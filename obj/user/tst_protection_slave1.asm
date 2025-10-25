
obj/user/tst_protection_slave1:     file format elf32-i386


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
  800031:	e8 02 01 00 00       	call   800138 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 58 4e 00 00    	sub    $0x4e58,%esp

	/*=================================================*/
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
#if USE_KHEAP
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  800041:	a1 20 30 80 00       	mov    0x803020,%eax
  800046:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
  80004c:	a1 20 30 80 00       	mov    0x803020,%eax
  800051:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800057:	39 c2                	cmp    %eax,%edx
  800059:	72 14                	jb     80006f <_main+0x37>
			panic("Please increase the WS size");
  80005b:	83 ec 04             	sub    $0x4,%esp
  80005e:	68 c0 1f 80 00       	push   $0x801fc0
  800063:	6a 12                	push   $0x12
  800065:	68 dc 1f 80 00       	push   $0x801fdc
  80006a:	e8 79 02 00 00       	call   8002e8 <_panic>
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	{
		char initname[10] = "x";
  80006f:	c7 45 e6 78 00 00 00 	movl   $0x78,-0x1a(%ebp)
  800076:	c7 45 ea 00 00 00 00 	movl   $0x0,-0x16(%ebp)
  80007d:	66 c7 45 ee 00 00    	movw   $0x0,-0x12(%ebp)
		char name[10] ;
#define NUM_OF_OBJS 5000
		uint32* vars[NUM_OF_OBJS];
		for (int s = 0; s < NUM_OF_OBJS; ++s)
  800083:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80008a:	eb 5d                	jmp    8000e9 <_main+0xb1>
		{
			char index[10];
			ltostr(s, index);
  80008c:	83 ec 08             	sub    $0x8,%esp
  80008f:	8d 45 d2             	lea    -0x2e(%ebp),%eax
  800092:	50                   	push   %eax
  800093:	ff 75 f4             	pushl  -0xc(%ebp)
  800096:	e8 49 11 00 00       	call   8011e4 <ltostr>
  80009b:	83 c4 10             	add    $0x10,%esp
			strcconcat(initname, index, name);
  80009e:	83 ec 04             	sub    $0x4,%esp
  8000a1:	8d 45 dc             	lea    -0x24(%ebp),%eax
  8000a4:	50                   	push   %eax
  8000a5:	8d 45 d2             	lea    -0x2e(%ebp),%eax
  8000a8:	50                   	push   %eax
  8000a9:	8d 45 e6             	lea    -0x1a(%ebp),%eax
  8000ac:	50                   	push   %eax
  8000ad:	e8 0b 12 00 00       	call   8012bd <strcconcat>
  8000b2:	83 c4 10             	add    $0x10,%esp
			vars[s] = smalloc(name, PAGE_SIZE, 1);
  8000b5:	83 ec 04             	sub    $0x4,%esp
  8000b8:	6a 01                	push   $0x1
  8000ba:	68 00 10 00 00       	push   $0x1000
  8000bf:	8d 45 dc             	lea    -0x24(%ebp),%eax
  8000c2:	50                   	push   %eax
  8000c3:	e8 f8 14 00 00       	call   8015c0 <smalloc>
  8000c8:	83 c4 10             	add    $0x10,%esp
  8000cb:	89 c2                	mov    %eax,%edx
  8000cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000d0:	89 94 85 b0 b1 ff ff 	mov    %edx,-0x4e50(%ebp,%eax,4)
			*vars[s] = s;
  8000d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000da:	8b 84 85 b0 b1 ff ff 	mov    -0x4e50(%ebp,%eax,4),%eax
  8000e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000e4:	89 10                	mov    %edx,(%eax)
	{
		char initname[10] = "x";
		char name[10] ;
#define NUM_OF_OBJS 5000
		uint32* vars[NUM_OF_OBJS];
		for (int s = 0; s < NUM_OF_OBJS; ++s)
  8000e6:	ff 45 f4             	incl   -0xc(%ebp)
  8000e9:	81 7d f4 87 13 00 00 	cmpl   $0x1387,-0xc(%ebp)
  8000f0:	7e 9a                	jle    80008c <_main+0x54>
			ltostr(s, index);
			strcconcat(initname, index, name);
			vars[s] = smalloc(name, PAGE_SIZE, 1);
			*vars[s] = s;
		}
		for (int s = 0; s < NUM_OF_OBJS; ++s)
  8000f2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8000f9:	eb 2c                	jmp    800127 <_main+0xef>
		{
			assert(*vars[s] == s);
  8000fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000fe:	8b 84 85 b0 b1 ff ff 	mov    -0x4e50(%ebp,%eax,4),%eax
  800105:	8b 10                	mov    (%eax),%edx
  800107:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80010a:	39 c2                	cmp    %eax,%edx
  80010c:	74 16                	je     800124 <_main+0xec>
  80010e:	68 f9 1f 80 00       	push   $0x801ff9
  800113:	68 07 20 80 00       	push   $0x802007
  800118:	6a 28                	push   $0x28
  80011a:	68 dc 1f 80 00       	push   $0x801fdc
  80011f:	e8 c4 01 00 00       	call   8002e8 <_panic>
			ltostr(s, index);
			strcconcat(initname, index, name);
			vars[s] = smalloc(name, PAGE_SIZE, 1);
			*vars[s] = s;
		}
		for (int s = 0; s < NUM_OF_OBJS; ++s)
  800124:	ff 45 f0             	incl   -0x10(%ebp)
  800127:	81 7d f0 87 13 00 00 	cmpl   $0x1387,-0x10(%ebp)
  80012e:	7e cb                	jle    8000fb <_main+0xc3>
		{
			assert(*vars[s] == s);
		}
	}

	inctst();
  800130:	e8 43 19 00 00       	call   801a78 <inctst>
}
  800135:	90                   	nop
  800136:	c9                   	leave  
  800137:	c3                   	ret    

00800138 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800138:	55                   	push   %ebp
  800139:	89 e5                	mov    %esp,%ebp
  80013b:	57                   	push   %edi
  80013c:	56                   	push   %esi
  80013d:	53                   	push   %ebx
  80013e:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800141:	e8 f4 17 00 00       	call   80193a <sys_getenvindex>
  800146:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800149:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80014c:	89 d0                	mov    %edx,%eax
  80014e:	c1 e0 02             	shl    $0x2,%eax
  800151:	01 d0                	add    %edx,%eax
  800153:	c1 e0 03             	shl    $0x3,%eax
  800156:	01 d0                	add    %edx,%eax
  800158:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80015f:	01 d0                	add    %edx,%eax
  800161:	c1 e0 02             	shl    $0x2,%eax
  800164:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800169:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80016e:	a1 20 30 80 00       	mov    0x803020,%eax
  800173:	8a 40 20             	mov    0x20(%eax),%al
  800176:	84 c0                	test   %al,%al
  800178:	74 0d                	je     800187 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  80017a:	a1 20 30 80 00       	mov    0x803020,%eax
  80017f:	83 c0 20             	add    $0x20,%eax
  800182:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800187:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80018b:	7e 0a                	jle    800197 <libmain+0x5f>
		binaryname = argv[0];
  80018d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800190:	8b 00                	mov    (%eax),%eax
  800192:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  800197:	83 ec 08             	sub    $0x8,%esp
  80019a:	ff 75 0c             	pushl  0xc(%ebp)
  80019d:	ff 75 08             	pushl  0x8(%ebp)
  8001a0:	e8 93 fe ff ff       	call   800038 <_main>
  8001a5:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8001a8:	a1 00 30 80 00       	mov    0x803000,%eax
  8001ad:	85 c0                	test   %eax,%eax
  8001af:	0f 84 01 01 00 00    	je     8002b6 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8001b5:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8001bb:	bb 14 21 80 00       	mov    $0x802114,%ebx
  8001c0:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001c5:	89 c7                	mov    %eax,%edi
  8001c7:	89 de                	mov    %ebx,%esi
  8001c9:	89 d1                	mov    %edx,%ecx
  8001cb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8001cd:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8001d0:	b9 56 00 00 00       	mov    $0x56,%ecx
  8001d5:	b0 00                	mov    $0x0,%al
  8001d7:	89 d7                	mov    %edx,%edi
  8001d9:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8001db:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8001e2:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8001e5:	83 ec 08             	sub    $0x8,%esp
  8001e8:	50                   	push   %eax
  8001e9:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8001ef:	50                   	push   %eax
  8001f0:	e8 7b 19 00 00       	call   801b70 <sys_utilities>
  8001f5:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8001f8:	e8 c4 14 00 00       	call   8016c1 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8001fd:	83 ec 0c             	sub    $0xc,%esp
  800200:	68 34 20 80 00       	push   $0x802034
  800205:	e8 ac 03 00 00       	call   8005b6 <cprintf>
  80020a:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80020d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800210:	85 c0                	test   %eax,%eax
  800212:	74 18                	je     80022c <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800214:	e8 75 19 00 00       	call   801b8e <sys_get_optimal_num_faults>
  800219:	83 ec 08             	sub    $0x8,%esp
  80021c:	50                   	push   %eax
  80021d:	68 5c 20 80 00       	push   $0x80205c
  800222:	e8 8f 03 00 00       	call   8005b6 <cprintf>
  800227:	83 c4 10             	add    $0x10,%esp
  80022a:	eb 59                	jmp    800285 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80022c:	a1 20 30 80 00       	mov    0x803020,%eax
  800231:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  800237:	a1 20 30 80 00       	mov    0x803020,%eax
  80023c:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  800242:	83 ec 04             	sub    $0x4,%esp
  800245:	52                   	push   %edx
  800246:	50                   	push   %eax
  800247:	68 80 20 80 00       	push   $0x802080
  80024c:	e8 65 03 00 00       	call   8005b6 <cprintf>
  800251:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800254:	a1 20 30 80 00       	mov    0x803020,%eax
  800259:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  80025f:	a1 20 30 80 00       	mov    0x803020,%eax
  800264:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  80026a:	a1 20 30 80 00       	mov    0x803020,%eax
  80026f:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  800275:	51                   	push   %ecx
  800276:	52                   	push   %edx
  800277:	50                   	push   %eax
  800278:	68 a8 20 80 00       	push   $0x8020a8
  80027d:	e8 34 03 00 00       	call   8005b6 <cprintf>
  800282:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800285:	a1 20 30 80 00       	mov    0x803020,%eax
  80028a:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  800290:	83 ec 08             	sub    $0x8,%esp
  800293:	50                   	push   %eax
  800294:	68 00 21 80 00       	push   $0x802100
  800299:	e8 18 03 00 00       	call   8005b6 <cprintf>
  80029e:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8002a1:	83 ec 0c             	sub    $0xc,%esp
  8002a4:	68 34 20 80 00       	push   $0x802034
  8002a9:	e8 08 03 00 00       	call   8005b6 <cprintf>
  8002ae:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8002b1:	e8 25 14 00 00       	call   8016db <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8002b6:	e8 1f 00 00 00       	call   8002da <exit>
}
  8002bb:	90                   	nop
  8002bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002bf:	5b                   	pop    %ebx
  8002c0:	5e                   	pop    %esi
  8002c1:	5f                   	pop    %edi
  8002c2:	5d                   	pop    %ebp
  8002c3:	c3                   	ret    

008002c4 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002c4:	55                   	push   %ebp
  8002c5:	89 e5                	mov    %esp,%ebp
  8002c7:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002ca:	83 ec 0c             	sub    $0xc,%esp
  8002cd:	6a 00                	push   $0x0
  8002cf:	e8 32 16 00 00       	call   801906 <sys_destroy_env>
  8002d4:	83 c4 10             	add    $0x10,%esp
}
  8002d7:	90                   	nop
  8002d8:	c9                   	leave  
  8002d9:	c3                   	ret    

008002da <exit>:

void
exit(void)
{
  8002da:	55                   	push   %ebp
  8002db:	89 e5                	mov    %esp,%ebp
  8002dd:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002e0:	e8 87 16 00 00       	call   80196c <sys_exit_env>
}
  8002e5:	90                   	nop
  8002e6:	c9                   	leave  
  8002e7:	c3                   	ret    

008002e8 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002e8:	55                   	push   %ebp
  8002e9:	89 e5                	mov    %esp,%ebp
  8002eb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002ee:	8d 45 10             	lea    0x10(%ebp),%eax
  8002f1:	83 c0 04             	add    $0x4,%eax
  8002f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002f7:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8002fc:	85 c0                	test   %eax,%eax
  8002fe:	74 16                	je     800316 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800300:	a1 18 b1 81 00       	mov    0x81b118,%eax
  800305:	83 ec 08             	sub    $0x8,%esp
  800308:	50                   	push   %eax
  800309:	68 78 21 80 00       	push   $0x802178
  80030e:	e8 a3 02 00 00       	call   8005b6 <cprintf>
  800313:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800316:	a1 04 30 80 00       	mov    0x803004,%eax
  80031b:	83 ec 0c             	sub    $0xc,%esp
  80031e:	ff 75 0c             	pushl  0xc(%ebp)
  800321:	ff 75 08             	pushl  0x8(%ebp)
  800324:	50                   	push   %eax
  800325:	68 80 21 80 00       	push   $0x802180
  80032a:	6a 74                	push   $0x74
  80032c:	e8 b2 02 00 00       	call   8005e3 <cprintf_colored>
  800331:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800334:	8b 45 10             	mov    0x10(%ebp),%eax
  800337:	83 ec 08             	sub    $0x8,%esp
  80033a:	ff 75 f4             	pushl  -0xc(%ebp)
  80033d:	50                   	push   %eax
  80033e:	e8 04 02 00 00       	call   800547 <vcprintf>
  800343:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800346:	83 ec 08             	sub    $0x8,%esp
  800349:	6a 00                	push   $0x0
  80034b:	68 a8 21 80 00       	push   $0x8021a8
  800350:	e8 f2 01 00 00       	call   800547 <vcprintf>
  800355:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800358:	e8 7d ff ff ff       	call   8002da <exit>

	// should not return here
	while (1) ;
  80035d:	eb fe                	jmp    80035d <_panic+0x75>

0080035f <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80035f:	55                   	push   %ebp
  800360:	89 e5                	mov    %esp,%ebp
  800362:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800365:	a1 20 30 80 00       	mov    0x803020,%eax
  80036a:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800370:	8b 45 0c             	mov    0xc(%ebp),%eax
  800373:	39 c2                	cmp    %eax,%edx
  800375:	74 14                	je     80038b <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800377:	83 ec 04             	sub    $0x4,%esp
  80037a:	68 ac 21 80 00       	push   $0x8021ac
  80037f:	6a 26                	push   $0x26
  800381:	68 f8 21 80 00       	push   $0x8021f8
  800386:	e8 5d ff ff ff       	call   8002e8 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80038b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800392:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800399:	e9 c5 00 00 00       	jmp    800463 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80039e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003a1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ab:	01 d0                	add    %edx,%eax
  8003ad:	8b 00                	mov    (%eax),%eax
  8003af:	85 c0                	test   %eax,%eax
  8003b1:	75 08                	jne    8003bb <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8003b3:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003b6:	e9 a5 00 00 00       	jmp    800460 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8003bb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003c2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003c9:	eb 69                	jmp    800434 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003cb:	a1 20 30 80 00       	mov    0x803020,%eax
  8003d0:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8003d6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003d9:	89 d0                	mov    %edx,%eax
  8003db:	01 c0                	add    %eax,%eax
  8003dd:	01 d0                	add    %edx,%eax
  8003df:	c1 e0 03             	shl    $0x3,%eax
  8003e2:	01 c8                	add    %ecx,%eax
  8003e4:	8a 40 04             	mov    0x4(%eax),%al
  8003e7:	84 c0                	test   %al,%al
  8003e9:	75 46                	jne    800431 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003eb:	a1 20 30 80 00       	mov    0x803020,%eax
  8003f0:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8003f6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003f9:	89 d0                	mov    %edx,%eax
  8003fb:	01 c0                	add    %eax,%eax
  8003fd:	01 d0                	add    %edx,%eax
  8003ff:	c1 e0 03             	shl    $0x3,%eax
  800402:	01 c8                	add    %ecx,%eax
  800404:	8b 00                	mov    (%eax),%eax
  800406:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800409:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80040c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800411:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800413:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800416:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80041d:	8b 45 08             	mov    0x8(%ebp),%eax
  800420:	01 c8                	add    %ecx,%eax
  800422:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800424:	39 c2                	cmp    %eax,%edx
  800426:	75 09                	jne    800431 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800428:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80042f:	eb 15                	jmp    800446 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800431:	ff 45 e8             	incl   -0x18(%ebp)
  800434:	a1 20 30 80 00       	mov    0x803020,%eax
  800439:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80043f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800442:	39 c2                	cmp    %eax,%edx
  800444:	77 85                	ja     8003cb <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800446:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80044a:	75 14                	jne    800460 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80044c:	83 ec 04             	sub    $0x4,%esp
  80044f:	68 04 22 80 00       	push   $0x802204
  800454:	6a 3a                	push   $0x3a
  800456:	68 f8 21 80 00       	push   $0x8021f8
  80045b:	e8 88 fe ff ff       	call   8002e8 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800460:	ff 45 f0             	incl   -0x10(%ebp)
  800463:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800466:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800469:	0f 8c 2f ff ff ff    	jl     80039e <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80046f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800476:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80047d:	eb 26                	jmp    8004a5 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80047f:	a1 20 30 80 00       	mov    0x803020,%eax
  800484:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80048a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80048d:	89 d0                	mov    %edx,%eax
  80048f:	01 c0                	add    %eax,%eax
  800491:	01 d0                	add    %edx,%eax
  800493:	c1 e0 03             	shl    $0x3,%eax
  800496:	01 c8                	add    %ecx,%eax
  800498:	8a 40 04             	mov    0x4(%eax),%al
  80049b:	3c 01                	cmp    $0x1,%al
  80049d:	75 03                	jne    8004a2 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80049f:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004a2:	ff 45 e0             	incl   -0x20(%ebp)
  8004a5:	a1 20 30 80 00       	mov    0x803020,%eax
  8004aa:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004b3:	39 c2                	cmp    %eax,%edx
  8004b5:	77 c8                	ja     80047f <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004ba:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004bd:	74 14                	je     8004d3 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8004bf:	83 ec 04             	sub    $0x4,%esp
  8004c2:	68 58 22 80 00       	push   $0x802258
  8004c7:	6a 44                	push   $0x44
  8004c9:	68 f8 21 80 00       	push   $0x8021f8
  8004ce:	e8 15 fe ff ff       	call   8002e8 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004d3:	90                   	nop
  8004d4:	c9                   	leave  
  8004d5:	c3                   	ret    

008004d6 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8004d6:	55                   	push   %ebp
  8004d7:	89 e5                	mov    %esp,%ebp
  8004d9:	53                   	push   %ebx
  8004da:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8004dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e0:	8b 00                	mov    (%eax),%eax
  8004e2:	8d 48 01             	lea    0x1(%eax),%ecx
  8004e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004e8:	89 0a                	mov    %ecx,(%edx)
  8004ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8004ed:	88 d1                	mov    %dl,%cl
  8004ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004f2:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f9:	8b 00                	mov    (%eax),%eax
  8004fb:	3d ff 00 00 00       	cmp    $0xff,%eax
  800500:	75 30                	jne    800532 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800502:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  800508:	a0 44 30 80 00       	mov    0x803044,%al
  80050d:	0f b6 c0             	movzbl %al,%eax
  800510:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800513:	8b 09                	mov    (%ecx),%ecx
  800515:	89 cb                	mov    %ecx,%ebx
  800517:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80051a:	83 c1 08             	add    $0x8,%ecx
  80051d:	52                   	push   %edx
  80051e:	50                   	push   %eax
  80051f:	53                   	push   %ebx
  800520:	51                   	push   %ecx
  800521:	e8 57 11 00 00       	call   80167d <sys_cputs>
  800526:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800529:	8b 45 0c             	mov    0xc(%ebp),%eax
  80052c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800532:	8b 45 0c             	mov    0xc(%ebp),%eax
  800535:	8b 40 04             	mov    0x4(%eax),%eax
  800538:	8d 50 01             	lea    0x1(%eax),%edx
  80053b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80053e:	89 50 04             	mov    %edx,0x4(%eax)
}
  800541:	90                   	nop
  800542:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800545:	c9                   	leave  
  800546:	c3                   	ret    

00800547 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800547:	55                   	push   %ebp
  800548:	89 e5                	mov    %esp,%ebp
  80054a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800550:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800557:	00 00 00 
	b.cnt = 0;
  80055a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800561:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800564:	ff 75 0c             	pushl  0xc(%ebp)
  800567:	ff 75 08             	pushl  0x8(%ebp)
  80056a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800570:	50                   	push   %eax
  800571:	68 d6 04 80 00       	push   $0x8004d6
  800576:	e8 5a 02 00 00       	call   8007d5 <vprintfmt>
  80057b:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  80057e:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  800584:	a0 44 30 80 00       	mov    0x803044,%al
  800589:	0f b6 c0             	movzbl %al,%eax
  80058c:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800592:	52                   	push   %edx
  800593:	50                   	push   %eax
  800594:	51                   	push   %ecx
  800595:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80059b:	83 c0 08             	add    $0x8,%eax
  80059e:	50                   	push   %eax
  80059f:	e8 d9 10 00 00       	call   80167d <sys_cputs>
  8005a4:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8005a7:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  8005ae:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005b4:	c9                   	leave  
  8005b5:	c3                   	ret    

008005b6 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8005b6:	55                   	push   %ebp
  8005b7:	89 e5                	mov    %esp,%ebp
  8005b9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005bc:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  8005c3:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8005cc:	83 ec 08             	sub    $0x8,%esp
  8005cf:	ff 75 f4             	pushl  -0xc(%ebp)
  8005d2:	50                   	push   %eax
  8005d3:	e8 6f ff ff ff       	call   800547 <vcprintf>
  8005d8:	83 c4 10             	add    $0x10,%esp
  8005db:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005de:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005e1:	c9                   	leave  
  8005e2:	c3                   	ret    

008005e3 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8005e3:	55                   	push   %ebp
  8005e4:	89 e5                	mov    %esp,%ebp
  8005e6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005e9:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  8005f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f3:	c1 e0 08             	shl    $0x8,%eax
  8005f6:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  8005fb:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005fe:	83 c0 04             	add    $0x4,%eax
  800601:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800604:	8b 45 0c             	mov    0xc(%ebp),%eax
  800607:	83 ec 08             	sub    $0x8,%esp
  80060a:	ff 75 f4             	pushl  -0xc(%ebp)
  80060d:	50                   	push   %eax
  80060e:	e8 34 ff ff ff       	call   800547 <vcprintf>
  800613:	83 c4 10             	add    $0x10,%esp
  800616:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800619:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  800620:	07 00 00 

	return cnt;
  800623:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800626:	c9                   	leave  
  800627:	c3                   	ret    

00800628 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800628:	55                   	push   %ebp
  800629:	89 e5                	mov    %esp,%ebp
  80062b:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80062e:	e8 8e 10 00 00       	call   8016c1 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800633:	8d 45 0c             	lea    0xc(%ebp),%eax
  800636:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800639:	8b 45 08             	mov    0x8(%ebp),%eax
  80063c:	83 ec 08             	sub    $0x8,%esp
  80063f:	ff 75 f4             	pushl  -0xc(%ebp)
  800642:	50                   	push   %eax
  800643:	e8 ff fe ff ff       	call   800547 <vcprintf>
  800648:	83 c4 10             	add    $0x10,%esp
  80064b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80064e:	e8 88 10 00 00       	call   8016db <sys_unlock_cons>
	return cnt;
  800653:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800656:	c9                   	leave  
  800657:	c3                   	ret    

00800658 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800658:	55                   	push   %ebp
  800659:	89 e5                	mov    %esp,%ebp
  80065b:	53                   	push   %ebx
  80065c:	83 ec 14             	sub    $0x14,%esp
  80065f:	8b 45 10             	mov    0x10(%ebp),%eax
  800662:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800665:	8b 45 14             	mov    0x14(%ebp),%eax
  800668:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80066b:	8b 45 18             	mov    0x18(%ebp),%eax
  80066e:	ba 00 00 00 00       	mov    $0x0,%edx
  800673:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800676:	77 55                	ja     8006cd <printnum+0x75>
  800678:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80067b:	72 05                	jb     800682 <printnum+0x2a>
  80067d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800680:	77 4b                	ja     8006cd <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800682:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800685:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800688:	8b 45 18             	mov    0x18(%ebp),%eax
  80068b:	ba 00 00 00 00       	mov    $0x0,%edx
  800690:	52                   	push   %edx
  800691:	50                   	push   %eax
  800692:	ff 75 f4             	pushl  -0xc(%ebp)
  800695:	ff 75 f0             	pushl  -0x10(%ebp)
  800698:	e8 a7 16 00 00       	call   801d44 <__udivdi3>
  80069d:	83 c4 10             	add    $0x10,%esp
  8006a0:	83 ec 04             	sub    $0x4,%esp
  8006a3:	ff 75 20             	pushl  0x20(%ebp)
  8006a6:	53                   	push   %ebx
  8006a7:	ff 75 18             	pushl  0x18(%ebp)
  8006aa:	52                   	push   %edx
  8006ab:	50                   	push   %eax
  8006ac:	ff 75 0c             	pushl  0xc(%ebp)
  8006af:	ff 75 08             	pushl  0x8(%ebp)
  8006b2:	e8 a1 ff ff ff       	call   800658 <printnum>
  8006b7:	83 c4 20             	add    $0x20,%esp
  8006ba:	eb 1a                	jmp    8006d6 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006bc:	83 ec 08             	sub    $0x8,%esp
  8006bf:	ff 75 0c             	pushl  0xc(%ebp)
  8006c2:	ff 75 20             	pushl  0x20(%ebp)
  8006c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c8:	ff d0                	call   *%eax
  8006ca:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006cd:	ff 4d 1c             	decl   0x1c(%ebp)
  8006d0:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006d4:	7f e6                	jg     8006bc <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006d6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006d9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006e4:	53                   	push   %ebx
  8006e5:	51                   	push   %ecx
  8006e6:	52                   	push   %edx
  8006e7:	50                   	push   %eax
  8006e8:	e8 67 17 00 00       	call   801e54 <__umoddi3>
  8006ed:	83 c4 10             	add    $0x10,%esp
  8006f0:	05 d4 24 80 00       	add    $0x8024d4,%eax
  8006f5:	8a 00                	mov    (%eax),%al
  8006f7:	0f be c0             	movsbl %al,%eax
  8006fa:	83 ec 08             	sub    $0x8,%esp
  8006fd:	ff 75 0c             	pushl  0xc(%ebp)
  800700:	50                   	push   %eax
  800701:	8b 45 08             	mov    0x8(%ebp),%eax
  800704:	ff d0                	call   *%eax
  800706:	83 c4 10             	add    $0x10,%esp
}
  800709:	90                   	nop
  80070a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80070d:	c9                   	leave  
  80070e:	c3                   	ret    

0080070f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80070f:	55                   	push   %ebp
  800710:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800712:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800716:	7e 1c                	jle    800734 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800718:	8b 45 08             	mov    0x8(%ebp),%eax
  80071b:	8b 00                	mov    (%eax),%eax
  80071d:	8d 50 08             	lea    0x8(%eax),%edx
  800720:	8b 45 08             	mov    0x8(%ebp),%eax
  800723:	89 10                	mov    %edx,(%eax)
  800725:	8b 45 08             	mov    0x8(%ebp),%eax
  800728:	8b 00                	mov    (%eax),%eax
  80072a:	83 e8 08             	sub    $0x8,%eax
  80072d:	8b 50 04             	mov    0x4(%eax),%edx
  800730:	8b 00                	mov    (%eax),%eax
  800732:	eb 40                	jmp    800774 <getuint+0x65>
	else if (lflag)
  800734:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800738:	74 1e                	je     800758 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80073a:	8b 45 08             	mov    0x8(%ebp),%eax
  80073d:	8b 00                	mov    (%eax),%eax
  80073f:	8d 50 04             	lea    0x4(%eax),%edx
  800742:	8b 45 08             	mov    0x8(%ebp),%eax
  800745:	89 10                	mov    %edx,(%eax)
  800747:	8b 45 08             	mov    0x8(%ebp),%eax
  80074a:	8b 00                	mov    (%eax),%eax
  80074c:	83 e8 04             	sub    $0x4,%eax
  80074f:	8b 00                	mov    (%eax),%eax
  800751:	ba 00 00 00 00       	mov    $0x0,%edx
  800756:	eb 1c                	jmp    800774 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800758:	8b 45 08             	mov    0x8(%ebp),%eax
  80075b:	8b 00                	mov    (%eax),%eax
  80075d:	8d 50 04             	lea    0x4(%eax),%edx
  800760:	8b 45 08             	mov    0x8(%ebp),%eax
  800763:	89 10                	mov    %edx,(%eax)
  800765:	8b 45 08             	mov    0x8(%ebp),%eax
  800768:	8b 00                	mov    (%eax),%eax
  80076a:	83 e8 04             	sub    $0x4,%eax
  80076d:	8b 00                	mov    (%eax),%eax
  80076f:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800774:	5d                   	pop    %ebp
  800775:	c3                   	ret    

00800776 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800776:	55                   	push   %ebp
  800777:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800779:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80077d:	7e 1c                	jle    80079b <getint+0x25>
		return va_arg(*ap, long long);
  80077f:	8b 45 08             	mov    0x8(%ebp),%eax
  800782:	8b 00                	mov    (%eax),%eax
  800784:	8d 50 08             	lea    0x8(%eax),%edx
  800787:	8b 45 08             	mov    0x8(%ebp),%eax
  80078a:	89 10                	mov    %edx,(%eax)
  80078c:	8b 45 08             	mov    0x8(%ebp),%eax
  80078f:	8b 00                	mov    (%eax),%eax
  800791:	83 e8 08             	sub    $0x8,%eax
  800794:	8b 50 04             	mov    0x4(%eax),%edx
  800797:	8b 00                	mov    (%eax),%eax
  800799:	eb 38                	jmp    8007d3 <getint+0x5d>
	else if (lflag)
  80079b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80079f:	74 1a                	je     8007bb <getint+0x45>
		return va_arg(*ap, long);
  8007a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a4:	8b 00                	mov    (%eax),%eax
  8007a6:	8d 50 04             	lea    0x4(%eax),%edx
  8007a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ac:	89 10                	mov    %edx,(%eax)
  8007ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b1:	8b 00                	mov    (%eax),%eax
  8007b3:	83 e8 04             	sub    $0x4,%eax
  8007b6:	8b 00                	mov    (%eax),%eax
  8007b8:	99                   	cltd   
  8007b9:	eb 18                	jmp    8007d3 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8007bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007be:	8b 00                	mov    (%eax),%eax
  8007c0:	8d 50 04             	lea    0x4(%eax),%edx
  8007c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c6:	89 10                	mov    %edx,(%eax)
  8007c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cb:	8b 00                	mov    (%eax),%eax
  8007cd:	83 e8 04             	sub    $0x4,%eax
  8007d0:	8b 00                	mov    (%eax),%eax
  8007d2:	99                   	cltd   
}
  8007d3:	5d                   	pop    %ebp
  8007d4:	c3                   	ret    

008007d5 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007d5:	55                   	push   %ebp
  8007d6:	89 e5                	mov    %esp,%ebp
  8007d8:	56                   	push   %esi
  8007d9:	53                   	push   %ebx
  8007da:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007dd:	eb 17                	jmp    8007f6 <vprintfmt+0x21>
			if (ch == '\0')
  8007df:	85 db                	test   %ebx,%ebx
  8007e1:	0f 84 c1 03 00 00    	je     800ba8 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8007e7:	83 ec 08             	sub    $0x8,%esp
  8007ea:	ff 75 0c             	pushl  0xc(%ebp)
  8007ed:	53                   	push   %ebx
  8007ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f1:	ff d0                	call   *%eax
  8007f3:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8007f9:	8d 50 01             	lea    0x1(%eax),%edx
  8007fc:	89 55 10             	mov    %edx,0x10(%ebp)
  8007ff:	8a 00                	mov    (%eax),%al
  800801:	0f b6 d8             	movzbl %al,%ebx
  800804:	83 fb 25             	cmp    $0x25,%ebx
  800807:	75 d6                	jne    8007df <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800809:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80080d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800814:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80081b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800822:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800829:	8b 45 10             	mov    0x10(%ebp),%eax
  80082c:	8d 50 01             	lea    0x1(%eax),%edx
  80082f:	89 55 10             	mov    %edx,0x10(%ebp)
  800832:	8a 00                	mov    (%eax),%al
  800834:	0f b6 d8             	movzbl %al,%ebx
  800837:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80083a:	83 f8 5b             	cmp    $0x5b,%eax
  80083d:	0f 87 3d 03 00 00    	ja     800b80 <vprintfmt+0x3ab>
  800843:	8b 04 85 f8 24 80 00 	mov    0x8024f8(,%eax,4),%eax
  80084a:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80084c:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800850:	eb d7                	jmp    800829 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800852:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800856:	eb d1                	jmp    800829 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800858:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80085f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800862:	89 d0                	mov    %edx,%eax
  800864:	c1 e0 02             	shl    $0x2,%eax
  800867:	01 d0                	add    %edx,%eax
  800869:	01 c0                	add    %eax,%eax
  80086b:	01 d8                	add    %ebx,%eax
  80086d:	83 e8 30             	sub    $0x30,%eax
  800870:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800873:	8b 45 10             	mov    0x10(%ebp),%eax
  800876:	8a 00                	mov    (%eax),%al
  800878:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80087b:	83 fb 2f             	cmp    $0x2f,%ebx
  80087e:	7e 3e                	jle    8008be <vprintfmt+0xe9>
  800880:	83 fb 39             	cmp    $0x39,%ebx
  800883:	7f 39                	jg     8008be <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800885:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800888:	eb d5                	jmp    80085f <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80088a:	8b 45 14             	mov    0x14(%ebp),%eax
  80088d:	83 c0 04             	add    $0x4,%eax
  800890:	89 45 14             	mov    %eax,0x14(%ebp)
  800893:	8b 45 14             	mov    0x14(%ebp),%eax
  800896:	83 e8 04             	sub    $0x4,%eax
  800899:	8b 00                	mov    (%eax),%eax
  80089b:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80089e:	eb 1f                	jmp    8008bf <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008a0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008a4:	79 83                	jns    800829 <vprintfmt+0x54>
				width = 0;
  8008a6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8008ad:	e9 77 ff ff ff       	jmp    800829 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008b2:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008b9:	e9 6b ff ff ff       	jmp    800829 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008be:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008bf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008c3:	0f 89 60 ff ff ff    	jns    800829 <vprintfmt+0x54>
				width = precision, precision = -1;
  8008c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008cf:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008d6:	e9 4e ff ff ff       	jmp    800829 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008db:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8008de:	e9 46 ff ff ff       	jmp    800829 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e6:	83 c0 04             	add    $0x4,%eax
  8008e9:	89 45 14             	mov    %eax,0x14(%ebp)
  8008ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ef:	83 e8 04             	sub    $0x4,%eax
  8008f2:	8b 00                	mov    (%eax),%eax
  8008f4:	83 ec 08             	sub    $0x8,%esp
  8008f7:	ff 75 0c             	pushl  0xc(%ebp)
  8008fa:	50                   	push   %eax
  8008fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fe:	ff d0                	call   *%eax
  800900:	83 c4 10             	add    $0x10,%esp
			break;
  800903:	e9 9b 02 00 00       	jmp    800ba3 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800908:	8b 45 14             	mov    0x14(%ebp),%eax
  80090b:	83 c0 04             	add    $0x4,%eax
  80090e:	89 45 14             	mov    %eax,0x14(%ebp)
  800911:	8b 45 14             	mov    0x14(%ebp),%eax
  800914:	83 e8 04             	sub    $0x4,%eax
  800917:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800919:	85 db                	test   %ebx,%ebx
  80091b:	79 02                	jns    80091f <vprintfmt+0x14a>
				err = -err;
  80091d:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80091f:	83 fb 64             	cmp    $0x64,%ebx
  800922:	7f 0b                	jg     80092f <vprintfmt+0x15a>
  800924:	8b 34 9d 40 23 80 00 	mov    0x802340(,%ebx,4),%esi
  80092b:	85 f6                	test   %esi,%esi
  80092d:	75 19                	jne    800948 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80092f:	53                   	push   %ebx
  800930:	68 e5 24 80 00       	push   $0x8024e5
  800935:	ff 75 0c             	pushl  0xc(%ebp)
  800938:	ff 75 08             	pushl  0x8(%ebp)
  80093b:	e8 70 02 00 00       	call   800bb0 <printfmt>
  800940:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800943:	e9 5b 02 00 00       	jmp    800ba3 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800948:	56                   	push   %esi
  800949:	68 ee 24 80 00       	push   $0x8024ee
  80094e:	ff 75 0c             	pushl  0xc(%ebp)
  800951:	ff 75 08             	pushl  0x8(%ebp)
  800954:	e8 57 02 00 00       	call   800bb0 <printfmt>
  800959:	83 c4 10             	add    $0x10,%esp
			break;
  80095c:	e9 42 02 00 00       	jmp    800ba3 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800961:	8b 45 14             	mov    0x14(%ebp),%eax
  800964:	83 c0 04             	add    $0x4,%eax
  800967:	89 45 14             	mov    %eax,0x14(%ebp)
  80096a:	8b 45 14             	mov    0x14(%ebp),%eax
  80096d:	83 e8 04             	sub    $0x4,%eax
  800970:	8b 30                	mov    (%eax),%esi
  800972:	85 f6                	test   %esi,%esi
  800974:	75 05                	jne    80097b <vprintfmt+0x1a6>
				p = "(null)";
  800976:	be f1 24 80 00       	mov    $0x8024f1,%esi
			if (width > 0 && padc != '-')
  80097b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80097f:	7e 6d                	jle    8009ee <vprintfmt+0x219>
  800981:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800985:	74 67                	je     8009ee <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800987:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80098a:	83 ec 08             	sub    $0x8,%esp
  80098d:	50                   	push   %eax
  80098e:	56                   	push   %esi
  80098f:	e8 1e 03 00 00       	call   800cb2 <strnlen>
  800994:	83 c4 10             	add    $0x10,%esp
  800997:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80099a:	eb 16                	jmp    8009b2 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80099c:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009a0:	83 ec 08             	sub    $0x8,%esp
  8009a3:	ff 75 0c             	pushl  0xc(%ebp)
  8009a6:	50                   	push   %eax
  8009a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009aa:	ff d0                	call   *%eax
  8009ac:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009af:	ff 4d e4             	decl   -0x1c(%ebp)
  8009b2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009b6:	7f e4                	jg     80099c <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009b8:	eb 34                	jmp    8009ee <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8009ba:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009be:	74 1c                	je     8009dc <vprintfmt+0x207>
  8009c0:	83 fb 1f             	cmp    $0x1f,%ebx
  8009c3:	7e 05                	jle    8009ca <vprintfmt+0x1f5>
  8009c5:	83 fb 7e             	cmp    $0x7e,%ebx
  8009c8:	7e 12                	jle    8009dc <vprintfmt+0x207>
					putch('?', putdat);
  8009ca:	83 ec 08             	sub    $0x8,%esp
  8009cd:	ff 75 0c             	pushl  0xc(%ebp)
  8009d0:	6a 3f                	push   $0x3f
  8009d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d5:	ff d0                	call   *%eax
  8009d7:	83 c4 10             	add    $0x10,%esp
  8009da:	eb 0f                	jmp    8009eb <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009dc:	83 ec 08             	sub    $0x8,%esp
  8009df:	ff 75 0c             	pushl  0xc(%ebp)
  8009e2:	53                   	push   %ebx
  8009e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e6:	ff d0                	call   *%eax
  8009e8:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009eb:	ff 4d e4             	decl   -0x1c(%ebp)
  8009ee:	89 f0                	mov    %esi,%eax
  8009f0:	8d 70 01             	lea    0x1(%eax),%esi
  8009f3:	8a 00                	mov    (%eax),%al
  8009f5:	0f be d8             	movsbl %al,%ebx
  8009f8:	85 db                	test   %ebx,%ebx
  8009fa:	74 24                	je     800a20 <vprintfmt+0x24b>
  8009fc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a00:	78 b8                	js     8009ba <vprintfmt+0x1e5>
  800a02:	ff 4d e0             	decl   -0x20(%ebp)
  800a05:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a09:	79 af                	jns    8009ba <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a0b:	eb 13                	jmp    800a20 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a0d:	83 ec 08             	sub    $0x8,%esp
  800a10:	ff 75 0c             	pushl  0xc(%ebp)
  800a13:	6a 20                	push   $0x20
  800a15:	8b 45 08             	mov    0x8(%ebp),%eax
  800a18:	ff d0                	call   *%eax
  800a1a:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a1d:	ff 4d e4             	decl   -0x1c(%ebp)
  800a20:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a24:	7f e7                	jg     800a0d <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a26:	e9 78 01 00 00       	jmp    800ba3 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a2b:	83 ec 08             	sub    $0x8,%esp
  800a2e:	ff 75 e8             	pushl  -0x18(%ebp)
  800a31:	8d 45 14             	lea    0x14(%ebp),%eax
  800a34:	50                   	push   %eax
  800a35:	e8 3c fd ff ff       	call   800776 <getint>
  800a3a:	83 c4 10             	add    $0x10,%esp
  800a3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a40:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a46:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a49:	85 d2                	test   %edx,%edx
  800a4b:	79 23                	jns    800a70 <vprintfmt+0x29b>
				putch('-', putdat);
  800a4d:	83 ec 08             	sub    $0x8,%esp
  800a50:	ff 75 0c             	pushl  0xc(%ebp)
  800a53:	6a 2d                	push   $0x2d
  800a55:	8b 45 08             	mov    0x8(%ebp),%eax
  800a58:	ff d0                	call   *%eax
  800a5a:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a60:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a63:	f7 d8                	neg    %eax
  800a65:	83 d2 00             	adc    $0x0,%edx
  800a68:	f7 da                	neg    %edx
  800a6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a6d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a70:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a77:	e9 bc 00 00 00       	jmp    800b38 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a7c:	83 ec 08             	sub    $0x8,%esp
  800a7f:	ff 75 e8             	pushl  -0x18(%ebp)
  800a82:	8d 45 14             	lea    0x14(%ebp),%eax
  800a85:	50                   	push   %eax
  800a86:	e8 84 fc ff ff       	call   80070f <getuint>
  800a8b:	83 c4 10             	add    $0x10,%esp
  800a8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a91:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a94:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a9b:	e9 98 00 00 00       	jmp    800b38 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800aa0:	83 ec 08             	sub    $0x8,%esp
  800aa3:	ff 75 0c             	pushl  0xc(%ebp)
  800aa6:	6a 58                	push   $0x58
  800aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  800aab:	ff d0                	call   *%eax
  800aad:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ab0:	83 ec 08             	sub    $0x8,%esp
  800ab3:	ff 75 0c             	pushl  0xc(%ebp)
  800ab6:	6a 58                	push   $0x58
  800ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  800abb:	ff d0                	call   *%eax
  800abd:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ac0:	83 ec 08             	sub    $0x8,%esp
  800ac3:	ff 75 0c             	pushl  0xc(%ebp)
  800ac6:	6a 58                	push   $0x58
  800ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  800acb:	ff d0                	call   *%eax
  800acd:	83 c4 10             	add    $0x10,%esp
			break;
  800ad0:	e9 ce 00 00 00       	jmp    800ba3 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800ad5:	83 ec 08             	sub    $0x8,%esp
  800ad8:	ff 75 0c             	pushl  0xc(%ebp)
  800adb:	6a 30                	push   $0x30
  800add:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae0:	ff d0                	call   *%eax
  800ae2:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ae5:	83 ec 08             	sub    $0x8,%esp
  800ae8:	ff 75 0c             	pushl  0xc(%ebp)
  800aeb:	6a 78                	push   $0x78
  800aed:	8b 45 08             	mov    0x8(%ebp),%eax
  800af0:	ff d0                	call   *%eax
  800af2:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800af5:	8b 45 14             	mov    0x14(%ebp),%eax
  800af8:	83 c0 04             	add    $0x4,%eax
  800afb:	89 45 14             	mov    %eax,0x14(%ebp)
  800afe:	8b 45 14             	mov    0x14(%ebp),%eax
  800b01:	83 e8 04             	sub    $0x4,%eax
  800b04:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b06:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b09:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b10:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b17:	eb 1f                	jmp    800b38 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b19:	83 ec 08             	sub    $0x8,%esp
  800b1c:	ff 75 e8             	pushl  -0x18(%ebp)
  800b1f:	8d 45 14             	lea    0x14(%ebp),%eax
  800b22:	50                   	push   %eax
  800b23:	e8 e7 fb ff ff       	call   80070f <getuint>
  800b28:	83 c4 10             	add    $0x10,%esp
  800b2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b2e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b31:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b38:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b3f:	83 ec 04             	sub    $0x4,%esp
  800b42:	52                   	push   %edx
  800b43:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b46:	50                   	push   %eax
  800b47:	ff 75 f4             	pushl  -0xc(%ebp)
  800b4a:	ff 75 f0             	pushl  -0x10(%ebp)
  800b4d:	ff 75 0c             	pushl  0xc(%ebp)
  800b50:	ff 75 08             	pushl  0x8(%ebp)
  800b53:	e8 00 fb ff ff       	call   800658 <printnum>
  800b58:	83 c4 20             	add    $0x20,%esp
			break;
  800b5b:	eb 46                	jmp    800ba3 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b5d:	83 ec 08             	sub    $0x8,%esp
  800b60:	ff 75 0c             	pushl  0xc(%ebp)
  800b63:	53                   	push   %ebx
  800b64:	8b 45 08             	mov    0x8(%ebp),%eax
  800b67:	ff d0                	call   *%eax
  800b69:	83 c4 10             	add    $0x10,%esp
			break;
  800b6c:	eb 35                	jmp    800ba3 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800b6e:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800b75:	eb 2c                	jmp    800ba3 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800b77:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800b7e:	eb 23                	jmp    800ba3 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b80:	83 ec 08             	sub    $0x8,%esp
  800b83:	ff 75 0c             	pushl  0xc(%ebp)
  800b86:	6a 25                	push   $0x25
  800b88:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8b:	ff d0                	call   *%eax
  800b8d:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b90:	ff 4d 10             	decl   0x10(%ebp)
  800b93:	eb 03                	jmp    800b98 <vprintfmt+0x3c3>
  800b95:	ff 4d 10             	decl   0x10(%ebp)
  800b98:	8b 45 10             	mov    0x10(%ebp),%eax
  800b9b:	48                   	dec    %eax
  800b9c:	8a 00                	mov    (%eax),%al
  800b9e:	3c 25                	cmp    $0x25,%al
  800ba0:	75 f3                	jne    800b95 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800ba2:	90                   	nop
		}
	}
  800ba3:	e9 35 fc ff ff       	jmp    8007dd <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ba8:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ba9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bac:	5b                   	pop    %ebx
  800bad:	5e                   	pop    %esi
  800bae:	5d                   	pop    %ebp
  800baf:	c3                   	ret    

00800bb0 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bb0:	55                   	push   %ebp
  800bb1:	89 e5                	mov    %esp,%ebp
  800bb3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800bb6:	8d 45 10             	lea    0x10(%ebp),%eax
  800bb9:	83 c0 04             	add    $0x4,%eax
  800bbc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800bbf:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc2:	ff 75 f4             	pushl  -0xc(%ebp)
  800bc5:	50                   	push   %eax
  800bc6:	ff 75 0c             	pushl  0xc(%ebp)
  800bc9:	ff 75 08             	pushl  0x8(%ebp)
  800bcc:	e8 04 fc ff ff       	call   8007d5 <vprintfmt>
  800bd1:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800bd4:	90                   	nop
  800bd5:	c9                   	leave  
  800bd6:	c3                   	ret    

00800bd7 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bd7:	55                   	push   %ebp
  800bd8:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800bda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bdd:	8b 40 08             	mov    0x8(%eax),%eax
  800be0:	8d 50 01             	lea    0x1(%eax),%edx
  800be3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be6:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800be9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bec:	8b 10                	mov    (%eax),%edx
  800bee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf1:	8b 40 04             	mov    0x4(%eax),%eax
  800bf4:	39 c2                	cmp    %eax,%edx
  800bf6:	73 12                	jae    800c0a <sprintputch+0x33>
		*b->buf++ = ch;
  800bf8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bfb:	8b 00                	mov    (%eax),%eax
  800bfd:	8d 48 01             	lea    0x1(%eax),%ecx
  800c00:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c03:	89 0a                	mov    %ecx,(%edx)
  800c05:	8b 55 08             	mov    0x8(%ebp),%edx
  800c08:	88 10                	mov    %dl,(%eax)
}
  800c0a:	90                   	nop
  800c0b:	5d                   	pop    %ebp
  800c0c:	c3                   	ret    

00800c0d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c0d:	55                   	push   %ebp
  800c0e:	89 e5                	mov    %esp,%ebp
  800c10:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c13:	8b 45 08             	mov    0x8(%ebp),%eax
  800c16:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c19:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c1c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c22:	01 d0                	add    %edx,%eax
  800c24:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c27:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c2e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c32:	74 06                	je     800c3a <vsnprintf+0x2d>
  800c34:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c38:	7f 07                	jg     800c41 <vsnprintf+0x34>
		return -E_INVAL;
  800c3a:	b8 03 00 00 00       	mov    $0x3,%eax
  800c3f:	eb 20                	jmp    800c61 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c41:	ff 75 14             	pushl  0x14(%ebp)
  800c44:	ff 75 10             	pushl  0x10(%ebp)
  800c47:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c4a:	50                   	push   %eax
  800c4b:	68 d7 0b 80 00       	push   $0x800bd7
  800c50:	e8 80 fb ff ff       	call   8007d5 <vprintfmt>
  800c55:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c58:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c5b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c61:	c9                   	leave  
  800c62:	c3                   	ret    

00800c63 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c63:	55                   	push   %ebp
  800c64:	89 e5                	mov    %esp,%ebp
  800c66:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c69:	8d 45 10             	lea    0x10(%ebp),%eax
  800c6c:	83 c0 04             	add    $0x4,%eax
  800c6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c72:	8b 45 10             	mov    0x10(%ebp),%eax
  800c75:	ff 75 f4             	pushl  -0xc(%ebp)
  800c78:	50                   	push   %eax
  800c79:	ff 75 0c             	pushl  0xc(%ebp)
  800c7c:	ff 75 08             	pushl  0x8(%ebp)
  800c7f:	e8 89 ff ff ff       	call   800c0d <vsnprintf>
  800c84:	83 c4 10             	add    $0x10,%esp
  800c87:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c8d:	c9                   	leave  
  800c8e:	c3                   	ret    

00800c8f <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c8f:	55                   	push   %ebp
  800c90:	89 e5                	mov    %esp,%ebp
  800c92:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c95:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c9c:	eb 06                	jmp    800ca4 <strlen+0x15>
		n++;
  800c9e:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ca1:	ff 45 08             	incl   0x8(%ebp)
  800ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca7:	8a 00                	mov    (%eax),%al
  800ca9:	84 c0                	test   %al,%al
  800cab:	75 f1                	jne    800c9e <strlen+0xf>
		n++;
	return n;
  800cad:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cb0:	c9                   	leave  
  800cb1:	c3                   	ret    

00800cb2 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800cb2:	55                   	push   %ebp
  800cb3:	89 e5                	mov    %esp,%ebp
  800cb5:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cb8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cbf:	eb 09                	jmp    800cca <strnlen+0x18>
		n++;
  800cc1:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cc4:	ff 45 08             	incl   0x8(%ebp)
  800cc7:	ff 4d 0c             	decl   0xc(%ebp)
  800cca:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cce:	74 09                	je     800cd9 <strnlen+0x27>
  800cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd3:	8a 00                	mov    (%eax),%al
  800cd5:	84 c0                	test   %al,%al
  800cd7:	75 e8                	jne    800cc1 <strnlen+0xf>
		n++;
	return n;
  800cd9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cdc:	c9                   	leave  
  800cdd:	c3                   	ret    

00800cde <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cde:	55                   	push   %ebp
  800cdf:	89 e5                	mov    %esp,%ebp
  800ce1:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800cea:	90                   	nop
  800ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cee:	8d 50 01             	lea    0x1(%eax),%edx
  800cf1:	89 55 08             	mov    %edx,0x8(%ebp)
  800cf4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cf7:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cfa:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cfd:	8a 12                	mov    (%edx),%dl
  800cff:	88 10                	mov    %dl,(%eax)
  800d01:	8a 00                	mov    (%eax),%al
  800d03:	84 c0                	test   %al,%al
  800d05:	75 e4                	jne    800ceb <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d07:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d0a:	c9                   	leave  
  800d0b:	c3                   	ret    

00800d0c <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d0c:	55                   	push   %ebp
  800d0d:	89 e5                	mov    %esp,%ebp
  800d0f:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d12:	8b 45 08             	mov    0x8(%ebp),%eax
  800d15:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d18:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d1f:	eb 1f                	jmp    800d40 <strncpy+0x34>
		*dst++ = *src;
  800d21:	8b 45 08             	mov    0x8(%ebp),%eax
  800d24:	8d 50 01             	lea    0x1(%eax),%edx
  800d27:	89 55 08             	mov    %edx,0x8(%ebp)
  800d2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d2d:	8a 12                	mov    (%edx),%dl
  800d2f:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d34:	8a 00                	mov    (%eax),%al
  800d36:	84 c0                	test   %al,%al
  800d38:	74 03                	je     800d3d <strncpy+0x31>
			src++;
  800d3a:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d3d:	ff 45 fc             	incl   -0x4(%ebp)
  800d40:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d43:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d46:	72 d9                	jb     800d21 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d48:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d4b:	c9                   	leave  
  800d4c:	c3                   	ret    

00800d4d <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d4d:	55                   	push   %ebp
  800d4e:	89 e5                	mov    %esp,%ebp
  800d50:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d53:	8b 45 08             	mov    0x8(%ebp),%eax
  800d56:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d59:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d5d:	74 30                	je     800d8f <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d5f:	eb 16                	jmp    800d77 <strlcpy+0x2a>
			*dst++ = *src++;
  800d61:	8b 45 08             	mov    0x8(%ebp),%eax
  800d64:	8d 50 01             	lea    0x1(%eax),%edx
  800d67:	89 55 08             	mov    %edx,0x8(%ebp)
  800d6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d6d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d70:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d73:	8a 12                	mov    (%edx),%dl
  800d75:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d77:	ff 4d 10             	decl   0x10(%ebp)
  800d7a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d7e:	74 09                	je     800d89 <strlcpy+0x3c>
  800d80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d83:	8a 00                	mov    (%eax),%al
  800d85:	84 c0                	test   %al,%al
  800d87:	75 d8                	jne    800d61 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d89:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d8f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d92:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d95:	29 c2                	sub    %eax,%edx
  800d97:	89 d0                	mov    %edx,%eax
}
  800d99:	c9                   	leave  
  800d9a:	c3                   	ret    

00800d9b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d9b:	55                   	push   %ebp
  800d9c:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d9e:	eb 06                	jmp    800da6 <strcmp+0xb>
		p++, q++;
  800da0:	ff 45 08             	incl   0x8(%ebp)
  800da3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800da6:	8b 45 08             	mov    0x8(%ebp),%eax
  800da9:	8a 00                	mov    (%eax),%al
  800dab:	84 c0                	test   %al,%al
  800dad:	74 0e                	je     800dbd <strcmp+0x22>
  800daf:	8b 45 08             	mov    0x8(%ebp),%eax
  800db2:	8a 10                	mov    (%eax),%dl
  800db4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db7:	8a 00                	mov    (%eax),%al
  800db9:	38 c2                	cmp    %al,%dl
  800dbb:	74 e3                	je     800da0 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc0:	8a 00                	mov    (%eax),%al
  800dc2:	0f b6 d0             	movzbl %al,%edx
  800dc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc8:	8a 00                	mov    (%eax),%al
  800dca:	0f b6 c0             	movzbl %al,%eax
  800dcd:	29 c2                	sub    %eax,%edx
  800dcf:	89 d0                	mov    %edx,%eax
}
  800dd1:	5d                   	pop    %ebp
  800dd2:	c3                   	ret    

00800dd3 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800dd3:	55                   	push   %ebp
  800dd4:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800dd6:	eb 09                	jmp    800de1 <strncmp+0xe>
		n--, p++, q++;
  800dd8:	ff 4d 10             	decl   0x10(%ebp)
  800ddb:	ff 45 08             	incl   0x8(%ebp)
  800dde:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800de1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800de5:	74 17                	je     800dfe <strncmp+0x2b>
  800de7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dea:	8a 00                	mov    (%eax),%al
  800dec:	84 c0                	test   %al,%al
  800dee:	74 0e                	je     800dfe <strncmp+0x2b>
  800df0:	8b 45 08             	mov    0x8(%ebp),%eax
  800df3:	8a 10                	mov    (%eax),%dl
  800df5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df8:	8a 00                	mov    (%eax),%al
  800dfa:	38 c2                	cmp    %al,%dl
  800dfc:	74 da                	je     800dd8 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800dfe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e02:	75 07                	jne    800e0b <strncmp+0x38>
		return 0;
  800e04:	b8 00 00 00 00       	mov    $0x0,%eax
  800e09:	eb 14                	jmp    800e1f <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0e:	8a 00                	mov    (%eax),%al
  800e10:	0f b6 d0             	movzbl %al,%edx
  800e13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e16:	8a 00                	mov    (%eax),%al
  800e18:	0f b6 c0             	movzbl %al,%eax
  800e1b:	29 c2                	sub    %eax,%edx
  800e1d:	89 d0                	mov    %edx,%eax
}
  800e1f:	5d                   	pop    %ebp
  800e20:	c3                   	ret    

00800e21 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e21:	55                   	push   %ebp
  800e22:	89 e5                	mov    %esp,%ebp
  800e24:	83 ec 04             	sub    $0x4,%esp
  800e27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e2d:	eb 12                	jmp    800e41 <strchr+0x20>
		if (*s == c)
  800e2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e32:	8a 00                	mov    (%eax),%al
  800e34:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e37:	75 05                	jne    800e3e <strchr+0x1d>
			return (char *) s;
  800e39:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3c:	eb 11                	jmp    800e4f <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e3e:	ff 45 08             	incl   0x8(%ebp)
  800e41:	8b 45 08             	mov    0x8(%ebp),%eax
  800e44:	8a 00                	mov    (%eax),%al
  800e46:	84 c0                	test   %al,%al
  800e48:	75 e5                	jne    800e2f <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e4a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e4f:	c9                   	leave  
  800e50:	c3                   	ret    

00800e51 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e51:	55                   	push   %ebp
  800e52:	89 e5                	mov    %esp,%ebp
  800e54:	83 ec 04             	sub    $0x4,%esp
  800e57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e5a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e5d:	eb 0d                	jmp    800e6c <strfind+0x1b>
		if (*s == c)
  800e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e62:	8a 00                	mov    (%eax),%al
  800e64:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e67:	74 0e                	je     800e77 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e69:	ff 45 08             	incl   0x8(%ebp)
  800e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6f:	8a 00                	mov    (%eax),%al
  800e71:	84 c0                	test   %al,%al
  800e73:	75 ea                	jne    800e5f <strfind+0xe>
  800e75:	eb 01                	jmp    800e78 <strfind+0x27>
		if (*s == c)
			break;
  800e77:	90                   	nop
	return (char *) s;
  800e78:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e7b:	c9                   	leave  
  800e7c:	c3                   	ret    

00800e7d <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800e7d:	55                   	push   %ebp
  800e7e:	89 e5                	mov    %esp,%ebp
  800e80:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800e83:	8b 45 08             	mov    0x8(%ebp),%eax
  800e86:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800e89:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e8d:	76 63                	jbe    800ef2 <memset+0x75>
		uint64 data_block = c;
  800e8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e92:	99                   	cltd   
  800e93:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e96:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800e99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e9c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e9f:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800ea3:	c1 e0 08             	shl    $0x8,%eax
  800ea6:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ea9:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800eac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eaf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eb2:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800eb6:	c1 e0 10             	shl    $0x10,%eax
  800eb9:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ebc:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800ebf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ec2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ec5:	89 c2                	mov    %eax,%edx
  800ec7:	b8 00 00 00 00       	mov    $0x0,%eax
  800ecc:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ecf:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800ed2:	eb 18                	jmp    800eec <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800ed4:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800ed7:	8d 41 08             	lea    0x8(%ecx),%eax
  800eda:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800edd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ee0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ee3:	89 01                	mov    %eax,(%ecx)
  800ee5:	89 51 04             	mov    %edx,0x4(%ecx)
  800ee8:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800eec:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ef0:	77 e2                	ja     800ed4 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800ef2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ef6:	74 23                	je     800f1b <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800ef8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800efb:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800efe:	eb 0e                	jmp    800f0e <memset+0x91>
			*p8++ = (uint8)c;
  800f00:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f03:	8d 50 01             	lea    0x1(%eax),%edx
  800f06:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f09:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f0c:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800f0e:	8b 45 10             	mov    0x10(%ebp),%eax
  800f11:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f14:	89 55 10             	mov    %edx,0x10(%ebp)
  800f17:	85 c0                	test   %eax,%eax
  800f19:	75 e5                	jne    800f00 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800f1b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f1e:	c9                   	leave  
  800f1f:	c3                   	ret    

00800f20 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f20:	55                   	push   %ebp
  800f21:	89 e5                	mov    %esp,%ebp
  800f23:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800f26:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f29:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800f32:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f36:	76 24                	jbe    800f5c <memcpy+0x3c>
		while(n >= 8){
  800f38:	eb 1c                	jmp    800f56 <memcpy+0x36>
			*d64 = *s64;
  800f3a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f3d:	8b 50 04             	mov    0x4(%eax),%edx
  800f40:	8b 00                	mov    (%eax),%eax
  800f42:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f45:	89 01                	mov    %eax,(%ecx)
  800f47:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800f4a:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800f4e:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800f52:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800f56:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f5a:	77 de                	ja     800f3a <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800f5c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f60:	74 31                	je     800f93 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800f62:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f65:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800f68:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f6b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800f6e:	eb 16                	jmp    800f86 <memcpy+0x66>
			*d8++ = *s8++;
  800f70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f73:	8d 50 01             	lea    0x1(%eax),%edx
  800f76:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800f79:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f7c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f7f:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800f82:	8a 12                	mov    (%edx),%dl
  800f84:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800f86:	8b 45 10             	mov    0x10(%ebp),%eax
  800f89:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f8c:	89 55 10             	mov    %edx,0x10(%ebp)
  800f8f:	85 c0                	test   %eax,%eax
  800f91:	75 dd                	jne    800f70 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800f93:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f96:	c9                   	leave  
  800f97:	c3                   	ret    

00800f98 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f98:	55                   	push   %ebp
  800f99:	89 e5                	mov    %esp,%ebp
  800f9b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800faa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fad:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fb0:	73 50                	jae    801002 <memmove+0x6a>
  800fb2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fb5:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb8:	01 d0                	add    %edx,%eax
  800fba:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fbd:	76 43                	jbe    801002 <memmove+0x6a>
		s += n;
  800fbf:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc2:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800fc5:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc8:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800fcb:	eb 10                	jmp    800fdd <memmove+0x45>
			*--d = *--s;
  800fcd:	ff 4d f8             	decl   -0x8(%ebp)
  800fd0:	ff 4d fc             	decl   -0x4(%ebp)
  800fd3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fd6:	8a 10                	mov    (%eax),%dl
  800fd8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fdb:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fdd:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe0:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fe3:	89 55 10             	mov    %edx,0x10(%ebp)
  800fe6:	85 c0                	test   %eax,%eax
  800fe8:	75 e3                	jne    800fcd <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fea:	eb 23                	jmp    80100f <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800fec:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fef:	8d 50 01             	lea    0x1(%eax),%edx
  800ff2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ff5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ff8:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ffb:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ffe:	8a 12                	mov    (%edx),%dl
  801000:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801002:	8b 45 10             	mov    0x10(%ebp),%eax
  801005:	8d 50 ff             	lea    -0x1(%eax),%edx
  801008:	89 55 10             	mov    %edx,0x10(%ebp)
  80100b:	85 c0                	test   %eax,%eax
  80100d:	75 dd                	jne    800fec <memmove+0x54>
			*d++ = *s++;

	return dst;
  80100f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801012:	c9                   	leave  
  801013:	c3                   	ret    

00801014 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801014:	55                   	push   %ebp
  801015:	89 e5                	mov    %esp,%ebp
  801017:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80101a:	8b 45 08             	mov    0x8(%ebp),%eax
  80101d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801020:	8b 45 0c             	mov    0xc(%ebp),%eax
  801023:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801026:	eb 2a                	jmp    801052 <memcmp+0x3e>
		if (*s1 != *s2)
  801028:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80102b:	8a 10                	mov    (%eax),%dl
  80102d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801030:	8a 00                	mov    (%eax),%al
  801032:	38 c2                	cmp    %al,%dl
  801034:	74 16                	je     80104c <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801036:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801039:	8a 00                	mov    (%eax),%al
  80103b:	0f b6 d0             	movzbl %al,%edx
  80103e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801041:	8a 00                	mov    (%eax),%al
  801043:	0f b6 c0             	movzbl %al,%eax
  801046:	29 c2                	sub    %eax,%edx
  801048:	89 d0                	mov    %edx,%eax
  80104a:	eb 18                	jmp    801064 <memcmp+0x50>
		s1++, s2++;
  80104c:	ff 45 fc             	incl   -0x4(%ebp)
  80104f:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801052:	8b 45 10             	mov    0x10(%ebp),%eax
  801055:	8d 50 ff             	lea    -0x1(%eax),%edx
  801058:	89 55 10             	mov    %edx,0x10(%ebp)
  80105b:	85 c0                	test   %eax,%eax
  80105d:	75 c9                	jne    801028 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80105f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801064:	c9                   	leave  
  801065:	c3                   	ret    

00801066 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801066:	55                   	push   %ebp
  801067:	89 e5                	mov    %esp,%ebp
  801069:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80106c:	8b 55 08             	mov    0x8(%ebp),%edx
  80106f:	8b 45 10             	mov    0x10(%ebp),%eax
  801072:	01 d0                	add    %edx,%eax
  801074:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801077:	eb 15                	jmp    80108e <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801079:	8b 45 08             	mov    0x8(%ebp),%eax
  80107c:	8a 00                	mov    (%eax),%al
  80107e:	0f b6 d0             	movzbl %al,%edx
  801081:	8b 45 0c             	mov    0xc(%ebp),%eax
  801084:	0f b6 c0             	movzbl %al,%eax
  801087:	39 c2                	cmp    %eax,%edx
  801089:	74 0d                	je     801098 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80108b:	ff 45 08             	incl   0x8(%ebp)
  80108e:	8b 45 08             	mov    0x8(%ebp),%eax
  801091:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801094:	72 e3                	jb     801079 <memfind+0x13>
  801096:	eb 01                	jmp    801099 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801098:	90                   	nop
	return (void *) s;
  801099:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80109c:	c9                   	leave  
  80109d:	c3                   	ret    

0080109e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80109e:	55                   	push   %ebp
  80109f:	89 e5                	mov    %esp,%ebp
  8010a1:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8010a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8010ab:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010b2:	eb 03                	jmp    8010b7 <strtol+0x19>
		s++;
  8010b4:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ba:	8a 00                	mov    (%eax),%al
  8010bc:	3c 20                	cmp    $0x20,%al
  8010be:	74 f4                	je     8010b4 <strtol+0x16>
  8010c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c3:	8a 00                	mov    (%eax),%al
  8010c5:	3c 09                	cmp    $0x9,%al
  8010c7:	74 eb                	je     8010b4 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cc:	8a 00                	mov    (%eax),%al
  8010ce:	3c 2b                	cmp    $0x2b,%al
  8010d0:	75 05                	jne    8010d7 <strtol+0x39>
		s++;
  8010d2:	ff 45 08             	incl   0x8(%ebp)
  8010d5:	eb 13                	jmp    8010ea <strtol+0x4c>
	else if (*s == '-')
  8010d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010da:	8a 00                	mov    (%eax),%al
  8010dc:	3c 2d                	cmp    $0x2d,%al
  8010de:	75 0a                	jne    8010ea <strtol+0x4c>
		s++, neg = 1;
  8010e0:	ff 45 08             	incl   0x8(%ebp)
  8010e3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010ea:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010ee:	74 06                	je     8010f6 <strtol+0x58>
  8010f0:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010f4:	75 20                	jne    801116 <strtol+0x78>
  8010f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f9:	8a 00                	mov    (%eax),%al
  8010fb:	3c 30                	cmp    $0x30,%al
  8010fd:	75 17                	jne    801116 <strtol+0x78>
  8010ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801102:	40                   	inc    %eax
  801103:	8a 00                	mov    (%eax),%al
  801105:	3c 78                	cmp    $0x78,%al
  801107:	75 0d                	jne    801116 <strtol+0x78>
		s += 2, base = 16;
  801109:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80110d:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801114:	eb 28                	jmp    80113e <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801116:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80111a:	75 15                	jne    801131 <strtol+0x93>
  80111c:	8b 45 08             	mov    0x8(%ebp),%eax
  80111f:	8a 00                	mov    (%eax),%al
  801121:	3c 30                	cmp    $0x30,%al
  801123:	75 0c                	jne    801131 <strtol+0x93>
		s++, base = 8;
  801125:	ff 45 08             	incl   0x8(%ebp)
  801128:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80112f:	eb 0d                	jmp    80113e <strtol+0xa0>
	else if (base == 0)
  801131:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801135:	75 07                	jne    80113e <strtol+0xa0>
		base = 10;
  801137:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80113e:	8b 45 08             	mov    0x8(%ebp),%eax
  801141:	8a 00                	mov    (%eax),%al
  801143:	3c 2f                	cmp    $0x2f,%al
  801145:	7e 19                	jle    801160 <strtol+0xc2>
  801147:	8b 45 08             	mov    0x8(%ebp),%eax
  80114a:	8a 00                	mov    (%eax),%al
  80114c:	3c 39                	cmp    $0x39,%al
  80114e:	7f 10                	jg     801160 <strtol+0xc2>
			dig = *s - '0';
  801150:	8b 45 08             	mov    0x8(%ebp),%eax
  801153:	8a 00                	mov    (%eax),%al
  801155:	0f be c0             	movsbl %al,%eax
  801158:	83 e8 30             	sub    $0x30,%eax
  80115b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80115e:	eb 42                	jmp    8011a2 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801160:	8b 45 08             	mov    0x8(%ebp),%eax
  801163:	8a 00                	mov    (%eax),%al
  801165:	3c 60                	cmp    $0x60,%al
  801167:	7e 19                	jle    801182 <strtol+0xe4>
  801169:	8b 45 08             	mov    0x8(%ebp),%eax
  80116c:	8a 00                	mov    (%eax),%al
  80116e:	3c 7a                	cmp    $0x7a,%al
  801170:	7f 10                	jg     801182 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801172:	8b 45 08             	mov    0x8(%ebp),%eax
  801175:	8a 00                	mov    (%eax),%al
  801177:	0f be c0             	movsbl %al,%eax
  80117a:	83 e8 57             	sub    $0x57,%eax
  80117d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801180:	eb 20                	jmp    8011a2 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801182:	8b 45 08             	mov    0x8(%ebp),%eax
  801185:	8a 00                	mov    (%eax),%al
  801187:	3c 40                	cmp    $0x40,%al
  801189:	7e 39                	jle    8011c4 <strtol+0x126>
  80118b:	8b 45 08             	mov    0x8(%ebp),%eax
  80118e:	8a 00                	mov    (%eax),%al
  801190:	3c 5a                	cmp    $0x5a,%al
  801192:	7f 30                	jg     8011c4 <strtol+0x126>
			dig = *s - 'A' + 10;
  801194:	8b 45 08             	mov    0x8(%ebp),%eax
  801197:	8a 00                	mov    (%eax),%al
  801199:	0f be c0             	movsbl %al,%eax
  80119c:	83 e8 37             	sub    $0x37,%eax
  80119f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8011a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011a5:	3b 45 10             	cmp    0x10(%ebp),%eax
  8011a8:	7d 19                	jge    8011c3 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8011aa:	ff 45 08             	incl   0x8(%ebp)
  8011ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011b0:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011b4:	89 c2                	mov    %eax,%edx
  8011b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011b9:	01 d0                	add    %edx,%eax
  8011bb:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8011be:	e9 7b ff ff ff       	jmp    80113e <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8011c3:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011c4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011c8:	74 08                	je     8011d2 <strtol+0x134>
		*endptr = (char *) s;
  8011ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8011d0:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011d6:	74 07                	je     8011df <strtol+0x141>
  8011d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011db:	f7 d8                	neg    %eax
  8011dd:	eb 03                	jmp    8011e2 <strtol+0x144>
  8011df:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011e2:	c9                   	leave  
  8011e3:	c3                   	ret    

008011e4 <ltostr>:

void
ltostr(long value, char *str)
{
  8011e4:	55                   	push   %ebp
  8011e5:	89 e5                	mov    %esp,%ebp
  8011e7:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011ea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011f1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011f8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011fc:	79 13                	jns    801211 <ltostr+0x2d>
	{
		neg = 1;
  8011fe:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801205:	8b 45 0c             	mov    0xc(%ebp),%eax
  801208:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80120b:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80120e:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801211:	8b 45 08             	mov    0x8(%ebp),%eax
  801214:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801219:	99                   	cltd   
  80121a:	f7 f9                	idiv   %ecx
  80121c:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80121f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801222:	8d 50 01             	lea    0x1(%eax),%edx
  801225:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801228:	89 c2                	mov    %eax,%edx
  80122a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122d:	01 d0                	add    %edx,%eax
  80122f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801232:	83 c2 30             	add    $0x30,%edx
  801235:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801237:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80123a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80123f:	f7 e9                	imul   %ecx
  801241:	c1 fa 02             	sar    $0x2,%edx
  801244:	89 c8                	mov    %ecx,%eax
  801246:	c1 f8 1f             	sar    $0x1f,%eax
  801249:	29 c2                	sub    %eax,%edx
  80124b:	89 d0                	mov    %edx,%eax
  80124d:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801250:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801254:	75 bb                	jne    801211 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801256:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80125d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801260:	48                   	dec    %eax
  801261:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801264:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801268:	74 3d                	je     8012a7 <ltostr+0xc3>
		start = 1 ;
  80126a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801271:	eb 34                	jmp    8012a7 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801273:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801276:	8b 45 0c             	mov    0xc(%ebp),%eax
  801279:	01 d0                	add    %edx,%eax
  80127b:	8a 00                	mov    (%eax),%al
  80127d:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801280:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801283:	8b 45 0c             	mov    0xc(%ebp),%eax
  801286:	01 c2                	add    %eax,%edx
  801288:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80128b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128e:	01 c8                	add    %ecx,%eax
  801290:	8a 00                	mov    (%eax),%al
  801292:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801294:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801297:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129a:	01 c2                	add    %eax,%edx
  80129c:	8a 45 eb             	mov    -0x15(%ebp),%al
  80129f:	88 02                	mov    %al,(%edx)
		start++ ;
  8012a1:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8012a4:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8012a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012aa:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012ad:	7c c4                	jl     801273 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8012af:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8012b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b5:	01 d0                	add    %edx,%eax
  8012b7:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012ba:	90                   	nop
  8012bb:	c9                   	leave  
  8012bc:	c3                   	ret    

008012bd <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012bd:	55                   	push   %ebp
  8012be:	89 e5                	mov    %esp,%ebp
  8012c0:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012c3:	ff 75 08             	pushl  0x8(%ebp)
  8012c6:	e8 c4 f9 ff ff       	call   800c8f <strlen>
  8012cb:	83 c4 04             	add    $0x4,%esp
  8012ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012d1:	ff 75 0c             	pushl  0xc(%ebp)
  8012d4:	e8 b6 f9 ff ff       	call   800c8f <strlen>
  8012d9:	83 c4 04             	add    $0x4,%esp
  8012dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012df:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012ed:	eb 17                	jmp    801306 <strcconcat+0x49>
		final[s] = str1[s] ;
  8012ef:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f5:	01 c2                	add    %eax,%edx
  8012f7:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fd:	01 c8                	add    %ecx,%eax
  8012ff:	8a 00                	mov    (%eax),%al
  801301:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801303:	ff 45 fc             	incl   -0x4(%ebp)
  801306:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801309:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80130c:	7c e1                	jl     8012ef <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80130e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801315:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80131c:	eb 1f                	jmp    80133d <strcconcat+0x80>
		final[s++] = str2[i] ;
  80131e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801321:	8d 50 01             	lea    0x1(%eax),%edx
  801324:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801327:	89 c2                	mov    %eax,%edx
  801329:	8b 45 10             	mov    0x10(%ebp),%eax
  80132c:	01 c2                	add    %eax,%edx
  80132e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801331:	8b 45 0c             	mov    0xc(%ebp),%eax
  801334:	01 c8                	add    %ecx,%eax
  801336:	8a 00                	mov    (%eax),%al
  801338:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80133a:	ff 45 f8             	incl   -0x8(%ebp)
  80133d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801340:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801343:	7c d9                	jl     80131e <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801345:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801348:	8b 45 10             	mov    0x10(%ebp),%eax
  80134b:	01 d0                	add    %edx,%eax
  80134d:	c6 00 00             	movb   $0x0,(%eax)
}
  801350:	90                   	nop
  801351:	c9                   	leave  
  801352:	c3                   	ret    

00801353 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801353:	55                   	push   %ebp
  801354:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801356:	8b 45 14             	mov    0x14(%ebp),%eax
  801359:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80135f:	8b 45 14             	mov    0x14(%ebp),%eax
  801362:	8b 00                	mov    (%eax),%eax
  801364:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80136b:	8b 45 10             	mov    0x10(%ebp),%eax
  80136e:	01 d0                	add    %edx,%eax
  801370:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801376:	eb 0c                	jmp    801384 <strsplit+0x31>
			*string++ = 0;
  801378:	8b 45 08             	mov    0x8(%ebp),%eax
  80137b:	8d 50 01             	lea    0x1(%eax),%edx
  80137e:	89 55 08             	mov    %edx,0x8(%ebp)
  801381:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801384:	8b 45 08             	mov    0x8(%ebp),%eax
  801387:	8a 00                	mov    (%eax),%al
  801389:	84 c0                	test   %al,%al
  80138b:	74 18                	je     8013a5 <strsplit+0x52>
  80138d:	8b 45 08             	mov    0x8(%ebp),%eax
  801390:	8a 00                	mov    (%eax),%al
  801392:	0f be c0             	movsbl %al,%eax
  801395:	50                   	push   %eax
  801396:	ff 75 0c             	pushl  0xc(%ebp)
  801399:	e8 83 fa ff ff       	call   800e21 <strchr>
  80139e:	83 c4 08             	add    $0x8,%esp
  8013a1:	85 c0                	test   %eax,%eax
  8013a3:	75 d3                	jne    801378 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8013a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a8:	8a 00                	mov    (%eax),%al
  8013aa:	84 c0                	test   %al,%al
  8013ac:	74 5a                	je     801408 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8013ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8013b1:	8b 00                	mov    (%eax),%eax
  8013b3:	83 f8 0f             	cmp    $0xf,%eax
  8013b6:	75 07                	jne    8013bf <strsplit+0x6c>
		{
			return 0;
  8013b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8013bd:	eb 66                	jmp    801425 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8013c2:	8b 00                	mov    (%eax),%eax
  8013c4:	8d 48 01             	lea    0x1(%eax),%ecx
  8013c7:	8b 55 14             	mov    0x14(%ebp),%edx
  8013ca:	89 0a                	mov    %ecx,(%edx)
  8013cc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8013d6:	01 c2                	add    %eax,%edx
  8013d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013db:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013dd:	eb 03                	jmp    8013e2 <strsplit+0x8f>
			string++;
  8013df:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e5:	8a 00                	mov    (%eax),%al
  8013e7:	84 c0                	test   %al,%al
  8013e9:	74 8b                	je     801376 <strsplit+0x23>
  8013eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ee:	8a 00                	mov    (%eax),%al
  8013f0:	0f be c0             	movsbl %al,%eax
  8013f3:	50                   	push   %eax
  8013f4:	ff 75 0c             	pushl  0xc(%ebp)
  8013f7:	e8 25 fa ff ff       	call   800e21 <strchr>
  8013fc:	83 c4 08             	add    $0x8,%esp
  8013ff:	85 c0                	test   %eax,%eax
  801401:	74 dc                	je     8013df <strsplit+0x8c>
			string++;
	}
  801403:	e9 6e ff ff ff       	jmp    801376 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801408:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801409:	8b 45 14             	mov    0x14(%ebp),%eax
  80140c:	8b 00                	mov    (%eax),%eax
  80140e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801415:	8b 45 10             	mov    0x10(%ebp),%eax
  801418:	01 d0                	add    %edx,%eax
  80141a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801420:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801425:	c9                   	leave  
  801426:	c3                   	ret    

00801427 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801427:	55                   	push   %ebp
  801428:	89 e5                	mov    %esp,%ebp
  80142a:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  80142d:	8b 45 08             	mov    0x8(%ebp),%eax
  801430:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801433:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80143a:	eb 4a                	jmp    801486 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  80143c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80143f:	8b 45 08             	mov    0x8(%ebp),%eax
  801442:	01 c2                	add    %eax,%edx
  801444:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801447:	8b 45 0c             	mov    0xc(%ebp),%eax
  80144a:	01 c8                	add    %ecx,%eax
  80144c:	8a 00                	mov    (%eax),%al
  80144e:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801450:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801453:	8b 45 0c             	mov    0xc(%ebp),%eax
  801456:	01 d0                	add    %edx,%eax
  801458:	8a 00                	mov    (%eax),%al
  80145a:	3c 40                	cmp    $0x40,%al
  80145c:	7e 25                	jle    801483 <str2lower+0x5c>
  80145e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801461:	8b 45 0c             	mov    0xc(%ebp),%eax
  801464:	01 d0                	add    %edx,%eax
  801466:	8a 00                	mov    (%eax),%al
  801468:	3c 5a                	cmp    $0x5a,%al
  80146a:	7f 17                	jg     801483 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  80146c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80146f:	8b 45 08             	mov    0x8(%ebp),%eax
  801472:	01 d0                	add    %edx,%eax
  801474:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801477:	8b 55 08             	mov    0x8(%ebp),%edx
  80147a:	01 ca                	add    %ecx,%edx
  80147c:	8a 12                	mov    (%edx),%dl
  80147e:	83 c2 20             	add    $0x20,%edx
  801481:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801483:	ff 45 fc             	incl   -0x4(%ebp)
  801486:	ff 75 0c             	pushl  0xc(%ebp)
  801489:	e8 01 f8 ff ff       	call   800c8f <strlen>
  80148e:	83 c4 04             	add    $0x4,%esp
  801491:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801494:	7f a6                	jg     80143c <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801496:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801499:	c9                   	leave  
  80149a:	c3                   	ret    

0080149b <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  80149b:	55                   	push   %ebp
  80149c:	89 e5                	mov    %esp,%ebp
  80149e:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  8014a1:	a1 08 30 80 00       	mov    0x803008,%eax
  8014a6:	85 c0                	test   %eax,%eax
  8014a8:	74 42                	je     8014ec <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  8014aa:	83 ec 08             	sub    $0x8,%esp
  8014ad:	68 00 00 00 82       	push   $0x82000000
  8014b2:	68 00 00 00 80       	push   $0x80000000
  8014b7:	e8 8c 07 00 00       	call   801c48 <initialize_dynamic_allocator>
  8014bc:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  8014bf:	e8 e7 05 00 00       	call   801aab <sys_get_uheap_strategy>
  8014c4:	a3 60 b0 81 00       	mov    %eax,0x81b060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  8014c9:	a1 40 30 80 00       	mov    0x803040,%eax
  8014ce:	05 00 10 00 00       	add    $0x1000,%eax
  8014d3:	a3 10 b1 81 00       	mov    %eax,0x81b110
		uheapPageAllocBreak = uheapPageAllocStart;
  8014d8:	a1 10 b1 81 00       	mov    0x81b110,%eax
  8014dd:	a3 68 b0 81 00       	mov    %eax,0x81b068

		__firstTimeFlag = 0;
  8014e2:	c7 05 08 30 80 00 00 	movl   $0x0,0x803008
  8014e9:	00 00 00 
	}
}
  8014ec:	90                   	nop
  8014ed:	c9                   	leave  
  8014ee:	c3                   	ret    

008014ef <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  8014ef:	55                   	push   %ebp
  8014f0:	89 e5                	mov    %esp,%ebp
  8014f2:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  8014f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014fe:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801503:	83 ec 08             	sub    $0x8,%esp
  801506:	68 06 04 00 00       	push   $0x406
  80150b:	50                   	push   %eax
  80150c:	e8 e4 01 00 00       	call   8016f5 <__sys_allocate_page>
  801511:	83 c4 10             	add    $0x10,%esp
  801514:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801517:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80151b:	79 14                	jns    801531 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  80151d:	83 ec 04             	sub    $0x4,%esp
  801520:	68 68 26 80 00       	push   $0x802668
  801525:	6a 1f                	push   $0x1f
  801527:	68 a4 26 80 00       	push   $0x8026a4
  80152c:	e8 b7 ed ff ff       	call   8002e8 <_panic>
	return 0;
  801531:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801536:	c9                   	leave  
  801537:	c3                   	ret    

00801538 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801538:	55                   	push   %ebp
  801539:	89 e5                	mov    %esp,%ebp
  80153b:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  80153e:	8b 45 08             	mov    0x8(%ebp),%eax
  801541:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801544:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801547:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80154c:	83 ec 0c             	sub    $0xc,%esp
  80154f:	50                   	push   %eax
  801550:	e8 e7 01 00 00       	call   80173c <__sys_unmap_frame>
  801555:	83 c4 10             	add    $0x10,%esp
  801558:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  80155b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80155f:	79 14                	jns    801575 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801561:	83 ec 04             	sub    $0x4,%esp
  801564:	68 b0 26 80 00       	push   $0x8026b0
  801569:	6a 2a                	push   $0x2a
  80156b:	68 a4 26 80 00       	push   $0x8026a4
  801570:	e8 73 ed ff ff       	call   8002e8 <_panic>
}
  801575:	90                   	nop
  801576:	c9                   	leave  
  801577:	c3                   	ret    

00801578 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801578:	55                   	push   %ebp
  801579:	89 e5                	mov    %esp,%ebp
  80157b:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80157e:	e8 18 ff ff ff       	call   80149b <uheap_init>
	if (size == 0) return NULL ;
  801583:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801587:	75 07                	jne    801590 <malloc+0x18>
  801589:	b8 00 00 00 00       	mov    $0x0,%eax
  80158e:	eb 14                	jmp    8015a4 <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  801590:	83 ec 04             	sub    $0x4,%esp
  801593:	68 f0 26 80 00       	push   $0x8026f0
  801598:	6a 3e                	push   $0x3e
  80159a:	68 a4 26 80 00       	push   $0x8026a4
  80159f:	e8 44 ed ff ff       	call   8002e8 <_panic>
}
  8015a4:	c9                   	leave  
  8015a5:	c3                   	ret    

008015a6 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  8015a6:	55                   	push   %ebp
  8015a7:	89 e5                	mov    %esp,%ebp
  8015a9:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  8015ac:	83 ec 04             	sub    $0x4,%esp
  8015af:	68 18 27 80 00       	push   $0x802718
  8015b4:	6a 49                	push   $0x49
  8015b6:	68 a4 26 80 00       	push   $0x8026a4
  8015bb:	e8 28 ed ff ff       	call   8002e8 <_panic>

008015c0 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8015c0:	55                   	push   %ebp
  8015c1:	89 e5                	mov    %esp,%ebp
  8015c3:	83 ec 18             	sub    $0x18,%esp
  8015c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8015c9:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8015cc:	e8 ca fe ff ff       	call   80149b <uheap_init>
	if (size == 0) return NULL ;
  8015d1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015d5:	75 07                	jne    8015de <smalloc+0x1e>
  8015d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8015dc:	eb 14                	jmp    8015f2 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  8015de:	83 ec 04             	sub    $0x4,%esp
  8015e1:	68 3c 27 80 00       	push   $0x80273c
  8015e6:	6a 5a                	push   $0x5a
  8015e8:	68 a4 26 80 00       	push   $0x8026a4
  8015ed:	e8 f6 ec ff ff       	call   8002e8 <_panic>
}
  8015f2:	c9                   	leave  
  8015f3:	c3                   	ret    

008015f4 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8015f4:	55                   	push   %ebp
  8015f5:	89 e5                	mov    %esp,%ebp
  8015f7:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8015fa:	e8 9c fe ff ff       	call   80149b <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  8015ff:	83 ec 04             	sub    $0x4,%esp
  801602:	68 64 27 80 00       	push   $0x802764
  801607:	6a 6a                	push   $0x6a
  801609:	68 a4 26 80 00       	push   $0x8026a4
  80160e:	e8 d5 ec ff ff       	call   8002e8 <_panic>

00801613 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801613:	55                   	push   %ebp
  801614:	89 e5                	mov    %esp,%ebp
  801616:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801619:	e8 7d fe ff ff       	call   80149b <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  80161e:	83 ec 04             	sub    $0x4,%esp
  801621:	68 88 27 80 00       	push   $0x802788
  801626:	68 88 00 00 00       	push   $0x88
  80162b:	68 a4 26 80 00       	push   $0x8026a4
  801630:	e8 b3 ec ff ff       	call   8002e8 <_panic>

00801635 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  801635:	55                   	push   %ebp
  801636:	89 e5                	mov    %esp,%ebp
  801638:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  80163b:	83 ec 04             	sub    $0x4,%esp
  80163e:	68 b0 27 80 00       	push   $0x8027b0
  801643:	68 9b 00 00 00       	push   $0x9b
  801648:	68 a4 26 80 00       	push   $0x8026a4
  80164d:	e8 96 ec ff ff       	call   8002e8 <_panic>

00801652 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801652:	55                   	push   %ebp
  801653:	89 e5                	mov    %esp,%ebp
  801655:	57                   	push   %edi
  801656:	56                   	push   %esi
  801657:	53                   	push   %ebx
  801658:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80165b:	8b 45 08             	mov    0x8(%ebp),%eax
  80165e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801661:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801664:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801667:	8b 7d 18             	mov    0x18(%ebp),%edi
  80166a:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80166d:	cd 30                	int    $0x30
  80166f:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801672:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801675:	83 c4 10             	add    $0x10,%esp
  801678:	5b                   	pop    %ebx
  801679:	5e                   	pop    %esi
  80167a:	5f                   	pop    %edi
  80167b:	5d                   	pop    %ebp
  80167c:	c3                   	ret    

0080167d <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  80167d:	55                   	push   %ebp
  80167e:	89 e5                	mov    %esp,%ebp
  801680:	83 ec 04             	sub    $0x4,%esp
  801683:	8b 45 10             	mov    0x10(%ebp),%eax
  801686:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801689:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80168c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801690:	8b 45 08             	mov    0x8(%ebp),%eax
  801693:	6a 00                	push   $0x0
  801695:	51                   	push   %ecx
  801696:	52                   	push   %edx
  801697:	ff 75 0c             	pushl  0xc(%ebp)
  80169a:	50                   	push   %eax
  80169b:	6a 00                	push   $0x0
  80169d:	e8 b0 ff ff ff       	call   801652 <syscall>
  8016a2:	83 c4 18             	add    $0x18,%esp
}
  8016a5:	90                   	nop
  8016a6:	c9                   	leave  
  8016a7:	c3                   	ret    

008016a8 <sys_cgetc>:

int
sys_cgetc(void)
{
  8016a8:	55                   	push   %ebp
  8016a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8016ab:	6a 00                	push   $0x0
  8016ad:	6a 00                	push   $0x0
  8016af:	6a 00                	push   $0x0
  8016b1:	6a 00                	push   $0x0
  8016b3:	6a 00                	push   $0x0
  8016b5:	6a 02                	push   $0x2
  8016b7:	e8 96 ff ff ff       	call   801652 <syscall>
  8016bc:	83 c4 18             	add    $0x18,%esp
}
  8016bf:	c9                   	leave  
  8016c0:	c3                   	ret    

008016c1 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8016c1:	55                   	push   %ebp
  8016c2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8016c4:	6a 00                	push   $0x0
  8016c6:	6a 00                	push   $0x0
  8016c8:	6a 00                	push   $0x0
  8016ca:	6a 00                	push   $0x0
  8016cc:	6a 00                	push   $0x0
  8016ce:	6a 03                	push   $0x3
  8016d0:	e8 7d ff ff ff       	call   801652 <syscall>
  8016d5:	83 c4 18             	add    $0x18,%esp
}
  8016d8:	90                   	nop
  8016d9:	c9                   	leave  
  8016da:	c3                   	ret    

008016db <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8016db:	55                   	push   %ebp
  8016dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8016de:	6a 00                	push   $0x0
  8016e0:	6a 00                	push   $0x0
  8016e2:	6a 00                	push   $0x0
  8016e4:	6a 00                	push   $0x0
  8016e6:	6a 00                	push   $0x0
  8016e8:	6a 04                	push   $0x4
  8016ea:	e8 63 ff ff ff       	call   801652 <syscall>
  8016ef:	83 c4 18             	add    $0x18,%esp
}
  8016f2:	90                   	nop
  8016f3:	c9                   	leave  
  8016f4:	c3                   	ret    

008016f5 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8016f5:	55                   	push   %ebp
  8016f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8016f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fe:	6a 00                	push   $0x0
  801700:	6a 00                	push   $0x0
  801702:	6a 00                	push   $0x0
  801704:	52                   	push   %edx
  801705:	50                   	push   %eax
  801706:	6a 08                	push   $0x8
  801708:	e8 45 ff ff ff       	call   801652 <syscall>
  80170d:	83 c4 18             	add    $0x18,%esp
}
  801710:	c9                   	leave  
  801711:	c3                   	ret    

00801712 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801712:	55                   	push   %ebp
  801713:	89 e5                	mov    %esp,%ebp
  801715:	56                   	push   %esi
  801716:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801717:	8b 75 18             	mov    0x18(%ebp),%esi
  80171a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80171d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801720:	8b 55 0c             	mov    0xc(%ebp),%edx
  801723:	8b 45 08             	mov    0x8(%ebp),%eax
  801726:	56                   	push   %esi
  801727:	53                   	push   %ebx
  801728:	51                   	push   %ecx
  801729:	52                   	push   %edx
  80172a:	50                   	push   %eax
  80172b:	6a 09                	push   $0x9
  80172d:	e8 20 ff ff ff       	call   801652 <syscall>
  801732:	83 c4 18             	add    $0x18,%esp
}
  801735:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801738:	5b                   	pop    %ebx
  801739:	5e                   	pop    %esi
  80173a:	5d                   	pop    %ebp
  80173b:	c3                   	ret    

0080173c <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  80173c:	55                   	push   %ebp
  80173d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  80173f:	6a 00                	push   $0x0
  801741:	6a 00                	push   $0x0
  801743:	6a 00                	push   $0x0
  801745:	6a 00                	push   $0x0
  801747:	ff 75 08             	pushl  0x8(%ebp)
  80174a:	6a 0a                	push   $0xa
  80174c:	e8 01 ff ff ff       	call   801652 <syscall>
  801751:	83 c4 18             	add    $0x18,%esp
}
  801754:	c9                   	leave  
  801755:	c3                   	ret    

00801756 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801756:	55                   	push   %ebp
  801757:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801759:	6a 00                	push   $0x0
  80175b:	6a 00                	push   $0x0
  80175d:	6a 00                	push   $0x0
  80175f:	ff 75 0c             	pushl  0xc(%ebp)
  801762:	ff 75 08             	pushl  0x8(%ebp)
  801765:	6a 0b                	push   $0xb
  801767:	e8 e6 fe ff ff       	call   801652 <syscall>
  80176c:	83 c4 18             	add    $0x18,%esp
}
  80176f:	c9                   	leave  
  801770:	c3                   	ret    

00801771 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801771:	55                   	push   %ebp
  801772:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801774:	6a 00                	push   $0x0
  801776:	6a 00                	push   $0x0
  801778:	6a 00                	push   $0x0
  80177a:	6a 00                	push   $0x0
  80177c:	6a 00                	push   $0x0
  80177e:	6a 0c                	push   $0xc
  801780:	e8 cd fe ff ff       	call   801652 <syscall>
  801785:	83 c4 18             	add    $0x18,%esp
}
  801788:	c9                   	leave  
  801789:	c3                   	ret    

0080178a <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80178a:	55                   	push   %ebp
  80178b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80178d:	6a 00                	push   $0x0
  80178f:	6a 00                	push   $0x0
  801791:	6a 00                	push   $0x0
  801793:	6a 00                	push   $0x0
  801795:	6a 00                	push   $0x0
  801797:	6a 0d                	push   $0xd
  801799:	e8 b4 fe ff ff       	call   801652 <syscall>
  80179e:	83 c4 18             	add    $0x18,%esp
}
  8017a1:	c9                   	leave  
  8017a2:	c3                   	ret    

008017a3 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8017a3:	55                   	push   %ebp
  8017a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8017a6:	6a 00                	push   $0x0
  8017a8:	6a 00                	push   $0x0
  8017aa:	6a 00                	push   $0x0
  8017ac:	6a 00                	push   $0x0
  8017ae:	6a 00                	push   $0x0
  8017b0:	6a 0e                	push   $0xe
  8017b2:	e8 9b fe ff ff       	call   801652 <syscall>
  8017b7:	83 c4 18             	add    $0x18,%esp
}
  8017ba:	c9                   	leave  
  8017bb:	c3                   	ret    

008017bc <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8017bc:	55                   	push   %ebp
  8017bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8017bf:	6a 00                	push   $0x0
  8017c1:	6a 00                	push   $0x0
  8017c3:	6a 00                	push   $0x0
  8017c5:	6a 00                	push   $0x0
  8017c7:	6a 00                	push   $0x0
  8017c9:	6a 0f                	push   $0xf
  8017cb:	e8 82 fe ff ff       	call   801652 <syscall>
  8017d0:	83 c4 18             	add    $0x18,%esp
}
  8017d3:	c9                   	leave  
  8017d4:	c3                   	ret    

008017d5 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8017d5:	55                   	push   %ebp
  8017d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8017d8:	6a 00                	push   $0x0
  8017da:	6a 00                	push   $0x0
  8017dc:	6a 00                	push   $0x0
  8017de:	6a 00                	push   $0x0
  8017e0:	ff 75 08             	pushl  0x8(%ebp)
  8017e3:	6a 10                	push   $0x10
  8017e5:	e8 68 fe ff ff       	call   801652 <syscall>
  8017ea:	83 c4 18             	add    $0x18,%esp
}
  8017ed:	c9                   	leave  
  8017ee:	c3                   	ret    

008017ef <sys_scarce_memory>:

void sys_scarce_memory()
{
  8017ef:	55                   	push   %ebp
  8017f0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8017f2:	6a 00                	push   $0x0
  8017f4:	6a 00                	push   $0x0
  8017f6:	6a 00                	push   $0x0
  8017f8:	6a 00                	push   $0x0
  8017fa:	6a 00                	push   $0x0
  8017fc:	6a 11                	push   $0x11
  8017fe:	e8 4f fe ff ff       	call   801652 <syscall>
  801803:	83 c4 18             	add    $0x18,%esp
}
  801806:	90                   	nop
  801807:	c9                   	leave  
  801808:	c3                   	ret    

00801809 <sys_cputc>:

void
sys_cputc(const char c)
{
  801809:	55                   	push   %ebp
  80180a:	89 e5                	mov    %esp,%ebp
  80180c:	83 ec 04             	sub    $0x4,%esp
  80180f:	8b 45 08             	mov    0x8(%ebp),%eax
  801812:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801815:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801819:	6a 00                	push   $0x0
  80181b:	6a 00                	push   $0x0
  80181d:	6a 00                	push   $0x0
  80181f:	6a 00                	push   $0x0
  801821:	50                   	push   %eax
  801822:	6a 01                	push   $0x1
  801824:	e8 29 fe ff ff       	call   801652 <syscall>
  801829:	83 c4 18             	add    $0x18,%esp
}
  80182c:	90                   	nop
  80182d:	c9                   	leave  
  80182e:	c3                   	ret    

0080182f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80182f:	55                   	push   %ebp
  801830:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801832:	6a 00                	push   $0x0
  801834:	6a 00                	push   $0x0
  801836:	6a 00                	push   $0x0
  801838:	6a 00                	push   $0x0
  80183a:	6a 00                	push   $0x0
  80183c:	6a 14                	push   $0x14
  80183e:	e8 0f fe ff ff       	call   801652 <syscall>
  801843:	83 c4 18             	add    $0x18,%esp
}
  801846:	90                   	nop
  801847:	c9                   	leave  
  801848:	c3                   	ret    

00801849 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801849:	55                   	push   %ebp
  80184a:	89 e5                	mov    %esp,%ebp
  80184c:	83 ec 04             	sub    $0x4,%esp
  80184f:	8b 45 10             	mov    0x10(%ebp),%eax
  801852:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801855:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801858:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80185c:	8b 45 08             	mov    0x8(%ebp),%eax
  80185f:	6a 00                	push   $0x0
  801861:	51                   	push   %ecx
  801862:	52                   	push   %edx
  801863:	ff 75 0c             	pushl  0xc(%ebp)
  801866:	50                   	push   %eax
  801867:	6a 15                	push   $0x15
  801869:	e8 e4 fd ff ff       	call   801652 <syscall>
  80186e:	83 c4 18             	add    $0x18,%esp
}
  801871:	c9                   	leave  
  801872:	c3                   	ret    

00801873 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801873:	55                   	push   %ebp
  801874:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801876:	8b 55 0c             	mov    0xc(%ebp),%edx
  801879:	8b 45 08             	mov    0x8(%ebp),%eax
  80187c:	6a 00                	push   $0x0
  80187e:	6a 00                	push   $0x0
  801880:	6a 00                	push   $0x0
  801882:	52                   	push   %edx
  801883:	50                   	push   %eax
  801884:	6a 16                	push   $0x16
  801886:	e8 c7 fd ff ff       	call   801652 <syscall>
  80188b:	83 c4 18             	add    $0x18,%esp
}
  80188e:	c9                   	leave  
  80188f:	c3                   	ret    

00801890 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801890:	55                   	push   %ebp
  801891:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801893:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801896:	8b 55 0c             	mov    0xc(%ebp),%edx
  801899:	8b 45 08             	mov    0x8(%ebp),%eax
  80189c:	6a 00                	push   $0x0
  80189e:	6a 00                	push   $0x0
  8018a0:	51                   	push   %ecx
  8018a1:	52                   	push   %edx
  8018a2:	50                   	push   %eax
  8018a3:	6a 17                	push   $0x17
  8018a5:	e8 a8 fd ff ff       	call   801652 <syscall>
  8018aa:	83 c4 18             	add    $0x18,%esp
}
  8018ad:	c9                   	leave  
  8018ae:	c3                   	ret    

008018af <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8018af:	55                   	push   %ebp
  8018b0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8018b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b8:	6a 00                	push   $0x0
  8018ba:	6a 00                	push   $0x0
  8018bc:	6a 00                	push   $0x0
  8018be:	52                   	push   %edx
  8018bf:	50                   	push   %eax
  8018c0:	6a 18                	push   $0x18
  8018c2:	e8 8b fd ff ff       	call   801652 <syscall>
  8018c7:	83 c4 18             	add    $0x18,%esp
}
  8018ca:	c9                   	leave  
  8018cb:	c3                   	ret    

008018cc <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8018cc:	55                   	push   %ebp
  8018cd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8018cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d2:	6a 00                	push   $0x0
  8018d4:	ff 75 14             	pushl  0x14(%ebp)
  8018d7:	ff 75 10             	pushl  0x10(%ebp)
  8018da:	ff 75 0c             	pushl  0xc(%ebp)
  8018dd:	50                   	push   %eax
  8018de:	6a 19                	push   $0x19
  8018e0:	e8 6d fd ff ff       	call   801652 <syscall>
  8018e5:	83 c4 18             	add    $0x18,%esp
}
  8018e8:	c9                   	leave  
  8018e9:	c3                   	ret    

008018ea <sys_run_env>:

void sys_run_env(int32 envId)
{
  8018ea:	55                   	push   %ebp
  8018eb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8018ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f0:	6a 00                	push   $0x0
  8018f2:	6a 00                	push   $0x0
  8018f4:	6a 00                	push   $0x0
  8018f6:	6a 00                	push   $0x0
  8018f8:	50                   	push   %eax
  8018f9:	6a 1a                	push   $0x1a
  8018fb:	e8 52 fd ff ff       	call   801652 <syscall>
  801900:	83 c4 18             	add    $0x18,%esp
}
  801903:	90                   	nop
  801904:	c9                   	leave  
  801905:	c3                   	ret    

00801906 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801906:	55                   	push   %ebp
  801907:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801909:	8b 45 08             	mov    0x8(%ebp),%eax
  80190c:	6a 00                	push   $0x0
  80190e:	6a 00                	push   $0x0
  801910:	6a 00                	push   $0x0
  801912:	6a 00                	push   $0x0
  801914:	50                   	push   %eax
  801915:	6a 1b                	push   $0x1b
  801917:	e8 36 fd ff ff       	call   801652 <syscall>
  80191c:	83 c4 18             	add    $0x18,%esp
}
  80191f:	c9                   	leave  
  801920:	c3                   	ret    

00801921 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801921:	55                   	push   %ebp
  801922:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801924:	6a 00                	push   $0x0
  801926:	6a 00                	push   $0x0
  801928:	6a 00                	push   $0x0
  80192a:	6a 00                	push   $0x0
  80192c:	6a 00                	push   $0x0
  80192e:	6a 05                	push   $0x5
  801930:	e8 1d fd ff ff       	call   801652 <syscall>
  801935:	83 c4 18             	add    $0x18,%esp
}
  801938:	c9                   	leave  
  801939:	c3                   	ret    

0080193a <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80193a:	55                   	push   %ebp
  80193b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80193d:	6a 00                	push   $0x0
  80193f:	6a 00                	push   $0x0
  801941:	6a 00                	push   $0x0
  801943:	6a 00                	push   $0x0
  801945:	6a 00                	push   $0x0
  801947:	6a 06                	push   $0x6
  801949:	e8 04 fd ff ff       	call   801652 <syscall>
  80194e:	83 c4 18             	add    $0x18,%esp
}
  801951:	c9                   	leave  
  801952:	c3                   	ret    

00801953 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801953:	55                   	push   %ebp
  801954:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801956:	6a 00                	push   $0x0
  801958:	6a 00                	push   $0x0
  80195a:	6a 00                	push   $0x0
  80195c:	6a 00                	push   $0x0
  80195e:	6a 00                	push   $0x0
  801960:	6a 07                	push   $0x7
  801962:	e8 eb fc ff ff       	call   801652 <syscall>
  801967:	83 c4 18             	add    $0x18,%esp
}
  80196a:	c9                   	leave  
  80196b:	c3                   	ret    

0080196c <sys_exit_env>:


void sys_exit_env(void)
{
  80196c:	55                   	push   %ebp
  80196d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80196f:	6a 00                	push   $0x0
  801971:	6a 00                	push   $0x0
  801973:	6a 00                	push   $0x0
  801975:	6a 00                	push   $0x0
  801977:	6a 00                	push   $0x0
  801979:	6a 1c                	push   $0x1c
  80197b:	e8 d2 fc ff ff       	call   801652 <syscall>
  801980:	83 c4 18             	add    $0x18,%esp
}
  801983:	90                   	nop
  801984:	c9                   	leave  
  801985:	c3                   	ret    

00801986 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801986:	55                   	push   %ebp
  801987:	89 e5                	mov    %esp,%ebp
  801989:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80198c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80198f:	8d 50 04             	lea    0x4(%eax),%edx
  801992:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801995:	6a 00                	push   $0x0
  801997:	6a 00                	push   $0x0
  801999:	6a 00                	push   $0x0
  80199b:	52                   	push   %edx
  80199c:	50                   	push   %eax
  80199d:	6a 1d                	push   $0x1d
  80199f:	e8 ae fc ff ff       	call   801652 <syscall>
  8019a4:	83 c4 18             	add    $0x18,%esp
	return result;
  8019a7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019ad:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019b0:	89 01                	mov    %eax,(%ecx)
  8019b2:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8019b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b8:	c9                   	leave  
  8019b9:	c2 04 00             	ret    $0x4

008019bc <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8019bc:	55                   	push   %ebp
  8019bd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 00                	push   $0x0
  8019c3:	ff 75 10             	pushl  0x10(%ebp)
  8019c6:	ff 75 0c             	pushl  0xc(%ebp)
  8019c9:	ff 75 08             	pushl  0x8(%ebp)
  8019cc:	6a 13                	push   $0x13
  8019ce:	e8 7f fc ff ff       	call   801652 <syscall>
  8019d3:	83 c4 18             	add    $0x18,%esp
	return ;
  8019d6:	90                   	nop
}
  8019d7:	c9                   	leave  
  8019d8:	c3                   	ret    

008019d9 <sys_rcr2>:
uint32 sys_rcr2()
{
  8019d9:	55                   	push   %ebp
  8019da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 1e                	push   $0x1e
  8019e8:	e8 65 fc ff ff       	call   801652 <syscall>
  8019ed:	83 c4 18             	add    $0x18,%esp
}
  8019f0:	c9                   	leave  
  8019f1:	c3                   	ret    

008019f2 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8019f2:	55                   	push   %ebp
  8019f3:	89 e5                	mov    %esp,%ebp
  8019f5:	83 ec 04             	sub    $0x4,%esp
  8019f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8019fe:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801a02:	6a 00                	push   $0x0
  801a04:	6a 00                	push   $0x0
  801a06:	6a 00                	push   $0x0
  801a08:	6a 00                	push   $0x0
  801a0a:	50                   	push   %eax
  801a0b:	6a 1f                	push   $0x1f
  801a0d:	e8 40 fc ff ff       	call   801652 <syscall>
  801a12:	83 c4 18             	add    $0x18,%esp
	return ;
  801a15:	90                   	nop
}
  801a16:	c9                   	leave  
  801a17:	c3                   	ret    

00801a18 <rsttst>:
void rsttst()
{
  801a18:	55                   	push   %ebp
  801a19:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 00                	push   $0x0
  801a23:	6a 00                	push   $0x0
  801a25:	6a 21                	push   $0x21
  801a27:	e8 26 fc ff ff       	call   801652 <syscall>
  801a2c:	83 c4 18             	add    $0x18,%esp
	return ;
  801a2f:	90                   	nop
}
  801a30:	c9                   	leave  
  801a31:	c3                   	ret    

00801a32 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801a32:	55                   	push   %ebp
  801a33:	89 e5                	mov    %esp,%ebp
  801a35:	83 ec 04             	sub    $0x4,%esp
  801a38:	8b 45 14             	mov    0x14(%ebp),%eax
  801a3b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801a3e:	8b 55 18             	mov    0x18(%ebp),%edx
  801a41:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a45:	52                   	push   %edx
  801a46:	50                   	push   %eax
  801a47:	ff 75 10             	pushl  0x10(%ebp)
  801a4a:	ff 75 0c             	pushl  0xc(%ebp)
  801a4d:	ff 75 08             	pushl  0x8(%ebp)
  801a50:	6a 20                	push   $0x20
  801a52:	e8 fb fb ff ff       	call   801652 <syscall>
  801a57:	83 c4 18             	add    $0x18,%esp
	return ;
  801a5a:	90                   	nop
}
  801a5b:	c9                   	leave  
  801a5c:	c3                   	ret    

00801a5d <chktst>:
void chktst(uint32 n)
{
  801a5d:	55                   	push   %ebp
  801a5e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801a60:	6a 00                	push   $0x0
  801a62:	6a 00                	push   $0x0
  801a64:	6a 00                	push   $0x0
  801a66:	6a 00                	push   $0x0
  801a68:	ff 75 08             	pushl  0x8(%ebp)
  801a6b:	6a 22                	push   $0x22
  801a6d:	e8 e0 fb ff ff       	call   801652 <syscall>
  801a72:	83 c4 18             	add    $0x18,%esp
	return ;
  801a75:	90                   	nop
}
  801a76:	c9                   	leave  
  801a77:	c3                   	ret    

00801a78 <inctst>:

void inctst()
{
  801a78:	55                   	push   %ebp
  801a79:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801a7b:	6a 00                	push   $0x0
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 00                	push   $0x0
  801a83:	6a 00                	push   $0x0
  801a85:	6a 23                	push   $0x23
  801a87:	e8 c6 fb ff ff       	call   801652 <syscall>
  801a8c:	83 c4 18             	add    $0x18,%esp
	return ;
  801a8f:	90                   	nop
}
  801a90:	c9                   	leave  
  801a91:	c3                   	ret    

00801a92 <gettst>:
uint32 gettst()
{
  801a92:	55                   	push   %ebp
  801a93:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801a95:	6a 00                	push   $0x0
  801a97:	6a 00                	push   $0x0
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 00                	push   $0x0
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 24                	push   $0x24
  801aa1:	e8 ac fb ff ff       	call   801652 <syscall>
  801aa6:	83 c4 18             	add    $0x18,%esp
}
  801aa9:	c9                   	leave  
  801aaa:	c3                   	ret    

00801aab <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801aab:	55                   	push   %ebp
  801aac:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 25                	push   $0x25
  801aba:	e8 93 fb ff ff       	call   801652 <syscall>
  801abf:	83 c4 18             	add    $0x18,%esp
  801ac2:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801ac7:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801acc:	c9                   	leave  
  801acd:	c3                   	ret    

00801ace <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ace:	55                   	push   %ebp
  801acf:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad4:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ad9:	6a 00                	push   $0x0
  801adb:	6a 00                	push   $0x0
  801add:	6a 00                	push   $0x0
  801adf:	6a 00                	push   $0x0
  801ae1:	ff 75 08             	pushl  0x8(%ebp)
  801ae4:	6a 26                	push   $0x26
  801ae6:	e8 67 fb ff ff       	call   801652 <syscall>
  801aeb:	83 c4 18             	add    $0x18,%esp
	return ;
  801aee:	90                   	nop
}
  801aef:	c9                   	leave  
  801af0:	c3                   	ret    

00801af1 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801af1:	55                   	push   %ebp
  801af2:	89 e5                	mov    %esp,%ebp
  801af4:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801af5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801af8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801afb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801afe:	8b 45 08             	mov    0x8(%ebp),%eax
  801b01:	6a 00                	push   $0x0
  801b03:	53                   	push   %ebx
  801b04:	51                   	push   %ecx
  801b05:	52                   	push   %edx
  801b06:	50                   	push   %eax
  801b07:	6a 27                	push   $0x27
  801b09:	e8 44 fb ff ff       	call   801652 <syscall>
  801b0e:	83 c4 18             	add    $0x18,%esp
}
  801b11:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b14:	c9                   	leave  
  801b15:	c3                   	ret    

00801b16 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801b16:	55                   	push   %ebp
  801b17:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801b19:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1f:	6a 00                	push   $0x0
  801b21:	6a 00                	push   $0x0
  801b23:	6a 00                	push   $0x0
  801b25:	52                   	push   %edx
  801b26:	50                   	push   %eax
  801b27:	6a 28                	push   $0x28
  801b29:	e8 24 fb ff ff       	call   801652 <syscall>
  801b2e:	83 c4 18             	add    $0x18,%esp
}
  801b31:	c9                   	leave  
  801b32:	c3                   	ret    

00801b33 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801b33:	55                   	push   %ebp
  801b34:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801b36:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b39:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3f:	6a 00                	push   $0x0
  801b41:	51                   	push   %ecx
  801b42:	ff 75 10             	pushl  0x10(%ebp)
  801b45:	52                   	push   %edx
  801b46:	50                   	push   %eax
  801b47:	6a 29                	push   $0x29
  801b49:	e8 04 fb ff ff       	call   801652 <syscall>
  801b4e:	83 c4 18             	add    $0x18,%esp
}
  801b51:	c9                   	leave  
  801b52:	c3                   	ret    

00801b53 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b53:	55                   	push   %ebp
  801b54:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b56:	6a 00                	push   $0x0
  801b58:	6a 00                	push   $0x0
  801b5a:	ff 75 10             	pushl  0x10(%ebp)
  801b5d:	ff 75 0c             	pushl  0xc(%ebp)
  801b60:	ff 75 08             	pushl  0x8(%ebp)
  801b63:	6a 12                	push   $0x12
  801b65:	e8 e8 fa ff ff       	call   801652 <syscall>
  801b6a:	83 c4 18             	add    $0x18,%esp
	return ;
  801b6d:	90                   	nop
}
  801b6e:	c9                   	leave  
  801b6f:	c3                   	ret    

00801b70 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801b70:	55                   	push   %ebp
  801b71:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801b73:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b76:	8b 45 08             	mov    0x8(%ebp),%eax
  801b79:	6a 00                	push   $0x0
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 00                	push   $0x0
  801b7f:	52                   	push   %edx
  801b80:	50                   	push   %eax
  801b81:	6a 2a                	push   $0x2a
  801b83:	e8 ca fa ff ff       	call   801652 <syscall>
  801b88:	83 c4 18             	add    $0x18,%esp
	return;
  801b8b:	90                   	nop
}
  801b8c:	c9                   	leave  
  801b8d:	c3                   	ret    

00801b8e <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801b8e:	55                   	push   %ebp
  801b8f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801b91:	6a 00                	push   $0x0
  801b93:	6a 00                	push   $0x0
  801b95:	6a 00                	push   $0x0
  801b97:	6a 00                	push   $0x0
  801b99:	6a 00                	push   $0x0
  801b9b:	6a 2b                	push   $0x2b
  801b9d:	e8 b0 fa ff ff       	call   801652 <syscall>
  801ba2:	83 c4 18             	add    $0x18,%esp
}
  801ba5:	c9                   	leave  
  801ba6:	c3                   	ret    

00801ba7 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801ba7:	55                   	push   %ebp
  801ba8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801baa:	6a 00                	push   $0x0
  801bac:	6a 00                	push   $0x0
  801bae:	6a 00                	push   $0x0
  801bb0:	ff 75 0c             	pushl  0xc(%ebp)
  801bb3:	ff 75 08             	pushl  0x8(%ebp)
  801bb6:	6a 2d                	push   $0x2d
  801bb8:	e8 95 fa ff ff       	call   801652 <syscall>
  801bbd:	83 c4 18             	add    $0x18,%esp
	return;
  801bc0:	90                   	nop
}
  801bc1:	c9                   	leave  
  801bc2:	c3                   	ret    

00801bc3 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801bc3:	55                   	push   %ebp
  801bc4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801bc6:	6a 00                	push   $0x0
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 00                	push   $0x0
  801bcc:	ff 75 0c             	pushl  0xc(%ebp)
  801bcf:	ff 75 08             	pushl  0x8(%ebp)
  801bd2:	6a 2c                	push   $0x2c
  801bd4:	e8 79 fa ff ff       	call   801652 <syscall>
  801bd9:	83 c4 18             	add    $0x18,%esp
	return ;
  801bdc:	90                   	nop
}
  801bdd:	c9                   	leave  
  801bde:	c3                   	ret    

00801bdf <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801bdf:	55                   	push   %ebp
  801be0:	89 e5                	mov    %esp,%ebp
  801be2:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801be5:	83 ec 04             	sub    $0x4,%esp
  801be8:	68 d4 27 80 00       	push   $0x8027d4
  801bed:	68 25 01 00 00       	push   $0x125
  801bf2:	68 07 28 80 00       	push   $0x802807
  801bf7:	e8 ec e6 ff ff       	call   8002e8 <_panic>

00801bfc <to_page_va>:
//==================================================================================//
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  801bfc:	55                   	push   %ebp
  801bfd:	89 e5                	mov    %esp,%ebp
  801bff:	83 ec 10             	sub    $0x10,%esp
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  801c02:	8b 45 08             	mov    0x8(%ebp),%eax
  801c05:	ba 60 30 80 00       	mov    $0x803060,%edx
  801c0a:	29 d0                	sub    %edx,%eax
  801c0c:	c1 f8 02             	sar    $0x2,%eax
  801c0f:	89 c2                	mov    %eax,%edx
  801c11:	89 d0                	mov    %edx,%eax
  801c13:	c1 e0 02             	shl    $0x2,%eax
  801c16:	01 d0                	add    %edx,%eax
  801c18:	c1 e0 02             	shl    $0x2,%eax
  801c1b:	01 d0                	add    %edx,%eax
  801c1d:	c1 e0 02             	shl    $0x2,%eax
  801c20:	01 d0                	add    %edx,%eax
  801c22:	89 c1                	mov    %eax,%ecx
  801c24:	c1 e1 08             	shl    $0x8,%ecx
  801c27:	01 c8                	add    %ecx,%eax
  801c29:	89 c1                	mov    %eax,%ecx
  801c2b:	c1 e1 10             	shl    $0x10,%ecx
  801c2e:	01 c8                	add    %ecx,%eax
  801c30:	01 c0                	add    %eax,%eax
  801c32:	01 d0                	add    %edx,%eax
  801c34:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  801c37:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c3a:	c1 e0 0c             	shl    $0xc,%eax
  801c3d:	89 c2                	mov    %eax,%edx
  801c3f:	a1 64 b0 81 00       	mov    0x81b064,%eax
  801c44:	01 d0                	add    %edx,%eax
}
  801c46:	c9                   	leave  
  801c47:	c3                   	ret    

00801c48 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  801c48:	55                   	push   %ebp
  801c49:	89 e5                	mov    %esp,%ebp
  801c4b:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  801c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c51:	05 00 00 00 02       	add    $0x2000000,%eax
  801c56:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801c59:	73 16                	jae    801c71 <initialize_dynamic_allocator+0x29>
  801c5b:	68 18 28 80 00       	push   $0x802818
  801c60:	68 3e 28 80 00       	push   $0x80283e
  801c65:	6a 26                	push   $0x26
  801c67:	68 53 28 80 00       	push   $0x802853
  801c6c:	e8 77 e6 ff ff       	call   8002e8 <_panic>
		is_initialized = 1;
  801c71:	c7 05 24 30 80 00 01 	movl   $0x1,0x803024
  801c78:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	//Comment the following line
	panic("initialize_dynamic_allocator() Not implemented yet");
  801c7b:	83 ec 04             	sub    $0x4,%esp
  801c7e:	68 6c 28 80 00       	push   $0x80286c
  801c83:	6a 2e                	push   $0x2e
  801c85:	68 53 28 80 00       	push   $0x802853
  801c8a:	e8 59 e6 ff ff       	call   8002e8 <_panic>

00801c8f <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  801c8f:	55                   	push   %ebp
  801c90:	89 e5                	mov    %esp,%ebp
  801c92:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	//Comment the following line
	panic("get_block_size() Not implemented yet");
  801c95:	83 ec 04             	sub    $0x4,%esp
  801c98:	68 a0 28 80 00       	push   $0x8028a0
  801c9d:	6a 3a                	push   $0x3a
  801c9f:	68 53 28 80 00       	push   $0x802853
  801ca4:	e8 3f e6 ff ff       	call   8002e8 <_panic>

00801ca9 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  801ca9:	55                   	push   %ebp
  801caa:	89 e5                	mov    %esp,%ebp
  801cac:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  801caf:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801cb6:	76 16                	jbe    801cce <alloc_block+0x25>
  801cb8:	68 c8 28 80 00       	push   $0x8028c8
  801cbd:	68 3e 28 80 00       	push   $0x80283e
  801cc2:	6a 46                	push   $0x46
  801cc4:	68 53 28 80 00       	push   $0x802853
  801cc9:	e8 1a e6 ff ff       	call   8002e8 <_panic>
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	panic("alloc_block() Not implemented yet");
  801cce:	83 ec 04             	sub    $0x4,%esp
  801cd1:	68 ec 28 80 00       	push   $0x8028ec
  801cd6:	6a 4d                	push   $0x4d
  801cd8:	68 53 28 80 00       	push   $0x802853
  801cdd:	e8 06 e6 ff ff       	call   8002e8 <_panic>

00801ce2 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  801ce2:	55                   	push   %ebp
  801ce3:	89 e5                	mov    %esp,%ebp
  801ce5:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  801ce8:	8b 55 08             	mov    0x8(%ebp),%edx
  801ceb:	a1 64 b0 81 00       	mov    0x81b064,%eax
  801cf0:	39 c2                	cmp    %eax,%edx
  801cf2:	72 0c                	jb     801d00 <free_block+0x1e>
  801cf4:	8b 55 08             	mov    0x8(%ebp),%edx
  801cf7:	a1 40 30 80 00       	mov    0x803040,%eax
  801cfc:	39 c2                	cmp    %eax,%edx
  801cfe:	72 16                	jb     801d16 <free_block+0x34>
  801d00:	68 10 29 80 00       	push   $0x802910
  801d05:	68 3e 28 80 00       	push   $0x80283e
  801d0a:	6a 5b                	push   $0x5b
  801d0c:	68 53 28 80 00       	push   $0x802853
  801d11:	e8 d2 e5 ff ff       	call   8002e8 <_panic>
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	panic("free_block() Not implemented yet");
  801d16:	83 ec 04             	sub    $0x4,%esp
  801d19:	68 48 29 80 00       	push   $0x802948
  801d1e:	6a 63                	push   $0x63
  801d20:	68 53 28 80 00       	push   $0x802853
  801d25:	e8 be e5 ff ff       	call   8002e8 <_panic>

00801d2a <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  801d2a:	55                   	push   %ebp
  801d2b:	89 e5                	mov    %esp,%ebp
  801d2d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  801d30:	83 ec 04             	sub    $0x4,%esp
  801d33:	68 6c 29 80 00       	push   $0x80296c
  801d38:	6a 72                	push   $0x72
  801d3a:	68 53 28 80 00       	push   $0x802853
  801d3f:	e8 a4 e5 ff ff       	call   8002e8 <_panic>

00801d44 <__udivdi3>:
  801d44:	55                   	push   %ebp
  801d45:	57                   	push   %edi
  801d46:	56                   	push   %esi
  801d47:	53                   	push   %ebx
  801d48:	83 ec 1c             	sub    $0x1c,%esp
  801d4b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801d4f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801d53:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d57:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d5b:	89 ca                	mov    %ecx,%edx
  801d5d:	89 f8                	mov    %edi,%eax
  801d5f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801d63:	85 f6                	test   %esi,%esi
  801d65:	75 2d                	jne    801d94 <__udivdi3+0x50>
  801d67:	39 cf                	cmp    %ecx,%edi
  801d69:	77 65                	ja     801dd0 <__udivdi3+0x8c>
  801d6b:	89 fd                	mov    %edi,%ebp
  801d6d:	85 ff                	test   %edi,%edi
  801d6f:	75 0b                	jne    801d7c <__udivdi3+0x38>
  801d71:	b8 01 00 00 00       	mov    $0x1,%eax
  801d76:	31 d2                	xor    %edx,%edx
  801d78:	f7 f7                	div    %edi
  801d7a:	89 c5                	mov    %eax,%ebp
  801d7c:	31 d2                	xor    %edx,%edx
  801d7e:	89 c8                	mov    %ecx,%eax
  801d80:	f7 f5                	div    %ebp
  801d82:	89 c1                	mov    %eax,%ecx
  801d84:	89 d8                	mov    %ebx,%eax
  801d86:	f7 f5                	div    %ebp
  801d88:	89 cf                	mov    %ecx,%edi
  801d8a:	89 fa                	mov    %edi,%edx
  801d8c:	83 c4 1c             	add    $0x1c,%esp
  801d8f:	5b                   	pop    %ebx
  801d90:	5e                   	pop    %esi
  801d91:	5f                   	pop    %edi
  801d92:	5d                   	pop    %ebp
  801d93:	c3                   	ret    
  801d94:	39 ce                	cmp    %ecx,%esi
  801d96:	77 28                	ja     801dc0 <__udivdi3+0x7c>
  801d98:	0f bd fe             	bsr    %esi,%edi
  801d9b:	83 f7 1f             	xor    $0x1f,%edi
  801d9e:	75 40                	jne    801de0 <__udivdi3+0x9c>
  801da0:	39 ce                	cmp    %ecx,%esi
  801da2:	72 0a                	jb     801dae <__udivdi3+0x6a>
  801da4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801da8:	0f 87 9e 00 00 00    	ja     801e4c <__udivdi3+0x108>
  801dae:	b8 01 00 00 00       	mov    $0x1,%eax
  801db3:	89 fa                	mov    %edi,%edx
  801db5:	83 c4 1c             	add    $0x1c,%esp
  801db8:	5b                   	pop    %ebx
  801db9:	5e                   	pop    %esi
  801dba:	5f                   	pop    %edi
  801dbb:	5d                   	pop    %ebp
  801dbc:	c3                   	ret    
  801dbd:	8d 76 00             	lea    0x0(%esi),%esi
  801dc0:	31 ff                	xor    %edi,%edi
  801dc2:	31 c0                	xor    %eax,%eax
  801dc4:	89 fa                	mov    %edi,%edx
  801dc6:	83 c4 1c             	add    $0x1c,%esp
  801dc9:	5b                   	pop    %ebx
  801dca:	5e                   	pop    %esi
  801dcb:	5f                   	pop    %edi
  801dcc:	5d                   	pop    %ebp
  801dcd:	c3                   	ret    
  801dce:	66 90                	xchg   %ax,%ax
  801dd0:	89 d8                	mov    %ebx,%eax
  801dd2:	f7 f7                	div    %edi
  801dd4:	31 ff                	xor    %edi,%edi
  801dd6:	89 fa                	mov    %edi,%edx
  801dd8:	83 c4 1c             	add    $0x1c,%esp
  801ddb:	5b                   	pop    %ebx
  801ddc:	5e                   	pop    %esi
  801ddd:	5f                   	pop    %edi
  801dde:	5d                   	pop    %ebp
  801ddf:	c3                   	ret    
  801de0:	bd 20 00 00 00       	mov    $0x20,%ebp
  801de5:	89 eb                	mov    %ebp,%ebx
  801de7:	29 fb                	sub    %edi,%ebx
  801de9:	89 f9                	mov    %edi,%ecx
  801deb:	d3 e6                	shl    %cl,%esi
  801ded:	89 c5                	mov    %eax,%ebp
  801def:	88 d9                	mov    %bl,%cl
  801df1:	d3 ed                	shr    %cl,%ebp
  801df3:	89 e9                	mov    %ebp,%ecx
  801df5:	09 f1                	or     %esi,%ecx
  801df7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801dfb:	89 f9                	mov    %edi,%ecx
  801dfd:	d3 e0                	shl    %cl,%eax
  801dff:	89 c5                	mov    %eax,%ebp
  801e01:	89 d6                	mov    %edx,%esi
  801e03:	88 d9                	mov    %bl,%cl
  801e05:	d3 ee                	shr    %cl,%esi
  801e07:	89 f9                	mov    %edi,%ecx
  801e09:	d3 e2                	shl    %cl,%edx
  801e0b:	8b 44 24 08          	mov    0x8(%esp),%eax
  801e0f:	88 d9                	mov    %bl,%cl
  801e11:	d3 e8                	shr    %cl,%eax
  801e13:	09 c2                	or     %eax,%edx
  801e15:	89 d0                	mov    %edx,%eax
  801e17:	89 f2                	mov    %esi,%edx
  801e19:	f7 74 24 0c          	divl   0xc(%esp)
  801e1d:	89 d6                	mov    %edx,%esi
  801e1f:	89 c3                	mov    %eax,%ebx
  801e21:	f7 e5                	mul    %ebp
  801e23:	39 d6                	cmp    %edx,%esi
  801e25:	72 19                	jb     801e40 <__udivdi3+0xfc>
  801e27:	74 0b                	je     801e34 <__udivdi3+0xf0>
  801e29:	89 d8                	mov    %ebx,%eax
  801e2b:	31 ff                	xor    %edi,%edi
  801e2d:	e9 58 ff ff ff       	jmp    801d8a <__udivdi3+0x46>
  801e32:	66 90                	xchg   %ax,%ax
  801e34:	8b 54 24 08          	mov    0x8(%esp),%edx
  801e38:	89 f9                	mov    %edi,%ecx
  801e3a:	d3 e2                	shl    %cl,%edx
  801e3c:	39 c2                	cmp    %eax,%edx
  801e3e:	73 e9                	jae    801e29 <__udivdi3+0xe5>
  801e40:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801e43:	31 ff                	xor    %edi,%edi
  801e45:	e9 40 ff ff ff       	jmp    801d8a <__udivdi3+0x46>
  801e4a:	66 90                	xchg   %ax,%ax
  801e4c:	31 c0                	xor    %eax,%eax
  801e4e:	e9 37 ff ff ff       	jmp    801d8a <__udivdi3+0x46>
  801e53:	90                   	nop

00801e54 <__umoddi3>:
  801e54:	55                   	push   %ebp
  801e55:	57                   	push   %edi
  801e56:	56                   	push   %esi
  801e57:	53                   	push   %ebx
  801e58:	83 ec 1c             	sub    $0x1c,%esp
  801e5b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801e5f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801e63:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801e67:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801e6b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e6f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801e73:	89 f3                	mov    %esi,%ebx
  801e75:	89 fa                	mov    %edi,%edx
  801e77:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e7b:	89 34 24             	mov    %esi,(%esp)
  801e7e:	85 c0                	test   %eax,%eax
  801e80:	75 1a                	jne    801e9c <__umoddi3+0x48>
  801e82:	39 f7                	cmp    %esi,%edi
  801e84:	0f 86 a2 00 00 00    	jbe    801f2c <__umoddi3+0xd8>
  801e8a:	89 c8                	mov    %ecx,%eax
  801e8c:	89 f2                	mov    %esi,%edx
  801e8e:	f7 f7                	div    %edi
  801e90:	89 d0                	mov    %edx,%eax
  801e92:	31 d2                	xor    %edx,%edx
  801e94:	83 c4 1c             	add    $0x1c,%esp
  801e97:	5b                   	pop    %ebx
  801e98:	5e                   	pop    %esi
  801e99:	5f                   	pop    %edi
  801e9a:	5d                   	pop    %ebp
  801e9b:	c3                   	ret    
  801e9c:	39 f0                	cmp    %esi,%eax
  801e9e:	0f 87 ac 00 00 00    	ja     801f50 <__umoddi3+0xfc>
  801ea4:	0f bd e8             	bsr    %eax,%ebp
  801ea7:	83 f5 1f             	xor    $0x1f,%ebp
  801eaa:	0f 84 ac 00 00 00    	je     801f5c <__umoddi3+0x108>
  801eb0:	bf 20 00 00 00       	mov    $0x20,%edi
  801eb5:	29 ef                	sub    %ebp,%edi
  801eb7:	89 fe                	mov    %edi,%esi
  801eb9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801ebd:	89 e9                	mov    %ebp,%ecx
  801ebf:	d3 e0                	shl    %cl,%eax
  801ec1:	89 d7                	mov    %edx,%edi
  801ec3:	89 f1                	mov    %esi,%ecx
  801ec5:	d3 ef                	shr    %cl,%edi
  801ec7:	09 c7                	or     %eax,%edi
  801ec9:	89 e9                	mov    %ebp,%ecx
  801ecb:	d3 e2                	shl    %cl,%edx
  801ecd:	89 14 24             	mov    %edx,(%esp)
  801ed0:	89 d8                	mov    %ebx,%eax
  801ed2:	d3 e0                	shl    %cl,%eax
  801ed4:	89 c2                	mov    %eax,%edx
  801ed6:	8b 44 24 08          	mov    0x8(%esp),%eax
  801eda:	d3 e0                	shl    %cl,%eax
  801edc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ee0:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ee4:	89 f1                	mov    %esi,%ecx
  801ee6:	d3 e8                	shr    %cl,%eax
  801ee8:	09 d0                	or     %edx,%eax
  801eea:	d3 eb                	shr    %cl,%ebx
  801eec:	89 da                	mov    %ebx,%edx
  801eee:	f7 f7                	div    %edi
  801ef0:	89 d3                	mov    %edx,%ebx
  801ef2:	f7 24 24             	mull   (%esp)
  801ef5:	89 c6                	mov    %eax,%esi
  801ef7:	89 d1                	mov    %edx,%ecx
  801ef9:	39 d3                	cmp    %edx,%ebx
  801efb:	0f 82 87 00 00 00    	jb     801f88 <__umoddi3+0x134>
  801f01:	0f 84 91 00 00 00    	je     801f98 <__umoddi3+0x144>
  801f07:	8b 54 24 04          	mov    0x4(%esp),%edx
  801f0b:	29 f2                	sub    %esi,%edx
  801f0d:	19 cb                	sbb    %ecx,%ebx
  801f0f:	89 d8                	mov    %ebx,%eax
  801f11:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801f15:	d3 e0                	shl    %cl,%eax
  801f17:	89 e9                	mov    %ebp,%ecx
  801f19:	d3 ea                	shr    %cl,%edx
  801f1b:	09 d0                	or     %edx,%eax
  801f1d:	89 e9                	mov    %ebp,%ecx
  801f1f:	d3 eb                	shr    %cl,%ebx
  801f21:	89 da                	mov    %ebx,%edx
  801f23:	83 c4 1c             	add    $0x1c,%esp
  801f26:	5b                   	pop    %ebx
  801f27:	5e                   	pop    %esi
  801f28:	5f                   	pop    %edi
  801f29:	5d                   	pop    %ebp
  801f2a:	c3                   	ret    
  801f2b:	90                   	nop
  801f2c:	89 fd                	mov    %edi,%ebp
  801f2e:	85 ff                	test   %edi,%edi
  801f30:	75 0b                	jne    801f3d <__umoddi3+0xe9>
  801f32:	b8 01 00 00 00       	mov    $0x1,%eax
  801f37:	31 d2                	xor    %edx,%edx
  801f39:	f7 f7                	div    %edi
  801f3b:	89 c5                	mov    %eax,%ebp
  801f3d:	89 f0                	mov    %esi,%eax
  801f3f:	31 d2                	xor    %edx,%edx
  801f41:	f7 f5                	div    %ebp
  801f43:	89 c8                	mov    %ecx,%eax
  801f45:	f7 f5                	div    %ebp
  801f47:	89 d0                	mov    %edx,%eax
  801f49:	e9 44 ff ff ff       	jmp    801e92 <__umoddi3+0x3e>
  801f4e:	66 90                	xchg   %ax,%ax
  801f50:	89 c8                	mov    %ecx,%eax
  801f52:	89 f2                	mov    %esi,%edx
  801f54:	83 c4 1c             	add    $0x1c,%esp
  801f57:	5b                   	pop    %ebx
  801f58:	5e                   	pop    %esi
  801f59:	5f                   	pop    %edi
  801f5a:	5d                   	pop    %ebp
  801f5b:	c3                   	ret    
  801f5c:	3b 04 24             	cmp    (%esp),%eax
  801f5f:	72 06                	jb     801f67 <__umoddi3+0x113>
  801f61:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801f65:	77 0f                	ja     801f76 <__umoddi3+0x122>
  801f67:	89 f2                	mov    %esi,%edx
  801f69:	29 f9                	sub    %edi,%ecx
  801f6b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801f6f:	89 14 24             	mov    %edx,(%esp)
  801f72:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801f76:	8b 44 24 04          	mov    0x4(%esp),%eax
  801f7a:	8b 14 24             	mov    (%esp),%edx
  801f7d:	83 c4 1c             	add    $0x1c,%esp
  801f80:	5b                   	pop    %ebx
  801f81:	5e                   	pop    %esi
  801f82:	5f                   	pop    %edi
  801f83:	5d                   	pop    %ebp
  801f84:	c3                   	ret    
  801f85:	8d 76 00             	lea    0x0(%esi),%esi
  801f88:	2b 04 24             	sub    (%esp),%eax
  801f8b:	19 fa                	sbb    %edi,%edx
  801f8d:	89 d1                	mov    %edx,%ecx
  801f8f:	89 c6                	mov    %eax,%esi
  801f91:	e9 71 ff ff ff       	jmp    801f07 <__umoddi3+0xb3>
  801f96:	66 90                	xchg   %ax,%ax
  801f98:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801f9c:	72 ea                	jb     801f88 <__umoddi3+0x134>
  801f9e:	89 d9                	mov    %ebx,%ecx
  801fa0:	e9 62 ff ff ff       	jmp    801f07 <__umoddi3+0xb3>


obj/user/tst_chan_one_slave:     file format elf32-i386


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
  800031:	e8 6d 00 00 00       	call   8000a3 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Slave program: sleep, increment test after wakeup
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
	int envID = sys_getenvid();
  80003e:	e8 a4 14 00 00       	call   8014e7 <sys_getenvid>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)

	//Sleep on the channel
	sys_utilities("__Sleep__", 0);
  800046:	83 ec 08             	sub    $0x8,%esp
  800049:	6a 00                	push   $0x0
  80004b:	68 e0 1c 80 00       	push   $0x801ce0
  800050:	e8 e1 16 00 00       	call   801736 <sys_utilities>
  800055:	83 c4 10             	add    $0x10,%esp

	//wait for a while
	env_sleep(RAND(1000, 5000));
  800058:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80005b:	83 ec 0c             	sub    $0xc,%esp
  80005e:	50                   	push   %eax
  80005f:	e8 e8 14 00 00       	call   80154c <sys_get_virtual_time>
  800064:	83 c4 0c             	add    $0xc,%esp
  800067:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80006a:	b9 a0 0f 00 00       	mov    $0xfa0,%ecx
  80006f:	ba 00 00 00 00       	mov    $0x0,%edx
  800074:	f7 f1                	div    %ecx
  800076:	89 d0                	mov    %edx,%eax
  800078:	05 e8 03 00 00       	add    $0x3e8,%eax
  80007d:	83 ec 0c             	sub    $0xc,%esp
  800080:	50                   	push   %eax
  800081:	e8 3c 17 00 00       	call   8017c2 <env_sleep>
  800086:	83 c4 10             	add    $0x10,%esp

	//wakeup another one
	sys_utilities("__WakeupOne__", 0);
  800089:	83 ec 08             	sub    $0x8,%esp
  80008c:	6a 00                	push   $0x0
  80008e:	68 ea 1c 80 00       	push   $0x801cea
  800093:	e8 9e 16 00 00       	call   801736 <sys_utilities>
  800098:	83 c4 10             	add    $0x10,%esp

	//indicates wakenup
	inctst();
  80009b:	e8 9e 15 00 00       	call   80163e <inctst>

	return;
  8000a0:	90                   	nop
}
  8000a1:	c9                   	leave  
  8000a2:	c3                   	ret    

008000a3 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8000a3:	55                   	push   %ebp
  8000a4:	89 e5                	mov    %esp,%ebp
  8000a6:	57                   	push   %edi
  8000a7:	56                   	push   %esi
  8000a8:	53                   	push   %ebx
  8000a9:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8000ac:	e8 4f 14 00 00       	call   801500 <sys_getenvindex>
  8000b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8000b4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8000b7:	89 d0                	mov    %edx,%eax
  8000b9:	c1 e0 02             	shl    $0x2,%eax
  8000bc:	01 d0                	add    %edx,%eax
  8000be:	c1 e0 03             	shl    $0x3,%eax
  8000c1:	01 d0                	add    %edx,%eax
  8000c3:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8000ca:	01 d0                	add    %edx,%eax
  8000cc:	c1 e0 02             	shl    $0x2,%eax
  8000cf:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000d4:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8000d9:	a1 20 30 80 00       	mov    0x803020,%eax
  8000de:	8a 40 20             	mov    0x20(%eax),%al
  8000e1:	84 c0                	test   %al,%al
  8000e3:	74 0d                	je     8000f2 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8000e5:	a1 20 30 80 00       	mov    0x803020,%eax
  8000ea:	83 c0 20             	add    $0x20,%eax
  8000ed:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000f2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000f6:	7e 0a                	jle    800102 <libmain+0x5f>
		binaryname = argv[0];
  8000f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000fb:	8b 00                	mov    (%eax),%eax
  8000fd:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  800102:	83 ec 08             	sub    $0x8,%esp
  800105:	ff 75 0c             	pushl  0xc(%ebp)
  800108:	ff 75 08             	pushl  0x8(%ebp)
  80010b:	e8 28 ff ff ff       	call   800038 <_main>
  800110:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800113:	a1 00 30 80 00       	mov    0x803000,%eax
  800118:	85 c0                	test   %eax,%eax
  80011a:	0f 84 01 01 00 00    	je     800221 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800120:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800126:	bb f0 1d 80 00       	mov    $0x801df0,%ebx
  80012b:	ba 0e 00 00 00       	mov    $0xe,%edx
  800130:	89 c7                	mov    %eax,%edi
  800132:	89 de                	mov    %ebx,%esi
  800134:	89 d1                	mov    %edx,%ecx
  800136:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800138:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80013b:	b9 56 00 00 00       	mov    $0x56,%ecx
  800140:	b0 00                	mov    $0x0,%al
  800142:	89 d7                	mov    %edx,%edi
  800144:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800146:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80014d:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800150:	83 ec 08             	sub    $0x8,%esp
  800153:	50                   	push   %eax
  800154:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80015a:	50                   	push   %eax
  80015b:	e8 d6 15 00 00       	call   801736 <sys_utilities>
  800160:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800163:	e8 1f 11 00 00       	call   801287 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800168:	83 ec 0c             	sub    $0xc,%esp
  80016b:	68 10 1d 80 00       	push   $0x801d10
  800170:	e8 be 01 00 00       	call   800333 <cprintf>
  800175:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800178:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80017b:	85 c0                	test   %eax,%eax
  80017d:	74 18                	je     800197 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80017f:	e8 d0 15 00 00       	call   801754 <sys_get_optimal_num_faults>
  800184:	83 ec 08             	sub    $0x8,%esp
  800187:	50                   	push   %eax
  800188:	68 38 1d 80 00       	push   $0x801d38
  80018d:	e8 a1 01 00 00       	call   800333 <cprintf>
  800192:	83 c4 10             	add    $0x10,%esp
  800195:	eb 59                	jmp    8001f0 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800197:	a1 20 30 80 00       	mov    0x803020,%eax
  80019c:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8001a2:	a1 20 30 80 00       	mov    0x803020,%eax
  8001a7:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  8001ad:	83 ec 04             	sub    $0x4,%esp
  8001b0:	52                   	push   %edx
  8001b1:	50                   	push   %eax
  8001b2:	68 5c 1d 80 00       	push   $0x801d5c
  8001b7:	e8 77 01 00 00       	call   800333 <cprintf>
  8001bc:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001bf:	a1 20 30 80 00       	mov    0x803020,%eax
  8001c4:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8001ca:	a1 20 30 80 00       	mov    0x803020,%eax
  8001cf:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  8001d5:	a1 20 30 80 00       	mov    0x803020,%eax
  8001da:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  8001e0:	51                   	push   %ecx
  8001e1:	52                   	push   %edx
  8001e2:	50                   	push   %eax
  8001e3:	68 84 1d 80 00       	push   $0x801d84
  8001e8:	e8 46 01 00 00       	call   800333 <cprintf>
  8001ed:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001f0:	a1 20 30 80 00       	mov    0x803020,%eax
  8001f5:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  8001fb:	83 ec 08             	sub    $0x8,%esp
  8001fe:	50                   	push   %eax
  8001ff:	68 dc 1d 80 00       	push   $0x801ddc
  800204:	e8 2a 01 00 00       	call   800333 <cprintf>
  800209:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80020c:	83 ec 0c             	sub    $0xc,%esp
  80020f:	68 10 1d 80 00       	push   $0x801d10
  800214:	e8 1a 01 00 00       	call   800333 <cprintf>
  800219:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80021c:	e8 80 10 00 00       	call   8012a1 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800221:	e8 1f 00 00 00       	call   800245 <exit>
}
  800226:	90                   	nop
  800227:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80022a:	5b                   	pop    %ebx
  80022b:	5e                   	pop    %esi
  80022c:	5f                   	pop    %edi
  80022d:	5d                   	pop    %ebp
  80022e:	c3                   	ret    

0080022f <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80022f:	55                   	push   %ebp
  800230:	89 e5                	mov    %esp,%ebp
  800232:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800235:	83 ec 0c             	sub    $0xc,%esp
  800238:	6a 00                	push   $0x0
  80023a:	e8 8d 12 00 00       	call   8014cc <sys_destroy_env>
  80023f:	83 c4 10             	add    $0x10,%esp
}
  800242:	90                   	nop
  800243:	c9                   	leave  
  800244:	c3                   	ret    

00800245 <exit>:

void
exit(void)
{
  800245:	55                   	push   %ebp
  800246:	89 e5                	mov    %esp,%ebp
  800248:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80024b:	e8 e2 12 00 00       	call   801532 <sys_exit_env>
}
  800250:	90                   	nop
  800251:	c9                   	leave  
  800252:	c3                   	ret    

00800253 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800253:	55                   	push   %ebp
  800254:	89 e5                	mov    %esp,%ebp
  800256:	53                   	push   %ebx
  800257:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  80025a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80025d:	8b 00                	mov    (%eax),%eax
  80025f:	8d 48 01             	lea    0x1(%eax),%ecx
  800262:	8b 55 0c             	mov    0xc(%ebp),%edx
  800265:	89 0a                	mov    %ecx,(%edx)
  800267:	8b 55 08             	mov    0x8(%ebp),%edx
  80026a:	88 d1                	mov    %dl,%cl
  80026c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80026f:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800273:	8b 45 0c             	mov    0xc(%ebp),%eax
  800276:	8b 00                	mov    (%eax),%eax
  800278:	3d ff 00 00 00       	cmp    $0xff,%eax
  80027d:	75 30                	jne    8002af <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  80027f:	8b 15 18 b1 81 00    	mov    0x81b118,%edx
  800285:	a0 44 30 80 00       	mov    0x803044,%al
  80028a:	0f b6 c0             	movzbl %al,%eax
  80028d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800290:	8b 09                	mov    (%ecx),%ecx
  800292:	89 cb                	mov    %ecx,%ebx
  800294:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800297:	83 c1 08             	add    $0x8,%ecx
  80029a:	52                   	push   %edx
  80029b:	50                   	push   %eax
  80029c:	53                   	push   %ebx
  80029d:	51                   	push   %ecx
  80029e:	e8 a0 0f 00 00       	call   801243 <sys_cputs>
  8002a3:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8002a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8002af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002b2:	8b 40 04             	mov    0x4(%eax),%eax
  8002b5:	8d 50 01             	lea    0x1(%eax),%edx
  8002b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002bb:	89 50 04             	mov    %edx,0x4(%eax)
}
  8002be:	90                   	nop
  8002bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002c2:	c9                   	leave  
  8002c3:	c3                   	ret    

008002c4 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8002c4:	55                   	push   %ebp
  8002c5:	89 e5                	mov    %esp,%ebp
  8002c7:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002cd:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002d4:	00 00 00 
	b.cnt = 0;
  8002d7:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002de:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8002e1:	ff 75 0c             	pushl  0xc(%ebp)
  8002e4:	ff 75 08             	pushl  0x8(%ebp)
  8002e7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002ed:	50                   	push   %eax
  8002ee:	68 53 02 80 00       	push   $0x800253
  8002f3:	e8 5a 02 00 00       	call   800552 <vprintfmt>
  8002f8:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8002fb:	8b 15 18 b1 81 00    	mov    0x81b118,%edx
  800301:	a0 44 30 80 00       	mov    0x803044,%al
  800306:	0f b6 c0             	movzbl %al,%eax
  800309:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  80030f:	52                   	push   %edx
  800310:	50                   	push   %eax
  800311:	51                   	push   %ecx
  800312:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800318:	83 c0 08             	add    $0x8,%eax
  80031b:	50                   	push   %eax
  80031c:	e8 22 0f 00 00       	call   801243 <sys_cputs>
  800321:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800324:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  80032b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800331:	c9                   	leave  
  800332:	c3                   	ret    

00800333 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800333:	55                   	push   %ebp
  800334:	89 e5                	mov    %esp,%ebp
  800336:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800339:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  800340:	8d 45 0c             	lea    0xc(%ebp),%eax
  800343:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800346:	8b 45 08             	mov    0x8(%ebp),%eax
  800349:	83 ec 08             	sub    $0x8,%esp
  80034c:	ff 75 f4             	pushl  -0xc(%ebp)
  80034f:	50                   	push   %eax
  800350:	e8 6f ff ff ff       	call   8002c4 <vcprintf>
  800355:	83 c4 10             	add    $0x10,%esp
  800358:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80035b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80035e:	c9                   	leave  
  80035f:	c3                   	ret    

00800360 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800360:	55                   	push   %ebp
  800361:	89 e5                	mov    %esp,%ebp
  800363:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800366:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  80036d:	8b 45 08             	mov    0x8(%ebp),%eax
  800370:	c1 e0 08             	shl    $0x8,%eax
  800373:	a3 18 b1 81 00       	mov    %eax,0x81b118
	va_start(ap, fmt);
  800378:	8d 45 0c             	lea    0xc(%ebp),%eax
  80037b:	83 c0 04             	add    $0x4,%eax
  80037e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800381:	8b 45 0c             	mov    0xc(%ebp),%eax
  800384:	83 ec 08             	sub    $0x8,%esp
  800387:	ff 75 f4             	pushl  -0xc(%ebp)
  80038a:	50                   	push   %eax
  80038b:	e8 34 ff ff ff       	call   8002c4 <vcprintf>
  800390:	83 c4 10             	add    $0x10,%esp
  800393:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800396:	c7 05 18 b1 81 00 00 	movl   $0x700,0x81b118
  80039d:	07 00 00 

	return cnt;
  8003a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003a3:	c9                   	leave  
  8003a4:	c3                   	ret    

008003a5 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8003a5:	55                   	push   %ebp
  8003a6:	89 e5                	mov    %esp,%ebp
  8003a8:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8003ab:	e8 d7 0e 00 00       	call   801287 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8003b0:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8003b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b9:	83 ec 08             	sub    $0x8,%esp
  8003bc:	ff 75 f4             	pushl  -0xc(%ebp)
  8003bf:	50                   	push   %eax
  8003c0:	e8 ff fe ff ff       	call   8002c4 <vcprintf>
  8003c5:	83 c4 10             	add    $0x10,%esp
  8003c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8003cb:	e8 d1 0e 00 00       	call   8012a1 <sys_unlock_cons>
	return cnt;
  8003d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003d3:	c9                   	leave  
  8003d4:	c3                   	ret    

008003d5 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003d5:	55                   	push   %ebp
  8003d6:	89 e5                	mov    %esp,%ebp
  8003d8:	53                   	push   %ebx
  8003d9:	83 ec 14             	sub    $0x14,%esp
  8003dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8003df:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8003e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003e8:	8b 45 18             	mov    0x18(%ebp),%eax
  8003eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8003f0:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003f3:	77 55                	ja     80044a <printnum+0x75>
  8003f5:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003f8:	72 05                	jb     8003ff <printnum+0x2a>
  8003fa:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8003fd:	77 4b                	ja     80044a <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003ff:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800402:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800405:	8b 45 18             	mov    0x18(%ebp),%eax
  800408:	ba 00 00 00 00       	mov    $0x0,%edx
  80040d:	52                   	push   %edx
  80040e:	50                   	push   %eax
  80040f:	ff 75 f4             	pushl  -0xc(%ebp)
  800412:	ff 75 f0             	pushl  -0x10(%ebp)
  800415:	e8 56 16 00 00       	call   801a70 <__udivdi3>
  80041a:	83 c4 10             	add    $0x10,%esp
  80041d:	83 ec 04             	sub    $0x4,%esp
  800420:	ff 75 20             	pushl  0x20(%ebp)
  800423:	53                   	push   %ebx
  800424:	ff 75 18             	pushl  0x18(%ebp)
  800427:	52                   	push   %edx
  800428:	50                   	push   %eax
  800429:	ff 75 0c             	pushl  0xc(%ebp)
  80042c:	ff 75 08             	pushl  0x8(%ebp)
  80042f:	e8 a1 ff ff ff       	call   8003d5 <printnum>
  800434:	83 c4 20             	add    $0x20,%esp
  800437:	eb 1a                	jmp    800453 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800439:	83 ec 08             	sub    $0x8,%esp
  80043c:	ff 75 0c             	pushl  0xc(%ebp)
  80043f:	ff 75 20             	pushl  0x20(%ebp)
  800442:	8b 45 08             	mov    0x8(%ebp),%eax
  800445:	ff d0                	call   *%eax
  800447:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80044a:	ff 4d 1c             	decl   0x1c(%ebp)
  80044d:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800451:	7f e6                	jg     800439 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800453:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800456:	bb 00 00 00 00       	mov    $0x0,%ebx
  80045b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80045e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800461:	53                   	push   %ebx
  800462:	51                   	push   %ecx
  800463:	52                   	push   %edx
  800464:	50                   	push   %eax
  800465:	e8 16 17 00 00       	call   801b80 <__umoddi3>
  80046a:	83 c4 10             	add    $0x10,%esp
  80046d:	05 74 20 80 00       	add    $0x802074,%eax
  800472:	8a 00                	mov    (%eax),%al
  800474:	0f be c0             	movsbl %al,%eax
  800477:	83 ec 08             	sub    $0x8,%esp
  80047a:	ff 75 0c             	pushl  0xc(%ebp)
  80047d:	50                   	push   %eax
  80047e:	8b 45 08             	mov    0x8(%ebp),%eax
  800481:	ff d0                	call   *%eax
  800483:	83 c4 10             	add    $0x10,%esp
}
  800486:	90                   	nop
  800487:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80048a:	c9                   	leave  
  80048b:	c3                   	ret    

0080048c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80048c:	55                   	push   %ebp
  80048d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80048f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800493:	7e 1c                	jle    8004b1 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800495:	8b 45 08             	mov    0x8(%ebp),%eax
  800498:	8b 00                	mov    (%eax),%eax
  80049a:	8d 50 08             	lea    0x8(%eax),%edx
  80049d:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a0:	89 10                	mov    %edx,(%eax)
  8004a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a5:	8b 00                	mov    (%eax),%eax
  8004a7:	83 e8 08             	sub    $0x8,%eax
  8004aa:	8b 50 04             	mov    0x4(%eax),%edx
  8004ad:	8b 00                	mov    (%eax),%eax
  8004af:	eb 40                	jmp    8004f1 <getuint+0x65>
	else if (lflag)
  8004b1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004b5:	74 1e                	je     8004d5 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8004b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ba:	8b 00                	mov    (%eax),%eax
  8004bc:	8d 50 04             	lea    0x4(%eax),%edx
  8004bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c2:	89 10                	mov    %edx,(%eax)
  8004c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c7:	8b 00                	mov    (%eax),%eax
  8004c9:	83 e8 04             	sub    $0x4,%eax
  8004cc:	8b 00                	mov    (%eax),%eax
  8004ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8004d3:	eb 1c                	jmp    8004f1 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8004d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d8:	8b 00                	mov    (%eax),%eax
  8004da:	8d 50 04             	lea    0x4(%eax),%edx
  8004dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e0:	89 10                	mov    %edx,(%eax)
  8004e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e5:	8b 00                	mov    (%eax),%eax
  8004e7:	83 e8 04             	sub    $0x4,%eax
  8004ea:	8b 00                	mov    (%eax),%eax
  8004ec:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004f1:	5d                   	pop    %ebp
  8004f2:	c3                   	ret    

008004f3 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004f3:	55                   	push   %ebp
  8004f4:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004f6:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004fa:	7e 1c                	jle    800518 <getint+0x25>
		return va_arg(*ap, long long);
  8004fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ff:	8b 00                	mov    (%eax),%eax
  800501:	8d 50 08             	lea    0x8(%eax),%edx
  800504:	8b 45 08             	mov    0x8(%ebp),%eax
  800507:	89 10                	mov    %edx,(%eax)
  800509:	8b 45 08             	mov    0x8(%ebp),%eax
  80050c:	8b 00                	mov    (%eax),%eax
  80050e:	83 e8 08             	sub    $0x8,%eax
  800511:	8b 50 04             	mov    0x4(%eax),%edx
  800514:	8b 00                	mov    (%eax),%eax
  800516:	eb 38                	jmp    800550 <getint+0x5d>
	else if (lflag)
  800518:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80051c:	74 1a                	je     800538 <getint+0x45>
		return va_arg(*ap, long);
  80051e:	8b 45 08             	mov    0x8(%ebp),%eax
  800521:	8b 00                	mov    (%eax),%eax
  800523:	8d 50 04             	lea    0x4(%eax),%edx
  800526:	8b 45 08             	mov    0x8(%ebp),%eax
  800529:	89 10                	mov    %edx,(%eax)
  80052b:	8b 45 08             	mov    0x8(%ebp),%eax
  80052e:	8b 00                	mov    (%eax),%eax
  800530:	83 e8 04             	sub    $0x4,%eax
  800533:	8b 00                	mov    (%eax),%eax
  800535:	99                   	cltd   
  800536:	eb 18                	jmp    800550 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800538:	8b 45 08             	mov    0x8(%ebp),%eax
  80053b:	8b 00                	mov    (%eax),%eax
  80053d:	8d 50 04             	lea    0x4(%eax),%edx
  800540:	8b 45 08             	mov    0x8(%ebp),%eax
  800543:	89 10                	mov    %edx,(%eax)
  800545:	8b 45 08             	mov    0x8(%ebp),%eax
  800548:	8b 00                	mov    (%eax),%eax
  80054a:	83 e8 04             	sub    $0x4,%eax
  80054d:	8b 00                	mov    (%eax),%eax
  80054f:	99                   	cltd   
}
  800550:	5d                   	pop    %ebp
  800551:	c3                   	ret    

00800552 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800552:	55                   	push   %ebp
  800553:	89 e5                	mov    %esp,%ebp
  800555:	56                   	push   %esi
  800556:	53                   	push   %ebx
  800557:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80055a:	eb 17                	jmp    800573 <vprintfmt+0x21>
			if (ch == '\0')
  80055c:	85 db                	test   %ebx,%ebx
  80055e:	0f 84 c1 03 00 00    	je     800925 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800564:	83 ec 08             	sub    $0x8,%esp
  800567:	ff 75 0c             	pushl  0xc(%ebp)
  80056a:	53                   	push   %ebx
  80056b:	8b 45 08             	mov    0x8(%ebp),%eax
  80056e:	ff d0                	call   *%eax
  800570:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800573:	8b 45 10             	mov    0x10(%ebp),%eax
  800576:	8d 50 01             	lea    0x1(%eax),%edx
  800579:	89 55 10             	mov    %edx,0x10(%ebp)
  80057c:	8a 00                	mov    (%eax),%al
  80057e:	0f b6 d8             	movzbl %al,%ebx
  800581:	83 fb 25             	cmp    $0x25,%ebx
  800584:	75 d6                	jne    80055c <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800586:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80058a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800591:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800598:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80059f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8005a9:	8d 50 01             	lea    0x1(%eax),%edx
  8005ac:	89 55 10             	mov    %edx,0x10(%ebp)
  8005af:	8a 00                	mov    (%eax),%al
  8005b1:	0f b6 d8             	movzbl %al,%ebx
  8005b4:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8005b7:	83 f8 5b             	cmp    $0x5b,%eax
  8005ba:	0f 87 3d 03 00 00    	ja     8008fd <vprintfmt+0x3ab>
  8005c0:	8b 04 85 98 20 80 00 	mov    0x802098(,%eax,4),%eax
  8005c7:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8005c9:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8005cd:	eb d7                	jmp    8005a6 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8005cf:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8005d3:	eb d1                	jmp    8005a6 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005d5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8005dc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005df:	89 d0                	mov    %edx,%eax
  8005e1:	c1 e0 02             	shl    $0x2,%eax
  8005e4:	01 d0                	add    %edx,%eax
  8005e6:	01 c0                	add    %eax,%eax
  8005e8:	01 d8                	add    %ebx,%eax
  8005ea:	83 e8 30             	sub    $0x30,%eax
  8005ed:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8005f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8005f3:	8a 00                	mov    (%eax),%al
  8005f5:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8005f8:	83 fb 2f             	cmp    $0x2f,%ebx
  8005fb:	7e 3e                	jle    80063b <vprintfmt+0xe9>
  8005fd:	83 fb 39             	cmp    $0x39,%ebx
  800600:	7f 39                	jg     80063b <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800602:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800605:	eb d5                	jmp    8005dc <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800607:	8b 45 14             	mov    0x14(%ebp),%eax
  80060a:	83 c0 04             	add    $0x4,%eax
  80060d:	89 45 14             	mov    %eax,0x14(%ebp)
  800610:	8b 45 14             	mov    0x14(%ebp),%eax
  800613:	83 e8 04             	sub    $0x4,%eax
  800616:	8b 00                	mov    (%eax),%eax
  800618:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80061b:	eb 1f                	jmp    80063c <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80061d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800621:	79 83                	jns    8005a6 <vprintfmt+0x54>
				width = 0;
  800623:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80062a:	e9 77 ff ff ff       	jmp    8005a6 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80062f:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800636:	e9 6b ff ff ff       	jmp    8005a6 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80063b:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80063c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800640:	0f 89 60 ff ff ff    	jns    8005a6 <vprintfmt+0x54>
				width = precision, precision = -1;
  800646:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800649:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80064c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800653:	e9 4e ff ff ff       	jmp    8005a6 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800658:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80065b:	e9 46 ff ff ff       	jmp    8005a6 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800660:	8b 45 14             	mov    0x14(%ebp),%eax
  800663:	83 c0 04             	add    $0x4,%eax
  800666:	89 45 14             	mov    %eax,0x14(%ebp)
  800669:	8b 45 14             	mov    0x14(%ebp),%eax
  80066c:	83 e8 04             	sub    $0x4,%eax
  80066f:	8b 00                	mov    (%eax),%eax
  800671:	83 ec 08             	sub    $0x8,%esp
  800674:	ff 75 0c             	pushl  0xc(%ebp)
  800677:	50                   	push   %eax
  800678:	8b 45 08             	mov    0x8(%ebp),%eax
  80067b:	ff d0                	call   *%eax
  80067d:	83 c4 10             	add    $0x10,%esp
			break;
  800680:	e9 9b 02 00 00       	jmp    800920 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800685:	8b 45 14             	mov    0x14(%ebp),%eax
  800688:	83 c0 04             	add    $0x4,%eax
  80068b:	89 45 14             	mov    %eax,0x14(%ebp)
  80068e:	8b 45 14             	mov    0x14(%ebp),%eax
  800691:	83 e8 04             	sub    $0x4,%eax
  800694:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800696:	85 db                	test   %ebx,%ebx
  800698:	79 02                	jns    80069c <vprintfmt+0x14a>
				err = -err;
  80069a:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80069c:	83 fb 64             	cmp    $0x64,%ebx
  80069f:	7f 0b                	jg     8006ac <vprintfmt+0x15a>
  8006a1:	8b 34 9d e0 1e 80 00 	mov    0x801ee0(,%ebx,4),%esi
  8006a8:	85 f6                	test   %esi,%esi
  8006aa:	75 19                	jne    8006c5 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8006ac:	53                   	push   %ebx
  8006ad:	68 85 20 80 00       	push   $0x802085
  8006b2:	ff 75 0c             	pushl  0xc(%ebp)
  8006b5:	ff 75 08             	pushl  0x8(%ebp)
  8006b8:	e8 70 02 00 00       	call   80092d <printfmt>
  8006bd:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8006c0:	e9 5b 02 00 00       	jmp    800920 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8006c5:	56                   	push   %esi
  8006c6:	68 8e 20 80 00       	push   $0x80208e
  8006cb:	ff 75 0c             	pushl  0xc(%ebp)
  8006ce:	ff 75 08             	pushl  0x8(%ebp)
  8006d1:	e8 57 02 00 00       	call   80092d <printfmt>
  8006d6:	83 c4 10             	add    $0x10,%esp
			break;
  8006d9:	e9 42 02 00 00       	jmp    800920 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006de:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e1:	83 c0 04             	add    $0x4,%eax
  8006e4:	89 45 14             	mov    %eax,0x14(%ebp)
  8006e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ea:	83 e8 04             	sub    $0x4,%eax
  8006ed:	8b 30                	mov    (%eax),%esi
  8006ef:	85 f6                	test   %esi,%esi
  8006f1:	75 05                	jne    8006f8 <vprintfmt+0x1a6>
				p = "(null)";
  8006f3:	be 91 20 80 00       	mov    $0x802091,%esi
			if (width > 0 && padc != '-')
  8006f8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006fc:	7e 6d                	jle    80076b <vprintfmt+0x219>
  8006fe:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800702:	74 67                	je     80076b <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800704:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800707:	83 ec 08             	sub    $0x8,%esp
  80070a:	50                   	push   %eax
  80070b:	56                   	push   %esi
  80070c:	e8 1e 03 00 00       	call   800a2f <strnlen>
  800711:	83 c4 10             	add    $0x10,%esp
  800714:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800717:	eb 16                	jmp    80072f <vprintfmt+0x1dd>
					putch(padc, putdat);
  800719:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80071d:	83 ec 08             	sub    $0x8,%esp
  800720:	ff 75 0c             	pushl  0xc(%ebp)
  800723:	50                   	push   %eax
  800724:	8b 45 08             	mov    0x8(%ebp),%eax
  800727:	ff d0                	call   *%eax
  800729:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80072c:	ff 4d e4             	decl   -0x1c(%ebp)
  80072f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800733:	7f e4                	jg     800719 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800735:	eb 34                	jmp    80076b <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800737:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80073b:	74 1c                	je     800759 <vprintfmt+0x207>
  80073d:	83 fb 1f             	cmp    $0x1f,%ebx
  800740:	7e 05                	jle    800747 <vprintfmt+0x1f5>
  800742:	83 fb 7e             	cmp    $0x7e,%ebx
  800745:	7e 12                	jle    800759 <vprintfmt+0x207>
					putch('?', putdat);
  800747:	83 ec 08             	sub    $0x8,%esp
  80074a:	ff 75 0c             	pushl  0xc(%ebp)
  80074d:	6a 3f                	push   $0x3f
  80074f:	8b 45 08             	mov    0x8(%ebp),%eax
  800752:	ff d0                	call   *%eax
  800754:	83 c4 10             	add    $0x10,%esp
  800757:	eb 0f                	jmp    800768 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800759:	83 ec 08             	sub    $0x8,%esp
  80075c:	ff 75 0c             	pushl  0xc(%ebp)
  80075f:	53                   	push   %ebx
  800760:	8b 45 08             	mov    0x8(%ebp),%eax
  800763:	ff d0                	call   *%eax
  800765:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800768:	ff 4d e4             	decl   -0x1c(%ebp)
  80076b:	89 f0                	mov    %esi,%eax
  80076d:	8d 70 01             	lea    0x1(%eax),%esi
  800770:	8a 00                	mov    (%eax),%al
  800772:	0f be d8             	movsbl %al,%ebx
  800775:	85 db                	test   %ebx,%ebx
  800777:	74 24                	je     80079d <vprintfmt+0x24b>
  800779:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80077d:	78 b8                	js     800737 <vprintfmt+0x1e5>
  80077f:	ff 4d e0             	decl   -0x20(%ebp)
  800782:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800786:	79 af                	jns    800737 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800788:	eb 13                	jmp    80079d <vprintfmt+0x24b>
				putch(' ', putdat);
  80078a:	83 ec 08             	sub    $0x8,%esp
  80078d:	ff 75 0c             	pushl  0xc(%ebp)
  800790:	6a 20                	push   $0x20
  800792:	8b 45 08             	mov    0x8(%ebp),%eax
  800795:	ff d0                	call   *%eax
  800797:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80079a:	ff 4d e4             	decl   -0x1c(%ebp)
  80079d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007a1:	7f e7                	jg     80078a <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8007a3:	e9 78 01 00 00       	jmp    800920 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8007a8:	83 ec 08             	sub    $0x8,%esp
  8007ab:	ff 75 e8             	pushl  -0x18(%ebp)
  8007ae:	8d 45 14             	lea    0x14(%ebp),%eax
  8007b1:	50                   	push   %eax
  8007b2:	e8 3c fd ff ff       	call   8004f3 <getint>
  8007b7:	83 c4 10             	add    $0x10,%esp
  8007ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007bd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8007c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007c6:	85 d2                	test   %edx,%edx
  8007c8:	79 23                	jns    8007ed <vprintfmt+0x29b>
				putch('-', putdat);
  8007ca:	83 ec 08             	sub    $0x8,%esp
  8007cd:	ff 75 0c             	pushl  0xc(%ebp)
  8007d0:	6a 2d                	push   $0x2d
  8007d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d5:	ff d0                	call   *%eax
  8007d7:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8007da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007e0:	f7 d8                	neg    %eax
  8007e2:	83 d2 00             	adc    $0x0,%edx
  8007e5:	f7 da                	neg    %edx
  8007e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007ea:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8007ed:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007f4:	e9 bc 00 00 00       	jmp    8008b5 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007f9:	83 ec 08             	sub    $0x8,%esp
  8007fc:	ff 75 e8             	pushl  -0x18(%ebp)
  8007ff:	8d 45 14             	lea    0x14(%ebp),%eax
  800802:	50                   	push   %eax
  800803:	e8 84 fc ff ff       	call   80048c <getuint>
  800808:	83 c4 10             	add    $0x10,%esp
  80080b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80080e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800811:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800818:	e9 98 00 00 00       	jmp    8008b5 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80081d:	83 ec 08             	sub    $0x8,%esp
  800820:	ff 75 0c             	pushl  0xc(%ebp)
  800823:	6a 58                	push   $0x58
  800825:	8b 45 08             	mov    0x8(%ebp),%eax
  800828:	ff d0                	call   *%eax
  80082a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80082d:	83 ec 08             	sub    $0x8,%esp
  800830:	ff 75 0c             	pushl  0xc(%ebp)
  800833:	6a 58                	push   $0x58
  800835:	8b 45 08             	mov    0x8(%ebp),%eax
  800838:	ff d0                	call   *%eax
  80083a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80083d:	83 ec 08             	sub    $0x8,%esp
  800840:	ff 75 0c             	pushl  0xc(%ebp)
  800843:	6a 58                	push   $0x58
  800845:	8b 45 08             	mov    0x8(%ebp),%eax
  800848:	ff d0                	call   *%eax
  80084a:	83 c4 10             	add    $0x10,%esp
			break;
  80084d:	e9 ce 00 00 00       	jmp    800920 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800852:	83 ec 08             	sub    $0x8,%esp
  800855:	ff 75 0c             	pushl  0xc(%ebp)
  800858:	6a 30                	push   $0x30
  80085a:	8b 45 08             	mov    0x8(%ebp),%eax
  80085d:	ff d0                	call   *%eax
  80085f:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800862:	83 ec 08             	sub    $0x8,%esp
  800865:	ff 75 0c             	pushl  0xc(%ebp)
  800868:	6a 78                	push   $0x78
  80086a:	8b 45 08             	mov    0x8(%ebp),%eax
  80086d:	ff d0                	call   *%eax
  80086f:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800872:	8b 45 14             	mov    0x14(%ebp),%eax
  800875:	83 c0 04             	add    $0x4,%eax
  800878:	89 45 14             	mov    %eax,0x14(%ebp)
  80087b:	8b 45 14             	mov    0x14(%ebp),%eax
  80087e:	83 e8 04             	sub    $0x4,%eax
  800881:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800883:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800886:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80088d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800894:	eb 1f                	jmp    8008b5 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800896:	83 ec 08             	sub    $0x8,%esp
  800899:	ff 75 e8             	pushl  -0x18(%ebp)
  80089c:	8d 45 14             	lea    0x14(%ebp),%eax
  80089f:	50                   	push   %eax
  8008a0:	e8 e7 fb ff ff       	call   80048c <getuint>
  8008a5:	83 c4 10             	add    $0x10,%esp
  8008a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008ab:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8008ae:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8008b5:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8008b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008bc:	83 ec 04             	sub    $0x4,%esp
  8008bf:	52                   	push   %edx
  8008c0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8008c3:	50                   	push   %eax
  8008c4:	ff 75 f4             	pushl  -0xc(%ebp)
  8008c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8008ca:	ff 75 0c             	pushl  0xc(%ebp)
  8008cd:	ff 75 08             	pushl  0x8(%ebp)
  8008d0:	e8 00 fb ff ff       	call   8003d5 <printnum>
  8008d5:	83 c4 20             	add    $0x20,%esp
			break;
  8008d8:	eb 46                	jmp    800920 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008da:	83 ec 08             	sub    $0x8,%esp
  8008dd:	ff 75 0c             	pushl  0xc(%ebp)
  8008e0:	53                   	push   %ebx
  8008e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e4:	ff d0                	call   *%eax
  8008e6:	83 c4 10             	add    $0x10,%esp
			break;
  8008e9:	eb 35                	jmp    800920 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8008eb:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  8008f2:	eb 2c                	jmp    800920 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8008f4:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  8008fb:	eb 23                	jmp    800920 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008fd:	83 ec 08             	sub    $0x8,%esp
  800900:	ff 75 0c             	pushl  0xc(%ebp)
  800903:	6a 25                	push   $0x25
  800905:	8b 45 08             	mov    0x8(%ebp),%eax
  800908:	ff d0                	call   *%eax
  80090a:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80090d:	ff 4d 10             	decl   0x10(%ebp)
  800910:	eb 03                	jmp    800915 <vprintfmt+0x3c3>
  800912:	ff 4d 10             	decl   0x10(%ebp)
  800915:	8b 45 10             	mov    0x10(%ebp),%eax
  800918:	48                   	dec    %eax
  800919:	8a 00                	mov    (%eax),%al
  80091b:	3c 25                	cmp    $0x25,%al
  80091d:	75 f3                	jne    800912 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  80091f:	90                   	nop
		}
	}
  800920:	e9 35 fc ff ff       	jmp    80055a <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800925:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800926:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800929:	5b                   	pop    %ebx
  80092a:	5e                   	pop    %esi
  80092b:	5d                   	pop    %ebp
  80092c:	c3                   	ret    

0080092d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80092d:	55                   	push   %ebp
  80092e:	89 e5                	mov    %esp,%ebp
  800930:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800933:	8d 45 10             	lea    0x10(%ebp),%eax
  800936:	83 c0 04             	add    $0x4,%eax
  800939:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80093c:	8b 45 10             	mov    0x10(%ebp),%eax
  80093f:	ff 75 f4             	pushl  -0xc(%ebp)
  800942:	50                   	push   %eax
  800943:	ff 75 0c             	pushl  0xc(%ebp)
  800946:	ff 75 08             	pushl  0x8(%ebp)
  800949:	e8 04 fc ff ff       	call   800552 <vprintfmt>
  80094e:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800951:	90                   	nop
  800952:	c9                   	leave  
  800953:	c3                   	ret    

00800954 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800954:	55                   	push   %ebp
  800955:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800957:	8b 45 0c             	mov    0xc(%ebp),%eax
  80095a:	8b 40 08             	mov    0x8(%eax),%eax
  80095d:	8d 50 01             	lea    0x1(%eax),%edx
  800960:	8b 45 0c             	mov    0xc(%ebp),%eax
  800963:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800966:	8b 45 0c             	mov    0xc(%ebp),%eax
  800969:	8b 10                	mov    (%eax),%edx
  80096b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80096e:	8b 40 04             	mov    0x4(%eax),%eax
  800971:	39 c2                	cmp    %eax,%edx
  800973:	73 12                	jae    800987 <sprintputch+0x33>
		*b->buf++ = ch;
  800975:	8b 45 0c             	mov    0xc(%ebp),%eax
  800978:	8b 00                	mov    (%eax),%eax
  80097a:	8d 48 01             	lea    0x1(%eax),%ecx
  80097d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800980:	89 0a                	mov    %ecx,(%edx)
  800982:	8b 55 08             	mov    0x8(%ebp),%edx
  800985:	88 10                	mov    %dl,(%eax)
}
  800987:	90                   	nop
  800988:	5d                   	pop    %ebp
  800989:	c3                   	ret    

0080098a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80098a:	55                   	push   %ebp
  80098b:	89 e5                	mov    %esp,%ebp
  80098d:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800990:	8b 45 08             	mov    0x8(%ebp),%eax
  800993:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800996:	8b 45 0c             	mov    0xc(%ebp),%eax
  800999:	8d 50 ff             	lea    -0x1(%eax),%edx
  80099c:	8b 45 08             	mov    0x8(%ebp),%eax
  80099f:	01 d0                	add    %edx,%eax
  8009a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009a4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009ab:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8009af:	74 06                	je     8009b7 <vsnprintf+0x2d>
  8009b1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009b5:	7f 07                	jg     8009be <vsnprintf+0x34>
		return -E_INVAL;
  8009b7:	b8 03 00 00 00       	mov    $0x3,%eax
  8009bc:	eb 20                	jmp    8009de <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009be:	ff 75 14             	pushl  0x14(%ebp)
  8009c1:	ff 75 10             	pushl  0x10(%ebp)
  8009c4:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009c7:	50                   	push   %eax
  8009c8:	68 54 09 80 00       	push   $0x800954
  8009cd:	e8 80 fb ff ff       	call   800552 <vprintfmt>
  8009d2:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8009d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009d8:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009db:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8009de:	c9                   	leave  
  8009df:	c3                   	ret    

008009e0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009e0:	55                   	push   %ebp
  8009e1:	89 e5                	mov    %esp,%ebp
  8009e3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009e6:	8d 45 10             	lea    0x10(%ebp),%eax
  8009e9:	83 c0 04             	add    $0x4,%eax
  8009ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8009ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8009f2:	ff 75 f4             	pushl  -0xc(%ebp)
  8009f5:	50                   	push   %eax
  8009f6:	ff 75 0c             	pushl  0xc(%ebp)
  8009f9:	ff 75 08             	pushl  0x8(%ebp)
  8009fc:	e8 89 ff ff ff       	call   80098a <vsnprintf>
  800a01:	83 c4 10             	add    $0x10,%esp
  800a04:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800a07:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a0a:	c9                   	leave  
  800a0b:	c3                   	ret    

00800a0c <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800a0c:	55                   	push   %ebp
  800a0d:	89 e5                	mov    %esp,%ebp
  800a0f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800a12:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a19:	eb 06                	jmp    800a21 <strlen+0x15>
		n++;
  800a1b:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800a1e:	ff 45 08             	incl   0x8(%ebp)
  800a21:	8b 45 08             	mov    0x8(%ebp),%eax
  800a24:	8a 00                	mov    (%eax),%al
  800a26:	84 c0                	test   %al,%al
  800a28:	75 f1                	jne    800a1b <strlen+0xf>
		n++;
	return n;
  800a2a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a2d:	c9                   	leave  
  800a2e:	c3                   	ret    

00800a2f <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800a2f:	55                   	push   %ebp
  800a30:	89 e5                	mov    %esp,%ebp
  800a32:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a35:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a3c:	eb 09                	jmp    800a47 <strnlen+0x18>
		n++;
  800a3e:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a41:	ff 45 08             	incl   0x8(%ebp)
  800a44:	ff 4d 0c             	decl   0xc(%ebp)
  800a47:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a4b:	74 09                	je     800a56 <strnlen+0x27>
  800a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a50:	8a 00                	mov    (%eax),%al
  800a52:	84 c0                	test   %al,%al
  800a54:	75 e8                	jne    800a3e <strnlen+0xf>
		n++;
	return n;
  800a56:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a59:	c9                   	leave  
  800a5a:	c3                   	ret    

00800a5b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a5b:	55                   	push   %ebp
  800a5c:	89 e5                	mov    %esp,%ebp
  800a5e:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800a61:	8b 45 08             	mov    0x8(%ebp),%eax
  800a64:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800a67:	90                   	nop
  800a68:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6b:	8d 50 01             	lea    0x1(%eax),%edx
  800a6e:	89 55 08             	mov    %edx,0x8(%ebp)
  800a71:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a74:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a77:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a7a:	8a 12                	mov    (%edx),%dl
  800a7c:	88 10                	mov    %dl,(%eax)
  800a7e:	8a 00                	mov    (%eax),%al
  800a80:	84 c0                	test   %al,%al
  800a82:	75 e4                	jne    800a68 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800a84:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a87:	c9                   	leave  
  800a88:	c3                   	ret    

00800a89 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800a89:	55                   	push   %ebp
  800a8a:	89 e5                	mov    %esp,%ebp
  800a8c:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a92:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800a95:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a9c:	eb 1f                	jmp    800abd <strncpy+0x34>
		*dst++ = *src;
  800a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa1:	8d 50 01             	lea    0x1(%eax),%edx
  800aa4:	89 55 08             	mov    %edx,0x8(%ebp)
  800aa7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aaa:	8a 12                	mov    (%edx),%dl
  800aac:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800aae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ab1:	8a 00                	mov    (%eax),%al
  800ab3:	84 c0                	test   %al,%al
  800ab5:	74 03                	je     800aba <strncpy+0x31>
			src++;
  800ab7:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800aba:	ff 45 fc             	incl   -0x4(%ebp)
  800abd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ac0:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ac3:	72 d9                	jb     800a9e <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ac5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ac8:	c9                   	leave  
  800ac9:	c3                   	ret    

00800aca <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800aca:	55                   	push   %ebp
  800acb:	89 e5                	mov    %esp,%ebp
  800acd:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ad6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ada:	74 30                	je     800b0c <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800adc:	eb 16                	jmp    800af4 <strlcpy+0x2a>
			*dst++ = *src++;
  800ade:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae1:	8d 50 01             	lea    0x1(%eax),%edx
  800ae4:	89 55 08             	mov    %edx,0x8(%ebp)
  800ae7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aea:	8d 4a 01             	lea    0x1(%edx),%ecx
  800aed:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800af0:	8a 12                	mov    (%edx),%dl
  800af2:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800af4:	ff 4d 10             	decl   0x10(%ebp)
  800af7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800afb:	74 09                	je     800b06 <strlcpy+0x3c>
  800afd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b00:	8a 00                	mov    (%eax),%al
  800b02:	84 c0                	test   %al,%al
  800b04:	75 d8                	jne    800ade <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800b06:	8b 45 08             	mov    0x8(%ebp),%eax
  800b09:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b0c:	8b 55 08             	mov    0x8(%ebp),%edx
  800b0f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b12:	29 c2                	sub    %eax,%edx
  800b14:	89 d0                	mov    %edx,%eax
}
  800b16:	c9                   	leave  
  800b17:	c3                   	ret    

00800b18 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b18:	55                   	push   %ebp
  800b19:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800b1b:	eb 06                	jmp    800b23 <strcmp+0xb>
		p++, q++;
  800b1d:	ff 45 08             	incl   0x8(%ebp)
  800b20:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800b23:	8b 45 08             	mov    0x8(%ebp),%eax
  800b26:	8a 00                	mov    (%eax),%al
  800b28:	84 c0                	test   %al,%al
  800b2a:	74 0e                	je     800b3a <strcmp+0x22>
  800b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2f:	8a 10                	mov    (%eax),%dl
  800b31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b34:	8a 00                	mov    (%eax),%al
  800b36:	38 c2                	cmp    %al,%dl
  800b38:	74 e3                	je     800b1d <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3d:	8a 00                	mov    (%eax),%al
  800b3f:	0f b6 d0             	movzbl %al,%edx
  800b42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b45:	8a 00                	mov    (%eax),%al
  800b47:	0f b6 c0             	movzbl %al,%eax
  800b4a:	29 c2                	sub    %eax,%edx
  800b4c:	89 d0                	mov    %edx,%eax
}
  800b4e:	5d                   	pop    %ebp
  800b4f:	c3                   	ret    

00800b50 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800b50:	55                   	push   %ebp
  800b51:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800b53:	eb 09                	jmp    800b5e <strncmp+0xe>
		n--, p++, q++;
  800b55:	ff 4d 10             	decl   0x10(%ebp)
  800b58:	ff 45 08             	incl   0x8(%ebp)
  800b5b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800b5e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b62:	74 17                	je     800b7b <strncmp+0x2b>
  800b64:	8b 45 08             	mov    0x8(%ebp),%eax
  800b67:	8a 00                	mov    (%eax),%al
  800b69:	84 c0                	test   %al,%al
  800b6b:	74 0e                	je     800b7b <strncmp+0x2b>
  800b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b70:	8a 10                	mov    (%eax),%dl
  800b72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b75:	8a 00                	mov    (%eax),%al
  800b77:	38 c2                	cmp    %al,%dl
  800b79:	74 da                	je     800b55 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800b7b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b7f:	75 07                	jne    800b88 <strncmp+0x38>
		return 0;
  800b81:	b8 00 00 00 00       	mov    $0x0,%eax
  800b86:	eb 14                	jmp    800b9c <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b88:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8b:	8a 00                	mov    (%eax),%al
  800b8d:	0f b6 d0             	movzbl %al,%edx
  800b90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b93:	8a 00                	mov    (%eax),%al
  800b95:	0f b6 c0             	movzbl %al,%eax
  800b98:	29 c2                	sub    %eax,%edx
  800b9a:	89 d0                	mov    %edx,%eax
}
  800b9c:	5d                   	pop    %ebp
  800b9d:	c3                   	ret    

00800b9e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b9e:	55                   	push   %ebp
  800b9f:	89 e5                	mov    %esp,%ebp
  800ba1:	83 ec 04             	sub    $0x4,%esp
  800ba4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800baa:	eb 12                	jmp    800bbe <strchr+0x20>
		if (*s == c)
  800bac:	8b 45 08             	mov    0x8(%ebp),%eax
  800baf:	8a 00                	mov    (%eax),%al
  800bb1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800bb4:	75 05                	jne    800bbb <strchr+0x1d>
			return (char *) s;
  800bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb9:	eb 11                	jmp    800bcc <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800bbb:	ff 45 08             	incl   0x8(%ebp)
  800bbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc1:	8a 00                	mov    (%eax),%al
  800bc3:	84 c0                	test   %al,%al
  800bc5:	75 e5                	jne    800bac <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800bc7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bcc:	c9                   	leave  
  800bcd:	c3                   	ret    

00800bce <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800bce:	55                   	push   %ebp
  800bcf:	89 e5                	mov    %esp,%ebp
  800bd1:	83 ec 04             	sub    $0x4,%esp
  800bd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800bda:	eb 0d                	jmp    800be9 <strfind+0x1b>
		if (*s == c)
  800bdc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdf:	8a 00                	mov    (%eax),%al
  800be1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800be4:	74 0e                	je     800bf4 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800be6:	ff 45 08             	incl   0x8(%ebp)
  800be9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bec:	8a 00                	mov    (%eax),%al
  800bee:	84 c0                	test   %al,%al
  800bf0:	75 ea                	jne    800bdc <strfind+0xe>
  800bf2:	eb 01                	jmp    800bf5 <strfind+0x27>
		if (*s == c)
			break;
  800bf4:	90                   	nop
	return (char *) s;
  800bf5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bf8:	c9                   	leave  
  800bf9:	c3                   	ret    

00800bfa <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800bfa:	55                   	push   %ebp
  800bfb:	89 e5                	mov    %esp,%ebp
  800bfd:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800c00:	8b 45 08             	mov    0x8(%ebp),%eax
  800c03:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800c06:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800c0a:	76 63                	jbe    800c6f <memset+0x75>
		uint64 data_block = c;
  800c0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c0f:	99                   	cltd   
  800c10:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c13:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800c16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c19:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c1c:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800c20:	c1 e0 08             	shl    $0x8,%eax
  800c23:	09 45 f0             	or     %eax,-0x10(%ebp)
  800c26:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800c29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c2c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c2f:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800c33:	c1 e0 10             	shl    $0x10,%eax
  800c36:	09 45 f0             	or     %eax,-0x10(%ebp)
  800c39:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800c3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c42:	89 c2                	mov    %eax,%edx
  800c44:	b8 00 00 00 00       	mov    $0x0,%eax
  800c49:	09 45 f0             	or     %eax,-0x10(%ebp)
  800c4c:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800c4f:	eb 18                	jmp    800c69 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800c51:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800c54:	8d 41 08             	lea    0x8(%ecx),%eax
  800c57:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800c5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c5d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c60:	89 01                	mov    %eax,(%ecx)
  800c62:	89 51 04             	mov    %edx,0x4(%ecx)
  800c65:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800c69:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800c6d:	77 e2                	ja     800c51 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800c6f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c73:	74 23                	je     800c98 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800c75:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c78:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800c7b:	eb 0e                	jmp    800c8b <memset+0x91>
			*p8++ = (uint8)c;
  800c7d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c80:	8d 50 01             	lea    0x1(%eax),%edx
  800c83:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c86:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c89:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800c8b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c8e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c91:	89 55 10             	mov    %edx,0x10(%ebp)
  800c94:	85 c0                	test   %eax,%eax
  800c96:	75 e5                	jne    800c7d <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800c98:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c9b:	c9                   	leave  
  800c9c:	c3                   	ret    

00800c9d <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800c9d:	55                   	push   %ebp
  800c9e:	89 e5                	mov    %esp,%ebp
  800ca0:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800ca3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cac:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800caf:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800cb3:	76 24                	jbe    800cd9 <memcpy+0x3c>
		while(n >= 8){
  800cb5:	eb 1c                	jmp    800cd3 <memcpy+0x36>
			*d64 = *s64;
  800cb7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cba:	8b 50 04             	mov    0x4(%eax),%edx
  800cbd:	8b 00                	mov    (%eax),%eax
  800cbf:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800cc2:	89 01                	mov    %eax,(%ecx)
  800cc4:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800cc7:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800ccb:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800ccf:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800cd3:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800cd7:	77 de                	ja     800cb7 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800cd9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cdd:	74 31                	je     800d10 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800cdf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ce2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800ce5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ce8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800ceb:	eb 16                	jmp    800d03 <memcpy+0x66>
			*d8++ = *s8++;
  800ced:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cf0:	8d 50 01             	lea    0x1(%eax),%edx
  800cf3:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800cf6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cf9:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cfc:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800cff:	8a 12                	mov    (%edx),%dl
  800d01:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800d03:	8b 45 10             	mov    0x10(%ebp),%eax
  800d06:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d09:	89 55 10             	mov    %edx,0x10(%ebp)
  800d0c:	85 c0                	test   %eax,%eax
  800d0e:	75 dd                	jne    800ced <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800d10:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d13:	c9                   	leave  
  800d14:	c3                   	ret    

00800d15 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800d15:	55                   	push   %ebp
  800d16:	89 e5                	mov    %esp,%ebp
  800d18:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d21:	8b 45 08             	mov    0x8(%ebp),%eax
  800d24:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800d27:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d2a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d2d:	73 50                	jae    800d7f <memmove+0x6a>
  800d2f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d32:	8b 45 10             	mov    0x10(%ebp),%eax
  800d35:	01 d0                	add    %edx,%eax
  800d37:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d3a:	76 43                	jbe    800d7f <memmove+0x6a>
		s += n;
  800d3c:	8b 45 10             	mov    0x10(%ebp),%eax
  800d3f:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800d42:	8b 45 10             	mov    0x10(%ebp),%eax
  800d45:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800d48:	eb 10                	jmp    800d5a <memmove+0x45>
			*--d = *--s;
  800d4a:	ff 4d f8             	decl   -0x8(%ebp)
  800d4d:	ff 4d fc             	decl   -0x4(%ebp)
  800d50:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d53:	8a 10                	mov    (%eax),%dl
  800d55:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d58:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800d5a:	8b 45 10             	mov    0x10(%ebp),%eax
  800d5d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d60:	89 55 10             	mov    %edx,0x10(%ebp)
  800d63:	85 c0                	test   %eax,%eax
  800d65:	75 e3                	jne    800d4a <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d67:	eb 23                	jmp    800d8c <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800d69:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d6c:	8d 50 01             	lea    0x1(%eax),%edx
  800d6f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d72:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d75:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d78:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d7b:	8a 12                	mov    (%edx),%dl
  800d7d:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800d7f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d82:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d85:	89 55 10             	mov    %edx,0x10(%ebp)
  800d88:	85 c0                	test   %eax,%eax
  800d8a:	75 dd                	jne    800d69 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800d8c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d8f:	c9                   	leave  
  800d90:	c3                   	ret    

00800d91 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800d91:	55                   	push   %ebp
  800d92:	89 e5                	mov    %esp,%ebp
  800d94:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800d97:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800d9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da0:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800da3:	eb 2a                	jmp    800dcf <memcmp+0x3e>
		if (*s1 != *s2)
  800da5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800da8:	8a 10                	mov    (%eax),%dl
  800daa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dad:	8a 00                	mov    (%eax),%al
  800daf:	38 c2                	cmp    %al,%dl
  800db1:	74 16                	je     800dc9 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800db3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800db6:	8a 00                	mov    (%eax),%al
  800db8:	0f b6 d0             	movzbl %al,%edx
  800dbb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dbe:	8a 00                	mov    (%eax),%al
  800dc0:	0f b6 c0             	movzbl %al,%eax
  800dc3:	29 c2                	sub    %eax,%edx
  800dc5:	89 d0                	mov    %edx,%eax
  800dc7:	eb 18                	jmp    800de1 <memcmp+0x50>
		s1++, s2++;
  800dc9:	ff 45 fc             	incl   -0x4(%ebp)
  800dcc:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800dcf:	8b 45 10             	mov    0x10(%ebp),%eax
  800dd2:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dd5:	89 55 10             	mov    %edx,0x10(%ebp)
  800dd8:	85 c0                	test   %eax,%eax
  800dda:	75 c9                	jne    800da5 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ddc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800de1:	c9                   	leave  
  800de2:	c3                   	ret    

00800de3 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800de3:	55                   	push   %ebp
  800de4:	89 e5                	mov    %esp,%ebp
  800de6:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800de9:	8b 55 08             	mov    0x8(%ebp),%edx
  800dec:	8b 45 10             	mov    0x10(%ebp),%eax
  800def:	01 d0                	add    %edx,%eax
  800df1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800df4:	eb 15                	jmp    800e0b <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800df6:	8b 45 08             	mov    0x8(%ebp),%eax
  800df9:	8a 00                	mov    (%eax),%al
  800dfb:	0f b6 d0             	movzbl %al,%edx
  800dfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e01:	0f b6 c0             	movzbl %al,%eax
  800e04:	39 c2                	cmp    %eax,%edx
  800e06:	74 0d                	je     800e15 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e08:	ff 45 08             	incl   0x8(%ebp)
  800e0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800e11:	72 e3                	jb     800df6 <memfind+0x13>
  800e13:	eb 01                	jmp    800e16 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800e15:	90                   	nop
	return (void *) s;
  800e16:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e19:	c9                   	leave  
  800e1a:	c3                   	ret    

00800e1b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e1b:	55                   	push   %ebp
  800e1c:	89 e5                	mov    %esp,%ebp
  800e1e:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800e21:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800e28:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e2f:	eb 03                	jmp    800e34 <strtol+0x19>
		s++;
  800e31:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e34:	8b 45 08             	mov    0x8(%ebp),%eax
  800e37:	8a 00                	mov    (%eax),%al
  800e39:	3c 20                	cmp    $0x20,%al
  800e3b:	74 f4                	je     800e31 <strtol+0x16>
  800e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e40:	8a 00                	mov    (%eax),%al
  800e42:	3c 09                	cmp    $0x9,%al
  800e44:	74 eb                	je     800e31 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e46:	8b 45 08             	mov    0x8(%ebp),%eax
  800e49:	8a 00                	mov    (%eax),%al
  800e4b:	3c 2b                	cmp    $0x2b,%al
  800e4d:	75 05                	jne    800e54 <strtol+0x39>
		s++;
  800e4f:	ff 45 08             	incl   0x8(%ebp)
  800e52:	eb 13                	jmp    800e67 <strtol+0x4c>
	else if (*s == '-')
  800e54:	8b 45 08             	mov    0x8(%ebp),%eax
  800e57:	8a 00                	mov    (%eax),%al
  800e59:	3c 2d                	cmp    $0x2d,%al
  800e5b:	75 0a                	jne    800e67 <strtol+0x4c>
		s++, neg = 1;
  800e5d:	ff 45 08             	incl   0x8(%ebp)
  800e60:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e67:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e6b:	74 06                	je     800e73 <strtol+0x58>
  800e6d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800e71:	75 20                	jne    800e93 <strtol+0x78>
  800e73:	8b 45 08             	mov    0x8(%ebp),%eax
  800e76:	8a 00                	mov    (%eax),%al
  800e78:	3c 30                	cmp    $0x30,%al
  800e7a:	75 17                	jne    800e93 <strtol+0x78>
  800e7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7f:	40                   	inc    %eax
  800e80:	8a 00                	mov    (%eax),%al
  800e82:	3c 78                	cmp    $0x78,%al
  800e84:	75 0d                	jne    800e93 <strtol+0x78>
		s += 2, base = 16;
  800e86:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800e8a:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800e91:	eb 28                	jmp    800ebb <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800e93:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e97:	75 15                	jne    800eae <strtol+0x93>
  800e99:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9c:	8a 00                	mov    (%eax),%al
  800e9e:	3c 30                	cmp    $0x30,%al
  800ea0:	75 0c                	jne    800eae <strtol+0x93>
		s++, base = 8;
  800ea2:	ff 45 08             	incl   0x8(%ebp)
  800ea5:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800eac:	eb 0d                	jmp    800ebb <strtol+0xa0>
	else if (base == 0)
  800eae:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eb2:	75 07                	jne    800ebb <strtol+0xa0>
		base = 10;
  800eb4:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebe:	8a 00                	mov    (%eax),%al
  800ec0:	3c 2f                	cmp    $0x2f,%al
  800ec2:	7e 19                	jle    800edd <strtol+0xc2>
  800ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec7:	8a 00                	mov    (%eax),%al
  800ec9:	3c 39                	cmp    $0x39,%al
  800ecb:	7f 10                	jg     800edd <strtol+0xc2>
			dig = *s - '0';
  800ecd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed0:	8a 00                	mov    (%eax),%al
  800ed2:	0f be c0             	movsbl %al,%eax
  800ed5:	83 e8 30             	sub    $0x30,%eax
  800ed8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800edb:	eb 42                	jmp    800f1f <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800edd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee0:	8a 00                	mov    (%eax),%al
  800ee2:	3c 60                	cmp    $0x60,%al
  800ee4:	7e 19                	jle    800eff <strtol+0xe4>
  800ee6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee9:	8a 00                	mov    (%eax),%al
  800eeb:	3c 7a                	cmp    $0x7a,%al
  800eed:	7f 10                	jg     800eff <strtol+0xe4>
			dig = *s - 'a' + 10;
  800eef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef2:	8a 00                	mov    (%eax),%al
  800ef4:	0f be c0             	movsbl %al,%eax
  800ef7:	83 e8 57             	sub    $0x57,%eax
  800efa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800efd:	eb 20                	jmp    800f1f <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800eff:	8b 45 08             	mov    0x8(%ebp),%eax
  800f02:	8a 00                	mov    (%eax),%al
  800f04:	3c 40                	cmp    $0x40,%al
  800f06:	7e 39                	jle    800f41 <strtol+0x126>
  800f08:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0b:	8a 00                	mov    (%eax),%al
  800f0d:	3c 5a                	cmp    $0x5a,%al
  800f0f:	7f 30                	jg     800f41 <strtol+0x126>
			dig = *s - 'A' + 10;
  800f11:	8b 45 08             	mov    0x8(%ebp),%eax
  800f14:	8a 00                	mov    (%eax),%al
  800f16:	0f be c0             	movsbl %al,%eax
  800f19:	83 e8 37             	sub    $0x37,%eax
  800f1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800f1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f22:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f25:	7d 19                	jge    800f40 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800f27:	ff 45 08             	incl   0x8(%ebp)
  800f2a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f2d:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f31:	89 c2                	mov    %eax,%edx
  800f33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f36:	01 d0                	add    %edx,%eax
  800f38:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800f3b:	e9 7b ff ff ff       	jmp    800ebb <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800f40:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800f41:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f45:	74 08                	je     800f4f <strtol+0x134>
		*endptr = (char *) s;
  800f47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f4d:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800f4f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f53:	74 07                	je     800f5c <strtol+0x141>
  800f55:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f58:	f7 d8                	neg    %eax
  800f5a:	eb 03                	jmp    800f5f <strtol+0x144>
  800f5c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f5f:	c9                   	leave  
  800f60:	c3                   	ret    

00800f61 <ltostr>:

void
ltostr(long value, char *str)
{
  800f61:	55                   	push   %ebp
  800f62:	89 e5                	mov    %esp,%ebp
  800f64:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800f67:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800f6e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800f75:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f79:	79 13                	jns    800f8e <ltostr+0x2d>
	{
		neg = 1;
  800f7b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800f82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f85:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800f88:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800f8b:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800f8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f91:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800f96:	99                   	cltd   
  800f97:	f7 f9                	idiv   %ecx
  800f99:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800f9c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f9f:	8d 50 01             	lea    0x1(%eax),%edx
  800fa2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fa5:	89 c2                	mov    %eax,%edx
  800fa7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800faa:	01 d0                	add    %edx,%eax
  800fac:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800faf:	83 c2 30             	add    $0x30,%edx
  800fb2:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800fb4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fb7:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800fbc:	f7 e9                	imul   %ecx
  800fbe:	c1 fa 02             	sar    $0x2,%edx
  800fc1:	89 c8                	mov    %ecx,%eax
  800fc3:	c1 f8 1f             	sar    $0x1f,%eax
  800fc6:	29 c2                	sub    %eax,%edx
  800fc8:	89 d0                	mov    %edx,%eax
  800fca:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  800fcd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fd1:	75 bb                	jne    800f8e <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800fd3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800fda:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fdd:	48                   	dec    %eax
  800fde:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800fe1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800fe5:	74 3d                	je     801024 <ltostr+0xc3>
		start = 1 ;
  800fe7:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800fee:	eb 34                	jmp    801024 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  800ff0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ff3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff6:	01 d0                	add    %edx,%eax
  800ff8:	8a 00                	mov    (%eax),%al
  800ffa:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800ffd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801000:	8b 45 0c             	mov    0xc(%ebp),%eax
  801003:	01 c2                	add    %eax,%edx
  801005:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801008:	8b 45 0c             	mov    0xc(%ebp),%eax
  80100b:	01 c8                	add    %ecx,%eax
  80100d:	8a 00                	mov    (%eax),%al
  80100f:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801011:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801014:	8b 45 0c             	mov    0xc(%ebp),%eax
  801017:	01 c2                	add    %eax,%edx
  801019:	8a 45 eb             	mov    -0x15(%ebp),%al
  80101c:	88 02                	mov    %al,(%edx)
		start++ ;
  80101e:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801021:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801024:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801027:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80102a:	7c c4                	jl     800ff0 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80102c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80102f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801032:	01 d0                	add    %edx,%eax
  801034:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801037:	90                   	nop
  801038:	c9                   	leave  
  801039:	c3                   	ret    

0080103a <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80103a:	55                   	push   %ebp
  80103b:	89 e5                	mov    %esp,%ebp
  80103d:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801040:	ff 75 08             	pushl  0x8(%ebp)
  801043:	e8 c4 f9 ff ff       	call   800a0c <strlen>
  801048:	83 c4 04             	add    $0x4,%esp
  80104b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80104e:	ff 75 0c             	pushl  0xc(%ebp)
  801051:	e8 b6 f9 ff ff       	call   800a0c <strlen>
  801056:	83 c4 04             	add    $0x4,%esp
  801059:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80105c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801063:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80106a:	eb 17                	jmp    801083 <strcconcat+0x49>
		final[s] = str1[s] ;
  80106c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80106f:	8b 45 10             	mov    0x10(%ebp),%eax
  801072:	01 c2                	add    %eax,%edx
  801074:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801077:	8b 45 08             	mov    0x8(%ebp),%eax
  80107a:	01 c8                	add    %ecx,%eax
  80107c:	8a 00                	mov    (%eax),%al
  80107e:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801080:	ff 45 fc             	incl   -0x4(%ebp)
  801083:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801086:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801089:	7c e1                	jl     80106c <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80108b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801092:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801099:	eb 1f                	jmp    8010ba <strcconcat+0x80>
		final[s++] = str2[i] ;
  80109b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80109e:	8d 50 01             	lea    0x1(%eax),%edx
  8010a1:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8010a4:	89 c2                	mov    %eax,%edx
  8010a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8010a9:	01 c2                	add    %eax,%edx
  8010ab:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b1:	01 c8                	add    %ecx,%eax
  8010b3:	8a 00                	mov    (%eax),%al
  8010b5:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8010b7:	ff 45 f8             	incl   -0x8(%ebp)
  8010ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010bd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8010c0:	7c d9                	jl     80109b <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8010c2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8010c8:	01 d0                	add    %edx,%eax
  8010ca:	c6 00 00             	movb   $0x0,(%eax)
}
  8010cd:	90                   	nop
  8010ce:	c9                   	leave  
  8010cf:	c3                   	ret    

008010d0 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8010d0:	55                   	push   %ebp
  8010d1:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8010d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8010d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8010dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8010df:	8b 00                	mov    (%eax),%eax
  8010e1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8010eb:	01 d0                	add    %edx,%eax
  8010ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8010f3:	eb 0c                	jmp    801101 <strsplit+0x31>
			*string++ = 0;
  8010f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f8:	8d 50 01             	lea    0x1(%eax),%edx
  8010fb:	89 55 08             	mov    %edx,0x8(%ebp)
  8010fe:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801101:	8b 45 08             	mov    0x8(%ebp),%eax
  801104:	8a 00                	mov    (%eax),%al
  801106:	84 c0                	test   %al,%al
  801108:	74 18                	je     801122 <strsplit+0x52>
  80110a:	8b 45 08             	mov    0x8(%ebp),%eax
  80110d:	8a 00                	mov    (%eax),%al
  80110f:	0f be c0             	movsbl %al,%eax
  801112:	50                   	push   %eax
  801113:	ff 75 0c             	pushl  0xc(%ebp)
  801116:	e8 83 fa ff ff       	call   800b9e <strchr>
  80111b:	83 c4 08             	add    $0x8,%esp
  80111e:	85 c0                	test   %eax,%eax
  801120:	75 d3                	jne    8010f5 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801122:	8b 45 08             	mov    0x8(%ebp),%eax
  801125:	8a 00                	mov    (%eax),%al
  801127:	84 c0                	test   %al,%al
  801129:	74 5a                	je     801185 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80112b:	8b 45 14             	mov    0x14(%ebp),%eax
  80112e:	8b 00                	mov    (%eax),%eax
  801130:	83 f8 0f             	cmp    $0xf,%eax
  801133:	75 07                	jne    80113c <strsplit+0x6c>
		{
			return 0;
  801135:	b8 00 00 00 00       	mov    $0x0,%eax
  80113a:	eb 66                	jmp    8011a2 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80113c:	8b 45 14             	mov    0x14(%ebp),%eax
  80113f:	8b 00                	mov    (%eax),%eax
  801141:	8d 48 01             	lea    0x1(%eax),%ecx
  801144:	8b 55 14             	mov    0x14(%ebp),%edx
  801147:	89 0a                	mov    %ecx,(%edx)
  801149:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801150:	8b 45 10             	mov    0x10(%ebp),%eax
  801153:	01 c2                	add    %eax,%edx
  801155:	8b 45 08             	mov    0x8(%ebp),%eax
  801158:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80115a:	eb 03                	jmp    80115f <strsplit+0x8f>
			string++;
  80115c:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80115f:	8b 45 08             	mov    0x8(%ebp),%eax
  801162:	8a 00                	mov    (%eax),%al
  801164:	84 c0                	test   %al,%al
  801166:	74 8b                	je     8010f3 <strsplit+0x23>
  801168:	8b 45 08             	mov    0x8(%ebp),%eax
  80116b:	8a 00                	mov    (%eax),%al
  80116d:	0f be c0             	movsbl %al,%eax
  801170:	50                   	push   %eax
  801171:	ff 75 0c             	pushl  0xc(%ebp)
  801174:	e8 25 fa ff ff       	call   800b9e <strchr>
  801179:	83 c4 08             	add    $0x8,%esp
  80117c:	85 c0                	test   %eax,%eax
  80117e:	74 dc                	je     80115c <strsplit+0x8c>
			string++;
	}
  801180:	e9 6e ff ff ff       	jmp    8010f3 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801185:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801186:	8b 45 14             	mov    0x14(%ebp),%eax
  801189:	8b 00                	mov    (%eax),%eax
  80118b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801192:	8b 45 10             	mov    0x10(%ebp),%eax
  801195:	01 d0                	add    %edx,%eax
  801197:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80119d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8011a2:	c9                   	leave  
  8011a3:	c3                   	ret    

008011a4 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8011a4:	55                   	push   %ebp
  8011a5:	89 e5                	mov    %esp,%ebp
  8011a7:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8011aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ad:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8011b0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011b7:	eb 4a                	jmp    801203 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8011b9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bf:	01 c2                	add    %eax,%edx
  8011c1:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c7:	01 c8                	add    %ecx,%eax
  8011c9:	8a 00                	mov    (%eax),%al
  8011cb:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8011cd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d3:	01 d0                	add    %edx,%eax
  8011d5:	8a 00                	mov    (%eax),%al
  8011d7:	3c 40                	cmp    $0x40,%al
  8011d9:	7e 25                	jle    801200 <str2lower+0x5c>
  8011db:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e1:	01 d0                	add    %edx,%eax
  8011e3:	8a 00                	mov    (%eax),%al
  8011e5:	3c 5a                	cmp    $0x5a,%al
  8011e7:	7f 17                	jg     801200 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8011e9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ef:	01 d0                	add    %edx,%eax
  8011f1:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8011f7:	01 ca                	add    %ecx,%edx
  8011f9:	8a 12                	mov    (%edx),%dl
  8011fb:	83 c2 20             	add    $0x20,%edx
  8011fe:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801200:	ff 45 fc             	incl   -0x4(%ebp)
  801203:	ff 75 0c             	pushl  0xc(%ebp)
  801206:	e8 01 f8 ff ff       	call   800a0c <strlen>
  80120b:	83 c4 04             	add    $0x4,%esp
  80120e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801211:	7f a6                	jg     8011b9 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801213:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801216:	c9                   	leave  
  801217:	c3                   	ret    

00801218 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801218:	55                   	push   %ebp
  801219:	89 e5                	mov    %esp,%ebp
  80121b:	57                   	push   %edi
  80121c:	56                   	push   %esi
  80121d:	53                   	push   %ebx
  80121e:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801221:	8b 45 08             	mov    0x8(%ebp),%eax
  801224:	8b 55 0c             	mov    0xc(%ebp),%edx
  801227:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80122a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80122d:	8b 7d 18             	mov    0x18(%ebp),%edi
  801230:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801233:	cd 30                	int    $0x30
  801235:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801238:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80123b:	83 c4 10             	add    $0x10,%esp
  80123e:	5b                   	pop    %ebx
  80123f:	5e                   	pop    %esi
  801240:	5f                   	pop    %edi
  801241:	5d                   	pop    %ebp
  801242:	c3                   	ret    

00801243 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801243:	55                   	push   %ebp
  801244:	89 e5                	mov    %esp,%ebp
  801246:	83 ec 04             	sub    $0x4,%esp
  801249:	8b 45 10             	mov    0x10(%ebp),%eax
  80124c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  80124f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801252:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801256:	8b 45 08             	mov    0x8(%ebp),%eax
  801259:	6a 00                	push   $0x0
  80125b:	51                   	push   %ecx
  80125c:	52                   	push   %edx
  80125d:	ff 75 0c             	pushl  0xc(%ebp)
  801260:	50                   	push   %eax
  801261:	6a 00                	push   $0x0
  801263:	e8 b0 ff ff ff       	call   801218 <syscall>
  801268:	83 c4 18             	add    $0x18,%esp
}
  80126b:	90                   	nop
  80126c:	c9                   	leave  
  80126d:	c3                   	ret    

0080126e <sys_cgetc>:

int
sys_cgetc(void)
{
  80126e:	55                   	push   %ebp
  80126f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801271:	6a 00                	push   $0x0
  801273:	6a 00                	push   $0x0
  801275:	6a 00                	push   $0x0
  801277:	6a 00                	push   $0x0
  801279:	6a 00                	push   $0x0
  80127b:	6a 02                	push   $0x2
  80127d:	e8 96 ff ff ff       	call   801218 <syscall>
  801282:	83 c4 18             	add    $0x18,%esp
}
  801285:	c9                   	leave  
  801286:	c3                   	ret    

00801287 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801287:	55                   	push   %ebp
  801288:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80128a:	6a 00                	push   $0x0
  80128c:	6a 00                	push   $0x0
  80128e:	6a 00                	push   $0x0
  801290:	6a 00                	push   $0x0
  801292:	6a 00                	push   $0x0
  801294:	6a 03                	push   $0x3
  801296:	e8 7d ff ff ff       	call   801218 <syscall>
  80129b:	83 c4 18             	add    $0x18,%esp
}
  80129e:	90                   	nop
  80129f:	c9                   	leave  
  8012a0:	c3                   	ret    

008012a1 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8012a1:	55                   	push   %ebp
  8012a2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8012a4:	6a 00                	push   $0x0
  8012a6:	6a 00                	push   $0x0
  8012a8:	6a 00                	push   $0x0
  8012aa:	6a 00                	push   $0x0
  8012ac:	6a 00                	push   $0x0
  8012ae:	6a 04                	push   $0x4
  8012b0:	e8 63 ff ff ff       	call   801218 <syscall>
  8012b5:	83 c4 18             	add    $0x18,%esp
}
  8012b8:	90                   	nop
  8012b9:	c9                   	leave  
  8012ba:	c3                   	ret    

008012bb <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8012bb:	55                   	push   %ebp
  8012bc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8012be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c4:	6a 00                	push   $0x0
  8012c6:	6a 00                	push   $0x0
  8012c8:	6a 00                	push   $0x0
  8012ca:	52                   	push   %edx
  8012cb:	50                   	push   %eax
  8012cc:	6a 08                	push   $0x8
  8012ce:	e8 45 ff ff ff       	call   801218 <syscall>
  8012d3:	83 c4 18             	add    $0x18,%esp
}
  8012d6:	c9                   	leave  
  8012d7:	c3                   	ret    

008012d8 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8012d8:	55                   	push   %ebp
  8012d9:	89 e5                	mov    %esp,%ebp
  8012db:	56                   	push   %esi
  8012dc:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8012dd:	8b 75 18             	mov    0x18(%ebp),%esi
  8012e0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012e3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ec:	56                   	push   %esi
  8012ed:	53                   	push   %ebx
  8012ee:	51                   	push   %ecx
  8012ef:	52                   	push   %edx
  8012f0:	50                   	push   %eax
  8012f1:	6a 09                	push   $0x9
  8012f3:	e8 20 ff ff ff       	call   801218 <syscall>
  8012f8:	83 c4 18             	add    $0x18,%esp
}
  8012fb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012fe:	5b                   	pop    %ebx
  8012ff:	5e                   	pop    %esi
  801300:	5d                   	pop    %ebp
  801301:	c3                   	ret    

00801302 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801302:	55                   	push   %ebp
  801303:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801305:	6a 00                	push   $0x0
  801307:	6a 00                	push   $0x0
  801309:	6a 00                	push   $0x0
  80130b:	6a 00                	push   $0x0
  80130d:	ff 75 08             	pushl  0x8(%ebp)
  801310:	6a 0a                	push   $0xa
  801312:	e8 01 ff ff ff       	call   801218 <syscall>
  801317:	83 c4 18             	add    $0x18,%esp
}
  80131a:	c9                   	leave  
  80131b:	c3                   	ret    

0080131c <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80131c:	55                   	push   %ebp
  80131d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80131f:	6a 00                	push   $0x0
  801321:	6a 00                	push   $0x0
  801323:	6a 00                	push   $0x0
  801325:	ff 75 0c             	pushl  0xc(%ebp)
  801328:	ff 75 08             	pushl  0x8(%ebp)
  80132b:	6a 0b                	push   $0xb
  80132d:	e8 e6 fe ff ff       	call   801218 <syscall>
  801332:	83 c4 18             	add    $0x18,%esp
}
  801335:	c9                   	leave  
  801336:	c3                   	ret    

00801337 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801337:	55                   	push   %ebp
  801338:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80133a:	6a 00                	push   $0x0
  80133c:	6a 00                	push   $0x0
  80133e:	6a 00                	push   $0x0
  801340:	6a 00                	push   $0x0
  801342:	6a 00                	push   $0x0
  801344:	6a 0c                	push   $0xc
  801346:	e8 cd fe ff ff       	call   801218 <syscall>
  80134b:	83 c4 18             	add    $0x18,%esp
}
  80134e:	c9                   	leave  
  80134f:	c3                   	ret    

00801350 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801350:	55                   	push   %ebp
  801351:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801353:	6a 00                	push   $0x0
  801355:	6a 00                	push   $0x0
  801357:	6a 00                	push   $0x0
  801359:	6a 00                	push   $0x0
  80135b:	6a 00                	push   $0x0
  80135d:	6a 0d                	push   $0xd
  80135f:	e8 b4 fe ff ff       	call   801218 <syscall>
  801364:	83 c4 18             	add    $0x18,%esp
}
  801367:	c9                   	leave  
  801368:	c3                   	ret    

00801369 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801369:	55                   	push   %ebp
  80136a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80136c:	6a 00                	push   $0x0
  80136e:	6a 00                	push   $0x0
  801370:	6a 00                	push   $0x0
  801372:	6a 00                	push   $0x0
  801374:	6a 00                	push   $0x0
  801376:	6a 0e                	push   $0xe
  801378:	e8 9b fe ff ff       	call   801218 <syscall>
  80137d:	83 c4 18             	add    $0x18,%esp
}
  801380:	c9                   	leave  
  801381:	c3                   	ret    

00801382 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801382:	55                   	push   %ebp
  801383:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801385:	6a 00                	push   $0x0
  801387:	6a 00                	push   $0x0
  801389:	6a 00                	push   $0x0
  80138b:	6a 00                	push   $0x0
  80138d:	6a 00                	push   $0x0
  80138f:	6a 0f                	push   $0xf
  801391:	e8 82 fe ff ff       	call   801218 <syscall>
  801396:	83 c4 18             	add    $0x18,%esp
}
  801399:	c9                   	leave  
  80139a:	c3                   	ret    

0080139b <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80139b:	55                   	push   %ebp
  80139c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80139e:	6a 00                	push   $0x0
  8013a0:	6a 00                	push   $0x0
  8013a2:	6a 00                	push   $0x0
  8013a4:	6a 00                	push   $0x0
  8013a6:	ff 75 08             	pushl  0x8(%ebp)
  8013a9:	6a 10                	push   $0x10
  8013ab:	e8 68 fe ff ff       	call   801218 <syscall>
  8013b0:	83 c4 18             	add    $0x18,%esp
}
  8013b3:	c9                   	leave  
  8013b4:	c3                   	ret    

008013b5 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8013b5:	55                   	push   %ebp
  8013b6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8013b8:	6a 00                	push   $0x0
  8013ba:	6a 00                	push   $0x0
  8013bc:	6a 00                	push   $0x0
  8013be:	6a 00                	push   $0x0
  8013c0:	6a 00                	push   $0x0
  8013c2:	6a 11                	push   $0x11
  8013c4:	e8 4f fe ff ff       	call   801218 <syscall>
  8013c9:	83 c4 18             	add    $0x18,%esp
}
  8013cc:	90                   	nop
  8013cd:	c9                   	leave  
  8013ce:	c3                   	ret    

008013cf <sys_cputc>:

void
sys_cputc(const char c)
{
  8013cf:	55                   	push   %ebp
  8013d0:	89 e5                	mov    %esp,%ebp
  8013d2:	83 ec 04             	sub    $0x4,%esp
  8013d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8013db:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8013df:	6a 00                	push   $0x0
  8013e1:	6a 00                	push   $0x0
  8013e3:	6a 00                	push   $0x0
  8013e5:	6a 00                	push   $0x0
  8013e7:	50                   	push   %eax
  8013e8:	6a 01                	push   $0x1
  8013ea:	e8 29 fe ff ff       	call   801218 <syscall>
  8013ef:	83 c4 18             	add    $0x18,%esp
}
  8013f2:	90                   	nop
  8013f3:	c9                   	leave  
  8013f4:	c3                   	ret    

008013f5 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8013f5:	55                   	push   %ebp
  8013f6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8013f8:	6a 00                	push   $0x0
  8013fa:	6a 00                	push   $0x0
  8013fc:	6a 00                	push   $0x0
  8013fe:	6a 00                	push   $0x0
  801400:	6a 00                	push   $0x0
  801402:	6a 14                	push   $0x14
  801404:	e8 0f fe ff ff       	call   801218 <syscall>
  801409:	83 c4 18             	add    $0x18,%esp
}
  80140c:	90                   	nop
  80140d:	c9                   	leave  
  80140e:	c3                   	ret    

0080140f <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80140f:	55                   	push   %ebp
  801410:	89 e5                	mov    %esp,%ebp
  801412:	83 ec 04             	sub    $0x4,%esp
  801415:	8b 45 10             	mov    0x10(%ebp),%eax
  801418:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80141b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80141e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801422:	8b 45 08             	mov    0x8(%ebp),%eax
  801425:	6a 00                	push   $0x0
  801427:	51                   	push   %ecx
  801428:	52                   	push   %edx
  801429:	ff 75 0c             	pushl  0xc(%ebp)
  80142c:	50                   	push   %eax
  80142d:	6a 15                	push   $0x15
  80142f:	e8 e4 fd ff ff       	call   801218 <syscall>
  801434:	83 c4 18             	add    $0x18,%esp
}
  801437:	c9                   	leave  
  801438:	c3                   	ret    

00801439 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801439:	55                   	push   %ebp
  80143a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80143c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80143f:	8b 45 08             	mov    0x8(%ebp),%eax
  801442:	6a 00                	push   $0x0
  801444:	6a 00                	push   $0x0
  801446:	6a 00                	push   $0x0
  801448:	52                   	push   %edx
  801449:	50                   	push   %eax
  80144a:	6a 16                	push   $0x16
  80144c:	e8 c7 fd ff ff       	call   801218 <syscall>
  801451:	83 c4 18             	add    $0x18,%esp
}
  801454:	c9                   	leave  
  801455:	c3                   	ret    

00801456 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801456:	55                   	push   %ebp
  801457:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801459:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80145c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80145f:	8b 45 08             	mov    0x8(%ebp),%eax
  801462:	6a 00                	push   $0x0
  801464:	6a 00                	push   $0x0
  801466:	51                   	push   %ecx
  801467:	52                   	push   %edx
  801468:	50                   	push   %eax
  801469:	6a 17                	push   $0x17
  80146b:	e8 a8 fd ff ff       	call   801218 <syscall>
  801470:	83 c4 18             	add    $0x18,%esp
}
  801473:	c9                   	leave  
  801474:	c3                   	ret    

00801475 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801475:	55                   	push   %ebp
  801476:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801478:	8b 55 0c             	mov    0xc(%ebp),%edx
  80147b:	8b 45 08             	mov    0x8(%ebp),%eax
  80147e:	6a 00                	push   $0x0
  801480:	6a 00                	push   $0x0
  801482:	6a 00                	push   $0x0
  801484:	52                   	push   %edx
  801485:	50                   	push   %eax
  801486:	6a 18                	push   $0x18
  801488:	e8 8b fd ff ff       	call   801218 <syscall>
  80148d:	83 c4 18             	add    $0x18,%esp
}
  801490:	c9                   	leave  
  801491:	c3                   	ret    

00801492 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801492:	55                   	push   %ebp
  801493:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801495:	8b 45 08             	mov    0x8(%ebp),%eax
  801498:	6a 00                	push   $0x0
  80149a:	ff 75 14             	pushl  0x14(%ebp)
  80149d:	ff 75 10             	pushl  0x10(%ebp)
  8014a0:	ff 75 0c             	pushl  0xc(%ebp)
  8014a3:	50                   	push   %eax
  8014a4:	6a 19                	push   $0x19
  8014a6:	e8 6d fd ff ff       	call   801218 <syscall>
  8014ab:	83 c4 18             	add    $0x18,%esp
}
  8014ae:	c9                   	leave  
  8014af:	c3                   	ret    

008014b0 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8014b0:	55                   	push   %ebp
  8014b1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8014b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b6:	6a 00                	push   $0x0
  8014b8:	6a 00                	push   $0x0
  8014ba:	6a 00                	push   $0x0
  8014bc:	6a 00                	push   $0x0
  8014be:	50                   	push   %eax
  8014bf:	6a 1a                	push   $0x1a
  8014c1:	e8 52 fd ff ff       	call   801218 <syscall>
  8014c6:	83 c4 18             	add    $0x18,%esp
}
  8014c9:	90                   	nop
  8014ca:	c9                   	leave  
  8014cb:	c3                   	ret    

008014cc <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8014cc:	55                   	push   %ebp
  8014cd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8014cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d2:	6a 00                	push   $0x0
  8014d4:	6a 00                	push   $0x0
  8014d6:	6a 00                	push   $0x0
  8014d8:	6a 00                	push   $0x0
  8014da:	50                   	push   %eax
  8014db:	6a 1b                	push   $0x1b
  8014dd:	e8 36 fd ff ff       	call   801218 <syscall>
  8014e2:	83 c4 18             	add    $0x18,%esp
}
  8014e5:	c9                   	leave  
  8014e6:	c3                   	ret    

008014e7 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8014e7:	55                   	push   %ebp
  8014e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8014ea:	6a 00                	push   $0x0
  8014ec:	6a 00                	push   $0x0
  8014ee:	6a 00                	push   $0x0
  8014f0:	6a 00                	push   $0x0
  8014f2:	6a 00                	push   $0x0
  8014f4:	6a 05                	push   $0x5
  8014f6:	e8 1d fd ff ff       	call   801218 <syscall>
  8014fb:	83 c4 18             	add    $0x18,%esp
}
  8014fe:	c9                   	leave  
  8014ff:	c3                   	ret    

00801500 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801500:	55                   	push   %ebp
  801501:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801503:	6a 00                	push   $0x0
  801505:	6a 00                	push   $0x0
  801507:	6a 00                	push   $0x0
  801509:	6a 00                	push   $0x0
  80150b:	6a 00                	push   $0x0
  80150d:	6a 06                	push   $0x6
  80150f:	e8 04 fd ff ff       	call   801218 <syscall>
  801514:	83 c4 18             	add    $0x18,%esp
}
  801517:	c9                   	leave  
  801518:	c3                   	ret    

00801519 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801519:	55                   	push   %ebp
  80151a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80151c:	6a 00                	push   $0x0
  80151e:	6a 00                	push   $0x0
  801520:	6a 00                	push   $0x0
  801522:	6a 00                	push   $0x0
  801524:	6a 00                	push   $0x0
  801526:	6a 07                	push   $0x7
  801528:	e8 eb fc ff ff       	call   801218 <syscall>
  80152d:	83 c4 18             	add    $0x18,%esp
}
  801530:	c9                   	leave  
  801531:	c3                   	ret    

00801532 <sys_exit_env>:


void sys_exit_env(void)
{
  801532:	55                   	push   %ebp
  801533:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801535:	6a 00                	push   $0x0
  801537:	6a 00                	push   $0x0
  801539:	6a 00                	push   $0x0
  80153b:	6a 00                	push   $0x0
  80153d:	6a 00                	push   $0x0
  80153f:	6a 1c                	push   $0x1c
  801541:	e8 d2 fc ff ff       	call   801218 <syscall>
  801546:	83 c4 18             	add    $0x18,%esp
}
  801549:	90                   	nop
  80154a:	c9                   	leave  
  80154b:	c3                   	ret    

0080154c <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80154c:	55                   	push   %ebp
  80154d:	89 e5                	mov    %esp,%ebp
  80154f:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801552:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801555:	8d 50 04             	lea    0x4(%eax),%edx
  801558:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80155b:	6a 00                	push   $0x0
  80155d:	6a 00                	push   $0x0
  80155f:	6a 00                	push   $0x0
  801561:	52                   	push   %edx
  801562:	50                   	push   %eax
  801563:	6a 1d                	push   $0x1d
  801565:	e8 ae fc ff ff       	call   801218 <syscall>
  80156a:	83 c4 18             	add    $0x18,%esp
	return result;
  80156d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801570:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801573:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801576:	89 01                	mov    %eax,(%ecx)
  801578:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80157b:	8b 45 08             	mov    0x8(%ebp),%eax
  80157e:	c9                   	leave  
  80157f:	c2 04 00             	ret    $0x4

00801582 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801582:	55                   	push   %ebp
  801583:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801585:	6a 00                	push   $0x0
  801587:	6a 00                	push   $0x0
  801589:	ff 75 10             	pushl  0x10(%ebp)
  80158c:	ff 75 0c             	pushl  0xc(%ebp)
  80158f:	ff 75 08             	pushl  0x8(%ebp)
  801592:	6a 13                	push   $0x13
  801594:	e8 7f fc ff ff       	call   801218 <syscall>
  801599:	83 c4 18             	add    $0x18,%esp
	return ;
  80159c:	90                   	nop
}
  80159d:	c9                   	leave  
  80159e:	c3                   	ret    

0080159f <sys_rcr2>:
uint32 sys_rcr2()
{
  80159f:	55                   	push   %ebp
  8015a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8015a2:	6a 00                	push   $0x0
  8015a4:	6a 00                	push   $0x0
  8015a6:	6a 00                	push   $0x0
  8015a8:	6a 00                	push   $0x0
  8015aa:	6a 00                	push   $0x0
  8015ac:	6a 1e                	push   $0x1e
  8015ae:	e8 65 fc ff ff       	call   801218 <syscall>
  8015b3:	83 c4 18             	add    $0x18,%esp
}
  8015b6:	c9                   	leave  
  8015b7:	c3                   	ret    

008015b8 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8015b8:	55                   	push   %ebp
  8015b9:	89 e5                	mov    %esp,%ebp
  8015bb:	83 ec 04             	sub    $0x4,%esp
  8015be:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8015c4:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8015c8:	6a 00                	push   $0x0
  8015ca:	6a 00                	push   $0x0
  8015cc:	6a 00                	push   $0x0
  8015ce:	6a 00                	push   $0x0
  8015d0:	50                   	push   %eax
  8015d1:	6a 1f                	push   $0x1f
  8015d3:	e8 40 fc ff ff       	call   801218 <syscall>
  8015d8:	83 c4 18             	add    $0x18,%esp
	return ;
  8015db:	90                   	nop
}
  8015dc:	c9                   	leave  
  8015dd:	c3                   	ret    

008015de <rsttst>:
void rsttst()
{
  8015de:	55                   	push   %ebp
  8015df:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8015e1:	6a 00                	push   $0x0
  8015e3:	6a 00                	push   $0x0
  8015e5:	6a 00                	push   $0x0
  8015e7:	6a 00                	push   $0x0
  8015e9:	6a 00                	push   $0x0
  8015eb:	6a 21                	push   $0x21
  8015ed:	e8 26 fc ff ff       	call   801218 <syscall>
  8015f2:	83 c4 18             	add    $0x18,%esp
	return ;
  8015f5:	90                   	nop
}
  8015f6:	c9                   	leave  
  8015f7:	c3                   	ret    

008015f8 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8015f8:	55                   	push   %ebp
  8015f9:	89 e5                	mov    %esp,%ebp
  8015fb:	83 ec 04             	sub    $0x4,%esp
  8015fe:	8b 45 14             	mov    0x14(%ebp),%eax
  801601:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801604:	8b 55 18             	mov    0x18(%ebp),%edx
  801607:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80160b:	52                   	push   %edx
  80160c:	50                   	push   %eax
  80160d:	ff 75 10             	pushl  0x10(%ebp)
  801610:	ff 75 0c             	pushl  0xc(%ebp)
  801613:	ff 75 08             	pushl  0x8(%ebp)
  801616:	6a 20                	push   $0x20
  801618:	e8 fb fb ff ff       	call   801218 <syscall>
  80161d:	83 c4 18             	add    $0x18,%esp
	return ;
  801620:	90                   	nop
}
  801621:	c9                   	leave  
  801622:	c3                   	ret    

00801623 <chktst>:
void chktst(uint32 n)
{
  801623:	55                   	push   %ebp
  801624:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801626:	6a 00                	push   $0x0
  801628:	6a 00                	push   $0x0
  80162a:	6a 00                	push   $0x0
  80162c:	6a 00                	push   $0x0
  80162e:	ff 75 08             	pushl  0x8(%ebp)
  801631:	6a 22                	push   $0x22
  801633:	e8 e0 fb ff ff       	call   801218 <syscall>
  801638:	83 c4 18             	add    $0x18,%esp
	return ;
  80163b:	90                   	nop
}
  80163c:	c9                   	leave  
  80163d:	c3                   	ret    

0080163e <inctst>:

void inctst()
{
  80163e:	55                   	push   %ebp
  80163f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801641:	6a 00                	push   $0x0
  801643:	6a 00                	push   $0x0
  801645:	6a 00                	push   $0x0
  801647:	6a 00                	push   $0x0
  801649:	6a 00                	push   $0x0
  80164b:	6a 23                	push   $0x23
  80164d:	e8 c6 fb ff ff       	call   801218 <syscall>
  801652:	83 c4 18             	add    $0x18,%esp
	return ;
  801655:	90                   	nop
}
  801656:	c9                   	leave  
  801657:	c3                   	ret    

00801658 <gettst>:
uint32 gettst()
{
  801658:	55                   	push   %ebp
  801659:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80165b:	6a 00                	push   $0x0
  80165d:	6a 00                	push   $0x0
  80165f:	6a 00                	push   $0x0
  801661:	6a 00                	push   $0x0
  801663:	6a 00                	push   $0x0
  801665:	6a 24                	push   $0x24
  801667:	e8 ac fb ff ff       	call   801218 <syscall>
  80166c:	83 c4 18             	add    $0x18,%esp
}
  80166f:	c9                   	leave  
  801670:	c3                   	ret    

00801671 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801671:	55                   	push   %ebp
  801672:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801674:	6a 00                	push   $0x0
  801676:	6a 00                	push   $0x0
  801678:	6a 00                	push   $0x0
  80167a:	6a 00                	push   $0x0
  80167c:	6a 00                	push   $0x0
  80167e:	6a 25                	push   $0x25
  801680:	e8 93 fb ff ff       	call   801218 <syscall>
  801685:	83 c4 18             	add    $0x18,%esp
  801688:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  80168d:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801692:	c9                   	leave  
  801693:	c3                   	ret    

00801694 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801694:	55                   	push   %ebp
  801695:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801697:	8b 45 08             	mov    0x8(%ebp),%eax
  80169a:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80169f:	6a 00                	push   $0x0
  8016a1:	6a 00                	push   $0x0
  8016a3:	6a 00                	push   $0x0
  8016a5:	6a 00                	push   $0x0
  8016a7:	ff 75 08             	pushl  0x8(%ebp)
  8016aa:	6a 26                	push   $0x26
  8016ac:	e8 67 fb ff ff       	call   801218 <syscall>
  8016b1:	83 c4 18             	add    $0x18,%esp
	return ;
  8016b4:	90                   	nop
}
  8016b5:	c9                   	leave  
  8016b6:	c3                   	ret    

008016b7 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8016b7:	55                   	push   %ebp
  8016b8:	89 e5                	mov    %esp,%ebp
  8016ba:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8016bb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016be:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c7:	6a 00                	push   $0x0
  8016c9:	53                   	push   %ebx
  8016ca:	51                   	push   %ecx
  8016cb:	52                   	push   %edx
  8016cc:	50                   	push   %eax
  8016cd:	6a 27                	push   $0x27
  8016cf:	e8 44 fb ff ff       	call   801218 <syscall>
  8016d4:	83 c4 18             	add    $0x18,%esp
}
  8016d7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016da:	c9                   	leave  
  8016db:	c3                   	ret    

008016dc <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8016dc:	55                   	push   %ebp
  8016dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8016df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e5:	6a 00                	push   $0x0
  8016e7:	6a 00                	push   $0x0
  8016e9:	6a 00                	push   $0x0
  8016eb:	52                   	push   %edx
  8016ec:	50                   	push   %eax
  8016ed:	6a 28                	push   $0x28
  8016ef:	e8 24 fb ff ff       	call   801218 <syscall>
  8016f4:	83 c4 18             	add    $0x18,%esp
}
  8016f7:	c9                   	leave  
  8016f8:	c3                   	ret    

008016f9 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8016f9:	55                   	push   %ebp
  8016fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8016fc:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8016ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801702:	8b 45 08             	mov    0x8(%ebp),%eax
  801705:	6a 00                	push   $0x0
  801707:	51                   	push   %ecx
  801708:	ff 75 10             	pushl  0x10(%ebp)
  80170b:	52                   	push   %edx
  80170c:	50                   	push   %eax
  80170d:	6a 29                	push   $0x29
  80170f:	e8 04 fb ff ff       	call   801218 <syscall>
  801714:	83 c4 18             	add    $0x18,%esp
}
  801717:	c9                   	leave  
  801718:	c3                   	ret    

00801719 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801719:	55                   	push   %ebp
  80171a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80171c:	6a 00                	push   $0x0
  80171e:	6a 00                	push   $0x0
  801720:	ff 75 10             	pushl  0x10(%ebp)
  801723:	ff 75 0c             	pushl  0xc(%ebp)
  801726:	ff 75 08             	pushl  0x8(%ebp)
  801729:	6a 12                	push   $0x12
  80172b:	e8 e8 fa ff ff       	call   801218 <syscall>
  801730:	83 c4 18             	add    $0x18,%esp
	return ;
  801733:	90                   	nop
}
  801734:	c9                   	leave  
  801735:	c3                   	ret    

00801736 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801736:	55                   	push   %ebp
  801737:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801739:	8b 55 0c             	mov    0xc(%ebp),%edx
  80173c:	8b 45 08             	mov    0x8(%ebp),%eax
  80173f:	6a 00                	push   $0x0
  801741:	6a 00                	push   $0x0
  801743:	6a 00                	push   $0x0
  801745:	52                   	push   %edx
  801746:	50                   	push   %eax
  801747:	6a 2a                	push   $0x2a
  801749:	e8 ca fa ff ff       	call   801218 <syscall>
  80174e:	83 c4 18             	add    $0x18,%esp
	return;
  801751:	90                   	nop
}
  801752:	c9                   	leave  
  801753:	c3                   	ret    

00801754 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801754:	55                   	push   %ebp
  801755:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801757:	6a 00                	push   $0x0
  801759:	6a 00                	push   $0x0
  80175b:	6a 00                	push   $0x0
  80175d:	6a 00                	push   $0x0
  80175f:	6a 00                	push   $0x0
  801761:	6a 2b                	push   $0x2b
  801763:	e8 b0 fa ff ff       	call   801218 <syscall>
  801768:	83 c4 18             	add    $0x18,%esp
}
  80176b:	c9                   	leave  
  80176c:	c3                   	ret    

0080176d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80176d:	55                   	push   %ebp
  80176e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801770:	6a 00                	push   $0x0
  801772:	6a 00                	push   $0x0
  801774:	6a 00                	push   $0x0
  801776:	ff 75 0c             	pushl  0xc(%ebp)
  801779:	ff 75 08             	pushl  0x8(%ebp)
  80177c:	6a 2d                	push   $0x2d
  80177e:	e8 95 fa ff ff       	call   801218 <syscall>
  801783:	83 c4 18             	add    $0x18,%esp
	return;
  801786:	90                   	nop
}
  801787:	c9                   	leave  
  801788:	c3                   	ret    

00801789 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801789:	55                   	push   %ebp
  80178a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80178c:	6a 00                	push   $0x0
  80178e:	6a 00                	push   $0x0
  801790:	6a 00                	push   $0x0
  801792:	ff 75 0c             	pushl  0xc(%ebp)
  801795:	ff 75 08             	pushl  0x8(%ebp)
  801798:	6a 2c                	push   $0x2c
  80179a:	e8 79 fa ff ff       	call   801218 <syscall>
  80179f:	83 c4 18             	add    $0x18,%esp
	return ;
  8017a2:	90                   	nop
}
  8017a3:	c9                   	leave  
  8017a4:	c3                   	ret    

008017a5 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8017a5:	55                   	push   %ebp
  8017a6:	89 e5                	mov    %esp,%ebp
  8017a8:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  8017ab:	83 ec 04             	sub    $0x4,%esp
  8017ae:	68 08 22 80 00       	push   $0x802208
  8017b3:	68 25 01 00 00       	push   $0x125
  8017b8:	68 3b 22 80 00       	push   $0x80223b
  8017bd:	e8 be 00 00 00       	call   801880 <_panic>

008017c2 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8017c2:	55                   	push   %ebp
  8017c3:	89 e5                	mov    %esp,%ebp
  8017c5:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8017c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8017cb:	89 d0                	mov    %edx,%eax
  8017cd:	c1 e0 02             	shl    $0x2,%eax
  8017d0:	01 d0                	add    %edx,%eax
  8017d2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017d9:	01 d0                	add    %edx,%eax
  8017db:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017e2:	01 d0                	add    %edx,%eax
  8017e4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017eb:	01 d0                	add    %edx,%eax
  8017ed:	c1 e0 04             	shl    $0x4,%eax
  8017f0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  8017f3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  8017fa:	0f 31                	rdtsc  
  8017fc:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8017ff:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  801802:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801805:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801808:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80180b:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  80180e:	eb 46                	jmp    801856 <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  801810:	0f 31                	rdtsc  
  801812:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801815:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  801818:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80181b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80181e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801821:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801824:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801827:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80182a:	29 c2                	sub    %eax,%edx
  80182c:	89 d0                	mov    %edx,%eax
  80182e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801831:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801834:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801837:	89 d1                	mov    %edx,%ecx
  801839:	29 c1                	sub    %eax,%ecx
  80183b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80183e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801841:	39 c2                	cmp    %eax,%edx
  801843:	0f 97 c0             	seta   %al
  801846:	0f b6 c0             	movzbl %al,%eax
  801849:	29 c1                	sub    %eax,%ecx
  80184b:	89 c8                	mov    %ecx,%eax
  80184d:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801850:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801853:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801856:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801859:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80185c:	72 b2                	jb     801810 <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  80185e:	90                   	nop
  80185f:	c9                   	leave  
  801860:	c3                   	ret    

00801861 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801861:	55                   	push   %ebp
  801862:	89 e5                	mov    %esp,%ebp
  801864:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801867:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  80186e:	eb 03                	jmp    801873 <busy_wait+0x12>
  801870:	ff 45 fc             	incl   -0x4(%ebp)
  801873:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801876:	3b 45 08             	cmp    0x8(%ebp),%eax
  801879:	72 f5                	jb     801870 <busy_wait+0xf>
	return i;
  80187b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80187e:	c9                   	leave  
  80187f:	c3                   	ret    

00801880 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801880:	55                   	push   %ebp
  801881:	89 e5                	mov    %esp,%ebp
  801883:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801886:	8d 45 10             	lea    0x10(%ebp),%eax
  801889:	83 c0 04             	add    $0x4,%eax
  80188c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80188f:	a1 1c b1 81 00       	mov    0x81b11c,%eax
  801894:	85 c0                	test   %eax,%eax
  801896:	74 16                	je     8018ae <_panic+0x2e>
		cprintf("%s: ", argv0);
  801898:	a1 1c b1 81 00       	mov    0x81b11c,%eax
  80189d:	83 ec 08             	sub    $0x8,%esp
  8018a0:	50                   	push   %eax
  8018a1:	68 4c 22 80 00       	push   $0x80224c
  8018a6:	e8 88 ea ff ff       	call   800333 <cprintf>
  8018ab:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8018ae:	a1 04 30 80 00       	mov    0x803004,%eax
  8018b3:	83 ec 0c             	sub    $0xc,%esp
  8018b6:	ff 75 0c             	pushl  0xc(%ebp)
  8018b9:	ff 75 08             	pushl  0x8(%ebp)
  8018bc:	50                   	push   %eax
  8018bd:	68 54 22 80 00       	push   $0x802254
  8018c2:	6a 74                	push   $0x74
  8018c4:	e8 97 ea ff ff       	call   800360 <cprintf_colored>
  8018c9:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8018cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8018cf:	83 ec 08             	sub    $0x8,%esp
  8018d2:	ff 75 f4             	pushl  -0xc(%ebp)
  8018d5:	50                   	push   %eax
  8018d6:	e8 e9 e9 ff ff       	call   8002c4 <vcprintf>
  8018db:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8018de:	83 ec 08             	sub    $0x8,%esp
  8018e1:	6a 00                	push   $0x0
  8018e3:	68 7c 22 80 00       	push   $0x80227c
  8018e8:	e8 d7 e9 ff ff       	call   8002c4 <vcprintf>
  8018ed:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8018f0:	e8 50 e9 ff ff       	call   800245 <exit>

	// should not return here
	while (1) ;
  8018f5:	eb fe                	jmp    8018f5 <_panic+0x75>

008018f7 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8018f7:	55                   	push   %ebp
  8018f8:	89 e5                	mov    %esp,%ebp
  8018fa:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8018fd:	a1 20 30 80 00       	mov    0x803020,%eax
  801902:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801908:	8b 45 0c             	mov    0xc(%ebp),%eax
  80190b:	39 c2                	cmp    %eax,%edx
  80190d:	74 14                	je     801923 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80190f:	83 ec 04             	sub    $0x4,%esp
  801912:	68 80 22 80 00       	push   $0x802280
  801917:	6a 26                	push   $0x26
  801919:	68 cc 22 80 00       	push   $0x8022cc
  80191e:	e8 5d ff ff ff       	call   801880 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801923:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80192a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801931:	e9 c5 00 00 00       	jmp    8019fb <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801936:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801939:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801940:	8b 45 08             	mov    0x8(%ebp),%eax
  801943:	01 d0                	add    %edx,%eax
  801945:	8b 00                	mov    (%eax),%eax
  801947:	85 c0                	test   %eax,%eax
  801949:	75 08                	jne    801953 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80194b:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80194e:	e9 a5 00 00 00       	jmp    8019f8 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801953:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80195a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801961:	eb 69                	jmp    8019cc <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801963:	a1 20 30 80 00       	mov    0x803020,%eax
  801968:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80196e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801971:	89 d0                	mov    %edx,%eax
  801973:	01 c0                	add    %eax,%eax
  801975:	01 d0                	add    %edx,%eax
  801977:	c1 e0 03             	shl    $0x3,%eax
  80197a:	01 c8                	add    %ecx,%eax
  80197c:	8a 40 04             	mov    0x4(%eax),%al
  80197f:	84 c0                	test   %al,%al
  801981:	75 46                	jne    8019c9 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801983:	a1 20 30 80 00       	mov    0x803020,%eax
  801988:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80198e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801991:	89 d0                	mov    %edx,%eax
  801993:	01 c0                	add    %eax,%eax
  801995:	01 d0                	add    %edx,%eax
  801997:	c1 e0 03             	shl    $0x3,%eax
  80199a:	01 c8                	add    %ecx,%eax
  80199c:	8b 00                	mov    (%eax),%eax
  80199e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8019a1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8019a4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8019a9:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8019ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019ae:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8019b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b8:	01 c8                	add    %ecx,%eax
  8019ba:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8019bc:	39 c2                	cmp    %eax,%edx
  8019be:	75 09                	jne    8019c9 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8019c0:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8019c7:	eb 15                	jmp    8019de <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8019c9:	ff 45 e8             	incl   -0x18(%ebp)
  8019cc:	a1 20 30 80 00       	mov    0x803020,%eax
  8019d1:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8019d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8019da:	39 c2                	cmp    %eax,%edx
  8019dc:	77 85                	ja     801963 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8019de:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8019e2:	75 14                	jne    8019f8 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8019e4:	83 ec 04             	sub    $0x4,%esp
  8019e7:	68 d8 22 80 00       	push   $0x8022d8
  8019ec:	6a 3a                	push   $0x3a
  8019ee:	68 cc 22 80 00       	push   $0x8022cc
  8019f3:	e8 88 fe ff ff       	call   801880 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8019f8:	ff 45 f0             	incl   -0x10(%ebp)
  8019fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019fe:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801a01:	0f 8c 2f ff ff ff    	jl     801936 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801a07:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801a0e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801a15:	eb 26                	jmp    801a3d <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801a17:	a1 20 30 80 00       	mov    0x803020,%eax
  801a1c:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  801a22:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a25:	89 d0                	mov    %edx,%eax
  801a27:	01 c0                	add    %eax,%eax
  801a29:	01 d0                	add    %edx,%eax
  801a2b:	c1 e0 03             	shl    $0x3,%eax
  801a2e:	01 c8                	add    %ecx,%eax
  801a30:	8a 40 04             	mov    0x4(%eax),%al
  801a33:	3c 01                	cmp    $0x1,%al
  801a35:	75 03                	jne    801a3a <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801a37:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801a3a:	ff 45 e0             	incl   -0x20(%ebp)
  801a3d:	a1 20 30 80 00       	mov    0x803020,%eax
  801a42:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801a48:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a4b:	39 c2                	cmp    %eax,%edx
  801a4d:	77 c8                	ja     801a17 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801a4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a52:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801a55:	74 14                	je     801a6b <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801a57:	83 ec 04             	sub    $0x4,%esp
  801a5a:	68 2c 23 80 00       	push   $0x80232c
  801a5f:	6a 44                	push   $0x44
  801a61:	68 cc 22 80 00       	push   $0x8022cc
  801a66:	e8 15 fe ff ff       	call   801880 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801a6b:	90                   	nop
  801a6c:	c9                   	leave  
  801a6d:	c3                   	ret    
  801a6e:	66 90                	xchg   %ax,%ax

00801a70 <__udivdi3>:
  801a70:	55                   	push   %ebp
  801a71:	57                   	push   %edi
  801a72:	56                   	push   %esi
  801a73:	53                   	push   %ebx
  801a74:	83 ec 1c             	sub    $0x1c,%esp
  801a77:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801a7b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801a7f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a83:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a87:	89 ca                	mov    %ecx,%edx
  801a89:	89 f8                	mov    %edi,%eax
  801a8b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801a8f:	85 f6                	test   %esi,%esi
  801a91:	75 2d                	jne    801ac0 <__udivdi3+0x50>
  801a93:	39 cf                	cmp    %ecx,%edi
  801a95:	77 65                	ja     801afc <__udivdi3+0x8c>
  801a97:	89 fd                	mov    %edi,%ebp
  801a99:	85 ff                	test   %edi,%edi
  801a9b:	75 0b                	jne    801aa8 <__udivdi3+0x38>
  801a9d:	b8 01 00 00 00       	mov    $0x1,%eax
  801aa2:	31 d2                	xor    %edx,%edx
  801aa4:	f7 f7                	div    %edi
  801aa6:	89 c5                	mov    %eax,%ebp
  801aa8:	31 d2                	xor    %edx,%edx
  801aaa:	89 c8                	mov    %ecx,%eax
  801aac:	f7 f5                	div    %ebp
  801aae:	89 c1                	mov    %eax,%ecx
  801ab0:	89 d8                	mov    %ebx,%eax
  801ab2:	f7 f5                	div    %ebp
  801ab4:	89 cf                	mov    %ecx,%edi
  801ab6:	89 fa                	mov    %edi,%edx
  801ab8:	83 c4 1c             	add    $0x1c,%esp
  801abb:	5b                   	pop    %ebx
  801abc:	5e                   	pop    %esi
  801abd:	5f                   	pop    %edi
  801abe:	5d                   	pop    %ebp
  801abf:	c3                   	ret    
  801ac0:	39 ce                	cmp    %ecx,%esi
  801ac2:	77 28                	ja     801aec <__udivdi3+0x7c>
  801ac4:	0f bd fe             	bsr    %esi,%edi
  801ac7:	83 f7 1f             	xor    $0x1f,%edi
  801aca:	75 40                	jne    801b0c <__udivdi3+0x9c>
  801acc:	39 ce                	cmp    %ecx,%esi
  801ace:	72 0a                	jb     801ada <__udivdi3+0x6a>
  801ad0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801ad4:	0f 87 9e 00 00 00    	ja     801b78 <__udivdi3+0x108>
  801ada:	b8 01 00 00 00       	mov    $0x1,%eax
  801adf:	89 fa                	mov    %edi,%edx
  801ae1:	83 c4 1c             	add    $0x1c,%esp
  801ae4:	5b                   	pop    %ebx
  801ae5:	5e                   	pop    %esi
  801ae6:	5f                   	pop    %edi
  801ae7:	5d                   	pop    %ebp
  801ae8:	c3                   	ret    
  801ae9:	8d 76 00             	lea    0x0(%esi),%esi
  801aec:	31 ff                	xor    %edi,%edi
  801aee:	31 c0                	xor    %eax,%eax
  801af0:	89 fa                	mov    %edi,%edx
  801af2:	83 c4 1c             	add    $0x1c,%esp
  801af5:	5b                   	pop    %ebx
  801af6:	5e                   	pop    %esi
  801af7:	5f                   	pop    %edi
  801af8:	5d                   	pop    %ebp
  801af9:	c3                   	ret    
  801afa:	66 90                	xchg   %ax,%ax
  801afc:	89 d8                	mov    %ebx,%eax
  801afe:	f7 f7                	div    %edi
  801b00:	31 ff                	xor    %edi,%edi
  801b02:	89 fa                	mov    %edi,%edx
  801b04:	83 c4 1c             	add    $0x1c,%esp
  801b07:	5b                   	pop    %ebx
  801b08:	5e                   	pop    %esi
  801b09:	5f                   	pop    %edi
  801b0a:	5d                   	pop    %ebp
  801b0b:	c3                   	ret    
  801b0c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801b11:	89 eb                	mov    %ebp,%ebx
  801b13:	29 fb                	sub    %edi,%ebx
  801b15:	89 f9                	mov    %edi,%ecx
  801b17:	d3 e6                	shl    %cl,%esi
  801b19:	89 c5                	mov    %eax,%ebp
  801b1b:	88 d9                	mov    %bl,%cl
  801b1d:	d3 ed                	shr    %cl,%ebp
  801b1f:	89 e9                	mov    %ebp,%ecx
  801b21:	09 f1                	or     %esi,%ecx
  801b23:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801b27:	89 f9                	mov    %edi,%ecx
  801b29:	d3 e0                	shl    %cl,%eax
  801b2b:	89 c5                	mov    %eax,%ebp
  801b2d:	89 d6                	mov    %edx,%esi
  801b2f:	88 d9                	mov    %bl,%cl
  801b31:	d3 ee                	shr    %cl,%esi
  801b33:	89 f9                	mov    %edi,%ecx
  801b35:	d3 e2                	shl    %cl,%edx
  801b37:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b3b:	88 d9                	mov    %bl,%cl
  801b3d:	d3 e8                	shr    %cl,%eax
  801b3f:	09 c2                	or     %eax,%edx
  801b41:	89 d0                	mov    %edx,%eax
  801b43:	89 f2                	mov    %esi,%edx
  801b45:	f7 74 24 0c          	divl   0xc(%esp)
  801b49:	89 d6                	mov    %edx,%esi
  801b4b:	89 c3                	mov    %eax,%ebx
  801b4d:	f7 e5                	mul    %ebp
  801b4f:	39 d6                	cmp    %edx,%esi
  801b51:	72 19                	jb     801b6c <__udivdi3+0xfc>
  801b53:	74 0b                	je     801b60 <__udivdi3+0xf0>
  801b55:	89 d8                	mov    %ebx,%eax
  801b57:	31 ff                	xor    %edi,%edi
  801b59:	e9 58 ff ff ff       	jmp    801ab6 <__udivdi3+0x46>
  801b5e:	66 90                	xchg   %ax,%ax
  801b60:	8b 54 24 08          	mov    0x8(%esp),%edx
  801b64:	89 f9                	mov    %edi,%ecx
  801b66:	d3 e2                	shl    %cl,%edx
  801b68:	39 c2                	cmp    %eax,%edx
  801b6a:	73 e9                	jae    801b55 <__udivdi3+0xe5>
  801b6c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801b6f:	31 ff                	xor    %edi,%edi
  801b71:	e9 40 ff ff ff       	jmp    801ab6 <__udivdi3+0x46>
  801b76:	66 90                	xchg   %ax,%ax
  801b78:	31 c0                	xor    %eax,%eax
  801b7a:	e9 37 ff ff ff       	jmp    801ab6 <__udivdi3+0x46>
  801b7f:	90                   	nop

00801b80 <__umoddi3>:
  801b80:	55                   	push   %ebp
  801b81:	57                   	push   %edi
  801b82:	56                   	push   %esi
  801b83:	53                   	push   %ebx
  801b84:	83 ec 1c             	sub    $0x1c,%esp
  801b87:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801b8b:	8b 74 24 34          	mov    0x34(%esp),%esi
  801b8f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b93:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801b97:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b9b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b9f:	89 f3                	mov    %esi,%ebx
  801ba1:	89 fa                	mov    %edi,%edx
  801ba3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ba7:	89 34 24             	mov    %esi,(%esp)
  801baa:	85 c0                	test   %eax,%eax
  801bac:	75 1a                	jne    801bc8 <__umoddi3+0x48>
  801bae:	39 f7                	cmp    %esi,%edi
  801bb0:	0f 86 a2 00 00 00    	jbe    801c58 <__umoddi3+0xd8>
  801bb6:	89 c8                	mov    %ecx,%eax
  801bb8:	89 f2                	mov    %esi,%edx
  801bba:	f7 f7                	div    %edi
  801bbc:	89 d0                	mov    %edx,%eax
  801bbe:	31 d2                	xor    %edx,%edx
  801bc0:	83 c4 1c             	add    $0x1c,%esp
  801bc3:	5b                   	pop    %ebx
  801bc4:	5e                   	pop    %esi
  801bc5:	5f                   	pop    %edi
  801bc6:	5d                   	pop    %ebp
  801bc7:	c3                   	ret    
  801bc8:	39 f0                	cmp    %esi,%eax
  801bca:	0f 87 ac 00 00 00    	ja     801c7c <__umoddi3+0xfc>
  801bd0:	0f bd e8             	bsr    %eax,%ebp
  801bd3:	83 f5 1f             	xor    $0x1f,%ebp
  801bd6:	0f 84 ac 00 00 00    	je     801c88 <__umoddi3+0x108>
  801bdc:	bf 20 00 00 00       	mov    $0x20,%edi
  801be1:	29 ef                	sub    %ebp,%edi
  801be3:	89 fe                	mov    %edi,%esi
  801be5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801be9:	89 e9                	mov    %ebp,%ecx
  801beb:	d3 e0                	shl    %cl,%eax
  801bed:	89 d7                	mov    %edx,%edi
  801bef:	89 f1                	mov    %esi,%ecx
  801bf1:	d3 ef                	shr    %cl,%edi
  801bf3:	09 c7                	or     %eax,%edi
  801bf5:	89 e9                	mov    %ebp,%ecx
  801bf7:	d3 e2                	shl    %cl,%edx
  801bf9:	89 14 24             	mov    %edx,(%esp)
  801bfc:	89 d8                	mov    %ebx,%eax
  801bfe:	d3 e0                	shl    %cl,%eax
  801c00:	89 c2                	mov    %eax,%edx
  801c02:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c06:	d3 e0                	shl    %cl,%eax
  801c08:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c0c:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c10:	89 f1                	mov    %esi,%ecx
  801c12:	d3 e8                	shr    %cl,%eax
  801c14:	09 d0                	or     %edx,%eax
  801c16:	d3 eb                	shr    %cl,%ebx
  801c18:	89 da                	mov    %ebx,%edx
  801c1a:	f7 f7                	div    %edi
  801c1c:	89 d3                	mov    %edx,%ebx
  801c1e:	f7 24 24             	mull   (%esp)
  801c21:	89 c6                	mov    %eax,%esi
  801c23:	89 d1                	mov    %edx,%ecx
  801c25:	39 d3                	cmp    %edx,%ebx
  801c27:	0f 82 87 00 00 00    	jb     801cb4 <__umoddi3+0x134>
  801c2d:	0f 84 91 00 00 00    	je     801cc4 <__umoddi3+0x144>
  801c33:	8b 54 24 04          	mov    0x4(%esp),%edx
  801c37:	29 f2                	sub    %esi,%edx
  801c39:	19 cb                	sbb    %ecx,%ebx
  801c3b:	89 d8                	mov    %ebx,%eax
  801c3d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801c41:	d3 e0                	shl    %cl,%eax
  801c43:	89 e9                	mov    %ebp,%ecx
  801c45:	d3 ea                	shr    %cl,%edx
  801c47:	09 d0                	or     %edx,%eax
  801c49:	89 e9                	mov    %ebp,%ecx
  801c4b:	d3 eb                	shr    %cl,%ebx
  801c4d:	89 da                	mov    %ebx,%edx
  801c4f:	83 c4 1c             	add    $0x1c,%esp
  801c52:	5b                   	pop    %ebx
  801c53:	5e                   	pop    %esi
  801c54:	5f                   	pop    %edi
  801c55:	5d                   	pop    %ebp
  801c56:	c3                   	ret    
  801c57:	90                   	nop
  801c58:	89 fd                	mov    %edi,%ebp
  801c5a:	85 ff                	test   %edi,%edi
  801c5c:	75 0b                	jne    801c69 <__umoddi3+0xe9>
  801c5e:	b8 01 00 00 00       	mov    $0x1,%eax
  801c63:	31 d2                	xor    %edx,%edx
  801c65:	f7 f7                	div    %edi
  801c67:	89 c5                	mov    %eax,%ebp
  801c69:	89 f0                	mov    %esi,%eax
  801c6b:	31 d2                	xor    %edx,%edx
  801c6d:	f7 f5                	div    %ebp
  801c6f:	89 c8                	mov    %ecx,%eax
  801c71:	f7 f5                	div    %ebp
  801c73:	89 d0                	mov    %edx,%eax
  801c75:	e9 44 ff ff ff       	jmp    801bbe <__umoddi3+0x3e>
  801c7a:	66 90                	xchg   %ax,%ax
  801c7c:	89 c8                	mov    %ecx,%eax
  801c7e:	89 f2                	mov    %esi,%edx
  801c80:	83 c4 1c             	add    $0x1c,%esp
  801c83:	5b                   	pop    %ebx
  801c84:	5e                   	pop    %esi
  801c85:	5f                   	pop    %edi
  801c86:	5d                   	pop    %ebp
  801c87:	c3                   	ret    
  801c88:	3b 04 24             	cmp    (%esp),%eax
  801c8b:	72 06                	jb     801c93 <__umoddi3+0x113>
  801c8d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801c91:	77 0f                	ja     801ca2 <__umoddi3+0x122>
  801c93:	89 f2                	mov    %esi,%edx
  801c95:	29 f9                	sub    %edi,%ecx
  801c97:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801c9b:	89 14 24             	mov    %edx,(%esp)
  801c9e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ca2:	8b 44 24 04          	mov    0x4(%esp),%eax
  801ca6:	8b 14 24             	mov    (%esp),%edx
  801ca9:	83 c4 1c             	add    $0x1c,%esp
  801cac:	5b                   	pop    %ebx
  801cad:	5e                   	pop    %esi
  801cae:	5f                   	pop    %edi
  801caf:	5d                   	pop    %ebp
  801cb0:	c3                   	ret    
  801cb1:	8d 76 00             	lea    0x0(%esi),%esi
  801cb4:	2b 04 24             	sub    (%esp),%eax
  801cb7:	19 fa                	sbb    %edi,%edx
  801cb9:	89 d1                	mov    %edx,%ecx
  801cbb:	89 c6                	mov    %eax,%esi
  801cbd:	e9 71 ff ff ff       	jmp    801c33 <__umoddi3+0xb3>
  801cc2:	66 90                	xchg   %ax,%ax
  801cc4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801cc8:	72 ea                	jb     801cb4 <__umoddi3+0x134>
  801cca:	89 d9                	mov    %ebx,%ecx
  801ccc:	e9 62 ff ff ff       	jmp    801c33 <__umoddi3+0xb3>

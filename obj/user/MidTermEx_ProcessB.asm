
obj/user/MidTermEx_ProcessB:     file format elf32-i386


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
  800031:	e8 5d 02 00 00       	call   800293 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>
extern volatile bool printStats;

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 58             	sub    $0x58,%esp
	printStats = 0;
  80003e:	c7 05 00 30 80 00 00 	movl   $0x0,0x803000
  800045:	00 00 00 

	int32 parentenvID = sys_getparentenvid();
  800048:	e8 73 18 00 00       	call   8018c0 <sys_getparentenvid>
  80004d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int delay;

	/*[1] GET SHARED VARIABLE, SEMAPHORE SEL, check-finishing counter*/
	int *X = sget(parentenvID, "X") ;
  800050:	83 ec 08             	sub    $0x8,%esp
  800053:	68 40 23 80 00       	push   $0x802340
  800058:	ff 75 ec             	pushl  -0x14(%ebp)
  80005b:	e8 01 15 00 00       	call   801561 <sget>
  800060:	83 c4 10             	add    $0x10,%esp
  800063:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int *protType = sget(parentenvID, "protType") ;
  800066:	83 ec 08             	sub    $0x8,%esp
  800069:	68 42 23 80 00       	push   $0x802342
  80006e:	ff 75 ec             	pushl  -0x14(%ebp)
  800071:	e8 eb 14 00 00       	call   801561 <sget>
  800076:	83 c4 10             	add    $0x10,%esp
  800079:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int * finishedCount = sget(parentenvID, "finishedCount") ;
  80007c:	83 ec 08             	sub    $0x8,%esp
  80007f:	68 4b 23 80 00       	push   $0x80234b
  800084:	ff 75 ec             	pushl  -0x14(%ebp)
  800087:	e8 d5 14 00 00       	call   801561 <sget>
  80008c:	83 c4 10             	add    $0x10,%esp
  80008f:	89 45 e0             	mov    %eax,-0x20(%ebp)
	struct semaphore T, finished, finishedCountMutex ;
	struct uspinlock *sT, *sfinishedCountMutex;

	if (*protType == 1)
  800092:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800095:	8b 00                	mov    (%eax),%eax
  800097:	83 f8 01             	cmp    $0x1,%eax
  80009a:	75 47                	jne    8000e3 <_main+0xab>
	{
		T = get_semaphore(parentenvID, "T");
  80009c:	8d 45 bc             	lea    -0x44(%ebp),%eax
  80009f:	83 ec 04             	sub    $0x4,%esp
  8000a2:	68 59 23 80 00       	push   $0x802359
  8000a7:	ff 75 ec             	pushl  -0x14(%ebp)
  8000aa:	50                   	push   %eax
  8000ab:	e8 1b 1c 00 00       	call   801ccb <get_semaphore>
  8000b0:	83 c4 0c             	add    $0xc,%esp
		finished = get_semaphore(parentenvID, "finished");
  8000b3:	8d 45 b8             	lea    -0x48(%ebp),%eax
  8000b6:	83 ec 04             	sub    $0x4,%esp
  8000b9:	68 5b 23 80 00       	push   $0x80235b
  8000be:	ff 75 ec             	pushl  -0x14(%ebp)
  8000c1:	50                   	push   %eax
  8000c2:	e8 04 1c 00 00       	call   801ccb <get_semaphore>
  8000c7:	83 c4 0c             	add    $0xc,%esp
		finishedCountMutex = get_semaphore(parentenvID, "finishedCountMutex");
  8000ca:	8d 45 b4             	lea    -0x4c(%ebp),%eax
  8000cd:	83 ec 04             	sub    $0x4,%esp
  8000d0:	68 64 23 80 00       	push   $0x802364
  8000d5:	ff 75 ec             	pushl  -0x14(%ebp)
  8000d8:	50                   	push   %eax
  8000d9:	e8 ed 1b 00 00       	call   801ccb <get_semaphore>
  8000de:	83 c4 0c             	add    $0xc,%esp
  8000e1:	eb 36                	jmp    800119 <_main+0xe1>
	}
	else if (*protType == 2)
  8000e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000e6:	8b 00                	mov    (%eax),%eax
  8000e8:	83 f8 02             	cmp    $0x2,%eax
  8000eb:	75 2c                	jne    800119 <_main+0xe1>
	{
		sT = sget(parentenvID, "T");
  8000ed:	83 ec 08             	sub    $0x8,%esp
  8000f0:	68 59 23 80 00       	push   $0x802359
  8000f5:	ff 75 ec             	pushl  -0x14(%ebp)
  8000f8:	e8 64 14 00 00       	call   801561 <sget>
  8000fd:	83 c4 10             	add    $0x10,%esp
  800100:	89 45 f4             	mov    %eax,-0xc(%ebp)
		sfinishedCountMutex = sget(parentenvID, "finishedCountMutex");
  800103:	83 ec 08             	sub    $0x8,%esp
  800106:	68 64 23 80 00       	push   $0x802364
  80010b:	ff 75 ec             	pushl  -0x14(%ebp)
  80010e:	e8 4e 14 00 00       	call   801561 <sget>
  800113:	83 c4 10             	add    $0x10,%esp
  800116:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	/*[2] DO THE JOB*/
	int Z ;
	if (*protType == 1)
  800119:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80011c:	8b 00                	mov    (%eax),%eax
  80011e:	83 f8 01             	cmp    $0x1,%eax
  800121:	75 10                	jne    800133 <_main+0xfb>
	{
		wait_semaphore(T);
  800123:	83 ec 0c             	sub    $0xc,%esp
  800126:	ff 75 bc             	pushl  -0x44(%ebp)
  800129:	e8 b7 1b 00 00       	call   801ce5 <wait_semaphore>
  80012e:	83 c4 10             	add    $0x10,%esp
  800131:	eb 18                	jmp    80014b <_main+0x113>
	}
	else if (*protType == 2)
  800133:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800136:	8b 00                	mov    (%eax),%eax
  800138:	83 f8 02             	cmp    $0x2,%eax
  80013b:	75 0e                	jne    80014b <_main+0x113>
	{
		acquire_uspinlock(sT);
  80013d:	83 ec 0c             	sub    $0xc,%esp
  800140:	ff 75 f4             	pushl  -0xc(%ebp)
  800143:	e8 e9 1c 00 00       	call   801e31 <acquire_uspinlock>
  800148:	83 c4 10             	add    $0x10,%esp
	}

	//random delay
	delay = RAND(2000, 10000);
  80014b:	8d 45 c0             	lea    -0x40(%ebp),%eax
  80014e:	83 ec 0c             	sub    $0xc,%esp
  800151:	50                   	push   %eax
  800152:	e8 9c 17 00 00       	call   8018f3 <sys_get_virtual_time>
  800157:	83 c4 0c             	add    $0xc,%esp
  80015a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80015d:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  800162:	ba 00 00 00 00       	mov    $0x0,%edx
  800167:	f7 f1                	div    %ecx
  800169:	89 d0                	mov    %edx,%eax
  80016b:	05 d0 07 00 00       	add    $0x7d0,%eax
  800170:	89 45 dc             	mov    %eax,-0x24(%ebp)
	env_sleep(delay);
  800173:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800176:	83 ec 0c             	sub    $0xc,%esp
  800179:	50                   	push   %eax
  80017a:	e8 a5 1b 00 00       	call   801d24 <env_sleep>
  80017f:	83 c4 10             	add    $0x10,%esp
	//	cprintf("delay = %d\n", delay);

	Z = (*X) + 1 ;
  800182:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800185:	8b 00                	mov    (%eax),%eax
  800187:	40                   	inc    %eax
  800188:	89 45 d8             	mov    %eax,-0x28(%ebp)

	//random delay
	delay = RAND(2000, 10000);
  80018b:	8d 45 c8             	lea    -0x38(%ebp),%eax
  80018e:	83 ec 0c             	sub    $0xc,%esp
  800191:	50                   	push   %eax
  800192:	e8 5c 17 00 00       	call   8018f3 <sys_get_virtual_time>
  800197:	83 c4 0c             	add    $0xc,%esp
  80019a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80019d:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  8001a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8001a7:	f7 f1                	div    %ecx
  8001a9:	89 d0                	mov    %edx,%eax
  8001ab:	05 d0 07 00 00       	add    $0x7d0,%eax
  8001b0:	89 45 dc             	mov    %eax,-0x24(%ebp)
	env_sleep(delay);
  8001b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001b6:	83 ec 0c             	sub    $0xc,%esp
  8001b9:	50                   	push   %eax
  8001ba:	e8 65 1b 00 00       	call   801d24 <env_sleep>
  8001bf:	83 c4 10             	add    $0x10,%esp
	//	cprintf("delay = %d\n", delay);

	(*X) = Z ;
  8001c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001c5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8001c8:	89 10                	mov    %edx,(%eax)

	//random delay
	delay = RAND(2000, 10000);
  8001ca:	8d 45 d0             	lea    -0x30(%ebp),%eax
  8001cd:	83 ec 0c             	sub    $0xc,%esp
  8001d0:	50                   	push   %eax
  8001d1:	e8 1d 17 00 00       	call   8018f3 <sys_get_virtual_time>
  8001d6:	83 c4 0c             	add    $0xc,%esp
  8001d9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8001dc:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  8001e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8001e6:	f7 f1                	div    %ecx
  8001e8:	89 d0                	mov    %edx,%eax
  8001ea:	05 d0 07 00 00       	add    $0x7d0,%eax
  8001ef:	89 45 dc             	mov    %eax,-0x24(%ebp)
	env_sleep(delay);
  8001f2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001f5:	83 ec 0c             	sub    $0xc,%esp
  8001f8:	50                   	push   %eax
  8001f9:	e8 26 1b 00 00       	call   801d24 <env_sleep>
  8001fe:	83 c4 10             	add    $0x10,%esp
	//	cprintf("delay = %d\n", delay);

	/*[3] DECLARE FINISHING*/
	if (*protType == 1)
  800201:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800204:	8b 00                	mov    (%eax),%eax
  800206:	83 f8 01             	cmp    $0x1,%eax
  800209:	75 39                	jne    800244 <_main+0x20c>
	{
		signal_semaphore(finished);
  80020b:	83 ec 0c             	sub    $0xc,%esp
  80020e:	ff 75 b8             	pushl  -0x48(%ebp)
  800211:	e8 e9 1a 00 00       	call   801cff <signal_semaphore>
  800216:	83 c4 10             	add    $0x10,%esp

		wait_semaphore(finishedCountMutex);
  800219:	83 ec 0c             	sub    $0xc,%esp
  80021c:	ff 75 b4             	pushl  -0x4c(%ebp)
  80021f:	e8 c1 1a 00 00       	call   801ce5 <wait_semaphore>
  800224:	83 c4 10             	add    $0x10,%esp
		{
			(*finishedCount)++ ;
  800227:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80022a:	8b 00                	mov    (%eax),%eax
  80022c:	8d 50 01             	lea    0x1(%eax),%edx
  80022f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800232:	89 10                	mov    %edx,(%eax)
		}
		signal_semaphore(finishedCountMutex);
  800234:	83 ec 0c             	sub    $0xc,%esp
  800237:	ff 75 b4             	pushl  -0x4c(%ebp)
  80023a:	e8 c0 1a 00 00       	call   801cff <signal_semaphore>
  80023f:	83 c4 10             	add    $0x10,%esp
		{
			(*finishedCount)++ ;
		}
		sys_unlock_cons();
	}
}
  800242:	eb 4c                	jmp    800290 <_main+0x258>
		{
			(*finishedCount)++ ;
		}
		signal_semaphore(finishedCountMutex);
	}
	else if (*protType == 2)
  800244:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800247:	8b 00                	mov    (%eax),%eax
  800249:	83 f8 02             	cmp    $0x2,%eax
  80024c:	75 2b                	jne    800279 <_main+0x241>
	{
		acquire_uspinlock(sfinishedCountMutex);
  80024e:	83 ec 0c             	sub    $0xc,%esp
  800251:	ff 75 f0             	pushl  -0x10(%ebp)
  800254:	e8 d8 1b 00 00       	call   801e31 <acquire_uspinlock>
  800259:	83 c4 10             	add    $0x10,%esp
		{
			(*finishedCount)++ ;
  80025c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80025f:	8b 00                	mov    (%eax),%eax
  800261:	8d 50 01             	lea    0x1(%eax),%edx
  800264:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800267:	89 10                	mov    %edx,(%eax)
		}
		release_uspinlock(sfinishedCountMutex);
  800269:	83 ec 0c             	sub    $0xc,%esp
  80026c:	ff 75 f0             	pushl  -0x10(%ebp)
  80026f:	e8 15 1c 00 00       	call   801e89 <release_uspinlock>
  800274:	83 c4 10             	add    $0x10,%esp
		{
			(*finishedCount)++ ;
		}
		sys_unlock_cons();
	}
}
  800277:	eb 17                	jmp    800290 <_main+0x258>
			(*finishedCount)++ ;
		}
		release_uspinlock(sfinishedCountMutex);
	}else
	{
		sys_lock_cons();
  800279:	e8 b0 13 00 00       	call   80162e <sys_lock_cons>
		{
			(*finishedCount)++ ;
  80027e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800281:	8b 00                	mov    (%eax),%eax
  800283:	8d 50 01             	lea    0x1(%eax),%edx
  800286:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800289:	89 10                	mov    %edx,(%eax)
		}
		sys_unlock_cons();
  80028b:	e8 b8 13 00 00       	call   801648 <sys_unlock_cons>
	}
}
  800290:	90                   	nop
  800291:	c9                   	leave  
  800292:	c3                   	ret    

00800293 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800293:	55                   	push   %ebp
  800294:	89 e5                	mov    %esp,%ebp
  800296:	57                   	push   %edi
  800297:	56                   	push   %esi
  800298:	53                   	push   %ebx
  800299:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80029c:	e8 06 16 00 00       	call   8018a7 <sys_getenvindex>
  8002a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8002a4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002a7:	89 d0                	mov    %edx,%eax
  8002a9:	c1 e0 02             	shl    $0x2,%eax
  8002ac:	01 d0                	add    %edx,%eax
  8002ae:	c1 e0 03             	shl    $0x3,%eax
  8002b1:	01 d0                	add    %edx,%eax
  8002b3:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8002ba:	01 d0                	add    %edx,%eax
  8002bc:	c1 e0 02             	shl    $0x2,%eax
  8002bf:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002c4:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8002c9:	a1 20 30 80 00       	mov    0x803020,%eax
  8002ce:	8a 40 20             	mov    0x20(%eax),%al
  8002d1:	84 c0                	test   %al,%al
  8002d3:	74 0d                	je     8002e2 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8002d5:	a1 20 30 80 00       	mov    0x803020,%eax
  8002da:	83 c0 20             	add    $0x20,%eax
  8002dd:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002e2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8002e6:	7e 0a                	jle    8002f2 <libmain+0x5f>
		binaryname = argv[0];
  8002e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002eb:	8b 00                	mov    (%eax),%eax
  8002ed:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  8002f2:	83 ec 08             	sub    $0x8,%esp
  8002f5:	ff 75 0c             	pushl  0xc(%ebp)
  8002f8:	ff 75 08             	pushl  0x8(%ebp)
  8002fb:	e8 38 fd ff ff       	call   800038 <_main>
  800300:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800303:	a1 00 30 80 00       	mov    0x803000,%eax
  800308:	85 c0                	test   %eax,%eax
  80030a:	0f 84 01 01 00 00    	je     800411 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800310:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800316:	bb 70 24 80 00       	mov    $0x802470,%ebx
  80031b:	ba 0e 00 00 00       	mov    $0xe,%edx
  800320:	89 c7                	mov    %eax,%edi
  800322:	89 de                	mov    %ebx,%esi
  800324:	89 d1                	mov    %edx,%ecx
  800326:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800328:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80032b:	b9 56 00 00 00       	mov    $0x56,%ecx
  800330:	b0 00                	mov    $0x0,%al
  800332:	89 d7                	mov    %edx,%edi
  800334:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800336:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80033d:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800340:	83 ec 08             	sub    $0x8,%esp
  800343:	50                   	push   %eax
  800344:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80034a:	50                   	push   %eax
  80034b:	e8 8d 17 00 00       	call   801add <sys_utilities>
  800350:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800353:	e8 d6 12 00 00       	call   80162e <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800358:	83 ec 0c             	sub    $0xc,%esp
  80035b:	68 90 23 80 00       	push   $0x802390
  800360:	e8 be 01 00 00       	call   800523 <cprintf>
  800365:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800368:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80036b:	85 c0                	test   %eax,%eax
  80036d:	74 18                	je     800387 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80036f:	e8 87 17 00 00       	call   801afb <sys_get_optimal_num_faults>
  800374:	83 ec 08             	sub    $0x8,%esp
  800377:	50                   	push   %eax
  800378:	68 b8 23 80 00       	push   $0x8023b8
  80037d:	e8 a1 01 00 00       	call   800523 <cprintf>
  800382:	83 c4 10             	add    $0x10,%esp
  800385:	eb 59                	jmp    8003e0 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800387:	a1 20 30 80 00       	mov    0x803020,%eax
  80038c:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  800392:	a1 20 30 80 00       	mov    0x803020,%eax
  800397:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  80039d:	83 ec 04             	sub    $0x4,%esp
  8003a0:	52                   	push   %edx
  8003a1:	50                   	push   %eax
  8003a2:	68 dc 23 80 00       	push   $0x8023dc
  8003a7:	e8 77 01 00 00       	call   800523 <cprintf>
  8003ac:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8003af:	a1 20 30 80 00       	mov    0x803020,%eax
  8003b4:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8003ba:	a1 20 30 80 00       	mov    0x803020,%eax
  8003bf:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  8003c5:	a1 20 30 80 00       	mov    0x803020,%eax
  8003ca:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  8003d0:	51                   	push   %ecx
  8003d1:	52                   	push   %edx
  8003d2:	50                   	push   %eax
  8003d3:	68 04 24 80 00       	push   $0x802404
  8003d8:	e8 46 01 00 00       	call   800523 <cprintf>
  8003dd:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8003e0:	a1 20 30 80 00       	mov    0x803020,%eax
  8003e5:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  8003eb:	83 ec 08             	sub    $0x8,%esp
  8003ee:	50                   	push   %eax
  8003ef:	68 5c 24 80 00       	push   $0x80245c
  8003f4:	e8 2a 01 00 00       	call   800523 <cprintf>
  8003f9:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8003fc:	83 ec 0c             	sub    $0xc,%esp
  8003ff:	68 90 23 80 00       	push   $0x802390
  800404:	e8 1a 01 00 00       	call   800523 <cprintf>
  800409:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80040c:	e8 37 12 00 00       	call   801648 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800411:	e8 1f 00 00 00       	call   800435 <exit>
}
  800416:	90                   	nop
  800417:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80041a:	5b                   	pop    %ebx
  80041b:	5e                   	pop    %esi
  80041c:	5f                   	pop    %edi
  80041d:	5d                   	pop    %ebp
  80041e:	c3                   	ret    

0080041f <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80041f:	55                   	push   %ebp
  800420:	89 e5                	mov    %esp,%ebp
  800422:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800425:	83 ec 0c             	sub    $0xc,%esp
  800428:	6a 00                	push   $0x0
  80042a:	e8 44 14 00 00       	call   801873 <sys_destroy_env>
  80042f:	83 c4 10             	add    $0x10,%esp
}
  800432:	90                   	nop
  800433:	c9                   	leave  
  800434:	c3                   	ret    

00800435 <exit>:

void
exit(void)
{
  800435:	55                   	push   %ebp
  800436:	89 e5                	mov    %esp,%ebp
  800438:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80043b:	e8 99 14 00 00       	call   8018d9 <sys_exit_env>
}
  800440:	90                   	nop
  800441:	c9                   	leave  
  800442:	c3                   	ret    

00800443 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800443:	55                   	push   %ebp
  800444:	89 e5                	mov    %esp,%ebp
  800446:	53                   	push   %ebx
  800447:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  80044a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80044d:	8b 00                	mov    (%eax),%eax
  80044f:	8d 48 01             	lea    0x1(%eax),%ecx
  800452:	8b 55 0c             	mov    0xc(%ebp),%edx
  800455:	89 0a                	mov    %ecx,(%edx)
  800457:	8b 55 08             	mov    0x8(%ebp),%edx
  80045a:	88 d1                	mov    %dl,%cl
  80045c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80045f:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800463:	8b 45 0c             	mov    0xc(%ebp),%eax
  800466:	8b 00                	mov    (%eax),%eax
  800468:	3d ff 00 00 00       	cmp    $0xff,%eax
  80046d:	75 30                	jne    80049f <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  80046f:	8b 15 18 b1 81 00    	mov    0x81b118,%edx
  800475:	a0 44 30 80 00       	mov    0x803044,%al
  80047a:	0f b6 c0             	movzbl %al,%eax
  80047d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800480:	8b 09                	mov    (%ecx),%ecx
  800482:	89 cb                	mov    %ecx,%ebx
  800484:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800487:	83 c1 08             	add    $0x8,%ecx
  80048a:	52                   	push   %edx
  80048b:	50                   	push   %eax
  80048c:	53                   	push   %ebx
  80048d:	51                   	push   %ecx
  80048e:	e8 57 11 00 00       	call   8015ea <sys_cputs>
  800493:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800496:	8b 45 0c             	mov    0xc(%ebp),%eax
  800499:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80049f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004a2:	8b 40 04             	mov    0x4(%eax),%eax
  8004a5:	8d 50 01             	lea    0x1(%eax),%edx
  8004a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ab:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004ae:	90                   	nop
  8004af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004b2:	c9                   	leave  
  8004b3:	c3                   	ret    

008004b4 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004b4:	55                   	push   %ebp
  8004b5:	89 e5                	mov    %esp,%ebp
  8004b7:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004bd:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004c4:	00 00 00 
	b.cnt = 0;
  8004c7:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004ce:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004d1:	ff 75 0c             	pushl  0xc(%ebp)
  8004d4:	ff 75 08             	pushl  0x8(%ebp)
  8004d7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004dd:	50                   	push   %eax
  8004de:	68 43 04 80 00       	push   $0x800443
  8004e3:	e8 5a 02 00 00       	call   800742 <vprintfmt>
  8004e8:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8004eb:	8b 15 18 b1 81 00    	mov    0x81b118,%edx
  8004f1:	a0 44 30 80 00       	mov    0x803044,%al
  8004f6:	0f b6 c0             	movzbl %al,%eax
  8004f9:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8004ff:	52                   	push   %edx
  800500:	50                   	push   %eax
  800501:	51                   	push   %ecx
  800502:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800508:	83 c0 08             	add    $0x8,%eax
  80050b:	50                   	push   %eax
  80050c:	e8 d9 10 00 00       	call   8015ea <sys_cputs>
  800511:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800514:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  80051b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800521:	c9                   	leave  
  800522:	c3                   	ret    

00800523 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800523:	55                   	push   %ebp
  800524:	89 e5                	mov    %esp,%ebp
  800526:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800529:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  800530:	8d 45 0c             	lea    0xc(%ebp),%eax
  800533:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800536:	8b 45 08             	mov    0x8(%ebp),%eax
  800539:	83 ec 08             	sub    $0x8,%esp
  80053c:	ff 75 f4             	pushl  -0xc(%ebp)
  80053f:	50                   	push   %eax
  800540:	e8 6f ff ff ff       	call   8004b4 <vcprintf>
  800545:	83 c4 10             	add    $0x10,%esp
  800548:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80054b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80054e:	c9                   	leave  
  80054f:	c3                   	ret    

00800550 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800550:	55                   	push   %ebp
  800551:	89 e5                	mov    %esp,%ebp
  800553:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800556:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  80055d:	8b 45 08             	mov    0x8(%ebp),%eax
  800560:	c1 e0 08             	shl    $0x8,%eax
  800563:	a3 18 b1 81 00       	mov    %eax,0x81b118
	va_start(ap, fmt);
  800568:	8d 45 0c             	lea    0xc(%ebp),%eax
  80056b:	83 c0 04             	add    $0x4,%eax
  80056e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800571:	8b 45 0c             	mov    0xc(%ebp),%eax
  800574:	83 ec 08             	sub    $0x8,%esp
  800577:	ff 75 f4             	pushl  -0xc(%ebp)
  80057a:	50                   	push   %eax
  80057b:	e8 34 ff ff ff       	call   8004b4 <vcprintf>
  800580:	83 c4 10             	add    $0x10,%esp
  800583:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800586:	c7 05 18 b1 81 00 00 	movl   $0x700,0x81b118
  80058d:	07 00 00 

	return cnt;
  800590:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800593:	c9                   	leave  
  800594:	c3                   	ret    

00800595 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800595:	55                   	push   %ebp
  800596:	89 e5                	mov    %esp,%ebp
  800598:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80059b:	e8 8e 10 00 00       	call   80162e <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8005a0:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8005a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a9:	83 ec 08             	sub    $0x8,%esp
  8005ac:	ff 75 f4             	pushl  -0xc(%ebp)
  8005af:	50                   	push   %eax
  8005b0:	e8 ff fe ff ff       	call   8004b4 <vcprintf>
  8005b5:	83 c4 10             	add    $0x10,%esp
  8005b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8005bb:	e8 88 10 00 00       	call   801648 <sys_unlock_cons>
	return cnt;
  8005c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005c3:	c9                   	leave  
  8005c4:	c3                   	ret    

008005c5 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005c5:	55                   	push   %ebp
  8005c6:	89 e5                	mov    %esp,%ebp
  8005c8:	53                   	push   %ebx
  8005c9:	83 ec 14             	sub    $0x14,%esp
  8005cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8005cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005d8:	8b 45 18             	mov    0x18(%ebp),%eax
  8005db:	ba 00 00 00 00       	mov    $0x0,%edx
  8005e0:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005e3:	77 55                	ja     80063a <printnum+0x75>
  8005e5:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005e8:	72 05                	jb     8005ef <printnum+0x2a>
  8005ea:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005ed:	77 4b                	ja     80063a <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005ef:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005f2:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005f5:	8b 45 18             	mov    0x18(%ebp),%eax
  8005f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8005fd:	52                   	push   %edx
  8005fe:	50                   	push   %eax
  8005ff:	ff 75 f4             	pushl  -0xc(%ebp)
  800602:	ff 75 f0             	pushl  -0x10(%ebp)
  800605:	e8 ce 1a 00 00       	call   8020d8 <__udivdi3>
  80060a:	83 c4 10             	add    $0x10,%esp
  80060d:	83 ec 04             	sub    $0x4,%esp
  800610:	ff 75 20             	pushl  0x20(%ebp)
  800613:	53                   	push   %ebx
  800614:	ff 75 18             	pushl  0x18(%ebp)
  800617:	52                   	push   %edx
  800618:	50                   	push   %eax
  800619:	ff 75 0c             	pushl  0xc(%ebp)
  80061c:	ff 75 08             	pushl  0x8(%ebp)
  80061f:	e8 a1 ff ff ff       	call   8005c5 <printnum>
  800624:	83 c4 20             	add    $0x20,%esp
  800627:	eb 1a                	jmp    800643 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800629:	83 ec 08             	sub    $0x8,%esp
  80062c:	ff 75 0c             	pushl  0xc(%ebp)
  80062f:	ff 75 20             	pushl  0x20(%ebp)
  800632:	8b 45 08             	mov    0x8(%ebp),%eax
  800635:	ff d0                	call   *%eax
  800637:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80063a:	ff 4d 1c             	decl   0x1c(%ebp)
  80063d:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800641:	7f e6                	jg     800629 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800643:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800646:	bb 00 00 00 00       	mov    $0x0,%ebx
  80064b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80064e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800651:	53                   	push   %ebx
  800652:	51                   	push   %ecx
  800653:	52                   	push   %edx
  800654:	50                   	push   %eax
  800655:	e8 8e 1b 00 00       	call   8021e8 <__umoddi3>
  80065a:	83 c4 10             	add    $0x10,%esp
  80065d:	05 f4 26 80 00       	add    $0x8026f4,%eax
  800662:	8a 00                	mov    (%eax),%al
  800664:	0f be c0             	movsbl %al,%eax
  800667:	83 ec 08             	sub    $0x8,%esp
  80066a:	ff 75 0c             	pushl  0xc(%ebp)
  80066d:	50                   	push   %eax
  80066e:	8b 45 08             	mov    0x8(%ebp),%eax
  800671:	ff d0                	call   *%eax
  800673:	83 c4 10             	add    $0x10,%esp
}
  800676:	90                   	nop
  800677:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80067a:	c9                   	leave  
  80067b:	c3                   	ret    

0080067c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80067c:	55                   	push   %ebp
  80067d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80067f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800683:	7e 1c                	jle    8006a1 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800685:	8b 45 08             	mov    0x8(%ebp),%eax
  800688:	8b 00                	mov    (%eax),%eax
  80068a:	8d 50 08             	lea    0x8(%eax),%edx
  80068d:	8b 45 08             	mov    0x8(%ebp),%eax
  800690:	89 10                	mov    %edx,(%eax)
  800692:	8b 45 08             	mov    0x8(%ebp),%eax
  800695:	8b 00                	mov    (%eax),%eax
  800697:	83 e8 08             	sub    $0x8,%eax
  80069a:	8b 50 04             	mov    0x4(%eax),%edx
  80069d:	8b 00                	mov    (%eax),%eax
  80069f:	eb 40                	jmp    8006e1 <getuint+0x65>
	else if (lflag)
  8006a1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006a5:	74 1e                	je     8006c5 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006aa:	8b 00                	mov    (%eax),%eax
  8006ac:	8d 50 04             	lea    0x4(%eax),%edx
  8006af:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b2:	89 10                	mov    %edx,(%eax)
  8006b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b7:	8b 00                	mov    (%eax),%eax
  8006b9:	83 e8 04             	sub    $0x4,%eax
  8006bc:	8b 00                	mov    (%eax),%eax
  8006be:	ba 00 00 00 00       	mov    $0x0,%edx
  8006c3:	eb 1c                	jmp    8006e1 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c8:	8b 00                	mov    (%eax),%eax
  8006ca:	8d 50 04             	lea    0x4(%eax),%edx
  8006cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d0:	89 10                	mov    %edx,(%eax)
  8006d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d5:	8b 00                	mov    (%eax),%eax
  8006d7:	83 e8 04             	sub    $0x4,%eax
  8006da:	8b 00                	mov    (%eax),%eax
  8006dc:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006e1:	5d                   	pop    %ebp
  8006e2:	c3                   	ret    

008006e3 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006e3:	55                   	push   %ebp
  8006e4:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006e6:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006ea:	7e 1c                	jle    800708 <getint+0x25>
		return va_arg(*ap, long long);
  8006ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ef:	8b 00                	mov    (%eax),%eax
  8006f1:	8d 50 08             	lea    0x8(%eax),%edx
  8006f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f7:	89 10                	mov    %edx,(%eax)
  8006f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fc:	8b 00                	mov    (%eax),%eax
  8006fe:	83 e8 08             	sub    $0x8,%eax
  800701:	8b 50 04             	mov    0x4(%eax),%edx
  800704:	8b 00                	mov    (%eax),%eax
  800706:	eb 38                	jmp    800740 <getint+0x5d>
	else if (lflag)
  800708:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80070c:	74 1a                	je     800728 <getint+0x45>
		return va_arg(*ap, long);
  80070e:	8b 45 08             	mov    0x8(%ebp),%eax
  800711:	8b 00                	mov    (%eax),%eax
  800713:	8d 50 04             	lea    0x4(%eax),%edx
  800716:	8b 45 08             	mov    0x8(%ebp),%eax
  800719:	89 10                	mov    %edx,(%eax)
  80071b:	8b 45 08             	mov    0x8(%ebp),%eax
  80071e:	8b 00                	mov    (%eax),%eax
  800720:	83 e8 04             	sub    $0x4,%eax
  800723:	8b 00                	mov    (%eax),%eax
  800725:	99                   	cltd   
  800726:	eb 18                	jmp    800740 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800728:	8b 45 08             	mov    0x8(%ebp),%eax
  80072b:	8b 00                	mov    (%eax),%eax
  80072d:	8d 50 04             	lea    0x4(%eax),%edx
  800730:	8b 45 08             	mov    0x8(%ebp),%eax
  800733:	89 10                	mov    %edx,(%eax)
  800735:	8b 45 08             	mov    0x8(%ebp),%eax
  800738:	8b 00                	mov    (%eax),%eax
  80073a:	83 e8 04             	sub    $0x4,%eax
  80073d:	8b 00                	mov    (%eax),%eax
  80073f:	99                   	cltd   
}
  800740:	5d                   	pop    %ebp
  800741:	c3                   	ret    

00800742 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800742:	55                   	push   %ebp
  800743:	89 e5                	mov    %esp,%ebp
  800745:	56                   	push   %esi
  800746:	53                   	push   %ebx
  800747:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80074a:	eb 17                	jmp    800763 <vprintfmt+0x21>
			if (ch == '\0')
  80074c:	85 db                	test   %ebx,%ebx
  80074e:	0f 84 c1 03 00 00    	je     800b15 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800754:	83 ec 08             	sub    $0x8,%esp
  800757:	ff 75 0c             	pushl  0xc(%ebp)
  80075a:	53                   	push   %ebx
  80075b:	8b 45 08             	mov    0x8(%ebp),%eax
  80075e:	ff d0                	call   *%eax
  800760:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800763:	8b 45 10             	mov    0x10(%ebp),%eax
  800766:	8d 50 01             	lea    0x1(%eax),%edx
  800769:	89 55 10             	mov    %edx,0x10(%ebp)
  80076c:	8a 00                	mov    (%eax),%al
  80076e:	0f b6 d8             	movzbl %al,%ebx
  800771:	83 fb 25             	cmp    $0x25,%ebx
  800774:	75 d6                	jne    80074c <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800776:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80077a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800781:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800788:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80078f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800796:	8b 45 10             	mov    0x10(%ebp),%eax
  800799:	8d 50 01             	lea    0x1(%eax),%edx
  80079c:	89 55 10             	mov    %edx,0x10(%ebp)
  80079f:	8a 00                	mov    (%eax),%al
  8007a1:	0f b6 d8             	movzbl %al,%ebx
  8007a4:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007a7:	83 f8 5b             	cmp    $0x5b,%eax
  8007aa:	0f 87 3d 03 00 00    	ja     800aed <vprintfmt+0x3ab>
  8007b0:	8b 04 85 18 27 80 00 	mov    0x802718(,%eax,4),%eax
  8007b7:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007b9:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007bd:	eb d7                	jmp    800796 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007bf:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007c3:	eb d1                	jmp    800796 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007c5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007cc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007cf:	89 d0                	mov    %edx,%eax
  8007d1:	c1 e0 02             	shl    $0x2,%eax
  8007d4:	01 d0                	add    %edx,%eax
  8007d6:	01 c0                	add    %eax,%eax
  8007d8:	01 d8                	add    %ebx,%eax
  8007da:	83 e8 30             	sub    $0x30,%eax
  8007dd:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8007e3:	8a 00                	mov    (%eax),%al
  8007e5:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007e8:	83 fb 2f             	cmp    $0x2f,%ebx
  8007eb:	7e 3e                	jle    80082b <vprintfmt+0xe9>
  8007ed:	83 fb 39             	cmp    $0x39,%ebx
  8007f0:	7f 39                	jg     80082b <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007f2:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007f5:	eb d5                	jmp    8007cc <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fa:	83 c0 04             	add    $0x4,%eax
  8007fd:	89 45 14             	mov    %eax,0x14(%ebp)
  800800:	8b 45 14             	mov    0x14(%ebp),%eax
  800803:	83 e8 04             	sub    $0x4,%eax
  800806:	8b 00                	mov    (%eax),%eax
  800808:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80080b:	eb 1f                	jmp    80082c <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80080d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800811:	79 83                	jns    800796 <vprintfmt+0x54>
				width = 0;
  800813:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80081a:	e9 77 ff ff ff       	jmp    800796 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80081f:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800826:	e9 6b ff ff ff       	jmp    800796 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80082b:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80082c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800830:	0f 89 60 ff ff ff    	jns    800796 <vprintfmt+0x54>
				width = precision, precision = -1;
  800836:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800839:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80083c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800843:	e9 4e ff ff ff       	jmp    800796 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800848:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80084b:	e9 46 ff ff ff       	jmp    800796 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800850:	8b 45 14             	mov    0x14(%ebp),%eax
  800853:	83 c0 04             	add    $0x4,%eax
  800856:	89 45 14             	mov    %eax,0x14(%ebp)
  800859:	8b 45 14             	mov    0x14(%ebp),%eax
  80085c:	83 e8 04             	sub    $0x4,%eax
  80085f:	8b 00                	mov    (%eax),%eax
  800861:	83 ec 08             	sub    $0x8,%esp
  800864:	ff 75 0c             	pushl  0xc(%ebp)
  800867:	50                   	push   %eax
  800868:	8b 45 08             	mov    0x8(%ebp),%eax
  80086b:	ff d0                	call   *%eax
  80086d:	83 c4 10             	add    $0x10,%esp
			break;
  800870:	e9 9b 02 00 00       	jmp    800b10 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800875:	8b 45 14             	mov    0x14(%ebp),%eax
  800878:	83 c0 04             	add    $0x4,%eax
  80087b:	89 45 14             	mov    %eax,0x14(%ebp)
  80087e:	8b 45 14             	mov    0x14(%ebp),%eax
  800881:	83 e8 04             	sub    $0x4,%eax
  800884:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800886:	85 db                	test   %ebx,%ebx
  800888:	79 02                	jns    80088c <vprintfmt+0x14a>
				err = -err;
  80088a:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80088c:	83 fb 64             	cmp    $0x64,%ebx
  80088f:	7f 0b                	jg     80089c <vprintfmt+0x15a>
  800891:	8b 34 9d 60 25 80 00 	mov    0x802560(,%ebx,4),%esi
  800898:	85 f6                	test   %esi,%esi
  80089a:	75 19                	jne    8008b5 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80089c:	53                   	push   %ebx
  80089d:	68 05 27 80 00       	push   $0x802705
  8008a2:	ff 75 0c             	pushl  0xc(%ebp)
  8008a5:	ff 75 08             	pushl  0x8(%ebp)
  8008a8:	e8 70 02 00 00       	call   800b1d <printfmt>
  8008ad:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008b0:	e9 5b 02 00 00       	jmp    800b10 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008b5:	56                   	push   %esi
  8008b6:	68 0e 27 80 00       	push   $0x80270e
  8008bb:	ff 75 0c             	pushl  0xc(%ebp)
  8008be:	ff 75 08             	pushl  0x8(%ebp)
  8008c1:	e8 57 02 00 00       	call   800b1d <printfmt>
  8008c6:	83 c4 10             	add    $0x10,%esp
			break;
  8008c9:	e9 42 02 00 00       	jmp    800b10 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d1:	83 c0 04             	add    $0x4,%eax
  8008d4:	89 45 14             	mov    %eax,0x14(%ebp)
  8008d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008da:	83 e8 04             	sub    $0x4,%eax
  8008dd:	8b 30                	mov    (%eax),%esi
  8008df:	85 f6                	test   %esi,%esi
  8008e1:	75 05                	jne    8008e8 <vprintfmt+0x1a6>
				p = "(null)";
  8008e3:	be 11 27 80 00       	mov    $0x802711,%esi
			if (width > 0 && padc != '-')
  8008e8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ec:	7e 6d                	jle    80095b <vprintfmt+0x219>
  8008ee:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008f2:	74 67                	je     80095b <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008f7:	83 ec 08             	sub    $0x8,%esp
  8008fa:	50                   	push   %eax
  8008fb:	56                   	push   %esi
  8008fc:	e8 1e 03 00 00       	call   800c1f <strnlen>
  800901:	83 c4 10             	add    $0x10,%esp
  800904:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800907:	eb 16                	jmp    80091f <vprintfmt+0x1dd>
					putch(padc, putdat);
  800909:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80090d:	83 ec 08             	sub    $0x8,%esp
  800910:	ff 75 0c             	pushl  0xc(%ebp)
  800913:	50                   	push   %eax
  800914:	8b 45 08             	mov    0x8(%ebp),%eax
  800917:	ff d0                	call   *%eax
  800919:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80091c:	ff 4d e4             	decl   -0x1c(%ebp)
  80091f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800923:	7f e4                	jg     800909 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800925:	eb 34                	jmp    80095b <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800927:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80092b:	74 1c                	je     800949 <vprintfmt+0x207>
  80092d:	83 fb 1f             	cmp    $0x1f,%ebx
  800930:	7e 05                	jle    800937 <vprintfmt+0x1f5>
  800932:	83 fb 7e             	cmp    $0x7e,%ebx
  800935:	7e 12                	jle    800949 <vprintfmt+0x207>
					putch('?', putdat);
  800937:	83 ec 08             	sub    $0x8,%esp
  80093a:	ff 75 0c             	pushl  0xc(%ebp)
  80093d:	6a 3f                	push   $0x3f
  80093f:	8b 45 08             	mov    0x8(%ebp),%eax
  800942:	ff d0                	call   *%eax
  800944:	83 c4 10             	add    $0x10,%esp
  800947:	eb 0f                	jmp    800958 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800949:	83 ec 08             	sub    $0x8,%esp
  80094c:	ff 75 0c             	pushl  0xc(%ebp)
  80094f:	53                   	push   %ebx
  800950:	8b 45 08             	mov    0x8(%ebp),%eax
  800953:	ff d0                	call   *%eax
  800955:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800958:	ff 4d e4             	decl   -0x1c(%ebp)
  80095b:	89 f0                	mov    %esi,%eax
  80095d:	8d 70 01             	lea    0x1(%eax),%esi
  800960:	8a 00                	mov    (%eax),%al
  800962:	0f be d8             	movsbl %al,%ebx
  800965:	85 db                	test   %ebx,%ebx
  800967:	74 24                	je     80098d <vprintfmt+0x24b>
  800969:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80096d:	78 b8                	js     800927 <vprintfmt+0x1e5>
  80096f:	ff 4d e0             	decl   -0x20(%ebp)
  800972:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800976:	79 af                	jns    800927 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800978:	eb 13                	jmp    80098d <vprintfmt+0x24b>
				putch(' ', putdat);
  80097a:	83 ec 08             	sub    $0x8,%esp
  80097d:	ff 75 0c             	pushl  0xc(%ebp)
  800980:	6a 20                	push   $0x20
  800982:	8b 45 08             	mov    0x8(%ebp),%eax
  800985:	ff d0                	call   *%eax
  800987:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80098a:	ff 4d e4             	decl   -0x1c(%ebp)
  80098d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800991:	7f e7                	jg     80097a <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800993:	e9 78 01 00 00       	jmp    800b10 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800998:	83 ec 08             	sub    $0x8,%esp
  80099b:	ff 75 e8             	pushl  -0x18(%ebp)
  80099e:	8d 45 14             	lea    0x14(%ebp),%eax
  8009a1:	50                   	push   %eax
  8009a2:	e8 3c fd ff ff       	call   8006e3 <getint>
  8009a7:	83 c4 10             	add    $0x10,%esp
  8009aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009ad:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009b6:	85 d2                	test   %edx,%edx
  8009b8:	79 23                	jns    8009dd <vprintfmt+0x29b>
				putch('-', putdat);
  8009ba:	83 ec 08             	sub    $0x8,%esp
  8009bd:	ff 75 0c             	pushl  0xc(%ebp)
  8009c0:	6a 2d                	push   $0x2d
  8009c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c5:	ff d0                	call   *%eax
  8009c7:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009d0:	f7 d8                	neg    %eax
  8009d2:	83 d2 00             	adc    $0x0,%edx
  8009d5:	f7 da                	neg    %edx
  8009d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009da:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009dd:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009e4:	e9 bc 00 00 00       	jmp    800aa5 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009e9:	83 ec 08             	sub    $0x8,%esp
  8009ec:	ff 75 e8             	pushl  -0x18(%ebp)
  8009ef:	8d 45 14             	lea    0x14(%ebp),%eax
  8009f2:	50                   	push   %eax
  8009f3:	e8 84 fc ff ff       	call   80067c <getuint>
  8009f8:	83 c4 10             	add    $0x10,%esp
  8009fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009fe:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a01:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a08:	e9 98 00 00 00       	jmp    800aa5 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a0d:	83 ec 08             	sub    $0x8,%esp
  800a10:	ff 75 0c             	pushl  0xc(%ebp)
  800a13:	6a 58                	push   $0x58
  800a15:	8b 45 08             	mov    0x8(%ebp),%eax
  800a18:	ff d0                	call   *%eax
  800a1a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a1d:	83 ec 08             	sub    $0x8,%esp
  800a20:	ff 75 0c             	pushl  0xc(%ebp)
  800a23:	6a 58                	push   $0x58
  800a25:	8b 45 08             	mov    0x8(%ebp),%eax
  800a28:	ff d0                	call   *%eax
  800a2a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a2d:	83 ec 08             	sub    $0x8,%esp
  800a30:	ff 75 0c             	pushl  0xc(%ebp)
  800a33:	6a 58                	push   $0x58
  800a35:	8b 45 08             	mov    0x8(%ebp),%eax
  800a38:	ff d0                	call   *%eax
  800a3a:	83 c4 10             	add    $0x10,%esp
			break;
  800a3d:	e9 ce 00 00 00       	jmp    800b10 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800a42:	83 ec 08             	sub    $0x8,%esp
  800a45:	ff 75 0c             	pushl  0xc(%ebp)
  800a48:	6a 30                	push   $0x30
  800a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4d:	ff d0                	call   *%eax
  800a4f:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a52:	83 ec 08             	sub    $0x8,%esp
  800a55:	ff 75 0c             	pushl  0xc(%ebp)
  800a58:	6a 78                	push   $0x78
  800a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5d:	ff d0                	call   *%eax
  800a5f:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a62:	8b 45 14             	mov    0x14(%ebp),%eax
  800a65:	83 c0 04             	add    $0x4,%eax
  800a68:	89 45 14             	mov    %eax,0x14(%ebp)
  800a6b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6e:	83 e8 04             	sub    $0x4,%eax
  800a71:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a73:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a76:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a7d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a84:	eb 1f                	jmp    800aa5 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a86:	83 ec 08             	sub    $0x8,%esp
  800a89:	ff 75 e8             	pushl  -0x18(%ebp)
  800a8c:	8d 45 14             	lea    0x14(%ebp),%eax
  800a8f:	50                   	push   %eax
  800a90:	e8 e7 fb ff ff       	call   80067c <getuint>
  800a95:	83 c4 10             	add    $0x10,%esp
  800a98:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a9b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a9e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800aa5:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800aa9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800aac:	83 ec 04             	sub    $0x4,%esp
  800aaf:	52                   	push   %edx
  800ab0:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ab3:	50                   	push   %eax
  800ab4:	ff 75 f4             	pushl  -0xc(%ebp)
  800ab7:	ff 75 f0             	pushl  -0x10(%ebp)
  800aba:	ff 75 0c             	pushl  0xc(%ebp)
  800abd:	ff 75 08             	pushl  0x8(%ebp)
  800ac0:	e8 00 fb ff ff       	call   8005c5 <printnum>
  800ac5:	83 c4 20             	add    $0x20,%esp
			break;
  800ac8:	eb 46                	jmp    800b10 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800aca:	83 ec 08             	sub    $0x8,%esp
  800acd:	ff 75 0c             	pushl  0xc(%ebp)
  800ad0:	53                   	push   %ebx
  800ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad4:	ff d0                	call   *%eax
  800ad6:	83 c4 10             	add    $0x10,%esp
			break;
  800ad9:	eb 35                	jmp    800b10 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800adb:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800ae2:	eb 2c                	jmp    800b10 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800ae4:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800aeb:	eb 23                	jmp    800b10 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800aed:	83 ec 08             	sub    $0x8,%esp
  800af0:	ff 75 0c             	pushl  0xc(%ebp)
  800af3:	6a 25                	push   $0x25
  800af5:	8b 45 08             	mov    0x8(%ebp),%eax
  800af8:	ff d0                	call   *%eax
  800afa:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800afd:	ff 4d 10             	decl   0x10(%ebp)
  800b00:	eb 03                	jmp    800b05 <vprintfmt+0x3c3>
  800b02:	ff 4d 10             	decl   0x10(%ebp)
  800b05:	8b 45 10             	mov    0x10(%ebp),%eax
  800b08:	48                   	dec    %eax
  800b09:	8a 00                	mov    (%eax),%al
  800b0b:	3c 25                	cmp    $0x25,%al
  800b0d:	75 f3                	jne    800b02 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800b0f:	90                   	nop
		}
	}
  800b10:	e9 35 fc ff ff       	jmp    80074a <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b15:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b16:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b19:	5b                   	pop    %ebx
  800b1a:	5e                   	pop    %esi
  800b1b:	5d                   	pop    %ebp
  800b1c:	c3                   	ret    

00800b1d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b1d:	55                   	push   %ebp
  800b1e:	89 e5                	mov    %esp,%ebp
  800b20:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b23:	8d 45 10             	lea    0x10(%ebp),%eax
  800b26:	83 c0 04             	add    $0x4,%eax
  800b29:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b2c:	8b 45 10             	mov    0x10(%ebp),%eax
  800b2f:	ff 75 f4             	pushl  -0xc(%ebp)
  800b32:	50                   	push   %eax
  800b33:	ff 75 0c             	pushl  0xc(%ebp)
  800b36:	ff 75 08             	pushl  0x8(%ebp)
  800b39:	e8 04 fc ff ff       	call   800742 <vprintfmt>
  800b3e:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b41:	90                   	nop
  800b42:	c9                   	leave  
  800b43:	c3                   	ret    

00800b44 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b44:	55                   	push   %ebp
  800b45:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4a:	8b 40 08             	mov    0x8(%eax),%eax
  800b4d:	8d 50 01             	lea    0x1(%eax),%edx
  800b50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b53:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b59:	8b 10                	mov    (%eax),%edx
  800b5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5e:	8b 40 04             	mov    0x4(%eax),%eax
  800b61:	39 c2                	cmp    %eax,%edx
  800b63:	73 12                	jae    800b77 <sprintputch+0x33>
		*b->buf++ = ch;
  800b65:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b68:	8b 00                	mov    (%eax),%eax
  800b6a:	8d 48 01             	lea    0x1(%eax),%ecx
  800b6d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b70:	89 0a                	mov    %ecx,(%edx)
  800b72:	8b 55 08             	mov    0x8(%ebp),%edx
  800b75:	88 10                	mov    %dl,(%eax)
}
  800b77:	90                   	nop
  800b78:	5d                   	pop    %ebp
  800b79:	c3                   	ret    

00800b7a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b7a:	55                   	push   %ebp
  800b7b:	89 e5                	mov    %esp,%ebp
  800b7d:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b80:	8b 45 08             	mov    0x8(%ebp),%eax
  800b83:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b86:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b89:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8f:	01 d0                	add    %edx,%eax
  800b91:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b94:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b9b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b9f:	74 06                	je     800ba7 <vsnprintf+0x2d>
  800ba1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ba5:	7f 07                	jg     800bae <vsnprintf+0x34>
		return -E_INVAL;
  800ba7:	b8 03 00 00 00       	mov    $0x3,%eax
  800bac:	eb 20                	jmp    800bce <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800bae:	ff 75 14             	pushl  0x14(%ebp)
  800bb1:	ff 75 10             	pushl  0x10(%ebp)
  800bb4:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bb7:	50                   	push   %eax
  800bb8:	68 44 0b 80 00       	push   $0x800b44
  800bbd:	e8 80 fb ff ff       	call   800742 <vprintfmt>
  800bc2:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800bc5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bc8:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800bce:	c9                   	leave  
  800bcf:	c3                   	ret    

00800bd0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bd0:	55                   	push   %ebp
  800bd1:	89 e5                	mov    %esp,%ebp
  800bd3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bd6:	8d 45 10             	lea    0x10(%ebp),%eax
  800bd9:	83 c0 04             	add    $0x4,%eax
  800bdc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800bdf:	8b 45 10             	mov    0x10(%ebp),%eax
  800be2:	ff 75 f4             	pushl  -0xc(%ebp)
  800be5:	50                   	push   %eax
  800be6:	ff 75 0c             	pushl  0xc(%ebp)
  800be9:	ff 75 08             	pushl  0x8(%ebp)
  800bec:	e8 89 ff ff ff       	call   800b7a <vsnprintf>
  800bf1:	83 c4 10             	add    $0x10,%esp
  800bf4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bf7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bfa:	c9                   	leave  
  800bfb:	c3                   	ret    

00800bfc <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800bfc:	55                   	push   %ebp
  800bfd:	89 e5                	mov    %esp,%ebp
  800bff:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c02:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c09:	eb 06                	jmp    800c11 <strlen+0x15>
		n++;
  800c0b:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c0e:	ff 45 08             	incl   0x8(%ebp)
  800c11:	8b 45 08             	mov    0x8(%ebp),%eax
  800c14:	8a 00                	mov    (%eax),%al
  800c16:	84 c0                	test   %al,%al
  800c18:	75 f1                	jne    800c0b <strlen+0xf>
		n++;
	return n;
  800c1a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c1d:	c9                   	leave  
  800c1e:	c3                   	ret    

00800c1f <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c1f:	55                   	push   %ebp
  800c20:	89 e5                	mov    %esp,%ebp
  800c22:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c25:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c2c:	eb 09                	jmp    800c37 <strnlen+0x18>
		n++;
  800c2e:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c31:	ff 45 08             	incl   0x8(%ebp)
  800c34:	ff 4d 0c             	decl   0xc(%ebp)
  800c37:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c3b:	74 09                	je     800c46 <strnlen+0x27>
  800c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c40:	8a 00                	mov    (%eax),%al
  800c42:	84 c0                	test   %al,%al
  800c44:	75 e8                	jne    800c2e <strnlen+0xf>
		n++;
	return n;
  800c46:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c49:	c9                   	leave  
  800c4a:	c3                   	ret    

00800c4b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c4b:	55                   	push   %ebp
  800c4c:	89 e5                	mov    %esp,%ebp
  800c4e:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c51:	8b 45 08             	mov    0x8(%ebp),%eax
  800c54:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c57:	90                   	nop
  800c58:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5b:	8d 50 01             	lea    0x1(%eax),%edx
  800c5e:	89 55 08             	mov    %edx,0x8(%ebp)
  800c61:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c64:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c67:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c6a:	8a 12                	mov    (%edx),%dl
  800c6c:	88 10                	mov    %dl,(%eax)
  800c6e:	8a 00                	mov    (%eax),%al
  800c70:	84 c0                	test   %al,%al
  800c72:	75 e4                	jne    800c58 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c74:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c77:	c9                   	leave  
  800c78:	c3                   	ret    

00800c79 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c79:	55                   	push   %ebp
  800c7a:	89 e5                	mov    %esp,%ebp
  800c7c:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c82:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c85:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c8c:	eb 1f                	jmp    800cad <strncpy+0x34>
		*dst++ = *src;
  800c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c91:	8d 50 01             	lea    0x1(%eax),%edx
  800c94:	89 55 08             	mov    %edx,0x8(%ebp)
  800c97:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c9a:	8a 12                	mov    (%edx),%dl
  800c9c:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca1:	8a 00                	mov    (%eax),%al
  800ca3:	84 c0                	test   %al,%al
  800ca5:	74 03                	je     800caa <strncpy+0x31>
			src++;
  800ca7:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800caa:	ff 45 fc             	incl   -0x4(%ebp)
  800cad:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cb0:	3b 45 10             	cmp    0x10(%ebp),%eax
  800cb3:	72 d9                	jb     800c8e <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800cb5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800cb8:	c9                   	leave  
  800cb9:	c3                   	ret    

00800cba <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800cba:	55                   	push   %ebp
  800cbb:	89 e5                	mov    %esp,%ebp
  800cbd:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800cc6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cca:	74 30                	je     800cfc <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ccc:	eb 16                	jmp    800ce4 <strlcpy+0x2a>
			*dst++ = *src++;
  800cce:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd1:	8d 50 01             	lea    0x1(%eax),%edx
  800cd4:	89 55 08             	mov    %edx,0x8(%ebp)
  800cd7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cda:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cdd:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ce0:	8a 12                	mov    (%edx),%dl
  800ce2:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ce4:	ff 4d 10             	decl   0x10(%ebp)
  800ce7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ceb:	74 09                	je     800cf6 <strlcpy+0x3c>
  800ced:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf0:	8a 00                	mov    (%eax),%al
  800cf2:	84 c0                	test   %al,%al
  800cf4:	75 d8                	jne    800cce <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800cf6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf9:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cfc:	8b 55 08             	mov    0x8(%ebp),%edx
  800cff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d02:	29 c2                	sub    %eax,%edx
  800d04:	89 d0                	mov    %edx,%eax
}
  800d06:	c9                   	leave  
  800d07:	c3                   	ret    

00800d08 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d08:	55                   	push   %ebp
  800d09:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d0b:	eb 06                	jmp    800d13 <strcmp+0xb>
		p++, q++;
  800d0d:	ff 45 08             	incl   0x8(%ebp)
  800d10:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d13:	8b 45 08             	mov    0x8(%ebp),%eax
  800d16:	8a 00                	mov    (%eax),%al
  800d18:	84 c0                	test   %al,%al
  800d1a:	74 0e                	je     800d2a <strcmp+0x22>
  800d1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1f:	8a 10                	mov    (%eax),%dl
  800d21:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d24:	8a 00                	mov    (%eax),%al
  800d26:	38 c2                	cmp    %al,%dl
  800d28:	74 e3                	je     800d0d <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2d:	8a 00                	mov    (%eax),%al
  800d2f:	0f b6 d0             	movzbl %al,%edx
  800d32:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d35:	8a 00                	mov    (%eax),%al
  800d37:	0f b6 c0             	movzbl %al,%eax
  800d3a:	29 c2                	sub    %eax,%edx
  800d3c:	89 d0                	mov    %edx,%eax
}
  800d3e:	5d                   	pop    %ebp
  800d3f:	c3                   	ret    

00800d40 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d40:	55                   	push   %ebp
  800d41:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d43:	eb 09                	jmp    800d4e <strncmp+0xe>
		n--, p++, q++;
  800d45:	ff 4d 10             	decl   0x10(%ebp)
  800d48:	ff 45 08             	incl   0x8(%ebp)
  800d4b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d4e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d52:	74 17                	je     800d6b <strncmp+0x2b>
  800d54:	8b 45 08             	mov    0x8(%ebp),%eax
  800d57:	8a 00                	mov    (%eax),%al
  800d59:	84 c0                	test   %al,%al
  800d5b:	74 0e                	je     800d6b <strncmp+0x2b>
  800d5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d60:	8a 10                	mov    (%eax),%dl
  800d62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d65:	8a 00                	mov    (%eax),%al
  800d67:	38 c2                	cmp    %al,%dl
  800d69:	74 da                	je     800d45 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d6b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d6f:	75 07                	jne    800d78 <strncmp+0x38>
		return 0;
  800d71:	b8 00 00 00 00       	mov    $0x0,%eax
  800d76:	eb 14                	jmp    800d8c <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d78:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7b:	8a 00                	mov    (%eax),%al
  800d7d:	0f b6 d0             	movzbl %al,%edx
  800d80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d83:	8a 00                	mov    (%eax),%al
  800d85:	0f b6 c0             	movzbl %al,%eax
  800d88:	29 c2                	sub    %eax,%edx
  800d8a:	89 d0                	mov    %edx,%eax
}
  800d8c:	5d                   	pop    %ebp
  800d8d:	c3                   	ret    

00800d8e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d8e:	55                   	push   %ebp
  800d8f:	89 e5                	mov    %esp,%ebp
  800d91:	83 ec 04             	sub    $0x4,%esp
  800d94:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d97:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d9a:	eb 12                	jmp    800dae <strchr+0x20>
		if (*s == c)
  800d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9f:	8a 00                	mov    (%eax),%al
  800da1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800da4:	75 05                	jne    800dab <strchr+0x1d>
			return (char *) s;
  800da6:	8b 45 08             	mov    0x8(%ebp),%eax
  800da9:	eb 11                	jmp    800dbc <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800dab:	ff 45 08             	incl   0x8(%ebp)
  800dae:	8b 45 08             	mov    0x8(%ebp),%eax
  800db1:	8a 00                	mov    (%eax),%al
  800db3:	84 c0                	test   %al,%al
  800db5:	75 e5                	jne    800d9c <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800db7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dbc:	c9                   	leave  
  800dbd:	c3                   	ret    

00800dbe <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800dbe:	55                   	push   %ebp
  800dbf:	89 e5                	mov    %esp,%ebp
  800dc1:	83 ec 04             	sub    $0x4,%esp
  800dc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dca:	eb 0d                	jmp    800dd9 <strfind+0x1b>
		if (*s == c)
  800dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcf:	8a 00                	mov    (%eax),%al
  800dd1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dd4:	74 0e                	je     800de4 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800dd6:	ff 45 08             	incl   0x8(%ebp)
  800dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddc:	8a 00                	mov    (%eax),%al
  800dde:	84 c0                	test   %al,%al
  800de0:	75 ea                	jne    800dcc <strfind+0xe>
  800de2:	eb 01                	jmp    800de5 <strfind+0x27>
		if (*s == c)
			break;
  800de4:	90                   	nop
	return (char *) s;
  800de5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800de8:	c9                   	leave  
  800de9:	c3                   	ret    

00800dea <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800dea:	55                   	push   %ebp
  800deb:	89 e5                	mov    %esp,%ebp
  800ded:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800df0:	8b 45 08             	mov    0x8(%ebp),%eax
  800df3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800df6:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800dfa:	76 63                	jbe    800e5f <memset+0x75>
		uint64 data_block = c;
  800dfc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dff:	99                   	cltd   
  800e00:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e03:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800e06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e09:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e0c:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800e10:	c1 e0 08             	shl    $0x8,%eax
  800e13:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e16:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800e19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e1c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e1f:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800e23:	c1 e0 10             	shl    $0x10,%eax
  800e26:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e29:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800e2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e2f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e32:	89 c2                	mov    %eax,%edx
  800e34:	b8 00 00 00 00       	mov    $0x0,%eax
  800e39:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e3c:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800e3f:	eb 18                	jmp    800e59 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800e41:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800e44:	8d 41 08             	lea    0x8(%ecx),%eax
  800e47:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800e4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e4d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e50:	89 01                	mov    %eax,(%ecx)
  800e52:	89 51 04             	mov    %edx,0x4(%ecx)
  800e55:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800e59:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e5d:	77 e2                	ja     800e41 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800e5f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e63:	74 23                	je     800e88 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800e65:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e68:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e6b:	eb 0e                	jmp    800e7b <memset+0x91>
			*p8++ = (uint8)c;
  800e6d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e70:	8d 50 01             	lea    0x1(%eax),%edx
  800e73:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e76:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e79:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800e7b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e7e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e81:	89 55 10             	mov    %edx,0x10(%ebp)
  800e84:	85 c0                	test   %eax,%eax
  800e86:	75 e5                	jne    800e6d <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800e88:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e8b:	c9                   	leave  
  800e8c:	c3                   	ret    

00800e8d <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e8d:	55                   	push   %ebp
  800e8e:	89 e5                	mov    %esp,%ebp
  800e90:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800e93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e96:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800e99:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800e9f:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ea3:	76 24                	jbe    800ec9 <memcpy+0x3c>
		while(n >= 8){
  800ea5:	eb 1c                	jmp    800ec3 <memcpy+0x36>
			*d64 = *s64;
  800ea7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eaa:	8b 50 04             	mov    0x4(%eax),%edx
  800ead:	8b 00                	mov    (%eax),%eax
  800eaf:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800eb2:	89 01                	mov    %eax,(%ecx)
  800eb4:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800eb7:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800ebb:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800ebf:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800ec3:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ec7:	77 de                	ja     800ea7 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800ec9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ecd:	74 31                	je     800f00 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800ecf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800ed5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ed8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800edb:	eb 16                	jmp    800ef3 <memcpy+0x66>
			*d8++ = *s8++;
  800edd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ee0:	8d 50 01             	lea    0x1(%eax),%edx
  800ee3:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800ee6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ee9:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eec:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800eef:	8a 12                	mov    (%edx),%dl
  800ef1:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800ef3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ef6:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ef9:	89 55 10             	mov    %edx,0x10(%ebp)
  800efc:	85 c0                	test   %eax,%eax
  800efe:	75 dd                	jne    800edd <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800f00:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f03:	c9                   	leave  
  800f04:	c3                   	ret    

00800f05 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f05:	55                   	push   %ebp
  800f06:	89 e5                	mov    %esp,%ebp
  800f08:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f0e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f11:	8b 45 08             	mov    0x8(%ebp),%eax
  800f14:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f17:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f1a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f1d:	73 50                	jae    800f6f <memmove+0x6a>
  800f1f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f22:	8b 45 10             	mov    0x10(%ebp),%eax
  800f25:	01 d0                	add    %edx,%eax
  800f27:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f2a:	76 43                	jbe    800f6f <memmove+0x6a>
		s += n;
  800f2c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f2f:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f32:	8b 45 10             	mov    0x10(%ebp),%eax
  800f35:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f38:	eb 10                	jmp    800f4a <memmove+0x45>
			*--d = *--s;
  800f3a:	ff 4d f8             	decl   -0x8(%ebp)
  800f3d:	ff 4d fc             	decl   -0x4(%ebp)
  800f40:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f43:	8a 10                	mov    (%eax),%dl
  800f45:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f48:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f4a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f4d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f50:	89 55 10             	mov    %edx,0x10(%ebp)
  800f53:	85 c0                	test   %eax,%eax
  800f55:	75 e3                	jne    800f3a <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f57:	eb 23                	jmp    800f7c <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f59:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f5c:	8d 50 01             	lea    0x1(%eax),%edx
  800f5f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f62:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f65:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f68:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f6b:	8a 12                	mov    (%edx),%dl
  800f6d:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f6f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f72:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f75:	89 55 10             	mov    %edx,0x10(%ebp)
  800f78:	85 c0                	test   %eax,%eax
  800f7a:	75 dd                	jne    800f59 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f7c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f7f:	c9                   	leave  
  800f80:	c3                   	ret    

00800f81 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f81:	55                   	push   %ebp
  800f82:	89 e5                	mov    %esp,%ebp
  800f84:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f87:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f90:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f93:	eb 2a                	jmp    800fbf <memcmp+0x3e>
		if (*s1 != *s2)
  800f95:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f98:	8a 10                	mov    (%eax),%dl
  800f9a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f9d:	8a 00                	mov    (%eax),%al
  800f9f:	38 c2                	cmp    %al,%dl
  800fa1:	74 16                	je     800fb9 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800fa3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fa6:	8a 00                	mov    (%eax),%al
  800fa8:	0f b6 d0             	movzbl %al,%edx
  800fab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fae:	8a 00                	mov    (%eax),%al
  800fb0:	0f b6 c0             	movzbl %al,%eax
  800fb3:	29 c2                	sub    %eax,%edx
  800fb5:	89 d0                	mov    %edx,%eax
  800fb7:	eb 18                	jmp    800fd1 <memcmp+0x50>
		s1++, s2++;
  800fb9:	ff 45 fc             	incl   -0x4(%ebp)
  800fbc:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800fbf:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc2:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fc5:	89 55 10             	mov    %edx,0x10(%ebp)
  800fc8:	85 c0                	test   %eax,%eax
  800fca:	75 c9                	jne    800f95 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800fcc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fd1:	c9                   	leave  
  800fd2:	c3                   	ret    

00800fd3 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800fd3:	55                   	push   %ebp
  800fd4:	89 e5                	mov    %esp,%ebp
  800fd6:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800fd9:	8b 55 08             	mov    0x8(%ebp),%edx
  800fdc:	8b 45 10             	mov    0x10(%ebp),%eax
  800fdf:	01 d0                	add    %edx,%eax
  800fe1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800fe4:	eb 15                	jmp    800ffb <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800fe6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe9:	8a 00                	mov    (%eax),%al
  800feb:	0f b6 d0             	movzbl %al,%edx
  800fee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff1:	0f b6 c0             	movzbl %al,%eax
  800ff4:	39 c2                	cmp    %eax,%edx
  800ff6:	74 0d                	je     801005 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ff8:	ff 45 08             	incl   0x8(%ebp)
  800ffb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffe:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801001:	72 e3                	jb     800fe6 <memfind+0x13>
  801003:	eb 01                	jmp    801006 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801005:	90                   	nop
	return (void *) s;
  801006:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801009:	c9                   	leave  
  80100a:	c3                   	ret    

0080100b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80100b:	55                   	push   %ebp
  80100c:	89 e5                	mov    %esp,%ebp
  80100e:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801011:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801018:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80101f:	eb 03                	jmp    801024 <strtol+0x19>
		s++;
  801021:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801024:	8b 45 08             	mov    0x8(%ebp),%eax
  801027:	8a 00                	mov    (%eax),%al
  801029:	3c 20                	cmp    $0x20,%al
  80102b:	74 f4                	je     801021 <strtol+0x16>
  80102d:	8b 45 08             	mov    0x8(%ebp),%eax
  801030:	8a 00                	mov    (%eax),%al
  801032:	3c 09                	cmp    $0x9,%al
  801034:	74 eb                	je     801021 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801036:	8b 45 08             	mov    0x8(%ebp),%eax
  801039:	8a 00                	mov    (%eax),%al
  80103b:	3c 2b                	cmp    $0x2b,%al
  80103d:	75 05                	jne    801044 <strtol+0x39>
		s++;
  80103f:	ff 45 08             	incl   0x8(%ebp)
  801042:	eb 13                	jmp    801057 <strtol+0x4c>
	else if (*s == '-')
  801044:	8b 45 08             	mov    0x8(%ebp),%eax
  801047:	8a 00                	mov    (%eax),%al
  801049:	3c 2d                	cmp    $0x2d,%al
  80104b:	75 0a                	jne    801057 <strtol+0x4c>
		s++, neg = 1;
  80104d:	ff 45 08             	incl   0x8(%ebp)
  801050:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801057:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80105b:	74 06                	je     801063 <strtol+0x58>
  80105d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801061:	75 20                	jne    801083 <strtol+0x78>
  801063:	8b 45 08             	mov    0x8(%ebp),%eax
  801066:	8a 00                	mov    (%eax),%al
  801068:	3c 30                	cmp    $0x30,%al
  80106a:	75 17                	jne    801083 <strtol+0x78>
  80106c:	8b 45 08             	mov    0x8(%ebp),%eax
  80106f:	40                   	inc    %eax
  801070:	8a 00                	mov    (%eax),%al
  801072:	3c 78                	cmp    $0x78,%al
  801074:	75 0d                	jne    801083 <strtol+0x78>
		s += 2, base = 16;
  801076:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80107a:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801081:	eb 28                	jmp    8010ab <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801083:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801087:	75 15                	jne    80109e <strtol+0x93>
  801089:	8b 45 08             	mov    0x8(%ebp),%eax
  80108c:	8a 00                	mov    (%eax),%al
  80108e:	3c 30                	cmp    $0x30,%al
  801090:	75 0c                	jne    80109e <strtol+0x93>
		s++, base = 8;
  801092:	ff 45 08             	incl   0x8(%ebp)
  801095:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80109c:	eb 0d                	jmp    8010ab <strtol+0xa0>
	else if (base == 0)
  80109e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010a2:	75 07                	jne    8010ab <strtol+0xa0>
		base = 10;
  8010a4:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8010ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ae:	8a 00                	mov    (%eax),%al
  8010b0:	3c 2f                	cmp    $0x2f,%al
  8010b2:	7e 19                	jle    8010cd <strtol+0xc2>
  8010b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b7:	8a 00                	mov    (%eax),%al
  8010b9:	3c 39                	cmp    $0x39,%al
  8010bb:	7f 10                	jg     8010cd <strtol+0xc2>
			dig = *s - '0';
  8010bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c0:	8a 00                	mov    (%eax),%al
  8010c2:	0f be c0             	movsbl %al,%eax
  8010c5:	83 e8 30             	sub    $0x30,%eax
  8010c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010cb:	eb 42                	jmp    80110f <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8010cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d0:	8a 00                	mov    (%eax),%al
  8010d2:	3c 60                	cmp    $0x60,%al
  8010d4:	7e 19                	jle    8010ef <strtol+0xe4>
  8010d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d9:	8a 00                	mov    (%eax),%al
  8010db:	3c 7a                	cmp    $0x7a,%al
  8010dd:	7f 10                	jg     8010ef <strtol+0xe4>
			dig = *s - 'a' + 10;
  8010df:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e2:	8a 00                	mov    (%eax),%al
  8010e4:	0f be c0             	movsbl %al,%eax
  8010e7:	83 e8 57             	sub    $0x57,%eax
  8010ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010ed:	eb 20                	jmp    80110f <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8010ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f2:	8a 00                	mov    (%eax),%al
  8010f4:	3c 40                	cmp    $0x40,%al
  8010f6:	7e 39                	jle    801131 <strtol+0x126>
  8010f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fb:	8a 00                	mov    (%eax),%al
  8010fd:	3c 5a                	cmp    $0x5a,%al
  8010ff:	7f 30                	jg     801131 <strtol+0x126>
			dig = *s - 'A' + 10;
  801101:	8b 45 08             	mov    0x8(%ebp),%eax
  801104:	8a 00                	mov    (%eax),%al
  801106:	0f be c0             	movsbl %al,%eax
  801109:	83 e8 37             	sub    $0x37,%eax
  80110c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80110f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801112:	3b 45 10             	cmp    0x10(%ebp),%eax
  801115:	7d 19                	jge    801130 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801117:	ff 45 08             	incl   0x8(%ebp)
  80111a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80111d:	0f af 45 10          	imul   0x10(%ebp),%eax
  801121:	89 c2                	mov    %eax,%edx
  801123:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801126:	01 d0                	add    %edx,%eax
  801128:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80112b:	e9 7b ff ff ff       	jmp    8010ab <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801130:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801131:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801135:	74 08                	je     80113f <strtol+0x134>
		*endptr = (char *) s;
  801137:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113a:	8b 55 08             	mov    0x8(%ebp),%edx
  80113d:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80113f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801143:	74 07                	je     80114c <strtol+0x141>
  801145:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801148:	f7 d8                	neg    %eax
  80114a:	eb 03                	jmp    80114f <strtol+0x144>
  80114c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80114f:	c9                   	leave  
  801150:	c3                   	ret    

00801151 <ltostr>:

void
ltostr(long value, char *str)
{
  801151:	55                   	push   %ebp
  801152:	89 e5                	mov    %esp,%ebp
  801154:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801157:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80115e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801165:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801169:	79 13                	jns    80117e <ltostr+0x2d>
	{
		neg = 1;
  80116b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801172:	8b 45 0c             	mov    0xc(%ebp),%eax
  801175:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801178:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80117b:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80117e:	8b 45 08             	mov    0x8(%ebp),%eax
  801181:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801186:	99                   	cltd   
  801187:	f7 f9                	idiv   %ecx
  801189:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80118c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80118f:	8d 50 01             	lea    0x1(%eax),%edx
  801192:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801195:	89 c2                	mov    %eax,%edx
  801197:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119a:	01 d0                	add    %edx,%eax
  80119c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80119f:	83 c2 30             	add    $0x30,%edx
  8011a2:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8011a4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011a7:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011ac:	f7 e9                	imul   %ecx
  8011ae:	c1 fa 02             	sar    $0x2,%edx
  8011b1:	89 c8                	mov    %ecx,%eax
  8011b3:	c1 f8 1f             	sar    $0x1f,%eax
  8011b6:	29 c2                	sub    %eax,%edx
  8011b8:	89 d0                	mov    %edx,%eax
  8011ba:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8011bd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011c1:	75 bb                	jne    80117e <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8011c3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8011ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011cd:	48                   	dec    %eax
  8011ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8011d1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011d5:	74 3d                	je     801214 <ltostr+0xc3>
		start = 1 ;
  8011d7:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8011de:	eb 34                	jmp    801214 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8011e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e6:	01 d0                	add    %edx,%eax
  8011e8:	8a 00                	mov    (%eax),%al
  8011ea:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8011ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f3:	01 c2                	add    %eax,%edx
  8011f5:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8011f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fb:	01 c8                	add    %ecx,%eax
  8011fd:	8a 00                	mov    (%eax),%al
  8011ff:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801201:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801204:	8b 45 0c             	mov    0xc(%ebp),%eax
  801207:	01 c2                	add    %eax,%edx
  801209:	8a 45 eb             	mov    -0x15(%ebp),%al
  80120c:	88 02                	mov    %al,(%edx)
		start++ ;
  80120e:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801211:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801214:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801217:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80121a:	7c c4                	jl     8011e0 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80121c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80121f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801222:	01 d0                	add    %edx,%eax
  801224:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801227:	90                   	nop
  801228:	c9                   	leave  
  801229:	c3                   	ret    

0080122a <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80122a:	55                   	push   %ebp
  80122b:	89 e5                	mov    %esp,%ebp
  80122d:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801230:	ff 75 08             	pushl  0x8(%ebp)
  801233:	e8 c4 f9 ff ff       	call   800bfc <strlen>
  801238:	83 c4 04             	add    $0x4,%esp
  80123b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80123e:	ff 75 0c             	pushl  0xc(%ebp)
  801241:	e8 b6 f9 ff ff       	call   800bfc <strlen>
  801246:	83 c4 04             	add    $0x4,%esp
  801249:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80124c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801253:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80125a:	eb 17                	jmp    801273 <strcconcat+0x49>
		final[s] = str1[s] ;
  80125c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80125f:	8b 45 10             	mov    0x10(%ebp),%eax
  801262:	01 c2                	add    %eax,%edx
  801264:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801267:	8b 45 08             	mov    0x8(%ebp),%eax
  80126a:	01 c8                	add    %ecx,%eax
  80126c:	8a 00                	mov    (%eax),%al
  80126e:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801270:	ff 45 fc             	incl   -0x4(%ebp)
  801273:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801276:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801279:	7c e1                	jl     80125c <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80127b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801282:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801289:	eb 1f                	jmp    8012aa <strcconcat+0x80>
		final[s++] = str2[i] ;
  80128b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80128e:	8d 50 01             	lea    0x1(%eax),%edx
  801291:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801294:	89 c2                	mov    %eax,%edx
  801296:	8b 45 10             	mov    0x10(%ebp),%eax
  801299:	01 c2                	add    %eax,%edx
  80129b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80129e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a1:	01 c8                	add    %ecx,%eax
  8012a3:	8a 00                	mov    (%eax),%al
  8012a5:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8012a7:	ff 45 f8             	incl   -0x8(%ebp)
  8012aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012ad:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012b0:	7c d9                	jl     80128b <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8012b2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b8:	01 d0                	add    %edx,%eax
  8012ba:	c6 00 00             	movb   $0x0,(%eax)
}
  8012bd:	90                   	nop
  8012be:	c9                   	leave  
  8012bf:	c3                   	ret    

008012c0 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8012c0:	55                   	push   %ebp
  8012c1:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8012c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8012c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8012cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8012cf:	8b 00                	mov    (%eax),%eax
  8012d1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8012db:	01 d0                	add    %edx,%eax
  8012dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012e3:	eb 0c                	jmp    8012f1 <strsplit+0x31>
			*string++ = 0;
  8012e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e8:	8d 50 01             	lea    0x1(%eax),%edx
  8012eb:	89 55 08             	mov    %edx,0x8(%ebp)
  8012ee:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f4:	8a 00                	mov    (%eax),%al
  8012f6:	84 c0                	test   %al,%al
  8012f8:	74 18                	je     801312 <strsplit+0x52>
  8012fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fd:	8a 00                	mov    (%eax),%al
  8012ff:	0f be c0             	movsbl %al,%eax
  801302:	50                   	push   %eax
  801303:	ff 75 0c             	pushl  0xc(%ebp)
  801306:	e8 83 fa ff ff       	call   800d8e <strchr>
  80130b:	83 c4 08             	add    $0x8,%esp
  80130e:	85 c0                	test   %eax,%eax
  801310:	75 d3                	jne    8012e5 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801312:	8b 45 08             	mov    0x8(%ebp),%eax
  801315:	8a 00                	mov    (%eax),%al
  801317:	84 c0                	test   %al,%al
  801319:	74 5a                	je     801375 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80131b:	8b 45 14             	mov    0x14(%ebp),%eax
  80131e:	8b 00                	mov    (%eax),%eax
  801320:	83 f8 0f             	cmp    $0xf,%eax
  801323:	75 07                	jne    80132c <strsplit+0x6c>
		{
			return 0;
  801325:	b8 00 00 00 00       	mov    $0x0,%eax
  80132a:	eb 66                	jmp    801392 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80132c:	8b 45 14             	mov    0x14(%ebp),%eax
  80132f:	8b 00                	mov    (%eax),%eax
  801331:	8d 48 01             	lea    0x1(%eax),%ecx
  801334:	8b 55 14             	mov    0x14(%ebp),%edx
  801337:	89 0a                	mov    %ecx,(%edx)
  801339:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801340:	8b 45 10             	mov    0x10(%ebp),%eax
  801343:	01 c2                	add    %eax,%edx
  801345:	8b 45 08             	mov    0x8(%ebp),%eax
  801348:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80134a:	eb 03                	jmp    80134f <strsplit+0x8f>
			string++;
  80134c:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80134f:	8b 45 08             	mov    0x8(%ebp),%eax
  801352:	8a 00                	mov    (%eax),%al
  801354:	84 c0                	test   %al,%al
  801356:	74 8b                	je     8012e3 <strsplit+0x23>
  801358:	8b 45 08             	mov    0x8(%ebp),%eax
  80135b:	8a 00                	mov    (%eax),%al
  80135d:	0f be c0             	movsbl %al,%eax
  801360:	50                   	push   %eax
  801361:	ff 75 0c             	pushl  0xc(%ebp)
  801364:	e8 25 fa ff ff       	call   800d8e <strchr>
  801369:	83 c4 08             	add    $0x8,%esp
  80136c:	85 c0                	test   %eax,%eax
  80136e:	74 dc                	je     80134c <strsplit+0x8c>
			string++;
	}
  801370:	e9 6e ff ff ff       	jmp    8012e3 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801375:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801376:	8b 45 14             	mov    0x14(%ebp),%eax
  801379:	8b 00                	mov    (%eax),%eax
  80137b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801382:	8b 45 10             	mov    0x10(%ebp),%eax
  801385:	01 d0                	add    %edx,%eax
  801387:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80138d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801392:	c9                   	leave  
  801393:	c3                   	ret    

00801394 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801394:	55                   	push   %ebp
  801395:	89 e5                	mov    %esp,%ebp
  801397:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  80139a:	8b 45 08             	mov    0x8(%ebp),%eax
  80139d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8013a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013a7:	eb 4a                	jmp    8013f3 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8013a9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8013af:	01 c2                	add    %eax,%edx
  8013b1:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b7:	01 c8                	add    %ecx,%eax
  8013b9:	8a 00                	mov    (%eax),%al
  8013bb:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8013bd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c3:	01 d0                	add    %edx,%eax
  8013c5:	8a 00                	mov    (%eax),%al
  8013c7:	3c 40                	cmp    $0x40,%al
  8013c9:	7e 25                	jle    8013f0 <str2lower+0x5c>
  8013cb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d1:	01 d0                	add    %edx,%eax
  8013d3:	8a 00                	mov    (%eax),%al
  8013d5:	3c 5a                	cmp    $0x5a,%al
  8013d7:	7f 17                	jg     8013f0 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8013d9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013df:	01 d0                	add    %edx,%eax
  8013e1:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8013e7:	01 ca                	add    %ecx,%edx
  8013e9:	8a 12                	mov    (%edx),%dl
  8013eb:	83 c2 20             	add    $0x20,%edx
  8013ee:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8013f0:	ff 45 fc             	incl   -0x4(%ebp)
  8013f3:	ff 75 0c             	pushl  0xc(%ebp)
  8013f6:	e8 01 f8 ff ff       	call   800bfc <strlen>
  8013fb:	83 c4 04             	add    $0x4,%esp
  8013fe:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801401:	7f a6                	jg     8013a9 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801403:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801406:	c9                   	leave  
  801407:	c3                   	ret    

00801408 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801408:	55                   	push   %ebp
  801409:	89 e5                	mov    %esp,%ebp
  80140b:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  80140e:	a1 08 30 80 00       	mov    0x803008,%eax
  801413:	85 c0                	test   %eax,%eax
  801415:	74 42                	je     801459 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801417:	83 ec 08             	sub    $0x8,%esp
  80141a:	68 00 00 00 82       	push   $0x82000000
  80141f:	68 00 00 00 80       	push   $0x80000000
  801424:	e8 8c 07 00 00       	call   801bb5 <initialize_dynamic_allocator>
  801429:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  80142c:	e8 e7 05 00 00       	call   801a18 <sys_get_uheap_strategy>
  801431:	a3 60 b0 81 00       	mov    %eax,0x81b060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801436:	a1 40 30 80 00       	mov    0x803040,%eax
  80143b:	05 00 10 00 00       	add    $0x1000,%eax
  801440:	a3 10 b1 81 00       	mov    %eax,0x81b110
		uheapPageAllocBreak = uheapPageAllocStart;
  801445:	a1 10 b1 81 00       	mov    0x81b110,%eax
  80144a:	a3 68 b0 81 00       	mov    %eax,0x81b068

		__firstTimeFlag = 0;
  80144f:	c7 05 08 30 80 00 00 	movl   $0x0,0x803008
  801456:	00 00 00 
	}
}
  801459:	90                   	nop
  80145a:	c9                   	leave  
  80145b:	c3                   	ret    

0080145c <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  80145c:	55                   	push   %ebp
  80145d:	89 e5                	mov    %esp,%ebp
  80145f:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801462:	8b 45 08             	mov    0x8(%ebp),%eax
  801465:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801468:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80146b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801470:	83 ec 08             	sub    $0x8,%esp
  801473:	68 06 04 00 00       	push   $0x406
  801478:	50                   	push   %eax
  801479:	e8 e4 01 00 00       	call   801662 <__sys_allocate_page>
  80147e:	83 c4 10             	add    $0x10,%esp
  801481:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801484:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801488:	79 14                	jns    80149e <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  80148a:	83 ec 04             	sub    $0x4,%esp
  80148d:	68 88 28 80 00       	push   $0x802888
  801492:	6a 1f                	push   $0x1f
  801494:	68 c4 28 80 00       	push   $0x8028c4
  801499:	e8 4c 0a 00 00       	call   801eea <_panic>
	return 0;
  80149e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014a3:	c9                   	leave  
  8014a4:	c3                   	ret    

008014a5 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  8014a5:	55                   	push   %ebp
  8014a6:	89 e5                	mov    %esp,%ebp
  8014a8:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  8014ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014b4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014b9:	83 ec 0c             	sub    $0xc,%esp
  8014bc:	50                   	push   %eax
  8014bd:	e8 e7 01 00 00       	call   8016a9 <__sys_unmap_frame>
  8014c2:	83 c4 10             	add    $0x10,%esp
  8014c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8014c8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8014cc:	79 14                	jns    8014e2 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  8014ce:	83 ec 04             	sub    $0x4,%esp
  8014d1:	68 d0 28 80 00       	push   $0x8028d0
  8014d6:	6a 2a                	push   $0x2a
  8014d8:	68 c4 28 80 00       	push   $0x8028c4
  8014dd:	e8 08 0a 00 00       	call   801eea <_panic>
}
  8014e2:	90                   	nop
  8014e3:	c9                   	leave  
  8014e4:	c3                   	ret    

008014e5 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  8014e5:	55                   	push   %ebp
  8014e6:	89 e5                	mov    %esp,%ebp
  8014e8:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8014eb:	e8 18 ff ff ff       	call   801408 <uheap_init>
	if (size == 0) return NULL ;
  8014f0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014f4:	75 07                	jne    8014fd <malloc+0x18>
  8014f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8014fb:	eb 14                	jmp    801511 <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  8014fd:	83 ec 04             	sub    $0x4,%esp
  801500:	68 10 29 80 00       	push   $0x802910
  801505:	6a 3e                	push   $0x3e
  801507:	68 c4 28 80 00       	push   $0x8028c4
  80150c:	e8 d9 09 00 00       	call   801eea <_panic>
}
  801511:	c9                   	leave  
  801512:	c3                   	ret    

00801513 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801513:	55                   	push   %ebp
  801514:	89 e5                	mov    %esp,%ebp
  801516:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  801519:	83 ec 04             	sub    $0x4,%esp
  80151c:	68 38 29 80 00       	push   $0x802938
  801521:	6a 49                	push   $0x49
  801523:	68 c4 28 80 00       	push   $0x8028c4
  801528:	e8 bd 09 00 00       	call   801eea <_panic>

0080152d <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80152d:	55                   	push   %ebp
  80152e:	89 e5                	mov    %esp,%ebp
  801530:	83 ec 18             	sub    $0x18,%esp
  801533:	8b 45 10             	mov    0x10(%ebp),%eax
  801536:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801539:	e8 ca fe ff ff       	call   801408 <uheap_init>
	if (size == 0) return NULL ;
  80153e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801542:	75 07                	jne    80154b <smalloc+0x1e>
  801544:	b8 00 00 00 00       	mov    $0x0,%eax
  801549:	eb 14                	jmp    80155f <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  80154b:	83 ec 04             	sub    $0x4,%esp
  80154e:	68 5c 29 80 00       	push   $0x80295c
  801553:	6a 5a                	push   $0x5a
  801555:	68 c4 28 80 00       	push   $0x8028c4
  80155a:	e8 8b 09 00 00       	call   801eea <_panic>
}
  80155f:	c9                   	leave  
  801560:	c3                   	ret    

00801561 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801561:	55                   	push   %ebp
  801562:	89 e5                	mov    %esp,%ebp
  801564:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801567:	e8 9c fe ff ff       	call   801408 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  80156c:	83 ec 04             	sub    $0x4,%esp
  80156f:	68 84 29 80 00       	push   $0x802984
  801574:	6a 6a                	push   $0x6a
  801576:	68 c4 28 80 00       	push   $0x8028c4
  80157b:	e8 6a 09 00 00       	call   801eea <_panic>

00801580 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801580:	55                   	push   %ebp
  801581:	89 e5                	mov    %esp,%ebp
  801583:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801586:	e8 7d fe ff ff       	call   801408 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  80158b:	83 ec 04             	sub    $0x4,%esp
  80158e:	68 a8 29 80 00       	push   $0x8029a8
  801593:	68 88 00 00 00       	push   $0x88
  801598:	68 c4 28 80 00       	push   $0x8028c4
  80159d:	e8 48 09 00 00       	call   801eea <_panic>

008015a2 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  8015a2:	55                   	push   %ebp
  8015a3:	89 e5                	mov    %esp,%ebp
  8015a5:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  8015a8:	83 ec 04             	sub    $0x4,%esp
  8015ab:	68 d0 29 80 00       	push   $0x8029d0
  8015b0:	68 9b 00 00 00       	push   $0x9b
  8015b5:	68 c4 28 80 00       	push   $0x8028c4
  8015ba:	e8 2b 09 00 00       	call   801eea <_panic>

008015bf <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8015bf:	55                   	push   %ebp
  8015c0:	89 e5                	mov    %esp,%ebp
  8015c2:	57                   	push   %edi
  8015c3:	56                   	push   %esi
  8015c4:	53                   	push   %ebx
  8015c5:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015ce:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015d1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8015d4:	8b 7d 18             	mov    0x18(%ebp),%edi
  8015d7:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8015da:	cd 30                	int    $0x30
  8015dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8015df:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8015e2:	83 c4 10             	add    $0x10,%esp
  8015e5:	5b                   	pop    %ebx
  8015e6:	5e                   	pop    %esi
  8015e7:	5f                   	pop    %edi
  8015e8:	5d                   	pop    %ebp
  8015e9:	c3                   	ret    

008015ea <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8015ea:	55                   	push   %ebp
  8015eb:	89 e5                	mov    %esp,%ebp
  8015ed:	83 ec 04             	sub    $0x4,%esp
  8015f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8015f3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8015f6:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8015f9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8015fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801600:	6a 00                	push   $0x0
  801602:	51                   	push   %ecx
  801603:	52                   	push   %edx
  801604:	ff 75 0c             	pushl  0xc(%ebp)
  801607:	50                   	push   %eax
  801608:	6a 00                	push   $0x0
  80160a:	e8 b0 ff ff ff       	call   8015bf <syscall>
  80160f:	83 c4 18             	add    $0x18,%esp
}
  801612:	90                   	nop
  801613:	c9                   	leave  
  801614:	c3                   	ret    

00801615 <sys_cgetc>:

int
sys_cgetc(void)
{
  801615:	55                   	push   %ebp
  801616:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801618:	6a 00                	push   $0x0
  80161a:	6a 00                	push   $0x0
  80161c:	6a 00                	push   $0x0
  80161e:	6a 00                	push   $0x0
  801620:	6a 00                	push   $0x0
  801622:	6a 02                	push   $0x2
  801624:	e8 96 ff ff ff       	call   8015bf <syscall>
  801629:	83 c4 18             	add    $0x18,%esp
}
  80162c:	c9                   	leave  
  80162d:	c3                   	ret    

0080162e <sys_lock_cons>:

void sys_lock_cons(void)
{
  80162e:	55                   	push   %ebp
  80162f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801631:	6a 00                	push   $0x0
  801633:	6a 00                	push   $0x0
  801635:	6a 00                	push   $0x0
  801637:	6a 00                	push   $0x0
  801639:	6a 00                	push   $0x0
  80163b:	6a 03                	push   $0x3
  80163d:	e8 7d ff ff ff       	call   8015bf <syscall>
  801642:	83 c4 18             	add    $0x18,%esp
}
  801645:	90                   	nop
  801646:	c9                   	leave  
  801647:	c3                   	ret    

00801648 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801648:	55                   	push   %ebp
  801649:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80164b:	6a 00                	push   $0x0
  80164d:	6a 00                	push   $0x0
  80164f:	6a 00                	push   $0x0
  801651:	6a 00                	push   $0x0
  801653:	6a 00                	push   $0x0
  801655:	6a 04                	push   $0x4
  801657:	e8 63 ff ff ff       	call   8015bf <syscall>
  80165c:	83 c4 18             	add    $0x18,%esp
}
  80165f:	90                   	nop
  801660:	c9                   	leave  
  801661:	c3                   	ret    

00801662 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801662:	55                   	push   %ebp
  801663:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801665:	8b 55 0c             	mov    0xc(%ebp),%edx
  801668:	8b 45 08             	mov    0x8(%ebp),%eax
  80166b:	6a 00                	push   $0x0
  80166d:	6a 00                	push   $0x0
  80166f:	6a 00                	push   $0x0
  801671:	52                   	push   %edx
  801672:	50                   	push   %eax
  801673:	6a 08                	push   $0x8
  801675:	e8 45 ff ff ff       	call   8015bf <syscall>
  80167a:	83 c4 18             	add    $0x18,%esp
}
  80167d:	c9                   	leave  
  80167e:	c3                   	ret    

0080167f <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80167f:	55                   	push   %ebp
  801680:	89 e5                	mov    %esp,%ebp
  801682:	56                   	push   %esi
  801683:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801684:	8b 75 18             	mov    0x18(%ebp),%esi
  801687:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80168a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80168d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801690:	8b 45 08             	mov    0x8(%ebp),%eax
  801693:	56                   	push   %esi
  801694:	53                   	push   %ebx
  801695:	51                   	push   %ecx
  801696:	52                   	push   %edx
  801697:	50                   	push   %eax
  801698:	6a 09                	push   $0x9
  80169a:	e8 20 ff ff ff       	call   8015bf <syscall>
  80169f:	83 c4 18             	add    $0x18,%esp
}
  8016a2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016a5:	5b                   	pop    %ebx
  8016a6:	5e                   	pop    %esi
  8016a7:	5d                   	pop    %ebp
  8016a8:	c3                   	ret    

008016a9 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8016a9:	55                   	push   %ebp
  8016aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8016ac:	6a 00                	push   $0x0
  8016ae:	6a 00                	push   $0x0
  8016b0:	6a 00                	push   $0x0
  8016b2:	6a 00                	push   $0x0
  8016b4:	ff 75 08             	pushl  0x8(%ebp)
  8016b7:	6a 0a                	push   $0xa
  8016b9:	e8 01 ff ff ff       	call   8015bf <syscall>
  8016be:	83 c4 18             	add    $0x18,%esp
}
  8016c1:	c9                   	leave  
  8016c2:	c3                   	ret    

008016c3 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8016c3:	55                   	push   %ebp
  8016c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8016c6:	6a 00                	push   $0x0
  8016c8:	6a 00                	push   $0x0
  8016ca:	6a 00                	push   $0x0
  8016cc:	ff 75 0c             	pushl  0xc(%ebp)
  8016cf:	ff 75 08             	pushl  0x8(%ebp)
  8016d2:	6a 0b                	push   $0xb
  8016d4:	e8 e6 fe ff ff       	call   8015bf <syscall>
  8016d9:	83 c4 18             	add    $0x18,%esp
}
  8016dc:	c9                   	leave  
  8016dd:	c3                   	ret    

008016de <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8016de:	55                   	push   %ebp
  8016df:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8016e1:	6a 00                	push   $0x0
  8016e3:	6a 00                	push   $0x0
  8016e5:	6a 00                	push   $0x0
  8016e7:	6a 00                	push   $0x0
  8016e9:	6a 00                	push   $0x0
  8016eb:	6a 0c                	push   $0xc
  8016ed:	e8 cd fe ff ff       	call   8015bf <syscall>
  8016f2:	83 c4 18             	add    $0x18,%esp
}
  8016f5:	c9                   	leave  
  8016f6:	c3                   	ret    

008016f7 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8016f7:	55                   	push   %ebp
  8016f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8016fa:	6a 00                	push   $0x0
  8016fc:	6a 00                	push   $0x0
  8016fe:	6a 00                	push   $0x0
  801700:	6a 00                	push   $0x0
  801702:	6a 00                	push   $0x0
  801704:	6a 0d                	push   $0xd
  801706:	e8 b4 fe ff ff       	call   8015bf <syscall>
  80170b:	83 c4 18             	add    $0x18,%esp
}
  80170e:	c9                   	leave  
  80170f:	c3                   	ret    

00801710 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801710:	55                   	push   %ebp
  801711:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801713:	6a 00                	push   $0x0
  801715:	6a 00                	push   $0x0
  801717:	6a 00                	push   $0x0
  801719:	6a 00                	push   $0x0
  80171b:	6a 00                	push   $0x0
  80171d:	6a 0e                	push   $0xe
  80171f:	e8 9b fe ff ff       	call   8015bf <syscall>
  801724:	83 c4 18             	add    $0x18,%esp
}
  801727:	c9                   	leave  
  801728:	c3                   	ret    

00801729 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801729:	55                   	push   %ebp
  80172a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80172c:	6a 00                	push   $0x0
  80172e:	6a 00                	push   $0x0
  801730:	6a 00                	push   $0x0
  801732:	6a 00                	push   $0x0
  801734:	6a 00                	push   $0x0
  801736:	6a 0f                	push   $0xf
  801738:	e8 82 fe ff ff       	call   8015bf <syscall>
  80173d:	83 c4 18             	add    $0x18,%esp
}
  801740:	c9                   	leave  
  801741:	c3                   	ret    

00801742 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801742:	55                   	push   %ebp
  801743:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801745:	6a 00                	push   $0x0
  801747:	6a 00                	push   $0x0
  801749:	6a 00                	push   $0x0
  80174b:	6a 00                	push   $0x0
  80174d:	ff 75 08             	pushl  0x8(%ebp)
  801750:	6a 10                	push   $0x10
  801752:	e8 68 fe ff ff       	call   8015bf <syscall>
  801757:	83 c4 18             	add    $0x18,%esp
}
  80175a:	c9                   	leave  
  80175b:	c3                   	ret    

0080175c <sys_scarce_memory>:

void sys_scarce_memory()
{
  80175c:	55                   	push   %ebp
  80175d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80175f:	6a 00                	push   $0x0
  801761:	6a 00                	push   $0x0
  801763:	6a 00                	push   $0x0
  801765:	6a 00                	push   $0x0
  801767:	6a 00                	push   $0x0
  801769:	6a 11                	push   $0x11
  80176b:	e8 4f fe ff ff       	call   8015bf <syscall>
  801770:	83 c4 18             	add    $0x18,%esp
}
  801773:	90                   	nop
  801774:	c9                   	leave  
  801775:	c3                   	ret    

00801776 <sys_cputc>:

void
sys_cputc(const char c)
{
  801776:	55                   	push   %ebp
  801777:	89 e5                	mov    %esp,%ebp
  801779:	83 ec 04             	sub    $0x4,%esp
  80177c:	8b 45 08             	mov    0x8(%ebp),%eax
  80177f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801782:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801786:	6a 00                	push   $0x0
  801788:	6a 00                	push   $0x0
  80178a:	6a 00                	push   $0x0
  80178c:	6a 00                	push   $0x0
  80178e:	50                   	push   %eax
  80178f:	6a 01                	push   $0x1
  801791:	e8 29 fe ff ff       	call   8015bf <syscall>
  801796:	83 c4 18             	add    $0x18,%esp
}
  801799:	90                   	nop
  80179a:	c9                   	leave  
  80179b:	c3                   	ret    

0080179c <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80179c:	55                   	push   %ebp
  80179d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80179f:	6a 00                	push   $0x0
  8017a1:	6a 00                	push   $0x0
  8017a3:	6a 00                	push   $0x0
  8017a5:	6a 00                	push   $0x0
  8017a7:	6a 00                	push   $0x0
  8017a9:	6a 14                	push   $0x14
  8017ab:	e8 0f fe ff ff       	call   8015bf <syscall>
  8017b0:	83 c4 18             	add    $0x18,%esp
}
  8017b3:	90                   	nop
  8017b4:	c9                   	leave  
  8017b5:	c3                   	ret    

008017b6 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8017b6:	55                   	push   %ebp
  8017b7:	89 e5                	mov    %esp,%ebp
  8017b9:	83 ec 04             	sub    $0x4,%esp
  8017bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8017bf:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8017c2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8017c5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cc:	6a 00                	push   $0x0
  8017ce:	51                   	push   %ecx
  8017cf:	52                   	push   %edx
  8017d0:	ff 75 0c             	pushl  0xc(%ebp)
  8017d3:	50                   	push   %eax
  8017d4:	6a 15                	push   $0x15
  8017d6:	e8 e4 fd ff ff       	call   8015bf <syscall>
  8017db:	83 c4 18             	add    $0x18,%esp
}
  8017de:	c9                   	leave  
  8017df:	c3                   	ret    

008017e0 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8017e0:	55                   	push   %ebp
  8017e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8017e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e9:	6a 00                	push   $0x0
  8017eb:	6a 00                	push   $0x0
  8017ed:	6a 00                	push   $0x0
  8017ef:	52                   	push   %edx
  8017f0:	50                   	push   %eax
  8017f1:	6a 16                	push   $0x16
  8017f3:	e8 c7 fd ff ff       	call   8015bf <syscall>
  8017f8:	83 c4 18             	add    $0x18,%esp
}
  8017fb:	c9                   	leave  
  8017fc:	c3                   	ret    

008017fd <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8017fd:	55                   	push   %ebp
  8017fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801800:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801803:	8b 55 0c             	mov    0xc(%ebp),%edx
  801806:	8b 45 08             	mov    0x8(%ebp),%eax
  801809:	6a 00                	push   $0x0
  80180b:	6a 00                	push   $0x0
  80180d:	51                   	push   %ecx
  80180e:	52                   	push   %edx
  80180f:	50                   	push   %eax
  801810:	6a 17                	push   $0x17
  801812:	e8 a8 fd ff ff       	call   8015bf <syscall>
  801817:	83 c4 18             	add    $0x18,%esp
}
  80181a:	c9                   	leave  
  80181b:	c3                   	ret    

0080181c <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  80181c:	55                   	push   %ebp
  80181d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80181f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801822:	8b 45 08             	mov    0x8(%ebp),%eax
  801825:	6a 00                	push   $0x0
  801827:	6a 00                	push   $0x0
  801829:	6a 00                	push   $0x0
  80182b:	52                   	push   %edx
  80182c:	50                   	push   %eax
  80182d:	6a 18                	push   $0x18
  80182f:	e8 8b fd ff ff       	call   8015bf <syscall>
  801834:	83 c4 18             	add    $0x18,%esp
}
  801837:	c9                   	leave  
  801838:	c3                   	ret    

00801839 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801839:	55                   	push   %ebp
  80183a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80183c:	8b 45 08             	mov    0x8(%ebp),%eax
  80183f:	6a 00                	push   $0x0
  801841:	ff 75 14             	pushl  0x14(%ebp)
  801844:	ff 75 10             	pushl  0x10(%ebp)
  801847:	ff 75 0c             	pushl  0xc(%ebp)
  80184a:	50                   	push   %eax
  80184b:	6a 19                	push   $0x19
  80184d:	e8 6d fd ff ff       	call   8015bf <syscall>
  801852:	83 c4 18             	add    $0x18,%esp
}
  801855:	c9                   	leave  
  801856:	c3                   	ret    

00801857 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801857:	55                   	push   %ebp
  801858:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80185a:	8b 45 08             	mov    0x8(%ebp),%eax
  80185d:	6a 00                	push   $0x0
  80185f:	6a 00                	push   $0x0
  801861:	6a 00                	push   $0x0
  801863:	6a 00                	push   $0x0
  801865:	50                   	push   %eax
  801866:	6a 1a                	push   $0x1a
  801868:	e8 52 fd ff ff       	call   8015bf <syscall>
  80186d:	83 c4 18             	add    $0x18,%esp
}
  801870:	90                   	nop
  801871:	c9                   	leave  
  801872:	c3                   	ret    

00801873 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801873:	55                   	push   %ebp
  801874:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801876:	8b 45 08             	mov    0x8(%ebp),%eax
  801879:	6a 00                	push   $0x0
  80187b:	6a 00                	push   $0x0
  80187d:	6a 00                	push   $0x0
  80187f:	6a 00                	push   $0x0
  801881:	50                   	push   %eax
  801882:	6a 1b                	push   $0x1b
  801884:	e8 36 fd ff ff       	call   8015bf <syscall>
  801889:	83 c4 18             	add    $0x18,%esp
}
  80188c:	c9                   	leave  
  80188d:	c3                   	ret    

0080188e <sys_getenvid>:

int32 sys_getenvid(void)
{
  80188e:	55                   	push   %ebp
  80188f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801891:	6a 00                	push   $0x0
  801893:	6a 00                	push   $0x0
  801895:	6a 00                	push   $0x0
  801897:	6a 00                	push   $0x0
  801899:	6a 00                	push   $0x0
  80189b:	6a 05                	push   $0x5
  80189d:	e8 1d fd ff ff       	call   8015bf <syscall>
  8018a2:	83 c4 18             	add    $0x18,%esp
}
  8018a5:	c9                   	leave  
  8018a6:	c3                   	ret    

008018a7 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8018a7:	55                   	push   %ebp
  8018a8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8018aa:	6a 00                	push   $0x0
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 00                	push   $0x0
  8018b0:	6a 00                	push   $0x0
  8018b2:	6a 00                	push   $0x0
  8018b4:	6a 06                	push   $0x6
  8018b6:	e8 04 fd ff ff       	call   8015bf <syscall>
  8018bb:	83 c4 18             	add    $0x18,%esp
}
  8018be:	c9                   	leave  
  8018bf:	c3                   	ret    

008018c0 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8018c0:	55                   	push   %ebp
  8018c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8018c3:	6a 00                	push   $0x0
  8018c5:	6a 00                	push   $0x0
  8018c7:	6a 00                	push   $0x0
  8018c9:	6a 00                	push   $0x0
  8018cb:	6a 00                	push   $0x0
  8018cd:	6a 07                	push   $0x7
  8018cf:	e8 eb fc ff ff       	call   8015bf <syscall>
  8018d4:	83 c4 18             	add    $0x18,%esp
}
  8018d7:	c9                   	leave  
  8018d8:	c3                   	ret    

008018d9 <sys_exit_env>:


void sys_exit_env(void)
{
  8018d9:	55                   	push   %ebp
  8018da:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8018dc:	6a 00                	push   $0x0
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 00                	push   $0x0
  8018e6:	6a 1c                	push   $0x1c
  8018e8:	e8 d2 fc ff ff       	call   8015bf <syscall>
  8018ed:	83 c4 18             	add    $0x18,%esp
}
  8018f0:	90                   	nop
  8018f1:	c9                   	leave  
  8018f2:	c3                   	ret    

008018f3 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8018f3:	55                   	push   %ebp
  8018f4:	89 e5                	mov    %esp,%ebp
  8018f6:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8018f9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8018fc:	8d 50 04             	lea    0x4(%eax),%edx
  8018ff:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801902:	6a 00                	push   $0x0
  801904:	6a 00                	push   $0x0
  801906:	6a 00                	push   $0x0
  801908:	52                   	push   %edx
  801909:	50                   	push   %eax
  80190a:	6a 1d                	push   $0x1d
  80190c:	e8 ae fc ff ff       	call   8015bf <syscall>
  801911:	83 c4 18             	add    $0x18,%esp
	return result;
  801914:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801917:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80191a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80191d:	89 01                	mov    %eax,(%ecx)
  80191f:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801922:	8b 45 08             	mov    0x8(%ebp),%eax
  801925:	c9                   	leave  
  801926:	c2 04 00             	ret    $0x4

00801929 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801929:	55                   	push   %ebp
  80192a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80192c:	6a 00                	push   $0x0
  80192e:	6a 00                	push   $0x0
  801930:	ff 75 10             	pushl  0x10(%ebp)
  801933:	ff 75 0c             	pushl  0xc(%ebp)
  801936:	ff 75 08             	pushl  0x8(%ebp)
  801939:	6a 13                	push   $0x13
  80193b:	e8 7f fc ff ff       	call   8015bf <syscall>
  801940:	83 c4 18             	add    $0x18,%esp
	return ;
  801943:	90                   	nop
}
  801944:	c9                   	leave  
  801945:	c3                   	ret    

00801946 <sys_rcr2>:
uint32 sys_rcr2()
{
  801946:	55                   	push   %ebp
  801947:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801949:	6a 00                	push   $0x0
  80194b:	6a 00                	push   $0x0
  80194d:	6a 00                	push   $0x0
  80194f:	6a 00                	push   $0x0
  801951:	6a 00                	push   $0x0
  801953:	6a 1e                	push   $0x1e
  801955:	e8 65 fc ff ff       	call   8015bf <syscall>
  80195a:	83 c4 18             	add    $0x18,%esp
}
  80195d:	c9                   	leave  
  80195e:	c3                   	ret    

0080195f <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80195f:	55                   	push   %ebp
  801960:	89 e5                	mov    %esp,%ebp
  801962:	83 ec 04             	sub    $0x4,%esp
  801965:	8b 45 08             	mov    0x8(%ebp),%eax
  801968:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80196b:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80196f:	6a 00                	push   $0x0
  801971:	6a 00                	push   $0x0
  801973:	6a 00                	push   $0x0
  801975:	6a 00                	push   $0x0
  801977:	50                   	push   %eax
  801978:	6a 1f                	push   $0x1f
  80197a:	e8 40 fc ff ff       	call   8015bf <syscall>
  80197f:	83 c4 18             	add    $0x18,%esp
	return ;
  801982:	90                   	nop
}
  801983:	c9                   	leave  
  801984:	c3                   	ret    

00801985 <rsttst>:
void rsttst()
{
  801985:	55                   	push   %ebp
  801986:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801988:	6a 00                	push   $0x0
  80198a:	6a 00                	push   $0x0
  80198c:	6a 00                	push   $0x0
  80198e:	6a 00                	push   $0x0
  801990:	6a 00                	push   $0x0
  801992:	6a 21                	push   $0x21
  801994:	e8 26 fc ff ff       	call   8015bf <syscall>
  801999:	83 c4 18             	add    $0x18,%esp
	return ;
  80199c:	90                   	nop
}
  80199d:	c9                   	leave  
  80199e:	c3                   	ret    

0080199f <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80199f:	55                   	push   %ebp
  8019a0:	89 e5                	mov    %esp,%ebp
  8019a2:	83 ec 04             	sub    $0x4,%esp
  8019a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8019a8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8019ab:	8b 55 18             	mov    0x18(%ebp),%edx
  8019ae:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019b2:	52                   	push   %edx
  8019b3:	50                   	push   %eax
  8019b4:	ff 75 10             	pushl  0x10(%ebp)
  8019b7:	ff 75 0c             	pushl  0xc(%ebp)
  8019ba:	ff 75 08             	pushl  0x8(%ebp)
  8019bd:	6a 20                	push   $0x20
  8019bf:	e8 fb fb ff ff       	call   8015bf <syscall>
  8019c4:	83 c4 18             	add    $0x18,%esp
	return ;
  8019c7:	90                   	nop
}
  8019c8:	c9                   	leave  
  8019c9:	c3                   	ret    

008019ca <chktst>:
void chktst(uint32 n)
{
  8019ca:	55                   	push   %ebp
  8019cb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 00                	push   $0x0
  8019d5:	ff 75 08             	pushl  0x8(%ebp)
  8019d8:	6a 22                	push   $0x22
  8019da:	e8 e0 fb ff ff       	call   8015bf <syscall>
  8019df:	83 c4 18             	add    $0x18,%esp
	return ;
  8019e2:	90                   	nop
}
  8019e3:	c9                   	leave  
  8019e4:	c3                   	ret    

008019e5 <inctst>:

void inctst()
{
  8019e5:	55                   	push   %ebp
  8019e6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 00                	push   $0x0
  8019ec:	6a 00                	push   $0x0
  8019ee:	6a 00                	push   $0x0
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 23                	push   $0x23
  8019f4:	e8 c6 fb ff ff       	call   8015bf <syscall>
  8019f9:	83 c4 18             	add    $0x18,%esp
	return ;
  8019fc:	90                   	nop
}
  8019fd:	c9                   	leave  
  8019fe:	c3                   	ret    

008019ff <gettst>:
uint32 gettst()
{
  8019ff:	55                   	push   %ebp
  801a00:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801a02:	6a 00                	push   $0x0
  801a04:	6a 00                	push   $0x0
  801a06:	6a 00                	push   $0x0
  801a08:	6a 00                	push   $0x0
  801a0a:	6a 00                	push   $0x0
  801a0c:	6a 24                	push   $0x24
  801a0e:	e8 ac fb ff ff       	call   8015bf <syscall>
  801a13:	83 c4 18             	add    $0x18,%esp
}
  801a16:	c9                   	leave  
  801a17:	c3                   	ret    

00801a18 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801a18:	55                   	push   %ebp
  801a19:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 00                	push   $0x0
  801a23:	6a 00                	push   $0x0
  801a25:	6a 25                	push   $0x25
  801a27:	e8 93 fb ff ff       	call   8015bf <syscall>
  801a2c:	83 c4 18             	add    $0x18,%esp
  801a2f:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801a34:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801a39:	c9                   	leave  
  801a3a:	c3                   	ret    

00801a3b <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801a3b:	55                   	push   %ebp
  801a3c:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a41:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801a46:	6a 00                	push   $0x0
  801a48:	6a 00                	push   $0x0
  801a4a:	6a 00                	push   $0x0
  801a4c:	6a 00                	push   $0x0
  801a4e:	ff 75 08             	pushl  0x8(%ebp)
  801a51:	6a 26                	push   $0x26
  801a53:	e8 67 fb ff ff       	call   8015bf <syscall>
  801a58:	83 c4 18             	add    $0x18,%esp
	return ;
  801a5b:	90                   	nop
}
  801a5c:	c9                   	leave  
  801a5d:	c3                   	ret    

00801a5e <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801a5e:	55                   	push   %ebp
  801a5f:	89 e5                	mov    %esp,%ebp
  801a61:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801a62:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a65:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a68:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6e:	6a 00                	push   $0x0
  801a70:	53                   	push   %ebx
  801a71:	51                   	push   %ecx
  801a72:	52                   	push   %edx
  801a73:	50                   	push   %eax
  801a74:	6a 27                	push   $0x27
  801a76:	e8 44 fb ff ff       	call   8015bf <syscall>
  801a7b:	83 c4 18             	add    $0x18,%esp
}
  801a7e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a81:	c9                   	leave  
  801a82:	c3                   	ret    

00801a83 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801a83:	55                   	push   %ebp
  801a84:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801a86:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a89:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 00                	push   $0x0
  801a92:	52                   	push   %edx
  801a93:	50                   	push   %eax
  801a94:	6a 28                	push   $0x28
  801a96:	e8 24 fb ff ff       	call   8015bf <syscall>
  801a9b:	83 c4 18             	add    $0x18,%esp
}
  801a9e:	c9                   	leave  
  801a9f:	c3                   	ret    

00801aa0 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801aa0:	55                   	push   %ebp
  801aa1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801aa3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801aa6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  801aac:	6a 00                	push   $0x0
  801aae:	51                   	push   %ecx
  801aaf:	ff 75 10             	pushl  0x10(%ebp)
  801ab2:	52                   	push   %edx
  801ab3:	50                   	push   %eax
  801ab4:	6a 29                	push   $0x29
  801ab6:	e8 04 fb ff ff       	call   8015bf <syscall>
  801abb:	83 c4 18             	add    $0x18,%esp
}
  801abe:	c9                   	leave  
  801abf:	c3                   	ret    

00801ac0 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801ac0:	55                   	push   %ebp
  801ac1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	ff 75 10             	pushl  0x10(%ebp)
  801aca:	ff 75 0c             	pushl  0xc(%ebp)
  801acd:	ff 75 08             	pushl  0x8(%ebp)
  801ad0:	6a 12                	push   $0x12
  801ad2:	e8 e8 fa ff ff       	call   8015bf <syscall>
  801ad7:	83 c4 18             	add    $0x18,%esp
	return ;
  801ada:	90                   	nop
}
  801adb:	c9                   	leave  
  801adc:	c3                   	ret    

00801add <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801add:	55                   	push   %ebp
  801ade:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801ae0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae6:	6a 00                	push   $0x0
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 00                	push   $0x0
  801aec:	52                   	push   %edx
  801aed:	50                   	push   %eax
  801aee:	6a 2a                	push   $0x2a
  801af0:	e8 ca fa ff ff       	call   8015bf <syscall>
  801af5:	83 c4 18             	add    $0x18,%esp
	return;
  801af8:	90                   	nop
}
  801af9:	c9                   	leave  
  801afa:	c3                   	ret    

00801afb <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801afb:	55                   	push   %ebp
  801afc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801afe:	6a 00                	push   $0x0
  801b00:	6a 00                	push   $0x0
  801b02:	6a 00                	push   $0x0
  801b04:	6a 00                	push   $0x0
  801b06:	6a 00                	push   $0x0
  801b08:	6a 2b                	push   $0x2b
  801b0a:	e8 b0 fa ff ff       	call   8015bf <syscall>
  801b0f:	83 c4 18             	add    $0x18,%esp
}
  801b12:	c9                   	leave  
  801b13:	c3                   	ret    

00801b14 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b14:	55                   	push   %ebp
  801b15:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801b17:	6a 00                	push   $0x0
  801b19:	6a 00                	push   $0x0
  801b1b:	6a 00                	push   $0x0
  801b1d:	ff 75 0c             	pushl  0xc(%ebp)
  801b20:	ff 75 08             	pushl  0x8(%ebp)
  801b23:	6a 2d                	push   $0x2d
  801b25:	e8 95 fa ff ff       	call   8015bf <syscall>
  801b2a:	83 c4 18             	add    $0x18,%esp
	return;
  801b2d:	90                   	nop
}
  801b2e:	c9                   	leave  
  801b2f:	c3                   	ret    

00801b30 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801b30:	55                   	push   %ebp
  801b31:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801b33:	6a 00                	push   $0x0
  801b35:	6a 00                	push   $0x0
  801b37:	6a 00                	push   $0x0
  801b39:	ff 75 0c             	pushl  0xc(%ebp)
  801b3c:	ff 75 08             	pushl  0x8(%ebp)
  801b3f:	6a 2c                	push   $0x2c
  801b41:	e8 79 fa ff ff       	call   8015bf <syscall>
  801b46:	83 c4 18             	add    $0x18,%esp
	return ;
  801b49:	90                   	nop
}
  801b4a:	c9                   	leave  
  801b4b:	c3                   	ret    

00801b4c <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801b4c:	55                   	push   %ebp
  801b4d:	89 e5                	mov    %esp,%ebp
  801b4f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801b52:	83 ec 04             	sub    $0x4,%esp
  801b55:	68 f4 29 80 00       	push   $0x8029f4
  801b5a:	68 25 01 00 00       	push   $0x125
  801b5f:	68 27 2a 80 00       	push   $0x802a27
  801b64:	e8 81 03 00 00       	call   801eea <_panic>

00801b69 <to_page_va>:
//==================================================================================//
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  801b69:	55                   	push   %ebp
  801b6a:	89 e5                	mov    %esp,%ebp
  801b6c:	83 ec 10             	sub    $0x10,%esp
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  801b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b72:	ba 60 30 80 00       	mov    $0x803060,%edx
  801b77:	29 d0                	sub    %edx,%eax
  801b79:	c1 f8 02             	sar    $0x2,%eax
  801b7c:	89 c2                	mov    %eax,%edx
  801b7e:	89 d0                	mov    %edx,%eax
  801b80:	c1 e0 02             	shl    $0x2,%eax
  801b83:	01 d0                	add    %edx,%eax
  801b85:	c1 e0 02             	shl    $0x2,%eax
  801b88:	01 d0                	add    %edx,%eax
  801b8a:	c1 e0 02             	shl    $0x2,%eax
  801b8d:	01 d0                	add    %edx,%eax
  801b8f:	89 c1                	mov    %eax,%ecx
  801b91:	c1 e1 08             	shl    $0x8,%ecx
  801b94:	01 c8                	add    %ecx,%eax
  801b96:	89 c1                	mov    %eax,%ecx
  801b98:	c1 e1 10             	shl    $0x10,%ecx
  801b9b:	01 c8                	add    %ecx,%eax
  801b9d:	01 c0                	add    %eax,%eax
  801b9f:	01 d0                	add    %edx,%eax
  801ba1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  801ba4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ba7:	c1 e0 0c             	shl    $0xc,%eax
  801baa:	89 c2                	mov    %eax,%edx
  801bac:	a1 64 b0 81 00       	mov    0x81b064,%eax
  801bb1:	01 d0                	add    %edx,%eax
}
  801bb3:	c9                   	leave  
  801bb4:	c3                   	ret    

00801bb5 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  801bb5:	55                   	push   %ebp
  801bb6:	89 e5                	mov    %esp,%ebp
  801bb8:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  801bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbe:	05 00 00 00 02       	add    $0x2000000,%eax
  801bc3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801bc6:	73 16                	jae    801bde <initialize_dynamic_allocator+0x29>
  801bc8:	68 38 2a 80 00       	push   $0x802a38
  801bcd:	68 5e 2a 80 00       	push   $0x802a5e
  801bd2:	6a 26                	push   $0x26
  801bd4:	68 73 2a 80 00       	push   $0x802a73
  801bd9:	e8 0c 03 00 00       	call   801eea <_panic>
		is_initialized = 1;
  801bde:	c7 05 24 30 80 00 01 	movl   $0x1,0x803024
  801be5:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	//Comment the following line
	panic("initialize_dynamic_allocator() Not implemented yet");
  801be8:	83 ec 04             	sub    $0x4,%esp
  801beb:	68 8c 2a 80 00       	push   $0x802a8c
  801bf0:	6a 2e                	push   $0x2e
  801bf2:	68 73 2a 80 00       	push   $0x802a73
  801bf7:	e8 ee 02 00 00       	call   801eea <_panic>

00801bfc <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  801bfc:	55                   	push   %ebp
  801bfd:	89 e5                	mov    %esp,%ebp
  801bff:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	//Comment the following line
	panic("get_block_size() Not implemented yet");
  801c02:	83 ec 04             	sub    $0x4,%esp
  801c05:	68 c0 2a 80 00       	push   $0x802ac0
  801c0a:	6a 3a                	push   $0x3a
  801c0c:	68 73 2a 80 00       	push   $0x802a73
  801c11:	e8 d4 02 00 00       	call   801eea <_panic>

00801c16 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  801c16:	55                   	push   %ebp
  801c17:	89 e5                	mov    %esp,%ebp
  801c19:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  801c1c:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801c23:	76 16                	jbe    801c3b <alloc_block+0x25>
  801c25:	68 e8 2a 80 00       	push   $0x802ae8
  801c2a:	68 5e 2a 80 00       	push   $0x802a5e
  801c2f:	6a 46                	push   $0x46
  801c31:	68 73 2a 80 00       	push   $0x802a73
  801c36:	e8 af 02 00 00       	call   801eea <_panic>
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	panic("alloc_block() Not implemented yet");
  801c3b:	83 ec 04             	sub    $0x4,%esp
  801c3e:	68 0c 2b 80 00       	push   $0x802b0c
  801c43:	6a 4d                	push   $0x4d
  801c45:	68 73 2a 80 00       	push   $0x802a73
  801c4a:	e8 9b 02 00 00       	call   801eea <_panic>

00801c4f <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  801c4f:	55                   	push   %ebp
  801c50:	89 e5                	mov    %esp,%ebp
  801c52:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  801c55:	8b 55 08             	mov    0x8(%ebp),%edx
  801c58:	a1 64 b0 81 00       	mov    0x81b064,%eax
  801c5d:	39 c2                	cmp    %eax,%edx
  801c5f:	72 0c                	jb     801c6d <free_block+0x1e>
  801c61:	8b 55 08             	mov    0x8(%ebp),%edx
  801c64:	a1 40 30 80 00       	mov    0x803040,%eax
  801c69:	39 c2                	cmp    %eax,%edx
  801c6b:	72 16                	jb     801c83 <free_block+0x34>
  801c6d:	68 30 2b 80 00       	push   $0x802b30
  801c72:	68 5e 2a 80 00       	push   $0x802a5e
  801c77:	6a 5b                	push   $0x5b
  801c79:	68 73 2a 80 00       	push   $0x802a73
  801c7e:	e8 67 02 00 00       	call   801eea <_panic>
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	panic("free_block() Not implemented yet");
  801c83:	83 ec 04             	sub    $0x4,%esp
  801c86:	68 68 2b 80 00       	push   $0x802b68
  801c8b:	6a 63                	push   $0x63
  801c8d:	68 73 2a 80 00       	push   $0x802a73
  801c92:	e8 53 02 00 00       	call   801eea <_panic>

00801c97 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  801c97:	55                   	push   %ebp
  801c98:	89 e5                	mov    %esp,%ebp
  801c9a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  801c9d:	83 ec 04             	sub    $0x4,%esp
  801ca0:	68 8c 2b 80 00       	push   $0x802b8c
  801ca5:	6a 72                	push   $0x72
  801ca7:	68 73 2a 80 00       	push   $0x802a73
  801cac:	e8 39 02 00 00       	call   801eea <_panic>

00801cb1 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  801cb1:	55                   	push   %ebp
  801cb2:	89 e5                	mov    %esp,%ebp
  801cb4:	83 ec 08             	sub    $0x8,%esp
	panic("create_semaphore() is not implemented yet...!!");
  801cb7:	83 ec 04             	sub    $0x4,%esp
  801cba:	68 b0 2b 80 00       	push   $0x802bb0
  801cbf:	6a 07                	push   $0x7
  801cc1:	68 df 2b 80 00       	push   $0x802bdf
  801cc6:	e8 1f 02 00 00       	call   801eea <_panic>

00801ccb <get_semaphore>:
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ccb:	55                   	push   %ebp
  801ccc:	89 e5                	mov    %esp,%ebp
  801cce:	83 ec 08             	sub    $0x8,%esp
	panic("get_semaphore() is not implemented yet...!!");
  801cd1:	83 ec 04             	sub    $0x4,%esp
  801cd4:	68 f0 2b 80 00       	push   $0x802bf0
  801cd9:	6a 0b                	push   $0xb
  801cdb:	68 df 2b 80 00       	push   $0x802bdf
  801ce0:	e8 05 02 00 00       	call   801eea <_panic>

00801ce5 <wait_semaphore>:
}

void wait_semaphore(struct semaphore sem)
{
  801ce5:	55                   	push   %ebp
  801ce6:	89 e5                	mov    %esp,%ebp
  801ce8:	83 ec 08             	sub    $0x8,%esp
	panic("wait_semaphore() is not implemented yet...!!");
  801ceb:	83 ec 04             	sub    $0x4,%esp
  801cee:	68 1c 2c 80 00       	push   $0x802c1c
  801cf3:	6a 10                	push   $0x10
  801cf5:	68 df 2b 80 00       	push   $0x802bdf
  801cfa:	e8 eb 01 00 00       	call   801eea <_panic>

00801cff <signal_semaphore>:
}

void signal_semaphore(struct semaphore sem)
{
  801cff:	55                   	push   %ebp
  801d00:	89 e5                	mov    %esp,%ebp
  801d02:	83 ec 08             	sub    $0x8,%esp
	panic("signal_semaphore() is not implemented yet...!!");
  801d05:	83 ec 04             	sub    $0x4,%esp
  801d08:	68 4c 2c 80 00       	push   $0x802c4c
  801d0d:	6a 15                	push   $0x15
  801d0f:	68 df 2b 80 00       	push   $0x802bdf
  801d14:	e8 d1 01 00 00       	call   801eea <_panic>

00801d19 <semaphore_count>:
}

int semaphore_count(struct semaphore sem)
{
  801d19:	55                   	push   %ebp
  801d1a:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  801d1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1f:	8b 40 10             	mov    0x10(%eax),%eax
}
  801d22:	5d                   	pop    %ebp
  801d23:	c3                   	ret    

00801d24 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801d24:	55                   	push   %ebp
  801d25:	89 e5                	mov    %esp,%ebp
  801d27:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801d2a:	8b 55 08             	mov    0x8(%ebp),%edx
  801d2d:	89 d0                	mov    %edx,%eax
  801d2f:	c1 e0 02             	shl    $0x2,%eax
  801d32:	01 d0                	add    %edx,%eax
  801d34:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801d3b:	01 d0                	add    %edx,%eax
  801d3d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801d44:	01 d0                	add    %edx,%eax
  801d46:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801d4d:	01 d0                	add    %edx,%eax
  801d4f:	c1 e0 04             	shl    $0x4,%eax
  801d52:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  801d55:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  801d5c:	0f 31                	rdtsc  
  801d5e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801d61:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  801d64:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d67:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801d6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d6d:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801d70:	eb 46                	jmp    801db8 <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  801d72:	0f 31                	rdtsc  
  801d74:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801d77:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  801d7a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801d7d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801d80:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801d83:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801d86:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d8c:	29 c2                	sub    %eax,%edx
  801d8e:	89 d0                	mov    %edx,%eax
  801d90:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801d93:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801d96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d99:	89 d1                	mov    %edx,%ecx
  801d9b:	29 c1                	sub    %eax,%ecx
  801d9d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801da0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801da3:	39 c2                	cmp    %eax,%edx
  801da5:	0f 97 c0             	seta   %al
  801da8:	0f b6 c0             	movzbl %al,%eax
  801dab:	29 c1                	sub    %eax,%ecx
  801dad:	89 c8                	mov    %ecx,%eax
  801daf:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801db2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801db5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801db8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801dbb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801dbe:	72 b2                	jb     801d72 <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801dc0:	90                   	nop
  801dc1:	c9                   	leave  
  801dc2:	c3                   	ret    

00801dc3 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801dc3:	55                   	push   %ebp
  801dc4:	89 e5                	mov    %esp,%ebp
  801dc6:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801dc9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801dd0:	eb 03                	jmp    801dd5 <busy_wait+0x12>
  801dd2:	ff 45 fc             	incl   -0x4(%ebp)
  801dd5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801dd8:	3b 45 08             	cmp    0x8(%ebp),%eax
  801ddb:	72 f5                	jb     801dd2 <busy_wait+0xf>
	return i;
  801ddd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801de0:	c9                   	leave  
  801de1:	c3                   	ret    

00801de2 <init_uspinlock>:
#include "inc/uspinlock.h"

extern volatile struct Env *myEnv;

void init_uspinlock(struct uspinlock *lk, char *name, bool isOpened)
{
  801de2:	55                   	push   %ebp
  801de3:	89 e5                	mov    %esp,%ebp
  801de5:	83 ec 08             	sub    $0x8,%esp
	assert(isOpened == 0 || isOpened == 1);
  801de8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801dec:	74 1c                	je     801e0a <init_uspinlock+0x28>
  801dee:	83 7d 10 01          	cmpl   $0x1,0x10(%ebp)
  801df2:	74 16                	je     801e0a <init_uspinlock+0x28>
  801df4:	68 7c 2c 80 00       	push   $0x802c7c
  801df9:	68 9b 2c 80 00       	push   $0x802c9b
  801dfe:	6a 10                	push   $0x10
  801e00:	68 b0 2c 80 00       	push   $0x802cb0
  801e05:	e8 e0 00 00 00       	call   801eea <_panic>
	strcpy(lk->name, name);
  801e0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0d:	83 c0 04             	add    $0x4,%eax
  801e10:	83 ec 08             	sub    $0x8,%esp
  801e13:	ff 75 0c             	pushl  0xc(%ebp)
  801e16:	50                   	push   %eax
  801e17:	e8 2f ee ff ff       	call   800c4b <strcpy>
  801e1c:	83 c4 10             	add    $0x10,%esp
	lk->locked = (1 - isOpened);
  801e1f:	b8 01 00 00 00       	mov    $0x1,%eax
  801e24:	2b 45 10             	sub    0x10(%ebp),%eax
  801e27:	89 c2                	mov    %eax,%edx
  801e29:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2c:	89 10                	mov    %edx,(%eax)
}
  801e2e:	90                   	nop
  801e2f:	c9                   	leave  
  801e30:	c3                   	ret    

00801e31 <acquire_uspinlock>:
// Acquire the lock.
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void acquire_uspinlock(struct uspinlock *lk)
{
  801e31:	55                   	push   %ebp
  801e32:	89 e5                	mov    %esp,%ebp
  801e34:	83 ec 18             	sub    $0x18,%esp
	// The xchg is atomic.
	while(xchg(&lk->locked, 1) != 0) ;
  801e37:	90                   	nop
  801e38:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e3e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
xchg(volatile uint32 *addr, uint32 newval)
{
  uint32 result;

  // The + in "+m" denotes a read-modify-write operand.
  __asm __volatile("lock; xchgl %0, %1" :
  801e45:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e4b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801e4e:	f0 87 02             	lock xchg %eax,(%edx)
  801e51:	89 45 ec             	mov    %eax,-0x14(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
  801e54:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e57:	85 c0                	test   %eax,%eax
  801e59:	75 dd                	jne    801e38 <acquire_uspinlock+0x7>

	cprintf("[%d: %s] ACQUIRED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  801e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5e:	8d 48 04             	lea    0x4(%eax),%ecx
  801e61:	a1 20 30 80 00       	mov    0x803020,%eax
  801e66:	8d 50 20             	lea    0x20(%eax),%edx
  801e69:	a1 20 30 80 00       	mov    0x803020,%eax
  801e6e:	8b 40 10             	mov    0x10(%eax),%eax
  801e71:	51                   	push   %ecx
  801e72:	52                   	push   %edx
  801e73:	50                   	push   %eax
  801e74:	68 c0 2c 80 00       	push   $0x802cc0
  801e79:	e8 a5 e6 ff ff       	call   800523 <cprintf>
  801e7e:	83 c4 10             	add    $0x10,%esp

	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that the critical section's memory
	// references happen after the lock is acquired.
	__sync_synchronize();
  801e81:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
}
  801e86:	90                   	nop
  801e87:	c9                   	leave  
  801e88:	c3                   	ret    

00801e89 <release_uspinlock>:

// Release the lock.
void release_uspinlock(struct uspinlock *lk)
{
  801e89:	55                   	push   %ebp
  801e8a:	89 e5                	mov    %esp,%ebp
  801e8c:	83 ec 08             	sub    $0x8,%esp
	if(!(lk->locked))
  801e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e92:	8b 00                	mov    (%eax),%eax
  801e94:	85 c0                	test   %eax,%eax
  801e96:	75 18                	jne    801eb0 <release_uspinlock+0x27>
	{
		panic("release: lock \"%s\" is not held!", lk->name);
  801e98:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9b:	83 c0 04             	add    $0x4,%eax
  801e9e:	50                   	push   %eax
  801e9f:	68 e4 2c 80 00       	push   $0x802ce4
  801ea4:	6a 2b                	push   $0x2b
  801ea6:	68 b0 2c 80 00       	push   $0x802cb0
  801eab:	e8 3a 00 00 00       	call   801eea <_panic>
	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that all the stores in the critical
	// section are visible to other cores before the lock is released.
	// Both the C compiler and the hardware may re-order loads and
	// stores; __sync_synchronize() tells them both not to.
	__sync_synchronize();
  801eb0:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

	// Release the lock, equivalent to lk->locked = 0.
	// This code can't use a C assignment, since it might
	// not be atomic. A real OS would use C atomics here.
	asm volatile("movl $0, %0" : "+m" (lk->locked) : );
  801eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb8:	8b 55 08             	mov    0x8(%ebp),%edx
  801ebb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	cprintf("[%d: %s] RELEASED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  801ec1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec4:	8d 48 04             	lea    0x4(%eax),%ecx
  801ec7:	a1 20 30 80 00       	mov    0x803020,%eax
  801ecc:	8d 50 20             	lea    0x20(%eax),%edx
  801ecf:	a1 20 30 80 00       	mov    0x803020,%eax
  801ed4:	8b 40 10             	mov    0x10(%eax),%eax
  801ed7:	51                   	push   %ecx
  801ed8:	52                   	push   %edx
  801ed9:	50                   	push   %eax
  801eda:	68 04 2d 80 00       	push   $0x802d04
  801edf:	e8 3f e6 ff ff       	call   800523 <cprintf>
  801ee4:	83 c4 10             	add    $0x10,%esp
}
  801ee7:	90                   	nop
  801ee8:	c9                   	leave  
  801ee9:	c3                   	ret    

00801eea <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801eea:	55                   	push   %ebp
  801eeb:	89 e5                	mov    %esp,%ebp
  801eed:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801ef0:	8d 45 10             	lea    0x10(%ebp),%eax
  801ef3:	83 c0 04             	add    $0x4,%eax
  801ef6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801ef9:	a1 1c b1 81 00       	mov    0x81b11c,%eax
  801efe:	85 c0                	test   %eax,%eax
  801f00:	74 16                	je     801f18 <_panic+0x2e>
		cprintf("%s: ", argv0);
  801f02:	a1 1c b1 81 00       	mov    0x81b11c,%eax
  801f07:	83 ec 08             	sub    $0x8,%esp
  801f0a:	50                   	push   %eax
  801f0b:	68 28 2d 80 00       	push   $0x802d28
  801f10:	e8 0e e6 ff ff       	call   800523 <cprintf>
  801f15:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  801f18:	a1 04 30 80 00       	mov    0x803004,%eax
  801f1d:	83 ec 0c             	sub    $0xc,%esp
  801f20:	ff 75 0c             	pushl  0xc(%ebp)
  801f23:	ff 75 08             	pushl  0x8(%ebp)
  801f26:	50                   	push   %eax
  801f27:	68 30 2d 80 00       	push   $0x802d30
  801f2c:	6a 74                	push   $0x74
  801f2e:	e8 1d e6 ff ff       	call   800550 <cprintf_colored>
  801f33:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  801f36:	8b 45 10             	mov    0x10(%ebp),%eax
  801f39:	83 ec 08             	sub    $0x8,%esp
  801f3c:	ff 75 f4             	pushl  -0xc(%ebp)
  801f3f:	50                   	push   %eax
  801f40:	e8 6f e5 ff ff       	call   8004b4 <vcprintf>
  801f45:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801f48:	83 ec 08             	sub    $0x8,%esp
  801f4b:	6a 00                	push   $0x0
  801f4d:	68 58 2d 80 00       	push   $0x802d58
  801f52:	e8 5d e5 ff ff       	call   8004b4 <vcprintf>
  801f57:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801f5a:	e8 d6 e4 ff ff       	call   800435 <exit>

	// should not return here
	while (1) ;
  801f5f:	eb fe                	jmp    801f5f <_panic+0x75>

00801f61 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801f61:	55                   	push   %ebp
  801f62:	89 e5                	mov    %esp,%ebp
  801f64:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801f67:	a1 20 30 80 00       	mov    0x803020,%eax
  801f6c:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801f72:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f75:	39 c2                	cmp    %eax,%edx
  801f77:	74 14                	je     801f8d <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801f79:	83 ec 04             	sub    $0x4,%esp
  801f7c:	68 5c 2d 80 00       	push   $0x802d5c
  801f81:	6a 26                	push   $0x26
  801f83:	68 a8 2d 80 00       	push   $0x802da8
  801f88:	e8 5d ff ff ff       	call   801eea <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801f8d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801f94:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801f9b:	e9 c5 00 00 00       	jmp    802065 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801fa0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fa3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801faa:	8b 45 08             	mov    0x8(%ebp),%eax
  801fad:	01 d0                	add    %edx,%eax
  801faf:	8b 00                	mov    (%eax),%eax
  801fb1:	85 c0                	test   %eax,%eax
  801fb3:	75 08                	jne    801fbd <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801fb5:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801fb8:	e9 a5 00 00 00       	jmp    802062 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801fbd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801fc4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801fcb:	eb 69                	jmp    802036 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801fcd:	a1 20 30 80 00       	mov    0x803020,%eax
  801fd2:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  801fd8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801fdb:	89 d0                	mov    %edx,%eax
  801fdd:	01 c0                	add    %eax,%eax
  801fdf:	01 d0                	add    %edx,%eax
  801fe1:	c1 e0 03             	shl    $0x3,%eax
  801fe4:	01 c8                	add    %ecx,%eax
  801fe6:	8a 40 04             	mov    0x4(%eax),%al
  801fe9:	84 c0                	test   %al,%al
  801feb:	75 46                	jne    802033 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801fed:	a1 20 30 80 00       	mov    0x803020,%eax
  801ff2:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  801ff8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801ffb:	89 d0                	mov    %edx,%eax
  801ffd:	01 c0                	add    %eax,%eax
  801fff:	01 d0                	add    %edx,%eax
  802001:	c1 e0 03             	shl    $0x3,%eax
  802004:	01 c8                	add    %ecx,%eax
  802006:	8b 00                	mov    (%eax),%eax
  802008:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80200b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80200e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802013:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  802015:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802018:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80201f:	8b 45 08             	mov    0x8(%ebp),%eax
  802022:	01 c8                	add    %ecx,%eax
  802024:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  802026:	39 c2                	cmp    %eax,%edx
  802028:	75 09                	jne    802033 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80202a:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  802031:	eb 15                	jmp    802048 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802033:	ff 45 e8             	incl   -0x18(%ebp)
  802036:	a1 20 30 80 00       	mov    0x803020,%eax
  80203b:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  802041:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802044:	39 c2                	cmp    %eax,%edx
  802046:	77 85                	ja     801fcd <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  802048:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80204c:	75 14                	jne    802062 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80204e:	83 ec 04             	sub    $0x4,%esp
  802051:	68 b4 2d 80 00       	push   $0x802db4
  802056:	6a 3a                	push   $0x3a
  802058:	68 a8 2d 80 00       	push   $0x802da8
  80205d:	e8 88 fe ff ff       	call   801eea <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  802062:	ff 45 f0             	incl   -0x10(%ebp)
  802065:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802068:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80206b:	0f 8c 2f ff ff ff    	jl     801fa0 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  802071:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802078:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80207f:	eb 26                	jmp    8020a7 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  802081:	a1 20 30 80 00       	mov    0x803020,%eax
  802086:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80208c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80208f:	89 d0                	mov    %edx,%eax
  802091:	01 c0                	add    %eax,%eax
  802093:	01 d0                	add    %edx,%eax
  802095:	c1 e0 03             	shl    $0x3,%eax
  802098:	01 c8                	add    %ecx,%eax
  80209a:	8a 40 04             	mov    0x4(%eax),%al
  80209d:	3c 01                	cmp    $0x1,%al
  80209f:	75 03                	jne    8020a4 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8020a1:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8020a4:	ff 45 e0             	incl   -0x20(%ebp)
  8020a7:	a1 20 30 80 00       	mov    0x803020,%eax
  8020ac:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8020b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020b5:	39 c2                	cmp    %eax,%edx
  8020b7:	77 c8                	ja     802081 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8020b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020bc:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8020bf:	74 14                	je     8020d5 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8020c1:	83 ec 04             	sub    $0x4,%esp
  8020c4:	68 08 2e 80 00       	push   $0x802e08
  8020c9:	6a 44                	push   $0x44
  8020cb:	68 a8 2d 80 00       	push   $0x802da8
  8020d0:	e8 15 fe ff ff       	call   801eea <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8020d5:	90                   	nop
  8020d6:	c9                   	leave  
  8020d7:	c3                   	ret    

008020d8 <__udivdi3>:
  8020d8:	55                   	push   %ebp
  8020d9:	57                   	push   %edi
  8020da:	56                   	push   %esi
  8020db:	53                   	push   %ebx
  8020dc:	83 ec 1c             	sub    $0x1c,%esp
  8020df:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8020e3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8020e7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8020eb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8020ef:	89 ca                	mov    %ecx,%edx
  8020f1:	89 f8                	mov    %edi,%eax
  8020f3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8020f7:	85 f6                	test   %esi,%esi
  8020f9:	75 2d                	jne    802128 <__udivdi3+0x50>
  8020fb:	39 cf                	cmp    %ecx,%edi
  8020fd:	77 65                	ja     802164 <__udivdi3+0x8c>
  8020ff:	89 fd                	mov    %edi,%ebp
  802101:	85 ff                	test   %edi,%edi
  802103:	75 0b                	jne    802110 <__udivdi3+0x38>
  802105:	b8 01 00 00 00       	mov    $0x1,%eax
  80210a:	31 d2                	xor    %edx,%edx
  80210c:	f7 f7                	div    %edi
  80210e:	89 c5                	mov    %eax,%ebp
  802110:	31 d2                	xor    %edx,%edx
  802112:	89 c8                	mov    %ecx,%eax
  802114:	f7 f5                	div    %ebp
  802116:	89 c1                	mov    %eax,%ecx
  802118:	89 d8                	mov    %ebx,%eax
  80211a:	f7 f5                	div    %ebp
  80211c:	89 cf                	mov    %ecx,%edi
  80211e:	89 fa                	mov    %edi,%edx
  802120:	83 c4 1c             	add    $0x1c,%esp
  802123:	5b                   	pop    %ebx
  802124:	5e                   	pop    %esi
  802125:	5f                   	pop    %edi
  802126:	5d                   	pop    %ebp
  802127:	c3                   	ret    
  802128:	39 ce                	cmp    %ecx,%esi
  80212a:	77 28                	ja     802154 <__udivdi3+0x7c>
  80212c:	0f bd fe             	bsr    %esi,%edi
  80212f:	83 f7 1f             	xor    $0x1f,%edi
  802132:	75 40                	jne    802174 <__udivdi3+0x9c>
  802134:	39 ce                	cmp    %ecx,%esi
  802136:	72 0a                	jb     802142 <__udivdi3+0x6a>
  802138:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80213c:	0f 87 9e 00 00 00    	ja     8021e0 <__udivdi3+0x108>
  802142:	b8 01 00 00 00       	mov    $0x1,%eax
  802147:	89 fa                	mov    %edi,%edx
  802149:	83 c4 1c             	add    $0x1c,%esp
  80214c:	5b                   	pop    %ebx
  80214d:	5e                   	pop    %esi
  80214e:	5f                   	pop    %edi
  80214f:	5d                   	pop    %ebp
  802150:	c3                   	ret    
  802151:	8d 76 00             	lea    0x0(%esi),%esi
  802154:	31 ff                	xor    %edi,%edi
  802156:	31 c0                	xor    %eax,%eax
  802158:	89 fa                	mov    %edi,%edx
  80215a:	83 c4 1c             	add    $0x1c,%esp
  80215d:	5b                   	pop    %ebx
  80215e:	5e                   	pop    %esi
  80215f:	5f                   	pop    %edi
  802160:	5d                   	pop    %ebp
  802161:	c3                   	ret    
  802162:	66 90                	xchg   %ax,%ax
  802164:	89 d8                	mov    %ebx,%eax
  802166:	f7 f7                	div    %edi
  802168:	31 ff                	xor    %edi,%edi
  80216a:	89 fa                	mov    %edi,%edx
  80216c:	83 c4 1c             	add    $0x1c,%esp
  80216f:	5b                   	pop    %ebx
  802170:	5e                   	pop    %esi
  802171:	5f                   	pop    %edi
  802172:	5d                   	pop    %ebp
  802173:	c3                   	ret    
  802174:	bd 20 00 00 00       	mov    $0x20,%ebp
  802179:	89 eb                	mov    %ebp,%ebx
  80217b:	29 fb                	sub    %edi,%ebx
  80217d:	89 f9                	mov    %edi,%ecx
  80217f:	d3 e6                	shl    %cl,%esi
  802181:	89 c5                	mov    %eax,%ebp
  802183:	88 d9                	mov    %bl,%cl
  802185:	d3 ed                	shr    %cl,%ebp
  802187:	89 e9                	mov    %ebp,%ecx
  802189:	09 f1                	or     %esi,%ecx
  80218b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80218f:	89 f9                	mov    %edi,%ecx
  802191:	d3 e0                	shl    %cl,%eax
  802193:	89 c5                	mov    %eax,%ebp
  802195:	89 d6                	mov    %edx,%esi
  802197:	88 d9                	mov    %bl,%cl
  802199:	d3 ee                	shr    %cl,%esi
  80219b:	89 f9                	mov    %edi,%ecx
  80219d:	d3 e2                	shl    %cl,%edx
  80219f:	8b 44 24 08          	mov    0x8(%esp),%eax
  8021a3:	88 d9                	mov    %bl,%cl
  8021a5:	d3 e8                	shr    %cl,%eax
  8021a7:	09 c2                	or     %eax,%edx
  8021a9:	89 d0                	mov    %edx,%eax
  8021ab:	89 f2                	mov    %esi,%edx
  8021ad:	f7 74 24 0c          	divl   0xc(%esp)
  8021b1:	89 d6                	mov    %edx,%esi
  8021b3:	89 c3                	mov    %eax,%ebx
  8021b5:	f7 e5                	mul    %ebp
  8021b7:	39 d6                	cmp    %edx,%esi
  8021b9:	72 19                	jb     8021d4 <__udivdi3+0xfc>
  8021bb:	74 0b                	je     8021c8 <__udivdi3+0xf0>
  8021bd:	89 d8                	mov    %ebx,%eax
  8021bf:	31 ff                	xor    %edi,%edi
  8021c1:	e9 58 ff ff ff       	jmp    80211e <__udivdi3+0x46>
  8021c6:	66 90                	xchg   %ax,%ax
  8021c8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8021cc:	89 f9                	mov    %edi,%ecx
  8021ce:	d3 e2                	shl    %cl,%edx
  8021d0:	39 c2                	cmp    %eax,%edx
  8021d2:	73 e9                	jae    8021bd <__udivdi3+0xe5>
  8021d4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8021d7:	31 ff                	xor    %edi,%edi
  8021d9:	e9 40 ff ff ff       	jmp    80211e <__udivdi3+0x46>
  8021de:	66 90                	xchg   %ax,%ax
  8021e0:	31 c0                	xor    %eax,%eax
  8021e2:	e9 37 ff ff ff       	jmp    80211e <__udivdi3+0x46>
  8021e7:	90                   	nop

008021e8 <__umoddi3>:
  8021e8:	55                   	push   %ebp
  8021e9:	57                   	push   %edi
  8021ea:	56                   	push   %esi
  8021eb:	53                   	push   %ebx
  8021ec:	83 ec 1c             	sub    $0x1c,%esp
  8021ef:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8021f3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8021f7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8021fb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8021ff:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802203:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802207:	89 f3                	mov    %esi,%ebx
  802209:	89 fa                	mov    %edi,%edx
  80220b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80220f:	89 34 24             	mov    %esi,(%esp)
  802212:	85 c0                	test   %eax,%eax
  802214:	75 1a                	jne    802230 <__umoddi3+0x48>
  802216:	39 f7                	cmp    %esi,%edi
  802218:	0f 86 a2 00 00 00    	jbe    8022c0 <__umoddi3+0xd8>
  80221e:	89 c8                	mov    %ecx,%eax
  802220:	89 f2                	mov    %esi,%edx
  802222:	f7 f7                	div    %edi
  802224:	89 d0                	mov    %edx,%eax
  802226:	31 d2                	xor    %edx,%edx
  802228:	83 c4 1c             	add    $0x1c,%esp
  80222b:	5b                   	pop    %ebx
  80222c:	5e                   	pop    %esi
  80222d:	5f                   	pop    %edi
  80222e:	5d                   	pop    %ebp
  80222f:	c3                   	ret    
  802230:	39 f0                	cmp    %esi,%eax
  802232:	0f 87 ac 00 00 00    	ja     8022e4 <__umoddi3+0xfc>
  802238:	0f bd e8             	bsr    %eax,%ebp
  80223b:	83 f5 1f             	xor    $0x1f,%ebp
  80223e:	0f 84 ac 00 00 00    	je     8022f0 <__umoddi3+0x108>
  802244:	bf 20 00 00 00       	mov    $0x20,%edi
  802249:	29 ef                	sub    %ebp,%edi
  80224b:	89 fe                	mov    %edi,%esi
  80224d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802251:	89 e9                	mov    %ebp,%ecx
  802253:	d3 e0                	shl    %cl,%eax
  802255:	89 d7                	mov    %edx,%edi
  802257:	89 f1                	mov    %esi,%ecx
  802259:	d3 ef                	shr    %cl,%edi
  80225b:	09 c7                	or     %eax,%edi
  80225d:	89 e9                	mov    %ebp,%ecx
  80225f:	d3 e2                	shl    %cl,%edx
  802261:	89 14 24             	mov    %edx,(%esp)
  802264:	89 d8                	mov    %ebx,%eax
  802266:	d3 e0                	shl    %cl,%eax
  802268:	89 c2                	mov    %eax,%edx
  80226a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80226e:	d3 e0                	shl    %cl,%eax
  802270:	89 44 24 04          	mov    %eax,0x4(%esp)
  802274:	8b 44 24 08          	mov    0x8(%esp),%eax
  802278:	89 f1                	mov    %esi,%ecx
  80227a:	d3 e8                	shr    %cl,%eax
  80227c:	09 d0                	or     %edx,%eax
  80227e:	d3 eb                	shr    %cl,%ebx
  802280:	89 da                	mov    %ebx,%edx
  802282:	f7 f7                	div    %edi
  802284:	89 d3                	mov    %edx,%ebx
  802286:	f7 24 24             	mull   (%esp)
  802289:	89 c6                	mov    %eax,%esi
  80228b:	89 d1                	mov    %edx,%ecx
  80228d:	39 d3                	cmp    %edx,%ebx
  80228f:	0f 82 87 00 00 00    	jb     80231c <__umoddi3+0x134>
  802295:	0f 84 91 00 00 00    	je     80232c <__umoddi3+0x144>
  80229b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80229f:	29 f2                	sub    %esi,%edx
  8022a1:	19 cb                	sbb    %ecx,%ebx
  8022a3:	89 d8                	mov    %ebx,%eax
  8022a5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8022a9:	d3 e0                	shl    %cl,%eax
  8022ab:	89 e9                	mov    %ebp,%ecx
  8022ad:	d3 ea                	shr    %cl,%edx
  8022af:	09 d0                	or     %edx,%eax
  8022b1:	89 e9                	mov    %ebp,%ecx
  8022b3:	d3 eb                	shr    %cl,%ebx
  8022b5:	89 da                	mov    %ebx,%edx
  8022b7:	83 c4 1c             	add    $0x1c,%esp
  8022ba:	5b                   	pop    %ebx
  8022bb:	5e                   	pop    %esi
  8022bc:	5f                   	pop    %edi
  8022bd:	5d                   	pop    %ebp
  8022be:	c3                   	ret    
  8022bf:	90                   	nop
  8022c0:	89 fd                	mov    %edi,%ebp
  8022c2:	85 ff                	test   %edi,%edi
  8022c4:	75 0b                	jne    8022d1 <__umoddi3+0xe9>
  8022c6:	b8 01 00 00 00       	mov    $0x1,%eax
  8022cb:	31 d2                	xor    %edx,%edx
  8022cd:	f7 f7                	div    %edi
  8022cf:	89 c5                	mov    %eax,%ebp
  8022d1:	89 f0                	mov    %esi,%eax
  8022d3:	31 d2                	xor    %edx,%edx
  8022d5:	f7 f5                	div    %ebp
  8022d7:	89 c8                	mov    %ecx,%eax
  8022d9:	f7 f5                	div    %ebp
  8022db:	89 d0                	mov    %edx,%eax
  8022dd:	e9 44 ff ff ff       	jmp    802226 <__umoddi3+0x3e>
  8022e2:	66 90                	xchg   %ax,%ax
  8022e4:	89 c8                	mov    %ecx,%eax
  8022e6:	89 f2                	mov    %esi,%edx
  8022e8:	83 c4 1c             	add    $0x1c,%esp
  8022eb:	5b                   	pop    %ebx
  8022ec:	5e                   	pop    %esi
  8022ed:	5f                   	pop    %edi
  8022ee:	5d                   	pop    %ebp
  8022ef:	c3                   	ret    
  8022f0:	3b 04 24             	cmp    (%esp),%eax
  8022f3:	72 06                	jb     8022fb <__umoddi3+0x113>
  8022f5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8022f9:	77 0f                	ja     80230a <__umoddi3+0x122>
  8022fb:	89 f2                	mov    %esi,%edx
  8022fd:	29 f9                	sub    %edi,%ecx
  8022ff:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802303:	89 14 24             	mov    %edx,(%esp)
  802306:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80230a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80230e:	8b 14 24             	mov    (%esp),%edx
  802311:	83 c4 1c             	add    $0x1c,%esp
  802314:	5b                   	pop    %ebx
  802315:	5e                   	pop    %esi
  802316:	5f                   	pop    %edi
  802317:	5d                   	pop    %ebp
  802318:	c3                   	ret    
  802319:	8d 76 00             	lea    0x0(%esi),%esi
  80231c:	2b 04 24             	sub    (%esp),%eax
  80231f:	19 fa                	sbb    %edi,%edx
  802321:	89 d1                	mov    %edx,%ecx
  802323:	89 c6                	mov    %eax,%esi
  802325:	e9 71 ff ff ff       	jmp    80229b <__umoddi3+0xb3>
  80232a:	66 90                	xchg   %ax,%ax
  80232c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802330:	72 ea                	jb     80231c <__umoddi3+0x134>
  802332:	89 d9                	mov    %ebx,%ecx
  802334:	e9 62 ff ff ff       	jmp    80229b <__umoddi3+0xb3>

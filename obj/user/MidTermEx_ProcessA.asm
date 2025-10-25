
obj/user/MidTermEx_ProcessA:     file format elf32-i386


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
  800031:	e8 5e 02 00 00       	call   800294 <libmain>
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
  800048:	e8 74 18 00 00       	call   8018c1 <sys_getparentenvid>
  80004d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int delay;

	/*[1] GET SHARED VARIABLE, SEMAPHORE SEL, check-finishing counter*/
	int *X = sget(parentenvID, "X") ;
  800050:	83 ec 08             	sub    $0x8,%esp
  800053:	68 40 23 80 00       	push   $0x802340
  800058:	ff 75 ec             	pushl  -0x14(%ebp)
  80005b:	e8 02 15 00 00       	call   801562 <sget>
  800060:	83 c4 10             	add    $0x10,%esp
  800063:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int *protType = sget(parentenvID, "protType") ;
  800066:	83 ec 08             	sub    $0x8,%esp
  800069:	68 42 23 80 00       	push   $0x802342
  80006e:	ff 75 ec             	pushl  -0x14(%ebp)
  800071:	e8 ec 14 00 00       	call   801562 <sget>
  800076:	83 c4 10             	add    $0x10,%esp
  800079:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int *finishedCount = sget(parentenvID, "finishedCount") ;
  80007c:	83 ec 08             	sub    $0x8,%esp
  80007f:	68 4b 23 80 00       	push   $0x80234b
  800084:	ff 75 ec             	pushl  -0x14(%ebp)
  800087:	e8 d6 14 00 00       	call   801562 <sget>
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
  8000ab:	e8 1c 1c 00 00       	call   801ccc <get_semaphore>
  8000b0:	83 c4 0c             	add    $0xc,%esp
		finished = get_semaphore(parentenvID, "finished");
  8000b3:	8d 45 b8             	lea    -0x48(%ebp),%eax
  8000b6:	83 ec 04             	sub    $0x4,%esp
  8000b9:	68 5b 23 80 00       	push   $0x80235b
  8000be:	ff 75 ec             	pushl  -0x14(%ebp)
  8000c1:	50                   	push   %eax
  8000c2:	e8 05 1c 00 00       	call   801ccc <get_semaphore>
  8000c7:	83 c4 0c             	add    $0xc,%esp
		finishedCountMutex = get_semaphore(parentenvID, "finishedCountMutex");
  8000ca:	8d 45 b4             	lea    -0x4c(%ebp),%eax
  8000cd:	83 ec 04             	sub    $0x4,%esp
  8000d0:	68 64 23 80 00       	push   $0x802364
  8000d5:	ff 75 ec             	pushl  -0x14(%ebp)
  8000d8:	50                   	push   %eax
  8000d9:	e8 ee 1b 00 00       	call   801ccc <get_semaphore>
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
  8000f8:	e8 65 14 00 00       	call   801562 <sget>
  8000fd:	83 c4 10             	add    $0x10,%esp
  800100:	89 45 f4             	mov    %eax,-0xc(%ebp)
		sfinishedCountMutex = sget(parentenvID, "finishedCountMutex");
  800103:	83 ec 08             	sub    $0x8,%esp
  800106:	68 64 23 80 00       	push   $0x802364
  80010b:	ff 75 ec             	pushl  -0x14(%ebp)
  80010e:	e8 4f 14 00 00       	call   801562 <sget>
  800113:	83 c4 10             	add    $0x10,%esp
  800116:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	/*[2] DO THE JOB*/
	int Y ;
	//random delay
	delay = RAND(2000, 10000);
  800119:	8d 45 c0             	lea    -0x40(%ebp),%eax
  80011c:	83 ec 0c             	sub    $0xc,%esp
  80011f:	50                   	push   %eax
  800120:	e8 cf 17 00 00       	call   8018f4 <sys_get_virtual_time>
  800125:	83 c4 0c             	add    $0xc,%esp
  800128:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80012b:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  800130:	ba 00 00 00 00       	mov    $0x0,%edx
  800135:	f7 f1                	div    %ecx
  800137:	89 d0                	mov    %edx,%eax
  800139:	05 d0 07 00 00       	add    $0x7d0,%eax
  80013e:	89 45 dc             	mov    %eax,-0x24(%ebp)
	env_sleep(delay);
  800141:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800144:	83 ec 0c             	sub    $0xc,%esp
  800147:	50                   	push   %eax
  800148:	e8 d8 1b 00 00       	call   801d25 <env_sleep>
  80014d:	83 c4 10             	add    $0x10,%esp
	//	cprintf("delay = %d\n", delay);

	Y = (*X) * 2 ;
  800150:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800153:	8b 00                	mov    (%eax),%eax
  800155:	01 c0                	add    %eax,%eax
  800157:	89 45 d8             	mov    %eax,-0x28(%ebp)

	//random delay
	delay = RAND(2000, 10000);
  80015a:	8d 45 c8             	lea    -0x38(%ebp),%eax
  80015d:	83 ec 0c             	sub    $0xc,%esp
  800160:	50                   	push   %eax
  800161:	e8 8e 17 00 00       	call   8018f4 <sys_get_virtual_time>
  800166:	83 c4 0c             	add    $0xc,%esp
  800169:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80016c:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  800171:	ba 00 00 00 00       	mov    $0x0,%edx
  800176:	f7 f1                	div    %ecx
  800178:	89 d0                	mov    %edx,%eax
  80017a:	05 d0 07 00 00       	add    $0x7d0,%eax
  80017f:	89 45 dc             	mov    %eax,-0x24(%ebp)
	env_sleep(delay);
  800182:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800185:	83 ec 0c             	sub    $0xc,%esp
  800188:	50                   	push   %eax
  800189:	e8 97 1b 00 00       	call   801d25 <env_sleep>
  80018e:	83 c4 10             	add    $0x10,%esp
	//	cprintf("delay = %d\n", delay);

	(*X) = Y ;
  800191:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800194:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800197:	89 10                	mov    %edx,(%eax)

	//random delay
	delay = RAND(2000, 10000);
  800199:	8d 45 d0             	lea    -0x30(%ebp),%eax
  80019c:	83 ec 0c             	sub    $0xc,%esp
  80019f:	50                   	push   %eax
  8001a0:	e8 4f 17 00 00       	call   8018f4 <sys_get_virtual_time>
  8001a5:	83 c4 0c             	add    $0xc,%esp
  8001a8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8001ab:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  8001b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8001b5:	f7 f1                	div    %ecx
  8001b7:	89 d0                	mov    %edx,%eax
  8001b9:	05 d0 07 00 00       	add    $0x7d0,%eax
  8001be:	89 45 dc             	mov    %eax,-0x24(%ebp)
	env_sleep(delay);
  8001c1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001c4:	83 ec 0c             	sub    $0xc,%esp
  8001c7:	50                   	push   %eax
  8001c8:	e8 58 1b 00 00       	call   801d25 <env_sleep>
  8001cd:	83 c4 10             	add    $0x10,%esp
	//	cprintf("delay = %d\n", delay);

	if (*protType == 1)
  8001d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001d3:	8b 00                	mov    (%eax),%eax
  8001d5:	83 f8 01             	cmp    $0x1,%eax
  8001d8:	75 10                	jne    8001ea <_main+0x1b2>
	{
		signal_semaphore(T);
  8001da:	83 ec 0c             	sub    $0xc,%esp
  8001dd:	ff 75 bc             	pushl  -0x44(%ebp)
  8001e0:	e8 1b 1b 00 00       	call   801d00 <signal_semaphore>
  8001e5:	83 c4 10             	add    $0x10,%esp
  8001e8:	eb 18                	jmp    800202 <_main+0x1ca>
	}
	else if (*protType == 2)
  8001ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001ed:	8b 00                	mov    (%eax),%eax
  8001ef:	83 f8 02             	cmp    $0x2,%eax
  8001f2:	75 0e                	jne    800202 <_main+0x1ca>
	{
		release_uspinlock(sT);
  8001f4:	83 ec 0c             	sub    $0xc,%esp
  8001f7:	ff 75 f4             	pushl  -0xc(%ebp)
  8001fa:	e8 8b 1c 00 00       	call   801e8a <release_uspinlock>
  8001ff:	83 c4 10             	add    $0x10,%esp
	}
	/*[3] DECLARE FINISHING*/
	if (*protType == 1)
  800202:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800205:	8b 00                	mov    (%eax),%eax
  800207:	83 f8 01             	cmp    $0x1,%eax
  80020a:	75 39                	jne    800245 <_main+0x20d>
	{
		signal_semaphore(finished);
  80020c:	83 ec 0c             	sub    $0xc,%esp
  80020f:	ff 75 b8             	pushl  -0x48(%ebp)
  800212:	e8 e9 1a 00 00       	call   801d00 <signal_semaphore>
  800217:	83 c4 10             	add    $0x10,%esp

		wait_semaphore(finishedCountMutex);
  80021a:	83 ec 0c             	sub    $0xc,%esp
  80021d:	ff 75 b4             	pushl  -0x4c(%ebp)
  800220:	e8 c1 1a 00 00       	call   801ce6 <wait_semaphore>
  800225:	83 c4 10             	add    $0x10,%esp
		{
			(*finishedCount)++ ;
  800228:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80022b:	8b 00                	mov    (%eax),%eax
  80022d:	8d 50 01             	lea    0x1(%eax),%edx
  800230:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800233:	89 10                	mov    %edx,(%eax)
		}
		signal_semaphore(finishedCountMutex);
  800235:	83 ec 0c             	sub    $0xc,%esp
  800238:	ff 75 b4             	pushl  -0x4c(%ebp)
  80023b:	e8 c0 1a 00 00       	call   801d00 <signal_semaphore>
  800240:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
	}


}
  800243:	eb 4c                	jmp    800291 <_main+0x259>
		{
			(*finishedCount)++ ;
		}
		signal_semaphore(finishedCountMutex);
	}
	else if (*protType == 2)
  800245:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800248:	8b 00                	mov    (%eax),%eax
  80024a:	83 f8 02             	cmp    $0x2,%eax
  80024d:	75 2b                	jne    80027a <_main+0x242>
	{
		acquire_uspinlock(sfinishedCountMutex);
  80024f:	83 ec 0c             	sub    $0xc,%esp
  800252:	ff 75 f0             	pushl  -0x10(%ebp)
  800255:	e8 d8 1b 00 00       	call   801e32 <acquire_uspinlock>
  80025a:	83 c4 10             	add    $0x10,%esp
		{
			(*finishedCount)++ ;
  80025d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800260:	8b 00                	mov    (%eax),%eax
  800262:	8d 50 01             	lea    0x1(%eax),%edx
  800265:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800268:	89 10                	mov    %edx,(%eax)
		}
		release_uspinlock(sfinishedCountMutex);
  80026a:	83 ec 0c             	sub    $0xc,%esp
  80026d:	ff 75 f0             	pushl  -0x10(%ebp)
  800270:	e8 15 1c 00 00       	call   801e8a <release_uspinlock>
  800275:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
	}


}
  800278:	eb 17                	jmp    800291 <_main+0x259>
		}
		release_uspinlock(sfinishedCountMutex);
	}
	else
	{
		sys_lock_cons();
  80027a:	e8 b0 13 00 00       	call   80162f <sys_lock_cons>
		{
			(*finishedCount)++ ;
  80027f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800282:	8b 00                	mov    (%eax),%eax
  800284:	8d 50 01             	lea    0x1(%eax),%edx
  800287:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80028a:	89 10                	mov    %edx,(%eax)
		}
		sys_unlock_cons();
  80028c:	e8 b8 13 00 00       	call   801649 <sys_unlock_cons>
	}


}
  800291:	90                   	nop
  800292:	c9                   	leave  
  800293:	c3                   	ret    

00800294 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800294:	55                   	push   %ebp
  800295:	89 e5                	mov    %esp,%ebp
  800297:	57                   	push   %edi
  800298:	56                   	push   %esi
  800299:	53                   	push   %ebx
  80029a:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80029d:	e8 06 16 00 00       	call   8018a8 <sys_getenvindex>
  8002a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8002a5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002a8:	89 d0                	mov    %edx,%eax
  8002aa:	c1 e0 02             	shl    $0x2,%eax
  8002ad:	01 d0                	add    %edx,%eax
  8002af:	c1 e0 03             	shl    $0x3,%eax
  8002b2:	01 d0                	add    %edx,%eax
  8002b4:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8002bb:	01 d0                	add    %edx,%eax
  8002bd:	c1 e0 02             	shl    $0x2,%eax
  8002c0:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002c5:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8002ca:	a1 20 30 80 00       	mov    0x803020,%eax
  8002cf:	8a 40 20             	mov    0x20(%eax),%al
  8002d2:	84 c0                	test   %al,%al
  8002d4:	74 0d                	je     8002e3 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8002d6:	a1 20 30 80 00       	mov    0x803020,%eax
  8002db:	83 c0 20             	add    $0x20,%eax
  8002de:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002e3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8002e7:	7e 0a                	jle    8002f3 <libmain+0x5f>
		binaryname = argv[0];
  8002e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ec:	8b 00                	mov    (%eax),%eax
  8002ee:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  8002f3:	83 ec 08             	sub    $0x8,%esp
  8002f6:	ff 75 0c             	pushl  0xc(%ebp)
  8002f9:	ff 75 08             	pushl  0x8(%ebp)
  8002fc:	e8 37 fd ff ff       	call   800038 <_main>
  800301:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800304:	a1 00 30 80 00       	mov    0x803000,%eax
  800309:	85 c0                	test   %eax,%eax
  80030b:	0f 84 01 01 00 00    	je     800412 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800311:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800317:	bb 70 24 80 00       	mov    $0x802470,%ebx
  80031c:	ba 0e 00 00 00       	mov    $0xe,%edx
  800321:	89 c7                	mov    %eax,%edi
  800323:	89 de                	mov    %ebx,%esi
  800325:	89 d1                	mov    %edx,%ecx
  800327:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800329:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80032c:	b9 56 00 00 00       	mov    $0x56,%ecx
  800331:	b0 00                	mov    $0x0,%al
  800333:	89 d7                	mov    %edx,%edi
  800335:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800337:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80033e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800341:	83 ec 08             	sub    $0x8,%esp
  800344:	50                   	push   %eax
  800345:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80034b:	50                   	push   %eax
  80034c:	e8 8d 17 00 00       	call   801ade <sys_utilities>
  800351:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800354:	e8 d6 12 00 00       	call   80162f <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800359:	83 ec 0c             	sub    $0xc,%esp
  80035c:	68 90 23 80 00       	push   $0x802390
  800361:	e8 be 01 00 00       	call   800524 <cprintf>
  800366:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800369:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80036c:	85 c0                	test   %eax,%eax
  80036e:	74 18                	je     800388 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800370:	e8 87 17 00 00       	call   801afc <sys_get_optimal_num_faults>
  800375:	83 ec 08             	sub    $0x8,%esp
  800378:	50                   	push   %eax
  800379:	68 b8 23 80 00       	push   $0x8023b8
  80037e:	e8 a1 01 00 00       	call   800524 <cprintf>
  800383:	83 c4 10             	add    $0x10,%esp
  800386:	eb 59                	jmp    8003e1 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800388:	a1 20 30 80 00       	mov    0x803020,%eax
  80038d:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  800393:	a1 20 30 80 00       	mov    0x803020,%eax
  800398:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  80039e:	83 ec 04             	sub    $0x4,%esp
  8003a1:	52                   	push   %edx
  8003a2:	50                   	push   %eax
  8003a3:	68 dc 23 80 00       	push   $0x8023dc
  8003a8:	e8 77 01 00 00       	call   800524 <cprintf>
  8003ad:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8003b0:	a1 20 30 80 00       	mov    0x803020,%eax
  8003b5:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8003bb:	a1 20 30 80 00       	mov    0x803020,%eax
  8003c0:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  8003c6:	a1 20 30 80 00       	mov    0x803020,%eax
  8003cb:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  8003d1:	51                   	push   %ecx
  8003d2:	52                   	push   %edx
  8003d3:	50                   	push   %eax
  8003d4:	68 04 24 80 00       	push   $0x802404
  8003d9:	e8 46 01 00 00       	call   800524 <cprintf>
  8003de:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8003e1:	a1 20 30 80 00       	mov    0x803020,%eax
  8003e6:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  8003ec:	83 ec 08             	sub    $0x8,%esp
  8003ef:	50                   	push   %eax
  8003f0:	68 5c 24 80 00       	push   $0x80245c
  8003f5:	e8 2a 01 00 00       	call   800524 <cprintf>
  8003fa:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8003fd:	83 ec 0c             	sub    $0xc,%esp
  800400:	68 90 23 80 00       	push   $0x802390
  800405:	e8 1a 01 00 00       	call   800524 <cprintf>
  80040a:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80040d:	e8 37 12 00 00       	call   801649 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800412:	e8 1f 00 00 00       	call   800436 <exit>
}
  800417:	90                   	nop
  800418:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80041b:	5b                   	pop    %ebx
  80041c:	5e                   	pop    %esi
  80041d:	5f                   	pop    %edi
  80041e:	5d                   	pop    %ebp
  80041f:	c3                   	ret    

00800420 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800420:	55                   	push   %ebp
  800421:	89 e5                	mov    %esp,%ebp
  800423:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800426:	83 ec 0c             	sub    $0xc,%esp
  800429:	6a 00                	push   $0x0
  80042b:	e8 44 14 00 00       	call   801874 <sys_destroy_env>
  800430:	83 c4 10             	add    $0x10,%esp
}
  800433:	90                   	nop
  800434:	c9                   	leave  
  800435:	c3                   	ret    

00800436 <exit>:

void
exit(void)
{
  800436:	55                   	push   %ebp
  800437:	89 e5                	mov    %esp,%ebp
  800439:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80043c:	e8 99 14 00 00       	call   8018da <sys_exit_env>
}
  800441:	90                   	nop
  800442:	c9                   	leave  
  800443:	c3                   	ret    

00800444 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800444:	55                   	push   %ebp
  800445:	89 e5                	mov    %esp,%ebp
  800447:	53                   	push   %ebx
  800448:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  80044b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80044e:	8b 00                	mov    (%eax),%eax
  800450:	8d 48 01             	lea    0x1(%eax),%ecx
  800453:	8b 55 0c             	mov    0xc(%ebp),%edx
  800456:	89 0a                	mov    %ecx,(%edx)
  800458:	8b 55 08             	mov    0x8(%ebp),%edx
  80045b:	88 d1                	mov    %dl,%cl
  80045d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800460:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800464:	8b 45 0c             	mov    0xc(%ebp),%eax
  800467:	8b 00                	mov    (%eax),%eax
  800469:	3d ff 00 00 00       	cmp    $0xff,%eax
  80046e:	75 30                	jne    8004a0 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800470:	8b 15 18 b1 81 00    	mov    0x81b118,%edx
  800476:	a0 44 30 80 00       	mov    0x803044,%al
  80047b:	0f b6 c0             	movzbl %al,%eax
  80047e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800481:	8b 09                	mov    (%ecx),%ecx
  800483:	89 cb                	mov    %ecx,%ebx
  800485:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800488:	83 c1 08             	add    $0x8,%ecx
  80048b:	52                   	push   %edx
  80048c:	50                   	push   %eax
  80048d:	53                   	push   %ebx
  80048e:	51                   	push   %ecx
  80048f:	e8 57 11 00 00       	call   8015eb <sys_cputs>
  800494:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800497:	8b 45 0c             	mov    0xc(%ebp),%eax
  80049a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004a3:	8b 40 04             	mov    0x4(%eax),%eax
  8004a6:	8d 50 01             	lea    0x1(%eax),%edx
  8004a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ac:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004af:	90                   	nop
  8004b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004b3:	c9                   	leave  
  8004b4:	c3                   	ret    

008004b5 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004b5:	55                   	push   %ebp
  8004b6:	89 e5                	mov    %esp,%ebp
  8004b8:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004be:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004c5:	00 00 00 
	b.cnt = 0;
  8004c8:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004cf:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004d2:	ff 75 0c             	pushl  0xc(%ebp)
  8004d5:	ff 75 08             	pushl  0x8(%ebp)
  8004d8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004de:	50                   	push   %eax
  8004df:	68 44 04 80 00       	push   $0x800444
  8004e4:	e8 5a 02 00 00       	call   800743 <vprintfmt>
  8004e9:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8004ec:	8b 15 18 b1 81 00    	mov    0x81b118,%edx
  8004f2:	a0 44 30 80 00       	mov    0x803044,%al
  8004f7:	0f b6 c0             	movzbl %al,%eax
  8004fa:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800500:	52                   	push   %edx
  800501:	50                   	push   %eax
  800502:	51                   	push   %ecx
  800503:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800509:	83 c0 08             	add    $0x8,%eax
  80050c:	50                   	push   %eax
  80050d:	e8 d9 10 00 00       	call   8015eb <sys_cputs>
  800512:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800515:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  80051c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800522:	c9                   	leave  
  800523:	c3                   	ret    

00800524 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800524:	55                   	push   %ebp
  800525:	89 e5                	mov    %esp,%ebp
  800527:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80052a:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  800531:	8d 45 0c             	lea    0xc(%ebp),%eax
  800534:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800537:	8b 45 08             	mov    0x8(%ebp),%eax
  80053a:	83 ec 08             	sub    $0x8,%esp
  80053d:	ff 75 f4             	pushl  -0xc(%ebp)
  800540:	50                   	push   %eax
  800541:	e8 6f ff ff ff       	call   8004b5 <vcprintf>
  800546:	83 c4 10             	add    $0x10,%esp
  800549:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80054c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80054f:	c9                   	leave  
  800550:	c3                   	ret    

00800551 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800551:	55                   	push   %ebp
  800552:	89 e5                	mov    %esp,%ebp
  800554:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800557:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  80055e:	8b 45 08             	mov    0x8(%ebp),%eax
  800561:	c1 e0 08             	shl    $0x8,%eax
  800564:	a3 18 b1 81 00       	mov    %eax,0x81b118
	va_start(ap, fmt);
  800569:	8d 45 0c             	lea    0xc(%ebp),%eax
  80056c:	83 c0 04             	add    $0x4,%eax
  80056f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800572:	8b 45 0c             	mov    0xc(%ebp),%eax
  800575:	83 ec 08             	sub    $0x8,%esp
  800578:	ff 75 f4             	pushl  -0xc(%ebp)
  80057b:	50                   	push   %eax
  80057c:	e8 34 ff ff ff       	call   8004b5 <vcprintf>
  800581:	83 c4 10             	add    $0x10,%esp
  800584:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800587:	c7 05 18 b1 81 00 00 	movl   $0x700,0x81b118
  80058e:	07 00 00 

	return cnt;
  800591:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800594:	c9                   	leave  
  800595:	c3                   	ret    

00800596 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800596:	55                   	push   %ebp
  800597:	89 e5                	mov    %esp,%ebp
  800599:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80059c:	e8 8e 10 00 00       	call   80162f <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8005a1:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8005a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005aa:	83 ec 08             	sub    $0x8,%esp
  8005ad:	ff 75 f4             	pushl  -0xc(%ebp)
  8005b0:	50                   	push   %eax
  8005b1:	e8 ff fe ff ff       	call   8004b5 <vcprintf>
  8005b6:	83 c4 10             	add    $0x10,%esp
  8005b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8005bc:	e8 88 10 00 00       	call   801649 <sys_unlock_cons>
	return cnt;
  8005c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005c4:	c9                   	leave  
  8005c5:	c3                   	ret    

008005c6 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005c6:	55                   	push   %ebp
  8005c7:	89 e5                	mov    %esp,%ebp
  8005c9:	53                   	push   %ebx
  8005ca:	83 ec 14             	sub    $0x14,%esp
  8005cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8005d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005d9:	8b 45 18             	mov    0x18(%ebp),%eax
  8005dc:	ba 00 00 00 00       	mov    $0x0,%edx
  8005e1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005e4:	77 55                	ja     80063b <printnum+0x75>
  8005e6:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005e9:	72 05                	jb     8005f0 <printnum+0x2a>
  8005eb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005ee:	77 4b                	ja     80063b <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005f0:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005f3:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005f6:	8b 45 18             	mov    0x18(%ebp),%eax
  8005f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8005fe:	52                   	push   %edx
  8005ff:	50                   	push   %eax
  800600:	ff 75 f4             	pushl  -0xc(%ebp)
  800603:	ff 75 f0             	pushl  -0x10(%ebp)
  800606:	e8 d1 1a 00 00       	call   8020dc <__udivdi3>
  80060b:	83 c4 10             	add    $0x10,%esp
  80060e:	83 ec 04             	sub    $0x4,%esp
  800611:	ff 75 20             	pushl  0x20(%ebp)
  800614:	53                   	push   %ebx
  800615:	ff 75 18             	pushl  0x18(%ebp)
  800618:	52                   	push   %edx
  800619:	50                   	push   %eax
  80061a:	ff 75 0c             	pushl  0xc(%ebp)
  80061d:	ff 75 08             	pushl  0x8(%ebp)
  800620:	e8 a1 ff ff ff       	call   8005c6 <printnum>
  800625:	83 c4 20             	add    $0x20,%esp
  800628:	eb 1a                	jmp    800644 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80062a:	83 ec 08             	sub    $0x8,%esp
  80062d:	ff 75 0c             	pushl  0xc(%ebp)
  800630:	ff 75 20             	pushl  0x20(%ebp)
  800633:	8b 45 08             	mov    0x8(%ebp),%eax
  800636:	ff d0                	call   *%eax
  800638:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80063b:	ff 4d 1c             	decl   0x1c(%ebp)
  80063e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800642:	7f e6                	jg     80062a <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800644:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800647:	bb 00 00 00 00       	mov    $0x0,%ebx
  80064c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80064f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800652:	53                   	push   %ebx
  800653:	51                   	push   %ecx
  800654:	52                   	push   %edx
  800655:	50                   	push   %eax
  800656:	e8 91 1b 00 00       	call   8021ec <__umoddi3>
  80065b:	83 c4 10             	add    $0x10,%esp
  80065e:	05 f4 26 80 00       	add    $0x8026f4,%eax
  800663:	8a 00                	mov    (%eax),%al
  800665:	0f be c0             	movsbl %al,%eax
  800668:	83 ec 08             	sub    $0x8,%esp
  80066b:	ff 75 0c             	pushl  0xc(%ebp)
  80066e:	50                   	push   %eax
  80066f:	8b 45 08             	mov    0x8(%ebp),%eax
  800672:	ff d0                	call   *%eax
  800674:	83 c4 10             	add    $0x10,%esp
}
  800677:	90                   	nop
  800678:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80067b:	c9                   	leave  
  80067c:	c3                   	ret    

0080067d <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80067d:	55                   	push   %ebp
  80067e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800680:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800684:	7e 1c                	jle    8006a2 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800686:	8b 45 08             	mov    0x8(%ebp),%eax
  800689:	8b 00                	mov    (%eax),%eax
  80068b:	8d 50 08             	lea    0x8(%eax),%edx
  80068e:	8b 45 08             	mov    0x8(%ebp),%eax
  800691:	89 10                	mov    %edx,(%eax)
  800693:	8b 45 08             	mov    0x8(%ebp),%eax
  800696:	8b 00                	mov    (%eax),%eax
  800698:	83 e8 08             	sub    $0x8,%eax
  80069b:	8b 50 04             	mov    0x4(%eax),%edx
  80069e:	8b 00                	mov    (%eax),%eax
  8006a0:	eb 40                	jmp    8006e2 <getuint+0x65>
	else if (lflag)
  8006a2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006a6:	74 1e                	je     8006c6 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ab:	8b 00                	mov    (%eax),%eax
  8006ad:	8d 50 04             	lea    0x4(%eax),%edx
  8006b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b3:	89 10                	mov    %edx,(%eax)
  8006b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b8:	8b 00                	mov    (%eax),%eax
  8006ba:	83 e8 04             	sub    $0x4,%eax
  8006bd:	8b 00                	mov    (%eax),%eax
  8006bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8006c4:	eb 1c                	jmp    8006e2 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c9:	8b 00                	mov    (%eax),%eax
  8006cb:	8d 50 04             	lea    0x4(%eax),%edx
  8006ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d1:	89 10                	mov    %edx,(%eax)
  8006d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d6:	8b 00                	mov    (%eax),%eax
  8006d8:	83 e8 04             	sub    $0x4,%eax
  8006db:	8b 00                	mov    (%eax),%eax
  8006dd:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006e2:	5d                   	pop    %ebp
  8006e3:	c3                   	ret    

008006e4 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006e4:	55                   	push   %ebp
  8006e5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006e7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006eb:	7e 1c                	jle    800709 <getint+0x25>
		return va_arg(*ap, long long);
  8006ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f0:	8b 00                	mov    (%eax),%eax
  8006f2:	8d 50 08             	lea    0x8(%eax),%edx
  8006f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f8:	89 10                	mov    %edx,(%eax)
  8006fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fd:	8b 00                	mov    (%eax),%eax
  8006ff:	83 e8 08             	sub    $0x8,%eax
  800702:	8b 50 04             	mov    0x4(%eax),%edx
  800705:	8b 00                	mov    (%eax),%eax
  800707:	eb 38                	jmp    800741 <getint+0x5d>
	else if (lflag)
  800709:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80070d:	74 1a                	je     800729 <getint+0x45>
		return va_arg(*ap, long);
  80070f:	8b 45 08             	mov    0x8(%ebp),%eax
  800712:	8b 00                	mov    (%eax),%eax
  800714:	8d 50 04             	lea    0x4(%eax),%edx
  800717:	8b 45 08             	mov    0x8(%ebp),%eax
  80071a:	89 10                	mov    %edx,(%eax)
  80071c:	8b 45 08             	mov    0x8(%ebp),%eax
  80071f:	8b 00                	mov    (%eax),%eax
  800721:	83 e8 04             	sub    $0x4,%eax
  800724:	8b 00                	mov    (%eax),%eax
  800726:	99                   	cltd   
  800727:	eb 18                	jmp    800741 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800729:	8b 45 08             	mov    0x8(%ebp),%eax
  80072c:	8b 00                	mov    (%eax),%eax
  80072e:	8d 50 04             	lea    0x4(%eax),%edx
  800731:	8b 45 08             	mov    0x8(%ebp),%eax
  800734:	89 10                	mov    %edx,(%eax)
  800736:	8b 45 08             	mov    0x8(%ebp),%eax
  800739:	8b 00                	mov    (%eax),%eax
  80073b:	83 e8 04             	sub    $0x4,%eax
  80073e:	8b 00                	mov    (%eax),%eax
  800740:	99                   	cltd   
}
  800741:	5d                   	pop    %ebp
  800742:	c3                   	ret    

00800743 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800743:	55                   	push   %ebp
  800744:	89 e5                	mov    %esp,%ebp
  800746:	56                   	push   %esi
  800747:	53                   	push   %ebx
  800748:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80074b:	eb 17                	jmp    800764 <vprintfmt+0x21>
			if (ch == '\0')
  80074d:	85 db                	test   %ebx,%ebx
  80074f:	0f 84 c1 03 00 00    	je     800b16 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800755:	83 ec 08             	sub    $0x8,%esp
  800758:	ff 75 0c             	pushl  0xc(%ebp)
  80075b:	53                   	push   %ebx
  80075c:	8b 45 08             	mov    0x8(%ebp),%eax
  80075f:	ff d0                	call   *%eax
  800761:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800764:	8b 45 10             	mov    0x10(%ebp),%eax
  800767:	8d 50 01             	lea    0x1(%eax),%edx
  80076a:	89 55 10             	mov    %edx,0x10(%ebp)
  80076d:	8a 00                	mov    (%eax),%al
  80076f:	0f b6 d8             	movzbl %al,%ebx
  800772:	83 fb 25             	cmp    $0x25,%ebx
  800775:	75 d6                	jne    80074d <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800777:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80077b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800782:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800789:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800790:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800797:	8b 45 10             	mov    0x10(%ebp),%eax
  80079a:	8d 50 01             	lea    0x1(%eax),%edx
  80079d:	89 55 10             	mov    %edx,0x10(%ebp)
  8007a0:	8a 00                	mov    (%eax),%al
  8007a2:	0f b6 d8             	movzbl %al,%ebx
  8007a5:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007a8:	83 f8 5b             	cmp    $0x5b,%eax
  8007ab:	0f 87 3d 03 00 00    	ja     800aee <vprintfmt+0x3ab>
  8007b1:	8b 04 85 18 27 80 00 	mov    0x802718(,%eax,4),%eax
  8007b8:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007ba:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007be:	eb d7                	jmp    800797 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007c0:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007c4:	eb d1                	jmp    800797 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007c6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007cd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007d0:	89 d0                	mov    %edx,%eax
  8007d2:	c1 e0 02             	shl    $0x2,%eax
  8007d5:	01 d0                	add    %edx,%eax
  8007d7:	01 c0                	add    %eax,%eax
  8007d9:	01 d8                	add    %ebx,%eax
  8007db:	83 e8 30             	sub    $0x30,%eax
  8007de:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8007e4:	8a 00                	mov    (%eax),%al
  8007e6:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007e9:	83 fb 2f             	cmp    $0x2f,%ebx
  8007ec:	7e 3e                	jle    80082c <vprintfmt+0xe9>
  8007ee:	83 fb 39             	cmp    $0x39,%ebx
  8007f1:	7f 39                	jg     80082c <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007f3:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007f6:	eb d5                	jmp    8007cd <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fb:	83 c0 04             	add    $0x4,%eax
  8007fe:	89 45 14             	mov    %eax,0x14(%ebp)
  800801:	8b 45 14             	mov    0x14(%ebp),%eax
  800804:	83 e8 04             	sub    $0x4,%eax
  800807:	8b 00                	mov    (%eax),%eax
  800809:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80080c:	eb 1f                	jmp    80082d <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80080e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800812:	79 83                	jns    800797 <vprintfmt+0x54>
				width = 0;
  800814:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80081b:	e9 77 ff ff ff       	jmp    800797 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800820:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800827:	e9 6b ff ff ff       	jmp    800797 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80082c:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80082d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800831:	0f 89 60 ff ff ff    	jns    800797 <vprintfmt+0x54>
				width = precision, precision = -1;
  800837:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80083a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80083d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800844:	e9 4e ff ff ff       	jmp    800797 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800849:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80084c:	e9 46 ff ff ff       	jmp    800797 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800851:	8b 45 14             	mov    0x14(%ebp),%eax
  800854:	83 c0 04             	add    $0x4,%eax
  800857:	89 45 14             	mov    %eax,0x14(%ebp)
  80085a:	8b 45 14             	mov    0x14(%ebp),%eax
  80085d:	83 e8 04             	sub    $0x4,%eax
  800860:	8b 00                	mov    (%eax),%eax
  800862:	83 ec 08             	sub    $0x8,%esp
  800865:	ff 75 0c             	pushl  0xc(%ebp)
  800868:	50                   	push   %eax
  800869:	8b 45 08             	mov    0x8(%ebp),%eax
  80086c:	ff d0                	call   *%eax
  80086e:	83 c4 10             	add    $0x10,%esp
			break;
  800871:	e9 9b 02 00 00       	jmp    800b11 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800876:	8b 45 14             	mov    0x14(%ebp),%eax
  800879:	83 c0 04             	add    $0x4,%eax
  80087c:	89 45 14             	mov    %eax,0x14(%ebp)
  80087f:	8b 45 14             	mov    0x14(%ebp),%eax
  800882:	83 e8 04             	sub    $0x4,%eax
  800885:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800887:	85 db                	test   %ebx,%ebx
  800889:	79 02                	jns    80088d <vprintfmt+0x14a>
				err = -err;
  80088b:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80088d:	83 fb 64             	cmp    $0x64,%ebx
  800890:	7f 0b                	jg     80089d <vprintfmt+0x15a>
  800892:	8b 34 9d 60 25 80 00 	mov    0x802560(,%ebx,4),%esi
  800899:	85 f6                	test   %esi,%esi
  80089b:	75 19                	jne    8008b6 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80089d:	53                   	push   %ebx
  80089e:	68 05 27 80 00       	push   $0x802705
  8008a3:	ff 75 0c             	pushl  0xc(%ebp)
  8008a6:	ff 75 08             	pushl  0x8(%ebp)
  8008a9:	e8 70 02 00 00       	call   800b1e <printfmt>
  8008ae:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008b1:	e9 5b 02 00 00       	jmp    800b11 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008b6:	56                   	push   %esi
  8008b7:	68 0e 27 80 00       	push   $0x80270e
  8008bc:	ff 75 0c             	pushl  0xc(%ebp)
  8008bf:	ff 75 08             	pushl  0x8(%ebp)
  8008c2:	e8 57 02 00 00       	call   800b1e <printfmt>
  8008c7:	83 c4 10             	add    $0x10,%esp
			break;
  8008ca:	e9 42 02 00 00       	jmp    800b11 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d2:	83 c0 04             	add    $0x4,%eax
  8008d5:	89 45 14             	mov    %eax,0x14(%ebp)
  8008d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008db:	83 e8 04             	sub    $0x4,%eax
  8008de:	8b 30                	mov    (%eax),%esi
  8008e0:	85 f6                	test   %esi,%esi
  8008e2:	75 05                	jne    8008e9 <vprintfmt+0x1a6>
				p = "(null)";
  8008e4:	be 11 27 80 00       	mov    $0x802711,%esi
			if (width > 0 && padc != '-')
  8008e9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ed:	7e 6d                	jle    80095c <vprintfmt+0x219>
  8008ef:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008f3:	74 67                	je     80095c <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008f8:	83 ec 08             	sub    $0x8,%esp
  8008fb:	50                   	push   %eax
  8008fc:	56                   	push   %esi
  8008fd:	e8 1e 03 00 00       	call   800c20 <strnlen>
  800902:	83 c4 10             	add    $0x10,%esp
  800905:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800908:	eb 16                	jmp    800920 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80090a:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80090e:	83 ec 08             	sub    $0x8,%esp
  800911:	ff 75 0c             	pushl  0xc(%ebp)
  800914:	50                   	push   %eax
  800915:	8b 45 08             	mov    0x8(%ebp),%eax
  800918:	ff d0                	call   *%eax
  80091a:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80091d:	ff 4d e4             	decl   -0x1c(%ebp)
  800920:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800924:	7f e4                	jg     80090a <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800926:	eb 34                	jmp    80095c <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800928:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80092c:	74 1c                	je     80094a <vprintfmt+0x207>
  80092e:	83 fb 1f             	cmp    $0x1f,%ebx
  800931:	7e 05                	jle    800938 <vprintfmt+0x1f5>
  800933:	83 fb 7e             	cmp    $0x7e,%ebx
  800936:	7e 12                	jle    80094a <vprintfmt+0x207>
					putch('?', putdat);
  800938:	83 ec 08             	sub    $0x8,%esp
  80093b:	ff 75 0c             	pushl  0xc(%ebp)
  80093e:	6a 3f                	push   $0x3f
  800940:	8b 45 08             	mov    0x8(%ebp),%eax
  800943:	ff d0                	call   *%eax
  800945:	83 c4 10             	add    $0x10,%esp
  800948:	eb 0f                	jmp    800959 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80094a:	83 ec 08             	sub    $0x8,%esp
  80094d:	ff 75 0c             	pushl  0xc(%ebp)
  800950:	53                   	push   %ebx
  800951:	8b 45 08             	mov    0x8(%ebp),%eax
  800954:	ff d0                	call   *%eax
  800956:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800959:	ff 4d e4             	decl   -0x1c(%ebp)
  80095c:	89 f0                	mov    %esi,%eax
  80095e:	8d 70 01             	lea    0x1(%eax),%esi
  800961:	8a 00                	mov    (%eax),%al
  800963:	0f be d8             	movsbl %al,%ebx
  800966:	85 db                	test   %ebx,%ebx
  800968:	74 24                	je     80098e <vprintfmt+0x24b>
  80096a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80096e:	78 b8                	js     800928 <vprintfmt+0x1e5>
  800970:	ff 4d e0             	decl   -0x20(%ebp)
  800973:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800977:	79 af                	jns    800928 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800979:	eb 13                	jmp    80098e <vprintfmt+0x24b>
				putch(' ', putdat);
  80097b:	83 ec 08             	sub    $0x8,%esp
  80097e:	ff 75 0c             	pushl  0xc(%ebp)
  800981:	6a 20                	push   $0x20
  800983:	8b 45 08             	mov    0x8(%ebp),%eax
  800986:	ff d0                	call   *%eax
  800988:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80098b:	ff 4d e4             	decl   -0x1c(%ebp)
  80098e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800992:	7f e7                	jg     80097b <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800994:	e9 78 01 00 00       	jmp    800b11 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800999:	83 ec 08             	sub    $0x8,%esp
  80099c:	ff 75 e8             	pushl  -0x18(%ebp)
  80099f:	8d 45 14             	lea    0x14(%ebp),%eax
  8009a2:	50                   	push   %eax
  8009a3:	e8 3c fd ff ff       	call   8006e4 <getint>
  8009a8:	83 c4 10             	add    $0x10,%esp
  8009ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009ae:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009b7:	85 d2                	test   %edx,%edx
  8009b9:	79 23                	jns    8009de <vprintfmt+0x29b>
				putch('-', putdat);
  8009bb:	83 ec 08             	sub    $0x8,%esp
  8009be:	ff 75 0c             	pushl  0xc(%ebp)
  8009c1:	6a 2d                	push   $0x2d
  8009c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c6:	ff d0                	call   *%eax
  8009c8:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009d1:	f7 d8                	neg    %eax
  8009d3:	83 d2 00             	adc    $0x0,%edx
  8009d6:	f7 da                	neg    %edx
  8009d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009db:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009de:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009e5:	e9 bc 00 00 00       	jmp    800aa6 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009ea:	83 ec 08             	sub    $0x8,%esp
  8009ed:	ff 75 e8             	pushl  -0x18(%ebp)
  8009f0:	8d 45 14             	lea    0x14(%ebp),%eax
  8009f3:	50                   	push   %eax
  8009f4:	e8 84 fc ff ff       	call   80067d <getuint>
  8009f9:	83 c4 10             	add    $0x10,%esp
  8009fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009ff:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a02:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a09:	e9 98 00 00 00       	jmp    800aa6 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a0e:	83 ec 08             	sub    $0x8,%esp
  800a11:	ff 75 0c             	pushl  0xc(%ebp)
  800a14:	6a 58                	push   $0x58
  800a16:	8b 45 08             	mov    0x8(%ebp),%eax
  800a19:	ff d0                	call   *%eax
  800a1b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a1e:	83 ec 08             	sub    $0x8,%esp
  800a21:	ff 75 0c             	pushl  0xc(%ebp)
  800a24:	6a 58                	push   $0x58
  800a26:	8b 45 08             	mov    0x8(%ebp),%eax
  800a29:	ff d0                	call   *%eax
  800a2b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a2e:	83 ec 08             	sub    $0x8,%esp
  800a31:	ff 75 0c             	pushl  0xc(%ebp)
  800a34:	6a 58                	push   $0x58
  800a36:	8b 45 08             	mov    0x8(%ebp),%eax
  800a39:	ff d0                	call   *%eax
  800a3b:	83 c4 10             	add    $0x10,%esp
			break;
  800a3e:	e9 ce 00 00 00       	jmp    800b11 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800a43:	83 ec 08             	sub    $0x8,%esp
  800a46:	ff 75 0c             	pushl  0xc(%ebp)
  800a49:	6a 30                	push   $0x30
  800a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4e:	ff d0                	call   *%eax
  800a50:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a53:	83 ec 08             	sub    $0x8,%esp
  800a56:	ff 75 0c             	pushl  0xc(%ebp)
  800a59:	6a 78                	push   $0x78
  800a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5e:	ff d0                	call   *%eax
  800a60:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a63:	8b 45 14             	mov    0x14(%ebp),%eax
  800a66:	83 c0 04             	add    $0x4,%eax
  800a69:	89 45 14             	mov    %eax,0x14(%ebp)
  800a6c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6f:	83 e8 04             	sub    $0x4,%eax
  800a72:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a74:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a77:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a7e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a85:	eb 1f                	jmp    800aa6 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a87:	83 ec 08             	sub    $0x8,%esp
  800a8a:	ff 75 e8             	pushl  -0x18(%ebp)
  800a8d:	8d 45 14             	lea    0x14(%ebp),%eax
  800a90:	50                   	push   %eax
  800a91:	e8 e7 fb ff ff       	call   80067d <getuint>
  800a96:	83 c4 10             	add    $0x10,%esp
  800a99:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a9c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a9f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800aa6:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800aaa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800aad:	83 ec 04             	sub    $0x4,%esp
  800ab0:	52                   	push   %edx
  800ab1:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ab4:	50                   	push   %eax
  800ab5:	ff 75 f4             	pushl  -0xc(%ebp)
  800ab8:	ff 75 f0             	pushl  -0x10(%ebp)
  800abb:	ff 75 0c             	pushl  0xc(%ebp)
  800abe:	ff 75 08             	pushl  0x8(%ebp)
  800ac1:	e8 00 fb ff ff       	call   8005c6 <printnum>
  800ac6:	83 c4 20             	add    $0x20,%esp
			break;
  800ac9:	eb 46                	jmp    800b11 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800acb:	83 ec 08             	sub    $0x8,%esp
  800ace:	ff 75 0c             	pushl  0xc(%ebp)
  800ad1:	53                   	push   %ebx
  800ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad5:	ff d0                	call   *%eax
  800ad7:	83 c4 10             	add    $0x10,%esp
			break;
  800ada:	eb 35                	jmp    800b11 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800adc:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800ae3:	eb 2c                	jmp    800b11 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800ae5:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800aec:	eb 23                	jmp    800b11 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800aee:	83 ec 08             	sub    $0x8,%esp
  800af1:	ff 75 0c             	pushl  0xc(%ebp)
  800af4:	6a 25                	push   $0x25
  800af6:	8b 45 08             	mov    0x8(%ebp),%eax
  800af9:	ff d0                	call   *%eax
  800afb:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800afe:	ff 4d 10             	decl   0x10(%ebp)
  800b01:	eb 03                	jmp    800b06 <vprintfmt+0x3c3>
  800b03:	ff 4d 10             	decl   0x10(%ebp)
  800b06:	8b 45 10             	mov    0x10(%ebp),%eax
  800b09:	48                   	dec    %eax
  800b0a:	8a 00                	mov    (%eax),%al
  800b0c:	3c 25                	cmp    $0x25,%al
  800b0e:	75 f3                	jne    800b03 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800b10:	90                   	nop
		}
	}
  800b11:	e9 35 fc ff ff       	jmp    80074b <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b16:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b17:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b1a:	5b                   	pop    %ebx
  800b1b:	5e                   	pop    %esi
  800b1c:	5d                   	pop    %ebp
  800b1d:	c3                   	ret    

00800b1e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b1e:	55                   	push   %ebp
  800b1f:	89 e5                	mov    %esp,%ebp
  800b21:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b24:	8d 45 10             	lea    0x10(%ebp),%eax
  800b27:	83 c0 04             	add    $0x4,%eax
  800b2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b2d:	8b 45 10             	mov    0x10(%ebp),%eax
  800b30:	ff 75 f4             	pushl  -0xc(%ebp)
  800b33:	50                   	push   %eax
  800b34:	ff 75 0c             	pushl  0xc(%ebp)
  800b37:	ff 75 08             	pushl  0x8(%ebp)
  800b3a:	e8 04 fc ff ff       	call   800743 <vprintfmt>
  800b3f:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b42:	90                   	nop
  800b43:	c9                   	leave  
  800b44:	c3                   	ret    

00800b45 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b45:	55                   	push   %ebp
  800b46:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4b:	8b 40 08             	mov    0x8(%eax),%eax
  800b4e:	8d 50 01             	lea    0x1(%eax),%edx
  800b51:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b54:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5a:	8b 10                	mov    (%eax),%edx
  800b5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5f:	8b 40 04             	mov    0x4(%eax),%eax
  800b62:	39 c2                	cmp    %eax,%edx
  800b64:	73 12                	jae    800b78 <sprintputch+0x33>
		*b->buf++ = ch;
  800b66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b69:	8b 00                	mov    (%eax),%eax
  800b6b:	8d 48 01             	lea    0x1(%eax),%ecx
  800b6e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b71:	89 0a                	mov    %ecx,(%edx)
  800b73:	8b 55 08             	mov    0x8(%ebp),%edx
  800b76:	88 10                	mov    %dl,(%eax)
}
  800b78:	90                   	nop
  800b79:	5d                   	pop    %ebp
  800b7a:	c3                   	ret    

00800b7b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b7b:	55                   	push   %ebp
  800b7c:	89 e5                	mov    %esp,%ebp
  800b7e:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b81:	8b 45 08             	mov    0x8(%ebp),%eax
  800b84:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b8a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b90:	01 d0                	add    %edx,%eax
  800b92:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b95:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b9c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ba0:	74 06                	je     800ba8 <vsnprintf+0x2d>
  800ba2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ba6:	7f 07                	jg     800baf <vsnprintf+0x34>
		return -E_INVAL;
  800ba8:	b8 03 00 00 00       	mov    $0x3,%eax
  800bad:	eb 20                	jmp    800bcf <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800baf:	ff 75 14             	pushl  0x14(%ebp)
  800bb2:	ff 75 10             	pushl  0x10(%ebp)
  800bb5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bb8:	50                   	push   %eax
  800bb9:	68 45 0b 80 00       	push   $0x800b45
  800bbe:	e8 80 fb ff ff       	call   800743 <vprintfmt>
  800bc3:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800bc6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bc9:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800bcf:	c9                   	leave  
  800bd0:	c3                   	ret    

00800bd1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bd1:	55                   	push   %ebp
  800bd2:	89 e5                	mov    %esp,%ebp
  800bd4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bd7:	8d 45 10             	lea    0x10(%ebp),%eax
  800bda:	83 c0 04             	add    $0x4,%eax
  800bdd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800be0:	8b 45 10             	mov    0x10(%ebp),%eax
  800be3:	ff 75 f4             	pushl  -0xc(%ebp)
  800be6:	50                   	push   %eax
  800be7:	ff 75 0c             	pushl  0xc(%ebp)
  800bea:	ff 75 08             	pushl  0x8(%ebp)
  800bed:	e8 89 ff ff ff       	call   800b7b <vsnprintf>
  800bf2:	83 c4 10             	add    $0x10,%esp
  800bf5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bf8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bfb:	c9                   	leave  
  800bfc:	c3                   	ret    

00800bfd <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800bfd:	55                   	push   %ebp
  800bfe:	89 e5                	mov    %esp,%ebp
  800c00:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c03:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c0a:	eb 06                	jmp    800c12 <strlen+0x15>
		n++;
  800c0c:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c0f:	ff 45 08             	incl   0x8(%ebp)
  800c12:	8b 45 08             	mov    0x8(%ebp),%eax
  800c15:	8a 00                	mov    (%eax),%al
  800c17:	84 c0                	test   %al,%al
  800c19:	75 f1                	jne    800c0c <strlen+0xf>
		n++;
	return n;
  800c1b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c1e:	c9                   	leave  
  800c1f:	c3                   	ret    

00800c20 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c20:	55                   	push   %ebp
  800c21:	89 e5                	mov    %esp,%ebp
  800c23:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c26:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c2d:	eb 09                	jmp    800c38 <strnlen+0x18>
		n++;
  800c2f:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c32:	ff 45 08             	incl   0x8(%ebp)
  800c35:	ff 4d 0c             	decl   0xc(%ebp)
  800c38:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c3c:	74 09                	je     800c47 <strnlen+0x27>
  800c3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c41:	8a 00                	mov    (%eax),%al
  800c43:	84 c0                	test   %al,%al
  800c45:	75 e8                	jne    800c2f <strnlen+0xf>
		n++;
	return n;
  800c47:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c4a:	c9                   	leave  
  800c4b:	c3                   	ret    

00800c4c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c4c:	55                   	push   %ebp
  800c4d:	89 e5                	mov    %esp,%ebp
  800c4f:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c52:	8b 45 08             	mov    0x8(%ebp),%eax
  800c55:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c58:	90                   	nop
  800c59:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5c:	8d 50 01             	lea    0x1(%eax),%edx
  800c5f:	89 55 08             	mov    %edx,0x8(%ebp)
  800c62:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c65:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c68:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c6b:	8a 12                	mov    (%edx),%dl
  800c6d:	88 10                	mov    %dl,(%eax)
  800c6f:	8a 00                	mov    (%eax),%al
  800c71:	84 c0                	test   %al,%al
  800c73:	75 e4                	jne    800c59 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c75:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c78:	c9                   	leave  
  800c79:	c3                   	ret    

00800c7a <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c7a:	55                   	push   %ebp
  800c7b:	89 e5                	mov    %esp,%ebp
  800c7d:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c80:	8b 45 08             	mov    0x8(%ebp),%eax
  800c83:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c86:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c8d:	eb 1f                	jmp    800cae <strncpy+0x34>
		*dst++ = *src;
  800c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c92:	8d 50 01             	lea    0x1(%eax),%edx
  800c95:	89 55 08             	mov    %edx,0x8(%ebp)
  800c98:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c9b:	8a 12                	mov    (%edx),%dl
  800c9d:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca2:	8a 00                	mov    (%eax),%al
  800ca4:	84 c0                	test   %al,%al
  800ca6:	74 03                	je     800cab <strncpy+0x31>
			src++;
  800ca8:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800cab:	ff 45 fc             	incl   -0x4(%ebp)
  800cae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cb1:	3b 45 10             	cmp    0x10(%ebp),%eax
  800cb4:	72 d9                	jb     800c8f <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800cb6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800cb9:	c9                   	leave  
  800cba:	c3                   	ret    

00800cbb <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800cbb:	55                   	push   %ebp
  800cbc:	89 e5                	mov    %esp,%ebp
  800cbe:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800cc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800cc7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ccb:	74 30                	je     800cfd <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ccd:	eb 16                	jmp    800ce5 <strlcpy+0x2a>
			*dst++ = *src++;
  800ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd2:	8d 50 01             	lea    0x1(%eax),%edx
  800cd5:	89 55 08             	mov    %edx,0x8(%ebp)
  800cd8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cdb:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cde:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ce1:	8a 12                	mov    (%edx),%dl
  800ce3:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ce5:	ff 4d 10             	decl   0x10(%ebp)
  800ce8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cec:	74 09                	je     800cf7 <strlcpy+0x3c>
  800cee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf1:	8a 00                	mov    (%eax),%al
  800cf3:	84 c0                	test   %al,%al
  800cf5:	75 d8                	jne    800ccf <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfa:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cfd:	8b 55 08             	mov    0x8(%ebp),%edx
  800d00:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d03:	29 c2                	sub    %eax,%edx
  800d05:	89 d0                	mov    %edx,%eax
}
  800d07:	c9                   	leave  
  800d08:	c3                   	ret    

00800d09 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d09:	55                   	push   %ebp
  800d0a:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d0c:	eb 06                	jmp    800d14 <strcmp+0xb>
		p++, q++;
  800d0e:	ff 45 08             	incl   0x8(%ebp)
  800d11:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d14:	8b 45 08             	mov    0x8(%ebp),%eax
  800d17:	8a 00                	mov    (%eax),%al
  800d19:	84 c0                	test   %al,%al
  800d1b:	74 0e                	je     800d2b <strcmp+0x22>
  800d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d20:	8a 10                	mov    (%eax),%dl
  800d22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d25:	8a 00                	mov    (%eax),%al
  800d27:	38 c2                	cmp    %al,%dl
  800d29:	74 e3                	je     800d0e <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2e:	8a 00                	mov    (%eax),%al
  800d30:	0f b6 d0             	movzbl %al,%edx
  800d33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d36:	8a 00                	mov    (%eax),%al
  800d38:	0f b6 c0             	movzbl %al,%eax
  800d3b:	29 c2                	sub    %eax,%edx
  800d3d:	89 d0                	mov    %edx,%eax
}
  800d3f:	5d                   	pop    %ebp
  800d40:	c3                   	ret    

00800d41 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d41:	55                   	push   %ebp
  800d42:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d44:	eb 09                	jmp    800d4f <strncmp+0xe>
		n--, p++, q++;
  800d46:	ff 4d 10             	decl   0x10(%ebp)
  800d49:	ff 45 08             	incl   0x8(%ebp)
  800d4c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d4f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d53:	74 17                	je     800d6c <strncmp+0x2b>
  800d55:	8b 45 08             	mov    0x8(%ebp),%eax
  800d58:	8a 00                	mov    (%eax),%al
  800d5a:	84 c0                	test   %al,%al
  800d5c:	74 0e                	je     800d6c <strncmp+0x2b>
  800d5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d61:	8a 10                	mov    (%eax),%dl
  800d63:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d66:	8a 00                	mov    (%eax),%al
  800d68:	38 c2                	cmp    %al,%dl
  800d6a:	74 da                	je     800d46 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d6c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d70:	75 07                	jne    800d79 <strncmp+0x38>
		return 0;
  800d72:	b8 00 00 00 00       	mov    $0x0,%eax
  800d77:	eb 14                	jmp    800d8d <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d79:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7c:	8a 00                	mov    (%eax),%al
  800d7e:	0f b6 d0             	movzbl %al,%edx
  800d81:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d84:	8a 00                	mov    (%eax),%al
  800d86:	0f b6 c0             	movzbl %al,%eax
  800d89:	29 c2                	sub    %eax,%edx
  800d8b:	89 d0                	mov    %edx,%eax
}
  800d8d:	5d                   	pop    %ebp
  800d8e:	c3                   	ret    

00800d8f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d8f:	55                   	push   %ebp
  800d90:	89 e5                	mov    %esp,%ebp
  800d92:	83 ec 04             	sub    $0x4,%esp
  800d95:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d98:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d9b:	eb 12                	jmp    800daf <strchr+0x20>
		if (*s == c)
  800d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800da0:	8a 00                	mov    (%eax),%al
  800da2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800da5:	75 05                	jne    800dac <strchr+0x1d>
			return (char *) s;
  800da7:	8b 45 08             	mov    0x8(%ebp),%eax
  800daa:	eb 11                	jmp    800dbd <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800dac:	ff 45 08             	incl   0x8(%ebp)
  800daf:	8b 45 08             	mov    0x8(%ebp),%eax
  800db2:	8a 00                	mov    (%eax),%al
  800db4:	84 c0                	test   %al,%al
  800db6:	75 e5                	jne    800d9d <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800db8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dbd:	c9                   	leave  
  800dbe:	c3                   	ret    

00800dbf <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800dbf:	55                   	push   %ebp
  800dc0:	89 e5                	mov    %esp,%ebp
  800dc2:	83 ec 04             	sub    $0x4,%esp
  800dc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc8:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dcb:	eb 0d                	jmp    800dda <strfind+0x1b>
		if (*s == c)
  800dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd0:	8a 00                	mov    (%eax),%al
  800dd2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dd5:	74 0e                	je     800de5 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800dd7:	ff 45 08             	incl   0x8(%ebp)
  800dda:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddd:	8a 00                	mov    (%eax),%al
  800ddf:	84 c0                	test   %al,%al
  800de1:	75 ea                	jne    800dcd <strfind+0xe>
  800de3:	eb 01                	jmp    800de6 <strfind+0x27>
		if (*s == c)
			break;
  800de5:	90                   	nop
	return (char *) s;
  800de6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800de9:	c9                   	leave  
  800dea:	c3                   	ret    

00800deb <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800deb:	55                   	push   %ebp
  800dec:	89 e5                	mov    %esp,%ebp
  800dee:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800df1:	8b 45 08             	mov    0x8(%ebp),%eax
  800df4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800df7:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800dfb:	76 63                	jbe    800e60 <memset+0x75>
		uint64 data_block = c;
  800dfd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e00:	99                   	cltd   
  800e01:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e04:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800e07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e0a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e0d:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800e11:	c1 e0 08             	shl    $0x8,%eax
  800e14:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e17:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800e1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e1d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e20:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800e24:	c1 e0 10             	shl    $0x10,%eax
  800e27:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e2a:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800e2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e30:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e33:	89 c2                	mov    %eax,%edx
  800e35:	b8 00 00 00 00       	mov    $0x0,%eax
  800e3a:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e3d:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800e40:	eb 18                	jmp    800e5a <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800e42:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800e45:	8d 41 08             	lea    0x8(%ecx),%eax
  800e48:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800e4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e51:	89 01                	mov    %eax,(%ecx)
  800e53:	89 51 04             	mov    %edx,0x4(%ecx)
  800e56:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800e5a:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e5e:	77 e2                	ja     800e42 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800e60:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e64:	74 23                	je     800e89 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800e66:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e69:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e6c:	eb 0e                	jmp    800e7c <memset+0x91>
			*p8++ = (uint8)c;
  800e6e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e71:	8d 50 01             	lea    0x1(%eax),%edx
  800e74:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e77:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e7a:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800e7c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e7f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e82:	89 55 10             	mov    %edx,0x10(%ebp)
  800e85:	85 c0                	test   %eax,%eax
  800e87:	75 e5                	jne    800e6e <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800e89:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e8c:	c9                   	leave  
  800e8d:	c3                   	ret    

00800e8e <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e8e:	55                   	push   %ebp
  800e8f:	89 e5                	mov    %esp,%ebp
  800e91:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800e94:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e97:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800e9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800ea0:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ea4:	76 24                	jbe    800eca <memcpy+0x3c>
		while(n >= 8){
  800ea6:	eb 1c                	jmp    800ec4 <memcpy+0x36>
			*d64 = *s64;
  800ea8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eab:	8b 50 04             	mov    0x4(%eax),%edx
  800eae:	8b 00                	mov    (%eax),%eax
  800eb0:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800eb3:	89 01                	mov    %eax,(%ecx)
  800eb5:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800eb8:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800ebc:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800ec0:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800ec4:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ec8:	77 de                	ja     800ea8 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800eca:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ece:	74 31                	je     800f01 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800ed0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800ed6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ed9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800edc:	eb 16                	jmp    800ef4 <memcpy+0x66>
			*d8++ = *s8++;
  800ede:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ee1:	8d 50 01             	lea    0x1(%eax),%edx
  800ee4:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800ee7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eea:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eed:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800ef0:	8a 12                	mov    (%edx),%dl
  800ef2:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800ef4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ef7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800efa:	89 55 10             	mov    %edx,0x10(%ebp)
  800efd:	85 c0                	test   %eax,%eax
  800eff:	75 dd                	jne    800ede <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800f01:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f04:	c9                   	leave  
  800f05:	c3                   	ret    

00800f06 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f06:	55                   	push   %ebp
  800f07:	89 e5                	mov    %esp,%ebp
  800f09:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f0f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f12:	8b 45 08             	mov    0x8(%ebp),%eax
  800f15:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f18:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f1b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f1e:	73 50                	jae    800f70 <memmove+0x6a>
  800f20:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f23:	8b 45 10             	mov    0x10(%ebp),%eax
  800f26:	01 d0                	add    %edx,%eax
  800f28:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f2b:	76 43                	jbe    800f70 <memmove+0x6a>
		s += n;
  800f2d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f30:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f33:	8b 45 10             	mov    0x10(%ebp),%eax
  800f36:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f39:	eb 10                	jmp    800f4b <memmove+0x45>
			*--d = *--s;
  800f3b:	ff 4d f8             	decl   -0x8(%ebp)
  800f3e:	ff 4d fc             	decl   -0x4(%ebp)
  800f41:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f44:	8a 10                	mov    (%eax),%dl
  800f46:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f49:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f4b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f4e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f51:	89 55 10             	mov    %edx,0x10(%ebp)
  800f54:	85 c0                	test   %eax,%eax
  800f56:	75 e3                	jne    800f3b <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f58:	eb 23                	jmp    800f7d <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f5a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f5d:	8d 50 01             	lea    0x1(%eax),%edx
  800f60:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f63:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f66:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f69:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f6c:	8a 12                	mov    (%edx),%dl
  800f6e:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f70:	8b 45 10             	mov    0x10(%ebp),%eax
  800f73:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f76:	89 55 10             	mov    %edx,0x10(%ebp)
  800f79:	85 c0                	test   %eax,%eax
  800f7b:	75 dd                	jne    800f5a <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f7d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f80:	c9                   	leave  
  800f81:	c3                   	ret    

00800f82 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f82:	55                   	push   %ebp
  800f83:	89 e5                	mov    %esp,%ebp
  800f85:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f88:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f91:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f94:	eb 2a                	jmp    800fc0 <memcmp+0x3e>
		if (*s1 != *s2)
  800f96:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f99:	8a 10                	mov    (%eax),%dl
  800f9b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f9e:	8a 00                	mov    (%eax),%al
  800fa0:	38 c2                	cmp    %al,%dl
  800fa2:	74 16                	je     800fba <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800fa4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fa7:	8a 00                	mov    (%eax),%al
  800fa9:	0f b6 d0             	movzbl %al,%edx
  800fac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800faf:	8a 00                	mov    (%eax),%al
  800fb1:	0f b6 c0             	movzbl %al,%eax
  800fb4:	29 c2                	sub    %eax,%edx
  800fb6:	89 d0                	mov    %edx,%eax
  800fb8:	eb 18                	jmp    800fd2 <memcmp+0x50>
		s1++, s2++;
  800fba:	ff 45 fc             	incl   -0x4(%ebp)
  800fbd:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800fc0:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc3:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fc6:	89 55 10             	mov    %edx,0x10(%ebp)
  800fc9:	85 c0                	test   %eax,%eax
  800fcb:	75 c9                	jne    800f96 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800fcd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fd2:	c9                   	leave  
  800fd3:	c3                   	ret    

00800fd4 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800fd4:	55                   	push   %ebp
  800fd5:	89 e5                	mov    %esp,%ebp
  800fd7:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800fda:	8b 55 08             	mov    0x8(%ebp),%edx
  800fdd:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe0:	01 d0                	add    %edx,%eax
  800fe2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800fe5:	eb 15                	jmp    800ffc <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fea:	8a 00                	mov    (%eax),%al
  800fec:	0f b6 d0             	movzbl %al,%edx
  800fef:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff2:	0f b6 c0             	movzbl %al,%eax
  800ff5:	39 c2                	cmp    %eax,%edx
  800ff7:	74 0d                	je     801006 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ff9:	ff 45 08             	incl   0x8(%ebp)
  800ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fff:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801002:	72 e3                	jb     800fe7 <memfind+0x13>
  801004:	eb 01                	jmp    801007 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801006:	90                   	nop
	return (void *) s;
  801007:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80100a:	c9                   	leave  
  80100b:	c3                   	ret    

0080100c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80100c:	55                   	push   %ebp
  80100d:	89 e5                	mov    %esp,%ebp
  80100f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801012:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801019:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801020:	eb 03                	jmp    801025 <strtol+0x19>
		s++;
  801022:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801025:	8b 45 08             	mov    0x8(%ebp),%eax
  801028:	8a 00                	mov    (%eax),%al
  80102a:	3c 20                	cmp    $0x20,%al
  80102c:	74 f4                	je     801022 <strtol+0x16>
  80102e:	8b 45 08             	mov    0x8(%ebp),%eax
  801031:	8a 00                	mov    (%eax),%al
  801033:	3c 09                	cmp    $0x9,%al
  801035:	74 eb                	je     801022 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801037:	8b 45 08             	mov    0x8(%ebp),%eax
  80103a:	8a 00                	mov    (%eax),%al
  80103c:	3c 2b                	cmp    $0x2b,%al
  80103e:	75 05                	jne    801045 <strtol+0x39>
		s++;
  801040:	ff 45 08             	incl   0x8(%ebp)
  801043:	eb 13                	jmp    801058 <strtol+0x4c>
	else if (*s == '-')
  801045:	8b 45 08             	mov    0x8(%ebp),%eax
  801048:	8a 00                	mov    (%eax),%al
  80104a:	3c 2d                	cmp    $0x2d,%al
  80104c:	75 0a                	jne    801058 <strtol+0x4c>
		s++, neg = 1;
  80104e:	ff 45 08             	incl   0x8(%ebp)
  801051:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801058:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80105c:	74 06                	je     801064 <strtol+0x58>
  80105e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801062:	75 20                	jne    801084 <strtol+0x78>
  801064:	8b 45 08             	mov    0x8(%ebp),%eax
  801067:	8a 00                	mov    (%eax),%al
  801069:	3c 30                	cmp    $0x30,%al
  80106b:	75 17                	jne    801084 <strtol+0x78>
  80106d:	8b 45 08             	mov    0x8(%ebp),%eax
  801070:	40                   	inc    %eax
  801071:	8a 00                	mov    (%eax),%al
  801073:	3c 78                	cmp    $0x78,%al
  801075:	75 0d                	jne    801084 <strtol+0x78>
		s += 2, base = 16;
  801077:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80107b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801082:	eb 28                	jmp    8010ac <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801084:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801088:	75 15                	jne    80109f <strtol+0x93>
  80108a:	8b 45 08             	mov    0x8(%ebp),%eax
  80108d:	8a 00                	mov    (%eax),%al
  80108f:	3c 30                	cmp    $0x30,%al
  801091:	75 0c                	jne    80109f <strtol+0x93>
		s++, base = 8;
  801093:	ff 45 08             	incl   0x8(%ebp)
  801096:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80109d:	eb 0d                	jmp    8010ac <strtol+0xa0>
	else if (base == 0)
  80109f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010a3:	75 07                	jne    8010ac <strtol+0xa0>
		base = 10;
  8010a5:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8010ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8010af:	8a 00                	mov    (%eax),%al
  8010b1:	3c 2f                	cmp    $0x2f,%al
  8010b3:	7e 19                	jle    8010ce <strtol+0xc2>
  8010b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b8:	8a 00                	mov    (%eax),%al
  8010ba:	3c 39                	cmp    $0x39,%al
  8010bc:	7f 10                	jg     8010ce <strtol+0xc2>
			dig = *s - '0';
  8010be:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c1:	8a 00                	mov    (%eax),%al
  8010c3:	0f be c0             	movsbl %al,%eax
  8010c6:	83 e8 30             	sub    $0x30,%eax
  8010c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010cc:	eb 42                	jmp    801110 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8010ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d1:	8a 00                	mov    (%eax),%al
  8010d3:	3c 60                	cmp    $0x60,%al
  8010d5:	7e 19                	jle    8010f0 <strtol+0xe4>
  8010d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010da:	8a 00                	mov    (%eax),%al
  8010dc:	3c 7a                	cmp    $0x7a,%al
  8010de:	7f 10                	jg     8010f0 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8010e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e3:	8a 00                	mov    (%eax),%al
  8010e5:	0f be c0             	movsbl %al,%eax
  8010e8:	83 e8 57             	sub    $0x57,%eax
  8010eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010ee:	eb 20                	jmp    801110 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8010f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f3:	8a 00                	mov    (%eax),%al
  8010f5:	3c 40                	cmp    $0x40,%al
  8010f7:	7e 39                	jle    801132 <strtol+0x126>
  8010f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fc:	8a 00                	mov    (%eax),%al
  8010fe:	3c 5a                	cmp    $0x5a,%al
  801100:	7f 30                	jg     801132 <strtol+0x126>
			dig = *s - 'A' + 10;
  801102:	8b 45 08             	mov    0x8(%ebp),%eax
  801105:	8a 00                	mov    (%eax),%al
  801107:	0f be c0             	movsbl %al,%eax
  80110a:	83 e8 37             	sub    $0x37,%eax
  80110d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801110:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801113:	3b 45 10             	cmp    0x10(%ebp),%eax
  801116:	7d 19                	jge    801131 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801118:	ff 45 08             	incl   0x8(%ebp)
  80111b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80111e:	0f af 45 10          	imul   0x10(%ebp),%eax
  801122:	89 c2                	mov    %eax,%edx
  801124:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801127:	01 d0                	add    %edx,%eax
  801129:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80112c:	e9 7b ff ff ff       	jmp    8010ac <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801131:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801132:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801136:	74 08                	je     801140 <strtol+0x134>
		*endptr = (char *) s;
  801138:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113b:	8b 55 08             	mov    0x8(%ebp),%edx
  80113e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801140:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801144:	74 07                	je     80114d <strtol+0x141>
  801146:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801149:	f7 d8                	neg    %eax
  80114b:	eb 03                	jmp    801150 <strtol+0x144>
  80114d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801150:	c9                   	leave  
  801151:	c3                   	ret    

00801152 <ltostr>:

void
ltostr(long value, char *str)
{
  801152:	55                   	push   %ebp
  801153:	89 e5                	mov    %esp,%ebp
  801155:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801158:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80115f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801166:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80116a:	79 13                	jns    80117f <ltostr+0x2d>
	{
		neg = 1;
  80116c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801173:	8b 45 0c             	mov    0xc(%ebp),%eax
  801176:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801179:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80117c:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80117f:	8b 45 08             	mov    0x8(%ebp),%eax
  801182:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801187:	99                   	cltd   
  801188:	f7 f9                	idiv   %ecx
  80118a:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80118d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801190:	8d 50 01             	lea    0x1(%eax),%edx
  801193:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801196:	89 c2                	mov    %eax,%edx
  801198:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119b:	01 d0                	add    %edx,%eax
  80119d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011a0:	83 c2 30             	add    $0x30,%edx
  8011a3:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8011a5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011a8:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011ad:	f7 e9                	imul   %ecx
  8011af:	c1 fa 02             	sar    $0x2,%edx
  8011b2:	89 c8                	mov    %ecx,%eax
  8011b4:	c1 f8 1f             	sar    $0x1f,%eax
  8011b7:	29 c2                	sub    %eax,%edx
  8011b9:	89 d0                	mov    %edx,%eax
  8011bb:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8011be:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011c2:	75 bb                	jne    80117f <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8011c4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8011cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011ce:	48                   	dec    %eax
  8011cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8011d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011d6:	74 3d                	je     801215 <ltostr+0xc3>
		start = 1 ;
  8011d8:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8011df:	eb 34                	jmp    801215 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8011e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e7:	01 d0                	add    %edx,%eax
  8011e9:	8a 00                	mov    (%eax),%al
  8011eb:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8011ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f4:	01 c2                	add    %eax,%edx
  8011f6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8011f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fc:	01 c8                	add    %ecx,%eax
  8011fe:	8a 00                	mov    (%eax),%al
  801200:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801202:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801205:	8b 45 0c             	mov    0xc(%ebp),%eax
  801208:	01 c2                	add    %eax,%edx
  80120a:	8a 45 eb             	mov    -0x15(%ebp),%al
  80120d:	88 02                	mov    %al,(%edx)
		start++ ;
  80120f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801212:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801215:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801218:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80121b:	7c c4                	jl     8011e1 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80121d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801220:	8b 45 0c             	mov    0xc(%ebp),%eax
  801223:	01 d0                	add    %edx,%eax
  801225:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801228:	90                   	nop
  801229:	c9                   	leave  
  80122a:	c3                   	ret    

0080122b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80122b:	55                   	push   %ebp
  80122c:	89 e5                	mov    %esp,%ebp
  80122e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801231:	ff 75 08             	pushl  0x8(%ebp)
  801234:	e8 c4 f9 ff ff       	call   800bfd <strlen>
  801239:	83 c4 04             	add    $0x4,%esp
  80123c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80123f:	ff 75 0c             	pushl  0xc(%ebp)
  801242:	e8 b6 f9 ff ff       	call   800bfd <strlen>
  801247:	83 c4 04             	add    $0x4,%esp
  80124a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80124d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801254:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80125b:	eb 17                	jmp    801274 <strcconcat+0x49>
		final[s] = str1[s] ;
  80125d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801260:	8b 45 10             	mov    0x10(%ebp),%eax
  801263:	01 c2                	add    %eax,%edx
  801265:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801268:	8b 45 08             	mov    0x8(%ebp),%eax
  80126b:	01 c8                	add    %ecx,%eax
  80126d:	8a 00                	mov    (%eax),%al
  80126f:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801271:	ff 45 fc             	incl   -0x4(%ebp)
  801274:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801277:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80127a:	7c e1                	jl     80125d <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80127c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801283:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80128a:	eb 1f                	jmp    8012ab <strcconcat+0x80>
		final[s++] = str2[i] ;
  80128c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80128f:	8d 50 01             	lea    0x1(%eax),%edx
  801292:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801295:	89 c2                	mov    %eax,%edx
  801297:	8b 45 10             	mov    0x10(%ebp),%eax
  80129a:	01 c2                	add    %eax,%edx
  80129c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80129f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a2:	01 c8                	add    %ecx,%eax
  8012a4:	8a 00                	mov    (%eax),%al
  8012a6:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8012a8:	ff 45 f8             	incl   -0x8(%ebp)
  8012ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012ae:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012b1:	7c d9                	jl     80128c <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8012b3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b9:	01 d0                	add    %edx,%eax
  8012bb:	c6 00 00             	movb   $0x0,(%eax)
}
  8012be:	90                   	nop
  8012bf:	c9                   	leave  
  8012c0:	c3                   	ret    

008012c1 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8012c1:	55                   	push   %ebp
  8012c2:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8012c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8012c7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8012cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8012d0:	8b 00                	mov    (%eax),%eax
  8012d2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8012dc:	01 d0                	add    %edx,%eax
  8012de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012e4:	eb 0c                	jmp    8012f2 <strsplit+0x31>
			*string++ = 0;
  8012e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e9:	8d 50 01             	lea    0x1(%eax),%edx
  8012ec:	89 55 08             	mov    %edx,0x8(%ebp)
  8012ef:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f5:	8a 00                	mov    (%eax),%al
  8012f7:	84 c0                	test   %al,%al
  8012f9:	74 18                	je     801313 <strsplit+0x52>
  8012fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fe:	8a 00                	mov    (%eax),%al
  801300:	0f be c0             	movsbl %al,%eax
  801303:	50                   	push   %eax
  801304:	ff 75 0c             	pushl  0xc(%ebp)
  801307:	e8 83 fa ff ff       	call   800d8f <strchr>
  80130c:	83 c4 08             	add    $0x8,%esp
  80130f:	85 c0                	test   %eax,%eax
  801311:	75 d3                	jne    8012e6 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801313:	8b 45 08             	mov    0x8(%ebp),%eax
  801316:	8a 00                	mov    (%eax),%al
  801318:	84 c0                	test   %al,%al
  80131a:	74 5a                	je     801376 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80131c:	8b 45 14             	mov    0x14(%ebp),%eax
  80131f:	8b 00                	mov    (%eax),%eax
  801321:	83 f8 0f             	cmp    $0xf,%eax
  801324:	75 07                	jne    80132d <strsplit+0x6c>
		{
			return 0;
  801326:	b8 00 00 00 00       	mov    $0x0,%eax
  80132b:	eb 66                	jmp    801393 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80132d:	8b 45 14             	mov    0x14(%ebp),%eax
  801330:	8b 00                	mov    (%eax),%eax
  801332:	8d 48 01             	lea    0x1(%eax),%ecx
  801335:	8b 55 14             	mov    0x14(%ebp),%edx
  801338:	89 0a                	mov    %ecx,(%edx)
  80133a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801341:	8b 45 10             	mov    0x10(%ebp),%eax
  801344:	01 c2                	add    %eax,%edx
  801346:	8b 45 08             	mov    0x8(%ebp),%eax
  801349:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80134b:	eb 03                	jmp    801350 <strsplit+0x8f>
			string++;
  80134d:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801350:	8b 45 08             	mov    0x8(%ebp),%eax
  801353:	8a 00                	mov    (%eax),%al
  801355:	84 c0                	test   %al,%al
  801357:	74 8b                	je     8012e4 <strsplit+0x23>
  801359:	8b 45 08             	mov    0x8(%ebp),%eax
  80135c:	8a 00                	mov    (%eax),%al
  80135e:	0f be c0             	movsbl %al,%eax
  801361:	50                   	push   %eax
  801362:	ff 75 0c             	pushl  0xc(%ebp)
  801365:	e8 25 fa ff ff       	call   800d8f <strchr>
  80136a:	83 c4 08             	add    $0x8,%esp
  80136d:	85 c0                	test   %eax,%eax
  80136f:	74 dc                	je     80134d <strsplit+0x8c>
			string++;
	}
  801371:	e9 6e ff ff ff       	jmp    8012e4 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801376:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801377:	8b 45 14             	mov    0x14(%ebp),%eax
  80137a:	8b 00                	mov    (%eax),%eax
  80137c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801383:	8b 45 10             	mov    0x10(%ebp),%eax
  801386:	01 d0                	add    %edx,%eax
  801388:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80138e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801393:	c9                   	leave  
  801394:	c3                   	ret    

00801395 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801395:	55                   	push   %ebp
  801396:	89 e5                	mov    %esp,%ebp
  801398:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  80139b:	8b 45 08             	mov    0x8(%ebp),%eax
  80139e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8013a1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013a8:	eb 4a                	jmp    8013f4 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8013aa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b0:	01 c2                	add    %eax,%edx
  8013b2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b8:	01 c8                	add    %ecx,%eax
  8013ba:	8a 00                	mov    (%eax),%al
  8013bc:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8013be:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c4:	01 d0                	add    %edx,%eax
  8013c6:	8a 00                	mov    (%eax),%al
  8013c8:	3c 40                	cmp    $0x40,%al
  8013ca:	7e 25                	jle    8013f1 <str2lower+0x5c>
  8013cc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d2:	01 d0                	add    %edx,%eax
  8013d4:	8a 00                	mov    (%eax),%al
  8013d6:	3c 5a                	cmp    $0x5a,%al
  8013d8:	7f 17                	jg     8013f1 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8013da:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e0:	01 d0                	add    %edx,%eax
  8013e2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8013e8:	01 ca                	add    %ecx,%edx
  8013ea:	8a 12                	mov    (%edx),%dl
  8013ec:	83 c2 20             	add    $0x20,%edx
  8013ef:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8013f1:	ff 45 fc             	incl   -0x4(%ebp)
  8013f4:	ff 75 0c             	pushl  0xc(%ebp)
  8013f7:	e8 01 f8 ff ff       	call   800bfd <strlen>
  8013fc:	83 c4 04             	add    $0x4,%esp
  8013ff:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801402:	7f a6                	jg     8013aa <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801404:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801407:	c9                   	leave  
  801408:	c3                   	ret    

00801409 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801409:	55                   	push   %ebp
  80140a:	89 e5                	mov    %esp,%ebp
  80140c:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  80140f:	a1 08 30 80 00       	mov    0x803008,%eax
  801414:	85 c0                	test   %eax,%eax
  801416:	74 42                	je     80145a <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801418:	83 ec 08             	sub    $0x8,%esp
  80141b:	68 00 00 00 82       	push   $0x82000000
  801420:	68 00 00 00 80       	push   $0x80000000
  801425:	e8 8c 07 00 00       	call   801bb6 <initialize_dynamic_allocator>
  80142a:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  80142d:	e8 e7 05 00 00       	call   801a19 <sys_get_uheap_strategy>
  801432:	a3 60 b0 81 00       	mov    %eax,0x81b060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801437:	a1 40 30 80 00       	mov    0x803040,%eax
  80143c:	05 00 10 00 00       	add    $0x1000,%eax
  801441:	a3 10 b1 81 00       	mov    %eax,0x81b110
		uheapPageAllocBreak = uheapPageAllocStart;
  801446:	a1 10 b1 81 00       	mov    0x81b110,%eax
  80144b:	a3 68 b0 81 00       	mov    %eax,0x81b068

		__firstTimeFlag = 0;
  801450:	c7 05 08 30 80 00 00 	movl   $0x0,0x803008
  801457:	00 00 00 
	}
}
  80145a:	90                   	nop
  80145b:	c9                   	leave  
  80145c:	c3                   	ret    

0080145d <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  80145d:	55                   	push   %ebp
  80145e:	89 e5                	mov    %esp,%ebp
  801460:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801463:	8b 45 08             	mov    0x8(%ebp),%eax
  801466:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801469:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80146c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801471:	83 ec 08             	sub    $0x8,%esp
  801474:	68 06 04 00 00       	push   $0x406
  801479:	50                   	push   %eax
  80147a:	e8 e4 01 00 00       	call   801663 <__sys_allocate_page>
  80147f:	83 c4 10             	add    $0x10,%esp
  801482:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801485:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801489:	79 14                	jns    80149f <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  80148b:	83 ec 04             	sub    $0x4,%esp
  80148e:	68 88 28 80 00       	push   $0x802888
  801493:	6a 1f                	push   $0x1f
  801495:	68 c4 28 80 00       	push   $0x8028c4
  80149a:	e8 4c 0a 00 00       	call   801eeb <_panic>
	return 0;
  80149f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014a4:	c9                   	leave  
  8014a5:	c3                   	ret    

008014a6 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  8014a6:	55                   	push   %ebp
  8014a7:	89 e5                	mov    %esp,%ebp
  8014a9:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  8014ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8014af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014b5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014ba:	83 ec 0c             	sub    $0xc,%esp
  8014bd:	50                   	push   %eax
  8014be:	e8 e7 01 00 00       	call   8016aa <__sys_unmap_frame>
  8014c3:	83 c4 10             	add    $0x10,%esp
  8014c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8014c9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8014cd:	79 14                	jns    8014e3 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  8014cf:	83 ec 04             	sub    $0x4,%esp
  8014d2:	68 d0 28 80 00       	push   $0x8028d0
  8014d7:	6a 2a                	push   $0x2a
  8014d9:	68 c4 28 80 00       	push   $0x8028c4
  8014de:	e8 08 0a 00 00       	call   801eeb <_panic>
}
  8014e3:	90                   	nop
  8014e4:	c9                   	leave  
  8014e5:	c3                   	ret    

008014e6 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  8014e6:	55                   	push   %ebp
  8014e7:	89 e5                	mov    %esp,%ebp
  8014e9:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8014ec:	e8 18 ff ff ff       	call   801409 <uheap_init>
	if (size == 0) return NULL ;
  8014f1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014f5:	75 07                	jne    8014fe <malloc+0x18>
  8014f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8014fc:	eb 14                	jmp    801512 <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  8014fe:	83 ec 04             	sub    $0x4,%esp
  801501:	68 10 29 80 00       	push   $0x802910
  801506:	6a 3e                	push   $0x3e
  801508:	68 c4 28 80 00       	push   $0x8028c4
  80150d:	e8 d9 09 00 00       	call   801eeb <_panic>
}
  801512:	c9                   	leave  
  801513:	c3                   	ret    

00801514 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801514:	55                   	push   %ebp
  801515:	89 e5                	mov    %esp,%ebp
  801517:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  80151a:	83 ec 04             	sub    $0x4,%esp
  80151d:	68 38 29 80 00       	push   $0x802938
  801522:	6a 49                	push   $0x49
  801524:	68 c4 28 80 00       	push   $0x8028c4
  801529:	e8 bd 09 00 00       	call   801eeb <_panic>

0080152e <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80152e:	55                   	push   %ebp
  80152f:	89 e5                	mov    %esp,%ebp
  801531:	83 ec 18             	sub    $0x18,%esp
  801534:	8b 45 10             	mov    0x10(%ebp),%eax
  801537:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80153a:	e8 ca fe ff ff       	call   801409 <uheap_init>
	if (size == 0) return NULL ;
  80153f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801543:	75 07                	jne    80154c <smalloc+0x1e>
  801545:	b8 00 00 00 00       	mov    $0x0,%eax
  80154a:	eb 14                	jmp    801560 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  80154c:	83 ec 04             	sub    $0x4,%esp
  80154f:	68 5c 29 80 00       	push   $0x80295c
  801554:	6a 5a                	push   $0x5a
  801556:	68 c4 28 80 00       	push   $0x8028c4
  80155b:	e8 8b 09 00 00       	call   801eeb <_panic>
}
  801560:	c9                   	leave  
  801561:	c3                   	ret    

00801562 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801562:	55                   	push   %ebp
  801563:	89 e5                	mov    %esp,%ebp
  801565:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801568:	e8 9c fe ff ff       	call   801409 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  80156d:	83 ec 04             	sub    $0x4,%esp
  801570:	68 84 29 80 00       	push   $0x802984
  801575:	6a 6a                	push   $0x6a
  801577:	68 c4 28 80 00       	push   $0x8028c4
  80157c:	e8 6a 09 00 00       	call   801eeb <_panic>

00801581 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801581:	55                   	push   %ebp
  801582:	89 e5                	mov    %esp,%ebp
  801584:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801587:	e8 7d fe ff ff       	call   801409 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  80158c:	83 ec 04             	sub    $0x4,%esp
  80158f:	68 a8 29 80 00       	push   $0x8029a8
  801594:	68 88 00 00 00       	push   $0x88
  801599:	68 c4 28 80 00       	push   $0x8028c4
  80159e:	e8 48 09 00 00       	call   801eeb <_panic>

008015a3 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  8015a3:	55                   	push   %ebp
  8015a4:	89 e5                	mov    %esp,%ebp
  8015a6:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  8015a9:	83 ec 04             	sub    $0x4,%esp
  8015ac:	68 d0 29 80 00       	push   $0x8029d0
  8015b1:	68 9b 00 00 00       	push   $0x9b
  8015b6:	68 c4 28 80 00       	push   $0x8028c4
  8015bb:	e8 2b 09 00 00       	call   801eeb <_panic>

008015c0 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8015c0:	55                   	push   %ebp
  8015c1:	89 e5                	mov    %esp,%ebp
  8015c3:	57                   	push   %edi
  8015c4:	56                   	push   %esi
  8015c5:	53                   	push   %ebx
  8015c6:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015cf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015d2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8015d5:	8b 7d 18             	mov    0x18(%ebp),%edi
  8015d8:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8015db:	cd 30                	int    $0x30
  8015dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8015e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8015e3:	83 c4 10             	add    $0x10,%esp
  8015e6:	5b                   	pop    %ebx
  8015e7:	5e                   	pop    %esi
  8015e8:	5f                   	pop    %edi
  8015e9:	5d                   	pop    %ebp
  8015ea:	c3                   	ret    

008015eb <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8015eb:	55                   	push   %ebp
  8015ec:	89 e5                	mov    %esp,%ebp
  8015ee:	83 ec 04             	sub    $0x4,%esp
  8015f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8015f4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8015f7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8015fa:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8015fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801601:	6a 00                	push   $0x0
  801603:	51                   	push   %ecx
  801604:	52                   	push   %edx
  801605:	ff 75 0c             	pushl  0xc(%ebp)
  801608:	50                   	push   %eax
  801609:	6a 00                	push   $0x0
  80160b:	e8 b0 ff ff ff       	call   8015c0 <syscall>
  801610:	83 c4 18             	add    $0x18,%esp
}
  801613:	90                   	nop
  801614:	c9                   	leave  
  801615:	c3                   	ret    

00801616 <sys_cgetc>:

int
sys_cgetc(void)
{
  801616:	55                   	push   %ebp
  801617:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801619:	6a 00                	push   $0x0
  80161b:	6a 00                	push   $0x0
  80161d:	6a 00                	push   $0x0
  80161f:	6a 00                	push   $0x0
  801621:	6a 00                	push   $0x0
  801623:	6a 02                	push   $0x2
  801625:	e8 96 ff ff ff       	call   8015c0 <syscall>
  80162a:	83 c4 18             	add    $0x18,%esp
}
  80162d:	c9                   	leave  
  80162e:	c3                   	ret    

0080162f <sys_lock_cons>:

void sys_lock_cons(void)
{
  80162f:	55                   	push   %ebp
  801630:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801632:	6a 00                	push   $0x0
  801634:	6a 00                	push   $0x0
  801636:	6a 00                	push   $0x0
  801638:	6a 00                	push   $0x0
  80163a:	6a 00                	push   $0x0
  80163c:	6a 03                	push   $0x3
  80163e:	e8 7d ff ff ff       	call   8015c0 <syscall>
  801643:	83 c4 18             	add    $0x18,%esp
}
  801646:	90                   	nop
  801647:	c9                   	leave  
  801648:	c3                   	ret    

00801649 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801649:	55                   	push   %ebp
  80164a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80164c:	6a 00                	push   $0x0
  80164e:	6a 00                	push   $0x0
  801650:	6a 00                	push   $0x0
  801652:	6a 00                	push   $0x0
  801654:	6a 00                	push   $0x0
  801656:	6a 04                	push   $0x4
  801658:	e8 63 ff ff ff       	call   8015c0 <syscall>
  80165d:	83 c4 18             	add    $0x18,%esp
}
  801660:	90                   	nop
  801661:	c9                   	leave  
  801662:	c3                   	ret    

00801663 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801663:	55                   	push   %ebp
  801664:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801666:	8b 55 0c             	mov    0xc(%ebp),%edx
  801669:	8b 45 08             	mov    0x8(%ebp),%eax
  80166c:	6a 00                	push   $0x0
  80166e:	6a 00                	push   $0x0
  801670:	6a 00                	push   $0x0
  801672:	52                   	push   %edx
  801673:	50                   	push   %eax
  801674:	6a 08                	push   $0x8
  801676:	e8 45 ff ff ff       	call   8015c0 <syscall>
  80167b:	83 c4 18             	add    $0x18,%esp
}
  80167e:	c9                   	leave  
  80167f:	c3                   	ret    

00801680 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801680:	55                   	push   %ebp
  801681:	89 e5                	mov    %esp,%ebp
  801683:	56                   	push   %esi
  801684:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801685:	8b 75 18             	mov    0x18(%ebp),%esi
  801688:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80168b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80168e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801691:	8b 45 08             	mov    0x8(%ebp),%eax
  801694:	56                   	push   %esi
  801695:	53                   	push   %ebx
  801696:	51                   	push   %ecx
  801697:	52                   	push   %edx
  801698:	50                   	push   %eax
  801699:	6a 09                	push   $0x9
  80169b:	e8 20 ff ff ff       	call   8015c0 <syscall>
  8016a0:	83 c4 18             	add    $0x18,%esp
}
  8016a3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016a6:	5b                   	pop    %ebx
  8016a7:	5e                   	pop    %esi
  8016a8:	5d                   	pop    %ebp
  8016a9:	c3                   	ret    

008016aa <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8016aa:	55                   	push   %ebp
  8016ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8016ad:	6a 00                	push   $0x0
  8016af:	6a 00                	push   $0x0
  8016b1:	6a 00                	push   $0x0
  8016b3:	6a 00                	push   $0x0
  8016b5:	ff 75 08             	pushl  0x8(%ebp)
  8016b8:	6a 0a                	push   $0xa
  8016ba:	e8 01 ff ff ff       	call   8015c0 <syscall>
  8016bf:	83 c4 18             	add    $0x18,%esp
}
  8016c2:	c9                   	leave  
  8016c3:	c3                   	ret    

008016c4 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8016c4:	55                   	push   %ebp
  8016c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8016c7:	6a 00                	push   $0x0
  8016c9:	6a 00                	push   $0x0
  8016cb:	6a 00                	push   $0x0
  8016cd:	ff 75 0c             	pushl  0xc(%ebp)
  8016d0:	ff 75 08             	pushl  0x8(%ebp)
  8016d3:	6a 0b                	push   $0xb
  8016d5:	e8 e6 fe ff ff       	call   8015c0 <syscall>
  8016da:	83 c4 18             	add    $0x18,%esp
}
  8016dd:	c9                   	leave  
  8016de:	c3                   	ret    

008016df <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8016df:	55                   	push   %ebp
  8016e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8016e2:	6a 00                	push   $0x0
  8016e4:	6a 00                	push   $0x0
  8016e6:	6a 00                	push   $0x0
  8016e8:	6a 00                	push   $0x0
  8016ea:	6a 00                	push   $0x0
  8016ec:	6a 0c                	push   $0xc
  8016ee:	e8 cd fe ff ff       	call   8015c0 <syscall>
  8016f3:	83 c4 18             	add    $0x18,%esp
}
  8016f6:	c9                   	leave  
  8016f7:	c3                   	ret    

008016f8 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8016f8:	55                   	push   %ebp
  8016f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8016fb:	6a 00                	push   $0x0
  8016fd:	6a 00                	push   $0x0
  8016ff:	6a 00                	push   $0x0
  801701:	6a 00                	push   $0x0
  801703:	6a 00                	push   $0x0
  801705:	6a 0d                	push   $0xd
  801707:	e8 b4 fe ff ff       	call   8015c0 <syscall>
  80170c:	83 c4 18             	add    $0x18,%esp
}
  80170f:	c9                   	leave  
  801710:	c3                   	ret    

00801711 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801711:	55                   	push   %ebp
  801712:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801714:	6a 00                	push   $0x0
  801716:	6a 00                	push   $0x0
  801718:	6a 00                	push   $0x0
  80171a:	6a 00                	push   $0x0
  80171c:	6a 00                	push   $0x0
  80171e:	6a 0e                	push   $0xe
  801720:	e8 9b fe ff ff       	call   8015c0 <syscall>
  801725:	83 c4 18             	add    $0x18,%esp
}
  801728:	c9                   	leave  
  801729:	c3                   	ret    

0080172a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80172a:	55                   	push   %ebp
  80172b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80172d:	6a 00                	push   $0x0
  80172f:	6a 00                	push   $0x0
  801731:	6a 00                	push   $0x0
  801733:	6a 00                	push   $0x0
  801735:	6a 00                	push   $0x0
  801737:	6a 0f                	push   $0xf
  801739:	e8 82 fe ff ff       	call   8015c0 <syscall>
  80173e:	83 c4 18             	add    $0x18,%esp
}
  801741:	c9                   	leave  
  801742:	c3                   	ret    

00801743 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801743:	55                   	push   %ebp
  801744:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801746:	6a 00                	push   $0x0
  801748:	6a 00                	push   $0x0
  80174a:	6a 00                	push   $0x0
  80174c:	6a 00                	push   $0x0
  80174e:	ff 75 08             	pushl  0x8(%ebp)
  801751:	6a 10                	push   $0x10
  801753:	e8 68 fe ff ff       	call   8015c0 <syscall>
  801758:	83 c4 18             	add    $0x18,%esp
}
  80175b:	c9                   	leave  
  80175c:	c3                   	ret    

0080175d <sys_scarce_memory>:

void sys_scarce_memory()
{
  80175d:	55                   	push   %ebp
  80175e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801760:	6a 00                	push   $0x0
  801762:	6a 00                	push   $0x0
  801764:	6a 00                	push   $0x0
  801766:	6a 00                	push   $0x0
  801768:	6a 00                	push   $0x0
  80176a:	6a 11                	push   $0x11
  80176c:	e8 4f fe ff ff       	call   8015c0 <syscall>
  801771:	83 c4 18             	add    $0x18,%esp
}
  801774:	90                   	nop
  801775:	c9                   	leave  
  801776:	c3                   	ret    

00801777 <sys_cputc>:

void
sys_cputc(const char c)
{
  801777:	55                   	push   %ebp
  801778:	89 e5                	mov    %esp,%ebp
  80177a:	83 ec 04             	sub    $0x4,%esp
  80177d:	8b 45 08             	mov    0x8(%ebp),%eax
  801780:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801783:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801787:	6a 00                	push   $0x0
  801789:	6a 00                	push   $0x0
  80178b:	6a 00                	push   $0x0
  80178d:	6a 00                	push   $0x0
  80178f:	50                   	push   %eax
  801790:	6a 01                	push   $0x1
  801792:	e8 29 fe ff ff       	call   8015c0 <syscall>
  801797:	83 c4 18             	add    $0x18,%esp
}
  80179a:	90                   	nop
  80179b:	c9                   	leave  
  80179c:	c3                   	ret    

0080179d <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80179d:	55                   	push   %ebp
  80179e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8017a0:	6a 00                	push   $0x0
  8017a2:	6a 00                	push   $0x0
  8017a4:	6a 00                	push   $0x0
  8017a6:	6a 00                	push   $0x0
  8017a8:	6a 00                	push   $0x0
  8017aa:	6a 14                	push   $0x14
  8017ac:	e8 0f fe ff ff       	call   8015c0 <syscall>
  8017b1:	83 c4 18             	add    $0x18,%esp
}
  8017b4:	90                   	nop
  8017b5:	c9                   	leave  
  8017b6:	c3                   	ret    

008017b7 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8017b7:	55                   	push   %ebp
  8017b8:	89 e5                	mov    %esp,%ebp
  8017ba:	83 ec 04             	sub    $0x4,%esp
  8017bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8017c0:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8017c3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8017c6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cd:	6a 00                	push   $0x0
  8017cf:	51                   	push   %ecx
  8017d0:	52                   	push   %edx
  8017d1:	ff 75 0c             	pushl  0xc(%ebp)
  8017d4:	50                   	push   %eax
  8017d5:	6a 15                	push   $0x15
  8017d7:	e8 e4 fd ff ff       	call   8015c0 <syscall>
  8017dc:	83 c4 18             	add    $0x18,%esp
}
  8017df:	c9                   	leave  
  8017e0:	c3                   	ret    

008017e1 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8017e1:	55                   	push   %ebp
  8017e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8017e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ea:	6a 00                	push   $0x0
  8017ec:	6a 00                	push   $0x0
  8017ee:	6a 00                	push   $0x0
  8017f0:	52                   	push   %edx
  8017f1:	50                   	push   %eax
  8017f2:	6a 16                	push   $0x16
  8017f4:	e8 c7 fd ff ff       	call   8015c0 <syscall>
  8017f9:	83 c4 18             	add    $0x18,%esp
}
  8017fc:	c9                   	leave  
  8017fd:	c3                   	ret    

008017fe <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8017fe:	55                   	push   %ebp
  8017ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801801:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801804:	8b 55 0c             	mov    0xc(%ebp),%edx
  801807:	8b 45 08             	mov    0x8(%ebp),%eax
  80180a:	6a 00                	push   $0x0
  80180c:	6a 00                	push   $0x0
  80180e:	51                   	push   %ecx
  80180f:	52                   	push   %edx
  801810:	50                   	push   %eax
  801811:	6a 17                	push   $0x17
  801813:	e8 a8 fd ff ff       	call   8015c0 <syscall>
  801818:	83 c4 18             	add    $0x18,%esp
}
  80181b:	c9                   	leave  
  80181c:	c3                   	ret    

0080181d <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  80181d:	55                   	push   %ebp
  80181e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801820:	8b 55 0c             	mov    0xc(%ebp),%edx
  801823:	8b 45 08             	mov    0x8(%ebp),%eax
  801826:	6a 00                	push   $0x0
  801828:	6a 00                	push   $0x0
  80182a:	6a 00                	push   $0x0
  80182c:	52                   	push   %edx
  80182d:	50                   	push   %eax
  80182e:	6a 18                	push   $0x18
  801830:	e8 8b fd ff ff       	call   8015c0 <syscall>
  801835:	83 c4 18             	add    $0x18,%esp
}
  801838:	c9                   	leave  
  801839:	c3                   	ret    

0080183a <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80183a:	55                   	push   %ebp
  80183b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80183d:	8b 45 08             	mov    0x8(%ebp),%eax
  801840:	6a 00                	push   $0x0
  801842:	ff 75 14             	pushl  0x14(%ebp)
  801845:	ff 75 10             	pushl  0x10(%ebp)
  801848:	ff 75 0c             	pushl  0xc(%ebp)
  80184b:	50                   	push   %eax
  80184c:	6a 19                	push   $0x19
  80184e:	e8 6d fd ff ff       	call   8015c0 <syscall>
  801853:	83 c4 18             	add    $0x18,%esp
}
  801856:	c9                   	leave  
  801857:	c3                   	ret    

00801858 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801858:	55                   	push   %ebp
  801859:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80185b:	8b 45 08             	mov    0x8(%ebp),%eax
  80185e:	6a 00                	push   $0x0
  801860:	6a 00                	push   $0x0
  801862:	6a 00                	push   $0x0
  801864:	6a 00                	push   $0x0
  801866:	50                   	push   %eax
  801867:	6a 1a                	push   $0x1a
  801869:	e8 52 fd ff ff       	call   8015c0 <syscall>
  80186e:	83 c4 18             	add    $0x18,%esp
}
  801871:	90                   	nop
  801872:	c9                   	leave  
  801873:	c3                   	ret    

00801874 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801874:	55                   	push   %ebp
  801875:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801877:	8b 45 08             	mov    0x8(%ebp),%eax
  80187a:	6a 00                	push   $0x0
  80187c:	6a 00                	push   $0x0
  80187e:	6a 00                	push   $0x0
  801880:	6a 00                	push   $0x0
  801882:	50                   	push   %eax
  801883:	6a 1b                	push   $0x1b
  801885:	e8 36 fd ff ff       	call   8015c0 <syscall>
  80188a:	83 c4 18             	add    $0x18,%esp
}
  80188d:	c9                   	leave  
  80188e:	c3                   	ret    

0080188f <sys_getenvid>:

int32 sys_getenvid(void)
{
  80188f:	55                   	push   %ebp
  801890:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801892:	6a 00                	push   $0x0
  801894:	6a 00                	push   $0x0
  801896:	6a 00                	push   $0x0
  801898:	6a 00                	push   $0x0
  80189a:	6a 00                	push   $0x0
  80189c:	6a 05                	push   $0x5
  80189e:	e8 1d fd ff ff       	call   8015c0 <syscall>
  8018a3:	83 c4 18             	add    $0x18,%esp
}
  8018a6:	c9                   	leave  
  8018a7:	c3                   	ret    

008018a8 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8018a8:	55                   	push   %ebp
  8018a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8018ab:	6a 00                	push   $0x0
  8018ad:	6a 00                	push   $0x0
  8018af:	6a 00                	push   $0x0
  8018b1:	6a 00                	push   $0x0
  8018b3:	6a 00                	push   $0x0
  8018b5:	6a 06                	push   $0x6
  8018b7:	e8 04 fd ff ff       	call   8015c0 <syscall>
  8018bc:	83 c4 18             	add    $0x18,%esp
}
  8018bf:	c9                   	leave  
  8018c0:	c3                   	ret    

008018c1 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8018c1:	55                   	push   %ebp
  8018c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8018c4:	6a 00                	push   $0x0
  8018c6:	6a 00                	push   $0x0
  8018c8:	6a 00                	push   $0x0
  8018ca:	6a 00                	push   $0x0
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 07                	push   $0x7
  8018d0:	e8 eb fc ff ff       	call   8015c0 <syscall>
  8018d5:	83 c4 18             	add    $0x18,%esp
}
  8018d8:	c9                   	leave  
  8018d9:	c3                   	ret    

008018da <sys_exit_env>:


void sys_exit_env(void)
{
  8018da:	55                   	push   %ebp
  8018db:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8018dd:	6a 00                	push   $0x0
  8018df:	6a 00                	push   $0x0
  8018e1:	6a 00                	push   $0x0
  8018e3:	6a 00                	push   $0x0
  8018e5:	6a 00                	push   $0x0
  8018e7:	6a 1c                	push   $0x1c
  8018e9:	e8 d2 fc ff ff       	call   8015c0 <syscall>
  8018ee:	83 c4 18             	add    $0x18,%esp
}
  8018f1:	90                   	nop
  8018f2:	c9                   	leave  
  8018f3:	c3                   	ret    

008018f4 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8018f4:	55                   	push   %ebp
  8018f5:	89 e5                	mov    %esp,%ebp
  8018f7:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8018fa:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8018fd:	8d 50 04             	lea    0x4(%eax),%edx
  801900:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801903:	6a 00                	push   $0x0
  801905:	6a 00                	push   $0x0
  801907:	6a 00                	push   $0x0
  801909:	52                   	push   %edx
  80190a:	50                   	push   %eax
  80190b:	6a 1d                	push   $0x1d
  80190d:	e8 ae fc ff ff       	call   8015c0 <syscall>
  801912:	83 c4 18             	add    $0x18,%esp
	return result;
  801915:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801918:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80191b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80191e:	89 01                	mov    %eax,(%ecx)
  801920:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801923:	8b 45 08             	mov    0x8(%ebp),%eax
  801926:	c9                   	leave  
  801927:	c2 04 00             	ret    $0x4

0080192a <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80192a:	55                   	push   %ebp
  80192b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	ff 75 10             	pushl  0x10(%ebp)
  801934:	ff 75 0c             	pushl  0xc(%ebp)
  801937:	ff 75 08             	pushl  0x8(%ebp)
  80193a:	6a 13                	push   $0x13
  80193c:	e8 7f fc ff ff       	call   8015c0 <syscall>
  801941:	83 c4 18             	add    $0x18,%esp
	return ;
  801944:	90                   	nop
}
  801945:	c9                   	leave  
  801946:	c3                   	ret    

00801947 <sys_rcr2>:
uint32 sys_rcr2()
{
  801947:	55                   	push   %ebp
  801948:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80194a:	6a 00                	push   $0x0
  80194c:	6a 00                	push   $0x0
  80194e:	6a 00                	push   $0x0
  801950:	6a 00                	push   $0x0
  801952:	6a 00                	push   $0x0
  801954:	6a 1e                	push   $0x1e
  801956:	e8 65 fc ff ff       	call   8015c0 <syscall>
  80195b:	83 c4 18             	add    $0x18,%esp
}
  80195e:	c9                   	leave  
  80195f:	c3                   	ret    

00801960 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801960:	55                   	push   %ebp
  801961:	89 e5                	mov    %esp,%ebp
  801963:	83 ec 04             	sub    $0x4,%esp
  801966:	8b 45 08             	mov    0x8(%ebp),%eax
  801969:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80196c:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801970:	6a 00                	push   $0x0
  801972:	6a 00                	push   $0x0
  801974:	6a 00                	push   $0x0
  801976:	6a 00                	push   $0x0
  801978:	50                   	push   %eax
  801979:	6a 1f                	push   $0x1f
  80197b:	e8 40 fc ff ff       	call   8015c0 <syscall>
  801980:	83 c4 18             	add    $0x18,%esp
	return ;
  801983:	90                   	nop
}
  801984:	c9                   	leave  
  801985:	c3                   	ret    

00801986 <rsttst>:
void rsttst()
{
  801986:	55                   	push   %ebp
  801987:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801989:	6a 00                	push   $0x0
  80198b:	6a 00                	push   $0x0
  80198d:	6a 00                	push   $0x0
  80198f:	6a 00                	push   $0x0
  801991:	6a 00                	push   $0x0
  801993:	6a 21                	push   $0x21
  801995:	e8 26 fc ff ff       	call   8015c0 <syscall>
  80199a:	83 c4 18             	add    $0x18,%esp
	return ;
  80199d:	90                   	nop
}
  80199e:	c9                   	leave  
  80199f:	c3                   	ret    

008019a0 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8019a0:	55                   	push   %ebp
  8019a1:	89 e5                	mov    %esp,%ebp
  8019a3:	83 ec 04             	sub    $0x4,%esp
  8019a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8019a9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8019ac:	8b 55 18             	mov    0x18(%ebp),%edx
  8019af:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019b3:	52                   	push   %edx
  8019b4:	50                   	push   %eax
  8019b5:	ff 75 10             	pushl  0x10(%ebp)
  8019b8:	ff 75 0c             	pushl  0xc(%ebp)
  8019bb:	ff 75 08             	pushl  0x8(%ebp)
  8019be:	6a 20                	push   $0x20
  8019c0:	e8 fb fb ff ff       	call   8015c0 <syscall>
  8019c5:	83 c4 18             	add    $0x18,%esp
	return ;
  8019c8:	90                   	nop
}
  8019c9:	c9                   	leave  
  8019ca:	c3                   	ret    

008019cb <chktst>:
void chktst(uint32 n)
{
  8019cb:	55                   	push   %ebp
  8019cc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 00                	push   $0x0
  8019d2:	6a 00                	push   $0x0
  8019d4:	6a 00                	push   $0x0
  8019d6:	ff 75 08             	pushl  0x8(%ebp)
  8019d9:	6a 22                	push   $0x22
  8019db:	e8 e0 fb ff ff       	call   8015c0 <syscall>
  8019e0:	83 c4 18             	add    $0x18,%esp
	return ;
  8019e3:	90                   	nop
}
  8019e4:	c9                   	leave  
  8019e5:	c3                   	ret    

008019e6 <inctst>:

void inctst()
{
  8019e6:	55                   	push   %ebp
  8019e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 23                	push   $0x23
  8019f5:	e8 c6 fb ff ff       	call   8015c0 <syscall>
  8019fa:	83 c4 18             	add    $0x18,%esp
	return ;
  8019fd:	90                   	nop
}
  8019fe:	c9                   	leave  
  8019ff:	c3                   	ret    

00801a00 <gettst>:
uint32 gettst()
{
  801a00:	55                   	push   %ebp
  801a01:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801a03:	6a 00                	push   $0x0
  801a05:	6a 00                	push   $0x0
  801a07:	6a 00                	push   $0x0
  801a09:	6a 00                	push   $0x0
  801a0b:	6a 00                	push   $0x0
  801a0d:	6a 24                	push   $0x24
  801a0f:	e8 ac fb ff ff       	call   8015c0 <syscall>
  801a14:	83 c4 18             	add    $0x18,%esp
}
  801a17:	c9                   	leave  
  801a18:	c3                   	ret    

00801a19 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801a19:	55                   	push   %ebp
  801a1a:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a1c:	6a 00                	push   $0x0
  801a1e:	6a 00                	push   $0x0
  801a20:	6a 00                	push   $0x0
  801a22:	6a 00                	push   $0x0
  801a24:	6a 00                	push   $0x0
  801a26:	6a 25                	push   $0x25
  801a28:	e8 93 fb ff ff       	call   8015c0 <syscall>
  801a2d:	83 c4 18             	add    $0x18,%esp
  801a30:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801a35:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801a3a:	c9                   	leave  
  801a3b:	c3                   	ret    

00801a3c <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801a3c:	55                   	push   %ebp
  801a3d:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a42:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801a47:	6a 00                	push   $0x0
  801a49:	6a 00                	push   $0x0
  801a4b:	6a 00                	push   $0x0
  801a4d:	6a 00                	push   $0x0
  801a4f:	ff 75 08             	pushl  0x8(%ebp)
  801a52:	6a 26                	push   $0x26
  801a54:	e8 67 fb ff ff       	call   8015c0 <syscall>
  801a59:	83 c4 18             	add    $0x18,%esp
	return ;
  801a5c:	90                   	nop
}
  801a5d:	c9                   	leave  
  801a5e:	c3                   	ret    

00801a5f <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801a5f:	55                   	push   %ebp
  801a60:	89 e5                	mov    %esp,%ebp
  801a62:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801a63:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a66:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a69:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6f:	6a 00                	push   $0x0
  801a71:	53                   	push   %ebx
  801a72:	51                   	push   %ecx
  801a73:	52                   	push   %edx
  801a74:	50                   	push   %eax
  801a75:	6a 27                	push   $0x27
  801a77:	e8 44 fb ff ff       	call   8015c0 <syscall>
  801a7c:	83 c4 18             	add    $0x18,%esp
}
  801a7f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a82:	c9                   	leave  
  801a83:	c3                   	ret    

00801a84 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801a84:	55                   	push   %ebp
  801a85:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801a87:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8d:	6a 00                	push   $0x0
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 00                	push   $0x0
  801a93:	52                   	push   %edx
  801a94:	50                   	push   %eax
  801a95:	6a 28                	push   $0x28
  801a97:	e8 24 fb ff ff       	call   8015c0 <syscall>
  801a9c:	83 c4 18             	add    $0x18,%esp
}
  801a9f:	c9                   	leave  
  801aa0:	c3                   	ret    

00801aa1 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801aa1:	55                   	push   %ebp
  801aa2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801aa4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801aa7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aaa:	8b 45 08             	mov    0x8(%ebp),%eax
  801aad:	6a 00                	push   $0x0
  801aaf:	51                   	push   %ecx
  801ab0:	ff 75 10             	pushl  0x10(%ebp)
  801ab3:	52                   	push   %edx
  801ab4:	50                   	push   %eax
  801ab5:	6a 29                	push   $0x29
  801ab7:	e8 04 fb ff ff       	call   8015c0 <syscall>
  801abc:	83 c4 18             	add    $0x18,%esp
}
  801abf:	c9                   	leave  
  801ac0:	c3                   	ret    

00801ac1 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801ac1:	55                   	push   %ebp
  801ac2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801ac4:	6a 00                	push   $0x0
  801ac6:	6a 00                	push   $0x0
  801ac8:	ff 75 10             	pushl  0x10(%ebp)
  801acb:	ff 75 0c             	pushl  0xc(%ebp)
  801ace:	ff 75 08             	pushl  0x8(%ebp)
  801ad1:	6a 12                	push   $0x12
  801ad3:	e8 e8 fa ff ff       	call   8015c0 <syscall>
  801ad8:	83 c4 18             	add    $0x18,%esp
	return ;
  801adb:	90                   	nop
}
  801adc:	c9                   	leave  
  801add:	c3                   	ret    

00801ade <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801ade:	55                   	push   %ebp
  801adf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801ae1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ae4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae7:	6a 00                	push   $0x0
  801ae9:	6a 00                	push   $0x0
  801aeb:	6a 00                	push   $0x0
  801aed:	52                   	push   %edx
  801aee:	50                   	push   %eax
  801aef:	6a 2a                	push   $0x2a
  801af1:	e8 ca fa ff ff       	call   8015c0 <syscall>
  801af6:	83 c4 18             	add    $0x18,%esp
	return;
  801af9:	90                   	nop
}
  801afa:	c9                   	leave  
  801afb:	c3                   	ret    

00801afc <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801afc:	55                   	push   %ebp
  801afd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801aff:	6a 00                	push   $0x0
  801b01:	6a 00                	push   $0x0
  801b03:	6a 00                	push   $0x0
  801b05:	6a 00                	push   $0x0
  801b07:	6a 00                	push   $0x0
  801b09:	6a 2b                	push   $0x2b
  801b0b:	e8 b0 fa ff ff       	call   8015c0 <syscall>
  801b10:	83 c4 18             	add    $0x18,%esp
}
  801b13:	c9                   	leave  
  801b14:	c3                   	ret    

00801b15 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b15:	55                   	push   %ebp
  801b16:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 00                	push   $0x0
  801b1c:	6a 00                	push   $0x0
  801b1e:	ff 75 0c             	pushl  0xc(%ebp)
  801b21:	ff 75 08             	pushl  0x8(%ebp)
  801b24:	6a 2d                	push   $0x2d
  801b26:	e8 95 fa ff ff       	call   8015c0 <syscall>
  801b2b:	83 c4 18             	add    $0x18,%esp
	return;
  801b2e:	90                   	nop
}
  801b2f:	c9                   	leave  
  801b30:	c3                   	ret    

00801b31 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801b31:	55                   	push   %ebp
  801b32:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801b34:	6a 00                	push   $0x0
  801b36:	6a 00                	push   $0x0
  801b38:	6a 00                	push   $0x0
  801b3a:	ff 75 0c             	pushl  0xc(%ebp)
  801b3d:	ff 75 08             	pushl  0x8(%ebp)
  801b40:	6a 2c                	push   $0x2c
  801b42:	e8 79 fa ff ff       	call   8015c0 <syscall>
  801b47:	83 c4 18             	add    $0x18,%esp
	return ;
  801b4a:	90                   	nop
}
  801b4b:	c9                   	leave  
  801b4c:	c3                   	ret    

00801b4d <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801b4d:	55                   	push   %ebp
  801b4e:	89 e5                	mov    %esp,%ebp
  801b50:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801b53:	83 ec 04             	sub    $0x4,%esp
  801b56:	68 f4 29 80 00       	push   $0x8029f4
  801b5b:	68 25 01 00 00       	push   $0x125
  801b60:	68 27 2a 80 00       	push   $0x802a27
  801b65:	e8 81 03 00 00       	call   801eeb <_panic>

00801b6a <to_page_va>:
//==================================================================================//
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  801b6a:	55                   	push   %ebp
  801b6b:	89 e5                	mov    %esp,%ebp
  801b6d:	83 ec 10             	sub    $0x10,%esp
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  801b70:	8b 45 08             	mov    0x8(%ebp),%eax
  801b73:	ba 60 30 80 00       	mov    $0x803060,%edx
  801b78:	29 d0                	sub    %edx,%eax
  801b7a:	c1 f8 02             	sar    $0x2,%eax
  801b7d:	89 c2                	mov    %eax,%edx
  801b7f:	89 d0                	mov    %edx,%eax
  801b81:	c1 e0 02             	shl    $0x2,%eax
  801b84:	01 d0                	add    %edx,%eax
  801b86:	c1 e0 02             	shl    $0x2,%eax
  801b89:	01 d0                	add    %edx,%eax
  801b8b:	c1 e0 02             	shl    $0x2,%eax
  801b8e:	01 d0                	add    %edx,%eax
  801b90:	89 c1                	mov    %eax,%ecx
  801b92:	c1 e1 08             	shl    $0x8,%ecx
  801b95:	01 c8                	add    %ecx,%eax
  801b97:	89 c1                	mov    %eax,%ecx
  801b99:	c1 e1 10             	shl    $0x10,%ecx
  801b9c:	01 c8                	add    %ecx,%eax
  801b9e:	01 c0                	add    %eax,%eax
  801ba0:	01 d0                	add    %edx,%eax
  801ba2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  801ba5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ba8:	c1 e0 0c             	shl    $0xc,%eax
  801bab:	89 c2                	mov    %eax,%edx
  801bad:	a1 64 b0 81 00       	mov    0x81b064,%eax
  801bb2:	01 d0                	add    %edx,%eax
}
  801bb4:	c9                   	leave  
  801bb5:	c3                   	ret    

00801bb6 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  801bb6:	55                   	push   %ebp
  801bb7:	89 e5                	mov    %esp,%ebp
  801bb9:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  801bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbf:	05 00 00 00 02       	add    $0x2000000,%eax
  801bc4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801bc7:	73 16                	jae    801bdf <initialize_dynamic_allocator+0x29>
  801bc9:	68 38 2a 80 00       	push   $0x802a38
  801bce:	68 5e 2a 80 00       	push   $0x802a5e
  801bd3:	6a 26                	push   $0x26
  801bd5:	68 73 2a 80 00       	push   $0x802a73
  801bda:	e8 0c 03 00 00       	call   801eeb <_panic>
		is_initialized = 1;
  801bdf:	c7 05 24 30 80 00 01 	movl   $0x1,0x803024
  801be6:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	//Comment the following line
	panic("initialize_dynamic_allocator() Not implemented yet");
  801be9:	83 ec 04             	sub    $0x4,%esp
  801bec:	68 8c 2a 80 00       	push   $0x802a8c
  801bf1:	6a 2e                	push   $0x2e
  801bf3:	68 73 2a 80 00       	push   $0x802a73
  801bf8:	e8 ee 02 00 00       	call   801eeb <_panic>

00801bfd <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  801bfd:	55                   	push   %ebp
  801bfe:	89 e5                	mov    %esp,%ebp
  801c00:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	//Comment the following line
	panic("get_block_size() Not implemented yet");
  801c03:	83 ec 04             	sub    $0x4,%esp
  801c06:	68 c0 2a 80 00       	push   $0x802ac0
  801c0b:	6a 3a                	push   $0x3a
  801c0d:	68 73 2a 80 00       	push   $0x802a73
  801c12:	e8 d4 02 00 00       	call   801eeb <_panic>

00801c17 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  801c17:	55                   	push   %ebp
  801c18:	89 e5                	mov    %esp,%ebp
  801c1a:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  801c1d:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801c24:	76 16                	jbe    801c3c <alloc_block+0x25>
  801c26:	68 e8 2a 80 00       	push   $0x802ae8
  801c2b:	68 5e 2a 80 00       	push   $0x802a5e
  801c30:	6a 46                	push   $0x46
  801c32:	68 73 2a 80 00       	push   $0x802a73
  801c37:	e8 af 02 00 00       	call   801eeb <_panic>
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	panic("alloc_block() Not implemented yet");
  801c3c:	83 ec 04             	sub    $0x4,%esp
  801c3f:	68 0c 2b 80 00       	push   $0x802b0c
  801c44:	6a 4d                	push   $0x4d
  801c46:	68 73 2a 80 00       	push   $0x802a73
  801c4b:	e8 9b 02 00 00       	call   801eeb <_panic>

00801c50 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  801c50:	55                   	push   %ebp
  801c51:	89 e5                	mov    %esp,%ebp
  801c53:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  801c56:	8b 55 08             	mov    0x8(%ebp),%edx
  801c59:	a1 64 b0 81 00       	mov    0x81b064,%eax
  801c5e:	39 c2                	cmp    %eax,%edx
  801c60:	72 0c                	jb     801c6e <free_block+0x1e>
  801c62:	8b 55 08             	mov    0x8(%ebp),%edx
  801c65:	a1 40 30 80 00       	mov    0x803040,%eax
  801c6a:	39 c2                	cmp    %eax,%edx
  801c6c:	72 16                	jb     801c84 <free_block+0x34>
  801c6e:	68 30 2b 80 00       	push   $0x802b30
  801c73:	68 5e 2a 80 00       	push   $0x802a5e
  801c78:	6a 5b                	push   $0x5b
  801c7a:	68 73 2a 80 00       	push   $0x802a73
  801c7f:	e8 67 02 00 00       	call   801eeb <_panic>
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	panic("free_block() Not implemented yet");
  801c84:	83 ec 04             	sub    $0x4,%esp
  801c87:	68 68 2b 80 00       	push   $0x802b68
  801c8c:	6a 63                	push   $0x63
  801c8e:	68 73 2a 80 00       	push   $0x802a73
  801c93:	e8 53 02 00 00       	call   801eeb <_panic>

00801c98 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  801c98:	55                   	push   %ebp
  801c99:	89 e5                	mov    %esp,%ebp
  801c9b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  801c9e:	83 ec 04             	sub    $0x4,%esp
  801ca1:	68 8c 2b 80 00       	push   $0x802b8c
  801ca6:	6a 72                	push   $0x72
  801ca8:	68 73 2a 80 00       	push   $0x802a73
  801cad:	e8 39 02 00 00       	call   801eeb <_panic>

00801cb2 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  801cb2:	55                   	push   %ebp
  801cb3:	89 e5                	mov    %esp,%ebp
  801cb5:	83 ec 08             	sub    $0x8,%esp
	panic("create_semaphore() is not implemented yet...!!");
  801cb8:	83 ec 04             	sub    $0x4,%esp
  801cbb:	68 b0 2b 80 00       	push   $0x802bb0
  801cc0:	6a 07                	push   $0x7
  801cc2:	68 df 2b 80 00       	push   $0x802bdf
  801cc7:	e8 1f 02 00 00       	call   801eeb <_panic>

00801ccc <get_semaphore>:
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ccc:	55                   	push   %ebp
  801ccd:	89 e5                	mov    %esp,%ebp
  801ccf:	83 ec 08             	sub    $0x8,%esp
	panic("get_semaphore() is not implemented yet...!!");
  801cd2:	83 ec 04             	sub    $0x4,%esp
  801cd5:	68 f0 2b 80 00       	push   $0x802bf0
  801cda:	6a 0b                	push   $0xb
  801cdc:	68 df 2b 80 00       	push   $0x802bdf
  801ce1:	e8 05 02 00 00       	call   801eeb <_panic>

00801ce6 <wait_semaphore>:
}

void wait_semaphore(struct semaphore sem)
{
  801ce6:	55                   	push   %ebp
  801ce7:	89 e5                	mov    %esp,%ebp
  801ce9:	83 ec 08             	sub    $0x8,%esp
	panic("wait_semaphore() is not implemented yet...!!");
  801cec:	83 ec 04             	sub    $0x4,%esp
  801cef:	68 1c 2c 80 00       	push   $0x802c1c
  801cf4:	6a 10                	push   $0x10
  801cf6:	68 df 2b 80 00       	push   $0x802bdf
  801cfb:	e8 eb 01 00 00       	call   801eeb <_panic>

00801d00 <signal_semaphore>:
}

void signal_semaphore(struct semaphore sem)
{
  801d00:	55                   	push   %ebp
  801d01:	89 e5                	mov    %esp,%ebp
  801d03:	83 ec 08             	sub    $0x8,%esp
	panic("signal_semaphore() is not implemented yet...!!");
  801d06:	83 ec 04             	sub    $0x4,%esp
  801d09:	68 4c 2c 80 00       	push   $0x802c4c
  801d0e:	6a 15                	push   $0x15
  801d10:	68 df 2b 80 00       	push   $0x802bdf
  801d15:	e8 d1 01 00 00       	call   801eeb <_panic>

00801d1a <semaphore_count>:
}

int semaphore_count(struct semaphore sem)
{
  801d1a:	55                   	push   %ebp
  801d1b:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  801d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d20:	8b 40 10             	mov    0x10(%eax),%eax
}
  801d23:	5d                   	pop    %ebp
  801d24:	c3                   	ret    

00801d25 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801d25:	55                   	push   %ebp
  801d26:	89 e5                	mov    %esp,%ebp
  801d28:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801d2b:	8b 55 08             	mov    0x8(%ebp),%edx
  801d2e:	89 d0                	mov    %edx,%eax
  801d30:	c1 e0 02             	shl    $0x2,%eax
  801d33:	01 d0                	add    %edx,%eax
  801d35:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801d3c:	01 d0                	add    %edx,%eax
  801d3e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801d45:	01 d0                	add    %edx,%eax
  801d47:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801d4e:	01 d0                	add    %edx,%eax
  801d50:	c1 e0 04             	shl    $0x4,%eax
  801d53:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  801d56:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  801d5d:	0f 31                	rdtsc  
  801d5f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801d62:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  801d65:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d68:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801d6b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d6e:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801d71:	eb 46                	jmp    801db9 <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  801d73:	0f 31                	rdtsc  
  801d75:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801d78:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  801d7b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801d7e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801d81:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801d84:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801d87:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d8d:	29 c2                	sub    %eax,%edx
  801d8f:	89 d0                	mov    %edx,%eax
  801d91:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801d94:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801d97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d9a:	89 d1                	mov    %edx,%ecx
  801d9c:	29 c1                	sub    %eax,%ecx
  801d9e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801da1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801da4:	39 c2                	cmp    %eax,%edx
  801da6:	0f 97 c0             	seta   %al
  801da9:	0f b6 c0             	movzbl %al,%eax
  801dac:	29 c1                	sub    %eax,%ecx
  801dae:	89 c8                	mov    %ecx,%eax
  801db0:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801db3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801db6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801db9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801dbc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801dbf:	72 b2                	jb     801d73 <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801dc1:	90                   	nop
  801dc2:	c9                   	leave  
  801dc3:	c3                   	ret    

00801dc4 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801dc4:	55                   	push   %ebp
  801dc5:	89 e5                	mov    %esp,%ebp
  801dc7:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801dca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801dd1:	eb 03                	jmp    801dd6 <busy_wait+0x12>
  801dd3:	ff 45 fc             	incl   -0x4(%ebp)
  801dd6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801dd9:	3b 45 08             	cmp    0x8(%ebp),%eax
  801ddc:	72 f5                	jb     801dd3 <busy_wait+0xf>
	return i;
  801dde:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801de1:	c9                   	leave  
  801de2:	c3                   	ret    

00801de3 <init_uspinlock>:
#include "inc/uspinlock.h"

extern volatile struct Env *myEnv;

void init_uspinlock(struct uspinlock *lk, char *name, bool isOpened)
{
  801de3:	55                   	push   %ebp
  801de4:	89 e5                	mov    %esp,%ebp
  801de6:	83 ec 08             	sub    $0x8,%esp
	assert(isOpened == 0 || isOpened == 1);
  801de9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ded:	74 1c                	je     801e0b <init_uspinlock+0x28>
  801def:	83 7d 10 01          	cmpl   $0x1,0x10(%ebp)
  801df3:	74 16                	je     801e0b <init_uspinlock+0x28>
  801df5:	68 7c 2c 80 00       	push   $0x802c7c
  801dfa:	68 9b 2c 80 00       	push   $0x802c9b
  801dff:	6a 10                	push   $0x10
  801e01:	68 b0 2c 80 00       	push   $0x802cb0
  801e06:	e8 e0 00 00 00       	call   801eeb <_panic>
	strcpy(lk->name, name);
  801e0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0e:	83 c0 04             	add    $0x4,%eax
  801e11:	83 ec 08             	sub    $0x8,%esp
  801e14:	ff 75 0c             	pushl  0xc(%ebp)
  801e17:	50                   	push   %eax
  801e18:	e8 2f ee ff ff       	call   800c4c <strcpy>
  801e1d:	83 c4 10             	add    $0x10,%esp
	lk->locked = (1 - isOpened);
  801e20:	b8 01 00 00 00       	mov    $0x1,%eax
  801e25:	2b 45 10             	sub    0x10(%ebp),%eax
  801e28:	89 c2                	mov    %eax,%edx
  801e2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2d:	89 10                	mov    %edx,(%eax)
}
  801e2f:	90                   	nop
  801e30:	c9                   	leave  
  801e31:	c3                   	ret    

00801e32 <acquire_uspinlock>:
// Acquire the lock.
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void acquire_uspinlock(struct uspinlock *lk)
{
  801e32:	55                   	push   %ebp
  801e33:	89 e5                	mov    %esp,%ebp
  801e35:	83 ec 18             	sub    $0x18,%esp
	// The xchg is atomic.
	while(xchg(&lk->locked, 1) != 0) ;
  801e38:	90                   	nop
  801e39:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e3f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
xchg(volatile uint32 *addr, uint32 newval)
{
  uint32 result;

  // The + in "+m" denotes a read-modify-write operand.
  __asm __volatile("lock; xchgl %0, %1" :
  801e46:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e4c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801e4f:	f0 87 02             	lock xchg %eax,(%edx)
  801e52:	89 45 ec             	mov    %eax,-0x14(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
  801e55:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e58:	85 c0                	test   %eax,%eax
  801e5a:	75 dd                	jne    801e39 <acquire_uspinlock+0x7>

	cprintf("[%d: %s] ACQUIRED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  801e5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5f:	8d 48 04             	lea    0x4(%eax),%ecx
  801e62:	a1 20 30 80 00       	mov    0x803020,%eax
  801e67:	8d 50 20             	lea    0x20(%eax),%edx
  801e6a:	a1 20 30 80 00       	mov    0x803020,%eax
  801e6f:	8b 40 10             	mov    0x10(%eax),%eax
  801e72:	51                   	push   %ecx
  801e73:	52                   	push   %edx
  801e74:	50                   	push   %eax
  801e75:	68 c0 2c 80 00       	push   $0x802cc0
  801e7a:	e8 a5 e6 ff ff       	call   800524 <cprintf>
  801e7f:	83 c4 10             	add    $0x10,%esp

	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that the critical section's memory
	// references happen after the lock is acquired.
	__sync_synchronize();
  801e82:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
}
  801e87:	90                   	nop
  801e88:	c9                   	leave  
  801e89:	c3                   	ret    

00801e8a <release_uspinlock>:

// Release the lock.
void release_uspinlock(struct uspinlock *lk)
{
  801e8a:	55                   	push   %ebp
  801e8b:	89 e5                	mov    %esp,%ebp
  801e8d:	83 ec 08             	sub    $0x8,%esp
	if(!(lk->locked))
  801e90:	8b 45 08             	mov    0x8(%ebp),%eax
  801e93:	8b 00                	mov    (%eax),%eax
  801e95:	85 c0                	test   %eax,%eax
  801e97:	75 18                	jne    801eb1 <release_uspinlock+0x27>
	{
		panic("release: lock \"%s\" is not held!", lk->name);
  801e99:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9c:	83 c0 04             	add    $0x4,%eax
  801e9f:	50                   	push   %eax
  801ea0:	68 e4 2c 80 00       	push   $0x802ce4
  801ea5:	6a 2b                	push   $0x2b
  801ea7:	68 b0 2c 80 00       	push   $0x802cb0
  801eac:	e8 3a 00 00 00       	call   801eeb <_panic>
	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that all the stores in the critical
	// section are visible to other cores before the lock is released.
	// Both the C compiler and the hardware may re-order loads and
	// stores; __sync_synchronize() tells them both not to.
	__sync_synchronize();
  801eb1:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

	// Release the lock, equivalent to lk->locked = 0.
	// This code can't use a C assignment, since it might
	// not be atomic. A real OS would use C atomics here.
	asm volatile("movl $0, %0" : "+m" (lk->locked) : );
  801eb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb9:	8b 55 08             	mov    0x8(%ebp),%edx
  801ebc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	cprintf("[%d: %s] RELEASED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  801ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec5:	8d 48 04             	lea    0x4(%eax),%ecx
  801ec8:	a1 20 30 80 00       	mov    0x803020,%eax
  801ecd:	8d 50 20             	lea    0x20(%eax),%edx
  801ed0:	a1 20 30 80 00       	mov    0x803020,%eax
  801ed5:	8b 40 10             	mov    0x10(%eax),%eax
  801ed8:	51                   	push   %ecx
  801ed9:	52                   	push   %edx
  801eda:	50                   	push   %eax
  801edb:	68 04 2d 80 00       	push   $0x802d04
  801ee0:	e8 3f e6 ff ff       	call   800524 <cprintf>
  801ee5:	83 c4 10             	add    $0x10,%esp
}
  801ee8:	90                   	nop
  801ee9:	c9                   	leave  
  801eea:	c3                   	ret    

00801eeb <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801eeb:	55                   	push   %ebp
  801eec:	89 e5                	mov    %esp,%ebp
  801eee:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801ef1:	8d 45 10             	lea    0x10(%ebp),%eax
  801ef4:	83 c0 04             	add    $0x4,%eax
  801ef7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801efa:	a1 1c b1 81 00       	mov    0x81b11c,%eax
  801eff:	85 c0                	test   %eax,%eax
  801f01:	74 16                	je     801f19 <_panic+0x2e>
		cprintf("%s: ", argv0);
  801f03:	a1 1c b1 81 00       	mov    0x81b11c,%eax
  801f08:	83 ec 08             	sub    $0x8,%esp
  801f0b:	50                   	push   %eax
  801f0c:	68 28 2d 80 00       	push   $0x802d28
  801f11:	e8 0e e6 ff ff       	call   800524 <cprintf>
  801f16:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  801f19:	a1 04 30 80 00       	mov    0x803004,%eax
  801f1e:	83 ec 0c             	sub    $0xc,%esp
  801f21:	ff 75 0c             	pushl  0xc(%ebp)
  801f24:	ff 75 08             	pushl  0x8(%ebp)
  801f27:	50                   	push   %eax
  801f28:	68 30 2d 80 00       	push   $0x802d30
  801f2d:	6a 74                	push   $0x74
  801f2f:	e8 1d e6 ff ff       	call   800551 <cprintf_colored>
  801f34:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  801f37:	8b 45 10             	mov    0x10(%ebp),%eax
  801f3a:	83 ec 08             	sub    $0x8,%esp
  801f3d:	ff 75 f4             	pushl  -0xc(%ebp)
  801f40:	50                   	push   %eax
  801f41:	e8 6f e5 ff ff       	call   8004b5 <vcprintf>
  801f46:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801f49:	83 ec 08             	sub    $0x8,%esp
  801f4c:	6a 00                	push   $0x0
  801f4e:	68 58 2d 80 00       	push   $0x802d58
  801f53:	e8 5d e5 ff ff       	call   8004b5 <vcprintf>
  801f58:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801f5b:	e8 d6 e4 ff ff       	call   800436 <exit>

	// should not return here
	while (1) ;
  801f60:	eb fe                	jmp    801f60 <_panic+0x75>

00801f62 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801f62:	55                   	push   %ebp
  801f63:	89 e5                	mov    %esp,%ebp
  801f65:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801f68:	a1 20 30 80 00       	mov    0x803020,%eax
  801f6d:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801f73:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f76:	39 c2                	cmp    %eax,%edx
  801f78:	74 14                	je     801f8e <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801f7a:	83 ec 04             	sub    $0x4,%esp
  801f7d:	68 5c 2d 80 00       	push   $0x802d5c
  801f82:	6a 26                	push   $0x26
  801f84:	68 a8 2d 80 00       	push   $0x802da8
  801f89:	e8 5d ff ff ff       	call   801eeb <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801f8e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801f95:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801f9c:	e9 c5 00 00 00       	jmp    802066 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801fa1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fa4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801fab:	8b 45 08             	mov    0x8(%ebp),%eax
  801fae:	01 d0                	add    %edx,%eax
  801fb0:	8b 00                	mov    (%eax),%eax
  801fb2:	85 c0                	test   %eax,%eax
  801fb4:	75 08                	jne    801fbe <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801fb6:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801fb9:	e9 a5 00 00 00       	jmp    802063 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801fbe:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801fc5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801fcc:	eb 69                	jmp    802037 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801fce:	a1 20 30 80 00       	mov    0x803020,%eax
  801fd3:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  801fd9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801fdc:	89 d0                	mov    %edx,%eax
  801fde:	01 c0                	add    %eax,%eax
  801fe0:	01 d0                	add    %edx,%eax
  801fe2:	c1 e0 03             	shl    $0x3,%eax
  801fe5:	01 c8                	add    %ecx,%eax
  801fe7:	8a 40 04             	mov    0x4(%eax),%al
  801fea:	84 c0                	test   %al,%al
  801fec:	75 46                	jne    802034 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801fee:	a1 20 30 80 00       	mov    0x803020,%eax
  801ff3:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  801ff9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801ffc:	89 d0                	mov    %edx,%eax
  801ffe:	01 c0                	add    %eax,%eax
  802000:	01 d0                	add    %edx,%eax
  802002:	c1 e0 03             	shl    $0x3,%eax
  802005:	01 c8                	add    %ecx,%eax
  802007:	8b 00                	mov    (%eax),%eax
  802009:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80200c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80200f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802014:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  802016:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802019:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  802020:	8b 45 08             	mov    0x8(%ebp),%eax
  802023:	01 c8                	add    %ecx,%eax
  802025:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  802027:	39 c2                	cmp    %eax,%edx
  802029:	75 09                	jne    802034 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80202b:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  802032:	eb 15                	jmp    802049 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802034:	ff 45 e8             	incl   -0x18(%ebp)
  802037:	a1 20 30 80 00       	mov    0x803020,%eax
  80203c:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  802042:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802045:	39 c2                	cmp    %eax,%edx
  802047:	77 85                	ja     801fce <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  802049:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80204d:	75 14                	jne    802063 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80204f:	83 ec 04             	sub    $0x4,%esp
  802052:	68 b4 2d 80 00       	push   $0x802db4
  802057:	6a 3a                	push   $0x3a
  802059:	68 a8 2d 80 00       	push   $0x802da8
  80205e:	e8 88 fe ff ff       	call   801eeb <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  802063:	ff 45 f0             	incl   -0x10(%ebp)
  802066:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802069:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80206c:	0f 8c 2f ff ff ff    	jl     801fa1 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  802072:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802079:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802080:	eb 26                	jmp    8020a8 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  802082:	a1 20 30 80 00       	mov    0x803020,%eax
  802087:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80208d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802090:	89 d0                	mov    %edx,%eax
  802092:	01 c0                	add    %eax,%eax
  802094:	01 d0                	add    %edx,%eax
  802096:	c1 e0 03             	shl    $0x3,%eax
  802099:	01 c8                	add    %ecx,%eax
  80209b:	8a 40 04             	mov    0x4(%eax),%al
  80209e:	3c 01                	cmp    $0x1,%al
  8020a0:	75 03                	jne    8020a5 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8020a2:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8020a5:	ff 45 e0             	incl   -0x20(%ebp)
  8020a8:	a1 20 30 80 00       	mov    0x803020,%eax
  8020ad:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8020b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020b6:	39 c2                	cmp    %eax,%edx
  8020b8:	77 c8                	ja     802082 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8020ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020bd:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8020c0:	74 14                	je     8020d6 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8020c2:	83 ec 04             	sub    $0x4,%esp
  8020c5:	68 08 2e 80 00       	push   $0x802e08
  8020ca:	6a 44                	push   $0x44
  8020cc:	68 a8 2d 80 00       	push   $0x802da8
  8020d1:	e8 15 fe ff ff       	call   801eeb <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8020d6:	90                   	nop
  8020d7:	c9                   	leave  
  8020d8:	c3                   	ret    
  8020d9:	66 90                	xchg   %ax,%ax
  8020db:	90                   	nop

008020dc <__udivdi3>:
  8020dc:	55                   	push   %ebp
  8020dd:	57                   	push   %edi
  8020de:	56                   	push   %esi
  8020df:	53                   	push   %ebx
  8020e0:	83 ec 1c             	sub    $0x1c,%esp
  8020e3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8020e7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8020eb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8020ef:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8020f3:	89 ca                	mov    %ecx,%edx
  8020f5:	89 f8                	mov    %edi,%eax
  8020f7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8020fb:	85 f6                	test   %esi,%esi
  8020fd:	75 2d                	jne    80212c <__udivdi3+0x50>
  8020ff:	39 cf                	cmp    %ecx,%edi
  802101:	77 65                	ja     802168 <__udivdi3+0x8c>
  802103:	89 fd                	mov    %edi,%ebp
  802105:	85 ff                	test   %edi,%edi
  802107:	75 0b                	jne    802114 <__udivdi3+0x38>
  802109:	b8 01 00 00 00       	mov    $0x1,%eax
  80210e:	31 d2                	xor    %edx,%edx
  802110:	f7 f7                	div    %edi
  802112:	89 c5                	mov    %eax,%ebp
  802114:	31 d2                	xor    %edx,%edx
  802116:	89 c8                	mov    %ecx,%eax
  802118:	f7 f5                	div    %ebp
  80211a:	89 c1                	mov    %eax,%ecx
  80211c:	89 d8                	mov    %ebx,%eax
  80211e:	f7 f5                	div    %ebp
  802120:	89 cf                	mov    %ecx,%edi
  802122:	89 fa                	mov    %edi,%edx
  802124:	83 c4 1c             	add    $0x1c,%esp
  802127:	5b                   	pop    %ebx
  802128:	5e                   	pop    %esi
  802129:	5f                   	pop    %edi
  80212a:	5d                   	pop    %ebp
  80212b:	c3                   	ret    
  80212c:	39 ce                	cmp    %ecx,%esi
  80212e:	77 28                	ja     802158 <__udivdi3+0x7c>
  802130:	0f bd fe             	bsr    %esi,%edi
  802133:	83 f7 1f             	xor    $0x1f,%edi
  802136:	75 40                	jne    802178 <__udivdi3+0x9c>
  802138:	39 ce                	cmp    %ecx,%esi
  80213a:	72 0a                	jb     802146 <__udivdi3+0x6a>
  80213c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802140:	0f 87 9e 00 00 00    	ja     8021e4 <__udivdi3+0x108>
  802146:	b8 01 00 00 00       	mov    $0x1,%eax
  80214b:	89 fa                	mov    %edi,%edx
  80214d:	83 c4 1c             	add    $0x1c,%esp
  802150:	5b                   	pop    %ebx
  802151:	5e                   	pop    %esi
  802152:	5f                   	pop    %edi
  802153:	5d                   	pop    %ebp
  802154:	c3                   	ret    
  802155:	8d 76 00             	lea    0x0(%esi),%esi
  802158:	31 ff                	xor    %edi,%edi
  80215a:	31 c0                	xor    %eax,%eax
  80215c:	89 fa                	mov    %edi,%edx
  80215e:	83 c4 1c             	add    $0x1c,%esp
  802161:	5b                   	pop    %ebx
  802162:	5e                   	pop    %esi
  802163:	5f                   	pop    %edi
  802164:	5d                   	pop    %ebp
  802165:	c3                   	ret    
  802166:	66 90                	xchg   %ax,%ax
  802168:	89 d8                	mov    %ebx,%eax
  80216a:	f7 f7                	div    %edi
  80216c:	31 ff                	xor    %edi,%edi
  80216e:	89 fa                	mov    %edi,%edx
  802170:	83 c4 1c             	add    $0x1c,%esp
  802173:	5b                   	pop    %ebx
  802174:	5e                   	pop    %esi
  802175:	5f                   	pop    %edi
  802176:	5d                   	pop    %ebp
  802177:	c3                   	ret    
  802178:	bd 20 00 00 00       	mov    $0x20,%ebp
  80217d:	89 eb                	mov    %ebp,%ebx
  80217f:	29 fb                	sub    %edi,%ebx
  802181:	89 f9                	mov    %edi,%ecx
  802183:	d3 e6                	shl    %cl,%esi
  802185:	89 c5                	mov    %eax,%ebp
  802187:	88 d9                	mov    %bl,%cl
  802189:	d3 ed                	shr    %cl,%ebp
  80218b:	89 e9                	mov    %ebp,%ecx
  80218d:	09 f1                	or     %esi,%ecx
  80218f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802193:	89 f9                	mov    %edi,%ecx
  802195:	d3 e0                	shl    %cl,%eax
  802197:	89 c5                	mov    %eax,%ebp
  802199:	89 d6                	mov    %edx,%esi
  80219b:	88 d9                	mov    %bl,%cl
  80219d:	d3 ee                	shr    %cl,%esi
  80219f:	89 f9                	mov    %edi,%ecx
  8021a1:	d3 e2                	shl    %cl,%edx
  8021a3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8021a7:	88 d9                	mov    %bl,%cl
  8021a9:	d3 e8                	shr    %cl,%eax
  8021ab:	09 c2                	or     %eax,%edx
  8021ad:	89 d0                	mov    %edx,%eax
  8021af:	89 f2                	mov    %esi,%edx
  8021b1:	f7 74 24 0c          	divl   0xc(%esp)
  8021b5:	89 d6                	mov    %edx,%esi
  8021b7:	89 c3                	mov    %eax,%ebx
  8021b9:	f7 e5                	mul    %ebp
  8021bb:	39 d6                	cmp    %edx,%esi
  8021bd:	72 19                	jb     8021d8 <__udivdi3+0xfc>
  8021bf:	74 0b                	je     8021cc <__udivdi3+0xf0>
  8021c1:	89 d8                	mov    %ebx,%eax
  8021c3:	31 ff                	xor    %edi,%edi
  8021c5:	e9 58 ff ff ff       	jmp    802122 <__udivdi3+0x46>
  8021ca:	66 90                	xchg   %ax,%ax
  8021cc:	8b 54 24 08          	mov    0x8(%esp),%edx
  8021d0:	89 f9                	mov    %edi,%ecx
  8021d2:	d3 e2                	shl    %cl,%edx
  8021d4:	39 c2                	cmp    %eax,%edx
  8021d6:	73 e9                	jae    8021c1 <__udivdi3+0xe5>
  8021d8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8021db:	31 ff                	xor    %edi,%edi
  8021dd:	e9 40 ff ff ff       	jmp    802122 <__udivdi3+0x46>
  8021e2:	66 90                	xchg   %ax,%ax
  8021e4:	31 c0                	xor    %eax,%eax
  8021e6:	e9 37 ff ff ff       	jmp    802122 <__udivdi3+0x46>
  8021eb:	90                   	nop

008021ec <__umoddi3>:
  8021ec:	55                   	push   %ebp
  8021ed:	57                   	push   %edi
  8021ee:	56                   	push   %esi
  8021ef:	53                   	push   %ebx
  8021f0:	83 ec 1c             	sub    $0x1c,%esp
  8021f3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8021f7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8021fb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8021ff:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802203:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802207:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80220b:	89 f3                	mov    %esi,%ebx
  80220d:	89 fa                	mov    %edi,%edx
  80220f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802213:	89 34 24             	mov    %esi,(%esp)
  802216:	85 c0                	test   %eax,%eax
  802218:	75 1a                	jne    802234 <__umoddi3+0x48>
  80221a:	39 f7                	cmp    %esi,%edi
  80221c:	0f 86 a2 00 00 00    	jbe    8022c4 <__umoddi3+0xd8>
  802222:	89 c8                	mov    %ecx,%eax
  802224:	89 f2                	mov    %esi,%edx
  802226:	f7 f7                	div    %edi
  802228:	89 d0                	mov    %edx,%eax
  80222a:	31 d2                	xor    %edx,%edx
  80222c:	83 c4 1c             	add    $0x1c,%esp
  80222f:	5b                   	pop    %ebx
  802230:	5e                   	pop    %esi
  802231:	5f                   	pop    %edi
  802232:	5d                   	pop    %ebp
  802233:	c3                   	ret    
  802234:	39 f0                	cmp    %esi,%eax
  802236:	0f 87 ac 00 00 00    	ja     8022e8 <__umoddi3+0xfc>
  80223c:	0f bd e8             	bsr    %eax,%ebp
  80223f:	83 f5 1f             	xor    $0x1f,%ebp
  802242:	0f 84 ac 00 00 00    	je     8022f4 <__umoddi3+0x108>
  802248:	bf 20 00 00 00       	mov    $0x20,%edi
  80224d:	29 ef                	sub    %ebp,%edi
  80224f:	89 fe                	mov    %edi,%esi
  802251:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802255:	89 e9                	mov    %ebp,%ecx
  802257:	d3 e0                	shl    %cl,%eax
  802259:	89 d7                	mov    %edx,%edi
  80225b:	89 f1                	mov    %esi,%ecx
  80225d:	d3 ef                	shr    %cl,%edi
  80225f:	09 c7                	or     %eax,%edi
  802261:	89 e9                	mov    %ebp,%ecx
  802263:	d3 e2                	shl    %cl,%edx
  802265:	89 14 24             	mov    %edx,(%esp)
  802268:	89 d8                	mov    %ebx,%eax
  80226a:	d3 e0                	shl    %cl,%eax
  80226c:	89 c2                	mov    %eax,%edx
  80226e:	8b 44 24 08          	mov    0x8(%esp),%eax
  802272:	d3 e0                	shl    %cl,%eax
  802274:	89 44 24 04          	mov    %eax,0x4(%esp)
  802278:	8b 44 24 08          	mov    0x8(%esp),%eax
  80227c:	89 f1                	mov    %esi,%ecx
  80227e:	d3 e8                	shr    %cl,%eax
  802280:	09 d0                	or     %edx,%eax
  802282:	d3 eb                	shr    %cl,%ebx
  802284:	89 da                	mov    %ebx,%edx
  802286:	f7 f7                	div    %edi
  802288:	89 d3                	mov    %edx,%ebx
  80228a:	f7 24 24             	mull   (%esp)
  80228d:	89 c6                	mov    %eax,%esi
  80228f:	89 d1                	mov    %edx,%ecx
  802291:	39 d3                	cmp    %edx,%ebx
  802293:	0f 82 87 00 00 00    	jb     802320 <__umoddi3+0x134>
  802299:	0f 84 91 00 00 00    	je     802330 <__umoddi3+0x144>
  80229f:	8b 54 24 04          	mov    0x4(%esp),%edx
  8022a3:	29 f2                	sub    %esi,%edx
  8022a5:	19 cb                	sbb    %ecx,%ebx
  8022a7:	89 d8                	mov    %ebx,%eax
  8022a9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8022ad:	d3 e0                	shl    %cl,%eax
  8022af:	89 e9                	mov    %ebp,%ecx
  8022b1:	d3 ea                	shr    %cl,%edx
  8022b3:	09 d0                	or     %edx,%eax
  8022b5:	89 e9                	mov    %ebp,%ecx
  8022b7:	d3 eb                	shr    %cl,%ebx
  8022b9:	89 da                	mov    %ebx,%edx
  8022bb:	83 c4 1c             	add    $0x1c,%esp
  8022be:	5b                   	pop    %ebx
  8022bf:	5e                   	pop    %esi
  8022c0:	5f                   	pop    %edi
  8022c1:	5d                   	pop    %ebp
  8022c2:	c3                   	ret    
  8022c3:	90                   	nop
  8022c4:	89 fd                	mov    %edi,%ebp
  8022c6:	85 ff                	test   %edi,%edi
  8022c8:	75 0b                	jne    8022d5 <__umoddi3+0xe9>
  8022ca:	b8 01 00 00 00       	mov    $0x1,%eax
  8022cf:	31 d2                	xor    %edx,%edx
  8022d1:	f7 f7                	div    %edi
  8022d3:	89 c5                	mov    %eax,%ebp
  8022d5:	89 f0                	mov    %esi,%eax
  8022d7:	31 d2                	xor    %edx,%edx
  8022d9:	f7 f5                	div    %ebp
  8022db:	89 c8                	mov    %ecx,%eax
  8022dd:	f7 f5                	div    %ebp
  8022df:	89 d0                	mov    %edx,%eax
  8022e1:	e9 44 ff ff ff       	jmp    80222a <__umoddi3+0x3e>
  8022e6:	66 90                	xchg   %ax,%ax
  8022e8:	89 c8                	mov    %ecx,%eax
  8022ea:	89 f2                	mov    %esi,%edx
  8022ec:	83 c4 1c             	add    $0x1c,%esp
  8022ef:	5b                   	pop    %ebx
  8022f0:	5e                   	pop    %esi
  8022f1:	5f                   	pop    %edi
  8022f2:	5d                   	pop    %ebp
  8022f3:	c3                   	ret    
  8022f4:	3b 04 24             	cmp    (%esp),%eax
  8022f7:	72 06                	jb     8022ff <__umoddi3+0x113>
  8022f9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8022fd:	77 0f                	ja     80230e <__umoddi3+0x122>
  8022ff:	89 f2                	mov    %esi,%edx
  802301:	29 f9                	sub    %edi,%ecx
  802303:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802307:	89 14 24             	mov    %edx,(%esp)
  80230a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80230e:	8b 44 24 04          	mov    0x4(%esp),%eax
  802312:	8b 14 24             	mov    (%esp),%edx
  802315:	83 c4 1c             	add    $0x1c,%esp
  802318:	5b                   	pop    %ebx
  802319:	5e                   	pop    %esi
  80231a:	5f                   	pop    %edi
  80231b:	5d                   	pop    %ebp
  80231c:	c3                   	ret    
  80231d:	8d 76 00             	lea    0x0(%esi),%esi
  802320:	2b 04 24             	sub    (%esp),%eax
  802323:	19 fa                	sbb    %edi,%edx
  802325:	89 d1                	mov    %edx,%ecx
  802327:	89 c6                	mov    %eax,%esi
  802329:	e9 71 ff ff ff       	jmp    80229f <__umoddi3+0xb3>
  80232e:	66 90                	xchg   %ax,%ax
  802330:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802334:	72 ea                	jb     802320 <__umoddi3+0x134>
  802336:	89 d9                	mov    %ebx,%ecx
  802338:	e9 62 ff ff ff       	jmp    80229f <__umoddi3+0xb3>


obj/user/ef_tst_semaphore_1master:     file format elf32-i386


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
  800031:	e8 eb 01 00 00       	call   800221 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Master program: create the semaphores, run slaves and wait them to finish
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 38             	sub    $0x38,%esp
	int envID = sys_getenvid();
  80003e:	e8 10 18 00 00       	call   801853 <sys_getenvid>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)

	struct semaphore cs1 = create_semaphore("cs1", 1);
  800046:	8d 45 d8             	lea    -0x28(%ebp),%eax
  800049:	83 ec 04             	sub    $0x4,%esp
  80004c:	6a 01                	push   $0x1
  80004e:	68 20 1e 80 00       	push   $0x801e20
  800053:	50                   	push   %eax
  800054:	e8 d5 1a 00 00       	call   801b2e <create_semaphore>
  800059:	83 c4 0c             	add    $0xc,%esp
	struct semaphore depend1 = create_semaphore("depend1", 0);
  80005c:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  80005f:	83 ec 04             	sub    $0x4,%esp
  800062:	6a 00                	push   $0x0
  800064:	68 24 1e 80 00       	push   $0x801e24
  800069:	50                   	push   %eax
  80006a:	e8 bf 1a 00 00       	call   801b2e <create_semaphore>
  80006f:	83 c4 0c             	add    $0xc,%esp

	int id1, id2, id3;
	id1 = sys_create_env("ef_sem1Slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  800072:	a1 20 30 80 00       	mov    0x803020,%eax
  800077:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  80007d:	89 c2                	mov    %eax,%edx
  80007f:	a1 20 30 80 00       	mov    0x803020,%eax
  800084:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80008a:	6a 32                	push   $0x32
  80008c:	52                   	push   %edx
  80008d:	50                   	push   %eax
  80008e:	68 2c 1e 80 00       	push   $0x801e2c
  800093:	e8 66 17 00 00       	call   8017fe <sys_create_env>
  800098:	83 c4 10             	add    $0x10,%esp
  80009b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	id2 = sys_create_env("ef_sem1Slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  80009e:	a1 20 30 80 00       	mov    0x803020,%eax
  8000a3:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  8000a9:	89 c2                	mov    %eax,%edx
  8000ab:	a1 20 30 80 00       	mov    0x803020,%eax
  8000b0:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000b6:	6a 32                	push   $0x32
  8000b8:	52                   	push   %edx
  8000b9:	50                   	push   %eax
  8000ba:	68 2c 1e 80 00       	push   $0x801e2c
  8000bf:	e8 3a 17 00 00       	call   8017fe <sys_create_env>
  8000c4:	83 c4 10             	add    $0x10,%esp
  8000c7:	89 45 ec             	mov    %eax,-0x14(%ebp)
	id3 = sys_create_env("ef_sem1Slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  8000ca:	a1 20 30 80 00       	mov    0x803020,%eax
  8000cf:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  8000d5:	89 c2                	mov    %eax,%edx
  8000d7:	a1 20 30 80 00       	mov    0x803020,%eax
  8000dc:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000e2:	6a 32                	push   $0x32
  8000e4:	52                   	push   %edx
  8000e5:	50                   	push   %eax
  8000e6:	68 2c 1e 80 00       	push   $0x801e2c
  8000eb:	e8 0e 17 00 00       	call   8017fe <sys_create_env>
  8000f0:	83 c4 10             	add    $0x10,%esp
  8000f3:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if (id1 == E_ENV_CREATION_ERROR || id2 == E_ENV_CREATION_ERROR || id3 == E_ENV_CREATION_ERROR)
  8000f6:	83 7d f0 ef          	cmpl   $0xffffffef,-0x10(%ebp)
  8000fa:	74 0c                	je     800108 <_main+0xd0>
  8000fc:	83 7d ec ef          	cmpl   $0xffffffef,-0x14(%ebp)
  800100:	74 06                	je     800108 <_main+0xd0>
  800102:	83 7d e8 ef          	cmpl   $0xffffffef,-0x18(%ebp)
  800106:	75 14                	jne    80011c <_main+0xe4>
		panic("NO AVAILABLE ENVs...");
  800108:	83 ec 04             	sub    $0x4,%esp
  80010b:	68 39 1e 80 00       	push   $0x801e39
  800110:	6a 12                	push   $0x12
  800112:	68 50 1e 80 00       	push   $0x801e50
  800117:	e8 b5 02 00 00       	call   8003d1 <_panic>

	sys_run_env(id1);
  80011c:	83 ec 0c             	sub    $0xc,%esp
  80011f:	ff 75 f0             	pushl  -0x10(%ebp)
  800122:	e8 f5 16 00 00       	call   80181c <sys_run_env>
  800127:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id2);
  80012a:	83 ec 0c             	sub    $0xc,%esp
  80012d:	ff 75 ec             	pushl  -0x14(%ebp)
  800130:	e8 e7 16 00 00       	call   80181c <sys_run_env>
  800135:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id3);
  800138:	83 ec 0c             	sub    $0xc,%esp
  80013b:	ff 75 e8             	pushl  -0x18(%ebp)
  80013e:	e8 d9 16 00 00       	call   80181c <sys_run_env>
  800143:	83 c4 10             	add    $0x10,%esp

	wait_semaphore(depend1) ;
  800146:	83 ec 0c             	sub    $0xc,%esp
  800149:	ff 75 d4             	pushl  -0x2c(%ebp)
  80014c:	e8 11 1a 00 00       	call   801b62 <wait_semaphore>
  800151:	83 c4 10             	add    $0x10,%esp
	wait_semaphore(depend1) ;
  800154:	83 ec 0c             	sub    $0xc,%esp
  800157:	ff 75 d4             	pushl  -0x2c(%ebp)
  80015a:	e8 03 1a 00 00       	call   801b62 <wait_semaphore>
  80015f:	83 c4 10             	add    $0x10,%esp
	wait_semaphore(depend1) ;
  800162:	83 ec 0c             	sub    $0xc,%esp
  800165:	ff 75 d4             	pushl  -0x2c(%ebp)
  800168:	e8 f5 19 00 00       	call   801b62 <wait_semaphore>
  80016d:	83 c4 10             	add    $0x10,%esp

	int sem1val = semaphore_count(cs1);
  800170:	83 ec 0c             	sub    $0xc,%esp
  800173:	ff 75 d8             	pushl  -0x28(%ebp)
  800176:	e8 1b 1a 00 00       	call   801b96 <semaphore_count>
  80017b:	83 c4 10             	add    $0x10,%esp
  80017e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int sem2val = semaphore_count(depend1);
  800181:	83 ec 0c             	sub    $0xc,%esp
  800184:	ff 75 d4             	pushl  -0x2c(%ebp)
  800187:	e8 0a 1a 00 00       	call   801b96 <semaphore_count>
  80018c:	83 c4 10             	add    $0x10,%esp
  80018f:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (sem2val == 0 && sem1val == 1)
  800192:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800196:	75 18                	jne    8001b0 <_main+0x178>
  800198:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  80019c:	75 12                	jne    8001b0 <_main+0x178>
		cprintf("Test of Semaphores is finished!!\n\n\n");
  80019e:	83 ec 0c             	sub    $0xc,%esp
  8001a1:	68 70 1e 80 00       	push   $0x801e70
  8001a6:	e8 f4 04 00 00       	call   80069f <cprintf>
  8001ab:	83 c4 10             	add    $0x10,%esp
  8001ae:	eb 10                	jmp    8001c0 <_main+0x188>
	else
		cprintf("Error: wrong semaphore value... please review your semaphore code again...");
  8001b0:	83 ec 0c             	sub    $0xc,%esp
  8001b3:	68 94 1e 80 00       	push   $0x801e94
  8001b8:	e8 e2 04 00 00       	call   80069f <cprintf>
  8001bd:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  8001c0:	e8 c0 16 00 00       	call   801885 <sys_getparentenvid>
  8001c5:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if(parentenvID > 0)
  8001c8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8001cc:	7e 50                	jle    80021e <_main+0x1e6>
	{
		sys_destroy_env(id1);
  8001ce:	83 ec 0c             	sub    $0xc,%esp
  8001d1:	ff 75 f0             	pushl  -0x10(%ebp)
  8001d4:	e8 5f 16 00 00       	call   801838 <sys_destroy_env>
  8001d9:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(id2);
  8001dc:	83 ec 0c             	sub    $0xc,%esp
  8001df:	ff 75 ec             	pushl  -0x14(%ebp)
  8001e2:	e8 51 16 00 00       	call   801838 <sys_destroy_env>
  8001e7:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(id3);
  8001ea:	83 ec 0c             	sub    $0xc,%esp
  8001ed:	ff 75 e8             	pushl  -0x18(%ebp)
  8001f0:	e8 43 16 00 00       	call   801838 <sys_destroy_env>
  8001f5:	83 c4 10             	add    $0x10,%esp
		struct semaphore depend0 = get_semaphore(parentenvID, "depend0");
  8001f8:	8d 45 d0             	lea    -0x30(%ebp),%eax
  8001fb:	83 ec 04             	sub    $0x4,%esp
  8001fe:	68 df 1e 80 00       	push   $0x801edf
  800203:	ff 75 dc             	pushl  -0x24(%ebp)
  800206:	50                   	push   %eax
  800207:	e8 3c 19 00 00       	call   801b48 <get_semaphore>
  80020c:	83 c4 0c             	add    $0xc,%esp
		signal_semaphore(depend0);
  80020f:	83 ec 0c             	sub    $0xc,%esp
  800212:	ff 75 d0             	pushl  -0x30(%ebp)
  800215:	e8 62 19 00 00       	call   801b7c <signal_semaphore>
  80021a:	83 c4 10             	add    $0x10,%esp
//		int *finishedCount = NULL;
//		finishedCount = sget(parentenvID, "finishedCount") ;
//		(*finishedCount)++ ;
	}

	return;
  80021d:	90                   	nop
  80021e:	90                   	nop
}
  80021f:	c9                   	leave  
  800220:	c3                   	ret    

00800221 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800221:	55                   	push   %ebp
  800222:	89 e5                	mov    %esp,%ebp
  800224:	57                   	push   %edi
  800225:	56                   	push   %esi
  800226:	53                   	push   %ebx
  800227:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80022a:	e8 3d 16 00 00       	call   80186c <sys_getenvindex>
  80022f:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800232:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800235:	89 d0                	mov    %edx,%eax
  800237:	c1 e0 02             	shl    $0x2,%eax
  80023a:	01 d0                	add    %edx,%eax
  80023c:	c1 e0 03             	shl    $0x3,%eax
  80023f:	01 d0                	add    %edx,%eax
  800241:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800248:	01 d0                	add    %edx,%eax
  80024a:	c1 e0 02             	shl    $0x2,%eax
  80024d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800252:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800257:	a1 20 30 80 00       	mov    0x803020,%eax
  80025c:	8a 40 20             	mov    0x20(%eax),%al
  80025f:	84 c0                	test   %al,%al
  800261:	74 0d                	je     800270 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800263:	a1 20 30 80 00       	mov    0x803020,%eax
  800268:	83 c0 20             	add    $0x20,%eax
  80026b:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800270:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800274:	7e 0a                	jle    800280 <libmain+0x5f>
		binaryname = argv[0];
  800276:	8b 45 0c             	mov    0xc(%ebp),%eax
  800279:	8b 00                	mov    (%eax),%eax
  80027b:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  800280:	83 ec 08             	sub    $0x8,%esp
  800283:	ff 75 0c             	pushl  0xc(%ebp)
  800286:	ff 75 08             	pushl  0x8(%ebp)
  800289:	e8 aa fd ff ff       	call   800038 <_main>
  80028e:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800291:	a1 00 30 80 00       	mov    0x803000,%eax
  800296:	85 c0                	test   %eax,%eax
  800298:	0f 84 01 01 00 00    	je     80039f <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80029e:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8002a4:	bb e0 1f 80 00       	mov    $0x801fe0,%ebx
  8002a9:	ba 0e 00 00 00       	mov    $0xe,%edx
  8002ae:	89 c7                	mov    %eax,%edi
  8002b0:	89 de                	mov    %ebx,%esi
  8002b2:	89 d1                	mov    %edx,%ecx
  8002b4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8002b6:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8002b9:	b9 56 00 00 00       	mov    $0x56,%ecx
  8002be:	b0 00                	mov    $0x0,%al
  8002c0:	89 d7                	mov    %edx,%edi
  8002c2:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8002c4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8002cb:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8002ce:	83 ec 08             	sub    $0x8,%esp
  8002d1:	50                   	push   %eax
  8002d2:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8002d8:	50                   	push   %eax
  8002d9:	e8 c4 17 00 00       	call   801aa2 <sys_utilities>
  8002de:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8002e1:	e8 0d 13 00 00       	call   8015f3 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8002e6:	83 ec 0c             	sub    $0xc,%esp
  8002e9:	68 00 1f 80 00       	push   $0x801f00
  8002ee:	e8 ac 03 00 00       	call   80069f <cprintf>
  8002f3:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8002f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002f9:	85 c0                	test   %eax,%eax
  8002fb:	74 18                	je     800315 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8002fd:	e8 be 17 00 00       	call   801ac0 <sys_get_optimal_num_faults>
  800302:	83 ec 08             	sub    $0x8,%esp
  800305:	50                   	push   %eax
  800306:	68 28 1f 80 00       	push   $0x801f28
  80030b:	e8 8f 03 00 00       	call   80069f <cprintf>
  800310:	83 c4 10             	add    $0x10,%esp
  800313:	eb 59                	jmp    80036e <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800315:	a1 20 30 80 00       	mov    0x803020,%eax
  80031a:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  800320:	a1 20 30 80 00       	mov    0x803020,%eax
  800325:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  80032b:	83 ec 04             	sub    $0x4,%esp
  80032e:	52                   	push   %edx
  80032f:	50                   	push   %eax
  800330:	68 4c 1f 80 00       	push   $0x801f4c
  800335:	e8 65 03 00 00       	call   80069f <cprintf>
  80033a:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80033d:	a1 20 30 80 00       	mov    0x803020,%eax
  800342:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800348:	a1 20 30 80 00       	mov    0x803020,%eax
  80034d:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  800353:	a1 20 30 80 00       	mov    0x803020,%eax
  800358:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  80035e:	51                   	push   %ecx
  80035f:	52                   	push   %edx
  800360:	50                   	push   %eax
  800361:	68 74 1f 80 00       	push   $0x801f74
  800366:	e8 34 03 00 00       	call   80069f <cprintf>
  80036b:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80036e:	a1 20 30 80 00       	mov    0x803020,%eax
  800373:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  800379:	83 ec 08             	sub    $0x8,%esp
  80037c:	50                   	push   %eax
  80037d:	68 cc 1f 80 00       	push   $0x801fcc
  800382:	e8 18 03 00 00       	call   80069f <cprintf>
  800387:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80038a:	83 ec 0c             	sub    $0xc,%esp
  80038d:	68 00 1f 80 00       	push   $0x801f00
  800392:	e8 08 03 00 00       	call   80069f <cprintf>
  800397:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80039a:	e8 6e 12 00 00       	call   80160d <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80039f:	e8 1f 00 00 00       	call   8003c3 <exit>
}
  8003a4:	90                   	nop
  8003a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003a8:	5b                   	pop    %ebx
  8003a9:	5e                   	pop    %esi
  8003aa:	5f                   	pop    %edi
  8003ab:	5d                   	pop    %ebp
  8003ac:	c3                   	ret    

008003ad <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8003ad:	55                   	push   %ebp
  8003ae:	89 e5                	mov    %esp,%ebp
  8003b0:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8003b3:	83 ec 0c             	sub    $0xc,%esp
  8003b6:	6a 00                	push   $0x0
  8003b8:	e8 7b 14 00 00       	call   801838 <sys_destroy_env>
  8003bd:	83 c4 10             	add    $0x10,%esp
}
  8003c0:	90                   	nop
  8003c1:	c9                   	leave  
  8003c2:	c3                   	ret    

008003c3 <exit>:

void
exit(void)
{
  8003c3:	55                   	push   %ebp
  8003c4:	89 e5                	mov    %esp,%ebp
  8003c6:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8003c9:	e8 d0 14 00 00       	call   80189e <sys_exit_env>
}
  8003ce:	90                   	nop
  8003cf:	c9                   	leave  
  8003d0:	c3                   	ret    

008003d1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8003d1:	55                   	push   %ebp
  8003d2:	89 e5                	mov    %esp,%ebp
  8003d4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8003d7:	8d 45 10             	lea    0x10(%ebp),%eax
  8003da:	83 c0 04             	add    $0x4,%eax
  8003dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8003e0:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8003e5:	85 c0                	test   %eax,%eax
  8003e7:	74 16                	je     8003ff <_panic+0x2e>
		cprintf("%s: ", argv0);
  8003e9:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8003ee:	83 ec 08             	sub    $0x8,%esp
  8003f1:	50                   	push   %eax
  8003f2:	68 44 20 80 00       	push   $0x802044
  8003f7:	e8 a3 02 00 00       	call   80069f <cprintf>
  8003fc:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8003ff:	a1 04 30 80 00       	mov    0x803004,%eax
  800404:	83 ec 0c             	sub    $0xc,%esp
  800407:	ff 75 0c             	pushl  0xc(%ebp)
  80040a:	ff 75 08             	pushl  0x8(%ebp)
  80040d:	50                   	push   %eax
  80040e:	68 4c 20 80 00       	push   $0x80204c
  800413:	6a 74                	push   $0x74
  800415:	e8 b2 02 00 00       	call   8006cc <cprintf_colored>
  80041a:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  80041d:	8b 45 10             	mov    0x10(%ebp),%eax
  800420:	83 ec 08             	sub    $0x8,%esp
  800423:	ff 75 f4             	pushl  -0xc(%ebp)
  800426:	50                   	push   %eax
  800427:	e8 04 02 00 00       	call   800630 <vcprintf>
  80042c:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80042f:	83 ec 08             	sub    $0x8,%esp
  800432:	6a 00                	push   $0x0
  800434:	68 74 20 80 00       	push   $0x802074
  800439:	e8 f2 01 00 00       	call   800630 <vcprintf>
  80043e:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800441:	e8 7d ff ff ff       	call   8003c3 <exit>

	// should not return here
	while (1) ;
  800446:	eb fe                	jmp    800446 <_panic+0x75>

00800448 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800448:	55                   	push   %ebp
  800449:	89 e5                	mov    %esp,%ebp
  80044b:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80044e:	a1 20 30 80 00       	mov    0x803020,%eax
  800453:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800459:	8b 45 0c             	mov    0xc(%ebp),%eax
  80045c:	39 c2                	cmp    %eax,%edx
  80045e:	74 14                	je     800474 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800460:	83 ec 04             	sub    $0x4,%esp
  800463:	68 78 20 80 00       	push   $0x802078
  800468:	6a 26                	push   $0x26
  80046a:	68 c4 20 80 00       	push   $0x8020c4
  80046f:	e8 5d ff ff ff       	call   8003d1 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800474:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80047b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800482:	e9 c5 00 00 00       	jmp    80054c <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800487:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80048a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800491:	8b 45 08             	mov    0x8(%ebp),%eax
  800494:	01 d0                	add    %edx,%eax
  800496:	8b 00                	mov    (%eax),%eax
  800498:	85 c0                	test   %eax,%eax
  80049a:	75 08                	jne    8004a4 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80049c:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80049f:	e9 a5 00 00 00       	jmp    800549 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8004a4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004ab:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8004b2:	eb 69                	jmp    80051d <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8004b4:	a1 20 30 80 00       	mov    0x803020,%eax
  8004b9:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8004bf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004c2:	89 d0                	mov    %edx,%eax
  8004c4:	01 c0                	add    %eax,%eax
  8004c6:	01 d0                	add    %edx,%eax
  8004c8:	c1 e0 03             	shl    $0x3,%eax
  8004cb:	01 c8                	add    %ecx,%eax
  8004cd:	8a 40 04             	mov    0x4(%eax),%al
  8004d0:	84 c0                	test   %al,%al
  8004d2:	75 46                	jne    80051a <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004d4:	a1 20 30 80 00       	mov    0x803020,%eax
  8004d9:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8004df:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004e2:	89 d0                	mov    %edx,%eax
  8004e4:	01 c0                	add    %eax,%eax
  8004e6:	01 d0                	add    %edx,%eax
  8004e8:	c1 e0 03             	shl    $0x3,%eax
  8004eb:	01 c8                	add    %ecx,%eax
  8004ed:	8b 00                	mov    (%eax),%eax
  8004ef:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8004f2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004f5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8004fa:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8004fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004ff:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800506:	8b 45 08             	mov    0x8(%ebp),%eax
  800509:	01 c8                	add    %ecx,%eax
  80050b:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80050d:	39 c2                	cmp    %eax,%edx
  80050f:	75 09                	jne    80051a <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800511:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800518:	eb 15                	jmp    80052f <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80051a:	ff 45 e8             	incl   -0x18(%ebp)
  80051d:	a1 20 30 80 00       	mov    0x803020,%eax
  800522:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800528:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80052b:	39 c2                	cmp    %eax,%edx
  80052d:	77 85                	ja     8004b4 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80052f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800533:	75 14                	jne    800549 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800535:	83 ec 04             	sub    $0x4,%esp
  800538:	68 d0 20 80 00       	push   $0x8020d0
  80053d:	6a 3a                	push   $0x3a
  80053f:	68 c4 20 80 00       	push   $0x8020c4
  800544:	e8 88 fe ff ff       	call   8003d1 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800549:	ff 45 f0             	incl   -0x10(%ebp)
  80054c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80054f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800552:	0f 8c 2f ff ff ff    	jl     800487 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800558:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80055f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800566:	eb 26                	jmp    80058e <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800568:	a1 20 30 80 00       	mov    0x803020,%eax
  80056d:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800573:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800576:	89 d0                	mov    %edx,%eax
  800578:	01 c0                	add    %eax,%eax
  80057a:	01 d0                	add    %edx,%eax
  80057c:	c1 e0 03             	shl    $0x3,%eax
  80057f:	01 c8                	add    %ecx,%eax
  800581:	8a 40 04             	mov    0x4(%eax),%al
  800584:	3c 01                	cmp    $0x1,%al
  800586:	75 03                	jne    80058b <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800588:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80058b:	ff 45 e0             	incl   -0x20(%ebp)
  80058e:	a1 20 30 80 00       	mov    0x803020,%eax
  800593:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800599:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80059c:	39 c2                	cmp    %eax,%edx
  80059e:	77 c8                	ja     800568 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8005a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005a3:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8005a6:	74 14                	je     8005bc <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8005a8:	83 ec 04             	sub    $0x4,%esp
  8005ab:	68 24 21 80 00       	push   $0x802124
  8005b0:	6a 44                	push   $0x44
  8005b2:	68 c4 20 80 00       	push   $0x8020c4
  8005b7:	e8 15 fe ff ff       	call   8003d1 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8005bc:	90                   	nop
  8005bd:	c9                   	leave  
  8005be:	c3                   	ret    

008005bf <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8005bf:	55                   	push   %ebp
  8005c0:	89 e5                	mov    %esp,%ebp
  8005c2:	53                   	push   %ebx
  8005c3:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8005c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005c9:	8b 00                	mov    (%eax),%eax
  8005cb:	8d 48 01             	lea    0x1(%eax),%ecx
  8005ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005d1:	89 0a                	mov    %ecx,(%edx)
  8005d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8005d6:	88 d1                	mov    %dl,%cl
  8005d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005db:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8005df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005e2:	8b 00                	mov    (%eax),%eax
  8005e4:	3d ff 00 00 00       	cmp    $0xff,%eax
  8005e9:	75 30                	jne    80061b <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8005eb:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  8005f1:	a0 44 30 80 00       	mov    0x803044,%al
  8005f6:	0f b6 c0             	movzbl %al,%eax
  8005f9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005fc:	8b 09                	mov    (%ecx),%ecx
  8005fe:	89 cb                	mov    %ecx,%ebx
  800600:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800603:	83 c1 08             	add    $0x8,%ecx
  800606:	52                   	push   %edx
  800607:	50                   	push   %eax
  800608:	53                   	push   %ebx
  800609:	51                   	push   %ecx
  80060a:	e8 a0 0f 00 00       	call   8015af <sys_cputs>
  80060f:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800612:	8b 45 0c             	mov    0xc(%ebp),%eax
  800615:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80061b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80061e:	8b 40 04             	mov    0x4(%eax),%eax
  800621:	8d 50 01             	lea    0x1(%eax),%edx
  800624:	8b 45 0c             	mov    0xc(%ebp),%eax
  800627:	89 50 04             	mov    %edx,0x4(%eax)
}
  80062a:	90                   	nop
  80062b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80062e:	c9                   	leave  
  80062f:	c3                   	ret    

00800630 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800630:	55                   	push   %ebp
  800631:	89 e5                	mov    %esp,%ebp
  800633:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800639:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800640:	00 00 00 
	b.cnt = 0;
  800643:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80064a:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80064d:	ff 75 0c             	pushl  0xc(%ebp)
  800650:	ff 75 08             	pushl  0x8(%ebp)
  800653:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800659:	50                   	push   %eax
  80065a:	68 bf 05 80 00       	push   $0x8005bf
  80065f:	e8 5a 02 00 00       	call   8008be <vprintfmt>
  800664:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800667:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  80066d:	a0 44 30 80 00       	mov    0x803044,%al
  800672:	0f b6 c0             	movzbl %al,%eax
  800675:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  80067b:	52                   	push   %edx
  80067c:	50                   	push   %eax
  80067d:	51                   	push   %ecx
  80067e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800684:	83 c0 08             	add    $0x8,%eax
  800687:	50                   	push   %eax
  800688:	e8 22 0f 00 00       	call   8015af <sys_cputs>
  80068d:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800690:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  800697:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80069d:	c9                   	leave  
  80069e:	c3                   	ret    

0080069f <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80069f:	55                   	push   %ebp
  8006a0:	89 e5                	mov    %esp,%ebp
  8006a2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8006a5:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  8006ac:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006af:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b5:	83 ec 08             	sub    $0x8,%esp
  8006b8:	ff 75 f4             	pushl  -0xc(%ebp)
  8006bb:	50                   	push   %eax
  8006bc:	e8 6f ff ff ff       	call   800630 <vcprintf>
  8006c1:	83 c4 10             	add    $0x10,%esp
  8006c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8006c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006ca:	c9                   	leave  
  8006cb:	c3                   	ret    

008006cc <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8006cc:	55                   	push   %ebp
  8006cd:	89 e5                	mov    %esp,%ebp
  8006cf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8006d2:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  8006d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006dc:	c1 e0 08             	shl    $0x8,%eax
  8006df:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  8006e4:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006e7:	83 c0 04             	add    $0x4,%eax
  8006ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006f0:	83 ec 08             	sub    $0x8,%esp
  8006f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8006f6:	50                   	push   %eax
  8006f7:	e8 34 ff ff ff       	call   800630 <vcprintf>
  8006fc:	83 c4 10             	add    $0x10,%esp
  8006ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800702:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  800709:	07 00 00 

	return cnt;
  80070c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80070f:	c9                   	leave  
  800710:	c3                   	ret    

00800711 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800711:	55                   	push   %ebp
  800712:	89 e5                	mov    %esp,%ebp
  800714:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800717:	e8 d7 0e 00 00       	call   8015f3 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80071c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80071f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800722:	8b 45 08             	mov    0x8(%ebp),%eax
  800725:	83 ec 08             	sub    $0x8,%esp
  800728:	ff 75 f4             	pushl  -0xc(%ebp)
  80072b:	50                   	push   %eax
  80072c:	e8 ff fe ff ff       	call   800630 <vcprintf>
  800731:	83 c4 10             	add    $0x10,%esp
  800734:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800737:	e8 d1 0e 00 00       	call   80160d <sys_unlock_cons>
	return cnt;
  80073c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80073f:	c9                   	leave  
  800740:	c3                   	ret    

00800741 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800741:	55                   	push   %ebp
  800742:	89 e5                	mov    %esp,%ebp
  800744:	53                   	push   %ebx
  800745:	83 ec 14             	sub    $0x14,%esp
  800748:	8b 45 10             	mov    0x10(%ebp),%eax
  80074b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80074e:	8b 45 14             	mov    0x14(%ebp),%eax
  800751:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800754:	8b 45 18             	mov    0x18(%ebp),%eax
  800757:	ba 00 00 00 00       	mov    $0x0,%edx
  80075c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80075f:	77 55                	ja     8007b6 <printnum+0x75>
  800761:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800764:	72 05                	jb     80076b <printnum+0x2a>
  800766:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800769:	77 4b                	ja     8007b6 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80076b:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80076e:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800771:	8b 45 18             	mov    0x18(%ebp),%eax
  800774:	ba 00 00 00 00       	mov    $0x0,%edx
  800779:	52                   	push   %edx
  80077a:	50                   	push   %eax
  80077b:	ff 75 f4             	pushl  -0xc(%ebp)
  80077e:	ff 75 f0             	pushl  -0x10(%ebp)
  800781:	e8 1e 14 00 00       	call   801ba4 <__udivdi3>
  800786:	83 c4 10             	add    $0x10,%esp
  800789:	83 ec 04             	sub    $0x4,%esp
  80078c:	ff 75 20             	pushl  0x20(%ebp)
  80078f:	53                   	push   %ebx
  800790:	ff 75 18             	pushl  0x18(%ebp)
  800793:	52                   	push   %edx
  800794:	50                   	push   %eax
  800795:	ff 75 0c             	pushl  0xc(%ebp)
  800798:	ff 75 08             	pushl  0x8(%ebp)
  80079b:	e8 a1 ff ff ff       	call   800741 <printnum>
  8007a0:	83 c4 20             	add    $0x20,%esp
  8007a3:	eb 1a                	jmp    8007bf <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8007a5:	83 ec 08             	sub    $0x8,%esp
  8007a8:	ff 75 0c             	pushl  0xc(%ebp)
  8007ab:	ff 75 20             	pushl  0x20(%ebp)
  8007ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b1:	ff d0                	call   *%eax
  8007b3:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8007b6:	ff 4d 1c             	decl   0x1c(%ebp)
  8007b9:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8007bd:	7f e6                	jg     8007a5 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8007bf:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8007c2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007cd:	53                   	push   %ebx
  8007ce:	51                   	push   %ecx
  8007cf:	52                   	push   %edx
  8007d0:	50                   	push   %eax
  8007d1:	e8 de 14 00 00       	call   801cb4 <__umoddi3>
  8007d6:	83 c4 10             	add    $0x10,%esp
  8007d9:	05 94 23 80 00       	add    $0x802394,%eax
  8007de:	8a 00                	mov    (%eax),%al
  8007e0:	0f be c0             	movsbl %al,%eax
  8007e3:	83 ec 08             	sub    $0x8,%esp
  8007e6:	ff 75 0c             	pushl  0xc(%ebp)
  8007e9:	50                   	push   %eax
  8007ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ed:	ff d0                	call   *%eax
  8007ef:	83 c4 10             	add    $0x10,%esp
}
  8007f2:	90                   	nop
  8007f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007f6:	c9                   	leave  
  8007f7:	c3                   	ret    

008007f8 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007f8:	55                   	push   %ebp
  8007f9:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007fb:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007ff:	7e 1c                	jle    80081d <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800801:	8b 45 08             	mov    0x8(%ebp),%eax
  800804:	8b 00                	mov    (%eax),%eax
  800806:	8d 50 08             	lea    0x8(%eax),%edx
  800809:	8b 45 08             	mov    0x8(%ebp),%eax
  80080c:	89 10                	mov    %edx,(%eax)
  80080e:	8b 45 08             	mov    0x8(%ebp),%eax
  800811:	8b 00                	mov    (%eax),%eax
  800813:	83 e8 08             	sub    $0x8,%eax
  800816:	8b 50 04             	mov    0x4(%eax),%edx
  800819:	8b 00                	mov    (%eax),%eax
  80081b:	eb 40                	jmp    80085d <getuint+0x65>
	else if (lflag)
  80081d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800821:	74 1e                	je     800841 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800823:	8b 45 08             	mov    0x8(%ebp),%eax
  800826:	8b 00                	mov    (%eax),%eax
  800828:	8d 50 04             	lea    0x4(%eax),%edx
  80082b:	8b 45 08             	mov    0x8(%ebp),%eax
  80082e:	89 10                	mov    %edx,(%eax)
  800830:	8b 45 08             	mov    0x8(%ebp),%eax
  800833:	8b 00                	mov    (%eax),%eax
  800835:	83 e8 04             	sub    $0x4,%eax
  800838:	8b 00                	mov    (%eax),%eax
  80083a:	ba 00 00 00 00       	mov    $0x0,%edx
  80083f:	eb 1c                	jmp    80085d <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800841:	8b 45 08             	mov    0x8(%ebp),%eax
  800844:	8b 00                	mov    (%eax),%eax
  800846:	8d 50 04             	lea    0x4(%eax),%edx
  800849:	8b 45 08             	mov    0x8(%ebp),%eax
  80084c:	89 10                	mov    %edx,(%eax)
  80084e:	8b 45 08             	mov    0x8(%ebp),%eax
  800851:	8b 00                	mov    (%eax),%eax
  800853:	83 e8 04             	sub    $0x4,%eax
  800856:	8b 00                	mov    (%eax),%eax
  800858:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80085d:	5d                   	pop    %ebp
  80085e:	c3                   	ret    

0080085f <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80085f:	55                   	push   %ebp
  800860:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800862:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800866:	7e 1c                	jle    800884 <getint+0x25>
		return va_arg(*ap, long long);
  800868:	8b 45 08             	mov    0x8(%ebp),%eax
  80086b:	8b 00                	mov    (%eax),%eax
  80086d:	8d 50 08             	lea    0x8(%eax),%edx
  800870:	8b 45 08             	mov    0x8(%ebp),%eax
  800873:	89 10                	mov    %edx,(%eax)
  800875:	8b 45 08             	mov    0x8(%ebp),%eax
  800878:	8b 00                	mov    (%eax),%eax
  80087a:	83 e8 08             	sub    $0x8,%eax
  80087d:	8b 50 04             	mov    0x4(%eax),%edx
  800880:	8b 00                	mov    (%eax),%eax
  800882:	eb 38                	jmp    8008bc <getint+0x5d>
	else if (lflag)
  800884:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800888:	74 1a                	je     8008a4 <getint+0x45>
		return va_arg(*ap, long);
  80088a:	8b 45 08             	mov    0x8(%ebp),%eax
  80088d:	8b 00                	mov    (%eax),%eax
  80088f:	8d 50 04             	lea    0x4(%eax),%edx
  800892:	8b 45 08             	mov    0x8(%ebp),%eax
  800895:	89 10                	mov    %edx,(%eax)
  800897:	8b 45 08             	mov    0x8(%ebp),%eax
  80089a:	8b 00                	mov    (%eax),%eax
  80089c:	83 e8 04             	sub    $0x4,%eax
  80089f:	8b 00                	mov    (%eax),%eax
  8008a1:	99                   	cltd   
  8008a2:	eb 18                	jmp    8008bc <getint+0x5d>
	else
		return va_arg(*ap, int);
  8008a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a7:	8b 00                	mov    (%eax),%eax
  8008a9:	8d 50 04             	lea    0x4(%eax),%edx
  8008ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8008af:	89 10                	mov    %edx,(%eax)
  8008b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b4:	8b 00                	mov    (%eax),%eax
  8008b6:	83 e8 04             	sub    $0x4,%eax
  8008b9:	8b 00                	mov    (%eax),%eax
  8008bb:	99                   	cltd   
}
  8008bc:	5d                   	pop    %ebp
  8008bd:	c3                   	ret    

008008be <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8008be:	55                   	push   %ebp
  8008bf:	89 e5                	mov    %esp,%ebp
  8008c1:	56                   	push   %esi
  8008c2:	53                   	push   %ebx
  8008c3:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008c6:	eb 17                	jmp    8008df <vprintfmt+0x21>
			if (ch == '\0')
  8008c8:	85 db                	test   %ebx,%ebx
  8008ca:	0f 84 c1 03 00 00    	je     800c91 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8008d0:	83 ec 08             	sub    $0x8,%esp
  8008d3:	ff 75 0c             	pushl  0xc(%ebp)
  8008d6:	53                   	push   %ebx
  8008d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008da:	ff d0                	call   *%eax
  8008dc:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008df:	8b 45 10             	mov    0x10(%ebp),%eax
  8008e2:	8d 50 01             	lea    0x1(%eax),%edx
  8008e5:	89 55 10             	mov    %edx,0x10(%ebp)
  8008e8:	8a 00                	mov    (%eax),%al
  8008ea:	0f b6 d8             	movzbl %al,%ebx
  8008ed:	83 fb 25             	cmp    $0x25,%ebx
  8008f0:	75 d6                	jne    8008c8 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008f2:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8008f6:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8008fd:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800904:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80090b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800912:	8b 45 10             	mov    0x10(%ebp),%eax
  800915:	8d 50 01             	lea    0x1(%eax),%edx
  800918:	89 55 10             	mov    %edx,0x10(%ebp)
  80091b:	8a 00                	mov    (%eax),%al
  80091d:	0f b6 d8             	movzbl %al,%ebx
  800920:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800923:	83 f8 5b             	cmp    $0x5b,%eax
  800926:	0f 87 3d 03 00 00    	ja     800c69 <vprintfmt+0x3ab>
  80092c:	8b 04 85 b8 23 80 00 	mov    0x8023b8(,%eax,4),%eax
  800933:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800935:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800939:	eb d7                	jmp    800912 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80093b:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80093f:	eb d1                	jmp    800912 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800941:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800948:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80094b:	89 d0                	mov    %edx,%eax
  80094d:	c1 e0 02             	shl    $0x2,%eax
  800950:	01 d0                	add    %edx,%eax
  800952:	01 c0                	add    %eax,%eax
  800954:	01 d8                	add    %ebx,%eax
  800956:	83 e8 30             	sub    $0x30,%eax
  800959:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80095c:	8b 45 10             	mov    0x10(%ebp),%eax
  80095f:	8a 00                	mov    (%eax),%al
  800961:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800964:	83 fb 2f             	cmp    $0x2f,%ebx
  800967:	7e 3e                	jle    8009a7 <vprintfmt+0xe9>
  800969:	83 fb 39             	cmp    $0x39,%ebx
  80096c:	7f 39                	jg     8009a7 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80096e:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800971:	eb d5                	jmp    800948 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800973:	8b 45 14             	mov    0x14(%ebp),%eax
  800976:	83 c0 04             	add    $0x4,%eax
  800979:	89 45 14             	mov    %eax,0x14(%ebp)
  80097c:	8b 45 14             	mov    0x14(%ebp),%eax
  80097f:	83 e8 04             	sub    $0x4,%eax
  800982:	8b 00                	mov    (%eax),%eax
  800984:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800987:	eb 1f                	jmp    8009a8 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800989:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80098d:	79 83                	jns    800912 <vprintfmt+0x54>
				width = 0;
  80098f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800996:	e9 77 ff ff ff       	jmp    800912 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80099b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8009a2:	e9 6b ff ff ff       	jmp    800912 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8009a7:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8009a8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009ac:	0f 89 60 ff ff ff    	jns    800912 <vprintfmt+0x54>
				width = precision, precision = -1;
  8009b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8009b8:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8009bf:	e9 4e ff ff ff       	jmp    800912 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8009c4:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8009c7:	e9 46 ff ff ff       	jmp    800912 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8009cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8009cf:	83 c0 04             	add    $0x4,%eax
  8009d2:	89 45 14             	mov    %eax,0x14(%ebp)
  8009d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d8:	83 e8 04             	sub    $0x4,%eax
  8009db:	8b 00                	mov    (%eax),%eax
  8009dd:	83 ec 08             	sub    $0x8,%esp
  8009e0:	ff 75 0c             	pushl  0xc(%ebp)
  8009e3:	50                   	push   %eax
  8009e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e7:	ff d0                	call   *%eax
  8009e9:	83 c4 10             	add    $0x10,%esp
			break;
  8009ec:	e9 9b 02 00 00       	jmp    800c8c <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8009f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f4:	83 c0 04             	add    $0x4,%eax
  8009f7:	89 45 14             	mov    %eax,0x14(%ebp)
  8009fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8009fd:	83 e8 04             	sub    $0x4,%eax
  800a00:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a02:	85 db                	test   %ebx,%ebx
  800a04:	79 02                	jns    800a08 <vprintfmt+0x14a>
				err = -err;
  800a06:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a08:	83 fb 64             	cmp    $0x64,%ebx
  800a0b:	7f 0b                	jg     800a18 <vprintfmt+0x15a>
  800a0d:	8b 34 9d 00 22 80 00 	mov    0x802200(,%ebx,4),%esi
  800a14:	85 f6                	test   %esi,%esi
  800a16:	75 19                	jne    800a31 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a18:	53                   	push   %ebx
  800a19:	68 a5 23 80 00       	push   $0x8023a5
  800a1e:	ff 75 0c             	pushl  0xc(%ebp)
  800a21:	ff 75 08             	pushl  0x8(%ebp)
  800a24:	e8 70 02 00 00       	call   800c99 <printfmt>
  800a29:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a2c:	e9 5b 02 00 00       	jmp    800c8c <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a31:	56                   	push   %esi
  800a32:	68 ae 23 80 00       	push   $0x8023ae
  800a37:	ff 75 0c             	pushl  0xc(%ebp)
  800a3a:	ff 75 08             	pushl  0x8(%ebp)
  800a3d:	e8 57 02 00 00       	call   800c99 <printfmt>
  800a42:	83 c4 10             	add    $0x10,%esp
			break;
  800a45:	e9 42 02 00 00       	jmp    800c8c <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a4a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a4d:	83 c0 04             	add    $0x4,%eax
  800a50:	89 45 14             	mov    %eax,0x14(%ebp)
  800a53:	8b 45 14             	mov    0x14(%ebp),%eax
  800a56:	83 e8 04             	sub    $0x4,%eax
  800a59:	8b 30                	mov    (%eax),%esi
  800a5b:	85 f6                	test   %esi,%esi
  800a5d:	75 05                	jne    800a64 <vprintfmt+0x1a6>
				p = "(null)";
  800a5f:	be b1 23 80 00       	mov    $0x8023b1,%esi
			if (width > 0 && padc != '-')
  800a64:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a68:	7e 6d                	jle    800ad7 <vprintfmt+0x219>
  800a6a:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800a6e:	74 67                	je     800ad7 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a70:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a73:	83 ec 08             	sub    $0x8,%esp
  800a76:	50                   	push   %eax
  800a77:	56                   	push   %esi
  800a78:	e8 1e 03 00 00       	call   800d9b <strnlen>
  800a7d:	83 c4 10             	add    $0x10,%esp
  800a80:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800a83:	eb 16                	jmp    800a9b <vprintfmt+0x1dd>
					putch(padc, putdat);
  800a85:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800a89:	83 ec 08             	sub    $0x8,%esp
  800a8c:	ff 75 0c             	pushl  0xc(%ebp)
  800a8f:	50                   	push   %eax
  800a90:	8b 45 08             	mov    0x8(%ebp),%eax
  800a93:	ff d0                	call   *%eax
  800a95:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a98:	ff 4d e4             	decl   -0x1c(%ebp)
  800a9b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a9f:	7f e4                	jg     800a85 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800aa1:	eb 34                	jmp    800ad7 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800aa3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800aa7:	74 1c                	je     800ac5 <vprintfmt+0x207>
  800aa9:	83 fb 1f             	cmp    $0x1f,%ebx
  800aac:	7e 05                	jle    800ab3 <vprintfmt+0x1f5>
  800aae:	83 fb 7e             	cmp    $0x7e,%ebx
  800ab1:	7e 12                	jle    800ac5 <vprintfmt+0x207>
					putch('?', putdat);
  800ab3:	83 ec 08             	sub    $0x8,%esp
  800ab6:	ff 75 0c             	pushl  0xc(%ebp)
  800ab9:	6a 3f                	push   $0x3f
  800abb:	8b 45 08             	mov    0x8(%ebp),%eax
  800abe:	ff d0                	call   *%eax
  800ac0:	83 c4 10             	add    $0x10,%esp
  800ac3:	eb 0f                	jmp    800ad4 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800ac5:	83 ec 08             	sub    $0x8,%esp
  800ac8:	ff 75 0c             	pushl  0xc(%ebp)
  800acb:	53                   	push   %ebx
  800acc:	8b 45 08             	mov    0x8(%ebp),%eax
  800acf:	ff d0                	call   *%eax
  800ad1:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ad4:	ff 4d e4             	decl   -0x1c(%ebp)
  800ad7:	89 f0                	mov    %esi,%eax
  800ad9:	8d 70 01             	lea    0x1(%eax),%esi
  800adc:	8a 00                	mov    (%eax),%al
  800ade:	0f be d8             	movsbl %al,%ebx
  800ae1:	85 db                	test   %ebx,%ebx
  800ae3:	74 24                	je     800b09 <vprintfmt+0x24b>
  800ae5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ae9:	78 b8                	js     800aa3 <vprintfmt+0x1e5>
  800aeb:	ff 4d e0             	decl   -0x20(%ebp)
  800aee:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800af2:	79 af                	jns    800aa3 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800af4:	eb 13                	jmp    800b09 <vprintfmt+0x24b>
				putch(' ', putdat);
  800af6:	83 ec 08             	sub    $0x8,%esp
  800af9:	ff 75 0c             	pushl  0xc(%ebp)
  800afc:	6a 20                	push   $0x20
  800afe:	8b 45 08             	mov    0x8(%ebp),%eax
  800b01:	ff d0                	call   *%eax
  800b03:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b06:	ff 4d e4             	decl   -0x1c(%ebp)
  800b09:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b0d:	7f e7                	jg     800af6 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b0f:	e9 78 01 00 00       	jmp    800c8c <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b14:	83 ec 08             	sub    $0x8,%esp
  800b17:	ff 75 e8             	pushl  -0x18(%ebp)
  800b1a:	8d 45 14             	lea    0x14(%ebp),%eax
  800b1d:	50                   	push   %eax
  800b1e:	e8 3c fd ff ff       	call   80085f <getint>
  800b23:	83 c4 10             	add    $0x10,%esp
  800b26:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b29:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800b2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b2f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b32:	85 d2                	test   %edx,%edx
  800b34:	79 23                	jns    800b59 <vprintfmt+0x29b>
				putch('-', putdat);
  800b36:	83 ec 08             	sub    $0x8,%esp
  800b39:	ff 75 0c             	pushl  0xc(%ebp)
  800b3c:	6a 2d                	push   $0x2d
  800b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b41:	ff d0                	call   *%eax
  800b43:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800b46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b49:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b4c:	f7 d8                	neg    %eax
  800b4e:	83 d2 00             	adc    $0x0,%edx
  800b51:	f7 da                	neg    %edx
  800b53:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b56:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800b59:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b60:	e9 bc 00 00 00       	jmp    800c21 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b65:	83 ec 08             	sub    $0x8,%esp
  800b68:	ff 75 e8             	pushl  -0x18(%ebp)
  800b6b:	8d 45 14             	lea    0x14(%ebp),%eax
  800b6e:	50                   	push   %eax
  800b6f:	e8 84 fc ff ff       	call   8007f8 <getuint>
  800b74:	83 c4 10             	add    $0x10,%esp
  800b77:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b7a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800b7d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b84:	e9 98 00 00 00       	jmp    800c21 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b89:	83 ec 08             	sub    $0x8,%esp
  800b8c:	ff 75 0c             	pushl  0xc(%ebp)
  800b8f:	6a 58                	push   $0x58
  800b91:	8b 45 08             	mov    0x8(%ebp),%eax
  800b94:	ff d0                	call   *%eax
  800b96:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b99:	83 ec 08             	sub    $0x8,%esp
  800b9c:	ff 75 0c             	pushl  0xc(%ebp)
  800b9f:	6a 58                	push   $0x58
  800ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba4:	ff d0                	call   *%eax
  800ba6:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ba9:	83 ec 08             	sub    $0x8,%esp
  800bac:	ff 75 0c             	pushl  0xc(%ebp)
  800baf:	6a 58                	push   $0x58
  800bb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb4:	ff d0                	call   *%eax
  800bb6:	83 c4 10             	add    $0x10,%esp
			break;
  800bb9:	e9 ce 00 00 00       	jmp    800c8c <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800bbe:	83 ec 08             	sub    $0x8,%esp
  800bc1:	ff 75 0c             	pushl  0xc(%ebp)
  800bc4:	6a 30                	push   $0x30
  800bc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc9:	ff d0                	call   *%eax
  800bcb:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800bce:	83 ec 08             	sub    $0x8,%esp
  800bd1:	ff 75 0c             	pushl  0xc(%ebp)
  800bd4:	6a 78                	push   $0x78
  800bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd9:	ff d0                	call   *%eax
  800bdb:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800bde:	8b 45 14             	mov    0x14(%ebp),%eax
  800be1:	83 c0 04             	add    $0x4,%eax
  800be4:	89 45 14             	mov    %eax,0x14(%ebp)
  800be7:	8b 45 14             	mov    0x14(%ebp),%eax
  800bea:	83 e8 04             	sub    $0x4,%eax
  800bed:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bef:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bf2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800bf9:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c00:	eb 1f                	jmp    800c21 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c02:	83 ec 08             	sub    $0x8,%esp
  800c05:	ff 75 e8             	pushl  -0x18(%ebp)
  800c08:	8d 45 14             	lea    0x14(%ebp),%eax
  800c0b:	50                   	push   %eax
  800c0c:	e8 e7 fb ff ff       	call   8007f8 <getuint>
  800c11:	83 c4 10             	add    $0x10,%esp
  800c14:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c17:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800c1a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c21:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800c25:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c28:	83 ec 04             	sub    $0x4,%esp
  800c2b:	52                   	push   %edx
  800c2c:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c2f:	50                   	push   %eax
  800c30:	ff 75 f4             	pushl  -0xc(%ebp)
  800c33:	ff 75 f0             	pushl  -0x10(%ebp)
  800c36:	ff 75 0c             	pushl  0xc(%ebp)
  800c39:	ff 75 08             	pushl  0x8(%ebp)
  800c3c:	e8 00 fb ff ff       	call   800741 <printnum>
  800c41:	83 c4 20             	add    $0x20,%esp
			break;
  800c44:	eb 46                	jmp    800c8c <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c46:	83 ec 08             	sub    $0x8,%esp
  800c49:	ff 75 0c             	pushl  0xc(%ebp)
  800c4c:	53                   	push   %ebx
  800c4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c50:	ff d0                	call   *%eax
  800c52:	83 c4 10             	add    $0x10,%esp
			break;
  800c55:	eb 35                	jmp    800c8c <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800c57:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800c5e:	eb 2c                	jmp    800c8c <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800c60:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800c67:	eb 23                	jmp    800c8c <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c69:	83 ec 08             	sub    $0x8,%esp
  800c6c:	ff 75 0c             	pushl  0xc(%ebp)
  800c6f:	6a 25                	push   $0x25
  800c71:	8b 45 08             	mov    0x8(%ebp),%eax
  800c74:	ff d0                	call   *%eax
  800c76:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c79:	ff 4d 10             	decl   0x10(%ebp)
  800c7c:	eb 03                	jmp    800c81 <vprintfmt+0x3c3>
  800c7e:	ff 4d 10             	decl   0x10(%ebp)
  800c81:	8b 45 10             	mov    0x10(%ebp),%eax
  800c84:	48                   	dec    %eax
  800c85:	8a 00                	mov    (%eax),%al
  800c87:	3c 25                	cmp    $0x25,%al
  800c89:	75 f3                	jne    800c7e <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800c8b:	90                   	nop
		}
	}
  800c8c:	e9 35 fc ff ff       	jmp    8008c6 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800c91:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800c92:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c95:	5b                   	pop    %ebx
  800c96:	5e                   	pop    %esi
  800c97:	5d                   	pop    %ebp
  800c98:	c3                   	ret    

00800c99 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c99:	55                   	push   %ebp
  800c9a:	89 e5                	mov    %esp,%ebp
  800c9c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c9f:	8d 45 10             	lea    0x10(%ebp),%eax
  800ca2:	83 c0 04             	add    $0x4,%eax
  800ca5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800ca8:	8b 45 10             	mov    0x10(%ebp),%eax
  800cab:	ff 75 f4             	pushl  -0xc(%ebp)
  800cae:	50                   	push   %eax
  800caf:	ff 75 0c             	pushl  0xc(%ebp)
  800cb2:	ff 75 08             	pushl  0x8(%ebp)
  800cb5:	e8 04 fc ff ff       	call   8008be <vprintfmt>
  800cba:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800cbd:	90                   	nop
  800cbe:	c9                   	leave  
  800cbf:	c3                   	ret    

00800cc0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800cc0:	55                   	push   %ebp
  800cc1:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800cc3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc6:	8b 40 08             	mov    0x8(%eax),%eax
  800cc9:	8d 50 01             	lea    0x1(%eax),%edx
  800ccc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ccf:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800cd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd5:	8b 10                	mov    (%eax),%edx
  800cd7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cda:	8b 40 04             	mov    0x4(%eax),%eax
  800cdd:	39 c2                	cmp    %eax,%edx
  800cdf:	73 12                	jae    800cf3 <sprintputch+0x33>
		*b->buf++ = ch;
  800ce1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce4:	8b 00                	mov    (%eax),%eax
  800ce6:	8d 48 01             	lea    0x1(%eax),%ecx
  800ce9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cec:	89 0a                	mov    %ecx,(%edx)
  800cee:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf1:	88 10                	mov    %dl,(%eax)
}
  800cf3:	90                   	nop
  800cf4:	5d                   	pop    %ebp
  800cf5:	c3                   	ret    

00800cf6 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800cf6:	55                   	push   %ebp
  800cf7:	89 e5                	mov    %esp,%ebp
  800cf9:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cff:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d02:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d05:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d08:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0b:	01 d0                	add    %edx,%eax
  800d0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d10:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d17:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d1b:	74 06                	je     800d23 <vsnprintf+0x2d>
  800d1d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d21:	7f 07                	jg     800d2a <vsnprintf+0x34>
		return -E_INVAL;
  800d23:	b8 03 00 00 00       	mov    $0x3,%eax
  800d28:	eb 20                	jmp    800d4a <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d2a:	ff 75 14             	pushl  0x14(%ebp)
  800d2d:	ff 75 10             	pushl  0x10(%ebp)
  800d30:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d33:	50                   	push   %eax
  800d34:	68 c0 0c 80 00       	push   $0x800cc0
  800d39:	e8 80 fb ff ff       	call   8008be <vprintfmt>
  800d3e:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800d41:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d44:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d47:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800d4a:	c9                   	leave  
  800d4b:	c3                   	ret    

00800d4c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d4c:	55                   	push   %ebp
  800d4d:	89 e5                	mov    %esp,%ebp
  800d4f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d52:	8d 45 10             	lea    0x10(%ebp),%eax
  800d55:	83 c0 04             	add    $0x4,%eax
  800d58:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800d5b:	8b 45 10             	mov    0x10(%ebp),%eax
  800d5e:	ff 75 f4             	pushl  -0xc(%ebp)
  800d61:	50                   	push   %eax
  800d62:	ff 75 0c             	pushl  0xc(%ebp)
  800d65:	ff 75 08             	pushl  0x8(%ebp)
  800d68:	e8 89 ff ff ff       	call   800cf6 <vsnprintf>
  800d6d:	83 c4 10             	add    $0x10,%esp
  800d70:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800d73:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d76:	c9                   	leave  
  800d77:	c3                   	ret    

00800d78 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800d78:	55                   	push   %ebp
  800d79:	89 e5                	mov    %esp,%ebp
  800d7b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800d7e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d85:	eb 06                	jmp    800d8d <strlen+0x15>
		n++;
  800d87:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d8a:	ff 45 08             	incl   0x8(%ebp)
  800d8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d90:	8a 00                	mov    (%eax),%al
  800d92:	84 c0                	test   %al,%al
  800d94:	75 f1                	jne    800d87 <strlen+0xf>
		n++;
	return n;
  800d96:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d99:	c9                   	leave  
  800d9a:	c3                   	ret    

00800d9b <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d9b:	55                   	push   %ebp
  800d9c:	89 e5                	mov    %esp,%ebp
  800d9e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800da1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800da8:	eb 09                	jmp    800db3 <strnlen+0x18>
		n++;
  800daa:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800dad:	ff 45 08             	incl   0x8(%ebp)
  800db0:	ff 4d 0c             	decl   0xc(%ebp)
  800db3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800db7:	74 09                	je     800dc2 <strnlen+0x27>
  800db9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbc:	8a 00                	mov    (%eax),%al
  800dbe:	84 c0                	test   %al,%al
  800dc0:	75 e8                	jne    800daa <strnlen+0xf>
		n++;
	return n;
  800dc2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800dc5:	c9                   	leave  
  800dc6:	c3                   	ret    

00800dc7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800dc7:	55                   	push   %ebp
  800dc8:	89 e5                	mov    %esp,%ebp
  800dca:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800dd3:	90                   	nop
  800dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd7:	8d 50 01             	lea    0x1(%eax),%edx
  800dda:	89 55 08             	mov    %edx,0x8(%ebp)
  800ddd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800de0:	8d 4a 01             	lea    0x1(%edx),%ecx
  800de3:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800de6:	8a 12                	mov    (%edx),%dl
  800de8:	88 10                	mov    %dl,(%eax)
  800dea:	8a 00                	mov    (%eax),%al
  800dec:	84 c0                	test   %al,%al
  800dee:	75 e4                	jne    800dd4 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800df0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800df3:	c9                   	leave  
  800df4:	c3                   	ret    

00800df5 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800df5:	55                   	push   %ebp
  800df6:	89 e5                	mov    %esp,%ebp
  800df8:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfe:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e01:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e08:	eb 1f                	jmp    800e29 <strncpy+0x34>
		*dst++ = *src;
  800e0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0d:	8d 50 01             	lea    0x1(%eax),%edx
  800e10:	89 55 08             	mov    %edx,0x8(%ebp)
  800e13:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e16:	8a 12                	mov    (%edx),%dl
  800e18:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1d:	8a 00                	mov    (%eax),%al
  800e1f:	84 c0                	test   %al,%al
  800e21:	74 03                	je     800e26 <strncpy+0x31>
			src++;
  800e23:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e26:	ff 45 fc             	incl   -0x4(%ebp)
  800e29:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e2c:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e2f:	72 d9                	jb     800e0a <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800e31:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e34:	c9                   	leave  
  800e35:	c3                   	ret    

00800e36 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800e36:	55                   	push   %ebp
  800e37:	89 e5                	mov    %esp,%ebp
  800e39:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800e3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800e42:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e46:	74 30                	je     800e78 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800e48:	eb 16                	jmp    800e60 <strlcpy+0x2a>
			*dst++ = *src++;
  800e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4d:	8d 50 01             	lea    0x1(%eax),%edx
  800e50:	89 55 08             	mov    %edx,0x8(%ebp)
  800e53:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e56:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e59:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e5c:	8a 12                	mov    (%edx),%dl
  800e5e:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e60:	ff 4d 10             	decl   0x10(%ebp)
  800e63:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e67:	74 09                	je     800e72 <strlcpy+0x3c>
  800e69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6c:	8a 00                	mov    (%eax),%al
  800e6e:	84 c0                	test   %al,%al
  800e70:	75 d8                	jne    800e4a <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800e72:	8b 45 08             	mov    0x8(%ebp),%eax
  800e75:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e78:	8b 55 08             	mov    0x8(%ebp),%edx
  800e7b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e7e:	29 c2                	sub    %eax,%edx
  800e80:	89 d0                	mov    %edx,%eax
}
  800e82:	c9                   	leave  
  800e83:	c3                   	ret    

00800e84 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e84:	55                   	push   %ebp
  800e85:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800e87:	eb 06                	jmp    800e8f <strcmp+0xb>
		p++, q++;
  800e89:	ff 45 08             	incl   0x8(%ebp)
  800e8c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e92:	8a 00                	mov    (%eax),%al
  800e94:	84 c0                	test   %al,%al
  800e96:	74 0e                	je     800ea6 <strcmp+0x22>
  800e98:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9b:	8a 10                	mov    (%eax),%dl
  800e9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea0:	8a 00                	mov    (%eax),%al
  800ea2:	38 c2                	cmp    %al,%dl
  800ea4:	74 e3                	je     800e89 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ea6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea9:	8a 00                	mov    (%eax),%al
  800eab:	0f b6 d0             	movzbl %al,%edx
  800eae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb1:	8a 00                	mov    (%eax),%al
  800eb3:	0f b6 c0             	movzbl %al,%eax
  800eb6:	29 c2                	sub    %eax,%edx
  800eb8:	89 d0                	mov    %edx,%eax
}
  800eba:	5d                   	pop    %ebp
  800ebb:	c3                   	ret    

00800ebc <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800ebc:	55                   	push   %ebp
  800ebd:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800ebf:	eb 09                	jmp    800eca <strncmp+0xe>
		n--, p++, q++;
  800ec1:	ff 4d 10             	decl   0x10(%ebp)
  800ec4:	ff 45 08             	incl   0x8(%ebp)
  800ec7:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800eca:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ece:	74 17                	je     800ee7 <strncmp+0x2b>
  800ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed3:	8a 00                	mov    (%eax),%al
  800ed5:	84 c0                	test   %al,%al
  800ed7:	74 0e                	je     800ee7 <strncmp+0x2b>
  800ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  800edc:	8a 10                	mov    (%eax),%dl
  800ede:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee1:	8a 00                	mov    (%eax),%al
  800ee3:	38 c2                	cmp    %al,%dl
  800ee5:	74 da                	je     800ec1 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800ee7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eeb:	75 07                	jne    800ef4 <strncmp+0x38>
		return 0;
  800eed:	b8 00 00 00 00       	mov    $0x0,%eax
  800ef2:	eb 14                	jmp    800f08 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ef4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef7:	8a 00                	mov    (%eax),%al
  800ef9:	0f b6 d0             	movzbl %al,%edx
  800efc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eff:	8a 00                	mov    (%eax),%al
  800f01:	0f b6 c0             	movzbl %al,%eax
  800f04:	29 c2                	sub    %eax,%edx
  800f06:	89 d0                	mov    %edx,%eax
}
  800f08:	5d                   	pop    %ebp
  800f09:	c3                   	ret    

00800f0a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f0a:	55                   	push   %ebp
  800f0b:	89 e5                	mov    %esp,%ebp
  800f0d:	83 ec 04             	sub    $0x4,%esp
  800f10:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f13:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f16:	eb 12                	jmp    800f2a <strchr+0x20>
		if (*s == c)
  800f18:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1b:	8a 00                	mov    (%eax),%al
  800f1d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f20:	75 05                	jne    800f27 <strchr+0x1d>
			return (char *) s;
  800f22:	8b 45 08             	mov    0x8(%ebp),%eax
  800f25:	eb 11                	jmp    800f38 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800f27:	ff 45 08             	incl   0x8(%ebp)
  800f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2d:	8a 00                	mov    (%eax),%al
  800f2f:	84 c0                	test   %al,%al
  800f31:	75 e5                	jne    800f18 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800f33:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f38:	c9                   	leave  
  800f39:	c3                   	ret    

00800f3a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f3a:	55                   	push   %ebp
  800f3b:	89 e5                	mov    %esp,%ebp
  800f3d:	83 ec 04             	sub    $0x4,%esp
  800f40:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f43:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f46:	eb 0d                	jmp    800f55 <strfind+0x1b>
		if (*s == c)
  800f48:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4b:	8a 00                	mov    (%eax),%al
  800f4d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f50:	74 0e                	je     800f60 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f52:	ff 45 08             	incl   0x8(%ebp)
  800f55:	8b 45 08             	mov    0x8(%ebp),%eax
  800f58:	8a 00                	mov    (%eax),%al
  800f5a:	84 c0                	test   %al,%al
  800f5c:	75 ea                	jne    800f48 <strfind+0xe>
  800f5e:	eb 01                	jmp    800f61 <strfind+0x27>
		if (*s == c)
			break;
  800f60:	90                   	nop
	return (char *) s;
  800f61:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f64:	c9                   	leave  
  800f65:	c3                   	ret    

00800f66 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800f66:	55                   	push   %ebp
  800f67:	89 e5                	mov    %esp,%ebp
  800f69:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800f72:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f76:	76 63                	jbe    800fdb <memset+0x75>
		uint64 data_block = c;
  800f78:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f7b:	99                   	cltd   
  800f7c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f7f:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800f82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f85:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f88:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800f8c:	c1 e0 08             	shl    $0x8,%eax
  800f8f:	09 45 f0             	or     %eax,-0x10(%ebp)
  800f92:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800f95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f98:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f9b:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800f9f:	c1 e0 10             	shl    $0x10,%eax
  800fa2:	09 45 f0             	or     %eax,-0x10(%ebp)
  800fa5:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800fa8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fae:	89 c2                	mov    %eax,%edx
  800fb0:	b8 00 00 00 00       	mov    $0x0,%eax
  800fb5:	09 45 f0             	or     %eax,-0x10(%ebp)
  800fb8:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800fbb:	eb 18                	jmp    800fd5 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800fbd:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800fc0:	8d 41 08             	lea    0x8(%ecx),%eax
  800fc3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800fc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fc9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fcc:	89 01                	mov    %eax,(%ecx)
  800fce:	89 51 04             	mov    %edx,0x4(%ecx)
  800fd1:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800fd5:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800fd9:	77 e2                	ja     800fbd <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800fdb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fdf:	74 23                	je     801004 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800fe1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fe4:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800fe7:	eb 0e                	jmp    800ff7 <memset+0x91>
			*p8++ = (uint8)c;
  800fe9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fec:	8d 50 01             	lea    0x1(%eax),%edx
  800fef:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ff2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ff5:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800ff7:	8b 45 10             	mov    0x10(%ebp),%eax
  800ffa:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ffd:	89 55 10             	mov    %edx,0x10(%ebp)
  801000:	85 c0                	test   %eax,%eax
  801002:	75 e5                	jne    800fe9 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801004:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801007:	c9                   	leave  
  801008:	c3                   	ret    

00801009 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801009:	55                   	push   %ebp
  80100a:	89 e5                	mov    %esp,%ebp
  80100c:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  80100f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801012:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801015:	8b 45 08             	mov    0x8(%ebp),%eax
  801018:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  80101b:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80101f:	76 24                	jbe    801045 <memcpy+0x3c>
		while(n >= 8){
  801021:	eb 1c                	jmp    80103f <memcpy+0x36>
			*d64 = *s64;
  801023:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801026:	8b 50 04             	mov    0x4(%eax),%edx
  801029:	8b 00                	mov    (%eax),%eax
  80102b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80102e:	89 01                	mov    %eax,(%ecx)
  801030:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801033:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801037:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  80103b:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  80103f:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801043:	77 de                	ja     801023 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801045:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801049:	74 31                	je     80107c <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  80104b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80104e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801051:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801054:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801057:	eb 16                	jmp    80106f <memcpy+0x66>
			*d8++ = *s8++;
  801059:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80105c:	8d 50 01             	lea    0x1(%eax),%edx
  80105f:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801062:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801065:	8d 4a 01             	lea    0x1(%edx),%ecx
  801068:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80106b:	8a 12                	mov    (%edx),%dl
  80106d:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  80106f:	8b 45 10             	mov    0x10(%ebp),%eax
  801072:	8d 50 ff             	lea    -0x1(%eax),%edx
  801075:	89 55 10             	mov    %edx,0x10(%ebp)
  801078:	85 c0                	test   %eax,%eax
  80107a:	75 dd                	jne    801059 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  80107c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80107f:	c9                   	leave  
  801080:	c3                   	ret    

00801081 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801081:	55                   	push   %ebp
  801082:	89 e5                	mov    %esp,%ebp
  801084:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801087:	8b 45 0c             	mov    0xc(%ebp),%eax
  80108a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80108d:	8b 45 08             	mov    0x8(%ebp),%eax
  801090:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801093:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801096:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801099:	73 50                	jae    8010eb <memmove+0x6a>
  80109b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80109e:	8b 45 10             	mov    0x10(%ebp),%eax
  8010a1:	01 d0                	add    %edx,%eax
  8010a3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010a6:	76 43                	jbe    8010eb <memmove+0x6a>
		s += n;
  8010a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ab:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8010ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b1:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8010b4:	eb 10                	jmp    8010c6 <memmove+0x45>
			*--d = *--s;
  8010b6:	ff 4d f8             	decl   -0x8(%ebp)
  8010b9:	ff 4d fc             	decl   -0x4(%ebp)
  8010bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010bf:	8a 10                	mov    (%eax),%dl
  8010c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010c4:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8010c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8010c9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010cc:	89 55 10             	mov    %edx,0x10(%ebp)
  8010cf:	85 c0                	test   %eax,%eax
  8010d1:	75 e3                	jne    8010b6 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8010d3:	eb 23                	jmp    8010f8 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8010d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010d8:	8d 50 01             	lea    0x1(%eax),%edx
  8010db:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010de:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010e1:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010e4:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010e7:	8a 12                	mov    (%edx),%dl
  8010e9:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8010eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ee:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010f1:	89 55 10             	mov    %edx,0x10(%ebp)
  8010f4:	85 c0                	test   %eax,%eax
  8010f6:	75 dd                	jne    8010d5 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8010f8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010fb:	c9                   	leave  
  8010fc:	c3                   	ret    

008010fd <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8010fd:	55                   	push   %ebp
  8010fe:	89 e5                	mov    %esp,%ebp
  801100:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801103:	8b 45 08             	mov    0x8(%ebp),%eax
  801106:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801109:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110c:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80110f:	eb 2a                	jmp    80113b <memcmp+0x3e>
		if (*s1 != *s2)
  801111:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801114:	8a 10                	mov    (%eax),%dl
  801116:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801119:	8a 00                	mov    (%eax),%al
  80111b:	38 c2                	cmp    %al,%dl
  80111d:	74 16                	je     801135 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80111f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801122:	8a 00                	mov    (%eax),%al
  801124:	0f b6 d0             	movzbl %al,%edx
  801127:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80112a:	8a 00                	mov    (%eax),%al
  80112c:	0f b6 c0             	movzbl %al,%eax
  80112f:	29 c2                	sub    %eax,%edx
  801131:	89 d0                	mov    %edx,%eax
  801133:	eb 18                	jmp    80114d <memcmp+0x50>
		s1++, s2++;
  801135:	ff 45 fc             	incl   -0x4(%ebp)
  801138:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80113b:	8b 45 10             	mov    0x10(%ebp),%eax
  80113e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801141:	89 55 10             	mov    %edx,0x10(%ebp)
  801144:	85 c0                	test   %eax,%eax
  801146:	75 c9                	jne    801111 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801148:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80114d:	c9                   	leave  
  80114e:	c3                   	ret    

0080114f <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80114f:	55                   	push   %ebp
  801150:	89 e5                	mov    %esp,%ebp
  801152:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801155:	8b 55 08             	mov    0x8(%ebp),%edx
  801158:	8b 45 10             	mov    0x10(%ebp),%eax
  80115b:	01 d0                	add    %edx,%eax
  80115d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801160:	eb 15                	jmp    801177 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801162:	8b 45 08             	mov    0x8(%ebp),%eax
  801165:	8a 00                	mov    (%eax),%al
  801167:	0f b6 d0             	movzbl %al,%edx
  80116a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116d:	0f b6 c0             	movzbl %al,%eax
  801170:	39 c2                	cmp    %eax,%edx
  801172:	74 0d                	je     801181 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801174:	ff 45 08             	incl   0x8(%ebp)
  801177:	8b 45 08             	mov    0x8(%ebp),%eax
  80117a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80117d:	72 e3                	jb     801162 <memfind+0x13>
  80117f:	eb 01                	jmp    801182 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801181:	90                   	nop
	return (void *) s;
  801182:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801185:	c9                   	leave  
  801186:	c3                   	ret    

00801187 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801187:	55                   	push   %ebp
  801188:	89 e5                	mov    %esp,%ebp
  80118a:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80118d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801194:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80119b:	eb 03                	jmp    8011a0 <strtol+0x19>
		s++;
  80119d:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a3:	8a 00                	mov    (%eax),%al
  8011a5:	3c 20                	cmp    $0x20,%al
  8011a7:	74 f4                	je     80119d <strtol+0x16>
  8011a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ac:	8a 00                	mov    (%eax),%al
  8011ae:	3c 09                	cmp    $0x9,%al
  8011b0:	74 eb                	je     80119d <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8011b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b5:	8a 00                	mov    (%eax),%al
  8011b7:	3c 2b                	cmp    $0x2b,%al
  8011b9:	75 05                	jne    8011c0 <strtol+0x39>
		s++;
  8011bb:	ff 45 08             	incl   0x8(%ebp)
  8011be:	eb 13                	jmp    8011d3 <strtol+0x4c>
	else if (*s == '-')
  8011c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c3:	8a 00                	mov    (%eax),%al
  8011c5:	3c 2d                	cmp    $0x2d,%al
  8011c7:	75 0a                	jne    8011d3 <strtol+0x4c>
		s++, neg = 1;
  8011c9:	ff 45 08             	incl   0x8(%ebp)
  8011cc:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8011d3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011d7:	74 06                	je     8011df <strtol+0x58>
  8011d9:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8011dd:	75 20                	jne    8011ff <strtol+0x78>
  8011df:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e2:	8a 00                	mov    (%eax),%al
  8011e4:	3c 30                	cmp    $0x30,%al
  8011e6:	75 17                	jne    8011ff <strtol+0x78>
  8011e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011eb:	40                   	inc    %eax
  8011ec:	8a 00                	mov    (%eax),%al
  8011ee:	3c 78                	cmp    $0x78,%al
  8011f0:	75 0d                	jne    8011ff <strtol+0x78>
		s += 2, base = 16;
  8011f2:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8011f6:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8011fd:	eb 28                	jmp    801227 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8011ff:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801203:	75 15                	jne    80121a <strtol+0x93>
  801205:	8b 45 08             	mov    0x8(%ebp),%eax
  801208:	8a 00                	mov    (%eax),%al
  80120a:	3c 30                	cmp    $0x30,%al
  80120c:	75 0c                	jne    80121a <strtol+0x93>
		s++, base = 8;
  80120e:	ff 45 08             	incl   0x8(%ebp)
  801211:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801218:	eb 0d                	jmp    801227 <strtol+0xa0>
	else if (base == 0)
  80121a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80121e:	75 07                	jne    801227 <strtol+0xa0>
		base = 10;
  801220:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801227:	8b 45 08             	mov    0x8(%ebp),%eax
  80122a:	8a 00                	mov    (%eax),%al
  80122c:	3c 2f                	cmp    $0x2f,%al
  80122e:	7e 19                	jle    801249 <strtol+0xc2>
  801230:	8b 45 08             	mov    0x8(%ebp),%eax
  801233:	8a 00                	mov    (%eax),%al
  801235:	3c 39                	cmp    $0x39,%al
  801237:	7f 10                	jg     801249 <strtol+0xc2>
			dig = *s - '0';
  801239:	8b 45 08             	mov    0x8(%ebp),%eax
  80123c:	8a 00                	mov    (%eax),%al
  80123e:	0f be c0             	movsbl %al,%eax
  801241:	83 e8 30             	sub    $0x30,%eax
  801244:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801247:	eb 42                	jmp    80128b <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801249:	8b 45 08             	mov    0x8(%ebp),%eax
  80124c:	8a 00                	mov    (%eax),%al
  80124e:	3c 60                	cmp    $0x60,%al
  801250:	7e 19                	jle    80126b <strtol+0xe4>
  801252:	8b 45 08             	mov    0x8(%ebp),%eax
  801255:	8a 00                	mov    (%eax),%al
  801257:	3c 7a                	cmp    $0x7a,%al
  801259:	7f 10                	jg     80126b <strtol+0xe4>
			dig = *s - 'a' + 10;
  80125b:	8b 45 08             	mov    0x8(%ebp),%eax
  80125e:	8a 00                	mov    (%eax),%al
  801260:	0f be c0             	movsbl %al,%eax
  801263:	83 e8 57             	sub    $0x57,%eax
  801266:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801269:	eb 20                	jmp    80128b <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80126b:	8b 45 08             	mov    0x8(%ebp),%eax
  80126e:	8a 00                	mov    (%eax),%al
  801270:	3c 40                	cmp    $0x40,%al
  801272:	7e 39                	jle    8012ad <strtol+0x126>
  801274:	8b 45 08             	mov    0x8(%ebp),%eax
  801277:	8a 00                	mov    (%eax),%al
  801279:	3c 5a                	cmp    $0x5a,%al
  80127b:	7f 30                	jg     8012ad <strtol+0x126>
			dig = *s - 'A' + 10;
  80127d:	8b 45 08             	mov    0x8(%ebp),%eax
  801280:	8a 00                	mov    (%eax),%al
  801282:	0f be c0             	movsbl %al,%eax
  801285:	83 e8 37             	sub    $0x37,%eax
  801288:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80128b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80128e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801291:	7d 19                	jge    8012ac <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801293:	ff 45 08             	incl   0x8(%ebp)
  801296:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801299:	0f af 45 10          	imul   0x10(%ebp),%eax
  80129d:	89 c2                	mov    %eax,%edx
  80129f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012a2:	01 d0                	add    %edx,%eax
  8012a4:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8012a7:	e9 7b ff ff ff       	jmp    801227 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8012ac:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8012ad:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012b1:	74 08                	je     8012bb <strtol+0x134>
		*endptr = (char *) s;
  8012b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8012b9:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8012bb:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8012bf:	74 07                	je     8012c8 <strtol+0x141>
  8012c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012c4:	f7 d8                	neg    %eax
  8012c6:	eb 03                	jmp    8012cb <strtol+0x144>
  8012c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012cb:	c9                   	leave  
  8012cc:	c3                   	ret    

008012cd <ltostr>:

void
ltostr(long value, char *str)
{
  8012cd:	55                   	push   %ebp
  8012ce:	89 e5                	mov    %esp,%ebp
  8012d0:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8012d3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8012da:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8012e1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012e5:	79 13                	jns    8012fa <ltostr+0x2d>
	{
		neg = 1;
  8012e7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8012ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f1:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8012f4:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8012f7:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8012fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fd:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801302:	99                   	cltd   
  801303:	f7 f9                	idiv   %ecx
  801305:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801308:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80130b:	8d 50 01             	lea    0x1(%eax),%edx
  80130e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801311:	89 c2                	mov    %eax,%edx
  801313:	8b 45 0c             	mov    0xc(%ebp),%eax
  801316:	01 d0                	add    %edx,%eax
  801318:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80131b:	83 c2 30             	add    $0x30,%edx
  80131e:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801320:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801323:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801328:	f7 e9                	imul   %ecx
  80132a:	c1 fa 02             	sar    $0x2,%edx
  80132d:	89 c8                	mov    %ecx,%eax
  80132f:	c1 f8 1f             	sar    $0x1f,%eax
  801332:	29 c2                	sub    %eax,%edx
  801334:	89 d0                	mov    %edx,%eax
  801336:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801339:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80133d:	75 bb                	jne    8012fa <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80133f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801346:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801349:	48                   	dec    %eax
  80134a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80134d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801351:	74 3d                	je     801390 <ltostr+0xc3>
		start = 1 ;
  801353:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80135a:	eb 34                	jmp    801390 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80135c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80135f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801362:	01 d0                	add    %edx,%eax
  801364:	8a 00                	mov    (%eax),%al
  801366:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801369:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80136c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136f:	01 c2                	add    %eax,%edx
  801371:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801374:	8b 45 0c             	mov    0xc(%ebp),%eax
  801377:	01 c8                	add    %ecx,%eax
  801379:	8a 00                	mov    (%eax),%al
  80137b:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80137d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801380:	8b 45 0c             	mov    0xc(%ebp),%eax
  801383:	01 c2                	add    %eax,%edx
  801385:	8a 45 eb             	mov    -0x15(%ebp),%al
  801388:	88 02                	mov    %al,(%edx)
		start++ ;
  80138a:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80138d:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801390:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801393:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801396:	7c c4                	jl     80135c <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801398:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80139b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80139e:	01 d0                	add    %edx,%eax
  8013a0:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8013a3:	90                   	nop
  8013a4:	c9                   	leave  
  8013a5:	c3                   	ret    

008013a6 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8013a6:	55                   	push   %ebp
  8013a7:	89 e5                	mov    %esp,%ebp
  8013a9:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8013ac:	ff 75 08             	pushl  0x8(%ebp)
  8013af:	e8 c4 f9 ff ff       	call   800d78 <strlen>
  8013b4:	83 c4 04             	add    $0x4,%esp
  8013b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8013ba:	ff 75 0c             	pushl  0xc(%ebp)
  8013bd:	e8 b6 f9 ff ff       	call   800d78 <strlen>
  8013c2:	83 c4 04             	add    $0x4,%esp
  8013c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8013c8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8013cf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013d6:	eb 17                	jmp    8013ef <strcconcat+0x49>
		final[s] = str1[s] ;
  8013d8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013db:	8b 45 10             	mov    0x10(%ebp),%eax
  8013de:	01 c2                	add    %eax,%edx
  8013e0:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e6:	01 c8                	add    %ecx,%eax
  8013e8:	8a 00                	mov    (%eax),%al
  8013ea:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8013ec:	ff 45 fc             	incl   -0x4(%ebp)
  8013ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013f2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8013f5:	7c e1                	jl     8013d8 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8013f7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8013fe:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801405:	eb 1f                	jmp    801426 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801407:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80140a:	8d 50 01             	lea    0x1(%eax),%edx
  80140d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801410:	89 c2                	mov    %eax,%edx
  801412:	8b 45 10             	mov    0x10(%ebp),%eax
  801415:	01 c2                	add    %eax,%edx
  801417:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80141a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80141d:	01 c8                	add    %ecx,%eax
  80141f:	8a 00                	mov    (%eax),%al
  801421:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801423:	ff 45 f8             	incl   -0x8(%ebp)
  801426:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801429:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80142c:	7c d9                	jl     801407 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80142e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801431:	8b 45 10             	mov    0x10(%ebp),%eax
  801434:	01 d0                	add    %edx,%eax
  801436:	c6 00 00             	movb   $0x0,(%eax)
}
  801439:	90                   	nop
  80143a:	c9                   	leave  
  80143b:	c3                   	ret    

0080143c <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80143c:	55                   	push   %ebp
  80143d:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80143f:	8b 45 14             	mov    0x14(%ebp),%eax
  801442:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801448:	8b 45 14             	mov    0x14(%ebp),%eax
  80144b:	8b 00                	mov    (%eax),%eax
  80144d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801454:	8b 45 10             	mov    0x10(%ebp),%eax
  801457:	01 d0                	add    %edx,%eax
  801459:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80145f:	eb 0c                	jmp    80146d <strsplit+0x31>
			*string++ = 0;
  801461:	8b 45 08             	mov    0x8(%ebp),%eax
  801464:	8d 50 01             	lea    0x1(%eax),%edx
  801467:	89 55 08             	mov    %edx,0x8(%ebp)
  80146a:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80146d:	8b 45 08             	mov    0x8(%ebp),%eax
  801470:	8a 00                	mov    (%eax),%al
  801472:	84 c0                	test   %al,%al
  801474:	74 18                	je     80148e <strsplit+0x52>
  801476:	8b 45 08             	mov    0x8(%ebp),%eax
  801479:	8a 00                	mov    (%eax),%al
  80147b:	0f be c0             	movsbl %al,%eax
  80147e:	50                   	push   %eax
  80147f:	ff 75 0c             	pushl  0xc(%ebp)
  801482:	e8 83 fa ff ff       	call   800f0a <strchr>
  801487:	83 c4 08             	add    $0x8,%esp
  80148a:	85 c0                	test   %eax,%eax
  80148c:	75 d3                	jne    801461 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80148e:	8b 45 08             	mov    0x8(%ebp),%eax
  801491:	8a 00                	mov    (%eax),%al
  801493:	84 c0                	test   %al,%al
  801495:	74 5a                	je     8014f1 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801497:	8b 45 14             	mov    0x14(%ebp),%eax
  80149a:	8b 00                	mov    (%eax),%eax
  80149c:	83 f8 0f             	cmp    $0xf,%eax
  80149f:	75 07                	jne    8014a8 <strsplit+0x6c>
		{
			return 0;
  8014a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8014a6:	eb 66                	jmp    80150e <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8014a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8014ab:	8b 00                	mov    (%eax),%eax
  8014ad:	8d 48 01             	lea    0x1(%eax),%ecx
  8014b0:	8b 55 14             	mov    0x14(%ebp),%edx
  8014b3:	89 0a                	mov    %ecx,(%edx)
  8014b5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8014bf:	01 c2                	add    %eax,%edx
  8014c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c4:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014c6:	eb 03                	jmp    8014cb <strsplit+0x8f>
			string++;
  8014c8:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ce:	8a 00                	mov    (%eax),%al
  8014d0:	84 c0                	test   %al,%al
  8014d2:	74 8b                	je     80145f <strsplit+0x23>
  8014d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d7:	8a 00                	mov    (%eax),%al
  8014d9:	0f be c0             	movsbl %al,%eax
  8014dc:	50                   	push   %eax
  8014dd:	ff 75 0c             	pushl  0xc(%ebp)
  8014e0:	e8 25 fa ff ff       	call   800f0a <strchr>
  8014e5:	83 c4 08             	add    $0x8,%esp
  8014e8:	85 c0                	test   %eax,%eax
  8014ea:	74 dc                	je     8014c8 <strsplit+0x8c>
			string++;
	}
  8014ec:	e9 6e ff ff ff       	jmp    80145f <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8014f1:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8014f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8014f5:	8b 00                	mov    (%eax),%eax
  8014f7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014fe:	8b 45 10             	mov    0x10(%ebp),%eax
  801501:	01 d0                	add    %edx,%eax
  801503:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801509:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80150e:	c9                   	leave  
  80150f:	c3                   	ret    

00801510 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801510:	55                   	push   %ebp
  801511:	89 e5                	mov    %esp,%ebp
  801513:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801516:	8b 45 08             	mov    0x8(%ebp),%eax
  801519:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  80151c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801523:	eb 4a                	jmp    80156f <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801525:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801528:	8b 45 08             	mov    0x8(%ebp),%eax
  80152b:	01 c2                	add    %eax,%edx
  80152d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801530:	8b 45 0c             	mov    0xc(%ebp),%eax
  801533:	01 c8                	add    %ecx,%eax
  801535:	8a 00                	mov    (%eax),%al
  801537:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801539:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80153c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80153f:	01 d0                	add    %edx,%eax
  801541:	8a 00                	mov    (%eax),%al
  801543:	3c 40                	cmp    $0x40,%al
  801545:	7e 25                	jle    80156c <str2lower+0x5c>
  801547:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80154a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80154d:	01 d0                	add    %edx,%eax
  80154f:	8a 00                	mov    (%eax),%al
  801551:	3c 5a                	cmp    $0x5a,%al
  801553:	7f 17                	jg     80156c <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801555:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801558:	8b 45 08             	mov    0x8(%ebp),%eax
  80155b:	01 d0                	add    %edx,%eax
  80155d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801560:	8b 55 08             	mov    0x8(%ebp),%edx
  801563:	01 ca                	add    %ecx,%edx
  801565:	8a 12                	mov    (%edx),%dl
  801567:	83 c2 20             	add    $0x20,%edx
  80156a:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80156c:	ff 45 fc             	incl   -0x4(%ebp)
  80156f:	ff 75 0c             	pushl  0xc(%ebp)
  801572:	e8 01 f8 ff ff       	call   800d78 <strlen>
  801577:	83 c4 04             	add    $0x4,%esp
  80157a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80157d:	7f a6                	jg     801525 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  80157f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801582:	c9                   	leave  
  801583:	c3                   	ret    

00801584 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801584:	55                   	push   %ebp
  801585:	89 e5                	mov    %esp,%ebp
  801587:	57                   	push   %edi
  801588:	56                   	push   %esi
  801589:	53                   	push   %ebx
  80158a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80158d:	8b 45 08             	mov    0x8(%ebp),%eax
  801590:	8b 55 0c             	mov    0xc(%ebp),%edx
  801593:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801596:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801599:	8b 7d 18             	mov    0x18(%ebp),%edi
  80159c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80159f:	cd 30                	int    $0x30
  8015a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8015a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8015a7:	83 c4 10             	add    $0x10,%esp
  8015aa:	5b                   	pop    %ebx
  8015ab:	5e                   	pop    %esi
  8015ac:	5f                   	pop    %edi
  8015ad:	5d                   	pop    %ebp
  8015ae:	c3                   	ret    

008015af <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8015af:	55                   	push   %ebp
  8015b0:	89 e5                	mov    %esp,%ebp
  8015b2:	83 ec 04             	sub    $0x4,%esp
  8015b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8015b8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8015bb:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8015be:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8015c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c5:	6a 00                	push   $0x0
  8015c7:	51                   	push   %ecx
  8015c8:	52                   	push   %edx
  8015c9:	ff 75 0c             	pushl  0xc(%ebp)
  8015cc:	50                   	push   %eax
  8015cd:	6a 00                	push   $0x0
  8015cf:	e8 b0 ff ff ff       	call   801584 <syscall>
  8015d4:	83 c4 18             	add    $0x18,%esp
}
  8015d7:	90                   	nop
  8015d8:	c9                   	leave  
  8015d9:	c3                   	ret    

008015da <sys_cgetc>:

int
sys_cgetc(void)
{
  8015da:	55                   	push   %ebp
  8015db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8015dd:	6a 00                	push   $0x0
  8015df:	6a 00                	push   $0x0
  8015e1:	6a 00                	push   $0x0
  8015e3:	6a 00                	push   $0x0
  8015e5:	6a 00                	push   $0x0
  8015e7:	6a 02                	push   $0x2
  8015e9:	e8 96 ff ff ff       	call   801584 <syscall>
  8015ee:	83 c4 18             	add    $0x18,%esp
}
  8015f1:	c9                   	leave  
  8015f2:	c3                   	ret    

008015f3 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8015f3:	55                   	push   %ebp
  8015f4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8015f6:	6a 00                	push   $0x0
  8015f8:	6a 00                	push   $0x0
  8015fa:	6a 00                	push   $0x0
  8015fc:	6a 00                	push   $0x0
  8015fe:	6a 00                	push   $0x0
  801600:	6a 03                	push   $0x3
  801602:	e8 7d ff ff ff       	call   801584 <syscall>
  801607:	83 c4 18             	add    $0x18,%esp
}
  80160a:	90                   	nop
  80160b:	c9                   	leave  
  80160c:	c3                   	ret    

0080160d <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80160d:	55                   	push   %ebp
  80160e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801610:	6a 00                	push   $0x0
  801612:	6a 00                	push   $0x0
  801614:	6a 00                	push   $0x0
  801616:	6a 00                	push   $0x0
  801618:	6a 00                	push   $0x0
  80161a:	6a 04                	push   $0x4
  80161c:	e8 63 ff ff ff       	call   801584 <syscall>
  801621:	83 c4 18             	add    $0x18,%esp
}
  801624:	90                   	nop
  801625:	c9                   	leave  
  801626:	c3                   	ret    

00801627 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801627:	55                   	push   %ebp
  801628:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80162a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80162d:	8b 45 08             	mov    0x8(%ebp),%eax
  801630:	6a 00                	push   $0x0
  801632:	6a 00                	push   $0x0
  801634:	6a 00                	push   $0x0
  801636:	52                   	push   %edx
  801637:	50                   	push   %eax
  801638:	6a 08                	push   $0x8
  80163a:	e8 45 ff ff ff       	call   801584 <syscall>
  80163f:	83 c4 18             	add    $0x18,%esp
}
  801642:	c9                   	leave  
  801643:	c3                   	ret    

00801644 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801644:	55                   	push   %ebp
  801645:	89 e5                	mov    %esp,%ebp
  801647:	56                   	push   %esi
  801648:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801649:	8b 75 18             	mov    0x18(%ebp),%esi
  80164c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80164f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801652:	8b 55 0c             	mov    0xc(%ebp),%edx
  801655:	8b 45 08             	mov    0x8(%ebp),%eax
  801658:	56                   	push   %esi
  801659:	53                   	push   %ebx
  80165a:	51                   	push   %ecx
  80165b:	52                   	push   %edx
  80165c:	50                   	push   %eax
  80165d:	6a 09                	push   $0x9
  80165f:	e8 20 ff ff ff       	call   801584 <syscall>
  801664:	83 c4 18             	add    $0x18,%esp
}
  801667:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80166a:	5b                   	pop    %ebx
  80166b:	5e                   	pop    %esi
  80166c:	5d                   	pop    %ebp
  80166d:	c3                   	ret    

0080166e <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  80166e:	55                   	push   %ebp
  80166f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801671:	6a 00                	push   $0x0
  801673:	6a 00                	push   $0x0
  801675:	6a 00                	push   $0x0
  801677:	6a 00                	push   $0x0
  801679:	ff 75 08             	pushl  0x8(%ebp)
  80167c:	6a 0a                	push   $0xa
  80167e:	e8 01 ff ff ff       	call   801584 <syscall>
  801683:	83 c4 18             	add    $0x18,%esp
}
  801686:	c9                   	leave  
  801687:	c3                   	ret    

00801688 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801688:	55                   	push   %ebp
  801689:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80168b:	6a 00                	push   $0x0
  80168d:	6a 00                	push   $0x0
  80168f:	6a 00                	push   $0x0
  801691:	ff 75 0c             	pushl  0xc(%ebp)
  801694:	ff 75 08             	pushl  0x8(%ebp)
  801697:	6a 0b                	push   $0xb
  801699:	e8 e6 fe ff ff       	call   801584 <syscall>
  80169e:	83 c4 18             	add    $0x18,%esp
}
  8016a1:	c9                   	leave  
  8016a2:	c3                   	ret    

008016a3 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8016a3:	55                   	push   %ebp
  8016a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8016a6:	6a 00                	push   $0x0
  8016a8:	6a 00                	push   $0x0
  8016aa:	6a 00                	push   $0x0
  8016ac:	6a 00                	push   $0x0
  8016ae:	6a 00                	push   $0x0
  8016b0:	6a 0c                	push   $0xc
  8016b2:	e8 cd fe ff ff       	call   801584 <syscall>
  8016b7:	83 c4 18             	add    $0x18,%esp
}
  8016ba:	c9                   	leave  
  8016bb:	c3                   	ret    

008016bc <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8016bc:	55                   	push   %ebp
  8016bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8016bf:	6a 00                	push   $0x0
  8016c1:	6a 00                	push   $0x0
  8016c3:	6a 00                	push   $0x0
  8016c5:	6a 00                	push   $0x0
  8016c7:	6a 00                	push   $0x0
  8016c9:	6a 0d                	push   $0xd
  8016cb:	e8 b4 fe ff ff       	call   801584 <syscall>
  8016d0:	83 c4 18             	add    $0x18,%esp
}
  8016d3:	c9                   	leave  
  8016d4:	c3                   	ret    

008016d5 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8016d5:	55                   	push   %ebp
  8016d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8016d8:	6a 00                	push   $0x0
  8016da:	6a 00                	push   $0x0
  8016dc:	6a 00                	push   $0x0
  8016de:	6a 00                	push   $0x0
  8016e0:	6a 00                	push   $0x0
  8016e2:	6a 0e                	push   $0xe
  8016e4:	e8 9b fe ff ff       	call   801584 <syscall>
  8016e9:	83 c4 18             	add    $0x18,%esp
}
  8016ec:	c9                   	leave  
  8016ed:	c3                   	ret    

008016ee <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8016ee:	55                   	push   %ebp
  8016ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8016f1:	6a 00                	push   $0x0
  8016f3:	6a 00                	push   $0x0
  8016f5:	6a 00                	push   $0x0
  8016f7:	6a 00                	push   $0x0
  8016f9:	6a 00                	push   $0x0
  8016fb:	6a 0f                	push   $0xf
  8016fd:	e8 82 fe ff ff       	call   801584 <syscall>
  801702:	83 c4 18             	add    $0x18,%esp
}
  801705:	c9                   	leave  
  801706:	c3                   	ret    

00801707 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801707:	55                   	push   %ebp
  801708:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80170a:	6a 00                	push   $0x0
  80170c:	6a 00                	push   $0x0
  80170e:	6a 00                	push   $0x0
  801710:	6a 00                	push   $0x0
  801712:	ff 75 08             	pushl  0x8(%ebp)
  801715:	6a 10                	push   $0x10
  801717:	e8 68 fe ff ff       	call   801584 <syscall>
  80171c:	83 c4 18             	add    $0x18,%esp
}
  80171f:	c9                   	leave  
  801720:	c3                   	ret    

00801721 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801721:	55                   	push   %ebp
  801722:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801724:	6a 00                	push   $0x0
  801726:	6a 00                	push   $0x0
  801728:	6a 00                	push   $0x0
  80172a:	6a 00                	push   $0x0
  80172c:	6a 00                	push   $0x0
  80172e:	6a 11                	push   $0x11
  801730:	e8 4f fe ff ff       	call   801584 <syscall>
  801735:	83 c4 18             	add    $0x18,%esp
}
  801738:	90                   	nop
  801739:	c9                   	leave  
  80173a:	c3                   	ret    

0080173b <sys_cputc>:

void
sys_cputc(const char c)
{
  80173b:	55                   	push   %ebp
  80173c:	89 e5                	mov    %esp,%ebp
  80173e:	83 ec 04             	sub    $0x4,%esp
  801741:	8b 45 08             	mov    0x8(%ebp),%eax
  801744:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801747:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80174b:	6a 00                	push   $0x0
  80174d:	6a 00                	push   $0x0
  80174f:	6a 00                	push   $0x0
  801751:	6a 00                	push   $0x0
  801753:	50                   	push   %eax
  801754:	6a 01                	push   $0x1
  801756:	e8 29 fe ff ff       	call   801584 <syscall>
  80175b:	83 c4 18             	add    $0x18,%esp
}
  80175e:	90                   	nop
  80175f:	c9                   	leave  
  801760:	c3                   	ret    

00801761 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801761:	55                   	push   %ebp
  801762:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801764:	6a 00                	push   $0x0
  801766:	6a 00                	push   $0x0
  801768:	6a 00                	push   $0x0
  80176a:	6a 00                	push   $0x0
  80176c:	6a 00                	push   $0x0
  80176e:	6a 14                	push   $0x14
  801770:	e8 0f fe ff ff       	call   801584 <syscall>
  801775:	83 c4 18             	add    $0x18,%esp
}
  801778:	90                   	nop
  801779:	c9                   	leave  
  80177a:	c3                   	ret    

0080177b <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80177b:	55                   	push   %ebp
  80177c:	89 e5                	mov    %esp,%ebp
  80177e:	83 ec 04             	sub    $0x4,%esp
  801781:	8b 45 10             	mov    0x10(%ebp),%eax
  801784:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801787:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80178a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80178e:	8b 45 08             	mov    0x8(%ebp),%eax
  801791:	6a 00                	push   $0x0
  801793:	51                   	push   %ecx
  801794:	52                   	push   %edx
  801795:	ff 75 0c             	pushl  0xc(%ebp)
  801798:	50                   	push   %eax
  801799:	6a 15                	push   $0x15
  80179b:	e8 e4 fd ff ff       	call   801584 <syscall>
  8017a0:	83 c4 18             	add    $0x18,%esp
}
  8017a3:	c9                   	leave  
  8017a4:	c3                   	ret    

008017a5 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8017a5:	55                   	push   %ebp
  8017a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8017a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ae:	6a 00                	push   $0x0
  8017b0:	6a 00                	push   $0x0
  8017b2:	6a 00                	push   $0x0
  8017b4:	52                   	push   %edx
  8017b5:	50                   	push   %eax
  8017b6:	6a 16                	push   $0x16
  8017b8:	e8 c7 fd ff ff       	call   801584 <syscall>
  8017bd:	83 c4 18             	add    $0x18,%esp
}
  8017c0:	c9                   	leave  
  8017c1:	c3                   	ret    

008017c2 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8017c2:	55                   	push   %ebp
  8017c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8017c5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ce:	6a 00                	push   $0x0
  8017d0:	6a 00                	push   $0x0
  8017d2:	51                   	push   %ecx
  8017d3:	52                   	push   %edx
  8017d4:	50                   	push   %eax
  8017d5:	6a 17                	push   $0x17
  8017d7:	e8 a8 fd ff ff       	call   801584 <syscall>
  8017dc:	83 c4 18             	add    $0x18,%esp
}
  8017df:	c9                   	leave  
  8017e0:	c3                   	ret    

008017e1 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8017e1:	55                   	push   %ebp
  8017e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8017e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ea:	6a 00                	push   $0x0
  8017ec:	6a 00                	push   $0x0
  8017ee:	6a 00                	push   $0x0
  8017f0:	52                   	push   %edx
  8017f1:	50                   	push   %eax
  8017f2:	6a 18                	push   $0x18
  8017f4:	e8 8b fd ff ff       	call   801584 <syscall>
  8017f9:	83 c4 18             	add    $0x18,%esp
}
  8017fc:	c9                   	leave  
  8017fd:	c3                   	ret    

008017fe <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8017fe:	55                   	push   %ebp
  8017ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801801:	8b 45 08             	mov    0x8(%ebp),%eax
  801804:	6a 00                	push   $0x0
  801806:	ff 75 14             	pushl  0x14(%ebp)
  801809:	ff 75 10             	pushl  0x10(%ebp)
  80180c:	ff 75 0c             	pushl  0xc(%ebp)
  80180f:	50                   	push   %eax
  801810:	6a 19                	push   $0x19
  801812:	e8 6d fd ff ff       	call   801584 <syscall>
  801817:	83 c4 18             	add    $0x18,%esp
}
  80181a:	c9                   	leave  
  80181b:	c3                   	ret    

0080181c <sys_run_env>:

void sys_run_env(int32 envId)
{
  80181c:	55                   	push   %ebp
  80181d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80181f:	8b 45 08             	mov    0x8(%ebp),%eax
  801822:	6a 00                	push   $0x0
  801824:	6a 00                	push   $0x0
  801826:	6a 00                	push   $0x0
  801828:	6a 00                	push   $0x0
  80182a:	50                   	push   %eax
  80182b:	6a 1a                	push   $0x1a
  80182d:	e8 52 fd ff ff       	call   801584 <syscall>
  801832:	83 c4 18             	add    $0x18,%esp
}
  801835:	90                   	nop
  801836:	c9                   	leave  
  801837:	c3                   	ret    

00801838 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801838:	55                   	push   %ebp
  801839:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80183b:	8b 45 08             	mov    0x8(%ebp),%eax
  80183e:	6a 00                	push   $0x0
  801840:	6a 00                	push   $0x0
  801842:	6a 00                	push   $0x0
  801844:	6a 00                	push   $0x0
  801846:	50                   	push   %eax
  801847:	6a 1b                	push   $0x1b
  801849:	e8 36 fd ff ff       	call   801584 <syscall>
  80184e:	83 c4 18             	add    $0x18,%esp
}
  801851:	c9                   	leave  
  801852:	c3                   	ret    

00801853 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801853:	55                   	push   %ebp
  801854:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801856:	6a 00                	push   $0x0
  801858:	6a 00                	push   $0x0
  80185a:	6a 00                	push   $0x0
  80185c:	6a 00                	push   $0x0
  80185e:	6a 00                	push   $0x0
  801860:	6a 05                	push   $0x5
  801862:	e8 1d fd ff ff       	call   801584 <syscall>
  801867:	83 c4 18             	add    $0x18,%esp
}
  80186a:	c9                   	leave  
  80186b:	c3                   	ret    

0080186c <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80186c:	55                   	push   %ebp
  80186d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80186f:	6a 00                	push   $0x0
  801871:	6a 00                	push   $0x0
  801873:	6a 00                	push   $0x0
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	6a 06                	push   $0x6
  80187b:	e8 04 fd ff ff       	call   801584 <syscall>
  801880:	83 c4 18             	add    $0x18,%esp
}
  801883:	c9                   	leave  
  801884:	c3                   	ret    

00801885 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801885:	55                   	push   %ebp
  801886:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801888:	6a 00                	push   $0x0
  80188a:	6a 00                	push   $0x0
  80188c:	6a 00                	push   $0x0
  80188e:	6a 00                	push   $0x0
  801890:	6a 00                	push   $0x0
  801892:	6a 07                	push   $0x7
  801894:	e8 eb fc ff ff       	call   801584 <syscall>
  801899:	83 c4 18             	add    $0x18,%esp
}
  80189c:	c9                   	leave  
  80189d:	c3                   	ret    

0080189e <sys_exit_env>:


void sys_exit_env(void)
{
  80189e:	55                   	push   %ebp
  80189f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8018a1:	6a 00                	push   $0x0
  8018a3:	6a 00                	push   $0x0
  8018a5:	6a 00                	push   $0x0
  8018a7:	6a 00                	push   $0x0
  8018a9:	6a 00                	push   $0x0
  8018ab:	6a 1c                	push   $0x1c
  8018ad:	e8 d2 fc ff ff       	call   801584 <syscall>
  8018b2:	83 c4 18             	add    $0x18,%esp
}
  8018b5:	90                   	nop
  8018b6:	c9                   	leave  
  8018b7:	c3                   	ret    

008018b8 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8018b8:	55                   	push   %ebp
  8018b9:	89 e5                	mov    %esp,%ebp
  8018bb:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8018be:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8018c1:	8d 50 04             	lea    0x4(%eax),%edx
  8018c4:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8018c7:	6a 00                	push   $0x0
  8018c9:	6a 00                	push   $0x0
  8018cb:	6a 00                	push   $0x0
  8018cd:	52                   	push   %edx
  8018ce:	50                   	push   %eax
  8018cf:	6a 1d                	push   $0x1d
  8018d1:	e8 ae fc ff ff       	call   801584 <syscall>
  8018d6:	83 c4 18             	add    $0x18,%esp
	return result;
  8018d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018df:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018e2:	89 01                	mov    %eax,(%ecx)
  8018e4:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8018e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ea:	c9                   	leave  
  8018eb:	c2 04 00             	ret    $0x4

008018ee <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8018ee:	55                   	push   %ebp
  8018ef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8018f1:	6a 00                	push   $0x0
  8018f3:	6a 00                	push   $0x0
  8018f5:	ff 75 10             	pushl  0x10(%ebp)
  8018f8:	ff 75 0c             	pushl  0xc(%ebp)
  8018fb:	ff 75 08             	pushl  0x8(%ebp)
  8018fe:	6a 13                	push   $0x13
  801900:	e8 7f fc ff ff       	call   801584 <syscall>
  801905:	83 c4 18             	add    $0x18,%esp
	return ;
  801908:	90                   	nop
}
  801909:	c9                   	leave  
  80190a:	c3                   	ret    

0080190b <sys_rcr2>:
uint32 sys_rcr2()
{
  80190b:	55                   	push   %ebp
  80190c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80190e:	6a 00                	push   $0x0
  801910:	6a 00                	push   $0x0
  801912:	6a 00                	push   $0x0
  801914:	6a 00                	push   $0x0
  801916:	6a 00                	push   $0x0
  801918:	6a 1e                	push   $0x1e
  80191a:	e8 65 fc ff ff       	call   801584 <syscall>
  80191f:	83 c4 18             	add    $0x18,%esp
}
  801922:	c9                   	leave  
  801923:	c3                   	ret    

00801924 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801924:	55                   	push   %ebp
  801925:	89 e5                	mov    %esp,%ebp
  801927:	83 ec 04             	sub    $0x4,%esp
  80192a:	8b 45 08             	mov    0x8(%ebp),%eax
  80192d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801930:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801934:	6a 00                	push   $0x0
  801936:	6a 00                	push   $0x0
  801938:	6a 00                	push   $0x0
  80193a:	6a 00                	push   $0x0
  80193c:	50                   	push   %eax
  80193d:	6a 1f                	push   $0x1f
  80193f:	e8 40 fc ff ff       	call   801584 <syscall>
  801944:	83 c4 18             	add    $0x18,%esp
	return ;
  801947:	90                   	nop
}
  801948:	c9                   	leave  
  801949:	c3                   	ret    

0080194a <rsttst>:
void rsttst()
{
  80194a:	55                   	push   %ebp
  80194b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80194d:	6a 00                	push   $0x0
  80194f:	6a 00                	push   $0x0
  801951:	6a 00                	push   $0x0
  801953:	6a 00                	push   $0x0
  801955:	6a 00                	push   $0x0
  801957:	6a 21                	push   $0x21
  801959:	e8 26 fc ff ff       	call   801584 <syscall>
  80195e:	83 c4 18             	add    $0x18,%esp
	return ;
  801961:	90                   	nop
}
  801962:	c9                   	leave  
  801963:	c3                   	ret    

00801964 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801964:	55                   	push   %ebp
  801965:	89 e5                	mov    %esp,%ebp
  801967:	83 ec 04             	sub    $0x4,%esp
  80196a:	8b 45 14             	mov    0x14(%ebp),%eax
  80196d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801970:	8b 55 18             	mov    0x18(%ebp),%edx
  801973:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801977:	52                   	push   %edx
  801978:	50                   	push   %eax
  801979:	ff 75 10             	pushl  0x10(%ebp)
  80197c:	ff 75 0c             	pushl  0xc(%ebp)
  80197f:	ff 75 08             	pushl  0x8(%ebp)
  801982:	6a 20                	push   $0x20
  801984:	e8 fb fb ff ff       	call   801584 <syscall>
  801989:	83 c4 18             	add    $0x18,%esp
	return ;
  80198c:	90                   	nop
}
  80198d:	c9                   	leave  
  80198e:	c3                   	ret    

0080198f <chktst>:
void chktst(uint32 n)
{
  80198f:	55                   	push   %ebp
  801990:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801992:	6a 00                	push   $0x0
  801994:	6a 00                	push   $0x0
  801996:	6a 00                	push   $0x0
  801998:	6a 00                	push   $0x0
  80199a:	ff 75 08             	pushl  0x8(%ebp)
  80199d:	6a 22                	push   $0x22
  80199f:	e8 e0 fb ff ff       	call   801584 <syscall>
  8019a4:	83 c4 18             	add    $0x18,%esp
	return ;
  8019a7:	90                   	nop
}
  8019a8:	c9                   	leave  
  8019a9:	c3                   	ret    

008019aa <inctst>:

void inctst()
{
  8019aa:	55                   	push   %ebp
  8019ab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8019ad:	6a 00                	push   $0x0
  8019af:	6a 00                	push   $0x0
  8019b1:	6a 00                	push   $0x0
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 00                	push   $0x0
  8019b7:	6a 23                	push   $0x23
  8019b9:	e8 c6 fb ff ff       	call   801584 <syscall>
  8019be:	83 c4 18             	add    $0x18,%esp
	return ;
  8019c1:	90                   	nop
}
  8019c2:	c9                   	leave  
  8019c3:	c3                   	ret    

008019c4 <gettst>:
uint32 gettst()
{
  8019c4:	55                   	push   %ebp
  8019c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8019c7:	6a 00                	push   $0x0
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 24                	push   $0x24
  8019d3:	e8 ac fb ff ff       	call   801584 <syscall>
  8019d8:	83 c4 18             	add    $0x18,%esp
}
  8019db:	c9                   	leave  
  8019dc:	c3                   	ret    

008019dd <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8019dd:	55                   	push   %ebp
  8019de:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 25                	push   $0x25
  8019ec:	e8 93 fb ff ff       	call   801584 <syscall>
  8019f1:	83 c4 18             	add    $0x18,%esp
  8019f4:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  8019f9:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  8019fe:	c9                   	leave  
  8019ff:	c3                   	ret    

00801a00 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801a00:	55                   	push   %ebp
  801a01:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801a03:	8b 45 08             	mov    0x8(%ebp),%eax
  801a06:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801a0b:	6a 00                	push   $0x0
  801a0d:	6a 00                	push   $0x0
  801a0f:	6a 00                	push   $0x0
  801a11:	6a 00                	push   $0x0
  801a13:	ff 75 08             	pushl  0x8(%ebp)
  801a16:	6a 26                	push   $0x26
  801a18:	e8 67 fb ff ff       	call   801584 <syscall>
  801a1d:	83 c4 18             	add    $0x18,%esp
	return ;
  801a20:	90                   	nop
}
  801a21:	c9                   	leave  
  801a22:	c3                   	ret    

00801a23 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801a23:	55                   	push   %ebp
  801a24:	89 e5                	mov    %esp,%ebp
  801a26:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801a27:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a2a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a2d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a30:	8b 45 08             	mov    0x8(%ebp),%eax
  801a33:	6a 00                	push   $0x0
  801a35:	53                   	push   %ebx
  801a36:	51                   	push   %ecx
  801a37:	52                   	push   %edx
  801a38:	50                   	push   %eax
  801a39:	6a 27                	push   $0x27
  801a3b:	e8 44 fb ff ff       	call   801584 <syscall>
  801a40:	83 c4 18             	add    $0x18,%esp
}
  801a43:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a46:	c9                   	leave  
  801a47:	c3                   	ret    

00801a48 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801a48:	55                   	push   %ebp
  801a49:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801a4b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a51:	6a 00                	push   $0x0
  801a53:	6a 00                	push   $0x0
  801a55:	6a 00                	push   $0x0
  801a57:	52                   	push   %edx
  801a58:	50                   	push   %eax
  801a59:	6a 28                	push   $0x28
  801a5b:	e8 24 fb ff ff       	call   801584 <syscall>
  801a60:	83 c4 18             	add    $0x18,%esp
}
  801a63:	c9                   	leave  
  801a64:	c3                   	ret    

00801a65 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801a65:	55                   	push   %ebp
  801a66:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801a68:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a6b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a71:	6a 00                	push   $0x0
  801a73:	51                   	push   %ecx
  801a74:	ff 75 10             	pushl  0x10(%ebp)
  801a77:	52                   	push   %edx
  801a78:	50                   	push   %eax
  801a79:	6a 29                	push   $0x29
  801a7b:	e8 04 fb ff ff       	call   801584 <syscall>
  801a80:	83 c4 18             	add    $0x18,%esp
}
  801a83:	c9                   	leave  
  801a84:	c3                   	ret    

00801a85 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a85:	55                   	push   %ebp
  801a86:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a88:	6a 00                	push   $0x0
  801a8a:	6a 00                	push   $0x0
  801a8c:	ff 75 10             	pushl  0x10(%ebp)
  801a8f:	ff 75 0c             	pushl  0xc(%ebp)
  801a92:	ff 75 08             	pushl  0x8(%ebp)
  801a95:	6a 12                	push   $0x12
  801a97:	e8 e8 fa ff ff       	call   801584 <syscall>
  801a9c:	83 c4 18             	add    $0x18,%esp
	return ;
  801a9f:	90                   	nop
}
  801aa0:	c9                   	leave  
  801aa1:	c3                   	ret    

00801aa2 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801aa2:	55                   	push   %ebp
  801aa3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801aa5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  801aab:	6a 00                	push   $0x0
  801aad:	6a 00                	push   $0x0
  801aaf:	6a 00                	push   $0x0
  801ab1:	52                   	push   %edx
  801ab2:	50                   	push   %eax
  801ab3:	6a 2a                	push   $0x2a
  801ab5:	e8 ca fa ff ff       	call   801584 <syscall>
  801aba:	83 c4 18             	add    $0x18,%esp
	return;
  801abd:	90                   	nop
}
  801abe:	c9                   	leave  
  801abf:	c3                   	ret    

00801ac0 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801ac0:	55                   	push   %ebp
  801ac1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 00                	push   $0x0
  801acd:	6a 2b                	push   $0x2b
  801acf:	e8 b0 fa ff ff       	call   801584 <syscall>
  801ad4:	83 c4 18             	add    $0x18,%esp
}
  801ad7:	c9                   	leave  
  801ad8:	c3                   	ret    

00801ad9 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801ad9:	55                   	push   %ebp
  801ada:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 00                	push   $0x0
  801ae2:	ff 75 0c             	pushl  0xc(%ebp)
  801ae5:	ff 75 08             	pushl  0x8(%ebp)
  801ae8:	6a 2d                	push   $0x2d
  801aea:	e8 95 fa ff ff       	call   801584 <syscall>
  801aef:	83 c4 18             	add    $0x18,%esp
	return;
  801af2:	90                   	nop
}
  801af3:	c9                   	leave  
  801af4:	c3                   	ret    

00801af5 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801af5:	55                   	push   %ebp
  801af6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801af8:	6a 00                	push   $0x0
  801afa:	6a 00                	push   $0x0
  801afc:	6a 00                	push   $0x0
  801afe:	ff 75 0c             	pushl  0xc(%ebp)
  801b01:	ff 75 08             	pushl  0x8(%ebp)
  801b04:	6a 2c                	push   $0x2c
  801b06:	e8 79 fa ff ff       	call   801584 <syscall>
  801b0b:	83 c4 18             	add    $0x18,%esp
	return ;
  801b0e:	90                   	nop
}
  801b0f:	c9                   	leave  
  801b10:	c3                   	ret    

00801b11 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801b11:	55                   	push   %ebp
  801b12:	89 e5                	mov    %esp,%ebp
  801b14:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801b17:	83 ec 04             	sub    $0x4,%esp
  801b1a:	68 28 25 80 00       	push   $0x802528
  801b1f:	68 25 01 00 00       	push   $0x125
  801b24:	68 5b 25 80 00       	push   $0x80255b
  801b29:	e8 a3 e8 ff ff       	call   8003d1 <_panic>

00801b2e <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  801b2e:	55                   	push   %ebp
  801b2f:	89 e5                	mov    %esp,%ebp
  801b31:	83 ec 08             	sub    $0x8,%esp
	panic("create_semaphore() is not implemented yet...!!");
  801b34:	83 ec 04             	sub    $0x4,%esp
  801b37:	68 6c 25 80 00       	push   $0x80256c
  801b3c:	6a 07                	push   $0x7
  801b3e:	68 9b 25 80 00       	push   $0x80259b
  801b43:	e8 89 e8 ff ff       	call   8003d1 <_panic>

00801b48 <get_semaphore>:
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b48:	55                   	push   %ebp
  801b49:	89 e5                	mov    %esp,%ebp
  801b4b:	83 ec 08             	sub    $0x8,%esp
	panic("get_semaphore() is not implemented yet...!!");
  801b4e:	83 ec 04             	sub    $0x4,%esp
  801b51:	68 ac 25 80 00       	push   $0x8025ac
  801b56:	6a 0b                	push   $0xb
  801b58:	68 9b 25 80 00       	push   $0x80259b
  801b5d:	e8 6f e8 ff ff       	call   8003d1 <_panic>

00801b62 <wait_semaphore>:
}

void wait_semaphore(struct semaphore sem)
{
  801b62:	55                   	push   %ebp
  801b63:	89 e5                	mov    %esp,%ebp
  801b65:	83 ec 08             	sub    $0x8,%esp
	panic("wait_semaphore() is not implemented yet...!!");
  801b68:	83 ec 04             	sub    $0x4,%esp
  801b6b:	68 d8 25 80 00       	push   $0x8025d8
  801b70:	6a 10                	push   $0x10
  801b72:	68 9b 25 80 00       	push   $0x80259b
  801b77:	e8 55 e8 ff ff       	call   8003d1 <_panic>

00801b7c <signal_semaphore>:
}

void signal_semaphore(struct semaphore sem)
{
  801b7c:	55                   	push   %ebp
  801b7d:	89 e5                	mov    %esp,%ebp
  801b7f:	83 ec 08             	sub    $0x8,%esp
	panic("signal_semaphore() is not implemented yet...!!");
  801b82:	83 ec 04             	sub    $0x4,%esp
  801b85:	68 08 26 80 00       	push   $0x802608
  801b8a:	6a 15                	push   $0x15
  801b8c:	68 9b 25 80 00       	push   $0x80259b
  801b91:	e8 3b e8 ff ff       	call   8003d1 <_panic>

00801b96 <semaphore_count>:
}

int semaphore_count(struct semaphore sem)
{
  801b96:	55                   	push   %ebp
  801b97:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  801b99:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9c:	8b 40 10             	mov    0x10(%eax),%eax
}
  801b9f:	5d                   	pop    %ebp
  801ba0:	c3                   	ret    
  801ba1:	66 90                	xchg   %ax,%ax
  801ba3:	90                   	nop

00801ba4 <__udivdi3>:
  801ba4:	55                   	push   %ebp
  801ba5:	57                   	push   %edi
  801ba6:	56                   	push   %esi
  801ba7:	53                   	push   %ebx
  801ba8:	83 ec 1c             	sub    $0x1c,%esp
  801bab:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801baf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801bb3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801bb7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801bbb:	89 ca                	mov    %ecx,%edx
  801bbd:	89 f8                	mov    %edi,%eax
  801bbf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801bc3:	85 f6                	test   %esi,%esi
  801bc5:	75 2d                	jne    801bf4 <__udivdi3+0x50>
  801bc7:	39 cf                	cmp    %ecx,%edi
  801bc9:	77 65                	ja     801c30 <__udivdi3+0x8c>
  801bcb:	89 fd                	mov    %edi,%ebp
  801bcd:	85 ff                	test   %edi,%edi
  801bcf:	75 0b                	jne    801bdc <__udivdi3+0x38>
  801bd1:	b8 01 00 00 00       	mov    $0x1,%eax
  801bd6:	31 d2                	xor    %edx,%edx
  801bd8:	f7 f7                	div    %edi
  801bda:	89 c5                	mov    %eax,%ebp
  801bdc:	31 d2                	xor    %edx,%edx
  801bde:	89 c8                	mov    %ecx,%eax
  801be0:	f7 f5                	div    %ebp
  801be2:	89 c1                	mov    %eax,%ecx
  801be4:	89 d8                	mov    %ebx,%eax
  801be6:	f7 f5                	div    %ebp
  801be8:	89 cf                	mov    %ecx,%edi
  801bea:	89 fa                	mov    %edi,%edx
  801bec:	83 c4 1c             	add    $0x1c,%esp
  801bef:	5b                   	pop    %ebx
  801bf0:	5e                   	pop    %esi
  801bf1:	5f                   	pop    %edi
  801bf2:	5d                   	pop    %ebp
  801bf3:	c3                   	ret    
  801bf4:	39 ce                	cmp    %ecx,%esi
  801bf6:	77 28                	ja     801c20 <__udivdi3+0x7c>
  801bf8:	0f bd fe             	bsr    %esi,%edi
  801bfb:	83 f7 1f             	xor    $0x1f,%edi
  801bfe:	75 40                	jne    801c40 <__udivdi3+0x9c>
  801c00:	39 ce                	cmp    %ecx,%esi
  801c02:	72 0a                	jb     801c0e <__udivdi3+0x6a>
  801c04:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801c08:	0f 87 9e 00 00 00    	ja     801cac <__udivdi3+0x108>
  801c0e:	b8 01 00 00 00       	mov    $0x1,%eax
  801c13:	89 fa                	mov    %edi,%edx
  801c15:	83 c4 1c             	add    $0x1c,%esp
  801c18:	5b                   	pop    %ebx
  801c19:	5e                   	pop    %esi
  801c1a:	5f                   	pop    %edi
  801c1b:	5d                   	pop    %ebp
  801c1c:	c3                   	ret    
  801c1d:	8d 76 00             	lea    0x0(%esi),%esi
  801c20:	31 ff                	xor    %edi,%edi
  801c22:	31 c0                	xor    %eax,%eax
  801c24:	89 fa                	mov    %edi,%edx
  801c26:	83 c4 1c             	add    $0x1c,%esp
  801c29:	5b                   	pop    %ebx
  801c2a:	5e                   	pop    %esi
  801c2b:	5f                   	pop    %edi
  801c2c:	5d                   	pop    %ebp
  801c2d:	c3                   	ret    
  801c2e:	66 90                	xchg   %ax,%ax
  801c30:	89 d8                	mov    %ebx,%eax
  801c32:	f7 f7                	div    %edi
  801c34:	31 ff                	xor    %edi,%edi
  801c36:	89 fa                	mov    %edi,%edx
  801c38:	83 c4 1c             	add    $0x1c,%esp
  801c3b:	5b                   	pop    %ebx
  801c3c:	5e                   	pop    %esi
  801c3d:	5f                   	pop    %edi
  801c3e:	5d                   	pop    %ebp
  801c3f:	c3                   	ret    
  801c40:	bd 20 00 00 00       	mov    $0x20,%ebp
  801c45:	89 eb                	mov    %ebp,%ebx
  801c47:	29 fb                	sub    %edi,%ebx
  801c49:	89 f9                	mov    %edi,%ecx
  801c4b:	d3 e6                	shl    %cl,%esi
  801c4d:	89 c5                	mov    %eax,%ebp
  801c4f:	88 d9                	mov    %bl,%cl
  801c51:	d3 ed                	shr    %cl,%ebp
  801c53:	89 e9                	mov    %ebp,%ecx
  801c55:	09 f1                	or     %esi,%ecx
  801c57:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801c5b:	89 f9                	mov    %edi,%ecx
  801c5d:	d3 e0                	shl    %cl,%eax
  801c5f:	89 c5                	mov    %eax,%ebp
  801c61:	89 d6                	mov    %edx,%esi
  801c63:	88 d9                	mov    %bl,%cl
  801c65:	d3 ee                	shr    %cl,%esi
  801c67:	89 f9                	mov    %edi,%ecx
  801c69:	d3 e2                	shl    %cl,%edx
  801c6b:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c6f:	88 d9                	mov    %bl,%cl
  801c71:	d3 e8                	shr    %cl,%eax
  801c73:	09 c2                	or     %eax,%edx
  801c75:	89 d0                	mov    %edx,%eax
  801c77:	89 f2                	mov    %esi,%edx
  801c79:	f7 74 24 0c          	divl   0xc(%esp)
  801c7d:	89 d6                	mov    %edx,%esi
  801c7f:	89 c3                	mov    %eax,%ebx
  801c81:	f7 e5                	mul    %ebp
  801c83:	39 d6                	cmp    %edx,%esi
  801c85:	72 19                	jb     801ca0 <__udivdi3+0xfc>
  801c87:	74 0b                	je     801c94 <__udivdi3+0xf0>
  801c89:	89 d8                	mov    %ebx,%eax
  801c8b:	31 ff                	xor    %edi,%edi
  801c8d:	e9 58 ff ff ff       	jmp    801bea <__udivdi3+0x46>
  801c92:	66 90                	xchg   %ax,%ax
  801c94:	8b 54 24 08          	mov    0x8(%esp),%edx
  801c98:	89 f9                	mov    %edi,%ecx
  801c9a:	d3 e2                	shl    %cl,%edx
  801c9c:	39 c2                	cmp    %eax,%edx
  801c9e:	73 e9                	jae    801c89 <__udivdi3+0xe5>
  801ca0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801ca3:	31 ff                	xor    %edi,%edi
  801ca5:	e9 40 ff ff ff       	jmp    801bea <__udivdi3+0x46>
  801caa:	66 90                	xchg   %ax,%ax
  801cac:	31 c0                	xor    %eax,%eax
  801cae:	e9 37 ff ff ff       	jmp    801bea <__udivdi3+0x46>
  801cb3:	90                   	nop

00801cb4 <__umoddi3>:
  801cb4:	55                   	push   %ebp
  801cb5:	57                   	push   %edi
  801cb6:	56                   	push   %esi
  801cb7:	53                   	push   %ebx
  801cb8:	83 ec 1c             	sub    $0x1c,%esp
  801cbb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801cbf:	8b 74 24 34          	mov    0x34(%esp),%esi
  801cc3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801cc7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801ccb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ccf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801cd3:	89 f3                	mov    %esi,%ebx
  801cd5:	89 fa                	mov    %edi,%edx
  801cd7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801cdb:	89 34 24             	mov    %esi,(%esp)
  801cde:	85 c0                	test   %eax,%eax
  801ce0:	75 1a                	jne    801cfc <__umoddi3+0x48>
  801ce2:	39 f7                	cmp    %esi,%edi
  801ce4:	0f 86 a2 00 00 00    	jbe    801d8c <__umoddi3+0xd8>
  801cea:	89 c8                	mov    %ecx,%eax
  801cec:	89 f2                	mov    %esi,%edx
  801cee:	f7 f7                	div    %edi
  801cf0:	89 d0                	mov    %edx,%eax
  801cf2:	31 d2                	xor    %edx,%edx
  801cf4:	83 c4 1c             	add    $0x1c,%esp
  801cf7:	5b                   	pop    %ebx
  801cf8:	5e                   	pop    %esi
  801cf9:	5f                   	pop    %edi
  801cfa:	5d                   	pop    %ebp
  801cfb:	c3                   	ret    
  801cfc:	39 f0                	cmp    %esi,%eax
  801cfe:	0f 87 ac 00 00 00    	ja     801db0 <__umoddi3+0xfc>
  801d04:	0f bd e8             	bsr    %eax,%ebp
  801d07:	83 f5 1f             	xor    $0x1f,%ebp
  801d0a:	0f 84 ac 00 00 00    	je     801dbc <__umoddi3+0x108>
  801d10:	bf 20 00 00 00       	mov    $0x20,%edi
  801d15:	29 ef                	sub    %ebp,%edi
  801d17:	89 fe                	mov    %edi,%esi
  801d19:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801d1d:	89 e9                	mov    %ebp,%ecx
  801d1f:	d3 e0                	shl    %cl,%eax
  801d21:	89 d7                	mov    %edx,%edi
  801d23:	89 f1                	mov    %esi,%ecx
  801d25:	d3 ef                	shr    %cl,%edi
  801d27:	09 c7                	or     %eax,%edi
  801d29:	89 e9                	mov    %ebp,%ecx
  801d2b:	d3 e2                	shl    %cl,%edx
  801d2d:	89 14 24             	mov    %edx,(%esp)
  801d30:	89 d8                	mov    %ebx,%eax
  801d32:	d3 e0                	shl    %cl,%eax
  801d34:	89 c2                	mov    %eax,%edx
  801d36:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d3a:	d3 e0                	shl    %cl,%eax
  801d3c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d40:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d44:	89 f1                	mov    %esi,%ecx
  801d46:	d3 e8                	shr    %cl,%eax
  801d48:	09 d0                	or     %edx,%eax
  801d4a:	d3 eb                	shr    %cl,%ebx
  801d4c:	89 da                	mov    %ebx,%edx
  801d4e:	f7 f7                	div    %edi
  801d50:	89 d3                	mov    %edx,%ebx
  801d52:	f7 24 24             	mull   (%esp)
  801d55:	89 c6                	mov    %eax,%esi
  801d57:	89 d1                	mov    %edx,%ecx
  801d59:	39 d3                	cmp    %edx,%ebx
  801d5b:	0f 82 87 00 00 00    	jb     801de8 <__umoddi3+0x134>
  801d61:	0f 84 91 00 00 00    	je     801df8 <__umoddi3+0x144>
  801d67:	8b 54 24 04          	mov    0x4(%esp),%edx
  801d6b:	29 f2                	sub    %esi,%edx
  801d6d:	19 cb                	sbb    %ecx,%ebx
  801d6f:	89 d8                	mov    %ebx,%eax
  801d71:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801d75:	d3 e0                	shl    %cl,%eax
  801d77:	89 e9                	mov    %ebp,%ecx
  801d79:	d3 ea                	shr    %cl,%edx
  801d7b:	09 d0                	or     %edx,%eax
  801d7d:	89 e9                	mov    %ebp,%ecx
  801d7f:	d3 eb                	shr    %cl,%ebx
  801d81:	89 da                	mov    %ebx,%edx
  801d83:	83 c4 1c             	add    $0x1c,%esp
  801d86:	5b                   	pop    %ebx
  801d87:	5e                   	pop    %esi
  801d88:	5f                   	pop    %edi
  801d89:	5d                   	pop    %ebp
  801d8a:	c3                   	ret    
  801d8b:	90                   	nop
  801d8c:	89 fd                	mov    %edi,%ebp
  801d8e:	85 ff                	test   %edi,%edi
  801d90:	75 0b                	jne    801d9d <__umoddi3+0xe9>
  801d92:	b8 01 00 00 00       	mov    $0x1,%eax
  801d97:	31 d2                	xor    %edx,%edx
  801d99:	f7 f7                	div    %edi
  801d9b:	89 c5                	mov    %eax,%ebp
  801d9d:	89 f0                	mov    %esi,%eax
  801d9f:	31 d2                	xor    %edx,%edx
  801da1:	f7 f5                	div    %ebp
  801da3:	89 c8                	mov    %ecx,%eax
  801da5:	f7 f5                	div    %ebp
  801da7:	89 d0                	mov    %edx,%eax
  801da9:	e9 44 ff ff ff       	jmp    801cf2 <__umoddi3+0x3e>
  801dae:	66 90                	xchg   %ax,%ax
  801db0:	89 c8                	mov    %ecx,%eax
  801db2:	89 f2                	mov    %esi,%edx
  801db4:	83 c4 1c             	add    $0x1c,%esp
  801db7:	5b                   	pop    %ebx
  801db8:	5e                   	pop    %esi
  801db9:	5f                   	pop    %edi
  801dba:	5d                   	pop    %ebp
  801dbb:	c3                   	ret    
  801dbc:	3b 04 24             	cmp    (%esp),%eax
  801dbf:	72 06                	jb     801dc7 <__umoddi3+0x113>
  801dc1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801dc5:	77 0f                	ja     801dd6 <__umoddi3+0x122>
  801dc7:	89 f2                	mov    %esi,%edx
  801dc9:	29 f9                	sub    %edi,%ecx
  801dcb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801dcf:	89 14 24             	mov    %edx,(%esp)
  801dd2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801dd6:	8b 44 24 04          	mov    0x4(%esp),%eax
  801dda:	8b 14 24             	mov    (%esp),%edx
  801ddd:	83 c4 1c             	add    $0x1c,%esp
  801de0:	5b                   	pop    %ebx
  801de1:	5e                   	pop    %esi
  801de2:	5f                   	pop    %edi
  801de3:	5d                   	pop    %ebp
  801de4:	c3                   	ret    
  801de5:	8d 76 00             	lea    0x0(%esi),%esi
  801de8:	2b 04 24             	sub    (%esp),%eax
  801deb:	19 fa                	sbb    %edi,%edx
  801ded:	89 d1                	mov    %edx,%ecx
  801def:	89 c6                	mov    %eax,%esi
  801df1:	e9 71 ff ff ff       	jmp    801d67 <__umoddi3+0xb3>
  801df6:	66 90                	xchg   %ax,%ax
  801df8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801dfc:	72 ea                	jb     801de8 <__umoddi3+0x134>
  801dfe:	89 d9                	mov    %ebx,%ecx
  801e00:	e9 62 ff ff ff       	jmp    801d67 <__umoddi3+0xb3>

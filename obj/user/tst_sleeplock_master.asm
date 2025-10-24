
obj/user/tst_sleeplock_master:     file format elf32-i386


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
  800031:	e8 9d 01 00 00       	call   8001d3 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Master program: create and run slaves, wait them to finish
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 38             	sub    $0x38,%esp
	int envID = sys_getenvid();
  80003e:	e8 ca 19 00 00       	call   801a0d <sys_getenvid>
  800043:	89 45 e8             	mov    %eax,-0x18(%ebp)
	char slavesCnt[10];
	readline("Enter the number of Slave Programs: ", slavesCnt);
  800046:	83 ec 08             	sub    $0x8,%esp
  800049:	8d 45 da             	lea    -0x26(%ebp),%eax
  80004c:	50                   	push   %eax
  80004d:	68 60 20 80 00       	push   $0x802060
  800052:	e8 d3 0c 00 00       	call   800d2a <readline>
  800057:	83 c4 10             	add    $0x10,%esp
	int numOfSlaves = strtol(slavesCnt, NULL, 10);
  80005a:	83 ec 04             	sub    $0x4,%esp
  80005d:	6a 0a                	push   $0xa
  80005f:	6a 00                	push   $0x0
  800061:	8d 45 da             	lea    -0x26(%ebp),%eax
  800064:	50                   	push   %eax
  800065:	e8 d7 12 00 00       	call   801341 <strtol>
  80006a:	83 c4 10             	add    $0x10,%esp
  80006d:	89 45 f4             	mov    %eax,-0xc(%ebp)

	rsttst();
  800070:	e8 8f 1a 00 00       	call   801b04 <rsttst>

	//Create and run slave programs that should sleep
	int id;
	for (int i = 0; i < numOfSlaves; ++i)
  800075:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80007c:	eb 68                	jmp    8000e6 <_main+0xae>
	{
		id = sys_create_env("tstSleepLockSlave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  80007e:	a1 20 30 80 00       	mov    0x803020,%eax
  800083:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  800089:	a1 20 30 80 00       	mov    0x803020,%eax
  80008e:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  800094:	89 c1                	mov    %eax,%ecx
  800096:	a1 20 30 80 00       	mov    0x803020,%eax
  80009b:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000a1:	52                   	push   %edx
  8000a2:	51                   	push   %ecx
  8000a3:	50                   	push   %eax
  8000a4:	68 85 20 80 00       	push   $0x802085
  8000a9:	e8 0a 19 00 00       	call   8019b8 <sys_create_env>
  8000ae:	83 c4 10             	add    $0x10,%esp
  8000b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (id== E_ENV_CREATION_ERROR)
  8000b4:	83 7d e4 ef          	cmpl   $0xffffffef,-0x1c(%ebp)
  8000b8:	75 1b                	jne    8000d5 <_main+0x9d>
		{
			cprintf("\n%~insufficient number of processes in the system! only %d slave processes are created\n", i);
  8000ba:	83 ec 08             	sub    $0x8,%esp
  8000bd:	ff 75 f0             	pushl  -0x10(%ebp)
  8000c0:	68 98 20 80 00       	push   $0x802098
  8000c5:	e8 87 05 00 00       	call   800651 <cprintf>
  8000ca:	83 c4 10             	add    $0x10,%esp
			numOfSlaves = i;
  8000cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
			break;
  8000d3:	eb 19                	jmp    8000ee <_main+0xb6>
		}
		sys_run_env(id);
  8000d5:	83 ec 0c             	sub    $0xc,%esp
  8000d8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000db:	e8 f6 18 00 00       	call   8019d6 <sys_run_env>
  8000e0:	83 c4 10             	add    $0x10,%esp

	rsttst();

	//Create and run slave programs that should sleep
	int id;
	for (int i = 0; i < numOfSlaves; ++i)
  8000e3:	ff 45 f0             	incl   -0x10(%ebp)
  8000e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000e9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8000ec:	7c 90                	jl     80007e <_main+0x46>
		}
		sys_run_env(id);
	}

	//Wait until all slaves, except one, are blocked
	int numOfBlockedProcesses = 0;
  8000ee:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
	sys_utilities("__GetLockQueueSize__", (uint32)(&numOfBlockedProcesses));
  8000f5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  8000f8:	83 ec 08             	sub    $0x8,%esp
  8000fb:	50                   	push   %eax
  8000fc:	68 f0 20 80 00       	push   $0x8020f0
  800101:	e8 56 1b 00 00       	call   801c5c <sys_utilities>
  800106:	83 c4 10             	add    $0x10,%esp
	int cnt = 0;
  800109:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	while (numOfBlockedProcesses != numOfSlaves-1)
  800110:	eb 4c                	jmp    80015e <_main+0x126>
	{
		env_sleep(5000);
  800112:	83 ec 0c             	sub    $0xc,%esp
  800115:	68 88 13 00 00       	push   $0x1388
  80011a:	e8 c9 1b 00 00       	call   801ce8 <env_sleep>
  80011f:	83 c4 10             	add    $0x10,%esp
		if (cnt == numOfSlaves)
  800122:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800125:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800128:	75 1d                	jne    800147 <_main+0x10f>
		{
			panic("%~test sleeplock failed! unexpected number of blocked slaves. Expected = %d, Current = %d", numOfSlaves-1, numOfBlockedProcesses);
  80012a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80012d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800130:	4a                   	dec    %edx
  800131:	83 ec 0c             	sub    $0xc,%esp
  800134:	50                   	push   %eax
  800135:	52                   	push   %edx
  800136:	68 08 21 80 00       	push   $0x802108
  80013b:	6a 26                	push   $0x26
  80013d:	68 62 21 80 00       	push   $0x802162
  800142:	e8 3c 02 00 00       	call   800383 <_panic>
		}
		sys_utilities("__GetLockQueueSize__", (uint32)(&numOfBlockedProcesses));
  800147:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  80014a:	83 ec 08             	sub    $0x8,%esp
  80014d:	50                   	push   %eax
  80014e:	68 f0 20 80 00       	push   $0x8020f0
  800153:	e8 04 1b 00 00       	call   801c5c <sys_utilities>
  800158:	83 c4 10             	add    $0x10,%esp
		cnt++ ;
  80015b:	ff 45 ec             	incl   -0x14(%ebp)

	//Wait until all slaves, except one, are blocked
	int numOfBlockedProcesses = 0;
	sys_utilities("__GetLockQueueSize__", (uint32)(&numOfBlockedProcesses));
	int cnt = 0;
	while (numOfBlockedProcesses != numOfSlaves-1)
  80015e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800161:	8d 50 ff             	lea    -0x1(%eax),%edx
  800164:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800167:	39 c2                	cmp    %eax,%edx
  800169:	75 a7                	jne    800112 <_main+0xda>
		sys_utilities("__GetLockQueueSize__", (uint32)(&numOfBlockedProcesses));
		cnt++ ;
	}

	//signal the slave inside the critical section to leave it
	inctst();
  80016b:	e8 f4 19 00 00       	call   801b64 <inctst>

	//Wait until all slave finished
	cnt = 0;
  800170:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	while (gettst() != numOfSlaves +1/*since master already increment it by 1*/)
  800177:	eb 3a                	jmp    8001b3 <_main+0x17b>
	{
		env_sleep(5000);
  800179:	83 ec 0c             	sub    $0xc,%esp
  80017c:	68 88 13 00 00       	push   $0x1388
  800181:	e8 62 1b 00 00       	call   801ce8 <env_sleep>
  800186:	83 c4 10             	add    $0x10,%esp
		if (cnt == numOfSlaves)
  800189:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80018c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80018f:	75 1f                	jne    8001b0 <_main+0x178>
		{
			panic("%~test sleeplock failed! not all slaves finished. Expected %d, Actual %d", numOfSlaves +1, gettst());
  800191:	e8 e8 19 00 00       	call   801b7e <gettst>
  800196:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800199:	42                   	inc    %edx
  80019a:	83 ec 0c             	sub    $0xc,%esp
  80019d:	50                   	push   %eax
  80019e:	52                   	push   %edx
  80019f:	68 80 21 80 00       	push   $0x802180
  8001a4:	6a 36                	push   $0x36
  8001a6:	68 62 21 80 00       	push   $0x802162
  8001ab:	e8 d3 01 00 00       	call   800383 <_panic>
		}
		cnt++ ;
  8001b0:	ff 45 ec             	incl   -0x14(%ebp)
	//signal the slave inside the critical section to leave it
	inctst();

	//Wait until all slave finished
	cnt = 0;
	while (gettst() != numOfSlaves +1/*since master already increment it by 1*/)
  8001b3:	e8 c6 19 00 00       	call   801b7e <gettst>
  8001b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001bb:	42                   	inc    %edx
  8001bc:	39 d0                	cmp    %edx,%eax
  8001be:	75 b9                	jne    800179 <_main+0x141>
			panic("%~test sleeplock failed! not all slaves finished. Expected %d, Actual %d", numOfSlaves +1, gettst());
		}
		cnt++ ;
	}

	cprintf("%~\n\nCongratulations!! Test of Sleep Lock completed successfully!!\n\n");
  8001c0:	83 ec 0c             	sub    $0xc,%esp
  8001c3:	68 cc 21 80 00       	push   $0x8021cc
  8001c8:	e8 84 04 00 00       	call   800651 <cprintf>
  8001cd:	83 c4 10             	add    $0x10,%esp
}
  8001d0:	90                   	nop
  8001d1:	c9                   	leave  
  8001d2:	c3                   	ret    

008001d3 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8001d3:	55                   	push   %ebp
  8001d4:	89 e5                	mov    %esp,%ebp
  8001d6:	57                   	push   %edi
  8001d7:	56                   	push   %esi
  8001d8:	53                   	push   %ebx
  8001d9:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8001dc:	e8 45 18 00 00       	call   801a26 <sys_getenvindex>
  8001e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8001e4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8001e7:	89 d0                	mov    %edx,%eax
  8001e9:	c1 e0 02             	shl    $0x2,%eax
  8001ec:	01 d0                	add    %edx,%eax
  8001ee:	c1 e0 03             	shl    $0x3,%eax
  8001f1:	01 d0                	add    %edx,%eax
  8001f3:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8001fa:	01 d0                	add    %edx,%eax
  8001fc:	c1 e0 02             	shl    $0x2,%eax
  8001ff:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800204:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800209:	a1 20 30 80 00       	mov    0x803020,%eax
  80020e:	8a 40 20             	mov    0x20(%eax),%al
  800211:	84 c0                	test   %al,%al
  800213:	74 0d                	je     800222 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800215:	a1 20 30 80 00       	mov    0x803020,%eax
  80021a:	83 c0 20             	add    $0x20,%eax
  80021d:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800222:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800226:	7e 0a                	jle    800232 <libmain+0x5f>
		binaryname = argv[0];
  800228:	8b 45 0c             	mov    0xc(%ebp),%eax
  80022b:	8b 00                	mov    (%eax),%eax
  80022d:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  800232:	83 ec 08             	sub    $0x8,%esp
  800235:	ff 75 0c             	pushl  0xc(%ebp)
  800238:	ff 75 08             	pushl  0x8(%ebp)
  80023b:	e8 f8 fd ff ff       	call   800038 <_main>
  800240:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800243:	a1 00 30 80 00       	mov    0x803000,%eax
  800248:	85 c0                	test   %eax,%eax
  80024a:	0f 84 01 01 00 00    	je     800351 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800250:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800256:	bb 08 23 80 00       	mov    $0x802308,%ebx
  80025b:	ba 0e 00 00 00       	mov    $0xe,%edx
  800260:	89 c7                	mov    %eax,%edi
  800262:	89 de                	mov    %ebx,%esi
  800264:	89 d1                	mov    %edx,%ecx
  800266:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800268:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80026b:	b9 56 00 00 00       	mov    $0x56,%ecx
  800270:	b0 00                	mov    $0x0,%al
  800272:	89 d7                	mov    %edx,%edi
  800274:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800276:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80027d:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800280:	83 ec 08             	sub    $0x8,%esp
  800283:	50                   	push   %eax
  800284:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80028a:	50                   	push   %eax
  80028b:	e8 cc 19 00 00       	call   801c5c <sys_utilities>
  800290:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800293:	e8 15 15 00 00       	call   8017ad <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800298:	83 ec 0c             	sub    $0xc,%esp
  80029b:	68 28 22 80 00       	push   $0x802228
  8002a0:	e8 ac 03 00 00       	call   800651 <cprintf>
  8002a5:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8002a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002ab:	85 c0                	test   %eax,%eax
  8002ad:	74 18                	je     8002c7 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8002af:	e8 c6 19 00 00       	call   801c7a <sys_get_optimal_num_faults>
  8002b4:	83 ec 08             	sub    $0x8,%esp
  8002b7:	50                   	push   %eax
  8002b8:	68 50 22 80 00       	push   $0x802250
  8002bd:	e8 8f 03 00 00       	call   800651 <cprintf>
  8002c2:	83 c4 10             	add    $0x10,%esp
  8002c5:	eb 59                	jmp    800320 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8002c7:	a1 20 30 80 00       	mov    0x803020,%eax
  8002cc:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8002d2:	a1 20 30 80 00       	mov    0x803020,%eax
  8002d7:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  8002dd:	83 ec 04             	sub    $0x4,%esp
  8002e0:	52                   	push   %edx
  8002e1:	50                   	push   %eax
  8002e2:	68 74 22 80 00       	push   $0x802274
  8002e7:	e8 65 03 00 00       	call   800651 <cprintf>
  8002ec:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8002ef:	a1 20 30 80 00       	mov    0x803020,%eax
  8002f4:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8002fa:	a1 20 30 80 00       	mov    0x803020,%eax
  8002ff:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  800305:	a1 20 30 80 00       	mov    0x803020,%eax
  80030a:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  800310:	51                   	push   %ecx
  800311:	52                   	push   %edx
  800312:	50                   	push   %eax
  800313:	68 9c 22 80 00       	push   $0x80229c
  800318:	e8 34 03 00 00       	call   800651 <cprintf>
  80031d:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800320:	a1 20 30 80 00       	mov    0x803020,%eax
  800325:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  80032b:	83 ec 08             	sub    $0x8,%esp
  80032e:	50                   	push   %eax
  80032f:	68 f4 22 80 00       	push   $0x8022f4
  800334:	e8 18 03 00 00       	call   800651 <cprintf>
  800339:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80033c:	83 ec 0c             	sub    $0xc,%esp
  80033f:	68 28 22 80 00       	push   $0x802228
  800344:	e8 08 03 00 00       	call   800651 <cprintf>
  800349:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80034c:	e8 76 14 00 00       	call   8017c7 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800351:	e8 1f 00 00 00       	call   800375 <exit>
}
  800356:	90                   	nop
  800357:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80035a:	5b                   	pop    %ebx
  80035b:	5e                   	pop    %esi
  80035c:	5f                   	pop    %edi
  80035d:	5d                   	pop    %ebp
  80035e:	c3                   	ret    

0080035f <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80035f:	55                   	push   %ebp
  800360:	89 e5                	mov    %esp,%ebp
  800362:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800365:	83 ec 0c             	sub    $0xc,%esp
  800368:	6a 00                	push   $0x0
  80036a:	e8 83 16 00 00       	call   8019f2 <sys_destroy_env>
  80036f:	83 c4 10             	add    $0x10,%esp
}
  800372:	90                   	nop
  800373:	c9                   	leave  
  800374:	c3                   	ret    

00800375 <exit>:

void
exit(void)
{
  800375:	55                   	push   %ebp
  800376:	89 e5                	mov    %esp,%ebp
  800378:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80037b:	e8 d8 16 00 00       	call   801a58 <sys_exit_env>
}
  800380:	90                   	nop
  800381:	c9                   	leave  
  800382:	c3                   	ret    

00800383 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800383:	55                   	push   %ebp
  800384:	89 e5                	mov    %esp,%ebp
  800386:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800389:	8d 45 10             	lea    0x10(%ebp),%eax
  80038c:	83 c0 04             	add    $0x4,%eax
  80038f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800392:	a1 18 b1 81 00       	mov    0x81b118,%eax
  800397:	85 c0                	test   %eax,%eax
  800399:	74 16                	je     8003b1 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80039b:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8003a0:	83 ec 08             	sub    $0x8,%esp
  8003a3:	50                   	push   %eax
  8003a4:	68 6c 23 80 00       	push   $0x80236c
  8003a9:	e8 a3 02 00 00       	call   800651 <cprintf>
  8003ae:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8003b1:	a1 04 30 80 00       	mov    0x803004,%eax
  8003b6:	83 ec 0c             	sub    $0xc,%esp
  8003b9:	ff 75 0c             	pushl  0xc(%ebp)
  8003bc:	ff 75 08             	pushl  0x8(%ebp)
  8003bf:	50                   	push   %eax
  8003c0:	68 74 23 80 00       	push   $0x802374
  8003c5:	6a 74                	push   $0x74
  8003c7:	e8 b2 02 00 00       	call   80067e <cprintf_colored>
  8003cc:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8003cf:	8b 45 10             	mov    0x10(%ebp),%eax
  8003d2:	83 ec 08             	sub    $0x8,%esp
  8003d5:	ff 75 f4             	pushl  -0xc(%ebp)
  8003d8:	50                   	push   %eax
  8003d9:	e8 04 02 00 00       	call   8005e2 <vcprintf>
  8003de:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8003e1:	83 ec 08             	sub    $0x8,%esp
  8003e4:	6a 00                	push   $0x0
  8003e6:	68 9c 23 80 00       	push   $0x80239c
  8003eb:	e8 f2 01 00 00       	call   8005e2 <vcprintf>
  8003f0:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8003f3:	e8 7d ff ff ff       	call   800375 <exit>

	// should not return here
	while (1) ;
  8003f8:	eb fe                	jmp    8003f8 <_panic+0x75>

008003fa <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8003fa:	55                   	push   %ebp
  8003fb:	89 e5                	mov    %esp,%ebp
  8003fd:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800400:	a1 20 30 80 00       	mov    0x803020,%eax
  800405:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80040b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80040e:	39 c2                	cmp    %eax,%edx
  800410:	74 14                	je     800426 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800412:	83 ec 04             	sub    $0x4,%esp
  800415:	68 a0 23 80 00       	push   $0x8023a0
  80041a:	6a 26                	push   $0x26
  80041c:	68 ec 23 80 00       	push   $0x8023ec
  800421:	e8 5d ff ff ff       	call   800383 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800426:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80042d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800434:	e9 c5 00 00 00       	jmp    8004fe <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800439:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80043c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800443:	8b 45 08             	mov    0x8(%ebp),%eax
  800446:	01 d0                	add    %edx,%eax
  800448:	8b 00                	mov    (%eax),%eax
  80044a:	85 c0                	test   %eax,%eax
  80044c:	75 08                	jne    800456 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80044e:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800451:	e9 a5 00 00 00       	jmp    8004fb <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800456:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80045d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800464:	eb 69                	jmp    8004cf <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800466:	a1 20 30 80 00       	mov    0x803020,%eax
  80046b:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800471:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800474:	89 d0                	mov    %edx,%eax
  800476:	01 c0                	add    %eax,%eax
  800478:	01 d0                	add    %edx,%eax
  80047a:	c1 e0 03             	shl    $0x3,%eax
  80047d:	01 c8                	add    %ecx,%eax
  80047f:	8a 40 04             	mov    0x4(%eax),%al
  800482:	84 c0                	test   %al,%al
  800484:	75 46                	jne    8004cc <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800486:	a1 20 30 80 00       	mov    0x803020,%eax
  80048b:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800491:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800494:	89 d0                	mov    %edx,%eax
  800496:	01 c0                	add    %eax,%eax
  800498:	01 d0                	add    %edx,%eax
  80049a:	c1 e0 03             	shl    $0x3,%eax
  80049d:	01 c8                	add    %ecx,%eax
  80049f:	8b 00                	mov    (%eax),%eax
  8004a1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8004a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004a7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8004ac:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8004ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004b1:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8004b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8004bb:	01 c8                	add    %ecx,%eax
  8004bd:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004bf:	39 c2                	cmp    %eax,%edx
  8004c1:	75 09                	jne    8004cc <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8004c3:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8004ca:	eb 15                	jmp    8004e1 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004cc:	ff 45 e8             	incl   -0x18(%ebp)
  8004cf:	a1 20 30 80 00       	mov    0x803020,%eax
  8004d4:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004dd:	39 c2                	cmp    %eax,%edx
  8004df:	77 85                	ja     800466 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8004e1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8004e5:	75 14                	jne    8004fb <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8004e7:	83 ec 04             	sub    $0x4,%esp
  8004ea:	68 f8 23 80 00       	push   $0x8023f8
  8004ef:	6a 3a                	push   $0x3a
  8004f1:	68 ec 23 80 00       	push   $0x8023ec
  8004f6:	e8 88 fe ff ff       	call   800383 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8004fb:	ff 45 f0             	incl   -0x10(%ebp)
  8004fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800501:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800504:	0f 8c 2f ff ff ff    	jl     800439 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80050a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800511:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800518:	eb 26                	jmp    800540 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80051a:	a1 20 30 80 00       	mov    0x803020,%eax
  80051f:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800525:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800528:	89 d0                	mov    %edx,%eax
  80052a:	01 c0                	add    %eax,%eax
  80052c:	01 d0                	add    %edx,%eax
  80052e:	c1 e0 03             	shl    $0x3,%eax
  800531:	01 c8                	add    %ecx,%eax
  800533:	8a 40 04             	mov    0x4(%eax),%al
  800536:	3c 01                	cmp    $0x1,%al
  800538:	75 03                	jne    80053d <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80053a:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80053d:	ff 45 e0             	incl   -0x20(%ebp)
  800540:	a1 20 30 80 00       	mov    0x803020,%eax
  800545:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80054b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80054e:	39 c2                	cmp    %eax,%edx
  800550:	77 c8                	ja     80051a <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800552:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800555:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800558:	74 14                	je     80056e <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80055a:	83 ec 04             	sub    $0x4,%esp
  80055d:	68 4c 24 80 00       	push   $0x80244c
  800562:	6a 44                	push   $0x44
  800564:	68 ec 23 80 00       	push   $0x8023ec
  800569:	e8 15 fe ff ff       	call   800383 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80056e:	90                   	nop
  80056f:	c9                   	leave  
  800570:	c3                   	ret    

00800571 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800571:	55                   	push   %ebp
  800572:	89 e5                	mov    %esp,%ebp
  800574:	53                   	push   %ebx
  800575:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800578:	8b 45 0c             	mov    0xc(%ebp),%eax
  80057b:	8b 00                	mov    (%eax),%eax
  80057d:	8d 48 01             	lea    0x1(%eax),%ecx
  800580:	8b 55 0c             	mov    0xc(%ebp),%edx
  800583:	89 0a                	mov    %ecx,(%edx)
  800585:	8b 55 08             	mov    0x8(%ebp),%edx
  800588:	88 d1                	mov    %dl,%cl
  80058a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80058d:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800591:	8b 45 0c             	mov    0xc(%ebp),%eax
  800594:	8b 00                	mov    (%eax),%eax
  800596:	3d ff 00 00 00       	cmp    $0xff,%eax
  80059b:	75 30                	jne    8005cd <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  80059d:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  8005a3:	a0 44 30 80 00       	mov    0x803044,%al
  8005a8:	0f b6 c0             	movzbl %al,%eax
  8005ab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005ae:	8b 09                	mov    (%ecx),%ecx
  8005b0:	89 cb                	mov    %ecx,%ebx
  8005b2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005b5:	83 c1 08             	add    $0x8,%ecx
  8005b8:	52                   	push   %edx
  8005b9:	50                   	push   %eax
  8005ba:	53                   	push   %ebx
  8005bb:	51                   	push   %ecx
  8005bc:	e8 a8 11 00 00       	call   801769 <sys_cputs>
  8005c1:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8005c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005c7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8005cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005d0:	8b 40 04             	mov    0x4(%eax),%eax
  8005d3:	8d 50 01             	lea    0x1(%eax),%edx
  8005d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005d9:	89 50 04             	mov    %edx,0x4(%eax)
}
  8005dc:	90                   	nop
  8005dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8005e0:	c9                   	leave  
  8005e1:	c3                   	ret    

008005e2 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8005e2:	55                   	push   %ebp
  8005e3:	89 e5                	mov    %esp,%ebp
  8005e5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8005eb:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005f2:	00 00 00 
	b.cnt = 0;
  8005f5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8005fc:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8005ff:	ff 75 0c             	pushl  0xc(%ebp)
  800602:	ff 75 08             	pushl  0x8(%ebp)
  800605:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80060b:	50                   	push   %eax
  80060c:	68 71 05 80 00       	push   $0x800571
  800611:	e8 5a 02 00 00       	call   800870 <vprintfmt>
  800616:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800619:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  80061f:	a0 44 30 80 00       	mov    0x803044,%al
  800624:	0f b6 c0             	movzbl %al,%eax
  800627:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  80062d:	52                   	push   %edx
  80062e:	50                   	push   %eax
  80062f:	51                   	push   %ecx
  800630:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800636:	83 c0 08             	add    $0x8,%eax
  800639:	50                   	push   %eax
  80063a:	e8 2a 11 00 00       	call   801769 <sys_cputs>
  80063f:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800642:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  800649:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80064f:	c9                   	leave  
  800650:	c3                   	ret    

00800651 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800651:	55                   	push   %ebp
  800652:	89 e5                	mov    %esp,%ebp
  800654:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800657:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  80065e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800661:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800664:	8b 45 08             	mov    0x8(%ebp),%eax
  800667:	83 ec 08             	sub    $0x8,%esp
  80066a:	ff 75 f4             	pushl  -0xc(%ebp)
  80066d:	50                   	push   %eax
  80066e:	e8 6f ff ff ff       	call   8005e2 <vcprintf>
  800673:	83 c4 10             	add    $0x10,%esp
  800676:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800679:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80067c:	c9                   	leave  
  80067d:	c3                   	ret    

0080067e <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  80067e:	55                   	push   %ebp
  80067f:	89 e5                	mov    %esp,%ebp
  800681:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800684:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  80068b:	8b 45 08             	mov    0x8(%ebp),%eax
  80068e:	c1 e0 08             	shl    $0x8,%eax
  800691:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  800696:	8d 45 0c             	lea    0xc(%ebp),%eax
  800699:	83 c0 04             	add    $0x4,%eax
  80069c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80069f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006a2:	83 ec 08             	sub    $0x8,%esp
  8006a5:	ff 75 f4             	pushl  -0xc(%ebp)
  8006a8:	50                   	push   %eax
  8006a9:	e8 34 ff ff ff       	call   8005e2 <vcprintf>
  8006ae:	83 c4 10             	add    $0x10,%esp
  8006b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8006b4:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  8006bb:	07 00 00 

	return cnt;
  8006be:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006c1:	c9                   	leave  
  8006c2:	c3                   	ret    

008006c3 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8006c3:	55                   	push   %ebp
  8006c4:	89 e5                	mov    %esp,%ebp
  8006c6:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8006c9:	e8 df 10 00 00       	call   8017ad <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8006ce:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8006d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d7:	83 ec 08             	sub    $0x8,%esp
  8006da:	ff 75 f4             	pushl  -0xc(%ebp)
  8006dd:	50                   	push   %eax
  8006de:	e8 ff fe ff ff       	call   8005e2 <vcprintf>
  8006e3:	83 c4 10             	add    $0x10,%esp
  8006e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8006e9:	e8 d9 10 00 00       	call   8017c7 <sys_unlock_cons>
	return cnt;
  8006ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006f1:	c9                   	leave  
  8006f2:	c3                   	ret    

008006f3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006f3:	55                   	push   %ebp
  8006f4:	89 e5                	mov    %esp,%ebp
  8006f6:	53                   	push   %ebx
  8006f7:	83 ec 14             	sub    $0x14,%esp
  8006fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8006fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800700:	8b 45 14             	mov    0x14(%ebp),%eax
  800703:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800706:	8b 45 18             	mov    0x18(%ebp),%eax
  800709:	ba 00 00 00 00       	mov    $0x0,%edx
  80070e:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800711:	77 55                	ja     800768 <printnum+0x75>
  800713:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800716:	72 05                	jb     80071d <printnum+0x2a>
  800718:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80071b:	77 4b                	ja     800768 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80071d:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800720:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800723:	8b 45 18             	mov    0x18(%ebp),%eax
  800726:	ba 00 00 00 00       	mov    $0x0,%edx
  80072b:	52                   	push   %edx
  80072c:	50                   	push   %eax
  80072d:	ff 75 f4             	pushl  -0xc(%ebp)
  800730:	ff 75 f0             	pushl  -0x10(%ebp)
  800733:	e8 ac 16 00 00       	call   801de4 <__udivdi3>
  800738:	83 c4 10             	add    $0x10,%esp
  80073b:	83 ec 04             	sub    $0x4,%esp
  80073e:	ff 75 20             	pushl  0x20(%ebp)
  800741:	53                   	push   %ebx
  800742:	ff 75 18             	pushl  0x18(%ebp)
  800745:	52                   	push   %edx
  800746:	50                   	push   %eax
  800747:	ff 75 0c             	pushl  0xc(%ebp)
  80074a:	ff 75 08             	pushl  0x8(%ebp)
  80074d:	e8 a1 ff ff ff       	call   8006f3 <printnum>
  800752:	83 c4 20             	add    $0x20,%esp
  800755:	eb 1a                	jmp    800771 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800757:	83 ec 08             	sub    $0x8,%esp
  80075a:	ff 75 0c             	pushl  0xc(%ebp)
  80075d:	ff 75 20             	pushl  0x20(%ebp)
  800760:	8b 45 08             	mov    0x8(%ebp),%eax
  800763:	ff d0                	call   *%eax
  800765:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800768:	ff 4d 1c             	decl   0x1c(%ebp)
  80076b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80076f:	7f e6                	jg     800757 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800771:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800774:	bb 00 00 00 00       	mov    $0x0,%ebx
  800779:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80077c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80077f:	53                   	push   %ebx
  800780:	51                   	push   %ecx
  800781:	52                   	push   %edx
  800782:	50                   	push   %eax
  800783:	e8 6c 17 00 00       	call   801ef4 <__umoddi3>
  800788:	83 c4 10             	add    $0x10,%esp
  80078b:	05 b4 26 80 00       	add    $0x8026b4,%eax
  800790:	8a 00                	mov    (%eax),%al
  800792:	0f be c0             	movsbl %al,%eax
  800795:	83 ec 08             	sub    $0x8,%esp
  800798:	ff 75 0c             	pushl  0xc(%ebp)
  80079b:	50                   	push   %eax
  80079c:	8b 45 08             	mov    0x8(%ebp),%eax
  80079f:	ff d0                	call   *%eax
  8007a1:	83 c4 10             	add    $0x10,%esp
}
  8007a4:	90                   	nop
  8007a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007a8:	c9                   	leave  
  8007a9:	c3                   	ret    

008007aa <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007aa:	55                   	push   %ebp
  8007ab:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007ad:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007b1:	7e 1c                	jle    8007cf <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8007b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b6:	8b 00                	mov    (%eax),%eax
  8007b8:	8d 50 08             	lea    0x8(%eax),%edx
  8007bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007be:	89 10                	mov    %edx,(%eax)
  8007c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c3:	8b 00                	mov    (%eax),%eax
  8007c5:	83 e8 08             	sub    $0x8,%eax
  8007c8:	8b 50 04             	mov    0x4(%eax),%edx
  8007cb:	8b 00                	mov    (%eax),%eax
  8007cd:	eb 40                	jmp    80080f <getuint+0x65>
	else if (lflag)
  8007cf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007d3:	74 1e                	je     8007f3 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8007d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d8:	8b 00                	mov    (%eax),%eax
  8007da:	8d 50 04             	lea    0x4(%eax),%edx
  8007dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e0:	89 10                	mov    %edx,(%eax)
  8007e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e5:	8b 00                	mov    (%eax),%eax
  8007e7:	83 e8 04             	sub    $0x4,%eax
  8007ea:	8b 00                	mov    (%eax),%eax
  8007ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8007f1:	eb 1c                	jmp    80080f <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8007f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f6:	8b 00                	mov    (%eax),%eax
  8007f8:	8d 50 04             	lea    0x4(%eax),%edx
  8007fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fe:	89 10                	mov    %edx,(%eax)
  800800:	8b 45 08             	mov    0x8(%ebp),%eax
  800803:	8b 00                	mov    (%eax),%eax
  800805:	83 e8 04             	sub    $0x4,%eax
  800808:	8b 00                	mov    (%eax),%eax
  80080a:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80080f:	5d                   	pop    %ebp
  800810:	c3                   	ret    

00800811 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800811:	55                   	push   %ebp
  800812:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800814:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800818:	7e 1c                	jle    800836 <getint+0x25>
		return va_arg(*ap, long long);
  80081a:	8b 45 08             	mov    0x8(%ebp),%eax
  80081d:	8b 00                	mov    (%eax),%eax
  80081f:	8d 50 08             	lea    0x8(%eax),%edx
  800822:	8b 45 08             	mov    0x8(%ebp),%eax
  800825:	89 10                	mov    %edx,(%eax)
  800827:	8b 45 08             	mov    0x8(%ebp),%eax
  80082a:	8b 00                	mov    (%eax),%eax
  80082c:	83 e8 08             	sub    $0x8,%eax
  80082f:	8b 50 04             	mov    0x4(%eax),%edx
  800832:	8b 00                	mov    (%eax),%eax
  800834:	eb 38                	jmp    80086e <getint+0x5d>
	else if (lflag)
  800836:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80083a:	74 1a                	je     800856 <getint+0x45>
		return va_arg(*ap, long);
  80083c:	8b 45 08             	mov    0x8(%ebp),%eax
  80083f:	8b 00                	mov    (%eax),%eax
  800841:	8d 50 04             	lea    0x4(%eax),%edx
  800844:	8b 45 08             	mov    0x8(%ebp),%eax
  800847:	89 10                	mov    %edx,(%eax)
  800849:	8b 45 08             	mov    0x8(%ebp),%eax
  80084c:	8b 00                	mov    (%eax),%eax
  80084e:	83 e8 04             	sub    $0x4,%eax
  800851:	8b 00                	mov    (%eax),%eax
  800853:	99                   	cltd   
  800854:	eb 18                	jmp    80086e <getint+0x5d>
	else
		return va_arg(*ap, int);
  800856:	8b 45 08             	mov    0x8(%ebp),%eax
  800859:	8b 00                	mov    (%eax),%eax
  80085b:	8d 50 04             	lea    0x4(%eax),%edx
  80085e:	8b 45 08             	mov    0x8(%ebp),%eax
  800861:	89 10                	mov    %edx,(%eax)
  800863:	8b 45 08             	mov    0x8(%ebp),%eax
  800866:	8b 00                	mov    (%eax),%eax
  800868:	83 e8 04             	sub    $0x4,%eax
  80086b:	8b 00                	mov    (%eax),%eax
  80086d:	99                   	cltd   
}
  80086e:	5d                   	pop    %ebp
  80086f:	c3                   	ret    

00800870 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800870:	55                   	push   %ebp
  800871:	89 e5                	mov    %esp,%ebp
  800873:	56                   	push   %esi
  800874:	53                   	push   %ebx
  800875:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800878:	eb 17                	jmp    800891 <vprintfmt+0x21>
			if (ch == '\0')
  80087a:	85 db                	test   %ebx,%ebx
  80087c:	0f 84 c1 03 00 00    	je     800c43 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800882:	83 ec 08             	sub    $0x8,%esp
  800885:	ff 75 0c             	pushl  0xc(%ebp)
  800888:	53                   	push   %ebx
  800889:	8b 45 08             	mov    0x8(%ebp),%eax
  80088c:	ff d0                	call   *%eax
  80088e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800891:	8b 45 10             	mov    0x10(%ebp),%eax
  800894:	8d 50 01             	lea    0x1(%eax),%edx
  800897:	89 55 10             	mov    %edx,0x10(%ebp)
  80089a:	8a 00                	mov    (%eax),%al
  80089c:	0f b6 d8             	movzbl %al,%ebx
  80089f:	83 fb 25             	cmp    $0x25,%ebx
  8008a2:	75 d6                	jne    80087a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008a4:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8008a8:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8008af:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8008b6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8008bd:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8008c7:	8d 50 01             	lea    0x1(%eax),%edx
  8008ca:	89 55 10             	mov    %edx,0x10(%ebp)
  8008cd:	8a 00                	mov    (%eax),%al
  8008cf:	0f b6 d8             	movzbl %al,%ebx
  8008d2:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8008d5:	83 f8 5b             	cmp    $0x5b,%eax
  8008d8:	0f 87 3d 03 00 00    	ja     800c1b <vprintfmt+0x3ab>
  8008de:	8b 04 85 d8 26 80 00 	mov    0x8026d8(,%eax,4),%eax
  8008e5:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8008e7:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8008eb:	eb d7                	jmp    8008c4 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008ed:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8008f1:	eb d1                	jmp    8008c4 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008f3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8008fa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008fd:	89 d0                	mov    %edx,%eax
  8008ff:	c1 e0 02             	shl    $0x2,%eax
  800902:	01 d0                	add    %edx,%eax
  800904:	01 c0                	add    %eax,%eax
  800906:	01 d8                	add    %ebx,%eax
  800908:	83 e8 30             	sub    $0x30,%eax
  80090b:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80090e:	8b 45 10             	mov    0x10(%ebp),%eax
  800911:	8a 00                	mov    (%eax),%al
  800913:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800916:	83 fb 2f             	cmp    $0x2f,%ebx
  800919:	7e 3e                	jle    800959 <vprintfmt+0xe9>
  80091b:	83 fb 39             	cmp    $0x39,%ebx
  80091e:	7f 39                	jg     800959 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800920:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800923:	eb d5                	jmp    8008fa <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800925:	8b 45 14             	mov    0x14(%ebp),%eax
  800928:	83 c0 04             	add    $0x4,%eax
  80092b:	89 45 14             	mov    %eax,0x14(%ebp)
  80092e:	8b 45 14             	mov    0x14(%ebp),%eax
  800931:	83 e8 04             	sub    $0x4,%eax
  800934:	8b 00                	mov    (%eax),%eax
  800936:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800939:	eb 1f                	jmp    80095a <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80093b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80093f:	79 83                	jns    8008c4 <vprintfmt+0x54>
				width = 0;
  800941:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800948:	e9 77 ff ff ff       	jmp    8008c4 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80094d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800954:	e9 6b ff ff ff       	jmp    8008c4 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800959:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80095a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80095e:	0f 89 60 ff ff ff    	jns    8008c4 <vprintfmt+0x54>
				width = precision, precision = -1;
  800964:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800967:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80096a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800971:	e9 4e ff ff ff       	jmp    8008c4 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800976:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800979:	e9 46 ff ff ff       	jmp    8008c4 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80097e:	8b 45 14             	mov    0x14(%ebp),%eax
  800981:	83 c0 04             	add    $0x4,%eax
  800984:	89 45 14             	mov    %eax,0x14(%ebp)
  800987:	8b 45 14             	mov    0x14(%ebp),%eax
  80098a:	83 e8 04             	sub    $0x4,%eax
  80098d:	8b 00                	mov    (%eax),%eax
  80098f:	83 ec 08             	sub    $0x8,%esp
  800992:	ff 75 0c             	pushl  0xc(%ebp)
  800995:	50                   	push   %eax
  800996:	8b 45 08             	mov    0x8(%ebp),%eax
  800999:	ff d0                	call   *%eax
  80099b:	83 c4 10             	add    $0x10,%esp
			break;
  80099e:	e9 9b 02 00 00       	jmp    800c3e <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8009a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a6:	83 c0 04             	add    $0x4,%eax
  8009a9:	89 45 14             	mov    %eax,0x14(%ebp)
  8009ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8009af:	83 e8 04             	sub    $0x4,%eax
  8009b2:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8009b4:	85 db                	test   %ebx,%ebx
  8009b6:	79 02                	jns    8009ba <vprintfmt+0x14a>
				err = -err;
  8009b8:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8009ba:	83 fb 64             	cmp    $0x64,%ebx
  8009bd:	7f 0b                	jg     8009ca <vprintfmt+0x15a>
  8009bf:	8b 34 9d 20 25 80 00 	mov    0x802520(,%ebx,4),%esi
  8009c6:	85 f6                	test   %esi,%esi
  8009c8:	75 19                	jne    8009e3 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009ca:	53                   	push   %ebx
  8009cb:	68 c5 26 80 00       	push   $0x8026c5
  8009d0:	ff 75 0c             	pushl  0xc(%ebp)
  8009d3:	ff 75 08             	pushl  0x8(%ebp)
  8009d6:	e8 70 02 00 00       	call   800c4b <printfmt>
  8009db:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8009de:	e9 5b 02 00 00       	jmp    800c3e <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8009e3:	56                   	push   %esi
  8009e4:	68 ce 26 80 00       	push   $0x8026ce
  8009e9:	ff 75 0c             	pushl  0xc(%ebp)
  8009ec:	ff 75 08             	pushl  0x8(%ebp)
  8009ef:	e8 57 02 00 00       	call   800c4b <printfmt>
  8009f4:	83 c4 10             	add    $0x10,%esp
			break;
  8009f7:	e9 42 02 00 00       	jmp    800c3e <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8009fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ff:	83 c0 04             	add    $0x4,%eax
  800a02:	89 45 14             	mov    %eax,0x14(%ebp)
  800a05:	8b 45 14             	mov    0x14(%ebp),%eax
  800a08:	83 e8 04             	sub    $0x4,%eax
  800a0b:	8b 30                	mov    (%eax),%esi
  800a0d:	85 f6                	test   %esi,%esi
  800a0f:	75 05                	jne    800a16 <vprintfmt+0x1a6>
				p = "(null)";
  800a11:	be d1 26 80 00       	mov    $0x8026d1,%esi
			if (width > 0 && padc != '-')
  800a16:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a1a:	7e 6d                	jle    800a89 <vprintfmt+0x219>
  800a1c:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800a20:	74 67                	je     800a89 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a22:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a25:	83 ec 08             	sub    $0x8,%esp
  800a28:	50                   	push   %eax
  800a29:	56                   	push   %esi
  800a2a:	e8 26 05 00 00       	call   800f55 <strnlen>
  800a2f:	83 c4 10             	add    $0x10,%esp
  800a32:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800a35:	eb 16                	jmp    800a4d <vprintfmt+0x1dd>
					putch(padc, putdat);
  800a37:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800a3b:	83 ec 08             	sub    $0x8,%esp
  800a3e:	ff 75 0c             	pushl  0xc(%ebp)
  800a41:	50                   	push   %eax
  800a42:	8b 45 08             	mov    0x8(%ebp),%eax
  800a45:	ff d0                	call   *%eax
  800a47:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a4a:	ff 4d e4             	decl   -0x1c(%ebp)
  800a4d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a51:	7f e4                	jg     800a37 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a53:	eb 34                	jmp    800a89 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a55:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a59:	74 1c                	je     800a77 <vprintfmt+0x207>
  800a5b:	83 fb 1f             	cmp    $0x1f,%ebx
  800a5e:	7e 05                	jle    800a65 <vprintfmt+0x1f5>
  800a60:	83 fb 7e             	cmp    $0x7e,%ebx
  800a63:	7e 12                	jle    800a77 <vprintfmt+0x207>
					putch('?', putdat);
  800a65:	83 ec 08             	sub    $0x8,%esp
  800a68:	ff 75 0c             	pushl  0xc(%ebp)
  800a6b:	6a 3f                	push   $0x3f
  800a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a70:	ff d0                	call   *%eax
  800a72:	83 c4 10             	add    $0x10,%esp
  800a75:	eb 0f                	jmp    800a86 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a77:	83 ec 08             	sub    $0x8,%esp
  800a7a:	ff 75 0c             	pushl  0xc(%ebp)
  800a7d:	53                   	push   %ebx
  800a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a81:	ff d0                	call   *%eax
  800a83:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a86:	ff 4d e4             	decl   -0x1c(%ebp)
  800a89:	89 f0                	mov    %esi,%eax
  800a8b:	8d 70 01             	lea    0x1(%eax),%esi
  800a8e:	8a 00                	mov    (%eax),%al
  800a90:	0f be d8             	movsbl %al,%ebx
  800a93:	85 db                	test   %ebx,%ebx
  800a95:	74 24                	je     800abb <vprintfmt+0x24b>
  800a97:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a9b:	78 b8                	js     800a55 <vprintfmt+0x1e5>
  800a9d:	ff 4d e0             	decl   -0x20(%ebp)
  800aa0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800aa4:	79 af                	jns    800a55 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800aa6:	eb 13                	jmp    800abb <vprintfmt+0x24b>
				putch(' ', putdat);
  800aa8:	83 ec 08             	sub    $0x8,%esp
  800aab:	ff 75 0c             	pushl  0xc(%ebp)
  800aae:	6a 20                	push   $0x20
  800ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab3:	ff d0                	call   *%eax
  800ab5:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ab8:	ff 4d e4             	decl   -0x1c(%ebp)
  800abb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800abf:	7f e7                	jg     800aa8 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800ac1:	e9 78 01 00 00       	jmp    800c3e <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ac6:	83 ec 08             	sub    $0x8,%esp
  800ac9:	ff 75 e8             	pushl  -0x18(%ebp)
  800acc:	8d 45 14             	lea    0x14(%ebp),%eax
  800acf:	50                   	push   %eax
  800ad0:	e8 3c fd ff ff       	call   800811 <getint>
  800ad5:	83 c4 10             	add    $0x10,%esp
  800ad8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800adb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800ade:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ae1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ae4:	85 d2                	test   %edx,%edx
  800ae6:	79 23                	jns    800b0b <vprintfmt+0x29b>
				putch('-', putdat);
  800ae8:	83 ec 08             	sub    $0x8,%esp
  800aeb:	ff 75 0c             	pushl  0xc(%ebp)
  800aee:	6a 2d                	push   $0x2d
  800af0:	8b 45 08             	mov    0x8(%ebp),%eax
  800af3:	ff d0                	call   *%eax
  800af5:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800af8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800afb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800afe:	f7 d8                	neg    %eax
  800b00:	83 d2 00             	adc    $0x0,%edx
  800b03:	f7 da                	neg    %edx
  800b05:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b08:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800b0b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b12:	e9 bc 00 00 00       	jmp    800bd3 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b17:	83 ec 08             	sub    $0x8,%esp
  800b1a:	ff 75 e8             	pushl  -0x18(%ebp)
  800b1d:	8d 45 14             	lea    0x14(%ebp),%eax
  800b20:	50                   	push   %eax
  800b21:	e8 84 fc ff ff       	call   8007aa <getuint>
  800b26:	83 c4 10             	add    $0x10,%esp
  800b29:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b2c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800b2f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b36:	e9 98 00 00 00       	jmp    800bd3 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b3b:	83 ec 08             	sub    $0x8,%esp
  800b3e:	ff 75 0c             	pushl  0xc(%ebp)
  800b41:	6a 58                	push   $0x58
  800b43:	8b 45 08             	mov    0x8(%ebp),%eax
  800b46:	ff d0                	call   *%eax
  800b48:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b4b:	83 ec 08             	sub    $0x8,%esp
  800b4e:	ff 75 0c             	pushl  0xc(%ebp)
  800b51:	6a 58                	push   $0x58
  800b53:	8b 45 08             	mov    0x8(%ebp),%eax
  800b56:	ff d0                	call   *%eax
  800b58:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b5b:	83 ec 08             	sub    $0x8,%esp
  800b5e:	ff 75 0c             	pushl  0xc(%ebp)
  800b61:	6a 58                	push   $0x58
  800b63:	8b 45 08             	mov    0x8(%ebp),%eax
  800b66:	ff d0                	call   *%eax
  800b68:	83 c4 10             	add    $0x10,%esp
			break;
  800b6b:	e9 ce 00 00 00       	jmp    800c3e <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800b70:	83 ec 08             	sub    $0x8,%esp
  800b73:	ff 75 0c             	pushl  0xc(%ebp)
  800b76:	6a 30                	push   $0x30
  800b78:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7b:	ff d0                	call   *%eax
  800b7d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b80:	83 ec 08             	sub    $0x8,%esp
  800b83:	ff 75 0c             	pushl  0xc(%ebp)
  800b86:	6a 78                	push   $0x78
  800b88:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8b:	ff d0                	call   *%eax
  800b8d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b90:	8b 45 14             	mov    0x14(%ebp),%eax
  800b93:	83 c0 04             	add    $0x4,%eax
  800b96:	89 45 14             	mov    %eax,0x14(%ebp)
  800b99:	8b 45 14             	mov    0x14(%ebp),%eax
  800b9c:	83 e8 04             	sub    $0x4,%eax
  800b9f:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ba1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ba4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800bab:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800bb2:	eb 1f                	jmp    800bd3 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800bb4:	83 ec 08             	sub    $0x8,%esp
  800bb7:	ff 75 e8             	pushl  -0x18(%ebp)
  800bba:	8d 45 14             	lea    0x14(%ebp),%eax
  800bbd:	50                   	push   %eax
  800bbe:	e8 e7 fb ff ff       	call   8007aa <getuint>
  800bc3:	83 c4 10             	add    $0x10,%esp
  800bc6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bc9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800bcc:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800bd3:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800bd7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bda:	83 ec 04             	sub    $0x4,%esp
  800bdd:	52                   	push   %edx
  800bde:	ff 75 e4             	pushl  -0x1c(%ebp)
  800be1:	50                   	push   %eax
  800be2:	ff 75 f4             	pushl  -0xc(%ebp)
  800be5:	ff 75 f0             	pushl  -0x10(%ebp)
  800be8:	ff 75 0c             	pushl  0xc(%ebp)
  800beb:	ff 75 08             	pushl  0x8(%ebp)
  800bee:	e8 00 fb ff ff       	call   8006f3 <printnum>
  800bf3:	83 c4 20             	add    $0x20,%esp
			break;
  800bf6:	eb 46                	jmp    800c3e <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800bf8:	83 ec 08             	sub    $0x8,%esp
  800bfb:	ff 75 0c             	pushl  0xc(%ebp)
  800bfe:	53                   	push   %ebx
  800bff:	8b 45 08             	mov    0x8(%ebp),%eax
  800c02:	ff d0                	call   *%eax
  800c04:	83 c4 10             	add    $0x10,%esp
			break;
  800c07:	eb 35                	jmp    800c3e <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800c09:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800c10:	eb 2c                	jmp    800c3e <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800c12:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800c19:	eb 23                	jmp    800c3e <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c1b:	83 ec 08             	sub    $0x8,%esp
  800c1e:	ff 75 0c             	pushl  0xc(%ebp)
  800c21:	6a 25                	push   $0x25
  800c23:	8b 45 08             	mov    0x8(%ebp),%eax
  800c26:	ff d0                	call   *%eax
  800c28:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c2b:	ff 4d 10             	decl   0x10(%ebp)
  800c2e:	eb 03                	jmp    800c33 <vprintfmt+0x3c3>
  800c30:	ff 4d 10             	decl   0x10(%ebp)
  800c33:	8b 45 10             	mov    0x10(%ebp),%eax
  800c36:	48                   	dec    %eax
  800c37:	8a 00                	mov    (%eax),%al
  800c39:	3c 25                	cmp    $0x25,%al
  800c3b:	75 f3                	jne    800c30 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800c3d:	90                   	nop
		}
	}
  800c3e:	e9 35 fc ff ff       	jmp    800878 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800c43:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800c44:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c47:	5b                   	pop    %ebx
  800c48:	5e                   	pop    %esi
  800c49:	5d                   	pop    %ebp
  800c4a:	c3                   	ret    

00800c4b <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c4b:	55                   	push   %ebp
  800c4c:	89 e5                	mov    %esp,%ebp
  800c4e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c51:	8d 45 10             	lea    0x10(%ebp),%eax
  800c54:	83 c0 04             	add    $0x4,%eax
  800c57:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c5a:	8b 45 10             	mov    0x10(%ebp),%eax
  800c5d:	ff 75 f4             	pushl  -0xc(%ebp)
  800c60:	50                   	push   %eax
  800c61:	ff 75 0c             	pushl  0xc(%ebp)
  800c64:	ff 75 08             	pushl  0x8(%ebp)
  800c67:	e8 04 fc ff ff       	call   800870 <vprintfmt>
  800c6c:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c6f:	90                   	nop
  800c70:	c9                   	leave  
  800c71:	c3                   	ret    

00800c72 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c72:	55                   	push   %ebp
  800c73:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c78:	8b 40 08             	mov    0x8(%eax),%eax
  800c7b:	8d 50 01             	lea    0x1(%eax),%edx
  800c7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c81:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c87:	8b 10                	mov    (%eax),%edx
  800c89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c8c:	8b 40 04             	mov    0x4(%eax),%eax
  800c8f:	39 c2                	cmp    %eax,%edx
  800c91:	73 12                	jae    800ca5 <sprintputch+0x33>
		*b->buf++ = ch;
  800c93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c96:	8b 00                	mov    (%eax),%eax
  800c98:	8d 48 01             	lea    0x1(%eax),%ecx
  800c9b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c9e:	89 0a                	mov    %ecx,(%edx)
  800ca0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca3:	88 10                	mov    %dl,(%eax)
}
  800ca5:	90                   	nop
  800ca6:	5d                   	pop    %ebp
  800ca7:	c3                   	ret    

00800ca8 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ca8:	55                   	push   %ebp
  800ca9:	89 e5                	mov    %esp,%ebp
  800cab:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800cae:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800cb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cba:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbd:	01 d0                	add    %edx,%eax
  800cbf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cc2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800cc9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ccd:	74 06                	je     800cd5 <vsnprintf+0x2d>
  800ccf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cd3:	7f 07                	jg     800cdc <vsnprintf+0x34>
		return -E_INVAL;
  800cd5:	b8 03 00 00 00       	mov    $0x3,%eax
  800cda:	eb 20                	jmp    800cfc <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800cdc:	ff 75 14             	pushl  0x14(%ebp)
  800cdf:	ff 75 10             	pushl  0x10(%ebp)
  800ce2:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ce5:	50                   	push   %eax
  800ce6:	68 72 0c 80 00       	push   $0x800c72
  800ceb:	e8 80 fb ff ff       	call   800870 <vprintfmt>
  800cf0:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800cf3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cf6:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800cf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800cfc:	c9                   	leave  
  800cfd:	c3                   	ret    

00800cfe <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800cfe:	55                   	push   %ebp
  800cff:	89 e5                	mov    %esp,%ebp
  800d01:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d04:	8d 45 10             	lea    0x10(%ebp),%eax
  800d07:	83 c0 04             	add    $0x4,%eax
  800d0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800d0d:	8b 45 10             	mov    0x10(%ebp),%eax
  800d10:	ff 75 f4             	pushl  -0xc(%ebp)
  800d13:	50                   	push   %eax
  800d14:	ff 75 0c             	pushl  0xc(%ebp)
  800d17:	ff 75 08             	pushl  0x8(%ebp)
  800d1a:	e8 89 ff ff ff       	call   800ca8 <vsnprintf>
  800d1f:	83 c4 10             	add    $0x10,%esp
  800d22:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800d25:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d28:	c9                   	leave  
  800d29:	c3                   	ret    

00800d2a <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  800d2a:	55                   	push   %ebp
  800d2b:	89 e5                	mov    %esp,%ebp
  800d2d:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  800d30:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d34:	74 13                	je     800d49 <readline+0x1f>
		cprintf("%s", prompt);
  800d36:	83 ec 08             	sub    $0x8,%esp
  800d39:	ff 75 08             	pushl  0x8(%ebp)
  800d3c:	68 48 28 80 00       	push   $0x802848
  800d41:	e8 0b f9 ff ff       	call   800651 <cprintf>
  800d46:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800d49:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800d50:	83 ec 0c             	sub    $0xc,%esp
  800d53:	6a 00                	push   $0x0
  800d55:	e8 7e 10 00 00       	call   801dd8 <iscons>
  800d5a:	83 c4 10             	add    $0x10,%esp
  800d5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800d60:	e8 60 10 00 00       	call   801dc5 <getchar>
  800d65:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800d68:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800d6c:	79 22                	jns    800d90 <readline+0x66>
			if (c != -E_EOF)
  800d6e:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800d72:	0f 84 ad 00 00 00    	je     800e25 <readline+0xfb>
				cprintf("read error: %e\n", c);
  800d78:	83 ec 08             	sub    $0x8,%esp
  800d7b:	ff 75 ec             	pushl  -0x14(%ebp)
  800d7e:	68 4b 28 80 00       	push   $0x80284b
  800d83:	e8 c9 f8 ff ff       	call   800651 <cprintf>
  800d88:	83 c4 10             	add    $0x10,%esp
			break;
  800d8b:	e9 95 00 00 00       	jmp    800e25 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800d90:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800d94:	7e 34                	jle    800dca <readline+0xa0>
  800d96:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800d9d:	7f 2b                	jg     800dca <readline+0xa0>
			if (echoing)
  800d9f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800da3:	74 0e                	je     800db3 <readline+0x89>
				cputchar(c);
  800da5:	83 ec 0c             	sub    $0xc,%esp
  800da8:	ff 75 ec             	pushl  -0x14(%ebp)
  800dab:	e8 f6 0f 00 00       	call   801da6 <cputchar>
  800db0:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800db3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800db6:	8d 50 01             	lea    0x1(%eax),%edx
  800db9:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800dbc:	89 c2                	mov    %eax,%edx
  800dbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc1:	01 d0                	add    %edx,%eax
  800dc3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800dc6:	88 10                	mov    %dl,(%eax)
  800dc8:	eb 56                	jmp    800e20 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  800dca:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800dce:	75 1f                	jne    800def <readline+0xc5>
  800dd0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800dd4:	7e 19                	jle    800def <readline+0xc5>
			if (echoing)
  800dd6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800dda:	74 0e                	je     800dea <readline+0xc0>
				cputchar(c);
  800ddc:	83 ec 0c             	sub    $0xc,%esp
  800ddf:	ff 75 ec             	pushl  -0x14(%ebp)
  800de2:	e8 bf 0f 00 00       	call   801da6 <cputchar>
  800de7:	83 c4 10             	add    $0x10,%esp

			i--;
  800dea:	ff 4d f4             	decl   -0xc(%ebp)
  800ded:	eb 31                	jmp    800e20 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800def:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800df3:	74 0a                	je     800dff <readline+0xd5>
  800df5:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800df9:	0f 85 61 ff ff ff    	jne    800d60 <readline+0x36>
			if (echoing)
  800dff:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800e03:	74 0e                	je     800e13 <readline+0xe9>
				cputchar(c);
  800e05:	83 ec 0c             	sub    $0xc,%esp
  800e08:	ff 75 ec             	pushl  -0x14(%ebp)
  800e0b:	e8 96 0f 00 00       	call   801da6 <cputchar>
  800e10:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800e13:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e16:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e19:	01 d0                	add    %edx,%eax
  800e1b:	c6 00 00             	movb   $0x0,(%eax)
			break;
  800e1e:	eb 06                	jmp    800e26 <readline+0xfc>
		}
	}
  800e20:	e9 3b ff ff ff       	jmp    800d60 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  800e25:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  800e26:	90                   	nop
  800e27:	c9                   	leave  
  800e28:	c3                   	ret    

00800e29 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800e29:	55                   	push   %ebp
  800e2a:	89 e5                	mov    %esp,%ebp
  800e2c:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  800e2f:	e8 79 09 00 00       	call   8017ad <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  800e34:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e38:	74 13                	je     800e4d <atomic_readline+0x24>
			cprintf("%s", prompt);
  800e3a:	83 ec 08             	sub    $0x8,%esp
  800e3d:	ff 75 08             	pushl  0x8(%ebp)
  800e40:	68 48 28 80 00       	push   $0x802848
  800e45:	e8 07 f8 ff ff       	call   800651 <cprintf>
  800e4a:	83 c4 10             	add    $0x10,%esp

		i = 0;
  800e4d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  800e54:	83 ec 0c             	sub    $0xc,%esp
  800e57:	6a 00                	push   $0x0
  800e59:	e8 7a 0f 00 00       	call   801dd8 <iscons>
  800e5e:	83 c4 10             	add    $0x10,%esp
  800e61:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  800e64:	e8 5c 0f 00 00       	call   801dc5 <getchar>
  800e69:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  800e6c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800e70:	79 22                	jns    800e94 <atomic_readline+0x6b>
				if (c != -E_EOF)
  800e72:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800e76:	0f 84 ad 00 00 00    	je     800f29 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  800e7c:	83 ec 08             	sub    $0x8,%esp
  800e7f:	ff 75 ec             	pushl  -0x14(%ebp)
  800e82:	68 4b 28 80 00       	push   $0x80284b
  800e87:	e8 c5 f7 ff ff       	call   800651 <cprintf>
  800e8c:	83 c4 10             	add    $0x10,%esp
				break;
  800e8f:	e9 95 00 00 00       	jmp    800f29 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  800e94:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800e98:	7e 34                	jle    800ece <atomic_readline+0xa5>
  800e9a:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800ea1:	7f 2b                	jg     800ece <atomic_readline+0xa5>
				if (echoing)
  800ea3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800ea7:	74 0e                	je     800eb7 <atomic_readline+0x8e>
					cputchar(c);
  800ea9:	83 ec 0c             	sub    $0xc,%esp
  800eac:	ff 75 ec             	pushl  -0x14(%ebp)
  800eaf:	e8 f2 0e 00 00       	call   801da6 <cputchar>
  800eb4:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  800eb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800eba:	8d 50 01             	lea    0x1(%eax),%edx
  800ebd:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800ec0:	89 c2                	mov    %eax,%edx
  800ec2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec5:	01 d0                	add    %edx,%eax
  800ec7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800eca:	88 10                	mov    %dl,(%eax)
  800ecc:	eb 56                	jmp    800f24 <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  800ece:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800ed2:	75 1f                	jne    800ef3 <atomic_readline+0xca>
  800ed4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800ed8:	7e 19                	jle    800ef3 <atomic_readline+0xca>
				if (echoing)
  800eda:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800ede:	74 0e                	je     800eee <atomic_readline+0xc5>
					cputchar(c);
  800ee0:	83 ec 0c             	sub    $0xc,%esp
  800ee3:	ff 75 ec             	pushl  -0x14(%ebp)
  800ee6:	e8 bb 0e 00 00       	call   801da6 <cputchar>
  800eeb:	83 c4 10             	add    $0x10,%esp
				i--;
  800eee:	ff 4d f4             	decl   -0xc(%ebp)
  800ef1:	eb 31                	jmp    800f24 <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  800ef3:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800ef7:	74 0a                	je     800f03 <atomic_readline+0xda>
  800ef9:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800efd:	0f 85 61 ff ff ff    	jne    800e64 <atomic_readline+0x3b>
				if (echoing)
  800f03:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800f07:	74 0e                	je     800f17 <atomic_readline+0xee>
					cputchar(c);
  800f09:	83 ec 0c             	sub    $0xc,%esp
  800f0c:	ff 75 ec             	pushl  -0x14(%ebp)
  800f0f:	e8 92 0e 00 00       	call   801da6 <cputchar>
  800f14:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  800f17:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f1d:	01 d0                	add    %edx,%eax
  800f1f:	c6 00 00             	movb   $0x0,(%eax)
				break;
  800f22:	eb 06                	jmp    800f2a <atomic_readline+0x101>
			}
		}
  800f24:	e9 3b ff ff ff       	jmp    800e64 <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  800f29:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  800f2a:	e8 98 08 00 00       	call   8017c7 <sys_unlock_cons>
}
  800f2f:	90                   	nop
  800f30:	c9                   	leave  
  800f31:	c3                   	ret    

00800f32 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800f32:	55                   	push   %ebp
  800f33:	89 e5                	mov    %esp,%ebp
  800f35:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800f38:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f3f:	eb 06                	jmp    800f47 <strlen+0x15>
		n++;
  800f41:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800f44:	ff 45 08             	incl   0x8(%ebp)
  800f47:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4a:	8a 00                	mov    (%eax),%al
  800f4c:	84 c0                	test   %al,%al
  800f4e:	75 f1                	jne    800f41 <strlen+0xf>
		n++;
	return n;
  800f50:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f53:	c9                   	leave  
  800f54:	c3                   	ret    

00800f55 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800f55:	55                   	push   %ebp
  800f56:	89 e5                	mov    %esp,%ebp
  800f58:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f5b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f62:	eb 09                	jmp    800f6d <strnlen+0x18>
		n++;
  800f64:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f67:	ff 45 08             	incl   0x8(%ebp)
  800f6a:	ff 4d 0c             	decl   0xc(%ebp)
  800f6d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f71:	74 09                	je     800f7c <strnlen+0x27>
  800f73:	8b 45 08             	mov    0x8(%ebp),%eax
  800f76:	8a 00                	mov    (%eax),%al
  800f78:	84 c0                	test   %al,%al
  800f7a:	75 e8                	jne    800f64 <strnlen+0xf>
		n++;
	return n;
  800f7c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f7f:	c9                   	leave  
  800f80:	c3                   	ret    

00800f81 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800f81:	55                   	push   %ebp
  800f82:	89 e5                	mov    %esp,%ebp
  800f84:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800f87:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800f8d:	90                   	nop
  800f8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f91:	8d 50 01             	lea    0x1(%eax),%edx
  800f94:	89 55 08             	mov    %edx,0x8(%ebp)
  800f97:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f9a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f9d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800fa0:	8a 12                	mov    (%edx),%dl
  800fa2:	88 10                	mov    %dl,(%eax)
  800fa4:	8a 00                	mov    (%eax),%al
  800fa6:	84 c0                	test   %al,%al
  800fa8:	75 e4                	jne    800f8e <strcpy+0xd>
		/* do nothing */;
	return ret;
  800faa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800fad:	c9                   	leave  
  800fae:	c3                   	ret    

00800faf <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800faf:	55                   	push   %ebp
  800fb0:	89 e5                	mov    %esp,%ebp
  800fb2:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800fbb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800fc2:	eb 1f                	jmp    800fe3 <strncpy+0x34>
		*dst++ = *src;
  800fc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc7:	8d 50 01             	lea    0x1(%eax),%edx
  800fca:	89 55 08             	mov    %edx,0x8(%ebp)
  800fcd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fd0:	8a 12                	mov    (%edx),%dl
  800fd2:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800fd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd7:	8a 00                	mov    (%eax),%al
  800fd9:	84 c0                	test   %al,%al
  800fdb:	74 03                	je     800fe0 <strncpy+0x31>
			src++;
  800fdd:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800fe0:	ff 45 fc             	incl   -0x4(%ebp)
  800fe3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fe6:	3b 45 10             	cmp    0x10(%ebp),%eax
  800fe9:	72 d9                	jb     800fc4 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800feb:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800fee:	c9                   	leave  
  800fef:	c3                   	ret    

00800ff0 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800ff0:	55                   	push   %ebp
  800ff1:	89 e5                	mov    %esp,%ebp
  800ff3:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ff6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ffc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801000:	74 30                	je     801032 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801002:	eb 16                	jmp    80101a <strlcpy+0x2a>
			*dst++ = *src++;
  801004:	8b 45 08             	mov    0x8(%ebp),%eax
  801007:	8d 50 01             	lea    0x1(%eax),%edx
  80100a:	89 55 08             	mov    %edx,0x8(%ebp)
  80100d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801010:	8d 4a 01             	lea    0x1(%edx),%ecx
  801013:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801016:	8a 12                	mov    (%edx),%dl
  801018:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80101a:	ff 4d 10             	decl   0x10(%ebp)
  80101d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801021:	74 09                	je     80102c <strlcpy+0x3c>
  801023:	8b 45 0c             	mov    0xc(%ebp),%eax
  801026:	8a 00                	mov    (%eax),%al
  801028:	84 c0                	test   %al,%al
  80102a:	75 d8                	jne    801004 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80102c:	8b 45 08             	mov    0x8(%ebp),%eax
  80102f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801032:	8b 55 08             	mov    0x8(%ebp),%edx
  801035:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801038:	29 c2                	sub    %eax,%edx
  80103a:	89 d0                	mov    %edx,%eax
}
  80103c:	c9                   	leave  
  80103d:	c3                   	ret    

0080103e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80103e:	55                   	push   %ebp
  80103f:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801041:	eb 06                	jmp    801049 <strcmp+0xb>
		p++, q++;
  801043:	ff 45 08             	incl   0x8(%ebp)
  801046:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801049:	8b 45 08             	mov    0x8(%ebp),%eax
  80104c:	8a 00                	mov    (%eax),%al
  80104e:	84 c0                	test   %al,%al
  801050:	74 0e                	je     801060 <strcmp+0x22>
  801052:	8b 45 08             	mov    0x8(%ebp),%eax
  801055:	8a 10                	mov    (%eax),%dl
  801057:	8b 45 0c             	mov    0xc(%ebp),%eax
  80105a:	8a 00                	mov    (%eax),%al
  80105c:	38 c2                	cmp    %al,%dl
  80105e:	74 e3                	je     801043 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801060:	8b 45 08             	mov    0x8(%ebp),%eax
  801063:	8a 00                	mov    (%eax),%al
  801065:	0f b6 d0             	movzbl %al,%edx
  801068:	8b 45 0c             	mov    0xc(%ebp),%eax
  80106b:	8a 00                	mov    (%eax),%al
  80106d:	0f b6 c0             	movzbl %al,%eax
  801070:	29 c2                	sub    %eax,%edx
  801072:	89 d0                	mov    %edx,%eax
}
  801074:	5d                   	pop    %ebp
  801075:	c3                   	ret    

00801076 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801076:	55                   	push   %ebp
  801077:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801079:	eb 09                	jmp    801084 <strncmp+0xe>
		n--, p++, q++;
  80107b:	ff 4d 10             	decl   0x10(%ebp)
  80107e:	ff 45 08             	incl   0x8(%ebp)
  801081:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801084:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801088:	74 17                	je     8010a1 <strncmp+0x2b>
  80108a:	8b 45 08             	mov    0x8(%ebp),%eax
  80108d:	8a 00                	mov    (%eax),%al
  80108f:	84 c0                	test   %al,%al
  801091:	74 0e                	je     8010a1 <strncmp+0x2b>
  801093:	8b 45 08             	mov    0x8(%ebp),%eax
  801096:	8a 10                	mov    (%eax),%dl
  801098:	8b 45 0c             	mov    0xc(%ebp),%eax
  80109b:	8a 00                	mov    (%eax),%al
  80109d:	38 c2                	cmp    %al,%dl
  80109f:	74 da                	je     80107b <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8010a1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010a5:	75 07                	jne    8010ae <strncmp+0x38>
		return 0;
  8010a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8010ac:	eb 14                	jmp    8010c2 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8010ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b1:	8a 00                	mov    (%eax),%al
  8010b3:	0f b6 d0             	movzbl %al,%edx
  8010b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b9:	8a 00                	mov    (%eax),%al
  8010bb:	0f b6 c0             	movzbl %al,%eax
  8010be:	29 c2                	sub    %eax,%edx
  8010c0:	89 d0                	mov    %edx,%eax
}
  8010c2:	5d                   	pop    %ebp
  8010c3:	c3                   	ret    

008010c4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8010c4:	55                   	push   %ebp
  8010c5:	89 e5                	mov    %esp,%ebp
  8010c7:	83 ec 04             	sub    $0x4,%esp
  8010ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010cd:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8010d0:	eb 12                	jmp    8010e4 <strchr+0x20>
		if (*s == c)
  8010d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d5:	8a 00                	mov    (%eax),%al
  8010d7:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8010da:	75 05                	jne    8010e1 <strchr+0x1d>
			return (char *) s;
  8010dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010df:	eb 11                	jmp    8010f2 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8010e1:	ff 45 08             	incl   0x8(%ebp)
  8010e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e7:	8a 00                	mov    (%eax),%al
  8010e9:	84 c0                	test   %al,%al
  8010eb:	75 e5                	jne    8010d2 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8010ed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010f2:	c9                   	leave  
  8010f3:	c3                   	ret    

008010f4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8010f4:	55                   	push   %ebp
  8010f5:	89 e5                	mov    %esp,%ebp
  8010f7:	83 ec 04             	sub    $0x4,%esp
  8010fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010fd:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801100:	eb 0d                	jmp    80110f <strfind+0x1b>
		if (*s == c)
  801102:	8b 45 08             	mov    0x8(%ebp),%eax
  801105:	8a 00                	mov    (%eax),%al
  801107:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80110a:	74 0e                	je     80111a <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80110c:	ff 45 08             	incl   0x8(%ebp)
  80110f:	8b 45 08             	mov    0x8(%ebp),%eax
  801112:	8a 00                	mov    (%eax),%al
  801114:	84 c0                	test   %al,%al
  801116:	75 ea                	jne    801102 <strfind+0xe>
  801118:	eb 01                	jmp    80111b <strfind+0x27>
		if (*s == c)
			break;
  80111a:	90                   	nop
	return (char *) s;
  80111b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80111e:	c9                   	leave  
  80111f:	c3                   	ret    

00801120 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801120:	55                   	push   %ebp
  801121:	89 e5                	mov    %esp,%ebp
  801123:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801126:	8b 45 08             	mov    0x8(%ebp),%eax
  801129:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  80112c:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801130:	76 63                	jbe    801195 <memset+0x75>
		uint64 data_block = c;
  801132:	8b 45 0c             	mov    0xc(%ebp),%eax
  801135:	99                   	cltd   
  801136:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801139:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  80113c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80113f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801142:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801146:	c1 e0 08             	shl    $0x8,%eax
  801149:	09 45 f0             	or     %eax,-0x10(%ebp)
  80114c:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  80114f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801152:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801155:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801159:	c1 e0 10             	shl    $0x10,%eax
  80115c:	09 45 f0             	or     %eax,-0x10(%ebp)
  80115f:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801162:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801165:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801168:	89 c2                	mov    %eax,%edx
  80116a:	b8 00 00 00 00       	mov    $0x0,%eax
  80116f:	09 45 f0             	or     %eax,-0x10(%ebp)
  801172:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801175:	eb 18                	jmp    80118f <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801177:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80117a:	8d 41 08             	lea    0x8(%ecx),%eax
  80117d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801180:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801183:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801186:	89 01                	mov    %eax,(%ecx)
  801188:	89 51 04             	mov    %edx,0x4(%ecx)
  80118b:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  80118f:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801193:	77 e2                	ja     801177 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801195:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801199:	74 23                	je     8011be <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  80119b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80119e:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8011a1:	eb 0e                	jmp    8011b1 <memset+0x91>
			*p8++ = (uint8)c;
  8011a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011a6:	8d 50 01             	lea    0x1(%eax),%edx
  8011a9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011af:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8011b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011b7:	89 55 10             	mov    %edx,0x10(%ebp)
  8011ba:	85 c0                	test   %eax,%eax
  8011bc:	75 e5                	jne    8011a3 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8011be:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011c1:	c9                   	leave  
  8011c2:	c3                   	ret    

008011c3 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8011c3:	55                   	push   %ebp
  8011c4:	89 e5                	mov    %esp,%ebp
  8011c6:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8011c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8011cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8011d5:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8011d9:	76 24                	jbe    8011ff <memcpy+0x3c>
		while(n >= 8){
  8011db:	eb 1c                	jmp    8011f9 <memcpy+0x36>
			*d64 = *s64;
  8011dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011e0:	8b 50 04             	mov    0x4(%eax),%edx
  8011e3:	8b 00                	mov    (%eax),%eax
  8011e5:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011e8:	89 01                	mov    %eax,(%ecx)
  8011ea:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8011ed:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8011f1:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8011f5:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8011f9:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8011fd:	77 de                	ja     8011dd <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8011ff:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801203:	74 31                	je     801236 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801205:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801208:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  80120b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80120e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801211:	eb 16                	jmp    801229 <memcpy+0x66>
			*d8++ = *s8++;
  801213:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801216:	8d 50 01             	lea    0x1(%eax),%edx
  801219:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80121c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80121f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801222:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801225:	8a 12                	mov    (%edx),%dl
  801227:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801229:	8b 45 10             	mov    0x10(%ebp),%eax
  80122c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80122f:	89 55 10             	mov    %edx,0x10(%ebp)
  801232:	85 c0                	test   %eax,%eax
  801234:	75 dd                	jne    801213 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801236:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801239:	c9                   	leave  
  80123a:	c3                   	ret    

0080123b <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80123b:	55                   	push   %ebp
  80123c:	89 e5                	mov    %esp,%ebp
  80123e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801241:	8b 45 0c             	mov    0xc(%ebp),%eax
  801244:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801247:	8b 45 08             	mov    0x8(%ebp),%eax
  80124a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80124d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801250:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801253:	73 50                	jae    8012a5 <memmove+0x6a>
  801255:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801258:	8b 45 10             	mov    0x10(%ebp),%eax
  80125b:	01 d0                	add    %edx,%eax
  80125d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801260:	76 43                	jbe    8012a5 <memmove+0x6a>
		s += n;
  801262:	8b 45 10             	mov    0x10(%ebp),%eax
  801265:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801268:	8b 45 10             	mov    0x10(%ebp),%eax
  80126b:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80126e:	eb 10                	jmp    801280 <memmove+0x45>
			*--d = *--s;
  801270:	ff 4d f8             	decl   -0x8(%ebp)
  801273:	ff 4d fc             	decl   -0x4(%ebp)
  801276:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801279:	8a 10                	mov    (%eax),%dl
  80127b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80127e:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801280:	8b 45 10             	mov    0x10(%ebp),%eax
  801283:	8d 50 ff             	lea    -0x1(%eax),%edx
  801286:	89 55 10             	mov    %edx,0x10(%ebp)
  801289:	85 c0                	test   %eax,%eax
  80128b:	75 e3                	jne    801270 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80128d:	eb 23                	jmp    8012b2 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80128f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801292:	8d 50 01             	lea    0x1(%eax),%edx
  801295:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801298:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80129b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80129e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8012a1:	8a 12                	mov    (%edx),%dl
  8012a3:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8012a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012ab:	89 55 10             	mov    %edx,0x10(%ebp)
  8012ae:	85 c0                	test   %eax,%eax
  8012b0:	75 dd                	jne    80128f <memmove+0x54>
			*d++ = *s++;

	return dst;
  8012b2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012b5:	c9                   	leave  
  8012b6:	c3                   	ret    

008012b7 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8012b7:	55                   	push   %ebp
  8012b8:	89 e5                	mov    %esp,%ebp
  8012ba:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8012bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8012c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c6:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8012c9:	eb 2a                	jmp    8012f5 <memcmp+0x3e>
		if (*s1 != *s2)
  8012cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012ce:	8a 10                	mov    (%eax),%dl
  8012d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012d3:	8a 00                	mov    (%eax),%al
  8012d5:	38 c2                	cmp    %al,%dl
  8012d7:	74 16                	je     8012ef <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8012d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012dc:	8a 00                	mov    (%eax),%al
  8012de:	0f b6 d0             	movzbl %al,%edx
  8012e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012e4:	8a 00                	mov    (%eax),%al
  8012e6:	0f b6 c0             	movzbl %al,%eax
  8012e9:	29 c2                	sub    %eax,%edx
  8012eb:	89 d0                	mov    %edx,%eax
  8012ed:	eb 18                	jmp    801307 <memcmp+0x50>
		s1++, s2++;
  8012ef:	ff 45 fc             	incl   -0x4(%ebp)
  8012f2:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8012f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012fb:	89 55 10             	mov    %edx,0x10(%ebp)
  8012fe:	85 c0                	test   %eax,%eax
  801300:	75 c9                	jne    8012cb <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801302:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801307:	c9                   	leave  
  801308:	c3                   	ret    

00801309 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801309:	55                   	push   %ebp
  80130a:	89 e5                	mov    %esp,%ebp
  80130c:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80130f:	8b 55 08             	mov    0x8(%ebp),%edx
  801312:	8b 45 10             	mov    0x10(%ebp),%eax
  801315:	01 d0                	add    %edx,%eax
  801317:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80131a:	eb 15                	jmp    801331 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80131c:	8b 45 08             	mov    0x8(%ebp),%eax
  80131f:	8a 00                	mov    (%eax),%al
  801321:	0f b6 d0             	movzbl %al,%edx
  801324:	8b 45 0c             	mov    0xc(%ebp),%eax
  801327:	0f b6 c0             	movzbl %al,%eax
  80132a:	39 c2                	cmp    %eax,%edx
  80132c:	74 0d                	je     80133b <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80132e:	ff 45 08             	incl   0x8(%ebp)
  801331:	8b 45 08             	mov    0x8(%ebp),%eax
  801334:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801337:	72 e3                	jb     80131c <memfind+0x13>
  801339:	eb 01                	jmp    80133c <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80133b:	90                   	nop
	return (void *) s;
  80133c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80133f:	c9                   	leave  
  801340:	c3                   	ret    

00801341 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801341:	55                   	push   %ebp
  801342:	89 e5                	mov    %esp,%ebp
  801344:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801347:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80134e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801355:	eb 03                	jmp    80135a <strtol+0x19>
		s++;
  801357:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80135a:	8b 45 08             	mov    0x8(%ebp),%eax
  80135d:	8a 00                	mov    (%eax),%al
  80135f:	3c 20                	cmp    $0x20,%al
  801361:	74 f4                	je     801357 <strtol+0x16>
  801363:	8b 45 08             	mov    0x8(%ebp),%eax
  801366:	8a 00                	mov    (%eax),%al
  801368:	3c 09                	cmp    $0x9,%al
  80136a:	74 eb                	je     801357 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80136c:	8b 45 08             	mov    0x8(%ebp),%eax
  80136f:	8a 00                	mov    (%eax),%al
  801371:	3c 2b                	cmp    $0x2b,%al
  801373:	75 05                	jne    80137a <strtol+0x39>
		s++;
  801375:	ff 45 08             	incl   0x8(%ebp)
  801378:	eb 13                	jmp    80138d <strtol+0x4c>
	else if (*s == '-')
  80137a:	8b 45 08             	mov    0x8(%ebp),%eax
  80137d:	8a 00                	mov    (%eax),%al
  80137f:	3c 2d                	cmp    $0x2d,%al
  801381:	75 0a                	jne    80138d <strtol+0x4c>
		s++, neg = 1;
  801383:	ff 45 08             	incl   0x8(%ebp)
  801386:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80138d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801391:	74 06                	je     801399 <strtol+0x58>
  801393:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801397:	75 20                	jne    8013b9 <strtol+0x78>
  801399:	8b 45 08             	mov    0x8(%ebp),%eax
  80139c:	8a 00                	mov    (%eax),%al
  80139e:	3c 30                	cmp    $0x30,%al
  8013a0:	75 17                	jne    8013b9 <strtol+0x78>
  8013a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a5:	40                   	inc    %eax
  8013a6:	8a 00                	mov    (%eax),%al
  8013a8:	3c 78                	cmp    $0x78,%al
  8013aa:	75 0d                	jne    8013b9 <strtol+0x78>
		s += 2, base = 16;
  8013ac:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8013b0:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8013b7:	eb 28                	jmp    8013e1 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8013b9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013bd:	75 15                	jne    8013d4 <strtol+0x93>
  8013bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c2:	8a 00                	mov    (%eax),%al
  8013c4:	3c 30                	cmp    $0x30,%al
  8013c6:	75 0c                	jne    8013d4 <strtol+0x93>
		s++, base = 8;
  8013c8:	ff 45 08             	incl   0x8(%ebp)
  8013cb:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8013d2:	eb 0d                	jmp    8013e1 <strtol+0xa0>
	else if (base == 0)
  8013d4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013d8:	75 07                	jne    8013e1 <strtol+0xa0>
		base = 10;
  8013da:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8013e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e4:	8a 00                	mov    (%eax),%al
  8013e6:	3c 2f                	cmp    $0x2f,%al
  8013e8:	7e 19                	jle    801403 <strtol+0xc2>
  8013ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ed:	8a 00                	mov    (%eax),%al
  8013ef:	3c 39                	cmp    $0x39,%al
  8013f1:	7f 10                	jg     801403 <strtol+0xc2>
			dig = *s - '0';
  8013f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f6:	8a 00                	mov    (%eax),%al
  8013f8:	0f be c0             	movsbl %al,%eax
  8013fb:	83 e8 30             	sub    $0x30,%eax
  8013fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801401:	eb 42                	jmp    801445 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801403:	8b 45 08             	mov    0x8(%ebp),%eax
  801406:	8a 00                	mov    (%eax),%al
  801408:	3c 60                	cmp    $0x60,%al
  80140a:	7e 19                	jle    801425 <strtol+0xe4>
  80140c:	8b 45 08             	mov    0x8(%ebp),%eax
  80140f:	8a 00                	mov    (%eax),%al
  801411:	3c 7a                	cmp    $0x7a,%al
  801413:	7f 10                	jg     801425 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801415:	8b 45 08             	mov    0x8(%ebp),%eax
  801418:	8a 00                	mov    (%eax),%al
  80141a:	0f be c0             	movsbl %al,%eax
  80141d:	83 e8 57             	sub    $0x57,%eax
  801420:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801423:	eb 20                	jmp    801445 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801425:	8b 45 08             	mov    0x8(%ebp),%eax
  801428:	8a 00                	mov    (%eax),%al
  80142a:	3c 40                	cmp    $0x40,%al
  80142c:	7e 39                	jle    801467 <strtol+0x126>
  80142e:	8b 45 08             	mov    0x8(%ebp),%eax
  801431:	8a 00                	mov    (%eax),%al
  801433:	3c 5a                	cmp    $0x5a,%al
  801435:	7f 30                	jg     801467 <strtol+0x126>
			dig = *s - 'A' + 10;
  801437:	8b 45 08             	mov    0x8(%ebp),%eax
  80143a:	8a 00                	mov    (%eax),%al
  80143c:	0f be c0             	movsbl %al,%eax
  80143f:	83 e8 37             	sub    $0x37,%eax
  801442:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801445:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801448:	3b 45 10             	cmp    0x10(%ebp),%eax
  80144b:	7d 19                	jge    801466 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80144d:	ff 45 08             	incl   0x8(%ebp)
  801450:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801453:	0f af 45 10          	imul   0x10(%ebp),%eax
  801457:	89 c2                	mov    %eax,%edx
  801459:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80145c:	01 d0                	add    %edx,%eax
  80145e:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801461:	e9 7b ff ff ff       	jmp    8013e1 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801466:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801467:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80146b:	74 08                	je     801475 <strtol+0x134>
		*endptr = (char *) s;
  80146d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801470:	8b 55 08             	mov    0x8(%ebp),%edx
  801473:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801475:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801479:	74 07                	je     801482 <strtol+0x141>
  80147b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80147e:	f7 d8                	neg    %eax
  801480:	eb 03                	jmp    801485 <strtol+0x144>
  801482:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801485:	c9                   	leave  
  801486:	c3                   	ret    

00801487 <ltostr>:

void
ltostr(long value, char *str)
{
  801487:	55                   	push   %ebp
  801488:	89 e5                	mov    %esp,%ebp
  80148a:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80148d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801494:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80149b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80149f:	79 13                	jns    8014b4 <ltostr+0x2d>
	{
		neg = 1;
  8014a1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8014a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ab:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8014ae:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8014b1:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8014b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b7:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8014bc:	99                   	cltd   
  8014bd:	f7 f9                	idiv   %ecx
  8014bf:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8014c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014c5:	8d 50 01             	lea    0x1(%eax),%edx
  8014c8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014cb:	89 c2                	mov    %eax,%edx
  8014cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d0:	01 d0                	add    %edx,%eax
  8014d2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8014d5:	83 c2 30             	add    $0x30,%edx
  8014d8:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8014da:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014dd:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8014e2:	f7 e9                	imul   %ecx
  8014e4:	c1 fa 02             	sar    $0x2,%edx
  8014e7:	89 c8                	mov    %ecx,%eax
  8014e9:	c1 f8 1f             	sar    $0x1f,%eax
  8014ec:	29 c2                	sub    %eax,%edx
  8014ee:	89 d0                	mov    %edx,%eax
  8014f0:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8014f3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014f7:	75 bb                	jne    8014b4 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8014f9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801500:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801503:	48                   	dec    %eax
  801504:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801507:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80150b:	74 3d                	je     80154a <ltostr+0xc3>
		start = 1 ;
  80150d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801514:	eb 34                	jmp    80154a <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801516:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801519:	8b 45 0c             	mov    0xc(%ebp),%eax
  80151c:	01 d0                	add    %edx,%eax
  80151e:	8a 00                	mov    (%eax),%al
  801520:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801523:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801526:	8b 45 0c             	mov    0xc(%ebp),%eax
  801529:	01 c2                	add    %eax,%edx
  80152b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80152e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801531:	01 c8                	add    %ecx,%eax
  801533:	8a 00                	mov    (%eax),%al
  801535:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801537:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80153a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80153d:	01 c2                	add    %eax,%edx
  80153f:	8a 45 eb             	mov    -0x15(%ebp),%al
  801542:	88 02                	mov    %al,(%edx)
		start++ ;
  801544:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801547:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80154a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80154d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801550:	7c c4                	jl     801516 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801552:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801555:	8b 45 0c             	mov    0xc(%ebp),%eax
  801558:	01 d0                	add    %edx,%eax
  80155a:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80155d:	90                   	nop
  80155e:	c9                   	leave  
  80155f:	c3                   	ret    

00801560 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801560:	55                   	push   %ebp
  801561:	89 e5                	mov    %esp,%ebp
  801563:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801566:	ff 75 08             	pushl  0x8(%ebp)
  801569:	e8 c4 f9 ff ff       	call   800f32 <strlen>
  80156e:	83 c4 04             	add    $0x4,%esp
  801571:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801574:	ff 75 0c             	pushl  0xc(%ebp)
  801577:	e8 b6 f9 ff ff       	call   800f32 <strlen>
  80157c:	83 c4 04             	add    $0x4,%esp
  80157f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801582:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801589:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801590:	eb 17                	jmp    8015a9 <strcconcat+0x49>
		final[s] = str1[s] ;
  801592:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801595:	8b 45 10             	mov    0x10(%ebp),%eax
  801598:	01 c2                	add    %eax,%edx
  80159a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80159d:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a0:	01 c8                	add    %ecx,%eax
  8015a2:	8a 00                	mov    (%eax),%al
  8015a4:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8015a6:	ff 45 fc             	incl   -0x4(%ebp)
  8015a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015ac:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8015af:	7c e1                	jl     801592 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8015b1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8015b8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8015bf:	eb 1f                	jmp    8015e0 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8015c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015c4:	8d 50 01             	lea    0x1(%eax),%edx
  8015c7:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8015ca:	89 c2                	mov    %eax,%edx
  8015cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8015cf:	01 c2                	add    %eax,%edx
  8015d1:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8015d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d7:	01 c8                	add    %ecx,%eax
  8015d9:	8a 00                	mov    (%eax),%al
  8015db:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8015dd:	ff 45 f8             	incl   -0x8(%ebp)
  8015e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015e3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8015e6:	7c d9                	jl     8015c1 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8015e8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8015ee:	01 d0                	add    %edx,%eax
  8015f0:	c6 00 00             	movb   $0x0,(%eax)
}
  8015f3:	90                   	nop
  8015f4:	c9                   	leave  
  8015f5:	c3                   	ret    

008015f6 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8015f6:	55                   	push   %ebp
  8015f7:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8015f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8015fc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801602:	8b 45 14             	mov    0x14(%ebp),%eax
  801605:	8b 00                	mov    (%eax),%eax
  801607:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80160e:	8b 45 10             	mov    0x10(%ebp),%eax
  801611:	01 d0                	add    %edx,%eax
  801613:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801619:	eb 0c                	jmp    801627 <strsplit+0x31>
			*string++ = 0;
  80161b:	8b 45 08             	mov    0x8(%ebp),%eax
  80161e:	8d 50 01             	lea    0x1(%eax),%edx
  801621:	89 55 08             	mov    %edx,0x8(%ebp)
  801624:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801627:	8b 45 08             	mov    0x8(%ebp),%eax
  80162a:	8a 00                	mov    (%eax),%al
  80162c:	84 c0                	test   %al,%al
  80162e:	74 18                	je     801648 <strsplit+0x52>
  801630:	8b 45 08             	mov    0x8(%ebp),%eax
  801633:	8a 00                	mov    (%eax),%al
  801635:	0f be c0             	movsbl %al,%eax
  801638:	50                   	push   %eax
  801639:	ff 75 0c             	pushl  0xc(%ebp)
  80163c:	e8 83 fa ff ff       	call   8010c4 <strchr>
  801641:	83 c4 08             	add    $0x8,%esp
  801644:	85 c0                	test   %eax,%eax
  801646:	75 d3                	jne    80161b <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801648:	8b 45 08             	mov    0x8(%ebp),%eax
  80164b:	8a 00                	mov    (%eax),%al
  80164d:	84 c0                	test   %al,%al
  80164f:	74 5a                	je     8016ab <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801651:	8b 45 14             	mov    0x14(%ebp),%eax
  801654:	8b 00                	mov    (%eax),%eax
  801656:	83 f8 0f             	cmp    $0xf,%eax
  801659:	75 07                	jne    801662 <strsplit+0x6c>
		{
			return 0;
  80165b:	b8 00 00 00 00       	mov    $0x0,%eax
  801660:	eb 66                	jmp    8016c8 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801662:	8b 45 14             	mov    0x14(%ebp),%eax
  801665:	8b 00                	mov    (%eax),%eax
  801667:	8d 48 01             	lea    0x1(%eax),%ecx
  80166a:	8b 55 14             	mov    0x14(%ebp),%edx
  80166d:	89 0a                	mov    %ecx,(%edx)
  80166f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801676:	8b 45 10             	mov    0x10(%ebp),%eax
  801679:	01 c2                	add    %eax,%edx
  80167b:	8b 45 08             	mov    0x8(%ebp),%eax
  80167e:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801680:	eb 03                	jmp    801685 <strsplit+0x8f>
			string++;
  801682:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801685:	8b 45 08             	mov    0x8(%ebp),%eax
  801688:	8a 00                	mov    (%eax),%al
  80168a:	84 c0                	test   %al,%al
  80168c:	74 8b                	je     801619 <strsplit+0x23>
  80168e:	8b 45 08             	mov    0x8(%ebp),%eax
  801691:	8a 00                	mov    (%eax),%al
  801693:	0f be c0             	movsbl %al,%eax
  801696:	50                   	push   %eax
  801697:	ff 75 0c             	pushl  0xc(%ebp)
  80169a:	e8 25 fa ff ff       	call   8010c4 <strchr>
  80169f:	83 c4 08             	add    $0x8,%esp
  8016a2:	85 c0                	test   %eax,%eax
  8016a4:	74 dc                	je     801682 <strsplit+0x8c>
			string++;
	}
  8016a6:	e9 6e ff ff ff       	jmp    801619 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8016ab:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8016ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8016af:	8b 00                	mov    (%eax),%eax
  8016b1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8016bb:	01 d0                	add    %edx,%eax
  8016bd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8016c3:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8016c8:	c9                   	leave  
  8016c9:	c3                   	ret    

008016ca <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8016ca:	55                   	push   %ebp
  8016cb:	89 e5                	mov    %esp,%ebp
  8016cd:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8016d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8016d6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8016dd:	eb 4a                	jmp    801729 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8016df:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e5:	01 c2                	add    %eax,%edx
  8016e7:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8016ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016ed:	01 c8                	add    %ecx,%eax
  8016ef:	8a 00                	mov    (%eax),%al
  8016f1:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8016f3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f9:	01 d0                	add    %edx,%eax
  8016fb:	8a 00                	mov    (%eax),%al
  8016fd:	3c 40                	cmp    $0x40,%al
  8016ff:	7e 25                	jle    801726 <str2lower+0x5c>
  801701:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801704:	8b 45 0c             	mov    0xc(%ebp),%eax
  801707:	01 d0                	add    %edx,%eax
  801709:	8a 00                	mov    (%eax),%al
  80170b:	3c 5a                	cmp    $0x5a,%al
  80170d:	7f 17                	jg     801726 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  80170f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801712:	8b 45 08             	mov    0x8(%ebp),%eax
  801715:	01 d0                	add    %edx,%eax
  801717:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80171a:	8b 55 08             	mov    0x8(%ebp),%edx
  80171d:	01 ca                	add    %ecx,%edx
  80171f:	8a 12                	mov    (%edx),%dl
  801721:	83 c2 20             	add    $0x20,%edx
  801724:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801726:	ff 45 fc             	incl   -0x4(%ebp)
  801729:	ff 75 0c             	pushl  0xc(%ebp)
  80172c:	e8 01 f8 ff ff       	call   800f32 <strlen>
  801731:	83 c4 04             	add    $0x4,%esp
  801734:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801737:	7f a6                	jg     8016df <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801739:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80173c:	c9                   	leave  
  80173d:	c3                   	ret    

0080173e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80173e:	55                   	push   %ebp
  80173f:	89 e5                	mov    %esp,%ebp
  801741:	57                   	push   %edi
  801742:	56                   	push   %esi
  801743:	53                   	push   %ebx
  801744:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801747:	8b 45 08             	mov    0x8(%ebp),%eax
  80174a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80174d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801750:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801753:	8b 7d 18             	mov    0x18(%ebp),%edi
  801756:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801759:	cd 30                	int    $0x30
  80175b:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  80175e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801761:	83 c4 10             	add    $0x10,%esp
  801764:	5b                   	pop    %ebx
  801765:	5e                   	pop    %esi
  801766:	5f                   	pop    %edi
  801767:	5d                   	pop    %ebp
  801768:	c3                   	ret    

00801769 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801769:	55                   	push   %ebp
  80176a:	89 e5                	mov    %esp,%ebp
  80176c:	83 ec 04             	sub    $0x4,%esp
  80176f:	8b 45 10             	mov    0x10(%ebp),%eax
  801772:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801775:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801778:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80177c:	8b 45 08             	mov    0x8(%ebp),%eax
  80177f:	6a 00                	push   $0x0
  801781:	51                   	push   %ecx
  801782:	52                   	push   %edx
  801783:	ff 75 0c             	pushl  0xc(%ebp)
  801786:	50                   	push   %eax
  801787:	6a 00                	push   $0x0
  801789:	e8 b0 ff ff ff       	call   80173e <syscall>
  80178e:	83 c4 18             	add    $0x18,%esp
}
  801791:	90                   	nop
  801792:	c9                   	leave  
  801793:	c3                   	ret    

00801794 <sys_cgetc>:

int
sys_cgetc(void)
{
  801794:	55                   	push   %ebp
  801795:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801797:	6a 00                	push   $0x0
  801799:	6a 00                	push   $0x0
  80179b:	6a 00                	push   $0x0
  80179d:	6a 00                	push   $0x0
  80179f:	6a 00                	push   $0x0
  8017a1:	6a 02                	push   $0x2
  8017a3:	e8 96 ff ff ff       	call   80173e <syscall>
  8017a8:	83 c4 18             	add    $0x18,%esp
}
  8017ab:	c9                   	leave  
  8017ac:	c3                   	ret    

008017ad <sys_lock_cons>:

void sys_lock_cons(void)
{
  8017ad:	55                   	push   %ebp
  8017ae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8017b0:	6a 00                	push   $0x0
  8017b2:	6a 00                	push   $0x0
  8017b4:	6a 00                	push   $0x0
  8017b6:	6a 00                	push   $0x0
  8017b8:	6a 00                	push   $0x0
  8017ba:	6a 03                	push   $0x3
  8017bc:	e8 7d ff ff ff       	call   80173e <syscall>
  8017c1:	83 c4 18             	add    $0x18,%esp
}
  8017c4:	90                   	nop
  8017c5:	c9                   	leave  
  8017c6:	c3                   	ret    

008017c7 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8017c7:	55                   	push   %ebp
  8017c8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8017ca:	6a 00                	push   $0x0
  8017cc:	6a 00                	push   $0x0
  8017ce:	6a 00                	push   $0x0
  8017d0:	6a 00                	push   $0x0
  8017d2:	6a 00                	push   $0x0
  8017d4:	6a 04                	push   $0x4
  8017d6:	e8 63 ff ff ff       	call   80173e <syscall>
  8017db:	83 c4 18             	add    $0x18,%esp
}
  8017de:	90                   	nop
  8017df:	c9                   	leave  
  8017e0:	c3                   	ret    

008017e1 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8017e1:	55                   	push   %ebp
  8017e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8017e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ea:	6a 00                	push   $0x0
  8017ec:	6a 00                	push   $0x0
  8017ee:	6a 00                	push   $0x0
  8017f0:	52                   	push   %edx
  8017f1:	50                   	push   %eax
  8017f2:	6a 08                	push   $0x8
  8017f4:	e8 45 ff ff ff       	call   80173e <syscall>
  8017f9:	83 c4 18             	add    $0x18,%esp
}
  8017fc:	c9                   	leave  
  8017fd:	c3                   	ret    

008017fe <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8017fe:	55                   	push   %ebp
  8017ff:	89 e5                	mov    %esp,%ebp
  801801:	56                   	push   %esi
  801802:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801803:	8b 75 18             	mov    0x18(%ebp),%esi
  801806:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801809:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80180c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80180f:	8b 45 08             	mov    0x8(%ebp),%eax
  801812:	56                   	push   %esi
  801813:	53                   	push   %ebx
  801814:	51                   	push   %ecx
  801815:	52                   	push   %edx
  801816:	50                   	push   %eax
  801817:	6a 09                	push   $0x9
  801819:	e8 20 ff ff ff       	call   80173e <syscall>
  80181e:	83 c4 18             	add    $0x18,%esp
}
  801821:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801824:	5b                   	pop    %ebx
  801825:	5e                   	pop    %esi
  801826:	5d                   	pop    %ebp
  801827:	c3                   	ret    

00801828 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801828:	55                   	push   %ebp
  801829:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  80182b:	6a 00                	push   $0x0
  80182d:	6a 00                	push   $0x0
  80182f:	6a 00                	push   $0x0
  801831:	6a 00                	push   $0x0
  801833:	ff 75 08             	pushl  0x8(%ebp)
  801836:	6a 0a                	push   $0xa
  801838:	e8 01 ff ff ff       	call   80173e <syscall>
  80183d:	83 c4 18             	add    $0x18,%esp
}
  801840:	c9                   	leave  
  801841:	c3                   	ret    

00801842 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801842:	55                   	push   %ebp
  801843:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801845:	6a 00                	push   $0x0
  801847:	6a 00                	push   $0x0
  801849:	6a 00                	push   $0x0
  80184b:	ff 75 0c             	pushl  0xc(%ebp)
  80184e:	ff 75 08             	pushl  0x8(%ebp)
  801851:	6a 0b                	push   $0xb
  801853:	e8 e6 fe ff ff       	call   80173e <syscall>
  801858:	83 c4 18             	add    $0x18,%esp
}
  80185b:	c9                   	leave  
  80185c:	c3                   	ret    

0080185d <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80185d:	55                   	push   %ebp
  80185e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801860:	6a 00                	push   $0x0
  801862:	6a 00                	push   $0x0
  801864:	6a 00                	push   $0x0
  801866:	6a 00                	push   $0x0
  801868:	6a 00                	push   $0x0
  80186a:	6a 0c                	push   $0xc
  80186c:	e8 cd fe ff ff       	call   80173e <syscall>
  801871:	83 c4 18             	add    $0x18,%esp
}
  801874:	c9                   	leave  
  801875:	c3                   	ret    

00801876 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801876:	55                   	push   %ebp
  801877:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801879:	6a 00                	push   $0x0
  80187b:	6a 00                	push   $0x0
  80187d:	6a 00                	push   $0x0
  80187f:	6a 00                	push   $0x0
  801881:	6a 00                	push   $0x0
  801883:	6a 0d                	push   $0xd
  801885:	e8 b4 fe ff ff       	call   80173e <syscall>
  80188a:	83 c4 18             	add    $0x18,%esp
}
  80188d:	c9                   	leave  
  80188e:	c3                   	ret    

0080188f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80188f:	55                   	push   %ebp
  801890:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801892:	6a 00                	push   $0x0
  801894:	6a 00                	push   $0x0
  801896:	6a 00                	push   $0x0
  801898:	6a 00                	push   $0x0
  80189a:	6a 00                	push   $0x0
  80189c:	6a 0e                	push   $0xe
  80189e:	e8 9b fe ff ff       	call   80173e <syscall>
  8018a3:	83 c4 18             	add    $0x18,%esp
}
  8018a6:	c9                   	leave  
  8018a7:	c3                   	ret    

008018a8 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8018a8:	55                   	push   %ebp
  8018a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8018ab:	6a 00                	push   $0x0
  8018ad:	6a 00                	push   $0x0
  8018af:	6a 00                	push   $0x0
  8018b1:	6a 00                	push   $0x0
  8018b3:	6a 00                	push   $0x0
  8018b5:	6a 0f                	push   $0xf
  8018b7:	e8 82 fe ff ff       	call   80173e <syscall>
  8018bc:	83 c4 18             	add    $0x18,%esp
}
  8018bf:	c9                   	leave  
  8018c0:	c3                   	ret    

008018c1 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8018c1:	55                   	push   %ebp
  8018c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8018c4:	6a 00                	push   $0x0
  8018c6:	6a 00                	push   $0x0
  8018c8:	6a 00                	push   $0x0
  8018ca:	6a 00                	push   $0x0
  8018cc:	ff 75 08             	pushl  0x8(%ebp)
  8018cf:	6a 10                	push   $0x10
  8018d1:	e8 68 fe ff ff       	call   80173e <syscall>
  8018d6:	83 c4 18             	add    $0x18,%esp
}
  8018d9:	c9                   	leave  
  8018da:	c3                   	ret    

008018db <sys_scarce_memory>:

void sys_scarce_memory()
{
  8018db:	55                   	push   %ebp
  8018dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 00                	push   $0x0
  8018e6:	6a 00                	push   $0x0
  8018e8:	6a 11                	push   $0x11
  8018ea:	e8 4f fe ff ff       	call   80173e <syscall>
  8018ef:	83 c4 18             	add    $0x18,%esp
}
  8018f2:	90                   	nop
  8018f3:	c9                   	leave  
  8018f4:	c3                   	ret    

008018f5 <sys_cputc>:

void
sys_cputc(const char c)
{
  8018f5:	55                   	push   %ebp
  8018f6:	89 e5                	mov    %esp,%ebp
  8018f8:	83 ec 04             	sub    $0x4,%esp
  8018fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fe:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801901:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801905:	6a 00                	push   $0x0
  801907:	6a 00                	push   $0x0
  801909:	6a 00                	push   $0x0
  80190b:	6a 00                	push   $0x0
  80190d:	50                   	push   %eax
  80190e:	6a 01                	push   $0x1
  801910:	e8 29 fe ff ff       	call   80173e <syscall>
  801915:	83 c4 18             	add    $0x18,%esp
}
  801918:	90                   	nop
  801919:	c9                   	leave  
  80191a:	c3                   	ret    

0080191b <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80191b:	55                   	push   %ebp
  80191c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80191e:	6a 00                	push   $0x0
  801920:	6a 00                	push   $0x0
  801922:	6a 00                	push   $0x0
  801924:	6a 00                	push   $0x0
  801926:	6a 00                	push   $0x0
  801928:	6a 14                	push   $0x14
  80192a:	e8 0f fe ff ff       	call   80173e <syscall>
  80192f:	83 c4 18             	add    $0x18,%esp
}
  801932:	90                   	nop
  801933:	c9                   	leave  
  801934:	c3                   	ret    

00801935 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801935:	55                   	push   %ebp
  801936:	89 e5                	mov    %esp,%ebp
  801938:	83 ec 04             	sub    $0x4,%esp
  80193b:	8b 45 10             	mov    0x10(%ebp),%eax
  80193e:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801941:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801944:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801948:	8b 45 08             	mov    0x8(%ebp),%eax
  80194b:	6a 00                	push   $0x0
  80194d:	51                   	push   %ecx
  80194e:	52                   	push   %edx
  80194f:	ff 75 0c             	pushl  0xc(%ebp)
  801952:	50                   	push   %eax
  801953:	6a 15                	push   $0x15
  801955:	e8 e4 fd ff ff       	call   80173e <syscall>
  80195a:	83 c4 18             	add    $0x18,%esp
}
  80195d:	c9                   	leave  
  80195e:	c3                   	ret    

0080195f <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  80195f:	55                   	push   %ebp
  801960:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801962:	8b 55 0c             	mov    0xc(%ebp),%edx
  801965:	8b 45 08             	mov    0x8(%ebp),%eax
  801968:	6a 00                	push   $0x0
  80196a:	6a 00                	push   $0x0
  80196c:	6a 00                	push   $0x0
  80196e:	52                   	push   %edx
  80196f:	50                   	push   %eax
  801970:	6a 16                	push   $0x16
  801972:	e8 c7 fd ff ff       	call   80173e <syscall>
  801977:	83 c4 18             	add    $0x18,%esp
}
  80197a:	c9                   	leave  
  80197b:	c3                   	ret    

0080197c <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  80197c:	55                   	push   %ebp
  80197d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80197f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801982:	8b 55 0c             	mov    0xc(%ebp),%edx
  801985:	8b 45 08             	mov    0x8(%ebp),%eax
  801988:	6a 00                	push   $0x0
  80198a:	6a 00                	push   $0x0
  80198c:	51                   	push   %ecx
  80198d:	52                   	push   %edx
  80198e:	50                   	push   %eax
  80198f:	6a 17                	push   $0x17
  801991:	e8 a8 fd ff ff       	call   80173e <syscall>
  801996:	83 c4 18             	add    $0x18,%esp
}
  801999:	c9                   	leave  
  80199a:	c3                   	ret    

0080199b <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  80199b:	55                   	push   %ebp
  80199c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80199e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a4:	6a 00                	push   $0x0
  8019a6:	6a 00                	push   $0x0
  8019a8:	6a 00                	push   $0x0
  8019aa:	52                   	push   %edx
  8019ab:	50                   	push   %eax
  8019ac:	6a 18                	push   $0x18
  8019ae:	e8 8b fd ff ff       	call   80173e <syscall>
  8019b3:	83 c4 18             	add    $0x18,%esp
}
  8019b6:	c9                   	leave  
  8019b7:	c3                   	ret    

008019b8 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8019b8:	55                   	push   %ebp
  8019b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8019bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019be:	6a 00                	push   $0x0
  8019c0:	ff 75 14             	pushl  0x14(%ebp)
  8019c3:	ff 75 10             	pushl  0x10(%ebp)
  8019c6:	ff 75 0c             	pushl  0xc(%ebp)
  8019c9:	50                   	push   %eax
  8019ca:	6a 19                	push   $0x19
  8019cc:	e8 6d fd ff ff       	call   80173e <syscall>
  8019d1:	83 c4 18             	add    $0x18,%esp
}
  8019d4:	c9                   	leave  
  8019d5:	c3                   	ret    

008019d6 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8019d6:	55                   	push   %ebp
  8019d7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8019d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	50                   	push   %eax
  8019e5:	6a 1a                	push   $0x1a
  8019e7:	e8 52 fd ff ff       	call   80173e <syscall>
  8019ec:	83 c4 18             	add    $0x18,%esp
}
  8019ef:	90                   	nop
  8019f0:	c9                   	leave  
  8019f1:	c3                   	ret    

008019f2 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8019f2:	55                   	push   %ebp
  8019f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8019f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 00                	push   $0x0
  8019fe:	6a 00                	push   $0x0
  801a00:	50                   	push   %eax
  801a01:	6a 1b                	push   $0x1b
  801a03:	e8 36 fd ff ff       	call   80173e <syscall>
  801a08:	83 c4 18             	add    $0x18,%esp
}
  801a0b:	c9                   	leave  
  801a0c:	c3                   	ret    

00801a0d <sys_getenvid>:

int32 sys_getenvid(void)
{
  801a0d:	55                   	push   %ebp
  801a0e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801a10:	6a 00                	push   $0x0
  801a12:	6a 00                	push   $0x0
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 05                	push   $0x5
  801a1c:	e8 1d fd ff ff       	call   80173e <syscall>
  801a21:	83 c4 18             	add    $0x18,%esp
}
  801a24:	c9                   	leave  
  801a25:	c3                   	ret    

00801a26 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801a26:	55                   	push   %ebp
  801a27:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801a29:	6a 00                	push   $0x0
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 00                	push   $0x0
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 00                	push   $0x0
  801a33:	6a 06                	push   $0x6
  801a35:	e8 04 fd ff ff       	call   80173e <syscall>
  801a3a:	83 c4 18             	add    $0x18,%esp
}
  801a3d:	c9                   	leave  
  801a3e:	c3                   	ret    

00801a3f <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801a3f:	55                   	push   %ebp
  801a40:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801a42:	6a 00                	push   $0x0
  801a44:	6a 00                	push   $0x0
  801a46:	6a 00                	push   $0x0
  801a48:	6a 00                	push   $0x0
  801a4a:	6a 00                	push   $0x0
  801a4c:	6a 07                	push   $0x7
  801a4e:	e8 eb fc ff ff       	call   80173e <syscall>
  801a53:	83 c4 18             	add    $0x18,%esp
}
  801a56:	c9                   	leave  
  801a57:	c3                   	ret    

00801a58 <sys_exit_env>:


void sys_exit_env(void)
{
  801a58:	55                   	push   %ebp
  801a59:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 00                	push   $0x0
  801a63:	6a 00                	push   $0x0
  801a65:	6a 1c                	push   $0x1c
  801a67:	e8 d2 fc ff ff       	call   80173e <syscall>
  801a6c:	83 c4 18             	add    $0x18,%esp
}
  801a6f:	90                   	nop
  801a70:	c9                   	leave  
  801a71:	c3                   	ret    

00801a72 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801a72:	55                   	push   %ebp
  801a73:	89 e5                	mov    %esp,%ebp
  801a75:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801a78:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a7b:	8d 50 04             	lea    0x4(%eax),%edx
  801a7e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a81:	6a 00                	push   $0x0
  801a83:	6a 00                	push   $0x0
  801a85:	6a 00                	push   $0x0
  801a87:	52                   	push   %edx
  801a88:	50                   	push   %eax
  801a89:	6a 1d                	push   $0x1d
  801a8b:	e8 ae fc ff ff       	call   80173e <syscall>
  801a90:	83 c4 18             	add    $0x18,%esp
	return result;
  801a93:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a96:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a99:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a9c:	89 01                	mov    %eax,(%ecx)
  801a9e:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801aa1:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa4:	c9                   	leave  
  801aa5:	c2 04 00             	ret    $0x4

00801aa8 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801aa8:	55                   	push   %ebp
  801aa9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801aab:	6a 00                	push   $0x0
  801aad:	6a 00                	push   $0x0
  801aaf:	ff 75 10             	pushl  0x10(%ebp)
  801ab2:	ff 75 0c             	pushl  0xc(%ebp)
  801ab5:	ff 75 08             	pushl  0x8(%ebp)
  801ab8:	6a 13                	push   $0x13
  801aba:	e8 7f fc ff ff       	call   80173e <syscall>
  801abf:	83 c4 18             	add    $0x18,%esp
	return ;
  801ac2:	90                   	nop
}
  801ac3:	c9                   	leave  
  801ac4:	c3                   	ret    

00801ac5 <sys_rcr2>:
uint32 sys_rcr2()
{
  801ac5:	55                   	push   %ebp
  801ac6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ac8:	6a 00                	push   $0x0
  801aca:	6a 00                	push   $0x0
  801acc:	6a 00                	push   $0x0
  801ace:	6a 00                	push   $0x0
  801ad0:	6a 00                	push   $0x0
  801ad2:	6a 1e                	push   $0x1e
  801ad4:	e8 65 fc ff ff       	call   80173e <syscall>
  801ad9:	83 c4 18             	add    $0x18,%esp
}
  801adc:	c9                   	leave  
  801add:	c3                   	ret    

00801ade <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801ade:	55                   	push   %ebp
  801adf:	89 e5                	mov    %esp,%ebp
  801ae1:	83 ec 04             	sub    $0x4,%esp
  801ae4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801aea:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	50                   	push   %eax
  801af7:	6a 1f                	push   $0x1f
  801af9:	e8 40 fc ff ff       	call   80173e <syscall>
  801afe:	83 c4 18             	add    $0x18,%esp
	return ;
  801b01:	90                   	nop
}
  801b02:	c9                   	leave  
  801b03:	c3                   	ret    

00801b04 <rsttst>:
void rsttst()
{
  801b04:	55                   	push   %ebp
  801b05:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 21                	push   $0x21
  801b13:	e8 26 fc ff ff       	call   80173e <syscall>
  801b18:	83 c4 18             	add    $0x18,%esp
	return ;
  801b1b:	90                   	nop
}
  801b1c:	c9                   	leave  
  801b1d:	c3                   	ret    

00801b1e <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801b1e:	55                   	push   %ebp
  801b1f:	89 e5                	mov    %esp,%ebp
  801b21:	83 ec 04             	sub    $0x4,%esp
  801b24:	8b 45 14             	mov    0x14(%ebp),%eax
  801b27:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801b2a:	8b 55 18             	mov    0x18(%ebp),%edx
  801b2d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b31:	52                   	push   %edx
  801b32:	50                   	push   %eax
  801b33:	ff 75 10             	pushl  0x10(%ebp)
  801b36:	ff 75 0c             	pushl  0xc(%ebp)
  801b39:	ff 75 08             	pushl  0x8(%ebp)
  801b3c:	6a 20                	push   $0x20
  801b3e:	e8 fb fb ff ff       	call   80173e <syscall>
  801b43:	83 c4 18             	add    $0x18,%esp
	return ;
  801b46:	90                   	nop
}
  801b47:	c9                   	leave  
  801b48:	c3                   	ret    

00801b49 <chktst>:
void chktst(uint32 n)
{
  801b49:	55                   	push   %ebp
  801b4a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801b4c:	6a 00                	push   $0x0
  801b4e:	6a 00                	push   $0x0
  801b50:	6a 00                	push   $0x0
  801b52:	6a 00                	push   $0x0
  801b54:	ff 75 08             	pushl  0x8(%ebp)
  801b57:	6a 22                	push   $0x22
  801b59:	e8 e0 fb ff ff       	call   80173e <syscall>
  801b5e:	83 c4 18             	add    $0x18,%esp
	return ;
  801b61:	90                   	nop
}
  801b62:	c9                   	leave  
  801b63:	c3                   	ret    

00801b64 <inctst>:

void inctst()
{
  801b64:	55                   	push   %ebp
  801b65:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801b67:	6a 00                	push   $0x0
  801b69:	6a 00                	push   $0x0
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 23                	push   $0x23
  801b73:	e8 c6 fb ff ff       	call   80173e <syscall>
  801b78:	83 c4 18             	add    $0x18,%esp
	return ;
  801b7b:	90                   	nop
}
  801b7c:	c9                   	leave  
  801b7d:	c3                   	ret    

00801b7e <gettst>:
uint32 gettst()
{
  801b7e:	55                   	push   %ebp
  801b7f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801b81:	6a 00                	push   $0x0
  801b83:	6a 00                	push   $0x0
  801b85:	6a 00                	push   $0x0
  801b87:	6a 00                	push   $0x0
  801b89:	6a 00                	push   $0x0
  801b8b:	6a 24                	push   $0x24
  801b8d:	e8 ac fb ff ff       	call   80173e <syscall>
  801b92:	83 c4 18             	add    $0x18,%esp
}
  801b95:	c9                   	leave  
  801b96:	c3                   	ret    

00801b97 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801b97:	55                   	push   %ebp
  801b98:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b9a:	6a 00                	push   $0x0
  801b9c:	6a 00                	push   $0x0
  801b9e:	6a 00                	push   $0x0
  801ba0:	6a 00                	push   $0x0
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 25                	push   $0x25
  801ba6:	e8 93 fb ff ff       	call   80173e <syscall>
  801bab:	83 c4 18             	add    $0x18,%esp
  801bae:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801bb3:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801bb8:	c9                   	leave  
  801bb9:	c3                   	ret    

00801bba <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801bba:	55                   	push   %ebp
  801bbb:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801bbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc0:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 00                	push   $0x0
  801bcb:	6a 00                	push   $0x0
  801bcd:	ff 75 08             	pushl  0x8(%ebp)
  801bd0:	6a 26                	push   $0x26
  801bd2:	e8 67 fb ff ff       	call   80173e <syscall>
  801bd7:	83 c4 18             	add    $0x18,%esp
	return ;
  801bda:	90                   	nop
}
  801bdb:	c9                   	leave  
  801bdc:	c3                   	ret    

00801bdd <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801bdd:	55                   	push   %ebp
  801bde:	89 e5                	mov    %esp,%ebp
  801be0:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801be1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801be4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801be7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bea:	8b 45 08             	mov    0x8(%ebp),%eax
  801bed:	6a 00                	push   $0x0
  801bef:	53                   	push   %ebx
  801bf0:	51                   	push   %ecx
  801bf1:	52                   	push   %edx
  801bf2:	50                   	push   %eax
  801bf3:	6a 27                	push   $0x27
  801bf5:	e8 44 fb ff ff       	call   80173e <syscall>
  801bfa:	83 c4 18             	add    $0x18,%esp
}
  801bfd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c00:	c9                   	leave  
  801c01:	c3                   	ret    

00801c02 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801c02:	55                   	push   %ebp
  801c03:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801c05:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c08:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 00                	push   $0x0
  801c11:	52                   	push   %edx
  801c12:	50                   	push   %eax
  801c13:	6a 28                	push   $0x28
  801c15:	e8 24 fb ff ff       	call   80173e <syscall>
  801c1a:	83 c4 18             	add    $0x18,%esp
}
  801c1d:	c9                   	leave  
  801c1e:	c3                   	ret    

00801c1f <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801c1f:	55                   	push   %ebp
  801c20:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801c22:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c25:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c28:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2b:	6a 00                	push   $0x0
  801c2d:	51                   	push   %ecx
  801c2e:	ff 75 10             	pushl  0x10(%ebp)
  801c31:	52                   	push   %edx
  801c32:	50                   	push   %eax
  801c33:	6a 29                	push   $0x29
  801c35:	e8 04 fb ff ff       	call   80173e <syscall>
  801c3a:	83 c4 18             	add    $0x18,%esp
}
  801c3d:	c9                   	leave  
  801c3e:	c3                   	ret    

00801c3f <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801c3f:	55                   	push   %ebp
  801c40:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801c42:	6a 00                	push   $0x0
  801c44:	6a 00                	push   $0x0
  801c46:	ff 75 10             	pushl  0x10(%ebp)
  801c49:	ff 75 0c             	pushl  0xc(%ebp)
  801c4c:	ff 75 08             	pushl  0x8(%ebp)
  801c4f:	6a 12                	push   $0x12
  801c51:	e8 e8 fa ff ff       	call   80173e <syscall>
  801c56:	83 c4 18             	add    $0x18,%esp
	return ;
  801c59:	90                   	nop
}
  801c5a:	c9                   	leave  
  801c5b:	c3                   	ret    

00801c5c <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801c5c:	55                   	push   %ebp
  801c5d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801c5f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c62:	8b 45 08             	mov    0x8(%ebp),%eax
  801c65:	6a 00                	push   $0x0
  801c67:	6a 00                	push   $0x0
  801c69:	6a 00                	push   $0x0
  801c6b:	52                   	push   %edx
  801c6c:	50                   	push   %eax
  801c6d:	6a 2a                	push   $0x2a
  801c6f:	e8 ca fa ff ff       	call   80173e <syscall>
  801c74:	83 c4 18             	add    $0x18,%esp
	return;
  801c77:	90                   	nop
}
  801c78:	c9                   	leave  
  801c79:	c3                   	ret    

00801c7a <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801c7a:	55                   	push   %ebp
  801c7b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801c7d:	6a 00                	push   $0x0
  801c7f:	6a 00                	push   $0x0
  801c81:	6a 00                	push   $0x0
  801c83:	6a 00                	push   $0x0
  801c85:	6a 00                	push   $0x0
  801c87:	6a 2b                	push   $0x2b
  801c89:	e8 b0 fa ff ff       	call   80173e <syscall>
  801c8e:	83 c4 18             	add    $0x18,%esp
}
  801c91:	c9                   	leave  
  801c92:	c3                   	ret    

00801c93 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801c93:	55                   	push   %ebp
  801c94:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801c96:	6a 00                	push   $0x0
  801c98:	6a 00                	push   $0x0
  801c9a:	6a 00                	push   $0x0
  801c9c:	ff 75 0c             	pushl  0xc(%ebp)
  801c9f:	ff 75 08             	pushl  0x8(%ebp)
  801ca2:	6a 2d                	push   $0x2d
  801ca4:	e8 95 fa ff ff       	call   80173e <syscall>
  801ca9:	83 c4 18             	add    $0x18,%esp
	return;
  801cac:	90                   	nop
}
  801cad:	c9                   	leave  
  801cae:	c3                   	ret    

00801caf <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801caf:	55                   	push   %ebp
  801cb0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 00                	push   $0x0
  801cb6:	6a 00                	push   $0x0
  801cb8:	ff 75 0c             	pushl  0xc(%ebp)
  801cbb:	ff 75 08             	pushl  0x8(%ebp)
  801cbe:	6a 2c                	push   $0x2c
  801cc0:	e8 79 fa ff ff       	call   80173e <syscall>
  801cc5:	83 c4 18             	add    $0x18,%esp
	return ;
  801cc8:	90                   	nop
}
  801cc9:	c9                   	leave  
  801cca:	c3                   	ret    

00801ccb <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801ccb:	55                   	push   %ebp
  801ccc:	89 e5                	mov    %esp,%ebp
  801cce:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801cd1:	83 ec 04             	sub    $0x4,%esp
  801cd4:	68 5c 28 80 00       	push   $0x80285c
  801cd9:	68 25 01 00 00       	push   $0x125
  801cde:	68 8f 28 80 00       	push   $0x80288f
  801ce3:	e8 9b e6 ff ff       	call   800383 <_panic>

00801ce8 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801ce8:	55                   	push   %ebp
  801ce9:	89 e5                	mov    %esp,%ebp
  801ceb:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801cee:	8b 55 08             	mov    0x8(%ebp),%edx
  801cf1:	89 d0                	mov    %edx,%eax
  801cf3:	c1 e0 02             	shl    $0x2,%eax
  801cf6:	01 d0                	add    %edx,%eax
  801cf8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801cff:	01 d0                	add    %edx,%eax
  801d01:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801d08:	01 d0                	add    %edx,%eax
  801d0a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801d11:	01 d0                	add    %edx,%eax
  801d13:	c1 e0 04             	shl    $0x4,%eax
  801d16:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  801d19:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  801d20:	0f 31                	rdtsc  
  801d22:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801d25:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  801d28:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d2b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801d2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d31:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801d34:	eb 46                	jmp    801d7c <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  801d36:	0f 31                	rdtsc  
  801d38:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801d3b:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  801d3e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801d41:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801d44:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801d47:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801d4a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d50:	29 c2                	sub    %eax,%edx
  801d52:	89 d0                	mov    %edx,%eax
  801d54:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801d57:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801d5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d5d:	89 d1                	mov    %edx,%ecx
  801d5f:	29 c1                	sub    %eax,%ecx
  801d61:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801d64:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d67:	39 c2                	cmp    %eax,%edx
  801d69:	0f 97 c0             	seta   %al
  801d6c:	0f b6 c0             	movzbl %al,%eax
  801d6f:	29 c1                	sub    %eax,%ecx
  801d71:	89 c8                	mov    %ecx,%eax
  801d73:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801d76:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801d79:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801d7c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d7f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801d82:	72 b2                	jb     801d36 <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801d84:	90                   	nop
  801d85:	c9                   	leave  
  801d86:	c3                   	ret    

00801d87 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801d87:	55                   	push   %ebp
  801d88:	89 e5                	mov    %esp,%ebp
  801d8a:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801d8d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801d94:	eb 03                	jmp    801d99 <busy_wait+0x12>
  801d96:	ff 45 fc             	incl   -0x4(%ebp)
  801d99:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d9c:	3b 45 08             	cmp    0x8(%ebp),%eax
  801d9f:	72 f5                	jb     801d96 <busy_wait+0xf>
	return i;
  801da1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801da4:	c9                   	leave  
  801da5:	c3                   	ret    

00801da6 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  801da6:	55                   	push   %ebp
  801da7:	89 e5                	mov    %esp,%ebp
  801da9:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  801dac:	8b 45 08             	mov    0x8(%ebp),%eax
  801daf:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  801db2:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  801db6:	83 ec 0c             	sub    $0xc,%esp
  801db9:	50                   	push   %eax
  801dba:	e8 36 fb ff ff       	call   8018f5 <sys_cputc>
  801dbf:	83 c4 10             	add    $0x10,%esp
}
  801dc2:	90                   	nop
  801dc3:	c9                   	leave  
  801dc4:	c3                   	ret    

00801dc5 <getchar>:


int
getchar(void)
{
  801dc5:	55                   	push   %ebp
  801dc6:	89 e5                	mov    %esp,%ebp
  801dc8:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  801dcb:	e8 c4 f9 ff ff       	call   801794 <sys_cgetc>
  801dd0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  801dd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801dd6:	c9                   	leave  
  801dd7:	c3                   	ret    

00801dd8 <iscons>:

int iscons(int fdnum)
{
  801dd8:	55                   	push   %ebp
  801dd9:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  801ddb:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801de0:	5d                   	pop    %ebp
  801de1:	c3                   	ret    
  801de2:	66 90                	xchg   %ax,%ax

00801de4 <__udivdi3>:
  801de4:	55                   	push   %ebp
  801de5:	57                   	push   %edi
  801de6:	56                   	push   %esi
  801de7:	53                   	push   %ebx
  801de8:	83 ec 1c             	sub    $0x1c,%esp
  801deb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801def:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801df3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801df7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801dfb:	89 ca                	mov    %ecx,%edx
  801dfd:	89 f8                	mov    %edi,%eax
  801dff:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801e03:	85 f6                	test   %esi,%esi
  801e05:	75 2d                	jne    801e34 <__udivdi3+0x50>
  801e07:	39 cf                	cmp    %ecx,%edi
  801e09:	77 65                	ja     801e70 <__udivdi3+0x8c>
  801e0b:	89 fd                	mov    %edi,%ebp
  801e0d:	85 ff                	test   %edi,%edi
  801e0f:	75 0b                	jne    801e1c <__udivdi3+0x38>
  801e11:	b8 01 00 00 00       	mov    $0x1,%eax
  801e16:	31 d2                	xor    %edx,%edx
  801e18:	f7 f7                	div    %edi
  801e1a:	89 c5                	mov    %eax,%ebp
  801e1c:	31 d2                	xor    %edx,%edx
  801e1e:	89 c8                	mov    %ecx,%eax
  801e20:	f7 f5                	div    %ebp
  801e22:	89 c1                	mov    %eax,%ecx
  801e24:	89 d8                	mov    %ebx,%eax
  801e26:	f7 f5                	div    %ebp
  801e28:	89 cf                	mov    %ecx,%edi
  801e2a:	89 fa                	mov    %edi,%edx
  801e2c:	83 c4 1c             	add    $0x1c,%esp
  801e2f:	5b                   	pop    %ebx
  801e30:	5e                   	pop    %esi
  801e31:	5f                   	pop    %edi
  801e32:	5d                   	pop    %ebp
  801e33:	c3                   	ret    
  801e34:	39 ce                	cmp    %ecx,%esi
  801e36:	77 28                	ja     801e60 <__udivdi3+0x7c>
  801e38:	0f bd fe             	bsr    %esi,%edi
  801e3b:	83 f7 1f             	xor    $0x1f,%edi
  801e3e:	75 40                	jne    801e80 <__udivdi3+0x9c>
  801e40:	39 ce                	cmp    %ecx,%esi
  801e42:	72 0a                	jb     801e4e <__udivdi3+0x6a>
  801e44:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801e48:	0f 87 9e 00 00 00    	ja     801eec <__udivdi3+0x108>
  801e4e:	b8 01 00 00 00       	mov    $0x1,%eax
  801e53:	89 fa                	mov    %edi,%edx
  801e55:	83 c4 1c             	add    $0x1c,%esp
  801e58:	5b                   	pop    %ebx
  801e59:	5e                   	pop    %esi
  801e5a:	5f                   	pop    %edi
  801e5b:	5d                   	pop    %ebp
  801e5c:	c3                   	ret    
  801e5d:	8d 76 00             	lea    0x0(%esi),%esi
  801e60:	31 ff                	xor    %edi,%edi
  801e62:	31 c0                	xor    %eax,%eax
  801e64:	89 fa                	mov    %edi,%edx
  801e66:	83 c4 1c             	add    $0x1c,%esp
  801e69:	5b                   	pop    %ebx
  801e6a:	5e                   	pop    %esi
  801e6b:	5f                   	pop    %edi
  801e6c:	5d                   	pop    %ebp
  801e6d:	c3                   	ret    
  801e6e:	66 90                	xchg   %ax,%ax
  801e70:	89 d8                	mov    %ebx,%eax
  801e72:	f7 f7                	div    %edi
  801e74:	31 ff                	xor    %edi,%edi
  801e76:	89 fa                	mov    %edi,%edx
  801e78:	83 c4 1c             	add    $0x1c,%esp
  801e7b:	5b                   	pop    %ebx
  801e7c:	5e                   	pop    %esi
  801e7d:	5f                   	pop    %edi
  801e7e:	5d                   	pop    %ebp
  801e7f:	c3                   	ret    
  801e80:	bd 20 00 00 00       	mov    $0x20,%ebp
  801e85:	89 eb                	mov    %ebp,%ebx
  801e87:	29 fb                	sub    %edi,%ebx
  801e89:	89 f9                	mov    %edi,%ecx
  801e8b:	d3 e6                	shl    %cl,%esi
  801e8d:	89 c5                	mov    %eax,%ebp
  801e8f:	88 d9                	mov    %bl,%cl
  801e91:	d3 ed                	shr    %cl,%ebp
  801e93:	89 e9                	mov    %ebp,%ecx
  801e95:	09 f1                	or     %esi,%ecx
  801e97:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801e9b:	89 f9                	mov    %edi,%ecx
  801e9d:	d3 e0                	shl    %cl,%eax
  801e9f:	89 c5                	mov    %eax,%ebp
  801ea1:	89 d6                	mov    %edx,%esi
  801ea3:	88 d9                	mov    %bl,%cl
  801ea5:	d3 ee                	shr    %cl,%esi
  801ea7:	89 f9                	mov    %edi,%ecx
  801ea9:	d3 e2                	shl    %cl,%edx
  801eab:	8b 44 24 08          	mov    0x8(%esp),%eax
  801eaf:	88 d9                	mov    %bl,%cl
  801eb1:	d3 e8                	shr    %cl,%eax
  801eb3:	09 c2                	or     %eax,%edx
  801eb5:	89 d0                	mov    %edx,%eax
  801eb7:	89 f2                	mov    %esi,%edx
  801eb9:	f7 74 24 0c          	divl   0xc(%esp)
  801ebd:	89 d6                	mov    %edx,%esi
  801ebf:	89 c3                	mov    %eax,%ebx
  801ec1:	f7 e5                	mul    %ebp
  801ec3:	39 d6                	cmp    %edx,%esi
  801ec5:	72 19                	jb     801ee0 <__udivdi3+0xfc>
  801ec7:	74 0b                	je     801ed4 <__udivdi3+0xf0>
  801ec9:	89 d8                	mov    %ebx,%eax
  801ecb:	31 ff                	xor    %edi,%edi
  801ecd:	e9 58 ff ff ff       	jmp    801e2a <__udivdi3+0x46>
  801ed2:	66 90                	xchg   %ax,%ax
  801ed4:	8b 54 24 08          	mov    0x8(%esp),%edx
  801ed8:	89 f9                	mov    %edi,%ecx
  801eda:	d3 e2                	shl    %cl,%edx
  801edc:	39 c2                	cmp    %eax,%edx
  801ede:	73 e9                	jae    801ec9 <__udivdi3+0xe5>
  801ee0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801ee3:	31 ff                	xor    %edi,%edi
  801ee5:	e9 40 ff ff ff       	jmp    801e2a <__udivdi3+0x46>
  801eea:	66 90                	xchg   %ax,%ax
  801eec:	31 c0                	xor    %eax,%eax
  801eee:	e9 37 ff ff ff       	jmp    801e2a <__udivdi3+0x46>
  801ef3:	90                   	nop

00801ef4 <__umoddi3>:
  801ef4:	55                   	push   %ebp
  801ef5:	57                   	push   %edi
  801ef6:	56                   	push   %esi
  801ef7:	53                   	push   %ebx
  801ef8:	83 ec 1c             	sub    $0x1c,%esp
  801efb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801eff:	8b 74 24 34          	mov    0x34(%esp),%esi
  801f03:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801f07:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801f0b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801f0f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801f13:	89 f3                	mov    %esi,%ebx
  801f15:	89 fa                	mov    %edi,%edx
  801f17:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801f1b:	89 34 24             	mov    %esi,(%esp)
  801f1e:	85 c0                	test   %eax,%eax
  801f20:	75 1a                	jne    801f3c <__umoddi3+0x48>
  801f22:	39 f7                	cmp    %esi,%edi
  801f24:	0f 86 a2 00 00 00    	jbe    801fcc <__umoddi3+0xd8>
  801f2a:	89 c8                	mov    %ecx,%eax
  801f2c:	89 f2                	mov    %esi,%edx
  801f2e:	f7 f7                	div    %edi
  801f30:	89 d0                	mov    %edx,%eax
  801f32:	31 d2                	xor    %edx,%edx
  801f34:	83 c4 1c             	add    $0x1c,%esp
  801f37:	5b                   	pop    %ebx
  801f38:	5e                   	pop    %esi
  801f39:	5f                   	pop    %edi
  801f3a:	5d                   	pop    %ebp
  801f3b:	c3                   	ret    
  801f3c:	39 f0                	cmp    %esi,%eax
  801f3e:	0f 87 ac 00 00 00    	ja     801ff0 <__umoddi3+0xfc>
  801f44:	0f bd e8             	bsr    %eax,%ebp
  801f47:	83 f5 1f             	xor    $0x1f,%ebp
  801f4a:	0f 84 ac 00 00 00    	je     801ffc <__umoddi3+0x108>
  801f50:	bf 20 00 00 00       	mov    $0x20,%edi
  801f55:	29 ef                	sub    %ebp,%edi
  801f57:	89 fe                	mov    %edi,%esi
  801f59:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801f5d:	89 e9                	mov    %ebp,%ecx
  801f5f:	d3 e0                	shl    %cl,%eax
  801f61:	89 d7                	mov    %edx,%edi
  801f63:	89 f1                	mov    %esi,%ecx
  801f65:	d3 ef                	shr    %cl,%edi
  801f67:	09 c7                	or     %eax,%edi
  801f69:	89 e9                	mov    %ebp,%ecx
  801f6b:	d3 e2                	shl    %cl,%edx
  801f6d:	89 14 24             	mov    %edx,(%esp)
  801f70:	89 d8                	mov    %ebx,%eax
  801f72:	d3 e0                	shl    %cl,%eax
  801f74:	89 c2                	mov    %eax,%edx
  801f76:	8b 44 24 08          	mov    0x8(%esp),%eax
  801f7a:	d3 e0                	shl    %cl,%eax
  801f7c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f80:	8b 44 24 08          	mov    0x8(%esp),%eax
  801f84:	89 f1                	mov    %esi,%ecx
  801f86:	d3 e8                	shr    %cl,%eax
  801f88:	09 d0                	or     %edx,%eax
  801f8a:	d3 eb                	shr    %cl,%ebx
  801f8c:	89 da                	mov    %ebx,%edx
  801f8e:	f7 f7                	div    %edi
  801f90:	89 d3                	mov    %edx,%ebx
  801f92:	f7 24 24             	mull   (%esp)
  801f95:	89 c6                	mov    %eax,%esi
  801f97:	89 d1                	mov    %edx,%ecx
  801f99:	39 d3                	cmp    %edx,%ebx
  801f9b:	0f 82 87 00 00 00    	jb     802028 <__umoddi3+0x134>
  801fa1:	0f 84 91 00 00 00    	je     802038 <__umoddi3+0x144>
  801fa7:	8b 54 24 04          	mov    0x4(%esp),%edx
  801fab:	29 f2                	sub    %esi,%edx
  801fad:	19 cb                	sbb    %ecx,%ebx
  801faf:	89 d8                	mov    %ebx,%eax
  801fb1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801fb5:	d3 e0                	shl    %cl,%eax
  801fb7:	89 e9                	mov    %ebp,%ecx
  801fb9:	d3 ea                	shr    %cl,%edx
  801fbb:	09 d0                	or     %edx,%eax
  801fbd:	89 e9                	mov    %ebp,%ecx
  801fbf:	d3 eb                	shr    %cl,%ebx
  801fc1:	89 da                	mov    %ebx,%edx
  801fc3:	83 c4 1c             	add    $0x1c,%esp
  801fc6:	5b                   	pop    %ebx
  801fc7:	5e                   	pop    %esi
  801fc8:	5f                   	pop    %edi
  801fc9:	5d                   	pop    %ebp
  801fca:	c3                   	ret    
  801fcb:	90                   	nop
  801fcc:	89 fd                	mov    %edi,%ebp
  801fce:	85 ff                	test   %edi,%edi
  801fd0:	75 0b                	jne    801fdd <__umoddi3+0xe9>
  801fd2:	b8 01 00 00 00       	mov    $0x1,%eax
  801fd7:	31 d2                	xor    %edx,%edx
  801fd9:	f7 f7                	div    %edi
  801fdb:	89 c5                	mov    %eax,%ebp
  801fdd:	89 f0                	mov    %esi,%eax
  801fdf:	31 d2                	xor    %edx,%edx
  801fe1:	f7 f5                	div    %ebp
  801fe3:	89 c8                	mov    %ecx,%eax
  801fe5:	f7 f5                	div    %ebp
  801fe7:	89 d0                	mov    %edx,%eax
  801fe9:	e9 44 ff ff ff       	jmp    801f32 <__umoddi3+0x3e>
  801fee:	66 90                	xchg   %ax,%ax
  801ff0:	89 c8                	mov    %ecx,%eax
  801ff2:	89 f2                	mov    %esi,%edx
  801ff4:	83 c4 1c             	add    $0x1c,%esp
  801ff7:	5b                   	pop    %ebx
  801ff8:	5e                   	pop    %esi
  801ff9:	5f                   	pop    %edi
  801ffa:	5d                   	pop    %ebp
  801ffb:	c3                   	ret    
  801ffc:	3b 04 24             	cmp    (%esp),%eax
  801fff:	72 06                	jb     802007 <__umoddi3+0x113>
  802001:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802005:	77 0f                	ja     802016 <__umoddi3+0x122>
  802007:	89 f2                	mov    %esi,%edx
  802009:	29 f9                	sub    %edi,%ecx
  80200b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80200f:	89 14 24             	mov    %edx,(%esp)
  802012:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802016:	8b 44 24 04          	mov    0x4(%esp),%eax
  80201a:	8b 14 24             	mov    (%esp),%edx
  80201d:	83 c4 1c             	add    $0x1c,%esp
  802020:	5b                   	pop    %ebx
  802021:	5e                   	pop    %esi
  802022:	5f                   	pop    %edi
  802023:	5d                   	pop    %ebp
  802024:	c3                   	ret    
  802025:	8d 76 00             	lea    0x0(%esi),%esi
  802028:	2b 04 24             	sub    (%esp),%eax
  80202b:	19 fa                	sbb    %edi,%edx
  80202d:	89 d1                	mov    %edx,%ecx
  80202f:	89 c6                	mov    %eax,%esi
  802031:	e9 71 ff ff ff       	jmp    801fa7 <__umoddi3+0xb3>
  802036:	66 90                	xchg   %ax,%ax
  802038:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80203c:	72 ea                	jb     802028 <__umoddi3+0x134>
  80203e:	89 d9                	mov    %ebx,%ecx
  802040:	e9 62 ff ff ff       	jmp    801fa7 <__umoddi3+0xb3>

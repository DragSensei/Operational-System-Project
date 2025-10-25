
obj/user/tst_chan_all_master:     file format elf32-i386


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
  800031:	e8 99 01 00 00       	call   8001cf <libmain>
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
  80003e:	e8 c6 19 00 00       	call   801a09 <sys_getenvid>
  800043:	89 45 e8             	mov    %eax,-0x18(%ebp)
	char slavesCnt[10];
	readline("Enter the number of Slave Programs: ", slavesCnt);
  800046:	83 ec 08             	sub    $0x8,%esp
  800049:	8d 45 da             	lea    -0x26(%ebp),%eax
  80004c:	50                   	push   %eax
  80004d:	68 60 20 80 00       	push   $0x802060
  800052:	e8 cf 0c 00 00       	call   800d26 <readline>
  800057:	83 c4 10             	add    $0x10,%esp
	int numOfSlaves = strtol(slavesCnt, NULL, 10);
  80005a:	83 ec 04             	sub    $0x4,%esp
  80005d:	6a 0a                	push   $0xa
  80005f:	6a 00                	push   $0x0
  800061:	8d 45 da             	lea    -0x26(%ebp),%eax
  800064:	50                   	push   %eax
  800065:	e8 d3 12 00 00       	call   80133d <strtol>
  80006a:	83 c4 10             	add    $0x10,%esp
  80006d:	89 45 f4             	mov    %eax,-0xc(%ebp)

	//Create and run slave programs that should sleep
	int id;
	for (int i = 0; i < numOfSlaves; ++i)
  800070:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800077:	eb 68                	jmp    8000e1 <_main+0xa9>
	{
		id = sys_create_env("tstChanAllSlave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800079:	a1 20 30 80 00       	mov    0x803020,%eax
  80007e:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  800084:	a1 20 30 80 00       	mov    0x803020,%eax
  800089:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  80008f:	89 c1                	mov    %eax,%ecx
  800091:	a1 20 30 80 00       	mov    0x803020,%eax
  800096:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80009c:	52                   	push   %edx
  80009d:	51                   	push   %ecx
  80009e:	50                   	push   %eax
  80009f:	68 85 20 80 00       	push   $0x802085
  8000a4:	e8 0b 19 00 00       	call   8019b4 <sys_create_env>
  8000a9:	83 c4 10             	add    $0x10,%esp
  8000ac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (id== E_ENV_CREATION_ERROR)
  8000af:	83 7d e4 ef          	cmpl   $0xffffffef,-0x1c(%ebp)
  8000b3:	75 1b                	jne    8000d0 <_main+0x98>
		{
			cprintf("\n%~insufficient number of processes in the system! only %d slave processes are created\n", i);
  8000b5:	83 ec 08             	sub    $0x8,%esp
  8000b8:	ff 75 f0             	pushl  -0x10(%ebp)
  8000bb:	68 98 20 80 00       	push   $0x802098
  8000c0:	e8 88 05 00 00       	call   80064d <cprintf>
  8000c5:	83 c4 10             	add    $0x10,%esp
			numOfSlaves = i;
  8000c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
			break;
  8000ce:	eb 19                	jmp    8000e9 <_main+0xb1>
		}
		sys_run_env(id);
  8000d0:	83 ec 0c             	sub    $0xc,%esp
  8000d3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000d6:	e8 f7 18 00 00       	call   8019d2 <sys_run_env>
  8000db:	83 c4 10             	add    $0x10,%esp
	readline("Enter the number of Slave Programs: ", slavesCnt);
	int numOfSlaves = strtol(slavesCnt, NULL, 10);

	//Create and run slave programs that should sleep
	int id;
	for (int i = 0; i < numOfSlaves; ++i)
  8000de:	ff 45 f0             	incl   -0x10(%ebp)
  8000e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000e4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8000e7:	7c 90                	jl     800079 <_main+0x41>
		}
		sys_run_env(id);
	}

	//Wait until all slaves are blocked
	int numOfBlockedProcesses = 0;
  8000e9:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
	sys_utilities("__GetChanQueueSize__", (uint32)(&numOfBlockedProcesses));
  8000f0:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  8000f3:	83 ec 08             	sub    $0x8,%esp
  8000f6:	50                   	push   %eax
  8000f7:	68 f0 20 80 00       	push   $0x8020f0
  8000fc:	e8 57 1b 00 00       	call   801c58 <sys_utilities>
  800101:	83 c4 10             	add    $0x10,%esp
	int cnt = 0;
  800104:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	while (numOfBlockedProcesses != numOfSlaves)
  80010b:	eb 4a                	jmp    800157 <_main+0x11f>
	{
		env_sleep(1000);
  80010d:	83 ec 0c             	sub    $0xc,%esp
  800110:	68 e8 03 00 00       	push   $0x3e8
  800115:	e8 ca 1b 00 00       	call   801ce4 <env_sleep>
  80011a:	83 c4 10             	add    $0x10,%esp
		if (cnt == numOfSlaves)
  80011d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800120:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800123:	75 1b                	jne    800140 <_main+0x108>
		{
			panic("%~test channels failed! unexpected number of blocked slaves. Expected = %d, Current = %d", numOfSlaves, numOfBlockedProcesses);
  800125:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800128:	83 ec 0c             	sub    $0xc,%esp
  80012b:	50                   	push   %eax
  80012c:	ff 75 f4             	pushl  -0xc(%ebp)
  80012f:	68 08 21 80 00       	push   $0x802108
  800134:	6a 24                	push   $0x24
  800136:	68 61 21 80 00       	push   $0x802161
  80013b:	e8 3f 02 00 00       	call   80037f <_panic>
		}
		sys_utilities("__GetChanQueueSize__", (uint32)(&numOfBlockedProcesses));
  800140:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  800143:	83 ec 08             	sub    $0x8,%esp
  800146:	50                   	push   %eax
  800147:	68 f0 20 80 00       	push   $0x8020f0
  80014c:	e8 07 1b 00 00       	call   801c58 <sys_utilities>
  800151:	83 c4 10             	add    $0x10,%esp
		cnt++ ;
  800154:	ff 45 ec             	incl   -0x14(%ebp)

	//Wait until all slaves are blocked
	int numOfBlockedProcesses = 0;
	sys_utilities("__GetChanQueueSize__", (uint32)(&numOfBlockedProcesses));
	int cnt = 0;
	while (numOfBlockedProcesses != numOfSlaves)
  800157:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80015a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80015d:	75 ae                	jne    80010d <_main+0xd5>
		}
		sys_utilities("__GetChanQueueSize__", (uint32)(&numOfBlockedProcesses));
		cnt++ ;
	}

	rsttst();
  80015f:	e8 9c 19 00 00       	call   801b00 <rsttst>

	//Wakeup all
	sys_utilities("__WakeupAll__", 0);
  800164:	83 ec 08             	sub    $0x8,%esp
  800167:	6a 00                	push   $0x0
  800169:	68 7c 21 80 00       	push   $0x80217c
  80016e:	e8 e5 1a 00 00       	call   801c58 <sys_utilities>
  800173:	83 c4 10             	add    $0x10,%esp

	//Wait until all slave finished
	cnt = 0;
  800176:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	while (gettst() != numOfSlaves)
  80017d:	eb 2f                	jmp    8001ae <_main+0x176>
	{
		env_sleep(1000);
  80017f:	83 ec 0c             	sub    $0xc,%esp
  800182:	68 e8 03 00 00       	push   $0x3e8
  800187:	e8 58 1b 00 00       	call   801ce4 <env_sleep>
  80018c:	83 c4 10             	add    $0x10,%esp
		if (cnt == numOfSlaves)
  80018f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800192:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800195:	75 14                	jne    8001ab <_main+0x173>
		{
			panic("%~test channels failed! not all slaves finished");
  800197:	83 ec 04             	sub    $0x4,%esp
  80019a:	68 8c 21 80 00       	push   $0x80218c
  80019f:	6a 36                	push   $0x36
  8001a1:	68 61 21 80 00       	push   $0x802161
  8001a6:	e8 d4 01 00 00       	call   80037f <_panic>
		}
		cnt++ ;
  8001ab:	ff 45 ec             	incl   -0x14(%ebp)
	//Wakeup all
	sys_utilities("__WakeupAll__", 0);

	//Wait until all slave finished
	cnt = 0;
	while (gettst() != numOfSlaves)
  8001ae:	e8 c7 19 00 00       	call   801b7a <gettst>
  8001b3:	89 c2                	mov    %eax,%edx
  8001b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001b8:	39 c2                	cmp    %eax,%edx
  8001ba:	75 c3                	jne    80017f <_main+0x147>
			panic("%~test channels failed! not all slaves finished");
		}
		cnt++ ;
	}

	cprintf("%~\n\nCongratulations!! Test of Channel (sleep & wakeup ALL) completed successfully!!\n\n");
  8001bc:	83 ec 0c             	sub    $0xc,%esp
  8001bf:	68 bc 21 80 00       	push   $0x8021bc
  8001c4:	e8 84 04 00 00       	call   80064d <cprintf>
  8001c9:	83 c4 10             	add    $0x10,%esp

	return;
  8001cc:	90                   	nop
}
  8001cd:	c9                   	leave  
  8001ce:	c3                   	ret    

008001cf <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8001cf:	55                   	push   %ebp
  8001d0:	89 e5                	mov    %esp,%ebp
  8001d2:	57                   	push   %edi
  8001d3:	56                   	push   %esi
  8001d4:	53                   	push   %ebx
  8001d5:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8001d8:	e8 45 18 00 00       	call   801a22 <sys_getenvindex>
  8001dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8001e0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8001e3:	89 d0                	mov    %edx,%eax
  8001e5:	c1 e0 02             	shl    $0x2,%eax
  8001e8:	01 d0                	add    %edx,%eax
  8001ea:	c1 e0 03             	shl    $0x3,%eax
  8001ed:	01 d0                	add    %edx,%eax
  8001ef:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8001f6:	01 d0                	add    %edx,%eax
  8001f8:	c1 e0 02             	shl    $0x2,%eax
  8001fb:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800200:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800205:	a1 20 30 80 00       	mov    0x803020,%eax
  80020a:	8a 40 20             	mov    0x20(%eax),%al
  80020d:	84 c0                	test   %al,%al
  80020f:	74 0d                	je     80021e <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800211:	a1 20 30 80 00       	mov    0x803020,%eax
  800216:	83 c0 20             	add    $0x20,%eax
  800219:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80021e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800222:	7e 0a                	jle    80022e <libmain+0x5f>
		binaryname = argv[0];
  800224:	8b 45 0c             	mov    0xc(%ebp),%eax
  800227:	8b 00                	mov    (%eax),%eax
  800229:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  80022e:	83 ec 08             	sub    $0x8,%esp
  800231:	ff 75 0c             	pushl  0xc(%ebp)
  800234:	ff 75 08             	pushl  0x8(%ebp)
  800237:	e8 fc fd ff ff       	call   800038 <_main>
  80023c:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80023f:	a1 00 30 80 00       	mov    0x803000,%eax
  800244:	85 c0                	test   %eax,%eax
  800246:	0f 84 01 01 00 00    	je     80034d <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80024c:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800252:	bb 0c 23 80 00       	mov    $0x80230c,%ebx
  800257:	ba 0e 00 00 00       	mov    $0xe,%edx
  80025c:	89 c7                	mov    %eax,%edi
  80025e:	89 de                	mov    %ebx,%esi
  800260:	89 d1                	mov    %edx,%ecx
  800262:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800264:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800267:	b9 56 00 00 00       	mov    $0x56,%ecx
  80026c:	b0 00                	mov    $0x0,%al
  80026e:	89 d7                	mov    %edx,%edi
  800270:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800272:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800279:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80027c:	83 ec 08             	sub    $0x8,%esp
  80027f:	50                   	push   %eax
  800280:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800286:	50                   	push   %eax
  800287:	e8 cc 19 00 00       	call   801c58 <sys_utilities>
  80028c:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  80028f:	e8 15 15 00 00       	call   8017a9 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800294:	83 ec 0c             	sub    $0xc,%esp
  800297:	68 2c 22 80 00       	push   $0x80222c
  80029c:	e8 ac 03 00 00       	call   80064d <cprintf>
  8002a1:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8002a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002a7:	85 c0                	test   %eax,%eax
  8002a9:	74 18                	je     8002c3 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8002ab:	e8 c6 19 00 00       	call   801c76 <sys_get_optimal_num_faults>
  8002b0:	83 ec 08             	sub    $0x8,%esp
  8002b3:	50                   	push   %eax
  8002b4:	68 54 22 80 00       	push   $0x802254
  8002b9:	e8 8f 03 00 00       	call   80064d <cprintf>
  8002be:	83 c4 10             	add    $0x10,%esp
  8002c1:	eb 59                	jmp    80031c <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8002c3:	a1 20 30 80 00       	mov    0x803020,%eax
  8002c8:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8002ce:	a1 20 30 80 00       	mov    0x803020,%eax
  8002d3:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  8002d9:	83 ec 04             	sub    $0x4,%esp
  8002dc:	52                   	push   %edx
  8002dd:	50                   	push   %eax
  8002de:	68 78 22 80 00       	push   $0x802278
  8002e3:	e8 65 03 00 00       	call   80064d <cprintf>
  8002e8:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8002eb:	a1 20 30 80 00       	mov    0x803020,%eax
  8002f0:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8002f6:	a1 20 30 80 00       	mov    0x803020,%eax
  8002fb:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  800301:	a1 20 30 80 00       	mov    0x803020,%eax
  800306:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  80030c:	51                   	push   %ecx
  80030d:	52                   	push   %edx
  80030e:	50                   	push   %eax
  80030f:	68 a0 22 80 00       	push   $0x8022a0
  800314:	e8 34 03 00 00       	call   80064d <cprintf>
  800319:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80031c:	a1 20 30 80 00       	mov    0x803020,%eax
  800321:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  800327:	83 ec 08             	sub    $0x8,%esp
  80032a:	50                   	push   %eax
  80032b:	68 f8 22 80 00       	push   $0x8022f8
  800330:	e8 18 03 00 00       	call   80064d <cprintf>
  800335:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800338:	83 ec 0c             	sub    $0xc,%esp
  80033b:	68 2c 22 80 00       	push   $0x80222c
  800340:	e8 08 03 00 00       	call   80064d <cprintf>
  800345:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800348:	e8 76 14 00 00       	call   8017c3 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80034d:	e8 1f 00 00 00       	call   800371 <exit>
}
  800352:	90                   	nop
  800353:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800356:	5b                   	pop    %ebx
  800357:	5e                   	pop    %esi
  800358:	5f                   	pop    %edi
  800359:	5d                   	pop    %ebp
  80035a:	c3                   	ret    

0080035b <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80035b:	55                   	push   %ebp
  80035c:	89 e5                	mov    %esp,%ebp
  80035e:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800361:	83 ec 0c             	sub    $0xc,%esp
  800364:	6a 00                	push   $0x0
  800366:	e8 83 16 00 00       	call   8019ee <sys_destroy_env>
  80036b:	83 c4 10             	add    $0x10,%esp
}
  80036e:	90                   	nop
  80036f:	c9                   	leave  
  800370:	c3                   	ret    

00800371 <exit>:

void
exit(void)
{
  800371:	55                   	push   %ebp
  800372:	89 e5                	mov    %esp,%ebp
  800374:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800377:	e8 d8 16 00 00       	call   801a54 <sys_exit_env>
}
  80037c:	90                   	nop
  80037d:	c9                   	leave  
  80037e:	c3                   	ret    

0080037f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80037f:	55                   	push   %ebp
  800380:	89 e5                	mov    %esp,%ebp
  800382:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800385:	8d 45 10             	lea    0x10(%ebp),%eax
  800388:	83 c0 04             	add    $0x4,%eax
  80038b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80038e:	a1 18 b1 81 00       	mov    0x81b118,%eax
  800393:	85 c0                	test   %eax,%eax
  800395:	74 16                	je     8003ad <_panic+0x2e>
		cprintf("%s: ", argv0);
  800397:	a1 18 b1 81 00       	mov    0x81b118,%eax
  80039c:	83 ec 08             	sub    $0x8,%esp
  80039f:	50                   	push   %eax
  8003a0:	68 70 23 80 00       	push   $0x802370
  8003a5:	e8 a3 02 00 00       	call   80064d <cprintf>
  8003aa:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8003ad:	a1 04 30 80 00       	mov    0x803004,%eax
  8003b2:	83 ec 0c             	sub    $0xc,%esp
  8003b5:	ff 75 0c             	pushl  0xc(%ebp)
  8003b8:	ff 75 08             	pushl  0x8(%ebp)
  8003bb:	50                   	push   %eax
  8003bc:	68 78 23 80 00       	push   $0x802378
  8003c1:	6a 74                	push   $0x74
  8003c3:	e8 b2 02 00 00       	call   80067a <cprintf_colored>
  8003c8:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8003cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8003ce:	83 ec 08             	sub    $0x8,%esp
  8003d1:	ff 75 f4             	pushl  -0xc(%ebp)
  8003d4:	50                   	push   %eax
  8003d5:	e8 04 02 00 00       	call   8005de <vcprintf>
  8003da:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8003dd:	83 ec 08             	sub    $0x8,%esp
  8003e0:	6a 00                	push   $0x0
  8003e2:	68 a0 23 80 00       	push   $0x8023a0
  8003e7:	e8 f2 01 00 00       	call   8005de <vcprintf>
  8003ec:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8003ef:	e8 7d ff ff ff       	call   800371 <exit>

	// should not return here
	while (1) ;
  8003f4:	eb fe                	jmp    8003f4 <_panic+0x75>

008003f6 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8003f6:	55                   	push   %ebp
  8003f7:	89 e5                	mov    %esp,%ebp
  8003f9:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8003fc:	a1 20 30 80 00       	mov    0x803020,%eax
  800401:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800407:	8b 45 0c             	mov    0xc(%ebp),%eax
  80040a:	39 c2                	cmp    %eax,%edx
  80040c:	74 14                	je     800422 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80040e:	83 ec 04             	sub    $0x4,%esp
  800411:	68 a4 23 80 00       	push   $0x8023a4
  800416:	6a 26                	push   $0x26
  800418:	68 f0 23 80 00       	push   $0x8023f0
  80041d:	e8 5d ff ff ff       	call   80037f <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800422:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800429:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800430:	e9 c5 00 00 00       	jmp    8004fa <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800435:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800438:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80043f:	8b 45 08             	mov    0x8(%ebp),%eax
  800442:	01 d0                	add    %edx,%eax
  800444:	8b 00                	mov    (%eax),%eax
  800446:	85 c0                	test   %eax,%eax
  800448:	75 08                	jne    800452 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80044a:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80044d:	e9 a5 00 00 00       	jmp    8004f7 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800452:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800459:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800460:	eb 69                	jmp    8004cb <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800462:	a1 20 30 80 00       	mov    0x803020,%eax
  800467:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80046d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800470:	89 d0                	mov    %edx,%eax
  800472:	01 c0                	add    %eax,%eax
  800474:	01 d0                	add    %edx,%eax
  800476:	c1 e0 03             	shl    $0x3,%eax
  800479:	01 c8                	add    %ecx,%eax
  80047b:	8a 40 04             	mov    0x4(%eax),%al
  80047e:	84 c0                	test   %al,%al
  800480:	75 46                	jne    8004c8 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800482:	a1 20 30 80 00       	mov    0x803020,%eax
  800487:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80048d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800490:	89 d0                	mov    %edx,%eax
  800492:	01 c0                	add    %eax,%eax
  800494:	01 d0                	add    %edx,%eax
  800496:	c1 e0 03             	shl    $0x3,%eax
  800499:	01 c8                	add    %ecx,%eax
  80049b:	8b 00                	mov    (%eax),%eax
  80049d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8004a0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004a3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8004a8:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8004aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004ad:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8004b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b7:	01 c8                	add    %ecx,%eax
  8004b9:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004bb:	39 c2                	cmp    %eax,%edx
  8004bd:	75 09                	jne    8004c8 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8004bf:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8004c6:	eb 15                	jmp    8004dd <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004c8:	ff 45 e8             	incl   -0x18(%ebp)
  8004cb:	a1 20 30 80 00       	mov    0x803020,%eax
  8004d0:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004d9:	39 c2                	cmp    %eax,%edx
  8004db:	77 85                	ja     800462 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8004dd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8004e1:	75 14                	jne    8004f7 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8004e3:	83 ec 04             	sub    $0x4,%esp
  8004e6:	68 fc 23 80 00       	push   $0x8023fc
  8004eb:	6a 3a                	push   $0x3a
  8004ed:	68 f0 23 80 00       	push   $0x8023f0
  8004f2:	e8 88 fe ff ff       	call   80037f <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8004f7:	ff 45 f0             	incl   -0x10(%ebp)
  8004fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004fd:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800500:	0f 8c 2f ff ff ff    	jl     800435 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800506:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80050d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800514:	eb 26                	jmp    80053c <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800516:	a1 20 30 80 00       	mov    0x803020,%eax
  80051b:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800521:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800524:	89 d0                	mov    %edx,%eax
  800526:	01 c0                	add    %eax,%eax
  800528:	01 d0                	add    %edx,%eax
  80052a:	c1 e0 03             	shl    $0x3,%eax
  80052d:	01 c8                	add    %ecx,%eax
  80052f:	8a 40 04             	mov    0x4(%eax),%al
  800532:	3c 01                	cmp    $0x1,%al
  800534:	75 03                	jne    800539 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800536:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800539:	ff 45 e0             	incl   -0x20(%ebp)
  80053c:	a1 20 30 80 00       	mov    0x803020,%eax
  800541:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800547:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80054a:	39 c2                	cmp    %eax,%edx
  80054c:	77 c8                	ja     800516 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80054e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800551:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800554:	74 14                	je     80056a <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800556:	83 ec 04             	sub    $0x4,%esp
  800559:	68 50 24 80 00       	push   $0x802450
  80055e:	6a 44                	push   $0x44
  800560:	68 f0 23 80 00       	push   $0x8023f0
  800565:	e8 15 fe ff ff       	call   80037f <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80056a:	90                   	nop
  80056b:	c9                   	leave  
  80056c:	c3                   	ret    

0080056d <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80056d:	55                   	push   %ebp
  80056e:	89 e5                	mov    %esp,%ebp
  800570:	53                   	push   %ebx
  800571:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800574:	8b 45 0c             	mov    0xc(%ebp),%eax
  800577:	8b 00                	mov    (%eax),%eax
  800579:	8d 48 01             	lea    0x1(%eax),%ecx
  80057c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80057f:	89 0a                	mov    %ecx,(%edx)
  800581:	8b 55 08             	mov    0x8(%ebp),%edx
  800584:	88 d1                	mov    %dl,%cl
  800586:	8b 55 0c             	mov    0xc(%ebp),%edx
  800589:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80058d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800590:	8b 00                	mov    (%eax),%eax
  800592:	3d ff 00 00 00       	cmp    $0xff,%eax
  800597:	75 30                	jne    8005c9 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800599:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  80059f:	a0 44 30 80 00       	mov    0x803044,%al
  8005a4:	0f b6 c0             	movzbl %al,%eax
  8005a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005aa:	8b 09                	mov    (%ecx),%ecx
  8005ac:	89 cb                	mov    %ecx,%ebx
  8005ae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005b1:	83 c1 08             	add    $0x8,%ecx
  8005b4:	52                   	push   %edx
  8005b5:	50                   	push   %eax
  8005b6:	53                   	push   %ebx
  8005b7:	51                   	push   %ecx
  8005b8:	e8 a8 11 00 00       	call   801765 <sys_cputs>
  8005bd:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8005c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005c3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8005c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005cc:	8b 40 04             	mov    0x4(%eax),%eax
  8005cf:	8d 50 01             	lea    0x1(%eax),%edx
  8005d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005d5:	89 50 04             	mov    %edx,0x4(%eax)
}
  8005d8:	90                   	nop
  8005d9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8005dc:	c9                   	leave  
  8005dd:	c3                   	ret    

008005de <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8005de:	55                   	push   %ebp
  8005df:	89 e5                	mov    %esp,%ebp
  8005e1:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8005e7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005ee:	00 00 00 
	b.cnt = 0;
  8005f1:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8005f8:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8005fb:	ff 75 0c             	pushl  0xc(%ebp)
  8005fe:	ff 75 08             	pushl  0x8(%ebp)
  800601:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800607:	50                   	push   %eax
  800608:	68 6d 05 80 00       	push   $0x80056d
  80060d:	e8 5a 02 00 00       	call   80086c <vprintfmt>
  800612:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800615:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  80061b:	a0 44 30 80 00       	mov    0x803044,%al
  800620:	0f b6 c0             	movzbl %al,%eax
  800623:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800629:	52                   	push   %edx
  80062a:	50                   	push   %eax
  80062b:	51                   	push   %ecx
  80062c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800632:	83 c0 08             	add    $0x8,%eax
  800635:	50                   	push   %eax
  800636:	e8 2a 11 00 00       	call   801765 <sys_cputs>
  80063b:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80063e:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  800645:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80064b:	c9                   	leave  
  80064c:	c3                   	ret    

0080064d <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80064d:	55                   	push   %ebp
  80064e:	89 e5                	mov    %esp,%ebp
  800650:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800653:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  80065a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80065d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800660:	8b 45 08             	mov    0x8(%ebp),%eax
  800663:	83 ec 08             	sub    $0x8,%esp
  800666:	ff 75 f4             	pushl  -0xc(%ebp)
  800669:	50                   	push   %eax
  80066a:	e8 6f ff ff ff       	call   8005de <vcprintf>
  80066f:	83 c4 10             	add    $0x10,%esp
  800672:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800675:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800678:	c9                   	leave  
  800679:	c3                   	ret    

0080067a <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  80067a:	55                   	push   %ebp
  80067b:	89 e5                	mov    %esp,%ebp
  80067d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800680:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800687:	8b 45 08             	mov    0x8(%ebp),%eax
  80068a:	c1 e0 08             	shl    $0x8,%eax
  80068d:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  800692:	8d 45 0c             	lea    0xc(%ebp),%eax
  800695:	83 c0 04             	add    $0x4,%eax
  800698:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80069b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80069e:	83 ec 08             	sub    $0x8,%esp
  8006a1:	ff 75 f4             	pushl  -0xc(%ebp)
  8006a4:	50                   	push   %eax
  8006a5:	e8 34 ff ff ff       	call   8005de <vcprintf>
  8006aa:	83 c4 10             	add    $0x10,%esp
  8006ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8006b0:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  8006b7:	07 00 00 

	return cnt;
  8006ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006bd:	c9                   	leave  
  8006be:	c3                   	ret    

008006bf <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8006bf:	55                   	push   %ebp
  8006c0:	89 e5                	mov    %esp,%ebp
  8006c2:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8006c5:	e8 df 10 00 00       	call   8017a9 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8006ca:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8006d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d3:	83 ec 08             	sub    $0x8,%esp
  8006d6:	ff 75 f4             	pushl  -0xc(%ebp)
  8006d9:	50                   	push   %eax
  8006da:	e8 ff fe ff ff       	call   8005de <vcprintf>
  8006df:	83 c4 10             	add    $0x10,%esp
  8006e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8006e5:	e8 d9 10 00 00       	call   8017c3 <sys_unlock_cons>
	return cnt;
  8006ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006ed:	c9                   	leave  
  8006ee:	c3                   	ret    

008006ef <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006ef:	55                   	push   %ebp
  8006f0:	89 e5                	mov    %esp,%ebp
  8006f2:	53                   	push   %ebx
  8006f3:	83 ec 14             	sub    $0x14,%esp
  8006f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8006f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800702:	8b 45 18             	mov    0x18(%ebp),%eax
  800705:	ba 00 00 00 00       	mov    $0x0,%edx
  80070a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80070d:	77 55                	ja     800764 <printnum+0x75>
  80070f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800712:	72 05                	jb     800719 <printnum+0x2a>
  800714:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800717:	77 4b                	ja     800764 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800719:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80071c:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80071f:	8b 45 18             	mov    0x18(%ebp),%eax
  800722:	ba 00 00 00 00       	mov    $0x0,%edx
  800727:	52                   	push   %edx
  800728:	50                   	push   %eax
  800729:	ff 75 f4             	pushl  -0xc(%ebp)
  80072c:	ff 75 f0             	pushl  -0x10(%ebp)
  80072f:	e8 ac 16 00 00       	call   801de0 <__udivdi3>
  800734:	83 c4 10             	add    $0x10,%esp
  800737:	83 ec 04             	sub    $0x4,%esp
  80073a:	ff 75 20             	pushl  0x20(%ebp)
  80073d:	53                   	push   %ebx
  80073e:	ff 75 18             	pushl  0x18(%ebp)
  800741:	52                   	push   %edx
  800742:	50                   	push   %eax
  800743:	ff 75 0c             	pushl  0xc(%ebp)
  800746:	ff 75 08             	pushl  0x8(%ebp)
  800749:	e8 a1 ff ff ff       	call   8006ef <printnum>
  80074e:	83 c4 20             	add    $0x20,%esp
  800751:	eb 1a                	jmp    80076d <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800753:	83 ec 08             	sub    $0x8,%esp
  800756:	ff 75 0c             	pushl  0xc(%ebp)
  800759:	ff 75 20             	pushl  0x20(%ebp)
  80075c:	8b 45 08             	mov    0x8(%ebp),%eax
  80075f:	ff d0                	call   *%eax
  800761:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800764:	ff 4d 1c             	decl   0x1c(%ebp)
  800767:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80076b:	7f e6                	jg     800753 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80076d:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800770:	bb 00 00 00 00       	mov    $0x0,%ebx
  800775:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800778:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80077b:	53                   	push   %ebx
  80077c:	51                   	push   %ecx
  80077d:	52                   	push   %edx
  80077e:	50                   	push   %eax
  80077f:	e8 6c 17 00 00       	call   801ef0 <__umoddi3>
  800784:	83 c4 10             	add    $0x10,%esp
  800787:	05 b4 26 80 00       	add    $0x8026b4,%eax
  80078c:	8a 00                	mov    (%eax),%al
  80078e:	0f be c0             	movsbl %al,%eax
  800791:	83 ec 08             	sub    $0x8,%esp
  800794:	ff 75 0c             	pushl  0xc(%ebp)
  800797:	50                   	push   %eax
  800798:	8b 45 08             	mov    0x8(%ebp),%eax
  80079b:	ff d0                	call   *%eax
  80079d:	83 c4 10             	add    $0x10,%esp
}
  8007a0:	90                   	nop
  8007a1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007a4:	c9                   	leave  
  8007a5:	c3                   	ret    

008007a6 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007a6:	55                   	push   %ebp
  8007a7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007a9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007ad:	7e 1c                	jle    8007cb <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8007af:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b2:	8b 00                	mov    (%eax),%eax
  8007b4:	8d 50 08             	lea    0x8(%eax),%edx
  8007b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ba:	89 10                	mov    %edx,(%eax)
  8007bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bf:	8b 00                	mov    (%eax),%eax
  8007c1:	83 e8 08             	sub    $0x8,%eax
  8007c4:	8b 50 04             	mov    0x4(%eax),%edx
  8007c7:	8b 00                	mov    (%eax),%eax
  8007c9:	eb 40                	jmp    80080b <getuint+0x65>
	else if (lflag)
  8007cb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007cf:	74 1e                	je     8007ef <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8007d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d4:	8b 00                	mov    (%eax),%eax
  8007d6:	8d 50 04             	lea    0x4(%eax),%edx
  8007d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007dc:	89 10                	mov    %edx,(%eax)
  8007de:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e1:	8b 00                	mov    (%eax),%eax
  8007e3:	83 e8 04             	sub    $0x4,%eax
  8007e6:	8b 00                	mov    (%eax),%eax
  8007e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8007ed:	eb 1c                	jmp    80080b <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8007ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f2:	8b 00                	mov    (%eax),%eax
  8007f4:	8d 50 04             	lea    0x4(%eax),%edx
  8007f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fa:	89 10                	mov    %edx,(%eax)
  8007fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ff:	8b 00                	mov    (%eax),%eax
  800801:	83 e8 04             	sub    $0x4,%eax
  800804:	8b 00                	mov    (%eax),%eax
  800806:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80080b:	5d                   	pop    %ebp
  80080c:	c3                   	ret    

0080080d <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80080d:	55                   	push   %ebp
  80080e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800810:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800814:	7e 1c                	jle    800832 <getint+0x25>
		return va_arg(*ap, long long);
  800816:	8b 45 08             	mov    0x8(%ebp),%eax
  800819:	8b 00                	mov    (%eax),%eax
  80081b:	8d 50 08             	lea    0x8(%eax),%edx
  80081e:	8b 45 08             	mov    0x8(%ebp),%eax
  800821:	89 10                	mov    %edx,(%eax)
  800823:	8b 45 08             	mov    0x8(%ebp),%eax
  800826:	8b 00                	mov    (%eax),%eax
  800828:	83 e8 08             	sub    $0x8,%eax
  80082b:	8b 50 04             	mov    0x4(%eax),%edx
  80082e:	8b 00                	mov    (%eax),%eax
  800830:	eb 38                	jmp    80086a <getint+0x5d>
	else if (lflag)
  800832:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800836:	74 1a                	je     800852 <getint+0x45>
		return va_arg(*ap, long);
  800838:	8b 45 08             	mov    0x8(%ebp),%eax
  80083b:	8b 00                	mov    (%eax),%eax
  80083d:	8d 50 04             	lea    0x4(%eax),%edx
  800840:	8b 45 08             	mov    0x8(%ebp),%eax
  800843:	89 10                	mov    %edx,(%eax)
  800845:	8b 45 08             	mov    0x8(%ebp),%eax
  800848:	8b 00                	mov    (%eax),%eax
  80084a:	83 e8 04             	sub    $0x4,%eax
  80084d:	8b 00                	mov    (%eax),%eax
  80084f:	99                   	cltd   
  800850:	eb 18                	jmp    80086a <getint+0x5d>
	else
		return va_arg(*ap, int);
  800852:	8b 45 08             	mov    0x8(%ebp),%eax
  800855:	8b 00                	mov    (%eax),%eax
  800857:	8d 50 04             	lea    0x4(%eax),%edx
  80085a:	8b 45 08             	mov    0x8(%ebp),%eax
  80085d:	89 10                	mov    %edx,(%eax)
  80085f:	8b 45 08             	mov    0x8(%ebp),%eax
  800862:	8b 00                	mov    (%eax),%eax
  800864:	83 e8 04             	sub    $0x4,%eax
  800867:	8b 00                	mov    (%eax),%eax
  800869:	99                   	cltd   
}
  80086a:	5d                   	pop    %ebp
  80086b:	c3                   	ret    

0080086c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80086c:	55                   	push   %ebp
  80086d:	89 e5                	mov    %esp,%ebp
  80086f:	56                   	push   %esi
  800870:	53                   	push   %ebx
  800871:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800874:	eb 17                	jmp    80088d <vprintfmt+0x21>
			if (ch == '\0')
  800876:	85 db                	test   %ebx,%ebx
  800878:	0f 84 c1 03 00 00    	je     800c3f <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80087e:	83 ec 08             	sub    $0x8,%esp
  800881:	ff 75 0c             	pushl  0xc(%ebp)
  800884:	53                   	push   %ebx
  800885:	8b 45 08             	mov    0x8(%ebp),%eax
  800888:	ff d0                	call   *%eax
  80088a:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80088d:	8b 45 10             	mov    0x10(%ebp),%eax
  800890:	8d 50 01             	lea    0x1(%eax),%edx
  800893:	89 55 10             	mov    %edx,0x10(%ebp)
  800896:	8a 00                	mov    (%eax),%al
  800898:	0f b6 d8             	movzbl %al,%ebx
  80089b:	83 fb 25             	cmp    $0x25,%ebx
  80089e:	75 d6                	jne    800876 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008a0:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8008a4:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8008ab:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8008b2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8008b9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8008c3:	8d 50 01             	lea    0x1(%eax),%edx
  8008c6:	89 55 10             	mov    %edx,0x10(%ebp)
  8008c9:	8a 00                	mov    (%eax),%al
  8008cb:	0f b6 d8             	movzbl %al,%ebx
  8008ce:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8008d1:	83 f8 5b             	cmp    $0x5b,%eax
  8008d4:	0f 87 3d 03 00 00    	ja     800c17 <vprintfmt+0x3ab>
  8008da:	8b 04 85 d8 26 80 00 	mov    0x8026d8(,%eax,4),%eax
  8008e1:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8008e3:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8008e7:	eb d7                	jmp    8008c0 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008e9:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8008ed:	eb d1                	jmp    8008c0 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008ef:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8008f6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008f9:	89 d0                	mov    %edx,%eax
  8008fb:	c1 e0 02             	shl    $0x2,%eax
  8008fe:	01 d0                	add    %edx,%eax
  800900:	01 c0                	add    %eax,%eax
  800902:	01 d8                	add    %ebx,%eax
  800904:	83 e8 30             	sub    $0x30,%eax
  800907:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80090a:	8b 45 10             	mov    0x10(%ebp),%eax
  80090d:	8a 00                	mov    (%eax),%al
  80090f:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800912:	83 fb 2f             	cmp    $0x2f,%ebx
  800915:	7e 3e                	jle    800955 <vprintfmt+0xe9>
  800917:	83 fb 39             	cmp    $0x39,%ebx
  80091a:	7f 39                	jg     800955 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80091c:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80091f:	eb d5                	jmp    8008f6 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800921:	8b 45 14             	mov    0x14(%ebp),%eax
  800924:	83 c0 04             	add    $0x4,%eax
  800927:	89 45 14             	mov    %eax,0x14(%ebp)
  80092a:	8b 45 14             	mov    0x14(%ebp),%eax
  80092d:	83 e8 04             	sub    $0x4,%eax
  800930:	8b 00                	mov    (%eax),%eax
  800932:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800935:	eb 1f                	jmp    800956 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800937:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80093b:	79 83                	jns    8008c0 <vprintfmt+0x54>
				width = 0;
  80093d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800944:	e9 77 ff ff ff       	jmp    8008c0 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800949:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800950:	e9 6b ff ff ff       	jmp    8008c0 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800955:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800956:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80095a:	0f 89 60 ff ff ff    	jns    8008c0 <vprintfmt+0x54>
				width = precision, precision = -1;
  800960:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800963:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800966:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80096d:	e9 4e ff ff ff       	jmp    8008c0 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800972:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800975:	e9 46 ff ff ff       	jmp    8008c0 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80097a:	8b 45 14             	mov    0x14(%ebp),%eax
  80097d:	83 c0 04             	add    $0x4,%eax
  800980:	89 45 14             	mov    %eax,0x14(%ebp)
  800983:	8b 45 14             	mov    0x14(%ebp),%eax
  800986:	83 e8 04             	sub    $0x4,%eax
  800989:	8b 00                	mov    (%eax),%eax
  80098b:	83 ec 08             	sub    $0x8,%esp
  80098e:	ff 75 0c             	pushl  0xc(%ebp)
  800991:	50                   	push   %eax
  800992:	8b 45 08             	mov    0x8(%ebp),%eax
  800995:	ff d0                	call   *%eax
  800997:	83 c4 10             	add    $0x10,%esp
			break;
  80099a:	e9 9b 02 00 00       	jmp    800c3a <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80099f:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a2:	83 c0 04             	add    $0x4,%eax
  8009a5:	89 45 14             	mov    %eax,0x14(%ebp)
  8009a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ab:	83 e8 04             	sub    $0x4,%eax
  8009ae:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8009b0:	85 db                	test   %ebx,%ebx
  8009b2:	79 02                	jns    8009b6 <vprintfmt+0x14a>
				err = -err;
  8009b4:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8009b6:	83 fb 64             	cmp    $0x64,%ebx
  8009b9:	7f 0b                	jg     8009c6 <vprintfmt+0x15a>
  8009bb:	8b 34 9d 20 25 80 00 	mov    0x802520(,%ebx,4),%esi
  8009c2:	85 f6                	test   %esi,%esi
  8009c4:	75 19                	jne    8009df <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009c6:	53                   	push   %ebx
  8009c7:	68 c5 26 80 00       	push   $0x8026c5
  8009cc:	ff 75 0c             	pushl  0xc(%ebp)
  8009cf:	ff 75 08             	pushl  0x8(%ebp)
  8009d2:	e8 70 02 00 00       	call   800c47 <printfmt>
  8009d7:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8009da:	e9 5b 02 00 00       	jmp    800c3a <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8009df:	56                   	push   %esi
  8009e0:	68 ce 26 80 00       	push   $0x8026ce
  8009e5:	ff 75 0c             	pushl  0xc(%ebp)
  8009e8:	ff 75 08             	pushl  0x8(%ebp)
  8009eb:	e8 57 02 00 00       	call   800c47 <printfmt>
  8009f0:	83 c4 10             	add    $0x10,%esp
			break;
  8009f3:	e9 42 02 00 00       	jmp    800c3a <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8009f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8009fb:	83 c0 04             	add    $0x4,%eax
  8009fe:	89 45 14             	mov    %eax,0x14(%ebp)
  800a01:	8b 45 14             	mov    0x14(%ebp),%eax
  800a04:	83 e8 04             	sub    $0x4,%eax
  800a07:	8b 30                	mov    (%eax),%esi
  800a09:	85 f6                	test   %esi,%esi
  800a0b:	75 05                	jne    800a12 <vprintfmt+0x1a6>
				p = "(null)";
  800a0d:	be d1 26 80 00       	mov    $0x8026d1,%esi
			if (width > 0 && padc != '-')
  800a12:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a16:	7e 6d                	jle    800a85 <vprintfmt+0x219>
  800a18:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800a1c:	74 67                	je     800a85 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a1e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a21:	83 ec 08             	sub    $0x8,%esp
  800a24:	50                   	push   %eax
  800a25:	56                   	push   %esi
  800a26:	e8 26 05 00 00       	call   800f51 <strnlen>
  800a2b:	83 c4 10             	add    $0x10,%esp
  800a2e:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800a31:	eb 16                	jmp    800a49 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800a33:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800a37:	83 ec 08             	sub    $0x8,%esp
  800a3a:	ff 75 0c             	pushl  0xc(%ebp)
  800a3d:	50                   	push   %eax
  800a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a41:	ff d0                	call   *%eax
  800a43:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a46:	ff 4d e4             	decl   -0x1c(%ebp)
  800a49:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a4d:	7f e4                	jg     800a33 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a4f:	eb 34                	jmp    800a85 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a51:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a55:	74 1c                	je     800a73 <vprintfmt+0x207>
  800a57:	83 fb 1f             	cmp    $0x1f,%ebx
  800a5a:	7e 05                	jle    800a61 <vprintfmt+0x1f5>
  800a5c:	83 fb 7e             	cmp    $0x7e,%ebx
  800a5f:	7e 12                	jle    800a73 <vprintfmt+0x207>
					putch('?', putdat);
  800a61:	83 ec 08             	sub    $0x8,%esp
  800a64:	ff 75 0c             	pushl  0xc(%ebp)
  800a67:	6a 3f                	push   $0x3f
  800a69:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6c:	ff d0                	call   *%eax
  800a6e:	83 c4 10             	add    $0x10,%esp
  800a71:	eb 0f                	jmp    800a82 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a73:	83 ec 08             	sub    $0x8,%esp
  800a76:	ff 75 0c             	pushl  0xc(%ebp)
  800a79:	53                   	push   %ebx
  800a7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7d:	ff d0                	call   *%eax
  800a7f:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a82:	ff 4d e4             	decl   -0x1c(%ebp)
  800a85:	89 f0                	mov    %esi,%eax
  800a87:	8d 70 01             	lea    0x1(%eax),%esi
  800a8a:	8a 00                	mov    (%eax),%al
  800a8c:	0f be d8             	movsbl %al,%ebx
  800a8f:	85 db                	test   %ebx,%ebx
  800a91:	74 24                	je     800ab7 <vprintfmt+0x24b>
  800a93:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a97:	78 b8                	js     800a51 <vprintfmt+0x1e5>
  800a99:	ff 4d e0             	decl   -0x20(%ebp)
  800a9c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800aa0:	79 af                	jns    800a51 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800aa2:	eb 13                	jmp    800ab7 <vprintfmt+0x24b>
				putch(' ', putdat);
  800aa4:	83 ec 08             	sub    $0x8,%esp
  800aa7:	ff 75 0c             	pushl  0xc(%ebp)
  800aaa:	6a 20                	push   $0x20
  800aac:	8b 45 08             	mov    0x8(%ebp),%eax
  800aaf:	ff d0                	call   *%eax
  800ab1:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ab4:	ff 4d e4             	decl   -0x1c(%ebp)
  800ab7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800abb:	7f e7                	jg     800aa4 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800abd:	e9 78 01 00 00       	jmp    800c3a <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ac2:	83 ec 08             	sub    $0x8,%esp
  800ac5:	ff 75 e8             	pushl  -0x18(%ebp)
  800ac8:	8d 45 14             	lea    0x14(%ebp),%eax
  800acb:	50                   	push   %eax
  800acc:	e8 3c fd ff ff       	call   80080d <getint>
  800ad1:	83 c4 10             	add    $0x10,%esp
  800ad4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ad7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800ada:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800add:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ae0:	85 d2                	test   %edx,%edx
  800ae2:	79 23                	jns    800b07 <vprintfmt+0x29b>
				putch('-', putdat);
  800ae4:	83 ec 08             	sub    $0x8,%esp
  800ae7:	ff 75 0c             	pushl  0xc(%ebp)
  800aea:	6a 2d                	push   $0x2d
  800aec:	8b 45 08             	mov    0x8(%ebp),%eax
  800aef:	ff d0                	call   *%eax
  800af1:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800af4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800af7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800afa:	f7 d8                	neg    %eax
  800afc:	83 d2 00             	adc    $0x0,%edx
  800aff:	f7 da                	neg    %edx
  800b01:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b04:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800b07:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b0e:	e9 bc 00 00 00       	jmp    800bcf <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b13:	83 ec 08             	sub    $0x8,%esp
  800b16:	ff 75 e8             	pushl  -0x18(%ebp)
  800b19:	8d 45 14             	lea    0x14(%ebp),%eax
  800b1c:	50                   	push   %eax
  800b1d:	e8 84 fc ff ff       	call   8007a6 <getuint>
  800b22:	83 c4 10             	add    $0x10,%esp
  800b25:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b28:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800b2b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b32:	e9 98 00 00 00       	jmp    800bcf <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b37:	83 ec 08             	sub    $0x8,%esp
  800b3a:	ff 75 0c             	pushl  0xc(%ebp)
  800b3d:	6a 58                	push   $0x58
  800b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b42:	ff d0                	call   *%eax
  800b44:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b47:	83 ec 08             	sub    $0x8,%esp
  800b4a:	ff 75 0c             	pushl  0xc(%ebp)
  800b4d:	6a 58                	push   $0x58
  800b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b52:	ff d0                	call   *%eax
  800b54:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b57:	83 ec 08             	sub    $0x8,%esp
  800b5a:	ff 75 0c             	pushl  0xc(%ebp)
  800b5d:	6a 58                	push   $0x58
  800b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b62:	ff d0                	call   *%eax
  800b64:	83 c4 10             	add    $0x10,%esp
			break;
  800b67:	e9 ce 00 00 00       	jmp    800c3a <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800b6c:	83 ec 08             	sub    $0x8,%esp
  800b6f:	ff 75 0c             	pushl  0xc(%ebp)
  800b72:	6a 30                	push   $0x30
  800b74:	8b 45 08             	mov    0x8(%ebp),%eax
  800b77:	ff d0                	call   *%eax
  800b79:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b7c:	83 ec 08             	sub    $0x8,%esp
  800b7f:	ff 75 0c             	pushl  0xc(%ebp)
  800b82:	6a 78                	push   $0x78
  800b84:	8b 45 08             	mov    0x8(%ebp),%eax
  800b87:	ff d0                	call   *%eax
  800b89:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b8c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b8f:	83 c0 04             	add    $0x4,%eax
  800b92:	89 45 14             	mov    %eax,0x14(%ebp)
  800b95:	8b 45 14             	mov    0x14(%ebp),%eax
  800b98:	83 e8 04             	sub    $0x4,%eax
  800b9b:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ba0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ba7:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800bae:	eb 1f                	jmp    800bcf <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800bb0:	83 ec 08             	sub    $0x8,%esp
  800bb3:	ff 75 e8             	pushl  -0x18(%ebp)
  800bb6:	8d 45 14             	lea    0x14(%ebp),%eax
  800bb9:	50                   	push   %eax
  800bba:	e8 e7 fb ff ff       	call   8007a6 <getuint>
  800bbf:	83 c4 10             	add    $0x10,%esp
  800bc2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bc5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800bc8:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800bcf:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800bd3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bd6:	83 ec 04             	sub    $0x4,%esp
  800bd9:	52                   	push   %edx
  800bda:	ff 75 e4             	pushl  -0x1c(%ebp)
  800bdd:	50                   	push   %eax
  800bde:	ff 75 f4             	pushl  -0xc(%ebp)
  800be1:	ff 75 f0             	pushl  -0x10(%ebp)
  800be4:	ff 75 0c             	pushl  0xc(%ebp)
  800be7:	ff 75 08             	pushl  0x8(%ebp)
  800bea:	e8 00 fb ff ff       	call   8006ef <printnum>
  800bef:	83 c4 20             	add    $0x20,%esp
			break;
  800bf2:	eb 46                	jmp    800c3a <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800bf4:	83 ec 08             	sub    $0x8,%esp
  800bf7:	ff 75 0c             	pushl  0xc(%ebp)
  800bfa:	53                   	push   %ebx
  800bfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfe:	ff d0                	call   *%eax
  800c00:	83 c4 10             	add    $0x10,%esp
			break;
  800c03:	eb 35                	jmp    800c3a <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800c05:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800c0c:	eb 2c                	jmp    800c3a <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800c0e:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800c15:	eb 23                	jmp    800c3a <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c17:	83 ec 08             	sub    $0x8,%esp
  800c1a:	ff 75 0c             	pushl  0xc(%ebp)
  800c1d:	6a 25                	push   $0x25
  800c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c22:	ff d0                	call   *%eax
  800c24:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c27:	ff 4d 10             	decl   0x10(%ebp)
  800c2a:	eb 03                	jmp    800c2f <vprintfmt+0x3c3>
  800c2c:	ff 4d 10             	decl   0x10(%ebp)
  800c2f:	8b 45 10             	mov    0x10(%ebp),%eax
  800c32:	48                   	dec    %eax
  800c33:	8a 00                	mov    (%eax),%al
  800c35:	3c 25                	cmp    $0x25,%al
  800c37:	75 f3                	jne    800c2c <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800c39:	90                   	nop
		}
	}
  800c3a:	e9 35 fc ff ff       	jmp    800874 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800c3f:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800c40:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c43:	5b                   	pop    %ebx
  800c44:	5e                   	pop    %esi
  800c45:	5d                   	pop    %ebp
  800c46:	c3                   	ret    

00800c47 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c47:	55                   	push   %ebp
  800c48:	89 e5                	mov    %esp,%ebp
  800c4a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c4d:	8d 45 10             	lea    0x10(%ebp),%eax
  800c50:	83 c0 04             	add    $0x4,%eax
  800c53:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c56:	8b 45 10             	mov    0x10(%ebp),%eax
  800c59:	ff 75 f4             	pushl  -0xc(%ebp)
  800c5c:	50                   	push   %eax
  800c5d:	ff 75 0c             	pushl  0xc(%ebp)
  800c60:	ff 75 08             	pushl  0x8(%ebp)
  800c63:	e8 04 fc ff ff       	call   80086c <vprintfmt>
  800c68:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c6b:	90                   	nop
  800c6c:	c9                   	leave  
  800c6d:	c3                   	ret    

00800c6e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c6e:	55                   	push   %ebp
  800c6f:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c71:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c74:	8b 40 08             	mov    0x8(%eax),%eax
  800c77:	8d 50 01             	lea    0x1(%eax),%edx
  800c7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c7d:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c83:	8b 10                	mov    (%eax),%edx
  800c85:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c88:	8b 40 04             	mov    0x4(%eax),%eax
  800c8b:	39 c2                	cmp    %eax,%edx
  800c8d:	73 12                	jae    800ca1 <sprintputch+0x33>
		*b->buf++ = ch;
  800c8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c92:	8b 00                	mov    (%eax),%eax
  800c94:	8d 48 01             	lea    0x1(%eax),%ecx
  800c97:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c9a:	89 0a                	mov    %ecx,(%edx)
  800c9c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c9f:	88 10                	mov    %dl,(%eax)
}
  800ca1:	90                   	nop
  800ca2:	5d                   	pop    %ebp
  800ca3:	c3                   	ret    

00800ca4 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ca4:	55                   	push   %ebp
  800ca5:	89 e5                	mov    %esp,%ebp
  800ca7:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800caa:	8b 45 08             	mov    0x8(%ebp),%eax
  800cad:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800cb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb3:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb9:	01 d0                	add    %edx,%eax
  800cbb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cbe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800cc5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800cc9:	74 06                	je     800cd1 <vsnprintf+0x2d>
  800ccb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ccf:	7f 07                	jg     800cd8 <vsnprintf+0x34>
		return -E_INVAL;
  800cd1:	b8 03 00 00 00       	mov    $0x3,%eax
  800cd6:	eb 20                	jmp    800cf8 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800cd8:	ff 75 14             	pushl  0x14(%ebp)
  800cdb:	ff 75 10             	pushl  0x10(%ebp)
  800cde:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ce1:	50                   	push   %eax
  800ce2:	68 6e 0c 80 00       	push   $0x800c6e
  800ce7:	e8 80 fb ff ff       	call   80086c <vprintfmt>
  800cec:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800cef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cf2:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800cf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800cf8:	c9                   	leave  
  800cf9:	c3                   	ret    

00800cfa <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800cfa:	55                   	push   %ebp
  800cfb:	89 e5                	mov    %esp,%ebp
  800cfd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d00:	8d 45 10             	lea    0x10(%ebp),%eax
  800d03:	83 c0 04             	add    $0x4,%eax
  800d06:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800d09:	8b 45 10             	mov    0x10(%ebp),%eax
  800d0c:	ff 75 f4             	pushl  -0xc(%ebp)
  800d0f:	50                   	push   %eax
  800d10:	ff 75 0c             	pushl  0xc(%ebp)
  800d13:	ff 75 08             	pushl  0x8(%ebp)
  800d16:	e8 89 ff ff ff       	call   800ca4 <vsnprintf>
  800d1b:	83 c4 10             	add    $0x10,%esp
  800d1e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800d21:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d24:	c9                   	leave  
  800d25:	c3                   	ret    

00800d26 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  800d26:	55                   	push   %ebp
  800d27:	89 e5                	mov    %esp,%ebp
  800d29:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  800d2c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d30:	74 13                	je     800d45 <readline+0x1f>
		cprintf("%s", prompt);
  800d32:	83 ec 08             	sub    $0x8,%esp
  800d35:	ff 75 08             	pushl  0x8(%ebp)
  800d38:	68 48 28 80 00       	push   $0x802848
  800d3d:	e8 0b f9 ff ff       	call   80064d <cprintf>
  800d42:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800d45:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800d4c:	83 ec 0c             	sub    $0xc,%esp
  800d4f:	6a 00                	push   $0x0
  800d51:	e8 7e 10 00 00       	call   801dd4 <iscons>
  800d56:	83 c4 10             	add    $0x10,%esp
  800d59:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800d5c:	e8 60 10 00 00       	call   801dc1 <getchar>
  800d61:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800d64:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800d68:	79 22                	jns    800d8c <readline+0x66>
			if (c != -E_EOF)
  800d6a:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800d6e:	0f 84 ad 00 00 00    	je     800e21 <readline+0xfb>
				cprintf("read error: %e\n", c);
  800d74:	83 ec 08             	sub    $0x8,%esp
  800d77:	ff 75 ec             	pushl  -0x14(%ebp)
  800d7a:	68 4b 28 80 00       	push   $0x80284b
  800d7f:	e8 c9 f8 ff ff       	call   80064d <cprintf>
  800d84:	83 c4 10             	add    $0x10,%esp
			break;
  800d87:	e9 95 00 00 00       	jmp    800e21 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800d8c:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800d90:	7e 34                	jle    800dc6 <readline+0xa0>
  800d92:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800d99:	7f 2b                	jg     800dc6 <readline+0xa0>
			if (echoing)
  800d9b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800d9f:	74 0e                	je     800daf <readline+0x89>
				cputchar(c);
  800da1:	83 ec 0c             	sub    $0xc,%esp
  800da4:	ff 75 ec             	pushl  -0x14(%ebp)
  800da7:	e8 f6 0f 00 00       	call   801da2 <cputchar>
  800dac:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800daf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800db2:	8d 50 01             	lea    0x1(%eax),%edx
  800db5:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800db8:	89 c2                	mov    %eax,%edx
  800dba:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dbd:	01 d0                	add    %edx,%eax
  800dbf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800dc2:	88 10                	mov    %dl,(%eax)
  800dc4:	eb 56                	jmp    800e1c <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  800dc6:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800dca:	75 1f                	jne    800deb <readline+0xc5>
  800dcc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800dd0:	7e 19                	jle    800deb <readline+0xc5>
			if (echoing)
  800dd2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800dd6:	74 0e                	je     800de6 <readline+0xc0>
				cputchar(c);
  800dd8:	83 ec 0c             	sub    $0xc,%esp
  800ddb:	ff 75 ec             	pushl  -0x14(%ebp)
  800dde:	e8 bf 0f 00 00       	call   801da2 <cputchar>
  800de3:	83 c4 10             	add    $0x10,%esp

			i--;
  800de6:	ff 4d f4             	decl   -0xc(%ebp)
  800de9:	eb 31                	jmp    800e1c <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800deb:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800def:	74 0a                	je     800dfb <readline+0xd5>
  800df1:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800df5:	0f 85 61 ff ff ff    	jne    800d5c <readline+0x36>
			if (echoing)
  800dfb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800dff:	74 0e                	je     800e0f <readline+0xe9>
				cputchar(c);
  800e01:	83 ec 0c             	sub    $0xc,%esp
  800e04:	ff 75 ec             	pushl  -0x14(%ebp)
  800e07:	e8 96 0f 00 00       	call   801da2 <cputchar>
  800e0c:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800e0f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e12:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e15:	01 d0                	add    %edx,%eax
  800e17:	c6 00 00             	movb   $0x0,(%eax)
			break;
  800e1a:	eb 06                	jmp    800e22 <readline+0xfc>
		}
	}
  800e1c:	e9 3b ff ff ff       	jmp    800d5c <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  800e21:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  800e22:	90                   	nop
  800e23:	c9                   	leave  
  800e24:	c3                   	ret    

00800e25 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800e25:	55                   	push   %ebp
  800e26:	89 e5                	mov    %esp,%ebp
  800e28:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  800e2b:	e8 79 09 00 00       	call   8017a9 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  800e30:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e34:	74 13                	je     800e49 <atomic_readline+0x24>
			cprintf("%s", prompt);
  800e36:	83 ec 08             	sub    $0x8,%esp
  800e39:	ff 75 08             	pushl  0x8(%ebp)
  800e3c:	68 48 28 80 00       	push   $0x802848
  800e41:	e8 07 f8 ff ff       	call   80064d <cprintf>
  800e46:	83 c4 10             	add    $0x10,%esp

		i = 0;
  800e49:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  800e50:	83 ec 0c             	sub    $0xc,%esp
  800e53:	6a 00                	push   $0x0
  800e55:	e8 7a 0f 00 00       	call   801dd4 <iscons>
  800e5a:	83 c4 10             	add    $0x10,%esp
  800e5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  800e60:	e8 5c 0f 00 00       	call   801dc1 <getchar>
  800e65:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  800e68:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800e6c:	79 22                	jns    800e90 <atomic_readline+0x6b>
				if (c != -E_EOF)
  800e6e:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800e72:	0f 84 ad 00 00 00    	je     800f25 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  800e78:	83 ec 08             	sub    $0x8,%esp
  800e7b:	ff 75 ec             	pushl  -0x14(%ebp)
  800e7e:	68 4b 28 80 00       	push   $0x80284b
  800e83:	e8 c5 f7 ff ff       	call   80064d <cprintf>
  800e88:	83 c4 10             	add    $0x10,%esp
				break;
  800e8b:	e9 95 00 00 00       	jmp    800f25 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  800e90:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800e94:	7e 34                	jle    800eca <atomic_readline+0xa5>
  800e96:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800e9d:	7f 2b                	jg     800eca <atomic_readline+0xa5>
				if (echoing)
  800e9f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800ea3:	74 0e                	je     800eb3 <atomic_readline+0x8e>
					cputchar(c);
  800ea5:	83 ec 0c             	sub    $0xc,%esp
  800ea8:	ff 75 ec             	pushl  -0x14(%ebp)
  800eab:	e8 f2 0e 00 00       	call   801da2 <cputchar>
  800eb0:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  800eb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800eb6:	8d 50 01             	lea    0x1(%eax),%edx
  800eb9:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800ebc:	89 c2                	mov    %eax,%edx
  800ebe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec1:	01 d0                	add    %edx,%eax
  800ec3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ec6:	88 10                	mov    %dl,(%eax)
  800ec8:	eb 56                	jmp    800f20 <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  800eca:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800ece:	75 1f                	jne    800eef <atomic_readline+0xca>
  800ed0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800ed4:	7e 19                	jle    800eef <atomic_readline+0xca>
				if (echoing)
  800ed6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800eda:	74 0e                	je     800eea <atomic_readline+0xc5>
					cputchar(c);
  800edc:	83 ec 0c             	sub    $0xc,%esp
  800edf:	ff 75 ec             	pushl  -0x14(%ebp)
  800ee2:	e8 bb 0e 00 00       	call   801da2 <cputchar>
  800ee7:	83 c4 10             	add    $0x10,%esp
				i--;
  800eea:	ff 4d f4             	decl   -0xc(%ebp)
  800eed:	eb 31                	jmp    800f20 <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  800eef:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800ef3:	74 0a                	je     800eff <atomic_readline+0xda>
  800ef5:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800ef9:	0f 85 61 ff ff ff    	jne    800e60 <atomic_readline+0x3b>
				if (echoing)
  800eff:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800f03:	74 0e                	je     800f13 <atomic_readline+0xee>
					cputchar(c);
  800f05:	83 ec 0c             	sub    $0xc,%esp
  800f08:	ff 75 ec             	pushl  -0x14(%ebp)
  800f0b:	e8 92 0e 00 00       	call   801da2 <cputchar>
  800f10:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  800f13:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f16:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f19:	01 d0                	add    %edx,%eax
  800f1b:	c6 00 00             	movb   $0x0,(%eax)
				break;
  800f1e:	eb 06                	jmp    800f26 <atomic_readline+0x101>
			}
		}
  800f20:	e9 3b ff ff ff       	jmp    800e60 <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  800f25:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  800f26:	e8 98 08 00 00       	call   8017c3 <sys_unlock_cons>
}
  800f2b:	90                   	nop
  800f2c:	c9                   	leave  
  800f2d:	c3                   	ret    

00800f2e <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800f2e:	55                   	push   %ebp
  800f2f:	89 e5                	mov    %esp,%ebp
  800f31:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800f34:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f3b:	eb 06                	jmp    800f43 <strlen+0x15>
		n++;
  800f3d:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800f40:	ff 45 08             	incl   0x8(%ebp)
  800f43:	8b 45 08             	mov    0x8(%ebp),%eax
  800f46:	8a 00                	mov    (%eax),%al
  800f48:	84 c0                	test   %al,%al
  800f4a:	75 f1                	jne    800f3d <strlen+0xf>
		n++;
	return n;
  800f4c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f4f:	c9                   	leave  
  800f50:	c3                   	ret    

00800f51 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800f51:	55                   	push   %ebp
  800f52:	89 e5                	mov    %esp,%ebp
  800f54:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f57:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f5e:	eb 09                	jmp    800f69 <strnlen+0x18>
		n++;
  800f60:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f63:	ff 45 08             	incl   0x8(%ebp)
  800f66:	ff 4d 0c             	decl   0xc(%ebp)
  800f69:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f6d:	74 09                	je     800f78 <strnlen+0x27>
  800f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f72:	8a 00                	mov    (%eax),%al
  800f74:	84 c0                	test   %al,%al
  800f76:	75 e8                	jne    800f60 <strnlen+0xf>
		n++;
	return n;
  800f78:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f7b:	c9                   	leave  
  800f7c:	c3                   	ret    

00800f7d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800f7d:	55                   	push   %ebp
  800f7e:	89 e5                	mov    %esp,%ebp
  800f80:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800f83:	8b 45 08             	mov    0x8(%ebp),%eax
  800f86:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800f89:	90                   	nop
  800f8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8d:	8d 50 01             	lea    0x1(%eax),%edx
  800f90:	89 55 08             	mov    %edx,0x8(%ebp)
  800f93:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f96:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f99:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f9c:	8a 12                	mov    (%edx),%dl
  800f9e:	88 10                	mov    %dl,(%eax)
  800fa0:	8a 00                	mov    (%eax),%al
  800fa2:	84 c0                	test   %al,%al
  800fa4:	75 e4                	jne    800f8a <strcpy+0xd>
		/* do nothing */;
	return ret;
  800fa6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800fa9:	c9                   	leave  
  800faa:	c3                   	ret    

00800fab <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800fab:	55                   	push   %ebp
  800fac:	89 e5                	mov    %esp,%ebp
  800fae:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800fb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800fb7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800fbe:	eb 1f                	jmp    800fdf <strncpy+0x34>
		*dst++ = *src;
  800fc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc3:	8d 50 01             	lea    0x1(%eax),%edx
  800fc6:	89 55 08             	mov    %edx,0x8(%ebp)
  800fc9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fcc:	8a 12                	mov    (%edx),%dl
  800fce:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800fd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd3:	8a 00                	mov    (%eax),%al
  800fd5:	84 c0                	test   %al,%al
  800fd7:	74 03                	je     800fdc <strncpy+0x31>
			src++;
  800fd9:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800fdc:	ff 45 fc             	incl   -0x4(%ebp)
  800fdf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fe2:	3b 45 10             	cmp    0x10(%ebp),%eax
  800fe5:	72 d9                	jb     800fc0 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800fe7:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800fea:	c9                   	leave  
  800feb:	c3                   	ret    

00800fec <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800fec:	55                   	push   %ebp
  800fed:	89 e5                	mov    %esp,%ebp
  800fef:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ff2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ff8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ffc:	74 30                	je     80102e <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ffe:	eb 16                	jmp    801016 <strlcpy+0x2a>
			*dst++ = *src++;
  801000:	8b 45 08             	mov    0x8(%ebp),%eax
  801003:	8d 50 01             	lea    0x1(%eax),%edx
  801006:	89 55 08             	mov    %edx,0x8(%ebp)
  801009:	8b 55 0c             	mov    0xc(%ebp),%edx
  80100c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80100f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801012:	8a 12                	mov    (%edx),%dl
  801014:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801016:	ff 4d 10             	decl   0x10(%ebp)
  801019:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80101d:	74 09                	je     801028 <strlcpy+0x3c>
  80101f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801022:	8a 00                	mov    (%eax),%al
  801024:	84 c0                	test   %al,%al
  801026:	75 d8                	jne    801000 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801028:	8b 45 08             	mov    0x8(%ebp),%eax
  80102b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80102e:	8b 55 08             	mov    0x8(%ebp),%edx
  801031:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801034:	29 c2                	sub    %eax,%edx
  801036:	89 d0                	mov    %edx,%eax
}
  801038:	c9                   	leave  
  801039:	c3                   	ret    

0080103a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80103a:	55                   	push   %ebp
  80103b:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80103d:	eb 06                	jmp    801045 <strcmp+0xb>
		p++, q++;
  80103f:	ff 45 08             	incl   0x8(%ebp)
  801042:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801045:	8b 45 08             	mov    0x8(%ebp),%eax
  801048:	8a 00                	mov    (%eax),%al
  80104a:	84 c0                	test   %al,%al
  80104c:	74 0e                	je     80105c <strcmp+0x22>
  80104e:	8b 45 08             	mov    0x8(%ebp),%eax
  801051:	8a 10                	mov    (%eax),%dl
  801053:	8b 45 0c             	mov    0xc(%ebp),%eax
  801056:	8a 00                	mov    (%eax),%al
  801058:	38 c2                	cmp    %al,%dl
  80105a:	74 e3                	je     80103f <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80105c:	8b 45 08             	mov    0x8(%ebp),%eax
  80105f:	8a 00                	mov    (%eax),%al
  801061:	0f b6 d0             	movzbl %al,%edx
  801064:	8b 45 0c             	mov    0xc(%ebp),%eax
  801067:	8a 00                	mov    (%eax),%al
  801069:	0f b6 c0             	movzbl %al,%eax
  80106c:	29 c2                	sub    %eax,%edx
  80106e:	89 d0                	mov    %edx,%eax
}
  801070:	5d                   	pop    %ebp
  801071:	c3                   	ret    

00801072 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801072:	55                   	push   %ebp
  801073:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801075:	eb 09                	jmp    801080 <strncmp+0xe>
		n--, p++, q++;
  801077:	ff 4d 10             	decl   0x10(%ebp)
  80107a:	ff 45 08             	incl   0x8(%ebp)
  80107d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801080:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801084:	74 17                	je     80109d <strncmp+0x2b>
  801086:	8b 45 08             	mov    0x8(%ebp),%eax
  801089:	8a 00                	mov    (%eax),%al
  80108b:	84 c0                	test   %al,%al
  80108d:	74 0e                	je     80109d <strncmp+0x2b>
  80108f:	8b 45 08             	mov    0x8(%ebp),%eax
  801092:	8a 10                	mov    (%eax),%dl
  801094:	8b 45 0c             	mov    0xc(%ebp),%eax
  801097:	8a 00                	mov    (%eax),%al
  801099:	38 c2                	cmp    %al,%dl
  80109b:	74 da                	je     801077 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80109d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010a1:	75 07                	jne    8010aa <strncmp+0x38>
		return 0;
  8010a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8010a8:	eb 14                	jmp    8010be <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8010aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ad:	8a 00                	mov    (%eax),%al
  8010af:	0f b6 d0             	movzbl %al,%edx
  8010b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b5:	8a 00                	mov    (%eax),%al
  8010b7:	0f b6 c0             	movzbl %al,%eax
  8010ba:	29 c2                	sub    %eax,%edx
  8010bc:	89 d0                	mov    %edx,%eax
}
  8010be:	5d                   	pop    %ebp
  8010bf:	c3                   	ret    

008010c0 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8010c0:	55                   	push   %ebp
  8010c1:	89 e5                	mov    %esp,%ebp
  8010c3:	83 ec 04             	sub    $0x4,%esp
  8010c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8010cc:	eb 12                	jmp    8010e0 <strchr+0x20>
		if (*s == c)
  8010ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d1:	8a 00                	mov    (%eax),%al
  8010d3:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8010d6:	75 05                	jne    8010dd <strchr+0x1d>
			return (char *) s;
  8010d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010db:	eb 11                	jmp    8010ee <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8010dd:	ff 45 08             	incl   0x8(%ebp)
  8010e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e3:	8a 00                	mov    (%eax),%al
  8010e5:	84 c0                	test   %al,%al
  8010e7:	75 e5                	jne    8010ce <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8010e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010ee:	c9                   	leave  
  8010ef:	c3                   	ret    

008010f0 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8010f0:	55                   	push   %ebp
  8010f1:	89 e5                	mov    %esp,%ebp
  8010f3:	83 ec 04             	sub    $0x4,%esp
  8010f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8010fc:	eb 0d                	jmp    80110b <strfind+0x1b>
		if (*s == c)
  8010fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801101:	8a 00                	mov    (%eax),%al
  801103:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801106:	74 0e                	je     801116 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801108:	ff 45 08             	incl   0x8(%ebp)
  80110b:	8b 45 08             	mov    0x8(%ebp),%eax
  80110e:	8a 00                	mov    (%eax),%al
  801110:	84 c0                	test   %al,%al
  801112:	75 ea                	jne    8010fe <strfind+0xe>
  801114:	eb 01                	jmp    801117 <strfind+0x27>
		if (*s == c)
			break;
  801116:	90                   	nop
	return (char *) s;
  801117:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80111a:	c9                   	leave  
  80111b:	c3                   	ret    

0080111c <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  80111c:	55                   	push   %ebp
  80111d:	89 e5                	mov    %esp,%ebp
  80111f:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801122:	8b 45 08             	mov    0x8(%ebp),%eax
  801125:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801128:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80112c:	76 63                	jbe    801191 <memset+0x75>
		uint64 data_block = c;
  80112e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801131:	99                   	cltd   
  801132:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801135:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801138:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80113b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80113e:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801142:	c1 e0 08             	shl    $0x8,%eax
  801145:	09 45 f0             	or     %eax,-0x10(%ebp)
  801148:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  80114b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80114e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801151:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801155:	c1 e0 10             	shl    $0x10,%eax
  801158:	09 45 f0             	or     %eax,-0x10(%ebp)
  80115b:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  80115e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801161:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801164:	89 c2                	mov    %eax,%edx
  801166:	b8 00 00 00 00       	mov    $0x0,%eax
  80116b:	09 45 f0             	or     %eax,-0x10(%ebp)
  80116e:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801171:	eb 18                	jmp    80118b <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801173:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801176:	8d 41 08             	lea    0x8(%ecx),%eax
  801179:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80117c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80117f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801182:	89 01                	mov    %eax,(%ecx)
  801184:	89 51 04             	mov    %edx,0x4(%ecx)
  801187:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  80118b:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80118f:	77 e2                	ja     801173 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801191:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801195:	74 23                	je     8011ba <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801197:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80119a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  80119d:	eb 0e                	jmp    8011ad <memset+0x91>
			*p8++ = (uint8)c;
  80119f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011a2:	8d 50 01             	lea    0x1(%eax),%edx
  8011a5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011ab:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8011ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011b3:	89 55 10             	mov    %edx,0x10(%ebp)
  8011b6:	85 c0                	test   %eax,%eax
  8011b8:	75 e5                	jne    80119f <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8011ba:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011bd:	c9                   	leave  
  8011be:	c3                   	ret    

008011bf <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8011bf:	55                   	push   %ebp
  8011c0:	89 e5                	mov    %esp,%ebp
  8011c2:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8011c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8011cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ce:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8011d1:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8011d5:	76 24                	jbe    8011fb <memcpy+0x3c>
		while(n >= 8){
  8011d7:	eb 1c                	jmp    8011f5 <memcpy+0x36>
			*d64 = *s64;
  8011d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011dc:	8b 50 04             	mov    0x4(%eax),%edx
  8011df:	8b 00                	mov    (%eax),%eax
  8011e1:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011e4:	89 01                	mov    %eax,(%ecx)
  8011e6:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8011e9:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8011ed:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8011f1:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8011f5:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8011f9:	77 de                	ja     8011d9 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8011fb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011ff:	74 31                	je     801232 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801201:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801204:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801207:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80120a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  80120d:	eb 16                	jmp    801225 <memcpy+0x66>
			*d8++ = *s8++;
  80120f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801212:	8d 50 01             	lea    0x1(%eax),%edx
  801215:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801218:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80121b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80121e:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801221:	8a 12                	mov    (%edx),%dl
  801223:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801225:	8b 45 10             	mov    0x10(%ebp),%eax
  801228:	8d 50 ff             	lea    -0x1(%eax),%edx
  80122b:	89 55 10             	mov    %edx,0x10(%ebp)
  80122e:	85 c0                	test   %eax,%eax
  801230:	75 dd                	jne    80120f <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801232:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801235:	c9                   	leave  
  801236:	c3                   	ret    

00801237 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801237:	55                   	push   %ebp
  801238:	89 e5                	mov    %esp,%ebp
  80123a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80123d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801240:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801243:	8b 45 08             	mov    0x8(%ebp),%eax
  801246:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801249:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80124c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80124f:	73 50                	jae    8012a1 <memmove+0x6a>
  801251:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801254:	8b 45 10             	mov    0x10(%ebp),%eax
  801257:	01 d0                	add    %edx,%eax
  801259:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80125c:	76 43                	jbe    8012a1 <memmove+0x6a>
		s += n;
  80125e:	8b 45 10             	mov    0x10(%ebp),%eax
  801261:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801264:	8b 45 10             	mov    0x10(%ebp),%eax
  801267:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80126a:	eb 10                	jmp    80127c <memmove+0x45>
			*--d = *--s;
  80126c:	ff 4d f8             	decl   -0x8(%ebp)
  80126f:	ff 4d fc             	decl   -0x4(%ebp)
  801272:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801275:	8a 10                	mov    (%eax),%dl
  801277:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80127a:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80127c:	8b 45 10             	mov    0x10(%ebp),%eax
  80127f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801282:	89 55 10             	mov    %edx,0x10(%ebp)
  801285:	85 c0                	test   %eax,%eax
  801287:	75 e3                	jne    80126c <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801289:	eb 23                	jmp    8012ae <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80128b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80128e:	8d 50 01             	lea    0x1(%eax),%edx
  801291:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801294:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801297:	8d 4a 01             	lea    0x1(%edx),%ecx
  80129a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80129d:	8a 12                	mov    (%edx),%dl
  80129f:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8012a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012a7:	89 55 10             	mov    %edx,0x10(%ebp)
  8012aa:	85 c0                	test   %eax,%eax
  8012ac:	75 dd                	jne    80128b <memmove+0x54>
			*d++ = *s++;

	return dst;
  8012ae:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012b1:	c9                   	leave  
  8012b2:	c3                   	ret    

008012b3 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8012b3:	55                   	push   %ebp
  8012b4:	89 e5                	mov    %esp,%ebp
  8012b6:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8012b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8012bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c2:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8012c5:	eb 2a                	jmp    8012f1 <memcmp+0x3e>
		if (*s1 != *s2)
  8012c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012ca:	8a 10                	mov    (%eax),%dl
  8012cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012cf:	8a 00                	mov    (%eax),%al
  8012d1:	38 c2                	cmp    %al,%dl
  8012d3:	74 16                	je     8012eb <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8012d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012d8:	8a 00                	mov    (%eax),%al
  8012da:	0f b6 d0             	movzbl %al,%edx
  8012dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012e0:	8a 00                	mov    (%eax),%al
  8012e2:	0f b6 c0             	movzbl %al,%eax
  8012e5:	29 c2                	sub    %eax,%edx
  8012e7:	89 d0                	mov    %edx,%eax
  8012e9:	eb 18                	jmp    801303 <memcmp+0x50>
		s1++, s2++;
  8012eb:	ff 45 fc             	incl   -0x4(%ebp)
  8012ee:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8012f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012f7:	89 55 10             	mov    %edx,0x10(%ebp)
  8012fa:	85 c0                	test   %eax,%eax
  8012fc:	75 c9                	jne    8012c7 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8012fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801303:	c9                   	leave  
  801304:	c3                   	ret    

00801305 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801305:	55                   	push   %ebp
  801306:	89 e5                	mov    %esp,%ebp
  801308:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80130b:	8b 55 08             	mov    0x8(%ebp),%edx
  80130e:	8b 45 10             	mov    0x10(%ebp),%eax
  801311:	01 d0                	add    %edx,%eax
  801313:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801316:	eb 15                	jmp    80132d <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801318:	8b 45 08             	mov    0x8(%ebp),%eax
  80131b:	8a 00                	mov    (%eax),%al
  80131d:	0f b6 d0             	movzbl %al,%edx
  801320:	8b 45 0c             	mov    0xc(%ebp),%eax
  801323:	0f b6 c0             	movzbl %al,%eax
  801326:	39 c2                	cmp    %eax,%edx
  801328:	74 0d                	je     801337 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80132a:	ff 45 08             	incl   0x8(%ebp)
  80132d:	8b 45 08             	mov    0x8(%ebp),%eax
  801330:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801333:	72 e3                	jb     801318 <memfind+0x13>
  801335:	eb 01                	jmp    801338 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801337:	90                   	nop
	return (void *) s;
  801338:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80133b:	c9                   	leave  
  80133c:	c3                   	ret    

0080133d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80133d:	55                   	push   %ebp
  80133e:	89 e5                	mov    %esp,%ebp
  801340:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801343:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80134a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801351:	eb 03                	jmp    801356 <strtol+0x19>
		s++;
  801353:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801356:	8b 45 08             	mov    0x8(%ebp),%eax
  801359:	8a 00                	mov    (%eax),%al
  80135b:	3c 20                	cmp    $0x20,%al
  80135d:	74 f4                	je     801353 <strtol+0x16>
  80135f:	8b 45 08             	mov    0x8(%ebp),%eax
  801362:	8a 00                	mov    (%eax),%al
  801364:	3c 09                	cmp    $0x9,%al
  801366:	74 eb                	je     801353 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801368:	8b 45 08             	mov    0x8(%ebp),%eax
  80136b:	8a 00                	mov    (%eax),%al
  80136d:	3c 2b                	cmp    $0x2b,%al
  80136f:	75 05                	jne    801376 <strtol+0x39>
		s++;
  801371:	ff 45 08             	incl   0x8(%ebp)
  801374:	eb 13                	jmp    801389 <strtol+0x4c>
	else if (*s == '-')
  801376:	8b 45 08             	mov    0x8(%ebp),%eax
  801379:	8a 00                	mov    (%eax),%al
  80137b:	3c 2d                	cmp    $0x2d,%al
  80137d:	75 0a                	jne    801389 <strtol+0x4c>
		s++, neg = 1;
  80137f:	ff 45 08             	incl   0x8(%ebp)
  801382:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801389:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80138d:	74 06                	je     801395 <strtol+0x58>
  80138f:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801393:	75 20                	jne    8013b5 <strtol+0x78>
  801395:	8b 45 08             	mov    0x8(%ebp),%eax
  801398:	8a 00                	mov    (%eax),%al
  80139a:	3c 30                	cmp    $0x30,%al
  80139c:	75 17                	jne    8013b5 <strtol+0x78>
  80139e:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a1:	40                   	inc    %eax
  8013a2:	8a 00                	mov    (%eax),%al
  8013a4:	3c 78                	cmp    $0x78,%al
  8013a6:	75 0d                	jne    8013b5 <strtol+0x78>
		s += 2, base = 16;
  8013a8:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8013ac:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8013b3:	eb 28                	jmp    8013dd <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8013b5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013b9:	75 15                	jne    8013d0 <strtol+0x93>
  8013bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013be:	8a 00                	mov    (%eax),%al
  8013c0:	3c 30                	cmp    $0x30,%al
  8013c2:	75 0c                	jne    8013d0 <strtol+0x93>
		s++, base = 8;
  8013c4:	ff 45 08             	incl   0x8(%ebp)
  8013c7:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8013ce:	eb 0d                	jmp    8013dd <strtol+0xa0>
	else if (base == 0)
  8013d0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013d4:	75 07                	jne    8013dd <strtol+0xa0>
		base = 10;
  8013d6:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8013dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e0:	8a 00                	mov    (%eax),%al
  8013e2:	3c 2f                	cmp    $0x2f,%al
  8013e4:	7e 19                	jle    8013ff <strtol+0xc2>
  8013e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e9:	8a 00                	mov    (%eax),%al
  8013eb:	3c 39                	cmp    $0x39,%al
  8013ed:	7f 10                	jg     8013ff <strtol+0xc2>
			dig = *s - '0';
  8013ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f2:	8a 00                	mov    (%eax),%al
  8013f4:	0f be c0             	movsbl %al,%eax
  8013f7:	83 e8 30             	sub    $0x30,%eax
  8013fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8013fd:	eb 42                	jmp    801441 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8013ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801402:	8a 00                	mov    (%eax),%al
  801404:	3c 60                	cmp    $0x60,%al
  801406:	7e 19                	jle    801421 <strtol+0xe4>
  801408:	8b 45 08             	mov    0x8(%ebp),%eax
  80140b:	8a 00                	mov    (%eax),%al
  80140d:	3c 7a                	cmp    $0x7a,%al
  80140f:	7f 10                	jg     801421 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801411:	8b 45 08             	mov    0x8(%ebp),%eax
  801414:	8a 00                	mov    (%eax),%al
  801416:	0f be c0             	movsbl %al,%eax
  801419:	83 e8 57             	sub    $0x57,%eax
  80141c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80141f:	eb 20                	jmp    801441 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801421:	8b 45 08             	mov    0x8(%ebp),%eax
  801424:	8a 00                	mov    (%eax),%al
  801426:	3c 40                	cmp    $0x40,%al
  801428:	7e 39                	jle    801463 <strtol+0x126>
  80142a:	8b 45 08             	mov    0x8(%ebp),%eax
  80142d:	8a 00                	mov    (%eax),%al
  80142f:	3c 5a                	cmp    $0x5a,%al
  801431:	7f 30                	jg     801463 <strtol+0x126>
			dig = *s - 'A' + 10;
  801433:	8b 45 08             	mov    0x8(%ebp),%eax
  801436:	8a 00                	mov    (%eax),%al
  801438:	0f be c0             	movsbl %al,%eax
  80143b:	83 e8 37             	sub    $0x37,%eax
  80143e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801441:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801444:	3b 45 10             	cmp    0x10(%ebp),%eax
  801447:	7d 19                	jge    801462 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801449:	ff 45 08             	incl   0x8(%ebp)
  80144c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80144f:	0f af 45 10          	imul   0x10(%ebp),%eax
  801453:	89 c2                	mov    %eax,%edx
  801455:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801458:	01 d0                	add    %edx,%eax
  80145a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80145d:	e9 7b ff ff ff       	jmp    8013dd <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801462:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801463:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801467:	74 08                	je     801471 <strtol+0x134>
		*endptr = (char *) s;
  801469:	8b 45 0c             	mov    0xc(%ebp),%eax
  80146c:	8b 55 08             	mov    0x8(%ebp),%edx
  80146f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801471:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801475:	74 07                	je     80147e <strtol+0x141>
  801477:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80147a:	f7 d8                	neg    %eax
  80147c:	eb 03                	jmp    801481 <strtol+0x144>
  80147e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801481:	c9                   	leave  
  801482:	c3                   	ret    

00801483 <ltostr>:

void
ltostr(long value, char *str)
{
  801483:	55                   	push   %ebp
  801484:	89 e5                	mov    %esp,%ebp
  801486:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801489:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801490:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801497:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80149b:	79 13                	jns    8014b0 <ltostr+0x2d>
	{
		neg = 1;
  80149d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8014a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a7:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8014aa:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8014ad:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8014b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b3:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8014b8:	99                   	cltd   
  8014b9:	f7 f9                	idiv   %ecx
  8014bb:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8014be:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014c1:	8d 50 01             	lea    0x1(%eax),%edx
  8014c4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014c7:	89 c2                	mov    %eax,%edx
  8014c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014cc:	01 d0                	add    %edx,%eax
  8014ce:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8014d1:	83 c2 30             	add    $0x30,%edx
  8014d4:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8014d6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014d9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8014de:	f7 e9                	imul   %ecx
  8014e0:	c1 fa 02             	sar    $0x2,%edx
  8014e3:	89 c8                	mov    %ecx,%eax
  8014e5:	c1 f8 1f             	sar    $0x1f,%eax
  8014e8:	29 c2                	sub    %eax,%edx
  8014ea:	89 d0                	mov    %edx,%eax
  8014ec:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8014ef:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014f3:	75 bb                	jne    8014b0 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8014f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8014fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014ff:	48                   	dec    %eax
  801500:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801503:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801507:	74 3d                	je     801546 <ltostr+0xc3>
		start = 1 ;
  801509:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801510:	eb 34                	jmp    801546 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801512:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801515:	8b 45 0c             	mov    0xc(%ebp),%eax
  801518:	01 d0                	add    %edx,%eax
  80151a:	8a 00                	mov    (%eax),%al
  80151c:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80151f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801522:	8b 45 0c             	mov    0xc(%ebp),%eax
  801525:	01 c2                	add    %eax,%edx
  801527:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80152a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80152d:	01 c8                	add    %ecx,%eax
  80152f:	8a 00                	mov    (%eax),%al
  801531:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801533:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801536:	8b 45 0c             	mov    0xc(%ebp),%eax
  801539:	01 c2                	add    %eax,%edx
  80153b:	8a 45 eb             	mov    -0x15(%ebp),%al
  80153e:	88 02                	mov    %al,(%edx)
		start++ ;
  801540:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801543:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801546:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801549:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80154c:	7c c4                	jl     801512 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80154e:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801551:	8b 45 0c             	mov    0xc(%ebp),%eax
  801554:	01 d0                	add    %edx,%eax
  801556:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801559:	90                   	nop
  80155a:	c9                   	leave  
  80155b:	c3                   	ret    

0080155c <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80155c:	55                   	push   %ebp
  80155d:	89 e5                	mov    %esp,%ebp
  80155f:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801562:	ff 75 08             	pushl  0x8(%ebp)
  801565:	e8 c4 f9 ff ff       	call   800f2e <strlen>
  80156a:	83 c4 04             	add    $0x4,%esp
  80156d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801570:	ff 75 0c             	pushl  0xc(%ebp)
  801573:	e8 b6 f9 ff ff       	call   800f2e <strlen>
  801578:	83 c4 04             	add    $0x4,%esp
  80157b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80157e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801585:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80158c:	eb 17                	jmp    8015a5 <strcconcat+0x49>
		final[s] = str1[s] ;
  80158e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801591:	8b 45 10             	mov    0x10(%ebp),%eax
  801594:	01 c2                	add    %eax,%edx
  801596:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801599:	8b 45 08             	mov    0x8(%ebp),%eax
  80159c:	01 c8                	add    %ecx,%eax
  80159e:	8a 00                	mov    (%eax),%al
  8015a0:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8015a2:	ff 45 fc             	incl   -0x4(%ebp)
  8015a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015a8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8015ab:	7c e1                	jl     80158e <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8015ad:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8015b4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8015bb:	eb 1f                	jmp    8015dc <strcconcat+0x80>
		final[s++] = str2[i] ;
  8015bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015c0:	8d 50 01             	lea    0x1(%eax),%edx
  8015c3:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8015c6:	89 c2                	mov    %eax,%edx
  8015c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8015cb:	01 c2                	add    %eax,%edx
  8015cd:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8015d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d3:	01 c8                	add    %ecx,%eax
  8015d5:	8a 00                	mov    (%eax),%al
  8015d7:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8015d9:	ff 45 f8             	incl   -0x8(%ebp)
  8015dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015df:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8015e2:	7c d9                	jl     8015bd <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8015e4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8015ea:	01 d0                	add    %edx,%eax
  8015ec:	c6 00 00             	movb   $0x0,(%eax)
}
  8015ef:	90                   	nop
  8015f0:	c9                   	leave  
  8015f1:	c3                   	ret    

008015f2 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8015f2:	55                   	push   %ebp
  8015f3:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8015f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8015f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8015fe:	8b 45 14             	mov    0x14(%ebp),%eax
  801601:	8b 00                	mov    (%eax),%eax
  801603:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80160a:	8b 45 10             	mov    0x10(%ebp),%eax
  80160d:	01 d0                	add    %edx,%eax
  80160f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801615:	eb 0c                	jmp    801623 <strsplit+0x31>
			*string++ = 0;
  801617:	8b 45 08             	mov    0x8(%ebp),%eax
  80161a:	8d 50 01             	lea    0x1(%eax),%edx
  80161d:	89 55 08             	mov    %edx,0x8(%ebp)
  801620:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801623:	8b 45 08             	mov    0x8(%ebp),%eax
  801626:	8a 00                	mov    (%eax),%al
  801628:	84 c0                	test   %al,%al
  80162a:	74 18                	je     801644 <strsplit+0x52>
  80162c:	8b 45 08             	mov    0x8(%ebp),%eax
  80162f:	8a 00                	mov    (%eax),%al
  801631:	0f be c0             	movsbl %al,%eax
  801634:	50                   	push   %eax
  801635:	ff 75 0c             	pushl  0xc(%ebp)
  801638:	e8 83 fa ff ff       	call   8010c0 <strchr>
  80163d:	83 c4 08             	add    $0x8,%esp
  801640:	85 c0                	test   %eax,%eax
  801642:	75 d3                	jne    801617 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801644:	8b 45 08             	mov    0x8(%ebp),%eax
  801647:	8a 00                	mov    (%eax),%al
  801649:	84 c0                	test   %al,%al
  80164b:	74 5a                	je     8016a7 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80164d:	8b 45 14             	mov    0x14(%ebp),%eax
  801650:	8b 00                	mov    (%eax),%eax
  801652:	83 f8 0f             	cmp    $0xf,%eax
  801655:	75 07                	jne    80165e <strsplit+0x6c>
		{
			return 0;
  801657:	b8 00 00 00 00       	mov    $0x0,%eax
  80165c:	eb 66                	jmp    8016c4 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80165e:	8b 45 14             	mov    0x14(%ebp),%eax
  801661:	8b 00                	mov    (%eax),%eax
  801663:	8d 48 01             	lea    0x1(%eax),%ecx
  801666:	8b 55 14             	mov    0x14(%ebp),%edx
  801669:	89 0a                	mov    %ecx,(%edx)
  80166b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801672:	8b 45 10             	mov    0x10(%ebp),%eax
  801675:	01 c2                	add    %eax,%edx
  801677:	8b 45 08             	mov    0x8(%ebp),%eax
  80167a:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80167c:	eb 03                	jmp    801681 <strsplit+0x8f>
			string++;
  80167e:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801681:	8b 45 08             	mov    0x8(%ebp),%eax
  801684:	8a 00                	mov    (%eax),%al
  801686:	84 c0                	test   %al,%al
  801688:	74 8b                	je     801615 <strsplit+0x23>
  80168a:	8b 45 08             	mov    0x8(%ebp),%eax
  80168d:	8a 00                	mov    (%eax),%al
  80168f:	0f be c0             	movsbl %al,%eax
  801692:	50                   	push   %eax
  801693:	ff 75 0c             	pushl  0xc(%ebp)
  801696:	e8 25 fa ff ff       	call   8010c0 <strchr>
  80169b:	83 c4 08             	add    $0x8,%esp
  80169e:	85 c0                	test   %eax,%eax
  8016a0:	74 dc                	je     80167e <strsplit+0x8c>
			string++;
	}
  8016a2:	e9 6e ff ff ff       	jmp    801615 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8016a7:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8016a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8016ab:	8b 00                	mov    (%eax),%eax
  8016ad:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b7:	01 d0                	add    %edx,%eax
  8016b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8016bf:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8016c4:	c9                   	leave  
  8016c5:	c3                   	ret    

008016c6 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8016c6:	55                   	push   %ebp
  8016c7:	89 e5                	mov    %esp,%ebp
  8016c9:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8016cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cf:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8016d2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8016d9:	eb 4a                	jmp    801725 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8016db:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016de:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e1:	01 c2                	add    %eax,%edx
  8016e3:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8016e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016e9:	01 c8                	add    %ecx,%eax
  8016eb:	8a 00                	mov    (%eax),%al
  8016ed:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8016ef:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f5:	01 d0                	add    %edx,%eax
  8016f7:	8a 00                	mov    (%eax),%al
  8016f9:	3c 40                	cmp    $0x40,%al
  8016fb:	7e 25                	jle    801722 <str2lower+0x5c>
  8016fd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801700:	8b 45 0c             	mov    0xc(%ebp),%eax
  801703:	01 d0                	add    %edx,%eax
  801705:	8a 00                	mov    (%eax),%al
  801707:	3c 5a                	cmp    $0x5a,%al
  801709:	7f 17                	jg     801722 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  80170b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80170e:	8b 45 08             	mov    0x8(%ebp),%eax
  801711:	01 d0                	add    %edx,%eax
  801713:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801716:	8b 55 08             	mov    0x8(%ebp),%edx
  801719:	01 ca                	add    %ecx,%edx
  80171b:	8a 12                	mov    (%edx),%dl
  80171d:	83 c2 20             	add    $0x20,%edx
  801720:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801722:	ff 45 fc             	incl   -0x4(%ebp)
  801725:	ff 75 0c             	pushl  0xc(%ebp)
  801728:	e8 01 f8 ff ff       	call   800f2e <strlen>
  80172d:	83 c4 04             	add    $0x4,%esp
  801730:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801733:	7f a6                	jg     8016db <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801735:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801738:	c9                   	leave  
  801739:	c3                   	ret    

0080173a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80173a:	55                   	push   %ebp
  80173b:	89 e5                	mov    %esp,%ebp
  80173d:	57                   	push   %edi
  80173e:	56                   	push   %esi
  80173f:	53                   	push   %ebx
  801740:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801743:	8b 45 08             	mov    0x8(%ebp),%eax
  801746:	8b 55 0c             	mov    0xc(%ebp),%edx
  801749:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80174c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80174f:	8b 7d 18             	mov    0x18(%ebp),%edi
  801752:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801755:	cd 30                	int    $0x30
  801757:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  80175a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80175d:	83 c4 10             	add    $0x10,%esp
  801760:	5b                   	pop    %ebx
  801761:	5e                   	pop    %esi
  801762:	5f                   	pop    %edi
  801763:	5d                   	pop    %ebp
  801764:	c3                   	ret    

00801765 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801765:	55                   	push   %ebp
  801766:	89 e5                	mov    %esp,%ebp
  801768:	83 ec 04             	sub    $0x4,%esp
  80176b:	8b 45 10             	mov    0x10(%ebp),%eax
  80176e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801771:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801774:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801778:	8b 45 08             	mov    0x8(%ebp),%eax
  80177b:	6a 00                	push   $0x0
  80177d:	51                   	push   %ecx
  80177e:	52                   	push   %edx
  80177f:	ff 75 0c             	pushl  0xc(%ebp)
  801782:	50                   	push   %eax
  801783:	6a 00                	push   $0x0
  801785:	e8 b0 ff ff ff       	call   80173a <syscall>
  80178a:	83 c4 18             	add    $0x18,%esp
}
  80178d:	90                   	nop
  80178e:	c9                   	leave  
  80178f:	c3                   	ret    

00801790 <sys_cgetc>:

int
sys_cgetc(void)
{
  801790:	55                   	push   %ebp
  801791:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801793:	6a 00                	push   $0x0
  801795:	6a 00                	push   $0x0
  801797:	6a 00                	push   $0x0
  801799:	6a 00                	push   $0x0
  80179b:	6a 00                	push   $0x0
  80179d:	6a 02                	push   $0x2
  80179f:	e8 96 ff ff ff       	call   80173a <syscall>
  8017a4:	83 c4 18             	add    $0x18,%esp
}
  8017a7:	c9                   	leave  
  8017a8:	c3                   	ret    

008017a9 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8017a9:	55                   	push   %ebp
  8017aa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8017ac:	6a 00                	push   $0x0
  8017ae:	6a 00                	push   $0x0
  8017b0:	6a 00                	push   $0x0
  8017b2:	6a 00                	push   $0x0
  8017b4:	6a 00                	push   $0x0
  8017b6:	6a 03                	push   $0x3
  8017b8:	e8 7d ff ff ff       	call   80173a <syscall>
  8017bd:	83 c4 18             	add    $0x18,%esp
}
  8017c0:	90                   	nop
  8017c1:	c9                   	leave  
  8017c2:	c3                   	ret    

008017c3 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8017c3:	55                   	push   %ebp
  8017c4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8017c6:	6a 00                	push   $0x0
  8017c8:	6a 00                	push   $0x0
  8017ca:	6a 00                	push   $0x0
  8017cc:	6a 00                	push   $0x0
  8017ce:	6a 00                	push   $0x0
  8017d0:	6a 04                	push   $0x4
  8017d2:	e8 63 ff ff ff       	call   80173a <syscall>
  8017d7:	83 c4 18             	add    $0x18,%esp
}
  8017da:	90                   	nop
  8017db:	c9                   	leave  
  8017dc:	c3                   	ret    

008017dd <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8017dd:	55                   	push   %ebp
  8017de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8017e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e6:	6a 00                	push   $0x0
  8017e8:	6a 00                	push   $0x0
  8017ea:	6a 00                	push   $0x0
  8017ec:	52                   	push   %edx
  8017ed:	50                   	push   %eax
  8017ee:	6a 08                	push   $0x8
  8017f0:	e8 45 ff ff ff       	call   80173a <syscall>
  8017f5:	83 c4 18             	add    $0x18,%esp
}
  8017f8:	c9                   	leave  
  8017f9:	c3                   	ret    

008017fa <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8017fa:	55                   	push   %ebp
  8017fb:	89 e5                	mov    %esp,%ebp
  8017fd:	56                   	push   %esi
  8017fe:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8017ff:	8b 75 18             	mov    0x18(%ebp),%esi
  801802:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801805:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801808:	8b 55 0c             	mov    0xc(%ebp),%edx
  80180b:	8b 45 08             	mov    0x8(%ebp),%eax
  80180e:	56                   	push   %esi
  80180f:	53                   	push   %ebx
  801810:	51                   	push   %ecx
  801811:	52                   	push   %edx
  801812:	50                   	push   %eax
  801813:	6a 09                	push   $0x9
  801815:	e8 20 ff ff ff       	call   80173a <syscall>
  80181a:	83 c4 18             	add    $0x18,%esp
}
  80181d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801820:	5b                   	pop    %ebx
  801821:	5e                   	pop    %esi
  801822:	5d                   	pop    %ebp
  801823:	c3                   	ret    

00801824 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801824:	55                   	push   %ebp
  801825:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801827:	6a 00                	push   $0x0
  801829:	6a 00                	push   $0x0
  80182b:	6a 00                	push   $0x0
  80182d:	6a 00                	push   $0x0
  80182f:	ff 75 08             	pushl  0x8(%ebp)
  801832:	6a 0a                	push   $0xa
  801834:	e8 01 ff ff ff       	call   80173a <syscall>
  801839:	83 c4 18             	add    $0x18,%esp
}
  80183c:	c9                   	leave  
  80183d:	c3                   	ret    

0080183e <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80183e:	55                   	push   %ebp
  80183f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801841:	6a 00                	push   $0x0
  801843:	6a 00                	push   $0x0
  801845:	6a 00                	push   $0x0
  801847:	ff 75 0c             	pushl  0xc(%ebp)
  80184a:	ff 75 08             	pushl  0x8(%ebp)
  80184d:	6a 0b                	push   $0xb
  80184f:	e8 e6 fe ff ff       	call   80173a <syscall>
  801854:	83 c4 18             	add    $0x18,%esp
}
  801857:	c9                   	leave  
  801858:	c3                   	ret    

00801859 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801859:	55                   	push   %ebp
  80185a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80185c:	6a 00                	push   $0x0
  80185e:	6a 00                	push   $0x0
  801860:	6a 00                	push   $0x0
  801862:	6a 00                	push   $0x0
  801864:	6a 00                	push   $0x0
  801866:	6a 0c                	push   $0xc
  801868:	e8 cd fe ff ff       	call   80173a <syscall>
  80186d:	83 c4 18             	add    $0x18,%esp
}
  801870:	c9                   	leave  
  801871:	c3                   	ret    

00801872 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801872:	55                   	push   %ebp
  801873:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	6a 00                	push   $0x0
  80187b:	6a 00                	push   $0x0
  80187d:	6a 00                	push   $0x0
  80187f:	6a 0d                	push   $0xd
  801881:	e8 b4 fe ff ff       	call   80173a <syscall>
  801886:	83 c4 18             	add    $0x18,%esp
}
  801889:	c9                   	leave  
  80188a:	c3                   	ret    

0080188b <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80188b:	55                   	push   %ebp
  80188c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80188e:	6a 00                	push   $0x0
  801890:	6a 00                	push   $0x0
  801892:	6a 00                	push   $0x0
  801894:	6a 00                	push   $0x0
  801896:	6a 00                	push   $0x0
  801898:	6a 0e                	push   $0xe
  80189a:	e8 9b fe ff ff       	call   80173a <syscall>
  80189f:	83 c4 18             	add    $0x18,%esp
}
  8018a2:	c9                   	leave  
  8018a3:	c3                   	ret    

008018a4 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8018a4:	55                   	push   %ebp
  8018a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8018a7:	6a 00                	push   $0x0
  8018a9:	6a 00                	push   $0x0
  8018ab:	6a 00                	push   $0x0
  8018ad:	6a 00                	push   $0x0
  8018af:	6a 00                	push   $0x0
  8018b1:	6a 0f                	push   $0xf
  8018b3:	e8 82 fe ff ff       	call   80173a <syscall>
  8018b8:	83 c4 18             	add    $0x18,%esp
}
  8018bb:	c9                   	leave  
  8018bc:	c3                   	ret    

008018bd <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8018bd:	55                   	push   %ebp
  8018be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8018c0:	6a 00                	push   $0x0
  8018c2:	6a 00                	push   $0x0
  8018c4:	6a 00                	push   $0x0
  8018c6:	6a 00                	push   $0x0
  8018c8:	ff 75 08             	pushl  0x8(%ebp)
  8018cb:	6a 10                	push   $0x10
  8018cd:	e8 68 fe ff ff       	call   80173a <syscall>
  8018d2:	83 c4 18             	add    $0x18,%esp
}
  8018d5:	c9                   	leave  
  8018d6:	c3                   	ret    

008018d7 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8018d7:	55                   	push   %ebp
  8018d8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8018da:	6a 00                	push   $0x0
  8018dc:	6a 00                	push   $0x0
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 11                	push   $0x11
  8018e6:	e8 4f fe ff ff       	call   80173a <syscall>
  8018eb:	83 c4 18             	add    $0x18,%esp
}
  8018ee:	90                   	nop
  8018ef:	c9                   	leave  
  8018f0:	c3                   	ret    

008018f1 <sys_cputc>:

void
sys_cputc(const char c)
{
  8018f1:	55                   	push   %ebp
  8018f2:	89 e5                	mov    %esp,%ebp
  8018f4:	83 ec 04             	sub    $0x4,%esp
  8018f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fa:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8018fd:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801901:	6a 00                	push   $0x0
  801903:	6a 00                	push   $0x0
  801905:	6a 00                	push   $0x0
  801907:	6a 00                	push   $0x0
  801909:	50                   	push   %eax
  80190a:	6a 01                	push   $0x1
  80190c:	e8 29 fe ff ff       	call   80173a <syscall>
  801911:	83 c4 18             	add    $0x18,%esp
}
  801914:	90                   	nop
  801915:	c9                   	leave  
  801916:	c3                   	ret    

00801917 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801917:	55                   	push   %ebp
  801918:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80191a:	6a 00                	push   $0x0
  80191c:	6a 00                	push   $0x0
  80191e:	6a 00                	push   $0x0
  801920:	6a 00                	push   $0x0
  801922:	6a 00                	push   $0x0
  801924:	6a 14                	push   $0x14
  801926:	e8 0f fe ff ff       	call   80173a <syscall>
  80192b:	83 c4 18             	add    $0x18,%esp
}
  80192e:	90                   	nop
  80192f:	c9                   	leave  
  801930:	c3                   	ret    

00801931 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801931:	55                   	push   %ebp
  801932:	89 e5                	mov    %esp,%ebp
  801934:	83 ec 04             	sub    $0x4,%esp
  801937:	8b 45 10             	mov    0x10(%ebp),%eax
  80193a:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80193d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801940:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801944:	8b 45 08             	mov    0x8(%ebp),%eax
  801947:	6a 00                	push   $0x0
  801949:	51                   	push   %ecx
  80194a:	52                   	push   %edx
  80194b:	ff 75 0c             	pushl  0xc(%ebp)
  80194e:	50                   	push   %eax
  80194f:	6a 15                	push   $0x15
  801951:	e8 e4 fd ff ff       	call   80173a <syscall>
  801956:	83 c4 18             	add    $0x18,%esp
}
  801959:	c9                   	leave  
  80195a:	c3                   	ret    

0080195b <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  80195b:	55                   	push   %ebp
  80195c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80195e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801961:	8b 45 08             	mov    0x8(%ebp),%eax
  801964:	6a 00                	push   $0x0
  801966:	6a 00                	push   $0x0
  801968:	6a 00                	push   $0x0
  80196a:	52                   	push   %edx
  80196b:	50                   	push   %eax
  80196c:	6a 16                	push   $0x16
  80196e:	e8 c7 fd ff ff       	call   80173a <syscall>
  801973:	83 c4 18             	add    $0x18,%esp
}
  801976:	c9                   	leave  
  801977:	c3                   	ret    

00801978 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801978:	55                   	push   %ebp
  801979:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80197b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80197e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801981:	8b 45 08             	mov    0x8(%ebp),%eax
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	51                   	push   %ecx
  801989:	52                   	push   %edx
  80198a:	50                   	push   %eax
  80198b:	6a 17                	push   $0x17
  80198d:	e8 a8 fd ff ff       	call   80173a <syscall>
  801992:	83 c4 18             	add    $0x18,%esp
}
  801995:	c9                   	leave  
  801996:	c3                   	ret    

00801997 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801997:	55                   	push   %ebp
  801998:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80199a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80199d:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a0:	6a 00                	push   $0x0
  8019a2:	6a 00                	push   $0x0
  8019a4:	6a 00                	push   $0x0
  8019a6:	52                   	push   %edx
  8019a7:	50                   	push   %eax
  8019a8:	6a 18                	push   $0x18
  8019aa:	e8 8b fd ff ff       	call   80173a <syscall>
  8019af:	83 c4 18             	add    $0x18,%esp
}
  8019b2:	c9                   	leave  
  8019b3:	c3                   	ret    

008019b4 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8019b4:	55                   	push   %ebp
  8019b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8019b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ba:	6a 00                	push   $0x0
  8019bc:	ff 75 14             	pushl  0x14(%ebp)
  8019bf:	ff 75 10             	pushl  0x10(%ebp)
  8019c2:	ff 75 0c             	pushl  0xc(%ebp)
  8019c5:	50                   	push   %eax
  8019c6:	6a 19                	push   $0x19
  8019c8:	e8 6d fd ff ff       	call   80173a <syscall>
  8019cd:	83 c4 18             	add    $0x18,%esp
}
  8019d0:	c9                   	leave  
  8019d1:	c3                   	ret    

008019d2 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8019d2:	55                   	push   %ebp
  8019d3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8019d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d8:	6a 00                	push   $0x0
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	50                   	push   %eax
  8019e1:	6a 1a                	push   $0x1a
  8019e3:	e8 52 fd ff ff       	call   80173a <syscall>
  8019e8:	83 c4 18             	add    $0x18,%esp
}
  8019eb:	90                   	nop
  8019ec:	c9                   	leave  
  8019ed:	c3                   	ret    

008019ee <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8019ee:	55                   	push   %ebp
  8019ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8019f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 00                	push   $0x0
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 00                	push   $0x0
  8019fc:	50                   	push   %eax
  8019fd:	6a 1b                	push   $0x1b
  8019ff:	e8 36 fd ff ff       	call   80173a <syscall>
  801a04:	83 c4 18             	add    $0x18,%esp
}
  801a07:	c9                   	leave  
  801a08:	c3                   	ret    

00801a09 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801a09:	55                   	push   %ebp
  801a0a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801a0c:	6a 00                	push   $0x0
  801a0e:	6a 00                	push   $0x0
  801a10:	6a 00                	push   $0x0
  801a12:	6a 00                	push   $0x0
  801a14:	6a 00                	push   $0x0
  801a16:	6a 05                	push   $0x5
  801a18:	e8 1d fd ff ff       	call   80173a <syscall>
  801a1d:	83 c4 18             	add    $0x18,%esp
}
  801a20:	c9                   	leave  
  801a21:	c3                   	ret    

00801a22 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801a22:	55                   	push   %ebp
  801a23:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801a25:	6a 00                	push   $0x0
  801a27:	6a 00                	push   $0x0
  801a29:	6a 00                	push   $0x0
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 00                	push   $0x0
  801a2f:	6a 06                	push   $0x6
  801a31:	e8 04 fd ff ff       	call   80173a <syscall>
  801a36:	83 c4 18             	add    $0x18,%esp
}
  801a39:	c9                   	leave  
  801a3a:	c3                   	ret    

00801a3b <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801a3b:	55                   	push   %ebp
  801a3c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801a3e:	6a 00                	push   $0x0
  801a40:	6a 00                	push   $0x0
  801a42:	6a 00                	push   $0x0
  801a44:	6a 00                	push   $0x0
  801a46:	6a 00                	push   $0x0
  801a48:	6a 07                	push   $0x7
  801a4a:	e8 eb fc ff ff       	call   80173a <syscall>
  801a4f:	83 c4 18             	add    $0x18,%esp
}
  801a52:	c9                   	leave  
  801a53:	c3                   	ret    

00801a54 <sys_exit_env>:


void sys_exit_env(void)
{
  801a54:	55                   	push   %ebp
  801a55:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801a57:	6a 00                	push   $0x0
  801a59:	6a 00                	push   $0x0
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 1c                	push   $0x1c
  801a63:	e8 d2 fc ff ff       	call   80173a <syscall>
  801a68:	83 c4 18             	add    $0x18,%esp
}
  801a6b:	90                   	nop
  801a6c:	c9                   	leave  
  801a6d:	c3                   	ret    

00801a6e <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801a6e:	55                   	push   %ebp
  801a6f:	89 e5                	mov    %esp,%ebp
  801a71:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801a74:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a77:	8d 50 04             	lea    0x4(%eax),%edx
  801a7a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 00                	push   $0x0
  801a83:	52                   	push   %edx
  801a84:	50                   	push   %eax
  801a85:	6a 1d                	push   $0x1d
  801a87:	e8 ae fc ff ff       	call   80173a <syscall>
  801a8c:	83 c4 18             	add    $0x18,%esp
	return result;
  801a8f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a92:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a95:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a98:	89 01                	mov    %eax,(%ecx)
  801a9a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa0:	c9                   	leave  
  801aa1:	c2 04 00             	ret    $0x4

00801aa4 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801aa4:	55                   	push   %ebp
  801aa5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801aa7:	6a 00                	push   $0x0
  801aa9:	6a 00                	push   $0x0
  801aab:	ff 75 10             	pushl  0x10(%ebp)
  801aae:	ff 75 0c             	pushl  0xc(%ebp)
  801ab1:	ff 75 08             	pushl  0x8(%ebp)
  801ab4:	6a 13                	push   $0x13
  801ab6:	e8 7f fc ff ff       	call   80173a <syscall>
  801abb:	83 c4 18             	add    $0x18,%esp
	return ;
  801abe:	90                   	nop
}
  801abf:	c9                   	leave  
  801ac0:	c3                   	ret    

00801ac1 <sys_rcr2>:
uint32 sys_rcr2()
{
  801ac1:	55                   	push   %ebp
  801ac2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ac4:	6a 00                	push   $0x0
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 00                	push   $0x0
  801aca:	6a 00                	push   $0x0
  801acc:	6a 00                	push   $0x0
  801ace:	6a 1e                	push   $0x1e
  801ad0:	e8 65 fc ff ff       	call   80173a <syscall>
  801ad5:	83 c4 18             	add    $0x18,%esp
}
  801ad8:	c9                   	leave  
  801ad9:	c3                   	ret    

00801ada <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801ada:	55                   	push   %ebp
  801adb:	89 e5                	mov    %esp,%ebp
  801add:	83 ec 04             	sub    $0x4,%esp
  801ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ae6:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801aea:	6a 00                	push   $0x0
  801aec:	6a 00                	push   $0x0
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	50                   	push   %eax
  801af3:	6a 1f                	push   $0x1f
  801af5:	e8 40 fc ff ff       	call   80173a <syscall>
  801afa:	83 c4 18             	add    $0x18,%esp
	return ;
  801afd:	90                   	nop
}
  801afe:	c9                   	leave  
  801aff:	c3                   	ret    

00801b00 <rsttst>:
void rsttst()
{
  801b00:	55                   	push   %ebp
  801b01:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801b03:	6a 00                	push   $0x0
  801b05:	6a 00                	push   $0x0
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 21                	push   $0x21
  801b0f:	e8 26 fc ff ff       	call   80173a <syscall>
  801b14:	83 c4 18             	add    $0x18,%esp
	return ;
  801b17:	90                   	nop
}
  801b18:	c9                   	leave  
  801b19:	c3                   	ret    

00801b1a <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801b1a:	55                   	push   %ebp
  801b1b:	89 e5                	mov    %esp,%ebp
  801b1d:	83 ec 04             	sub    $0x4,%esp
  801b20:	8b 45 14             	mov    0x14(%ebp),%eax
  801b23:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801b26:	8b 55 18             	mov    0x18(%ebp),%edx
  801b29:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b2d:	52                   	push   %edx
  801b2e:	50                   	push   %eax
  801b2f:	ff 75 10             	pushl  0x10(%ebp)
  801b32:	ff 75 0c             	pushl  0xc(%ebp)
  801b35:	ff 75 08             	pushl  0x8(%ebp)
  801b38:	6a 20                	push   $0x20
  801b3a:	e8 fb fb ff ff       	call   80173a <syscall>
  801b3f:	83 c4 18             	add    $0x18,%esp
	return ;
  801b42:	90                   	nop
}
  801b43:	c9                   	leave  
  801b44:	c3                   	ret    

00801b45 <chktst>:
void chktst(uint32 n)
{
  801b45:	55                   	push   %ebp
  801b46:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801b48:	6a 00                	push   $0x0
  801b4a:	6a 00                	push   $0x0
  801b4c:	6a 00                	push   $0x0
  801b4e:	6a 00                	push   $0x0
  801b50:	ff 75 08             	pushl  0x8(%ebp)
  801b53:	6a 22                	push   $0x22
  801b55:	e8 e0 fb ff ff       	call   80173a <syscall>
  801b5a:	83 c4 18             	add    $0x18,%esp
	return ;
  801b5d:	90                   	nop
}
  801b5e:	c9                   	leave  
  801b5f:	c3                   	ret    

00801b60 <inctst>:

void inctst()
{
  801b60:	55                   	push   %ebp
  801b61:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801b63:	6a 00                	push   $0x0
  801b65:	6a 00                	push   $0x0
  801b67:	6a 00                	push   $0x0
  801b69:	6a 00                	push   $0x0
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 23                	push   $0x23
  801b6f:	e8 c6 fb ff ff       	call   80173a <syscall>
  801b74:	83 c4 18             	add    $0x18,%esp
	return ;
  801b77:	90                   	nop
}
  801b78:	c9                   	leave  
  801b79:	c3                   	ret    

00801b7a <gettst>:
uint32 gettst()
{
  801b7a:	55                   	push   %ebp
  801b7b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 00                	push   $0x0
  801b83:	6a 00                	push   $0x0
  801b85:	6a 00                	push   $0x0
  801b87:	6a 24                	push   $0x24
  801b89:	e8 ac fb ff ff       	call   80173a <syscall>
  801b8e:	83 c4 18             	add    $0x18,%esp
}
  801b91:	c9                   	leave  
  801b92:	c3                   	ret    

00801b93 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801b93:	55                   	push   %ebp
  801b94:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b96:	6a 00                	push   $0x0
  801b98:	6a 00                	push   $0x0
  801b9a:	6a 00                	push   $0x0
  801b9c:	6a 00                	push   $0x0
  801b9e:	6a 00                	push   $0x0
  801ba0:	6a 25                	push   $0x25
  801ba2:	e8 93 fb ff ff       	call   80173a <syscall>
  801ba7:	83 c4 18             	add    $0x18,%esp
  801baa:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801baf:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801bb4:	c9                   	leave  
  801bb5:	c3                   	ret    

00801bb6 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801bb6:	55                   	push   %ebp
  801bb7:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbc:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 00                	push   $0x0
  801bc9:	ff 75 08             	pushl  0x8(%ebp)
  801bcc:	6a 26                	push   $0x26
  801bce:	e8 67 fb ff ff       	call   80173a <syscall>
  801bd3:	83 c4 18             	add    $0x18,%esp
	return ;
  801bd6:	90                   	nop
}
  801bd7:	c9                   	leave  
  801bd8:	c3                   	ret    

00801bd9 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801bd9:	55                   	push   %ebp
  801bda:	89 e5                	mov    %esp,%ebp
  801bdc:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801bdd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801be0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801be3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801be6:	8b 45 08             	mov    0x8(%ebp),%eax
  801be9:	6a 00                	push   $0x0
  801beb:	53                   	push   %ebx
  801bec:	51                   	push   %ecx
  801bed:	52                   	push   %edx
  801bee:	50                   	push   %eax
  801bef:	6a 27                	push   $0x27
  801bf1:	e8 44 fb ff ff       	call   80173a <syscall>
  801bf6:	83 c4 18             	add    $0x18,%esp
}
  801bf9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bfc:	c9                   	leave  
  801bfd:	c3                   	ret    

00801bfe <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801bfe:	55                   	push   %ebp
  801bff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801c01:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c04:	8b 45 08             	mov    0x8(%ebp),%eax
  801c07:	6a 00                	push   $0x0
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 00                	push   $0x0
  801c0d:	52                   	push   %edx
  801c0e:	50                   	push   %eax
  801c0f:	6a 28                	push   $0x28
  801c11:	e8 24 fb ff ff       	call   80173a <syscall>
  801c16:	83 c4 18             	add    $0x18,%esp
}
  801c19:	c9                   	leave  
  801c1a:	c3                   	ret    

00801c1b <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801c1b:	55                   	push   %ebp
  801c1c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801c1e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c21:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c24:	8b 45 08             	mov    0x8(%ebp),%eax
  801c27:	6a 00                	push   $0x0
  801c29:	51                   	push   %ecx
  801c2a:	ff 75 10             	pushl  0x10(%ebp)
  801c2d:	52                   	push   %edx
  801c2e:	50                   	push   %eax
  801c2f:	6a 29                	push   $0x29
  801c31:	e8 04 fb ff ff       	call   80173a <syscall>
  801c36:	83 c4 18             	add    $0x18,%esp
}
  801c39:	c9                   	leave  
  801c3a:	c3                   	ret    

00801c3b <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801c3b:	55                   	push   %ebp
  801c3c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 00                	push   $0x0
  801c42:	ff 75 10             	pushl  0x10(%ebp)
  801c45:	ff 75 0c             	pushl  0xc(%ebp)
  801c48:	ff 75 08             	pushl  0x8(%ebp)
  801c4b:	6a 12                	push   $0x12
  801c4d:	e8 e8 fa ff ff       	call   80173a <syscall>
  801c52:	83 c4 18             	add    $0x18,%esp
	return ;
  801c55:	90                   	nop
}
  801c56:	c9                   	leave  
  801c57:	c3                   	ret    

00801c58 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801c58:	55                   	push   %ebp
  801c59:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801c5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c61:	6a 00                	push   $0x0
  801c63:	6a 00                	push   $0x0
  801c65:	6a 00                	push   $0x0
  801c67:	52                   	push   %edx
  801c68:	50                   	push   %eax
  801c69:	6a 2a                	push   $0x2a
  801c6b:	e8 ca fa ff ff       	call   80173a <syscall>
  801c70:	83 c4 18             	add    $0x18,%esp
	return;
  801c73:	90                   	nop
}
  801c74:	c9                   	leave  
  801c75:	c3                   	ret    

00801c76 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801c76:	55                   	push   %ebp
  801c77:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801c79:	6a 00                	push   $0x0
  801c7b:	6a 00                	push   $0x0
  801c7d:	6a 00                	push   $0x0
  801c7f:	6a 00                	push   $0x0
  801c81:	6a 00                	push   $0x0
  801c83:	6a 2b                	push   $0x2b
  801c85:	e8 b0 fa ff ff       	call   80173a <syscall>
  801c8a:	83 c4 18             	add    $0x18,%esp
}
  801c8d:	c9                   	leave  
  801c8e:	c3                   	ret    

00801c8f <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801c8f:	55                   	push   %ebp
  801c90:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801c92:	6a 00                	push   $0x0
  801c94:	6a 00                	push   $0x0
  801c96:	6a 00                	push   $0x0
  801c98:	ff 75 0c             	pushl  0xc(%ebp)
  801c9b:	ff 75 08             	pushl  0x8(%ebp)
  801c9e:	6a 2d                	push   $0x2d
  801ca0:	e8 95 fa ff ff       	call   80173a <syscall>
  801ca5:	83 c4 18             	add    $0x18,%esp
	return;
  801ca8:	90                   	nop
}
  801ca9:	c9                   	leave  
  801caa:	c3                   	ret    

00801cab <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801cab:	55                   	push   %ebp
  801cac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 00                	push   $0x0
  801cb2:	6a 00                	push   $0x0
  801cb4:	ff 75 0c             	pushl  0xc(%ebp)
  801cb7:	ff 75 08             	pushl  0x8(%ebp)
  801cba:	6a 2c                	push   $0x2c
  801cbc:	e8 79 fa ff ff       	call   80173a <syscall>
  801cc1:	83 c4 18             	add    $0x18,%esp
	return ;
  801cc4:	90                   	nop
}
  801cc5:	c9                   	leave  
  801cc6:	c3                   	ret    

00801cc7 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801cc7:	55                   	push   %ebp
  801cc8:	89 e5                	mov    %esp,%ebp
  801cca:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801ccd:	83 ec 04             	sub    $0x4,%esp
  801cd0:	68 5c 28 80 00       	push   $0x80285c
  801cd5:	68 25 01 00 00       	push   $0x125
  801cda:	68 8f 28 80 00       	push   $0x80288f
  801cdf:	e8 9b e6 ff ff       	call   80037f <_panic>

00801ce4 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801ce4:	55                   	push   %ebp
  801ce5:	89 e5                	mov    %esp,%ebp
  801ce7:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801cea:	8b 55 08             	mov    0x8(%ebp),%edx
  801ced:	89 d0                	mov    %edx,%eax
  801cef:	c1 e0 02             	shl    $0x2,%eax
  801cf2:	01 d0                	add    %edx,%eax
  801cf4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801cfb:	01 d0                	add    %edx,%eax
  801cfd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801d04:	01 d0                	add    %edx,%eax
  801d06:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801d0d:	01 d0                	add    %edx,%eax
  801d0f:	c1 e0 04             	shl    $0x4,%eax
  801d12:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  801d15:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  801d1c:	0f 31                	rdtsc  
  801d1e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801d21:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  801d24:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d27:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801d2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d2d:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801d30:	eb 46                	jmp    801d78 <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  801d32:	0f 31                	rdtsc  
  801d34:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801d37:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  801d3a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801d3d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801d40:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801d43:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801d46:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d4c:	29 c2                	sub    %eax,%edx
  801d4e:	89 d0                	mov    %edx,%eax
  801d50:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801d53:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801d56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d59:	89 d1                	mov    %edx,%ecx
  801d5b:	29 c1                	sub    %eax,%ecx
  801d5d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801d60:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d63:	39 c2                	cmp    %eax,%edx
  801d65:	0f 97 c0             	seta   %al
  801d68:	0f b6 c0             	movzbl %al,%eax
  801d6b:	29 c1                	sub    %eax,%ecx
  801d6d:	89 c8                	mov    %ecx,%eax
  801d6f:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801d72:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801d75:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801d78:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d7b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801d7e:	72 b2                	jb     801d32 <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801d80:	90                   	nop
  801d81:	c9                   	leave  
  801d82:	c3                   	ret    

00801d83 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801d83:	55                   	push   %ebp
  801d84:	89 e5                	mov    %esp,%ebp
  801d86:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801d89:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801d90:	eb 03                	jmp    801d95 <busy_wait+0x12>
  801d92:	ff 45 fc             	incl   -0x4(%ebp)
  801d95:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d98:	3b 45 08             	cmp    0x8(%ebp),%eax
  801d9b:	72 f5                	jb     801d92 <busy_wait+0xf>
	return i;
  801d9d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801da0:	c9                   	leave  
  801da1:	c3                   	ret    

00801da2 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  801da2:	55                   	push   %ebp
  801da3:	89 e5                	mov    %esp,%ebp
  801da5:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  801da8:	8b 45 08             	mov    0x8(%ebp),%eax
  801dab:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  801dae:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  801db2:	83 ec 0c             	sub    $0xc,%esp
  801db5:	50                   	push   %eax
  801db6:	e8 36 fb ff ff       	call   8018f1 <sys_cputc>
  801dbb:	83 c4 10             	add    $0x10,%esp
}
  801dbe:	90                   	nop
  801dbf:	c9                   	leave  
  801dc0:	c3                   	ret    

00801dc1 <getchar>:


int
getchar(void)
{
  801dc1:	55                   	push   %ebp
  801dc2:	89 e5                	mov    %esp,%ebp
  801dc4:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  801dc7:	e8 c4 f9 ff ff       	call   801790 <sys_cgetc>
  801dcc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  801dcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801dd2:	c9                   	leave  
  801dd3:	c3                   	ret    

00801dd4 <iscons>:

int iscons(int fdnum)
{
  801dd4:	55                   	push   %ebp
  801dd5:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  801dd7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801ddc:	5d                   	pop    %ebp
  801ddd:	c3                   	ret    
  801dde:	66 90                	xchg   %ax,%ax

00801de0 <__udivdi3>:
  801de0:	55                   	push   %ebp
  801de1:	57                   	push   %edi
  801de2:	56                   	push   %esi
  801de3:	53                   	push   %ebx
  801de4:	83 ec 1c             	sub    $0x1c,%esp
  801de7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801deb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801def:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801df3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801df7:	89 ca                	mov    %ecx,%edx
  801df9:	89 f8                	mov    %edi,%eax
  801dfb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801dff:	85 f6                	test   %esi,%esi
  801e01:	75 2d                	jne    801e30 <__udivdi3+0x50>
  801e03:	39 cf                	cmp    %ecx,%edi
  801e05:	77 65                	ja     801e6c <__udivdi3+0x8c>
  801e07:	89 fd                	mov    %edi,%ebp
  801e09:	85 ff                	test   %edi,%edi
  801e0b:	75 0b                	jne    801e18 <__udivdi3+0x38>
  801e0d:	b8 01 00 00 00       	mov    $0x1,%eax
  801e12:	31 d2                	xor    %edx,%edx
  801e14:	f7 f7                	div    %edi
  801e16:	89 c5                	mov    %eax,%ebp
  801e18:	31 d2                	xor    %edx,%edx
  801e1a:	89 c8                	mov    %ecx,%eax
  801e1c:	f7 f5                	div    %ebp
  801e1e:	89 c1                	mov    %eax,%ecx
  801e20:	89 d8                	mov    %ebx,%eax
  801e22:	f7 f5                	div    %ebp
  801e24:	89 cf                	mov    %ecx,%edi
  801e26:	89 fa                	mov    %edi,%edx
  801e28:	83 c4 1c             	add    $0x1c,%esp
  801e2b:	5b                   	pop    %ebx
  801e2c:	5e                   	pop    %esi
  801e2d:	5f                   	pop    %edi
  801e2e:	5d                   	pop    %ebp
  801e2f:	c3                   	ret    
  801e30:	39 ce                	cmp    %ecx,%esi
  801e32:	77 28                	ja     801e5c <__udivdi3+0x7c>
  801e34:	0f bd fe             	bsr    %esi,%edi
  801e37:	83 f7 1f             	xor    $0x1f,%edi
  801e3a:	75 40                	jne    801e7c <__udivdi3+0x9c>
  801e3c:	39 ce                	cmp    %ecx,%esi
  801e3e:	72 0a                	jb     801e4a <__udivdi3+0x6a>
  801e40:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801e44:	0f 87 9e 00 00 00    	ja     801ee8 <__udivdi3+0x108>
  801e4a:	b8 01 00 00 00       	mov    $0x1,%eax
  801e4f:	89 fa                	mov    %edi,%edx
  801e51:	83 c4 1c             	add    $0x1c,%esp
  801e54:	5b                   	pop    %ebx
  801e55:	5e                   	pop    %esi
  801e56:	5f                   	pop    %edi
  801e57:	5d                   	pop    %ebp
  801e58:	c3                   	ret    
  801e59:	8d 76 00             	lea    0x0(%esi),%esi
  801e5c:	31 ff                	xor    %edi,%edi
  801e5e:	31 c0                	xor    %eax,%eax
  801e60:	89 fa                	mov    %edi,%edx
  801e62:	83 c4 1c             	add    $0x1c,%esp
  801e65:	5b                   	pop    %ebx
  801e66:	5e                   	pop    %esi
  801e67:	5f                   	pop    %edi
  801e68:	5d                   	pop    %ebp
  801e69:	c3                   	ret    
  801e6a:	66 90                	xchg   %ax,%ax
  801e6c:	89 d8                	mov    %ebx,%eax
  801e6e:	f7 f7                	div    %edi
  801e70:	31 ff                	xor    %edi,%edi
  801e72:	89 fa                	mov    %edi,%edx
  801e74:	83 c4 1c             	add    $0x1c,%esp
  801e77:	5b                   	pop    %ebx
  801e78:	5e                   	pop    %esi
  801e79:	5f                   	pop    %edi
  801e7a:	5d                   	pop    %ebp
  801e7b:	c3                   	ret    
  801e7c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801e81:	89 eb                	mov    %ebp,%ebx
  801e83:	29 fb                	sub    %edi,%ebx
  801e85:	89 f9                	mov    %edi,%ecx
  801e87:	d3 e6                	shl    %cl,%esi
  801e89:	89 c5                	mov    %eax,%ebp
  801e8b:	88 d9                	mov    %bl,%cl
  801e8d:	d3 ed                	shr    %cl,%ebp
  801e8f:	89 e9                	mov    %ebp,%ecx
  801e91:	09 f1                	or     %esi,%ecx
  801e93:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801e97:	89 f9                	mov    %edi,%ecx
  801e99:	d3 e0                	shl    %cl,%eax
  801e9b:	89 c5                	mov    %eax,%ebp
  801e9d:	89 d6                	mov    %edx,%esi
  801e9f:	88 d9                	mov    %bl,%cl
  801ea1:	d3 ee                	shr    %cl,%esi
  801ea3:	89 f9                	mov    %edi,%ecx
  801ea5:	d3 e2                	shl    %cl,%edx
  801ea7:	8b 44 24 08          	mov    0x8(%esp),%eax
  801eab:	88 d9                	mov    %bl,%cl
  801ead:	d3 e8                	shr    %cl,%eax
  801eaf:	09 c2                	or     %eax,%edx
  801eb1:	89 d0                	mov    %edx,%eax
  801eb3:	89 f2                	mov    %esi,%edx
  801eb5:	f7 74 24 0c          	divl   0xc(%esp)
  801eb9:	89 d6                	mov    %edx,%esi
  801ebb:	89 c3                	mov    %eax,%ebx
  801ebd:	f7 e5                	mul    %ebp
  801ebf:	39 d6                	cmp    %edx,%esi
  801ec1:	72 19                	jb     801edc <__udivdi3+0xfc>
  801ec3:	74 0b                	je     801ed0 <__udivdi3+0xf0>
  801ec5:	89 d8                	mov    %ebx,%eax
  801ec7:	31 ff                	xor    %edi,%edi
  801ec9:	e9 58 ff ff ff       	jmp    801e26 <__udivdi3+0x46>
  801ece:	66 90                	xchg   %ax,%ax
  801ed0:	8b 54 24 08          	mov    0x8(%esp),%edx
  801ed4:	89 f9                	mov    %edi,%ecx
  801ed6:	d3 e2                	shl    %cl,%edx
  801ed8:	39 c2                	cmp    %eax,%edx
  801eda:	73 e9                	jae    801ec5 <__udivdi3+0xe5>
  801edc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801edf:	31 ff                	xor    %edi,%edi
  801ee1:	e9 40 ff ff ff       	jmp    801e26 <__udivdi3+0x46>
  801ee6:	66 90                	xchg   %ax,%ax
  801ee8:	31 c0                	xor    %eax,%eax
  801eea:	e9 37 ff ff ff       	jmp    801e26 <__udivdi3+0x46>
  801eef:	90                   	nop

00801ef0 <__umoddi3>:
  801ef0:	55                   	push   %ebp
  801ef1:	57                   	push   %edi
  801ef2:	56                   	push   %esi
  801ef3:	53                   	push   %ebx
  801ef4:	83 ec 1c             	sub    $0x1c,%esp
  801ef7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801efb:	8b 74 24 34          	mov    0x34(%esp),%esi
  801eff:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801f03:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801f07:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801f0b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801f0f:	89 f3                	mov    %esi,%ebx
  801f11:	89 fa                	mov    %edi,%edx
  801f13:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801f17:	89 34 24             	mov    %esi,(%esp)
  801f1a:	85 c0                	test   %eax,%eax
  801f1c:	75 1a                	jne    801f38 <__umoddi3+0x48>
  801f1e:	39 f7                	cmp    %esi,%edi
  801f20:	0f 86 a2 00 00 00    	jbe    801fc8 <__umoddi3+0xd8>
  801f26:	89 c8                	mov    %ecx,%eax
  801f28:	89 f2                	mov    %esi,%edx
  801f2a:	f7 f7                	div    %edi
  801f2c:	89 d0                	mov    %edx,%eax
  801f2e:	31 d2                	xor    %edx,%edx
  801f30:	83 c4 1c             	add    $0x1c,%esp
  801f33:	5b                   	pop    %ebx
  801f34:	5e                   	pop    %esi
  801f35:	5f                   	pop    %edi
  801f36:	5d                   	pop    %ebp
  801f37:	c3                   	ret    
  801f38:	39 f0                	cmp    %esi,%eax
  801f3a:	0f 87 ac 00 00 00    	ja     801fec <__umoddi3+0xfc>
  801f40:	0f bd e8             	bsr    %eax,%ebp
  801f43:	83 f5 1f             	xor    $0x1f,%ebp
  801f46:	0f 84 ac 00 00 00    	je     801ff8 <__umoddi3+0x108>
  801f4c:	bf 20 00 00 00       	mov    $0x20,%edi
  801f51:	29 ef                	sub    %ebp,%edi
  801f53:	89 fe                	mov    %edi,%esi
  801f55:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801f59:	89 e9                	mov    %ebp,%ecx
  801f5b:	d3 e0                	shl    %cl,%eax
  801f5d:	89 d7                	mov    %edx,%edi
  801f5f:	89 f1                	mov    %esi,%ecx
  801f61:	d3 ef                	shr    %cl,%edi
  801f63:	09 c7                	or     %eax,%edi
  801f65:	89 e9                	mov    %ebp,%ecx
  801f67:	d3 e2                	shl    %cl,%edx
  801f69:	89 14 24             	mov    %edx,(%esp)
  801f6c:	89 d8                	mov    %ebx,%eax
  801f6e:	d3 e0                	shl    %cl,%eax
  801f70:	89 c2                	mov    %eax,%edx
  801f72:	8b 44 24 08          	mov    0x8(%esp),%eax
  801f76:	d3 e0                	shl    %cl,%eax
  801f78:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f7c:	8b 44 24 08          	mov    0x8(%esp),%eax
  801f80:	89 f1                	mov    %esi,%ecx
  801f82:	d3 e8                	shr    %cl,%eax
  801f84:	09 d0                	or     %edx,%eax
  801f86:	d3 eb                	shr    %cl,%ebx
  801f88:	89 da                	mov    %ebx,%edx
  801f8a:	f7 f7                	div    %edi
  801f8c:	89 d3                	mov    %edx,%ebx
  801f8e:	f7 24 24             	mull   (%esp)
  801f91:	89 c6                	mov    %eax,%esi
  801f93:	89 d1                	mov    %edx,%ecx
  801f95:	39 d3                	cmp    %edx,%ebx
  801f97:	0f 82 87 00 00 00    	jb     802024 <__umoddi3+0x134>
  801f9d:	0f 84 91 00 00 00    	je     802034 <__umoddi3+0x144>
  801fa3:	8b 54 24 04          	mov    0x4(%esp),%edx
  801fa7:	29 f2                	sub    %esi,%edx
  801fa9:	19 cb                	sbb    %ecx,%ebx
  801fab:	89 d8                	mov    %ebx,%eax
  801fad:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801fb1:	d3 e0                	shl    %cl,%eax
  801fb3:	89 e9                	mov    %ebp,%ecx
  801fb5:	d3 ea                	shr    %cl,%edx
  801fb7:	09 d0                	or     %edx,%eax
  801fb9:	89 e9                	mov    %ebp,%ecx
  801fbb:	d3 eb                	shr    %cl,%ebx
  801fbd:	89 da                	mov    %ebx,%edx
  801fbf:	83 c4 1c             	add    $0x1c,%esp
  801fc2:	5b                   	pop    %ebx
  801fc3:	5e                   	pop    %esi
  801fc4:	5f                   	pop    %edi
  801fc5:	5d                   	pop    %ebp
  801fc6:	c3                   	ret    
  801fc7:	90                   	nop
  801fc8:	89 fd                	mov    %edi,%ebp
  801fca:	85 ff                	test   %edi,%edi
  801fcc:	75 0b                	jne    801fd9 <__umoddi3+0xe9>
  801fce:	b8 01 00 00 00       	mov    $0x1,%eax
  801fd3:	31 d2                	xor    %edx,%edx
  801fd5:	f7 f7                	div    %edi
  801fd7:	89 c5                	mov    %eax,%ebp
  801fd9:	89 f0                	mov    %esi,%eax
  801fdb:	31 d2                	xor    %edx,%edx
  801fdd:	f7 f5                	div    %ebp
  801fdf:	89 c8                	mov    %ecx,%eax
  801fe1:	f7 f5                	div    %ebp
  801fe3:	89 d0                	mov    %edx,%eax
  801fe5:	e9 44 ff ff ff       	jmp    801f2e <__umoddi3+0x3e>
  801fea:	66 90                	xchg   %ax,%ax
  801fec:	89 c8                	mov    %ecx,%eax
  801fee:	89 f2                	mov    %esi,%edx
  801ff0:	83 c4 1c             	add    $0x1c,%esp
  801ff3:	5b                   	pop    %ebx
  801ff4:	5e                   	pop    %esi
  801ff5:	5f                   	pop    %edi
  801ff6:	5d                   	pop    %ebp
  801ff7:	c3                   	ret    
  801ff8:	3b 04 24             	cmp    (%esp),%eax
  801ffb:	72 06                	jb     802003 <__umoddi3+0x113>
  801ffd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802001:	77 0f                	ja     802012 <__umoddi3+0x122>
  802003:	89 f2                	mov    %esi,%edx
  802005:	29 f9                	sub    %edi,%ecx
  802007:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80200b:	89 14 24             	mov    %edx,(%esp)
  80200e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802012:	8b 44 24 04          	mov    0x4(%esp),%eax
  802016:	8b 14 24             	mov    (%esp),%edx
  802019:	83 c4 1c             	add    $0x1c,%esp
  80201c:	5b                   	pop    %ebx
  80201d:	5e                   	pop    %esi
  80201e:	5f                   	pop    %edi
  80201f:	5d                   	pop    %ebp
  802020:	c3                   	ret    
  802021:	8d 76 00             	lea    0x0(%esi),%esi
  802024:	2b 04 24             	sub    (%esp),%eax
  802027:	19 fa                	sbb    %edi,%edx
  802029:	89 d1                	mov    %edx,%ecx
  80202b:	89 c6                	mov    %eax,%esi
  80202d:	e9 71 ff ff ff       	jmp    801fa3 <__umoddi3+0xb3>
  802032:	66 90                	xchg   %ax,%ax
  802034:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802038:	72 ea                	jb     802024 <__umoddi3+0x134>
  80203a:	89 d9                	mov    %ebx,%ecx
  80203c:	e9 62 ff ff ff       	jmp    801fa3 <__umoddi3+0xb3>

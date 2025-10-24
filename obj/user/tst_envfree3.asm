
obj/user/tst_envfree3:     file format elf32-i386


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
  800031:	e8 3b 02 00 00       	call   800271 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Scenario that tests the usage of shared variables
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec 8c 01 00 00    	sub    $0x18c,%esp
	// Testing scenario 3: using dynamic allocation and free. Kill itself!
	// Testing removing the allocated pages (static & dynamic) in mem, WS, mapped page tables, env's directory and env's page file

	char getksbrkCmd[100] = "__getKernelSBreak__";
  800044:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
  80004a:	bb bd 1f 80 00       	mov    $0x801fbd,%ebx
  80004f:	ba 05 00 00 00       	mov    $0x5,%edx
  800054:	89 c7                	mov    %eax,%edi
  800056:	89 de                	mov    %ebx,%esi
  800058:	89 d1                	mov    %edx,%ecx
  80005a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80005c:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
  800062:	b9 14 00 00 00       	mov    $0x14,%ecx
  800067:	b8 00 00 00 00       	mov    $0x0,%eax
  80006c:	89 d7                	mov    %edx,%edi
  80006e:	f3 ab                	rep stos %eax,%es:(%edi)
	uint32 ksbrk_before ;
	sys_utilities(getksbrkCmd, (uint32)&ksbrk_before);
  800070:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
  800076:	83 ec 08             	sub    $0x8,%esp
  800079:	50                   	push   %eax
  80007a:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
  800080:	50                   	push   %eax
  800081:	e8 6c 1a 00 00       	call   801af2 <sys_utilities>
  800086:	83 c4 10             	add    $0x10,%esp

	int freeFrames_before = sys_calculate_free_frames() ;
  800089:	e8 65 16 00 00       	call   8016f3 <sys_calculate_free_frames>
  80008e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800091:	e8 a8 16 00 00       	call   80173e <sys_pf_calculate_allocated_pages>
  800096:	89 45 e0             	mov    %eax,-0x20(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  800099:	83 ec 08             	sub    $0x8,%esp
  80009c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80009f:	68 00 1e 80 00       	push   $0x801e00
  8000a4:	e8 46 06 00 00       	call   8006ef <cprintf>
  8000a9:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcess = sys_create_env("tef3_slave", myEnv->page_WS_max_size,(myEnv->SecondListSize), 50);
  8000ac:	a1 20 30 80 00       	mov    0x803020,%eax
  8000b1:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  8000b7:	89 c2                	mov    %eax,%edx
  8000b9:	a1 20 30 80 00       	mov    0x803020,%eax
  8000be:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000c4:	6a 32                	push   $0x32
  8000c6:	52                   	push   %edx
  8000c7:	50                   	push   %eax
  8000c8:	68 33 1e 80 00       	push   $0x801e33
  8000cd:	e8 7c 17 00 00       	call   80184e <sys_create_env>
  8000d2:	83 c4 10             	add    $0x10,%esp
  8000d5:	89 45 dc             	mov    %eax,-0x24(%ebp)

	sys_run_env(envIdProcess);
  8000d8:	83 ec 0c             	sub    $0xc,%esp
  8000db:	ff 75 dc             	pushl  -0x24(%ebp)
  8000de:	e8 89 17 00 00       	call   80186c <sys_run_env>
  8000e3:	83 c4 10             	add    $0x10,%esp

	char getProcStateCmd[100] = "__getProcState@";
  8000e6:	8d 85 f4 fe ff ff    	lea    -0x10c(%ebp),%eax
  8000ec:	bb 21 20 80 00       	mov    $0x802021,%ebx
  8000f1:	ba 04 00 00 00       	mov    $0x4,%edx
  8000f6:	89 c7                	mov    %eax,%edi
  8000f8:	89 de                	mov    %ebx,%esi
  8000fa:	89 d1                	mov    %edx,%ecx
  8000fc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8000fe:	8d 95 04 ff ff ff    	lea    -0xfc(%ebp),%edx
  800104:	b9 15 00 00 00       	mov    $0x15,%ecx
  800109:	b8 00 00 00 00       	mov    $0x0,%eax
  80010e:	89 d7                	mov    %edx,%edi
  800110:	f3 ab                	rep stos %eax,%es:(%edi)
	int procState = 0;
  800112:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800119:	00 00 00 
	do
	{
		char id[20] ;
		ltostr(envIdProcess, id);
  80011c:	83 ec 08             	sub    $0x8,%esp
  80011f:	8d 85 d8 fe ff ff    	lea    -0x128(%ebp),%eax
  800125:	50                   	push   %eax
  800126:	ff 75 dc             	pushl  -0x24(%ebp)
  800129:	e8 ef 11 00 00       	call   80131d <ltostr>
  80012e:	83 c4 10             	add    $0x10,%esp
		char getProcStateWithIDCmd[100] ;
		strcconcat(getProcStateCmd, id, getProcStateWithIDCmd);
  800131:	83 ec 04             	sub    $0x4,%esp
  800134:	8d 85 74 fe ff ff    	lea    -0x18c(%ebp),%eax
  80013a:	50                   	push   %eax
  80013b:	8d 85 d8 fe ff ff    	lea    -0x128(%ebp),%eax
  800141:	50                   	push   %eax
  800142:	8d 85 f4 fe ff ff    	lea    -0x10c(%ebp),%eax
  800148:	50                   	push   %eax
  800149:	e8 a8 12 00 00       	call   8013f6 <strcconcat>
  80014e:	83 c4 10             	add    $0x10,%esp

		sys_utilities(getProcStateWithIDCmd, (uint32)&procState) ;
  800151:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800157:	83 ec 08             	sub    $0x8,%esp
  80015a:	50                   	push   %eax
  80015b:	8d 85 74 fe ff ff    	lea    -0x18c(%ebp),%eax
  800161:	50                   	push   %eax
  800162:	e8 8b 19 00 00       	call   801af2 <sys_utilities>
  800167:	83 c4 10             	add    $0x10,%esp
		//cprintf("status of env %d = %d\n", envIdProcess, procState);
	}
	while (procState != E_BAD_ENV) ;
  80016a:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800170:	83 f8 fe             	cmp    $0xfffffffe,%eax
  800173:	75 a7                	jne    80011c <_main+0xe4>

	uint32 ksbrk_after ;
	sys_utilities(getksbrkCmd, (uint32)&ksbrk_after);
  800175:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
  80017b:	83 ec 08             	sub    $0x8,%esp
  80017e:	50                   	push   %eax
  80017f:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
  800185:	50                   	push   %eax
  800186:	e8 67 19 00 00       	call   801af2 <sys_utilities>
  80018b:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  80018e:	e8 60 15 00 00       	call   8016f3 <sys_calculate_free_frames>
  800193:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  800196:	e8 a3 15 00 00       	call   80173e <sys_pf_calculate_allocated_pages>
  80019b:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	int expected = (ROUNDUP((uint32)ksbrk_after, PAGE_SIZE) - ROUNDUP((uint32)ksbrk_before, PAGE_SIZE)) / PAGE_SIZE;
  80019e:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  8001a5:	8b 95 ec fe ff ff    	mov    -0x114(%ebp),%edx
  8001ab:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8001ae:	01 d0                	add    %edx,%eax
  8001b0:	48                   	dec    %eax
  8001b1:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8001b4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8001bc:	f7 75 d0             	divl   -0x30(%ebp)
  8001bf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001c2:	29 d0                	sub    %edx,%eax
  8001c4:	89 c1                	mov    %eax,%ecx
  8001c6:	c7 45 c8 00 10 00 00 	movl   $0x1000,-0x38(%ebp)
  8001cd:	8b 95 58 ff ff ff    	mov    -0xa8(%ebp),%edx
  8001d3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8001d6:	01 d0                	add    %edx,%eax
  8001d8:	48                   	dec    %eax
  8001d9:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8001dc:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8001df:	ba 00 00 00 00       	mov    $0x0,%edx
  8001e4:	f7 75 c8             	divl   -0x38(%ebp)
  8001e7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8001ea:	29 d0                	sub    %edx,%eax
  8001ec:	29 c1                	sub    %eax,%ecx
  8001ee:	89 c8                	mov    %ecx,%eax
  8001f0:	c1 e8 0c             	shr    $0xc,%eax
  8001f3:	89 45 c0             	mov    %eax,-0x40(%ebp)
	cprintf("expected = %d\n",expected);
  8001f6:	83 ec 08             	sub    $0x8,%esp
  8001f9:	ff 75 c0             	pushl  -0x40(%ebp)
  8001fc:	68 3e 1e 80 00       	push   $0x801e3e
  800201:	e8 e9 04 00 00       	call   8006ef <cprintf>
  800206:	83 c4 10             	add    $0x10,%esp
	if ((freeFrames_before - freeFrames_after) != expected) {
  800209:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80020c:	2b 45 d8             	sub    -0x28(%ebp),%eax
  80020f:	3b 45 c0             	cmp    -0x40(%ebp),%eax
  800212:	74 2e                	je     800242 <_main+0x20a>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\ndifference = %d, expected = %d\n",
  800214:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800217:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80021a:	ff 75 c0             	pushl  -0x40(%ebp)
  80021d:	50                   	push   %eax
  80021e:	ff 75 d8             	pushl  -0x28(%ebp)
  800221:	68 50 1e 80 00       	push   $0x801e50
  800226:	e8 c4 04 00 00       	call   8006ef <cprintf>
  80022b:	83 c4 10             	add    $0x10,%esp
				freeFrames_after, freeFrames_after - freeFrames_before, expected);
		panic("env_free() does not work correctly... check it again.");
  80022e:	83 ec 04             	sub    $0x4,%esp
  800231:	68 c0 1e 80 00       	push   $0x801ec0
  800236:	6a 2f                	push   $0x2f
  800238:	68 f6 1e 80 00       	push   $0x801ef6
  80023d:	e8 df 01 00 00       	call   800421 <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back as expected = %d + kbreak pages (%d)\n", freeFrames_after, expected);
  800242:	83 ec 04             	sub    $0x4,%esp
  800245:	ff 75 c0             	pushl  -0x40(%ebp)
  800248:	ff 75 d8             	pushl  -0x28(%ebp)
  80024b:	68 0c 1f 80 00       	push   $0x801f0c
  800250:	e8 9a 04 00 00       	call   8006ef <cprintf>
  800255:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 3 for envfree completed successfully.\n");
  800258:	83 ec 0c             	sub    $0xc,%esp
  80025b:	68 74 1f 80 00       	push   $0x801f74
  800260:	e8 8a 04 00 00       	call   8006ef <cprintf>
  800265:	83 c4 10             	add    $0x10,%esp
	return;
  800268:	90                   	nop
}
  800269:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80026c:	5b                   	pop    %ebx
  80026d:	5e                   	pop    %esi
  80026e:	5f                   	pop    %edi
  80026f:	5d                   	pop    %ebp
  800270:	c3                   	ret    

00800271 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800271:	55                   	push   %ebp
  800272:	89 e5                	mov    %esp,%ebp
  800274:	57                   	push   %edi
  800275:	56                   	push   %esi
  800276:	53                   	push   %ebx
  800277:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80027a:	e8 3d 16 00 00       	call   8018bc <sys_getenvindex>
  80027f:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800282:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800285:	89 d0                	mov    %edx,%eax
  800287:	c1 e0 02             	shl    $0x2,%eax
  80028a:	01 d0                	add    %edx,%eax
  80028c:	c1 e0 03             	shl    $0x3,%eax
  80028f:	01 d0                	add    %edx,%eax
  800291:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800298:	01 d0                	add    %edx,%eax
  80029a:	c1 e0 02             	shl    $0x2,%eax
  80029d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002a2:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8002a7:	a1 20 30 80 00       	mov    0x803020,%eax
  8002ac:	8a 40 20             	mov    0x20(%eax),%al
  8002af:	84 c0                	test   %al,%al
  8002b1:	74 0d                	je     8002c0 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8002b3:	a1 20 30 80 00       	mov    0x803020,%eax
  8002b8:	83 c0 20             	add    $0x20,%eax
  8002bb:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002c0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8002c4:	7e 0a                	jle    8002d0 <libmain+0x5f>
		binaryname = argv[0];
  8002c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002c9:	8b 00                	mov    (%eax),%eax
  8002cb:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  8002d0:	83 ec 08             	sub    $0x8,%esp
  8002d3:	ff 75 0c             	pushl  0xc(%ebp)
  8002d6:	ff 75 08             	pushl  0x8(%ebp)
  8002d9:	e8 5a fd ff ff       	call   800038 <_main>
  8002de:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8002e1:	a1 00 30 80 00       	mov    0x803000,%eax
  8002e6:	85 c0                	test   %eax,%eax
  8002e8:	0f 84 01 01 00 00    	je     8003ef <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8002ee:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8002f4:	bb 80 21 80 00       	mov    $0x802180,%ebx
  8002f9:	ba 0e 00 00 00       	mov    $0xe,%edx
  8002fe:	89 c7                	mov    %eax,%edi
  800300:	89 de                	mov    %ebx,%esi
  800302:	89 d1                	mov    %edx,%ecx
  800304:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800306:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800309:	b9 56 00 00 00       	mov    $0x56,%ecx
  80030e:	b0 00                	mov    $0x0,%al
  800310:	89 d7                	mov    %edx,%edi
  800312:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800314:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80031b:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80031e:	83 ec 08             	sub    $0x8,%esp
  800321:	50                   	push   %eax
  800322:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800328:	50                   	push   %eax
  800329:	e8 c4 17 00 00       	call   801af2 <sys_utilities>
  80032e:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800331:	e8 0d 13 00 00       	call   801643 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800336:	83 ec 0c             	sub    $0xc,%esp
  800339:	68 a0 20 80 00       	push   $0x8020a0
  80033e:	e8 ac 03 00 00       	call   8006ef <cprintf>
  800343:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800346:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800349:	85 c0                	test   %eax,%eax
  80034b:	74 18                	je     800365 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80034d:	e8 be 17 00 00       	call   801b10 <sys_get_optimal_num_faults>
  800352:	83 ec 08             	sub    $0x8,%esp
  800355:	50                   	push   %eax
  800356:	68 c8 20 80 00       	push   $0x8020c8
  80035b:	e8 8f 03 00 00       	call   8006ef <cprintf>
  800360:	83 c4 10             	add    $0x10,%esp
  800363:	eb 59                	jmp    8003be <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800365:	a1 20 30 80 00       	mov    0x803020,%eax
  80036a:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  800370:	a1 20 30 80 00       	mov    0x803020,%eax
  800375:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  80037b:	83 ec 04             	sub    $0x4,%esp
  80037e:	52                   	push   %edx
  80037f:	50                   	push   %eax
  800380:	68 ec 20 80 00       	push   $0x8020ec
  800385:	e8 65 03 00 00       	call   8006ef <cprintf>
  80038a:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80038d:	a1 20 30 80 00       	mov    0x803020,%eax
  800392:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800398:	a1 20 30 80 00       	mov    0x803020,%eax
  80039d:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  8003a3:	a1 20 30 80 00       	mov    0x803020,%eax
  8003a8:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  8003ae:	51                   	push   %ecx
  8003af:	52                   	push   %edx
  8003b0:	50                   	push   %eax
  8003b1:	68 14 21 80 00       	push   $0x802114
  8003b6:	e8 34 03 00 00       	call   8006ef <cprintf>
  8003bb:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8003be:	a1 20 30 80 00       	mov    0x803020,%eax
  8003c3:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  8003c9:	83 ec 08             	sub    $0x8,%esp
  8003cc:	50                   	push   %eax
  8003cd:	68 6c 21 80 00       	push   $0x80216c
  8003d2:	e8 18 03 00 00       	call   8006ef <cprintf>
  8003d7:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8003da:	83 ec 0c             	sub    $0xc,%esp
  8003dd:	68 a0 20 80 00       	push   $0x8020a0
  8003e2:	e8 08 03 00 00       	call   8006ef <cprintf>
  8003e7:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8003ea:	e8 6e 12 00 00       	call   80165d <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8003ef:	e8 1f 00 00 00       	call   800413 <exit>
}
  8003f4:	90                   	nop
  8003f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003f8:	5b                   	pop    %ebx
  8003f9:	5e                   	pop    %esi
  8003fa:	5f                   	pop    %edi
  8003fb:	5d                   	pop    %ebp
  8003fc:	c3                   	ret    

008003fd <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8003fd:	55                   	push   %ebp
  8003fe:	89 e5                	mov    %esp,%ebp
  800400:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800403:	83 ec 0c             	sub    $0xc,%esp
  800406:	6a 00                	push   $0x0
  800408:	e8 7b 14 00 00       	call   801888 <sys_destroy_env>
  80040d:	83 c4 10             	add    $0x10,%esp
}
  800410:	90                   	nop
  800411:	c9                   	leave  
  800412:	c3                   	ret    

00800413 <exit>:

void
exit(void)
{
  800413:	55                   	push   %ebp
  800414:	89 e5                	mov    %esp,%ebp
  800416:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800419:	e8 d0 14 00 00       	call   8018ee <sys_exit_env>
}
  80041e:	90                   	nop
  80041f:	c9                   	leave  
  800420:	c3                   	ret    

00800421 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800421:	55                   	push   %ebp
  800422:	89 e5                	mov    %esp,%ebp
  800424:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800427:	8d 45 10             	lea    0x10(%ebp),%eax
  80042a:	83 c0 04             	add    $0x4,%eax
  80042d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800430:	a1 18 b1 81 00       	mov    0x81b118,%eax
  800435:	85 c0                	test   %eax,%eax
  800437:	74 16                	je     80044f <_panic+0x2e>
		cprintf("%s: ", argv0);
  800439:	a1 18 b1 81 00       	mov    0x81b118,%eax
  80043e:	83 ec 08             	sub    $0x8,%esp
  800441:	50                   	push   %eax
  800442:	68 e4 21 80 00       	push   $0x8021e4
  800447:	e8 a3 02 00 00       	call   8006ef <cprintf>
  80044c:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  80044f:	a1 04 30 80 00       	mov    0x803004,%eax
  800454:	83 ec 0c             	sub    $0xc,%esp
  800457:	ff 75 0c             	pushl  0xc(%ebp)
  80045a:	ff 75 08             	pushl  0x8(%ebp)
  80045d:	50                   	push   %eax
  80045e:	68 ec 21 80 00       	push   $0x8021ec
  800463:	6a 74                	push   $0x74
  800465:	e8 b2 02 00 00       	call   80071c <cprintf_colored>
  80046a:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  80046d:	8b 45 10             	mov    0x10(%ebp),%eax
  800470:	83 ec 08             	sub    $0x8,%esp
  800473:	ff 75 f4             	pushl  -0xc(%ebp)
  800476:	50                   	push   %eax
  800477:	e8 04 02 00 00       	call   800680 <vcprintf>
  80047c:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80047f:	83 ec 08             	sub    $0x8,%esp
  800482:	6a 00                	push   $0x0
  800484:	68 14 22 80 00       	push   $0x802214
  800489:	e8 f2 01 00 00       	call   800680 <vcprintf>
  80048e:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800491:	e8 7d ff ff ff       	call   800413 <exit>

	// should not return here
	while (1) ;
  800496:	eb fe                	jmp    800496 <_panic+0x75>

00800498 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800498:	55                   	push   %ebp
  800499:	89 e5                	mov    %esp,%ebp
  80049b:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80049e:	a1 20 30 80 00       	mov    0x803020,%eax
  8004a3:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ac:	39 c2                	cmp    %eax,%edx
  8004ae:	74 14                	je     8004c4 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8004b0:	83 ec 04             	sub    $0x4,%esp
  8004b3:	68 18 22 80 00       	push   $0x802218
  8004b8:	6a 26                	push   $0x26
  8004ba:	68 64 22 80 00       	push   $0x802264
  8004bf:	e8 5d ff ff ff       	call   800421 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8004c4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8004cb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004d2:	e9 c5 00 00 00       	jmp    80059c <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8004d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004da:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e4:	01 d0                	add    %edx,%eax
  8004e6:	8b 00                	mov    (%eax),%eax
  8004e8:	85 c0                	test   %eax,%eax
  8004ea:	75 08                	jne    8004f4 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8004ec:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8004ef:	e9 a5 00 00 00       	jmp    800599 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8004f4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004fb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800502:	eb 69                	jmp    80056d <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800504:	a1 20 30 80 00       	mov    0x803020,%eax
  800509:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80050f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800512:	89 d0                	mov    %edx,%eax
  800514:	01 c0                	add    %eax,%eax
  800516:	01 d0                	add    %edx,%eax
  800518:	c1 e0 03             	shl    $0x3,%eax
  80051b:	01 c8                	add    %ecx,%eax
  80051d:	8a 40 04             	mov    0x4(%eax),%al
  800520:	84 c0                	test   %al,%al
  800522:	75 46                	jne    80056a <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800524:	a1 20 30 80 00       	mov    0x803020,%eax
  800529:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80052f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800532:	89 d0                	mov    %edx,%eax
  800534:	01 c0                	add    %eax,%eax
  800536:	01 d0                	add    %edx,%eax
  800538:	c1 e0 03             	shl    $0x3,%eax
  80053b:	01 c8                	add    %ecx,%eax
  80053d:	8b 00                	mov    (%eax),%eax
  80053f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800542:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800545:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80054a:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80054c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80054f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800556:	8b 45 08             	mov    0x8(%ebp),%eax
  800559:	01 c8                	add    %ecx,%eax
  80055b:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80055d:	39 c2                	cmp    %eax,%edx
  80055f:	75 09                	jne    80056a <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800561:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800568:	eb 15                	jmp    80057f <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80056a:	ff 45 e8             	incl   -0x18(%ebp)
  80056d:	a1 20 30 80 00       	mov    0x803020,%eax
  800572:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800578:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80057b:	39 c2                	cmp    %eax,%edx
  80057d:	77 85                	ja     800504 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80057f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800583:	75 14                	jne    800599 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800585:	83 ec 04             	sub    $0x4,%esp
  800588:	68 70 22 80 00       	push   $0x802270
  80058d:	6a 3a                	push   $0x3a
  80058f:	68 64 22 80 00       	push   $0x802264
  800594:	e8 88 fe ff ff       	call   800421 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800599:	ff 45 f0             	incl   -0x10(%ebp)
  80059c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80059f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8005a2:	0f 8c 2f ff ff ff    	jl     8004d7 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8005a8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005af:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8005b6:	eb 26                	jmp    8005de <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8005b8:	a1 20 30 80 00       	mov    0x803020,%eax
  8005bd:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8005c3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005c6:	89 d0                	mov    %edx,%eax
  8005c8:	01 c0                	add    %eax,%eax
  8005ca:	01 d0                	add    %edx,%eax
  8005cc:	c1 e0 03             	shl    $0x3,%eax
  8005cf:	01 c8                	add    %ecx,%eax
  8005d1:	8a 40 04             	mov    0x4(%eax),%al
  8005d4:	3c 01                	cmp    $0x1,%al
  8005d6:	75 03                	jne    8005db <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8005d8:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005db:	ff 45 e0             	incl   -0x20(%ebp)
  8005de:	a1 20 30 80 00       	mov    0x803020,%eax
  8005e3:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005ec:	39 c2                	cmp    %eax,%edx
  8005ee:	77 c8                	ja     8005b8 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8005f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005f3:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8005f6:	74 14                	je     80060c <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8005f8:	83 ec 04             	sub    $0x4,%esp
  8005fb:	68 c4 22 80 00       	push   $0x8022c4
  800600:	6a 44                	push   $0x44
  800602:	68 64 22 80 00       	push   $0x802264
  800607:	e8 15 fe ff ff       	call   800421 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80060c:	90                   	nop
  80060d:	c9                   	leave  
  80060e:	c3                   	ret    

0080060f <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80060f:	55                   	push   %ebp
  800610:	89 e5                	mov    %esp,%ebp
  800612:	53                   	push   %ebx
  800613:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800616:	8b 45 0c             	mov    0xc(%ebp),%eax
  800619:	8b 00                	mov    (%eax),%eax
  80061b:	8d 48 01             	lea    0x1(%eax),%ecx
  80061e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800621:	89 0a                	mov    %ecx,(%edx)
  800623:	8b 55 08             	mov    0x8(%ebp),%edx
  800626:	88 d1                	mov    %dl,%cl
  800628:	8b 55 0c             	mov    0xc(%ebp),%edx
  80062b:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80062f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800632:	8b 00                	mov    (%eax),%eax
  800634:	3d ff 00 00 00       	cmp    $0xff,%eax
  800639:	75 30                	jne    80066b <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  80063b:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  800641:	a0 44 30 80 00       	mov    0x803044,%al
  800646:	0f b6 c0             	movzbl %al,%eax
  800649:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80064c:	8b 09                	mov    (%ecx),%ecx
  80064e:	89 cb                	mov    %ecx,%ebx
  800650:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800653:	83 c1 08             	add    $0x8,%ecx
  800656:	52                   	push   %edx
  800657:	50                   	push   %eax
  800658:	53                   	push   %ebx
  800659:	51                   	push   %ecx
  80065a:	e8 a0 0f 00 00       	call   8015ff <sys_cputs>
  80065f:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800662:	8b 45 0c             	mov    0xc(%ebp),%eax
  800665:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80066b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80066e:	8b 40 04             	mov    0x4(%eax),%eax
  800671:	8d 50 01             	lea    0x1(%eax),%edx
  800674:	8b 45 0c             	mov    0xc(%ebp),%eax
  800677:	89 50 04             	mov    %edx,0x4(%eax)
}
  80067a:	90                   	nop
  80067b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80067e:	c9                   	leave  
  80067f:	c3                   	ret    

00800680 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800680:	55                   	push   %ebp
  800681:	89 e5                	mov    %esp,%ebp
  800683:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800689:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800690:	00 00 00 
	b.cnt = 0;
  800693:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80069a:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80069d:	ff 75 0c             	pushl  0xc(%ebp)
  8006a0:	ff 75 08             	pushl  0x8(%ebp)
  8006a3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006a9:	50                   	push   %eax
  8006aa:	68 0f 06 80 00       	push   $0x80060f
  8006af:	e8 5a 02 00 00       	call   80090e <vprintfmt>
  8006b4:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8006b7:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  8006bd:	a0 44 30 80 00       	mov    0x803044,%al
  8006c2:	0f b6 c0             	movzbl %al,%eax
  8006c5:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8006cb:	52                   	push   %edx
  8006cc:	50                   	push   %eax
  8006cd:	51                   	push   %ecx
  8006ce:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006d4:	83 c0 08             	add    $0x8,%eax
  8006d7:	50                   	push   %eax
  8006d8:	e8 22 0f 00 00       	call   8015ff <sys_cputs>
  8006dd:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8006e0:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  8006e7:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8006ed:	c9                   	leave  
  8006ee:	c3                   	ret    

008006ef <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8006ef:	55                   	push   %ebp
  8006f0:	89 e5                	mov    %esp,%ebp
  8006f2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8006f5:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  8006fc:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800702:	8b 45 08             	mov    0x8(%ebp),%eax
  800705:	83 ec 08             	sub    $0x8,%esp
  800708:	ff 75 f4             	pushl  -0xc(%ebp)
  80070b:	50                   	push   %eax
  80070c:	e8 6f ff ff ff       	call   800680 <vcprintf>
  800711:	83 c4 10             	add    $0x10,%esp
  800714:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800717:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80071a:	c9                   	leave  
  80071b:	c3                   	ret    

0080071c <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  80071c:	55                   	push   %ebp
  80071d:	89 e5                	mov    %esp,%ebp
  80071f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800722:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800729:	8b 45 08             	mov    0x8(%ebp),%eax
  80072c:	c1 e0 08             	shl    $0x8,%eax
  80072f:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  800734:	8d 45 0c             	lea    0xc(%ebp),%eax
  800737:	83 c0 04             	add    $0x4,%eax
  80073a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80073d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800740:	83 ec 08             	sub    $0x8,%esp
  800743:	ff 75 f4             	pushl  -0xc(%ebp)
  800746:	50                   	push   %eax
  800747:	e8 34 ff ff ff       	call   800680 <vcprintf>
  80074c:	83 c4 10             	add    $0x10,%esp
  80074f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800752:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  800759:	07 00 00 

	return cnt;
  80075c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80075f:	c9                   	leave  
  800760:	c3                   	ret    

00800761 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800761:	55                   	push   %ebp
  800762:	89 e5                	mov    %esp,%ebp
  800764:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800767:	e8 d7 0e 00 00       	call   801643 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80076c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80076f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800772:	8b 45 08             	mov    0x8(%ebp),%eax
  800775:	83 ec 08             	sub    $0x8,%esp
  800778:	ff 75 f4             	pushl  -0xc(%ebp)
  80077b:	50                   	push   %eax
  80077c:	e8 ff fe ff ff       	call   800680 <vcprintf>
  800781:	83 c4 10             	add    $0x10,%esp
  800784:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800787:	e8 d1 0e 00 00       	call   80165d <sys_unlock_cons>
	return cnt;
  80078c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80078f:	c9                   	leave  
  800790:	c3                   	ret    

00800791 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800791:	55                   	push   %ebp
  800792:	89 e5                	mov    %esp,%ebp
  800794:	53                   	push   %ebx
  800795:	83 ec 14             	sub    $0x14,%esp
  800798:	8b 45 10             	mov    0x10(%ebp),%eax
  80079b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80079e:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007a4:	8b 45 18             	mov    0x18(%ebp),%eax
  8007a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8007ac:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007af:	77 55                	ja     800806 <printnum+0x75>
  8007b1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007b4:	72 05                	jb     8007bb <printnum+0x2a>
  8007b6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8007b9:	77 4b                	ja     800806 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007bb:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8007be:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8007c1:	8b 45 18             	mov    0x18(%ebp),%eax
  8007c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8007c9:	52                   	push   %edx
  8007ca:	50                   	push   %eax
  8007cb:	ff 75 f4             	pushl  -0xc(%ebp)
  8007ce:	ff 75 f0             	pushl  -0x10(%ebp)
  8007d1:	e8 aa 13 00 00       	call   801b80 <__udivdi3>
  8007d6:	83 c4 10             	add    $0x10,%esp
  8007d9:	83 ec 04             	sub    $0x4,%esp
  8007dc:	ff 75 20             	pushl  0x20(%ebp)
  8007df:	53                   	push   %ebx
  8007e0:	ff 75 18             	pushl  0x18(%ebp)
  8007e3:	52                   	push   %edx
  8007e4:	50                   	push   %eax
  8007e5:	ff 75 0c             	pushl  0xc(%ebp)
  8007e8:	ff 75 08             	pushl  0x8(%ebp)
  8007eb:	e8 a1 ff ff ff       	call   800791 <printnum>
  8007f0:	83 c4 20             	add    $0x20,%esp
  8007f3:	eb 1a                	jmp    80080f <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8007f5:	83 ec 08             	sub    $0x8,%esp
  8007f8:	ff 75 0c             	pushl  0xc(%ebp)
  8007fb:	ff 75 20             	pushl  0x20(%ebp)
  8007fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800801:	ff d0                	call   *%eax
  800803:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800806:	ff 4d 1c             	decl   0x1c(%ebp)
  800809:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80080d:	7f e6                	jg     8007f5 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80080f:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800812:	bb 00 00 00 00       	mov    $0x0,%ebx
  800817:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80081a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80081d:	53                   	push   %ebx
  80081e:	51                   	push   %ecx
  80081f:	52                   	push   %edx
  800820:	50                   	push   %eax
  800821:	e8 6a 14 00 00       	call   801c90 <__umoddi3>
  800826:	83 c4 10             	add    $0x10,%esp
  800829:	05 34 25 80 00       	add    $0x802534,%eax
  80082e:	8a 00                	mov    (%eax),%al
  800830:	0f be c0             	movsbl %al,%eax
  800833:	83 ec 08             	sub    $0x8,%esp
  800836:	ff 75 0c             	pushl  0xc(%ebp)
  800839:	50                   	push   %eax
  80083a:	8b 45 08             	mov    0x8(%ebp),%eax
  80083d:	ff d0                	call   *%eax
  80083f:	83 c4 10             	add    $0x10,%esp
}
  800842:	90                   	nop
  800843:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800846:	c9                   	leave  
  800847:	c3                   	ret    

00800848 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800848:	55                   	push   %ebp
  800849:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80084b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80084f:	7e 1c                	jle    80086d <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800851:	8b 45 08             	mov    0x8(%ebp),%eax
  800854:	8b 00                	mov    (%eax),%eax
  800856:	8d 50 08             	lea    0x8(%eax),%edx
  800859:	8b 45 08             	mov    0x8(%ebp),%eax
  80085c:	89 10                	mov    %edx,(%eax)
  80085e:	8b 45 08             	mov    0x8(%ebp),%eax
  800861:	8b 00                	mov    (%eax),%eax
  800863:	83 e8 08             	sub    $0x8,%eax
  800866:	8b 50 04             	mov    0x4(%eax),%edx
  800869:	8b 00                	mov    (%eax),%eax
  80086b:	eb 40                	jmp    8008ad <getuint+0x65>
	else if (lflag)
  80086d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800871:	74 1e                	je     800891 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800873:	8b 45 08             	mov    0x8(%ebp),%eax
  800876:	8b 00                	mov    (%eax),%eax
  800878:	8d 50 04             	lea    0x4(%eax),%edx
  80087b:	8b 45 08             	mov    0x8(%ebp),%eax
  80087e:	89 10                	mov    %edx,(%eax)
  800880:	8b 45 08             	mov    0x8(%ebp),%eax
  800883:	8b 00                	mov    (%eax),%eax
  800885:	83 e8 04             	sub    $0x4,%eax
  800888:	8b 00                	mov    (%eax),%eax
  80088a:	ba 00 00 00 00       	mov    $0x0,%edx
  80088f:	eb 1c                	jmp    8008ad <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800891:	8b 45 08             	mov    0x8(%ebp),%eax
  800894:	8b 00                	mov    (%eax),%eax
  800896:	8d 50 04             	lea    0x4(%eax),%edx
  800899:	8b 45 08             	mov    0x8(%ebp),%eax
  80089c:	89 10                	mov    %edx,(%eax)
  80089e:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a1:	8b 00                	mov    (%eax),%eax
  8008a3:	83 e8 04             	sub    $0x4,%eax
  8008a6:	8b 00                	mov    (%eax),%eax
  8008a8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8008ad:	5d                   	pop    %ebp
  8008ae:	c3                   	ret    

008008af <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008af:	55                   	push   %ebp
  8008b0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008b2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008b6:	7e 1c                	jle    8008d4 <getint+0x25>
		return va_arg(*ap, long long);
  8008b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bb:	8b 00                	mov    (%eax),%eax
  8008bd:	8d 50 08             	lea    0x8(%eax),%edx
  8008c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c3:	89 10                	mov    %edx,(%eax)
  8008c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c8:	8b 00                	mov    (%eax),%eax
  8008ca:	83 e8 08             	sub    $0x8,%eax
  8008cd:	8b 50 04             	mov    0x4(%eax),%edx
  8008d0:	8b 00                	mov    (%eax),%eax
  8008d2:	eb 38                	jmp    80090c <getint+0x5d>
	else if (lflag)
  8008d4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008d8:	74 1a                	je     8008f4 <getint+0x45>
		return va_arg(*ap, long);
  8008da:	8b 45 08             	mov    0x8(%ebp),%eax
  8008dd:	8b 00                	mov    (%eax),%eax
  8008df:	8d 50 04             	lea    0x4(%eax),%edx
  8008e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e5:	89 10                	mov    %edx,(%eax)
  8008e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ea:	8b 00                	mov    (%eax),%eax
  8008ec:	83 e8 04             	sub    $0x4,%eax
  8008ef:	8b 00                	mov    (%eax),%eax
  8008f1:	99                   	cltd   
  8008f2:	eb 18                	jmp    80090c <getint+0x5d>
	else
		return va_arg(*ap, int);
  8008f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f7:	8b 00                	mov    (%eax),%eax
  8008f9:	8d 50 04             	lea    0x4(%eax),%edx
  8008fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ff:	89 10                	mov    %edx,(%eax)
  800901:	8b 45 08             	mov    0x8(%ebp),%eax
  800904:	8b 00                	mov    (%eax),%eax
  800906:	83 e8 04             	sub    $0x4,%eax
  800909:	8b 00                	mov    (%eax),%eax
  80090b:	99                   	cltd   
}
  80090c:	5d                   	pop    %ebp
  80090d:	c3                   	ret    

0080090e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80090e:	55                   	push   %ebp
  80090f:	89 e5                	mov    %esp,%ebp
  800911:	56                   	push   %esi
  800912:	53                   	push   %ebx
  800913:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800916:	eb 17                	jmp    80092f <vprintfmt+0x21>
			if (ch == '\0')
  800918:	85 db                	test   %ebx,%ebx
  80091a:	0f 84 c1 03 00 00    	je     800ce1 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800920:	83 ec 08             	sub    $0x8,%esp
  800923:	ff 75 0c             	pushl  0xc(%ebp)
  800926:	53                   	push   %ebx
  800927:	8b 45 08             	mov    0x8(%ebp),%eax
  80092a:	ff d0                	call   *%eax
  80092c:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80092f:	8b 45 10             	mov    0x10(%ebp),%eax
  800932:	8d 50 01             	lea    0x1(%eax),%edx
  800935:	89 55 10             	mov    %edx,0x10(%ebp)
  800938:	8a 00                	mov    (%eax),%al
  80093a:	0f b6 d8             	movzbl %al,%ebx
  80093d:	83 fb 25             	cmp    $0x25,%ebx
  800940:	75 d6                	jne    800918 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800942:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800946:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80094d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800954:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80095b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800962:	8b 45 10             	mov    0x10(%ebp),%eax
  800965:	8d 50 01             	lea    0x1(%eax),%edx
  800968:	89 55 10             	mov    %edx,0x10(%ebp)
  80096b:	8a 00                	mov    (%eax),%al
  80096d:	0f b6 d8             	movzbl %al,%ebx
  800970:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800973:	83 f8 5b             	cmp    $0x5b,%eax
  800976:	0f 87 3d 03 00 00    	ja     800cb9 <vprintfmt+0x3ab>
  80097c:	8b 04 85 58 25 80 00 	mov    0x802558(,%eax,4),%eax
  800983:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800985:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800989:	eb d7                	jmp    800962 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80098b:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80098f:	eb d1                	jmp    800962 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800991:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800998:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80099b:	89 d0                	mov    %edx,%eax
  80099d:	c1 e0 02             	shl    $0x2,%eax
  8009a0:	01 d0                	add    %edx,%eax
  8009a2:	01 c0                	add    %eax,%eax
  8009a4:	01 d8                	add    %ebx,%eax
  8009a6:	83 e8 30             	sub    $0x30,%eax
  8009a9:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8009ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8009af:	8a 00                	mov    (%eax),%al
  8009b1:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009b4:	83 fb 2f             	cmp    $0x2f,%ebx
  8009b7:	7e 3e                	jle    8009f7 <vprintfmt+0xe9>
  8009b9:	83 fb 39             	cmp    $0x39,%ebx
  8009bc:	7f 39                	jg     8009f7 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009be:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009c1:	eb d5                	jmp    800998 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8009c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c6:	83 c0 04             	add    $0x4,%eax
  8009c9:	89 45 14             	mov    %eax,0x14(%ebp)
  8009cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8009cf:	83 e8 04             	sub    $0x4,%eax
  8009d2:	8b 00                	mov    (%eax),%eax
  8009d4:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8009d7:	eb 1f                	jmp    8009f8 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8009d9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009dd:	79 83                	jns    800962 <vprintfmt+0x54>
				width = 0;
  8009df:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8009e6:	e9 77 ff ff ff       	jmp    800962 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8009eb:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8009f2:	e9 6b ff ff ff       	jmp    800962 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8009f7:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8009f8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009fc:	0f 89 60 ff ff ff    	jns    800962 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a02:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a05:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a08:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a0f:	e9 4e ff ff ff       	jmp    800962 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a14:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a17:	e9 46 ff ff ff       	jmp    800962 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a1c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1f:	83 c0 04             	add    $0x4,%eax
  800a22:	89 45 14             	mov    %eax,0x14(%ebp)
  800a25:	8b 45 14             	mov    0x14(%ebp),%eax
  800a28:	83 e8 04             	sub    $0x4,%eax
  800a2b:	8b 00                	mov    (%eax),%eax
  800a2d:	83 ec 08             	sub    $0x8,%esp
  800a30:	ff 75 0c             	pushl  0xc(%ebp)
  800a33:	50                   	push   %eax
  800a34:	8b 45 08             	mov    0x8(%ebp),%eax
  800a37:	ff d0                	call   *%eax
  800a39:	83 c4 10             	add    $0x10,%esp
			break;
  800a3c:	e9 9b 02 00 00       	jmp    800cdc <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a41:	8b 45 14             	mov    0x14(%ebp),%eax
  800a44:	83 c0 04             	add    $0x4,%eax
  800a47:	89 45 14             	mov    %eax,0x14(%ebp)
  800a4a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a4d:	83 e8 04             	sub    $0x4,%eax
  800a50:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a52:	85 db                	test   %ebx,%ebx
  800a54:	79 02                	jns    800a58 <vprintfmt+0x14a>
				err = -err;
  800a56:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a58:	83 fb 64             	cmp    $0x64,%ebx
  800a5b:	7f 0b                	jg     800a68 <vprintfmt+0x15a>
  800a5d:	8b 34 9d a0 23 80 00 	mov    0x8023a0(,%ebx,4),%esi
  800a64:	85 f6                	test   %esi,%esi
  800a66:	75 19                	jne    800a81 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a68:	53                   	push   %ebx
  800a69:	68 45 25 80 00       	push   $0x802545
  800a6e:	ff 75 0c             	pushl  0xc(%ebp)
  800a71:	ff 75 08             	pushl  0x8(%ebp)
  800a74:	e8 70 02 00 00       	call   800ce9 <printfmt>
  800a79:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a7c:	e9 5b 02 00 00       	jmp    800cdc <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a81:	56                   	push   %esi
  800a82:	68 4e 25 80 00       	push   $0x80254e
  800a87:	ff 75 0c             	pushl  0xc(%ebp)
  800a8a:	ff 75 08             	pushl  0x8(%ebp)
  800a8d:	e8 57 02 00 00       	call   800ce9 <printfmt>
  800a92:	83 c4 10             	add    $0x10,%esp
			break;
  800a95:	e9 42 02 00 00       	jmp    800cdc <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a9a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9d:	83 c0 04             	add    $0x4,%eax
  800aa0:	89 45 14             	mov    %eax,0x14(%ebp)
  800aa3:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa6:	83 e8 04             	sub    $0x4,%eax
  800aa9:	8b 30                	mov    (%eax),%esi
  800aab:	85 f6                	test   %esi,%esi
  800aad:	75 05                	jne    800ab4 <vprintfmt+0x1a6>
				p = "(null)";
  800aaf:	be 51 25 80 00       	mov    $0x802551,%esi
			if (width > 0 && padc != '-')
  800ab4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ab8:	7e 6d                	jle    800b27 <vprintfmt+0x219>
  800aba:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800abe:	74 67                	je     800b27 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ac0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ac3:	83 ec 08             	sub    $0x8,%esp
  800ac6:	50                   	push   %eax
  800ac7:	56                   	push   %esi
  800ac8:	e8 1e 03 00 00       	call   800deb <strnlen>
  800acd:	83 c4 10             	add    $0x10,%esp
  800ad0:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800ad3:	eb 16                	jmp    800aeb <vprintfmt+0x1dd>
					putch(padc, putdat);
  800ad5:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800ad9:	83 ec 08             	sub    $0x8,%esp
  800adc:	ff 75 0c             	pushl  0xc(%ebp)
  800adf:	50                   	push   %eax
  800ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae3:	ff d0                	call   *%eax
  800ae5:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800ae8:	ff 4d e4             	decl   -0x1c(%ebp)
  800aeb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800aef:	7f e4                	jg     800ad5 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800af1:	eb 34                	jmp    800b27 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800af3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800af7:	74 1c                	je     800b15 <vprintfmt+0x207>
  800af9:	83 fb 1f             	cmp    $0x1f,%ebx
  800afc:	7e 05                	jle    800b03 <vprintfmt+0x1f5>
  800afe:	83 fb 7e             	cmp    $0x7e,%ebx
  800b01:	7e 12                	jle    800b15 <vprintfmt+0x207>
					putch('?', putdat);
  800b03:	83 ec 08             	sub    $0x8,%esp
  800b06:	ff 75 0c             	pushl  0xc(%ebp)
  800b09:	6a 3f                	push   $0x3f
  800b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0e:	ff d0                	call   *%eax
  800b10:	83 c4 10             	add    $0x10,%esp
  800b13:	eb 0f                	jmp    800b24 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b15:	83 ec 08             	sub    $0x8,%esp
  800b18:	ff 75 0c             	pushl  0xc(%ebp)
  800b1b:	53                   	push   %ebx
  800b1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1f:	ff d0                	call   *%eax
  800b21:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b24:	ff 4d e4             	decl   -0x1c(%ebp)
  800b27:	89 f0                	mov    %esi,%eax
  800b29:	8d 70 01             	lea    0x1(%eax),%esi
  800b2c:	8a 00                	mov    (%eax),%al
  800b2e:	0f be d8             	movsbl %al,%ebx
  800b31:	85 db                	test   %ebx,%ebx
  800b33:	74 24                	je     800b59 <vprintfmt+0x24b>
  800b35:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b39:	78 b8                	js     800af3 <vprintfmt+0x1e5>
  800b3b:	ff 4d e0             	decl   -0x20(%ebp)
  800b3e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b42:	79 af                	jns    800af3 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b44:	eb 13                	jmp    800b59 <vprintfmt+0x24b>
				putch(' ', putdat);
  800b46:	83 ec 08             	sub    $0x8,%esp
  800b49:	ff 75 0c             	pushl  0xc(%ebp)
  800b4c:	6a 20                	push   $0x20
  800b4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b51:	ff d0                	call   *%eax
  800b53:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b56:	ff 4d e4             	decl   -0x1c(%ebp)
  800b59:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b5d:	7f e7                	jg     800b46 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b5f:	e9 78 01 00 00       	jmp    800cdc <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b64:	83 ec 08             	sub    $0x8,%esp
  800b67:	ff 75 e8             	pushl  -0x18(%ebp)
  800b6a:	8d 45 14             	lea    0x14(%ebp),%eax
  800b6d:	50                   	push   %eax
  800b6e:	e8 3c fd ff ff       	call   8008af <getint>
  800b73:	83 c4 10             	add    $0x10,%esp
  800b76:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b79:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800b7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b7f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b82:	85 d2                	test   %edx,%edx
  800b84:	79 23                	jns    800ba9 <vprintfmt+0x29b>
				putch('-', putdat);
  800b86:	83 ec 08             	sub    $0x8,%esp
  800b89:	ff 75 0c             	pushl  0xc(%ebp)
  800b8c:	6a 2d                	push   $0x2d
  800b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b91:	ff d0                	call   *%eax
  800b93:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800b96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b99:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b9c:	f7 d8                	neg    %eax
  800b9e:	83 d2 00             	adc    $0x0,%edx
  800ba1:	f7 da                	neg    %edx
  800ba3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ba6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800ba9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bb0:	e9 bc 00 00 00       	jmp    800c71 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800bb5:	83 ec 08             	sub    $0x8,%esp
  800bb8:	ff 75 e8             	pushl  -0x18(%ebp)
  800bbb:	8d 45 14             	lea    0x14(%ebp),%eax
  800bbe:	50                   	push   %eax
  800bbf:	e8 84 fc ff ff       	call   800848 <getuint>
  800bc4:	83 c4 10             	add    $0x10,%esp
  800bc7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bca:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800bcd:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bd4:	e9 98 00 00 00       	jmp    800c71 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800bd9:	83 ec 08             	sub    $0x8,%esp
  800bdc:	ff 75 0c             	pushl  0xc(%ebp)
  800bdf:	6a 58                	push   $0x58
  800be1:	8b 45 08             	mov    0x8(%ebp),%eax
  800be4:	ff d0                	call   *%eax
  800be6:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800be9:	83 ec 08             	sub    $0x8,%esp
  800bec:	ff 75 0c             	pushl  0xc(%ebp)
  800bef:	6a 58                	push   $0x58
  800bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf4:	ff d0                	call   *%eax
  800bf6:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800bf9:	83 ec 08             	sub    $0x8,%esp
  800bfc:	ff 75 0c             	pushl  0xc(%ebp)
  800bff:	6a 58                	push   $0x58
  800c01:	8b 45 08             	mov    0x8(%ebp),%eax
  800c04:	ff d0                	call   *%eax
  800c06:	83 c4 10             	add    $0x10,%esp
			break;
  800c09:	e9 ce 00 00 00       	jmp    800cdc <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800c0e:	83 ec 08             	sub    $0x8,%esp
  800c11:	ff 75 0c             	pushl  0xc(%ebp)
  800c14:	6a 30                	push   $0x30
  800c16:	8b 45 08             	mov    0x8(%ebp),%eax
  800c19:	ff d0                	call   *%eax
  800c1b:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c1e:	83 ec 08             	sub    $0x8,%esp
  800c21:	ff 75 0c             	pushl  0xc(%ebp)
  800c24:	6a 78                	push   $0x78
  800c26:	8b 45 08             	mov    0x8(%ebp),%eax
  800c29:	ff d0                	call   *%eax
  800c2b:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c2e:	8b 45 14             	mov    0x14(%ebp),%eax
  800c31:	83 c0 04             	add    $0x4,%eax
  800c34:	89 45 14             	mov    %eax,0x14(%ebp)
  800c37:	8b 45 14             	mov    0x14(%ebp),%eax
  800c3a:	83 e8 04             	sub    $0x4,%eax
  800c3d:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c42:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c49:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c50:	eb 1f                	jmp    800c71 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c52:	83 ec 08             	sub    $0x8,%esp
  800c55:	ff 75 e8             	pushl  -0x18(%ebp)
  800c58:	8d 45 14             	lea    0x14(%ebp),%eax
  800c5b:	50                   	push   %eax
  800c5c:	e8 e7 fb ff ff       	call   800848 <getuint>
  800c61:	83 c4 10             	add    $0x10,%esp
  800c64:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c67:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800c6a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c71:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800c75:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c78:	83 ec 04             	sub    $0x4,%esp
  800c7b:	52                   	push   %edx
  800c7c:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c7f:	50                   	push   %eax
  800c80:	ff 75 f4             	pushl  -0xc(%ebp)
  800c83:	ff 75 f0             	pushl  -0x10(%ebp)
  800c86:	ff 75 0c             	pushl  0xc(%ebp)
  800c89:	ff 75 08             	pushl  0x8(%ebp)
  800c8c:	e8 00 fb ff ff       	call   800791 <printnum>
  800c91:	83 c4 20             	add    $0x20,%esp
			break;
  800c94:	eb 46                	jmp    800cdc <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c96:	83 ec 08             	sub    $0x8,%esp
  800c99:	ff 75 0c             	pushl  0xc(%ebp)
  800c9c:	53                   	push   %ebx
  800c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca0:	ff d0                	call   *%eax
  800ca2:	83 c4 10             	add    $0x10,%esp
			break;
  800ca5:	eb 35                	jmp    800cdc <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800ca7:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800cae:	eb 2c                	jmp    800cdc <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800cb0:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800cb7:	eb 23                	jmp    800cdc <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cb9:	83 ec 08             	sub    $0x8,%esp
  800cbc:	ff 75 0c             	pushl  0xc(%ebp)
  800cbf:	6a 25                	push   $0x25
  800cc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc4:	ff d0                	call   *%eax
  800cc6:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800cc9:	ff 4d 10             	decl   0x10(%ebp)
  800ccc:	eb 03                	jmp    800cd1 <vprintfmt+0x3c3>
  800cce:	ff 4d 10             	decl   0x10(%ebp)
  800cd1:	8b 45 10             	mov    0x10(%ebp),%eax
  800cd4:	48                   	dec    %eax
  800cd5:	8a 00                	mov    (%eax),%al
  800cd7:	3c 25                	cmp    $0x25,%al
  800cd9:	75 f3                	jne    800cce <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800cdb:	90                   	nop
		}
	}
  800cdc:	e9 35 fc ff ff       	jmp    800916 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ce1:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ce2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ce5:	5b                   	pop    %ebx
  800ce6:	5e                   	pop    %esi
  800ce7:	5d                   	pop    %ebp
  800ce8:	c3                   	ret    

00800ce9 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ce9:	55                   	push   %ebp
  800cea:	89 e5                	mov    %esp,%ebp
  800cec:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800cef:	8d 45 10             	lea    0x10(%ebp),%eax
  800cf2:	83 c0 04             	add    $0x4,%eax
  800cf5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800cf8:	8b 45 10             	mov    0x10(%ebp),%eax
  800cfb:	ff 75 f4             	pushl  -0xc(%ebp)
  800cfe:	50                   	push   %eax
  800cff:	ff 75 0c             	pushl  0xc(%ebp)
  800d02:	ff 75 08             	pushl  0x8(%ebp)
  800d05:	e8 04 fc ff ff       	call   80090e <vprintfmt>
  800d0a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d0d:	90                   	nop
  800d0e:	c9                   	leave  
  800d0f:	c3                   	ret    

00800d10 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d10:	55                   	push   %ebp
  800d11:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d16:	8b 40 08             	mov    0x8(%eax),%eax
  800d19:	8d 50 01             	lea    0x1(%eax),%edx
  800d1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d25:	8b 10                	mov    (%eax),%edx
  800d27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2a:	8b 40 04             	mov    0x4(%eax),%eax
  800d2d:	39 c2                	cmp    %eax,%edx
  800d2f:	73 12                	jae    800d43 <sprintputch+0x33>
		*b->buf++ = ch;
  800d31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d34:	8b 00                	mov    (%eax),%eax
  800d36:	8d 48 01             	lea    0x1(%eax),%ecx
  800d39:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d3c:	89 0a                	mov    %ecx,(%edx)
  800d3e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d41:	88 10                	mov    %dl,(%eax)
}
  800d43:	90                   	nop
  800d44:	5d                   	pop    %ebp
  800d45:	c3                   	ret    

00800d46 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d46:	55                   	push   %ebp
  800d47:	89 e5                	mov    %esp,%ebp
  800d49:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d55:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d58:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5b:	01 d0                	add    %edx,%eax
  800d5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d60:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d67:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d6b:	74 06                	je     800d73 <vsnprintf+0x2d>
  800d6d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d71:	7f 07                	jg     800d7a <vsnprintf+0x34>
		return -E_INVAL;
  800d73:	b8 03 00 00 00       	mov    $0x3,%eax
  800d78:	eb 20                	jmp    800d9a <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d7a:	ff 75 14             	pushl  0x14(%ebp)
  800d7d:	ff 75 10             	pushl  0x10(%ebp)
  800d80:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d83:	50                   	push   %eax
  800d84:	68 10 0d 80 00       	push   $0x800d10
  800d89:	e8 80 fb ff ff       	call   80090e <vprintfmt>
  800d8e:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800d91:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d94:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d97:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800d9a:	c9                   	leave  
  800d9b:	c3                   	ret    

00800d9c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d9c:	55                   	push   %ebp
  800d9d:	89 e5                	mov    %esp,%ebp
  800d9f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800da2:	8d 45 10             	lea    0x10(%ebp),%eax
  800da5:	83 c0 04             	add    $0x4,%eax
  800da8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800dab:	8b 45 10             	mov    0x10(%ebp),%eax
  800dae:	ff 75 f4             	pushl  -0xc(%ebp)
  800db1:	50                   	push   %eax
  800db2:	ff 75 0c             	pushl  0xc(%ebp)
  800db5:	ff 75 08             	pushl  0x8(%ebp)
  800db8:	e8 89 ff ff ff       	call   800d46 <vsnprintf>
  800dbd:	83 c4 10             	add    $0x10,%esp
  800dc0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800dc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800dc6:	c9                   	leave  
  800dc7:	c3                   	ret    

00800dc8 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800dc8:	55                   	push   %ebp
  800dc9:	89 e5                	mov    %esp,%ebp
  800dcb:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800dce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dd5:	eb 06                	jmp    800ddd <strlen+0x15>
		n++;
  800dd7:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800dda:	ff 45 08             	incl   0x8(%ebp)
  800ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  800de0:	8a 00                	mov    (%eax),%al
  800de2:	84 c0                	test   %al,%al
  800de4:	75 f1                	jne    800dd7 <strlen+0xf>
		n++;
	return n;
  800de6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800de9:	c9                   	leave  
  800dea:	c3                   	ret    

00800deb <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800deb:	55                   	push   %ebp
  800dec:	89 e5                	mov    %esp,%ebp
  800dee:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800df1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800df8:	eb 09                	jmp    800e03 <strnlen+0x18>
		n++;
  800dfa:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800dfd:	ff 45 08             	incl   0x8(%ebp)
  800e00:	ff 4d 0c             	decl   0xc(%ebp)
  800e03:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e07:	74 09                	je     800e12 <strnlen+0x27>
  800e09:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0c:	8a 00                	mov    (%eax),%al
  800e0e:	84 c0                	test   %al,%al
  800e10:	75 e8                	jne    800dfa <strnlen+0xf>
		n++;
	return n;
  800e12:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e15:	c9                   	leave  
  800e16:	c3                   	ret    

00800e17 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e17:	55                   	push   %ebp
  800e18:	89 e5                	mov    %esp,%ebp
  800e1a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e20:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e23:	90                   	nop
  800e24:	8b 45 08             	mov    0x8(%ebp),%eax
  800e27:	8d 50 01             	lea    0x1(%eax),%edx
  800e2a:	89 55 08             	mov    %edx,0x8(%ebp)
  800e2d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e30:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e33:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e36:	8a 12                	mov    (%edx),%dl
  800e38:	88 10                	mov    %dl,(%eax)
  800e3a:	8a 00                	mov    (%eax),%al
  800e3c:	84 c0                	test   %al,%al
  800e3e:	75 e4                	jne    800e24 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e40:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e43:	c9                   	leave  
  800e44:	c3                   	ret    

00800e45 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e45:	55                   	push   %ebp
  800e46:	89 e5                	mov    %esp,%ebp
  800e48:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e51:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e58:	eb 1f                	jmp    800e79 <strncpy+0x34>
		*dst++ = *src;
  800e5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5d:	8d 50 01             	lea    0x1(%eax),%edx
  800e60:	89 55 08             	mov    %edx,0x8(%ebp)
  800e63:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e66:	8a 12                	mov    (%edx),%dl
  800e68:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6d:	8a 00                	mov    (%eax),%al
  800e6f:	84 c0                	test   %al,%al
  800e71:	74 03                	je     800e76 <strncpy+0x31>
			src++;
  800e73:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e76:	ff 45 fc             	incl   -0x4(%ebp)
  800e79:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e7c:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e7f:	72 d9                	jb     800e5a <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800e81:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e84:	c9                   	leave  
  800e85:	c3                   	ret    

00800e86 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800e86:	55                   	push   %ebp
  800e87:	89 e5                	mov    %esp,%ebp
  800e89:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800e8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800e92:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e96:	74 30                	je     800ec8 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800e98:	eb 16                	jmp    800eb0 <strlcpy+0x2a>
			*dst++ = *src++;
  800e9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9d:	8d 50 01             	lea    0x1(%eax),%edx
  800ea0:	89 55 08             	mov    %edx,0x8(%ebp)
  800ea3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ea6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ea9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800eac:	8a 12                	mov    (%edx),%dl
  800eae:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800eb0:	ff 4d 10             	decl   0x10(%ebp)
  800eb3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eb7:	74 09                	je     800ec2 <strlcpy+0x3c>
  800eb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ebc:	8a 00                	mov    (%eax),%al
  800ebe:	84 c0                	test   %al,%al
  800ec0:	75 d8                	jne    800e9a <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec5:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ec8:	8b 55 08             	mov    0x8(%ebp),%edx
  800ecb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ece:	29 c2                	sub    %eax,%edx
  800ed0:	89 d0                	mov    %edx,%eax
}
  800ed2:	c9                   	leave  
  800ed3:	c3                   	ret    

00800ed4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ed4:	55                   	push   %ebp
  800ed5:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ed7:	eb 06                	jmp    800edf <strcmp+0xb>
		p++, q++;
  800ed9:	ff 45 08             	incl   0x8(%ebp)
  800edc:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800edf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee2:	8a 00                	mov    (%eax),%al
  800ee4:	84 c0                	test   %al,%al
  800ee6:	74 0e                	je     800ef6 <strcmp+0x22>
  800ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  800eeb:	8a 10                	mov    (%eax),%dl
  800eed:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef0:	8a 00                	mov    (%eax),%al
  800ef2:	38 c2                	cmp    %al,%dl
  800ef4:	74 e3                	je     800ed9 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ef6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef9:	8a 00                	mov    (%eax),%al
  800efb:	0f b6 d0             	movzbl %al,%edx
  800efe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f01:	8a 00                	mov    (%eax),%al
  800f03:	0f b6 c0             	movzbl %al,%eax
  800f06:	29 c2                	sub    %eax,%edx
  800f08:	89 d0                	mov    %edx,%eax
}
  800f0a:	5d                   	pop    %ebp
  800f0b:	c3                   	ret    

00800f0c <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f0c:	55                   	push   %ebp
  800f0d:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f0f:	eb 09                	jmp    800f1a <strncmp+0xe>
		n--, p++, q++;
  800f11:	ff 4d 10             	decl   0x10(%ebp)
  800f14:	ff 45 08             	incl   0x8(%ebp)
  800f17:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f1a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f1e:	74 17                	je     800f37 <strncmp+0x2b>
  800f20:	8b 45 08             	mov    0x8(%ebp),%eax
  800f23:	8a 00                	mov    (%eax),%al
  800f25:	84 c0                	test   %al,%al
  800f27:	74 0e                	je     800f37 <strncmp+0x2b>
  800f29:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2c:	8a 10                	mov    (%eax),%dl
  800f2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f31:	8a 00                	mov    (%eax),%al
  800f33:	38 c2                	cmp    %al,%dl
  800f35:	74 da                	je     800f11 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f37:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f3b:	75 07                	jne    800f44 <strncmp+0x38>
		return 0;
  800f3d:	b8 00 00 00 00       	mov    $0x0,%eax
  800f42:	eb 14                	jmp    800f58 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f44:	8b 45 08             	mov    0x8(%ebp),%eax
  800f47:	8a 00                	mov    (%eax),%al
  800f49:	0f b6 d0             	movzbl %al,%edx
  800f4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4f:	8a 00                	mov    (%eax),%al
  800f51:	0f b6 c0             	movzbl %al,%eax
  800f54:	29 c2                	sub    %eax,%edx
  800f56:	89 d0                	mov    %edx,%eax
}
  800f58:	5d                   	pop    %ebp
  800f59:	c3                   	ret    

00800f5a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f5a:	55                   	push   %ebp
  800f5b:	89 e5                	mov    %esp,%ebp
  800f5d:	83 ec 04             	sub    $0x4,%esp
  800f60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f63:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f66:	eb 12                	jmp    800f7a <strchr+0x20>
		if (*s == c)
  800f68:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6b:	8a 00                	mov    (%eax),%al
  800f6d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f70:	75 05                	jne    800f77 <strchr+0x1d>
			return (char *) s;
  800f72:	8b 45 08             	mov    0x8(%ebp),%eax
  800f75:	eb 11                	jmp    800f88 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800f77:	ff 45 08             	incl   0x8(%ebp)
  800f7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7d:	8a 00                	mov    (%eax),%al
  800f7f:	84 c0                	test   %al,%al
  800f81:	75 e5                	jne    800f68 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800f83:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f88:	c9                   	leave  
  800f89:	c3                   	ret    

00800f8a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f8a:	55                   	push   %ebp
  800f8b:	89 e5                	mov    %esp,%ebp
  800f8d:	83 ec 04             	sub    $0x4,%esp
  800f90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f93:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f96:	eb 0d                	jmp    800fa5 <strfind+0x1b>
		if (*s == c)
  800f98:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9b:	8a 00                	mov    (%eax),%al
  800f9d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fa0:	74 0e                	je     800fb0 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800fa2:	ff 45 08             	incl   0x8(%ebp)
  800fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa8:	8a 00                	mov    (%eax),%al
  800faa:	84 c0                	test   %al,%al
  800fac:	75 ea                	jne    800f98 <strfind+0xe>
  800fae:	eb 01                	jmp    800fb1 <strfind+0x27>
		if (*s == c)
			break;
  800fb0:	90                   	nop
	return (char *) s;
  800fb1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fb4:	c9                   	leave  
  800fb5:	c3                   	ret    

00800fb6 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800fb6:	55                   	push   %ebp
  800fb7:	89 e5                	mov    %esp,%ebp
  800fb9:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800fc2:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800fc6:	76 63                	jbe    80102b <memset+0x75>
		uint64 data_block = c;
  800fc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fcb:	99                   	cltd   
  800fcc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fcf:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800fd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fd5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fd8:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800fdc:	c1 e0 08             	shl    $0x8,%eax
  800fdf:	09 45 f0             	or     %eax,-0x10(%ebp)
  800fe2:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800fe5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fe8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800feb:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800fef:	c1 e0 10             	shl    $0x10,%eax
  800ff2:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ff5:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800ff8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ffb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ffe:	89 c2                	mov    %eax,%edx
  801000:	b8 00 00 00 00       	mov    $0x0,%eax
  801005:	09 45 f0             	or     %eax,-0x10(%ebp)
  801008:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  80100b:	eb 18                	jmp    801025 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  80100d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801010:	8d 41 08             	lea    0x8(%ecx),%eax
  801013:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801016:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801019:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80101c:	89 01                	mov    %eax,(%ecx)
  80101e:	89 51 04             	mov    %edx,0x4(%ecx)
  801021:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801025:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801029:	77 e2                	ja     80100d <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  80102b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80102f:	74 23                	je     801054 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801031:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801034:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801037:	eb 0e                	jmp    801047 <memset+0x91>
			*p8++ = (uint8)c;
  801039:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80103c:	8d 50 01             	lea    0x1(%eax),%edx
  80103f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801042:	8b 55 0c             	mov    0xc(%ebp),%edx
  801045:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801047:	8b 45 10             	mov    0x10(%ebp),%eax
  80104a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80104d:	89 55 10             	mov    %edx,0x10(%ebp)
  801050:	85 c0                	test   %eax,%eax
  801052:	75 e5                	jne    801039 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801054:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801057:	c9                   	leave  
  801058:	c3                   	ret    

00801059 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801059:	55                   	push   %ebp
  80105a:	89 e5                	mov    %esp,%ebp
  80105c:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  80105f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801062:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801065:	8b 45 08             	mov    0x8(%ebp),%eax
  801068:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  80106b:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80106f:	76 24                	jbe    801095 <memcpy+0x3c>
		while(n >= 8){
  801071:	eb 1c                	jmp    80108f <memcpy+0x36>
			*d64 = *s64;
  801073:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801076:	8b 50 04             	mov    0x4(%eax),%edx
  801079:	8b 00                	mov    (%eax),%eax
  80107b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80107e:	89 01                	mov    %eax,(%ecx)
  801080:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801083:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801087:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  80108b:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  80108f:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801093:	77 de                	ja     801073 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801095:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801099:	74 31                	je     8010cc <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  80109b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80109e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8010a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8010a7:	eb 16                	jmp    8010bf <memcpy+0x66>
			*d8++ = *s8++;
  8010a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010ac:	8d 50 01             	lea    0x1(%eax),%edx
  8010af:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8010b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010b5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010b8:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8010bb:	8a 12                	mov    (%edx),%dl
  8010bd:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  8010bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8010c2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010c5:	89 55 10             	mov    %edx,0x10(%ebp)
  8010c8:	85 c0                	test   %eax,%eax
  8010ca:	75 dd                	jne    8010a9 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  8010cc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010cf:	c9                   	leave  
  8010d0:	c3                   	ret    

008010d1 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8010d1:	55                   	push   %ebp
  8010d2:	89 e5                	mov    %esp,%ebp
  8010d4:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8010d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010da:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8010e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010e6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010e9:	73 50                	jae    80113b <memmove+0x6a>
  8010eb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f1:	01 d0                	add    %edx,%eax
  8010f3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010f6:	76 43                	jbe    80113b <memmove+0x6a>
		s += n;
  8010f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8010fb:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8010fe:	8b 45 10             	mov    0x10(%ebp),%eax
  801101:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801104:	eb 10                	jmp    801116 <memmove+0x45>
			*--d = *--s;
  801106:	ff 4d f8             	decl   -0x8(%ebp)
  801109:	ff 4d fc             	decl   -0x4(%ebp)
  80110c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80110f:	8a 10                	mov    (%eax),%dl
  801111:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801114:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801116:	8b 45 10             	mov    0x10(%ebp),%eax
  801119:	8d 50 ff             	lea    -0x1(%eax),%edx
  80111c:	89 55 10             	mov    %edx,0x10(%ebp)
  80111f:	85 c0                	test   %eax,%eax
  801121:	75 e3                	jne    801106 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801123:	eb 23                	jmp    801148 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801125:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801128:	8d 50 01             	lea    0x1(%eax),%edx
  80112b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80112e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801131:	8d 4a 01             	lea    0x1(%edx),%ecx
  801134:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801137:	8a 12                	mov    (%edx),%dl
  801139:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80113b:	8b 45 10             	mov    0x10(%ebp),%eax
  80113e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801141:	89 55 10             	mov    %edx,0x10(%ebp)
  801144:	85 c0                	test   %eax,%eax
  801146:	75 dd                	jne    801125 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801148:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80114b:	c9                   	leave  
  80114c:	c3                   	ret    

0080114d <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80114d:	55                   	push   %ebp
  80114e:	89 e5                	mov    %esp,%ebp
  801150:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801153:	8b 45 08             	mov    0x8(%ebp),%eax
  801156:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801159:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115c:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80115f:	eb 2a                	jmp    80118b <memcmp+0x3e>
		if (*s1 != *s2)
  801161:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801164:	8a 10                	mov    (%eax),%dl
  801166:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801169:	8a 00                	mov    (%eax),%al
  80116b:	38 c2                	cmp    %al,%dl
  80116d:	74 16                	je     801185 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80116f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801172:	8a 00                	mov    (%eax),%al
  801174:	0f b6 d0             	movzbl %al,%edx
  801177:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80117a:	8a 00                	mov    (%eax),%al
  80117c:	0f b6 c0             	movzbl %al,%eax
  80117f:	29 c2                	sub    %eax,%edx
  801181:	89 d0                	mov    %edx,%eax
  801183:	eb 18                	jmp    80119d <memcmp+0x50>
		s1++, s2++;
  801185:	ff 45 fc             	incl   -0x4(%ebp)
  801188:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80118b:	8b 45 10             	mov    0x10(%ebp),%eax
  80118e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801191:	89 55 10             	mov    %edx,0x10(%ebp)
  801194:	85 c0                	test   %eax,%eax
  801196:	75 c9                	jne    801161 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801198:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80119d:	c9                   	leave  
  80119e:	c3                   	ret    

0080119f <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80119f:	55                   	push   %ebp
  8011a0:	89 e5                	mov    %esp,%ebp
  8011a2:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8011a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8011a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ab:	01 d0                	add    %edx,%eax
  8011ad:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8011b0:	eb 15                	jmp    8011c7 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8011b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b5:	8a 00                	mov    (%eax),%al
  8011b7:	0f b6 d0             	movzbl %al,%edx
  8011ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011bd:	0f b6 c0             	movzbl %al,%eax
  8011c0:	39 c2                	cmp    %eax,%edx
  8011c2:	74 0d                	je     8011d1 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8011c4:	ff 45 08             	incl   0x8(%ebp)
  8011c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ca:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8011cd:	72 e3                	jb     8011b2 <memfind+0x13>
  8011cf:	eb 01                	jmp    8011d2 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8011d1:	90                   	nop
	return (void *) s;
  8011d2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011d5:	c9                   	leave  
  8011d6:	c3                   	ret    

008011d7 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8011d7:	55                   	push   %ebp
  8011d8:	89 e5                	mov    %esp,%ebp
  8011da:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8011dd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8011e4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011eb:	eb 03                	jmp    8011f0 <strtol+0x19>
		s++;
  8011ed:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f3:	8a 00                	mov    (%eax),%al
  8011f5:	3c 20                	cmp    $0x20,%al
  8011f7:	74 f4                	je     8011ed <strtol+0x16>
  8011f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fc:	8a 00                	mov    (%eax),%al
  8011fe:	3c 09                	cmp    $0x9,%al
  801200:	74 eb                	je     8011ed <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801202:	8b 45 08             	mov    0x8(%ebp),%eax
  801205:	8a 00                	mov    (%eax),%al
  801207:	3c 2b                	cmp    $0x2b,%al
  801209:	75 05                	jne    801210 <strtol+0x39>
		s++;
  80120b:	ff 45 08             	incl   0x8(%ebp)
  80120e:	eb 13                	jmp    801223 <strtol+0x4c>
	else if (*s == '-')
  801210:	8b 45 08             	mov    0x8(%ebp),%eax
  801213:	8a 00                	mov    (%eax),%al
  801215:	3c 2d                	cmp    $0x2d,%al
  801217:	75 0a                	jne    801223 <strtol+0x4c>
		s++, neg = 1;
  801219:	ff 45 08             	incl   0x8(%ebp)
  80121c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801223:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801227:	74 06                	je     80122f <strtol+0x58>
  801229:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80122d:	75 20                	jne    80124f <strtol+0x78>
  80122f:	8b 45 08             	mov    0x8(%ebp),%eax
  801232:	8a 00                	mov    (%eax),%al
  801234:	3c 30                	cmp    $0x30,%al
  801236:	75 17                	jne    80124f <strtol+0x78>
  801238:	8b 45 08             	mov    0x8(%ebp),%eax
  80123b:	40                   	inc    %eax
  80123c:	8a 00                	mov    (%eax),%al
  80123e:	3c 78                	cmp    $0x78,%al
  801240:	75 0d                	jne    80124f <strtol+0x78>
		s += 2, base = 16;
  801242:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801246:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80124d:	eb 28                	jmp    801277 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80124f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801253:	75 15                	jne    80126a <strtol+0x93>
  801255:	8b 45 08             	mov    0x8(%ebp),%eax
  801258:	8a 00                	mov    (%eax),%al
  80125a:	3c 30                	cmp    $0x30,%al
  80125c:	75 0c                	jne    80126a <strtol+0x93>
		s++, base = 8;
  80125e:	ff 45 08             	incl   0x8(%ebp)
  801261:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801268:	eb 0d                	jmp    801277 <strtol+0xa0>
	else if (base == 0)
  80126a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80126e:	75 07                	jne    801277 <strtol+0xa0>
		base = 10;
  801270:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801277:	8b 45 08             	mov    0x8(%ebp),%eax
  80127a:	8a 00                	mov    (%eax),%al
  80127c:	3c 2f                	cmp    $0x2f,%al
  80127e:	7e 19                	jle    801299 <strtol+0xc2>
  801280:	8b 45 08             	mov    0x8(%ebp),%eax
  801283:	8a 00                	mov    (%eax),%al
  801285:	3c 39                	cmp    $0x39,%al
  801287:	7f 10                	jg     801299 <strtol+0xc2>
			dig = *s - '0';
  801289:	8b 45 08             	mov    0x8(%ebp),%eax
  80128c:	8a 00                	mov    (%eax),%al
  80128e:	0f be c0             	movsbl %al,%eax
  801291:	83 e8 30             	sub    $0x30,%eax
  801294:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801297:	eb 42                	jmp    8012db <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801299:	8b 45 08             	mov    0x8(%ebp),%eax
  80129c:	8a 00                	mov    (%eax),%al
  80129e:	3c 60                	cmp    $0x60,%al
  8012a0:	7e 19                	jle    8012bb <strtol+0xe4>
  8012a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a5:	8a 00                	mov    (%eax),%al
  8012a7:	3c 7a                	cmp    $0x7a,%al
  8012a9:	7f 10                	jg     8012bb <strtol+0xe4>
			dig = *s - 'a' + 10;
  8012ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ae:	8a 00                	mov    (%eax),%al
  8012b0:	0f be c0             	movsbl %al,%eax
  8012b3:	83 e8 57             	sub    $0x57,%eax
  8012b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012b9:	eb 20                	jmp    8012db <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8012bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012be:	8a 00                	mov    (%eax),%al
  8012c0:	3c 40                	cmp    $0x40,%al
  8012c2:	7e 39                	jle    8012fd <strtol+0x126>
  8012c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c7:	8a 00                	mov    (%eax),%al
  8012c9:	3c 5a                	cmp    $0x5a,%al
  8012cb:	7f 30                	jg     8012fd <strtol+0x126>
			dig = *s - 'A' + 10;
  8012cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d0:	8a 00                	mov    (%eax),%al
  8012d2:	0f be c0             	movsbl %al,%eax
  8012d5:	83 e8 37             	sub    $0x37,%eax
  8012d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8012db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012de:	3b 45 10             	cmp    0x10(%ebp),%eax
  8012e1:	7d 19                	jge    8012fc <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8012e3:	ff 45 08             	incl   0x8(%ebp)
  8012e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012e9:	0f af 45 10          	imul   0x10(%ebp),%eax
  8012ed:	89 c2                	mov    %eax,%edx
  8012ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012f2:	01 d0                	add    %edx,%eax
  8012f4:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8012f7:	e9 7b ff ff ff       	jmp    801277 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8012fc:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8012fd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801301:	74 08                	je     80130b <strtol+0x134>
		*endptr = (char *) s;
  801303:	8b 45 0c             	mov    0xc(%ebp),%eax
  801306:	8b 55 08             	mov    0x8(%ebp),%edx
  801309:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80130b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80130f:	74 07                	je     801318 <strtol+0x141>
  801311:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801314:	f7 d8                	neg    %eax
  801316:	eb 03                	jmp    80131b <strtol+0x144>
  801318:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80131b:	c9                   	leave  
  80131c:	c3                   	ret    

0080131d <ltostr>:

void
ltostr(long value, char *str)
{
  80131d:	55                   	push   %ebp
  80131e:	89 e5                	mov    %esp,%ebp
  801320:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801323:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80132a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801331:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801335:	79 13                	jns    80134a <ltostr+0x2d>
	{
		neg = 1;
  801337:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80133e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801341:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801344:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801347:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80134a:	8b 45 08             	mov    0x8(%ebp),%eax
  80134d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801352:	99                   	cltd   
  801353:	f7 f9                	idiv   %ecx
  801355:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801358:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80135b:	8d 50 01             	lea    0x1(%eax),%edx
  80135e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801361:	89 c2                	mov    %eax,%edx
  801363:	8b 45 0c             	mov    0xc(%ebp),%eax
  801366:	01 d0                	add    %edx,%eax
  801368:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80136b:	83 c2 30             	add    $0x30,%edx
  80136e:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801370:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801373:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801378:	f7 e9                	imul   %ecx
  80137a:	c1 fa 02             	sar    $0x2,%edx
  80137d:	89 c8                	mov    %ecx,%eax
  80137f:	c1 f8 1f             	sar    $0x1f,%eax
  801382:	29 c2                	sub    %eax,%edx
  801384:	89 d0                	mov    %edx,%eax
  801386:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801389:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80138d:	75 bb                	jne    80134a <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80138f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801396:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801399:	48                   	dec    %eax
  80139a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80139d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8013a1:	74 3d                	je     8013e0 <ltostr+0xc3>
		start = 1 ;
  8013a3:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8013aa:	eb 34                	jmp    8013e0 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8013ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b2:	01 d0                	add    %edx,%eax
  8013b4:	8a 00                	mov    (%eax),%al
  8013b6:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8013b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013bf:	01 c2                	add    %eax,%edx
  8013c1:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8013c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c7:	01 c8                	add    %ecx,%eax
  8013c9:	8a 00                	mov    (%eax),%al
  8013cb:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8013cd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d3:	01 c2                	add    %eax,%edx
  8013d5:	8a 45 eb             	mov    -0x15(%ebp),%al
  8013d8:	88 02                	mov    %al,(%edx)
		start++ ;
  8013da:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8013dd:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8013e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013e3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013e6:	7c c4                	jl     8013ac <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8013e8:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8013eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ee:	01 d0                	add    %edx,%eax
  8013f0:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8013f3:	90                   	nop
  8013f4:	c9                   	leave  
  8013f5:	c3                   	ret    

008013f6 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8013f6:	55                   	push   %ebp
  8013f7:	89 e5                	mov    %esp,%ebp
  8013f9:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8013fc:	ff 75 08             	pushl  0x8(%ebp)
  8013ff:	e8 c4 f9 ff ff       	call   800dc8 <strlen>
  801404:	83 c4 04             	add    $0x4,%esp
  801407:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80140a:	ff 75 0c             	pushl  0xc(%ebp)
  80140d:	e8 b6 f9 ff ff       	call   800dc8 <strlen>
  801412:	83 c4 04             	add    $0x4,%esp
  801415:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801418:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80141f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801426:	eb 17                	jmp    80143f <strcconcat+0x49>
		final[s] = str1[s] ;
  801428:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80142b:	8b 45 10             	mov    0x10(%ebp),%eax
  80142e:	01 c2                	add    %eax,%edx
  801430:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801433:	8b 45 08             	mov    0x8(%ebp),%eax
  801436:	01 c8                	add    %ecx,%eax
  801438:	8a 00                	mov    (%eax),%al
  80143a:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80143c:	ff 45 fc             	incl   -0x4(%ebp)
  80143f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801442:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801445:	7c e1                	jl     801428 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801447:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80144e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801455:	eb 1f                	jmp    801476 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801457:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80145a:	8d 50 01             	lea    0x1(%eax),%edx
  80145d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801460:	89 c2                	mov    %eax,%edx
  801462:	8b 45 10             	mov    0x10(%ebp),%eax
  801465:	01 c2                	add    %eax,%edx
  801467:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80146a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80146d:	01 c8                	add    %ecx,%eax
  80146f:	8a 00                	mov    (%eax),%al
  801471:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801473:	ff 45 f8             	incl   -0x8(%ebp)
  801476:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801479:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80147c:	7c d9                	jl     801457 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80147e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801481:	8b 45 10             	mov    0x10(%ebp),%eax
  801484:	01 d0                	add    %edx,%eax
  801486:	c6 00 00             	movb   $0x0,(%eax)
}
  801489:	90                   	nop
  80148a:	c9                   	leave  
  80148b:	c3                   	ret    

0080148c <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80148c:	55                   	push   %ebp
  80148d:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80148f:	8b 45 14             	mov    0x14(%ebp),%eax
  801492:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801498:	8b 45 14             	mov    0x14(%ebp),%eax
  80149b:	8b 00                	mov    (%eax),%eax
  80149d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8014a7:	01 d0                	add    %edx,%eax
  8014a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014af:	eb 0c                	jmp    8014bd <strsplit+0x31>
			*string++ = 0;
  8014b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b4:	8d 50 01             	lea    0x1(%eax),%edx
  8014b7:	89 55 08             	mov    %edx,0x8(%ebp)
  8014ba:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c0:	8a 00                	mov    (%eax),%al
  8014c2:	84 c0                	test   %al,%al
  8014c4:	74 18                	je     8014de <strsplit+0x52>
  8014c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c9:	8a 00                	mov    (%eax),%al
  8014cb:	0f be c0             	movsbl %al,%eax
  8014ce:	50                   	push   %eax
  8014cf:	ff 75 0c             	pushl  0xc(%ebp)
  8014d2:	e8 83 fa ff ff       	call   800f5a <strchr>
  8014d7:	83 c4 08             	add    $0x8,%esp
  8014da:	85 c0                	test   %eax,%eax
  8014dc:	75 d3                	jne    8014b1 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8014de:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e1:	8a 00                	mov    (%eax),%al
  8014e3:	84 c0                	test   %al,%al
  8014e5:	74 5a                	je     801541 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8014e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8014ea:	8b 00                	mov    (%eax),%eax
  8014ec:	83 f8 0f             	cmp    $0xf,%eax
  8014ef:	75 07                	jne    8014f8 <strsplit+0x6c>
		{
			return 0;
  8014f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8014f6:	eb 66                	jmp    80155e <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8014f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8014fb:	8b 00                	mov    (%eax),%eax
  8014fd:	8d 48 01             	lea    0x1(%eax),%ecx
  801500:	8b 55 14             	mov    0x14(%ebp),%edx
  801503:	89 0a                	mov    %ecx,(%edx)
  801505:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80150c:	8b 45 10             	mov    0x10(%ebp),%eax
  80150f:	01 c2                	add    %eax,%edx
  801511:	8b 45 08             	mov    0x8(%ebp),%eax
  801514:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801516:	eb 03                	jmp    80151b <strsplit+0x8f>
			string++;
  801518:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80151b:	8b 45 08             	mov    0x8(%ebp),%eax
  80151e:	8a 00                	mov    (%eax),%al
  801520:	84 c0                	test   %al,%al
  801522:	74 8b                	je     8014af <strsplit+0x23>
  801524:	8b 45 08             	mov    0x8(%ebp),%eax
  801527:	8a 00                	mov    (%eax),%al
  801529:	0f be c0             	movsbl %al,%eax
  80152c:	50                   	push   %eax
  80152d:	ff 75 0c             	pushl  0xc(%ebp)
  801530:	e8 25 fa ff ff       	call   800f5a <strchr>
  801535:	83 c4 08             	add    $0x8,%esp
  801538:	85 c0                	test   %eax,%eax
  80153a:	74 dc                	je     801518 <strsplit+0x8c>
			string++;
	}
  80153c:	e9 6e ff ff ff       	jmp    8014af <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801541:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801542:	8b 45 14             	mov    0x14(%ebp),%eax
  801545:	8b 00                	mov    (%eax),%eax
  801547:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80154e:	8b 45 10             	mov    0x10(%ebp),%eax
  801551:	01 d0                	add    %edx,%eax
  801553:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801559:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80155e:	c9                   	leave  
  80155f:	c3                   	ret    

00801560 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801560:	55                   	push   %ebp
  801561:	89 e5                	mov    %esp,%ebp
  801563:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801566:	8b 45 08             	mov    0x8(%ebp),%eax
  801569:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  80156c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801573:	eb 4a                	jmp    8015bf <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801575:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801578:	8b 45 08             	mov    0x8(%ebp),%eax
  80157b:	01 c2                	add    %eax,%edx
  80157d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801580:	8b 45 0c             	mov    0xc(%ebp),%eax
  801583:	01 c8                	add    %ecx,%eax
  801585:	8a 00                	mov    (%eax),%al
  801587:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801589:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80158c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80158f:	01 d0                	add    %edx,%eax
  801591:	8a 00                	mov    (%eax),%al
  801593:	3c 40                	cmp    $0x40,%al
  801595:	7e 25                	jle    8015bc <str2lower+0x5c>
  801597:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80159a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80159d:	01 d0                	add    %edx,%eax
  80159f:	8a 00                	mov    (%eax),%al
  8015a1:	3c 5a                	cmp    $0x5a,%al
  8015a3:	7f 17                	jg     8015bc <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8015a5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ab:	01 d0                	add    %edx,%eax
  8015ad:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015b0:	8b 55 08             	mov    0x8(%ebp),%edx
  8015b3:	01 ca                	add    %ecx,%edx
  8015b5:	8a 12                	mov    (%edx),%dl
  8015b7:	83 c2 20             	add    $0x20,%edx
  8015ba:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8015bc:	ff 45 fc             	incl   -0x4(%ebp)
  8015bf:	ff 75 0c             	pushl  0xc(%ebp)
  8015c2:	e8 01 f8 ff ff       	call   800dc8 <strlen>
  8015c7:	83 c4 04             	add    $0x4,%esp
  8015ca:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8015cd:	7f a6                	jg     801575 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8015cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8015d2:	c9                   	leave  
  8015d3:	c3                   	ret    

008015d4 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8015d4:	55                   	push   %ebp
  8015d5:	89 e5                	mov    %esp,%ebp
  8015d7:	57                   	push   %edi
  8015d8:	56                   	push   %esi
  8015d9:	53                   	push   %ebx
  8015da:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015e3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015e6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8015e9:	8b 7d 18             	mov    0x18(%ebp),%edi
  8015ec:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8015ef:	cd 30                	int    $0x30
  8015f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8015f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8015f7:	83 c4 10             	add    $0x10,%esp
  8015fa:	5b                   	pop    %ebx
  8015fb:	5e                   	pop    %esi
  8015fc:	5f                   	pop    %edi
  8015fd:	5d                   	pop    %ebp
  8015fe:	c3                   	ret    

008015ff <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8015ff:	55                   	push   %ebp
  801600:	89 e5                	mov    %esp,%ebp
  801602:	83 ec 04             	sub    $0x4,%esp
  801605:	8b 45 10             	mov    0x10(%ebp),%eax
  801608:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  80160b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80160e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801612:	8b 45 08             	mov    0x8(%ebp),%eax
  801615:	6a 00                	push   $0x0
  801617:	51                   	push   %ecx
  801618:	52                   	push   %edx
  801619:	ff 75 0c             	pushl  0xc(%ebp)
  80161c:	50                   	push   %eax
  80161d:	6a 00                	push   $0x0
  80161f:	e8 b0 ff ff ff       	call   8015d4 <syscall>
  801624:	83 c4 18             	add    $0x18,%esp
}
  801627:	90                   	nop
  801628:	c9                   	leave  
  801629:	c3                   	ret    

0080162a <sys_cgetc>:

int
sys_cgetc(void)
{
  80162a:	55                   	push   %ebp
  80162b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80162d:	6a 00                	push   $0x0
  80162f:	6a 00                	push   $0x0
  801631:	6a 00                	push   $0x0
  801633:	6a 00                	push   $0x0
  801635:	6a 00                	push   $0x0
  801637:	6a 02                	push   $0x2
  801639:	e8 96 ff ff ff       	call   8015d4 <syscall>
  80163e:	83 c4 18             	add    $0x18,%esp
}
  801641:	c9                   	leave  
  801642:	c3                   	ret    

00801643 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801643:	55                   	push   %ebp
  801644:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801646:	6a 00                	push   $0x0
  801648:	6a 00                	push   $0x0
  80164a:	6a 00                	push   $0x0
  80164c:	6a 00                	push   $0x0
  80164e:	6a 00                	push   $0x0
  801650:	6a 03                	push   $0x3
  801652:	e8 7d ff ff ff       	call   8015d4 <syscall>
  801657:	83 c4 18             	add    $0x18,%esp
}
  80165a:	90                   	nop
  80165b:	c9                   	leave  
  80165c:	c3                   	ret    

0080165d <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80165d:	55                   	push   %ebp
  80165e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801660:	6a 00                	push   $0x0
  801662:	6a 00                	push   $0x0
  801664:	6a 00                	push   $0x0
  801666:	6a 00                	push   $0x0
  801668:	6a 00                	push   $0x0
  80166a:	6a 04                	push   $0x4
  80166c:	e8 63 ff ff ff       	call   8015d4 <syscall>
  801671:	83 c4 18             	add    $0x18,%esp
}
  801674:	90                   	nop
  801675:	c9                   	leave  
  801676:	c3                   	ret    

00801677 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801677:	55                   	push   %ebp
  801678:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80167a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80167d:	8b 45 08             	mov    0x8(%ebp),%eax
  801680:	6a 00                	push   $0x0
  801682:	6a 00                	push   $0x0
  801684:	6a 00                	push   $0x0
  801686:	52                   	push   %edx
  801687:	50                   	push   %eax
  801688:	6a 08                	push   $0x8
  80168a:	e8 45 ff ff ff       	call   8015d4 <syscall>
  80168f:	83 c4 18             	add    $0x18,%esp
}
  801692:	c9                   	leave  
  801693:	c3                   	ret    

00801694 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801694:	55                   	push   %ebp
  801695:	89 e5                	mov    %esp,%ebp
  801697:	56                   	push   %esi
  801698:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801699:	8b 75 18             	mov    0x18(%ebp),%esi
  80169c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80169f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a8:	56                   	push   %esi
  8016a9:	53                   	push   %ebx
  8016aa:	51                   	push   %ecx
  8016ab:	52                   	push   %edx
  8016ac:	50                   	push   %eax
  8016ad:	6a 09                	push   $0x9
  8016af:	e8 20 ff ff ff       	call   8015d4 <syscall>
  8016b4:	83 c4 18             	add    $0x18,%esp
}
  8016b7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016ba:	5b                   	pop    %ebx
  8016bb:	5e                   	pop    %esi
  8016bc:	5d                   	pop    %ebp
  8016bd:	c3                   	ret    

008016be <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8016be:	55                   	push   %ebp
  8016bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8016c1:	6a 00                	push   $0x0
  8016c3:	6a 00                	push   $0x0
  8016c5:	6a 00                	push   $0x0
  8016c7:	6a 00                	push   $0x0
  8016c9:	ff 75 08             	pushl  0x8(%ebp)
  8016cc:	6a 0a                	push   $0xa
  8016ce:	e8 01 ff ff ff       	call   8015d4 <syscall>
  8016d3:	83 c4 18             	add    $0x18,%esp
}
  8016d6:	c9                   	leave  
  8016d7:	c3                   	ret    

008016d8 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8016d8:	55                   	push   %ebp
  8016d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8016db:	6a 00                	push   $0x0
  8016dd:	6a 00                	push   $0x0
  8016df:	6a 00                	push   $0x0
  8016e1:	ff 75 0c             	pushl  0xc(%ebp)
  8016e4:	ff 75 08             	pushl  0x8(%ebp)
  8016e7:	6a 0b                	push   $0xb
  8016e9:	e8 e6 fe ff ff       	call   8015d4 <syscall>
  8016ee:	83 c4 18             	add    $0x18,%esp
}
  8016f1:	c9                   	leave  
  8016f2:	c3                   	ret    

008016f3 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8016f3:	55                   	push   %ebp
  8016f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8016f6:	6a 00                	push   $0x0
  8016f8:	6a 00                	push   $0x0
  8016fa:	6a 00                	push   $0x0
  8016fc:	6a 00                	push   $0x0
  8016fe:	6a 00                	push   $0x0
  801700:	6a 0c                	push   $0xc
  801702:	e8 cd fe ff ff       	call   8015d4 <syscall>
  801707:	83 c4 18             	add    $0x18,%esp
}
  80170a:	c9                   	leave  
  80170b:	c3                   	ret    

0080170c <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80170c:	55                   	push   %ebp
  80170d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80170f:	6a 00                	push   $0x0
  801711:	6a 00                	push   $0x0
  801713:	6a 00                	push   $0x0
  801715:	6a 00                	push   $0x0
  801717:	6a 00                	push   $0x0
  801719:	6a 0d                	push   $0xd
  80171b:	e8 b4 fe ff ff       	call   8015d4 <syscall>
  801720:	83 c4 18             	add    $0x18,%esp
}
  801723:	c9                   	leave  
  801724:	c3                   	ret    

00801725 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801725:	55                   	push   %ebp
  801726:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801728:	6a 00                	push   $0x0
  80172a:	6a 00                	push   $0x0
  80172c:	6a 00                	push   $0x0
  80172e:	6a 00                	push   $0x0
  801730:	6a 00                	push   $0x0
  801732:	6a 0e                	push   $0xe
  801734:	e8 9b fe ff ff       	call   8015d4 <syscall>
  801739:	83 c4 18             	add    $0x18,%esp
}
  80173c:	c9                   	leave  
  80173d:	c3                   	ret    

0080173e <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80173e:	55                   	push   %ebp
  80173f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801741:	6a 00                	push   $0x0
  801743:	6a 00                	push   $0x0
  801745:	6a 00                	push   $0x0
  801747:	6a 00                	push   $0x0
  801749:	6a 00                	push   $0x0
  80174b:	6a 0f                	push   $0xf
  80174d:	e8 82 fe ff ff       	call   8015d4 <syscall>
  801752:	83 c4 18             	add    $0x18,%esp
}
  801755:	c9                   	leave  
  801756:	c3                   	ret    

00801757 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801757:	55                   	push   %ebp
  801758:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80175a:	6a 00                	push   $0x0
  80175c:	6a 00                	push   $0x0
  80175e:	6a 00                	push   $0x0
  801760:	6a 00                	push   $0x0
  801762:	ff 75 08             	pushl  0x8(%ebp)
  801765:	6a 10                	push   $0x10
  801767:	e8 68 fe ff ff       	call   8015d4 <syscall>
  80176c:	83 c4 18             	add    $0x18,%esp
}
  80176f:	c9                   	leave  
  801770:	c3                   	ret    

00801771 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801771:	55                   	push   %ebp
  801772:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801774:	6a 00                	push   $0x0
  801776:	6a 00                	push   $0x0
  801778:	6a 00                	push   $0x0
  80177a:	6a 00                	push   $0x0
  80177c:	6a 00                	push   $0x0
  80177e:	6a 11                	push   $0x11
  801780:	e8 4f fe ff ff       	call   8015d4 <syscall>
  801785:	83 c4 18             	add    $0x18,%esp
}
  801788:	90                   	nop
  801789:	c9                   	leave  
  80178a:	c3                   	ret    

0080178b <sys_cputc>:

void
sys_cputc(const char c)
{
  80178b:	55                   	push   %ebp
  80178c:	89 e5                	mov    %esp,%ebp
  80178e:	83 ec 04             	sub    $0x4,%esp
  801791:	8b 45 08             	mov    0x8(%ebp),%eax
  801794:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801797:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80179b:	6a 00                	push   $0x0
  80179d:	6a 00                	push   $0x0
  80179f:	6a 00                	push   $0x0
  8017a1:	6a 00                	push   $0x0
  8017a3:	50                   	push   %eax
  8017a4:	6a 01                	push   $0x1
  8017a6:	e8 29 fe ff ff       	call   8015d4 <syscall>
  8017ab:	83 c4 18             	add    $0x18,%esp
}
  8017ae:	90                   	nop
  8017af:	c9                   	leave  
  8017b0:	c3                   	ret    

008017b1 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8017b1:	55                   	push   %ebp
  8017b2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8017b4:	6a 00                	push   $0x0
  8017b6:	6a 00                	push   $0x0
  8017b8:	6a 00                	push   $0x0
  8017ba:	6a 00                	push   $0x0
  8017bc:	6a 00                	push   $0x0
  8017be:	6a 14                	push   $0x14
  8017c0:	e8 0f fe ff ff       	call   8015d4 <syscall>
  8017c5:	83 c4 18             	add    $0x18,%esp
}
  8017c8:	90                   	nop
  8017c9:	c9                   	leave  
  8017ca:	c3                   	ret    

008017cb <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8017cb:	55                   	push   %ebp
  8017cc:	89 e5                	mov    %esp,%ebp
  8017ce:	83 ec 04             	sub    $0x4,%esp
  8017d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8017d4:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8017d7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8017da:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017de:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e1:	6a 00                	push   $0x0
  8017e3:	51                   	push   %ecx
  8017e4:	52                   	push   %edx
  8017e5:	ff 75 0c             	pushl  0xc(%ebp)
  8017e8:	50                   	push   %eax
  8017e9:	6a 15                	push   $0x15
  8017eb:	e8 e4 fd ff ff       	call   8015d4 <syscall>
  8017f0:	83 c4 18             	add    $0x18,%esp
}
  8017f3:	c9                   	leave  
  8017f4:	c3                   	ret    

008017f5 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8017f5:	55                   	push   %ebp
  8017f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8017f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fe:	6a 00                	push   $0x0
  801800:	6a 00                	push   $0x0
  801802:	6a 00                	push   $0x0
  801804:	52                   	push   %edx
  801805:	50                   	push   %eax
  801806:	6a 16                	push   $0x16
  801808:	e8 c7 fd ff ff       	call   8015d4 <syscall>
  80180d:	83 c4 18             	add    $0x18,%esp
}
  801810:	c9                   	leave  
  801811:	c3                   	ret    

00801812 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801812:	55                   	push   %ebp
  801813:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801815:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801818:	8b 55 0c             	mov    0xc(%ebp),%edx
  80181b:	8b 45 08             	mov    0x8(%ebp),%eax
  80181e:	6a 00                	push   $0x0
  801820:	6a 00                	push   $0x0
  801822:	51                   	push   %ecx
  801823:	52                   	push   %edx
  801824:	50                   	push   %eax
  801825:	6a 17                	push   $0x17
  801827:	e8 a8 fd ff ff       	call   8015d4 <syscall>
  80182c:	83 c4 18             	add    $0x18,%esp
}
  80182f:	c9                   	leave  
  801830:	c3                   	ret    

00801831 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801831:	55                   	push   %ebp
  801832:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801834:	8b 55 0c             	mov    0xc(%ebp),%edx
  801837:	8b 45 08             	mov    0x8(%ebp),%eax
  80183a:	6a 00                	push   $0x0
  80183c:	6a 00                	push   $0x0
  80183e:	6a 00                	push   $0x0
  801840:	52                   	push   %edx
  801841:	50                   	push   %eax
  801842:	6a 18                	push   $0x18
  801844:	e8 8b fd ff ff       	call   8015d4 <syscall>
  801849:	83 c4 18             	add    $0x18,%esp
}
  80184c:	c9                   	leave  
  80184d:	c3                   	ret    

0080184e <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80184e:	55                   	push   %ebp
  80184f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801851:	8b 45 08             	mov    0x8(%ebp),%eax
  801854:	6a 00                	push   $0x0
  801856:	ff 75 14             	pushl  0x14(%ebp)
  801859:	ff 75 10             	pushl  0x10(%ebp)
  80185c:	ff 75 0c             	pushl  0xc(%ebp)
  80185f:	50                   	push   %eax
  801860:	6a 19                	push   $0x19
  801862:	e8 6d fd ff ff       	call   8015d4 <syscall>
  801867:	83 c4 18             	add    $0x18,%esp
}
  80186a:	c9                   	leave  
  80186b:	c3                   	ret    

0080186c <sys_run_env>:

void sys_run_env(int32 envId)
{
  80186c:	55                   	push   %ebp
  80186d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80186f:	8b 45 08             	mov    0x8(%ebp),%eax
  801872:	6a 00                	push   $0x0
  801874:	6a 00                	push   $0x0
  801876:	6a 00                	push   $0x0
  801878:	6a 00                	push   $0x0
  80187a:	50                   	push   %eax
  80187b:	6a 1a                	push   $0x1a
  80187d:	e8 52 fd ff ff       	call   8015d4 <syscall>
  801882:	83 c4 18             	add    $0x18,%esp
}
  801885:	90                   	nop
  801886:	c9                   	leave  
  801887:	c3                   	ret    

00801888 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801888:	55                   	push   %ebp
  801889:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80188b:	8b 45 08             	mov    0x8(%ebp),%eax
  80188e:	6a 00                	push   $0x0
  801890:	6a 00                	push   $0x0
  801892:	6a 00                	push   $0x0
  801894:	6a 00                	push   $0x0
  801896:	50                   	push   %eax
  801897:	6a 1b                	push   $0x1b
  801899:	e8 36 fd ff ff       	call   8015d4 <syscall>
  80189e:	83 c4 18             	add    $0x18,%esp
}
  8018a1:	c9                   	leave  
  8018a2:	c3                   	ret    

008018a3 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8018a3:	55                   	push   %ebp
  8018a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8018a6:	6a 00                	push   $0x0
  8018a8:	6a 00                	push   $0x0
  8018aa:	6a 00                	push   $0x0
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 00                	push   $0x0
  8018b0:	6a 05                	push   $0x5
  8018b2:	e8 1d fd ff ff       	call   8015d4 <syscall>
  8018b7:	83 c4 18             	add    $0x18,%esp
}
  8018ba:	c9                   	leave  
  8018bb:	c3                   	ret    

008018bc <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8018bc:	55                   	push   %ebp
  8018bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8018bf:	6a 00                	push   $0x0
  8018c1:	6a 00                	push   $0x0
  8018c3:	6a 00                	push   $0x0
  8018c5:	6a 00                	push   $0x0
  8018c7:	6a 00                	push   $0x0
  8018c9:	6a 06                	push   $0x6
  8018cb:	e8 04 fd ff ff       	call   8015d4 <syscall>
  8018d0:	83 c4 18             	add    $0x18,%esp
}
  8018d3:	c9                   	leave  
  8018d4:	c3                   	ret    

008018d5 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8018d5:	55                   	push   %ebp
  8018d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8018d8:	6a 00                	push   $0x0
  8018da:	6a 00                	push   $0x0
  8018dc:	6a 00                	push   $0x0
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 07                	push   $0x7
  8018e4:	e8 eb fc ff ff       	call   8015d4 <syscall>
  8018e9:	83 c4 18             	add    $0x18,%esp
}
  8018ec:	c9                   	leave  
  8018ed:	c3                   	ret    

008018ee <sys_exit_env>:


void sys_exit_env(void)
{
  8018ee:	55                   	push   %ebp
  8018ef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8018f1:	6a 00                	push   $0x0
  8018f3:	6a 00                	push   $0x0
  8018f5:	6a 00                	push   $0x0
  8018f7:	6a 00                	push   $0x0
  8018f9:	6a 00                	push   $0x0
  8018fb:	6a 1c                	push   $0x1c
  8018fd:	e8 d2 fc ff ff       	call   8015d4 <syscall>
  801902:	83 c4 18             	add    $0x18,%esp
}
  801905:	90                   	nop
  801906:	c9                   	leave  
  801907:	c3                   	ret    

00801908 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801908:	55                   	push   %ebp
  801909:	89 e5                	mov    %esp,%ebp
  80190b:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80190e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801911:	8d 50 04             	lea    0x4(%eax),%edx
  801914:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801917:	6a 00                	push   $0x0
  801919:	6a 00                	push   $0x0
  80191b:	6a 00                	push   $0x0
  80191d:	52                   	push   %edx
  80191e:	50                   	push   %eax
  80191f:	6a 1d                	push   $0x1d
  801921:	e8 ae fc ff ff       	call   8015d4 <syscall>
  801926:	83 c4 18             	add    $0x18,%esp
	return result;
  801929:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80192c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80192f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801932:	89 01                	mov    %eax,(%ecx)
  801934:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801937:	8b 45 08             	mov    0x8(%ebp),%eax
  80193a:	c9                   	leave  
  80193b:	c2 04 00             	ret    $0x4

0080193e <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80193e:	55                   	push   %ebp
  80193f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801941:	6a 00                	push   $0x0
  801943:	6a 00                	push   $0x0
  801945:	ff 75 10             	pushl  0x10(%ebp)
  801948:	ff 75 0c             	pushl  0xc(%ebp)
  80194b:	ff 75 08             	pushl  0x8(%ebp)
  80194e:	6a 13                	push   $0x13
  801950:	e8 7f fc ff ff       	call   8015d4 <syscall>
  801955:	83 c4 18             	add    $0x18,%esp
	return ;
  801958:	90                   	nop
}
  801959:	c9                   	leave  
  80195a:	c3                   	ret    

0080195b <sys_rcr2>:
uint32 sys_rcr2()
{
  80195b:	55                   	push   %ebp
  80195c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80195e:	6a 00                	push   $0x0
  801960:	6a 00                	push   $0x0
  801962:	6a 00                	push   $0x0
  801964:	6a 00                	push   $0x0
  801966:	6a 00                	push   $0x0
  801968:	6a 1e                	push   $0x1e
  80196a:	e8 65 fc ff ff       	call   8015d4 <syscall>
  80196f:	83 c4 18             	add    $0x18,%esp
}
  801972:	c9                   	leave  
  801973:	c3                   	ret    

00801974 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801974:	55                   	push   %ebp
  801975:	89 e5                	mov    %esp,%ebp
  801977:	83 ec 04             	sub    $0x4,%esp
  80197a:	8b 45 08             	mov    0x8(%ebp),%eax
  80197d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801980:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	6a 00                	push   $0x0
  80198a:	6a 00                	push   $0x0
  80198c:	50                   	push   %eax
  80198d:	6a 1f                	push   $0x1f
  80198f:	e8 40 fc ff ff       	call   8015d4 <syscall>
  801994:	83 c4 18             	add    $0x18,%esp
	return ;
  801997:	90                   	nop
}
  801998:	c9                   	leave  
  801999:	c3                   	ret    

0080199a <rsttst>:
void rsttst()
{
  80199a:	55                   	push   %ebp
  80199b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 21                	push   $0x21
  8019a9:	e8 26 fc ff ff       	call   8015d4 <syscall>
  8019ae:	83 c4 18             	add    $0x18,%esp
	return ;
  8019b1:	90                   	nop
}
  8019b2:	c9                   	leave  
  8019b3:	c3                   	ret    

008019b4 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8019b4:	55                   	push   %ebp
  8019b5:	89 e5                	mov    %esp,%ebp
  8019b7:	83 ec 04             	sub    $0x4,%esp
  8019ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8019bd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8019c0:	8b 55 18             	mov    0x18(%ebp),%edx
  8019c3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019c7:	52                   	push   %edx
  8019c8:	50                   	push   %eax
  8019c9:	ff 75 10             	pushl  0x10(%ebp)
  8019cc:	ff 75 0c             	pushl  0xc(%ebp)
  8019cf:	ff 75 08             	pushl  0x8(%ebp)
  8019d2:	6a 20                	push   $0x20
  8019d4:	e8 fb fb ff ff       	call   8015d4 <syscall>
  8019d9:	83 c4 18             	add    $0x18,%esp
	return ;
  8019dc:	90                   	nop
}
  8019dd:	c9                   	leave  
  8019de:	c3                   	ret    

008019df <chktst>:
void chktst(uint32 n)
{
  8019df:	55                   	push   %ebp
  8019e0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 00                	push   $0x0
  8019ea:	ff 75 08             	pushl  0x8(%ebp)
  8019ed:	6a 22                	push   $0x22
  8019ef:	e8 e0 fb ff ff       	call   8015d4 <syscall>
  8019f4:	83 c4 18             	add    $0x18,%esp
	return ;
  8019f7:	90                   	nop
}
  8019f8:	c9                   	leave  
  8019f9:	c3                   	ret    

008019fa <inctst>:

void inctst()
{
  8019fa:	55                   	push   %ebp
  8019fb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 00                	push   $0x0
  801a01:	6a 00                	push   $0x0
  801a03:	6a 00                	push   $0x0
  801a05:	6a 00                	push   $0x0
  801a07:	6a 23                	push   $0x23
  801a09:	e8 c6 fb ff ff       	call   8015d4 <syscall>
  801a0e:	83 c4 18             	add    $0x18,%esp
	return ;
  801a11:	90                   	nop
}
  801a12:	c9                   	leave  
  801a13:	c3                   	ret    

00801a14 <gettst>:
uint32 gettst()
{
  801a14:	55                   	push   %ebp
  801a15:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 24                	push   $0x24
  801a23:	e8 ac fb ff ff       	call   8015d4 <syscall>
  801a28:	83 c4 18             	add    $0x18,%esp
}
  801a2b:	c9                   	leave  
  801a2c:	c3                   	ret    

00801a2d <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801a2d:	55                   	push   %ebp
  801a2e:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a30:	6a 00                	push   $0x0
  801a32:	6a 00                	push   $0x0
  801a34:	6a 00                	push   $0x0
  801a36:	6a 00                	push   $0x0
  801a38:	6a 00                	push   $0x0
  801a3a:	6a 25                	push   $0x25
  801a3c:	e8 93 fb ff ff       	call   8015d4 <syscall>
  801a41:	83 c4 18             	add    $0x18,%esp
  801a44:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801a49:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801a4e:	c9                   	leave  
  801a4f:	c3                   	ret    

00801a50 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801a50:	55                   	push   %ebp
  801a51:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801a53:	8b 45 08             	mov    0x8(%ebp),%eax
  801a56:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 00                	push   $0x0
  801a63:	ff 75 08             	pushl  0x8(%ebp)
  801a66:	6a 26                	push   $0x26
  801a68:	e8 67 fb ff ff       	call   8015d4 <syscall>
  801a6d:	83 c4 18             	add    $0x18,%esp
	return ;
  801a70:	90                   	nop
}
  801a71:	c9                   	leave  
  801a72:	c3                   	ret    

00801a73 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801a73:	55                   	push   %ebp
  801a74:	89 e5                	mov    %esp,%ebp
  801a76:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801a77:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a7a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a80:	8b 45 08             	mov    0x8(%ebp),%eax
  801a83:	6a 00                	push   $0x0
  801a85:	53                   	push   %ebx
  801a86:	51                   	push   %ecx
  801a87:	52                   	push   %edx
  801a88:	50                   	push   %eax
  801a89:	6a 27                	push   $0x27
  801a8b:	e8 44 fb ff ff       	call   8015d4 <syscall>
  801a90:	83 c4 18             	add    $0x18,%esp
}
  801a93:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a96:	c9                   	leave  
  801a97:	c3                   	ret    

00801a98 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801a98:	55                   	push   %ebp
  801a99:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801a9b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa1:	6a 00                	push   $0x0
  801aa3:	6a 00                	push   $0x0
  801aa5:	6a 00                	push   $0x0
  801aa7:	52                   	push   %edx
  801aa8:	50                   	push   %eax
  801aa9:	6a 28                	push   $0x28
  801aab:	e8 24 fb ff ff       	call   8015d4 <syscall>
  801ab0:	83 c4 18             	add    $0x18,%esp
}
  801ab3:	c9                   	leave  
  801ab4:	c3                   	ret    

00801ab5 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801ab5:	55                   	push   %ebp
  801ab6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801ab8:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801abb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801abe:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac1:	6a 00                	push   $0x0
  801ac3:	51                   	push   %ecx
  801ac4:	ff 75 10             	pushl  0x10(%ebp)
  801ac7:	52                   	push   %edx
  801ac8:	50                   	push   %eax
  801ac9:	6a 29                	push   $0x29
  801acb:	e8 04 fb ff ff       	call   8015d4 <syscall>
  801ad0:	83 c4 18             	add    $0x18,%esp
}
  801ad3:	c9                   	leave  
  801ad4:	c3                   	ret    

00801ad5 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801ad5:	55                   	push   %ebp
  801ad6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801ad8:	6a 00                	push   $0x0
  801ada:	6a 00                	push   $0x0
  801adc:	ff 75 10             	pushl  0x10(%ebp)
  801adf:	ff 75 0c             	pushl  0xc(%ebp)
  801ae2:	ff 75 08             	pushl  0x8(%ebp)
  801ae5:	6a 12                	push   $0x12
  801ae7:	e8 e8 fa ff ff       	call   8015d4 <syscall>
  801aec:	83 c4 18             	add    $0x18,%esp
	return ;
  801aef:	90                   	nop
}
  801af0:	c9                   	leave  
  801af1:	c3                   	ret    

00801af2 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801af2:	55                   	push   %ebp
  801af3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801af5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801af8:	8b 45 08             	mov    0x8(%ebp),%eax
  801afb:	6a 00                	push   $0x0
  801afd:	6a 00                	push   $0x0
  801aff:	6a 00                	push   $0x0
  801b01:	52                   	push   %edx
  801b02:	50                   	push   %eax
  801b03:	6a 2a                	push   $0x2a
  801b05:	e8 ca fa ff ff       	call   8015d4 <syscall>
  801b0a:	83 c4 18             	add    $0x18,%esp
	return;
  801b0d:	90                   	nop
}
  801b0e:	c9                   	leave  
  801b0f:	c3                   	ret    

00801b10 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801b10:	55                   	push   %ebp
  801b11:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801b13:	6a 00                	push   $0x0
  801b15:	6a 00                	push   $0x0
  801b17:	6a 00                	push   $0x0
  801b19:	6a 00                	push   $0x0
  801b1b:	6a 00                	push   $0x0
  801b1d:	6a 2b                	push   $0x2b
  801b1f:	e8 b0 fa ff ff       	call   8015d4 <syscall>
  801b24:	83 c4 18             	add    $0x18,%esp
}
  801b27:	c9                   	leave  
  801b28:	c3                   	ret    

00801b29 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b29:	55                   	push   %ebp
  801b2a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 00                	push   $0x0
  801b30:	6a 00                	push   $0x0
  801b32:	ff 75 0c             	pushl  0xc(%ebp)
  801b35:	ff 75 08             	pushl  0x8(%ebp)
  801b38:	6a 2d                	push   $0x2d
  801b3a:	e8 95 fa ff ff       	call   8015d4 <syscall>
  801b3f:	83 c4 18             	add    $0x18,%esp
	return;
  801b42:	90                   	nop
}
  801b43:	c9                   	leave  
  801b44:	c3                   	ret    

00801b45 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801b45:	55                   	push   %ebp
  801b46:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801b48:	6a 00                	push   $0x0
  801b4a:	6a 00                	push   $0x0
  801b4c:	6a 00                	push   $0x0
  801b4e:	ff 75 0c             	pushl  0xc(%ebp)
  801b51:	ff 75 08             	pushl  0x8(%ebp)
  801b54:	6a 2c                	push   $0x2c
  801b56:	e8 79 fa ff ff       	call   8015d4 <syscall>
  801b5b:	83 c4 18             	add    $0x18,%esp
	return ;
  801b5e:	90                   	nop
}
  801b5f:	c9                   	leave  
  801b60:	c3                   	ret    

00801b61 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801b61:	55                   	push   %ebp
  801b62:	89 e5                	mov    %esp,%ebp
  801b64:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801b67:	83 ec 04             	sub    $0x4,%esp
  801b6a:	68 c8 26 80 00       	push   $0x8026c8
  801b6f:	68 25 01 00 00       	push   $0x125
  801b74:	68 fb 26 80 00       	push   $0x8026fb
  801b79:	e8 a3 e8 ff ff       	call   800421 <_panic>
  801b7e:	66 90                	xchg   %ax,%ax

00801b80 <__udivdi3>:
  801b80:	55                   	push   %ebp
  801b81:	57                   	push   %edi
  801b82:	56                   	push   %esi
  801b83:	53                   	push   %ebx
  801b84:	83 ec 1c             	sub    $0x1c,%esp
  801b87:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801b8b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801b8f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b93:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b97:	89 ca                	mov    %ecx,%edx
  801b99:	89 f8                	mov    %edi,%eax
  801b9b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801b9f:	85 f6                	test   %esi,%esi
  801ba1:	75 2d                	jne    801bd0 <__udivdi3+0x50>
  801ba3:	39 cf                	cmp    %ecx,%edi
  801ba5:	77 65                	ja     801c0c <__udivdi3+0x8c>
  801ba7:	89 fd                	mov    %edi,%ebp
  801ba9:	85 ff                	test   %edi,%edi
  801bab:	75 0b                	jne    801bb8 <__udivdi3+0x38>
  801bad:	b8 01 00 00 00       	mov    $0x1,%eax
  801bb2:	31 d2                	xor    %edx,%edx
  801bb4:	f7 f7                	div    %edi
  801bb6:	89 c5                	mov    %eax,%ebp
  801bb8:	31 d2                	xor    %edx,%edx
  801bba:	89 c8                	mov    %ecx,%eax
  801bbc:	f7 f5                	div    %ebp
  801bbe:	89 c1                	mov    %eax,%ecx
  801bc0:	89 d8                	mov    %ebx,%eax
  801bc2:	f7 f5                	div    %ebp
  801bc4:	89 cf                	mov    %ecx,%edi
  801bc6:	89 fa                	mov    %edi,%edx
  801bc8:	83 c4 1c             	add    $0x1c,%esp
  801bcb:	5b                   	pop    %ebx
  801bcc:	5e                   	pop    %esi
  801bcd:	5f                   	pop    %edi
  801bce:	5d                   	pop    %ebp
  801bcf:	c3                   	ret    
  801bd0:	39 ce                	cmp    %ecx,%esi
  801bd2:	77 28                	ja     801bfc <__udivdi3+0x7c>
  801bd4:	0f bd fe             	bsr    %esi,%edi
  801bd7:	83 f7 1f             	xor    $0x1f,%edi
  801bda:	75 40                	jne    801c1c <__udivdi3+0x9c>
  801bdc:	39 ce                	cmp    %ecx,%esi
  801bde:	72 0a                	jb     801bea <__udivdi3+0x6a>
  801be0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801be4:	0f 87 9e 00 00 00    	ja     801c88 <__udivdi3+0x108>
  801bea:	b8 01 00 00 00       	mov    $0x1,%eax
  801bef:	89 fa                	mov    %edi,%edx
  801bf1:	83 c4 1c             	add    $0x1c,%esp
  801bf4:	5b                   	pop    %ebx
  801bf5:	5e                   	pop    %esi
  801bf6:	5f                   	pop    %edi
  801bf7:	5d                   	pop    %ebp
  801bf8:	c3                   	ret    
  801bf9:	8d 76 00             	lea    0x0(%esi),%esi
  801bfc:	31 ff                	xor    %edi,%edi
  801bfe:	31 c0                	xor    %eax,%eax
  801c00:	89 fa                	mov    %edi,%edx
  801c02:	83 c4 1c             	add    $0x1c,%esp
  801c05:	5b                   	pop    %ebx
  801c06:	5e                   	pop    %esi
  801c07:	5f                   	pop    %edi
  801c08:	5d                   	pop    %ebp
  801c09:	c3                   	ret    
  801c0a:	66 90                	xchg   %ax,%ax
  801c0c:	89 d8                	mov    %ebx,%eax
  801c0e:	f7 f7                	div    %edi
  801c10:	31 ff                	xor    %edi,%edi
  801c12:	89 fa                	mov    %edi,%edx
  801c14:	83 c4 1c             	add    $0x1c,%esp
  801c17:	5b                   	pop    %ebx
  801c18:	5e                   	pop    %esi
  801c19:	5f                   	pop    %edi
  801c1a:	5d                   	pop    %ebp
  801c1b:	c3                   	ret    
  801c1c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801c21:	89 eb                	mov    %ebp,%ebx
  801c23:	29 fb                	sub    %edi,%ebx
  801c25:	89 f9                	mov    %edi,%ecx
  801c27:	d3 e6                	shl    %cl,%esi
  801c29:	89 c5                	mov    %eax,%ebp
  801c2b:	88 d9                	mov    %bl,%cl
  801c2d:	d3 ed                	shr    %cl,%ebp
  801c2f:	89 e9                	mov    %ebp,%ecx
  801c31:	09 f1                	or     %esi,%ecx
  801c33:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801c37:	89 f9                	mov    %edi,%ecx
  801c39:	d3 e0                	shl    %cl,%eax
  801c3b:	89 c5                	mov    %eax,%ebp
  801c3d:	89 d6                	mov    %edx,%esi
  801c3f:	88 d9                	mov    %bl,%cl
  801c41:	d3 ee                	shr    %cl,%esi
  801c43:	89 f9                	mov    %edi,%ecx
  801c45:	d3 e2                	shl    %cl,%edx
  801c47:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c4b:	88 d9                	mov    %bl,%cl
  801c4d:	d3 e8                	shr    %cl,%eax
  801c4f:	09 c2                	or     %eax,%edx
  801c51:	89 d0                	mov    %edx,%eax
  801c53:	89 f2                	mov    %esi,%edx
  801c55:	f7 74 24 0c          	divl   0xc(%esp)
  801c59:	89 d6                	mov    %edx,%esi
  801c5b:	89 c3                	mov    %eax,%ebx
  801c5d:	f7 e5                	mul    %ebp
  801c5f:	39 d6                	cmp    %edx,%esi
  801c61:	72 19                	jb     801c7c <__udivdi3+0xfc>
  801c63:	74 0b                	je     801c70 <__udivdi3+0xf0>
  801c65:	89 d8                	mov    %ebx,%eax
  801c67:	31 ff                	xor    %edi,%edi
  801c69:	e9 58 ff ff ff       	jmp    801bc6 <__udivdi3+0x46>
  801c6e:	66 90                	xchg   %ax,%ax
  801c70:	8b 54 24 08          	mov    0x8(%esp),%edx
  801c74:	89 f9                	mov    %edi,%ecx
  801c76:	d3 e2                	shl    %cl,%edx
  801c78:	39 c2                	cmp    %eax,%edx
  801c7a:	73 e9                	jae    801c65 <__udivdi3+0xe5>
  801c7c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801c7f:	31 ff                	xor    %edi,%edi
  801c81:	e9 40 ff ff ff       	jmp    801bc6 <__udivdi3+0x46>
  801c86:	66 90                	xchg   %ax,%ax
  801c88:	31 c0                	xor    %eax,%eax
  801c8a:	e9 37 ff ff ff       	jmp    801bc6 <__udivdi3+0x46>
  801c8f:	90                   	nop

00801c90 <__umoddi3>:
  801c90:	55                   	push   %ebp
  801c91:	57                   	push   %edi
  801c92:	56                   	push   %esi
  801c93:	53                   	push   %ebx
  801c94:	83 ec 1c             	sub    $0x1c,%esp
  801c97:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801c9b:	8b 74 24 34          	mov    0x34(%esp),%esi
  801c9f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801ca3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801ca7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801cab:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801caf:	89 f3                	mov    %esi,%ebx
  801cb1:	89 fa                	mov    %edi,%edx
  801cb3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801cb7:	89 34 24             	mov    %esi,(%esp)
  801cba:	85 c0                	test   %eax,%eax
  801cbc:	75 1a                	jne    801cd8 <__umoddi3+0x48>
  801cbe:	39 f7                	cmp    %esi,%edi
  801cc0:	0f 86 a2 00 00 00    	jbe    801d68 <__umoddi3+0xd8>
  801cc6:	89 c8                	mov    %ecx,%eax
  801cc8:	89 f2                	mov    %esi,%edx
  801cca:	f7 f7                	div    %edi
  801ccc:	89 d0                	mov    %edx,%eax
  801cce:	31 d2                	xor    %edx,%edx
  801cd0:	83 c4 1c             	add    $0x1c,%esp
  801cd3:	5b                   	pop    %ebx
  801cd4:	5e                   	pop    %esi
  801cd5:	5f                   	pop    %edi
  801cd6:	5d                   	pop    %ebp
  801cd7:	c3                   	ret    
  801cd8:	39 f0                	cmp    %esi,%eax
  801cda:	0f 87 ac 00 00 00    	ja     801d8c <__umoddi3+0xfc>
  801ce0:	0f bd e8             	bsr    %eax,%ebp
  801ce3:	83 f5 1f             	xor    $0x1f,%ebp
  801ce6:	0f 84 ac 00 00 00    	je     801d98 <__umoddi3+0x108>
  801cec:	bf 20 00 00 00       	mov    $0x20,%edi
  801cf1:	29 ef                	sub    %ebp,%edi
  801cf3:	89 fe                	mov    %edi,%esi
  801cf5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801cf9:	89 e9                	mov    %ebp,%ecx
  801cfb:	d3 e0                	shl    %cl,%eax
  801cfd:	89 d7                	mov    %edx,%edi
  801cff:	89 f1                	mov    %esi,%ecx
  801d01:	d3 ef                	shr    %cl,%edi
  801d03:	09 c7                	or     %eax,%edi
  801d05:	89 e9                	mov    %ebp,%ecx
  801d07:	d3 e2                	shl    %cl,%edx
  801d09:	89 14 24             	mov    %edx,(%esp)
  801d0c:	89 d8                	mov    %ebx,%eax
  801d0e:	d3 e0                	shl    %cl,%eax
  801d10:	89 c2                	mov    %eax,%edx
  801d12:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d16:	d3 e0                	shl    %cl,%eax
  801d18:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d1c:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d20:	89 f1                	mov    %esi,%ecx
  801d22:	d3 e8                	shr    %cl,%eax
  801d24:	09 d0                	or     %edx,%eax
  801d26:	d3 eb                	shr    %cl,%ebx
  801d28:	89 da                	mov    %ebx,%edx
  801d2a:	f7 f7                	div    %edi
  801d2c:	89 d3                	mov    %edx,%ebx
  801d2e:	f7 24 24             	mull   (%esp)
  801d31:	89 c6                	mov    %eax,%esi
  801d33:	89 d1                	mov    %edx,%ecx
  801d35:	39 d3                	cmp    %edx,%ebx
  801d37:	0f 82 87 00 00 00    	jb     801dc4 <__umoddi3+0x134>
  801d3d:	0f 84 91 00 00 00    	je     801dd4 <__umoddi3+0x144>
  801d43:	8b 54 24 04          	mov    0x4(%esp),%edx
  801d47:	29 f2                	sub    %esi,%edx
  801d49:	19 cb                	sbb    %ecx,%ebx
  801d4b:	89 d8                	mov    %ebx,%eax
  801d4d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801d51:	d3 e0                	shl    %cl,%eax
  801d53:	89 e9                	mov    %ebp,%ecx
  801d55:	d3 ea                	shr    %cl,%edx
  801d57:	09 d0                	or     %edx,%eax
  801d59:	89 e9                	mov    %ebp,%ecx
  801d5b:	d3 eb                	shr    %cl,%ebx
  801d5d:	89 da                	mov    %ebx,%edx
  801d5f:	83 c4 1c             	add    $0x1c,%esp
  801d62:	5b                   	pop    %ebx
  801d63:	5e                   	pop    %esi
  801d64:	5f                   	pop    %edi
  801d65:	5d                   	pop    %ebp
  801d66:	c3                   	ret    
  801d67:	90                   	nop
  801d68:	89 fd                	mov    %edi,%ebp
  801d6a:	85 ff                	test   %edi,%edi
  801d6c:	75 0b                	jne    801d79 <__umoddi3+0xe9>
  801d6e:	b8 01 00 00 00       	mov    $0x1,%eax
  801d73:	31 d2                	xor    %edx,%edx
  801d75:	f7 f7                	div    %edi
  801d77:	89 c5                	mov    %eax,%ebp
  801d79:	89 f0                	mov    %esi,%eax
  801d7b:	31 d2                	xor    %edx,%edx
  801d7d:	f7 f5                	div    %ebp
  801d7f:	89 c8                	mov    %ecx,%eax
  801d81:	f7 f5                	div    %ebp
  801d83:	89 d0                	mov    %edx,%eax
  801d85:	e9 44 ff ff ff       	jmp    801cce <__umoddi3+0x3e>
  801d8a:	66 90                	xchg   %ax,%ax
  801d8c:	89 c8                	mov    %ecx,%eax
  801d8e:	89 f2                	mov    %esi,%edx
  801d90:	83 c4 1c             	add    $0x1c,%esp
  801d93:	5b                   	pop    %ebx
  801d94:	5e                   	pop    %esi
  801d95:	5f                   	pop    %edi
  801d96:	5d                   	pop    %ebp
  801d97:	c3                   	ret    
  801d98:	3b 04 24             	cmp    (%esp),%eax
  801d9b:	72 06                	jb     801da3 <__umoddi3+0x113>
  801d9d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801da1:	77 0f                	ja     801db2 <__umoddi3+0x122>
  801da3:	89 f2                	mov    %esi,%edx
  801da5:	29 f9                	sub    %edi,%ecx
  801da7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801dab:	89 14 24             	mov    %edx,(%esp)
  801dae:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801db2:	8b 44 24 04          	mov    0x4(%esp),%eax
  801db6:	8b 14 24             	mov    (%esp),%edx
  801db9:	83 c4 1c             	add    $0x1c,%esp
  801dbc:	5b                   	pop    %ebx
  801dbd:	5e                   	pop    %esi
  801dbe:	5f                   	pop    %edi
  801dbf:	5d                   	pop    %ebp
  801dc0:	c3                   	ret    
  801dc1:	8d 76 00             	lea    0x0(%esi),%esi
  801dc4:	2b 04 24             	sub    (%esp),%eax
  801dc7:	19 fa                	sbb    %edi,%edx
  801dc9:	89 d1                	mov    %edx,%ecx
  801dcb:	89 c6                	mov    %eax,%esi
  801dcd:	e9 71 ff ff ff       	jmp    801d43 <__umoddi3+0xb3>
  801dd2:	66 90                	xchg   %ax,%ax
  801dd4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801dd8:	72 ea                	jb     801dc4 <__umoddi3+0x134>
  801dda:	89 d9                	mov    %ebx,%ecx
  801ddc:	e9 62 ff ff ff       	jmp    801d43 <__umoddi3+0xb3>

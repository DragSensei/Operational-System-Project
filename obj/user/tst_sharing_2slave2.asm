
obj/user/tst_sharing_2slave2:     file format elf32-i386


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
  800031:	e8 23 02 00 00       	call   800259 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Slave program2: Get 2 shared variables, edit the writable one, and attempt to edit the readOnly one
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 24             	sub    $0x24,%esp
	/*=================================================*/
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
#if USE_KHEAP
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  80003f:	a1 20 30 80 00       	mov    0x803020,%eax
  800044:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
  80004a:	a1 20 30 80 00       	mov    0x803020,%eax
  80004f:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800055:	39 c2                	cmp    %eax,%edx
  800057:	72 14                	jb     80006d <_main+0x35>
			panic("Please increase the WS size");
  800059:	83 ec 04             	sub    $0x4,%esp
  80005c:	68 e0 20 80 00       	push   $0x8020e0
  800061:	6a 0d                	push   $0xd
  800063:	68 fc 20 80 00       	push   $0x8020fc
  800068:	e8 9c 03 00 00       	call   800409 <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  80006d:	c7 45 f4 00 10 00 82 	movl   $0x82001000,-0xc(%ebp)


	int32 parentenvID = sys_getparentenvid();
  800074:	e8 fb 19 00 00       	call   801a74 <sys_getparentenvid>
  800079:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int freeFrames, diff, expected;

	//GET: z then x, opposite to creation order (x then y then z)
	//So, addresses here will be different from the OWNER addresses
	//sys_lock_cons();
	sys_lock_cons();
  80007c:	e8 61 17 00 00       	call   8017e2 <sys_lock_cons>
	{
		freeFrames = sys_calculate_free_frames() ;
  800081:	e8 0c 18 00 00       	call   801892 <sys_calculate_free_frames>
  800086:	89 45 ec             	mov    %eax,-0x14(%ebp)
		z = sget(parentenvID,"z");
  800089:	83 ec 08             	sub    $0x8,%esp
  80008c:	68 17 21 80 00       	push   $0x802117
  800091:	ff 75 f0             	pushl  -0x10(%ebp)
  800094:	e8 7c 16 00 00       	call   801715 <sget>
  800099:	83 c4 10             	add    $0x10,%esp
  80009c:	89 45 e8             	mov    %eax,-0x18(%ebp)
		expectedVA = (uint32*)(pagealloc_start + 0 * PAGE_SIZE);
  80009f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (z != expectedVA) panic("Get(): Returned address is not correct. Expected = %x, Actual = %x\nMake sure that you align the allocation on 4KB boundary", expectedVA, z);
  8000a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000a8:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8000ab:	74 1a                	je     8000c7 <_main+0x8f>
  8000ad:	83 ec 0c             	sub    $0xc,%esp
  8000b0:	ff 75 e8             	pushl  -0x18(%ebp)
  8000b3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000b6:	68 1c 21 80 00       	push   $0x80211c
  8000bb:	6a 23                	push   $0x23
  8000bd:	68 fc 20 80 00       	push   $0x8020fc
  8000c2:	e8 42 03 00 00       	call   800409 <_panic>
		expected = 1 ; /*1table*/
  8000c7:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8000ce:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000d1:	e8 bc 17 00 00       	call   801892 <sys_calculate_free_frames>
  8000d6:	29 c3                	sub    %eax,%ebx
  8000d8:	89 d8                	mov    %ebx,%eax
  8000da:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (diff != expected) panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  8000dd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8000e0:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8000e3:	74 24                	je     800109 <_main+0xd1>
  8000e5:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000e8:	e8 a5 17 00 00       	call   801892 <sys_calculate_free_frames>
  8000ed:	29 c3                	sub    %eax,%ebx
  8000ef:	89 d8                	mov    %ebx,%eax
  8000f1:	83 ec 0c             	sub    $0xc,%esp
  8000f4:	ff 75 e0             	pushl  -0x20(%ebp)
  8000f7:	50                   	push   %eax
  8000f8:	68 98 21 80 00       	push   $0x802198
  8000fd:	6a 26                	push   $0x26
  8000ff:	68 fc 20 80 00       	push   $0x8020fc
  800104:	e8 00 03 00 00       	call   800409 <_panic>
	}
	sys_unlock_cons();
  800109:	e8 ee 16 00 00       	call   8017fc <sys_unlock_cons>
	//sys_unlock_cons();

	//sys_lock_cons();
	sys_lock_cons();
  80010e:	e8 cf 16 00 00       	call   8017e2 <sys_lock_cons>
	{
		freeFrames = sys_calculate_free_frames() ;
  800113:	e8 7a 17 00 00       	call   801892 <sys_calculate_free_frames>
  800118:	89 45 ec             	mov    %eax,-0x14(%ebp)
		x = sget(parentenvID,"x");
  80011b:	83 ec 08             	sub    $0x8,%esp
  80011e:	68 30 22 80 00       	push   $0x802230
  800123:	ff 75 f0             	pushl  -0x10(%ebp)
  800126:	e8 ea 15 00 00       	call   801715 <sget>
  80012b:	83 c4 10             	add    $0x10,%esp
  80012e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		expectedVA = (uint32*)(pagealloc_start + 1 * PAGE_SIZE);
  800131:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800134:	05 00 10 00 00       	add    $0x1000,%eax
  800139:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (x != expectedVA) panic("Get(): Returned address is not correct. Expected = %x, Actual = %x\nMake sure that you align the allocation on 4KB boundary", expectedVA, x);
  80013c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80013f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800142:	74 1a                	je     80015e <_main+0x126>
  800144:	83 ec 0c             	sub    $0xc,%esp
  800147:	ff 75 d8             	pushl  -0x28(%ebp)
  80014a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80014d:	68 1c 21 80 00       	push   $0x80211c
  800152:	6a 31                	push   $0x31
  800154:	68 fc 20 80 00       	push   $0x8020fc
  800159:	e8 ab 02 00 00       	call   800409 <_panic>
		expected = 0;
  80015e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800165:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800168:	e8 25 17 00 00       	call   801892 <sys_calculate_free_frames>
  80016d:	29 c3                	sub    %eax,%ebx
  80016f:	89 d8                	mov    %ebx,%eax
  800171:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (diff != expected) panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  800174:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800177:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80017a:	74 24                	je     8001a0 <_main+0x168>
  80017c:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  80017f:	e8 0e 17 00 00       	call   801892 <sys_calculate_free_frames>
  800184:	29 c3                	sub    %eax,%ebx
  800186:	89 d8                	mov    %ebx,%eax
  800188:	83 ec 0c             	sub    $0xc,%esp
  80018b:	ff 75 e0             	pushl  -0x20(%ebp)
  80018e:	50                   	push   %eax
  80018f:	68 98 21 80 00       	push   $0x802198
  800194:	6a 34                	push   $0x34
  800196:	68 fc 20 80 00       	push   $0x8020fc
  80019b:	e8 69 02 00 00       	call   800409 <_panic>
	}
	sys_unlock_cons();
  8001a0:	e8 57 16 00 00       	call   8017fc <sys_unlock_cons>
	//sys_unlock_cons();

	if (*x != 10) panic("Get(): Shared Variable is not created or got correctly") ;
  8001a5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8001a8:	8b 00                	mov    (%eax),%eax
  8001aa:	83 f8 0a             	cmp    $0xa,%eax
  8001ad:	74 14                	je     8001c3 <_main+0x18b>
  8001af:	83 ec 04             	sub    $0x4,%esp
  8001b2:	68 34 22 80 00       	push   $0x802234
  8001b7:	6a 39                	push   $0x39
  8001b9:	68 fc 20 80 00       	push   $0x8020fc
  8001be:	e8 46 02 00 00       	call   800409 <_panic>

	//Edit the writable object
	*z = 50;
  8001c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001c6:	c7 00 32 00 00 00    	movl   $0x32,(%eax)
	if (*z != 50) panic("Get(): Shared Variable is not created or got correctly") ;
  8001cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001cf:	8b 00                	mov    (%eax),%eax
  8001d1:	83 f8 32             	cmp    $0x32,%eax
  8001d4:	74 14                	je     8001ea <_main+0x1b2>
  8001d6:	83 ec 04             	sub    $0x4,%esp
  8001d9:	68 34 22 80 00       	push   $0x802234
  8001de:	6a 3d                	push   $0x3d
  8001e0:	68 fc 20 80 00       	push   $0x8020fc
  8001e5:	e8 1f 02 00 00       	call   800409 <_panic>

	inctst();
  8001ea:	e8 aa 19 00 00       	call   801b99 <inctst>

	//sync with master
	while (gettst() != 5) ;
  8001ef:	90                   	nop
  8001f0:	e8 be 19 00 00       	call   801bb3 <gettst>
  8001f5:	83 f8 05             	cmp    $0x5,%eax
  8001f8:	75 f6                	jne    8001f0 <_main+0x1b8>

	//Attempt to edit the ReadOnly object, it should panic
	sys_bypassPageFault(6);
  8001fa:	83 ec 0c             	sub    $0xc,%esp
  8001fd:	6a 06                	push   $0x6
  8001ff:	e8 0f 19 00 00       	call   801b13 <sys_bypassPageFault>
  800204:	83 c4 10             	add    $0x10,%esp
	cprintf("Attempt to edit the ReadOnly object @ va = %x\n", x);
  800207:	83 ec 08             	sub    $0x8,%esp
  80020a:	ff 75 d8             	pushl  -0x28(%ebp)
  80020d:	68 6c 22 80 00       	push   $0x80226c
  800212:	e8 c0 04 00 00       	call   8006d7 <cprintf>
  800217:	83 c4 10             	add    $0x10,%esp
	*x = 100;
  80021a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80021d:	c7 00 64 00 00 00    	movl   $0x64,(%eax)

	sys_bypassPageFault(0);
  800223:	83 ec 0c             	sub    $0xc,%esp
  800226:	6a 00                	push   $0x0
  800228:	e8 e6 18 00 00       	call   801b13 <sys_bypassPageFault>
  80022d:	83 c4 10             	add    $0x10,%esp

	inctst();
  800230:	e8 64 19 00 00       	call   801b99 <inctst>
	if (*x == 100)
  800235:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800238:	8b 00                	mov    (%eax),%eax
  80023a:	83 f8 64             	cmp    $0x64,%eax
  80023d:	75 14                	jne    800253 <_main+0x21b>
		panic("Test FAILED! it should not edit the variable x since it's a read-only!") ;
  80023f:	83 ec 04             	sub    $0x4,%esp
  800242:	68 9c 22 80 00       	push   $0x80229c
  800247:	6a 4d                	push   $0x4d
  800249:	68 fc 20 80 00       	push   $0x8020fc
  80024e:	e8 b6 01 00 00       	call   800409 <_panic>
	return;
  800253:	90                   	nop
}
  800254:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800257:	c9                   	leave  
  800258:	c3                   	ret    

00800259 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800259:	55                   	push   %ebp
  80025a:	89 e5                	mov    %esp,%ebp
  80025c:	57                   	push   %edi
  80025d:	56                   	push   %esi
  80025e:	53                   	push   %ebx
  80025f:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800262:	e8 f4 17 00 00       	call   801a5b <sys_getenvindex>
  800267:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  80026a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80026d:	89 d0                	mov    %edx,%eax
  80026f:	c1 e0 02             	shl    $0x2,%eax
  800272:	01 d0                	add    %edx,%eax
  800274:	c1 e0 03             	shl    $0x3,%eax
  800277:	01 d0                	add    %edx,%eax
  800279:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800280:	01 d0                	add    %edx,%eax
  800282:	c1 e0 02             	shl    $0x2,%eax
  800285:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80028a:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80028f:	a1 20 30 80 00       	mov    0x803020,%eax
  800294:	8a 40 20             	mov    0x20(%eax),%al
  800297:	84 c0                	test   %al,%al
  800299:	74 0d                	je     8002a8 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  80029b:	a1 20 30 80 00       	mov    0x803020,%eax
  8002a0:	83 c0 20             	add    $0x20,%eax
  8002a3:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002a8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8002ac:	7e 0a                	jle    8002b8 <libmain+0x5f>
		binaryname = argv[0];
  8002ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002b1:	8b 00                	mov    (%eax),%eax
  8002b3:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  8002b8:	83 ec 08             	sub    $0x8,%esp
  8002bb:	ff 75 0c             	pushl  0xc(%ebp)
  8002be:	ff 75 08             	pushl  0x8(%ebp)
  8002c1:	e8 72 fd ff ff       	call   800038 <_main>
  8002c6:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8002c9:	a1 00 30 80 00       	mov    0x803000,%eax
  8002ce:	85 c0                	test   %eax,%eax
  8002d0:	0f 84 01 01 00 00    	je     8003d7 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8002d6:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8002dc:	bb dc 23 80 00       	mov    $0x8023dc,%ebx
  8002e1:	ba 0e 00 00 00       	mov    $0xe,%edx
  8002e6:	89 c7                	mov    %eax,%edi
  8002e8:	89 de                	mov    %ebx,%esi
  8002ea:	89 d1                	mov    %edx,%ecx
  8002ec:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8002ee:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8002f1:	b9 56 00 00 00       	mov    $0x56,%ecx
  8002f6:	b0 00                	mov    $0x0,%al
  8002f8:	89 d7                	mov    %edx,%edi
  8002fa:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8002fc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800303:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800306:	83 ec 08             	sub    $0x8,%esp
  800309:	50                   	push   %eax
  80030a:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800310:	50                   	push   %eax
  800311:	e8 7b 19 00 00       	call   801c91 <sys_utilities>
  800316:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800319:	e8 c4 14 00 00       	call   8017e2 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80031e:	83 ec 0c             	sub    $0xc,%esp
  800321:	68 fc 22 80 00       	push   $0x8022fc
  800326:	e8 ac 03 00 00       	call   8006d7 <cprintf>
  80032b:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80032e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800331:	85 c0                	test   %eax,%eax
  800333:	74 18                	je     80034d <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800335:	e8 75 19 00 00       	call   801caf <sys_get_optimal_num_faults>
  80033a:	83 ec 08             	sub    $0x8,%esp
  80033d:	50                   	push   %eax
  80033e:	68 24 23 80 00       	push   $0x802324
  800343:	e8 8f 03 00 00       	call   8006d7 <cprintf>
  800348:	83 c4 10             	add    $0x10,%esp
  80034b:	eb 59                	jmp    8003a6 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80034d:	a1 20 30 80 00       	mov    0x803020,%eax
  800352:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  800358:	a1 20 30 80 00       	mov    0x803020,%eax
  80035d:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  800363:	83 ec 04             	sub    $0x4,%esp
  800366:	52                   	push   %edx
  800367:	50                   	push   %eax
  800368:	68 48 23 80 00       	push   $0x802348
  80036d:	e8 65 03 00 00       	call   8006d7 <cprintf>
  800372:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800375:	a1 20 30 80 00       	mov    0x803020,%eax
  80037a:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800380:	a1 20 30 80 00       	mov    0x803020,%eax
  800385:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  80038b:	a1 20 30 80 00       	mov    0x803020,%eax
  800390:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  800396:	51                   	push   %ecx
  800397:	52                   	push   %edx
  800398:	50                   	push   %eax
  800399:	68 70 23 80 00       	push   $0x802370
  80039e:	e8 34 03 00 00       	call   8006d7 <cprintf>
  8003a3:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8003a6:	a1 20 30 80 00       	mov    0x803020,%eax
  8003ab:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  8003b1:	83 ec 08             	sub    $0x8,%esp
  8003b4:	50                   	push   %eax
  8003b5:	68 c8 23 80 00       	push   $0x8023c8
  8003ba:	e8 18 03 00 00       	call   8006d7 <cprintf>
  8003bf:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8003c2:	83 ec 0c             	sub    $0xc,%esp
  8003c5:	68 fc 22 80 00       	push   $0x8022fc
  8003ca:	e8 08 03 00 00       	call   8006d7 <cprintf>
  8003cf:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8003d2:	e8 25 14 00 00       	call   8017fc <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8003d7:	e8 1f 00 00 00       	call   8003fb <exit>
}
  8003dc:	90                   	nop
  8003dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003e0:	5b                   	pop    %ebx
  8003e1:	5e                   	pop    %esi
  8003e2:	5f                   	pop    %edi
  8003e3:	5d                   	pop    %ebp
  8003e4:	c3                   	ret    

008003e5 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8003e5:	55                   	push   %ebp
  8003e6:	89 e5                	mov    %esp,%ebp
  8003e8:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8003eb:	83 ec 0c             	sub    $0xc,%esp
  8003ee:	6a 00                	push   $0x0
  8003f0:	e8 32 16 00 00       	call   801a27 <sys_destroy_env>
  8003f5:	83 c4 10             	add    $0x10,%esp
}
  8003f8:	90                   	nop
  8003f9:	c9                   	leave  
  8003fa:	c3                   	ret    

008003fb <exit>:

void
exit(void)
{
  8003fb:	55                   	push   %ebp
  8003fc:	89 e5                	mov    %esp,%ebp
  8003fe:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800401:	e8 87 16 00 00       	call   801a8d <sys_exit_env>
}
  800406:	90                   	nop
  800407:	c9                   	leave  
  800408:	c3                   	ret    

00800409 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800409:	55                   	push   %ebp
  80040a:	89 e5                	mov    %esp,%ebp
  80040c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80040f:	8d 45 10             	lea    0x10(%ebp),%eax
  800412:	83 c0 04             	add    $0x4,%eax
  800415:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800418:	a1 18 b1 81 00       	mov    0x81b118,%eax
  80041d:	85 c0                	test   %eax,%eax
  80041f:	74 16                	je     800437 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800421:	a1 18 b1 81 00       	mov    0x81b118,%eax
  800426:	83 ec 08             	sub    $0x8,%esp
  800429:	50                   	push   %eax
  80042a:	68 40 24 80 00       	push   $0x802440
  80042f:	e8 a3 02 00 00       	call   8006d7 <cprintf>
  800434:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800437:	a1 04 30 80 00       	mov    0x803004,%eax
  80043c:	83 ec 0c             	sub    $0xc,%esp
  80043f:	ff 75 0c             	pushl  0xc(%ebp)
  800442:	ff 75 08             	pushl  0x8(%ebp)
  800445:	50                   	push   %eax
  800446:	68 48 24 80 00       	push   $0x802448
  80044b:	6a 74                	push   $0x74
  80044d:	e8 b2 02 00 00       	call   800704 <cprintf_colored>
  800452:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800455:	8b 45 10             	mov    0x10(%ebp),%eax
  800458:	83 ec 08             	sub    $0x8,%esp
  80045b:	ff 75 f4             	pushl  -0xc(%ebp)
  80045e:	50                   	push   %eax
  80045f:	e8 04 02 00 00       	call   800668 <vcprintf>
  800464:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800467:	83 ec 08             	sub    $0x8,%esp
  80046a:	6a 00                	push   $0x0
  80046c:	68 70 24 80 00       	push   $0x802470
  800471:	e8 f2 01 00 00       	call   800668 <vcprintf>
  800476:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800479:	e8 7d ff ff ff       	call   8003fb <exit>

	// should not return here
	while (1) ;
  80047e:	eb fe                	jmp    80047e <_panic+0x75>

00800480 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800480:	55                   	push   %ebp
  800481:	89 e5                	mov    %esp,%ebp
  800483:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800486:	a1 20 30 80 00       	mov    0x803020,%eax
  80048b:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800491:	8b 45 0c             	mov    0xc(%ebp),%eax
  800494:	39 c2                	cmp    %eax,%edx
  800496:	74 14                	je     8004ac <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800498:	83 ec 04             	sub    $0x4,%esp
  80049b:	68 74 24 80 00       	push   $0x802474
  8004a0:	6a 26                	push   $0x26
  8004a2:	68 c0 24 80 00       	push   $0x8024c0
  8004a7:	e8 5d ff ff ff       	call   800409 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8004ac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8004b3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004ba:	e9 c5 00 00 00       	jmp    800584 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8004bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004c2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8004cc:	01 d0                	add    %edx,%eax
  8004ce:	8b 00                	mov    (%eax),%eax
  8004d0:	85 c0                	test   %eax,%eax
  8004d2:	75 08                	jne    8004dc <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8004d4:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8004d7:	e9 a5 00 00 00       	jmp    800581 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8004dc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004e3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8004ea:	eb 69                	jmp    800555 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8004ec:	a1 20 30 80 00       	mov    0x803020,%eax
  8004f1:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8004f7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004fa:	89 d0                	mov    %edx,%eax
  8004fc:	01 c0                	add    %eax,%eax
  8004fe:	01 d0                	add    %edx,%eax
  800500:	c1 e0 03             	shl    $0x3,%eax
  800503:	01 c8                	add    %ecx,%eax
  800505:	8a 40 04             	mov    0x4(%eax),%al
  800508:	84 c0                	test   %al,%al
  80050a:	75 46                	jne    800552 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80050c:	a1 20 30 80 00       	mov    0x803020,%eax
  800511:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800517:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80051a:	89 d0                	mov    %edx,%eax
  80051c:	01 c0                	add    %eax,%eax
  80051e:	01 d0                	add    %edx,%eax
  800520:	c1 e0 03             	shl    $0x3,%eax
  800523:	01 c8                	add    %ecx,%eax
  800525:	8b 00                	mov    (%eax),%eax
  800527:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80052a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80052d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800532:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800534:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800537:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80053e:	8b 45 08             	mov    0x8(%ebp),%eax
  800541:	01 c8                	add    %ecx,%eax
  800543:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800545:	39 c2                	cmp    %eax,%edx
  800547:	75 09                	jne    800552 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800549:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800550:	eb 15                	jmp    800567 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800552:	ff 45 e8             	incl   -0x18(%ebp)
  800555:	a1 20 30 80 00       	mov    0x803020,%eax
  80055a:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800560:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800563:	39 c2                	cmp    %eax,%edx
  800565:	77 85                	ja     8004ec <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800567:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80056b:	75 14                	jne    800581 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80056d:	83 ec 04             	sub    $0x4,%esp
  800570:	68 cc 24 80 00       	push   $0x8024cc
  800575:	6a 3a                	push   $0x3a
  800577:	68 c0 24 80 00       	push   $0x8024c0
  80057c:	e8 88 fe ff ff       	call   800409 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800581:	ff 45 f0             	incl   -0x10(%ebp)
  800584:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800587:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80058a:	0f 8c 2f ff ff ff    	jl     8004bf <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800590:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800597:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80059e:	eb 26                	jmp    8005c6 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8005a0:	a1 20 30 80 00       	mov    0x803020,%eax
  8005a5:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8005ab:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005ae:	89 d0                	mov    %edx,%eax
  8005b0:	01 c0                	add    %eax,%eax
  8005b2:	01 d0                	add    %edx,%eax
  8005b4:	c1 e0 03             	shl    $0x3,%eax
  8005b7:	01 c8                	add    %ecx,%eax
  8005b9:	8a 40 04             	mov    0x4(%eax),%al
  8005bc:	3c 01                	cmp    $0x1,%al
  8005be:	75 03                	jne    8005c3 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8005c0:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005c3:	ff 45 e0             	incl   -0x20(%ebp)
  8005c6:	a1 20 30 80 00       	mov    0x803020,%eax
  8005cb:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005d4:	39 c2                	cmp    %eax,%edx
  8005d6:	77 c8                	ja     8005a0 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8005d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005db:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8005de:	74 14                	je     8005f4 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8005e0:	83 ec 04             	sub    $0x4,%esp
  8005e3:	68 20 25 80 00       	push   $0x802520
  8005e8:	6a 44                	push   $0x44
  8005ea:	68 c0 24 80 00       	push   $0x8024c0
  8005ef:	e8 15 fe ff ff       	call   800409 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8005f4:	90                   	nop
  8005f5:	c9                   	leave  
  8005f6:	c3                   	ret    

008005f7 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8005f7:	55                   	push   %ebp
  8005f8:	89 e5                	mov    %esp,%ebp
  8005fa:	53                   	push   %ebx
  8005fb:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8005fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800601:	8b 00                	mov    (%eax),%eax
  800603:	8d 48 01             	lea    0x1(%eax),%ecx
  800606:	8b 55 0c             	mov    0xc(%ebp),%edx
  800609:	89 0a                	mov    %ecx,(%edx)
  80060b:	8b 55 08             	mov    0x8(%ebp),%edx
  80060e:	88 d1                	mov    %dl,%cl
  800610:	8b 55 0c             	mov    0xc(%ebp),%edx
  800613:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800617:	8b 45 0c             	mov    0xc(%ebp),%eax
  80061a:	8b 00                	mov    (%eax),%eax
  80061c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800621:	75 30                	jne    800653 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800623:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  800629:	a0 44 30 80 00       	mov    0x803044,%al
  80062e:	0f b6 c0             	movzbl %al,%eax
  800631:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800634:	8b 09                	mov    (%ecx),%ecx
  800636:	89 cb                	mov    %ecx,%ebx
  800638:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80063b:	83 c1 08             	add    $0x8,%ecx
  80063e:	52                   	push   %edx
  80063f:	50                   	push   %eax
  800640:	53                   	push   %ebx
  800641:	51                   	push   %ecx
  800642:	e8 57 11 00 00       	call   80179e <sys_cputs>
  800647:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80064a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80064d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800653:	8b 45 0c             	mov    0xc(%ebp),%eax
  800656:	8b 40 04             	mov    0x4(%eax),%eax
  800659:	8d 50 01             	lea    0x1(%eax),%edx
  80065c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80065f:	89 50 04             	mov    %edx,0x4(%eax)
}
  800662:	90                   	nop
  800663:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800666:	c9                   	leave  
  800667:	c3                   	ret    

00800668 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800668:	55                   	push   %ebp
  800669:	89 e5                	mov    %esp,%ebp
  80066b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800671:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800678:	00 00 00 
	b.cnt = 0;
  80067b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800682:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800685:	ff 75 0c             	pushl  0xc(%ebp)
  800688:	ff 75 08             	pushl  0x8(%ebp)
  80068b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800691:	50                   	push   %eax
  800692:	68 f7 05 80 00       	push   $0x8005f7
  800697:	e8 5a 02 00 00       	call   8008f6 <vprintfmt>
  80069c:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  80069f:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  8006a5:	a0 44 30 80 00       	mov    0x803044,%al
  8006aa:	0f b6 c0             	movzbl %al,%eax
  8006ad:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8006b3:	52                   	push   %edx
  8006b4:	50                   	push   %eax
  8006b5:	51                   	push   %ecx
  8006b6:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006bc:	83 c0 08             	add    $0x8,%eax
  8006bf:	50                   	push   %eax
  8006c0:	e8 d9 10 00 00       	call   80179e <sys_cputs>
  8006c5:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8006c8:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  8006cf:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8006d5:	c9                   	leave  
  8006d6:	c3                   	ret    

008006d7 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8006d7:	55                   	push   %ebp
  8006d8:	89 e5                	mov    %esp,%ebp
  8006da:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8006dd:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  8006e4:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ed:	83 ec 08             	sub    $0x8,%esp
  8006f0:	ff 75 f4             	pushl  -0xc(%ebp)
  8006f3:	50                   	push   %eax
  8006f4:	e8 6f ff ff ff       	call   800668 <vcprintf>
  8006f9:	83 c4 10             	add    $0x10,%esp
  8006fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8006ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800702:	c9                   	leave  
  800703:	c3                   	ret    

00800704 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800704:	55                   	push   %ebp
  800705:	89 e5                	mov    %esp,%ebp
  800707:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80070a:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800711:	8b 45 08             	mov    0x8(%ebp),%eax
  800714:	c1 e0 08             	shl    $0x8,%eax
  800717:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  80071c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80071f:	83 c0 04             	add    $0x4,%eax
  800722:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800725:	8b 45 0c             	mov    0xc(%ebp),%eax
  800728:	83 ec 08             	sub    $0x8,%esp
  80072b:	ff 75 f4             	pushl  -0xc(%ebp)
  80072e:	50                   	push   %eax
  80072f:	e8 34 ff ff ff       	call   800668 <vcprintf>
  800734:	83 c4 10             	add    $0x10,%esp
  800737:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  80073a:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  800741:	07 00 00 

	return cnt;
  800744:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800747:	c9                   	leave  
  800748:	c3                   	ret    

00800749 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800749:	55                   	push   %ebp
  80074a:	89 e5                	mov    %esp,%ebp
  80074c:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80074f:	e8 8e 10 00 00       	call   8017e2 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800754:	8d 45 0c             	lea    0xc(%ebp),%eax
  800757:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80075a:	8b 45 08             	mov    0x8(%ebp),%eax
  80075d:	83 ec 08             	sub    $0x8,%esp
  800760:	ff 75 f4             	pushl  -0xc(%ebp)
  800763:	50                   	push   %eax
  800764:	e8 ff fe ff ff       	call   800668 <vcprintf>
  800769:	83 c4 10             	add    $0x10,%esp
  80076c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80076f:	e8 88 10 00 00       	call   8017fc <sys_unlock_cons>
	return cnt;
  800774:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800777:	c9                   	leave  
  800778:	c3                   	ret    

00800779 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800779:	55                   	push   %ebp
  80077a:	89 e5                	mov    %esp,%ebp
  80077c:	53                   	push   %ebx
  80077d:	83 ec 14             	sub    $0x14,%esp
  800780:	8b 45 10             	mov    0x10(%ebp),%eax
  800783:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800786:	8b 45 14             	mov    0x14(%ebp),%eax
  800789:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80078c:	8b 45 18             	mov    0x18(%ebp),%eax
  80078f:	ba 00 00 00 00       	mov    $0x0,%edx
  800794:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800797:	77 55                	ja     8007ee <printnum+0x75>
  800799:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80079c:	72 05                	jb     8007a3 <printnum+0x2a>
  80079e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8007a1:	77 4b                	ja     8007ee <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007a3:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8007a6:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8007a9:	8b 45 18             	mov    0x18(%ebp),%eax
  8007ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8007b1:	52                   	push   %edx
  8007b2:	50                   	push   %eax
  8007b3:	ff 75 f4             	pushl  -0xc(%ebp)
  8007b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8007b9:	e8 aa 16 00 00       	call   801e68 <__udivdi3>
  8007be:	83 c4 10             	add    $0x10,%esp
  8007c1:	83 ec 04             	sub    $0x4,%esp
  8007c4:	ff 75 20             	pushl  0x20(%ebp)
  8007c7:	53                   	push   %ebx
  8007c8:	ff 75 18             	pushl  0x18(%ebp)
  8007cb:	52                   	push   %edx
  8007cc:	50                   	push   %eax
  8007cd:	ff 75 0c             	pushl  0xc(%ebp)
  8007d0:	ff 75 08             	pushl  0x8(%ebp)
  8007d3:	e8 a1 ff ff ff       	call   800779 <printnum>
  8007d8:	83 c4 20             	add    $0x20,%esp
  8007db:	eb 1a                	jmp    8007f7 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8007dd:	83 ec 08             	sub    $0x8,%esp
  8007e0:	ff 75 0c             	pushl  0xc(%ebp)
  8007e3:	ff 75 20             	pushl  0x20(%ebp)
  8007e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e9:	ff d0                	call   *%eax
  8007eb:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8007ee:	ff 4d 1c             	decl   0x1c(%ebp)
  8007f1:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8007f5:	7f e6                	jg     8007dd <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8007f7:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8007fa:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800802:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800805:	53                   	push   %ebx
  800806:	51                   	push   %ecx
  800807:	52                   	push   %edx
  800808:	50                   	push   %eax
  800809:	e8 6a 17 00 00       	call   801f78 <__umoddi3>
  80080e:	83 c4 10             	add    $0x10,%esp
  800811:	05 94 27 80 00       	add    $0x802794,%eax
  800816:	8a 00                	mov    (%eax),%al
  800818:	0f be c0             	movsbl %al,%eax
  80081b:	83 ec 08             	sub    $0x8,%esp
  80081e:	ff 75 0c             	pushl  0xc(%ebp)
  800821:	50                   	push   %eax
  800822:	8b 45 08             	mov    0x8(%ebp),%eax
  800825:	ff d0                	call   *%eax
  800827:	83 c4 10             	add    $0x10,%esp
}
  80082a:	90                   	nop
  80082b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80082e:	c9                   	leave  
  80082f:	c3                   	ret    

00800830 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800830:	55                   	push   %ebp
  800831:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800833:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800837:	7e 1c                	jle    800855 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800839:	8b 45 08             	mov    0x8(%ebp),%eax
  80083c:	8b 00                	mov    (%eax),%eax
  80083e:	8d 50 08             	lea    0x8(%eax),%edx
  800841:	8b 45 08             	mov    0x8(%ebp),%eax
  800844:	89 10                	mov    %edx,(%eax)
  800846:	8b 45 08             	mov    0x8(%ebp),%eax
  800849:	8b 00                	mov    (%eax),%eax
  80084b:	83 e8 08             	sub    $0x8,%eax
  80084e:	8b 50 04             	mov    0x4(%eax),%edx
  800851:	8b 00                	mov    (%eax),%eax
  800853:	eb 40                	jmp    800895 <getuint+0x65>
	else if (lflag)
  800855:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800859:	74 1e                	je     800879 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80085b:	8b 45 08             	mov    0x8(%ebp),%eax
  80085e:	8b 00                	mov    (%eax),%eax
  800860:	8d 50 04             	lea    0x4(%eax),%edx
  800863:	8b 45 08             	mov    0x8(%ebp),%eax
  800866:	89 10                	mov    %edx,(%eax)
  800868:	8b 45 08             	mov    0x8(%ebp),%eax
  80086b:	8b 00                	mov    (%eax),%eax
  80086d:	83 e8 04             	sub    $0x4,%eax
  800870:	8b 00                	mov    (%eax),%eax
  800872:	ba 00 00 00 00       	mov    $0x0,%edx
  800877:	eb 1c                	jmp    800895 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800879:	8b 45 08             	mov    0x8(%ebp),%eax
  80087c:	8b 00                	mov    (%eax),%eax
  80087e:	8d 50 04             	lea    0x4(%eax),%edx
  800881:	8b 45 08             	mov    0x8(%ebp),%eax
  800884:	89 10                	mov    %edx,(%eax)
  800886:	8b 45 08             	mov    0x8(%ebp),%eax
  800889:	8b 00                	mov    (%eax),%eax
  80088b:	83 e8 04             	sub    $0x4,%eax
  80088e:	8b 00                	mov    (%eax),%eax
  800890:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800895:	5d                   	pop    %ebp
  800896:	c3                   	ret    

00800897 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800897:	55                   	push   %ebp
  800898:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80089a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80089e:	7e 1c                	jle    8008bc <getint+0x25>
		return va_arg(*ap, long long);
  8008a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a3:	8b 00                	mov    (%eax),%eax
  8008a5:	8d 50 08             	lea    0x8(%eax),%edx
  8008a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ab:	89 10                	mov    %edx,(%eax)
  8008ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b0:	8b 00                	mov    (%eax),%eax
  8008b2:	83 e8 08             	sub    $0x8,%eax
  8008b5:	8b 50 04             	mov    0x4(%eax),%edx
  8008b8:	8b 00                	mov    (%eax),%eax
  8008ba:	eb 38                	jmp    8008f4 <getint+0x5d>
	else if (lflag)
  8008bc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008c0:	74 1a                	je     8008dc <getint+0x45>
		return va_arg(*ap, long);
  8008c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c5:	8b 00                	mov    (%eax),%eax
  8008c7:	8d 50 04             	lea    0x4(%eax),%edx
  8008ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cd:	89 10                	mov    %edx,(%eax)
  8008cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d2:	8b 00                	mov    (%eax),%eax
  8008d4:	83 e8 04             	sub    $0x4,%eax
  8008d7:	8b 00                	mov    (%eax),%eax
  8008d9:	99                   	cltd   
  8008da:	eb 18                	jmp    8008f4 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8008dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008df:	8b 00                	mov    (%eax),%eax
  8008e1:	8d 50 04             	lea    0x4(%eax),%edx
  8008e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e7:	89 10                	mov    %edx,(%eax)
  8008e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ec:	8b 00                	mov    (%eax),%eax
  8008ee:	83 e8 04             	sub    $0x4,%eax
  8008f1:	8b 00                	mov    (%eax),%eax
  8008f3:	99                   	cltd   
}
  8008f4:	5d                   	pop    %ebp
  8008f5:	c3                   	ret    

008008f6 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8008f6:	55                   	push   %ebp
  8008f7:	89 e5                	mov    %esp,%ebp
  8008f9:	56                   	push   %esi
  8008fa:	53                   	push   %ebx
  8008fb:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008fe:	eb 17                	jmp    800917 <vprintfmt+0x21>
			if (ch == '\0')
  800900:	85 db                	test   %ebx,%ebx
  800902:	0f 84 c1 03 00 00    	je     800cc9 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800908:	83 ec 08             	sub    $0x8,%esp
  80090b:	ff 75 0c             	pushl  0xc(%ebp)
  80090e:	53                   	push   %ebx
  80090f:	8b 45 08             	mov    0x8(%ebp),%eax
  800912:	ff d0                	call   *%eax
  800914:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800917:	8b 45 10             	mov    0x10(%ebp),%eax
  80091a:	8d 50 01             	lea    0x1(%eax),%edx
  80091d:	89 55 10             	mov    %edx,0x10(%ebp)
  800920:	8a 00                	mov    (%eax),%al
  800922:	0f b6 d8             	movzbl %al,%ebx
  800925:	83 fb 25             	cmp    $0x25,%ebx
  800928:	75 d6                	jne    800900 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80092a:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80092e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800935:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80093c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800943:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80094a:	8b 45 10             	mov    0x10(%ebp),%eax
  80094d:	8d 50 01             	lea    0x1(%eax),%edx
  800950:	89 55 10             	mov    %edx,0x10(%ebp)
  800953:	8a 00                	mov    (%eax),%al
  800955:	0f b6 d8             	movzbl %al,%ebx
  800958:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80095b:	83 f8 5b             	cmp    $0x5b,%eax
  80095e:	0f 87 3d 03 00 00    	ja     800ca1 <vprintfmt+0x3ab>
  800964:	8b 04 85 b8 27 80 00 	mov    0x8027b8(,%eax,4),%eax
  80096b:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80096d:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800971:	eb d7                	jmp    80094a <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800973:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800977:	eb d1                	jmp    80094a <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800979:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800980:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800983:	89 d0                	mov    %edx,%eax
  800985:	c1 e0 02             	shl    $0x2,%eax
  800988:	01 d0                	add    %edx,%eax
  80098a:	01 c0                	add    %eax,%eax
  80098c:	01 d8                	add    %ebx,%eax
  80098e:	83 e8 30             	sub    $0x30,%eax
  800991:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800994:	8b 45 10             	mov    0x10(%ebp),%eax
  800997:	8a 00                	mov    (%eax),%al
  800999:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80099c:	83 fb 2f             	cmp    $0x2f,%ebx
  80099f:	7e 3e                	jle    8009df <vprintfmt+0xe9>
  8009a1:	83 fb 39             	cmp    $0x39,%ebx
  8009a4:	7f 39                	jg     8009df <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009a6:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009a9:	eb d5                	jmp    800980 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8009ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ae:	83 c0 04             	add    $0x4,%eax
  8009b1:	89 45 14             	mov    %eax,0x14(%ebp)
  8009b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b7:	83 e8 04             	sub    $0x4,%eax
  8009ba:	8b 00                	mov    (%eax),%eax
  8009bc:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8009bf:	eb 1f                	jmp    8009e0 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8009c1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009c5:	79 83                	jns    80094a <vprintfmt+0x54>
				width = 0;
  8009c7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8009ce:	e9 77 ff ff ff       	jmp    80094a <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8009d3:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8009da:	e9 6b ff ff ff       	jmp    80094a <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8009df:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8009e0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009e4:	0f 89 60 ff ff ff    	jns    80094a <vprintfmt+0x54>
				width = precision, precision = -1;
  8009ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009ed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8009f0:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8009f7:	e9 4e ff ff ff       	jmp    80094a <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8009fc:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8009ff:	e9 46 ff ff ff       	jmp    80094a <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a04:	8b 45 14             	mov    0x14(%ebp),%eax
  800a07:	83 c0 04             	add    $0x4,%eax
  800a0a:	89 45 14             	mov    %eax,0x14(%ebp)
  800a0d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a10:	83 e8 04             	sub    $0x4,%eax
  800a13:	8b 00                	mov    (%eax),%eax
  800a15:	83 ec 08             	sub    $0x8,%esp
  800a18:	ff 75 0c             	pushl  0xc(%ebp)
  800a1b:	50                   	push   %eax
  800a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1f:	ff d0                	call   *%eax
  800a21:	83 c4 10             	add    $0x10,%esp
			break;
  800a24:	e9 9b 02 00 00       	jmp    800cc4 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a29:	8b 45 14             	mov    0x14(%ebp),%eax
  800a2c:	83 c0 04             	add    $0x4,%eax
  800a2f:	89 45 14             	mov    %eax,0x14(%ebp)
  800a32:	8b 45 14             	mov    0x14(%ebp),%eax
  800a35:	83 e8 04             	sub    $0x4,%eax
  800a38:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a3a:	85 db                	test   %ebx,%ebx
  800a3c:	79 02                	jns    800a40 <vprintfmt+0x14a>
				err = -err;
  800a3e:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a40:	83 fb 64             	cmp    $0x64,%ebx
  800a43:	7f 0b                	jg     800a50 <vprintfmt+0x15a>
  800a45:	8b 34 9d 00 26 80 00 	mov    0x802600(,%ebx,4),%esi
  800a4c:	85 f6                	test   %esi,%esi
  800a4e:	75 19                	jne    800a69 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a50:	53                   	push   %ebx
  800a51:	68 a5 27 80 00       	push   $0x8027a5
  800a56:	ff 75 0c             	pushl  0xc(%ebp)
  800a59:	ff 75 08             	pushl  0x8(%ebp)
  800a5c:	e8 70 02 00 00       	call   800cd1 <printfmt>
  800a61:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a64:	e9 5b 02 00 00       	jmp    800cc4 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a69:	56                   	push   %esi
  800a6a:	68 ae 27 80 00       	push   $0x8027ae
  800a6f:	ff 75 0c             	pushl  0xc(%ebp)
  800a72:	ff 75 08             	pushl  0x8(%ebp)
  800a75:	e8 57 02 00 00       	call   800cd1 <printfmt>
  800a7a:	83 c4 10             	add    $0x10,%esp
			break;
  800a7d:	e9 42 02 00 00       	jmp    800cc4 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a82:	8b 45 14             	mov    0x14(%ebp),%eax
  800a85:	83 c0 04             	add    $0x4,%eax
  800a88:	89 45 14             	mov    %eax,0x14(%ebp)
  800a8b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a8e:	83 e8 04             	sub    $0x4,%eax
  800a91:	8b 30                	mov    (%eax),%esi
  800a93:	85 f6                	test   %esi,%esi
  800a95:	75 05                	jne    800a9c <vprintfmt+0x1a6>
				p = "(null)";
  800a97:	be b1 27 80 00       	mov    $0x8027b1,%esi
			if (width > 0 && padc != '-')
  800a9c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800aa0:	7e 6d                	jle    800b0f <vprintfmt+0x219>
  800aa2:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800aa6:	74 67                	je     800b0f <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800aa8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800aab:	83 ec 08             	sub    $0x8,%esp
  800aae:	50                   	push   %eax
  800aaf:	56                   	push   %esi
  800ab0:	e8 1e 03 00 00       	call   800dd3 <strnlen>
  800ab5:	83 c4 10             	add    $0x10,%esp
  800ab8:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800abb:	eb 16                	jmp    800ad3 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800abd:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800ac1:	83 ec 08             	sub    $0x8,%esp
  800ac4:	ff 75 0c             	pushl  0xc(%ebp)
  800ac7:	50                   	push   %eax
  800ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  800acb:	ff d0                	call   *%eax
  800acd:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800ad0:	ff 4d e4             	decl   -0x1c(%ebp)
  800ad3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ad7:	7f e4                	jg     800abd <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ad9:	eb 34                	jmp    800b0f <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800adb:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800adf:	74 1c                	je     800afd <vprintfmt+0x207>
  800ae1:	83 fb 1f             	cmp    $0x1f,%ebx
  800ae4:	7e 05                	jle    800aeb <vprintfmt+0x1f5>
  800ae6:	83 fb 7e             	cmp    $0x7e,%ebx
  800ae9:	7e 12                	jle    800afd <vprintfmt+0x207>
					putch('?', putdat);
  800aeb:	83 ec 08             	sub    $0x8,%esp
  800aee:	ff 75 0c             	pushl  0xc(%ebp)
  800af1:	6a 3f                	push   $0x3f
  800af3:	8b 45 08             	mov    0x8(%ebp),%eax
  800af6:	ff d0                	call   *%eax
  800af8:	83 c4 10             	add    $0x10,%esp
  800afb:	eb 0f                	jmp    800b0c <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800afd:	83 ec 08             	sub    $0x8,%esp
  800b00:	ff 75 0c             	pushl  0xc(%ebp)
  800b03:	53                   	push   %ebx
  800b04:	8b 45 08             	mov    0x8(%ebp),%eax
  800b07:	ff d0                	call   *%eax
  800b09:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b0c:	ff 4d e4             	decl   -0x1c(%ebp)
  800b0f:	89 f0                	mov    %esi,%eax
  800b11:	8d 70 01             	lea    0x1(%eax),%esi
  800b14:	8a 00                	mov    (%eax),%al
  800b16:	0f be d8             	movsbl %al,%ebx
  800b19:	85 db                	test   %ebx,%ebx
  800b1b:	74 24                	je     800b41 <vprintfmt+0x24b>
  800b1d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b21:	78 b8                	js     800adb <vprintfmt+0x1e5>
  800b23:	ff 4d e0             	decl   -0x20(%ebp)
  800b26:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b2a:	79 af                	jns    800adb <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b2c:	eb 13                	jmp    800b41 <vprintfmt+0x24b>
				putch(' ', putdat);
  800b2e:	83 ec 08             	sub    $0x8,%esp
  800b31:	ff 75 0c             	pushl  0xc(%ebp)
  800b34:	6a 20                	push   $0x20
  800b36:	8b 45 08             	mov    0x8(%ebp),%eax
  800b39:	ff d0                	call   *%eax
  800b3b:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b3e:	ff 4d e4             	decl   -0x1c(%ebp)
  800b41:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b45:	7f e7                	jg     800b2e <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b47:	e9 78 01 00 00       	jmp    800cc4 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b4c:	83 ec 08             	sub    $0x8,%esp
  800b4f:	ff 75 e8             	pushl  -0x18(%ebp)
  800b52:	8d 45 14             	lea    0x14(%ebp),%eax
  800b55:	50                   	push   %eax
  800b56:	e8 3c fd ff ff       	call   800897 <getint>
  800b5b:	83 c4 10             	add    $0x10,%esp
  800b5e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b61:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800b64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b67:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b6a:	85 d2                	test   %edx,%edx
  800b6c:	79 23                	jns    800b91 <vprintfmt+0x29b>
				putch('-', putdat);
  800b6e:	83 ec 08             	sub    $0x8,%esp
  800b71:	ff 75 0c             	pushl  0xc(%ebp)
  800b74:	6a 2d                	push   $0x2d
  800b76:	8b 45 08             	mov    0x8(%ebp),%eax
  800b79:	ff d0                	call   *%eax
  800b7b:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800b7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b81:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b84:	f7 d8                	neg    %eax
  800b86:	83 d2 00             	adc    $0x0,%edx
  800b89:	f7 da                	neg    %edx
  800b8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b8e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800b91:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b98:	e9 bc 00 00 00       	jmp    800c59 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b9d:	83 ec 08             	sub    $0x8,%esp
  800ba0:	ff 75 e8             	pushl  -0x18(%ebp)
  800ba3:	8d 45 14             	lea    0x14(%ebp),%eax
  800ba6:	50                   	push   %eax
  800ba7:	e8 84 fc ff ff       	call   800830 <getuint>
  800bac:	83 c4 10             	add    $0x10,%esp
  800baf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bb2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800bb5:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bbc:	e9 98 00 00 00       	jmp    800c59 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800bc1:	83 ec 08             	sub    $0x8,%esp
  800bc4:	ff 75 0c             	pushl  0xc(%ebp)
  800bc7:	6a 58                	push   $0x58
  800bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcc:	ff d0                	call   *%eax
  800bce:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800bd1:	83 ec 08             	sub    $0x8,%esp
  800bd4:	ff 75 0c             	pushl  0xc(%ebp)
  800bd7:	6a 58                	push   $0x58
  800bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdc:	ff d0                	call   *%eax
  800bde:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800be1:	83 ec 08             	sub    $0x8,%esp
  800be4:	ff 75 0c             	pushl  0xc(%ebp)
  800be7:	6a 58                	push   $0x58
  800be9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bec:	ff d0                	call   *%eax
  800bee:	83 c4 10             	add    $0x10,%esp
			break;
  800bf1:	e9 ce 00 00 00       	jmp    800cc4 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800bf6:	83 ec 08             	sub    $0x8,%esp
  800bf9:	ff 75 0c             	pushl  0xc(%ebp)
  800bfc:	6a 30                	push   $0x30
  800bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800c01:	ff d0                	call   *%eax
  800c03:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c06:	83 ec 08             	sub    $0x8,%esp
  800c09:	ff 75 0c             	pushl  0xc(%ebp)
  800c0c:	6a 78                	push   $0x78
  800c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c11:	ff d0                	call   *%eax
  800c13:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c16:	8b 45 14             	mov    0x14(%ebp),%eax
  800c19:	83 c0 04             	add    $0x4,%eax
  800c1c:	89 45 14             	mov    %eax,0x14(%ebp)
  800c1f:	8b 45 14             	mov    0x14(%ebp),%eax
  800c22:	83 e8 04             	sub    $0x4,%eax
  800c25:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c27:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c2a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c31:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c38:	eb 1f                	jmp    800c59 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c3a:	83 ec 08             	sub    $0x8,%esp
  800c3d:	ff 75 e8             	pushl  -0x18(%ebp)
  800c40:	8d 45 14             	lea    0x14(%ebp),%eax
  800c43:	50                   	push   %eax
  800c44:	e8 e7 fb ff ff       	call   800830 <getuint>
  800c49:	83 c4 10             	add    $0x10,%esp
  800c4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c4f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800c52:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c59:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800c5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c60:	83 ec 04             	sub    $0x4,%esp
  800c63:	52                   	push   %edx
  800c64:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c67:	50                   	push   %eax
  800c68:	ff 75 f4             	pushl  -0xc(%ebp)
  800c6b:	ff 75 f0             	pushl  -0x10(%ebp)
  800c6e:	ff 75 0c             	pushl  0xc(%ebp)
  800c71:	ff 75 08             	pushl  0x8(%ebp)
  800c74:	e8 00 fb ff ff       	call   800779 <printnum>
  800c79:	83 c4 20             	add    $0x20,%esp
			break;
  800c7c:	eb 46                	jmp    800cc4 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c7e:	83 ec 08             	sub    $0x8,%esp
  800c81:	ff 75 0c             	pushl  0xc(%ebp)
  800c84:	53                   	push   %ebx
  800c85:	8b 45 08             	mov    0x8(%ebp),%eax
  800c88:	ff d0                	call   *%eax
  800c8a:	83 c4 10             	add    $0x10,%esp
			break;
  800c8d:	eb 35                	jmp    800cc4 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800c8f:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800c96:	eb 2c                	jmp    800cc4 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800c98:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800c9f:	eb 23                	jmp    800cc4 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ca1:	83 ec 08             	sub    $0x8,%esp
  800ca4:	ff 75 0c             	pushl  0xc(%ebp)
  800ca7:	6a 25                	push   $0x25
  800ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cac:	ff d0                	call   *%eax
  800cae:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800cb1:	ff 4d 10             	decl   0x10(%ebp)
  800cb4:	eb 03                	jmp    800cb9 <vprintfmt+0x3c3>
  800cb6:	ff 4d 10             	decl   0x10(%ebp)
  800cb9:	8b 45 10             	mov    0x10(%ebp),%eax
  800cbc:	48                   	dec    %eax
  800cbd:	8a 00                	mov    (%eax),%al
  800cbf:	3c 25                	cmp    $0x25,%al
  800cc1:	75 f3                	jne    800cb6 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800cc3:	90                   	nop
		}
	}
  800cc4:	e9 35 fc ff ff       	jmp    8008fe <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800cc9:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800cca:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ccd:	5b                   	pop    %ebx
  800cce:	5e                   	pop    %esi
  800ccf:	5d                   	pop    %ebp
  800cd0:	c3                   	ret    

00800cd1 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800cd1:	55                   	push   %ebp
  800cd2:	89 e5                	mov    %esp,%ebp
  800cd4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800cd7:	8d 45 10             	lea    0x10(%ebp),%eax
  800cda:	83 c0 04             	add    $0x4,%eax
  800cdd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800ce0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ce3:	ff 75 f4             	pushl  -0xc(%ebp)
  800ce6:	50                   	push   %eax
  800ce7:	ff 75 0c             	pushl  0xc(%ebp)
  800cea:	ff 75 08             	pushl  0x8(%ebp)
  800ced:	e8 04 fc ff ff       	call   8008f6 <vprintfmt>
  800cf2:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800cf5:	90                   	nop
  800cf6:	c9                   	leave  
  800cf7:	c3                   	ret    

00800cf8 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800cf8:	55                   	push   %ebp
  800cf9:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800cfb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cfe:	8b 40 08             	mov    0x8(%eax),%eax
  800d01:	8d 50 01             	lea    0x1(%eax),%edx
  800d04:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d07:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d0d:	8b 10                	mov    (%eax),%edx
  800d0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d12:	8b 40 04             	mov    0x4(%eax),%eax
  800d15:	39 c2                	cmp    %eax,%edx
  800d17:	73 12                	jae    800d2b <sprintputch+0x33>
		*b->buf++ = ch;
  800d19:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1c:	8b 00                	mov    (%eax),%eax
  800d1e:	8d 48 01             	lea    0x1(%eax),%ecx
  800d21:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d24:	89 0a                	mov    %ecx,(%edx)
  800d26:	8b 55 08             	mov    0x8(%ebp),%edx
  800d29:	88 10                	mov    %dl,(%eax)
}
  800d2b:	90                   	nop
  800d2c:	5d                   	pop    %ebp
  800d2d:	c3                   	ret    

00800d2e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d2e:	55                   	push   %ebp
  800d2f:	89 e5                	mov    %esp,%ebp
  800d31:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d34:	8b 45 08             	mov    0x8(%ebp),%eax
  800d37:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d40:	8b 45 08             	mov    0x8(%ebp),%eax
  800d43:	01 d0                	add    %edx,%eax
  800d45:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d48:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d4f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d53:	74 06                	je     800d5b <vsnprintf+0x2d>
  800d55:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d59:	7f 07                	jg     800d62 <vsnprintf+0x34>
		return -E_INVAL;
  800d5b:	b8 03 00 00 00       	mov    $0x3,%eax
  800d60:	eb 20                	jmp    800d82 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d62:	ff 75 14             	pushl  0x14(%ebp)
  800d65:	ff 75 10             	pushl  0x10(%ebp)
  800d68:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d6b:	50                   	push   %eax
  800d6c:	68 f8 0c 80 00       	push   $0x800cf8
  800d71:	e8 80 fb ff ff       	call   8008f6 <vprintfmt>
  800d76:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800d79:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d7c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800d82:	c9                   	leave  
  800d83:	c3                   	ret    

00800d84 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d84:	55                   	push   %ebp
  800d85:	89 e5                	mov    %esp,%ebp
  800d87:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d8a:	8d 45 10             	lea    0x10(%ebp),%eax
  800d8d:	83 c0 04             	add    $0x4,%eax
  800d90:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800d93:	8b 45 10             	mov    0x10(%ebp),%eax
  800d96:	ff 75 f4             	pushl  -0xc(%ebp)
  800d99:	50                   	push   %eax
  800d9a:	ff 75 0c             	pushl  0xc(%ebp)
  800d9d:	ff 75 08             	pushl  0x8(%ebp)
  800da0:	e8 89 ff ff ff       	call   800d2e <vsnprintf>
  800da5:	83 c4 10             	add    $0x10,%esp
  800da8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800dab:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800dae:	c9                   	leave  
  800daf:	c3                   	ret    

00800db0 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800db0:	55                   	push   %ebp
  800db1:	89 e5                	mov    %esp,%ebp
  800db3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800db6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dbd:	eb 06                	jmp    800dc5 <strlen+0x15>
		n++;
  800dbf:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800dc2:	ff 45 08             	incl   0x8(%ebp)
  800dc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc8:	8a 00                	mov    (%eax),%al
  800dca:	84 c0                	test   %al,%al
  800dcc:	75 f1                	jne    800dbf <strlen+0xf>
		n++;
	return n;
  800dce:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800dd1:	c9                   	leave  
  800dd2:	c3                   	ret    

00800dd3 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800dd3:	55                   	push   %ebp
  800dd4:	89 e5                	mov    %esp,%ebp
  800dd6:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800dd9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800de0:	eb 09                	jmp    800deb <strnlen+0x18>
		n++;
  800de2:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800de5:	ff 45 08             	incl   0x8(%ebp)
  800de8:	ff 4d 0c             	decl   0xc(%ebp)
  800deb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800def:	74 09                	je     800dfa <strnlen+0x27>
  800df1:	8b 45 08             	mov    0x8(%ebp),%eax
  800df4:	8a 00                	mov    (%eax),%al
  800df6:	84 c0                	test   %al,%al
  800df8:	75 e8                	jne    800de2 <strnlen+0xf>
		n++;
	return n;
  800dfa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800dfd:	c9                   	leave  
  800dfe:	c3                   	ret    

00800dff <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800dff:	55                   	push   %ebp
  800e00:	89 e5                	mov    %esp,%ebp
  800e02:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e05:	8b 45 08             	mov    0x8(%ebp),%eax
  800e08:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e0b:	90                   	nop
  800e0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0f:	8d 50 01             	lea    0x1(%eax),%edx
  800e12:	89 55 08             	mov    %edx,0x8(%ebp)
  800e15:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e18:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e1b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e1e:	8a 12                	mov    (%edx),%dl
  800e20:	88 10                	mov    %dl,(%eax)
  800e22:	8a 00                	mov    (%eax),%al
  800e24:	84 c0                	test   %al,%al
  800e26:	75 e4                	jne    800e0c <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e28:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e2b:	c9                   	leave  
  800e2c:	c3                   	ret    

00800e2d <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e2d:	55                   	push   %ebp
  800e2e:	89 e5                	mov    %esp,%ebp
  800e30:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e33:	8b 45 08             	mov    0x8(%ebp),%eax
  800e36:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e39:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e40:	eb 1f                	jmp    800e61 <strncpy+0x34>
		*dst++ = *src;
  800e42:	8b 45 08             	mov    0x8(%ebp),%eax
  800e45:	8d 50 01             	lea    0x1(%eax),%edx
  800e48:	89 55 08             	mov    %edx,0x8(%ebp)
  800e4b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e4e:	8a 12                	mov    (%edx),%dl
  800e50:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e55:	8a 00                	mov    (%eax),%al
  800e57:	84 c0                	test   %al,%al
  800e59:	74 03                	je     800e5e <strncpy+0x31>
			src++;
  800e5b:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e5e:	ff 45 fc             	incl   -0x4(%ebp)
  800e61:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e64:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e67:	72 d9                	jb     800e42 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800e69:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e6c:	c9                   	leave  
  800e6d:	c3                   	ret    

00800e6e <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800e6e:	55                   	push   %ebp
  800e6f:	89 e5                	mov    %esp,%ebp
  800e71:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800e74:	8b 45 08             	mov    0x8(%ebp),%eax
  800e77:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800e7a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e7e:	74 30                	je     800eb0 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800e80:	eb 16                	jmp    800e98 <strlcpy+0x2a>
			*dst++ = *src++;
  800e82:	8b 45 08             	mov    0x8(%ebp),%eax
  800e85:	8d 50 01             	lea    0x1(%eax),%edx
  800e88:	89 55 08             	mov    %edx,0x8(%ebp)
  800e8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e8e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e91:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e94:	8a 12                	mov    (%edx),%dl
  800e96:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e98:	ff 4d 10             	decl   0x10(%ebp)
  800e9b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e9f:	74 09                	je     800eaa <strlcpy+0x3c>
  800ea1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea4:	8a 00                	mov    (%eax),%al
  800ea6:	84 c0                	test   %al,%al
  800ea8:	75 d8                	jne    800e82 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800eaa:	8b 45 08             	mov    0x8(%ebp),%eax
  800ead:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800eb0:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eb6:	29 c2                	sub    %eax,%edx
  800eb8:	89 d0                	mov    %edx,%eax
}
  800eba:	c9                   	leave  
  800ebb:	c3                   	ret    

00800ebc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ebc:	55                   	push   %ebp
  800ebd:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ebf:	eb 06                	jmp    800ec7 <strcmp+0xb>
		p++, q++;
  800ec1:	ff 45 08             	incl   0x8(%ebp)
  800ec4:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ec7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eca:	8a 00                	mov    (%eax),%al
  800ecc:	84 c0                	test   %al,%al
  800ece:	74 0e                	je     800ede <strcmp+0x22>
  800ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed3:	8a 10                	mov    (%eax),%dl
  800ed5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed8:	8a 00                	mov    (%eax),%al
  800eda:	38 c2                	cmp    %al,%dl
  800edc:	74 e3                	je     800ec1 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ede:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee1:	8a 00                	mov    (%eax),%al
  800ee3:	0f b6 d0             	movzbl %al,%edx
  800ee6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee9:	8a 00                	mov    (%eax),%al
  800eeb:	0f b6 c0             	movzbl %al,%eax
  800eee:	29 c2                	sub    %eax,%edx
  800ef0:	89 d0                	mov    %edx,%eax
}
  800ef2:	5d                   	pop    %ebp
  800ef3:	c3                   	ret    

00800ef4 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800ef4:	55                   	push   %ebp
  800ef5:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800ef7:	eb 09                	jmp    800f02 <strncmp+0xe>
		n--, p++, q++;
  800ef9:	ff 4d 10             	decl   0x10(%ebp)
  800efc:	ff 45 08             	incl   0x8(%ebp)
  800eff:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f02:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f06:	74 17                	je     800f1f <strncmp+0x2b>
  800f08:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0b:	8a 00                	mov    (%eax),%al
  800f0d:	84 c0                	test   %al,%al
  800f0f:	74 0e                	je     800f1f <strncmp+0x2b>
  800f11:	8b 45 08             	mov    0x8(%ebp),%eax
  800f14:	8a 10                	mov    (%eax),%dl
  800f16:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f19:	8a 00                	mov    (%eax),%al
  800f1b:	38 c2                	cmp    %al,%dl
  800f1d:	74 da                	je     800ef9 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f1f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f23:	75 07                	jne    800f2c <strncmp+0x38>
		return 0;
  800f25:	b8 00 00 00 00       	mov    $0x0,%eax
  800f2a:	eb 14                	jmp    800f40 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2f:	8a 00                	mov    (%eax),%al
  800f31:	0f b6 d0             	movzbl %al,%edx
  800f34:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f37:	8a 00                	mov    (%eax),%al
  800f39:	0f b6 c0             	movzbl %al,%eax
  800f3c:	29 c2                	sub    %eax,%edx
  800f3e:	89 d0                	mov    %edx,%eax
}
  800f40:	5d                   	pop    %ebp
  800f41:	c3                   	ret    

00800f42 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f42:	55                   	push   %ebp
  800f43:	89 e5                	mov    %esp,%ebp
  800f45:	83 ec 04             	sub    $0x4,%esp
  800f48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f4e:	eb 12                	jmp    800f62 <strchr+0x20>
		if (*s == c)
  800f50:	8b 45 08             	mov    0x8(%ebp),%eax
  800f53:	8a 00                	mov    (%eax),%al
  800f55:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f58:	75 05                	jne    800f5f <strchr+0x1d>
			return (char *) s;
  800f5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5d:	eb 11                	jmp    800f70 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800f5f:	ff 45 08             	incl   0x8(%ebp)
  800f62:	8b 45 08             	mov    0x8(%ebp),%eax
  800f65:	8a 00                	mov    (%eax),%al
  800f67:	84 c0                	test   %al,%al
  800f69:	75 e5                	jne    800f50 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800f6b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f70:	c9                   	leave  
  800f71:	c3                   	ret    

00800f72 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f72:	55                   	push   %ebp
  800f73:	89 e5                	mov    %esp,%ebp
  800f75:	83 ec 04             	sub    $0x4,%esp
  800f78:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f7b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f7e:	eb 0d                	jmp    800f8d <strfind+0x1b>
		if (*s == c)
  800f80:	8b 45 08             	mov    0x8(%ebp),%eax
  800f83:	8a 00                	mov    (%eax),%al
  800f85:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f88:	74 0e                	je     800f98 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f8a:	ff 45 08             	incl   0x8(%ebp)
  800f8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f90:	8a 00                	mov    (%eax),%al
  800f92:	84 c0                	test   %al,%al
  800f94:	75 ea                	jne    800f80 <strfind+0xe>
  800f96:	eb 01                	jmp    800f99 <strfind+0x27>
		if (*s == c)
			break;
  800f98:	90                   	nop
	return (char *) s;
  800f99:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f9c:	c9                   	leave  
  800f9d:	c3                   	ret    

00800f9e <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800f9e:	55                   	push   %ebp
  800f9f:	89 e5                	mov    %esp,%ebp
  800fa1:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800faa:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800fae:	76 63                	jbe    801013 <memset+0x75>
		uint64 data_block = c;
  800fb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb3:	99                   	cltd   
  800fb4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fb7:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800fba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fbd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fc0:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800fc4:	c1 e0 08             	shl    $0x8,%eax
  800fc7:	09 45 f0             	or     %eax,-0x10(%ebp)
  800fca:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800fcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fd0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fd3:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800fd7:	c1 e0 10             	shl    $0x10,%eax
  800fda:	09 45 f0             	or     %eax,-0x10(%ebp)
  800fdd:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800fe0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fe3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fe6:	89 c2                	mov    %eax,%edx
  800fe8:	b8 00 00 00 00       	mov    $0x0,%eax
  800fed:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ff0:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800ff3:	eb 18                	jmp    80100d <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800ff5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800ff8:	8d 41 08             	lea    0x8(%ecx),%eax
  800ffb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800ffe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801001:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801004:	89 01                	mov    %eax,(%ecx)
  801006:	89 51 04             	mov    %edx,0x4(%ecx)
  801009:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  80100d:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801011:	77 e2                	ja     800ff5 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801013:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801017:	74 23                	je     80103c <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801019:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80101c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  80101f:	eb 0e                	jmp    80102f <memset+0x91>
			*p8++ = (uint8)c;
  801021:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801024:	8d 50 01             	lea    0x1(%eax),%edx
  801027:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80102a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80102d:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  80102f:	8b 45 10             	mov    0x10(%ebp),%eax
  801032:	8d 50 ff             	lea    -0x1(%eax),%edx
  801035:	89 55 10             	mov    %edx,0x10(%ebp)
  801038:	85 c0                	test   %eax,%eax
  80103a:	75 e5                	jne    801021 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  80103c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80103f:	c9                   	leave  
  801040:	c3                   	ret    

00801041 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801041:	55                   	push   %ebp
  801042:	89 e5                	mov    %esp,%ebp
  801044:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801047:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  80104d:	8b 45 08             	mov    0x8(%ebp),%eax
  801050:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801053:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801057:	76 24                	jbe    80107d <memcpy+0x3c>
		while(n >= 8){
  801059:	eb 1c                	jmp    801077 <memcpy+0x36>
			*d64 = *s64;
  80105b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80105e:	8b 50 04             	mov    0x4(%eax),%edx
  801061:	8b 00                	mov    (%eax),%eax
  801063:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801066:	89 01                	mov    %eax,(%ecx)
  801068:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  80106b:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  80106f:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801073:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801077:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80107b:	77 de                	ja     80105b <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  80107d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801081:	74 31                	je     8010b4 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801083:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801086:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801089:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80108c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  80108f:	eb 16                	jmp    8010a7 <memcpy+0x66>
			*d8++ = *s8++;
  801091:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801094:	8d 50 01             	lea    0x1(%eax),%edx
  801097:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80109a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80109d:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010a0:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8010a3:	8a 12                	mov    (%edx),%dl
  8010a5:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  8010a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8010aa:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010ad:	89 55 10             	mov    %edx,0x10(%ebp)
  8010b0:	85 c0                	test   %eax,%eax
  8010b2:	75 dd                	jne    801091 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  8010b4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010b7:	c9                   	leave  
  8010b8:	c3                   	ret    

008010b9 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8010b9:	55                   	push   %ebp
  8010ba:	89 e5                	mov    %esp,%ebp
  8010bc:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8010bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8010cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ce:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010d1:	73 50                	jae    801123 <memmove+0x6a>
  8010d3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d9:	01 d0                	add    %edx,%eax
  8010db:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010de:	76 43                	jbe    801123 <memmove+0x6a>
		s += n;
  8010e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8010e3:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8010e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8010e9:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8010ec:	eb 10                	jmp    8010fe <memmove+0x45>
			*--d = *--s;
  8010ee:	ff 4d f8             	decl   -0x8(%ebp)
  8010f1:	ff 4d fc             	decl   -0x4(%ebp)
  8010f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010f7:	8a 10                	mov    (%eax),%dl
  8010f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010fc:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8010fe:	8b 45 10             	mov    0x10(%ebp),%eax
  801101:	8d 50 ff             	lea    -0x1(%eax),%edx
  801104:	89 55 10             	mov    %edx,0x10(%ebp)
  801107:	85 c0                	test   %eax,%eax
  801109:	75 e3                	jne    8010ee <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80110b:	eb 23                	jmp    801130 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80110d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801110:	8d 50 01             	lea    0x1(%eax),%edx
  801113:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801116:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801119:	8d 4a 01             	lea    0x1(%edx),%ecx
  80111c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80111f:	8a 12                	mov    (%edx),%dl
  801121:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801123:	8b 45 10             	mov    0x10(%ebp),%eax
  801126:	8d 50 ff             	lea    -0x1(%eax),%edx
  801129:	89 55 10             	mov    %edx,0x10(%ebp)
  80112c:	85 c0                	test   %eax,%eax
  80112e:	75 dd                	jne    80110d <memmove+0x54>
			*d++ = *s++;

	return dst;
  801130:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801133:	c9                   	leave  
  801134:	c3                   	ret    

00801135 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801135:	55                   	push   %ebp
  801136:	89 e5                	mov    %esp,%ebp
  801138:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80113b:	8b 45 08             	mov    0x8(%ebp),%eax
  80113e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801141:	8b 45 0c             	mov    0xc(%ebp),%eax
  801144:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801147:	eb 2a                	jmp    801173 <memcmp+0x3e>
		if (*s1 != *s2)
  801149:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80114c:	8a 10                	mov    (%eax),%dl
  80114e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801151:	8a 00                	mov    (%eax),%al
  801153:	38 c2                	cmp    %al,%dl
  801155:	74 16                	je     80116d <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801157:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80115a:	8a 00                	mov    (%eax),%al
  80115c:	0f b6 d0             	movzbl %al,%edx
  80115f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801162:	8a 00                	mov    (%eax),%al
  801164:	0f b6 c0             	movzbl %al,%eax
  801167:	29 c2                	sub    %eax,%edx
  801169:	89 d0                	mov    %edx,%eax
  80116b:	eb 18                	jmp    801185 <memcmp+0x50>
		s1++, s2++;
  80116d:	ff 45 fc             	incl   -0x4(%ebp)
  801170:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801173:	8b 45 10             	mov    0x10(%ebp),%eax
  801176:	8d 50 ff             	lea    -0x1(%eax),%edx
  801179:	89 55 10             	mov    %edx,0x10(%ebp)
  80117c:	85 c0                	test   %eax,%eax
  80117e:	75 c9                	jne    801149 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801180:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801185:	c9                   	leave  
  801186:	c3                   	ret    

00801187 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801187:	55                   	push   %ebp
  801188:	89 e5                	mov    %esp,%ebp
  80118a:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80118d:	8b 55 08             	mov    0x8(%ebp),%edx
  801190:	8b 45 10             	mov    0x10(%ebp),%eax
  801193:	01 d0                	add    %edx,%eax
  801195:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801198:	eb 15                	jmp    8011af <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80119a:	8b 45 08             	mov    0x8(%ebp),%eax
  80119d:	8a 00                	mov    (%eax),%al
  80119f:	0f b6 d0             	movzbl %al,%edx
  8011a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a5:	0f b6 c0             	movzbl %al,%eax
  8011a8:	39 c2                	cmp    %eax,%edx
  8011aa:	74 0d                	je     8011b9 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8011ac:	ff 45 08             	incl   0x8(%ebp)
  8011af:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8011b5:	72 e3                	jb     80119a <memfind+0x13>
  8011b7:	eb 01                	jmp    8011ba <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8011b9:	90                   	nop
	return (void *) s;
  8011ba:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011bd:	c9                   	leave  
  8011be:	c3                   	ret    

008011bf <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8011bf:	55                   	push   %ebp
  8011c0:	89 e5                	mov    %esp,%ebp
  8011c2:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8011c5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8011cc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011d3:	eb 03                	jmp    8011d8 <strtol+0x19>
		s++;
  8011d5:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011db:	8a 00                	mov    (%eax),%al
  8011dd:	3c 20                	cmp    $0x20,%al
  8011df:	74 f4                	je     8011d5 <strtol+0x16>
  8011e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e4:	8a 00                	mov    (%eax),%al
  8011e6:	3c 09                	cmp    $0x9,%al
  8011e8:	74 eb                	je     8011d5 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8011ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ed:	8a 00                	mov    (%eax),%al
  8011ef:	3c 2b                	cmp    $0x2b,%al
  8011f1:	75 05                	jne    8011f8 <strtol+0x39>
		s++;
  8011f3:	ff 45 08             	incl   0x8(%ebp)
  8011f6:	eb 13                	jmp    80120b <strtol+0x4c>
	else if (*s == '-')
  8011f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fb:	8a 00                	mov    (%eax),%al
  8011fd:	3c 2d                	cmp    $0x2d,%al
  8011ff:	75 0a                	jne    80120b <strtol+0x4c>
		s++, neg = 1;
  801201:	ff 45 08             	incl   0x8(%ebp)
  801204:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80120b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80120f:	74 06                	je     801217 <strtol+0x58>
  801211:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801215:	75 20                	jne    801237 <strtol+0x78>
  801217:	8b 45 08             	mov    0x8(%ebp),%eax
  80121a:	8a 00                	mov    (%eax),%al
  80121c:	3c 30                	cmp    $0x30,%al
  80121e:	75 17                	jne    801237 <strtol+0x78>
  801220:	8b 45 08             	mov    0x8(%ebp),%eax
  801223:	40                   	inc    %eax
  801224:	8a 00                	mov    (%eax),%al
  801226:	3c 78                	cmp    $0x78,%al
  801228:	75 0d                	jne    801237 <strtol+0x78>
		s += 2, base = 16;
  80122a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80122e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801235:	eb 28                	jmp    80125f <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801237:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80123b:	75 15                	jne    801252 <strtol+0x93>
  80123d:	8b 45 08             	mov    0x8(%ebp),%eax
  801240:	8a 00                	mov    (%eax),%al
  801242:	3c 30                	cmp    $0x30,%al
  801244:	75 0c                	jne    801252 <strtol+0x93>
		s++, base = 8;
  801246:	ff 45 08             	incl   0x8(%ebp)
  801249:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801250:	eb 0d                	jmp    80125f <strtol+0xa0>
	else if (base == 0)
  801252:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801256:	75 07                	jne    80125f <strtol+0xa0>
		base = 10;
  801258:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80125f:	8b 45 08             	mov    0x8(%ebp),%eax
  801262:	8a 00                	mov    (%eax),%al
  801264:	3c 2f                	cmp    $0x2f,%al
  801266:	7e 19                	jle    801281 <strtol+0xc2>
  801268:	8b 45 08             	mov    0x8(%ebp),%eax
  80126b:	8a 00                	mov    (%eax),%al
  80126d:	3c 39                	cmp    $0x39,%al
  80126f:	7f 10                	jg     801281 <strtol+0xc2>
			dig = *s - '0';
  801271:	8b 45 08             	mov    0x8(%ebp),%eax
  801274:	8a 00                	mov    (%eax),%al
  801276:	0f be c0             	movsbl %al,%eax
  801279:	83 e8 30             	sub    $0x30,%eax
  80127c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80127f:	eb 42                	jmp    8012c3 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801281:	8b 45 08             	mov    0x8(%ebp),%eax
  801284:	8a 00                	mov    (%eax),%al
  801286:	3c 60                	cmp    $0x60,%al
  801288:	7e 19                	jle    8012a3 <strtol+0xe4>
  80128a:	8b 45 08             	mov    0x8(%ebp),%eax
  80128d:	8a 00                	mov    (%eax),%al
  80128f:	3c 7a                	cmp    $0x7a,%al
  801291:	7f 10                	jg     8012a3 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801293:	8b 45 08             	mov    0x8(%ebp),%eax
  801296:	8a 00                	mov    (%eax),%al
  801298:	0f be c0             	movsbl %al,%eax
  80129b:	83 e8 57             	sub    $0x57,%eax
  80129e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012a1:	eb 20                	jmp    8012c3 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8012a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a6:	8a 00                	mov    (%eax),%al
  8012a8:	3c 40                	cmp    $0x40,%al
  8012aa:	7e 39                	jle    8012e5 <strtol+0x126>
  8012ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8012af:	8a 00                	mov    (%eax),%al
  8012b1:	3c 5a                	cmp    $0x5a,%al
  8012b3:	7f 30                	jg     8012e5 <strtol+0x126>
			dig = *s - 'A' + 10;
  8012b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b8:	8a 00                	mov    (%eax),%al
  8012ba:	0f be c0             	movsbl %al,%eax
  8012bd:	83 e8 37             	sub    $0x37,%eax
  8012c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8012c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012c6:	3b 45 10             	cmp    0x10(%ebp),%eax
  8012c9:	7d 19                	jge    8012e4 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8012cb:	ff 45 08             	incl   0x8(%ebp)
  8012ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012d1:	0f af 45 10          	imul   0x10(%ebp),%eax
  8012d5:	89 c2                	mov    %eax,%edx
  8012d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012da:	01 d0                	add    %edx,%eax
  8012dc:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8012df:	e9 7b ff ff ff       	jmp    80125f <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8012e4:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8012e5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012e9:	74 08                	je     8012f3 <strtol+0x134>
		*endptr = (char *) s;
  8012eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8012f1:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8012f3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8012f7:	74 07                	je     801300 <strtol+0x141>
  8012f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012fc:	f7 d8                	neg    %eax
  8012fe:	eb 03                	jmp    801303 <strtol+0x144>
  801300:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801303:	c9                   	leave  
  801304:	c3                   	ret    

00801305 <ltostr>:

void
ltostr(long value, char *str)
{
  801305:	55                   	push   %ebp
  801306:	89 e5                	mov    %esp,%ebp
  801308:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80130b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801312:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801319:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80131d:	79 13                	jns    801332 <ltostr+0x2d>
	{
		neg = 1;
  80131f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801326:	8b 45 0c             	mov    0xc(%ebp),%eax
  801329:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80132c:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80132f:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801332:	8b 45 08             	mov    0x8(%ebp),%eax
  801335:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80133a:	99                   	cltd   
  80133b:	f7 f9                	idiv   %ecx
  80133d:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801340:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801343:	8d 50 01             	lea    0x1(%eax),%edx
  801346:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801349:	89 c2                	mov    %eax,%edx
  80134b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134e:	01 d0                	add    %edx,%eax
  801350:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801353:	83 c2 30             	add    $0x30,%edx
  801356:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801358:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80135b:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801360:	f7 e9                	imul   %ecx
  801362:	c1 fa 02             	sar    $0x2,%edx
  801365:	89 c8                	mov    %ecx,%eax
  801367:	c1 f8 1f             	sar    $0x1f,%eax
  80136a:	29 c2                	sub    %eax,%edx
  80136c:	89 d0                	mov    %edx,%eax
  80136e:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801371:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801375:	75 bb                	jne    801332 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801377:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80137e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801381:	48                   	dec    %eax
  801382:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801385:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801389:	74 3d                	je     8013c8 <ltostr+0xc3>
		start = 1 ;
  80138b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801392:	eb 34                	jmp    8013c8 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801394:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801397:	8b 45 0c             	mov    0xc(%ebp),%eax
  80139a:	01 d0                	add    %edx,%eax
  80139c:	8a 00                	mov    (%eax),%al
  80139e:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8013a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a7:	01 c2                	add    %eax,%edx
  8013a9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8013ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013af:	01 c8                	add    %ecx,%eax
  8013b1:	8a 00                	mov    (%eax),%al
  8013b3:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8013b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013bb:	01 c2                	add    %eax,%edx
  8013bd:	8a 45 eb             	mov    -0x15(%ebp),%al
  8013c0:	88 02                	mov    %al,(%edx)
		start++ ;
  8013c2:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8013c5:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8013c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013cb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013ce:	7c c4                	jl     801394 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8013d0:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8013d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d6:	01 d0                	add    %edx,%eax
  8013d8:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8013db:	90                   	nop
  8013dc:	c9                   	leave  
  8013dd:	c3                   	ret    

008013de <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8013de:	55                   	push   %ebp
  8013df:	89 e5                	mov    %esp,%ebp
  8013e1:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8013e4:	ff 75 08             	pushl  0x8(%ebp)
  8013e7:	e8 c4 f9 ff ff       	call   800db0 <strlen>
  8013ec:	83 c4 04             	add    $0x4,%esp
  8013ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8013f2:	ff 75 0c             	pushl  0xc(%ebp)
  8013f5:	e8 b6 f9 ff ff       	call   800db0 <strlen>
  8013fa:	83 c4 04             	add    $0x4,%esp
  8013fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801400:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801407:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80140e:	eb 17                	jmp    801427 <strcconcat+0x49>
		final[s] = str1[s] ;
  801410:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801413:	8b 45 10             	mov    0x10(%ebp),%eax
  801416:	01 c2                	add    %eax,%edx
  801418:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80141b:	8b 45 08             	mov    0x8(%ebp),%eax
  80141e:	01 c8                	add    %ecx,%eax
  801420:	8a 00                	mov    (%eax),%al
  801422:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801424:	ff 45 fc             	incl   -0x4(%ebp)
  801427:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80142a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80142d:	7c e1                	jl     801410 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80142f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801436:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80143d:	eb 1f                	jmp    80145e <strcconcat+0x80>
		final[s++] = str2[i] ;
  80143f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801442:	8d 50 01             	lea    0x1(%eax),%edx
  801445:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801448:	89 c2                	mov    %eax,%edx
  80144a:	8b 45 10             	mov    0x10(%ebp),%eax
  80144d:	01 c2                	add    %eax,%edx
  80144f:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801452:	8b 45 0c             	mov    0xc(%ebp),%eax
  801455:	01 c8                	add    %ecx,%eax
  801457:	8a 00                	mov    (%eax),%al
  801459:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80145b:	ff 45 f8             	incl   -0x8(%ebp)
  80145e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801461:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801464:	7c d9                	jl     80143f <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801466:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801469:	8b 45 10             	mov    0x10(%ebp),%eax
  80146c:	01 d0                	add    %edx,%eax
  80146e:	c6 00 00             	movb   $0x0,(%eax)
}
  801471:	90                   	nop
  801472:	c9                   	leave  
  801473:	c3                   	ret    

00801474 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801474:	55                   	push   %ebp
  801475:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801477:	8b 45 14             	mov    0x14(%ebp),%eax
  80147a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801480:	8b 45 14             	mov    0x14(%ebp),%eax
  801483:	8b 00                	mov    (%eax),%eax
  801485:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80148c:	8b 45 10             	mov    0x10(%ebp),%eax
  80148f:	01 d0                	add    %edx,%eax
  801491:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801497:	eb 0c                	jmp    8014a5 <strsplit+0x31>
			*string++ = 0;
  801499:	8b 45 08             	mov    0x8(%ebp),%eax
  80149c:	8d 50 01             	lea    0x1(%eax),%edx
  80149f:	89 55 08             	mov    %edx,0x8(%ebp)
  8014a2:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a8:	8a 00                	mov    (%eax),%al
  8014aa:	84 c0                	test   %al,%al
  8014ac:	74 18                	je     8014c6 <strsplit+0x52>
  8014ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b1:	8a 00                	mov    (%eax),%al
  8014b3:	0f be c0             	movsbl %al,%eax
  8014b6:	50                   	push   %eax
  8014b7:	ff 75 0c             	pushl  0xc(%ebp)
  8014ba:	e8 83 fa ff ff       	call   800f42 <strchr>
  8014bf:	83 c4 08             	add    $0x8,%esp
  8014c2:	85 c0                	test   %eax,%eax
  8014c4:	75 d3                	jne    801499 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8014c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c9:	8a 00                	mov    (%eax),%al
  8014cb:	84 c0                	test   %al,%al
  8014cd:	74 5a                	je     801529 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8014cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8014d2:	8b 00                	mov    (%eax),%eax
  8014d4:	83 f8 0f             	cmp    $0xf,%eax
  8014d7:	75 07                	jne    8014e0 <strsplit+0x6c>
		{
			return 0;
  8014d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8014de:	eb 66                	jmp    801546 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8014e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8014e3:	8b 00                	mov    (%eax),%eax
  8014e5:	8d 48 01             	lea    0x1(%eax),%ecx
  8014e8:	8b 55 14             	mov    0x14(%ebp),%edx
  8014eb:	89 0a                	mov    %ecx,(%edx)
  8014ed:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8014f7:	01 c2                	add    %eax,%edx
  8014f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fc:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014fe:	eb 03                	jmp    801503 <strsplit+0x8f>
			string++;
  801500:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801503:	8b 45 08             	mov    0x8(%ebp),%eax
  801506:	8a 00                	mov    (%eax),%al
  801508:	84 c0                	test   %al,%al
  80150a:	74 8b                	je     801497 <strsplit+0x23>
  80150c:	8b 45 08             	mov    0x8(%ebp),%eax
  80150f:	8a 00                	mov    (%eax),%al
  801511:	0f be c0             	movsbl %al,%eax
  801514:	50                   	push   %eax
  801515:	ff 75 0c             	pushl  0xc(%ebp)
  801518:	e8 25 fa ff ff       	call   800f42 <strchr>
  80151d:	83 c4 08             	add    $0x8,%esp
  801520:	85 c0                	test   %eax,%eax
  801522:	74 dc                	je     801500 <strsplit+0x8c>
			string++;
	}
  801524:	e9 6e ff ff ff       	jmp    801497 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801529:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80152a:	8b 45 14             	mov    0x14(%ebp),%eax
  80152d:	8b 00                	mov    (%eax),%eax
  80152f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801536:	8b 45 10             	mov    0x10(%ebp),%eax
  801539:	01 d0                	add    %edx,%eax
  80153b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801541:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801546:	c9                   	leave  
  801547:	c3                   	ret    

00801548 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801548:	55                   	push   %ebp
  801549:	89 e5                	mov    %esp,%ebp
  80154b:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  80154e:	8b 45 08             	mov    0x8(%ebp),%eax
  801551:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801554:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80155b:	eb 4a                	jmp    8015a7 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  80155d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801560:	8b 45 08             	mov    0x8(%ebp),%eax
  801563:	01 c2                	add    %eax,%edx
  801565:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801568:	8b 45 0c             	mov    0xc(%ebp),%eax
  80156b:	01 c8                	add    %ecx,%eax
  80156d:	8a 00                	mov    (%eax),%al
  80156f:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801571:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801574:	8b 45 0c             	mov    0xc(%ebp),%eax
  801577:	01 d0                	add    %edx,%eax
  801579:	8a 00                	mov    (%eax),%al
  80157b:	3c 40                	cmp    $0x40,%al
  80157d:	7e 25                	jle    8015a4 <str2lower+0x5c>
  80157f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801582:	8b 45 0c             	mov    0xc(%ebp),%eax
  801585:	01 d0                	add    %edx,%eax
  801587:	8a 00                	mov    (%eax),%al
  801589:	3c 5a                	cmp    $0x5a,%al
  80158b:	7f 17                	jg     8015a4 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  80158d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801590:	8b 45 08             	mov    0x8(%ebp),%eax
  801593:	01 d0                	add    %edx,%eax
  801595:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801598:	8b 55 08             	mov    0x8(%ebp),%edx
  80159b:	01 ca                	add    %ecx,%edx
  80159d:	8a 12                	mov    (%edx),%dl
  80159f:	83 c2 20             	add    $0x20,%edx
  8015a2:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8015a4:	ff 45 fc             	incl   -0x4(%ebp)
  8015a7:	ff 75 0c             	pushl  0xc(%ebp)
  8015aa:	e8 01 f8 ff ff       	call   800db0 <strlen>
  8015af:	83 c4 04             	add    $0x4,%esp
  8015b2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8015b5:	7f a6                	jg     80155d <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8015b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8015ba:	c9                   	leave  
  8015bb:	c3                   	ret    

008015bc <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  8015bc:	55                   	push   %ebp
  8015bd:	89 e5                	mov    %esp,%ebp
  8015bf:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  8015c2:	a1 08 30 80 00       	mov    0x803008,%eax
  8015c7:	85 c0                	test   %eax,%eax
  8015c9:	74 42                	je     80160d <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  8015cb:	83 ec 08             	sub    $0x8,%esp
  8015ce:	68 00 00 00 82       	push   $0x82000000
  8015d3:	68 00 00 00 80       	push   $0x80000000
  8015d8:	e8 8c 07 00 00       	call   801d69 <initialize_dynamic_allocator>
  8015dd:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  8015e0:	e8 e7 05 00 00       	call   801bcc <sys_get_uheap_strategy>
  8015e5:	a3 60 b0 81 00       	mov    %eax,0x81b060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  8015ea:	a1 40 30 80 00       	mov    0x803040,%eax
  8015ef:	05 00 10 00 00       	add    $0x1000,%eax
  8015f4:	a3 10 b1 81 00       	mov    %eax,0x81b110
		uheapPageAllocBreak = uheapPageAllocStart;
  8015f9:	a1 10 b1 81 00       	mov    0x81b110,%eax
  8015fe:	a3 68 b0 81 00       	mov    %eax,0x81b068

		__firstTimeFlag = 0;
  801603:	c7 05 08 30 80 00 00 	movl   $0x0,0x803008
  80160a:	00 00 00 
	}
}
  80160d:	90                   	nop
  80160e:	c9                   	leave  
  80160f:	c3                   	ret    

00801610 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801610:	55                   	push   %ebp
  801611:	89 e5                	mov    %esp,%ebp
  801613:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801616:	8b 45 08             	mov    0x8(%ebp),%eax
  801619:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80161c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80161f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801624:	83 ec 08             	sub    $0x8,%esp
  801627:	68 06 04 00 00       	push   $0x406
  80162c:	50                   	push   %eax
  80162d:	e8 e4 01 00 00       	call   801816 <__sys_allocate_page>
  801632:	83 c4 10             	add    $0x10,%esp
  801635:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801638:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80163c:	79 14                	jns    801652 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  80163e:	83 ec 04             	sub    $0x4,%esp
  801641:	68 28 29 80 00       	push   $0x802928
  801646:	6a 1f                	push   $0x1f
  801648:	68 64 29 80 00       	push   $0x802964
  80164d:	e8 b7 ed ff ff       	call   800409 <_panic>
	return 0;
  801652:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801657:	c9                   	leave  
  801658:	c3                   	ret    

00801659 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801659:	55                   	push   %ebp
  80165a:	89 e5                	mov    %esp,%ebp
  80165c:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  80165f:	8b 45 08             	mov    0x8(%ebp),%eax
  801662:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801665:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801668:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80166d:	83 ec 0c             	sub    $0xc,%esp
  801670:	50                   	push   %eax
  801671:	e8 e7 01 00 00       	call   80185d <__sys_unmap_frame>
  801676:	83 c4 10             	add    $0x10,%esp
  801679:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  80167c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801680:	79 14                	jns    801696 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801682:	83 ec 04             	sub    $0x4,%esp
  801685:	68 70 29 80 00       	push   $0x802970
  80168a:	6a 2a                	push   $0x2a
  80168c:	68 64 29 80 00       	push   $0x802964
  801691:	e8 73 ed ff ff       	call   800409 <_panic>
}
  801696:	90                   	nop
  801697:	c9                   	leave  
  801698:	c3                   	ret    

00801699 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801699:	55                   	push   %ebp
  80169a:	89 e5                	mov    %esp,%ebp
  80169c:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80169f:	e8 18 ff ff ff       	call   8015bc <uheap_init>
	if (size == 0) return NULL ;
  8016a4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8016a8:	75 07                	jne    8016b1 <malloc+0x18>
  8016aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8016af:	eb 14                	jmp    8016c5 <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  8016b1:	83 ec 04             	sub    $0x4,%esp
  8016b4:	68 b0 29 80 00       	push   $0x8029b0
  8016b9:	6a 3e                	push   $0x3e
  8016bb:	68 64 29 80 00       	push   $0x802964
  8016c0:	e8 44 ed ff ff       	call   800409 <_panic>
}
  8016c5:	c9                   	leave  
  8016c6:	c3                   	ret    

008016c7 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  8016c7:	55                   	push   %ebp
  8016c8:	89 e5                	mov    %esp,%ebp
  8016ca:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  8016cd:	83 ec 04             	sub    $0x4,%esp
  8016d0:	68 d8 29 80 00       	push   $0x8029d8
  8016d5:	6a 49                	push   $0x49
  8016d7:	68 64 29 80 00       	push   $0x802964
  8016dc:	e8 28 ed ff ff       	call   800409 <_panic>

008016e1 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8016e1:	55                   	push   %ebp
  8016e2:	89 e5                	mov    %esp,%ebp
  8016e4:	83 ec 18             	sub    $0x18,%esp
  8016e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ea:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8016ed:	e8 ca fe ff ff       	call   8015bc <uheap_init>
	if (size == 0) return NULL ;
  8016f2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016f6:	75 07                	jne    8016ff <smalloc+0x1e>
  8016f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8016fd:	eb 14                	jmp    801713 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  8016ff:	83 ec 04             	sub    $0x4,%esp
  801702:	68 fc 29 80 00       	push   $0x8029fc
  801707:	6a 5a                	push   $0x5a
  801709:	68 64 29 80 00       	push   $0x802964
  80170e:	e8 f6 ec ff ff       	call   800409 <_panic>
}
  801713:	c9                   	leave  
  801714:	c3                   	ret    

00801715 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801715:	55                   	push   %ebp
  801716:	89 e5                	mov    %esp,%ebp
  801718:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80171b:	e8 9c fe ff ff       	call   8015bc <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  801720:	83 ec 04             	sub    $0x4,%esp
  801723:	68 24 2a 80 00       	push   $0x802a24
  801728:	6a 6a                	push   $0x6a
  80172a:	68 64 29 80 00       	push   $0x802964
  80172f:	e8 d5 ec ff ff       	call   800409 <_panic>

00801734 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801734:	55                   	push   %ebp
  801735:	89 e5                	mov    %esp,%ebp
  801737:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80173a:	e8 7d fe ff ff       	call   8015bc <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  80173f:	83 ec 04             	sub    $0x4,%esp
  801742:	68 48 2a 80 00       	push   $0x802a48
  801747:	68 88 00 00 00       	push   $0x88
  80174c:	68 64 29 80 00       	push   $0x802964
  801751:	e8 b3 ec ff ff       	call   800409 <_panic>

00801756 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  801756:	55                   	push   %ebp
  801757:	89 e5                	mov    %esp,%ebp
  801759:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  80175c:	83 ec 04             	sub    $0x4,%esp
  80175f:	68 70 2a 80 00       	push   $0x802a70
  801764:	68 9b 00 00 00       	push   $0x9b
  801769:	68 64 29 80 00       	push   $0x802964
  80176e:	e8 96 ec ff ff       	call   800409 <_panic>

00801773 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801773:	55                   	push   %ebp
  801774:	89 e5                	mov    %esp,%ebp
  801776:	57                   	push   %edi
  801777:	56                   	push   %esi
  801778:	53                   	push   %ebx
  801779:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80177c:	8b 45 08             	mov    0x8(%ebp),%eax
  80177f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801782:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801785:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801788:	8b 7d 18             	mov    0x18(%ebp),%edi
  80178b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80178e:	cd 30                	int    $0x30
  801790:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801793:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801796:	83 c4 10             	add    $0x10,%esp
  801799:	5b                   	pop    %ebx
  80179a:	5e                   	pop    %esi
  80179b:	5f                   	pop    %edi
  80179c:	5d                   	pop    %ebp
  80179d:	c3                   	ret    

0080179e <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  80179e:	55                   	push   %ebp
  80179f:	89 e5                	mov    %esp,%ebp
  8017a1:	83 ec 04             	sub    $0x4,%esp
  8017a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8017a7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8017aa:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8017ad:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b4:	6a 00                	push   $0x0
  8017b6:	51                   	push   %ecx
  8017b7:	52                   	push   %edx
  8017b8:	ff 75 0c             	pushl  0xc(%ebp)
  8017bb:	50                   	push   %eax
  8017bc:	6a 00                	push   $0x0
  8017be:	e8 b0 ff ff ff       	call   801773 <syscall>
  8017c3:	83 c4 18             	add    $0x18,%esp
}
  8017c6:	90                   	nop
  8017c7:	c9                   	leave  
  8017c8:	c3                   	ret    

008017c9 <sys_cgetc>:

int
sys_cgetc(void)
{
  8017c9:	55                   	push   %ebp
  8017ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8017cc:	6a 00                	push   $0x0
  8017ce:	6a 00                	push   $0x0
  8017d0:	6a 00                	push   $0x0
  8017d2:	6a 00                	push   $0x0
  8017d4:	6a 00                	push   $0x0
  8017d6:	6a 02                	push   $0x2
  8017d8:	e8 96 ff ff ff       	call   801773 <syscall>
  8017dd:	83 c4 18             	add    $0x18,%esp
}
  8017e0:	c9                   	leave  
  8017e1:	c3                   	ret    

008017e2 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8017e2:	55                   	push   %ebp
  8017e3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8017e5:	6a 00                	push   $0x0
  8017e7:	6a 00                	push   $0x0
  8017e9:	6a 00                	push   $0x0
  8017eb:	6a 00                	push   $0x0
  8017ed:	6a 00                	push   $0x0
  8017ef:	6a 03                	push   $0x3
  8017f1:	e8 7d ff ff ff       	call   801773 <syscall>
  8017f6:	83 c4 18             	add    $0x18,%esp
}
  8017f9:	90                   	nop
  8017fa:	c9                   	leave  
  8017fb:	c3                   	ret    

008017fc <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8017fc:	55                   	push   %ebp
  8017fd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8017ff:	6a 00                	push   $0x0
  801801:	6a 00                	push   $0x0
  801803:	6a 00                	push   $0x0
  801805:	6a 00                	push   $0x0
  801807:	6a 00                	push   $0x0
  801809:	6a 04                	push   $0x4
  80180b:	e8 63 ff ff ff       	call   801773 <syscall>
  801810:	83 c4 18             	add    $0x18,%esp
}
  801813:	90                   	nop
  801814:	c9                   	leave  
  801815:	c3                   	ret    

00801816 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801816:	55                   	push   %ebp
  801817:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801819:	8b 55 0c             	mov    0xc(%ebp),%edx
  80181c:	8b 45 08             	mov    0x8(%ebp),%eax
  80181f:	6a 00                	push   $0x0
  801821:	6a 00                	push   $0x0
  801823:	6a 00                	push   $0x0
  801825:	52                   	push   %edx
  801826:	50                   	push   %eax
  801827:	6a 08                	push   $0x8
  801829:	e8 45 ff ff ff       	call   801773 <syscall>
  80182e:	83 c4 18             	add    $0x18,%esp
}
  801831:	c9                   	leave  
  801832:	c3                   	ret    

00801833 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801833:	55                   	push   %ebp
  801834:	89 e5                	mov    %esp,%ebp
  801836:	56                   	push   %esi
  801837:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801838:	8b 75 18             	mov    0x18(%ebp),%esi
  80183b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80183e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801841:	8b 55 0c             	mov    0xc(%ebp),%edx
  801844:	8b 45 08             	mov    0x8(%ebp),%eax
  801847:	56                   	push   %esi
  801848:	53                   	push   %ebx
  801849:	51                   	push   %ecx
  80184a:	52                   	push   %edx
  80184b:	50                   	push   %eax
  80184c:	6a 09                	push   $0x9
  80184e:	e8 20 ff ff ff       	call   801773 <syscall>
  801853:	83 c4 18             	add    $0x18,%esp
}
  801856:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801859:	5b                   	pop    %ebx
  80185a:	5e                   	pop    %esi
  80185b:	5d                   	pop    %ebp
  80185c:	c3                   	ret    

0080185d <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  80185d:	55                   	push   %ebp
  80185e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801860:	6a 00                	push   $0x0
  801862:	6a 00                	push   $0x0
  801864:	6a 00                	push   $0x0
  801866:	6a 00                	push   $0x0
  801868:	ff 75 08             	pushl  0x8(%ebp)
  80186b:	6a 0a                	push   $0xa
  80186d:	e8 01 ff ff ff       	call   801773 <syscall>
  801872:	83 c4 18             	add    $0x18,%esp
}
  801875:	c9                   	leave  
  801876:	c3                   	ret    

00801877 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801877:	55                   	push   %ebp
  801878:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80187a:	6a 00                	push   $0x0
  80187c:	6a 00                	push   $0x0
  80187e:	6a 00                	push   $0x0
  801880:	ff 75 0c             	pushl  0xc(%ebp)
  801883:	ff 75 08             	pushl  0x8(%ebp)
  801886:	6a 0b                	push   $0xb
  801888:	e8 e6 fe ff ff       	call   801773 <syscall>
  80188d:	83 c4 18             	add    $0x18,%esp
}
  801890:	c9                   	leave  
  801891:	c3                   	ret    

00801892 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801892:	55                   	push   %ebp
  801893:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801895:	6a 00                	push   $0x0
  801897:	6a 00                	push   $0x0
  801899:	6a 00                	push   $0x0
  80189b:	6a 00                	push   $0x0
  80189d:	6a 00                	push   $0x0
  80189f:	6a 0c                	push   $0xc
  8018a1:	e8 cd fe ff ff       	call   801773 <syscall>
  8018a6:	83 c4 18             	add    $0x18,%esp
}
  8018a9:	c9                   	leave  
  8018aa:	c3                   	ret    

008018ab <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8018ab:	55                   	push   %ebp
  8018ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8018ae:	6a 00                	push   $0x0
  8018b0:	6a 00                	push   $0x0
  8018b2:	6a 00                	push   $0x0
  8018b4:	6a 00                	push   $0x0
  8018b6:	6a 00                	push   $0x0
  8018b8:	6a 0d                	push   $0xd
  8018ba:	e8 b4 fe ff ff       	call   801773 <syscall>
  8018bf:	83 c4 18             	add    $0x18,%esp
}
  8018c2:	c9                   	leave  
  8018c3:	c3                   	ret    

008018c4 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8018c4:	55                   	push   %ebp
  8018c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8018c7:	6a 00                	push   $0x0
  8018c9:	6a 00                	push   $0x0
  8018cb:	6a 00                	push   $0x0
  8018cd:	6a 00                	push   $0x0
  8018cf:	6a 00                	push   $0x0
  8018d1:	6a 0e                	push   $0xe
  8018d3:	e8 9b fe ff ff       	call   801773 <syscall>
  8018d8:	83 c4 18             	add    $0x18,%esp
}
  8018db:	c9                   	leave  
  8018dc:	c3                   	ret    

008018dd <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8018dd:	55                   	push   %ebp
  8018de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 00                	push   $0x0
  8018e6:	6a 00                	push   $0x0
  8018e8:	6a 00                	push   $0x0
  8018ea:	6a 0f                	push   $0xf
  8018ec:	e8 82 fe ff ff       	call   801773 <syscall>
  8018f1:	83 c4 18             	add    $0x18,%esp
}
  8018f4:	c9                   	leave  
  8018f5:	c3                   	ret    

008018f6 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8018f6:	55                   	push   %ebp
  8018f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8018f9:	6a 00                	push   $0x0
  8018fb:	6a 00                	push   $0x0
  8018fd:	6a 00                	push   $0x0
  8018ff:	6a 00                	push   $0x0
  801901:	ff 75 08             	pushl  0x8(%ebp)
  801904:	6a 10                	push   $0x10
  801906:	e8 68 fe ff ff       	call   801773 <syscall>
  80190b:	83 c4 18             	add    $0x18,%esp
}
  80190e:	c9                   	leave  
  80190f:	c3                   	ret    

00801910 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801910:	55                   	push   %ebp
  801911:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801913:	6a 00                	push   $0x0
  801915:	6a 00                	push   $0x0
  801917:	6a 00                	push   $0x0
  801919:	6a 00                	push   $0x0
  80191b:	6a 00                	push   $0x0
  80191d:	6a 11                	push   $0x11
  80191f:	e8 4f fe ff ff       	call   801773 <syscall>
  801924:	83 c4 18             	add    $0x18,%esp
}
  801927:	90                   	nop
  801928:	c9                   	leave  
  801929:	c3                   	ret    

0080192a <sys_cputc>:

void
sys_cputc(const char c)
{
  80192a:	55                   	push   %ebp
  80192b:	89 e5                	mov    %esp,%ebp
  80192d:	83 ec 04             	sub    $0x4,%esp
  801930:	8b 45 08             	mov    0x8(%ebp),%eax
  801933:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801936:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80193a:	6a 00                	push   $0x0
  80193c:	6a 00                	push   $0x0
  80193e:	6a 00                	push   $0x0
  801940:	6a 00                	push   $0x0
  801942:	50                   	push   %eax
  801943:	6a 01                	push   $0x1
  801945:	e8 29 fe ff ff       	call   801773 <syscall>
  80194a:	83 c4 18             	add    $0x18,%esp
}
  80194d:	90                   	nop
  80194e:	c9                   	leave  
  80194f:	c3                   	ret    

00801950 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801950:	55                   	push   %ebp
  801951:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801953:	6a 00                	push   $0x0
  801955:	6a 00                	push   $0x0
  801957:	6a 00                	push   $0x0
  801959:	6a 00                	push   $0x0
  80195b:	6a 00                	push   $0x0
  80195d:	6a 14                	push   $0x14
  80195f:	e8 0f fe ff ff       	call   801773 <syscall>
  801964:	83 c4 18             	add    $0x18,%esp
}
  801967:	90                   	nop
  801968:	c9                   	leave  
  801969:	c3                   	ret    

0080196a <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80196a:	55                   	push   %ebp
  80196b:	89 e5                	mov    %esp,%ebp
  80196d:	83 ec 04             	sub    $0x4,%esp
  801970:	8b 45 10             	mov    0x10(%ebp),%eax
  801973:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801976:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801979:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80197d:	8b 45 08             	mov    0x8(%ebp),%eax
  801980:	6a 00                	push   $0x0
  801982:	51                   	push   %ecx
  801983:	52                   	push   %edx
  801984:	ff 75 0c             	pushl  0xc(%ebp)
  801987:	50                   	push   %eax
  801988:	6a 15                	push   $0x15
  80198a:	e8 e4 fd ff ff       	call   801773 <syscall>
  80198f:	83 c4 18             	add    $0x18,%esp
}
  801992:	c9                   	leave  
  801993:	c3                   	ret    

00801994 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801994:	55                   	push   %ebp
  801995:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801997:	8b 55 0c             	mov    0xc(%ebp),%edx
  80199a:	8b 45 08             	mov    0x8(%ebp),%eax
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	52                   	push   %edx
  8019a4:	50                   	push   %eax
  8019a5:	6a 16                	push   $0x16
  8019a7:	e8 c7 fd ff ff       	call   801773 <syscall>
  8019ac:	83 c4 18             	add    $0x18,%esp
}
  8019af:	c9                   	leave  
  8019b0:	c3                   	ret    

008019b1 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8019b1:	55                   	push   %ebp
  8019b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8019b4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 00                	push   $0x0
  8019c1:	51                   	push   %ecx
  8019c2:	52                   	push   %edx
  8019c3:	50                   	push   %eax
  8019c4:	6a 17                	push   $0x17
  8019c6:	e8 a8 fd ff ff       	call   801773 <syscall>
  8019cb:	83 c4 18             	add    $0x18,%esp
}
  8019ce:	c9                   	leave  
  8019cf:	c3                   	ret    

008019d0 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8019d0:	55                   	push   %ebp
  8019d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8019d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d9:	6a 00                	push   $0x0
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 00                	push   $0x0
  8019df:	52                   	push   %edx
  8019e0:	50                   	push   %eax
  8019e1:	6a 18                	push   $0x18
  8019e3:	e8 8b fd ff ff       	call   801773 <syscall>
  8019e8:	83 c4 18             	add    $0x18,%esp
}
  8019eb:	c9                   	leave  
  8019ec:	c3                   	ret    

008019ed <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8019ed:	55                   	push   %ebp
  8019ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8019f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f3:	6a 00                	push   $0x0
  8019f5:	ff 75 14             	pushl  0x14(%ebp)
  8019f8:	ff 75 10             	pushl  0x10(%ebp)
  8019fb:	ff 75 0c             	pushl  0xc(%ebp)
  8019fe:	50                   	push   %eax
  8019ff:	6a 19                	push   $0x19
  801a01:	e8 6d fd ff ff       	call   801773 <syscall>
  801a06:	83 c4 18             	add    $0x18,%esp
}
  801a09:	c9                   	leave  
  801a0a:	c3                   	ret    

00801a0b <sys_run_env>:

void sys_run_env(int32 envId)
{
  801a0b:	55                   	push   %ebp
  801a0c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a11:	6a 00                	push   $0x0
  801a13:	6a 00                	push   $0x0
  801a15:	6a 00                	push   $0x0
  801a17:	6a 00                	push   $0x0
  801a19:	50                   	push   %eax
  801a1a:	6a 1a                	push   $0x1a
  801a1c:	e8 52 fd ff ff       	call   801773 <syscall>
  801a21:	83 c4 18             	add    $0x18,%esp
}
  801a24:	90                   	nop
  801a25:	c9                   	leave  
  801a26:	c3                   	ret    

00801a27 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801a27:	55                   	push   %ebp
  801a28:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801a2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2d:	6a 00                	push   $0x0
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	50                   	push   %eax
  801a36:	6a 1b                	push   $0x1b
  801a38:	e8 36 fd ff ff       	call   801773 <syscall>
  801a3d:	83 c4 18             	add    $0x18,%esp
}
  801a40:	c9                   	leave  
  801a41:	c3                   	ret    

00801a42 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801a42:	55                   	push   %ebp
  801a43:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801a45:	6a 00                	push   $0x0
  801a47:	6a 00                	push   $0x0
  801a49:	6a 00                	push   $0x0
  801a4b:	6a 00                	push   $0x0
  801a4d:	6a 00                	push   $0x0
  801a4f:	6a 05                	push   $0x5
  801a51:	e8 1d fd ff ff       	call   801773 <syscall>
  801a56:	83 c4 18             	add    $0x18,%esp
}
  801a59:	c9                   	leave  
  801a5a:	c3                   	ret    

00801a5b <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801a5b:	55                   	push   %ebp
  801a5c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 00                	push   $0x0
  801a62:	6a 00                	push   $0x0
  801a64:	6a 00                	push   $0x0
  801a66:	6a 00                	push   $0x0
  801a68:	6a 06                	push   $0x6
  801a6a:	e8 04 fd ff ff       	call   801773 <syscall>
  801a6f:	83 c4 18             	add    $0x18,%esp
}
  801a72:	c9                   	leave  
  801a73:	c3                   	ret    

00801a74 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801a74:	55                   	push   %ebp
  801a75:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801a77:	6a 00                	push   $0x0
  801a79:	6a 00                	push   $0x0
  801a7b:	6a 00                	push   $0x0
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 07                	push   $0x7
  801a83:	e8 eb fc ff ff       	call   801773 <syscall>
  801a88:	83 c4 18             	add    $0x18,%esp
}
  801a8b:	c9                   	leave  
  801a8c:	c3                   	ret    

00801a8d <sys_exit_env>:


void sys_exit_env(void)
{
  801a8d:	55                   	push   %ebp
  801a8e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801a90:	6a 00                	push   $0x0
  801a92:	6a 00                	push   $0x0
  801a94:	6a 00                	push   $0x0
  801a96:	6a 00                	push   $0x0
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 1c                	push   $0x1c
  801a9c:	e8 d2 fc ff ff       	call   801773 <syscall>
  801aa1:	83 c4 18             	add    $0x18,%esp
}
  801aa4:	90                   	nop
  801aa5:	c9                   	leave  
  801aa6:	c3                   	ret    

00801aa7 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801aa7:	55                   	push   %ebp
  801aa8:	89 e5                	mov    %esp,%ebp
  801aaa:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801aad:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ab0:	8d 50 04             	lea    0x4(%eax),%edx
  801ab3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	52                   	push   %edx
  801abd:	50                   	push   %eax
  801abe:	6a 1d                	push   $0x1d
  801ac0:	e8 ae fc ff ff       	call   801773 <syscall>
  801ac5:	83 c4 18             	add    $0x18,%esp
	return result;
  801ac8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801acb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ace:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ad1:	89 01                	mov    %eax,(%ecx)
  801ad3:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801ad6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad9:	c9                   	leave  
  801ada:	c2 04 00             	ret    $0x4

00801add <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801add:	55                   	push   %ebp
  801ade:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 00                	push   $0x0
  801ae4:	ff 75 10             	pushl  0x10(%ebp)
  801ae7:	ff 75 0c             	pushl  0xc(%ebp)
  801aea:	ff 75 08             	pushl  0x8(%ebp)
  801aed:	6a 13                	push   $0x13
  801aef:	e8 7f fc ff ff       	call   801773 <syscall>
  801af4:	83 c4 18             	add    $0x18,%esp
	return ;
  801af7:	90                   	nop
}
  801af8:	c9                   	leave  
  801af9:	c3                   	ret    

00801afa <sys_rcr2>:
uint32 sys_rcr2()
{
  801afa:	55                   	push   %ebp
  801afb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801afd:	6a 00                	push   $0x0
  801aff:	6a 00                	push   $0x0
  801b01:	6a 00                	push   $0x0
  801b03:	6a 00                	push   $0x0
  801b05:	6a 00                	push   $0x0
  801b07:	6a 1e                	push   $0x1e
  801b09:	e8 65 fc ff ff       	call   801773 <syscall>
  801b0e:	83 c4 18             	add    $0x18,%esp
}
  801b11:	c9                   	leave  
  801b12:	c3                   	ret    

00801b13 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801b13:	55                   	push   %ebp
  801b14:	89 e5                	mov    %esp,%ebp
  801b16:	83 ec 04             	sub    $0x4,%esp
  801b19:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801b1f:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	50                   	push   %eax
  801b2c:	6a 1f                	push   $0x1f
  801b2e:	e8 40 fc ff ff       	call   801773 <syscall>
  801b33:	83 c4 18             	add    $0x18,%esp
	return ;
  801b36:	90                   	nop
}
  801b37:	c9                   	leave  
  801b38:	c3                   	ret    

00801b39 <rsttst>:
void rsttst()
{
  801b39:	55                   	push   %ebp
  801b3a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 00                	push   $0x0
  801b42:	6a 00                	push   $0x0
  801b44:	6a 00                	push   $0x0
  801b46:	6a 21                	push   $0x21
  801b48:	e8 26 fc ff ff       	call   801773 <syscall>
  801b4d:	83 c4 18             	add    $0x18,%esp
	return ;
  801b50:	90                   	nop
}
  801b51:	c9                   	leave  
  801b52:	c3                   	ret    

00801b53 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801b53:	55                   	push   %ebp
  801b54:	89 e5                	mov    %esp,%ebp
  801b56:	83 ec 04             	sub    $0x4,%esp
  801b59:	8b 45 14             	mov    0x14(%ebp),%eax
  801b5c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801b5f:	8b 55 18             	mov    0x18(%ebp),%edx
  801b62:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b66:	52                   	push   %edx
  801b67:	50                   	push   %eax
  801b68:	ff 75 10             	pushl  0x10(%ebp)
  801b6b:	ff 75 0c             	pushl  0xc(%ebp)
  801b6e:	ff 75 08             	pushl  0x8(%ebp)
  801b71:	6a 20                	push   $0x20
  801b73:	e8 fb fb ff ff       	call   801773 <syscall>
  801b78:	83 c4 18             	add    $0x18,%esp
	return ;
  801b7b:	90                   	nop
}
  801b7c:	c9                   	leave  
  801b7d:	c3                   	ret    

00801b7e <chktst>:
void chktst(uint32 n)
{
  801b7e:	55                   	push   %ebp
  801b7f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801b81:	6a 00                	push   $0x0
  801b83:	6a 00                	push   $0x0
  801b85:	6a 00                	push   $0x0
  801b87:	6a 00                	push   $0x0
  801b89:	ff 75 08             	pushl  0x8(%ebp)
  801b8c:	6a 22                	push   $0x22
  801b8e:	e8 e0 fb ff ff       	call   801773 <syscall>
  801b93:	83 c4 18             	add    $0x18,%esp
	return ;
  801b96:	90                   	nop
}
  801b97:	c9                   	leave  
  801b98:	c3                   	ret    

00801b99 <inctst>:

void inctst()
{
  801b99:	55                   	push   %ebp
  801b9a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801b9c:	6a 00                	push   $0x0
  801b9e:	6a 00                	push   $0x0
  801ba0:	6a 00                	push   $0x0
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 00                	push   $0x0
  801ba6:	6a 23                	push   $0x23
  801ba8:	e8 c6 fb ff ff       	call   801773 <syscall>
  801bad:	83 c4 18             	add    $0x18,%esp
	return ;
  801bb0:	90                   	nop
}
  801bb1:	c9                   	leave  
  801bb2:	c3                   	ret    

00801bb3 <gettst>:
uint32 gettst()
{
  801bb3:	55                   	push   %ebp
  801bb4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801bb6:	6a 00                	push   $0x0
  801bb8:	6a 00                	push   $0x0
  801bba:	6a 00                	push   $0x0
  801bbc:	6a 00                	push   $0x0
  801bbe:	6a 00                	push   $0x0
  801bc0:	6a 24                	push   $0x24
  801bc2:	e8 ac fb ff ff       	call   801773 <syscall>
  801bc7:	83 c4 18             	add    $0x18,%esp
}
  801bca:	c9                   	leave  
  801bcb:	c3                   	ret    

00801bcc <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801bcc:	55                   	push   %ebp
  801bcd:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bcf:	6a 00                	push   $0x0
  801bd1:	6a 00                	push   $0x0
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 00                	push   $0x0
  801bd9:	6a 25                	push   $0x25
  801bdb:	e8 93 fb ff ff       	call   801773 <syscall>
  801be0:	83 c4 18             	add    $0x18,%esp
  801be3:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801be8:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801bed:	c9                   	leave  
  801bee:	c3                   	ret    

00801bef <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801bef:	55                   	push   %ebp
  801bf0:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801bf2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf5:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801bfa:	6a 00                	push   $0x0
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	ff 75 08             	pushl  0x8(%ebp)
  801c05:	6a 26                	push   $0x26
  801c07:	e8 67 fb ff ff       	call   801773 <syscall>
  801c0c:	83 c4 18             	add    $0x18,%esp
	return ;
  801c0f:	90                   	nop
}
  801c10:	c9                   	leave  
  801c11:	c3                   	ret    

00801c12 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801c12:	55                   	push   %ebp
  801c13:	89 e5                	mov    %esp,%ebp
  801c15:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801c16:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c19:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c1c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c22:	6a 00                	push   $0x0
  801c24:	53                   	push   %ebx
  801c25:	51                   	push   %ecx
  801c26:	52                   	push   %edx
  801c27:	50                   	push   %eax
  801c28:	6a 27                	push   $0x27
  801c2a:	e8 44 fb ff ff       	call   801773 <syscall>
  801c2f:	83 c4 18             	add    $0x18,%esp
}
  801c32:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c35:	c9                   	leave  
  801c36:	c3                   	ret    

00801c37 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801c37:	55                   	push   %ebp
  801c38:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801c3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c40:	6a 00                	push   $0x0
  801c42:	6a 00                	push   $0x0
  801c44:	6a 00                	push   $0x0
  801c46:	52                   	push   %edx
  801c47:	50                   	push   %eax
  801c48:	6a 28                	push   $0x28
  801c4a:	e8 24 fb ff ff       	call   801773 <syscall>
  801c4f:	83 c4 18             	add    $0x18,%esp
}
  801c52:	c9                   	leave  
  801c53:	c3                   	ret    

00801c54 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801c54:	55                   	push   %ebp
  801c55:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801c57:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c60:	6a 00                	push   $0x0
  801c62:	51                   	push   %ecx
  801c63:	ff 75 10             	pushl  0x10(%ebp)
  801c66:	52                   	push   %edx
  801c67:	50                   	push   %eax
  801c68:	6a 29                	push   $0x29
  801c6a:	e8 04 fb ff ff       	call   801773 <syscall>
  801c6f:	83 c4 18             	add    $0x18,%esp
}
  801c72:	c9                   	leave  
  801c73:	c3                   	ret    

00801c74 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801c74:	55                   	push   %ebp
  801c75:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801c77:	6a 00                	push   $0x0
  801c79:	6a 00                	push   $0x0
  801c7b:	ff 75 10             	pushl  0x10(%ebp)
  801c7e:	ff 75 0c             	pushl  0xc(%ebp)
  801c81:	ff 75 08             	pushl  0x8(%ebp)
  801c84:	6a 12                	push   $0x12
  801c86:	e8 e8 fa ff ff       	call   801773 <syscall>
  801c8b:	83 c4 18             	add    $0x18,%esp
	return ;
  801c8e:	90                   	nop
}
  801c8f:	c9                   	leave  
  801c90:	c3                   	ret    

00801c91 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801c91:	55                   	push   %ebp
  801c92:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801c94:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c97:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9a:	6a 00                	push   $0x0
  801c9c:	6a 00                	push   $0x0
  801c9e:	6a 00                	push   $0x0
  801ca0:	52                   	push   %edx
  801ca1:	50                   	push   %eax
  801ca2:	6a 2a                	push   $0x2a
  801ca4:	e8 ca fa ff ff       	call   801773 <syscall>
  801ca9:	83 c4 18             	add    $0x18,%esp
	return;
  801cac:	90                   	nop
}
  801cad:	c9                   	leave  
  801cae:	c3                   	ret    

00801caf <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801caf:	55                   	push   %ebp
  801cb0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 00                	push   $0x0
  801cb6:	6a 00                	push   $0x0
  801cb8:	6a 00                	push   $0x0
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 2b                	push   $0x2b
  801cbe:	e8 b0 fa ff ff       	call   801773 <syscall>
  801cc3:	83 c4 18             	add    $0x18,%esp
}
  801cc6:	c9                   	leave  
  801cc7:	c3                   	ret    

00801cc8 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801cc8:	55                   	push   %ebp
  801cc9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801ccb:	6a 00                	push   $0x0
  801ccd:	6a 00                	push   $0x0
  801ccf:	6a 00                	push   $0x0
  801cd1:	ff 75 0c             	pushl  0xc(%ebp)
  801cd4:	ff 75 08             	pushl  0x8(%ebp)
  801cd7:	6a 2d                	push   $0x2d
  801cd9:	e8 95 fa ff ff       	call   801773 <syscall>
  801cde:	83 c4 18             	add    $0x18,%esp
	return;
  801ce1:	90                   	nop
}
  801ce2:	c9                   	leave  
  801ce3:	c3                   	ret    

00801ce4 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801ce4:	55                   	push   %ebp
  801ce5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801ce7:	6a 00                	push   $0x0
  801ce9:	6a 00                	push   $0x0
  801ceb:	6a 00                	push   $0x0
  801ced:	ff 75 0c             	pushl  0xc(%ebp)
  801cf0:	ff 75 08             	pushl  0x8(%ebp)
  801cf3:	6a 2c                	push   $0x2c
  801cf5:	e8 79 fa ff ff       	call   801773 <syscall>
  801cfa:	83 c4 18             	add    $0x18,%esp
	return ;
  801cfd:	90                   	nop
}
  801cfe:	c9                   	leave  
  801cff:	c3                   	ret    

00801d00 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801d00:	55                   	push   %ebp
  801d01:	89 e5                	mov    %esp,%ebp
  801d03:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801d06:	83 ec 04             	sub    $0x4,%esp
  801d09:	68 94 2a 80 00       	push   $0x802a94
  801d0e:	68 25 01 00 00       	push   $0x125
  801d13:	68 c7 2a 80 00       	push   $0x802ac7
  801d18:	e8 ec e6 ff ff       	call   800409 <_panic>

00801d1d <to_page_va>:
//==================================================================================//
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  801d1d:	55                   	push   %ebp
  801d1e:	89 e5                	mov    %esp,%ebp
  801d20:	83 ec 10             	sub    $0x10,%esp
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  801d23:	8b 45 08             	mov    0x8(%ebp),%eax
  801d26:	ba 60 30 80 00       	mov    $0x803060,%edx
  801d2b:	29 d0                	sub    %edx,%eax
  801d2d:	c1 f8 02             	sar    $0x2,%eax
  801d30:	89 c2                	mov    %eax,%edx
  801d32:	89 d0                	mov    %edx,%eax
  801d34:	c1 e0 02             	shl    $0x2,%eax
  801d37:	01 d0                	add    %edx,%eax
  801d39:	c1 e0 02             	shl    $0x2,%eax
  801d3c:	01 d0                	add    %edx,%eax
  801d3e:	c1 e0 02             	shl    $0x2,%eax
  801d41:	01 d0                	add    %edx,%eax
  801d43:	89 c1                	mov    %eax,%ecx
  801d45:	c1 e1 08             	shl    $0x8,%ecx
  801d48:	01 c8                	add    %ecx,%eax
  801d4a:	89 c1                	mov    %eax,%ecx
  801d4c:	c1 e1 10             	shl    $0x10,%ecx
  801d4f:	01 c8                	add    %ecx,%eax
  801d51:	01 c0                	add    %eax,%eax
  801d53:	01 d0                	add    %edx,%eax
  801d55:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  801d58:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d5b:	c1 e0 0c             	shl    $0xc,%eax
  801d5e:	89 c2                	mov    %eax,%edx
  801d60:	a1 64 b0 81 00       	mov    0x81b064,%eax
  801d65:	01 d0                	add    %edx,%eax
}
  801d67:	c9                   	leave  
  801d68:	c3                   	ret    

00801d69 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  801d69:	55                   	push   %ebp
  801d6a:	89 e5                	mov    %esp,%ebp
  801d6c:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  801d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d72:	05 00 00 00 02       	add    $0x2000000,%eax
  801d77:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801d7a:	73 16                	jae    801d92 <initialize_dynamic_allocator+0x29>
  801d7c:	68 d8 2a 80 00       	push   $0x802ad8
  801d81:	68 fe 2a 80 00       	push   $0x802afe
  801d86:	6a 26                	push   $0x26
  801d88:	68 13 2b 80 00       	push   $0x802b13
  801d8d:	e8 77 e6 ff ff       	call   800409 <_panic>
		is_initialized = 1;
  801d92:	c7 05 24 30 80 00 01 	movl   $0x1,0x803024
  801d99:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	//Comment the following line
	panic("initialize_dynamic_allocator() Not implemented yet");
  801d9c:	83 ec 04             	sub    $0x4,%esp
  801d9f:	68 2c 2b 80 00       	push   $0x802b2c
  801da4:	6a 2e                	push   $0x2e
  801da6:	68 13 2b 80 00       	push   $0x802b13
  801dab:	e8 59 e6 ff ff       	call   800409 <_panic>

00801db0 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  801db0:	55                   	push   %ebp
  801db1:	89 e5                	mov    %esp,%ebp
  801db3:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	//Comment the following line
	panic("get_block_size() Not implemented yet");
  801db6:	83 ec 04             	sub    $0x4,%esp
  801db9:	68 60 2b 80 00       	push   $0x802b60
  801dbe:	6a 3a                	push   $0x3a
  801dc0:	68 13 2b 80 00       	push   $0x802b13
  801dc5:	e8 3f e6 ff ff       	call   800409 <_panic>

00801dca <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  801dca:	55                   	push   %ebp
  801dcb:	89 e5                	mov    %esp,%ebp
  801dcd:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  801dd0:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801dd7:	76 16                	jbe    801def <alloc_block+0x25>
  801dd9:	68 88 2b 80 00       	push   $0x802b88
  801dde:	68 fe 2a 80 00       	push   $0x802afe
  801de3:	6a 46                	push   $0x46
  801de5:	68 13 2b 80 00       	push   $0x802b13
  801dea:	e8 1a e6 ff ff       	call   800409 <_panic>
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	panic("alloc_block() Not implemented yet");
  801def:	83 ec 04             	sub    $0x4,%esp
  801df2:	68 ac 2b 80 00       	push   $0x802bac
  801df7:	6a 4d                	push   $0x4d
  801df9:	68 13 2b 80 00       	push   $0x802b13
  801dfe:	e8 06 e6 ff ff       	call   800409 <_panic>

00801e03 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  801e03:	55                   	push   %ebp
  801e04:	89 e5                	mov    %esp,%ebp
  801e06:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  801e09:	8b 55 08             	mov    0x8(%ebp),%edx
  801e0c:	a1 64 b0 81 00       	mov    0x81b064,%eax
  801e11:	39 c2                	cmp    %eax,%edx
  801e13:	72 0c                	jb     801e21 <free_block+0x1e>
  801e15:	8b 55 08             	mov    0x8(%ebp),%edx
  801e18:	a1 40 30 80 00       	mov    0x803040,%eax
  801e1d:	39 c2                	cmp    %eax,%edx
  801e1f:	72 16                	jb     801e37 <free_block+0x34>
  801e21:	68 d0 2b 80 00       	push   $0x802bd0
  801e26:	68 fe 2a 80 00       	push   $0x802afe
  801e2b:	6a 5b                	push   $0x5b
  801e2d:	68 13 2b 80 00       	push   $0x802b13
  801e32:	e8 d2 e5 ff ff       	call   800409 <_panic>
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	panic("free_block() Not implemented yet");
  801e37:	83 ec 04             	sub    $0x4,%esp
  801e3a:	68 08 2c 80 00       	push   $0x802c08
  801e3f:	6a 63                	push   $0x63
  801e41:	68 13 2b 80 00       	push   $0x802b13
  801e46:	e8 be e5 ff ff       	call   800409 <_panic>

00801e4b <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  801e4b:	55                   	push   %ebp
  801e4c:	89 e5                	mov    %esp,%ebp
  801e4e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  801e51:	83 ec 04             	sub    $0x4,%esp
  801e54:	68 2c 2c 80 00       	push   $0x802c2c
  801e59:	6a 72                	push   $0x72
  801e5b:	68 13 2b 80 00       	push   $0x802b13
  801e60:	e8 a4 e5 ff ff       	call   800409 <_panic>
  801e65:	66 90                	xchg   %ax,%ax
  801e67:	90                   	nop

00801e68 <__udivdi3>:
  801e68:	55                   	push   %ebp
  801e69:	57                   	push   %edi
  801e6a:	56                   	push   %esi
  801e6b:	53                   	push   %ebx
  801e6c:	83 ec 1c             	sub    $0x1c,%esp
  801e6f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801e73:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801e77:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801e7b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e7f:	89 ca                	mov    %ecx,%edx
  801e81:	89 f8                	mov    %edi,%eax
  801e83:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801e87:	85 f6                	test   %esi,%esi
  801e89:	75 2d                	jne    801eb8 <__udivdi3+0x50>
  801e8b:	39 cf                	cmp    %ecx,%edi
  801e8d:	77 65                	ja     801ef4 <__udivdi3+0x8c>
  801e8f:	89 fd                	mov    %edi,%ebp
  801e91:	85 ff                	test   %edi,%edi
  801e93:	75 0b                	jne    801ea0 <__udivdi3+0x38>
  801e95:	b8 01 00 00 00       	mov    $0x1,%eax
  801e9a:	31 d2                	xor    %edx,%edx
  801e9c:	f7 f7                	div    %edi
  801e9e:	89 c5                	mov    %eax,%ebp
  801ea0:	31 d2                	xor    %edx,%edx
  801ea2:	89 c8                	mov    %ecx,%eax
  801ea4:	f7 f5                	div    %ebp
  801ea6:	89 c1                	mov    %eax,%ecx
  801ea8:	89 d8                	mov    %ebx,%eax
  801eaa:	f7 f5                	div    %ebp
  801eac:	89 cf                	mov    %ecx,%edi
  801eae:	89 fa                	mov    %edi,%edx
  801eb0:	83 c4 1c             	add    $0x1c,%esp
  801eb3:	5b                   	pop    %ebx
  801eb4:	5e                   	pop    %esi
  801eb5:	5f                   	pop    %edi
  801eb6:	5d                   	pop    %ebp
  801eb7:	c3                   	ret    
  801eb8:	39 ce                	cmp    %ecx,%esi
  801eba:	77 28                	ja     801ee4 <__udivdi3+0x7c>
  801ebc:	0f bd fe             	bsr    %esi,%edi
  801ebf:	83 f7 1f             	xor    $0x1f,%edi
  801ec2:	75 40                	jne    801f04 <__udivdi3+0x9c>
  801ec4:	39 ce                	cmp    %ecx,%esi
  801ec6:	72 0a                	jb     801ed2 <__udivdi3+0x6a>
  801ec8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801ecc:	0f 87 9e 00 00 00    	ja     801f70 <__udivdi3+0x108>
  801ed2:	b8 01 00 00 00       	mov    $0x1,%eax
  801ed7:	89 fa                	mov    %edi,%edx
  801ed9:	83 c4 1c             	add    $0x1c,%esp
  801edc:	5b                   	pop    %ebx
  801edd:	5e                   	pop    %esi
  801ede:	5f                   	pop    %edi
  801edf:	5d                   	pop    %ebp
  801ee0:	c3                   	ret    
  801ee1:	8d 76 00             	lea    0x0(%esi),%esi
  801ee4:	31 ff                	xor    %edi,%edi
  801ee6:	31 c0                	xor    %eax,%eax
  801ee8:	89 fa                	mov    %edi,%edx
  801eea:	83 c4 1c             	add    $0x1c,%esp
  801eed:	5b                   	pop    %ebx
  801eee:	5e                   	pop    %esi
  801eef:	5f                   	pop    %edi
  801ef0:	5d                   	pop    %ebp
  801ef1:	c3                   	ret    
  801ef2:	66 90                	xchg   %ax,%ax
  801ef4:	89 d8                	mov    %ebx,%eax
  801ef6:	f7 f7                	div    %edi
  801ef8:	31 ff                	xor    %edi,%edi
  801efa:	89 fa                	mov    %edi,%edx
  801efc:	83 c4 1c             	add    $0x1c,%esp
  801eff:	5b                   	pop    %ebx
  801f00:	5e                   	pop    %esi
  801f01:	5f                   	pop    %edi
  801f02:	5d                   	pop    %ebp
  801f03:	c3                   	ret    
  801f04:	bd 20 00 00 00       	mov    $0x20,%ebp
  801f09:	89 eb                	mov    %ebp,%ebx
  801f0b:	29 fb                	sub    %edi,%ebx
  801f0d:	89 f9                	mov    %edi,%ecx
  801f0f:	d3 e6                	shl    %cl,%esi
  801f11:	89 c5                	mov    %eax,%ebp
  801f13:	88 d9                	mov    %bl,%cl
  801f15:	d3 ed                	shr    %cl,%ebp
  801f17:	89 e9                	mov    %ebp,%ecx
  801f19:	09 f1                	or     %esi,%ecx
  801f1b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801f1f:	89 f9                	mov    %edi,%ecx
  801f21:	d3 e0                	shl    %cl,%eax
  801f23:	89 c5                	mov    %eax,%ebp
  801f25:	89 d6                	mov    %edx,%esi
  801f27:	88 d9                	mov    %bl,%cl
  801f29:	d3 ee                	shr    %cl,%esi
  801f2b:	89 f9                	mov    %edi,%ecx
  801f2d:	d3 e2                	shl    %cl,%edx
  801f2f:	8b 44 24 08          	mov    0x8(%esp),%eax
  801f33:	88 d9                	mov    %bl,%cl
  801f35:	d3 e8                	shr    %cl,%eax
  801f37:	09 c2                	or     %eax,%edx
  801f39:	89 d0                	mov    %edx,%eax
  801f3b:	89 f2                	mov    %esi,%edx
  801f3d:	f7 74 24 0c          	divl   0xc(%esp)
  801f41:	89 d6                	mov    %edx,%esi
  801f43:	89 c3                	mov    %eax,%ebx
  801f45:	f7 e5                	mul    %ebp
  801f47:	39 d6                	cmp    %edx,%esi
  801f49:	72 19                	jb     801f64 <__udivdi3+0xfc>
  801f4b:	74 0b                	je     801f58 <__udivdi3+0xf0>
  801f4d:	89 d8                	mov    %ebx,%eax
  801f4f:	31 ff                	xor    %edi,%edi
  801f51:	e9 58 ff ff ff       	jmp    801eae <__udivdi3+0x46>
  801f56:	66 90                	xchg   %ax,%ax
  801f58:	8b 54 24 08          	mov    0x8(%esp),%edx
  801f5c:	89 f9                	mov    %edi,%ecx
  801f5e:	d3 e2                	shl    %cl,%edx
  801f60:	39 c2                	cmp    %eax,%edx
  801f62:	73 e9                	jae    801f4d <__udivdi3+0xe5>
  801f64:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801f67:	31 ff                	xor    %edi,%edi
  801f69:	e9 40 ff ff ff       	jmp    801eae <__udivdi3+0x46>
  801f6e:	66 90                	xchg   %ax,%ax
  801f70:	31 c0                	xor    %eax,%eax
  801f72:	e9 37 ff ff ff       	jmp    801eae <__udivdi3+0x46>
  801f77:	90                   	nop

00801f78 <__umoddi3>:
  801f78:	55                   	push   %ebp
  801f79:	57                   	push   %edi
  801f7a:	56                   	push   %esi
  801f7b:	53                   	push   %ebx
  801f7c:	83 ec 1c             	sub    $0x1c,%esp
  801f7f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801f83:	8b 74 24 34          	mov    0x34(%esp),%esi
  801f87:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801f8b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801f8f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801f93:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801f97:	89 f3                	mov    %esi,%ebx
  801f99:	89 fa                	mov    %edi,%edx
  801f9b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801f9f:	89 34 24             	mov    %esi,(%esp)
  801fa2:	85 c0                	test   %eax,%eax
  801fa4:	75 1a                	jne    801fc0 <__umoddi3+0x48>
  801fa6:	39 f7                	cmp    %esi,%edi
  801fa8:	0f 86 a2 00 00 00    	jbe    802050 <__umoddi3+0xd8>
  801fae:	89 c8                	mov    %ecx,%eax
  801fb0:	89 f2                	mov    %esi,%edx
  801fb2:	f7 f7                	div    %edi
  801fb4:	89 d0                	mov    %edx,%eax
  801fb6:	31 d2                	xor    %edx,%edx
  801fb8:	83 c4 1c             	add    $0x1c,%esp
  801fbb:	5b                   	pop    %ebx
  801fbc:	5e                   	pop    %esi
  801fbd:	5f                   	pop    %edi
  801fbe:	5d                   	pop    %ebp
  801fbf:	c3                   	ret    
  801fc0:	39 f0                	cmp    %esi,%eax
  801fc2:	0f 87 ac 00 00 00    	ja     802074 <__umoddi3+0xfc>
  801fc8:	0f bd e8             	bsr    %eax,%ebp
  801fcb:	83 f5 1f             	xor    $0x1f,%ebp
  801fce:	0f 84 ac 00 00 00    	je     802080 <__umoddi3+0x108>
  801fd4:	bf 20 00 00 00       	mov    $0x20,%edi
  801fd9:	29 ef                	sub    %ebp,%edi
  801fdb:	89 fe                	mov    %edi,%esi
  801fdd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801fe1:	89 e9                	mov    %ebp,%ecx
  801fe3:	d3 e0                	shl    %cl,%eax
  801fe5:	89 d7                	mov    %edx,%edi
  801fe7:	89 f1                	mov    %esi,%ecx
  801fe9:	d3 ef                	shr    %cl,%edi
  801feb:	09 c7                	or     %eax,%edi
  801fed:	89 e9                	mov    %ebp,%ecx
  801fef:	d3 e2                	shl    %cl,%edx
  801ff1:	89 14 24             	mov    %edx,(%esp)
  801ff4:	89 d8                	mov    %ebx,%eax
  801ff6:	d3 e0                	shl    %cl,%eax
  801ff8:	89 c2                	mov    %eax,%edx
  801ffa:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ffe:	d3 e0                	shl    %cl,%eax
  802000:	89 44 24 04          	mov    %eax,0x4(%esp)
  802004:	8b 44 24 08          	mov    0x8(%esp),%eax
  802008:	89 f1                	mov    %esi,%ecx
  80200a:	d3 e8                	shr    %cl,%eax
  80200c:	09 d0                	or     %edx,%eax
  80200e:	d3 eb                	shr    %cl,%ebx
  802010:	89 da                	mov    %ebx,%edx
  802012:	f7 f7                	div    %edi
  802014:	89 d3                	mov    %edx,%ebx
  802016:	f7 24 24             	mull   (%esp)
  802019:	89 c6                	mov    %eax,%esi
  80201b:	89 d1                	mov    %edx,%ecx
  80201d:	39 d3                	cmp    %edx,%ebx
  80201f:	0f 82 87 00 00 00    	jb     8020ac <__umoddi3+0x134>
  802025:	0f 84 91 00 00 00    	je     8020bc <__umoddi3+0x144>
  80202b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80202f:	29 f2                	sub    %esi,%edx
  802031:	19 cb                	sbb    %ecx,%ebx
  802033:	89 d8                	mov    %ebx,%eax
  802035:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802039:	d3 e0                	shl    %cl,%eax
  80203b:	89 e9                	mov    %ebp,%ecx
  80203d:	d3 ea                	shr    %cl,%edx
  80203f:	09 d0                	or     %edx,%eax
  802041:	89 e9                	mov    %ebp,%ecx
  802043:	d3 eb                	shr    %cl,%ebx
  802045:	89 da                	mov    %ebx,%edx
  802047:	83 c4 1c             	add    $0x1c,%esp
  80204a:	5b                   	pop    %ebx
  80204b:	5e                   	pop    %esi
  80204c:	5f                   	pop    %edi
  80204d:	5d                   	pop    %ebp
  80204e:	c3                   	ret    
  80204f:	90                   	nop
  802050:	89 fd                	mov    %edi,%ebp
  802052:	85 ff                	test   %edi,%edi
  802054:	75 0b                	jne    802061 <__umoddi3+0xe9>
  802056:	b8 01 00 00 00       	mov    $0x1,%eax
  80205b:	31 d2                	xor    %edx,%edx
  80205d:	f7 f7                	div    %edi
  80205f:	89 c5                	mov    %eax,%ebp
  802061:	89 f0                	mov    %esi,%eax
  802063:	31 d2                	xor    %edx,%edx
  802065:	f7 f5                	div    %ebp
  802067:	89 c8                	mov    %ecx,%eax
  802069:	f7 f5                	div    %ebp
  80206b:	89 d0                	mov    %edx,%eax
  80206d:	e9 44 ff ff ff       	jmp    801fb6 <__umoddi3+0x3e>
  802072:	66 90                	xchg   %ax,%ax
  802074:	89 c8                	mov    %ecx,%eax
  802076:	89 f2                	mov    %esi,%edx
  802078:	83 c4 1c             	add    $0x1c,%esp
  80207b:	5b                   	pop    %ebx
  80207c:	5e                   	pop    %esi
  80207d:	5f                   	pop    %edi
  80207e:	5d                   	pop    %ebp
  80207f:	c3                   	ret    
  802080:	3b 04 24             	cmp    (%esp),%eax
  802083:	72 06                	jb     80208b <__umoddi3+0x113>
  802085:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802089:	77 0f                	ja     80209a <__umoddi3+0x122>
  80208b:	89 f2                	mov    %esi,%edx
  80208d:	29 f9                	sub    %edi,%ecx
  80208f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802093:	89 14 24             	mov    %edx,(%esp)
  802096:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80209a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80209e:	8b 14 24             	mov    (%esp),%edx
  8020a1:	83 c4 1c             	add    $0x1c,%esp
  8020a4:	5b                   	pop    %ebx
  8020a5:	5e                   	pop    %esi
  8020a6:	5f                   	pop    %edi
  8020a7:	5d                   	pop    %ebp
  8020a8:	c3                   	ret    
  8020a9:	8d 76 00             	lea    0x0(%esi),%esi
  8020ac:	2b 04 24             	sub    (%esp),%eax
  8020af:	19 fa                	sbb    %edi,%edx
  8020b1:	89 d1                	mov    %edx,%ecx
  8020b3:	89 c6                	mov    %eax,%esi
  8020b5:	e9 71 ff ff ff       	jmp    80202b <__umoddi3+0xb3>
  8020ba:	66 90                	xchg   %ax,%ax
  8020bc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8020c0:	72 ea                	jb     8020ac <__umoddi3+0x134>
  8020c2:	89 d9                	mov    %ebx,%ecx
  8020c4:	e9 62 ff ff ff       	jmp    80202b <__umoddi3+0xb3>

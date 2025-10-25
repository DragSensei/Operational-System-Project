
obj/user/tst_sharing_3:     file format elf32-i386


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
  800031:	e8 45 02 00 00       	call   80027b <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the SPECIAL CASES during the creation & get of shared variables
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 38             	sub    $0x38,%esp
	/*=================================================*/
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
#if USE_KHEAP
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  80003e:	a1 20 30 80 00       	mov    0x803020,%eax
  800043:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
  800049:	a1 20 30 80 00       	mov    0x803020,%eax
  80004e:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800054:	39 c2                	cmp    %eax,%edx
  800056:	72 14                	jb     80006c <_main+0x34>
			panic("Please increase the WS size");
  800058:	83 ec 04             	sub    $0x4,%esp
  80005b:	68 00 21 80 00       	push   $0x802100
  800060:	6a 0c                	push   $0xc
  800062:	68 1c 21 80 00       	push   $0x80211c
  800067:	e8 bf 03 00 00       	call   80042b <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	cprintf("************************************************\n");
  80006c:	83 ec 0c             	sub    $0xc,%esp
  80006f:	68 34 21 80 00       	push   $0x802134
  800074:	e8 80 06 00 00       	call   8006f9 <cprintf>
  800079:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  80007c:	83 ec 0c             	sub    $0xc,%esp
  80007f:	68 68 21 80 00       	push   $0x802168
  800084:	e8 70 06 00 00       	call   8006f9 <cprintf>
  800089:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  80008c:	83 ec 0c             	sub    $0xc,%esp
  80008f:	68 c4 21 80 00       	push   $0x8021c4
  800094:	e8 60 06 00 00       	call   8006f9 <cprintf>
  800099:	83 c4 10             	add    $0x10,%esp

	int eval = 0;
  80009c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	bool is_correct = 1;
  8000a3:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  8000aa:	c7 45 ec 00 10 00 82 	movl   $0x82001000,-0x14(%ebp)

	uint32 *x, *y, *z ;
	cprintf("STEP A: checking creation of shared object that is already exists... [35%] \n\n");
  8000b1:	83 ec 0c             	sub    $0xc,%esp
  8000b4:	68 f8 21 80 00       	push   $0x8021f8
  8000b9:	e8 3b 06 00 00       	call   8006f9 <cprintf>
  8000be:	83 c4 10             	add    $0x10,%esp
	{
		int ret ;
		//int ret = sys_createSharedObject("x", PAGE_SIZE, 1, (void*)&x);
		x = smalloc("x", PAGE_SIZE, 1);
  8000c1:	83 ec 04             	sub    $0x4,%esp
  8000c4:	6a 01                	push   $0x1
  8000c6:	68 00 10 00 00       	push   $0x1000
  8000cb:	68 46 22 80 00       	push   $0x802246
  8000d0:	e8 2e 16 00 00       	call   801703 <smalloc>
  8000d5:	83 c4 10             	add    $0x10,%esp
  8000d8:	89 45 e8             	mov    %eax,-0x18(%ebp)
		int freeFrames = sys_calculate_free_frames() ;
  8000db:	e8 d4 17 00 00       	call   8018b4 <sys_calculate_free_frames>
  8000e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8000e3:	83 ec 04             	sub    $0x4,%esp
  8000e6:	6a 01                	push   $0x1
  8000e8:	68 00 10 00 00       	push   $0x1000
  8000ed:	68 46 22 80 00       	push   $0x802246
  8000f2:	e8 0c 16 00 00       	call   801703 <smalloc>
  8000f7:	83 c4 10             	add    $0x10,%esp
  8000fa:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (x != NULL) {is_correct = 0; cprintf("Trying to create an already exists object and corresponding error is not returned!!");}
  8000fd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800101:	74 17                	je     80011a <_main+0xe2>
  800103:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80010a:	83 ec 0c             	sub    $0xc,%esp
  80010d:	68 48 22 80 00       	push   $0x802248
  800112:	e8 e2 05 00 00       	call   8006f9 <cprintf>
  800117:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) {is_correct = 0; cprintf("Wrong allocation: make sure that you don't allocate any memory if the shared object exists");}
  80011a:	e8 95 17 00 00       	call   8018b4 <sys_calculate_free_frames>
  80011f:	89 c2                	mov    %eax,%edx
  800121:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800124:	39 c2                	cmp    %eax,%edx
  800126:	74 17                	je     80013f <_main+0x107>
  800128:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80012f:	83 ec 0c             	sub    $0xc,%esp
  800132:	68 9c 22 80 00       	push   $0x80229c
  800137:	e8 bd 05 00 00       	call   8006f9 <cprintf>
  80013c:	83 c4 10             	add    $0x10,%esp
	}
	if (is_correct)	eval+=35;
  80013f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800143:	74 04                	je     800149 <_main+0x111>
  800145:	83 45 f4 23          	addl   $0x23,-0xc(%ebp)
	is_correct = 1;
  800149:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	cprintf("STEP B: checking getting shared object that is NOT exists... [35%]\n\n");
  800150:	83 ec 0c             	sub    $0xc,%esp
  800153:	68 f8 22 80 00       	push   $0x8022f8
  800158:	e8 9c 05 00 00       	call   8006f9 <cprintf>
  80015d:	83 c4 10             	add    $0x10,%esp
	{
		int ret ;
		x = sget(myEnv->env_id, "xx");
  800160:	a1 20 30 80 00       	mov    0x803020,%eax
  800165:	8b 40 10             	mov    0x10(%eax),%eax
  800168:	83 ec 08             	sub    $0x8,%esp
  80016b:	68 3d 23 80 00       	push   $0x80233d
  800170:	50                   	push   %eax
  800171:	e8 c1 15 00 00       	call   801737 <sget>
  800176:	83 c4 10             	add    $0x10,%esp
  800179:	89 45 e8             	mov    %eax,-0x18(%ebp)
		int freeFrames = sys_calculate_free_frames() ;
  80017c:	e8 33 17 00 00       	call   8018b4 <sys_calculate_free_frames>
  800181:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (x != NULL) {is_correct = 0; cprintf("Trying to get a NON existing object and corresponding error is not returned!!");}
  800184:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800188:	74 17                	je     8001a1 <_main+0x169>
  80018a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800191:	83 ec 0c             	sub    $0xc,%esp
  800194:	68 40 23 80 00       	push   $0x802340
  800199:	e8 5b 05 00 00       	call   8006f9 <cprintf>
  80019e:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) {is_correct = 0; cprintf("Wrong get: make sure that you don't allocate any memory if the shared object not exists");}
  8001a1:	e8 0e 17 00 00       	call   8018b4 <sys_calculate_free_frames>
  8001a6:	89 c2                	mov    %eax,%edx
  8001a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001ab:	39 c2                	cmp    %eax,%edx
  8001ad:	74 17                	je     8001c6 <_main+0x18e>
  8001af:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001b6:	83 ec 0c             	sub    $0xc,%esp
  8001b9:	68 90 23 80 00       	push   $0x802390
  8001be:	e8 36 05 00 00       	call   8006f9 <cprintf>
  8001c3:	83 c4 10             	add    $0x10,%esp
	}
	if (is_correct)	eval+=35;
  8001c6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8001ca:	74 04                	je     8001d0 <_main+0x198>
  8001cc:	83 45 f4 23          	addl   $0x23,-0xc(%ebp)
	is_correct = 1;
  8001d0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	cprintf("STEP C: checking the creation of shared object that exceeds the SHARED area limit... [30%]\n\n");
  8001d7:	83 ec 0c             	sub    $0xc,%esp
  8001da:	68 e8 23 80 00       	push   $0x8023e8
  8001df:	e8 15 05 00 00       	call   8006f9 <cprintf>
  8001e4:	83 c4 10             	add    $0x10,%esp
	{
		int freeFrames = sys_calculate_free_frames() ;
  8001e7:	e8 c8 16 00 00       	call   8018b4 <sys_calculate_free_frames>
  8001ec:	89 45 dc             	mov    %eax,-0x24(%ebp)
		uint32 size = USER_HEAP_MAX - pagealloc_start - PAGE_SIZE + 1;
  8001ef:	b8 01 f0 ff 9f       	mov    $0x9ffff001,%eax
  8001f4:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8001f7:	89 45 d8             	mov    %eax,-0x28(%ebp)
		y = smalloc("y", size, 1);
  8001fa:	83 ec 04             	sub    $0x4,%esp
  8001fd:	6a 01                	push   $0x1
  8001ff:	ff 75 d8             	pushl  -0x28(%ebp)
  800202:	68 45 24 80 00       	push   $0x802445
  800207:	e8 f7 14 00 00       	call   801703 <smalloc>
  80020c:	83 c4 10             	add    $0x10,%esp
  80020f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if (y != NULL) {is_correct = 0; cprintf("Trying to create a shared object that exceed the SHARED area limit and the corresponding error is not returned!!");}
  800212:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800216:	74 17                	je     80022f <_main+0x1f7>
  800218:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80021f:	83 ec 0c             	sub    $0xc,%esp
  800222:	68 48 24 80 00       	push   $0x802448
  800227:	e8 cd 04 00 00       	call   8006f9 <cprintf>
  80022c:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) {is_correct = 0; cprintf("Wrong allocation: make sure that you don't allocate any memory if the shared object exceed the SHARED area limit");}
  80022f:	e8 80 16 00 00       	call   8018b4 <sys_calculate_free_frames>
  800234:	89 c2                	mov    %eax,%edx
  800236:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800239:	39 c2                	cmp    %eax,%edx
  80023b:	74 17                	je     800254 <_main+0x21c>
  80023d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800244:	83 ec 0c             	sub    $0xc,%esp
  800247:	68 bc 24 80 00       	push   $0x8024bc
  80024c:	e8 a8 04 00 00       	call   8006f9 <cprintf>
  800251:	83 c4 10             	add    $0x10,%esp
	}
	if (is_correct)	eval+=30;
  800254:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800258:	74 04                	je     80025e <_main+0x226>
  80025a:	83 45 f4 1e          	addl   $0x1e,-0xc(%ebp)
	is_correct = 1;
  80025e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	cprintf("\n%~Test of Shared Variables [Create & Get: Special Cases] completed. Eval = %d%%\n\n", eval);
  800265:	83 ec 08             	sub    $0x8,%esp
  800268:	ff 75 f4             	pushl  -0xc(%ebp)
  80026b:	68 30 25 80 00       	push   $0x802530
  800270:	e8 84 04 00 00       	call   8006f9 <cprintf>
  800275:	83 c4 10             	add    $0x10,%esp

}
  800278:	90                   	nop
  800279:	c9                   	leave  
  80027a:	c3                   	ret    

0080027b <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80027b:	55                   	push   %ebp
  80027c:	89 e5                	mov    %esp,%ebp
  80027e:	57                   	push   %edi
  80027f:	56                   	push   %esi
  800280:	53                   	push   %ebx
  800281:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800284:	e8 f4 17 00 00       	call   801a7d <sys_getenvindex>
  800289:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  80028c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80028f:	89 d0                	mov    %edx,%eax
  800291:	c1 e0 02             	shl    $0x2,%eax
  800294:	01 d0                	add    %edx,%eax
  800296:	c1 e0 03             	shl    $0x3,%eax
  800299:	01 d0                	add    %edx,%eax
  80029b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8002a2:	01 d0                	add    %edx,%eax
  8002a4:	c1 e0 02             	shl    $0x2,%eax
  8002a7:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002ac:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8002b1:	a1 20 30 80 00       	mov    0x803020,%eax
  8002b6:	8a 40 20             	mov    0x20(%eax),%al
  8002b9:	84 c0                	test   %al,%al
  8002bb:	74 0d                	je     8002ca <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8002bd:	a1 20 30 80 00       	mov    0x803020,%eax
  8002c2:	83 c0 20             	add    $0x20,%eax
  8002c5:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002ca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8002ce:	7e 0a                	jle    8002da <libmain+0x5f>
		binaryname = argv[0];
  8002d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002d3:	8b 00                	mov    (%eax),%eax
  8002d5:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  8002da:	83 ec 08             	sub    $0x8,%esp
  8002dd:	ff 75 0c             	pushl  0xc(%ebp)
  8002e0:	ff 75 08             	pushl  0x8(%ebp)
  8002e3:	e8 50 fd ff ff       	call   800038 <_main>
  8002e8:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8002eb:	a1 00 30 80 00       	mov    0x803000,%eax
  8002f0:	85 c0                	test   %eax,%eax
  8002f2:	0f 84 01 01 00 00    	je     8003f9 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8002f8:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8002fe:	bb 7c 26 80 00       	mov    $0x80267c,%ebx
  800303:	ba 0e 00 00 00       	mov    $0xe,%edx
  800308:	89 c7                	mov    %eax,%edi
  80030a:	89 de                	mov    %ebx,%esi
  80030c:	89 d1                	mov    %edx,%ecx
  80030e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800310:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800313:	b9 56 00 00 00       	mov    $0x56,%ecx
  800318:	b0 00                	mov    $0x0,%al
  80031a:	89 d7                	mov    %edx,%edi
  80031c:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80031e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800325:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800328:	83 ec 08             	sub    $0x8,%esp
  80032b:	50                   	push   %eax
  80032c:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800332:	50                   	push   %eax
  800333:	e8 7b 19 00 00       	call   801cb3 <sys_utilities>
  800338:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  80033b:	e8 c4 14 00 00       	call   801804 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800340:	83 ec 0c             	sub    $0xc,%esp
  800343:	68 9c 25 80 00       	push   $0x80259c
  800348:	e8 ac 03 00 00       	call   8006f9 <cprintf>
  80034d:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800350:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800353:	85 c0                	test   %eax,%eax
  800355:	74 18                	je     80036f <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800357:	e8 75 19 00 00       	call   801cd1 <sys_get_optimal_num_faults>
  80035c:	83 ec 08             	sub    $0x8,%esp
  80035f:	50                   	push   %eax
  800360:	68 c4 25 80 00       	push   $0x8025c4
  800365:	e8 8f 03 00 00       	call   8006f9 <cprintf>
  80036a:	83 c4 10             	add    $0x10,%esp
  80036d:	eb 59                	jmp    8003c8 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80036f:	a1 20 30 80 00       	mov    0x803020,%eax
  800374:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  80037a:	a1 20 30 80 00       	mov    0x803020,%eax
  80037f:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  800385:	83 ec 04             	sub    $0x4,%esp
  800388:	52                   	push   %edx
  800389:	50                   	push   %eax
  80038a:	68 e8 25 80 00       	push   $0x8025e8
  80038f:	e8 65 03 00 00       	call   8006f9 <cprintf>
  800394:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800397:	a1 20 30 80 00       	mov    0x803020,%eax
  80039c:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8003a2:	a1 20 30 80 00       	mov    0x803020,%eax
  8003a7:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  8003ad:	a1 20 30 80 00       	mov    0x803020,%eax
  8003b2:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  8003b8:	51                   	push   %ecx
  8003b9:	52                   	push   %edx
  8003ba:	50                   	push   %eax
  8003bb:	68 10 26 80 00       	push   $0x802610
  8003c0:	e8 34 03 00 00       	call   8006f9 <cprintf>
  8003c5:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8003c8:	a1 20 30 80 00       	mov    0x803020,%eax
  8003cd:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  8003d3:	83 ec 08             	sub    $0x8,%esp
  8003d6:	50                   	push   %eax
  8003d7:	68 68 26 80 00       	push   $0x802668
  8003dc:	e8 18 03 00 00       	call   8006f9 <cprintf>
  8003e1:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8003e4:	83 ec 0c             	sub    $0xc,%esp
  8003e7:	68 9c 25 80 00       	push   $0x80259c
  8003ec:	e8 08 03 00 00       	call   8006f9 <cprintf>
  8003f1:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8003f4:	e8 25 14 00 00       	call   80181e <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8003f9:	e8 1f 00 00 00       	call   80041d <exit>
}
  8003fe:	90                   	nop
  8003ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800402:	5b                   	pop    %ebx
  800403:	5e                   	pop    %esi
  800404:	5f                   	pop    %edi
  800405:	5d                   	pop    %ebp
  800406:	c3                   	ret    

00800407 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800407:	55                   	push   %ebp
  800408:	89 e5                	mov    %esp,%ebp
  80040a:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80040d:	83 ec 0c             	sub    $0xc,%esp
  800410:	6a 00                	push   $0x0
  800412:	e8 32 16 00 00       	call   801a49 <sys_destroy_env>
  800417:	83 c4 10             	add    $0x10,%esp
}
  80041a:	90                   	nop
  80041b:	c9                   	leave  
  80041c:	c3                   	ret    

0080041d <exit>:

void
exit(void)
{
  80041d:	55                   	push   %ebp
  80041e:	89 e5                	mov    %esp,%ebp
  800420:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800423:	e8 87 16 00 00       	call   801aaf <sys_exit_env>
}
  800428:	90                   	nop
  800429:	c9                   	leave  
  80042a:	c3                   	ret    

0080042b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80042b:	55                   	push   %ebp
  80042c:	89 e5                	mov    %esp,%ebp
  80042e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800431:	8d 45 10             	lea    0x10(%ebp),%eax
  800434:	83 c0 04             	add    $0x4,%eax
  800437:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80043a:	a1 18 b1 81 00       	mov    0x81b118,%eax
  80043f:	85 c0                	test   %eax,%eax
  800441:	74 16                	je     800459 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800443:	a1 18 b1 81 00       	mov    0x81b118,%eax
  800448:	83 ec 08             	sub    $0x8,%esp
  80044b:	50                   	push   %eax
  80044c:	68 e0 26 80 00       	push   $0x8026e0
  800451:	e8 a3 02 00 00       	call   8006f9 <cprintf>
  800456:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800459:	a1 04 30 80 00       	mov    0x803004,%eax
  80045e:	83 ec 0c             	sub    $0xc,%esp
  800461:	ff 75 0c             	pushl  0xc(%ebp)
  800464:	ff 75 08             	pushl  0x8(%ebp)
  800467:	50                   	push   %eax
  800468:	68 e8 26 80 00       	push   $0x8026e8
  80046d:	6a 74                	push   $0x74
  80046f:	e8 b2 02 00 00       	call   800726 <cprintf_colored>
  800474:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800477:	8b 45 10             	mov    0x10(%ebp),%eax
  80047a:	83 ec 08             	sub    $0x8,%esp
  80047d:	ff 75 f4             	pushl  -0xc(%ebp)
  800480:	50                   	push   %eax
  800481:	e8 04 02 00 00       	call   80068a <vcprintf>
  800486:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800489:	83 ec 08             	sub    $0x8,%esp
  80048c:	6a 00                	push   $0x0
  80048e:	68 10 27 80 00       	push   $0x802710
  800493:	e8 f2 01 00 00       	call   80068a <vcprintf>
  800498:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80049b:	e8 7d ff ff ff       	call   80041d <exit>

	// should not return here
	while (1) ;
  8004a0:	eb fe                	jmp    8004a0 <_panic+0x75>

008004a2 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8004a2:	55                   	push   %ebp
  8004a3:	89 e5                	mov    %esp,%ebp
  8004a5:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8004a8:	a1 20 30 80 00       	mov    0x803020,%eax
  8004ad:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b6:	39 c2                	cmp    %eax,%edx
  8004b8:	74 14                	je     8004ce <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8004ba:	83 ec 04             	sub    $0x4,%esp
  8004bd:	68 14 27 80 00       	push   $0x802714
  8004c2:	6a 26                	push   $0x26
  8004c4:	68 60 27 80 00       	push   $0x802760
  8004c9:	e8 5d ff ff ff       	call   80042b <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8004ce:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8004d5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004dc:	e9 c5 00 00 00       	jmp    8005a6 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8004e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004e4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ee:	01 d0                	add    %edx,%eax
  8004f0:	8b 00                	mov    (%eax),%eax
  8004f2:	85 c0                	test   %eax,%eax
  8004f4:	75 08                	jne    8004fe <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8004f6:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8004f9:	e9 a5 00 00 00       	jmp    8005a3 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8004fe:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800505:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80050c:	eb 69                	jmp    800577 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80050e:	a1 20 30 80 00       	mov    0x803020,%eax
  800513:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800519:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80051c:	89 d0                	mov    %edx,%eax
  80051e:	01 c0                	add    %eax,%eax
  800520:	01 d0                	add    %edx,%eax
  800522:	c1 e0 03             	shl    $0x3,%eax
  800525:	01 c8                	add    %ecx,%eax
  800527:	8a 40 04             	mov    0x4(%eax),%al
  80052a:	84 c0                	test   %al,%al
  80052c:	75 46                	jne    800574 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80052e:	a1 20 30 80 00       	mov    0x803020,%eax
  800533:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800539:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80053c:	89 d0                	mov    %edx,%eax
  80053e:	01 c0                	add    %eax,%eax
  800540:	01 d0                	add    %edx,%eax
  800542:	c1 e0 03             	shl    $0x3,%eax
  800545:	01 c8                	add    %ecx,%eax
  800547:	8b 00                	mov    (%eax),%eax
  800549:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80054c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80054f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800554:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800556:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800559:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800560:	8b 45 08             	mov    0x8(%ebp),%eax
  800563:	01 c8                	add    %ecx,%eax
  800565:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800567:	39 c2                	cmp    %eax,%edx
  800569:	75 09                	jne    800574 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80056b:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800572:	eb 15                	jmp    800589 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800574:	ff 45 e8             	incl   -0x18(%ebp)
  800577:	a1 20 30 80 00       	mov    0x803020,%eax
  80057c:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800582:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800585:	39 c2                	cmp    %eax,%edx
  800587:	77 85                	ja     80050e <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800589:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80058d:	75 14                	jne    8005a3 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80058f:	83 ec 04             	sub    $0x4,%esp
  800592:	68 6c 27 80 00       	push   $0x80276c
  800597:	6a 3a                	push   $0x3a
  800599:	68 60 27 80 00       	push   $0x802760
  80059e:	e8 88 fe ff ff       	call   80042b <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8005a3:	ff 45 f0             	incl   -0x10(%ebp)
  8005a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005a9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8005ac:	0f 8c 2f ff ff ff    	jl     8004e1 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8005b2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005b9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8005c0:	eb 26                	jmp    8005e8 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8005c2:	a1 20 30 80 00       	mov    0x803020,%eax
  8005c7:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8005cd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005d0:	89 d0                	mov    %edx,%eax
  8005d2:	01 c0                	add    %eax,%eax
  8005d4:	01 d0                	add    %edx,%eax
  8005d6:	c1 e0 03             	shl    $0x3,%eax
  8005d9:	01 c8                	add    %ecx,%eax
  8005db:	8a 40 04             	mov    0x4(%eax),%al
  8005de:	3c 01                	cmp    $0x1,%al
  8005e0:	75 03                	jne    8005e5 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8005e2:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005e5:	ff 45 e0             	incl   -0x20(%ebp)
  8005e8:	a1 20 30 80 00       	mov    0x803020,%eax
  8005ed:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005f6:	39 c2                	cmp    %eax,%edx
  8005f8:	77 c8                	ja     8005c2 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8005fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005fd:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800600:	74 14                	je     800616 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800602:	83 ec 04             	sub    $0x4,%esp
  800605:	68 c0 27 80 00       	push   $0x8027c0
  80060a:	6a 44                	push   $0x44
  80060c:	68 60 27 80 00       	push   $0x802760
  800611:	e8 15 fe ff ff       	call   80042b <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800616:	90                   	nop
  800617:	c9                   	leave  
  800618:	c3                   	ret    

00800619 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800619:	55                   	push   %ebp
  80061a:	89 e5                	mov    %esp,%ebp
  80061c:	53                   	push   %ebx
  80061d:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800620:	8b 45 0c             	mov    0xc(%ebp),%eax
  800623:	8b 00                	mov    (%eax),%eax
  800625:	8d 48 01             	lea    0x1(%eax),%ecx
  800628:	8b 55 0c             	mov    0xc(%ebp),%edx
  80062b:	89 0a                	mov    %ecx,(%edx)
  80062d:	8b 55 08             	mov    0x8(%ebp),%edx
  800630:	88 d1                	mov    %dl,%cl
  800632:	8b 55 0c             	mov    0xc(%ebp),%edx
  800635:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800639:	8b 45 0c             	mov    0xc(%ebp),%eax
  80063c:	8b 00                	mov    (%eax),%eax
  80063e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800643:	75 30                	jne    800675 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800645:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  80064b:	a0 44 30 80 00       	mov    0x803044,%al
  800650:	0f b6 c0             	movzbl %al,%eax
  800653:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800656:	8b 09                	mov    (%ecx),%ecx
  800658:	89 cb                	mov    %ecx,%ebx
  80065a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80065d:	83 c1 08             	add    $0x8,%ecx
  800660:	52                   	push   %edx
  800661:	50                   	push   %eax
  800662:	53                   	push   %ebx
  800663:	51                   	push   %ecx
  800664:	e8 57 11 00 00       	call   8017c0 <sys_cputs>
  800669:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80066c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80066f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800675:	8b 45 0c             	mov    0xc(%ebp),%eax
  800678:	8b 40 04             	mov    0x4(%eax),%eax
  80067b:	8d 50 01             	lea    0x1(%eax),%edx
  80067e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800681:	89 50 04             	mov    %edx,0x4(%eax)
}
  800684:	90                   	nop
  800685:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800688:	c9                   	leave  
  800689:	c3                   	ret    

0080068a <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80068a:	55                   	push   %ebp
  80068b:	89 e5                	mov    %esp,%ebp
  80068d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800693:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80069a:	00 00 00 
	b.cnt = 0;
  80069d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006a4:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8006a7:	ff 75 0c             	pushl  0xc(%ebp)
  8006aa:	ff 75 08             	pushl  0x8(%ebp)
  8006ad:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006b3:	50                   	push   %eax
  8006b4:	68 19 06 80 00       	push   $0x800619
  8006b9:	e8 5a 02 00 00       	call   800918 <vprintfmt>
  8006be:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8006c1:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  8006c7:	a0 44 30 80 00       	mov    0x803044,%al
  8006cc:	0f b6 c0             	movzbl %al,%eax
  8006cf:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8006d5:	52                   	push   %edx
  8006d6:	50                   	push   %eax
  8006d7:	51                   	push   %ecx
  8006d8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006de:	83 c0 08             	add    $0x8,%eax
  8006e1:	50                   	push   %eax
  8006e2:	e8 d9 10 00 00       	call   8017c0 <sys_cputs>
  8006e7:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8006ea:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  8006f1:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8006f7:	c9                   	leave  
  8006f8:	c3                   	ret    

008006f9 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8006f9:	55                   	push   %ebp
  8006fa:	89 e5                	mov    %esp,%ebp
  8006fc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8006ff:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  800706:	8d 45 0c             	lea    0xc(%ebp),%eax
  800709:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80070c:	8b 45 08             	mov    0x8(%ebp),%eax
  80070f:	83 ec 08             	sub    $0x8,%esp
  800712:	ff 75 f4             	pushl  -0xc(%ebp)
  800715:	50                   	push   %eax
  800716:	e8 6f ff ff ff       	call   80068a <vcprintf>
  80071b:	83 c4 10             	add    $0x10,%esp
  80071e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800721:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800724:	c9                   	leave  
  800725:	c3                   	ret    

00800726 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800726:	55                   	push   %ebp
  800727:	89 e5                	mov    %esp,%ebp
  800729:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80072c:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800733:	8b 45 08             	mov    0x8(%ebp),%eax
  800736:	c1 e0 08             	shl    $0x8,%eax
  800739:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  80073e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800741:	83 c0 04             	add    $0x4,%eax
  800744:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800747:	8b 45 0c             	mov    0xc(%ebp),%eax
  80074a:	83 ec 08             	sub    $0x8,%esp
  80074d:	ff 75 f4             	pushl  -0xc(%ebp)
  800750:	50                   	push   %eax
  800751:	e8 34 ff ff ff       	call   80068a <vcprintf>
  800756:	83 c4 10             	add    $0x10,%esp
  800759:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  80075c:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  800763:	07 00 00 

	return cnt;
  800766:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800769:	c9                   	leave  
  80076a:	c3                   	ret    

0080076b <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80076b:	55                   	push   %ebp
  80076c:	89 e5                	mov    %esp,%ebp
  80076e:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800771:	e8 8e 10 00 00       	call   801804 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800776:	8d 45 0c             	lea    0xc(%ebp),%eax
  800779:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80077c:	8b 45 08             	mov    0x8(%ebp),%eax
  80077f:	83 ec 08             	sub    $0x8,%esp
  800782:	ff 75 f4             	pushl  -0xc(%ebp)
  800785:	50                   	push   %eax
  800786:	e8 ff fe ff ff       	call   80068a <vcprintf>
  80078b:	83 c4 10             	add    $0x10,%esp
  80078e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800791:	e8 88 10 00 00       	call   80181e <sys_unlock_cons>
	return cnt;
  800796:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800799:	c9                   	leave  
  80079a:	c3                   	ret    

0080079b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80079b:	55                   	push   %ebp
  80079c:	89 e5                	mov    %esp,%ebp
  80079e:	53                   	push   %ebx
  80079f:	83 ec 14             	sub    $0x14,%esp
  8007a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8007a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007ae:	8b 45 18             	mov    0x18(%ebp),%eax
  8007b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8007b6:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007b9:	77 55                	ja     800810 <printnum+0x75>
  8007bb:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007be:	72 05                	jb     8007c5 <printnum+0x2a>
  8007c0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8007c3:	77 4b                	ja     800810 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007c5:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8007c8:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8007cb:	8b 45 18             	mov    0x18(%ebp),%eax
  8007ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8007d3:	52                   	push   %edx
  8007d4:	50                   	push   %eax
  8007d5:	ff 75 f4             	pushl  -0xc(%ebp)
  8007d8:	ff 75 f0             	pushl  -0x10(%ebp)
  8007db:	e8 a8 16 00 00       	call   801e88 <__udivdi3>
  8007e0:	83 c4 10             	add    $0x10,%esp
  8007e3:	83 ec 04             	sub    $0x4,%esp
  8007e6:	ff 75 20             	pushl  0x20(%ebp)
  8007e9:	53                   	push   %ebx
  8007ea:	ff 75 18             	pushl  0x18(%ebp)
  8007ed:	52                   	push   %edx
  8007ee:	50                   	push   %eax
  8007ef:	ff 75 0c             	pushl  0xc(%ebp)
  8007f2:	ff 75 08             	pushl  0x8(%ebp)
  8007f5:	e8 a1 ff ff ff       	call   80079b <printnum>
  8007fa:	83 c4 20             	add    $0x20,%esp
  8007fd:	eb 1a                	jmp    800819 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8007ff:	83 ec 08             	sub    $0x8,%esp
  800802:	ff 75 0c             	pushl  0xc(%ebp)
  800805:	ff 75 20             	pushl  0x20(%ebp)
  800808:	8b 45 08             	mov    0x8(%ebp),%eax
  80080b:	ff d0                	call   *%eax
  80080d:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800810:	ff 4d 1c             	decl   0x1c(%ebp)
  800813:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800817:	7f e6                	jg     8007ff <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800819:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80081c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800821:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800824:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800827:	53                   	push   %ebx
  800828:	51                   	push   %ecx
  800829:	52                   	push   %edx
  80082a:	50                   	push   %eax
  80082b:	e8 68 17 00 00       	call   801f98 <__umoddi3>
  800830:	83 c4 10             	add    $0x10,%esp
  800833:	05 34 2a 80 00       	add    $0x802a34,%eax
  800838:	8a 00                	mov    (%eax),%al
  80083a:	0f be c0             	movsbl %al,%eax
  80083d:	83 ec 08             	sub    $0x8,%esp
  800840:	ff 75 0c             	pushl  0xc(%ebp)
  800843:	50                   	push   %eax
  800844:	8b 45 08             	mov    0x8(%ebp),%eax
  800847:	ff d0                	call   *%eax
  800849:	83 c4 10             	add    $0x10,%esp
}
  80084c:	90                   	nop
  80084d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800850:	c9                   	leave  
  800851:	c3                   	ret    

00800852 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800852:	55                   	push   %ebp
  800853:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800855:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800859:	7e 1c                	jle    800877 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80085b:	8b 45 08             	mov    0x8(%ebp),%eax
  80085e:	8b 00                	mov    (%eax),%eax
  800860:	8d 50 08             	lea    0x8(%eax),%edx
  800863:	8b 45 08             	mov    0x8(%ebp),%eax
  800866:	89 10                	mov    %edx,(%eax)
  800868:	8b 45 08             	mov    0x8(%ebp),%eax
  80086b:	8b 00                	mov    (%eax),%eax
  80086d:	83 e8 08             	sub    $0x8,%eax
  800870:	8b 50 04             	mov    0x4(%eax),%edx
  800873:	8b 00                	mov    (%eax),%eax
  800875:	eb 40                	jmp    8008b7 <getuint+0x65>
	else if (lflag)
  800877:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80087b:	74 1e                	je     80089b <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80087d:	8b 45 08             	mov    0x8(%ebp),%eax
  800880:	8b 00                	mov    (%eax),%eax
  800882:	8d 50 04             	lea    0x4(%eax),%edx
  800885:	8b 45 08             	mov    0x8(%ebp),%eax
  800888:	89 10                	mov    %edx,(%eax)
  80088a:	8b 45 08             	mov    0x8(%ebp),%eax
  80088d:	8b 00                	mov    (%eax),%eax
  80088f:	83 e8 04             	sub    $0x4,%eax
  800892:	8b 00                	mov    (%eax),%eax
  800894:	ba 00 00 00 00       	mov    $0x0,%edx
  800899:	eb 1c                	jmp    8008b7 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80089b:	8b 45 08             	mov    0x8(%ebp),%eax
  80089e:	8b 00                	mov    (%eax),%eax
  8008a0:	8d 50 04             	lea    0x4(%eax),%edx
  8008a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a6:	89 10                	mov    %edx,(%eax)
  8008a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ab:	8b 00                	mov    (%eax),%eax
  8008ad:	83 e8 04             	sub    $0x4,%eax
  8008b0:	8b 00                	mov    (%eax),%eax
  8008b2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8008b7:	5d                   	pop    %ebp
  8008b8:	c3                   	ret    

008008b9 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008b9:	55                   	push   %ebp
  8008ba:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008bc:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008c0:	7e 1c                	jle    8008de <getint+0x25>
		return va_arg(*ap, long long);
  8008c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c5:	8b 00                	mov    (%eax),%eax
  8008c7:	8d 50 08             	lea    0x8(%eax),%edx
  8008ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cd:	89 10                	mov    %edx,(%eax)
  8008cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d2:	8b 00                	mov    (%eax),%eax
  8008d4:	83 e8 08             	sub    $0x8,%eax
  8008d7:	8b 50 04             	mov    0x4(%eax),%edx
  8008da:	8b 00                	mov    (%eax),%eax
  8008dc:	eb 38                	jmp    800916 <getint+0x5d>
	else if (lflag)
  8008de:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008e2:	74 1a                	je     8008fe <getint+0x45>
		return va_arg(*ap, long);
  8008e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e7:	8b 00                	mov    (%eax),%eax
  8008e9:	8d 50 04             	lea    0x4(%eax),%edx
  8008ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ef:	89 10                	mov    %edx,(%eax)
  8008f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f4:	8b 00                	mov    (%eax),%eax
  8008f6:	83 e8 04             	sub    $0x4,%eax
  8008f9:	8b 00                	mov    (%eax),%eax
  8008fb:	99                   	cltd   
  8008fc:	eb 18                	jmp    800916 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8008fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800901:	8b 00                	mov    (%eax),%eax
  800903:	8d 50 04             	lea    0x4(%eax),%edx
  800906:	8b 45 08             	mov    0x8(%ebp),%eax
  800909:	89 10                	mov    %edx,(%eax)
  80090b:	8b 45 08             	mov    0x8(%ebp),%eax
  80090e:	8b 00                	mov    (%eax),%eax
  800910:	83 e8 04             	sub    $0x4,%eax
  800913:	8b 00                	mov    (%eax),%eax
  800915:	99                   	cltd   
}
  800916:	5d                   	pop    %ebp
  800917:	c3                   	ret    

00800918 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800918:	55                   	push   %ebp
  800919:	89 e5                	mov    %esp,%ebp
  80091b:	56                   	push   %esi
  80091c:	53                   	push   %ebx
  80091d:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800920:	eb 17                	jmp    800939 <vprintfmt+0x21>
			if (ch == '\0')
  800922:	85 db                	test   %ebx,%ebx
  800924:	0f 84 c1 03 00 00    	je     800ceb <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80092a:	83 ec 08             	sub    $0x8,%esp
  80092d:	ff 75 0c             	pushl  0xc(%ebp)
  800930:	53                   	push   %ebx
  800931:	8b 45 08             	mov    0x8(%ebp),%eax
  800934:	ff d0                	call   *%eax
  800936:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800939:	8b 45 10             	mov    0x10(%ebp),%eax
  80093c:	8d 50 01             	lea    0x1(%eax),%edx
  80093f:	89 55 10             	mov    %edx,0x10(%ebp)
  800942:	8a 00                	mov    (%eax),%al
  800944:	0f b6 d8             	movzbl %al,%ebx
  800947:	83 fb 25             	cmp    $0x25,%ebx
  80094a:	75 d6                	jne    800922 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80094c:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800950:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800957:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80095e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800965:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80096c:	8b 45 10             	mov    0x10(%ebp),%eax
  80096f:	8d 50 01             	lea    0x1(%eax),%edx
  800972:	89 55 10             	mov    %edx,0x10(%ebp)
  800975:	8a 00                	mov    (%eax),%al
  800977:	0f b6 d8             	movzbl %al,%ebx
  80097a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80097d:	83 f8 5b             	cmp    $0x5b,%eax
  800980:	0f 87 3d 03 00 00    	ja     800cc3 <vprintfmt+0x3ab>
  800986:	8b 04 85 58 2a 80 00 	mov    0x802a58(,%eax,4),%eax
  80098d:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80098f:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800993:	eb d7                	jmp    80096c <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800995:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800999:	eb d1                	jmp    80096c <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80099b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009a2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009a5:	89 d0                	mov    %edx,%eax
  8009a7:	c1 e0 02             	shl    $0x2,%eax
  8009aa:	01 d0                	add    %edx,%eax
  8009ac:	01 c0                	add    %eax,%eax
  8009ae:	01 d8                	add    %ebx,%eax
  8009b0:	83 e8 30             	sub    $0x30,%eax
  8009b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8009b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8009b9:	8a 00                	mov    (%eax),%al
  8009bb:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009be:	83 fb 2f             	cmp    $0x2f,%ebx
  8009c1:	7e 3e                	jle    800a01 <vprintfmt+0xe9>
  8009c3:	83 fb 39             	cmp    $0x39,%ebx
  8009c6:	7f 39                	jg     800a01 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009c8:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009cb:	eb d5                	jmp    8009a2 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8009cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d0:	83 c0 04             	add    $0x4,%eax
  8009d3:	89 45 14             	mov    %eax,0x14(%ebp)
  8009d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d9:	83 e8 04             	sub    $0x4,%eax
  8009dc:	8b 00                	mov    (%eax),%eax
  8009de:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8009e1:	eb 1f                	jmp    800a02 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8009e3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009e7:	79 83                	jns    80096c <vprintfmt+0x54>
				width = 0;
  8009e9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8009f0:	e9 77 ff ff ff       	jmp    80096c <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8009f5:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8009fc:	e9 6b ff ff ff       	jmp    80096c <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a01:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a02:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a06:	0f 89 60 ff ff ff    	jns    80096c <vprintfmt+0x54>
				width = precision, precision = -1;
  800a0c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a0f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a12:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a19:	e9 4e ff ff ff       	jmp    80096c <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a1e:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a21:	e9 46 ff ff ff       	jmp    80096c <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a26:	8b 45 14             	mov    0x14(%ebp),%eax
  800a29:	83 c0 04             	add    $0x4,%eax
  800a2c:	89 45 14             	mov    %eax,0x14(%ebp)
  800a2f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a32:	83 e8 04             	sub    $0x4,%eax
  800a35:	8b 00                	mov    (%eax),%eax
  800a37:	83 ec 08             	sub    $0x8,%esp
  800a3a:	ff 75 0c             	pushl  0xc(%ebp)
  800a3d:	50                   	push   %eax
  800a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a41:	ff d0                	call   *%eax
  800a43:	83 c4 10             	add    $0x10,%esp
			break;
  800a46:	e9 9b 02 00 00       	jmp    800ce6 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a4b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a4e:	83 c0 04             	add    $0x4,%eax
  800a51:	89 45 14             	mov    %eax,0x14(%ebp)
  800a54:	8b 45 14             	mov    0x14(%ebp),%eax
  800a57:	83 e8 04             	sub    $0x4,%eax
  800a5a:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a5c:	85 db                	test   %ebx,%ebx
  800a5e:	79 02                	jns    800a62 <vprintfmt+0x14a>
				err = -err;
  800a60:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a62:	83 fb 64             	cmp    $0x64,%ebx
  800a65:	7f 0b                	jg     800a72 <vprintfmt+0x15a>
  800a67:	8b 34 9d a0 28 80 00 	mov    0x8028a0(,%ebx,4),%esi
  800a6e:	85 f6                	test   %esi,%esi
  800a70:	75 19                	jne    800a8b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a72:	53                   	push   %ebx
  800a73:	68 45 2a 80 00       	push   $0x802a45
  800a78:	ff 75 0c             	pushl  0xc(%ebp)
  800a7b:	ff 75 08             	pushl  0x8(%ebp)
  800a7e:	e8 70 02 00 00       	call   800cf3 <printfmt>
  800a83:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a86:	e9 5b 02 00 00       	jmp    800ce6 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a8b:	56                   	push   %esi
  800a8c:	68 4e 2a 80 00       	push   $0x802a4e
  800a91:	ff 75 0c             	pushl  0xc(%ebp)
  800a94:	ff 75 08             	pushl  0x8(%ebp)
  800a97:	e8 57 02 00 00       	call   800cf3 <printfmt>
  800a9c:	83 c4 10             	add    $0x10,%esp
			break;
  800a9f:	e9 42 02 00 00       	jmp    800ce6 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800aa4:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa7:	83 c0 04             	add    $0x4,%eax
  800aaa:	89 45 14             	mov    %eax,0x14(%ebp)
  800aad:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab0:	83 e8 04             	sub    $0x4,%eax
  800ab3:	8b 30                	mov    (%eax),%esi
  800ab5:	85 f6                	test   %esi,%esi
  800ab7:	75 05                	jne    800abe <vprintfmt+0x1a6>
				p = "(null)";
  800ab9:	be 51 2a 80 00       	mov    $0x802a51,%esi
			if (width > 0 && padc != '-')
  800abe:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ac2:	7e 6d                	jle    800b31 <vprintfmt+0x219>
  800ac4:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800ac8:	74 67                	je     800b31 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800aca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800acd:	83 ec 08             	sub    $0x8,%esp
  800ad0:	50                   	push   %eax
  800ad1:	56                   	push   %esi
  800ad2:	e8 1e 03 00 00       	call   800df5 <strnlen>
  800ad7:	83 c4 10             	add    $0x10,%esp
  800ada:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800add:	eb 16                	jmp    800af5 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800adf:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800ae3:	83 ec 08             	sub    $0x8,%esp
  800ae6:	ff 75 0c             	pushl  0xc(%ebp)
  800ae9:	50                   	push   %eax
  800aea:	8b 45 08             	mov    0x8(%ebp),%eax
  800aed:	ff d0                	call   *%eax
  800aef:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800af2:	ff 4d e4             	decl   -0x1c(%ebp)
  800af5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800af9:	7f e4                	jg     800adf <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800afb:	eb 34                	jmp    800b31 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800afd:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b01:	74 1c                	je     800b1f <vprintfmt+0x207>
  800b03:	83 fb 1f             	cmp    $0x1f,%ebx
  800b06:	7e 05                	jle    800b0d <vprintfmt+0x1f5>
  800b08:	83 fb 7e             	cmp    $0x7e,%ebx
  800b0b:	7e 12                	jle    800b1f <vprintfmt+0x207>
					putch('?', putdat);
  800b0d:	83 ec 08             	sub    $0x8,%esp
  800b10:	ff 75 0c             	pushl  0xc(%ebp)
  800b13:	6a 3f                	push   $0x3f
  800b15:	8b 45 08             	mov    0x8(%ebp),%eax
  800b18:	ff d0                	call   *%eax
  800b1a:	83 c4 10             	add    $0x10,%esp
  800b1d:	eb 0f                	jmp    800b2e <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b1f:	83 ec 08             	sub    $0x8,%esp
  800b22:	ff 75 0c             	pushl  0xc(%ebp)
  800b25:	53                   	push   %ebx
  800b26:	8b 45 08             	mov    0x8(%ebp),%eax
  800b29:	ff d0                	call   *%eax
  800b2b:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b2e:	ff 4d e4             	decl   -0x1c(%ebp)
  800b31:	89 f0                	mov    %esi,%eax
  800b33:	8d 70 01             	lea    0x1(%eax),%esi
  800b36:	8a 00                	mov    (%eax),%al
  800b38:	0f be d8             	movsbl %al,%ebx
  800b3b:	85 db                	test   %ebx,%ebx
  800b3d:	74 24                	je     800b63 <vprintfmt+0x24b>
  800b3f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b43:	78 b8                	js     800afd <vprintfmt+0x1e5>
  800b45:	ff 4d e0             	decl   -0x20(%ebp)
  800b48:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b4c:	79 af                	jns    800afd <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b4e:	eb 13                	jmp    800b63 <vprintfmt+0x24b>
				putch(' ', putdat);
  800b50:	83 ec 08             	sub    $0x8,%esp
  800b53:	ff 75 0c             	pushl  0xc(%ebp)
  800b56:	6a 20                	push   $0x20
  800b58:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5b:	ff d0                	call   *%eax
  800b5d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b60:	ff 4d e4             	decl   -0x1c(%ebp)
  800b63:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b67:	7f e7                	jg     800b50 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b69:	e9 78 01 00 00       	jmp    800ce6 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b6e:	83 ec 08             	sub    $0x8,%esp
  800b71:	ff 75 e8             	pushl  -0x18(%ebp)
  800b74:	8d 45 14             	lea    0x14(%ebp),%eax
  800b77:	50                   	push   %eax
  800b78:	e8 3c fd ff ff       	call   8008b9 <getint>
  800b7d:	83 c4 10             	add    $0x10,%esp
  800b80:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b83:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800b86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b89:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b8c:	85 d2                	test   %edx,%edx
  800b8e:	79 23                	jns    800bb3 <vprintfmt+0x29b>
				putch('-', putdat);
  800b90:	83 ec 08             	sub    $0x8,%esp
  800b93:	ff 75 0c             	pushl  0xc(%ebp)
  800b96:	6a 2d                	push   $0x2d
  800b98:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9b:	ff d0                	call   *%eax
  800b9d:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800ba0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ba3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ba6:	f7 d8                	neg    %eax
  800ba8:	83 d2 00             	adc    $0x0,%edx
  800bab:	f7 da                	neg    %edx
  800bad:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bb0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800bb3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bba:	e9 bc 00 00 00       	jmp    800c7b <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800bbf:	83 ec 08             	sub    $0x8,%esp
  800bc2:	ff 75 e8             	pushl  -0x18(%ebp)
  800bc5:	8d 45 14             	lea    0x14(%ebp),%eax
  800bc8:	50                   	push   %eax
  800bc9:	e8 84 fc ff ff       	call   800852 <getuint>
  800bce:	83 c4 10             	add    $0x10,%esp
  800bd1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bd4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800bd7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bde:	e9 98 00 00 00       	jmp    800c7b <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800be3:	83 ec 08             	sub    $0x8,%esp
  800be6:	ff 75 0c             	pushl  0xc(%ebp)
  800be9:	6a 58                	push   $0x58
  800beb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bee:	ff d0                	call   *%eax
  800bf0:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800bf3:	83 ec 08             	sub    $0x8,%esp
  800bf6:	ff 75 0c             	pushl  0xc(%ebp)
  800bf9:	6a 58                	push   $0x58
  800bfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfe:	ff d0                	call   *%eax
  800c00:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c03:	83 ec 08             	sub    $0x8,%esp
  800c06:	ff 75 0c             	pushl  0xc(%ebp)
  800c09:	6a 58                	push   $0x58
  800c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0e:	ff d0                	call   *%eax
  800c10:	83 c4 10             	add    $0x10,%esp
			break;
  800c13:	e9 ce 00 00 00       	jmp    800ce6 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800c18:	83 ec 08             	sub    $0x8,%esp
  800c1b:	ff 75 0c             	pushl  0xc(%ebp)
  800c1e:	6a 30                	push   $0x30
  800c20:	8b 45 08             	mov    0x8(%ebp),%eax
  800c23:	ff d0                	call   *%eax
  800c25:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c28:	83 ec 08             	sub    $0x8,%esp
  800c2b:	ff 75 0c             	pushl  0xc(%ebp)
  800c2e:	6a 78                	push   $0x78
  800c30:	8b 45 08             	mov    0x8(%ebp),%eax
  800c33:	ff d0                	call   *%eax
  800c35:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c38:	8b 45 14             	mov    0x14(%ebp),%eax
  800c3b:	83 c0 04             	add    $0x4,%eax
  800c3e:	89 45 14             	mov    %eax,0x14(%ebp)
  800c41:	8b 45 14             	mov    0x14(%ebp),%eax
  800c44:	83 e8 04             	sub    $0x4,%eax
  800c47:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c49:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c4c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c53:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c5a:	eb 1f                	jmp    800c7b <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c5c:	83 ec 08             	sub    $0x8,%esp
  800c5f:	ff 75 e8             	pushl  -0x18(%ebp)
  800c62:	8d 45 14             	lea    0x14(%ebp),%eax
  800c65:	50                   	push   %eax
  800c66:	e8 e7 fb ff ff       	call   800852 <getuint>
  800c6b:	83 c4 10             	add    $0x10,%esp
  800c6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c71:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800c74:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c7b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800c7f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c82:	83 ec 04             	sub    $0x4,%esp
  800c85:	52                   	push   %edx
  800c86:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c89:	50                   	push   %eax
  800c8a:	ff 75 f4             	pushl  -0xc(%ebp)
  800c8d:	ff 75 f0             	pushl  -0x10(%ebp)
  800c90:	ff 75 0c             	pushl  0xc(%ebp)
  800c93:	ff 75 08             	pushl  0x8(%ebp)
  800c96:	e8 00 fb ff ff       	call   80079b <printnum>
  800c9b:	83 c4 20             	add    $0x20,%esp
			break;
  800c9e:	eb 46                	jmp    800ce6 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ca0:	83 ec 08             	sub    $0x8,%esp
  800ca3:	ff 75 0c             	pushl  0xc(%ebp)
  800ca6:	53                   	push   %ebx
  800ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  800caa:	ff d0                	call   *%eax
  800cac:	83 c4 10             	add    $0x10,%esp
			break;
  800caf:	eb 35                	jmp    800ce6 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800cb1:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800cb8:	eb 2c                	jmp    800ce6 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800cba:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800cc1:	eb 23                	jmp    800ce6 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cc3:	83 ec 08             	sub    $0x8,%esp
  800cc6:	ff 75 0c             	pushl  0xc(%ebp)
  800cc9:	6a 25                	push   $0x25
  800ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cce:	ff d0                	call   *%eax
  800cd0:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800cd3:	ff 4d 10             	decl   0x10(%ebp)
  800cd6:	eb 03                	jmp    800cdb <vprintfmt+0x3c3>
  800cd8:	ff 4d 10             	decl   0x10(%ebp)
  800cdb:	8b 45 10             	mov    0x10(%ebp),%eax
  800cde:	48                   	dec    %eax
  800cdf:	8a 00                	mov    (%eax),%al
  800ce1:	3c 25                	cmp    $0x25,%al
  800ce3:	75 f3                	jne    800cd8 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800ce5:	90                   	nop
		}
	}
  800ce6:	e9 35 fc ff ff       	jmp    800920 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ceb:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800cec:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800cef:	5b                   	pop    %ebx
  800cf0:	5e                   	pop    %esi
  800cf1:	5d                   	pop    %ebp
  800cf2:	c3                   	ret    

00800cf3 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800cf3:	55                   	push   %ebp
  800cf4:	89 e5                	mov    %esp,%ebp
  800cf6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800cf9:	8d 45 10             	lea    0x10(%ebp),%eax
  800cfc:	83 c0 04             	add    $0x4,%eax
  800cff:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d02:	8b 45 10             	mov    0x10(%ebp),%eax
  800d05:	ff 75 f4             	pushl  -0xc(%ebp)
  800d08:	50                   	push   %eax
  800d09:	ff 75 0c             	pushl  0xc(%ebp)
  800d0c:	ff 75 08             	pushl  0x8(%ebp)
  800d0f:	e8 04 fc ff ff       	call   800918 <vprintfmt>
  800d14:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d17:	90                   	nop
  800d18:	c9                   	leave  
  800d19:	c3                   	ret    

00800d1a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d1a:	55                   	push   %ebp
  800d1b:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d20:	8b 40 08             	mov    0x8(%eax),%eax
  800d23:	8d 50 01             	lea    0x1(%eax),%edx
  800d26:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d29:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2f:	8b 10                	mov    (%eax),%edx
  800d31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d34:	8b 40 04             	mov    0x4(%eax),%eax
  800d37:	39 c2                	cmp    %eax,%edx
  800d39:	73 12                	jae    800d4d <sprintputch+0x33>
		*b->buf++ = ch;
  800d3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3e:	8b 00                	mov    (%eax),%eax
  800d40:	8d 48 01             	lea    0x1(%eax),%ecx
  800d43:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d46:	89 0a                	mov    %ecx,(%edx)
  800d48:	8b 55 08             	mov    0x8(%ebp),%edx
  800d4b:	88 10                	mov    %dl,(%eax)
}
  800d4d:	90                   	nop
  800d4e:	5d                   	pop    %ebp
  800d4f:	c3                   	ret    

00800d50 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d50:	55                   	push   %ebp
  800d51:	89 e5                	mov    %esp,%ebp
  800d53:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d56:	8b 45 08             	mov    0x8(%ebp),%eax
  800d59:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d62:	8b 45 08             	mov    0x8(%ebp),%eax
  800d65:	01 d0                	add    %edx,%eax
  800d67:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d6a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d71:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d75:	74 06                	je     800d7d <vsnprintf+0x2d>
  800d77:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d7b:	7f 07                	jg     800d84 <vsnprintf+0x34>
		return -E_INVAL;
  800d7d:	b8 03 00 00 00       	mov    $0x3,%eax
  800d82:	eb 20                	jmp    800da4 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d84:	ff 75 14             	pushl  0x14(%ebp)
  800d87:	ff 75 10             	pushl  0x10(%ebp)
  800d8a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d8d:	50                   	push   %eax
  800d8e:	68 1a 0d 80 00       	push   $0x800d1a
  800d93:	e8 80 fb ff ff       	call   800918 <vprintfmt>
  800d98:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800d9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d9e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800da1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800da4:	c9                   	leave  
  800da5:	c3                   	ret    

00800da6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800da6:	55                   	push   %ebp
  800da7:	89 e5                	mov    %esp,%ebp
  800da9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800dac:	8d 45 10             	lea    0x10(%ebp),%eax
  800daf:	83 c0 04             	add    $0x4,%eax
  800db2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800db5:	8b 45 10             	mov    0x10(%ebp),%eax
  800db8:	ff 75 f4             	pushl  -0xc(%ebp)
  800dbb:	50                   	push   %eax
  800dbc:	ff 75 0c             	pushl  0xc(%ebp)
  800dbf:	ff 75 08             	pushl  0x8(%ebp)
  800dc2:	e8 89 ff ff ff       	call   800d50 <vsnprintf>
  800dc7:	83 c4 10             	add    $0x10,%esp
  800dca:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800dcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800dd0:	c9                   	leave  
  800dd1:	c3                   	ret    

00800dd2 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800dd2:	55                   	push   %ebp
  800dd3:	89 e5                	mov    %esp,%ebp
  800dd5:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800dd8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ddf:	eb 06                	jmp    800de7 <strlen+0x15>
		n++;
  800de1:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800de4:	ff 45 08             	incl   0x8(%ebp)
  800de7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dea:	8a 00                	mov    (%eax),%al
  800dec:	84 c0                	test   %al,%al
  800dee:	75 f1                	jne    800de1 <strlen+0xf>
		n++;
	return n;
  800df0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800df3:	c9                   	leave  
  800df4:	c3                   	ret    

00800df5 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800df5:	55                   	push   %ebp
  800df6:	89 e5                	mov    %esp,%ebp
  800df8:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800dfb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e02:	eb 09                	jmp    800e0d <strnlen+0x18>
		n++;
  800e04:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e07:	ff 45 08             	incl   0x8(%ebp)
  800e0a:	ff 4d 0c             	decl   0xc(%ebp)
  800e0d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e11:	74 09                	je     800e1c <strnlen+0x27>
  800e13:	8b 45 08             	mov    0x8(%ebp),%eax
  800e16:	8a 00                	mov    (%eax),%al
  800e18:	84 c0                	test   %al,%al
  800e1a:	75 e8                	jne    800e04 <strnlen+0xf>
		n++;
	return n;
  800e1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e1f:	c9                   	leave  
  800e20:	c3                   	ret    

00800e21 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e21:	55                   	push   %ebp
  800e22:	89 e5                	mov    %esp,%ebp
  800e24:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e27:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e2d:	90                   	nop
  800e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e31:	8d 50 01             	lea    0x1(%eax),%edx
  800e34:	89 55 08             	mov    %edx,0x8(%ebp)
  800e37:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e3a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e3d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e40:	8a 12                	mov    (%edx),%dl
  800e42:	88 10                	mov    %dl,(%eax)
  800e44:	8a 00                	mov    (%eax),%al
  800e46:	84 c0                	test   %al,%al
  800e48:	75 e4                	jne    800e2e <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e4a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e4d:	c9                   	leave  
  800e4e:	c3                   	ret    

00800e4f <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e4f:	55                   	push   %ebp
  800e50:	89 e5                	mov    %esp,%ebp
  800e52:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e55:	8b 45 08             	mov    0x8(%ebp),%eax
  800e58:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e5b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e62:	eb 1f                	jmp    800e83 <strncpy+0x34>
		*dst++ = *src;
  800e64:	8b 45 08             	mov    0x8(%ebp),%eax
  800e67:	8d 50 01             	lea    0x1(%eax),%edx
  800e6a:	89 55 08             	mov    %edx,0x8(%ebp)
  800e6d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e70:	8a 12                	mov    (%edx),%dl
  800e72:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e74:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e77:	8a 00                	mov    (%eax),%al
  800e79:	84 c0                	test   %al,%al
  800e7b:	74 03                	je     800e80 <strncpy+0x31>
			src++;
  800e7d:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e80:	ff 45 fc             	incl   -0x4(%ebp)
  800e83:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e86:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e89:	72 d9                	jb     800e64 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800e8b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e8e:	c9                   	leave  
  800e8f:	c3                   	ret    

00800e90 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800e90:	55                   	push   %ebp
  800e91:	89 e5                	mov    %esp,%ebp
  800e93:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800e96:	8b 45 08             	mov    0x8(%ebp),%eax
  800e99:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800e9c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ea0:	74 30                	je     800ed2 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ea2:	eb 16                	jmp    800eba <strlcpy+0x2a>
			*dst++ = *src++;
  800ea4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea7:	8d 50 01             	lea    0x1(%eax),%edx
  800eaa:	89 55 08             	mov    %edx,0x8(%ebp)
  800ead:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eb0:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eb3:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800eb6:	8a 12                	mov    (%edx),%dl
  800eb8:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800eba:	ff 4d 10             	decl   0x10(%ebp)
  800ebd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ec1:	74 09                	je     800ecc <strlcpy+0x3c>
  800ec3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec6:	8a 00                	mov    (%eax),%al
  800ec8:	84 c0                	test   %al,%al
  800eca:	75 d8                	jne    800ea4 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecf:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ed2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed8:	29 c2                	sub    %eax,%edx
  800eda:	89 d0                	mov    %edx,%eax
}
  800edc:	c9                   	leave  
  800edd:	c3                   	ret    

00800ede <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ede:	55                   	push   %ebp
  800edf:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ee1:	eb 06                	jmp    800ee9 <strcmp+0xb>
		p++, q++;
  800ee3:	ff 45 08             	incl   0x8(%ebp)
  800ee6:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ee9:	8b 45 08             	mov    0x8(%ebp),%eax
  800eec:	8a 00                	mov    (%eax),%al
  800eee:	84 c0                	test   %al,%al
  800ef0:	74 0e                	je     800f00 <strcmp+0x22>
  800ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef5:	8a 10                	mov    (%eax),%dl
  800ef7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800efa:	8a 00                	mov    (%eax),%al
  800efc:	38 c2                	cmp    %al,%dl
  800efe:	74 e3                	je     800ee3 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f00:	8b 45 08             	mov    0x8(%ebp),%eax
  800f03:	8a 00                	mov    (%eax),%al
  800f05:	0f b6 d0             	movzbl %al,%edx
  800f08:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f0b:	8a 00                	mov    (%eax),%al
  800f0d:	0f b6 c0             	movzbl %al,%eax
  800f10:	29 c2                	sub    %eax,%edx
  800f12:	89 d0                	mov    %edx,%eax
}
  800f14:	5d                   	pop    %ebp
  800f15:	c3                   	ret    

00800f16 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f16:	55                   	push   %ebp
  800f17:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f19:	eb 09                	jmp    800f24 <strncmp+0xe>
		n--, p++, q++;
  800f1b:	ff 4d 10             	decl   0x10(%ebp)
  800f1e:	ff 45 08             	incl   0x8(%ebp)
  800f21:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f24:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f28:	74 17                	je     800f41 <strncmp+0x2b>
  800f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2d:	8a 00                	mov    (%eax),%al
  800f2f:	84 c0                	test   %al,%al
  800f31:	74 0e                	je     800f41 <strncmp+0x2b>
  800f33:	8b 45 08             	mov    0x8(%ebp),%eax
  800f36:	8a 10                	mov    (%eax),%dl
  800f38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f3b:	8a 00                	mov    (%eax),%al
  800f3d:	38 c2                	cmp    %al,%dl
  800f3f:	74 da                	je     800f1b <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f41:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f45:	75 07                	jne    800f4e <strncmp+0x38>
		return 0;
  800f47:	b8 00 00 00 00       	mov    $0x0,%eax
  800f4c:	eb 14                	jmp    800f62 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f51:	8a 00                	mov    (%eax),%al
  800f53:	0f b6 d0             	movzbl %al,%edx
  800f56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f59:	8a 00                	mov    (%eax),%al
  800f5b:	0f b6 c0             	movzbl %al,%eax
  800f5e:	29 c2                	sub    %eax,%edx
  800f60:	89 d0                	mov    %edx,%eax
}
  800f62:	5d                   	pop    %ebp
  800f63:	c3                   	ret    

00800f64 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f64:	55                   	push   %ebp
  800f65:	89 e5                	mov    %esp,%ebp
  800f67:	83 ec 04             	sub    $0x4,%esp
  800f6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f70:	eb 12                	jmp    800f84 <strchr+0x20>
		if (*s == c)
  800f72:	8b 45 08             	mov    0x8(%ebp),%eax
  800f75:	8a 00                	mov    (%eax),%al
  800f77:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f7a:	75 05                	jne    800f81 <strchr+0x1d>
			return (char *) s;
  800f7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7f:	eb 11                	jmp    800f92 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800f81:	ff 45 08             	incl   0x8(%ebp)
  800f84:	8b 45 08             	mov    0x8(%ebp),%eax
  800f87:	8a 00                	mov    (%eax),%al
  800f89:	84 c0                	test   %al,%al
  800f8b:	75 e5                	jne    800f72 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800f8d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f92:	c9                   	leave  
  800f93:	c3                   	ret    

00800f94 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f94:	55                   	push   %ebp
  800f95:	89 e5                	mov    %esp,%ebp
  800f97:	83 ec 04             	sub    $0x4,%esp
  800f9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f9d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fa0:	eb 0d                	jmp    800faf <strfind+0x1b>
		if (*s == c)
  800fa2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa5:	8a 00                	mov    (%eax),%al
  800fa7:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800faa:	74 0e                	je     800fba <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800fac:	ff 45 08             	incl   0x8(%ebp)
  800faf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb2:	8a 00                	mov    (%eax),%al
  800fb4:	84 c0                	test   %al,%al
  800fb6:	75 ea                	jne    800fa2 <strfind+0xe>
  800fb8:	eb 01                	jmp    800fbb <strfind+0x27>
		if (*s == c)
			break;
  800fba:	90                   	nop
	return (char *) s;
  800fbb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fbe:	c9                   	leave  
  800fbf:	c3                   	ret    

00800fc0 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800fc0:	55                   	push   %ebp
  800fc1:	89 e5                	mov    %esp,%ebp
  800fc3:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800fcc:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800fd0:	76 63                	jbe    801035 <memset+0x75>
		uint64 data_block = c;
  800fd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd5:	99                   	cltd   
  800fd6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fd9:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800fdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fdf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fe2:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800fe6:	c1 e0 08             	shl    $0x8,%eax
  800fe9:	09 45 f0             	or     %eax,-0x10(%ebp)
  800fec:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800fef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ff2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ff5:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800ff9:	c1 e0 10             	shl    $0x10,%eax
  800ffc:	09 45 f0             	or     %eax,-0x10(%ebp)
  800fff:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801002:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801005:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801008:	89 c2                	mov    %eax,%edx
  80100a:	b8 00 00 00 00       	mov    $0x0,%eax
  80100f:	09 45 f0             	or     %eax,-0x10(%ebp)
  801012:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801015:	eb 18                	jmp    80102f <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801017:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80101a:	8d 41 08             	lea    0x8(%ecx),%eax
  80101d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801020:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801023:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801026:	89 01                	mov    %eax,(%ecx)
  801028:	89 51 04             	mov    %edx,0x4(%ecx)
  80102b:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  80102f:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801033:	77 e2                	ja     801017 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801035:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801039:	74 23                	je     80105e <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  80103b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80103e:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801041:	eb 0e                	jmp    801051 <memset+0x91>
			*p8++ = (uint8)c;
  801043:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801046:	8d 50 01             	lea    0x1(%eax),%edx
  801049:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80104c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80104f:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801051:	8b 45 10             	mov    0x10(%ebp),%eax
  801054:	8d 50 ff             	lea    -0x1(%eax),%edx
  801057:	89 55 10             	mov    %edx,0x10(%ebp)
  80105a:	85 c0                	test   %eax,%eax
  80105c:	75 e5                	jne    801043 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  80105e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801061:	c9                   	leave  
  801062:	c3                   	ret    

00801063 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801063:	55                   	push   %ebp
  801064:	89 e5                	mov    %esp,%ebp
  801066:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801069:	8b 45 0c             	mov    0xc(%ebp),%eax
  80106c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  80106f:	8b 45 08             	mov    0x8(%ebp),%eax
  801072:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801075:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801079:	76 24                	jbe    80109f <memcpy+0x3c>
		while(n >= 8){
  80107b:	eb 1c                	jmp    801099 <memcpy+0x36>
			*d64 = *s64;
  80107d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801080:	8b 50 04             	mov    0x4(%eax),%edx
  801083:	8b 00                	mov    (%eax),%eax
  801085:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801088:	89 01                	mov    %eax,(%ecx)
  80108a:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  80108d:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801091:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801095:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801099:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80109d:	77 de                	ja     80107d <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  80109f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010a3:	74 31                	je     8010d6 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8010a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8010ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8010b1:	eb 16                	jmp    8010c9 <memcpy+0x66>
			*d8++ = *s8++;
  8010b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010b6:	8d 50 01             	lea    0x1(%eax),%edx
  8010b9:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8010bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010bf:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010c2:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8010c5:	8a 12                	mov    (%edx),%dl
  8010c7:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  8010c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8010cc:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010cf:	89 55 10             	mov    %edx,0x10(%ebp)
  8010d2:	85 c0                	test   %eax,%eax
  8010d4:	75 dd                	jne    8010b3 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  8010d6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010d9:	c9                   	leave  
  8010da:	c3                   	ret    

008010db <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8010db:	55                   	push   %ebp
  8010dc:	89 e5                	mov    %esp,%ebp
  8010de:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8010e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ea:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8010ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010f0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010f3:	73 50                	jae    801145 <memmove+0x6a>
  8010f5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8010fb:	01 d0                	add    %edx,%eax
  8010fd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801100:	76 43                	jbe    801145 <memmove+0x6a>
		s += n;
  801102:	8b 45 10             	mov    0x10(%ebp),%eax
  801105:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801108:	8b 45 10             	mov    0x10(%ebp),%eax
  80110b:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80110e:	eb 10                	jmp    801120 <memmove+0x45>
			*--d = *--s;
  801110:	ff 4d f8             	decl   -0x8(%ebp)
  801113:	ff 4d fc             	decl   -0x4(%ebp)
  801116:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801119:	8a 10                	mov    (%eax),%dl
  80111b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80111e:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801120:	8b 45 10             	mov    0x10(%ebp),%eax
  801123:	8d 50 ff             	lea    -0x1(%eax),%edx
  801126:	89 55 10             	mov    %edx,0x10(%ebp)
  801129:	85 c0                	test   %eax,%eax
  80112b:	75 e3                	jne    801110 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80112d:	eb 23                	jmp    801152 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80112f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801132:	8d 50 01             	lea    0x1(%eax),%edx
  801135:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801138:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80113b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80113e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801141:	8a 12                	mov    (%edx),%dl
  801143:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801145:	8b 45 10             	mov    0x10(%ebp),%eax
  801148:	8d 50 ff             	lea    -0x1(%eax),%edx
  80114b:	89 55 10             	mov    %edx,0x10(%ebp)
  80114e:	85 c0                	test   %eax,%eax
  801150:	75 dd                	jne    80112f <memmove+0x54>
			*d++ = *s++;

	return dst;
  801152:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801155:	c9                   	leave  
  801156:	c3                   	ret    

00801157 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801157:	55                   	push   %ebp
  801158:	89 e5                	mov    %esp,%ebp
  80115a:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80115d:	8b 45 08             	mov    0x8(%ebp),%eax
  801160:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801163:	8b 45 0c             	mov    0xc(%ebp),%eax
  801166:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801169:	eb 2a                	jmp    801195 <memcmp+0x3e>
		if (*s1 != *s2)
  80116b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80116e:	8a 10                	mov    (%eax),%dl
  801170:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801173:	8a 00                	mov    (%eax),%al
  801175:	38 c2                	cmp    %al,%dl
  801177:	74 16                	je     80118f <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801179:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80117c:	8a 00                	mov    (%eax),%al
  80117e:	0f b6 d0             	movzbl %al,%edx
  801181:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801184:	8a 00                	mov    (%eax),%al
  801186:	0f b6 c0             	movzbl %al,%eax
  801189:	29 c2                	sub    %eax,%edx
  80118b:	89 d0                	mov    %edx,%eax
  80118d:	eb 18                	jmp    8011a7 <memcmp+0x50>
		s1++, s2++;
  80118f:	ff 45 fc             	incl   -0x4(%ebp)
  801192:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801195:	8b 45 10             	mov    0x10(%ebp),%eax
  801198:	8d 50 ff             	lea    -0x1(%eax),%edx
  80119b:	89 55 10             	mov    %edx,0x10(%ebp)
  80119e:	85 c0                	test   %eax,%eax
  8011a0:	75 c9                	jne    80116b <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8011a2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011a7:	c9                   	leave  
  8011a8:	c3                   	ret    

008011a9 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8011a9:	55                   	push   %ebp
  8011aa:	89 e5                	mov    %esp,%ebp
  8011ac:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8011af:	8b 55 08             	mov    0x8(%ebp),%edx
  8011b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b5:	01 d0                	add    %edx,%eax
  8011b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8011ba:	eb 15                	jmp    8011d1 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8011bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bf:	8a 00                	mov    (%eax),%al
  8011c1:	0f b6 d0             	movzbl %al,%edx
  8011c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c7:	0f b6 c0             	movzbl %al,%eax
  8011ca:	39 c2                	cmp    %eax,%edx
  8011cc:	74 0d                	je     8011db <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8011ce:	ff 45 08             	incl   0x8(%ebp)
  8011d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8011d7:	72 e3                	jb     8011bc <memfind+0x13>
  8011d9:	eb 01                	jmp    8011dc <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8011db:	90                   	nop
	return (void *) s;
  8011dc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011df:	c9                   	leave  
  8011e0:	c3                   	ret    

008011e1 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8011e1:	55                   	push   %ebp
  8011e2:	89 e5                	mov    %esp,%ebp
  8011e4:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8011e7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8011ee:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011f5:	eb 03                	jmp    8011fa <strtol+0x19>
		s++;
  8011f7:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fd:	8a 00                	mov    (%eax),%al
  8011ff:	3c 20                	cmp    $0x20,%al
  801201:	74 f4                	je     8011f7 <strtol+0x16>
  801203:	8b 45 08             	mov    0x8(%ebp),%eax
  801206:	8a 00                	mov    (%eax),%al
  801208:	3c 09                	cmp    $0x9,%al
  80120a:	74 eb                	je     8011f7 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80120c:	8b 45 08             	mov    0x8(%ebp),%eax
  80120f:	8a 00                	mov    (%eax),%al
  801211:	3c 2b                	cmp    $0x2b,%al
  801213:	75 05                	jne    80121a <strtol+0x39>
		s++;
  801215:	ff 45 08             	incl   0x8(%ebp)
  801218:	eb 13                	jmp    80122d <strtol+0x4c>
	else if (*s == '-')
  80121a:	8b 45 08             	mov    0x8(%ebp),%eax
  80121d:	8a 00                	mov    (%eax),%al
  80121f:	3c 2d                	cmp    $0x2d,%al
  801221:	75 0a                	jne    80122d <strtol+0x4c>
		s++, neg = 1;
  801223:	ff 45 08             	incl   0x8(%ebp)
  801226:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80122d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801231:	74 06                	je     801239 <strtol+0x58>
  801233:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801237:	75 20                	jne    801259 <strtol+0x78>
  801239:	8b 45 08             	mov    0x8(%ebp),%eax
  80123c:	8a 00                	mov    (%eax),%al
  80123e:	3c 30                	cmp    $0x30,%al
  801240:	75 17                	jne    801259 <strtol+0x78>
  801242:	8b 45 08             	mov    0x8(%ebp),%eax
  801245:	40                   	inc    %eax
  801246:	8a 00                	mov    (%eax),%al
  801248:	3c 78                	cmp    $0x78,%al
  80124a:	75 0d                	jne    801259 <strtol+0x78>
		s += 2, base = 16;
  80124c:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801250:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801257:	eb 28                	jmp    801281 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801259:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80125d:	75 15                	jne    801274 <strtol+0x93>
  80125f:	8b 45 08             	mov    0x8(%ebp),%eax
  801262:	8a 00                	mov    (%eax),%al
  801264:	3c 30                	cmp    $0x30,%al
  801266:	75 0c                	jne    801274 <strtol+0x93>
		s++, base = 8;
  801268:	ff 45 08             	incl   0x8(%ebp)
  80126b:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801272:	eb 0d                	jmp    801281 <strtol+0xa0>
	else if (base == 0)
  801274:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801278:	75 07                	jne    801281 <strtol+0xa0>
		base = 10;
  80127a:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801281:	8b 45 08             	mov    0x8(%ebp),%eax
  801284:	8a 00                	mov    (%eax),%al
  801286:	3c 2f                	cmp    $0x2f,%al
  801288:	7e 19                	jle    8012a3 <strtol+0xc2>
  80128a:	8b 45 08             	mov    0x8(%ebp),%eax
  80128d:	8a 00                	mov    (%eax),%al
  80128f:	3c 39                	cmp    $0x39,%al
  801291:	7f 10                	jg     8012a3 <strtol+0xc2>
			dig = *s - '0';
  801293:	8b 45 08             	mov    0x8(%ebp),%eax
  801296:	8a 00                	mov    (%eax),%al
  801298:	0f be c0             	movsbl %al,%eax
  80129b:	83 e8 30             	sub    $0x30,%eax
  80129e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012a1:	eb 42                	jmp    8012e5 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8012a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a6:	8a 00                	mov    (%eax),%al
  8012a8:	3c 60                	cmp    $0x60,%al
  8012aa:	7e 19                	jle    8012c5 <strtol+0xe4>
  8012ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8012af:	8a 00                	mov    (%eax),%al
  8012b1:	3c 7a                	cmp    $0x7a,%al
  8012b3:	7f 10                	jg     8012c5 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8012b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b8:	8a 00                	mov    (%eax),%al
  8012ba:	0f be c0             	movsbl %al,%eax
  8012bd:	83 e8 57             	sub    $0x57,%eax
  8012c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012c3:	eb 20                	jmp    8012e5 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8012c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c8:	8a 00                	mov    (%eax),%al
  8012ca:	3c 40                	cmp    $0x40,%al
  8012cc:	7e 39                	jle    801307 <strtol+0x126>
  8012ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d1:	8a 00                	mov    (%eax),%al
  8012d3:	3c 5a                	cmp    $0x5a,%al
  8012d5:	7f 30                	jg     801307 <strtol+0x126>
			dig = *s - 'A' + 10;
  8012d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012da:	8a 00                	mov    (%eax),%al
  8012dc:	0f be c0             	movsbl %al,%eax
  8012df:	83 e8 37             	sub    $0x37,%eax
  8012e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8012e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012e8:	3b 45 10             	cmp    0x10(%ebp),%eax
  8012eb:	7d 19                	jge    801306 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8012ed:	ff 45 08             	incl   0x8(%ebp)
  8012f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012f3:	0f af 45 10          	imul   0x10(%ebp),%eax
  8012f7:	89 c2                	mov    %eax,%edx
  8012f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012fc:	01 d0                	add    %edx,%eax
  8012fe:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801301:	e9 7b ff ff ff       	jmp    801281 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801306:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801307:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80130b:	74 08                	je     801315 <strtol+0x134>
		*endptr = (char *) s;
  80130d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801310:	8b 55 08             	mov    0x8(%ebp),%edx
  801313:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801315:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801319:	74 07                	je     801322 <strtol+0x141>
  80131b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80131e:	f7 d8                	neg    %eax
  801320:	eb 03                	jmp    801325 <strtol+0x144>
  801322:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801325:	c9                   	leave  
  801326:	c3                   	ret    

00801327 <ltostr>:

void
ltostr(long value, char *str)
{
  801327:	55                   	push   %ebp
  801328:	89 e5                	mov    %esp,%ebp
  80132a:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80132d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801334:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80133b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80133f:	79 13                	jns    801354 <ltostr+0x2d>
	{
		neg = 1;
  801341:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801348:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134b:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80134e:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801351:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801354:	8b 45 08             	mov    0x8(%ebp),%eax
  801357:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80135c:	99                   	cltd   
  80135d:	f7 f9                	idiv   %ecx
  80135f:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801362:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801365:	8d 50 01             	lea    0x1(%eax),%edx
  801368:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80136b:	89 c2                	mov    %eax,%edx
  80136d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801370:	01 d0                	add    %edx,%eax
  801372:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801375:	83 c2 30             	add    $0x30,%edx
  801378:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80137a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80137d:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801382:	f7 e9                	imul   %ecx
  801384:	c1 fa 02             	sar    $0x2,%edx
  801387:	89 c8                	mov    %ecx,%eax
  801389:	c1 f8 1f             	sar    $0x1f,%eax
  80138c:	29 c2                	sub    %eax,%edx
  80138e:	89 d0                	mov    %edx,%eax
  801390:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801393:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801397:	75 bb                	jne    801354 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801399:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8013a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013a3:	48                   	dec    %eax
  8013a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8013a7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8013ab:	74 3d                	je     8013ea <ltostr+0xc3>
		start = 1 ;
  8013ad:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8013b4:	eb 34                	jmp    8013ea <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8013b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013bc:	01 d0                	add    %edx,%eax
  8013be:	8a 00                	mov    (%eax),%al
  8013c0:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8013c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c9:	01 c2                	add    %eax,%edx
  8013cb:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8013ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d1:	01 c8                	add    %ecx,%eax
  8013d3:	8a 00                	mov    (%eax),%al
  8013d5:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8013d7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013dd:	01 c2                	add    %eax,%edx
  8013df:	8a 45 eb             	mov    -0x15(%ebp),%al
  8013e2:	88 02                	mov    %al,(%edx)
		start++ ;
  8013e4:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8013e7:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8013ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013ed:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013f0:	7c c4                	jl     8013b6 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8013f2:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8013f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f8:	01 d0                	add    %edx,%eax
  8013fa:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8013fd:	90                   	nop
  8013fe:	c9                   	leave  
  8013ff:	c3                   	ret    

00801400 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801400:	55                   	push   %ebp
  801401:	89 e5                	mov    %esp,%ebp
  801403:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801406:	ff 75 08             	pushl  0x8(%ebp)
  801409:	e8 c4 f9 ff ff       	call   800dd2 <strlen>
  80140e:	83 c4 04             	add    $0x4,%esp
  801411:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801414:	ff 75 0c             	pushl  0xc(%ebp)
  801417:	e8 b6 f9 ff ff       	call   800dd2 <strlen>
  80141c:	83 c4 04             	add    $0x4,%esp
  80141f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801422:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801429:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801430:	eb 17                	jmp    801449 <strcconcat+0x49>
		final[s] = str1[s] ;
  801432:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801435:	8b 45 10             	mov    0x10(%ebp),%eax
  801438:	01 c2                	add    %eax,%edx
  80143a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80143d:	8b 45 08             	mov    0x8(%ebp),%eax
  801440:	01 c8                	add    %ecx,%eax
  801442:	8a 00                	mov    (%eax),%al
  801444:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801446:	ff 45 fc             	incl   -0x4(%ebp)
  801449:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80144c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80144f:	7c e1                	jl     801432 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801451:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801458:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80145f:	eb 1f                	jmp    801480 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801461:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801464:	8d 50 01             	lea    0x1(%eax),%edx
  801467:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80146a:	89 c2                	mov    %eax,%edx
  80146c:	8b 45 10             	mov    0x10(%ebp),%eax
  80146f:	01 c2                	add    %eax,%edx
  801471:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801474:	8b 45 0c             	mov    0xc(%ebp),%eax
  801477:	01 c8                	add    %ecx,%eax
  801479:	8a 00                	mov    (%eax),%al
  80147b:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80147d:	ff 45 f8             	incl   -0x8(%ebp)
  801480:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801483:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801486:	7c d9                	jl     801461 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801488:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80148b:	8b 45 10             	mov    0x10(%ebp),%eax
  80148e:	01 d0                	add    %edx,%eax
  801490:	c6 00 00             	movb   $0x0,(%eax)
}
  801493:	90                   	nop
  801494:	c9                   	leave  
  801495:	c3                   	ret    

00801496 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801496:	55                   	push   %ebp
  801497:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801499:	8b 45 14             	mov    0x14(%ebp),%eax
  80149c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8014a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8014a5:	8b 00                	mov    (%eax),%eax
  8014a7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8014b1:	01 d0                	add    %edx,%eax
  8014b3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014b9:	eb 0c                	jmp    8014c7 <strsplit+0x31>
			*string++ = 0;
  8014bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014be:	8d 50 01             	lea    0x1(%eax),%edx
  8014c1:	89 55 08             	mov    %edx,0x8(%ebp)
  8014c4:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ca:	8a 00                	mov    (%eax),%al
  8014cc:	84 c0                	test   %al,%al
  8014ce:	74 18                	je     8014e8 <strsplit+0x52>
  8014d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d3:	8a 00                	mov    (%eax),%al
  8014d5:	0f be c0             	movsbl %al,%eax
  8014d8:	50                   	push   %eax
  8014d9:	ff 75 0c             	pushl  0xc(%ebp)
  8014dc:	e8 83 fa ff ff       	call   800f64 <strchr>
  8014e1:	83 c4 08             	add    $0x8,%esp
  8014e4:	85 c0                	test   %eax,%eax
  8014e6:	75 d3                	jne    8014bb <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8014e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014eb:	8a 00                	mov    (%eax),%al
  8014ed:	84 c0                	test   %al,%al
  8014ef:	74 5a                	je     80154b <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8014f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8014f4:	8b 00                	mov    (%eax),%eax
  8014f6:	83 f8 0f             	cmp    $0xf,%eax
  8014f9:	75 07                	jne    801502 <strsplit+0x6c>
		{
			return 0;
  8014fb:	b8 00 00 00 00       	mov    $0x0,%eax
  801500:	eb 66                	jmp    801568 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801502:	8b 45 14             	mov    0x14(%ebp),%eax
  801505:	8b 00                	mov    (%eax),%eax
  801507:	8d 48 01             	lea    0x1(%eax),%ecx
  80150a:	8b 55 14             	mov    0x14(%ebp),%edx
  80150d:	89 0a                	mov    %ecx,(%edx)
  80150f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801516:	8b 45 10             	mov    0x10(%ebp),%eax
  801519:	01 c2                	add    %eax,%edx
  80151b:	8b 45 08             	mov    0x8(%ebp),%eax
  80151e:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801520:	eb 03                	jmp    801525 <strsplit+0x8f>
			string++;
  801522:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801525:	8b 45 08             	mov    0x8(%ebp),%eax
  801528:	8a 00                	mov    (%eax),%al
  80152a:	84 c0                	test   %al,%al
  80152c:	74 8b                	je     8014b9 <strsplit+0x23>
  80152e:	8b 45 08             	mov    0x8(%ebp),%eax
  801531:	8a 00                	mov    (%eax),%al
  801533:	0f be c0             	movsbl %al,%eax
  801536:	50                   	push   %eax
  801537:	ff 75 0c             	pushl  0xc(%ebp)
  80153a:	e8 25 fa ff ff       	call   800f64 <strchr>
  80153f:	83 c4 08             	add    $0x8,%esp
  801542:	85 c0                	test   %eax,%eax
  801544:	74 dc                	je     801522 <strsplit+0x8c>
			string++;
	}
  801546:	e9 6e ff ff ff       	jmp    8014b9 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80154b:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80154c:	8b 45 14             	mov    0x14(%ebp),%eax
  80154f:	8b 00                	mov    (%eax),%eax
  801551:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801558:	8b 45 10             	mov    0x10(%ebp),%eax
  80155b:	01 d0                	add    %edx,%eax
  80155d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801563:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801568:	c9                   	leave  
  801569:	c3                   	ret    

0080156a <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80156a:	55                   	push   %ebp
  80156b:	89 e5                	mov    %esp,%ebp
  80156d:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801570:	8b 45 08             	mov    0x8(%ebp),%eax
  801573:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801576:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80157d:	eb 4a                	jmp    8015c9 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  80157f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801582:	8b 45 08             	mov    0x8(%ebp),%eax
  801585:	01 c2                	add    %eax,%edx
  801587:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80158a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80158d:	01 c8                	add    %ecx,%eax
  80158f:	8a 00                	mov    (%eax),%al
  801591:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801593:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801596:	8b 45 0c             	mov    0xc(%ebp),%eax
  801599:	01 d0                	add    %edx,%eax
  80159b:	8a 00                	mov    (%eax),%al
  80159d:	3c 40                	cmp    $0x40,%al
  80159f:	7e 25                	jle    8015c6 <str2lower+0x5c>
  8015a1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a7:	01 d0                	add    %edx,%eax
  8015a9:	8a 00                	mov    (%eax),%al
  8015ab:	3c 5a                	cmp    $0x5a,%al
  8015ad:	7f 17                	jg     8015c6 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8015af:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b5:	01 d0                	add    %edx,%eax
  8015b7:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8015bd:	01 ca                	add    %ecx,%edx
  8015bf:	8a 12                	mov    (%edx),%dl
  8015c1:	83 c2 20             	add    $0x20,%edx
  8015c4:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8015c6:	ff 45 fc             	incl   -0x4(%ebp)
  8015c9:	ff 75 0c             	pushl  0xc(%ebp)
  8015cc:	e8 01 f8 ff ff       	call   800dd2 <strlen>
  8015d1:	83 c4 04             	add    $0x4,%esp
  8015d4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8015d7:	7f a6                	jg     80157f <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8015d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8015dc:	c9                   	leave  
  8015dd:	c3                   	ret    

008015de <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  8015de:	55                   	push   %ebp
  8015df:	89 e5                	mov    %esp,%ebp
  8015e1:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  8015e4:	a1 08 30 80 00       	mov    0x803008,%eax
  8015e9:	85 c0                	test   %eax,%eax
  8015eb:	74 42                	je     80162f <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  8015ed:	83 ec 08             	sub    $0x8,%esp
  8015f0:	68 00 00 00 82       	push   $0x82000000
  8015f5:	68 00 00 00 80       	push   $0x80000000
  8015fa:	e8 8c 07 00 00       	call   801d8b <initialize_dynamic_allocator>
  8015ff:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801602:	e8 e7 05 00 00       	call   801bee <sys_get_uheap_strategy>
  801607:	a3 60 b0 81 00       	mov    %eax,0x81b060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  80160c:	a1 40 30 80 00       	mov    0x803040,%eax
  801611:	05 00 10 00 00       	add    $0x1000,%eax
  801616:	a3 10 b1 81 00       	mov    %eax,0x81b110
		uheapPageAllocBreak = uheapPageAllocStart;
  80161b:	a1 10 b1 81 00       	mov    0x81b110,%eax
  801620:	a3 68 b0 81 00       	mov    %eax,0x81b068

		__firstTimeFlag = 0;
  801625:	c7 05 08 30 80 00 00 	movl   $0x0,0x803008
  80162c:	00 00 00 
	}
}
  80162f:	90                   	nop
  801630:	c9                   	leave  
  801631:	c3                   	ret    

00801632 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801632:	55                   	push   %ebp
  801633:	89 e5                	mov    %esp,%ebp
  801635:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801638:	8b 45 08             	mov    0x8(%ebp),%eax
  80163b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80163e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801641:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801646:	83 ec 08             	sub    $0x8,%esp
  801649:	68 06 04 00 00       	push   $0x406
  80164e:	50                   	push   %eax
  80164f:	e8 e4 01 00 00       	call   801838 <__sys_allocate_page>
  801654:	83 c4 10             	add    $0x10,%esp
  801657:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  80165a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80165e:	79 14                	jns    801674 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801660:	83 ec 04             	sub    $0x4,%esp
  801663:	68 c8 2b 80 00       	push   $0x802bc8
  801668:	6a 1f                	push   $0x1f
  80166a:	68 04 2c 80 00       	push   $0x802c04
  80166f:	e8 b7 ed ff ff       	call   80042b <_panic>
	return 0;
  801674:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801679:	c9                   	leave  
  80167a:	c3                   	ret    

0080167b <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  80167b:	55                   	push   %ebp
  80167c:	89 e5                	mov    %esp,%ebp
  80167e:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801681:	8b 45 08             	mov    0x8(%ebp),%eax
  801684:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801687:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80168a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80168f:	83 ec 0c             	sub    $0xc,%esp
  801692:	50                   	push   %eax
  801693:	e8 e7 01 00 00       	call   80187f <__sys_unmap_frame>
  801698:	83 c4 10             	add    $0x10,%esp
  80169b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  80169e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8016a2:	79 14                	jns    8016b8 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  8016a4:	83 ec 04             	sub    $0x4,%esp
  8016a7:	68 10 2c 80 00       	push   $0x802c10
  8016ac:	6a 2a                	push   $0x2a
  8016ae:	68 04 2c 80 00       	push   $0x802c04
  8016b3:	e8 73 ed ff ff       	call   80042b <_panic>
}
  8016b8:	90                   	nop
  8016b9:	c9                   	leave  
  8016ba:	c3                   	ret    

008016bb <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  8016bb:	55                   	push   %ebp
  8016bc:	89 e5                	mov    %esp,%ebp
  8016be:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8016c1:	e8 18 ff ff ff       	call   8015de <uheap_init>
	if (size == 0) return NULL ;
  8016c6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8016ca:	75 07                	jne    8016d3 <malloc+0x18>
  8016cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8016d1:	eb 14                	jmp    8016e7 <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  8016d3:	83 ec 04             	sub    $0x4,%esp
  8016d6:	68 50 2c 80 00       	push   $0x802c50
  8016db:	6a 3e                	push   $0x3e
  8016dd:	68 04 2c 80 00       	push   $0x802c04
  8016e2:	e8 44 ed ff ff       	call   80042b <_panic>
}
  8016e7:	c9                   	leave  
  8016e8:	c3                   	ret    

008016e9 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  8016e9:	55                   	push   %ebp
  8016ea:	89 e5                	mov    %esp,%ebp
  8016ec:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  8016ef:	83 ec 04             	sub    $0x4,%esp
  8016f2:	68 78 2c 80 00       	push   $0x802c78
  8016f7:	6a 49                	push   $0x49
  8016f9:	68 04 2c 80 00       	push   $0x802c04
  8016fe:	e8 28 ed ff ff       	call   80042b <_panic>

00801703 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801703:	55                   	push   %ebp
  801704:	89 e5                	mov    %esp,%ebp
  801706:	83 ec 18             	sub    $0x18,%esp
  801709:	8b 45 10             	mov    0x10(%ebp),%eax
  80170c:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80170f:	e8 ca fe ff ff       	call   8015de <uheap_init>
	if (size == 0) return NULL ;
  801714:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801718:	75 07                	jne    801721 <smalloc+0x1e>
  80171a:	b8 00 00 00 00       	mov    $0x0,%eax
  80171f:	eb 14                	jmp    801735 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  801721:	83 ec 04             	sub    $0x4,%esp
  801724:	68 9c 2c 80 00       	push   $0x802c9c
  801729:	6a 5a                	push   $0x5a
  80172b:	68 04 2c 80 00       	push   $0x802c04
  801730:	e8 f6 ec ff ff       	call   80042b <_panic>
}
  801735:	c9                   	leave  
  801736:	c3                   	ret    

00801737 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801737:	55                   	push   %ebp
  801738:	89 e5                	mov    %esp,%ebp
  80173a:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80173d:	e8 9c fe ff ff       	call   8015de <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  801742:	83 ec 04             	sub    $0x4,%esp
  801745:	68 c4 2c 80 00       	push   $0x802cc4
  80174a:	6a 6a                	push   $0x6a
  80174c:	68 04 2c 80 00       	push   $0x802c04
  801751:	e8 d5 ec ff ff       	call   80042b <_panic>

00801756 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801756:	55                   	push   %ebp
  801757:	89 e5                	mov    %esp,%ebp
  801759:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80175c:	e8 7d fe ff ff       	call   8015de <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  801761:	83 ec 04             	sub    $0x4,%esp
  801764:	68 e8 2c 80 00       	push   $0x802ce8
  801769:	68 88 00 00 00       	push   $0x88
  80176e:	68 04 2c 80 00       	push   $0x802c04
  801773:	e8 b3 ec ff ff       	call   80042b <_panic>

00801778 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  801778:	55                   	push   %ebp
  801779:	89 e5                	mov    %esp,%ebp
  80177b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  80177e:	83 ec 04             	sub    $0x4,%esp
  801781:	68 10 2d 80 00       	push   $0x802d10
  801786:	68 9b 00 00 00       	push   $0x9b
  80178b:	68 04 2c 80 00       	push   $0x802c04
  801790:	e8 96 ec ff ff       	call   80042b <_panic>

00801795 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801795:	55                   	push   %ebp
  801796:	89 e5                	mov    %esp,%ebp
  801798:	57                   	push   %edi
  801799:	56                   	push   %esi
  80179a:	53                   	push   %ebx
  80179b:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80179e:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017a4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017a7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017aa:	8b 7d 18             	mov    0x18(%ebp),%edi
  8017ad:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8017b0:	cd 30                	int    $0x30
  8017b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8017b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8017b8:	83 c4 10             	add    $0x10,%esp
  8017bb:	5b                   	pop    %ebx
  8017bc:	5e                   	pop    %esi
  8017bd:	5f                   	pop    %edi
  8017be:	5d                   	pop    %ebp
  8017bf:	c3                   	ret    

008017c0 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8017c0:	55                   	push   %ebp
  8017c1:	89 e5                	mov    %esp,%ebp
  8017c3:	83 ec 04             	sub    $0x4,%esp
  8017c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8017c9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8017cc:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8017cf:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d6:	6a 00                	push   $0x0
  8017d8:	51                   	push   %ecx
  8017d9:	52                   	push   %edx
  8017da:	ff 75 0c             	pushl  0xc(%ebp)
  8017dd:	50                   	push   %eax
  8017de:	6a 00                	push   $0x0
  8017e0:	e8 b0 ff ff ff       	call   801795 <syscall>
  8017e5:	83 c4 18             	add    $0x18,%esp
}
  8017e8:	90                   	nop
  8017e9:	c9                   	leave  
  8017ea:	c3                   	ret    

008017eb <sys_cgetc>:

int
sys_cgetc(void)
{
  8017eb:	55                   	push   %ebp
  8017ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8017ee:	6a 00                	push   $0x0
  8017f0:	6a 00                	push   $0x0
  8017f2:	6a 00                	push   $0x0
  8017f4:	6a 00                	push   $0x0
  8017f6:	6a 00                	push   $0x0
  8017f8:	6a 02                	push   $0x2
  8017fa:	e8 96 ff ff ff       	call   801795 <syscall>
  8017ff:	83 c4 18             	add    $0x18,%esp
}
  801802:	c9                   	leave  
  801803:	c3                   	ret    

00801804 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801804:	55                   	push   %ebp
  801805:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801807:	6a 00                	push   $0x0
  801809:	6a 00                	push   $0x0
  80180b:	6a 00                	push   $0x0
  80180d:	6a 00                	push   $0x0
  80180f:	6a 00                	push   $0x0
  801811:	6a 03                	push   $0x3
  801813:	e8 7d ff ff ff       	call   801795 <syscall>
  801818:	83 c4 18             	add    $0x18,%esp
}
  80181b:	90                   	nop
  80181c:	c9                   	leave  
  80181d:	c3                   	ret    

0080181e <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80181e:	55                   	push   %ebp
  80181f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801821:	6a 00                	push   $0x0
  801823:	6a 00                	push   $0x0
  801825:	6a 00                	push   $0x0
  801827:	6a 00                	push   $0x0
  801829:	6a 00                	push   $0x0
  80182b:	6a 04                	push   $0x4
  80182d:	e8 63 ff ff ff       	call   801795 <syscall>
  801832:	83 c4 18             	add    $0x18,%esp
}
  801835:	90                   	nop
  801836:	c9                   	leave  
  801837:	c3                   	ret    

00801838 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801838:	55                   	push   %ebp
  801839:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80183b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80183e:	8b 45 08             	mov    0x8(%ebp),%eax
  801841:	6a 00                	push   $0x0
  801843:	6a 00                	push   $0x0
  801845:	6a 00                	push   $0x0
  801847:	52                   	push   %edx
  801848:	50                   	push   %eax
  801849:	6a 08                	push   $0x8
  80184b:	e8 45 ff ff ff       	call   801795 <syscall>
  801850:	83 c4 18             	add    $0x18,%esp
}
  801853:	c9                   	leave  
  801854:	c3                   	ret    

00801855 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801855:	55                   	push   %ebp
  801856:	89 e5                	mov    %esp,%ebp
  801858:	56                   	push   %esi
  801859:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80185a:	8b 75 18             	mov    0x18(%ebp),%esi
  80185d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801860:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801863:	8b 55 0c             	mov    0xc(%ebp),%edx
  801866:	8b 45 08             	mov    0x8(%ebp),%eax
  801869:	56                   	push   %esi
  80186a:	53                   	push   %ebx
  80186b:	51                   	push   %ecx
  80186c:	52                   	push   %edx
  80186d:	50                   	push   %eax
  80186e:	6a 09                	push   $0x9
  801870:	e8 20 ff ff ff       	call   801795 <syscall>
  801875:	83 c4 18             	add    $0x18,%esp
}
  801878:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80187b:	5b                   	pop    %ebx
  80187c:	5e                   	pop    %esi
  80187d:	5d                   	pop    %ebp
  80187e:	c3                   	ret    

0080187f <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  80187f:	55                   	push   %ebp
  801880:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801882:	6a 00                	push   $0x0
  801884:	6a 00                	push   $0x0
  801886:	6a 00                	push   $0x0
  801888:	6a 00                	push   $0x0
  80188a:	ff 75 08             	pushl  0x8(%ebp)
  80188d:	6a 0a                	push   $0xa
  80188f:	e8 01 ff ff ff       	call   801795 <syscall>
  801894:	83 c4 18             	add    $0x18,%esp
}
  801897:	c9                   	leave  
  801898:	c3                   	ret    

00801899 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801899:	55                   	push   %ebp
  80189a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80189c:	6a 00                	push   $0x0
  80189e:	6a 00                	push   $0x0
  8018a0:	6a 00                	push   $0x0
  8018a2:	ff 75 0c             	pushl  0xc(%ebp)
  8018a5:	ff 75 08             	pushl  0x8(%ebp)
  8018a8:	6a 0b                	push   $0xb
  8018aa:	e8 e6 fe ff ff       	call   801795 <syscall>
  8018af:	83 c4 18             	add    $0x18,%esp
}
  8018b2:	c9                   	leave  
  8018b3:	c3                   	ret    

008018b4 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8018b4:	55                   	push   %ebp
  8018b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8018b7:	6a 00                	push   $0x0
  8018b9:	6a 00                	push   $0x0
  8018bb:	6a 00                	push   $0x0
  8018bd:	6a 00                	push   $0x0
  8018bf:	6a 00                	push   $0x0
  8018c1:	6a 0c                	push   $0xc
  8018c3:	e8 cd fe ff ff       	call   801795 <syscall>
  8018c8:	83 c4 18             	add    $0x18,%esp
}
  8018cb:	c9                   	leave  
  8018cc:	c3                   	ret    

008018cd <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8018cd:	55                   	push   %ebp
  8018ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8018d0:	6a 00                	push   $0x0
  8018d2:	6a 00                	push   $0x0
  8018d4:	6a 00                	push   $0x0
  8018d6:	6a 00                	push   $0x0
  8018d8:	6a 00                	push   $0x0
  8018da:	6a 0d                	push   $0xd
  8018dc:	e8 b4 fe ff ff       	call   801795 <syscall>
  8018e1:	83 c4 18             	add    $0x18,%esp
}
  8018e4:	c9                   	leave  
  8018e5:	c3                   	ret    

008018e6 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8018e6:	55                   	push   %ebp
  8018e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8018e9:	6a 00                	push   $0x0
  8018eb:	6a 00                	push   $0x0
  8018ed:	6a 00                	push   $0x0
  8018ef:	6a 00                	push   $0x0
  8018f1:	6a 00                	push   $0x0
  8018f3:	6a 0e                	push   $0xe
  8018f5:	e8 9b fe ff ff       	call   801795 <syscall>
  8018fa:	83 c4 18             	add    $0x18,%esp
}
  8018fd:	c9                   	leave  
  8018fe:	c3                   	ret    

008018ff <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8018ff:	55                   	push   %ebp
  801900:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801902:	6a 00                	push   $0x0
  801904:	6a 00                	push   $0x0
  801906:	6a 00                	push   $0x0
  801908:	6a 00                	push   $0x0
  80190a:	6a 00                	push   $0x0
  80190c:	6a 0f                	push   $0xf
  80190e:	e8 82 fe ff ff       	call   801795 <syscall>
  801913:	83 c4 18             	add    $0x18,%esp
}
  801916:	c9                   	leave  
  801917:	c3                   	ret    

00801918 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801918:	55                   	push   %ebp
  801919:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80191b:	6a 00                	push   $0x0
  80191d:	6a 00                	push   $0x0
  80191f:	6a 00                	push   $0x0
  801921:	6a 00                	push   $0x0
  801923:	ff 75 08             	pushl  0x8(%ebp)
  801926:	6a 10                	push   $0x10
  801928:	e8 68 fe ff ff       	call   801795 <syscall>
  80192d:	83 c4 18             	add    $0x18,%esp
}
  801930:	c9                   	leave  
  801931:	c3                   	ret    

00801932 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801932:	55                   	push   %ebp
  801933:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801935:	6a 00                	push   $0x0
  801937:	6a 00                	push   $0x0
  801939:	6a 00                	push   $0x0
  80193b:	6a 00                	push   $0x0
  80193d:	6a 00                	push   $0x0
  80193f:	6a 11                	push   $0x11
  801941:	e8 4f fe ff ff       	call   801795 <syscall>
  801946:	83 c4 18             	add    $0x18,%esp
}
  801949:	90                   	nop
  80194a:	c9                   	leave  
  80194b:	c3                   	ret    

0080194c <sys_cputc>:

void
sys_cputc(const char c)
{
  80194c:	55                   	push   %ebp
  80194d:	89 e5                	mov    %esp,%ebp
  80194f:	83 ec 04             	sub    $0x4,%esp
  801952:	8b 45 08             	mov    0x8(%ebp),%eax
  801955:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801958:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80195c:	6a 00                	push   $0x0
  80195e:	6a 00                	push   $0x0
  801960:	6a 00                	push   $0x0
  801962:	6a 00                	push   $0x0
  801964:	50                   	push   %eax
  801965:	6a 01                	push   $0x1
  801967:	e8 29 fe ff ff       	call   801795 <syscall>
  80196c:	83 c4 18             	add    $0x18,%esp
}
  80196f:	90                   	nop
  801970:	c9                   	leave  
  801971:	c3                   	ret    

00801972 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801972:	55                   	push   %ebp
  801973:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801975:	6a 00                	push   $0x0
  801977:	6a 00                	push   $0x0
  801979:	6a 00                	push   $0x0
  80197b:	6a 00                	push   $0x0
  80197d:	6a 00                	push   $0x0
  80197f:	6a 14                	push   $0x14
  801981:	e8 0f fe ff ff       	call   801795 <syscall>
  801986:	83 c4 18             	add    $0x18,%esp
}
  801989:	90                   	nop
  80198a:	c9                   	leave  
  80198b:	c3                   	ret    

0080198c <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80198c:	55                   	push   %ebp
  80198d:	89 e5                	mov    %esp,%ebp
  80198f:	83 ec 04             	sub    $0x4,%esp
  801992:	8b 45 10             	mov    0x10(%ebp),%eax
  801995:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801998:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80199b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80199f:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a2:	6a 00                	push   $0x0
  8019a4:	51                   	push   %ecx
  8019a5:	52                   	push   %edx
  8019a6:	ff 75 0c             	pushl  0xc(%ebp)
  8019a9:	50                   	push   %eax
  8019aa:	6a 15                	push   $0x15
  8019ac:	e8 e4 fd ff ff       	call   801795 <syscall>
  8019b1:	83 c4 18             	add    $0x18,%esp
}
  8019b4:	c9                   	leave  
  8019b5:	c3                   	ret    

008019b6 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8019b6:	55                   	push   %ebp
  8019b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8019b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 00                	push   $0x0
  8019c5:	52                   	push   %edx
  8019c6:	50                   	push   %eax
  8019c7:	6a 16                	push   $0x16
  8019c9:	e8 c7 fd ff ff       	call   801795 <syscall>
  8019ce:	83 c4 18             	add    $0x18,%esp
}
  8019d1:	c9                   	leave  
  8019d2:	c3                   	ret    

008019d3 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8019d3:	55                   	push   %ebp
  8019d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8019d6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 00                	push   $0x0
  8019e3:	51                   	push   %ecx
  8019e4:	52                   	push   %edx
  8019e5:	50                   	push   %eax
  8019e6:	6a 17                	push   $0x17
  8019e8:	e8 a8 fd ff ff       	call   801795 <syscall>
  8019ed:	83 c4 18             	add    $0x18,%esp
}
  8019f0:	c9                   	leave  
  8019f1:	c3                   	ret    

008019f2 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8019f2:	55                   	push   %ebp
  8019f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8019f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fb:	6a 00                	push   $0x0
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 00                	push   $0x0
  801a01:	52                   	push   %edx
  801a02:	50                   	push   %eax
  801a03:	6a 18                	push   $0x18
  801a05:	e8 8b fd ff ff       	call   801795 <syscall>
  801a0a:	83 c4 18             	add    $0x18,%esp
}
  801a0d:	c9                   	leave  
  801a0e:	c3                   	ret    

00801a0f <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a0f:	55                   	push   %ebp
  801a10:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a12:	8b 45 08             	mov    0x8(%ebp),%eax
  801a15:	6a 00                	push   $0x0
  801a17:	ff 75 14             	pushl  0x14(%ebp)
  801a1a:	ff 75 10             	pushl  0x10(%ebp)
  801a1d:	ff 75 0c             	pushl  0xc(%ebp)
  801a20:	50                   	push   %eax
  801a21:	6a 19                	push   $0x19
  801a23:	e8 6d fd ff ff       	call   801795 <syscall>
  801a28:	83 c4 18             	add    $0x18,%esp
}
  801a2b:	c9                   	leave  
  801a2c:	c3                   	ret    

00801a2d <sys_run_env>:

void sys_run_env(int32 envId)
{
  801a2d:	55                   	push   %ebp
  801a2e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a30:	8b 45 08             	mov    0x8(%ebp),%eax
  801a33:	6a 00                	push   $0x0
  801a35:	6a 00                	push   $0x0
  801a37:	6a 00                	push   $0x0
  801a39:	6a 00                	push   $0x0
  801a3b:	50                   	push   %eax
  801a3c:	6a 1a                	push   $0x1a
  801a3e:	e8 52 fd ff ff       	call   801795 <syscall>
  801a43:	83 c4 18             	add    $0x18,%esp
}
  801a46:	90                   	nop
  801a47:	c9                   	leave  
  801a48:	c3                   	ret    

00801a49 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801a49:	55                   	push   %ebp
  801a4a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4f:	6a 00                	push   $0x0
  801a51:	6a 00                	push   $0x0
  801a53:	6a 00                	push   $0x0
  801a55:	6a 00                	push   $0x0
  801a57:	50                   	push   %eax
  801a58:	6a 1b                	push   $0x1b
  801a5a:	e8 36 fd ff ff       	call   801795 <syscall>
  801a5f:	83 c4 18             	add    $0x18,%esp
}
  801a62:	c9                   	leave  
  801a63:	c3                   	ret    

00801a64 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801a64:	55                   	push   %ebp
  801a65:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801a67:	6a 00                	push   $0x0
  801a69:	6a 00                	push   $0x0
  801a6b:	6a 00                	push   $0x0
  801a6d:	6a 00                	push   $0x0
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 05                	push   $0x5
  801a73:	e8 1d fd ff ff       	call   801795 <syscall>
  801a78:	83 c4 18             	add    $0x18,%esp
}
  801a7b:	c9                   	leave  
  801a7c:	c3                   	ret    

00801a7d <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801a7d:	55                   	push   %ebp
  801a7e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801a80:	6a 00                	push   $0x0
  801a82:	6a 00                	push   $0x0
  801a84:	6a 00                	push   $0x0
  801a86:	6a 00                	push   $0x0
  801a88:	6a 00                	push   $0x0
  801a8a:	6a 06                	push   $0x6
  801a8c:	e8 04 fd ff ff       	call   801795 <syscall>
  801a91:	83 c4 18             	add    $0x18,%esp
}
  801a94:	c9                   	leave  
  801a95:	c3                   	ret    

00801a96 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801a96:	55                   	push   %ebp
  801a97:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 00                	push   $0x0
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 00                	push   $0x0
  801aa3:	6a 07                	push   $0x7
  801aa5:	e8 eb fc ff ff       	call   801795 <syscall>
  801aaa:	83 c4 18             	add    $0x18,%esp
}
  801aad:	c9                   	leave  
  801aae:	c3                   	ret    

00801aaf <sys_exit_env>:


void sys_exit_env(void)
{
  801aaf:	55                   	push   %ebp
  801ab0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	6a 1c                	push   $0x1c
  801abe:	e8 d2 fc ff ff       	call   801795 <syscall>
  801ac3:	83 c4 18             	add    $0x18,%esp
}
  801ac6:	90                   	nop
  801ac7:	c9                   	leave  
  801ac8:	c3                   	ret    

00801ac9 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801ac9:	55                   	push   %ebp
  801aca:	89 e5                	mov    %esp,%ebp
  801acc:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801acf:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ad2:	8d 50 04             	lea    0x4(%eax),%edx
  801ad5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ad8:	6a 00                	push   $0x0
  801ada:	6a 00                	push   $0x0
  801adc:	6a 00                	push   $0x0
  801ade:	52                   	push   %edx
  801adf:	50                   	push   %eax
  801ae0:	6a 1d                	push   $0x1d
  801ae2:	e8 ae fc ff ff       	call   801795 <syscall>
  801ae7:	83 c4 18             	add    $0x18,%esp
	return result;
  801aea:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801aed:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801af0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801af3:	89 01                	mov    %eax,(%ecx)
  801af5:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801af8:	8b 45 08             	mov    0x8(%ebp),%eax
  801afb:	c9                   	leave  
  801afc:	c2 04 00             	ret    $0x4

00801aff <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801aff:	55                   	push   %ebp
  801b00:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b02:	6a 00                	push   $0x0
  801b04:	6a 00                	push   $0x0
  801b06:	ff 75 10             	pushl  0x10(%ebp)
  801b09:	ff 75 0c             	pushl  0xc(%ebp)
  801b0c:	ff 75 08             	pushl  0x8(%ebp)
  801b0f:	6a 13                	push   $0x13
  801b11:	e8 7f fc ff ff       	call   801795 <syscall>
  801b16:	83 c4 18             	add    $0x18,%esp
	return ;
  801b19:	90                   	nop
}
  801b1a:	c9                   	leave  
  801b1b:	c3                   	ret    

00801b1c <sys_rcr2>:
uint32 sys_rcr2()
{
  801b1c:	55                   	push   %ebp
  801b1d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b1f:	6a 00                	push   $0x0
  801b21:	6a 00                	push   $0x0
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	6a 1e                	push   $0x1e
  801b2b:	e8 65 fc ff ff       	call   801795 <syscall>
  801b30:	83 c4 18             	add    $0x18,%esp
}
  801b33:	c9                   	leave  
  801b34:	c3                   	ret    

00801b35 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801b35:	55                   	push   %ebp
  801b36:	89 e5                	mov    %esp,%ebp
  801b38:	83 ec 04             	sub    $0x4,%esp
  801b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801b41:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801b45:	6a 00                	push   $0x0
  801b47:	6a 00                	push   $0x0
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 00                	push   $0x0
  801b4d:	50                   	push   %eax
  801b4e:	6a 1f                	push   $0x1f
  801b50:	e8 40 fc ff ff       	call   801795 <syscall>
  801b55:	83 c4 18             	add    $0x18,%esp
	return ;
  801b58:	90                   	nop
}
  801b59:	c9                   	leave  
  801b5a:	c3                   	ret    

00801b5b <rsttst>:
void rsttst()
{
  801b5b:	55                   	push   %ebp
  801b5c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801b5e:	6a 00                	push   $0x0
  801b60:	6a 00                	push   $0x0
  801b62:	6a 00                	push   $0x0
  801b64:	6a 00                	push   $0x0
  801b66:	6a 00                	push   $0x0
  801b68:	6a 21                	push   $0x21
  801b6a:	e8 26 fc ff ff       	call   801795 <syscall>
  801b6f:	83 c4 18             	add    $0x18,%esp
	return ;
  801b72:	90                   	nop
}
  801b73:	c9                   	leave  
  801b74:	c3                   	ret    

00801b75 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801b75:	55                   	push   %ebp
  801b76:	89 e5                	mov    %esp,%ebp
  801b78:	83 ec 04             	sub    $0x4,%esp
  801b7b:	8b 45 14             	mov    0x14(%ebp),%eax
  801b7e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801b81:	8b 55 18             	mov    0x18(%ebp),%edx
  801b84:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b88:	52                   	push   %edx
  801b89:	50                   	push   %eax
  801b8a:	ff 75 10             	pushl  0x10(%ebp)
  801b8d:	ff 75 0c             	pushl  0xc(%ebp)
  801b90:	ff 75 08             	pushl  0x8(%ebp)
  801b93:	6a 20                	push   $0x20
  801b95:	e8 fb fb ff ff       	call   801795 <syscall>
  801b9a:	83 c4 18             	add    $0x18,%esp
	return ;
  801b9d:	90                   	nop
}
  801b9e:	c9                   	leave  
  801b9f:	c3                   	ret    

00801ba0 <chktst>:
void chktst(uint32 n)
{
  801ba0:	55                   	push   %ebp
  801ba1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	ff 75 08             	pushl  0x8(%ebp)
  801bae:	6a 22                	push   $0x22
  801bb0:	e8 e0 fb ff ff       	call   801795 <syscall>
  801bb5:	83 c4 18             	add    $0x18,%esp
	return ;
  801bb8:	90                   	nop
}
  801bb9:	c9                   	leave  
  801bba:	c3                   	ret    

00801bbb <inctst>:

void inctst()
{
  801bbb:	55                   	push   %ebp
  801bbc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801bbe:	6a 00                	push   $0x0
  801bc0:	6a 00                	push   $0x0
  801bc2:	6a 00                	push   $0x0
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 00                	push   $0x0
  801bc8:	6a 23                	push   $0x23
  801bca:	e8 c6 fb ff ff       	call   801795 <syscall>
  801bcf:	83 c4 18             	add    $0x18,%esp
	return ;
  801bd2:	90                   	nop
}
  801bd3:	c9                   	leave  
  801bd4:	c3                   	ret    

00801bd5 <gettst>:
uint32 gettst()
{
  801bd5:	55                   	push   %ebp
  801bd6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 00                	push   $0x0
  801be0:	6a 00                	push   $0x0
  801be2:	6a 24                	push   $0x24
  801be4:	e8 ac fb ff ff       	call   801795 <syscall>
  801be9:	83 c4 18             	add    $0x18,%esp
}
  801bec:	c9                   	leave  
  801bed:	c3                   	ret    

00801bee <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801bee:	55                   	push   %ebp
  801bef:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bf1:	6a 00                	push   $0x0
  801bf3:	6a 00                	push   $0x0
  801bf5:	6a 00                	push   $0x0
  801bf7:	6a 00                	push   $0x0
  801bf9:	6a 00                	push   $0x0
  801bfb:	6a 25                	push   $0x25
  801bfd:	e8 93 fb ff ff       	call   801795 <syscall>
  801c02:	83 c4 18             	add    $0x18,%esp
  801c05:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801c0a:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801c0f:	c9                   	leave  
  801c10:	c3                   	ret    

00801c11 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c11:	55                   	push   %ebp
  801c12:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801c14:	8b 45 08             	mov    0x8(%ebp),%eax
  801c17:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	6a 00                	push   $0x0
  801c24:	ff 75 08             	pushl  0x8(%ebp)
  801c27:	6a 26                	push   $0x26
  801c29:	e8 67 fb ff ff       	call   801795 <syscall>
  801c2e:	83 c4 18             	add    $0x18,%esp
	return ;
  801c31:	90                   	nop
}
  801c32:	c9                   	leave  
  801c33:	c3                   	ret    

00801c34 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801c34:	55                   	push   %ebp
  801c35:	89 e5                	mov    %esp,%ebp
  801c37:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801c38:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c3b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c3e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c41:	8b 45 08             	mov    0x8(%ebp),%eax
  801c44:	6a 00                	push   $0x0
  801c46:	53                   	push   %ebx
  801c47:	51                   	push   %ecx
  801c48:	52                   	push   %edx
  801c49:	50                   	push   %eax
  801c4a:	6a 27                	push   $0x27
  801c4c:	e8 44 fb ff ff       	call   801795 <syscall>
  801c51:	83 c4 18             	add    $0x18,%esp
}
  801c54:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c57:	c9                   	leave  
  801c58:	c3                   	ret    

00801c59 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801c59:	55                   	push   %ebp
  801c5a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801c5c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c62:	6a 00                	push   $0x0
  801c64:	6a 00                	push   $0x0
  801c66:	6a 00                	push   $0x0
  801c68:	52                   	push   %edx
  801c69:	50                   	push   %eax
  801c6a:	6a 28                	push   $0x28
  801c6c:	e8 24 fb ff ff       	call   801795 <syscall>
  801c71:	83 c4 18             	add    $0x18,%esp
}
  801c74:	c9                   	leave  
  801c75:	c3                   	ret    

00801c76 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801c76:	55                   	push   %ebp
  801c77:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801c79:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c7c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c82:	6a 00                	push   $0x0
  801c84:	51                   	push   %ecx
  801c85:	ff 75 10             	pushl  0x10(%ebp)
  801c88:	52                   	push   %edx
  801c89:	50                   	push   %eax
  801c8a:	6a 29                	push   $0x29
  801c8c:	e8 04 fb ff ff       	call   801795 <syscall>
  801c91:	83 c4 18             	add    $0x18,%esp
}
  801c94:	c9                   	leave  
  801c95:	c3                   	ret    

00801c96 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801c96:	55                   	push   %ebp
  801c97:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801c99:	6a 00                	push   $0x0
  801c9b:	6a 00                	push   $0x0
  801c9d:	ff 75 10             	pushl  0x10(%ebp)
  801ca0:	ff 75 0c             	pushl  0xc(%ebp)
  801ca3:	ff 75 08             	pushl  0x8(%ebp)
  801ca6:	6a 12                	push   $0x12
  801ca8:	e8 e8 fa ff ff       	call   801795 <syscall>
  801cad:	83 c4 18             	add    $0x18,%esp
	return ;
  801cb0:	90                   	nop
}
  801cb1:	c9                   	leave  
  801cb2:	c3                   	ret    

00801cb3 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801cb3:	55                   	push   %ebp
  801cb4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801cb6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbc:	6a 00                	push   $0x0
  801cbe:	6a 00                	push   $0x0
  801cc0:	6a 00                	push   $0x0
  801cc2:	52                   	push   %edx
  801cc3:	50                   	push   %eax
  801cc4:	6a 2a                	push   $0x2a
  801cc6:	e8 ca fa ff ff       	call   801795 <syscall>
  801ccb:	83 c4 18             	add    $0x18,%esp
	return;
  801cce:	90                   	nop
}
  801ccf:	c9                   	leave  
  801cd0:	c3                   	ret    

00801cd1 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801cd1:	55                   	push   %ebp
  801cd2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 00                	push   $0x0
  801cda:	6a 00                	push   $0x0
  801cdc:	6a 00                	push   $0x0
  801cde:	6a 2b                	push   $0x2b
  801ce0:	e8 b0 fa ff ff       	call   801795 <syscall>
  801ce5:	83 c4 18             	add    $0x18,%esp
}
  801ce8:	c9                   	leave  
  801ce9:	c3                   	ret    

00801cea <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801cea:	55                   	push   %ebp
  801ceb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801ced:	6a 00                	push   $0x0
  801cef:	6a 00                	push   $0x0
  801cf1:	6a 00                	push   $0x0
  801cf3:	ff 75 0c             	pushl  0xc(%ebp)
  801cf6:	ff 75 08             	pushl  0x8(%ebp)
  801cf9:	6a 2d                	push   $0x2d
  801cfb:	e8 95 fa ff ff       	call   801795 <syscall>
  801d00:	83 c4 18             	add    $0x18,%esp
	return;
  801d03:	90                   	nop
}
  801d04:	c9                   	leave  
  801d05:	c3                   	ret    

00801d06 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801d06:	55                   	push   %ebp
  801d07:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801d09:	6a 00                	push   $0x0
  801d0b:	6a 00                	push   $0x0
  801d0d:	6a 00                	push   $0x0
  801d0f:	ff 75 0c             	pushl  0xc(%ebp)
  801d12:	ff 75 08             	pushl  0x8(%ebp)
  801d15:	6a 2c                	push   $0x2c
  801d17:	e8 79 fa ff ff       	call   801795 <syscall>
  801d1c:	83 c4 18             	add    $0x18,%esp
	return ;
  801d1f:	90                   	nop
}
  801d20:	c9                   	leave  
  801d21:	c3                   	ret    

00801d22 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801d22:	55                   	push   %ebp
  801d23:	89 e5                	mov    %esp,%ebp
  801d25:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801d28:	83 ec 04             	sub    $0x4,%esp
  801d2b:	68 34 2d 80 00       	push   $0x802d34
  801d30:	68 25 01 00 00       	push   $0x125
  801d35:	68 67 2d 80 00       	push   $0x802d67
  801d3a:	e8 ec e6 ff ff       	call   80042b <_panic>

00801d3f <to_page_va>:
//==================================================================================//
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  801d3f:	55                   	push   %ebp
  801d40:	89 e5                	mov    %esp,%ebp
  801d42:	83 ec 10             	sub    $0x10,%esp
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  801d45:	8b 45 08             	mov    0x8(%ebp),%eax
  801d48:	ba 60 30 80 00       	mov    $0x803060,%edx
  801d4d:	29 d0                	sub    %edx,%eax
  801d4f:	c1 f8 02             	sar    $0x2,%eax
  801d52:	89 c2                	mov    %eax,%edx
  801d54:	89 d0                	mov    %edx,%eax
  801d56:	c1 e0 02             	shl    $0x2,%eax
  801d59:	01 d0                	add    %edx,%eax
  801d5b:	c1 e0 02             	shl    $0x2,%eax
  801d5e:	01 d0                	add    %edx,%eax
  801d60:	c1 e0 02             	shl    $0x2,%eax
  801d63:	01 d0                	add    %edx,%eax
  801d65:	89 c1                	mov    %eax,%ecx
  801d67:	c1 e1 08             	shl    $0x8,%ecx
  801d6a:	01 c8                	add    %ecx,%eax
  801d6c:	89 c1                	mov    %eax,%ecx
  801d6e:	c1 e1 10             	shl    $0x10,%ecx
  801d71:	01 c8                	add    %ecx,%eax
  801d73:	01 c0                	add    %eax,%eax
  801d75:	01 d0                	add    %edx,%eax
  801d77:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  801d7a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d7d:	c1 e0 0c             	shl    $0xc,%eax
  801d80:	89 c2                	mov    %eax,%edx
  801d82:	a1 64 b0 81 00       	mov    0x81b064,%eax
  801d87:	01 d0                	add    %edx,%eax
}
  801d89:	c9                   	leave  
  801d8a:	c3                   	ret    

00801d8b <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  801d8b:	55                   	push   %ebp
  801d8c:	89 e5                	mov    %esp,%ebp
  801d8e:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  801d91:	8b 45 08             	mov    0x8(%ebp),%eax
  801d94:	05 00 00 00 02       	add    $0x2000000,%eax
  801d99:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801d9c:	73 16                	jae    801db4 <initialize_dynamic_allocator+0x29>
  801d9e:	68 78 2d 80 00       	push   $0x802d78
  801da3:	68 9e 2d 80 00       	push   $0x802d9e
  801da8:	6a 26                	push   $0x26
  801daa:	68 b3 2d 80 00       	push   $0x802db3
  801daf:	e8 77 e6 ff ff       	call   80042b <_panic>
		is_initialized = 1;
  801db4:	c7 05 24 30 80 00 01 	movl   $0x1,0x803024
  801dbb:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	//Comment the following line
	panic("initialize_dynamic_allocator() Not implemented yet");
  801dbe:	83 ec 04             	sub    $0x4,%esp
  801dc1:	68 cc 2d 80 00       	push   $0x802dcc
  801dc6:	6a 2e                	push   $0x2e
  801dc8:	68 b3 2d 80 00       	push   $0x802db3
  801dcd:	e8 59 e6 ff ff       	call   80042b <_panic>

00801dd2 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  801dd2:	55                   	push   %ebp
  801dd3:	89 e5                	mov    %esp,%ebp
  801dd5:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	//Comment the following line
	panic("get_block_size() Not implemented yet");
  801dd8:	83 ec 04             	sub    $0x4,%esp
  801ddb:	68 00 2e 80 00       	push   $0x802e00
  801de0:	6a 3a                	push   $0x3a
  801de2:	68 b3 2d 80 00       	push   $0x802db3
  801de7:	e8 3f e6 ff ff       	call   80042b <_panic>

00801dec <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  801dec:	55                   	push   %ebp
  801ded:	89 e5                	mov    %esp,%ebp
  801def:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  801df2:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801df9:	76 16                	jbe    801e11 <alloc_block+0x25>
  801dfb:	68 28 2e 80 00       	push   $0x802e28
  801e00:	68 9e 2d 80 00       	push   $0x802d9e
  801e05:	6a 46                	push   $0x46
  801e07:	68 b3 2d 80 00       	push   $0x802db3
  801e0c:	e8 1a e6 ff ff       	call   80042b <_panic>
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	panic("alloc_block() Not implemented yet");
  801e11:	83 ec 04             	sub    $0x4,%esp
  801e14:	68 4c 2e 80 00       	push   $0x802e4c
  801e19:	6a 4d                	push   $0x4d
  801e1b:	68 b3 2d 80 00       	push   $0x802db3
  801e20:	e8 06 e6 ff ff       	call   80042b <_panic>

00801e25 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  801e25:	55                   	push   %ebp
  801e26:	89 e5                	mov    %esp,%ebp
  801e28:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  801e2b:	8b 55 08             	mov    0x8(%ebp),%edx
  801e2e:	a1 64 b0 81 00       	mov    0x81b064,%eax
  801e33:	39 c2                	cmp    %eax,%edx
  801e35:	72 0c                	jb     801e43 <free_block+0x1e>
  801e37:	8b 55 08             	mov    0x8(%ebp),%edx
  801e3a:	a1 40 30 80 00       	mov    0x803040,%eax
  801e3f:	39 c2                	cmp    %eax,%edx
  801e41:	72 16                	jb     801e59 <free_block+0x34>
  801e43:	68 70 2e 80 00       	push   $0x802e70
  801e48:	68 9e 2d 80 00       	push   $0x802d9e
  801e4d:	6a 5b                	push   $0x5b
  801e4f:	68 b3 2d 80 00       	push   $0x802db3
  801e54:	e8 d2 e5 ff ff       	call   80042b <_panic>
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	panic("free_block() Not implemented yet");
  801e59:	83 ec 04             	sub    $0x4,%esp
  801e5c:	68 a8 2e 80 00       	push   $0x802ea8
  801e61:	6a 63                	push   $0x63
  801e63:	68 b3 2d 80 00       	push   $0x802db3
  801e68:	e8 be e5 ff ff       	call   80042b <_panic>

00801e6d <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  801e6d:	55                   	push   %ebp
  801e6e:	89 e5                	mov    %esp,%ebp
  801e70:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  801e73:	83 ec 04             	sub    $0x4,%esp
  801e76:	68 cc 2e 80 00       	push   $0x802ecc
  801e7b:	6a 72                	push   $0x72
  801e7d:	68 b3 2d 80 00       	push   $0x802db3
  801e82:	e8 a4 e5 ff ff       	call   80042b <_panic>
  801e87:	90                   	nop

00801e88 <__udivdi3>:
  801e88:	55                   	push   %ebp
  801e89:	57                   	push   %edi
  801e8a:	56                   	push   %esi
  801e8b:	53                   	push   %ebx
  801e8c:	83 ec 1c             	sub    $0x1c,%esp
  801e8f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801e93:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801e97:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801e9b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e9f:	89 ca                	mov    %ecx,%edx
  801ea1:	89 f8                	mov    %edi,%eax
  801ea3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801ea7:	85 f6                	test   %esi,%esi
  801ea9:	75 2d                	jne    801ed8 <__udivdi3+0x50>
  801eab:	39 cf                	cmp    %ecx,%edi
  801ead:	77 65                	ja     801f14 <__udivdi3+0x8c>
  801eaf:	89 fd                	mov    %edi,%ebp
  801eb1:	85 ff                	test   %edi,%edi
  801eb3:	75 0b                	jne    801ec0 <__udivdi3+0x38>
  801eb5:	b8 01 00 00 00       	mov    $0x1,%eax
  801eba:	31 d2                	xor    %edx,%edx
  801ebc:	f7 f7                	div    %edi
  801ebe:	89 c5                	mov    %eax,%ebp
  801ec0:	31 d2                	xor    %edx,%edx
  801ec2:	89 c8                	mov    %ecx,%eax
  801ec4:	f7 f5                	div    %ebp
  801ec6:	89 c1                	mov    %eax,%ecx
  801ec8:	89 d8                	mov    %ebx,%eax
  801eca:	f7 f5                	div    %ebp
  801ecc:	89 cf                	mov    %ecx,%edi
  801ece:	89 fa                	mov    %edi,%edx
  801ed0:	83 c4 1c             	add    $0x1c,%esp
  801ed3:	5b                   	pop    %ebx
  801ed4:	5e                   	pop    %esi
  801ed5:	5f                   	pop    %edi
  801ed6:	5d                   	pop    %ebp
  801ed7:	c3                   	ret    
  801ed8:	39 ce                	cmp    %ecx,%esi
  801eda:	77 28                	ja     801f04 <__udivdi3+0x7c>
  801edc:	0f bd fe             	bsr    %esi,%edi
  801edf:	83 f7 1f             	xor    $0x1f,%edi
  801ee2:	75 40                	jne    801f24 <__udivdi3+0x9c>
  801ee4:	39 ce                	cmp    %ecx,%esi
  801ee6:	72 0a                	jb     801ef2 <__udivdi3+0x6a>
  801ee8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801eec:	0f 87 9e 00 00 00    	ja     801f90 <__udivdi3+0x108>
  801ef2:	b8 01 00 00 00       	mov    $0x1,%eax
  801ef7:	89 fa                	mov    %edi,%edx
  801ef9:	83 c4 1c             	add    $0x1c,%esp
  801efc:	5b                   	pop    %ebx
  801efd:	5e                   	pop    %esi
  801efe:	5f                   	pop    %edi
  801eff:	5d                   	pop    %ebp
  801f00:	c3                   	ret    
  801f01:	8d 76 00             	lea    0x0(%esi),%esi
  801f04:	31 ff                	xor    %edi,%edi
  801f06:	31 c0                	xor    %eax,%eax
  801f08:	89 fa                	mov    %edi,%edx
  801f0a:	83 c4 1c             	add    $0x1c,%esp
  801f0d:	5b                   	pop    %ebx
  801f0e:	5e                   	pop    %esi
  801f0f:	5f                   	pop    %edi
  801f10:	5d                   	pop    %ebp
  801f11:	c3                   	ret    
  801f12:	66 90                	xchg   %ax,%ax
  801f14:	89 d8                	mov    %ebx,%eax
  801f16:	f7 f7                	div    %edi
  801f18:	31 ff                	xor    %edi,%edi
  801f1a:	89 fa                	mov    %edi,%edx
  801f1c:	83 c4 1c             	add    $0x1c,%esp
  801f1f:	5b                   	pop    %ebx
  801f20:	5e                   	pop    %esi
  801f21:	5f                   	pop    %edi
  801f22:	5d                   	pop    %ebp
  801f23:	c3                   	ret    
  801f24:	bd 20 00 00 00       	mov    $0x20,%ebp
  801f29:	89 eb                	mov    %ebp,%ebx
  801f2b:	29 fb                	sub    %edi,%ebx
  801f2d:	89 f9                	mov    %edi,%ecx
  801f2f:	d3 e6                	shl    %cl,%esi
  801f31:	89 c5                	mov    %eax,%ebp
  801f33:	88 d9                	mov    %bl,%cl
  801f35:	d3 ed                	shr    %cl,%ebp
  801f37:	89 e9                	mov    %ebp,%ecx
  801f39:	09 f1                	or     %esi,%ecx
  801f3b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801f3f:	89 f9                	mov    %edi,%ecx
  801f41:	d3 e0                	shl    %cl,%eax
  801f43:	89 c5                	mov    %eax,%ebp
  801f45:	89 d6                	mov    %edx,%esi
  801f47:	88 d9                	mov    %bl,%cl
  801f49:	d3 ee                	shr    %cl,%esi
  801f4b:	89 f9                	mov    %edi,%ecx
  801f4d:	d3 e2                	shl    %cl,%edx
  801f4f:	8b 44 24 08          	mov    0x8(%esp),%eax
  801f53:	88 d9                	mov    %bl,%cl
  801f55:	d3 e8                	shr    %cl,%eax
  801f57:	09 c2                	or     %eax,%edx
  801f59:	89 d0                	mov    %edx,%eax
  801f5b:	89 f2                	mov    %esi,%edx
  801f5d:	f7 74 24 0c          	divl   0xc(%esp)
  801f61:	89 d6                	mov    %edx,%esi
  801f63:	89 c3                	mov    %eax,%ebx
  801f65:	f7 e5                	mul    %ebp
  801f67:	39 d6                	cmp    %edx,%esi
  801f69:	72 19                	jb     801f84 <__udivdi3+0xfc>
  801f6b:	74 0b                	je     801f78 <__udivdi3+0xf0>
  801f6d:	89 d8                	mov    %ebx,%eax
  801f6f:	31 ff                	xor    %edi,%edi
  801f71:	e9 58 ff ff ff       	jmp    801ece <__udivdi3+0x46>
  801f76:	66 90                	xchg   %ax,%ax
  801f78:	8b 54 24 08          	mov    0x8(%esp),%edx
  801f7c:	89 f9                	mov    %edi,%ecx
  801f7e:	d3 e2                	shl    %cl,%edx
  801f80:	39 c2                	cmp    %eax,%edx
  801f82:	73 e9                	jae    801f6d <__udivdi3+0xe5>
  801f84:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801f87:	31 ff                	xor    %edi,%edi
  801f89:	e9 40 ff ff ff       	jmp    801ece <__udivdi3+0x46>
  801f8e:	66 90                	xchg   %ax,%ax
  801f90:	31 c0                	xor    %eax,%eax
  801f92:	e9 37 ff ff ff       	jmp    801ece <__udivdi3+0x46>
  801f97:	90                   	nop

00801f98 <__umoddi3>:
  801f98:	55                   	push   %ebp
  801f99:	57                   	push   %edi
  801f9a:	56                   	push   %esi
  801f9b:	53                   	push   %ebx
  801f9c:	83 ec 1c             	sub    $0x1c,%esp
  801f9f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801fa3:	8b 74 24 34          	mov    0x34(%esp),%esi
  801fa7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801fab:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801faf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801fb3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801fb7:	89 f3                	mov    %esi,%ebx
  801fb9:	89 fa                	mov    %edi,%edx
  801fbb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801fbf:	89 34 24             	mov    %esi,(%esp)
  801fc2:	85 c0                	test   %eax,%eax
  801fc4:	75 1a                	jne    801fe0 <__umoddi3+0x48>
  801fc6:	39 f7                	cmp    %esi,%edi
  801fc8:	0f 86 a2 00 00 00    	jbe    802070 <__umoddi3+0xd8>
  801fce:	89 c8                	mov    %ecx,%eax
  801fd0:	89 f2                	mov    %esi,%edx
  801fd2:	f7 f7                	div    %edi
  801fd4:	89 d0                	mov    %edx,%eax
  801fd6:	31 d2                	xor    %edx,%edx
  801fd8:	83 c4 1c             	add    $0x1c,%esp
  801fdb:	5b                   	pop    %ebx
  801fdc:	5e                   	pop    %esi
  801fdd:	5f                   	pop    %edi
  801fde:	5d                   	pop    %ebp
  801fdf:	c3                   	ret    
  801fe0:	39 f0                	cmp    %esi,%eax
  801fe2:	0f 87 ac 00 00 00    	ja     802094 <__umoddi3+0xfc>
  801fe8:	0f bd e8             	bsr    %eax,%ebp
  801feb:	83 f5 1f             	xor    $0x1f,%ebp
  801fee:	0f 84 ac 00 00 00    	je     8020a0 <__umoddi3+0x108>
  801ff4:	bf 20 00 00 00       	mov    $0x20,%edi
  801ff9:	29 ef                	sub    %ebp,%edi
  801ffb:	89 fe                	mov    %edi,%esi
  801ffd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802001:	89 e9                	mov    %ebp,%ecx
  802003:	d3 e0                	shl    %cl,%eax
  802005:	89 d7                	mov    %edx,%edi
  802007:	89 f1                	mov    %esi,%ecx
  802009:	d3 ef                	shr    %cl,%edi
  80200b:	09 c7                	or     %eax,%edi
  80200d:	89 e9                	mov    %ebp,%ecx
  80200f:	d3 e2                	shl    %cl,%edx
  802011:	89 14 24             	mov    %edx,(%esp)
  802014:	89 d8                	mov    %ebx,%eax
  802016:	d3 e0                	shl    %cl,%eax
  802018:	89 c2                	mov    %eax,%edx
  80201a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80201e:	d3 e0                	shl    %cl,%eax
  802020:	89 44 24 04          	mov    %eax,0x4(%esp)
  802024:	8b 44 24 08          	mov    0x8(%esp),%eax
  802028:	89 f1                	mov    %esi,%ecx
  80202a:	d3 e8                	shr    %cl,%eax
  80202c:	09 d0                	or     %edx,%eax
  80202e:	d3 eb                	shr    %cl,%ebx
  802030:	89 da                	mov    %ebx,%edx
  802032:	f7 f7                	div    %edi
  802034:	89 d3                	mov    %edx,%ebx
  802036:	f7 24 24             	mull   (%esp)
  802039:	89 c6                	mov    %eax,%esi
  80203b:	89 d1                	mov    %edx,%ecx
  80203d:	39 d3                	cmp    %edx,%ebx
  80203f:	0f 82 87 00 00 00    	jb     8020cc <__umoddi3+0x134>
  802045:	0f 84 91 00 00 00    	je     8020dc <__umoddi3+0x144>
  80204b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80204f:	29 f2                	sub    %esi,%edx
  802051:	19 cb                	sbb    %ecx,%ebx
  802053:	89 d8                	mov    %ebx,%eax
  802055:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802059:	d3 e0                	shl    %cl,%eax
  80205b:	89 e9                	mov    %ebp,%ecx
  80205d:	d3 ea                	shr    %cl,%edx
  80205f:	09 d0                	or     %edx,%eax
  802061:	89 e9                	mov    %ebp,%ecx
  802063:	d3 eb                	shr    %cl,%ebx
  802065:	89 da                	mov    %ebx,%edx
  802067:	83 c4 1c             	add    $0x1c,%esp
  80206a:	5b                   	pop    %ebx
  80206b:	5e                   	pop    %esi
  80206c:	5f                   	pop    %edi
  80206d:	5d                   	pop    %ebp
  80206e:	c3                   	ret    
  80206f:	90                   	nop
  802070:	89 fd                	mov    %edi,%ebp
  802072:	85 ff                	test   %edi,%edi
  802074:	75 0b                	jne    802081 <__umoddi3+0xe9>
  802076:	b8 01 00 00 00       	mov    $0x1,%eax
  80207b:	31 d2                	xor    %edx,%edx
  80207d:	f7 f7                	div    %edi
  80207f:	89 c5                	mov    %eax,%ebp
  802081:	89 f0                	mov    %esi,%eax
  802083:	31 d2                	xor    %edx,%edx
  802085:	f7 f5                	div    %ebp
  802087:	89 c8                	mov    %ecx,%eax
  802089:	f7 f5                	div    %ebp
  80208b:	89 d0                	mov    %edx,%eax
  80208d:	e9 44 ff ff ff       	jmp    801fd6 <__umoddi3+0x3e>
  802092:	66 90                	xchg   %ax,%ax
  802094:	89 c8                	mov    %ecx,%eax
  802096:	89 f2                	mov    %esi,%edx
  802098:	83 c4 1c             	add    $0x1c,%esp
  80209b:	5b                   	pop    %ebx
  80209c:	5e                   	pop    %esi
  80209d:	5f                   	pop    %edi
  80209e:	5d                   	pop    %ebp
  80209f:	c3                   	ret    
  8020a0:	3b 04 24             	cmp    (%esp),%eax
  8020a3:	72 06                	jb     8020ab <__umoddi3+0x113>
  8020a5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8020a9:	77 0f                	ja     8020ba <__umoddi3+0x122>
  8020ab:	89 f2                	mov    %esi,%edx
  8020ad:	29 f9                	sub    %edi,%ecx
  8020af:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8020b3:	89 14 24             	mov    %edx,(%esp)
  8020b6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8020ba:	8b 44 24 04          	mov    0x4(%esp),%eax
  8020be:	8b 14 24             	mov    (%esp),%edx
  8020c1:	83 c4 1c             	add    $0x1c,%esp
  8020c4:	5b                   	pop    %ebx
  8020c5:	5e                   	pop    %esi
  8020c6:	5f                   	pop    %edi
  8020c7:	5d                   	pop    %ebp
  8020c8:	c3                   	ret    
  8020c9:	8d 76 00             	lea    0x0(%esi),%esi
  8020cc:	2b 04 24             	sub    (%esp),%eax
  8020cf:	19 fa                	sbb    %edi,%edx
  8020d1:	89 d1                	mov    %edx,%ecx
  8020d3:	89 c6                	mov    %eax,%esi
  8020d5:	e9 71 ff ff ff       	jmp    80204b <__umoddi3+0xb3>
  8020da:	66 90                	xchg   %ax,%ax
  8020dc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8020e0:	72 ea                	jb     8020cc <__umoddi3+0x134>
  8020e2:	89 d9                	mov    %ebx,%ecx
  8020e4:	e9 62 ff ff ff       	jmp    80204b <__umoddi3+0xb3>

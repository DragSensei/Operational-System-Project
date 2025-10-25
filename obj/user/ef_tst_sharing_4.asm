
obj/user/ef_tst_sharing_4:     file format elf32-i386


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
  800031:	e8 53 06 00 00       	call   800689 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the free of shared variables (create_shared_memory)
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 64             	sub    $0x64,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
#if USE_KHEAP
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  80003f:	a1 20 40 80 00       	mov    0x804020,%eax
  800044:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
  80004a:	a1 20 40 80 00       	mov    0x804020,%eax
  80004f:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800055:	39 c2                	cmp    %eax,%edx
  800057:	72 14                	jb     80006d <_main+0x35>
			panic("Please increase the WS size");
  800059:	83 ec 04             	sub    $0x4,%esp
  80005c:	68 00 25 80 00       	push   $0x802500
  800061:	6a 0b                	push   $0xb
  800063:	68 1c 25 80 00       	push   $0x80251c
  800068:	e8 cc 07 00 00       	call   800839 <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  80006d:	c7 45 f4 00 10 00 82 	movl   $0x82001000,-0xc(%ebp)
	uint32 *x, *y, *z ;
	int freeFrames, diff, expected;

	cprintf("************************************************\n");
  800074:	83 ec 0c             	sub    $0xc,%esp
  800077:	68 34 25 80 00       	push   $0x802534
  80007c:	e8 86 0a 00 00       	call   800b07 <cprintf>
  800081:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  800084:	83 ec 0c             	sub    $0xc,%esp
  800087:	68 68 25 80 00       	push   $0x802568
  80008c:	e8 76 0a 00 00       	call   800b07 <cprintf>
  800091:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  800094:	83 ec 0c             	sub    $0xc,%esp
  800097:	68 c4 25 80 00       	push   $0x8025c4
  80009c:	e8 66 0a 00 00       	call   800b07 <cprintf>
  8000a1:	83 c4 10             	add    $0x10,%esp

	int Mega = 1024*1024;
  8000a4:	c7 45 f0 00 00 10 00 	movl   $0x100000,-0x10(%ebp)
	int kilo = 1024;
  8000ab:	c7 45 ec 00 04 00 00 	movl   $0x400,-0x14(%ebp)
	int envID = sys_getenvid();
  8000b2:	e8 bb 1d 00 00       	call   801e72 <sys_getenvid>
  8000b7:	89 45 e8             	mov    %eax,-0x18(%ebp)
	cprintf("STEP A: checking free of a shared object ... [25%]\n");
  8000ba:	83 ec 0c             	sub    $0xc,%esp
  8000bd:	68 f8 25 80 00       	push   $0x8025f8
  8000c2:	e8 40 0a 00 00       	call   800b07 <cprintf>
  8000c7:	83 c4 10             	add    $0x10,%esp
	{
		freeFrames = sys_calculate_free_frames() ;
  8000ca:	e8 f3 1b 00 00       	call   801cc2 <sys_calculate_free_frames>
  8000cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8000d2:	83 ec 04             	sub    $0x4,%esp
  8000d5:	6a 01                	push   $0x1
  8000d7:	68 00 10 00 00       	push   $0x1000
  8000dc:	68 2c 26 80 00       	push   $0x80262c
  8000e1:	e8 2b 1a 00 00       	call   801b11 <smalloc>
  8000e6:	83 c4 10             	add    $0x10,%esp
  8000e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (x != (uint32*)pagealloc_start)
  8000ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000ef:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  8000f2:	74 14                	je     800108 <_main+0xd0>
		{panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  8000f4:	83 ec 04             	sub    $0x4,%esp
  8000f7:	68 30 26 80 00       	push   $0x802630
  8000fc:	6a 22                	push   $0x22
  8000fe:	68 1c 25 80 00       	push   $0x80251c
  800103:	e8 31 07 00 00       	call   800839 <_panic>
		expected = 1+1 ; /*1page +1table*/
  800108:	c7 45 dc 02 00 00 00 	movl   $0x2,-0x24(%ebp)

		/*extra 1 page & 1 table for kernel sbrk (at max) due to sharedObject & frameStorage*/
		/*extra 1 page & 1 table for user sbrk (at max) if creating special DS to manage USER PAGE ALLOC */
		int upperLimit = expected +1+1 +1+1 ;
  80010f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800112:	83 c0 04             	add    $0x4,%eax
  800115:	89 45 d8             	mov    %eax,-0x28(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800118:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80011b:	e8 a2 1b 00 00       	call   801cc2 <sys_calculate_free_frames>
  800120:	29 c3                	sub    %eax,%ebx
  800122:	89 d8                	mov    %ebx,%eax
  800124:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if (diff < expected || diff > upperLimit)
  800127:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80012a:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80012d:	7c 08                	jl     800137 <_main+0xff>
  80012f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800132:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800135:	7e 24                	jle    80015b <_main+0x123>
			{panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  800137:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80013a:	e8 83 1b 00 00       	call   801cc2 <sys_calculate_free_frames>
  80013f:	29 c3                	sub    %eax,%ebx
  800141:	89 d8                	mov    %ebx,%eax
  800143:	83 ec 0c             	sub    $0xc,%esp
  800146:	ff 75 dc             	pushl  -0x24(%ebp)
  800149:	50                   	push   %eax
  80014a:	68 9c 26 80 00       	push   $0x80269c
  80014f:	6a 2a                	push   $0x2a
  800151:	68 1c 25 80 00       	push   $0x80251c
  800156:	e8 de 06 00 00       	call   800839 <_panic>

		sfree(x);
  80015b:	83 ec 0c             	sub    $0xc,%esp
  80015e:	ff 75 e0             	pushl  -0x20(%ebp)
  800161:	e8 20 1a 00 00       	call   801b86 <sfree>
  800166:	83 c4 10             	add    $0x10,%esp

		int diff2 = (freeFrames - sys_calculate_free_frames());
  800169:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80016c:	e8 51 1b 00 00       	call   801cc2 <sys_calculate_free_frames>
  800171:	29 c3                	sub    %eax,%ebx
  800173:	89 d8                	mov    %ebx,%eax
  800175:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff2 !=  (diff - expected))
  800178:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80017b:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80017e:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  800181:	74 24                	je     8001a7 <_main+0x16f>
		{panic("Wrong free: revise your freeSharedObject logic. Expected = %d, Actual = %d", expected, (freeFrames - sys_calculate_free_frames()));}
  800183:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800186:	e8 37 1b 00 00       	call   801cc2 <sys_calculate_free_frames>
  80018b:	29 c3                	sub    %eax,%ebx
  80018d:	89 d8                	mov    %ebx,%eax
  80018f:	83 ec 0c             	sub    $0xc,%esp
  800192:	50                   	push   %eax
  800193:	ff 75 dc             	pushl  -0x24(%ebp)
  800196:	68 34 27 80 00       	push   $0x802734
  80019b:	6a 30                	push   $0x30
  80019d:	68 1c 25 80 00       	push   $0x80251c
  8001a2:	e8 92 06 00 00       	call   800839 <_panic>
	}
	cprintf("Step A completed!!\n\n\n");
  8001a7:	83 ec 0c             	sub    $0xc,%esp
  8001aa:	68 7f 27 80 00       	push   $0x80277f
  8001af:	e8 53 09 00 00       	call   800b07 <cprintf>
  8001b4:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP B: checking free of 2 shared objects ... [25%]\n");
  8001b7:	83 ec 0c             	sub    $0xc,%esp
  8001ba:	68 98 27 80 00       	push   $0x802798
  8001bf:	e8 43 09 00 00       	call   800b07 <cprintf>
  8001c4:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x, *z ;
		freeFrames = sys_calculate_free_frames() ;
  8001c7:	e8 f6 1a 00 00       	call   801cc2 <sys_calculate_free_frames>
  8001cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		z = smalloc("z", PAGE_SIZE, 1);
  8001cf:	83 ec 04             	sub    $0x4,%esp
  8001d2:	6a 01                	push   $0x1
  8001d4:	68 00 10 00 00       	push   $0x1000
  8001d9:	68 cd 27 80 00       	push   $0x8027cd
  8001de:	e8 2e 19 00 00       	call   801b11 <smalloc>
  8001e3:	83 c4 10             	add    $0x10,%esp
  8001e6:	89 45 cc             	mov    %eax,-0x34(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8001e9:	83 ec 04             	sub    $0x4,%esp
  8001ec:	6a 01                	push   $0x1
  8001ee:	68 00 10 00 00       	push   $0x1000
  8001f3:	68 2c 26 80 00       	push   $0x80262c
  8001f8:	e8 14 19 00 00       	call   801b11 <smalloc>
  8001fd:	83 c4 10             	add    $0x10,%esp
  800200:	89 45 c8             	mov    %eax,-0x38(%ebp)

		if(x == NULL)
  800203:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800207:	75 14                	jne    80021d <_main+0x1e5>
		{panic("Wrong free: make sure that you free the shared object by calling free_share_object()");}
  800209:	83 ec 04             	sub    $0x4,%esp
  80020c:	68 d0 27 80 00       	push   $0x8027d0
  800211:	6a 3c                	push   $0x3c
  800213:	68 1c 25 80 00       	push   $0x80251c
  800218:	e8 1c 06 00 00       	call   800839 <_panic>

		expected = 2+1 ; /*2pages +1table*/
  80021d:	c7 45 dc 03 00 00 00 	movl   $0x3,-0x24(%ebp)
		/*extra 1 page for kernel sbrk (at max) due to sharedObject & frameStorage of the 2nd object "x"*/
		/*if creating special DS to manage USER PAGE ALLOC, the prev. created page from STEP A is sufficient */
		int upperLimit = expected +1 ;
  800224:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800227:	40                   	inc    %eax
  800228:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80022b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80022e:	e8 8f 1a 00 00       	call   801cc2 <sys_calculate_free_frames>
  800233:	29 c3                	sub    %eax,%ebx
  800235:	89 d8                	mov    %ebx,%eax
  800237:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if (diff < expected || diff > upperLimit)
  80023a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80023d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800240:	7c 08                	jl     80024a <_main+0x212>
  800242:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800245:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  800248:	7e 14                	jle    80025e <_main+0x226>
			{panic("Wrong previous free: make sure that you correctly free shared object before (Step A)");}
  80024a:	83 ec 04             	sub    $0x4,%esp
  80024d:	68 28 28 80 00       	push   $0x802828
  800252:	6a 44                	push   $0x44
  800254:	68 1c 25 80 00       	push   $0x80251c
  800259:	e8 db 05 00 00       	call   800839 <_panic>

		sfree(z);
  80025e:	83 ec 0c             	sub    $0xc,%esp
  800261:	ff 75 cc             	pushl  -0x34(%ebp)
  800264:	e8 1d 19 00 00       	call   801b86 <sfree>
  800269:	83 c4 10             	add    $0x10,%esp

		int diff2 = (freeFrames - sys_calculate_free_frames());
  80026c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80026f:	e8 4e 1a 00 00       	call   801cc2 <sys_calculate_free_frames>
  800274:	29 c3                	sub    %eax,%ebx
  800276:	89 d8                	mov    %ebx,%eax
  800278:	89 45 c0             	mov    %eax,-0x40(%ebp)
		if (diff2 != (diff - 1 /*1 page*/))
  80027b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80027e:	48                   	dec    %eax
  80027f:	3b 45 c0             	cmp    -0x40(%ebp),%eax
  800282:	74 24                	je     8002a8 <_main+0x270>
		{panic("Wrong free: revise your freeSharedObject logic. Expected = %d, Actual = %d", expected, (freeFrames - sys_calculate_free_frames()));}
  800284:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800287:	e8 36 1a 00 00       	call   801cc2 <sys_calculate_free_frames>
  80028c:	29 c3                	sub    %eax,%ebx
  80028e:	89 d8                	mov    %ebx,%eax
  800290:	83 ec 0c             	sub    $0xc,%esp
  800293:	50                   	push   %eax
  800294:	ff 75 dc             	pushl  -0x24(%ebp)
  800297:	68 34 27 80 00       	push   $0x802734
  80029c:	6a 4a                	push   $0x4a
  80029e:	68 1c 25 80 00       	push   $0x80251c
  8002a3:	e8 91 05 00 00       	call   800839 <_panic>

		sfree(x);
  8002a8:	83 ec 0c             	sub    $0xc,%esp
  8002ab:	ff 75 c8             	pushl  -0x38(%ebp)
  8002ae:	e8 d3 18 00 00       	call   801b86 <sfree>
  8002b3:	83 c4 10             	add    $0x10,%esp

		expected = 0;
  8002b6:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
		int diff3 = (freeFrames - sys_calculate_free_frames());
  8002bd:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8002c0:	e8 fd 19 00 00       	call   801cc2 <sys_calculate_free_frames>
  8002c5:	29 c3                	sub    %eax,%ebx
  8002c7:	89 d8                	mov    %ebx,%eax
  8002c9:	89 45 bc             	mov    %eax,-0x44(%ebp)
		if (diff3 != (diff2 - (1+1) /*1 page + 1 table*/))
  8002cc:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8002cf:	83 e8 02             	sub    $0x2,%eax
  8002d2:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  8002d5:	74 24                	je     8002fb <_main+0x2c3>
		{panic("Wrong free: revise your freeSharedObject logic. Expected = %d, Actual = %d", expected, (freeFrames - sys_calculate_free_frames()));}
  8002d7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8002da:	e8 e3 19 00 00       	call   801cc2 <sys_calculate_free_frames>
  8002df:	29 c3                	sub    %eax,%ebx
  8002e1:	89 d8                	mov    %ebx,%eax
  8002e3:	83 ec 0c             	sub    $0xc,%esp
  8002e6:	50                   	push   %eax
  8002e7:	ff 75 dc             	pushl  -0x24(%ebp)
  8002ea:	68 34 27 80 00       	push   $0x802734
  8002ef:	6a 51                	push   $0x51
  8002f1:	68 1c 25 80 00       	push   $0x80251c
  8002f6:	e8 3e 05 00 00       	call   800839 <_panic>

	}
	cprintf("Step B completed!!\n\n\n");
  8002fb:	83 ec 0c             	sub    $0xc,%esp
  8002fe:	68 7d 28 80 00       	push   $0x80287d
  800303:	e8 ff 07 00 00       	call   800b07 <cprintf>
  800308:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP C: checking range of loop during free... [50%]\n");
  80030b:	83 ec 0c             	sub    $0xc,%esp
  80030e:	68 94 28 80 00       	push   $0x802894
  800313:	e8 ef 07 00 00       	call   800b07 <cprintf>
  800318:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *w, *u;
		int freeFrames = sys_calculate_free_frames() ;
  80031b:	e8 a2 19 00 00       	call   801cc2 <sys_calculate_free_frames>
  800320:	89 45 b8             	mov    %eax,-0x48(%ebp)
		w = smalloc("w", 3 * PAGE_SIZE+1, 1);
  800323:	83 ec 04             	sub    $0x4,%esp
  800326:	6a 01                	push   $0x1
  800328:	68 01 30 00 00       	push   $0x3001
  80032d:	68 c9 28 80 00       	push   $0x8028c9
  800332:	e8 da 17 00 00       	call   801b11 <smalloc>
  800337:	83 c4 10             	add    $0x10,%esp
  80033a:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		u = smalloc("u", PAGE_SIZE, 1);
  80033d:	83 ec 04             	sub    $0x4,%esp
  800340:	6a 01                	push   $0x1
  800342:	68 00 10 00 00       	push   $0x1000
  800347:	68 cb 28 80 00       	push   $0x8028cb
  80034c:	e8 c0 17 00 00       	call   801b11 <smalloc>
  800351:	83 c4 10             	add    $0x10,%esp
  800354:	89 45 b0             	mov    %eax,-0x50(%ebp)
		expected = 5+1 ; /*5pages +1table*/
  800357:	c7 45 dc 06 00 00 00 	movl   $0x6,-0x24(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80035e:	8b 5d b8             	mov    -0x48(%ebp),%ebx
  800361:	e8 5c 19 00 00       	call   801cc2 <sys_calculate_free_frames>
  800366:	29 c3                	sub    %eax,%ebx
  800368:	89 d8                	mov    %ebx,%eax
  80036a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if (diff != expected)
  80036d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800370:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800373:	74 24                	je     800399 <_main+0x361>
			{panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  800375:	8b 5d b8             	mov    -0x48(%ebp),%ebx
  800378:	e8 45 19 00 00       	call   801cc2 <sys_calculate_free_frames>
  80037d:	29 c3                	sub    %eax,%ebx
  80037f:	89 d8                	mov    %ebx,%eax
  800381:	83 ec 0c             	sub    $0xc,%esp
  800384:	ff 75 dc             	pushl  -0x24(%ebp)
  800387:	50                   	push   %eax
  800388:	68 9c 26 80 00       	push   $0x80269c
  80038d:	6a 5f                	push   $0x5f
  80038f:	68 1c 25 80 00       	push   $0x80251c
  800394:	e8 a0 04 00 00       	call   800839 <_panic>

		sfree(w);
  800399:	83 ec 0c             	sub    $0xc,%esp
  80039c:	ff 75 b4             	pushl  -0x4c(%ebp)
  80039f:	e8 e2 17 00 00       	call   801b86 <sfree>
  8003a4:	83 c4 10             	add    $0x10,%esp

		expected = 1+1 ; /*1page +1table*/
  8003a7:	c7 45 dc 02 00 00 00 	movl   $0x2,-0x24(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8003ae:	8b 5d b8             	mov    -0x48(%ebp),%ebx
  8003b1:	e8 0c 19 00 00       	call   801cc2 <sys_calculate_free_frames>
  8003b6:	29 c3                	sub    %eax,%ebx
  8003b8:	89 d8                	mov    %ebx,%eax
  8003ba:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if (diff != expected) {panic("Wrong free: revise your freeSharedObject logic. Expected = %d, Actual = %d", expected, (freeFrames - sys_calculate_free_frames()));}
  8003bd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003c0:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8003c3:	74 24                	je     8003e9 <_main+0x3b1>
  8003c5:	8b 5d b8             	mov    -0x48(%ebp),%ebx
  8003c8:	e8 f5 18 00 00       	call   801cc2 <sys_calculate_free_frames>
  8003cd:	29 c3                	sub    %eax,%ebx
  8003cf:	89 d8                	mov    %ebx,%eax
  8003d1:	83 ec 0c             	sub    $0xc,%esp
  8003d4:	50                   	push   %eax
  8003d5:	ff 75 dc             	pushl  -0x24(%ebp)
  8003d8:	68 34 27 80 00       	push   $0x802734
  8003dd:	6a 65                	push   $0x65
  8003df:	68 1c 25 80 00       	push   $0x80251c
  8003e4:	e8 50 04 00 00       	call   800839 <_panic>

		uint32 *o;

		o = smalloc("o", 2 * PAGE_SIZE-1,1);
  8003e9:	83 ec 04             	sub    $0x4,%esp
  8003ec:	6a 01                	push   $0x1
  8003ee:	68 ff 1f 00 00       	push   $0x1fff
  8003f3:	68 cd 28 80 00       	push   $0x8028cd
  8003f8:	e8 14 17 00 00       	call   801b11 <smalloc>
  8003fd:	83 c4 10             	add    $0x10,%esp
  800400:	89 45 ac             	mov    %eax,-0x54(%ebp)

		expected = 3+1 ; /*3pages +1table*/
  800403:	c7 45 dc 04 00 00 00 	movl   $0x4,-0x24(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80040a:	8b 5d b8             	mov    -0x48(%ebp),%ebx
  80040d:	e8 b0 18 00 00       	call   801cc2 <sys_calculate_free_frames>
  800412:	29 c3                	sub    %eax,%ebx
  800414:	89 d8                	mov    %ebx,%eax
  800416:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if (diff != expected /*Exact! since it's not expected that to invloke sbrk due to the prev. sfree*/)
  800419:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80041c:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80041f:	74 24                	je     800445 <_main+0x40d>
			{panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  800421:	8b 5d b8             	mov    -0x48(%ebp),%ebx
  800424:	e8 99 18 00 00       	call   801cc2 <sys_calculate_free_frames>
  800429:	29 c3                	sub    %eax,%ebx
  80042b:	89 d8                	mov    %ebx,%eax
  80042d:	83 ec 0c             	sub    $0xc,%esp
  800430:	ff 75 dc             	pushl  -0x24(%ebp)
  800433:	50                   	push   %eax
  800434:	68 9c 26 80 00       	push   $0x80269c
  800439:	6a 6e                	push   $0x6e
  80043b:	68 1c 25 80 00       	push   $0x80251c
  800440:	e8 f4 03 00 00       	call   800839 <_panic>

		sfree(o);
  800445:	83 ec 0c             	sub    $0xc,%esp
  800448:	ff 75 ac             	pushl  -0x54(%ebp)
  80044b:	e8 36 17 00 00       	call   801b86 <sfree>
  800450:	83 c4 10             	add    $0x10,%esp

		expected = 1+1 ; /*1page +1table*/
  800453:	c7 45 dc 02 00 00 00 	movl   $0x2,-0x24(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80045a:	8b 5d b8             	mov    -0x48(%ebp),%ebx
  80045d:	e8 60 18 00 00       	call   801cc2 <sys_calculate_free_frames>
  800462:	29 c3                	sub    %eax,%ebx
  800464:	89 d8                	mov    %ebx,%eax
  800466:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if (diff != expected) {panic("Wrong free: revise your freeSharedObject logic. Expected = %d, Actual = %d", expected, (freeFrames - sys_calculate_free_frames()));}
  800469:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80046c:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80046f:	74 24                	je     800495 <_main+0x45d>
  800471:	8b 5d b8             	mov    -0x48(%ebp),%ebx
  800474:	e8 49 18 00 00       	call   801cc2 <sys_calculate_free_frames>
  800479:	29 c3                	sub    %eax,%ebx
  80047b:	89 d8                	mov    %ebx,%eax
  80047d:	83 ec 0c             	sub    $0xc,%esp
  800480:	50                   	push   %eax
  800481:	ff 75 dc             	pushl  -0x24(%ebp)
  800484:	68 34 27 80 00       	push   $0x802734
  800489:	6a 74                	push   $0x74
  80048b:	68 1c 25 80 00       	push   $0x80251c
  800490:	e8 a4 03 00 00       	call   800839 <_panic>

		sfree(u);
  800495:	83 ec 0c             	sub    $0xc,%esp
  800498:	ff 75 b0             	pushl  -0x50(%ebp)
  80049b:	e8 e6 16 00 00       	call   801b86 <sfree>
  8004a0:	83 c4 10             	add    $0x10,%esp

		expected = 0;
  8004a3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8004aa:	8b 5d b8             	mov    -0x48(%ebp),%ebx
  8004ad:	e8 10 18 00 00       	call   801cc2 <sys_calculate_free_frames>
  8004b2:	29 c3                	sub    %eax,%ebx
  8004b4:	89 d8                	mov    %ebx,%eax
  8004b6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if (diff != expected) {panic("Wrong free: revise your freeSharedObject logic. Expected = %d, Actual = %d", expected, (freeFrames - sys_calculate_free_frames()));}
  8004b9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8004bc:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8004bf:	74 24                	je     8004e5 <_main+0x4ad>
  8004c1:	8b 5d b8             	mov    -0x48(%ebp),%ebx
  8004c4:	e8 f9 17 00 00       	call   801cc2 <sys_calculate_free_frames>
  8004c9:	29 c3                	sub    %eax,%ebx
  8004cb:	89 d8                	mov    %ebx,%eax
  8004cd:	83 ec 0c             	sub    $0xc,%esp
  8004d0:	50                   	push   %eax
  8004d1:	ff 75 dc             	pushl  -0x24(%ebp)
  8004d4:	68 34 27 80 00       	push   $0x802734
  8004d9:	6a 7a                	push   $0x7a
  8004db:	68 1c 25 80 00       	push   $0x80251c
  8004e0:	e8 54 03 00 00       	call   800839 <_panic>

		//Checking boundaries of page tables
		freeFrames = sys_calculate_free_frames() ;
  8004e5:	e8 d8 17 00 00       	call   801cc2 <sys_calculate_free_frames>
  8004ea:	89 45 b8             	mov    %eax,-0x48(%ebp)
		w = smalloc("w", 3 * Mega - 1*kilo, 1);
  8004ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004f0:	89 c2                	mov    %eax,%edx
  8004f2:	01 d2                	add    %edx,%edx
  8004f4:	01 d0                	add    %edx,%eax
  8004f6:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8004f9:	83 ec 04             	sub    $0x4,%esp
  8004fc:	6a 01                	push   $0x1
  8004fe:	50                   	push   %eax
  8004ff:	68 c9 28 80 00       	push   $0x8028c9
  800504:	e8 08 16 00 00       	call   801b11 <smalloc>
  800509:	83 c4 10             	add    $0x10,%esp
  80050c:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		u = smalloc("u", 7 * Mega - 1*kilo, 1);
  80050f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800512:	89 d0                	mov    %edx,%eax
  800514:	01 c0                	add    %eax,%eax
  800516:	01 d0                	add    %edx,%eax
  800518:	01 c0                	add    %eax,%eax
  80051a:	01 d0                	add    %edx,%eax
  80051c:	2b 45 ec             	sub    -0x14(%ebp),%eax
  80051f:	83 ec 04             	sub    $0x4,%esp
  800522:	6a 01                	push   $0x1
  800524:	50                   	push   %eax
  800525:	68 cb 28 80 00       	push   $0x8028cb
  80052a:	e8 e2 15 00 00       	call   801b11 <smalloc>
  80052f:	83 c4 10             	add    $0x10,%esp
  800532:	89 45 b0             	mov    %eax,-0x50(%ebp)
		o = smalloc("o", 2 * Mega + 1*kilo, 1);
  800535:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800538:	01 c0                	add    %eax,%eax
  80053a:	89 c2                	mov    %eax,%edx
  80053c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80053f:	01 d0                	add    %edx,%eax
  800541:	83 ec 04             	sub    $0x4,%esp
  800544:	6a 01                	push   $0x1
  800546:	50                   	push   %eax
  800547:	68 cd 28 80 00       	push   $0x8028cd
  80054c:	e8 c0 15 00 00       	call   801b11 <smalloc>
  800551:	83 c4 10             	add    $0x10,%esp
  800554:	89 45 ac             	mov    %eax,-0x54(%ebp)

		expected = 3073+4+4 ; /*3073pages +4tables +4pages for framesStorage by Kernel Page Allocator since it exceed 2KB size*/
  800557:	c7 45 dc 09 0c 00 00 	movl   $0xc09,-0x24(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80055e:	8b 5d b8             	mov    -0x48(%ebp),%ebx
  800561:	e8 5c 17 00 00       	call   801cc2 <sys_calculate_free_frames>
  800566:	29 c3                	sub    %eax,%ebx
  800568:	89 d8                	mov    %ebx,%eax
  80056a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/)
  80056d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800570:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800573:	7c 0b                	jl     800580 <_main+0x548>
  800575:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800578:	83 c0 02             	add    $0x2,%eax
  80057b:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80057e:	7d 27                	jge    8005a7 <_main+0x56f>
			{panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  800580:	8b 5d b8             	mov    -0x48(%ebp),%ebx
  800583:	e8 3a 17 00 00       	call   801cc2 <sys_calculate_free_frames>
  800588:	29 c3                	sub    %eax,%ebx
  80058a:	89 d8                	mov    %ebx,%eax
  80058c:	83 ec 0c             	sub    $0xc,%esp
  80058f:	ff 75 dc             	pushl  -0x24(%ebp)
  800592:	50                   	push   %eax
  800593:	68 9c 26 80 00       	push   $0x80269c
  800598:	68 85 00 00 00       	push   $0x85
  80059d:	68 1c 25 80 00       	push   $0x80251c
  8005a2:	e8 92 02 00 00       	call   800839 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8005a7:	e8 16 17 00 00       	call   801cc2 <sys_calculate_free_frames>
  8005ac:	89 45 b8             	mov    %eax,-0x48(%ebp)

		sfree(o);
  8005af:	83 ec 0c             	sub    $0xc,%esp
  8005b2:	ff 75 ac             	pushl  -0x54(%ebp)
  8005b5:	e8 cc 15 00 00       	call   801b86 <sfree>
  8005ba:	83 c4 10             	add    $0x10,%esp
//		if ((freeFrames - sys_calculate_free_frames()) !=  2560+3+5) {panic("Wrong free: check your logic");

		sfree(w);
  8005bd:	83 ec 0c             	sub    $0xc,%esp
  8005c0:	ff 75 b4             	pushl  -0x4c(%ebp)
  8005c3:	e8 be 15 00 00       	call   801b86 <sfree>
  8005c8:	83 c4 10             	add    $0x10,%esp
//		if ((freeFrames - sys_calculate_free_frames()) !=  1792+3+3) {panic("Wrong free: check your logic");

		sfree(u);
  8005cb:	83 ec 0c             	sub    $0xc,%esp
  8005ce:	ff 75 b0             	pushl  -0x50(%ebp)
  8005d1:	e8 b0 15 00 00       	call   801b86 <sfree>
  8005d6:	83 c4 10             	add    $0x10,%esp

		expected = 3073+4+4;
  8005d9:	c7 45 dc 09 0c 00 00 	movl   $0xc09,-0x24(%ebp)
		diff = (sys_calculate_free_frames() - freeFrames);
  8005e0:	e8 dd 16 00 00       	call   801cc2 <sys_calculate_free_frames>
  8005e5:	89 c2                	mov    %eax,%edx
  8005e7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8005ea:	29 c2                	sub    %eax,%edx
  8005ec:	89 d0                	mov    %edx,%eax
  8005ee:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if (diff != expected) {panic("Wrong free: revise your freeSharedObject logic. Expected = %d, Actual = %d", expected, (freeFrames - sys_calculate_free_frames()));}
  8005f1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005f4:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8005f7:	74 27                	je     800620 <_main+0x5e8>
  8005f9:	8b 5d b8             	mov    -0x48(%ebp),%ebx
  8005fc:	e8 c1 16 00 00       	call   801cc2 <sys_calculate_free_frames>
  800601:	29 c3                	sub    %eax,%ebx
  800603:	89 d8                	mov    %ebx,%eax
  800605:	83 ec 0c             	sub    $0xc,%esp
  800608:	50                   	push   %eax
  800609:	ff 75 dc             	pushl  -0x24(%ebp)
  80060c:	68 34 27 80 00       	push   $0x802734
  800611:	68 93 00 00 00       	push   $0x93
  800616:	68 1c 25 80 00       	push   $0x80251c
  80061b:	e8 19 02 00 00       	call   800839 <_panic>
	}
	cprintf("Step C completed!!\n\n\n");
  800620:	83 ec 0c             	sub    $0xc,%esp
  800623:	68 cf 28 80 00       	push   $0x8028cf
  800628:	e8 da 04 00 00       	call   800b07 <cprintf>
  80062d:	83 c4 10             	add    $0x10,%esp

	cprintf("Test of freeSharedObjects [4] is finished!!\n\n\n");
  800630:	83 ec 0c             	sub    $0xc,%esp
  800633:	68 e8 28 80 00       	push   $0x8028e8
  800638:	e8 ca 04 00 00       	call   800b07 <cprintf>
  80063d:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  800640:	e8 5f 18 00 00       	call   801ea4 <sys_getparentenvid>
  800645:	89 45 a8             	mov    %eax,-0x58(%ebp)
	if(parentenvID > 0)
  800648:	83 7d a8 00          	cmpl   $0x0,-0x58(%ebp)
  80064c:	7e 35                	jle    800683 <_main+0x64b>
	{
		//Get the check-finishing counter
		int *finishedCount = NULL;
  80064e:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
		finishedCount = sget(parentenvID, "finishedCount") ;
  800655:	83 ec 08             	sub    $0x8,%esp
  800658:	68 17 29 80 00       	push   $0x802917
  80065d:	ff 75 a8             	pushl  -0x58(%ebp)
  800660:	e8 e0 14 00 00       	call   801b45 <sget>
  800665:	83 c4 10             	add    $0x10,%esp
  800668:	89 45 a4             	mov    %eax,-0x5c(%ebp)

		//Critical section to protect the shared variable
		sys_lock_cons();
  80066b:	e8 a2 15 00 00       	call   801c12 <sys_lock_cons>
		{
			(*finishedCount)++ ;
  800670:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800673:	8b 00                	mov    (%eax),%eax
  800675:	8d 50 01             	lea    0x1(%eax),%edx
  800678:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80067b:	89 10                	mov    %edx,(%eax)
		}
		sys_unlock_cons();
  80067d:	e8 aa 15 00 00       	call   801c2c <sys_unlock_cons>
	}
	return;
  800682:	90                   	nop
  800683:	90                   	nop
}
  800684:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800687:	c9                   	leave  
  800688:	c3                   	ret    

00800689 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800689:	55                   	push   %ebp
  80068a:	89 e5                	mov    %esp,%ebp
  80068c:	57                   	push   %edi
  80068d:	56                   	push   %esi
  80068e:	53                   	push   %ebx
  80068f:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800692:	e8 f4 17 00 00       	call   801e8b <sys_getenvindex>
  800697:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  80069a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80069d:	89 d0                	mov    %edx,%eax
  80069f:	c1 e0 02             	shl    $0x2,%eax
  8006a2:	01 d0                	add    %edx,%eax
  8006a4:	c1 e0 03             	shl    $0x3,%eax
  8006a7:	01 d0                	add    %edx,%eax
  8006a9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8006b0:	01 d0                	add    %edx,%eax
  8006b2:	c1 e0 02             	shl    $0x2,%eax
  8006b5:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8006ba:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8006bf:	a1 20 40 80 00       	mov    0x804020,%eax
  8006c4:	8a 40 20             	mov    0x20(%eax),%al
  8006c7:	84 c0                	test   %al,%al
  8006c9:	74 0d                	je     8006d8 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8006cb:	a1 20 40 80 00       	mov    0x804020,%eax
  8006d0:	83 c0 20             	add    $0x20,%eax
  8006d3:	a3 04 40 80 00       	mov    %eax,0x804004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8006d8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8006dc:	7e 0a                	jle    8006e8 <libmain+0x5f>
		binaryname = argv[0];
  8006de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006e1:	8b 00                	mov    (%eax),%eax
  8006e3:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	_main(argc, argv);
  8006e8:	83 ec 08             	sub    $0x8,%esp
  8006eb:	ff 75 0c             	pushl  0xc(%ebp)
  8006ee:	ff 75 08             	pushl  0x8(%ebp)
  8006f1:	e8 42 f9 ff ff       	call   800038 <_main>
  8006f6:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8006f9:	a1 00 40 80 00       	mov    0x804000,%eax
  8006fe:	85 c0                	test   %eax,%eax
  800700:	0f 84 01 01 00 00    	je     800807 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800706:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80070c:	bb 20 2a 80 00       	mov    $0x802a20,%ebx
  800711:	ba 0e 00 00 00       	mov    $0xe,%edx
  800716:	89 c7                	mov    %eax,%edi
  800718:	89 de                	mov    %ebx,%esi
  80071a:	89 d1                	mov    %edx,%ecx
  80071c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80071e:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800721:	b9 56 00 00 00       	mov    $0x56,%ecx
  800726:	b0 00                	mov    $0x0,%al
  800728:	89 d7                	mov    %edx,%edi
  80072a:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80072c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800733:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800736:	83 ec 08             	sub    $0x8,%esp
  800739:	50                   	push   %eax
  80073a:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800740:	50                   	push   %eax
  800741:	e8 7b 19 00 00       	call   8020c1 <sys_utilities>
  800746:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800749:	e8 c4 14 00 00       	call   801c12 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80074e:	83 ec 0c             	sub    $0xc,%esp
  800751:	68 40 29 80 00       	push   $0x802940
  800756:	e8 ac 03 00 00       	call   800b07 <cprintf>
  80075b:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80075e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800761:	85 c0                	test   %eax,%eax
  800763:	74 18                	je     80077d <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800765:	e8 75 19 00 00       	call   8020df <sys_get_optimal_num_faults>
  80076a:	83 ec 08             	sub    $0x8,%esp
  80076d:	50                   	push   %eax
  80076e:	68 68 29 80 00       	push   $0x802968
  800773:	e8 8f 03 00 00       	call   800b07 <cprintf>
  800778:	83 c4 10             	add    $0x10,%esp
  80077b:	eb 59                	jmp    8007d6 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80077d:	a1 20 40 80 00       	mov    0x804020,%eax
  800782:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  800788:	a1 20 40 80 00       	mov    0x804020,%eax
  80078d:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  800793:	83 ec 04             	sub    $0x4,%esp
  800796:	52                   	push   %edx
  800797:	50                   	push   %eax
  800798:	68 8c 29 80 00       	push   $0x80298c
  80079d:	e8 65 03 00 00       	call   800b07 <cprintf>
  8007a2:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8007a5:	a1 20 40 80 00       	mov    0x804020,%eax
  8007aa:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8007b0:	a1 20 40 80 00       	mov    0x804020,%eax
  8007b5:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  8007bb:	a1 20 40 80 00       	mov    0x804020,%eax
  8007c0:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  8007c6:	51                   	push   %ecx
  8007c7:	52                   	push   %edx
  8007c8:	50                   	push   %eax
  8007c9:	68 b4 29 80 00       	push   $0x8029b4
  8007ce:	e8 34 03 00 00       	call   800b07 <cprintf>
  8007d3:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8007d6:	a1 20 40 80 00       	mov    0x804020,%eax
  8007db:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  8007e1:	83 ec 08             	sub    $0x8,%esp
  8007e4:	50                   	push   %eax
  8007e5:	68 0c 2a 80 00       	push   $0x802a0c
  8007ea:	e8 18 03 00 00       	call   800b07 <cprintf>
  8007ef:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8007f2:	83 ec 0c             	sub    $0xc,%esp
  8007f5:	68 40 29 80 00       	push   $0x802940
  8007fa:	e8 08 03 00 00       	call   800b07 <cprintf>
  8007ff:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800802:	e8 25 14 00 00       	call   801c2c <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800807:	e8 1f 00 00 00       	call   80082b <exit>
}
  80080c:	90                   	nop
  80080d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800810:	5b                   	pop    %ebx
  800811:	5e                   	pop    %esi
  800812:	5f                   	pop    %edi
  800813:	5d                   	pop    %ebp
  800814:	c3                   	ret    

00800815 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800815:	55                   	push   %ebp
  800816:	89 e5                	mov    %esp,%ebp
  800818:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80081b:	83 ec 0c             	sub    $0xc,%esp
  80081e:	6a 00                	push   $0x0
  800820:	e8 32 16 00 00       	call   801e57 <sys_destroy_env>
  800825:	83 c4 10             	add    $0x10,%esp
}
  800828:	90                   	nop
  800829:	c9                   	leave  
  80082a:	c3                   	ret    

0080082b <exit>:

void
exit(void)
{
  80082b:	55                   	push   %ebp
  80082c:	89 e5                	mov    %esp,%ebp
  80082e:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800831:	e8 87 16 00 00       	call   801ebd <sys_exit_env>
}
  800836:	90                   	nop
  800837:	c9                   	leave  
  800838:	c3                   	ret    

00800839 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800839:	55                   	push   %ebp
  80083a:	89 e5                	mov    %esp,%ebp
  80083c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80083f:	8d 45 10             	lea    0x10(%ebp),%eax
  800842:	83 c0 04             	add    $0x4,%eax
  800845:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800848:	a1 18 c1 81 00       	mov    0x81c118,%eax
  80084d:	85 c0                	test   %eax,%eax
  80084f:	74 16                	je     800867 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800851:	a1 18 c1 81 00       	mov    0x81c118,%eax
  800856:	83 ec 08             	sub    $0x8,%esp
  800859:	50                   	push   %eax
  80085a:	68 84 2a 80 00       	push   $0x802a84
  80085f:	e8 a3 02 00 00       	call   800b07 <cprintf>
  800864:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800867:	a1 04 40 80 00       	mov    0x804004,%eax
  80086c:	83 ec 0c             	sub    $0xc,%esp
  80086f:	ff 75 0c             	pushl  0xc(%ebp)
  800872:	ff 75 08             	pushl  0x8(%ebp)
  800875:	50                   	push   %eax
  800876:	68 8c 2a 80 00       	push   $0x802a8c
  80087b:	6a 74                	push   $0x74
  80087d:	e8 b2 02 00 00       	call   800b34 <cprintf_colored>
  800882:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800885:	8b 45 10             	mov    0x10(%ebp),%eax
  800888:	83 ec 08             	sub    $0x8,%esp
  80088b:	ff 75 f4             	pushl  -0xc(%ebp)
  80088e:	50                   	push   %eax
  80088f:	e8 04 02 00 00       	call   800a98 <vcprintf>
  800894:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800897:	83 ec 08             	sub    $0x8,%esp
  80089a:	6a 00                	push   $0x0
  80089c:	68 b4 2a 80 00       	push   $0x802ab4
  8008a1:	e8 f2 01 00 00       	call   800a98 <vcprintf>
  8008a6:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8008a9:	e8 7d ff ff ff       	call   80082b <exit>

	// should not return here
	while (1) ;
  8008ae:	eb fe                	jmp    8008ae <_panic+0x75>

008008b0 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8008b0:	55                   	push   %ebp
  8008b1:	89 e5                	mov    %esp,%ebp
  8008b3:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8008b6:	a1 20 40 80 00       	mov    0x804020,%eax
  8008bb:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8008c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008c4:	39 c2                	cmp    %eax,%edx
  8008c6:	74 14                	je     8008dc <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8008c8:	83 ec 04             	sub    $0x4,%esp
  8008cb:	68 b8 2a 80 00       	push   $0x802ab8
  8008d0:	6a 26                	push   $0x26
  8008d2:	68 04 2b 80 00       	push   $0x802b04
  8008d7:	e8 5d ff ff ff       	call   800839 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8008dc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8008e3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8008ea:	e9 c5 00 00 00       	jmp    8009b4 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8008ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008f2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8008f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fc:	01 d0                	add    %edx,%eax
  8008fe:	8b 00                	mov    (%eax),%eax
  800900:	85 c0                	test   %eax,%eax
  800902:	75 08                	jne    80090c <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800904:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800907:	e9 a5 00 00 00       	jmp    8009b1 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80090c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800913:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80091a:	eb 69                	jmp    800985 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80091c:	a1 20 40 80 00       	mov    0x804020,%eax
  800921:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800927:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80092a:	89 d0                	mov    %edx,%eax
  80092c:	01 c0                	add    %eax,%eax
  80092e:	01 d0                	add    %edx,%eax
  800930:	c1 e0 03             	shl    $0x3,%eax
  800933:	01 c8                	add    %ecx,%eax
  800935:	8a 40 04             	mov    0x4(%eax),%al
  800938:	84 c0                	test   %al,%al
  80093a:	75 46                	jne    800982 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80093c:	a1 20 40 80 00       	mov    0x804020,%eax
  800941:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800947:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80094a:	89 d0                	mov    %edx,%eax
  80094c:	01 c0                	add    %eax,%eax
  80094e:	01 d0                	add    %edx,%eax
  800950:	c1 e0 03             	shl    $0x3,%eax
  800953:	01 c8                	add    %ecx,%eax
  800955:	8b 00                	mov    (%eax),%eax
  800957:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80095a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80095d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800962:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800964:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800967:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80096e:	8b 45 08             	mov    0x8(%ebp),%eax
  800971:	01 c8                	add    %ecx,%eax
  800973:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800975:	39 c2                	cmp    %eax,%edx
  800977:	75 09                	jne    800982 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800979:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800980:	eb 15                	jmp    800997 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800982:	ff 45 e8             	incl   -0x18(%ebp)
  800985:	a1 20 40 80 00       	mov    0x804020,%eax
  80098a:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800990:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800993:	39 c2                	cmp    %eax,%edx
  800995:	77 85                	ja     80091c <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800997:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80099b:	75 14                	jne    8009b1 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80099d:	83 ec 04             	sub    $0x4,%esp
  8009a0:	68 10 2b 80 00       	push   $0x802b10
  8009a5:	6a 3a                	push   $0x3a
  8009a7:	68 04 2b 80 00       	push   $0x802b04
  8009ac:	e8 88 fe ff ff       	call   800839 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8009b1:	ff 45 f0             	incl   -0x10(%ebp)
  8009b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009b7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8009ba:	0f 8c 2f ff ff ff    	jl     8008ef <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8009c0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009c7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8009ce:	eb 26                	jmp    8009f6 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8009d0:	a1 20 40 80 00       	mov    0x804020,%eax
  8009d5:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8009db:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009de:	89 d0                	mov    %edx,%eax
  8009e0:	01 c0                	add    %eax,%eax
  8009e2:	01 d0                	add    %edx,%eax
  8009e4:	c1 e0 03             	shl    $0x3,%eax
  8009e7:	01 c8                	add    %ecx,%eax
  8009e9:	8a 40 04             	mov    0x4(%eax),%al
  8009ec:	3c 01                	cmp    $0x1,%al
  8009ee:	75 03                	jne    8009f3 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8009f0:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009f3:	ff 45 e0             	incl   -0x20(%ebp)
  8009f6:	a1 20 40 80 00       	mov    0x804020,%eax
  8009fb:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800a01:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a04:	39 c2                	cmp    %eax,%edx
  800a06:	77 c8                	ja     8009d0 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800a08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a0b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800a0e:	74 14                	je     800a24 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800a10:	83 ec 04             	sub    $0x4,%esp
  800a13:	68 64 2b 80 00       	push   $0x802b64
  800a18:	6a 44                	push   $0x44
  800a1a:	68 04 2b 80 00       	push   $0x802b04
  800a1f:	e8 15 fe ff ff       	call   800839 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800a24:	90                   	nop
  800a25:	c9                   	leave  
  800a26:	c3                   	ret    

00800a27 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800a27:	55                   	push   %ebp
  800a28:	89 e5                	mov    %esp,%ebp
  800a2a:	53                   	push   %ebx
  800a2b:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800a2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a31:	8b 00                	mov    (%eax),%eax
  800a33:	8d 48 01             	lea    0x1(%eax),%ecx
  800a36:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a39:	89 0a                	mov    %ecx,(%edx)
  800a3b:	8b 55 08             	mov    0x8(%ebp),%edx
  800a3e:	88 d1                	mov    %dl,%cl
  800a40:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a43:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800a47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a4a:	8b 00                	mov    (%eax),%eax
  800a4c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800a51:	75 30                	jne    800a83 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800a53:	8b 15 1c c1 81 00    	mov    0x81c11c,%edx
  800a59:	a0 44 40 80 00       	mov    0x804044,%al
  800a5e:	0f b6 c0             	movzbl %al,%eax
  800a61:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a64:	8b 09                	mov    (%ecx),%ecx
  800a66:	89 cb                	mov    %ecx,%ebx
  800a68:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a6b:	83 c1 08             	add    $0x8,%ecx
  800a6e:	52                   	push   %edx
  800a6f:	50                   	push   %eax
  800a70:	53                   	push   %ebx
  800a71:	51                   	push   %ecx
  800a72:	e8 57 11 00 00       	call   801bce <sys_cputs>
  800a77:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800a7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a7d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800a83:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a86:	8b 40 04             	mov    0x4(%eax),%eax
  800a89:	8d 50 01             	lea    0x1(%eax),%edx
  800a8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a8f:	89 50 04             	mov    %edx,0x4(%eax)
}
  800a92:	90                   	nop
  800a93:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a96:	c9                   	leave  
  800a97:	c3                   	ret    

00800a98 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800a98:	55                   	push   %ebp
  800a99:	89 e5                	mov    %esp,%ebp
  800a9b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800aa1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800aa8:	00 00 00 
	b.cnt = 0;
  800aab:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800ab2:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800ab5:	ff 75 0c             	pushl  0xc(%ebp)
  800ab8:	ff 75 08             	pushl  0x8(%ebp)
  800abb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800ac1:	50                   	push   %eax
  800ac2:	68 27 0a 80 00       	push   $0x800a27
  800ac7:	e8 5a 02 00 00       	call   800d26 <vprintfmt>
  800acc:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800acf:	8b 15 1c c1 81 00    	mov    0x81c11c,%edx
  800ad5:	a0 44 40 80 00       	mov    0x804044,%al
  800ada:	0f b6 c0             	movzbl %al,%eax
  800add:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800ae3:	52                   	push   %edx
  800ae4:	50                   	push   %eax
  800ae5:	51                   	push   %ecx
  800ae6:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800aec:	83 c0 08             	add    $0x8,%eax
  800aef:	50                   	push   %eax
  800af0:	e8 d9 10 00 00       	call   801bce <sys_cputs>
  800af5:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800af8:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
	return b.cnt;
  800aff:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800b05:	c9                   	leave  
  800b06:	c3                   	ret    

00800b07 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800b07:	55                   	push   %ebp
  800b08:	89 e5                	mov    %esp,%ebp
  800b0a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800b0d:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	va_start(ap, fmt);
  800b14:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b17:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800b1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1d:	83 ec 08             	sub    $0x8,%esp
  800b20:	ff 75 f4             	pushl  -0xc(%ebp)
  800b23:	50                   	push   %eax
  800b24:	e8 6f ff ff ff       	call   800a98 <vcprintf>
  800b29:	83 c4 10             	add    $0x10,%esp
  800b2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800b2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b32:	c9                   	leave  
  800b33:	c3                   	ret    

00800b34 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800b34:	55                   	push   %ebp
  800b35:	89 e5                	mov    %esp,%ebp
  800b37:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800b3a:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800b41:	8b 45 08             	mov    0x8(%ebp),%eax
  800b44:	c1 e0 08             	shl    $0x8,%eax
  800b47:	a3 1c c1 81 00       	mov    %eax,0x81c11c
	va_start(ap, fmt);
  800b4c:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b4f:	83 c0 04             	add    $0x4,%eax
  800b52:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800b55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b58:	83 ec 08             	sub    $0x8,%esp
  800b5b:	ff 75 f4             	pushl  -0xc(%ebp)
  800b5e:	50                   	push   %eax
  800b5f:	e8 34 ff ff ff       	call   800a98 <vcprintf>
  800b64:	83 c4 10             	add    $0x10,%esp
  800b67:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800b6a:	c7 05 1c c1 81 00 00 	movl   $0x700,0x81c11c
  800b71:	07 00 00 

	return cnt;
  800b74:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b77:	c9                   	leave  
  800b78:	c3                   	ret    

00800b79 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800b79:	55                   	push   %ebp
  800b7a:	89 e5                	mov    %esp,%ebp
  800b7c:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800b7f:	e8 8e 10 00 00       	call   801c12 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800b84:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b87:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8d:	83 ec 08             	sub    $0x8,%esp
  800b90:	ff 75 f4             	pushl  -0xc(%ebp)
  800b93:	50                   	push   %eax
  800b94:	e8 ff fe ff ff       	call   800a98 <vcprintf>
  800b99:	83 c4 10             	add    $0x10,%esp
  800b9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800b9f:	e8 88 10 00 00       	call   801c2c <sys_unlock_cons>
	return cnt;
  800ba4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ba7:	c9                   	leave  
  800ba8:	c3                   	ret    

00800ba9 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800ba9:	55                   	push   %ebp
  800baa:	89 e5                	mov    %esp,%ebp
  800bac:	53                   	push   %ebx
  800bad:	83 ec 14             	sub    $0x14,%esp
  800bb0:	8b 45 10             	mov    0x10(%ebp),%eax
  800bb3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bb6:	8b 45 14             	mov    0x14(%ebp),%eax
  800bb9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800bbc:	8b 45 18             	mov    0x18(%ebp),%eax
  800bbf:	ba 00 00 00 00       	mov    $0x0,%edx
  800bc4:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800bc7:	77 55                	ja     800c1e <printnum+0x75>
  800bc9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800bcc:	72 05                	jb     800bd3 <printnum+0x2a>
  800bce:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800bd1:	77 4b                	ja     800c1e <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800bd3:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800bd6:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800bd9:	8b 45 18             	mov    0x18(%ebp),%eax
  800bdc:	ba 00 00 00 00       	mov    $0x0,%edx
  800be1:	52                   	push   %edx
  800be2:	50                   	push   %eax
  800be3:	ff 75 f4             	pushl  -0xc(%ebp)
  800be6:	ff 75 f0             	pushl  -0x10(%ebp)
  800be9:	e8 aa 16 00 00       	call   802298 <__udivdi3>
  800bee:	83 c4 10             	add    $0x10,%esp
  800bf1:	83 ec 04             	sub    $0x4,%esp
  800bf4:	ff 75 20             	pushl  0x20(%ebp)
  800bf7:	53                   	push   %ebx
  800bf8:	ff 75 18             	pushl  0x18(%ebp)
  800bfb:	52                   	push   %edx
  800bfc:	50                   	push   %eax
  800bfd:	ff 75 0c             	pushl  0xc(%ebp)
  800c00:	ff 75 08             	pushl  0x8(%ebp)
  800c03:	e8 a1 ff ff ff       	call   800ba9 <printnum>
  800c08:	83 c4 20             	add    $0x20,%esp
  800c0b:	eb 1a                	jmp    800c27 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800c0d:	83 ec 08             	sub    $0x8,%esp
  800c10:	ff 75 0c             	pushl  0xc(%ebp)
  800c13:	ff 75 20             	pushl  0x20(%ebp)
  800c16:	8b 45 08             	mov    0x8(%ebp),%eax
  800c19:	ff d0                	call   *%eax
  800c1b:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c1e:	ff 4d 1c             	decl   0x1c(%ebp)
  800c21:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800c25:	7f e6                	jg     800c0d <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c27:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800c2a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c32:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c35:	53                   	push   %ebx
  800c36:	51                   	push   %ecx
  800c37:	52                   	push   %edx
  800c38:	50                   	push   %eax
  800c39:	e8 6a 17 00 00       	call   8023a8 <__umoddi3>
  800c3e:	83 c4 10             	add    $0x10,%esp
  800c41:	05 d4 2d 80 00       	add    $0x802dd4,%eax
  800c46:	8a 00                	mov    (%eax),%al
  800c48:	0f be c0             	movsbl %al,%eax
  800c4b:	83 ec 08             	sub    $0x8,%esp
  800c4e:	ff 75 0c             	pushl  0xc(%ebp)
  800c51:	50                   	push   %eax
  800c52:	8b 45 08             	mov    0x8(%ebp),%eax
  800c55:	ff d0                	call   *%eax
  800c57:	83 c4 10             	add    $0x10,%esp
}
  800c5a:	90                   	nop
  800c5b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c5e:	c9                   	leave  
  800c5f:	c3                   	ret    

00800c60 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800c60:	55                   	push   %ebp
  800c61:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c63:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c67:	7e 1c                	jle    800c85 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800c69:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6c:	8b 00                	mov    (%eax),%eax
  800c6e:	8d 50 08             	lea    0x8(%eax),%edx
  800c71:	8b 45 08             	mov    0x8(%ebp),%eax
  800c74:	89 10                	mov    %edx,(%eax)
  800c76:	8b 45 08             	mov    0x8(%ebp),%eax
  800c79:	8b 00                	mov    (%eax),%eax
  800c7b:	83 e8 08             	sub    $0x8,%eax
  800c7e:	8b 50 04             	mov    0x4(%eax),%edx
  800c81:	8b 00                	mov    (%eax),%eax
  800c83:	eb 40                	jmp    800cc5 <getuint+0x65>
	else if (lflag)
  800c85:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c89:	74 1e                	je     800ca9 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800c8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8e:	8b 00                	mov    (%eax),%eax
  800c90:	8d 50 04             	lea    0x4(%eax),%edx
  800c93:	8b 45 08             	mov    0x8(%ebp),%eax
  800c96:	89 10                	mov    %edx,(%eax)
  800c98:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9b:	8b 00                	mov    (%eax),%eax
  800c9d:	83 e8 04             	sub    $0x4,%eax
  800ca0:	8b 00                	mov    (%eax),%eax
  800ca2:	ba 00 00 00 00       	mov    $0x0,%edx
  800ca7:	eb 1c                	jmp    800cc5 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cac:	8b 00                	mov    (%eax),%eax
  800cae:	8d 50 04             	lea    0x4(%eax),%edx
  800cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb4:	89 10                	mov    %edx,(%eax)
  800cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb9:	8b 00                	mov    (%eax),%eax
  800cbb:	83 e8 04             	sub    $0x4,%eax
  800cbe:	8b 00                	mov    (%eax),%eax
  800cc0:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800cc5:	5d                   	pop    %ebp
  800cc6:	c3                   	ret    

00800cc7 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800cc7:	55                   	push   %ebp
  800cc8:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800cca:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800cce:	7e 1c                	jle    800cec <getint+0x25>
		return va_arg(*ap, long long);
  800cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd3:	8b 00                	mov    (%eax),%eax
  800cd5:	8d 50 08             	lea    0x8(%eax),%edx
  800cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdb:	89 10                	mov    %edx,(%eax)
  800cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce0:	8b 00                	mov    (%eax),%eax
  800ce2:	83 e8 08             	sub    $0x8,%eax
  800ce5:	8b 50 04             	mov    0x4(%eax),%edx
  800ce8:	8b 00                	mov    (%eax),%eax
  800cea:	eb 38                	jmp    800d24 <getint+0x5d>
	else if (lflag)
  800cec:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cf0:	74 1a                	je     800d0c <getint+0x45>
		return va_arg(*ap, long);
  800cf2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf5:	8b 00                	mov    (%eax),%eax
  800cf7:	8d 50 04             	lea    0x4(%eax),%edx
  800cfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfd:	89 10                	mov    %edx,(%eax)
  800cff:	8b 45 08             	mov    0x8(%ebp),%eax
  800d02:	8b 00                	mov    (%eax),%eax
  800d04:	83 e8 04             	sub    $0x4,%eax
  800d07:	8b 00                	mov    (%eax),%eax
  800d09:	99                   	cltd   
  800d0a:	eb 18                	jmp    800d24 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0f:	8b 00                	mov    (%eax),%eax
  800d11:	8d 50 04             	lea    0x4(%eax),%edx
  800d14:	8b 45 08             	mov    0x8(%ebp),%eax
  800d17:	89 10                	mov    %edx,(%eax)
  800d19:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1c:	8b 00                	mov    (%eax),%eax
  800d1e:	83 e8 04             	sub    $0x4,%eax
  800d21:	8b 00                	mov    (%eax),%eax
  800d23:	99                   	cltd   
}
  800d24:	5d                   	pop    %ebp
  800d25:	c3                   	ret    

00800d26 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800d26:	55                   	push   %ebp
  800d27:	89 e5                	mov    %esp,%ebp
  800d29:	56                   	push   %esi
  800d2a:	53                   	push   %ebx
  800d2b:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d2e:	eb 17                	jmp    800d47 <vprintfmt+0x21>
			if (ch == '\0')
  800d30:	85 db                	test   %ebx,%ebx
  800d32:	0f 84 c1 03 00 00    	je     8010f9 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800d38:	83 ec 08             	sub    $0x8,%esp
  800d3b:	ff 75 0c             	pushl  0xc(%ebp)
  800d3e:	53                   	push   %ebx
  800d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d42:	ff d0                	call   *%eax
  800d44:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d47:	8b 45 10             	mov    0x10(%ebp),%eax
  800d4a:	8d 50 01             	lea    0x1(%eax),%edx
  800d4d:	89 55 10             	mov    %edx,0x10(%ebp)
  800d50:	8a 00                	mov    (%eax),%al
  800d52:	0f b6 d8             	movzbl %al,%ebx
  800d55:	83 fb 25             	cmp    $0x25,%ebx
  800d58:	75 d6                	jne    800d30 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800d5a:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800d5e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800d65:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800d6c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800d73:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d7a:	8b 45 10             	mov    0x10(%ebp),%eax
  800d7d:	8d 50 01             	lea    0x1(%eax),%edx
  800d80:	89 55 10             	mov    %edx,0x10(%ebp)
  800d83:	8a 00                	mov    (%eax),%al
  800d85:	0f b6 d8             	movzbl %al,%ebx
  800d88:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800d8b:	83 f8 5b             	cmp    $0x5b,%eax
  800d8e:	0f 87 3d 03 00 00    	ja     8010d1 <vprintfmt+0x3ab>
  800d94:	8b 04 85 f8 2d 80 00 	mov    0x802df8(,%eax,4),%eax
  800d9b:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800d9d:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800da1:	eb d7                	jmp    800d7a <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800da3:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800da7:	eb d1                	jmp    800d7a <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800da9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800db0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800db3:	89 d0                	mov    %edx,%eax
  800db5:	c1 e0 02             	shl    $0x2,%eax
  800db8:	01 d0                	add    %edx,%eax
  800dba:	01 c0                	add    %eax,%eax
  800dbc:	01 d8                	add    %ebx,%eax
  800dbe:	83 e8 30             	sub    $0x30,%eax
  800dc1:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800dc4:	8b 45 10             	mov    0x10(%ebp),%eax
  800dc7:	8a 00                	mov    (%eax),%al
  800dc9:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800dcc:	83 fb 2f             	cmp    $0x2f,%ebx
  800dcf:	7e 3e                	jle    800e0f <vprintfmt+0xe9>
  800dd1:	83 fb 39             	cmp    $0x39,%ebx
  800dd4:	7f 39                	jg     800e0f <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800dd6:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800dd9:	eb d5                	jmp    800db0 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800ddb:	8b 45 14             	mov    0x14(%ebp),%eax
  800dde:	83 c0 04             	add    $0x4,%eax
  800de1:	89 45 14             	mov    %eax,0x14(%ebp)
  800de4:	8b 45 14             	mov    0x14(%ebp),%eax
  800de7:	83 e8 04             	sub    $0x4,%eax
  800dea:	8b 00                	mov    (%eax),%eax
  800dec:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800def:	eb 1f                	jmp    800e10 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800df1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800df5:	79 83                	jns    800d7a <vprintfmt+0x54>
				width = 0;
  800df7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800dfe:	e9 77 ff ff ff       	jmp    800d7a <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800e03:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800e0a:	e9 6b ff ff ff       	jmp    800d7a <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800e0f:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800e10:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e14:	0f 89 60 ff ff ff    	jns    800d7a <vprintfmt+0x54>
				width = precision, precision = -1;
  800e1a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e1d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e20:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800e27:	e9 4e ff ff ff       	jmp    800d7a <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800e2c:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800e2f:	e9 46 ff ff ff       	jmp    800d7a <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800e34:	8b 45 14             	mov    0x14(%ebp),%eax
  800e37:	83 c0 04             	add    $0x4,%eax
  800e3a:	89 45 14             	mov    %eax,0x14(%ebp)
  800e3d:	8b 45 14             	mov    0x14(%ebp),%eax
  800e40:	83 e8 04             	sub    $0x4,%eax
  800e43:	8b 00                	mov    (%eax),%eax
  800e45:	83 ec 08             	sub    $0x8,%esp
  800e48:	ff 75 0c             	pushl  0xc(%ebp)
  800e4b:	50                   	push   %eax
  800e4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4f:	ff d0                	call   *%eax
  800e51:	83 c4 10             	add    $0x10,%esp
			break;
  800e54:	e9 9b 02 00 00       	jmp    8010f4 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800e59:	8b 45 14             	mov    0x14(%ebp),%eax
  800e5c:	83 c0 04             	add    $0x4,%eax
  800e5f:	89 45 14             	mov    %eax,0x14(%ebp)
  800e62:	8b 45 14             	mov    0x14(%ebp),%eax
  800e65:	83 e8 04             	sub    $0x4,%eax
  800e68:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800e6a:	85 db                	test   %ebx,%ebx
  800e6c:	79 02                	jns    800e70 <vprintfmt+0x14a>
				err = -err;
  800e6e:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800e70:	83 fb 64             	cmp    $0x64,%ebx
  800e73:	7f 0b                	jg     800e80 <vprintfmt+0x15a>
  800e75:	8b 34 9d 40 2c 80 00 	mov    0x802c40(,%ebx,4),%esi
  800e7c:	85 f6                	test   %esi,%esi
  800e7e:	75 19                	jne    800e99 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800e80:	53                   	push   %ebx
  800e81:	68 e5 2d 80 00       	push   $0x802de5
  800e86:	ff 75 0c             	pushl  0xc(%ebp)
  800e89:	ff 75 08             	pushl  0x8(%ebp)
  800e8c:	e8 70 02 00 00       	call   801101 <printfmt>
  800e91:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800e94:	e9 5b 02 00 00       	jmp    8010f4 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800e99:	56                   	push   %esi
  800e9a:	68 ee 2d 80 00       	push   $0x802dee
  800e9f:	ff 75 0c             	pushl  0xc(%ebp)
  800ea2:	ff 75 08             	pushl  0x8(%ebp)
  800ea5:	e8 57 02 00 00       	call   801101 <printfmt>
  800eaa:	83 c4 10             	add    $0x10,%esp
			break;
  800ead:	e9 42 02 00 00       	jmp    8010f4 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800eb2:	8b 45 14             	mov    0x14(%ebp),%eax
  800eb5:	83 c0 04             	add    $0x4,%eax
  800eb8:	89 45 14             	mov    %eax,0x14(%ebp)
  800ebb:	8b 45 14             	mov    0x14(%ebp),%eax
  800ebe:	83 e8 04             	sub    $0x4,%eax
  800ec1:	8b 30                	mov    (%eax),%esi
  800ec3:	85 f6                	test   %esi,%esi
  800ec5:	75 05                	jne    800ecc <vprintfmt+0x1a6>
				p = "(null)";
  800ec7:	be f1 2d 80 00       	mov    $0x802df1,%esi
			if (width > 0 && padc != '-')
  800ecc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ed0:	7e 6d                	jle    800f3f <vprintfmt+0x219>
  800ed2:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800ed6:	74 67                	je     800f3f <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ed8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800edb:	83 ec 08             	sub    $0x8,%esp
  800ede:	50                   	push   %eax
  800edf:	56                   	push   %esi
  800ee0:	e8 1e 03 00 00       	call   801203 <strnlen>
  800ee5:	83 c4 10             	add    $0x10,%esp
  800ee8:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800eeb:	eb 16                	jmp    800f03 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800eed:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800ef1:	83 ec 08             	sub    $0x8,%esp
  800ef4:	ff 75 0c             	pushl  0xc(%ebp)
  800ef7:	50                   	push   %eax
  800ef8:	8b 45 08             	mov    0x8(%ebp),%eax
  800efb:	ff d0                	call   *%eax
  800efd:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800f00:	ff 4d e4             	decl   -0x1c(%ebp)
  800f03:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f07:	7f e4                	jg     800eed <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f09:	eb 34                	jmp    800f3f <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800f0b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800f0f:	74 1c                	je     800f2d <vprintfmt+0x207>
  800f11:	83 fb 1f             	cmp    $0x1f,%ebx
  800f14:	7e 05                	jle    800f1b <vprintfmt+0x1f5>
  800f16:	83 fb 7e             	cmp    $0x7e,%ebx
  800f19:	7e 12                	jle    800f2d <vprintfmt+0x207>
					putch('?', putdat);
  800f1b:	83 ec 08             	sub    $0x8,%esp
  800f1e:	ff 75 0c             	pushl  0xc(%ebp)
  800f21:	6a 3f                	push   $0x3f
  800f23:	8b 45 08             	mov    0x8(%ebp),%eax
  800f26:	ff d0                	call   *%eax
  800f28:	83 c4 10             	add    $0x10,%esp
  800f2b:	eb 0f                	jmp    800f3c <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800f2d:	83 ec 08             	sub    $0x8,%esp
  800f30:	ff 75 0c             	pushl  0xc(%ebp)
  800f33:	53                   	push   %ebx
  800f34:	8b 45 08             	mov    0x8(%ebp),%eax
  800f37:	ff d0                	call   *%eax
  800f39:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f3c:	ff 4d e4             	decl   -0x1c(%ebp)
  800f3f:	89 f0                	mov    %esi,%eax
  800f41:	8d 70 01             	lea    0x1(%eax),%esi
  800f44:	8a 00                	mov    (%eax),%al
  800f46:	0f be d8             	movsbl %al,%ebx
  800f49:	85 db                	test   %ebx,%ebx
  800f4b:	74 24                	je     800f71 <vprintfmt+0x24b>
  800f4d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f51:	78 b8                	js     800f0b <vprintfmt+0x1e5>
  800f53:	ff 4d e0             	decl   -0x20(%ebp)
  800f56:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f5a:	79 af                	jns    800f0b <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f5c:	eb 13                	jmp    800f71 <vprintfmt+0x24b>
				putch(' ', putdat);
  800f5e:	83 ec 08             	sub    $0x8,%esp
  800f61:	ff 75 0c             	pushl  0xc(%ebp)
  800f64:	6a 20                	push   $0x20
  800f66:	8b 45 08             	mov    0x8(%ebp),%eax
  800f69:	ff d0                	call   *%eax
  800f6b:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f6e:	ff 4d e4             	decl   -0x1c(%ebp)
  800f71:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f75:	7f e7                	jg     800f5e <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800f77:	e9 78 01 00 00       	jmp    8010f4 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800f7c:	83 ec 08             	sub    $0x8,%esp
  800f7f:	ff 75 e8             	pushl  -0x18(%ebp)
  800f82:	8d 45 14             	lea    0x14(%ebp),%eax
  800f85:	50                   	push   %eax
  800f86:	e8 3c fd ff ff       	call   800cc7 <getint>
  800f8b:	83 c4 10             	add    $0x10,%esp
  800f8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f91:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800f94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f97:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f9a:	85 d2                	test   %edx,%edx
  800f9c:	79 23                	jns    800fc1 <vprintfmt+0x29b>
				putch('-', putdat);
  800f9e:	83 ec 08             	sub    $0x8,%esp
  800fa1:	ff 75 0c             	pushl  0xc(%ebp)
  800fa4:	6a 2d                	push   $0x2d
  800fa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa9:	ff d0                	call   *%eax
  800fab:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800fae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fb1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fb4:	f7 d8                	neg    %eax
  800fb6:	83 d2 00             	adc    $0x0,%edx
  800fb9:	f7 da                	neg    %edx
  800fbb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fbe:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800fc1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800fc8:	e9 bc 00 00 00       	jmp    801089 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800fcd:	83 ec 08             	sub    $0x8,%esp
  800fd0:	ff 75 e8             	pushl  -0x18(%ebp)
  800fd3:	8d 45 14             	lea    0x14(%ebp),%eax
  800fd6:	50                   	push   %eax
  800fd7:	e8 84 fc ff ff       	call   800c60 <getuint>
  800fdc:	83 c4 10             	add    $0x10,%esp
  800fdf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fe2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800fe5:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800fec:	e9 98 00 00 00       	jmp    801089 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ff1:	83 ec 08             	sub    $0x8,%esp
  800ff4:	ff 75 0c             	pushl  0xc(%ebp)
  800ff7:	6a 58                	push   $0x58
  800ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffc:	ff d0                	call   *%eax
  800ffe:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801001:	83 ec 08             	sub    $0x8,%esp
  801004:	ff 75 0c             	pushl  0xc(%ebp)
  801007:	6a 58                	push   $0x58
  801009:	8b 45 08             	mov    0x8(%ebp),%eax
  80100c:	ff d0                	call   *%eax
  80100e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801011:	83 ec 08             	sub    $0x8,%esp
  801014:	ff 75 0c             	pushl  0xc(%ebp)
  801017:	6a 58                	push   $0x58
  801019:	8b 45 08             	mov    0x8(%ebp),%eax
  80101c:	ff d0                	call   *%eax
  80101e:	83 c4 10             	add    $0x10,%esp
			break;
  801021:	e9 ce 00 00 00       	jmp    8010f4 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  801026:	83 ec 08             	sub    $0x8,%esp
  801029:	ff 75 0c             	pushl  0xc(%ebp)
  80102c:	6a 30                	push   $0x30
  80102e:	8b 45 08             	mov    0x8(%ebp),%eax
  801031:	ff d0                	call   *%eax
  801033:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801036:	83 ec 08             	sub    $0x8,%esp
  801039:	ff 75 0c             	pushl  0xc(%ebp)
  80103c:	6a 78                	push   $0x78
  80103e:	8b 45 08             	mov    0x8(%ebp),%eax
  801041:	ff d0                	call   *%eax
  801043:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801046:	8b 45 14             	mov    0x14(%ebp),%eax
  801049:	83 c0 04             	add    $0x4,%eax
  80104c:	89 45 14             	mov    %eax,0x14(%ebp)
  80104f:	8b 45 14             	mov    0x14(%ebp),%eax
  801052:	83 e8 04             	sub    $0x4,%eax
  801055:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801057:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80105a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801061:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801068:	eb 1f                	jmp    801089 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80106a:	83 ec 08             	sub    $0x8,%esp
  80106d:	ff 75 e8             	pushl  -0x18(%ebp)
  801070:	8d 45 14             	lea    0x14(%ebp),%eax
  801073:	50                   	push   %eax
  801074:	e8 e7 fb ff ff       	call   800c60 <getuint>
  801079:	83 c4 10             	add    $0x10,%esp
  80107c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80107f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801082:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801089:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80108d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801090:	83 ec 04             	sub    $0x4,%esp
  801093:	52                   	push   %edx
  801094:	ff 75 e4             	pushl  -0x1c(%ebp)
  801097:	50                   	push   %eax
  801098:	ff 75 f4             	pushl  -0xc(%ebp)
  80109b:	ff 75 f0             	pushl  -0x10(%ebp)
  80109e:	ff 75 0c             	pushl  0xc(%ebp)
  8010a1:	ff 75 08             	pushl  0x8(%ebp)
  8010a4:	e8 00 fb ff ff       	call   800ba9 <printnum>
  8010a9:	83 c4 20             	add    $0x20,%esp
			break;
  8010ac:	eb 46                	jmp    8010f4 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8010ae:	83 ec 08             	sub    $0x8,%esp
  8010b1:	ff 75 0c             	pushl  0xc(%ebp)
  8010b4:	53                   	push   %ebx
  8010b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b8:	ff d0                	call   *%eax
  8010ba:	83 c4 10             	add    $0x10,%esp
			break;
  8010bd:	eb 35                	jmp    8010f4 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8010bf:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
			break;
  8010c6:	eb 2c                	jmp    8010f4 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8010c8:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
			break;
  8010cf:	eb 23                	jmp    8010f4 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8010d1:	83 ec 08             	sub    $0x8,%esp
  8010d4:	ff 75 0c             	pushl  0xc(%ebp)
  8010d7:	6a 25                	push   $0x25
  8010d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010dc:	ff d0                	call   *%eax
  8010de:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8010e1:	ff 4d 10             	decl   0x10(%ebp)
  8010e4:	eb 03                	jmp    8010e9 <vprintfmt+0x3c3>
  8010e6:	ff 4d 10             	decl   0x10(%ebp)
  8010e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ec:	48                   	dec    %eax
  8010ed:	8a 00                	mov    (%eax),%al
  8010ef:	3c 25                	cmp    $0x25,%al
  8010f1:	75 f3                	jne    8010e6 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8010f3:	90                   	nop
		}
	}
  8010f4:	e9 35 fc ff ff       	jmp    800d2e <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8010f9:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8010fa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8010fd:	5b                   	pop    %ebx
  8010fe:	5e                   	pop    %esi
  8010ff:	5d                   	pop    %ebp
  801100:	c3                   	ret    

00801101 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801101:	55                   	push   %ebp
  801102:	89 e5                	mov    %esp,%ebp
  801104:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801107:	8d 45 10             	lea    0x10(%ebp),%eax
  80110a:	83 c0 04             	add    $0x4,%eax
  80110d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801110:	8b 45 10             	mov    0x10(%ebp),%eax
  801113:	ff 75 f4             	pushl  -0xc(%ebp)
  801116:	50                   	push   %eax
  801117:	ff 75 0c             	pushl  0xc(%ebp)
  80111a:	ff 75 08             	pushl  0x8(%ebp)
  80111d:	e8 04 fc ff ff       	call   800d26 <vprintfmt>
  801122:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801125:	90                   	nop
  801126:	c9                   	leave  
  801127:	c3                   	ret    

00801128 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801128:	55                   	push   %ebp
  801129:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80112b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112e:	8b 40 08             	mov    0x8(%eax),%eax
  801131:	8d 50 01             	lea    0x1(%eax),%edx
  801134:	8b 45 0c             	mov    0xc(%ebp),%eax
  801137:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80113a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113d:	8b 10                	mov    (%eax),%edx
  80113f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801142:	8b 40 04             	mov    0x4(%eax),%eax
  801145:	39 c2                	cmp    %eax,%edx
  801147:	73 12                	jae    80115b <sprintputch+0x33>
		*b->buf++ = ch;
  801149:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114c:	8b 00                	mov    (%eax),%eax
  80114e:	8d 48 01             	lea    0x1(%eax),%ecx
  801151:	8b 55 0c             	mov    0xc(%ebp),%edx
  801154:	89 0a                	mov    %ecx,(%edx)
  801156:	8b 55 08             	mov    0x8(%ebp),%edx
  801159:	88 10                	mov    %dl,(%eax)
}
  80115b:	90                   	nop
  80115c:	5d                   	pop    %ebp
  80115d:	c3                   	ret    

0080115e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80115e:	55                   	push   %ebp
  80115f:	89 e5                	mov    %esp,%ebp
  801161:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801164:	8b 45 08             	mov    0x8(%ebp),%eax
  801167:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80116a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801170:	8b 45 08             	mov    0x8(%ebp),%eax
  801173:	01 d0                	add    %edx,%eax
  801175:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801178:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80117f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801183:	74 06                	je     80118b <vsnprintf+0x2d>
  801185:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801189:	7f 07                	jg     801192 <vsnprintf+0x34>
		return -E_INVAL;
  80118b:	b8 03 00 00 00       	mov    $0x3,%eax
  801190:	eb 20                	jmp    8011b2 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801192:	ff 75 14             	pushl  0x14(%ebp)
  801195:	ff 75 10             	pushl  0x10(%ebp)
  801198:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80119b:	50                   	push   %eax
  80119c:	68 28 11 80 00       	push   $0x801128
  8011a1:	e8 80 fb ff ff       	call   800d26 <vprintfmt>
  8011a6:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8011a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8011ac:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8011af:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8011b2:	c9                   	leave  
  8011b3:	c3                   	ret    

008011b4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8011b4:	55                   	push   %ebp
  8011b5:	89 e5                	mov    %esp,%ebp
  8011b7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8011ba:	8d 45 10             	lea    0x10(%ebp),%eax
  8011bd:	83 c0 04             	add    $0x4,%eax
  8011c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8011c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c6:	ff 75 f4             	pushl  -0xc(%ebp)
  8011c9:	50                   	push   %eax
  8011ca:	ff 75 0c             	pushl  0xc(%ebp)
  8011cd:	ff 75 08             	pushl  0x8(%ebp)
  8011d0:	e8 89 ff ff ff       	call   80115e <vsnprintf>
  8011d5:	83 c4 10             	add    $0x10,%esp
  8011d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8011db:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8011de:	c9                   	leave  
  8011df:	c3                   	ret    

008011e0 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8011e0:	55                   	push   %ebp
  8011e1:	89 e5                	mov    %esp,%ebp
  8011e3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8011e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011ed:	eb 06                	jmp    8011f5 <strlen+0x15>
		n++;
  8011ef:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8011f2:	ff 45 08             	incl   0x8(%ebp)
  8011f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f8:	8a 00                	mov    (%eax),%al
  8011fa:	84 c0                	test   %al,%al
  8011fc:	75 f1                	jne    8011ef <strlen+0xf>
		n++;
	return n;
  8011fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801201:	c9                   	leave  
  801202:	c3                   	ret    

00801203 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801203:	55                   	push   %ebp
  801204:	89 e5                	mov    %esp,%ebp
  801206:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801209:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801210:	eb 09                	jmp    80121b <strnlen+0x18>
		n++;
  801212:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801215:	ff 45 08             	incl   0x8(%ebp)
  801218:	ff 4d 0c             	decl   0xc(%ebp)
  80121b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80121f:	74 09                	je     80122a <strnlen+0x27>
  801221:	8b 45 08             	mov    0x8(%ebp),%eax
  801224:	8a 00                	mov    (%eax),%al
  801226:	84 c0                	test   %al,%al
  801228:	75 e8                	jne    801212 <strnlen+0xf>
		n++;
	return n;
  80122a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80122d:	c9                   	leave  
  80122e:	c3                   	ret    

0080122f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80122f:	55                   	push   %ebp
  801230:	89 e5                	mov    %esp,%ebp
  801232:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801235:	8b 45 08             	mov    0x8(%ebp),%eax
  801238:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80123b:	90                   	nop
  80123c:	8b 45 08             	mov    0x8(%ebp),%eax
  80123f:	8d 50 01             	lea    0x1(%eax),%edx
  801242:	89 55 08             	mov    %edx,0x8(%ebp)
  801245:	8b 55 0c             	mov    0xc(%ebp),%edx
  801248:	8d 4a 01             	lea    0x1(%edx),%ecx
  80124b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80124e:	8a 12                	mov    (%edx),%dl
  801250:	88 10                	mov    %dl,(%eax)
  801252:	8a 00                	mov    (%eax),%al
  801254:	84 c0                	test   %al,%al
  801256:	75 e4                	jne    80123c <strcpy+0xd>
		/* do nothing */;
	return ret;
  801258:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80125b:	c9                   	leave  
  80125c:	c3                   	ret    

0080125d <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80125d:	55                   	push   %ebp
  80125e:	89 e5                	mov    %esp,%ebp
  801260:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801263:	8b 45 08             	mov    0x8(%ebp),%eax
  801266:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801269:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801270:	eb 1f                	jmp    801291 <strncpy+0x34>
		*dst++ = *src;
  801272:	8b 45 08             	mov    0x8(%ebp),%eax
  801275:	8d 50 01             	lea    0x1(%eax),%edx
  801278:	89 55 08             	mov    %edx,0x8(%ebp)
  80127b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80127e:	8a 12                	mov    (%edx),%dl
  801280:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801282:	8b 45 0c             	mov    0xc(%ebp),%eax
  801285:	8a 00                	mov    (%eax),%al
  801287:	84 c0                	test   %al,%al
  801289:	74 03                	je     80128e <strncpy+0x31>
			src++;
  80128b:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80128e:	ff 45 fc             	incl   -0x4(%ebp)
  801291:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801294:	3b 45 10             	cmp    0x10(%ebp),%eax
  801297:	72 d9                	jb     801272 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801299:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80129c:	c9                   	leave  
  80129d:	c3                   	ret    

0080129e <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80129e:	55                   	push   %ebp
  80129f:	89 e5                	mov    %esp,%ebp
  8012a1:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8012a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8012aa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012ae:	74 30                	je     8012e0 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8012b0:	eb 16                	jmp    8012c8 <strlcpy+0x2a>
			*dst++ = *src++;
  8012b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b5:	8d 50 01             	lea    0x1(%eax),%edx
  8012b8:	89 55 08             	mov    %edx,0x8(%ebp)
  8012bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012be:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012c1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8012c4:	8a 12                	mov    (%edx),%dl
  8012c6:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8012c8:	ff 4d 10             	decl   0x10(%ebp)
  8012cb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012cf:	74 09                	je     8012da <strlcpy+0x3c>
  8012d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d4:	8a 00                	mov    (%eax),%al
  8012d6:	84 c0                	test   %al,%al
  8012d8:	75 d8                	jne    8012b2 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8012da:	8b 45 08             	mov    0x8(%ebp),%eax
  8012dd:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8012e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8012e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012e6:	29 c2                	sub    %eax,%edx
  8012e8:	89 d0                	mov    %edx,%eax
}
  8012ea:	c9                   	leave  
  8012eb:	c3                   	ret    

008012ec <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8012ec:	55                   	push   %ebp
  8012ed:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8012ef:	eb 06                	jmp    8012f7 <strcmp+0xb>
		p++, q++;
  8012f1:	ff 45 08             	incl   0x8(%ebp)
  8012f4:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8012f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fa:	8a 00                	mov    (%eax),%al
  8012fc:	84 c0                	test   %al,%al
  8012fe:	74 0e                	je     80130e <strcmp+0x22>
  801300:	8b 45 08             	mov    0x8(%ebp),%eax
  801303:	8a 10                	mov    (%eax),%dl
  801305:	8b 45 0c             	mov    0xc(%ebp),%eax
  801308:	8a 00                	mov    (%eax),%al
  80130a:	38 c2                	cmp    %al,%dl
  80130c:	74 e3                	je     8012f1 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80130e:	8b 45 08             	mov    0x8(%ebp),%eax
  801311:	8a 00                	mov    (%eax),%al
  801313:	0f b6 d0             	movzbl %al,%edx
  801316:	8b 45 0c             	mov    0xc(%ebp),%eax
  801319:	8a 00                	mov    (%eax),%al
  80131b:	0f b6 c0             	movzbl %al,%eax
  80131e:	29 c2                	sub    %eax,%edx
  801320:	89 d0                	mov    %edx,%eax
}
  801322:	5d                   	pop    %ebp
  801323:	c3                   	ret    

00801324 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801324:	55                   	push   %ebp
  801325:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801327:	eb 09                	jmp    801332 <strncmp+0xe>
		n--, p++, q++;
  801329:	ff 4d 10             	decl   0x10(%ebp)
  80132c:	ff 45 08             	incl   0x8(%ebp)
  80132f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801332:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801336:	74 17                	je     80134f <strncmp+0x2b>
  801338:	8b 45 08             	mov    0x8(%ebp),%eax
  80133b:	8a 00                	mov    (%eax),%al
  80133d:	84 c0                	test   %al,%al
  80133f:	74 0e                	je     80134f <strncmp+0x2b>
  801341:	8b 45 08             	mov    0x8(%ebp),%eax
  801344:	8a 10                	mov    (%eax),%dl
  801346:	8b 45 0c             	mov    0xc(%ebp),%eax
  801349:	8a 00                	mov    (%eax),%al
  80134b:	38 c2                	cmp    %al,%dl
  80134d:	74 da                	je     801329 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80134f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801353:	75 07                	jne    80135c <strncmp+0x38>
		return 0;
  801355:	b8 00 00 00 00       	mov    $0x0,%eax
  80135a:	eb 14                	jmp    801370 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80135c:	8b 45 08             	mov    0x8(%ebp),%eax
  80135f:	8a 00                	mov    (%eax),%al
  801361:	0f b6 d0             	movzbl %al,%edx
  801364:	8b 45 0c             	mov    0xc(%ebp),%eax
  801367:	8a 00                	mov    (%eax),%al
  801369:	0f b6 c0             	movzbl %al,%eax
  80136c:	29 c2                	sub    %eax,%edx
  80136e:	89 d0                	mov    %edx,%eax
}
  801370:	5d                   	pop    %ebp
  801371:	c3                   	ret    

00801372 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801372:	55                   	push   %ebp
  801373:	89 e5                	mov    %esp,%ebp
  801375:	83 ec 04             	sub    $0x4,%esp
  801378:	8b 45 0c             	mov    0xc(%ebp),%eax
  80137b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80137e:	eb 12                	jmp    801392 <strchr+0x20>
		if (*s == c)
  801380:	8b 45 08             	mov    0x8(%ebp),%eax
  801383:	8a 00                	mov    (%eax),%al
  801385:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801388:	75 05                	jne    80138f <strchr+0x1d>
			return (char *) s;
  80138a:	8b 45 08             	mov    0x8(%ebp),%eax
  80138d:	eb 11                	jmp    8013a0 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80138f:	ff 45 08             	incl   0x8(%ebp)
  801392:	8b 45 08             	mov    0x8(%ebp),%eax
  801395:	8a 00                	mov    (%eax),%al
  801397:	84 c0                	test   %al,%al
  801399:	75 e5                	jne    801380 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80139b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013a0:	c9                   	leave  
  8013a1:	c3                   	ret    

008013a2 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8013a2:	55                   	push   %ebp
  8013a3:	89 e5                	mov    %esp,%ebp
  8013a5:	83 ec 04             	sub    $0x4,%esp
  8013a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ab:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8013ae:	eb 0d                	jmp    8013bd <strfind+0x1b>
		if (*s == c)
  8013b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b3:	8a 00                	mov    (%eax),%al
  8013b5:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8013b8:	74 0e                	je     8013c8 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8013ba:	ff 45 08             	incl   0x8(%ebp)
  8013bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c0:	8a 00                	mov    (%eax),%al
  8013c2:	84 c0                	test   %al,%al
  8013c4:	75 ea                	jne    8013b0 <strfind+0xe>
  8013c6:	eb 01                	jmp    8013c9 <strfind+0x27>
		if (*s == c)
			break;
  8013c8:	90                   	nop
	return (char *) s;
  8013c9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013cc:	c9                   	leave  
  8013cd:	c3                   	ret    

008013ce <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  8013ce:	55                   	push   %ebp
  8013cf:	89 e5                	mov    %esp,%ebp
  8013d1:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  8013d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  8013da:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8013de:	76 63                	jbe    801443 <memset+0x75>
		uint64 data_block = c;
  8013e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e3:	99                   	cltd   
  8013e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8013e7:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  8013ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013f0:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  8013f4:	c1 e0 08             	shl    $0x8,%eax
  8013f7:	09 45 f0             	or     %eax,-0x10(%ebp)
  8013fa:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  8013fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801400:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801403:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801407:	c1 e0 10             	shl    $0x10,%eax
  80140a:	09 45 f0             	or     %eax,-0x10(%ebp)
  80140d:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801410:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801413:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801416:	89 c2                	mov    %eax,%edx
  801418:	b8 00 00 00 00       	mov    $0x0,%eax
  80141d:	09 45 f0             	or     %eax,-0x10(%ebp)
  801420:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801423:	eb 18                	jmp    80143d <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801425:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801428:	8d 41 08             	lea    0x8(%ecx),%eax
  80142b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80142e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801431:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801434:	89 01                	mov    %eax,(%ecx)
  801436:	89 51 04             	mov    %edx,0x4(%ecx)
  801439:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  80143d:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801441:	77 e2                	ja     801425 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801443:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801447:	74 23                	je     80146c <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801449:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80144c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  80144f:	eb 0e                	jmp    80145f <memset+0x91>
			*p8++ = (uint8)c;
  801451:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801454:	8d 50 01             	lea    0x1(%eax),%edx
  801457:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80145a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80145d:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  80145f:	8b 45 10             	mov    0x10(%ebp),%eax
  801462:	8d 50 ff             	lea    -0x1(%eax),%edx
  801465:	89 55 10             	mov    %edx,0x10(%ebp)
  801468:	85 c0                	test   %eax,%eax
  80146a:	75 e5                	jne    801451 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  80146c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80146f:	c9                   	leave  
  801470:	c3                   	ret    

00801471 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801471:	55                   	push   %ebp
  801472:	89 e5                	mov    %esp,%ebp
  801474:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801477:	8b 45 0c             	mov    0xc(%ebp),%eax
  80147a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  80147d:	8b 45 08             	mov    0x8(%ebp),%eax
  801480:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801483:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801487:	76 24                	jbe    8014ad <memcpy+0x3c>
		while(n >= 8){
  801489:	eb 1c                	jmp    8014a7 <memcpy+0x36>
			*d64 = *s64;
  80148b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80148e:	8b 50 04             	mov    0x4(%eax),%edx
  801491:	8b 00                	mov    (%eax),%eax
  801493:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801496:	89 01                	mov    %eax,(%ecx)
  801498:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  80149b:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  80149f:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8014a3:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8014a7:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8014ab:	77 de                	ja     80148b <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8014ad:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014b1:	74 31                	je     8014e4 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8014b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8014b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8014bf:	eb 16                	jmp    8014d7 <memcpy+0x66>
			*d8++ = *s8++;
  8014c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014c4:	8d 50 01             	lea    0x1(%eax),%edx
  8014c7:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8014ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014cd:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014d0:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8014d3:	8a 12                	mov    (%edx),%dl
  8014d5:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  8014d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8014da:	8d 50 ff             	lea    -0x1(%eax),%edx
  8014dd:	89 55 10             	mov    %edx,0x10(%ebp)
  8014e0:	85 c0                	test   %eax,%eax
  8014e2:	75 dd                	jne    8014c1 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  8014e4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014e7:	c9                   	leave  
  8014e8:	c3                   	ret    

008014e9 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8014e9:	55                   	push   %ebp
  8014ea:	89 e5                	mov    %esp,%ebp
  8014ec:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8014ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8014f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8014fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014fe:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801501:	73 50                	jae    801553 <memmove+0x6a>
  801503:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801506:	8b 45 10             	mov    0x10(%ebp),%eax
  801509:	01 d0                	add    %edx,%eax
  80150b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80150e:	76 43                	jbe    801553 <memmove+0x6a>
		s += n;
  801510:	8b 45 10             	mov    0x10(%ebp),%eax
  801513:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801516:	8b 45 10             	mov    0x10(%ebp),%eax
  801519:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80151c:	eb 10                	jmp    80152e <memmove+0x45>
			*--d = *--s;
  80151e:	ff 4d f8             	decl   -0x8(%ebp)
  801521:	ff 4d fc             	decl   -0x4(%ebp)
  801524:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801527:	8a 10                	mov    (%eax),%dl
  801529:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80152c:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80152e:	8b 45 10             	mov    0x10(%ebp),%eax
  801531:	8d 50 ff             	lea    -0x1(%eax),%edx
  801534:	89 55 10             	mov    %edx,0x10(%ebp)
  801537:	85 c0                	test   %eax,%eax
  801539:	75 e3                	jne    80151e <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80153b:	eb 23                	jmp    801560 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80153d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801540:	8d 50 01             	lea    0x1(%eax),%edx
  801543:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801546:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801549:	8d 4a 01             	lea    0x1(%edx),%ecx
  80154c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80154f:	8a 12                	mov    (%edx),%dl
  801551:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801553:	8b 45 10             	mov    0x10(%ebp),%eax
  801556:	8d 50 ff             	lea    -0x1(%eax),%edx
  801559:	89 55 10             	mov    %edx,0x10(%ebp)
  80155c:	85 c0                	test   %eax,%eax
  80155e:	75 dd                	jne    80153d <memmove+0x54>
			*d++ = *s++;

	return dst;
  801560:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801563:	c9                   	leave  
  801564:	c3                   	ret    

00801565 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801565:	55                   	push   %ebp
  801566:	89 e5                	mov    %esp,%ebp
  801568:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80156b:	8b 45 08             	mov    0x8(%ebp),%eax
  80156e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801571:	8b 45 0c             	mov    0xc(%ebp),%eax
  801574:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801577:	eb 2a                	jmp    8015a3 <memcmp+0x3e>
		if (*s1 != *s2)
  801579:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80157c:	8a 10                	mov    (%eax),%dl
  80157e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801581:	8a 00                	mov    (%eax),%al
  801583:	38 c2                	cmp    %al,%dl
  801585:	74 16                	je     80159d <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801587:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80158a:	8a 00                	mov    (%eax),%al
  80158c:	0f b6 d0             	movzbl %al,%edx
  80158f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801592:	8a 00                	mov    (%eax),%al
  801594:	0f b6 c0             	movzbl %al,%eax
  801597:	29 c2                	sub    %eax,%edx
  801599:	89 d0                	mov    %edx,%eax
  80159b:	eb 18                	jmp    8015b5 <memcmp+0x50>
		s1++, s2++;
  80159d:	ff 45 fc             	incl   -0x4(%ebp)
  8015a0:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8015a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8015a6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015a9:	89 55 10             	mov    %edx,0x10(%ebp)
  8015ac:	85 c0                	test   %eax,%eax
  8015ae:	75 c9                	jne    801579 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8015b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015b5:	c9                   	leave  
  8015b6:	c3                   	ret    

008015b7 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8015b7:	55                   	push   %ebp
  8015b8:	89 e5                	mov    %esp,%ebp
  8015ba:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8015bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8015c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8015c3:	01 d0                	add    %edx,%eax
  8015c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8015c8:	eb 15                	jmp    8015df <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8015ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cd:	8a 00                	mov    (%eax),%al
  8015cf:	0f b6 d0             	movzbl %al,%edx
  8015d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d5:	0f b6 c0             	movzbl %al,%eax
  8015d8:	39 c2                	cmp    %eax,%edx
  8015da:	74 0d                	je     8015e9 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8015dc:	ff 45 08             	incl   0x8(%ebp)
  8015df:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8015e5:	72 e3                	jb     8015ca <memfind+0x13>
  8015e7:	eb 01                	jmp    8015ea <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8015e9:	90                   	nop
	return (void *) s;
  8015ea:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015ed:	c9                   	leave  
  8015ee:	c3                   	ret    

008015ef <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8015ef:	55                   	push   %ebp
  8015f0:	89 e5                	mov    %esp,%ebp
  8015f2:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8015f5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8015fc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801603:	eb 03                	jmp    801608 <strtol+0x19>
		s++;
  801605:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801608:	8b 45 08             	mov    0x8(%ebp),%eax
  80160b:	8a 00                	mov    (%eax),%al
  80160d:	3c 20                	cmp    $0x20,%al
  80160f:	74 f4                	je     801605 <strtol+0x16>
  801611:	8b 45 08             	mov    0x8(%ebp),%eax
  801614:	8a 00                	mov    (%eax),%al
  801616:	3c 09                	cmp    $0x9,%al
  801618:	74 eb                	je     801605 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80161a:	8b 45 08             	mov    0x8(%ebp),%eax
  80161d:	8a 00                	mov    (%eax),%al
  80161f:	3c 2b                	cmp    $0x2b,%al
  801621:	75 05                	jne    801628 <strtol+0x39>
		s++;
  801623:	ff 45 08             	incl   0x8(%ebp)
  801626:	eb 13                	jmp    80163b <strtol+0x4c>
	else if (*s == '-')
  801628:	8b 45 08             	mov    0x8(%ebp),%eax
  80162b:	8a 00                	mov    (%eax),%al
  80162d:	3c 2d                	cmp    $0x2d,%al
  80162f:	75 0a                	jne    80163b <strtol+0x4c>
		s++, neg = 1;
  801631:	ff 45 08             	incl   0x8(%ebp)
  801634:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80163b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80163f:	74 06                	je     801647 <strtol+0x58>
  801641:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801645:	75 20                	jne    801667 <strtol+0x78>
  801647:	8b 45 08             	mov    0x8(%ebp),%eax
  80164a:	8a 00                	mov    (%eax),%al
  80164c:	3c 30                	cmp    $0x30,%al
  80164e:	75 17                	jne    801667 <strtol+0x78>
  801650:	8b 45 08             	mov    0x8(%ebp),%eax
  801653:	40                   	inc    %eax
  801654:	8a 00                	mov    (%eax),%al
  801656:	3c 78                	cmp    $0x78,%al
  801658:	75 0d                	jne    801667 <strtol+0x78>
		s += 2, base = 16;
  80165a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80165e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801665:	eb 28                	jmp    80168f <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801667:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80166b:	75 15                	jne    801682 <strtol+0x93>
  80166d:	8b 45 08             	mov    0x8(%ebp),%eax
  801670:	8a 00                	mov    (%eax),%al
  801672:	3c 30                	cmp    $0x30,%al
  801674:	75 0c                	jne    801682 <strtol+0x93>
		s++, base = 8;
  801676:	ff 45 08             	incl   0x8(%ebp)
  801679:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801680:	eb 0d                	jmp    80168f <strtol+0xa0>
	else if (base == 0)
  801682:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801686:	75 07                	jne    80168f <strtol+0xa0>
		base = 10;
  801688:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80168f:	8b 45 08             	mov    0x8(%ebp),%eax
  801692:	8a 00                	mov    (%eax),%al
  801694:	3c 2f                	cmp    $0x2f,%al
  801696:	7e 19                	jle    8016b1 <strtol+0xc2>
  801698:	8b 45 08             	mov    0x8(%ebp),%eax
  80169b:	8a 00                	mov    (%eax),%al
  80169d:	3c 39                	cmp    $0x39,%al
  80169f:	7f 10                	jg     8016b1 <strtol+0xc2>
			dig = *s - '0';
  8016a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a4:	8a 00                	mov    (%eax),%al
  8016a6:	0f be c0             	movsbl %al,%eax
  8016a9:	83 e8 30             	sub    $0x30,%eax
  8016ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016af:	eb 42                	jmp    8016f3 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8016b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b4:	8a 00                	mov    (%eax),%al
  8016b6:	3c 60                	cmp    $0x60,%al
  8016b8:	7e 19                	jle    8016d3 <strtol+0xe4>
  8016ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bd:	8a 00                	mov    (%eax),%al
  8016bf:	3c 7a                	cmp    $0x7a,%al
  8016c1:	7f 10                	jg     8016d3 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8016c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c6:	8a 00                	mov    (%eax),%al
  8016c8:	0f be c0             	movsbl %al,%eax
  8016cb:	83 e8 57             	sub    $0x57,%eax
  8016ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016d1:	eb 20                	jmp    8016f3 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8016d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d6:	8a 00                	mov    (%eax),%al
  8016d8:	3c 40                	cmp    $0x40,%al
  8016da:	7e 39                	jle    801715 <strtol+0x126>
  8016dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016df:	8a 00                	mov    (%eax),%al
  8016e1:	3c 5a                	cmp    $0x5a,%al
  8016e3:	7f 30                	jg     801715 <strtol+0x126>
			dig = *s - 'A' + 10;
  8016e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e8:	8a 00                	mov    (%eax),%al
  8016ea:	0f be c0             	movsbl %al,%eax
  8016ed:	83 e8 37             	sub    $0x37,%eax
  8016f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8016f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016f6:	3b 45 10             	cmp    0x10(%ebp),%eax
  8016f9:	7d 19                	jge    801714 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8016fb:	ff 45 08             	incl   0x8(%ebp)
  8016fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801701:	0f af 45 10          	imul   0x10(%ebp),%eax
  801705:	89 c2                	mov    %eax,%edx
  801707:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80170a:	01 d0                	add    %edx,%eax
  80170c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80170f:	e9 7b ff ff ff       	jmp    80168f <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801714:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801715:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801719:	74 08                	je     801723 <strtol+0x134>
		*endptr = (char *) s;
  80171b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80171e:	8b 55 08             	mov    0x8(%ebp),%edx
  801721:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801723:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801727:	74 07                	je     801730 <strtol+0x141>
  801729:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80172c:	f7 d8                	neg    %eax
  80172e:	eb 03                	jmp    801733 <strtol+0x144>
  801730:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801733:	c9                   	leave  
  801734:	c3                   	ret    

00801735 <ltostr>:

void
ltostr(long value, char *str)
{
  801735:	55                   	push   %ebp
  801736:	89 e5                	mov    %esp,%ebp
  801738:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80173b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801742:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801749:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80174d:	79 13                	jns    801762 <ltostr+0x2d>
	{
		neg = 1;
  80174f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801756:	8b 45 0c             	mov    0xc(%ebp),%eax
  801759:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80175c:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80175f:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801762:	8b 45 08             	mov    0x8(%ebp),%eax
  801765:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80176a:	99                   	cltd   
  80176b:	f7 f9                	idiv   %ecx
  80176d:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801770:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801773:	8d 50 01             	lea    0x1(%eax),%edx
  801776:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801779:	89 c2                	mov    %eax,%edx
  80177b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80177e:	01 d0                	add    %edx,%eax
  801780:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801783:	83 c2 30             	add    $0x30,%edx
  801786:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801788:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80178b:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801790:	f7 e9                	imul   %ecx
  801792:	c1 fa 02             	sar    $0x2,%edx
  801795:	89 c8                	mov    %ecx,%eax
  801797:	c1 f8 1f             	sar    $0x1f,%eax
  80179a:	29 c2                	sub    %eax,%edx
  80179c:	89 d0                	mov    %edx,%eax
  80179e:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8017a1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8017a5:	75 bb                	jne    801762 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8017a7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8017ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017b1:	48                   	dec    %eax
  8017b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8017b5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8017b9:	74 3d                	je     8017f8 <ltostr+0xc3>
		start = 1 ;
  8017bb:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8017c2:	eb 34                	jmp    8017f8 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8017c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ca:	01 d0                	add    %edx,%eax
  8017cc:	8a 00                	mov    (%eax),%al
  8017ce:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8017d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017d7:	01 c2                	add    %eax,%edx
  8017d9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8017dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017df:	01 c8                	add    %ecx,%eax
  8017e1:	8a 00                	mov    (%eax),%al
  8017e3:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8017e5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017eb:	01 c2                	add    %eax,%edx
  8017ed:	8a 45 eb             	mov    -0x15(%ebp),%al
  8017f0:	88 02                	mov    %al,(%edx)
		start++ ;
  8017f2:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8017f5:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8017f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017fb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8017fe:	7c c4                	jl     8017c4 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801800:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801803:	8b 45 0c             	mov    0xc(%ebp),%eax
  801806:	01 d0                	add    %edx,%eax
  801808:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80180b:	90                   	nop
  80180c:	c9                   	leave  
  80180d:	c3                   	ret    

0080180e <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80180e:	55                   	push   %ebp
  80180f:	89 e5                	mov    %esp,%ebp
  801811:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801814:	ff 75 08             	pushl  0x8(%ebp)
  801817:	e8 c4 f9 ff ff       	call   8011e0 <strlen>
  80181c:	83 c4 04             	add    $0x4,%esp
  80181f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801822:	ff 75 0c             	pushl  0xc(%ebp)
  801825:	e8 b6 f9 ff ff       	call   8011e0 <strlen>
  80182a:	83 c4 04             	add    $0x4,%esp
  80182d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801830:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801837:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80183e:	eb 17                	jmp    801857 <strcconcat+0x49>
		final[s] = str1[s] ;
  801840:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801843:	8b 45 10             	mov    0x10(%ebp),%eax
  801846:	01 c2                	add    %eax,%edx
  801848:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80184b:	8b 45 08             	mov    0x8(%ebp),%eax
  80184e:	01 c8                	add    %ecx,%eax
  801850:	8a 00                	mov    (%eax),%al
  801852:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801854:	ff 45 fc             	incl   -0x4(%ebp)
  801857:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80185a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80185d:	7c e1                	jl     801840 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80185f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801866:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80186d:	eb 1f                	jmp    80188e <strcconcat+0x80>
		final[s++] = str2[i] ;
  80186f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801872:	8d 50 01             	lea    0x1(%eax),%edx
  801875:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801878:	89 c2                	mov    %eax,%edx
  80187a:	8b 45 10             	mov    0x10(%ebp),%eax
  80187d:	01 c2                	add    %eax,%edx
  80187f:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801882:	8b 45 0c             	mov    0xc(%ebp),%eax
  801885:	01 c8                	add    %ecx,%eax
  801887:	8a 00                	mov    (%eax),%al
  801889:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80188b:	ff 45 f8             	incl   -0x8(%ebp)
  80188e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801891:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801894:	7c d9                	jl     80186f <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801896:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801899:	8b 45 10             	mov    0x10(%ebp),%eax
  80189c:	01 d0                	add    %edx,%eax
  80189e:	c6 00 00             	movb   $0x0,(%eax)
}
  8018a1:	90                   	nop
  8018a2:	c9                   	leave  
  8018a3:	c3                   	ret    

008018a4 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8018a4:	55                   	push   %ebp
  8018a5:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8018a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8018aa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8018b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8018b3:	8b 00                	mov    (%eax),%eax
  8018b5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8018bf:	01 d0                	add    %edx,%eax
  8018c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8018c7:	eb 0c                	jmp    8018d5 <strsplit+0x31>
			*string++ = 0;
  8018c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cc:	8d 50 01             	lea    0x1(%eax),%edx
  8018cf:	89 55 08             	mov    %edx,0x8(%ebp)
  8018d2:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8018d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d8:	8a 00                	mov    (%eax),%al
  8018da:	84 c0                	test   %al,%al
  8018dc:	74 18                	je     8018f6 <strsplit+0x52>
  8018de:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e1:	8a 00                	mov    (%eax),%al
  8018e3:	0f be c0             	movsbl %al,%eax
  8018e6:	50                   	push   %eax
  8018e7:	ff 75 0c             	pushl  0xc(%ebp)
  8018ea:	e8 83 fa ff ff       	call   801372 <strchr>
  8018ef:	83 c4 08             	add    $0x8,%esp
  8018f2:	85 c0                	test   %eax,%eax
  8018f4:	75 d3                	jne    8018c9 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8018f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f9:	8a 00                	mov    (%eax),%al
  8018fb:	84 c0                	test   %al,%al
  8018fd:	74 5a                	je     801959 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8018ff:	8b 45 14             	mov    0x14(%ebp),%eax
  801902:	8b 00                	mov    (%eax),%eax
  801904:	83 f8 0f             	cmp    $0xf,%eax
  801907:	75 07                	jne    801910 <strsplit+0x6c>
		{
			return 0;
  801909:	b8 00 00 00 00       	mov    $0x0,%eax
  80190e:	eb 66                	jmp    801976 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801910:	8b 45 14             	mov    0x14(%ebp),%eax
  801913:	8b 00                	mov    (%eax),%eax
  801915:	8d 48 01             	lea    0x1(%eax),%ecx
  801918:	8b 55 14             	mov    0x14(%ebp),%edx
  80191b:	89 0a                	mov    %ecx,(%edx)
  80191d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801924:	8b 45 10             	mov    0x10(%ebp),%eax
  801927:	01 c2                	add    %eax,%edx
  801929:	8b 45 08             	mov    0x8(%ebp),%eax
  80192c:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80192e:	eb 03                	jmp    801933 <strsplit+0x8f>
			string++;
  801930:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801933:	8b 45 08             	mov    0x8(%ebp),%eax
  801936:	8a 00                	mov    (%eax),%al
  801938:	84 c0                	test   %al,%al
  80193a:	74 8b                	je     8018c7 <strsplit+0x23>
  80193c:	8b 45 08             	mov    0x8(%ebp),%eax
  80193f:	8a 00                	mov    (%eax),%al
  801941:	0f be c0             	movsbl %al,%eax
  801944:	50                   	push   %eax
  801945:	ff 75 0c             	pushl  0xc(%ebp)
  801948:	e8 25 fa ff ff       	call   801372 <strchr>
  80194d:	83 c4 08             	add    $0x8,%esp
  801950:	85 c0                	test   %eax,%eax
  801952:	74 dc                	je     801930 <strsplit+0x8c>
			string++;
	}
  801954:	e9 6e ff ff ff       	jmp    8018c7 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801959:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80195a:	8b 45 14             	mov    0x14(%ebp),%eax
  80195d:	8b 00                	mov    (%eax),%eax
  80195f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801966:	8b 45 10             	mov    0x10(%ebp),%eax
  801969:	01 d0                	add    %edx,%eax
  80196b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801971:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801976:	c9                   	leave  
  801977:	c3                   	ret    

00801978 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801978:	55                   	push   %ebp
  801979:	89 e5                	mov    %esp,%ebp
  80197b:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  80197e:	8b 45 08             	mov    0x8(%ebp),%eax
  801981:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801984:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80198b:	eb 4a                	jmp    8019d7 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  80198d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801990:	8b 45 08             	mov    0x8(%ebp),%eax
  801993:	01 c2                	add    %eax,%edx
  801995:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801998:	8b 45 0c             	mov    0xc(%ebp),%eax
  80199b:	01 c8                	add    %ecx,%eax
  80199d:	8a 00                	mov    (%eax),%al
  80199f:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8019a1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019a7:	01 d0                	add    %edx,%eax
  8019a9:	8a 00                	mov    (%eax),%al
  8019ab:	3c 40                	cmp    $0x40,%al
  8019ad:	7e 25                	jle    8019d4 <str2lower+0x5c>
  8019af:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019b5:	01 d0                	add    %edx,%eax
  8019b7:	8a 00                	mov    (%eax),%al
  8019b9:	3c 5a                	cmp    $0x5a,%al
  8019bb:	7f 17                	jg     8019d4 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8019bd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c3:	01 d0                	add    %edx,%eax
  8019c5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8019c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8019cb:	01 ca                	add    %ecx,%edx
  8019cd:	8a 12                	mov    (%edx),%dl
  8019cf:	83 c2 20             	add    $0x20,%edx
  8019d2:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8019d4:	ff 45 fc             	incl   -0x4(%ebp)
  8019d7:	ff 75 0c             	pushl  0xc(%ebp)
  8019da:	e8 01 f8 ff ff       	call   8011e0 <strlen>
  8019df:	83 c4 04             	add    $0x4,%esp
  8019e2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8019e5:	7f a6                	jg     80198d <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8019e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8019ea:	c9                   	leave  
  8019eb:	c3                   	ret    

008019ec <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  8019ec:	55                   	push   %ebp
  8019ed:	89 e5                	mov    %esp,%ebp
  8019ef:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  8019f2:	a1 08 40 80 00       	mov    0x804008,%eax
  8019f7:	85 c0                	test   %eax,%eax
  8019f9:	74 42                	je     801a3d <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  8019fb:	83 ec 08             	sub    $0x8,%esp
  8019fe:	68 00 00 00 82       	push   $0x82000000
  801a03:	68 00 00 00 80       	push   $0x80000000
  801a08:	e8 8c 07 00 00       	call   802199 <initialize_dynamic_allocator>
  801a0d:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801a10:	e8 e7 05 00 00       	call   801ffc <sys_get_uheap_strategy>
  801a15:	a3 60 c0 81 00       	mov    %eax,0x81c060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801a1a:	a1 40 40 80 00       	mov    0x804040,%eax
  801a1f:	05 00 10 00 00       	add    $0x1000,%eax
  801a24:	a3 10 c1 81 00       	mov    %eax,0x81c110
		uheapPageAllocBreak = uheapPageAllocStart;
  801a29:	a1 10 c1 81 00       	mov    0x81c110,%eax
  801a2e:	a3 68 c0 81 00       	mov    %eax,0x81c068

		__firstTimeFlag = 0;
  801a33:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  801a3a:	00 00 00 
	}
}
  801a3d:	90                   	nop
  801a3e:	c9                   	leave  
  801a3f:	c3                   	ret    

00801a40 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801a40:	55                   	push   %ebp
  801a41:	89 e5                	mov    %esp,%ebp
  801a43:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801a46:	8b 45 08             	mov    0x8(%ebp),%eax
  801a49:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a4f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a54:	83 ec 08             	sub    $0x8,%esp
  801a57:	68 06 04 00 00       	push   $0x406
  801a5c:	50                   	push   %eax
  801a5d:	e8 e4 01 00 00       	call   801c46 <__sys_allocate_page>
  801a62:	83 c4 10             	add    $0x10,%esp
  801a65:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801a68:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801a6c:	79 14                	jns    801a82 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801a6e:	83 ec 04             	sub    $0x4,%esp
  801a71:	68 68 2f 80 00       	push   $0x802f68
  801a76:	6a 1f                	push   $0x1f
  801a78:	68 a4 2f 80 00       	push   $0x802fa4
  801a7d:	e8 b7 ed ff ff       	call   800839 <_panic>
	return 0;
  801a82:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a87:	c9                   	leave  
  801a88:	c3                   	ret    

00801a89 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801a89:	55                   	push   %ebp
  801a8a:	89 e5                	mov    %esp,%ebp
  801a8c:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a92:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a98:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a9d:	83 ec 0c             	sub    $0xc,%esp
  801aa0:	50                   	push   %eax
  801aa1:	e8 e7 01 00 00       	call   801c8d <__sys_unmap_frame>
  801aa6:	83 c4 10             	add    $0x10,%esp
  801aa9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801aac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ab0:	79 14                	jns    801ac6 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801ab2:	83 ec 04             	sub    $0x4,%esp
  801ab5:	68 b0 2f 80 00       	push   $0x802fb0
  801aba:	6a 2a                	push   $0x2a
  801abc:	68 a4 2f 80 00       	push   $0x802fa4
  801ac1:	e8 73 ed ff ff       	call   800839 <_panic>
}
  801ac6:	90                   	nop
  801ac7:	c9                   	leave  
  801ac8:	c3                   	ret    

00801ac9 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801ac9:	55                   	push   %ebp
  801aca:	89 e5                	mov    %esp,%ebp
  801acc:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801acf:	e8 18 ff ff ff       	call   8019ec <uheap_init>
	if (size == 0) return NULL ;
  801ad4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ad8:	75 07                	jne    801ae1 <malloc+0x18>
  801ada:	b8 00 00 00 00       	mov    $0x0,%eax
  801adf:	eb 14                	jmp    801af5 <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  801ae1:	83 ec 04             	sub    $0x4,%esp
  801ae4:	68 f0 2f 80 00       	push   $0x802ff0
  801ae9:	6a 3e                	push   $0x3e
  801aeb:	68 a4 2f 80 00       	push   $0x802fa4
  801af0:	e8 44 ed ff ff       	call   800839 <_panic>
}
  801af5:	c9                   	leave  
  801af6:	c3                   	ret    

00801af7 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801af7:	55                   	push   %ebp
  801af8:	89 e5                	mov    %esp,%ebp
  801afa:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  801afd:	83 ec 04             	sub    $0x4,%esp
  801b00:	68 18 30 80 00       	push   $0x803018
  801b05:	6a 49                	push   $0x49
  801b07:	68 a4 2f 80 00       	push   $0x802fa4
  801b0c:	e8 28 ed ff ff       	call   800839 <_panic>

00801b11 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801b11:	55                   	push   %ebp
  801b12:	89 e5                	mov    %esp,%ebp
  801b14:	83 ec 18             	sub    $0x18,%esp
  801b17:	8b 45 10             	mov    0x10(%ebp),%eax
  801b1a:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801b1d:	e8 ca fe ff ff       	call   8019ec <uheap_init>
	if (size == 0) return NULL ;
  801b22:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801b26:	75 07                	jne    801b2f <smalloc+0x1e>
  801b28:	b8 00 00 00 00       	mov    $0x0,%eax
  801b2d:	eb 14                	jmp    801b43 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  801b2f:	83 ec 04             	sub    $0x4,%esp
  801b32:	68 3c 30 80 00       	push   $0x80303c
  801b37:	6a 5a                	push   $0x5a
  801b39:	68 a4 2f 80 00       	push   $0x802fa4
  801b3e:	e8 f6 ec ff ff       	call   800839 <_panic>
}
  801b43:	c9                   	leave  
  801b44:	c3                   	ret    

00801b45 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801b45:	55                   	push   %ebp
  801b46:	89 e5                	mov    %esp,%ebp
  801b48:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801b4b:	e8 9c fe ff ff       	call   8019ec <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  801b50:	83 ec 04             	sub    $0x4,%esp
  801b53:	68 64 30 80 00       	push   $0x803064
  801b58:	6a 6a                	push   $0x6a
  801b5a:	68 a4 2f 80 00       	push   $0x802fa4
  801b5f:	e8 d5 ec ff ff       	call   800839 <_panic>

00801b64 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801b64:	55                   	push   %ebp
  801b65:	89 e5                	mov    %esp,%ebp
  801b67:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801b6a:	e8 7d fe ff ff       	call   8019ec <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  801b6f:	83 ec 04             	sub    $0x4,%esp
  801b72:	68 88 30 80 00       	push   $0x803088
  801b77:	68 88 00 00 00       	push   $0x88
  801b7c:	68 a4 2f 80 00       	push   $0x802fa4
  801b81:	e8 b3 ec ff ff       	call   800839 <_panic>

00801b86 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  801b86:	55                   	push   %ebp
  801b87:	89 e5                	mov    %esp,%ebp
  801b89:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  801b8c:	83 ec 04             	sub    $0x4,%esp
  801b8f:	68 b0 30 80 00       	push   $0x8030b0
  801b94:	68 9b 00 00 00       	push   $0x9b
  801b99:	68 a4 2f 80 00       	push   $0x802fa4
  801b9e:	e8 96 ec ff ff       	call   800839 <_panic>

00801ba3 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801ba3:	55                   	push   %ebp
  801ba4:	89 e5                	mov    %esp,%ebp
  801ba6:	57                   	push   %edi
  801ba7:	56                   	push   %esi
  801ba8:	53                   	push   %ebx
  801ba9:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801bac:	8b 45 08             	mov    0x8(%ebp),%eax
  801baf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bb2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bb5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801bb8:	8b 7d 18             	mov    0x18(%ebp),%edi
  801bbb:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801bbe:	cd 30                	int    $0x30
  801bc0:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801bc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801bc6:	83 c4 10             	add    $0x10,%esp
  801bc9:	5b                   	pop    %ebx
  801bca:	5e                   	pop    %esi
  801bcb:	5f                   	pop    %edi
  801bcc:	5d                   	pop    %ebp
  801bcd:	c3                   	ret    

00801bce <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801bce:	55                   	push   %ebp
  801bcf:	89 e5                	mov    %esp,%ebp
  801bd1:	83 ec 04             	sub    $0x4,%esp
  801bd4:	8b 45 10             	mov    0x10(%ebp),%eax
  801bd7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801bda:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801bdd:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801be1:	8b 45 08             	mov    0x8(%ebp),%eax
  801be4:	6a 00                	push   $0x0
  801be6:	51                   	push   %ecx
  801be7:	52                   	push   %edx
  801be8:	ff 75 0c             	pushl  0xc(%ebp)
  801beb:	50                   	push   %eax
  801bec:	6a 00                	push   $0x0
  801bee:	e8 b0 ff ff ff       	call   801ba3 <syscall>
  801bf3:	83 c4 18             	add    $0x18,%esp
}
  801bf6:	90                   	nop
  801bf7:	c9                   	leave  
  801bf8:	c3                   	ret    

00801bf9 <sys_cgetc>:

int
sys_cgetc(void)
{
  801bf9:	55                   	push   %ebp
  801bfa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	6a 00                	push   $0x0
  801c04:	6a 00                	push   $0x0
  801c06:	6a 02                	push   $0x2
  801c08:	e8 96 ff ff ff       	call   801ba3 <syscall>
  801c0d:	83 c4 18             	add    $0x18,%esp
}
  801c10:	c9                   	leave  
  801c11:	c3                   	ret    

00801c12 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801c12:	55                   	push   %ebp
  801c13:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801c15:	6a 00                	push   $0x0
  801c17:	6a 00                	push   $0x0
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 03                	push   $0x3
  801c21:	e8 7d ff ff ff       	call   801ba3 <syscall>
  801c26:	83 c4 18             	add    $0x18,%esp
}
  801c29:	90                   	nop
  801c2a:	c9                   	leave  
  801c2b:	c3                   	ret    

00801c2c <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801c2c:	55                   	push   %ebp
  801c2d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 00                	push   $0x0
  801c33:	6a 00                	push   $0x0
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	6a 04                	push   $0x4
  801c3b:	e8 63 ff ff ff       	call   801ba3 <syscall>
  801c40:	83 c4 18             	add    $0x18,%esp
}
  801c43:	90                   	nop
  801c44:	c9                   	leave  
  801c45:	c3                   	ret    

00801c46 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801c46:	55                   	push   %ebp
  801c47:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801c49:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	52                   	push   %edx
  801c56:	50                   	push   %eax
  801c57:	6a 08                	push   $0x8
  801c59:	e8 45 ff ff ff       	call   801ba3 <syscall>
  801c5e:	83 c4 18             	add    $0x18,%esp
}
  801c61:	c9                   	leave  
  801c62:	c3                   	ret    

00801c63 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801c63:	55                   	push   %ebp
  801c64:	89 e5                	mov    %esp,%ebp
  801c66:	56                   	push   %esi
  801c67:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801c68:	8b 75 18             	mov    0x18(%ebp),%esi
  801c6b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c6e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c71:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c74:	8b 45 08             	mov    0x8(%ebp),%eax
  801c77:	56                   	push   %esi
  801c78:	53                   	push   %ebx
  801c79:	51                   	push   %ecx
  801c7a:	52                   	push   %edx
  801c7b:	50                   	push   %eax
  801c7c:	6a 09                	push   $0x9
  801c7e:	e8 20 ff ff ff       	call   801ba3 <syscall>
  801c83:	83 c4 18             	add    $0x18,%esp
}
  801c86:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c89:	5b                   	pop    %ebx
  801c8a:	5e                   	pop    %esi
  801c8b:	5d                   	pop    %ebp
  801c8c:	c3                   	ret    

00801c8d <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801c8d:	55                   	push   %ebp
  801c8e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801c90:	6a 00                	push   $0x0
  801c92:	6a 00                	push   $0x0
  801c94:	6a 00                	push   $0x0
  801c96:	6a 00                	push   $0x0
  801c98:	ff 75 08             	pushl  0x8(%ebp)
  801c9b:	6a 0a                	push   $0xa
  801c9d:	e8 01 ff ff ff       	call   801ba3 <syscall>
  801ca2:	83 c4 18             	add    $0x18,%esp
}
  801ca5:	c9                   	leave  
  801ca6:	c3                   	ret    

00801ca7 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801ca7:	55                   	push   %ebp
  801ca8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801caa:	6a 00                	push   $0x0
  801cac:	6a 00                	push   $0x0
  801cae:	6a 00                	push   $0x0
  801cb0:	ff 75 0c             	pushl  0xc(%ebp)
  801cb3:	ff 75 08             	pushl  0x8(%ebp)
  801cb6:	6a 0b                	push   $0xb
  801cb8:	e8 e6 fe ff ff       	call   801ba3 <syscall>
  801cbd:	83 c4 18             	add    $0x18,%esp
}
  801cc0:	c9                   	leave  
  801cc1:	c3                   	ret    

00801cc2 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801cc2:	55                   	push   %ebp
  801cc3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801cc5:	6a 00                	push   $0x0
  801cc7:	6a 00                	push   $0x0
  801cc9:	6a 00                	push   $0x0
  801ccb:	6a 00                	push   $0x0
  801ccd:	6a 00                	push   $0x0
  801ccf:	6a 0c                	push   $0xc
  801cd1:	e8 cd fe ff ff       	call   801ba3 <syscall>
  801cd6:	83 c4 18             	add    $0x18,%esp
}
  801cd9:	c9                   	leave  
  801cda:	c3                   	ret    

00801cdb <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801cdb:	55                   	push   %ebp
  801cdc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801cde:	6a 00                	push   $0x0
  801ce0:	6a 00                	push   $0x0
  801ce2:	6a 00                	push   $0x0
  801ce4:	6a 00                	push   $0x0
  801ce6:	6a 00                	push   $0x0
  801ce8:	6a 0d                	push   $0xd
  801cea:	e8 b4 fe ff ff       	call   801ba3 <syscall>
  801cef:	83 c4 18             	add    $0x18,%esp
}
  801cf2:	c9                   	leave  
  801cf3:	c3                   	ret    

00801cf4 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801cf4:	55                   	push   %ebp
  801cf5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801cf7:	6a 00                	push   $0x0
  801cf9:	6a 00                	push   $0x0
  801cfb:	6a 00                	push   $0x0
  801cfd:	6a 00                	push   $0x0
  801cff:	6a 00                	push   $0x0
  801d01:	6a 0e                	push   $0xe
  801d03:	e8 9b fe ff ff       	call   801ba3 <syscall>
  801d08:	83 c4 18             	add    $0x18,%esp
}
  801d0b:	c9                   	leave  
  801d0c:	c3                   	ret    

00801d0d <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801d0d:	55                   	push   %ebp
  801d0e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801d10:	6a 00                	push   $0x0
  801d12:	6a 00                	push   $0x0
  801d14:	6a 00                	push   $0x0
  801d16:	6a 00                	push   $0x0
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 0f                	push   $0xf
  801d1c:	e8 82 fe ff ff       	call   801ba3 <syscall>
  801d21:	83 c4 18             	add    $0x18,%esp
}
  801d24:	c9                   	leave  
  801d25:	c3                   	ret    

00801d26 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801d26:	55                   	push   %ebp
  801d27:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801d29:	6a 00                	push   $0x0
  801d2b:	6a 00                	push   $0x0
  801d2d:	6a 00                	push   $0x0
  801d2f:	6a 00                	push   $0x0
  801d31:	ff 75 08             	pushl  0x8(%ebp)
  801d34:	6a 10                	push   $0x10
  801d36:	e8 68 fe ff ff       	call   801ba3 <syscall>
  801d3b:	83 c4 18             	add    $0x18,%esp
}
  801d3e:	c9                   	leave  
  801d3f:	c3                   	ret    

00801d40 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801d40:	55                   	push   %ebp
  801d41:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801d43:	6a 00                	push   $0x0
  801d45:	6a 00                	push   $0x0
  801d47:	6a 00                	push   $0x0
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 00                	push   $0x0
  801d4d:	6a 11                	push   $0x11
  801d4f:	e8 4f fe ff ff       	call   801ba3 <syscall>
  801d54:	83 c4 18             	add    $0x18,%esp
}
  801d57:	90                   	nop
  801d58:	c9                   	leave  
  801d59:	c3                   	ret    

00801d5a <sys_cputc>:

void
sys_cputc(const char c)
{
  801d5a:	55                   	push   %ebp
  801d5b:	89 e5                	mov    %esp,%ebp
  801d5d:	83 ec 04             	sub    $0x4,%esp
  801d60:	8b 45 08             	mov    0x8(%ebp),%eax
  801d63:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801d66:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d6a:	6a 00                	push   $0x0
  801d6c:	6a 00                	push   $0x0
  801d6e:	6a 00                	push   $0x0
  801d70:	6a 00                	push   $0x0
  801d72:	50                   	push   %eax
  801d73:	6a 01                	push   $0x1
  801d75:	e8 29 fe ff ff       	call   801ba3 <syscall>
  801d7a:	83 c4 18             	add    $0x18,%esp
}
  801d7d:	90                   	nop
  801d7e:	c9                   	leave  
  801d7f:	c3                   	ret    

00801d80 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801d80:	55                   	push   %ebp
  801d81:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801d83:	6a 00                	push   $0x0
  801d85:	6a 00                	push   $0x0
  801d87:	6a 00                	push   $0x0
  801d89:	6a 00                	push   $0x0
  801d8b:	6a 00                	push   $0x0
  801d8d:	6a 14                	push   $0x14
  801d8f:	e8 0f fe ff ff       	call   801ba3 <syscall>
  801d94:	83 c4 18             	add    $0x18,%esp
}
  801d97:	90                   	nop
  801d98:	c9                   	leave  
  801d99:	c3                   	ret    

00801d9a <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801d9a:	55                   	push   %ebp
  801d9b:	89 e5                	mov    %esp,%ebp
  801d9d:	83 ec 04             	sub    $0x4,%esp
  801da0:	8b 45 10             	mov    0x10(%ebp),%eax
  801da3:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801da6:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801da9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801dad:	8b 45 08             	mov    0x8(%ebp),%eax
  801db0:	6a 00                	push   $0x0
  801db2:	51                   	push   %ecx
  801db3:	52                   	push   %edx
  801db4:	ff 75 0c             	pushl  0xc(%ebp)
  801db7:	50                   	push   %eax
  801db8:	6a 15                	push   $0x15
  801dba:	e8 e4 fd ff ff       	call   801ba3 <syscall>
  801dbf:	83 c4 18             	add    $0x18,%esp
}
  801dc2:	c9                   	leave  
  801dc3:	c3                   	ret    

00801dc4 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801dc4:	55                   	push   %ebp
  801dc5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801dc7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dca:	8b 45 08             	mov    0x8(%ebp),%eax
  801dcd:	6a 00                	push   $0x0
  801dcf:	6a 00                	push   $0x0
  801dd1:	6a 00                	push   $0x0
  801dd3:	52                   	push   %edx
  801dd4:	50                   	push   %eax
  801dd5:	6a 16                	push   $0x16
  801dd7:	e8 c7 fd ff ff       	call   801ba3 <syscall>
  801ddc:	83 c4 18             	add    $0x18,%esp
}
  801ddf:	c9                   	leave  
  801de0:	c3                   	ret    

00801de1 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801de1:	55                   	push   %ebp
  801de2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801de4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801de7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dea:	8b 45 08             	mov    0x8(%ebp),%eax
  801ded:	6a 00                	push   $0x0
  801def:	6a 00                	push   $0x0
  801df1:	51                   	push   %ecx
  801df2:	52                   	push   %edx
  801df3:	50                   	push   %eax
  801df4:	6a 17                	push   $0x17
  801df6:	e8 a8 fd ff ff       	call   801ba3 <syscall>
  801dfb:	83 c4 18             	add    $0x18,%esp
}
  801dfe:	c9                   	leave  
  801dff:	c3                   	ret    

00801e00 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801e00:	55                   	push   %ebp
  801e01:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801e03:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e06:	8b 45 08             	mov    0x8(%ebp),%eax
  801e09:	6a 00                	push   $0x0
  801e0b:	6a 00                	push   $0x0
  801e0d:	6a 00                	push   $0x0
  801e0f:	52                   	push   %edx
  801e10:	50                   	push   %eax
  801e11:	6a 18                	push   $0x18
  801e13:	e8 8b fd ff ff       	call   801ba3 <syscall>
  801e18:	83 c4 18             	add    $0x18,%esp
}
  801e1b:	c9                   	leave  
  801e1c:	c3                   	ret    

00801e1d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801e1d:	55                   	push   %ebp
  801e1e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801e20:	8b 45 08             	mov    0x8(%ebp),%eax
  801e23:	6a 00                	push   $0x0
  801e25:	ff 75 14             	pushl  0x14(%ebp)
  801e28:	ff 75 10             	pushl  0x10(%ebp)
  801e2b:	ff 75 0c             	pushl  0xc(%ebp)
  801e2e:	50                   	push   %eax
  801e2f:	6a 19                	push   $0x19
  801e31:	e8 6d fd ff ff       	call   801ba3 <syscall>
  801e36:	83 c4 18             	add    $0x18,%esp
}
  801e39:	c9                   	leave  
  801e3a:	c3                   	ret    

00801e3b <sys_run_env>:

void sys_run_env(int32 envId)
{
  801e3b:	55                   	push   %ebp
  801e3c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801e3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e41:	6a 00                	push   $0x0
  801e43:	6a 00                	push   $0x0
  801e45:	6a 00                	push   $0x0
  801e47:	6a 00                	push   $0x0
  801e49:	50                   	push   %eax
  801e4a:	6a 1a                	push   $0x1a
  801e4c:	e8 52 fd ff ff       	call   801ba3 <syscall>
  801e51:	83 c4 18             	add    $0x18,%esp
}
  801e54:	90                   	nop
  801e55:	c9                   	leave  
  801e56:	c3                   	ret    

00801e57 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801e57:	55                   	push   %ebp
  801e58:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801e5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5d:	6a 00                	push   $0x0
  801e5f:	6a 00                	push   $0x0
  801e61:	6a 00                	push   $0x0
  801e63:	6a 00                	push   $0x0
  801e65:	50                   	push   %eax
  801e66:	6a 1b                	push   $0x1b
  801e68:	e8 36 fd ff ff       	call   801ba3 <syscall>
  801e6d:	83 c4 18             	add    $0x18,%esp
}
  801e70:	c9                   	leave  
  801e71:	c3                   	ret    

00801e72 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801e72:	55                   	push   %ebp
  801e73:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801e75:	6a 00                	push   $0x0
  801e77:	6a 00                	push   $0x0
  801e79:	6a 00                	push   $0x0
  801e7b:	6a 00                	push   $0x0
  801e7d:	6a 00                	push   $0x0
  801e7f:	6a 05                	push   $0x5
  801e81:	e8 1d fd ff ff       	call   801ba3 <syscall>
  801e86:	83 c4 18             	add    $0x18,%esp
}
  801e89:	c9                   	leave  
  801e8a:	c3                   	ret    

00801e8b <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801e8b:	55                   	push   %ebp
  801e8c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801e8e:	6a 00                	push   $0x0
  801e90:	6a 00                	push   $0x0
  801e92:	6a 00                	push   $0x0
  801e94:	6a 00                	push   $0x0
  801e96:	6a 00                	push   $0x0
  801e98:	6a 06                	push   $0x6
  801e9a:	e8 04 fd ff ff       	call   801ba3 <syscall>
  801e9f:	83 c4 18             	add    $0x18,%esp
}
  801ea2:	c9                   	leave  
  801ea3:	c3                   	ret    

00801ea4 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801ea4:	55                   	push   %ebp
  801ea5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801ea7:	6a 00                	push   $0x0
  801ea9:	6a 00                	push   $0x0
  801eab:	6a 00                	push   $0x0
  801ead:	6a 00                	push   $0x0
  801eaf:	6a 00                	push   $0x0
  801eb1:	6a 07                	push   $0x7
  801eb3:	e8 eb fc ff ff       	call   801ba3 <syscall>
  801eb8:	83 c4 18             	add    $0x18,%esp
}
  801ebb:	c9                   	leave  
  801ebc:	c3                   	ret    

00801ebd <sys_exit_env>:


void sys_exit_env(void)
{
  801ebd:	55                   	push   %ebp
  801ebe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801ec0:	6a 00                	push   $0x0
  801ec2:	6a 00                	push   $0x0
  801ec4:	6a 00                	push   $0x0
  801ec6:	6a 00                	push   $0x0
  801ec8:	6a 00                	push   $0x0
  801eca:	6a 1c                	push   $0x1c
  801ecc:	e8 d2 fc ff ff       	call   801ba3 <syscall>
  801ed1:	83 c4 18             	add    $0x18,%esp
}
  801ed4:	90                   	nop
  801ed5:	c9                   	leave  
  801ed6:	c3                   	ret    

00801ed7 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801ed7:	55                   	push   %ebp
  801ed8:	89 e5                	mov    %esp,%ebp
  801eda:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801edd:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ee0:	8d 50 04             	lea    0x4(%eax),%edx
  801ee3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ee6:	6a 00                	push   $0x0
  801ee8:	6a 00                	push   $0x0
  801eea:	6a 00                	push   $0x0
  801eec:	52                   	push   %edx
  801eed:	50                   	push   %eax
  801eee:	6a 1d                	push   $0x1d
  801ef0:	e8 ae fc ff ff       	call   801ba3 <syscall>
  801ef5:	83 c4 18             	add    $0x18,%esp
	return result;
  801ef8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801efb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801efe:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f01:	89 01                	mov    %eax,(%ecx)
  801f03:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801f06:	8b 45 08             	mov    0x8(%ebp),%eax
  801f09:	c9                   	leave  
  801f0a:	c2 04 00             	ret    $0x4

00801f0d <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801f0d:	55                   	push   %ebp
  801f0e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801f10:	6a 00                	push   $0x0
  801f12:	6a 00                	push   $0x0
  801f14:	ff 75 10             	pushl  0x10(%ebp)
  801f17:	ff 75 0c             	pushl  0xc(%ebp)
  801f1a:	ff 75 08             	pushl  0x8(%ebp)
  801f1d:	6a 13                	push   $0x13
  801f1f:	e8 7f fc ff ff       	call   801ba3 <syscall>
  801f24:	83 c4 18             	add    $0x18,%esp
	return ;
  801f27:	90                   	nop
}
  801f28:	c9                   	leave  
  801f29:	c3                   	ret    

00801f2a <sys_rcr2>:
uint32 sys_rcr2()
{
  801f2a:	55                   	push   %ebp
  801f2b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801f2d:	6a 00                	push   $0x0
  801f2f:	6a 00                	push   $0x0
  801f31:	6a 00                	push   $0x0
  801f33:	6a 00                	push   $0x0
  801f35:	6a 00                	push   $0x0
  801f37:	6a 1e                	push   $0x1e
  801f39:	e8 65 fc ff ff       	call   801ba3 <syscall>
  801f3e:	83 c4 18             	add    $0x18,%esp
}
  801f41:	c9                   	leave  
  801f42:	c3                   	ret    

00801f43 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801f43:	55                   	push   %ebp
  801f44:	89 e5                	mov    %esp,%ebp
  801f46:	83 ec 04             	sub    $0x4,%esp
  801f49:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801f4f:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801f53:	6a 00                	push   $0x0
  801f55:	6a 00                	push   $0x0
  801f57:	6a 00                	push   $0x0
  801f59:	6a 00                	push   $0x0
  801f5b:	50                   	push   %eax
  801f5c:	6a 1f                	push   $0x1f
  801f5e:	e8 40 fc ff ff       	call   801ba3 <syscall>
  801f63:	83 c4 18             	add    $0x18,%esp
	return ;
  801f66:	90                   	nop
}
  801f67:	c9                   	leave  
  801f68:	c3                   	ret    

00801f69 <rsttst>:
void rsttst()
{
  801f69:	55                   	push   %ebp
  801f6a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801f6c:	6a 00                	push   $0x0
  801f6e:	6a 00                	push   $0x0
  801f70:	6a 00                	push   $0x0
  801f72:	6a 00                	push   $0x0
  801f74:	6a 00                	push   $0x0
  801f76:	6a 21                	push   $0x21
  801f78:	e8 26 fc ff ff       	call   801ba3 <syscall>
  801f7d:	83 c4 18             	add    $0x18,%esp
	return ;
  801f80:	90                   	nop
}
  801f81:	c9                   	leave  
  801f82:	c3                   	ret    

00801f83 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801f83:	55                   	push   %ebp
  801f84:	89 e5                	mov    %esp,%ebp
  801f86:	83 ec 04             	sub    $0x4,%esp
  801f89:	8b 45 14             	mov    0x14(%ebp),%eax
  801f8c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801f8f:	8b 55 18             	mov    0x18(%ebp),%edx
  801f92:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f96:	52                   	push   %edx
  801f97:	50                   	push   %eax
  801f98:	ff 75 10             	pushl  0x10(%ebp)
  801f9b:	ff 75 0c             	pushl  0xc(%ebp)
  801f9e:	ff 75 08             	pushl  0x8(%ebp)
  801fa1:	6a 20                	push   $0x20
  801fa3:	e8 fb fb ff ff       	call   801ba3 <syscall>
  801fa8:	83 c4 18             	add    $0x18,%esp
	return ;
  801fab:	90                   	nop
}
  801fac:	c9                   	leave  
  801fad:	c3                   	ret    

00801fae <chktst>:
void chktst(uint32 n)
{
  801fae:	55                   	push   %ebp
  801faf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801fb1:	6a 00                	push   $0x0
  801fb3:	6a 00                	push   $0x0
  801fb5:	6a 00                	push   $0x0
  801fb7:	6a 00                	push   $0x0
  801fb9:	ff 75 08             	pushl  0x8(%ebp)
  801fbc:	6a 22                	push   $0x22
  801fbe:	e8 e0 fb ff ff       	call   801ba3 <syscall>
  801fc3:	83 c4 18             	add    $0x18,%esp
	return ;
  801fc6:	90                   	nop
}
  801fc7:	c9                   	leave  
  801fc8:	c3                   	ret    

00801fc9 <inctst>:

void inctst()
{
  801fc9:	55                   	push   %ebp
  801fca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801fcc:	6a 00                	push   $0x0
  801fce:	6a 00                	push   $0x0
  801fd0:	6a 00                	push   $0x0
  801fd2:	6a 00                	push   $0x0
  801fd4:	6a 00                	push   $0x0
  801fd6:	6a 23                	push   $0x23
  801fd8:	e8 c6 fb ff ff       	call   801ba3 <syscall>
  801fdd:	83 c4 18             	add    $0x18,%esp
	return ;
  801fe0:	90                   	nop
}
  801fe1:	c9                   	leave  
  801fe2:	c3                   	ret    

00801fe3 <gettst>:
uint32 gettst()
{
  801fe3:	55                   	push   %ebp
  801fe4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801fe6:	6a 00                	push   $0x0
  801fe8:	6a 00                	push   $0x0
  801fea:	6a 00                	push   $0x0
  801fec:	6a 00                	push   $0x0
  801fee:	6a 00                	push   $0x0
  801ff0:	6a 24                	push   $0x24
  801ff2:	e8 ac fb ff ff       	call   801ba3 <syscall>
  801ff7:	83 c4 18             	add    $0x18,%esp
}
  801ffa:	c9                   	leave  
  801ffb:	c3                   	ret    

00801ffc <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801ffc:	55                   	push   %ebp
  801ffd:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fff:	6a 00                	push   $0x0
  802001:	6a 00                	push   $0x0
  802003:	6a 00                	push   $0x0
  802005:	6a 00                	push   $0x0
  802007:	6a 00                	push   $0x0
  802009:	6a 25                	push   $0x25
  80200b:	e8 93 fb ff ff       	call   801ba3 <syscall>
  802010:	83 c4 18             	add    $0x18,%esp
  802013:	a3 60 c0 81 00       	mov    %eax,0x81c060
	return uheapPlaceStrategy ;
  802018:	a1 60 c0 81 00       	mov    0x81c060,%eax
}
  80201d:	c9                   	leave  
  80201e:	c3                   	ret    

0080201f <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80201f:	55                   	push   %ebp
  802020:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  802022:	8b 45 08             	mov    0x8(%ebp),%eax
  802025:	a3 60 c0 81 00       	mov    %eax,0x81c060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80202a:	6a 00                	push   $0x0
  80202c:	6a 00                	push   $0x0
  80202e:	6a 00                	push   $0x0
  802030:	6a 00                	push   $0x0
  802032:	ff 75 08             	pushl  0x8(%ebp)
  802035:	6a 26                	push   $0x26
  802037:	e8 67 fb ff ff       	call   801ba3 <syscall>
  80203c:	83 c4 18             	add    $0x18,%esp
	return ;
  80203f:	90                   	nop
}
  802040:	c9                   	leave  
  802041:	c3                   	ret    

00802042 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802042:	55                   	push   %ebp
  802043:	89 e5                	mov    %esp,%ebp
  802045:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802046:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802049:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80204c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80204f:	8b 45 08             	mov    0x8(%ebp),%eax
  802052:	6a 00                	push   $0x0
  802054:	53                   	push   %ebx
  802055:	51                   	push   %ecx
  802056:	52                   	push   %edx
  802057:	50                   	push   %eax
  802058:	6a 27                	push   $0x27
  80205a:	e8 44 fb ff ff       	call   801ba3 <syscall>
  80205f:	83 c4 18             	add    $0x18,%esp
}
  802062:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802065:	c9                   	leave  
  802066:	c3                   	ret    

00802067 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802067:	55                   	push   %ebp
  802068:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80206a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80206d:	8b 45 08             	mov    0x8(%ebp),%eax
  802070:	6a 00                	push   $0x0
  802072:	6a 00                	push   $0x0
  802074:	6a 00                	push   $0x0
  802076:	52                   	push   %edx
  802077:	50                   	push   %eax
  802078:	6a 28                	push   $0x28
  80207a:	e8 24 fb ff ff       	call   801ba3 <syscall>
  80207f:	83 c4 18             	add    $0x18,%esp
}
  802082:	c9                   	leave  
  802083:	c3                   	ret    

00802084 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802084:	55                   	push   %ebp
  802085:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802087:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80208a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80208d:	8b 45 08             	mov    0x8(%ebp),%eax
  802090:	6a 00                	push   $0x0
  802092:	51                   	push   %ecx
  802093:	ff 75 10             	pushl  0x10(%ebp)
  802096:	52                   	push   %edx
  802097:	50                   	push   %eax
  802098:	6a 29                	push   $0x29
  80209a:	e8 04 fb ff ff       	call   801ba3 <syscall>
  80209f:	83 c4 18             	add    $0x18,%esp
}
  8020a2:	c9                   	leave  
  8020a3:	c3                   	ret    

008020a4 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8020a4:	55                   	push   %ebp
  8020a5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8020a7:	6a 00                	push   $0x0
  8020a9:	6a 00                	push   $0x0
  8020ab:	ff 75 10             	pushl  0x10(%ebp)
  8020ae:	ff 75 0c             	pushl  0xc(%ebp)
  8020b1:	ff 75 08             	pushl  0x8(%ebp)
  8020b4:	6a 12                	push   $0x12
  8020b6:	e8 e8 fa ff ff       	call   801ba3 <syscall>
  8020bb:	83 c4 18             	add    $0x18,%esp
	return ;
  8020be:	90                   	nop
}
  8020bf:	c9                   	leave  
  8020c0:	c3                   	ret    

008020c1 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8020c1:	55                   	push   %ebp
  8020c2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8020c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ca:	6a 00                	push   $0x0
  8020cc:	6a 00                	push   $0x0
  8020ce:	6a 00                	push   $0x0
  8020d0:	52                   	push   %edx
  8020d1:	50                   	push   %eax
  8020d2:	6a 2a                	push   $0x2a
  8020d4:	e8 ca fa ff ff       	call   801ba3 <syscall>
  8020d9:	83 c4 18             	add    $0x18,%esp
	return;
  8020dc:	90                   	nop
}
  8020dd:	c9                   	leave  
  8020de:	c3                   	ret    

008020df <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8020df:	55                   	push   %ebp
  8020e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8020e2:	6a 00                	push   $0x0
  8020e4:	6a 00                	push   $0x0
  8020e6:	6a 00                	push   $0x0
  8020e8:	6a 00                	push   $0x0
  8020ea:	6a 00                	push   $0x0
  8020ec:	6a 2b                	push   $0x2b
  8020ee:	e8 b0 fa ff ff       	call   801ba3 <syscall>
  8020f3:	83 c4 18             	add    $0x18,%esp
}
  8020f6:	c9                   	leave  
  8020f7:	c3                   	ret    

008020f8 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8020f8:	55                   	push   %ebp
  8020f9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8020fb:	6a 00                	push   $0x0
  8020fd:	6a 00                	push   $0x0
  8020ff:	6a 00                	push   $0x0
  802101:	ff 75 0c             	pushl  0xc(%ebp)
  802104:	ff 75 08             	pushl  0x8(%ebp)
  802107:	6a 2d                	push   $0x2d
  802109:	e8 95 fa ff ff       	call   801ba3 <syscall>
  80210e:	83 c4 18             	add    $0x18,%esp
	return;
  802111:	90                   	nop
}
  802112:	c9                   	leave  
  802113:	c3                   	ret    

00802114 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802114:	55                   	push   %ebp
  802115:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802117:	6a 00                	push   $0x0
  802119:	6a 00                	push   $0x0
  80211b:	6a 00                	push   $0x0
  80211d:	ff 75 0c             	pushl  0xc(%ebp)
  802120:	ff 75 08             	pushl  0x8(%ebp)
  802123:	6a 2c                	push   $0x2c
  802125:	e8 79 fa ff ff       	call   801ba3 <syscall>
  80212a:	83 c4 18             	add    $0x18,%esp
	return ;
  80212d:	90                   	nop
}
  80212e:	c9                   	leave  
  80212f:	c3                   	ret    

00802130 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  802130:	55                   	push   %ebp
  802131:	89 e5                	mov    %esp,%ebp
  802133:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  802136:	83 ec 04             	sub    $0x4,%esp
  802139:	68 d4 30 80 00       	push   $0x8030d4
  80213e:	68 25 01 00 00       	push   $0x125
  802143:	68 07 31 80 00       	push   $0x803107
  802148:	e8 ec e6 ff ff       	call   800839 <_panic>

0080214d <to_page_va>:
//==================================================================================//
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  80214d:	55                   	push   %ebp
  80214e:	89 e5                	mov    %esp,%ebp
  802150:	83 ec 10             	sub    $0x10,%esp
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  802153:	8b 45 08             	mov    0x8(%ebp),%eax
  802156:	ba 60 40 80 00       	mov    $0x804060,%edx
  80215b:	29 d0                	sub    %edx,%eax
  80215d:	c1 f8 02             	sar    $0x2,%eax
  802160:	89 c2                	mov    %eax,%edx
  802162:	89 d0                	mov    %edx,%eax
  802164:	c1 e0 02             	shl    $0x2,%eax
  802167:	01 d0                	add    %edx,%eax
  802169:	c1 e0 02             	shl    $0x2,%eax
  80216c:	01 d0                	add    %edx,%eax
  80216e:	c1 e0 02             	shl    $0x2,%eax
  802171:	01 d0                	add    %edx,%eax
  802173:	89 c1                	mov    %eax,%ecx
  802175:	c1 e1 08             	shl    $0x8,%ecx
  802178:	01 c8                	add    %ecx,%eax
  80217a:	89 c1                	mov    %eax,%ecx
  80217c:	c1 e1 10             	shl    $0x10,%ecx
  80217f:	01 c8                	add    %ecx,%eax
  802181:	01 c0                	add    %eax,%eax
  802183:	01 d0                	add    %edx,%eax
  802185:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  802188:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80218b:	c1 e0 0c             	shl    $0xc,%eax
  80218e:	89 c2                	mov    %eax,%edx
  802190:	a1 64 c0 81 00       	mov    0x81c064,%eax
  802195:	01 d0                	add    %edx,%eax
}
  802197:	c9                   	leave  
  802198:	c3                   	ret    

00802199 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  802199:	55                   	push   %ebp
  80219a:	89 e5                	mov    %esp,%ebp
  80219c:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  80219f:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a2:	05 00 00 00 02       	add    $0x2000000,%eax
  8021a7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8021aa:	73 16                	jae    8021c2 <initialize_dynamic_allocator+0x29>
  8021ac:	68 18 31 80 00       	push   $0x803118
  8021b1:	68 3e 31 80 00       	push   $0x80313e
  8021b6:	6a 26                	push   $0x26
  8021b8:	68 53 31 80 00       	push   $0x803153
  8021bd:	e8 77 e6 ff ff       	call   800839 <_panic>
		is_initialized = 1;
  8021c2:	c7 05 24 40 80 00 01 	movl   $0x1,0x804024
  8021c9:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	//Comment the following line
	panic("initialize_dynamic_allocator() Not implemented yet");
  8021cc:	83 ec 04             	sub    $0x4,%esp
  8021cf:	68 6c 31 80 00       	push   $0x80316c
  8021d4:	6a 2e                	push   $0x2e
  8021d6:	68 53 31 80 00       	push   $0x803153
  8021db:	e8 59 e6 ff ff       	call   800839 <_panic>

008021e0 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  8021e0:	55                   	push   %ebp
  8021e1:	89 e5                	mov    %esp,%ebp
  8021e3:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	//Comment the following line
	panic("get_block_size() Not implemented yet");
  8021e6:	83 ec 04             	sub    $0x4,%esp
  8021e9:	68 a0 31 80 00       	push   $0x8031a0
  8021ee:	6a 3a                	push   $0x3a
  8021f0:	68 53 31 80 00       	push   $0x803153
  8021f5:	e8 3f e6 ff ff       	call   800839 <_panic>

008021fa <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  8021fa:	55                   	push   %ebp
  8021fb:	89 e5                	mov    %esp,%ebp
  8021fd:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  802200:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802207:	76 16                	jbe    80221f <alloc_block+0x25>
  802209:	68 c8 31 80 00       	push   $0x8031c8
  80220e:	68 3e 31 80 00       	push   $0x80313e
  802213:	6a 46                	push   $0x46
  802215:	68 53 31 80 00       	push   $0x803153
  80221a:	e8 1a e6 ff ff       	call   800839 <_panic>
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	panic("alloc_block() Not implemented yet");
  80221f:	83 ec 04             	sub    $0x4,%esp
  802222:	68 ec 31 80 00       	push   $0x8031ec
  802227:	6a 4d                	push   $0x4d
  802229:	68 53 31 80 00       	push   $0x803153
  80222e:	e8 06 e6 ff ff       	call   800839 <_panic>

00802233 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  802233:	55                   	push   %ebp
  802234:	89 e5                	mov    %esp,%ebp
  802236:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  802239:	8b 55 08             	mov    0x8(%ebp),%edx
  80223c:	a1 64 c0 81 00       	mov    0x81c064,%eax
  802241:	39 c2                	cmp    %eax,%edx
  802243:	72 0c                	jb     802251 <free_block+0x1e>
  802245:	8b 55 08             	mov    0x8(%ebp),%edx
  802248:	a1 40 40 80 00       	mov    0x804040,%eax
  80224d:	39 c2                	cmp    %eax,%edx
  80224f:	72 16                	jb     802267 <free_block+0x34>
  802251:	68 10 32 80 00       	push   $0x803210
  802256:	68 3e 31 80 00       	push   $0x80313e
  80225b:	6a 5b                	push   $0x5b
  80225d:	68 53 31 80 00       	push   $0x803153
  802262:	e8 d2 e5 ff ff       	call   800839 <_panic>
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	panic("free_block() Not implemented yet");
  802267:	83 ec 04             	sub    $0x4,%esp
  80226a:	68 48 32 80 00       	push   $0x803248
  80226f:	6a 63                	push   $0x63
  802271:	68 53 31 80 00       	push   $0x803153
  802276:	e8 be e5 ff ff       	call   800839 <_panic>

0080227b <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  80227b:	55                   	push   %ebp
  80227c:	89 e5                	mov    %esp,%ebp
  80227e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  802281:	83 ec 04             	sub    $0x4,%esp
  802284:	68 6c 32 80 00       	push   $0x80326c
  802289:	6a 72                	push   $0x72
  80228b:	68 53 31 80 00       	push   $0x803153
  802290:	e8 a4 e5 ff ff       	call   800839 <_panic>
  802295:	66 90                	xchg   %ax,%ax
  802297:	90                   	nop

00802298 <__udivdi3>:
  802298:	55                   	push   %ebp
  802299:	57                   	push   %edi
  80229a:	56                   	push   %esi
  80229b:	53                   	push   %ebx
  80229c:	83 ec 1c             	sub    $0x1c,%esp
  80229f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8022a3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8022a7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8022ab:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8022af:	89 ca                	mov    %ecx,%edx
  8022b1:	89 f8                	mov    %edi,%eax
  8022b3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8022b7:	85 f6                	test   %esi,%esi
  8022b9:	75 2d                	jne    8022e8 <__udivdi3+0x50>
  8022bb:	39 cf                	cmp    %ecx,%edi
  8022bd:	77 65                	ja     802324 <__udivdi3+0x8c>
  8022bf:	89 fd                	mov    %edi,%ebp
  8022c1:	85 ff                	test   %edi,%edi
  8022c3:	75 0b                	jne    8022d0 <__udivdi3+0x38>
  8022c5:	b8 01 00 00 00       	mov    $0x1,%eax
  8022ca:	31 d2                	xor    %edx,%edx
  8022cc:	f7 f7                	div    %edi
  8022ce:	89 c5                	mov    %eax,%ebp
  8022d0:	31 d2                	xor    %edx,%edx
  8022d2:	89 c8                	mov    %ecx,%eax
  8022d4:	f7 f5                	div    %ebp
  8022d6:	89 c1                	mov    %eax,%ecx
  8022d8:	89 d8                	mov    %ebx,%eax
  8022da:	f7 f5                	div    %ebp
  8022dc:	89 cf                	mov    %ecx,%edi
  8022de:	89 fa                	mov    %edi,%edx
  8022e0:	83 c4 1c             	add    $0x1c,%esp
  8022e3:	5b                   	pop    %ebx
  8022e4:	5e                   	pop    %esi
  8022e5:	5f                   	pop    %edi
  8022e6:	5d                   	pop    %ebp
  8022e7:	c3                   	ret    
  8022e8:	39 ce                	cmp    %ecx,%esi
  8022ea:	77 28                	ja     802314 <__udivdi3+0x7c>
  8022ec:	0f bd fe             	bsr    %esi,%edi
  8022ef:	83 f7 1f             	xor    $0x1f,%edi
  8022f2:	75 40                	jne    802334 <__udivdi3+0x9c>
  8022f4:	39 ce                	cmp    %ecx,%esi
  8022f6:	72 0a                	jb     802302 <__udivdi3+0x6a>
  8022f8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8022fc:	0f 87 9e 00 00 00    	ja     8023a0 <__udivdi3+0x108>
  802302:	b8 01 00 00 00       	mov    $0x1,%eax
  802307:	89 fa                	mov    %edi,%edx
  802309:	83 c4 1c             	add    $0x1c,%esp
  80230c:	5b                   	pop    %ebx
  80230d:	5e                   	pop    %esi
  80230e:	5f                   	pop    %edi
  80230f:	5d                   	pop    %ebp
  802310:	c3                   	ret    
  802311:	8d 76 00             	lea    0x0(%esi),%esi
  802314:	31 ff                	xor    %edi,%edi
  802316:	31 c0                	xor    %eax,%eax
  802318:	89 fa                	mov    %edi,%edx
  80231a:	83 c4 1c             	add    $0x1c,%esp
  80231d:	5b                   	pop    %ebx
  80231e:	5e                   	pop    %esi
  80231f:	5f                   	pop    %edi
  802320:	5d                   	pop    %ebp
  802321:	c3                   	ret    
  802322:	66 90                	xchg   %ax,%ax
  802324:	89 d8                	mov    %ebx,%eax
  802326:	f7 f7                	div    %edi
  802328:	31 ff                	xor    %edi,%edi
  80232a:	89 fa                	mov    %edi,%edx
  80232c:	83 c4 1c             	add    $0x1c,%esp
  80232f:	5b                   	pop    %ebx
  802330:	5e                   	pop    %esi
  802331:	5f                   	pop    %edi
  802332:	5d                   	pop    %ebp
  802333:	c3                   	ret    
  802334:	bd 20 00 00 00       	mov    $0x20,%ebp
  802339:	89 eb                	mov    %ebp,%ebx
  80233b:	29 fb                	sub    %edi,%ebx
  80233d:	89 f9                	mov    %edi,%ecx
  80233f:	d3 e6                	shl    %cl,%esi
  802341:	89 c5                	mov    %eax,%ebp
  802343:	88 d9                	mov    %bl,%cl
  802345:	d3 ed                	shr    %cl,%ebp
  802347:	89 e9                	mov    %ebp,%ecx
  802349:	09 f1                	or     %esi,%ecx
  80234b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80234f:	89 f9                	mov    %edi,%ecx
  802351:	d3 e0                	shl    %cl,%eax
  802353:	89 c5                	mov    %eax,%ebp
  802355:	89 d6                	mov    %edx,%esi
  802357:	88 d9                	mov    %bl,%cl
  802359:	d3 ee                	shr    %cl,%esi
  80235b:	89 f9                	mov    %edi,%ecx
  80235d:	d3 e2                	shl    %cl,%edx
  80235f:	8b 44 24 08          	mov    0x8(%esp),%eax
  802363:	88 d9                	mov    %bl,%cl
  802365:	d3 e8                	shr    %cl,%eax
  802367:	09 c2                	or     %eax,%edx
  802369:	89 d0                	mov    %edx,%eax
  80236b:	89 f2                	mov    %esi,%edx
  80236d:	f7 74 24 0c          	divl   0xc(%esp)
  802371:	89 d6                	mov    %edx,%esi
  802373:	89 c3                	mov    %eax,%ebx
  802375:	f7 e5                	mul    %ebp
  802377:	39 d6                	cmp    %edx,%esi
  802379:	72 19                	jb     802394 <__udivdi3+0xfc>
  80237b:	74 0b                	je     802388 <__udivdi3+0xf0>
  80237d:	89 d8                	mov    %ebx,%eax
  80237f:	31 ff                	xor    %edi,%edi
  802381:	e9 58 ff ff ff       	jmp    8022de <__udivdi3+0x46>
  802386:	66 90                	xchg   %ax,%ax
  802388:	8b 54 24 08          	mov    0x8(%esp),%edx
  80238c:	89 f9                	mov    %edi,%ecx
  80238e:	d3 e2                	shl    %cl,%edx
  802390:	39 c2                	cmp    %eax,%edx
  802392:	73 e9                	jae    80237d <__udivdi3+0xe5>
  802394:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802397:	31 ff                	xor    %edi,%edi
  802399:	e9 40 ff ff ff       	jmp    8022de <__udivdi3+0x46>
  80239e:	66 90                	xchg   %ax,%ax
  8023a0:	31 c0                	xor    %eax,%eax
  8023a2:	e9 37 ff ff ff       	jmp    8022de <__udivdi3+0x46>
  8023a7:	90                   	nop

008023a8 <__umoddi3>:
  8023a8:	55                   	push   %ebp
  8023a9:	57                   	push   %edi
  8023aa:	56                   	push   %esi
  8023ab:	53                   	push   %ebx
  8023ac:	83 ec 1c             	sub    $0x1c,%esp
  8023af:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8023b3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8023b7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8023bb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8023bf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8023c3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8023c7:	89 f3                	mov    %esi,%ebx
  8023c9:	89 fa                	mov    %edi,%edx
  8023cb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8023cf:	89 34 24             	mov    %esi,(%esp)
  8023d2:	85 c0                	test   %eax,%eax
  8023d4:	75 1a                	jne    8023f0 <__umoddi3+0x48>
  8023d6:	39 f7                	cmp    %esi,%edi
  8023d8:	0f 86 a2 00 00 00    	jbe    802480 <__umoddi3+0xd8>
  8023de:	89 c8                	mov    %ecx,%eax
  8023e0:	89 f2                	mov    %esi,%edx
  8023e2:	f7 f7                	div    %edi
  8023e4:	89 d0                	mov    %edx,%eax
  8023e6:	31 d2                	xor    %edx,%edx
  8023e8:	83 c4 1c             	add    $0x1c,%esp
  8023eb:	5b                   	pop    %ebx
  8023ec:	5e                   	pop    %esi
  8023ed:	5f                   	pop    %edi
  8023ee:	5d                   	pop    %ebp
  8023ef:	c3                   	ret    
  8023f0:	39 f0                	cmp    %esi,%eax
  8023f2:	0f 87 ac 00 00 00    	ja     8024a4 <__umoddi3+0xfc>
  8023f8:	0f bd e8             	bsr    %eax,%ebp
  8023fb:	83 f5 1f             	xor    $0x1f,%ebp
  8023fe:	0f 84 ac 00 00 00    	je     8024b0 <__umoddi3+0x108>
  802404:	bf 20 00 00 00       	mov    $0x20,%edi
  802409:	29 ef                	sub    %ebp,%edi
  80240b:	89 fe                	mov    %edi,%esi
  80240d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802411:	89 e9                	mov    %ebp,%ecx
  802413:	d3 e0                	shl    %cl,%eax
  802415:	89 d7                	mov    %edx,%edi
  802417:	89 f1                	mov    %esi,%ecx
  802419:	d3 ef                	shr    %cl,%edi
  80241b:	09 c7                	or     %eax,%edi
  80241d:	89 e9                	mov    %ebp,%ecx
  80241f:	d3 e2                	shl    %cl,%edx
  802421:	89 14 24             	mov    %edx,(%esp)
  802424:	89 d8                	mov    %ebx,%eax
  802426:	d3 e0                	shl    %cl,%eax
  802428:	89 c2                	mov    %eax,%edx
  80242a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80242e:	d3 e0                	shl    %cl,%eax
  802430:	89 44 24 04          	mov    %eax,0x4(%esp)
  802434:	8b 44 24 08          	mov    0x8(%esp),%eax
  802438:	89 f1                	mov    %esi,%ecx
  80243a:	d3 e8                	shr    %cl,%eax
  80243c:	09 d0                	or     %edx,%eax
  80243e:	d3 eb                	shr    %cl,%ebx
  802440:	89 da                	mov    %ebx,%edx
  802442:	f7 f7                	div    %edi
  802444:	89 d3                	mov    %edx,%ebx
  802446:	f7 24 24             	mull   (%esp)
  802449:	89 c6                	mov    %eax,%esi
  80244b:	89 d1                	mov    %edx,%ecx
  80244d:	39 d3                	cmp    %edx,%ebx
  80244f:	0f 82 87 00 00 00    	jb     8024dc <__umoddi3+0x134>
  802455:	0f 84 91 00 00 00    	je     8024ec <__umoddi3+0x144>
  80245b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80245f:	29 f2                	sub    %esi,%edx
  802461:	19 cb                	sbb    %ecx,%ebx
  802463:	89 d8                	mov    %ebx,%eax
  802465:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802469:	d3 e0                	shl    %cl,%eax
  80246b:	89 e9                	mov    %ebp,%ecx
  80246d:	d3 ea                	shr    %cl,%edx
  80246f:	09 d0                	or     %edx,%eax
  802471:	89 e9                	mov    %ebp,%ecx
  802473:	d3 eb                	shr    %cl,%ebx
  802475:	89 da                	mov    %ebx,%edx
  802477:	83 c4 1c             	add    $0x1c,%esp
  80247a:	5b                   	pop    %ebx
  80247b:	5e                   	pop    %esi
  80247c:	5f                   	pop    %edi
  80247d:	5d                   	pop    %ebp
  80247e:	c3                   	ret    
  80247f:	90                   	nop
  802480:	89 fd                	mov    %edi,%ebp
  802482:	85 ff                	test   %edi,%edi
  802484:	75 0b                	jne    802491 <__umoddi3+0xe9>
  802486:	b8 01 00 00 00       	mov    $0x1,%eax
  80248b:	31 d2                	xor    %edx,%edx
  80248d:	f7 f7                	div    %edi
  80248f:	89 c5                	mov    %eax,%ebp
  802491:	89 f0                	mov    %esi,%eax
  802493:	31 d2                	xor    %edx,%edx
  802495:	f7 f5                	div    %ebp
  802497:	89 c8                	mov    %ecx,%eax
  802499:	f7 f5                	div    %ebp
  80249b:	89 d0                	mov    %edx,%eax
  80249d:	e9 44 ff ff ff       	jmp    8023e6 <__umoddi3+0x3e>
  8024a2:	66 90                	xchg   %ax,%ax
  8024a4:	89 c8                	mov    %ecx,%eax
  8024a6:	89 f2                	mov    %esi,%edx
  8024a8:	83 c4 1c             	add    $0x1c,%esp
  8024ab:	5b                   	pop    %ebx
  8024ac:	5e                   	pop    %esi
  8024ad:	5f                   	pop    %edi
  8024ae:	5d                   	pop    %ebp
  8024af:	c3                   	ret    
  8024b0:	3b 04 24             	cmp    (%esp),%eax
  8024b3:	72 06                	jb     8024bb <__umoddi3+0x113>
  8024b5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8024b9:	77 0f                	ja     8024ca <__umoddi3+0x122>
  8024bb:	89 f2                	mov    %esi,%edx
  8024bd:	29 f9                	sub    %edi,%ecx
  8024bf:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8024c3:	89 14 24             	mov    %edx,(%esp)
  8024c6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8024ca:	8b 44 24 04          	mov    0x4(%esp),%eax
  8024ce:	8b 14 24             	mov    (%esp),%edx
  8024d1:	83 c4 1c             	add    $0x1c,%esp
  8024d4:	5b                   	pop    %ebx
  8024d5:	5e                   	pop    %esi
  8024d6:	5f                   	pop    %edi
  8024d7:	5d                   	pop    %ebp
  8024d8:	c3                   	ret    
  8024d9:	8d 76 00             	lea    0x0(%esi),%esi
  8024dc:	2b 04 24             	sub    (%esp),%eax
  8024df:	19 fa                	sbb    %edi,%edx
  8024e1:	89 d1                	mov    %edx,%ecx
  8024e3:	89 c6                	mov    %eax,%esi
  8024e5:	e9 71 ff ff ff       	jmp    80245b <__umoddi3+0xb3>
  8024ea:	66 90                	xchg   %ax,%ax
  8024ec:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8024f0:	72 ea                	jb     8024dc <__umoddi3+0x134>
  8024f2:	89 d9                	mov    %ebx,%ecx
  8024f4:	e9 62 ff ff ff       	jmp    80245b <__umoddi3+0xb3>

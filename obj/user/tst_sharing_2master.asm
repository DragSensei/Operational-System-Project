
obj/user/tst_sharing_2master:     file format elf32-i386


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
  800031:	e8 1d 04 00 00       	call   800453 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Master program: create the shared variables, initialize them and run slaves
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 34             	sub    $0x34,%esp

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
  80005c:	68 e0 22 80 00       	push   $0x8022e0
  800061:	6a 14                	push   $0x14
  800063:	68 fc 22 80 00       	push   $0x8022fc
  800068:	e8 96 05 00 00       	call   800603 <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	int eval = 0;
  80006d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	bool is_correct = 1;
  800074:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  80007b:	c7 45 ec 00 10 00 82 	movl   $0x82001000,-0x14(%ebp)
	uint32 *x, *y, *z ;
	int diff, expected;

	//x: Readonly
	int freeFrames = sys_calculate_free_frames() ;
  800082:	e8 05 1a 00 00       	call   801a8c <sys_calculate_free_frames>
  800087:	89 45 e8             	mov    %eax,-0x18(%ebp)
	x = smalloc("x", 4, 0);
  80008a:	83 ec 04             	sub    $0x4,%esp
  80008d:	6a 00                	push   $0x0
  80008f:	6a 04                	push   $0x4
  800091:	68 17 23 80 00       	push   $0x802317
  800096:	e8 40 18 00 00       	call   8018db <smalloc>
  80009b:	83 c4 10             	add    $0x10,%esp
  80009e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (x != (uint32*)pagealloc_start) {is_correct = 0; cprintf("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");}
  8000a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000a4:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8000a7:	74 17                	je     8000c0 <_main+0x88>
  8000a9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8000b0:	83 ec 0c             	sub    $0xc,%esp
  8000b3:	68 1c 23 80 00       	push   $0x80231c
  8000b8:	e8 14 08 00 00       	call   8008d1 <cprintf>
  8000bd:	83 c4 10             	add    $0x10,%esp
	expected = 1+1 ; /*1page +1table*/
  8000c0:	c7 45 e0 02 00 00 00 	movl   $0x2,-0x20(%ebp)
	diff = (freeFrames - sys_calculate_free_frames());
  8000c7:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000ca:	e8 bd 19 00 00       	call   801a8c <sys_calculate_free_frames>
  8000cf:	29 c3                	sub    %eax,%ebx
  8000d1:	89 d8                	mov    %ebx,%eax
  8000d3:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/) {is_correct = 0; cprintf("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  8000d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8000d9:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8000dc:	7c 0b                	jl     8000e9 <_main+0xb1>
  8000de:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8000e1:	83 c0 02             	add    $0x2,%eax
  8000e4:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8000e7:	7d 27                	jge    800110 <_main+0xd8>
  8000e9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8000f0:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000f3:	e8 94 19 00 00       	call   801a8c <sys_calculate_free_frames>
  8000f8:	29 c3                	sub    %eax,%ebx
  8000fa:	89 d8                	mov    %ebx,%eax
  8000fc:	83 ec 04             	sub    $0x4,%esp
  8000ff:	ff 75 e0             	pushl  -0x20(%ebp)
  800102:	50                   	push   %eax
  800103:	68 80 23 80 00       	push   $0x802380
  800108:	e8 c4 07 00 00       	call   8008d1 <cprintf>
  80010d:	83 c4 10             	add    $0x10,%esp

	//y: Readonly
	freeFrames = sys_calculate_free_frames() ;
  800110:	e8 77 19 00 00       	call   801a8c <sys_calculate_free_frames>
  800115:	89 45 e8             	mov    %eax,-0x18(%ebp)
	y = smalloc("y", 4, 0);
  800118:	83 ec 04             	sub    $0x4,%esp
  80011b:	6a 00                	push   $0x0
  80011d:	6a 04                	push   $0x4
  80011f:	68 18 24 80 00       	push   $0x802418
  800124:	e8 b2 17 00 00       	call   8018db <smalloc>
  800129:	83 c4 10             	add    $0x10,%esp
  80012c:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (y != (uint32*)(pagealloc_start + 1 * PAGE_SIZE)) {is_correct = 0; cprintf("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");}
  80012f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800132:	05 00 10 00 00       	add    $0x1000,%eax
  800137:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80013a:	74 17                	je     800153 <_main+0x11b>
  80013c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800143:	83 ec 0c             	sub    $0xc,%esp
  800146:	68 1c 23 80 00       	push   $0x80231c
  80014b:	e8 81 07 00 00       	call   8008d1 <cprintf>
  800150:	83 c4 10             	add    $0x10,%esp
	expected = 1 ; /*1page*/
  800153:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
	diff = (freeFrames - sys_calculate_free_frames());
  80015a:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  80015d:	e8 2a 19 00 00       	call   801a8c <sys_calculate_free_frames>
  800162:	29 c3                	sub    %eax,%ebx
  800164:	89 d8                	mov    %ebx,%eax
  800166:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/) {is_correct = 0; cprintf("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  800169:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80016c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80016f:	7c 0b                	jl     80017c <_main+0x144>
  800171:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800174:	83 c0 02             	add    $0x2,%eax
  800177:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80017a:	7d 27                	jge    8001a3 <_main+0x16b>
  80017c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800183:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800186:	e8 01 19 00 00       	call   801a8c <sys_calculate_free_frames>
  80018b:	29 c3                	sub    %eax,%ebx
  80018d:	89 d8                	mov    %ebx,%eax
  80018f:	83 ec 04             	sub    $0x4,%esp
  800192:	ff 75 e0             	pushl  -0x20(%ebp)
  800195:	50                   	push   %eax
  800196:	68 80 23 80 00       	push   $0x802380
  80019b:	e8 31 07 00 00       	call   8008d1 <cprintf>
  8001a0:	83 c4 10             	add    $0x10,%esp

	//z: Writable
	freeFrames = sys_calculate_free_frames() ;
  8001a3:	e8 e4 18 00 00       	call   801a8c <sys_calculate_free_frames>
  8001a8:	89 45 e8             	mov    %eax,-0x18(%ebp)
	z = smalloc("z", 4, 1);
  8001ab:	83 ec 04             	sub    $0x4,%esp
  8001ae:	6a 01                	push   $0x1
  8001b0:	6a 04                	push   $0x4
  8001b2:	68 1a 24 80 00       	push   $0x80241a
  8001b7:	e8 1f 17 00 00       	call   8018db <smalloc>
  8001bc:	83 c4 10             	add    $0x10,%esp
  8001bf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (z != (uint32*)(pagealloc_start + 2 * PAGE_SIZE)) {is_correct = 0; cprintf("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");}
  8001c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001c5:	05 00 20 00 00       	add    $0x2000,%eax
  8001ca:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8001cd:	74 17                	je     8001e6 <_main+0x1ae>
  8001cf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001d6:	83 ec 0c             	sub    $0xc,%esp
  8001d9:	68 1c 23 80 00       	push   $0x80231c
  8001de:	e8 ee 06 00 00       	call   8008d1 <cprintf>
  8001e3:	83 c4 10             	add    $0x10,%esp
	expected = 1 ; /*1page*/
  8001e6:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
	diff = (freeFrames - sys_calculate_free_frames());
  8001ed:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8001f0:	e8 97 18 00 00       	call   801a8c <sys_calculate_free_frames>
  8001f5:	29 c3                	sub    %eax,%ebx
  8001f7:	89 d8                	mov    %ebx,%eax
  8001f9:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/) {is_correct = 0; cprintf("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  8001fc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001ff:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800202:	7c 0b                	jl     80020f <_main+0x1d7>
  800204:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800207:	83 c0 02             	add    $0x2,%eax
  80020a:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80020d:	7d 27                	jge    800236 <_main+0x1fe>
  80020f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800216:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800219:	e8 6e 18 00 00       	call   801a8c <sys_calculate_free_frames>
  80021e:	29 c3                	sub    %eax,%ebx
  800220:	89 d8                	mov    %ebx,%eax
  800222:	83 ec 04             	sub    $0x4,%esp
  800225:	ff 75 e0             	pushl  -0x20(%ebp)
  800228:	50                   	push   %eax
  800229:	68 80 23 80 00       	push   $0x802380
  80022e:	e8 9e 06 00 00       	call   8008d1 <cprintf>
  800233:	83 c4 10             	add    $0x10,%esp

	if (is_correct)	eval+=25;
  800236:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80023a:	74 04                	je     800240 <_main+0x208>
  80023c:	83 45 f4 19          	addl   $0x19,-0xc(%ebp)
	is_correct = 1;
  800240:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	*x = 10 ;
  800247:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80024a:	c7 00 0a 00 00 00    	movl   $0xa,(%eax)
	*y = 20 ;
  800250:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800253:	c7 00 14 00 00 00    	movl   $0x14,(%eax)

	int id1, id2, id3;
	id1 = sys_create_env("shr2Slave1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800259:	a1 20 30 80 00       	mov    0x803020,%eax
  80025e:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  800264:	a1 20 30 80 00       	mov    0x803020,%eax
  800269:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  80026f:	89 c1                	mov    %eax,%ecx
  800271:	a1 20 30 80 00       	mov    0x803020,%eax
  800276:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80027c:	52                   	push   %edx
  80027d:	51                   	push   %ecx
  80027e:	50                   	push   %eax
  80027f:	68 1c 24 80 00       	push   $0x80241c
  800284:	e8 5e 19 00 00       	call   801be7 <sys_create_env>
  800289:	83 c4 10             	add    $0x10,%esp
  80028c:	89 45 d0             	mov    %eax,-0x30(%ebp)
	id2 = sys_create_env("shr2Slave1", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  80028f:	a1 20 30 80 00       	mov    0x803020,%eax
  800294:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  80029a:	a1 20 30 80 00       	mov    0x803020,%eax
  80029f:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  8002a5:	89 c1                	mov    %eax,%ecx
  8002a7:	a1 20 30 80 00       	mov    0x803020,%eax
  8002ac:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8002b2:	52                   	push   %edx
  8002b3:	51                   	push   %ecx
  8002b4:	50                   	push   %eax
  8002b5:	68 1c 24 80 00       	push   $0x80241c
  8002ba:	e8 28 19 00 00       	call   801be7 <sys_create_env>
  8002bf:	83 c4 10             	add    $0x10,%esp
  8002c2:	89 45 cc             	mov    %eax,-0x34(%ebp)
	id3 = sys_create_env("shr2Slave1", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  8002c5:	a1 20 30 80 00       	mov    0x803020,%eax
  8002ca:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  8002d0:	a1 20 30 80 00       	mov    0x803020,%eax
  8002d5:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  8002db:	89 c1                	mov    %eax,%ecx
  8002dd:	a1 20 30 80 00       	mov    0x803020,%eax
  8002e2:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8002e8:	52                   	push   %edx
  8002e9:	51                   	push   %ecx
  8002ea:	50                   	push   %eax
  8002eb:	68 1c 24 80 00       	push   $0x80241c
  8002f0:	e8 f2 18 00 00       	call   801be7 <sys_create_env>
  8002f5:	83 c4 10             	add    $0x10,%esp
  8002f8:	89 45 c8             	mov    %eax,-0x38(%ebp)

	//to check that the slave environments completed successfully
	rsttst();
  8002fb:	e8 33 1a 00 00       	call   801d33 <rsttst>

	sys_run_env(id1);
  800300:	83 ec 0c             	sub    $0xc,%esp
  800303:	ff 75 d0             	pushl  -0x30(%ebp)
  800306:	e8 fa 18 00 00       	call   801c05 <sys_run_env>
  80030b:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id2);
  80030e:	83 ec 0c             	sub    $0xc,%esp
  800311:	ff 75 cc             	pushl  -0x34(%ebp)
  800314:	e8 ec 18 00 00       	call   801c05 <sys_run_env>
  800319:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id3);
  80031c:	83 ec 0c             	sub    $0xc,%esp
  80031f:	ff 75 c8             	pushl  -0x38(%ebp)
  800322:	e8 de 18 00 00       	call   801c05 <sys_run_env>
  800327:	83 c4 10             	add    $0x10,%esp

	//to ensure that the slave environments completed successfully
	while (gettst()!=3) ;// panic("test failed");
  80032a:	90                   	nop
  80032b:	e8 7d 1a 00 00       	call   801dad <gettst>
  800330:	83 f8 03             	cmp    $0x3,%eax
  800333:	75 f6                	jne    80032b <_main+0x2f3>


	if (*z != 30)
  800335:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800338:	8b 00                	mov    (%eax),%eax
  80033a:	83 f8 1e             	cmp    $0x1e,%eax
  80033d:	74 17                	je     800356 <_main+0x31e>
	{is_correct = 0; cprintf("Error!! Please check the creation (or the getting) of shared variables!!\n\n\n");}
  80033f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800346:	83 ec 0c             	sub    $0xc,%esp
  800349:	68 28 24 80 00       	push   $0x802428
  80034e:	e8 7e 05 00 00       	call   8008d1 <cprintf>
  800353:	83 c4 10             	add    $0x10,%esp

	if (is_correct)	eval+=25;
  800356:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80035a:	74 04                	je     800360 <_main+0x328>
  80035c:	83 45 f4 19          	addl   $0x19,-0xc(%ebp)
	is_correct = 1;
  800360:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	atomic_cprintf("%@Now, attempting to write a ReadOnly variable\n\n\n");
  800367:	83 ec 0c             	sub    $0xc,%esp
  80036a:	68 74 24 80 00       	push   $0x802474
  80036f:	e8 cf 05 00 00       	call   800943 <atomic_cprintf>
  800374:	83 c4 10             	add    $0x10,%esp

	id1 = sys_create_env("shr2Slave2", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800377:	a1 20 30 80 00       	mov    0x803020,%eax
  80037c:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  800382:	a1 20 30 80 00       	mov    0x803020,%eax
  800387:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  80038d:	89 c1                	mov    %eax,%ecx
  80038f:	a1 20 30 80 00       	mov    0x803020,%eax
  800394:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80039a:	52                   	push   %edx
  80039b:	51                   	push   %ecx
  80039c:	50                   	push   %eax
  80039d:	68 a6 24 80 00       	push   $0x8024a6
  8003a2:	e8 40 18 00 00       	call   801be7 <sys_create_env>
  8003a7:	83 c4 10             	add    $0x10,%esp
  8003aa:	89 45 d0             	mov    %eax,-0x30(%ebp)

	sys_run_env(id1);
  8003ad:	83 ec 0c             	sub    $0xc,%esp
  8003b0:	ff 75 d0             	pushl  -0x30(%ebp)
  8003b3:	e8 4d 18 00 00       	call   801c05 <sys_run_env>
  8003b8:	83 c4 10             	add    $0x10,%esp

	//to ensure that the slave environment edits the z variable
	while (gettst() != 4) ;
  8003bb:	90                   	nop
  8003bc:	e8 ec 19 00 00       	call   801dad <gettst>
  8003c1:	83 f8 04             	cmp    $0x4,%eax
  8003c4:	75 f6                	jne    8003bc <_main+0x384>

	if (*z != 50)
  8003c6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003c9:	8b 00                	mov    (%eax),%eax
  8003cb:	83 f8 32             	cmp    $0x32,%eax
  8003ce:	74 17                	je     8003e7 <_main+0x3af>
	{is_correct = 0; cprintf("Error!! Please check the creation (or the getting) of shared variables!!\n\n\n");}
  8003d0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003d7:	83 ec 0c             	sub    $0xc,%esp
  8003da:	68 28 24 80 00       	push   $0x802428
  8003df:	e8 ed 04 00 00       	call   8008d1 <cprintf>
  8003e4:	83 c4 10             	add    $0x10,%esp

	if (is_correct)	eval+=25;
  8003e7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8003eb:	74 04                	je     8003f1 <_main+0x3b9>
  8003ed:	83 45 f4 19          	addl   $0x19,-0xc(%ebp)
	is_correct = 1;
  8003f1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	//Signal slave2
	inctst();
  8003f8:	e8 96 19 00 00       	call   801d93 <inctst>

	//to ensure that the slave environment attempt to edit the x variable
	while (gettst()!=6) ;// panic("test failed");
  8003fd:	90                   	nop
  8003fe:	e8 aa 19 00 00       	call   801dad <gettst>
  800403:	83 f8 06             	cmp    $0x6,%eax
  800406:	75 f6                	jne    8003fe <_main+0x3c6>

	if (*x != 10)
  800408:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80040b:	8b 00                	mov    (%eax),%eax
  80040d:	83 f8 0a             	cmp    $0xa,%eax
  800410:	74 17                	je     800429 <_main+0x3f1>
	{is_correct = 0; cprintf("Error!! Please check the creation (or the getting) of shared variables!!\n\n\n");}
  800412:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800419:	83 ec 0c             	sub    $0xc,%esp
  80041c:	68 28 24 80 00       	push   $0x802428
  800421:	e8 ab 04 00 00       	call   8008d1 <cprintf>
  800426:	83 c4 10             	add    $0x10,%esp

	if (is_correct)	eval+=25;
  800429:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80042d:	74 04                	je     800433 <_main+0x3fb>
  80042f:	83 45 f4 19          	addl   $0x19,-0xc(%ebp)
	is_correct = 1;
  800433:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	cprintf("\n%~Test of Shared Variables [Create & Get] completed. Eval = %d%%\n\n", eval);
  80043a:	83 ec 08             	sub    $0x8,%esp
  80043d:	ff 75 f4             	pushl  -0xc(%ebp)
  800440:	68 b4 24 80 00       	push   $0x8024b4
  800445:	e8 87 04 00 00       	call   8008d1 <cprintf>
  80044a:	83 c4 10             	add    $0x10,%esp
	return;
  80044d:	90                   	nop
}
  80044e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800451:	c9                   	leave  
  800452:	c3                   	ret    

00800453 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800453:	55                   	push   %ebp
  800454:	89 e5                	mov    %esp,%ebp
  800456:	57                   	push   %edi
  800457:	56                   	push   %esi
  800458:	53                   	push   %ebx
  800459:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80045c:	e8 f4 17 00 00       	call   801c55 <sys_getenvindex>
  800461:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800464:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800467:	89 d0                	mov    %edx,%eax
  800469:	c1 e0 02             	shl    $0x2,%eax
  80046c:	01 d0                	add    %edx,%eax
  80046e:	c1 e0 03             	shl    $0x3,%eax
  800471:	01 d0                	add    %edx,%eax
  800473:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80047a:	01 d0                	add    %edx,%eax
  80047c:	c1 e0 02             	shl    $0x2,%eax
  80047f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800484:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800489:	a1 20 30 80 00       	mov    0x803020,%eax
  80048e:	8a 40 20             	mov    0x20(%eax),%al
  800491:	84 c0                	test   %al,%al
  800493:	74 0d                	je     8004a2 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800495:	a1 20 30 80 00       	mov    0x803020,%eax
  80049a:	83 c0 20             	add    $0x20,%eax
  80049d:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8004a2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8004a6:	7e 0a                	jle    8004b2 <libmain+0x5f>
		binaryname = argv[0];
  8004a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ab:	8b 00                	mov    (%eax),%eax
  8004ad:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  8004b2:	83 ec 08             	sub    $0x8,%esp
  8004b5:	ff 75 0c             	pushl  0xc(%ebp)
  8004b8:	ff 75 08             	pushl  0x8(%ebp)
  8004bb:	e8 78 fb ff ff       	call   800038 <_main>
  8004c0:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8004c3:	a1 00 30 80 00       	mov    0x803000,%eax
  8004c8:	85 c0                	test   %eax,%eax
  8004ca:	0f 84 01 01 00 00    	je     8005d1 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8004d0:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8004d6:	bb f0 25 80 00       	mov    $0x8025f0,%ebx
  8004db:	ba 0e 00 00 00       	mov    $0xe,%edx
  8004e0:	89 c7                	mov    %eax,%edi
  8004e2:	89 de                	mov    %ebx,%esi
  8004e4:	89 d1                	mov    %edx,%ecx
  8004e6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8004e8:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8004eb:	b9 56 00 00 00       	mov    $0x56,%ecx
  8004f0:	b0 00                	mov    $0x0,%al
  8004f2:	89 d7                	mov    %edx,%edi
  8004f4:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8004f6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8004fd:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800500:	83 ec 08             	sub    $0x8,%esp
  800503:	50                   	push   %eax
  800504:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80050a:	50                   	push   %eax
  80050b:	e8 7b 19 00 00       	call   801e8b <sys_utilities>
  800510:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800513:	e8 c4 14 00 00       	call   8019dc <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800518:	83 ec 0c             	sub    $0xc,%esp
  80051b:	68 10 25 80 00       	push   $0x802510
  800520:	e8 ac 03 00 00       	call   8008d1 <cprintf>
  800525:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800528:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80052b:	85 c0                	test   %eax,%eax
  80052d:	74 18                	je     800547 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80052f:	e8 75 19 00 00       	call   801ea9 <sys_get_optimal_num_faults>
  800534:	83 ec 08             	sub    $0x8,%esp
  800537:	50                   	push   %eax
  800538:	68 38 25 80 00       	push   $0x802538
  80053d:	e8 8f 03 00 00       	call   8008d1 <cprintf>
  800542:	83 c4 10             	add    $0x10,%esp
  800545:	eb 59                	jmp    8005a0 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800547:	a1 20 30 80 00       	mov    0x803020,%eax
  80054c:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  800552:	a1 20 30 80 00       	mov    0x803020,%eax
  800557:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  80055d:	83 ec 04             	sub    $0x4,%esp
  800560:	52                   	push   %edx
  800561:	50                   	push   %eax
  800562:	68 5c 25 80 00       	push   $0x80255c
  800567:	e8 65 03 00 00       	call   8008d1 <cprintf>
  80056c:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80056f:	a1 20 30 80 00       	mov    0x803020,%eax
  800574:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  80057a:	a1 20 30 80 00       	mov    0x803020,%eax
  80057f:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  800585:	a1 20 30 80 00       	mov    0x803020,%eax
  80058a:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  800590:	51                   	push   %ecx
  800591:	52                   	push   %edx
  800592:	50                   	push   %eax
  800593:	68 84 25 80 00       	push   $0x802584
  800598:	e8 34 03 00 00       	call   8008d1 <cprintf>
  80059d:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8005a0:	a1 20 30 80 00       	mov    0x803020,%eax
  8005a5:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  8005ab:	83 ec 08             	sub    $0x8,%esp
  8005ae:	50                   	push   %eax
  8005af:	68 dc 25 80 00       	push   $0x8025dc
  8005b4:	e8 18 03 00 00       	call   8008d1 <cprintf>
  8005b9:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8005bc:	83 ec 0c             	sub    $0xc,%esp
  8005bf:	68 10 25 80 00       	push   $0x802510
  8005c4:	e8 08 03 00 00       	call   8008d1 <cprintf>
  8005c9:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8005cc:	e8 25 14 00 00       	call   8019f6 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8005d1:	e8 1f 00 00 00       	call   8005f5 <exit>
}
  8005d6:	90                   	nop
  8005d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8005da:	5b                   	pop    %ebx
  8005db:	5e                   	pop    %esi
  8005dc:	5f                   	pop    %edi
  8005dd:	5d                   	pop    %ebp
  8005de:	c3                   	ret    

008005df <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8005df:	55                   	push   %ebp
  8005e0:	89 e5                	mov    %esp,%ebp
  8005e2:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8005e5:	83 ec 0c             	sub    $0xc,%esp
  8005e8:	6a 00                	push   $0x0
  8005ea:	e8 32 16 00 00       	call   801c21 <sys_destroy_env>
  8005ef:	83 c4 10             	add    $0x10,%esp
}
  8005f2:	90                   	nop
  8005f3:	c9                   	leave  
  8005f4:	c3                   	ret    

008005f5 <exit>:

void
exit(void)
{
  8005f5:	55                   	push   %ebp
  8005f6:	89 e5                	mov    %esp,%ebp
  8005f8:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8005fb:	e8 87 16 00 00       	call   801c87 <sys_exit_env>
}
  800600:	90                   	nop
  800601:	c9                   	leave  
  800602:	c3                   	ret    

00800603 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800603:	55                   	push   %ebp
  800604:	89 e5                	mov    %esp,%ebp
  800606:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800609:	8d 45 10             	lea    0x10(%ebp),%eax
  80060c:	83 c0 04             	add    $0x4,%eax
  80060f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800612:	a1 18 b1 81 00       	mov    0x81b118,%eax
  800617:	85 c0                	test   %eax,%eax
  800619:	74 16                	je     800631 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80061b:	a1 18 b1 81 00       	mov    0x81b118,%eax
  800620:	83 ec 08             	sub    $0x8,%esp
  800623:	50                   	push   %eax
  800624:	68 54 26 80 00       	push   $0x802654
  800629:	e8 a3 02 00 00       	call   8008d1 <cprintf>
  80062e:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800631:	a1 04 30 80 00       	mov    0x803004,%eax
  800636:	83 ec 0c             	sub    $0xc,%esp
  800639:	ff 75 0c             	pushl  0xc(%ebp)
  80063c:	ff 75 08             	pushl  0x8(%ebp)
  80063f:	50                   	push   %eax
  800640:	68 5c 26 80 00       	push   $0x80265c
  800645:	6a 74                	push   $0x74
  800647:	e8 b2 02 00 00       	call   8008fe <cprintf_colored>
  80064c:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  80064f:	8b 45 10             	mov    0x10(%ebp),%eax
  800652:	83 ec 08             	sub    $0x8,%esp
  800655:	ff 75 f4             	pushl  -0xc(%ebp)
  800658:	50                   	push   %eax
  800659:	e8 04 02 00 00       	call   800862 <vcprintf>
  80065e:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800661:	83 ec 08             	sub    $0x8,%esp
  800664:	6a 00                	push   $0x0
  800666:	68 84 26 80 00       	push   $0x802684
  80066b:	e8 f2 01 00 00       	call   800862 <vcprintf>
  800670:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800673:	e8 7d ff ff ff       	call   8005f5 <exit>

	// should not return here
	while (1) ;
  800678:	eb fe                	jmp    800678 <_panic+0x75>

0080067a <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80067a:	55                   	push   %ebp
  80067b:	89 e5                	mov    %esp,%ebp
  80067d:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800680:	a1 20 30 80 00       	mov    0x803020,%eax
  800685:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80068b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80068e:	39 c2                	cmp    %eax,%edx
  800690:	74 14                	je     8006a6 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800692:	83 ec 04             	sub    $0x4,%esp
  800695:	68 88 26 80 00       	push   $0x802688
  80069a:	6a 26                	push   $0x26
  80069c:	68 d4 26 80 00       	push   $0x8026d4
  8006a1:	e8 5d ff ff ff       	call   800603 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8006a6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8006ad:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8006b4:	e9 c5 00 00 00       	jmp    80077e <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8006b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006bc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c6:	01 d0                	add    %edx,%eax
  8006c8:	8b 00                	mov    (%eax),%eax
  8006ca:	85 c0                	test   %eax,%eax
  8006cc:	75 08                	jne    8006d6 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8006ce:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8006d1:	e9 a5 00 00 00       	jmp    80077b <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8006d6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006dd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8006e4:	eb 69                	jmp    80074f <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8006e6:	a1 20 30 80 00       	mov    0x803020,%eax
  8006eb:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8006f1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8006f4:	89 d0                	mov    %edx,%eax
  8006f6:	01 c0                	add    %eax,%eax
  8006f8:	01 d0                	add    %edx,%eax
  8006fa:	c1 e0 03             	shl    $0x3,%eax
  8006fd:	01 c8                	add    %ecx,%eax
  8006ff:	8a 40 04             	mov    0x4(%eax),%al
  800702:	84 c0                	test   %al,%al
  800704:	75 46                	jne    80074c <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800706:	a1 20 30 80 00       	mov    0x803020,%eax
  80070b:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800711:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800714:	89 d0                	mov    %edx,%eax
  800716:	01 c0                	add    %eax,%eax
  800718:	01 d0                	add    %edx,%eax
  80071a:	c1 e0 03             	shl    $0x3,%eax
  80071d:	01 c8                	add    %ecx,%eax
  80071f:	8b 00                	mov    (%eax),%eax
  800721:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800724:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800727:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80072c:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80072e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800731:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800738:	8b 45 08             	mov    0x8(%ebp),%eax
  80073b:	01 c8                	add    %ecx,%eax
  80073d:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80073f:	39 c2                	cmp    %eax,%edx
  800741:	75 09                	jne    80074c <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800743:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80074a:	eb 15                	jmp    800761 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80074c:	ff 45 e8             	incl   -0x18(%ebp)
  80074f:	a1 20 30 80 00       	mov    0x803020,%eax
  800754:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80075a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80075d:	39 c2                	cmp    %eax,%edx
  80075f:	77 85                	ja     8006e6 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800761:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800765:	75 14                	jne    80077b <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800767:	83 ec 04             	sub    $0x4,%esp
  80076a:	68 e0 26 80 00       	push   $0x8026e0
  80076f:	6a 3a                	push   $0x3a
  800771:	68 d4 26 80 00       	push   $0x8026d4
  800776:	e8 88 fe ff ff       	call   800603 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80077b:	ff 45 f0             	incl   -0x10(%ebp)
  80077e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800781:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800784:	0f 8c 2f ff ff ff    	jl     8006b9 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80078a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800791:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800798:	eb 26                	jmp    8007c0 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80079a:	a1 20 30 80 00       	mov    0x803020,%eax
  80079f:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8007a5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007a8:	89 d0                	mov    %edx,%eax
  8007aa:	01 c0                	add    %eax,%eax
  8007ac:	01 d0                	add    %edx,%eax
  8007ae:	c1 e0 03             	shl    $0x3,%eax
  8007b1:	01 c8                	add    %ecx,%eax
  8007b3:	8a 40 04             	mov    0x4(%eax),%al
  8007b6:	3c 01                	cmp    $0x1,%al
  8007b8:	75 03                	jne    8007bd <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8007ba:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8007bd:	ff 45 e0             	incl   -0x20(%ebp)
  8007c0:	a1 20 30 80 00       	mov    0x803020,%eax
  8007c5:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8007cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007ce:	39 c2                	cmp    %eax,%edx
  8007d0:	77 c8                	ja     80079a <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8007d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007d5:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8007d8:	74 14                	je     8007ee <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8007da:	83 ec 04             	sub    $0x4,%esp
  8007dd:	68 34 27 80 00       	push   $0x802734
  8007e2:	6a 44                	push   $0x44
  8007e4:	68 d4 26 80 00       	push   $0x8026d4
  8007e9:	e8 15 fe ff ff       	call   800603 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8007ee:	90                   	nop
  8007ef:	c9                   	leave  
  8007f0:	c3                   	ret    

008007f1 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8007f1:	55                   	push   %ebp
  8007f2:	89 e5                	mov    %esp,%ebp
  8007f4:	53                   	push   %ebx
  8007f5:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8007f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007fb:	8b 00                	mov    (%eax),%eax
  8007fd:	8d 48 01             	lea    0x1(%eax),%ecx
  800800:	8b 55 0c             	mov    0xc(%ebp),%edx
  800803:	89 0a                	mov    %ecx,(%edx)
  800805:	8b 55 08             	mov    0x8(%ebp),%edx
  800808:	88 d1                	mov    %dl,%cl
  80080a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80080d:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800811:	8b 45 0c             	mov    0xc(%ebp),%eax
  800814:	8b 00                	mov    (%eax),%eax
  800816:	3d ff 00 00 00       	cmp    $0xff,%eax
  80081b:	75 30                	jne    80084d <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  80081d:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  800823:	a0 44 30 80 00       	mov    0x803044,%al
  800828:	0f b6 c0             	movzbl %al,%eax
  80082b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80082e:	8b 09                	mov    (%ecx),%ecx
  800830:	89 cb                	mov    %ecx,%ebx
  800832:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800835:	83 c1 08             	add    $0x8,%ecx
  800838:	52                   	push   %edx
  800839:	50                   	push   %eax
  80083a:	53                   	push   %ebx
  80083b:	51                   	push   %ecx
  80083c:	e8 57 11 00 00       	call   801998 <sys_cputs>
  800841:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800844:	8b 45 0c             	mov    0xc(%ebp),%eax
  800847:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80084d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800850:	8b 40 04             	mov    0x4(%eax),%eax
  800853:	8d 50 01             	lea    0x1(%eax),%edx
  800856:	8b 45 0c             	mov    0xc(%ebp),%eax
  800859:	89 50 04             	mov    %edx,0x4(%eax)
}
  80085c:	90                   	nop
  80085d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800860:	c9                   	leave  
  800861:	c3                   	ret    

00800862 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800862:	55                   	push   %ebp
  800863:	89 e5                	mov    %esp,%ebp
  800865:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80086b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800872:	00 00 00 
	b.cnt = 0;
  800875:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80087c:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80087f:	ff 75 0c             	pushl  0xc(%ebp)
  800882:	ff 75 08             	pushl  0x8(%ebp)
  800885:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80088b:	50                   	push   %eax
  80088c:	68 f1 07 80 00       	push   $0x8007f1
  800891:	e8 5a 02 00 00       	call   800af0 <vprintfmt>
  800896:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800899:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  80089f:	a0 44 30 80 00       	mov    0x803044,%al
  8008a4:	0f b6 c0             	movzbl %al,%eax
  8008a7:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8008ad:	52                   	push   %edx
  8008ae:	50                   	push   %eax
  8008af:	51                   	push   %ecx
  8008b0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8008b6:	83 c0 08             	add    $0x8,%eax
  8008b9:	50                   	push   %eax
  8008ba:	e8 d9 10 00 00       	call   801998 <sys_cputs>
  8008bf:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8008c2:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  8008c9:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8008cf:	c9                   	leave  
  8008d0:	c3                   	ret    

008008d1 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8008d1:	55                   	push   %ebp
  8008d2:	89 e5                	mov    %esp,%ebp
  8008d4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8008d7:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  8008de:	8d 45 0c             	lea    0xc(%ebp),%eax
  8008e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8008e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e7:	83 ec 08             	sub    $0x8,%esp
  8008ea:	ff 75 f4             	pushl  -0xc(%ebp)
  8008ed:	50                   	push   %eax
  8008ee:	e8 6f ff ff ff       	call   800862 <vcprintf>
  8008f3:	83 c4 10             	add    $0x10,%esp
  8008f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8008f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8008fc:	c9                   	leave  
  8008fd:	c3                   	ret    

008008fe <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8008fe:	55                   	push   %ebp
  8008ff:	89 e5                	mov    %esp,%ebp
  800901:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800904:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  80090b:	8b 45 08             	mov    0x8(%ebp),%eax
  80090e:	c1 e0 08             	shl    $0x8,%eax
  800911:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  800916:	8d 45 0c             	lea    0xc(%ebp),%eax
  800919:	83 c0 04             	add    $0x4,%eax
  80091c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80091f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800922:	83 ec 08             	sub    $0x8,%esp
  800925:	ff 75 f4             	pushl  -0xc(%ebp)
  800928:	50                   	push   %eax
  800929:	e8 34 ff ff ff       	call   800862 <vcprintf>
  80092e:	83 c4 10             	add    $0x10,%esp
  800931:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800934:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  80093b:	07 00 00 

	return cnt;
  80093e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800941:	c9                   	leave  
  800942:	c3                   	ret    

00800943 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800943:	55                   	push   %ebp
  800944:	89 e5                	mov    %esp,%ebp
  800946:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800949:	e8 8e 10 00 00       	call   8019dc <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80094e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800951:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800954:	8b 45 08             	mov    0x8(%ebp),%eax
  800957:	83 ec 08             	sub    $0x8,%esp
  80095a:	ff 75 f4             	pushl  -0xc(%ebp)
  80095d:	50                   	push   %eax
  80095e:	e8 ff fe ff ff       	call   800862 <vcprintf>
  800963:	83 c4 10             	add    $0x10,%esp
  800966:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800969:	e8 88 10 00 00       	call   8019f6 <sys_unlock_cons>
	return cnt;
  80096e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800971:	c9                   	leave  
  800972:	c3                   	ret    

00800973 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800973:	55                   	push   %ebp
  800974:	89 e5                	mov    %esp,%ebp
  800976:	53                   	push   %ebx
  800977:	83 ec 14             	sub    $0x14,%esp
  80097a:	8b 45 10             	mov    0x10(%ebp),%eax
  80097d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800980:	8b 45 14             	mov    0x14(%ebp),%eax
  800983:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800986:	8b 45 18             	mov    0x18(%ebp),%eax
  800989:	ba 00 00 00 00       	mov    $0x0,%edx
  80098e:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800991:	77 55                	ja     8009e8 <printnum+0x75>
  800993:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800996:	72 05                	jb     80099d <printnum+0x2a>
  800998:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80099b:	77 4b                	ja     8009e8 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80099d:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8009a0:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8009a3:	8b 45 18             	mov    0x18(%ebp),%eax
  8009a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8009ab:	52                   	push   %edx
  8009ac:	50                   	push   %eax
  8009ad:	ff 75 f4             	pushl  -0xc(%ebp)
  8009b0:	ff 75 f0             	pushl  -0x10(%ebp)
  8009b3:	e8 a8 16 00 00       	call   802060 <__udivdi3>
  8009b8:	83 c4 10             	add    $0x10,%esp
  8009bb:	83 ec 04             	sub    $0x4,%esp
  8009be:	ff 75 20             	pushl  0x20(%ebp)
  8009c1:	53                   	push   %ebx
  8009c2:	ff 75 18             	pushl  0x18(%ebp)
  8009c5:	52                   	push   %edx
  8009c6:	50                   	push   %eax
  8009c7:	ff 75 0c             	pushl  0xc(%ebp)
  8009ca:	ff 75 08             	pushl  0x8(%ebp)
  8009cd:	e8 a1 ff ff ff       	call   800973 <printnum>
  8009d2:	83 c4 20             	add    $0x20,%esp
  8009d5:	eb 1a                	jmp    8009f1 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8009d7:	83 ec 08             	sub    $0x8,%esp
  8009da:	ff 75 0c             	pushl  0xc(%ebp)
  8009dd:	ff 75 20             	pushl  0x20(%ebp)
  8009e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e3:	ff d0                	call   *%eax
  8009e5:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8009e8:	ff 4d 1c             	decl   0x1c(%ebp)
  8009eb:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8009ef:	7f e6                	jg     8009d7 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8009f1:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8009f4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8009f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009ff:	53                   	push   %ebx
  800a00:	51                   	push   %ecx
  800a01:	52                   	push   %edx
  800a02:	50                   	push   %eax
  800a03:	e8 68 17 00 00       	call   802170 <__umoddi3>
  800a08:	83 c4 10             	add    $0x10,%esp
  800a0b:	05 94 29 80 00       	add    $0x802994,%eax
  800a10:	8a 00                	mov    (%eax),%al
  800a12:	0f be c0             	movsbl %al,%eax
  800a15:	83 ec 08             	sub    $0x8,%esp
  800a18:	ff 75 0c             	pushl  0xc(%ebp)
  800a1b:	50                   	push   %eax
  800a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1f:	ff d0                	call   *%eax
  800a21:	83 c4 10             	add    $0x10,%esp
}
  800a24:	90                   	nop
  800a25:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a28:	c9                   	leave  
  800a29:	c3                   	ret    

00800a2a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800a2a:	55                   	push   %ebp
  800a2b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800a2d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800a31:	7e 1c                	jle    800a4f <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800a33:	8b 45 08             	mov    0x8(%ebp),%eax
  800a36:	8b 00                	mov    (%eax),%eax
  800a38:	8d 50 08             	lea    0x8(%eax),%edx
  800a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3e:	89 10                	mov    %edx,(%eax)
  800a40:	8b 45 08             	mov    0x8(%ebp),%eax
  800a43:	8b 00                	mov    (%eax),%eax
  800a45:	83 e8 08             	sub    $0x8,%eax
  800a48:	8b 50 04             	mov    0x4(%eax),%edx
  800a4b:	8b 00                	mov    (%eax),%eax
  800a4d:	eb 40                	jmp    800a8f <getuint+0x65>
	else if (lflag)
  800a4f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a53:	74 1e                	je     800a73 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800a55:	8b 45 08             	mov    0x8(%ebp),%eax
  800a58:	8b 00                	mov    (%eax),%eax
  800a5a:	8d 50 04             	lea    0x4(%eax),%edx
  800a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a60:	89 10                	mov    %edx,(%eax)
  800a62:	8b 45 08             	mov    0x8(%ebp),%eax
  800a65:	8b 00                	mov    (%eax),%eax
  800a67:	83 e8 04             	sub    $0x4,%eax
  800a6a:	8b 00                	mov    (%eax),%eax
  800a6c:	ba 00 00 00 00       	mov    $0x0,%edx
  800a71:	eb 1c                	jmp    800a8f <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800a73:	8b 45 08             	mov    0x8(%ebp),%eax
  800a76:	8b 00                	mov    (%eax),%eax
  800a78:	8d 50 04             	lea    0x4(%eax),%edx
  800a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7e:	89 10                	mov    %edx,(%eax)
  800a80:	8b 45 08             	mov    0x8(%ebp),%eax
  800a83:	8b 00                	mov    (%eax),%eax
  800a85:	83 e8 04             	sub    $0x4,%eax
  800a88:	8b 00                	mov    (%eax),%eax
  800a8a:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800a8f:	5d                   	pop    %ebp
  800a90:	c3                   	ret    

00800a91 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800a91:	55                   	push   %ebp
  800a92:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800a94:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800a98:	7e 1c                	jle    800ab6 <getint+0x25>
		return va_arg(*ap, long long);
  800a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9d:	8b 00                	mov    (%eax),%eax
  800a9f:	8d 50 08             	lea    0x8(%eax),%edx
  800aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa5:	89 10                	mov    %edx,(%eax)
  800aa7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aaa:	8b 00                	mov    (%eax),%eax
  800aac:	83 e8 08             	sub    $0x8,%eax
  800aaf:	8b 50 04             	mov    0x4(%eax),%edx
  800ab2:	8b 00                	mov    (%eax),%eax
  800ab4:	eb 38                	jmp    800aee <getint+0x5d>
	else if (lflag)
  800ab6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800aba:	74 1a                	je     800ad6 <getint+0x45>
		return va_arg(*ap, long);
  800abc:	8b 45 08             	mov    0x8(%ebp),%eax
  800abf:	8b 00                	mov    (%eax),%eax
  800ac1:	8d 50 04             	lea    0x4(%eax),%edx
  800ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac7:	89 10                	mov    %edx,(%eax)
  800ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  800acc:	8b 00                	mov    (%eax),%eax
  800ace:	83 e8 04             	sub    $0x4,%eax
  800ad1:	8b 00                	mov    (%eax),%eax
  800ad3:	99                   	cltd   
  800ad4:	eb 18                	jmp    800aee <getint+0x5d>
	else
		return va_arg(*ap, int);
  800ad6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad9:	8b 00                	mov    (%eax),%eax
  800adb:	8d 50 04             	lea    0x4(%eax),%edx
  800ade:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae1:	89 10                	mov    %edx,(%eax)
  800ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae6:	8b 00                	mov    (%eax),%eax
  800ae8:	83 e8 04             	sub    $0x4,%eax
  800aeb:	8b 00                	mov    (%eax),%eax
  800aed:	99                   	cltd   
}
  800aee:	5d                   	pop    %ebp
  800aef:	c3                   	ret    

00800af0 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800af0:	55                   	push   %ebp
  800af1:	89 e5                	mov    %esp,%ebp
  800af3:	56                   	push   %esi
  800af4:	53                   	push   %ebx
  800af5:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800af8:	eb 17                	jmp    800b11 <vprintfmt+0x21>
			if (ch == '\0')
  800afa:	85 db                	test   %ebx,%ebx
  800afc:	0f 84 c1 03 00 00    	je     800ec3 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800b02:	83 ec 08             	sub    $0x8,%esp
  800b05:	ff 75 0c             	pushl  0xc(%ebp)
  800b08:	53                   	push   %ebx
  800b09:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0c:	ff d0                	call   *%eax
  800b0e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b11:	8b 45 10             	mov    0x10(%ebp),%eax
  800b14:	8d 50 01             	lea    0x1(%eax),%edx
  800b17:	89 55 10             	mov    %edx,0x10(%ebp)
  800b1a:	8a 00                	mov    (%eax),%al
  800b1c:	0f b6 d8             	movzbl %al,%ebx
  800b1f:	83 fb 25             	cmp    $0x25,%ebx
  800b22:	75 d6                	jne    800afa <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800b24:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800b28:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800b2f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800b36:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800b3d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b44:	8b 45 10             	mov    0x10(%ebp),%eax
  800b47:	8d 50 01             	lea    0x1(%eax),%edx
  800b4a:	89 55 10             	mov    %edx,0x10(%ebp)
  800b4d:	8a 00                	mov    (%eax),%al
  800b4f:	0f b6 d8             	movzbl %al,%ebx
  800b52:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800b55:	83 f8 5b             	cmp    $0x5b,%eax
  800b58:	0f 87 3d 03 00 00    	ja     800e9b <vprintfmt+0x3ab>
  800b5e:	8b 04 85 b8 29 80 00 	mov    0x8029b8(,%eax,4),%eax
  800b65:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800b67:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800b6b:	eb d7                	jmp    800b44 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800b6d:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800b71:	eb d1                	jmp    800b44 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800b73:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800b7a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800b7d:	89 d0                	mov    %edx,%eax
  800b7f:	c1 e0 02             	shl    $0x2,%eax
  800b82:	01 d0                	add    %edx,%eax
  800b84:	01 c0                	add    %eax,%eax
  800b86:	01 d8                	add    %ebx,%eax
  800b88:	83 e8 30             	sub    $0x30,%eax
  800b8b:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800b8e:	8b 45 10             	mov    0x10(%ebp),%eax
  800b91:	8a 00                	mov    (%eax),%al
  800b93:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800b96:	83 fb 2f             	cmp    $0x2f,%ebx
  800b99:	7e 3e                	jle    800bd9 <vprintfmt+0xe9>
  800b9b:	83 fb 39             	cmp    $0x39,%ebx
  800b9e:	7f 39                	jg     800bd9 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ba0:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ba3:	eb d5                	jmp    800b7a <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800ba5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ba8:	83 c0 04             	add    $0x4,%eax
  800bab:	89 45 14             	mov    %eax,0x14(%ebp)
  800bae:	8b 45 14             	mov    0x14(%ebp),%eax
  800bb1:	83 e8 04             	sub    $0x4,%eax
  800bb4:	8b 00                	mov    (%eax),%eax
  800bb6:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800bb9:	eb 1f                	jmp    800bda <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800bbb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bbf:	79 83                	jns    800b44 <vprintfmt+0x54>
				width = 0;
  800bc1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800bc8:	e9 77 ff ff ff       	jmp    800b44 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800bcd:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800bd4:	e9 6b ff ff ff       	jmp    800b44 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800bd9:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800bda:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bde:	0f 89 60 ff ff ff    	jns    800b44 <vprintfmt+0x54>
				width = precision, precision = -1;
  800be4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800be7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800bea:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800bf1:	e9 4e ff ff ff       	jmp    800b44 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800bf6:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800bf9:	e9 46 ff ff ff       	jmp    800b44 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800bfe:	8b 45 14             	mov    0x14(%ebp),%eax
  800c01:	83 c0 04             	add    $0x4,%eax
  800c04:	89 45 14             	mov    %eax,0x14(%ebp)
  800c07:	8b 45 14             	mov    0x14(%ebp),%eax
  800c0a:	83 e8 04             	sub    $0x4,%eax
  800c0d:	8b 00                	mov    (%eax),%eax
  800c0f:	83 ec 08             	sub    $0x8,%esp
  800c12:	ff 75 0c             	pushl  0xc(%ebp)
  800c15:	50                   	push   %eax
  800c16:	8b 45 08             	mov    0x8(%ebp),%eax
  800c19:	ff d0                	call   *%eax
  800c1b:	83 c4 10             	add    $0x10,%esp
			break;
  800c1e:	e9 9b 02 00 00       	jmp    800ebe <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800c23:	8b 45 14             	mov    0x14(%ebp),%eax
  800c26:	83 c0 04             	add    $0x4,%eax
  800c29:	89 45 14             	mov    %eax,0x14(%ebp)
  800c2c:	8b 45 14             	mov    0x14(%ebp),%eax
  800c2f:	83 e8 04             	sub    $0x4,%eax
  800c32:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800c34:	85 db                	test   %ebx,%ebx
  800c36:	79 02                	jns    800c3a <vprintfmt+0x14a>
				err = -err;
  800c38:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800c3a:	83 fb 64             	cmp    $0x64,%ebx
  800c3d:	7f 0b                	jg     800c4a <vprintfmt+0x15a>
  800c3f:	8b 34 9d 00 28 80 00 	mov    0x802800(,%ebx,4),%esi
  800c46:	85 f6                	test   %esi,%esi
  800c48:	75 19                	jne    800c63 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800c4a:	53                   	push   %ebx
  800c4b:	68 a5 29 80 00       	push   $0x8029a5
  800c50:	ff 75 0c             	pushl  0xc(%ebp)
  800c53:	ff 75 08             	pushl  0x8(%ebp)
  800c56:	e8 70 02 00 00       	call   800ecb <printfmt>
  800c5b:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800c5e:	e9 5b 02 00 00       	jmp    800ebe <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800c63:	56                   	push   %esi
  800c64:	68 ae 29 80 00       	push   $0x8029ae
  800c69:	ff 75 0c             	pushl  0xc(%ebp)
  800c6c:	ff 75 08             	pushl  0x8(%ebp)
  800c6f:	e8 57 02 00 00       	call   800ecb <printfmt>
  800c74:	83 c4 10             	add    $0x10,%esp
			break;
  800c77:	e9 42 02 00 00       	jmp    800ebe <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800c7c:	8b 45 14             	mov    0x14(%ebp),%eax
  800c7f:	83 c0 04             	add    $0x4,%eax
  800c82:	89 45 14             	mov    %eax,0x14(%ebp)
  800c85:	8b 45 14             	mov    0x14(%ebp),%eax
  800c88:	83 e8 04             	sub    $0x4,%eax
  800c8b:	8b 30                	mov    (%eax),%esi
  800c8d:	85 f6                	test   %esi,%esi
  800c8f:	75 05                	jne    800c96 <vprintfmt+0x1a6>
				p = "(null)";
  800c91:	be b1 29 80 00       	mov    $0x8029b1,%esi
			if (width > 0 && padc != '-')
  800c96:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c9a:	7e 6d                	jle    800d09 <vprintfmt+0x219>
  800c9c:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800ca0:	74 67                	je     800d09 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ca2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ca5:	83 ec 08             	sub    $0x8,%esp
  800ca8:	50                   	push   %eax
  800ca9:	56                   	push   %esi
  800caa:	e8 1e 03 00 00       	call   800fcd <strnlen>
  800caf:	83 c4 10             	add    $0x10,%esp
  800cb2:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800cb5:	eb 16                	jmp    800ccd <vprintfmt+0x1dd>
					putch(padc, putdat);
  800cb7:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800cbb:	83 ec 08             	sub    $0x8,%esp
  800cbe:	ff 75 0c             	pushl  0xc(%ebp)
  800cc1:	50                   	push   %eax
  800cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc5:	ff d0                	call   *%eax
  800cc7:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800cca:	ff 4d e4             	decl   -0x1c(%ebp)
  800ccd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cd1:	7f e4                	jg     800cb7 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800cd3:	eb 34                	jmp    800d09 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800cd5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800cd9:	74 1c                	je     800cf7 <vprintfmt+0x207>
  800cdb:	83 fb 1f             	cmp    $0x1f,%ebx
  800cde:	7e 05                	jle    800ce5 <vprintfmt+0x1f5>
  800ce0:	83 fb 7e             	cmp    $0x7e,%ebx
  800ce3:	7e 12                	jle    800cf7 <vprintfmt+0x207>
					putch('?', putdat);
  800ce5:	83 ec 08             	sub    $0x8,%esp
  800ce8:	ff 75 0c             	pushl  0xc(%ebp)
  800ceb:	6a 3f                	push   $0x3f
  800ced:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf0:	ff d0                	call   *%eax
  800cf2:	83 c4 10             	add    $0x10,%esp
  800cf5:	eb 0f                	jmp    800d06 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800cf7:	83 ec 08             	sub    $0x8,%esp
  800cfa:	ff 75 0c             	pushl  0xc(%ebp)
  800cfd:	53                   	push   %ebx
  800cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800d01:	ff d0                	call   *%eax
  800d03:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d06:	ff 4d e4             	decl   -0x1c(%ebp)
  800d09:	89 f0                	mov    %esi,%eax
  800d0b:	8d 70 01             	lea    0x1(%eax),%esi
  800d0e:	8a 00                	mov    (%eax),%al
  800d10:	0f be d8             	movsbl %al,%ebx
  800d13:	85 db                	test   %ebx,%ebx
  800d15:	74 24                	je     800d3b <vprintfmt+0x24b>
  800d17:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d1b:	78 b8                	js     800cd5 <vprintfmt+0x1e5>
  800d1d:	ff 4d e0             	decl   -0x20(%ebp)
  800d20:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d24:	79 af                	jns    800cd5 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d26:	eb 13                	jmp    800d3b <vprintfmt+0x24b>
				putch(' ', putdat);
  800d28:	83 ec 08             	sub    $0x8,%esp
  800d2b:	ff 75 0c             	pushl  0xc(%ebp)
  800d2e:	6a 20                	push   $0x20
  800d30:	8b 45 08             	mov    0x8(%ebp),%eax
  800d33:	ff d0                	call   *%eax
  800d35:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d38:	ff 4d e4             	decl   -0x1c(%ebp)
  800d3b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d3f:	7f e7                	jg     800d28 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800d41:	e9 78 01 00 00       	jmp    800ebe <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800d46:	83 ec 08             	sub    $0x8,%esp
  800d49:	ff 75 e8             	pushl  -0x18(%ebp)
  800d4c:	8d 45 14             	lea    0x14(%ebp),%eax
  800d4f:	50                   	push   %eax
  800d50:	e8 3c fd ff ff       	call   800a91 <getint>
  800d55:	83 c4 10             	add    $0x10,%esp
  800d58:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d5b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800d5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d61:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d64:	85 d2                	test   %edx,%edx
  800d66:	79 23                	jns    800d8b <vprintfmt+0x29b>
				putch('-', putdat);
  800d68:	83 ec 08             	sub    $0x8,%esp
  800d6b:	ff 75 0c             	pushl  0xc(%ebp)
  800d6e:	6a 2d                	push   $0x2d
  800d70:	8b 45 08             	mov    0x8(%ebp),%eax
  800d73:	ff d0                	call   *%eax
  800d75:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800d78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d7b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d7e:	f7 d8                	neg    %eax
  800d80:	83 d2 00             	adc    $0x0,%edx
  800d83:	f7 da                	neg    %edx
  800d85:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d88:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800d8b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800d92:	e9 bc 00 00 00       	jmp    800e53 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800d97:	83 ec 08             	sub    $0x8,%esp
  800d9a:	ff 75 e8             	pushl  -0x18(%ebp)
  800d9d:	8d 45 14             	lea    0x14(%ebp),%eax
  800da0:	50                   	push   %eax
  800da1:	e8 84 fc ff ff       	call   800a2a <getuint>
  800da6:	83 c4 10             	add    $0x10,%esp
  800da9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dac:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800daf:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800db6:	e9 98 00 00 00       	jmp    800e53 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800dbb:	83 ec 08             	sub    $0x8,%esp
  800dbe:	ff 75 0c             	pushl  0xc(%ebp)
  800dc1:	6a 58                	push   $0x58
  800dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc6:	ff d0                	call   *%eax
  800dc8:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800dcb:	83 ec 08             	sub    $0x8,%esp
  800dce:	ff 75 0c             	pushl  0xc(%ebp)
  800dd1:	6a 58                	push   $0x58
  800dd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd6:	ff d0                	call   *%eax
  800dd8:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ddb:	83 ec 08             	sub    $0x8,%esp
  800dde:	ff 75 0c             	pushl  0xc(%ebp)
  800de1:	6a 58                	push   $0x58
  800de3:	8b 45 08             	mov    0x8(%ebp),%eax
  800de6:	ff d0                	call   *%eax
  800de8:	83 c4 10             	add    $0x10,%esp
			break;
  800deb:	e9 ce 00 00 00       	jmp    800ebe <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800df0:	83 ec 08             	sub    $0x8,%esp
  800df3:	ff 75 0c             	pushl  0xc(%ebp)
  800df6:	6a 30                	push   $0x30
  800df8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfb:	ff d0                	call   *%eax
  800dfd:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800e00:	83 ec 08             	sub    $0x8,%esp
  800e03:	ff 75 0c             	pushl  0xc(%ebp)
  800e06:	6a 78                	push   $0x78
  800e08:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0b:	ff d0                	call   *%eax
  800e0d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800e10:	8b 45 14             	mov    0x14(%ebp),%eax
  800e13:	83 c0 04             	add    $0x4,%eax
  800e16:	89 45 14             	mov    %eax,0x14(%ebp)
  800e19:	8b 45 14             	mov    0x14(%ebp),%eax
  800e1c:	83 e8 04             	sub    $0x4,%eax
  800e1f:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e21:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e24:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800e2b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800e32:	eb 1f                	jmp    800e53 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800e34:	83 ec 08             	sub    $0x8,%esp
  800e37:	ff 75 e8             	pushl  -0x18(%ebp)
  800e3a:	8d 45 14             	lea    0x14(%ebp),%eax
  800e3d:	50                   	push   %eax
  800e3e:	e8 e7 fb ff ff       	call   800a2a <getuint>
  800e43:	83 c4 10             	add    $0x10,%esp
  800e46:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e49:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800e4c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800e53:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800e57:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e5a:	83 ec 04             	sub    $0x4,%esp
  800e5d:	52                   	push   %edx
  800e5e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800e61:	50                   	push   %eax
  800e62:	ff 75 f4             	pushl  -0xc(%ebp)
  800e65:	ff 75 f0             	pushl  -0x10(%ebp)
  800e68:	ff 75 0c             	pushl  0xc(%ebp)
  800e6b:	ff 75 08             	pushl  0x8(%ebp)
  800e6e:	e8 00 fb ff ff       	call   800973 <printnum>
  800e73:	83 c4 20             	add    $0x20,%esp
			break;
  800e76:	eb 46                	jmp    800ebe <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800e78:	83 ec 08             	sub    $0x8,%esp
  800e7b:	ff 75 0c             	pushl  0xc(%ebp)
  800e7e:	53                   	push   %ebx
  800e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e82:	ff d0                	call   *%eax
  800e84:	83 c4 10             	add    $0x10,%esp
			break;
  800e87:	eb 35                	jmp    800ebe <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800e89:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800e90:	eb 2c                	jmp    800ebe <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800e92:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800e99:	eb 23                	jmp    800ebe <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800e9b:	83 ec 08             	sub    $0x8,%esp
  800e9e:	ff 75 0c             	pushl  0xc(%ebp)
  800ea1:	6a 25                	push   $0x25
  800ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea6:	ff d0                	call   *%eax
  800ea8:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800eab:	ff 4d 10             	decl   0x10(%ebp)
  800eae:	eb 03                	jmp    800eb3 <vprintfmt+0x3c3>
  800eb0:	ff 4d 10             	decl   0x10(%ebp)
  800eb3:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb6:	48                   	dec    %eax
  800eb7:	8a 00                	mov    (%eax),%al
  800eb9:	3c 25                	cmp    $0x25,%al
  800ebb:	75 f3                	jne    800eb0 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800ebd:	90                   	nop
		}
	}
  800ebe:	e9 35 fc ff ff       	jmp    800af8 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ec3:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ec4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ec7:	5b                   	pop    %ebx
  800ec8:	5e                   	pop    %esi
  800ec9:	5d                   	pop    %ebp
  800eca:	c3                   	ret    

00800ecb <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ecb:	55                   	push   %ebp
  800ecc:	89 e5                	mov    %esp,%ebp
  800ece:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ed1:	8d 45 10             	lea    0x10(%ebp),%eax
  800ed4:	83 c0 04             	add    $0x4,%eax
  800ed7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800eda:	8b 45 10             	mov    0x10(%ebp),%eax
  800edd:	ff 75 f4             	pushl  -0xc(%ebp)
  800ee0:	50                   	push   %eax
  800ee1:	ff 75 0c             	pushl  0xc(%ebp)
  800ee4:	ff 75 08             	pushl  0x8(%ebp)
  800ee7:	e8 04 fc ff ff       	call   800af0 <vprintfmt>
  800eec:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800eef:	90                   	nop
  800ef0:	c9                   	leave  
  800ef1:	c3                   	ret    

00800ef2 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ef2:	55                   	push   %ebp
  800ef3:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800ef5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef8:	8b 40 08             	mov    0x8(%eax),%eax
  800efb:	8d 50 01             	lea    0x1(%eax),%edx
  800efe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f01:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800f04:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f07:	8b 10                	mov    (%eax),%edx
  800f09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f0c:	8b 40 04             	mov    0x4(%eax),%eax
  800f0f:	39 c2                	cmp    %eax,%edx
  800f11:	73 12                	jae    800f25 <sprintputch+0x33>
		*b->buf++ = ch;
  800f13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f16:	8b 00                	mov    (%eax),%eax
  800f18:	8d 48 01             	lea    0x1(%eax),%ecx
  800f1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f1e:	89 0a                	mov    %ecx,(%edx)
  800f20:	8b 55 08             	mov    0x8(%ebp),%edx
  800f23:	88 10                	mov    %dl,(%eax)
}
  800f25:	90                   	nop
  800f26:	5d                   	pop    %ebp
  800f27:	c3                   	ret    

00800f28 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f28:	55                   	push   %ebp
  800f29:	89 e5                	mov    %esp,%ebp
  800f2b:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f31:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800f34:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f37:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3d:	01 d0                	add    %edx,%eax
  800f3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f42:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800f49:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f4d:	74 06                	je     800f55 <vsnprintf+0x2d>
  800f4f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f53:	7f 07                	jg     800f5c <vsnprintf+0x34>
		return -E_INVAL;
  800f55:	b8 03 00 00 00       	mov    $0x3,%eax
  800f5a:	eb 20                	jmp    800f7c <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800f5c:	ff 75 14             	pushl  0x14(%ebp)
  800f5f:	ff 75 10             	pushl  0x10(%ebp)
  800f62:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800f65:	50                   	push   %eax
  800f66:	68 f2 0e 80 00       	push   $0x800ef2
  800f6b:	e8 80 fb ff ff       	call   800af0 <vprintfmt>
  800f70:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800f73:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f76:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800f79:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800f7c:	c9                   	leave  
  800f7d:	c3                   	ret    

00800f7e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f7e:	55                   	push   %ebp
  800f7f:	89 e5                	mov    %esp,%ebp
  800f81:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800f84:	8d 45 10             	lea    0x10(%ebp),%eax
  800f87:	83 c0 04             	add    $0x4,%eax
  800f8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800f8d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f90:	ff 75 f4             	pushl  -0xc(%ebp)
  800f93:	50                   	push   %eax
  800f94:	ff 75 0c             	pushl  0xc(%ebp)
  800f97:	ff 75 08             	pushl  0x8(%ebp)
  800f9a:	e8 89 ff ff ff       	call   800f28 <vsnprintf>
  800f9f:	83 c4 10             	add    $0x10,%esp
  800fa2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800fa5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800fa8:	c9                   	leave  
  800fa9:	c3                   	ret    

00800faa <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800faa:	55                   	push   %ebp
  800fab:	89 e5                	mov    %esp,%ebp
  800fad:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800fb0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800fb7:	eb 06                	jmp    800fbf <strlen+0x15>
		n++;
  800fb9:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800fbc:	ff 45 08             	incl   0x8(%ebp)
  800fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc2:	8a 00                	mov    (%eax),%al
  800fc4:	84 c0                	test   %al,%al
  800fc6:	75 f1                	jne    800fb9 <strlen+0xf>
		n++;
	return n;
  800fc8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800fcb:	c9                   	leave  
  800fcc:	c3                   	ret    

00800fcd <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800fcd:	55                   	push   %ebp
  800fce:	89 e5                	mov    %esp,%ebp
  800fd0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800fd3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800fda:	eb 09                	jmp    800fe5 <strnlen+0x18>
		n++;
  800fdc:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800fdf:	ff 45 08             	incl   0x8(%ebp)
  800fe2:	ff 4d 0c             	decl   0xc(%ebp)
  800fe5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800fe9:	74 09                	je     800ff4 <strnlen+0x27>
  800feb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fee:	8a 00                	mov    (%eax),%al
  800ff0:	84 c0                	test   %al,%al
  800ff2:	75 e8                	jne    800fdc <strnlen+0xf>
		n++;
	return n;
  800ff4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ff7:	c9                   	leave  
  800ff8:	c3                   	ret    

00800ff9 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ff9:	55                   	push   %ebp
  800ffa:	89 e5                	mov    %esp,%ebp
  800ffc:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800fff:	8b 45 08             	mov    0x8(%ebp),%eax
  801002:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801005:	90                   	nop
  801006:	8b 45 08             	mov    0x8(%ebp),%eax
  801009:	8d 50 01             	lea    0x1(%eax),%edx
  80100c:	89 55 08             	mov    %edx,0x8(%ebp)
  80100f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801012:	8d 4a 01             	lea    0x1(%edx),%ecx
  801015:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801018:	8a 12                	mov    (%edx),%dl
  80101a:	88 10                	mov    %dl,(%eax)
  80101c:	8a 00                	mov    (%eax),%al
  80101e:	84 c0                	test   %al,%al
  801020:	75 e4                	jne    801006 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801022:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801025:	c9                   	leave  
  801026:	c3                   	ret    

00801027 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801027:	55                   	push   %ebp
  801028:	89 e5                	mov    %esp,%ebp
  80102a:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80102d:	8b 45 08             	mov    0x8(%ebp),%eax
  801030:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801033:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80103a:	eb 1f                	jmp    80105b <strncpy+0x34>
		*dst++ = *src;
  80103c:	8b 45 08             	mov    0x8(%ebp),%eax
  80103f:	8d 50 01             	lea    0x1(%eax),%edx
  801042:	89 55 08             	mov    %edx,0x8(%ebp)
  801045:	8b 55 0c             	mov    0xc(%ebp),%edx
  801048:	8a 12                	mov    (%edx),%dl
  80104a:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80104c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104f:	8a 00                	mov    (%eax),%al
  801051:	84 c0                	test   %al,%al
  801053:	74 03                	je     801058 <strncpy+0x31>
			src++;
  801055:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801058:	ff 45 fc             	incl   -0x4(%ebp)
  80105b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80105e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801061:	72 d9                	jb     80103c <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801063:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801066:	c9                   	leave  
  801067:	c3                   	ret    

00801068 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801068:	55                   	push   %ebp
  801069:	89 e5                	mov    %esp,%ebp
  80106b:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80106e:	8b 45 08             	mov    0x8(%ebp),%eax
  801071:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801074:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801078:	74 30                	je     8010aa <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80107a:	eb 16                	jmp    801092 <strlcpy+0x2a>
			*dst++ = *src++;
  80107c:	8b 45 08             	mov    0x8(%ebp),%eax
  80107f:	8d 50 01             	lea    0x1(%eax),%edx
  801082:	89 55 08             	mov    %edx,0x8(%ebp)
  801085:	8b 55 0c             	mov    0xc(%ebp),%edx
  801088:	8d 4a 01             	lea    0x1(%edx),%ecx
  80108b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80108e:	8a 12                	mov    (%edx),%dl
  801090:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801092:	ff 4d 10             	decl   0x10(%ebp)
  801095:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801099:	74 09                	je     8010a4 <strlcpy+0x3c>
  80109b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80109e:	8a 00                	mov    (%eax),%al
  8010a0:	84 c0                	test   %al,%al
  8010a2:	75 d8                	jne    80107c <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8010a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a7:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8010aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010b0:	29 c2                	sub    %eax,%edx
  8010b2:	89 d0                	mov    %edx,%eax
}
  8010b4:	c9                   	leave  
  8010b5:	c3                   	ret    

008010b6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8010b6:	55                   	push   %ebp
  8010b7:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8010b9:	eb 06                	jmp    8010c1 <strcmp+0xb>
		p++, q++;
  8010bb:	ff 45 08             	incl   0x8(%ebp)
  8010be:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8010c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c4:	8a 00                	mov    (%eax),%al
  8010c6:	84 c0                	test   %al,%al
  8010c8:	74 0e                	je     8010d8 <strcmp+0x22>
  8010ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cd:	8a 10                	mov    (%eax),%dl
  8010cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d2:	8a 00                	mov    (%eax),%al
  8010d4:	38 c2                	cmp    %al,%dl
  8010d6:	74 e3                	je     8010bb <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8010d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010db:	8a 00                	mov    (%eax),%al
  8010dd:	0f b6 d0             	movzbl %al,%edx
  8010e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e3:	8a 00                	mov    (%eax),%al
  8010e5:	0f b6 c0             	movzbl %al,%eax
  8010e8:	29 c2                	sub    %eax,%edx
  8010ea:	89 d0                	mov    %edx,%eax
}
  8010ec:	5d                   	pop    %ebp
  8010ed:	c3                   	ret    

008010ee <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8010ee:	55                   	push   %ebp
  8010ef:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8010f1:	eb 09                	jmp    8010fc <strncmp+0xe>
		n--, p++, q++;
  8010f3:	ff 4d 10             	decl   0x10(%ebp)
  8010f6:	ff 45 08             	incl   0x8(%ebp)
  8010f9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8010fc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801100:	74 17                	je     801119 <strncmp+0x2b>
  801102:	8b 45 08             	mov    0x8(%ebp),%eax
  801105:	8a 00                	mov    (%eax),%al
  801107:	84 c0                	test   %al,%al
  801109:	74 0e                	je     801119 <strncmp+0x2b>
  80110b:	8b 45 08             	mov    0x8(%ebp),%eax
  80110e:	8a 10                	mov    (%eax),%dl
  801110:	8b 45 0c             	mov    0xc(%ebp),%eax
  801113:	8a 00                	mov    (%eax),%al
  801115:	38 c2                	cmp    %al,%dl
  801117:	74 da                	je     8010f3 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801119:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80111d:	75 07                	jne    801126 <strncmp+0x38>
		return 0;
  80111f:	b8 00 00 00 00       	mov    $0x0,%eax
  801124:	eb 14                	jmp    80113a <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801126:	8b 45 08             	mov    0x8(%ebp),%eax
  801129:	8a 00                	mov    (%eax),%al
  80112b:	0f b6 d0             	movzbl %al,%edx
  80112e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801131:	8a 00                	mov    (%eax),%al
  801133:	0f b6 c0             	movzbl %al,%eax
  801136:	29 c2                	sub    %eax,%edx
  801138:	89 d0                	mov    %edx,%eax
}
  80113a:	5d                   	pop    %ebp
  80113b:	c3                   	ret    

0080113c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80113c:	55                   	push   %ebp
  80113d:	89 e5                	mov    %esp,%ebp
  80113f:	83 ec 04             	sub    $0x4,%esp
  801142:	8b 45 0c             	mov    0xc(%ebp),%eax
  801145:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801148:	eb 12                	jmp    80115c <strchr+0x20>
		if (*s == c)
  80114a:	8b 45 08             	mov    0x8(%ebp),%eax
  80114d:	8a 00                	mov    (%eax),%al
  80114f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801152:	75 05                	jne    801159 <strchr+0x1d>
			return (char *) s;
  801154:	8b 45 08             	mov    0x8(%ebp),%eax
  801157:	eb 11                	jmp    80116a <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801159:	ff 45 08             	incl   0x8(%ebp)
  80115c:	8b 45 08             	mov    0x8(%ebp),%eax
  80115f:	8a 00                	mov    (%eax),%al
  801161:	84 c0                	test   %al,%al
  801163:	75 e5                	jne    80114a <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801165:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80116a:	c9                   	leave  
  80116b:	c3                   	ret    

0080116c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80116c:	55                   	push   %ebp
  80116d:	89 e5                	mov    %esp,%ebp
  80116f:	83 ec 04             	sub    $0x4,%esp
  801172:	8b 45 0c             	mov    0xc(%ebp),%eax
  801175:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801178:	eb 0d                	jmp    801187 <strfind+0x1b>
		if (*s == c)
  80117a:	8b 45 08             	mov    0x8(%ebp),%eax
  80117d:	8a 00                	mov    (%eax),%al
  80117f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801182:	74 0e                	je     801192 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801184:	ff 45 08             	incl   0x8(%ebp)
  801187:	8b 45 08             	mov    0x8(%ebp),%eax
  80118a:	8a 00                	mov    (%eax),%al
  80118c:	84 c0                	test   %al,%al
  80118e:	75 ea                	jne    80117a <strfind+0xe>
  801190:	eb 01                	jmp    801193 <strfind+0x27>
		if (*s == c)
			break;
  801192:	90                   	nop
	return (char *) s;
  801193:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801196:	c9                   	leave  
  801197:	c3                   	ret    

00801198 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801198:	55                   	push   %ebp
  801199:	89 e5                	mov    %esp,%ebp
  80119b:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  80119e:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  8011a4:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8011a8:	76 63                	jbe    80120d <memset+0x75>
		uint64 data_block = c;
  8011aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ad:	99                   	cltd   
  8011ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011b1:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  8011b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011ba:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  8011be:	c1 e0 08             	shl    $0x8,%eax
  8011c1:	09 45 f0             	or     %eax,-0x10(%ebp)
  8011c4:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  8011c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011cd:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  8011d1:	c1 e0 10             	shl    $0x10,%eax
  8011d4:	09 45 f0             	or     %eax,-0x10(%ebp)
  8011d7:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  8011da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011e0:	89 c2                	mov    %eax,%edx
  8011e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8011e7:	09 45 f0             	or     %eax,-0x10(%ebp)
  8011ea:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  8011ed:	eb 18                	jmp    801207 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  8011ef:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011f2:	8d 41 08             	lea    0x8(%ecx),%eax
  8011f5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8011f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011fe:	89 01                	mov    %eax,(%ecx)
  801200:	89 51 04             	mov    %edx,0x4(%ecx)
  801203:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801207:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80120b:	77 e2                	ja     8011ef <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  80120d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801211:	74 23                	je     801236 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801213:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801216:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801219:	eb 0e                	jmp    801229 <memset+0x91>
			*p8++ = (uint8)c;
  80121b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80121e:	8d 50 01             	lea    0x1(%eax),%edx
  801221:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801224:	8b 55 0c             	mov    0xc(%ebp),%edx
  801227:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801229:	8b 45 10             	mov    0x10(%ebp),%eax
  80122c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80122f:	89 55 10             	mov    %edx,0x10(%ebp)
  801232:	85 c0                	test   %eax,%eax
  801234:	75 e5                	jne    80121b <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801236:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801239:	c9                   	leave  
  80123a:	c3                   	ret    

0080123b <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80123b:	55                   	push   %ebp
  80123c:	89 e5                	mov    %esp,%ebp
  80123e:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801241:	8b 45 0c             	mov    0xc(%ebp),%eax
  801244:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801247:	8b 45 08             	mov    0x8(%ebp),%eax
  80124a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  80124d:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801251:	76 24                	jbe    801277 <memcpy+0x3c>
		while(n >= 8){
  801253:	eb 1c                	jmp    801271 <memcpy+0x36>
			*d64 = *s64;
  801255:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801258:	8b 50 04             	mov    0x4(%eax),%edx
  80125b:	8b 00                	mov    (%eax),%eax
  80125d:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801260:	89 01                	mov    %eax,(%ecx)
  801262:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801265:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801269:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  80126d:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801271:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801275:	77 de                	ja     801255 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801277:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80127b:	74 31                	je     8012ae <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  80127d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801280:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801283:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801286:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801289:	eb 16                	jmp    8012a1 <memcpy+0x66>
			*d8++ = *s8++;
  80128b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80128e:	8d 50 01             	lea    0x1(%eax),%edx
  801291:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801294:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801297:	8d 4a 01             	lea    0x1(%edx),%ecx
  80129a:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80129d:	8a 12                	mov    (%edx),%dl
  80129f:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  8012a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012a7:	89 55 10             	mov    %edx,0x10(%ebp)
  8012aa:	85 c0                	test   %eax,%eax
  8012ac:	75 dd                	jne    80128b <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  8012ae:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012b1:	c9                   	leave  
  8012b2:	c3                   	ret    

008012b3 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8012b3:	55                   	push   %ebp
  8012b4:	89 e5                	mov    %esp,%ebp
  8012b6:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8012b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8012bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8012c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012c8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8012cb:	73 50                	jae    80131d <memmove+0x6a>
  8012cd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d3:	01 d0                	add    %edx,%eax
  8012d5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8012d8:	76 43                	jbe    80131d <memmove+0x6a>
		s += n;
  8012da:	8b 45 10             	mov    0x10(%ebp),%eax
  8012dd:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8012e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e3:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8012e6:	eb 10                	jmp    8012f8 <memmove+0x45>
			*--d = *--s;
  8012e8:	ff 4d f8             	decl   -0x8(%ebp)
  8012eb:	ff 4d fc             	decl   -0x4(%ebp)
  8012ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012f1:	8a 10                	mov    (%eax),%dl
  8012f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012f6:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8012f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8012fb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012fe:	89 55 10             	mov    %edx,0x10(%ebp)
  801301:	85 c0                	test   %eax,%eax
  801303:	75 e3                	jne    8012e8 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801305:	eb 23                	jmp    80132a <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801307:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80130a:	8d 50 01             	lea    0x1(%eax),%edx
  80130d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801310:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801313:	8d 4a 01             	lea    0x1(%edx),%ecx
  801316:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801319:	8a 12                	mov    (%edx),%dl
  80131b:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80131d:	8b 45 10             	mov    0x10(%ebp),%eax
  801320:	8d 50 ff             	lea    -0x1(%eax),%edx
  801323:	89 55 10             	mov    %edx,0x10(%ebp)
  801326:	85 c0                	test   %eax,%eax
  801328:	75 dd                	jne    801307 <memmove+0x54>
			*d++ = *s++;

	return dst;
  80132a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80132d:	c9                   	leave  
  80132e:	c3                   	ret    

0080132f <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80132f:	55                   	push   %ebp
  801330:	89 e5                	mov    %esp,%ebp
  801332:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801335:	8b 45 08             	mov    0x8(%ebp),%eax
  801338:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80133b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80133e:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801341:	eb 2a                	jmp    80136d <memcmp+0x3e>
		if (*s1 != *s2)
  801343:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801346:	8a 10                	mov    (%eax),%dl
  801348:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80134b:	8a 00                	mov    (%eax),%al
  80134d:	38 c2                	cmp    %al,%dl
  80134f:	74 16                	je     801367 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801351:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801354:	8a 00                	mov    (%eax),%al
  801356:	0f b6 d0             	movzbl %al,%edx
  801359:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80135c:	8a 00                	mov    (%eax),%al
  80135e:	0f b6 c0             	movzbl %al,%eax
  801361:	29 c2                	sub    %eax,%edx
  801363:	89 d0                	mov    %edx,%eax
  801365:	eb 18                	jmp    80137f <memcmp+0x50>
		s1++, s2++;
  801367:	ff 45 fc             	incl   -0x4(%ebp)
  80136a:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80136d:	8b 45 10             	mov    0x10(%ebp),%eax
  801370:	8d 50 ff             	lea    -0x1(%eax),%edx
  801373:	89 55 10             	mov    %edx,0x10(%ebp)
  801376:	85 c0                	test   %eax,%eax
  801378:	75 c9                	jne    801343 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80137a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80137f:	c9                   	leave  
  801380:	c3                   	ret    

00801381 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801381:	55                   	push   %ebp
  801382:	89 e5                	mov    %esp,%ebp
  801384:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801387:	8b 55 08             	mov    0x8(%ebp),%edx
  80138a:	8b 45 10             	mov    0x10(%ebp),%eax
  80138d:	01 d0                	add    %edx,%eax
  80138f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801392:	eb 15                	jmp    8013a9 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801394:	8b 45 08             	mov    0x8(%ebp),%eax
  801397:	8a 00                	mov    (%eax),%al
  801399:	0f b6 d0             	movzbl %al,%edx
  80139c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80139f:	0f b6 c0             	movzbl %al,%eax
  8013a2:	39 c2                	cmp    %eax,%edx
  8013a4:	74 0d                	je     8013b3 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8013a6:	ff 45 08             	incl   0x8(%ebp)
  8013a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ac:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8013af:	72 e3                	jb     801394 <memfind+0x13>
  8013b1:	eb 01                	jmp    8013b4 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8013b3:	90                   	nop
	return (void *) s;
  8013b4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013b7:	c9                   	leave  
  8013b8:	c3                   	ret    

008013b9 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8013b9:	55                   	push   %ebp
  8013ba:	89 e5                	mov    %esp,%ebp
  8013bc:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8013bf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8013c6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013cd:	eb 03                	jmp    8013d2 <strtol+0x19>
		s++;
  8013cf:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d5:	8a 00                	mov    (%eax),%al
  8013d7:	3c 20                	cmp    $0x20,%al
  8013d9:	74 f4                	je     8013cf <strtol+0x16>
  8013db:	8b 45 08             	mov    0x8(%ebp),%eax
  8013de:	8a 00                	mov    (%eax),%al
  8013e0:	3c 09                	cmp    $0x9,%al
  8013e2:	74 eb                	je     8013cf <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8013e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e7:	8a 00                	mov    (%eax),%al
  8013e9:	3c 2b                	cmp    $0x2b,%al
  8013eb:	75 05                	jne    8013f2 <strtol+0x39>
		s++;
  8013ed:	ff 45 08             	incl   0x8(%ebp)
  8013f0:	eb 13                	jmp    801405 <strtol+0x4c>
	else if (*s == '-')
  8013f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f5:	8a 00                	mov    (%eax),%al
  8013f7:	3c 2d                	cmp    $0x2d,%al
  8013f9:	75 0a                	jne    801405 <strtol+0x4c>
		s++, neg = 1;
  8013fb:	ff 45 08             	incl   0x8(%ebp)
  8013fe:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801405:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801409:	74 06                	je     801411 <strtol+0x58>
  80140b:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80140f:	75 20                	jne    801431 <strtol+0x78>
  801411:	8b 45 08             	mov    0x8(%ebp),%eax
  801414:	8a 00                	mov    (%eax),%al
  801416:	3c 30                	cmp    $0x30,%al
  801418:	75 17                	jne    801431 <strtol+0x78>
  80141a:	8b 45 08             	mov    0x8(%ebp),%eax
  80141d:	40                   	inc    %eax
  80141e:	8a 00                	mov    (%eax),%al
  801420:	3c 78                	cmp    $0x78,%al
  801422:	75 0d                	jne    801431 <strtol+0x78>
		s += 2, base = 16;
  801424:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801428:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80142f:	eb 28                	jmp    801459 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801431:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801435:	75 15                	jne    80144c <strtol+0x93>
  801437:	8b 45 08             	mov    0x8(%ebp),%eax
  80143a:	8a 00                	mov    (%eax),%al
  80143c:	3c 30                	cmp    $0x30,%al
  80143e:	75 0c                	jne    80144c <strtol+0x93>
		s++, base = 8;
  801440:	ff 45 08             	incl   0x8(%ebp)
  801443:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80144a:	eb 0d                	jmp    801459 <strtol+0xa0>
	else if (base == 0)
  80144c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801450:	75 07                	jne    801459 <strtol+0xa0>
		base = 10;
  801452:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801459:	8b 45 08             	mov    0x8(%ebp),%eax
  80145c:	8a 00                	mov    (%eax),%al
  80145e:	3c 2f                	cmp    $0x2f,%al
  801460:	7e 19                	jle    80147b <strtol+0xc2>
  801462:	8b 45 08             	mov    0x8(%ebp),%eax
  801465:	8a 00                	mov    (%eax),%al
  801467:	3c 39                	cmp    $0x39,%al
  801469:	7f 10                	jg     80147b <strtol+0xc2>
			dig = *s - '0';
  80146b:	8b 45 08             	mov    0x8(%ebp),%eax
  80146e:	8a 00                	mov    (%eax),%al
  801470:	0f be c0             	movsbl %al,%eax
  801473:	83 e8 30             	sub    $0x30,%eax
  801476:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801479:	eb 42                	jmp    8014bd <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80147b:	8b 45 08             	mov    0x8(%ebp),%eax
  80147e:	8a 00                	mov    (%eax),%al
  801480:	3c 60                	cmp    $0x60,%al
  801482:	7e 19                	jle    80149d <strtol+0xe4>
  801484:	8b 45 08             	mov    0x8(%ebp),%eax
  801487:	8a 00                	mov    (%eax),%al
  801489:	3c 7a                	cmp    $0x7a,%al
  80148b:	7f 10                	jg     80149d <strtol+0xe4>
			dig = *s - 'a' + 10;
  80148d:	8b 45 08             	mov    0x8(%ebp),%eax
  801490:	8a 00                	mov    (%eax),%al
  801492:	0f be c0             	movsbl %al,%eax
  801495:	83 e8 57             	sub    $0x57,%eax
  801498:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80149b:	eb 20                	jmp    8014bd <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80149d:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a0:	8a 00                	mov    (%eax),%al
  8014a2:	3c 40                	cmp    $0x40,%al
  8014a4:	7e 39                	jle    8014df <strtol+0x126>
  8014a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a9:	8a 00                	mov    (%eax),%al
  8014ab:	3c 5a                	cmp    $0x5a,%al
  8014ad:	7f 30                	jg     8014df <strtol+0x126>
			dig = *s - 'A' + 10;
  8014af:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b2:	8a 00                	mov    (%eax),%al
  8014b4:	0f be c0             	movsbl %al,%eax
  8014b7:	83 e8 37             	sub    $0x37,%eax
  8014ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8014bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014c0:	3b 45 10             	cmp    0x10(%ebp),%eax
  8014c3:	7d 19                	jge    8014de <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8014c5:	ff 45 08             	incl   0x8(%ebp)
  8014c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014cb:	0f af 45 10          	imul   0x10(%ebp),%eax
  8014cf:	89 c2                	mov    %eax,%edx
  8014d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014d4:	01 d0                	add    %edx,%eax
  8014d6:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8014d9:	e9 7b ff ff ff       	jmp    801459 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8014de:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8014df:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8014e3:	74 08                	je     8014ed <strtol+0x134>
		*endptr = (char *) s;
  8014e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8014eb:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8014ed:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8014f1:	74 07                	je     8014fa <strtol+0x141>
  8014f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014f6:	f7 d8                	neg    %eax
  8014f8:	eb 03                	jmp    8014fd <strtol+0x144>
  8014fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014fd:	c9                   	leave  
  8014fe:	c3                   	ret    

008014ff <ltostr>:

void
ltostr(long value, char *str)
{
  8014ff:	55                   	push   %ebp
  801500:	89 e5                	mov    %esp,%ebp
  801502:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801505:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80150c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801513:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801517:	79 13                	jns    80152c <ltostr+0x2d>
	{
		neg = 1;
  801519:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801520:	8b 45 0c             	mov    0xc(%ebp),%eax
  801523:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801526:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801529:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80152c:	8b 45 08             	mov    0x8(%ebp),%eax
  80152f:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801534:	99                   	cltd   
  801535:	f7 f9                	idiv   %ecx
  801537:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80153a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80153d:	8d 50 01             	lea    0x1(%eax),%edx
  801540:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801543:	89 c2                	mov    %eax,%edx
  801545:	8b 45 0c             	mov    0xc(%ebp),%eax
  801548:	01 d0                	add    %edx,%eax
  80154a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80154d:	83 c2 30             	add    $0x30,%edx
  801550:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801552:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801555:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80155a:	f7 e9                	imul   %ecx
  80155c:	c1 fa 02             	sar    $0x2,%edx
  80155f:	89 c8                	mov    %ecx,%eax
  801561:	c1 f8 1f             	sar    $0x1f,%eax
  801564:	29 c2                	sub    %eax,%edx
  801566:	89 d0                	mov    %edx,%eax
  801568:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80156b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80156f:	75 bb                	jne    80152c <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801571:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801578:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80157b:	48                   	dec    %eax
  80157c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80157f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801583:	74 3d                	je     8015c2 <ltostr+0xc3>
		start = 1 ;
  801585:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80158c:	eb 34                	jmp    8015c2 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80158e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801591:	8b 45 0c             	mov    0xc(%ebp),%eax
  801594:	01 d0                	add    %edx,%eax
  801596:	8a 00                	mov    (%eax),%al
  801598:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80159b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80159e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a1:	01 c2                	add    %eax,%edx
  8015a3:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8015a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a9:	01 c8                	add    %ecx,%eax
  8015ab:	8a 00                	mov    (%eax),%al
  8015ad:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8015af:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b5:	01 c2                	add    %eax,%edx
  8015b7:	8a 45 eb             	mov    -0x15(%ebp),%al
  8015ba:	88 02                	mov    %al,(%edx)
		start++ ;
  8015bc:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8015bf:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8015c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015c5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8015c8:	7c c4                	jl     80158e <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8015ca:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8015cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d0:	01 d0                	add    %edx,%eax
  8015d2:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8015d5:	90                   	nop
  8015d6:	c9                   	leave  
  8015d7:	c3                   	ret    

008015d8 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8015d8:	55                   	push   %ebp
  8015d9:	89 e5                	mov    %esp,%ebp
  8015db:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8015de:	ff 75 08             	pushl  0x8(%ebp)
  8015e1:	e8 c4 f9 ff ff       	call   800faa <strlen>
  8015e6:	83 c4 04             	add    $0x4,%esp
  8015e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8015ec:	ff 75 0c             	pushl  0xc(%ebp)
  8015ef:	e8 b6 f9 ff ff       	call   800faa <strlen>
  8015f4:	83 c4 04             	add    $0x4,%esp
  8015f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8015fa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801601:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801608:	eb 17                	jmp    801621 <strcconcat+0x49>
		final[s] = str1[s] ;
  80160a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80160d:	8b 45 10             	mov    0x10(%ebp),%eax
  801610:	01 c2                	add    %eax,%edx
  801612:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801615:	8b 45 08             	mov    0x8(%ebp),%eax
  801618:	01 c8                	add    %ecx,%eax
  80161a:	8a 00                	mov    (%eax),%al
  80161c:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80161e:	ff 45 fc             	incl   -0x4(%ebp)
  801621:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801624:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801627:	7c e1                	jl     80160a <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801629:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801630:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801637:	eb 1f                	jmp    801658 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801639:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80163c:	8d 50 01             	lea    0x1(%eax),%edx
  80163f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801642:	89 c2                	mov    %eax,%edx
  801644:	8b 45 10             	mov    0x10(%ebp),%eax
  801647:	01 c2                	add    %eax,%edx
  801649:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80164c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80164f:	01 c8                	add    %ecx,%eax
  801651:	8a 00                	mov    (%eax),%al
  801653:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801655:	ff 45 f8             	incl   -0x8(%ebp)
  801658:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80165b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80165e:	7c d9                	jl     801639 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801660:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801663:	8b 45 10             	mov    0x10(%ebp),%eax
  801666:	01 d0                	add    %edx,%eax
  801668:	c6 00 00             	movb   $0x0,(%eax)
}
  80166b:	90                   	nop
  80166c:	c9                   	leave  
  80166d:	c3                   	ret    

0080166e <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80166e:	55                   	push   %ebp
  80166f:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801671:	8b 45 14             	mov    0x14(%ebp),%eax
  801674:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80167a:	8b 45 14             	mov    0x14(%ebp),%eax
  80167d:	8b 00                	mov    (%eax),%eax
  80167f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801686:	8b 45 10             	mov    0x10(%ebp),%eax
  801689:	01 d0                	add    %edx,%eax
  80168b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801691:	eb 0c                	jmp    80169f <strsplit+0x31>
			*string++ = 0;
  801693:	8b 45 08             	mov    0x8(%ebp),%eax
  801696:	8d 50 01             	lea    0x1(%eax),%edx
  801699:	89 55 08             	mov    %edx,0x8(%ebp)
  80169c:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80169f:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a2:	8a 00                	mov    (%eax),%al
  8016a4:	84 c0                	test   %al,%al
  8016a6:	74 18                	je     8016c0 <strsplit+0x52>
  8016a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ab:	8a 00                	mov    (%eax),%al
  8016ad:	0f be c0             	movsbl %al,%eax
  8016b0:	50                   	push   %eax
  8016b1:	ff 75 0c             	pushl  0xc(%ebp)
  8016b4:	e8 83 fa ff ff       	call   80113c <strchr>
  8016b9:	83 c4 08             	add    $0x8,%esp
  8016bc:	85 c0                	test   %eax,%eax
  8016be:	75 d3                	jne    801693 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8016c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c3:	8a 00                	mov    (%eax),%al
  8016c5:	84 c0                	test   %al,%al
  8016c7:	74 5a                	je     801723 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8016c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8016cc:	8b 00                	mov    (%eax),%eax
  8016ce:	83 f8 0f             	cmp    $0xf,%eax
  8016d1:	75 07                	jne    8016da <strsplit+0x6c>
		{
			return 0;
  8016d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8016d8:	eb 66                	jmp    801740 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8016da:	8b 45 14             	mov    0x14(%ebp),%eax
  8016dd:	8b 00                	mov    (%eax),%eax
  8016df:	8d 48 01             	lea    0x1(%eax),%ecx
  8016e2:	8b 55 14             	mov    0x14(%ebp),%edx
  8016e5:	89 0a                	mov    %ecx,(%edx)
  8016e7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8016f1:	01 c2                	add    %eax,%edx
  8016f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f6:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016f8:	eb 03                	jmp    8016fd <strsplit+0x8f>
			string++;
  8016fa:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801700:	8a 00                	mov    (%eax),%al
  801702:	84 c0                	test   %al,%al
  801704:	74 8b                	je     801691 <strsplit+0x23>
  801706:	8b 45 08             	mov    0x8(%ebp),%eax
  801709:	8a 00                	mov    (%eax),%al
  80170b:	0f be c0             	movsbl %al,%eax
  80170e:	50                   	push   %eax
  80170f:	ff 75 0c             	pushl  0xc(%ebp)
  801712:	e8 25 fa ff ff       	call   80113c <strchr>
  801717:	83 c4 08             	add    $0x8,%esp
  80171a:	85 c0                	test   %eax,%eax
  80171c:	74 dc                	je     8016fa <strsplit+0x8c>
			string++;
	}
  80171e:	e9 6e ff ff ff       	jmp    801691 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801723:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801724:	8b 45 14             	mov    0x14(%ebp),%eax
  801727:	8b 00                	mov    (%eax),%eax
  801729:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801730:	8b 45 10             	mov    0x10(%ebp),%eax
  801733:	01 d0                	add    %edx,%eax
  801735:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80173b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801740:	c9                   	leave  
  801741:	c3                   	ret    

00801742 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801742:	55                   	push   %ebp
  801743:	89 e5                	mov    %esp,%ebp
  801745:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801748:	8b 45 08             	mov    0x8(%ebp),%eax
  80174b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  80174e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801755:	eb 4a                	jmp    8017a1 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801757:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80175a:	8b 45 08             	mov    0x8(%ebp),%eax
  80175d:	01 c2                	add    %eax,%edx
  80175f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801762:	8b 45 0c             	mov    0xc(%ebp),%eax
  801765:	01 c8                	add    %ecx,%eax
  801767:	8a 00                	mov    (%eax),%al
  801769:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  80176b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80176e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801771:	01 d0                	add    %edx,%eax
  801773:	8a 00                	mov    (%eax),%al
  801775:	3c 40                	cmp    $0x40,%al
  801777:	7e 25                	jle    80179e <str2lower+0x5c>
  801779:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80177c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80177f:	01 d0                	add    %edx,%eax
  801781:	8a 00                	mov    (%eax),%al
  801783:	3c 5a                	cmp    $0x5a,%al
  801785:	7f 17                	jg     80179e <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801787:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80178a:	8b 45 08             	mov    0x8(%ebp),%eax
  80178d:	01 d0                	add    %edx,%eax
  80178f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801792:	8b 55 08             	mov    0x8(%ebp),%edx
  801795:	01 ca                	add    %ecx,%edx
  801797:	8a 12                	mov    (%edx),%dl
  801799:	83 c2 20             	add    $0x20,%edx
  80179c:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80179e:	ff 45 fc             	incl   -0x4(%ebp)
  8017a1:	ff 75 0c             	pushl  0xc(%ebp)
  8017a4:	e8 01 f8 ff ff       	call   800faa <strlen>
  8017a9:	83 c4 04             	add    $0x4,%esp
  8017ac:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8017af:	7f a6                	jg     801757 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8017b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8017b4:	c9                   	leave  
  8017b5:	c3                   	ret    

008017b6 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  8017b6:	55                   	push   %ebp
  8017b7:	89 e5                	mov    %esp,%ebp
  8017b9:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  8017bc:	a1 08 30 80 00       	mov    0x803008,%eax
  8017c1:	85 c0                	test   %eax,%eax
  8017c3:	74 42                	je     801807 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  8017c5:	83 ec 08             	sub    $0x8,%esp
  8017c8:	68 00 00 00 82       	push   $0x82000000
  8017cd:	68 00 00 00 80       	push   $0x80000000
  8017d2:	e8 8c 07 00 00       	call   801f63 <initialize_dynamic_allocator>
  8017d7:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  8017da:	e8 e7 05 00 00       	call   801dc6 <sys_get_uheap_strategy>
  8017df:	a3 60 b0 81 00       	mov    %eax,0x81b060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  8017e4:	a1 40 30 80 00       	mov    0x803040,%eax
  8017e9:	05 00 10 00 00       	add    $0x1000,%eax
  8017ee:	a3 10 b1 81 00       	mov    %eax,0x81b110
		uheapPageAllocBreak = uheapPageAllocStart;
  8017f3:	a1 10 b1 81 00       	mov    0x81b110,%eax
  8017f8:	a3 68 b0 81 00       	mov    %eax,0x81b068

		__firstTimeFlag = 0;
  8017fd:	c7 05 08 30 80 00 00 	movl   $0x0,0x803008
  801804:	00 00 00 
	}
}
  801807:	90                   	nop
  801808:	c9                   	leave  
  801809:	c3                   	ret    

0080180a <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  80180a:	55                   	push   %ebp
  80180b:	89 e5                	mov    %esp,%ebp
  80180d:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801810:	8b 45 08             	mov    0x8(%ebp),%eax
  801813:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801816:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801819:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80181e:	83 ec 08             	sub    $0x8,%esp
  801821:	68 06 04 00 00       	push   $0x406
  801826:	50                   	push   %eax
  801827:	e8 e4 01 00 00       	call   801a10 <__sys_allocate_page>
  80182c:	83 c4 10             	add    $0x10,%esp
  80182f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801832:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801836:	79 14                	jns    80184c <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801838:	83 ec 04             	sub    $0x4,%esp
  80183b:	68 28 2b 80 00       	push   $0x802b28
  801840:	6a 1f                	push   $0x1f
  801842:	68 64 2b 80 00       	push   $0x802b64
  801847:	e8 b7 ed ff ff       	call   800603 <_panic>
	return 0;
  80184c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801851:	c9                   	leave  
  801852:	c3                   	ret    

00801853 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801853:	55                   	push   %ebp
  801854:	89 e5                	mov    %esp,%ebp
  801856:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801859:	8b 45 08             	mov    0x8(%ebp),%eax
  80185c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80185f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801862:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801867:	83 ec 0c             	sub    $0xc,%esp
  80186a:	50                   	push   %eax
  80186b:	e8 e7 01 00 00       	call   801a57 <__sys_unmap_frame>
  801870:	83 c4 10             	add    $0x10,%esp
  801873:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801876:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80187a:	79 14                	jns    801890 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  80187c:	83 ec 04             	sub    $0x4,%esp
  80187f:	68 70 2b 80 00       	push   $0x802b70
  801884:	6a 2a                	push   $0x2a
  801886:	68 64 2b 80 00       	push   $0x802b64
  80188b:	e8 73 ed ff ff       	call   800603 <_panic>
}
  801890:	90                   	nop
  801891:	c9                   	leave  
  801892:	c3                   	ret    

00801893 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801893:	55                   	push   %ebp
  801894:	89 e5                	mov    %esp,%ebp
  801896:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801899:	e8 18 ff ff ff       	call   8017b6 <uheap_init>
	if (size == 0) return NULL ;
  80189e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018a2:	75 07                	jne    8018ab <malloc+0x18>
  8018a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8018a9:	eb 14                	jmp    8018bf <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  8018ab:	83 ec 04             	sub    $0x4,%esp
  8018ae:	68 b0 2b 80 00       	push   $0x802bb0
  8018b3:	6a 3e                	push   $0x3e
  8018b5:	68 64 2b 80 00       	push   $0x802b64
  8018ba:	e8 44 ed ff ff       	call   800603 <_panic>
}
  8018bf:	c9                   	leave  
  8018c0:	c3                   	ret    

008018c1 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  8018c1:	55                   	push   %ebp
  8018c2:	89 e5                	mov    %esp,%ebp
  8018c4:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  8018c7:	83 ec 04             	sub    $0x4,%esp
  8018ca:	68 d8 2b 80 00       	push   $0x802bd8
  8018cf:	6a 49                	push   $0x49
  8018d1:	68 64 2b 80 00       	push   $0x802b64
  8018d6:	e8 28 ed ff ff       	call   800603 <_panic>

008018db <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8018db:	55                   	push   %ebp
  8018dc:	89 e5                	mov    %esp,%ebp
  8018de:	83 ec 18             	sub    $0x18,%esp
  8018e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8018e4:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8018e7:	e8 ca fe ff ff       	call   8017b6 <uheap_init>
	if (size == 0) return NULL ;
  8018ec:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8018f0:	75 07                	jne    8018f9 <smalloc+0x1e>
  8018f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8018f7:	eb 14                	jmp    80190d <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  8018f9:	83 ec 04             	sub    $0x4,%esp
  8018fc:	68 fc 2b 80 00       	push   $0x802bfc
  801901:	6a 5a                	push   $0x5a
  801903:	68 64 2b 80 00       	push   $0x802b64
  801908:	e8 f6 ec ff ff       	call   800603 <_panic>
}
  80190d:	c9                   	leave  
  80190e:	c3                   	ret    

0080190f <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80190f:	55                   	push   %ebp
  801910:	89 e5                	mov    %esp,%ebp
  801912:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801915:	e8 9c fe ff ff       	call   8017b6 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  80191a:	83 ec 04             	sub    $0x4,%esp
  80191d:	68 24 2c 80 00       	push   $0x802c24
  801922:	6a 6a                	push   $0x6a
  801924:	68 64 2b 80 00       	push   $0x802b64
  801929:	e8 d5 ec ff ff       	call   800603 <_panic>

0080192e <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80192e:	55                   	push   %ebp
  80192f:	89 e5                	mov    %esp,%ebp
  801931:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801934:	e8 7d fe ff ff       	call   8017b6 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  801939:	83 ec 04             	sub    $0x4,%esp
  80193c:	68 48 2c 80 00       	push   $0x802c48
  801941:	68 88 00 00 00       	push   $0x88
  801946:	68 64 2b 80 00       	push   $0x802b64
  80194b:	e8 b3 ec ff ff       	call   800603 <_panic>

00801950 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  801950:	55                   	push   %ebp
  801951:	89 e5                	mov    %esp,%ebp
  801953:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  801956:	83 ec 04             	sub    $0x4,%esp
  801959:	68 70 2c 80 00       	push   $0x802c70
  80195e:	68 9b 00 00 00       	push   $0x9b
  801963:	68 64 2b 80 00       	push   $0x802b64
  801968:	e8 96 ec ff ff       	call   800603 <_panic>

0080196d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80196d:	55                   	push   %ebp
  80196e:	89 e5                	mov    %esp,%ebp
  801970:	57                   	push   %edi
  801971:	56                   	push   %esi
  801972:	53                   	push   %ebx
  801973:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801976:	8b 45 08             	mov    0x8(%ebp),%eax
  801979:	8b 55 0c             	mov    0xc(%ebp),%edx
  80197c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80197f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801982:	8b 7d 18             	mov    0x18(%ebp),%edi
  801985:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801988:	cd 30                	int    $0x30
  80198a:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  80198d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801990:	83 c4 10             	add    $0x10,%esp
  801993:	5b                   	pop    %ebx
  801994:	5e                   	pop    %esi
  801995:	5f                   	pop    %edi
  801996:	5d                   	pop    %ebp
  801997:	c3                   	ret    

00801998 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801998:	55                   	push   %ebp
  801999:	89 e5                	mov    %esp,%ebp
  80199b:	83 ec 04             	sub    $0x4,%esp
  80199e:	8b 45 10             	mov    0x10(%ebp),%eax
  8019a1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8019a4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8019a7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ae:	6a 00                	push   $0x0
  8019b0:	51                   	push   %ecx
  8019b1:	52                   	push   %edx
  8019b2:	ff 75 0c             	pushl  0xc(%ebp)
  8019b5:	50                   	push   %eax
  8019b6:	6a 00                	push   $0x0
  8019b8:	e8 b0 ff ff ff       	call   80196d <syscall>
  8019bd:	83 c4 18             	add    $0x18,%esp
}
  8019c0:	90                   	nop
  8019c1:	c9                   	leave  
  8019c2:	c3                   	ret    

008019c3 <sys_cgetc>:

int
sys_cgetc(void)
{
  8019c3:	55                   	push   %ebp
  8019c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8019c6:	6a 00                	push   $0x0
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 02                	push   $0x2
  8019d2:	e8 96 ff ff ff       	call   80196d <syscall>
  8019d7:	83 c4 18             	add    $0x18,%esp
}
  8019da:	c9                   	leave  
  8019db:	c3                   	ret    

008019dc <sys_lock_cons>:

void sys_lock_cons(void)
{
  8019dc:	55                   	push   %ebp
  8019dd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 03                	push   $0x3
  8019eb:	e8 7d ff ff ff       	call   80196d <syscall>
  8019f0:	83 c4 18             	add    $0x18,%esp
}
  8019f3:	90                   	nop
  8019f4:	c9                   	leave  
  8019f5:	c3                   	ret    

008019f6 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8019f6:	55                   	push   %ebp
  8019f7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 00                	push   $0x0
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 00                	push   $0x0
  801a01:	6a 00                	push   $0x0
  801a03:	6a 04                	push   $0x4
  801a05:	e8 63 ff ff ff       	call   80196d <syscall>
  801a0a:	83 c4 18             	add    $0x18,%esp
}
  801a0d:	90                   	nop
  801a0e:	c9                   	leave  
  801a0f:	c3                   	ret    

00801a10 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801a10:	55                   	push   %ebp
  801a11:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801a13:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a16:	8b 45 08             	mov    0x8(%ebp),%eax
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 00                	push   $0x0
  801a1f:	52                   	push   %edx
  801a20:	50                   	push   %eax
  801a21:	6a 08                	push   $0x8
  801a23:	e8 45 ff ff ff       	call   80196d <syscall>
  801a28:	83 c4 18             	add    $0x18,%esp
}
  801a2b:	c9                   	leave  
  801a2c:	c3                   	ret    

00801a2d <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801a2d:	55                   	push   %ebp
  801a2e:	89 e5                	mov    %esp,%ebp
  801a30:	56                   	push   %esi
  801a31:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801a32:	8b 75 18             	mov    0x18(%ebp),%esi
  801a35:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a38:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a41:	56                   	push   %esi
  801a42:	53                   	push   %ebx
  801a43:	51                   	push   %ecx
  801a44:	52                   	push   %edx
  801a45:	50                   	push   %eax
  801a46:	6a 09                	push   $0x9
  801a48:	e8 20 ff ff ff       	call   80196d <syscall>
  801a4d:	83 c4 18             	add    $0x18,%esp
}
  801a50:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a53:	5b                   	pop    %ebx
  801a54:	5e                   	pop    %esi
  801a55:	5d                   	pop    %ebp
  801a56:	c3                   	ret    

00801a57 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801a57:	55                   	push   %ebp
  801a58:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801a5a:	6a 00                	push   $0x0
  801a5c:	6a 00                	push   $0x0
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 00                	push   $0x0
  801a62:	ff 75 08             	pushl  0x8(%ebp)
  801a65:	6a 0a                	push   $0xa
  801a67:	e8 01 ff ff ff       	call   80196d <syscall>
  801a6c:	83 c4 18             	add    $0x18,%esp
}
  801a6f:	c9                   	leave  
  801a70:	c3                   	ret    

00801a71 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a71:	55                   	push   %ebp
  801a72:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a74:	6a 00                	push   $0x0
  801a76:	6a 00                	push   $0x0
  801a78:	6a 00                	push   $0x0
  801a7a:	ff 75 0c             	pushl  0xc(%ebp)
  801a7d:	ff 75 08             	pushl  0x8(%ebp)
  801a80:	6a 0b                	push   $0xb
  801a82:	e8 e6 fe ff ff       	call   80196d <syscall>
  801a87:	83 c4 18             	add    $0x18,%esp
}
  801a8a:	c9                   	leave  
  801a8b:	c3                   	ret    

00801a8c <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a8c:	55                   	push   %ebp
  801a8d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 00                	push   $0x0
  801a93:	6a 00                	push   $0x0
  801a95:	6a 00                	push   $0x0
  801a97:	6a 00                	push   $0x0
  801a99:	6a 0c                	push   $0xc
  801a9b:	e8 cd fe ff ff       	call   80196d <syscall>
  801aa0:	83 c4 18             	add    $0x18,%esp
}
  801aa3:	c9                   	leave  
  801aa4:	c3                   	ret    

00801aa5 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801aa5:	55                   	push   %ebp
  801aa6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801aa8:	6a 00                	push   $0x0
  801aaa:	6a 00                	push   $0x0
  801aac:	6a 00                	push   $0x0
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 0d                	push   $0xd
  801ab4:	e8 b4 fe ff ff       	call   80196d <syscall>
  801ab9:	83 c4 18             	add    $0x18,%esp
}
  801abc:	c9                   	leave  
  801abd:	c3                   	ret    

00801abe <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801abe:	55                   	push   %ebp
  801abf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801ac1:	6a 00                	push   $0x0
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 0e                	push   $0xe
  801acd:	e8 9b fe ff ff       	call   80196d <syscall>
  801ad2:	83 c4 18             	add    $0x18,%esp
}
  801ad5:	c9                   	leave  
  801ad6:	c3                   	ret    

00801ad7 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801ad7:	55                   	push   %ebp
  801ad8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801ada:	6a 00                	push   $0x0
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 00                	push   $0x0
  801ae4:	6a 0f                	push   $0xf
  801ae6:	e8 82 fe ff ff       	call   80196d <syscall>
  801aeb:	83 c4 18             	add    $0x18,%esp
}
  801aee:	c9                   	leave  
  801aef:	c3                   	ret    

00801af0 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801af0:	55                   	push   %ebp
  801af1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801af3:	6a 00                	push   $0x0
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	ff 75 08             	pushl  0x8(%ebp)
  801afe:	6a 10                	push   $0x10
  801b00:	e8 68 fe ff ff       	call   80196d <syscall>
  801b05:	83 c4 18             	add    $0x18,%esp
}
  801b08:	c9                   	leave  
  801b09:	c3                   	ret    

00801b0a <sys_scarce_memory>:

void sys_scarce_memory()
{
  801b0a:	55                   	push   %ebp
  801b0b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 00                	push   $0x0
  801b13:	6a 00                	push   $0x0
  801b15:	6a 00                	push   $0x0
  801b17:	6a 11                	push   $0x11
  801b19:	e8 4f fe ff ff       	call   80196d <syscall>
  801b1e:	83 c4 18             	add    $0x18,%esp
}
  801b21:	90                   	nop
  801b22:	c9                   	leave  
  801b23:	c3                   	ret    

00801b24 <sys_cputc>:

void
sys_cputc(const char c)
{
  801b24:	55                   	push   %ebp
  801b25:	89 e5                	mov    %esp,%ebp
  801b27:	83 ec 04             	sub    $0x4,%esp
  801b2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b30:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b34:	6a 00                	push   $0x0
  801b36:	6a 00                	push   $0x0
  801b38:	6a 00                	push   $0x0
  801b3a:	6a 00                	push   $0x0
  801b3c:	50                   	push   %eax
  801b3d:	6a 01                	push   $0x1
  801b3f:	e8 29 fe ff ff       	call   80196d <syscall>
  801b44:	83 c4 18             	add    $0x18,%esp
}
  801b47:	90                   	nop
  801b48:	c9                   	leave  
  801b49:	c3                   	ret    

00801b4a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b4a:	55                   	push   %ebp
  801b4b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b4d:	6a 00                	push   $0x0
  801b4f:	6a 00                	push   $0x0
  801b51:	6a 00                	push   $0x0
  801b53:	6a 00                	push   $0x0
  801b55:	6a 00                	push   $0x0
  801b57:	6a 14                	push   $0x14
  801b59:	e8 0f fe ff ff       	call   80196d <syscall>
  801b5e:	83 c4 18             	add    $0x18,%esp
}
  801b61:	90                   	nop
  801b62:	c9                   	leave  
  801b63:	c3                   	ret    

00801b64 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b64:	55                   	push   %ebp
  801b65:	89 e5                	mov    %esp,%ebp
  801b67:	83 ec 04             	sub    $0x4,%esp
  801b6a:	8b 45 10             	mov    0x10(%ebp),%eax
  801b6d:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b70:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b73:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b77:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7a:	6a 00                	push   $0x0
  801b7c:	51                   	push   %ecx
  801b7d:	52                   	push   %edx
  801b7e:	ff 75 0c             	pushl  0xc(%ebp)
  801b81:	50                   	push   %eax
  801b82:	6a 15                	push   $0x15
  801b84:	e8 e4 fd ff ff       	call   80196d <syscall>
  801b89:	83 c4 18             	add    $0x18,%esp
}
  801b8c:	c9                   	leave  
  801b8d:	c3                   	ret    

00801b8e <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801b8e:	55                   	push   %ebp
  801b8f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b91:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b94:	8b 45 08             	mov    0x8(%ebp),%eax
  801b97:	6a 00                	push   $0x0
  801b99:	6a 00                	push   $0x0
  801b9b:	6a 00                	push   $0x0
  801b9d:	52                   	push   %edx
  801b9e:	50                   	push   %eax
  801b9f:	6a 16                	push   $0x16
  801ba1:	e8 c7 fd ff ff       	call   80196d <syscall>
  801ba6:	83 c4 18             	add    $0x18,%esp
}
  801ba9:	c9                   	leave  
  801baa:	c3                   	ret    

00801bab <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801bab:	55                   	push   %ebp
  801bac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801bae:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bb1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb7:	6a 00                	push   $0x0
  801bb9:	6a 00                	push   $0x0
  801bbb:	51                   	push   %ecx
  801bbc:	52                   	push   %edx
  801bbd:	50                   	push   %eax
  801bbe:	6a 17                	push   $0x17
  801bc0:	e8 a8 fd ff ff       	call   80196d <syscall>
  801bc5:	83 c4 18             	add    $0x18,%esp
}
  801bc8:	c9                   	leave  
  801bc9:	c3                   	ret    

00801bca <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801bca:	55                   	push   %ebp
  801bcb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801bcd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bd0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 00                	push   $0x0
  801bd9:	52                   	push   %edx
  801bda:	50                   	push   %eax
  801bdb:	6a 18                	push   $0x18
  801bdd:	e8 8b fd ff ff       	call   80196d <syscall>
  801be2:	83 c4 18             	add    $0x18,%esp
}
  801be5:	c9                   	leave  
  801be6:	c3                   	ret    

00801be7 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801be7:	55                   	push   %ebp
  801be8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801bea:	8b 45 08             	mov    0x8(%ebp),%eax
  801bed:	6a 00                	push   $0x0
  801bef:	ff 75 14             	pushl  0x14(%ebp)
  801bf2:	ff 75 10             	pushl  0x10(%ebp)
  801bf5:	ff 75 0c             	pushl  0xc(%ebp)
  801bf8:	50                   	push   %eax
  801bf9:	6a 19                	push   $0x19
  801bfb:	e8 6d fd ff ff       	call   80196d <syscall>
  801c00:	83 c4 18             	add    $0x18,%esp
}
  801c03:	c9                   	leave  
  801c04:	c3                   	ret    

00801c05 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801c05:	55                   	push   %ebp
  801c06:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c08:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 00                	push   $0x0
  801c11:	6a 00                	push   $0x0
  801c13:	50                   	push   %eax
  801c14:	6a 1a                	push   $0x1a
  801c16:	e8 52 fd ff ff       	call   80196d <syscall>
  801c1b:	83 c4 18             	add    $0x18,%esp
}
  801c1e:	90                   	nop
  801c1f:	c9                   	leave  
  801c20:	c3                   	ret    

00801c21 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c21:	55                   	push   %ebp
  801c22:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c24:	8b 45 08             	mov    0x8(%ebp),%eax
  801c27:	6a 00                	push   $0x0
  801c29:	6a 00                	push   $0x0
  801c2b:	6a 00                	push   $0x0
  801c2d:	6a 00                	push   $0x0
  801c2f:	50                   	push   %eax
  801c30:	6a 1b                	push   $0x1b
  801c32:	e8 36 fd ff ff       	call   80196d <syscall>
  801c37:	83 c4 18             	add    $0x18,%esp
}
  801c3a:	c9                   	leave  
  801c3b:	c3                   	ret    

00801c3c <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c3c:	55                   	push   %ebp
  801c3d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c3f:	6a 00                	push   $0x0
  801c41:	6a 00                	push   $0x0
  801c43:	6a 00                	push   $0x0
  801c45:	6a 00                	push   $0x0
  801c47:	6a 00                	push   $0x0
  801c49:	6a 05                	push   $0x5
  801c4b:	e8 1d fd ff ff       	call   80196d <syscall>
  801c50:	83 c4 18             	add    $0x18,%esp
}
  801c53:	c9                   	leave  
  801c54:	c3                   	ret    

00801c55 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c55:	55                   	push   %ebp
  801c56:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 00                	push   $0x0
  801c60:	6a 00                	push   $0x0
  801c62:	6a 06                	push   $0x6
  801c64:	e8 04 fd ff ff       	call   80196d <syscall>
  801c69:	83 c4 18             	add    $0x18,%esp
}
  801c6c:	c9                   	leave  
  801c6d:	c3                   	ret    

00801c6e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c6e:	55                   	push   %ebp
  801c6f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c71:	6a 00                	push   $0x0
  801c73:	6a 00                	push   $0x0
  801c75:	6a 00                	push   $0x0
  801c77:	6a 00                	push   $0x0
  801c79:	6a 00                	push   $0x0
  801c7b:	6a 07                	push   $0x7
  801c7d:	e8 eb fc ff ff       	call   80196d <syscall>
  801c82:	83 c4 18             	add    $0x18,%esp
}
  801c85:	c9                   	leave  
  801c86:	c3                   	ret    

00801c87 <sys_exit_env>:


void sys_exit_env(void)
{
  801c87:	55                   	push   %ebp
  801c88:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 00                	push   $0x0
  801c92:	6a 00                	push   $0x0
  801c94:	6a 1c                	push   $0x1c
  801c96:	e8 d2 fc ff ff       	call   80196d <syscall>
  801c9b:	83 c4 18             	add    $0x18,%esp
}
  801c9e:	90                   	nop
  801c9f:	c9                   	leave  
  801ca0:	c3                   	ret    

00801ca1 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801ca1:	55                   	push   %ebp
  801ca2:	89 e5                	mov    %esp,%ebp
  801ca4:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801ca7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801caa:	8d 50 04             	lea    0x4(%eax),%edx
  801cad:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cb0:	6a 00                	push   $0x0
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 00                	push   $0x0
  801cb6:	52                   	push   %edx
  801cb7:	50                   	push   %eax
  801cb8:	6a 1d                	push   $0x1d
  801cba:	e8 ae fc ff ff       	call   80196d <syscall>
  801cbf:	83 c4 18             	add    $0x18,%esp
	return result;
  801cc2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cc5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801cc8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ccb:	89 01                	mov    %eax,(%ecx)
  801ccd:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd3:	c9                   	leave  
  801cd4:	c2 04 00             	ret    $0x4

00801cd7 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801cd7:	55                   	push   %ebp
  801cd8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801cda:	6a 00                	push   $0x0
  801cdc:	6a 00                	push   $0x0
  801cde:	ff 75 10             	pushl  0x10(%ebp)
  801ce1:	ff 75 0c             	pushl  0xc(%ebp)
  801ce4:	ff 75 08             	pushl  0x8(%ebp)
  801ce7:	6a 13                	push   $0x13
  801ce9:	e8 7f fc ff ff       	call   80196d <syscall>
  801cee:	83 c4 18             	add    $0x18,%esp
	return ;
  801cf1:	90                   	nop
}
  801cf2:	c9                   	leave  
  801cf3:	c3                   	ret    

00801cf4 <sys_rcr2>:
uint32 sys_rcr2()
{
  801cf4:	55                   	push   %ebp
  801cf5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801cf7:	6a 00                	push   $0x0
  801cf9:	6a 00                	push   $0x0
  801cfb:	6a 00                	push   $0x0
  801cfd:	6a 00                	push   $0x0
  801cff:	6a 00                	push   $0x0
  801d01:	6a 1e                	push   $0x1e
  801d03:	e8 65 fc ff ff       	call   80196d <syscall>
  801d08:	83 c4 18             	add    $0x18,%esp
}
  801d0b:	c9                   	leave  
  801d0c:	c3                   	ret    

00801d0d <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801d0d:	55                   	push   %ebp
  801d0e:	89 e5                	mov    %esp,%ebp
  801d10:	83 ec 04             	sub    $0x4,%esp
  801d13:	8b 45 08             	mov    0x8(%ebp),%eax
  801d16:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d19:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d1d:	6a 00                	push   $0x0
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 00                	push   $0x0
  801d23:	6a 00                	push   $0x0
  801d25:	50                   	push   %eax
  801d26:	6a 1f                	push   $0x1f
  801d28:	e8 40 fc ff ff       	call   80196d <syscall>
  801d2d:	83 c4 18             	add    $0x18,%esp
	return ;
  801d30:	90                   	nop
}
  801d31:	c9                   	leave  
  801d32:	c3                   	ret    

00801d33 <rsttst>:
void rsttst()
{
  801d33:	55                   	push   %ebp
  801d34:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d36:	6a 00                	push   $0x0
  801d38:	6a 00                	push   $0x0
  801d3a:	6a 00                	push   $0x0
  801d3c:	6a 00                	push   $0x0
  801d3e:	6a 00                	push   $0x0
  801d40:	6a 21                	push   $0x21
  801d42:	e8 26 fc ff ff       	call   80196d <syscall>
  801d47:	83 c4 18             	add    $0x18,%esp
	return ;
  801d4a:	90                   	nop
}
  801d4b:	c9                   	leave  
  801d4c:	c3                   	ret    

00801d4d <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d4d:	55                   	push   %ebp
  801d4e:	89 e5                	mov    %esp,%ebp
  801d50:	83 ec 04             	sub    $0x4,%esp
  801d53:	8b 45 14             	mov    0x14(%ebp),%eax
  801d56:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d59:	8b 55 18             	mov    0x18(%ebp),%edx
  801d5c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d60:	52                   	push   %edx
  801d61:	50                   	push   %eax
  801d62:	ff 75 10             	pushl  0x10(%ebp)
  801d65:	ff 75 0c             	pushl  0xc(%ebp)
  801d68:	ff 75 08             	pushl  0x8(%ebp)
  801d6b:	6a 20                	push   $0x20
  801d6d:	e8 fb fb ff ff       	call   80196d <syscall>
  801d72:	83 c4 18             	add    $0x18,%esp
	return ;
  801d75:	90                   	nop
}
  801d76:	c9                   	leave  
  801d77:	c3                   	ret    

00801d78 <chktst>:
void chktst(uint32 n)
{
  801d78:	55                   	push   %ebp
  801d79:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d7b:	6a 00                	push   $0x0
  801d7d:	6a 00                	push   $0x0
  801d7f:	6a 00                	push   $0x0
  801d81:	6a 00                	push   $0x0
  801d83:	ff 75 08             	pushl  0x8(%ebp)
  801d86:	6a 22                	push   $0x22
  801d88:	e8 e0 fb ff ff       	call   80196d <syscall>
  801d8d:	83 c4 18             	add    $0x18,%esp
	return ;
  801d90:	90                   	nop
}
  801d91:	c9                   	leave  
  801d92:	c3                   	ret    

00801d93 <inctst>:

void inctst()
{
  801d93:	55                   	push   %ebp
  801d94:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d96:	6a 00                	push   $0x0
  801d98:	6a 00                	push   $0x0
  801d9a:	6a 00                	push   $0x0
  801d9c:	6a 00                	push   $0x0
  801d9e:	6a 00                	push   $0x0
  801da0:	6a 23                	push   $0x23
  801da2:	e8 c6 fb ff ff       	call   80196d <syscall>
  801da7:	83 c4 18             	add    $0x18,%esp
	return ;
  801daa:	90                   	nop
}
  801dab:	c9                   	leave  
  801dac:	c3                   	ret    

00801dad <gettst>:
uint32 gettst()
{
  801dad:	55                   	push   %ebp
  801dae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801db0:	6a 00                	push   $0x0
  801db2:	6a 00                	push   $0x0
  801db4:	6a 00                	push   $0x0
  801db6:	6a 00                	push   $0x0
  801db8:	6a 00                	push   $0x0
  801dba:	6a 24                	push   $0x24
  801dbc:	e8 ac fb ff ff       	call   80196d <syscall>
  801dc1:	83 c4 18             	add    $0x18,%esp
}
  801dc4:	c9                   	leave  
  801dc5:	c3                   	ret    

00801dc6 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801dc6:	55                   	push   %ebp
  801dc7:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dc9:	6a 00                	push   $0x0
  801dcb:	6a 00                	push   $0x0
  801dcd:	6a 00                	push   $0x0
  801dcf:	6a 00                	push   $0x0
  801dd1:	6a 00                	push   $0x0
  801dd3:	6a 25                	push   $0x25
  801dd5:	e8 93 fb ff ff       	call   80196d <syscall>
  801dda:	83 c4 18             	add    $0x18,%esp
  801ddd:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801de2:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801de7:	c9                   	leave  
  801de8:	c3                   	ret    

00801de9 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801de9:	55                   	push   %ebp
  801dea:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801dec:	8b 45 08             	mov    0x8(%ebp),%eax
  801def:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801df4:	6a 00                	push   $0x0
  801df6:	6a 00                	push   $0x0
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 00                	push   $0x0
  801dfc:	ff 75 08             	pushl  0x8(%ebp)
  801dff:	6a 26                	push   $0x26
  801e01:	e8 67 fb ff ff       	call   80196d <syscall>
  801e06:	83 c4 18             	add    $0x18,%esp
	return ;
  801e09:	90                   	nop
}
  801e0a:	c9                   	leave  
  801e0b:	c3                   	ret    

00801e0c <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e0c:	55                   	push   %ebp
  801e0d:	89 e5                	mov    %esp,%ebp
  801e0f:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e10:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e13:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e16:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e19:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1c:	6a 00                	push   $0x0
  801e1e:	53                   	push   %ebx
  801e1f:	51                   	push   %ecx
  801e20:	52                   	push   %edx
  801e21:	50                   	push   %eax
  801e22:	6a 27                	push   $0x27
  801e24:	e8 44 fb ff ff       	call   80196d <syscall>
  801e29:	83 c4 18             	add    $0x18,%esp
}
  801e2c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e2f:	c9                   	leave  
  801e30:	c3                   	ret    

00801e31 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e31:	55                   	push   %ebp
  801e32:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e34:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e37:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3a:	6a 00                	push   $0x0
  801e3c:	6a 00                	push   $0x0
  801e3e:	6a 00                	push   $0x0
  801e40:	52                   	push   %edx
  801e41:	50                   	push   %eax
  801e42:	6a 28                	push   $0x28
  801e44:	e8 24 fb ff ff       	call   80196d <syscall>
  801e49:	83 c4 18             	add    $0x18,%esp
}
  801e4c:	c9                   	leave  
  801e4d:	c3                   	ret    

00801e4e <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801e4e:	55                   	push   %ebp
  801e4f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801e51:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801e54:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e57:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5a:	6a 00                	push   $0x0
  801e5c:	51                   	push   %ecx
  801e5d:	ff 75 10             	pushl  0x10(%ebp)
  801e60:	52                   	push   %edx
  801e61:	50                   	push   %eax
  801e62:	6a 29                	push   $0x29
  801e64:	e8 04 fb ff ff       	call   80196d <syscall>
  801e69:	83 c4 18             	add    $0x18,%esp
}
  801e6c:	c9                   	leave  
  801e6d:	c3                   	ret    

00801e6e <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801e6e:	55                   	push   %ebp
  801e6f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801e71:	6a 00                	push   $0x0
  801e73:	6a 00                	push   $0x0
  801e75:	ff 75 10             	pushl  0x10(%ebp)
  801e78:	ff 75 0c             	pushl  0xc(%ebp)
  801e7b:	ff 75 08             	pushl  0x8(%ebp)
  801e7e:	6a 12                	push   $0x12
  801e80:	e8 e8 fa ff ff       	call   80196d <syscall>
  801e85:	83 c4 18             	add    $0x18,%esp
	return ;
  801e88:	90                   	nop
}
  801e89:	c9                   	leave  
  801e8a:	c3                   	ret    

00801e8b <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801e8b:	55                   	push   %ebp
  801e8c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801e8e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e91:	8b 45 08             	mov    0x8(%ebp),%eax
  801e94:	6a 00                	push   $0x0
  801e96:	6a 00                	push   $0x0
  801e98:	6a 00                	push   $0x0
  801e9a:	52                   	push   %edx
  801e9b:	50                   	push   %eax
  801e9c:	6a 2a                	push   $0x2a
  801e9e:	e8 ca fa ff ff       	call   80196d <syscall>
  801ea3:	83 c4 18             	add    $0x18,%esp
	return;
  801ea6:	90                   	nop
}
  801ea7:	c9                   	leave  
  801ea8:	c3                   	ret    

00801ea9 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801ea9:	55                   	push   %ebp
  801eaa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801eac:	6a 00                	push   $0x0
  801eae:	6a 00                	push   $0x0
  801eb0:	6a 00                	push   $0x0
  801eb2:	6a 00                	push   $0x0
  801eb4:	6a 00                	push   $0x0
  801eb6:	6a 2b                	push   $0x2b
  801eb8:	e8 b0 fa ff ff       	call   80196d <syscall>
  801ebd:	83 c4 18             	add    $0x18,%esp
}
  801ec0:	c9                   	leave  
  801ec1:	c3                   	ret    

00801ec2 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801ec2:	55                   	push   %ebp
  801ec3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801ec5:	6a 00                	push   $0x0
  801ec7:	6a 00                	push   $0x0
  801ec9:	6a 00                	push   $0x0
  801ecb:	ff 75 0c             	pushl  0xc(%ebp)
  801ece:	ff 75 08             	pushl  0x8(%ebp)
  801ed1:	6a 2d                	push   $0x2d
  801ed3:	e8 95 fa ff ff       	call   80196d <syscall>
  801ed8:	83 c4 18             	add    $0x18,%esp
	return;
  801edb:	90                   	nop
}
  801edc:	c9                   	leave  
  801edd:	c3                   	ret    

00801ede <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801ede:	55                   	push   %ebp
  801edf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801ee1:	6a 00                	push   $0x0
  801ee3:	6a 00                	push   $0x0
  801ee5:	6a 00                	push   $0x0
  801ee7:	ff 75 0c             	pushl  0xc(%ebp)
  801eea:	ff 75 08             	pushl  0x8(%ebp)
  801eed:	6a 2c                	push   $0x2c
  801eef:	e8 79 fa ff ff       	call   80196d <syscall>
  801ef4:	83 c4 18             	add    $0x18,%esp
	return ;
  801ef7:	90                   	nop
}
  801ef8:	c9                   	leave  
  801ef9:	c3                   	ret    

00801efa <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801efa:	55                   	push   %ebp
  801efb:	89 e5                	mov    %esp,%ebp
  801efd:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801f00:	83 ec 04             	sub    $0x4,%esp
  801f03:	68 94 2c 80 00       	push   $0x802c94
  801f08:	68 25 01 00 00       	push   $0x125
  801f0d:	68 c7 2c 80 00       	push   $0x802cc7
  801f12:	e8 ec e6 ff ff       	call   800603 <_panic>

00801f17 <to_page_va>:
//==================================================================================//
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  801f17:	55                   	push   %ebp
  801f18:	89 e5                	mov    %esp,%ebp
  801f1a:	83 ec 10             	sub    $0x10,%esp
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  801f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f20:	ba 60 30 80 00       	mov    $0x803060,%edx
  801f25:	29 d0                	sub    %edx,%eax
  801f27:	c1 f8 02             	sar    $0x2,%eax
  801f2a:	89 c2                	mov    %eax,%edx
  801f2c:	89 d0                	mov    %edx,%eax
  801f2e:	c1 e0 02             	shl    $0x2,%eax
  801f31:	01 d0                	add    %edx,%eax
  801f33:	c1 e0 02             	shl    $0x2,%eax
  801f36:	01 d0                	add    %edx,%eax
  801f38:	c1 e0 02             	shl    $0x2,%eax
  801f3b:	01 d0                	add    %edx,%eax
  801f3d:	89 c1                	mov    %eax,%ecx
  801f3f:	c1 e1 08             	shl    $0x8,%ecx
  801f42:	01 c8                	add    %ecx,%eax
  801f44:	89 c1                	mov    %eax,%ecx
  801f46:	c1 e1 10             	shl    $0x10,%ecx
  801f49:	01 c8                	add    %ecx,%eax
  801f4b:	01 c0                	add    %eax,%eax
  801f4d:	01 d0                	add    %edx,%eax
  801f4f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  801f52:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f55:	c1 e0 0c             	shl    $0xc,%eax
  801f58:	89 c2                	mov    %eax,%edx
  801f5a:	a1 64 b0 81 00       	mov    0x81b064,%eax
  801f5f:	01 d0                	add    %edx,%eax
}
  801f61:	c9                   	leave  
  801f62:	c3                   	ret    

00801f63 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  801f63:	55                   	push   %ebp
  801f64:	89 e5                	mov    %esp,%ebp
  801f66:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  801f69:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6c:	05 00 00 00 02       	add    $0x2000000,%eax
  801f71:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801f74:	73 16                	jae    801f8c <initialize_dynamic_allocator+0x29>
  801f76:	68 d8 2c 80 00       	push   $0x802cd8
  801f7b:	68 fe 2c 80 00       	push   $0x802cfe
  801f80:	6a 26                	push   $0x26
  801f82:	68 13 2d 80 00       	push   $0x802d13
  801f87:	e8 77 e6 ff ff       	call   800603 <_panic>
		is_initialized = 1;
  801f8c:	c7 05 24 30 80 00 01 	movl   $0x1,0x803024
  801f93:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	//Comment the following line
	panic("initialize_dynamic_allocator() Not implemented yet");
  801f96:	83 ec 04             	sub    $0x4,%esp
  801f99:	68 2c 2d 80 00       	push   $0x802d2c
  801f9e:	6a 2e                	push   $0x2e
  801fa0:	68 13 2d 80 00       	push   $0x802d13
  801fa5:	e8 59 e6 ff ff       	call   800603 <_panic>

00801faa <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  801faa:	55                   	push   %ebp
  801fab:	89 e5                	mov    %esp,%ebp
  801fad:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	//Comment the following line
	panic("get_block_size() Not implemented yet");
  801fb0:	83 ec 04             	sub    $0x4,%esp
  801fb3:	68 60 2d 80 00       	push   $0x802d60
  801fb8:	6a 3a                	push   $0x3a
  801fba:	68 13 2d 80 00       	push   $0x802d13
  801fbf:	e8 3f e6 ff ff       	call   800603 <_panic>

00801fc4 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  801fc4:	55                   	push   %ebp
  801fc5:	89 e5                	mov    %esp,%ebp
  801fc7:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  801fca:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801fd1:	76 16                	jbe    801fe9 <alloc_block+0x25>
  801fd3:	68 88 2d 80 00       	push   $0x802d88
  801fd8:	68 fe 2c 80 00       	push   $0x802cfe
  801fdd:	6a 46                	push   $0x46
  801fdf:	68 13 2d 80 00       	push   $0x802d13
  801fe4:	e8 1a e6 ff ff       	call   800603 <_panic>
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	panic("alloc_block() Not implemented yet");
  801fe9:	83 ec 04             	sub    $0x4,%esp
  801fec:	68 ac 2d 80 00       	push   $0x802dac
  801ff1:	6a 4d                	push   $0x4d
  801ff3:	68 13 2d 80 00       	push   $0x802d13
  801ff8:	e8 06 e6 ff ff       	call   800603 <_panic>

00801ffd <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  801ffd:	55                   	push   %ebp
  801ffe:	89 e5                	mov    %esp,%ebp
  802000:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  802003:	8b 55 08             	mov    0x8(%ebp),%edx
  802006:	a1 64 b0 81 00       	mov    0x81b064,%eax
  80200b:	39 c2                	cmp    %eax,%edx
  80200d:	72 0c                	jb     80201b <free_block+0x1e>
  80200f:	8b 55 08             	mov    0x8(%ebp),%edx
  802012:	a1 40 30 80 00       	mov    0x803040,%eax
  802017:	39 c2                	cmp    %eax,%edx
  802019:	72 16                	jb     802031 <free_block+0x34>
  80201b:	68 d0 2d 80 00       	push   $0x802dd0
  802020:	68 fe 2c 80 00       	push   $0x802cfe
  802025:	6a 5b                	push   $0x5b
  802027:	68 13 2d 80 00       	push   $0x802d13
  80202c:	e8 d2 e5 ff ff       	call   800603 <_panic>
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	panic("free_block() Not implemented yet");
  802031:	83 ec 04             	sub    $0x4,%esp
  802034:	68 08 2e 80 00       	push   $0x802e08
  802039:	6a 63                	push   $0x63
  80203b:	68 13 2d 80 00       	push   $0x802d13
  802040:	e8 be e5 ff ff       	call   800603 <_panic>

00802045 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  802045:	55                   	push   %ebp
  802046:	89 e5                	mov    %esp,%ebp
  802048:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  80204b:	83 ec 04             	sub    $0x4,%esp
  80204e:	68 2c 2e 80 00       	push   $0x802e2c
  802053:	6a 72                	push   $0x72
  802055:	68 13 2d 80 00       	push   $0x802d13
  80205a:	e8 a4 e5 ff ff       	call   800603 <_panic>
  80205f:	90                   	nop

00802060 <__udivdi3>:
  802060:	55                   	push   %ebp
  802061:	57                   	push   %edi
  802062:	56                   	push   %esi
  802063:	53                   	push   %ebx
  802064:	83 ec 1c             	sub    $0x1c,%esp
  802067:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80206b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80206f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802073:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802077:	89 ca                	mov    %ecx,%edx
  802079:	89 f8                	mov    %edi,%eax
  80207b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80207f:	85 f6                	test   %esi,%esi
  802081:	75 2d                	jne    8020b0 <__udivdi3+0x50>
  802083:	39 cf                	cmp    %ecx,%edi
  802085:	77 65                	ja     8020ec <__udivdi3+0x8c>
  802087:	89 fd                	mov    %edi,%ebp
  802089:	85 ff                	test   %edi,%edi
  80208b:	75 0b                	jne    802098 <__udivdi3+0x38>
  80208d:	b8 01 00 00 00       	mov    $0x1,%eax
  802092:	31 d2                	xor    %edx,%edx
  802094:	f7 f7                	div    %edi
  802096:	89 c5                	mov    %eax,%ebp
  802098:	31 d2                	xor    %edx,%edx
  80209a:	89 c8                	mov    %ecx,%eax
  80209c:	f7 f5                	div    %ebp
  80209e:	89 c1                	mov    %eax,%ecx
  8020a0:	89 d8                	mov    %ebx,%eax
  8020a2:	f7 f5                	div    %ebp
  8020a4:	89 cf                	mov    %ecx,%edi
  8020a6:	89 fa                	mov    %edi,%edx
  8020a8:	83 c4 1c             	add    $0x1c,%esp
  8020ab:	5b                   	pop    %ebx
  8020ac:	5e                   	pop    %esi
  8020ad:	5f                   	pop    %edi
  8020ae:	5d                   	pop    %ebp
  8020af:	c3                   	ret    
  8020b0:	39 ce                	cmp    %ecx,%esi
  8020b2:	77 28                	ja     8020dc <__udivdi3+0x7c>
  8020b4:	0f bd fe             	bsr    %esi,%edi
  8020b7:	83 f7 1f             	xor    $0x1f,%edi
  8020ba:	75 40                	jne    8020fc <__udivdi3+0x9c>
  8020bc:	39 ce                	cmp    %ecx,%esi
  8020be:	72 0a                	jb     8020ca <__udivdi3+0x6a>
  8020c0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8020c4:	0f 87 9e 00 00 00    	ja     802168 <__udivdi3+0x108>
  8020ca:	b8 01 00 00 00       	mov    $0x1,%eax
  8020cf:	89 fa                	mov    %edi,%edx
  8020d1:	83 c4 1c             	add    $0x1c,%esp
  8020d4:	5b                   	pop    %ebx
  8020d5:	5e                   	pop    %esi
  8020d6:	5f                   	pop    %edi
  8020d7:	5d                   	pop    %ebp
  8020d8:	c3                   	ret    
  8020d9:	8d 76 00             	lea    0x0(%esi),%esi
  8020dc:	31 ff                	xor    %edi,%edi
  8020de:	31 c0                	xor    %eax,%eax
  8020e0:	89 fa                	mov    %edi,%edx
  8020e2:	83 c4 1c             	add    $0x1c,%esp
  8020e5:	5b                   	pop    %ebx
  8020e6:	5e                   	pop    %esi
  8020e7:	5f                   	pop    %edi
  8020e8:	5d                   	pop    %ebp
  8020e9:	c3                   	ret    
  8020ea:	66 90                	xchg   %ax,%ax
  8020ec:	89 d8                	mov    %ebx,%eax
  8020ee:	f7 f7                	div    %edi
  8020f0:	31 ff                	xor    %edi,%edi
  8020f2:	89 fa                	mov    %edi,%edx
  8020f4:	83 c4 1c             	add    $0x1c,%esp
  8020f7:	5b                   	pop    %ebx
  8020f8:	5e                   	pop    %esi
  8020f9:	5f                   	pop    %edi
  8020fa:	5d                   	pop    %ebp
  8020fb:	c3                   	ret    
  8020fc:	bd 20 00 00 00       	mov    $0x20,%ebp
  802101:	89 eb                	mov    %ebp,%ebx
  802103:	29 fb                	sub    %edi,%ebx
  802105:	89 f9                	mov    %edi,%ecx
  802107:	d3 e6                	shl    %cl,%esi
  802109:	89 c5                	mov    %eax,%ebp
  80210b:	88 d9                	mov    %bl,%cl
  80210d:	d3 ed                	shr    %cl,%ebp
  80210f:	89 e9                	mov    %ebp,%ecx
  802111:	09 f1                	or     %esi,%ecx
  802113:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802117:	89 f9                	mov    %edi,%ecx
  802119:	d3 e0                	shl    %cl,%eax
  80211b:	89 c5                	mov    %eax,%ebp
  80211d:	89 d6                	mov    %edx,%esi
  80211f:	88 d9                	mov    %bl,%cl
  802121:	d3 ee                	shr    %cl,%esi
  802123:	89 f9                	mov    %edi,%ecx
  802125:	d3 e2                	shl    %cl,%edx
  802127:	8b 44 24 08          	mov    0x8(%esp),%eax
  80212b:	88 d9                	mov    %bl,%cl
  80212d:	d3 e8                	shr    %cl,%eax
  80212f:	09 c2                	or     %eax,%edx
  802131:	89 d0                	mov    %edx,%eax
  802133:	89 f2                	mov    %esi,%edx
  802135:	f7 74 24 0c          	divl   0xc(%esp)
  802139:	89 d6                	mov    %edx,%esi
  80213b:	89 c3                	mov    %eax,%ebx
  80213d:	f7 e5                	mul    %ebp
  80213f:	39 d6                	cmp    %edx,%esi
  802141:	72 19                	jb     80215c <__udivdi3+0xfc>
  802143:	74 0b                	je     802150 <__udivdi3+0xf0>
  802145:	89 d8                	mov    %ebx,%eax
  802147:	31 ff                	xor    %edi,%edi
  802149:	e9 58 ff ff ff       	jmp    8020a6 <__udivdi3+0x46>
  80214e:	66 90                	xchg   %ax,%ax
  802150:	8b 54 24 08          	mov    0x8(%esp),%edx
  802154:	89 f9                	mov    %edi,%ecx
  802156:	d3 e2                	shl    %cl,%edx
  802158:	39 c2                	cmp    %eax,%edx
  80215a:	73 e9                	jae    802145 <__udivdi3+0xe5>
  80215c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80215f:	31 ff                	xor    %edi,%edi
  802161:	e9 40 ff ff ff       	jmp    8020a6 <__udivdi3+0x46>
  802166:	66 90                	xchg   %ax,%ax
  802168:	31 c0                	xor    %eax,%eax
  80216a:	e9 37 ff ff ff       	jmp    8020a6 <__udivdi3+0x46>
  80216f:	90                   	nop

00802170 <__umoddi3>:
  802170:	55                   	push   %ebp
  802171:	57                   	push   %edi
  802172:	56                   	push   %esi
  802173:	53                   	push   %ebx
  802174:	83 ec 1c             	sub    $0x1c,%esp
  802177:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80217b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80217f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802183:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802187:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80218b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80218f:	89 f3                	mov    %esi,%ebx
  802191:	89 fa                	mov    %edi,%edx
  802193:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802197:	89 34 24             	mov    %esi,(%esp)
  80219a:	85 c0                	test   %eax,%eax
  80219c:	75 1a                	jne    8021b8 <__umoddi3+0x48>
  80219e:	39 f7                	cmp    %esi,%edi
  8021a0:	0f 86 a2 00 00 00    	jbe    802248 <__umoddi3+0xd8>
  8021a6:	89 c8                	mov    %ecx,%eax
  8021a8:	89 f2                	mov    %esi,%edx
  8021aa:	f7 f7                	div    %edi
  8021ac:	89 d0                	mov    %edx,%eax
  8021ae:	31 d2                	xor    %edx,%edx
  8021b0:	83 c4 1c             	add    $0x1c,%esp
  8021b3:	5b                   	pop    %ebx
  8021b4:	5e                   	pop    %esi
  8021b5:	5f                   	pop    %edi
  8021b6:	5d                   	pop    %ebp
  8021b7:	c3                   	ret    
  8021b8:	39 f0                	cmp    %esi,%eax
  8021ba:	0f 87 ac 00 00 00    	ja     80226c <__umoddi3+0xfc>
  8021c0:	0f bd e8             	bsr    %eax,%ebp
  8021c3:	83 f5 1f             	xor    $0x1f,%ebp
  8021c6:	0f 84 ac 00 00 00    	je     802278 <__umoddi3+0x108>
  8021cc:	bf 20 00 00 00       	mov    $0x20,%edi
  8021d1:	29 ef                	sub    %ebp,%edi
  8021d3:	89 fe                	mov    %edi,%esi
  8021d5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8021d9:	89 e9                	mov    %ebp,%ecx
  8021db:	d3 e0                	shl    %cl,%eax
  8021dd:	89 d7                	mov    %edx,%edi
  8021df:	89 f1                	mov    %esi,%ecx
  8021e1:	d3 ef                	shr    %cl,%edi
  8021e3:	09 c7                	or     %eax,%edi
  8021e5:	89 e9                	mov    %ebp,%ecx
  8021e7:	d3 e2                	shl    %cl,%edx
  8021e9:	89 14 24             	mov    %edx,(%esp)
  8021ec:	89 d8                	mov    %ebx,%eax
  8021ee:	d3 e0                	shl    %cl,%eax
  8021f0:	89 c2                	mov    %eax,%edx
  8021f2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8021f6:	d3 e0                	shl    %cl,%eax
  8021f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021fc:	8b 44 24 08          	mov    0x8(%esp),%eax
  802200:	89 f1                	mov    %esi,%ecx
  802202:	d3 e8                	shr    %cl,%eax
  802204:	09 d0                	or     %edx,%eax
  802206:	d3 eb                	shr    %cl,%ebx
  802208:	89 da                	mov    %ebx,%edx
  80220a:	f7 f7                	div    %edi
  80220c:	89 d3                	mov    %edx,%ebx
  80220e:	f7 24 24             	mull   (%esp)
  802211:	89 c6                	mov    %eax,%esi
  802213:	89 d1                	mov    %edx,%ecx
  802215:	39 d3                	cmp    %edx,%ebx
  802217:	0f 82 87 00 00 00    	jb     8022a4 <__umoddi3+0x134>
  80221d:	0f 84 91 00 00 00    	je     8022b4 <__umoddi3+0x144>
  802223:	8b 54 24 04          	mov    0x4(%esp),%edx
  802227:	29 f2                	sub    %esi,%edx
  802229:	19 cb                	sbb    %ecx,%ebx
  80222b:	89 d8                	mov    %ebx,%eax
  80222d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802231:	d3 e0                	shl    %cl,%eax
  802233:	89 e9                	mov    %ebp,%ecx
  802235:	d3 ea                	shr    %cl,%edx
  802237:	09 d0                	or     %edx,%eax
  802239:	89 e9                	mov    %ebp,%ecx
  80223b:	d3 eb                	shr    %cl,%ebx
  80223d:	89 da                	mov    %ebx,%edx
  80223f:	83 c4 1c             	add    $0x1c,%esp
  802242:	5b                   	pop    %ebx
  802243:	5e                   	pop    %esi
  802244:	5f                   	pop    %edi
  802245:	5d                   	pop    %ebp
  802246:	c3                   	ret    
  802247:	90                   	nop
  802248:	89 fd                	mov    %edi,%ebp
  80224a:	85 ff                	test   %edi,%edi
  80224c:	75 0b                	jne    802259 <__umoddi3+0xe9>
  80224e:	b8 01 00 00 00       	mov    $0x1,%eax
  802253:	31 d2                	xor    %edx,%edx
  802255:	f7 f7                	div    %edi
  802257:	89 c5                	mov    %eax,%ebp
  802259:	89 f0                	mov    %esi,%eax
  80225b:	31 d2                	xor    %edx,%edx
  80225d:	f7 f5                	div    %ebp
  80225f:	89 c8                	mov    %ecx,%eax
  802261:	f7 f5                	div    %ebp
  802263:	89 d0                	mov    %edx,%eax
  802265:	e9 44 ff ff ff       	jmp    8021ae <__umoddi3+0x3e>
  80226a:	66 90                	xchg   %ax,%ax
  80226c:	89 c8                	mov    %ecx,%eax
  80226e:	89 f2                	mov    %esi,%edx
  802270:	83 c4 1c             	add    $0x1c,%esp
  802273:	5b                   	pop    %ebx
  802274:	5e                   	pop    %esi
  802275:	5f                   	pop    %edi
  802276:	5d                   	pop    %ebp
  802277:	c3                   	ret    
  802278:	3b 04 24             	cmp    (%esp),%eax
  80227b:	72 06                	jb     802283 <__umoddi3+0x113>
  80227d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802281:	77 0f                	ja     802292 <__umoddi3+0x122>
  802283:	89 f2                	mov    %esi,%edx
  802285:	29 f9                	sub    %edi,%ecx
  802287:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80228b:	89 14 24             	mov    %edx,(%esp)
  80228e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802292:	8b 44 24 04          	mov    0x4(%esp),%eax
  802296:	8b 14 24             	mov    (%esp),%edx
  802299:	83 c4 1c             	add    $0x1c,%esp
  80229c:	5b                   	pop    %ebx
  80229d:	5e                   	pop    %esi
  80229e:	5f                   	pop    %edi
  80229f:	5d                   	pop    %ebp
  8022a0:	c3                   	ret    
  8022a1:	8d 76 00             	lea    0x0(%esi),%esi
  8022a4:	2b 04 24             	sub    (%esp),%eax
  8022a7:	19 fa                	sbb    %edi,%edx
  8022a9:	89 d1                	mov    %edx,%ecx
  8022ab:	89 c6                	mov    %eax,%esi
  8022ad:	e9 71 ff ff ff       	jmp    802223 <__umoddi3+0xb3>
  8022b2:	66 90                	xchg   %ax,%ax
  8022b4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8022b8:	72 ea                	jb     8022a4 <__umoddi3+0x134>
  8022ba:	89 d9                	mov    %ebx,%ecx
  8022bc:	e9 62 ff ff ff       	jmp    802223 <__umoddi3+0xb3>

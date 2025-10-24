
obj/user/tst_sharing_1:     file format elf32-i386


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
  800031:	e8 d7 03 00 00       	call   80040d <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the creation of shared variables (create_shared_memory)
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
  80005c:	68 80 22 80 00       	push   $0x802280
  800061:	6a 13                	push   $0x13
  800063:	68 9c 22 80 00       	push   $0x80229c
  800068:	e8 50 05 00 00       	call   8005bd <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	int eval = 0;
  80006d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	bool is_correct = 1;
  800074:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	uint32 *x, *y, *z ;
	uint32 expected ;
	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  80007b:	c7 45 e8 00 10 00 82 	movl   $0x82001000,-0x18(%ebp)

	cprintf("STEP A: checking the creation of shared variables... [60%]\n");
  800082:	83 ec 0c             	sub    $0xc,%esp
  800085:	68 b4 22 80 00       	push   $0x8022b4
  80008a:	e8 fc 07 00 00       	call   80088b <cprintf>
  80008f:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  800092:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		int freeFrames = sys_calculate_free_frames() ;
  800099:	e8 a8 19 00 00       	call   801a46 <sys_calculate_free_frames>
  80009e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8000a1:	83 ec 04             	sub    $0x4,%esp
  8000a4:	6a 01                	push   $0x1
  8000a6:	68 00 10 00 00       	push   $0x1000
  8000ab:	68 f0 22 80 00       	push   $0x8022f0
  8000b0:	e8 e0 17 00 00       	call   801895 <smalloc>
  8000b5:	83 c4 10             	add    $0x10,%esp
  8000b8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (x != (uint32*)pagealloc_start) {is_correct = 0; cprintf("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  8000bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000be:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  8000c1:	74 17                	je     8000da <_main+0xa2>
  8000c3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8000ca:	83 ec 0c             	sub    $0xc,%esp
  8000cd:	68 f4 22 80 00       	push   $0x8022f4
  8000d2:	e8 b4 07 00 00       	call   80088b <cprintf>
  8000d7:	83 c4 10             	add    $0x10,%esp
		expected = 1+1 ; /*1page +1table*/
  8000da:	c7 45 dc 02 00 00 00 	movl   $0x2,-0x24(%ebp)
		int diff = (freeFrames - sys_calculate_free_frames());
  8000e1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8000e4:	e8 5d 19 00 00       	call   801a46 <sys_calculate_free_frames>
  8000e9:	29 c3                	sub    %eax,%ebx
  8000eb:	89 d8                	mov    %ebx,%eax
  8000ed:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/) {is_correct = 0; cprintf("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  8000f0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8000f3:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8000f6:	72 0d                	jb     800105 <_main+0xcd>
  8000f8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8000fb:	8d 50 02             	lea    0x2(%eax),%edx
  8000fe:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800101:	39 c2                	cmp    %eax,%edx
  800103:	73 27                	jae    80012c <_main+0xf4>
  800105:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80010c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80010f:	e8 32 19 00 00       	call   801a46 <sys_calculate_free_frames>
  800114:	29 c3                	sub    %eax,%ebx
  800116:	89 d8                	mov    %ebx,%eax
  800118:	83 ec 04             	sub    $0x4,%esp
  80011b:	ff 75 dc             	pushl  -0x24(%ebp)
  80011e:	50                   	push   %eax
  80011f:	68 60 23 80 00       	push   $0x802360
  800124:	e8 62 07 00 00       	call   80088b <cprintf>
  800129:	83 c4 10             	add    $0x10,%esp
		if (is_correct) eval += 20 ;
  80012c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800130:	74 04                	je     800136 <_main+0xfe>
  800132:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)

		is_correct = 1;
  800136:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		freeFrames = sys_calculate_free_frames() ;
  80013d:	e8 04 19 00 00       	call   801a46 <sys_calculate_free_frames>
  800142:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		z = smalloc("z", PAGE_SIZE + 4, 1);
  800145:	83 ec 04             	sub    $0x4,%esp
  800148:	6a 01                	push   $0x1
  80014a:	68 04 10 00 00       	push   $0x1004
  80014f:	68 f8 23 80 00       	push   $0x8023f8
  800154:	e8 3c 17 00 00       	call   801895 <smalloc>
  800159:	83 c4 10             	add    $0x10,%esp
  80015c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if (z != (uint32*)(pagealloc_start + 1 * PAGE_SIZE)) {is_correct = 0; cprintf("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  80015f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800162:	05 00 10 00 00       	add    $0x1000,%eax
  800167:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80016a:	74 17                	je     800183 <_main+0x14b>
  80016c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800173:	83 ec 0c             	sub    $0xc,%esp
  800176:	68 f4 22 80 00       	push   $0x8022f4
  80017b:	e8 0b 07 00 00       	call   80088b <cprintf>
  800180:	83 c4 10             	add    $0x10,%esp
		expected = 2 ; /*2pages*/
  800183:	c7 45 dc 02 00 00 00 	movl   $0x2,-0x24(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80018a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80018d:	e8 b4 18 00 00       	call   801a46 <sys_calculate_free_frames>
  800192:	29 c3                	sub    %eax,%ebx
  800194:	89 d8                	mov    %ebx,%eax
  800196:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/) {is_correct = 0; cprintf("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  800199:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80019c:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80019f:	72 0d                	jb     8001ae <_main+0x176>
  8001a1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001a4:	8d 50 02             	lea    0x2(%eax),%edx
  8001a7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8001aa:	39 c2                	cmp    %eax,%edx
  8001ac:	73 27                	jae    8001d5 <_main+0x19d>
  8001ae:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001b5:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8001b8:	e8 89 18 00 00       	call   801a46 <sys_calculate_free_frames>
  8001bd:	29 c3                	sub    %eax,%ebx
  8001bf:	89 d8                	mov    %ebx,%eax
  8001c1:	83 ec 04             	sub    $0x4,%esp
  8001c4:	ff 75 dc             	pushl  -0x24(%ebp)
  8001c7:	50                   	push   %eax
  8001c8:	68 60 23 80 00       	push   $0x802360
  8001cd:	e8 b9 06 00 00       	call   80088b <cprintf>
  8001d2:	83 c4 10             	add    $0x10,%esp
		if (is_correct) eval += 20 ;
  8001d5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8001d9:	74 04                	je     8001df <_main+0x1a7>
  8001db:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)

		is_correct = 1;
  8001df:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		freeFrames = sys_calculate_free_frames() ;
  8001e6:	e8 5b 18 00 00       	call   801a46 <sys_calculate_free_frames>
  8001eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		y = smalloc("y", 4, 1);
  8001ee:	83 ec 04             	sub    $0x4,%esp
  8001f1:	6a 01                	push   $0x1
  8001f3:	6a 04                	push   $0x4
  8001f5:	68 fa 23 80 00       	push   $0x8023fa
  8001fa:	e8 96 16 00 00       	call   801895 <smalloc>
  8001ff:	83 c4 10             	add    $0x10,%esp
  800202:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (y != (uint32*)(pagealloc_start + 3 * PAGE_SIZE)) {is_correct = 0; cprintf("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  800205:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800208:	05 00 30 00 00       	add    $0x3000,%eax
  80020d:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  800210:	74 17                	je     800229 <_main+0x1f1>
  800212:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800219:	83 ec 0c             	sub    $0xc,%esp
  80021c:	68 f4 22 80 00       	push   $0x8022f4
  800221:	e8 65 06 00 00       	call   80088b <cprintf>
  800226:	83 c4 10             	add    $0x10,%esp
		expected = 1 ; /*1page*/
  800229:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800230:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800233:	e8 0e 18 00 00       	call   801a46 <sys_calculate_free_frames>
  800238:	29 c3                	sub    %eax,%ebx
  80023a:	89 d8                	mov    %ebx,%eax
  80023c:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/) {is_correct = 0; cprintf("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  80023f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800242:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800245:	72 0d                	jb     800254 <_main+0x21c>
  800247:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80024a:	8d 50 02             	lea    0x2(%eax),%edx
  80024d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800250:	39 c2                	cmp    %eax,%edx
  800252:	73 27                	jae    80027b <_main+0x243>
  800254:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80025b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80025e:	e8 e3 17 00 00       	call   801a46 <sys_calculate_free_frames>
  800263:	29 c3                	sub    %eax,%ebx
  800265:	89 d8                	mov    %ebx,%eax
  800267:	83 ec 04             	sub    $0x4,%esp
  80026a:	ff 75 dc             	pushl  -0x24(%ebp)
  80026d:	50                   	push   %eax
  80026e:	68 60 23 80 00       	push   $0x802360
  800273:	e8 13 06 00 00       	call   80088b <cprintf>
  800278:	83 c4 10             	add    $0x10,%esp
		if (is_correct) eval += 20 ;
  80027b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80027f:	74 04                	je     800285 <_main+0x24d>
  800281:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
	}
	cprintf("Step A is completed successfully!!\n\n\n");
  800285:	83 ec 0c             	sub    $0xc,%esp
  800288:	68 fc 23 80 00       	push   $0x8023fc
  80028d:	e8 f9 05 00 00       	call   80088b <cprintf>
  800292:	83 c4 10             	add    $0x10,%esp

	is_correct = 1;
  800295:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	cprintf("STEP B: checking reading & writing... [40%]\n");
  80029c:	83 ec 0c             	sub    $0xc,%esp
  80029f:	68 24 24 80 00       	push   $0x802424
  8002a4:	e8 e2 05 00 00       	call   80088b <cprintf>
  8002a9:	83 c4 10             	add    $0x10,%esp
	{
		int i=0;
  8002ac:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for(;i<PAGE_SIZE/4;i++)
  8002b3:	eb 2d                	jmp    8002e2 <_main+0x2aa>
		{
			x[i] = -1;
  8002b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002b8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002c2:	01 d0                	add    %edx,%eax
  8002c4:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			y[i] = -1;
  8002ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002cd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002d4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8002d7:	01 d0                	add    %edx,%eax
  8002d9:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)

	is_correct = 1;
	cprintf("STEP B: checking reading & writing... [40%]\n");
	{
		int i=0;
		for(;i<PAGE_SIZE/4;i++)
  8002df:	ff 45 ec             	incl   -0x14(%ebp)
  8002e2:	81 7d ec ff 03 00 00 	cmpl   $0x3ff,-0x14(%ebp)
  8002e9:	7e ca                	jle    8002b5 <_main+0x27d>
		{
			x[i] = -1;
			y[i] = -1;
		}

		i=0;
  8002eb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for(;i<2*PAGE_SIZE/4;i++)
  8002f2:	eb 18                	jmp    80030c <_main+0x2d4>
		{
			z[i] = -1;
  8002f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002f7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002fe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800301:	01 d0                	add    %edx,%eax
  800303:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			x[i] = -1;
			y[i] = -1;
		}

		i=0;
		for(;i<2*PAGE_SIZE/4;i++)
  800309:	ff 45 ec             	incl   -0x14(%ebp)
  80030c:	81 7d ec ff 07 00 00 	cmpl   $0x7ff,-0x14(%ebp)
  800313:	7e df                	jle    8002f4 <_main+0x2bc>
		{
			z[i] = -1;
		}

		if( x[0] !=  -1)  					{is_correct = 0; cprintf("Reading/Writing of shared object is failed");}
  800315:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800318:	8b 00                	mov    (%eax),%eax
  80031a:	83 f8 ff             	cmp    $0xffffffff,%eax
  80031d:	74 17                	je     800336 <_main+0x2fe>
  80031f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800326:	83 ec 0c             	sub    $0xc,%esp
  800329:	68 54 24 80 00       	push   $0x802454
  80032e:	e8 58 05 00 00       	call   80088b <cprintf>
  800333:	83 c4 10             	add    $0x10,%esp
		if( x[PAGE_SIZE/4 - 1] !=  -1)  	{is_correct = 0; cprintf("Reading/Writing of shared object is failed");}
  800336:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800339:	05 fc 0f 00 00       	add    $0xffc,%eax
  80033e:	8b 00                	mov    (%eax),%eax
  800340:	83 f8 ff             	cmp    $0xffffffff,%eax
  800343:	74 17                	je     80035c <_main+0x324>
  800345:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80034c:	83 ec 0c             	sub    $0xc,%esp
  80034f:	68 54 24 80 00       	push   $0x802454
  800354:	e8 32 05 00 00       	call   80088b <cprintf>
  800359:	83 c4 10             	add    $0x10,%esp

		if( y[0] !=  -1)  					{is_correct = 0; cprintf("Reading/Writing of shared object is failed");}
  80035c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80035f:	8b 00                	mov    (%eax),%eax
  800361:	83 f8 ff             	cmp    $0xffffffff,%eax
  800364:	74 17                	je     80037d <_main+0x345>
  800366:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80036d:	83 ec 0c             	sub    $0xc,%esp
  800370:	68 54 24 80 00       	push   $0x802454
  800375:	e8 11 05 00 00       	call   80088b <cprintf>
  80037a:	83 c4 10             	add    $0x10,%esp
		if( y[PAGE_SIZE/4 - 1] !=  -1)  	{is_correct = 0; cprintf("Reading/Writing of shared object is failed");}
  80037d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800380:	05 fc 0f 00 00       	add    $0xffc,%eax
  800385:	8b 00                	mov    (%eax),%eax
  800387:	83 f8 ff             	cmp    $0xffffffff,%eax
  80038a:	74 17                	je     8003a3 <_main+0x36b>
  80038c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800393:	83 ec 0c             	sub    $0xc,%esp
  800396:	68 54 24 80 00       	push   $0x802454
  80039b:	e8 eb 04 00 00       	call   80088b <cprintf>
  8003a0:	83 c4 10             	add    $0x10,%esp

		if( z[0] !=  -1)  					{is_correct = 0; cprintf("Reading/Writing of shared object is failed");}
  8003a3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003a6:	8b 00                	mov    (%eax),%eax
  8003a8:	83 f8 ff             	cmp    $0xffffffff,%eax
  8003ab:	74 17                	je     8003c4 <_main+0x38c>
  8003ad:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003b4:	83 ec 0c             	sub    $0xc,%esp
  8003b7:	68 54 24 80 00       	push   $0x802454
  8003bc:	e8 ca 04 00 00       	call   80088b <cprintf>
  8003c1:	83 c4 10             	add    $0x10,%esp
		if( z[2*PAGE_SIZE/4 - 1] !=  -1)  	{is_correct = 0; cprintf("Reading/Writing of shared object is failed");}
  8003c4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003c7:	05 fc 1f 00 00       	add    $0x1ffc,%eax
  8003cc:	8b 00                	mov    (%eax),%eax
  8003ce:	83 f8 ff             	cmp    $0xffffffff,%eax
  8003d1:	74 17                	je     8003ea <_main+0x3b2>
  8003d3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003da:	83 ec 0c             	sub    $0xc,%esp
  8003dd:	68 54 24 80 00       	push   $0x802454
  8003e2:	e8 a4 04 00 00       	call   80088b <cprintf>
  8003e7:	83 c4 10             	add    $0x10,%esp
	}
	if (is_correct)
  8003ea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8003ee:	74 04                	je     8003f4 <_main+0x3bc>
		eval += 40 ;
  8003f0:	83 45 f4 28          	addl   $0x28,-0xc(%ebp)
	cprintf("\n%~Test of Shared Variables [Create] [1] completed. Eval = %d%%\n\n", eval);
  8003f4:	83 ec 08             	sub    $0x8,%esp
  8003f7:	ff 75 f4             	pushl  -0xc(%ebp)
  8003fa:	68 80 24 80 00       	push   $0x802480
  8003ff:	e8 87 04 00 00       	call   80088b <cprintf>
  800404:	83 c4 10             	add    $0x10,%esp

	return;
  800407:	90                   	nop
}
  800408:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80040b:	c9                   	leave  
  80040c:	c3                   	ret    

0080040d <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80040d:	55                   	push   %ebp
  80040e:	89 e5                	mov    %esp,%ebp
  800410:	57                   	push   %edi
  800411:	56                   	push   %esi
  800412:	53                   	push   %ebx
  800413:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800416:	e8 f4 17 00 00       	call   801c0f <sys_getenvindex>
  80041b:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  80041e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800421:	89 d0                	mov    %edx,%eax
  800423:	c1 e0 02             	shl    $0x2,%eax
  800426:	01 d0                	add    %edx,%eax
  800428:	c1 e0 03             	shl    $0x3,%eax
  80042b:	01 d0                	add    %edx,%eax
  80042d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800434:	01 d0                	add    %edx,%eax
  800436:	c1 e0 02             	shl    $0x2,%eax
  800439:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80043e:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800443:	a1 20 30 80 00       	mov    0x803020,%eax
  800448:	8a 40 20             	mov    0x20(%eax),%al
  80044b:	84 c0                	test   %al,%al
  80044d:	74 0d                	je     80045c <libmain+0x4f>
		binaryname = myEnv->prog_name;
  80044f:	a1 20 30 80 00       	mov    0x803020,%eax
  800454:	83 c0 20             	add    $0x20,%eax
  800457:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80045c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800460:	7e 0a                	jle    80046c <libmain+0x5f>
		binaryname = argv[0];
  800462:	8b 45 0c             	mov    0xc(%ebp),%eax
  800465:	8b 00                	mov    (%eax),%eax
  800467:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  80046c:	83 ec 08             	sub    $0x8,%esp
  80046f:	ff 75 0c             	pushl  0xc(%ebp)
  800472:	ff 75 08             	pushl  0x8(%ebp)
  800475:	e8 be fb ff ff       	call   800038 <_main>
  80047a:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80047d:	a1 00 30 80 00       	mov    0x803000,%eax
  800482:	85 c0                	test   %eax,%eax
  800484:	0f 84 01 01 00 00    	je     80058b <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80048a:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800490:	bb bc 25 80 00       	mov    $0x8025bc,%ebx
  800495:	ba 0e 00 00 00       	mov    $0xe,%edx
  80049a:	89 c7                	mov    %eax,%edi
  80049c:	89 de                	mov    %ebx,%esi
  80049e:	89 d1                	mov    %edx,%ecx
  8004a0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8004a2:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8004a5:	b9 56 00 00 00       	mov    $0x56,%ecx
  8004aa:	b0 00                	mov    $0x0,%al
  8004ac:	89 d7                	mov    %edx,%edi
  8004ae:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8004b0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8004b7:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8004ba:	83 ec 08             	sub    $0x8,%esp
  8004bd:	50                   	push   %eax
  8004be:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8004c4:	50                   	push   %eax
  8004c5:	e8 7b 19 00 00       	call   801e45 <sys_utilities>
  8004ca:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8004cd:	e8 c4 14 00 00       	call   801996 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8004d2:	83 ec 0c             	sub    $0xc,%esp
  8004d5:	68 dc 24 80 00       	push   $0x8024dc
  8004da:	e8 ac 03 00 00       	call   80088b <cprintf>
  8004df:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8004e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004e5:	85 c0                	test   %eax,%eax
  8004e7:	74 18                	je     800501 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8004e9:	e8 75 19 00 00       	call   801e63 <sys_get_optimal_num_faults>
  8004ee:	83 ec 08             	sub    $0x8,%esp
  8004f1:	50                   	push   %eax
  8004f2:	68 04 25 80 00       	push   $0x802504
  8004f7:	e8 8f 03 00 00       	call   80088b <cprintf>
  8004fc:	83 c4 10             	add    $0x10,%esp
  8004ff:	eb 59                	jmp    80055a <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800501:	a1 20 30 80 00       	mov    0x803020,%eax
  800506:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  80050c:	a1 20 30 80 00       	mov    0x803020,%eax
  800511:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  800517:	83 ec 04             	sub    $0x4,%esp
  80051a:	52                   	push   %edx
  80051b:	50                   	push   %eax
  80051c:	68 28 25 80 00       	push   $0x802528
  800521:	e8 65 03 00 00       	call   80088b <cprintf>
  800526:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800529:	a1 20 30 80 00       	mov    0x803020,%eax
  80052e:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800534:	a1 20 30 80 00       	mov    0x803020,%eax
  800539:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  80053f:	a1 20 30 80 00       	mov    0x803020,%eax
  800544:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  80054a:	51                   	push   %ecx
  80054b:	52                   	push   %edx
  80054c:	50                   	push   %eax
  80054d:	68 50 25 80 00       	push   $0x802550
  800552:	e8 34 03 00 00       	call   80088b <cprintf>
  800557:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80055a:	a1 20 30 80 00       	mov    0x803020,%eax
  80055f:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  800565:	83 ec 08             	sub    $0x8,%esp
  800568:	50                   	push   %eax
  800569:	68 a8 25 80 00       	push   $0x8025a8
  80056e:	e8 18 03 00 00       	call   80088b <cprintf>
  800573:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800576:	83 ec 0c             	sub    $0xc,%esp
  800579:	68 dc 24 80 00       	push   $0x8024dc
  80057e:	e8 08 03 00 00       	call   80088b <cprintf>
  800583:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800586:	e8 25 14 00 00       	call   8019b0 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80058b:	e8 1f 00 00 00       	call   8005af <exit>
}
  800590:	90                   	nop
  800591:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800594:	5b                   	pop    %ebx
  800595:	5e                   	pop    %esi
  800596:	5f                   	pop    %edi
  800597:	5d                   	pop    %ebp
  800598:	c3                   	ret    

00800599 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800599:	55                   	push   %ebp
  80059a:	89 e5                	mov    %esp,%ebp
  80059c:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80059f:	83 ec 0c             	sub    $0xc,%esp
  8005a2:	6a 00                	push   $0x0
  8005a4:	e8 32 16 00 00       	call   801bdb <sys_destroy_env>
  8005a9:	83 c4 10             	add    $0x10,%esp
}
  8005ac:	90                   	nop
  8005ad:	c9                   	leave  
  8005ae:	c3                   	ret    

008005af <exit>:

void
exit(void)
{
  8005af:	55                   	push   %ebp
  8005b0:	89 e5                	mov    %esp,%ebp
  8005b2:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8005b5:	e8 87 16 00 00       	call   801c41 <sys_exit_env>
}
  8005ba:	90                   	nop
  8005bb:	c9                   	leave  
  8005bc:	c3                   	ret    

008005bd <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8005bd:	55                   	push   %ebp
  8005be:	89 e5                	mov    %esp,%ebp
  8005c0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8005c3:	8d 45 10             	lea    0x10(%ebp),%eax
  8005c6:	83 c0 04             	add    $0x4,%eax
  8005c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8005cc:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8005d1:	85 c0                	test   %eax,%eax
  8005d3:	74 16                	je     8005eb <_panic+0x2e>
		cprintf("%s: ", argv0);
  8005d5:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8005da:	83 ec 08             	sub    $0x8,%esp
  8005dd:	50                   	push   %eax
  8005de:	68 20 26 80 00       	push   $0x802620
  8005e3:	e8 a3 02 00 00       	call   80088b <cprintf>
  8005e8:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8005eb:	a1 04 30 80 00       	mov    0x803004,%eax
  8005f0:	83 ec 0c             	sub    $0xc,%esp
  8005f3:	ff 75 0c             	pushl  0xc(%ebp)
  8005f6:	ff 75 08             	pushl  0x8(%ebp)
  8005f9:	50                   	push   %eax
  8005fa:	68 28 26 80 00       	push   $0x802628
  8005ff:	6a 74                	push   $0x74
  800601:	e8 b2 02 00 00       	call   8008b8 <cprintf_colored>
  800606:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800609:	8b 45 10             	mov    0x10(%ebp),%eax
  80060c:	83 ec 08             	sub    $0x8,%esp
  80060f:	ff 75 f4             	pushl  -0xc(%ebp)
  800612:	50                   	push   %eax
  800613:	e8 04 02 00 00       	call   80081c <vcprintf>
  800618:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80061b:	83 ec 08             	sub    $0x8,%esp
  80061e:	6a 00                	push   $0x0
  800620:	68 50 26 80 00       	push   $0x802650
  800625:	e8 f2 01 00 00       	call   80081c <vcprintf>
  80062a:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80062d:	e8 7d ff ff ff       	call   8005af <exit>

	// should not return here
	while (1) ;
  800632:	eb fe                	jmp    800632 <_panic+0x75>

00800634 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800634:	55                   	push   %ebp
  800635:	89 e5                	mov    %esp,%ebp
  800637:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80063a:	a1 20 30 80 00       	mov    0x803020,%eax
  80063f:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800645:	8b 45 0c             	mov    0xc(%ebp),%eax
  800648:	39 c2                	cmp    %eax,%edx
  80064a:	74 14                	je     800660 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80064c:	83 ec 04             	sub    $0x4,%esp
  80064f:	68 54 26 80 00       	push   $0x802654
  800654:	6a 26                	push   $0x26
  800656:	68 a0 26 80 00       	push   $0x8026a0
  80065b:	e8 5d ff ff ff       	call   8005bd <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800660:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800667:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80066e:	e9 c5 00 00 00       	jmp    800738 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800673:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800676:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80067d:	8b 45 08             	mov    0x8(%ebp),%eax
  800680:	01 d0                	add    %edx,%eax
  800682:	8b 00                	mov    (%eax),%eax
  800684:	85 c0                	test   %eax,%eax
  800686:	75 08                	jne    800690 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800688:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80068b:	e9 a5 00 00 00       	jmp    800735 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800690:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800697:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80069e:	eb 69                	jmp    800709 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8006a0:	a1 20 30 80 00       	mov    0x803020,%eax
  8006a5:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8006ab:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8006ae:	89 d0                	mov    %edx,%eax
  8006b0:	01 c0                	add    %eax,%eax
  8006b2:	01 d0                	add    %edx,%eax
  8006b4:	c1 e0 03             	shl    $0x3,%eax
  8006b7:	01 c8                	add    %ecx,%eax
  8006b9:	8a 40 04             	mov    0x4(%eax),%al
  8006bc:	84 c0                	test   %al,%al
  8006be:	75 46                	jne    800706 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8006c0:	a1 20 30 80 00       	mov    0x803020,%eax
  8006c5:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8006cb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8006ce:	89 d0                	mov    %edx,%eax
  8006d0:	01 c0                	add    %eax,%eax
  8006d2:	01 d0                	add    %edx,%eax
  8006d4:	c1 e0 03             	shl    $0x3,%eax
  8006d7:	01 c8                	add    %ecx,%eax
  8006d9:	8b 00                	mov    (%eax),%eax
  8006db:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8006de:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8006e1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8006e6:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8006e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006eb:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8006f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f5:	01 c8                	add    %ecx,%eax
  8006f7:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8006f9:	39 c2                	cmp    %eax,%edx
  8006fb:	75 09                	jne    800706 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8006fd:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800704:	eb 15                	jmp    80071b <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800706:	ff 45 e8             	incl   -0x18(%ebp)
  800709:	a1 20 30 80 00       	mov    0x803020,%eax
  80070e:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800714:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800717:	39 c2                	cmp    %eax,%edx
  800719:	77 85                	ja     8006a0 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80071b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80071f:	75 14                	jne    800735 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800721:	83 ec 04             	sub    $0x4,%esp
  800724:	68 ac 26 80 00       	push   $0x8026ac
  800729:	6a 3a                	push   $0x3a
  80072b:	68 a0 26 80 00       	push   $0x8026a0
  800730:	e8 88 fe ff ff       	call   8005bd <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800735:	ff 45 f0             	incl   -0x10(%ebp)
  800738:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80073b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80073e:	0f 8c 2f ff ff ff    	jl     800673 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800744:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80074b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800752:	eb 26                	jmp    80077a <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800754:	a1 20 30 80 00       	mov    0x803020,%eax
  800759:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80075f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800762:	89 d0                	mov    %edx,%eax
  800764:	01 c0                	add    %eax,%eax
  800766:	01 d0                	add    %edx,%eax
  800768:	c1 e0 03             	shl    $0x3,%eax
  80076b:	01 c8                	add    %ecx,%eax
  80076d:	8a 40 04             	mov    0x4(%eax),%al
  800770:	3c 01                	cmp    $0x1,%al
  800772:	75 03                	jne    800777 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800774:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800777:	ff 45 e0             	incl   -0x20(%ebp)
  80077a:	a1 20 30 80 00       	mov    0x803020,%eax
  80077f:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800785:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800788:	39 c2                	cmp    %eax,%edx
  80078a:	77 c8                	ja     800754 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80078c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80078f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800792:	74 14                	je     8007a8 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800794:	83 ec 04             	sub    $0x4,%esp
  800797:	68 00 27 80 00       	push   $0x802700
  80079c:	6a 44                	push   $0x44
  80079e:	68 a0 26 80 00       	push   $0x8026a0
  8007a3:	e8 15 fe ff ff       	call   8005bd <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8007a8:	90                   	nop
  8007a9:	c9                   	leave  
  8007aa:	c3                   	ret    

008007ab <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8007ab:	55                   	push   %ebp
  8007ac:	89 e5                	mov    %esp,%ebp
  8007ae:	53                   	push   %ebx
  8007af:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8007b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007b5:	8b 00                	mov    (%eax),%eax
  8007b7:	8d 48 01             	lea    0x1(%eax),%ecx
  8007ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007bd:	89 0a                	mov    %ecx,(%edx)
  8007bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8007c2:	88 d1                	mov    %dl,%cl
  8007c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007c7:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8007cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007ce:	8b 00                	mov    (%eax),%eax
  8007d0:	3d ff 00 00 00       	cmp    $0xff,%eax
  8007d5:	75 30                	jne    800807 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8007d7:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  8007dd:	a0 44 30 80 00       	mov    0x803044,%al
  8007e2:	0f b6 c0             	movzbl %al,%eax
  8007e5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007e8:	8b 09                	mov    (%ecx),%ecx
  8007ea:	89 cb                	mov    %ecx,%ebx
  8007ec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007ef:	83 c1 08             	add    $0x8,%ecx
  8007f2:	52                   	push   %edx
  8007f3:	50                   	push   %eax
  8007f4:	53                   	push   %ebx
  8007f5:	51                   	push   %ecx
  8007f6:	e8 57 11 00 00       	call   801952 <sys_cputs>
  8007fb:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8007fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800801:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800807:	8b 45 0c             	mov    0xc(%ebp),%eax
  80080a:	8b 40 04             	mov    0x4(%eax),%eax
  80080d:	8d 50 01             	lea    0x1(%eax),%edx
  800810:	8b 45 0c             	mov    0xc(%ebp),%eax
  800813:	89 50 04             	mov    %edx,0x4(%eax)
}
  800816:	90                   	nop
  800817:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80081a:	c9                   	leave  
  80081b:	c3                   	ret    

0080081c <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80081c:	55                   	push   %ebp
  80081d:	89 e5                	mov    %esp,%ebp
  80081f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800825:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80082c:	00 00 00 
	b.cnt = 0;
  80082f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800836:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800839:	ff 75 0c             	pushl  0xc(%ebp)
  80083c:	ff 75 08             	pushl  0x8(%ebp)
  80083f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800845:	50                   	push   %eax
  800846:	68 ab 07 80 00       	push   $0x8007ab
  80084b:	e8 5a 02 00 00       	call   800aaa <vprintfmt>
  800850:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800853:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  800859:	a0 44 30 80 00       	mov    0x803044,%al
  80085e:	0f b6 c0             	movzbl %al,%eax
  800861:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800867:	52                   	push   %edx
  800868:	50                   	push   %eax
  800869:	51                   	push   %ecx
  80086a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800870:	83 c0 08             	add    $0x8,%eax
  800873:	50                   	push   %eax
  800874:	e8 d9 10 00 00       	call   801952 <sys_cputs>
  800879:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80087c:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  800883:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800889:	c9                   	leave  
  80088a:	c3                   	ret    

0080088b <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80088b:	55                   	push   %ebp
  80088c:	89 e5                	mov    %esp,%ebp
  80088e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800891:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  800898:	8d 45 0c             	lea    0xc(%ebp),%eax
  80089b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80089e:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a1:	83 ec 08             	sub    $0x8,%esp
  8008a4:	ff 75 f4             	pushl  -0xc(%ebp)
  8008a7:	50                   	push   %eax
  8008a8:	e8 6f ff ff ff       	call   80081c <vcprintf>
  8008ad:	83 c4 10             	add    $0x10,%esp
  8008b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8008b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8008b6:	c9                   	leave  
  8008b7:	c3                   	ret    

008008b8 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8008b8:	55                   	push   %ebp
  8008b9:	89 e5                	mov    %esp,%ebp
  8008bb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8008be:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  8008c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c8:	c1 e0 08             	shl    $0x8,%eax
  8008cb:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  8008d0:	8d 45 0c             	lea    0xc(%ebp),%eax
  8008d3:	83 c0 04             	add    $0x4,%eax
  8008d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8008d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008dc:	83 ec 08             	sub    $0x8,%esp
  8008df:	ff 75 f4             	pushl  -0xc(%ebp)
  8008e2:	50                   	push   %eax
  8008e3:	e8 34 ff ff ff       	call   80081c <vcprintf>
  8008e8:	83 c4 10             	add    $0x10,%esp
  8008eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8008ee:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  8008f5:	07 00 00 

	return cnt;
  8008f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8008fb:	c9                   	leave  
  8008fc:	c3                   	ret    

008008fd <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8008fd:	55                   	push   %ebp
  8008fe:	89 e5                	mov    %esp,%ebp
  800900:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800903:	e8 8e 10 00 00       	call   801996 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800908:	8d 45 0c             	lea    0xc(%ebp),%eax
  80090b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80090e:	8b 45 08             	mov    0x8(%ebp),%eax
  800911:	83 ec 08             	sub    $0x8,%esp
  800914:	ff 75 f4             	pushl  -0xc(%ebp)
  800917:	50                   	push   %eax
  800918:	e8 ff fe ff ff       	call   80081c <vcprintf>
  80091d:	83 c4 10             	add    $0x10,%esp
  800920:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800923:	e8 88 10 00 00       	call   8019b0 <sys_unlock_cons>
	return cnt;
  800928:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80092b:	c9                   	leave  
  80092c:	c3                   	ret    

0080092d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80092d:	55                   	push   %ebp
  80092e:	89 e5                	mov    %esp,%ebp
  800930:	53                   	push   %ebx
  800931:	83 ec 14             	sub    $0x14,%esp
  800934:	8b 45 10             	mov    0x10(%ebp),%eax
  800937:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80093a:	8b 45 14             	mov    0x14(%ebp),%eax
  80093d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800940:	8b 45 18             	mov    0x18(%ebp),%eax
  800943:	ba 00 00 00 00       	mov    $0x0,%edx
  800948:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80094b:	77 55                	ja     8009a2 <printnum+0x75>
  80094d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800950:	72 05                	jb     800957 <printnum+0x2a>
  800952:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800955:	77 4b                	ja     8009a2 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800957:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80095a:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80095d:	8b 45 18             	mov    0x18(%ebp),%eax
  800960:	ba 00 00 00 00       	mov    $0x0,%edx
  800965:	52                   	push   %edx
  800966:	50                   	push   %eax
  800967:	ff 75 f4             	pushl  -0xc(%ebp)
  80096a:	ff 75 f0             	pushl  -0x10(%ebp)
  80096d:	e8 aa 16 00 00       	call   80201c <__udivdi3>
  800972:	83 c4 10             	add    $0x10,%esp
  800975:	83 ec 04             	sub    $0x4,%esp
  800978:	ff 75 20             	pushl  0x20(%ebp)
  80097b:	53                   	push   %ebx
  80097c:	ff 75 18             	pushl  0x18(%ebp)
  80097f:	52                   	push   %edx
  800980:	50                   	push   %eax
  800981:	ff 75 0c             	pushl  0xc(%ebp)
  800984:	ff 75 08             	pushl  0x8(%ebp)
  800987:	e8 a1 ff ff ff       	call   80092d <printnum>
  80098c:	83 c4 20             	add    $0x20,%esp
  80098f:	eb 1a                	jmp    8009ab <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800991:	83 ec 08             	sub    $0x8,%esp
  800994:	ff 75 0c             	pushl  0xc(%ebp)
  800997:	ff 75 20             	pushl  0x20(%ebp)
  80099a:	8b 45 08             	mov    0x8(%ebp),%eax
  80099d:	ff d0                	call   *%eax
  80099f:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8009a2:	ff 4d 1c             	decl   0x1c(%ebp)
  8009a5:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8009a9:	7f e6                	jg     800991 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8009ab:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8009ae:	bb 00 00 00 00       	mov    $0x0,%ebx
  8009b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009b9:	53                   	push   %ebx
  8009ba:	51                   	push   %ecx
  8009bb:	52                   	push   %edx
  8009bc:	50                   	push   %eax
  8009bd:	e8 6a 17 00 00       	call   80212c <__umoddi3>
  8009c2:	83 c4 10             	add    $0x10,%esp
  8009c5:	05 74 29 80 00       	add    $0x802974,%eax
  8009ca:	8a 00                	mov    (%eax),%al
  8009cc:	0f be c0             	movsbl %al,%eax
  8009cf:	83 ec 08             	sub    $0x8,%esp
  8009d2:	ff 75 0c             	pushl  0xc(%ebp)
  8009d5:	50                   	push   %eax
  8009d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d9:	ff d0                	call   *%eax
  8009db:	83 c4 10             	add    $0x10,%esp
}
  8009de:	90                   	nop
  8009df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009e2:	c9                   	leave  
  8009e3:	c3                   	ret    

008009e4 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8009e4:	55                   	push   %ebp
  8009e5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8009e7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8009eb:	7e 1c                	jle    800a09 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8009ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f0:	8b 00                	mov    (%eax),%eax
  8009f2:	8d 50 08             	lea    0x8(%eax),%edx
  8009f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f8:	89 10                	mov    %edx,(%eax)
  8009fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fd:	8b 00                	mov    (%eax),%eax
  8009ff:	83 e8 08             	sub    $0x8,%eax
  800a02:	8b 50 04             	mov    0x4(%eax),%edx
  800a05:	8b 00                	mov    (%eax),%eax
  800a07:	eb 40                	jmp    800a49 <getuint+0x65>
	else if (lflag)
  800a09:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a0d:	74 1e                	je     800a2d <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a12:	8b 00                	mov    (%eax),%eax
  800a14:	8d 50 04             	lea    0x4(%eax),%edx
  800a17:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1a:	89 10                	mov    %edx,(%eax)
  800a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1f:	8b 00                	mov    (%eax),%eax
  800a21:	83 e8 04             	sub    $0x4,%eax
  800a24:	8b 00                	mov    (%eax),%eax
  800a26:	ba 00 00 00 00       	mov    $0x0,%edx
  800a2b:	eb 1c                	jmp    800a49 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a30:	8b 00                	mov    (%eax),%eax
  800a32:	8d 50 04             	lea    0x4(%eax),%edx
  800a35:	8b 45 08             	mov    0x8(%ebp),%eax
  800a38:	89 10                	mov    %edx,(%eax)
  800a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3d:	8b 00                	mov    (%eax),%eax
  800a3f:	83 e8 04             	sub    $0x4,%eax
  800a42:	8b 00                	mov    (%eax),%eax
  800a44:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800a49:	5d                   	pop    %ebp
  800a4a:	c3                   	ret    

00800a4b <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800a4b:	55                   	push   %ebp
  800a4c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800a4e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800a52:	7e 1c                	jle    800a70 <getint+0x25>
		return va_arg(*ap, long long);
  800a54:	8b 45 08             	mov    0x8(%ebp),%eax
  800a57:	8b 00                	mov    (%eax),%eax
  800a59:	8d 50 08             	lea    0x8(%eax),%edx
  800a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5f:	89 10                	mov    %edx,(%eax)
  800a61:	8b 45 08             	mov    0x8(%ebp),%eax
  800a64:	8b 00                	mov    (%eax),%eax
  800a66:	83 e8 08             	sub    $0x8,%eax
  800a69:	8b 50 04             	mov    0x4(%eax),%edx
  800a6c:	8b 00                	mov    (%eax),%eax
  800a6e:	eb 38                	jmp    800aa8 <getint+0x5d>
	else if (lflag)
  800a70:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a74:	74 1a                	je     800a90 <getint+0x45>
		return va_arg(*ap, long);
  800a76:	8b 45 08             	mov    0x8(%ebp),%eax
  800a79:	8b 00                	mov    (%eax),%eax
  800a7b:	8d 50 04             	lea    0x4(%eax),%edx
  800a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a81:	89 10                	mov    %edx,(%eax)
  800a83:	8b 45 08             	mov    0x8(%ebp),%eax
  800a86:	8b 00                	mov    (%eax),%eax
  800a88:	83 e8 04             	sub    $0x4,%eax
  800a8b:	8b 00                	mov    (%eax),%eax
  800a8d:	99                   	cltd   
  800a8e:	eb 18                	jmp    800aa8 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800a90:	8b 45 08             	mov    0x8(%ebp),%eax
  800a93:	8b 00                	mov    (%eax),%eax
  800a95:	8d 50 04             	lea    0x4(%eax),%edx
  800a98:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9b:	89 10                	mov    %edx,(%eax)
  800a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa0:	8b 00                	mov    (%eax),%eax
  800aa2:	83 e8 04             	sub    $0x4,%eax
  800aa5:	8b 00                	mov    (%eax),%eax
  800aa7:	99                   	cltd   
}
  800aa8:	5d                   	pop    %ebp
  800aa9:	c3                   	ret    

00800aaa <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800aaa:	55                   	push   %ebp
  800aab:	89 e5                	mov    %esp,%ebp
  800aad:	56                   	push   %esi
  800aae:	53                   	push   %ebx
  800aaf:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ab2:	eb 17                	jmp    800acb <vprintfmt+0x21>
			if (ch == '\0')
  800ab4:	85 db                	test   %ebx,%ebx
  800ab6:	0f 84 c1 03 00 00    	je     800e7d <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800abc:	83 ec 08             	sub    $0x8,%esp
  800abf:	ff 75 0c             	pushl  0xc(%ebp)
  800ac2:	53                   	push   %ebx
  800ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac6:	ff d0                	call   *%eax
  800ac8:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800acb:	8b 45 10             	mov    0x10(%ebp),%eax
  800ace:	8d 50 01             	lea    0x1(%eax),%edx
  800ad1:	89 55 10             	mov    %edx,0x10(%ebp)
  800ad4:	8a 00                	mov    (%eax),%al
  800ad6:	0f b6 d8             	movzbl %al,%ebx
  800ad9:	83 fb 25             	cmp    $0x25,%ebx
  800adc:	75 d6                	jne    800ab4 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800ade:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800ae2:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800ae9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800af0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800af7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800afe:	8b 45 10             	mov    0x10(%ebp),%eax
  800b01:	8d 50 01             	lea    0x1(%eax),%edx
  800b04:	89 55 10             	mov    %edx,0x10(%ebp)
  800b07:	8a 00                	mov    (%eax),%al
  800b09:	0f b6 d8             	movzbl %al,%ebx
  800b0c:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800b0f:	83 f8 5b             	cmp    $0x5b,%eax
  800b12:	0f 87 3d 03 00 00    	ja     800e55 <vprintfmt+0x3ab>
  800b18:	8b 04 85 98 29 80 00 	mov    0x802998(,%eax,4),%eax
  800b1f:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800b21:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800b25:	eb d7                	jmp    800afe <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800b27:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800b2b:	eb d1                	jmp    800afe <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800b2d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800b34:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800b37:	89 d0                	mov    %edx,%eax
  800b39:	c1 e0 02             	shl    $0x2,%eax
  800b3c:	01 d0                	add    %edx,%eax
  800b3e:	01 c0                	add    %eax,%eax
  800b40:	01 d8                	add    %ebx,%eax
  800b42:	83 e8 30             	sub    $0x30,%eax
  800b45:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800b48:	8b 45 10             	mov    0x10(%ebp),%eax
  800b4b:	8a 00                	mov    (%eax),%al
  800b4d:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800b50:	83 fb 2f             	cmp    $0x2f,%ebx
  800b53:	7e 3e                	jle    800b93 <vprintfmt+0xe9>
  800b55:	83 fb 39             	cmp    $0x39,%ebx
  800b58:	7f 39                	jg     800b93 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800b5a:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800b5d:	eb d5                	jmp    800b34 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800b5f:	8b 45 14             	mov    0x14(%ebp),%eax
  800b62:	83 c0 04             	add    $0x4,%eax
  800b65:	89 45 14             	mov    %eax,0x14(%ebp)
  800b68:	8b 45 14             	mov    0x14(%ebp),%eax
  800b6b:	83 e8 04             	sub    $0x4,%eax
  800b6e:	8b 00                	mov    (%eax),%eax
  800b70:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800b73:	eb 1f                	jmp    800b94 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800b75:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b79:	79 83                	jns    800afe <vprintfmt+0x54>
				width = 0;
  800b7b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800b82:	e9 77 ff ff ff       	jmp    800afe <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800b87:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800b8e:	e9 6b ff ff ff       	jmp    800afe <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800b93:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800b94:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b98:	0f 89 60 ff ff ff    	jns    800afe <vprintfmt+0x54>
				width = precision, precision = -1;
  800b9e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ba1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800ba4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800bab:	e9 4e ff ff ff       	jmp    800afe <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800bb0:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800bb3:	e9 46 ff ff ff       	jmp    800afe <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800bb8:	8b 45 14             	mov    0x14(%ebp),%eax
  800bbb:	83 c0 04             	add    $0x4,%eax
  800bbe:	89 45 14             	mov    %eax,0x14(%ebp)
  800bc1:	8b 45 14             	mov    0x14(%ebp),%eax
  800bc4:	83 e8 04             	sub    $0x4,%eax
  800bc7:	8b 00                	mov    (%eax),%eax
  800bc9:	83 ec 08             	sub    $0x8,%esp
  800bcc:	ff 75 0c             	pushl  0xc(%ebp)
  800bcf:	50                   	push   %eax
  800bd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd3:	ff d0                	call   *%eax
  800bd5:	83 c4 10             	add    $0x10,%esp
			break;
  800bd8:	e9 9b 02 00 00       	jmp    800e78 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800bdd:	8b 45 14             	mov    0x14(%ebp),%eax
  800be0:	83 c0 04             	add    $0x4,%eax
  800be3:	89 45 14             	mov    %eax,0x14(%ebp)
  800be6:	8b 45 14             	mov    0x14(%ebp),%eax
  800be9:	83 e8 04             	sub    $0x4,%eax
  800bec:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800bee:	85 db                	test   %ebx,%ebx
  800bf0:	79 02                	jns    800bf4 <vprintfmt+0x14a>
				err = -err;
  800bf2:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800bf4:	83 fb 64             	cmp    $0x64,%ebx
  800bf7:	7f 0b                	jg     800c04 <vprintfmt+0x15a>
  800bf9:	8b 34 9d e0 27 80 00 	mov    0x8027e0(,%ebx,4),%esi
  800c00:	85 f6                	test   %esi,%esi
  800c02:	75 19                	jne    800c1d <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800c04:	53                   	push   %ebx
  800c05:	68 85 29 80 00       	push   $0x802985
  800c0a:	ff 75 0c             	pushl  0xc(%ebp)
  800c0d:	ff 75 08             	pushl  0x8(%ebp)
  800c10:	e8 70 02 00 00       	call   800e85 <printfmt>
  800c15:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800c18:	e9 5b 02 00 00       	jmp    800e78 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800c1d:	56                   	push   %esi
  800c1e:	68 8e 29 80 00       	push   $0x80298e
  800c23:	ff 75 0c             	pushl  0xc(%ebp)
  800c26:	ff 75 08             	pushl  0x8(%ebp)
  800c29:	e8 57 02 00 00       	call   800e85 <printfmt>
  800c2e:	83 c4 10             	add    $0x10,%esp
			break;
  800c31:	e9 42 02 00 00       	jmp    800e78 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800c36:	8b 45 14             	mov    0x14(%ebp),%eax
  800c39:	83 c0 04             	add    $0x4,%eax
  800c3c:	89 45 14             	mov    %eax,0x14(%ebp)
  800c3f:	8b 45 14             	mov    0x14(%ebp),%eax
  800c42:	83 e8 04             	sub    $0x4,%eax
  800c45:	8b 30                	mov    (%eax),%esi
  800c47:	85 f6                	test   %esi,%esi
  800c49:	75 05                	jne    800c50 <vprintfmt+0x1a6>
				p = "(null)";
  800c4b:	be 91 29 80 00       	mov    $0x802991,%esi
			if (width > 0 && padc != '-')
  800c50:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c54:	7e 6d                	jle    800cc3 <vprintfmt+0x219>
  800c56:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800c5a:	74 67                	je     800cc3 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800c5c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c5f:	83 ec 08             	sub    $0x8,%esp
  800c62:	50                   	push   %eax
  800c63:	56                   	push   %esi
  800c64:	e8 1e 03 00 00       	call   800f87 <strnlen>
  800c69:	83 c4 10             	add    $0x10,%esp
  800c6c:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800c6f:	eb 16                	jmp    800c87 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800c71:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800c75:	83 ec 08             	sub    $0x8,%esp
  800c78:	ff 75 0c             	pushl  0xc(%ebp)
  800c7b:	50                   	push   %eax
  800c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7f:	ff d0                	call   *%eax
  800c81:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800c84:	ff 4d e4             	decl   -0x1c(%ebp)
  800c87:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c8b:	7f e4                	jg     800c71 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c8d:	eb 34                	jmp    800cc3 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800c8f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800c93:	74 1c                	je     800cb1 <vprintfmt+0x207>
  800c95:	83 fb 1f             	cmp    $0x1f,%ebx
  800c98:	7e 05                	jle    800c9f <vprintfmt+0x1f5>
  800c9a:	83 fb 7e             	cmp    $0x7e,%ebx
  800c9d:	7e 12                	jle    800cb1 <vprintfmt+0x207>
					putch('?', putdat);
  800c9f:	83 ec 08             	sub    $0x8,%esp
  800ca2:	ff 75 0c             	pushl  0xc(%ebp)
  800ca5:	6a 3f                	push   $0x3f
  800ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  800caa:	ff d0                	call   *%eax
  800cac:	83 c4 10             	add    $0x10,%esp
  800caf:	eb 0f                	jmp    800cc0 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800cb1:	83 ec 08             	sub    $0x8,%esp
  800cb4:	ff 75 0c             	pushl  0xc(%ebp)
  800cb7:	53                   	push   %ebx
  800cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbb:	ff d0                	call   *%eax
  800cbd:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800cc0:	ff 4d e4             	decl   -0x1c(%ebp)
  800cc3:	89 f0                	mov    %esi,%eax
  800cc5:	8d 70 01             	lea    0x1(%eax),%esi
  800cc8:	8a 00                	mov    (%eax),%al
  800cca:	0f be d8             	movsbl %al,%ebx
  800ccd:	85 db                	test   %ebx,%ebx
  800ccf:	74 24                	je     800cf5 <vprintfmt+0x24b>
  800cd1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800cd5:	78 b8                	js     800c8f <vprintfmt+0x1e5>
  800cd7:	ff 4d e0             	decl   -0x20(%ebp)
  800cda:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800cde:	79 af                	jns    800c8f <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ce0:	eb 13                	jmp    800cf5 <vprintfmt+0x24b>
				putch(' ', putdat);
  800ce2:	83 ec 08             	sub    $0x8,%esp
  800ce5:	ff 75 0c             	pushl  0xc(%ebp)
  800ce8:	6a 20                	push   $0x20
  800cea:	8b 45 08             	mov    0x8(%ebp),%eax
  800ced:	ff d0                	call   *%eax
  800cef:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800cf2:	ff 4d e4             	decl   -0x1c(%ebp)
  800cf5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cf9:	7f e7                	jg     800ce2 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800cfb:	e9 78 01 00 00       	jmp    800e78 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800d00:	83 ec 08             	sub    $0x8,%esp
  800d03:	ff 75 e8             	pushl  -0x18(%ebp)
  800d06:	8d 45 14             	lea    0x14(%ebp),%eax
  800d09:	50                   	push   %eax
  800d0a:	e8 3c fd ff ff       	call   800a4b <getint>
  800d0f:	83 c4 10             	add    $0x10,%esp
  800d12:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d15:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800d18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d1b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d1e:	85 d2                	test   %edx,%edx
  800d20:	79 23                	jns    800d45 <vprintfmt+0x29b>
				putch('-', putdat);
  800d22:	83 ec 08             	sub    $0x8,%esp
  800d25:	ff 75 0c             	pushl  0xc(%ebp)
  800d28:	6a 2d                	push   $0x2d
  800d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2d:	ff d0                	call   *%eax
  800d2f:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800d32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d35:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d38:	f7 d8                	neg    %eax
  800d3a:	83 d2 00             	adc    $0x0,%edx
  800d3d:	f7 da                	neg    %edx
  800d3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d42:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800d45:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800d4c:	e9 bc 00 00 00       	jmp    800e0d <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800d51:	83 ec 08             	sub    $0x8,%esp
  800d54:	ff 75 e8             	pushl  -0x18(%ebp)
  800d57:	8d 45 14             	lea    0x14(%ebp),%eax
  800d5a:	50                   	push   %eax
  800d5b:	e8 84 fc ff ff       	call   8009e4 <getuint>
  800d60:	83 c4 10             	add    $0x10,%esp
  800d63:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d66:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800d69:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800d70:	e9 98 00 00 00       	jmp    800e0d <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800d75:	83 ec 08             	sub    $0x8,%esp
  800d78:	ff 75 0c             	pushl  0xc(%ebp)
  800d7b:	6a 58                	push   $0x58
  800d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d80:	ff d0                	call   *%eax
  800d82:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800d85:	83 ec 08             	sub    $0x8,%esp
  800d88:	ff 75 0c             	pushl  0xc(%ebp)
  800d8b:	6a 58                	push   $0x58
  800d8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d90:	ff d0                	call   *%eax
  800d92:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800d95:	83 ec 08             	sub    $0x8,%esp
  800d98:	ff 75 0c             	pushl  0xc(%ebp)
  800d9b:	6a 58                	push   $0x58
  800d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800da0:	ff d0                	call   *%eax
  800da2:	83 c4 10             	add    $0x10,%esp
			break;
  800da5:	e9 ce 00 00 00       	jmp    800e78 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800daa:	83 ec 08             	sub    $0x8,%esp
  800dad:	ff 75 0c             	pushl  0xc(%ebp)
  800db0:	6a 30                	push   $0x30
  800db2:	8b 45 08             	mov    0x8(%ebp),%eax
  800db5:	ff d0                	call   *%eax
  800db7:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800dba:	83 ec 08             	sub    $0x8,%esp
  800dbd:	ff 75 0c             	pushl  0xc(%ebp)
  800dc0:	6a 78                	push   $0x78
  800dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc5:	ff d0                	call   *%eax
  800dc7:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800dca:	8b 45 14             	mov    0x14(%ebp),%eax
  800dcd:	83 c0 04             	add    $0x4,%eax
  800dd0:	89 45 14             	mov    %eax,0x14(%ebp)
  800dd3:	8b 45 14             	mov    0x14(%ebp),%eax
  800dd6:	83 e8 04             	sub    $0x4,%eax
  800dd9:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ddb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dde:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800de5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800dec:	eb 1f                	jmp    800e0d <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800dee:	83 ec 08             	sub    $0x8,%esp
  800df1:	ff 75 e8             	pushl  -0x18(%ebp)
  800df4:	8d 45 14             	lea    0x14(%ebp),%eax
  800df7:	50                   	push   %eax
  800df8:	e8 e7 fb ff ff       	call   8009e4 <getuint>
  800dfd:	83 c4 10             	add    $0x10,%esp
  800e00:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e03:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800e06:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800e0d:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800e11:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e14:	83 ec 04             	sub    $0x4,%esp
  800e17:	52                   	push   %edx
  800e18:	ff 75 e4             	pushl  -0x1c(%ebp)
  800e1b:	50                   	push   %eax
  800e1c:	ff 75 f4             	pushl  -0xc(%ebp)
  800e1f:	ff 75 f0             	pushl  -0x10(%ebp)
  800e22:	ff 75 0c             	pushl  0xc(%ebp)
  800e25:	ff 75 08             	pushl  0x8(%ebp)
  800e28:	e8 00 fb ff ff       	call   80092d <printnum>
  800e2d:	83 c4 20             	add    $0x20,%esp
			break;
  800e30:	eb 46                	jmp    800e78 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800e32:	83 ec 08             	sub    $0x8,%esp
  800e35:	ff 75 0c             	pushl  0xc(%ebp)
  800e38:	53                   	push   %ebx
  800e39:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3c:	ff d0                	call   *%eax
  800e3e:	83 c4 10             	add    $0x10,%esp
			break;
  800e41:	eb 35                	jmp    800e78 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800e43:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800e4a:	eb 2c                	jmp    800e78 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800e4c:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800e53:	eb 23                	jmp    800e78 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800e55:	83 ec 08             	sub    $0x8,%esp
  800e58:	ff 75 0c             	pushl  0xc(%ebp)
  800e5b:	6a 25                	push   $0x25
  800e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e60:	ff d0                	call   *%eax
  800e62:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800e65:	ff 4d 10             	decl   0x10(%ebp)
  800e68:	eb 03                	jmp    800e6d <vprintfmt+0x3c3>
  800e6a:	ff 4d 10             	decl   0x10(%ebp)
  800e6d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e70:	48                   	dec    %eax
  800e71:	8a 00                	mov    (%eax),%al
  800e73:	3c 25                	cmp    $0x25,%al
  800e75:	75 f3                	jne    800e6a <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800e77:	90                   	nop
		}
	}
  800e78:	e9 35 fc ff ff       	jmp    800ab2 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800e7d:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800e7e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e81:	5b                   	pop    %ebx
  800e82:	5e                   	pop    %esi
  800e83:	5d                   	pop    %ebp
  800e84:	c3                   	ret    

00800e85 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800e85:	55                   	push   %ebp
  800e86:	89 e5                	mov    %esp,%ebp
  800e88:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800e8b:	8d 45 10             	lea    0x10(%ebp),%eax
  800e8e:	83 c0 04             	add    $0x4,%eax
  800e91:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800e94:	8b 45 10             	mov    0x10(%ebp),%eax
  800e97:	ff 75 f4             	pushl  -0xc(%ebp)
  800e9a:	50                   	push   %eax
  800e9b:	ff 75 0c             	pushl  0xc(%ebp)
  800e9e:	ff 75 08             	pushl  0x8(%ebp)
  800ea1:	e8 04 fc ff ff       	call   800aaa <vprintfmt>
  800ea6:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800ea9:	90                   	nop
  800eaa:	c9                   	leave  
  800eab:	c3                   	ret    

00800eac <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800eac:	55                   	push   %ebp
  800ead:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800eaf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb2:	8b 40 08             	mov    0x8(%eax),%eax
  800eb5:	8d 50 01             	lea    0x1(%eax),%edx
  800eb8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ebb:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800ebe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec1:	8b 10                	mov    (%eax),%edx
  800ec3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec6:	8b 40 04             	mov    0x4(%eax),%eax
  800ec9:	39 c2                	cmp    %eax,%edx
  800ecb:	73 12                	jae    800edf <sprintputch+0x33>
		*b->buf++ = ch;
  800ecd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed0:	8b 00                	mov    (%eax),%eax
  800ed2:	8d 48 01             	lea    0x1(%eax),%ecx
  800ed5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ed8:	89 0a                	mov    %ecx,(%edx)
  800eda:	8b 55 08             	mov    0x8(%ebp),%edx
  800edd:	88 10                	mov    %dl,(%eax)
}
  800edf:	90                   	nop
  800ee0:	5d                   	pop    %ebp
  800ee1:	c3                   	ret    

00800ee2 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ee2:	55                   	push   %ebp
  800ee3:	89 e5                	mov    %esp,%ebp
  800ee5:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  800eeb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800eee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ef4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef7:	01 d0                	add    %edx,%eax
  800ef9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800efc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800f03:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f07:	74 06                	je     800f0f <vsnprintf+0x2d>
  800f09:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f0d:	7f 07                	jg     800f16 <vsnprintf+0x34>
		return -E_INVAL;
  800f0f:	b8 03 00 00 00       	mov    $0x3,%eax
  800f14:	eb 20                	jmp    800f36 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800f16:	ff 75 14             	pushl  0x14(%ebp)
  800f19:	ff 75 10             	pushl  0x10(%ebp)
  800f1c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800f1f:	50                   	push   %eax
  800f20:	68 ac 0e 80 00       	push   $0x800eac
  800f25:	e8 80 fb ff ff       	call   800aaa <vprintfmt>
  800f2a:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800f2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f30:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800f33:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800f36:	c9                   	leave  
  800f37:	c3                   	ret    

00800f38 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f38:	55                   	push   %ebp
  800f39:	89 e5                	mov    %esp,%ebp
  800f3b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800f3e:	8d 45 10             	lea    0x10(%ebp),%eax
  800f41:	83 c0 04             	add    $0x4,%eax
  800f44:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800f47:	8b 45 10             	mov    0x10(%ebp),%eax
  800f4a:	ff 75 f4             	pushl  -0xc(%ebp)
  800f4d:	50                   	push   %eax
  800f4e:	ff 75 0c             	pushl  0xc(%ebp)
  800f51:	ff 75 08             	pushl  0x8(%ebp)
  800f54:	e8 89 ff ff ff       	call   800ee2 <vsnprintf>
  800f59:	83 c4 10             	add    $0x10,%esp
  800f5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800f5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800f62:	c9                   	leave  
  800f63:	c3                   	ret    

00800f64 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800f64:	55                   	push   %ebp
  800f65:	89 e5                	mov    %esp,%ebp
  800f67:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800f6a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f71:	eb 06                	jmp    800f79 <strlen+0x15>
		n++;
  800f73:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800f76:	ff 45 08             	incl   0x8(%ebp)
  800f79:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7c:	8a 00                	mov    (%eax),%al
  800f7e:	84 c0                	test   %al,%al
  800f80:	75 f1                	jne    800f73 <strlen+0xf>
		n++;
	return n;
  800f82:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f85:	c9                   	leave  
  800f86:	c3                   	ret    

00800f87 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800f87:	55                   	push   %ebp
  800f88:	89 e5                	mov    %esp,%ebp
  800f8a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f8d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f94:	eb 09                	jmp    800f9f <strnlen+0x18>
		n++;
  800f96:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f99:	ff 45 08             	incl   0x8(%ebp)
  800f9c:	ff 4d 0c             	decl   0xc(%ebp)
  800f9f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800fa3:	74 09                	je     800fae <strnlen+0x27>
  800fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa8:	8a 00                	mov    (%eax),%al
  800faa:	84 c0                	test   %al,%al
  800fac:	75 e8                	jne    800f96 <strnlen+0xf>
		n++;
	return n;
  800fae:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800fb1:	c9                   	leave  
  800fb2:	c3                   	ret    

00800fb3 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800fb3:	55                   	push   %ebp
  800fb4:	89 e5                	mov    %esp,%ebp
  800fb6:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800fb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800fbf:	90                   	nop
  800fc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc3:	8d 50 01             	lea    0x1(%eax),%edx
  800fc6:	89 55 08             	mov    %edx,0x8(%ebp)
  800fc9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fcc:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fcf:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800fd2:	8a 12                	mov    (%edx),%dl
  800fd4:	88 10                	mov    %dl,(%eax)
  800fd6:	8a 00                	mov    (%eax),%al
  800fd8:	84 c0                	test   %al,%al
  800fda:	75 e4                	jne    800fc0 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800fdc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800fdf:	c9                   	leave  
  800fe0:	c3                   	ret    

00800fe1 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800fe1:	55                   	push   %ebp
  800fe2:	89 e5                	mov    %esp,%ebp
  800fe4:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fea:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800fed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ff4:	eb 1f                	jmp    801015 <strncpy+0x34>
		*dst++ = *src;
  800ff6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff9:	8d 50 01             	lea    0x1(%eax),%edx
  800ffc:	89 55 08             	mov    %edx,0x8(%ebp)
  800fff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801002:	8a 12                	mov    (%edx),%dl
  801004:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801006:	8b 45 0c             	mov    0xc(%ebp),%eax
  801009:	8a 00                	mov    (%eax),%al
  80100b:	84 c0                	test   %al,%al
  80100d:	74 03                	je     801012 <strncpy+0x31>
			src++;
  80100f:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801012:	ff 45 fc             	incl   -0x4(%ebp)
  801015:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801018:	3b 45 10             	cmp    0x10(%ebp),%eax
  80101b:	72 d9                	jb     800ff6 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80101d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801020:	c9                   	leave  
  801021:	c3                   	ret    

00801022 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801022:	55                   	push   %ebp
  801023:	89 e5                	mov    %esp,%ebp
  801025:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801028:	8b 45 08             	mov    0x8(%ebp),%eax
  80102b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80102e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801032:	74 30                	je     801064 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801034:	eb 16                	jmp    80104c <strlcpy+0x2a>
			*dst++ = *src++;
  801036:	8b 45 08             	mov    0x8(%ebp),%eax
  801039:	8d 50 01             	lea    0x1(%eax),%edx
  80103c:	89 55 08             	mov    %edx,0x8(%ebp)
  80103f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801042:	8d 4a 01             	lea    0x1(%edx),%ecx
  801045:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801048:	8a 12                	mov    (%edx),%dl
  80104a:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80104c:	ff 4d 10             	decl   0x10(%ebp)
  80104f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801053:	74 09                	je     80105e <strlcpy+0x3c>
  801055:	8b 45 0c             	mov    0xc(%ebp),%eax
  801058:	8a 00                	mov    (%eax),%al
  80105a:	84 c0                	test   %al,%al
  80105c:	75 d8                	jne    801036 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80105e:	8b 45 08             	mov    0x8(%ebp),%eax
  801061:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801064:	8b 55 08             	mov    0x8(%ebp),%edx
  801067:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80106a:	29 c2                	sub    %eax,%edx
  80106c:	89 d0                	mov    %edx,%eax
}
  80106e:	c9                   	leave  
  80106f:	c3                   	ret    

00801070 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801070:	55                   	push   %ebp
  801071:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801073:	eb 06                	jmp    80107b <strcmp+0xb>
		p++, q++;
  801075:	ff 45 08             	incl   0x8(%ebp)
  801078:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80107b:	8b 45 08             	mov    0x8(%ebp),%eax
  80107e:	8a 00                	mov    (%eax),%al
  801080:	84 c0                	test   %al,%al
  801082:	74 0e                	je     801092 <strcmp+0x22>
  801084:	8b 45 08             	mov    0x8(%ebp),%eax
  801087:	8a 10                	mov    (%eax),%dl
  801089:	8b 45 0c             	mov    0xc(%ebp),%eax
  80108c:	8a 00                	mov    (%eax),%al
  80108e:	38 c2                	cmp    %al,%dl
  801090:	74 e3                	je     801075 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801092:	8b 45 08             	mov    0x8(%ebp),%eax
  801095:	8a 00                	mov    (%eax),%al
  801097:	0f b6 d0             	movzbl %al,%edx
  80109a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80109d:	8a 00                	mov    (%eax),%al
  80109f:	0f b6 c0             	movzbl %al,%eax
  8010a2:	29 c2                	sub    %eax,%edx
  8010a4:	89 d0                	mov    %edx,%eax
}
  8010a6:	5d                   	pop    %ebp
  8010a7:	c3                   	ret    

008010a8 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8010a8:	55                   	push   %ebp
  8010a9:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8010ab:	eb 09                	jmp    8010b6 <strncmp+0xe>
		n--, p++, q++;
  8010ad:	ff 4d 10             	decl   0x10(%ebp)
  8010b0:	ff 45 08             	incl   0x8(%ebp)
  8010b3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8010b6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010ba:	74 17                	je     8010d3 <strncmp+0x2b>
  8010bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bf:	8a 00                	mov    (%eax),%al
  8010c1:	84 c0                	test   %al,%al
  8010c3:	74 0e                	je     8010d3 <strncmp+0x2b>
  8010c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c8:	8a 10                	mov    (%eax),%dl
  8010ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010cd:	8a 00                	mov    (%eax),%al
  8010cf:	38 c2                	cmp    %al,%dl
  8010d1:	74 da                	je     8010ad <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8010d3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010d7:	75 07                	jne    8010e0 <strncmp+0x38>
		return 0;
  8010d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8010de:	eb 14                	jmp    8010f4 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8010e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e3:	8a 00                	mov    (%eax),%al
  8010e5:	0f b6 d0             	movzbl %al,%edx
  8010e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010eb:	8a 00                	mov    (%eax),%al
  8010ed:	0f b6 c0             	movzbl %al,%eax
  8010f0:	29 c2                	sub    %eax,%edx
  8010f2:	89 d0                	mov    %edx,%eax
}
  8010f4:	5d                   	pop    %ebp
  8010f5:	c3                   	ret    

008010f6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8010f6:	55                   	push   %ebp
  8010f7:	89 e5                	mov    %esp,%ebp
  8010f9:	83 ec 04             	sub    $0x4,%esp
  8010fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ff:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801102:	eb 12                	jmp    801116 <strchr+0x20>
		if (*s == c)
  801104:	8b 45 08             	mov    0x8(%ebp),%eax
  801107:	8a 00                	mov    (%eax),%al
  801109:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80110c:	75 05                	jne    801113 <strchr+0x1d>
			return (char *) s;
  80110e:	8b 45 08             	mov    0x8(%ebp),%eax
  801111:	eb 11                	jmp    801124 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801113:	ff 45 08             	incl   0x8(%ebp)
  801116:	8b 45 08             	mov    0x8(%ebp),%eax
  801119:	8a 00                	mov    (%eax),%al
  80111b:	84 c0                	test   %al,%al
  80111d:	75 e5                	jne    801104 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80111f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801124:	c9                   	leave  
  801125:	c3                   	ret    

00801126 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801126:	55                   	push   %ebp
  801127:	89 e5                	mov    %esp,%ebp
  801129:	83 ec 04             	sub    $0x4,%esp
  80112c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801132:	eb 0d                	jmp    801141 <strfind+0x1b>
		if (*s == c)
  801134:	8b 45 08             	mov    0x8(%ebp),%eax
  801137:	8a 00                	mov    (%eax),%al
  801139:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80113c:	74 0e                	je     80114c <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80113e:	ff 45 08             	incl   0x8(%ebp)
  801141:	8b 45 08             	mov    0x8(%ebp),%eax
  801144:	8a 00                	mov    (%eax),%al
  801146:	84 c0                	test   %al,%al
  801148:	75 ea                	jne    801134 <strfind+0xe>
  80114a:	eb 01                	jmp    80114d <strfind+0x27>
		if (*s == c)
			break;
  80114c:	90                   	nop
	return (char *) s;
  80114d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801150:	c9                   	leave  
  801151:	c3                   	ret    

00801152 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801152:	55                   	push   %ebp
  801153:	89 e5                	mov    %esp,%ebp
  801155:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801158:	8b 45 08             	mov    0x8(%ebp),%eax
  80115b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  80115e:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801162:	76 63                	jbe    8011c7 <memset+0x75>
		uint64 data_block = c;
  801164:	8b 45 0c             	mov    0xc(%ebp),%eax
  801167:	99                   	cltd   
  801168:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80116b:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  80116e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801171:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801174:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801178:	c1 e0 08             	shl    $0x8,%eax
  80117b:	09 45 f0             	or     %eax,-0x10(%ebp)
  80117e:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801181:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801184:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801187:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  80118b:	c1 e0 10             	shl    $0x10,%eax
  80118e:	09 45 f0             	or     %eax,-0x10(%ebp)
  801191:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801194:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801197:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80119a:	89 c2                	mov    %eax,%edx
  80119c:	b8 00 00 00 00       	mov    $0x0,%eax
  8011a1:	09 45 f0             	or     %eax,-0x10(%ebp)
  8011a4:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  8011a7:	eb 18                	jmp    8011c1 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  8011a9:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011ac:	8d 41 08             	lea    0x8(%ecx),%eax
  8011af:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8011b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011b8:	89 01                	mov    %eax,(%ecx)
  8011ba:	89 51 04             	mov    %edx,0x4(%ecx)
  8011bd:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  8011c1:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8011c5:	77 e2                	ja     8011a9 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8011c7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011cb:	74 23                	je     8011f0 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8011cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011d0:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8011d3:	eb 0e                	jmp    8011e3 <memset+0x91>
			*p8++ = (uint8)c;
  8011d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011d8:	8d 50 01             	lea    0x1(%eax),%edx
  8011db:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011e1:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8011e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011e9:	89 55 10             	mov    %edx,0x10(%ebp)
  8011ec:	85 c0                	test   %eax,%eax
  8011ee:	75 e5                	jne    8011d5 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8011f0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011f3:	c9                   	leave  
  8011f4:	c3                   	ret    

008011f5 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8011f5:	55                   	push   %ebp
  8011f6:	89 e5                	mov    %esp,%ebp
  8011f8:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8011fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801201:	8b 45 08             	mov    0x8(%ebp),%eax
  801204:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801207:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80120b:	76 24                	jbe    801231 <memcpy+0x3c>
		while(n >= 8){
  80120d:	eb 1c                	jmp    80122b <memcpy+0x36>
			*d64 = *s64;
  80120f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801212:	8b 50 04             	mov    0x4(%eax),%edx
  801215:	8b 00                	mov    (%eax),%eax
  801217:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80121a:	89 01                	mov    %eax,(%ecx)
  80121c:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  80121f:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801223:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801227:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  80122b:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80122f:	77 de                	ja     80120f <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801231:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801235:	74 31                	je     801268 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801237:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80123a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  80123d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801240:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801243:	eb 16                	jmp    80125b <memcpy+0x66>
			*d8++ = *s8++;
  801245:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801248:	8d 50 01             	lea    0x1(%eax),%edx
  80124b:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80124e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801251:	8d 4a 01             	lea    0x1(%edx),%ecx
  801254:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801257:	8a 12                	mov    (%edx),%dl
  801259:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  80125b:	8b 45 10             	mov    0x10(%ebp),%eax
  80125e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801261:	89 55 10             	mov    %edx,0x10(%ebp)
  801264:	85 c0                	test   %eax,%eax
  801266:	75 dd                	jne    801245 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801268:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80126b:	c9                   	leave  
  80126c:	c3                   	ret    

0080126d <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80126d:	55                   	push   %ebp
  80126e:	89 e5                	mov    %esp,%ebp
  801270:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801273:	8b 45 0c             	mov    0xc(%ebp),%eax
  801276:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801279:	8b 45 08             	mov    0x8(%ebp),%eax
  80127c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80127f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801282:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801285:	73 50                	jae    8012d7 <memmove+0x6a>
  801287:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80128a:	8b 45 10             	mov    0x10(%ebp),%eax
  80128d:	01 d0                	add    %edx,%eax
  80128f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801292:	76 43                	jbe    8012d7 <memmove+0x6a>
		s += n;
  801294:	8b 45 10             	mov    0x10(%ebp),%eax
  801297:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80129a:	8b 45 10             	mov    0x10(%ebp),%eax
  80129d:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8012a0:	eb 10                	jmp    8012b2 <memmove+0x45>
			*--d = *--s;
  8012a2:	ff 4d f8             	decl   -0x8(%ebp)
  8012a5:	ff 4d fc             	decl   -0x4(%ebp)
  8012a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012ab:	8a 10                	mov    (%eax),%dl
  8012ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012b0:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8012b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012b8:	89 55 10             	mov    %edx,0x10(%ebp)
  8012bb:	85 c0                	test   %eax,%eax
  8012bd:	75 e3                	jne    8012a2 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8012bf:	eb 23                	jmp    8012e4 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8012c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012c4:	8d 50 01             	lea    0x1(%eax),%edx
  8012c7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012ca:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012cd:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012d0:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8012d3:	8a 12                	mov    (%edx),%dl
  8012d5:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8012d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8012da:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012dd:	89 55 10             	mov    %edx,0x10(%ebp)
  8012e0:	85 c0                	test   %eax,%eax
  8012e2:	75 dd                	jne    8012c1 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8012e4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012e7:	c9                   	leave  
  8012e8:	c3                   	ret    

008012e9 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8012e9:	55                   	push   %ebp
  8012ea:	89 e5                	mov    %esp,%ebp
  8012ec:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8012ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8012f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f8:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8012fb:	eb 2a                	jmp    801327 <memcmp+0x3e>
		if (*s1 != *s2)
  8012fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801300:	8a 10                	mov    (%eax),%dl
  801302:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801305:	8a 00                	mov    (%eax),%al
  801307:	38 c2                	cmp    %al,%dl
  801309:	74 16                	je     801321 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80130b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80130e:	8a 00                	mov    (%eax),%al
  801310:	0f b6 d0             	movzbl %al,%edx
  801313:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801316:	8a 00                	mov    (%eax),%al
  801318:	0f b6 c0             	movzbl %al,%eax
  80131b:	29 c2                	sub    %eax,%edx
  80131d:	89 d0                	mov    %edx,%eax
  80131f:	eb 18                	jmp    801339 <memcmp+0x50>
		s1++, s2++;
  801321:	ff 45 fc             	incl   -0x4(%ebp)
  801324:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801327:	8b 45 10             	mov    0x10(%ebp),%eax
  80132a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80132d:	89 55 10             	mov    %edx,0x10(%ebp)
  801330:	85 c0                	test   %eax,%eax
  801332:	75 c9                	jne    8012fd <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801334:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801339:	c9                   	leave  
  80133a:	c3                   	ret    

0080133b <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80133b:	55                   	push   %ebp
  80133c:	89 e5                	mov    %esp,%ebp
  80133e:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801341:	8b 55 08             	mov    0x8(%ebp),%edx
  801344:	8b 45 10             	mov    0x10(%ebp),%eax
  801347:	01 d0                	add    %edx,%eax
  801349:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80134c:	eb 15                	jmp    801363 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80134e:	8b 45 08             	mov    0x8(%ebp),%eax
  801351:	8a 00                	mov    (%eax),%al
  801353:	0f b6 d0             	movzbl %al,%edx
  801356:	8b 45 0c             	mov    0xc(%ebp),%eax
  801359:	0f b6 c0             	movzbl %al,%eax
  80135c:	39 c2                	cmp    %eax,%edx
  80135e:	74 0d                	je     80136d <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801360:	ff 45 08             	incl   0x8(%ebp)
  801363:	8b 45 08             	mov    0x8(%ebp),%eax
  801366:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801369:	72 e3                	jb     80134e <memfind+0x13>
  80136b:	eb 01                	jmp    80136e <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80136d:	90                   	nop
	return (void *) s;
  80136e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801371:	c9                   	leave  
  801372:	c3                   	ret    

00801373 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801373:	55                   	push   %ebp
  801374:	89 e5                	mov    %esp,%ebp
  801376:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801379:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801380:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801387:	eb 03                	jmp    80138c <strtol+0x19>
		s++;
  801389:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80138c:	8b 45 08             	mov    0x8(%ebp),%eax
  80138f:	8a 00                	mov    (%eax),%al
  801391:	3c 20                	cmp    $0x20,%al
  801393:	74 f4                	je     801389 <strtol+0x16>
  801395:	8b 45 08             	mov    0x8(%ebp),%eax
  801398:	8a 00                	mov    (%eax),%al
  80139a:	3c 09                	cmp    $0x9,%al
  80139c:	74 eb                	je     801389 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80139e:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a1:	8a 00                	mov    (%eax),%al
  8013a3:	3c 2b                	cmp    $0x2b,%al
  8013a5:	75 05                	jne    8013ac <strtol+0x39>
		s++;
  8013a7:	ff 45 08             	incl   0x8(%ebp)
  8013aa:	eb 13                	jmp    8013bf <strtol+0x4c>
	else if (*s == '-')
  8013ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8013af:	8a 00                	mov    (%eax),%al
  8013b1:	3c 2d                	cmp    $0x2d,%al
  8013b3:	75 0a                	jne    8013bf <strtol+0x4c>
		s++, neg = 1;
  8013b5:	ff 45 08             	incl   0x8(%ebp)
  8013b8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8013bf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013c3:	74 06                	je     8013cb <strtol+0x58>
  8013c5:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8013c9:	75 20                	jne    8013eb <strtol+0x78>
  8013cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ce:	8a 00                	mov    (%eax),%al
  8013d0:	3c 30                	cmp    $0x30,%al
  8013d2:	75 17                	jne    8013eb <strtol+0x78>
  8013d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d7:	40                   	inc    %eax
  8013d8:	8a 00                	mov    (%eax),%al
  8013da:	3c 78                	cmp    $0x78,%al
  8013dc:	75 0d                	jne    8013eb <strtol+0x78>
		s += 2, base = 16;
  8013de:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8013e2:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8013e9:	eb 28                	jmp    801413 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8013eb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013ef:	75 15                	jne    801406 <strtol+0x93>
  8013f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f4:	8a 00                	mov    (%eax),%al
  8013f6:	3c 30                	cmp    $0x30,%al
  8013f8:	75 0c                	jne    801406 <strtol+0x93>
		s++, base = 8;
  8013fa:	ff 45 08             	incl   0x8(%ebp)
  8013fd:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801404:	eb 0d                	jmp    801413 <strtol+0xa0>
	else if (base == 0)
  801406:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80140a:	75 07                	jne    801413 <strtol+0xa0>
		base = 10;
  80140c:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801413:	8b 45 08             	mov    0x8(%ebp),%eax
  801416:	8a 00                	mov    (%eax),%al
  801418:	3c 2f                	cmp    $0x2f,%al
  80141a:	7e 19                	jle    801435 <strtol+0xc2>
  80141c:	8b 45 08             	mov    0x8(%ebp),%eax
  80141f:	8a 00                	mov    (%eax),%al
  801421:	3c 39                	cmp    $0x39,%al
  801423:	7f 10                	jg     801435 <strtol+0xc2>
			dig = *s - '0';
  801425:	8b 45 08             	mov    0x8(%ebp),%eax
  801428:	8a 00                	mov    (%eax),%al
  80142a:	0f be c0             	movsbl %al,%eax
  80142d:	83 e8 30             	sub    $0x30,%eax
  801430:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801433:	eb 42                	jmp    801477 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801435:	8b 45 08             	mov    0x8(%ebp),%eax
  801438:	8a 00                	mov    (%eax),%al
  80143a:	3c 60                	cmp    $0x60,%al
  80143c:	7e 19                	jle    801457 <strtol+0xe4>
  80143e:	8b 45 08             	mov    0x8(%ebp),%eax
  801441:	8a 00                	mov    (%eax),%al
  801443:	3c 7a                	cmp    $0x7a,%al
  801445:	7f 10                	jg     801457 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801447:	8b 45 08             	mov    0x8(%ebp),%eax
  80144a:	8a 00                	mov    (%eax),%al
  80144c:	0f be c0             	movsbl %al,%eax
  80144f:	83 e8 57             	sub    $0x57,%eax
  801452:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801455:	eb 20                	jmp    801477 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801457:	8b 45 08             	mov    0x8(%ebp),%eax
  80145a:	8a 00                	mov    (%eax),%al
  80145c:	3c 40                	cmp    $0x40,%al
  80145e:	7e 39                	jle    801499 <strtol+0x126>
  801460:	8b 45 08             	mov    0x8(%ebp),%eax
  801463:	8a 00                	mov    (%eax),%al
  801465:	3c 5a                	cmp    $0x5a,%al
  801467:	7f 30                	jg     801499 <strtol+0x126>
			dig = *s - 'A' + 10;
  801469:	8b 45 08             	mov    0x8(%ebp),%eax
  80146c:	8a 00                	mov    (%eax),%al
  80146e:	0f be c0             	movsbl %al,%eax
  801471:	83 e8 37             	sub    $0x37,%eax
  801474:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801477:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80147a:	3b 45 10             	cmp    0x10(%ebp),%eax
  80147d:	7d 19                	jge    801498 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80147f:	ff 45 08             	incl   0x8(%ebp)
  801482:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801485:	0f af 45 10          	imul   0x10(%ebp),%eax
  801489:	89 c2                	mov    %eax,%edx
  80148b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80148e:	01 d0                	add    %edx,%eax
  801490:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801493:	e9 7b ff ff ff       	jmp    801413 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801498:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801499:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80149d:	74 08                	je     8014a7 <strtol+0x134>
		*endptr = (char *) s;
  80149f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8014a5:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8014a7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8014ab:	74 07                	je     8014b4 <strtol+0x141>
  8014ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014b0:	f7 d8                	neg    %eax
  8014b2:	eb 03                	jmp    8014b7 <strtol+0x144>
  8014b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014b7:	c9                   	leave  
  8014b8:	c3                   	ret    

008014b9 <ltostr>:

void
ltostr(long value, char *str)
{
  8014b9:	55                   	push   %ebp
  8014ba:	89 e5                	mov    %esp,%ebp
  8014bc:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8014bf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8014c6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8014cd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014d1:	79 13                	jns    8014e6 <ltostr+0x2d>
	{
		neg = 1;
  8014d3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8014da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014dd:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8014e0:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8014e3:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8014e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e9:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8014ee:	99                   	cltd   
  8014ef:	f7 f9                	idiv   %ecx
  8014f1:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8014f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014f7:	8d 50 01             	lea    0x1(%eax),%edx
  8014fa:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014fd:	89 c2                	mov    %eax,%edx
  8014ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801502:	01 d0                	add    %edx,%eax
  801504:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801507:	83 c2 30             	add    $0x30,%edx
  80150a:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80150c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80150f:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801514:	f7 e9                	imul   %ecx
  801516:	c1 fa 02             	sar    $0x2,%edx
  801519:	89 c8                	mov    %ecx,%eax
  80151b:	c1 f8 1f             	sar    $0x1f,%eax
  80151e:	29 c2                	sub    %eax,%edx
  801520:	89 d0                	mov    %edx,%eax
  801522:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801525:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801529:	75 bb                	jne    8014e6 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80152b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801532:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801535:	48                   	dec    %eax
  801536:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801539:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80153d:	74 3d                	je     80157c <ltostr+0xc3>
		start = 1 ;
  80153f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801546:	eb 34                	jmp    80157c <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801548:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80154b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80154e:	01 d0                	add    %edx,%eax
  801550:	8a 00                	mov    (%eax),%al
  801552:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801555:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801558:	8b 45 0c             	mov    0xc(%ebp),%eax
  80155b:	01 c2                	add    %eax,%edx
  80155d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801560:	8b 45 0c             	mov    0xc(%ebp),%eax
  801563:	01 c8                	add    %ecx,%eax
  801565:	8a 00                	mov    (%eax),%al
  801567:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801569:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80156c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80156f:	01 c2                	add    %eax,%edx
  801571:	8a 45 eb             	mov    -0x15(%ebp),%al
  801574:	88 02                	mov    %al,(%edx)
		start++ ;
  801576:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801579:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80157c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80157f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801582:	7c c4                	jl     801548 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801584:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801587:	8b 45 0c             	mov    0xc(%ebp),%eax
  80158a:	01 d0                	add    %edx,%eax
  80158c:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80158f:	90                   	nop
  801590:	c9                   	leave  
  801591:	c3                   	ret    

00801592 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801592:	55                   	push   %ebp
  801593:	89 e5                	mov    %esp,%ebp
  801595:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801598:	ff 75 08             	pushl  0x8(%ebp)
  80159b:	e8 c4 f9 ff ff       	call   800f64 <strlen>
  8015a0:	83 c4 04             	add    $0x4,%esp
  8015a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8015a6:	ff 75 0c             	pushl  0xc(%ebp)
  8015a9:	e8 b6 f9 ff ff       	call   800f64 <strlen>
  8015ae:	83 c4 04             	add    $0x4,%esp
  8015b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8015b4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8015bb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015c2:	eb 17                	jmp    8015db <strcconcat+0x49>
		final[s] = str1[s] ;
  8015c4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8015ca:	01 c2                	add    %eax,%edx
  8015cc:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d2:	01 c8                	add    %ecx,%eax
  8015d4:	8a 00                	mov    (%eax),%al
  8015d6:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8015d8:	ff 45 fc             	incl   -0x4(%ebp)
  8015db:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015de:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8015e1:	7c e1                	jl     8015c4 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8015e3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8015ea:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8015f1:	eb 1f                	jmp    801612 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8015f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015f6:	8d 50 01             	lea    0x1(%eax),%edx
  8015f9:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8015fc:	89 c2                	mov    %eax,%edx
  8015fe:	8b 45 10             	mov    0x10(%ebp),%eax
  801601:	01 c2                	add    %eax,%edx
  801603:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801606:	8b 45 0c             	mov    0xc(%ebp),%eax
  801609:	01 c8                	add    %ecx,%eax
  80160b:	8a 00                	mov    (%eax),%al
  80160d:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80160f:	ff 45 f8             	incl   -0x8(%ebp)
  801612:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801615:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801618:	7c d9                	jl     8015f3 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80161a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80161d:	8b 45 10             	mov    0x10(%ebp),%eax
  801620:	01 d0                	add    %edx,%eax
  801622:	c6 00 00             	movb   $0x0,(%eax)
}
  801625:	90                   	nop
  801626:	c9                   	leave  
  801627:	c3                   	ret    

00801628 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801628:	55                   	push   %ebp
  801629:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80162b:	8b 45 14             	mov    0x14(%ebp),%eax
  80162e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801634:	8b 45 14             	mov    0x14(%ebp),%eax
  801637:	8b 00                	mov    (%eax),%eax
  801639:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801640:	8b 45 10             	mov    0x10(%ebp),%eax
  801643:	01 d0                	add    %edx,%eax
  801645:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80164b:	eb 0c                	jmp    801659 <strsplit+0x31>
			*string++ = 0;
  80164d:	8b 45 08             	mov    0x8(%ebp),%eax
  801650:	8d 50 01             	lea    0x1(%eax),%edx
  801653:	89 55 08             	mov    %edx,0x8(%ebp)
  801656:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801659:	8b 45 08             	mov    0x8(%ebp),%eax
  80165c:	8a 00                	mov    (%eax),%al
  80165e:	84 c0                	test   %al,%al
  801660:	74 18                	je     80167a <strsplit+0x52>
  801662:	8b 45 08             	mov    0x8(%ebp),%eax
  801665:	8a 00                	mov    (%eax),%al
  801667:	0f be c0             	movsbl %al,%eax
  80166a:	50                   	push   %eax
  80166b:	ff 75 0c             	pushl  0xc(%ebp)
  80166e:	e8 83 fa ff ff       	call   8010f6 <strchr>
  801673:	83 c4 08             	add    $0x8,%esp
  801676:	85 c0                	test   %eax,%eax
  801678:	75 d3                	jne    80164d <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80167a:	8b 45 08             	mov    0x8(%ebp),%eax
  80167d:	8a 00                	mov    (%eax),%al
  80167f:	84 c0                	test   %al,%al
  801681:	74 5a                	je     8016dd <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801683:	8b 45 14             	mov    0x14(%ebp),%eax
  801686:	8b 00                	mov    (%eax),%eax
  801688:	83 f8 0f             	cmp    $0xf,%eax
  80168b:	75 07                	jne    801694 <strsplit+0x6c>
		{
			return 0;
  80168d:	b8 00 00 00 00       	mov    $0x0,%eax
  801692:	eb 66                	jmp    8016fa <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801694:	8b 45 14             	mov    0x14(%ebp),%eax
  801697:	8b 00                	mov    (%eax),%eax
  801699:	8d 48 01             	lea    0x1(%eax),%ecx
  80169c:	8b 55 14             	mov    0x14(%ebp),%edx
  80169f:	89 0a                	mov    %ecx,(%edx)
  8016a1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ab:	01 c2                	add    %eax,%edx
  8016ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b0:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016b2:	eb 03                	jmp    8016b7 <strsplit+0x8f>
			string++;
  8016b4:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ba:	8a 00                	mov    (%eax),%al
  8016bc:	84 c0                	test   %al,%al
  8016be:	74 8b                	je     80164b <strsplit+0x23>
  8016c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c3:	8a 00                	mov    (%eax),%al
  8016c5:	0f be c0             	movsbl %al,%eax
  8016c8:	50                   	push   %eax
  8016c9:	ff 75 0c             	pushl  0xc(%ebp)
  8016cc:	e8 25 fa ff ff       	call   8010f6 <strchr>
  8016d1:	83 c4 08             	add    $0x8,%esp
  8016d4:	85 c0                	test   %eax,%eax
  8016d6:	74 dc                	je     8016b4 <strsplit+0x8c>
			string++;
	}
  8016d8:	e9 6e ff ff ff       	jmp    80164b <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8016dd:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8016de:	8b 45 14             	mov    0x14(%ebp),%eax
  8016e1:	8b 00                	mov    (%eax),%eax
  8016e3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ed:	01 d0                	add    %edx,%eax
  8016ef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8016f5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8016fa:	c9                   	leave  
  8016fb:	c3                   	ret    

008016fc <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8016fc:	55                   	push   %ebp
  8016fd:	89 e5                	mov    %esp,%ebp
  8016ff:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801702:	8b 45 08             	mov    0x8(%ebp),%eax
  801705:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801708:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80170f:	eb 4a                	jmp    80175b <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801711:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801714:	8b 45 08             	mov    0x8(%ebp),%eax
  801717:	01 c2                	add    %eax,%edx
  801719:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80171c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80171f:	01 c8                	add    %ecx,%eax
  801721:	8a 00                	mov    (%eax),%al
  801723:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801725:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801728:	8b 45 0c             	mov    0xc(%ebp),%eax
  80172b:	01 d0                	add    %edx,%eax
  80172d:	8a 00                	mov    (%eax),%al
  80172f:	3c 40                	cmp    $0x40,%al
  801731:	7e 25                	jle    801758 <str2lower+0x5c>
  801733:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801736:	8b 45 0c             	mov    0xc(%ebp),%eax
  801739:	01 d0                	add    %edx,%eax
  80173b:	8a 00                	mov    (%eax),%al
  80173d:	3c 5a                	cmp    $0x5a,%al
  80173f:	7f 17                	jg     801758 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801741:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801744:	8b 45 08             	mov    0x8(%ebp),%eax
  801747:	01 d0                	add    %edx,%eax
  801749:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80174c:	8b 55 08             	mov    0x8(%ebp),%edx
  80174f:	01 ca                	add    %ecx,%edx
  801751:	8a 12                	mov    (%edx),%dl
  801753:	83 c2 20             	add    $0x20,%edx
  801756:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801758:	ff 45 fc             	incl   -0x4(%ebp)
  80175b:	ff 75 0c             	pushl  0xc(%ebp)
  80175e:	e8 01 f8 ff ff       	call   800f64 <strlen>
  801763:	83 c4 04             	add    $0x4,%esp
  801766:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801769:	7f a6                	jg     801711 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  80176b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80176e:	c9                   	leave  
  80176f:	c3                   	ret    

00801770 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801770:	55                   	push   %ebp
  801771:	89 e5                	mov    %esp,%ebp
  801773:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801776:	a1 08 30 80 00       	mov    0x803008,%eax
  80177b:	85 c0                	test   %eax,%eax
  80177d:	74 42                	je     8017c1 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  80177f:	83 ec 08             	sub    $0x8,%esp
  801782:	68 00 00 00 82       	push   $0x82000000
  801787:	68 00 00 00 80       	push   $0x80000000
  80178c:	e8 8c 07 00 00       	call   801f1d <initialize_dynamic_allocator>
  801791:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801794:	e8 e7 05 00 00       	call   801d80 <sys_get_uheap_strategy>
  801799:	a3 60 b0 81 00       	mov    %eax,0x81b060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  80179e:	a1 40 30 80 00       	mov    0x803040,%eax
  8017a3:	05 00 10 00 00       	add    $0x1000,%eax
  8017a8:	a3 10 b1 81 00       	mov    %eax,0x81b110
		uheapPageAllocBreak = uheapPageAllocStart;
  8017ad:	a1 10 b1 81 00       	mov    0x81b110,%eax
  8017b2:	a3 68 b0 81 00       	mov    %eax,0x81b068

		__firstTimeFlag = 0;
  8017b7:	c7 05 08 30 80 00 00 	movl   $0x0,0x803008
  8017be:	00 00 00 
	}
}
  8017c1:	90                   	nop
  8017c2:	c9                   	leave  
  8017c3:	c3                   	ret    

008017c4 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  8017c4:	55                   	push   %ebp
  8017c5:	89 e5                	mov    %esp,%ebp
  8017c7:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  8017ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017d3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8017d8:	83 ec 08             	sub    $0x8,%esp
  8017db:	68 06 04 00 00       	push   $0x406
  8017e0:	50                   	push   %eax
  8017e1:	e8 e4 01 00 00       	call   8019ca <__sys_allocate_page>
  8017e6:	83 c4 10             	add    $0x10,%esp
  8017e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8017ec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8017f0:	79 14                	jns    801806 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  8017f2:	83 ec 04             	sub    $0x4,%esp
  8017f5:	68 08 2b 80 00       	push   $0x802b08
  8017fa:	6a 1f                	push   $0x1f
  8017fc:	68 44 2b 80 00       	push   $0x802b44
  801801:	e8 b7 ed ff ff       	call   8005bd <_panic>
	return 0;
  801806:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80180b:	c9                   	leave  
  80180c:	c3                   	ret    

0080180d <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  80180d:	55                   	push   %ebp
  80180e:	89 e5                	mov    %esp,%ebp
  801810:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801813:	8b 45 08             	mov    0x8(%ebp),%eax
  801816:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801819:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80181c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801821:	83 ec 0c             	sub    $0xc,%esp
  801824:	50                   	push   %eax
  801825:	e8 e7 01 00 00       	call   801a11 <__sys_unmap_frame>
  80182a:	83 c4 10             	add    $0x10,%esp
  80182d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801830:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801834:	79 14                	jns    80184a <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801836:	83 ec 04             	sub    $0x4,%esp
  801839:	68 50 2b 80 00       	push   $0x802b50
  80183e:	6a 2a                	push   $0x2a
  801840:	68 44 2b 80 00       	push   $0x802b44
  801845:	e8 73 ed ff ff       	call   8005bd <_panic>
}
  80184a:	90                   	nop
  80184b:	c9                   	leave  
  80184c:	c3                   	ret    

0080184d <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  80184d:	55                   	push   %ebp
  80184e:	89 e5                	mov    %esp,%ebp
  801850:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801853:	e8 18 ff ff ff       	call   801770 <uheap_init>
	if (size == 0) return NULL ;
  801858:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80185c:	75 07                	jne    801865 <malloc+0x18>
  80185e:	b8 00 00 00 00       	mov    $0x0,%eax
  801863:	eb 14                	jmp    801879 <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  801865:	83 ec 04             	sub    $0x4,%esp
  801868:	68 90 2b 80 00       	push   $0x802b90
  80186d:	6a 3e                	push   $0x3e
  80186f:	68 44 2b 80 00       	push   $0x802b44
  801874:	e8 44 ed ff ff       	call   8005bd <_panic>
}
  801879:	c9                   	leave  
  80187a:	c3                   	ret    

0080187b <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  80187b:	55                   	push   %ebp
  80187c:	89 e5                	mov    %esp,%ebp
  80187e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  801881:	83 ec 04             	sub    $0x4,%esp
  801884:	68 b8 2b 80 00       	push   $0x802bb8
  801889:	6a 49                	push   $0x49
  80188b:	68 44 2b 80 00       	push   $0x802b44
  801890:	e8 28 ed ff ff       	call   8005bd <_panic>

00801895 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801895:	55                   	push   %ebp
  801896:	89 e5                	mov    %esp,%ebp
  801898:	83 ec 18             	sub    $0x18,%esp
  80189b:	8b 45 10             	mov    0x10(%ebp),%eax
  80189e:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8018a1:	e8 ca fe ff ff       	call   801770 <uheap_init>
	if (size == 0) return NULL ;
  8018a6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8018aa:	75 07                	jne    8018b3 <smalloc+0x1e>
  8018ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8018b1:	eb 14                	jmp    8018c7 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  8018b3:	83 ec 04             	sub    $0x4,%esp
  8018b6:	68 dc 2b 80 00       	push   $0x802bdc
  8018bb:	6a 5a                	push   $0x5a
  8018bd:	68 44 2b 80 00       	push   $0x802b44
  8018c2:	e8 f6 ec ff ff       	call   8005bd <_panic>
}
  8018c7:	c9                   	leave  
  8018c8:	c3                   	ret    

008018c9 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8018c9:	55                   	push   %ebp
  8018ca:	89 e5                	mov    %esp,%ebp
  8018cc:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8018cf:	e8 9c fe ff ff       	call   801770 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  8018d4:	83 ec 04             	sub    $0x4,%esp
  8018d7:	68 04 2c 80 00       	push   $0x802c04
  8018dc:	6a 6a                	push   $0x6a
  8018de:	68 44 2b 80 00       	push   $0x802b44
  8018e3:	e8 d5 ec ff ff       	call   8005bd <_panic>

008018e8 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8018e8:	55                   	push   %ebp
  8018e9:	89 e5                	mov    %esp,%ebp
  8018eb:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8018ee:	e8 7d fe ff ff       	call   801770 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  8018f3:	83 ec 04             	sub    $0x4,%esp
  8018f6:	68 28 2c 80 00       	push   $0x802c28
  8018fb:	68 88 00 00 00       	push   $0x88
  801900:	68 44 2b 80 00       	push   $0x802b44
  801905:	e8 b3 ec ff ff       	call   8005bd <_panic>

0080190a <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  80190a:	55                   	push   %ebp
  80190b:	89 e5                	mov    %esp,%ebp
  80190d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  801910:	83 ec 04             	sub    $0x4,%esp
  801913:	68 50 2c 80 00       	push   $0x802c50
  801918:	68 9b 00 00 00       	push   $0x9b
  80191d:	68 44 2b 80 00       	push   $0x802b44
  801922:	e8 96 ec ff ff       	call   8005bd <_panic>

00801927 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801927:	55                   	push   %ebp
  801928:	89 e5                	mov    %esp,%ebp
  80192a:	57                   	push   %edi
  80192b:	56                   	push   %esi
  80192c:	53                   	push   %ebx
  80192d:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801930:	8b 45 08             	mov    0x8(%ebp),%eax
  801933:	8b 55 0c             	mov    0xc(%ebp),%edx
  801936:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801939:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80193c:	8b 7d 18             	mov    0x18(%ebp),%edi
  80193f:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801942:	cd 30                	int    $0x30
  801944:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801947:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80194a:	83 c4 10             	add    $0x10,%esp
  80194d:	5b                   	pop    %ebx
  80194e:	5e                   	pop    %esi
  80194f:	5f                   	pop    %edi
  801950:	5d                   	pop    %ebp
  801951:	c3                   	ret    

00801952 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801952:	55                   	push   %ebp
  801953:	89 e5                	mov    %esp,%ebp
  801955:	83 ec 04             	sub    $0x4,%esp
  801958:	8b 45 10             	mov    0x10(%ebp),%eax
  80195b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  80195e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801961:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801965:	8b 45 08             	mov    0x8(%ebp),%eax
  801968:	6a 00                	push   $0x0
  80196a:	51                   	push   %ecx
  80196b:	52                   	push   %edx
  80196c:	ff 75 0c             	pushl  0xc(%ebp)
  80196f:	50                   	push   %eax
  801970:	6a 00                	push   $0x0
  801972:	e8 b0 ff ff ff       	call   801927 <syscall>
  801977:	83 c4 18             	add    $0x18,%esp
}
  80197a:	90                   	nop
  80197b:	c9                   	leave  
  80197c:	c3                   	ret    

0080197d <sys_cgetc>:

int
sys_cgetc(void)
{
  80197d:	55                   	push   %ebp
  80197e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801980:	6a 00                	push   $0x0
  801982:	6a 00                	push   $0x0
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	6a 00                	push   $0x0
  80198a:	6a 02                	push   $0x2
  80198c:	e8 96 ff ff ff       	call   801927 <syscall>
  801991:	83 c4 18             	add    $0x18,%esp
}
  801994:	c9                   	leave  
  801995:	c3                   	ret    

00801996 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801996:	55                   	push   %ebp
  801997:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801999:	6a 00                	push   $0x0
  80199b:	6a 00                	push   $0x0
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 03                	push   $0x3
  8019a5:	e8 7d ff ff ff       	call   801927 <syscall>
  8019aa:	83 c4 18             	add    $0x18,%esp
}
  8019ad:	90                   	nop
  8019ae:	c9                   	leave  
  8019af:	c3                   	ret    

008019b0 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8019b0:	55                   	push   %ebp
  8019b1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 00                	push   $0x0
  8019b7:	6a 00                	push   $0x0
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 04                	push   $0x4
  8019bf:	e8 63 ff ff ff       	call   801927 <syscall>
  8019c4:	83 c4 18             	add    $0x18,%esp
}
  8019c7:	90                   	nop
  8019c8:	c9                   	leave  
  8019c9:	c3                   	ret    

008019ca <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8019ca:	55                   	push   %ebp
  8019cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8019cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 00                	push   $0x0
  8019d9:	52                   	push   %edx
  8019da:	50                   	push   %eax
  8019db:	6a 08                	push   $0x8
  8019dd:	e8 45 ff ff ff       	call   801927 <syscall>
  8019e2:	83 c4 18             	add    $0x18,%esp
}
  8019e5:	c9                   	leave  
  8019e6:	c3                   	ret    

008019e7 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8019e7:	55                   	push   %ebp
  8019e8:	89 e5                	mov    %esp,%ebp
  8019ea:	56                   	push   %esi
  8019eb:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8019ec:	8b 75 18             	mov    0x18(%ebp),%esi
  8019ef:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019f2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fb:	56                   	push   %esi
  8019fc:	53                   	push   %ebx
  8019fd:	51                   	push   %ecx
  8019fe:	52                   	push   %edx
  8019ff:	50                   	push   %eax
  801a00:	6a 09                	push   $0x9
  801a02:	e8 20 ff ff ff       	call   801927 <syscall>
  801a07:	83 c4 18             	add    $0x18,%esp
}
  801a0a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a0d:	5b                   	pop    %ebx
  801a0e:	5e                   	pop    %esi
  801a0f:	5d                   	pop    %ebp
  801a10:	c3                   	ret    

00801a11 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801a11:	55                   	push   %ebp
  801a12:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 00                	push   $0x0
  801a1c:	ff 75 08             	pushl  0x8(%ebp)
  801a1f:	6a 0a                	push   $0xa
  801a21:	e8 01 ff ff ff       	call   801927 <syscall>
  801a26:	83 c4 18             	add    $0x18,%esp
}
  801a29:	c9                   	leave  
  801a2a:	c3                   	ret    

00801a2b <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a2b:	55                   	push   %ebp
  801a2c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 00                	push   $0x0
  801a32:	6a 00                	push   $0x0
  801a34:	ff 75 0c             	pushl  0xc(%ebp)
  801a37:	ff 75 08             	pushl  0x8(%ebp)
  801a3a:	6a 0b                	push   $0xb
  801a3c:	e8 e6 fe ff ff       	call   801927 <syscall>
  801a41:	83 c4 18             	add    $0x18,%esp
}
  801a44:	c9                   	leave  
  801a45:	c3                   	ret    

00801a46 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a46:	55                   	push   %ebp
  801a47:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a49:	6a 00                	push   $0x0
  801a4b:	6a 00                	push   $0x0
  801a4d:	6a 00                	push   $0x0
  801a4f:	6a 00                	push   $0x0
  801a51:	6a 00                	push   $0x0
  801a53:	6a 0c                	push   $0xc
  801a55:	e8 cd fe ff ff       	call   801927 <syscall>
  801a5a:	83 c4 18             	add    $0x18,%esp
}
  801a5d:	c9                   	leave  
  801a5e:	c3                   	ret    

00801a5f <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a5f:	55                   	push   %ebp
  801a60:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a62:	6a 00                	push   $0x0
  801a64:	6a 00                	push   $0x0
  801a66:	6a 00                	push   $0x0
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 0d                	push   $0xd
  801a6e:	e8 b4 fe ff ff       	call   801927 <syscall>
  801a73:	83 c4 18             	add    $0x18,%esp
}
  801a76:	c9                   	leave  
  801a77:	c3                   	ret    

00801a78 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a78:	55                   	push   %ebp
  801a79:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a7b:	6a 00                	push   $0x0
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 00                	push   $0x0
  801a83:	6a 00                	push   $0x0
  801a85:	6a 0e                	push   $0xe
  801a87:	e8 9b fe ff ff       	call   801927 <syscall>
  801a8c:	83 c4 18             	add    $0x18,%esp
}
  801a8f:	c9                   	leave  
  801a90:	c3                   	ret    

00801a91 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a91:	55                   	push   %ebp
  801a92:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a94:	6a 00                	push   $0x0
  801a96:	6a 00                	push   $0x0
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 0f                	push   $0xf
  801aa0:	e8 82 fe ff ff       	call   801927 <syscall>
  801aa5:	83 c4 18             	add    $0x18,%esp
}
  801aa8:	c9                   	leave  
  801aa9:	c3                   	ret    

00801aaa <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801aaa:	55                   	push   %ebp
  801aab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801aad:	6a 00                	push   $0x0
  801aaf:	6a 00                	push   $0x0
  801ab1:	6a 00                	push   $0x0
  801ab3:	6a 00                	push   $0x0
  801ab5:	ff 75 08             	pushl  0x8(%ebp)
  801ab8:	6a 10                	push   $0x10
  801aba:	e8 68 fe ff ff       	call   801927 <syscall>
  801abf:	83 c4 18             	add    $0x18,%esp
}
  801ac2:	c9                   	leave  
  801ac3:	c3                   	ret    

00801ac4 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801ac4:	55                   	push   %ebp
  801ac5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 00                	push   $0x0
  801acd:	6a 00                	push   $0x0
  801acf:	6a 00                	push   $0x0
  801ad1:	6a 11                	push   $0x11
  801ad3:	e8 4f fe ff ff       	call   801927 <syscall>
  801ad8:	83 c4 18             	add    $0x18,%esp
}
  801adb:	90                   	nop
  801adc:	c9                   	leave  
  801add:	c3                   	ret    

00801ade <sys_cputc>:

void
sys_cputc(const char c)
{
  801ade:	55                   	push   %ebp
  801adf:	89 e5                	mov    %esp,%ebp
  801ae1:	83 ec 04             	sub    $0x4,%esp
  801ae4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801aea:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	50                   	push   %eax
  801af7:	6a 01                	push   $0x1
  801af9:	e8 29 fe ff ff       	call   801927 <syscall>
  801afe:	83 c4 18             	add    $0x18,%esp
}
  801b01:	90                   	nop
  801b02:	c9                   	leave  
  801b03:	c3                   	ret    

00801b04 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b04:	55                   	push   %ebp
  801b05:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 14                	push   $0x14
  801b13:	e8 0f fe ff ff       	call   801927 <syscall>
  801b18:	83 c4 18             	add    $0x18,%esp
}
  801b1b:	90                   	nop
  801b1c:	c9                   	leave  
  801b1d:	c3                   	ret    

00801b1e <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b1e:	55                   	push   %ebp
  801b1f:	89 e5                	mov    %esp,%ebp
  801b21:	83 ec 04             	sub    $0x4,%esp
  801b24:	8b 45 10             	mov    0x10(%ebp),%eax
  801b27:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b2a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b2d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b31:	8b 45 08             	mov    0x8(%ebp),%eax
  801b34:	6a 00                	push   $0x0
  801b36:	51                   	push   %ecx
  801b37:	52                   	push   %edx
  801b38:	ff 75 0c             	pushl  0xc(%ebp)
  801b3b:	50                   	push   %eax
  801b3c:	6a 15                	push   $0x15
  801b3e:	e8 e4 fd ff ff       	call   801927 <syscall>
  801b43:	83 c4 18             	add    $0x18,%esp
}
  801b46:	c9                   	leave  
  801b47:	c3                   	ret    

00801b48 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801b48:	55                   	push   %ebp
  801b49:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b4b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b51:	6a 00                	push   $0x0
  801b53:	6a 00                	push   $0x0
  801b55:	6a 00                	push   $0x0
  801b57:	52                   	push   %edx
  801b58:	50                   	push   %eax
  801b59:	6a 16                	push   $0x16
  801b5b:	e8 c7 fd ff ff       	call   801927 <syscall>
  801b60:	83 c4 18             	add    $0x18,%esp
}
  801b63:	c9                   	leave  
  801b64:	c3                   	ret    

00801b65 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801b65:	55                   	push   %ebp
  801b66:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b68:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b6b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b71:	6a 00                	push   $0x0
  801b73:	6a 00                	push   $0x0
  801b75:	51                   	push   %ecx
  801b76:	52                   	push   %edx
  801b77:	50                   	push   %eax
  801b78:	6a 17                	push   $0x17
  801b7a:	e8 a8 fd ff ff       	call   801927 <syscall>
  801b7f:	83 c4 18             	add    $0x18,%esp
}
  801b82:	c9                   	leave  
  801b83:	c3                   	ret    

00801b84 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801b84:	55                   	push   %ebp
  801b85:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b87:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 00                	push   $0x0
  801b93:	52                   	push   %edx
  801b94:	50                   	push   %eax
  801b95:	6a 18                	push   $0x18
  801b97:	e8 8b fd ff ff       	call   801927 <syscall>
  801b9c:	83 c4 18             	add    $0x18,%esp
}
  801b9f:	c9                   	leave  
  801ba0:	c3                   	ret    

00801ba1 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801ba1:	55                   	push   %ebp
  801ba2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801ba4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba7:	6a 00                	push   $0x0
  801ba9:	ff 75 14             	pushl  0x14(%ebp)
  801bac:	ff 75 10             	pushl  0x10(%ebp)
  801baf:	ff 75 0c             	pushl  0xc(%ebp)
  801bb2:	50                   	push   %eax
  801bb3:	6a 19                	push   $0x19
  801bb5:	e8 6d fd ff ff       	call   801927 <syscall>
  801bba:	83 c4 18             	add    $0x18,%esp
}
  801bbd:	c9                   	leave  
  801bbe:	c3                   	ret    

00801bbf <sys_run_env>:

void sys_run_env(int32 envId)
{
  801bbf:	55                   	push   %ebp
  801bc0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 00                	push   $0x0
  801bcb:	6a 00                	push   $0x0
  801bcd:	50                   	push   %eax
  801bce:	6a 1a                	push   $0x1a
  801bd0:	e8 52 fd ff ff       	call   801927 <syscall>
  801bd5:	83 c4 18             	add    $0x18,%esp
}
  801bd8:	90                   	nop
  801bd9:	c9                   	leave  
  801bda:	c3                   	ret    

00801bdb <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801bdb:	55                   	push   %ebp
  801bdc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801bde:	8b 45 08             	mov    0x8(%ebp),%eax
  801be1:	6a 00                	push   $0x0
  801be3:	6a 00                	push   $0x0
  801be5:	6a 00                	push   $0x0
  801be7:	6a 00                	push   $0x0
  801be9:	50                   	push   %eax
  801bea:	6a 1b                	push   $0x1b
  801bec:	e8 36 fd ff ff       	call   801927 <syscall>
  801bf1:	83 c4 18             	add    $0x18,%esp
}
  801bf4:	c9                   	leave  
  801bf5:	c3                   	ret    

00801bf6 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801bf6:	55                   	push   %ebp
  801bf7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801bf9:	6a 00                	push   $0x0
  801bfb:	6a 00                	push   $0x0
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 00                	push   $0x0
  801c01:	6a 00                	push   $0x0
  801c03:	6a 05                	push   $0x5
  801c05:	e8 1d fd ff ff       	call   801927 <syscall>
  801c0a:	83 c4 18             	add    $0x18,%esp
}
  801c0d:	c9                   	leave  
  801c0e:	c3                   	ret    

00801c0f <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c0f:	55                   	push   %ebp
  801c10:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c12:	6a 00                	push   $0x0
  801c14:	6a 00                	push   $0x0
  801c16:	6a 00                	push   $0x0
  801c18:	6a 00                	push   $0x0
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 06                	push   $0x6
  801c1e:	e8 04 fd ff ff       	call   801927 <syscall>
  801c23:	83 c4 18             	add    $0x18,%esp
}
  801c26:	c9                   	leave  
  801c27:	c3                   	ret    

00801c28 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c28:	55                   	push   %ebp
  801c29:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c2b:	6a 00                	push   $0x0
  801c2d:	6a 00                	push   $0x0
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 00                	push   $0x0
  801c33:	6a 00                	push   $0x0
  801c35:	6a 07                	push   $0x7
  801c37:	e8 eb fc ff ff       	call   801927 <syscall>
  801c3c:	83 c4 18             	add    $0x18,%esp
}
  801c3f:	c9                   	leave  
  801c40:	c3                   	ret    

00801c41 <sys_exit_env>:


void sys_exit_env(void)
{
  801c41:	55                   	push   %ebp
  801c42:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c44:	6a 00                	push   $0x0
  801c46:	6a 00                	push   $0x0
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 1c                	push   $0x1c
  801c50:	e8 d2 fc ff ff       	call   801927 <syscall>
  801c55:	83 c4 18             	add    $0x18,%esp
}
  801c58:	90                   	nop
  801c59:	c9                   	leave  
  801c5a:	c3                   	ret    

00801c5b <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801c5b:	55                   	push   %ebp
  801c5c:	89 e5                	mov    %esp,%ebp
  801c5e:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c61:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c64:	8d 50 04             	lea    0x4(%eax),%edx
  801c67:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 00                	push   $0x0
  801c70:	52                   	push   %edx
  801c71:	50                   	push   %eax
  801c72:	6a 1d                	push   $0x1d
  801c74:	e8 ae fc ff ff       	call   801927 <syscall>
  801c79:	83 c4 18             	add    $0x18,%esp
	return result;
  801c7c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c7f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c82:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c85:	89 01                	mov    %eax,(%ecx)
  801c87:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8d:	c9                   	leave  
  801c8e:	c2 04 00             	ret    $0x4

00801c91 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c91:	55                   	push   %ebp
  801c92:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c94:	6a 00                	push   $0x0
  801c96:	6a 00                	push   $0x0
  801c98:	ff 75 10             	pushl  0x10(%ebp)
  801c9b:	ff 75 0c             	pushl  0xc(%ebp)
  801c9e:	ff 75 08             	pushl  0x8(%ebp)
  801ca1:	6a 13                	push   $0x13
  801ca3:	e8 7f fc ff ff       	call   801927 <syscall>
  801ca8:	83 c4 18             	add    $0x18,%esp
	return ;
  801cab:	90                   	nop
}
  801cac:	c9                   	leave  
  801cad:	c3                   	ret    

00801cae <sys_rcr2>:
uint32 sys_rcr2()
{
  801cae:	55                   	push   %ebp
  801caf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801cb1:	6a 00                	push   $0x0
  801cb3:	6a 00                	push   $0x0
  801cb5:	6a 00                	push   $0x0
  801cb7:	6a 00                	push   $0x0
  801cb9:	6a 00                	push   $0x0
  801cbb:	6a 1e                	push   $0x1e
  801cbd:	e8 65 fc ff ff       	call   801927 <syscall>
  801cc2:	83 c4 18             	add    $0x18,%esp
}
  801cc5:	c9                   	leave  
  801cc6:	c3                   	ret    

00801cc7 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801cc7:	55                   	push   %ebp
  801cc8:	89 e5                	mov    %esp,%ebp
  801cca:	83 ec 04             	sub    $0x4,%esp
  801ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801cd3:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801cd7:	6a 00                	push   $0x0
  801cd9:	6a 00                	push   $0x0
  801cdb:	6a 00                	push   $0x0
  801cdd:	6a 00                	push   $0x0
  801cdf:	50                   	push   %eax
  801ce0:	6a 1f                	push   $0x1f
  801ce2:	e8 40 fc ff ff       	call   801927 <syscall>
  801ce7:	83 c4 18             	add    $0x18,%esp
	return ;
  801cea:	90                   	nop
}
  801ceb:	c9                   	leave  
  801cec:	c3                   	ret    

00801ced <rsttst>:
void rsttst()
{
  801ced:	55                   	push   %ebp
  801cee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801cf0:	6a 00                	push   $0x0
  801cf2:	6a 00                	push   $0x0
  801cf4:	6a 00                	push   $0x0
  801cf6:	6a 00                	push   $0x0
  801cf8:	6a 00                	push   $0x0
  801cfa:	6a 21                	push   $0x21
  801cfc:	e8 26 fc ff ff       	call   801927 <syscall>
  801d01:	83 c4 18             	add    $0x18,%esp
	return ;
  801d04:	90                   	nop
}
  801d05:	c9                   	leave  
  801d06:	c3                   	ret    

00801d07 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d07:	55                   	push   %ebp
  801d08:	89 e5                	mov    %esp,%ebp
  801d0a:	83 ec 04             	sub    $0x4,%esp
  801d0d:	8b 45 14             	mov    0x14(%ebp),%eax
  801d10:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d13:	8b 55 18             	mov    0x18(%ebp),%edx
  801d16:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d1a:	52                   	push   %edx
  801d1b:	50                   	push   %eax
  801d1c:	ff 75 10             	pushl  0x10(%ebp)
  801d1f:	ff 75 0c             	pushl  0xc(%ebp)
  801d22:	ff 75 08             	pushl  0x8(%ebp)
  801d25:	6a 20                	push   $0x20
  801d27:	e8 fb fb ff ff       	call   801927 <syscall>
  801d2c:	83 c4 18             	add    $0x18,%esp
	return ;
  801d2f:	90                   	nop
}
  801d30:	c9                   	leave  
  801d31:	c3                   	ret    

00801d32 <chktst>:
void chktst(uint32 n)
{
  801d32:	55                   	push   %ebp
  801d33:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d35:	6a 00                	push   $0x0
  801d37:	6a 00                	push   $0x0
  801d39:	6a 00                	push   $0x0
  801d3b:	6a 00                	push   $0x0
  801d3d:	ff 75 08             	pushl  0x8(%ebp)
  801d40:	6a 22                	push   $0x22
  801d42:	e8 e0 fb ff ff       	call   801927 <syscall>
  801d47:	83 c4 18             	add    $0x18,%esp
	return ;
  801d4a:	90                   	nop
}
  801d4b:	c9                   	leave  
  801d4c:	c3                   	ret    

00801d4d <inctst>:

void inctst()
{
  801d4d:	55                   	push   %ebp
  801d4e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d50:	6a 00                	push   $0x0
  801d52:	6a 00                	push   $0x0
  801d54:	6a 00                	push   $0x0
  801d56:	6a 00                	push   $0x0
  801d58:	6a 00                	push   $0x0
  801d5a:	6a 23                	push   $0x23
  801d5c:	e8 c6 fb ff ff       	call   801927 <syscall>
  801d61:	83 c4 18             	add    $0x18,%esp
	return ;
  801d64:	90                   	nop
}
  801d65:	c9                   	leave  
  801d66:	c3                   	ret    

00801d67 <gettst>:
uint32 gettst()
{
  801d67:	55                   	push   %ebp
  801d68:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d6a:	6a 00                	push   $0x0
  801d6c:	6a 00                	push   $0x0
  801d6e:	6a 00                	push   $0x0
  801d70:	6a 00                	push   $0x0
  801d72:	6a 00                	push   $0x0
  801d74:	6a 24                	push   $0x24
  801d76:	e8 ac fb ff ff       	call   801927 <syscall>
  801d7b:	83 c4 18             	add    $0x18,%esp
}
  801d7e:	c9                   	leave  
  801d7f:	c3                   	ret    

00801d80 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801d80:	55                   	push   %ebp
  801d81:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d83:	6a 00                	push   $0x0
  801d85:	6a 00                	push   $0x0
  801d87:	6a 00                	push   $0x0
  801d89:	6a 00                	push   $0x0
  801d8b:	6a 00                	push   $0x0
  801d8d:	6a 25                	push   $0x25
  801d8f:	e8 93 fb ff ff       	call   801927 <syscall>
  801d94:	83 c4 18             	add    $0x18,%esp
  801d97:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801d9c:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801da1:	c9                   	leave  
  801da2:	c3                   	ret    

00801da3 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801da3:	55                   	push   %ebp
  801da4:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801da6:	8b 45 08             	mov    0x8(%ebp),%eax
  801da9:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801dae:	6a 00                	push   $0x0
  801db0:	6a 00                	push   $0x0
  801db2:	6a 00                	push   $0x0
  801db4:	6a 00                	push   $0x0
  801db6:	ff 75 08             	pushl  0x8(%ebp)
  801db9:	6a 26                	push   $0x26
  801dbb:	e8 67 fb ff ff       	call   801927 <syscall>
  801dc0:	83 c4 18             	add    $0x18,%esp
	return ;
  801dc3:	90                   	nop
}
  801dc4:	c9                   	leave  
  801dc5:	c3                   	ret    

00801dc6 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801dc6:	55                   	push   %ebp
  801dc7:	89 e5                	mov    %esp,%ebp
  801dc9:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801dca:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801dcd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801dd0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd6:	6a 00                	push   $0x0
  801dd8:	53                   	push   %ebx
  801dd9:	51                   	push   %ecx
  801dda:	52                   	push   %edx
  801ddb:	50                   	push   %eax
  801ddc:	6a 27                	push   $0x27
  801dde:	e8 44 fb ff ff       	call   801927 <syscall>
  801de3:	83 c4 18             	add    $0x18,%esp
}
  801de6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801de9:	c9                   	leave  
  801dea:	c3                   	ret    

00801deb <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801deb:	55                   	push   %ebp
  801dec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801dee:	8b 55 0c             	mov    0xc(%ebp),%edx
  801df1:	8b 45 08             	mov    0x8(%ebp),%eax
  801df4:	6a 00                	push   $0x0
  801df6:	6a 00                	push   $0x0
  801df8:	6a 00                	push   $0x0
  801dfa:	52                   	push   %edx
  801dfb:	50                   	push   %eax
  801dfc:	6a 28                	push   $0x28
  801dfe:	e8 24 fb ff ff       	call   801927 <syscall>
  801e03:	83 c4 18             	add    $0x18,%esp
}
  801e06:	c9                   	leave  
  801e07:	c3                   	ret    

00801e08 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801e08:	55                   	push   %ebp
  801e09:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801e0b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801e0e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e11:	8b 45 08             	mov    0x8(%ebp),%eax
  801e14:	6a 00                	push   $0x0
  801e16:	51                   	push   %ecx
  801e17:	ff 75 10             	pushl  0x10(%ebp)
  801e1a:	52                   	push   %edx
  801e1b:	50                   	push   %eax
  801e1c:	6a 29                	push   $0x29
  801e1e:	e8 04 fb ff ff       	call   801927 <syscall>
  801e23:	83 c4 18             	add    $0x18,%esp
}
  801e26:	c9                   	leave  
  801e27:	c3                   	ret    

00801e28 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801e28:	55                   	push   %ebp
  801e29:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 00                	push   $0x0
  801e2f:	ff 75 10             	pushl  0x10(%ebp)
  801e32:	ff 75 0c             	pushl  0xc(%ebp)
  801e35:	ff 75 08             	pushl  0x8(%ebp)
  801e38:	6a 12                	push   $0x12
  801e3a:	e8 e8 fa ff ff       	call   801927 <syscall>
  801e3f:	83 c4 18             	add    $0x18,%esp
	return ;
  801e42:	90                   	nop
}
  801e43:	c9                   	leave  
  801e44:	c3                   	ret    

00801e45 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801e45:	55                   	push   %ebp
  801e46:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801e48:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4e:	6a 00                	push   $0x0
  801e50:	6a 00                	push   $0x0
  801e52:	6a 00                	push   $0x0
  801e54:	52                   	push   %edx
  801e55:	50                   	push   %eax
  801e56:	6a 2a                	push   $0x2a
  801e58:	e8 ca fa ff ff       	call   801927 <syscall>
  801e5d:	83 c4 18             	add    $0x18,%esp
	return;
  801e60:	90                   	nop
}
  801e61:	c9                   	leave  
  801e62:	c3                   	ret    

00801e63 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801e63:	55                   	push   %ebp
  801e64:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801e66:	6a 00                	push   $0x0
  801e68:	6a 00                	push   $0x0
  801e6a:	6a 00                	push   $0x0
  801e6c:	6a 00                	push   $0x0
  801e6e:	6a 00                	push   $0x0
  801e70:	6a 2b                	push   $0x2b
  801e72:	e8 b0 fa ff ff       	call   801927 <syscall>
  801e77:	83 c4 18             	add    $0x18,%esp
}
  801e7a:	c9                   	leave  
  801e7b:	c3                   	ret    

00801e7c <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801e7c:	55                   	push   %ebp
  801e7d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801e7f:	6a 00                	push   $0x0
  801e81:	6a 00                	push   $0x0
  801e83:	6a 00                	push   $0x0
  801e85:	ff 75 0c             	pushl  0xc(%ebp)
  801e88:	ff 75 08             	pushl  0x8(%ebp)
  801e8b:	6a 2d                	push   $0x2d
  801e8d:	e8 95 fa ff ff       	call   801927 <syscall>
  801e92:	83 c4 18             	add    $0x18,%esp
	return;
  801e95:	90                   	nop
}
  801e96:	c9                   	leave  
  801e97:	c3                   	ret    

00801e98 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801e98:	55                   	push   %ebp
  801e99:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801e9b:	6a 00                	push   $0x0
  801e9d:	6a 00                	push   $0x0
  801e9f:	6a 00                	push   $0x0
  801ea1:	ff 75 0c             	pushl  0xc(%ebp)
  801ea4:	ff 75 08             	pushl  0x8(%ebp)
  801ea7:	6a 2c                	push   $0x2c
  801ea9:	e8 79 fa ff ff       	call   801927 <syscall>
  801eae:	83 c4 18             	add    $0x18,%esp
	return ;
  801eb1:	90                   	nop
}
  801eb2:	c9                   	leave  
  801eb3:	c3                   	ret    

00801eb4 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801eb4:	55                   	push   %ebp
  801eb5:	89 e5                	mov    %esp,%ebp
  801eb7:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801eba:	83 ec 04             	sub    $0x4,%esp
  801ebd:	68 74 2c 80 00       	push   $0x802c74
  801ec2:	68 25 01 00 00       	push   $0x125
  801ec7:	68 a7 2c 80 00       	push   $0x802ca7
  801ecc:	e8 ec e6 ff ff       	call   8005bd <_panic>

00801ed1 <to_page_va>:
//==================================================================================//
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  801ed1:	55                   	push   %ebp
  801ed2:	89 e5                	mov    %esp,%ebp
  801ed4:	83 ec 10             	sub    $0x10,%esp
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  801ed7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eda:	ba 60 30 80 00       	mov    $0x803060,%edx
  801edf:	29 d0                	sub    %edx,%eax
  801ee1:	c1 f8 02             	sar    $0x2,%eax
  801ee4:	89 c2                	mov    %eax,%edx
  801ee6:	89 d0                	mov    %edx,%eax
  801ee8:	c1 e0 02             	shl    $0x2,%eax
  801eeb:	01 d0                	add    %edx,%eax
  801eed:	c1 e0 02             	shl    $0x2,%eax
  801ef0:	01 d0                	add    %edx,%eax
  801ef2:	c1 e0 02             	shl    $0x2,%eax
  801ef5:	01 d0                	add    %edx,%eax
  801ef7:	89 c1                	mov    %eax,%ecx
  801ef9:	c1 e1 08             	shl    $0x8,%ecx
  801efc:	01 c8                	add    %ecx,%eax
  801efe:	89 c1                	mov    %eax,%ecx
  801f00:	c1 e1 10             	shl    $0x10,%ecx
  801f03:	01 c8                	add    %ecx,%eax
  801f05:	01 c0                	add    %eax,%eax
  801f07:	01 d0                	add    %edx,%eax
  801f09:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  801f0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f0f:	c1 e0 0c             	shl    $0xc,%eax
  801f12:	89 c2                	mov    %eax,%edx
  801f14:	a1 64 b0 81 00       	mov    0x81b064,%eax
  801f19:	01 d0                	add    %edx,%eax
}
  801f1b:	c9                   	leave  
  801f1c:	c3                   	ret    

00801f1d <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  801f1d:	55                   	push   %ebp
  801f1e:	89 e5                	mov    %esp,%ebp
  801f20:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  801f23:	8b 45 08             	mov    0x8(%ebp),%eax
  801f26:	05 00 00 00 02       	add    $0x2000000,%eax
  801f2b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801f2e:	73 16                	jae    801f46 <initialize_dynamic_allocator+0x29>
  801f30:	68 b8 2c 80 00       	push   $0x802cb8
  801f35:	68 de 2c 80 00       	push   $0x802cde
  801f3a:	6a 26                	push   $0x26
  801f3c:	68 f3 2c 80 00       	push   $0x802cf3
  801f41:	e8 77 e6 ff ff       	call   8005bd <_panic>
		is_initialized = 1;
  801f46:	c7 05 24 30 80 00 01 	movl   $0x1,0x803024
  801f4d:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	//Comment the following line
	panic("initialize_dynamic_allocator() Not implemented yet");
  801f50:	83 ec 04             	sub    $0x4,%esp
  801f53:	68 0c 2d 80 00       	push   $0x802d0c
  801f58:	6a 2e                	push   $0x2e
  801f5a:	68 f3 2c 80 00       	push   $0x802cf3
  801f5f:	e8 59 e6 ff ff       	call   8005bd <_panic>

00801f64 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  801f64:	55                   	push   %ebp
  801f65:	89 e5                	mov    %esp,%ebp
  801f67:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	//Comment the following line
	panic("get_block_size() Not implemented yet");
  801f6a:	83 ec 04             	sub    $0x4,%esp
  801f6d:	68 40 2d 80 00       	push   $0x802d40
  801f72:	6a 3a                	push   $0x3a
  801f74:	68 f3 2c 80 00       	push   $0x802cf3
  801f79:	e8 3f e6 ff ff       	call   8005bd <_panic>

00801f7e <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  801f7e:	55                   	push   %ebp
  801f7f:	89 e5                	mov    %esp,%ebp
  801f81:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  801f84:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801f8b:	76 16                	jbe    801fa3 <alloc_block+0x25>
  801f8d:	68 68 2d 80 00       	push   $0x802d68
  801f92:	68 de 2c 80 00       	push   $0x802cde
  801f97:	6a 46                	push   $0x46
  801f99:	68 f3 2c 80 00       	push   $0x802cf3
  801f9e:	e8 1a e6 ff ff       	call   8005bd <_panic>
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	panic("alloc_block() Not implemented yet");
  801fa3:	83 ec 04             	sub    $0x4,%esp
  801fa6:	68 8c 2d 80 00       	push   $0x802d8c
  801fab:	6a 4d                	push   $0x4d
  801fad:	68 f3 2c 80 00       	push   $0x802cf3
  801fb2:	e8 06 e6 ff ff       	call   8005bd <_panic>

00801fb7 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  801fb7:	55                   	push   %ebp
  801fb8:	89 e5                	mov    %esp,%ebp
  801fba:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  801fbd:	8b 55 08             	mov    0x8(%ebp),%edx
  801fc0:	a1 64 b0 81 00       	mov    0x81b064,%eax
  801fc5:	39 c2                	cmp    %eax,%edx
  801fc7:	72 0c                	jb     801fd5 <free_block+0x1e>
  801fc9:	8b 55 08             	mov    0x8(%ebp),%edx
  801fcc:	a1 40 30 80 00       	mov    0x803040,%eax
  801fd1:	39 c2                	cmp    %eax,%edx
  801fd3:	72 16                	jb     801feb <free_block+0x34>
  801fd5:	68 b0 2d 80 00       	push   $0x802db0
  801fda:	68 de 2c 80 00       	push   $0x802cde
  801fdf:	6a 5b                	push   $0x5b
  801fe1:	68 f3 2c 80 00       	push   $0x802cf3
  801fe6:	e8 d2 e5 ff ff       	call   8005bd <_panic>
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	panic("free_block() Not implemented yet");
  801feb:	83 ec 04             	sub    $0x4,%esp
  801fee:	68 e8 2d 80 00       	push   $0x802de8
  801ff3:	6a 63                	push   $0x63
  801ff5:	68 f3 2c 80 00       	push   $0x802cf3
  801ffa:	e8 be e5 ff ff       	call   8005bd <_panic>

00801fff <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  801fff:	55                   	push   %ebp
  802000:	89 e5                	mov    %esp,%ebp
  802002:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  802005:	83 ec 04             	sub    $0x4,%esp
  802008:	68 0c 2e 80 00       	push   $0x802e0c
  80200d:	6a 72                	push   $0x72
  80200f:	68 f3 2c 80 00       	push   $0x802cf3
  802014:	e8 a4 e5 ff ff       	call   8005bd <_panic>
  802019:	66 90                	xchg   %ax,%ax
  80201b:	90                   	nop

0080201c <__udivdi3>:
  80201c:	55                   	push   %ebp
  80201d:	57                   	push   %edi
  80201e:	56                   	push   %esi
  80201f:	53                   	push   %ebx
  802020:	83 ec 1c             	sub    $0x1c,%esp
  802023:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802027:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80202b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80202f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802033:	89 ca                	mov    %ecx,%edx
  802035:	89 f8                	mov    %edi,%eax
  802037:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80203b:	85 f6                	test   %esi,%esi
  80203d:	75 2d                	jne    80206c <__udivdi3+0x50>
  80203f:	39 cf                	cmp    %ecx,%edi
  802041:	77 65                	ja     8020a8 <__udivdi3+0x8c>
  802043:	89 fd                	mov    %edi,%ebp
  802045:	85 ff                	test   %edi,%edi
  802047:	75 0b                	jne    802054 <__udivdi3+0x38>
  802049:	b8 01 00 00 00       	mov    $0x1,%eax
  80204e:	31 d2                	xor    %edx,%edx
  802050:	f7 f7                	div    %edi
  802052:	89 c5                	mov    %eax,%ebp
  802054:	31 d2                	xor    %edx,%edx
  802056:	89 c8                	mov    %ecx,%eax
  802058:	f7 f5                	div    %ebp
  80205a:	89 c1                	mov    %eax,%ecx
  80205c:	89 d8                	mov    %ebx,%eax
  80205e:	f7 f5                	div    %ebp
  802060:	89 cf                	mov    %ecx,%edi
  802062:	89 fa                	mov    %edi,%edx
  802064:	83 c4 1c             	add    $0x1c,%esp
  802067:	5b                   	pop    %ebx
  802068:	5e                   	pop    %esi
  802069:	5f                   	pop    %edi
  80206a:	5d                   	pop    %ebp
  80206b:	c3                   	ret    
  80206c:	39 ce                	cmp    %ecx,%esi
  80206e:	77 28                	ja     802098 <__udivdi3+0x7c>
  802070:	0f bd fe             	bsr    %esi,%edi
  802073:	83 f7 1f             	xor    $0x1f,%edi
  802076:	75 40                	jne    8020b8 <__udivdi3+0x9c>
  802078:	39 ce                	cmp    %ecx,%esi
  80207a:	72 0a                	jb     802086 <__udivdi3+0x6a>
  80207c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802080:	0f 87 9e 00 00 00    	ja     802124 <__udivdi3+0x108>
  802086:	b8 01 00 00 00       	mov    $0x1,%eax
  80208b:	89 fa                	mov    %edi,%edx
  80208d:	83 c4 1c             	add    $0x1c,%esp
  802090:	5b                   	pop    %ebx
  802091:	5e                   	pop    %esi
  802092:	5f                   	pop    %edi
  802093:	5d                   	pop    %ebp
  802094:	c3                   	ret    
  802095:	8d 76 00             	lea    0x0(%esi),%esi
  802098:	31 ff                	xor    %edi,%edi
  80209a:	31 c0                	xor    %eax,%eax
  80209c:	89 fa                	mov    %edi,%edx
  80209e:	83 c4 1c             	add    $0x1c,%esp
  8020a1:	5b                   	pop    %ebx
  8020a2:	5e                   	pop    %esi
  8020a3:	5f                   	pop    %edi
  8020a4:	5d                   	pop    %ebp
  8020a5:	c3                   	ret    
  8020a6:	66 90                	xchg   %ax,%ax
  8020a8:	89 d8                	mov    %ebx,%eax
  8020aa:	f7 f7                	div    %edi
  8020ac:	31 ff                	xor    %edi,%edi
  8020ae:	89 fa                	mov    %edi,%edx
  8020b0:	83 c4 1c             	add    $0x1c,%esp
  8020b3:	5b                   	pop    %ebx
  8020b4:	5e                   	pop    %esi
  8020b5:	5f                   	pop    %edi
  8020b6:	5d                   	pop    %ebp
  8020b7:	c3                   	ret    
  8020b8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8020bd:	89 eb                	mov    %ebp,%ebx
  8020bf:	29 fb                	sub    %edi,%ebx
  8020c1:	89 f9                	mov    %edi,%ecx
  8020c3:	d3 e6                	shl    %cl,%esi
  8020c5:	89 c5                	mov    %eax,%ebp
  8020c7:	88 d9                	mov    %bl,%cl
  8020c9:	d3 ed                	shr    %cl,%ebp
  8020cb:	89 e9                	mov    %ebp,%ecx
  8020cd:	09 f1                	or     %esi,%ecx
  8020cf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8020d3:	89 f9                	mov    %edi,%ecx
  8020d5:	d3 e0                	shl    %cl,%eax
  8020d7:	89 c5                	mov    %eax,%ebp
  8020d9:	89 d6                	mov    %edx,%esi
  8020db:	88 d9                	mov    %bl,%cl
  8020dd:	d3 ee                	shr    %cl,%esi
  8020df:	89 f9                	mov    %edi,%ecx
  8020e1:	d3 e2                	shl    %cl,%edx
  8020e3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8020e7:	88 d9                	mov    %bl,%cl
  8020e9:	d3 e8                	shr    %cl,%eax
  8020eb:	09 c2                	or     %eax,%edx
  8020ed:	89 d0                	mov    %edx,%eax
  8020ef:	89 f2                	mov    %esi,%edx
  8020f1:	f7 74 24 0c          	divl   0xc(%esp)
  8020f5:	89 d6                	mov    %edx,%esi
  8020f7:	89 c3                	mov    %eax,%ebx
  8020f9:	f7 e5                	mul    %ebp
  8020fb:	39 d6                	cmp    %edx,%esi
  8020fd:	72 19                	jb     802118 <__udivdi3+0xfc>
  8020ff:	74 0b                	je     80210c <__udivdi3+0xf0>
  802101:	89 d8                	mov    %ebx,%eax
  802103:	31 ff                	xor    %edi,%edi
  802105:	e9 58 ff ff ff       	jmp    802062 <__udivdi3+0x46>
  80210a:	66 90                	xchg   %ax,%ax
  80210c:	8b 54 24 08          	mov    0x8(%esp),%edx
  802110:	89 f9                	mov    %edi,%ecx
  802112:	d3 e2                	shl    %cl,%edx
  802114:	39 c2                	cmp    %eax,%edx
  802116:	73 e9                	jae    802101 <__udivdi3+0xe5>
  802118:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80211b:	31 ff                	xor    %edi,%edi
  80211d:	e9 40 ff ff ff       	jmp    802062 <__udivdi3+0x46>
  802122:	66 90                	xchg   %ax,%ax
  802124:	31 c0                	xor    %eax,%eax
  802126:	e9 37 ff ff ff       	jmp    802062 <__udivdi3+0x46>
  80212b:	90                   	nop

0080212c <__umoddi3>:
  80212c:	55                   	push   %ebp
  80212d:	57                   	push   %edi
  80212e:	56                   	push   %esi
  80212f:	53                   	push   %ebx
  802130:	83 ec 1c             	sub    $0x1c,%esp
  802133:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802137:	8b 74 24 34          	mov    0x34(%esp),%esi
  80213b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80213f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802143:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802147:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80214b:	89 f3                	mov    %esi,%ebx
  80214d:	89 fa                	mov    %edi,%edx
  80214f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802153:	89 34 24             	mov    %esi,(%esp)
  802156:	85 c0                	test   %eax,%eax
  802158:	75 1a                	jne    802174 <__umoddi3+0x48>
  80215a:	39 f7                	cmp    %esi,%edi
  80215c:	0f 86 a2 00 00 00    	jbe    802204 <__umoddi3+0xd8>
  802162:	89 c8                	mov    %ecx,%eax
  802164:	89 f2                	mov    %esi,%edx
  802166:	f7 f7                	div    %edi
  802168:	89 d0                	mov    %edx,%eax
  80216a:	31 d2                	xor    %edx,%edx
  80216c:	83 c4 1c             	add    $0x1c,%esp
  80216f:	5b                   	pop    %ebx
  802170:	5e                   	pop    %esi
  802171:	5f                   	pop    %edi
  802172:	5d                   	pop    %ebp
  802173:	c3                   	ret    
  802174:	39 f0                	cmp    %esi,%eax
  802176:	0f 87 ac 00 00 00    	ja     802228 <__umoddi3+0xfc>
  80217c:	0f bd e8             	bsr    %eax,%ebp
  80217f:	83 f5 1f             	xor    $0x1f,%ebp
  802182:	0f 84 ac 00 00 00    	je     802234 <__umoddi3+0x108>
  802188:	bf 20 00 00 00       	mov    $0x20,%edi
  80218d:	29 ef                	sub    %ebp,%edi
  80218f:	89 fe                	mov    %edi,%esi
  802191:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802195:	89 e9                	mov    %ebp,%ecx
  802197:	d3 e0                	shl    %cl,%eax
  802199:	89 d7                	mov    %edx,%edi
  80219b:	89 f1                	mov    %esi,%ecx
  80219d:	d3 ef                	shr    %cl,%edi
  80219f:	09 c7                	or     %eax,%edi
  8021a1:	89 e9                	mov    %ebp,%ecx
  8021a3:	d3 e2                	shl    %cl,%edx
  8021a5:	89 14 24             	mov    %edx,(%esp)
  8021a8:	89 d8                	mov    %ebx,%eax
  8021aa:	d3 e0                	shl    %cl,%eax
  8021ac:	89 c2                	mov    %eax,%edx
  8021ae:	8b 44 24 08          	mov    0x8(%esp),%eax
  8021b2:	d3 e0                	shl    %cl,%eax
  8021b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021b8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8021bc:	89 f1                	mov    %esi,%ecx
  8021be:	d3 e8                	shr    %cl,%eax
  8021c0:	09 d0                	or     %edx,%eax
  8021c2:	d3 eb                	shr    %cl,%ebx
  8021c4:	89 da                	mov    %ebx,%edx
  8021c6:	f7 f7                	div    %edi
  8021c8:	89 d3                	mov    %edx,%ebx
  8021ca:	f7 24 24             	mull   (%esp)
  8021cd:	89 c6                	mov    %eax,%esi
  8021cf:	89 d1                	mov    %edx,%ecx
  8021d1:	39 d3                	cmp    %edx,%ebx
  8021d3:	0f 82 87 00 00 00    	jb     802260 <__umoddi3+0x134>
  8021d9:	0f 84 91 00 00 00    	je     802270 <__umoddi3+0x144>
  8021df:	8b 54 24 04          	mov    0x4(%esp),%edx
  8021e3:	29 f2                	sub    %esi,%edx
  8021e5:	19 cb                	sbb    %ecx,%ebx
  8021e7:	89 d8                	mov    %ebx,%eax
  8021e9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8021ed:	d3 e0                	shl    %cl,%eax
  8021ef:	89 e9                	mov    %ebp,%ecx
  8021f1:	d3 ea                	shr    %cl,%edx
  8021f3:	09 d0                	or     %edx,%eax
  8021f5:	89 e9                	mov    %ebp,%ecx
  8021f7:	d3 eb                	shr    %cl,%ebx
  8021f9:	89 da                	mov    %ebx,%edx
  8021fb:	83 c4 1c             	add    $0x1c,%esp
  8021fe:	5b                   	pop    %ebx
  8021ff:	5e                   	pop    %esi
  802200:	5f                   	pop    %edi
  802201:	5d                   	pop    %ebp
  802202:	c3                   	ret    
  802203:	90                   	nop
  802204:	89 fd                	mov    %edi,%ebp
  802206:	85 ff                	test   %edi,%edi
  802208:	75 0b                	jne    802215 <__umoddi3+0xe9>
  80220a:	b8 01 00 00 00       	mov    $0x1,%eax
  80220f:	31 d2                	xor    %edx,%edx
  802211:	f7 f7                	div    %edi
  802213:	89 c5                	mov    %eax,%ebp
  802215:	89 f0                	mov    %esi,%eax
  802217:	31 d2                	xor    %edx,%edx
  802219:	f7 f5                	div    %ebp
  80221b:	89 c8                	mov    %ecx,%eax
  80221d:	f7 f5                	div    %ebp
  80221f:	89 d0                	mov    %edx,%eax
  802221:	e9 44 ff ff ff       	jmp    80216a <__umoddi3+0x3e>
  802226:	66 90                	xchg   %ax,%ax
  802228:	89 c8                	mov    %ecx,%eax
  80222a:	89 f2                	mov    %esi,%edx
  80222c:	83 c4 1c             	add    $0x1c,%esp
  80222f:	5b                   	pop    %ebx
  802230:	5e                   	pop    %esi
  802231:	5f                   	pop    %edi
  802232:	5d                   	pop    %ebp
  802233:	c3                   	ret    
  802234:	3b 04 24             	cmp    (%esp),%eax
  802237:	72 06                	jb     80223f <__umoddi3+0x113>
  802239:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80223d:	77 0f                	ja     80224e <__umoddi3+0x122>
  80223f:	89 f2                	mov    %esi,%edx
  802241:	29 f9                	sub    %edi,%ecx
  802243:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802247:	89 14 24             	mov    %edx,(%esp)
  80224a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80224e:	8b 44 24 04          	mov    0x4(%esp),%eax
  802252:	8b 14 24             	mov    (%esp),%edx
  802255:	83 c4 1c             	add    $0x1c,%esp
  802258:	5b                   	pop    %ebx
  802259:	5e                   	pop    %esi
  80225a:	5f                   	pop    %edi
  80225b:	5d                   	pop    %ebp
  80225c:	c3                   	ret    
  80225d:	8d 76 00             	lea    0x0(%esi),%esi
  802260:	2b 04 24             	sub    (%esp),%eax
  802263:	19 fa                	sbb    %edi,%edx
  802265:	89 d1                	mov    %edx,%ecx
  802267:	89 c6                	mov    %eax,%esi
  802269:	e9 71 ff ff ff       	jmp    8021df <__umoddi3+0xb3>
  80226e:	66 90                	xchg   %ax,%ax
  802270:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802274:	72 ea                	jb     802260 <__umoddi3+0x134>
  802276:	89 d9                	mov    %ebx,%ecx
  802278:	e9 62 ff ff ff       	jmp    8021df <__umoddi3+0xb3>

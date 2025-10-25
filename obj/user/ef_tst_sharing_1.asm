
obj/user/ef_tst_sharing_1:     file format elf32-i386


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
  800031:	e8 73 03 00 00       	call   8003a9 <libmain>
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
//#endif
//	/*=================================================*/

	uint32 *x, *y, *z ;
	uint32 expected ;
	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  80003f:	c7 45 f0 00 10 00 82 	movl   $0x82001000,-0x10(%ebp)

	cprintf("STEP A: checking the creation of shared variables...\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 20 22 80 00       	push   $0x802220
  80004e:	e8 d4 07 00 00       	call   800827 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
	{
		int freeFrames = sys_calculate_free_frames() ;
  800056:	e8 87 19 00 00       	call   8019e2 <sys_calculate_free_frames>
  80005b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  80005e:	83 ec 04             	sub    $0x4,%esp
  800061:	6a 01                	push   $0x1
  800063:	68 00 10 00 00       	push   $0x1000
  800068:	68 56 22 80 00       	push   $0x802256
  80006d:	e8 bf 17 00 00       	call   801831 <smalloc>
  800072:	83 c4 10             	add    $0x10,%esp
  800075:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (x != (uint32*)pagealloc_start) {panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  800078:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80007b:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  80007e:	74 14                	je     800094 <_main+0x5c>
  800080:	83 ec 04             	sub    $0x4,%esp
  800083:	68 58 22 80 00       	push   $0x802258
  800088:	6a 1a                	push   $0x1a
  80008a:	68 c4 22 80 00       	push   $0x8022c4
  80008f:	e8 c5 04 00 00       	call   800559 <_panic>
		expected = 1+1 ; /*1page +1table*/
  800094:	c7 45 e4 02 00 00 00 	movl   $0x2,-0x1c(%ebp)
		int diff = (freeFrames - sys_calculate_free_frames());
  80009b:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  80009e:	e8 3f 19 00 00       	call   8019e2 <sys_calculate_free_frames>
  8000a3:	29 c3                	sub    %eax,%ebx
  8000a5:	89 d8                	mov    %ebx,%eax
  8000a7:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/) {panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  8000aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8000ad:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8000b0:	72 0d                	jb     8000bf <_main+0x87>
  8000b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000b5:	8d 50 02             	lea    0x2(%eax),%edx
  8000b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8000bb:	39 c2                	cmp    %eax,%edx
  8000bd:	73 24                	jae    8000e3 <_main+0xab>
  8000bf:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000c2:	e8 1b 19 00 00       	call   8019e2 <sys_calculate_free_frames>
  8000c7:	29 c3                	sub    %eax,%ebx
  8000c9:	89 d8                	mov    %ebx,%eax
  8000cb:	83 ec 0c             	sub    $0xc,%esp
  8000ce:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000d1:	50                   	push   %eax
  8000d2:	68 dc 22 80 00       	push   $0x8022dc
  8000d7:	6a 1d                	push   $0x1d
  8000d9:	68 c4 22 80 00       	push   $0x8022c4
  8000de:	e8 76 04 00 00       	call   800559 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8000e3:	e8 fa 18 00 00       	call   8019e2 <sys_calculate_free_frames>
  8000e8:	89 45 ec             	mov    %eax,-0x14(%ebp)
		z = smalloc("z", PAGE_SIZE + 4, 1);
  8000eb:	83 ec 04             	sub    $0x4,%esp
  8000ee:	6a 01                	push   $0x1
  8000f0:	68 04 10 00 00       	push   $0x1004
  8000f5:	68 74 23 80 00       	push   $0x802374
  8000fa:	e8 32 17 00 00       	call   801831 <smalloc>
  8000ff:	83 c4 10             	add    $0x10,%esp
  800102:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (z != (uint32*)(pagealloc_start + 1 * PAGE_SIZE)) {panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  800105:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800108:	05 00 10 00 00       	add    $0x1000,%eax
  80010d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800110:	74 14                	je     800126 <_main+0xee>
  800112:	83 ec 04             	sub    $0x4,%esp
  800115:	68 58 22 80 00       	push   $0x802258
  80011a:	6a 21                	push   $0x21
  80011c:	68 c4 22 80 00       	push   $0x8022c4
  800121:	e8 33 04 00 00       	call   800559 <_panic>
		expected = 2 ; /*2pages*/
  800126:	c7 45 e4 02 00 00 00 	movl   $0x2,-0x1c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80012d:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800130:	e8 ad 18 00 00       	call   8019e2 <sys_calculate_free_frames>
  800135:	29 c3                	sub    %eax,%ebx
  800137:	89 d8                	mov    %ebx,%eax
  800139:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/) {panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  80013c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80013f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800142:	72 0d                	jb     800151 <_main+0x119>
  800144:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800147:	8d 50 02             	lea    0x2(%eax),%edx
  80014a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80014d:	39 c2                	cmp    %eax,%edx
  80014f:	73 24                	jae    800175 <_main+0x13d>
  800151:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800154:	e8 89 18 00 00       	call   8019e2 <sys_calculate_free_frames>
  800159:	29 c3                	sub    %eax,%ebx
  80015b:	89 d8                	mov    %ebx,%eax
  80015d:	83 ec 0c             	sub    $0xc,%esp
  800160:	ff 75 e4             	pushl  -0x1c(%ebp)
  800163:	50                   	push   %eax
  800164:	68 dc 22 80 00       	push   $0x8022dc
  800169:	6a 24                	push   $0x24
  80016b:	68 c4 22 80 00       	push   $0x8022c4
  800170:	e8 e4 03 00 00       	call   800559 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800175:	e8 68 18 00 00       	call   8019e2 <sys_calculate_free_frames>
  80017a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		y = smalloc("y", 4, 1);
  80017d:	83 ec 04             	sub    $0x4,%esp
  800180:	6a 01                	push   $0x1
  800182:	6a 04                	push   $0x4
  800184:	68 76 23 80 00       	push   $0x802376
  800189:	e8 a3 16 00 00       	call   801831 <smalloc>
  80018e:	83 c4 10             	add    $0x10,%esp
  800191:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (y != (uint32*)(pagealloc_start + 3 * PAGE_SIZE)) {panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  800194:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800197:	05 00 30 00 00       	add    $0x3000,%eax
  80019c:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80019f:	74 14                	je     8001b5 <_main+0x17d>
  8001a1:	83 ec 04             	sub    $0x4,%esp
  8001a4:	68 58 22 80 00       	push   $0x802258
  8001a9:	6a 28                	push   $0x28
  8001ab:	68 c4 22 80 00       	push   $0x8022c4
  8001b0:	e8 a4 03 00 00       	call   800559 <_panic>
		expected = 1 ; /*1page*/
  8001b5:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8001bc:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8001bf:	e8 1e 18 00 00       	call   8019e2 <sys_calculate_free_frames>
  8001c4:	29 c3                	sub    %eax,%ebx
  8001c6:	89 d8                	mov    %ebx,%eax
  8001c8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/) {panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  8001cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001ce:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8001d1:	72 0d                	jb     8001e0 <_main+0x1a8>
  8001d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001d6:	8d 50 02             	lea    0x2(%eax),%edx
  8001d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001dc:	39 c2                	cmp    %eax,%edx
  8001de:	73 24                	jae    800204 <_main+0x1cc>
  8001e0:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8001e3:	e8 fa 17 00 00       	call   8019e2 <sys_calculate_free_frames>
  8001e8:	29 c3                	sub    %eax,%ebx
  8001ea:	89 d8                	mov    %ebx,%eax
  8001ec:	83 ec 0c             	sub    $0xc,%esp
  8001ef:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001f2:	50                   	push   %eax
  8001f3:	68 dc 22 80 00       	push   $0x8022dc
  8001f8:	6a 2b                	push   $0x2b
  8001fa:	68 c4 22 80 00       	push   $0x8022c4
  8001ff:	e8 55 03 00 00       	call   800559 <_panic>
	}
	cprintf("Step A is finished!!\n\n\n");
  800204:	83 ec 0c             	sub    $0xc,%esp
  800207:	68 78 23 80 00       	push   $0x802378
  80020c:	e8 16 06 00 00       	call   800827 <cprintf>
  800211:	83 c4 10             	add    $0x10,%esp


	cprintf("STEP B: checking reading & writing... \n");
  800214:	83 ec 0c             	sub    $0xc,%esp
  800217:	68 90 23 80 00       	push   $0x802390
  80021c:	e8 06 06 00 00       	call   800827 <cprintf>
  800221:	83 c4 10             	add    $0x10,%esp
	{
		int i=0;
  800224:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		for(;i<PAGE_SIZE/4;i++)
  80022b:	eb 2d                	jmp    80025a <_main+0x222>
		{
			x[i] = -1;
  80022d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800230:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800237:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80023a:	01 d0                	add    %edx,%eax
  80023c:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			y[i] = -1;
  800242:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800245:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80024c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80024f:	01 d0                	add    %edx,%eax
  800251:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)


	cprintf("STEP B: checking reading & writing... \n");
	{
		int i=0;
		for(;i<PAGE_SIZE/4;i++)
  800257:	ff 45 f4             	incl   -0xc(%ebp)
  80025a:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
  800261:	7e ca                	jle    80022d <_main+0x1f5>
		{
			x[i] = -1;
			y[i] = -1;
		}

		i=0;
  800263:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		for(;i<2*PAGE_SIZE/4;i++)
  80026a:	eb 18                	jmp    800284 <_main+0x24c>
		{
			z[i] = -1;
  80026c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80026f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800276:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800279:	01 d0                	add    %edx,%eax
  80027b:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			x[i] = -1;
			y[i] = -1;
		}

		i=0;
		for(;i<2*PAGE_SIZE/4;i++)
  800281:	ff 45 f4             	incl   -0xc(%ebp)
  800284:	81 7d f4 ff 07 00 00 	cmpl   $0x7ff,-0xc(%ebp)
  80028b:	7e df                	jle    80026c <_main+0x234>
		{
			z[i] = -1;
		}

		if( x[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  80028d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800290:	8b 00                	mov    (%eax),%eax
  800292:	83 f8 ff             	cmp    $0xffffffff,%eax
  800295:	74 14                	je     8002ab <_main+0x273>
  800297:	83 ec 04             	sub    $0x4,%esp
  80029a:	68 b8 23 80 00       	push   $0x8023b8
  80029f:	6a 3f                	push   $0x3f
  8002a1:	68 c4 22 80 00       	push   $0x8022c4
  8002a6:	e8 ae 02 00 00       	call   800559 <_panic>
		if( x[PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  8002ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002ae:	05 fc 0f 00 00       	add    $0xffc,%eax
  8002b3:	8b 00                	mov    (%eax),%eax
  8002b5:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002b8:	74 14                	je     8002ce <_main+0x296>
  8002ba:	83 ec 04             	sub    $0x4,%esp
  8002bd:	68 b8 23 80 00       	push   $0x8023b8
  8002c2:	6a 40                	push   $0x40
  8002c4:	68 c4 22 80 00       	push   $0x8022c4
  8002c9:	e8 8b 02 00 00       	call   800559 <_panic>

		if( y[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  8002ce:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002d1:	8b 00                	mov    (%eax),%eax
  8002d3:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002d6:	74 14                	je     8002ec <_main+0x2b4>
  8002d8:	83 ec 04             	sub    $0x4,%esp
  8002db:	68 b8 23 80 00       	push   $0x8023b8
  8002e0:	6a 42                	push   $0x42
  8002e2:	68 c4 22 80 00       	push   $0x8022c4
  8002e7:	e8 6d 02 00 00       	call   800559 <_panic>
		if( y[PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  8002ec:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002ef:	05 fc 0f 00 00       	add    $0xffc,%eax
  8002f4:	8b 00                	mov    (%eax),%eax
  8002f6:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002f9:	74 14                	je     80030f <_main+0x2d7>
  8002fb:	83 ec 04             	sub    $0x4,%esp
  8002fe:	68 b8 23 80 00       	push   $0x8023b8
  800303:	6a 43                	push   $0x43
  800305:	68 c4 22 80 00       	push   $0x8022c4
  80030a:	e8 4a 02 00 00       	call   800559 <_panic>

		if( z[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  80030f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800312:	8b 00                	mov    (%eax),%eax
  800314:	83 f8 ff             	cmp    $0xffffffff,%eax
  800317:	74 14                	je     80032d <_main+0x2f5>
  800319:	83 ec 04             	sub    $0x4,%esp
  80031c:	68 b8 23 80 00       	push   $0x8023b8
  800321:	6a 45                	push   $0x45
  800323:	68 c4 22 80 00       	push   $0x8022c4
  800328:	e8 2c 02 00 00       	call   800559 <_panic>
		if( z[2*PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  80032d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800330:	05 fc 1f 00 00       	add    $0x1ffc,%eax
  800335:	8b 00                	mov    (%eax),%eax
  800337:	83 f8 ff             	cmp    $0xffffffff,%eax
  80033a:	74 14                	je     800350 <_main+0x318>
  80033c:	83 ec 04             	sub    $0x4,%esp
  80033f:	68 b8 23 80 00       	push   $0x8023b8
  800344:	6a 46                	push   $0x46
  800346:	68 c4 22 80 00       	push   $0x8022c4
  80034b:	e8 09 02 00 00       	call   800559 <_panic>
	}

	cprintf("test sharing 1 [Create] is finished!!\n\n\n");
  800350:	83 ec 0c             	sub    $0xc,%esp
  800353:	68 e4 23 80 00       	push   $0x8023e4
  800358:	e8 ca 04 00 00       	call   800827 <cprintf>
  80035d:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  800360:	e8 5f 18 00 00       	call   801bc4 <sys_getparentenvid>
  800365:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if(parentenvID > 0)
  800368:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80036c:	7e 35                	jle    8003a3 <_main+0x36b>
	{
		//Get the check-finishing counter
		int *finishedCount = NULL;
  80036e:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		finishedCount = sget(parentenvID, "finishedCount") ;
  800375:	83 ec 08             	sub    $0x8,%esp
  800378:	68 0d 24 80 00       	push   $0x80240d
  80037d:	ff 75 d4             	pushl  -0x2c(%ebp)
  800380:	e8 e0 14 00 00       	call   801865 <sget>
  800385:	83 c4 10             	add    $0x10,%esp
  800388:	89 45 d0             	mov    %eax,-0x30(%ebp)
		sys_lock_cons();
  80038b:	e8 a2 15 00 00       	call   801932 <sys_lock_cons>
		{
			(*finishedCount)++ ;
  800390:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800393:	8b 00                	mov    (%eax),%eax
  800395:	8d 50 01             	lea    0x1(%eax),%edx
  800398:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80039b:	89 10                	mov    %edx,(%eax)
		}
		sys_unlock_cons();
  80039d:	e8 aa 15 00 00       	call   80194c <sys_unlock_cons>
	}

	return;
  8003a2:	90                   	nop
  8003a3:	90                   	nop
}
  8003a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003a7:	c9                   	leave  
  8003a8:	c3                   	ret    

008003a9 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8003a9:	55                   	push   %ebp
  8003aa:	89 e5                	mov    %esp,%ebp
  8003ac:	57                   	push   %edi
  8003ad:	56                   	push   %esi
  8003ae:	53                   	push   %ebx
  8003af:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8003b2:	e8 f4 17 00 00       	call   801bab <sys_getenvindex>
  8003b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8003ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8003bd:	89 d0                	mov    %edx,%eax
  8003bf:	c1 e0 02             	shl    $0x2,%eax
  8003c2:	01 d0                	add    %edx,%eax
  8003c4:	c1 e0 03             	shl    $0x3,%eax
  8003c7:	01 d0                	add    %edx,%eax
  8003c9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8003d0:	01 d0                	add    %edx,%eax
  8003d2:	c1 e0 02             	shl    $0x2,%eax
  8003d5:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8003da:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8003df:	a1 20 30 80 00       	mov    0x803020,%eax
  8003e4:	8a 40 20             	mov    0x20(%eax),%al
  8003e7:	84 c0                	test   %al,%al
  8003e9:	74 0d                	je     8003f8 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8003eb:	a1 20 30 80 00       	mov    0x803020,%eax
  8003f0:	83 c0 20             	add    $0x20,%eax
  8003f3:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003f8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8003fc:	7e 0a                	jle    800408 <libmain+0x5f>
		binaryname = argv[0];
  8003fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800401:	8b 00                	mov    (%eax),%eax
  800403:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  800408:	83 ec 08             	sub    $0x8,%esp
  80040b:	ff 75 0c             	pushl  0xc(%ebp)
  80040e:	ff 75 08             	pushl  0x8(%ebp)
  800411:	e8 22 fc ff ff       	call   800038 <_main>
  800416:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800419:	a1 00 30 80 00       	mov    0x803000,%eax
  80041e:	85 c0                	test   %eax,%eax
  800420:	0f 84 01 01 00 00    	je     800527 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800426:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80042c:	bb 14 25 80 00       	mov    $0x802514,%ebx
  800431:	ba 0e 00 00 00       	mov    $0xe,%edx
  800436:	89 c7                	mov    %eax,%edi
  800438:	89 de                	mov    %ebx,%esi
  80043a:	89 d1                	mov    %edx,%ecx
  80043c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80043e:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800441:	b9 56 00 00 00       	mov    $0x56,%ecx
  800446:	b0 00                	mov    $0x0,%al
  800448:	89 d7                	mov    %edx,%edi
  80044a:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80044c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800453:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800456:	83 ec 08             	sub    $0x8,%esp
  800459:	50                   	push   %eax
  80045a:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800460:	50                   	push   %eax
  800461:	e8 7b 19 00 00       	call   801de1 <sys_utilities>
  800466:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800469:	e8 c4 14 00 00       	call   801932 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80046e:	83 ec 0c             	sub    $0xc,%esp
  800471:	68 34 24 80 00       	push   $0x802434
  800476:	e8 ac 03 00 00       	call   800827 <cprintf>
  80047b:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80047e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800481:	85 c0                	test   %eax,%eax
  800483:	74 18                	je     80049d <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800485:	e8 75 19 00 00       	call   801dff <sys_get_optimal_num_faults>
  80048a:	83 ec 08             	sub    $0x8,%esp
  80048d:	50                   	push   %eax
  80048e:	68 5c 24 80 00       	push   $0x80245c
  800493:	e8 8f 03 00 00       	call   800827 <cprintf>
  800498:	83 c4 10             	add    $0x10,%esp
  80049b:	eb 59                	jmp    8004f6 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80049d:	a1 20 30 80 00       	mov    0x803020,%eax
  8004a2:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8004a8:	a1 20 30 80 00       	mov    0x803020,%eax
  8004ad:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  8004b3:	83 ec 04             	sub    $0x4,%esp
  8004b6:	52                   	push   %edx
  8004b7:	50                   	push   %eax
  8004b8:	68 80 24 80 00       	push   $0x802480
  8004bd:	e8 65 03 00 00       	call   800827 <cprintf>
  8004c2:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8004c5:	a1 20 30 80 00       	mov    0x803020,%eax
  8004ca:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8004d0:	a1 20 30 80 00       	mov    0x803020,%eax
  8004d5:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  8004db:	a1 20 30 80 00       	mov    0x803020,%eax
  8004e0:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  8004e6:	51                   	push   %ecx
  8004e7:	52                   	push   %edx
  8004e8:	50                   	push   %eax
  8004e9:	68 a8 24 80 00       	push   $0x8024a8
  8004ee:	e8 34 03 00 00       	call   800827 <cprintf>
  8004f3:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8004f6:	a1 20 30 80 00       	mov    0x803020,%eax
  8004fb:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  800501:	83 ec 08             	sub    $0x8,%esp
  800504:	50                   	push   %eax
  800505:	68 00 25 80 00       	push   $0x802500
  80050a:	e8 18 03 00 00       	call   800827 <cprintf>
  80050f:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800512:	83 ec 0c             	sub    $0xc,%esp
  800515:	68 34 24 80 00       	push   $0x802434
  80051a:	e8 08 03 00 00       	call   800827 <cprintf>
  80051f:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800522:	e8 25 14 00 00       	call   80194c <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800527:	e8 1f 00 00 00       	call   80054b <exit>
}
  80052c:	90                   	nop
  80052d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800530:	5b                   	pop    %ebx
  800531:	5e                   	pop    %esi
  800532:	5f                   	pop    %edi
  800533:	5d                   	pop    %ebp
  800534:	c3                   	ret    

00800535 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800535:	55                   	push   %ebp
  800536:	89 e5                	mov    %esp,%ebp
  800538:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80053b:	83 ec 0c             	sub    $0xc,%esp
  80053e:	6a 00                	push   $0x0
  800540:	e8 32 16 00 00       	call   801b77 <sys_destroy_env>
  800545:	83 c4 10             	add    $0x10,%esp
}
  800548:	90                   	nop
  800549:	c9                   	leave  
  80054a:	c3                   	ret    

0080054b <exit>:

void
exit(void)
{
  80054b:	55                   	push   %ebp
  80054c:	89 e5                	mov    %esp,%ebp
  80054e:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800551:	e8 87 16 00 00       	call   801bdd <sys_exit_env>
}
  800556:	90                   	nop
  800557:	c9                   	leave  
  800558:	c3                   	ret    

00800559 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800559:	55                   	push   %ebp
  80055a:	89 e5                	mov    %esp,%ebp
  80055c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80055f:	8d 45 10             	lea    0x10(%ebp),%eax
  800562:	83 c0 04             	add    $0x4,%eax
  800565:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800568:	a1 18 b1 81 00       	mov    0x81b118,%eax
  80056d:	85 c0                	test   %eax,%eax
  80056f:	74 16                	je     800587 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800571:	a1 18 b1 81 00       	mov    0x81b118,%eax
  800576:	83 ec 08             	sub    $0x8,%esp
  800579:	50                   	push   %eax
  80057a:	68 78 25 80 00       	push   $0x802578
  80057f:	e8 a3 02 00 00       	call   800827 <cprintf>
  800584:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800587:	a1 04 30 80 00       	mov    0x803004,%eax
  80058c:	83 ec 0c             	sub    $0xc,%esp
  80058f:	ff 75 0c             	pushl  0xc(%ebp)
  800592:	ff 75 08             	pushl  0x8(%ebp)
  800595:	50                   	push   %eax
  800596:	68 80 25 80 00       	push   $0x802580
  80059b:	6a 74                	push   $0x74
  80059d:	e8 b2 02 00 00       	call   800854 <cprintf_colored>
  8005a2:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8005a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8005a8:	83 ec 08             	sub    $0x8,%esp
  8005ab:	ff 75 f4             	pushl  -0xc(%ebp)
  8005ae:	50                   	push   %eax
  8005af:	e8 04 02 00 00       	call   8007b8 <vcprintf>
  8005b4:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8005b7:	83 ec 08             	sub    $0x8,%esp
  8005ba:	6a 00                	push   $0x0
  8005bc:	68 a8 25 80 00       	push   $0x8025a8
  8005c1:	e8 f2 01 00 00       	call   8007b8 <vcprintf>
  8005c6:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8005c9:	e8 7d ff ff ff       	call   80054b <exit>

	// should not return here
	while (1) ;
  8005ce:	eb fe                	jmp    8005ce <_panic+0x75>

008005d0 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8005d0:	55                   	push   %ebp
  8005d1:	89 e5                	mov    %esp,%ebp
  8005d3:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8005d6:	a1 20 30 80 00       	mov    0x803020,%eax
  8005db:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005e4:	39 c2                	cmp    %eax,%edx
  8005e6:	74 14                	je     8005fc <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8005e8:	83 ec 04             	sub    $0x4,%esp
  8005eb:	68 ac 25 80 00       	push   $0x8025ac
  8005f0:	6a 26                	push   $0x26
  8005f2:	68 f8 25 80 00       	push   $0x8025f8
  8005f7:	e8 5d ff ff ff       	call   800559 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8005fc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800603:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80060a:	e9 c5 00 00 00       	jmp    8006d4 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80060f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800612:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800619:	8b 45 08             	mov    0x8(%ebp),%eax
  80061c:	01 d0                	add    %edx,%eax
  80061e:	8b 00                	mov    (%eax),%eax
  800620:	85 c0                	test   %eax,%eax
  800622:	75 08                	jne    80062c <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800624:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800627:	e9 a5 00 00 00       	jmp    8006d1 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80062c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800633:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80063a:	eb 69                	jmp    8006a5 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80063c:	a1 20 30 80 00       	mov    0x803020,%eax
  800641:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800647:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80064a:	89 d0                	mov    %edx,%eax
  80064c:	01 c0                	add    %eax,%eax
  80064e:	01 d0                	add    %edx,%eax
  800650:	c1 e0 03             	shl    $0x3,%eax
  800653:	01 c8                	add    %ecx,%eax
  800655:	8a 40 04             	mov    0x4(%eax),%al
  800658:	84 c0                	test   %al,%al
  80065a:	75 46                	jne    8006a2 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80065c:	a1 20 30 80 00       	mov    0x803020,%eax
  800661:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800667:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80066a:	89 d0                	mov    %edx,%eax
  80066c:	01 c0                	add    %eax,%eax
  80066e:	01 d0                	add    %edx,%eax
  800670:	c1 e0 03             	shl    $0x3,%eax
  800673:	01 c8                	add    %ecx,%eax
  800675:	8b 00                	mov    (%eax),%eax
  800677:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80067a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80067d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800682:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800684:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800687:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80068e:	8b 45 08             	mov    0x8(%ebp),%eax
  800691:	01 c8                	add    %ecx,%eax
  800693:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800695:	39 c2                	cmp    %eax,%edx
  800697:	75 09                	jne    8006a2 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800699:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8006a0:	eb 15                	jmp    8006b7 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006a2:	ff 45 e8             	incl   -0x18(%ebp)
  8006a5:	a1 20 30 80 00       	mov    0x803020,%eax
  8006aa:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8006b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8006b3:	39 c2                	cmp    %eax,%edx
  8006b5:	77 85                	ja     80063c <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8006b7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8006bb:	75 14                	jne    8006d1 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8006bd:	83 ec 04             	sub    $0x4,%esp
  8006c0:	68 04 26 80 00       	push   $0x802604
  8006c5:	6a 3a                	push   $0x3a
  8006c7:	68 f8 25 80 00       	push   $0x8025f8
  8006cc:	e8 88 fe ff ff       	call   800559 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8006d1:	ff 45 f0             	incl   -0x10(%ebp)
  8006d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006d7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8006da:	0f 8c 2f ff ff ff    	jl     80060f <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8006e0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006e7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8006ee:	eb 26                	jmp    800716 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8006f0:	a1 20 30 80 00       	mov    0x803020,%eax
  8006f5:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8006fb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006fe:	89 d0                	mov    %edx,%eax
  800700:	01 c0                	add    %eax,%eax
  800702:	01 d0                	add    %edx,%eax
  800704:	c1 e0 03             	shl    $0x3,%eax
  800707:	01 c8                	add    %ecx,%eax
  800709:	8a 40 04             	mov    0x4(%eax),%al
  80070c:	3c 01                	cmp    $0x1,%al
  80070e:	75 03                	jne    800713 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800710:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800713:	ff 45 e0             	incl   -0x20(%ebp)
  800716:	a1 20 30 80 00       	mov    0x803020,%eax
  80071b:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800721:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800724:	39 c2                	cmp    %eax,%edx
  800726:	77 c8                	ja     8006f0 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800728:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80072b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80072e:	74 14                	je     800744 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800730:	83 ec 04             	sub    $0x4,%esp
  800733:	68 58 26 80 00       	push   $0x802658
  800738:	6a 44                	push   $0x44
  80073a:	68 f8 25 80 00       	push   $0x8025f8
  80073f:	e8 15 fe ff ff       	call   800559 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800744:	90                   	nop
  800745:	c9                   	leave  
  800746:	c3                   	ret    

00800747 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800747:	55                   	push   %ebp
  800748:	89 e5                	mov    %esp,%ebp
  80074a:	53                   	push   %ebx
  80074b:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  80074e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800751:	8b 00                	mov    (%eax),%eax
  800753:	8d 48 01             	lea    0x1(%eax),%ecx
  800756:	8b 55 0c             	mov    0xc(%ebp),%edx
  800759:	89 0a                	mov    %ecx,(%edx)
  80075b:	8b 55 08             	mov    0x8(%ebp),%edx
  80075e:	88 d1                	mov    %dl,%cl
  800760:	8b 55 0c             	mov    0xc(%ebp),%edx
  800763:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800767:	8b 45 0c             	mov    0xc(%ebp),%eax
  80076a:	8b 00                	mov    (%eax),%eax
  80076c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800771:	75 30                	jne    8007a3 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800773:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  800779:	a0 44 30 80 00       	mov    0x803044,%al
  80077e:	0f b6 c0             	movzbl %al,%eax
  800781:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800784:	8b 09                	mov    (%ecx),%ecx
  800786:	89 cb                	mov    %ecx,%ebx
  800788:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80078b:	83 c1 08             	add    $0x8,%ecx
  80078e:	52                   	push   %edx
  80078f:	50                   	push   %eax
  800790:	53                   	push   %ebx
  800791:	51                   	push   %ecx
  800792:	e8 57 11 00 00       	call   8018ee <sys_cputs>
  800797:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80079a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80079d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8007a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007a6:	8b 40 04             	mov    0x4(%eax),%eax
  8007a9:	8d 50 01             	lea    0x1(%eax),%edx
  8007ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007af:	89 50 04             	mov    %edx,0x4(%eax)
}
  8007b2:	90                   	nop
  8007b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007b6:	c9                   	leave  
  8007b7:	c3                   	ret    

008007b8 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8007b8:	55                   	push   %ebp
  8007b9:	89 e5                	mov    %esp,%ebp
  8007bb:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8007c1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8007c8:	00 00 00 
	b.cnt = 0;
  8007cb:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8007d2:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8007d5:	ff 75 0c             	pushl  0xc(%ebp)
  8007d8:	ff 75 08             	pushl  0x8(%ebp)
  8007db:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007e1:	50                   	push   %eax
  8007e2:	68 47 07 80 00       	push   $0x800747
  8007e7:	e8 5a 02 00 00       	call   800a46 <vprintfmt>
  8007ec:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8007ef:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  8007f5:	a0 44 30 80 00       	mov    0x803044,%al
  8007fa:	0f b6 c0             	movzbl %al,%eax
  8007fd:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800803:	52                   	push   %edx
  800804:	50                   	push   %eax
  800805:	51                   	push   %ecx
  800806:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80080c:	83 c0 08             	add    $0x8,%eax
  80080f:	50                   	push   %eax
  800810:	e8 d9 10 00 00       	call   8018ee <sys_cputs>
  800815:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800818:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  80081f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800825:	c9                   	leave  
  800826:	c3                   	ret    

00800827 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800827:	55                   	push   %ebp
  800828:	89 e5                	mov    %esp,%ebp
  80082a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80082d:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  800834:	8d 45 0c             	lea    0xc(%ebp),%eax
  800837:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80083a:	8b 45 08             	mov    0x8(%ebp),%eax
  80083d:	83 ec 08             	sub    $0x8,%esp
  800840:	ff 75 f4             	pushl  -0xc(%ebp)
  800843:	50                   	push   %eax
  800844:	e8 6f ff ff ff       	call   8007b8 <vcprintf>
  800849:	83 c4 10             	add    $0x10,%esp
  80084c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80084f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800852:	c9                   	leave  
  800853:	c3                   	ret    

00800854 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800854:	55                   	push   %ebp
  800855:	89 e5                	mov    %esp,%ebp
  800857:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80085a:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800861:	8b 45 08             	mov    0x8(%ebp),%eax
  800864:	c1 e0 08             	shl    $0x8,%eax
  800867:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  80086c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80086f:	83 c0 04             	add    $0x4,%eax
  800872:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800875:	8b 45 0c             	mov    0xc(%ebp),%eax
  800878:	83 ec 08             	sub    $0x8,%esp
  80087b:	ff 75 f4             	pushl  -0xc(%ebp)
  80087e:	50                   	push   %eax
  80087f:	e8 34 ff ff ff       	call   8007b8 <vcprintf>
  800884:	83 c4 10             	add    $0x10,%esp
  800887:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  80088a:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  800891:	07 00 00 

	return cnt;
  800894:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800897:	c9                   	leave  
  800898:	c3                   	ret    

00800899 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800899:	55                   	push   %ebp
  80089a:	89 e5                	mov    %esp,%ebp
  80089c:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80089f:	e8 8e 10 00 00       	call   801932 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8008a4:	8d 45 0c             	lea    0xc(%ebp),%eax
  8008a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8008aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ad:	83 ec 08             	sub    $0x8,%esp
  8008b0:	ff 75 f4             	pushl  -0xc(%ebp)
  8008b3:	50                   	push   %eax
  8008b4:	e8 ff fe ff ff       	call   8007b8 <vcprintf>
  8008b9:	83 c4 10             	add    $0x10,%esp
  8008bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8008bf:	e8 88 10 00 00       	call   80194c <sys_unlock_cons>
	return cnt;
  8008c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8008c7:	c9                   	leave  
  8008c8:	c3                   	ret    

008008c9 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8008c9:	55                   	push   %ebp
  8008ca:	89 e5                	mov    %esp,%ebp
  8008cc:	53                   	push   %ebx
  8008cd:	83 ec 14             	sub    $0x14,%esp
  8008d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8008d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8008dc:	8b 45 18             	mov    0x18(%ebp),%eax
  8008df:	ba 00 00 00 00       	mov    $0x0,%edx
  8008e4:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8008e7:	77 55                	ja     80093e <printnum+0x75>
  8008e9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8008ec:	72 05                	jb     8008f3 <printnum+0x2a>
  8008ee:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8008f1:	77 4b                	ja     80093e <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8008f3:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8008f6:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8008f9:	8b 45 18             	mov    0x18(%ebp),%eax
  8008fc:	ba 00 00 00 00       	mov    $0x0,%edx
  800901:	52                   	push   %edx
  800902:	50                   	push   %eax
  800903:	ff 75 f4             	pushl  -0xc(%ebp)
  800906:	ff 75 f0             	pushl  -0x10(%ebp)
  800909:	e8 aa 16 00 00       	call   801fb8 <__udivdi3>
  80090e:	83 c4 10             	add    $0x10,%esp
  800911:	83 ec 04             	sub    $0x4,%esp
  800914:	ff 75 20             	pushl  0x20(%ebp)
  800917:	53                   	push   %ebx
  800918:	ff 75 18             	pushl  0x18(%ebp)
  80091b:	52                   	push   %edx
  80091c:	50                   	push   %eax
  80091d:	ff 75 0c             	pushl  0xc(%ebp)
  800920:	ff 75 08             	pushl  0x8(%ebp)
  800923:	e8 a1 ff ff ff       	call   8008c9 <printnum>
  800928:	83 c4 20             	add    $0x20,%esp
  80092b:	eb 1a                	jmp    800947 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80092d:	83 ec 08             	sub    $0x8,%esp
  800930:	ff 75 0c             	pushl  0xc(%ebp)
  800933:	ff 75 20             	pushl  0x20(%ebp)
  800936:	8b 45 08             	mov    0x8(%ebp),%eax
  800939:	ff d0                	call   *%eax
  80093b:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80093e:	ff 4d 1c             	decl   0x1c(%ebp)
  800941:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800945:	7f e6                	jg     80092d <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800947:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80094a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80094f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800952:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800955:	53                   	push   %ebx
  800956:	51                   	push   %ecx
  800957:	52                   	push   %edx
  800958:	50                   	push   %eax
  800959:	e8 6a 17 00 00       	call   8020c8 <__umoddi3>
  80095e:	83 c4 10             	add    $0x10,%esp
  800961:	05 d4 28 80 00       	add    $0x8028d4,%eax
  800966:	8a 00                	mov    (%eax),%al
  800968:	0f be c0             	movsbl %al,%eax
  80096b:	83 ec 08             	sub    $0x8,%esp
  80096e:	ff 75 0c             	pushl  0xc(%ebp)
  800971:	50                   	push   %eax
  800972:	8b 45 08             	mov    0x8(%ebp),%eax
  800975:	ff d0                	call   *%eax
  800977:	83 c4 10             	add    $0x10,%esp
}
  80097a:	90                   	nop
  80097b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80097e:	c9                   	leave  
  80097f:	c3                   	ret    

00800980 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800980:	55                   	push   %ebp
  800981:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800983:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800987:	7e 1c                	jle    8009a5 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800989:	8b 45 08             	mov    0x8(%ebp),%eax
  80098c:	8b 00                	mov    (%eax),%eax
  80098e:	8d 50 08             	lea    0x8(%eax),%edx
  800991:	8b 45 08             	mov    0x8(%ebp),%eax
  800994:	89 10                	mov    %edx,(%eax)
  800996:	8b 45 08             	mov    0x8(%ebp),%eax
  800999:	8b 00                	mov    (%eax),%eax
  80099b:	83 e8 08             	sub    $0x8,%eax
  80099e:	8b 50 04             	mov    0x4(%eax),%edx
  8009a1:	8b 00                	mov    (%eax),%eax
  8009a3:	eb 40                	jmp    8009e5 <getuint+0x65>
	else if (lflag)
  8009a5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009a9:	74 1e                	je     8009c9 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8009ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ae:	8b 00                	mov    (%eax),%eax
  8009b0:	8d 50 04             	lea    0x4(%eax),%edx
  8009b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b6:	89 10                	mov    %edx,(%eax)
  8009b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bb:	8b 00                	mov    (%eax),%eax
  8009bd:	83 e8 04             	sub    $0x4,%eax
  8009c0:	8b 00                	mov    (%eax),%eax
  8009c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8009c7:	eb 1c                	jmp    8009e5 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8009c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cc:	8b 00                	mov    (%eax),%eax
  8009ce:	8d 50 04             	lea    0x4(%eax),%edx
  8009d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d4:	89 10                	mov    %edx,(%eax)
  8009d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d9:	8b 00                	mov    (%eax),%eax
  8009db:	83 e8 04             	sub    $0x4,%eax
  8009de:	8b 00                	mov    (%eax),%eax
  8009e0:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8009e5:	5d                   	pop    %ebp
  8009e6:	c3                   	ret    

008009e7 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8009e7:	55                   	push   %ebp
  8009e8:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8009ea:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8009ee:	7e 1c                	jle    800a0c <getint+0x25>
		return va_arg(*ap, long long);
  8009f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f3:	8b 00                	mov    (%eax),%eax
  8009f5:	8d 50 08             	lea    0x8(%eax),%edx
  8009f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fb:	89 10                	mov    %edx,(%eax)
  8009fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800a00:	8b 00                	mov    (%eax),%eax
  800a02:	83 e8 08             	sub    $0x8,%eax
  800a05:	8b 50 04             	mov    0x4(%eax),%edx
  800a08:	8b 00                	mov    (%eax),%eax
  800a0a:	eb 38                	jmp    800a44 <getint+0x5d>
	else if (lflag)
  800a0c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a10:	74 1a                	je     800a2c <getint+0x45>
		return va_arg(*ap, long);
  800a12:	8b 45 08             	mov    0x8(%ebp),%eax
  800a15:	8b 00                	mov    (%eax),%eax
  800a17:	8d 50 04             	lea    0x4(%eax),%edx
  800a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1d:	89 10                	mov    %edx,(%eax)
  800a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a22:	8b 00                	mov    (%eax),%eax
  800a24:	83 e8 04             	sub    $0x4,%eax
  800a27:	8b 00                	mov    (%eax),%eax
  800a29:	99                   	cltd   
  800a2a:	eb 18                	jmp    800a44 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2f:	8b 00                	mov    (%eax),%eax
  800a31:	8d 50 04             	lea    0x4(%eax),%edx
  800a34:	8b 45 08             	mov    0x8(%ebp),%eax
  800a37:	89 10                	mov    %edx,(%eax)
  800a39:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3c:	8b 00                	mov    (%eax),%eax
  800a3e:	83 e8 04             	sub    $0x4,%eax
  800a41:	8b 00                	mov    (%eax),%eax
  800a43:	99                   	cltd   
}
  800a44:	5d                   	pop    %ebp
  800a45:	c3                   	ret    

00800a46 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800a46:	55                   	push   %ebp
  800a47:	89 e5                	mov    %esp,%ebp
  800a49:	56                   	push   %esi
  800a4a:	53                   	push   %ebx
  800a4b:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a4e:	eb 17                	jmp    800a67 <vprintfmt+0x21>
			if (ch == '\0')
  800a50:	85 db                	test   %ebx,%ebx
  800a52:	0f 84 c1 03 00 00    	je     800e19 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800a58:	83 ec 08             	sub    $0x8,%esp
  800a5b:	ff 75 0c             	pushl  0xc(%ebp)
  800a5e:	53                   	push   %ebx
  800a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a62:	ff d0                	call   *%eax
  800a64:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a67:	8b 45 10             	mov    0x10(%ebp),%eax
  800a6a:	8d 50 01             	lea    0x1(%eax),%edx
  800a6d:	89 55 10             	mov    %edx,0x10(%ebp)
  800a70:	8a 00                	mov    (%eax),%al
  800a72:	0f b6 d8             	movzbl %al,%ebx
  800a75:	83 fb 25             	cmp    $0x25,%ebx
  800a78:	75 d6                	jne    800a50 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a7a:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800a7e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800a85:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800a8c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800a93:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a9a:	8b 45 10             	mov    0x10(%ebp),%eax
  800a9d:	8d 50 01             	lea    0x1(%eax),%edx
  800aa0:	89 55 10             	mov    %edx,0x10(%ebp)
  800aa3:	8a 00                	mov    (%eax),%al
  800aa5:	0f b6 d8             	movzbl %al,%ebx
  800aa8:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800aab:	83 f8 5b             	cmp    $0x5b,%eax
  800aae:	0f 87 3d 03 00 00    	ja     800df1 <vprintfmt+0x3ab>
  800ab4:	8b 04 85 f8 28 80 00 	mov    0x8028f8(,%eax,4),%eax
  800abb:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800abd:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800ac1:	eb d7                	jmp    800a9a <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800ac3:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800ac7:	eb d1                	jmp    800a9a <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ac9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800ad0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800ad3:	89 d0                	mov    %edx,%eax
  800ad5:	c1 e0 02             	shl    $0x2,%eax
  800ad8:	01 d0                	add    %edx,%eax
  800ada:	01 c0                	add    %eax,%eax
  800adc:	01 d8                	add    %ebx,%eax
  800ade:	83 e8 30             	sub    $0x30,%eax
  800ae1:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800ae4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ae7:	8a 00                	mov    (%eax),%al
  800ae9:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800aec:	83 fb 2f             	cmp    $0x2f,%ebx
  800aef:	7e 3e                	jle    800b2f <vprintfmt+0xe9>
  800af1:	83 fb 39             	cmp    $0x39,%ebx
  800af4:	7f 39                	jg     800b2f <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800af6:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800af9:	eb d5                	jmp    800ad0 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800afb:	8b 45 14             	mov    0x14(%ebp),%eax
  800afe:	83 c0 04             	add    $0x4,%eax
  800b01:	89 45 14             	mov    %eax,0x14(%ebp)
  800b04:	8b 45 14             	mov    0x14(%ebp),%eax
  800b07:	83 e8 04             	sub    $0x4,%eax
  800b0a:	8b 00                	mov    (%eax),%eax
  800b0c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800b0f:	eb 1f                	jmp    800b30 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800b11:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b15:	79 83                	jns    800a9a <vprintfmt+0x54>
				width = 0;
  800b17:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800b1e:	e9 77 ff ff ff       	jmp    800a9a <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800b23:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800b2a:	e9 6b ff ff ff       	jmp    800a9a <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800b2f:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800b30:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b34:	0f 89 60 ff ff ff    	jns    800a9a <vprintfmt+0x54>
				width = precision, precision = -1;
  800b3a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b3d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b40:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800b47:	e9 4e ff ff ff       	jmp    800a9a <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b4c:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800b4f:	e9 46 ff ff ff       	jmp    800a9a <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800b54:	8b 45 14             	mov    0x14(%ebp),%eax
  800b57:	83 c0 04             	add    $0x4,%eax
  800b5a:	89 45 14             	mov    %eax,0x14(%ebp)
  800b5d:	8b 45 14             	mov    0x14(%ebp),%eax
  800b60:	83 e8 04             	sub    $0x4,%eax
  800b63:	8b 00                	mov    (%eax),%eax
  800b65:	83 ec 08             	sub    $0x8,%esp
  800b68:	ff 75 0c             	pushl  0xc(%ebp)
  800b6b:	50                   	push   %eax
  800b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6f:	ff d0                	call   *%eax
  800b71:	83 c4 10             	add    $0x10,%esp
			break;
  800b74:	e9 9b 02 00 00       	jmp    800e14 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800b79:	8b 45 14             	mov    0x14(%ebp),%eax
  800b7c:	83 c0 04             	add    $0x4,%eax
  800b7f:	89 45 14             	mov    %eax,0x14(%ebp)
  800b82:	8b 45 14             	mov    0x14(%ebp),%eax
  800b85:	83 e8 04             	sub    $0x4,%eax
  800b88:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800b8a:	85 db                	test   %ebx,%ebx
  800b8c:	79 02                	jns    800b90 <vprintfmt+0x14a>
				err = -err;
  800b8e:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800b90:	83 fb 64             	cmp    $0x64,%ebx
  800b93:	7f 0b                	jg     800ba0 <vprintfmt+0x15a>
  800b95:	8b 34 9d 40 27 80 00 	mov    0x802740(,%ebx,4),%esi
  800b9c:	85 f6                	test   %esi,%esi
  800b9e:	75 19                	jne    800bb9 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ba0:	53                   	push   %ebx
  800ba1:	68 e5 28 80 00       	push   $0x8028e5
  800ba6:	ff 75 0c             	pushl  0xc(%ebp)
  800ba9:	ff 75 08             	pushl  0x8(%ebp)
  800bac:	e8 70 02 00 00       	call   800e21 <printfmt>
  800bb1:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800bb4:	e9 5b 02 00 00       	jmp    800e14 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800bb9:	56                   	push   %esi
  800bba:	68 ee 28 80 00       	push   $0x8028ee
  800bbf:	ff 75 0c             	pushl  0xc(%ebp)
  800bc2:	ff 75 08             	pushl  0x8(%ebp)
  800bc5:	e8 57 02 00 00       	call   800e21 <printfmt>
  800bca:	83 c4 10             	add    $0x10,%esp
			break;
  800bcd:	e9 42 02 00 00       	jmp    800e14 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800bd2:	8b 45 14             	mov    0x14(%ebp),%eax
  800bd5:	83 c0 04             	add    $0x4,%eax
  800bd8:	89 45 14             	mov    %eax,0x14(%ebp)
  800bdb:	8b 45 14             	mov    0x14(%ebp),%eax
  800bde:	83 e8 04             	sub    $0x4,%eax
  800be1:	8b 30                	mov    (%eax),%esi
  800be3:	85 f6                	test   %esi,%esi
  800be5:	75 05                	jne    800bec <vprintfmt+0x1a6>
				p = "(null)";
  800be7:	be f1 28 80 00       	mov    $0x8028f1,%esi
			if (width > 0 && padc != '-')
  800bec:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bf0:	7e 6d                	jle    800c5f <vprintfmt+0x219>
  800bf2:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800bf6:	74 67                	je     800c5f <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800bf8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800bfb:	83 ec 08             	sub    $0x8,%esp
  800bfe:	50                   	push   %eax
  800bff:	56                   	push   %esi
  800c00:	e8 1e 03 00 00       	call   800f23 <strnlen>
  800c05:	83 c4 10             	add    $0x10,%esp
  800c08:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800c0b:	eb 16                	jmp    800c23 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800c0d:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800c11:	83 ec 08             	sub    $0x8,%esp
  800c14:	ff 75 0c             	pushl  0xc(%ebp)
  800c17:	50                   	push   %eax
  800c18:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1b:	ff d0                	call   *%eax
  800c1d:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800c20:	ff 4d e4             	decl   -0x1c(%ebp)
  800c23:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c27:	7f e4                	jg     800c0d <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c29:	eb 34                	jmp    800c5f <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800c2b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800c2f:	74 1c                	je     800c4d <vprintfmt+0x207>
  800c31:	83 fb 1f             	cmp    $0x1f,%ebx
  800c34:	7e 05                	jle    800c3b <vprintfmt+0x1f5>
  800c36:	83 fb 7e             	cmp    $0x7e,%ebx
  800c39:	7e 12                	jle    800c4d <vprintfmt+0x207>
					putch('?', putdat);
  800c3b:	83 ec 08             	sub    $0x8,%esp
  800c3e:	ff 75 0c             	pushl  0xc(%ebp)
  800c41:	6a 3f                	push   $0x3f
  800c43:	8b 45 08             	mov    0x8(%ebp),%eax
  800c46:	ff d0                	call   *%eax
  800c48:	83 c4 10             	add    $0x10,%esp
  800c4b:	eb 0f                	jmp    800c5c <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800c4d:	83 ec 08             	sub    $0x8,%esp
  800c50:	ff 75 0c             	pushl  0xc(%ebp)
  800c53:	53                   	push   %ebx
  800c54:	8b 45 08             	mov    0x8(%ebp),%eax
  800c57:	ff d0                	call   *%eax
  800c59:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c5c:	ff 4d e4             	decl   -0x1c(%ebp)
  800c5f:	89 f0                	mov    %esi,%eax
  800c61:	8d 70 01             	lea    0x1(%eax),%esi
  800c64:	8a 00                	mov    (%eax),%al
  800c66:	0f be d8             	movsbl %al,%ebx
  800c69:	85 db                	test   %ebx,%ebx
  800c6b:	74 24                	je     800c91 <vprintfmt+0x24b>
  800c6d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c71:	78 b8                	js     800c2b <vprintfmt+0x1e5>
  800c73:	ff 4d e0             	decl   -0x20(%ebp)
  800c76:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c7a:	79 af                	jns    800c2b <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c7c:	eb 13                	jmp    800c91 <vprintfmt+0x24b>
				putch(' ', putdat);
  800c7e:	83 ec 08             	sub    $0x8,%esp
  800c81:	ff 75 0c             	pushl  0xc(%ebp)
  800c84:	6a 20                	push   $0x20
  800c86:	8b 45 08             	mov    0x8(%ebp),%eax
  800c89:	ff d0                	call   *%eax
  800c8b:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c8e:	ff 4d e4             	decl   -0x1c(%ebp)
  800c91:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c95:	7f e7                	jg     800c7e <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800c97:	e9 78 01 00 00       	jmp    800e14 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800c9c:	83 ec 08             	sub    $0x8,%esp
  800c9f:	ff 75 e8             	pushl  -0x18(%ebp)
  800ca2:	8d 45 14             	lea    0x14(%ebp),%eax
  800ca5:	50                   	push   %eax
  800ca6:	e8 3c fd ff ff       	call   8009e7 <getint>
  800cab:	83 c4 10             	add    $0x10,%esp
  800cae:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cb1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800cb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cb7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cba:	85 d2                	test   %edx,%edx
  800cbc:	79 23                	jns    800ce1 <vprintfmt+0x29b>
				putch('-', putdat);
  800cbe:	83 ec 08             	sub    $0x8,%esp
  800cc1:	ff 75 0c             	pushl  0xc(%ebp)
  800cc4:	6a 2d                	push   $0x2d
  800cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc9:	ff d0                	call   *%eax
  800ccb:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800cce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cd1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cd4:	f7 d8                	neg    %eax
  800cd6:	83 d2 00             	adc    $0x0,%edx
  800cd9:	f7 da                	neg    %edx
  800cdb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cde:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800ce1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ce8:	e9 bc 00 00 00       	jmp    800da9 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ced:	83 ec 08             	sub    $0x8,%esp
  800cf0:	ff 75 e8             	pushl  -0x18(%ebp)
  800cf3:	8d 45 14             	lea    0x14(%ebp),%eax
  800cf6:	50                   	push   %eax
  800cf7:	e8 84 fc ff ff       	call   800980 <getuint>
  800cfc:	83 c4 10             	add    $0x10,%esp
  800cff:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d02:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800d05:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800d0c:	e9 98 00 00 00       	jmp    800da9 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800d11:	83 ec 08             	sub    $0x8,%esp
  800d14:	ff 75 0c             	pushl  0xc(%ebp)
  800d17:	6a 58                	push   $0x58
  800d19:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1c:	ff d0                	call   *%eax
  800d1e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800d21:	83 ec 08             	sub    $0x8,%esp
  800d24:	ff 75 0c             	pushl  0xc(%ebp)
  800d27:	6a 58                	push   $0x58
  800d29:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2c:	ff d0                	call   *%eax
  800d2e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800d31:	83 ec 08             	sub    $0x8,%esp
  800d34:	ff 75 0c             	pushl  0xc(%ebp)
  800d37:	6a 58                	push   $0x58
  800d39:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3c:	ff d0                	call   *%eax
  800d3e:	83 c4 10             	add    $0x10,%esp
			break;
  800d41:	e9 ce 00 00 00       	jmp    800e14 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800d46:	83 ec 08             	sub    $0x8,%esp
  800d49:	ff 75 0c             	pushl  0xc(%ebp)
  800d4c:	6a 30                	push   $0x30
  800d4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d51:	ff d0                	call   *%eax
  800d53:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800d56:	83 ec 08             	sub    $0x8,%esp
  800d59:	ff 75 0c             	pushl  0xc(%ebp)
  800d5c:	6a 78                	push   $0x78
  800d5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d61:	ff d0                	call   *%eax
  800d63:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800d66:	8b 45 14             	mov    0x14(%ebp),%eax
  800d69:	83 c0 04             	add    $0x4,%eax
  800d6c:	89 45 14             	mov    %eax,0x14(%ebp)
  800d6f:	8b 45 14             	mov    0x14(%ebp),%eax
  800d72:	83 e8 04             	sub    $0x4,%eax
  800d75:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d77:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d7a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800d81:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800d88:	eb 1f                	jmp    800da9 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800d8a:	83 ec 08             	sub    $0x8,%esp
  800d8d:	ff 75 e8             	pushl  -0x18(%ebp)
  800d90:	8d 45 14             	lea    0x14(%ebp),%eax
  800d93:	50                   	push   %eax
  800d94:	e8 e7 fb ff ff       	call   800980 <getuint>
  800d99:	83 c4 10             	add    $0x10,%esp
  800d9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d9f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800da2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800da9:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800dad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800db0:	83 ec 04             	sub    $0x4,%esp
  800db3:	52                   	push   %edx
  800db4:	ff 75 e4             	pushl  -0x1c(%ebp)
  800db7:	50                   	push   %eax
  800db8:	ff 75 f4             	pushl  -0xc(%ebp)
  800dbb:	ff 75 f0             	pushl  -0x10(%ebp)
  800dbe:	ff 75 0c             	pushl  0xc(%ebp)
  800dc1:	ff 75 08             	pushl  0x8(%ebp)
  800dc4:	e8 00 fb ff ff       	call   8008c9 <printnum>
  800dc9:	83 c4 20             	add    $0x20,%esp
			break;
  800dcc:	eb 46                	jmp    800e14 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800dce:	83 ec 08             	sub    $0x8,%esp
  800dd1:	ff 75 0c             	pushl  0xc(%ebp)
  800dd4:	53                   	push   %ebx
  800dd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd8:	ff d0                	call   *%eax
  800dda:	83 c4 10             	add    $0x10,%esp
			break;
  800ddd:	eb 35                	jmp    800e14 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800ddf:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800de6:	eb 2c                	jmp    800e14 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800de8:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800def:	eb 23                	jmp    800e14 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800df1:	83 ec 08             	sub    $0x8,%esp
  800df4:	ff 75 0c             	pushl  0xc(%ebp)
  800df7:	6a 25                	push   $0x25
  800df9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfc:	ff d0                	call   *%eax
  800dfe:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800e01:	ff 4d 10             	decl   0x10(%ebp)
  800e04:	eb 03                	jmp    800e09 <vprintfmt+0x3c3>
  800e06:	ff 4d 10             	decl   0x10(%ebp)
  800e09:	8b 45 10             	mov    0x10(%ebp),%eax
  800e0c:	48                   	dec    %eax
  800e0d:	8a 00                	mov    (%eax),%al
  800e0f:	3c 25                	cmp    $0x25,%al
  800e11:	75 f3                	jne    800e06 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800e13:	90                   	nop
		}
	}
  800e14:	e9 35 fc ff ff       	jmp    800a4e <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800e19:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800e1a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e1d:	5b                   	pop    %ebx
  800e1e:	5e                   	pop    %esi
  800e1f:	5d                   	pop    %ebp
  800e20:	c3                   	ret    

00800e21 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800e21:	55                   	push   %ebp
  800e22:	89 e5                	mov    %esp,%ebp
  800e24:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800e27:	8d 45 10             	lea    0x10(%ebp),%eax
  800e2a:	83 c0 04             	add    $0x4,%eax
  800e2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800e30:	8b 45 10             	mov    0x10(%ebp),%eax
  800e33:	ff 75 f4             	pushl  -0xc(%ebp)
  800e36:	50                   	push   %eax
  800e37:	ff 75 0c             	pushl  0xc(%ebp)
  800e3a:	ff 75 08             	pushl  0x8(%ebp)
  800e3d:	e8 04 fc ff ff       	call   800a46 <vprintfmt>
  800e42:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800e45:	90                   	nop
  800e46:	c9                   	leave  
  800e47:	c3                   	ret    

00800e48 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e48:	55                   	push   %ebp
  800e49:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800e4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4e:	8b 40 08             	mov    0x8(%eax),%eax
  800e51:	8d 50 01             	lea    0x1(%eax),%edx
  800e54:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e57:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800e5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e5d:	8b 10                	mov    (%eax),%edx
  800e5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e62:	8b 40 04             	mov    0x4(%eax),%eax
  800e65:	39 c2                	cmp    %eax,%edx
  800e67:	73 12                	jae    800e7b <sprintputch+0x33>
		*b->buf++ = ch;
  800e69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6c:	8b 00                	mov    (%eax),%eax
  800e6e:	8d 48 01             	lea    0x1(%eax),%ecx
  800e71:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e74:	89 0a                	mov    %ecx,(%edx)
  800e76:	8b 55 08             	mov    0x8(%ebp),%edx
  800e79:	88 10                	mov    %dl,(%eax)
}
  800e7b:	90                   	nop
  800e7c:	5d                   	pop    %ebp
  800e7d:	c3                   	ret    

00800e7e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e7e:	55                   	push   %ebp
  800e7f:	89 e5                	mov    %esp,%ebp
  800e81:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e84:	8b 45 08             	mov    0x8(%ebp),%eax
  800e87:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800e8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e90:	8b 45 08             	mov    0x8(%ebp),%eax
  800e93:	01 d0                	add    %edx,%eax
  800e95:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e98:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800e9f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ea3:	74 06                	je     800eab <vsnprintf+0x2d>
  800ea5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ea9:	7f 07                	jg     800eb2 <vsnprintf+0x34>
		return -E_INVAL;
  800eab:	b8 03 00 00 00       	mov    $0x3,%eax
  800eb0:	eb 20                	jmp    800ed2 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800eb2:	ff 75 14             	pushl  0x14(%ebp)
  800eb5:	ff 75 10             	pushl  0x10(%ebp)
  800eb8:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ebb:	50                   	push   %eax
  800ebc:	68 48 0e 80 00       	push   $0x800e48
  800ec1:	e8 80 fb ff ff       	call   800a46 <vprintfmt>
  800ec6:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800ec9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ecc:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ecf:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800ed2:	c9                   	leave  
  800ed3:	c3                   	ret    

00800ed4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ed4:	55                   	push   %ebp
  800ed5:	89 e5                	mov    %esp,%ebp
  800ed7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800eda:	8d 45 10             	lea    0x10(%ebp),%eax
  800edd:	83 c0 04             	add    $0x4,%eax
  800ee0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ee3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee6:	ff 75 f4             	pushl  -0xc(%ebp)
  800ee9:	50                   	push   %eax
  800eea:	ff 75 0c             	pushl  0xc(%ebp)
  800eed:	ff 75 08             	pushl  0x8(%ebp)
  800ef0:	e8 89 ff ff ff       	call   800e7e <vsnprintf>
  800ef5:	83 c4 10             	add    $0x10,%esp
  800ef8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800efb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800efe:	c9                   	leave  
  800eff:	c3                   	ret    

00800f00 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800f00:	55                   	push   %ebp
  800f01:	89 e5                	mov    %esp,%ebp
  800f03:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800f06:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f0d:	eb 06                	jmp    800f15 <strlen+0x15>
		n++;
  800f0f:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800f12:	ff 45 08             	incl   0x8(%ebp)
  800f15:	8b 45 08             	mov    0x8(%ebp),%eax
  800f18:	8a 00                	mov    (%eax),%al
  800f1a:	84 c0                	test   %al,%al
  800f1c:	75 f1                	jne    800f0f <strlen+0xf>
		n++;
	return n;
  800f1e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f21:	c9                   	leave  
  800f22:	c3                   	ret    

00800f23 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800f23:	55                   	push   %ebp
  800f24:	89 e5                	mov    %esp,%ebp
  800f26:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f29:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f30:	eb 09                	jmp    800f3b <strnlen+0x18>
		n++;
  800f32:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f35:	ff 45 08             	incl   0x8(%ebp)
  800f38:	ff 4d 0c             	decl   0xc(%ebp)
  800f3b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f3f:	74 09                	je     800f4a <strnlen+0x27>
  800f41:	8b 45 08             	mov    0x8(%ebp),%eax
  800f44:	8a 00                	mov    (%eax),%al
  800f46:	84 c0                	test   %al,%al
  800f48:	75 e8                	jne    800f32 <strnlen+0xf>
		n++;
	return n;
  800f4a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f4d:	c9                   	leave  
  800f4e:	c3                   	ret    

00800f4f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800f4f:	55                   	push   %ebp
  800f50:	89 e5                	mov    %esp,%ebp
  800f52:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800f55:	8b 45 08             	mov    0x8(%ebp),%eax
  800f58:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800f5b:	90                   	nop
  800f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5f:	8d 50 01             	lea    0x1(%eax),%edx
  800f62:	89 55 08             	mov    %edx,0x8(%ebp)
  800f65:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f68:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f6b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f6e:	8a 12                	mov    (%edx),%dl
  800f70:	88 10                	mov    %dl,(%eax)
  800f72:	8a 00                	mov    (%eax),%al
  800f74:	84 c0                	test   %al,%al
  800f76:	75 e4                	jne    800f5c <strcpy+0xd>
		/* do nothing */;
	return ret;
  800f78:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f7b:	c9                   	leave  
  800f7c:	c3                   	ret    

00800f7d <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800f7d:	55                   	push   %ebp
  800f7e:	89 e5                	mov    %esp,%ebp
  800f80:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800f83:	8b 45 08             	mov    0x8(%ebp),%eax
  800f86:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800f89:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f90:	eb 1f                	jmp    800fb1 <strncpy+0x34>
		*dst++ = *src;
  800f92:	8b 45 08             	mov    0x8(%ebp),%eax
  800f95:	8d 50 01             	lea    0x1(%eax),%edx
  800f98:	89 55 08             	mov    %edx,0x8(%ebp)
  800f9b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f9e:	8a 12                	mov    (%edx),%dl
  800fa0:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800fa2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa5:	8a 00                	mov    (%eax),%al
  800fa7:	84 c0                	test   %al,%al
  800fa9:	74 03                	je     800fae <strncpy+0x31>
			src++;
  800fab:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800fae:	ff 45 fc             	incl   -0x4(%ebp)
  800fb1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fb4:	3b 45 10             	cmp    0x10(%ebp),%eax
  800fb7:	72 d9                	jb     800f92 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800fb9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800fbc:	c9                   	leave  
  800fbd:	c3                   	ret    

00800fbe <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800fbe:	55                   	push   %ebp
  800fbf:	89 e5                	mov    %esp,%ebp
  800fc1:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800fc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800fca:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fce:	74 30                	je     801000 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800fd0:	eb 16                	jmp    800fe8 <strlcpy+0x2a>
			*dst++ = *src++;
  800fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd5:	8d 50 01             	lea    0x1(%eax),%edx
  800fd8:	89 55 08             	mov    %edx,0x8(%ebp)
  800fdb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fde:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fe1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800fe4:	8a 12                	mov    (%edx),%dl
  800fe6:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800fe8:	ff 4d 10             	decl   0x10(%ebp)
  800feb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fef:	74 09                	je     800ffa <strlcpy+0x3c>
  800ff1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff4:	8a 00                	mov    (%eax),%al
  800ff6:	84 c0                	test   %al,%al
  800ff8:	75 d8                	jne    800fd2 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffd:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801000:	8b 55 08             	mov    0x8(%ebp),%edx
  801003:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801006:	29 c2                	sub    %eax,%edx
  801008:	89 d0                	mov    %edx,%eax
}
  80100a:	c9                   	leave  
  80100b:	c3                   	ret    

0080100c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80100c:	55                   	push   %ebp
  80100d:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80100f:	eb 06                	jmp    801017 <strcmp+0xb>
		p++, q++;
  801011:	ff 45 08             	incl   0x8(%ebp)
  801014:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801017:	8b 45 08             	mov    0x8(%ebp),%eax
  80101a:	8a 00                	mov    (%eax),%al
  80101c:	84 c0                	test   %al,%al
  80101e:	74 0e                	je     80102e <strcmp+0x22>
  801020:	8b 45 08             	mov    0x8(%ebp),%eax
  801023:	8a 10                	mov    (%eax),%dl
  801025:	8b 45 0c             	mov    0xc(%ebp),%eax
  801028:	8a 00                	mov    (%eax),%al
  80102a:	38 c2                	cmp    %al,%dl
  80102c:	74 e3                	je     801011 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80102e:	8b 45 08             	mov    0x8(%ebp),%eax
  801031:	8a 00                	mov    (%eax),%al
  801033:	0f b6 d0             	movzbl %al,%edx
  801036:	8b 45 0c             	mov    0xc(%ebp),%eax
  801039:	8a 00                	mov    (%eax),%al
  80103b:	0f b6 c0             	movzbl %al,%eax
  80103e:	29 c2                	sub    %eax,%edx
  801040:	89 d0                	mov    %edx,%eax
}
  801042:	5d                   	pop    %ebp
  801043:	c3                   	ret    

00801044 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801044:	55                   	push   %ebp
  801045:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801047:	eb 09                	jmp    801052 <strncmp+0xe>
		n--, p++, q++;
  801049:	ff 4d 10             	decl   0x10(%ebp)
  80104c:	ff 45 08             	incl   0x8(%ebp)
  80104f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801052:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801056:	74 17                	je     80106f <strncmp+0x2b>
  801058:	8b 45 08             	mov    0x8(%ebp),%eax
  80105b:	8a 00                	mov    (%eax),%al
  80105d:	84 c0                	test   %al,%al
  80105f:	74 0e                	je     80106f <strncmp+0x2b>
  801061:	8b 45 08             	mov    0x8(%ebp),%eax
  801064:	8a 10                	mov    (%eax),%dl
  801066:	8b 45 0c             	mov    0xc(%ebp),%eax
  801069:	8a 00                	mov    (%eax),%al
  80106b:	38 c2                	cmp    %al,%dl
  80106d:	74 da                	je     801049 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80106f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801073:	75 07                	jne    80107c <strncmp+0x38>
		return 0;
  801075:	b8 00 00 00 00       	mov    $0x0,%eax
  80107a:	eb 14                	jmp    801090 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80107c:	8b 45 08             	mov    0x8(%ebp),%eax
  80107f:	8a 00                	mov    (%eax),%al
  801081:	0f b6 d0             	movzbl %al,%edx
  801084:	8b 45 0c             	mov    0xc(%ebp),%eax
  801087:	8a 00                	mov    (%eax),%al
  801089:	0f b6 c0             	movzbl %al,%eax
  80108c:	29 c2                	sub    %eax,%edx
  80108e:	89 d0                	mov    %edx,%eax
}
  801090:	5d                   	pop    %ebp
  801091:	c3                   	ret    

00801092 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801092:	55                   	push   %ebp
  801093:	89 e5                	mov    %esp,%ebp
  801095:	83 ec 04             	sub    $0x4,%esp
  801098:	8b 45 0c             	mov    0xc(%ebp),%eax
  80109b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80109e:	eb 12                	jmp    8010b2 <strchr+0x20>
		if (*s == c)
  8010a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a3:	8a 00                	mov    (%eax),%al
  8010a5:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8010a8:	75 05                	jne    8010af <strchr+0x1d>
			return (char *) s;
  8010aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ad:	eb 11                	jmp    8010c0 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8010af:	ff 45 08             	incl   0x8(%ebp)
  8010b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b5:	8a 00                	mov    (%eax),%al
  8010b7:	84 c0                	test   %al,%al
  8010b9:	75 e5                	jne    8010a0 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8010bb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010c0:	c9                   	leave  
  8010c1:	c3                   	ret    

008010c2 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8010c2:	55                   	push   %ebp
  8010c3:	89 e5                	mov    %esp,%ebp
  8010c5:	83 ec 04             	sub    $0x4,%esp
  8010c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010cb:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8010ce:	eb 0d                	jmp    8010dd <strfind+0x1b>
		if (*s == c)
  8010d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d3:	8a 00                	mov    (%eax),%al
  8010d5:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8010d8:	74 0e                	je     8010e8 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8010da:	ff 45 08             	incl   0x8(%ebp)
  8010dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e0:	8a 00                	mov    (%eax),%al
  8010e2:	84 c0                	test   %al,%al
  8010e4:	75 ea                	jne    8010d0 <strfind+0xe>
  8010e6:	eb 01                	jmp    8010e9 <strfind+0x27>
		if (*s == c)
			break;
  8010e8:	90                   	nop
	return (char *) s;
  8010e9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010ec:	c9                   	leave  
  8010ed:	c3                   	ret    

008010ee <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  8010ee:	55                   	push   %ebp
  8010ef:	89 e5                	mov    %esp,%ebp
  8010f1:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  8010f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  8010fa:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010fe:	76 63                	jbe    801163 <memset+0x75>
		uint64 data_block = c;
  801100:	8b 45 0c             	mov    0xc(%ebp),%eax
  801103:	99                   	cltd   
  801104:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801107:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  80110a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80110d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801110:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801114:	c1 e0 08             	shl    $0x8,%eax
  801117:	09 45 f0             	or     %eax,-0x10(%ebp)
  80111a:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  80111d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801120:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801123:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801127:	c1 e0 10             	shl    $0x10,%eax
  80112a:	09 45 f0             	or     %eax,-0x10(%ebp)
  80112d:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801130:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801133:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801136:	89 c2                	mov    %eax,%edx
  801138:	b8 00 00 00 00       	mov    $0x0,%eax
  80113d:	09 45 f0             	or     %eax,-0x10(%ebp)
  801140:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801143:	eb 18                	jmp    80115d <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801145:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801148:	8d 41 08             	lea    0x8(%ecx),%eax
  80114b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80114e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801151:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801154:	89 01                	mov    %eax,(%ecx)
  801156:	89 51 04             	mov    %edx,0x4(%ecx)
  801159:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  80115d:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801161:	77 e2                	ja     801145 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801163:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801167:	74 23                	je     80118c <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801169:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80116c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  80116f:	eb 0e                	jmp    80117f <memset+0x91>
			*p8++ = (uint8)c;
  801171:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801174:	8d 50 01             	lea    0x1(%eax),%edx
  801177:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80117a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80117d:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  80117f:	8b 45 10             	mov    0x10(%ebp),%eax
  801182:	8d 50 ff             	lea    -0x1(%eax),%edx
  801185:	89 55 10             	mov    %edx,0x10(%ebp)
  801188:	85 c0                	test   %eax,%eax
  80118a:	75 e5                	jne    801171 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  80118c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80118f:	c9                   	leave  
  801190:	c3                   	ret    

00801191 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801191:	55                   	push   %ebp
  801192:	89 e5                	mov    %esp,%ebp
  801194:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801197:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  80119d:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8011a3:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8011a7:	76 24                	jbe    8011cd <memcpy+0x3c>
		while(n >= 8){
  8011a9:	eb 1c                	jmp    8011c7 <memcpy+0x36>
			*d64 = *s64;
  8011ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011ae:	8b 50 04             	mov    0x4(%eax),%edx
  8011b1:	8b 00                	mov    (%eax),%eax
  8011b3:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011b6:	89 01                	mov    %eax,(%ecx)
  8011b8:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8011bb:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8011bf:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8011c3:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8011c7:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8011cb:	77 de                	ja     8011ab <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8011cd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011d1:	74 31                	je     801204 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8011d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8011d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8011df:	eb 16                	jmp    8011f7 <memcpy+0x66>
			*d8++ = *s8++;
  8011e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011e4:	8d 50 01             	lea    0x1(%eax),%edx
  8011e7:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8011ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011ed:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011f0:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8011f3:	8a 12                	mov    (%edx),%dl
  8011f5:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  8011f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8011fa:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011fd:	89 55 10             	mov    %edx,0x10(%ebp)
  801200:	85 c0                	test   %eax,%eax
  801202:	75 dd                	jne    8011e1 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801204:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801207:	c9                   	leave  
  801208:	c3                   	ret    

00801209 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801209:	55                   	push   %ebp
  80120a:	89 e5                	mov    %esp,%ebp
  80120c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80120f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801212:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801215:	8b 45 08             	mov    0x8(%ebp),%eax
  801218:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80121b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80121e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801221:	73 50                	jae    801273 <memmove+0x6a>
  801223:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801226:	8b 45 10             	mov    0x10(%ebp),%eax
  801229:	01 d0                	add    %edx,%eax
  80122b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80122e:	76 43                	jbe    801273 <memmove+0x6a>
		s += n;
  801230:	8b 45 10             	mov    0x10(%ebp),%eax
  801233:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801236:	8b 45 10             	mov    0x10(%ebp),%eax
  801239:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80123c:	eb 10                	jmp    80124e <memmove+0x45>
			*--d = *--s;
  80123e:	ff 4d f8             	decl   -0x8(%ebp)
  801241:	ff 4d fc             	decl   -0x4(%ebp)
  801244:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801247:	8a 10                	mov    (%eax),%dl
  801249:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80124c:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80124e:	8b 45 10             	mov    0x10(%ebp),%eax
  801251:	8d 50 ff             	lea    -0x1(%eax),%edx
  801254:	89 55 10             	mov    %edx,0x10(%ebp)
  801257:	85 c0                	test   %eax,%eax
  801259:	75 e3                	jne    80123e <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80125b:	eb 23                	jmp    801280 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80125d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801260:	8d 50 01             	lea    0x1(%eax),%edx
  801263:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801266:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801269:	8d 4a 01             	lea    0x1(%edx),%ecx
  80126c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80126f:	8a 12                	mov    (%edx),%dl
  801271:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801273:	8b 45 10             	mov    0x10(%ebp),%eax
  801276:	8d 50 ff             	lea    -0x1(%eax),%edx
  801279:	89 55 10             	mov    %edx,0x10(%ebp)
  80127c:	85 c0                	test   %eax,%eax
  80127e:	75 dd                	jne    80125d <memmove+0x54>
			*d++ = *s++;

	return dst;
  801280:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801283:	c9                   	leave  
  801284:	c3                   	ret    

00801285 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801285:	55                   	push   %ebp
  801286:	89 e5                	mov    %esp,%ebp
  801288:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80128b:	8b 45 08             	mov    0x8(%ebp),%eax
  80128e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801291:	8b 45 0c             	mov    0xc(%ebp),%eax
  801294:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801297:	eb 2a                	jmp    8012c3 <memcmp+0x3e>
		if (*s1 != *s2)
  801299:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80129c:	8a 10                	mov    (%eax),%dl
  80129e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012a1:	8a 00                	mov    (%eax),%al
  8012a3:	38 c2                	cmp    %al,%dl
  8012a5:	74 16                	je     8012bd <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8012a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012aa:	8a 00                	mov    (%eax),%al
  8012ac:	0f b6 d0             	movzbl %al,%edx
  8012af:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012b2:	8a 00                	mov    (%eax),%al
  8012b4:	0f b6 c0             	movzbl %al,%eax
  8012b7:	29 c2                	sub    %eax,%edx
  8012b9:	89 d0                	mov    %edx,%eax
  8012bb:	eb 18                	jmp    8012d5 <memcmp+0x50>
		s1++, s2++;
  8012bd:	ff 45 fc             	incl   -0x4(%ebp)
  8012c0:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8012c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8012c6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012c9:	89 55 10             	mov    %edx,0x10(%ebp)
  8012cc:	85 c0                	test   %eax,%eax
  8012ce:	75 c9                	jne    801299 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8012d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012d5:	c9                   	leave  
  8012d6:	c3                   	ret    

008012d7 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8012d7:	55                   	push   %ebp
  8012d8:	89 e5                	mov    %esp,%ebp
  8012da:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8012dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8012e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e3:	01 d0                	add    %edx,%eax
  8012e5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8012e8:	eb 15                	jmp    8012ff <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8012ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ed:	8a 00                	mov    (%eax),%al
  8012ef:	0f b6 d0             	movzbl %al,%edx
  8012f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f5:	0f b6 c0             	movzbl %al,%eax
  8012f8:	39 c2                	cmp    %eax,%edx
  8012fa:	74 0d                	je     801309 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8012fc:	ff 45 08             	incl   0x8(%ebp)
  8012ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801302:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801305:	72 e3                	jb     8012ea <memfind+0x13>
  801307:	eb 01                	jmp    80130a <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801309:	90                   	nop
	return (void *) s;
  80130a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80130d:	c9                   	leave  
  80130e:	c3                   	ret    

0080130f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80130f:	55                   	push   %ebp
  801310:	89 e5                	mov    %esp,%ebp
  801312:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801315:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80131c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801323:	eb 03                	jmp    801328 <strtol+0x19>
		s++;
  801325:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801328:	8b 45 08             	mov    0x8(%ebp),%eax
  80132b:	8a 00                	mov    (%eax),%al
  80132d:	3c 20                	cmp    $0x20,%al
  80132f:	74 f4                	je     801325 <strtol+0x16>
  801331:	8b 45 08             	mov    0x8(%ebp),%eax
  801334:	8a 00                	mov    (%eax),%al
  801336:	3c 09                	cmp    $0x9,%al
  801338:	74 eb                	je     801325 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80133a:	8b 45 08             	mov    0x8(%ebp),%eax
  80133d:	8a 00                	mov    (%eax),%al
  80133f:	3c 2b                	cmp    $0x2b,%al
  801341:	75 05                	jne    801348 <strtol+0x39>
		s++;
  801343:	ff 45 08             	incl   0x8(%ebp)
  801346:	eb 13                	jmp    80135b <strtol+0x4c>
	else if (*s == '-')
  801348:	8b 45 08             	mov    0x8(%ebp),%eax
  80134b:	8a 00                	mov    (%eax),%al
  80134d:	3c 2d                	cmp    $0x2d,%al
  80134f:	75 0a                	jne    80135b <strtol+0x4c>
		s++, neg = 1;
  801351:	ff 45 08             	incl   0x8(%ebp)
  801354:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80135b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80135f:	74 06                	je     801367 <strtol+0x58>
  801361:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801365:	75 20                	jne    801387 <strtol+0x78>
  801367:	8b 45 08             	mov    0x8(%ebp),%eax
  80136a:	8a 00                	mov    (%eax),%al
  80136c:	3c 30                	cmp    $0x30,%al
  80136e:	75 17                	jne    801387 <strtol+0x78>
  801370:	8b 45 08             	mov    0x8(%ebp),%eax
  801373:	40                   	inc    %eax
  801374:	8a 00                	mov    (%eax),%al
  801376:	3c 78                	cmp    $0x78,%al
  801378:	75 0d                	jne    801387 <strtol+0x78>
		s += 2, base = 16;
  80137a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80137e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801385:	eb 28                	jmp    8013af <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801387:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80138b:	75 15                	jne    8013a2 <strtol+0x93>
  80138d:	8b 45 08             	mov    0x8(%ebp),%eax
  801390:	8a 00                	mov    (%eax),%al
  801392:	3c 30                	cmp    $0x30,%al
  801394:	75 0c                	jne    8013a2 <strtol+0x93>
		s++, base = 8;
  801396:	ff 45 08             	incl   0x8(%ebp)
  801399:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8013a0:	eb 0d                	jmp    8013af <strtol+0xa0>
	else if (base == 0)
  8013a2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013a6:	75 07                	jne    8013af <strtol+0xa0>
		base = 10;
  8013a8:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8013af:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b2:	8a 00                	mov    (%eax),%al
  8013b4:	3c 2f                	cmp    $0x2f,%al
  8013b6:	7e 19                	jle    8013d1 <strtol+0xc2>
  8013b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bb:	8a 00                	mov    (%eax),%al
  8013bd:	3c 39                	cmp    $0x39,%al
  8013bf:	7f 10                	jg     8013d1 <strtol+0xc2>
			dig = *s - '0';
  8013c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c4:	8a 00                	mov    (%eax),%al
  8013c6:	0f be c0             	movsbl %al,%eax
  8013c9:	83 e8 30             	sub    $0x30,%eax
  8013cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8013cf:	eb 42                	jmp    801413 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8013d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d4:	8a 00                	mov    (%eax),%al
  8013d6:	3c 60                	cmp    $0x60,%al
  8013d8:	7e 19                	jle    8013f3 <strtol+0xe4>
  8013da:	8b 45 08             	mov    0x8(%ebp),%eax
  8013dd:	8a 00                	mov    (%eax),%al
  8013df:	3c 7a                	cmp    $0x7a,%al
  8013e1:	7f 10                	jg     8013f3 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8013e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e6:	8a 00                	mov    (%eax),%al
  8013e8:	0f be c0             	movsbl %al,%eax
  8013eb:	83 e8 57             	sub    $0x57,%eax
  8013ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8013f1:	eb 20                	jmp    801413 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8013f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f6:	8a 00                	mov    (%eax),%al
  8013f8:	3c 40                	cmp    $0x40,%al
  8013fa:	7e 39                	jle    801435 <strtol+0x126>
  8013fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ff:	8a 00                	mov    (%eax),%al
  801401:	3c 5a                	cmp    $0x5a,%al
  801403:	7f 30                	jg     801435 <strtol+0x126>
			dig = *s - 'A' + 10;
  801405:	8b 45 08             	mov    0x8(%ebp),%eax
  801408:	8a 00                	mov    (%eax),%al
  80140a:	0f be c0             	movsbl %al,%eax
  80140d:	83 e8 37             	sub    $0x37,%eax
  801410:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801413:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801416:	3b 45 10             	cmp    0x10(%ebp),%eax
  801419:	7d 19                	jge    801434 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80141b:	ff 45 08             	incl   0x8(%ebp)
  80141e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801421:	0f af 45 10          	imul   0x10(%ebp),%eax
  801425:	89 c2                	mov    %eax,%edx
  801427:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80142a:	01 d0                	add    %edx,%eax
  80142c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80142f:	e9 7b ff ff ff       	jmp    8013af <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801434:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801435:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801439:	74 08                	je     801443 <strtol+0x134>
		*endptr = (char *) s;
  80143b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80143e:	8b 55 08             	mov    0x8(%ebp),%edx
  801441:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801443:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801447:	74 07                	je     801450 <strtol+0x141>
  801449:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80144c:	f7 d8                	neg    %eax
  80144e:	eb 03                	jmp    801453 <strtol+0x144>
  801450:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801453:	c9                   	leave  
  801454:	c3                   	ret    

00801455 <ltostr>:

void
ltostr(long value, char *str)
{
  801455:	55                   	push   %ebp
  801456:	89 e5                	mov    %esp,%ebp
  801458:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80145b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801462:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801469:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80146d:	79 13                	jns    801482 <ltostr+0x2d>
	{
		neg = 1;
  80146f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801476:	8b 45 0c             	mov    0xc(%ebp),%eax
  801479:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80147c:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80147f:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801482:	8b 45 08             	mov    0x8(%ebp),%eax
  801485:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80148a:	99                   	cltd   
  80148b:	f7 f9                	idiv   %ecx
  80148d:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801490:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801493:	8d 50 01             	lea    0x1(%eax),%edx
  801496:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801499:	89 c2                	mov    %eax,%edx
  80149b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80149e:	01 d0                	add    %edx,%eax
  8014a0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8014a3:	83 c2 30             	add    $0x30,%edx
  8014a6:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8014a8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014ab:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8014b0:	f7 e9                	imul   %ecx
  8014b2:	c1 fa 02             	sar    $0x2,%edx
  8014b5:	89 c8                	mov    %ecx,%eax
  8014b7:	c1 f8 1f             	sar    $0x1f,%eax
  8014ba:	29 c2                	sub    %eax,%edx
  8014bc:	89 d0                	mov    %edx,%eax
  8014be:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8014c1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014c5:	75 bb                	jne    801482 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8014c7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8014ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014d1:	48                   	dec    %eax
  8014d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8014d5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8014d9:	74 3d                	je     801518 <ltostr+0xc3>
		start = 1 ;
  8014db:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8014e2:	eb 34                	jmp    801518 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8014e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ea:	01 d0                	add    %edx,%eax
  8014ec:	8a 00                	mov    (%eax),%al
  8014ee:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8014f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f7:	01 c2                	add    %eax,%edx
  8014f9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8014fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ff:	01 c8                	add    %ecx,%eax
  801501:	8a 00                	mov    (%eax),%al
  801503:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801505:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801508:	8b 45 0c             	mov    0xc(%ebp),%eax
  80150b:	01 c2                	add    %eax,%edx
  80150d:	8a 45 eb             	mov    -0x15(%ebp),%al
  801510:	88 02                	mov    %al,(%edx)
		start++ ;
  801512:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801515:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801518:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80151b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80151e:	7c c4                	jl     8014e4 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801520:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801523:	8b 45 0c             	mov    0xc(%ebp),%eax
  801526:	01 d0                	add    %edx,%eax
  801528:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80152b:	90                   	nop
  80152c:	c9                   	leave  
  80152d:	c3                   	ret    

0080152e <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80152e:	55                   	push   %ebp
  80152f:	89 e5                	mov    %esp,%ebp
  801531:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801534:	ff 75 08             	pushl  0x8(%ebp)
  801537:	e8 c4 f9 ff ff       	call   800f00 <strlen>
  80153c:	83 c4 04             	add    $0x4,%esp
  80153f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801542:	ff 75 0c             	pushl  0xc(%ebp)
  801545:	e8 b6 f9 ff ff       	call   800f00 <strlen>
  80154a:	83 c4 04             	add    $0x4,%esp
  80154d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801550:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801557:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80155e:	eb 17                	jmp    801577 <strcconcat+0x49>
		final[s] = str1[s] ;
  801560:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801563:	8b 45 10             	mov    0x10(%ebp),%eax
  801566:	01 c2                	add    %eax,%edx
  801568:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80156b:	8b 45 08             	mov    0x8(%ebp),%eax
  80156e:	01 c8                	add    %ecx,%eax
  801570:	8a 00                	mov    (%eax),%al
  801572:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801574:	ff 45 fc             	incl   -0x4(%ebp)
  801577:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80157a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80157d:	7c e1                	jl     801560 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80157f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801586:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80158d:	eb 1f                	jmp    8015ae <strcconcat+0x80>
		final[s++] = str2[i] ;
  80158f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801592:	8d 50 01             	lea    0x1(%eax),%edx
  801595:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801598:	89 c2                	mov    %eax,%edx
  80159a:	8b 45 10             	mov    0x10(%ebp),%eax
  80159d:	01 c2                	add    %eax,%edx
  80159f:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8015a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a5:	01 c8                	add    %ecx,%eax
  8015a7:	8a 00                	mov    (%eax),%al
  8015a9:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8015ab:	ff 45 f8             	incl   -0x8(%ebp)
  8015ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015b1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8015b4:	7c d9                	jl     80158f <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8015b6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8015bc:	01 d0                	add    %edx,%eax
  8015be:	c6 00 00             	movb   $0x0,(%eax)
}
  8015c1:	90                   	nop
  8015c2:	c9                   	leave  
  8015c3:	c3                   	ret    

008015c4 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8015c4:	55                   	push   %ebp
  8015c5:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8015c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8015ca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8015d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8015d3:	8b 00                	mov    (%eax),%eax
  8015d5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8015df:	01 d0                	add    %edx,%eax
  8015e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8015e7:	eb 0c                	jmp    8015f5 <strsplit+0x31>
			*string++ = 0;
  8015e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ec:	8d 50 01             	lea    0x1(%eax),%edx
  8015ef:	89 55 08             	mov    %edx,0x8(%ebp)
  8015f2:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8015f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f8:	8a 00                	mov    (%eax),%al
  8015fa:	84 c0                	test   %al,%al
  8015fc:	74 18                	je     801616 <strsplit+0x52>
  8015fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801601:	8a 00                	mov    (%eax),%al
  801603:	0f be c0             	movsbl %al,%eax
  801606:	50                   	push   %eax
  801607:	ff 75 0c             	pushl  0xc(%ebp)
  80160a:	e8 83 fa ff ff       	call   801092 <strchr>
  80160f:	83 c4 08             	add    $0x8,%esp
  801612:	85 c0                	test   %eax,%eax
  801614:	75 d3                	jne    8015e9 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801616:	8b 45 08             	mov    0x8(%ebp),%eax
  801619:	8a 00                	mov    (%eax),%al
  80161b:	84 c0                	test   %al,%al
  80161d:	74 5a                	je     801679 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80161f:	8b 45 14             	mov    0x14(%ebp),%eax
  801622:	8b 00                	mov    (%eax),%eax
  801624:	83 f8 0f             	cmp    $0xf,%eax
  801627:	75 07                	jne    801630 <strsplit+0x6c>
		{
			return 0;
  801629:	b8 00 00 00 00       	mov    $0x0,%eax
  80162e:	eb 66                	jmp    801696 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801630:	8b 45 14             	mov    0x14(%ebp),%eax
  801633:	8b 00                	mov    (%eax),%eax
  801635:	8d 48 01             	lea    0x1(%eax),%ecx
  801638:	8b 55 14             	mov    0x14(%ebp),%edx
  80163b:	89 0a                	mov    %ecx,(%edx)
  80163d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801644:	8b 45 10             	mov    0x10(%ebp),%eax
  801647:	01 c2                	add    %eax,%edx
  801649:	8b 45 08             	mov    0x8(%ebp),%eax
  80164c:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80164e:	eb 03                	jmp    801653 <strsplit+0x8f>
			string++;
  801650:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801653:	8b 45 08             	mov    0x8(%ebp),%eax
  801656:	8a 00                	mov    (%eax),%al
  801658:	84 c0                	test   %al,%al
  80165a:	74 8b                	je     8015e7 <strsplit+0x23>
  80165c:	8b 45 08             	mov    0x8(%ebp),%eax
  80165f:	8a 00                	mov    (%eax),%al
  801661:	0f be c0             	movsbl %al,%eax
  801664:	50                   	push   %eax
  801665:	ff 75 0c             	pushl  0xc(%ebp)
  801668:	e8 25 fa ff ff       	call   801092 <strchr>
  80166d:	83 c4 08             	add    $0x8,%esp
  801670:	85 c0                	test   %eax,%eax
  801672:	74 dc                	je     801650 <strsplit+0x8c>
			string++;
	}
  801674:	e9 6e ff ff ff       	jmp    8015e7 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801679:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80167a:	8b 45 14             	mov    0x14(%ebp),%eax
  80167d:	8b 00                	mov    (%eax),%eax
  80167f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801686:	8b 45 10             	mov    0x10(%ebp),%eax
  801689:	01 d0                	add    %edx,%eax
  80168b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801691:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801696:	c9                   	leave  
  801697:	c3                   	ret    

00801698 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801698:	55                   	push   %ebp
  801699:	89 e5                	mov    %esp,%ebp
  80169b:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  80169e:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8016a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8016ab:	eb 4a                	jmp    8016f7 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8016ad:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b3:	01 c2                	add    %eax,%edx
  8016b5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8016b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016bb:	01 c8                	add    %ecx,%eax
  8016bd:	8a 00                	mov    (%eax),%al
  8016bf:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8016c1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016c7:	01 d0                	add    %edx,%eax
  8016c9:	8a 00                	mov    (%eax),%al
  8016cb:	3c 40                	cmp    $0x40,%al
  8016cd:	7e 25                	jle    8016f4 <str2lower+0x5c>
  8016cf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016d5:	01 d0                	add    %edx,%eax
  8016d7:	8a 00                	mov    (%eax),%al
  8016d9:	3c 5a                	cmp    $0x5a,%al
  8016db:	7f 17                	jg     8016f4 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8016dd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e3:	01 d0                	add    %edx,%eax
  8016e5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8016e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8016eb:	01 ca                	add    %ecx,%edx
  8016ed:	8a 12                	mov    (%edx),%dl
  8016ef:	83 c2 20             	add    $0x20,%edx
  8016f2:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8016f4:	ff 45 fc             	incl   -0x4(%ebp)
  8016f7:	ff 75 0c             	pushl  0xc(%ebp)
  8016fa:	e8 01 f8 ff ff       	call   800f00 <strlen>
  8016ff:	83 c4 04             	add    $0x4,%esp
  801702:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801705:	7f a6                	jg     8016ad <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801707:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80170a:	c9                   	leave  
  80170b:	c3                   	ret    

0080170c <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  80170c:	55                   	push   %ebp
  80170d:	89 e5                	mov    %esp,%ebp
  80170f:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801712:	a1 08 30 80 00       	mov    0x803008,%eax
  801717:	85 c0                	test   %eax,%eax
  801719:	74 42                	je     80175d <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  80171b:	83 ec 08             	sub    $0x8,%esp
  80171e:	68 00 00 00 82       	push   $0x82000000
  801723:	68 00 00 00 80       	push   $0x80000000
  801728:	e8 8c 07 00 00       	call   801eb9 <initialize_dynamic_allocator>
  80172d:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801730:	e8 e7 05 00 00       	call   801d1c <sys_get_uheap_strategy>
  801735:	a3 60 b0 81 00       	mov    %eax,0x81b060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  80173a:	a1 40 30 80 00       	mov    0x803040,%eax
  80173f:	05 00 10 00 00       	add    $0x1000,%eax
  801744:	a3 10 b1 81 00       	mov    %eax,0x81b110
		uheapPageAllocBreak = uheapPageAllocStart;
  801749:	a1 10 b1 81 00       	mov    0x81b110,%eax
  80174e:	a3 68 b0 81 00       	mov    %eax,0x81b068

		__firstTimeFlag = 0;
  801753:	c7 05 08 30 80 00 00 	movl   $0x0,0x803008
  80175a:	00 00 00 
	}
}
  80175d:	90                   	nop
  80175e:	c9                   	leave  
  80175f:	c3                   	ret    

00801760 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801760:	55                   	push   %ebp
  801761:	89 e5                	mov    %esp,%ebp
  801763:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801766:	8b 45 08             	mov    0x8(%ebp),%eax
  801769:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80176c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80176f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801774:	83 ec 08             	sub    $0x8,%esp
  801777:	68 06 04 00 00       	push   $0x406
  80177c:	50                   	push   %eax
  80177d:	e8 e4 01 00 00       	call   801966 <__sys_allocate_page>
  801782:	83 c4 10             	add    $0x10,%esp
  801785:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801788:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80178c:	79 14                	jns    8017a2 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  80178e:	83 ec 04             	sub    $0x4,%esp
  801791:	68 68 2a 80 00       	push   $0x802a68
  801796:	6a 1f                	push   $0x1f
  801798:	68 a4 2a 80 00       	push   $0x802aa4
  80179d:	e8 b7 ed ff ff       	call   800559 <_panic>
	return 0;
  8017a2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017a7:	c9                   	leave  
  8017a8:	c3                   	ret    

008017a9 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  8017a9:	55                   	push   %ebp
  8017aa:	89 e5                	mov    %esp,%ebp
  8017ac:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  8017af:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017b8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8017bd:	83 ec 0c             	sub    $0xc,%esp
  8017c0:	50                   	push   %eax
  8017c1:	e8 e7 01 00 00       	call   8019ad <__sys_unmap_frame>
  8017c6:	83 c4 10             	add    $0x10,%esp
  8017c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8017cc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8017d0:	79 14                	jns    8017e6 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  8017d2:	83 ec 04             	sub    $0x4,%esp
  8017d5:	68 b0 2a 80 00       	push   $0x802ab0
  8017da:	6a 2a                	push   $0x2a
  8017dc:	68 a4 2a 80 00       	push   $0x802aa4
  8017e1:	e8 73 ed ff ff       	call   800559 <_panic>
}
  8017e6:	90                   	nop
  8017e7:	c9                   	leave  
  8017e8:	c3                   	ret    

008017e9 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  8017e9:	55                   	push   %ebp
  8017ea:	89 e5                	mov    %esp,%ebp
  8017ec:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8017ef:	e8 18 ff ff ff       	call   80170c <uheap_init>
	if (size == 0) return NULL ;
  8017f4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8017f8:	75 07                	jne    801801 <malloc+0x18>
  8017fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8017ff:	eb 14                	jmp    801815 <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  801801:	83 ec 04             	sub    $0x4,%esp
  801804:	68 f0 2a 80 00       	push   $0x802af0
  801809:	6a 3e                	push   $0x3e
  80180b:	68 a4 2a 80 00       	push   $0x802aa4
  801810:	e8 44 ed ff ff       	call   800559 <_panic>
}
  801815:	c9                   	leave  
  801816:	c3                   	ret    

00801817 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801817:	55                   	push   %ebp
  801818:	89 e5                	mov    %esp,%ebp
  80181a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  80181d:	83 ec 04             	sub    $0x4,%esp
  801820:	68 18 2b 80 00       	push   $0x802b18
  801825:	6a 49                	push   $0x49
  801827:	68 a4 2a 80 00       	push   $0x802aa4
  80182c:	e8 28 ed ff ff       	call   800559 <_panic>

00801831 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801831:	55                   	push   %ebp
  801832:	89 e5                	mov    %esp,%ebp
  801834:	83 ec 18             	sub    $0x18,%esp
  801837:	8b 45 10             	mov    0x10(%ebp),%eax
  80183a:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80183d:	e8 ca fe ff ff       	call   80170c <uheap_init>
	if (size == 0) return NULL ;
  801842:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801846:	75 07                	jne    80184f <smalloc+0x1e>
  801848:	b8 00 00 00 00       	mov    $0x0,%eax
  80184d:	eb 14                	jmp    801863 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  80184f:	83 ec 04             	sub    $0x4,%esp
  801852:	68 3c 2b 80 00       	push   $0x802b3c
  801857:	6a 5a                	push   $0x5a
  801859:	68 a4 2a 80 00       	push   $0x802aa4
  80185e:	e8 f6 ec ff ff       	call   800559 <_panic>
}
  801863:	c9                   	leave  
  801864:	c3                   	ret    

00801865 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801865:	55                   	push   %ebp
  801866:	89 e5                	mov    %esp,%ebp
  801868:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80186b:	e8 9c fe ff ff       	call   80170c <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  801870:	83 ec 04             	sub    $0x4,%esp
  801873:	68 64 2b 80 00       	push   $0x802b64
  801878:	6a 6a                	push   $0x6a
  80187a:	68 a4 2a 80 00       	push   $0x802aa4
  80187f:	e8 d5 ec ff ff       	call   800559 <_panic>

00801884 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801884:	55                   	push   %ebp
  801885:	89 e5                	mov    %esp,%ebp
  801887:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80188a:	e8 7d fe ff ff       	call   80170c <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  80188f:	83 ec 04             	sub    $0x4,%esp
  801892:	68 88 2b 80 00       	push   $0x802b88
  801897:	68 88 00 00 00       	push   $0x88
  80189c:	68 a4 2a 80 00       	push   $0x802aa4
  8018a1:	e8 b3 ec ff ff       	call   800559 <_panic>

008018a6 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  8018a6:	55                   	push   %ebp
  8018a7:	89 e5                	mov    %esp,%ebp
  8018a9:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  8018ac:	83 ec 04             	sub    $0x4,%esp
  8018af:	68 b0 2b 80 00       	push   $0x802bb0
  8018b4:	68 9b 00 00 00       	push   $0x9b
  8018b9:	68 a4 2a 80 00       	push   $0x802aa4
  8018be:	e8 96 ec ff ff       	call   800559 <_panic>

008018c3 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8018c3:	55                   	push   %ebp
  8018c4:	89 e5                	mov    %esp,%ebp
  8018c6:	57                   	push   %edi
  8018c7:	56                   	push   %esi
  8018c8:	53                   	push   %ebx
  8018c9:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018d5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018d8:	8b 7d 18             	mov    0x18(%ebp),%edi
  8018db:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8018de:	cd 30                	int    $0x30
  8018e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8018e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018e6:	83 c4 10             	add    $0x10,%esp
  8018e9:	5b                   	pop    %ebx
  8018ea:	5e                   	pop    %esi
  8018eb:	5f                   	pop    %edi
  8018ec:	5d                   	pop    %ebp
  8018ed:	c3                   	ret    

008018ee <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8018ee:	55                   	push   %ebp
  8018ef:	89 e5                	mov    %esp,%ebp
  8018f1:	83 ec 04             	sub    $0x4,%esp
  8018f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8018f7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8018fa:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8018fd:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801901:	8b 45 08             	mov    0x8(%ebp),%eax
  801904:	6a 00                	push   $0x0
  801906:	51                   	push   %ecx
  801907:	52                   	push   %edx
  801908:	ff 75 0c             	pushl  0xc(%ebp)
  80190b:	50                   	push   %eax
  80190c:	6a 00                	push   $0x0
  80190e:	e8 b0 ff ff ff       	call   8018c3 <syscall>
  801913:	83 c4 18             	add    $0x18,%esp
}
  801916:	90                   	nop
  801917:	c9                   	leave  
  801918:	c3                   	ret    

00801919 <sys_cgetc>:

int
sys_cgetc(void)
{
  801919:	55                   	push   %ebp
  80191a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80191c:	6a 00                	push   $0x0
  80191e:	6a 00                	push   $0x0
  801920:	6a 00                	push   $0x0
  801922:	6a 00                	push   $0x0
  801924:	6a 00                	push   $0x0
  801926:	6a 02                	push   $0x2
  801928:	e8 96 ff ff ff       	call   8018c3 <syscall>
  80192d:	83 c4 18             	add    $0x18,%esp
}
  801930:	c9                   	leave  
  801931:	c3                   	ret    

00801932 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801932:	55                   	push   %ebp
  801933:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801935:	6a 00                	push   $0x0
  801937:	6a 00                	push   $0x0
  801939:	6a 00                	push   $0x0
  80193b:	6a 00                	push   $0x0
  80193d:	6a 00                	push   $0x0
  80193f:	6a 03                	push   $0x3
  801941:	e8 7d ff ff ff       	call   8018c3 <syscall>
  801946:	83 c4 18             	add    $0x18,%esp
}
  801949:	90                   	nop
  80194a:	c9                   	leave  
  80194b:	c3                   	ret    

0080194c <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80194c:	55                   	push   %ebp
  80194d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80194f:	6a 00                	push   $0x0
  801951:	6a 00                	push   $0x0
  801953:	6a 00                	push   $0x0
  801955:	6a 00                	push   $0x0
  801957:	6a 00                	push   $0x0
  801959:	6a 04                	push   $0x4
  80195b:	e8 63 ff ff ff       	call   8018c3 <syscall>
  801960:	83 c4 18             	add    $0x18,%esp
}
  801963:	90                   	nop
  801964:	c9                   	leave  
  801965:	c3                   	ret    

00801966 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801966:	55                   	push   %ebp
  801967:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801969:	8b 55 0c             	mov    0xc(%ebp),%edx
  80196c:	8b 45 08             	mov    0x8(%ebp),%eax
  80196f:	6a 00                	push   $0x0
  801971:	6a 00                	push   $0x0
  801973:	6a 00                	push   $0x0
  801975:	52                   	push   %edx
  801976:	50                   	push   %eax
  801977:	6a 08                	push   $0x8
  801979:	e8 45 ff ff ff       	call   8018c3 <syscall>
  80197e:	83 c4 18             	add    $0x18,%esp
}
  801981:	c9                   	leave  
  801982:	c3                   	ret    

00801983 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801983:	55                   	push   %ebp
  801984:	89 e5                	mov    %esp,%ebp
  801986:	56                   	push   %esi
  801987:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801988:	8b 75 18             	mov    0x18(%ebp),%esi
  80198b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80198e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801991:	8b 55 0c             	mov    0xc(%ebp),%edx
  801994:	8b 45 08             	mov    0x8(%ebp),%eax
  801997:	56                   	push   %esi
  801998:	53                   	push   %ebx
  801999:	51                   	push   %ecx
  80199a:	52                   	push   %edx
  80199b:	50                   	push   %eax
  80199c:	6a 09                	push   $0x9
  80199e:	e8 20 ff ff ff       	call   8018c3 <syscall>
  8019a3:	83 c4 18             	add    $0x18,%esp
}
  8019a6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019a9:	5b                   	pop    %ebx
  8019aa:	5e                   	pop    %esi
  8019ab:	5d                   	pop    %ebp
  8019ac:	c3                   	ret    

008019ad <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8019ad:	55                   	push   %ebp
  8019ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8019b0:	6a 00                	push   $0x0
  8019b2:	6a 00                	push   $0x0
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 00                	push   $0x0
  8019b8:	ff 75 08             	pushl  0x8(%ebp)
  8019bb:	6a 0a                	push   $0xa
  8019bd:	e8 01 ff ff ff       	call   8018c3 <syscall>
  8019c2:	83 c4 18             	add    $0x18,%esp
}
  8019c5:	c9                   	leave  
  8019c6:	c3                   	ret    

008019c7 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8019c7:	55                   	push   %ebp
  8019c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	ff 75 0c             	pushl  0xc(%ebp)
  8019d3:	ff 75 08             	pushl  0x8(%ebp)
  8019d6:	6a 0b                	push   $0xb
  8019d8:	e8 e6 fe ff ff       	call   8018c3 <syscall>
  8019dd:	83 c4 18             	add    $0x18,%esp
}
  8019e0:	c9                   	leave  
  8019e1:	c3                   	ret    

008019e2 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8019e2:	55                   	push   %ebp
  8019e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 0c                	push   $0xc
  8019f1:	e8 cd fe ff ff       	call   8018c3 <syscall>
  8019f6:	83 c4 18             	add    $0x18,%esp
}
  8019f9:	c9                   	leave  
  8019fa:	c3                   	ret    

008019fb <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8019fb:	55                   	push   %ebp
  8019fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8019fe:	6a 00                	push   $0x0
  801a00:	6a 00                	push   $0x0
  801a02:	6a 00                	push   $0x0
  801a04:	6a 00                	push   $0x0
  801a06:	6a 00                	push   $0x0
  801a08:	6a 0d                	push   $0xd
  801a0a:	e8 b4 fe ff ff       	call   8018c3 <syscall>
  801a0f:	83 c4 18             	add    $0x18,%esp
}
  801a12:	c9                   	leave  
  801a13:	c3                   	ret    

00801a14 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a14:	55                   	push   %ebp
  801a15:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 0e                	push   $0xe
  801a23:	e8 9b fe ff ff       	call   8018c3 <syscall>
  801a28:	83 c4 18             	add    $0x18,%esp
}
  801a2b:	c9                   	leave  
  801a2c:	c3                   	ret    

00801a2d <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a2d:	55                   	push   %ebp
  801a2e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a30:	6a 00                	push   $0x0
  801a32:	6a 00                	push   $0x0
  801a34:	6a 00                	push   $0x0
  801a36:	6a 00                	push   $0x0
  801a38:	6a 00                	push   $0x0
  801a3a:	6a 0f                	push   $0xf
  801a3c:	e8 82 fe ff ff       	call   8018c3 <syscall>
  801a41:	83 c4 18             	add    $0x18,%esp
}
  801a44:	c9                   	leave  
  801a45:	c3                   	ret    

00801a46 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a46:	55                   	push   %ebp
  801a47:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a49:	6a 00                	push   $0x0
  801a4b:	6a 00                	push   $0x0
  801a4d:	6a 00                	push   $0x0
  801a4f:	6a 00                	push   $0x0
  801a51:	ff 75 08             	pushl  0x8(%ebp)
  801a54:	6a 10                	push   $0x10
  801a56:	e8 68 fe ff ff       	call   8018c3 <syscall>
  801a5b:	83 c4 18             	add    $0x18,%esp
}
  801a5e:	c9                   	leave  
  801a5f:	c3                   	ret    

00801a60 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a60:	55                   	push   %ebp
  801a61:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a63:	6a 00                	push   $0x0
  801a65:	6a 00                	push   $0x0
  801a67:	6a 00                	push   $0x0
  801a69:	6a 00                	push   $0x0
  801a6b:	6a 00                	push   $0x0
  801a6d:	6a 11                	push   $0x11
  801a6f:	e8 4f fe ff ff       	call   8018c3 <syscall>
  801a74:	83 c4 18             	add    $0x18,%esp
}
  801a77:	90                   	nop
  801a78:	c9                   	leave  
  801a79:	c3                   	ret    

00801a7a <sys_cputc>:

void
sys_cputc(const char c)
{
  801a7a:	55                   	push   %ebp
  801a7b:	89 e5                	mov    %esp,%ebp
  801a7d:	83 ec 04             	sub    $0x4,%esp
  801a80:	8b 45 08             	mov    0x8(%ebp),%eax
  801a83:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a86:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 00                	push   $0x0
  801a92:	50                   	push   %eax
  801a93:	6a 01                	push   $0x1
  801a95:	e8 29 fe ff ff       	call   8018c3 <syscall>
  801a9a:	83 c4 18             	add    $0x18,%esp
}
  801a9d:	90                   	nop
  801a9e:	c9                   	leave  
  801a9f:	c3                   	ret    

00801aa0 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801aa0:	55                   	push   %ebp
  801aa1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801aa3:	6a 00                	push   $0x0
  801aa5:	6a 00                	push   $0x0
  801aa7:	6a 00                	push   $0x0
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 00                	push   $0x0
  801aad:	6a 14                	push   $0x14
  801aaf:	e8 0f fe ff ff       	call   8018c3 <syscall>
  801ab4:	83 c4 18             	add    $0x18,%esp
}
  801ab7:	90                   	nop
  801ab8:	c9                   	leave  
  801ab9:	c3                   	ret    

00801aba <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801aba:	55                   	push   %ebp
  801abb:	89 e5                	mov    %esp,%ebp
  801abd:	83 ec 04             	sub    $0x4,%esp
  801ac0:	8b 45 10             	mov    0x10(%ebp),%eax
  801ac3:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801ac6:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ac9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801acd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad0:	6a 00                	push   $0x0
  801ad2:	51                   	push   %ecx
  801ad3:	52                   	push   %edx
  801ad4:	ff 75 0c             	pushl  0xc(%ebp)
  801ad7:	50                   	push   %eax
  801ad8:	6a 15                	push   $0x15
  801ada:	e8 e4 fd ff ff       	call   8018c3 <syscall>
  801adf:	83 c4 18             	add    $0x18,%esp
}
  801ae2:	c9                   	leave  
  801ae3:	c3                   	ret    

00801ae4 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801ae4:	55                   	push   %ebp
  801ae5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801ae7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aea:	8b 45 08             	mov    0x8(%ebp),%eax
  801aed:	6a 00                	push   $0x0
  801aef:	6a 00                	push   $0x0
  801af1:	6a 00                	push   $0x0
  801af3:	52                   	push   %edx
  801af4:	50                   	push   %eax
  801af5:	6a 16                	push   $0x16
  801af7:	e8 c7 fd ff ff       	call   8018c3 <syscall>
  801afc:	83 c4 18             	add    $0x18,%esp
}
  801aff:	c9                   	leave  
  801b00:	c3                   	ret    

00801b01 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801b01:	55                   	push   %ebp
  801b02:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b04:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b07:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 00                	push   $0x0
  801b11:	51                   	push   %ecx
  801b12:	52                   	push   %edx
  801b13:	50                   	push   %eax
  801b14:	6a 17                	push   $0x17
  801b16:	e8 a8 fd ff ff       	call   8018c3 <syscall>
  801b1b:	83 c4 18             	add    $0x18,%esp
}
  801b1e:	c9                   	leave  
  801b1f:	c3                   	ret    

00801b20 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801b20:	55                   	push   %ebp
  801b21:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b23:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b26:	8b 45 08             	mov    0x8(%ebp),%eax
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 00                	push   $0x0
  801b2f:	52                   	push   %edx
  801b30:	50                   	push   %eax
  801b31:	6a 18                	push   $0x18
  801b33:	e8 8b fd ff ff       	call   8018c3 <syscall>
  801b38:	83 c4 18             	add    $0x18,%esp
}
  801b3b:	c9                   	leave  
  801b3c:	c3                   	ret    

00801b3d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b3d:	55                   	push   %ebp
  801b3e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b40:	8b 45 08             	mov    0x8(%ebp),%eax
  801b43:	6a 00                	push   $0x0
  801b45:	ff 75 14             	pushl  0x14(%ebp)
  801b48:	ff 75 10             	pushl  0x10(%ebp)
  801b4b:	ff 75 0c             	pushl  0xc(%ebp)
  801b4e:	50                   	push   %eax
  801b4f:	6a 19                	push   $0x19
  801b51:	e8 6d fd ff ff       	call   8018c3 <syscall>
  801b56:	83 c4 18             	add    $0x18,%esp
}
  801b59:	c9                   	leave  
  801b5a:	c3                   	ret    

00801b5b <sys_run_env>:

void sys_run_env(int32 envId)
{
  801b5b:	55                   	push   %ebp
  801b5c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b61:	6a 00                	push   $0x0
  801b63:	6a 00                	push   $0x0
  801b65:	6a 00                	push   $0x0
  801b67:	6a 00                	push   $0x0
  801b69:	50                   	push   %eax
  801b6a:	6a 1a                	push   $0x1a
  801b6c:	e8 52 fd ff ff       	call   8018c3 <syscall>
  801b71:	83 c4 18             	add    $0x18,%esp
}
  801b74:	90                   	nop
  801b75:	c9                   	leave  
  801b76:	c3                   	ret    

00801b77 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b77:	55                   	push   %ebp
  801b78:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 00                	push   $0x0
  801b83:	6a 00                	push   $0x0
  801b85:	50                   	push   %eax
  801b86:	6a 1b                	push   $0x1b
  801b88:	e8 36 fd ff ff       	call   8018c3 <syscall>
  801b8d:	83 c4 18             	add    $0x18,%esp
}
  801b90:	c9                   	leave  
  801b91:	c3                   	ret    

00801b92 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b92:	55                   	push   %ebp
  801b93:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b95:	6a 00                	push   $0x0
  801b97:	6a 00                	push   $0x0
  801b99:	6a 00                	push   $0x0
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 00                	push   $0x0
  801b9f:	6a 05                	push   $0x5
  801ba1:	e8 1d fd ff ff       	call   8018c3 <syscall>
  801ba6:	83 c4 18             	add    $0x18,%esp
}
  801ba9:	c9                   	leave  
  801baa:	c3                   	ret    

00801bab <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801bab:	55                   	push   %ebp
  801bac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 00                	push   $0x0
  801bb4:	6a 00                	push   $0x0
  801bb6:	6a 00                	push   $0x0
  801bb8:	6a 06                	push   $0x6
  801bba:	e8 04 fd ff ff       	call   8018c3 <syscall>
  801bbf:	83 c4 18             	add    $0x18,%esp
}
  801bc2:	c9                   	leave  
  801bc3:	c3                   	ret    

00801bc4 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801bc4:	55                   	push   %ebp
  801bc5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 00                	push   $0x0
  801bcb:	6a 00                	push   $0x0
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 00                	push   $0x0
  801bd1:	6a 07                	push   $0x7
  801bd3:	e8 eb fc ff ff       	call   8018c3 <syscall>
  801bd8:	83 c4 18             	add    $0x18,%esp
}
  801bdb:	c9                   	leave  
  801bdc:	c3                   	ret    

00801bdd <sys_exit_env>:


void sys_exit_env(void)
{
  801bdd:	55                   	push   %ebp
  801bde:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801be0:	6a 00                	push   $0x0
  801be2:	6a 00                	push   $0x0
  801be4:	6a 00                	push   $0x0
  801be6:	6a 00                	push   $0x0
  801be8:	6a 00                	push   $0x0
  801bea:	6a 1c                	push   $0x1c
  801bec:	e8 d2 fc ff ff       	call   8018c3 <syscall>
  801bf1:	83 c4 18             	add    $0x18,%esp
}
  801bf4:	90                   	nop
  801bf5:	c9                   	leave  
  801bf6:	c3                   	ret    

00801bf7 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801bf7:	55                   	push   %ebp
  801bf8:	89 e5                	mov    %esp,%ebp
  801bfa:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801bfd:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c00:	8d 50 04             	lea    0x4(%eax),%edx
  801c03:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c06:	6a 00                	push   $0x0
  801c08:	6a 00                	push   $0x0
  801c0a:	6a 00                	push   $0x0
  801c0c:	52                   	push   %edx
  801c0d:	50                   	push   %eax
  801c0e:	6a 1d                	push   $0x1d
  801c10:	e8 ae fc ff ff       	call   8018c3 <syscall>
  801c15:	83 c4 18             	add    $0x18,%esp
	return result;
  801c18:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c1b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c1e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c21:	89 01                	mov    %eax,(%ecx)
  801c23:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c26:	8b 45 08             	mov    0x8(%ebp),%eax
  801c29:	c9                   	leave  
  801c2a:	c2 04 00             	ret    $0x4

00801c2d <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c2d:	55                   	push   %ebp
  801c2e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c30:	6a 00                	push   $0x0
  801c32:	6a 00                	push   $0x0
  801c34:	ff 75 10             	pushl  0x10(%ebp)
  801c37:	ff 75 0c             	pushl  0xc(%ebp)
  801c3a:	ff 75 08             	pushl  0x8(%ebp)
  801c3d:	6a 13                	push   $0x13
  801c3f:	e8 7f fc ff ff       	call   8018c3 <syscall>
  801c44:	83 c4 18             	add    $0x18,%esp
	return ;
  801c47:	90                   	nop
}
  801c48:	c9                   	leave  
  801c49:	c3                   	ret    

00801c4a <sys_rcr2>:
uint32 sys_rcr2()
{
  801c4a:	55                   	push   %ebp
  801c4b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c4d:	6a 00                	push   $0x0
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	6a 00                	push   $0x0
  801c57:	6a 1e                	push   $0x1e
  801c59:	e8 65 fc ff ff       	call   8018c3 <syscall>
  801c5e:	83 c4 18             	add    $0x18,%esp
}
  801c61:	c9                   	leave  
  801c62:	c3                   	ret    

00801c63 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801c63:	55                   	push   %ebp
  801c64:	89 e5                	mov    %esp,%ebp
  801c66:	83 ec 04             	sub    $0x4,%esp
  801c69:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c6f:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c73:	6a 00                	push   $0x0
  801c75:	6a 00                	push   $0x0
  801c77:	6a 00                	push   $0x0
  801c79:	6a 00                	push   $0x0
  801c7b:	50                   	push   %eax
  801c7c:	6a 1f                	push   $0x1f
  801c7e:	e8 40 fc ff ff       	call   8018c3 <syscall>
  801c83:	83 c4 18             	add    $0x18,%esp
	return ;
  801c86:	90                   	nop
}
  801c87:	c9                   	leave  
  801c88:	c3                   	ret    

00801c89 <rsttst>:
void rsttst()
{
  801c89:	55                   	push   %ebp
  801c8a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 00                	push   $0x0
  801c92:	6a 00                	push   $0x0
  801c94:	6a 00                	push   $0x0
  801c96:	6a 21                	push   $0x21
  801c98:	e8 26 fc ff ff       	call   8018c3 <syscall>
  801c9d:	83 c4 18             	add    $0x18,%esp
	return ;
  801ca0:	90                   	nop
}
  801ca1:	c9                   	leave  
  801ca2:	c3                   	ret    

00801ca3 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ca3:	55                   	push   %ebp
  801ca4:	89 e5                	mov    %esp,%ebp
  801ca6:	83 ec 04             	sub    $0x4,%esp
  801ca9:	8b 45 14             	mov    0x14(%ebp),%eax
  801cac:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801caf:	8b 55 18             	mov    0x18(%ebp),%edx
  801cb2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cb6:	52                   	push   %edx
  801cb7:	50                   	push   %eax
  801cb8:	ff 75 10             	pushl  0x10(%ebp)
  801cbb:	ff 75 0c             	pushl  0xc(%ebp)
  801cbe:	ff 75 08             	pushl  0x8(%ebp)
  801cc1:	6a 20                	push   $0x20
  801cc3:	e8 fb fb ff ff       	call   8018c3 <syscall>
  801cc8:	83 c4 18             	add    $0x18,%esp
	return ;
  801ccb:	90                   	nop
}
  801ccc:	c9                   	leave  
  801ccd:	c3                   	ret    

00801cce <chktst>:
void chktst(uint32 n)
{
  801cce:	55                   	push   %ebp
  801ccf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801cd1:	6a 00                	push   $0x0
  801cd3:	6a 00                	push   $0x0
  801cd5:	6a 00                	push   $0x0
  801cd7:	6a 00                	push   $0x0
  801cd9:	ff 75 08             	pushl  0x8(%ebp)
  801cdc:	6a 22                	push   $0x22
  801cde:	e8 e0 fb ff ff       	call   8018c3 <syscall>
  801ce3:	83 c4 18             	add    $0x18,%esp
	return ;
  801ce6:	90                   	nop
}
  801ce7:	c9                   	leave  
  801ce8:	c3                   	ret    

00801ce9 <inctst>:

void inctst()
{
  801ce9:	55                   	push   %ebp
  801cea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801cec:	6a 00                	push   $0x0
  801cee:	6a 00                	push   $0x0
  801cf0:	6a 00                	push   $0x0
  801cf2:	6a 00                	push   $0x0
  801cf4:	6a 00                	push   $0x0
  801cf6:	6a 23                	push   $0x23
  801cf8:	e8 c6 fb ff ff       	call   8018c3 <syscall>
  801cfd:	83 c4 18             	add    $0x18,%esp
	return ;
  801d00:	90                   	nop
}
  801d01:	c9                   	leave  
  801d02:	c3                   	ret    

00801d03 <gettst>:
uint32 gettst()
{
  801d03:	55                   	push   %ebp
  801d04:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d06:	6a 00                	push   $0x0
  801d08:	6a 00                	push   $0x0
  801d0a:	6a 00                	push   $0x0
  801d0c:	6a 00                	push   $0x0
  801d0e:	6a 00                	push   $0x0
  801d10:	6a 24                	push   $0x24
  801d12:	e8 ac fb ff ff       	call   8018c3 <syscall>
  801d17:	83 c4 18             	add    $0x18,%esp
}
  801d1a:	c9                   	leave  
  801d1b:	c3                   	ret    

00801d1c <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801d1c:	55                   	push   %ebp
  801d1d:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 00                	push   $0x0
  801d23:	6a 00                	push   $0x0
  801d25:	6a 00                	push   $0x0
  801d27:	6a 00                	push   $0x0
  801d29:	6a 25                	push   $0x25
  801d2b:	e8 93 fb ff ff       	call   8018c3 <syscall>
  801d30:	83 c4 18             	add    $0x18,%esp
  801d33:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801d38:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801d3d:	c9                   	leave  
  801d3e:	c3                   	ret    

00801d3f <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801d3f:	55                   	push   %ebp
  801d40:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801d42:	8b 45 08             	mov    0x8(%ebp),%eax
  801d45:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 00                	push   $0x0
  801d4e:	6a 00                	push   $0x0
  801d50:	6a 00                	push   $0x0
  801d52:	ff 75 08             	pushl  0x8(%ebp)
  801d55:	6a 26                	push   $0x26
  801d57:	e8 67 fb ff ff       	call   8018c3 <syscall>
  801d5c:	83 c4 18             	add    $0x18,%esp
	return ;
  801d5f:	90                   	nop
}
  801d60:	c9                   	leave  
  801d61:	c3                   	ret    

00801d62 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801d62:	55                   	push   %ebp
  801d63:	89 e5                	mov    %esp,%ebp
  801d65:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801d66:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d69:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d72:	6a 00                	push   $0x0
  801d74:	53                   	push   %ebx
  801d75:	51                   	push   %ecx
  801d76:	52                   	push   %edx
  801d77:	50                   	push   %eax
  801d78:	6a 27                	push   $0x27
  801d7a:	e8 44 fb ff ff       	call   8018c3 <syscall>
  801d7f:	83 c4 18             	add    $0x18,%esp
}
  801d82:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d85:	c9                   	leave  
  801d86:	c3                   	ret    

00801d87 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801d87:	55                   	push   %ebp
  801d88:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801d8a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d90:	6a 00                	push   $0x0
  801d92:	6a 00                	push   $0x0
  801d94:	6a 00                	push   $0x0
  801d96:	52                   	push   %edx
  801d97:	50                   	push   %eax
  801d98:	6a 28                	push   $0x28
  801d9a:	e8 24 fb ff ff       	call   8018c3 <syscall>
  801d9f:	83 c4 18             	add    $0x18,%esp
}
  801da2:	c9                   	leave  
  801da3:	c3                   	ret    

00801da4 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801da4:	55                   	push   %ebp
  801da5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801da7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801daa:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dad:	8b 45 08             	mov    0x8(%ebp),%eax
  801db0:	6a 00                	push   $0x0
  801db2:	51                   	push   %ecx
  801db3:	ff 75 10             	pushl  0x10(%ebp)
  801db6:	52                   	push   %edx
  801db7:	50                   	push   %eax
  801db8:	6a 29                	push   $0x29
  801dba:	e8 04 fb ff ff       	call   8018c3 <syscall>
  801dbf:	83 c4 18             	add    $0x18,%esp
}
  801dc2:	c9                   	leave  
  801dc3:	c3                   	ret    

00801dc4 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801dc4:	55                   	push   %ebp
  801dc5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801dc7:	6a 00                	push   $0x0
  801dc9:	6a 00                	push   $0x0
  801dcb:	ff 75 10             	pushl  0x10(%ebp)
  801dce:	ff 75 0c             	pushl  0xc(%ebp)
  801dd1:	ff 75 08             	pushl  0x8(%ebp)
  801dd4:	6a 12                	push   $0x12
  801dd6:	e8 e8 fa ff ff       	call   8018c3 <syscall>
  801ddb:	83 c4 18             	add    $0x18,%esp
	return ;
  801dde:	90                   	nop
}
  801ddf:	c9                   	leave  
  801de0:	c3                   	ret    

00801de1 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801de1:	55                   	push   %ebp
  801de2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801de4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801de7:	8b 45 08             	mov    0x8(%ebp),%eax
  801dea:	6a 00                	push   $0x0
  801dec:	6a 00                	push   $0x0
  801dee:	6a 00                	push   $0x0
  801df0:	52                   	push   %edx
  801df1:	50                   	push   %eax
  801df2:	6a 2a                	push   $0x2a
  801df4:	e8 ca fa ff ff       	call   8018c3 <syscall>
  801df9:	83 c4 18             	add    $0x18,%esp
	return;
  801dfc:	90                   	nop
}
  801dfd:	c9                   	leave  
  801dfe:	c3                   	ret    

00801dff <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801dff:	55                   	push   %ebp
  801e00:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801e02:	6a 00                	push   $0x0
  801e04:	6a 00                	push   $0x0
  801e06:	6a 00                	push   $0x0
  801e08:	6a 00                	push   $0x0
  801e0a:	6a 00                	push   $0x0
  801e0c:	6a 2b                	push   $0x2b
  801e0e:	e8 b0 fa ff ff       	call   8018c3 <syscall>
  801e13:	83 c4 18             	add    $0x18,%esp
}
  801e16:	c9                   	leave  
  801e17:	c3                   	ret    

00801e18 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801e18:	55                   	push   %ebp
  801e19:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801e1b:	6a 00                	push   $0x0
  801e1d:	6a 00                	push   $0x0
  801e1f:	6a 00                	push   $0x0
  801e21:	ff 75 0c             	pushl  0xc(%ebp)
  801e24:	ff 75 08             	pushl  0x8(%ebp)
  801e27:	6a 2d                	push   $0x2d
  801e29:	e8 95 fa ff ff       	call   8018c3 <syscall>
  801e2e:	83 c4 18             	add    $0x18,%esp
	return;
  801e31:	90                   	nop
}
  801e32:	c9                   	leave  
  801e33:	c3                   	ret    

00801e34 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801e34:	55                   	push   %ebp
  801e35:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801e37:	6a 00                	push   $0x0
  801e39:	6a 00                	push   $0x0
  801e3b:	6a 00                	push   $0x0
  801e3d:	ff 75 0c             	pushl  0xc(%ebp)
  801e40:	ff 75 08             	pushl  0x8(%ebp)
  801e43:	6a 2c                	push   $0x2c
  801e45:	e8 79 fa ff ff       	call   8018c3 <syscall>
  801e4a:	83 c4 18             	add    $0x18,%esp
	return ;
  801e4d:	90                   	nop
}
  801e4e:	c9                   	leave  
  801e4f:	c3                   	ret    

00801e50 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801e50:	55                   	push   %ebp
  801e51:	89 e5                	mov    %esp,%ebp
  801e53:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801e56:	83 ec 04             	sub    $0x4,%esp
  801e59:	68 d4 2b 80 00       	push   $0x802bd4
  801e5e:	68 25 01 00 00       	push   $0x125
  801e63:	68 07 2c 80 00       	push   $0x802c07
  801e68:	e8 ec e6 ff ff       	call   800559 <_panic>

00801e6d <to_page_va>:
//==================================================================================//
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  801e6d:	55                   	push   %ebp
  801e6e:	89 e5                	mov    %esp,%ebp
  801e70:	83 ec 10             	sub    $0x10,%esp
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  801e73:	8b 45 08             	mov    0x8(%ebp),%eax
  801e76:	ba 60 30 80 00       	mov    $0x803060,%edx
  801e7b:	29 d0                	sub    %edx,%eax
  801e7d:	c1 f8 02             	sar    $0x2,%eax
  801e80:	89 c2                	mov    %eax,%edx
  801e82:	89 d0                	mov    %edx,%eax
  801e84:	c1 e0 02             	shl    $0x2,%eax
  801e87:	01 d0                	add    %edx,%eax
  801e89:	c1 e0 02             	shl    $0x2,%eax
  801e8c:	01 d0                	add    %edx,%eax
  801e8e:	c1 e0 02             	shl    $0x2,%eax
  801e91:	01 d0                	add    %edx,%eax
  801e93:	89 c1                	mov    %eax,%ecx
  801e95:	c1 e1 08             	shl    $0x8,%ecx
  801e98:	01 c8                	add    %ecx,%eax
  801e9a:	89 c1                	mov    %eax,%ecx
  801e9c:	c1 e1 10             	shl    $0x10,%ecx
  801e9f:	01 c8                	add    %ecx,%eax
  801ea1:	01 c0                	add    %eax,%eax
  801ea3:	01 d0                	add    %edx,%eax
  801ea5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  801ea8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801eab:	c1 e0 0c             	shl    $0xc,%eax
  801eae:	89 c2                	mov    %eax,%edx
  801eb0:	a1 64 b0 81 00       	mov    0x81b064,%eax
  801eb5:	01 d0                	add    %edx,%eax
}
  801eb7:	c9                   	leave  
  801eb8:	c3                   	ret    

00801eb9 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  801eb9:	55                   	push   %ebp
  801eba:	89 e5                	mov    %esp,%ebp
  801ebc:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  801ebf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec2:	05 00 00 00 02       	add    $0x2000000,%eax
  801ec7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801eca:	73 16                	jae    801ee2 <initialize_dynamic_allocator+0x29>
  801ecc:	68 18 2c 80 00       	push   $0x802c18
  801ed1:	68 3e 2c 80 00       	push   $0x802c3e
  801ed6:	6a 26                	push   $0x26
  801ed8:	68 53 2c 80 00       	push   $0x802c53
  801edd:	e8 77 e6 ff ff       	call   800559 <_panic>
		is_initialized = 1;
  801ee2:	c7 05 24 30 80 00 01 	movl   $0x1,0x803024
  801ee9:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	//Comment the following line
	panic("initialize_dynamic_allocator() Not implemented yet");
  801eec:	83 ec 04             	sub    $0x4,%esp
  801eef:	68 6c 2c 80 00       	push   $0x802c6c
  801ef4:	6a 2e                	push   $0x2e
  801ef6:	68 53 2c 80 00       	push   $0x802c53
  801efb:	e8 59 e6 ff ff       	call   800559 <_panic>

00801f00 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  801f00:	55                   	push   %ebp
  801f01:	89 e5                	mov    %esp,%ebp
  801f03:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	//Comment the following line
	panic("get_block_size() Not implemented yet");
  801f06:	83 ec 04             	sub    $0x4,%esp
  801f09:	68 a0 2c 80 00       	push   $0x802ca0
  801f0e:	6a 3a                	push   $0x3a
  801f10:	68 53 2c 80 00       	push   $0x802c53
  801f15:	e8 3f e6 ff ff       	call   800559 <_panic>

00801f1a <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  801f1a:	55                   	push   %ebp
  801f1b:	89 e5                	mov    %esp,%ebp
  801f1d:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  801f20:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801f27:	76 16                	jbe    801f3f <alloc_block+0x25>
  801f29:	68 c8 2c 80 00       	push   $0x802cc8
  801f2e:	68 3e 2c 80 00       	push   $0x802c3e
  801f33:	6a 46                	push   $0x46
  801f35:	68 53 2c 80 00       	push   $0x802c53
  801f3a:	e8 1a e6 ff ff       	call   800559 <_panic>
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	panic("alloc_block() Not implemented yet");
  801f3f:	83 ec 04             	sub    $0x4,%esp
  801f42:	68 ec 2c 80 00       	push   $0x802cec
  801f47:	6a 4d                	push   $0x4d
  801f49:	68 53 2c 80 00       	push   $0x802c53
  801f4e:	e8 06 e6 ff ff       	call   800559 <_panic>

00801f53 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  801f53:	55                   	push   %ebp
  801f54:	89 e5                	mov    %esp,%ebp
  801f56:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  801f59:	8b 55 08             	mov    0x8(%ebp),%edx
  801f5c:	a1 64 b0 81 00       	mov    0x81b064,%eax
  801f61:	39 c2                	cmp    %eax,%edx
  801f63:	72 0c                	jb     801f71 <free_block+0x1e>
  801f65:	8b 55 08             	mov    0x8(%ebp),%edx
  801f68:	a1 40 30 80 00       	mov    0x803040,%eax
  801f6d:	39 c2                	cmp    %eax,%edx
  801f6f:	72 16                	jb     801f87 <free_block+0x34>
  801f71:	68 10 2d 80 00       	push   $0x802d10
  801f76:	68 3e 2c 80 00       	push   $0x802c3e
  801f7b:	6a 5b                	push   $0x5b
  801f7d:	68 53 2c 80 00       	push   $0x802c53
  801f82:	e8 d2 e5 ff ff       	call   800559 <_panic>
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	panic("free_block() Not implemented yet");
  801f87:	83 ec 04             	sub    $0x4,%esp
  801f8a:	68 48 2d 80 00       	push   $0x802d48
  801f8f:	6a 63                	push   $0x63
  801f91:	68 53 2c 80 00       	push   $0x802c53
  801f96:	e8 be e5 ff ff       	call   800559 <_panic>

00801f9b <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  801f9b:	55                   	push   %ebp
  801f9c:	89 e5                	mov    %esp,%ebp
  801f9e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  801fa1:	83 ec 04             	sub    $0x4,%esp
  801fa4:	68 6c 2d 80 00       	push   $0x802d6c
  801fa9:	6a 72                	push   $0x72
  801fab:	68 53 2c 80 00       	push   $0x802c53
  801fb0:	e8 a4 e5 ff ff       	call   800559 <_panic>
  801fb5:	66 90                	xchg   %ax,%ax
  801fb7:	90                   	nop

00801fb8 <__udivdi3>:
  801fb8:	55                   	push   %ebp
  801fb9:	57                   	push   %edi
  801fba:	56                   	push   %esi
  801fbb:	53                   	push   %ebx
  801fbc:	83 ec 1c             	sub    $0x1c,%esp
  801fbf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801fc3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801fc7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801fcb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801fcf:	89 ca                	mov    %ecx,%edx
  801fd1:	89 f8                	mov    %edi,%eax
  801fd3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801fd7:	85 f6                	test   %esi,%esi
  801fd9:	75 2d                	jne    802008 <__udivdi3+0x50>
  801fdb:	39 cf                	cmp    %ecx,%edi
  801fdd:	77 65                	ja     802044 <__udivdi3+0x8c>
  801fdf:	89 fd                	mov    %edi,%ebp
  801fe1:	85 ff                	test   %edi,%edi
  801fe3:	75 0b                	jne    801ff0 <__udivdi3+0x38>
  801fe5:	b8 01 00 00 00       	mov    $0x1,%eax
  801fea:	31 d2                	xor    %edx,%edx
  801fec:	f7 f7                	div    %edi
  801fee:	89 c5                	mov    %eax,%ebp
  801ff0:	31 d2                	xor    %edx,%edx
  801ff2:	89 c8                	mov    %ecx,%eax
  801ff4:	f7 f5                	div    %ebp
  801ff6:	89 c1                	mov    %eax,%ecx
  801ff8:	89 d8                	mov    %ebx,%eax
  801ffa:	f7 f5                	div    %ebp
  801ffc:	89 cf                	mov    %ecx,%edi
  801ffe:	89 fa                	mov    %edi,%edx
  802000:	83 c4 1c             	add    $0x1c,%esp
  802003:	5b                   	pop    %ebx
  802004:	5e                   	pop    %esi
  802005:	5f                   	pop    %edi
  802006:	5d                   	pop    %ebp
  802007:	c3                   	ret    
  802008:	39 ce                	cmp    %ecx,%esi
  80200a:	77 28                	ja     802034 <__udivdi3+0x7c>
  80200c:	0f bd fe             	bsr    %esi,%edi
  80200f:	83 f7 1f             	xor    $0x1f,%edi
  802012:	75 40                	jne    802054 <__udivdi3+0x9c>
  802014:	39 ce                	cmp    %ecx,%esi
  802016:	72 0a                	jb     802022 <__udivdi3+0x6a>
  802018:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80201c:	0f 87 9e 00 00 00    	ja     8020c0 <__udivdi3+0x108>
  802022:	b8 01 00 00 00       	mov    $0x1,%eax
  802027:	89 fa                	mov    %edi,%edx
  802029:	83 c4 1c             	add    $0x1c,%esp
  80202c:	5b                   	pop    %ebx
  80202d:	5e                   	pop    %esi
  80202e:	5f                   	pop    %edi
  80202f:	5d                   	pop    %ebp
  802030:	c3                   	ret    
  802031:	8d 76 00             	lea    0x0(%esi),%esi
  802034:	31 ff                	xor    %edi,%edi
  802036:	31 c0                	xor    %eax,%eax
  802038:	89 fa                	mov    %edi,%edx
  80203a:	83 c4 1c             	add    $0x1c,%esp
  80203d:	5b                   	pop    %ebx
  80203e:	5e                   	pop    %esi
  80203f:	5f                   	pop    %edi
  802040:	5d                   	pop    %ebp
  802041:	c3                   	ret    
  802042:	66 90                	xchg   %ax,%ax
  802044:	89 d8                	mov    %ebx,%eax
  802046:	f7 f7                	div    %edi
  802048:	31 ff                	xor    %edi,%edi
  80204a:	89 fa                	mov    %edi,%edx
  80204c:	83 c4 1c             	add    $0x1c,%esp
  80204f:	5b                   	pop    %ebx
  802050:	5e                   	pop    %esi
  802051:	5f                   	pop    %edi
  802052:	5d                   	pop    %ebp
  802053:	c3                   	ret    
  802054:	bd 20 00 00 00       	mov    $0x20,%ebp
  802059:	89 eb                	mov    %ebp,%ebx
  80205b:	29 fb                	sub    %edi,%ebx
  80205d:	89 f9                	mov    %edi,%ecx
  80205f:	d3 e6                	shl    %cl,%esi
  802061:	89 c5                	mov    %eax,%ebp
  802063:	88 d9                	mov    %bl,%cl
  802065:	d3 ed                	shr    %cl,%ebp
  802067:	89 e9                	mov    %ebp,%ecx
  802069:	09 f1                	or     %esi,%ecx
  80206b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80206f:	89 f9                	mov    %edi,%ecx
  802071:	d3 e0                	shl    %cl,%eax
  802073:	89 c5                	mov    %eax,%ebp
  802075:	89 d6                	mov    %edx,%esi
  802077:	88 d9                	mov    %bl,%cl
  802079:	d3 ee                	shr    %cl,%esi
  80207b:	89 f9                	mov    %edi,%ecx
  80207d:	d3 e2                	shl    %cl,%edx
  80207f:	8b 44 24 08          	mov    0x8(%esp),%eax
  802083:	88 d9                	mov    %bl,%cl
  802085:	d3 e8                	shr    %cl,%eax
  802087:	09 c2                	or     %eax,%edx
  802089:	89 d0                	mov    %edx,%eax
  80208b:	89 f2                	mov    %esi,%edx
  80208d:	f7 74 24 0c          	divl   0xc(%esp)
  802091:	89 d6                	mov    %edx,%esi
  802093:	89 c3                	mov    %eax,%ebx
  802095:	f7 e5                	mul    %ebp
  802097:	39 d6                	cmp    %edx,%esi
  802099:	72 19                	jb     8020b4 <__udivdi3+0xfc>
  80209b:	74 0b                	je     8020a8 <__udivdi3+0xf0>
  80209d:	89 d8                	mov    %ebx,%eax
  80209f:	31 ff                	xor    %edi,%edi
  8020a1:	e9 58 ff ff ff       	jmp    801ffe <__udivdi3+0x46>
  8020a6:	66 90                	xchg   %ax,%ax
  8020a8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8020ac:	89 f9                	mov    %edi,%ecx
  8020ae:	d3 e2                	shl    %cl,%edx
  8020b0:	39 c2                	cmp    %eax,%edx
  8020b2:	73 e9                	jae    80209d <__udivdi3+0xe5>
  8020b4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8020b7:	31 ff                	xor    %edi,%edi
  8020b9:	e9 40 ff ff ff       	jmp    801ffe <__udivdi3+0x46>
  8020be:	66 90                	xchg   %ax,%ax
  8020c0:	31 c0                	xor    %eax,%eax
  8020c2:	e9 37 ff ff ff       	jmp    801ffe <__udivdi3+0x46>
  8020c7:	90                   	nop

008020c8 <__umoddi3>:
  8020c8:	55                   	push   %ebp
  8020c9:	57                   	push   %edi
  8020ca:	56                   	push   %esi
  8020cb:	53                   	push   %ebx
  8020cc:	83 ec 1c             	sub    $0x1c,%esp
  8020cf:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8020d3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8020d7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8020db:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8020df:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8020e3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8020e7:	89 f3                	mov    %esi,%ebx
  8020e9:	89 fa                	mov    %edi,%edx
  8020eb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8020ef:	89 34 24             	mov    %esi,(%esp)
  8020f2:	85 c0                	test   %eax,%eax
  8020f4:	75 1a                	jne    802110 <__umoddi3+0x48>
  8020f6:	39 f7                	cmp    %esi,%edi
  8020f8:	0f 86 a2 00 00 00    	jbe    8021a0 <__umoddi3+0xd8>
  8020fe:	89 c8                	mov    %ecx,%eax
  802100:	89 f2                	mov    %esi,%edx
  802102:	f7 f7                	div    %edi
  802104:	89 d0                	mov    %edx,%eax
  802106:	31 d2                	xor    %edx,%edx
  802108:	83 c4 1c             	add    $0x1c,%esp
  80210b:	5b                   	pop    %ebx
  80210c:	5e                   	pop    %esi
  80210d:	5f                   	pop    %edi
  80210e:	5d                   	pop    %ebp
  80210f:	c3                   	ret    
  802110:	39 f0                	cmp    %esi,%eax
  802112:	0f 87 ac 00 00 00    	ja     8021c4 <__umoddi3+0xfc>
  802118:	0f bd e8             	bsr    %eax,%ebp
  80211b:	83 f5 1f             	xor    $0x1f,%ebp
  80211e:	0f 84 ac 00 00 00    	je     8021d0 <__umoddi3+0x108>
  802124:	bf 20 00 00 00       	mov    $0x20,%edi
  802129:	29 ef                	sub    %ebp,%edi
  80212b:	89 fe                	mov    %edi,%esi
  80212d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802131:	89 e9                	mov    %ebp,%ecx
  802133:	d3 e0                	shl    %cl,%eax
  802135:	89 d7                	mov    %edx,%edi
  802137:	89 f1                	mov    %esi,%ecx
  802139:	d3 ef                	shr    %cl,%edi
  80213b:	09 c7                	or     %eax,%edi
  80213d:	89 e9                	mov    %ebp,%ecx
  80213f:	d3 e2                	shl    %cl,%edx
  802141:	89 14 24             	mov    %edx,(%esp)
  802144:	89 d8                	mov    %ebx,%eax
  802146:	d3 e0                	shl    %cl,%eax
  802148:	89 c2                	mov    %eax,%edx
  80214a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80214e:	d3 e0                	shl    %cl,%eax
  802150:	89 44 24 04          	mov    %eax,0x4(%esp)
  802154:	8b 44 24 08          	mov    0x8(%esp),%eax
  802158:	89 f1                	mov    %esi,%ecx
  80215a:	d3 e8                	shr    %cl,%eax
  80215c:	09 d0                	or     %edx,%eax
  80215e:	d3 eb                	shr    %cl,%ebx
  802160:	89 da                	mov    %ebx,%edx
  802162:	f7 f7                	div    %edi
  802164:	89 d3                	mov    %edx,%ebx
  802166:	f7 24 24             	mull   (%esp)
  802169:	89 c6                	mov    %eax,%esi
  80216b:	89 d1                	mov    %edx,%ecx
  80216d:	39 d3                	cmp    %edx,%ebx
  80216f:	0f 82 87 00 00 00    	jb     8021fc <__umoddi3+0x134>
  802175:	0f 84 91 00 00 00    	je     80220c <__umoddi3+0x144>
  80217b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80217f:	29 f2                	sub    %esi,%edx
  802181:	19 cb                	sbb    %ecx,%ebx
  802183:	89 d8                	mov    %ebx,%eax
  802185:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802189:	d3 e0                	shl    %cl,%eax
  80218b:	89 e9                	mov    %ebp,%ecx
  80218d:	d3 ea                	shr    %cl,%edx
  80218f:	09 d0                	or     %edx,%eax
  802191:	89 e9                	mov    %ebp,%ecx
  802193:	d3 eb                	shr    %cl,%ebx
  802195:	89 da                	mov    %ebx,%edx
  802197:	83 c4 1c             	add    $0x1c,%esp
  80219a:	5b                   	pop    %ebx
  80219b:	5e                   	pop    %esi
  80219c:	5f                   	pop    %edi
  80219d:	5d                   	pop    %ebp
  80219e:	c3                   	ret    
  80219f:	90                   	nop
  8021a0:	89 fd                	mov    %edi,%ebp
  8021a2:	85 ff                	test   %edi,%edi
  8021a4:	75 0b                	jne    8021b1 <__umoddi3+0xe9>
  8021a6:	b8 01 00 00 00       	mov    $0x1,%eax
  8021ab:	31 d2                	xor    %edx,%edx
  8021ad:	f7 f7                	div    %edi
  8021af:	89 c5                	mov    %eax,%ebp
  8021b1:	89 f0                	mov    %esi,%eax
  8021b3:	31 d2                	xor    %edx,%edx
  8021b5:	f7 f5                	div    %ebp
  8021b7:	89 c8                	mov    %ecx,%eax
  8021b9:	f7 f5                	div    %ebp
  8021bb:	89 d0                	mov    %edx,%eax
  8021bd:	e9 44 ff ff ff       	jmp    802106 <__umoddi3+0x3e>
  8021c2:	66 90                	xchg   %ax,%ax
  8021c4:	89 c8                	mov    %ecx,%eax
  8021c6:	89 f2                	mov    %esi,%edx
  8021c8:	83 c4 1c             	add    $0x1c,%esp
  8021cb:	5b                   	pop    %ebx
  8021cc:	5e                   	pop    %esi
  8021cd:	5f                   	pop    %edi
  8021ce:	5d                   	pop    %ebp
  8021cf:	c3                   	ret    
  8021d0:	3b 04 24             	cmp    (%esp),%eax
  8021d3:	72 06                	jb     8021db <__umoddi3+0x113>
  8021d5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8021d9:	77 0f                	ja     8021ea <__umoddi3+0x122>
  8021db:	89 f2                	mov    %esi,%edx
  8021dd:	29 f9                	sub    %edi,%ecx
  8021df:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8021e3:	89 14 24             	mov    %edx,(%esp)
  8021e6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8021ea:	8b 44 24 04          	mov    0x4(%esp),%eax
  8021ee:	8b 14 24             	mov    (%esp),%edx
  8021f1:	83 c4 1c             	add    $0x1c,%esp
  8021f4:	5b                   	pop    %ebx
  8021f5:	5e                   	pop    %esi
  8021f6:	5f                   	pop    %edi
  8021f7:	5d                   	pop    %ebp
  8021f8:	c3                   	ret    
  8021f9:	8d 76 00             	lea    0x0(%esi),%esi
  8021fc:	2b 04 24             	sub    (%esp),%eax
  8021ff:	19 fa                	sbb    %edi,%edx
  802201:	89 d1                	mov    %edx,%ecx
  802203:	89 c6                	mov    %eax,%esi
  802205:	e9 71 ff ff ff       	jmp    80217b <__umoddi3+0xb3>
  80220a:	66 90                	xchg   %ax,%ax
  80220c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802210:	72 ea                	jb     8021fc <__umoddi3+0x134>
  802212:	89 d9                	mov    %ebx,%ecx
  802214:	e9 62 ff ff ff       	jmp    80217b <__umoddi3+0xb3>

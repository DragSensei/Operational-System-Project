
obj/user/tst_malloc_2:     file format elf32-i386


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
  800031:	e8 a3 05 00 00       	call   8005d9 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <check_dynalloc_datastruct>:
#define USER_TST_UTILITIES_H_
#include <inc/types.h>
#include <inc/stdio.h>

int check_dynalloc_datastruct(void* va, void* expectedVA, uint32 expectedSize, uint8 expectedFlag)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
  80003e:	8b 45 14             	mov    0x14(%ebp),%eax
  800041:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//Check returned va
	if(va != expectedVA)
  800044:	8b 45 08             	mov    0x8(%ebp),%eax
  800047:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80004a:	74 1d                	je     800069 <check_dynalloc_datastruct+0x31>
	{
		cprintf("wrong block address. Expected %x, Actual %x\n", expectedVA, va);
  80004c:	83 ec 04             	sub    $0x4,%esp
  80004f:	ff 75 08             	pushl  0x8(%ebp)
  800052:	ff 75 0c             	pushl  0xc(%ebp)
  800055:	68 60 24 80 00       	push   $0x802460
  80005a:	e8 f8 09 00 00       	call   800a57 <cprintf>
  80005f:	83 c4 10             	add    $0x10,%esp
		return 0;
  800062:	b8 00 00 00 00       	mov    $0x0,%eax
  800067:	eb 55                	jmp    8000be <check_dynalloc_datastruct+0x86>
	}
	//Check header & footer
	uint32 header = *((uint32*)va-1);
  800069:	8b 45 08             	mov    0x8(%ebp),%eax
  80006c:	8b 40 fc             	mov    -0x4(%eax),%eax
  80006f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 footer = *((uint32*)(va + expectedSize - 8));
  800072:	8b 45 10             	mov    0x10(%ebp),%eax
  800075:	8d 50 f8             	lea    -0x8(%eax),%edx
  800078:	8b 45 08             	mov    0x8(%ebp),%eax
  80007b:	01 d0                	add    %edx,%eax
  80007d:	8b 00                	mov    (%eax),%eax
  80007f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 expectedData = expectedSize | expectedFlag ;
  800082:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  800086:	0b 45 10             	or     0x10(%ebp),%eax
  800089:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(header != expectedData || footer != expectedData)
  80008c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80008f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800092:	75 08                	jne    80009c <check_dynalloc_datastruct+0x64>
  800094:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800097:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80009a:	74 1d                	je     8000b9 <check_dynalloc_datastruct+0x81>
	{
		cprintf("wrong header/footer data. Expected %d, Actual H:%d F:%d\n", expectedData, header, footer);
  80009c:	ff 75 f0             	pushl  -0x10(%ebp)
  80009f:	ff 75 f4             	pushl  -0xc(%ebp)
  8000a2:	ff 75 ec             	pushl  -0x14(%ebp)
  8000a5:	68 90 24 80 00       	push   $0x802490
  8000aa:	e8 a8 09 00 00       	call   800a57 <cprintf>
  8000af:	83 c4 10             	add    $0x10,%esp
		return 0;
  8000b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b7:	eb 05                	jmp    8000be <check_dynalloc_datastruct+0x86>
	}
	return 1;
  8000b9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8000be:	c9                   	leave  
  8000bf:	c3                   	ret    

008000c0 <_main>:
short* startVAs[numOfAllocs*allocCntPerSize+1] ;
short* midVAs[numOfAllocs*allocCntPerSize+1] ;
short* endVAs[numOfAllocs*allocCntPerSize+1] ;

void _main(void)
{
  8000c0:	55                   	push   %ebp
  8000c1:	89 e5                	mov    %esp,%ebp
  8000c3:	53                   	push   %ebx
  8000c4:	81 ec a4 00 00 00    	sub    $0xa4,%esp

	//cprintf("1\n");
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
#if USE_KHEAP
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  8000ca:	a1 40 40 80 00       	mov    0x804040,%eax
  8000cf:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
  8000d5:	a1 40 40 80 00       	mov    0x804040,%eax
  8000da:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000e0:	39 c2                	cmp    %eax,%edx
  8000e2:	72 14                	jb     8000f8 <_main+0x38>
			panic("Please increase the WS size");
  8000e4:	83 ec 04             	sub    $0x4,%esp
  8000e7:	68 c9 24 80 00       	push   $0x8024c9
  8000ec:	6a 25                	push   $0x25
  8000ee:	68 e5 24 80 00       	push   $0x8024e5
  8000f3:	e8 91 06 00 00       	call   800789 <_panic>
#endif

	/*=================================================*/


	int eval = 0;
  8000f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	bool is_correct = 1;
  8000ff:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	int targetAllocatedSpace = 3*Mega;
  800106:	c7 45 c8 00 00 30 00 	movl   $0x300000,-0x38(%ebp)

	void * va ;
	int idx = 0;
  80010d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	bool chk;
	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800114:	e8 44 1b 00 00       	call   801c5d <sys_pf_calculate_allocated_pages>
  800119:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	int freeFrames = sys_calculate_free_frames() ;
  80011c:	e8 f1 1a 00 00       	call   801c12 <sys_calculate_free_frames>
  800121:	89 45 c0             	mov    %eax,-0x40(%ebp)
	void* expectedVA;
	uint32 actualSize, expectedSize, curTotalSize,roundedTotalSize ;
	//====================================================================//
	/*INITIAL ALLOC Scenario 1: Try to allocate set of blocks with different sizes*/
	cprintf("%~\n1: [BLOCK ALLOCATOR] allocate set of blocks with different sizes [all should fit] [30%]\n") ;
  800124:	83 ec 0c             	sub    $0xc,%esp
  800127:	68 fc 24 80 00       	push   $0x8024fc
  80012c:	e8 26 09 00 00       	call   800a57 <cprintf>
  800131:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  800134:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		void* curVA = (void*) USER_HEAP_START + sizeof(int) /*BEG Block*/ ;
  80013b:	c7 45 e0 04 00 00 80 	movl   $0x80000004,-0x20(%ebp)
		curTotalSize = sizeof(int);
  800142:	c7 45 e4 04 00 00 00 	movl   $0x4,-0x1c(%ebp)
		for (int i = 0; i < numOfAllocs; ++i)
  800149:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800150:	e9 b6 01 00 00       	jmp    80030b <_main+0x24b>
		{
			for (int j = 0; j < allocCntPerSize; ++j)
  800155:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  80015c:	e9 9a 01 00 00       	jmp    8002fb <_main+0x23b>
			{
				actualSize = allocSizes[i] - sizeOfMetaData;
  800161:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800164:	8b 04 85 00 40 80 00 	mov    0x804000(,%eax,4),%eax
  80016b:	83 e8 08             	sub    $0x8,%eax
  80016e:	89 45 bc             	mov    %eax,-0x44(%ebp)
				va = startVAs[idx] = malloc(actualSize);
  800171:	83 ec 0c             	sub    $0xc,%esp
  800174:	ff 75 bc             	pushl  -0x44(%ebp)
  800177:	e8 9d 18 00 00       	call   801a19 <malloc>
  80017c:	83 c4 10             	add    $0x10,%esp
  80017f:	89 c2                	mov    %eax,%edx
  800181:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800184:	89 14 85 80 40 80 00 	mov    %edx,0x804080(,%eax,4)
  80018b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80018e:	8b 04 85 80 40 80 00 	mov    0x804080(,%eax,4),%eax
  800195:	89 45 b8             	mov    %eax,-0x48(%ebp)
				midVAs[idx] = va + actualSize/2 ;
  800198:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80019b:	d1 e8                	shr    %eax
  80019d:	89 c2                	mov    %eax,%edx
  80019f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8001a2:	01 c2                	add    %eax,%edx
  8001a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001a7:	89 14 85 80 6c 80 00 	mov    %edx,0x806c80(,%eax,4)
				endVAs[idx] = va + actualSize - sizeof(short);
  8001ae:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8001b1:	8d 50 fe             	lea    -0x2(%eax),%edx
  8001b4:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8001b7:	01 c2                	add    %eax,%edx
  8001b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001bc:	89 14 85 80 56 80 00 	mov    %edx,0x805680(,%eax,4)
				//Check returned va
				expectedVA = (curVA + sizeOfMetaData/2);
  8001c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001c6:	83 c0 04             	add    $0x4,%eax
  8001c9:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				expectedSize = allocSizes[i];
  8001cc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001cf:	8b 04 85 00 40 80 00 	mov    0x804000(,%eax,4),%eax
  8001d6:	89 45 e8             	mov    %eax,-0x18(%ebp)
				curTotalSize += allocSizes[i] ;
  8001d9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001dc:	8b 04 85 00 40 80 00 	mov    0x804000(,%eax,4),%eax
  8001e3:	01 45 e4             	add    %eax,-0x1c(%ebp)
				//============================================================
				//Check if the remaining area doesn't fit the DynAllocBlock,
				//so update the curVA & curTotalSize to skip this area
				roundedTotalSize = ROUNDUP(curTotalSize, PAGE_SIZE);
  8001e6:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  8001ed:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8001f0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8001f3:	01 d0                	add    %edx,%eax
  8001f5:	48                   	dec    %eax
  8001f6:	89 45 ac             	mov    %eax,-0x54(%ebp)
  8001f9:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8001fc:	ba 00 00 00 00       	mov    $0x0,%edx
  800201:	f7 75 b0             	divl   -0x50(%ebp)
  800204:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800207:	29 d0                	sub    %edx,%eax
  800209:	89 45 a8             	mov    %eax,-0x58(%ebp)
				int diff = (roundedTotalSize - curTotalSize) ;
  80020c:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80020f:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800212:	89 45 a4             	mov    %eax,-0x5c(%ebp)
				if (diff > 0 && diff < (DYN_ALLOC_MIN_BLOCK_SIZE + sizeOfMetaData  + sizeof(int) /*END block*/))
  800215:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  800219:	7e 60                	jle    80027b <_main+0x1bb>
  80021b:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80021e:	83 f8 13             	cmp    $0x13,%eax
  800221:	77 58                	ja     80027b <_main+0x1bb>
				{
					cprintf("%~\n FRAGMENTATION @allocSize#%d: curVA = %x diff = %d\n", i, curVA, diff);
  800223:	ff 75 a4             	pushl  -0x5c(%ebp)
  800226:	ff 75 e0             	pushl  -0x20(%ebp)
  800229:	ff 75 dc             	pushl  -0x24(%ebp)
  80022c:	68 58 25 80 00       	push   $0x802558
  800231:	e8 21 08 00 00       	call   800a57 <cprintf>
  800236:	83 c4 10             	add    $0x10,%esp
//					cprintf("%~\n Allocated block @ %x with size = %d\n", va, get_block_size(va));

					curVA = ROUNDUP(curVA, PAGE_SIZE)- sizeof(int) /*next alloc will start at END Block (after sbrk)*/;
  800239:	c7 45 a0 00 10 00 00 	movl   $0x1000,-0x60(%ebp)
  800240:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800243:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800246:	01 d0                	add    %edx,%eax
  800248:	48                   	dec    %eax
  800249:	89 45 9c             	mov    %eax,-0x64(%ebp)
  80024c:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80024f:	ba 00 00 00 00       	mov    $0x0,%edx
  800254:	f7 75 a0             	divl   -0x60(%ebp)
  800257:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80025a:	29 d0                	sub    %edx,%eax
  80025c:	83 e8 04             	sub    $0x4,%eax
  80025f:	89 45 e0             	mov    %eax,-0x20(%ebp)
					curTotalSize = roundedTotalSize - sizeof(int) /*exclude END Block*/;
  800262:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800265:	83 e8 04             	sub    $0x4,%eax
  800268:	89 45 e4             	mov    %eax,-0x1c(%ebp)
					expectedSize += diff - sizeof(int) /*exclude END Block*/;
  80026b:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  80026e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800271:	01 d0                	add    %edx,%eax
  800273:	83 e8 04             	sub    $0x4,%eax
  800276:	89 45 e8             	mov    %eax,-0x18(%ebp)
  800279:	eb 0d                	jmp    800288 <_main+0x1c8>
				}
				else
				{
					curVA += allocSizes[i] ;
  80027b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80027e:	8b 04 85 00 40 80 00 	mov    0x804000(,%eax,4),%eax
  800285:	01 45 e0             	add    %eax,-0x20(%ebp)
				}
				//============================================================
				if (is_correct)
  800288:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80028c:	74 37                	je     8002c5 <_main+0x205>
				{
					if (check_dynalloc_datastruct(va, expectedVA, expectedSize, 1) == 0)
  80028e:	6a 01                	push   $0x1
  800290:	ff 75 e8             	pushl  -0x18(%ebp)
  800293:	ff 75 b4             	pushl  -0x4c(%ebp)
  800296:	ff 75 b8             	pushl  -0x48(%ebp)
  800299:	e8 9a fd ff ff       	call   800038 <check_dynalloc_datastruct>
  80029e:	83 c4 10             	add    $0x10,%esp
  8002a1:	85 c0                	test   %eax,%eax
  8002a3:	75 20                	jne    8002c5 <_main+0x205>
					{
						if (is_correct)
  8002a5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8002a9:	74 1a                	je     8002c5 <_main+0x205>
						{
							is_correct = 0;
  8002ab:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
							cprintf("alloc_block_xx #1.%d: WRONG ALLOC\n", idx);
  8002b2:	83 ec 08             	sub    $0x8,%esp
  8002b5:	ff 75 ec             	pushl  -0x14(%ebp)
  8002b8:	68 90 25 80 00       	push   $0x802590
  8002bd:	e8 95 07 00 00       	call   800a57 <cprintf>
  8002c2:	83 c4 10             	add    $0x10,%esp
						}
					}
				}
				*(startVAs[idx]) = idx ;
  8002c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002c8:	8b 14 85 80 40 80 00 	mov    0x804080(,%eax,4),%edx
  8002cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002d2:	66 89 02             	mov    %ax,(%edx)
				*(midVAs[idx]) = idx ;
  8002d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002d8:	8b 14 85 80 6c 80 00 	mov    0x806c80(,%eax,4),%edx
  8002df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002e2:	66 89 02             	mov    %ax,(%edx)
				*(endVAs[idx]) = idx ;
  8002e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002e8:	8b 14 85 80 56 80 00 	mov    0x805680(,%eax,4),%edx
  8002ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002f2:	66 89 02             	mov    %ax,(%edx)
				idx++;
  8002f5:	ff 45 ec             	incl   -0x14(%ebp)
		is_correct = 1;
		void* curVA = (void*) USER_HEAP_START + sizeof(int) /*BEG Block*/ ;
		curTotalSize = sizeof(int);
		for (int i = 0; i < numOfAllocs; ++i)
		{
			for (int j = 0; j < allocCntPerSize; ++j)
  8002f8:	ff 45 d8             	incl   -0x28(%ebp)
  8002fb:	81 7d d8 c7 00 00 00 	cmpl   $0xc7,-0x28(%ebp)
  800302:	0f 8e 59 fe ff ff    	jle    800161 <_main+0xa1>
	cprintf("%~\n1: [BLOCK ALLOCATOR] allocate set of blocks with different sizes [all should fit] [30%]\n") ;
	{
		is_correct = 1;
		void* curVA = (void*) USER_HEAP_START + sizeof(int) /*BEG Block*/ ;
		curTotalSize = sizeof(int);
		for (int i = 0; i < numOfAllocs; ++i)
  800308:	ff 45 dc             	incl   -0x24(%ebp)
  80030b:	83 7d dc 06          	cmpl   $0x6,-0x24(%ebp)
  80030f:	0f 8e 40 fe ff ff    	jle    800155 <_main+0x95>
				idx++;
			}
			//if (is_correct == 0)
			//break;
		}
		if (is_correct)
  800315:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800319:	74 04                	je     80031f <_main+0x25f>
		{
			eval += 30;
  80031b:	83 45 f4 1e          	addl   $0x1e,-0xc(%ebp)
		}
	}

	//====================================================================//
	/*INITIAL ALLOC Scenario 2: Check stored data inside each allocated block*/
	cprintf("%~\n2: Check stored data inside each allocated block [30%]\n") ;
  80031f:	83 ec 0c             	sub    $0xc,%esp
  800322:	68 b4 25 80 00       	push   $0x8025b4
  800327:	e8 2b 07 00 00       	call   800a57 <cprintf>
  80032c:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  80032f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

		for (int i = 0; i < idx; ++i)
  800336:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  80033d:	eb 5b                	jmp    80039a <_main+0x2da>
		{
			if (*(startVAs[i]) != i || *(midVAs[i]) != i ||	*(endVAs[i]) != i)
  80033f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800342:	8b 04 85 80 40 80 00 	mov    0x804080(,%eax,4),%eax
  800349:	66 8b 00             	mov    (%eax),%ax
  80034c:	98                   	cwtl   
  80034d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800350:	75 26                	jne    800378 <_main+0x2b8>
  800352:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800355:	8b 04 85 80 6c 80 00 	mov    0x806c80(,%eax,4),%eax
  80035c:	66 8b 00             	mov    (%eax),%ax
  80035f:	98                   	cwtl   
  800360:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800363:	75 13                	jne    800378 <_main+0x2b8>
  800365:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800368:	8b 04 85 80 56 80 00 	mov    0x805680(,%eax,4),%eax
  80036f:	66 8b 00             	mov    (%eax),%ax
  800372:	98                   	cwtl   
  800373:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800376:	74 1f                	je     800397 <_main+0x2d7>
			{
				is_correct = 0;
  800378:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
				cprintf("alloc_block_xx #2.%d: WRONG! content of the block is not correct. Expected %d\n",i, i);
  80037f:	83 ec 04             	sub    $0x4,%esp
  800382:	ff 75 d4             	pushl  -0x2c(%ebp)
  800385:	ff 75 d4             	pushl  -0x2c(%ebp)
  800388:	68 f0 25 80 00       	push   $0x8025f0
  80038d:	e8 c5 06 00 00       	call   800a57 <cprintf>
  800392:	83 c4 10             	add    $0x10,%esp
				break;
  800395:	eb 0b                	jmp    8003a2 <_main+0x2e2>
	/*INITIAL ALLOC Scenario 2: Check stored data inside each allocated block*/
	cprintf("%~\n2: Check stored data inside each allocated block [30%]\n") ;
	{
		is_correct = 1;

		for (int i = 0; i < idx; ++i)
  800397:	ff 45 d4             	incl   -0x2c(%ebp)
  80039a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80039d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8003a0:	7c 9d                	jl     80033f <_main+0x27f>
				is_correct = 0;
				cprintf("alloc_block_xx #2.%d: WRONG! content of the block is not correct. Expected %d\n",i, i);
				break;
			}
		}
		if (is_correct)
  8003a2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8003a6:	74 04                	je     8003ac <_main+0x2ec>
		{
			eval += 30;
  8003a8:	83 45 f4 1e          	addl   $0x1e,-0xc(%ebp)
		}
	}

	/*Check page file*/
	cprintf("%~\n3: Check page file size (nothing should be allocated) [10%]\n") ;
  8003ac:	83 ec 0c             	sub    $0xc,%esp
  8003af:	68 40 26 80 00       	push   $0x802640
  8003b4:	e8 9e 06 00 00       	call   800a57 <cprintf>
  8003b9:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  8003bc:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0)
  8003c3:	e8 95 18 00 00       	call   801c5d <sys_pf_calculate_allocated_pages>
  8003c8:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  8003cb:	74 17                	je     8003e4 <_main+0x324>
		{
			cprintf("page(s) are allocated in PageFile while not expected to\n");
  8003cd:	83 ec 0c             	sub    $0xc,%esp
  8003d0:	68 80 26 80 00       	push   $0x802680
  8003d5:	e8 7d 06 00 00       	call   800a57 <cprintf>
  8003da:	83 c4 10             	add    $0x10,%esp
			is_correct = 0;
  8003dd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		}
		if (is_correct)
  8003e4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8003e8:	74 04                	je     8003ee <_main+0x32e>
		{
			eval += 10;
  8003ea:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		}
	}

	uint32 expectedAllocatedSize = 0;
  8003ee:	c7 45 98 00 00 00 00 	movl   $0x0,-0x68(%ebp)
//	for (int i = 0; i < numOfAllocs; ++i)
//	{
//		expectedAllocatedSize += allocCntPerSize * allocSizes[i] ;
//	}
//	expectedAllocatedSize = ROUNDUP(expectedAllocatedSize, PAGE_SIZE);
	expectedAllocatedSize = ROUNDUP(curTotalSize, PAGE_SIZE);
  8003f5:	c7 45 94 00 10 00 00 	movl   $0x1000,-0x6c(%ebp)
  8003fc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8003ff:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800402:	01 d0                	add    %edx,%eax
  800404:	48                   	dec    %eax
  800405:	89 45 90             	mov    %eax,-0x70(%ebp)
  800408:	8b 45 90             	mov    -0x70(%ebp),%eax
  80040b:	ba 00 00 00 00       	mov    $0x0,%edx
  800410:	f7 75 94             	divl   -0x6c(%ebp)
  800413:	8b 45 90             	mov    -0x70(%ebp),%eax
  800416:	29 d0                	sub    %edx,%eax
  800418:	89 45 98             	mov    %eax,-0x68(%ebp)
	uint32 expectedAllocNumOfPages = expectedAllocatedSize / PAGE_SIZE; 				/*# pages*/
  80041b:	8b 45 98             	mov    -0x68(%ebp),%eax
  80041e:	c1 e8 0c             	shr    $0xc,%eax
  800421:	89 45 8c             	mov    %eax,-0x74(%ebp)
	uint32 expectedAllocNumOfTables = ROUNDUP(expectedAllocatedSize, PTSIZE) / PTSIZE; 	/*# tables*/
  800424:	c7 45 88 00 00 40 00 	movl   $0x400000,-0x78(%ebp)
  80042b:	8b 55 98             	mov    -0x68(%ebp),%edx
  80042e:	8b 45 88             	mov    -0x78(%ebp),%eax
  800431:	01 d0                	add    %edx,%eax
  800433:	48                   	dec    %eax
  800434:	89 45 84             	mov    %eax,-0x7c(%ebp)
  800437:	8b 45 84             	mov    -0x7c(%ebp),%eax
  80043a:	ba 00 00 00 00       	mov    $0x0,%edx
  80043f:	f7 75 88             	divl   -0x78(%ebp)
  800442:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800445:	29 d0                	sub    %edx,%eax
  800447:	c1 e8 16             	shr    $0x16,%eax
  80044a:	89 45 80             	mov    %eax,-0x80(%ebp)
	uint32 expectedAllocNumOfPagesForWS = ROUNDUP(expectedAllocNumOfPages * (sizeof(struct WorkingSetElement) + sizeOfMetaData), PAGE_SIZE) / PAGE_SIZE; 				/*# pages*/
  80044d:	c7 85 7c ff ff ff 00 	movl   $0x1000,-0x84(%ebp)
  800454:	10 00 00 
  800457:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80045a:	c1 e0 05             	shl    $0x5,%eax
  80045d:	89 c2                	mov    %eax,%edx
  80045f:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800465:	01 d0                	add    %edx,%eax
  800467:	48                   	dec    %eax
  800468:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
  80046e:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800474:	ba 00 00 00 00       	mov    $0x0,%edx
  800479:	f7 b5 7c ff ff ff    	divl   -0x84(%ebp)
  80047f:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800485:	29 d0                	sub    %edx,%eax
  800487:	c1 e8 0c             	shr    $0xc,%eax
  80048a:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)

	/*Check memory allocation*/
	cprintf("%~\n4: Check total allocation in RAM (for pages, tables & WS) [10%]\n") ;
  800490:	83 ec 0c             	sub    $0xc,%esp
  800493:	68 bc 26 80 00       	push   $0x8026bc
  800498:	e8 ba 05 00 00       	call   800a57 <cprintf>
  80049d:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  8004a0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		uint32 expected = expectedAllocNumOfPages + expectedAllocNumOfTables  + expectedAllocNumOfPagesForWS;
  8004a7:	8b 55 8c             	mov    -0x74(%ebp),%edx
  8004aa:	8b 45 80             	mov    -0x80(%ebp),%eax
  8004ad:	01 c2                	add    %eax,%edx
  8004af:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8004b5:	01 d0                	add    %edx,%eax
  8004b7:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
		uint32 actual = (freeFrames - sys_calculate_free_frames()) ;
  8004bd:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  8004c0:	e8 4d 17 00 00       	call   801c12 <sys_calculate_free_frames>
  8004c5:	29 c3                	sub    %eax,%ebx
  8004c7:	89 d8                	mov    %ebx,%eax
  8004c9:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
		if (expected != actual)
  8004cf:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  8004d5:	3b 85 6c ff ff ff    	cmp    -0x94(%ebp),%eax
  8004db:	74 23                	je     800500 <_main+0x440>
		{
			cprintf("number of allocated pages in MEMORY not correct. Expected %d, Actual %d\n", expected, actual);
  8004dd:	83 ec 04             	sub    $0x4,%esp
  8004e0:	ff b5 6c ff ff ff    	pushl  -0x94(%ebp)
  8004e6:	ff b5 70 ff ff ff    	pushl  -0x90(%ebp)
  8004ec:	68 00 27 80 00       	push   $0x802700
  8004f1:	e8 61 05 00 00       	call   800a57 <cprintf>
  8004f6:	83 c4 10             	add    $0x10,%esp
			is_correct = 0;
  8004f9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		}
		if (is_correct)
  800500:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800504:	74 04                	je     80050a <_main+0x44a>
		{
			eval += 10;
  800506:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		}
	}

	/*Check WS elements*/
	cprintf("%~\n5: Check content of WS [20%]\n") ;
  80050a:	83 ec 0c             	sub    $0xc,%esp
  80050d:	68 4c 27 80 00       	push   $0x80274c
  800512:	e8 40 05 00 00       	call   800a57 <cprintf>
  800517:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  80051a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		uint32* expectedVAs = malloc(expectedAllocNumOfPages*sizeof(int));
  800521:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800524:	c1 e0 02             	shl    $0x2,%eax
  800527:	83 ec 0c             	sub    $0xc,%esp
  80052a:	50                   	push   %eax
  80052b:	e8 e9 14 00 00       	call   801a19 <malloc>
  800530:	83 c4 10             	add    $0x10,%esp
  800533:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
		int i = 0;
  800539:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		for (uint32 va = USER_HEAP_START; va < USER_HEAP_START + expectedAllocatedSize; va+=PAGE_SIZE)
  800540:	c7 45 cc 00 00 00 80 	movl   $0x80000000,-0x34(%ebp)
  800547:	eb 24                	jmp    80056d <_main+0x4ad>
		{
			expectedVAs[i++] = va;
  800549:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80054c:	8d 50 01             	lea    0x1(%eax),%edx
  80054f:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800552:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800559:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  80055f:	01 c2                	add    %eax,%edx
  800561:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800564:	89 02                	mov    %eax,(%edx)
	cprintf("%~\n5: Check content of WS [20%]\n") ;
	{
		is_correct = 1;
		uint32* expectedVAs = malloc(expectedAllocNumOfPages*sizeof(int));
		int i = 0;
		for (uint32 va = USER_HEAP_START; va < USER_HEAP_START + expectedAllocatedSize; va+=PAGE_SIZE)
  800566:	81 45 cc 00 10 00 00 	addl   $0x1000,-0x34(%ebp)
  80056d:	8b 45 98             	mov    -0x68(%ebp),%eax
  800570:	05 00 00 00 80       	add    $0x80000000,%eax
  800575:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  800578:	77 cf                	ja     800549 <_main+0x489>
		{
			expectedVAs[i++] = va;
		}
		chk = sys_check_WS_list(expectedVAs, expectedAllocNumOfPages, 0, 2);
  80057a:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80057d:	6a 02                	push   $0x2
  80057f:	6a 00                	push   $0x0
  800581:	50                   	push   %eax
  800582:	ff b5 68 ff ff ff    	pushl  -0x98(%ebp)
  800588:	e8 47 1a 00 00       	call   801fd4 <sys_check_WS_list>
  80058d:	83 c4 10             	add    $0x10,%esp
  800590:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
		if (chk != 1)
  800596:	83 bd 64 ff ff ff 01 	cmpl   $0x1,-0x9c(%ebp)
  80059d:	74 17                	je     8005b6 <_main+0x4f6>
		{
			cprintf("malloc: page is not added to WS\n");
  80059f:	83 ec 0c             	sub    $0xc,%esp
  8005a2:	68 70 27 80 00       	push   $0x802770
  8005a7:	e8 ab 04 00 00       	call   800a57 <cprintf>
  8005ac:	83 c4 10             	add    $0x10,%esp
			is_correct = 0;
  8005af:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		}
		if (is_correct)
  8005b6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8005ba:	74 04                	je     8005c0 <_main+0x500>
		{
			eval += 20;
  8005bc:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
		}
	}

	cprintf("%~\ntest malloc (2) [DYNAMIC ALLOCATOR] is finished. Evaluation = %d%\n", eval);
  8005c0:	83 ec 08             	sub    $0x8,%esp
  8005c3:	ff 75 f4             	pushl  -0xc(%ebp)
  8005c6:	68 94 27 80 00       	push   $0x802794
  8005cb:	e8 87 04 00 00       	call   800a57 <cprintf>
  8005d0:	83 c4 10             	add    $0x10,%esp

	return;
  8005d3:	90                   	nop
}
  8005d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8005d7:	c9                   	leave  
  8005d8:	c3                   	ret    

008005d9 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8005d9:	55                   	push   %ebp
  8005da:	89 e5                	mov    %esp,%ebp
  8005dc:	57                   	push   %edi
  8005dd:	56                   	push   %esi
  8005de:	53                   	push   %ebx
  8005df:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8005e2:	e8 f4 17 00 00       	call   801ddb <sys_getenvindex>
  8005e7:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8005ea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8005ed:	89 d0                	mov    %edx,%eax
  8005ef:	c1 e0 02             	shl    $0x2,%eax
  8005f2:	01 d0                	add    %edx,%eax
  8005f4:	c1 e0 03             	shl    $0x3,%eax
  8005f7:	01 d0                	add    %edx,%eax
  8005f9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800600:	01 d0                	add    %edx,%eax
  800602:	c1 e0 02             	shl    $0x2,%eax
  800605:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80060a:	a3 40 40 80 00       	mov    %eax,0x804040

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80060f:	a1 40 40 80 00       	mov    0x804040,%eax
  800614:	8a 40 20             	mov    0x20(%eax),%al
  800617:	84 c0                	test   %al,%al
  800619:	74 0d                	je     800628 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  80061b:	a1 40 40 80 00       	mov    0x804040,%eax
  800620:	83 c0 20             	add    $0x20,%eax
  800623:	a3 20 40 80 00       	mov    %eax,0x804020

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800628:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80062c:	7e 0a                	jle    800638 <libmain+0x5f>
		binaryname = argv[0];
  80062e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800631:	8b 00                	mov    (%eax),%eax
  800633:	a3 20 40 80 00       	mov    %eax,0x804020

	// call user main routine
	_main(argc, argv);
  800638:	83 ec 08             	sub    $0x8,%esp
  80063b:	ff 75 0c             	pushl  0xc(%ebp)
  80063e:	ff 75 08             	pushl  0x8(%ebp)
  800641:	e8 7a fa ff ff       	call   8000c0 <_main>
  800646:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800649:	a1 1c 40 80 00       	mov    0x80401c,%eax
  80064e:	85 c0                	test   %eax,%eax
  800650:	0f 84 01 01 00 00    	je     800757 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800656:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80065c:	bb d4 28 80 00       	mov    $0x8028d4,%ebx
  800661:	ba 0e 00 00 00       	mov    $0xe,%edx
  800666:	89 c7                	mov    %eax,%edi
  800668:	89 de                	mov    %ebx,%esi
  80066a:	89 d1                	mov    %edx,%ecx
  80066c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80066e:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800671:	b9 56 00 00 00       	mov    $0x56,%ecx
  800676:	b0 00                	mov    $0x0,%al
  800678:	89 d7                	mov    %edx,%edi
  80067a:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80067c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800683:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800686:	83 ec 08             	sub    $0x8,%esp
  800689:	50                   	push   %eax
  80068a:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800690:	50                   	push   %eax
  800691:	e8 7b 19 00 00       	call   802011 <sys_utilities>
  800696:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800699:	e8 c4 14 00 00       	call   801b62 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80069e:	83 ec 0c             	sub    $0xc,%esp
  8006a1:	68 f4 27 80 00       	push   $0x8027f4
  8006a6:	e8 ac 03 00 00       	call   800a57 <cprintf>
  8006ab:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8006ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006b1:	85 c0                	test   %eax,%eax
  8006b3:	74 18                	je     8006cd <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8006b5:	e8 75 19 00 00       	call   80202f <sys_get_optimal_num_faults>
  8006ba:	83 ec 08             	sub    $0x8,%esp
  8006bd:	50                   	push   %eax
  8006be:	68 1c 28 80 00       	push   $0x80281c
  8006c3:	e8 8f 03 00 00       	call   800a57 <cprintf>
  8006c8:	83 c4 10             	add    $0x10,%esp
  8006cb:	eb 59                	jmp    800726 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8006cd:	a1 40 40 80 00       	mov    0x804040,%eax
  8006d2:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8006d8:	a1 40 40 80 00       	mov    0x804040,%eax
  8006dd:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  8006e3:	83 ec 04             	sub    $0x4,%esp
  8006e6:	52                   	push   %edx
  8006e7:	50                   	push   %eax
  8006e8:	68 40 28 80 00       	push   $0x802840
  8006ed:	e8 65 03 00 00       	call   800a57 <cprintf>
  8006f2:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8006f5:	a1 40 40 80 00       	mov    0x804040,%eax
  8006fa:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800700:	a1 40 40 80 00       	mov    0x804040,%eax
  800705:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  80070b:	a1 40 40 80 00       	mov    0x804040,%eax
  800710:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  800716:	51                   	push   %ecx
  800717:	52                   	push   %edx
  800718:	50                   	push   %eax
  800719:	68 68 28 80 00       	push   $0x802868
  80071e:	e8 34 03 00 00       	call   800a57 <cprintf>
  800723:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800726:	a1 40 40 80 00       	mov    0x804040,%eax
  80072b:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  800731:	83 ec 08             	sub    $0x8,%esp
  800734:	50                   	push   %eax
  800735:	68 c0 28 80 00       	push   $0x8028c0
  80073a:	e8 18 03 00 00       	call   800a57 <cprintf>
  80073f:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800742:	83 ec 0c             	sub    $0xc,%esp
  800745:	68 f4 27 80 00       	push   $0x8027f4
  80074a:	e8 08 03 00 00       	call   800a57 <cprintf>
  80074f:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800752:	e8 25 14 00 00       	call   801b7c <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800757:	e8 1f 00 00 00       	call   80077b <exit>
}
  80075c:	90                   	nop
  80075d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800760:	5b                   	pop    %ebx
  800761:	5e                   	pop    %esi
  800762:	5f                   	pop    %edi
  800763:	5d                   	pop    %ebp
  800764:	c3                   	ret    

00800765 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800765:	55                   	push   %ebp
  800766:	89 e5                	mov    %esp,%ebp
  800768:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80076b:	83 ec 0c             	sub    $0xc,%esp
  80076e:	6a 00                	push   $0x0
  800770:	e8 32 16 00 00       	call   801da7 <sys_destroy_env>
  800775:	83 c4 10             	add    $0x10,%esp
}
  800778:	90                   	nop
  800779:	c9                   	leave  
  80077a:	c3                   	ret    

0080077b <exit>:

void
exit(void)
{
  80077b:	55                   	push   %ebp
  80077c:	89 e5                	mov    %esp,%ebp
  80077e:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800781:	e8 87 16 00 00       	call   801e0d <sys_exit_env>
}
  800786:	90                   	nop
  800787:	c9                   	leave  
  800788:	c3                   	ret    

00800789 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800789:	55                   	push   %ebp
  80078a:	89 e5                	mov    %esp,%ebp
  80078c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80078f:	8d 45 10             	lea    0x10(%ebp),%eax
  800792:	83 c0 04             	add    $0x4,%eax
  800795:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800798:	a1 38 03 82 00       	mov    0x820338,%eax
  80079d:	85 c0                	test   %eax,%eax
  80079f:	74 16                	je     8007b7 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8007a1:	a1 38 03 82 00       	mov    0x820338,%eax
  8007a6:	83 ec 08             	sub    $0x8,%esp
  8007a9:	50                   	push   %eax
  8007aa:	68 38 29 80 00       	push   $0x802938
  8007af:	e8 a3 02 00 00       	call   800a57 <cprintf>
  8007b4:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8007b7:	a1 20 40 80 00       	mov    0x804020,%eax
  8007bc:	83 ec 0c             	sub    $0xc,%esp
  8007bf:	ff 75 0c             	pushl  0xc(%ebp)
  8007c2:	ff 75 08             	pushl  0x8(%ebp)
  8007c5:	50                   	push   %eax
  8007c6:	68 40 29 80 00       	push   $0x802940
  8007cb:	6a 74                	push   $0x74
  8007cd:	e8 b2 02 00 00       	call   800a84 <cprintf_colored>
  8007d2:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8007d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8007d8:	83 ec 08             	sub    $0x8,%esp
  8007db:	ff 75 f4             	pushl  -0xc(%ebp)
  8007de:	50                   	push   %eax
  8007df:	e8 04 02 00 00       	call   8009e8 <vcprintf>
  8007e4:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8007e7:	83 ec 08             	sub    $0x8,%esp
  8007ea:	6a 00                	push   $0x0
  8007ec:	68 68 29 80 00       	push   $0x802968
  8007f1:	e8 f2 01 00 00       	call   8009e8 <vcprintf>
  8007f6:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8007f9:	e8 7d ff ff ff       	call   80077b <exit>

	// should not return here
	while (1) ;
  8007fe:	eb fe                	jmp    8007fe <_panic+0x75>

00800800 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800800:	55                   	push   %ebp
  800801:	89 e5                	mov    %esp,%ebp
  800803:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800806:	a1 40 40 80 00       	mov    0x804040,%eax
  80080b:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800811:	8b 45 0c             	mov    0xc(%ebp),%eax
  800814:	39 c2                	cmp    %eax,%edx
  800816:	74 14                	je     80082c <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800818:	83 ec 04             	sub    $0x4,%esp
  80081b:	68 6c 29 80 00       	push   $0x80296c
  800820:	6a 26                	push   $0x26
  800822:	68 b8 29 80 00       	push   $0x8029b8
  800827:	e8 5d ff ff ff       	call   800789 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80082c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800833:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80083a:	e9 c5 00 00 00       	jmp    800904 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80083f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800842:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800849:	8b 45 08             	mov    0x8(%ebp),%eax
  80084c:	01 d0                	add    %edx,%eax
  80084e:	8b 00                	mov    (%eax),%eax
  800850:	85 c0                	test   %eax,%eax
  800852:	75 08                	jne    80085c <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800854:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800857:	e9 a5 00 00 00       	jmp    800901 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80085c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800863:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80086a:	eb 69                	jmp    8008d5 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80086c:	a1 40 40 80 00       	mov    0x804040,%eax
  800871:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800877:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80087a:	89 d0                	mov    %edx,%eax
  80087c:	01 c0                	add    %eax,%eax
  80087e:	01 d0                	add    %edx,%eax
  800880:	c1 e0 03             	shl    $0x3,%eax
  800883:	01 c8                	add    %ecx,%eax
  800885:	8a 40 04             	mov    0x4(%eax),%al
  800888:	84 c0                	test   %al,%al
  80088a:	75 46                	jne    8008d2 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80088c:	a1 40 40 80 00       	mov    0x804040,%eax
  800891:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800897:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80089a:	89 d0                	mov    %edx,%eax
  80089c:	01 c0                	add    %eax,%eax
  80089e:	01 d0                	add    %edx,%eax
  8008a0:	c1 e0 03             	shl    $0x3,%eax
  8008a3:	01 c8                	add    %ecx,%eax
  8008a5:	8b 00                	mov    (%eax),%eax
  8008a7:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8008aa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8008ad:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008b2:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8008b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008b7:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8008be:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c1:	01 c8                	add    %ecx,%eax
  8008c3:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008c5:	39 c2                	cmp    %eax,%edx
  8008c7:	75 09                	jne    8008d2 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8008c9:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8008d0:	eb 15                	jmp    8008e7 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008d2:	ff 45 e8             	incl   -0x18(%ebp)
  8008d5:	a1 40 40 80 00       	mov    0x804040,%eax
  8008da:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8008e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008e3:	39 c2                	cmp    %eax,%edx
  8008e5:	77 85                	ja     80086c <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8008e7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8008eb:	75 14                	jne    800901 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8008ed:	83 ec 04             	sub    $0x4,%esp
  8008f0:	68 c4 29 80 00       	push   $0x8029c4
  8008f5:	6a 3a                	push   $0x3a
  8008f7:	68 b8 29 80 00       	push   $0x8029b8
  8008fc:	e8 88 fe ff ff       	call   800789 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800901:	ff 45 f0             	incl   -0x10(%ebp)
  800904:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800907:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80090a:	0f 8c 2f ff ff ff    	jl     80083f <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800910:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800917:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80091e:	eb 26                	jmp    800946 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800920:	a1 40 40 80 00       	mov    0x804040,%eax
  800925:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80092b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80092e:	89 d0                	mov    %edx,%eax
  800930:	01 c0                	add    %eax,%eax
  800932:	01 d0                	add    %edx,%eax
  800934:	c1 e0 03             	shl    $0x3,%eax
  800937:	01 c8                	add    %ecx,%eax
  800939:	8a 40 04             	mov    0x4(%eax),%al
  80093c:	3c 01                	cmp    $0x1,%al
  80093e:	75 03                	jne    800943 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800940:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800943:	ff 45 e0             	incl   -0x20(%ebp)
  800946:	a1 40 40 80 00       	mov    0x804040,%eax
  80094b:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800951:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800954:	39 c2                	cmp    %eax,%edx
  800956:	77 c8                	ja     800920 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800958:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80095b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80095e:	74 14                	je     800974 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800960:	83 ec 04             	sub    $0x4,%esp
  800963:	68 18 2a 80 00       	push   $0x802a18
  800968:	6a 44                	push   $0x44
  80096a:	68 b8 29 80 00       	push   $0x8029b8
  80096f:	e8 15 fe ff ff       	call   800789 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800974:	90                   	nop
  800975:	c9                   	leave  
  800976:	c3                   	ret    

00800977 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800977:	55                   	push   %ebp
  800978:	89 e5                	mov    %esp,%ebp
  80097a:	53                   	push   %ebx
  80097b:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  80097e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800981:	8b 00                	mov    (%eax),%eax
  800983:	8d 48 01             	lea    0x1(%eax),%ecx
  800986:	8b 55 0c             	mov    0xc(%ebp),%edx
  800989:	89 0a                	mov    %ecx,(%edx)
  80098b:	8b 55 08             	mov    0x8(%ebp),%edx
  80098e:	88 d1                	mov    %dl,%cl
  800990:	8b 55 0c             	mov    0xc(%ebp),%edx
  800993:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800997:	8b 45 0c             	mov    0xc(%ebp),%eax
  80099a:	8b 00                	mov    (%eax),%eax
  80099c:	3d ff 00 00 00       	cmp    $0xff,%eax
  8009a1:	75 30                	jne    8009d3 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8009a3:	8b 15 3c 03 82 00    	mov    0x82033c,%edx
  8009a9:	a0 64 40 80 00       	mov    0x804064,%al
  8009ae:	0f b6 c0             	movzbl %al,%eax
  8009b1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009b4:	8b 09                	mov    (%ecx),%ecx
  8009b6:	89 cb                	mov    %ecx,%ebx
  8009b8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009bb:	83 c1 08             	add    $0x8,%ecx
  8009be:	52                   	push   %edx
  8009bf:	50                   	push   %eax
  8009c0:	53                   	push   %ebx
  8009c1:	51                   	push   %ecx
  8009c2:	e8 57 11 00 00       	call   801b1e <sys_cputs>
  8009c7:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8009ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8009d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009d6:	8b 40 04             	mov    0x4(%eax),%eax
  8009d9:	8d 50 01             	lea    0x1(%eax),%edx
  8009dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009df:	89 50 04             	mov    %edx,0x4(%eax)
}
  8009e2:	90                   	nop
  8009e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009e6:	c9                   	leave  
  8009e7:	c3                   	ret    

008009e8 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8009e8:	55                   	push   %ebp
  8009e9:	89 e5                	mov    %esp,%ebp
  8009eb:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8009f1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8009f8:	00 00 00 
	b.cnt = 0;
  8009fb:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800a02:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800a05:	ff 75 0c             	pushl  0xc(%ebp)
  800a08:	ff 75 08             	pushl  0x8(%ebp)
  800a0b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a11:	50                   	push   %eax
  800a12:	68 77 09 80 00       	push   $0x800977
  800a17:	e8 5a 02 00 00       	call   800c76 <vprintfmt>
  800a1c:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800a1f:	8b 15 3c 03 82 00    	mov    0x82033c,%edx
  800a25:	a0 64 40 80 00       	mov    0x804064,%al
  800a2a:	0f b6 c0             	movzbl %al,%eax
  800a2d:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800a33:	52                   	push   %edx
  800a34:	50                   	push   %eax
  800a35:	51                   	push   %ecx
  800a36:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a3c:	83 c0 08             	add    $0x8,%eax
  800a3f:	50                   	push   %eax
  800a40:	e8 d9 10 00 00       	call   801b1e <sys_cputs>
  800a45:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800a48:	c6 05 64 40 80 00 00 	movb   $0x0,0x804064
	return b.cnt;
  800a4f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a55:	c9                   	leave  
  800a56:	c3                   	ret    

00800a57 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800a57:	55                   	push   %ebp
  800a58:	89 e5                	mov    %esp,%ebp
  800a5a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a5d:	c6 05 64 40 80 00 01 	movb   $0x1,0x804064
	va_start(ap, fmt);
  800a64:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a67:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6d:	83 ec 08             	sub    $0x8,%esp
  800a70:	ff 75 f4             	pushl  -0xc(%ebp)
  800a73:	50                   	push   %eax
  800a74:	e8 6f ff ff ff       	call   8009e8 <vcprintf>
  800a79:	83 c4 10             	add    $0x10,%esp
  800a7c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a82:	c9                   	leave  
  800a83:	c3                   	ret    

00800a84 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800a84:	55                   	push   %ebp
  800a85:	89 e5                	mov    %esp,%ebp
  800a87:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a8a:	c6 05 64 40 80 00 01 	movb   $0x1,0x804064
	curTextClr = (textClr << 8) ; //set text color by the given value
  800a91:	8b 45 08             	mov    0x8(%ebp),%eax
  800a94:	c1 e0 08             	shl    $0x8,%eax
  800a97:	a3 3c 03 82 00       	mov    %eax,0x82033c
	va_start(ap, fmt);
  800a9c:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a9f:	83 c0 04             	add    $0x4,%eax
  800aa2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800aa5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aa8:	83 ec 08             	sub    $0x8,%esp
  800aab:	ff 75 f4             	pushl  -0xc(%ebp)
  800aae:	50                   	push   %eax
  800aaf:	e8 34 ff ff ff       	call   8009e8 <vcprintf>
  800ab4:	83 c4 10             	add    $0x10,%esp
  800ab7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800aba:	c7 05 3c 03 82 00 00 	movl   $0x700,0x82033c
  800ac1:	07 00 00 

	return cnt;
  800ac4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ac7:	c9                   	leave  
  800ac8:	c3                   	ret    

00800ac9 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800ac9:	55                   	push   %ebp
  800aca:	89 e5                	mov    %esp,%ebp
  800acc:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800acf:	e8 8e 10 00 00       	call   801b62 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800ad4:	8d 45 0c             	lea    0xc(%ebp),%eax
  800ad7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800ada:	8b 45 08             	mov    0x8(%ebp),%eax
  800add:	83 ec 08             	sub    $0x8,%esp
  800ae0:	ff 75 f4             	pushl  -0xc(%ebp)
  800ae3:	50                   	push   %eax
  800ae4:	e8 ff fe ff ff       	call   8009e8 <vcprintf>
  800ae9:	83 c4 10             	add    $0x10,%esp
  800aec:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800aef:	e8 88 10 00 00       	call   801b7c <sys_unlock_cons>
	return cnt;
  800af4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800af7:	c9                   	leave  
  800af8:	c3                   	ret    

00800af9 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800af9:	55                   	push   %ebp
  800afa:	89 e5                	mov    %esp,%ebp
  800afc:	53                   	push   %ebx
  800afd:	83 ec 14             	sub    $0x14,%esp
  800b00:	8b 45 10             	mov    0x10(%ebp),%eax
  800b03:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b06:	8b 45 14             	mov    0x14(%ebp),%eax
  800b09:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800b0c:	8b 45 18             	mov    0x18(%ebp),%eax
  800b0f:	ba 00 00 00 00       	mov    $0x0,%edx
  800b14:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b17:	77 55                	ja     800b6e <printnum+0x75>
  800b19:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b1c:	72 05                	jb     800b23 <printnum+0x2a>
  800b1e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800b21:	77 4b                	ja     800b6e <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800b23:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800b26:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800b29:	8b 45 18             	mov    0x18(%ebp),%eax
  800b2c:	ba 00 00 00 00       	mov    $0x0,%edx
  800b31:	52                   	push   %edx
  800b32:	50                   	push   %eax
  800b33:	ff 75 f4             	pushl  -0xc(%ebp)
  800b36:	ff 75 f0             	pushl  -0x10(%ebp)
  800b39:	e8 aa 16 00 00       	call   8021e8 <__udivdi3>
  800b3e:	83 c4 10             	add    $0x10,%esp
  800b41:	83 ec 04             	sub    $0x4,%esp
  800b44:	ff 75 20             	pushl  0x20(%ebp)
  800b47:	53                   	push   %ebx
  800b48:	ff 75 18             	pushl  0x18(%ebp)
  800b4b:	52                   	push   %edx
  800b4c:	50                   	push   %eax
  800b4d:	ff 75 0c             	pushl  0xc(%ebp)
  800b50:	ff 75 08             	pushl  0x8(%ebp)
  800b53:	e8 a1 ff ff ff       	call   800af9 <printnum>
  800b58:	83 c4 20             	add    $0x20,%esp
  800b5b:	eb 1a                	jmp    800b77 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800b5d:	83 ec 08             	sub    $0x8,%esp
  800b60:	ff 75 0c             	pushl  0xc(%ebp)
  800b63:	ff 75 20             	pushl  0x20(%ebp)
  800b66:	8b 45 08             	mov    0x8(%ebp),%eax
  800b69:	ff d0                	call   *%eax
  800b6b:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800b6e:	ff 4d 1c             	decl   0x1c(%ebp)
  800b71:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800b75:	7f e6                	jg     800b5d <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800b77:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800b7a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b82:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b85:	53                   	push   %ebx
  800b86:	51                   	push   %ecx
  800b87:	52                   	push   %edx
  800b88:	50                   	push   %eax
  800b89:	e8 6a 17 00 00       	call   8022f8 <__umoddi3>
  800b8e:	83 c4 10             	add    $0x10,%esp
  800b91:	05 94 2c 80 00       	add    $0x802c94,%eax
  800b96:	8a 00                	mov    (%eax),%al
  800b98:	0f be c0             	movsbl %al,%eax
  800b9b:	83 ec 08             	sub    $0x8,%esp
  800b9e:	ff 75 0c             	pushl  0xc(%ebp)
  800ba1:	50                   	push   %eax
  800ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba5:	ff d0                	call   *%eax
  800ba7:	83 c4 10             	add    $0x10,%esp
}
  800baa:	90                   	nop
  800bab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800bae:	c9                   	leave  
  800baf:	c3                   	ret    

00800bb0 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800bb0:	55                   	push   %ebp
  800bb1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800bb3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800bb7:	7e 1c                	jle    800bd5 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbc:	8b 00                	mov    (%eax),%eax
  800bbe:	8d 50 08             	lea    0x8(%eax),%edx
  800bc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc4:	89 10                	mov    %edx,(%eax)
  800bc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc9:	8b 00                	mov    (%eax),%eax
  800bcb:	83 e8 08             	sub    $0x8,%eax
  800bce:	8b 50 04             	mov    0x4(%eax),%edx
  800bd1:	8b 00                	mov    (%eax),%eax
  800bd3:	eb 40                	jmp    800c15 <getuint+0x65>
	else if (lflag)
  800bd5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bd9:	74 1e                	je     800bf9 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bde:	8b 00                	mov    (%eax),%eax
  800be0:	8d 50 04             	lea    0x4(%eax),%edx
  800be3:	8b 45 08             	mov    0x8(%ebp),%eax
  800be6:	89 10                	mov    %edx,(%eax)
  800be8:	8b 45 08             	mov    0x8(%ebp),%eax
  800beb:	8b 00                	mov    (%eax),%eax
  800bed:	83 e8 04             	sub    $0x4,%eax
  800bf0:	8b 00                	mov    (%eax),%eax
  800bf2:	ba 00 00 00 00       	mov    $0x0,%edx
  800bf7:	eb 1c                	jmp    800c15 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfc:	8b 00                	mov    (%eax),%eax
  800bfe:	8d 50 04             	lea    0x4(%eax),%edx
  800c01:	8b 45 08             	mov    0x8(%ebp),%eax
  800c04:	89 10                	mov    %edx,(%eax)
  800c06:	8b 45 08             	mov    0x8(%ebp),%eax
  800c09:	8b 00                	mov    (%eax),%eax
  800c0b:	83 e8 04             	sub    $0x4,%eax
  800c0e:	8b 00                	mov    (%eax),%eax
  800c10:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800c15:	5d                   	pop    %ebp
  800c16:	c3                   	ret    

00800c17 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800c17:	55                   	push   %ebp
  800c18:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c1a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c1e:	7e 1c                	jle    800c3c <getint+0x25>
		return va_arg(*ap, long long);
  800c20:	8b 45 08             	mov    0x8(%ebp),%eax
  800c23:	8b 00                	mov    (%eax),%eax
  800c25:	8d 50 08             	lea    0x8(%eax),%edx
  800c28:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2b:	89 10                	mov    %edx,(%eax)
  800c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c30:	8b 00                	mov    (%eax),%eax
  800c32:	83 e8 08             	sub    $0x8,%eax
  800c35:	8b 50 04             	mov    0x4(%eax),%edx
  800c38:	8b 00                	mov    (%eax),%eax
  800c3a:	eb 38                	jmp    800c74 <getint+0x5d>
	else if (lflag)
  800c3c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c40:	74 1a                	je     800c5c <getint+0x45>
		return va_arg(*ap, long);
  800c42:	8b 45 08             	mov    0x8(%ebp),%eax
  800c45:	8b 00                	mov    (%eax),%eax
  800c47:	8d 50 04             	lea    0x4(%eax),%edx
  800c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4d:	89 10                	mov    %edx,(%eax)
  800c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c52:	8b 00                	mov    (%eax),%eax
  800c54:	83 e8 04             	sub    $0x4,%eax
  800c57:	8b 00                	mov    (%eax),%eax
  800c59:	99                   	cltd   
  800c5a:	eb 18                	jmp    800c74 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800c5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5f:	8b 00                	mov    (%eax),%eax
  800c61:	8d 50 04             	lea    0x4(%eax),%edx
  800c64:	8b 45 08             	mov    0x8(%ebp),%eax
  800c67:	89 10                	mov    %edx,(%eax)
  800c69:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6c:	8b 00                	mov    (%eax),%eax
  800c6e:	83 e8 04             	sub    $0x4,%eax
  800c71:	8b 00                	mov    (%eax),%eax
  800c73:	99                   	cltd   
}
  800c74:	5d                   	pop    %ebp
  800c75:	c3                   	ret    

00800c76 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800c76:	55                   	push   %ebp
  800c77:	89 e5                	mov    %esp,%ebp
  800c79:	56                   	push   %esi
  800c7a:	53                   	push   %ebx
  800c7b:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c7e:	eb 17                	jmp    800c97 <vprintfmt+0x21>
			if (ch == '\0')
  800c80:	85 db                	test   %ebx,%ebx
  800c82:	0f 84 c1 03 00 00    	je     801049 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800c88:	83 ec 08             	sub    $0x8,%esp
  800c8b:	ff 75 0c             	pushl  0xc(%ebp)
  800c8e:	53                   	push   %ebx
  800c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c92:	ff d0                	call   *%eax
  800c94:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c97:	8b 45 10             	mov    0x10(%ebp),%eax
  800c9a:	8d 50 01             	lea    0x1(%eax),%edx
  800c9d:	89 55 10             	mov    %edx,0x10(%ebp)
  800ca0:	8a 00                	mov    (%eax),%al
  800ca2:	0f b6 d8             	movzbl %al,%ebx
  800ca5:	83 fb 25             	cmp    $0x25,%ebx
  800ca8:	75 d6                	jne    800c80 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800caa:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800cae:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800cb5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800cbc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800cc3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800cca:	8b 45 10             	mov    0x10(%ebp),%eax
  800ccd:	8d 50 01             	lea    0x1(%eax),%edx
  800cd0:	89 55 10             	mov    %edx,0x10(%ebp)
  800cd3:	8a 00                	mov    (%eax),%al
  800cd5:	0f b6 d8             	movzbl %al,%ebx
  800cd8:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800cdb:	83 f8 5b             	cmp    $0x5b,%eax
  800cde:	0f 87 3d 03 00 00    	ja     801021 <vprintfmt+0x3ab>
  800ce4:	8b 04 85 b8 2c 80 00 	mov    0x802cb8(,%eax,4),%eax
  800ceb:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800ced:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800cf1:	eb d7                	jmp    800cca <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800cf3:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800cf7:	eb d1                	jmp    800cca <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cf9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800d00:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800d03:	89 d0                	mov    %edx,%eax
  800d05:	c1 e0 02             	shl    $0x2,%eax
  800d08:	01 d0                	add    %edx,%eax
  800d0a:	01 c0                	add    %eax,%eax
  800d0c:	01 d8                	add    %ebx,%eax
  800d0e:	83 e8 30             	sub    $0x30,%eax
  800d11:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800d14:	8b 45 10             	mov    0x10(%ebp),%eax
  800d17:	8a 00                	mov    (%eax),%al
  800d19:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800d1c:	83 fb 2f             	cmp    $0x2f,%ebx
  800d1f:	7e 3e                	jle    800d5f <vprintfmt+0xe9>
  800d21:	83 fb 39             	cmp    $0x39,%ebx
  800d24:	7f 39                	jg     800d5f <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d26:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800d29:	eb d5                	jmp    800d00 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800d2b:	8b 45 14             	mov    0x14(%ebp),%eax
  800d2e:	83 c0 04             	add    $0x4,%eax
  800d31:	89 45 14             	mov    %eax,0x14(%ebp)
  800d34:	8b 45 14             	mov    0x14(%ebp),%eax
  800d37:	83 e8 04             	sub    $0x4,%eax
  800d3a:	8b 00                	mov    (%eax),%eax
  800d3c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800d3f:	eb 1f                	jmp    800d60 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800d41:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d45:	79 83                	jns    800cca <vprintfmt+0x54>
				width = 0;
  800d47:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800d4e:	e9 77 ff ff ff       	jmp    800cca <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800d53:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800d5a:	e9 6b ff ff ff       	jmp    800cca <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800d5f:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800d60:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d64:	0f 89 60 ff ff ff    	jns    800cca <vprintfmt+0x54>
				width = precision, precision = -1;
  800d6a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d6d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d70:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800d77:	e9 4e ff ff ff       	jmp    800cca <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d7c:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800d7f:	e9 46 ff ff ff       	jmp    800cca <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800d84:	8b 45 14             	mov    0x14(%ebp),%eax
  800d87:	83 c0 04             	add    $0x4,%eax
  800d8a:	89 45 14             	mov    %eax,0x14(%ebp)
  800d8d:	8b 45 14             	mov    0x14(%ebp),%eax
  800d90:	83 e8 04             	sub    $0x4,%eax
  800d93:	8b 00                	mov    (%eax),%eax
  800d95:	83 ec 08             	sub    $0x8,%esp
  800d98:	ff 75 0c             	pushl  0xc(%ebp)
  800d9b:	50                   	push   %eax
  800d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9f:	ff d0                	call   *%eax
  800da1:	83 c4 10             	add    $0x10,%esp
			break;
  800da4:	e9 9b 02 00 00       	jmp    801044 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800da9:	8b 45 14             	mov    0x14(%ebp),%eax
  800dac:	83 c0 04             	add    $0x4,%eax
  800daf:	89 45 14             	mov    %eax,0x14(%ebp)
  800db2:	8b 45 14             	mov    0x14(%ebp),%eax
  800db5:	83 e8 04             	sub    $0x4,%eax
  800db8:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800dba:	85 db                	test   %ebx,%ebx
  800dbc:	79 02                	jns    800dc0 <vprintfmt+0x14a>
				err = -err;
  800dbe:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800dc0:	83 fb 64             	cmp    $0x64,%ebx
  800dc3:	7f 0b                	jg     800dd0 <vprintfmt+0x15a>
  800dc5:	8b 34 9d 00 2b 80 00 	mov    0x802b00(,%ebx,4),%esi
  800dcc:	85 f6                	test   %esi,%esi
  800dce:	75 19                	jne    800de9 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800dd0:	53                   	push   %ebx
  800dd1:	68 a5 2c 80 00       	push   $0x802ca5
  800dd6:	ff 75 0c             	pushl  0xc(%ebp)
  800dd9:	ff 75 08             	pushl  0x8(%ebp)
  800ddc:	e8 70 02 00 00       	call   801051 <printfmt>
  800de1:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800de4:	e9 5b 02 00 00       	jmp    801044 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800de9:	56                   	push   %esi
  800dea:	68 ae 2c 80 00       	push   $0x802cae
  800def:	ff 75 0c             	pushl  0xc(%ebp)
  800df2:	ff 75 08             	pushl  0x8(%ebp)
  800df5:	e8 57 02 00 00       	call   801051 <printfmt>
  800dfa:	83 c4 10             	add    $0x10,%esp
			break;
  800dfd:	e9 42 02 00 00       	jmp    801044 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800e02:	8b 45 14             	mov    0x14(%ebp),%eax
  800e05:	83 c0 04             	add    $0x4,%eax
  800e08:	89 45 14             	mov    %eax,0x14(%ebp)
  800e0b:	8b 45 14             	mov    0x14(%ebp),%eax
  800e0e:	83 e8 04             	sub    $0x4,%eax
  800e11:	8b 30                	mov    (%eax),%esi
  800e13:	85 f6                	test   %esi,%esi
  800e15:	75 05                	jne    800e1c <vprintfmt+0x1a6>
				p = "(null)";
  800e17:	be b1 2c 80 00       	mov    $0x802cb1,%esi
			if (width > 0 && padc != '-')
  800e1c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e20:	7e 6d                	jle    800e8f <vprintfmt+0x219>
  800e22:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800e26:	74 67                	je     800e8f <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e28:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e2b:	83 ec 08             	sub    $0x8,%esp
  800e2e:	50                   	push   %eax
  800e2f:	56                   	push   %esi
  800e30:	e8 1e 03 00 00       	call   801153 <strnlen>
  800e35:	83 c4 10             	add    $0x10,%esp
  800e38:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800e3b:	eb 16                	jmp    800e53 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800e3d:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800e41:	83 ec 08             	sub    $0x8,%esp
  800e44:	ff 75 0c             	pushl  0xc(%ebp)
  800e47:	50                   	push   %eax
  800e48:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4b:	ff d0                	call   *%eax
  800e4d:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e50:	ff 4d e4             	decl   -0x1c(%ebp)
  800e53:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e57:	7f e4                	jg     800e3d <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e59:	eb 34                	jmp    800e8f <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800e5b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800e5f:	74 1c                	je     800e7d <vprintfmt+0x207>
  800e61:	83 fb 1f             	cmp    $0x1f,%ebx
  800e64:	7e 05                	jle    800e6b <vprintfmt+0x1f5>
  800e66:	83 fb 7e             	cmp    $0x7e,%ebx
  800e69:	7e 12                	jle    800e7d <vprintfmt+0x207>
					putch('?', putdat);
  800e6b:	83 ec 08             	sub    $0x8,%esp
  800e6e:	ff 75 0c             	pushl  0xc(%ebp)
  800e71:	6a 3f                	push   $0x3f
  800e73:	8b 45 08             	mov    0x8(%ebp),%eax
  800e76:	ff d0                	call   *%eax
  800e78:	83 c4 10             	add    $0x10,%esp
  800e7b:	eb 0f                	jmp    800e8c <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800e7d:	83 ec 08             	sub    $0x8,%esp
  800e80:	ff 75 0c             	pushl  0xc(%ebp)
  800e83:	53                   	push   %ebx
  800e84:	8b 45 08             	mov    0x8(%ebp),%eax
  800e87:	ff d0                	call   *%eax
  800e89:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e8c:	ff 4d e4             	decl   -0x1c(%ebp)
  800e8f:	89 f0                	mov    %esi,%eax
  800e91:	8d 70 01             	lea    0x1(%eax),%esi
  800e94:	8a 00                	mov    (%eax),%al
  800e96:	0f be d8             	movsbl %al,%ebx
  800e99:	85 db                	test   %ebx,%ebx
  800e9b:	74 24                	je     800ec1 <vprintfmt+0x24b>
  800e9d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ea1:	78 b8                	js     800e5b <vprintfmt+0x1e5>
  800ea3:	ff 4d e0             	decl   -0x20(%ebp)
  800ea6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800eaa:	79 af                	jns    800e5b <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800eac:	eb 13                	jmp    800ec1 <vprintfmt+0x24b>
				putch(' ', putdat);
  800eae:	83 ec 08             	sub    $0x8,%esp
  800eb1:	ff 75 0c             	pushl  0xc(%ebp)
  800eb4:	6a 20                	push   $0x20
  800eb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb9:	ff d0                	call   *%eax
  800ebb:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ebe:	ff 4d e4             	decl   -0x1c(%ebp)
  800ec1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ec5:	7f e7                	jg     800eae <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800ec7:	e9 78 01 00 00       	jmp    801044 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ecc:	83 ec 08             	sub    $0x8,%esp
  800ecf:	ff 75 e8             	pushl  -0x18(%ebp)
  800ed2:	8d 45 14             	lea    0x14(%ebp),%eax
  800ed5:	50                   	push   %eax
  800ed6:	e8 3c fd ff ff       	call   800c17 <getint>
  800edb:	83 c4 10             	add    $0x10,%esp
  800ede:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ee1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800ee4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ee7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eea:	85 d2                	test   %edx,%edx
  800eec:	79 23                	jns    800f11 <vprintfmt+0x29b>
				putch('-', putdat);
  800eee:	83 ec 08             	sub    $0x8,%esp
  800ef1:	ff 75 0c             	pushl  0xc(%ebp)
  800ef4:	6a 2d                	push   $0x2d
  800ef6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef9:	ff d0                	call   *%eax
  800efb:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800efe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f01:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f04:	f7 d8                	neg    %eax
  800f06:	83 d2 00             	adc    $0x0,%edx
  800f09:	f7 da                	neg    %edx
  800f0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f0e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800f11:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f18:	e9 bc 00 00 00       	jmp    800fd9 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800f1d:	83 ec 08             	sub    $0x8,%esp
  800f20:	ff 75 e8             	pushl  -0x18(%ebp)
  800f23:	8d 45 14             	lea    0x14(%ebp),%eax
  800f26:	50                   	push   %eax
  800f27:	e8 84 fc ff ff       	call   800bb0 <getuint>
  800f2c:	83 c4 10             	add    $0x10,%esp
  800f2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f32:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800f35:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f3c:	e9 98 00 00 00       	jmp    800fd9 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800f41:	83 ec 08             	sub    $0x8,%esp
  800f44:	ff 75 0c             	pushl  0xc(%ebp)
  800f47:	6a 58                	push   $0x58
  800f49:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4c:	ff d0                	call   *%eax
  800f4e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f51:	83 ec 08             	sub    $0x8,%esp
  800f54:	ff 75 0c             	pushl  0xc(%ebp)
  800f57:	6a 58                	push   $0x58
  800f59:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5c:	ff d0                	call   *%eax
  800f5e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f61:	83 ec 08             	sub    $0x8,%esp
  800f64:	ff 75 0c             	pushl  0xc(%ebp)
  800f67:	6a 58                	push   $0x58
  800f69:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6c:	ff d0                	call   *%eax
  800f6e:	83 c4 10             	add    $0x10,%esp
			break;
  800f71:	e9 ce 00 00 00       	jmp    801044 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800f76:	83 ec 08             	sub    $0x8,%esp
  800f79:	ff 75 0c             	pushl  0xc(%ebp)
  800f7c:	6a 30                	push   $0x30
  800f7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f81:	ff d0                	call   *%eax
  800f83:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800f86:	83 ec 08             	sub    $0x8,%esp
  800f89:	ff 75 0c             	pushl  0xc(%ebp)
  800f8c:	6a 78                	push   $0x78
  800f8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f91:	ff d0                	call   *%eax
  800f93:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800f96:	8b 45 14             	mov    0x14(%ebp),%eax
  800f99:	83 c0 04             	add    $0x4,%eax
  800f9c:	89 45 14             	mov    %eax,0x14(%ebp)
  800f9f:	8b 45 14             	mov    0x14(%ebp),%eax
  800fa2:	83 e8 04             	sub    $0x4,%eax
  800fa5:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800fa7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800faa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800fb1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800fb8:	eb 1f                	jmp    800fd9 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800fba:	83 ec 08             	sub    $0x8,%esp
  800fbd:	ff 75 e8             	pushl  -0x18(%ebp)
  800fc0:	8d 45 14             	lea    0x14(%ebp),%eax
  800fc3:	50                   	push   %eax
  800fc4:	e8 e7 fb ff ff       	call   800bb0 <getuint>
  800fc9:	83 c4 10             	add    $0x10,%esp
  800fcc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fcf:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800fd2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800fd9:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800fdd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800fe0:	83 ec 04             	sub    $0x4,%esp
  800fe3:	52                   	push   %edx
  800fe4:	ff 75 e4             	pushl  -0x1c(%ebp)
  800fe7:	50                   	push   %eax
  800fe8:	ff 75 f4             	pushl  -0xc(%ebp)
  800feb:	ff 75 f0             	pushl  -0x10(%ebp)
  800fee:	ff 75 0c             	pushl  0xc(%ebp)
  800ff1:	ff 75 08             	pushl  0x8(%ebp)
  800ff4:	e8 00 fb ff ff       	call   800af9 <printnum>
  800ff9:	83 c4 20             	add    $0x20,%esp
			break;
  800ffc:	eb 46                	jmp    801044 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ffe:	83 ec 08             	sub    $0x8,%esp
  801001:	ff 75 0c             	pushl  0xc(%ebp)
  801004:	53                   	push   %ebx
  801005:	8b 45 08             	mov    0x8(%ebp),%eax
  801008:	ff d0                	call   *%eax
  80100a:	83 c4 10             	add    $0x10,%esp
			break;
  80100d:	eb 35                	jmp    801044 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  80100f:	c6 05 64 40 80 00 00 	movb   $0x0,0x804064
			break;
  801016:	eb 2c                	jmp    801044 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  801018:	c6 05 64 40 80 00 01 	movb   $0x1,0x804064
			break;
  80101f:	eb 23                	jmp    801044 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801021:	83 ec 08             	sub    $0x8,%esp
  801024:	ff 75 0c             	pushl  0xc(%ebp)
  801027:	6a 25                	push   $0x25
  801029:	8b 45 08             	mov    0x8(%ebp),%eax
  80102c:	ff d0                	call   *%eax
  80102e:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801031:	ff 4d 10             	decl   0x10(%ebp)
  801034:	eb 03                	jmp    801039 <vprintfmt+0x3c3>
  801036:	ff 4d 10             	decl   0x10(%ebp)
  801039:	8b 45 10             	mov    0x10(%ebp),%eax
  80103c:	48                   	dec    %eax
  80103d:	8a 00                	mov    (%eax),%al
  80103f:	3c 25                	cmp    $0x25,%al
  801041:	75 f3                	jne    801036 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  801043:	90                   	nop
		}
	}
  801044:	e9 35 fc ff ff       	jmp    800c7e <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801049:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80104a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80104d:	5b                   	pop    %ebx
  80104e:	5e                   	pop    %esi
  80104f:	5d                   	pop    %ebp
  801050:	c3                   	ret    

00801051 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801051:	55                   	push   %ebp
  801052:	89 e5                	mov    %esp,%ebp
  801054:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801057:	8d 45 10             	lea    0x10(%ebp),%eax
  80105a:	83 c0 04             	add    $0x4,%eax
  80105d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801060:	8b 45 10             	mov    0x10(%ebp),%eax
  801063:	ff 75 f4             	pushl  -0xc(%ebp)
  801066:	50                   	push   %eax
  801067:	ff 75 0c             	pushl  0xc(%ebp)
  80106a:	ff 75 08             	pushl  0x8(%ebp)
  80106d:	e8 04 fc ff ff       	call   800c76 <vprintfmt>
  801072:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801075:	90                   	nop
  801076:	c9                   	leave  
  801077:	c3                   	ret    

00801078 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801078:	55                   	push   %ebp
  801079:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80107b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107e:	8b 40 08             	mov    0x8(%eax),%eax
  801081:	8d 50 01             	lea    0x1(%eax),%edx
  801084:	8b 45 0c             	mov    0xc(%ebp),%eax
  801087:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80108a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80108d:	8b 10                	mov    (%eax),%edx
  80108f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801092:	8b 40 04             	mov    0x4(%eax),%eax
  801095:	39 c2                	cmp    %eax,%edx
  801097:	73 12                	jae    8010ab <sprintputch+0x33>
		*b->buf++ = ch;
  801099:	8b 45 0c             	mov    0xc(%ebp),%eax
  80109c:	8b 00                	mov    (%eax),%eax
  80109e:	8d 48 01             	lea    0x1(%eax),%ecx
  8010a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010a4:	89 0a                	mov    %ecx,(%edx)
  8010a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8010a9:	88 10                	mov    %dl,(%eax)
}
  8010ab:	90                   	nop
  8010ac:	5d                   	pop    %ebp
  8010ad:	c3                   	ret    

008010ae <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8010ae:	55                   	push   %ebp
  8010af:	89 e5                	mov    %esp,%ebp
  8010b1:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8010b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8010ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010bd:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c3:	01 d0                	add    %edx,%eax
  8010c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010c8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8010cf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010d3:	74 06                	je     8010db <vsnprintf+0x2d>
  8010d5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010d9:	7f 07                	jg     8010e2 <vsnprintf+0x34>
		return -E_INVAL;
  8010db:	b8 03 00 00 00       	mov    $0x3,%eax
  8010e0:	eb 20                	jmp    801102 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8010e2:	ff 75 14             	pushl  0x14(%ebp)
  8010e5:	ff 75 10             	pushl  0x10(%ebp)
  8010e8:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8010eb:	50                   	push   %eax
  8010ec:	68 78 10 80 00       	push   $0x801078
  8010f1:	e8 80 fb ff ff       	call   800c76 <vprintfmt>
  8010f6:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8010f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8010fc:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8010ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801102:	c9                   	leave  
  801103:	c3                   	ret    

00801104 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801104:	55                   	push   %ebp
  801105:	89 e5                	mov    %esp,%ebp
  801107:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80110a:	8d 45 10             	lea    0x10(%ebp),%eax
  80110d:	83 c0 04             	add    $0x4,%eax
  801110:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801113:	8b 45 10             	mov    0x10(%ebp),%eax
  801116:	ff 75 f4             	pushl  -0xc(%ebp)
  801119:	50                   	push   %eax
  80111a:	ff 75 0c             	pushl  0xc(%ebp)
  80111d:	ff 75 08             	pushl  0x8(%ebp)
  801120:	e8 89 ff ff ff       	call   8010ae <vsnprintf>
  801125:	83 c4 10             	add    $0x10,%esp
  801128:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80112b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80112e:	c9                   	leave  
  80112f:	c3                   	ret    

00801130 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801130:	55                   	push   %ebp
  801131:	89 e5                	mov    %esp,%ebp
  801133:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801136:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80113d:	eb 06                	jmp    801145 <strlen+0x15>
		n++;
  80113f:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801142:	ff 45 08             	incl   0x8(%ebp)
  801145:	8b 45 08             	mov    0x8(%ebp),%eax
  801148:	8a 00                	mov    (%eax),%al
  80114a:	84 c0                	test   %al,%al
  80114c:	75 f1                	jne    80113f <strlen+0xf>
		n++;
	return n;
  80114e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801151:	c9                   	leave  
  801152:	c3                   	ret    

00801153 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801153:	55                   	push   %ebp
  801154:	89 e5                	mov    %esp,%ebp
  801156:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801159:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801160:	eb 09                	jmp    80116b <strnlen+0x18>
		n++;
  801162:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801165:	ff 45 08             	incl   0x8(%ebp)
  801168:	ff 4d 0c             	decl   0xc(%ebp)
  80116b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80116f:	74 09                	je     80117a <strnlen+0x27>
  801171:	8b 45 08             	mov    0x8(%ebp),%eax
  801174:	8a 00                	mov    (%eax),%al
  801176:	84 c0                	test   %al,%al
  801178:	75 e8                	jne    801162 <strnlen+0xf>
		n++;
	return n;
  80117a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80117d:	c9                   	leave  
  80117e:	c3                   	ret    

0080117f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80117f:	55                   	push   %ebp
  801180:	89 e5                	mov    %esp,%ebp
  801182:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801185:	8b 45 08             	mov    0x8(%ebp),%eax
  801188:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80118b:	90                   	nop
  80118c:	8b 45 08             	mov    0x8(%ebp),%eax
  80118f:	8d 50 01             	lea    0x1(%eax),%edx
  801192:	89 55 08             	mov    %edx,0x8(%ebp)
  801195:	8b 55 0c             	mov    0xc(%ebp),%edx
  801198:	8d 4a 01             	lea    0x1(%edx),%ecx
  80119b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80119e:	8a 12                	mov    (%edx),%dl
  8011a0:	88 10                	mov    %dl,(%eax)
  8011a2:	8a 00                	mov    (%eax),%al
  8011a4:	84 c0                	test   %al,%al
  8011a6:	75 e4                	jne    80118c <strcpy+0xd>
		/* do nothing */;
	return ret;
  8011a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8011ab:	c9                   	leave  
  8011ac:	c3                   	ret    

008011ad <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8011ad:	55                   	push   %ebp
  8011ae:	89 e5                	mov    %esp,%ebp
  8011b0:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8011b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8011b9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011c0:	eb 1f                	jmp    8011e1 <strncpy+0x34>
		*dst++ = *src;
  8011c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c5:	8d 50 01             	lea    0x1(%eax),%edx
  8011c8:	89 55 08             	mov    %edx,0x8(%ebp)
  8011cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011ce:	8a 12                	mov    (%edx),%dl
  8011d0:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8011d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d5:	8a 00                	mov    (%eax),%al
  8011d7:	84 c0                	test   %al,%al
  8011d9:	74 03                	je     8011de <strncpy+0x31>
			src++;
  8011db:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8011de:	ff 45 fc             	incl   -0x4(%ebp)
  8011e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011e4:	3b 45 10             	cmp    0x10(%ebp),%eax
  8011e7:	72 d9                	jb     8011c2 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8011e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011ec:	c9                   	leave  
  8011ed:	c3                   	ret    

008011ee <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8011ee:	55                   	push   %ebp
  8011ef:	89 e5                	mov    %esp,%ebp
  8011f1:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8011f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8011fa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011fe:	74 30                	je     801230 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801200:	eb 16                	jmp    801218 <strlcpy+0x2a>
			*dst++ = *src++;
  801202:	8b 45 08             	mov    0x8(%ebp),%eax
  801205:	8d 50 01             	lea    0x1(%eax),%edx
  801208:	89 55 08             	mov    %edx,0x8(%ebp)
  80120b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80120e:	8d 4a 01             	lea    0x1(%edx),%ecx
  801211:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801214:	8a 12                	mov    (%edx),%dl
  801216:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801218:	ff 4d 10             	decl   0x10(%ebp)
  80121b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80121f:	74 09                	je     80122a <strlcpy+0x3c>
  801221:	8b 45 0c             	mov    0xc(%ebp),%eax
  801224:	8a 00                	mov    (%eax),%al
  801226:	84 c0                	test   %al,%al
  801228:	75 d8                	jne    801202 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80122a:	8b 45 08             	mov    0x8(%ebp),%eax
  80122d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801230:	8b 55 08             	mov    0x8(%ebp),%edx
  801233:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801236:	29 c2                	sub    %eax,%edx
  801238:	89 d0                	mov    %edx,%eax
}
  80123a:	c9                   	leave  
  80123b:	c3                   	ret    

0080123c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80123c:	55                   	push   %ebp
  80123d:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80123f:	eb 06                	jmp    801247 <strcmp+0xb>
		p++, q++;
  801241:	ff 45 08             	incl   0x8(%ebp)
  801244:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801247:	8b 45 08             	mov    0x8(%ebp),%eax
  80124a:	8a 00                	mov    (%eax),%al
  80124c:	84 c0                	test   %al,%al
  80124e:	74 0e                	je     80125e <strcmp+0x22>
  801250:	8b 45 08             	mov    0x8(%ebp),%eax
  801253:	8a 10                	mov    (%eax),%dl
  801255:	8b 45 0c             	mov    0xc(%ebp),%eax
  801258:	8a 00                	mov    (%eax),%al
  80125a:	38 c2                	cmp    %al,%dl
  80125c:	74 e3                	je     801241 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80125e:	8b 45 08             	mov    0x8(%ebp),%eax
  801261:	8a 00                	mov    (%eax),%al
  801263:	0f b6 d0             	movzbl %al,%edx
  801266:	8b 45 0c             	mov    0xc(%ebp),%eax
  801269:	8a 00                	mov    (%eax),%al
  80126b:	0f b6 c0             	movzbl %al,%eax
  80126e:	29 c2                	sub    %eax,%edx
  801270:	89 d0                	mov    %edx,%eax
}
  801272:	5d                   	pop    %ebp
  801273:	c3                   	ret    

00801274 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801274:	55                   	push   %ebp
  801275:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801277:	eb 09                	jmp    801282 <strncmp+0xe>
		n--, p++, q++;
  801279:	ff 4d 10             	decl   0x10(%ebp)
  80127c:	ff 45 08             	incl   0x8(%ebp)
  80127f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801282:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801286:	74 17                	je     80129f <strncmp+0x2b>
  801288:	8b 45 08             	mov    0x8(%ebp),%eax
  80128b:	8a 00                	mov    (%eax),%al
  80128d:	84 c0                	test   %al,%al
  80128f:	74 0e                	je     80129f <strncmp+0x2b>
  801291:	8b 45 08             	mov    0x8(%ebp),%eax
  801294:	8a 10                	mov    (%eax),%dl
  801296:	8b 45 0c             	mov    0xc(%ebp),%eax
  801299:	8a 00                	mov    (%eax),%al
  80129b:	38 c2                	cmp    %al,%dl
  80129d:	74 da                	je     801279 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80129f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012a3:	75 07                	jne    8012ac <strncmp+0x38>
		return 0;
  8012a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8012aa:	eb 14                	jmp    8012c0 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8012ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8012af:	8a 00                	mov    (%eax),%al
  8012b1:	0f b6 d0             	movzbl %al,%edx
  8012b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b7:	8a 00                	mov    (%eax),%al
  8012b9:	0f b6 c0             	movzbl %al,%eax
  8012bc:	29 c2                	sub    %eax,%edx
  8012be:	89 d0                	mov    %edx,%eax
}
  8012c0:	5d                   	pop    %ebp
  8012c1:	c3                   	ret    

008012c2 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8012c2:	55                   	push   %ebp
  8012c3:	89 e5                	mov    %esp,%ebp
  8012c5:	83 ec 04             	sub    $0x4,%esp
  8012c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012cb:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8012ce:	eb 12                	jmp    8012e2 <strchr+0x20>
		if (*s == c)
  8012d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d3:	8a 00                	mov    (%eax),%al
  8012d5:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8012d8:	75 05                	jne    8012df <strchr+0x1d>
			return (char *) s;
  8012da:	8b 45 08             	mov    0x8(%ebp),%eax
  8012dd:	eb 11                	jmp    8012f0 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8012df:	ff 45 08             	incl   0x8(%ebp)
  8012e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e5:	8a 00                	mov    (%eax),%al
  8012e7:	84 c0                	test   %al,%al
  8012e9:	75 e5                	jne    8012d0 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8012eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012f0:	c9                   	leave  
  8012f1:	c3                   	ret    

008012f2 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8012f2:	55                   	push   %ebp
  8012f3:	89 e5                	mov    %esp,%ebp
  8012f5:	83 ec 04             	sub    $0x4,%esp
  8012f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012fb:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8012fe:	eb 0d                	jmp    80130d <strfind+0x1b>
		if (*s == c)
  801300:	8b 45 08             	mov    0x8(%ebp),%eax
  801303:	8a 00                	mov    (%eax),%al
  801305:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801308:	74 0e                	je     801318 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80130a:	ff 45 08             	incl   0x8(%ebp)
  80130d:	8b 45 08             	mov    0x8(%ebp),%eax
  801310:	8a 00                	mov    (%eax),%al
  801312:	84 c0                	test   %al,%al
  801314:	75 ea                	jne    801300 <strfind+0xe>
  801316:	eb 01                	jmp    801319 <strfind+0x27>
		if (*s == c)
			break;
  801318:	90                   	nop
	return (char *) s;
  801319:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80131c:	c9                   	leave  
  80131d:	c3                   	ret    

0080131e <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  80131e:	55                   	push   %ebp
  80131f:	89 e5                	mov    %esp,%ebp
  801321:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801324:	8b 45 08             	mov    0x8(%ebp),%eax
  801327:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  80132a:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80132e:	76 63                	jbe    801393 <memset+0x75>
		uint64 data_block = c;
  801330:	8b 45 0c             	mov    0xc(%ebp),%eax
  801333:	99                   	cltd   
  801334:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801337:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  80133a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80133d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801340:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801344:	c1 e0 08             	shl    $0x8,%eax
  801347:	09 45 f0             	or     %eax,-0x10(%ebp)
  80134a:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  80134d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801350:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801353:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801357:	c1 e0 10             	shl    $0x10,%eax
  80135a:	09 45 f0             	or     %eax,-0x10(%ebp)
  80135d:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801360:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801363:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801366:	89 c2                	mov    %eax,%edx
  801368:	b8 00 00 00 00       	mov    $0x0,%eax
  80136d:	09 45 f0             	or     %eax,-0x10(%ebp)
  801370:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801373:	eb 18                	jmp    80138d <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801375:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801378:	8d 41 08             	lea    0x8(%ecx),%eax
  80137b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80137e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801381:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801384:	89 01                	mov    %eax,(%ecx)
  801386:	89 51 04             	mov    %edx,0x4(%ecx)
  801389:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  80138d:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801391:	77 e2                	ja     801375 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801393:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801397:	74 23                	je     8013bc <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801399:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80139c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  80139f:	eb 0e                	jmp    8013af <memset+0x91>
			*p8++ = (uint8)c;
  8013a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013a4:	8d 50 01             	lea    0x1(%eax),%edx
  8013a7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013ad:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8013af:	8b 45 10             	mov    0x10(%ebp),%eax
  8013b2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013b5:	89 55 10             	mov    %edx,0x10(%ebp)
  8013b8:	85 c0                	test   %eax,%eax
  8013ba:	75 e5                	jne    8013a1 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8013bc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013bf:	c9                   	leave  
  8013c0:	c3                   	ret    

008013c1 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8013c1:	55                   	push   %ebp
  8013c2:	89 e5                	mov    %esp,%ebp
  8013c4:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8013c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8013cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8013d3:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8013d7:	76 24                	jbe    8013fd <memcpy+0x3c>
		while(n >= 8){
  8013d9:	eb 1c                	jmp    8013f7 <memcpy+0x36>
			*d64 = *s64;
  8013db:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013de:	8b 50 04             	mov    0x4(%eax),%edx
  8013e1:	8b 00                	mov    (%eax),%eax
  8013e3:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8013e6:	89 01                	mov    %eax,(%ecx)
  8013e8:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8013eb:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8013ef:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8013f3:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8013f7:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8013fb:	77 de                	ja     8013db <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8013fd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801401:	74 31                	je     801434 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801403:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801406:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801409:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80140c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  80140f:	eb 16                	jmp    801427 <memcpy+0x66>
			*d8++ = *s8++;
  801411:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801414:	8d 50 01             	lea    0x1(%eax),%edx
  801417:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80141a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80141d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801420:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801423:	8a 12                	mov    (%edx),%dl
  801425:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801427:	8b 45 10             	mov    0x10(%ebp),%eax
  80142a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80142d:	89 55 10             	mov    %edx,0x10(%ebp)
  801430:	85 c0                	test   %eax,%eax
  801432:	75 dd                	jne    801411 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801434:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801437:	c9                   	leave  
  801438:	c3                   	ret    

00801439 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801439:	55                   	push   %ebp
  80143a:	89 e5                	mov    %esp,%ebp
  80143c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80143f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801442:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801445:	8b 45 08             	mov    0x8(%ebp),%eax
  801448:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80144b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80144e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801451:	73 50                	jae    8014a3 <memmove+0x6a>
  801453:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801456:	8b 45 10             	mov    0x10(%ebp),%eax
  801459:	01 d0                	add    %edx,%eax
  80145b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80145e:	76 43                	jbe    8014a3 <memmove+0x6a>
		s += n;
  801460:	8b 45 10             	mov    0x10(%ebp),%eax
  801463:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801466:	8b 45 10             	mov    0x10(%ebp),%eax
  801469:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80146c:	eb 10                	jmp    80147e <memmove+0x45>
			*--d = *--s;
  80146e:	ff 4d f8             	decl   -0x8(%ebp)
  801471:	ff 4d fc             	decl   -0x4(%ebp)
  801474:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801477:	8a 10                	mov    (%eax),%dl
  801479:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80147c:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80147e:	8b 45 10             	mov    0x10(%ebp),%eax
  801481:	8d 50 ff             	lea    -0x1(%eax),%edx
  801484:	89 55 10             	mov    %edx,0x10(%ebp)
  801487:	85 c0                	test   %eax,%eax
  801489:	75 e3                	jne    80146e <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80148b:	eb 23                	jmp    8014b0 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80148d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801490:	8d 50 01             	lea    0x1(%eax),%edx
  801493:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801496:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801499:	8d 4a 01             	lea    0x1(%edx),%ecx
  80149c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80149f:	8a 12                	mov    (%edx),%dl
  8014a1:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8014a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8014a6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8014a9:	89 55 10             	mov    %edx,0x10(%ebp)
  8014ac:	85 c0                	test   %eax,%eax
  8014ae:	75 dd                	jne    80148d <memmove+0x54>
			*d++ = *s++;

	return dst;
  8014b0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014b3:	c9                   	leave  
  8014b4:	c3                   	ret    

008014b5 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8014b5:	55                   	push   %ebp
  8014b6:	89 e5                	mov    %esp,%ebp
  8014b8:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8014bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014be:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8014c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c4:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8014c7:	eb 2a                	jmp    8014f3 <memcmp+0x3e>
		if (*s1 != *s2)
  8014c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014cc:	8a 10                	mov    (%eax),%dl
  8014ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014d1:	8a 00                	mov    (%eax),%al
  8014d3:	38 c2                	cmp    %al,%dl
  8014d5:	74 16                	je     8014ed <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8014d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014da:	8a 00                	mov    (%eax),%al
  8014dc:	0f b6 d0             	movzbl %al,%edx
  8014df:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014e2:	8a 00                	mov    (%eax),%al
  8014e4:	0f b6 c0             	movzbl %al,%eax
  8014e7:	29 c2                	sub    %eax,%edx
  8014e9:	89 d0                	mov    %edx,%eax
  8014eb:	eb 18                	jmp    801505 <memcmp+0x50>
		s1++, s2++;
  8014ed:	ff 45 fc             	incl   -0x4(%ebp)
  8014f0:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8014f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8014f6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8014f9:	89 55 10             	mov    %edx,0x10(%ebp)
  8014fc:	85 c0                	test   %eax,%eax
  8014fe:	75 c9                	jne    8014c9 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801500:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801505:	c9                   	leave  
  801506:	c3                   	ret    

00801507 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801507:	55                   	push   %ebp
  801508:	89 e5                	mov    %esp,%ebp
  80150a:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80150d:	8b 55 08             	mov    0x8(%ebp),%edx
  801510:	8b 45 10             	mov    0x10(%ebp),%eax
  801513:	01 d0                	add    %edx,%eax
  801515:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801518:	eb 15                	jmp    80152f <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80151a:	8b 45 08             	mov    0x8(%ebp),%eax
  80151d:	8a 00                	mov    (%eax),%al
  80151f:	0f b6 d0             	movzbl %al,%edx
  801522:	8b 45 0c             	mov    0xc(%ebp),%eax
  801525:	0f b6 c0             	movzbl %al,%eax
  801528:	39 c2                	cmp    %eax,%edx
  80152a:	74 0d                	je     801539 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80152c:	ff 45 08             	incl   0x8(%ebp)
  80152f:	8b 45 08             	mov    0x8(%ebp),%eax
  801532:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801535:	72 e3                	jb     80151a <memfind+0x13>
  801537:	eb 01                	jmp    80153a <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801539:	90                   	nop
	return (void *) s;
  80153a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80153d:	c9                   	leave  
  80153e:	c3                   	ret    

0080153f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80153f:	55                   	push   %ebp
  801540:	89 e5                	mov    %esp,%ebp
  801542:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801545:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80154c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801553:	eb 03                	jmp    801558 <strtol+0x19>
		s++;
  801555:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801558:	8b 45 08             	mov    0x8(%ebp),%eax
  80155b:	8a 00                	mov    (%eax),%al
  80155d:	3c 20                	cmp    $0x20,%al
  80155f:	74 f4                	je     801555 <strtol+0x16>
  801561:	8b 45 08             	mov    0x8(%ebp),%eax
  801564:	8a 00                	mov    (%eax),%al
  801566:	3c 09                	cmp    $0x9,%al
  801568:	74 eb                	je     801555 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80156a:	8b 45 08             	mov    0x8(%ebp),%eax
  80156d:	8a 00                	mov    (%eax),%al
  80156f:	3c 2b                	cmp    $0x2b,%al
  801571:	75 05                	jne    801578 <strtol+0x39>
		s++;
  801573:	ff 45 08             	incl   0x8(%ebp)
  801576:	eb 13                	jmp    80158b <strtol+0x4c>
	else if (*s == '-')
  801578:	8b 45 08             	mov    0x8(%ebp),%eax
  80157b:	8a 00                	mov    (%eax),%al
  80157d:	3c 2d                	cmp    $0x2d,%al
  80157f:	75 0a                	jne    80158b <strtol+0x4c>
		s++, neg = 1;
  801581:	ff 45 08             	incl   0x8(%ebp)
  801584:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80158b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80158f:	74 06                	je     801597 <strtol+0x58>
  801591:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801595:	75 20                	jne    8015b7 <strtol+0x78>
  801597:	8b 45 08             	mov    0x8(%ebp),%eax
  80159a:	8a 00                	mov    (%eax),%al
  80159c:	3c 30                	cmp    $0x30,%al
  80159e:	75 17                	jne    8015b7 <strtol+0x78>
  8015a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a3:	40                   	inc    %eax
  8015a4:	8a 00                	mov    (%eax),%al
  8015a6:	3c 78                	cmp    $0x78,%al
  8015a8:	75 0d                	jne    8015b7 <strtol+0x78>
		s += 2, base = 16;
  8015aa:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8015ae:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8015b5:	eb 28                	jmp    8015df <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8015b7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015bb:	75 15                	jne    8015d2 <strtol+0x93>
  8015bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c0:	8a 00                	mov    (%eax),%al
  8015c2:	3c 30                	cmp    $0x30,%al
  8015c4:	75 0c                	jne    8015d2 <strtol+0x93>
		s++, base = 8;
  8015c6:	ff 45 08             	incl   0x8(%ebp)
  8015c9:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8015d0:	eb 0d                	jmp    8015df <strtol+0xa0>
	else if (base == 0)
  8015d2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015d6:	75 07                	jne    8015df <strtol+0xa0>
		base = 10;
  8015d8:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8015df:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e2:	8a 00                	mov    (%eax),%al
  8015e4:	3c 2f                	cmp    $0x2f,%al
  8015e6:	7e 19                	jle    801601 <strtol+0xc2>
  8015e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015eb:	8a 00                	mov    (%eax),%al
  8015ed:	3c 39                	cmp    $0x39,%al
  8015ef:	7f 10                	jg     801601 <strtol+0xc2>
			dig = *s - '0';
  8015f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f4:	8a 00                	mov    (%eax),%al
  8015f6:	0f be c0             	movsbl %al,%eax
  8015f9:	83 e8 30             	sub    $0x30,%eax
  8015fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8015ff:	eb 42                	jmp    801643 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801601:	8b 45 08             	mov    0x8(%ebp),%eax
  801604:	8a 00                	mov    (%eax),%al
  801606:	3c 60                	cmp    $0x60,%al
  801608:	7e 19                	jle    801623 <strtol+0xe4>
  80160a:	8b 45 08             	mov    0x8(%ebp),%eax
  80160d:	8a 00                	mov    (%eax),%al
  80160f:	3c 7a                	cmp    $0x7a,%al
  801611:	7f 10                	jg     801623 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801613:	8b 45 08             	mov    0x8(%ebp),%eax
  801616:	8a 00                	mov    (%eax),%al
  801618:	0f be c0             	movsbl %al,%eax
  80161b:	83 e8 57             	sub    $0x57,%eax
  80161e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801621:	eb 20                	jmp    801643 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801623:	8b 45 08             	mov    0x8(%ebp),%eax
  801626:	8a 00                	mov    (%eax),%al
  801628:	3c 40                	cmp    $0x40,%al
  80162a:	7e 39                	jle    801665 <strtol+0x126>
  80162c:	8b 45 08             	mov    0x8(%ebp),%eax
  80162f:	8a 00                	mov    (%eax),%al
  801631:	3c 5a                	cmp    $0x5a,%al
  801633:	7f 30                	jg     801665 <strtol+0x126>
			dig = *s - 'A' + 10;
  801635:	8b 45 08             	mov    0x8(%ebp),%eax
  801638:	8a 00                	mov    (%eax),%al
  80163a:	0f be c0             	movsbl %al,%eax
  80163d:	83 e8 37             	sub    $0x37,%eax
  801640:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801643:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801646:	3b 45 10             	cmp    0x10(%ebp),%eax
  801649:	7d 19                	jge    801664 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80164b:	ff 45 08             	incl   0x8(%ebp)
  80164e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801651:	0f af 45 10          	imul   0x10(%ebp),%eax
  801655:	89 c2                	mov    %eax,%edx
  801657:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80165a:	01 d0                	add    %edx,%eax
  80165c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80165f:	e9 7b ff ff ff       	jmp    8015df <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801664:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801665:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801669:	74 08                	je     801673 <strtol+0x134>
		*endptr = (char *) s;
  80166b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80166e:	8b 55 08             	mov    0x8(%ebp),%edx
  801671:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801673:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801677:	74 07                	je     801680 <strtol+0x141>
  801679:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80167c:	f7 d8                	neg    %eax
  80167e:	eb 03                	jmp    801683 <strtol+0x144>
  801680:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801683:	c9                   	leave  
  801684:	c3                   	ret    

00801685 <ltostr>:

void
ltostr(long value, char *str)
{
  801685:	55                   	push   %ebp
  801686:	89 e5                	mov    %esp,%ebp
  801688:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80168b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801692:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801699:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80169d:	79 13                	jns    8016b2 <ltostr+0x2d>
	{
		neg = 1;
  80169f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8016a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a9:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8016ac:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8016af:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8016b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b5:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8016ba:	99                   	cltd   
  8016bb:	f7 f9                	idiv   %ecx
  8016bd:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8016c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016c3:	8d 50 01             	lea    0x1(%eax),%edx
  8016c6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8016c9:	89 c2                	mov    %eax,%edx
  8016cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016ce:	01 d0                	add    %edx,%eax
  8016d0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8016d3:	83 c2 30             	add    $0x30,%edx
  8016d6:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8016d8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016db:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8016e0:	f7 e9                	imul   %ecx
  8016e2:	c1 fa 02             	sar    $0x2,%edx
  8016e5:	89 c8                	mov    %ecx,%eax
  8016e7:	c1 f8 1f             	sar    $0x1f,%eax
  8016ea:	29 c2                	sub    %eax,%edx
  8016ec:	89 d0                	mov    %edx,%eax
  8016ee:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8016f1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8016f5:	75 bb                	jne    8016b2 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8016f7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8016fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801701:	48                   	dec    %eax
  801702:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801705:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801709:	74 3d                	je     801748 <ltostr+0xc3>
		start = 1 ;
  80170b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801712:	eb 34                	jmp    801748 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801714:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801717:	8b 45 0c             	mov    0xc(%ebp),%eax
  80171a:	01 d0                	add    %edx,%eax
  80171c:	8a 00                	mov    (%eax),%al
  80171e:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801721:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801724:	8b 45 0c             	mov    0xc(%ebp),%eax
  801727:	01 c2                	add    %eax,%edx
  801729:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80172c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80172f:	01 c8                	add    %ecx,%eax
  801731:	8a 00                	mov    (%eax),%al
  801733:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801735:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801738:	8b 45 0c             	mov    0xc(%ebp),%eax
  80173b:	01 c2                	add    %eax,%edx
  80173d:	8a 45 eb             	mov    -0x15(%ebp),%al
  801740:	88 02                	mov    %al,(%edx)
		start++ ;
  801742:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801745:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801748:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80174b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80174e:	7c c4                	jl     801714 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801750:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801753:	8b 45 0c             	mov    0xc(%ebp),%eax
  801756:	01 d0                	add    %edx,%eax
  801758:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80175b:	90                   	nop
  80175c:	c9                   	leave  
  80175d:	c3                   	ret    

0080175e <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80175e:	55                   	push   %ebp
  80175f:	89 e5                	mov    %esp,%ebp
  801761:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801764:	ff 75 08             	pushl  0x8(%ebp)
  801767:	e8 c4 f9 ff ff       	call   801130 <strlen>
  80176c:	83 c4 04             	add    $0x4,%esp
  80176f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801772:	ff 75 0c             	pushl  0xc(%ebp)
  801775:	e8 b6 f9 ff ff       	call   801130 <strlen>
  80177a:	83 c4 04             	add    $0x4,%esp
  80177d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801780:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801787:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80178e:	eb 17                	jmp    8017a7 <strcconcat+0x49>
		final[s] = str1[s] ;
  801790:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801793:	8b 45 10             	mov    0x10(%ebp),%eax
  801796:	01 c2                	add    %eax,%edx
  801798:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80179b:	8b 45 08             	mov    0x8(%ebp),%eax
  80179e:	01 c8                	add    %ecx,%eax
  8017a0:	8a 00                	mov    (%eax),%al
  8017a2:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8017a4:	ff 45 fc             	incl   -0x4(%ebp)
  8017a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017aa:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8017ad:	7c e1                	jl     801790 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8017af:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8017b6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8017bd:	eb 1f                	jmp    8017de <strcconcat+0x80>
		final[s++] = str2[i] ;
  8017bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017c2:	8d 50 01             	lea    0x1(%eax),%edx
  8017c5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8017c8:	89 c2                	mov    %eax,%edx
  8017ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8017cd:	01 c2                	add    %eax,%edx
  8017cf:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8017d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017d5:	01 c8                	add    %ecx,%eax
  8017d7:	8a 00                	mov    (%eax),%al
  8017d9:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8017db:	ff 45 f8             	incl   -0x8(%ebp)
  8017de:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017e1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8017e4:	7c d9                	jl     8017bf <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8017e6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8017ec:	01 d0                	add    %edx,%eax
  8017ee:	c6 00 00             	movb   $0x0,(%eax)
}
  8017f1:	90                   	nop
  8017f2:	c9                   	leave  
  8017f3:	c3                   	ret    

008017f4 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8017f4:	55                   	push   %ebp
  8017f5:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8017f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8017fa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801800:	8b 45 14             	mov    0x14(%ebp),%eax
  801803:	8b 00                	mov    (%eax),%eax
  801805:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80180c:	8b 45 10             	mov    0x10(%ebp),%eax
  80180f:	01 d0                	add    %edx,%eax
  801811:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801817:	eb 0c                	jmp    801825 <strsplit+0x31>
			*string++ = 0;
  801819:	8b 45 08             	mov    0x8(%ebp),%eax
  80181c:	8d 50 01             	lea    0x1(%eax),%edx
  80181f:	89 55 08             	mov    %edx,0x8(%ebp)
  801822:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801825:	8b 45 08             	mov    0x8(%ebp),%eax
  801828:	8a 00                	mov    (%eax),%al
  80182a:	84 c0                	test   %al,%al
  80182c:	74 18                	je     801846 <strsplit+0x52>
  80182e:	8b 45 08             	mov    0x8(%ebp),%eax
  801831:	8a 00                	mov    (%eax),%al
  801833:	0f be c0             	movsbl %al,%eax
  801836:	50                   	push   %eax
  801837:	ff 75 0c             	pushl  0xc(%ebp)
  80183a:	e8 83 fa ff ff       	call   8012c2 <strchr>
  80183f:	83 c4 08             	add    $0x8,%esp
  801842:	85 c0                	test   %eax,%eax
  801844:	75 d3                	jne    801819 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801846:	8b 45 08             	mov    0x8(%ebp),%eax
  801849:	8a 00                	mov    (%eax),%al
  80184b:	84 c0                	test   %al,%al
  80184d:	74 5a                	je     8018a9 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80184f:	8b 45 14             	mov    0x14(%ebp),%eax
  801852:	8b 00                	mov    (%eax),%eax
  801854:	83 f8 0f             	cmp    $0xf,%eax
  801857:	75 07                	jne    801860 <strsplit+0x6c>
		{
			return 0;
  801859:	b8 00 00 00 00       	mov    $0x0,%eax
  80185e:	eb 66                	jmp    8018c6 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801860:	8b 45 14             	mov    0x14(%ebp),%eax
  801863:	8b 00                	mov    (%eax),%eax
  801865:	8d 48 01             	lea    0x1(%eax),%ecx
  801868:	8b 55 14             	mov    0x14(%ebp),%edx
  80186b:	89 0a                	mov    %ecx,(%edx)
  80186d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801874:	8b 45 10             	mov    0x10(%ebp),%eax
  801877:	01 c2                	add    %eax,%edx
  801879:	8b 45 08             	mov    0x8(%ebp),%eax
  80187c:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80187e:	eb 03                	jmp    801883 <strsplit+0x8f>
			string++;
  801880:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801883:	8b 45 08             	mov    0x8(%ebp),%eax
  801886:	8a 00                	mov    (%eax),%al
  801888:	84 c0                	test   %al,%al
  80188a:	74 8b                	je     801817 <strsplit+0x23>
  80188c:	8b 45 08             	mov    0x8(%ebp),%eax
  80188f:	8a 00                	mov    (%eax),%al
  801891:	0f be c0             	movsbl %al,%eax
  801894:	50                   	push   %eax
  801895:	ff 75 0c             	pushl  0xc(%ebp)
  801898:	e8 25 fa ff ff       	call   8012c2 <strchr>
  80189d:	83 c4 08             	add    $0x8,%esp
  8018a0:	85 c0                	test   %eax,%eax
  8018a2:	74 dc                	je     801880 <strsplit+0x8c>
			string++;
	}
  8018a4:	e9 6e ff ff ff       	jmp    801817 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8018a9:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8018aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8018ad:	8b 00                	mov    (%eax),%eax
  8018af:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8018b9:	01 d0                	add    %edx,%eax
  8018bb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8018c1:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8018c6:	c9                   	leave  
  8018c7:	c3                   	ret    

008018c8 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8018c8:	55                   	push   %ebp
  8018c9:	89 e5                	mov    %esp,%ebp
  8018cb:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8018ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8018d4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8018db:	eb 4a                	jmp    801927 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8018dd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e3:	01 c2                	add    %eax,%edx
  8018e5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8018e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018eb:	01 c8                	add    %ecx,%eax
  8018ed:	8a 00                	mov    (%eax),%al
  8018ef:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8018f1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018f7:	01 d0                	add    %edx,%eax
  8018f9:	8a 00                	mov    (%eax),%al
  8018fb:	3c 40                	cmp    $0x40,%al
  8018fd:	7e 25                	jle    801924 <str2lower+0x5c>
  8018ff:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801902:	8b 45 0c             	mov    0xc(%ebp),%eax
  801905:	01 d0                	add    %edx,%eax
  801907:	8a 00                	mov    (%eax),%al
  801909:	3c 5a                	cmp    $0x5a,%al
  80190b:	7f 17                	jg     801924 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  80190d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801910:	8b 45 08             	mov    0x8(%ebp),%eax
  801913:	01 d0                	add    %edx,%eax
  801915:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801918:	8b 55 08             	mov    0x8(%ebp),%edx
  80191b:	01 ca                	add    %ecx,%edx
  80191d:	8a 12                	mov    (%edx),%dl
  80191f:	83 c2 20             	add    $0x20,%edx
  801922:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801924:	ff 45 fc             	incl   -0x4(%ebp)
  801927:	ff 75 0c             	pushl  0xc(%ebp)
  80192a:	e8 01 f8 ff ff       	call   801130 <strlen>
  80192f:	83 c4 04             	add    $0x4,%esp
  801932:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801935:	7f a6                	jg     8018dd <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801937:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80193a:	c9                   	leave  
  80193b:	c3                   	ret    

0080193c <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  80193c:	55                   	push   %ebp
  80193d:	89 e5                	mov    %esp,%ebp
  80193f:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801942:	a1 24 40 80 00       	mov    0x804024,%eax
  801947:	85 c0                	test   %eax,%eax
  801949:	74 42                	je     80198d <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  80194b:	83 ec 08             	sub    $0x8,%esp
  80194e:	68 00 00 00 82       	push   $0x82000000
  801953:	68 00 00 00 80       	push   $0x80000000
  801958:	e8 8c 07 00 00       	call   8020e9 <initialize_dynamic_allocator>
  80195d:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801960:	e8 e7 05 00 00       	call   801f4c <sys_get_uheap_strategy>
  801965:	a3 80 02 82 00       	mov    %eax,0x820280
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  80196a:	a1 60 40 80 00       	mov    0x804060,%eax
  80196f:	05 00 10 00 00       	add    $0x1000,%eax
  801974:	a3 30 03 82 00       	mov    %eax,0x820330
		uheapPageAllocBreak = uheapPageAllocStart;
  801979:	a1 30 03 82 00       	mov    0x820330,%eax
  80197e:	a3 88 02 82 00       	mov    %eax,0x820288

		__firstTimeFlag = 0;
  801983:	c7 05 24 40 80 00 00 	movl   $0x0,0x804024
  80198a:	00 00 00 
	}
}
  80198d:	90                   	nop
  80198e:	c9                   	leave  
  80198f:	c3                   	ret    

00801990 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801990:	55                   	push   %ebp
  801991:	89 e5                	mov    %esp,%ebp
  801993:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801996:	8b 45 08             	mov    0x8(%ebp),%eax
  801999:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80199c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80199f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8019a4:	83 ec 08             	sub    $0x8,%esp
  8019a7:	68 06 04 00 00       	push   $0x406
  8019ac:	50                   	push   %eax
  8019ad:	e8 e4 01 00 00       	call   801b96 <__sys_allocate_page>
  8019b2:	83 c4 10             	add    $0x10,%esp
  8019b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8019b8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8019bc:	79 14                	jns    8019d2 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  8019be:	83 ec 04             	sub    $0x4,%esp
  8019c1:	68 28 2e 80 00       	push   $0x802e28
  8019c6:	6a 1f                	push   $0x1f
  8019c8:	68 64 2e 80 00       	push   $0x802e64
  8019cd:	e8 b7 ed ff ff       	call   800789 <_panic>
	return 0;
  8019d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019d7:	c9                   	leave  
  8019d8:	c3                   	ret    

008019d9 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  8019d9:	55                   	push   %ebp
  8019da:	89 e5                	mov    %esp,%ebp
  8019dc:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  8019df:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8019e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019e8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8019ed:	83 ec 0c             	sub    $0xc,%esp
  8019f0:	50                   	push   %eax
  8019f1:	e8 e7 01 00 00       	call   801bdd <__sys_unmap_frame>
  8019f6:	83 c4 10             	add    $0x10,%esp
  8019f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8019fc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801a00:	79 14                	jns    801a16 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801a02:	83 ec 04             	sub    $0x4,%esp
  801a05:	68 70 2e 80 00       	push   $0x802e70
  801a0a:	6a 2a                	push   $0x2a
  801a0c:	68 64 2e 80 00       	push   $0x802e64
  801a11:	e8 73 ed ff ff       	call   800789 <_panic>
}
  801a16:	90                   	nop
  801a17:	c9                   	leave  
  801a18:	c3                   	ret    

00801a19 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801a19:	55                   	push   %ebp
  801a1a:	89 e5                	mov    %esp,%ebp
  801a1c:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801a1f:	e8 18 ff ff ff       	call   80193c <uheap_init>
	if (size == 0) return NULL ;
  801a24:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a28:	75 07                	jne    801a31 <malloc+0x18>
  801a2a:	b8 00 00 00 00       	mov    $0x0,%eax
  801a2f:	eb 14                	jmp    801a45 <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  801a31:	83 ec 04             	sub    $0x4,%esp
  801a34:	68 b0 2e 80 00       	push   $0x802eb0
  801a39:	6a 3e                	push   $0x3e
  801a3b:	68 64 2e 80 00       	push   $0x802e64
  801a40:	e8 44 ed ff ff       	call   800789 <_panic>
}
  801a45:	c9                   	leave  
  801a46:	c3                   	ret    

00801a47 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801a47:	55                   	push   %ebp
  801a48:	89 e5                	mov    %esp,%ebp
  801a4a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  801a4d:	83 ec 04             	sub    $0x4,%esp
  801a50:	68 d8 2e 80 00       	push   $0x802ed8
  801a55:	6a 49                	push   $0x49
  801a57:	68 64 2e 80 00       	push   $0x802e64
  801a5c:	e8 28 ed ff ff       	call   800789 <_panic>

00801a61 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801a61:	55                   	push   %ebp
  801a62:	89 e5                	mov    %esp,%ebp
  801a64:	83 ec 18             	sub    $0x18,%esp
  801a67:	8b 45 10             	mov    0x10(%ebp),%eax
  801a6a:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801a6d:	e8 ca fe ff ff       	call   80193c <uheap_init>
	if (size == 0) return NULL ;
  801a72:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a76:	75 07                	jne    801a7f <smalloc+0x1e>
  801a78:	b8 00 00 00 00       	mov    $0x0,%eax
  801a7d:	eb 14                	jmp    801a93 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  801a7f:	83 ec 04             	sub    $0x4,%esp
  801a82:	68 fc 2e 80 00       	push   $0x802efc
  801a87:	6a 5a                	push   $0x5a
  801a89:	68 64 2e 80 00       	push   $0x802e64
  801a8e:	e8 f6 ec ff ff       	call   800789 <_panic>
}
  801a93:	c9                   	leave  
  801a94:	c3                   	ret    

00801a95 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801a95:	55                   	push   %ebp
  801a96:	89 e5                	mov    %esp,%ebp
  801a98:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801a9b:	e8 9c fe ff ff       	call   80193c <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  801aa0:	83 ec 04             	sub    $0x4,%esp
  801aa3:	68 24 2f 80 00       	push   $0x802f24
  801aa8:	6a 6a                	push   $0x6a
  801aaa:	68 64 2e 80 00       	push   $0x802e64
  801aaf:	e8 d5 ec ff ff       	call   800789 <_panic>

00801ab4 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801ab4:	55                   	push   %ebp
  801ab5:	89 e5                	mov    %esp,%ebp
  801ab7:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801aba:	e8 7d fe ff ff       	call   80193c <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  801abf:	83 ec 04             	sub    $0x4,%esp
  801ac2:	68 48 2f 80 00       	push   $0x802f48
  801ac7:	68 88 00 00 00       	push   $0x88
  801acc:	68 64 2e 80 00       	push   $0x802e64
  801ad1:	e8 b3 ec ff ff       	call   800789 <_panic>

00801ad6 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  801ad6:	55                   	push   %ebp
  801ad7:	89 e5                	mov    %esp,%ebp
  801ad9:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  801adc:	83 ec 04             	sub    $0x4,%esp
  801adf:	68 70 2f 80 00       	push   $0x802f70
  801ae4:	68 9b 00 00 00       	push   $0x9b
  801ae9:	68 64 2e 80 00       	push   $0x802e64
  801aee:	e8 96 ec ff ff       	call   800789 <_panic>

00801af3 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801af3:	55                   	push   %ebp
  801af4:	89 e5                	mov    %esp,%ebp
  801af6:	57                   	push   %edi
  801af7:	56                   	push   %esi
  801af8:	53                   	push   %ebx
  801af9:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801afc:	8b 45 08             	mov    0x8(%ebp),%eax
  801aff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b02:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b05:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b08:	8b 7d 18             	mov    0x18(%ebp),%edi
  801b0b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801b0e:	cd 30                	int    $0x30
  801b10:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801b13:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801b16:	83 c4 10             	add    $0x10,%esp
  801b19:	5b                   	pop    %ebx
  801b1a:	5e                   	pop    %esi
  801b1b:	5f                   	pop    %edi
  801b1c:	5d                   	pop    %ebp
  801b1d:	c3                   	ret    

00801b1e <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801b1e:	55                   	push   %ebp
  801b1f:	89 e5                	mov    %esp,%ebp
  801b21:	83 ec 04             	sub    $0x4,%esp
  801b24:	8b 45 10             	mov    0x10(%ebp),%eax
  801b27:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801b2a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b2d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b31:	8b 45 08             	mov    0x8(%ebp),%eax
  801b34:	6a 00                	push   $0x0
  801b36:	51                   	push   %ecx
  801b37:	52                   	push   %edx
  801b38:	ff 75 0c             	pushl  0xc(%ebp)
  801b3b:	50                   	push   %eax
  801b3c:	6a 00                	push   $0x0
  801b3e:	e8 b0 ff ff ff       	call   801af3 <syscall>
  801b43:	83 c4 18             	add    $0x18,%esp
}
  801b46:	90                   	nop
  801b47:	c9                   	leave  
  801b48:	c3                   	ret    

00801b49 <sys_cgetc>:

int
sys_cgetc(void)
{
  801b49:	55                   	push   %ebp
  801b4a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801b4c:	6a 00                	push   $0x0
  801b4e:	6a 00                	push   $0x0
  801b50:	6a 00                	push   $0x0
  801b52:	6a 00                	push   $0x0
  801b54:	6a 00                	push   $0x0
  801b56:	6a 02                	push   $0x2
  801b58:	e8 96 ff ff ff       	call   801af3 <syscall>
  801b5d:	83 c4 18             	add    $0x18,%esp
}
  801b60:	c9                   	leave  
  801b61:	c3                   	ret    

00801b62 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801b62:	55                   	push   %ebp
  801b63:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801b65:	6a 00                	push   $0x0
  801b67:	6a 00                	push   $0x0
  801b69:	6a 00                	push   $0x0
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 03                	push   $0x3
  801b71:	e8 7d ff ff ff       	call   801af3 <syscall>
  801b76:	83 c4 18             	add    $0x18,%esp
}
  801b79:	90                   	nop
  801b7a:	c9                   	leave  
  801b7b:	c3                   	ret    

00801b7c <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801b7c:	55                   	push   %ebp
  801b7d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 00                	push   $0x0
  801b83:	6a 00                	push   $0x0
  801b85:	6a 00                	push   $0x0
  801b87:	6a 00                	push   $0x0
  801b89:	6a 04                	push   $0x4
  801b8b:	e8 63 ff ff ff       	call   801af3 <syscall>
  801b90:	83 c4 18             	add    $0x18,%esp
}
  801b93:	90                   	nop
  801b94:	c9                   	leave  
  801b95:	c3                   	ret    

00801b96 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801b96:	55                   	push   %ebp
  801b97:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801b99:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9f:	6a 00                	push   $0x0
  801ba1:	6a 00                	push   $0x0
  801ba3:	6a 00                	push   $0x0
  801ba5:	52                   	push   %edx
  801ba6:	50                   	push   %eax
  801ba7:	6a 08                	push   $0x8
  801ba9:	e8 45 ff ff ff       	call   801af3 <syscall>
  801bae:	83 c4 18             	add    $0x18,%esp
}
  801bb1:	c9                   	leave  
  801bb2:	c3                   	ret    

00801bb3 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801bb3:	55                   	push   %ebp
  801bb4:	89 e5                	mov    %esp,%ebp
  801bb6:	56                   	push   %esi
  801bb7:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801bb8:	8b 75 18             	mov    0x18(%ebp),%esi
  801bbb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801bbe:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bc1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc7:	56                   	push   %esi
  801bc8:	53                   	push   %ebx
  801bc9:	51                   	push   %ecx
  801bca:	52                   	push   %edx
  801bcb:	50                   	push   %eax
  801bcc:	6a 09                	push   $0x9
  801bce:	e8 20 ff ff ff       	call   801af3 <syscall>
  801bd3:	83 c4 18             	add    $0x18,%esp
}
  801bd6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bd9:	5b                   	pop    %ebx
  801bda:	5e                   	pop    %esi
  801bdb:	5d                   	pop    %ebp
  801bdc:	c3                   	ret    

00801bdd <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801bdd:	55                   	push   %ebp
  801bde:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801be0:	6a 00                	push   $0x0
  801be2:	6a 00                	push   $0x0
  801be4:	6a 00                	push   $0x0
  801be6:	6a 00                	push   $0x0
  801be8:	ff 75 08             	pushl  0x8(%ebp)
  801beb:	6a 0a                	push   $0xa
  801bed:	e8 01 ff ff ff       	call   801af3 <syscall>
  801bf2:	83 c4 18             	add    $0x18,%esp
}
  801bf5:	c9                   	leave  
  801bf6:	c3                   	ret    

00801bf7 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801bf7:	55                   	push   %ebp
  801bf8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801bfa:	6a 00                	push   $0x0
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 00                	push   $0x0
  801c00:	ff 75 0c             	pushl  0xc(%ebp)
  801c03:	ff 75 08             	pushl  0x8(%ebp)
  801c06:	6a 0b                	push   $0xb
  801c08:	e8 e6 fe ff ff       	call   801af3 <syscall>
  801c0d:	83 c4 18             	add    $0x18,%esp
}
  801c10:	c9                   	leave  
  801c11:	c3                   	ret    

00801c12 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801c12:	55                   	push   %ebp
  801c13:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801c15:	6a 00                	push   $0x0
  801c17:	6a 00                	push   $0x0
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 0c                	push   $0xc
  801c21:	e8 cd fe ff ff       	call   801af3 <syscall>
  801c26:	83 c4 18             	add    $0x18,%esp
}
  801c29:	c9                   	leave  
  801c2a:	c3                   	ret    

00801c2b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801c2b:	55                   	push   %ebp
  801c2c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801c2e:	6a 00                	push   $0x0
  801c30:	6a 00                	push   $0x0
  801c32:	6a 00                	push   $0x0
  801c34:	6a 00                	push   $0x0
  801c36:	6a 00                	push   $0x0
  801c38:	6a 0d                	push   $0xd
  801c3a:	e8 b4 fe ff ff       	call   801af3 <syscall>
  801c3f:	83 c4 18             	add    $0x18,%esp
}
  801c42:	c9                   	leave  
  801c43:	c3                   	ret    

00801c44 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801c44:	55                   	push   %ebp
  801c45:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801c47:	6a 00                	push   $0x0
  801c49:	6a 00                	push   $0x0
  801c4b:	6a 00                	push   $0x0
  801c4d:	6a 00                	push   $0x0
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 0e                	push   $0xe
  801c53:	e8 9b fe ff ff       	call   801af3 <syscall>
  801c58:	83 c4 18             	add    $0x18,%esp
}
  801c5b:	c9                   	leave  
  801c5c:	c3                   	ret    

00801c5d <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801c5d:	55                   	push   %ebp
  801c5e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801c60:	6a 00                	push   $0x0
  801c62:	6a 00                	push   $0x0
  801c64:	6a 00                	push   $0x0
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 0f                	push   $0xf
  801c6c:	e8 82 fe ff ff       	call   801af3 <syscall>
  801c71:	83 c4 18             	add    $0x18,%esp
}
  801c74:	c9                   	leave  
  801c75:	c3                   	ret    

00801c76 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801c76:	55                   	push   %ebp
  801c77:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801c79:	6a 00                	push   $0x0
  801c7b:	6a 00                	push   $0x0
  801c7d:	6a 00                	push   $0x0
  801c7f:	6a 00                	push   $0x0
  801c81:	ff 75 08             	pushl  0x8(%ebp)
  801c84:	6a 10                	push   $0x10
  801c86:	e8 68 fe ff ff       	call   801af3 <syscall>
  801c8b:	83 c4 18             	add    $0x18,%esp
}
  801c8e:	c9                   	leave  
  801c8f:	c3                   	ret    

00801c90 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801c90:	55                   	push   %ebp
  801c91:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801c93:	6a 00                	push   $0x0
  801c95:	6a 00                	push   $0x0
  801c97:	6a 00                	push   $0x0
  801c99:	6a 00                	push   $0x0
  801c9b:	6a 00                	push   $0x0
  801c9d:	6a 11                	push   $0x11
  801c9f:	e8 4f fe ff ff       	call   801af3 <syscall>
  801ca4:	83 c4 18             	add    $0x18,%esp
}
  801ca7:	90                   	nop
  801ca8:	c9                   	leave  
  801ca9:	c3                   	ret    

00801caa <sys_cputc>:

void
sys_cputc(const char c)
{
  801caa:	55                   	push   %ebp
  801cab:	89 e5                	mov    %esp,%ebp
  801cad:	83 ec 04             	sub    $0x4,%esp
  801cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801cb6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 00                	push   $0x0
  801cbe:	6a 00                	push   $0x0
  801cc0:	6a 00                	push   $0x0
  801cc2:	50                   	push   %eax
  801cc3:	6a 01                	push   $0x1
  801cc5:	e8 29 fe ff ff       	call   801af3 <syscall>
  801cca:	83 c4 18             	add    $0x18,%esp
}
  801ccd:	90                   	nop
  801cce:	c9                   	leave  
  801ccf:	c3                   	ret    

00801cd0 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801cd0:	55                   	push   %ebp
  801cd1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801cd3:	6a 00                	push   $0x0
  801cd5:	6a 00                	push   $0x0
  801cd7:	6a 00                	push   $0x0
  801cd9:	6a 00                	push   $0x0
  801cdb:	6a 00                	push   $0x0
  801cdd:	6a 14                	push   $0x14
  801cdf:	e8 0f fe ff ff       	call   801af3 <syscall>
  801ce4:	83 c4 18             	add    $0x18,%esp
}
  801ce7:	90                   	nop
  801ce8:	c9                   	leave  
  801ce9:	c3                   	ret    

00801cea <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801cea:	55                   	push   %ebp
  801ceb:	89 e5                	mov    %esp,%ebp
  801ced:	83 ec 04             	sub    $0x4,%esp
  801cf0:	8b 45 10             	mov    0x10(%ebp),%eax
  801cf3:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801cf6:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801cf9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  801d00:	6a 00                	push   $0x0
  801d02:	51                   	push   %ecx
  801d03:	52                   	push   %edx
  801d04:	ff 75 0c             	pushl  0xc(%ebp)
  801d07:	50                   	push   %eax
  801d08:	6a 15                	push   $0x15
  801d0a:	e8 e4 fd ff ff       	call   801af3 <syscall>
  801d0f:	83 c4 18             	add    $0x18,%esp
}
  801d12:	c9                   	leave  
  801d13:	c3                   	ret    

00801d14 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801d14:	55                   	push   %ebp
  801d15:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801d17:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1d:	6a 00                	push   $0x0
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 00                	push   $0x0
  801d23:	52                   	push   %edx
  801d24:	50                   	push   %eax
  801d25:	6a 16                	push   $0x16
  801d27:	e8 c7 fd ff ff       	call   801af3 <syscall>
  801d2c:	83 c4 18             	add    $0x18,%esp
}
  801d2f:	c9                   	leave  
  801d30:	c3                   	ret    

00801d31 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801d31:	55                   	push   %ebp
  801d32:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801d34:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d37:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 00                	push   $0x0
  801d41:	51                   	push   %ecx
  801d42:	52                   	push   %edx
  801d43:	50                   	push   %eax
  801d44:	6a 17                	push   $0x17
  801d46:	e8 a8 fd ff ff       	call   801af3 <syscall>
  801d4b:	83 c4 18             	add    $0x18,%esp
}
  801d4e:	c9                   	leave  
  801d4f:	c3                   	ret    

00801d50 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801d50:	55                   	push   %ebp
  801d51:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801d53:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d56:	8b 45 08             	mov    0x8(%ebp),%eax
  801d59:	6a 00                	push   $0x0
  801d5b:	6a 00                	push   $0x0
  801d5d:	6a 00                	push   $0x0
  801d5f:	52                   	push   %edx
  801d60:	50                   	push   %eax
  801d61:	6a 18                	push   $0x18
  801d63:	e8 8b fd ff ff       	call   801af3 <syscall>
  801d68:	83 c4 18             	add    $0x18,%esp
}
  801d6b:	c9                   	leave  
  801d6c:	c3                   	ret    

00801d6d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801d6d:	55                   	push   %ebp
  801d6e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801d70:	8b 45 08             	mov    0x8(%ebp),%eax
  801d73:	6a 00                	push   $0x0
  801d75:	ff 75 14             	pushl  0x14(%ebp)
  801d78:	ff 75 10             	pushl  0x10(%ebp)
  801d7b:	ff 75 0c             	pushl  0xc(%ebp)
  801d7e:	50                   	push   %eax
  801d7f:	6a 19                	push   $0x19
  801d81:	e8 6d fd ff ff       	call   801af3 <syscall>
  801d86:	83 c4 18             	add    $0x18,%esp
}
  801d89:	c9                   	leave  
  801d8a:	c3                   	ret    

00801d8b <sys_run_env>:

void sys_run_env(int32 envId)
{
  801d8b:	55                   	push   %ebp
  801d8c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d91:	6a 00                	push   $0x0
  801d93:	6a 00                	push   $0x0
  801d95:	6a 00                	push   $0x0
  801d97:	6a 00                	push   $0x0
  801d99:	50                   	push   %eax
  801d9a:	6a 1a                	push   $0x1a
  801d9c:	e8 52 fd ff ff       	call   801af3 <syscall>
  801da1:	83 c4 18             	add    $0x18,%esp
}
  801da4:	90                   	nop
  801da5:	c9                   	leave  
  801da6:	c3                   	ret    

00801da7 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801da7:	55                   	push   %ebp
  801da8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801daa:	8b 45 08             	mov    0x8(%ebp),%eax
  801dad:	6a 00                	push   $0x0
  801daf:	6a 00                	push   $0x0
  801db1:	6a 00                	push   $0x0
  801db3:	6a 00                	push   $0x0
  801db5:	50                   	push   %eax
  801db6:	6a 1b                	push   $0x1b
  801db8:	e8 36 fd ff ff       	call   801af3 <syscall>
  801dbd:	83 c4 18             	add    $0x18,%esp
}
  801dc0:	c9                   	leave  
  801dc1:	c3                   	ret    

00801dc2 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801dc2:	55                   	push   %ebp
  801dc3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801dc5:	6a 00                	push   $0x0
  801dc7:	6a 00                	push   $0x0
  801dc9:	6a 00                	push   $0x0
  801dcb:	6a 00                	push   $0x0
  801dcd:	6a 00                	push   $0x0
  801dcf:	6a 05                	push   $0x5
  801dd1:	e8 1d fd ff ff       	call   801af3 <syscall>
  801dd6:	83 c4 18             	add    $0x18,%esp
}
  801dd9:	c9                   	leave  
  801dda:	c3                   	ret    

00801ddb <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ddb:	55                   	push   %ebp
  801ddc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801dde:	6a 00                	push   $0x0
  801de0:	6a 00                	push   $0x0
  801de2:	6a 00                	push   $0x0
  801de4:	6a 00                	push   $0x0
  801de6:	6a 00                	push   $0x0
  801de8:	6a 06                	push   $0x6
  801dea:	e8 04 fd ff ff       	call   801af3 <syscall>
  801def:	83 c4 18             	add    $0x18,%esp
}
  801df2:	c9                   	leave  
  801df3:	c3                   	ret    

00801df4 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801df4:	55                   	push   %ebp
  801df5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801df7:	6a 00                	push   $0x0
  801df9:	6a 00                	push   $0x0
  801dfb:	6a 00                	push   $0x0
  801dfd:	6a 00                	push   $0x0
  801dff:	6a 00                	push   $0x0
  801e01:	6a 07                	push   $0x7
  801e03:	e8 eb fc ff ff       	call   801af3 <syscall>
  801e08:	83 c4 18             	add    $0x18,%esp
}
  801e0b:	c9                   	leave  
  801e0c:	c3                   	ret    

00801e0d <sys_exit_env>:


void sys_exit_env(void)
{
  801e0d:	55                   	push   %ebp
  801e0e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801e10:	6a 00                	push   $0x0
  801e12:	6a 00                	push   $0x0
  801e14:	6a 00                	push   $0x0
  801e16:	6a 00                	push   $0x0
  801e18:	6a 00                	push   $0x0
  801e1a:	6a 1c                	push   $0x1c
  801e1c:	e8 d2 fc ff ff       	call   801af3 <syscall>
  801e21:	83 c4 18             	add    $0x18,%esp
}
  801e24:	90                   	nop
  801e25:	c9                   	leave  
  801e26:	c3                   	ret    

00801e27 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801e27:	55                   	push   %ebp
  801e28:	89 e5                	mov    %esp,%ebp
  801e2a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801e2d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e30:	8d 50 04             	lea    0x4(%eax),%edx
  801e33:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e36:	6a 00                	push   $0x0
  801e38:	6a 00                	push   $0x0
  801e3a:	6a 00                	push   $0x0
  801e3c:	52                   	push   %edx
  801e3d:	50                   	push   %eax
  801e3e:	6a 1d                	push   $0x1d
  801e40:	e8 ae fc ff ff       	call   801af3 <syscall>
  801e45:	83 c4 18             	add    $0x18,%esp
	return result;
  801e48:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e4b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e4e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e51:	89 01                	mov    %eax,(%ecx)
  801e53:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801e56:	8b 45 08             	mov    0x8(%ebp),%eax
  801e59:	c9                   	leave  
  801e5a:	c2 04 00             	ret    $0x4

00801e5d <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801e5d:	55                   	push   %ebp
  801e5e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801e60:	6a 00                	push   $0x0
  801e62:	6a 00                	push   $0x0
  801e64:	ff 75 10             	pushl  0x10(%ebp)
  801e67:	ff 75 0c             	pushl  0xc(%ebp)
  801e6a:	ff 75 08             	pushl  0x8(%ebp)
  801e6d:	6a 13                	push   $0x13
  801e6f:	e8 7f fc ff ff       	call   801af3 <syscall>
  801e74:	83 c4 18             	add    $0x18,%esp
	return ;
  801e77:	90                   	nop
}
  801e78:	c9                   	leave  
  801e79:	c3                   	ret    

00801e7a <sys_rcr2>:
uint32 sys_rcr2()
{
  801e7a:	55                   	push   %ebp
  801e7b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801e7d:	6a 00                	push   $0x0
  801e7f:	6a 00                	push   $0x0
  801e81:	6a 00                	push   $0x0
  801e83:	6a 00                	push   $0x0
  801e85:	6a 00                	push   $0x0
  801e87:	6a 1e                	push   $0x1e
  801e89:	e8 65 fc ff ff       	call   801af3 <syscall>
  801e8e:	83 c4 18             	add    $0x18,%esp
}
  801e91:	c9                   	leave  
  801e92:	c3                   	ret    

00801e93 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801e93:	55                   	push   %ebp
  801e94:	89 e5                	mov    %esp,%ebp
  801e96:	83 ec 04             	sub    $0x4,%esp
  801e99:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801e9f:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801ea3:	6a 00                	push   $0x0
  801ea5:	6a 00                	push   $0x0
  801ea7:	6a 00                	push   $0x0
  801ea9:	6a 00                	push   $0x0
  801eab:	50                   	push   %eax
  801eac:	6a 1f                	push   $0x1f
  801eae:	e8 40 fc ff ff       	call   801af3 <syscall>
  801eb3:	83 c4 18             	add    $0x18,%esp
	return ;
  801eb6:	90                   	nop
}
  801eb7:	c9                   	leave  
  801eb8:	c3                   	ret    

00801eb9 <rsttst>:
void rsttst()
{
  801eb9:	55                   	push   %ebp
  801eba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ebc:	6a 00                	push   $0x0
  801ebe:	6a 00                	push   $0x0
  801ec0:	6a 00                	push   $0x0
  801ec2:	6a 00                	push   $0x0
  801ec4:	6a 00                	push   $0x0
  801ec6:	6a 21                	push   $0x21
  801ec8:	e8 26 fc ff ff       	call   801af3 <syscall>
  801ecd:	83 c4 18             	add    $0x18,%esp
	return ;
  801ed0:	90                   	nop
}
  801ed1:	c9                   	leave  
  801ed2:	c3                   	ret    

00801ed3 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ed3:	55                   	push   %ebp
  801ed4:	89 e5                	mov    %esp,%ebp
  801ed6:	83 ec 04             	sub    $0x4,%esp
  801ed9:	8b 45 14             	mov    0x14(%ebp),%eax
  801edc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801edf:	8b 55 18             	mov    0x18(%ebp),%edx
  801ee2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ee6:	52                   	push   %edx
  801ee7:	50                   	push   %eax
  801ee8:	ff 75 10             	pushl  0x10(%ebp)
  801eeb:	ff 75 0c             	pushl  0xc(%ebp)
  801eee:	ff 75 08             	pushl  0x8(%ebp)
  801ef1:	6a 20                	push   $0x20
  801ef3:	e8 fb fb ff ff       	call   801af3 <syscall>
  801ef8:	83 c4 18             	add    $0x18,%esp
	return ;
  801efb:	90                   	nop
}
  801efc:	c9                   	leave  
  801efd:	c3                   	ret    

00801efe <chktst>:
void chktst(uint32 n)
{
  801efe:	55                   	push   %ebp
  801eff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801f01:	6a 00                	push   $0x0
  801f03:	6a 00                	push   $0x0
  801f05:	6a 00                	push   $0x0
  801f07:	6a 00                	push   $0x0
  801f09:	ff 75 08             	pushl  0x8(%ebp)
  801f0c:	6a 22                	push   $0x22
  801f0e:	e8 e0 fb ff ff       	call   801af3 <syscall>
  801f13:	83 c4 18             	add    $0x18,%esp
	return ;
  801f16:	90                   	nop
}
  801f17:	c9                   	leave  
  801f18:	c3                   	ret    

00801f19 <inctst>:

void inctst()
{
  801f19:	55                   	push   %ebp
  801f1a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801f1c:	6a 00                	push   $0x0
  801f1e:	6a 00                	push   $0x0
  801f20:	6a 00                	push   $0x0
  801f22:	6a 00                	push   $0x0
  801f24:	6a 00                	push   $0x0
  801f26:	6a 23                	push   $0x23
  801f28:	e8 c6 fb ff ff       	call   801af3 <syscall>
  801f2d:	83 c4 18             	add    $0x18,%esp
	return ;
  801f30:	90                   	nop
}
  801f31:	c9                   	leave  
  801f32:	c3                   	ret    

00801f33 <gettst>:
uint32 gettst()
{
  801f33:	55                   	push   %ebp
  801f34:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801f36:	6a 00                	push   $0x0
  801f38:	6a 00                	push   $0x0
  801f3a:	6a 00                	push   $0x0
  801f3c:	6a 00                	push   $0x0
  801f3e:	6a 00                	push   $0x0
  801f40:	6a 24                	push   $0x24
  801f42:	e8 ac fb ff ff       	call   801af3 <syscall>
  801f47:	83 c4 18             	add    $0x18,%esp
}
  801f4a:	c9                   	leave  
  801f4b:	c3                   	ret    

00801f4c <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801f4c:	55                   	push   %ebp
  801f4d:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f4f:	6a 00                	push   $0x0
  801f51:	6a 00                	push   $0x0
  801f53:	6a 00                	push   $0x0
  801f55:	6a 00                	push   $0x0
  801f57:	6a 00                	push   $0x0
  801f59:	6a 25                	push   $0x25
  801f5b:	e8 93 fb ff ff       	call   801af3 <syscall>
  801f60:	83 c4 18             	add    $0x18,%esp
  801f63:	a3 80 02 82 00       	mov    %eax,0x820280
	return uheapPlaceStrategy ;
  801f68:	a1 80 02 82 00       	mov    0x820280,%eax
}
  801f6d:	c9                   	leave  
  801f6e:	c3                   	ret    

00801f6f <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801f6f:	55                   	push   %ebp
  801f70:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801f72:	8b 45 08             	mov    0x8(%ebp),%eax
  801f75:	a3 80 02 82 00       	mov    %eax,0x820280
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801f7a:	6a 00                	push   $0x0
  801f7c:	6a 00                	push   $0x0
  801f7e:	6a 00                	push   $0x0
  801f80:	6a 00                	push   $0x0
  801f82:	ff 75 08             	pushl  0x8(%ebp)
  801f85:	6a 26                	push   $0x26
  801f87:	e8 67 fb ff ff       	call   801af3 <syscall>
  801f8c:	83 c4 18             	add    $0x18,%esp
	return ;
  801f8f:	90                   	nop
}
  801f90:	c9                   	leave  
  801f91:	c3                   	ret    

00801f92 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801f92:	55                   	push   %ebp
  801f93:	89 e5                	mov    %esp,%ebp
  801f95:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801f96:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f99:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa2:	6a 00                	push   $0x0
  801fa4:	53                   	push   %ebx
  801fa5:	51                   	push   %ecx
  801fa6:	52                   	push   %edx
  801fa7:	50                   	push   %eax
  801fa8:	6a 27                	push   $0x27
  801faa:	e8 44 fb ff ff       	call   801af3 <syscall>
  801faf:	83 c4 18             	add    $0x18,%esp
}
  801fb2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fb5:	c9                   	leave  
  801fb6:	c3                   	ret    

00801fb7 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801fb7:	55                   	push   %ebp
  801fb8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801fba:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc0:	6a 00                	push   $0x0
  801fc2:	6a 00                	push   $0x0
  801fc4:	6a 00                	push   $0x0
  801fc6:	52                   	push   %edx
  801fc7:	50                   	push   %eax
  801fc8:	6a 28                	push   $0x28
  801fca:	e8 24 fb ff ff       	call   801af3 <syscall>
  801fcf:	83 c4 18             	add    $0x18,%esp
}
  801fd2:	c9                   	leave  
  801fd3:	c3                   	ret    

00801fd4 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801fd4:	55                   	push   %ebp
  801fd5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801fd7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801fda:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fdd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe0:	6a 00                	push   $0x0
  801fe2:	51                   	push   %ecx
  801fe3:	ff 75 10             	pushl  0x10(%ebp)
  801fe6:	52                   	push   %edx
  801fe7:	50                   	push   %eax
  801fe8:	6a 29                	push   $0x29
  801fea:	e8 04 fb ff ff       	call   801af3 <syscall>
  801fef:	83 c4 18             	add    $0x18,%esp
}
  801ff2:	c9                   	leave  
  801ff3:	c3                   	ret    

00801ff4 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801ff4:	55                   	push   %ebp
  801ff5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801ff7:	6a 00                	push   $0x0
  801ff9:	6a 00                	push   $0x0
  801ffb:	ff 75 10             	pushl  0x10(%ebp)
  801ffe:	ff 75 0c             	pushl  0xc(%ebp)
  802001:	ff 75 08             	pushl  0x8(%ebp)
  802004:	6a 12                	push   $0x12
  802006:	e8 e8 fa ff ff       	call   801af3 <syscall>
  80200b:	83 c4 18             	add    $0x18,%esp
	return ;
  80200e:	90                   	nop
}
  80200f:	c9                   	leave  
  802010:	c3                   	ret    

00802011 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802011:	55                   	push   %ebp
  802012:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802014:	8b 55 0c             	mov    0xc(%ebp),%edx
  802017:	8b 45 08             	mov    0x8(%ebp),%eax
  80201a:	6a 00                	push   $0x0
  80201c:	6a 00                	push   $0x0
  80201e:	6a 00                	push   $0x0
  802020:	52                   	push   %edx
  802021:	50                   	push   %eax
  802022:	6a 2a                	push   $0x2a
  802024:	e8 ca fa ff ff       	call   801af3 <syscall>
  802029:	83 c4 18             	add    $0x18,%esp
	return;
  80202c:	90                   	nop
}
  80202d:	c9                   	leave  
  80202e:	c3                   	ret    

0080202f <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  80202f:	55                   	push   %ebp
  802030:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  802032:	6a 00                	push   $0x0
  802034:	6a 00                	push   $0x0
  802036:	6a 00                	push   $0x0
  802038:	6a 00                	push   $0x0
  80203a:	6a 00                	push   $0x0
  80203c:	6a 2b                	push   $0x2b
  80203e:	e8 b0 fa ff ff       	call   801af3 <syscall>
  802043:	83 c4 18             	add    $0x18,%esp
}
  802046:	c9                   	leave  
  802047:	c3                   	ret    

00802048 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802048:	55                   	push   %ebp
  802049:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80204b:	6a 00                	push   $0x0
  80204d:	6a 00                	push   $0x0
  80204f:	6a 00                	push   $0x0
  802051:	ff 75 0c             	pushl  0xc(%ebp)
  802054:	ff 75 08             	pushl  0x8(%ebp)
  802057:	6a 2d                	push   $0x2d
  802059:	e8 95 fa ff ff       	call   801af3 <syscall>
  80205e:	83 c4 18             	add    $0x18,%esp
	return;
  802061:	90                   	nop
}
  802062:	c9                   	leave  
  802063:	c3                   	ret    

00802064 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802064:	55                   	push   %ebp
  802065:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802067:	6a 00                	push   $0x0
  802069:	6a 00                	push   $0x0
  80206b:	6a 00                	push   $0x0
  80206d:	ff 75 0c             	pushl  0xc(%ebp)
  802070:	ff 75 08             	pushl  0x8(%ebp)
  802073:	6a 2c                	push   $0x2c
  802075:	e8 79 fa ff ff       	call   801af3 <syscall>
  80207a:	83 c4 18             	add    $0x18,%esp
	return ;
  80207d:	90                   	nop
}
  80207e:	c9                   	leave  
  80207f:	c3                   	ret    

00802080 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  802080:	55                   	push   %ebp
  802081:	89 e5                	mov    %esp,%ebp
  802083:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  802086:	83 ec 04             	sub    $0x4,%esp
  802089:	68 94 2f 80 00       	push   $0x802f94
  80208e:	68 25 01 00 00       	push   $0x125
  802093:	68 c7 2f 80 00       	push   $0x802fc7
  802098:	e8 ec e6 ff ff       	call   800789 <_panic>

0080209d <to_page_va>:
//==================================================================================//
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  80209d:	55                   	push   %ebp
  80209e:	89 e5                	mov    %esp,%ebp
  8020a0:	83 ec 10             	sub    $0x10,%esp
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  8020a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a6:	ba 80 82 80 00       	mov    $0x808280,%edx
  8020ab:	29 d0                	sub    %edx,%eax
  8020ad:	c1 f8 02             	sar    $0x2,%eax
  8020b0:	89 c2                	mov    %eax,%edx
  8020b2:	89 d0                	mov    %edx,%eax
  8020b4:	c1 e0 02             	shl    $0x2,%eax
  8020b7:	01 d0                	add    %edx,%eax
  8020b9:	c1 e0 02             	shl    $0x2,%eax
  8020bc:	01 d0                	add    %edx,%eax
  8020be:	c1 e0 02             	shl    $0x2,%eax
  8020c1:	01 d0                	add    %edx,%eax
  8020c3:	89 c1                	mov    %eax,%ecx
  8020c5:	c1 e1 08             	shl    $0x8,%ecx
  8020c8:	01 c8                	add    %ecx,%eax
  8020ca:	89 c1                	mov    %eax,%ecx
  8020cc:	c1 e1 10             	shl    $0x10,%ecx
  8020cf:	01 c8                	add    %ecx,%eax
  8020d1:	01 c0                	add    %eax,%eax
  8020d3:	01 d0                	add    %edx,%eax
  8020d5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  8020d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020db:	c1 e0 0c             	shl    $0xc,%eax
  8020de:	89 c2                	mov    %eax,%edx
  8020e0:	a1 84 02 82 00       	mov    0x820284,%eax
  8020e5:	01 d0                	add    %edx,%eax
}
  8020e7:	c9                   	leave  
  8020e8:	c3                   	ret    

008020e9 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  8020e9:	55                   	push   %ebp
  8020ea:	89 e5                	mov    %esp,%ebp
  8020ec:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  8020ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f2:	05 00 00 00 02       	add    $0x2000000,%eax
  8020f7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8020fa:	73 16                	jae    802112 <initialize_dynamic_allocator+0x29>
  8020fc:	68 d8 2f 80 00       	push   $0x802fd8
  802101:	68 fe 2f 80 00       	push   $0x802ffe
  802106:	6a 26                	push   $0x26
  802108:	68 13 30 80 00       	push   $0x803013
  80210d:	e8 77 e6 ff ff       	call   800789 <_panic>
		is_initialized = 1;
  802112:	c7 05 44 40 80 00 01 	movl   $0x1,0x804044
  802119:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	//Comment the following line
	panic("initialize_dynamic_allocator() Not implemented yet");
  80211c:	83 ec 04             	sub    $0x4,%esp
  80211f:	68 2c 30 80 00       	push   $0x80302c
  802124:	6a 2e                	push   $0x2e
  802126:	68 13 30 80 00       	push   $0x803013
  80212b:	e8 59 e6 ff ff       	call   800789 <_panic>

00802130 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  802130:	55                   	push   %ebp
  802131:	89 e5                	mov    %esp,%ebp
  802133:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	//Comment the following line
	panic("get_block_size() Not implemented yet");
  802136:	83 ec 04             	sub    $0x4,%esp
  802139:	68 60 30 80 00       	push   $0x803060
  80213e:	6a 3a                	push   $0x3a
  802140:	68 13 30 80 00       	push   $0x803013
  802145:	e8 3f e6 ff ff       	call   800789 <_panic>

0080214a <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  80214a:	55                   	push   %ebp
  80214b:	89 e5                	mov    %esp,%ebp
  80214d:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  802150:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802157:	76 16                	jbe    80216f <alloc_block+0x25>
  802159:	68 88 30 80 00       	push   $0x803088
  80215e:	68 fe 2f 80 00       	push   $0x802ffe
  802163:	6a 46                	push   $0x46
  802165:	68 13 30 80 00       	push   $0x803013
  80216a:	e8 1a e6 ff ff       	call   800789 <_panic>
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	panic("alloc_block() Not implemented yet");
  80216f:	83 ec 04             	sub    $0x4,%esp
  802172:	68 ac 30 80 00       	push   $0x8030ac
  802177:	6a 4d                	push   $0x4d
  802179:	68 13 30 80 00       	push   $0x803013
  80217e:	e8 06 e6 ff ff       	call   800789 <_panic>

00802183 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  802183:	55                   	push   %ebp
  802184:	89 e5                	mov    %esp,%ebp
  802186:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  802189:	8b 55 08             	mov    0x8(%ebp),%edx
  80218c:	a1 84 02 82 00       	mov    0x820284,%eax
  802191:	39 c2                	cmp    %eax,%edx
  802193:	72 0c                	jb     8021a1 <free_block+0x1e>
  802195:	8b 55 08             	mov    0x8(%ebp),%edx
  802198:	a1 60 40 80 00       	mov    0x804060,%eax
  80219d:	39 c2                	cmp    %eax,%edx
  80219f:	72 16                	jb     8021b7 <free_block+0x34>
  8021a1:	68 d0 30 80 00       	push   $0x8030d0
  8021a6:	68 fe 2f 80 00       	push   $0x802ffe
  8021ab:	6a 5b                	push   $0x5b
  8021ad:	68 13 30 80 00       	push   $0x803013
  8021b2:	e8 d2 e5 ff ff       	call   800789 <_panic>
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	panic("free_block() Not implemented yet");
  8021b7:	83 ec 04             	sub    $0x4,%esp
  8021ba:	68 08 31 80 00       	push   $0x803108
  8021bf:	6a 63                	push   $0x63
  8021c1:	68 13 30 80 00       	push   $0x803013
  8021c6:	e8 be e5 ff ff       	call   800789 <_panic>

008021cb <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  8021cb:	55                   	push   %ebp
  8021cc:	89 e5                	mov    %esp,%ebp
  8021ce:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  8021d1:	83 ec 04             	sub    $0x4,%esp
  8021d4:	68 2c 31 80 00       	push   $0x80312c
  8021d9:	6a 72                	push   $0x72
  8021db:	68 13 30 80 00       	push   $0x803013
  8021e0:	e8 a4 e5 ff ff       	call   800789 <_panic>
  8021e5:	66 90                	xchg   %ax,%ax
  8021e7:	90                   	nop

008021e8 <__udivdi3>:
  8021e8:	55                   	push   %ebp
  8021e9:	57                   	push   %edi
  8021ea:	56                   	push   %esi
  8021eb:	53                   	push   %ebx
  8021ec:	83 ec 1c             	sub    $0x1c,%esp
  8021ef:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8021f3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8021f7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8021fb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8021ff:	89 ca                	mov    %ecx,%edx
  802201:	89 f8                	mov    %edi,%eax
  802203:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802207:	85 f6                	test   %esi,%esi
  802209:	75 2d                	jne    802238 <__udivdi3+0x50>
  80220b:	39 cf                	cmp    %ecx,%edi
  80220d:	77 65                	ja     802274 <__udivdi3+0x8c>
  80220f:	89 fd                	mov    %edi,%ebp
  802211:	85 ff                	test   %edi,%edi
  802213:	75 0b                	jne    802220 <__udivdi3+0x38>
  802215:	b8 01 00 00 00       	mov    $0x1,%eax
  80221a:	31 d2                	xor    %edx,%edx
  80221c:	f7 f7                	div    %edi
  80221e:	89 c5                	mov    %eax,%ebp
  802220:	31 d2                	xor    %edx,%edx
  802222:	89 c8                	mov    %ecx,%eax
  802224:	f7 f5                	div    %ebp
  802226:	89 c1                	mov    %eax,%ecx
  802228:	89 d8                	mov    %ebx,%eax
  80222a:	f7 f5                	div    %ebp
  80222c:	89 cf                	mov    %ecx,%edi
  80222e:	89 fa                	mov    %edi,%edx
  802230:	83 c4 1c             	add    $0x1c,%esp
  802233:	5b                   	pop    %ebx
  802234:	5e                   	pop    %esi
  802235:	5f                   	pop    %edi
  802236:	5d                   	pop    %ebp
  802237:	c3                   	ret    
  802238:	39 ce                	cmp    %ecx,%esi
  80223a:	77 28                	ja     802264 <__udivdi3+0x7c>
  80223c:	0f bd fe             	bsr    %esi,%edi
  80223f:	83 f7 1f             	xor    $0x1f,%edi
  802242:	75 40                	jne    802284 <__udivdi3+0x9c>
  802244:	39 ce                	cmp    %ecx,%esi
  802246:	72 0a                	jb     802252 <__udivdi3+0x6a>
  802248:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80224c:	0f 87 9e 00 00 00    	ja     8022f0 <__udivdi3+0x108>
  802252:	b8 01 00 00 00       	mov    $0x1,%eax
  802257:	89 fa                	mov    %edi,%edx
  802259:	83 c4 1c             	add    $0x1c,%esp
  80225c:	5b                   	pop    %ebx
  80225d:	5e                   	pop    %esi
  80225e:	5f                   	pop    %edi
  80225f:	5d                   	pop    %ebp
  802260:	c3                   	ret    
  802261:	8d 76 00             	lea    0x0(%esi),%esi
  802264:	31 ff                	xor    %edi,%edi
  802266:	31 c0                	xor    %eax,%eax
  802268:	89 fa                	mov    %edi,%edx
  80226a:	83 c4 1c             	add    $0x1c,%esp
  80226d:	5b                   	pop    %ebx
  80226e:	5e                   	pop    %esi
  80226f:	5f                   	pop    %edi
  802270:	5d                   	pop    %ebp
  802271:	c3                   	ret    
  802272:	66 90                	xchg   %ax,%ax
  802274:	89 d8                	mov    %ebx,%eax
  802276:	f7 f7                	div    %edi
  802278:	31 ff                	xor    %edi,%edi
  80227a:	89 fa                	mov    %edi,%edx
  80227c:	83 c4 1c             	add    $0x1c,%esp
  80227f:	5b                   	pop    %ebx
  802280:	5e                   	pop    %esi
  802281:	5f                   	pop    %edi
  802282:	5d                   	pop    %ebp
  802283:	c3                   	ret    
  802284:	bd 20 00 00 00       	mov    $0x20,%ebp
  802289:	89 eb                	mov    %ebp,%ebx
  80228b:	29 fb                	sub    %edi,%ebx
  80228d:	89 f9                	mov    %edi,%ecx
  80228f:	d3 e6                	shl    %cl,%esi
  802291:	89 c5                	mov    %eax,%ebp
  802293:	88 d9                	mov    %bl,%cl
  802295:	d3 ed                	shr    %cl,%ebp
  802297:	89 e9                	mov    %ebp,%ecx
  802299:	09 f1                	or     %esi,%ecx
  80229b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80229f:	89 f9                	mov    %edi,%ecx
  8022a1:	d3 e0                	shl    %cl,%eax
  8022a3:	89 c5                	mov    %eax,%ebp
  8022a5:	89 d6                	mov    %edx,%esi
  8022a7:	88 d9                	mov    %bl,%cl
  8022a9:	d3 ee                	shr    %cl,%esi
  8022ab:	89 f9                	mov    %edi,%ecx
  8022ad:	d3 e2                	shl    %cl,%edx
  8022af:	8b 44 24 08          	mov    0x8(%esp),%eax
  8022b3:	88 d9                	mov    %bl,%cl
  8022b5:	d3 e8                	shr    %cl,%eax
  8022b7:	09 c2                	or     %eax,%edx
  8022b9:	89 d0                	mov    %edx,%eax
  8022bb:	89 f2                	mov    %esi,%edx
  8022bd:	f7 74 24 0c          	divl   0xc(%esp)
  8022c1:	89 d6                	mov    %edx,%esi
  8022c3:	89 c3                	mov    %eax,%ebx
  8022c5:	f7 e5                	mul    %ebp
  8022c7:	39 d6                	cmp    %edx,%esi
  8022c9:	72 19                	jb     8022e4 <__udivdi3+0xfc>
  8022cb:	74 0b                	je     8022d8 <__udivdi3+0xf0>
  8022cd:	89 d8                	mov    %ebx,%eax
  8022cf:	31 ff                	xor    %edi,%edi
  8022d1:	e9 58 ff ff ff       	jmp    80222e <__udivdi3+0x46>
  8022d6:	66 90                	xchg   %ax,%ax
  8022d8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8022dc:	89 f9                	mov    %edi,%ecx
  8022de:	d3 e2                	shl    %cl,%edx
  8022e0:	39 c2                	cmp    %eax,%edx
  8022e2:	73 e9                	jae    8022cd <__udivdi3+0xe5>
  8022e4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8022e7:	31 ff                	xor    %edi,%edi
  8022e9:	e9 40 ff ff ff       	jmp    80222e <__udivdi3+0x46>
  8022ee:	66 90                	xchg   %ax,%ax
  8022f0:	31 c0                	xor    %eax,%eax
  8022f2:	e9 37 ff ff ff       	jmp    80222e <__udivdi3+0x46>
  8022f7:	90                   	nop

008022f8 <__umoddi3>:
  8022f8:	55                   	push   %ebp
  8022f9:	57                   	push   %edi
  8022fa:	56                   	push   %esi
  8022fb:	53                   	push   %ebx
  8022fc:	83 ec 1c             	sub    $0x1c,%esp
  8022ff:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802303:	8b 74 24 34          	mov    0x34(%esp),%esi
  802307:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80230b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80230f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802313:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802317:	89 f3                	mov    %esi,%ebx
  802319:	89 fa                	mov    %edi,%edx
  80231b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80231f:	89 34 24             	mov    %esi,(%esp)
  802322:	85 c0                	test   %eax,%eax
  802324:	75 1a                	jne    802340 <__umoddi3+0x48>
  802326:	39 f7                	cmp    %esi,%edi
  802328:	0f 86 a2 00 00 00    	jbe    8023d0 <__umoddi3+0xd8>
  80232e:	89 c8                	mov    %ecx,%eax
  802330:	89 f2                	mov    %esi,%edx
  802332:	f7 f7                	div    %edi
  802334:	89 d0                	mov    %edx,%eax
  802336:	31 d2                	xor    %edx,%edx
  802338:	83 c4 1c             	add    $0x1c,%esp
  80233b:	5b                   	pop    %ebx
  80233c:	5e                   	pop    %esi
  80233d:	5f                   	pop    %edi
  80233e:	5d                   	pop    %ebp
  80233f:	c3                   	ret    
  802340:	39 f0                	cmp    %esi,%eax
  802342:	0f 87 ac 00 00 00    	ja     8023f4 <__umoddi3+0xfc>
  802348:	0f bd e8             	bsr    %eax,%ebp
  80234b:	83 f5 1f             	xor    $0x1f,%ebp
  80234e:	0f 84 ac 00 00 00    	je     802400 <__umoddi3+0x108>
  802354:	bf 20 00 00 00       	mov    $0x20,%edi
  802359:	29 ef                	sub    %ebp,%edi
  80235b:	89 fe                	mov    %edi,%esi
  80235d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802361:	89 e9                	mov    %ebp,%ecx
  802363:	d3 e0                	shl    %cl,%eax
  802365:	89 d7                	mov    %edx,%edi
  802367:	89 f1                	mov    %esi,%ecx
  802369:	d3 ef                	shr    %cl,%edi
  80236b:	09 c7                	or     %eax,%edi
  80236d:	89 e9                	mov    %ebp,%ecx
  80236f:	d3 e2                	shl    %cl,%edx
  802371:	89 14 24             	mov    %edx,(%esp)
  802374:	89 d8                	mov    %ebx,%eax
  802376:	d3 e0                	shl    %cl,%eax
  802378:	89 c2                	mov    %eax,%edx
  80237a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80237e:	d3 e0                	shl    %cl,%eax
  802380:	89 44 24 04          	mov    %eax,0x4(%esp)
  802384:	8b 44 24 08          	mov    0x8(%esp),%eax
  802388:	89 f1                	mov    %esi,%ecx
  80238a:	d3 e8                	shr    %cl,%eax
  80238c:	09 d0                	or     %edx,%eax
  80238e:	d3 eb                	shr    %cl,%ebx
  802390:	89 da                	mov    %ebx,%edx
  802392:	f7 f7                	div    %edi
  802394:	89 d3                	mov    %edx,%ebx
  802396:	f7 24 24             	mull   (%esp)
  802399:	89 c6                	mov    %eax,%esi
  80239b:	89 d1                	mov    %edx,%ecx
  80239d:	39 d3                	cmp    %edx,%ebx
  80239f:	0f 82 87 00 00 00    	jb     80242c <__umoddi3+0x134>
  8023a5:	0f 84 91 00 00 00    	je     80243c <__umoddi3+0x144>
  8023ab:	8b 54 24 04          	mov    0x4(%esp),%edx
  8023af:	29 f2                	sub    %esi,%edx
  8023b1:	19 cb                	sbb    %ecx,%ebx
  8023b3:	89 d8                	mov    %ebx,%eax
  8023b5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8023b9:	d3 e0                	shl    %cl,%eax
  8023bb:	89 e9                	mov    %ebp,%ecx
  8023bd:	d3 ea                	shr    %cl,%edx
  8023bf:	09 d0                	or     %edx,%eax
  8023c1:	89 e9                	mov    %ebp,%ecx
  8023c3:	d3 eb                	shr    %cl,%ebx
  8023c5:	89 da                	mov    %ebx,%edx
  8023c7:	83 c4 1c             	add    $0x1c,%esp
  8023ca:	5b                   	pop    %ebx
  8023cb:	5e                   	pop    %esi
  8023cc:	5f                   	pop    %edi
  8023cd:	5d                   	pop    %ebp
  8023ce:	c3                   	ret    
  8023cf:	90                   	nop
  8023d0:	89 fd                	mov    %edi,%ebp
  8023d2:	85 ff                	test   %edi,%edi
  8023d4:	75 0b                	jne    8023e1 <__umoddi3+0xe9>
  8023d6:	b8 01 00 00 00       	mov    $0x1,%eax
  8023db:	31 d2                	xor    %edx,%edx
  8023dd:	f7 f7                	div    %edi
  8023df:	89 c5                	mov    %eax,%ebp
  8023e1:	89 f0                	mov    %esi,%eax
  8023e3:	31 d2                	xor    %edx,%edx
  8023e5:	f7 f5                	div    %ebp
  8023e7:	89 c8                	mov    %ecx,%eax
  8023e9:	f7 f5                	div    %ebp
  8023eb:	89 d0                	mov    %edx,%eax
  8023ed:	e9 44 ff ff ff       	jmp    802336 <__umoddi3+0x3e>
  8023f2:	66 90                	xchg   %ax,%ax
  8023f4:	89 c8                	mov    %ecx,%eax
  8023f6:	89 f2                	mov    %esi,%edx
  8023f8:	83 c4 1c             	add    $0x1c,%esp
  8023fb:	5b                   	pop    %ebx
  8023fc:	5e                   	pop    %esi
  8023fd:	5f                   	pop    %edi
  8023fe:	5d                   	pop    %ebp
  8023ff:	c3                   	ret    
  802400:	3b 04 24             	cmp    (%esp),%eax
  802403:	72 06                	jb     80240b <__umoddi3+0x113>
  802405:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802409:	77 0f                	ja     80241a <__umoddi3+0x122>
  80240b:	89 f2                	mov    %esi,%edx
  80240d:	29 f9                	sub    %edi,%ecx
  80240f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802413:	89 14 24             	mov    %edx,(%esp)
  802416:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80241a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80241e:	8b 14 24             	mov    (%esp),%edx
  802421:	83 c4 1c             	add    $0x1c,%esp
  802424:	5b                   	pop    %ebx
  802425:	5e                   	pop    %esi
  802426:	5f                   	pop    %edi
  802427:	5d                   	pop    %ebp
  802428:	c3                   	ret    
  802429:	8d 76 00             	lea    0x0(%esi),%esi
  80242c:	2b 04 24             	sub    (%esp),%eax
  80242f:	19 fa                	sbb    %edi,%edx
  802431:	89 d1                	mov    %edx,%ecx
  802433:	89 c6                	mov    %eax,%esi
  802435:	e9 71 ff ff ff       	jmp    8023ab <__umoddi3+0xb3>
  80243a:	66 90                	xchg   %ax,%ax
  80243c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802440:	72 ea                	jb     80242c <__umoddi3+0x134>
  802442:	89 d9                	mov    %ebx,%ecx
  802444:	e9 62 ff ff ff       	jmp    8023ab <__umoddi3+0xb3>

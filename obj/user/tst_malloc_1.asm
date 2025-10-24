
obj/user/tst_malloc_1:     file format elf32-i386


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
  800031:	e8 d1 10 00 00       	call   801107 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <inRange>:
	char a;
	short b;
	int c;
};
int inRange(int val, int min, int max)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
	return (val >= min && val <= max) ? 1 : 0;
  80003b:	8b 45 08             	mov    0x8(%ebp),%eax
  80003e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800041:	7c 0f                	jl     800052 <inRange+0x1a>
  800043:	8b 45 08             	mov    0x8(%ebp),%eax
  800046:	3b 45 10             	cmp    0x10(%ebp),%eax
  800049:	7f 07                	jg     800052 <inRange+0x1a>
  80004b:	b8 01 00 00 00       	mov    $0x1,%eax
  800050:	eb 05                	jmp    800057 <inRange+0x1f>
  800052:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800057:	5d                   	pop    %ebp
  800058:	c3                   	ret    

00800059 <_main>:
void _main(void)
{
  800059:	55                   	push   %ebp
  80005a:	89 e5                	mov    %esp,%ebp
  80005c:	57                   	push   %edi
  80005d:	53                   	push   %ebx
  80005e:	81 ec 30 01 00 00    	sub    $0x130,%esp

	//cprintf("1\n");
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
#if USE_KHEAP
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  800064:	a1 20 50 80 00       	mov    0x805020,%eax
  800069:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
  80006f:	a1 20 50 80 00       	mov    0x805020,%eax
  800074:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80007a:	39 c2                	cmp    %eax,%edx
  80007c:	72 14                	jb     800092 <_main+0x39>
			panic("Please increase the WS size");
  80007e:	83 ec 04             	sub    $0x4,%esp
  800081:	68 80 2f 80 00       	push   $0x802f80
  800086:	6a 1f                	push   $0x1f
  800088:	68 9c 2f 80 00       	push   $0x802f9c
  80008d:	e8 25 12 00 00       	call   8012b7 <_panic>
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	//cprintf("2\n");
	int eval = 0;
  800092:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	bool is_correct = 1;
  800099:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  8000a0:	c7 45 ec 00 10 00 82 	movl   $0x82001000,-0x14(%ebp)

	int Mega = 1024*1024;
  8000a7:	c7 45 e8 00 00 10 00 	movl   $0x100000,-0x18(%ebp)
	int kilo = 1024;
  8000ae:	c7 45 e4 00 04 00 00 	movl   $0x400,-0x1c(%ebp)
	char minByte = 1<<7;
  8000b5:	c6 45 e3 80          	movb   $0x80,-0x1d(%ebp)
	char maxByte = 0x7F;
  8000b9:	c6 45 e2 7f          	movb   $0x7f,-0x1e(%ebp)
	short minShort = 1<<15 ;
  8000bd:	66 c7 45 e0 00 80    	movw   $0x8000,-0x20(%ebp)
	short maxShort = 0x7FFF;
  8000c3:	66 c7 45 de ff 7f    	movw   $0x7fff,-0x22(%ebp)
	int minInt = 1<<31 ;
  8000c9:	c7 45 d8 00 00 00 80 	movl   $0x80000000,-0x28(%ebp)
	int maxInt = 0x7FFFFFFF;
  8000d0:	c7 45 d4 ff ff ff 7f 	movl   $0x7fffffff,-0x2c(%ebp)
	char *byteArr, *byteArr2 ;
	short *shortArr, *shortArr2 ;
	int *intArr;
	struct MyStruct *structArr ;
	int lastIndexOfByte, lastIndexOfByte2, lastIndexOfShort, lastIndexOfShort2, lastIndexOfInt, lastIndexOfStruct;
	int start_freeFrames = sys_calculate_free_frames() ;
  8000d7:	e8 64 26 00 00       	call   802740 <sys_calculate_free_frames>
  8000dc:	89 45 d0             	mov    %eax,-0x30(%ebp)
	int freeFrames, usedDiskPages, found;
	int expectedNumOfFrames, actualNumOfFrames;
	cprintf("\n%~[1] Allocate spaces of different sizes in PAGE ALLOCATOR and write some data to them [70%]\n");
  8000df:	83 ec 0c             	sub    $0xc,%esp
  8000e2:	68 b0 2f 80 00       	push   $0x802fb0
  8000e7:	e8 99 14 00 00       	call   801585 <cprintf>
  8000ec:	83 c4 10             	add    $0x10,%esp
	void* ptr_allocations[20] = {0};
  8000ef:	8d 95 04 ff ff ff    	lea    -0xfc(%ebp),%edx
  8000f5:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ff:	89 d7                	mov    %edx,%edi
  800101:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		//cprintf("3\n");
		//2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  800103:	e8 38 26 00 00       	call   802740 <sys_calculate_free_frames>
  800108:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80010b:	e8 7b 26 00 00       	call   80278b <sys_pf_calculate_allocated_pages>
  800110:	89 45 c8             	mov    %eax,-0x38(%ebp)
			ptr_allocations[0] = malloc(2*Mega-kilo);
  800113:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800116:	01 c0                	add    %eax,%eax
  800118:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	50                   	push   %eax
  80011f:	e8 23 24 00 00       	call   802547 <malloc>
  800124:	83 c4 10             	add    $0x10,%esp
  800127:	89 85 04 ff ff ff    	mov    %eax,-0xfc(%ebp)
			if ((uint32) ptr_allocations[0] != (pagealloc_start)) {is_correct = 0; cprintf("1 Wrong start address for the allocated space... \n");}
  80012d:	8b 85 04 ff ff ff    	mov    -0xfc(%ebp),%eax
  800133:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800136:	74 17                	je     80014f <_main+0xf6>
  800138:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80013f:	83 ec 0c             	sub    $0xc,%esp
  800142:	68 10 30 80 00       	push   $0x803010
  800147:	e8 39 14 00 00       	call   801585 <cprintf>
  80014c:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 1 /*table*/ ;
  80014f:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  800156:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800159:	e8 e2 25 00 00       	call   802740 <sys_calculate_free_frames>
  80015e:	29 c3                	sub    %eax,%ebx
  800160:	89 d8                	mov    %ebx,%eax
  800162:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  800165:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800168:	83 c0 02             	add    $0x2,%eax
  80016b:	83 ec 04             	sub    $0x4,%esp
  80016e:	50                   	push   %eax
  80016f:	ff 75 c4             	pushl  -0x3c(%ebp)
  800172:	ff 75 c0             	pushl  -0x40(%ebp)
  800175:	e8 be fe ff ff       	call   800038 <inRange>
  80017a:	83 c4 10             	add    $0x10,%esp
  80017d:	85 c0                	test   %eax,%eax
  80017f:	75 21                	jne    8001a2 <_main+0x149>
			{is_correct = 0; cprintf("1 Wrong allocation: unexpected number of pages that are allocated in memory! Expected = [%d, %d], Actual = %d\n", expectedNumOfFrames, expectedNumOfFrames+2, actualNumOfFrames);}
  800181:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800188:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80018b:	83 c0 02             	add    $0x2,%eax
  80018e:	ff 75 c0             	pushl  -0x40(%ebp)
  800191:	50                   	push   %eax
  800192:	ff 75 c4             	pushl  -0x3c(%ebp)
  800195:	68 44 30 80 00       	push   $0x803044
  80019a:	e8 e6 13 00 00       	call   801585 <cprintf>
  80019f:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("1 Extra or less pages are allocated in PageFile\n");}
  8001a2:	e8 e4 25 00 00       	call   80278b <sys_pf_calculate_allocated_pages>
  8001a7:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8001aa:	74 17                	je     8001c3 <_main+0x16a>
  8001ac:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001b3:	83 ec 0c             	sub    $0xc,%esp
  8001b6:	68 b4 30 80 00       	push   $0x8030b4
  8001bb:	e8 c5 13 00 00       	call   801585 <cprintf>
  8001c0:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  8001c3:	e8 78 25 00 00       	call   802740 <sys_calculate_free_frames>
  8001c8:	89 45 cc             	mov    %eax,-0x34(%ebp)
			lastIndexOfByte = (2*Mega-kilo)/sizeof(char) - 1;
  8001cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001ce:	01 c0                	add    %eax,%eax
  8001d0:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8001d3:	48                   	dec    %eax
  8001d4:	89 45 bc             	mov    %eax,-0x44(%ebp)
			byteArr = (char *) ptr_allocations[0];
  8001d7:	8b 85 04 ff ff ff    	mov    -0xfc(%ebp),%eax
  8001dd:	89 45 b8             	mov    %eax,-0x48(%ebp)
			byteArr[0] = minByte ;
  8001e0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8001e3:	8a 55 e3             	mov    -0x1d(%ebp),%dl
  8001e6:	88 10                	mov    %dl,(%eax)
			byteArr[lastIndexOfByte] = maxByte ;
  8001e8:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8001eb:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8001ee:	01 c2                	add    %eax,%edx
  8001f0:	8a 45 e2             	mov    -0x1e(%ebp),%al
  8001f3:	88 02                	mov    %al,(%edx)
			expectedNumOfFrames = 2 /*+1 table already created in malloc due to marking the allocated pages*/ ;
  8001f5:	c7 45 c4 02 00 00 00 	movl   $0x2,-0x3c(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  8001fc:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8001ff:	e8 3c 25 00 00       	call   802740 <sys_calculate_free_frames>
  800204:	29 c3                	sub    %eax,%ebx
  800206:	89 d8                	mov    %ebx,%eax
  800208:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  80020b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80020e:	83 c0 02             	add    $0x2,%eax
  800211:	83 ec 04             	sub    $0x4,%esp
  800214:	50                   	push   %eax
  800215:	ff 75 c4             	pushl  -0x3c(%ebp)
  800218:	ff 75 c0             	pushl  -0x40(%ebp)
  80021b:	e8 18 fe ff ff       	call   800038 <inRange>
  800220:	83 c4 10             	add    $0x10,%esp
  800223:	85 c0                	test   %eax,%eax
  800225:	75 1d                	jne    800244 <_main+0x1eb>
			{ is_correct = 0; cprintf("1 Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);}
  800227:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80022e:	83 ec 04             	sub    $0x4,%esp
  800231:	ff 75 c0             	pushl  -0x40(%ebp)
  800234:	ff 75 c4             	pushl  -0x3c(%ebp)
  800237:	68 e8 30 80 00       	push   $0x8030e8
  80023c:	e8 44 13 00 00       	call   801585 <cprintf>
  800241:	83 c4 10             	add    $0x10,%esp

			uint32 expectedVAs[2] = { ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE)} ;
  800244:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800247:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  80024a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80024d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800252:	89 85 fc fe ff ff    	mov    %eax,-0x104(%ebp)
  800258:	8b 55 bc             	mov    -0x44(%ebp),%edx
  80025b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80025e:	01 d0                	add    %edx,%eax
  800260:	89 45 b0             	mov    %eax,-0x50(%ebp)
  800263:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800266:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80026b:	89 85 00 ff ff ff    	mov    %eax,-0x100(%ebp)
			found = sys_check_WS_list(expectedVAs, 2, 0, 2);
  800271:	6a 02                	push   $0x2
  800273:	6a 00                	push   $0x0
  800275:	6a 02                	push   $0x2
  800277:	8d 85 fc fe ff ff    	lea    -0x104(%ebp),%eax
  80027d:	50                   	push   %eax
  80027e:	e8 7f 28 00 00       	call   802b02 <sys_check_WS_list>
  800283:	83 c4 10             	add    $0x10,%esp
  800286:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("1 malloc: page is not added to WS\n");}
  800289:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  80028d:	74 17                	je     8002a6 <_main+0x24d>
  80028f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800296:	83 ec 0c             	sub    $0xc,%esp
  800299:	68 68 31 80 00       	push   $0x803168
  80029e:	e8 e2 12 00 00       	call   801585 <cprintf>
  8002a3:	83 c4 10             	add    $0x10,%esp
		}
		//cprintf("4\n");
		if (is_correct)
  8002a6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8002aa:	74 04                	je     8002b0 <_main+0x257>
		{
			eval += 10;
  8002ac:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		}

		is_correct = 1;
  8002b0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		//2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  8002b7:	e8 84 24 00 00       	call   802740 <sys_calculate_free_frames>
  8002bc:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8002bf:	e8 c7 24 00 00       	call   80278b <sys_pf_calculate_allocated_pages>
  8002c4:	89 45 c8             	mov    %eax,-0x38(%ebp)
			ptr_allocations[1] = malloc(2*Mega-kilo);
  8002c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002ca:	01 c0                	add    %eax,%eax
  8002cc:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8002cf:	83 ec 0c             	sub    $0xc,%esp
  8002d2:	50                   	push   %eax
  8002d3:	e8 6f 22 00 00       	call   802547 <malloc>
  8002d8:	83 c4 10             	add    $0x10,%esp
  8002db:	89 85 08 ff ff ff    	mov    %eax,-0xf8(%ebp)
			if ((uint32) ptr_allocations[1] != (pagealloc_start + 2*Mega)) { is_correct = 0; cprintf("2 Wrong start address for the allocated space... \n");}
  8002e1:	8b 85 08 ff ff ff    	mov    -0xf8(%ebp),%eax
  8002e7:	89 c2                	mov    %eax,%edx
  8002e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002ec:	01 c0                	add    %eax,%eax
  8002ee:	89 c1                	mov    %eax,%ecx
  8002f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002f3:	01 c8                	add    %ecx,%eax
  8002f5:	39 c2                	cmp    %eax,%edx
  8002f7:	74 17                	je     800310 <_main+0x2b7>
  8002f9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800300:	83 ec 0c             	sub    $0xc,%esp
  800303:	68 8c 31 80 00       	push   $0x80318c
  800308:	e8 78 12 00 00       	call   801585 <cprintf>
  80030d:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 0 /*table exists*/ ;
  800310:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  800317:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  80031a:	e8 21 24 00 00       	call   802740 <sys_calculate_free_frames>
  80031f:	29 c3                	sub    %eax,%ebx
  800321:	89 d8                	mov    %ebx,%eax
  800323:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  800326:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800329:	83 c0 02             	add    $0x2,%eax
  80032c:	83 ec 04             	sub    $0x4,%esp
  80032f:	50                   	push   %eax
  800330:	ff 75 c4             	pushl  -0x3c(%ebp)
  800333:	ff 75 c0             	pushl  -0x40(%ebp)
  800336:	e8 fd fc ff ff       	call   800038 <inRange>
  80033b:	83 c4 10             	add    $0x10,%esp
  80033e:	85 c0                	test   %eax,%eax
  800340:	75 21                	jne    800363 <_main+0x30a>
			{is_correct = 0; cprintf("2 Wrong allocation: unexpected number of pages that are allocated in memory! Expected = [%d, %d], Actual = %d\n", expectedNumOfFrames, expectedNumOfFrames+2, actualNumOfFrames);}
  800342:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800349:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80034c:	83 c0 02             	add    $0x2,%eax
  80034f:	ff 75 c0             	pushl  -0x40(%ebp)
  800352:	50                   	push   %eax
  800353:	ff 75 c4             	pushl  -0x3c(%ebp)
  800356:	68 c0 31 80 00       	push   $0x8031c0
  80035b:	e8 25 12 00 00       	call   801585 <cprintf>
  800360:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("2 Extra or less pages are allocated in PageFile\n");}
  800363:	e8 23 24 00 00       	call   80278b <sys_pf_calculate_allocated_pages>
  800368:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80036b:	74 17                	je     800384 <_main+0x32b>
  80036d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800374:	83 ec 0c             	sub    $0xc,%esp
  800377:	68 30 32 80 00       	push   $0x803230
  80037c:	e8 04 12 00 00       	call   801585 <cprintf>
  800381:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  800384:	e8 b7 23 00 00       	call   802740 <sys_calculate_free_frames>
  800389:	89 45 cc             	mov    %eax,-0x34(%ebp)
			shortArr = (short *) ptr_allocations[1];
  80038c:	8b 85 08 ff ff ff    	mov    -0xf8(%ebp),%eax
  800392:	89 45 a8             	mov    %eax,-0x58(%ebp)
			lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
  800395:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800398:	01 c0                	add    %eax,%eax
  80039a:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80039d:	d1 e8                	shr    %eax
  80039f:	48                   	dec    %eax
  8003a0:	89 45 a4             	mov    %eax,-0x5c(%ebp)
			shortArr[0] = minShort;
  8003a3:	8b 55 a8             	mov    -0x58(%ebp),%edx
  8003a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003a9:	66 89 02             	mov    %ax,(%edx)
			shortArr[lastIndexOfShort] = maxShort;
  8003ac:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003af:	01 c0                	add    %eax,%eax
  8003b1:	89 c2                	mov    %eax,%edx
  8003b3:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8003b6:	01 c2                	add    %eax,%edx
  8003b8:	66 8b 45 de          	mov    -0x22(%ebp),%ax
  8003bc:	66 89 02             	mov    %ax,(%edx)
			expectedNumOfFrames = 2 ;
  8003bf:	c7 45 c4 02 00 00 00 	movl   $0x2,-0x3c(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  8003c6:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8003c9:	e8 72 23 00 00       	call   802740 <sys_calculate_free_frames>
  8003ce:	29 c3                	sub    %eax,%ebx
  8003d0:	89 d8                	mov    %ebx,%eax
  8003d2:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  8003d5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8003d8:	83 c0 02             	add    $0x2,%eax
  8003db:	83 ec 04             	sub    $0x4,%esp
  8003de:	50                   	push   %eax
  8003df:	ff 75 c4             	pushl  -0x3c(%ebp)
  8003e2:	ff 75 c0             	pushl  -0x40(%ebp)
  8003e5:	e8 4e fc ff ff       	call   800038 <inRange>
  8003ea:	83 c4 10             	add    $0x10,%esp
  8003ed:	85 c0                	test   %eax,%eax
  8003ef:	75 1d                	jne    80040e <_main+0x3b5>
			{ is_correct = 0; cprintf("2 Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);}
  8003f1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003f8:	83 ec 04             	sub    $0x4,%esp
  8003fb:	ff 75 c0             	pushl  -0x40(%ebp)
  8003fe:	ff 75 c4             	pushl  -0x3c(%ebp)
  800401:	68 64 32 80 00       	push   $0x803264
  800406:	e8 7a 11 00 00       	call   801585 <cprintf>
  80040b:	83 c4 10             	add    $0x10,%esp
			uint32 expectedVAs[2] = { ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE)} ;
  80040e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800411:	89 45 a0             	mov    %eax,-0x60(%ebp)
  800414:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800417:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80041c:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
  800422:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800425:	01 c0                	add    %eax,%eax
  800427:	89 c2                	mov    %eax,%edx
  800429:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80042c:	01 d0                	add    %edx,%eax
  80042e:	89 45 9c             	mov    %eax,-0x64(%ebp)
  800431:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800434:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800439:	89 85 f8 fe ff ff    	mov    %eax,-0x108(%ebp)
			found = sys_check_WS_list(expectedVAs, 2, 0, 2);
  80043f:	6a 02                	push   $0x2
  800441:	6a 00                	push   $0x0
  800443:	6a 02                	push   $0x2
  800445:	8d 85 f4 fe ff ff    	lea    -0x10c(%ebp),%eax
  80044b:	50                   	push   %eax
  80044c:	e8 b1 26 00 00       	call   802b02 <sys_check_WS_list>
  800451:	83 c4 10             	add    $0x10,%esp
  800454:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("2 malloc: page is not added to WS\n");}
  800457:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  80045b:	74 17                	je     800474 <_main+0x41b>
  80045d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800464:	83 ec 0c             	sub    $0xc,%esp
  800467:	68 e4 32 80 00       	push   $0x8032e4
  80046c:	e8 14 11 00 00       	call   801585 <cprintf>
  800471:	83 c4 10             	add    $0x10,%esp
		}
		//cprintf("5\n");
		if (is_correct)
  800474:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800478:	74 04                	je     80047e <_main+0x425>
		{
			eval += 10;
  80047a:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		}

		is_correct = 1;
  80047e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

		//3 KB
		{
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800485:	e8 01 23 00 00       	call   80278b <sys_pf_calculate_allocated_pages>
  80048a:	89 45 c8             	mov    %eax,-0x38(%ebp)
			ptr_allocations[2] = malloc(3*kilo);
  80048d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800490:	89 c2                	mov    %eax,%edx
  800492:	01 d2                	add    %edx,%edx
  800494:	01 d0                	add    %edx,%eax
  800496:	83 ec 0c             	sub    $0xc,%esp
  800499:	50                   	push   %eax
  80049a:	e8 a8 20 00 00       	call   802547 <malloc>
  80049f:	83 c4 10             	add    $0x10,%esp
  8004a2:	89 85 0c ff ff ff    	mov    %eax,-0xf4(%ebp)
			if ((uint32) ptr_allocations[2] != (pagealloc_start + 4*Mega)) { is_correct = 0; cprintf("3 Wrong start address for the allocated space... \n");}
  8004a8:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
  8004ae:	89 c2                	mov    %eax,%edx
  8004b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004b3:	c1 e0 02             	shl    $0x2,%eax
  8004b6:	89 c1                	mov    %eax,%ecx
  8004b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8004bb:	01 c8                	add    %ecx,%eax
  8004bd:	39 c2                	cmp    %eax,%edx
  8004bf:	74 17                	je     8004d8 <_main+0x47f>
  8004c1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004c8:	83 ec 0c             	sub    $0xc,%esp
  8004cb:	68 08 33 80 00       	push   $0x803308
  8004d0:	e8 b0 10 00 00       	call   801585 <cprintf>
  8004d5:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 1 /*table*/ ;
  8004d8:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  8004df:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8004e2:	e8 59 22 00 00       	call   802740 <sys_calculate_free_frames>
  8004e7:	29 c3                	sub    %eax,%ebx
  8004e9:	89 d8                	mov    %ebx,%eax
  8004eb:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  8004ee:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8004f1:	83 c0 02             	add    $0x2,%eax
  8004f4:	83 ec 04             	sub    $0x4,%esp
  8004f7:	50                   	push   %eax
  8004f8:	ff 75 c4             	pushl  -0x3c(%ebp)
  8004fb:	ff 75 c0             	pushl  -0x40(%ebp)
  8004fe:	e8 35 fb ff ff       	call   800038 <inRange>
  800503:	83 c4 10             	add    $0x10,%esp
  800506:	85 c0                	test   %eax,%eax
  800508:	75 21                	jne    80052b <_main+0x4d2>
			{is_correct = 0; cprintf("3 Wrong allocation: unexpected number of pages that are allocated in memory! Expected = [%d, %d], Actual = %d\n", expectedNumOfFrames, expectedNumOfFrames+2, actualNumOfFrames);}
  80050a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800511:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800514:	83 c0 02             	add    $0x2,%eax
  800517:	ff 75 c0             	pushl  -0x40(%ebp)
  80051a:	50                   	push   %eax
  80051b:	ff 75 c4             	pushl  -0x3c(%ebp)
  80051e:	68 3c 33 80 00       	push   $0x80333c
  800523:	e8 5d 10 00 00       	call   801585 <cprintf>
  800528:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("3 Extra or less pages are allocated in PageFile\n");}
  80052b:	e8 5b 22 00 00       	call   80278b <sys_pf_calculate_allocated_pages>
  800530:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800533:	74 17                	je     80054c <_main+0x4f3>
  800535:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80053c:	83 ec 0c             	sub    $0xc,%esp
  80053f:	68 ac 33 80 00       	push   $0x8033ac
  800544:	e8 3c 10 00 00       	call   801585 <cprintf>
  800549:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  80054c:	e8 ef 21 00 00       	call   802740 <sys_calculate_free_frames>
  800551:	89 45 cc             	mov    %eax,-0x34(%ebp)
			intArr = (int *) ptr_allocations[2];
  800554:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
  80055a:	89 45 98             	mov    %eax,-0x68(%ebp)
			lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
  80055d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800560:	01 c0                	add    %eax,%eax
  800562:	c1 e8 02             	shr    $0x2,%eax
  800565:	48                   	dec    %eax
  800566:	89 45 94             	mov    %eax,-0x6c(%ebp)
			intArr[0] = minInt;
  800569:	8b 45 98             	mov    -0x68(%ebp),%eax
  80056c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80056f:	89 10                	mov    %edx,(%eax)
			intArr[lastIndexOfInt] = maxInt;
  800571:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800574:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80057b:	8b 45 98             	mov    -0x68(%ebp),%eax
  80057e:	01 c2                	add    %eax,%edx
  800580:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800583:	89 02                	mov    %eax,(%edx)
			expectedNumOfFrames = 1 ;
  800585:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  80058c:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  80058f:	e8 ac 21 00 00       	call   802740 <sys_calculate_free_frames>
  800594:	29 c3                	sub    %eax,%ebx
  800596:	89 d8                	mov    %ebx,%eax
  800598:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  80059b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80059e:	83 c0 02             	add    $0x2,%eax
  8005a1:	83 ec 04             	sub    $0x4,%esp
  8005a4:	50                   	push   %eax
  8005a5:	ff 75 c4             	pushl  -0x3c(%ebp)
  8005a8:	ff 75 c0             	pushl  -0x40(%ebp)
  8005ab:	e8 88 fa ff ff       	call   800038 <inRange>
  8005b0:	83 c4 10             	add    $0x10,%esp
  8005b3:	85 c0                	test   %eax,%eax
  8005b5:	75 1d                	jne    8005d4 <_main+0x57b>
			{ is_correct = 0; cprintf("3 Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);}
  8005b7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8005be:	83 ec 04             	sub    $0x4,%esp
  8005c1:	ff 75 c0             	pushl  -0x40(%ebp)
  8005c4:	ff 75 c4             	pushl  -0x3c(%ebp)
  8005c7:	68 e0 33 80 00       	push   $0x8033e0
  8005cc:	e8 b4 0f 00 00       	call   801585 <cprintf>
  8005d1:	83 c4 10             	add    $0x10,%esp
			uint32 expectedVAs[2] = { ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE)} ;
  8005d4:	8b 45 98             	mov    -0x68(%ebp),%eax
  8005d7:	89 45 90             	mov    %eax,-0x70(%ebp)
  8005da:	8b 45 90             	mov    -0x70(%ebp),%eax
  8005dd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005e2:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
  8005e8:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8005eb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005f2:	8b 45 98             	mov    -0x68(%ebp),%eax
  8005f5:	01 d0                	add    %edx,%eax
  8005f7:	89 45 8c             	mov    %eax,-0x74(%ebp)
  8005fa:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8005fd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800602:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
			found = sys_check_WS_list(expectedVAs, 2, 0, 2);
  800608:	6a 02                	push   $0x2
  80060a:	6a 00                	push   $0x0
  80060c:	6a 02                	push   $0x2
  80060e:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
  800614:	50                   	push   %eax
  800615:	e8 e8 24 00 00       	call   802b02 <sys_check_WS_list>
  80061a:	83 c4 10             	add    $0x10,%esp
  80061d:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("3 malloc: page is not added to WS\n");}
  800620:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  800624:	74 17                	je     80063d <_main+0x5e4>
  800626:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80062d:	83 ec 0c             	sub    $0xc,%esp
  800630:	68 60 34 80 00       	push   $0x803460
  800635:	e8 4b 0f 00 00       	call   801585 <cprintf>
  80063a:	83 c4 10             	add    $0x10,%esp
		}

		//3 KB
		{
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80063d:	e8 49 21 00 00       	call   80278b <sys_pf_calculate_allocated_pages>
  800642:	89 45 c8             	mov    %eax,-0x38(%ebp)
			ptr_allocations[3] = malloc(3*kilo);
  800645:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800648:	89 c2                	mov    %eax,%edx
  80064a:	01 d2                	add    %edx,%edx
  80064c:	01 d0                	add    %edx,%eax
  80064e:	83 ec 0c             	sub    $0xc,%esp
  800651:	50                   	push   %eax
  800652:	e8 f0 1e 00 00       	call   802547 <malloc>
  800657:	83 c4 10             	add    $0x10,%esp
  80065a:	89 85 10 ff ff ff    	mov    %eax,-0xf0(%ebp)
			if ((uint32) ptr_allocations[3] != (pagealloc_start + 4*Mega + 4*kilo)) { is_correct = 0; cprintf("4 Wrong start address for the allocated space... \n");}
  800660:	8b 85 10 ff ff ff    	mov    -0xf0(%ebp),%eax
  800666:	89 c2                	mov    %eax,%edx
  800668:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80066b:	c1 e0 02             	shl    $0x2,%eax
  80066e:	89 c1                	mov    %eax,%ecx
  800670:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800673:	c1 e0 02             	shl    $0x2,%eax
  800676:	01 c1                	add    %eax,%ecx
  800678:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80067b:	01 c8                	add    %ecx,%eax
  80067d:	39 c2                	cmp    %eax,%edx
  80067f:	74 17                	je     800698 <_main+0x63f>
  800681:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800688:	83 ec 0c             	sub    $0xc,%esp
  80068b:	68 84 34 80 00       	push   $0x803484
  800690:	e8 f0 0e 00 00       	call   801585 <cprintf>
  800695:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("4 Extra or less pages are allocated in PageFile\n");}
  800698:	e8 ee 20 00 00       	call   80278b <sys_pf_calculate_allocated_pages>
  80069d:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8006a0:	74 17                	je     8006b9 <_main+0x660>
  8006a2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8006a9:	83 ec 0c             	sub    $0xc,%esp
  8006ac:	68 b8 34 80 00       	push   $0x8034b8
  8006b1:	e8 cf 0e 00 00       	call   801585 <cprintf>
  8006b6:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)
  8006b9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8006bd:	74 04                	je     8006c3 <_main+0x66a>
		{
			eval += 10;
  8006bf:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		}

		is_correct = 1;
  8006c3:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

		//7 KB
		{
			freeFrames = sys_calculate_free_frames() ;
  8006ca:	e8 71 20 00 00       	call   802740 <sys_calculate_free_frames>
  8006cf:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8006d2:	e8 b4 20 00 00       	call   80278b <sys_pf_calculate_allocated_pages>
  8006d7:	89 45 c8             	mov    %eax,-0x38(%ebp)
			ptr_allocations[4] = malloc(7*kilo);
  8006da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8006dd:	89 d0                	mov    %edx,%eax
  8006df:	01 c0                	add    %eax,%eax
  8006e1:	01 d0                	add    %edx,%eax
  8006e3:	01 c0                	add    %eax,%eax
  8006e5:	01 d0                	add    %edx,%eax
  8006e7:	83 ec 0c             	sub    $0xc,%esp
  8006ea:	50                   	push   %eax
  8006eb:	e8 57 1e 00 00       	call   802547 <malloc>
  8006f0:	83 c4 10             	add    $0x10,%esp
  8006f3:	89 85 14 ff ff ff    	mov    %eax,-0xec(%ebp)
			if ((uint32) ptr_allocations[4] != (pagealloc_start + 4*Mega + 8*kilo)) { is_correct = 0; cprintf("5 Wrong start address for the allocated space... \n");}
  8006f9:	8b 85 14 ff ff ff    	mov    -0xec(%ebp),%eax
  8006ff:	89 c2                	mov    %eax,%edx
  800701:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800704:	c1 e0 02             	shl    $0x2,%eax
  800707:	89 c1                	mov    %eax,%ecx
  800709:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80070c:	c1 e0 03             	shl    $0x3,%eax
  80070f:	01 c1                	add    %eax,%ecx
  800711:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800714:	01 c8                	add    %ecx,%eax
  800716:	39 c2                	cmp    %eax,%edx
  800718:	74 17                	je     800731 <_main+0x6d8>
  80071a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800721:	83 ec 0c             	sub    $0xc,%esp
  800724:	68 ec 34 80 00       	push   $0x8034ec
  800729:	e8 57 0e 00 00       	call   801585 <cprintf>
  80072e:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 0 /*no table*/ ;
  800731:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  800738:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  80073b:	e8 00 20 00 00       	call   802740 <sys_calculate_free_frames>
  800740:	29 c3                	sub    %eax,%ebx
  800742:	89 d8                	mov    %ebx,%eax
  800744:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  800747:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80074a:	83 c0 02             	add    $0x2,%eax
  80074d:	83 ec 04             	sub    $0x4,%esp
  800750:	50                   	push   %eax
  800751:	ff 75 c4             	pushl  -0x3c(%ebp)
  800754:	ff 75 c0             	pushl  -0x40(%ebp)
  800757:	e8 dc f8 ff ff       	call   800038 <inRange>
  80075c:	83 c4 10             	add    $0x10,%esp
  80075f:	85 c0                	test   %eax,%eax
  800761:	75 21                	jne    800784 <_main+0x72b>
			{is_correct = 0; cprintf("5 Wrong allocation: unexpected number of pages that are allocated in memory! Expected = [%d, %d], Actual = %d\n", expectedNumOfFrames, expectedNumOfFrames+2, actualNumOfFrames);}
  800763:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80076a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80076d:	83 c0 02             	add    $0x2,%eax
  800770:	ff 75 c0             	pushl  -0x40(%ebp)
  800773:	50                   	push   %eax
  800774:	ff 75 c4             	pushl  -0x3c(%ebp)
  800777:	68 20 35 80 00       	push   $0x803520
  80077c:	e8 04 0e 00 00       	call   801585 <cprintf>
  800781:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("5 Extra or less pages are allocated in PageFile\n");}
  800784:	e8 02 20 00 00       	call   80278b <sys_pf_calculate_allocated_pages>
  800789:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80078c:	74 17                	je     8007a5 <_main+0x74c>
  80078e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800795:	83 ec 0c             	sub    $0xc,%esp
  800798:	68 90 35 80 00       	push   $0x803590
  80079d:	e8 e3 0d 00 00       	call   801585 <cprintf>
  8007a2:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  8007a5:	e8 96 1f 00 00       	call   802740 <sys_calculate_free_frames>
  8007aa:	89 45 cc             	mov    %eax,-0x34(%ebp)
			structArr = (struct MyStruct *) ptr_allocations[4];
  8007ad:	8b 85 14 ff ff ff    	mov    -0xec(%ebp),%eax
  8007b3:	89 45 88             	mov    %eax,-0x78(%ebp)
			lastIndexOfStruct = (7*kilo)/sizeof(struct MyStruct) - 1;
  8007b6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8007b9:	89 d0                	mov    %edx,%eax
  8007bb:	01 c0                	add    %eax,%eax
  8007bd:	01 d0                	add    %edx,%eax
  8007bf:	01 c0                	add    %eax,%eax
  8007c1:	01 d0                	add    %edx,%eax
  8007c3:	c1 e8 03             	shr    $0x3,%eax
  8007c6:	48                   	dec    %eax
  8007c7:	89 45 84             	mov    %eax,-0x7c(%ebp)
			structArr[0].a = minByte; structArr[0].b = minShort; structArr[0].c = minInt;
  8007ca:	8b 45 88             	mov    -0x78(%ebp),%eax
  8007cd:	8a 55 e3             	mov    -0x1d(%ebp),%dl
  8007d0:	88 10                	mov    %dl,(%eax)
  8007d2:	8b 55 88             	mov    -0x78(%ebp),%edx
  8007d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007d8:	66 89 42 02          	mov    %ax,0x2(%edx)
  8007dc:	8b 45 88             	mov    -0x78(%ebp),%eax
  8007df:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007e2:	89 50 04             	mov    %edx,0x4(%eax)
			structArr[lastIndexOfStruct].a = maxByte; structArr[lastIndexOfStruct].b = maxShort; structArr[lastIndexOfStruct].c = maxInt;
  8007e5:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8007e8:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8007ef:	8b 45 88             	mov    -0x78(%ebp),%eax
  8007f2:	01 c2                	add    %eax,%edx
  8007f4:	8a 45 e2             	mov    -0x1e(%ebp),%al
  8007f7:	88 02                	mov    %al,(%edx)
  8007f9:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8007fc:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800803:	8b 45 88             	mov    -0x78(%ebp),%eax
  800806:	01 c2                	add    %eax,%edx
  800808:	66 8b 45 de          	mov    -0x22(%ebp),%ax
  80080c:	66 89 42 02          	mov    %ax,0x2(%edx)
  800810:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800813:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80081a:	8b 45 88             	mov    -0x78(%ebp),%eax
  80081d:	01 c2                	add    %eax,%edx
  80081f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800822:	89 42 04             	mov    %eax,0x4(%edx)
			expectedNumOfFrames = 2 ;
  800825:	c7 45 c4 02 00 00 00 	movl   $0x2,-0x3c(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  80082c:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  80082f:	e8 0c 1f 00 00       	call   802740 <sys_calculate_free_frames>
  800834:	29 c3                	sub    %eax,%ebx
  800836:	89 d8                	mov    %ebx,%eax
  800838:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  80083b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80083e:	83 c0 02             	add    $0x2,%eax
  800841:	83 ec 04             	sub    $0x4,%esp
  800844:	50                   	push   %eax
  800845:	ff 75 c4             	pushl  -0x3c(%ebp)
  800848:	ff 75 c0             	pushl  -0x40(%ebp)
  80084b:	e8 e8 f7 ff ff       	call   800038 <inRange>
  800850:	83 c4 10             	add    $0x10,%esp
  800853:	85 c0                	test   %eax,%eax
  800855:	75 1d                	jne    800874 <_main+0x81b>
			{ is_correct = 0; cprintf("5 Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);}
  800857:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80085e:	83 ec 04             	sub    $0x4,%esp
  800861:	ff 75 c0             	pushl  -0x40(%ebp)
  800864:	ff 75 c4             	pushl  -0x3c(%ebp)
  800867:	68 c4 35 80 00       	push   $0x8035c4
  80086c:	e8 14 0d 00 00       	call   801585 <cprintf>
  800871:	83 c4 10             	add    $0x10,%esp
			uint32 expectedVAs[2] = { ROUNDDOWN((uint32)(&(structArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE)} ;
  800874:	8b 45 88             	mov    -0x78(%ebp),%eax
  800877:	89 45 80             	mov    %eax,-0x80(%ebp)
  80087a:	8b 45 80             	mov    -0x80(%ebp),%eax
  80087d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800882:	89 85 e4 fe ff ff    	mov    %eax,-0x11c(%ebp)
  800888:	8b 45 84             	mov    -0x7c(%ebp),%eax
  80088b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800892:	8b 45 88             	mov    -0x78(%ebp),%eax
  800895:	01 d0                	add    %edx,%eax
  800897:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  80089d:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  8008a3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008a8:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
			found = sys_check_WS_list(expectedVAs, 2, 0, 2);
  8008ae:	6a 02                	push   $0x2
  8008b0:	6a 00                	push   $0x0
  8008b2:	6a 02                	push   $0x2
  8008b4:	8d 85 e4 fe ff ff    	lea    -0x11c(%ebp),%eax
  8008ba:	50                   	push   %eax
  8008bb:	e8 42 22 00 00       	call   802b02 <sys_check_WS_list>
  8008c0:	83 c4 10             	add    $0x10,%esp
  8008c3:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("5 malloc: page is not added to WS\n");}
  8008c6:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  8008ca:	74 17                	je     8008e3 <_main+0x88a>
  8008cc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8008d3:	83 ec 0c             	sub    $0xc,%esp
  8008d6:	68 44 36 80 00       	push   $0x803644
  8008db:	e8 a5 0c 00 00       	call   801585 <cprintf>
  8008e0:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)
  8008e3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8008e7:	74 04                	je     8008ed <_main+0x894>
		{
			eval += 10;
  8008e9:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		}

		is_correct = 1;
  8008ed:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

		//3 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  8008f4:	e8 47 1e 00 00       	call   802740 <sys_calculate_free_frames>
  8008f9:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8008fc:	e8 8a 1e 00 00       	call   80278b <sys_pf_calculate_allocated_pages>
  800901:	89 45 c8             	mov    %eax,-0x38(%ebp)
			ptr_allocations[5] = malloc(3*Mega-kilo);
  800904:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800907:	89 c2                	mov    %eax,%edx
  800909:	01 d2                	add    %edx,%edx
  80090b:	01 d0                	add    %edx,%eax
  80090d:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800910:	83 ec 0c             	sub    $0xc,%esp
  800913:	50                   	push   %eax
  800914:	e8 2e 1c 00 00       	call   802547 <malloc>
  800919:	83 c4 10             	add    $0x10,%esp
  80091c:	89 85 18 ff ff ff    	mov    %eax,-0xe8(%ebp)
			if ((uint32) ptr_allocations[5] != (pagealloc_start + 4*Mega + 16*kilo)) { is_correct = 0; cprintf("6 Wrong start address for the allocated space... \n");}
  800922:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
  800928:	89 c2                	mov    %eax,%edx
  80092a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80092d:	c1 e0 02             	shl    $0x2,%eax
  800930:	89 c1                	mov    %eax,%ecx
  800932:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800935:	c1 e0 04             	shl    $0x4,%eax
  800938:	01 c1                	add    %eax,%ecx
  80093a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80093d:	01 c8                	add    %ecx,%eax
  80093f:	39 c2                	cmp    %eax,%edx
  800941:	74 17                	je     80095a <_main+0x901>
  800943:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80094a:	83 ec 0c             	sub    $0xc,%esp
  80094d:	68 68 36 80 00       	push   $0x803668
  800952:	e8 2e 0c 00 00       	call   801585 <cprintf>
  800957:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 0 /*no table*/ ;
  80095a:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  800961:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800964:	e8 d7 1d 00 00       	call   802740 <sys_calculate_free_frames>
  800969:	29 c3                	sub    %eax,%ebx
  80096b:	89 d8                	mov    %ebx,%eax
  80096d:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  800970:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800973:	83 c0 02             	add    $0x2,%eax
  800976:	83 ec 04             	sub    $0x4,%esp
  800979:	50                   	push   %eax
  80097a:	ff 75 c4             	pushl  -0x3c(%ebp)
  80097d:	ff 75 c0             	pushl  -0x40(%ebp)
  800980:	e8 b3 f6 ff ff       	call   800038 <inRange>
  800985:	83 c4 10             	add    $0x10,%esp
  800988:	85 c0                	test   %eax,%eax
  80098a:	75 21                	jne    8009ad <_main+0x954>
			{is_correct = 0; cprintf("6 Wrong allocation: unexpected number of pages that are allocated in memory! Expected = [%d, %d], Actual = %d\n", expectedNumOfFrames, expectedNumOfFrames+2, actualNumOfFrames);}
  80098c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800993:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800996:	83 c0 02             	add    $0x2,%eax
  800999:	ff 75 c0             	pushl  -0x40(%ebp)
  80099c:	50                   	push   %eax
  80099d:	ff 75 c4             	pushl  -0x3c(%ebp)
  8009a0:	68 9c 36 80 00       	push   $0x80369c
  8009a5:	e8 db 0b 00 00       	call   801585 <cprintf>
  8009aa:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("6 Extra or less pages are allocated in PageFile\n");}
  8009ad:	e8 d9 1d 00 00       	call   80278b <sys_pf_calculate_allocated_pages>
  8009b2:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8009b5:	74 17                	je     8009ce <_main+0x975>
  8009b7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8009be:	83 ec 0c             	sub    $0xc,%esp
  8009c1:	68 0c 37 80 00       	push   $0x80370c
  8009c6:	e8 ba 0b 00 00       	call   801585 <cprintf>
  8009cb:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)
  8009ce:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8009d2:	74 04                	je     8009d8 <_main+0x97f>
		{
			eval += 10;
  8009d4:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		}

		is_correct = 1;
  8009d8:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

		//6 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  8009df:	e8 5c 1d 00 00       	call   802740 <sys_calculate_free_frames>
  8009e4:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8009e7:	e8 9f 1d 00 00       	call   80278b <sys_pf_calculate_allocated_pages>
  8009ec:	89 45 c8             	mov    %eax,-0x38(%ebp)
			ptr_allocations[6] = malloc(6*Mega-kilo);
  8009ef:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009f2:	89 d0                	mov    %edx,%eax
  8009f4:	01 c0                	add    %eax,%eax
  8009f6:	01 d0                	add    %edx,%eax
  8009f8:	01 c0                	add    %eax,%eax
  8009fa:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8009fd:	83 ec 0c             	sub    $0xc,%esp
  800a00:	50                   	push   %eax
  800a01:	e8 41 1b 00 00       	call   802547 <malloc>
  800a06:	83 c4 10             	add    $0x10,%esp
  800a09:	89 85 1c ff ff ff    	mov    %eax,-0xe4(%ebp)
			if ((uint32) ptr_allocations[6] != (pagealloc_start + 7*Mega + 16*kilo)) { is_correct = 0; cprintf("7 Wrong start address for the allocated space... \n");}
  800a0f:	8b 85 1c ff ff ff    	mov    -0xe4(%ebp),%eax
  800a15:	89 c1                	mov    %eax,%ecx
  800a17:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a1a:	89 d0                	mov    %edx,%eax
  800a1c:	01 c0                	add    %eax,%eax
  800a1e:	01 d0                	add    %edx,%eax
  800a20:	01 c0                	add    %eax,%eax
  800a22:	01 d0                	add    %edx,%eax
  800a24:	89 c2                	mov    %eax,%edx
  800a26:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800a29:	c1 e0 04             	shl    $0x4,%eax
  800a2c:	01 c2                	add    %eax,%edx
  800a2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a31:	01 d0                	add    %edx,%eax
  800a33:	39 c1                	cmp    %eax,%ecx
  800a35:	74 17                	je     800a4e <_main+0x9f5>
  800a37:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800a3e:	83 ec 0c             	sub    $0xc,%esp
  800a41:	68 40 37 80 00       	push   $0x803740
  800a46:	e8 3a 0b 00 00       	call   801585 <cprintf>
  800a4b:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 2 /*table*/ ;
  800a4e:	c7 45 c4 02 00 00 00 	movl   $0x2,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  800a55:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800a58:	e8 e3 1c 00 00       	call   802740 <sys_calculate_free_frames>
  800a5d:	29 c3                	sub    %eax,%ebx
  800a5f:	89 d8                	mov    %ebx,%eax
  800a61:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  800a64:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800a67:	83 c0 02             	add    $0x2,%eax
  800a6a:	83 ec 04             	sub    $0x4,%esp
  800a6d:	50                   	push   %eax
  800a6e:	ff 75 c4             	pushl  -0x3c(%ebp)
  800a71:	ff 75 c0             	pushl  -0x40(%ebp)
  800a74:	e8 bf f5 ff ff       	call   800038 <inRange>
  800a79:	83 c4 10             	add    $0x10,%esp
  800a7c:	85 c0                	test   %eax,%eax
  800a7e:	75 21                	jne    800aa1 <_main+0xa48>
			{is_correct = 0; cprintf("7 Wrong allocation: unexpected number of pages that are allocated in memory! Expected = [%d, %d], Actual = %d\n", expectedNumOfFrames, expectedNumOfFrames+2, actualNumOfFrames);}
  800a80:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800a87:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800a8a:	83 c0 02             	add    $0x2,%eax
  800a8d:	ff 75 c0             	pushl  -0x40(%ebp)
  800a90:	50                   	push   %eax
  800a91:	ff 75 c4             	pushl  -0x3c(%ebp)
  800a94:	68 74 37 80 00       	push   $0x803774
  800a99:	e8 e7 0a 00 00       	call   801585 <cprintf>
  800a9e:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("7 Extra or less pages are allocated in PageFile\n");}
  800aa1:	e8 e5 1c 00 00       	call   80278b <sys_pf_calculate_allocated_pages>
  800aa6:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800aa9:	74 17                	je     800ac2 <_main+0xa69>
  800aab:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ab2:	83 ec 0c             	sub    $0xc,%esp
  800ab5:	68 e4 37 80 00       	push   $0x8037e4
  800aba:	e8 c6 0a 00 00       	call   801585 <cprintf>
  800abf:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  800ac2:	e8 79 1c 00 00       	call   802740 <sys_calculate_free_frames>
  800ac7:	89 45 cc             	mov    %eax,-0x34(%ebp)
			lastIndexOfByte2 = (6*Mega-kilo)/sizeof(char) - 1;
  800aca:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800acd:	89 d0                	mov    %edx,%eax
  800acf:	01 c0                	add    %eax,%eax
  800ad1:	01 d0                	add    %edx,%eax
  800ad3:	01 c0                	add    %eax,%eax
  800ad5:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800ad8:	48                   	dec    %eax
  800ad9:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
			byteArr2 = (char *) ptr_allocations[6];
  800adf:	8b 85 1c ff ff ff    	mov    -0xe4(%ebp),%eax
  800ae5:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
			byteArr2[0] = minByte ;
  800aeb:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800af1:	8a 55 e3             	mov    -0x1d(%ebp),%dl
  800af4:	88 10                	mov    %dl,(%eax)
			byteArr2[lastIndexOfByte2 / 2] = maxByte / 2;
  800af6:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800afc:	89 c2                	mov    %eax,%edx
  800afe:	c1 ea 1f             	shr    $0x1f,%edx
  800b01:	01 d0                	add    %edx,%eax
  800b03:	d1 f8                	sar    %eax
  800b05:	89 c2                	mov    %eax,%edx
  800b07:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800b0d:	01 c2                	add    %eax,%edx
  800b0f:	8a 45 e2             	mov    -0x1e(%ebp),%al
  800b12:	88 c1                	mov    %al,%cl
  800b14:	c0 e9 07             	shr    $0x7,%cl
  800b17:	01 c8                	add    %ecx,%eax
  800b19:	d0 f8                	sar    %al
  800b1b:	88 02                	mov    %al,(%edx)
			byteArr2[lastIndexOfByte2] = maxByte ;
  800b1d:	8b 95 78 ff ff ff    	mov    -0x88(%ebp),%edx
  800b23:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800b29:	01 c2                	add    %eax,%edx
  800b2b:	8a 45 e2             	mov    -0x1e(%ebp),%al
  800b2e:	88 02                	mov    %al,(%edx)
			expectedNumOfFrames = 3 ;
  800b30:	c7 45 c4 03 00 00 00 	movl   $0x3,-0x3c(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  800b37:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800b3a:	e8 01 1c 00 00       	call   802740 <sys_calculate_free_frames>
  800b3f:	29 c3                	sub    %eax,%ebx
  800b41:	89 d8                	mov    %ebx,%eax
  800b43:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  800b46:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800b49:	83 c0 02             	add    $0x2,%eax
  800b4c:	83 ec 04             	sub    $0x4,%esp
  800b4f:	50                   	push   %eax
  800b50:	ff 75 c4             	pushl  -0x3c(%ebp)
  800b53:	ff 75 c0             	pushl  -0x40(%ebp)
  800b56:	e8 dd f4 ff ff       	call   800038 <inRange>
  800b5b:	83 c4 10             	add    $0x10,%esp
  800b5e:	85 c0                	test   %eax,%eax
  800b60:	75 1d                	jne    800b7f <_main+0xb26>
			{ is_correct = 0; cprintf("7 Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);}
  800b62:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800b69:	83 ec 04             	sub    $0x4,%esp
  800b6c:	ff 75 c0             	pushl  -0x40(%ebp)
  800b6f:	ff 75 c4             	pushl  -0x3c(%ebp)
  800b72:	68 18 38 80 00       	push   $0x803818
  800b77:	e8 09 0a 00 00       	call   801585 <cprintf>
  800b7c:	83 c4 10             	add    $0x10,%esp
			uint32 expectedVAs[3] = { ROUNDDOWN((uint32)(&(byteArr2[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE)} ;
  800b7f:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800b85:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
  800b8b:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800b91:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b96:	89 85 d8 fe ff ff    	mov    %eax,-0x128(%ebp)
  800b9c:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800ba2:	89 c2                	mov    %eax,%edx
  800ba4:	c1 ea 1f             	shr    $0x1f,%edx
  800ba7:	01 d0                	add    %edx,%eax
  800ba9:	d1 f8                	sar    %eax
  800bab:	89 c2                	mov    %eax,%edx
  800bad:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800bb3:	01 d0                	add    %edx,%eax
  800bb5:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
  800bbb:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800bc1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800bc6:	89 85 dc fe ff ff    	mov    %eax,-0x124(%ebp)
  800bcc:	8b 95 78 ff ff ff    	mov    -0x88(%ebp),%edx
  800bd2:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800bd8:	01 d0                	add    %edx,%eax
  800bda:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
  800be0:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  800be6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800beb:	89 85 e0 fe ff ff    	mov    %eax,-0x120(%ebp)
			found = sys_check_WS_list(expectedVAs, 3, 0, 2);
  800bf1:	6a 02                	push   $0x2
  800bf3:	6a 00                	push   $0x0
  800bf5:	6a 03                	push   $0x3
  800bf7:	8d 85 d8 fe ff ff    	lea    -0x128(%ebp),%eax
  800bfd:	50                   	push   %eax
  800bfe:	e8 ff 1e 00 00       	call   802b02 <sys_check_WS_list>
  800c03:	83 c4 10             	add    $0x10,%esp
  800c06:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("7 malloc: page is not added to WS\n");}
  800c09:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  800c0d:	74 17                	je     800c26 <_main+0xbcd>
  800c0f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800c16:	83 ec 0c             	sub    $0xc,%esp
  800c19:	68 98 38 80 00       	push   $0x803898
  800c1e:	e8 62 09 00 00       	call   801585 <cprintf>
  800c23:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)
  800c26:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800c2a:	74 04                	je     800c30 <_main+0xbd7>
		{
			eval += 10;
  800c2c:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		}

		is_correct = 1;
  800c30:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

		//14 KB
		{
			freeFrames = sys_calculate_free_frames() ;
  800c37:	e8 04 1b 00 00       	call   802740 <sys_calculate_free_frames>
  800c3c:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800c3f:	e8 47 1b 00 00       	call   80278b <sys_pf_calculate_allocated_pages>
  800c44:	89 45 c8             	mov    %eax,-0x38(%ebp)
			ptr_allocations[7] = malloc(14*kilo);
  800c47:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800c4a:	89 d0                	mov    %edx,%eax
  800c4c:	01 c0                	add    %eax,%eax
  800c4e:	01 d0                	add    %edx,%eax
  800c50:	01 c0                	add    %eax,%eax
  800c52:	01 d0                	add    %edx,%eax
  800c54:	01 c0                	add    %eax,%eax
  800c56:	83 ec 0c             	sub    $0xc,%esp
  800c59:	50                   	push   %eax
  800c5a:	e8 e8 18 00 00       	call   802547 <malloc>
  800c5f:	83 c4 10             	add    $0x10,%esp
  800c62:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
			if ((uint32) ptr_allocations[7] != (pagealloc_start + 13*Mega + 16*kilo)) { is_correct = 0; cprintf("8 Wrong start address for the allocated space... \n");}
  800c68:	8b 85 20 ff ff ff    	mov    -0xe0(%ebp),%eax
  800c6e:	89 c1                	mov    %eax,%ecx
  800c70:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800c73:	89 d0                	mov    %edx,%eax
  800c75:	01 c0                	add    %eax,%eax
  800c77:	01 d0                	add    %edx,%eax
  800c79:	c1 e0 02             	shl    $0x2,%eax
  800c7c:	01 d0                	add    %edx,%eax
  800c7e:	89 c2                	mov    %eax,%edx
  800c80:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800c83:	c1 e0 04             	shl    $0x4,%eax
  800c86:	01 c2                	add    %eax,%edx
  800c88:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c8b:	01 d0                	add    %edx,%eax
  800c8d:	39 c1                	cmp    %eax,%ecx
  800c8f:	74 17                	je     800ca8 <_main+0xc4f>
  800c91:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800c98:	83 ec 0c             	sub    $0xc,%esp
  800c9b:	68 bc 38 80 00       	push   $0x8038bc
  800ca0:	e8 e0 08 00 00       	call   801585 <cprintf>
  800ca5:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 0 /*table*/ ;
  800ca8:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  800caf:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800cb2:	e8 89 1a 00 00       	call   802740 <sys_calculate_free_frames>
  800cb7:	29 c3                	sub    %eax,%ebx
  800cb9:	89 d8                	mov    %ebx,%eax
  800cbb:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  800cbe:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800cc1:	83 c0 02             	add    $0x2,%eax
  800cc4:	83 ec 04             	sub    $0x4,%esp
  800cc7:	50                   	push   %eax
  800cc8:	ff 75 c4             	pushl  -0x3c(%ebp)
  800ccb:	ff 75 c0             	pushl  -0x40(%ebp)
  800cce:	e8 65 f3 ff ff       	call   800038 <inRange>
  800cd3:	83 c4 10             	add    $0x10,%esp
  800cd6:	85 c0                	test   %eax,%eax
  800cd8:	75 21                	jne    800cfb <_main+0xca2>
			{is_correct = 0; cprintf("8 Wrong allocation: unexpected number of pages that are allocated in memory! Expected = [%d, %d], Actual = %d\n", expectedNumOfFrames, expectedNumOfFrames+2, actualNumOfFrames);}
  800cda:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ce1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800ce4:	83 c0 02             	add    $0x2,%eax
  800ce7:	ff 75 c0             	pushl  -0x40(%ebp)
  800cea:	50                   	push   %eax
  800ceb:	ff 75 c4             	pushl  -0x3c(%ebp)
  800cee:	68 f0 38 80 00       	push   $0x8038f0
  800cf3:	e8 8d 08 00 00       	call   801585 <cprintf>
  800cf8:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("8 Extra or less pages are allocated in PageFile\n");}
  800cfb:	e8 8b 1a 00 00       	call   80278b <sys_pf_calculate_allocated_pages>
  800d00:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800d03:	74 17                	je     800d1c <_main+0xcc3>
  800d05:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800d0c:	83 ec 0c             	sub    $0xc,%esp
  800d0f:	68 60 39 80 00       	push   $0x803960
  800d14:	e8 6c 08 00 00       	call   801585 <cprintf>
  800d19:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  800d1c:	e8 1f 1a 00 00       	call   802740 <sys_calculate_free_frames>
  800d21:	89 45 cc             	mov    %eax,-0x34(%ebp)
			shortArr2 = (short *) ptr_allocations[7];
  800d24:	8b 85 20 ff ff ff    	mov    -0xe0(%ebp),%eax
  800d2a:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
			lastIndexOfShort2 = (14*kilo)/sizeof(short) - 1;
  800d30:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800d33:	89 d0                	mov    %edx,%eax
  800d35:	01 c0                	add    %eax,%eax
  800d37:	01 d0                	add    %edx,%eax
  800d39:	01 c0                	add    %eax,%eax
  800d3b:	01 d0                	add    %edx,%eax
  800d3d:	01 c0                	add    %eax,%eax
  800d3f:	d1 e8                	shr    %eax
  800d41:	48                   	dec    %eax
  800d42:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
			shortArr2[0] = minShort;
  800d48:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  800d4e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d51:	66 89 02             	mov    %ax,(%edx)
			shortArr2[lastIndexOfShort2 / 2] = maxShort / 2;
  800d54:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800d5a:	89 c2                	mov    %eax,%edx
  800d5c:	c1 ea 1f             	shr    $0x1f,%edx
  800d5f:	01 d0                	add    %edx,%eax
  800d61:	d1 f8                	sar    %eax
  800d63:	01 c0                	add    %eax,%eax
  800d65:	89 c2                	mov    %eax,%edx
  800d67:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  800d6d:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800d70:	66 8b 45 de          	mov    -0x22(%ebp),%ax
  800d74:	89 c2                	mov    %eax,%edx
  800d76:	66 c1 ea 0f          	shr    $0xf,%dx
  800d7a:	01 d0                	add    %edx,%eax
  800d7c:	66 d1 f8             	sar    %ax
  800d7f:	66 89 01             	mov    %ax,(%ecx)
			shortArr2[lastIndexOfShort2] = maxShort;
  800d82:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800d88:	01 c0                	add    %eax,%eax
  800d8a:	89 c2                	mov    %eax,%edx
  800d8c:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  800d92:	01 c2                	add    %eax,%edx
  800d94:	66 8b 45 de          	mov    -0x22(%ebp),%ax
  800d98:	66 89 02             	mov    %ax,(%edx)
			expectedNumOfFrames = 3 ;
  800d9b:	c7 45 c4 03 00 00 00 	movl   $0x3,-0x3c(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  800da2:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800da5:	e8 96 19 00 00       	call   802740 <sys_calculate_free_frames>
  800daa:	29 c3                	sub    %eax,%ebx
  800dac:	89 d8                	mov    %ebx,%eax
  800dae:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  800db1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800db4:	83 c0 02             	add    $0x2,%eax
  800db7:	83 ec 04             	sub    $0x4,%esp
  800dba:	50                   	push   %eax
  800dbb:	ff 75 c4             	pushl  -0x3c(%ebp)
  800dbe:	ff 75 c0             	pushl  -0x40(%ebp)
  800dc1:	e8 72 f2 ff ff       	call   800038 <inRange>
  800dc6:	83 c4 10             	add    $0x10,%esp
  800dc9:	85 c0                	test   %eax,%eax
  800dcb:	75 1d                	jne    800dea <_main+0xd91>
			{ is_correct = 0; cprintf("8 Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);}
  800dcd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800dd4:	83 ec 04             	sub    $0x4,%esp
  800dd7:	ff 75 c0             	pushl  -0x40(%ebp)
  800dda:	ff 75 c4             	pushl  -0x3c(%ebp)
  800ddd:	68 94 39 80 00       	push   $0x803994
  800de2:	e8 9e 07 00 00       	call   801585 <cprintf>
  800de7:	83 c4 10             	add    $0x10,%esp
			uint32 expectedVAs[3] = { ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2/2])), PAGE_SIZE), ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2])), PAGE_SIZE)} ;
  800dea:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  800df0:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  800df6:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800dfc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800e01:	89 85 cc fe ff ff    	mov    %eax,-0x134(%ebp)
  800e07:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800e0d:	89 c2                	mov    %eax,%edx
  800e0f:	c1 ea 1f             	shr    $0x1f,%edx
  800e12:	01 d0                	add    %edx,%eax
  800e14:	d1 f8                	sar    %eax
  800e16:	01 c0                	add    %eax,%eax
  800e18:	89 c2                	mov    %eax,%edx
  800e1a:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  800e20:	01 d0                	add    %edx,%eax
  800e22:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
  800e28:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800e2e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800e33:	89 85 d0 fe ff ff    	mov    %eax,-0x130(%ebp)
  800e39:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800e3f:	01 c0                	add    %eax,%eax
  800e41:	89 c2                	mov    %eax,%edx
  800e43:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  800e49:	01 d0                	add    %edx,%eax
  800e4b:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
  800e51:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  800e57:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800e5c:	89 85 d4 fe ff ff    	mov    %eax,-0x12c(%ebp)
			found = sys_check_WS_list(expectedVAs, 3, 0, 2);
  800e62:	6a 02                	push   $0x2
  800e64:	6a 00                	push   $0x0
  800e66:	6a 03                	push   $0x3
  800e68:	8d 85 cc fe ff ff    	lea    -0x134(%ebp),%eax
  800e6e:	50                   	push   %eax
  800e6f:	e8 8e 1c 00 00       	call   802b02 <sys_check_WS_list>
  800e74:	83 c4 10             	add    $0x10,%esp
  800e77:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("8 malloc: page is not added to WS\n");}
  800e7a:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  800e7e:	74 17                	je     800e97 <_main+0xe3e>
  800e80:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800e87:	83 ec 0c             	sub    $0xc,%esp
  800e8a:	68 14 3a 80 00       	push   $0x803a14
  800e8f:	e8 f1 06 00 00       	call   801585 <cprintf>
  800e94:	83 c4 10             	add    $0x10,%esp
		}
	}
	if (is_correct)
  800e97:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800e9b:	74 04                	je     800ea1 <_main+0xe48>
	{
		eval += 10;
  800e9d:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
	}
	is_correct = 1;
  800ea1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	//Check that the values are successfully stored
	cprintf("\n%~[2] Check that the values are successfully stored [30%]\n");
  800ea8:	83 ec 0c             	sub    $0xc,%esp
  800eab:	68 38 3a 80 00       	push   $0x803a38
  800eb0:	e8 d0 06 00 00       	call   801585 <cprintf>
  800eb5:	83 c4 10             	add    $0x10,%esp
	{
		if (byteArr[0] 	!= minByte 	|| byteArr[lastIndexOfByte] 	!= maxByte) { is_correct = 0; cprintf("9 Wrong allocation: stored values are wrongly changed!\n");}
  800eb8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800ebb:	8a 00                	mov    (%eax),%al
  800ebd:	3a 45 e3             	cmp    -0x1d(%ebp),%al
  800ec0:	75 0f                	jne    800ed1 <_main+0xe78>
  800ec2:	8b 55 bc             	mov    -0x44(%ebp),%edx
  800ec5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800ec8:	01 d0                	add    %edx,%eax
  800eca:	8a 00                	mov    (%eax),%al
  800ecc:	3a 45 e2             	cmp    -0x1e(%ebp),%al
  800ecf:	74 17                	je     800ee8 <_main+0xe8f>
  800ed1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ed8:	83 ec 0c             	sub    $0xc,%esp
  800edb:	68 74 3a 80 00       	push   $0x803a74
  800ee0:	e8 a0 06 00 00       	call   801585 <cprintf>
  800ee5:	83 c4 10             	add    $0x10,%esp
		if (shortArr[0] != minShort || shortArr[lastIndexOfShort] 	!= maxShort) { is_correct = 0; cprintf("10 Wrong allocation: stored values are wrongly changed!\n");}
  800ee8:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800eeb:	66 8b 00             	mov    (%eax),%ax
  800eee:	66 3b 45 e0          	cmp    -0x20(%ebp),%ax
  800ef2:	75 15                	jne    800f09 <_main+0xeb0>
  800ef4:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800ef7:	01 c0                	add    %eax,%eax
  800ef9:	89 c2                	mov    %eax,%edx
  800efb:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800efe:	01 d0                	add    %edx,%eax
  800f00:	66 8b 00             	mov    (%eax),%ax
  800f03:	66 3b 45 de          	cmp    -0x22(%ebp),%ax
  800f07:	74 17                	je     800f20 <_main+0xec7>
  800f09:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800f10:	83 ec 0c             	sub    $0xc,%esp
  800f13:	68 ac 3a 80 00       	push   $0x803aac
  800f18:	e8 68 06 00 00       	call   801585 <cprintf>
  800f1d:	83 c4 10             	add    $0x10,%esp
		if (intArr[0] 	!= minInt 	|| intArr[lastIndexOfInt] 		!= maxInt) { is_correct = 0; cprintf("11 Wrong allocation: stored values are wrongly changed!\n");}
  800f20:	8b 45 98             	mov    -0x68(%ebp),%eax
  800f23:	8b 00                	mov    (%eax),%eax
  800f25:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800f28:	75 16                	jne    800f40 <_main+0xee7>
  800f2a:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800f2d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f34:	8b 45 98             	mov    -0x68(%ebp),%eax
  800f37:	01 d0                	add    %edx,%eax
  800f39:	8b 00                	mov    (%eax),%eax
  800f3b:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800f3e:	74 17                	je     800f57 <_main+0xefe>
  800f40:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800f47:	83 ec 0c             	sub    $0xc,%esp
  800f4a:	68 e8 3a 80 00       	push   $0x803ae8
  800f4f:	e8 31 06 00 00       	call   801585 <cprintf>
  800f54:	83 c4 10             	add    $0x10,%esp

		if (structArr[0].a != minByte 	|| structArr[lastIndexOfStruct].a != maxByte) 	{ is_correct = 0; cprintf("12 Wrong allocation: stored values are wrongly changed!\n");}
  800f57:	8b 45 88             	mov    -0x78(%ebp),%eax
  800f5a:	8a 00                	mov    (%eax),%al
  800f5c:	3a 45 e3             	cmp    -0x1d(%ebp),%al
  800f5f:	75 16                	jne    800f77 <_main+0xf1e>
  800f61:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800f64:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800f6b:	8b 45 88             	mov    -0x78(%ebp),%eax
  800f6e:	01 d0                	add    %edx,%eax
  800f70:	8a 00                	mov    (%eax),%al
  800f72:	3a 45 e2             	cmp    -0x1e(%ebp),%al
  800f75:	74 17                	je     800f8e <_main+0xf35>
  800f77:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800f7e:	83 ec 0c             	sub    $0xc,%esp
  800f81:	68 24 3b 80 00       	push   $0x803b24
  800f86:	e8 fa 05 00 00       	call   801585 <cprintf>
  800f8b:	83 c4 10             	add    $0x10,%esp
		if (structArr[0].b != minShort 	|| structArr[lastIndexOfStruct].b != maxShort) 	{ is_correct = 0; cprintf("13 Wrong allocation: stored values are wrongly changed!\n");}
  800f8e:	8b 45 88             	mov    -0x78(%ebp),%eax
  800f91:	66 8b 40 02          	mov    0x2(%eax),%ax
  800f95:	66 3b 45 e0          	cmp    -0x20(%ebp),%ax
  800f99:	75 19                	jne    800fb4 <_main+0xf5b>
  800f9b:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800f9e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800fa5:	8b 45 88             	mov    -0x78(%ebp),%eax
  800fa8:	01 d0                	add    %edx,%eax
  800faa:	66 8b 40 02          	mov    0x2(%eax),%ax
  800fae:	66 3b 45 de          	cmp    -0x22(%ebp),%ax
  800fb2:	74 17                	je     800fcb <_main+0xf72>
  800fb4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800fbb:	83 ec 0c             	sub    $0xc,%esp
  800fbe:	68 60 3b 80 00       	push   $0x803b60
  800fc3:	e8 bd 05 00 00       	call   801585 <cprintf>
  800fc8:	83 c4 10             	add    $0x10,%esp
		if (structArr[0].c != minInt 	|| structArr[lastIndexOfStruct].c != maxInt) 	{ is_correct = 0; cprintf("14 Wrong allocation: stored values are wrongly changed!\n");}
  800fcb:	8b 45 88             	mov    -0x78(%ebp),%eax
  800fce:	8b 40 04             	mov    0x4(%eax),%eax
  800fd1:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800fd4:	75 17                	jne    800fed <_main+0xf94>
  800fd6:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800fd9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800fe0:	8b 45 88             	mov    -0x78(%ebp),%eax
  800fe3:	01 d0                	add    %edx,%eax
  800fe5:	8b 40 04             	mov    0x4(%eax),%eax
  800fe8:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800feb:	74 17                	je     801004 <_main+0xfab>
  800fed:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ff4:	83 ec 0c             	sub    $0xc,%esp
  800ff7:	68 9c 3b 80 00       	push   $0x803b9c
  800ffc:	e8 84 05 00 00       	call   801585 <cprintf>
  801001:	83 c4 10             	add    $0x10,%esp

		if (byteArr2[0]  != minByte  || byteArr2[lastIndexOfByte2/2]   != maxByte/2 	|| byteArr2[lastIndexOfByte2] 	!= maxByte) { is_correct = 0; cprintf("15 Wrong allocation: stored values are wrongly changed!\n");}
  801004:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  80100a:	8a 00                	mov    (%eax),%al
  80100c:	3a 45 e3             	cmp    -0x1d(%ebp),%al
  80100f:	75 40                	jne    801051 <_main+0xff8>
  801011:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  801017:	89 c2                	mov    %eax,%edx
  801019:	c1 ea 1f             	shr    $0x1f,%edx
  80101c:	01 d0                	add    %edx,%eax
  80101e:	d1 f8                	sar    %eax
  801020:	89 c2                	mov    %eax,%edx
  801022:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  801028:	01 d0                	add    %edx,%eax
  80102a:	8a 10                	mov    (%eax),%dl
  80102c:	8a 45 e2             	mov    -0x1e(%ebp),%al
  80102f:	88 c1                	mov    %al,%cl
  801031:	c0 e9 07             	shr    $0x7,%cl
  801034:	01 c8                	add    %ecx,%eax
  801036:	d0 f8                	sar    %al
  801038:	38 c2                	cmp    %al,%dl
  80103a:	75 15                	jne    801051 <_main+0xff8>
  80103c:	8b 95 78 ff ff ff    	mov    -0x88(%ebp),%edx
  801042:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  801048:	01 d0                	add    %edx,%eax
  80104a:	8a 00                	mov    (%eax),%al
  80104c:	3a 45 e2             	cmp    -0x1e(%ebp),%al
  80104f:	74 17                	je     801068 <_main+0x100f>
  801051:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801058:	83 ec 0c             	sub    $0xc,%esp
  80105b:	68 d8 3b 80 00       	push   $0x803bd8
  801060:	e8 20 05 00 00       	call   801585 <cprintf>
  801065:	83 c4 10             	add    $0x10,%esp
		if (shortArr2[0] != minShort || shortArr2[lastIndexOfShort2/2] != maxShort/2 || shortArr2[lastIndexOfShort2] 	!= maxShort) { is_correct = 0; cprintf("16 Wrong allocation: stored values are wrongly changed!\n");}
  801068:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  80106e:	66 8b 00             	mov    (%eax),%ax
  801071:	66 3b 45 e0          	cmp    -0x20(%ebp),%ax
  801075:	75 4d                	jne    8010c4 <_main+0x106b>
  801077:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  80107d:	89 c2                	mov    %eax,%edx
  80107f:	c1 ea 1f             	shr    $0x1f,%edx
  801082:	01 d0                	add    %edx,%eax
  801084:	d1 f8                	sar    %eax
  801086:	01 c0                	add    %eax,%eax
  801088:	89 c2                	mov    %eax,%edx
  80108a:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  801090:	01 d0                	add    %edx,%eax
  801092:	66 8b 10             	mov    (%eax),%dx
  801095:	66 8b 45 de          	mov    -0x22(%ebp),%ax
  801099:	89 c1                	mov    %eax,%ecx
  80109b:	66 c1 e9 0f          	shr    $0xf,%cx
  80109f:	01 c8                	add    %ecx,%eax
  8010a1:	66 d1 f8             	sar    %ax
  8010a4:	66 39 c2             	cmp    %ax,%dx
  8010a7:	75 1b                	jne    8010c4 <_main+0x106b>
  8010a9:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  8010af:	01 c0                	add    %eax,%eax
  8010b1:	89 c2                	mov    %eax,%edx
  8010b3:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  8010b9:	01 d0                	add    %edx,%eax
  8010bb:	66 8b 00             	mov    (%eax),%ax
  8010be:	66 3b 45 de          	cmp    -0x22(%ebp),%ax
  8010c2:	74 17                	je     8010db <_main+0x1082>
  8010c4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8010cb:	83 ec 0c             	sub    $0xc,%esp
  8010ce:	68 14 3c 80 00       	push   $0x803c14
  8010d3:	e8 ad 04 00 00       	call   801585 <cprintf>
  8010d8:	83 c4 10             	add    $0x10,%esp

	}
	if (is_correct)
  8010db:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8010df:	74 04                	je     8010e5 <_main+0x108c>
	{
		eval += 30;
  8010e1:	83 45 f4 1e          	addl   $0x1e,-0xc(%ebp)
	}

	is_correct = 1;
  8010e5:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	cprintf("%~\nTest malloc (1) [PAGE ALLOCATOR] completed. Eval = %d\n", eval);
  8010ec:	83 ec 08             	sub    $0x8,%esp
  8010ef:	ff 75 f4             	pushl  -0xc(%ebp)
  8010f2:	68 50 3c 80 00       	push   $0x803c50
  8010f7:	e8 89 04 00 00       	call   801585 <cprintf>
  8010fc:	83 c4 10             	add    $0x10,%esp

	return;
  8010ff:	90                   	nop
}
  801100:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801103:	5b                   	pop    %ebx
  801104:	5f                   	pop    %edi
  801105:	5d                   	pop    %ebp
  801106:	c3                   	ret    

00801107 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  801107:	55                   	push   %ebp
  801108:	89 e5                	mov    %esp,%ebp
  80110a:	57                   	push   %edi
  80110b:	56                   	push   %esi
  80110c:	53                   	push   %ebx
  80110d:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  801110:	e8 f4 17 00 00       	call   802909 <sys_getenvindex>
  801115:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  801118:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80111b:	89 d0                	mov    %edx,%eax
  80111d:	c1 e0 02             	shl    $0x2,%eax
  801120:	01 d0                	add    %edx,%eax
  801122:	c1 e0 03             	shl    $0x3,%eax
  801125:	01 d0                	add    %edx,%eax
  801127:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80112e:	01 d0                	add    %edx,%eax
  801130:	c1 e0 02             	shl    $0x2,%eax
  801133:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801138:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80113d:	a1 20 50 80 00       	mov    0x805020,%eax
  801142:	8a 40 20             	mov    0x20(%eax),%al
  801145:	84 c0                	test   %al,%al
  801147:	74 0d                	je     801156 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  801149:	a1 20 50 80 00       	mov    0x805020,%eax
  80114e:	83 c0 20             	add    $0x20,%eax
  801151:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  801156:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80115a:	7e 0a                	jle    801166 <libmain+0x5f>
		binaryname = argv[0];
  80115c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115f:	8b 00                	mov    (%eax),%eax
  801161:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  801166:	83 ec 08             	sub    $0x8,%esp
  801169:	ff 75 0c             	pushl  0xc(%ebp)
  80116c:	ff 75 08             	pushl  0x8(%ebp)
  80116f:	e8 e5 ee ff ff       	call   800059 <_main>
  801174:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  801177:	a1 00 50 80 00       	mov    0x805000,%eax
  80117c:	85 c0                	test   %eax,%eax
  80117e:	0f 84 01 01 00 00    	je     801285 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  801184:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80118a:	bb 84 3d 80 00       	mov    $0x803d84,%ebx
  80118f:	ba 0e 00 00 00       	mov    $0xe,%edx
  801194:	89 c7                	mov    %eax,%edi
  801196:	89 de                	mov    %ebx,%esi
  801198:	89 d1                	mov    %edx,%ecx
  80119a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80119c:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80119f:	b9 56 00 00 00       	mov    $0x56,%ecx
  8011a4:	b0 00                	mov    $0x0,%al
  8011a6:	89 d7                	mov    %edx,%edi
  8011a8:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8011aa:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8011b1:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8011b4:	83 ec 08             	sub    $0x8,%esp
  8011b7:	50                   	push   %eax
  8011b8:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8011be:	50                   	push   %eax
  8011bf:	e8 7b 19 00 00       	call   802b3f <sys_utilities>
  8011c4:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8011c7:	e8 c4 14 00 00       	call   802690 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8011cc:	83 ec 0c             	sub    $0xc,%esp
  8011cf:	68 a4 3c 80 00       	push   $0x803ca4
  8011d4:	e8 ac 03 00 00       	call   801585 <cprintf>
  8011d9:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8011dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011df:	85 c0                	test   %eax,%eax
  8011e1:	74 18                	je     8011fb <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8011e3:	e8 75 19 00 00       	call   802b5d <sys_get_optimal_num_faults>
  8011e8:	83 ec 08             	sub    $0x8,%esp
  8011eb:	50                   	push   %eax
  8011ec:	68 cc 3c 80 00       	push   $0x803ccc
  8011f1:	e8 8f 03 00 00       	call   801585 <cprintf>
  8011f6:	83 c4 10             	add    $0x10,%esp
  8011f9:	eb 59                	jmp    801254 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8011fb:	a1 20 50 80 00       	mov    0x805020,%eax
  801200:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  801206:	a1 20 50 80 00       	mov    0x805020,%eax
  80120b:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  801211:	83 ec 04             	sub    $0x4,%esp
  801214:	52                   	push   %edx
  801215:	50                   	push   %eax
  801216:	68 f0 3c 80 00       	push   $0x803cf0
  80121b:	e8 65 03 00 00       	call   801585 <cprintf>
  801220:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  801223:	a1 20 50 80 00       	mov    0x805020,%eax
  801228:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  80122e:	a1 20 50 80 00       	mov    0x805020,%eax
  801233:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  801239:	a1 20 50 80 00       	mov    0x805020,%eax
  80123e:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  801244:	51                   	push   %ecx
  801245:	52                   	push   %edx
  801246:	50                   	push   %eax
  801247:	68 18 3d 80 00       	push   $0x803d18
  80124c:	e8 34 03 00 00       	call   801585 <cprintf>
  801251:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  801254:	a1 20 50 80 00       	mov    0x805020,%eax
  801259:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  80125f:	83 ec 08             	sub    $0x8,%esp
  801262:	50                   	push   %eax
  801263:	68 70 3d 80 00       	push   $0x803d70
  801268:	e8 18 03 00 00       	call   801585 <cprintf>
  80126d:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  801270:	83 ec 0c             	sub    $0xc,%esp
  801273:	68 a4 3c 80 00       	push   $0x803ca4
  801278:	e8 08 03 00 00       	call   801585 <cprintf>
  80127d:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  801280:	e8 25 14 00 00       	call   8026aa <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  801285:	e8 1f 00 00 00       	call   8012a9 <exit>
}
  80128a:	90                   	nop
  80128b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80128e:	5b                   	pop    %ebx
  80128f:	5e                   	pop    %esi
  801290:	5f                   	pop    %edi
  801291:	5d                   	pop    %ebp
  801292:	c3                   	ret    

00801293 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  801293:	55                   	push   %ebp
  801294:	89 e5                	mov    %esp,%ebp
  801296:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  801299:	83 ec 0c             	sub    $0xc,%esp
  80129c:	6a 00                	push   $0x0
  80129e:	e8 32 16 00 00       	call   8028d5 <sys_destroy_env>
  8012a3:	83 c4 10             	add    $0x10,%esp
}
  8012a6:	90                   	nop
  8012a7:	c9                   	leave  
  8012a8:	c3                   	ret    

008012a9 <exit>:

void
exit(void)
{
  8012a9:	55                   	push   %ebp
  8012aa:	89 e5                	mov    %esp,%ebp
  8012ac:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8012af:	e8 87 16 00 00       	call   80293b <sys_exit_env>
}
  8012b4:	90                   	nop
  8012b5:	c9                   	leave  
  8012b6:	c3                   	ret    

008012b7 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8012b7:	55                   	push   %ebp
  8012b8:	89 e5                	mov    %esp,%ebp
  8012ba:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8012bd:	8d 45 10             	lea    0x10(%ebp),%eax
  8012c0:	83 c0 04             	add    $0x4,%eax
  8012c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8012c6:	a1 18 d1 81 00       	mov    0x81d118,%eax
  8012cb:	85 c0                	test   %eax,%eax
  8012cd:	74 16                	je     8012e5 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8012cf:	a1 18 d1 81 00       	mov    0x81d118,%eax
  8012d4:	83 ec 08             	sub    $0x8,%esp
  8012d7:	50                   	push   %eax
  8012d8:	68 e8 3d 80 00       	push   $0x803de8
  8012dd:	e8 a3 02 00 00       	call   801585 <cprintf>
  8012e2:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8012e5:	a1 04 50 80 00       	mov    0x805004,%eax
  8012ea:	83 ec 0c             	sub    $0xc,%esp
  8012ed:	ff 75 0c             	pushl  0xc(%ebp)
  8012f0:	ff 75 08             	pushl  0x8(%ebp)
  8012f3:	50                   	push   %eax
  8012f4:	68 f0 3d 80 00       	push   $0x803df0
  8012f9:	6a 74                	push   $0x74
  8012fb:	e8 b2 02 00 00       	call   8015b2 <cprintf_colored>
  801300:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  801303:	8b 45 10             	mov    0x10(%ebp),%eax
  801306:	83 ec 08             	sub    $0x8,%esp
  801309:	ff 75 f4             	pushl  -0xc(%ebp)
  80130c:	50                   	push   %eax
  80130d:	e8 04 02 00 00       	call   801516 <vcprintf>
  801312:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801315:	83 ec 08             	sub    $0x8,%esp
  801318:	6a 00                	push   $0x0
  80131a:	68 18 3e 80 00       	push   $0x803e18
  80131f:	e8 f2 01 00 00       	call   801516 <vcprintf>
  801324:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801327:	e8 7d ff ff ff       	call   8012a9 <exit>

	// should not return here
	while (1) ;
  80132c:	eb fe                	jmp    80132c <_panic+0x75>

0080132e <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80132e:	55                   	push   %ebp
  80132f:	89 e5                	mov    %esp,%ebp
  801331:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801334:	a1 20 50 80 00       	mov    0x805020,%eax
  801339:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80133f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801342:	39 c2                	cmp    %eax,%edx
  801344:	74 14                	je     80135a <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801346:	83 ec 04             	sub    $0x4,%esp
  801349:	68 1c 3e 80 00       	push   $0x803e1c
  80134e:	6a 26                	push   $0x26
  801350:	68 68 3e 80 00       	push   $0x803e68
  801355:	e8 5d ff ff ff       	call   8012b7 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80135a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801361:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801368:	e9 c5 00 00 00       	jmp    801432 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80136d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801370:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801377:	8b 45 08             	mov    0x8(%ebp),%eax
  80137a:	01 d0                	add    %edx,%eax
  80137c:	8b 00                	mov    (%eax),%eax
  80137e:	85 c0                	test   %eax,%eax
  801380:	75 08                	jne    80138a <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801382:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801385:	e9 a5 00 00 00       	jmp    80142f <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80138a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801391:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801398:	eb 69                	jmp    801403 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80139a:	a1 20 50 80 00       	mov    0x805020,%eax
  80139f:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8013a5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8013a8:	89 d0                	mov    %edx,%eax
  8013aa:	01 c0                	add    %eax,%eax
  8013ac:	01 d0                	add    %edx,%eax
  8013ae:	c1 e0 03             	shl    $0x3,%eax
  8013b1:	01 c8                	add    %ecx,%eax
  8013b3:	8a 40 04             	mov    0x4(%eax),%al
  8013b6:	84 c0                	test   %al,%al
  8013b8:	75 46                	jne    801400 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8013ba:	a1 20 50 80 00       	mov    0x805020,%eax
  8013bf:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8013c5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8013c8:	89 d0                	mov    %edx,%eax
  8013ca:	01 c0                	add    %eax,%eax
  8013cc:	01 d0                	add    %edx,%eax
  8013ce:	c1 e0 03             	shl    $0x3,%eax
  8013d1:	01 c8                	add    %ecx,%eax
  8013d3:	8b 00                	mov    (%eax),%eax
  8013d5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8013d8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8013db:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013e0:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8013e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013e5:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8013ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ef:	01 c8                	add    %ecx,%eax
  8013f1:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8013f3:	39 c2                	cmp    %eax,%edx
  8013f5:	75 09                	jne    801400 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8013f7:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8013fe:	eb 15                	jmp    801415 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801400:	ff 45 e8             	incl   -0x18(%ebp)
  801403:	a1 20 50 80 00       	mov    0x805020,%eax
  801408:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80140e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801411:	39 c2                	cmp    %eax,%edx
  801413:	77 85                	ja     80139a <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801415:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801419:	75 14                	jne    80142f <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80141b:	83 ec 04             	sub    $0x4,%esp
  80141e:	68 74 3e 80 00       	push   $0x803e74
  801423:	6a 3a                	push   $0x3a
  801425:	68 68 3e 80 00       	push   $0x803e68
  80142a:	e8 88 fe ff ff       	call   8012b7 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80142f:	ff 45 f0             	incl   -0x10(%ebp)
  801432:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801435:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801438:	0f 8c 2f ff ff ff    	jl     80136d <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80143e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801445:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80144c:	eb 26                	jmp    801474 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80144e:	a1 20 50 80 00       	mov    0x805020,%eax
  801453:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  801459:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80145c:	89 d0                	mov    %edx,%eax
  80145e:	01 c0                	add    %eax,%eax
  801460:	01 d0                	add    %edx,%eax
  801462:	c1 e0 03             	shl    $0x3,%eax
  801465:	01 c8                	add    %ecx,%eax
  801467:	8a 40 04             	mov    0x4(%eax),%al
  80146a:	3c 01                	cmp    $0x1,%al
  80146c:	75 03                	jne    801471 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80146e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801471:	ff 45 e0             	incl   -0x20(%ebp)
  801474:	a1 20 50 80 00       	mov    0x805020,%eax
  801479:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80147f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801482:	39 c2                	cmp    %eax,%edx
  801484:	77 c8                	ja     80144e <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801486:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801489:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80148c:	74 14                	je     8014a2 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80148e:	83 ec 04             	sub    $0x4,%esp
  801491:	68 c8 3e 80 00       	push   $0x803ec8
  801496:	6a 44                	push   $0x44
  801498:	68 68 3e 80 00       	push   $0x803e68
  80149d:	e8 15 fe ff ff       	call   8012b7 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8014a2:	90                   	nop
  8014a3:	c9                   	leave  
  8014a4:	c3                   	ret    

008014a5 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8014a5:	55                   	push   %ebp
  8014a6:	89 e5                	mov    %esp,%ebp
  8014a8:	53                   	push   %ebx
  8014a9:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8014ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014af:	8b 00                	mov    (%eax),%eax
  8014b1:	8d 48 01             	lea    0x1(%eax),%ecx
  8014b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014b7:	89 0a                	mov    %ecx,(%edx)
  8014b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8014bc:	88 d1                	mov    %dl,%cl
  8014be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014c1:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8014c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c8:	8b 00                	mov    (%eax),%eax
  8014ca:	3d ff 00 00 00       	cmp    $0xff,%eax
  8014cf:	75 30                	jne    801501 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8014d1:	8b 15 1c d1 81 00    	mov    0x81d11c,%edx
  8014d7:	a0 44 50 80 00       	mov    0x805044,%al
  8014dc:	0f b6 c0             	movzbl %al,%eax
  8014df:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014e2:	8b 09                	mov    (%ecx),%ecx
  8014e4:	89 cb                	mov    %ecx,%ebx
  8014e6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014e9:	83 c1 08             	add    $0x8,%ecx
  8014ec:	52                   	push   %edx
  8014ed:	50                   	push   %eax
  8014ee:	53                   	push   %ebx
  8014ef:	51                   	push   %ecx
  8014f0:	e8 57 11 00 00       	call   80264c <sys_cputs>
  8014f5:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8014f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014fb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  801501:	8b 45 0c             	mov    0xc(%ebp),%eax
  801504:	8b 40 04             	mov    0x4(%eax),%eax
  801507:	8d 50 01             	lea    0x1(%eax),%edx
  80150a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80150d:	89 50 04             	mov    %edx,0x4(%eax)
}
  801510:	90                   	nop
  801511:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801514:	c9                   	leave  
  801515:	c3                   	ret    

00801516 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  801516:	55                   	push   %ebp
  801517:	89 e5                	mov    %esp,%ebp
  801519:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80151f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801526:	00 00 00 
	b.cnt = 0;
  801529:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801530:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  801533:	ff 75 0c             	pushl  0xc(%ebp)
  801536:	ff 75 08             	pushl  0x8(%ebp)
  801539:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80153f:	50                   	push   %eax
  801540:	68 a5 14 80 00       	push   $0x8014a5
  801545:	e8 5a 02 00 00       	call   8017a4 <vprintfmt>
  80154a:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  80154d:	8b 15 1c d1 81 00    	mov    0x81d11c,%edx
  801553:	a0 44 50 80 00       	mov    0x805044,%al
  801558:	0f b6 c0             	movzbl %al,%eax
  80155b:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  801561:	52                   	push   %edx
  801562:	50                   	push   %eax
  801563:	51                   	push   %ecx
  801564:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80156a:	83 c0 08             	add    $0x8,%eax
  80156d:	50                   	push   %eax
  80156e:	e8 d9 10 00 00       	call   80264c <sys_cputs>
  801573:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  801576:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
	return b.cnt;
  80157d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801583:	c9                   	leave  
  801584:	c3                   	ret    

00801585 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  801585:	55                   	push   %ebp
  801586:	89 e5                	mov    %esp,%ebp
  801588:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80158b:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	va_start(ap, fmt);
  801592:	8d 45 0c             	lea    0xc(%ebp),%eax
  801595:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801598:	8b 45 08             	mov    0x8(%ebp),%eax
  80159b:	83 ec 08             	sub    $0x8,%esp
  80159e:	ff 75 f4             	pushl  -0xc(%ebp)
  8015a1:	50                   	push   %eax
  8015a2:	e8 6f ff ff ff       	call   801516 <vcprintf>
  8015a7:	83 c4 10             	add    $0x10,%esp
  8015aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8015ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8015b0:	c9                   	leave  
  8015b1:	c3                   	ret    

008015b2 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8015b2:	55                   	push   %ebp
  8015b3:	89 e5                	mov    %esp,%ebp
  8015b5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8015b8:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	curTextClr = (textClr << 8) ; //set text color by the given value
  8015bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c2:	c1 e0 08             	shl    $0x8,%eax
  8015c5:	a3 1c d1 81 00       	mov    %eax,0x81d11c
	va_start(ap, fmt);
  8015ca:	8d 45 0c             	lea    0xc(%ebp),%eax
  8015cd:	83 c0 04             	add    $0x4,%eax
  8015d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8015d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d6:	83 ec 08             	sub    $0x8,%esp
  8015d9:	ff 75 f4             	pushl  -0xc(%ebp)
  8015dc:	50                   	push   %eax
  8015dd:	e8 34 ff ff ff       	call   801516 <vcprintf>
  8015e2:	83 c4 10             	add    $0x10,%esp
  8015e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8015e8:	c7 05 1c d1 81 00 00 	movl   $0x700,0x81d11c
  8015ef:	07 00 00 

	return cnt;
  8015f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8015f5:	c9                   	leave  
  8015f6:	c3                   	ret    

008015f7 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8015f7:	55                   	push   %ebp
  8015f8:	89 e5                	mov    %esp,%ebp
  8015fa:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8015fd:	e8 8e 10 00 00       	call   802690 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  801602:	8d 45 0c             	lea    0xc(%ebp),%eax
  801605:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  801608:	8b 45 08             	mov    0x8(%ebp),%eax
  80160b:	83 ec 08             	sub    $0x8,%esp
  80160e:	ff 75 f4             	pushl  -0xc(%ebp)
  801611:	50                   	push   %eax
  801612:	e8 ff fe ff ff       	call   801516 <vcprintf>
  801617:	83 c4 10             	add    $0x10,%esp
  80161a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80161d:	e8 88 10 00 00       	call   8026aa <sys_unlock_cons>
	return cnt;
  801622:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801625:	c9                   	leave  
  801626:	c3                   	ret    

00801627 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801627:	55                   	push   %ebp
  801628:	89 e5                	mov    %esp,%ebp
  80162a:	53                   	push   %ebx
  80162b:	83 ec 14             	sub    $0x14,%esp
  80162e:	8b 45 10             	mov    0x10(%ebp),%eax
  801631:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801634:	8b 45 14             	mov    0x14(%ebp),%eax
  801637:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80163a:	8b 45 18             	mov    0x18(%ebp),%eax
  80163d:	ba 00 00 00 00       	mov    $0x0,%edx
  801642:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801645:	77 55                	ja     80169c <printnum+0x75>
  801647:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80164a:	72 05                	jb     801651 <printnum+0x2a>
  80164c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80164f:	77 4b                	ja     80169c <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801651:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801654:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801657:	8b 45 18             	mov    0x18(%ebp),%eax
  80165a:	ba 00 00 00 00       	mov    $0x0,%edx
  80165f:	52                   	push   %edx
  801660:	50                   	push   %eax
  801661:	ff 75 f4             	pushl  -0xc(%ebp)
  801664:	ff 75 f0             	pushl  -0x10(%ebp)
  801667:	e8 a8 16 00 00       	call   802d14 <__udivdi3>
  80166c:	83 c4 10             	add    $0x10,%esp
  80166f:	83 ec 04             	sub    $0x4,%esp
  801672:	ff 75 20             	pushl  0x20(%ebp)
  801675:	53                   	push   %ebx
  801676:	ff 75 18             	pushl  0x18(%ebp)
  801679:	52                   	push   %edx
  80167a:	50                   	push   %eax
  80167b:	ff 75 0c             	pushl  0xc(%ebp)
  80167e:	ff 75 08             	pushl  0x8(%ebp)
  801681:	e8 a1 ff ff ff       	call   801627 <printnum>
  801686:	83 c4 20             	add    $0x20,%esp
  801689:	eb 1a                	jmp    8016a5 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80168b:	83 ec 08             	sub    $0x8,%esp
  80168e:	ff 75 0c             	pushl  0xc(%ebp)
  801691:	ff 75 20             	pushl  0x20(%ebp)
  801694:	8b 45 08             	mov    0x8(%ebp),%eax
  801697:	ff d0                	call   *%eax
  801699:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80169c:	ff 4d 1c             	decl   0x1c(%ebp)
  80169f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8016a3:	7f e6                	jg     80168b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8016a5:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8016a8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016b3:	53                   	push   %ebx
  8016b4:	51                   	push   %ecx
  8016b5:	52                   	push   %edx
  8016b6:	50                   	push   %eax
  8016b7:	e8 68 17 00 00       	call   802e24 <__umoddi3>
  8016bc:	83 c4 10             	add    $0x10,%esp
  8016bf:	05 34 41 80 00       	add    $0x804134,%eax
  8016c4:	8a 00                	mov    (%eax),%al
  8016c6:	0f be c0             	movsbl %al,%eax
  8016c9:	83 ec 08             	sub    $0x8,%esp
  8016cc:	ff 75 0c             	pushl  0xc(%ebp)
  8016cf:	50                   	push   %eax
  8016d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d3:	ff d0                	call   *%eax
  8016d5:	83 c4 10             	add    $0x10,%esp
}
  8016d8:	90                   	nop
  8016d9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016dc:	c9                   	leave  
  8016dd:	c3                   	ret    

008016de <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8016de:	55                   	push   %ebp
  8016df:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8016e1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8016e5:	7e 1c                	jle    801703 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8016e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ea:	8b 00                	mov    (%eax),%eax
  8016ec:	8d 50 08             	lea    0x8(%eax),%edx
  8016ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f2:	89 10                	mov    %edx,(%eax)
  8016f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f7:	8b 00                	mov    (%eax),%eax
  8016f9:	83 e8 08             	sub    $0x8,%eax
  8016fc:	8b 50 04             	mov    0x4(%eax),%edx
  8016ff:	8b 00                	mov    (%eax),%eax
  801701:	eb 40                	jmp    801743 <getuint+0x65>
	else if (lflag)
  801703:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801707:	74 1e                	je     801727 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  801709:	8b 45 08             	mov    0x8(%ebp),%eax
  80170c:	8b 00                	mov    (%eax),%eax
  80170e:	8d 50 04             	lea    0x4(%eax),%edx
  801711:	8b 45 08             	mov    0x8(%ebp),%eax
  801714:	89 10                	mov    %edx,(%eax)
  801716:	8b 45 08             	mov    0x8(%ebp),%eax
  801719:	8b 00                	mov    (%eax),%eax
  80171b:	83 e8 04             	sub    $0x4,%eax
  80171e:	8b 00                	mov    (%eax),%eax
  801720:	ba 00 00 00 00       	mov    $0x0,%edx
  801725:	eb 1c                	jmp    801743 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801727:	8b 45 08             	mov    0x8(%ebp),%eax
  80172a:	8b 00                	mov    (%eax),%eax
  80172c:	8d 50 04             	lea    0x4(%eax),%edx
  80172f:	8b 45 08             	mov    0x8(%ebp),%eax
  801732:	89 10                	mov    %edx,(%eax)
  801734:	8b 45 08             	mov    0x8(%ebp),%eax
  801737:	8b 00                	mov    (%eax),%eax
  801739:	83 e8 04             	sub    $0x4,%eax
  80173c:	8b 00                	mov    (%eax),%eax
  80173e:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801743:	5d                   	pop    %ebp
  801744:	c3                   	ret    

00801745 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801745:	55                   	push   %ebp
  801746:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801748:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80174c:	7e 1c                	jle    80176a <getint+0x25>
		return va_arg(*ap, long long);
  80174e:	8b 45 08             	mov    0x8(%ebp),%eax
  801751:	8b 00                	mov    (%eax),%eax
  801753:	8d 50 08             	lea    0x8(%eax),%edx
  801756:	8b 45 08             	mov    0x8(%ebp),%eax
  801759:	89 10                	mov    %edx,(%eax)
  80175b:	8b 45 08             	mov    0x8(%ebp),%eax
  80175e:	8b 00                	mov    (%eax),%eax
  801760:	83 e8 08             	sub    $0x8,%eax
  801763:	8b 50 04             	mov    0x4(%eax),%edx
  801766:	8b 00                	mov    (%eax),%eax
  801768:	eb 38                	jmp    8017a2 <getint+0x5d>
	else if (lflag)
  80176a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80176e:	74 1a                	je     80178a <getint+0x45>
		return va_arg(*ap, long);
  801770:	8b 45 08             	mov    0x8(%ebp),%eax
  801773:	8b 00                	mov    (%eax),%eax
  801775:	8d 50 04             	lea    0x4(%eax),%edx
  801778:	8b 45 08             	mov    0x8(%ebp),%eax
  80177b:	89 10                	mov    %edx,(%eax)
  80177d:	8b 45 08             	mov    0x8(%ebp),%eax
  801780:	8b 00                	mov    (%eax),%eax
  801782:	83 e8 04             	sub    $0x4,%eax
  801785:	8b 00                	mov    (%eax),%eax
  801787:	99                   	cltd   
  801788:	eb 18                	jmp    8017a2 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80178a:	8b 45 08             	mov    0x8(%ebp),%eax
  80178d:	8b 00                	mov    (%eax),%eax
  80178f:	8d 50 04             	lea    0x4(%eax),%edx
  801792:	8b 45 08             	mov    0x8(%ebp),%eax
  801795:	89 10                	mov    %edx,(%eax)
  801797:	8b 45 08             	mov    0x8(%ebp),%eax
  80179a:	8b 00                	mov    (%eax),%eax
  80179c:	83 e8 04             	sub    $0x4,%eax
  80179f:	8b 00                	mov    (%eax),%eax
  8017a1:	99                   	cltd   
}
  8017a2:	5d                   	pop    %ebp
  8017a3:	c3                   	ret    

008017a4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8017a4:	55                   	push   %ebp
  8017a5:	89 e5                	mov    %esp,%ebp
  8017a7:	56                   	push   %esi
  8017a8:	53                   	push   %ebx
  8017a9:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8017ac:	eb 17                	jmp    8017c5 <vprintfmt+0x21>
			if (ch == '\0')
  8017ae:	85 db                	test   %ebx,%ebx
  8017b0:	0f 84 c1 03 00 00    	je     801b77 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8017b6:	83 ec 08             	sub    $0x8,%esp
  8017b9:	ff 75 0c             	pushl  0xc(%ebp)
  8017bc:	53                   	push   %ebx
  8017bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c0:	ff d0                	call   *%eax
  8017c2:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8017c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8017c8:	8d 50 01             	lea    0x1(%eax),%edx
  8017cb:	89 55 10             	mov    %edx,0x10(%ebp)
  8017ce:	8a 00                	mov    (%eax),%al
  8017d0:	0f b6 d8             	movzbl %al,%ebx
  8017d3:	83 fb 25             	cmp    $0x25,%ebx
  8017d6:	75 d6                	jne    8017ae <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8017d8:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8017dc:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8017e3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8017ea:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8017f1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8017f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8017fb:	8d 50 01             	lea    0x1(%eax),%edx
  8017fe:	89 55 10             	mov    %edx,0x10(%ebp)
  801801:	8a 00                	mov    (%eax),%al
  801803:	0f b6 d8             	movzbl %al,%ebx
  801806:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801809:	83 f8 5b             	cmp    $0x5b,%eax
  80180c:	0f 87 3d 03 00 00    	ja     801b4f <vprintfmt+0x3ab>
  801812:	8b 04 85 58 41 80 00 	mov    0x804158(,%eax,4),%eax
  801819:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80181b:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80181f:	eb d7                	jmp    8017f8 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801821:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801825:	eb d1                	jmp    8017f8 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801827:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80182e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801831:	89 d0                	mov    %edx,%eax
  801833:	c1 e0 02             	shl    $0x2,%eax
  801836:	01 d0                	add    %edx,%eax
  801838:	01 c0                	add    %eax,%eax
  80183a:	01 d8                	add    %ebx,%eax
  80183c:	83 e8 30             	sub    $0x30,%eax
  80183f:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801842:	8b 45 10             	mov    0x10(%ebp),%eax
  801845:	8a 00                	mov    (%eax),%al
  801847:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80184a:	83 fb 2f             	cmp    $0x2f,%ebx
  80184d:	7e 3e                	jle    80188d <vprintfmt+0xe9>
  80184f:	83 fb 39             	cmp    $0x39,%ebx
  801852:	7f 39                	jg     80188d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801854:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801857:	eb d5                	jmp    80182e <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801859:	8b 45 14             	mov    0x14(%ebp),%eax
  80185c:	83 c0 04             	add    $0x4,%eax
  80185f:	89 45 14             	mov    %eax,0x14(%ebp)
  801862:	8b 45 14             	mov    0x14(%ebp),%eax
  801865:	83 e8 04             	sub    $0x4,%eax
  801868:	8b 00                	mov    (%eax),%eax
  80186a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80186d:	eb 1f                	jmp    80188e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80186f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801873:	79 83                	jns    8017f8 <vprintfmt+0x54>
				width = 0;
  801875:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80187c:	e9 77 ff ff ff       	jmp    8017f8 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801881:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801888:	e9 6b ff ff ff       	jmp    8017f8 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80188d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80188e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801892:	0f 89 60 ff ff ff    	jns    8017f8 <vprintfmt+0x54>
				width = precision, precision = -1;
  801898:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80189b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80189e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8018a5:	e9 4e ff ff ff       	jmp    8017f8 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8018aa:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8018ad:	e9 46 ff ff ff       	jmp    8017f8 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8018b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8018b5:	83 c0 04             	add    $0x4,%eax
  8018b8:	89 45 14             	mov    %eax,0x14(%ebp)
  8018bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8018be:	83 e8 04             	sub    $0x4,%eax
  8018c1:	8b 00                	mov    (%eax),%eax
  8018c3:	83 ec 08             	sub    $0x8,%esp
  8018c6:	ff 75 0c             	pushl  0xc(%ebp)
  8018c9:	50                   	push   %eax
  8018ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cd:	ff d0                	call   *%eax
  8018cf:	83 c4 10             	add    $0x10,%esp
			break;
  8018d2:	e9 9b 02 00 00       	jmp    801b72 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8018d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8018da:	83 c0 04             	add    $0x4,%eax
  8018dd:	89 45 14             	mov    %eax,0x14(%ebp)
  8018e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8018e3:	83 e8 04             	sub    $0x4,%eax
  8018e6:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8018e8:	85 db                	test   %ebx,%ebx
  8018ea:	79 02                	jns    8018ee <vprintfmt+0x14a>
				err = -err;
  8018ec:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8018ee:	83 fb 64             	cmp    $0x64,%ebx
  8018f1:	7f 0b                	jg     8018fe <vprintfmt+0x15a>
  8018f3:	8b 34 9d a0 3f 80 00 	mov    0x803fa0(,%ebx,4),%esi
  8018fa:	85 f6                	test   %esi,%esi
  8018fc:	75 19                	jne    801917 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8018fe:	53                   	push   %ebx
  8018ff:	68 45 41 80 00       	push   $0x804145
  801904:	ff 75 0c             	pushl  0xc(%ebp)
  801907:	ff 75 08             	pushl  0x8(%ebp)
  80190a:	e8 70 02 00 00       	call   801b7f <printfmt>
  80190f:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801912:	e9 5b 02 00 00       	jmp    801b72 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801917:	56                   	push   %esi
  801918:	68 4e 41 80 00       	push   $0x80414e
  80191d:	ff 75 0c             	pushl  0xc(%ebp)
  801920:	ff 75 08             	pushl  0x8(%ebp)
  801923:	e8 57 02 00 00       	call   801b7f <printfmt>
  801928:	83 c4 10             	add    $0x10,%esp
			break;
  80192b:	e9 42 02 00 00       	jmp    801b72 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801930:	8b 45 14             	mov    0x14(%ebp),%eax
  801933:	83 c0 04             	add    $0x4,%eax
  801936:	89 45 14             	mov    %eax,0x14(%ebp)
  801939:	8b 45 14             	mov    0x14(%ebp),%eax
  80193c:	83 e8 04             	sub    $0x4,%eax
  80193f:	8b 30                	mov    (%eax),%esi
  801941:	85 f6                	test   %esi,%esi
  801943:	75 05                	jne    80194a <vprintfmt+0x1a6>
				p = "(null)";
  801945:	be 51 41 80 00       	mov    $0x804151,%esi
			if (width > 0 && padc != '-')
  80194a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80194e:	7e 6d                	jle    8019bd <vprintfmt+0x219>
  801950:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801954:	74 67                	je     8019bd <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801956:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801959:	83 ec 08             	sub    $0x8,%esp
  80195c:	50                   	push   %eax
  80195d:	56                   	push   %esi
  80195e:	e8 1e 03 00 00       	call   801c81 <strnlen>
  801963:	83 c4 10             	add    $0x10,%esp
  801966:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801969:	eb 16                	jmp    801981 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80196b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80196f:	83 ec 08             	sub    $0x8,%esp
  801972:	ff 75 0c             	pushl  0xc(%ebp)
  801975:	50                   	push   %eax
  801976:	8b 45 08             	mov    0x8(%ebp),%eax
  801979:	ff d0                	call   *%eax
  80197b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80197e:	ff 4d e4             	decl   -0x1c(%ebp)
  801981:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801985:	7f e4                	jg     80196b <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801987:	eb 34                	jmp    8019bd <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801989:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80198d:	74 1c                	je     8019ab <vprintfmt+0x207>
  80198f:	83 fb 1f             	cmp    $0x1f,%ebx
  801992:	7e 05                	jle    801999 <vprintfmt+0x1f5>
  801994:	83 fb 7e             	cmp    $0x7e,%ebx
  801997:	7e 12                	jle    8019ab <vprintfmt+0x207>
					putch('?', putdat);
  801999:	83 ec 08             	sub    $0x8,%esp
  80199c:	ff 75 0c             	pushl  0xc(%ebp)
  80199f:	6a 3f                	push   $0x3f
  8019a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a4:	ff d0                	call   *%eax
  8019a6:	83 c4 10             	add    $0x10,%esp
  8019a9:	eb 0f                	jmp    8019ba <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8019ab:	83 ec 08             	sub    $0x8,%esp
  8019ae:	ff 75 0c             	pushl  0xc(%ebp)
  8019b1:	53                   	push   %ebx
  8019b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b5:	ff d0                	call   *%eax
  8019b7:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8019ba:	ff 4d e4             	decl   -0x1c(%ebp)
  8019bd:	89 f0                	mov    %esi,%eax
  8019bf:	8d 70 01             	lea    0x1(%eax),%esi
  8019c2:	8a 00                	mov    (%eax),%al
  8019c4:	0f be d8             	movsbl %al,%ebx
  8019c7:	85 db                	test   %ebx,%ebx
  8019c9:	74 24                	je     8019ef <vprintfmt+0x24b>
  8019cb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8019cf:	78 b8                	js     801989 <vprintfmt+0x1e5>
  8019d1:	ff 4d e0             	decl   -0x20(%ebp)
  8019d4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8019d8:	79 af                	jns    801989 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8019da:	eb 13                	jmp    8019ef <vprintfmt+0x24b>
				putch(' ', putdat);
  8019dc:	83 ec 08             	sub    $0x8,%esp
  8019df:	ff 75 0c             	pushl  0xc(%ebp)
  8019e2:	6a 20                	push   $0x20
  8019e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e7:	ff d0                	call   *%eax
  8019e9:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8019ec:	ff 4d e4             	decl   -0x1c(%ebp)
  8019ef:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8019f3:	7f e7                	jg     8019dc <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8019f5:	e9 78 01 00 00       	jmp    801b72 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8019fa:	83 ec 08             	sub    $0x8,%esp
  8019fd:	ff 75 e8             	pushl  -0x18(%ebp)
  801a00:	8d 45 14             	lea    0x14(%ebp),%eax
  801a03:	50                   	push   %eax
  801a04:	e8 3c fd ff ff       	call   801745 <getint>
  801a09:	83 c4 10             	add    $0x10,%esp
  801a0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801a0f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801a12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a15:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a18:	85 d2                	test   %edx,%edx
  801a1a:	79 23                	jns    801a3f <vprintfmt+0x29b>
				putch('-', putdat);
  801a1c:	83 ec 08             	sub    $0x8,%esp
  801a1f:	ff 75 0c             	pushl  0xc(%ebp)
  801a22:	6a 2d                	push   $0x2d
  801a24:	8b 45 08             	mov    0x8(%ebp),%eax
  801a27:	ff d0                	call   *%eax
  801a29:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801a2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a2f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a32:	f7 d8                	neg    %eax
  801a34:	83 d2 00             	adc    $0x0,%edx
  801a37:	f7 da                	neg    %edx
  801a39:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801a3c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801a3f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801a46:	e9 bc 00 00 00       	jmp    801b07 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801a4b:	83 ec 08             	sub    $0x8,%esp
  801a4e:	ff 75 e8             	pushl  -0x18(%ebp)
  801a51:	8d 45 14             	lea    0x14(%ebp),%eax
  801a54:	50                   	push   %eax
  801a55:	e8 84 fc ff ff       	call   8016de <getuint>
  801a5a:	83 c4 10             	add    $0x10,%esp
  801a5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801a60:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801a63:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801a6a:	e9 98 00 00 00       	jmp    801b07 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801a6f:	83 ec 08             	sub    $0x8,%esp
  801a72:	ff 75 0c             	pushl  0xc(%ebp)
  801a75:	6a 58                	push   $0x58
  801a77:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7a:	ff d0                	call   *%eax
  801a7c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801a7f:	83 ec 08             	sub    $0x8,%esp
  801a82:	ff 75 0c             	pushl  0xc(%ebp)
  801a85:	6a 58                	push   $0x58
  801a87:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8a:	ff d0                	call   *%eax
  801a8c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801a8f:	83 ec 08             	sub    $0x8,%esp
  801a92:	ff 75 0c             	pushl  0xc(%ebp)
  801a95:	6a 58                	push   $0x58
  801a97:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9a:	ff d0                	call   *%eax
  801a9c:	83 c4 10             	add    $0x10,%esp
			break;
  801a9f:	e9 ce 00 00 00       	jmp    801b72 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  801aa4:	83 ec 08             	sub    $0x8,%esp
  801aa7:	ff 75 0c             	pushl  0xc(%ebp)
  801aaa:	6a 30                	push   $0x30
  801aac:	8b 45 08             	mov    0x8(%ebp),%eax
  801aaf:	ff d0                	call   *%eax
  801ab1:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801ab4:	83 ec 08             	sub    $0x8,%esp
  801ab7:	ff 75 0c             	pushl  0xc(%ebp)
  801aba:	6a 78                	push   $0x78
  801abc:	8b 45 08             	mov    0x8(%ebp),%eax
  801abf:	ff d0                	call   *%eax
  801ac1:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801ac4:	8b 45 14             	mov    0x14(%ebp),%eax
  801ac7:	83 c0 04             	add    $0x4,%eax
  801aca:	89 45 14             	mov    %eax,0x14(%ebp)
  801acd:	8b 45 14             	mov    0x14(%ebp),%eax
  801ad0:	83 e8 04             	sub    $0x4,%eax
  801ad3:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801ad5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801ad8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801adf:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801ae6:	eb 1f                	jmp    801b07 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801ae8:	83 ec 08             	sub    $0x8,%esp
  801aeb:	ff 75 e8             	pushl  -0x18(%ebp)
  801aee:	8d 45 14             	lea    0x14(%ebp),%eax
  801af1:	50                   	push   %eax
  801af2:	e8 e7 fb ff ff       	call   8016de <getuint>
  801af7:	83 c4 10             	add    $0x10,%esp
  801afa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801afd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801b00:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801b07:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801b0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b0e:	83 ec 04             	sub    $0x4,%esp
  801b11:	52                   	push   %edx
  801b12:	ff 75 e4             	pushl  -0x1c(%ebp)
  801b15:	50                   	push   %eax
  801b16:	ff 75 f4             	pushl  -0xc(%ebp)
  801b19:	ff 75 f0             	pushl  -0x10(%ebp)
  801b1c:	ff 75 0c             	pushl  0xc(%ebp)
  801b1f:	ff 75 08             	pushl  0x8(%ebp)
  801b22:	e8 00 fb ff ff       	call   801627 <printnum>
  801b27:	83 c4 20             	add    $0x20,%esp
			break;
  801b2a:	eb 46                	jmp    801b72 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801b2c:	83 ec 08             	sub    $0x8,%esp
  801b2f:	ff 75 0c             	pushl  0xc(%ebp)
  801b32:	53                   	push   %ebx
  801b33:	8b 45 08             	mov    0x8(%ebp),%eax
  801b36:	ff d0                	call   *%eax
  801b38:	83 c4 10             	add    $0x10,%esp
			break;
  801b3b:	eb 35                	jmp    801b72 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  801b3d:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
			break;
  801b44:	eb 2c                	jmp    801b72 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  801b46:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
			break;
  801b4d:	eb 23                	jmp    801b72 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801b4f:	83 ec 08             	sub    $0x8,%esp
  801b52:	ff 75 0c             	pushl  0xc(%ebp)
  801b55:	6a 25                	push   $0x25
  801b57:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5a:	ff d0                	call   *%eax
  801b5c:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801b5f:	ff 4d 10             	decl   0x10(%ebp)
  801b62:	eb 03                	jmp    801b67 <vprintfmt+0x3c3>
  801b64:	ff 4d 10             	decl   0x10(%ebp)
  801b67:	8b 45 10             	mov    0x10(%ebp),%eax
  801b6a:	48                   	dec    %eax
  801b6b:	8a 00                	mov    (%eax),%al
  801b6d:	3c 25                	cmp    $0x25,%al
  801b6f:	75 f3                	jne    801b64 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  801b71:	90                   	nop
		}
	}
  801b72:	e9 35 fc ff ff       	jmp    8017ac <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801b77:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801b78:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b7b:	5b                   	pop    %ebx
  801b7c:	5e                   	pop    %esi
  801b7d:	5d                   	pop    %ebp
  801b7e:	c3                   	ret    

00801b7f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801b7f:	55                   	push   %ebp
  801b80:	89 e5                	mov    %esp,%ebp
  801b82:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801b85:	8d 45 10             	lea    0x10(%ebp),%eax
  801b88:	83 c0 04             	add    $0x4,%eax
  801b8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801b8e:	8b 45 10             	mov    0x10(%ebp),%eax
  801b91:	ff 75 f4             	pushl  -0xc(%ebp)
  801b94:	50                   	push   %eax
  801b95:	ff 75 0c             	pushl  0xc(%ebp)
  801b98:	ff 75 08             	pushl  0x8(%ebp)
  801b9b:	e8 04 fc ff ff       	call   8017a4 <vprintfmt>
  801ba0:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801ba3:	90                   	nop
  801ba4:	c9                   	leave  
  801ba5:	c3                   	ret    

00801ba6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801ba6:	55                   	push   %ebp
  801ba7:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801ba9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bac:	8b 40 08             	mov    0x8(%eax),%eax
  801baf:	8d 50 01             	lea    0x1(%eax),%edx
  801bb2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bb5:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801bb8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bbb:	8b 10                	mov    (%eax),%edx
  801bbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bc0:	8b 40 04             	mov    0x4(%eax),%eax
  801bc3:	39 c2                	cmp    %eax,%edx
  801bc5:	73 12                	jae    801bd9 <sprintputch+0x33>
		*b->buf++ = ch;
  801bc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bca:	8b 00                	mov    (%eax),%eax
  801bcc:	8d 48 01             	lea    0x1(%eax),%ecx
  801bcf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bd2:	89 0a                	mov    %ecx,(%edx)
  801bd4:	8b 55 08             	mov    0x8(%ebp),%edx
  801bd7:	88 10                	mov    %dl,(%eax)
}
  801bd9:	90                   	nop
  801bda:	5d                   	pop    %ebp
  801bdb:	c3                   	ret    

00801bdc <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801bdc:	55                   	push   %ebp
  801bdd:	89 e5                	mov    %esp,%ebp
  801bdf:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801be2:	8b 45 08             	mov    0x8(%ebp),%eax
  801be5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801be8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801beb:	8d 50 ff             	lea    -0x1(%eax),%edx
  801bee:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf1:	01 d0                	add    %edx,%eax
  801bf3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801bf6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801bfd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801c01:	74 06                	je     801c09 <vsnprintf+0x2d>
  801c03:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801c07:	7f 07                	jg     801c10 <vsnprintf+0x34>
		return -E_INVAL;
  801c09:	b8 03 00 00 00       	mov    $0x3,%eax
  801c0e:	eb 20                	jmp    801c30 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801c10:	ff 75 14             	pushl  0x14(%ebp)
  801c13:	ff 75 10             	pushl  0x10(%ebp)
  801c16:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801c19:	50                   	push   %eax
  801c1a:	68 a6 1b 80 00       	push   $0x801ba6
  801c1f:	e8 80 fb ff ff       	call   8017a4 <vprintfmt>
  801c24:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801c27:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c2a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801c2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801c30:	c9                   	leave  
  801c31:	c3                   	ret    

00801c32 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801c32:	55                   	push   %ebp
  801c33:	89 e5                	mov    %esp,%ebp
  801c35:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801c38:	8d 45 10             	lea    0x10(%ebp),%eax
  801c3b:	83 c0 04             	add    $0x4,%eax
  801c3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801c41:	8b 45 10             	mov    0x10(%ebp),%eax
  801c44:	ff 75 f4             	pushl  -0xc(%ebp)
  801c47:	50                   	push   %eax
  801c48:	ff 75 0c             	pushl  0xc(%ebp)
  801c4b:	ff 75 08             	pushl  0x8(%ebp)
  801c4e:	e8 89 ff ff ff       	call   801bdc <vsnprintf>
  801c53:	83 c4 10             	add    $0x10,%esp
  801c56:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801c59:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801c5c:	c9                   	leave  
  801c5d:	c3                   	ret    

00801c5e <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801c5e:	55                   	push   %ebp
  801c5f:	89 e5                	mov    %esp,%ebp
  801c61:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801c64:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801c6b:	eb 06                	jmp    801c73 <strlen+0x15>
		n++;
  801c6d:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801c70:	ff 45 08             	incl   0x8(%ebp)
  801c73:	8b 45 08             	mov    0x8(%ebp),%eax
  801c76:	8a 00                	mov    (%eax),%al
  801c78:	84 c0                	test   %al,%al
  801c7a:	75 f1                	jne    801c6d <strlen+0xf>
		n++;
	return n;
  801c7c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801c7f:	c9                   	leave  
  801c80:	c3                   	ret    

00801c81 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801c81:	55                   	push   %ebp
  801c82:	89 e5                	mov    %esp,%ebp
  801c84:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801c87:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801c8e:	eb 09                	jmp    801c99 <strnlen+0x18>
		n++;
  801c90:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801c93:	ff 45 08             	incl   0x8(%ebp)
  801c96:	ff 4d 0c             	decl   0xc(%ebp)
  801c99:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801c9d:	74 09                	je     801ca8 <strnlen+0x27>
  801c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca2:	8a 00                	mov    (%eax),%al
  801ca4:	84 c0                	test   %al,%al
  801ca6:	75 e8                	jne    801c90 <strnlen+0xf>
		n++;
	return n;
  801ca8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801cab:	c9                   	leave  
  801cac:	c3                   	ret    

00801cad <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801cad:	55                   	push   %ebp
  801cae:	89 e5                	mov    %esp,%ebp
  801cb0:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801cb9:	90                   	nop
  801cba:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbd:	8d 50 01             	lea    0x1(%eax),%edx
  801cc0:	89 55 08             	mov    %edx,0x8(%ebp)
  801cc3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cc6:	8d 4a 01             	lea    0x1(%edx),%ecx
  801cc9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801ccc:	8a 12                	mov    (%edx),%dl
  801cce:	88 10                	mov    %dl,(%eax)
  801cd0:	8a 00                	mov    (%eax),%al
  801cd2:	84 c0                	test   %al,%al
  801cd4:	75 e4                	jne    801cba <strcpy+0xd>
		/* do nothing */;
	return ret;
  801cd6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801cd9:	c9                   	leave  
  801cda:	c3                   	ret    

00801cdb <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801cdb:	55                   	push   %ebp
  801cdc:	89 e5                	mov    %esp,%ebp
  801cde:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801ce1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801ce7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801cee:	eb 1f                	jmp    801d0f <strncpy+0x34>
		*dst++ = *src;
  801cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf3:	8d 50 01             	lea    0x1(%eax),%edx
  801cf6:	89 55 08             	mov    %edx,0x8(%ebp)
  801cf9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cfc:	8a 12                	mov    (%edx),%dl
  801cfe:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801d00:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d03:	8a 00                	mov    (%eax),%al
  801d05:	84 c0                	test   %al,%al
  801d07:	74 03                	je     801d0c <strncpy+0x31>
			src++;
  801d09:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801d0c:	ff 45 fc             	incl   -0x4(%ebp)
  801d0f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d12:	3b 45 10             	cmp    0x10(%ebp),%eax
  801d15:	72 d9                	jb     801cf0 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801d17:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801d1a:	c9                   	leave  
  801d1b:	c3                   	ret    

00801d1c <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801d1c:	55                   	push   %ebp
  801d1d:	89 e5                	mov    %esp,%ebp
  801d1f:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801d22:	8b 45 08             	mov    0x8(%ebp),%eax
  801d25:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801d28:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801d2c:	74 30                	je     801d5e <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801d2e:	eb 16                	jmp    801d46 <strlcpy+0x2a>
			*dst++ = *src++;
  801d30:	8b 45 08             	mov    0x8(%ebp),%eax
  801d33:	8d 50 01             	lea    0x1(%eax),%edx
  801d36:	89 55 08             	mov    %edx,0x8(%ebp)
  801d39:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d3c:	8d 4a 01             	lea    0x1(%edx),%ecx
  801d3f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801d42:	8a 12                	mov    (%edx),%dl
  801d44:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801d46:	ff 4d 10             	decl   0x10(%ebp)
  801d49:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801d4d:	74 09                	je     801d58 <strlcpy+0x3c>
  801d4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d52:	8a 00                	mov    (%eax),%al
  801d54:	84 c0                	test   %al,%al
  801d56:	75 d8                	jne    801d30 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801d58:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801d5e:	8b 55 08             	mov    0x8(%ebp),%edx
  801d61:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d64:	29 c2                	sub    %eax,%edx
  801d66:	89 d0                	mov    %edx,%eax
}
  801d68:	c9                   	leave  
  801d69:	c3                   	ret    

00801d6a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801d6a:	55                   	push   %ebp
  801d6b:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801d6d:	eb 06                	jmp    801d75 <strcmp+0xb>
		p++, q++;
  801d6f:	ff 45 08             	incl   0x8(%ebp)
  801d72:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801d75:	8b 45 08             	mov    0x8(%ebp),%eax
  801d78:	8a 00                	mov    (%eax),%al
  801d7a:	84 c0                	test   %al,%al
  801d7c:	74 0e                	je     801d8c <strcmp+0x22>
  801d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d81:	8a 10                	mov    (%eax),%dl
  801d83:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d86:	8a 00                	mov    (%eax),%al
  801d88:	38 c2                	cmp    %al,%dl
  801d8a:	74 e3                	je     801d6f <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8f:	8a 00                	mov    (%eax),%al
  801d91:	0f b6 d0             	movzbl %al,%edx
  801d94:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d97:	8a 00                	mov    (%eax),%al
  801d99:	0f b6 c0             	movzbl %al,%eax
  801d9c:	29 c2                	sub    %eax,%edx
  801d9e:	89 d0                	mov    %edx,%eax
}
  801da0:	5d                   	pop    %ebp
  801da1:	c3                   	ret    

00801da2 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801da2:	55                   	push   %ebp
  801da3:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801da5:	eb 09                	jmp    801db0 <strncmp+0xe>
		n--, p++, q++;
  801da7:	ff 4d 10             	decl   0x10(%ebp)
  801daa:	ff 45 08             	incl   0x8(%ebp)
  801dad:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801db0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801db4:	74 17                	je     801dcd <strncmp+0x2b>
  801db6:	8b 45 08             	mov    0x8(%ebp),%eax
  801db9:	8a 00                	mov    (%eax),%al
  801dbb:	84 c0                	test   %al,%al
  801dbd:	74 0e                	je     801dcd <strncmp+0x2b>
  801dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc2:	8a 10                	mov    (%eax),%dl
  801dc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dc7:	8a 00                	mov    (%eax),%al
  801dc9:	38 c2                	cmp    %al,%dl
  801dcb:	74 da                	je     801da7 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801dcd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801dd1:	75 07                	jne    801dda <strncmp+0x38>
		return 0;
  801dd3:	b8 00 00 00 00       	mov    $0x0,%eax
  801dd8:	eb 14                	jmp    801dee <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801dda:	8b 45 08             	mov    0x8(%ebp),%eax
  801ddd:	8a 00                	mov    (%eax),%al
  801ddf:	0f b6 d0             	movzbl %al,%edx
  801de2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801de5:	8a 00                	mov    (%eax),%al
  801de7:	0f b6 c0             	movzbl %al,%eax
  801dea:	29 c2                	sub    %eax,%edx
  801dec:	89 d0                	mov    %edx,%eax
}
  801dee:	5d                   	pop    %ebp
  801def:	c3                   	ret    

00801df0 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801df0:	55                   	push   %ebp
  801df1:	89 e5                	mov    %esp,%ebp
  801df3:	83 ec 04             	sub    $0x4,%esp
  801df6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801df9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801dfc:	eb 12                	jmp    801e10 <strchr+0x20>
		if (*s == c)
  801dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  801e01:	8a 00                	mov    (%eax),%al
  801e03:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801e06:	75 05                	jne    801e0d <strchr+0x1d>
			return (char *) s;
  801e08:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0b:	eb 11                	jmp    801e1e <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801e0d:	ff 45 08             	incl   0x8(%ebp)
  801e10:	8b 45 08             	mov    0x8(%ebp),%eax
  801e13:	8a 00                	mov    (%eax),%al
  801e15:	84 c0                	test   %al,%al
  801e17:	75 e5                	jne    801dfe <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801e19:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e1e:	c9                   	leave  
  801e1f:	c3                   	ret    

00801e20 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801e20:	55                   	push   %ebp
  801e21:	89 e5                	mov    %esp,%ebp
  801e23:	83 ec 04             	sub    $0x4,%esp
  801e26:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e29:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801e2c:	eb 0d                	jmp    801e3b <strfind+0x1b>
		if (*s == c)
  801e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e31:	8a 00                	mov    (%eax),%al
  801e33:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801e36:	74 0e                	je     801e46 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801e38:	ff 45 08             	incl   0x8(%ebp)
  801e3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3e:	8a 00                	mov    (%eax),%al
  801e40:	84 c0                	test   %al,%al
  801e42:	75 ea                	jne    801e2e <strfind+0xe>
  801e44:	eb 01                	jmp    801e47 <strfind+0x27>
		if (*s == c)
			break;
  801e46:	90                   	nop
	return (char *) s;
  801e47:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801e4a:	c9                   	leave  
  801e4b:	c3                   	ret    

00801e4c <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801e4c:	55                   	push   %ebp
  801e4d:	89 e5                	mov    %esp,%ebp
  801e4f:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801e52:	8b 45 08             	mov    0x8(%ebp),%eax
  801e55:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801e58:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801e5c:	76 63                	jbe    801ec1 <memset+0x75>
		uint64 data_block = c;
  801e5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e61:	99                   	cltd   
  801e62:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e65:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801e68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e6b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e6e:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801e72:	c1 e0 08             	shl    $0x8,%eax
  801e75:	09 45 f0             	or     %eax,-0x10(%ebp)
  801e78:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801e7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e7e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e81:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801e85:	c1 e0 10             	shl    $0x10,%eax
  801e88:	09 45 f0             	or     %eax,-0x10(%ebp)
  801e8b:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801e8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e91:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e94:	89 c2                	mov    %eax,%edx
  801e96:	b8 00 00 00 00       	mov    $0x0,%eax
  801e9b:	09 45 f0             	or     %eax,-0x10(%ebp)
  801e9e:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801ea1:	eb 18                	jmp    801ebb <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801ea3:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801ea6:	8d 41 08             	lea    0x8(%ecx),%eax
  801ea9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801eac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eaf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801eb2:	89 01                	mov    %eax,(%ecx)
  801eb4:	89 51 04             	mov    %edx,0x4(%ecx)
  801eb7:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801ebb:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801ebf:	77 e2                	ja     801ea3 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801ec1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ec5:	74 23                	je     801eea <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801ec7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801eca:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801ecd:	eb 0e                	jmp    801edd <memset+0x91>
			*p8++ = (uint8)c;
  801ecf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ed2:	8d 50 01             	lea    0x1(%eax),%edx
  801ed5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801ed8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801edb:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801edd:	8b 45 10             	mov    0x10(%ebp),%eax
  801ee0:	8d 50 ff             	lea    -0x1(%eax),%edx
  801ee3:	89 55 10             	mov    %edx,0x10(%ebp)
  801ee6:	85 c0                	test   %eax,%eax
  801ee8:	75 e5                	jne    801ecf <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801eea:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801eed:	c9                   	leave  
  801eee:	c3                   	ret    

00801eef <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801eef:	55                   	push   %ebp
  801ef0:	89 e5                	mov    %esp,%ebp
  801ef2:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801ef5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ef8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801efb:	8b 45 08             	mov    0x8(%ebp),%eax
  801efe:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801f01:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801f05:	76 24                	jbe    801f2b <memcpy+0x3c>
		while(n >= 8){
  801f07:	eb 1c                	jmp    801f25 <memcpy+0x36>
			*d64 = *s64;
  801f09:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f0c:	8b 50 04             	mov    0x4(%eax),%edx
  801f0f:	8b 00                	mov    (%eax),%eax
  801f11:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801f14:	89 01                	mov    %eax,(%ecx)
  801f16:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801f19:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801f1d:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801f21:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801f25:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801f29:	77 de                	ja     801f09 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801f2b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f2f:	74 31                	je     801f62 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801f31:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f34:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801f37:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f3a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801f3d:	eb 16                	jmp    801f55 <memcpy+0x66>
			*d8++ = *s8++;
  801f3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f42:	8d 50 01             	lea    0x1(%eax),%edx
  801f45:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801f48:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f4b:	8d 4a 01             	lea    0x1(%edx),%ecx
  801f4e:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801f51:	8a 12                	mov    (%edx),%dl
  801f53:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801f55:	8b 45 10             	mov    0x10(%ebp),%eax
  801f58:	8d 50 ff             	lea    -0x1(%eax),%edx
  801f5b:	89 55 10             	mov    %edx,0x10(%ebp)
  801f5e:	85 c0                	test   %eax,%eax
  801f60:	75 dd                	jne    801f3f <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801f62:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801f65:	c9                   	leave  
  801f66:	c3                   	ret    

00801f67 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801f67:	55                   	push   %ebp
  801f68:	89 e5                	mov    %esp,%ebp
  801f6a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801f6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f70:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801f73:	8b 45 08             	mov    0x8(%ebp),%eax
  801f76:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801f79:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f7c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801f7f:	73 50                	jae    801fd1 <memmove+0x6a>
  801f81:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f84:	8b 45 10             	mov    0x10(%ebp),%eax
  801f87:	01 d0                	add    %edx,%eax
  801f89:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801f8c:	76 43                	jbe    801fd1 <memmove+0x6a>
		s += n;
  801f8e:	8b 45 10             	mov    0x10(%ebp),%eax
  801f91:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801f94:	8b 45 10             	mov    0x10(%ebp),%eax
  801f97:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801f9a:	eb 10                	jmp    801fac <memmove+0x45>
			*--d = *--s;
  801f9c:	ff 4d f8             	decl   -0x8(%ebp)
  801f9f:	ff 4d fc             	decl   -0x4(%ebp)
  801fa2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fa5:	8a 10                	mov    (%eax),%dl
  801fa7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801faa:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801fac:	8b 45 10             	mov    0x10(%ebp),%eax
  801faf:	8d 50 ff             	lea    -0x1(%eax),%edx
  801fb2:	89 55 10             	mov    %edx,0x10(%ebp)
  801fb5:	85 c0                	test   %eax,%eax
  801fb7:	75 e3                	jne    801f9c <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801fb9:	eb 23                	jmp    801fde <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801fbb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801fbe:	8d 50 01             	lea    0x1(%eax),%edx
  801fc1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801fc4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801fc7:	8d 4a 01             	lea    0x1(%edx),%ecx
  801fca:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801fcd:	8a 12                	mov    (%edx),%dl
  801fcf:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801fd1:	8b 45 10             	mov    0x10(%ebp),%eax
  801fd4:	8d 50 ff             	lea    -0x1(%eax),%edx
  801fd7:	89 55 10             	mov    %edx,0x10(%ebp)
  801fda:	85 c0                	test   %eax,%eax
  801fdc:	75 dd                	jne    801fbb <memmove+0x54>
			*d++ = *s++;

	return dst;
  801fde:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801fe1:	c9                   	leave  
  801fe2:	c3                   	ret    

00801fe3 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801fe3:	55                   	push   %ebp
  801fe4:	89 e5                	mov    %esp,%ebp
  801fe6:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fec:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801fef:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ff2:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801ff5:	eb 2a                	jmp    802021 <memcmp+0x3e>
		if (*s1 != *s2)
  801ff7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ffa:	8a 10                	mov    (%eax),%dl
  801ffc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801fff:	8a 00                	mov    (%eax),%al
  802001:	38 c2                	cmp    %al,%dl
  802003:	74 16                	je     80201b <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  802005:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802008:	8a 00                	mov    (%eax),%al
  80200a:	0f b6 d0             	movzbl %al,%edx
  80200d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802010:	8a 00                	mov    (%eax),%al
  802012:	0f b6 c0             	movzbl %al,%eax
  802015:	29 c2                	sub    %eax,%edx
  802017:	89 d0                	mov    %edx,%eax
  802019:	eb 18                	jmp    802033 <memcmp+0x50>
		s1++, s2++;
  80201b:	ff 45 fc             	incl   -0x4(%ebp)
  80201e:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  802021:	8b 45 10             	mov    0x10(%ebp),%eax
  802024:	8d 50 ff             	lea    -0x1(%eax),%edx
  802027:	89 55 10             	mov    %edx,0x10(%ebp)
  80202a:	85 c0                	test   %eax,%eax
  80202c:	75 c9                	jne    801ff7 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80202e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802033:	c9                   	leave  
  802034:	c3                   	ret    

00802035 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  802035:	55                   	push   %ebp
  802036:	89 e5                	mov    %esp,%ebp
  802038:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80203b:	8b 55 08             	mov    0x8(%ebp),%edx
  80203e:	8b 45 10             	mov    0x10(%ebp),%eax
  802041:	01 d0                	add    %edx,%eax
  802043:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  802046:	eb 15                	jmp    80205d <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  802048:	8b 45 08             	mov    0x8(%ebp),%eax
  80204b:	8a 00                	mov    (%eax),%al
  80204d:	0f b6 d0             	movzbl %al,%edx
  802050:	8b 45 0c             	mov    0xc(%ebp),%eax
  802053:	0f b6 c0             	movzbl %al,%eax
  802056:	39 c2                	cmp    %eax,%edx
  802058:	74 0d                	je     802067 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80205a:	ff 45 08             	incl   0x8(%ebp)
  80205d:	8b 45 08             	mov    0x8(%ebp),%eax
  802060:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  802063:	72 e3                	jb     802048 <memfind+0x13>
  802065:	eb 01                	jmp    802068 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  802067:	90                   	nop
	return (void *) s;
  802068:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80206b:	c9                   	leave  
  80206c:	c3                   	ret    

0080206d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80206d:	55                   	push   %ebp
  80206e:	89 e5                	mov    %esp,%ebp
  802070:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  802073:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80207a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802081:	eb 03                	jmp    802086 <strtol+0x19>
		s++;
  802083:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802086:	8b 45 08             	mov    0x8(%ebp),%eax
  802089:	8a 00                	mov    (%eax),%al
  80208b:	3c 20                	cmp    $0x20,%al
  80208d:	74 f4                	je     802083 <strtol+0x16>
  80208f:	8b 45 08             	mov    0x8(%ebp),%eax
  802092:	8a 00                	mov    (%eax),%al
  802094:	3c 09                	cmp    $0x9,%al
  802096:	74 eb                	je     802083 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  802098:	8b 45 08             	mov    0x8(%ebp),%eax
  80209b:	8a 00                	mov    (%eax),%al
  80209d:	3c 2b                	cmp    $0x2b,%al
  80209f:	75 05                	jne    8020a6 <strtol+0x39>
		s++;
  8020a1:	ff 45 08             	incl   0x8(%ebp)
  8020a4:	eb 13                	jmp    8020b9 <strtol+0x4c>
	else if (*s == '-')
  8020a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a9:	8a 00                	mov    (%eax),%al
  8020ab:	3c 2d                	cmp    $0x2d,%al
  8020ad:	75 0a                	jne    8020b9 <strtol+0x4c>
		s++, neg = 1;
  8020af:	ff 45 08             	incl   0x8(%ebp)
  8020b2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8020b9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8020bd:	74 06                	je     8020c5 <strtol+0x58>
  8020bf:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8020c3:	75 20                	jne    8020e5 <strtol+0x78>
  8020c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c8:	8a 00                	mov    (%eax),%al
  8020ca:	3c 30                	cmp    $0x30,%al
  8020cc:	75 17                	jne    8020e5 <strtol+0x78>
  8020ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d1:	40                   	inc    %eax
  8020d2:	8a 00                	mov    (%eax),%al
  8020d4:	3c 78                	cmp    $0x78,%al
  8020d6:	75 0d                	jne    8020e5 <strtol+0x78>
		s += 2, base = 16;
  8020d8:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8020dc:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8020e3:	eb 28                	jmp    80210d <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8020e5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8020e9:	75 15                	jne    802100 <strtol+0x93>
  8020eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ee:	8a 00                	mov    (%eax),%al
  8020f0:	3c 30                	cmp    $0x30,%al
  8020f2:	75 0c                	jne    802100 <strtol+0x93>
		s++, base = 8;
  8020f4:	ff 45 08             	incl   0x8(%ebp)
  8020f7:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8020fe:	eb 0d                	jmp    80210d <strtol+0xa0>
	else if (base == 0)
  802100:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802104:	75 07                	jne    80210d <strtol+0xa0>
		base = 10;
  802106:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80210d:	8b 45 08             	mov    0x8(%ebp),%eax
  802110:	8a 00                	mov    (%eax),%al
  802112:	3c 2f                	cmp    $0x2f,%al
  802114:	7e 19                	jle    80212f <strtol+0xc2>
  802116:	8b 45 08             	mov    0x8(%ebp),%eax
  802119:	8a 00                	mov    (%eax),%al
  80211b:	3c 39                	cmp    $0x39,%al
  80211d:	7f 10                	jg     80212f <strtol+0xc2>
			dig = *s - '0';
  80211f:	8b 45 08             	mov    0x8(%ebp),%eax
  802122:	8a 00                	mov    (%eax),%al
  802124:	0f be c0             	movsbl %al,%eax
  802127:	83 e8 30             	sub    $0x30,%eax
  80212a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80212d:	eb 42                	jmp    802171 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80212f:	8b 45 08             	mov    0x8(%ebp),%eax
  802132:	8a 00                	mov    (%eax),%al
  802134:	3c 60                	cmp    $0x60,%al
  802136:	7e 19                	jle    802151 <strtol+0xe4>
  802138:	8b 45 08             	mov    0x8(%ebp),%eax
  80213b:	8a 00                	mov    (%eax),%al
  80213d:	3c 7a                	cmp    $0x7a,%al
  80213f:	7f 10                	jg     802151 <strtol+0xe4>
			dig = *s - 'a' + 10;
  802141:	8b 45 08             	mov    0x8(%ebp),%eax
  802144:	8a 00                	mov    (%eax),%al
  802146:	0f be c0             	movsbl %al,%eax
  802149:	83 e8 57             	sub    $0x57,%eax
  80214c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80214f:	eb 20                	jmp    802171 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  802151:	8b 45 08             	mov    0x8(%ebp),%eax
  802154:	8a 00                	mov    (%eax),%al
  802156:	3c 40                	cmp    $0x40,%al
  802158:	7e 39                	jle    802193 <strtol+0x126>
  80215a:	8b 45 08             	mov    0x8(%ebp),%eax
  80215d:	8a 00                	mov    (%eax),%al
  80215f:	3c 5a                	cmp    $0x5a,%al
  802161:	7f 30                	jg     802193 <strtol+0x126>
			dig = *s - 'A' + 10;
  802163:	8b 45 08             	mov    0x8(%ebp),%eax
  802166:	8a 00                	mov    (%eax),%al
  802168:	0f be c0             	movsbl %al,%eax
  80216b:	83 e8 37             	sub    $0x37,%eax
  80216e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  802171:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802174:	3b 45 10             	cmp    0x10(%ebp),%eax
  802177:	7d 19                	jge    802192 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  802179:	ff 45 08             	incl   0x8(%ebp)
  80217c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80217f:	0f af 45 10          	imul   0x10(%ebp),%eax
  802183:	89 c2                	mov    %eax,%edx
  802185:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802188:	01 d0                	add    %edx,%eax
  80218a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80218d:	e9 7b ff ff ff       	jmp    80210d <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  802192:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  802193:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802197:	74 08                	je     8021a1 <strtol+0x134>
		*endptr = (char *) s;
  802199:	8b 45 0c             	mov    0xc(%ebp),%eax
  80219c:	8b 55 08             	mov    0x8(%ebp),%edx
  80219f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8021a1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021a5:	74 07                	je     8021ae <strtol+0x141>
  8021a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021aa:	f7 d8                	neg    %eax
  8021ac:	eb 03                	jmp    8021b1 <strtol+0x144>
  8021ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8021b1:	c9                   	leave  
  8021b2:	c3                   	ret    

008021b3 <ltostr>:

void
ltostr(long value, char *str)
{
  8021b3:	55                   	push   %ebp
  8021b4:	89 e5                	mov    %esp,%ebp
  8021b6:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8021b9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8021c0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8021c7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021cb:	79 13                	jns    8021e0 <ltostr+0x2d>
	{
		neg = 1;
  8021cd:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8021d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021d7:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8021da:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8021dd:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8021e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e3:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8021e8:	99                   	cltd   
  8021e9:	f7 f9                	idiv   %ecx
  8021eb:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8021ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021f1:	8d 50 01             	lea    0x1(%eax),%edx
  8021f4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8021f7:	89 c2                	mov    %eax,%edx
  8021f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021fc:	01 d0                	add    %edx,%eax
  8021fe:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802201:	83 c2 30             	add    $0x30,%edx
  802204:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  802206:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802209:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80220e:	f7 e9                	imul   %ecx
  802210:	c1 fa 02             	sar    $0x2,%edx
  802213:	89 c8                	mov    %ecx,%eax
  802215:	c1 f8 1f             	sar    $0x1f,%eax
  802218:	29 c2                	sub    %eax,%edx
  80221a:	89 d0                	mov    %edx,%eax
  80221c:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80221f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802223:	75 bb                	jne    8021e0 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  802225:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80222c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80222f:	48                   	dec    %eax
  802230:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  802233:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802237:	74 3d                	je     802276 <ltostr+0xc3>
		start = 1 ;
  802239:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  802240:	eb 34                	jmp    802276 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  802242:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802245:	8b 45 0c             	mov    0xc(%ebp),%eax
  802248:	01 d0                	add    %edx,%eax
  80224a:	8a 00                	mov    (%eax),%al
  80224c:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80224f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802252:	8b 45 0c             	mov    0xc(%ebp),%eax
  802255:	01 c2                	add    %eax,%edx
  802257:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80225a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80225d:	01 c8                	add    %ecx,%eax
  80225f:	8a 00                	mov    (%eax),%al
  802261:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  802263:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802266:	8b 45 0c             	mov    0xc(%ebp),%eax
  802269:	01 c2                	add    %eax,%edx
  80226b:	8a 45 eb             	mov    -0x15(%ebp),%al
  80226e:	88 02                	mov    %al,(%edx)
		start++ ;
  802270:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  802273:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  802276:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802279:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80227c:	7c c4                	jl     802242 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80227e:	8b 55 f8             	mov    -0x8(%ebp),%edx
  802281:	8b 45 0c             	mov    0xc(%ebp),%eax
  802284:	01 d0                	add    %edx,%eax
  802286:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  802289:	90                   	nop
  80228a:	c9                   	leave  
  80228b:	c3                   	ret    

0080228c <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80228c:	55                   	push   %ebp
  80228d:	89 e5                	mov    %esp,%ebp
  80228f:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  802292:	ff 75 08             	pushl  0x8(%ebp)
  802295:	e8 c4 f9 ff ff       	call   801c5e <strlen>
  80229a:	83 c4 04             	add    $0x4,%esp
  80229d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8022a0:	ff 75 0c             	pushl  0xc(%ebp)
  8022a3:	e8 b6 f9 ff ff       	call   801c5e <strlen>
  8022a8:	83 c4 04             	add    $0x4,%esp
  8022ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8022ae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8022b5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8022bc:	eb 17                	jmp    8022d5 <strcconcat+0x49>
		final[s] = str1[s] ;
  8022be:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8022c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8022c4:	01 c2                	add    %eax,%edx
  8022c6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8022c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cc:	01 c8                	add    %ecx,%eax
  8022ce:	8a 00                	mov    (%eax),%al
  8022d0:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8022d2:	ff 45 fc             	incl   -0x4(%ebp)
  8022d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022d8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8022db:	7c e1                	jl     8022be <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8022dd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8022e4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8022eb:	eb 1f                	jmp    80230c <strcconcat+0x80>
		final[s++] = str2[i] ;
  8022ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022f0:	8d 50 01             	lea    0x1(%eax),%edx
  8022f3:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8022f6:	89 c2                	mov    %eax,%edx
  8022f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8022fb:	01 c2                	add    %eax,%edx
  8022fd:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  802300:	8b 45 0c             	mov    0xc(%ebp),%eax
  802303:	01 c8                	add    %ecx,%eax
  802305:	8a 00                	mov    (%eax),%al
  802307:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  802309:	ff 45 f8             	incl   -0x8(%ebp)
  80230c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80230f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802312:	7c d9                	jl     8022ed <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  802314:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802317:	8b 45 10             	mov    0x10(%ebp),%eax
  80231a:	01 d0                	add    %edx,%eax
  80231c:	c6 00 00             	movb   $0x0,(%eax)
}
  80231f:	90                   	nop
  802320:	c9                   	leave  
  802321:	c3                   	ret    

00802322 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  802322:	55                   	push   %ebp
  802323:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  802325:	8b 45 14             	mov    0x14(%ebp),%eax
  802328:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80232e:	8b 45 14             	mov    0x14(%ebp),%eax
  802331:	8b 00                	mov    (%eax),%eax
  802333:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80233a:	8b 45 10             	mov    0x10(%ebp),%eax
  80233d:	01 d0                	add    %edx,%eax
  80233f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802345:	eb 0c                	jmp    802353 <strsplit+0x31>
			*string++ = 0;
  802347:	8b 45 08             	mov    0x8(%ebp),%eax
  80234a:	8d 50 01             	lea    0x1(%eax),%edx
  80234d:	89 55 08             	mov    %edx,0x8(%ebp)
  802350:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802353:	8b 45 08             	mov    0x8(%ebp),%eax
  802356:	8a 00                	mov    (%eax),%al
  802358:	84 c0                	test   %al,%al
  80235a:	74 18                	je     802374 <strsplit+0x52>
  80235c:	8b 45 08             	mov    0x8(%ebp),%eax
  80235f:	8a 00                	mov    (%eax),%al
  802361:	0f be c0             	movsbl %al,%eax
  802364:	50                   	push   %eax
  802365:	ff 75 0c             	pushl  0xc(%ebp)
  802368:	e8 83 fa ff ff       	call   801df0 <strchr>
  80236d:	83 c4 08             	add    $0x8,%esp
  802370:	85 c0                	test   %eax,%eax
  802372:	75 d3                	jne    802347 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  802374:	8b 45 08             	mov    0x8(%ebp),%eax
  802377:	8a 00                	mov    (%eax),%al
  802379:	84 c0                	test   %al,%al
  80237b:	74 5a                	je     8023d7 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80237d:	8b 45 14             	mov    0x14(%ebp),%eax
  802380:	8b 00                	mov    (%eax),%eax
  802382:	83 f8 0f             	cmp    $0xf,%eax
  802385:	75 07                	jne    80238e <strsplit+0x6c>
		{
			return 0;
  802387:	b8 00 00 00 00       	mov    $0x0,%eax
  80238c:	eb 66                	jmp    8023f4 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80238e:	8b 45 14             	mov    0x14(%ebp),%eax
  802391:	8b 00                	mov    (%eax),%eax
  802393:	8d 48 01             	lea    0x1(%eax),%ecx
  802396:	8b 55 14             	mov    0x14(%ebp),%edx
  802399:	89 0a                	mov    %ecx,(%edx)
  80239b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8023a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8023a5:	01 c2                	add    %eax,%edx
  8023a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023aa:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8023ac:	eb 03                	jmp    8023b1 <strsplit+0x8f>
			string++;
  8023ae:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8023b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b4:	8a 00                	mov    (%eax),%al
  8023b6:	84 c0                	test   %al,%al
  8023b8:	74 8b                	je     802345 <strsplit+0x23>
  8023ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bd:	8a 00                	mov    (%eax),%al
  8023bf:	0f be c0             	movsbl %al,%eax
  8023c2:	50                   	push   %eax
  8023c3:	ff 75 0c             	pushl  0xc(%ebp)
  8023c6:	e8 25 fa ff ff       	call   801df0 <strchr>
  8023cb:	83 c4 08             	add    $0x8,%esp
  8023ce:	85 c0                	test   %eax,%eax
  8023d0:	74 dc                	je     8023ae <strsplit+0x8c>
			string++;
	}
  8023d2:	e9 6e ff ff ff       	jmp    802345 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8023d7:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8023d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8023db:	8b 00                	mov    (%eax),%eax
  8023dd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8023e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8023e7:	01 d0                	add    %edx,%eax
  8023e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8023ef:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8023f4:	c9                   	leave  
  8023f5:	c3                   	ret    

008023f6 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8023f6:	55                   	push   %ebp
  8023f7:	89 e5                	mov    %esp,%ebp
  8023f9:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8023fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ff:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  802402:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802409:	eb 4a                	jmp    802455 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  80240b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80240e:	8b 45 08             	mov    0x8(%ebp),%eax
  802411:	01 c2                	add    %eax,%edx
  802413:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802416:	8b 45 0c             	mov    0xc(%ebp),%eax
  802419:	01 c8                	add    %ecx,%eax
  80241b:	8a 00                	mov    (%eax),%al
  80241d:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  80241f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802422:	8b 45 0c             	mov    0xc(%ebp),%eax
  802425:	01 d0                	add    %edx,%eax
  802427:	8a 00                	mov    (%eax),%al
  802429:	3c 40                	cmp    $0x40,%al
  80242b:	7e 25                	jle    802452 <str2lower+0x5c>
  80242d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802430:	8b 45 0c             	mov    0xc(%ebp),%eax
  802433:	01 d0                	add    %edx,%eax
  802435:	8a 00                	mov    (%eax),%al
  802437:	3c 5a                	cmp    $0x5a,%al
  802439:	7f 17                	jg     802452 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  80243b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80243e:	8b 45 08             	mov    0x8(%ebp),%eax
  802441:	01 d0                	add    %edx,%eax
  802443:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802446:	8b 55 08             	mov    0x8(%ebp),%edx
  802449:	01 ca                	add    %ecx,%edx
  80244b:	8a 12                	mov    (%edx),%dl
  80244d:	83 c2 20             	add    $0x20,%edx
  802450:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  802452:	ff 45 fc             	incl   -0x4(%ebp)
  802455:	ff 75 0c             	pushl  0xc(%ebp)
  802458:	e8 01 f8 ff ff       	call   801c5e <strlen>
  80245d:	83 c4 04             	add    $0x4,%esp
  802460:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  802463:	7f a6                	jg     80240b <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  802465:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  802468:	c9                   	leave  
  802469:	c3                   	ret    

0080246a <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  80246a:	55                   	push   %ebp
  80246b:	89 e5                	mov    %esp,%ebp
  80246d:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  802470:	a1 08 50 80 00       	mov    0x805008,%eax
  802475:	85 c0                	test   %eax,%eax
  802477:	74 42                	je     8024bb <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  802479:	83 ec 08             	sub    $0x8,%esp
  80247c:	68 00 00 00 82       	push   $0x82000000
  802481:	68 00 00 00 80       	push   $0x80000000
  802486:	e8 8c 07 00 00       	call   802c17 <initialize_dynamic_allocator>
  80248b:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  80248e:	e8 e7 05 00 00       	call   802a7a <sys_get_uheap_strategy>
  802493:	a3 60 d0 81 00       	mov    %eax,0x81d060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  802498:	a1 40 50 80 00       	mov    0x805040,%eax
  80249d:	05 00 10 00 00       	add    $0x1000,%eax
  8024a2:	a3 10 d1 81 00       	mov    %eax,0x81d110
		uheapPageAllocBreak = uheapPageAllocStart;
  8024a7:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8024ac:	a3 68 d0 81 00       	mov    %eax,0x81d068

		__firstTimeFlag = 0;
  8024b1:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  8024b8:	00 00 00 
	}
}
  8024bb:	90                   	nop
  8024bc:	c9                   	leave  
  8024bd:	c3                   	ret    

008024be <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  8024be:	55                   	push   %ebp
  8024bf:	89 e5                	mov    %esp,%ebp
  8024c1:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  8024c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8024d2:	83 ec 08             	sub    $0x8,%esp
  8024d5:	68 06 04 00 00       	push   $0x406
  8024da:	50                   	push   %eax
  8024db:	e8 e4 01 00 00       	call   8026c4 <__sys_allocate_page>
  8024e0:	83 c4 10             	add    $0x10,%esp
  8024e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8024e6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024ea:	79 14                	jns    802500 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  8024ec:	83 ec 04             	sub    $0x4,%esp
  8024ef:	68 c8 42 80 00       	push   $0x8042c8
  8024f4:	6a 1f                	push   $0x1f
  8024f6:	68 04 43 80 00       	push   $0x804304
  8024fb:	e8 b7 ed ff ff       	call   8012b7 <_panic>
	return 0;
  802500:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802505:	c9                   	leave  
  802506:	c3                   	ret    

00802507 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  802507:	55                   	push   %ebp
  802508:	89 e5                	mov    %esp,%ebp
  80250a:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  80250d:	8b 45 08             	mov    0x8(%ebp),%eax
  802510:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802513:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802516:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80251b:	83 ec 0c             	sub    $0xc,%esp
  80251e:	50                   	push   %eax
  80251f:	e8 e7 01 00 00       	call   80270b <__sys_unmap_frame>
  802524:	83 c4 10             	add    $0x10,%esp
  802527:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  80252a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80252e:	79 14                	jns    802544 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  802530:	83 ec 04             	sub    $0x4,%esp
  802533:	68 10 43 80 00       	push   $0x804310
  802538:	6a 2a                	push   $0x2a
  80253a:	68 04 43 80 00       	push   $0x804304
  80253f:	e8 73 ed ff ff       	call   8012b7 <_panic>
}
  802544:	90                   	nop
  802545:	c9                   	leave  
  802546:	c3                   	ret    

00802547 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  802547:	55                   	push   %ebp
  802548:	89 e5                	mov    %esp,%ebp
  80254a:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80254d:	e8 18 ff ff ff       	call   80246a <uheap_init>
	if (size == 0) return NULL ;
  802552:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802556:	75 07                	jne    80255f <malloc+0x18>
  802558:	b8 00 00 00 00       	mov    $0x0,%eax
  80255d:	eb 14                	jmp    802573 <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  80255f:	83 ec 04             	sub    $0x4,%esp
  802562:	68 50 43 80 00       	push   $0x804350
  802567:	6a 3e                	push   $0x3e
  802569:	68 04 43 80 00       	push   $0x804304
  80256e:	e8 44 ed ff ff       	call   8012b7 <_panic>
}
  802573:	c9                   	leave  
  802574:	c3                   	ret    

00802575 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  802575:	55                   	push   %ebp
  802576:	89 e5                	mov    %esp,%ebp
  802578:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  80257b:	83 ec 04             	sub    $0x4,%esp
  80257e:	68 78 43 80 00       	push   $0x804378
  802583:	6a 49                	push   $0x49
  802585:	68 04 43 80 00       	push   $0x804304
  80258a:	e8 28 ed ff ff       	call   8012b7 <_panic>

0080258f <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80258f:	55                   	push   %ebp
  802590:	89 e5                	mov    %esp,%ebp
  802592:	83 ec 18             	sub    $0x18,%esp
  802595:	8b 45 10             	mov    0x10(%ebp),%eax
  802598:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80259b:	e8 ca fe ff ff       	call   80246a <uheap_init>
	if (size == 0) return NULL ;
  8025a0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8025a4:	75 07                	jne    8025ad <smalloc+0x1e>
  8025a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8025ab:	eb 14                	jmp    8025c1 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  8025ad:	83 ec 04             	sub    $0x4,%esp
  8025b0:	68 9c 43 80 00       	push   $0x80439c
  8025b5:	6a 5a                	push   $0x5a
  8025b7:	68 04 43 80 00       	push   $0x804304
  8025bc:	e8 f6 ec ff ff       	call   8012b7 <_panic>
}
  8025c1:	c9                   	leave  
  8025c2:	c3                   	ret    

008025c3 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8025c3:	55                   	push   %ebp
  8025c4:	89 e5                	mov    %esp,%ebp
  8025c6:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8025c9:	e8 9c fe ff ff       	call   80246a <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  8025ce:	83 ec 04             	sub    $0x4,%esp
  8025d1:	68 c4 43 80 00       	push   $0x8043c4
  8025d6:	6a 6a                	push   $0x6a
  8025d8:	68 04 43 80 00       	push   $0x804304
  8025dd:	e8 d5 ec ff ff       	call   8012b7 <_panic>

008025e2 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8025e2:	55                   	push   %ebp
  8025e3:	89 e5                	mov    %esp,%ebp
  8025e5:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8025e8:	e8 7d fe ff ff       	call   80246a <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  8025ed:	83 ec 04             	sub    $0x4,%esp
  8025f0:	68 e8 43 80 00       	push   $0x8043e8
  8025f5:	68 88 00 00 00       	push   $0x88
  8025fa:	68 04 43 80 00       	push   $0x804304
  8025ff:	e8 b3 ec ff ff       	call   8012b7 <_panic>

00802604 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  802604:	55                   	push   %ebp
  802605:	89 e5                	mov    %esp,%ebp
  802607:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  80260a:	83 ec 04             	sub    $0x4,%esp
  80260d:	68 10 44 80 00       	push   $0x804410
  802612:	68 9b 00 00 00       	push   $0x9b
  802617:	68 04 43 80 00       	push   $0x804304
  80261c:	e8 96 ec ff ff       	call   8012b7 <_panic>

00802621 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802621:	55                   	push   %ebp
  802622:	89 e5                	mov    %esp,%ebp
  802624:	57                   	push   %edi
  802625:	56                   	push   %esi
  802626:	53                   	push   %ebx
  802627:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80262a:	8b 45 08             	mov    0x8(%ebp),%eax
  80262d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802630:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802633:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802636:	8b 7d 18             	mov    0x18(%ebp),%edi
  802639:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80263c:	cd 30                	int    $0x30
  80263e:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  802641:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802644:	83 c4 10             	add    $0x10,%esp
  802647:	5b                   	pop    %ebx
  802648:	5e                   	pop    %esi
  802649:	5f                   	pop    %edi
  80264a:	5d                   	pop    %ebp
  80264b:	c3                   	ret    

0080264c <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  80264c:	55                   	push   %ebp
  80264d:	89 e5                	mov    %esp,%ebp
  80264f:	83 ec 04             	sub    $0x4,%esp
  802652:	8b 45 10             	mov    0x10(%ebp),%eax
  802655:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  802658:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80265b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80265f:	8b 45 08             	mov    0x8(%ebp),%eax
  802662:	6a 00                	push   $0x0
  802664:	51                   	push   %ecx
  802665:	52                   	push   %edx
  802666:	ff 75 0c             	pushl  0xc(%ebp)
  802669:	50                   	push   %eax
  80266a:	6a 00                	push   $0x0
  80266c:	e8 b0 ff ff ff       	call   802621 <syscall>
  802671:	83 c4 18             	add    $0x18,%esp
}
  802674:	90                   	nop
  802675:	c9                   	leave  
  802676:	c3                   	ret    

00802677 <sys_cgetc>:

int
sys_cgetc(void)
{
  802677:	55                   	push   %ebp
  802678:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80267a:	6a 00                	push   $0x0
  80267c:	6a 00                	push   $0x0
  80267e:	6a 00                	push   $0x0
  802680:	6a 00                	push   $0x0
  802682:	6a 00                	push   $0x0
  802684:	6a 02                	push   $0x2
  802686:	e8 96 ff ff ff       	call   802621 <syscall>
  80268b:	83 c4 18             	add    $0x18,%esp
}
  80268e:	c9                   	leave  
  80268f:	c3                   	ret    

00802690 <sys_lock_cons>:

void sys_lock_cons(void)
{
  802690:	55                   	push   %ebp
  802691:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802693:	6a 00                	push   $0x0
  802695:	6a 00                	push   $0x0
  802697:	6a 00                	push   $0x0
  802699:	6a 00                	push   $0x0
  80269b:	6a 00                	push   $0x0
  80269d:	6a 03                	push   $0x3
  80269f:	e8 7d ff ff ff       	call   802621 <syscall>
  8026a4:	83 c4 18             	add    $0x18,%esp
}
  8026a7:	90                   	nop
  8026a8:	c9                   	leave  
  8026a9:	c3                   	ret    

008026aa <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8026aa:	55                   	push   %ebp
  8026ab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8026ad:	6a 00                	push   $0x0
  8026af:	6a 00                	push   $0x0
  8026b1:	6a 00                	push   $0x0
  8026b3:	6a 00                	push   $0x0
  8026b5:	6a 00                	push   $0x0
  8026b7:	6a 04                	push   $0x4
  8026b9:	e8 63 ff ff ff       	call   802621 <syscall>
  8026be:	83 c4 18             	add    $0x18,%esp
}
  8026c1:	90                   	nop
  8026c2:	c9                   	leave  
  8026c3:	c3                   	ret    

008026c4 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8026c4:	55                   	push   %ebp
  8026c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8026c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8026cd:	6a 00                	push   $0x0
  8026cf:	6a 00                	push   $0x0
  8026d1:	6a 00                	push   $0x0
  8026d3:	52                   	push   %edx
  8026d4:	50                   	push   %eax
  8026d5:	6a 08                	push   $0x8
  8026d7:	e8 45 ff ff ff       	call   802621 <syscall>
  8026dc:	83 c4 18             	add    $0x18,%esp
}
  8026df:	c9                   	leave  
  8026e0:	c3                   	ret    

008026e1 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8026e1:	55                   	push   %ebp
  8026e2:	89 e5                	mov    %esp,%ebp
  8026e4:	56                   	push   %esi
  8026e5:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8026e6:	8b 75 18             	mov    0x18(%ebp),%esi
  8026e9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8026ec:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8026ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f5:	56                   	push   %esi
  8026f6:	53                   	push   %ebx
  8026f7:	51                   	push   %ecx
  8026f8:	52                   	push   %edx
  8026f9:	50                   	push   %eax
  8026fa:	6a 09                	push   $0x9
  8026fc:	e8 20 ff ff ff       	call   802621 <syscall>
  802701:	83 c4 18             	add    $0x18,%esp
}
  802704:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802707:	5b                   	pop    %ebx
  802708:	5e                   	pop    %esi
  802709:	5d                   	pop    %ebp
  80270a:	c3                   	ret    

0080270b <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  80270b:	55                   	push   %ebp
  80270c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  80270e:	6a 00                	push   $0x0
  802710:	6a 00                	push   $0x0
  802712:	6a 00                	push   $0x0
  802714:	6a 00                	push   $0x0
  802716:	ff 75 08             	pushl  0x8(%ebp)
  802719:	6a 0a                	push   $0xa
  80271b:	e8 01 ff ff ff       	call   802621 <syscall>
  802720:	83 c4 18             	add    $0x18,%esp
}
  802723:	c9                   	leave  
  802724:	c3                   	ret    

00802725 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802725:	55                   	push   %ebp
  802726:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802728:	6a 00                	push   $0x0
  80272a:	6a 00                	push   $0x0
  80272c:	6a 00                	push   $0x0
  80272e:	ff 75 0c             	pushl  0xc(%ebp)
  802731:	ff 75 08             	pushl  0x8(%ebp)
  802734:	6a 0b                	push   $0xb
  802736:	e8 e6 fe ff ff       	call   802621 <syscall>
  80273b:	83 c4 18             	add    $0x18,%esp
}
  80273e:	c9                   	leave  
  80273f:	c3                   	ret    

00802740 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802740:	55                   	push   %ebp
  802741:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802743:	6a 00                	push   $0x0
  802745:	6a 00                	push   $0x0
  802747:	6a 00                	push   $0x0
  802749:	6a 00                	push   $0x0
  80274b:	6a 00                	push   $0x0
  80274d:	6a 0c                	push   $0xc
  80274f:	e8 cd fe ff ff       	call   802621 <syscall>
  802754:	83 c4 18             	add    $0x18,%esp
}
  802757:	c9                   	leave  
  802758:	c3                   	ret    

00802759 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802759:	55                   	push   %ebp
  80275a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80275c:	6a 00                	push   $0x0
  80275e:	6a 00                	push   $0x0
  802760:	6a 00                	push   $0x0
  802762:	6a 00                	push   $0x0
  802764:	6a 00                	push   $0x0
  802766:	6a 0d                	push   $0xd
  802768:	e8 b4 fe ff ff       	call   802621 <syscall>
  80276d:	83 c4 18             	add    $0x18,%esp
}
  802770:	c9                   	leave  
  802771:	c3                   	ret    

00802772 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802772:	55                   	push   %ebp
  802773:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802775:	6a 00                	push   $0x0
  802777:	6a 00                	push   $0x0
  802779:	6a 00                	push   $0x0
  80277b:	6a 00                	push   $0x0
  80277d:	6a 00                	push   $0x0
  80277f:	6a 0e                	push   $0xe
  802781:	e8 9b fe ff ff       	call   802621 <syscall>
  802786:	83 c4 18             	add    $0x18,%esp
}
  802789:	c9                   	leave  
  80278a:	c3                   	ret    

0080278b <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80278b:	55                   	push   %ebp
  80278c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80278e:	6a 00                	push   $0x0
  802790:	6a 00                	push   $0x0
  802792:	6a 00                	push   $0x0
  802794:	6a 00                	push   $0x0
  802796:	6a 00                	push   $0x0
  802798:	6a 0f                	push   $0xf
  80279a:	e8 82 fe ff ff       	call   802621 <syscall>
  80279f:	83 c4 18             	add    $0x18,%esp
}
  8027a2:	c9                   	leave  
  8027a3:	c3                   	ret    

008027a4 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8027a4:	55                   	push   %ebp
  8027a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8027a7:	6a 00                	push   $0x0
  8027a9:	6a 00                	push   $0x0
  8027ab:	6a 00                	push   $0x0
  8027ad:	6a 00                	push   $0x0
  8027af:	ff 75 08             	pushl  0x8(%ebp)
  8027b2:	6a 10                	push   $0x10
  8027b4:	e8 68 fe ff ff       	call   802621 <syscall>
  8027b9:	83 c4 18             	add    $0x18,%esp
}
  8027bc:	c9                   	leave  
  8027bd:	c3                   	ret    

008027be <sys_scarce_memory>:

void sys_scarce_memory()
{
  8027be:	55                   	push   %ebp
  8027bf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8027c1:	6a 00                	push   $0x0
  8027c3:	6a 00                	push   $0x0
  8027c5:	6a 00                	push   $0x0
  8027c7:	6a 00                	push   $0x0
  8027c9:	6a 00                	push   $0x0
  8027cb:	6a 11                	push   $0x11
  8027cd:	e8 4f fe ff ff       	call   802621 <syscall>
  8027d2:	83 c4 18             	add    $0x18,%esp
}
  8027d5:	90                   	nop
  8027d6:	c9                   	leave  
  8027d7:	c3                   	ret    

008027d8 <sys_cputc>:

void
sys_cputc(const char c)
{
  8027d8:	55                   	push   %ebp
  8027d9:	89 e5                	mov    %esp,%ebp
  8027db:	83 ec 04             	sub    $0x4,%esp
  8027de:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8027e4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8027e8:	6a 00                	push   $0x0
  8027ea:	6a 00                	push   $0x0
  8027ec:	6a 00                	push   $0x0
  8027ee:	6a 00                	push   $0x0
  8027f0:	50                   	push   %eax
  8027f1:	6a 01                	push   $0x1
  8027f3:	e8 29 fe ff ff       	call   802621 <syscall>
  8027f8:	83 c4 18             	add    $0x18,%esp
}
  8027fb:	90                   	nop
  8027fc:	c9                   	leave  
  8027fd:	c3                   	ret    

008027fe <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8027fe:	55                   	push   %ebp
  8027ff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802801:	6a 00                	push   $0x0
  802803:	6a 00                	push   $0x0
  802805:	6a 00                	push   $0x0
  802807:	6a 00                	push   $0x0
  802809:	6a 00                	push   $0x0
  80280b:	6a 14                	push   $0x14
  80280d:	e8 0f fe ff ff       	call   802621 <syscall>
  802812:	83 c4 18             	add    $0x18,%esp
}
  802815:	90                   	nop
  802816:	c9                   	leave  
  802817:	c3                   	ret    

00802818 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802818:	55                   	push   %ebp
  802819:	89 e5                	mov    %esp,%ebp
  80281b:	83 ec 04             	sub    $0x4,%esp
  80281e:	8b 45 10             	mov    0x10(%ebp),%eax
  802821:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802824:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802827:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80282b:	8b 45 08             	mov    0x8(%ebp),%eax
  80282e:	6a 00                	push   $0x0
  802830:	51                   	push   %ecx
  802831:	52                   	push   %edx
  802832:	ff 75 0c             	pushl  0xc(%ebp)
  802835:	50                   	push   %eax
  802836:	6a 15                	push   $0x15
  802838:	e8 e4 fd ff ff       	call   802621 <syscall>
  80283d:	83 c4 18             	add    $0x18,%esp
}
  802840:	c9                   	leave  
  802841:	c3                   	ret    

00802842 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  802842:	55                   	push   %ebp
  802843:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802845:	8b 55 0c             	mov    0xc(%ebp),%edx
  802848:	8b 45 08             	mov    0x8(%ebp),%eax
  80284b:	6a 00                	push   $0x0
  80284d:	6a 00                	push   $0x0
  80284f:	6a 00                	push   $0x0
  802851:	52                   	push   %edx
  802852:	50                   	push   %eax
  802853:	6a 16                	push   $0x16
  802855:	e8 c7 fd ff ff       	call   802621 <syscall>
  80285a:	83 c4 18             	add    $0x18,%esp
}
  80285d:	c9                   	leave  
  80285e:	c3                   	ret    

0080285f <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  80285f:	55                   	push   %ebp
  802860:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802862:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802865:	8b 55 0c             	mov    0xc(%ebp),%edx
  802868:	8b 45 08             	mov    0x8(%ebp),%eax
  80286b:	6a 00                	push   $0x0
  80286d:	6a 00                	push   $0x0
  80286f:	51                   	push   %ecx
  802870:	52                   	push   %edx
  802871:	50                   	push   %eax
  802872:	6a 17                	push   $0x17
  802874:	e8 a8 fd ff ff       	call   802621 <syscall>
  802879:	83 c4 18             	add    $0x18,%esp
}
  80287c:	c9                   	leave  
  80287d:	c3                   	ret    

0080287e <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  80287e:	55                   	push   %ebp
  80287f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802881:	8b 55 0c             	mov    0xc(%ebp),%edx
  802884:	8b 45 08             	mov    0x8(%ebp),%eax
  802887:	6a 00                	push   $0x0
  802889:	6a 00                	push   $0x0
  80288b:	6a 00                	push   $0x0
  80288d:	52                   	push   %edx
  80288e:	50                   	push   %eax
  80288f:	6a 18                	push   $0x18
  802891:	e8 8b fd ff ff       	call   802621 <syscall>
  802896:	83 c4 18             	add    $0x18,%esp
}
  802899:	c9                   	leave  
  80289a:	c3                   	ret    

0080289b <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80289b:	55                   	push   %ebp
  80289c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80289e:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a1:	6a 00                	push   $0x0
  8028a3:	ff 75 14             	pushl  0x14(%ebp)
  8028a6:	ff 75 10             	pushl  0x10(%ebp)
  8028a9:	ff 75 0c             	pushl  0xc(%ebp)
  8028ac:	50                   	push   %eax
  8028ad:	6a 19                	push   $0x19
  8028af:	e8 6d fd ff ff       	call   802621 <syscall>
  8028b4:	83 c4 18             	add    $0x18,%esp
}
  8028b7:	c9                   	leave  
  8028b8:	c3                   	ret    

008028b9 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8028b9:	55                   	push   %ebp
  8028ba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8028bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8028bf:	6a 00                	push   $0x0
  8028c1:	6a 00                	push   $0x0
  8028c3:	6a 00                	push   $0x0
  8028c5:	6a 00                	push   $0x0
  8028c7:	50                   	push   %eax
  8028c8:	6a 1a                	push   $0x1a
  8028ca:	e8 52 fd ff ff       	call   802621 <syscall>
  8028cf:	83 c4 18             	add    $0x18,%esp
}
  8028d2:	90                   	nop
  8028d3:	c9                   	leave  
  8028d4:	c3                   	ret    

008028d5 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8028d5:	55                   	push   %ebp
  8028d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8028d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8028db:	6a 00                	push   $0x0
  8028dd:	6a 00                	push   $0x0
  8028df:	6a 00                	push   $0x0
  8028e1:	6a 00                	push   $0x0
  8028e3:	50                   	push   %eax
  8028e4:	6a 1b                	push   $0x1b
  8028e6:	e8 36 fd ff ff       	call   802621 <syscall>
  8028eb:	83 c4 18             	add    $0x18,%esp
}
  8028ee:	c9                   	leave  
  8028ef:	c3                   	ret    

008028f0 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8028f0:	55                   	push   %ebp
  8028f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8028f3:	6a 00                	push   $0x0
  8028f5:	6a 00                	push   $0x0
  8028f7:	6a 00                	push   $0x0
  8028f9:	6a 00                	push   $0x0
  8028fb:	6a 00                	push   $0x0
  8028fd:	6a 05                	push   $0x5
  8028ff:	e8 1d fd ff ff       	call   802621 <syscall>
  802904:	83 c4 18             	add    $0x18,%esp
}
  802907:	c9                   	leave  
  802908:	c3                   	ret    

00802909 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802909:	55                   	push   %ebp
  80290a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80290c:	6a 00                	push   $0x0
  80290e:	6a 00                	push   $0x0
  802910:	6a 00                	push   $0x0
  802912:	6a 00                	push   $0x0
  802914:	6a 00                	push   $0x0
  802916:	6a 06                	push   $0x6
  802918:	e8 04 fd ff ff       	call   802621 <syscall>
  80291d:	83 c4 18             	add    $0x18,%esp
}
  802920:	c9                   	leave  
  802921:	c3                   	ret    

00802922 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802922:	55                   	push   %ebp
  802923:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802925:	6a 00                	push   $0x0
  802927:	6a 00                	push   $0x0
  802929:	6a 00                	push   $0x0
  80292b:	6a 00                	push   $0x0
  80292d:	6a 00                	push   $0x0
  80292f:	6a 07                	push   $0x7
  802931:	e8 eb fc ff ff       	call   802621 <syscall>
  802936:	83 c4 18             	add    $0x18,%esp
}
  802939:	c9                   	leave  
  80293a:	c3                   	ret    

0080293b <sys_exit_env>:


void sys_exit_env(void)
{
  80293b:	55                   	push   %ebp
  80293c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80293e:	6a 00                	push   $0x0
  802940:	6a 00                	push   $0x0
  802942:	6a 00                	push   $0x0
  802944:	6a 00                	push   $0x0
  802946:	6a 00                	push   $0x0
  802948:	6a 1c                	push   $0x1c
  80294a:	e8 d2 fc ff ff       	call   802621 <syscall>
  80294f:	83 c4 18             	add    $0x18,%esp
}
  802952:	90                   	nop
  802953:	c9                   	leave  
  802954:	c3                   	ret    

00802955 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802955:	55                   	push   %ebp
  802956:	89 e5                	mov    %esp,%ebp
  802958:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80295b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80295e:	8d 50 04             	lea    0x4(%eax),%edx
  802961:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802964:	6a 00                	push   $0x0
  802966:	6a 00                	push   $0x0
  802968:	6a 00                	push   $0x0
  80296a:	52                   	push   %edx
  80296b:	50                   	push   %eax
  80296c:	6a 1d                	push   $0x1d
  80296e:	e8 ae fc ff ff       	call   802621 <syscall>
  802973:	83 c4 18             	add    $0x18,%esp
	return result;
  802976:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802979:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80297c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80297f:	89 01                	mov    %eax,(%ecx)
  802981:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802984:	8b 45 08             	mov    0x8(%ebp),%eax
  802987:	c9                   	leave  
  802988:	c2 04 00             	ret    $0x4

0080298b <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80298b:	55                   	push   %ebp
  80298c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80298e:	6a 00                	push   $0x0
  802990:	6a 00                	push   $0x0
  802992:	ff 75 10             	pushl  0x10(%ebp)
  802995:	ff 75 0c             	pushl  0xc(%ebp)
  802998:	ff 75 08             	pushl  0x8(%ebp)
  80299b:	6a 13                	push   $0x13
  80299d:	e8 7f fc ff ff       	call   802621 <syscall>
  8029a2:	83 c4 18             	add    $0x18,%esp
	return ;
  8029a5:	90                   	nop
}
  8029a6:	c9                   	leave  
  8029a7:	c3                   	ret    

008029a8 <sys_rcr2>:
uint32 sys_rcr2()
{
  8029a8:	55                   	push   %ebp
  8029a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8029ab:	6a 00                	push   $0x0
  8029ad:	6a 00                	push   $0x0
  8029af:	6a 00                	push   $0x0
  8029b1:	6a 00                	push   $0x0
  8029b3:	6a 00                	push   $0x0
  8029b5:	6a 1e                	push   $0x1e
  8029b7:	e8 65 fc ff ff       	call   802621 <syscall>
  8029bc:	83 c4 18             	add    $0x18,%esp
}
  8029bf:	c9                   	leave  
  8029c0:	c3                   	ret    

008029c1 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8029c1:	55                   	push   %ebp
  8029c2:	89 e5                	mov    %esp,%ebp
  8029c4:	83 ec 04             	sub    $0x4,%esp
  8029c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ca:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8029cd:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8029d1:	6a 00                	push   $0x0
  8029d3:	6a 00                	push   $0x0
  8029d5:	6a 00                	push   $0x0
  8029d7:	6a 00                	push   $0x0
  8029d9:	50                   	push   %eax
  8029da:	6a 1f                	push   $0x1f
  8029dc:	e8 40 fc ff ff       	call   802621 <syscall>
  8029e1:	83 c4 18             	add    $0x18,%esp
	return ;
  8029e4:	90                   	nop
}
  8029e5:	c9                   	leave  
  8029e6:	c3                   	ret    

008029e7 <rsttst>:
void rsttst()
{
  8029e7:	55                   	push   %ebp
  8029e8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8029ea:	6a 00                	push   $0x0
  8029ec:	6a 00                	push   $0x0
  8029ee:	6a 00                	push   $0x0
  8029f0:	6a 00                	push   $0x0
  8029f2:	6a 00                	push   $0x0
  8029f4:	6a 21                	push   $0x21
  8029f6:	e8 26 fc ff ff       	call   802621 <syscall>
  8029fb:	83 c4 18             	add    $0x18,%esp
	return ;
  8029fe:	90                   	nop
}
  8029ff:	c9                   	leave  
  802a00:	c3                   	ret    

00802a01 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802a01:	55                   	push   %ebp
  802a02:	89 e5                	mov    %esp,%ebp
  802a04:	83 ec 04             	sub    $0x4,%esp
  802a07:	8b 45 14             	mov    0x14(%ebp),%eax
  802a0a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802a0d:	8b 55 18             	mov    0x18(%ebp),%edx
  802a10:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802a14:	52                   	push   %edx
  802a15:	50                   	push   %eax
  802a16:	ff 75 10             	pushl  0x10(%ebp)
  802a19:	ff 75 0c             	pushl  0xc(%ebp)
  802a1c:	ff 75 08             	pushl  0x8(%ebp)
  802a1f:	6a 20                	push   $0x20
  802a21:	e8 fb fb ff ff       	call   802621 <syscall>
  802a26:	83 c4 18             	add    $0x18,%esp
	return ;
  802a29:	90                   	nop
}
  802a2a:	c9                   	leave  
  802a2b:	c3                   	ret    

00802a2c <chktst>:
void chktst(uint32 n)
{
  802a2c:	55                   	push   %ebp
  802a2d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802a2f:	6a 00                	push   $0x0
  802a31:	6a 00                	push   $0x0
  802a33:	6a 00                	push   $0x0
  802a35:	6a 00                	push   $0x0
  802a37:	ff 75 08             	pushl  0x8(%ebp)
  802a3a:	6a 22                	push   $0x22
  802a3c:	e8 e0 fb ff ff       	call   802621 <syscall>
  802a41:	83 c4 18             	add    $0x18,%esp
	return ;
  802a44:	90                   	nop
}
  802a45:	c9                   	leave  
  802a46:	c3                   	ret    

00802a47 <inctst>:

void inctst()
{
  802a47:	55                   	push   %ebp
  802a48:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802a4a:	6a 00                	push   $0x0
  802a4c:	6a 00                	push   $0x0
  802a4e:	6a 00                	push   $0x0
  802a50:	6a 00                	push   $0x0
  802a52:	6a 00                	push   $0x0
  802a54:	6a 23                	push   $0x23
  802a56:	e8 c6 fb ff ff       	call   802621 <syscall>
  802a5b:	83 c4 18             	add    $0x18,%esp
	return ;
  802a5e:	90                   	nop
}
  802a5f:	c9                   	leave  
  802a60:	c3                   	ret    

00802a61 <gettst>:
uint32 gettst()
{
  802a61:	55                   	push   %ebp
  802a62:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802a64:	6a 00                	push   $0x0
  802a66:	6a 00                	push   $0x0
  802a68:	6a 00                	push   $0x0
  802a6a:	6a 00                	push   $0x0
  802a6c:	6a 00                	push   $0x0
  802a6e:	6a 24                	push   $0x24
  802a70:	e8 ac fb ff ff       	call   802621 <syscall>
  802a75:	83 c4 18             	add    $0x18,%esp
}
  802a78:	c9                   	leave  
  802a79:	c3                   	ret    

00802a7a <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  802a7a:	55                   	push   %ebp
  802a7b:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802a7d:	6a 00                	push   $0x0
  802a7f:	6a 00                	push   $0x0
  802a81:	6a 00                	push   $0x0
  802a83:	6a 00                	push   $0x0
  802a85:	6a 00                	push   $0x0
  802a87:	6a 25                	push   $0x25
  802a89:	e8 93 fb ff ff       	call   802621 <syscall>
  802a8e:	83 c4 18             	add    $0x18,%esp
  802a91:	a3 60 d0 81 00       	mov    %eax,0x81d060
	return uheapPlaceStrategy ;
  802a96:	a1 60 d0 81 00       	mov    0x81d060,%eax
}
  802a9b:	c9                   	leave  
  802a9c:	c3                   	ret    

00802a9d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802a9d:	55                   	push   %ebp
  802a9e:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  802aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa3:	a3 60 d0 81 00       	mov    %eax,0x81d060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802aa8:	6a 00                	push   $0x0
  802aaa:	6a 00                	push   $0x0
  802aac:	6a 00                	push   $0x0
  802aae:	6a 00                	push   $0x0
  802ab0:	ff 75 08             	pushl  0x8(%ebp)
  802ab3:	6a 26                	push   $0x26
  802ab5:	e8 67 fb ff ff       	call   802621 <syscall>
  802aba:	83 c4 18             	add    $0x18,%esp
	return ;
  802abd:	90                   	nop
}
  802abe:	c9                   	leave  
  802abf:	c3                   	ret    

00802ac0 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802ac0:	55                   	push   %ebp
  802ac1:	89 e5                	mov    %esp,%ebp
  802ac3:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802ac4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802ac7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802aca:	8b 55 0c             	mov    0xc(%ebp),%edx
  802acd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad0:	6a 00                	push   $0x0
  802ad2:	53                   	push   %ebx
  802ad3:	51                   	push   %ecx
  802ad4:	52                   	push   %edx
  802ad5:	50                   	push   %eax
  802ad6:	6a 27                	push   $0x27
  802ad8:	e8 44 fb ff ff       	call   802621 <syscall>
  802add:	83 c4 18             	add    $0x18,%esp
}
  802ae0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802ae3:	c9                   	leave  
  802ae4:	c3                   	ret    

00802ae5 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802ae5:	55                   	push   %ebp
  802ae6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802ae8:	8b 55 0c             	mov    0xc(%ebp),%edx
  802aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  802aee:	6a 00                	push   $0x0
  802af0:	6a 00                	push   $0x0
  802af2:	6a 00                	push   $0x0
  802af4:	52                   	push   %edx
  802af5:	50                   	push   %eax
  802af6:	6a 28                	push   $0x28
  802af8:	e8 24 fb ff ff       	call   802621 <syscall>
  802afd:	83 c4 18             	add    $0x18,%esp
}
  802b00:	c9                   	leave  
  802b01:	c3                   	ret    

00802b02 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802b02:	55                   	push   %ebp
  802b03:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802b05:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802b08:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0e:	6a 00                	push   $0x0
  802b10:	51                   	push   %ecx
  802b11:	ff 75 10             	pushl  0x10(%ebp)
  802b14:	52                   	push   %edx
  802b15:	50                   	push   %eax
  802b16:	6a 29                	push   $0x29
  802b18:	e8 04 fb ff ff       	call   802621 <syscall>
  802b1d:	83 c4 18             	add    $0x18,%esp
}
  802b20:	c9                   	leave  
  802b21:	c3                   	ret    

00802b22 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802b22:	55                   	push   %ebp
  802b23:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802b25:	6a 00                	push   $0x0
  802b27:	6a 00                	push   $0x0
  802b29:	ff 75 10             	pushl  0x10(%ebp)
  802b2c:	ff 75 0c             	pushl  0xc(%ebp)
  802b2f:	ff 75 08             	pushl  0x8(%ebp)
  802b32:	6a 12                	push   $0x12
  802b34:	e8 e8 fa ff ff       	call   802621 <syscall>
  802b39:	83 c4 18             	add    $0x18,%esp
	return ;
  802b3c:	90                   	nop
}
  802b3d:	c9                   	leave  
  802b3e:	c3                   	ret    

00802b3f <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802b3f:	55                   	push   %ebp
  802b40:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802b42:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b45:	8b 45 08             	mov    0x8(%ebp),%eax
  802b48:	6a 00                	push   $0x0
  802b4a:	6a 00                	push   $0x0
  802b4c:	6a 00                	push   $0x0
  802b4e:	52                   	push   %edx
  802b4f:	50                   	push   %eax
  802b50:	6a 2a                	push   $0x2a
  802b52:	e8 ca fa ff ff       	call   802621 <syscall>
  802b57:	83 c4 18             	add    $0x18,%esp
	return;
  802b5a:	90                   	nop
}
  802b5b:	c9                   	leave  
  802b5c:	c3                   	ret    

00802b5d <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  802b5d:	55                   	push   %ebp
  802b5e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  802b60:	6a 00                	push   $0x0
  802b62:	6a 00                	push   $0x0
  802b64:	6a 00                	push   $0x0
  802b66:	6a 00                	push   $0x0
  802b68:	6a 00                	push   $0x0
  802b6a:	6a 2b                	push   $0x2b
  802b6c:	e8 b0 fa ff ff       	call   802621 <syscall>
  802b71:	83 c4 18             	add    $0x18,%esp
}
  802b74:	c9                   	leave  
  802b75:	c3                   	ret    

00802b76 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802b76:	55                   	push   %ebp
  802b77:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802b79:	6a 00                	push   $0x0
  802b7b:	6a 00                	push   $0x0
  802b7d:	6a 00                	push   $0x0
  802b7f:	ff 75 0c             	pushl  0xc(%ebp)
  802b82:	ff 75 08             	pushl  0x8(%ebp)
  802b85:	6a 2d                	push   $0x2d
  802b87:	e8 95 fa ff ff       	call   802621 <syscall>
  802b8c:	83 c4 18             	add    $0x18,%esp
	return;
  802b8f:	90                   	nop
}
  802b90:	c9                   	leave  
  802b91:	c3                   	ret    

00802b92 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802b92:	55                   	push   %ebp
  802b93:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802b95:	6a 00                	push   $0x0
  802b97:	6a 00                	push   $0x0
  802b99:	6a 00                	push   $0x0
  802b9b:	ff 75 0c             	pushl  0xc(%ebp)
  802b9e:	ff 75 08             	pushl  0x8(%ebp)
  802ba1:	6a 2c                	push   $0x2c
  802ba3:	e8 79 fa ff ff       	call   802621 <syscall>
  802ba8:	83 c4 18             	add    $0x18,%esp
	return ;
  802bab:	90                   	nop
}
  802bac:	c9                   	leave  
  802bad:	c3                   	ret    

00802bae <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  802bae:	55                   	push   %ebp
  802baf:	89 e5                	mov    %esp,%ebp
  802bb1:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  802bb4:	83 ec 04             	sub    $0x4,%esp
  802bb7:	68 34 44 80 00       	push   $0x804434
  802bbc:	68 25 01 00 00       	push   $0x125
  802bc1:	68 67 44 80 00       	push   $0x804467
  802bc6:	e8 ec e6 ff ff       	call   8012b7 <_panic>

00802bcb <to_page_va>:
//==================================================================================//
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  802bcb:	55                   	push   %ebp
  802bcc:	89 e5                	mov    %esp,%ebp
  802bce:	83 ec 10             	sub    $0x10,%esp
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  802bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd4:	ba 60 50 80 00       	mov    $0x805060,%edx
  802bd9:	29 d0                	sub    %edx,%eax
  802bdb:	c1 f8 02             	sar    $0x2,%eax
  802bde:	89 c2                	mov    %eax,%edx
  802be0:	89 d0                	mov    %edx,%eax
  802be2:	c1 e0 02             	shl    $0x2,%eax
  802be5:	01 d0                	add    %edx,%eax
  802be7:	c1 e0 02             	shl    $0x2,%eax
  802bea:	01 d0                	add    %edx,%eax
  802bec:	c1 e0 02             	shl    $0x2,%eax
  802bef:	01 d0                	add    %edx,%eax
  802bf1:	89 c1                	mov    %eax,%ecx
  802bf3:	c1 e1 08             	shl    $0x8,%ecx
  802bf6:	01 c8                	add    %ecx,%eax
  802bf8:	89 c1                	mov    %eax,%ecx
  802bfa:	c1 e1 10             	shl    $0x10,%ecx
  802bfd:	01 c8                	add    %ecx,%eax
  802bff:	01 c0                	add    %eax,%eax
  802c01:	01 d0                	add    %edx,%eax
  802c03:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  802c06:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802c09:	c1 e0 0c             	shl    $0xc,%eax
  802c0c:	89 c2                	mov    %eax,%edx
  802c0e:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802c13:	01 d0                	add    %edx,%eax
}
  802c15:	c9                   	leave  
  802c16:	c3                   	ret    

00802c17 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  802c17:	55                   	push   %ebp
  802c18:	89 e5                	mov    %esp,%ebp
  802c1a:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  802c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c20:	05 00 00 00 02       	add    $0x2000000,%eax
  802c25:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802c28:	73 16                	jae    802c40 <initialize_dynamic_allocator+0x29>
  802c2a:	68 78 44 80 00       	push   $0x804478
  802c2f:	68 9e 44 80 00       	push   $0x80449e
  802c34:	6a 26                	push   $0x26
  802c36:	68 b3 44 80 00       	push   $0x8044b3
  802c3b:	e8 77 e6 ff ff       	call   8012b7 <_panic>
		is_initialized = 1;
  802c40:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  802c47:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	//Comment the following line
	panic("initialize_dynamic_allocator() Not implemented yet");
  802c4a:	83 ec 04             	sub    $0x4,%esp
  802c4d:	68 cc 44 80 00       	push   $0x8044cc
  802c52:	6a 2e                	push   $0x2e
  802c54:	68 b3 44 80 00       	push   $0x8044b3
  802c59:	e8 59 e6 ff ff       	call   8012b7 <_panic>

00802c5e <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  802c5e:	55                   	push   %ebp
  802c5f:	89 e5                	mov    %esp,%ebp
  802c61:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	//Comment the following line
	panic("get_block_size() Not implemented yet");
  802c64:	83 ec 04             	sub    $0x4,%esp
  802c67:	68 00 45 80 00       	push   $0x804500
  802c6c:	6a 3a                	push   $0x3a
  802c6e:	68 b3 44 80 00       	push   $0x8044b3
  802c73:	e8 3f e6 ff ff       	call   8012b7 <_panic>

00802c78 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  802c78:	55                   	push   %ebp
  802c79:	89 e5                	mov    %esp,%ebp
  802c7b:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  802c7e:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802c85:	76 16                	jbe    802c9d <alloc_block+0x25>
  802c87:	68 28 45 80 00       	push   $0x804528
  802c8c:	68 9e 44 80 00       	push   $0x80449e
  802c91:	6a 46                	push   $0x46
  802c93:	68 b3 44 80 00       	push   $0x8044b3
  802c98:	e8 1a e6 ff ff       	call   8012b7 <_panic>
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	panic("alloc_block() Not implemented yet");
  802c9d:	83 ec 04             	sub    $0x4,%esp
  802ca0:	68 4c 45 80 00       	push   $0x80454c
  802ca5:	6a 4d                	push   $0x4d
  802ca7:	68 b3 44 80 00       	push   $0x8044b3
  802cac:	e8 06 e6 ff ff       	call   8012b7 <_panic>

00802cb1 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  802cb1:	55                   	push   %ebp
  802cb2:	89 e5                	mov    %esp,%ebp
  802cb4:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  802cb7:	8b 55 08             	mov    0x8(%ebp),%edx
  802cba:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802cbf:	39 c2                	cmp    %eax,%edx
  802cc1:	72 0c                	jb     802ccf <free_block+0x1e>
  802cc3:	8b 55 08             	mov    0x8(%ebp),%edx
  802cc6:	a1 40 50 80 00       	mov    0x805040,%eax
  802ccb:	39 c2                	cmp    %eax,%edx
  802ccd:	72 16                	jb     802ce5 <free_block+0x34>
  802ccf:	68 70 45 80 00       	push   $0x804570
  802cd4:	68 9e 44 80 00       	push   $0x80449e
  802cd9:	6a 5b                	push   $0x5b
  802cdb:	68 b3 44 80 00       	push   $0x8044b3
  802ce0:	e8 d2 e5 ff ff       	call   8012b7 <_panic>
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	panic("free_block() Not implemented yet");
  802ce5:	83 ec 04             	sub    $0x4,%esp
  802ce8:	68 a8 45 80 00       	push   $0x8045a8
  802ced:	6a 63                	push   $0x63
  802cef:	68 b3 44 80 00       	push   $0x8044b3
  802cf4:	e8 be e5 ff ff       	call   8012b7 <_panic>

00802cf9 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  802cf9:	55                   	push   %ebp
  802cfa:	89 e5                	mov    %esp,%ebp
  802cfc:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  802cff:	83 ec 04             	sub    $0x4,%esp
  802d02:	68 cc 45 80 00       	push   $0x8045cc
  802d07:	6a 72                	push   $0x72
  802d09:	68 b3 44 80 00       	push   $0x8044b3
  802d0e:	e8 a4 e5 ff ff       	call   8012b7 <_panic>
  802d13:	90                   	nop

00802d14 <__udivdi3>:
  802d14:	55                   	push   %ebp
  802d15:	57                   	push   %edi
  802d16:	56                   	push   %esi
  802d17:	53                   	push   %ebx
  802d18:	83 ec 1c             	sub    $0x1c,%esp
  802d1b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802d1f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802d23:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802d27:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802d2b:	89 ca                	mov    %ecx,%edx
  802d2d:	89 f8                	mov    %edi,%eax
  802d2f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802d33:	85 f6                	test   %esi,%esi
  802d35:	75 2d                	jne    802d64 <__udivdi3+0x50>
  802d37:	39 cf                	cmp    %ecx,%edi
  802d39:	77 65                	ja     802da0 <__udivdi3+0x8c>
  802d3b:	89 fd                	mov    %edi,%ebp
  802d3d:	85 ff                	test   %edi,%edi
  802d3f:	75 0b                	jne    802d4c <__udivdi3+0x38>
  802d41:	b8 01 00 00 00       	mov    $0x1,%eax
  802d46:	31 d2                	xor    %edx,%edx
  802d48:	f7 f7                	div    %edi
  802d4a:	89 c5                	mov    %eax,%ebp
  802d4c:	31 d2                	xor    %edx,%edx
  802d4e:	89 c8                	mov    %ecx,%eax
  802d50:	f7 f5                	div    %ebp
  802d52:	89 c1                	mov    %eax,%ecx
  802d54:	89 d8                	mov    %ebx,%eax
  802d56:	f7 f5                	div    %ebp
  802d58:	89 cf                	mov    %ecx,%edi
  802d5a:	89 fa                	mov    %edi,%edx
  802d5c:	83 c4 1c             	add    $0x1c,%esp
  802d5f:	5b                   	pop    %ebx
  802d60:	5e                   	pop    %esi
  802d61:	5f                   	pop    %edi
  802d62:	5d                   	pop    %ebp
  802d63:	c3                   	ret    
  802d64:	39 ce                	cmp    %ecx,%esi
  802d66:	77 28                	ja     802d90 <__udivdi3+0x7c>
  802d68:	0f bd fe             	bsr    %esi,%edi
  802d6b:	83 f7 1f             	xor    $0x1f,%edi
  802d6e:	75 40                	jne    802db0 <__udivdi3+0x9c>
  802d70:	39 ce                	cmp    %ecx,%esi
  802d72:	72 0a                	jb     802d7e <__udivdi3+0x6a>
  802d74:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802d78:	0f 87 9e 00 00 00    	ja     802e1c <__udivdi3+0x108>
  802d7e:	b8 01 00 00 00       	mov    $0x1,%eax
  802d83:	89 fa                	mov    %edi,%edx
  802d85:	83 c4 1c             	add    $0x1c,%esp
  802d88:	5b                   	pop    %ebx
  802d89:	5e                   	pop    %esi
  802d8a:	5f                   	pop    %edi
  802d8b:	5d                   	pop    %ebp
  802d8c:	c3                   	ret    
  802d8d:	8d 76 00             	lea    0x0(%esi),%esi
  802d90:	31 ff                	xor    %edi,%edi
  802d92:	31 c0                	xor    %eax,%eax
  802d94:	89 fa                	mov    %edi,%edx
  802d96:	83 c4 1c             	add    $0x1c,%esp
  802d99:	5b                   	pop    %ebx
  802d9a:	5e                   	pop    %esi
  802d9b:	5f                   	pop    %edi
  802d9c:	5d                   	pop    %ebp
  802d9d:	c3                   	ret    
  802d9e:	66 90                	xchg   %ax,%ax
  802da0:	89 d8                	mov    %ebx,%eax
  802da2:	f7 f7                	div    %edi
  802da4:	31 ff                	xor    %edi,%edi
  802da6:	89 fa                	mov    %edi,%edx
  802da8:	83 c4 1c             	add    $0x1c,%esp
  802dab:	5b                   	pop    %ebx
  802dac:	5e                   	pop    %esi
  802dad:	5f                   	pop    %edi
  802dae:	5d                   	pop    %ebp
  802daf:	c3                   	ret    
  802db0:	bd 20 00 00 00       	mov    $0x20,%ebp
  802db5:	89 eb                	mov    %ebp,%ebx
  802db7:	29 fb                	sub    %edi,%ebx
  802db9:	89 f9                	mov    %edi,%ecx
  802dbb:	d3 e6                	shl    %cl,%esi
  802dbd:	89 c5                	mov    %eax,%ebp
  802dbf:	88 d9                	mov    %bl,%cl
  802dc1:	d3 ed                	shr    %cl,%ebp
  802dc3:	89 e9                	mov    %ebp,%ecx
  802dc5:	09 f1                	or     %esi,%ecx
  802dc7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802dcb:	89 f9                	mov    %edi,%ecx
  802dcd:	d3 e0                	shl    %cl,%eax
  802dcf:	89 c5                	mov    %eax,%ebp
  802dd1:	89 d6                	mov    %edx,%esi
  802dd3:	88 d9                	mov    %bl,%cl
  802dd5:	d3 ee                	shr    %cl,%esi
  802dd7:	89 f9                	mov    %edi,%ecx
  802dd9:	d3 e2                	shl    %cl,%edx
  802ddb:	8b 44 24 08          	mov    0x8(%esp),%eax
  802ddf:	88 d9                	mov    %bl,%cl
  802de1:	d3 e8                	shr    %cl,%eax
  802de3:	09 c2                	or     %eax,%edx
  802de5:	89 d0                	mov    %edx,%eax
  802de7:	89 f2                	mov    %esi,%edx
  802de9:	f7 74 24 0c          	divl   0xc(%esp)
  802ded:	89 d6                	mov    %edx,%esi
  802def:	89 c3                	mov    %eax,%ebx
  802df1:	f7 e5                	mul    %ebp
  802df3:	39 d6                	cmp    %edx,%esi
  802df5:	72 19                	jb     802e10 <__udivdi3+0xfc>
  802df7:	74 0b                	je     802e04 <__udivdi3+0xf0>
  802df9:	89 d8                	mov    %ebx,%eax
  802dfb:	31 ff                	xor    %edi,%edi
  802dfd:	e9 58 ff ff ff       	jmp    802d5a <__udivdi3+0x46>
  802e02:	66 90                	xchg   %ax,%ax
  802e04:	8b 54 24 08          	mov    0x8(%esp),%edx
  802e08:	89 f9                	mov    %edi,%ecx
  802e0a:	d3 e2                	shl    %cl,%edx
  802e0c:	39 c2                	cmp    %eax,%edx
  802e0e:	73 e9                	jae    802df9 <__udivdi3+0xe5>
  802e10:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802e13:	31 ff                	xor    %edi,%edi
  802e15:	e9 40 ff ff ff       	jmp    802d5a <__udivdi3+0x46>
  802e1a:	66 90                	xchg   %ax,%ax
  802e1c:	31 c0                	xor    %eax,%eax
  802e1e:	e9 37 ff ff ff       	jmp    802d5a <__udivdi3+0x46>
  802e23:	90                   	nop

00802e24 <__umoddi3>:
  802e24:	55                   	push   %ebp
  802e25:	57                   	push   %edi
  802e26:	56                   	push   %esi
  802e27:	53                   	push   %ebx
  802e28:	83 ec 1c             	sub    $0x1c,%esp
  802e2b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802e2f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802e33:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802e37:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802e3b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802e3f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802e43:	89 f3                	mov    %esi,%ebx
  802e45:	89 fa                	mov    %edi,%edx
  802e47:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802e4b:	89 34 24             	mov    %esi,(%esp)
  802e4e:	85 c0                	test   %eax,%eax
  802e50:	75 1a                	jne    802e6c <__umoddi3+0x48>
  802e52:	39 f7                	cmp    %esi,%edi
  802e54:	0f 86 a2 00 00 00    	jbe    802efc <__umoddi3+0xd8>
  802e5a:	89 c8                	mov    %ecx,%eax
  802e5c:	89 f2                	mov    %esi,%edx
  802e5e:	f7 f7                	div    %edi
  802e60:	89 d0                	mov    %edx,%eax
  802e62:	31 d2                	xor    %edx,%edx
  802e64:	83 c4 1c             	add    $0x1c,%esp
  802e67:	5b                   	pop    %ebx
  802e68:	5e                   	pop    %esi
  802e69:	5f                   	pop    %edi
  802e6a:	5d                   	pop    %ebp
  802e6b:	c3                   	ret    
  802e6c:	39 f0                	cmp    %esi,%eax
  802e6e:	0f 87 ac 00 00 00    	ja     802f20 <__umoddi3+0xfc>
  802e74:	0f bd e8             	bsr    %eax,%ebp
  802e77:	83 f5 1f             	xor    $0x1f,%ebp
  802e7a:	0f 84 ac 00 00 00    	je     802f2c <__umoddi3+0x108>
  802e80:	bf 20 00 00 00       	mov    $0x20,%edi
  802e85:	29 ef                	sub    %ebp,%edi
  802e87:	89 fe                	mov    %edi,%esi
  802e89:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802e8d:	89 e9                	mov    %ebp,%ecx
  802e8f:	d3 e0                	shl    %cl,%eax
  802e91:	89 d7                	mov    %edx,%edi
  802e93:	89 f1                	mov    %esi,%ecx
  802e95:	d3 ef                	shr    %cl,%edi
  802e97:	09 c7                	or     %eax,%edi
  802e99:	89 e9                	mov    %ebp,%ecx
  802e9b:	d3 e2                	shl    %cl,%edx
  802e9d:	89 14 24             	mov    %edx,(%esp)
  802ea0:	89 d8                	mov    %ebx,%eax
  802ea2:	d3 e0                	shl    %cl,%eax
  802ea4:	89 c2                	mov    %eax,%edx
  802ea6:	8b 44 24 08          	mov    0x8(%esp),%eax
  802eaa:	d3 e0                	shl    %cl,%eax
  802eac:	89 44 24 04          	mov    %eax,0x4(%esp)
  802eb0:	8b 44 24 08          	mov    0x8(%esp),%eax
  802eb4:	89 f1                	mov    %esi,%ecx
  802eb6:	d3 e8                	shr    %cl,%eax
  802eb8:	09 d0                	or     %edx,%eax
  802eba:	d3 eb                	shr    %cl,%ebx
  802ebc:	89 da                	mov    %ebx,%edx
  802ebe:	f7 f7                	div    %edi
  802ec0:	89 d3                	mov    %edx,%ebx
  802ec2:	f7 24 24             	mull   (%esp)
  802ec5:	89 c6                	mov    %eax,%esi
  802ec7:	89 d1                	mov    %edx,%ecx
  802ec9:	39 d3                	cmp    %edx,%ebx
  802ecb:	0f 82 87 00 00 00    	jb     802f58 <__umoddi3+0x134>
  802ed1:	0f 84 91 00 00 00    	je     802f68 <__umoddi3+0x144>
  802ed7:	8b 54 24 04          	mov    0x4(%esp),%edx
  802edb:	29 f2                	sub    %esi,%edx
  802edd:	19 cb                	sbb    %ecx,%ebx
  802edf:	89 d8                	mov    %ebx,%eax
  802ee1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802ee5:	d3 e0                	shl    %cl,%eax
  802ee7:	89 e9                	mov    %ebp,%ecx
  802ee9:	d3 ea                	shr    %cl,%edx
  802eeb:	09 d0                	or     %edx,%eax
  802eed:	89 e9                	mov    %ebp,%ecx
  802eef:	d3 eb                	shr    %cl,%ebx
  802ef1:	89 da                	mov    %ebx,%edx
  802ef3:	83 c4 1c             	add    $0x1c,%esp
  802ef6:	5b                   	pop    %ebx
  802ef7:	5e                   	pop    %esi
  802ef8:	5f                   	pop    %edi
  802ef9:	5d                   	pop    %ebp
  802efa:	c3                   	ret    
  802efb:	90                   	nop
  802efc:	89 fd                	mov    %edi,%ebp
  802efe:	85 ff                	test   %edi,%edi
  802f00:	75 0b                	jne    802f0d <__umoddi3+0xe9>
  802f02:	b8 01 00 00 00       	mov    $0x1,%eax
  802f07:	31 d2                	xor    %edx,%edx
  802f09:	f7 f7                	div    %edi
  802f0b:	89 c5                	mov    %eax,%ebp
  802f0d:	89 f0                	mov    %esi,%eax
  802f0f:	31 d2                	xor    %edx,%edx
  802f11:	f7 f5                	div    %ebp
  802f13:	89 c8                	mov    %ecx,%eax
  802f15:	f7 f5                	div    %ebp
  802f17:	89 d0                	mov    %edx,%eax
  802f19:	e9 44 ff ff ff       	jmp    802e62 <__umoddi3+0x3e>
  802f1e:	66 90                	xchg   %ax,%ax
  802f20:	89 c8                	mov    %ecx,%eax
  802f22:	89 f2                	mov    %esi,%edx
  802f24:	83 c4 1c             	add    $0x1c,%esp
  802f27:	5b                   	pop    %ebx
  802f28:	5e                   	pop    %esi
  802f29:	5f                   	pop    %edi
  802f2a:	5d                   	pop    %ebp
  802f2b:	c3                   	ret    
  802f2c:	3b 04 24             	cmp    (%esp),%eax
  802f2f:	72 06                	jb     802f37 <__umoddi3+0x113>
  802f31:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802f35:	77 0f                	ja     802f46 <__umoddi3+0x122>
  802f37:	89 f2                	mov    %esi,%edx
  802f39:	29 f9                	sub    %edi,%ecx
  802f3b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802f3f:	89 14 24             	mov    %edx,(%esp)
  802f42:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802f46:	8b 44 24 04          	mov    0x4(%esp),%eax
  802f4a:	8b 14 24             	mov    (%esp),%edx
  802f4d:	83 c4 1c             	add    $0x1c,%esp
  802f50:	5b                   	pop    %ebx
  802f51:	5e                   	pop    %esi
  802f52:	5f                   	pop    %edi
  802f53:	5d                   	pop    %ebp
  802f54:	c3                   	ret    
  802f55:	8d 76 00             	lea    0x0(%esi),%esi
  802f58:	2b 04 24             	sub    (%esp),%eax
  802f5b:	19 fa                	sbb    %edi,%edx
  802f5d:	89 d1                	mov    %edx,%ecx
  802f5f:	89 c6                	mov    %eax,%esi
  802f61:	e9 71 ff ff ff       	jmp    802ed7 <__umoddi3+0xb3>
  802f66:	66 90                	xchg   %ax,%ax
  802f68:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802f6c:	72 ea                	jb     802f58 <__umoddi3+0x134>
  802f6e:	89 d9                	mov    %ebx,%ecx
  802f70:	e9 62 ff ff ff       	jmp    802ed7 <__umoddi3+0xb3>

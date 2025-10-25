
obj/user/tst_free_1:     file format elf32-i386


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
  800031:	e8 7e 16 00 00       	call   8016b4 <libmain>
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
  80005e:	81 ec b0 01 00 00    	sub    $0x1b0,%esp

#if USE_KHEAP
	//cprintf("1\n");
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  800064:	a1 20 60 80 00       	mov    0x806020,%eax
  800069:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
  80006f:	a1 20 60 80 00       	mov    0x806020,%eax
  800074:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80007a:	39 c2                	cmp    %eax,%edx
  80007c:	72 14                	jb     800092 <_main+0x39>
			panic("Please increase the WS size");
  80007e:	83 ec 04             	sub    $0x4,%esp
  800081:	68 00 36 80 00       	push   $0x803600
  800086:	6a 1e                	push   $0x1e
  800088:	68 1c 36 80 00       	push   $0x80361c
  80008d:	e8 d2 17 00 00       	call   801864 <_panic>
	}
	/*=================================================*/
#else
	panic("not handled!");
#endif
	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  800092:	c7 45 ec 00 10 00 82 	movl   $0x82001000,-0x14(%ebp)

	int eval = 0;
  800099:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	bool is_correct = 1;
  8000a0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

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
	short *shortArr, *shortArr2 ;
	int *intArr;
	struct MyStruct *structArr ;
	int lastIndexOfByte, lastIndexOfByte2, lastIndexOfShort, lastIndexOfShort2, lastIndexOfInt, lastIndexOfStruct;
	bool found;
	int start_freeFrames = sys_calculate_free_frames() ;
  8000d7:	e8 11 2c 00 00       	call   802ced <sys_calculate_free_frames>
  8000dc:	89 45 d0             	mov    %eax,-0x30(%ebp)
	int freeFrames, usedDiskPages, chk;
	int expectedNumOfFrames, actualNumOfFrames;
	cprintf("\n%~[1] Allocate spaces of different sizes in PAGE ALLOCATOR and write some data to them\n");
  8000df:	83 ec 0c             	sub    $0xc,%esp
  8000e2:	68 30 36 80 00       	push   $0x803630
  8000e7:	e8 46 1a 00 00       	call   801b32 <cprintf>
  8000ec:	83 c4 10             	add    $0x10,%esp
	void* ptr_allocations[20] = {0};
  8000ef:	8d 95 bc fe ff ff    	lea    -0x144(%ebp),%edx
  8000f5:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ff:	89 d7                	mov    %edx,%edi
  800101:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		//cprintf("3\n");
		//2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  800103:	e8 e5 2b 00 00       	call   802ced <sys_calculate_free_frames>
  800108:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80010b:	e8 28 2c 00 00       	call   802d38 <sys_pf_calculate_allocated_pages>
  800110:	89 45 c8             	mov    %eax,-0x38(%ebp)
			ptr_allocations[0] = malloc(2*Mega-kilo);
  800113:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800116:	01 c0                	add    %eax,%eax
  800118:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	50                   	push   %eax
  80011f:	e8 d0 29 00 00       	call   802af4 <malloc>
  800124:	83 c4 10             	add    $0x10,%esp
  800127:	89 85 bc fe ff ff    	mov    %eax,-0x144(%ebp)
			if ((uint32) ptr_allocations[0] != (pagealloc_start)) {is_correct = 0; cprintf("1 Wrong start address for the allocated space... \n");}
  80012d:	8b 85 bc fe ff ff    	mov    -0x144(%ebp),%eax
  800133:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800136:	74 17                	je     80014f <_main+0xf6>
  800138:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80013f:	83 ec 0c             	sub    $0xc,%esp
  800142:	68 8c 36 80 00       	push   $0x80368c
  800147:	e8 e6 19 00 00       	call   801b32 <cprintf>
  80014c:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 1 /*table*/ ;
  80014f:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  800156:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800159:	e8 8f 2b 00 00       	call   802ced <sys_calculate_free_frames>
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
  800195:	68 c0 36 80 00       	push   $0x8036c0
  80019a:	e8 93 19 00 00       	call   801b32 <cprintf>
  80019f:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("1 Extra or less pages are allocated in PageFile\n");}
  8001a2:	e8 91 2b 00 00       	call   802d38 <sys_pf_calculate_allocated_pages>
  8001a7:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8001aa:	74 17                	je     8001c3 <_main+0x16a>
  8001ac:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001b3:	83 ec 0c             	sub    $0xc,%esp
  8001b6:	68 30 37 80 00       	push   $0x803730
  8001bb:	e8 72 19 00 00       	call   801b32 <cprintf>
  8001c0:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  8001c3:	e8 25 2b 00 00       	call   802ced <sys_calculate_free_frames>
  8001c8:	89 45 cc             	mov    %eax,-0x34(%ebp)
			lastIndexOfByte = (2*Mega-kilo)/sizeof(char) - 1;
  8001cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001ce:	01 c0                	add    %eax,%eax
  8001d0:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8001d3:	48                   	dec    %eax
  8001d4:	89 45 bc             	mov    %eax,-0x44(%ebp)
			byteArr = (char *) ptr_allocations[0];
  8001d7:	8b 85 bc fe ff ff    	mov    -0x144(%ebp),%eax
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
  8001ff:	e8 e9 2a 00 00       	call   802ced <sys_calculate_free_frames>
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
  800237:	68 64 37 80 00       	push   $0x803764
  80023c:	e8 f1 18 00 00       	call   801b32 <cprintf>
  800241:	83 c4 10             	add    $0x10,%esp

			uint32 expectedVAs[2] = { ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE)} ;
  800244:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800247:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  80024a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80024d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800252:	89 85 b4 fe ff ff    	mov    %eax,-0x14c(%ebp)
  800258:	8b 55 bc             	mov    -0x44(%ebp),%edx
  80025b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80025e:	01 d0                	add    %edx,%eax
  800260:	89 45 b0             	mov    %eax,-0x50(%ebp)
  800263:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800266:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80026b:	89 85 b8 fe ff ff    	mov    %eax,-0x148(%ebp)
			found = sys_check_WS_list(expectedVAs, 2, 0, 2);
  800271:	6a 02                	push   $0x2
  800273:	6a 00                	push   $0x0
  800275:	6a 02                	push   $0x2
  800277:	8d 85 b4 fe ff ff    	lea    -0x14c(%ebp),%eax
  80027d:	50                   	push   %eax
  80027e:	e8 2c 2e 00 00       	call   8030af <sys_check_WS_list>
  800283:	83 c4 10             	add    $0x10,%esp
  800286:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("1 malloc: page is not added to WS\n");}
  800289:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  80028d:	74 17                	je     8002a6 <_main+0x24d>
  80028f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800296:	83 ec 0c             	sub    $0xc,%esp
  800299:	68 e4 37 80 00       	push   $0x8037e4
  80029e:	e8 8f 18 00 00       	call   801b32 <cprintf>
  8002a3:	83 c4 10             	add    $0x10,%esp
		}
		//2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  8002a6:	e8 42 2a 00 00       	call   802ced <sys_calculate_free_frames>
  8002ab:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8002ae:	e8 85 2a 00 00       	call   802d38 <sys_pf_calculate_allocated_pages>
  8002b3:	89 45 c8             	mov    %eax,-0x38(%ebp)
			ptr_allocations[1] = malloc(2*Mega-kilo);
  8002b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002b9:	01 c0                	add    %eax,%eax
  8002bb:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8002be:	83 ec 0c             	sub    $0xc,%esp
  8002c1:	50                   	push   %eax
  8002c2:	e8 2d 28 00 00       	call   802af4 <malloc>
  8002c7:	83 c4 10             	add    $0x10,%esp
  8002ca:	89 85 c0 fe ff ff    	mov    %eax,-0x140(%ebp)
			if ((uint32) ptr_allocations[1] != (pagealloc_start + 2*Mega)) { is_correct = 0; cprintf("2 Wrong start address for the allocated space... \n");}
  8002d0:	8b 85 c0 fe ff ff    	mov    -0x140(%ebp),%eax
  8002d6:	89 c2                	mov    %eax,%edx
  8002d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002db:	01 c0                	add    %eax,%eax
  8002dd:	89 c1                	mov    %eax,%ecx
  8002df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002e2:	01 c8                	add    %ecx,%eax
  8002e4:	39 c2                	cmp    %eax,%edx
  8002e6:	74 17                	je     8002ff <_main+0x2a6>
  8002e8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8002ef:	83 ec 0c             	sub    $0xc,%esp
  8002f2:	68 08 38 80 00       	push   $0x803808
  8002f7:	e8 36 18 00 00       	call   801b32 <cprintf>
  8002fc:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 0 /*table exists*/ ;
  8002ff:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  800306:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800309:	e8 df 29 00 00       	call   802ced <sys_calculate_free_frames>
  80030e:	29 c3                	sub    %eax,%ebx
  800310:	89 d8                	mov    %ebx,%eax
  800312:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  800315:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800318:	83 c0 02             	add    $0x2,%eax
  80031b:	83 ec 04             	sub    $0x4,%esp
  80031e:	50                   	push   %eax
  80031f:	ff 75 c4             	pushl  -0x3c(%ebp)
  800322:	ff 75 c0             	pushl  -0x40(%ebp)
  800325:	e8 0e fd ff ff       	call   800038 <inRange>
  80032a:	83 c4 10             	add    $0x10,%esp
  80032d:	85 c0                	test   %eax,%eax
  80032f:	75 21                	jne    800352 <_main+0x2f9>
			{is_correct = 0; cprintf("2 Wrong allocation: unexpected number of pages that are allocated in memory! Expected = [%d, %d], Actual = %d\n", expectedNumOfFrames, expectedNumOfFrames+2, actualNumOfFrames);}
  800331:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800338:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80033b:	83 c0 02             	add    $0x2,%eax
  80033e:	ff 75 c0             	pushl  -0x40(%ebp)
  800341:	50                   	push   %eax
  800342:	ff 75 c4             	pushl  -0x3c(%ebp)
  800345:	68 3c 38 80 00       	push   $0x80383c
  80034a:	e8 e3 17 00 00       	call   801b32 <cprintf>
  80034f:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("2 Extra or less pages are allocated in PageFile\n");}
  800352:	e8 e1 29 00 00       	call   802d38 <sys_pf_calculate_allocated_pages>
  800357:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80035a:	74 17                	je     800373 <_main+0x31a>
  80035c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800363:	83 ec 0c             	sub    $0xc,%esp
  800366:	68 ac 38 80 00       	push   $0x8038ac
  80036b:	e8 c2 17 00 00       	call   801b32 <cprintf>
  800370:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  800373:	e8 75 29 00 00       	call   802ced <sys_calculate_free_frames>
  800378:	89 45 cc             	mov    %eax,-0x34(%ebp)
			shortArr = (short *) ptr_allocations[1];
  80037b:	8b 85 c0 fe ff ff    	mov    -0x140(%ebp),%eax
  800381:	89 45 a8             	mov    %eax,-0x58(%ebp)
			lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
  800384:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800387:	01 c0                	add    %eax,%eax
  800389:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80038c:	d1 e8                	shr    %eax
  80038e:	48                   	dec    %eax
  80038f:	89 45 a4             	mov    %eax,-0x5c(%ebp)
			shortArr[0] = minShort;
  800392:	8b 55 a8             	mov    -0x58(%ebp),%edx
  800395:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800398:	66 89 02             	mov    %ax,(%edx)
			shortArr[lastIndexOfShort] = maxShort;
  80039b:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80039e:	01 c0                	add    %eax,%eax
  8003a0:	89 c2                	mov    %eax,%edx
  8003a2:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8003a5:	01 c2                	add    %eax,%edx
  8003a7:	66 8b 45 de          	mov    -0x22(%ebp),%ax
  8003ab:	66 89 02             	mov    %ax,(%edx)
			expectedNumOfFrames = 2 ;
  8003ae:	c7 45 c4 02 00 00 00 	movl   $0x2,-0x3c(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  8003b5:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8003b8:	e8 30 29 00 00       	call   802ced <sys_calculate_free_frames>
  8003bd:	29 c3                	sub    %eax,%ebx
  8003bf:	89 d8                	mov    %ebx,%eax
  8003c1:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  8003c4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8003c7:	83 c0 02             	add    $0x2,%eax
  8003ca:	83 ec 04             	sub    $0x4,%esp
  8003cd:	50                   	push   %eax
  8003ce:	ff 75 c4             	pushl  -0x3c(%ebp)
  8003d1:	ff 75 c0             	pushl  -0x40(%ebp)
  8003d4:	e8 5f fc ff ff       	call   800038 <inRange>
  8003d9:	83 c4 10             	add    $0x10,%esp
  8003dc:	85 c0                	test   %eax,%eax
  8003de:	75 1d                	jne    8003fd <_main+0x3a4>
			{ is_correct = 0; cprintf("2 Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);}
  8003e0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003e7:	83 ec 04             	sub    $0x4,%esp
  8003ea:	ff 75 c0             	pushl  -0x40(%ebp)
  8003ed:	ff 75 c4             	pushl  -0x3c(%ebp)
  8003f0:	68 e0 38 80 00       	push   $0x8038e0
  8003f5:	e8 38 17 00 00       	call   801b32 <cprintf>
  8003fa:	83 c4 10             	add    $0x10,%esp
			uint32 expectedVAs[2] = { ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE)} ;
  8003fd:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800400:	89 45 a0             	mov    %eax,-0x60(%ebp)
  800403:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800406:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80040b:	89 85 ac fe ff ff    	mov    %eax,-0x154(%ebp)
  800411:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800414:	01 c0                	add    %eax,%eax
  800416:	89 c2                	mov    %eax,%edx
  800418:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80041b:	01 d0                	add    %edx,%eax
  80041d:	89 45 9c             	mov    %eax,-0x64(%ebp)
  800420:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800423:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800428:	89 85 b0 fe ff ff    	mov    %eax,-0x150(%ebp)
			found = sys_check_WS_list(expectedVAs, 2, 0, 2);
  80042e:	6a 02                	push   $0x2
  800430:	6a 00                	push   $0x0
  800432:	6a 02                	push   $0x2
  800434:	8d 85 ac fe ff ff    	lea    -0x154(%ebp),%eax
  80043a:	50                   	push   %eax
  80043b:	e8 6f 2c 00 00       	call   8030af <sys_check_WS_list>
  800440:	83 c4 10             	add    $0x10,%esp
  800443:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("2 malloc: page is not added to WS\n");}
  800446:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  80044a:	74 17                	je     800463 <_main+0x40a>
  80044c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800453:	83 ec 0c             	sub    $0xc,%esp
  800456:	68 60 39 80 00       	push   $0x803960
  80045b:	e8 d2 16 00 00       	call   801b32 <cprintf>
  800460:	83 c4 10             	add    $0x10,%esp
		}

		//3 KB
		{
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800463:	e8 d0 28 00 00       	call   802d38 <sys_pf_calculate_allocated_pages>
  800468:	89 45 c8             	mov    %eax,-0x38(%ebp)
			ptr_allocations[2] = malloc(3*kilo);
  80046b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80046e:	89 c2                	mov    %eax,%edx
  800470:	01 d2                	add    %edx,%edx
  800472:	01 d0                	add    %edx,%eax
  800474:	83 ec 0c             	sub    $0xc,%esp
  800477:	50                   	push   %eax
  800478:	e8 77 26 00 00       	call   802af4 <malloc>
  80047d:	83 c4 10             	add    $0x10,%esp
  800480:	89 85 c4 fe ff ff    	mov    %eax,-0x13c(%ebp)
			if ((uint32) ptr_allocations[2] != (pagealloc_start + 4*Mega)) { is_correct = 0; cprintf("3 Wrong start address for the allocated space... \n");}
  800486:	8b 85 c4 fe ff ff    	mov    -0x13c(%ebp),%eax
  80048c:	89 c2                	mov    %eax,%edx
  80048e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800491:	c1 e0 02             	shl    $0x2,%eax
  800494:	89 c1                	mov    %eax,%ecx
  800496:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800499:	01 c8                	add    %ecx,%eax
  80049b:	39 c2                	cmp    %eax,%edx
  80049d:	74 17                	je     8004b6 <_main+0x45d>
  80049f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004a6:	83 ec 0c             	sub    $0xc,%esp
  8004a9:	68 84 39 80 00       	push   $0x803984
  8004ae:	e8 7f 16 00 00       	call   801b32 <cprintf>
  8004b3:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 1 /*table*/ ;
  8004b6:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  8004bd:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8004c0:	e8 28 28 00 00       	call   802ced <sys_calculate_free_frames>
  8004c5:	29 c3                	sub    %eax,%ebx
  8004c7:	89 d8                	mov    %ebx,%eax
  8004c9:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  8004cc:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8004cf:	83 c0 02             	add    $0x2,%eax
  8004d2:	83 ec 04             	sub    $0x4,%esp
  8004d5:	50                   	push   %eax
  8004d6:	ff 75 c4             	pushl  -0x3c(%ebp)
  8004d9:	ff 75 c0             	pushl  -0x40(%ebp)
  8004dc:	e8 57 fb ff ff       	call   800038 <inRange>
  8004e1:	83 c4 10             	add    $0x10,%esp
  8004e4:	85 c0                	test   %eax,%eax
  8004e6:	75 21                	jne    800509 <_main+0x4b0>
			{is_correct = 0; cprintf("3 Wrong allocation: unexpected number of pages that are allocated in memory! Expected = [%d, %d], Actual = %d\n", expectedNumOfFrames, expectedNumOfFrames+2, actualNumOfFrames);}
  8004e8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004ef:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8004f2:	83 c0 02             	add    $0x2,%eax
  8004f5:	ff 75 c0             	pushl  -0x40(%ebp)
  8004f8:	50                   	push   %eax
  8004f9:	ff 75 c4             	pushl  -0x3c(%ebp)
  8004fc:	68 b8 39 80 00       	push   $0x8039b8
  800501:	e8 2c 16 00 00       	call   801b32 <cprintf>
  800506:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("3 Extra or less pages are allocated in PageFile\n");}
  800509:	e8 2a 28 00 00       	call   802d38 <sys_pf_calculate_allocated_pages>
  80050e:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800511:	74 17                	je     80052a <_main+0x4d1>
  800513:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80051a:	83 ec 0c             	sub    $0xc,%esp
  80051d:	68 28 3a 80 00       	push   $0x803a28
  800522:	e8 0b 16 00 00       	call   801b32 <cprintf>
  800527:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  80052a:	e8 be 27 00 00       	call   802ced <sys_calculate_free_frames>
  80052f:	89 45 cc             	mov    %eax,-0x34(%ebp)
			intArr = (int *) ptr_allocations[2];
  800532:	8b 85 c4 fe ff ff    	mov    -0x13c(%ebp),%eax
  800538:	89 45 98             	mov    %eax,-0x68(%ebp)
			lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
  80053b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80053e:	01 c0                	add    %eax,%eax
  800540:	c1 e8 02             	shr    $0x2,%eax
  800543:	48                   	dec    %eax
  800544:	89 45 94             	mov    %eax,-0x6c(%ebp)
			intArr[0] = minInt;
  800547:	8b 45 98             	mov    -0x68(%ebp),%eax
  80054a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80054d:	89 10                	mov    %edx,(%eax)
			intArr[lastIndexOfInt] = maxInt;
  80054f:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800552:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800559:	8b 45 98             	mov    -0x68(%ebp),%eax
  80055c:	01 c2                	add    %eax,%edx
  80055e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800561:	89 02                	mov    %eax,(%edx)
			expectedNumOfFrames = 1 ;
  800563:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  80056a:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  80056d:	e8 7b 27 00 00       	call   802ced <sys_calculate_free_frames>
  800572:	29 c3                	sub    %eax,%ebx
  800574:	89 d8                	mov    %ebx,%eax
  800576:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  800579:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80057c:	83 c0 02             	add    $0x2,%eax
  80057f:	83 ec 04             	sub    $0x4,%esp
  800582:	50                   	push   %eax
  800583:	ff 75 c4             	pushl  -0x3c(%ebp)
  800586:	ff 75 c0             	pushl  -0x40(%ebp)
  800589:	e8 aa fa ff ff       	call   800038 <inRange>
  80058e:	83 c4 10             	add    $0x10,%esp
  800591:	85 c0                	test   %eax,%eax
  800593:	75 1d                	jne    8005b2 <_main+0x559>
			{ is_correct = 0; cprintf("3 Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);}
  800595:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80059c:	83 ec 04             	sub    $0x4,%esp
  80059f:	ff 75 c0             	pushl  -0x40(%ebp)
  8005a2:	ff 75 c4             	pushl  -0x3c(%ebp)
  8005a5:	68 5c 3a 80 00       	push   $0x803a5c
  8005aa:	e8 83 15 00 00       	call   801b32 <cprintf>
  8005af:	83 c4 10             	add    $0x10,%esp
			uint32 expectedVAs[2] = { ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE)} ;
  8005b2:	8b 45 98             	mov    -0x68(%ebp),%eax
  8005b5:	89 45 90             	mov    %eax,-0x70(%ebp)
  8005b8:	8b 45 90             	mov    -0x70(%ebp),%eax
  8005bb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005c0:	89 85 a4 fe ff ff    	mov    %eax,-0x15c(%ebp)
  8005c6:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8005c9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005d0:	8b 45 98             	mov    -0x68(%ebp),%eax
  8005d3:	01 d0                	add    %edx,%eax
  8005d5:	89 45 8c             	mov    %eax,-0x74(%ebp)
  8005d8:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8005db:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005e0:	89 85 a8 fe ff ff    	mov    %eax,-0x158(%ebp)
			found = sys_check_WS_list(expectedVAs, 2, 0, 2);
  8005e6:	6a 02                	push   $0x2
  8005e8:	6a 00                	push   $0x0
  8005ea:	6a 02                	push   $0x2
  8005ec:	8d 85 a4 fe ff ff    	lea    -0x15c(%ebp),%eax
  8005f2:	50                   	push   %eax
  8005f3:	e8 b7 2a 00 00       	call   8030af <sys_check_WS_list>
  8005f8:	83 c4 10             	add    $0x10,%esp
  8005fb:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("3 malloc: page is not added to WS\n");}
  8005fe:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  800602:	74 17                	je     80061b <_main+0x5c2>
  800604:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80060b:	83 ec 0c             	sub    $0xc,%esp
  80060e:	68 dc 3a 80 00       	push   $0x803adc
  800613:	e8 1a 15 00 00       	call   801b32 <cprintf>
  800618:	83 c4 10             	add    $0x10,%esp
		}

		//3 KB
		{
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80061b:	e8 18 27 00 00       	call   802d38 <sys_pf_calculate_allocated_pages>
  800620:	89 45 c8             	mov    %eax,-0x38(%ebp)
			ptr_allocations[3] = malloc(3*kilo);
  800623:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800626:	89 c2                	mov    %eax,%edx
  800628:	01 d2                	add    %edx,%edx
  80062a:	01 d0                	add    %edx,%eax
  80062c:	83 ec 0c             	sub    $0xc,%esp
  80062f:	50                   	push   %eax
  800630:	e8 bf 24 00 00       	call   802af4 <malloc>
  800635:	83 c4 10             	add    $0x10,%esp
  800638:	89 85 c8 fe ff ff    	mov    %eax,-0x138(%ebp)
			if ((uint32) ptr_allocations[3] != (pagealloc_start + 4*Mega + 4*kilo)) { is_correct = 0; cprintf("4 Wrong start address for the allocated space... \n");}
  80063e:	8b 85 c8 fe ff ff    	mov    -0x138(%ebp),%eax
  800644:	89 c2                	mov    %eax,%edx
  800646:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800649:	c1 e0 02             	shl    $0x2,%eax
  80064c:	89 c1                	mov    %eax,%ecx
  80064e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800651:	c1 e0 02             	shl    $0x2,%eax
  800654:	01 c1                	add    %eax,%ecx
  800656:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800659:	01 c8                	add    %ecx,%eax
  80065b:	39 c2                	cmp    %eax,%edx
  80065d:	74 17                	je     800676 <_main+0x61d>
  80065f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800666:	83 ec 0c             	sub    $0xc,%esp
  800669:	68 00 3b 80 00       	push   $0x803b00
  80066e:	e8 bf 14 00 00       	call   801b32 <cprintf>
  800673:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("4 Extra or less pages are allocated in PageFile\n");}
  800676:	e8 bd 26 00 00       	call   802d38 <sys_pf_calculate_allocated_pages>
  80067b:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80067e:	74 17                	je     800697 <_main+0x63e>
  800680:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800687:	83 ec 0c             	sub    $0xc,%esp
  80068a:	68 34 3b 80 00       	push   $0x803b34
  80068f:	e8 9e 14 00 00       	call   801b32 <cprintf>
  800694:	83 c4 10             	add    $0x10,%esp
		}
		//7 KB
		{
			freeFrames = sys_calculate_free_frames() ;
  800697:	e8 51 26 00 00       	call   802ced <sys_calculate_free_frames>
  80069c:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80069f:	e8 94 26 00 00       	call   802d38 <sys_pf_calculate_allocated_pages>
  8006a4:	89 45 c8             	mov    %eax,-0x38(%ebp)
			ptr_allocations[4] = malloc(7*kilo);
  8006a7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8006aa:	89 d0                	mov    %edx,%eax
  8006ac:	01 c0                	add    %eax,%eax
  8006ae:	01 d0                	add    %edx,%eax
  8006b0:	01 c0                	add    %eax,%eax
  8006b2:	01 d0                	add    %edx,%eax
  8006b4:	83 ec 0c             	sub    $0xc,%esp
  8006b7:	50                   	push   %eax
  8006b8:	e8 37 24 00 00       	call   802af4 <malloc>
  8006bd:	83 c4 10             	add    $0x10,%esp
  8006c0:	89 85 cc fe ff ff    	mov    %eax,-0x134(%ebp)
			if ((uint32) ptr_allocations[4] != (pagealloc_start + 4*Mega + 8*kilo)) { is_correct = 0; cprintf("5 Wrong start address for the allocated space... \n");}
  8006c6:	8b 85 cc fe ff ff    	mov    -0x134(%ebp),%eax
  8006cc:	89 c2                	mov    %eax,%edx
  8006ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8006d1:	c1 e0 02             	shl    $0x2,%eax
  8006d4:	89 c1                	mov    %eax,%ecx
  8006d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006d9:	c1 e0 03             	shl    $0x3,%eax
  8006dc:	01 c1                	add    %eax,%ecx
  8006de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8006e1:	01 c8                	add    %ecx,%eax
  8006e3:	39 c2                	cmp    %eax,%edx
  8006e5:	74 17                	je     8006fe <_main+0x6a5>
  8006e7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8006ee:	83 ec 0c             	sub    $0xc,%esp
  8006f1:	68 68 3b 80 00       	push   $0x803b68
  8006f6:	e8 37 14 00 00       	call   801b32 <cprintf>
  8006fb:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 0 /*no table*/ ;
  8006fe:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  800705:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800708:	e8 e0 25 00 00       	call   802ced <sys_calculate_free_frames>
  80070d:	29 c3                	sub    %eax,%ebx
  80070f:	89 d8                	mov    %ebx,%eax
  800711:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  800714:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800717:	83 c0 02             	add    $0x2,%eax
  80071a:	83 ec 04             	sub    $0x4,%esp
  80071d:	50                   	push   %eax
  80071e:	ff 75 c4             	pushl  -0x3c(%ebp)
  800721:	ff 75 c0             	pushl  -0x40(%ebp)
  800724:	e8 0f f9 ff ff       	call   800038 <inRange>
  800729:	83 c4 10             	add    $0x10,%esp
  80072c:	85 c0                	test   %eax,%eax
  80072e:	75 21                	jne    800751 <_main+0x6f8>
			{is_correct = 0; cprintf("5 Wrong allocation: unexpected number of pages that are allocated in memory! Expected = [%d, %d], Actual = %d\n", expectedNumOfFrames, expectedNumOfFrames+2, actualNumOfFrames);}
  800730:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800737:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80073a:	83 c0 02             	add    $0x2,%eax
  80073d:	ff 75 c0             	pushl  -0x40(%ebp)
  800740:	50                   	push   %eax
  800741:	ff 75 c4             	pushl  -0x3c(%ebp)
  800744:	68 9c 3b 80 00       	push   $0x803b9c
  800749:	e8 e4 13 00 00       	call   801b32 <cprintf>
  80074e:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("5 Extra or less pages are allocated in PageFile\n");}
  800751:	e8 e2 25 00 00       	call   802d38 <sys_pf_calculate_allocated_pages>
  800756:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800759:	74 17                	je     800772 <_main+0x719>
  80075b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800762:	83 ec 0c             	sub    $0xc,%esp
  800765:	68 0c 3c 80 00       	push   $0x803c0c
  80076a:	e8 c3 13 00 00       	call   801b32 <cprintf>
  80076f:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  800772:	e8 76 25 00 00       	call   802ced <sys_calculate_free_frames>
  800777:	89 45 cc             	mov    %eax,-0x34(%ebp)
			structArr = (struct MyStruct *) ptr_allocations[4];
  80077a:	8b 85 cc fe ff ff    	mov    -0x134(%ebp),%eax
  800780:	89 45 88             	mov    %eax,-0x78(%ebp)
			lastIndexOfStruct = (7*kilo)/sizeof(struct MyStruct) - 1;
  800783:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800786:	89 d0                	mov    %edx,%eax
  800788:	01 c0                	add    %eax,%eax
  80078a:	01 d0                	add    %edx,%eax
  80078c:	01 c0                	add    %eax,%eax
  80078e:	01 d0                	add    %edx,%eax
  800790:	c1 e8 03             	shr    $0x3,%eax
  800793:	48                   	dec    %eax
  800794:	89 45 84             	mov    %eax,-0x7c(%ebp)
			structArr[0].a = minByte; structArr[0].b = minShort; structArr[0].c = minInt;
  800797:	8b 45 88             	mov    -0x78(%ebp),%eax
  80079a:	8a 55 e3             	mov    -0x1d(%ebp),%dl
  80079d:	88 10                	mov    %dl,(%eax)
  80079f:	8b 55 88             	mov    -0x78(%ebp),%edx
  8007a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007a5:	66 89 42 02          	mov    %ax,0x2(%edx)
  8007a9:	8b 45 88             	mov    -0x78(%ebp),%eax
  8007ac:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007af:	89 50 04             	mov    %edx,0x4(%eax)
			structArr[lastIndexOfStruct].a = maxByte; structArr[lastIndexOfStruct].b = maxShort; structArr[lastIndexOfStruct].c = maxInt;
  8007b2:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8007b5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8007bc:	8b 45 88             	mov    -0x78(%ebp),%eax
  8007bf:	01 c2                	add    %eax,%edx
  8007c1:	8a 45 e2             	mov    -0x1e(%ebp),%al
  8007c4:	88 02                	mov    %al,(%edx)
  8007c6:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8007c9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8007d0:	8b 45 88             	mov    -0x78(%ebp),%eax
  8007d3:	01 c2                	add    %eax,%edx
  8007d5:	66 8b 45 de          	mov    -0x22(%ebp),%ax
  8007d9:	66 89 42 02          	mov    %ax,0x2(%edx)
  8007dd:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8007e0:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8007e7:	8b 45 88             	mov    -0x78(%ebp),%eax
  8007ea:	01 c2                	add    %eax,%edx
  8007ec:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8007ef:	89 42 04             	mov    %eax,0x4(%edx)
			expectedNumOfFrames = 2 ;
  8007f2:	c7 45 c4 02 00 00 00 	movl   $0x2,-0x3c(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  8007f9:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8007fc:	e8 ec 24 00 00       	call   802ced <sys_calculate_free_frames>
  800801:	29 c3                	sub    %eax,%ebx
  800803:	89 d8                	mov    %ebx,%eax
  800805:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  800808:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80080b:	83 c0 02             	add    $0x2,%eax
  80080e:	83 ec 04             	sub    $0x4,%esp
  800811:	50                   	push   %eax
  800812:	ff 75 c4             	pushl  -0x3c(%ebp)
  800815:	ff 75 c0             	pushl  -0x40(%ebp)
  800818:	e8 1b f8 ff ff       	call   800038 <inRange>
  80081d:	83 c4 10             	add    $0x10,%esp
  800820:	85 c0                	test   %eax,%eax
  800822:	75 1d                	jne    800841 <_main+0x7e8>
			{ is_correct = 0; cprintf("5 Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);}
  800824:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80082b:	83 ec 04             	sub    $0x4,%esp
  80082e:	ff 75 c0             	pushl  -0x40(%ebp)
  800831:	ff 75 c4             	pushl  -0x3c(%ebp)
  800834:	68 40 3c 80 00       	push   $0x803c40
  800839:	e8 f4 12 00 00       	call   801b32 <cprintf>
  80083e:	83 c4 10             	add    $0x10,%esp
			uint32 expectedVAs[2] = { ROUNDDOWN((uint32)(&(structArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE)} ;
  800841:	8b 45 88             	mov    -0x78(%ebp),%eax
  800844:	89 45 80             	mov    %eax,-0x80(%ebp)
  800847:	8b 45 80             	mov    -0x80(%ebp),%eax
  80084a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80084f:	89 85 9c fe ff ff    	mov    %eax,-0x164(%ebp)
  800855:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800858:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80085f:	8b 45 88             	mov    -0x78(%ebp),%eax
  800862:	01 d0                	add    %edx,%eax
  800864:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  80086a:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800870:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800875:	89 85 a0 fe ff ff    	mov    %eax,-0x160(%ebp)
			found = sys_check_WS_list(expectedVAs, 2, 0, 2);
  80087b:	6a 02                	push   $0x2
  80087d:	6a 00                	push   $0x0
  80087f:	6a 02                	push   $0x2
  800881:	8d 85 9c fe ff ff    	lea    -0x164(%ebp),%eax
  800887:	50                   	push   %eax
  800888:	e8 22 28 00 00       	call   8030af <sys_check_WS_list>
  80088d:	83 c4 10             	add    $0x10,%esp
  800890:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("5 malloc: page is not added to WS\n");}
  800893:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  800897:	74 17                	je     8008b0 <_main+0x857>
  800899:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8008a0:	83 ec 0c             	sub    $0xc,%esp
  8008a3:	68 c0 3c 80 00       	push   $0x803cc0
  8008a8:	e8 85 12 00 00       	call   801b32 <cprintf>
  8008ad:	83 c4 10             	add    $0x10,%esp
		}
		//3 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  8008b0:	e8 38 24 00 00       	call   802ced <sys_calculate_free_frames>
  8008b5:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8008b8:	e8 7b 24 00 00       	call   802d38 <sys_pf_calculate_allocated_pages>
  8008bd:	89 45 c8             	mov    %eax,-0x38(%ebp)
			ptr_allocations[5] = malloc(3*Mega-kilo);
  8008c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008c3:	89 c2                	mov    %eax,%edx
  8008c5:	01 d2                	add    %edx,%edx
  8008c7:	01 d0                	add    %edx,%eax
  8008c9:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8008cc:	83 ec 0c             	sub    $0xc,%esp
  8008cf:	50                   	push   %eax
  8008d0:	e8 1f 22 00 00       	call   802af4 <malloc>
  8008d5:	83 c4 10             	add    $0x10,%esp
  8008d8:	89 85 d0 fe ff ff    	mov    %eax,-0x130(%ebp)
			if ((uint32) ptr_allocations[5] != (pagealloc_start + 4*Mega + 16*kilo)) { is_correct = 0; cprintf("6 Wrong start address for the allocated space... \n");}
  8008de:	8b 85 d0 fe ff ff    	mov    -0x130(%ebp),%eax
  8008e4:	89 c2                	mov    %eax,%edx
  8008e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008e9:	c1 e0 02             	shl    $0x2,%eax
  8008ec:	89 c1                	mov    %eax,%ecx
  8008ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8008f1:	c1 e0 04             	shl    $0x4,%eax
  8008f4:	01 c1                	add    %eax,%ecx
  8008f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008f9:	01 c8                	add    %ecx,%eax
  8008fb:	39 c2                	cmp    %eax,%edx
  8008fd:	74 17                	je     800916 <_main+0x8bd>
  8008ff:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800906:	83 ec 0c             	sub    $0xc,%esp
  800909:	68 e4 3c 80 00       	push   $0x803ce4
  80090e:	e8 1f 12 00 00       	call   801b32 <cprintf>
  800913:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 0 /*no table*/ ;
  800916:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  80091d:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800920:	e8 c8 23 00 00       	call   802ced <sys_calculate_free_frames>
  800925:	29 c3                	sub    %eax,%ebx
  800927:	89 d8                	mov    %ebx,%eax
  800929:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  80092c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80092f:	83 c0 02             	add    $0x2,%eax
  800932:	83 ec 04             	sub    $0x4,%esp
  800935:	50                   	push   %eax
  800936:	ff 75 c4             	pushl  -0x3c(%ebp)
  800939:	ff 75 c0             	pushl  -0x40(%ebp)
  80093c:	e8 f7 f6 ff ff       	call   800038 <inRange>
  800941:	83 c4 10             	add    $0x10,%esp
  800944:	85 c0                	test   %eax,%eax
  800946:	75 21                	jne    800969 <_main+0x910>
			{is_correct = 0; cprintf("6 Wrong allocation: unexpected number of pages that are allocated in memory! Expected = [%d, %d], Actual = %d\n", expectedNumOfFrames, expectedNumOfFrames+2, actualNumOfFrames);}
  800948:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80094f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800952:	83 c0 02             	add    $0x2,%eax
  800955:	ff 75 c0             	pushl  -0x40(%ebp)
  800958:	50                   	push   %eax
  800959:	ff 75 c4             	pushl  -0x3c(%ebp)
  80095c:	68 18 3d 80 00       	push   $0x803d18
  800961:	e8 cc 11 00 00       	call   801b32 <cprintf>
  800966:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("6 Extra or less pages are allocated in PageFile\n");}
  800969:	e8 ca 23 00 00       	call   802d38 <sys_pf_calculate_allocated_pages>
  80096e:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800971:	74 17                	je     80098a <_main+0x931>
  800973:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80097a:	83 ec 0c             	sub    $0xc,%esp
  80097d:	68 88 3d 80 00       	push   $0x803d88
  800982:	e8 ab 11 00 00       	call   801b32 <cprintf>
  800987:	83 c4 10             	add    $0x10,%esp
		}
		//6 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  80098a:	e8 5e 23 00 00       	call   802ced <sys_calculate_free_frames>
  80098f:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800992:	e8 a1 23 00 00       	call   802d38 <sys_pf_calculate_allocated_pages>
  800997:	89 45 c8             	mov    %eax,-0x38(%ebp)
			ptr_allocations[6] = malloc(6*Mega-kilo);
  80099a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80099d:	89 d0                	mov    %edx,%eax
  80099f:	01 c0                	add    %eax,%eax
  8009a1:	01 d0                	add    %edx,%eax
  8009a3:	01 c0                	add    %eax,%eax
  8009a5:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8009a8:	83 ec 0c             	sub    $0xc,%esp
  8009ab:	50                   	push   %eax
  8009ac:	e8 43 21 00 00       	call   802af4 <malloc>
  8009b1:	83 c4 10             	add    $0x10,%esp
  8009b4:	89 85 d4 fe ff ff    	mov    %eax,-0x12c(%ebp)
			if ((uint32) ptr_allocations[6] != (pagealloc_start + 7*Mega + 16*kilo)) { is_correct = 0; cprintf("7 Wrong start address for the allocated space... \n");}
  8009ba:	8b 85 d4 fe ff ff    	mov    -0x12c(%ebp),%eax
  8009c0:	89 c1                	mov    %eax,%ecx
  8009c2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009c5:	89 d0                	mov    %edx,%eax
  8009c7:	01 c0                	add    %eax,%eax
  8009c9:	01 d0                	add    %edx,%eax
  8009cb:	01 c0                	add    %eax,%eax
  8009cd:	01 d0                	add    %edx,%eax
  8009cf:	89 c2                	mov    %eax,%edx
  8009d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8009d4:	c1 e0 04             	shl    $0x4,%eax
  8009d7:	01 c2                	add    %eax,%edx
  8009d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009dc:	01 d0                	add    %edx,%eax
  8009de:	39 c1                	cmp    %eax,%ecx
  8009e0:	74 17                	je     8009f9 <_main+0x9a0>
  8009e2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8009e9:	83 ec 0c             	sub    $0xc,%esp
  8009ec:	68 bc 3d 80 00       	push   $0x803dbc
  8009f1:	e8 3c 11 00 00       	call   801b32 <cprintf>
  8009f6:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 2 /*table*/ ;
  8009f9:	c7 45 c4 02 00 00 00 	movl   $0x2,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  800a00:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800a03:	e8 e5 22 00 00       	call   802ced <sys_calculate_free_frames>
  800a08:	29 c3                	sub    %eax,%ebx
  800a0a:	89 d8                	mov    %ebx,%eax
  800a0c:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  800a0f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800a12:	83 c0 02             	add    $0x2,%eax
  800a15:	83 ec 04             	sub    $0x4,%esp
  800a18:	50                   	push   %eax
  800a19:	ff 75 c4             	pushl  -0x3c(%ebp)
  800a1c:	ff 75 c0             	pushl  -0x40(%ebp)
  800a1f:	e8 14 f6 ff ff       	call   800038 <inRange>
  800a24:	83 c4 10             	add    $0x10,%esp
  800a27:	85 c0                	test   %eax,%eax
  800a29:	75 21                	jne    800a4c <_main+0x9f3>
			{is_correct = 0; cprintf("7 Wrong allocation: unexpected number of pages that are allocated in memory! Expected = [%d, %d], Actual = %d\n", expectedNumOfFrames, expectedNumOfFrames+2, actualNumOfFrames);}
  800a2b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800a32:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800a35:	83 c0 02             	add    $0x2,%eax
  800a38:	ff 75 c0             	pushl  -0x40(%ebp)
  800a3b:	50                   	push   %eax
  800a3c:	ff 75 c4             	pushl  -0x3c(%ebp)
  800a3f:	68 f0 3d 80 00       	push   $0x803df0
  800a44:	e8 e9 10 00 00       	call   801b32 <cprintf>
  800a49:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("7 Extra or less pages are allocated in PageFile\n");}
  800a4c:	e8 e7 22 00 00       	call   802d38 <sys_pf_calculate_allocated_pages>
  800a51:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800a54:	74 17                	je     800a6d <_main+0xa14>
  800a56:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800a5d:	83 ec 0c             	sub    $0xc,%esp
  800a60:	68 60 3e 80 00       	push   $0x803e60
  800a65:	e8 c8 10 00 00       	call   801b32 <cprintf>
  800a6a:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  800a6d:	e8 7b 22 00 00       	call   802ced <sys_calculate_free_frames>
  800a72:	89 45 cc             	mov    %eax,-0x34(%ebp)
			lastIndexOfByte2 = (6*Mega-kilo)/sizeof(char) - 1;
  800a75:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a78:	89 d0                	mov    %edx,%eax
  800a7a:	01 c0                	add    %eax,%eax
  800a7c:	01 d0                	add    %edx,%eax
  800a7e:	01 c0                	add    %eax,%eax
  800a80:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800a83:	48                   	dec    %eax
  800a84:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
			byteArr2 = (char *) ptr_allocations[6];
  800a8a:	8b 85 d4 fe ff ff    	mov    -0x12c(%ebp),%eax
  800a90:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
			byteArr2[0] = minByte ;
  800a96:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800a9c:	8a 55 e3             	mov    -0x1d(%ebp),%dl
  800a9f:	88 10                	mov    %dl,(%eax)
			byteArr2[lastIndexOfByte2 / 2] = maxByte / 2;
  800aa1:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800aa7:	89 c2                	mov    %eax,%edx
  800aa9:	c1 ea 1f             	shr    $0x1f,%edx
  800aac:	01 d0                	add    %edx,%eax
  800aae:	d1 f8                	sar    %eax
  800ab0:	89 c2                	mov    %eax,%edx
  800ab2:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800ab8:	01 c2                	add    %eax,%edx
  800aba:	8a 45 e2             	mov    -0x1e(%ebp),%al
  800abd:	88 c1                	mov    %al,%cl
  800abf:	c0 e9 07             	shr    $0x7,%cl
  800ac2:	01 c8                	add    %ecx,%eax
  800ac4:	d0 f8                	sar    %al
  800ac6:	88 02                	mov    %al,(%edx)
			byteArr2[lastIndexOfByte2] = maxByte ;
  800ac8:	8b 95 78 ff ff ff    	mov    -0x88(%ebp),%edx
  800ace:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800ad4:	01 c2                	add    %eax,%edx
  800ad6:	8a 45 e2             	mov    -0x1e(%ebp),%al
  800ad9:	88 02                	mov    %al,(%edx)
			expectedNumOfFrames = 3 ;
  800adb:	c7 45 c4 03 00 00 00 	movl   $0x3,-0x3c(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  800ae2:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800ae5:	e8 03 22 00 00       	call   802ced <sys_calculate_free_frames>
  800aea:	29 c3                	sub    %eax,%ebx
  800aec:	89 d8                	mov    %ebx,%eax
  800aee:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  800af1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800af4:	83 c0 02             	add    $0x2,%eax
  800af7:	83 ec 04             	sub    $0x4,%esp
  800afa:	50                   	push   %eax
  800afb:	ff 75 c4             	pushl  -0x3c(%ebp)
  800afe:	ff 75 c0             	pushl  -0x40(%ebp)
  800b01:	e8 32 f5 ff ff       	call   800038 <inRange>
  800b06:	83 c4 10             	add    $0x10,%esp
  800b09:	85 c0                	test   %eax,%eax
  800b0b:	75 1d                	jne    800b2a <_main+0xad1>
			{ is_correct = 0; cprintf("7 Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);}
  800b0d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800b14:	83 ec 04             	sub    $0x4,%esp
  800b17:	ff 75 c0             	pushl  -0x40(%ebp)
  800b1a:	ff 75 c4             	pushl  -0x3c(%ebp)
  800b1d:	68 94 3e 80 00       	push   $0x803e94
  800b22:	e8 0b 10 00 00       	call   801b32 <cprintf>
  800b27:	83 c4 10             	add    $0x10,%esp
			uint32 expectedVAs[3] = { ROUNDDOWN((uint32)(&(byteArr2[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE)} ;
  800b2a:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800b30:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
  800b36:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800b3c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b41:	89 85 90 fe ff ff    	mov    %eax,-0x170(%ebp)
  800b47:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800b4d:	89 c2                	mov    %eax,%edx
  800b4f:	c1 ea 1f             	shr    $0x1f,%edx
  800b52:	01 d0                	add    %edx,%eax
  800b54:	d1 f8                	sar    %eax
  800b56:	89 c2                	mov    %eax,%edx
  800b58:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800b5e:	01 d0                	add    %edx,%eax
  800b60:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
  800b66:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800b6c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b71:	89 85 94 fe ff ff    	mov    %eax,-0x16c(%ebp)
  800b77:	8b 95 78 ff ff ff    	mov    -0x88(%ebp),%edx
  800b7d:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800b83:	01 d0                	add    %edx,%eax
  800b85:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
  800b8b:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  800b91:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b96:	89 85 98 fe ff ff    	mov    %eax,-0x168(%ebp)
			found = sys_check_WS_list(expectedVAs, 3, 0, 2);
  800b9c:	6a 02                	push   $0x2
  800b9e:	6a 00                	push   $0x0
  800ba0:	6a 03                	push   $0x3
  800ba2:	8d 85 90 fe ff ff    	lea    -0x170(%ebp),%eax
  800ba8:	50                   	push   %eax
  800ba9:	e8 01 25 00 00       	call   8030af <sys_check_WS_list>
  800bae:	83 c4 10             	add    $0x10,%esp
  800bb1:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("7 malloc: page is not added to WS\n");}
  800bb4:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  800bb8:	74 17                	je     800bd1 <_main+0xb78>
  800bba:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800bc1:	83 ec 0c             	sub    $0xc,%esp
  800bc4:	68 14 3f 80 00       	push   $0x803f14
  800bc9:	e8 64 0f 00 00       	call   801b32 <cprintf>
  800bce:	83 c4 10             	add    $0x10,%esp
		}
		//14 KB
		{
			freeFrames = sys_calculate_free_frames() ;
  800bd1:	e8 17 21 00 00       	call   802ced <sys_calculate_free_frames>
  800bd6:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800bd9:	e8 5a 21 00 00       	call   802d38 <sys_pf_calculate_allocated_pages>
  800bde:	89 45 c8             	mov    %eax,-0x38(%ebp)
			ptr_allocations[7] = malloc(14*kilo);
  800be1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800be4:	89 d0                	mov    %edx,%eax
  800be6:	01 c0                	add    %eax,%eax
  800be8:	01 d0                	add    %edx,%eax
  800bea:	01 c0                	add    %eax,%eax
  800bec:	01 d0                	add    %edx,%eax
  800bee:	01 c0                	add    %eax,%eax
  800bf0:	83 ec 0c             	sub    $0xc,%esp
  800bf3:	50                   	push   %eax
  800bf4:	e8 fb 1e 00 00       	call   802af4 <malloc>
  800bf9:	83 c4 10             	add    $0x10,%esp
  800bfc:	89 85 d8 fe ff ff    	mov    %eax,-0x128(%ebp)
			if ((uint32) ptr_allocations[7] != (pagealloc_start + 13*Mega + 16*kilo)) { is_correct = 0; cprintf("8 Wrong start address for the allocated space... \n");}
  800c02:	8b 85 d8 fe ff ff    	mov    -0x128(%ebp),%eax
  800c08:	89 c1                	mov    %eax,%ecx
  800c0a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800c0d:	89 d0                	mov    %edx,%eax
  800c0f:	01 c0                	add    %eax,%eax
  800c11:	01 d0                	add    %edx,%eax
  800c13:	c1 e0 02             	shl    $0x2,%eax
  800c16:	01 d0                	add    %edx,%eax
  800c18:	89 c2                	mov    %eax,%edx
  800c1a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800c1d:	c1 e0 04             	shl    $0x4,%eax
  800c20:	01 c2                	add    %eax,%edx
  800c22:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c25:	01 d0                	add    %edx,%eax
  800c27:	39 c1                	cmp    %eax,%ecx
  800c29:	74 17                	je     800c42 <_main+0xbe9>
  800c2b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800c32:	83 ec 0c             	sub    $0xc,%esp
  800c35:	68 38 3f 80 00       	push   $0x803f38
  800c3a:	e8 f3 0e 00 00       	call   801b32 <cprintf>
  800c3f:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 0 /*table*/ ;
  800c42:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  800c49:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800c4c:	e8 9c 20 00 00       	call   802ced <sys_calculate_free_frames>
  800c51:	29 c3                	sub    %eax,%ebx
  800c53:	89 d8                	mov    %ebx,%eax
  800c55:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  800c58:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800c5b:	83 c0 02             	add    $0x2,%eax
  800c5e:	83 ec 04             	sub    $0x4,%esp
  800c61:	50                   	push   %eax
  800c62:	ff 75 c4             	pushl  -0x3c(%ebp)
  800c65:	ff 75 c0             	pushl  -0x40(%ebp)
  800c68:	e8 cb f3 ff ff       	call   800038 <inRange>
  800c6d:	83 c4 10             	add    $0x10,%esp
  800c70:	85 c0                	test   %eax,%eax
  800c72:	75 21                	jne    800c95 <_main+0xc3c>
			{is_correct = 0; cprintf("8 Wrong allocation: unexpected number of pages that are allocated in memory! Expected = [%d, %d], Actual = %d\n", expectedNumOfFrames, expectedNumOfFrames+2, actualNumOfFrames);}
  800c74:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800c7b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800c7e:	83 c0 02             	add    $0x2,%eax
  800c81:	ff 75 c0             	pushl  -0x40(%ebp)
  800c84:	50                   	push   %eax
  800c85:	ff 75 c4             	pushl  -0x3c(%ebp)
  800c88:	68 6c 3f 80 00       	push   $0x803f6c
  800c8d:	e8 a0 0e 00 00       	call   801b32 <cprintf>
  800c92:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("8 Extra or less pages are allocated in PageFile\n");}
  800c95:	e8 9e 20 00 00       	call   802d38 <sys_pf_calculate_allocated_pages>
  800c9a:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800c9d:	74 17                	je     800cb6 <_main+0xc5d>
  800c9f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ca6:	83 ec 0c             	sub    $0xc,%esp
  800ca9:	68 dc 3f 80 00       	push   $0x803fdc
  800cae:	e8 7f 0e 00 00       	call   801b32 <cprintf>
  800cb3:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  800cb6:	e8 32 20 00 00       	call   802ced <sys_calculate_free_frames>
  800cbb:	89 45 cc             	mov    %eax,-0x34(%ebp)
			shortArr2 = (short *) ptr_allocations[7];
  800cbe:	8b 85 d8 fe ff ff    	mov    -0x128(%ebp),%eax
  800cc4:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
			lastIndexOfShort2 = (14*kilo)/sizeof(short) - 1;
  800cca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800ccd:	89 d0                	mov    %edx,%eax
  800ccf:	01 c0                	add    %eax,%eax
  800cd1:	01 d0                	add    %edx,%eax
  800cd3:	01 c0                	add    %eax,%eax
  800cd5:	01 d0                	add    %edx,%eax
  800cd7:	01 c0                	add    %eax,%eax
  800cd9:	d1 e8                	shr    %eax
  800cdb:	48                   	dec    %eax
  800cdc:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
			shortArr2[0] = minShort;
  800ce2:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  800ce8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ceb:	66 89 02             	mov    %ax,(%edx)
			shortArr2[lastIndexOfShort2 / 2] = maxShort / 2;
  800cee:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800cf4:	89 c2                	mov    %eax,%edx
  800cf6:	c1 ea 1f             	shr    $0x1f,%edx
  800cf9:	01 d0                	add    %edx,%eax
  800cfb:	d1 f8                	sar    %eax
  800cfd:	01 c0                	add    %eax,%eax
  800cff:	89 c2                	mov    %eax,%edx
  800d01:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  800d07:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800d0a:	66 8b 45 de          	mov    -0x22(%ebp),%ax
  800d0e:	89 c2                	mov    %eax,%edx
  800d10:	66 c1 ea 0f          	shr    $0xf,%dx
  800d14:	01 d0                	add    %edx,%eax
  800d16:	66 d1 f8             	sar    %ax
  800d19:	66 89 01             	mov    %ax,(%ecx)
			shortArr2[lastIndexOfShort2] = maxShort;
  800d1c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800d22:	01 c0                	add    %eax,%eax
  800d24:	89 c2                	mov    %eax,%edx
  800d26:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  800d2c:	01 c2                	add    %eax,%edx
  800d2e:	66 8b 45 de          	mov    -0x22(%ebp),%ax
  800d32:	66 89 02             	mov    %ax,(%edx)
			expectedNumOfFrames = 3 ;
  800d35:	c7 45 c4 03 00 00 00 	movl   $0x3,-0x3c(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  800d3c:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800d3f:	e8 a9 1f 00 00       	call   802ced <sys_calculate_free_frames>
  800d44:	29 c3                	sub    %eax,%ebx
  800d46:	89 d8                	mov    %ebx,%eax
  800d48:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  800d4b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800d4e:	83 c0 02             	add    $0x2,%eax
  800d51:	83 ec 04             	sub    $0x4,%esp
  800d54:	50                   	push   %eax
  800d55:	ff 75 c4             	pushl  -0x3c(%ebp)
  800d58:	ff 75 c0             	pushl  -0x40(%ebp)
  800d5b:	e8 d8 f2 ff ff       	call   800038 <inRange>
  800d60:	83 c4 10             	add    $0x10,%esp
  800d63:	85 c0                	test   %eax,%eax
  800d65:	75 1d                	jne    800d84 <_main+0xd2b>
			{ is_correct = 0; cprintf("8 Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);}
  800d67:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800d6e:	83 ec 04             	sub    $0x4,%esp
  800d71:	ff 75 c0             	pushl  -0x40(%ebp)
  800d74:	ff 75 c4             	pushl  -0x3c(%ebp)
  800d77:	68 10 40 80 00       	push   $0x804010
  800d7c:	e8 b1 0d 00 00       	call   801b32 <cprintf>
  800d81:	83 c4 10             	add    $0x10,%esp
			uint32 expectedVAs[3] = { ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2/2])), PAGE_SIZE), ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2])), PAGE_SIZE)} ;
  800d84:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  800d8a:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  800d90:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800d96:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d9b:	89 85 84 fe ff ff    	mov    %eax,-0x17c(%ebp)
  800da1:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800da7:	89 c2                	mov    %eax,%edx
  800da9:	c1 ea 1f             	shr    $0x1f,%edx
  800dac:	01 d0                	add    %edx,%eax
  800dae:	d1 f8                	sar    %eax
  800db0:	01 c0                	add    %eax,%eax
  800db2:	89 c2                	mov    %eax,%edx
  800db4:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  800dba:	01 d0                	add    %edx,%eax
  800dbc:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
  800dc2:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800dc8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800dcd:	89 85 88 fe ff ff    	mov    %eax,-0x178(%ebp)
  800dd3:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800dd9:	01 c0                	add    %eax,%eax
  800ddb:	89 c2                	mov    %eax,%edx
  800ddd:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  800de3:	01 d0                	add    %edx,%eax
  800de5:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
  800deb:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  800df1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800df6:	89 85 8c fe ff ff    	mov    %eax,-0x174(%ebp)
			found = sys_check_WS_list(expectedVAs, 3, 0, 2);
  800dfc:	6a 02                	push   $0x2
  800dfe:	6a 00                	push   $0x0
  800e00:	6a 03                	push   $0x3
  800e02:	8d 85 84 fe ff ff    	lea    -0x17c(%ebp),%eax
  800e08:	50                   	push   %eax
  800e09:	e8 a1 22 00 00       	call   8030af <sys_check_WS_list>
  800e0e:	83 c4 10             	add    $0x10,%esp
  800e11:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("8 malloc: page is not added to WS\n");}
  800e14:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  800e18:	74 17                	je     800e31 <_main+0xdd8>
  800e1a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800e21:	83 ec 0c             	sub    $0xc,%esp
  800e24:	68 90 40 80 00       	push   $0x804090
  800e29:	e8 04 0d 00 00       	call   801b32 <cprintf>
  800e2e:	83 c4 10             	add    $0x10,%esp
		}
	}
	uint32 pagealloc_end = pagealloc_start + 13*Mega + 32*kilo ;
  800e31:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800e34:	89 d0                	mov    %edx,%eax
  800e36:	01 c0                	add    %eax,%eax
  800e38:	01 d0                	add    %edx,%eax
  800e3a:	c1 e0 02             	shl    $0x2,%eax
  800e3d:	01 d0                	add    %edx,%eax
  800e3f:	89 c2                	mov    %eax,%edx
  800e41:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800e44:	c1 e0 05             	shl    $0x5,%eax
  800e47:	01 c2                	add    %eax,%edx
  800e49:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e4c:	01 d0                	add    %edx,%eax
  800e4e:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)


	is_correct = 1;
  800e54:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	//FREE ALL
	cprintf("\n%~[2] Free all the allocated spaces from PAGE ALLOCATOR \[70%]\n");
  800e5b:	83 ec 0c             	sub    $0xc,%esp
  800e5e:	68 b4 40 80 00       	push   $0x8040b4
  800e63:	e8 ca 0c 00 00       	call   801b32 <cprintf>
  800e68:	83 c4 10             	add    $0x10,%esp
	{
		//Free 1st 2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  800e6b:	e8 7d 1e 00 00       	call   802ced <sys_calculate_free_frames>
  800e70:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800e73:	e8 c0 1e 00 00       	call   802d38 <sys_pf_calculate_allocated_pages>
  800e78:	89 45 c8             	mov    %eax,-0x38(%ebp)
			free(ptr_allocations[0]);
  800e7b:	8b 85 bc fe ff ff    	mov    -0x144(%ebp),%eax
  800e81:	83 ec 0c             	sub    $0xc,%esp
  800e84:	50                   	push   %eax
  800e85:	e8 98 1c 00 00       	call   802b22 <free>
  800e8a:	83 c4 10             	add    $0x10,%esp

			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) { is_correct = 0; cprintf("9 Wrong free: Extra or less pages are removed from PageFile\n");}
  800e8d:	e8 a6 1e 00 00       	call   802d38 <sys_pf_calculate_allocated_pages>
  800e92:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800e95:	74 17                	je     800eae <_main+0xe55>
  800e97:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800e9e:	83 ec 0c             	sub    $0xc,%esp
  800ea1:	68 f4 40 80 00       	push   $0x8040f4
  800ea6:	e8 87 0c 00 00       	call   801b32 <cprintf>
  800eab:	83 c4 10             	add    $0x10,%esp
			if ((sys_calculate_free_frames() - freeFrames) != 2 ) { is_correct = 0; cprintf("9 Wrong free: WS pages in memory and/or page tables are not freed correctly\n");}
  800eae:	e8 3a 1e 00 00       	call   802ced <sys_calculate_free_frames>
  800eb3:	89 c2                	mov    %eax,%edx
  800eb5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800eb8:	29 c2                	sub    %eax,%edx
  800eba:	89 d0                	mov    %edx,%eax
  800ebc:	83 f8 02             	cmp    $0x2,%eax
  800ebf:	74 17                	je     800ed8 <_main+0xe7f>
  800ec1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ec8:	83 ec 0c             	sub    $0xc,%esp
  800ecb:	68 34 41 80 00       	push   $0x804134
  800ed0:	e8 5d 0c 00 00       	call   801b32 <cprintf>
  800ed5:	83 c4 10             	add    $0x10,%esp
			uint32 notExpectedVAs[2] = { ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE)} ;
  800ed8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800edb:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
  800ee1:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  800ee7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800eec:	89 85 7c fe ff ff    	mov    %eax,-0x184(%ebp)
  800ef2:	8b 55 bc             	mov    -0x44(%ebp),%edx
  800ef5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800ef8:	01 d0                	add    %edx,%eax
  800efa:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)
  800f00:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  800f06:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f0b:	89 85 80 fe ff ff    	mov    %eax,-0x180(%ebp)
			chk = sys_check_WS_list(notExpectedVAs, 2, 0, 3);
  800f11:	6a 03                	push   $0x3
  800f13:	6a 00                	push   $0x0
  800f15:	6a 02                	push   $0x2
  800f17:	8d 85 7c fe ff ff    	lea    -0x184(%ebp),%eax
  800f1d:	50                   	push   %eax
  800f1e:	e8 8c 21 00 00       	call   8030af <sys_check_WS_list>
  800f23:	83 c4 10             	add    $0x10,%esp
  800f26:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
			if (chk != 1) { is_correct = 0; cprintf("9 free: page is not removed from WS\n");}
  800f2c:	83 bd 44 ff ff ff 01 	cmpl   $0x1,-0xbc(%ebp)
  800f33:	74 17                	je     800f4c <_main+0xef3>
  800f35:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800f3c:	83 ec 0c             	sub    $0xc,%esp
  800f3f:	68 84 41 80 00       	push   $0x804184
  800f44:	e8 e9 0b 00 00       	call   801b32 <cprintf>
  800f49:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)
  800f4c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800f50:	74 04                	je     800f56 <_main+0xefd>
		{
			eval += 10;
  800f52:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		}

		is_correct = 1;
  800f56:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		//Free 2nd 2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  800f5d:	e8 8b 1d 00 00       	call   802ced <sys_calculate_free_frames>
  800f62:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800f65:	e8 ce 1d 00 00       	call   802d38 <sys_pf_calculate_allocated_pages>
  800f6a:	89 45 c8             	mov    %eax,-0x38(%ebp)
			free(ptr_allocations[1]);
  800f6d:	8b 85 c0 fe ff ff    	mov    -0x140(%ebp),%eax
  800f73:	83 ec 0c             	sub    $0xc,%esp
  800f76:	50                   	push   %eax
  800f77:	e8 a6 1b 00 00       	call   802b22 <free>
  800f7c:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0)
  800f7f:	e8 b4 1d 00 00       	call   802d38 <sys_pf_calculate_allocated_pages>
  800f84:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800f87:	74 17                	je     800fa0 <_main+0xf47>
			{ is_correct = 0; cprintf("10 Wrong free: Extra or less pages are removed from PageFile\n");}
  800f89:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800f90:	83 ec 0c             	sub    $0xc,%esp
  800f93:	68 ac 41 80 00       	push   $0x8041ac
  800f98:	e8 95 0b 00 00       	call   801b32 <cprintf>
  800f9d:	83 c4 10             	add    $0x10,%esp
			if ((sys_calculate_free_frames() - freeFrames) != 2 /*we don't remove free tables anymore*/)
  800fa0:	e8 48 1d 00 00       	call   802ced <sys_calculate_free_frames>
  800fa5:	89 c2                	mov    %eax,%edx
  800fa7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800faa:	29 c2                	sub    %eax,%edx
  800fac:	89 d0                	mov    %edx,%eax
  800fae:	83 f8 02             	cmp    $0x2,%eax
  800fb1:	74 17                	je     800fca <_main+0xf71>
			{ is_correct = 0; cprintf("10 Wrong free: WS pages in memory and/or page tables are not freed correctly\n");}
  800fb3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800fba:	83 ec 0c             	sub    $0xc,%esp
  800fbd:	68 ec 41 80 00       	push   $0x8041ec
  800fc2:	e8 6b 0b 00 00       	call   801b32 <cprintf>
  800fc7:	83 c4 10             	add    $0x10,%esp
			uint32 notExpectedVAs[2] = { ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE)} ;
  800fca:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800fcd:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
  800fd3:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800fd9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800fde:	89 85 74 fe ff ff    	mov    %eax,-0x18c(%ebp)
  800fe4:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800fe7:	01 c0                	add    %eax,%eax
  800fe9:	89 c2                	mov    %eax,%edx
  800feb:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800fee:	01 d0                	add    %edx,%eax
  800ff0:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
  800ff6:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800ffc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801001:	89 85 78 fe ff ff    	mov    %eax,-0x188(%ebp)
			chk = sys_check_WS_list(notExpectedVAs, 2, 0, 3);
  801007:	6a 03                	push   $0x3
  801009:	6a 00                	push   $0x0
  80100b:	6a 02                	push   $0x2
  80100d:	8d 85 74 fe ff ff    	lea    -0x18c(%ebp),%eax
  801013:	50                   	push   %eax
  801014:	e8 96 20 00 00       	call   8030af <sys_check_WS_list>
  801019:	83 c4 10             	add    $0x10,%esp
  80101c:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
			if (chk != 1) { is_correct = 0; cprintf("10 free: page is not removed from WS\n");}
  801022:	83 bd 44 ff ff ff 01 	cmpl   $0x1,-0xbc(%ebp)
  801029:	74 17                	je     801042 <_main+0xfe9>
  80102b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801032:	83 ec 0c             	sub    $0xc,%esp
  801035:	68 3c 42 80 00       	push   $0x80423c
  80103a:	e8 f3 0a 00 00       	call   801b32 <cprintf>
  80103f:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)
  801042:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801046:	74 04                	je     80104c <_main+0xff3>
		{
			eval += 10;
  801048:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		}

		is_correct = 1;
  80104c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		//Free 6 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  801053:	e8 95 1c 00 00       	call   802ced <sys_calculate_free_frames>
  801058:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80105b:	e8 d8 1c 00 00       	call   802d38 <sys_pf_calculate_allocated_pages>
  801060:	89 45 c8             	mov    %eax,-0x38(%ebp)
			free(ptr_allocations[6]);
  801063:	8b 85 d4 fe ff ff    	mov    -0x12c(%ebp),%eax
  801069:	83 ec 0c             	sub    $0xc,%esp
  80106c:	50                   	push   %eax
  80106d:	e8 b0 1a 00 00       	call   802b22 <free>
  801072:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0)
  801075:	e8 be 1c 00 00       	call   802d38 <sys_pf_calculate_allocated_pages>
  80107a:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80107d:	74 17                	je     801096 <_main+0x103d>
			{ is_correct = 0; cprintf("11 Wrong free: Extra or less pages are removed from PageFile\n");}
  80107f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801086:	83 ec 0c             	sub    $0xc,%esp
  801089:	68 64 42 80 00       	push   $0x804264
  80108e:	e8 9f 0a 00 00       	call   801b32 <cprintf>
  801093:	83 c4 10             	add    $0x10,%esp
			if ((sys_calculate_free_frames() - freeFrames) != 3 /*+ 1*/)
  801096:	e8 52 1c 00 00       	call   802ced <sys_calculate_free_frames>
  80109b:	89 c2                	mov    %eax,%edx
  80109d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8010a0:	29 c2                	sub    %eax,%edx
  8010a2:	89 d0                	mov    %edx,%eax
  8010a4:	83 f8 03             	cmp    $0x3,%eax
  8010a7:	74 17                	je     8010c0 <_main+0x1067>
			{ is_correct = 0; cprintf("11 Wrong free: WS pages in memory and/or page tables are not freed correctly\n");}
  8010a9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8010b0:	83 ec 0c             	sub    $0xc,%esp
  8010b3:	68 a4 42 80 00       	push   $0x8042a4
  8010b8:	e8 75 0a 00 00       	call   801b32 <cprintf>
  8010bd:	83 c4 10             	add    $0x10,%esp
			uint32 notExpectedVAs[3] = { ROUNDDOWN((uint32)(&(byteArr2[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE)} ;
  8010c0:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8010c6:	89 85 38 ff ff ff    	mov    %eax,-0xc8(%ebp)
  8010cc:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
  8010d2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8010d7:	89 85 68 fe ff ff    	mov    %eax,-0x198(%ebp)
  8010dd:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  8010e3:	89 c2                	mov    %eax,%edx
  8010e5:	c1 ea 1f             	shr    $0x1f,%edx
  8010e8:	01 d0                	add    %edx,%eax
  8010ea:	d1 f8                	sar    %eax
  8010ec:	89 c2                	mov    %eax,%edx
  8010ee:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8010f4:	01 d0                	add    %edx,%eax
  8010f6:	89 85 34 ff ff ff    	mov    %eax,-0xcc(%ebp)
  8010fc:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
  801102:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801107:	89 85 6c fe ff ff    	mov    %eax,-0x194(%ebp)
  80110d:	8b 95 78 ff ff ff    	mov    -0x88(%ebp),%edx
  801113:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  801119:	01 d0                	add    %edx,%eax
  80111b:	89 85 30 ff ff ff    	mov    %eax,-0xd0(%ebp)
  801121:	8b 85 30 ff ff ff    	mov    -0xd0(%ebp),%eax
  801127:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80112c:	89 85 70 fe ff ff    	mov    %eax,-0x190(%ebp)
			chk = sys_check_WS_list(notExpectedVAs, 3, 0, 3);
  801132:	6a 03                	push   $0x3
  801134:	6a 00                	push   $0x0
  801136:	6a 03                	push   $0x3
  801138:	8d 85 68 fe ff ff    	lea    -0x198(%ebp),%eax
  80113e:	50                   	push   %eax
  80113f:	e8 6b 1f 00 00       	call   8030af <sys_check_WS_list>
  801144:	83 c4 10             	add    $0x10,%esp
  801147:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
			if (chk != 1) { is_correct = 0; cprintf("11 free: page is not removed from WS\n");}
  80114d:	83 bd 44 ff ff ff 01 	cmpl   $0x1,-0xbc(%ebp)
  801154:	74 17                	je     80116d <_main+0x1114>
  801156:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80115d:	83 ec 0c             	sub    $0xc,%esp
  801160:	68 f4 42 80 00       	push   $0x8042f4
  801165:	e8 c8 09 00 00       	call   801b32 <cprintf>
  80116a:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)
  80116d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801171:	74 04                	je     801177 <_main+0x111e>
		{
			eval += 10;
  801173:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		}

		is_correct = 1;
  801177:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		//Free 7 KB
		{
			freeFrames = sys_calculate_free_frames() ;
  80117e:	e8 6a 1b 00 00       	call   802ced <sys_calculate_free_frames>
  801183:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  801186:	e8 ad 1b 00 00       	call   802d38 <sys_pf_calculate_allocated_pages>
  80118b:	89 45 c8             	mov    %eax,-0x38(%ebp)
			free(ptr_allocations[4]);
  80118e:	8b 85 cc fe ff ff    	mov    -0x134(%ebp),%eax
  801194:	83 ec 0c             	sub    $0xc,%esp
  801197:	50                   	push   %eax
  801198:	e8 85 19 00 00       	call   802b22 <free>
  80119d:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0)
  8011a0:	e8 93 1b 00 00       	call   802d38 <sys_pf_calculate_allocated_pages>
  8011a5:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8011a8:	74 17                	je     8011c1 <_main+0x1168>
			{ is_correct = 0; cprintf("12 Wrong free: Extra or less pages are removed from PageFile\n");}
  8011aa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8011b1:	83 ec 0c             	sub    $0xc,%esp
  8011b4:	68 1c 43 80 00       	push   $0x80431c
  8011b9:	e8 74 09 00 00       	call   801b32 <cprintf>
  8011be:	83 c4 10             	add    $0x10,%esp
			if ((sys_calculate_free_frames() - freeFrames) != 2)
  8011c1:	e8 27 1b 00 00       	call   802ced <sys_calculate_free_frames>
  8011c6:	89 c2                	mov    %eax,%edx
  8011c8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8011cb:	29 c2                	sub    %eax,%edx
  8011cd:	89 d0                	mov    %edx,%eax
  8011cf:	83 f8 02             	cmp    $0x2,%eax
  8011d2:	74 17                	je     8011eb <_main+0x1192>
			{ is_correct = 0; cprintf("12 Wrong free: WS pages in memory and/or page tables are not freed correctly\n");}
  8011d4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8011db:	83 ec 0c             	sub    $0xc,%esp
  8011de:	68 5c 43 80 00       	push   $0x80435c
  8011e3:	e8 4a 09 00 00       	call   801b32 <cprintf>
  8011e8:	83 c4 10             	add    $0x10,%esp
			uint32 notExpectedVAs[2] = { ROUNDDOWN((uint32)(&(structArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE)} ;
  8011eb:	8b 45 88             	mov    -0x78(%ebp),%eax
  8011ee:	89 85 2c ff ff ff    	mov    %eax,-0xd4(%ebp)
  8011f4:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
  8011fa:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011ff:	89 85 60 fe ff ff    	mov    %eax,-0x1a0(%ebp)
  801205:	8b 45 84             	mov    -0x7c(%ebp),%eax
  801208:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80120f:	8b 45 88             	mov    -0x78(%ebp),%eax
  801212:	01 d0                	add    %edx,%eax
  801214:	89 85 28 ff ff ff    	mov    %eax,-0xd8(%ebp)
  80121a:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
  801220:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801225:	89 85 64 fe ff ff    	mov    %eax,-0x19c(%ebp)
			chk = sys_check_WS_list(notExpectedVAs, 2, 0, 3);
  80122b:	6a 03                	push   $0x3
  80122d:	6a 00                	push   $0x0
  80122f:	6a 02                	push   $0x2
  801231:	8d 85 60 fe ff ff    	lea    -0x1a0(%ebp),%eax
  801237:	50                   	push   %eax
  801238:	e8 72 1e 00 00       	call   8030af <sys_check_WS_list>
  80123d:	83 c4 10             	add    $0x10,%esp
  801240:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
			if (chk != 1) { is_correct = 0; cprintf("12 free: page is not removed from WS\n");}
  801246:	83 bd 44 ff ff ff 01 	cmpl   $0x1,-0xbc(%ebp)
  80124d:	74 17                	je     801266 <_main+0x120d>
  80124f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801256:	83 ec 0c             	sub    $0xc,%esp
  801259:	68 ac 43 80 00       	push   $0x8043ac
  80125e:	e8 cf 08 00 00       	call   801b32 <cprintf>
  801263:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)
  801266:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80126a:	74 04                	je     801270 <_main+0x1217>
		{
			eval += 10;
  80126c:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		}

		is_correct = 1;
  801270:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		//Free 3 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  801277:	e8 71 1a 00 00       	call   802ced <sys_calculate_free_frames>
  80127c:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80127f:	e8 b4 1a 00 00       	call   802d38 <sys_pf_calculate_allocated_pages>
  801284:	89 45 c8             	mov    %eax,-0x38(%ebp)
			free(ptr_allocations[5]);
  801287:	8b 85 d0 fe ff ff    	mov    -0x130(%ebp),%eax
  80128d:	83 ec 0c             	sub    $0xc,%esp
  801290:	50                   	push   %eax
  801291:	e8 8c 18 00 00       	call   802b22 <free>
  801296:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0)
  801299:	e8 9a 1a 00 00       	call   802d38 <sys_pf_calculate_allocated_pages>
  80129e:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8012a1:	74 17                	je     8012ba <_main+0x1261>
			{ is_correct = 0; cprintf("13 Wrong free: Extra or less pages are removed from PageFile\n");}
  8012a3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8012aa:	83 ec 0c             	sub    $0xc,%esp
  8012ad:	68 d4 43 80 00       	push   $0x8043d4
  8012b2:	e8 7b 08 00 00       	call   801b32 <cprintf>
  8012b7:	83 c4 10             	add    $0x10,%esp
			if ((sys_calculate_free_frames() - freeFrames) != 0)
  8012ba:	e8 2e 1a 00 00       	call   802ced <sys_calculate_free_frames>
  8012bf:	89 c2                	mov    %eax,%edx
  8012c1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8012c4:	39 c2                	cmp    %eax,%edx
  8012c6:	74 17                	je     8012df <_main+0x1286>
			{ is_correct = 0; cprintf("13 Wrong free: unexpected number of free frames after calling free\n");}
  8012c8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8012cf:	83 ec 0c             	sub    $0xc,%esp
  8012d2:	68 14 44 80 00       	push   $0x804414
  8012d7:	e8 56 08 00 00       	call   801b32 <cprintf>
  8012dc:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)
  8012df:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012e3:	74 04                	je     8012e9 <_main+0x1290>
		{
			eval += 5;
  8012e5:	83 45 f4 05          	addl   $0x5,-0xc(%ebp)
		}

		is_correct = 1;
  8012e9:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		//Free 1st 3 KB
		{
			freeFrames = sys_calculate_free_frames() ;
  8012f0:	e8 f8 19 00 00       	call   802ced <sys_calculate_free_frames>
  8012f5:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8012f8:	e8 3b 1a 00 00       	call   802d38 <sys_pf_calculate_allocated_pages>
  8012fd:	89 45 c8             	mov    %eax,-0x38(%ebp)
			free(ptr_allocations[2]);
  801300:	8b 85 c4 fe ff ff    	mov    -0x13c(%ebp),%eax
  801306:	83 ec 0c             	sub    $0xc,%esp
  801309:	50                   	push   %eax
  80130a:	e8 13 18 00 00       	call   802b22 <free>
  80130f:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0)
  801312:	e8 21 1a 00 00       	call   802d38 <sys_pf_calculate_allocated_pages>
  801317:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80131a:	74 17                	je     801333 <_main+0x12da>
			{ is_correct = 0; cprintf("14 Wrong free: Extra or less pages are removed from PageFile\n");}
  80131c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801323:	83 ec 0c             	sub    $0xc,%esp
  801326:	68 58 44 80 00       	push   $0x804458
  80132b:	e8 02 08 00 00       	call   801b32 <cprintf>
  801330:	83 c4 10             	add    $0x10,%esp
			if ((sys_calculate_free_frames() - freeFrames) != 1 /*+ 1*/)
  801333:	e8 b5 19 00 00       	call   802ced <sys_calculate_free_frames>
  801338:	89 c2                	mov    %eax,%edx
  80133a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80133d:	29 c2                	sub    %eax,%edx
  80133f:	89 d0                	mov    %edx,%eax
  801341:	83 f8 01             	cmp    $0x1,%eax
  801344:	74 17                	je     80135d <_main+0x1304>
			{ is_correct = 0; cprintf("14 Wrong free: WS pages in memory and/or page tables are not freed correctly\n");}
  801346:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80134d:	83 ec 0c             	sub    $0xc,%esp
  801350:	68 98 44 80 00       	push   $0x804498
  801355:	e8 d8 07 00 00       	call   801b32 <cprintf>
  80135a:	83 c4 10             	add    $0x10,%esp
			uint32 notExpectedVAs[2] = { ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE)} ;
  80135d:	8b 45 98             	mov    -0x68(%ebp),%eax
  801360:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
  801366:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  80136c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801371:	89 85 58 fe ff ff    	mov    %eax,-0x1a8(%ebp)
  801377:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80137a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801381:	8b 45 98             	mov    -0x68(%ebp),%eax
  801384:	01 d0                	add    %edx,%eax
  801386:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
  80138c:	8b 85 20 ff ff ff    	mov    -0xe0(%ebp),%eax
  801392:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801397:	89 85 5c fe ff ff    	mov    %eax,-0x1a4(%ebp)
			chk = sys_check_WS_list(notExpectedVAs, 2, 0, 3);
  80139d:	6a 03                	push   $0x3
  80139f:	6a 00                	push   $0x0
  8013a1:	6a 02                	push   $0x2
  8013a3:	8d 85 58 fe ff ff    	lea    -0x1a8(%ebp),%eax
  8013a9:	50                   	push   %eax
  8013aa:	e8 00 1d 00 00       	call   8030af <sys_check_WS_list>
  8013af:	83 c4 10             	add    $0x10,%esp
  8013b2:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
			if (chk != 1) { is_correct = 0; cprintf("14 free: page is not removed from WS\n");}
  8013b8:	83 bd 44 ff ff ff 01 	cmpl   $0x1,-0xbc(%ebp)
  8013bf:	74 17                	je     8013d8 <_main+0x137f>
  8013c1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8013c8:	83 ec 0c             	sub    $0xc,%esp
  8013cb:	68 e8 44 80 00       	push   $0x8044e8
  8013d0:	e8 5d 07 00 00       	call   801b32 <cprintf>
  8013d5:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)
  8013d8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013dc:	74 04                	je     8013e2 <_main+0x1389>
		{
			eval += 10;
  8013de:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		}

		is_correct = 1;
  8013e2:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		//Free 2nd 3 KB
		{
			freeFrames = sys_calculate_free_frames() ;
  8013e9:	e8 ff 18 00 00       	call   802ced <sys_calculate_free_frames>
  8013ee:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8013f1:	e8 42 19 00 00       	call   802d38 <sys_pf_calculate_allocated_pages>
  8013f6:	89 45 c8             	mov    %eax,-0x38(%ebp)
			free(ptr_allocations[3]);
  8013f9:	8b 85 c8 fe ff ff    	mov    -0x138(%ebp),%eax
  8013ff:	83 ec 0c             	sub    $0xc,%esp
  801402:	50                   	push   %eax
  801403:	e8 1a 17 00 00       	call   802b22 <free>
  801408:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0)
  80140b:	e8 28 19 00 00       	call   802d38 <sys_pf_calculate_allocated_pages>
  801410:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  801413:	74 17                	je     80142c <_main+0x13d3>
			{ is_correct = 0; cprintf("15 Wrong free: Extra or less pages are removed from PageFile\n");}
  801415:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80141c:	83 ec 0c             	sub    $0xc,%esp
  80141f:	68 10 45 80 00       	push   $0x804510
  801424:	e8 09 07 00 00       	call   801b32 <cprintf>
  801429:	83 c4 10             	add    $0x10,%esp
			if ((sys_calculate_free_frames() - freeFrames) != 0)
  80142c:	e8 bc 18 00 00       	call   802ced <sys_calculate_free_frames>
  801431:	89 c2                	mov    %eax,%edx
  801433:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801436:	39 c2                	cmp    %eax,%edx
  801438:	74 17                	je     801451 <_main+0x13f8>
			{ is_correct = 0; cprintf("15 Wrong free: WS pages in memory and/or page tables are not freed correctly\n");}
  80143a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801441:	83 ec 0c             	sub    $0xc,%esp
  801444:	68 50 45 80 00       	push   $0x804550
  801449:	e8 e4 06 00 00       	call   801b32 <cprintf>
  80144e:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)
  801451:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801455:	74 04                	je     80145b <_main+0x1402>
		{
			eval += 5;
  801457:	83 45 f4 05          	addl   $0x5,-0xc(%ebp)
		}

		is_correct = 1;
  80145b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		//Free last 14 KB
		{
			freeFrames = sys_calculate_free_frames() ;
  801462:	e8 86 18 00 00       	call   802ced <sys_calculate_free_frames>
  801467:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80146a:	e8 c9 18 00 00       	call   802d38 <sys_pf_calculate_allocated_pages>
  80146f:	89 45 c8             	mov    %eax,-0x38(%ebp)
			free(ptr_allocations[7]);
  801472:	8b 85 d8 fe ff ff    	mov    -0x128(%ebp),%eax
  801478:	83 ec 0c             	sub    $0xc,%esp
  80147b:	50                   	push   %eax
  80147c:	e8 a1 16 00 00       	call   802b22 <free>
  801481:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0)
  801484:	e8 af 18 00 00       	call   802d38 <sys_pf_calculate_allocated_pages>
  801489:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80148c:	74 17                	je     8014a5 <_main+0x144c>
			{ is_correct = 0; cprintf("16 Wrong free: Extra or less pages are removed from PageFile\n");}
  80148e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801495:	83 ec 0c             	sub    $0xc,%esp
  801498:	68 a0 45 80 00       	push   $0x8045a0
  80149d:	e8 90 06 00 00       	call   801b32 <cprintf>
  8014a2:	83 c4 10             	add    $0x10,%esp
			if ((sys_calculate_free_frames() - freeFrames) != 3 /*+ 1*/)
  8014a5:	e8 43 18 00 00       	call   802ced <sys_calculate_free_frames>
  8014aa:	89 c2                	mov    %eax,%edx
  8014ac:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8014af:	29 c2                	sub    %eax,%edx
  8014b1:	89 d0                	mov    %edx,%eax
  8014b3:	83 f8 03             	cmp    $0x3,%eax
  8014b6:	74 17                	je     8014cf <_main+0x1476>
			{ is_correct = 0; cprintf("16 Wrong free: WS pages in memory and/or page tables are not freed correctly\n");}
  8014b8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8014bf:	83 ec 0c             	sub    $0xc,%esp
  8014c2:	68 e0 45 80 00       	push   $0x8045e0
  8014c7:	e8 66 06 00 00       	call   801b32 <cprintf>
  8014cc:	83 c4 10             	add    $0x10,%esp
			uint32 notExpectedVAs[3] = { ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2/2])), PAGE_SIZE), ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2])), PAGE_SIZE)} ;
  8014cf:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  8014d5:	89 85 1c ff ff ff    	mov    %eax,-0xe4(%ebp)
  8014db:	8b 85 1c ff ff ff    	mov    -0xe4(%ebp),%eax
  8014e1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014e6:	89 85 4c fe ff ff    	mov    %eax,-0x1b4(%ebp)
  8014ec:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  8014f2:	89 c2                	mov    %eax,%edx
  8014f4:	c1 ea 1f             	shr    $0x1f,%edx
  8014f7:	01 d0                	add    %edx,%eax
  8014f9:	d1 f8                	sar    %eax
  8014fb:	01 c0                	add    %eax,%eax
  8014fd:	89 c2                	mov    %eax,%edx
  8014ff:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  801505:	01 d0                	add    %edx,%eax
  801507:	89 85 18 ff ff ff    	mov    %eax,-0xe8(%ebp)
  80150d:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
  801513:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801518:	89 85 50 fe ff ff    	mov    %eax,-0x1b0(%ebp)
  80151e:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  801524:	01 c0                	add    %eax,%eax
  801526:	89 c2                	mov    %eax,%edx
  801528:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  80152e:	01 d0                	add    %edx,%eax
  801530:	89 85 14 ff ff ff    	mov    %eax,-0xec(%ebp)
  801536:	8b 85 14 ff ff ff    	mov    -0xec(%ebp),%eax
  80153c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801541:	89 85 54 fe ff ff    	mov    %eax,-0x1ac(%ebp)
			chk = sys_check_WS_list(notExpectedVAs, 3, 0, 3);
  801547:	6a 03                	push   $0x3
  801549:	6a 00                	push   $0x0
  80154b:	6a 03                	push   $0x3
  80154d:	8d 85 4c fe ff ff    	lea    -0x1b4(%ebp),%eax
  801553:	50                   	push   %eax
  801554:	e8 56 1b 00 00       	call   8030af <sys_check_WS_list>
  801559:	83 c4 10             	add    $0x10,%esp
  80155c:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
			if (chk != 1) { is_correct = 0; cprintf("16 free: page is not removed from WS\n");}
  801562:	83 bd 44 ff ff ff 01 	cmpl   $0x1,-0xbc(%ebp)
  801569:	74 17                	je     801582 <_main+0x1529>
  80156b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801572:	83 ec 0c             	sub    $0xc,%esp
  801575:	68 30 46 80 00       	push   $0x804630
  80157a:	e8 b3 05 00 00       	call   801b32 <cprintf>
  80157f:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)
  801582:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801586:	74 04                	je     80158c <_main+0x1533>
		{
			eval += 10;
  801588:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		}

		is_correct = 1;
  80158c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}

	is_correct = 1;
  801593:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	//Test accessing a freed area (processes should be killed by the validation of the fault handler)
	cprintf("\n%~[3] Test accessing a freed area (processes should be killed by the validation of the fault handler) [30%]\n");
  80159a:	83 ec 0c             	sub    $0xc,%esp
  80159d:	68 58 46 80 00       	push   $0x804658
  8015a2:	e8 8b 05 00 00       	call   801b32 <cprintf>
  8015a7:	83 c4 10             	add    $0x10,%esp
	{
		rsttst();
  8015aa:	e8 e5 19 00 00       	call   802f94 <rsttst>
		int ID1 = sys_create_env("tf1_slave1", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  8015af:	a1 20 60 80 00       	mov    0x806020,%eax
  8015b4:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  8015ba:	a1 20 60 80 00       	mov    0x806020,%eax
  8015bf:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  8015c5:	89 c1                	mov    %eax,%ecx
  8015c7:	a1 20 60 80 00       	mov    0x806020,%eax
  8015cc:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8015d2:	52                   	push   %edx
  8015d3:	51                   	push   %ecx
  8015d4:	50                   	push   %eax
  8015d5:	68 c6 46 80 00       	push   $0x8046c6
  8015da:	e8 69 18 00 00       	call   802e48 <sys_create_env>
  8015df:	83 c4 10             	add    $0x10,%esp
  8015e2:	89 85 10 ff ff ff    	mov    %eax,-0xf0(%ebp)
		sys_run_env(ID1);
  8015e8:	83 ec 0c             	sub    $0xc,%esp
  8015eb:	ff b5 10 ff ff ff    	pushl  -0xf0(%ebp)
  8015f1:	e8 70 18 00 00       	call   802e66 <sys_run_env>
  8015f6:	83 c4 10             	add    $0x10,%esp

		//wait until a slave finishes the allocation & freeing operations
		while (gettst() != 1) ;
  8015f9:	90                   	nop
  8015fa:	e8 0f 1a 00 00       	call   80300e <gettst>
  8015ff:	83 f8 01             	cmp    $0x1,%eax
  801602:	75 f6                	jne    8015fa <_main+0x15a1>

		int ID2 = sys_create_env("tf1_slave2", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  801604:	a1 20 60 80 00       	mov    0x806020,%eax
  801609:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  80160f:	a1 20 60 80 00       	mov    0x806020,%eax
  801614:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  80161a:	89 c1                	mov    %eax,%ecx
  80161c:	a1 20 60 80 00       	mov    0x806020,%eax
  801621:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  801627:	52                   	push   %edx
  801628:	51                   	push   %ecx
  801629:	50                   	push   %eax
  80162a:	68 d1 46 80 00       	push   $0x8046d1
  80162f:	e8 14 18 00 00       	call   802e48 <sys_create_env>
  801634:	83 c4 10             	add    $0x10,%esp
  801637:	89 85 0c ff ff ff    	mov    %eax,-0xf4(%ebp)
		sys_run_env(ID2);
  80163d:	83 ec 0c             	sub    $0xc,%esp
  801640:	ff b5 0c ff ff ff    	pushl  -0xf4(%ebp)
  801646:	e8 1b 18 00 00       	call   802e66 <sys_run_env>
  80164b:	83 c4 10             	add    $0x10,%esp

		//wait until a slave finishes the allocation & freeing operations
		while (gettst() != 1) ;
  80164e:	90                   	nop
  80164f:	e8 ba 19 00 00       	call   80300e <gettst>
  801654:	83 f8 01             	cmp    $0x1,%eax
  801657:	75 f6                	jne    80164f <_main+0x15f6>

		//signal them to start accessing the freed area
		inctst();
  801659:	e8 96 19 00 00       	call   802ff4 <inctst>

		//sleep for a while to allow each slave to try access its freed location
		env_sleep(10000);
  80165e:	83 ec 0c             	sub    $0xc,%esp
  801661:	68 10 27 00 00       	push   $0x2710
  801666:	e8 55 1c 00 00       	call   8032c0 <env_sleep>
  80166b:	83 c4 10             	add    $0x10,%esp

		if (gettst() > 3)
  80166e:	e8 9b 19 00 00       	call   80300e <gettst>
  801673:	83 f8 03             	cmp    $0x3,%eax
  801676:	76 17                	jbe    80168f <_main+0x1636>
		{ is_correct = 0; cprintf("\n17 Free: access to freed space is done while it's NOT expected to be!! (processes should be killed by the validation of the fault handler)\n");}
  801678:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80167f:	83 ec 0c             	sub    $0xc,%esp
  801682:	68 dc 46 80 00       	push   $0x8046dc
  801687:	e8 a6 04 00 00       	call   801b32 <cprintf>
  80168c:	83 c4 10             	add    $0x10,%esp
	}
	if (is_correct)
  80168f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801693:	74 04                	je     801699 <_main+0x1640>
	{
		eval += 30;
  801695:	83 45 f4 1e          	addl   $0x1e,-0xc(%ebp)
	}
	cprintf("%~\ntest free [1] [PAGE ALLOCATOR] completed. Eval = %d\n\n", eval);
  801699:	83 ec 08             	sub    $0x8,%esp
  80169c:	ff 75 f4             	pushl  -0xc(%ebp)
  80169f:	68 6c 47 80 00       	push   $0x80476c
  8016a4:	e8 89 04 00 00       	call   801b32 <cprintf>
  8016a9:	83 c4 10             	add    $0x10,%esp

	return;
  8016ac:	90                   	nop
}
  8016ad:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016b0:	5b                   	pop    %ebx
  8016b1:	5f                   	pop    %edi
  8016b2:	5d                   	pop    %ebp
  8016b3:	c3                   	ret    

008016b4 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8016b4:	55                   	push   %ebp
  8016b5:	89 e5                	mov    %esp,%ebp
  8016b7:	57                   	push   %edi
  8016b8:	56                   	push   %esi
  8016b9:	53                   	push   %ebx
  8016ba:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8016bd:	e8 f4 17 00 00       	call   802eb6 <sys_getenvindex>
  8016c2:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8016c5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8016c8:	89 d0                	mov    %edx,%eax
  8016ca:	c1 e0 02             	shl    $0x2,%eax
  8016cd:	01 d0                	add    %edx,%eax
  8016cf:	c1 e0 03             	shl    $0x3,%eax
  8016d2:	01 d0                	add    %edx,%eax
  8016d4:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8016db:	01 d0                	add    %edx,%eax
  8016dd:	c1 e0 02             	shl    $0x2,%eax
  8016e0:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8016e5:	a3 20 60 80 00       	mov    %eax,0x806020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8016ea:	a1 20 60 80 00       	mov    0x806020,%eax
  8016ef:	8a 40 20             	mov    0x20(%eax),%al
  8016f2:	84 c0                	test   %al,%al
  8016f4:	74 0d                	je     801703 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8016f6:	a1 20 60 80 00       	mov    0x806020,%eax
  8016fb:	83 c0 20             	add    $0x20,%eax
  8016fe:	a3 04 60 80 00       	mov    %eax,0x806004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  801703:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801707:	7e 0a                	jle    801713 <libmain+0x5f>
		binaryname = argv[0];
  801709:	8b 45 0c             	mov    0xc(%ebp),%eax
  80170c:	8b 00                	mov    (%eax),%eax
  80170e:	a3 04 60 80 00       	mov    %eax,0x806004

	// call user main routine
	_main(argc, argv);
  801713:	83 ec 08             	sub    $0x8,%esp
  801716:	ff 75 0c             	pushl  0xc(%ebp)
  801719:	ff 75 08             	pushl  0x8(%ebp)
  80171c:	e8 38 e9 ff ff       	call   800059 <_main>
  801721:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  801724:	a1 00 60 80 00       	mov    0x806000,%eax
  801729:	85 c0                	test   %eax,%eax
  80172b:	0f 84 01 01 00 00    	je     801832 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  801731:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  801737:	bb a0 48 80 00       	mov    $0x8048a0,%ebx
  80173c:	ba 0e 00 00 00       	mov    $0xe,%edx
  801741:	89 c7                	mov    %eax,%edi
  801743:	89 de                	mov    %ebx,%esi
  801745:	89 d1                	mov    %edx,%ecx
  801747:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  801749:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80174c:	b9 56 00 00 00       	mov    $0x56,%ecx
  801751:	b0 00                	mov    $0x0,%al
  801753:	89 d7                	mov    %edx,%edi
  801755:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  801757:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80175e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801761:	83 ec 08             	sub    $0x8,%esp
  801764:	50                   	push   %eax
  801765:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80176b:	50                   	push   %eax
  80176c:	e8 7b 19 00 00       	call   8030ec <sys_utilities>
  801771:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  801774:	e8 c4 14 00 00       	call   802c3d <sys_lock_cons>
		{
			cprintf("**************************************\n");
  801779:	83 ec 0c             	sub    $0xc,%esp
  80177c:	68 c0 47 80 00       	push   $0x8047c0
  801781:	e8 ac 03 00 00       	call   801b32 <cprintf>
  801786:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  801789:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80178c:	85 c0                	test   %eax,%eax
  80178e:	74 18                	je     8017a8 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  801790:	e8 75 19 00 00       	call   80310a <sys_get_optimal_num_faults>
  801795:	83 ec 08             	sub    $0x8,%esp
  801798:	50                   	push   %eax
  801799:	68 e8 47 80 00       	push   $0x8047e8
  80179e:	e8 8f 03 00 00       	call   801b32 <cprintf>
  8017a3:	83 c4 10             	add    $0x10,%esp
  8017a6:	eb 59                	jmp    801801 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8017a8:	a1 20 60 80 00       	mov    0x806020,%eax
  8017ad:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8017b3:	a1 20 60 80 00       	mov    0x806020,%eax
  8017b8:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  8017be:	83 ec 04             	sub    $0x4,%esp
  8017c1:	52                   	push   %edx
  8017c2:	50                   	push   %eax
  8017c3:	68 0c 48 80 00       	push   $0x80480c
  8017c8:	e8 65 03 00 00       	call   801b32 <cprintf>
  8017cd:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8017d0:	a1 20 60 80 00       	mov    0x806020,%eax
  8017d5:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8017db:	a1 20 60 80 00       	mov    0x806020,%eax
  8017e0:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  8017e6:	a1 20 60 80 00       	mov    0x806020,%eax
  8017eb:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  8017f1:	51                   	push   %ecx
  8017f2:	52                   	push   %edx
  8017f3:	50                   	push   %eax
  8017f4:	68 34 48 80 00       	push   $0x804834
  8017f9:	e8 34 03 00 00       	call   801b32 <cprintf>
  8017fe:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  801801:	a1 20 60 80 00       	mov    0x806020,%eax
  801806:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  80180c:	83 ec 08             	sub    $0x8,%esp
  80180f:	50                   	push   %eax
  801810:	68 8c 48 80 00       	push   $0x80488c
  801815:	e8 18 03 00 00       	call   801b32 <cprintf>
  80181a:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80181d:	83 ec 0c             	sub    $0xc,%esp
  801820:	68 c0 47 80 00       	push   $0x8047c0
  801825:	e8 08 03 00 00       	call   801b32 <cprintf>
  80182a:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80182d:	e8 25 14 00 00       	call   802c57 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  801832:	e8 1f 00 00 00       	call   801856 <exit>
}
  801837:	90                   	nop
  801838:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80183b:	5b                   	pop    %ebx
  80183c:	5e                   	pop    %esi
  80183d:	5f                   	pop    %edi
  80183e:	5d                   	pop    %ebp
  80183f:	c3                   	ret    

00801840 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  801840:	55                   	push   %ebp
  801841:	89 e5                	mov    %esp,%ebp
  801843:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  801846:	83 ec 0c             	sub    $0xc,%esp
  801849:	6a 00                	push   $0x0
  80184b:	e8 32 16 00 00       	call   802e82 <sys_destroy_env>
  801850:	83 c4 10             	add    $0x10,%esp
}
  801853:	90                   	nop
  801854:	c9                   	leave  
  801855:	c3                   	ret    

00801856 <exit>:

void
exit(void)
{
  801856:	55                   	push   %ebp
  801857:	89 e5                	mov    %esp,%ebp
  801859:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80185c:	e8 87 16 00 00       	call   802ee8 <sys_exit_env>
}
  801861:	90                   	nop
  801862:	c9                   	leave  
  801863:	c3                   	ret    

00801864 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801864:	55                   	push   %ebp
  801865:	89 e5                	mov    %esp,%ebp
  801867:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80186a:	8d 45 10             	lea    0x10(%ebp),%eax
  80186d:	83 c0 04             	add    $0x4,%eax
  801870:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801873:	a1 18 e1 81 00       	mov    0x81e118,%eax
  801878:	85 c0                	test   %eax,%eax
  80187a:	74 16                	je     801892 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80187c:	a1 18 e1 81 00       	mov    0x81e118,%eax
  801881:	83 ec 08             	sub    $0x8,%esp
  801884:	50                   	push   %eax
  801885:	68 04 49 80 00       	push   $0x804904
  80188a:	e8 a3 02 00 00       	call   801b32 <cprintf>
  80188f:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  801892:	a1 04 60 80 00       	mov    0x806004,%eax
  801897:	83 ec 0c             	sub    $0xc,%esp
  80189a:	ff 75 0c             	pushl  0xc(%ebp)
  80189d:	ff 75 08             	pushl  0x8(%ebp)
  8018a0:	50                   	push   %eax
  8018a1:	68 0c 49 80 00       	push   $0x80490c
  8018a6:	6a 74                	push   $0x74
  8018a8:	e8 b2 02 00 00       	call   801b5f <cprintf_colored>
  8018ad:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8018b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8018b3:	83 ec 08             	sub    $0x8,%esp
  8018b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8018b9:	50                   	push   %eax
  8018ba:	e8 04 02 00 00       	call   801ac3 <vcprintf>
  8018bf:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8018c2:	83 ec 08             	sub    $0x8,%esp
  8018c5:	6a 00                	push   $0x0
  8018c7:	68 34 49 80 00       	push   $0x804934
  8018cc:	e8 f2 01 00 00       	call   801ac3 <vcprintf>
  8018d1:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8018d4:	e8 7d ff ff ff       	call   801856 <exit>

	// should not return here
	while (1) ;
  8018d9:	eb fe                	jmp    8018d9 <_panic+0x75>

008018db <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8018db:	55                   	push   %ebp
  8018dc:	89 e5                	mov    %esp,%ebp
  8018de:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8018e1:	a1 20 60 80 00       	mov    0x806020,%eax
  8018e6:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8018ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018ef:	39 c2                	cmp    %eax,%edx
  8018f1:	74 14                	je     801907 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8018f3:	83 ec 04             	sub    $0x4,%esp
  8018f6:	68 38 49 80 00       	push   $0x804938
  8018fb:	6a 26                	push   $0x26
  8018fd:	68 84 49 80 00       	push   $0x804984
  801902:	e8 5d ff ff ff       	call   801864 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801907:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80190e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801915:	e9 c5 00 00 00       	jmp    8019df <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80191a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80191d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801924:	8b 45 08             	mov    0x8(%ebp),%eax
  801927:	01 d0                	add    %edx,%eax
  801929:	8b 00                	mov    (%eax),%eax
  80192b:	85 c0                	test   %eax,%eax
  80192d:	75 08                	jne    801937 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80192f:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801932:	e9 a5 00 00 00       	jmp    8019dc <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801937:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80193e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801945:	eb 69                	jmp    8019b0 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801947:	a1 20 60 80 00       	mov    0x806020,%eax
  80194c:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  801952:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801955:	89 d0                	mov    %edx,%eax
  801957:	01 c0                	add    %eax,%eax
  801959:	01 d0                	add    %edx,%eax
  80195b:	c1 e0 03             	shl    $0x3,%eax
  80195e:	01 c8                	add    %ecx,%eax
  801960:	8a 40 04             	mov    0x4(%eax),%al
  801963:	84 c0                	test   %al,%al
  801965:	75 46                	jne    8019ad <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801967:	a1 20 60 80 00       	mov    0x806020,%eax
  80196c:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  801972:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801975:	89 d0                	mov    %edx,%eax
  801977:	01 c0                	add    %eax,%eax
  801979:	01 d0                	add    %edx,%eax
  80197b:	c1 e0 03             	shl    $0x3,%eax
  80197e:	01 c8                	add    %ecx,%eax
  801980:	8b 00                	mov    (%eax),%eax
  801982:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801985:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801988:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80198d:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80198f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801992:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801999:	8b 45 08             	mov    0x8(%ebp),%eax
  80199c:	01 c8                	add    %ecx,%eax
  80199e:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8019a0:	39 c2                	cmp    %eax,%edx
  8019a2:	75 09                	jne    8019ad <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8019a4:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8019ab:	eb 15                	jmp    8019c2 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8019ad:	ff 45 e8             	incl   -0x18(%ebp)
  8019b0:	a1 20 60 80 00       	mov    0x806020,%eax
  8019b5:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8019bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8019be:	39 c2                	cmp    %eax,%edx
  8019c0:	77 85                	ja     801947 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8019c2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8019c6:	75 14                	jne    8019dc <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8019c8:	83 ec 04             	sub    $0x4,%esp
  8019cb:	68 90 49 80 00       	push   $0x804990
  8019d0:	6a 3a                	push   $0x3a
  8019d2:	68 84 49 80 00       	push   $0x804984
  8019d7:	e8 88 fe ff ff       	call   801864 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8019dc:	ff 45 f0             	incl   -0x10(%ebp)
  8019df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019e2:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8019e5:	0f 8c 2f ff ff ff    	jl     80191a <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8019eb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8019f2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8019f9:	eb 26                	jmp    801a21 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8019fb:	a1 20 60 80 00       	mov    0x806020,%eax
  801a00:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  801a06:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a09:	89 d0                	mov    %edx,%eax
  801a0b:	01 c0                	add    %eax,%eax
  801a0d:	01 d0                	add    %edx,%eax
  801a0f:	c1 e0 03             	shl    $0x3,%eax
  801a12:	01 c8                	add    %ecx,%eax
  801a14:	8a 40 04             	mov    0x4(%eax),%al
  801a17:	3c 01                	cmp    $0x1,%al
  801a19:	75 03                	jne    801a1e <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801a1b:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801a1e:	ff 45 e0             	incl   -0x20(%ebp)
  801a21:	a1 20 60 80 00       	mov    0x806020,%eax
  801a26:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801a2c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a2f:	39 c2                	cmp    %eax,%edx
  801a31:	77 c8                	ja     8019fb <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801a33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a36:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801a39:	74 14                	je     801a4f <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801a3b:	83 ec 04             	sub    $0x4,%esp
  801a3e:	68 e4 49 80 00       	push   $0x8049e4
  801a43:	6a 44                	push   $0x44
  801a45:	68 84 49 80 00       	push   $0x804984
  801a4a:	e8 15 fe ff ff       	call   801864 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801a4f:	90                   	nop
  801a50:	c9                   	leave  
  801a51:	c3                   	ret    

00801a52 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  801a52:	55                   	push   %ebp
  801a53:	89 e5                	mov    %esp,%ebp
  801a55:	53                   	push   %ebx
  801a56:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  801a59:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a5c:	8b 00                	mov    (%eax),%eax
  801a5e:	8d 48 01             	lea    0x1(%eax),%ecx
  801a61:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a64:	89 0a                	mov    %ecx,(%edx)
  801a66:	8b 55 08             	mov    0x8(%ebp),%edx
  801a69:	88 d1                	mov    %dl,%cl
  801a6b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a6e:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  801a72:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a75:	8b 00                	mov    (%eax),%eax
  801a77:	3d ff 00 00 00       	cmp    $0xff,%eax
  801a7c:	75 30                	jne    801aae <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  801a7e:	8b 15 1c e1 81 00    	mov    0x81e11c,%edx
  801a84:	a0 44 60 80 00       	mov    0x806044,%al
  801a89:	0f b6 c0             	movzbl %al,%eax
  801a8c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a8f:	8b 09                	mov    (%ecx),%ecx
  801a91:	89 cb                	mov    %ecx,%ebx
  801a93:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a96:	83 c1 08             	add    $0x8,%ecx
  801a99:	52                   	push   %edx
  801a9a:	50                   	push   %eax
  801a9b:	53                   	push   %ebx
  801a9c:	51                   	push   %ecx
  801a9d:	e8 57 11 00 00       	call   802bf9 <sys_cputs>
  801aa2:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  801aa5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aa8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  801aae:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ab1:	8b 40 04             	mov    0x4(%eax),%eax
  801ab4:	8d 50 01             	lea    0x1(%eax),%edx
  801ab7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aba:	89 50 04             	mov    %edx,0x4(%eax)
}
  801abd:	90                   	nop
  801abe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ac1:	c9                   	leave  
  801ac2:	c3                   	ret    

00801ac3 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  801ac3:	55                   	push   %ebp
  801ac4:	89 e5                	mov    %esp,%ebp
  801ac6:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801acc:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801ad3:	00 00 00 
	b.cnt = 0;
  801ad6:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801add:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  801ae0:	ff 75 0c             	pushl  0xc(%ebp)
  801ae3:	ff 75 08             	pushl  0x8(%ebp)
  801ae6:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801aec:	50                   	push   %eax
  801aed:	68 52 1a 80 00       	push   $0x801a52
  801af2:	e8 5a 02 00 00       	call   801d51 <vprintfmt>
  801af7:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  801afa:	8b 15 1c e1 81 00    	mov    0x81e11c,%edx
  801b00:	a0 44 60 80 00       	mov    0x806044,%al
  801b05:	0f b6 c0             	movzbl %al,%eax
  801b08:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  801b0e:	52                   	push   %edx
  801b0f:	50                   	push   %eax
  801b10:	51                   	push   %ecx
  801b11:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801b17:	83 c0 08             	add    $0x8,%eax
  801b1a:	50                   	push   %eax
  801b1b:	e8 d9 10 00 00       	call   802bf9 <sys_cputs>
  801b20:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  801b23:	c6 05 44 60 80 00 00 	movb   $0x0,0x806044
	return b.cnt;
  801b2a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801b30:	c9                   	leave  
  801b31:	c3                   	ret    

00801b32 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  801b32:	55                   	push   %ebp
  801b33:	89 e5                	mov    %esp,%ebp
  801b35:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801b38:	c6 05 44 60 80 00 01 	movb   $0x1,0x806044
	va_start(ap, fmt);
  801b3f:	8d 45 0c             	lea    0xc(%ebp),%eax
  801b42:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801b45:	8b 45 08             	mov    0x8(%ebp),%eax
  801b48:	83 ec 08             	sub    $0x8,%esp
  801b4b:	ff 75 f4             	pushl  -0xc(%ebp)
  801b4e:	50                   	push   %eax
  801b4f:	e8 6f ff ff ff       	call   801ac3 <vcprintf>
  801b54:	83 c4 10             	add    $0x10,%esp
  801b57:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801b5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801b5d:	c9                   	leave  
  801b5e:	c3                   	ret    

00801b5f <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  801b5f:	55                   	push   %ebp
  801b60:	89 e5                	mov    %esp,%ebp
  801b62:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801b65:	c6 05 44 60 80 00 01 	movb   $0x1,0x806044
	curTextClr = (textClr << 8) ; //set text color by the given value
  801b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6f:	c1 e0 08             	shl    $0x8,%eax
  801b72:	a3 1c e1 81 00       	mov    %eax,0x81e11c
	va_start(ap, fmt);
  801b77:	8d 45 0c             	lea    0xc(%ebp),%eax
  801b7a:	83 c0 04             	add    $0x4,%eax
  801b7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801b80:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b83:	83 ec 08             	sub    $0x8,%esp
  801b86:	ff 75 f4             	pushl  -0xc(%ebp)
  801b89:	50                   	push   %eax
  801b8a:	e8 34 ff ff ff       	call   801ac3 <vcprintf>
  801b8f:	83 c4 10             	add    $0x10,%esp
  801b92:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  801b95:	c7 05 1c e1 81 00 00 	movl   $0x700,0x81e11c
  801b9c:	07 00 00 

	return cnt;
  801b9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801ba2:	c9                   	leave  
  801ba3:	c3                   	ret    

00801ba4 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  801ba4:	55                   	push   %ebp
  801ba5:	89 e5                	mov    %esp,%ebp
  801ba7:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  801baa:	e8 8e 10 00 00       	call   802c3d <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  801baf:	8d 45 0c             	lea    0xc(%ebp),%eax
  801bb2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  801bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb8:	83 ec 08             	sub    $0x8,%esp
  801bbb:	ff 75 f4             	pushl  -0xc(%ebp)
  801bbe:	50                   	push   %eax
  801bbf:	e8 ff fe ff ff       	call   801ac3 <vcprintf>
  801bc4:	83 c4 10             	add    $0x10,%esp
  801bc7:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  801bca:	e8 88 10 00 00       	call   802c57 <sys_unlock_cons>
	return cnt;
  801bcf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801bd2:	c9                   	leave  
  801bd3:	c3                   	ret    

00801bd4 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801bd4:	55                   	push   %ebp
  801bd5:	89 e5                	mov    %esp,%ebp
  801bd7:	53                   	push   %ebx
  801bd8:	83 ec 14             	sub    $0x14,%esp
  801bdb:	8b 45 10             	mov    0x10(%ebp),%eax
  801bde:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801be1:	8b 45 14             	mov    0x14(%ebp),%eax
  801be4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801be7:	8b 45 18             	mov    0x18(%ebp),%eax
  801bea:	ba 00 00 00 00       	mov    $0x0,%edx
  801bef:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801bf2:	77 55                	ja     801c49 <printnum+0x75>
  801bf4:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801bf7:	72 05                	jb     801bfe <printnum+0x2a>
  801bf9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801bfc:	77 4b                	ja     801c49 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801bfe:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801c01:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801c04:	8b 45 18             	mov    0x18(%ebp),%eax
  801c07:	ba 00 00 00 00       	mov    $0x0,%edx
  801c0c:	52                   	push   %edx
  801c0d:	50                   	push   %eax
  801c0e:	ff 75 f4             	pushl  -0xc(%ebp)
  801c11:	ff 75 f0             	pushl  -0x10(%ebp)
  801c14:	e8 67 17 00 00       	call   803380 <__udivdi3>
  801c19:	83 c4 10             	add    $0x10,%esp
  801c1c:	83 ec 04             	sub    $0x4,%esp
  801c1f:	ff 75 20             	pushl  0x20(%ebp)
  801c22:	53                   	push   %ebx
  801c23:	ff 75 18             	pushl  0x18(%ebp)
  801c26:	52                   	push   %edx
  801c27:	50                   	push   %eax
  801c28:	ff 75 0c             	pushl  0xc(%ebp)
  801c2b:	ff 75 08             	pushl  0x8(%ebp)
  801c2e:	e8 a1 ff ff ff       	call   801bd4 <printnum>
  801c33:	83 c4 20             	add    $0x20,%esp
  801c36:	eb 1a                	jmp    801c52 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801c38:	83 ec 08             	sub    $0x8,%esp
  801c3b:	ff 75 0c             	pushl  0xc(%ebp)
  801c3e:	ff 75 20             	pushl  0x20(%ebp)
  801c41:	8b 45 08             	mov    0x8(%ebp),%eax
  801c44:	ff d0                	call   *%eax
  801c46:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801c49:	ff 4d 1c             	decl   0x1c(%ebp)
  801c4c:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801c50:	7f e6                	jg     801c38 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801c52:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801c55:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c5d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c60:	53                   	push   %ebx
  801c61:	51                   	push   %ecx
  801c62:	52                   	push   %edx
  801c63:	50                   	push   %eax
  801c64:	e8 27 18 00 00       	call   803490 <__umoddi3>
  801c69:	83 c4 10             	add    $0x10,%esp
  801c6c:	05 54 4c 80 00       	add    $0x804c54,%eax
  801c71:	8a 00                	mov    (%eax),%al
  801c73:	0f be c0             	movsbl %al,%eax
  801c76:	83 ec 08             	sub    $0x8,%esp
  801c79:	ff 75 0c             	pushl  0xc(%ebp)
  801c7c:	50                   	push   %eax
  801c7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c80:	ff d0                	call   *%eax
  801c82:	83 c4 10             	add    $0x10,%esp
}
  801c85:	90                   	nop
  801c86:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c89:	c9                   	leave  
  801c8a:	c3                   	ret    

00801c8b <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801c8b:	55                   	push   %ebp
  801c8c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801c8e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801c92:	7e 1c                	jle    801cb0 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801c94:	8b 45 08             	mov    0x8(%ebp),%eax
  801c97:	8b 00                	mov    (%eax),%eax
  801c99:	8d 50 08             	lea    0x8(%eax),%edx
  801c9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9f:	89 10                	mov    %edx,(%eax)
  801ca1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca4:	8b 00                	mov    (%eax),%eax
  801ca6:	83 e8 08             	sub    $0x8,%eax
  801ca9:	8b 50 04             	mov    0x4(%eax),%edx
  801cac:	8b 00                	mov    (%eax),%eax
  801cae:	eb 40                	jmp    801cf0 <getuint+0x65>
	else if (lflag)
  801cb0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801cb4:	74 1e                	je     801cd4 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  801cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb9:	8b 00                	mov    (%eax),%eax
  801cbb:	8d 50 04             	lea    0x4(%eax),%edx
  801cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc1:	89 10                	mov    %edx,(%eax)
  801cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc6:	8b 00                	mov    (%eax),%eax
  801cc8:	83 e8 04             	sub    $0x4,%eax
  801ccb:	8b 00                	mov    (%eax),%eax
  801ccd:	ba 00 00 00 00       	mov    $0x0,%edx
  801cd2:	eb 1c                	jmp    801cf0 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801cd4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd7:	8b 00                	mov    (%eax),%eax
  801cd9:	8d 50 04             	lea    0x4(%eax),%edx
  801cdc:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdf:	89 10                	mov    %edx,(%eax)
  801ce1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce4:	8b 00                	mov    (%eax),%eax
  801ce6:	83 e8 04             	sub    $0x4,%eax
  801ce9:	8b 00                	mov    (%eax),%eax
  801ceb:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801cf0:	5d                   	pop    %ebp
  801cf1:	c3                   	ret    

00801cf2 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801cf2:	55                   	push   %ebp
  801cf3:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801cf5:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801cf9:	7e 1c                	jle    801d17 <getint+0x25>
		return va_arg(*ap, long long);
  801cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfe:	8b 00                	mov    (%eax),%eax
  801d00:	8d 50 08             	lea    0x8(%eax),%edx
  801d03:	8b 45 08             	mov    0x8(%ebp),%eax
  801d06:	89 10                	mov    %edx,(%eax)
  801d08:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0b:	8b 00                	mov    (%eax),%eax
  801d0d:	83 e8 08             	sub    $0x8,%eax
  801d10:	8b 50 04             	mov    0x4(%eax),%edx
  801d13:	8b 00                	mov    (%eax),%eax
  801d15:	eb 38                	jmp    801d4f <getint+0x5d>
	else if (lflag)
  801d17:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d1b:	74 1a                	je     801d37 <getint+0x45>
		return va_arg(*ap, long);
  801d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d20:	8b 00                	mov    (%eax),%eax
  801d22:	8d 50 04             	lea    0x4(%eax),%edx
  801d25:	8b 45 08             	mov    0x8(%ebp),%eax
  801d28:	89 10                	mov    %edx,(%eax)
  801d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2d:	8b 00                	mov    (%eax),%eax
  801d2f:	83 e8 04             	sub    $0x4,%eax
  801d32:	8b 00                	mov    (%eax),%eax
  801d34:	99                   	cltd   
  801d35:	eb 18                	jmp    801d4f <getint+0x5d>
	else
		return va_arg(*ap, int);
  801d37:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3a:	8b 00                	mov    (%eax),%eax
  801d3c:	8d 50 04             	lea    0x4(%eax),%edx
  801d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d42:	89 10                	mov    %edx,(%eax)
  801d44:	8b 45 08             	mov    0x8(%ebp),%eax
  801d47:	8b 00                	mov    (%eax),%eax
  801d49:	83 e8 04             	sub    $0x4,%eax
  801d4c:	8b 00                	mov    (%eax),%eax
  801d4e:	99                   	cltd   
}
  801d4f:	5d                   	pop    %ebp
  801d50:	c3                   	ret    

00801d51 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801d51:	55                   	push   %ebp
  801d52:	89 e5                	mov    %esp,%ebp
  801d54:	56                   	push   %esi
  801d55:	53                   	push   %ebx
  801d56:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801d59:	eb 17                	jmp    801d72 <vprintfmt+0x21>
			if (ch == '\0')
  801d5b:	85 db                	test   %ebx,%ebx
  801d5d:	0f 84 c1 03 00 00    	je     802124 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  801d63:	83 ec 08             	sub    $0x8,%esp
  801d66:	ff 75 0c             	pushl  0xc(%ebp)
  801d69:	53                   	push   %ebx
  801d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6d:	ff d0                	call   *%eax
  801d6f:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801d72:	8b 45 10             	mov    0x10(%ebp),%eax
  801d75:	8d 50 01             	lea    0x1(%eax),%edx
  801d78:	89 55 10             	mov    %edx,0x10(%ebp)
  801d7b:	8a 00                	mov    (%eax),%al
  801d7d:	0f b6 d8             	movzbl %al,%ebx
  801d80:	83 fb 25             	cmp    $0x25,%ebx
  801d83:	75 d6                	jne    801d5b <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801d85:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801d89:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801d90:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801d97:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801d9e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801da5:	8b 45 10             	mov    0x10(%ebp),%eax
  801da8:	8d 50 01             	lea    0x1(%eax),%edx
  801dab:	89 55 10             	mov    %edx,0x10(%ebp)
  801dae:	8a 00                	mov    (%eax),%al
  801db0:	0f b6 d8             	movzbl %al,%ebx
  801db3:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801db6:	83 f8 5b             	cmp    $0x5b,%eax
  801db9:	0f 87 3d 03 00 00    	ja     8020fc <vprintfmt+0x3ab>
  801dbf:	8b 04 85 78 4c 80 00 	mov    0x804c78(,%eax,4),%eax
  801dc6:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801dc8:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801dcc:	eb d7                	jmp    801da5 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801dce:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801dd2:	eb d1                	jmp    801da5 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801dd4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801ddb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801dde:	89 d0                	mov    %edx,%eax
  801de0:	c1 e0 02             	shl    $0x2,%eax
  801de3:	01 d0                	add    %edx,%eax
  801de5:	01 c0                	add    %eax,%eax
  801de7:	01 d8                	add    %ebx,%eax
  801de9:	83 e8 30             	sub    $0x30,%eax
  801dec:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801def:	8b 45 10             	mov    0x10(%ebp),%eax
  801df2:	8a 00                	mov    (%eax),%al
  801df4:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801df7:	83 fb 2f             	cmp    $0x2f,%ebx
  801dfa:	7e 3e                	jle    801e3a <vprintfmt+0xe9>
  801dfc:	83 fb 39             	cmp    $0x39,%ebx
  801dff:	7f 39                	jg     801e3a <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801e01:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801e04:	eb d5                	jmp    801ddb <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801e06:	8b 45 14             	mov    0x14(%ebp),%eax
  801e09:	83 c0 04             	add    $0x4,%eax
  801e0c:	89 45 14             	mov    %eax,0x14(%ebp)
  801e0f:	8b 45 14             	mov    0x14(%ebp),%eax
  801e12:	83 e8 04             	sub    $0x4,%eax
  801e15:	8b 00                	mov    (%eax),%eax
  801e17:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801e1a:	eb 1f                	jmp    801e3b <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801e1c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801e20:	79 83                	jns    801da5 <vprintfmt+0x54>
				width = 0;
  801e22:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801e29:	e9 77 ff ff ff       	jmp    801da5 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801e2e:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801e35:	e9 6b ff ff ff       	jmp    801da5 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801e3a:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801e3b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801e3f:	0f 89 60 ff ff ff    	jns    801da5 <vprintfmt+0x54>
				width = precision, precision = -1;
  801e45:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e48:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801e4b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801e52:	e9 4e ff ff ff       	jmp    801da5 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801e57:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801e5a:	e9 46 ff ff ff       	jmp    801da5 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801e5f:	8b 45 14             	mov    0x14(%ebp),%eax
  801e62:	83 c0 04             	add    $0x4,%eax
  801e65:	89 45 14             	mov    %eax,0x14(%ebp)
  801e68:	8b 45 14             	mov    0x14(%ebp),%eax
  801e6b:	83 e8 04             	sub    $0x4,%eax
  801e6e:	8b 00                	mov    (%eax),%eax
  801e70:	83 ec 08             	sub    $0x8,%esp
  801e73:	ff 75 0c             	pushl  0xc(%ebp)
  801e76:	50                   	push   %eax
  801e77:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7a:	ff d0                	call   *%eax
  801e7c:	83 c4 10             	add    $0x10,%esp
			break;
  801e7f:	e9 9b 02 00 00       	jmp    80211f <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801e84:	8b 45 14             	mov    0x14(%ebp),%eax
  801e87:	83 c0 04             	add    $0x4,%eax
  801e8a:	89 45 14             	mov    %eax,0x14(%ebp)
  801e8d:	8b 45 14             	mov    0x14(%ebp),%eax
  801e90:	83 e8 04             	sub    $0x4,%eax
  801e93:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801e95:	85 db                	test   %ebx,%ebx
  801e97:	79 02                	jns    801e9b <vprintfmt+0x14a>
				err = -err;
  801e99:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801e9b:	83 fb 64             	cmp    $0x64,%ebx
  801e9e:	7f 0b                	jg     801eab <vprintfmt+0x15a>
  801ea0:	8b 34 9d c0 4a 80 00 	mov    0x804ac0(,%ebx,4),%esi
  801ea7:	85 f6                	test   %esi,%esi
  801ea9:	75 19                	jne    801ec4 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801eab:	53                   	push   %ebx
  801eac:	68 65 4c 80 00       	push   $0x804c65
  801eb1:	ff 75 0c             	pushl  0xc(%ebp)
  801eb4:	ff 75 08             	pushl  0x8(%ebp)
  801eb7:	e8 70 02 00 00       	call   80212c <printfmt>
  801ebc:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801ebf:	e9 5b 02 00 00       	jmp    80211f <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801ec4:	56                   	push   %esi
  801ec5:	68 6e 4c 80 00       	push   $0x804c6e
  801eca:	ff 75 0c             	pushl  0xc(%ebp)
  801ecd:	ff 75 08             	pushl  0x8(%ebp)
  801ed0:	e8 57 02 00 00       	call   80212c <printfmt>
  801ed5:	83 c4 10             	add    $0x10,%esp
			break;
  801ed8:	e9 42 02 00 00       	jmp    80211f <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801edd:	8b 45 14             	mov    0x14(%ebp),%eax
  801ee0:	83 c0 04             	add    $0x4,%eax
  801ee3:	89 45 14             	mov    %eax,0x14(%ebp)
  801ee6:	8b 45 14             	mov    0x14(%ebp),%eax
  801ee9:	83 e8 04             	sub    $0x4,%eax
  801eec:	8b 30                	mov    (%eax),%esi
  801eee:	85 f6                	test   %esi,%esi
  801ef0:	75 05                	jne    801ef7 <vprintfmt+0x1a6>
				p = "(null)";
  801ef2:	be 71 4c 80 00       	mov    $0x804c71,%esi
			if (width > 0 && padc != '-')
  801ef7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801efb:	7e 6d                	jle    801f6a <vprintfmt+0x219>
  801efd:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801f01:	74 67                	je     801f6a <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801f03:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f06:	83 ec 08             	sub    $0x8,%esp
  801f09:	50                   	push   %eax
  801f0a:	56                   	push   %esi
  801f0b:	e8 1e 03 00 00       	call   80222e <strnlen>
  801f10:	83 c4 10             	add    $0x10,%esp
  801f13:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801f16:	eb 16                	jmp    801f2e <vprintfmt+0x1dd>
					putch(padc, putdat);
  801f18:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801f1c:	83 ec 08             	sub    $0x8,%esp
  801f1f:	ff 75 0c             	pushl  0xc(%ebp)
  801f22:	50                   	push   %eax
  801f23:	8b 45 08             	mov    0x8(%ebp),%eax
  801f26:	ff d0                	call   *%eax
  801f28:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801f2b:	ff 4d e4             	decl   -0x1c(%ebp)
  801f2e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801f32:	7f e4                	jg     801f18 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801f34:	eb 34                	jmp    801f6a <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801f36:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801f3a:	74 1c                	je     801f58 <vprintfmt+0x207>
  801f3c:	83 fb 1f             	cmp    $0x1f,%ebx
  801f3f:	7e 05                	jle    801f46 <vprintfmt+0x1f5>
  801f41:	83 fb 7e             	cmp    $0x7e,%ebx
  801f44:	7e 12                	jle    801f58 <vprintfmt+0x207>
					putch('?', putdat);
  801f46:	83 ec 08             	sub    $0x8,%esp
  801f49:	ff 75 0c             	pushl  0xc(%ebp)
  801f4c:	6a 3f                	push   $0x3f
  801f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f51:	ff d0                	call   *%eax
  801f53:	83 c4 10             	add    $0x10,%esp
  801f56:	eb 0f                	jmp    801f67 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801f58:	83 ec 08             	sub    $0x8,%esp
  801f5b:	ff 75 0c             	pushl  0xc(%ebp)
  801f5e:	53                   	push   %ebx
  801f5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f62:	ff d0                	call   *%eax
  801f64:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801f67:	ff 4d e4             	decl   -0x1c(%ebp)
  801f6a:	89 f0                	mov    %esi,%eax
  801f6c:	8d 70 01             	lea    0x1(%eax),%esi
  801f6f:	8a 00                	mov    (%eax),%al
  801f71:	0f be d8             	movsbl %al,%ebx
  801f74:	85 db                	test   %ebx,%ebx
  801f76:	74 24                	je     801f9c <vprintfmt+0x24b>
  801f78:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801f7c:	78 b8                	js     801f36 <vprintfmt+0x1e5>
  801f7e:	ff 4d e0             	decl   -0x20(%ebp)
  801f81:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801f85:	79 af                	jns    801f36 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801f87:	eb 13                	jmp    801f9c <vprintfmt+0x24b>
				putch(' ', putdat);
  801f89:	83 ec 08             	sub    $0x8,%esp
  801f8c:	ff 75 0c             	pushl  0xc(%ebp)
  801f8f:	6a 20                	push   $0x20
  801f91:	8b 45 08             	mov    0x8(%ebp),%eax
  801f94:	ff d0                	call   *%eax
  801f96:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801f99:	ff 4d e4             	decl   -0x1c(%ebp)
  801f9c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801fa0:	7f e7                	jg     801f89 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801fa2:	e9 78 01 00 00       	jmp    80211f <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801fa7:	83 ec 08             	sub    $0x8,%esp
  801faa:	ff 75 e8             	pushl  -0x18(%ebp)
  801fad:	8d 45 14             	lea    0x14(%ebp),%eax
  801fb0:	50                   	push   %eax
  801fb1:	e8 3c fd ff ff       	call   801cf2 <getint>
  801fb6:	83 c4 10             	add    $0x10,%esp
  801fb9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801fbc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801fbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fc2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fc5:	85 d2                	test   %edx,%edx
  801fc7:	79 23                	jns    801fec <vprintfmt+0x29b>
				putch('-', putdat);
  801fc9:	83 ec 08             	sub    $0x8,%esp
  801fcc:	ff 75 0c             	pushl  0xc(%ebp)
  801fcf:	6a 2d                	push   $0x2d
  801fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd4:	ff d0                	call   *%eax
  801fd6:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801fd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fdc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fdf:	f7 d8                	neg    %eax
  801fe1:	83 d2 00             	adc    $0x0,%edx
  801fe4:	f7 da                	neg    %edx
  801fe6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801fe9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801fec:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801ff3:	e9 bc 00 00 00       	jmp    8020b4 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801ff8:	83 ec 08             	sub    $0x8,%esp
  801ffb:	ff 75 e8             	pushl  -0x18(%ebp)
  801ffe:	8d 45 14             	lea    0x14(%ebp),%eax
  802001:	50                   	push   %eax
  802002:	e8 84 fc ff ff       	call   801c8b <getuint>
  802007:	83 c4 10             	add    $0x10,%esp
  80200a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80200d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  802010:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  802017:	e9 98 00 00 00       	jmp    8020b4 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80201c:	83 ec 08             	sub    $0x8,%esp
  80201f:	ff 75 0c             	pushl  0xc(%ebp)
  802022:	6a 58                	push   $0x58
  802024:	8b 45 08             	mov    0x8(%ebp),%eax
  802027:	ff d0                	call   *%eax
  802029:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80202c:	83 ec 08             	sub    $0x8,%esp
  80202f:	ff 75 0c             	pushl  0xc(%ebp)
  802032:	6a 58                	push   $0x58
  802034:	8b 45 08             	mov    0x8(%ebp),%eax
  802037:	ff d0                	call   *%eax
  802039:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80203c:	83 ec 08             	sub    $0x8,%esp
  80203f:	ff 75 0c             	pushl  0xc(%ebp)
  802042:	6a 58                	push   $0x58
  802044:	8b 45 08             	mov    0x8(%ebp),%eax
  802047:	ff d0                	call   *%eax
  802049:	83 c4 10             	add    $0x10,%esp
			break;
  80204c:	e9 ce 00 00 00       	jmp    80211f <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  802051:	83 ec 08             	sub    $0x8,%esp
  802054:	ff 75 0c             	pushl  0xc(%ebp)
  802057:	6a 30                	push   $0x30
  802059:	8b 45 08             	mov    0x8(%ebp),%eax
  80205c:	ff d0                	call   *%eax
  80205e:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  802061:	83 ec 08             	sub    $0x8,%esp
  802064:	ff 75 0c             	pushl  0xc(%ebp)
  802067:	6a 78                	push   $0x78
  802069:	8b 45 08             	mov    0x8(%ebp),%eax
  80206c:	ff d0                	call   *%eax
  80206e:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  802071:	8b 45 14             	mov    0x14(%ebp),%eax
  802074:	83 c0 04             	add    $0x4,%eax
  802077:	89 45 14             	mov    %eax,0x14(%ebp)
  80207a:	8b 45 14             	mov    0x14(%ebp),%eax
  80207d:	83 e8 04             	sub    $0x4,%eax
  802080:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  802082:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802085:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80208c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  802093:	eb 1f                	jmp    8020b4 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  802095:	83 ec 08             	sub    $0x8,%esp
  802098:	ff 75 e8             	pushl  -0x18(%ebp)
  80209b:	8d 45 14             	lea    0x14(%ebp),%eax
  80209e:	50                   	push   %eax
  80209f:	e8 e7 fb ff ff       	call   801c8b <getuint>
  8020a4:	83 c4 10             	add    $0x10,%esp
  8020a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8020aa:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8020ad:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8020b4:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8020b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020bb:	83 ec 04             	sub    $0x4,%esp
  8020be:	52                   	push   %edx
  8020bf:	ff 75 e4             	pushl  -0x1c(%ebp)
  8020c2:	50                   	push   %eax
  8020c3:	ff 75 f4             	pushl  -0xc(%ebp)
  8020c6:	ff 75 f0             	pushl  -0x10(%ebp)
  8020c9:	ff 75 0c             	pushl  0xc(%ebp)
  8020cc:	ff 75 08             	pushl  0x8(%ebp)
  8020cf:	e8 00 fb ff ff       	call   801bd4 <printnum>
  8020d4:	83 c4 20             	add    $0x20,%esp
			break;
  8020d7:	eb 46                	jmp    80211f <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8020d9:	83 ec 08             	sub    $0x8,%esp
  8020dc:	ff 75 0c             	pushl  0xc(%ebp)
  8020df:	53                   	push   %ebx
  8020e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e3:	ff d0                	call   *%eax
  8020e5:	83 c4 10             	add    $0x10,%esp
			break;
  8020e8:	eb 35                	jmp    80211f <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8020ea:	c6 05 44 60 80 00 00 	movb   $0x0,0x806044
			break;
  8020f1:	eb 2c                	jmp    80211f <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8020f3:	c6 05 44 60 80 00 01 	movb   $0x1,0x806044
			break;
  8020fa:	eb 23                	jmp    80211f <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8020fc:	83 ec 08             	sub    $0x8,%esp
  8020ff:	ff 75 0c             	pushl  0xc(%ebp)
  802102:	6a 25                	push   $0x25
  802104:	8b 45 08             	mov    0x8(%ebp),%eax
  802107:	ff d0                	call   *%eax
  802109:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80210c:	ff 4d 10             	decl   0x10(%ebp)
  80210f:	eb 03                	jmp    802114 <vprintfmt+0x3c3>
  802111:	ff 4d 10             	decl   0x10(%ebp)
  802114:	8b 45 10             	mov    0x10(%ebp),%eax
  802117:	48                   	dec    %eax
  802118:	8a 00                	mov    (%eax),%al
  80211a:	3c 25                	cmp    $0x25,%al
  80211c:	75 f3                	jne    802111 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  80211e:	90                   	nop
		}
	}
  80211f:	e9 35 fc ff ff       	jmp    801d59 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  802124:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  802125:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802128:	5b                   	pop    %ebx
  802129:	5e                   	pop    %esi
  80212a:	5d                   	pop    %ebp
  80212b:	c3                   	ret    

0080212c <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80212c:	55                   	push   %ebp
  80212d:	89 e5                	mov    %esp,%ebp
  80212f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  802132:	8d 45 10             	lea    0x10(%ebp),%eax
  802135:	83 c0 04             	add    $0x4,%eax
  802138:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80213b:	8b 45 10             	mov    0x10(%ebp),%eax
  80213e:	ff 75 f4             	pushl  -0xc(%ebp)
  802141:	50                   	push   %eax
  802142:	ff 75 0c             	pushl  0xc(%ebp)
  802145:	ff 75 08             	pushl  0x8(%ebp)
  802148:	e8 04 fc ff ff       	call   801d51 <vprintfmt>
  80214d:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  802150:	90                   	nop
  802151:	c9                   	leave  
  802152:	c3                   	ret    

00802153 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  802153:	55                   	push   %ebp
  802154:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  802156:	8b 45 0c             	mov    0xc(%ebp),%eax
  802159:	8b 40 08             	mov    0x8(%eax),%eax
  80215c:	8d 50 01             	lea    0x1(%eax),%edx
  80215f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802162:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  802165:	8b 45 0c             	mov    0xc(%ebp),%eax
  802168:	8b 10                	mov    (%eax),%edx
  80216a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80216d:	8b 40 04             	mov    0x4(%eax),%eax
  802170:	39 c2                	cmp    %eax,%edx
  802172:	73 12                	jae    802186 <sprintputch+0x33>
		*b->buf++ = ch;
  802174:	8b 45 0c             	mov    0xc(%ebp),%eax
  802177:	8b 00                	mov    (%eax),%eax
  802179:	8d 48 01             	lea    0x1(%eax),%ecx
  80217c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80217f:	89 0a                	mov    %ecx,(%edx)
  802181:	8b 55 08             	mov    0x8(%ebp),%edx
  802184:	88 10                	mov    %dl,(%eax)
}
  802186:	90                   	nop
  802187:	5d                   	pop    %ebp
  802188:	c3                   	ret    

00802189 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  802189:	55                   	push   %ebp
  80218a:	89 e5                	mov    %esp,%ebp
  80218c:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80218f:	8b 45 08             	mov    0x8(%ebp),%eax
  802192:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802195:	8b 45 0c             	mov    0xc(%ebp),%eax
  802198:	8d 50 ff             	lea    -0x1(%eax),%edx
  80219b:	8b 45 08             	mov    0x8(%ebp),%eax
  80219e:	01 d0                	add    %edx,%eax
  8021a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8021a3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8021aa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021ae:	74 06                	je     8021b6 <vsnprintf+0x2d>
  8021b0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8021b4:	7f 07                	jg     8021bd <vsnprintf+0x34>
		return -E_INVAL;
  8021b6:	b8 03 00 00 00       	mov    $0x3,%eax
  8021bb:	eb 20                	jmp    8021dd <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8021bd:	ff 75 14             	pushl  0x14(%ebp)
  8021c0:	ff 75 10             	pushl  0x10(%ebp)
  8021c3:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8021c6:	50                   	push   %eax
  8021c7:	68 53 21 80 00       	push   $0x802153
  8021cc:	e8 80 fb ff ff       	call   801d51 <vprintfmt>
  8021d1:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8021d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021d7:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8021da:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8021dd:	c9                   	leave  
  8021de:	c3                   	ret    

008021df <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8021df:	55                   	push   %ebp
  8021e0:	89 e5                	mov    %esp,%ebp
  8021e2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8021e5:	8d 45 10             	lea    0x10(%ebp),%eax
  8021e8:	83 c0 04             	add    $0x4,%eax
  8021eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8021ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8021f1:	ff 75 f4             	pushl  -0xc(%ebp)
  8021f4:	50                   	push   %eax
  8021f5:	ff 75 0c             	pushl  0xc(%ebp)
  8021f8:	ff 75 08             	pushl  0x8(%ebp)
  8021fb:	e8 89 ff ff ff       	call   802189 <vsnprintf>
  802200:	83 c4 10             	add    $0x10,%esp
  802203:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  802206:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802209:	c9                   	leave  
  80220a:	c3                   	ret    

0080220b <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80220b:	55                   	push   %ebp
  80220c:	89 e5                	mov    %esp,%ebp
  80220e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  802211:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802218:	eb 06                	jmp    802220 <strlen+0x15>
		n++;
  80221a:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80221d:	ff 45 08             	incl   0x8(%ebp)
  802220:	8b 45 08             	mov    0x8(%ebp),%eax
  802223:	8a 00                	mov    (%eax),%al
  802225:	84 c0                	test   %al,%al
  802227:	75 f1                	jne    80221a <strlen+0xf>
		n++;
	return n;
  802229:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80222c:	c9                   	leave  
  80222d:	c3                   	ret    

0080222e <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80222e:	55                   	push   %ebp
  80222f:	89 e5                	mov    %esp,%ebp
  802231:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802234:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80223b:	eb 09                	jmp    802246 <strnlen+0x18>
		n++;
  80223d:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802240:	ff 45 08             	incl   0x8(%ebp)
  802243:	ff 4d 0c             	decl   0xc(%ebp)
  802246:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80224a:	74 09                	je     802255 <strnlen+0x27>
  80224c:	8b 45 08             	mov    0x8(%ebp),%eax
  80224f:	8a 00                	mov    (%eax),%al
  802251:	84 c0                	test   %al,%al
  802253:	75 e8                	jne    80223d <strnlen+0xf>
		n++;
	return n;
  802255:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802258:	c9                   	leave  
  802259:	c3                   	ret    

0080225a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80225a:	55                   	push   %ebp
  80225b:	89 e5                	mov    %esp,%ebp
  80225d:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  802260:	8b 45 08             	mov    0x8(%ebp),%eax
  802263:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  802266:	90                   	nop
  802267:	8b 45 08             	mov    0x8(%ebp),%eax
  80226a:	8d 50 01             	lea    0x1(%eax),%edx
  80226d:	89 55 08             	mov    %edx,0x8(%ebp)
  802270:	8b 55 0c             	mov    0xc(%ebp),%edx
  802273:	8d 4a 01             	lea    0x1(%edx),%ecx
  802276:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  802279:	8a 12                	mov    (%edx),%dl
  80227b:	88 10                	mov    %dl,(%eax)
  80227d:	8a 00                	mov    (%eax),%al
  80227f:	84 c0                	test   %al,%al
  802281:	75 e4                	jne    802267 <strcpy+0xd>
		/* do nothing */;
	return ret;
  802283:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802286:	c9                   	leave  
  802287:	c3                   	ret    

00802288 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  802288:	55                   	push   %ebp
  802289:	89 e5                	mov    %esp,%ebp
  80228b:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80228e:	8b 45 08             	mov    0x8(%ebp),%eax
  802291:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  802294:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80229b:	eb 1f                	jmp    8022bc <strncpy+0x34>
		*dst++ = *src;
  80229d:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a0:	8d 50 01             	lea    0x1(%eax),%edx
  8022a3:	89 55 08             	mov    %edx,0x8(%ebp)
  8022a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022a9:	8a 12                	mov    (%edx),%dl
  8022ab:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8022ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022b0:	8a 00                	mov    (%eax),%al
  8022b2:	84 c0                	test   %al,%al
  8022b4:	74 03                	je     8022b9 <strncpy+0x31>
			src++;
  8022b6:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8022b9:	ff 45 fc             	incl   -0x4(%ebp)
  8022bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022bf:	3b 45 10             	cmp    0x10(%ebp),%eax
  8022c2:	72 d9                	jb     80229d <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8022c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8022c7:	c9                   	leave  
  8022c8:	c3                   	ret    

008022c9 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8022c9:	55                   	push   %ebp
  8022ca:	89 e5                	mov    %esp,%ebp
  8022cc:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8022cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8022d5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8022d9:	74 30                	je     80230b <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8022db:	eb 16                	jmp    8022f3 <strlcpy+0x2a>
			*dst++ = *src++;
  8022dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e0:	8d 50 01             	lea    0x1(%eax),%edx
  8022e3:	89 55 08             	mov    %edx,0x8(%ebp)
  8022e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022e9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8022ec:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8022ef:	8a 12                	mov    (%edx),%dl
  8022f1:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8022f3:	ff 4d 10             	decl   0x10(%ebp)
  8022f6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8022fa:	74 09                	je     802305 <strlcpy+0x3c>
  8022fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022ff:	8a 00                	mov    (%eax),%al
  802301:	84 c0                	test   %al,%al
  802303:	75 d8                	jne    8022dd <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  802305:	8b 45 08             	mov    0x8(%ebp),%eax
  802308:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80230b:	8b 55 08             	mov    0x8(%ebp),%edx
  80230e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802311:	29 c2                	sub    %eax,%edx
  802313:	89 d0                	mov    %edx,%eax
}
  802315:	c9                   	leave  
  802316:	c3                   	ret    

00802317 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  802317:	55                   	push   %ebp
  802318:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80231a:	eb 06                	jmp    802322 <strcmp+0xb>
		p++, q++;
  80231c:	ff 45 08             	incl   0x8(%ebp)
  80231f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  802322:	8b 45 08             	mov    0x8(%ebp),%eax
  802325:	8a 00                	mov    (%eax),%al
  802327:	84 c0                	test   %al,%al
  802329:	74 0e                	je     802339 <strcmp+0x22>
  80232b:	8b 45 08             	mov    0x8(%ebp),%eax
  80232e:	8a 10                	mov    (%eax),%dl
  802330:	8b 45 0c             	mov    0xc(%ebp),%eax
  802333:	8a 00                	mov    (%eax),%al
  802335:	38 c2                	cmp    %al,%dl
  802337:	74 e3                	je     80231c <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  802339:	8b 45 08             	mov    0x8(%ebp),%eax
  80233c:	8a 00                	mov    (%eax),%al
  80233e:	0f b6 d0             	movzbl %al,%edx
  802341:	8b 45 0c             	mov    0xc(%ebp),%eax
  802344:	8a 00                	mov    (%eax),%al
  802346:	0f b6 c0             	movzbl %al,%eax
  802349:	29 c2                	sub    %eax,%edx
  80234b:	89 d0                	mov    %edx,%eax
}
  80234d:	5d                   	pop    %ebp
  80234e:	c3                   	ret    

0080234f <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80234f:	55                   	push   %ebp
  802350:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  802352:	eb 09                	jmp    80235d <strncmp+0xe>
		n--, p++, q++;
  802354:	ff 4d 10             	decl   0x10(%ebp)
  802357:	ff 45 08             	incl   0x8(%ebp)
  80235a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80235d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802361:	74 17                	je     80237a <strncmp+0x2b>
  802363:	8b 45 08             	mov    0x8(%ebp),%eax
  802366:	8a 00                	mov    (%eax),%al
  802368:	84 c0                	test   %al,%al
  80236a:	74 0e                	je     80237a <strncmp+0x2b>
  80236c:	8b 45 08             	mov    0x8(%ebp),%eax
  80236f:	8a 10                	mov    (%eax),%dl
  802371:	8b 45 0c             	mov    0xc(%ebp),%eax
  802374:	8a 00                	mov    (%eax),%al
  802376:	38 c2                	cmp    %al,%dl
  802378:	74 da                	je     802354 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80237a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80237e:	75 07                	jne    802387 <strncmp+0x38>
		return 0;
  802380:	b8 00 00 00 00       	mov    $0x0,%eax
  802385:	eb 14                	jmp    80239b <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  802387:	8b 45 08             	mov    0x8(%ebp),%eax
  80238a:	8a 00                	mov    (%eax),%al
  80238c:	0f b6 d0             	movzbl %al,%edx
  80238f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802392:	8a 00                	mov    (%eax),%al
  802394:	0f b6 c0             	movzbl %al,%eax
  802397:	29 c2                	sub    %eax,%edx
  802399:	89 d0                	mov    %edx,%eax
}
  80239b:	5d                   	pop    %ebp
  80239c:	c3                   	ret    

0080239d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80239d:	55                   	push   %ebp
  80239e:	89 e5                	mov    %esp,%ebp
  8023a0:	83 ec 04             	sub    $0x4,%esp
  8023a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023a6:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8023a9:	eb 12                	jmp    8023bd <strchr+0x20>
		if (*s == c)
  8023ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ae:	8a 00                	mov    (%eax),%al
  8023b0:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8023b3:	75 05                	jne    8023ba <strchr+0x1d>
			return (char *) s;
  8023b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b8:	eb 11                	jmp    8023cb <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8023ba:	ff 45 08             	incl   0x8(%ebp)
  8023bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c0:	8a 00                	mov    (%eax),%al
  8023c2:	84 c0                	test   %al,%al
  8023c4:	75 e5                	jne    8023ab <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8023c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023cb:	c9                   	leave  
  8023cc:	c3                   	ret    

008023cd <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8023cd:	55                   	push   %ebp
  8023ce:	89 e5                	mov    %esp,%ebp
  8023d0:	83 ec 04             	sub    $0x4,%esp
  8023d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023d6:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8023d9:	eb 0d                	jmp    8023e8 <strfind+0x1b>
		if (*s == c)
  8023db:	8b 45 08             	mov    0x8(%ebp),%eax
  8023de:	8a 00                	mov    (%eax),%al
  8023e0:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8023e3:	74 0e                	je     8023f3 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8023e5:	ff 45 08             	incl   0x8(%ebp)
  8023e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023eb:	8a 00                	mov    (%eax),%al
  8023ed:	84 c0                	test   %al,%al
  8023ef:	75 ea                	jne    8023db <strfind+0xe>
  8023f1:	eb 01                	jmp    8023f4 <strfind+0x27>
		if (*s == c)
			break;
  8023f3:	90                   	nop
	return (char *) s;
  8023f4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8023f7:	c9                   	leave  
  8023f8:	c3                   	ret    

008023f9 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  8023f9:	55                   	push   %ebp
  8023fa:	89 e5                	mov    %esp,%ebp
  8023fc:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  8023ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802402:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  802405:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  802409:	76 63                	jbe    80246e <memset+0x75>
		uint64 data_block = c;
  80240b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80240e:	99                   	cltd   
  80240f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802412:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  802415:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802418:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80241b:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  80241f:	c1 e0 08             	shl    $0x8,%eax
  802422:	09 45 f0             	or     %eax,-0x10(%ebp)
  802425:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  802428:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80242b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80242e:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  802432:	c1 e0 10             	shl    $0x10,%eax
  802435:	09 45 f0             	or     %eax,-0x10(%ebp)
  802438:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  80243b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80243e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802441:	89 c2                	mov    %eax,%edx
  802443:	b8 00 00 00 00       	mov    $0x0,%eax
  802448:	09 45 f0             	or     %eax,-0x10(%ebp)
  80244b:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  80244e:	eb 18                	jmp    802468 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  802450:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802453:	8d 41 08             	lea    0x8(%ecx),%eax
  802456:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802459:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80245c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80245f:	89 01                	mov    %eax,(%ecx)
  802461:	89 51 04             	mov    %edx,0x4(%ecx)
  802464:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  802468:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80246c:	77 e2                	ja     802450 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  80246e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802472:	74 23                	je     802497 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  802474:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802477:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  80247a:	eb 0e                	jmp    80248a <memset+0x91>
			*p8++ = (uint8)c;
  80247c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80247f:	8d 50 01             	lea    0x1(%eax),%edx
  802482:	89 55 f8             	mov    %edx,-0x8(%ebp)
  802485:	8b 55 0c             	mov    0xc(%ebp),%edx
  802488:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  80248a:	8b 45 10             	mov    0x10(%ebp),%eax
  80248d:	8d 50 ff             	lea    -0x1(%eax),%edx
  802490:	89 55 10             	mov    %edx,0x10(%ebp)
  802493:	85 c0                	test   %eax,%eax
  802495:	75 e5                	jne    80247c <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  802497:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80249a:	c9                   	leave  
  80249b:	c3                   	ret    

0080249c <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80249c:	55                   	push   %ebp
  80249d:	89 e5                	mov    %esp,%ebp
  80249f:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8024a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024a5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8024a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ab:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8024ae:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8024b2:	76 24                	jbe    8024d8 <memcpy+0x3c>
		while(n >= 8){
  8024b4:	eb 1c                	jmp    8024d2 <memcpy+0x36>
			*d64 = *s64;
  8024b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024b9:	8b 50 04             	mov    0x4(%eax),%edx
  8024bc:	8b 00                	mov    (%eax),%eax
  8024be:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8024c1:	89 01                	mov    %eax,(%ecx)
  8024c3:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8024c6:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8024ca:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8024ce:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8024d2:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8024d6:	77 de                	ja     8024b6 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8024d8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8024dc:	74 31                	je     80250f <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8024de:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8024e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8024e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8024ea:	eb 16                	jmp    802502 <memcpy+0x66>
			*d8++ = *s8++;
  8024ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024ef:	8d 50 01             	lea    0x1(%eax),%edx
  8024f2:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8024f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024f8:	8d 4a 01             	lea    0x1(%edx),%ecx
  8024fb:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8024fe:	8a 12                	mov    (%edx),%dl
  802500:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  802502:	8b 45 10             	mov    0x10(%ebp),%eax
  802505:	8d 50 ff             	lea    -0x1(%eax),%edx
  802508:	89 55 10             	mov    %edx,0x10(%ebp)
  80250b:	85 c0                	test   %eax,%eax
  80250d:	75 dd                	jne    8024ec <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  80250f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802512:	c9                   	leave  
  802513:	c3                   	ret    

00802514 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  802514:	55                   	push   %ebp
  802515:	89 e5                	mov    %esp,%ebp
  802517:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80251a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80251d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  802520:	8b 45 08             	mov    0x8(%ebp),%eax
  802523:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  802526:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802529:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80252c:	73 50                	jae    80257e <memmove+0x6a>
  80252e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802531:	8b 45 10             	mov    0x10(%ebp),%eax
  802534:	01 d0                	add    %edx,%eax
  802536:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802539:	76 43                	jbe    80257e <memmove+0x6a>
		s += n;
  80253b:	8b 45 10             	mov    0x10(%ebp),%eax
  80253e:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  802541:	8b 45 10             	mov    0x10(%ebp),%eax
  802544:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  802547:	eb 10                	jmp    802559 <memmove+0x45>
			*--d = *--s;
  802549:	ff 4d f8             	decl   -0x8(%ebp)
  80254c:	ff 4d fc             	decl   -0x4(%ebp)
  80254f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802552:	8a 10                	mov    (%eax),%dl
  802554:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802557:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  802559:	8b 45 10             	mov    0x10(%ebp),%eax
  80255c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80255f:	89 55 10             	mov    %edx,0x10(%ebp)
  802562:	85 c0                	test   %eax,%eax
  802564:	75 e3                	jne    802549 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  802566:	eb 23                	jmp    80258b <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  802568:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80256b:	8d 50 01             	lea    0x1(%eax),%edx
  80256e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  802571:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802574:	8d 4a 01             	lea    0x1(%edx),%ecx
  802577:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80257a:	8a 12                	mov    (%edx),%dl
  80257c:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80257e:	8b 45 10             	mov    0x10(%ebp),%eax
  802581:	8d 50 ff             	lea    -0x1(%eax),%edx
  802584:	89 55 10             	mov    %edx,0x10(%ebp)
  802587:	85 c0                	test   %eax,%eax
  802589:	75 dd                	jne    802568 <memmove+0x54>
			*d++ = *s++;

	return dst;
  80258b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80258e:	c9                   	leave  
  80258f:	c3                   	ret    

00802590 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  802590:	55                   	push   %ebp
  802591:	89 e5                	mov    %esp,%ebp
  802593:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  802596:	8b 45 08             	mov    0x8(%ebp),%eax
  802599:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80259c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80259f:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8025a2:	eb 2a                	jmp    8025ce <memcmp+0x3e>
		if (*s1 != *s2)
  8025a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025a7:	8a 10                	mov    (%eax),%dl
  8025a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8025ac:	8a 00                	mov    (%eax),%al
  8025ae:	38 c2                	cmp    %al,%dl
  8025b0:	74 16                	je     8025c8 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8025b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025b5:	8a 00                	mov    (%eax),%al
  8025b7:	0f b6 d0             	movzbl %al,%edx
  8025ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8025bd:	8a 00                	mov    (%eax),%al
  8025bf:	0f b6 c0             	movzbl %al,%eax
  8025c2:	29 c2                	sub    %eax,%edx
  8025c4:	89 d0                	mov    %edx,%eax
  8025c6:	eb 18                	jmp    8025e0 <memcmp+0x50>
		s1++, s2++;
  8025c8:	ff 45 fc             	incl   -0x4(%ebp)
  8025cb:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8025ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8025d1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8025d4:	89 55 10             	mov    %edx,0x10(%ebp)
  8025d7:	85 c0                	test   %eax,%eax
  8025d9:	75 c9                	jne    8025a4 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8025db:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025e0:	c9                   	leave  
  8025e1:	c3                   	ret    

008025e2 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8025e2:	55                   	push   %ebp
  8025e3:	89 e5                	mov    %esp,%ebp
  8025e5:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8025e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8025eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8025ee:	01 d0                	add    %edx,%eax
  8025f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8025f3:	eb 15                	jmp    80260a <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8025f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f8:	8a 00                	mov    (%eax),%al
  8025fa:	0f b6 d0             	movzbl %al,%edx
  8025fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802600:	0f b6 c0             	movzbl %al,%eax
  802603:	39 c2                	cmp    %eax,%edx
  802605:	74 0d                	je     802614 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  802607:	ff 45 08             	incl   0x8(%ebp)
  80260a:	8b 45 08             	mov    0x8(%ebp),%eax
  80260d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  802610:	72 e3                	jb     8025f5 <memfind+0x13>
  802612:	eb 01                	jmp    802615 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  802614:	90                   	nop
	return (void *) s;
  802615:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802618:	c9                   	leave  
  802619:	c3                   	ret    

0080261a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80261a:	55                   	push   %ebp
  80261b:	89 e5                	mov    %esp,%ebp
  80261d:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  802620:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  802627:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80262e:	eb 03                	jmp    802633 <strtol+0x19>
		s++;
  802630:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802633:	8b 45 08             	mov    0x8(%ebp),%eax
  802636:	8a 00                	mov    (%eax),%al
  802638:	3c 20                	cmp    $0x20,%al
  80263a:	74 f4                	je     802630 <strtol+0x16>
  80263c:	8b 45 08             	mov    0x8(%ebp),%eax
  80263f:	8a 00                	mov    (%eax),%al
  802641:	3c 09                	cmp    $0x9,%al
  802643:	74 eb                	je     802630 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  802645:	8b 45 08             	mov    0x8(%ebp),%eax
  802648:	8a 00                	mov    (%eax),%al
  80264a:	3c 2b                	cmp    $0x2b,%al
  80264c:	75 05                	jne    802653 <strtol+0x39>
		s++;
  80264e:	ff 45 08             	incl   0x8(%ebp)
  802651:	eb 13                	jmp    802666 <strtol+0x4c>
	else if (*s == '-')
  802653:	8b 45 08             	mov    0x8(%ebp),%eax
  802656:	8a 00                	mov    (%eax),%al
  802658:	3c 2d                	cmp    $0x2d,%al
  80265a:	75 0a                	jne    802666 <strtol+0x4c>
		s++, neg = 1;
  80265c:	ff 45 08             	incl   0x8(%ebp)
  80265f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  802666:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80266a:	74 06                	je     802672 <strtol+0x58>
  80266c:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  802670:	75 20                	jne    802692 <strtol+0x78>
  802672:	8b 45 08             	mov    0x8(%ebp),%eax
  802675:	8a 00                	mov    (%eax),%al
  802677:	3c 30                	cmp    $0x30,%al
  802679:	75 17                	jne    802692 <strtol+0x78>
  80267b:	8b 45 08             	mov    0x8(%ebp),%eax
  80267e:	40                   	inc    %eax
  80267f:	8a 00                	mov    (%eax),%al
  802681:	3c 78                	cmp    $0x78,%al
  802683:	75 0d                	jne    802692 <strtol+0x78>
		s += 2, base = 16;
  802685:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  802689:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  802690:	eb 28                	jmp    8026ba <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  802692:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802696:	75 15                	jne    8026ad <strtol+0x93>
  802698:	8b 45 08             	mov    0x8(%ebp),%eax
  80269b:	8a 00                	mov    (%eax),%al
  80269d:	3c 30                	cmp    $0x30,%al
  80269f:	75 0c                	jne    8026ad <strtol+0x93>
		s++, base = 8;
  8026a1:	ff 45 08             	incl   0x8(%ebp)
  8026a4:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8026ab:	eb 0d                	jmp    8026ba <strtol+0xa0>
	else if (base == 0)
  8026ad:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8026b1:	75 07                	jne    8026ba <strtol+0xa0>
		base = 10;
  8026b3:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8026ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8026bd:	8a 00                	mov    (%eax),%al
  8026bf:	3c 2f                	cmp    $0x2f,%al
  8026c1:	7e 19                	jle    8026dc <strtol+0xc2>
  8026c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c6:	8a 00                	mov    (%eax),%al
  8026c8:	3c 39                	cmp    $0x39,%al
  8026ca:	7f 10                	jg     8026dc <strtol+0xc2>
			dig = *s - '0';
  8026cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8026cf:	8a 00                	mov    (%eax),%al
  8026d1:	0f be c0             	movsbl %al,%eax
  8026d4:	83 e8 30             	sub    $0x30,%eax
  8026d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026da:	eb 42                	jmp    80271e <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8026dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8026df:	8a 00                	mov    (%eax),%al
  8026e1:	3c 60                	cmp    $0x60,%al
  8026e3:	7e 19                	jle    8026fe <strtol+0xe4>
  8026e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e8:	8a 00                	mov    (%eax),%al
  8026ea:	3c 7a                	cmp    $0x7a,%al
  8026ec:	7f 10                	jg     8026fe <strtol+0xe4>
			dig = *s - 'a' + 10;
  8026ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f1:	8a 00                	mov    (%eax),%al
  8026f3:	0f be c0             	movsbl %al,%eax
  8026f6:	83 e8 57             	sub    $0x57,%eax
  8026f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026fc:	eb 20                	jmp    80271e <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8026fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802701:	8a 00                	mov    (%eax),%al
  802703:	3c 40                	cmp    $0x40,%al
  802705:	7e 39                	jle    802740 <strtol+0x126>
  802707:	8b 45 08             	mov    0x8(%ebp),%eax
  80270a:	8a 00                	mov    (%eax),%al
  80270c:	3c 5a                	cmp    $0x5a,%al
  80270e:	7f 30                	jg     802740 <strtol+0x126>
			dig = *s - 'A' + 10;
  802710:	8b 45 08             	mov    0x8(%ebp),%eax
  802713:	8a 00                	mov    (%eax),%al
  802715:	0f be c0             	movsbl %al,%eax
  802718:	83 e8 37             	sub    $0x37,%eax
  80271b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80271e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802721:	3b 45 10             	cmp    0x10(%ebp),%eax
  802724:	7d 19                	jge    80273f <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  802726:	ff 45 08             	incl   0x8(%ebp)
  802729:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80272c:	0f af 45 10          	imul   0x10(%ebp),%eax
  802730:	89 c2                	mov    %eax,%edx
  802732:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802735:	01 d0                	add    %edx,%eax
  802737:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80273a:	e9 7b ff ff ff       	jmp    8026ba <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80273f:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  802740:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802744:	74 08                	je     80274e <strtol+0x134>
		*endptr = (char *) s;
  802746:	8b 45 0c             	mov    0xc(%ebp),%eax
  802749:	8b 55 08             	mov    0x8(%ebp),%edx
  80274c:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80274e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802752:	74 07                	je     80275b <strtol+0x141>
  802754:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802757:	f7 d8                	neg    %eax
  802759:	eb 03                	jmp    80275e <strtol+0x144>
  80275b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80275e:	c9                   	leave  
  80275f:	c3                   	ret    

00802760 <ltostr>:

void
ltostr(long value, char *str)
{
  802760:	55                   	push   %ebp
  802761:	89 e5                	mov    %esp,%ebp
  802763:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  802766:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80276d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  802774:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802778:	79 13                	jns    80278d <ltostr+0x2d>
	{
		neg = 1;
  80277a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  802781:	8b 45 0c             	mov    0xc(%ebp),%eax
  802784:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  802787:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80278a:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80278d:	8b 45 08             	mov    0x8(%ebp),%eax
  802790:	b9 0a 00 00 00       	mov    $0xa,%ecx
  802795:	99                   	cltd   
  802796:	f7 f9                	idiv   %ecx
  802798:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80279b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80279e:	8d 50 01             	lea    0x1(%eax),%edx
  8027a1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8027a4:	89 c2                	mov    %eax,%edx
  8027a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027a9:	01 d0                	add    %edx,%eax
  8027ab:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027ae:	83 c2 30             	add    $0x30,%edx
  8027b1:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8027b3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8027b6:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8027bb:	f7 e9                	imul   %ecx
  8027bd:	c1 fa 02             	sar    $0x2,%edx
  8027c0:	89 c8                	mov    %ecx,%eax
  8027c2:	c1 f8 1f             	sar    $0x1f,%eax
  8027c5:	29 c2                	sub    %eax,%edx
  8027c7:	89 d0                	mov    %edx,%eax
  8027c9:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8027cc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8027d0:	75 bb                	jne    80278d <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8027d2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8027d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8027dc:	48                   	dec    %eax
  8027dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8027e0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8027e4:	74 3d                	je     802823 <ltostr+0xc3>
		start = 1 ;
  8027e6:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8027ed:	eb 34                	jmp    802823 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8027ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027f5:	01 d0                	add    %edx,%eax
  8027f7:	8a 00                	mov    (%eax),%al
  8027f9:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8027fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  802802:	01 c2                	add    %eax,%edx
  802804:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802807:	8b 45 0c             	mov    0xc(%ebp),%eax
  80280a:	01 c8                	add    %ecx,%eax
  80280c:	8a 00                	mov    (%eax),%al
  80280e:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  802810:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802813:	8b 45 0c             	mov    0xc(%ebp),%eax
  802816:	01 c2                	add    %eax,%edx
  802818:	8a 45 eb             	mov    -0x15(%ebp),%al
  80281b:	88 02                	mov    %al,(%edx)
		start++ ;
  80281d:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  802820:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  802823:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802826:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802829:	7c c4                	jl     8027ef <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80282b:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80282e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802831:	01 d0                	add    %edx,%eax
  802833:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  802836:	90                   	nop
  802837:	c9                   	leave  
  802838:	c3                   	ret    

00802839 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  802839:	55                   	push   %ebp
  80283a:	89 e5                	mov    %esp,%ebp
  80283c:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80283f:	ff 75 08             	pushl  0x8(%ebp)
  802842:	e8 c4 f9 ff ff       	call   80220b <strlen>
  802847:	83 c4 04             	add    $0x4,%esp
  80284a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80284d:	ff 75 0c             	pushl  0xc(%ebp)
  802850:	e8 b6 f9 ff ff       	call   80220b <strlen>
  802855:	83 c4 04             	add    $0x4,%esp
  802858:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80285b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  802862:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802869:	eb 17                	jmp    802882 <strcconcat+0x49>
		final[s] = str1[s] ;
  80286b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80286e:	8b 45 10             	mov    0x10(%ebp),%eax
  802871:	01 c2                	add    %eax,%edx
  802873:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802876:	8b 45 08             	mov    0x8(%ebp),%eax
  802879:	01 c8                	add    %ecx,%eax
  80287b:	8a 00                	mov    (%eax),%al
  80287d:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80287f:	ff 45 fc             	incl   -0x4(%ebp)
  802882:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802885:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802888:	7c e1                	jl     80286b <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80288a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  802891:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  802898:	eb 1f                	jmp    8028b9 <strcconcat+0x80>
		final[s++] = str2[i] ;
  80289a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80289d:	8d 50 01             	lea    0x1(%eax),%edx
  8028a0:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8028a3:	89 c2                	mov    %eax,%edx
  8028a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8028a8:	01 c2                	add    %eax,%edx
  8028aa:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8028ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028b0:	01 c8                	add    %ecx,%eax
  8028b2:	8a 00                	mov    (%eax),%al
  8028b4:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8028b6:	ff 45 f8             	incl   -0x8(%ebp)
  8028b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8028bc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8028bf:	7c d9                	jl     80289a <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8028c1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8028c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8028c7:	01 d0                	add    %edx,%eax
  8028c9:	c6 00 00             	movb   $0x0,(%eax)
}
  8028cc:	90                   	nop
  8028cd:	c9                   	leave  
  8028ce:	c3                   	ret    

008028cf <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8028cf:	55                   	push   %ebp
  8028d0:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8028d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8028d5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8028db:	8b 45 14             	mov    0x14(%ebp),%eax
  8028de:	8b 00                	mov    (%eax),%eax
  8028e0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8028e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8028ea:	01 d0                	add    %edx,%eax
  8028ec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8028f2:	eb 0c                	jmp    802900 <strsplit+0x31>
			*string++ = 0;
  8028f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f7:	8d 50 01             	lea    0x1(%eax),%edx
  8028fa:	89 55 08             	mov    %edx,0x8(%ebp)
  8028fd:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802900:	8b 45 08             	mov    0x8(%ebp),%eax
  802903:	8a 00                	mov    (%eax),%al
  802905:	84 c0                	test   %al,%al
  802907:	74 18                	je     802921 <strsplit+0x52>
  802909:	8b 45 08             	mov    0x8(%ebp),%eax
  80290c:	8a 00                	mov    (%eax),%al
  80290e:	0f be c0             	movsbl %al,%eax
  802911:	50                   	push   %eax
  802912:	ff 75 0c             	pushl  0xc(%ebp)
  802915:	e8 83 fa ff ff       	call   80239d <strchr>
  80291a:	83 c4 08             	add    $0x8,%esp
  80291d:	85 c0                	test   %eax,%eax
  80291f:	75 d3                	jne    8028f4 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  802921:	8b 45 08             	mov    0x8(%ebp),%eax
  802924:	8a 00                	mov    (%eax),%al
  802926:	84 c0                	test   %al,%al
  802928:	74 5a                	je     802984 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80292a:	8b 45 14             	mov    0x14(%ebp),%eax
  80292d:	8b 00                	mov    (%eax),%eax
  80292f:	83 f8 0f             	cmp    $0xf,%eax
  802932:	75 07                	jne    80293b <strsplit+0x6c>
		{
			return 0;
  802934:	b8 00 00 00 00       	mov    $0x0,%eax
  802939:	eb 66                	jmp    8029a1 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80293b:	8b 45 14             	mov    0x14(%ebp),%eax
  80293e:	8b 00                	mov    (%eax),%eax
  802940:	8d 48 01             	lea    0x1(%eax),%ecx
  802943:	8b 55 14             	mov    0x14(%ebp),%edx
  802946:	89 0a                	mov    %ecx,(%edx)
  802948:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80294f:	8b 45 10             	mov    0x10(%ebp),%eax
  802952:	01 c2                	add    %eax,%edx
  802954:	8b 45 08             	mov    0x8(%ebp),%eax
  802957:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  802959:	eb 03                	jmp    80295e <strsplit+0x8f>
			string++;
  80295b:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80295e:	8b 45 08             	mov    0x8(%ebp),%eax
  802961:	8a 00                	mov    (%eax),%al
  802963:	84 c0                	test   %al,%al
  802965:	74 8b                	je     8028f2 <strsplit+0x23>
  802967:	8b 45 08             	mov    0x8(%ebp),%eax
  80296a:	8a 00                	mov    (%eax),%al
  80296c:	0f be c0             	movsbl %al,%eax
  80296f:	50                   	push   %eax
  802970:	ff 75 0c             	pushl  0xc(%ebp)
  802973:	e8 25 fa ff ff       	call   80239d <strchr>
  802978:	83 c4 08             	add    $0x8,%esp
  80297b:	85 c0                	test   %eax,%eax
  80297d:	74 dc                	je     80295b <strsplit+0x8c>
			string++;
	}
  80297f:	e9 6e ff ff ff       	jmp    8028f2 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  802984:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  802985:	8b 45 14             	mov    0x14(%ebp),%eax
  802988:	8b 00                	mov    (%eax),%eax
  80298a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802991:	8b 45 10             	mov    0x10(%ebp),%eax
  802994:	01 d0                	add    %edx,%eax
  802996:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80299c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8029a1:	c9                   	leave  
  8029a2:	c3                   	ret    

008029a3 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8029a3:	55                   	push   %ebp
  8029a4:	89 e5                	mov    %esp,%ebp
  8029a6:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8029a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ac:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8029af:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8029b6:	eb 4a                	jmp    802a02 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8029b8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8029bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8029be:	01 c2                	add    %eax,%edx
  8029c0:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8029c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029c6:	01 c8                	add    %ecx,%eax
  8029c8:	8a 00                	mov    (%eax),%al
  8029ca:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8029cc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8029cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029d2:	01 d0                	add    %edx,%eax
  8029d4:	8a 00                	mov    (%eax),%al
  8029d6:	3c 40                	cmp    $0x40,%al
  8029d8:	7e 25                	jle    8029ff <str2lower+0x5c>
  8029da:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8029dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029e0:	01 d0                	add    %edx,%eax
  8029e2:	8a 00                	mov    (%eax),%al
  8029e4:	3c 5a                	cmp    $0x5a,%al
  8029e6:	7f 17                	jg     8029ff <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8029e8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8029eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ee:	01 d0                	add    %edx,%eax
  8029f0:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8029f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8029f6:	01 ca                	add    %ecx,%edx
  8029f8:	8a 12                	mov    (%edx),%dl
  8029fa:	83 c2 20             	add    $0x20,%edx
  8029fd:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8029ff:	ff 45 fc             	incl   -0x4(%ebp)
  802a02:	ff 75 0c             	pushl  0xc(%ebp)
  802a05:	e8 01 f8 ff ff       	call   80220b <strlen>
  802a0a:	83 c4 04             	add    $0x4,%esp
  802a0d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  802a10:	7f a6                	jg     8029b8 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  802a12:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  802a15:	c9                   	leave  
  802a16:	c3                   	ret    

00802a17 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  802a17:	55                   	push   %ebp
  802a18:	89 e5                	mov    %esp,%ebp
  802a1a:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  802a1d:	a1 08 60 80 00       	mov    0x806008,%eax
  802a22:	85 c0                	test   %eax,%eax
  802a24:	74 42                	je     802a68 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  802a26:	83 ec 08             	sub    $0x8,%esp
  802a29:	68 00 00 00 82       	push   $0x82000000
  802a2e:	68 00 00 00 80       	push   $0x80000000
  802a33:	e8 8c 07 00 00       	call   8031c4 <initialize_dynamic_allocator>
  802a38:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  802a3b:	e8 e7 05 00 00       	call   803027 <sys_get_uheap_strategy>
  802a40:	a3 60 e0 81 00       	mov    %eax,0x81e060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  802a45:	a1 40 60 80 00       	mov    0x806040,%eax
  802a4a:	05 00 10 00 00       	add    $0x1000,%eax
  802a4f:	a3 10 e1 81 00       	mov    %eax,0x81e110
		uheapPageAllocBreak = uheapPageAllocStart;
  802a54:	a1 10 e1 81 00       	mov    0x81e110,%eax
  802a59:	a3 68 e0 81 00       	mov    %eax,0x81e068

		__firstTimeFlag = 0;
  802a5e:	c7 05 08 60 80 00 00 	movl   $0x0,0x806008
  802a65:	00 00 00 
	}
}
  802a68:	90                   	nop
  802a69:	c9                   	leave  
  802a6a:	c3                   	ret    

00802a6b <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  802a6b:	55                   	push   %ebp
  802a6c:	89 e5                	mov    %esp,%ebp
  802a6e:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  802a71:	8b 45 08             	mov    0x8(%ebp),%eax
  802a74:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802a7f:	83 ec 08             	sub    $0x8,%esp
  802a82:	68 06 04 00 00       	push   $0x406
  802a87:	50                   	push   %eax
  802a88:	e8 e4 01 00 00       	call   802c71 <__sys_allocate_page>
  802a8d:	83 c4 10             	add    $0x10,%esp
  802a90:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  802a93:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a97:	79 14                	jns    802aad <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  802a99:	83 ec 04             	sub    $0x4,%esp
  802a9c:	68 e8 4d 80 00       	push   $0x804de8
  802aa1:	6a 1f                	push   $0x1f
  802aa3:	68 24 4e 80 00       	push   $0x804e24
  802aa8:	e8 b7 ed ff ff       	call   801864 <_panic>
	return 0;
  802aad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ab2:	c9                   	leave  
  802ab3:	c3                   	ret    

00802ab4 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  802ab4:	55                   	push   %ebp
  802ab5:	89 e5                	mov    %esp,%ebp
  802ab7:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  802aba:	8b 45 08             	mov    0x8(%ebp),%eax
  802abd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ac0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802ac8:	83 ec 0c             	sub    $0xc,%esp
  802acb:	50                   	push   %eax
  802acc:	e8 e7 01 00 00       	call   802cb8 <__sys_unmap_frame>
  802ad1:	83 c4 10             	add    $0x10,%esp
  802ad4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  802ad7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802adb:	79 14                	jns    802af1 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  802add:	83 ec 04             	sub    $0x4,%esp
  802ae0:	68 30 4e 80 00       	push   $0x804e30
  802ae5:	6a 2a                	push   $0x2a
  802ae7:	68 24 4e 80 00       	push   $0x804e24
  802aec:	e8 73 ed ff ff       	call   801864 <_panic>
}
  802af1:	90                   	nop
  802af2:	c9                   	leave  
  802af3:	c3                   	ret    

00802af4 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  802af4:	55                   	push   %ebp
  802af5:	89 e5                	mov    %esp,%ebp
  802af7:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802afa:	e8 18 ff ff ff       	call   802a17 <uheap_init>
	if (size == 0) return NULL ;
  802aff:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b03:	75 07                	jne    802b0c <malloc+0x18>
  802b05:	b8 00 00 00 00       	mov    $0x0,%eax
  802b0a:	eb 14                	jmp    802b20 <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  802b0c:	83 ec 04             	sub    $0x4,%esp
  802b0f:	68 70 4e 80 00       	push   $0x804e70
  802b14:	6a 3e                	push   $0x3e
  802b16:	68 24 4e 80 00       	push   $0x804e24
  802b1b:	e8 44 ed ff ff       	call   801864 <_panic>
}
  802b20:	c9                   	leave  
  802b21:	c3                   	ret    

00802b22 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  802b22:	55                   	push   %ebp
  802b23:	89 e5                	mov    %esp,%ebp
  802b25:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  802b28:	83 ec 04             	sub    $0x4,%esp
  802b2b:	68 98 4e 80 00       	push   $0x804e98
  802b30:	6a 49                	push   $0x49
  802b32:	68 24 4e 80 00       	push   $0x804e24
  802b37:	e8 28 ed ff ff       	call   801864 <_panic>

00802b3c <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802b3c:	55                   	push   %ebp
  802b3d:	89 e5                	mov    %esp,%ebp
  802b3f:	83 ec 18             	sub    $0x18,%esp
  802b42:	8b 45 10             	mov    0x10(%ebp),%eax
  802b45:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802b48:	e8 ca fe ff ff       	call   802a17 <uheap_init>
	if (size == 0) return NULL ;
  802b4d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802b51:	75 07                	jne    802b5a <smalloc+0x1e>
  802b53:	b8 00 00 00 00       	mov    $0x0,%eax
  802b58:	eb 14                	jmp    802b6e <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  802b5a:	83 ec 04             	sub    $0x4,%esp
  802b5d:	68 bc 4e 80 00       	push   $0x804ebc
  802b62:	6a 5a                	push   $0x5a
  802b64:	68 24 4e 80 00       	push   $0x804e24
  802b69:	e8 f6 ec ff ff       	call   801864 <_panic>
}
  802b6e:	c9                   	leave  
  802b6f:	c3                   	ret    

00802b70 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802b70:	55                   	push   %ebp
  802b71:	89 e5                	mov    %esp,%ebp
  802b73:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802b76:	e8 9c fe ff ff       	call   802a17 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  802b7b:	83 ec 04             	sub    $0x4,%esp
  802b7e:	68 e4 4e 80 00       	push   $0x804ee4
  802b83:	6a 6a                	push   $0x6a
  802b85:	68 24 4e 80 00       	push   $0x804e24
  802b8a:	e8 d5 ec ff ff       	call   801864 <_panic>

00802b8f <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802b8f:	55                   	push   %ebp
  802b90:	89 e5                	mov    %esp,%ebp
  802b92:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802b95:	e8 7d fe ff ff       	call   802a17 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  802b9a:	83 ec 04             	sub    $0x4,%esp
  802b9d:	68 08 4f 80 00       	push   $0x804f08
  802ba2:	68 88 00 00 00       	push   $0x88
  802ba7:	68 24 4e 80 00       	push   $0x804e24
  802bac:	e8 b3 ec ff ff       	call   801864 <_panic>

00802bb1 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  802bb1:	55                   	push   %ebp
  802bb2:	89 e5                	mov    %esp,%ebp
  802bb4:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  802bb7:	83 ec 04             	sub    $0x4,%esp
  802bba:	68 30 4f 80 00       	push   $0x804f30
  802bbf:	68 9b 00 00 00       	push   $0x9b
  802bc4:	68 24 4e 80 00       	push   $0x804e24
  802bc9:	e8 96 ec ff ff       	call   801864 <_panic>

00802bce <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802bce:	55                   	push   %ebp
  802bcf:	89 e5                	mov    %esp,%ebp
  802bd1:	57                   	push   %edi
  802bd2:	56                   	push   %esi
  802bd3:	53                   	push   %ebx
  802bd4:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802bd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802bda:	8b 55 0c             	mov    0xc(%ebp),%edx
  802bdd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802be0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802be3:	8b 7d 18             	mov    0x18(%ebp),%edi
  802be6:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802be9:	cd 30                	int    $0x30
  802beb:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  802bee:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802bf1:	83 c4 10             	add    $0x10,%esp
  802bf4:	5b                   	pop    %ebx
  802bf5:	5e                   	pop    %esi
  802bf6:	5f                   	pop    %edi
  802bf7:	5d                   	pop    %ebp
  802bf8:	c3                   	ret    

00802bf9 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  802bf9:	55                   	push   %ebp
  802bfa:	89 e5                	mov    %esp,%ebp
  802bfc:	83 ec 04             	sub    $0x4,%esp
  802bff:	8b 45 10             	mov    0x10(%ebp),%eax
  802c02:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  802c05:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802c08:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802c0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0f:	6a 00                	push   $0x0
  802c11:	51                   	push   %ecx
  802c12:	52                   	push   %edx
  802c13:	ff 75 0c             	pushl  0xc(%ebp)
  802c16:	50                   	push   %eax
  802c17:	6a 00                	push   $0x0
  802c19:	e8 b0 ff ff ff       	call   802bce <syscall>
  802c1e:	83 c4 18             	add    $0x18,%esp
}
  802c21:	90                   	nop
  802c22:	c9                   	leave  
  802c23:	c3                   	ret    

00802c24 <sys_cgetc>:

int
sys_cgetc(void)
{
  802c24:	55                   	push   %ebp
  802c25:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802c27:	6a 00                	push   $0x0
  802c29:	6a 00                	push   $0x0
  802c2b:	6a 00                	push   $0x0
  802c2d:	6a 00                	push   $0x0
  802c2f:	6a 00                	push   $0x0
  802c31:	6a 02                	push   $0x2
  802c33:	e8 96 ff ff ff       	call   802bce <syscall>
  802c38:	83 c4 18             	add    $0x18,%esp
}
  802c3b:	c9                   	leave  
  802c3c:	c3                   	ret    

00802c3d <sys_lock_cons>:

void sys_lock_cons(void)
{
  802c3d:	55                   	push   %ebp
  802c3e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802c40:	6a 00                	push   $0x0
  802c42:	6a 00                	push   $0x0
  802c44:	6a 00                	push   $0x0
  802c46:	6a 00                	push   $0x0
  802c48:	6a 00                	push   $0x0
  802c4a:	6a 03                	push   $0x3
  802c4c:	e8 7d ff ff ff       	call   802bce <syscall>
  802c51:	83 c4 18             	add    $0x18,%esp
}
  802c54:	90                   	nop
  802c55:	c9                   	leave  
  802c56:	c3                   	ret    

00802c57 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802c57:	55                   	push   %ebp
  802c58:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802c5a:	6a 00                	push   $0x0
  802c5c:	6a 00                	push   $0x0
  802c5e:	6a 00                	push   $0x0
  802c60:	6a 00                	push   $0x0
  802c62:	6a 00                	push   $0x0
  802c64:	6a 04                	push   $0x4
  802c66:	e8 63 ff ff ff       	call   802bce <syscall>
  802c6b:	83 c4 18             	add    $0x18,%esp
}
  802c6e:	90                   	nop
  802c6f:	c9                   	leave  
  802c70:	c3                   	ret    

00802c71 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802c71:	55                   	push   %ebp
  802c72:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802c74:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c77:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7a:	6a 00                	push   $0x0
  802c7c:	6a 00                	push   $0x0
  802c7e:	6a 00                	push   $0x0
  802c80:	52                   	push   %edx
  802c81:	50                   	push   %eax
  802c82:	6a 08                	push   $0x8
  802c84:	e8 45 ff ff ff       	call   802bce <syscall>
  802c89:	83 c4 18             	add    $0x18,%esp
}
  802c8c:	c9                   	leave  
  802c8d:	c3                   	ret    

00802c8e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802c8e:	55                   	push   %ebp
  802c8f:	89 e5                	mov    %esp,%ebp
  802c91:	56                   	push   %esi
  802c92:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802c93:	8b 75 18             	mov    0x18(%ebp),%esi
  802c96:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802c99:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802c9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca2:	56                   	push   %esi
  802ca3:	53                   	push   %ebx
  802ca4:	51                   	push   %ecx
  802ca5:	52                   	push   %edx
  802ca6:	50                   	push   %eax
  802ca7:	6a 09                	push   $0x9
  802ca9:	e8 20 ff ff ff       	call   802bce <syscall>
  802cae:	83 c4 18             	add    $0x18,%esp
}
  802cb1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802cb4:	5b                   	pop    %ebx
  802cb5:	5e                   	pop    %esi
  802cb6:	5d                   	pop    %ebp
  802cb7:	c3                   	ret    

00802cb8 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  802cb8:	55                   	push   %ebp
  802cb9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  802cbb:	6a 00                	push   $0x0
  802cbd:	6a 00                	push   $0x0
  802cbf:	6a 00                	push   $0x0
  802cc1:	6a 00                	push   $0x0
  802cc3:	ff 75 08             	pushl  0x8(%ebp)
  802cc6:	6a 0a                	push   $0xa
  802cc8:	e8 01 ff ff ff       	call   802bce <syscall>
  802ccd:	83 c4 18             	add    $0x18,%esp
}
  802cd0:	c9                   	leave  
  802cd1:	c3                   	ret    

00802cd2 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802cd2:	55                   	push   %ebp
  802cd3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802cd5:	6a 00                	push   $0x0
  802cd7:	6a 00                	push   $0x0
  802cd9:	6a 00                	push   $0x0
  802cdb:	ff 75 0c             	pushl  0xc(%ebp)
  802cde:	ff 75 08             	pushl  0x8(%ebp)
  802ce1:	6a 0b                	push   $0xb
  802ce3:	e8 e6 fe ff ff       	call   802bce <syscall>
  802ce8:	83 c4 18             	add    $0x18,%esp
}
  802ceb:	c9                   	leave  
  802cec:	c3                   	ret    

00802ced <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802ced:	55                   	push   %ebp
  802cee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802cf0:	6a 00                	push   $0x0
  802cf2:	6a 00                	push   $0x0
  802cf4:	6a 00                	push   $0x0
  802cf6:	6a 00                	push   $0x0
  802cf8:	6a 00                	push   $0x0
  802cfa:	6a 0c                	push   $0xc
  802cfc:	e8 cd fe ff ff       	call   802bce <syscall>
  802d01:	83 c4 18             	add    $0x18,%esp
}
  802d04:	c9                   	leave  
  802d05:	c3                   	ret    

00802d06 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802d06:	55                   	push   %ebp
  802d07:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802d09:	6a 00                	push   $0x0
  802d0b:	6a 00                	push   $0x0
  802d0d:	6a 00                	push   $0x0
  802d0f:	6a 00                	push   $0x0
  802d11:	6a 00                	push   $0x0
  802d13:	6a 0d                	push   $0xd
  802d15:	e8 b4 fe ff ff       	call   802bce <syscall>
  802d1a:	83 c4 18             	add    $0x18,%esp
}
  802d1d:	c9                   	leave  
  802d1e:	c3                   	ret    

00802d1f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802d1f:	55                   	push   %ebp
  802d20:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802d22:	6a 00                	push   $0x0
  802d24:	6a 00                	push   $0x0
  802d26:	6a 00                	push   $0x0
  802d28:	6a 00                	push   $0x0
  802d2a:	6a 00                	push   $0x0
  802d2c:	6a 0e                	push   $0xe
  802d2e:	e8 9b fe ff ff       	call   802bce <syscall>
  802d33:	83 c4 18             	add    $0x18,%esp
}
  802d36:	c9                   	leave  
  802d37:	c3                   	ret    

00802d38 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802d38:	55                   	push   %ebp
  802d39:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802d3b:	6a 00                	push   $0x0
  802d3d:	6a 00                	push   $0x0
  802d3f:	6a 00                	push   $0x0
  802d41:	6a 00                	push   $0x0
  802d43:	6a 00                	push   $0x0
  802d45:	6a 0f                	push   $0xf
  802d47:	e8 82 fe ff ff       	call   802bce <syscall>
  802d4c:	83 c4 18             	add    $0x18,%esp
}
  802d4f:	c9                   	leave  
  802d50:	c3                   	ret    

00802d51 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802d51:	55                   	push   %ebp
  802d52:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802d54:	6a 00                	push   $0x0
  802d56:	6a 00                	push   $0x0
  802d58:	6a 00                	push   $0x0
  802d5a:	6a 00                	push   $0x0
  802d5c:	ff 75 08             	pushl  0x8(%ebp)
  802d5f:	6a 10                	push   $0x10
  802d61:	e8 68 fe ff ff       	call   802bce <syscall>
  802d66:	83 c4 18             	add    $0x18,%esp
}
  802d69:	c9                   	leave  
  802d6a:	c3                   	ret    

00802d6b <sys_scarce_memory>:

void sys_scarce_memory()
{
  802d6b:	55                   	push   %ebp
  802d6c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802d6e:	6a 00                	push   $0x0
  802d70:	6a 00                	push   $0x0
  802d72:	6a 00                	push   $0x0
  802d74:	6a 00                	push   $0x0
  802d76:	6a 00                	push   $0x0
  802d78:	6a 11                	push   $0x11
  802d7a:	e8 4f fe ff ff       	call   802bce <syscall>
  802d7f:	83 c4 18             	add    $0x18,%esp
}
  802d82:	90                   	nop
  802d83:	c9                   	leave  
  802d84:	c3                   	ret    

00802d85 <sys_cputc>:

void
sys_cputc(const char c)
{
  802d85:	55                   	push   %ebp
  802d86:	89 e5                	mov    %esp,%ebp
  802d88:	83 ec 04             	sub    $0x4,%esp
  802d8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802d91:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802d95:	6a 00                	push   $0x0
  802d97:	6a 00                	push   $0x0
  802d99:	6a 00                	push   $0x0
  802d9b:	6a 00                	push   $0x0
  802d9d:	50                   	push   %eax
  802d9e:	6a 01                	push   $0x1
  802da0:	e8 29 fe ff ff       	call   802bce <syscall>
  802da5:	83 c4 18             	add    $0x18,%esp
}
  802da8:	90                   	nop
  802da9:	c9                   	leave  
  802daa:	c3                   	ret    

00802dab <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802dab:	55                   	push   %ebp
  802dac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802dae:	6a 00                	push   $0x0
  802db0:	6a 00                	push   $0x0
  802db2:	6a 00                	push   $0x0
  802db4:	6a 00                	push   $0x0
  802db6:	6a 00                	push   $0x0
  802db8:	6a 14                	push   $0x14
  802dba:	e8 0f fe ff ff       	call   802bce <syscall>
  802dbf:	83 c4 18             	add    $0x18,%esp
}
  802dc2:	90                   	nop
  802dc3:	c9                   	leave  
  802dc4:	c3                   	ret    

00802dc5 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802dc5:	55                   	push   %ebp
  802dc6:	89 e5                	mov    %esp,%ebp
  802dc8:	83 ec 04             	sub    $0x4,%esp
  802dcb:	8b 45 10             	mov    0x10(%ebp),%eax
  802dce:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802dd1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802dd4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802dd8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ddb:	6a 00                	push   $0x0
  802ddd:	51                   	push   %ecx
  802dde:	52                   	push   %edx
  802ddf:	ff 75 0c             	pushl  0xc(%ebp)
  802de2:	50                   	push   %eax
  802de3:	6a 15                	push   $0x15
  802de5:	e8 e4 fd ff ff       	call   802bce <syscall>
  802dea:	83 c4 18             	add    $0x18,%esp
}
  802ded:	c9                   	leave  
  802dee:	c3                   	ret    

00802def <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  802def:	55                   	push   %ebp
  802df0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802df2:	8b 55 0c             	mov    0xc(%ebp),%edx
  802df5:	8b 45 08             	mov    0x8(%ebp),%eax
  802df8:	6a 00                	push   $0x0
  802dfa:	6a 00                	push   $0x0
  802dfc:	6a 00                	push   $0x0
  802dfe:	52                   	push   %edx
  802dff:	50                   	push   %eax
  802e00:	6a 16                	push   $0x16
  802e02:	e8 c7 fd ff ff       	call   802bce <syscall>
  802e07:	83 c4 18             	add    $0x18,%esp
}
  802e0a:	c9                   	leave  
  802e0b:	c3                   	ret    

00802e0c <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  802e0c:	55                   	push   %ebp
  802e0d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802e0f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802e12:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e15:	8b 45 08             	mov    0x8(%ebp),%eax
  802e18:	6a 00                	push   $0x0
  802e1a:	6a 00                	push   $0x0
  802e1c:	51                   	push   %ecx
  802e1d:	52                   	push   %edx
  802e1e:	50                   	push   %eax
  802e1f:	6a 17                	push   $0x17
  802e21:	e8 a8 fd ff ff       	call   802bce <syscall>
  802e26:	83 c4 18             	add    $0x18,%esp
}
  802e29:	c9                   	leave  
  802e2a:	c3                   	ret    

00802e2b <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  802e2b:	55                   	push   %ebp
  802e2c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802e2e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e31:	8b 45 08             	mov    0x8(%ebp),%eax
  802e34:	6a 00                	push   $0x0
  802e36:	6a 00                	push   $0x0
  802e38:	6a 00                	push   $0x0
  802e3a:	52                   	push   %edx
  802e3b:	50                   	push   %eax
  802e3c:	6a 18                	push   $0x18
  802e3e:	e8 8b fd ff ff       	call   802bce <syscall>
  802e43:	83 c4 18             	add    $0x18,%esp
}
  802e46:	c9                   	leave  
  802e47:	c3                   	ret    

00802e48 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802e48:	55                   	push   %ebp
  802e49:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4e:	6a 00                	push   $0x0
  802e50:	ff 75 14             	pushl  0x14(%ebp)
  802e53:	ff 75 10             	pushl  0x10(%ebp)
  802e56:	ff 75 0c             	pushl  0xc(%ebp)
  802e59:	50                   	push   %eax
  802e5a:	6a 19                	push   $0x19
  802e5c:	e8 6d fd ff ff       	call   802bce <syscall>
  802e61:	83 c4 18             	add    $0x18,%esp
}
  802e64:	c9                   	leave  
  802e65:	c3                   	ret    

00802e66 <sys_run_env>:

void sys_run_env(int32 envId)
{
  802e66:	55                   	push   %ebp
  802e67:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802e69:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6c:	6a 00                	push   $0x0
  802e6e:	6a 00                	push   $0x0
  802e70:	6a 00                	push   $0x0
  802e72:	6a 00                	push   $0x0
  802e74:	50                   	push   %eax
  802e75:	6a 1a                	push   $0x1a
  802e77:	e8 52 fd ff ff       	call   802bce <syscall>
  802e7c:	83 c4 18             	add    $0x18,%esp
}
  802e7f:	90                   	nop
  802e80:	c9                   	leave  
  802e81:	c3                   	ret    

00802e82 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802e82:	55                   	push   %ebp
  802e83:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802e85:	8b 45 08             	mov    0x8(%ebp),%eax
  802e88:	6a 00                	push   $0x0
  802e8a:	6a 00                	push   $0x0
  802e8c:	6a 00                	push   $0x0
  802e8e:	6a 00                	push   $0x0
  802e90:	50                   	push   %eax
  802e91:	6a 1b                	push   $0x1b
  802e93:	e8 36 fd ff ff       	call   802bce <syscall>
  802e98:	83 c4 18             	add    $0x18,%esp
}
  802e9b:	c9                   	leave  
  802e9c:	c3                   	ret    

00802e9d <sys_getenvid>:

int32 sys_getenvid(void)
{
  802e9d:	55                   	push   %ebp
  802e9e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802ea0:	6a 00                	push   $0x0
  802ea2:	6a 00                	push   $0x0
  802ea4:	6a 00                	push   $0x0
  802ea6:	6a 00                	push   $0x0
  802ea8:	6a 00                	push   $0x0
  802eaa:	6a 05                	push   $0x5
  802eac:	e8 1d fd ff ff       	call   802bce <syscall>
  802eb1:	83 c4 18             	add    $0x18,%esp
}
  802eb4:	c9                   	leave  
  802eb5:	c3                   	ret    

00802eb6 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802eb6:	55                   	push   %ebp
  802eb7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802eb9:	6a 00                	push   $0x0
  802ebb:	6a 00                	push   $0x0
  802ebd:	6a 00                	push   $0x0
  802ebf:	6a 00                	push   $0x0
  802ec1:	6a 00                	push   $0x0
  802ec3:	6a 06                	push   $0x6
  802ec5:	e8 04 fd ff ff       	call   802bce <syscall>
  802eca:	83 c4 18             	add    $0x18,%esp
}
  802ecd:	c9                   	leave  
  802ece:	c3                   	ret    

00802ecf <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802ecf:	55                   	push   %ebp
  802ed0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802ed2:	6a 00                	push   $0x0
  802ed4:	6a 00                	push   $0x0
  802ed6:	6a 00                	push   $0x0
  802ed8:	6a 00                	push   $0x0
  802eda:	6a 00                	push   $0x0
  802edc:	6a 07                	push   $0x7
  802ede:	e8 eb fc ff ff       	call   802bce <syscall>
  802ee3:	83 c4 18             	add    $0x18,%esp
}
  802ee6:	c9                   	leave  
  802ee7:	c3                   	ret    

00802ee8 <sys_exit_env>:


void sys_exit_env(void)
{
  802ee8:	55                   	push   %ebp
  802ee9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802eeb:	6a 00                	push   $0x0
  802eed:	6a 00                	push   $0x0
  802eef:	6a 00                	push   $0x0
  802ef1:	6a 00                	push   $0x0
  802ef3:	6a 00                	push   $0x0
  802ef5:	6a 1c                	push   $0x1c
  802ef7:	e8 d2 fc ff ff       	call   802bce <syscall>
  802efc:	83 c4 18             	add    $0x18,%esp
}
  802eff:	90                   	nop
  802f00:	c9                   	leave  
  802f01:	c3                   	ret    

00802f02 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802f02:	55                   	push   %ebp
  802f03:	89 e5                	mov    %esp,%ebp
  802f05:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802f08:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802f0b:	8d 50 04             	lea    0x4(%eax),%edx
  802f0e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802f11:	6a 00                	push   $0x0
  802f13:	6a 00                	push   $0x0
  802f15:	6a 00                	push   $0x0
  802f17:	52                   	push   %edx
  802f18:	50                   	push   %eax
  802f19:	6a 1d                	push   $0x1d
  802f1b:	e8 ae fc ff ff       	call   802bce <syscall>
  802f20:	83 c4 18             	add    $0x18,%esp
	return result;
  802f23:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802f26:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802f29:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802f2c:	89 01                	mov    %eax,(%ecx)
  802f2e:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802f31:	8b 45 08             	mov    0x8(%ebp),%eax
  802f34:	c9                   	leave  
  802f35:	c2 04 00             	ret    $0x4

00802f38 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802f38:	55                   	push   %ebp
  802f39:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802f3b:	6a 00                	push   $0x0
  802f3d:	6a 00                	push   $0x0
  802f3f:	ff 75 10             	pushl  0x10(%ebp)
  802f42:	ff 75 0c             	pushl  0xc(%ebp)
  802f45:	ff 75 08             	pushl  0x8(%ebp)
  802f48:	6a 13                	push   $0x13
  802f4a:	e8 7f fc ff ff       	call   802bce <syscall>
  802f4f:	83 c4 18             	add    $0x18,%esp
	return ;
  802f52:	90                   	nop
}
  802f53:	c9                   	leave  
  802f54:	c3                   	ret    

00802f55 <sys_rcr2>:
uint32 sys_rcr2()
{
  802f55:	55                   	push   %ebp
  802f56:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802f58:	6a 00                	push   $0x0
  802f5a:	6a 00                	push   $0x0
  802f5c:	6a 00                	push   $0x0
  802f5e:	6a 00                	push   $0x0
  802f60:	6a 00                	push   $0x0
  802f62:	6a 1e                	push   $0x1e
  802f64:	e8 65 fc ff ff       	call   802bce <syscall>
  802f69:	83 c4 18             	add    $0x18,%esp
}
  802f6c:	c9                   	leave  
  802f6d:	c3                   	ret    

00802f6e <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802f6e:	55                   	push   %ebp
  802f6f:	89 e5                	mov    %esp,%ebp
  802f71:	83 ec 04             	sub    $0x4,%esp
  802f74:	8b 45 08             	mov    0x8(%ebp),%eax
  802f77:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802f7a:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802f7e:	6a 00                	push   $0x0
  802f80:	6a 00                	push   $0x0
  802f82:	6a 00                	push   $0x0
  802f84:	6a 00                	push   $0x0
  802f86:	50                   	push   %eax
  802f87:	6a 1f                	push   $0x1f
  802f89:	e8 40 fc ff ff       	call   802bce <syscall>
  802f8e:	83 c4 18             	add    $0x18,%esp
	return ;
  802f91:	90                   	nop
}
  802f92:	c9                   	leave  
  802f93:	c3                   	ret    

00802f94 <rsttst>:
void rsttst()
{
  802f94:	55                   	push   %ebp
  802f95:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802f97:	6a 00                	push   $0x0
  802f99:	6a 00                	push   $0x0
  802f9b:	6a 00                	push   $0x0
  802f9d:	6a 00                	push   $0x0
  802f9f:	6a 00                	push   $0x0
  802fa1:	6a 21                	push   $0x21
  802fa3:	e8 26 fc ff ff       	call   802bce <syscall>
  802fa8:	83 c4 18             	add    $0x18,%esp
	return ;
  802fab:	90                   	nop
}
  802fac:	c9                   	leave  
  802fad:	c3                   	ret    

00802fae <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802fae:	55                   	push   %ebp
  802faf:	89 e5                	mov    %esp,%ebp
  802fb1:	83 ec 04             	sub    $0x4,%esp
  802fb4:	8b 45 14             	mov    0x14(%ebp),%eax
  802fb7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802fba:	8b 55 18             	mov    0x18(%ebp),%edx
  802fbd:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802fc1:	52                   	push   %edx
  802fc2:	50                   	push   %eax
  802fc3:	ff 75 10             	pushl  0x10(%ebp)
  802fc6:	ff 75 0c             	pushl  0xc(%ebp)
  802fc9:	ff 75 08             	pushl  0x8(%ebp)
  802fcc:	6a 20                	push   $0x20
  802fce:	e8 fb fb ff ff       	call   802bce <syscall>
  802fd3:	83 c4 18             	add    $0x18,%esp
	return ;
  802fd6:	90                   	nop
}
  802fd7:	c9                   	leave  
  802fd8:	c3                   	ret    

00802fd9 <chktst>:
void chktst(uint32 n)
{
  802fd9:	55                   	push   %ebp
  802fda:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802fdc:	6a 00                	push   $0x0
  802fde:	6a 00                	push   $0x0
  802fe0:	6a 00                	push   $0x0
  802fe2:	6a 00                	push   $0x0
  802fe4:	ff 75 08             	pushl  0x8(%ebp)
  802fe7:	6a 22                	push   $0x22
  802fe9:	e8 e0 fb ff ff       	call   802bce <syscall>
  802fee:	83 c4 18             	add    $0x18,%esp
	return ;
  802ff1:	90                   	nop
}
  802ff2:	c9                   	leave  
  802ff3:	c3                   	ret    

00802ff4 <inctst>:

void inctst()
{
  802ff4:	55                   	push   %ebp
  802ff5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802ff7:	6a 00                	push   $0x0
  802ff9:	6a 00                	push   $0x0
  802ffb:	6a 00                	push   $0x0
  802ffd:	6a 00                	push   $0x0
  802fff:	6a 00                	push   $0x0
  803001:	6a 23                	push   $0x23
  803003:	e8 c6 fb ff ff       	call   802bce <syscall>
  803008:	83 c4 18             	add    $0x18,%esp
	return ;
  80300b:	90                   	nop
}
  80300c:	c9                   	leave  
  80300d:	c3                   	ret    

0080300e <gettst>:
uint32 gettst()
{
  80300e:	55                   	push   %ebp
  80300f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  803011:	6a 00                	push   $0x0
  803013:	6a 00                	push   $0x0
  803015:	6a 00                	push   $0x0
  803017:	6a 00                	push   $0x0
  803019:	6a 00                	push   $0x0
  80301b:	6a 24                	push   $0x24
  80301d:	e8 ac fb ff ff       	call   802bce <syscall>
  803022:	83 c4 18             	add    $0x18,%esp
}
  803025:	c9                   	leave  
  803026:	c3                   	ret    

00803027 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  803027:	55                   	push   %ebp
  803028:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80302a:	6a 00                	push   $0x0
  80302c:	6a 00                	push   $0x0
  80302e:	6a 00                	push   $0x0
  803030:	6a 00                	push   $0x0
  803032:	6a 00                	push   $0x0
  803034:	6a 25                	push   $0x25
  803036:	e8 93 fb ff ff       	call   802bce <syscall>
  80303b:	83 c4 18             	add    $0x18,%esp
  80303e:	a3 60 e0 81 00       	mov    %eax,0x81e060
	return uheapPlaceStrategy ;
  803043:	a1 60 e0 81 00       	mov    0x81e060,%eax
}
  803048:	c9                   	leave  
  803049:	c3                   	ret    

0080304a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80304a:	55                   	push   %ebp
  80304b:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  80304d:	8b 45 08             	mov    0x8(%ebp),%eax
  803050:	a3 60 e0 81 00       	mov    %eax,0x81e060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  803055:	6a 00                	push   $0x0
  803057:	6a 00                	push   $0x0
  803059:	6a 00                	push   $0x0
  80305b:	6a 00                	push   $0x0
  80305d:	ff 75 08             	pushl  0x8(%ebp)
  803060:	6a 26                	push   $0x26
  803062:	e8 67 fb ff ff       	call   802bce <syscall>
  803067:	83 c4 18             	add    $0x18,%esp
	return ;
  80306a:	90                   	nop
}
  80306b:	c9                   	leave  
  80306c:	c3                   	ret    

0080306d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80306d:	55                   	push   %ebp
  80306e:	89 e5                	mov    %esp,%ebp
  803070:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  803071:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803074:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803077:	8b 55 0c             	mov    0xc(%ebp),%edx
  80307a:	8b 45 08             	mov    0x8(%ebp),%eax
  80307d:	6a 00                	push   $0x0
  80307f:	53                   	push   %ebx
  803080:	51                   	push   %ecx
  803081:	52                   	push   %edx
  803082:	50                   	push   %eax
  803083:	6a 27                	push   $0x27
  803085:	e8 44 fb ff ff       	call   802bce <syscall>
  80308a:	83 c4 18             	add    $0x18,%esp
}
  80308d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803090:	c9                   	leave  
  803091:	c3                   	ret    

00803092 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  803092:	55                   	push   %ebp
  803093:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  803095:	8b 55 0c             	mov    0xc(%ebp),%edx
  803098:	8b 45 08             	mov    0x8(%ebp),%eax
  80309b:	6a 00                	push   $0x0
  80309d:	6a 00                	push   $0x0
  80309f:	6a 00                	push   $0x0
  8030a1:	52                   	push   %edx
  8030a2:	50                   	push   %eax
  8030a3:	6a 28                	push   $0x28
  8030a5:	e8 24 fb ff ff       	call   802bce <syscall>
  8030aa:	83 c4 18             	add    $0x18,%esp
}
  8030ad:	c9                   	leave  
  8030ae:	c3                   	ret    

008030af <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8030af:	55                   	push   %ebp
  8030b0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8030b2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8030b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030bb:	6a 00                	push   $0x0
  8030bd:	51                   	push   %ecx
  8030be:	ff 75 10             	pushl  0x10(%ebp)
  8030c1:	52                   	push   %edx
  8030c2:	50                   	push   %eax
  8030c3:	6a 29                	push   $0x29
  8030c5:	e8 04 fb ff ff       	call   802bce <syscall>
  8030ca:	83 c4 18             	add    $0x18,%esp
}
  8030cd:	c9                   	leave  
  8030ce:	c3                   	ret    

008030cf <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8030cf:	55                   	push   %ebp
  8030d0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8030d2:	6a 00                	push   $0x0
  8030d4:	6a 00                	push   $0x0
  8030d6:	ff 75 10             	pushl  0x10(%ebp)
  8030d9:	ff 75 0c             	pushl  0xc(%ebp)
  8030dc:	ff 75 08             	pushl  0x8(%ebp)
  8030df:	6a 12                	push   $0x12
  8030e1:	e8 e8 fa ff ff       	call   802bce <syscall>
  8030e6:	83 c4 18             	add    $0x18,%esp
	return ;
  8030e9:	90                   	nop
}
  8030ea:	c9                   	leave  
  8030eb:	c3                   	ret    

008030ec <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8030ec:	55                   	push   %ebp
  8030ed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8030ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f5:	6a 00                	push   $0x0
  8030f7:	6a 00                	push   $0x0
  8030f9:	6a 00                	push   $0x0
  8030fb:	52                   	push   %edx
  8030fc:	50                   	push   %eax
  8030fd:	6a 2a                	push   $0x2a
  8030ff:	e8 ca fa ff ff       	call   802bce <syscall>
  803104:	83 c4 18             	add    $0x18,%esp
	return;
  803107:	90                   	nop
}
  803108:	c9                   	leave  
  803109:	c3                   	ret    

0080310a <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  80310a:	55                   	push   %ebp
  80310b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  80310d:	6a 00                	push   $0x0
  80310f:	6a 00                	push   $0x0
  803111:	6a 00                	push   $0x0
  803113:	6a 00                	push   $0x0
  803115:	6a 00                	push   $0x0
  803117:	6a 2b                	push   $0x2b
  803119:	e8 b0 fa ff ff       	call   802bce <syscall>
  80311e:	83 c4 18             	add    $0x18,%esp
}
  803121:	c9                   	leave  
  803122:	c3                   	ret    

00803123 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  803123:	55                   	push   %ebp
  803124:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  803126:	6a 00                	push   $0x0
  803128:	6a 00                	push   $0x0
  80312a:	6a 00                	push   $0x0
  80312c:	ff 75 0c             	pushl  0xc(%ebp)
  80312f:	ff 75 08             	pushl  0x8(%ebp)
  803132:	6a 2d                	push   $0x2d
  803134:	e8 95 fa ff ff       	call   802bce <syscall>
  803139:	83 c4 18             	add    $0x18,%esp
	return;
  80313c:	90                   	nop
}
  80313d:	c9                   	leave  
  80313e:	c3                   	ret    

0080313f <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80313f:	55                   	push   %ebp
  803140:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  803142:	6a 00                	push   $0x0
  803144:	6a 00                	push   $0x0
  803146:	6a 00                	push   $0x0
  803148:	ff 75 0c             	pushl  0xc(%ebp)
  80314b:	ff 75 08             	pushl  0x8(%ebp)
  80314e:	6a 2c                	push   $0x2c
  803150:	e8 79 fa ff ff       	call   802bce <syscall>
  803155:	83 c4 18             	add    $0x18,%esp
	return ;
  803158:	90                   	nop
}
  803159:	c9                   	leave  
  80315a:	c3                   	ret    

0080315b <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  80315b:	55                   	push   %ebp
  80315c:	89 e5                	mov    %esp,%ebp
  80315e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  803161:	83 ec 04             	sub    $0x4,%esp
  803164:	68 54 4f 80 00       	push   $0x804f54
  803169:	68 25 01 00 00       	push   $0x125
  80316e:	68 87 4f 80 00       	push   $0x804f87
  803173:	e8 ec e6 ff ff       	call   801864 <_panic>

00803178 <to_page_va>:
//==================================================================================//
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  803178:	55                   	push   %ebp
  803179:	89 e5                	mov    %esp,%ebp
  80317b:	83 ec 10             	sub    $0x10,%esp
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  80317e:	8b 45 08             	mov    0x8(%ebp),%eax
  803181:	ba 60 60 80 00       	mov    $0x806060,%edx
  803186:	29 d0                	sub    %edx,%eax
  803188:	c1 f8 02             	sar    $0x2,%eax
  80318b:	89 c2                	mov    %eax,%edx
  80318d:	89 d0                	mov    %edx,%eax
  80318f:	c1 e0 02             	shl    $0x2,%eax
  803192:	01 d0                	add    %edx,%eax
  803194:	c1 e0 02             	shl    $0x2,%eax
  803197:	01 d0                	add    %edx,%eax
  803199:	c1 e0 02             	shl    $0x2,%eax
  80319c:	01 d0                	add    %edx,%eax
  80319e:	89 c1                	mov    %eax,%ecx
  8031a0:	c1 e1 08             	shl    $0x8,%ecx
  8031a3:	01 c8                	add    %ecx,%eax
  8031a5:	89 c1                	mov    %eax,%ecx
  8031a7:	c1 e1 10             	shl    $0x10,%ecx
  8031aa:	01 c8                	add    %ecx,%eax
  8031ac:	01 c0                	add    %eax,%eax
  8031ae:	01 d0                	add    %edx,%eax
  8031b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  8031b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8031b6:	c1 e0 0c             	shl    $0xc,%eax
  8031b9:	89 c2                	mov    %eax,%edx
  8031bb:	a1 64 e0 81 00       	mov    0x81e064,%eax
  8031c0:	01 d0                	add    %edx,%eax
}
  8031c2:	c9                   	leave  
  8031c3:	c3                   	ret    

008031c4 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  8031c4:	55                   	push   %ebp
  8031c5:	89 e5                	mov    %esp,%ebp
  8031c7:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  8031ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8031cd:	05 00 00 00 02       	add    $0x2000000,%eax
  8031d2:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8031d5:	73 16                	jae    8031ed <initialize_dynamic_allocator+0x29>
  8031d7:	68 98 4f 80 00       	push   $0x804f98
  8031dc:	68 be 4f 80 00       	push   $0x804fbe
  8031e1:	6a 26                	push   $0x26
  8031e3:	68 d3 4f 80 00       	push   $0x804fd3
  8031e8:	e8 77 e6 ff ff       	call   801864 <_panic>
		is_initialized = 1;
  8031ed:	c7 05 24 60 80 00 01 	movl   $0x1,0x806024
  8031f4:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	//Comment the following line
	panic("initialize_dynamic_allocator() Not implemented yet");
  8031f7:	83 ec 04             	sub    $0x4,%esp
  8031fa:	68 ec 4f 80 00       	push   $0x804fec
  8031ff:	6a 2e                	push   $0x2e
  803201:	68 d3 4f 80 00       	push   $0x804fd3
  803206:	e8 59 e6 ff ff       	call   801864 <_panic>

0080320b <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  80320b:	55                   	push   %ebp
  80320c:	89 e5                	mov    %esp,%ebp
  80320e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	//Comment the following line
	panic("get_block_size() Not implemented yet");
  803211:	83 ec 04             	sub    $0x4,%esp
  803214:	68 20 50 80 00       	push   $0x805020
  803219:	6a 3a                	push   $0x3a
  80321b:	68 d3 4f 80 00       	push   $0x804fd3
  803220:	e8 3f e6 ff ff       	call   801864 <_panic>

00803225 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  803225:	55                   	push   %ebp
  803226:	89 e5                	mov    %esp,%ebp
  803228:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  80322b:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  803232:	76 16                	jbe    80324a <alloc_block+0x25>
  803234:	68 48 50 80 00       	push   $0x805048
  803239:	68 be 4f 80 00       	push   $0x804fbe
  80323e:	6a 46                	push   $0x46
  803240:	68 d3 4f 80 00       	push   $0x804fd3
  803245:	e8 1a e6 ff ff       	call   801864 <_panic>
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	panic("alloc_block() Not implemented yet");
  80324a:	83 ec 04             	sub    $0x4,%esp
  80324d:	68 6c 50 80 00       	push   $0x80506c
  803252:	6a 4d                	push   $0x4d
  803254:	68 d3 4f 80 00       	push   $0x804fd3
  803259:	e8 06 e6 ff ff       	call   801864 <_panic>

0080325e <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  80325e:	55                   	push   %ebp
  80325f:	89 e5                	mov    %esp,%ebp
  803261:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  803264:	8b 55 08             	mov    0x8(%ebp),%edx
  803267:	a1 64 e0 81 00       	mov    0x81e064,%eax
  80326c:	39 c2                	cmp    %eax,%edx
  80326e:	72 0c                	jb     80327c <free_block+0x1e>
  803270:	8b 55 08             	mov    0x8(%ebp),%edx
  803273:	a1 40 60 80 00       	mov    0x806040,%eax
  803278:	39 c2                	cmp    %eax,%edx
  80327a:	72 16                	jb     803292 <free_block+0x34>
  80327c:	68 90 50 80 00       	push   $0x805090
  803281:	68 be 4f 80 00       	push   $0x804fbe
  803286:	6a 5b                	push   $0x5b
  803288:	68 d3 4f 80 00       	push   $0x804fd3
  80328d:	e8 d2 e5 ff ff       	call   801864 <_panic>
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	panic("free_block() Not implemented yet");
  803292:	83 ec 04             	sub    $0x4,%esp
  803295:	68 c8 50 80 00       	push   $0x8050c8
  80329a:	6a 63                	push   $0x63
  80329c:	68 d3 4f 80 00       	push   $0x804fd3
  8032a1:	e8 be e5 ff ff       	call   801864 <_panic>

008032a6 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  8032a6:	55                   	push   %ebp
  8032a7:	89 e5                	mov    %esp,%ebp
  8032a9:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  8032ac:	83 ec 04             	sub    $0x4,%esp
  8032af:	68 ec 50 80 00       	push   $0x8050ec
  8032b4:	6a 72                	push   $0x72
  8032b6:	68 d3 4f 80 00       	push   $0x804fd3
  8032bb:	e8 a4 e5 ff ff       	call   801864 <_panic>

008032c0 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8032c0:	55                   	push   %ebp
  8032c1:	89 e5                	mov    %esp,%ebp
  8032c3:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8032c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8032c9:	89 d0                	mov    %edx,%eax
  8032cb:	c1 e0 02             	shl    $0x2,%eax
  8032ce:	01 d0                	add    %edx,%eax
  8032d0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8032d7:	01 d0                	add    %edx,%eax
  8032d9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8032e0:	01 d0                	add    %edx,%eax
  8032e2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8032e9:	01 d0                	add    %edx,%eax
  8032eb:	c1 e0 04             	shl    $0x4,%eax
  8032ee:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  8032f1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  8032f8:	0f 31                	rdtsc  
  8032fa:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8032fd:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  803300:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803303:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803306:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803309:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  80330c:	eb 46                	jmp    803354 <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  80330e:	0f 31                	rdtsc  
  803310:	89 45 d0             	mov    %eax,-0x30(%ebp)
  803313:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  803316:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803319:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80331c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80331f:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803322:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803325:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803328:	29 c2                	sub    %eax,%edx
  80332a:	89 d0                	mov    %edx,%eax
  80332c:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  80332f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803332:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803335:	89 d1                	mov    %edx,%ecx
  803337:	29 c1                	sub    %eax,%ecx
  803339:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80333c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80333f:	39 c2                	cmp    %eax,%edx
  803341:	0f 97 c0             	seta   %al
  803344:	0f b6 c0             	movzbl %al,%eax
  803347:	29 c1                	sub    %eax,%ecx
  803349:	89 c8                	mov    %ecx,%eax
  80334b:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  80334e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803351:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  803354:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803357:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80335a:	72 b2                	jb     80330e <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  80335c:	90                   	nop
  80335d:	c9                   	leave  
  80335e:	c3                   	ret    

0080335f <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  80335f:	55                   	push   %ebp
  803360:	89 e5                	mov    %esp,%ebp
  803362:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803365:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  80336c:	eb 03                	jmp    803371 <busy_wait+0x12>
  80336e:	ff 45 fc             	incl   -0x4(%ebp)
  803371:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803374:	3b 45 08             	cmp    0x8(%ebp),%eax
  803377:	72 f5                	jb     80336e <busy_wait+0xf>
	return i;
  803379:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80337c:	c9                   	leave  
  80337d:	c3                   	ret    
  80337e:	66 90                	xchg   %ax,%ax

00803380 <__udivdi3>:
  803380:	55                   	push   %ebp
  803381:	57                   	push   %edi
  803382:	56                   	push   %esi
  803383:	53                   	push   %ebx
  803384:	83 ec 1c             	sub    $0x1c,%esp
  803387:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80338b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80338f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803393:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803397:	89 ca                	mov    %ecx,%edx
  803399:	89 f8                	mov    %edi,%eax
  80339b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80339f:	85 f6                	test   %esi,%esi
  8033a1:	75 2d                	jne    8033d0 <__udivdi3+0x50>
  8033a3:	39 cf                	cmp    %ecx,%edi
  8033a5:	77 65                	ja     80340c <__udivdi3+0x8c>
  8033a7:	89 fd                	mov    %edi,%ebp
  8033a9:	85 ff                	test   %edi,%edi
  8033ab:	75 0b                	jne    8033b8 <__udivdi3+0x38>
  8033ad:	b8 01 00 00 00       	mov    $0x1,%eax
  8033b2:	31 d2                	xor    %edx,%edx
  8033b4:	f7 f7                	div    %edi
  8033b6:	89 c5                	mov    %eax,%ebp
  8033b8:	31 d2                	xor    %edx,%edx
  8033ba:	89 c8                	mov    %ecx,%eax
  8033bc:	f7 f5                	div    %ebp
  8033be:	89 c1                	mov    %eax,%ecx
  8033c0:	89 d8                	mov    %ebx,%eax
  8033c2:	f7 f5                	div    %ebp
  8033c4:	89 cf                	mov    %ecx,%edi
  8033c6:	89 fa                	mov    %edi,%edx
  8033c8:	83 c4 1c             	add    $0x1c,%esp
  8033cb:	5b                   	pop    %ebx
  8033cc:	5e                   	pop    %esi
  8033cd:	5f                   	pop    %edi
  8033ce:	5d                   	pop    %ebp
  8033cf:	c3                   	ret    
  8033d0:	39 ce                	cmp    %ecx,%esi
  8033d2:	77 28                	ja     8033fc <__udivdi3+0x7c>
  8033d4:	0f bd fe             	bsr    %esi,%edi
  8033d7:	83 f7 1f             	xor    $0x1f,%edi
  8033da:	75 40                	jne    80341c <__udivdi3+0x9c>
  8033dc:	39 ce                	cmp    %ecx,%esi
  8033de:	72 0a                	jb     8033ea <__udivdi3+0x6a>
  8033e0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8033e4:	0f 87 9e 00 00 00    	ja     803488 <__udivdi3+0x108>
  8033ea:	b8 01 00 00 00       	mov    $0x1,%eax
  8033ef:	89 fa                	mov    %edi,%edx
  8033f1:	83 c4 1c             	add    $0x1c,%esp
  8033f4:	5b                   	pop    %ebx
  8033f5:	5e                   	pop    %esi
  8033f6:	5f                   	pop    %edi
  8033f7:	5d                   	pop    %ebp
  8033f8:	c3                   	ret    
  8033f9:	8d 76 00             	lea    0x0(%esi),%esi
  8033fc:	31 ff                	xor    %edi,%edi
  8033fe:	31 c0                	xor    %eax,%eax
  803400:	89 fa                	mov    %edi,%edx
  803402:	83 c4 1c             	add    $0x1c,%esp
  803405:	5b                   	pop    %ebx
  803406:	5e                   	pop    %esi
  803407:	5f                   	pop    %edi
  803408:	5d                   	pop    %ebp
  803409:	c3                   	ret    
  80340a:	66 90                	xchg   %ax,%ax
  80340c:	89 d8                	mov    %ebx,%eax
  80340e:	f7 f7                	div    %edi
  803410:	31 ff                	xor    %edi,%edi
  803412:	89 fa                	mov    %edi,%edx
  803414:	83 c4 1c             	add    $0x1c,%esp
  803417:	5b                   	pop    %ebx
  803418:	5e                   	pop    %esi
  803419:	5f                   	pop    %edi
  80341a:	5d                   	pop    %ebp
  80341b:	c3                   	ret    
  80341c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803421:	89 eb                	mov    %ebp,%ebx
  803423:	29 fb                	sub    %edi,%ebx
  803425:	89 f9                	mov    %edi,%ecx
  803427:	d3 e6                	shl    %cl,%esi
  803429:	89 c5                	mov    %eax,%ebp
  80342b:	88 d9                	mov    %bl,%cl
  80342d:	d3 ed                	shr    %cl,%ebp
  80342f:	89 e9                	mov    %ebp,%ecx
  803431:	09 f1                	or     %esi,%ecx
  803433:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803437:	89 f9                	mov    %edi,%ecx
  803439:	d3 e0                	shl    %cl,%eax
  80343b:	89 c5                	mov    %eax,%ebp
  80343d:	89 d6                	mov    %edx,%esi
  80343f:	88 d9                	mov    %bl,%cl
  803441:	d3 ee                	shr    %cl,%esi
  803443:	89 f9                	mov    %edi,%ecx
  803445:	d3 e2                	shl    %cl,%edx
  803447:	8b 44 24 08          	mov    0x8(%esp),%eax
  80344b:	88 d9                	mov    %bl,%cl
  80344d:	d3 e8                	shr    %cl,%eax
  80344f:	09 c2                	or     %eax,%edx
  803451:	89 d0                	mov    %edx,%eax
  803453:	89 f2                	mov    %esi,%edx
  803455:	f7 74 24 0c          	divl   0xc(%esp)
  803459:	89 d6                	mov    %edx,%esi
  80345b:	89 c3                	mov    %eax,%ebx
  80345d:	f7 e5                	mul    %ebp
  80345f:	39 d6                	cmp    %edx,%esi
  803461:	72 19                	jb     80347c <__udivdi3+0xfc>
  803463:	74 0b                	je     803470 <__udivdi3+0xf0>
  803465:	89 d8                	mov    %ebx,%eax
  803467:	31 ff                	xor    %edi,%edi
  803469:	e9 58 ff ff ff       	jmp    8033c6 <__udivdi3+0x46>
  80346e:	66 90                	xchg   %ax,%ax
  803470:	8b 54 24 08          	mov    0x8(%esp),%edx
  803474:	89 f9                	mov    %edi,%ecx
  803476:	d3 e2                	shl    %cl,%edx
  803478:	39 c2                	cmp    %eax,%edx
  80347a:	73 e9                	jae    803465 <__udivdi3+0xe5>
  80347c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80347f:	31 ff                	xor    %edi,%edi
  803481:	e9 40 ff ff ff       	jmp    8033c6 <__udivdi3+0x46>
  803486:	66 90                	xchg   %ax,%ax
  803488:	31 c0                	xor    %eax,%eax
  80348a:	e9 37 ff ff ff       	jmp    8033c6 <__udivdi3+0x46>
  80348f:	90                   	nop

00803490 <__umoddi3>:
  803490:	55                   	push   %ebp
  803491:	57                   	push   %edi
  803492:	56                   	push   %esi
  803493:	53                   	push   %ebx
  803494:	83 ec 1c             	sub    $0x1c,%esp
  803497:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80349b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80349f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8034a3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8034a7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8034ab:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8034af:	89 f3                	mov    %esi,%ebx
  8034b1:	89 fa                	mov    %edi,%edx
  8034b3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8034b7:	89 34 24             	mov    %esi,(%esp)
  8034ba:	85 c0                	test   %eax,%eax
  8034bc:	75 1a                	jne    8034d8 <__umoddi3+0x48>
  8034be:	39 f7                	cmp    %esi,%edi
  8034c0:	0f 86 a2 00 00 00    	jbe    803568 <__umoddi3+0xd8>
  8034c6:	89 c8                	mov    %ecx,%eax
  8034c8:	89 f2                	mov    %esi,%edx
  8034ca:	f7 f7                	div    %edi
  8034cc:	89 d0                	mov    %edx,%eax
  8034ce:	31 d2                	xor    %edx,%edx
  8034d0:	83 c4 1c             	add    $0x1c,%esp
  8034d3:	5b                   	pop    %ebx
  8034d4:	5e                   	pop    %esi
  8034d5:	5f                   	pop    %edi
  8034d6:	5d                   	pop    %ebp
  8034d7:	c3                   	ret    
  8034d8:	39 f0                	cmp    %esi,%eax
  8034da:	0f 87 ac 00 00 00    	ja     80358c <__umoddi3+0xfc>
  8034e0:	0f bd e8             	bsr    %eax,%ebp
  8034e3:	83 f5 1f             	xor    $0x1f,%ebp
  8034e6:	0f 84 ac 00 00 00    	je     803598 <__umoddi3+0x108>
  8034ec:	bf 20 00 00 00       	mov    $0x20,%edi
  8034f1:	29 ef                	sub    %ebp,%edi
  8034f3:	89 fe                	mov    %edi,%esi
  8034f5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8034f9:	89 e9                	mov    %ebp,%ecx
  8034fb:	d3 e0                	shl    %cl,%eax
  8034fd:	89 d7                	mov    %edx,%edi
  8034ff:	89 f1                	mov    %esi,%ecx
  803501:	d3 ef                	shr    %cl,%edi
  803503:	09 c7                	or     %eax,%edi
  803505:	89 e9                	mov    %ebp,%ecx
  803507:	d3 e2                	shl    %cl,%edx
  803509:	89 14 24             	mov    %edx,(%esp)
  80350c:	89 d8                	mov    %ebx,%eax
  80350e:	d3 e0                	shl    %cl,%eax
  803510:	89 c2                	mov    %eax,%edx
  803512:	8b 44 24 08          	mov    0x8(%esp),%eax
  803516:	d3 e0                	shl    %cl,%eax
  803518:	89 44 24 04          	mov    %eax,0x4(%esp)
  80351c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803520:	89 f1                	mov    %esi,%ecx
  803522:	d3 e8                	shr    %cl,%eax
  803524:	09 d0                	or     %edx,%eax
  803526:	d3 eb                	shr    %cl,%ebx
  803528:	89 da                	mov    %ebx,%edx
  80352a:	f7 f7                	div    %edi
  80352c:	89 d3                	mov    %edx,%ebx
  80352e:	f7 24 24             	mull   (%esp)
  803531:	89 c6                	mov    %eax,%esi
  803533:	89 d1                	mov    %edx,%ecx
  803535:	39 d3                	cmp    %edx,%ebx
  803537:	0f 82 87 00 00 00    	jb     8035c4 <__umoddi3+0x134>
  80353d:	0f 84 91 00 00 00    	je     8035d4 <__umoddi3+0x144>
  803543:	8b 54 24 04          	mov    0x4(%esp),%edx
  803547:	29 f2                	sub    %esi,%edx
  803549:	19 cb                	sbb    %ecx,%ebx
  80354b:	89 d8                	mov    %ebx,%eax
  80354d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803551:	d3 e0                	shl    %cl,%eax
  803553:	89 e9                	mov    %ebp,%ecx
  803555:	d3 ea                	shr    %cl,%edx
  803557:	09 d0                	or     %edx,%eax
  803559:	89 e9                	mov    %ebp,%ecx
  80355b:	d3 eb                	shr    %cl,%ebx
  80355d:	89 da                	mov    %ebx,%edx
  80355f:	83 c4 1c             	add    $0x1c,%esp
  803562:	5b                   	pop    %ebx
  803563:	5e                   	pop    %esi
  803564:	5f                   	pop    %edi
  803565:	5d                   	pop    %ebp
  803566:	c3                   	ret    
  803567:	90                   	nop
  803568:	89 fd                	mov    %edi,%ebp
  80356a:	85 ff                	test   %edi,%edi
  80356c:	75 0b                	jne    803579 <__umoddi3+0xe9>
  80356e:	b8 01 00 00 00       	mov    $0x1,%eax
  803573:	31 d2                	xor    %edx,%edx
  803575:	f7 f7                	div    %edi
  803577:	89 c5                	mov    %eax,%ebp
  803579:	89 f0                	mov    %esi,%eax
  80357b:	31 d2                	xor    %edx,%edx
  80357d:	f7 f5                	div    %ebp
  80357f:	89 c8                	mov    %ecx,%eax
  803581:	f7 f5                	div    %ebp
  803583:	89 d0                	mov    %edx,%eax
  803585:	e9 44 ff ff ff       	jmp    8034ce <__umoddi3+0x3e>
  80358a:	66 90                	xchg   %ax,%ax
  80358c:	89 c8                	mov    %ecx,%eax
  80358e:	89 f2                	mov    %esi,%edx
  803590:	83 c4 1c             	add    $0x1c,%esp
  803593:	5b                   	pop    %ebx
  803594:	5e                   	pop    %esi
  803595:	5f                   	pop    %edi
  803596:	5d                   	pop    %ebp
  803597:	c3                   	ret    
  803598:	3b 04 24             	cmp    (%esp),%eax
  80359b:	72 06                	jb     8035a3 <__umoddi3+0x113>
  80359d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8035a1:	77 0f                	ja     8035b2 <__umoddi3+0x122>
  8035a3:	89 f2                	mov    %esi,%edx
  8035a5:	29 f9                	sub    %edi,%ecx
  8035a7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8035ab:	89 14 24             	mov    %edx,(%esp)
  8035ae:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8035b2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8035b6:	8b 14 24             	mov    (%esp),%edx
  8035b9:	83 c4 1c             	add    $0x1c,%esp
  8035bc:	5b                   	pop    %ebx
  8035bd:	5e                   	pop    %esi
  8035be:	5f                   	pop    %edi
  8035bf:	5d                   	pop    %ebp
  8035c0:	c3                   	ret    
  8035c1:	8d 76 00             	lea    0x0(%esi),%esi
  8035c4:	2b 04 24             	sub    (%esp),%eax
  8035c7:	19 fa                	sbb    %edi,%edx
  8035c9:	89 d1                	mov    %edx,%ecx
  8035cb:	89 c6                	mov    %eax,%esi
  8035cd:	e9 71 ff ff ff       	jmp    803543 <__umoddi3+0xb3>
  8035d2:	66 90                	xchg   %ax,%ax
  8035d4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8035d8:	72 ea                	jb     8035c4 <__umoddi3+0x134>
  8035da:	89 d9                	mov    %ebx,%ecx
  8035dc:	e9 62 ff ff ff       	jmp    803543 <__umoddi3+0xb3>

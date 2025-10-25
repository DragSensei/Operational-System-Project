
obj/user/tst_free_1_slave1:     file format elf32-i386


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
  800031:	e8 b7 02 00 00       	call   8002ed <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>


void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	81 ec b0 00 00 00    	sub    $0xb0,%esp
	 *********************************************************/
#if USE_KHEAP
	//cprintf("1\n");
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  800043:	a1 20 30 80 00       	mov    0x803020,%eax
  800048:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
  80004e:	a1 20 30 80 00       	mov    0x803020,%eax
  800053:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800059:	39 c2                	cmp    %eax,%edx
  80005b:	72 14                	jb     800071 <_main+0x39>
			panic("Please increase the WS size");
  80005d:	83 ec 04             	sub    $0x4,%esp
  800060:	68 60 21 80 00       	push   $0x802160
  800065:	6a 11                	push   $0x11
  800067:	68 7c 21 80 00       	push   $0x80217c
  80006c:	e8 2c 04 00 00       	call   80049d <_panic>
	//	malloc(0);
	/*=================================================*/
#else
	panic("not handled!");
#endif
	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  800071:	c7 45 f4 00 10 00 82 	movl   $0x82001000,-0xc(%ebp)


	int Mega = 1024*1024;
  800078:	c7 45 f0 00 00 10 00 	movl   $0x100000,-0x10(%ebp)
	int kilo = 1024;
  80007f:	c7 45 ec 00 04 00 00 	movl   $0x400,-0x14(%ebp)
	char minByte = 1<<7;
  800086:	c6 45 eb 80          	movb   $0x80,-0x15(%ebp)
	char maxByte = 0x7F;
  80008a:	c6 45 ea 7f          	movb   $0x7f,-0x16(%ebp)
	short minShort = 1<<15 ;
  80008e:	66 c7 45 e8 00 80    	movw   $0x8000,-0x18(%ebp)
	short maxShort = 0x7FFF;
  800094:	66 c7 45 e6 ff 7f    	movw   $0x7fff,-0x1a(%ebp)
	int minInt = 1<<31 ;
  80009a:	c7 45 e0 00 00 00 80 	movl   $0x80000000,-0x20(%ebp)
	int maxInt = 0x7FFFFFFF;
  8000a1:	c7 45 dc ff ff ff 7f 	movl   $0x7fffffff,-0x24(%ebp)
	char *byteArr ;
	int lastIndexOfByte;

	int freeFrames, usedDiskPages, chk;
	int expectedNumOfFrames, actualNumOfFrames;
	void* ptr_allocations[20] = {0};
  8000a8:	8d 95 60 ff ff ff    	lea    -0xa0(%ebp),%edx
  8000ae:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b8:	89 d7                	mov    %edx,%edi
  8000ba:	f3 ab                	rep stos %eax,%es:(%edi)
	//ALLOCATE ONE SPACE
	{
		//2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  8000bc:	e8 65 18 00 00       	call   801926 <sys_calculate_free_frames>
  8000c1:	89 45 d8             	mov    %eax,-0x28(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000c4:	e8 a8 18 00 00       	call   801971 <sys_pf_calculate_allocated_pages>
  8000c9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			ptr_allocations[0] = malloc(2*Mega-kilo);
  8000cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000cf:	01 c0                	add    %eax,%eax
  8000d1:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8000d4:	83 ec 0c             	sub    $0xc,%esp
  8000d7:	50                   	push   %eax
  8000d8:	e8 50 16 00 00       	call   80172d <malloc>
  8000dd:	83 c4 10             	add    $0x10,%esp
  8000e0:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
			if ((uint32) ptr_allocations[0] != (pagealloc_start)) panic("Wrong start address for the allocated space... ");
  8000e6:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  8000ec:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8000ef:	74 14                	je     800105 <_main+0xcd>
  8000f1:	83 ec 04             	sub    $0x4,%esp
  8000f4:	68 98 21 80 00       	push   $0x802198
  8000f9:	6a 32                	push   $0x32
  8000fb:	68 7c 21 80 00       	push   $0x80217c
  800100:	e8 98 03 00 00       	call   80049d <_panic>
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800105:	e8 67 18 00 00       	call   801971 <sys_pf_calculate_allocated_pages>
  80010a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80010d:	74 14                	je     800123 <_main+0xeb>
  80010f:	83 ec 04             	sub    $0x4,%esp
  800112:	68 c8 21 80 00       	push   $0x8021c8
  800117:	6a 33                	push   $0x33
  800119:	68 7c 21 80 00       	push   $0x80217c
  80011e:	e8 7a 03 00 00       	call   80049d <_panic>

			freeFrames = sys_calculate_free_frames() ;
  800123:	e8 fe 17 00 00       	call   801926 <sys_calculate_free_frames>
  800128:	89 45 d8             	mov    %eax,-0x28(%ebp)
			lastIndexOfByte = (2*Mega-kilo)/sizeof(char) - 1;
  80012b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80012e:	01 c0                	add    %eax,%eax
  800130:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800133:	48                   	dec    %eax
  800134:	89 45 d0             	mov    %eax,-0x30(%ebp)
			byteArr = (char *) ptr_allocations[0];
  800137:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  80013d:	89 45 cc             	mov    %eax,-0x34(%ebp)
			byteArr[0] = minByte ;
  800140:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800143:	8a 55 eb             	mov    -0x15(%ebp),%dl
  800146:	88 10                	mov    %dl,(%eax)
			byteArr[lastIndexOfByte] = maxByte ;
  800148:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80014b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80014e:	01 c2                	add    %eax,%edx
  800150:	8a 45 ea             	mov    -0x16(%ebp),%al
  800153:	88 02                	mov    %al,(%edx)
			expectedNumOfFrames = 2 /*+1 table already created in malloc due to marking the allocated pages*/ ;
  800155:	c7 45 c8 02 00 00 00 	movl   $0x2,-0x38(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  80015c:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  80015f:	e8 c2 17 00 00       	call   801926 <sys_calculate_free_frames>
  800164:	29 c3                	sub    %eax,%ebx
  800166:	89 d8                	mov    %ebx,%eax
  800168:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if (actualNumOfFrames < expectedNumOfFrames)
  80016b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80016e:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800171:	7d 1a                	jge    80018d <_main+0x155>
				panic("Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);
  800173:	83 ec 0c             	sub    $0xc,%esp
  800176:	ff 75 c4             	pushl  -0x3c(%ebp)
  800179:	ff 75 c8             	pushl  -0x38(%ebp)
  80017c:	68 f8 21 80 00       	push   $0x8021f8
  800181:	6a 3d                	push   $0x3d
  800183:	68 7c 21 80 00       	push   $0x80217c
  800188:	e8 10 03 00 00       	call   80049d <_panic>

			uint32 expectedVAs[2] = { ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE)} ;
  80018d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800190:	89 45 c0             	mov    %eax,-0x40(%ebp)
  800193:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800196:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80019b:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
  8001a1:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8001a4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001a7:	01 d0                	add    %edx,%eax
  8001a9:	89 45 bc             	mov    %eax,-0x44(%ebp)
  8001ac:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8001af:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001b4:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
			chk = sys_check_WS_list(expectedVAs, 2, 0, 2);
  8001ba:	6a 02                	push   $0x2
  8001bc:	6a 00                	push   $0x0
  8001be:	6a 02                	push   $0x2
  8001c0:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
  8001c6:	50                   	push   %eax
  8001c7:	e8 1c 1b 00 00       	call   801ce8 <sys_check_WS_list>
  8001cc:	83 c4 10             	add    $0x10,%esp
  8001cf:	89 45 b8             	mov    %eax,-0x48(%ebp)
			if (chk != 1) panic("malloc: page is not added to WS");
  8001d2:	83 7d b8 01          	cmpl   $0x1,-0x48(%ebp)
  8001d6:	74 14                	je     8001ec <_main+0x1b4>
  8001d8:	83 ec 04             	sub    $0x4,%esp
  8001db:	68 74 22 80 00       	push   $0x802274
  8001e0:	6a 41                	push   $0x41
  8001e2:	68 7c 21 80 00       	push   $0x80217c
  8001e7:	e8 b1 02 00 00       	call   80049d <_panic>

	//FREE IT
	{
		//Free 1st 2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  8001ec:	e8 35 17 00 00       	call   801926 <sys_calculate_free_frames>
  8001f1:	89 45 d8             	mov    %eax,-0x28(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001f4:	e8 78 17 00 00       	call   801971 <sys_pf_calculate_allocated_pages>
  8001f9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			free(ptr_allocations[0]);
  8001fc:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800202:	83 ec 0c             	sub    $0xc,%esp
  800205:	50                   	push   %eax
  800206:	e8 50 15 00 00       	call   80175b <free>
  80020b:	83 c4 10             	add    $0x10,%esp

			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  80020e:	e8 5e 17 00 00       	call   801971 <sys_pf_calculate_allocated_pages>
  800213:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800216:	74 14                	je     80022c <_main+0x1f4>
  800218:	83 ec 04             	sub    $0x4,%esp
  80021b:	68 94 22 80 00       	push   $0x802294
  800220:	6a 4e                	push   $0x4e
  800222:	68 7c 21 80 00       	push   $0x80217c
  800227:	e8 71 02 00 00       	call   80049d <_panic>
			if ((sys_calculate_free_frames() - freeFrames) != 2 ) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  80022c:	e8 f5 16 00 00       	call   801926 <sys_calculate_free_frames>
  800231:	89 c2                	mov    %eax,%edx
  800233:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800236:	29 c2                	sub    %eax,%edx
  800238:	89 d0                	mov    %edx,%eax
  80023a:	83 f8 02             	cmp    $0x2,%eax
  80023d:	74 14                	je     800253 <_main+0x21b>
  80023f:	83 ec 04             	sub    $0x4,%esp
  800242:	68 d0 22 80 00       	push   $0x8022d0
  800247:	6a 4f                	push   $0x4f
  800249:	68 7c 21 80 00       	push   $0x80217c
  80024e:	e8 4a 02 00 00       	call   80049d <_panic>
			uint32 notExpectedVAs[2] = { ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE)} ;
  800253:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800256:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  800259:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80025c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800261:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)
  800267:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80026a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80026d:	01 d0                	add    %edx,%eax
  80026f:	89 45 b0             	mov    %eax,-0x50(%ebp)
  800272:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800275:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80027a:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
			chk = sys_check_WS_list(notExpectedVAs, 2, 0, 3);
  800280:	6a 03                	push   $0x3
  800282:	6a 00                	push   $0x0
  800284:	6a 02                	push   $0x2
  800286:	8d 85 50 ff ff ff    	lea    -0xb0(%ebp),%eax
  80028c:	50                   	push   %eax
  80028d:	e8 56 1a 00 00       	call   801ce8 <sys_check_WS_list>
  800292:	83 c4 10             	add    $0x10,%esp
  800295:	89 45 b8             	mov    %eax,-0x48(%ebp)
			if (chk != 1) panic("free: page is not removed from WS");
  800298:	83 7d b8 01          	cmpl   $0x1,-0x48(%ebp)
  80029c:	74 14                	je     8002b2 <_main+0x27a>
  80029e:	83 ec 04             	sub    $0x4,%esp
  8002a1:	68 1c 23 80 00       	push   $0x80231c
  8002a6:	6a 52                	push   $0x52
  8002a8:	68 7c 21 80 00       	push   $0x80217c
  8002ad:	e8 eb 01 00 00       	call   80049d <_panic>
		}
	}
	inctst(); //to ensure that it reached here
  8002b2:	e8 76 19 00 00       	call   801c2d <inctst>

	//wait until receiving a signal from the master
	while (gettst() != 3) ;
  8002b7:	90                   	nop
  8002b8:	e8 8a 19 00 00       	call   801c47 <gettst>
  8002bd:	83 f8 03             	cmp    $0x3,%eax
  8002c0:	75 f6                	jne    8002b8 <_main+0x280>

	//Test accessing a freed area but NOT ACCESSED Before (processes should be killed by the validation of the fault handler)
	{
		byteArr[8*kilo] = minByte ;
  8002c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002c5:	c1 e0 03             	shl    $0x3,%eax
  8002c8:	89 c2                	mov    %eax,%edx
  8002ca:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8002cd:	01 c2                	add    %eax,%edx
  8002cf:	8a 45 eb             	mov    -0x15(%ebp),%al
  8002d2:	88 02                	mov    %al,(%edx)
		inctst();
  8002d4:	e8 54 19 00 00       	call   801c2d <inctst>
		panic("tst_free_1_slave2 failed: The env must be killed and shouldn't return here.");
  8002d9:	83 ec 04             	sub    $0x4,%esp
  8002dc:	68 40 23 80 00       	push   $0x802340
  8002e1:	6a 5e                	push   $0x5e
  8002e3:	68 7c 21 80 00       	push   $0x80217c
  8002e8:	e8 b0 01 00 00       	call   80049d <_panic>

008002ed <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8002ed:	55                   	push   %ebp
  8002ee:	89 e5                	mov    %esp,%ebp
  8002f0:	57                   	push   %edi
  8002f1:	56                   	push   %esi
  8002f2:	53                   	push   %ebx
  8002f3:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8002f6:	e8 f4 17 00 00       	call   801aef <sys_getenvindex>
  8002fb:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8002fe:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800301:	89 d0                	mov    %edx,%eax
  800303:	c1 e0 02             	shl    $0x2,%eax
  800306:	01 d0                	add    %edx,%eax
  800308:	c1 e0 03             	shl    $0x3,%eax
  80030b:	01 d0                	add    %edx,%eax
  80030d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800314:	01 d0                	add    %edx,%eax
  800316:	c1 e0 02             	shl    $0x2,%eax
  800319:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80031e:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800323:	a1 20 30 80 00       	mov    0x803020,%eax
  800328:	8a 40 20             	mov    0x20(%eax),%al
  80032b:	84 c0                	test   %al,%al
  80032d:	74 0d                	je     80033c <libmain+0x4f>
		binaryname = myEnv->prog_name;
  80032f:	a1 20 30 80 00       	mov    0x803020,%eax
  800334:	83 c0 20             	add    $0x20,%eax
  800337:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80033c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800340:	7e 0a                	jle    80034c <libmain+0x5f>
		binaryname = argv[0];
  800342:	8b 45 0c             	mov    0xc(%ebp),%eax
  800345:	8b 00                	mov    (%eax),%eax
  800347:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  80034c:	83 ec 08             	sub    $0x8,%esp
  80034f:	ff 75 0c             	pushl  0xc(%ebp)
  800352:	ff 75 08             	pushl  0x8(%ebp)
  800355:	e8 de fc ff ff       	call   800038 <_main>
  80035a:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80035d:	a1 00 30 80 00       	mov    0x803000,%eax
  800362:	85 c0                	test   %eax,%eax
  800364:	0f 84 01 01 00 00    	je     80046b <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80036a:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800370:	bb 84 24 80 00       	mov    $0x802484,%ebx
  800375:	ba 0e 00 00 00       	mov    $0xe,%edx
  80037a:	89 c7                	mov    %eax,%edi
  80037c:	89 de                	mov    %ebx,%esi
  80037e:	89 d1                	mov    %edx,%ecx
  800380:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800382:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800385:	b9 56 00 00 00       	mov    $0x56,%ecx
  80038a:	b0 00                	mov    $0x0,%al
  80038c:	89 d7                	mov    %edx,%edi
  80038e:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800390:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800397:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80039a:	83 ec 08             	sub    $0x8,%esp
  80039d:	50                   	push   %eax
  80039e:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8003a4:	50                   	push   %eax
  8003a5:	e8 7b 19 00 00       	call   801d25 <sys_utilities>
  8003aa:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8003ad:	e8 c4 14 00 00       	call   801876 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8003b2:	83 ec 0c             	sub    $0xc,%esp
  8003b5:	68 a4 23 80 00       	push   $0x8023a4
  8003ba:	e8 ac 03 00 00       	call   80076b <cprintf>
  8003bf:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8003c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003c5:	85 c0                	test   %eax,%eax
  8003c7:	74 18                	je     8003e1 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8003c9:	e8 75 19 00 00       	call   801d43 <sys_get_optimal_num_faults>
  8003ce:	83 ec 08             	sub    $0x8,%esp
  8003d1:	50                   	push   %eax
  8003d2:	68 cc 23 80 00       	push   $0x8023cc
  8003d7:	e8 8f 03 00 00       	call   80076b <cprintf>
  8003dc:	83 c4 10             	add    $0x10,%esp
  8003df:	eb 59                	jmp    80043a <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8003e1:	a1 20 30 80 00       	mov    0x803020,%eax
  8003e6:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8003ec:	a1 20 30 80 00       	mov    0x803020,%eax
  8003f1:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  8003f7:	83 ec 04             	sub    $0x4,%esp
  8003fa:	52                   	push   %edx
  8003fb:	50                   	push   %eax
  8003fc:	68 f0 23 80 00       	push   $0x8023f0
  800401:	e8 65 03 00 00       	call   80076b <cprintf>
  800406:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800409:	a1 20 30 80 00       	mov    0x803020,%eax
  80040e:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800414:	a1 20 30 80 00       	mov    0x803020,%eax
  800419:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  80041f:	a1 20 30 80 00       	mov    0x803020,%eax
  800424:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  80042a:	51                   	push   %ecx
  80042b:	52                   	push   %edx
  80042c:	50                   	push   %eax
  80042d:	68 18 24 80 00       	push   $0x802418
  800432:	e8 34 03 00 00       	call   80076b <cprintf>
  800437:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80043a:	a1 20 30 80 00       	mov    0x803020,%eax
  80043f:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  800445:	83 ec 08             	sub    $0x8,%esp
  800448:	50                   	push   %eax
  800449:	68 70 24 80 00       	push   $0x802470
  80044e:	e8 18 03 00 00       	call   80076b <cprintf>
  800453:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800456:	83 ec 0c             	sub    $0xc,%esp
  800459:	68 a4 23 80 00       	push   $0x8023a4
  80045e:	e8 08 03 00 00       	call   80076b <cprintf>
  800463:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800466:	e8 25 14 00 00       	call   801890 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80046b:	e8 1f 00 00 00       	call   80048f <exit>
}
  800470:	90                   	nop
  800471:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800474:	5b                   	pop    %ebx
  800475:	5e                   	pop    %esi
  800476:	5f                   	pop    %edi
  800477:	5d                   	pop    %ebp
  800478:	c3                   	ret    

00800479 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800479:	55                   	push   %ebp
  80047a:	89 e5                	mov    %esp,%ebp
  80047c:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80047f:	83 ec 0c             	sub    $0xc,%esp
  800482:	6a 00                	push   $0x0
  800484:	e8 32 16 00 00       	call   801abb <sys_destroy_env>
  800489:	83 c4 10             	add    $0x10,%esp
}
  80048c:	90                   	nop
  80048d:	c9                   	leave  
  80048e:	c3                   	ret    

0080048f <exit>:

void
exit(void)
{
  80048f:	55                   	push   %ebp
  800490:	89 e5                	mov    %esp,%ebp
  800492:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800495:	e8 87 16 00 00       	call   801b21 <sys_exit_env>
}
  80049a:	90                   	nop
  80049b:	c9                   	leave  
  80049c:	c3                   	ret    

0080049d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80049d:	55                   	push   %ebp
  80049e:	89 e5                	mov    %esp,%ebp
  8004a0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8004a3:	8d 45 10             	lea    0x10(%ebp),%eax
  8004a6:	83 c0 04             	add    $0x4,%eax
  8004a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8004ac:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8004b1:	85 c0                	test   %eax,%eax
  8004b3:	74 16                	je     8004cb <_panic+0x2e>
		cprintf("%s: ", argv0);
  8004b5:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8004ba:	83 ec 08             	sub    $0x8,%esp
  8004bd:	50                   	push   %eax
  8004be:	68 e8 24 80 00       	push   $0x8024e8
  8004c3:	e8 a3 02 00 00       	call   80076b <cprintf>
  8004c8:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8004cb:	a1 04 30 80 00       	mov    0x803004,%eax
  8004d0:	83 ec 0c             	sub    $0xc,%esp
  8004d3:	ff 75 0c             	pushl  0xc(%ebp)
  8004d6:	ff 75 08             	pushl  0x8(%ebp)
  8004d9:	50                   	push   %eax
  8004da:	68 f0 24 80 00       	push   $0x8024f0
  8004df:	6a 74                	push   $0x74
  8004e1:	e8 b2 02 00 00       	call   800798 <cprintf_colored>
  8004e6:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8004e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8004ec:	83 ec 08             	sub    $0x8,%esp
  8004ef:	ff 75 f4             	pushl  -0xc(%ebp)
  8004f2:	50                   	push   %eax
  8004f3:	e8 04 02 00 00       	call   8006fc <vcprintf>
  8004f8:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8004fb:	83 ec 08             	sub    $0x8,%esp
  8004fe:	6a 00                	push   $0x0
  800500:	68 18 25 80 00       	push   $0x802518
  800505:	e8 f2 01 00 00       	call   8006fc <vcprintf>
  80050a:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80050d:	e8 7d ff ff ff       	call   80048f <exit>

	// should not return here
	while (1) ;
  800512:	eb fe                	jmp    800512 <_panic+0x75>

00800514 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800514:	55                   	push   %ebp
  800515:	89 e5                	mov    %esp,%ebp
  800517:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80051a:	a1 20 30 80 00       	mov    0x803020,%eax
  80051f:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800525:	8b 45 0c             	mov    0xc(%ebp),%eax
  800528:	39 c2                	cmp    %eax,%edx
  80052a:	74 14                	je     800540 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80052c:	83 ec 04             	sub    $0x4,%esp
  80052f:	68 1c 25 80 00       	push   $0x80251c
  800534:	6a 26                	push   $0x26
  800536:	68 68 25 80 00       	push   $0x802568
  80053b:	e8 5d ff ff ff       	call   80049d <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800540:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800547:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80054e:	e9 c5 00 00 00       	jmp    800618 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800553:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800556:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80055d:	8b 45 08             	mov    0x8(%ebp),%eax
  800560:	01 d0                	add    %edx,%eax
  800562:	8b 00                	mov    (%eax),%eax
  800564:	85 c0                	test   %eax,%eax
  800566:	75 08                	jne    800570 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800568:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80056b:	e9 a5 00 00 00       	jmp    800615 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800570:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800577:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80057e:	eb 69                	jmp    8005e9 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800580:	a1 20 30 80 00       	mov    0x803020,%eax
  800585:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80058b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80058e:	89 d0                	mov    %edx,%eax
  800590:	01 c0                	add    %eax,%eax
  800592:	01 d0                	add    %edx,%eax
  800594:	c1 e0 03             	shl    $0x3,%eax
  800597:	01 c8                	add    %ecx,%eax
  800599:	8a 40 04             	mov    0x4(%eax),%al
  80059c:	84 c0                	test   %al,%al
  80059e:	75 46                	jne    8005e6 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005a0:	a1 20 30 80 00       	mov    0x803020,%eax
  8005a5:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8005ab:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005ae:	89 d0                	mov    %edx,%eax
  8005b0:	01 c0                	add    %eax,%eax
  8005b2:	01 d0                	add    %edx,%eax
  8005b4:	c1 e0 03             	shl    $0x3,%eax
  8005b7:	01 c8                	add    %ecx,%eax
  8005b9:	8b 00                	mov    (%eax),%eax
  8005bb:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005be:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005c1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005c6:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8005c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005cb:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d5:	01 c8                	add    %ecx,%eax
  8005d7:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005d9:	39 c2                	cmp    %eax,%edx
  8005db:	75 09                	jne    8005e6 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8005dd:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8005e4:	eb 15                	jmp    8005fb <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005e6:	ff 45 e8             	incl   -0x18(%ebp)
  8005e9:	a1 20 30 80 00       	mov    0x803020,%eax
  8005ee:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005f7:	39 c2                	cmp    %eax,%edx
  8005f9:	77 85                	ja     800580 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8005fb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8005ff:	75 14                	jne    800615 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800601:	83 ec 04             	sub    $0x4,%esp
  800604:	68 74 25 80 00       	push   $0x802574
  800609:	6a 3a                	push   $0x3a
  80060b:	68 68 25 80 00       	push   $0x802568
  800610:	e8 88 fe ff ff       	call   80049d <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800615:	ff 45 f0             	incl   -0x10(%ebp)
  800618:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80061b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80061e:	0f 8c 2f ff ff ff    	jl     800553 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800624:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80062b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800632:	eb 26                	jmp    80065a <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800634:	a1 20 30 80 00       	mov    0x803020,%eax
  800639:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80063f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800642:	89 d0                	mov    %edx,%eax
  800644:	01 c0                	add    %eax,%eax
  800646:	01 d0                	add    %edx,%eax
  800648:	c1 e0 03             	shl    $0x3,%eax
  80064b:	01 c8                	add    %ecx,%eax
  80064d:	8a 40 04             	mov    0x4(%eax),%al
  800650:	3c 01                	cmp    $0x1,%al
  800652:	75 03                	jne    800657 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800654:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800657:	ff 45 e0             	incl   -0x20(%ebp)
  80065a:	a1 20 30 80 00       	mov    0x803020,%eax
  80065f:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800665:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800668:	39 c2                	cmp    %eax,%edx
  80066a:	77 c8                	ja     800634 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80066c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80066f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800672:	74 14                	je     800688 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800674:	83 ec 04             	sub    $0x4,%esp
  800677:	68 c8 25 80 00       	push   $0x8025c8
  80067c:	6a 44                	push   $0x44
  80067e:	68 68 25 80 00       	push   $0x802568
  800683:	e8 15 fe ff ff       	call   80049d <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800688:	90                   	nop
  800689:	c9                   	leave  
  80068a:	c3                   	ret    

0080068b <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80068b:	55                   	push   %ebp
  80068c:	89 e5                	mov    %esp,%ebp
  80068e:	53                   	push   %ebx
  80068f:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800692:	8b 45 0c             	mov    0xc(%ebp),%eax
  800695:	8b 00                	mov    (%eax),%eax
  800697:	8d 48 01             	lea    0x1(%eax),%ecx
  80069a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80069d:	89 0a                	mov    %ecx,(%edx)
  80069f:	8b 55 08             	mov    0x8(%ebp),%edx
  8006a2:	88 d1                	mov    %dl,%cl
  8006a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006a7:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8006ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ae:	8b 00                	mov    (%eax),%eax
  8006b0:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006b5:	75 30                	jne    8006e7 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8006b7:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  8006bd:	a0 44 30 80 00       	mov    0x803044,%al
  8006c2:	0f b6 c0             	movzbl %al,%eax
  8006c5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006c8:	8b 09                	mov    (%ecx),%ecx
  8006ca:	89 cb                	mov    %ecx,%ebx
  8006cc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006cf:	83 c1 08             	add    $0x8,%ecx
  8006d2:	52                   	push   %edx
  8006d3:	50                   	push   %eax
  8006d4:	53                   	push   %ebx
  8006d5:	51                   	push   %ecx
  8006d6:	e8 57 11 00 00       	call   801832 <sys_cputs>
  8006db:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ea:	8b 40 04             	mov    0x4(%eax),%eax
  8006ed:	8d 50 01             	lea    0x1(%eax),%edx
  8006f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006f3:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006f6:	90                   	nop
  8006f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006fa:	c9                   	leave  
  8006fb:	c3                   	ret    

008006fc <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006fc:	55                   	push   %ebp
  8006fd:	89 e5                	mov    %esp,%ebp
  8006ff:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800705:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80070c:	00 00 00 
	b.cnt = 0;
  80070f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800716:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800719:	ff 75 0c             	pushl  0xc(%ebp)
  80071c:	ff 75 08             	pushl  0x8(%ebp)
  80071f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800725:	50                   	push   %eax
  800726:	68 8b 06 80 00       	push   $0x80068b
  80072b:	e8 5a 02 00 00       	call   80098a <vprintfmt>
  800730:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800733:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  800739:	a0 44 30 80 00       	mov    0x803044,%al
  80073e:	0f b6 c0             	movzbl %al,%eax
  800741:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800747:	52                   	push   %edx
  800748:	50                   	push   %eax
  800749:	51                   	push   %ecx
  80074a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800750:	83 c0 08             	add    $0x8,%eax
  800753:	50                   	push   %eax
  800754:	e8 d9 10 00 00       	call   801832 <sys_cputs>
  800759:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80075c:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  800763:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800769:	c9                   	leave  
  80076a:	c3                   	ret    

0080076b <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80076b:	55                   	push   %ebp
  80076c:	89 e5                	mov    %esp,%ebp
  80076e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800771:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  800778:	8d 45 0c             	lea    0xc(%ebp),%eax
  80077b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80077e:	8b 45 08             	mov    0x8(%ebp),%eax
  800781:	83 ec 08             	sub    $0x8,%esp
  800784:	ff 75 f4             	pushl  -0xc(%ebp)
  800787:	50                   	push   %eax
  800788:	e8 6f ff ff ff       	call   8006fc <vcprintf>
  80078d:	83 c4 10             	add    $0x10,%esp
  800790:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800793:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800796:	c9                   	leave  
  800797:	c3                   	ret    

00800798 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800798:	55                   	push   %ebp
  800799:	89 e5                	mov    %esp,%ebp
  80079b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80079e:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  8007a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a8:	c1 e0 08             	shl    $0x8,%eax
  8007ab:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  8007b0:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007b3:	83 c0 04             	add    $0x4,%eax
  8007b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007bc:	83 ec 08             	sub    $0x8,%esp
  8007bf:	ff 75 f4             	pushl  -0xc(%ebp)
  8007c2:	50                   	push   %eax
  8007c3:	e8 34 ff ff ff       	call   8006fc <vcprintf>
  8007c8:	83 c4 10             	add    $0x10,%esp
  8007cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8007ce:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  8007d5:	07 00 00 

	return cnt;
  8007d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007db:	c9                   	leave  
  8007dc:	c3                   	ret    

008007dd <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8007dd:	55                   	push   %ebp
  8007de:	89 e5                	mov    %esp,%ebp
  8007e0:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8007e3:	e8 8e 10 00 00       	call   801876 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8007e8:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8007ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f1:	83 ec 08             	sub    $0x8,%esp
  8007f4:	ff 75 f4             	pushl  -0xc(%ebp)
  8007f7:	50                   	push   %eax
  8007f8:	e8 ff fe ff ff       	call   8006fc <vcprintf>
  8007fd:	83 c4 10             	add    $0x10,%esp
  800800:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800803:	e8 88 10 00 00       	call   801890 <sys_unlock_cons>
	return cnt;
  800808:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80080b:	c9                   	leave  
  80080c:	c3                   	ret    

0080080d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80080d:	55                   	push   %ebp
  80080e:	89 e5                	mov    %esp,%ebp
  800810:	53                   	push   %ebx
  800811:	83 ec 14             	sub    $0x14,%esp
  800814:	8b 45 10             	mov    0x10(%ebp),%eax
  800817:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80081a:	8b 45 14             	mov    0x14(%ebp),%eax
  80081d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800820:	8b 45 18             	mov    0x18(%ebp),%eax
  800823:	ba 00 00 00 00       	mov    $0x0,%edx
  800828:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80082b:	77 55                	ja     800882 <printnum+0x75>
  80082d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800830:	72 05                	jb     800837 <printnum+0x2a>
  800832:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800835:	77 4b                	ja     800882 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800837:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80083a:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80083d:	8b 45 18             	mov    0x18(%ebp),%eax
  800840:	ba 00 00 00 00       	mov    $0x0,%edx
  800845:	52                   	push   %edx
  800846:	50                   	push   %eax
  800847:	ff 75 f4             	pushl  -0xc(%ebp)
  80084a:	ff 75 f0             	pushl  -0x10(%ebp)
  80084d:	e8 aa 16 00 00       	call   801efc <__udivdi3>
  800852:	83 c4 10             	add    $0x10,%esp
  800855:	83 ec 04             	sub    $0x4,%esp
  800858:	ff 75 20             	pushl  0x20(%ebp)
  80085b:	53                   	push   %ebx
  80085c:	ff 75 18             	pushl  0x18(%ebp)
  80085f:	52                   	push   %edx
  800860:	50                   	push   %eax
  800861:	ff 75 0c             	pushl  0xc(%ebp)
  800864:	ff 75 08             	pushl  0x8(%ebp)
  800867:	e8 a1 ff ff ff       	call   80080d <printnum>
  80086c:	83 c4 20             	add    $0x20,%esp
  80086f:	eb 1a                	jmp    80088b <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800871:	83 ec 08             	sub    $0x8,%esp
  800874:	ff 75 0c             	pushl  0xc(%ebp)
  800877:	ff 75 20             	pushl  0x20(%ebp)
  80087a:	8b 45 08             	mov    0x8(%ebp),%eax
  80087d:	ff d0                	call   *%eax
  80087f:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800882:	ff 4d 1c             	decl   0x1c(%ebp)
  800885:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800889:	7f e6                	jg     800871 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80088b:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80088e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800893:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800896:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800899:	53                   	push   %ebx
  80089a:	51                   	push   %ecx
  80089b:	52                   	push   %edx
  80089c:	50                   	push   %eax
  80089d:	e8 6a 17 00 00       	call   80200c <__umoddi3>
  8008a2:	83 c4 10             	add    $0x10,%esp
  8008a5:	05 34 28 80 00       	add    $0x802834,%eax
  8008aa:	8a 00                	mov    (%eax),%al
  8008ac:	0f be c0             	movsbl %al,%eax
  8008af:	83 ec 08             	sub    $0x8,%esp
  8008b2:	ff 75 0c             	pushl  0xc(%ebp)
  8008b5:	50                   	push   %eax
  8008b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b9:	ff d0                	call   *%eax
  8008bb:	83 c4 10             	add    $0x10,%esp
}
  8008be:	90                   	nop
  8008bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008c2:	c9                   	leave  
  8008c3:	c3                   	ret    

008008c4 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008c4:	55                   	push   %ebp
  8008c5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008c7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008cb:	7e 1c                	jle    8008e9 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d0:	8b 00                	mov    (%eax),%eax
  8008d2:	8d 50 08             	lea    0x8(%eax),%edx
  8008d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d8:	89 10                	mov    %edx,(%eax)
  8008da:	8b 45 08             	mov    0x8(%ebp),%eax
  8008dd:	8b 00                	mov    (%eax),%eax
  8008df:	83 e8 08             	sub    $0x8,%eax
  8008e2:	8b 50 04             	mov    0x4(%eax),%edx
  8008e5:	8b 00                	mov    (%eax),%eax
  8008e7:	eb 40                	jmp    800929 <getuint+0x65>
	else if (lflag)
  8008e9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008ed:	74 1e                	je     80090d <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f2:	8b 00                	mov    (%eax),%eax
  8008f4:	8d 50 04             	lea    0x4(%eax),%edx
  8008f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fa:	89 10                	mov    %edx,(%eax)
  8008fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ff:	8b 00                	mov    (%eax),%eax
  800901:	83 e8 04             	sub    $0x4,%eax
  800904:	8b 00                	mov    (%eax),%eax
  800906:	ba 00 00 00 00       	mov    $0x0,%edx
  80090b:	eb 1c                	jmp    800929 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80090d:	8b 45 08             	mov    0x8(%ebp),%eax
  800910:	8b 00                	mov    (%eax),%eax
  800912:	8d 50 04             	lea    0x4(%eax),%edx
  800915:	8b 45 08             	mov    0x8(%ebp),%eax
  800918:	89 10                	mov    %edx,(%eax)
  80091a:	8b 45 08             	mov    0x8(%ebp),%eax
  80091d:	8b 00                	mov    (%eax),%eax
  80091f:	83 e8 04             	sub    $0x4,%eax
  800922:	8b 00                	mov    (%eax),%eax
  800924:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800929:	5d                   	pop    %ebp
  80092a:	c3                   	ret    

0080092b <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80092b:	55                   	push   %ebp
  80092c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80092e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800932:	7e 1c                	jle    800950 <getint+0x25>
		return va_arg(*ap, long long);
  800934:	8b 45 08             	mov    0x8(%ebp),%eax
  800937:	8b 00                	mov    (%eax),%eax
  800939:	8d 50 08             	lea    0x8(%eax),%edx
  80093c:	8b 45 08             	mov    0x8(%ebp),%eax
  80093f:	89 10                	mov    %edx,(%eax)
  800941:	8b 45 08             	mov    0x8(%ebp),%eax
  800944:	8b 00                	mov    (%eax),%eax
  800946:	83 e8 08             	sub    $0x8,%eax
  800949:	8b 50 04             	mov    0x4(%eax),%edx
  80094c:	8b 00                	mov    (%eax),%eax
  80094e:	eb 38                	jmp    800988 <getint+0x5d>
	else if (lflag)
  800950:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800954:	74 1a                	je     800970 <getint+0x45>
		return va_arg(*ap, long);
  800956:	8b 45 08             	mov    0x8(%ebp),%eax
  800959:	8b 00                	mov    (%eax),%eax
  80095b:	8d 50 04             	lea    0x4(%eax),%edx
  80095e:	8b 45 08             	mov    0x8(%ebp),%eax
  800961:	89 10                	mov    %edx,(%eax)
  800963:	8b 45 08             	mov    0x8(%ebp),%eax
  800966:	8b 00                	mov    (%eax),%eax
  800968:	83 e8 04             	sub    $0x4,%eax
  80096b:	8b 00                	mov    (%eax),%eax
  80096d:	99                   	cltd   
  80096e:	eb 18                	jmp    800988 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800970:	8b 45 08             	mov    0x8(%ebp),%eax
  800973:	8b 00                	mov    (%eax),%eax
  800975:	8d 50 04             	lea    0x4(%eax),%edx
  800978:	8b 45 08             	mov    0x8(%ebp),%eax
  80097b:	89 10                	mov    %edx,(%eax)
  80097d:	8b 45 08             	mov    0x8(%ebp),%eax
  800980:	8b 00                	mov    (%eax),%eax
  800982:	83 e8 04             	sub    $0x4,%eax
  800985:	8b 00                	mov    (%eax),%eax
  800987:	99                   	cltd   
}
  800988:	5d                   	pop    %ebp
  800989:	c3                   	ret    

0080098a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80098a:	55                   	push   %ebp
  80098b:	89 e5                	mov    %esp,%ebp
  80098d:	56                   	push   %esi
  80098e:	53                   	push   %ebx
  80098f:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800992:	eb 17                	jmp    8009ab <vprintfmt+0x21>
			if (ch == '\0')
  800994:	85 db                	test   %ebx,%ebx
  800996:	0f 84 c1 03 00 00    	je     800d5d <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80099c:	83 ec 08             	sub    $0x8,%esp
  80099f:	ff 75 0c             	pushl  0xc(%ebp)
  8009a2:	53                   	push   %ebx
  8009a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a6:	ff d0                	call   *%eax
  8009a8:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ae:	8d 50 01             	lea    0x1(%eax),%edx
  8009b1:	89 55 10             	mov    %edx,0x10(%ebp)
  8009b4:	8a 00                	mov    (%eax),%al
  8009b6:	0f b6 d8             	movzbl %al,%ebx
  8009b9:	83 fb 25             	cmp    $0x25,%ebx
  8009bc:	75 d6                	jne    800994 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009be:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8009c2:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009c9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009d0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009d7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009de:	8b 45 10             	mov    0x10(%ebp),%eax
  8009e1:	8d 50 01             	lea    0x1(%eax),%edx
  8009e4:	89 55 10             	mov    %edx,0x10(%ebp)
  8009e7:	8a 00                	mov    (%eax),%al
  8009e9:	0f b6 d8             	movzbl %al,%ebx
  8009ec:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009ef:	83 f8 5b             	cmp    $0x5b,%eax
  8009f2:	0f 87 3d 03 00 00    	ja     800d35 <vprintfmt+0x3ab>
  8009f8:	8b 04 85 58 28 80 00 	mov    0x802858(,%eax,4),%eax
  8009ff:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a01:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800a05:	eb d7                	jmp    8009de <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a07:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a0b:	eb d1                	jmp    8009de <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a0d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a14:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a17:	89 d0                	mov    %edx,%eax
  800a19:	c1 e0 02             	shl    $0x2,%eax
  800a1c:	01 d0                	add    %edx,%eax
  800a1e:	01 c0                	add    %eax,%eax
  800a20:	01 d8                	add    %ebx,%eax
  800a22:	83 e8 30             	sub    $0x30,%eax
  800a25:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a28:	8b 45 10             	mov    0x10(%ebp),%eax
  800a2b:	8a 00                	mov    (%eax),%al
  800a2d:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a30:	83 fb 2f             	cmp    $0x2f,%ebx
  800a33:	7e 3e                	jle    800a73 <vprintfmt+0xe9>
  800a35:	83 fb 39             	cmp    $0x39,%ebx
  800a38:	7f 39                	jg     800a73 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a3a:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a3d:	eb d5                	jmp    800a14 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a3f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a42:	83 c0 04             	add    $0x4,%eax
  800a45:	89 45 14             	mov    %eax,0x14(%ebp)
  800a48:	8b 45 14             	mov    0x14(%ebp),%eax
  800a4b:	83 e8 04             	sub    $0x4,%eax
  800a4e:	8b 00                	mov    (%eax),%eax
  800a50:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a53:	eb 1f                	jmp    800a74 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a55:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a59:	79 83                	jns    8009de <vprintfmt+0x54>
				width = 0;
  800a5b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a62:	e9 77 ff ff ff       	jmp    8009de <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a67:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a6e:	e9 6b ff ff ff       	jmp    8009de <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a73:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a74:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a78:	0f 89 60 ff ff ff    	jns    8009de <vprintfmt+0x54>
				width = precision, precision = -1;
  800a7e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a81:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a84:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a8b:	e9 4e ff ff ff       	jmp    8009de <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a90:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a93:	e9 46 ff ff ff       	jmp    8009de <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a98:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9b:	83 c0 04             	add    $0x4,%eax
  800a9e:	89 45 14             	mov    %eax,0x14(%ebp)
  800aa1:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa4:	83 e8 04             	sub    $0x4,%eax
  800aa7:	8b 00                	mov    (%eax),%eax
  800aa9:	83 ec 08             	sub    $0x8,%esp
  800aac:	ff 75 0c             	pushl  0xc(%ebp)
  800aaf:	50                   	push   %eax
  800ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab3:	ff d0                	call   *%eax
  800ab5:	83 c4 10             	add    $0x10,%esp
			break;
  800ab8:	e9 9b 02 00 00       	jmp    800d58 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800abd:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac0:	83 c0 04             	add    $0x4,%eax
  800ac3:	89 45 14             	mov    %eax,0x14(%ebp)
  800ac6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac9:	83 e8 04             	sub    $0x4,%eax
  800acc:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ace:	85 db                	test   %ebx,%ebx
  800ad0:	79 02                	jns    800ad4 <vprintfmt+0x14a>
				err = -err;
  800ad2:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ad4:	83 fb 64             	cmp    $0x64,%ebx
  800ad7:	7f 0b                	jg     800ae4 <vprintfmt+0x15a>
  800ad9:	8b 34 9d a0 26 80 00 	mov    0x8026a0(,%ebx,4),%esi
  800ae0:	85 f6                	test   %esi,%esi
  800ae2:	75 19                	jne    800afd <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ae4:	53                   	push   %ebx
  800ae5:	68 45 28 80 00       	push   $0x802845
  800aea:	ff 75 0c             	pushl  0xc(%ebp)
  800aed:	ff 75 08             	pushl  0x8(%ebp)
  800af0:	e8 70 02 00 00       	call   800d65 <printfmt>
  800af5:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800af8:	e9 5b 02 00 00       	jmp    800d58 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800afd:	56                   	push   %esi
  800afe:	68 4e 28 80 00       	push   $0x80284e
  800b03:	ff 75 0c             	pushl  0xc(%ebp)
  800b06:	ff 75 08             	pushl  0x8(%ebp)
  800b09:	e8 57 02 00 00       	call   800d65 <printfmt>
  800b0e:	83 c4 10             	add    $0x10,%esp
			break;
  800b11:	e9 42 02 00 00       	jmp    800d58 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b16:	8b 45 14             	mov    0x14(%ebp),%eax
  800b19:	83 c0 04             	add    $0x4,%eax
  800b1c:	89 45 14             	mov    %eax,0x14(%ebp)
  800b1f:	8b 45 14             	mov    0x14(%ebp),%eax
  800b22:	83 e8 04             	sub    $0x4,%eax
  800b25:	8b 30                	mov    (%eax),%esi
  800b27:	85 f6                	test   %esi,%esi
  800b29:	75 05                	jne    800b30 <vprintfmt+0x1a6>
				p = "(null)";
  800b2b:	be 51 28 80 00       	mov    $0x802851,%esi
			if (width > 0 && padc != '-')
  800b30:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b34:	7e 6d                	jle    800ba3 <vprintfmt+0x219>
  800b36:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b3a:	74 67                	je     800ba3 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b3c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b3f:	83 ec 08             	sub    $0x8,%esp
  800b42:	50                   	push   %eax
  800b43:	56                   	push   %esi
  800b44:	e8 1e 03 00 00       	call   800e67 <strnlen>
  800b49:	83 c4 10             	add    $0x10,%esp
  800b4c:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b4f:	eb 16                	jmp    800b67 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b51:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b55:	83 ec 08             	sub    $0x8,%esp
  800b58:	ff 75 0c             	pushl  0xc(%ebp)
  800b5b:	50                   	push   %eax
  800b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5f:	ff d0                	call   *%eax
  800b61:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b64:	ff 4d e4             	decl   -0x1c(%ebp)
  800b67:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b6b:	7f e4                	jg     800b51 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b6d:	eb 34                	jmp    800ba3 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b6f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b73:	74 1c                	je     800b91 <vprintfmt+0x207>
  800b75:	83 fb 1f             	cmp    $0x1f,%ebx
  800b78:	7e 05                	jle    800b7f <vprintfmt+0x1f5>
  800b7a:	83 fb 7e             	cmp    $0x7e,%ebx
  800b7d:	7e 12                	jle    800b91 <vprintfmt+0x207>
					putch('?', putdat);
  800b7f:	83 ec 08             	sub    $0x8,%esp
  800b82:	ff 75 0c             	pushl  0xc(%ebp)
  800b85:	6a 3f                	push   $0x3f
  800b87:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8a:	ff d0                	call   *%eax
  800b8c:	83 c4 10             	add    $0x10,%esp
  800b8f:	eb 0f                	jmp    800ba0 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b91:	83 ec 08             	sub    $0x8,%esp
  800b94:	ff 75 0c             	pushl  0xc(%ebp)
  800b97:	53                   	push   %ebx
  800b98:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9b:	ff d0                	call   *%eax
  800b9d:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ba0:	ff 4d e4             	decl   -0x1c(%ebp)
  800ba3:	89 f0                	mov    %esi,%eax
  800ba5:	8d 70 01             	lea    0x1(%eax),%esi
  800ba8:	8a 00                	mov    (%eax),%al
  800baa:	0f be d8             	movsbl %al,%ebx
  800bad:	85 db                	test   %ebx,%ebx
  800baf:	74 24                	je     800bd5 <vprintfmt+0x24b>
  800bb1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bb5:	78 b8                	js     800b6f <vprintfmt+0x1e5>
  800bb7:	ff 4d e0             	decl   -0x20(%ebp)
  800bba:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bbe:	79 af                	jns    800b6f <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bc0:	eb 13                	jmp    800bd5 <vprintfmt+0x24b>
				putch(' ', putdat);
  800bc2:	83 ec 08             	sub    $0x8,%esp
  800bc5:	ff 75 0c             	pushl  0xc(%ebp)
  800bc8:	6a 20                	push   $0x20
  800bca:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcd:	ff d0                	call   *%eax
  800bcf:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bd2:	ff 4d e4             	decl   -0x1c(%ebp)
  800bd5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bd9:	7f e7                	jg     800bc2 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800bdb:	e9 78 01 00 00       	jmp    800d58 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800be0:	83 ec 08             	sub    $0x8,%esp
  800be3:	ff 75 e8             	pushl  -0x18(%ebp)
  800be6:	8d 45 14             	lea    0x14(%ebp),%eax
  800be9:	50                   	push   %eax
  800bea:	e8 3c fd ff ff       	call   80092b <getint>
  800bef:	83 c4 10             	add    $0x10,%esp
  800bf2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bf5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800bf8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bfb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bfe:	85 d2                	test   %edx,%edx
  800c00:	79 23                	jns    800c25 <vprintfmt+0x29b>
				putch('-', putdat);
  800c02:	83 ec 08             	sub    $0x8,%esp
  800c05:	ff 75 0c             	pushl  0xc(%ebp)
  800c08:	6a 2d                	push   $0x2d
  800c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0d:	ff d0                	call   *%eax
  800c0f:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c15:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c18:	f7 d8                	neg    %eax
  800c1a:	83 d2 00             	adc    $0x0,%edx
  800c1d:	f7 da                	neg    %edx
  800c1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c22:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c25:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c2c:	e9 bc 00 00 00       	jmp    800ced <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c31:	83 ec 08             	sub    $0x8,%esp
  800c34:	ff 75 e8             	pushl  -0x18(%ebp)
  800c37:	8d 45 14             	lea    0x14(%ebp),%eax
  800c3a:	50                   	push   %eax
  800c3b:	e8 84 fc ff ff       	call   8008c4 <getuint>
  800c40:	83 c4 10             	add    $0x10,%esp
  800c43:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c46:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c49:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c50:	e9 98 00 00 00       	jmp    800ced <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c55:	83 ec 08             	sub    $0x8,%esp
  800c58:	ff 75 0c             	pushl  0xc(%ebp)
  800c5b:	6a 58                	push   $0x58
  800c5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c60:	ff d0                	call   *%eax
  800c62:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c65:	83 ec 08             	sub    $0x8,%esp
  800c68:	ff 75 0c             	pushl  0xc(%ebp)
  800c6b:	6a 58                	push   $0x58
  800c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c70:	ff d0                	call   *%eax
  800c72:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c75:	83 ec 08             	sub    $0x8,%esp
  800c78:	ff 75 0c             	pushl  0xc(%ebp)
  800c7b:	6a 58                	push   $0x58
  800c7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c80:	ff d0                	call   *%eax
  800c82:	83 c4 10             	add    $0x10,%esp
			break;
  800c85:	e9 ce 00 00 00       	jmp    800d58 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800c8a:	83 ec 08             	sub    $0x8,%esp
  800c8d:	ff 75 0c             	pushl  0xc(%ebp)
  800c90:	6a 30                	push   $0x30
  800c92:	8b 45 08             	mov    0x8(%ebp),%eax
  800c95:	ff d0                	call   *%eax
  800c97:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c9a:	83 ec 08             	sub    $0x8,%esp
  800c9d:	ff 75 0c             	pushl  0xc(%ebp)
  800ca0:	6a 78                	push   $0x78
  800ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca5:	ff d0                	call   *%eax
  800ca7:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800caa:	8b 45 14             	mov    0x14(%ebp),%eax
  800cad:	83 c0 04             	add    $0x4,%eax
  800cb0:	89 45 14             	mov    %eax,0x14(%ebp)
  800cb3:	8b 45 14             	mov    0x14(%ebp),%eax
  800cb6:	83 e8 04             	sub    $0x4,%eax
  800cb9:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cbb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cbe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800cc5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ccc:	eb 1f                	jmp    800ced <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800cce:	83 ec 08             	sub    $0x8,%esp
  800cd1:	ff 75 e8             	pushl  -0x18(%ebp)
  800cd4:	8d 45 14             	lea    0x14(%ebp),%eax
  800cd7:	50                   	push   %eax
  800cd8:	e8 e7 fb ff ff       	call   8008c4 <getuint>
  800cdd:	83 c4 10             	add    $0x10,%esp
  800ce0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ce3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ce6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ced:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800cf1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cf4:	83 ec 04             	sub    $0x4,%esp
  800cf7:	52                   	push   %edx
  800cf8:	ff 75 e4             	pushl  -0x1c(%ebp)
  800cfb:	50                   	push   %eax
  800cfc:	ff 75 f4             	pushl  -0xc(%ebp)
  800cff:	ff 75 f0             	pushl  -0x10(%ebp)
  800d02:	ff 75 0c             	pushl  0xc(%ebp)
  800d05:	ff 75 08             	pushl  0x8(%ebp)
  800d08:	e8 00 fb ff ff       	call   80080d <printnum>
  800d0d:	83 c4 20             	add    $0x20,%esp
			break;
  800d10:	eb 46                	jmp    800d58 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d12:	83 ec 08             	sub    $0x8,%esp
  800d15:	ff 75 0c             	pushl  0xc(%ebp)
  800d18:	53                   	push   %ebx
  800d19:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1c:	ff d0                	call   *%eax
  800d1e:	83 c4 10             	add    $0x10,%esp
			break;
  800d21:	eb 35                	jmp    800d58 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800d23:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800d2a:	eb 2c                	jmp    800d58 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800d2c:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800d33:	eb 23                	jmp    800d58 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d35:	83 ec 08             	sub    $0x8,%esp
  800d38:	ff 75 0c             	pushl  0xc(%ebp)
  800d3b:	6a 25                	push   $0x25
  800d3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d40:	ff d0                	call   *%eax
  800d42:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d45:	ff 4d 10             	decl   0x10(%ebp)
  800d48:	eb 03                	jmp    800d4d <vprintfmt+0x3c3>
  800d4a:	ff 4d 10             	decl   0x10(%ebp)
  800d4d:	8b 45 10             	mov    0x10(%ebp),%eax
  800d50:	48                   	dec    %eax
  800d51:	8a 00                	mov    (%eax),%al
  800d53:	3c 25                	cmp    $0x25,%al
  800d55:	75 f3                	jne    800d4a <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800d57:	90                   	nop
		}
	}
  800d58:	e9 35 fc ff ff       	jmp    800992 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d5d:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d5e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d61:	5b                   	pop    %ebx
  800d62:	5e                   	pop    %esi
  800d63:	5d                   	pop    %ebp
  800d64:	c3                   	ret    

00800d65 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d65:	55                   	push   %ebp
  800d66:	89 e5                	mov    %esp,%ebp
  800d68:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d6b:	8d 45 10             	lea    0x10(%ebp),%eax
  800d6e:	83 c0 04             	add    $0x4,%eax
  800d71:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d74:	8b 45 10             	mov    0x10(%ebp),%eax
  800d77:	ff 75 f4             	pushl  -0xc(%ebp)
  800d7a:	50                   	push   %eax
  800d7b:	ff 75 0c             	pushl  0xc(%ebp)
  800d7e:	ff 75 08             	pushl  0x8(%ebp)
  800d81:	e8 04 fc ff ff       	call   80098a <vprintfmt>
  800d86:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d89:	90                   	nop
  800d8a:	c9                   	leave  
  800d8b:	c3                   	ret    

00800d8c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d8c:	55                   	push   %ebp
  800d8d:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d92:	8b 40 08             	mov    0x8(%eax),%eax
  800d95:	8d 50 01             	lea    0x1(%eax),%edx
  800d98:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9b:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da1:	8b 10                	mov    (%eax),%edx
  800da3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da6:	8b 40 04             	mov    0x4(%eax),%eax
  800da9:	39 c2                	cmp    %eax,%edx
  800dab:	73 12                	jae    800dbf <sprintputch+0x33>
		*b->buf++ = ch;
  800dad:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db0:	8b 00                	mov    (%eax),%eax
  800db2:	8d 48 01             	lea    0x1(%eax),%ecx
  800db5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800db8:	89 0a                	mov    %ecx,(%edx)
  800dba:	8b 55 08             	mov    0x8(%ebp),%edx
  800dbd:	88 10                	mov    %dl,(%eax)
}
  800dbf:	90                   	nop
  800dc0:	5d                   	pop    %ebp
  800dc1:	c3                   	ret    

00800dc2 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800dc2:	55                   	push   %ebp
  800dc3:	89 e5                	mov    %esp,%ebp
  800dc5:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800dc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800dce:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd7:	01 d0                	add    %edx,%eax
  800dd9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ddc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800de3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800de7:	74 06                	je     800def <vsnprintf+0x2d>
  800de9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ded:	7f 07                	jg     800df6 <vsnprintf+0x34>
		return -E_INVAL;
  800def:	b8 03 00 00 00       	mov    $0x3,%eax
  800df4:	eb 20                	jmp    800e16 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800df6:	ff 75 14             	pushl  0x14(%ebp)
  800df9:	ff 75 10             	pushl  0x10(%ebp)
  800dfc:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800dff:	50                   	push   %eax
  800e00:	68 8c 0d 80 00       	push   $0x800d8c
  800e05:	e8 80 fb ff ff       	call   80098a <vprintfmt>
  800e0a:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800e0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e10:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e13:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e16:	c9                   	leave  
  800e17:	c3                   	ret    

00800e18 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e18:	55                   	push   %ebp
  800e19:	89 e5                	mov    %esp,%ebp
  800e1b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e1e:	8d 45 10             	lea    0x10(%ebp),%eax
  800e21:	83 c0 04             	add    $0x4,%eax
  800e24:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e27:	8b 45 10             	mov    0x10(%ebp),%eax
  800e2a:	ff 75 f4             	pushl  -0xc(%ebp)
  800e2d:	50                   	push   %eax
  800e2e:	ff 75 0c             	pushl  0xc(%ebp)
  800e31:	ff 75 08             	pushl  0x8(%ebp)
  800e34:	e8 89 ff ff ff       	call   800dc2 <vsnprintf>
  800e39:	83 c4 10             	add    $0x10,%esp
  800e3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e42:	c9                   	leave  
  800e43:	c3                   	ret    

00800e44 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e44:	55                   	push   %ebp
  800e45:	89 e5                	mov    %esp,%ebp
  800e47:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e4a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e51:	eb 06                	jmp    800e59 <strlen+0x15>
		n++;
  800e53:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e56:	ff 45 08             	incl   0x8(%ebp)
  800e59:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5c:	8a 00                	mov    (%eax),%al
  800e5e:	84 c0                	test   %al,%al
  800e60:	75 f1                	jne    800e53 <strlen+0xf>
		n++;
	return n;
  800e62:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e65:	c9                   	leave  
  800e66:	c3                   	ret    

00800e67 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e67:	55                   	push   %ebp
  800e68:	89 e5                	mov    %esp,%ebp
  800e6a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e6d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e74:	eb 09                	jmp    800e7f <strnlen+0x18>
		n++;
  800e76:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e79:	ff 45 08             	incl   0x8(%ebp)
  800e7c:	ff 4d 0c             	decl   0xc(%ebp)
  800e7f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e83:	74 09                	je     800e8e <strnlen+0x27>
  800e85:	8b 45 08             	mov    0x8(%ebp),%eax
  800e88:	8a 00                	mov    (%eax),%al
  800e8a:	84 c0                	test   %al,%al
  800e8c:	75 e8                	jne    800e76 <strnlen+0xf>
		n++;
	return n;
  800e8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e91:	c9                   	leave  
  800e92:	c3                   	ret    

00800e93 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e93:	55                   	push   %ebp
  800e94:	89 e5                	mov    %esp,%ebp
  800e96:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e99:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e9f:	90                   	nop
  800ea0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea3:	8d 50 01             	lea    0x1(%eax),%edx
  800ea6:	89 55 08             	mov    %edx,0x8(%ebp)
  800ea9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eac:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eaf:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800eb2:	8a 12                	mov    (%edx),%dl
  800eb4:	88 10                	mov    %dl,(%eax)
  800eb6:	8a 00                	mov    (%eax),%al
  800eb8:	84 c0                	test   %al,%al
  800eba:	75 e4                	jne    800ea0 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ebc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ebf:	c9                   	leave  
  800ec0:	c3                   	ret    

00800ec1 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800ec1:	55                   	push   %ebp
  800ec2:	89 e5                	mov    %esp,%ebp
  800ec4:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800ec7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eca:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ecd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ed4:	eb 1f                	jmp    800ef5 <strncpy+0x34>
		*dst++ = *src;
  800ed6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed9:	8d 50 01             	lea    0x1(%eax),%edx
  800edc:	89 55 08             	mov    %edx,0x8(%ebp)
  800edf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ee2:	8a 12                	mov    (%edx),%dl
  800ee4:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ee6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee9:	8a 00                	mov    (%eax),%al
  800eeb:	84 c0                	test   %al,%al
  800eed:	74 03                	je     800ef2 <strncpy+0x31>
			src++;
  800eef:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ef2:	ff 45 fc             	incl   -0x4(%ebp)
  800ef5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ef8:	3b 45 10             	cmp    0x10(%ebp),%eax
  800efb:	72 d9                	jb     800ed6 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800efd:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f00:	c9                   	leave  
  800f01:	c3                   	ret    

00800f02 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800f02:	55                   	push   %ebp
  800f03:	89 e5                	mov    %esp,%ebp
  800f05:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800f08:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800f0e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f12:	74 30                	je     800f44 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800f14:	eb 16                	jmp    800f2c <strlcpy+0x2a>
			*dst++ = *src++;
  800f16:	8b 45 08             	mov    0x8(%ebp),%eax
  800f19:	8d 50 01             	lea    0x1(%eax),%edx
  800f1c:	89 55 08             	mov    %edx,0x8(%ebp)
  800f1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f22:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f25:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f28:	8a 12                	mov    (%edx),%dl
  800f2a:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f2c:	ff 4d 10             	decl   0x10(%ebp)
  800f2f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f33:	74 09                	je     800f3e <strlcpy+0x3c>
  800f35:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f38:	8a 00                	mov    (%eax),%al
  800f3a:	84 c0                	test   %al,%al
  800f3c:	75 d8                	jne    800f16 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f41:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f44:	8b 55 08             	mov    0x8(%ebp),%edx
  800f47:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f4a:	29 c2                	sub    %eax,%edx
  800f4c:	89 d0                	mov    %edx,%eax
}
  800f4e:	c9                   	leave  
  800f4f:	c3                   	ret    

00800f50 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f50:	55                   	push   %ebp
  800f51:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f53:	eb 06                	jmp    800f5b <strcmp+0xb>
		p++, q++;
  800f55:	ff 45 08             	incl   0x8(%ebp)
  800f58:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5e:	8a 00                	mov    (%eax),%al
  800f60:	84 c0                	test   %al,%al
  800f62:	74 0e                	je     800f72 <strcmp+0x22>
  800f64:	8b 45 08             	mov    0x8(%ebp),%eax
  800f67:	8a 10                	mov    (%eax),%dl
  800f69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6c:	8a 00                	mov    (%eax),%al
  800f6e:	38 c2                	cmp    %al,%dl
  800f70:	74 e3                	je     800f55 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f72:	8b 45 08             	mov    0x8(%ebp),%eax
  800f75:	8a 00                	mov    (%eax),%al
  800f77:	0f b6 d0             	movzbl %al,%edx
  800f7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f7d:	8a 00                	mov    (%eax),%al
  800f7f:	0f b6 c0             	movzbl %al,%eax
  800f82:	29 c2                	sub    %eax,%edx
  800f84:	89 d0                	mov    %edx,%eax
}
  800f86:	5d                   	pop    %ebp
  800f87:	c3                   	ret    

00800f88 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f88:	55                   	push   %ebp
  800f89:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f8b:	eb 09                	jmp    800f96 <strncmp+0xe>
		n--, p++, q++;
  800f8d:	ff 4d 10             	decl   0x10(%ebp)
  800f90:	ff 45 08             	incl   0x8(%ebp)
  800f93:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f96:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f9a:	74 17                	je     800fb3 <strncmp+0x2b>
  800f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9f:	8a 00                	mov    (%eax),%al
  800fa1:	84 c0                	test   %al,%al
  800fa3:	74 0e                	je     800fb3 <strncmp+0x2b>
  800fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa8:	8a 10                	mov    (%eax),%dl
  800faa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fad:	8a 00                	mov    (%eax),%al
  800faf:	38 c2                	cmp    %al,%dl
  800fb1:	74 da                	je     800f8d <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800fb3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fb7:	75 07                	jne    800fc0 <strncmp+0x38>
		return 0;
  800fb9:	b8 00 00 00 00       	mov    $0x0,%eax
  800fbe:	eb 14                	jmp    800fd4 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800fc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc3:	8a 00                	mov    (%eax),%al
  800fc5:	0f b6 d0             	movzbl %al,%edx
  800fc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fcb:	8a 00                	mov    (%eax),%al
  800fcd:	0f b6 c0             	movzbl %al,%eax
  800fd0:	29 c2                	sub    %eax,%edx
  800fd2:	89 d0                	mov    %edx,%eax
}
  800fd4:	5d                   	pop    %ebp
  800fd5:	c3                   	ret    

00800fd6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800fd6:	55                   	push   %ebp
  800fd7:	89 e5                	mov    %esp,%ebp
  800fd9:	83 ec 04             	sub    $0x4,%esp
  800fdc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fdf:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fe2:	eb 12                	jmp    800ff6 <strchr+0x20>
		if (*s == c)
  800fe4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe7:	8a 00                	mov    (%eax),%al
  800fe9:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fec:	75 05                	jne    800ff3 <strchr+0x1d>
			return (char *) s;
  800fee:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff1:	eb 11                	jmp    801004 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ff3:	ff 45 08             	incl   0x8(%ebp)
  800ff6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff9:	8a 00                	mov    (%eax),%al
  800ffb:	84 c0                	test   %al,%al
  800ffd:	75 e5                	jne    800fe4 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800fff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801004:	c9                   	leave  
  801005:	c3                   	ret    

00801006 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801006:	55                   	push   %ebp
  801007:	89 e5                	mov    %esp,%ebp
  801009:	83 ec 04             	sub    $0x4,%esp
  80100c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80100f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801012:	eb 0d                	jmp    801021 <strfind+0x1b>
		if (*s == c)
  801014:	8b 45 08             	mov    0x8(%ebp),%eax
  801017:	8a 00                	mov    (%eax),%al
  801019:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80101c:	74 0e                	je     80102c <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80101e:	ff 45 08             	incl   0x8(%ebp)
  801021:	8b 45 08             	mov    0x8(%ebp),%eax
  801024:	8a 00                	mov    (%eax),%al
  801026:	84 c0                	test   %al,%al
  801028:	75 ea                	jne    801014 <strfind+0xe>
  80102a:	eb 01                	jmp    80102d <strfind+0x27>
		if (*s == c)
			break;
  80102c:	90                   	nop
	return (char *) s;
  80102d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801030:	c9                   	leave  
  801031:	c3                   	ret    

00801032 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801032:	55                   	push   %ebp
  801033:	89 e5                	mov    %esp,%ebp
  801035:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801038:	8b 45 08             	mov    0x8(%ebp),%eax
  80103b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  80103e:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801042:	76 63                	jbe    8010a7 <memset+0x75>
		uint64 data_block = c;
  801044:	8b 45 0c             	mov    0xc(%ebp),%eax
  801047:	99                   	cltd   
  801048:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80104b:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  80104e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801051:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801054:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801058:	c1 e0 08             	shl    $0x8,%eax
  80105b:	09 45 f0             	or     %eax,-0x10(%ebp)
  80105e:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801061:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801064:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801067:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  80106b:	c1 e0 10             	shl    $0x10,%eax
  80106e:	09 45 f0             	or     %eax,-0x10(%ebp)
  801071:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801074:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801077:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80107a:	89 c2                	mov    %eax,%edx
  80107c:	b8 00 00 00 00       	mov    $0x0,%eax
  801081:	09 45 f0             	or     %eax,-0x10(%ebp)
  801084:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801087:	eb 18                	jmp    8010a1 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801089:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80108c:	8d 41 08             	lea    0x8(%ecx),%eax
  80108f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801092:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801095:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801098:	89 01                	mov    %eax,(%ecx)
  80109a:	89 51 04             	mov    %edx,0x4(%ecx)
  80109d:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  8010a1:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010a5:	77 e2                	ja     801089 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8010a7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010ab:	74 23                	je     8010d0 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8010ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010b0:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8010b3:	eb 0e                	jmp    8010c3 <memset+0x91>
			*p8++ = (uint8)c;
  8010b5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010b8:	8d 50 01             	lea    0x1(%eax),%edx
  8010bb:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010c1:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8010c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8010c6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010c9:	89 55 10             	mov    %edx,0x10(%ebp)
  8010cc:	85 c0                	test   %eax,%eax
  8010ce:	75 e5                	jne    8010b5 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8010d0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010d3:	c9                   	leave  
  8010d4:	c3                   	ret    

008010d5 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8010d5:	55                   	push   %ebp
  8010d6:	89 e5                	mov    %esp,%ebp
  8010d8:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8010db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010de:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8010e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8010e7:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010eb:	76 24                	jbe    801111 <memcpy+0x3c>
		while(n >= 8){
  8010ed:	eb 1c                	jmp    80110b <memcpy+0x36>
			*d64 = *s64;
  8010ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010f2:	8b 50 04             	mov    0x4(%eax),%edx
  8010f5:	8b 00                	mov    (%eax),%eax
  8010f7:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010fa:	89 01                	mov    %eax,(%ecx)
  8010fc:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8010ff:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801103:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801107:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  80110b:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80110f:	77 de                	ja     8010ef <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801111:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801115:	74 31                	je     801148 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801117:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80111a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  80111d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801120:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801123:	eb 16                	jmp    80113b <memcpy+0x66>
			*d8++ = *s8++;
  801125:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801128:	8d 50 01             	lea    0x1(%eax),%edx
  80112b:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80112e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801131:	8d 4a 01             	lea    0x1(%edx),%ecx
  801134:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801137:	8a 12                	mov    (%edx),%dl
  801139:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  80113b:	8b 45 10             	mov    0x10(%ebp),%eax
  80113e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801141:	89 55 10             	mov    %edx,0x10(%ebp)
  801144:	85 c0                	test   %eax,%eax
  801146:	75 dd                	jne    801125 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801148:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80114b:	c9                   	leave  
  80114c:	c3                   	ret    

0080114d <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80114d:	55                   	push   %ebp
  80114e:	89 e5                	mov    %esp,%ebp
  801150:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801153:	8b 45 0c             	mov    0xc(%ebp),%eax
  801156:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801159:	8b 45 08             	mov    0x8(%ebp),%eax
  80115c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80115f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801162:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801165:	73 50                	jae    8011b7 <memmove+0x6a>
  801167:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80116a:	8b 45 10             	mov    0x10(%ebp),%eax
  80116d:	01 d0                	add    %edx,%eax
  80116f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801172:	76 43                	jbe    8011b7 <memmove+0x6a>
		s += n;
  801174:	8b 45 10             	mov    0x10(%ebp),%eax
  801177:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80117a:	8b 45 10             	mov    0x10(%ebp),%eax
  80117d:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801180:	eb 10                	jmp    801192 <memmove+0x45>
			*--d = *--s;
  801182:	ff 4d f8             	decl   -0x8(%ebp)
  801185:	ff 4d fc             	decl   -0x4(%ebp)
  801188:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80118b:	8a 10                	mov    (%eax),%dl
  80118d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801190:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801192:	8b 45 10             	mov    0x10(%ebp),%eax
  801195:	8d 50 ff             	lea    -0x1(%eax),%edx
  801198:	89 55 10             	mov    %edx,0x10(%ebp)
  80119b:	85 c0                	test   %eax,%eax
  80119d:	75 e3                	jne    801182 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80119f:	eb 23                	jmp    8011c4 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8011a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011a4:	8d 50 01             	lea    0x1(%eax),%edx
  8011a7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011aa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011ad:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011b0:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8011b3:	8a 12                	mov    (%edx),%dl
  8011b5:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8011b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ba:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011bd:	89 55 10             	mov    %edx,0x10(%ebp)
  8011c0:	85 c0                	test   %eax,%eax
  8011c2:	75 dd                	jne    8011a1 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8011c4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011c7:	c9                   	leave  
  8011c8:	c3                   	ret    

008011c9 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8011c9:	55                   	push   %ebp
  8011ca:	89 e5                	mov    %esp,%ebp
  8011cc:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8011cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8011d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d8:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8011db:	eb 2a                	jmp    801207 <memcmp+0x3e>
		if (*s1 != *s2)
  8011dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011e0:	8a 10                	mov    (%eax),%dl
  8011e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011e5:	8a 00                	mov    (%eax),%al
  8011e7:	38 c2                	cmp    %al,%dl
  8011e9:	74 16                	je     801201 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8011eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011ee:	8a 00                	mov    (%eax),%al
  8011f0:	0f b6 d0             	movzbl %al,%edx
  8011f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011f6:	8a 00                	mov    (%eax),%al
  8011f8:	0f b6 c0             	movzbl %al,%eax
  8011fb:	29 c2                	sub    %eax,%edx
  8011fd:	89 d0                	mov    %edx,%eax
  8011ff:	eb 18                	jmp    801219 <memcmp+0x50>
		s1++, s2++;
  801201:	ff 45 fc             	incl   -0x4(%ebp)
  801204:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801207:	8b 45 10             	mov    0x10(%ebp),%eax
  80120a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80120d:	89 55 10             	mov    %edx,0x10(%ebp)
  801210:	85 c0                	test   %eax,%eax
  801212:	75 c9                	jne    8011dd <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801214:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801219:	c9                   	leave  
  80121a:	c3                   	ret    

0080121b <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80121b:	55                   	push   %ebp
  80121c:	89 e5                	mov    %esp,%ebp
  80121e:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801221:	8b 55 08             	mov    0x8(%ebp),%edx
  801224:	8b 45 10             	mov    0x10(%ebp),%eax
  801227:	01 d0                	add    %edx,%eax
  801229:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80122c:	eb 15                	jmp    801243 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80122e:	8b 45 08             	mov    0x8(%ebp),%eax
  801231:	8a 00                	mov    (%eax),%al
  801233:	0f b6 d0             	movzbl %al,%edx
  801236:	8b 45 0c             	mov    0xc(%ebp),%eax
  801239:	0f b6 c0             	movzbl %al,%eax
  80123c:	39 c2                	cmp    %eax,%edx
  80123e:	74 0d                	je     80124d <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801240:	ff 45 08             	incl   0x8(%ebp)
  801243:	8b 45 08             	mov    0x8(%ebp),%eax
  801246:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801249:	72 e3                	jb     80122e <memfind+0x13>
  80124b:	eb 01                	jmp    80124e <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80124d:	90                   	nop
	return (void *) s;
  80124e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801251:	c9                   	leave  
  801252:	c3                   	ret    

00801253 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801253:	55                   	push   %ebp
  801254:	89 e5                	mov    %esp,%ebp
  801256:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801259:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801260:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801267:	eb 03                	jmp    80126c <strtol+0x19>
		s++;
  801269:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80126c:	8b 45 08             	mov    0x8(%ebp),%eax
  80126f:	8a 00                	mov    (%eax),%al
  801271:	3c 20                	cmp    $0x20,%al
  801273:	74 f4                	je     801269 <strtol+0x16>
  801275:	8b 45 08             	mov    0x8(%ebp),%eax
  801278:	8a 00                	mov    (%eax),%al
  80127a:	3c 09                	cmp    $0x9,%al
  80127c:	74 eb                	je     801269 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80127e:	8b 45 08             	mov    0x8(%ebp),%eax
  801281:	8a 00                	mov    (%eax),%al
  801283:	3c 2b                	cmp    $0x2b,%al
  801285:	75 05                	jne    80128c <strtol+0x39>
		s++;
  801287:	ff 45 08             	incl   0x8(%ebp)
  80128a:	eb 13                	jmp    80129f <strtol+0x4c>
	else if (*s == '-')
  80128c:	8b 45 08             	mov    0x8(%ebp),%eax
  80128f:	8a 00                	mov    (%eax),%al
  801291:	3c 2d                	cmp    $0x2d,%al
  801293:	75 0a                	jne    80129f <strtol+0x4c>
		s++, neg = 1;
  801295:	ff 45 08             	incl   0x8(%ebp)
  801298:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80129f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012a3:	74 06                	je     8012ab <strtol+0x58>
  8012a5:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8012a9:	75 20                	jne    8012cb <strtol+0x78>
  8012ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ae:	8a 00                	mov    (%eax),%al
  8012b0:	3c 30                	cmp    $0x30,%al
  8012b2:	75 17                	jne    8012cb <strtol+0x78>
  8012b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b7:	40                   	inc    %eax
  8012b8:	8a 00                	mov    (%eax),%al
  8012ba:	3c 78                	cmp    $0x78,%al
  8012bc:	75 0d                	jne    8012cb <strtol+0x78>
		s += 2, base = 16;
  8012be:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8012c2:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8012c9:	eb 28                	jmp    8012f3 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8012cb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012cf:	75 15                	jne    8012e6 <strtol+0x93>
  8012d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d4:	8a 00                	mov    (%eax),%al
  8012d6:	3c 30                	cmp    $0x30,%al
  8012d8:	75 0c                	jne    8012e6 <strtol+0x93>
		s++, base = 8;
  8012da:	ff 45 08             	incl   0x8(%ebp)
  8012dd:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8012e4:	eb 0d                	jmp    8012f3 <strtol+0xa0>
	else if (base == 0)
  8012e6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012ea:	75 07                	jne    8012f3 <strtol+0xa0>
		base = 10;
  8012ec:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8012f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f6:	8a 00                	mov    (%eax),%al
  8012f8:	3c 2f                	cmp    $0x2f,%al
  8012fa:	7e 19                	jle    801315 <strtol+0xc2>
  8012fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ff:	8a 00                	mov    (%eax),%al
  801301:	3c 39                	cmp    $0x39,%al
  801303:	7f 10                	jg     801315 <strtol+0xc2>
			dig = *s - '0';
  801305:	8b 45 08             	mov    0x8(%ebp),%eax
  801308:	8a 00                	mov    (%eax),%al
  80130a:	0f be c0             	movsbl %al,%eax
  80130d:	83 e8 30             	sub    $0x30,%eax
  801310:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801313:	eb 42                	jmp    801357 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801315:	8b 45 08             	mov    0x8(%ebp),%eax
  801318:	8a 00                	mov    (%eax),%al
  80131a:	3c 60                	cmp    $0x60,%al
  80131c:	7e 19                	jle    801337 <strtol+0xe4>
  80131e:	8b 45 08             	mov    0x8(%ebp),%eax
  801321:	8a 00                	mov    (%eax),%al
  801323:	3c 7a                	cmp    $0x7a,%al
  801325:	7f 10                	jg     801337 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801327:	8b 45 08             	mov    0x8(%ebp),%eax
  80132a:	8a 00                	mov    (%eax),%al
  80132c:	0f be c0             	movsbl %al,%eax
  80132f:	83 e8 57             	sub    $0x57,%eax
  801332:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801335:	eb 20                	jmp    801357 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801337:	8b 45 08             	mov    0x8(%ebp),%eax
  80133a:	8a 00                	mov    (%eax),%al
  80133c:	3c 40                	cmp    $0x40,%al
  80133e:	7e 39                	jle    801379 <strtol+0x126>
  801340:	8b 45 08             	mov    0x8(%ebp),%eax
  801343:	8a 00                	mov    (%eax),%al
  801345:	3c 5a                	cmp    $0x5a,%al
  801347:	7f 30                	jg     801379 <strtol+0x126>
			dig = *s - 'A' + 10;
  801349:	8b 45 08             	mov    0x8(%ebp),%eax
  80134c:	8a 00                	mov    (%eax),%al
  80134e:	0f be c0             	movsbl %al,%eax
  801351:	83 e8 37             	sub    $0x37,%eax
  801354:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801357:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80135a:	3b 45 10             	cmp    0x10(%ebp),%eax
  80135d:	7d 19                	jge    801378 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80135f:	ff 45 08             	incl   0x8(%ebp)
  801362:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801365:	0f af 45 10          	imul   0x10(%ebp),%eax
  801369:	89 c2                	mov    %eax,%edx
  80136b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80136e:	01 d0                	add    %edx,%eax
  801370:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801373:	e9 7b ff ff ff       	jmp    8012f3 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801378:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801379:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80137d:	74 08                	je     801387 <strtol+0x134>
		*endptr = (char *) s;
  80137f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801382:	8b 55 08             	mov    0x8(%ebp),%edx
  801385:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801387:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80138b:	74 07                	je     801394 <strtol+0x141>
  80138d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801390:	f7 d8                	neg    %eax
  801392:	eb 03                	jmp    801397 <strtol+0x144>
  801394:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801397:	c9                   	leave  
  801398:	c3                   	ret    

00801399 <ltostr>:

void
ltostr(long value, char *str)
{
  801399:	55                   	push   %ebp
  80139a:	89 e5                	mov    %esp,%ebp
  80139c:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80139f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8013a6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8013ad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013b1:	79 13                	jns    8013c6 <ltostr+0x2d>
	{
		neg = 1;
  8013b3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8013ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013bd:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8013c0:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8013c3:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8013c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c9:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8013ce:	99                   	cltd   
  8013cf:	f7 f9                	idiv   %ecx
  8013d1:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8013d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013d7:	8d 50 01             	lea    0x1(%eax),%edx
  8013da:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013dd:	89 c2                	mov    %eax,%edx
  8013df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e2:	01 d0                	add    %edx,%eax
  8013e4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013e7:	83 c2 30             	add    $0x30,%edx
  8013ea:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8013ec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013ef:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8013f4:	f7 e9                	imul   %ecx
  8013f6:	c1 fa 02             	sar    $0x2,%edx
  8013f9:	89 c8                	mov    %ecx,%eax
  8013fb:	c1 f8 1f             	sar    $0x1f,%eax
  8013fe:	29 c2                	sub    %eax,%edx
  801400:	89 d0                	mov    %edx,%eax
  801402:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801405:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801409:	75 bb                	jne    8013c6 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80140b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801412:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801415:	48                   	dec    %eax
  801416:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801419:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80141d:	74 3d                	je     80145c <ltostr+0xc3>
		start = 1 ;
  80141f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801426:	eb 34                	jmp    80145c <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801428:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80142b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80142e:	01 d0                	add    %edx,%eax
  801430:	8a 00                	mov    (%eax),%al
  801432:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801435:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801438:	8b 45 0c             	mov    0xc(%ebp),%eax
  80143b:	01 c2                	add    %eax,%edx
  80143d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801440:	8b 45 0c             	mov    0xc(%ebp),%eax
  801443:	01 c8                	add    %ecx,%eax
  801445:	8a 00                	mov    (%eax),%al
  801447:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801449:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80144c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80144f:	01 c2                	add    %eax,%edx
  801451:	8a 45 eb             	mov    -0x15(%ebp),%al
  801454:	88 02                	mov    %al,(%edx)
		start++ ;
  801456:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801459:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80145c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80145f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801462:	7c c4                	jl     801428 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801464:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801467:	8b 45 0c             	mov    0xc(%ebp),%eax
  80146a:	01 d0                	add    %edx,%eax
  80146c:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80146f:	90                   	nop
  801470:	c9                   	leave  
  801471:	c3                   	ret    

00801472 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801472:	55                   	push   %ebp
  801473:	89 e5                	mov    %esp,%ebp
  801475:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801478:	ff 75 08             	pushl  0x8(%ebp)
  80147b:	e8 c4 f9 ff ff       	call   800e44 <strlen>
  801480:	83 c4 04             	add    $0x4,%esp
  801483:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801486:	ff 75 0c             	pushl  0xc(%ebp)
  801489:	e8 b6 f9 ff ff       	call   800e44 <strlen>
  80148e:	83 c4 04             	add    $0x4,%esp
  801491:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801494:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80149b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014a2:	eb 17                	jmp    8014bb <strcconcat+0x49>
		final[s] = str1[s] ;
  8014a4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8014aa:	01 c2                	add    %eax,%edx
  8014ac:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8014af:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b2:	01 c8                	add    %ecx,%eax
  8014b4:	8a 00                	mov    (%eax),%al
  8014b6:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8014b8:	ff 45 fc             	incl   -0x4(%ebp)
  8014bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014be:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8014c1:	7c e1                	jl     8014a4 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8014c3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8014ca:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8014d1:	eb 1f                	jmp    8014f2 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8014d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014d6:	8d 50 01             	lea    0x1(%eax),%edx
  8014d9:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014dc:	89 c2                	mov    %eax,%edx
  8014de:	8b 45 10             	mov    0x10(%ebp),%eax
  8014e1:	01 c2                	add    %eax,%edx
  8014e3:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8014e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e9:	01 c8                	add    %ecx,%eax
  8014eb:	8a 00                	mov    (%eax),%al
  8014ed:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8014ef:	ff 45 f8             	incl   -0x8(%ebp)
  8014f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014f5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8014f8:	7c d9                	jl     8014d3 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8014fa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801500:	01 d0                	add    %edx,%eax
  801502:	c6 00 00             	movb   $0x0,(%eax)
}
  801505:	90                   	nop
  801506:	c9                   	leave  
  801507:	c3                   	ret    

00801508 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801508:	55                   	push   %ebp
  801509:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80150b:	8b 45 14             	mov    0x14(%ebp),%eax
  80150e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801514:	8b 45 14             	mov    0x14(%ebp),%eax
  801517:	8b 00                	mov    (%eax),%eax
  801519:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801520:	8b 45 10             	mov    0x10(%ebp),%eax
  801523:	01 d0                	add    %edx,%eax
  801525:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80152b:	eb 0c                	jmp    801539 <strsplit+0x31>
			*string++ = 0;
  80152d:	8b 45 08             	mov    0x8(%ebp),%eax
  801530:	8d 50 01             	lea    0x1(%eax),%edx
  801533:	89 55 08             	mov    %edx,0x8(%ebp)
  801536:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801539:	8b 45 08             	mov    0x8(%ebp),%eax
  80153c:	8a 00                	mov    (%eax),%al
  80153e:	84 c0                	test   %al,%al
  801540:	74 18                	je     80155a <strsplit+0x52>
  801542:	8b 45 08             	mov    0x8(%ebp),%eax
  801545:	8a 00                	mov    (%eax),%al
  801547:	0f be c0             	movsbl %al,%eax
  80154a:	50                   	push   %eax
  80154b:	ff 75 0c             	pushl  0xc(%ebp)
  80154e:	e8 83 fa ff ff       	call   800fd6 <strchr>
  801553:	83 c4 08             	add    $0x8,%esp
  801556:	85 c0                	test   %eax,%eax
  801558:	75 d3                	jne    80152d <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80155a:	8b 45 08             	mov    0x8(%ebp),%eax
  80155d:	8a 00                	mov    (%eax),%al
  80155f:	84 c0                	test   %al,%al
  801561:	74 5a                	je     8015bd <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801563:	8b 45 14             	mov    0x14(%ebp),%eax
  801566:	8b 00                	mov    (%eax),%eax
  801568:	83 f8 0f             	cmp    $0xf,%eax
  80156b:	75 07                	jne    801574 <strsplit+0x6c>
		{
			return 0;
  80156d:	b8 00 00 00 00       	mov    $0x0,%eax
  801572:	eb 66                	jmp    8015da <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801574:	8b 45 14             	mov    0x14(%ebp),%eax
  801577:	8b 00                	mov    (%eax),%eax
  801579:	8d 48 01             	lea    0x1(%eax),%ecx
  80157c:	8b 55 14             	mov    0x14(%ebp),%edx
  80157f:	89 0a                	mov    %ecx,(%edx)
  801581:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801588:	8b 45 10             	mov    0x10(%ebp),%eax
  80158b:	01 c2                	add    %eax,%edx
  80158d:	8b 45 08             	mov    0x8(%ebp),%eax
  801590:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801592:	eb 03                	jmp    801597 <strsplit+0x8f>
			string++;
  801594:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801597:	8b 45 08             	mov    0x8(%ebp),%eax
  80159a:	8a 00                	mov    (%eax),%al
  80159c:	84 c0                	test   %al,%al
  80159e:	74 8b                	je     80152b <strsplit+0x23>
  8015a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a3:	8a 00                	mov    (%eax),%al
  8015a5:	0f be c0             	movsbl %al,%eax
  8015a8:	50                   	push   %eax
  8015a9:	ff 75 0c             	pushl  0xc(%ebp)
  8015ac:	e8 25 fa ff ff       	call   800fd6 <strchr>
  8015b1:	83 c4 08             	add    $0x8,%esp
  8015b4:	85 c0                	test   %eax,%eax
  8015b6:	74 dc                	je     801594 <strsplit+0x8c>
			string++;
	}
  8015b8:	e9 6e ff ff ff       	jmp    80152b <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8015bd:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8015be:	8b 45 14             	mov    0x14(%ebp),%eax
  8015c1:	8b 00                	mov    (%eax),%eax
  8015c3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8015cd:	01 d0                	add    %edx,%eax
  8015cf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8015d5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8015da:	c9                   	leave  
  8015db:	c3                   	ret    

008015dc <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8015dc:	55                   	push   %ebp
  8015dd:	89 e5                	mov    %esp,%ebp
  8015df:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8015e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8015e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015ef:	eb 4a                	jmp    80163b <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8015f1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f7:	01 c2                	add    %eax,%edx
  8015f9:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ff:	01 c8                	add    %ecx,%eax
  801601:	8a 00                	mov    (%eax),%al
  801603:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801605:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801608:	8b 45 0c             	mov    0xc(%ebp),%eax
  80160b:	01 d0                	add    %edx,%eax
  80160d:	8a 00                	mov    (%eax),%al
  80160f:	3c 40                	cmp    $0x40,%al
  801611:	7e 25                	jle    801638 <str2lower+0x5c>
  801613:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801616:	8b 45 0c             	mov    0xc(%ebp),%eax
  801619:	01 d0                	add    %edx,%eax
  80161b:	8a 00                	mov    (%eax),%al
  80161d:	3c 5a                	cmp    $0x5a,%al
  80161f:	7f 17                	jg     801638 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801621:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801624:	8b 45 08             	mov    0x8(%ebp),%eax
  801627:	01 d0                	add    %edx,%eax
  801629:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80162c:	8b 55 08             	mov    0x8(%ebp),%edx
  80162f:	01 ca                	add    %ecx,%edx
  801631:	8a 12                	mov    (%edx),%dl
  801633:	83 c2 20             	add    $0x20,%edx
  801636:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801638:	ff 45 fc             	incl   -0x4(%ebp)
  80163b:	ff 75 0c             	pushl  0xc(%ebp)
  80163e:	e8 01 f8 ff ff       	call   800e44 <strlen>
  801643:	83 c4 04             	add    $0x4,%esp
  801646:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801649:	7f a6                	jg     8015f1 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  80164b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80164e:	c9                   	leave  
  80164f:	c3                   	ret    

00801650 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801650:	55                   	push   %ebp
  801651:	89 e5                	mov    %esp,%ebp
  801653:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801656:	a1 08 30 80 00       	mov    0x803008,%eax
  80165b:	85 c0                	test   %eax,%eax
  80165d:	74 42                	je     8016a1 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  80165f:	83 ec 08             	sub    $0x8,%esp
  801662:	68 00 00 00 82       	push   $0x82000000
  801667:	68 00 00 00 80       	push   $0x80000000
  80166c:	e8 8c 07 00 00       	call   801dfd <initialize_dynamic_allocator>
  801671:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801674:	e8 e7 05 00 00       	call   801c60 <sys_get_uheap_strategy>
  801679:	a3 60 b0 81 00       	mov    %eax,0x81b060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  80167e:	a1 40 30 80 00       	mov    0x803040,%eax
  801683:	05 00 10 00 00       	add    $0x1000,%eax
  801688:	a3 10 b1 81 00       	mov    %eax,0x81b110
		uheapPageAllocBreak = uheapPageAllocStart;
  80168d:	a1 10 b1 81 00       	mov    0x81b110,%eax
  801692:	a3 68 b0 81 00       	mov    %eax,0x81b068

		__firstTimeFlag = 0;
  801697:	c7 05 08 30 80 00 00 	movl   $0x0,0x803008
  80169e:	00 00 00 
	}
}
  8016a1:	90                   	nop
  8016a2:	c9                   	leave  
  8016a3:	c3                   	ret    

008016a4 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  8016a4:	55                   	push   %ebp
  8016a5:	89 e5                	mov    %esp,%ebp
  8016a7:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  8016aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016b3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016b8:	83 ec 08             	sub    $0x8,%esp
  8016bb:	68 06 04 00 00       	push   $0x406
  8016c0:	50                   	push   %eax
  8016c1:	e8 e4 01 00 00       	call   8018aa <__sys_allocate_page>
  8016c6:	83 c4 10             	add    $0x10,%esp
  8016c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8016cc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8016d0:	79 14                	jns    8016e6 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  8016d2:	83 ec 04             	sub    $0x4,%esp
  8016d5:	68 c8 29 80 00       	push   $0x8029c8
  8016da:	6a 1f                	push   $0x1f
  8016dc:	68 04 2a 80 00       	push   $0x802a04
  8016e1:	e8 b7 ed ff ff       	call   80049d <_panic>
	return 0;
  8016e6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016eb:	c9                   	leave  
  8016ec:	c3                   	ret    

008016ed <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  8016ed:	55                   	push   %ebp
  8016ee:	89 e5                	mov    %esp,%ebp
  8016f0:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  8016f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016fc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801701:	83 ec 0c             	sub    $0xc,%esp
  801704:	50                   	push   %eax
  801705:	e8 e7 01 00 00       	call   8018f1 <__sys_unmap_frame>
  80170a:	83 c4 10             	add    $0x10,%esp
  80170d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801710:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801714:	79 14                	jns    80172a <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801716:	83 ec 04             	sub    $0x4,%esp
  801719:	68 10 2a 80 00       	push   $0x802a10
  80171e:	6a 2a                	push   $0x2a
  801720:	68 04 2a 80 00       	push   $0x802a04
  801725:	e8 73 ed ff ff       	call   80049d <_panic>
}
  80172a:	90                   	nop
  80172b:	c9                   	leave  
  80172c:	c3                   	ret    

0080172d <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  80172d:	55                   	push   %ebp
  80172e:	89 e5                	mov    %esp,%ebp
  801730:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801733:	e8 18 ff ff ff       	call   801650 <uheap_init>
	if (size == 0) return NULL ;
  801738:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80173c:	75 07                	jne    801745 <malloc+0x18>
  80173e:	b8 00 00 00 00       	mov    $0x0,%eax
  801743:	eb 14                	jmp    801759 <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  801745:	83 ec 04             	sub    $0x4,%esp
  801748:	68 50 2a 80 00       	push   $0x802a50
  80174d:	6a 3e                	push   $0x3e
  80174f:	68 04 2a 80 00       	push   $0x802a04
  801754:	e8 44 ed ff ff       	call   80049d <_panic>
}
  801759:	c9                   	leave  
  80175a:	c3                   	ret    

0080175b <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  80175b:	55                   	push   %ebp
  80175c:	89 e5                	mov    %esp,%ebp
  80175e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  801761:	83 ec 04             	sub    $0x4,%esp
  801764:	68 78 2a 80 00       	push   $0x802a78
  801769:	6a 49                	push   $0x49
  80176b:	68 04 2a 80 00       	push   $0x802a04
  801770:	e8 28 ed ff ff       	call   80049d <_panic>

00801775 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801775:	55                   	push   %ebp
  801776:	89 e5                	mov    %esp,%ebp
  801778:	83 ec 18             	sub    $0x18,%esp
  80177b:	8b 45 10             	mov    0x10(%ebp),%eax
  80177e:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801781:	e8 ca fe ff ff       	call   801650 <uheap_init>
	if (size == 0) return NULL ;
  801786:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80178a:	75 07                	jne    801793 <smalloc+0x1e>
  80178c:	b8 00 00 00 00       	mov    $0x0,%eax
  801791:	eb 14                	jmp    8017a7 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  801793:	83 ec 04             	sub    $0x4,%esp
  801796:	68 9c 2a 80 00       	push   $0x802a9c
  80179b:	6a 5a                	push   $0x5a
  80179d:	68 04 2a 80 00       	push   $0x802a04
  8017a2:	e8 f6 ec ff ff       	call   80049d <_panic>
}
  8017a7:	c9                   	leave  
  8017a8:	c3                   	ret    

008017a9 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8017a9:	55                   	push   %ebp
  8017aa:	89 e5                	mov    %esp,%ebp
  8017ac:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8017af:	e8 9c fe ff ff       	call   801650 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  8017b4:	83 ec 04             	sub    $0x4,%esp
  8017b7:	68 c4 2a 80 00       	push   $0x802ac4
  8017bc:	6a 6a                	push   $0x6a
  8017be:	68 04 2a 80 00       	push   $0x802a04
  8017c3:	e8 d5 ec ff ff       	call   80049d <_panic>

008017c8 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8017c8:	55                   	push   %ebp
  8017c9:	89 e5                	mov    %esp,%ebp
  8017cb:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8017ce:	e8 7d fe ff ff       	call   801650 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  8017d3:	83 ec 04             	sub    $0x4,%esp
  8017d6:	68 e8 2a 80 00       	push   $0x802ae8
  8017db:	68 88 00 00 00       	push   $0x88
  8017e0:	68 04 2a 80 00       	push   $0x802a04
  8017e5:	e8 b3 ec ff ff       	call   80049d <_panic>

008017ea <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  8017ea:	55                   	push   %ebp
  8017eb:	89 e5                	mov    %esp,%ebp
  8017ed:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  8017f0:	83 ec 04             	sub    $0x4,%esp
  8017f3:	68 10 2b 80 00       	push   $0x802b10
  8017f8:	68 9b 00 00 00       	push   $0x9b
  8017fd:	68 04 2a 80 00       	push   $0x802a04
  801802:	e8 96 ec ff ff       	call   80049d <_panic>

00801807 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801807:	55                   	push   %ebp
  801808:	89 e5                	mov    %esp,%ebp
  80180a:	57                   	push   %edi
  80180b:	56                   	push   %esi
  80180c:	53                   	push   %ebx
  80180d:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801810:	8b 45 08             	mov    0x8(%ebp),%eax
  801813:	8b 55 0c             	mov    0xc(%ebp),%edx
  801816:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801819:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80181c:	8b 7d 18             	mov    0x18(%ebp),%edi
  80181f:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801822:	cd 30                	int    $0x30
  801824:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801827:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80182a:	83 c4 10             	add    $0x10,%esp
  80182d:	5b                   	pop    %ebx
  80182e:	5e                   	pop    %esi
  80182f:	5f                   	pop    %edi
  801830:	5d                   	pop    %ebp
  801831:	c3                   	ret    

00801832 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801832:	55                   	push   %ebp
  801833:	89 e5                	mov    %esp,%ebp
  801835:	83 ec 04             	sub    $0x4,%esp
  801838:	8b 45 10             	mov    0x10(%ebp),%eax
  80183b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  80183e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801841:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801845:	8b 45 08             	mov    0x8(%ebp),%eax
  801848:	6a 00                	push   $0x0
  80184a:	51                   	push   %ecx
  80184b:	52                   	push   %edx
  80184c:	ff 75 0c             	pushl  0xc(%ebp)
  80184f:	50                   	push   %eax
  801850:	6a 00                	push   $0x0
  801852:	e8 b0 ff ff ff       	call   801807 <syscall>
  801857:	83 c4 18             	add    $0x18,%esp
}
  80185a:	90                   	nop
  80185b:	c9                   	leave  
  80185c:	c3                   	ret    

0080185d <sys_cgetc>:

int
sys_cgetc(void)
{
  80185d:	55                   	push   %ebp
  80185e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801860:	6a 00                	push   $0x0
  801862:	6a 00                	push   $0x0
  801864:	6a 00                	push   $0x0
  801866:	6a 00                	push   $0x0
  801868:	6a 00                	push   $0x0
  80186a:	6a 02                	push   $0x2
  80186c:	e8 96 ff ff ff       	call   801807 <syscall>
  801871:	83 c4 18             	add    $0x18,%esp
}
  801874:	c9                   	leave  
  801875:	c3                   	ret    

00801876 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801876:	55                   	push   %ebp
  801877:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801879:	6a 00                	push   $0x0
  80187b:	6a 00                	push   $0x0
  80187d:	6a 00                	push   $0x0
  80187f:	6a 00                	push   $0x0
  801881:	6a 00                	push   $0x0
  801883:	6a 03                	push   $0x3
  801885:	e8 7d ff ff ff       	call   801807 <syscall>
  80188a:	83 c4 18             	add    $0x18,%esp
}
  80188d:	90                   	nop
  80188e:	c9                   	leave  
  80188f:	c3                   	ret    

00801890 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801890:	55                   	push   %ebp
  801891:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801893:	6a 00                	push   $0x0
  801895:	6a 00                	push   $0x0
  801897:	6a 00                	push   $0x0
  801899:	6a 00                	push   $0x0
  80189b:	6a 00                	push   $0x0
  80189d:	6a 04                	push   $0x4
  80189f:	e8 63 ff ff ff       	call   801807 <syscall>
  8018a4:	83 c4 18             	add    $0x18,%esp
}
  8018a7:	90                   	nop
  8018a8:	c9                   	leave  
  8018a9:	c3                   	ret    

008018aa <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8018aa:	55                   	push   %ebp
  8018ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8018ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b3:	6a 00                	push   $0x0
  8018b5:	6a 00                	push   $0x0
  8018b7:	6a 00                	push   $0x0
  8018b9:	52                   	push   %edx
  8018ba:	50                   	push   %eax
  8018bb:	6a 08                	push   $0x8
  8018bd:	e8 45 ff ff ff       	call   801807 <syscall>
  8018c2:	83 c4 18             	add    $0x18,%esp
}
  8018c5:	c9                   	leave  
  8018c6:	c3                   	ret    

008018c7 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018c7:	55                   	push   %ebp
  8018c8:	89 e5                	mov    %esp,%ebp
  8018ca:	56                   	push   %esi
  8018cb:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018cc:	8b 75 18             	mov    0x18(%ebp),%esi
  8018cf:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018d2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018db:	56                   	push   %esi
  8018dc:	53                   	push   %ebx
  8018dd:	51                   	push   %ecx
  8018de:	52                   	push   %edx
  8018df:	50                   	push   %eax
  8018e0:	6a 09                	push   $0x9
  8018e2:	e8 20 ff ff ff       	call   801807 <syscall>
  8018e7:	83 c4 18             	add    $0x18,%esp
}
  8018ea:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018ed:	5b                   	pop    %ebx
  8018ee:	5e                   	pop    %esi
  8018ef:	5d                   	pop    %ebp
  8018f0:	c3                   	ret    

008018f1 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8018f1:	55                   	push   %ebp
  8018f2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8018f4:	6a 00                	push   $0x0
  8018f6:	6a 00                	push   $0x0
  8018f8:	6a 00                	push   $0x0
  8018fa:	6a 00                	push   $0x0
  8018fc:	ff 75 08             	pushl  0x8(%ebp)
  8018ff:	6a 0a                	push   $0xa
  801901:	e8 01 ff ff ff       	call   801807 <syscall>
  801906:	83 c4 18             	add    $0x18,%esp
}
  801909:	c9                   	leave  
  80190a:	c3                   	ret    

0080190b <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80190b:	55                   	push   %ebp
  80190c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80190e:	6a 00                	push   $0x0
  801910:	6a 00                	push   $0x0
  801912:	6a 00                	push   $0x0
  801914:	ff 75 0c             	pushl  0xc(%ebp)
  801917:	ff 75 08             	pushl  0x8(%ebp)
  80191a:	6a 0b                	push   $0xb
  80191c:	e8 e6 fe ff ff       	call   801807 <syscall>
  801921:	83 c4 18             	add    $0x18,%esp
}
  801924:	c9                   	leave  
  801925:	c3                   	ret    

00801926 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801926:	55                   	push   %ebp
  801927:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801929:	6a 00                	push   $0x0
  80192b:	6a 00                	push   $0x0
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	6a 00                	push   $0x0
  801933:	6a 0c                	push   $0xc
  801935:	e8 cd fe ff ff       	call   801807 <syscall>
  80193a:	83 c4 18             	add    $0x18,%esp
}
  80193d:	c9                   	leave  
  80193e:	c3                   	ret    

0080193f <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80193f:	55                   	push   %ebp
  801940:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801942:	6a 00                	push   $0x0
  801944:	6a 00                	push   $0x0
  801946:	6a 00                	push   $0x0
  801948:	6a 00                	push   $0x0
  80194a:	6a 00                	push   $0x0
  80194c:	6a 0d                	push   $0xd
  80194e:	e8 b4 fe ff ff       	call   801807 <syscall>
  801953:	83 c4 18             	add    $0x18,%esp
}
  801956:	c9                   	leave  
  801957:	c3                   	ret    

00801958 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801958:	55                   	push   %ebp
  801959:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80195b:	6a 00                	push   $0x0
  80195d:	6a 00                	push   $0x0
  80195f:	6a 00                	push   $0x0
  801961:	6a 00                	push   $0x0
  801963:	6a 00                	push   $0x0
  801965:	6a 0e                	push   $0xe
  801967:	e8 9b fe ff ff       	call   801807 <syscall>
  80196c:	83 c4 18             	add    $0x18,%esp
}
  80196f:	c9                   	leave  
  801970:	c3                   	ret    

00801971 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801971:	55                   	push   %ebp
  801972:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801974:	6a 00                	push   $0x0
  801976:	6a 00                	push   $0x0
  801978:	6a 00                	push   $0x0
  80197a:	6a 00                	push   $0x0
  80197c:	6a 00                	push   $0x0
  80197e:	6a 0f                	push   $0xf
  801980:	e8 82 fe ff ff       	call   801807 <syscall>
  801985:	83 c4 18             	add    $0x18,%esp
}
  801988:	c9                   	leave  
  801989:	c3                   	ret    

0080198a <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80198a:	55                   	push   %ebp
  80198b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80198d:	6a 00                	push   $0x0
  80198f:	6a 00                	push   $0x0
  801991:	6a 00                	push   $0x0
  801993:	6a 00                	push   $0x0
  801995:	ff 75 08             	pushl  0x8(%ebp)
  801998:	6a 10                	push   $0x10
  80199a:	e8 68 fe ff ff       	call   801807 <syscall>
  80199f:	83 c4 18             	add    $0x18,%esp
}
  8019a2:	c9                   	leave  
  8019a3:	c3                   	ret    

008019a4 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019a4:	55                   	push   %ebp
  8019a5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 00                	push   $0x0
  8019ab:	6a 00                	push   $0x0
  8019ad:	6a 00                	push   $0x0
  8019af:	6a 00                	push   $0x0
  8019b1:	6a 11                	push   $0x11
  8019b3:	e8 4f fe ff ff       	call   801807 <syscall>
  8019b8:	83 c4 18             	add    $0x18,%esp
}
  8019bb:	90                   	nop
  8019bc:	c9                   	leave  
  8019bd:	c3                   	ret    

008019be <sys_cputc>:

void
sys_cputc(const char c)
{
  8019be:	55                   	push   %ebp
  8019bf:	89 e5                	mov    %esp,%ebp
  8019c1:	83 ec 04             	sub    $0x4,%esp
  8019c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8019ca:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 00                	push   $0x0
  8019d2:	6a 00                	push   $0x0
  8019d4:	6a 00                	push   $0x0
  8019d6:	50                   	push   %eax
  8019d7:	6a 01                	push   $0x1
  8019d9:	e8 29 fe ff ff       	call   801807 <syscall>
  8019de:	83 c4 18             	add    $0x18,%esp
}
  8019e1:	90                   	nop
  8019e2:	c9                   	leave  
  8019e3:	c3                   	ret    

008019e4 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8019e4:	55                   	push   %ebp
  8019e5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 14                	push   $0x14
  8019f3:	e8 0f fe ff ff       	call   801807 <syscall>
  8019f8:	83 c4 18             	add    $0x18,%esp
}
  8019fb:	90                   	nop
  8019fc:	c9                   	leave  
  8019fd:	c3                   	ret    

008019fe <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8019fe:	55                   	push   %ebp
  8019ff:	89 e5                	mov    %esp,%ebp
  801a01:	83 ec 04             	sub    $0x4,%esp
  801a04:	8b 45 10             	mov    0x10(%ebp),%eax
  801a07:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a0a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a0d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a11:	8b 45 08             	mov    0x8(%ebp),%eax
  801a14:	6a 00                	push   $0x0
  801a16:	51                   	push   %ecx
  801a17:	52                   	push   %edx
  801a18:	ff 75 0c             	pushl  0xc(%ebp)
  801a1b:	50                   	push   %eax
  801a1c:	6a 15                	push   $0x15
  801a1e:	e8 e4 fd ff ff       	call   801807 <syscall>
  801a23:	83 c4 18             	add    $0x18,%esp
}
  801a26:	c9                   	leave  
  801a27:	c3                   	ret    

00801a28 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801a28:	55                   	push   %ebp
  801a29:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	6a 00                	push   $0x0
  801a37:	52                   	push   %edx
  801a38:	50                   	push   %eax
  801a39:	6a 16                	push   $0x16
  801a3b:	e8 c7 fd ff ff       	call   801807 <syscall>
  801a40:	83 c4 18             	add    $0x18,%esp
}
  801a43:	c9                   	leave  
  801a44:	c3                   	ret    

00801a45 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801a45:	55                   	push   %ebp
  801a46:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a48:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a4b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a51:	6a 00                	push   $0x0
  801a53:	6a 00                	push   $0x0
  801a55:	51                   	push   %ecx
  801a56:	52                   	push   %edx
  801a57:	50                   	push   %eax
  801a58:	6a 17                	push   $0x17
  801a5a:	e8 a8 fd ff ff       	call   801807 <syscall>
  801a5f:	83 c4 18             	add    $0x18,%esp
}
  801a62:	c9                   	leave  
  801a63:	c3                   	ret    

00801a64 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801a64:	55                   	push   %ebp
  801a65:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a67:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6d:	6a 00                	push   $0x0
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 00                	push   $0x0
  801a73:	52                   	push   %edx
  801a74:	50                   	push   %eax
  801a75:	6a 18                	push   $0x18
  801a77:	e8 8b fd ff ff       	call   801807 <syscall>
  801a7c:	83 c4 18             	add    $0x18,%esp
}
  801a7f:	c9                   	leave  
  801a80:	c3                   	ret    

00801a81 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a81:	55                   	push   %ebp
  801a82:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a84:	8b 45 08             	mov    0x8(%ebp),%eax
  801a87:	6a 00                	push   $0x0
  801a89:	ff 75 14             	pushl  0x14(%ebp)
  801a8c:	ff 75 10             	pushl  0x10(%ebp)
  801a8f:	ff 75 0c             	pushl  0xc(%ebp)
  801a92:	50                   	push   %eax
  801a93:	6a 19                	push   $0x19
  801a95:	e8 6d fd ff ff       	call   801807 <syscall>
  801a9a:	83 c4 18             	add    $0x18,%esp
}
  801a9d:	c9                   	leave  
  801a9e:	c3                   	ret    

00801a9f <sys_run_env>:

void sys_run_env(int32 envId)
{
  801a9f:	55                   	push   %ebp
  801aa0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa5:	6a 00                	push   $0x0
  801aa7:	6a 00                	push   $0x0
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 00                	push   $0x0
  801aad:	50                   	push   %eax
  801aae:	6a 1a                	push   $0x1a
  801ab0:	e8 52 fd ff ff       	call   801807 <syscall>
  801ab5:	83 c4 18             	add    $0x18,%esp
}
  801ab8:	90                   	nop
  801ab9:	c9                   	leave  
  801aba:	c3                   	ret    

00801abb <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801abb:	55                   	push   %ebp
  801abc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801abe:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac1:	6a 00                	push   $0x0
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	50                   	push   %eax
  801aca:	6a 1b                	push   $0x1b
  801acc:	e8 36 fd ff ff       	call   801807 <syscall>
  801ad1:	83 c4 18             	add    $0x18,%esp
}
  801ad4:	c9                   	leave  
  801ad5:	c3                   	ret    

00801ad6 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ad6:	55                   	push   %ebp
  801ad7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ad9:	6a 00                	push   $0x0
  801adb:	6a 00                	push   $0x0
  801add:	6a 00                	push   $0x0
  801adf:	6a 00                	push   $0x0
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 05                	push   $0x5
  801ae5:	e8 1d fd ff ff       	call   801807 <syscall>
  801aea:	83 c4 18             	add    $0x18,%esp
}
  801aed:	c9                   	leave  
  801aee:	c3                   	ret    

00801aef <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801aef:	55                   	push   %ebp
  801af0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	6a 00                	push   $0x0
  801afa:	6a 00                	push   $0x0
  801afc:	6a 06                	push   $0x6
  801afe:	e8 04 fd ff ff       	call   801807 <syscall>
  801b03:	83 c4 18             	add    $0x18,%esp
}
  801b06:	c9                   	leave  
  801b07:	c3                   	ret    

00801b08 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b08:	55                   	push   %ebp
  801b09:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 00                	push   $0x0
  801b13:	6a 00                	push   $0x0
  801b15:	6a 07                	push   $0x7
  801b17:	e8 eb fc ff ff       	call   801807 <syscall>
  801b1c:	83 c4 18             	add    $0x18,%esp
}
  801b1f:	c9                   	leave  
  801b20:	c3                   	ret    

00801b21 <sys_exit_env>:


void sys_exit_env(void)
{
  801b21:	55                   	push   %ebp
  801b22:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b24:	6a 00                	push   $0x0
  801b26:	6a 00                	push   $0x0
  801b28:	6a 00                	push   $0x0
  801b2a:	6a 00                	push   $0x0
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 1c                	push   $0x1c
  801b30:	e8 d2 fc ff ff       	call   801807 <syscall>
  801b35:	83 c4 18             	add    $0x18,%esp
}
  801b38:	90                   	nop
  801b39:	c9                   	leave  
  801b3a:	c3                   	ret    

00801b3b <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801b3b:	55                   	push   %ebp
  801b3c:	89 e5                	mov    %esp,%ebp
  801b3e:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b41:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b44:	8d 50 04             	lea    0x4(%eax),%edx
  801b47:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b4a:	6a 00                	push   $0x0
  801b4c:	6a 00                	push   $0x0
  801b4e:	6a 00                	push   $0x0
  801b50:	52                   	push   %edx
  801b51:	50                   	push   %eax
  801b52:	6a 1d                	push   $0x1d
  801b54:	e8 ae fc ff ff       	call   801807 <syscall>
  801b59:	83 c4 18             	add    $0x18,%esp
	return result;
  801b5c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b5f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b62:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b65:	89 01                	mov    %eax,(%ecx)
  801b67:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6d:	c9                   	leave  
  801b6e:	c2 04 00             	ret    $0x4

00801b71 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b71:	55                   	push   %ebp
  801b72:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b74:	6a 00                	push   $0x0
  801b76:	6a 00                	push   $0x0
  801b78:	ff 75 10             	pushl  0x10(%ebp)
  801b7b:	ff 75 0c             	pushl  0xc(%ebp)
  801b7e:	ff 75 08             	pushl  0x8(%ebp)
  801b81:	6a 13                	push   $0x13
  801b83:	e8 7f fc ff ff       	call   801807 <syscall>
  801b88:	83 c4 18             	add    $0x18,%esp
	return ;
  801b8b:	90                   	nop
}
  801b8c:	c9                   	leave  
  801b8d:	c3                   	ret    

00801b8e <sys_rcr2>:
uint32 sys_rcr2()
{
  801b8e:	55                   	push   %ebp
  801b8f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b91:	6a 00                	push   $0x0
  801b93:	6a 00                	push   $0x0
  801b95:	6a 00                	push   $0x0
  801b97:	6a 00                	push   $0x0
  801b99:	6a 00                	push   $0x0
  801b9b:	6a 1e                	push   $0x1e
  801b9d:	e8 65 fc ff ff       	call   801807 <syscall>
  801ba2:	83 c4 18             	add    $0x18,%esp
}
  801ba5:	c9                   	leave  
  801ba6:	c3                   	ret    

00801ba7 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801ba7:	55                   	push   %ebp
  801ba8:	89 e5                	mov    %esp,%ebp
  801baa:	83 ec 04             	sub    $0x4,%esp
  801bad:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801bb3:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801bb7:	6a 00                	push   $0x0
  801bb9:	6a 00                	push   $0x0
  801bbb:	6a 00                	push   $0x0
  801bbd:	6a 00                	push   $0x0
  801bbf:	50                   	push   %eax
  801bc0:	6a 1f                	push   $0x1f
  801bc2:	e8 40 fc ff ff       	call   801807 <syscall>
  801bc7:	83 c4 18             	add    $0x18,%esp
	return ;
  801bca:	90                   	nop
}
  801bcb:	c9                   	leave  
  801bcc:	c3                   	ret    

00801bcd <rsttst>:
void rsttst()
{
  801bcd:	55                   	push   %ebp
  801bce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 21                	push   $0x21
  801bdc:	e8 26 fc ff ff       	call   801807 <syscall>
  801be1:	83 c4 18             	add    $0x18,%esp
	return ;
  801be4:	90                   	nop
}
  801be5:	c9                   	leave  
  801be6:	c3                   	ret    

00801be7 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801be7:	55                   	push   %ebp
  801be8:	89 e5                	mov    %esp,%ebp
  801bea:	83 ec 04             	sub    $0x4,%esp
  801bed:	8b 45 14             	mov    0x14(%ebp),%eax
  801bf0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801bf3:	8b 55 18             	mov    0x18(%ebp),%edx
  801bf6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801bfa:	52                   	push   %edx
  801bfb:	50                   	push   %eax
  801bfc:	ff 75 10             	pushl  0x10(%ebp)
  801bff:	ff 75 0c             	pushl  0xc(%ebp)
  801c02:	ff 75 08             	pushl  0x8(%ebp)
  801c05:	6a 20                	push   $0x20
  801c07:	e8 fb fb ff ff       	call   801807 <syscall>
  801c0c:	83 c4 18             	add    $0x18,%esp
	return ;
  801c0f:	90                   	nop
}
  801c10:	c9                   	leave  
  801c11:	c3                   	ret    

00801c12 <chktst>:
void chktst(uint32 n)
{
  801c12:	55                   	push   %ebp
  801c13:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c15:	6a 00                	push   $0x0
  801c17:	6a 00                	push   $0x0
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 00                	push   $0x0
  801c1d:	ff 75 08             	pushl  0x8(%ebp)
  801c20:	6a 22                	push   $0x22
  801c22:	e8 e0 fb ff ff       	call   801807 <syscall>
  801c27:	83 c4 18             	add    $0x18,%esp
	return ;
  801c2a:	90                   	nop
}
  801c2b:	c9                   	leave  
  801c2c:	c3                   	ret    

00801c2d <inctst>:

void inctst()
{
  801c2d:	55                   	push   %ebp
  801c2e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c30:	6a 00                	push   $0x0
  801c32:	6a 00                	push   $0x0
  801c34:	6a 00                	push   $0x0
  801c36:	6a 00                	push   $0x0
  801c38:	6a 00                	push   $0x0
  801c3a:	6a 23                	push   $0x23
  801c3c:	e8 c6 fb ff ff       	call   801807 <syscall>
  801c41:	83 c4 18             	add    $0x18,%esp
	return ;
  801c44:	90                   	nop
}
  801c45:	c9                   	leave  
  801c46:	c3                   	ret    

00801c47 <gettst>:
uint32 gettst()
{
  801c47:	55                   	push   %ebp
  801c48:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 00                	push   $0x0
  801c52:	6a 00                	push   $0x0
  801c54:	6a 24                	push   $0x24
  801c56:	e8 ac fb ff ff       	call   801807 <syscall>
  801c5b:	83 c4 18             	add    $0x18,%esp
}
  801c5e:	c9                   	leave  
  801c5f:	c3                   	ret    

00801c60 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801c60:	55                   	push   %ebp
  801c61:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c63:	6a 00                	push   $0x0
  801c65:	6a 00                	push   $0x0
  801c67:	6a 00                	push   $0x0
  801c69:	6a 00                	push   $0x0
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 25                	push   $0x25
  801c6f:	e8 93 fb ff ff       	call   801807 <syscall>
  801c74:	83 c4 18             	add    $0x18,%esp
  801c77:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801c7c:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801c81:	c9                   	leave  
  801c82:	c3                   	ret    

00801c83 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c83:	55                   	push   %ebp
  801c84:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801c86:	8b 45 08             	mov    0x8(%ebp),%eax
  801c89:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 00                	push   $0x0
  801c92:	6a 00                	push   $0x0
  801c94:	6a 00                	push   $0x0
  801c96:	ff 75 08             	pushl  0x8(%ebp)
  801c99:	6a 26                	push   $0x26
  801c9b:	e8 67 fb ff ff       	call   801807 <syscall>
  801ca0:	83 c4 18             	add    $0x18,%esp
	return ;
  801ca3:	90                   	nop
}
  801ca4:	c9                   	leave  
  801ca5:	c3                   	ret    

00801ca6 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ca6:	55                   	push   %ebp
  801ca7:	89 e5                	mov    %esp,%ebp
  801ca9:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801caa:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cad:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cb0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb6:	6a 00                	push   $0x0
  801cb8:	53                   	push   %ebx
  801cb9:	51                   	push   %ecx
  801cba:	52                   	push   %edx
  801cbb:	50                   	push   %eax
  801cbc:	6a 27                	push   $0x27
  801cbe:	e8 44 fb ff ff       	call   801807 <syscall>
  801cc3:	83 c4 18             	add    $0x18,%esp
}
  801cc6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cc9:	c9                   	leave  
  801cca:	c3                   	ret    

00801ccb <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ccb:	55                   	push   %ebp
  801ccc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801cce:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 00                	push   $0x0
  801cda:	52                   	push   %edx
  801cdb:	50                   	push   %eax
  801cdc:	6a 28                	push   $0x28
  801cde:	e8 24 fb ff ff       	call   801807 <syscall>
  801ce3:	83 c4 18             	add    $0x18,%esp
}
  801ce6:	c9                   	leave  
  801ce7:	c3                   	ret    

00801ce8 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801ce8:	55                   	push   %ebp
  801ce9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801ceb:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801cee:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cf1:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf4:	6a 00                	push   $0x0
  801cf6:	51                   	push   %ecx
  801cf7:	ff 75 10             	pushl  0x10(%ebp)
  801cfa:	52                   	push   %edx
  801cfb:	50                   	push   %eax
  801cfc:	6a 29                	push   $0x29
  801cfe:	e8 04 fb ff ff       	call   801807 <syscall>
  801d03:	83 c4 18             	add    $0x18,%esp
}
  801d06:	c9                   	leave  
  801d07:	c3                   	ret    

00801d08 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801d08:	55                   	push   %ebp
  801d09:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801d0b:	6a 00                	push   $0x0
  801d0d:	6a 00                	push   $0x0
  801d0f:	ff 75 10             	pushl  0x10(%ebp)
  801d12:	ff 75 0c             	pushl  0xc(%ebp)
  801d15:	ff 75 08             	pushl  0x8(%ebp)
  801d18:	6a 12                	push   $0x12
  801d1a:	e8 e8 fa ff ff       	call   801807 <syscall>
  801d1f:	83 c4 18             	add    $0x18,%esp
	return ;
  801d22:	90                   	nop
}
  801d23:	c9                   	leave  
  801d24:	c3                   	ret    

00801d25 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801d25:	55                   	push   %ebp
  801d26:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801d28:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2e:	6a 00                	push   $0x0
  801d30:	6a 00                	push   $0x0
  801d32:	6a 00                	push   $0x0
  801d34:	52                   	push   %edx
  801d35:	50                   	push   %eax
  801d36:	6a 2a                	push   $0x2a
  801d38:	e8 ca fa ff ff       	call   801807 <syscall>
  801d3d:	83 c4 18             	add    $0x18,%esp
	return;
  801d40:	90                   	nop
}
  801d41:	c9                   	leave  
  801d42:	c3                   	ret    

00801d43 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801d43:	55                   	push   %ebp
  801d44:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801d46:	6a 00                	push   $0x0
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 00                	push   $0x0
  801d4e:	6a 00                	push   $0x0
  801d50:	6a 2b                	push   $0x2b
  801d52:	e8 b0 fa ff ff       	call   801807 <syscall>
  801d57:	83 c4 18             	add    $0x18,%esp
}
  801d5a:	c9                   	leave  
  801d5b:	c3                   	ret    

00801d5c <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801d5c:	55                   	push   %ebp
  801d5d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801d5f:	6a 00                	push   $0x0
  801d61:	6a 00                	push   $0x0
  801d63:	6a 00                	push   $0x0
  801d65:	ff 75 0c             	pushl  0xc(%ebp)
  801d68:	ff 75 08             	pushl  0x8(%ebp)
  801d6b:	6a 2d                	push   $0x2d
  801d6d:	e8 95 fa ff ff       	call   801807 <syscall>
  801d72:	83 c4 18             	add    $0x18,%esp
	return;
  801d75:	90                   	nop
}
  801d76:	c9                   	leave  
  801d77:	c3                   	ret    

00801d78 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801d78:	55                   	push   %ebp
  801d79:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801d7b:	6a 00                	push   $0x0
  801d7d:	6a 00                	push   $0x0
  801d7f:	6a 00                	push   $0x0
  801d81:	ff 75 0c             	pushl  0xc(%ebp)
  801d84:	ff 75 08             	pushl  0x8(%ebp)
  801d87:	6a 2c                	push   $0x2c
  801d89:	e8 79 fa ff ff       	call   801807 <syscall>
  801d8e:	83 c4 18             	add    $0x18,%esp
	return ;
  801d91:	90                   	nop
}
  801d92:	c9                   	leave  
  801d93:	c3                   	ret    

00801d94 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801d94:	55                   	push   %ebp
  801d95:	89 e5                	mov    %esp,%ebp
  801d97:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801d9a:	83 ec 04             	sub    $0x4,%esp
  801d9d:	68 34 2b 80 00       	push   $0x802b34
  801da2:	68 25 01 00 00       	push   $0x125
  801da7:	68 67 2b 80 00       	push   $0x802b67
  801dac:	e8 ec e6 ff ff       	call   80049d <_panic>

00801db1 <to_page_va>:
//==================================================================================//
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  801db1:	55                   	push   %ebp
  801db2:	89 e5                	mov    %esp,%ebp
  801db4:	83 ec 10             	sub    $0x10,%esp
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  801db7:	8b 45 08             	mov    0x8(%ebp),%eax
  801dba:	ba 60 30 80 00       	mov    $0x803060,%edx
  801dbf:	29 d0                	sub    %edx,%eax
  801dc1:	c1 f8 02             	sar    $0x2,%eax
  801dc4:	89 c2                	mov    %eax,%edx
  801dc6:	89 d0                	mov    %edx,%eax
  801dc8:	c1 e0 02             	shl    $0x2,%eax
  801dcb:	01 d0                	add    %edx,%eax
  801dcd:	c1 e0 02             	shl    $0x2,%eax
  801dd0:	01 d0                	add    %edx,%eax
  801dd2:	c1 e0 02             	shl    $0x2,%eax
  801dd5:	01 d0                	add    %edx,%eax
  801dd7:	89 c1                	mov    %eax,%ecx
  801dd9:	c1 e1 08             	shl    $0x8,%ecx
  801ddc:	01 c8                	add    %ecx,%eax
  801dde:	89 c1                	mov    %eax,%ecx
  801de0:	c1 e1 10             	shl    $0x10,%ecx
  801de3:	01 c8                	add    %ecx,%eax
  801de5:	01 c0                	add    %eax,%eax
  801de7:	01 d0                	add    %edx,%eax
  801de9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  801dec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801def:	c1 e0 0c             	shl    $0xc,%eax
  801df2:	89 c2                	mov    %eax,%edx
  801df4:	a1 64 b0 81 00       	mov    0x81b064,%eax
  801df9:	01 d0                	add    %edx,%eax
}
  801dfb:	c9                   	leave  
  801dfc:	c3                   	ret    

00801dfd <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  801dfd:	55                   	push   %ebp
  801dfe:	89 e5                	mov    %esp,%ebp
  801e00:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  801e03:	8b 45 08             	mov    0x8(%ebp),%eax
  801e06:	05 00 00 00 02       	add    $0x2000000,%eax
  801e0b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801e0e:	73 16                	jae    801e26 <initialize_dynamic_allocator+0x29>
  801e10:	68 78 2b 80 00       	push   $0x802b78
  801e15:	68 9e 2b 80 00       	push   $0x802b9e
  801e1a:	6a 26                	push   $0x26
  801e1c:	68 b3 2b 80 00       	push   $0x802bb3
  801e21:	e8 77 e6 ff ff       	call   80049d <_panic>
		is_initialized = 1;
  801e26:	c7 05 24 30 80 00 01 	movl   $0x1,0x803024
  801e2d:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	//Comment the following line
	panic("initialize_dynamic_allocator() Not implemented yet");
  801e30:	83 ec 04             	sub    $0x4,%esp
  801e33:	68 cc 2b 80 00       	push   $0x802bcc
  801e38:	6a 2e                	push   $0x2e
  801e3a:	68 b3 2b 80 00       	push   $0x802bb3
  801e3f:	e8 59 e6 ff ff       	call   80049d <_panic>

00801e44 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  801e44:	55                   	push   %ebp
  801e45:	89 e5                	mov    %esp,%ebp
  801e47:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	//Comment the following line
	panic("get_block_size() Not implemented yet");
  801e4a:	83 ec 04             	sub    $0x4,%esp
  801e4d:	68 00 2c 80 00       	push   $0x802c00
  801e52:	6a 3a                	push   $0x3a
  801e54:	68 b3 2b 80 00       	push   $0x802bb3
  801e59:	e8 3f e6 ff ff       	call   80049d <_panic>

00801e5e <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  801e5e:	55                   	push   %ebp
  801e5f:	89 e5                	mov    %esp,%ebp
  801e61:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  801e64:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801e6b:	76 16                	jbe    801e83 <alloc_block+0x25>
  801e6d:	68 28 2c 80 00       	push   $0x802c28
  801e72:	68 9e 2b 80 00       	push   $0x802b9e
  801e77:	6a 46                	push   $0x46
  801e79:	68 b3 2b 80 00       	push   $0x802bb3
  801e7e:	e8 1a e6 ff ff       	call   80049d <_panic>
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	panic("alloc_block() Not implemented yet");
  801e83:	83 ec 04             	sub    $0x4,%esp
  801e86:	68 4c 2c 80 00       	push   $0x802c4c
  801e8b:	6a 4d                	push   $0x4d
  801e8d:	68 b3 2b 80 00       	push   $0x802bb3
  801e92:	e8 06 e6 ff ff       	call   80049d <_panic>

00801e97 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  801e97:	55                   	push   %ebp
  801e98:	89 e5                	mov    %esp,%ebp
  801e9a:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  801e9d:	8b 55 08             	mov    0x8(%ebp),%edx
  801ea0:	a1 64 b0 81 00       	mov    0x81b064,%eax
  801ea5:	39 c2                	cmp    %eax,%edx
  801ea7:	72 0c                	jb     801eb5 <free_block+0x1e>
  801ea9:	8b 55 08             	mov    0x8(%ebp),%edx
  801eac:	a1 40 30 80 00       	mov    0x803040,%eax
  801eb1:	39 c2                	cmp    %eax,%edx
  801eb3:	72 16                	jb     801ecb <free_block+0x34>
  801eb5:	68 70 2c 80 00       	push   $0x802c70
  801eba:	68 9e 2b 80 00       	push   $0x802b9e
  801ebf:	6a 5b                	push   $0x5b
  801ec1:	68 b3 2b 80 00       	push   $0x802bb3
  801ec6:	e8 d2 e5 ff ff       	call   80049d <_panic>
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	panic("free_block() Not implemented yet");
  801ecb:	83 ec 04             	sub    $0x4,%esp
  801ece:	68 a8 2c 80 00       	push   $0x802ca8
  801ed3:	6a 63                	push   $0x63
  801ed5:	68 b3 2b 80 00       	push   $0x802bb3
  801eda:	e8 be e5 ff ff       	call   80049d <_panic>

00801edf <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  801edf:	55                   	push   %ebp
  801ee0:	89 e5                	mov    %esp,%ebp
  801ee2:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  801ee5:	83 ec 04             	sub    $0x4,%esp
  801ee8:	68 cc 2c 80 00       	push   $0x802ccc
  801eed:	6a 72                	push   $0x72
  801eef:	68 b3 2b 80 00       	push   $0x802bb3
  801ef4:	e8 a4 e5 ff ff       	call   80049d <_panic>
  801ef9:	66 90                	xchg   %ax,%ax
  801efb:	90                   	nop

00801efc <__udivdi3>:
  801efc:	55                   	push   %ebp
  801efd:	57                   	push   %edi
  801efe:	56                   	push   %esi
  801eff:	53                   	push   %ebx
  801f00:	83 ec 1c             	sub    $0x1c,%esp
  801f03:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801f07:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801f0b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801f0f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801f13:	89 ca                	mov    %ecx,%edx
  801f15:	89 f8                	mov    %edi,%eax
  801f17:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801f1b:	85 f6                	test   %esi,%esi
  801f1d:	75 2d                	jne    801f4c <__udivdi3+0x50>
  801f1f:	39 cf                	cmp    %ecx,%edi
  801f21:	77 65                	ja     801f88 <__udivdi3+0x8c>
  801f23:	89 fd                	mov    %edi,%ebp
  801f25:	85 ff                	test   %edi,%edi
  801f27:	75 0b                	jne    801f34 <__udivdi3+0x38>
  801f29:	b8 01 00 00 00       	mov    $0x1,%eax
  801f2e:	31 d2                	xor    %edx,%edx
  801f30:	f7 f7                	div    %edi
  801f32:	89 c5                	mov    %eax,%ebp
  801f34:	31 d2                	xor    %edx,%edx
  801f36:	89 c8                	mov    %ecx,%eax
  801f38:	f7 f5                	div    %ebp
  801f3a:	89 c1                	mov    %eax,%ecx
  801f3c:	89 d8                	mov    %ebx,%eax
  801f3e:	f7 f5                	div    %ebp
  801f40:	89 cf                	mov    %ecx,%edi
  801f42:	89 fa                	mov    %edi,%edx
  801f44:	83 c4 1c             	add    $0x1c,%esp
  801f47:	5b                   	pop    %ebx
  801f48:	5e                   	pop    %esi
  801f49:	5f                   	pop    %edi
  801f4a:	5d                   	pop    %ebp
  801f4b:	c3                   	ret    
  801f4c:	39 ce                	cmp    %ecx,%esi
  801f4e:	77 28                	ja     801f78 <__udivdi3+0x7c>
  801f50:	0f bd fe             	bsr    %esi,%edi
  801f53:	83 f7 1f             	xor    $0x1f,%edi
  801f56:	75 40                	jne    801f98 <__udivdi3+0x9c>
  801f58:	39 ce                	cmp    %ecx,%esi
  801f5a:	72 0a                	jb     801f66 <__udivdi3+0x6a>
  801f5c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801f60:	0f 87 9e 00 00 00    	ja     802004 <__udivdi3+0x108>
  801f66:	b8 01 00 00 00       	mov    $0x1,%eax
  801f6b:	89 fa                	mov    %edi,%edx
  801f6d:	83 c4 1c             	add    $0x1c,%esp
  801f70:	5b                   	pop    %ebx
  801f71:	5e                   	pop    %esi
  801f72:	5f                   	pop    %edi
  801f73:	5d                   	pop    %ebp
  801f74:	c3                   	ret    
  801f75:	8d 76 00             	lea    0x0(%esi),%esi
  801f78:	31 ff                	xor    %edi,%edi
  801f7a:	31 c0                	xor    %eax,%eax
  801f7c:	89 fa                	mov    %edi,%edx
  801f7e:	83 c4 1c             	add    $0x1c,%esp
  801f81:	5b                   	pop    %ebx
  801f82:	5e                   	pop    %esi
  801f83:	5f                   	pop    %edi
  801f84:	5d                   	pop    %ebp
  801f85:	c3                   	ret    
  801f86:	66 90                	xchg   %ax,%ax
  801f88:	89 d8                	mov    %ebx,%eax
  801f8a:	f7 f7                	div    %edi
  801f8c:	31 ff                	xor    %edi,%edi
  801f8e:	89 fa                	mov    %edi,%edx
  801f90:	83 c4 1c             	add    $0x1c,%esp
  801f93:	5b                   	pop    %ebx
  801f94:	5e                   	pop    %esi
  801f95:	5f                   	pop    %edi
  801f96:	5d                   	pop    %ebp
  801f97:	c3                   	ret    
  801f98:	bd 20 00 00 00       	mov    $0x20,%ebp
  801f9d:	89 eb                	mov    %ebp,%ebx
  801f9f:	29 fb                	sub    %edi,%ebx
  801fa1:	89 f9                	mov    %edi,%ecx
  801fa3:	d3 e6                	shl    %cl,%esi
  801fa5:	89 c5                	mov    %eax,%ebp
  801fa7:	88 d9                	mov    %bl,%cl
  801fa9:	d3 ed                	shr    %cl,%ebp
  801fab:	89 e9                	mov    %ebp,%ecx
  801fad:	09 f1                	or     %esi,%ecx
  801faf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801fb3:	89 f9                	mov    %edi,%ecx
  801fb5:	d3 e0                	shl    %cl,%eax
  801fb7:	89 c5                	mov    %eax,%ebp
  801fb9:	89 d6                	mov    %edx,%esi
  801fbb:	88 d9                	mov    %bl,%cl
  801fbd:	d3 ee                	shr    %cl,%esi
  801fbf:	89 f9                	mov    %edi,%ecx
  801fc1:	d3 e2                	shl    %cl,%edx
  801fc3:	8b 44 24 08          	mov    0x8(%esp),%eax
  801fc7:	88 d9                	mov    %bl,%cl
  801fc9:	d3 e8                	shr    %cl,%eax
  801fcb:	09 c2                	or     %eax,%edx
  801fcd:	89 d0                	mov    %edx,%eax
  801fcf:	89 f2                	mov    %esi,%edx
  801fd1:	f7 74 24 0c          	divl   0xc(%esp)
  801fd5:	89 d6                	mov    %edx,%esi
  801fd7:	89 c3                	mov    %eax,%ebx
  801fd9:	f7 e5                	mul    %ebp
  801fdb:	39 d6                	cmp    %edx,%esi
  801fdd:	72 19                	jb     801ff8 <__udivdi3+0xfc>
  801fdf:	74 0b                	je     801fec <__udivdi3+0xf0>
  801fe1:	89 d8                	mov    %ebx,%eax
  801fe3:	31 ff                	xor    %edi,%edi
  801fe5:	e9 58 ff ff ff       	jmp    801f42 <__udivdi3+0x46>
  801fea:	66 90                	xchg   %ax,%ax
  801fec:	8b 54 24 08          	mov    0x8(%esp),%edx
  801ff0:	89 f9                	mov    %edi,%ecx
  801ff2:	d3 e2                	shl    %cl,%edx
  801ff4:	39 c2                	cmp    %eax,%edx
  801ff6:	73 e9                	jae    801fe1 <__udivdi3+0xe5>
  801ff8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801ffb:	31 ff                	xor    %edi,%edi
  801ffd:	e9 40 ff ff ff       	jmp    801f42 <__udivdi3+0x46>
  802002:	66 90                	xchg   %ax,%ax
  802004:	31 c0                	xor    %eax,%eax
  802006:	e9 37 ff ff ff       	jmp    801f42 <__udivdi3+0x46>
  80200b:	90                   	nop

0080200c <__umoddi3>:
  80200c:	55                   	push   %ebp
  80200d:	57                   	push   %edi
  80200e:	56                   	push   %esi
  80200f:	53                   	push   %ebx
  802010:	83 ec 1c             	sub    $0x1c,%esp
  802013:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802017:	8b 74 24 34          	mov    0x34(%esp),%esi
  80201b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80201f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802023:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802027:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80202b:	89 f3                	mov    %esi,%ebx
  80202d:	89 fa                	mov    %edi,%edx
  80202f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802033:	89 34 24             	mov    %esi,(%esp)
  802036:	85 c0                	test   %eax,%eax
  802038:	75 1a                	jne    802054 <__umoddi3+0x48>
  80203a:	39 f7                	cmp    %esi,%edi
  80203c:	0f 86 a2 00 00 00    	jbe    8020e4 <__umoddi3+0xd8>
  802042:	89 c8                	mov    %ecx,%eax
  802044:	89 f2                	mov    %esi,%edx
  802046:	f7 f7                	div    %edi
  802048:	89 d0                	mov    %edx,%eax
  80204a:	31 d2                	xor    %edx,%edx
  80204c:	83 c4 1c             	add    $0x1c,%esp
  80204f:	5b                   	pop    %ebx
  802050:	5e                   	pop    %esi
  802051:	5f                   	pop    %edi
  802052:	5d                   	pop    %ebp
  802053:	c3                   	ret    
  802054:	39 f0                	cmp    %esi,%eax
  802056:	0f 87 ac 00 00 00    	ja     802108 <__umoddi3+0xfc>
  80205c:	0f bd e8             	bsr    %eax,%ebp
  80205f:	83 f5 1f             	xor    $0x1f,%ebp
  802062:	0f 84 ac 00 00 00    	je     802114 <__umoddi3+0x108>
  802068:	bf 20 00 00 00       	mov    $0x20,%edi
  80206d:	29 ef                	sub    %ebp,%edi
  80206f:	89 fe                	mov    %edi,%esi
  802071:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802075:	89 e9                	mov    %ebp,%ecx
  802077:	d3 e0                	shl    %cl,%eax
  802079:	89 d7                	mov    %edx,%edi
  80207b:	89 f1                	mov    %esi,%ecx
  80207d:	d3 ef                	shr    %cl,%edi
  80207f:	09 c7                	or     %eax,%edi
  802081:	89 e9                	mov    %ebp,%ecx
  802083:	d3 e2                	shl    %cl,%edx
  802085:	89 14 24             	mov    %edx,(%esp)
  802088:	89 d8                	mov    %ebx,%eax
  80208a:	d3 e0                	shl    %cl,%eax
  80208c:	89 c2                	mov    %eax,%edx
  80208e:	8b 44 24 08          	mov    0x8(%esp),%eax
  802092:	d3 e0                	shl    %cl,%eax
  802094:	89 44 24 04          	mov    %eax,0x4(%esp)
  802098:	8b 44 24 08          	mov    0x8(%esp),%eax
  80209c:	89 f1                	mov    %esi,%ecx
  80209e:	d3 e8                	shr    %cl,%eax
  8020a0:	09 d0                	or     %edx,%eax
  8020a2:	d3 eb                	shr    %cl,%ebx
  8020a4:	89 da                	mov    %ebx,%edx
  8020a6:	f7 f7                	div    %edi
  8020a8:	89 d3                	mov    %edx,%ebx
  8020aa:	f7 24 24             	mull   (%esp)
  8020ad:	89 c6                	mov    %eax,%esi
  8020af:	89 d1                	mov    %edx,%ecx
  8020b1:	39 d3                	cmp    %edx,%ebx
  8020b3:	0f 82 87 00 00 00    	jb     802140 <__umoddi3+0x134>
  8020b9:	0f 84 91 00 00 00    	je     802150 <__umoddi3+0x144>
  8020bf:	8b 54 24 04          	mov    0x4(%esp),%edx
  8020c3:	29 f2                	sub    %esi,%edx
  8020c5:	19 cb                	sbb    %ecx,%ebx
  8020c7:	89 d8                	mov    %ebx,%eax
  8020c9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8020cd:	d3 e0                	shl    %cl,%eax
  8020cf:	89 e9                	mov    %ebp,%ecx
  8020d1:	d3 ea                	shr    %cl,%edx
  8020d3:	09 d0                	or     %edx,%eax
  8020d5:	89 e9                	mov    %ebp,%ecx
  8020d7:	d3 eb                	shr    %cl,%ebx
  8020d9:	89 da                	mov    %ebx,%edx
  8020db:	83 c4 1c             	add    $0x1c,%esp
  8020de:	5b                   	pop    %ebx
  8020df:	5e                   	pop    %esi
  8020e0:	5f                   	pop    %edi
  8020e1:	5d                   	pop    %ebp
  8020e2:	c3                   	ret    
  8020e3:	90                   	nop
  8020e4:	89 fd                	mov    %edi,%ebp
  8020e6:	85 ff                	test   %edi,%edi
  8020e8:	75 0b                	jne    8020f5 <__umoddi3+0xe9>
  8020ea:	b8 01 00 00 00       	mov    $0x1,%eax
  8020ef:	31 d2                	xor    %edx,%edx
  8020f1:	f7 f7                	div    %edi
  8020f3:	89 c5                	mov    %eax,%ebp
  8020f5:	89 f0                	mov    %esi,%eax
  8020f7:	31 d2                	xor    %edx,%edx
  8020f9:	f7 f5                	div    %ebp
  8020fb:	89 c8                	mov    %ecx,%eax
  8020fd:	f7 f5                	div    %ebp
  8020ff:	89 d0                	mov    %edx,%eax
  802101:	e9 44 ff ff ff       	jmp    80204a <__umoddi3+0x3e>
  802106:	66 90                	xchg   %ax,%ax
  802108:	89 c8                	mov    %ecx,%eax
  80210a:	89 f2                	mov    %esi,%edx
  80210c:	83 c4 1c             	add    $0x1c,%esp
  80210f:	5b                   	pop    %ebx
  802110:	5e                   	pop    %esi
  802111:	5f                   	pop    %edi
  802112:	5d                   	pop    %ebp
  802113:	c3                   	ret    
  802114:	3b 04 24             	cmp    (%esp),%eax
  802117:	72 06                	jb     80211f <__umoddi3+0x113>
  802119:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80211d:	77 0f                	ja     80212e <__umoddi3+0x122>
  80211f:	89 f2                	mov    %esi,%edx
  802121:	29 f9                	sub    %edi,%ecx
  802123:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802127:	89 14 24             	mov    %edx,(%esp)
  80212a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80212e:	8b 44 24 04          	mov    0x4(%esp),%eax
  802132:	8b 14 24             	mov    (%esp),%edx
  802135:	83 c4 1c             	add    $0x1c,%esp
  802138:	5b                   	pop    %ebx
  802139:	5e                   	pop    %esi
  80213a:	5f                   	pop    %edi
  80213b:	5d                   	pop    %ebp
  80213c:	c3                   	ret    
  80213d:	8d 76 00             	lea    0x0(%esi),%esi
  802140:	2b 04 24             	sub    (%esp),%eax
  802143:	19 fa                	sbb    %edi,%edx
  802145:	89 d1                	mov    %edx,%ecx
  802147:	89 c6                	mov    %eax,%esi
  802149:	e9 71 ff ff ff       	jmp    8020bf <__umoddi3+0xb3>
  80214e:	66 90                	xchg   %ax,%ax
  802150:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802154:	72 ea                	jb     802140 <__umoddi3+0x134>
  802156:	89 d9                	mov    %ebx,%ecx
  802158:	e9 62 ff ff ff       	jmp    8020bf <__umoddi3+0xb3>


obj/user/tst_placement:     file format elf32-i386


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
  800031:	e8 1e 05 00 00       	call   800554 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
		0x200000, 0x201000, 0x202000, 0x203000, 0x204000, 0x205000, 0x206000,0x207000,	//Unused
		0x800000, 0x801000, 0x802000, 0x803000,		//Code & Data
		0xeebfd000, 0xedbfd000 /*will be created during the call of sys_check_WS_list*/} ;//Stack

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	81 ec 74 00 00 01    	sub    $0x1000074,%esp

	char arr[PAGE_SIZE*1024*4];
	bool found ;
	//("STEP 0: checking Initial WS entries ...\n");
	{
		found = sys_check_WS_list(expectedInitialVAs, 14, 0, 1);
  800042:	6a 01                	push   $0x1
  800044:	6a 00                	push   $0x0
  800046:	6a 0e                	push   $0xe
  800048:	68 00 30 80 00       	push   $0x803000
  80004d:	e8 46 1d 00 00       	call   801d98 <sys_check_WS_list>
  800052:	83 c4 10             	add    $0x10,%esp
  800055:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (found != 1) panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800058:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  80005c:	74 14                	je     800072 <_main+0x3a>
  80005e:	83 ec 04             	sub    $0x4,%esp
  800061:	68 e0 20 80 00       	push   $0x8020e0
  800066:	6a 15                	push   $0x15
  800068:	68 21 21 80 00       	push   $0x802121
  80006d:	e8 92 06 00 00       	call   800704 <_panic>

		/*NO NEED FOR THIS IF REPL IS "LRU"*/
		if( myEnv->page_last_WS_element !=  NULL)
  800072:	a1 40 30 80 00       	mov    0x803040,%eax
  800077:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
  80007d:	85 c0                	test   %eax,%eax
  80007f:	74 14                	je     800095 <_main+0x5d>
			panic("INITIAL PAGE last WS checking failed! Review size of the WS..!!");
  800081:	83 ec 04             	sub    $0x4,%esp
  800084:	68 38 21 80 00       	push   $0x802138
  800089:	6a 19                	push   $0x19
  80008b:	68 21 21 80 00       	push   $0x802121
  800090:	e8 6f 06 00 00       	call   800704 <_panic>
		/*====================================*/
	}
	int eval = 0;
  800095:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	bool is_correct = 1;
  80009c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000a3:	e8 79 19 00 00       	call   801a21 <sys_pf_calculate_allocated_pages>
  8000a8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int freePages = sys_calculate_free_frames();
  8000ab:	e8 26 19 00 00       	call   8019d6 <sys_calculate_free_frames>
  8000b0:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int i=0;
  8000b3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	for(;i<=PAGE_SIZE;i++)
  8000ba:	eb 11                	jmp    8000cd <_main+0x95>
	{
		arr[i] = 1;
  8000bc:	8d 95 dc ff ff fe    	lea    -0x1000024(%ebp),%edx
  8000c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000c5:	01 d0                	add    %edx,%eax
  8000c7:	c6 00 01             	movb   $0x1,(%eax)
	int eval = 0;
	bool is_correct = 1;
	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
	int freePages = sys_calculate_free_frames();
	int i=0;
	for(;i<=PAGE_SIZE;i++)
  8000ca:	ff 45 ec             	incl   -0x14(%ebp)
  8000cd:	81 7d ec 00 10 00 00 	cmpl   $0x1000,-0x14(%ebp)
  8000d4:	7e e6                	jle    8000bc <_main+0x84>
	{
		arr[i] = 1;
	}

	i=PAGE_SIZE*1024;
  8000d6:	c7 45 ec 00 00 40 00 	movl   $0x400000,-0x14(%ebp)
	for(;i<=(PAGE_SIZE*1024 + PAGE_SIZE);i++)
  8000dd:	eb 11                	jmp    8000f0 <_main+0xb8>
	{
		arr[i] = 2;
  8000df:	8d 95 dc ff ff fe    	lea    -0x1000024(%ebp),%edx
  8000e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000e8:	01 d0                	add    %edx,%eax
  8000ea:	c6 00 02             	movb   $0x2,(%eax)
	{
		arr[i] = 1;
	}

	i=PAGE_SIZE*1024;
	for(;i<=(PAGE_SIZE*1024 + PAGE_SIZE);i++)
  8000ed:	ff 45 ec             	incl   -0x14(%ebp)
  8000f0:	81 7d ec 00 10 40 00 	cmpl   $0x401000,-0x14(%ebp)
  8000f7:	7e e6                	jle    8000df <_main+0xa7>
	{
		arr[i] = 2;
	}

	i=PAGE_SIZE*1024*2;
  8000f9:	c7 45 ec 00 00 80 00 	movl   $0x800000,-0x14(%ebp)
	for(;i<=(PAGE_SIZE*1024*2 + PAGE_SIZE);i++)
  800100:	eb 11                	jmp    800113 <_main+0xdb>
	{
		arr[i] = 3;
  800102:	8d 95 dc ff ff fe    	lea    -0x1000024(%ebp),%edx
  800108:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80010b:	01 d0                	add    %edx,%eax
  80010d:	c6 00 03             	movb   $0x3,(%eax)
	{
		arr[i] = 2;
	}

	i=PAGE_SIZE*1024*2;
	for(;i<=(PAGE_SIZE*1024*2 + PAGE_SIZE);i++)
  800110:	ff 45 ec             	incl   -0x14(%ebp)
  800113:	81 7d ec 00 10 80 00 	cmpl   $0x801000,-0x14(%ebp)
  80011a:	7e e6                	jle    800102 <_main+0xca>
	{
		arr[i] = 3;
	}

	is_correct = 1;
  80011c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	cprintf("STEP A: checking PLACEMENT fault handling... [40%] \n");
  800123:	83 ec 0c             	sub    $0xc,%esp
  800126:	68 78 21 80 00       	push   $0x802178
  80012b:	e8 a2 08 00 00       	call   8009d2 <cprintf>
  800130:	83 c4 10             	add    $0x10,%esp
	{
		if( arr[0] !=  1)  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n");}
  800133:	8a 85 dc ff ff fe    	mov    -0x1000024(%ebp),%al
  800139:	3c 01                	cmp    $0x1,%al
  80013b:	74 17                	je     800154 <_main+0x11c>
  80013d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800144:	83 ec 0c             	sub    $0xc,%esp
  800147:	68 b0 21 80 00       	push   $0x8021b0
  80014c:	e8 81 08 00 00       	call   8009d2 <cprintf>
  800151:	83 c4 10             	add    $0x10,%esp
		if( arr[PAGE_SIZE] !=  1)  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n");}
  800154:	8a 85 dc 0f 00 ff    	mov    -0xfff024(%ebp),%al
  80015a:	3c 01                	cmp    $0x1,%al
  80015c:	74 17                	je     800175 <_main+0x13d>
  80015e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800165:	83 ec 0c             	sub    $0xc,%esp
  800168:	68 b0 21 80 00       	push   $0x8021b0
  80016d:	e8 60 08 00 00       	call   8009d2 <cprintf>
  800172:	83 c4 10             	add    $0x10,%esp

		if( arr[PAGE_SIZE*1024] !=  2)  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n");}
  800175:	8a 85 dc ff 3f ff    	mov    -0xc00024(%ebp),%al
  80017b:	3c 02                	cmp    $0x2,%al
  80017d:	74 17                	je     800196 <_main+0x15e>
  80017f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800186:	83 ec 0c             	sub    $0xc,%esp
  800189:	68 b0 21 80 00       	push   $0x8021b0
  80018e:	e8 3f 08 00 00       	call   8009d2 <cprintf>
  800193:	83 c4 10             	add    $0x10,%esp
		if( arr[PAGE_SIZE*1025] !=  2)  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n");}
  800196:	8a 85 dc 0f 40 ff    	mov    -0xbff024(%ebp),%al
  80019c:	3c 02                	cmp    $0x2,%al
  80019e:	74 17                	je     8001b7 <_main+0x17f>
  8001a0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001a7:	83 ec 0c             	sub    $0xc,%esp
  8001aa:	68 b0 21 80 00       	push   $0x8021b0
  8001af:	e8 1e 08 00 00       	call   8009d2 <cprintf>
  8001b4:	83 c4 10             	add    $0x10,%esp

		if( arr[PAGE_SIZE*1024*2] !=  3)  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n");}
  8001b7:	8a 85 dc ff 7f ff    	mov    -0x800024(%ebp),%al
  8001bd:	3c 03                	cmp    $0x3,%al
  8001bf:	74 17                	je     8001d8 <_main+0x1a0>
  8001c1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001c8:	83 ec 0c             	sub    $0xc,%esp
  8001cb:	68 b0 21 80 00       	push   $0x8021b0
  8001d0:	e8 fd 07 00 00       	call   8009d2 <cprintf>
  8001d5:	83 c4 10             	add    $0x10,%esp
		if( arr[PAGE_SIZE*1024*2 + PAGE_SIZE] !=  3)  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n");}
  8001d8:	8a 85 dc 0f 80 ff    	mov    -0x7ff024(%ebp),%al
  8001de:	3c 03                	cmp    $0x3,%al
  8001e0:	74 17                	je     8001f9 <_main+0x1c1>
  8001e2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001e9:	83 ec 0c             	sub    $0xc,%esp
  8001ec:	68 b0 21 80 00       	push   $0x8021b0
  8001f1:	e8 dc 07 00 00       	call   8009d2 <cprintf>
  8001f6:	83 c4 10             	add    $0x10,%esp


		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("new stack pages should NOT be written to Page File until evicted as victim\n");}
  8001f9:	e8 23 18 00 00       	call   801a21 <sys_pf_calculate_allocated_pages>
  8001fe:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800201:	74 17                	je     80021a <_main+0x1e2>
  800203:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80020a:	83 ec 0c             	sub    $0xc,%esp
  80020d:	68 d0 21 80 00       	push   $0x8021d0
  800212:	e8 bb 07 00 00       	call   8009d2 <cprintf>
  800217:	83 c4 10             	add    $0x10,%esp

		int expected = 5 /*pages*/ + 2 /*tables*/;
  80021a:	c7 45 dc 07 00 00 00 	movl   $0x7,-0x24(%ebp)
		if( (freePages - sys_calculate_free_frames() ) != expected )
  800221:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800224:	e8 ad 17 00 00       	call   8019d6 <sys_calculate_free_frames>
  800229:	29 c3                	sub    %eax,%ebx
  80022b:	89 da                	mov    %ebx,%edx
  80022d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800230:	39 c2                	cmp    %eax,%edx
  800232:	74 27                	je     80025b <_main+0x223>
		{ is_correct = 0; cprintf("allocated memory size incorrect. Expected Difference = %d, Actual = %d\n", expected, (freePages - sys_calculate_free_frames() ));}
  800234:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80023b:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80023e:	e8 93 17 00 00       	call   8019d6 <sys_calculate_free_frames>
  800243:	29 c3                	sub    %eax,%ebx
  800245:	89 d8                	mov    %ebx,%eax
  800247:	83 ec 04             	sub    $0x4,%esp
  80024a:	50                   	push   %eax
  80024b:	ff 75 dc             	pushl  -0x24(%ebp)
  80024e:	68 1c 22 80 00       	push   $0x80221c
  800253:	e8 7a 07 00 00       	call   8009d2 <cprintf>
  800258:	83 c4 10             	add    $0x10,%esp
	}
	cprintf("STEP A finished: PLACEMENT fault handling !\n\n\n");
  80025b:	83 ec 0c             	sub    $0xc,%esp
  80025e:	68 64 22 80 00       	push   $0x802264
  800263:	e8 6a 07 00 00       	call   8009d2 <cprintf>
  800268:	83 c4 10             	add    $0x10,%esp

	if (is_correct)
  80026b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80026f:	74 04                	je     800275 <_main+0x23d>
	{
		eval += 40;
  800271:	83 45 f4 28          	addl   $0x28,-0xc(%ebp)
	}
	is_correct = 1;
  800275:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	cprintf("STEP B: checking WS entries... [30%]\n");
  80027c:	83 ec 0c             	sub    $0xc,%esp
  80027f:	68 94 22 80 00       	push   $0x802294
  800284:	e8 49 07 00 00       	call   8009d2 <cprintf>
  800289:	83 c4 10             	add    $0x10,%esp
		//				0x200000,0x201000,0x202000,0x203000,0x204000,0x205000,0x206000,0x207000,
		//				0x800000,0x801000,0x802000,0x803000,
		//				0xeebfd000,0xedbfd000,0xedbfe000,0xedffd000,0xedffe000,0xee3fd000,0xee3fe000};
		uint32 expectedPages[19] ;
		{
			expectedPages[0] = 0x200000 ;
  80028c:	c7 85 90 ff ff fe 00 	movl   $0x200000,-0x1000070(%ebp)
  800293:	00 20 00 
			expectedPages[1] = 0x201000 ;
  800296:	c7 85 94 ff ff fe 00 	movl   $0x201000,-0x100006c(%ebp)
  80029d:	10 20 00 
			expectedPages[2] = 0x202000 ;
  8002a0:	c7 85 98 ff ff fe 00 	movl   $0x202000,-0x1000068(%ebp)
  8002a7:	20 20 00 
			expectedPages[3] = 0x203000 ;
  8002aa:	c7 85 9c ff ff fe 00 	movl   $0x203000,-0x1000064(%ebp)
  8002b1:	30 20 00 
			expectedPages[4] = 0x204000 ;
  8002b4:	c7 85 a0 ff ff fe 00 	movl   $0x204000,-0x1000060(%ebp)
  8002bb:	40 20 00 
			expectedPages[5] = 0x205000 ;
  8002be:	c7 85 a4 ff ff fe 00 	movl   $0x205000,-0x100005c(%ebp)
  8002c5:	50 20 00 
			expectedPages[6] = 0x206000 ;
  8002c8:	c7 85 a8 ff ff fe 00 	movl   $0x206000,-0x1000058(%ebp)
  8002cf:	60 20 00 
			expectedPages[7] = 0x207000 ;
  8002d2:	c7 85 ac ff ff fe 00 	movl   $0x207000,-0x1000054(%ebp)
  8002d9:	70 20 00 
			expectedPages[8] = 0x800000 ;
  8002dc:	c7 85 b0 ff ff fe 00 	movl   $0x800000,-0x1000050(%ebp)
  8002e3:	00 80 00 
			expectedPages[9] = 0x801000 ;
  8002e6:	c7 85 b4 ff ff fe 00 	movl   $0x801000,-0x100004c(%ebp)
  8002ed:	10 80 00 
			expectedPages[10] = 0x802000 ;
  8002f0:	c7 85 b8 ff ff fe 00 	movl   $0x802000,-0x1000048(%ebp)
  8002f7:	20 80 00 
			expectedPages[11] = 0x803000 ;
  8002fa:	c7 85 bc ff ff fe 00 	movl   $0x803000,-0x1000044(%ebp)
  800301:	30 80 00 
			expectedPages[12] = 0xeebfd000 ;
  800304:	c7 85 c0 ff ff fe 00 	movl   $0xeebfd000,-0x1000040(%ebp)
  80030b:	d0 bf ee 
			expectedPages[13] = 0xedbfd000 ;
  80030e:	c7 85 c4 ff ff fe 00 	movl   $0xedbfd000,-0x100003c(%ebp)
  800315:	d0 bf ed 
			expectedPages[14] = 0xedbfe000 ;
  800318:	c7 85 c8 ff ff fe 00 	movl   $0xedbfe000,-0x1000038(%ebp)
  80031f:	e0 bf ed 
			expectedPages[15] = 0xedffd000 ;
  800322:	c7 85 cc ff ff fe 00 	movl   $0xedffd000,-0x1000034(%ebp)
  800329:	d0 ff ed 
			expectedPages[16] = 0xedffe000 ;
  80032c:	c7 85 d0 ff ff fe 00 	movl   $0xedffe000,-0x1000030(%ebp)
  800333:	e0 ff ed 
			expectedPages[17] = 0xee3fd000 ;
  800336:	c7 85 d4 ff ff fe 00 	movl   $0xee3fd000,-0x100002c(%ebp)
  80033d:	d0 3f ee 
			expectedPages[18] = 0xee3fe000 ;
  800340:	c7 85 d8 ff ff fe 00 	movl   $0xee3fe000,-0x1000028(%ebp)
  800347:	e0 3f ee 
		}
		found = sys_check_WS_list(expectedPages, 19, 0, 1);
  80034a:	6a 01                	push   $0x1
  80034c:	6a 00                	push   $0x0
  80034e:	6a 13                	push   $0x13
  800350:	8d 85 90 ff ff fe    	lea    -0x1000070(%ebp),%eax
  800356:	50                   	push   %eax
  800357:	e8 3c 1a 00 00       	call   801d98 <sys_check_WS_list>
  80035c:	83 c4 10             	add    $0x10,%esp
  80035f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (found != 1)
  800362:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  800366:	74 17                	je     80037f <_main+0x347>
		{ is_correct = 0; cprintf("PAGE WS entry checking failed... trace it by printing page WS before & after fault\n");}
  800368:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80036f:	83 ec 0c             	sub    $0xc,%esp
  800372:	68 bc 22 80 00       	push   $0x8022bc
  800377:	e8 56 06 00 00       	call   8009d2 <cprintf>
  80037c:	83 c4 10             	add    $0x10,%esp
	}
	cprintf("STEP B finished: WS entries test \n\n\n");
  80037f:	83 ec 0c             	sub    $0xc,%esp
  800382:	68 10 23 80 00       	push   $0x802310
  800387:	e8 46 06 00 00       	call   8009d2 <cprintf>
  80038c:	83 c4 10             	add    $0x10,%esp
	if (is_correct)
  80038f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800393:	74 04                	je     800399 <_main+0x361>
	{
		eval += 30;
  800395:	83 45 f4 1e          	addl   $0x1e,-0xc(%ebp)
	}
	is_correct = 1;
  800399:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	cprintf("STEP C: checking working sets WHEN BECOMES FULL... [30%]\n");
  8003a0:	83 ec 0c             	sub    $0xc,%esp
  8003a3:	68 38 23 80 00       	push   $0x802338
  8003a8:	e8 25 06 00 00       	call   8009d2 <cprintf>
  8003ad:	83 c4 10             	add    $0x10,%esp
	{
		/*NO NEED FOR THIS IF REPL IS "LRU"*/
		if(myEnv->page_last_WS_element != NULL)
  8003b0:	a1 40 30 80 00       	mov    0x803040,%eax
  8003b5:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
  8003bb:	85 c0                	test   %eax,%eax
  8003bd:	74 17                	je     8003d6 <_main+0x39e>
		{ is_correct = 0; cprintf("wrong PAGE WS pointer location... trace it by printing page WS before & after fault\n");}
  8003bf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003c6:	83 ec 0c             	sub    $0xc,%esp
  8003c9:	68 74 23 80 00       	push   $0x802374
  8003ce:	e8 ff 05 00 00       	call   8009d2 <cprintf>
  8003d3:	83 c4 10             	add    $0x10,%esp

		i=PAGE_SIZE*1024*3;
  8003d6:	c7 45 ec 00 00 c0 00 	movl   $0xc00000,-0x14(%ebp)
		for(;i<=(PAGE_SIZE*1024*3);i++)
  8003dd:	eb 11                	jmp    8003f0 <_main+0x3b8>
		{
			arr[i] = 4;
  8003df:	8d 95 dc ff ff fe    	lea    -0x1000024(%ebp),%edx
  8003e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003e8:	01 d0                	add    %edx,%eax
  8003ea:	c6 00 04             	movb   $0x4,(%eax)
		/*NO NEED FOR THIS IF REPL IS "LRU"*/
		if(myEnv->page_last_WS_element != NULL)
		{ is_correct = 0; cprintf("wrong PAGE WS pointer location... trace it by printing page WS before & after fault\n");}

		i=PAGE_SIZE*1024*3;
		for(;i<=(PAGE_SIZE*1024*3);i++)
  8003ed:	ff 45 ec             	incl   -0x14(%ebp)
  8003f0:	81 7d ec 00 00 c0 00 	cmpl   $0xc00000,-0x14(%ebp)
  8003f7:	7e e6                	jle    8003df <_main+0x3a7>
		{
			arr[i] = 4;
		}

		if( arr[PAGE_SIZE*1024*3] != 4)  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n");}
  8003f9:	8a 85 dc ff bf ff    	mov    -0x400024(%ebp),%al
  8003ff:	3c 04                	cmp    $0x4,%al
  800401:	74 17                	je     80041a <_main+0x3e2>
  800403:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80040a:	83 ec 0c             	sub    $0xc,%esp
  80040d:	68 b0 21 80 00       	push   $0x8021b0
  800412:	e8 bb 05 00 00       	call   8009d2 <cprintf>
  800417:	83 c4 10             	add    $0x10,%esp
//				0x200000,0x201000,0x202000,0x203000,0x204000,0x205000,0x206000,0x207000,
//				0x800000,0x801000,0x802000,0x803000,
//				0xeebfd000,0xedbfd000,0xedbfe000,0xedffd000,0xedffe000,0xee3fd000,0xee3fe000,0xee7fd000};
		uint32 expectedPages[19] ;
		{
			expectedPages[0] = 0x200000 ;
  80041a:	c7 85 90 ff ff fe 00 	movl   $0x200000,-0x1000070(%ebp)
  800421:	00 20 00 
			expectedPages[1] = 0x201000 ;
  800424:	c7 85 94 ff ff fe 00 	movl   $0x201000,-0x100006c(%ebp)
  80042b:	10 20 00 
			expectedPages[2] = 0x202000 ;
  80042e:	c7 85 98 ff ff fe 00 	movl   $0x202000,-0x1000068(%ebp)
  800435:	20 20 00 
			expectedPages[3] = 0x203000 ;
  800438:	c7 85 9c ff ff fe 00 	movl   $0x203000,-0x1000064(%ebp)
  80043f:	30 20 00 
			expectedPages[4] = 0x204000 ;
  800442:	c7 85 a0 ff ff fe 00 	movl   $0x204000,-0x1000060(%ebp)
  800449:	40 20 00 
			expectedPages[5] = 0x205000 ;
  80044c:	c7 85 a4 ff ff fe 00 	movl   $0x205000,-0x100005c(%ebp)
  800453:	50 20 00 
			expectedPages[6] = 0x206000 ;
  800456:	c7 85 a8 ff ff fe 00 	movl   $0x206000,-0x1000058(%ebp)
  80045d:	60 20 00 
			expectedPages[7] = 0x207000 ;
  800460:	c7 85 ac ff ff fe 00 	movl   $0x207000,-0x1000054(%ebp)
  800467:	70 20 00 
			expectedPages[8] = 0x800000 ;
  80046a:	c7 85 b0 ff ff fe 00 	movl   $0x800000,-0x1000050(%ebp)
  800471:	00 80 00 
			expectedPages[9] = 0x801000 ;
  800474:	c7 85 b4 ff ff fe 00 	movl   $0x801000,-0x100004c(%ebp)
  80047b:	10 80 00 
			expectedPages[10] = 0x802000 ;
  80047e:	c7 85 b8 ff ff fe 00 	movl   $0x802000,-0x1000048(%ebp)
  800485:	20 80 00 
			expectedPages[11] = 0x803000 ;
  800488:	c7 85 bc ff ff fe 00 	movl   $0x803000,-0x1000044(%ebp)
  80048f:	30 80 00 
			expectedPages[12] = 0xeebfd000 ;
  800492:	c7 85 c0 ff ff fe 00 	movl   $0xeebfd000,-0x1000040(%ebp)
  800499:	d0 bf ee 
			expectedPages[13] = 0xedbfd000 ;
  80049c:	c7 85 c4 ff ff fe 00 	movl   $0xedbfd000,-0x100003c(%ebp)
  8004a3:	d0 bf ed 
			expectedPages[14] = 0xedbfe000 ;
  8004a6:	c7 85 c8 ff ff fe 00 	movl   $0xedbfe000,-0x1000038(%ebp)
  8004ad:	e0 bf ed 
			expectedPages[15] = 0xedffd000 ;
  8004b0:	c7 85 cc ff ff fe 00 	movl   $0xedffd000,-0x1000034(%ebp)
  8004b7:	d0 ff ed 
			expectedPages[16] = 0xedffe000 ;
  8004ba:	c7 85 d0 ff ff fe 00 	movl   $0xedffe000,-0x1000030(%ebp)
  8004c1:	e0 ff ed 
			expectedPages[17] = 0xee3fd000 ;
  8004c4:	c7 85 d4 ff ff fe 00 	movl   $0xee3fd000,-0x100002c(%ebp)
  8004cb:	d0 3f ee 
			expectedPages[18] = 0xee3fe000 ;
  8004ce:	c7 85 d8 ff ff fe 00 	movl   $0xee3fe000,-0x1000028(%ebp)
  8004d5:	e0 3f ee 
			expectedPages[19] = 0xee7fd000 ;
  8004d8:	c7 85 dc ff ff fe 00 	movl   $0xee7fd000,-0x1000024(%ebp)
  8004df:	d0 7f ee 
		}
		found = sys_check_WS_list(expectedPages, 20, 0x200000, 1);
  8004e2:	6a 01                	push   $0x1
  8004e4:	68 00 00 20 00       	push   $0x200000
  8004e9:	6a 14                	push   $0x14
  8004eb:	8d 85 90 ff ff fe    	lea    -0x1000070(%ebp),%eax
  8004f1:	50                   	push   %eax
  8004f2:	e8 a1 18 00 00       	call   801d98 <sys_check_WS_list>
  8004f7:	83 c4 10             	add    $0x10,%esp
  8004fa:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (found != 1)
  8004fd:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  800501:	74 17                	je     80051a <_main+0x4e2>
		{ is_correct = 0; cprintf("PAGE WS entry checking failed... trace it by printing page WS before & after fault\n");}
  800503:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80050a:	83 ec 0c             	sub    $0xc,%esp
  80050d:	68 bc 22 80 00       	push   $0x8022bc
  800512:	e8 bb 04 00 00       	call   8009d2 <cprintf>
  800517:	83 c4 10             	add    $0x10,%esp
		/*NO NEED FOR THIS IF REPL IS "LRU"*/
		//if(myEnv->page_last_WS_index != 0) { is_correct = 0; cprintf("wrong PAGE WS pointer location... trace it by printing page WS before & after fault\n");}

	}
	cprintf("STEP C finished: WS is FULL now\n\n\n");
  80051a:	83 ec 0c             	sub    $0xc,%esp
  80051d:	68 cc 23 80 00       	push   $0x8023cc
  800522:	e8 ab 04 00 00       	call   8009d2 <cprintf>
  800527:	83 c4 10             	add    $0x10,%esp
	if (is_correct)
  80052a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80052e:	74 04                	je     800534 <_main+0x4fc>
	{
		eval += 30;
  800530:	83 45 f4 1e          	addl   $0x1e,-0xc(%ebp)
	}
	is_correct = 1;
  800534:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	cprintf("%~\nTest of PAGE PLACEMENT completed. Eval = %d\n\n", eval);
  80053b:	83 ec 08             	sub    $0x8,%esp
  80053e:	ff 75 f4             	pushl  -0xc(%ebp)
  800541:	68 f0 23 80 00       	push   $0x8023f0
  800546:	e8 87 04 00 00       	call   8009d2 <cprintf>
  80054b:	83 c4 10             	add    $0x10,%esp

	return;
  80054e:	90                   	nop
#endif
}
  80054f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800552:	c9                   	leave  
  800553:	c3                   	ret    

00800554 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800554:	55                   	push   %ebp
  800555:	89 e5                	mov    %esp,%ebp
  800557:	57                   	push   %edi
  800558:	56                   	push   %esi
  800559:	53                   	push   %ebx
  80055a:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80055d:	e8 3d 16 00 00       	call   801b9f <sys_getenvindex>
  800562:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800565:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800568:	89 d0                	mov    %edx,%eax
  80056a:	c1 e0 02             	shl    $0x2,%eax
  80056d:	01 d0                	add    %edx,%eax
  80056f:	c1 e0 03             	shl    $0x3,%eax
  800572:	01 d0                	add    %edx,%eax
  800574:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80057b:	01 d0                	add    %edx,%eax
  80057d:	c1 e0 02             	shl    $0x2,%eax
  800580:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800585:	a3 40 30 80 00       	mov    %eax,0x803040

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80058a:	a1 40 30 80 00       	mov    0x803040,%eax
  80058f:	8a 40 20             	mov    0x20(%eax),%al
  800592:	84 c0                	test   %al,%al
  800594:	74 0d                	je     8005a3 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800596:	a1 40 30 80 00       	mov    0x803040,%eax
  80059b:	83 c0 20             	add    $0x20,%eax
  80059e:	a3 3c 30 80 00       	mov    %eax,0x80303c

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8005a3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8005a7:	7e 0a                	jle    8005b3 <libmain+0x5f>
		binaryname = argv[0];
  8005a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005ac:	8b 00                	mov    (%eax),%eax
  8005ae:	a3 3c 30 80 00       	mov    %eax,0x80303c

	// call user main routine
	_main(argc, argv);
  8005b3:	83 ec 08             	sub    $0x8,%esp
  8005b6:	ff 75 0c             	pushl  0xc(%ebp)
  8005b9:	ff 75 08             	pushl  0x8(%ebp)
  8005bc:	e8 77 fa ff ff       	call   800038 <_main>
  8005c1:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8005c4:	a1 38 30 80 00       	mov    0x803038,%eax
  8005c9:	85 c0                	test   %eax,%eax
  8005cb:	0f 84 01 01 00 00    	je     8006d2 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8005d1:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8005d7:	bb 1c 25 80 00       	mov    $0x80251c,%ebx
  8005dc:	ba 0e 00 00 00       	mov    $0xe,%edx
  8005e1:	89 c7                	mov    %eax,%edi
  8005e3:	89 de                	mov    %ebx,%esi
  8005e5:	89 d1                	mov    %edx,%ecx
  8005e7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8005e9:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8005ec:	b9 56 00 00 00       	mov    $0x56,%ecx
  8005f1:	b0 00                	mov    $0x0,%al
  8005f3:	89 d7                	mov    %edx,%edi
  8005f5:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8005f7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8005fe:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800601:	83 ec 08             	sub    $0x8,%esp
  800604:	50                   	push   %eax
  800605:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80060b:	50                   	push   %eax
  80060c:	e8 c4 17 00 00       	call   801dd5 <sys_utilities>
  800611:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800614:	e8 0d 13 00 00       	call   801926 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800619:	83 ec 0c             	sub    $0xc,%esp
  80061c:	68 3c 24 80 00       	push   $0x80243c
  800621:	e8 ac 03 00 00       	call   8009d2 <cprintf>
  800626:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800629:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80062c:	85 c0                	test   %eax,%eax
  80062e:	74 18                	je     800648 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800630:	e8 be 17 00 00       	call   801df3 <sys_get_optimal_num_faults>
  800635:	83 ec 08             	sub    $0x8,%esp
  800638:	50                   	push   %eax
  800639:	68 64 24 80 00       	push   $0x802464
  80063e:	e8 8f 03 00 00       	call   8009d2 <cprintf>
  800643:	83 c4 10             	add    $0x10,%esp
  800646:	eb 59                	jmp    8006a1 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800648:	a1 40 30 80 00       	mov    0x803040,%eax
  80064d:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  800653:	a1 40 30 80 00       	mov    0x803040,%eax
  800658:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  80065e:	83 ec 04             	sub    $0x4,%esp
  800661:	52                   	push   %edx
  800662:	50                   	push   %eax
  800663:	68 88 24 80 00       	push   $0x802488
  800668:	e8 65 03 00 00       	call   8009d2 <cprintf>
  80066d:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800670:	a1 40 30 80 00       	mov    0x803040,%eax
  800675:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  80067b:	a1 40 30 80 00       	mov    0x803040,%eax
  800680:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  800686:	a1 40 30 80 00       	mov    0x803040,%eax
  80068b:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  800691:	51                   	push   %ecx
  800692:	52                   	push   %edx
  800693:	50                   	push   %eax
  800694:	68 b0 24 80 00       	push   $0x8024b0
  800699:	e8 34 03 00 00       	call   8009d2 <cprintf>
  80069e:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8006a1:	a1 40 30 80 00       	mov    0x803040,%eax
  8006a6:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  8006ac:	83 ec 08             	sub    $0x8,%esp
  8006af:	50                   	push   %eax
  8006b0:	68 08 25 80 00       	push   $0x802508
  8006b5:	e8 18 03 00 00       	call   8009d2 <cprintf>
  8006ba:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8006bd:	83 ec 0c             	sub    $0xc,%esp
  8006c0:	68 3c 24 80 00       	push   $0x80243c
  8006c5:	e8 08 03 00 00       	call   8009d2 <cprintf>
  8006ca:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8006cd:	e8 6e 12 00 00       	call   801940 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8006d2:	e8 1f 00 00 00       	call   8006f6 <exit>
}
  8006d7:	90                   	nop
  8006d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006db:	5b                   	pop    %ebx
  8006dc:	5e                   	pop    %esi
  8006dd:	5f                   	pop    %edi
  8006de:	5d                   	pop    %ebp
  8006df:	c3                   	ret    

008006e0 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8006e0:	55                   	push   %ebp
  8006e1:	89 e5                	mov    %esp,%ebp
  8006e3:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8006e6:	83 ec 0c             	sub    $0xc,%esp
  8006e9:	6a 00                	push   $0x0
  8006eb:	e8 7b 14 00 00       	call   801b6b <sys_destroy_env>
  8006f0:	83 c4 10             	add    $0x10,%esp
}
  8006f3:	90                   	nop
  8006f4:	c9                   	leave  
  8006f5:	c3                   	ret    

008006f6 <exit>:

void
exit(void)
{
  8006f6:	55                   	push   %ebp
  8006f7:	89 e5                	mov    %esp,%ebp
  8006f9:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8006fc:	e8 d0 14 00 00       	call   801bd1 <sys_exit_env>
}
  800701:	90                   	nop
  800702:	c9                   	leave  
  800703:	c3                   	ret    

00800704 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800704:	55                   	push   %ebp
  800705:	89 e5                	mov    %esp,%ebp
  800707:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80070a:	8d 45 10             	lea    0x10(%ebp),%eax
  80070d:	83 c0 04             	add    $0x4,%eax
  800710:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800713:	a1 38 b1 81 00       	mov    0x81b138,%eax
  800718:	85 c0                	test   %eax,%eax
  80071a:	74 16                	je     800732 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80071c:	a1 38 b1 81 00       	mov    0x81b138,%eax
  800721:	83 ec 08             	sub    $0x8,%esp
  800724:	50                   	push   %eax
  800725:	68 80 25 80 00       	push   $0x802580
  80072a:	e8 a3 02 00 00       	call   8009d2 <cprintf>
  80072f:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800732:	a1 3c 30 80 00       	mov    0x80303c,%eax
  800737:	83 ec 0c             	sub    $0xc,%esp
  80073a:	ff 75 0c             	pushl  0xc(%ebp)
  80073d:	ff 75 08             	pushl  0x8(%ebp)
  800740:	50                   	push   %eax
  800741:	68 88 25 80 00       	push   $0x802588
  800746:	6a 74                	push   $0x74
  800748:	e8 b2 02 00 00       	call   8009ff <cprintf_colored>
  80074d:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800750:	8b 45 10             	mov    0x10(%ebp),%eax
  800753:	83 ec 08             	sub    $0x8,%esp
  800756:	ff 75 f4             	pushl  -0xc(%ebp)
  800759:	50                   	push   %eax
  80075a:	e8 04 02 00 00       	call   800963 <vcprintf>
  80075f:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800762:	83 ec 08             	sub    $0x8,%esp
  800765:	6a 00                	push   $0x0
  800767:	68 b0 25 80 00       	push   $0x8025b0
  80076c:	e8 f2 01 00 00       	call   800963 <vcprintf>
  800771:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800774:	e8 7d ff ff ff       	call   8006f6 <exit>

	// should not return here
	while (1) ;
  800779:	eb fe                	jmp    800779 <_panic+0x75>

0080077b <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80077b:	55                   	push   %ebp
  80077c:	89 e5                	mov    %esp,%ebp
  80077e:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800781:	a1 40 30 80 00       	mov    0x803040,%eax
  800786:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80078c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80078f:	39 c2                	cmp    %eax,%edx
  800791:	74 14                	je     8007a7 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800793:	83 ec 04             	sub    $0x4,%esp
  800796:	68 b4 25 80 00       	push   $0x8025b4
  80079b:	6a 26                	push   $0x26
  80079d:	68 00 26 80 00       	push   $0x802600
  8007a2:	e8 5d ff ff ff       	call   800704 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8007a7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8007ae:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8007b5:	e9 c5 00 00 00       	jmp    80087f <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8007ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007bd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c7:	01 d0                	add    %edx,%eax
  8007c9:	8b 00                	mov    (%eax),%eax
  8007cb:	85 c0                	test   %eax,%eax
  8007cd:	75 08                	jne    8007d7 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8007cf:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8007d2:	e9 a5 00 00 00       	jmp    80087c <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8007d7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8007de:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8007e5:	eb 69                	jmp    800850 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8007e7:	a1 40 30 80 00       	mov    0x803040,%eax
  8007ec:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8007f2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007f5:	89 d0                	mov    %edx,%eax
  8007f7:	01 c0                	add    %eax,%eax
  8007f9:	01 d0                	add    %edx,%eax
  8007fb:	c1 e0 03             	shl    $0x3,%eax
  8007fe:	01 c8                	add    %ecx,%eax
  800800:	8a 40 04             	mov    0x4(%eax),%al
  800803:	84 c0                	test   %al,%al
  800805:	75 46                	jne    80084d <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800807:	a1 40 30 80 00       	mov    0x803040,%eax
  80080c:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800812:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800815:	89 d0                	mov    %edx,%eax
  800817:	01 c0                	add    %eax,%eax
  800819:	01 d0                	add    %edx,%eax
  80081b:	c1 e0 03             	shl    $0x3,%eax
  80081e:	01 c8                	add    %ecx,%eax
  800820:	8b 00                	mov    (%eax),%eax
  800822:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800825:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800828:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80082d:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80082f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800832:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800839:	8b 45 08             	mov    0x8(%ebp),%eax
  80083c:	01 c8                	add    %ecx,%eax
  80083e:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800840:	39 c2                	cmp    %eax,%edx
  800842:	75 09                	jne    80084d <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800844:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80084b:	eb 15                	jmp    800862 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80084d:	ff 45 e8             	incl   -0x18(%ebp)
  800850:	a1 40 30 80 00       	mov    0x803040,%eax
  800855:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80085b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80085e:	39 c2                	cmp    %eax,%edx
  800860:	77 85                	ja     8007e7 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800862:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800866:	75 14                	jne    80087c <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800868:	83 ec 04             	sub    $0x4,%esp
  80086b:	68 0c 26 80 00       	push   $0x80260c
  800870:	6a 3a                	push   $0x3a
  800872:	68 00 26 80 00       	push   $0x802600
  800877:	e8 88 fe ff ff       	call   800704 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80087c:	ff 45 f0             	incl   -0x10(%ebp)
  80087f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800882:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800885:	0f 8c 2f ff ff ff    	jl     8007ba <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80088b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800892:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800899:	eb 26                	jmp    8008c1 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80089b:	a1 40 30 80 00       	mov    0x803040,%eax
  8008a0:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8008a6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008a9:	89 d0                	mov    %edx,%eax
  8008ab:	01 c0                	add    %eax,%eax
  8008ad:	01 d0                	add    %edx,%eax
  8008af:	c1 e0 03             	shl    $0x3,%eax
  8008b2:	01 c8                	add    %ecx,%eax
  8008b4:	8a 40 04             	mov    0x4(%eax),%al
  8008b7:	3c 01                	cmp    $0x1,%al
  8008b9:	75 03                	jne    8008be <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8008bb:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008be:	ff 45 e0             	incl   -0x20(%ebp)
  8008c1:	a1 40 30 80 00       	mov    0x803040,%eax
  8008c6:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8008cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008cf:	39 c2                	cmp    %eax,%edx
  8008d1:	77 c8                	ja     80089b <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8008d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008d6:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8008d9:	74 14                	je     8008ef <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8008db:	83 ec 04             	sub    $0x4,%esp
  8008de:	68 60 26 80 00       	push   $0x802660
  8008e3:	6a 44                	push   $0x44
  8008e5:	68 00 26 80 00       	push   $0x802600
  8008ea:	e8 15 fe ff ff       	call   800704 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8008ef:	90                   	nop
  8008f0:	c9                   	leave  
  8008f1:	c3                   	ret    

008008f2 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8008f2:	55                   	push   %ebp
  8008f3:	89 e5                	mov    %esp,%ebp
  8008f5:	53                   	push   %ebx
  8008f6:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8008f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008fc:	8b 00                	mov    (%eax),%eax
  8008fe:	8d 48 01             	lea    0x1(%eax),%ecx
  800901:	8b 55 0c             	mov    0xc(%ebp),%edx
  800904:	89 0a                	mov    %ecx,(%edx)
  800906:	8b 55 08             	mov    0x8(%ebp),%edx
  800909:	88 d1                	mov    %dl,%cl
  80090b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80090e:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800912:	8b 45 0c             	mov    0xc(%ebp),%eax
  800915:	8b 00                	mov    (%eax),%eax
  800917:	3d ff 00 00 00       	cmp    $0xff,%eax
  80091c:	75 30                	jne    80094e <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  80091e:	8b 15 3c b1 81 00    	mov    0x81b13c,%edx
  800924:	a0 64 30 80 00       	mov    0x803064,%al
  800929:	0f b6 c0             	movzbl %al,%eax
  80092c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80092f:	8b 09                	mov    (%ecx),%ecx
  800931:	89 cb                	mov    %ecx,%ebx
  800933:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800936:	83 c1 08             	add    $0x8,%ecx
  800939:	52                   	push   %edx
  80093a:	50                   	push   %eax
  80093b:	53                   	push   %ebx
  80093c:	51                   	push   %ecx
  80093d:	e8 a0 0f 00 00       	call   8018e2 <sys_cputs>
  800942:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800945:	8b 45 0c             	mov    0xc(%ebp),%eax
  800948:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80094e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800951:	8b 40 04             	mov    0x4(%eax),%eax
  800954:	8d 50 01             	lea    0x1(%eax),%edx
  800957:	8b 45 0c             	mov    0xc(%ebp),%eax
  80095a:	89 50 04             	mov    %edx,0x4(%eax)
}
  80095d:	90                   	nop
  80095e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800961:	c9                   	leave  
  800962:	c3                   	ret    

00800963 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800963:	55                   	push   %ebp
  800964:	89 e5                	mov    %esp,%ebp
  800966:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80096c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800973:	00 00 00 
	b.cnt = 0;
  800976:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80097d:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800980:	ff 75 0c             	pushl  0xc(%ebp)
  800983:	ff 75 08             	pushl  0x8(%ebp)
  800986:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80098c:	50                   	push   %eax
  80098d:	68 f2 08 80 00       	push   $0x8008f2
  800992:	e8 5a 02 00 00       	call   800bf1 <vprintfmt>
  800997:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  80099a:	8b 15 3c b1 81 00    	mov    0x81b13c,%edx
  8009a0:	a0 64 30 80 00       	mov    0x803064,%al
  8009a5:	0f b6 c0             	movzbl %al,%eax
  8009a8:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8009ae:	52                   	push   %edx
  8009af:	50                   	push   %eax
  8009b0:	51                   	push   %ecx
  8009b1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009b7:	83 c0 08             	add    $0x8,%eax
  8009ba:	50                   	push   %eax
  8009bb:	e8 22 0f 00 00       	call   8018e2 <sys_cputs>
  8009c0:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8009c3:	c6 05 64 30 80 00 00 	movb   $0x0,0x803064
	return b.cnt;
  8009ca:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8009d0:	c9                   	leave  
  8009d1:	c3                   	ret    

008009d2 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8009d2:	55                   	push   %ebp
  8009d3:	89 e5                	mov    %esp,%ebp
  8009d5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8009d8:	c6 05 64 30 80 00 01 	movb   $0x1,0x803064
	va_start(ap, fmt);
  8009df:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e8:	83 ec 08             	sub    $0x8,%esp
  8009eb:	ff 75 f4             	pushl  -0xc(%ebp)
  8009ee:	50                   	push   %eax
  8009ef:	e8 6f ff ff ff       	call   800963 <vcprintf>
  8009f4:	83 c4 10             	add    $0x10,%esp
  8009f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8009fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009fd:	c9                   	leave  
  8009fe:	c3                   	ret    

008009ff <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8009ff:	55                   	push   %ebp
  800a00:	89 e5                	mov    %esp,%ebp
  800a02:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a05:	c6 05 64 30 80 00 01 	movb   $0x1,0x803064
	curTextClr = (textClr << 8) ; //set text color by the given value
  800a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0f:	c1 e0 08             	shl    $0x8,%eax
  800a12:	a3 3c b1 81 00       	mov    %eax,0x81b13c
	va_start(ap, fmt);
  800a17:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a1a:	83 c0 04             	add    $0x4,%eax
  800a1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a20:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a23:	83 ec 08             	sub    $0x8,%esp
  800a26:	ff 75 f4             	pushl  -0xc(%ebp)
  800a29:	50                   	push   %eax
  800a2a:	e8 34 ff ff ff       	call   800963 <vcprintf>
  800a2f:	83 c4 10             	add    $0x10,%esp
  800a32:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800a35:	c7 05 3c b1 81 00 00 	movl   $0x700,0x81b13c
  800a3c:	07 00 00 

	return cnt;
  800a3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a42:	c9                   	leave  
  800a43:	c3                   	ret    

00800a44 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800a44:	55                   	push   %ebp
  800a45:	89 e5                	mov    %esp,%ebp
  800a47:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800a4a:	e8 d7 0e 00 00       	call   801926 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800a4f:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a52:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800a55:	8b 45 08             	mov    0x8(%ebp),%eax
  800a58:	83 ec 08             	sub    $0x8,%esp
  800a5b:	ff 75 f4             	pushl  -0xc(%ebp)
  800a5e:	50                   	push   %eax
  800a5f:	e8 ff fe ff ff       	call   800963 <vcprintf>
  800a64:	83 c4 10             	add    $0x10,%esp
  800a67:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800a6a:	e8 d1 0e 00 00       	call   801940 <sys_unlock_cons>
	return cnt;
  800a6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a72:	c9                   	leave  
  800a73:	c3                   	ret    

00800a74 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a74:	55                   	push   %ebp
  800a75:	89 e5                	mov    %esp,%ebp
  800a77:	53                   	push   %ebx
  800a78:	83 ec 14             	sub    $0x14,%esp
  800a7b:	8b 45 10             	mov    0x10(%ebp),%eax
  800a7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a81:	8b 45 14             	mov    0x14(%ebp),%eax
  800a84:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a87:	8b 45 18             	mov    0x18(%ebp),%eax
  800a8a:	ba 00 00 00 00       	mov    $0x0,%edx
  800a8f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a92:	77 55                	ja     800ae9 <printnum+0x75>
  800a94:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a97:	72 05                	jb     800a9e <printnum+0x2a>
  800a99:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a9c:	77 4b                	ja     800ae9 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a9e:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800aa1:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800aa4:	8b 45 18             	mov    0x18(%ebp),%eax
  800aa7:	ba 00 00 00 00       	mov    $0x0,%edx
  800aac:	52                   	push   %edx
  800aad:	50                   	push   %eax
  800aae:	ff 75 f4             	pushl  -0xc(%ebp)
  800ab1:	ff 75 f0             	pushl  -0x10(%ebp)
  800ab4:	e8 ab 13 00 00       	call   801e64 <__udivdi3>
  800ab9:	83 c4 10             	add    $0x10,%esp
  800abc:	83 ec 04             	sub    $0x4,%esp
  800abf:	ff 75 20             	pushl  0x20(%ebp)
  800ac2:	53                   	push   %ebx
  800ac3:	ff 75 18             	pushl  0x18(%ebp)
  800ac6:	52                   	push   %edx
  800ac7:	50                   	push   %eax
  800ac8:	ff 75 0c             	pushl  0xc(%ebp)
  800acb:	ff 75 08             	pushl  0x8(%ebp)
  800ace:	e8 a1 ff ff ff       	call   800a74 <printnum>
  800ad3:	83 c4 20             	add    $0x20,%esp
  800ad6:	eb 1a                	jmp    800af2 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800ad8:	83 ec 08             	sub    $0x8,%esp
  800adb:	ff 75 0c             	pushl  0xc(%ebp)
  800ade:	ff 75 20             	pushl  0x20(%ebp)
  800ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae4:	ff d0                	call   *%eax
  800ae6:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800ae9:	ff 4d 1c             	decl   0x1c(%ebp)
  800aec:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800af0:	7f e6                	jg     800ad8 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800af2:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800af5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800afa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800afd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b00:	53                   	push   %ebx
  800b01:	51                   	push   %ecx
  800b02:	52                   	push   %edx
  800b03:	50                   	push   %eax
  800b04:	e8 6b 14 00 00       	call   801f74 <__umoddi3>
  800b09:	83 c4 10             	add    $0x10,%esp
  800b0c:	05 d4 28 80 00       	add    $0x8028d4,%eax
  800b11:	8a 00                	mov    (%eax),%al
  800b13:	0f be c0             	movsbl %al,%eax
  800b16:	83 ec 08             	sub    $0x8,%esp
  800b19:	ff 75 0c             	pushl  0xc(%ebp)
  800b1c:	50                   	push   %eax
  800b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b20:	ff d0                	call   *%eax
  800b22:	83 c4 10             	add    $0x10,%esp
}
  800b25:	90                   	nop
  800b26:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b29:	c9                   	leave  
  800b2a:	c3                   	ret    

00800b2b <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b2b:	55                   	push   %ebp
  800b2c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b2e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b32:	7e 1c                	jle    800b50 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800b34:	8b 45 08             	mov    0x8(%ebp),%eax
  800b37:	8b 00                	mov    (%eax),%eax
  800b39:	8d 50 08             	lea    0x8(%eax),%edx
  800b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3f:	89 10                	mov    %edx,(%eax)
  800b41:	8b 45 08             	mov    0x8(%ebp),%eax
  800b44:	8b 00                	mov    (%eax),%eax
  800b46:	83 e8 08             	sub    $0x8,%eax
  800b49:	8b 50 04             	mov    0x4(%eax),%edx
  800b4c:	8b 00                	mov    (%eax),%eax
  800b4e:	eb 40                	jmp    800b90 <getuint+0x65>
	else if (lflag)
  800b50:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b54:	74 1e                	je     800b74 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800b56:	8b 45 08             	mov    0x8(%ebp),%eax
  800b59:	8b 00                	mov    (%eax),%eax
  800b5b:	8d 50 04             	lea    0x4(%eax),%edx
  800b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b61:	89 10                	mov    %edx,(%eax)
  800b63:	8b 45 08             	mov    0x8(%ebp),%eax
  800b66:	8b 00                	mov    (%eax),%eax
  800b68:	83 e8 04             	sub    $0x4,%eax
  800b6b:	8b 00                	mov    (%eax),%eax
  800b6d:	ba 00 00 00 00       	mov    $0x0,%edx
  800b72:	eb 1c                	jmp    800b90 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800b74:	8b 45 08             	mov    0x8(%ebp),%eax
  800b77:	8b 00                	mov    (%eax),%eax
  800b79:	8d 50 04             	lea    0x4(%eax),%edx
  800b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7f:	89 10                	mov    %edx,(%eax)
  800b81:	8b 45 08             	mov    0x8(%ebp),%eax
  800b84:	8b 00                	mov    (%eax),%eax
  800b86:	83 e8 04             	sub    $0x4,%eax
  800b89:	8b 00                	mov    (%eax),%eax
  800b8b:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800b90:	5d                   	pop    %ebp
  800b91:	c3                   	ret    

00800b92 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800b92:	55                   	push   %ebp
  800b93:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b95:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b99:	7e 1c                	jle    800bb7 <getint+0x25>
		return va_arg(*ap, long long);
  800b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9e:	8b 00                	mov    (%eax),%eax
  800ba0:	8d 50 08             	lea    0x8(%eax),%edx
  800ba3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba6:	89 10                	mov    %edx,(%eax)
  800ba8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bab:	8b 00                	mov    (%eax),%eax
  800bad:	83 e8 08             	sub    $0x8,%eax
  800bb0:	8b 50 04             	mov    0x4(%eax),%edx
  800bb3:	8b 00                	mov    (%eax),%eax
  800bb5:	eb 38                	jmp    800bef <getint+0x5d>
	else if (lflag)
  800bb7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bbb:	74 1a                	je     800bd7 <getint+0x45>
		return va_arg(*ap, long);
  800bbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc0:	8b 00                	mov    (%eax),%eax
  800bc2:	8d 50 04             	lea    0x4(%eax),%edx
  800bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc8:	89 10                	mov    %edx,(%eax)
  800bca:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcd:	8b 00                	mov    (%eax),%eax
  800bcf:	83 e8 04             	sub    $0x4,%eax
  800bd2:	8b 00                	mov    (%eax),%eax
  800bd4:	99                   	cltd   
  800bd5:	eb 18                	jmp    800bef <getint+0x5d>
	else
		return va_arg(*ap, int);
  800bd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bda:	8b 00                	mov    (%eax),%eax
  800bdc:	8d 50 04             	lea    0x4(%eax),%edx
  800bdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800be2:	89 10                	mov    %edx,(%eax)
  800be4:	8b 45 08             	mov    0x8(%ebp),%eax
  800be7:	8b 00                	mov    (%eax),%eax
  800be9:	83 e8 04             	sub    $0x4,%eax
  800bec:	8b 00                	mov    (%eax),%eax
  800bee:	99                   	cltd   
}
  800bef:	5d                   	pop    %ebp
  800bf0:	c3                   	ret    

00800bf1 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800bf1:	55                   	push   %ebp
  800bf2:	89 e5                	mov    %esp,%ebp
  800bf4:	56                   	push   %esi
  800bf5:	53                   	push   %ebx
  800bf6:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bf9:	eb 17                	jmp    800c12 <vprintfmt+0x21>
			if (ch == '\0')
  800bfb:	85 db                	test   %ebx,%ebx
  800bfd:	0f 84 c1 03 00 00    	je     800fc4 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800c03:	83 ec 08             	sub    $0x8,%esp
  800c06:	ff 75 0c             	pushl  0xc(%ebp)
  800c09:	53                   	push   %ebx
  800c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0d:	ff d0                	call   *%eax
  800c0f:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c12:	8b 45 10             	mov    0x10(%ebp),%eax
  800c15:	8d 50 01             	lea    0x1(%eax),%edx
  800c18:	89 55 10             	mov    %edx,0x10(%ebp)
  800c1b:	8a 00                	mov    (%eax),%al
  800c1d:	0f b6 d8             	movzbl %al,%ebx
  800c20:	83 fb 25             	cmp    $0x25,%ebx
  800c23:	75 d6                	jne    800bfb <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c25:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800c29:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800c30:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800c37:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800c3e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c45:	8b 45 10             	mov    0x10(%ebp),%eax
  800c48:	8d 50 01             	lea    0x1(%eax),%edx
  800c4b:	89 55 10             	mov    %edx,0x10(%ebp)
  800c4e:	8a 00                	mov    (%eax),%al
  800c50:	0f b6 d8             	movzbl %al,%ebx
  800c53:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800c56:	83 f8 5b             	cmp    $0x5b,%eax
  800c59:	0f 87 3d 03 00 00    	ja     800f9c <vprintfmt+0x3ab>
  800c5f:	8b 04 85 f8 28 80 00 	mov    0x8028f8(,%eax,4),%eax
  800c66:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c68:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800c6c:	eb d7                	jmp    800c45 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c6e:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800c72:	eb d1                	jmp    800c45 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c74:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800c7b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c7e:	89 d0                	mov    %edx,%eax
  800c80:	c1 e0 02             	shl    $0x2,%eax
  800c83:	01 d0                	add    %edx,%eax
  800c85:	01 c0                	add    %eax,%eax
  800c87:	01 d8                	add    %ebx,%eax
  800c89:	83 e8 30             	sub    $0x30,%eax
  800c8c:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800c8f:	8b 45 10             	mov    0x10(%ebp),%eax
  800c92:	8a 00                	mov    (%eax),%al
  800c94:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c97:	83 fb 2f             	cmp    $0x2f,%ebx
  800c9a:	7e 3e                	jle    800cda <vprintfmt+0xe9>
  800c9c:	83 fb 39             	cmp    $0x39,%ebx
  800c9f:	7f 39                	jg     800cda <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ca1:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ca4:	eb d5                	jmp    800c7b <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800ca6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ca9:	83 c0 04             	add    $0x4,%eax
  800cac:	89 45 14             	mov    %eax,0x14(%ebp)
  800caf:	8b 45 14             	mov    0x14(%ebp),%eax
  800cb2:	83 e8 04             	sub    $0x4,%eax
  800cb5:	8b 00                	mov    (%eax),%eax
  800cb7:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800cba:	eb 1f                	jmp    800cdb <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800cbc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cc0:	79 83                	jns    800c45 <vprintfmt+0x54>
				width = 0;
  800cc2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800cc9:	e9 77 ff ff ff       	jmp    800c45 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800cce:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800cd5:	e9 6b ff ff ff       	jmp    800c45 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800cda:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800cdb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cdf:	0f 89 60 ff ff ff    	jns    800c45 <vprintfmt+0x54>
				width = precision, precision = -1;
  800ce5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ce8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800ceb:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800cf2:	e9 4e ff ff ff       	jmp    800c45 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800cf7:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800cfa:	e9 46 ff ff ff       	jmp    800c45 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800cff:	8b 45 14             	mov    0x14(%ebp),%eax
  800d02:	83 c0 04             	add    $0x4,%eax
  800d05:	89 45 14             	mov    %eax,0x14(%ebp)
  800d08:	8b 45 14             	mov    0x14(%ebp),%eax
  800d0b:	83 e8 04             	sub    $0x4,%eax
  800d0e:	8b 00                	mov    (%eax),%eax
  800d10:	83 ec 08             	sub    $0x8,%esp
  800d13:	ff 75 0c             	pushl  0xc(%ebp)
  800d16:	50                   	push   %eax
  800d17:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1a:	ff d0                	call   *%eax
  800d1c:	83 c4 10             	add    $0x10,%esp
			break;
  800d1f:	e9 9b 02 00 00       	jmp    800fbf <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800d24:	8b 45 14             	mov    0x14(%ebp),%eax
  800d27:	83 c0 04             	add    $0x4,%eax
  800d2a:	89 45 14             	mov    %eax,0x14(%ebp)
  800d2d:	8b 45 14             	mov    0x14(%ebp),%eax
  800d30:	83 e8 04             	sub    $0x4,%eax
  800d33:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800d35:	85 db                	test   %ebx,%ebx
  800d37:	79 02                	jns    800d3b <vprintfmt+0x14a>
				err = -err;
  800d39:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800d3b:	83 fb 64             	cmp    $0x64,%ebx
  800d3e:	7f 0b                	jg     800d4b <vprintfmt+0x15a>
  800d40:	8b 34 9d 40 27 80 00 	mov    0x802740(,%ebx,4),%esi
  800d47:	85 f6                	test   %esi,%esi
  800d49:	75 19                	jne    800d64 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d4b:	53                   	push   %ebx
  800d4c:	68 e5 28 80 00       	push   $0x8028e5
  800d51:	ff 75 0c             	pushl  0xc(%ebp)
  800d54:	ff 75 08             	pushl  0x8(%ebp)
  800d57:	e8 70 02 00 00       	call   800fcc <printfmt>
  800d5c:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d5f:	e9 5b 02 00 00       	jmp    800fbf <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d64:	56                   	push   %esi
  800d65:	68 ee 28 80 00       	push   $0x8028ee
  800d6a:	ff 75 0c             	pushl  0xc(%ebp)
  800d6d:	ff 75 08             	pushl  0x8(%ebp)
  800d70:	e8 57 02 00 00       	call   800fcc <printfmt>
  800d75:	83 c4 10             	add    $0x10,%esp
			break;
  800d78:	e9 42 02 00 00       	jmp    800fbf <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800d7d:	8b 45 14             	mov    0x14(%ebp),%eax
  800d80:	83 c0 04             	add    $0x4,%eax
  800d83:	89 45 14             	mov    %eax,0x14(%ebp)
  800d86:	8b 45 14             	mov    0x14(%ebp),%eax
  800d89:	83 e8 04             	sub    $0x4,%eax
  800d8c:	8b 30                	mov    (%eax),%esi
  800d8e:	85 f6                	test   %esi,%esi
  800d90:	75 05                	jne    800d97 <vprintfmt+0x1a6>
				p = "(null)";
  800d92:	be f1 28 80 00       	mov    $0x8028f1,%esi
			if (width > 0 && padc != '-')
  800d97:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d9b:	7e 6d                	jle    800e0a <vprintfmt+0x219>
  800d9d:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800da1:	74 67                	je     800e0a <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800da3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800da6:	83 ec 08             	sub    $0x8,%esp
  800da9:	50                   	push   %eax
  800daa:	56                   	push   %esi
  800dab:	e8 1e 03 00 00       	call   8010ce <strnlen>
  800db0:	83 c4 10             	add    $0x10,%esp
  800db3:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800db6:	eb 16                	jmp    800dce <vprintfmt+0x1dd>
					putch(padc, putdat);
  800db8:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800dbc:	83 ec 08             	sub    $0x8,%esp
  800dbf:	ff 75 0c             	pushl  0xc(%ebp)
  800dc2:	50                   	push   %eax
  800dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc6:	ff d0                	call   *%eax
  800dc8:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800dcb:	ff 4d e4             	decl   -0x1c(%ebp)
  800dce:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dd2:	7f e4                	jg     800db8 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800dd4:	eb 34                	jmp    800e0a <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800dd6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800dda:	74 1c                	je     800df8 <vprintfmt+0x207>
  800ddc:	83 fb 1f             	cmp    $0x1f,%ebx
  800ddf:	7e 05                	jle    800de6 <vprintfmt+0x1f5>
  800de1:	83 fb 7e             	cmp    $0x7e,%ebx
  800de4:	7e 12                	jle    800df8 <vprintfmt+0x207>
					putch('?', putdat);
  800de6:	83 ec 08             	sub    $0x8,%esp
  800de9:	ff 75 0c             	pushl  0xc(%ebp)
  800dec:	6a 3f                	push   $0x3f
  800dee:	8b 45 08             	mov    0x8(%ebp),%eax
  800df1:	ff d0                	call   *%eax
  800df3:	83 c4 10             	add    $0x10,%esp
  800df6:	eb 0f                	jmp    800e07 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800df8:	83 ec 08             	sub    $0x8,%esp
  800dfb:	ff 75 0c             	pushl  0xc(%ebp)
  800dfe:	53                   	push   %ebx
  800dff:	8b 45 08             	mov    0x8(%ebp),%eax
  800e02:	ff d0                	call   *%eax
  800e04:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e07:	ff 4d e4             	decl   -0x1c(%ebp)
  800e0a:	89 f0                	mov    %esi,%eax
  800e0c:	8d 70 01             	lea    0x1(%eax),%esi
  800e0f:	8a 00                	mov    (%eax),%al
  800e11:	0f be d8             	movsbl %al,%ebx
  800e14:	85 db                	test   %ebx,%ebx
  800e16:	74 24                	je     800e3c <vprintfmt+0x24b>
  800e18:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e1c:	78 b8                	js     800dd6 <vprintfmt+0x1e5>
  800e1e:	ff 4d e0             	decl   -0x20(%ebp)
  800e21:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e25:	79 af                	jns    800dd6 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e27:	eb 13                	jmp    800e3c <vprintfmt+0x24b>
				putch(' ', putdat);
  800e29:	83 ec 08             	sub    $0x8,%esp
  800e2c:	ff 75 0c             	pushl  0xc(%ebp)
  800e2f:	6a 20                	push   $0x20
  800e31:	8b 45 08             	mov    0x8(%ebp),%eax
  800e34:	ff d0                	call   *%eax
  800e36:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e39:	ff 4d e4             	decl   -0x1c(%ebp)
  800e3c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e40:	7f e7                	jg     800e29 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800e42:	e9 78 01 00 00       	jmp    800fbf <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e47:	83 ec 08             	sub    $0x8,%esp
  800e4a:	ff 75 e8             	pushl  -0x18(%ebp)
  800e4d:	8d 45 14             	lea    0x14(%ebp),%eax
  800e50:	50                   	push   %eax
  800e51:	e8 3c fd ff ff       	call   800b92 <getint>
  800e56:	83 c4 10             	add    $0x10,%esp
  800e59:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e5c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800e5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e62:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e65:	85 d2                	test   %edx,%edx
  800e67:	79 23                	jns    800e8c <vprintfmt+0x29b>
				putch('-', putdat);
  800e69:	83 ec 08             	sub    $0x8,%esp
  800e6c:	ff 75 0c             	pushl  0xc(%ebp)
  800e6f:	6a 2d                	push   $0x2d
  800e71:	8b 45 08             	mov    0x8(%ebp),%eax
  800e74:	ff d0                	call   *%eax
  800e76:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800e79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e7c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e7f:	f7 d8                	neg    %eax
  800e81:	83 d2 00             	adc    $0x0,%edx
  800e84:	f7 da                	neg    %edx
  800e86:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e89:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800e8c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e93:	e9 bc 00 00 00       	jmp    800f54 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800e98:	83 ec 08             	sub    $0x8,%esp
  800e9b:	ff 75 e8             	pushl  -0x18(%ebp)
  800e9e:	8d 45 14             	lea    0x14(%ebp),%eax
  800ea1:	50                   	push   %eax
  800ea2:	e8 84 fc ff ff       	call   800b2b <getuint>
  800ea7:	83 c4 10             	add    $0x10,%esp
  800eaa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ead:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800eb0:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800eb7:	e9 98 00 00 00       	jmp    800f54 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ebc:	83 ec 08             	sub    $0x8,%esp
  800ebf:	ff 75 0c             	pushl  0xc(%ebp)
  800ec2:	6a 58                	push   $0x58
  800ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec7:	ff d0                	call   *%eax
  800ec9:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ecc:	83 ec 08             	sub    $0x8,%esp
  800ecf:	ff 75 0c             	pushl  0xc(%ebp)
  800ed2:	6a 58                	push   $0x58
  800ed4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed7:	ff d0                	call   *%eax
  800ed9:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800edc:	83 ec 08             	sub    $0x8,%esp
  800edf:	ff 75 0c             	pushl  0xc(%ebp)
  800ee2:	6a 58                	push   $0x58
  800ee4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee7:	ff d0                	call   *%eax
  800ee9:	83 c4 10             	add    $0x10,%esp
			break;
  800eec:	e9 ce 00 00 00       	jmp    800fbf <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800ef1:	83 ec 08             	sub    $0x8,%esp
  800ef4:	ff 75 0c             	pushl  0xc(%ebp)
  800ef7:	6a 30                	push   $0x30
  800ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  800efc:	ff d0                	call   *%eax
  800efe:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800f01:	83 ec 08             	sub    $0x8,%esp
  800f04:	ff 75 0c             	pushl  0xc(%ebp)
  800f07:	6a 78                	push   $0x78
  800f09:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0c:	ff d0                	call   *%eax
  800f0e:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800f11:	8b 45 14             	mov    0x14(%ebp),%eax
  800f14:	83 c0 04             	add    $0x4,%eax
  800f17:	89 45 14             	mov    %eax,0x14(%ebp)
  800f1a:	8b 45 14             	mov    0x14(%ebp),%eax
  800f1d:	83 e8 04             	sub    $0x4,%eax
  800f20:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f22:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f25:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800f2c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800f33:	eb 1f                	jmp    800f54 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800f35:	83 ec 08             	sub    $0x8,%esp
  800f38:	ff 75 e8             	pushl  -0x18(%ebp)
  800f3b:	8d 45 14             	lea    0x14(%ebp),%eax
  800f3e:	50                   	push   %eax
  800f3f:	e8 e7 fb ff ff       	call   800b2b <getuint>
  800f44:	83 c4 10             	add    $0x10,%esp
  800f47:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f4a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800f4d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f54:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800f58:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f5b:	83 ec 04             	sub    $0x4,%esp
  800f5e:	52                   	push   %edx
  800f5f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f62:	50                   	push   %eax
  800f63:	ff 75 f4             	pushl  -0xc(%ebp)
  800f66:	ff 75 f0             	pushl  -0x10(%ebp)
  800f69:	ff 75 0c             	pushl  0xc(%ebp)
  800f6c:	ff 75 08             	pushl  0x8(%ebp)
  800f6f:	e8 00 fb ff ff       	call   800a74 <printnum>
  800f74:	83 c4 20             	add    $0x20,%esp
			break;
  800f77:	eb 46                	jmp    800fbf <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f79:	83 ec 08             	sub    $0x8,%esp
  800f7c:	ff 75 0c             	pushl  0xc(%ebp)
  800f7f:	53                   	push   %ebx
  800f80:	8b 45 08             	mov    0x8(%ebp),%eax
  800f83:	ff d0                	call   *%eax
  800f85:	83 c4 10             	add    $0x10,%esp
			break;
  800f88:	eb 35                	jmp    800fbf <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800f8a:	c6 05 64 30 80 00 00 	movb   $0x0,0x803064
			break;
  800f91:	eb 2c                	jmp    800fbf <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800f93:	c6 05 64 30 80 00 01 	movb   $0x1,0x803064
			break;
  800f9a:	eb 23                	jmp    800fbf <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f9c:	83 ec 08             	sub    $0x8,%esp
  800f9f:	ff 75 0c             	pushl  0xc(%ebp)
  800fa2:	6a 25                	push   $0x25
  800fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa7:	ff d0                	call   *%eax
  800fa9:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800fac:	ff 4d 10             	decl   0x10(%ebp)
  800faf:	eb 03                	jmp    800fb4 <vprintfmt+0x3c3>
  800fb1:	ff 4d 10             	decl   0x10(%ebp)
  800fb4:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb7:	48                   	dec    %eax
  800fb8:	8a 00                	mov    (%eax),%al
  800fba:	3c 25                	cmp    $0x25,%al
  800fbc:	75 f3                	jne    800fb1 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800fbe:	90                   	nop
		}
	}
  800fbf:	e9 35 fc ff ff       	jmp    800bf9 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800fc4:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800fc5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800fc8:	5b                   	pop    %ebx
  800fc9:	5e                   	pop    %esi
  800fca:	5d                   	pop    %ebp
  800fcb:	c3                   	ret    

00800fcc <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800fcc:	55                   	push   %ebp
  800fcd:	89 e5                	mov    %esp,%ebp
  800fcf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800fd2:	8d 45 10             	lea    0x10(%ebp),%eax
  800fd5:	83 c0 04             	add    $0x4,%eax
  800fd8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800fdb:	8b 45 10             	mov    0x10(%ebp),%eax
  800fde:	ff 75 f4             	pushl  -0xc(%ebp)
  800fe1:	50                   	push   %eax
  800fe2:	ff 75 0c             	pushl  0xc(%ebp)
  800fe5:	ff 75 08             	pushl  0x8(%ebp)
  800fe8:	e8 04 fc ff ff       	call   800bf1 <vprintfmt>
  800fed:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800ff0:	90                   	nop
  800ff1:	c9                   	leave  
  800ff2:	c3                   	ret    

00800ff3 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ff3:	55                   	push   %ebp
  800ff4:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800ff6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff9:	8b 40 08             	mov    0x8(%eax),%eax
  800ffc:	8d 50 01             	lea    0x1(%eax),%edx
  800fff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801002:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801005:	8b 45 0c             	mov    0xc(%ebp),%eax
  801008:	8b 10                	mov    (%eax),%edx
  80100a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80100d:	8b 40 04             	mov    0x4(%eax),%eax
  801010:	39 c2                	cmp    %eax,%edx
  801012:	73 12                	jae    801026 <sprintputch+0x33>
		*b->buf++ = ch;
  801014:	8b 45 0c             	mov    0xc(%ebp),%eax
  801017:	8b 00                	mov    (%eax),%eax
  801019:	8d 48 01             	lea    0x1(%eax),%ecx
  80101c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80101f:	89 0a                	mov    %ecx,(%edx)
  801021:	8b 55 08             	mov    0x8(%ebp),%edx
  801024:	88 10                	mov    %dl,(%eax)
}
  801026:	90                   	nop
  801027:	5d                   	pop    %ebp
  801028:	c3                   	ret    

00801029 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801029:	55                   	push   %ebp
  80102a:	89 e5                	mov    %esp,%ebp
  80102c:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80102f:	8b 45 08             	mov    0x8(%ebp),%eax
  801032:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801035:	8b 45 0c             	mov    0xc(%ebp),%eax
  801038:	8d 50 ff             	lea    -0x1(%eax),%edx
  80103b:	8b 45 08             	mov    0x8(%ebp),%eax
  80103e:	01 d0                	add    %edx,%eax
  801040:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801043:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80104a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80104e:	74 06                	je     801056 <vsnprintf+0x2d>
  801050:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801054:	7f 07                	jg     80105d <vsnprintf+0x34>
		return -E_INVAL;
  801056:	b8 03 00 00 00       	mov    $0x3,%eax
  80105b:	eb 20                	jmp    80107d <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80105d:	ff 75 14             	pushl  0x14(%ebp)
  801060:	ff 75 10             	pushl  0x10(%ebp)
  801063:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801066:	50                   	push   %eax
  801067:	68 f3 0f 80 00       	push   $0x800ff3
  80106c:	e8 80 fb ff ff       	call   800bf1 <vprintfmt>
  801071:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801074:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801077:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80107a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80107d:	c9                   	leave  
  80107e:	c3                   	ret    

0080107f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80107f:	55                   	push   %ebp
  801080:	89 e5                	mov    %esp,%ebp
  801082:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801085:	8d 45 10             	lea    0x10(%ebp),%eax
  801088:	83 c0 04             	add    $0x4,%eax
  80108b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80108e:	8b 45 10             	mov    0x10(%ebp),%eax
  801091:	ff 75 f4             	pushl  -0xc(%ebp)
  801094:	50                   	push   %eax
  801095:	ff 75 0c             	pushl  0xc(%ebp)
  801098:	ff 75 08             	pushl  0x8(%ebp)
  80109b:	e8 89 ff ff ff       	call   801029 <vsnprintf>
  8010a0:	83 c4 10             	add    $0x10,%esp
  8010a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8010a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8010a9:	c9                   	leave  
  8010aa:	c3                   	ret    

008010ab <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8010ab:	55                   	push   %ebp
  8010ac:	89 e5                	mov    %esp,%ebp
  8010ae:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8010b1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010b8:	eb 06                	jmp    8010c0 <strlen+0x15>
		n++;
  8010ba:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8010bd:	ff 45 08             	incl   0x8(%ebp)
  8010c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c3:	8a 00                	mov    (%eax),%al
  8010c5:	84 c0                	test   %al,%al
  8010c7:	75 f1                	jne    8010ba <strlen+0xf>
		n++;
	return n;
  8010c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010cc:	c9                   	leave  
  8010cd:	c3                   	ret    

008010ce <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8010ce:	55                   	push   %ebp
  8010cf:	89 e5                	mov    %esp,%ebp
  8010d1:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010d4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010db:	eb 09                	jmp    8010e6 <strnlen+0x18>
		n++;
  8010dd:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010e0:	ff 45 08             	incl   0x8(%ebp)
  8010e3:	ff 4d 0c             	decl   0xc(%ebp)
  8010e6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010ea:	74 09                	je     8010f5 <strnlen+0x27>
  8010ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ef:	8a 00                	mov    (%eax),%al
  8010f1:	84 c0                	test   %al,%al
  8010f3:	75 e8                	jne    8010dd <strnlen+0xf>
		n++;
	return n;
  8010f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010f8:	c9                   	leave  
  8010f9:	c3                   	ret    

008010fa <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8010fa:	55                   	push   %ebp
  8010fb:	89 e5                	mov    %esp,%ebp
  8010fd:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801100:	8b 45 08             	mov    0x8(%ebp),%eax
  801103:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801106:	90                   	nop
  801107:	8b 45 08             	mov    0x8(%ebp),%eax
  80110a:	8d 50 01             	lea    0x1(%eax),%edx
  80110d:	89 55 08             	mov    %edx,0x8(%ebp)
  801110:	8b 55 0c             	mov    0xc(%ebp),%edx
  801113:	8d 4a 01             	lea    0x1(%edx),%ecx
  801116:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801119:	8a 12                	mov    (%edx),%dl
  80111b:	88 10                	mov    %dl,(%eax)
  80111d:	8a 00                	mov    (%eax),%al
  80111f:	84 c0                	test   %al,%al
  801121:	75 e4                	jne    801107 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801123:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801126:	c9                   	leave  
  801127:	c3                   	ret    

00801128 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801128:	55                   	push   %ebp
  801129:	89 e5                	mov    %esp,%ebp
  80112b:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80112e:	8b 45 08             	mov    0x8(%ebp),%eax
  801131:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801134:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80113b:	eb 1f                	jmp    80115c <strncpy+0x34>
		*dst++ = *src;
  80113d:	8b 45 08             	mov    0x8(%ebp),%eax
  801140:	8d 50 01             	lea    0x1(%eax),%edx
  801143:	89 55 08             	mov    %edx,0x8(%ebp)
  801146:	8b 55 0c             	mov    0xc(%ebp),%edx
  801149:	8a 12                	mov    (%edx),%dl
  80114b:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80114d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801150:	8a 00                	mov    (%eax),%al
  801152:	84 c0                	test   %al,%al
  801154:	74 03                	je     801159 <strncpy+0x31>
			src++;
  801156:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801159:	ff 45 fc             	incl   -0x4(%ebp)
  80115c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80115f:	3b 45 10             	cmp    0x10(%ebp),%eax
  801162:	72 d9                	jb     80113d <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801164:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801167:	c9                   	leave  
  801168:	c3                   	ret    

00801169 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801169:	55                   	push   %ebp
  80116a:	89 e5                	mov    %esp,%ebp
  80116c:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80116f:	8b 45 08             	mov    0x8(%ebp),%eax
  801172:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801175:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801179:	74 30                	je     8011ab <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80117b:	eb 16                	jmp    801193 <strlcpy+0x2a>
			*dst++ = *src++;
  80117d:	8b 45 08             	mov    0x8(%ebp),%eax
  801180:	8d 50 01             	lea    0x1(%eax),%edx
  801183:	89 55 08             	mov    %edx,0x8(%ebp)
  801186:	8b 55 0c             	mov    0xc(%ebp),%edx
  801189:	8d 4a 01             	lea    0x1(%edx),%ecx
  80118c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80118f:	8a 12                	mov    (%edx),%dl
  801191:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801193:	ff 4d 10             	decl   0x10(%ebp)
  801196:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80119a:	74 09                	je     8011a5 <strlcpy+0x3c>
  80119c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119f:	8a 00                	mov    (%eax),%al
  8011a1:	84 c0                	test   %al,%al
  8011a3:	75 d8                	jne    80117d <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8011a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a8:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8011ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8011ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011b1:	29 c2                	sub    %eax,%edx
  8011b3:	89 d0                	mov    %edx,%eax
}
  8011b5:	c9                   	leave  
  8011b6:	c3                   	ret    

008011b7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8011b7:	55                   	push   %ebp
  8011b8:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8011ba:	eb 06                	jmp    8011c2 <strcmp+0xb>
		p++, q++;
  8011bc:	ff 45 08             	incl   0x8(%ebp)
  8011bf:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8011c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c5:	8a 00                	mov    (%eax),%al
  8011c7:	84 c0                	test   %al,%al
  8011c9:	74 0e                	je     8011d9 <strcmp+0x22>
  8011cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ce:	8a 10                	mov    (%eax),%dl
  8011d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d3:	8a 00                	mov    (%eax),%al
  8011d5:	38 c2                	cmp    %al,%dl
  8011d7:	74 e3                	je     8011bc <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8011d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011dc:	8a 00                	mov    (%eax),%al
  8011de:	0f b6 d0             	movzbl %al,%edx
  8011e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e4:	8a 00                	mov    (%eax),%al
  8011e6:	0f b6 c0             	movzbl %al,%eax
  8011e9:	29 c2                	sub    %eax,%edx
  8011eb:	89 d0                	mov    %edx,%eax
}
  8011ed:	5d                   	pop    %ebp
  8011ee:	c3                   	ret    

008011ef <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8011ef:	55                   	push   %ebp
  8011f0:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8011f2:	eb 09                	jmp    8011fd <strncmp+0xe>
		n--, p++, q++;
  8011f4:	ff 4d 10             	decl   0x10(%ebp)
  8011f7:	ff 45 08             	incl   0x8(%ebp)
  8011fa:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8011fd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801201:	74 17                	je     80121a <strncmp+0x2b>
  801203:	8b 45 08             	mov    0x8(%ebp),%eax
  801206:	8a 00                	mov    (%eax),%al
  801208:	84 c0                	test   %al,%al
  80120a:	74 0e                	je     80121a <strncmp+0x2b>
  80120c:	8b 45 08             	mov    0x8(%ebp),%eax
  80120f:	8a 10                	mov    (%eax),%dl
  801211:	8b 45 0c             	mov    0xc(%ebp),%eax
  801214:	8a 00                	mov    (%eax),%al
  801216:	38 c2                	cmp    %al,%dl
  801218:	74 da                	je     8011f4 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80121a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80121e:	75 07                	jne    801227 <strncmp+0x38>
		return 0;
  801220:	b8 00 00 00 00       	mov    $0x0,%eax
  801225:	eb 14                	jmp    80123b <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801227:	8b 45 08             	mov    0x8(%ebp),%eax
  80122a:	8a 00                	mov    (%eax),%al
  80122c:	0f b6 d0             	movzbl %al,%edx
  80122f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801232:	8a 00                	mov    (%eax),%al
  801234:	0f b6 c0             	movzbl %al,%eax
  801237:	29 c2                	sub    %eax,%edx
  801239:	89 d0                	mov    %edx,%eax
}
  80123b:	5d                   	pop    %ebp
  80123c:	c3                   	ret    

0080123d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80123d:	55                   	push   %ebp
  80123e:	89 e5                	mov    %esp,%ebp
  801240:	83 ec 04             	sub    $0x4,%esp
  801243:	8b 45 0c             	mov    0xc(%ebp),%eax
  801246:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801249:	eb 12                	jmp    80125d <strchr+0x20>
		if (*s == c)
  80124b:	8b 45 08             	mov    0x8(%ebp),%eax
  80124e:	8a 00                	mov    (%eax),%al
  801250:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801253:	75 05                	jne    80125a <strchr+0x1d>
			return (char *) s;
  801255:	8b 45 08             	mov    0x8(%ebp),%eax
  801258:	eb 11                	jmp    80126b <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80125a:	ff 45 08             	incl   0x8(%ebp)
  80125d:	8b 45 08             	mov    0x8(%ebp),%eax
  801260:	8a 00                	mov    (%eax),%al
  801262:	84 c0                	test   %al,%al
  801264:	75 e5                	jne    80124b <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801266:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80126b:	c9                   	leave  
  80126c:	c3                   	ret    

0080126d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80126d:	55                   	push   %ebp
  80126e:	89 e5                	mov    %esp,%ebp
  801270:	83 ec 04             	sub    $0x4,%esp
  801273:	8b 45 0c             	mov    0xc(%ebp),%eax
  801276:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801279:	eb 0d                	jmp    801288 <strfind+0x1b>
		if (*s == c)
  80127b:	8b 45 08             	mov    0x8(%ebp),%eax
  80127e:	8a 00                	mov    (%eax),%al
  801280:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801283:	74 0e                	je     801293 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801285:	ff 45 08             	incl   0x8(%ebp)
  801288:	8b 45 08             	mov    0x8(%ebp),%eax
  80128b:	8a 00                	mov    (%eax),%al
  80128d:	84 c0                	test   %al,%al
  80128f:	75 ea                	jne    80127b <strfind+0xe>
  801291:	eb 01                	jmp    801294 <strfind+0x27>
		if (*s == c)
			break;
  801293:	90                   	nop
	return (char *) s;
  801294:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801297:	c9                   	leave  
  801298:	c3                   	ret    

00801299 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801299:	55                   	push   %ebp
  80129a:	89 e5                	mov    %esp,%ebp
  80129c:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  80129f:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  8012a5:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8012a9:	76 63                	jbe    80130e <memset+0x75>
		uint64 data_block = c;
  8012ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ae:	99                   	cltd   
  8012af:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8012b2:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  8012b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012bb:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  8012bf:	c1 e0 08             	shl    $0x8,%eax
  8012c2:	09 45 f0             	or     %eax,-0x10(%ebp)
  8012c5:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  8012c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012ce:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  8012d2:	c1 e0 10             	shl    $0x10,%eax
  8012d5:	09 45 f0             	or     %eax,-0x10(%ebp)
  8012d8:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  8012db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012e1:	89 c2                	mov    %eax,%edx
  8012e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8012e8:	09 45 f0             	or     %eax,-0x10(%ebp)
  8012eb:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  8012ee:	eb 18                	jmp    801308 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  8012f0:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012f3:	8d 41 08             	lea    0x8(%ecx),%eax
  8012f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8012f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012ff:	89 01                	mov    %eax,(%ecx)
  801301:	89 51 04             	mov    %edx,0x4(%ecx)
  801304:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801308:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80130c:	77 e2                	ja     8012f0 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  80130e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801312:	74 23                	je     801337 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801314:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801317:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  80131a:	eb 0e                	jmp    80132a <memset+0x91>
			*p8++ = (uint8)c;
  80131c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80131f:	8d 50 01             	lea    0x1(%eax),%edx
  801322:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801325:	8b 55 0c             	mov    0xc(%ebp),%edx
  801328:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  80132a:	8b 45 10             	mov    0x10(%ebp),%eax
  80132d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801330:	89 55 10             	mov    %edx,0x10(%ebp)
  801333:	85 c0                	test   %eax,%eax
  801335:	75 e5                	jne    80131c <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801337:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80133a:	c9                   	leave  
  80133b:	c3                   	ret    

0080133c <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80133c:	55                   	push   %ebp
  80133d:	89 e5                	mov    %esp,%ebp
  80133f:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801342:	8b 45 0c             	mov    0xc(%ebp),%eax
  801345:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801348:	8b 45 08             	mov    0x8(%ebp),%eax
  80134b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  80134e:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801352:	76 24                	jbe    801378 <memcpy+0x3c>
		while(n >= 8){
  801354:	eb 1c                	jmp    801372 <memcpy+0x36>
			*d64 = *s64;
  801356:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801359:	8b 50 04             	mov    0x4(%eax),%edx
  80135c:	8b 00                	mov    (%eax),%eax
  80135e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801361:	89 01                	mov    %eax,(%ecx)
  801363:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801366:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  80136a:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  80136e:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801372:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801376:	77 de                	ja     801356 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801378:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80137c:	74 31                	je     8013af <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  80137e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801381:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801384:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801387:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  80138a:	eb 16                	jmp    8013a2 <memcpy+0x66>
			*d8++ = *s8++;
  80138c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80138f:	8d 50 01             	lea    0x1(%eax),%edx
  801392:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801395:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801398:	8d 4a 01             	lea    0x1(%edx),%ecx
  80139b:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80139e:	8a 12                	mov    (%edx),%dl
  8013a0:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  8013a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8013a5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013a8:	89 55 10             	mov    %edx,0x10(%ebp)
  8013ab:	85 c0                	test   %eax,%eax
  8013ad:	75 dd                	jne    80138c <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  8013af:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013b2:	c9                   	leave  
  8013b3:	c3                   	ret    

008013b4 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8013b4:	55                   	push   %ebp
  8013b5:	89 e5                	mov    %esp,%ebp
  8013b7:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8013ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013bd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8013c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8013c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013c9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8013cc:	73 50                	jae    80141e <memmove+0x6a>
  8013ce:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8013d4:	01 d0                	add    %edx,%eax
  8013d6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8013d9:	76 43                	jbe    80141e <memmove+0x6a>
		s += n;
  8013db:	8b 45 10             	mov    0x10(%ebp),%eax
  8013de:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8013e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e4:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8013e7:	eb 10                	jmp    8013f9 <memmove+0x45>
			*--d = *--s;
  8013e9:	ff 4d f8             	decl   -0x8(%ebp)
  8013ec:	ff 4d fc             	decl   -0x4(%ebp)
  8013ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013f2:	8a 10                	mov    (%eax),%dl
  8013f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013f7:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8013f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8013fc:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013ff:	89 55 10             	mov    %edx,0x10(%ebp)
  801402:	85 c0                	test   %eax,%eax
  801404:	75 e3                	jne    8013e9 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801406:	eb 23                	jmp    80142b <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801408:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80140b:	8d 50 01             	lea    0x1(%eax),%edx
  80140e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801411:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801414:	8d 4a 01             	lea    0x1(%edx),%ecx
  801417:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80141a:	8a 12                	mov    (%edx),%dl
  80141c:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80141e:	8b 45 10             	mov    0x10(%ebp),%eax
  801421:	8d 50 ff             	lea    -0x1(%eax),%edx
  801424:	89 55 10             	mov    %edx,0x10(%ebp)
  801427:	85 c0                	test   %eax,%eax
  801429:	75 dd                	jne    801408 <memmove+0x54>
			*d++ = *s++;

	return dst;
  80142b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80142e:	c9                   	leave  
  80142f:	c3                   	ret    

00801430 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801430:	55                   	push   %ebp
  801431:	89 e5                	mov    %esp,%ebp
  801433:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801436:	8b 45 08             	mov    0x8(%ebp),%eax
  801439:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80143c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80143f:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801442:	eb 2a                	jmp    80146e <memcmp+0x3e>
		if (*s1 != *s2)
  801444:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801447:	8a 10                	mov    (%eax),%dl
  801449:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80144c:	8a 00                	mov    (%eax),%al
  80144e:	38 c2                	cmp    %al,%dl
  801450:	74 16                	je     801468 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801452:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801455:	8a 00                	mov    (%eax),%al
  801457:	0f b6 d0             	movzbl %al,%edx
  80145a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80145d:	8a 00                	mov    (%eax),%al
  80145f:	0f b6 c0             	movzbl %al,%eax
  801462:	29 c2                	sub    %eax,%edx
  801464:	89 d0                	mov    %edx,%eax
  801466:	eb 18                	jmp    801480 <memcmp+0x50>
		s1++, s2++;
  801468:	ff 45 fc             	incl   -0x4(%ebp)
  80146b:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80146e:	8b 45 10             	mov    0x10(%ebp),%eax
  801471:	8d 50 ff             	lea    -0x1(%eax),%edx
  801474:	89 55 10             	mov    %edx,0x10(%ebp)
  801477:	85 c0                	test   %eax,%eax
  801479:	75 c9                	jne    801444 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80147b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801480:	c9                   	leave  
  801481:	c3                   	ret    

00801482 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801482:	55                   	push   %ebp
  801483:	89 e5                	mov    %esp,%ebp
  801485:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801488:	8b 55 08             	mov    0x8(%ebp),%edx
  80148b:	8b 45 10             	mov    0x10(%ebp),%eax
  80148e:	01 d0                	add    %edx,%eax
  801490:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801493:	eb 15                	jmp    8014aa <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801495:	8b 45 08             	mov    0x8(%ebp),%eax
  801498:	8a 00                	mov    (%eax),%al
  80149a:	0f b6 d0             	movzbl %al,%edx
  80149d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a0:	0f b6 c0             	movzbl %al,%eax
  8014a3:	39 c2                	cmp    %eax,%edx
  8014a5:	74 0d                	je     8014b4 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8014a7:	ff 45 08             	incl   0x8(%ebp)
  8014aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ad:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8014b0:	72 e3                	jb     801495 <memfind+0x13>
  8014b2:	eb 01                	jmp    8014b5 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8014b4:	90                   	nop
	return (void *) s;
  8014b5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014b8:	c9                   	leave  
  8014b9:	c3                   	ret    

008014ba <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8014ba:	55                   	push   %ebp
  8014bb:	89 e5                	mov    %esp,%ebp
  8014bd:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8014c0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8014c7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8014ce:	eb 03                	jmp    8014d3 <strtol+0x19>
		s++;
  8014d0:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8014d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d6:	8a 00                	mov    (%eax),%al
  8014d8:	3c 20                	cmp    $0x20,%al
  8014da:	74 f4                	je     8014d0 <strtol+0x16>
  8014dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014df:	8a 00                	mov    (%eax),%al
  8014e1:	3c 09                	cmp    $0x9,%al
  8014e3:	74 eb                	je     8014d0 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8014e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e8:	8a 00                	mov    (%eax),%al
  8014ea:	3c 2b                	cmp    $0x2b,%al
  8014ec:	75 05                	jne    8014f3 <strtol+0x39>
		s++;
  8014ee:	ff 45 08             	incl   0x8(%ebp)
  8014f1:	eb 13                	jmp    801506 <strtol+0x4c>
	else if (*s == '-')
  8014f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f6:	8a 00                	mov    (%eax),%al
  8014f8:	3c 2d                	cmp    $0x2d,%al
  8014fa:	75 0a                	jne    801506 <strtol+0x4c>
		s++, neg = 1;
  8014fc:	ff 45 08             	incl   0x8(%ebp)
  8014ff:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801506:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80150a:	74 06                	je     801512 <strtol+0x58>
  80150c:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801510:	75 20                	jne    801532 <strtol+0x78>
  801512:	8b 45 08             	mov    0x8(%ebp),%eax
  801515:	8a 00                	mov    (%eax),%al
  801517:	3c 30                	cmp    $0x30,%al
  801519:	75 17                	jne    801532 <strtol+0x78>
  80151b:	8b 45 08             	mov    0x8(%ebp),%eax
  80151e:	40                   	inc    %eax
  80151f:	8a 00                	mov    (%eax),%al
  801521:	3c 78                	cmp    $0x78,%al
  801523:	75 0d                	jne    801532 <strtol+0x78>
		s += 2, base = 16;
  801525:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801529:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801530:	eb 28                	jmp    80155a <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801532:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801536:	75 15                	jne    80154d <strtol+0x93>
  801538:	8b 45 08             	mov    0x8(%ebp),%eax
  80153b:	8a 00                	mov    (%eax),%al
  80153d:	3c 30                	cmp    $0x30,%al
  80153f:	75 0c                	jne    80154d <strtol+0x93>
		s++, base = 8;
  801541:	ff 45 08             	incl   0x8(%ebp)
  801544:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80154b:	eb 0d                	jmp    80155a <strtol+0xa0>
	else if (base == 0)
  80154d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801551:	75 07                	jne    80155a <strtol+0xa0>
		base = 10;
  801553:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80155a:	8b 45 08             	mov    0x8(%ebp),%eax
  80155d:	8a 00                	mov    (%eax),%al
  80155f:	3c 2f                	cmp    $0x2f,%al
  801561:	7e 19                	jle    80157c <strtol+0xc2>
  801563:	8b 45 08             	mov    0x8(%ebp),%eax
  801566:	8a 00                	mov    (%eax),%al
  801568:	3c 39                	cmp    $0x39,%al
  80156a:	7f 10                	jg     80157c <strtol+0xc2>
			dig = *s - '0';
  80156c:	8b 45 08             	mov    0x8(%ebp),%eax
  80156f:	8a 00                	mov    (%eax),%al
  801571:	0f be c0             	movsbl %al,%eax
  801574:	83 e8 30             	sub    $0x30,%eax
  801577:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80157a:	eb 42                	jmp    8015be <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80157c:	8b 45 08             	mov    0x8(%ebp),%eax
  80157f:	8a 00                	mov    (%eax),%al
  801581:	3c 60                	cmp    $0x60,%al
  801583:	7e 19                	jle    80159e <strtol+0xe4>
  801585:	8b 45 08             	mov    0x8(%ebp),%eax
  801588:	8a 00                	mov    (%eax),%al
  80158a:	3c 7a                	cmp    $0x7a,%al
  80158c:	7f 10                	jg     80159e <strtol+0xe4>
			dig = *s - 'a' + 10;
  80158e:	8b 45 08             	mov    0x8(%ebp),%eax
  801591:	8a 00                	mov    (%eax),%al
  801593:	0f be c0             	movsbl %al,%eax
  801596:	83 e8 57             	sub    $0x57,%eax
  801599:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80159c:	eb 20                	jmp    8015be <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80159e:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a1:	8a 00                	mov    (%eax),%al
  8015a3:	3c 40                	cmp    $0x40,%al
  8015a5:	7e 39                	jle    8015e0 <strtol+0x126>
  8015a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015aa:	8a 00                	mov    (%eax),%al
  8015ac:	3c 5a                	cmp    $0x5a,%al
  8015ae:	7f 30                	jg     8015e0 <strtol+0x126>
			dig = *s - 'A' + 10;
  8015b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b3:	8a 00                	mov    (%eax),%al
  8015b5:	0f be c0             	movsbl %al,%eax
  8015b8:	83 e8 37             	sub    $0x37,%eax
  8015bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8015be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015c1:	3b 45 10             	cmp    0x10(%ebp),%eax
  8015c4:	7d 19                	jge    8015df <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8015c6:	ff 45 08             	incl   0x8(%ebp)
  8015c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015cc:	0f af 45 10          	imul   0x10(%ebp),%eax
  8015d0:	89 c2                	mov    %eax,%edx
  8015d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015d5:	01 d0                	add    %edx,%eax
  8015d7:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8015da:	e9 7b ff ff ff       	jmp    80155a <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8015df:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8015e0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015e4:	74 08                	je     8015ee <strtol+0x134>
		*endptr = (char *) s;
  8015e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8015ec:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8015ee:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8015f2:	74 07                	je     8015fb <strtol+0x141>
  8015f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015f7:	f7 d8                	neg    %eax
  8015f9:	eb 03                	jmp    8015fe <strtol+0x144>
  8015fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8015fe:	c9                   	leave  
  8015ff:	c3                   	ret    

00801600 <ltostr>:

void
ltostr(long value, char *str)
{
  801600:	55                   	push   %ebp
  801601:	89 e5                	mov    %esp,%ebp
  801603:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801606:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80160d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801614:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801618:	79 13                	jns    80162d <ltostr+0x2d>
	{
		neg = 1;
  80161a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801621:	8b 45 0c             	mov    0xc(%ebp),%eax
  801624:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801627:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80162a:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80162d:	8b 45 08             	mov    0x8(%ebp),%eax
  801630:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801635:	99                   	cltd   
  801636:	f7 f9                	idiv   %ecx
  801638:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80163b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80163e:	8d 50 01             	lea    0x1(%eax),%edx
  801641:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801644:	89 c2                	mov    %eax,%edx
  801646:	8b 45 0c             	mov    0xc(%ebp),%eax
  801649:	01 d0                	add    %edx,%eax
  80164b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80164e:	83 c2 30             	add    $0x30,%edx
  801651:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801653:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801656:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80165b:	f7 e9                	imul   %ecx
  80165d:	c1 fa 02             	sar    $0x2,%edx
  801660:	89 c8                	mov    %ecx,%eax
  801662:	c1 f8 1f             	sar    $0x1f,%eax
  801665:	29 c2                	sub    %eax,%edx
  801667:	89 d0                	mov    %edx,%eax
  801669:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80166c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801670:	75 bb                	jne    80162d <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801672:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801679:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80167c:	48                   	dec    %eax
  80167d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801680:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801684:	74 3d                	je     8016c3 <ltostr+0xc3>
		start = 1 ;
  801686:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80168d:	eb 34                	jmp    8016c3 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80168f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801692:	8b 45 0c             	mov    0xc(%ebp),%eax
  801695:	01 d0                	add    %edx,%eax
  801697:	8a 00                	mov    (%eax),%al
  801699:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80169c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80169f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a2:	01 c2                	add    %eax,%edx
  8016a4:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8016a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016aa:	01 c8                	add    %ecx,%eax
  8016ac:	8a 00                	mov    (%eax),%al
  8016ae:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8016b0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016b6:	01 c2                	add    %eax,%edx
  8016b8:	8a 45 eb             	mov    -0x15(%ebp),%al
  8016bb:	88 02                	mov    %al,(%edx)
		start++ ;
  8016bd:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8016c0:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8016c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016c6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8016c9:	7c c4                	jl     80168f <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8016cb:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8016ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016d1:	01 d0                	add    %edx,%eax
  8016d3:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8016d6:	90                   	nop
  8016d7:	c9                   	leave  
  8016d8:	c3                   	ret    

008016d9 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8016d9:	55                   	push   %ebp
  8016da:	89 e5                	mov    %esp,%ebp
  8016dc:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8016df:	ff 75 08             	pushl  0x8(%ebp)
  8016e2:	e8 c4 f9 ff ff       	call   8010ab <strlen>
  8016e7:	83 c4 04             	add    $0x4,%esp
  8016ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8016ed:	ff 75 0c             	pushl  0xc(%ebp)
  8016f0:	e8 b6 f9 ff ff       	call   8010ab <strlen>
  8016f5:	83 c4 04             	add    $0x4,%esp
  8016f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8016fb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801702:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801709:	eb 17                	jmp    801722 <strcconcat+0x49>
		final[s] = str1[s] ;
  80170b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80170e:	8b 45 10             	mov    0x10(%ebp),%eax
  801711:	01 c2                	add    %eax,%edx
  801713:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801716:	8b 45 08             	mov    0x8(%ebp),%eax
  801719:	01 c8                	add    %ecx,%eax
  80171b:	8a 00                	mov    (%eax),%al
  80171d:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80171f:	ff 45 fc             	incl   -0x4(%ebp)
  801722:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801725:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801728:	7c e1                	jl     80170b <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80172a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801731:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801738:	eb 1f                	jmp    801759 <strcconcat+0x80>
		final[s++] = str2[i] ;
  80173a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80173d:	8d 50 01             	lea    0x1(%eax),%edx
  801740:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801743:	89 c2                	mov    %eax,%edx
  801745:	8b 45 10             	mov    0x10(%ebp),%eax
  801748:	01 c2                	add    %eax,%edx
  80174a:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80174d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801750:	01 c8                	add    %ecx,%eax
  801752:	8a 00                	mov    (%eax),%al
  801754:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801756:	ff 45 f8             	incl   -0x8(%ebp)
  801759:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80175c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80175f:	7c d9                	jl     80173a <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801761:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801764:	8b 45 10             	mov    0x10(%ebp),%eax
  801767:	01 d0                	add    %edx,%eax
  801769:	c6 00 00             	movb   $0x0,(%eax)
}
  80176c:	90                   	nop
  80176d:	c9                   	leave  
  80176e:	c3                   	ret    

0080176f <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80176f:	55                   	push   %ebp
  801770:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801772:	8b 45 14             	mov    0x14(%ebp),%eax
  801775:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80177b:	8b 45 14             	mov    0x14(%ebp),%eax
  80177e:	8b 00                	mov    (%eax),%eax
  801780:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801787:	8b 45 10             	mov    0x10(%ebp),%eax
  80178a:	01 d0                	add    %edx,%eax
  80178c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801792:	eb 0c                	jmp    8017a0 <strsplit+0x31>
			*string++ = 0;
  801794:	8b 45 08             	mov    0x8(%ebp),%eax
  801797:	8d 50 01             	lea    0x1(%eax),%edx
  80179a:	89 55 08             	mov    %edx,0x8(%ebp)
  80179d:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8017a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a3:	8a 00                	mov    (%eax),%al
  8017a5:	84 c0                	test   %al,%al
  8017a7:	74 18                	je     8017c1 <strsplit+0x52>
  8017a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ac:	8a 00                	mov    (%eax),%al
  8017ae:	0f be c0             	movsbl %al,%eax
  8017b1:	50                   	push   %eax
  8017b2:	ff 75 0c             	pushl  0xc(%ebp)
  8017b5:	e8 83 fa ff ff       	call   80123d <strchr>
  8017ba:	83 c4 08             	add    $0x8,%esp
  8017bd:	85 c0                	test   %eax,%eax
  8017bf:	75 d3                	jne    801794 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8017c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c4:	8a 00                	mov    (%eax),%al
  8017c6:	84 c0                	test   %al,%al
  8017c8:	74 5a                	je     801824 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8017ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8017cd:	8b 00                	mov    (%eax),%eax
  8017cf:	83 f8 0f             	cmp    $0xf,%eax
  8017d2:	75 07                	jne    8017db <strsplit+0x6c>
		{
			return 0;
  8017d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8017d9:	eb 66                	jmp    801841 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8017db:	8b 45 14             	mov    0x14(%ebp),%eax
  8017de:	8b 00                	mov    (%eax),%eax
  8017e0:	8d 48 01             	lea    0x1(%eax),%ecx
  8017e3:	8b 55 14             	mov    0x14(%ebp),%edx
  8017e6:	89 0a                	mov    %ecx,(%edx)
  8017e8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8017f2:	01 c2                	add    %eax,%edx
  8017f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f7:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8017f9:	eb 03                	jmp    8017fe <strsplit+0x8f>
			string++;
  8017fb:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8017fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801801:	8a 00                	mov    (%eax),%al
  801803:	84 c0                	test   %al,%al
  801805:	74 8b                	je     801792 <strsplit+0x23>
  801807:	8b 45 08             	mov    0x8(%ebp),%eax
  80180a:	8a 00                	mov    (%eax),%al
  80180c:	0f be c0             	movsbl %al,%eax
  80180f:	50                   	push   %eax
  801810:	ff 75 0c             	pushl  0xc(%ebp)
  801813:	e8 25 fa ff ff       	call   80123d <strchr>
  801818:	83 c4 08             	add    $0x8,%esp
  80181b:	85 c0                	test   %eax,%eax
  80181d:	74 dc                	je     8017fb <strsplit+0x8c>
			string++;
	}
  80181f:	e9 6e ff ff ff       	jmp    801792 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801824:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801825:	8b 45 14             	mov    0x14(%ebp),%eax
  801828:	8b 00                	mov    (%eax),%eax
  80182a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801831:	8b 45 10             	mov    0x10(%ebp),%eax
  801834:	01 d0                	add    %edx,%eax
  801836:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80183c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801841:	c9                   	leave  
  801842:	c3                   	ret    

00801843 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801843:	55                   	push   %ebp
  801844:	89 e5                	mov    %esp,%ebp
  801846:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801849:	8b 45 08             	mov    0x8(%ebp),%eax
  80184c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  80184f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801856:	eb 4a                	jmp    8018a2 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801858:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80185b:	8b 45 08             	mov    0x8(%ebp),%eax
  80185e:	01 c2                	add    %eax,%edx
  801860:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801863:	8b 45 0c             	mov    0xc(%ebp),%eax
  801866:	01 c8                	add    %ecx,%eax
  801868:	8a 00                	mov    (%eax),%al
  80186a:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  80186c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80186f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801872:	01 d0                	add    %edx,%eax
  801874:	8a 00                	mov    (%eax),%al
  801876:	3c 40                	cmp    $0x40,%al
  801878:	7e 25                	jle    80189f <str2lower+0x5c>
  80187a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80187d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801880:	01 d0                	add    %edx,%eax
  801882:	8a 00                	mov    (%eax),%al
  801884:	3c 5a                	cmp    $0x5a,%al
  801886:	7f 17                	jg     80189f <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801888:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80188b:	8b 45 08             	mov    0x8(%ebp),%eax
  80188e:	01 d0                	add    %edx,%eax
  801890:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801893:	8b 55 08             	mov    0x8(%ebp),%edx
  801896:	01 ca                	add    %ecx,%edx
  801898:	8a 12                	mov    (%edx),%dl
  80189a:	83 c2 20             	add    $0x20,%edx
  80189d:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80189f:	ff 45 fc             	incl   -0x4(%ebp)
  8018a2:	ff 75 0c             	pushl  0xc(%ebp)
  8018a5:	e8 01 f8 ff ff       	call   8010ab <strlen>
  8018aa:	83 c4 04             	add    $0x4,%esp
  8018ad:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8018b0:	7f a6                	jg     801858 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8018b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8018b5:	c9                   	leave  
  8018b6:	c3                   	ret    

008018b7 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8018b7:	55                   	push   %ebp
  8018b8:	89 e5                	mov    %esp,%ebp
  8018ba:	57                   	push   %edi
  8018bb:	56                   	push   %esi
  8018bc:	53                   	push   %ebx
  8018bd:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018c6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018c9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018cc:	8b 7d 18             	mov    0x18(%ebp),%edi
  8018cf:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8018d2:	cd 30                	int    $0x30
  8018d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8018d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018da:	83 c4 10             	add    $0x10,%esp
  8018dd:	5b                   	pop    %ebx
  8018de:	5e                   	pop    %esi
  8018df:	5f                   	pop    %edi
  8018e0:	5d                   	pop    %ebp
  8018e1:	c3                   	ret    

008018e2 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8018e2:	55                   	push   %ebp
  8018e3:	89 e5                	mov    %esp,%ebp
  8018e5:	83 ec 04             	sub    $0x4,%esp
  8018e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8018eb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8018ee:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8018f1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f8:	6a 00                	push   $0x0
  8018fa:	51                   	push   %ecx
  8018fb:	52                   	push   %edx
  8018fc:	ff 75 0c             	pushl  0xc(%ebp)
  8018ff:	50                   	push   %eax
  801900:	6a 00                	push   $0x0
  801902:	e8 b0 ff ff ff       	call   8018b7 <syscall>
  801907:	83 c4 18             	add    $0x18,%esp
}
  80190a:	90                   	nop
  80190b:	c9                   	leave  
  80190c:	c3                   	ret    

0080190d <sys_cgetc>:

int
sys_cgetc(void)
{
  80190d:	55                   	push   %ebp
  80190e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801910:	6a 00                	push   $0x0
  801912:	6a 00                	push   $0x0
  801914:	6a 00                	push   $0x0
  801916:	6a 00                	push   $0x0
  801918:	6a 00                	push   $0x0
  80191a:	6a 02                	push   $0x2
  80191c:	e8 96 ff ff ff       	call   8018b7 <syscall>
  801921:	83 c4 18             	add    $0x18,%esp
}
  801924:	c9                   	leave  
  801925:	c3                   	ret    

00801926 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801926:	55                   	push   %ebp
  801927:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801929:	6a 00                	push   $0x0
  80192b:	6a 00                	push   $0x0
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	6a 00                	push   $0x0
  801933:	6a 03                	push   $0x3
  801935:	e8 7d ff ff ff       	call   8018b7 <syscall>
  80193a:	83 c4 18             	add    $0x18,%esp
}
  80193d:	90                   	nop
  80193e:	c9                   	leave  
  80193f:	c3                   	ret    

00801940 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801940:	55                   	push   %ebp
  801941:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801943:	6a 00                	push   $0x0
  801945:	6a 00                	push   $0x0
  801947:	6a 00                	push   $0x0
  801949:	6a 00                	push   $0x0
  80194b:	6a 00                	push   $0x0
  80194d:	6a 04                	push   $0x4
  80194f:	e8 63 ff ff ff       	call   8018b7 <syscall>
  801954:	83 c4 18             	add    $0x18,%esp
}
  801957:	90                   	nop
  801958:	c9                   	leave  
  801959:	c3                   	ret    

0080195a <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80195a:	55                   	push   %ebp
  80195b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80195d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801960:	8b 45 08             	mov    0x8(%ebp),%eax
  801963:	6a 00                	push   $0x0
  801965:	6a 00                	push   $0x0
  801967:	6a 00                	push   $0x0
  801969:	52                   	push   %edx
  80196a:	50                   	push   %eax
  80196b:	6a 08                	push   $0x8
  80196d:	e8 45 ff ff ff       	call   8018b7 <syscall>
  801972:	83 c4 18             	add    $0x18,%esp
}
  801975:	c9                   	leave  
  801976:	c3                   	ret    

00801977 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801977:	55                   	push   %ebp
  801978:	89 e5                	mov    %esp,%ebp
  80197a:	56                   	push   %esi
  80197b:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80197c:	8b 75 18             	mov    0x18(%ebp),%esi
  80197f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801982:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801985:	8b 55 0c             	mov    0xc(%ebp),%edx
  801988:	8b 45 08             	mov    0x8(%ebp),%eax
  80198b:	56                   	push   %esi
  80198c:	53                   	push   %ebx
  80198d:	51                   	push   %ecx
  80198e:	52                   	push   %edx
  80198f:	50                   	push   %eax
  801990:	6a 09                	push   $0x9
  801992:	e8 20 ff ff ff       	call   8018b7 <syscall>
  801997:	83 c4 18             	add    $0x18,%esp
}
  80199a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80199d:	5b                   	pop    %ebx
  80199e:	5e                   	pop    %esi
  80199f:	5d                   	pop    %ebp
  8019a0:	c3                   	ret    

008019a1 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8019a1:	55                   	push   %ebp
  8019a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8019a4:	6a 00                	push   $0x0
  8019a6:	6a 00                	push   $0x0
  8019a8:	6a 00                	push   $0x0
  8019aa:	6a 00                	push   $0x0
  8019ac:	ff 75 08             	pushl  0x8(%ebp)
  8019af:	6a 0a                	push   $0xa
  8019b1:	e8 01 ff ff ff       	call   8018b7 <syscall>
  8019b6:	83 c4 18             	add    $0x18,%esp
}
  8019b9:	c9                   	leave  
  8019ba:	c3                   	ret    

008019bb <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8019bb:	55                   	push   %ebp
  8019bc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 00                	push   $0x0
  8019c2:	6a 00                	push   $0x0
  8019c4:	ff 75 0c             	pushl  0xc(%ebp)
  8019c7:	ff 75 08             	pushl  0x8(%ebp)
  8019ca:	6a 0b                	push   $0xb
  8019cc:	e8 e6 fe ff ff       	call   8018b7 <syscall>
  8019d1:	83 c4 18             	add    $0x18,%esp
}
  8019d4:	c9                   	leave  
  8019d5:	c3                   	ret    

008019d6 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8019d6:	55                   	push   %ebp
  8019d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8019d9:	6a 00                	push   $0x0
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 0c                	push   $0xc
  8019e5:	e8 cd fe ff ff       	call   8018b7 <syscall>
  8019ea:	83 c4 18             	add    $0x18,%esp
}
  8019ed:	c9                   	leave  
  8019ee:	c3                   	ret    

008019ef <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8019ef:	55                   	push   %ebp
  8019f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8019f2:	6a 00                	push   $0x0
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 00                	push   $0x0
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 0d                	push   $0xd
  8019fe:	e8 b4 fe ff ff       	call   8018b7 <syscall>
  801a03:	83 c4 18             	add    $0x18,%esp
}
  801a06:	c9                   	leave  
  801a07:	c3                   	ret    

00801a08 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a08:	55                   	push   %ebp
  801a09:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a0b:	6a 00                	push   $0x0
  801a0d:	6a 00                	push   $0x0
  801a0f:	6a 00                	push   $0x0
  801a11:	6a 00                	push   $0x0
  801a13:	6a 00                	push   $0x0
  801a15:	6a 0e                	push   $0xe
  801a17:	e8 9b fe ff ff       	call   8018b7 <syscall>
  801a1c:	83 c4 18             	add    $0x18,%esp
}
  801a1f:	c9                   	leave  
  801a20:	c3                   	ret    

00801a21 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a21:	55                   	push   %ebp
  801a22:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a24:	6a 00                	push   $0x0
  801a26:	6a 00                	push   $0x0
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 0f                	push   $0xf
  801a30:	e8 82 fe ff ff       	call   8018b7 <syscall>
  801a35:	83 c4 18             	add    $0x18,%esp
}
  801a38:	c9                   	leave  
  801a39:	c3                   	ret    

00801a3a <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a3a:	55                   	push   %ebp
  801a3b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a3d:	6a 00                	push   $0x0
  801a3f:	6a 00                	push   $0x0
  801a41:	6a 00                	push   $0x0
  801a43:	6a 00                	push   $0x0
  801a45:	ff 75 08             	pushl  0x8(%ebp)
  801a48:	6a 10                	push   $0x10
  801a4a:	e8 68 fe ff ff       	call   8018b7 <syscall>
  801a4f:	83 c4 18             	add    $0x18,%esp
}
  801a52:	c9                   	leave  
  801a53:	c3                   	ret    

00801a54 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a54:	55                   	push   %ebp
  801a55:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a57:	6a 00                	push   $0x0
  801a59:	6a 00                	push   $0x0
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 11                	push   $0x11
  801a63:	e8 4f fe ff ff       	call   8018b7 <syscall>
  801a68:	83 c4 18             	add    $0x18,%esp
}
  801a6b:	90                   	nop
  801a6c:	c9                   	leave  
  801a6d:	c3                   	ret    

00801a6e <sys_cputc>:

void
sys_cputc(const char c)
{
  801a6e:	55                   	push   %ebp
  801a6f:	89 e5                	mov    %esp,%ebp
  801a71:	83 ec 04             	sub    $0x4,%esp
  801a74:	8b 45 08             	mov    0x8(%ebp),%eax
  801a77:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a7a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	6a 00                	push   $0x0
  801a84:	6a 00                	push   $0x0
  801a86:	50                   	push   %eax
  801a87:	6a 01                	push   $0x1
  801a89:	e8 29 fe ff ff       	call   8018b7 <syscall>
  801a8e:	83 c4 18             	add    $0x18,%esp
}
  801a91:	90                   	nop
  801a92:	c9                   	leave  
  801a93:	c3                   	ret    

00801a94 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a94:	55                   	push   %ebp
  801a95:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a97:	6a 00                	push   $0x0
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 00                	push   $0x0
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 14                	push   $0x14
  801aa3:	e8 0f fe ff ff       	call   8018b7 <syscall>
  801aa8:	83 c4 18             	add    $0x18,%esp
}
  801aab:	90                   	nop
  801aac:	c9                   	leave  
  801aad:	c3                   	ret    

00801aae <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801aae:	55                   	push   %ebp
  801aaf:	89 e5                	mov    %esp,%ebp
  801ab1:	83 ec 04             	sub    $0x4,%esp
  801ab4:	8b 45 10             	mov    0x10(%ebp),%eax
  801ab7:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801aba:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801abd:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac4:	6a 00                	push   $0x0
  801ac6:	51                   	push   %ecx
  801ac7:	52                   	push   %edx
  801ac8:	ff 75 0c             	pushl  0xc(%ebp)
  801acb:	50                   	push   %eax
  801acc:	6a 15                	push   $0x15
  801ace:	e8 e4 fd ff ff       	call   8018b7 <syscall>
  801ad3:	83 c4 18             	add    $0x18,%esp
}
  801ad6:	c9                   	leave  
  801ad7:	c3                   	ret    

00801ad8 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801ad8:	55                   	push   %ebp
  801ad9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801adb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ade:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 00                	push   $0x0
  801ae7:	52                   	push   %edx
  801ae8:	50                   	push   %eax
  801ae9:	6a 16                	push   $0x16
  801aeb:	e8 c7 fd ff ff       	call   8018b7 <syscall>
  801af0:	83 c4 18             	add    $0x18,%esp
}
  801af3:	c9                   	leave  
  801af4:	c3                   	ret    

00801af5 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801af5:	55                   	push   %ebp
  801af6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801af8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801afb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801afe:	8b 45 08             	mov    0x8(%ebp),%eax
  801b01:	6a 00                	push   $0x0
  801b03:	6a 00                	push   $0x0
  801b05:	51                   	push   %ecx
  801b06:	52                   	push   %edx
  801b07:	50                   	push   %eax
  801b08:	6a 17                	push   $0x17
  801b0a:	e8 a8 fd ff ff       	call   8018b7 <syscall>
  801b0f:	83 c4 18             	add    $0x18,%esp
}
  801b12:	c9                   	leave  
  801b13:	c3                   	ret    

00801b14 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801b14:	55                   	push   %ebp
  801b15:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b17:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1d:	6a 00                	push   $0x0
  801b1f:	6a 00                	push   $0x0
  801b21:	6a 00                	push   $0x0
  801b23:	52                   	push   %edx
  801b24:	50                   	push   %eax
  801b25:	6a 18                	push   $0x18
  801b27:	e8 8b fd ff ff       	call   8018b7 <syscall>
  801b2c:	83 c4 18             	add    $0x18,%esp
}
  801b2f:	c9                   	leave  
  801b30:	c3                   	ret    

00801b31 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b31:	55                   	push   %ebp
  801b32:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b34:	8b 45 08             	mov    0x8(%ebp),%eax
  801b37:	6a 00                	push   $0x0
  801b39:	ff 75 14             	pushl  0x14(%ebp)
  801b3c:	ff 75 10             	pushl  0x10(%ebp)
  801b3f:	ff 75 0c             	pushl  0xc(%ebp)
  801b42:	50                   	push   %eax
  801b43:	6a 19                	push   $0x19
  801b45:	e8 6d fd ff ff       	call   8018b7 <syscall>
  801b4a:	83 c4 18             	add    $0x18,%esp
}
  801b4d:	c9                   	leave  
  801b4e:	c3                   	ret    

00801b4f <sys_run_env>:

void sys_run_env(int32 envId)
{
  801b4f:	55                   	push   %ebp
  801b50:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b52:	8b 45 08             	mov    0x8(%ebp),%eax
  801b55:	6a 00                	push   $0x0
  801b57:	6a 00                	push   $0x0
  801b59:	6a 00                	push   $0x0
  801b5b:	6a 00                	push   $0x0
  801b5d:	50                   	push   %eax
  801b5e:	6a 1a                	push   $0x1a
  801b60:	e8 52 fd ff ff       	call   8018b7 <syscall>
  801b65:	83 c4 18             	add    $0x18,%esp
}
  801b68:	90                   	nop
  801b69:	c9                   	leave  
  801b6a:	c3                   	ret    

00801b6b <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b6b:	55                   	push   %ebp
  801b6c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b71:	6a 00                	push   $0x0
  801b73:	6a 00                	push   $0x0
  801b75:	6a 00                	push   $0x0
  801b77:	6a 00                	push   $0x0
  801b79:	50                   	push   %eax
  801b7a:	6a 1b                	push   $0x1b
  801b7c:	e8 36 fd ff ff       	call   8018b7 <syscall>
  801b81:	83 c4 18             	add    $0x18,%esp
}
  801b84:	c9                   	leave  
  801b85:	c3                   	ret    

00801b86 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b86:	55                   	push   %ebp
  801b87:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b89:	6a 00                	push   $0x0
  801b8b:	6a 00                	push   $0x0
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 00                	push   $0x0
  801b93:	6a 05                	push   $0x5
  801b95:	e8 1d fd ff ff       	call   8018b7 <syscall>
  801b9a:	83 c4 18             	add    $0x18,%esp
}
  801b9d:	c9                   	leave  
  801b9e:	c3                   	ret    

00801b9f <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b9f:	55                   	push   %ebp
  801ba0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 00                	push   $0x0
  801ba6:	6a 00                	push   $0x0
  801ba8:	6a 00                	push   $0x0
  801baa:	6a 00                	push   $0x0
  801bac:	6a 06                	push   $0x6
  801bae:	e8 04 fd ff ff       	call   8018b7 <syscall>
  801bb3:	83 c4 18             	add    $0x18,%esp
}
  801bb6:	c9                   	leave  
  801bb7:	c3                   	ret    

00801bb8 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801bb8:	55                   	push   %ebp
  801bb9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801bbb:	6a 00                	push   $0x0
  801bbd:	6a 00                	push   $0x0
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 07                	push   $0x7
  801bc7:	e8 eb fc ff ff       	call   8018b7 <syscall>
  801bcc:	83 c4 18             	add    $0x18,%esp
}
  801bcf:	c9                   	leave  
  801bd0:	c3                   	ret    

00801bd1 <sys_exit_env>:


void sys_exit_env(void)
{
  801bd1:	55                   	push   %ebp
  801bd2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 1c                	push   $0x1c
  801be0:	e8 d2 fc ff ff       	call   8018b7 <syscall>
  801be5:	83 c4 18             	add    $0x18,%esp
}
  801be8:	90                   	nop
  801be9:	c9                   	leave  
  801bea:	c3                   	ret    

00801beb <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801beb:	55                   	push   %ebp
  801bec:	89 e5                	mov    %esp,%ebp
  801bee:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801bf1:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801bf4:	8d 50 04             	lea    0x4(%eax),%edx
  801bf7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801bfa:	6a 00                	push   $0x0
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 00                	push   $0x0
  801c00:	52                   	push   %edx
  801c01:	50                   	push   %eax
  801c02:	6a 1d                	push   $0x1d
  801c04:	e8 ae fc ff ff       	call   8018b7 <syscall>
  801c09:	83 c4 18             	add    $0x18,%esp
	return result;
  801c0c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c0f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c12:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c15:	89 01                	mov    %eax,(%ecx)
  801c17:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1d:	c9                   	leave  
  801c1e:	c2 04 00             	ret    $0x4

00801c21 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c21:	55                   	push   %ebp
  801c22:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c24:	6a 00                	push   $0x0
  801c26:	6a 00                	push   $0x0
  801c28:	ff 75 10             	pushl  0x10(%ebp)
  801c2b:	ff 75 0c             	pushl  0xc(%ebp)
  801c2e:	ff 75 08             	pushl  0x8(%ebp)
  801c31:	6a 13                	push   $0x13
  801c33:	e8 7f fc ff ff       	call   8018b7 <syscall>
  801c38:	83 c4 18             	add    $0x18,%esp
	return ;
  801c3b:	90                   	nop
}
  801c3c:	c9                   	leave  
  801c3d:	c3                   	ret    

00801c3e <sys_rcr2>:
uint32 sys_rcr2()
{
  801c3e:	55                   	push   %ebp
  801c3f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c41:	6a 00                	push   $0x0
  801c43:	6a 00                	push   $0x0
  801c45:	6a 00                	push   $0x0
  801c47:	6a 00                	push   $0x0
  801c49:	6a 00                	push   $0x0
  801c4b:	6a 1e                	push   $0x1e
  801c4d:	e8 65 fc ff ff       	call   8018b7 <syscall>
  801c52:	83 c4 18             	add    $0x18,%esp
}
  801c55:	c9                   	leave  
  801c56:	c3                   	ret    

00801c57 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801c57:	55                   	push   %ebp
  801c58:	89 e5                	mov    %esp,%ebp
  801c5a:	83 ec 04             	sub    $0x4,%esp
  801c5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c60:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c63:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c67:	6a 00                	push   $0x0
  801c69:	6a 00                	push   $0x0
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 00                	push   $0x0
  801c6f:	50                   	push   %eax
  801c70:	6a 1f                	push   $0x1f
  801c72:	e8 40 fc ff ff       	call   8018b7 <syscall>
  801c77:	83 c4 18             	add    $0x18,%esp
	return ;
  801c7a:	90                   	nop
}
  801c7b:	c9                   	leave  
  801c7c:	c3                   	ret    

00801c7d <rsttst>:
void rsttst()
{
  801c7d:	55                   	push   %ebp
  801c7e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c80:	6a 00                	push   $0x0
  801c82:	6a 00                	push   $0x0
  801c84:	6a 00                	push   $0x0
  801c86:	6a 00                	push   $0x0
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 21                	push   $0x21
  801c8c:	e8 26 fc ff ff       	call   8018b7 <syscall>
  801c91:	83 c4 18             	add    $0x18,%esp
	return ;
  801c94:	90                   	nop
}
  801c95:	c9                   	leave  
  801c96:	c3                   	ret    

00801c97 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c97:	55                   	push   %ebp
  801c98:	89 e5                	mov    %esp,%ebp
  801c9a:	83 ec 04             	sub    $0x4,%esp
  801c9d:	8b 45 14             	mov    0x14(%ebp),%eax
  801ca0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ca3:	8b 55 18             	mov    0x18(%ebp),%edx
  801ca6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801caa:	52                   	push   %edx
  801cab:	50                   	push   %eax
  801cac:	ff 75 10             	pushl  0x10(%ebp)
  801caf:	ff 75 0c             	pushl  0xc(%ebp)
  801cb2:	ff 75 08             	pushl  0x8(%ebp)
  801cb5:	6a 20                	push   $0x20
  801cb7:	e8 fb fb ff ff       	call   8018b7 <syscall>
  801cbc:	83 c4 18             	add    $0x18,%esp
	return ;
  801cbf:	90                   	nop
}
  801cc0:	c9                   	leave  
  801cc1:	c3                   	ret    

00801cc2 <chktst>:
void chktst(uint32 n)
{
  801cc2:	55                   	push   %ebp
  801cc3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801cc5:	6a 00                	push   $0x0
  801cc7:	6a 00                	push   $0x0
  801cc9:	6a 00                	push   $0x0
  801ccb:	6a 00                	push   $0x0
  801ccd:	ff 75 08             	pushl  0x8(%ebp)
  801cd0:	6a 22                	push   $0x22
  801cd2:	e8 e0 fb ff ff       	call   8018b7 <syscall>
  801cd7:	83 c4 18             	add    $0x18,%esp
	return ;
  801cda:	90                   	nop
}
  801cdb:	c9                   	leave  
  801cdc:	c3                   	ret    

00801cdd <inctst>:

void inctst()
{
  801cdd:	55                   	push   %ebp
  801cde:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801ce0:	6a 00                	push   $0x0
  801ce2:	6a 00                	push   $0x0
  801ce4:	6a 00                	push   $0x0
  801ce6:	6a 00                	push   $0x0
  801ce8:	6a 00                	push   $0x0
  801cea:	6a 23                	push   $0x23
  801cec:	e8 c6 fb ff ff       	call   8018b7 <syscall>
  801cf1:	83 c4 18             	add    $0x18,%esp
	return ;
  801cf4:	90                   	nop
}
  801cf5:	c9                   	leave  
  801cf6:	c3                   	ret    

00801cf7 <gettst>:
uint32 gettst()
{
  801cf7:	55                   	push   %ebp
  801cf8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801cfa:	6a 00                	push   $0x0
  801cfc:	6a 00                	push   $0x0
  801cfe:	6a 00                	push   $0x0
  801d00:	6a 00                	push   $0x0
  801d02:	6a 00                	push   $0x0
  801d04:	6a 24                	push   $0x24
  801d06:	e8 ac fb ff ff       	call   8018b7 <syscall>
  801d0b:	83 c4 18             	add    $0x18,%esp
}
  801d0e:	c9                   	leave  
  801d0f:	c3                   	ret    

00801d10 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801d10:	55                   	push   %ebp
  801d11:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d13:	6a 00                	push   $0x0
  801d15:	6a 00                	push   $0x0
  801d17:	6a 00                	push   $0x0
  801d19:	6a 00                	push   $0x0
  801d1b:	6a 00                	push   $0x0
  801d1d:	6a 25                	push   $0x25
  801d1f:	e8 93 fb ff ff       	call   8018b7 <syscall>
  801d24:	83 c4 18             	add    $0x18,%esp
  801d27:	a3 80 b0 81 00       	mov    %eax,0x81b080
	return uheapPlaceStrategy ;
  801d2c:	a1 80 b0 81 00       	mov    0x81b080,%eax
}
  801d31:	c9                   	leave  
  801d32:	c3                   	ret    

00801d33 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801d33:	55                   	push   %ebp
  801d34:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801d36:	8b 45 08             	mov    0x8(%ebp),%eax
  801d39:	a3 80 b0 81 00       	mov    %eax,0x81b080
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801d3e:	6a 00                	push   $0x0
  801d40:	6a 00                	push   $0x0
  801d42:	6a 00                	push   $0x0
  801d44:	6a 00                	push   $0x0
  801d46:	ff 75 08             	pushl  0x8(%ebp)
  801d49:	6a 26                	push   $0x26
  801d4b:	e8 67 fb ff ff       	call   8018b7 <syscall>
  801d50:	83 c4 18             	add    $0x18,%esp
	return ;
  801d53:	90                   	nop
}
  801d54:	c9                   	leave  
  801d55:	c3                   	ret    

00801d56 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801d56:	55                   	push   %ebp
  801d57:	89 e5                	mov    %esp,%ebp
  801d59:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801d5a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d5d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d60:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d63:	8b 45 08             	mov    0x8(%ebp),%eax
  801d66:	6a 00                	push   $0x0
  801d68:	53                   	push   %ebx
  801d69:	51                   	push   %ecx
  801d6a:	52                   	push   %edx
  801d6b:	50                   	push   %eax
  801d6c:	6a 27                	push   $0x27
  801d6e:	e8 44 fb ff ff       	call   8018b7 <syscall>
  801d73:	83 c4 18             	add    $0x18,%esp
}
  801d76:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d79:	c9                   	leave  
  801d7a:	c3                   	ret    

00801d7b <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801d7b:	55                   	push   %ebp
  801d7c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801d7e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d81:	8b 45 08             	mov    0x8(%ebp),%eax
  801d84:	6a 00                	push   $0x0
  801d86:	6a 00                	push   $0x0
  801d88:	6a 00                	push   $0x0
  801d8a:	52                   	push   %edx
  801d8b:	50                   	push   %eax
  801d8c:	6a 28                	push   $0x28
  801d8e:	e8 24 fb ff ff       	call   8018b7 <syscall>
  801d93:	83 c4 18             	add    $0x18,%esp
}
  801d96:	c9                   	leave  
  801d97:	c3                   	ret    

00801d98 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801d98:	55                   	push   %ebp
  801d99:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801d9b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d9e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801da1:	8b 45 08             	mov    0x8(%ebp),%eax
  801da4:	6a 00                	push   $0x0
  801da6:	51                   	push   %ecx
  801da7:	ff 75 10             	pushl  0x10(%ebp)
  801daa:	52                   	push   %edx
  801dab:	50                   	push   %eax
  801dac:	6a 29                	push   $0x29
  801dae:	e8 04 fb ff ff       	call   8018b7 <syscall>
  801db3:	83 c4 18             	add    $0x18,%esp
}
  801db6:	c9                   	leave  
  801db7:	c3                   	ret    

00801db8 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801db8:	55                   	push   %ebp
  801db9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801dbb:	6a 00                	push   $0x0
  801dbd:	6a 00                	push   $0x0
  801dbf:	ff 75 10             	pushl  0x10(%ebp)
  801dc2:	ff 75 0c             	pushl  0xc(%ebp)
  801dc5:	ff 75 08             	pushl  0x8(%ebp)
  801dc8:	6a 12                	push   $0x12
  801dca:	e8 e8 fa ff ff       	call   8018b7 <syscall>
  801dcf:	83 c4 18             	add    $0x18,%esp
	return ;
  801dd2:	90                   	nop
}
  801dd3:	c9                   	leave  
  801dd4:	c3                   	ret    

00801dd5 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801dd5:	55                   	push   %ebp
  801dd6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801dd8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dde:	6a 00                	push   $0x0
  801de0:	6a 00                	push   $0x0
  801de2:	6a 00                	push   $0x0
  801de4:	52                   	push   %edx
  801de5:	50                   	push   %eax
  801de6:	6a 2a                	push   $0x2a
  801de8:	e8 ca fa ff ff       	call   8018b7 <syscall>
  801ded:	83 c4 18             	add    $0x18,%esp
	return;
  801df0:	90                   	nop
}
  801df1:	c9                   	leave  
  801df2:	c3                   	ret    

00801df3 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801df3:	55                   	push   %ebp
  801df4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801df6:	6a 00                	push   $0x0
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 00                	push   $0x0
  801dfc:	6a 00                	push   $0x0
  801dfe:	6a 00                	push   $0x0
  801e00:	6a 2b                	push   $0x2b
  801e02:	e8 b0 fa ff ff       	call   8018b7 <syscall>
  801e07:	83 c4 18             	add    $0x18,%esp
}
  801e0a:	c9                   	leave  
  801e0b:	c3                   	ret    

00801e0c <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801e0c:	55                   	push   %ebp
  801e0d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 00                	push   $0x0
  801e13:	6a 00                	push   $0x0
  801e15:	ff 75 0c             	pushl  0xc(%ebp)
  801e18:	ff 75 08             	pushl  0x8(%ebp)
  801e1b:	6a 2d                	push   $0x2d
  801e1d:	e8 95 fa ff ff       	call   8018b7 <syscall>
  801e22:	83 c4 18             	add    $0x18,%esp
	return;
  801e25:	90                   	nop
}
  801e26:	c9                   	leave  
  801e27:	c3                   	ret    

00801e28 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801e28:	55                   	push   %ebp
  801e29:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 00                	push   $0x0
  801e31:	ff 75 0c             	pushl  0xc(%ebp)
  801e34:	ff 75 08             	pushl  0x8(%ebp)
  801e37:	6a 2c                	push   $0x2c
  801e39:	e8 79 fa ff ff       	call   8018b7 <syscall>
  801e3e:	83 c4 18             	add    $0x18,%esp
	return ;
  801e41:	90                   	nop
}
  801e42:	c9                   	leave  
  801e43:	c3                   	ret    

00801e44 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801e44:	55                   	push   %ebp
  801e45:	89 e5                	mov    %esp,%ebp
  801e47:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801e4a:	83 ec 04             	sub    $0x4,%esp
  801e4d:	68 68 2a 80 00       	push   $0x802a68
  801e52:	68 25 01 00 00       	push   $0x125
  801e57:	68 9b 2a 80 00       	push   $0x802a9b
  801e5c:	e8 a3 e8 ff ff       	call   800704 <_panic>
  801e61:	66 90                	xchg   %ax,%ax
  801e63:	90                   	nop

00801e64 <__udivdi3>:
  801e64:	55                   	push   %ebp
  801e65:	57                   	push   %edi
  801e66:	56                   	push   %esi
  801e67:	53                   	push   %ebx
  801e68:	83 ec 1c             	sub    $0x1c,%esp
  801e6b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801e6f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801e73:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801e77:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e7b:	89 ca                	mov    %ecx,%edx
  801e7d:	89 f8                	mov    %edi,%eax
  801e7f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801e83:	85 f6                	test   %esi,%esi
  801e85:	75 2d                	jne    801eb4 <__udivdi3+0x50>
  801e87:	39 cf                	cmp    %ecx,%edi
  801e89:	77 65                	ja     801ef0 <__udivdi3+0x8c>
  801e8b:	89 fd                	mov    %edi,%ebp
  801e8d:	85 ff                	test   %edi,%edi
  801e8f:	75 0b                	jne    801e9c <__udivdi3+0x38>
  801e91:	b8 01 00 00 00       	mov    $0x1,%eax
  801e96:	31 d2                	xor    %edx,%edx
  801e98:	f7 f7                	div    %edi
  801e9a:	89 c5                	mov    %eax,%ebp
  801e9c:	31 d2                	xor    %edx,%edx
  801e9e:	89 c8                	mov    %ecx,%eax
  801ea0:	f7 f5                	div    %ebp
  801ea2:	89 c1                	mov    %eax,%ecx
  801ea4:	89 d8                	mov    %ebx,%eax
  801ea6:	f7 f5                	div    %ebp
  801ea8:	89 cf                	mov    %ecx,%edi
  801eaa:	89 fa                	mov    %edi,%edx
  801eac:	83 c4 1c             	add    $0x1c,%esp
  801eaf:	5b                   	pop    %ebx
  801eb0:	5e                   	pop    %esi
  801eb1:	5f                   	pop    %edi
  801eb2:	5d                   	pop    %ebp
  801eb3:	c3                   	ret    
  801eb4:	39 ce                	cmp    %ecx,%esi
  801eb6:	77 28                	ja     801ee0 <__udivdi3+0x7c>
  801eb8:	0f bd fe             	bsr    %esi,%edi
  801ebb:	83 f7 1f             	xor    $0x1f,%edi
  801ebe:	75 40                	jne    801f00 <__udivdi3+0x9c>
  801ec0:	39 ce                	cmp    %ecx,%esi
  801ec2:	72 0a                	jb     801ece <__udivdi3+0x6a>
  801ec4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801ec8:	0f 87 9e 00 00 00    	ja     801f6c <__udivdi3+0x108>
  801ece:	b8 01 00 00 00       	mov    $0x1,%eax
  801ed3:	89 fa                	mov    %edi,%edx
  801ed5:	83 c4 1c             	add    $0x1c,%esp
  801ed8:	5b                   	pop    %ebx
  801ed9:	5e                   	pop    %esi
  801eda:	5f                   	pop    %edi
  801edb:	5d                   	pop    %ebp
  801edc:	c3                   	ret    
  801edd:	8d 76 00             	lea    0x0(%esi),%esi
  801ee0:	31 ff                	xor    %edi,%edi
  801ee2:	31 c0                	xor    %eax,%eax
  801ee4:	89 fa                	mov    %edi,%edx
  801ee6:	83 c4 1c             	add    $0x1c,%esp
  801ee9:	5b                   	pop    %ebx
  801eea:	5e                   	pop    %esi
  801eeb:	5f                   	pop    %edi
  801eec:	5d                   	pop    %ebp
  801eed:	c3                   	ret    
  801eee:	66 90                	xchg   %ax,%ax
  801ef0:	89 d8                	mov    %ebx,%eax
  801ef2:	f7 f7                	div    %edi
  801ef4:	31 ff                	xor    %edi,%edi
  801ef6:	89 fa                	mov    %edi,%edx
  801ef8:	83 c4 1c             	add    $0x1c,%esp
  801efb:	5b                   	pop    %ebx
  801efc:	5e                   	pop    %esi
  801efd:	5f                   	pop    %edi
  801efe:	5d                   	pop    %ebp
  801eff:	c3                   	ret    
  801f00:	bd 20 00 00 00       	mov    $0x20,%ebp
  801f05:	89 eb                	mov    %ebp,%ebx
  801f07:	29 fb                	sub    %edi,%ebx
  801f09:	89 f9                	mov    %edi,%ecx
  801f0b:	d3 e6                	shl    %cl,%esi
  801f0d:	89 c5                	mov    %eax,%ebp
  801f0f:	88 d9                	mov    %bl,%cl
  801f11:	d3 ed                	shr    %cl,%ebp
  801f13:	89 e9                	mov    %ebp,%ecx
  801f15:	09 f1                	or     %esi,%ecx
  801f17:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801f1b:	89 f9                	mov    %edi,%ecx
  801f1d:	d3 e0                	shl    %cl,%eax
  801f1f:	89 c5                	mov    %eax,%ebp
  801f21:	89 d6                	mov    %edx,%esi
  801f23:	88 d9                	mov    %bl,%cl
  801f25:	d3 ee                	shr    %cl,%esi
  801f27:	89 f9                	mov    %edi,%ecx
  801f29:	d3 e2                	shl    %cl,%edx
  801f2b:	8b 44 24 08          	mov    0x8(%esp),%eax
  801f2f:	88 d9                	mov    %bl,%cl
  801f31:	d3 e8                	shr    %cl,%eax
  801f33:	09 c2                	or     %eax,%edx
  801f35:	89 d0                	mov    %edx,%eax
  801f37:	89 f2                	mov    %esi,%edx
  801f39:	f7 74 24 0c          	divl   0xc(%esp)
  801f3d:	89 d6                	mov    %edx,%esi
  801f3f:	89 c3                	mov    %eax,%ebx
  801f41:	f7 e5                	mul    %ebp
  801f43:	39 d6                	cmp    %edx,%esi
  801f45:	72 19                	jb     801f60 <__udivdi3+0xfc>
  801f47:	74 0b                	je     801f54 <__udivdi3+0xf0>
  801f49:	89 d8                	mov    %ebx,%eax
  801f4b:	31 ff                	xor    %edi,%edi
  801f4d:	e9 58 ff ff ff       	jmp    801eaa <__udivdi3+0x46>
  801f52:	66 90                	xchg   %ax,%ax
  801f54:	8b 54 24 08          	mov    0x8(%esp),%edx
  801f58:	89 f9                	mov    %edi,%ecx
  801f5a:	d3 e2                	shl    %cl,%edx
  801f5c:	39 c2                	cmp    %eax,%edx
  801f5e:	73 e9                	jae    801f49 <__udivdi3+0xe5>
  801f60:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801f63:	31 ff                	xor    %edi,%edi
  801f65:	e9 40 ff ff ff       	jmp    801eaa <__udivdi3+0x46>
  801f6a:	66 90                	xchg   %ax,%ax
  801f6c:	31 c0                	xor    %eax,%eax
  801f6e:	e9 37 ff ff ff       	jmp    801eaa <__udivdi3+0x46>
  801f73:	90                   	nop

00801f74 <__umoddi3>:
  801f74:	55                   	push   %ebp
  801f75:	57                   	push   %edi
  801f76:	56                   	push   %esi
  801f77:	53                   	push   %ebx
  801f78:	83 ec 1c             	sub    $0x1c,%esp
  801f7b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801f7f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801f83:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801f87:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801f8b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801f8f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801f93:	89 f3                	mov    %esi,%ebx
  801f95:	89 fa                	mov    %edi,%edx
  801f97:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801f9b:	89 34 24             	mov    %esi,(%esp)
  801f9e:	85 c0                	test   %eax,%eax
  801fa0:	75 1a                	jne    801fbc <__umoddi3+0x48>
  801fa2:	39 f7                	cmp    %esi,%edi
  801fa4:	0f 86 a2 00 00 00    	jbe    80204c <__umoddi3+0xd8>
  801faa:	89 c8                	mov    %ecx,%eax
  801fac:	89 f2                	mov    %esi,%edx
  801fae:	f7 f7                	div    %edi
  801fb0:	89 d0                	mov    %edx,%eax
  801fb2:	31 d2                	xor    %edx,%edx
  801fb4:	83 c4 1c             	add    $0x1c,%esp
  801fb7:	5b                   	pop    %ebx
  801fb8:	5e                   	pop    %esi
  801fb9:	5f                   	pop    %edi
  801fba:	5d                   	pop    %ebp
  801fbb:	c3                   	ret    
  801fbc:	39 f0                	cmp    %esi,%eax
  801fbe:	0f 87 ac 00 00 00    	ja     802070 <__umoddi3+0xfc>
  801fc4:	0f bd e8             	bsr    %eax,%ebp
  801fc7:	83 f5 1f             	xor    $0x1f,%ebp
  801fca:	0f 84 ac 00 00 00    	je     80207c <__umoddi3+0x108>
  801fd0:	bf 20 00 00 00       	mov    $0x20,%edi
  801fd5:	29 ef                	sub    %ebp,%edi
  801fd7:	89 fe                	mov    %edi,%esi
  801fd9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801fdd:	89 e9                	mov    %ebp,%ecx
  801fdf:	d3 e0                	shl    %cl,%eax
  801fe1:	89 d7                	mov    %edx,%edi
  801fe3:	89 f1                	mov    %esi,%ecx
  801fe5:	d3 ef                	shr    %cl,%edi
  801fe7:	09 c7                	or     %eax,%edi
  801fe9:	89 e9                	mov    %ebp,%ecx
  801feb:	d3 e2                	shl    %cl,%edx
  801fed:	89 14 24             	mov    %edx,(%esp)
  801ff0:	89 d8                	mov    %ebx,%eax
  801ff2:	d3 e0                	shl    %cl,%eax
  801ff4:	89 c2                	mov    %eax,%edx
  801ff6:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ffa:	d3 e0                	shl    %cl,%eax
  801ffc:	89 44 24 04          	mov    %eax,0x4(%esp)
  802000:	8b 44 24 08          	mov    0x8(%esp),%eax
  802004:	89 f1                	mov    %esi,%ecx
  802006:	d3 e8                	shr    %cl,%eax
  802008:	09 d0                	or     %edx,%eax
  80200a:	d3 eb                	shr    %cl,%ebx
  80200c:	89 da                	mov    %ebx,%edx
  80200e:	f7 f7                	div    %edi
  802010:	89 d3                	mov    %edx,%ebx
  802012:	f7 24 24             	mull   (%esp)
  802015:	89 c6                	mov    %eax,%esi
  802017:	89 d1                	mov    %edx,%ecx
  802019:	39 d3                	cmp    %edx,%ebx
  80201b:	0f 82 87 00 00 00    	jb     8020a8 <__umoddi3+0x134>
  802021:	0f 84 91 00 00 00    	je     8020b8 <__umoddi3+0x144>
  802027:	8b 54 24 04          	mov    0x4(%esp),%edx
  80202b:	29 f2                	sub    %esi,%edx
  80202d:	19 cb                	sbb    %ecx,%ebx
  80202f:	89 d8                	mov    %ebx,%eax
  802031:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802035:	d3 e0                	shl    %cl,%eax
  802037:	89 e9                	mov    %ebp,%ecx
  802039:	d3 ea                	shr    %cl,%edx
  80203b:	09 d0                	or     %edx,%eax
  80203d:	89 e9                	mov    %ebp,%ecx
  80203f:	d3 eb                	shr    %cl,%ebx
  802041:	89 da                	mov    %ebx,%edx
  802043:	83 c4 1c             	add    $0x1c,%esp
  802046:	5b                   	pop    %ebx
  802047:	5e                   	pop    %esi
  802048:	5f                   	pop    %edi
  802049:	5d                   	pop    %ebp
  80204a:	c3                   	ret    
  80204b:	90                   	nop
  80204c:	89 fd                	mov    %edi,%ebp
  80204e:	85 ff                	test   %edi,%edi
  802050:	75 0b                	jne    80205d <__umoddi3+0xe9>
  802052:	b8 01 00 00 00       	mov    $0x1,%eax
  802057:	31 d2                	xor    %edx,%edx
  802059:	f7 f7                	div    %edi
  80205b:	89 c5                	mov    %eax,%ebp
  80205d:	89 f0                	mov    %esi,%eax
  80205f:	31 d2                	xor    %edx,%edx
  802061:	f7 f5                	div    %ebp
  802063:	89 c8                	mov    %ecx,%eax
  802065:	f7 f5                	div    %ebp
  802067:	89 d0                	mov    %edx,%eax
  802069:	e9 44 ff ff ff       	jmp    801fb2 <__umoddi3+0x3e>
  80206e:	66 90                	xchg   %ax,%ax
  802070:	89 c8                	mov    %ecx,%eax
  802072:	89 f2                	mov    %esi,%edx
  802074:	83 c4 1c             	add    $0x1c,%esp
  802077:	5b                   	pop    %ebx
  802078:	5e                   	pop    %esi
  802079:	5f                   	pop    %edi
  80207a:	5d                   	pop    %ebp
  80207b:	c3                   	ret    
  80207c:	3b 04 24             	cmp    (%esp),%eax
  80207f:	72 06                	jb     802087 <__umoddi3+0x113>
  802081:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802085:	77 0f                	ja     802096 <__umoddi3+0x122>
  802087:	89 f2                	mov    %esi,%edx
  802089:	29 f9                	sub    %edi,%ecx
  80208b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80208f:	89 14 24             	mov    %edx,(%esp)
  802092:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802096:	8b 44 24 04          	mov    0x4(%esp),%eax
  80209a:	8b 14 24             	mov    (%esp),%edx
  80209d:	83 c4 1c             	add    $0x1c,%esp
  8020a0:	5b                   	pop    %ebx
  8020a1:	5e                   	pop    %esi
  8020a2:	5f                   	pop    %edi
  8020a3:	5d                   	pop    %ebp
  8020a4:	c3                   	ret    
  8020a5:	8d 76 00             	lea    0x0(%esi),%esi
  8020a8:	2b 04 24             	sub    (%esp),%eax
  8020ab:	19 fa                	sbb    %edi,%edx
  8020ad:	89 d1                	mov    %edx,%ecx
  8020af:	89 c6                	mov    %eax,%esi
  8020b1:	e9 71 ff ff ff       	jmp    802027 <__umoddi3+0xb3>
  8020b6:	66 90                	xchg   %ax,%ax
  8020b8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8020bc:	72 ea                	jb     8020a8 <__umoddi3+0x134>
  8020be:	89 d9                	mov    %ebx,%ecx
  8020c0:	e9 62 ff ff ff       	jmp    802027 <__umoddi3+0xb3>

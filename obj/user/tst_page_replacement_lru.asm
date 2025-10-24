
obj/user/tst_page_replacement_lru:     file format elf32-i386


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
  800031:	e8 fc 02 00 00       	call   800332 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
char arr[PAGE_SIZE*12];
char* ptr = (char* )0x0801000 ;
char* ptr2 = (char* )0x0804000 ;

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	83 ec 6c             	sub    $0x6c,%esp
//	cprintf("envID = %d\n",envID);


	//("STEP 0: checking Initial WS entries ...\n");
	{
		if( ROUNDDOWN(myEnv->__uptr_pws[0].virtual_address,PAGE_SIZE) !=   0x200000)  	panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800041:	a1 20 30 80 00       	mov    0x803020,%eax
  800046:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  80004c:	8b 00                	mov    (%eax),%eax
  80004e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800051:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800054:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800059:	3d 00 00 20 00       	cmp    $0x200000,%eax
  80005e:	74 14                	je     800074 <_main+0x3c>
  800060:	83 ec 04             	sub    $0x4,%esp
  800063:	68 c0 1e 80 00       	push   $0x801ec0
  800068:	6a 13                	push   $0x13
  80006a:	68 04 1f 80 00       	push   $0x801f04
  80006f:	e8 6e 04 00 00       	call   8004e2 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[1].virtual_address,PAGE_SIZE) !=   0x201000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800074:	a1 20 30 80 00       	mov    0x803020,%eax
  800079:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  80007f:	83 c0 18             	add    $0x18,%eax
  800082:	8b 00                	mov    (%eax),%eax
  800084:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800087:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80008a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80008f:	3d 00 10 20 00       	cmp    $0x201000,%eax
  800094:	74 14                	je     8000aa <_main+0x72>
  800096:	83 ec 04             	sub    $0x4,%esp
  800099:	68 c0 1e 80 00       	push   $0x801ec0
  80009e:	6a 14                	push   $0x14
  8000a0:	68 04 1f 80 00       	push   $0x801f04
  8000a5:	e8 38 04 00 00       	call   8004e2 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[2].virtual_address,PAGE_SIZE) !=   0x202000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8000aa:	a1 20 30 80 00       	mov    0x803020,%eax
  8000af:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  8000b5:	83 c0 30             	add    $0x30,%eax
  8000b8:	8b 00                	mov    (%eax),%eax
  8000ba:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8000bd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8000c0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8000c5:	3d 00 20 20 00       	cmp    $0x202000,%eax
  8000ca:	74 14                	je     8000e0 <_main+0xa8>
  8000cc:	83 ec 04             	sub    $0x4,%esp
  8000cf:	68 c0 1e 80 00       	push   $0x801ec0
  8000d4:	6a 15                	push   $0x15
  8000d6:	68 04 1f 80 00       	push   $0x801f04
  8000db:	e8 02 04 00 00       	call   8004e2 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[3].virtual_address,PAGE_SIZE) !=   0x203000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8000e0:	a1 20 30 80 00       	mov    0x803020,%eax
  8000e5:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  8000eb:	83 c0 48             	add    $0x48,%eax
  8000ee:	8b 00                	mov    (%eax),%eax
  8000f0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8000f3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8000f6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8000fb:	3d 00 30 20 00       	cmp    $0x203000,%eax
  800100:	74 14                	je     800116 <_main+0xde>
  800102:	83 ec 04             	sub    $0x4,%esp
  800105:	68 c0 1e 80 00       	push   $0x801ec0
  80010a:	6a 16                	push   $0x16
  80010c:	68 04 1f 80 00       	push   $0x801f04
  800111:	e8 cc 03 00 00       	call   8004e2 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[4].virtual_address,PAGE_SIZE) !=   0x204000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800116:	a1 20 30 80 00       	mov    0x803020,%eax
  80011b:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  800121:	83 c0 60             	add    $0x60,%eax
  800124:	8b 00                	mov    (%eax),%eax
  800126:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800129:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80012c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800131:	3d 00 40 20 00       	cmp    $0x204000,%eax
  800136:	74 14                	je     80014c <_main+0x114>
  800138:	83 ec 04             	sub    $0x4,%esp
  80013b:	68 c0 1e 80 00       	push   $0x801ec0
  800140:	6a 17                	push   $0x17
  800142:	68 04 1f 80 00       	push   $0x801f04
  800147:	e8 96 03 00 00       	call   8004e2 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[5].virtual_address,PAGE_SIZE) !=   0x205000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80014c:	a1 20 30 80 00       	mov    0x803020,%eax
  800151:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  800157:	83 c0 78             	add    $0x78,%eax
  80015a:	8b 00                	mov    (%eax),%eax
  80015c:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80015f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800162:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800167:	3d 00 50 20 00       	cmp    $0x205000,%eax
  80016c:	74 14                	je     800182 <_main+0x14a>
  80016e:	83 ec 04             	sub    $0x4,%esp
  800171:	68 c0 1e 80 00       	push   $0x801ec0
  800176:	6a 18                	push   $0x18
  800178:	68 04 1f 80 00       	push   $0x801f04
  80017d:	e8 60 03 00 00       	call   8004e2 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[6].virtual_address,PAGE_SIZE) !=   0x800000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800182:	a1 20 30 80 00       	mov    0x803020,%eax
  800187:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  80018d:	05 90 00 00 00       	add    $0x90,%eax
  800192:	8b 00                	mov    (%eax),%eax
  800194:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800197:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80019a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80019f:	3d 00 00 80 00       	cmp    $0x800000,%eax
  8001a4:	74 14                	je     8001ba <_main+0x182>
  8001a6:	83 ec 04             	sub    $0x4,%esp
  8001a9:	68 c0 1e 80 00       	push   $0x801ec0
  8001ae:	6a 19                	push   $0x19
  8001b0:	68 04 1f 80 00       	push   $0x801f04
  8001b5:	e8 28 03 00 00       	call   8004e2 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[7].virtual_address,PAGE_SIZE) !=   0x801000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8001ba:	a1 20 30 80 00       	mov    0x803020,%eax
  8001bf:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  8001c5:	05 a8 00 00 00       	add    $0xa8,%eax
  8001ca:	8b 00                	mov    (%eax),%eax
  8001cc:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8001cf:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8001d2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001d7:	3d 00 10 80 00       	cmp    $0x801000,%eax
  8001dc:	74 14                	je     8001f2 <_main+0x1ba>
  8001de:	83 ec 04             	sub    $0x4,%esp
  8001e1:	68 c0 1e 80 00       	push   $0x801ec0
  8001e6:	6a 1a                	push   $0x1a
  8001e8:	68 04 1f 80 00       	push   $0x801f04
  8001ed:	e8 f0 02 00 00       	call   8004e2 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[8].virtual_address,PAGE_SIZE) !=   0x802000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8001f2:	a1 20 30 80 00       	mov    0x803020,%eax
  8001f7:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  8001fd:	05 c0 00 00 00       	add    $0xc0,%eax
  800202:	8b 00                	mov    (%eax),%eax
  800204:	89 45 c0             	mov    %eax,-0x40(%ebp)
  800207:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80020a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80020f:	3d 00 20 80 00       	cmp    $0x802000,%eax
  800214:	74 14                	je     80022a <_main+0x1f2>
  800216:	83 ec 04             	sub    $0x4,%esp
  800219:	68 c0 1e 80 00       	push   $0x801ec0
  80021e:	6a 1b                	push   $0x1b
  800220:	68 04 1f 80 00       	push   $0x801f04
  800225:	e8 b8 02 00 00       	call   8004e2 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[9].virtual_address,PAGE_SIZE) !=   0x803000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80022a:	a1 20 30 80 00       	mov    0x803020,%eax
  80022f:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  800235:	05 d8 00 00 00       	add    $0xd8,%eax
  80023a:	8b 00                	mov    (%eax),%eax
  80023c:	89 45 bc             	mov    %eax,-0x44(%ebp)
  80023f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800242:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800247:	3d 00 30 80 00       	cmp    $0x803000,%eax
  80024c:	74 14                	je     800262 <_main+0x22a>
  80024e:	83 ec 04             	sub    $0x4,%esp
  800251:	68 c0 1e 80 00       	push   $0x801ec0
  800256:	6a 1c                	push   $0x1c
  800258:	68 04 1f 80 00       	push   $0x801f04
  80025d:	e8 80 02 00 00       	call   8004e2 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[10].virtual_address,PAGE_SIZE) !=   0xeebfd000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800262:	a1 20 30 80 00       	mov    0x803020,%eax
  800267:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  80026d:	05 f0 00 00 00       	add    $0xf0,%eax
  800272:	8b 00                	mov    (%eax),%eax
  800274:	89 45 b8             	mov    %eax,-0x48(%ebp)
  800277:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80027a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80027f:	3d 00 d0 bf ee       	cmp    $0xeebfd000,%eax
  800284:	74 14                	je     80029a <_main+0x262>
  800286:	83 ec 04             	sub    $0x4,%esp
  800289:	68 c0 1e 80 00       	push   $0x801ec0
  80028e:	6a 1d                	push   $0x1d
  800290:	68 04 1f 80 00       	push   $0x801f04
  800295:	e8 48 02 00 00       	call   8004e2 <_panic>
		/*NO NEED FOR THIS AS WE WORK ON "LRU"*/
		//if( myEnv->page_last_WS_index !=  0)  										panic("INITIAL PAGE WS last index checking failed! Review size of the WS..!!");
	}

	//Reading (Not Modified)
	char garbage1 = arr[PAGE_SIZE*11-1] ;
  80029a:	a0 5f e0 80 00       	mov    0x80e05f,%al
  80029f:	88 45 b7             	mov    %al,-0x49(%ebp)
	char garbage2 = arr[PAGE_SIZE*12-1] ;
  8002a2:	a0 5f f0 80 00       	mov    0x80f05f,%al
  8002a7:	88 45 b6             	mov    %al,-0x4a(%ebp)

	//Writing (Modified)
	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  8002aa:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8002b1:	eb 37                	jmp    8002ea <_main+0x2b2>
	{
		arr[i] = -1 ;
  8002b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002b6:	05 60 30 80 00       	add    $0x803060,%eax
  8002bb:	c6 00 ff             	movb   $0xff,(%eax)
		/*2016: this BUGGY line is REMOVED el7! it overwrites the KERNEL CODE :( !!!*/
		//*ptr = *ptr2 ;
		/*==========================================================================*/
		//always use pages at 0x801000 and 0x804000
		*ptr2 = *ptr ;
  8002be:	a1 04 30 80 00       	mov    0x803004,%eax
  8002c3:	8b 15 00 30 80 00    	mov    0x803000,%edx
  8002c9:	8a 12                	mov    (%edx),%dl
  8002cb:	88 10                	mov    %dl,(%eax)
		ptr++ ; ptr2++ ;
  8002cd:	a1 00 30 80 00       	mov    0x803000,%eax
  8002d2:	40                   	inc    %eax
  8002d3:	a3 00 30 80 00       	mov    %eax,0x803000
  8002d8:	a1 04 30 80 00       	mov    0x803004,%eax
  8002dd:	40                   	inc    %eax
  8002de:	a3 04 30 80 00       	mov    %eax,0x803004
	char garbage1 = arr[PAGE_SIZE*11-1] ;
	char garbage2 = arr[PAGE_SIZE*12-1] ;

	//Writing (Modified)
	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  8002e3:	81 45 e4 00 08 00 00 	addl   $0x800,-0x1c(%ebp)
  8002ea:	81 7d e4 ff 9f 00 00 	cmpl   $0x9fff,-0x1c(%ebp)
  8002f1:	7e c0                	jle    8002b3 <_main+0x27b>
		ptr++ ; ptr2++ ;
	}

	//===================

	uint32 expectedPages[11] = {0x809000,0x80a000,0x804000,0x80b000,0x80c000,0x800000,0x801000,0x808000,0x803000,0xeebfd000,0};
  8002f3:	8d 45 88             	lea    -0x78(%ebp),%eax
  8002f6:	bb 80 1f 80 00       	mov    $0x801f80,%ebx
  8002fb:	ba 0b 00 00 00       	mov    $0xb,%edx
  800300:	89 c7                	mov    %eax,%edi
  800302:	89 de                	mov    %ebx,%esi
  800304:	89 d1                	mov    %edx,%ecx
  800306:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

	//cprintf("Checking PAGE LRU algorithm... \n");
	{
		CheckWSArrayWithoutLastIndex(expectedPages, 11);
  800308:	83 ec 08             	sub    $0x8,%esp
  80030b:	6a 0b                	push   $0xb
  80030d:	8d 45 88             	lea    -0x78(%ebp),%eax
  800310:	50                   	push   %eax
  800311:	e8 43 02 00 00       	call   800559 <CheckWSArrayWithoutLastIndex>
  800316:	83 c4 10             	add    $0x10,%esp
		/*NO NEED FOR THIS AS WE WORK ON "LRU"*/
		//if(myEnv->page_last_WS_index != 5) panic("wrong PAGE WS pointer location");

	}

	cprintf("Congratulations!! test PAGE replacement [LRU Alg.] is completed successfully.\n");
  800319:	83 ec 0c             	sub    $0xc,%esp
  80031c:	68 24 1f 80 00       	push   $0x801f24
  800321:	e8 8a 04 00 00       	call   8007b0 <cprintf>
  800326:	83 c4 10             	add    $0x10,%esp
	return;
  800329:	90                   	nop
}
  80032a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80032d:	5b                   	pop    %ebx
  80032e:	5e                   	pop    %esi
  80032f:	5f                   	pop    %edi
  800330:	5d                   	pop    %ebp
  800331:	c3                   	ret    

00800332 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800332:	55                   	push   %ebp
  800333:	89 e5                	mov    %esp,%ebp
  800335:	57                   	push   %edi
  800336:	56                   	push   %esi
  800337:	53                   	push   %ebx
  800338:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80033b:	e8 3d 16 00 00       	call   80197d <sys_getenvindex>
  800340:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800343:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800346:	89 d0                	mov    %edx,%eax
  800348:	c1 e0 02             	shl    $0x2,%eax
  80034b:	01 d0                	add    %edx,%eax
  80034d:	c1 e0 03             	shl    $0x3,%eax
  800350:	01 d0                	add    %edx,%eax
  800352:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800359:	01 d0                	add    %edx,%eax
  80035b:	c1 e0 02             	shl    $0x2,%eax
  80035e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800363:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800368:	a1 20 30 80 00       	mov    0x803020,%eax
  80036d:	8a 40 20             	mov    0x20(%eax),%al
  800370:	84 c0                	test   %al,%al
  800372:	74 0d                	je     800381 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800374:	a1 20 30 80 00       	mov    0x803020,%eax
  800379:	83 c0 20             	add    $0x20,%eax
  80037c:	a3 0c 30 80 00       	mov    %eax,0x80300c

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800381:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800385:	7e 0a                	jle    800391 <libmain+0x5f>
		binaryname = argv[0];
  800387:	8b 45 0c             	mov    0xc(%ebp),%eax
  80038a:	8b 00                	mov    (%eax),%eax
  80038c:	a3 0c 30 80 00       	mov    %eax,0x80300c

	// call user main routine
	_main(argc, argv);
  800391:	83 ec 08             	sub    $0x8,%esp
  800394:	ff 75 0c             	pushl  0xc(%ebp)
  800397:	ff 75 08             	pushl  0x8(%ebp)
  80039a:	e8 99 fc ff ff       	call   800038 <_main>
  80039f:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8003a2:	a1 08 30 80 00       	mov    0x803008,%eax
  8003a7:	85 c0                	test   %eax,%eax
  8003a9:	0f 84 01 01 00 00    	je     8004b0 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8003af:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8003b5:	bb a4 20 80 00       	mov    $0x8020a4,%ebx
  8003ba:	ba 0e 00 00 00       	mov    $0xe,%edx
  8003bf:	89 c7                	mov    %eax,%edi
  8003c1:	89 de                	mov    %ebx,%esi
  8003c3:	89 d1                	mov    %edx,%ecx
  8003c5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8003c7:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8003ca:	b9 56 00 00 00       	mov    $0x56,%ecx
  8003cf:	b0 00                	mov    $0x0,%al
  8003d1:	89 d7                	mov    %edx,%edi
  8003d3:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8003d5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8003dc:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8003df:	83 ec 08             	sub    $0x8,%esp
  8003e2:	50                   	push   %eax
  8003e3:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8003e9:	50                   	push   %eax
  8003ea:	e8 c4 17 00 00       	call   801bb3 <sys_utilities>
  8003ef:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8003f2:	e8 0d 13 00 00       	call   801704 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8003f7:	83 ec 0c             	sub    $0xc,%esp
  8003fa:	68 c4 1f 80 00       	push   $0x801fc4
  8003ff:	e8 ac 03 00 00       	call   8007b0 <cprintf>
  800404:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800407:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80040a:	85 c0                	test   %eax,%eax
  80040c:	74 18                	je     800426 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80040e:	e8 be 17 00 00       	call   801bd1 <sys_get_optimal_num_faults>
  800413:	83 ec 08             	sub    $0x8,%esp
  800416:	50                   	push   %eax
  800417:	68 ec 1f 80 00       	push   $0x801fec
  80041c:	e8 8f 03 00 00       	call   8007b0 <cprintf>
  800421:	83 c4 10             	add    $0x10,%esp
  800424:	eb 59                	jmp    80047f <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800426:	a1 20 30 80 00       	mov    0x803020,%eax
  80042b:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  800431:	a1 20 30 80 00       	mov    0x803020,%eax
  800436:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  80043c:	83 ec 04             	sub    $0x4,%esp
  80043f:	52                   	push   %edx
  800440:	50                   	push   %eax
  800441:	68 10 20 80 00       	push   $0x802010
  800446:	e8 65 03 00 00       	call   8007b0 <cprintf>
  80044b:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80044e:	a1 20 30 80 00       	mov    0x803020,%eax
  800453:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800459:	a1 20 30 80 00       	mov    0x803020,%eax
  80045e:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  800464:	a1 20 30 80 00       	mov    0x803020,%eax
  800469:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  80046f:	51                   	push   %ecx
  800470:	52                   	push   %edx
  800471:	50                   	push   %eax
  800472:	68 38 20 80 00       	push   $0x802038
  800477:	e8 34 03 00 00       	call   8007b0 <cprintf>
  80047c:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80047f:	a1 20 30 80 00       	mov    0x803020,%eax
  800484:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  80048a:	83 ec 08             	sub    $0x8,%esp
  80048d:	50                   	push   %eax
  80048e:	68 90 20 80 00       	push   $0x802090
  800493:	e8 18 03 00 00       	call   8007b0 <cprintf>
  800498:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80049b:	83 ec 0c             	sub    $0xc,%esp
  80049e:	68 c4 1f 80 00       	push   $0x801fc4
  8004a3:	e8 08 03 00 00       	call   8007b0 <cprintf>
  8004a8:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8004ab:	e8 6e 12 00 00       	call   80171e <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8004b0:	e8 1f 00 00 00       	call   8004d4 <exit>
}
  8004b5:	90                   	nop
  8004b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004b9:	5b                   	pop    %ebx
  8004ba:	5e                   	pop    %esi
  8004bb:	5f                   	pop    %edi
  8004bc:	5d                   	pop    %ebp
  8004bd:	c3                   	ret    

008004be <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8004be:	55                   	push   %ebp
  8004bf:	89 e5                	mov    %esp,%ebp
  8004c1:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8004c4:	83 ec 0c             	sub    $0xc,%esp
  8004c7:	6a 00                	push   $0x0
  8004c9:	e8 7b 14 00 00       	call   801949 <sys_destroy_env>
  8004ce:	83 c4 10             	add    $0x10,%esp
}
  8004d1:	90                   	nop
  8004d2:	c9                   	leave  
  8004d3:	c3                   	ret    

008004d4 <exit>:

void
exit(void)
{
  8004d4:	55                   	push   %ebp
  8004d5:	89 e5                	mov    %esp,%ebp
  8004d7:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8004da:	e8 d0 14 00 00       	call   8019af <sys_exit_env>
}
  8004df:	90                   	nop
  8004e0:	c9                   	leave  
  8004e1:	c3                   	ret    

008004e2 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8004e2:	55                   	push   %ebp
  8004e3:	89 e5                	mov    %esp,%ebp
  8004e5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8004e8:	8d 45 10             	lea    0x10(%ebp),%eax
  8004eb:	83 c0 04             	add    $0x4,%eax
  8004ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8004f1:	a1 38 71 82 00       	mov    0x827138,%eax
  8004f6:	85 c0                	test   %eax,%eax
  8004f8:	74 16                	je     800510 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8004fa:	a1 38 71 82 00       	mov    0x827138,%eax
  8004ff:	83 ec 08             	sub    $0x8,%esp
  800502:	50                   	push   %eax
  800503:	68 08 21 80 00       	push   $0x802108
  800508:	e8 a3 02 00 00       	call   8007b0 <cprintf>
  80050d:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800510:	a1 0c 30 80 00       	mov    0x80300c,%eax
  800515:	83 ec 0c             	sub    $0xc,%esp
  800518:	ff 75 0c             	pushl  0xc(%ebp)
  80051b:	ff 75 08             	pushl  0x8(%ebp)
  80051e:	50                   	push   %eax
  80051f:	68 10 21 80 00       	push   $0x802110
  800524:	6a 74                	push   $0x74
  800526:	e8 b2 02 00 00       	call   8007dd <cprintf_colored>
  80052b:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  80052e:	8b 45 10             	mov    0x10(%ebp),%eax
  800531:	83 ec 08             	sub    $0x8,%esp
  800534:	ff 75 f4             	pushl  -0xc(%ebp)
  800537:	50                   	push   %eax
  800538:	e8 04 02 00 00       	call   800741 <vcprintf>
  80053d:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800540:	83 ec 08             	sub    $0x8,%esp
  800543:	6a 00                	push   $0x0
  800545:	68 38 21 80 00       	push   $0x802138
  80054a:	e8 f2 01 00 00       	call   800741 <vcprintf>
  80054f:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800552:	e8 7d ff ff ff       	call   8004d4 <exit>

	// should not return here
	while (1) ;
  800557:	eb fe                	jmp    800557 <_panic+0x75>

00800559 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800559:	55                   	push   %ebp
  80055a:	89 e5                	mov    %esp,%ebp
  80055c:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80055f:	a1 20 30 80 00       	mov    0x803020,%eax
  800564:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80056a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80056d:	39 c2                	cmp    %eax,%edx
  80056f:	74 14                	je     800585 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800571:	83 ec 04             	sub    $0x4,%esp
  800574:	68 3c 21 80 00       	push   $0x80213c
  800579:	6a 26                	push   $0x26
  80057b:	68 88 21 80 00       	push   $0x802188
  800580:	e8 5d ff ff ff       	call   8004e2 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800585:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80058c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800593:	e9 c5 00 00 00       	jmp    80065d <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800598:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80059b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a5:	01 d0                	add    %edx,%eax
  8005a7:	8b 00                	mov    (%eax),%eax
  8005a9:	85 c0                	test   %eax,%eax
  8005ab:	75 08                	jne    8005b5 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8005ad:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8005b0:	e9 a5 00 00 00       	jmp    80065a <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8005b5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005bc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005c3:	eb 69                	jmp    80062e <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8005c5:	a1 20 30 80 00       	mov    0x803020,%eax
  8005ca:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8005d0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005d3:	89 d0                	mov    %edx,%eax
  8005d5:	01 c0                	add    %eax,%eax
  8005d7:	01 d0                	add    %edx,%eax
  8005d9:	c1 e0 03             	shl    $0x3,%eax
  8005dc:	01 c8                	add    %ecx,%eax
  8005de:	8a 40 04             	mov    0x4(%eax),%al
  8005e1:	84 c0                	test   %al,%al
  8005e3:	75 46                	jne    80062b <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005e5:	a1 20 30 80 00       	mov    0x803020,%eax
  8005ea:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8005f0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005f3:	89 d0                	mov    %edx,%eax
  8005f5:	01 c0                	add    %eax,%eax
  8005f7:	01 d0                	add    %edx,%eax
  8005f9:	c1 e0 03             	shl    $0x3,%eax
  8005fc:	01 c8                	add    %ecx,%eax
  8005fe:	8b 00                	mov    (%eax),%eax
  800600:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800603:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800606:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80060b:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80060d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800610:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800617:	8b 45 08             	mov    0x8(%ebp),%eax
  80061a:	01 c8                	add    %ecx,%eax
  80061c:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80061e:	39 c2                	cmp    %eax,%edx
  800620:	75 09                	jne    80062b <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800622:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800629:	eb 15                	jmp    800640 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80062b:	ff 45 e8             	incl   -0x18(%ebp)
  80062e:	a1 20 30 80 00       	mov    0x803020,%eax
  800633:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800639:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80063c:	39 c2                	cmp    %eax,%edx
  80063e:	77 85                	ja     8005c5 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800640:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800644:	75 14                	jne    80065a <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800646:	83 ec 04             	sub    $0x4,%esp
  800649:	68 94 21 80 00       	push   $0x802194
  80064e:	6a 3a                	push   $0x3a
  800650:	68 88 21 80 00       	push   $0x802188
  800655:	e8 88 fe ff ff       	call   8004e2 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80065a:	ff 45 f0             	incl   -0x10(%ebp)
  80065d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800660:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800663:	0f 8c 2f ff ff ff    	jl     800598 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800669:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800670:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800677:	eb 26                	jmp    80069f <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800679:	a1 20 30 80 00       	mov    0x803020,%eax
  80067e:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800684:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800687:	89 d0                	mov    %edx,%eax
  800689:	01 c0                	add    %eax,%eax
  80068b:	01 d0                	add    %edx,%eax
  80068d:	c1 e0 03             	shl    $0x3,%eax
  800690:	01 c8                	add    %ecx,%eax
  800692:	8a 40 04             	mov    0x4(%eax),%al
  800695:	3c 01                	cmp    $0x1,%al
  800697:	75 03                	jne    80069c <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800699:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80069c:	ff 45 e0             	incl   -0x20(%ebp)
  80069f:	a1 20 30 80 00       	mov    0x803020,%eax
  8006a4:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8006aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006ad:	39 c2                	cmp    %eax,%edx
  8006af:	77 c8                	ja     800679 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8006b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006b4:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8006b7:	74 14                	je     8006cd <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8006b9:	83 ec 04             	sub    $0x4,%esp
  8006bc:	68 e8 21 80 00       	push   $0x8021e8
  8006c1:	6a 44                	push   $0x44
  8006c3:	68 88 21 80 00       	push   $0x802188
  8006c8:	e8 15 fe ff ff       	call   8004e2 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8006cd:	90                   	nop
  8006ce:	c9                   	leave  
  8006cf:	c3                   	ret    

008006d0 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8006d0:	55                   	push   %ebp
  8006d1:	89 e5                	mov    %esp,%ebp
  8006d3:	53                   	push   %ebx
  8006d4:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8006d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006da:	8b 00                	mov    (%eax),%eax
  8006dc:	8d 48 01             	lea    0x1(%eax),%ecx
  8006df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006e2:	89 0a                	mov    %ecx,(%edx)
  8006e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8006e7:	88 d1                	mov    %dl,%cl
  8006e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006ec:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8006f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006f3:	8b 00                	mov    (%eax),%eax
  8006f5:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006fa:	75 30                	jne    80072c <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8006fc:	8b 15 3c 71 82 00    	mov    0x82713c,%edx
  800702:	a0 60 f0 80 00       	mov    0x80f060,%al
  800707:	0f b6 c0             	movzbl %al,%eax
  80070a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80070d:	8b 09                	mov    (%ecx),%ecx
  80070f:	89 cb                	mov    %ecx,%ebx
  800711:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800714:	83 c1 08             	add    $0x8,%ecx
  800717:	52                   	push   %edx
  800718:	50                   	push   %eax
  800719:	53                   	push   %ebx
  80071a:	51                   	push   %ecx
  80071b:	e8 a0 0f 00 00       	call   8016c0 <sys_cputs>
  800720:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800723:	8b 45 0c             	mov    0xc(%ebp),%eax
  800726:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80072c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80072f:	8b 40 04             	mov    0x4(%eax),%eax
  800732:	8d 50 01             	lea    0x1(%eax),%edx
  800735:	8b 45 0c             	mov    0xc(%ebp),%eax
  800738:	89 50 04             	mov    %edx,0x4(%eax)
}
  80073b:	90                   	nop
  80073c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80073f:	c9                   	leave  
  800740:	c3                   	ret    

00800741 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800741:	55                   	push   %ebp
  800742:	89 e5                	mov    %esp,%ebp
  800744:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80074a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800751:	00 00 00 
	b.cnt = 0;
  800754:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80075b:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80075e:	ff 75 0c             	pushl  0xc(%ebp)
  800761:	ff 75 08             	pushl  0x8(%ebp)
  800764:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80076a:	50                   	push   %eax
  80076b:	68 d0 06 80 00       	push   $0x8006d0
  800770:	e8 5a 02 00 00       	call   8009cf <vprintfmt>
  800775:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800778:	8b 15 3c 71 82 00    	mov    0x82713c,%edx
  80077e:	a0 60 f0 80 00       	mov    0x80f060,%al
  800783:	0f b6 c0             	movzbl %al,%eax
  800786:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  80078c:	52                   	push   %edx
  80078d:	50                   	push   %eax
  80078e:	51                   	push   %ecx
  80078f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800795:	83 c0 08             	add    $0x8,%eax
  800798:	50                   	push   %eax
  800799:	e8 22 0f 00 00       	call   8016c0 <sys_cputs>
  80079e:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8007a1:	c6 05 60 f0 80 00 00 	movb   $0x0,0x80f060
	return b.cnt;
  8007a8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8007ae:	c9                   	leave  
  8007af:	c3                   	ret    

008007b0 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8007b0:	55                   	push   %ebp
  8007b1:	89 e5                	mov    %esp,%ebp
  8007b3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8007b6:	c6 05 60 f0 80 00 01 	movb   $0x1,0x80f060
	va_start(ap, fmt);
  8007bd:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c6:	83 ec 08             	sub    $0x8,%esp
  8007c9:	ff 75 f4             	pushl  -0xc(%ebp)
  8007cc:	50                   	push   %eax
  8007cd:	e8 6f ff ff ff       	call   800741 <vcprintf>
  8007d2:	83 c4 10             	add    $0x10,%esp
  8007d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8007d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007db:	c9                   	leave  
  8007dc:	c3                   	ret    

008007dd <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8007dd:	55                   	push   %ebp
  8007de:	89 e5                	mov    %esp,%ebp
  8007e0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8007e3:	c6 05 60 f0 80 00 01 	movb   $0x1,0x80f060
	curTextClr = (textClr << 8) ; //set text color by the given value
  8007ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ed:	c1 e0 08             	shl    $0x8,%eax
  8007f0:	a3 3c 71 82 00       	mov    %eax,0x82713c
	va_start(ap, fmt);
  8007f5:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007f8:	83 c0 04             	add    $0x4,%eax
  8007fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800801:	83 ec 08             	sub    $0x8,%esp
  800804:	ff 75 f4             	pushl  -0xc(%ebp)
  800807:	50                   	push   %eax
  800808:	e8 34 ff ff ff       	call   800741 <vcprintf>
  80080d:	83 c4 10             	add    $0x10,%esp
  800810:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800813:	c7 05 3c 71 82 00 00 	movl   $0x700,0x82713c
  80081a:	07 00 00 

	return cnt;
  80081d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800820:	c9                   	leave  
  800821:	c3                   	ret    

00800822 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800822:	55                   	push   %ebp
  800823:	89 e5                	mov    %esp,%ebp
  800825:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800828:	e8 d7 0e 00 00       	call   801704 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80082d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800830:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800833:	8b 45 08             	mov    0x8(%ebp),%eax
  800836:	83 ec 08             	sub    $0x8,%esp
  800839:	ff 75 f4             	pushl  -0xc(%ebp)
  80083c:	50                   	push   %eax
  80083d:	e8 ff fe ff ff       	call   800741 <vcprintf>
  800842:	83 c4 10             	add    $0x10,%esp
  800845:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800848:	e8 d1 0e 00 00       	call   80171e <sys_unlock_cons>
	return cnt;
  80084d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800850:	c9                   	leave  
  800851:	c3                   	ret    

00800852 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800852:	55                   	push   %ebp
  800853:	89 e5                	mov    %esp,%ebp
  800855:	53                   	push   %ebx
  800856:	83 ec 14             	sub    $0x14,%esp
  800859:	8b 45 10             	mov    0x10(%ebp),%eax
  80085c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80085f:	8b 45 14             	mov    0x14(%ebp),%eax
  800862:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800865:	8b 45 18             	mov    0x18(%ebp),%eax
  800868:	ba 00 00 00 00       	mov    $0x0,%edx
  80086d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800870:	77 55                	ja     8008c7 <printnum+0x75>
  800872:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800875:	72 05                	jb     80087c <printnum+0x2a>
  800877:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80087a:	77 4b                	ja     8008c7 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80087c:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80087f:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800882:	8b 45 18             	mov    0x18(%ebp),%eax
  800885:	ba 00 00 00 00       	mov    $0x0,%edx
  80088a:	52                   	push   %edx
  80088b:	50                   	push   %eax
  80088c:	ff 75 f4             	pushl  -0xc(%ebp)
  80088f:	ff 75 f0             	pushl  -0x10(%ebp)
  800892:	e8 a9 13 00 00       	call   801c40 <__udivdi3>
  800897:	83 c4 10             	add    $0x10,%esp
  80089a:	83 ec 04             	sub    $0x4,%esp
  80089d:	ff 75 20             	pushl  0x20(%ebp)
  8008a0:	53                   	push   %ebx
  8008a1:	ff 75 18             	pushl  0x18(%ebp)
  8008a4:	52                   	push   %edx
  8008a5:	50                   	push   %eax
  8008a6:	ff 75 0c             	pushl  0xc(%ebp)
  8008a9:	ff 75 08             	pushl  0x8(%ebp)
  8008ac:	e8 a1 ff ff ff       	call   800852 <printnum>
  8008b1:	83 c4 20             	add    $0x20,%esp
  8008b4:	eb 1a                	jmp    8008d0 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8008b6:	83 ec 08             	sub    $0x8,%esp
  8008b9:	ff 75 0c             	pushl  0xc(%ebp)
  8008bc:	ff 75 20             	pushl  0x20(%ebp)
  8008bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c2:	ff d0                	call   *%eax
  8008c4:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8008c7:	ff 4d 1c             	decl   0x1c(%ebp)
  8008ca:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8008ce:	7f e6                	jg     8008b6 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8008d0:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8008d3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8008d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008db:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008de:	53                   	push   %ebx
  8008df:	51                   	push   %ecx
  8008e0:	52                   	push   %edx
  8008e1:	50                   	push   %eax
  8008e2:	e8 69 14 00 00       	call   801d50 <__umoddi3>
  8008e7:	83 c4 10             	add    $0x10,%esp
  8008ea:	05 54 24 80 00       	add    $0x802454,%eax
  8008ef:	8a 00                	mov    (%eax),%al
  8008f1:	0f be c0             	movsbl %al,%eax
  8008f4:	83 ec 08             	sub    $0x8,%esp
  8008f7:	ff 75 0c             	pushl  0xc(%ebp)
  8008fa:	50                   	push   %eax
  8008fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fe:	ff d0                	call   *%eax
  800900:	83 c4 10             	add    $0x10,%esp
}
  800903:	90                   	nop
  800904:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800907:	c9                   	leave  
  800908:	c3                   	ret    

00800909 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800909:	55                   	push   %ebp
  80090a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80090c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800910:	7e 1c                	jle    80092e <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800912:	8b 45 08             	mov    0x8(%ebp),%eax
  800915:	8b 00                	mov    (%eax),%eax
  800917:	8d 50 08             	lea    0x8(%eax),%edx
  80091a:	8b 45 08             	mov    0x8(%ebp),%eax
  80091d:	89 10                	mov    %edx,(%eax)
  80091f:	8b 45 08             	mov    0x8(%ebp),%eax
  800922:	8b 00                	mov    (%eax),%eax
  800924:	83 e8 08             	sub    $0x8,%eax
  800927:	8b 50 04             	mov    0x4(%eax),%edx
  80092a:	8b 00                	mov    (%eax),%eax
  80092c:	eb 40                	jmp    80096e <getuint+0x65>
	else if (lflag)
  80092e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800932:	74 1e                	je     800952 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800934:	8b 45 08             	mov    0x8(%ebp),%eax
  800937:	8b 00                	mov    (%eax),%eax
  800939:	8d 50 04             	lea    0x4(%eax),%edx
  80093c:	8b 45 08             	mov    0x8(%ebp),%eax
  80093f:	89 10                	mov    %edx,(%eax)
  800941:	8b 45 08             	mov    0x8(%ebp),%eax
  800944:	8b 00                	mov    (%eax),%eax
  800946:	83 e8 04             	sub    $0x4,%eax
  800949:	8b 00                	mov    (%eax),%eax
  80094b:	ba 00 00 00 00       	mov    $0x0,%edx
  800950:	eb 1c                	jmp    80096e <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800952:	8b 45 08             	mov    0x8(%ebp),%eax
  800955:	8b 00                	mov    (%eax),%eax
  800957:	8d 50 04             	lea    0x4(%eax),%edx
  80095a:	8b 45 08             	mov    0x8(%ebp),%eax
  80095d:	89 10                	mov    %edx,(%eax)
  80095f:	8b 45 08             	mov    0x8(%ebp),%eax
  800962:	8b 00                	mov    (%eax),%eax
  800964:	83 e8 04             	sub    $0x4,%eax
  800967:	8b 00                	mov    (%eax),%eax
  800969:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80096e:	5d                   	pop    %ebp
  80096f:	c3                   	ret    

00800970 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800970:	55                   	push   %ebp
  800971:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800973:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800977:	7e 1c                	jle    800995 <getint+0x25>
		return va_arg(*ap, long long);
  800979:	8b 45 08             	mov    0x8(%ebp),%eax
  80097c:	8b 00                	mov    (%eax),%eax
  80097e:	8d 50 08             	lea    0x8(%eax),%edx
  800981:	8b 45 08             	mov    0x8(%ebp),%eax
  800984:	89 10                	mov    %edx,(%eax)
  800986:	8b 45 08             	mov    0x8(%ebp),%eax
  800989:	8b 00                	mov    (%eax),%eax
  80098b:	83 e8 08             	sub    $0x8,%eax
  80098e:	8b 50 04             	mov    0x4(%eax),%edx
  800991:	8b 00                	mov    (%eax),%eax
  800993:	eb 38                	jmp    8009cd <getint+0x5d>
	else if (lflag)
  800995:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800999:	74 1a                	je     8009b5 <getint+0x45>
		return va_arg(*ap, long);
  80099b:	8b 45 08             	mov    0x8(%ebp),%eax
  80099e:	8b 00                	mov    (%eax),%eax
  8009a0:	8d 50 04             	lea    0x4(%eax),%edx
  8009a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a6:	89 10                	mov    %edx,(%eax)
  8009a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ab:	8b 00                	mov    (%eax),%eax
  8009ad:	83 e8 04             	sub    $0x4,%eax
  8009b0:	8b 00                	mov    (%eax),%eax
  8009b2:	99                   	cltd   
  8009b3:	eb 18                	jmp    8009cd <getint+0x5d>
	else
		return va_arg(*ap, int);
  8009b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b8:	8b 00                	mov    (%eax),%eax
  8009ba:	8d 50 04             	lea    0x4(%eax),%edx
  8009bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c0:	89 10                	mov    %edx,(%eax)
  8009c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c5:	8b 00                	mov    (%eax),%eax
  8009c7:	83 e8 04             	sub    $0x4,%eax
  8009ca:	8b 00                	mov    (%eax),%eax
  8009cc:	99                   	cltd   
}
  8009cd:	5d                   	pop    %ebp
  8009ce:	c3                   	ret    

008009cf <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8009cf:	55                   	push   %ebp
  8009d0:	89 e5                	mov    %esp,%ebp
  8009d2:	56                   	push   %esi
  8009d3:	53                   	push   %ebx
  8009d4:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009d7:	eb 17                	jmp    8009f0 <vprintfmt+0x21>
			if (ch == '\0')
  8009d9:	85 db                	test   %ebx,%ebx
  8009db:	0f 84 c1 03 00 00    	je     800da2 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8009e1:	83 ec 08             	sub    $0x8,%esp
  8009e4:	ff 75 0c             	pushl  0xc(%ebp)
  8009e7:	53                   	push   %ebx
  8009e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009eb:	ff d0                	call   *%eax
  8009ed:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8009f3:	8d 50 01             	lea    0x1(%eax),%edx
  8009f6:	89 55 10             	mov    %edx,0x10(%ebp)
  8009f9:	8a 00                	mov    (%eax),%al
  8009fb:	0f b6 d8             	movzbl %al,%ebx
  8009fe:	83 fb 25             	cmp    $0x25,%ebx
  800a01:	75 d6                	jne    8009d9 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a03:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800a07:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800a0e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800a15:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800a1c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a23:	8b 45 10             	mov    0x10(%ebp),%eax
  800a26:	8d 50 01             	lea    0x1(%eax),%edx
  800a29:	89 55 10             	mov    %edx,0x10(%ebp)
  800a2c:	8a 00                	mov    (%eax),%al
  800a2e:	0f b6 d8             	movzbl %al,%ebx
  800a31:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800a34:	83 f8 5b             	cmp    $0x5b,%eax
  800a37:	0f 87 3d 03 00 00    	ja     800d7a <vprintfmt+0x3ab>
  800a3d:	8b 04 85 78 24 80 00 	mov    0x802478(,%eax,4),%eax
  800a44:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a46:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800a4a:	eb d7                	jmp    800a23 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a4c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a50:	eb d1                	jmp    800a23 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a52:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a59:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a5c:	89 d0                	mov    %edx,%eax
  800a5e:	c1 e0 02             	shl    $0x2,%eax
  800a61:	01 d0                	add    %edx,%eax
  800a63:	01 c0                	add    %eax,%eax
  800a65:	01 d8                	add    %ebx,%eax
  800a67:	83 e8 30             	sub    $0x30,%eax
  800a6a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a6d:	8b 45 10             	mov    0x10(%ebp),%eax
  800a70:	8a 00                	mov    (%eax),%al
  800a72:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a75:	83 fb 2f             	cmp    $0x2f,%ebx
  800a78:	7e 3e                	jle    800ab8 <vprintfmt+0xe9>
  800a7a:	83 fb 39             	cmp    $0x39,%ebx
  800a7d:	7f 39                	jg     800ab8 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a7f:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a82:	eb d5                	jmp    800a59 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a84:	8b 45 14             	mov    0x14(%ebp),%eax
  800a87:	83 c0 04             	add    $0x4,%eax
  800a8a:	89 45 14             	mov    %eax,0x14(%ebp)
  800a8d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a90:	83 e8 04             	sub    $0x4,%eax
  800a93:	8b 00                	mov    (%eax),%eax
  800a95:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a98:	eb 1f                	jmp    800ab9 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a9a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a9e:	79 83                	jns    800a23 <vprintfmt+0x54>
				width = 0;
  800aa0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800aa7:	e9 77 ff ff ff       	jmp    800a23 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800aac:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800ab3:	e9 6b ff ff ff       	jmp    800a23 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800ab8:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800ab9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800abd:	0f 89 60 ff ff ff    	jns    800a23 <vprintfmt+0x54>
				width = precision, precision = -1;
  800ac3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ac6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800ac9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800ad0:	e9 4e ff ff ff       	jmp    800a23 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ad5:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800ad8:	e9 46 ff ff ff       	jmp    800a23 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800add:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae0:	83 c0 04             	add    $0x4,%eax
  800ae3:	89 45 14             	mov    %eax,0x14(%ebp)
  800ae6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae9:	83 e8 04             	sub    $0x4,%eax
  800aec:	8b 00                	mov    (%eax),%eax
  800aee:	83 ec 08             	sub    $0x8,%esp
  800af1:	ff 75 0c             	pushl  0xc(%ebp)
  800af4:	50                   	push   %eax
  800af5:	8b 45 08             	mov    0x8(%ebp),%eax
  800af8:	ff d0                	call   *%eax
  800afa:	83 c4 10             	add    $0x10,%esp
			break;
  800afd:	e9 9b 02 00 00       	jmp    800d9d <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800b02:	8b 45 14             	mov    0x14(%ebp),%eax
  800b05:	83 c0 04             	add    $0x4,%eax
  800b08:	89 45 14             	mov    %eax,0x14(%ebp)
  800b0b:	8b 45 14             	mov    0x14(%ebp),%eax
  800b0e:	83 e8 04             	sub    $0x4,%eax
  800b11:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800b13:	85 db                	test   %ebx,%ebx
  800b15:	79 02                	jns    800b19 <vprintfmt+0x14a>
				err = -err;
  800b17:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800b19:	83 fb 64             	cmp    $0x64,%ebx
  800b1c:	7f 0b                	jg     800b29 <vprintfmt+0x15a>
  800b1e:	8b 34 9d c0 22 80 00 	mov    0x8022c0(,%ebx,4),%esi
  800b25:	85 f6                	test   %esi,%esi
  800b27:	75 19                	jne    800b42 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b29:	53                   	push   %ebx
  800b2a:	68 65 24 80 00       	push   $0x802465
  800b2f:	ff 75 0c             	pushl  0xc(%ebp)
  800b32:	ff 75 08             	pushl  0x8(%ebp)
  800b35:	e8 70 02 00 00       	call   800daa <printfmt>
  800b3a:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b3d:	e9 5b 02 00 00       	jmp    800d9d <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b42:	56                   	push   %esi
  800b43:	68 6e 24 80 00       	push   $0x80246e
  800b48:	ff 75 0c             	pushl  0xc(%ebp)
  800b4b:	ff 75 08             	pushl  0x8(%ebp)
  800b4e:	e8 57 02 00 00       	call   800daa <printfmt>
  800b53:	83 c4 10             	add    $0x10,%esp
			break;
  800b56:	e9 42 02 00 00       	jmp    800d9d <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b5b:	8b 45 14             	mov    0x14(%ebp),%eax
  800b5e:	83 c0 04             	add    $0x4,%eax
  800b61:	89 45 14             	mov    %eax,0x14(%ebp)
  800b64:	8b 45 14             	mov    0x14(%ebp),%eax
  800b67:	83 e8 04             	sub    $0x4,%eax
  800b6a:	8b 30                	mov    (%eax),%esi
  800b6c:	85 f6                	test   %esi,%esi
  800b6e:	75 05                	jne    800b75 <vprintfmt+0x1a6>
				p = "(null)";
  800b70:	be 71 24 80 00       	mov    $0x802471,%esi
			if (width > 0 && padc != '-')
  800b75:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b79:	7e 6d                	jle    800be8 <vprintfmt+0x219>
  800b7b:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b7f:	74 67                	je     800be8 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b81:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b84:	83 ec 08             	sub    $0x8,%esp
  800b87:	50                   	push   %eax
  800b88:	56                   	push   %esi
  800b89:	e8 1e 03 00 00       	call   800eac <strnlen>
  800b8e:	83 c4 10             	add    $0x10,%esp
  800b91:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b94:	eb 16                	jmp    800bac <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b96:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b9a:	83 ec 08             	sub    $0x8,%esp
  800b9d:	ff 75 0c             	pushl  0xc(%ebp)
  800ba0:	50                   	push   %eax
  800ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba4:	ff d0                	call   *%eax
  800ba6:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800ba9:	ff 4d e4             	decl   -0x1c(%ebp)
  800bac:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bb0:	7f e4                	jg     800b96 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bb2:	eb 34                	jmp    800be8 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800bb4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800bb8:	74 1c                	je     800bd6 <vprintfmt+0x207>
  800bba:	83 fb 1f             	cmp    $0x1f,%ebx
  800bbd:	7e 05                	jle    800bc4 <vprintfmt+0x1f5>
  800bbf:	83 fb 7e             	cmp    $0x7e,%ebx
  800bc2:	7e 12                	jle    800bd6 <vprintfmt+0x207>
					putch('?', putdat);
  800bc4:	83 ec 08             	sub    $0x8,%esp
  800bc7:	ff 75 0c             	pushl  0xc(%ebp)
  800bca:	6a 3f                	push   $0x3f
  800bcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcf:	ff d0                	call   *%eax
  800bd1:	83 c4 10             	add    $0x10,%esp
  800bd4:	eb 0f                	jmp    800be5 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800bd6:	83 ec 08             	sub    $0x8,%esp
  800bd9:	ff 75 0c             	pushl  0xc(%ebp)
  800bdc:	53                   	push   %ebx
  800bdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800be0:	ff d0                	call   *%eax
  800be2:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800be5:	ff 4d e4             	decl   -0x1c(%ebp)
  800be8:	89 f0                	mov    %esi,%eax
  800bea:	8d 70 01             	lea    0x1(%eax),%esi
  800bed:	8a 00                	mov    (%eax),%al
  800bef:	0f be d8             	movsbl %al,%ebx
  800bf2:	85 db                	test   %ebx,%ebx
  800bf4:	74 24                	je     800c1a <vprintfmt+0x24b>
  800bf6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bfa:	78 b8                	js     800bb4 <vprintfmt+0x1e5>
  800bfc:	ff 4d e0             	decl   -0x20(%ebp)
  800bff:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c03:	79 af                	jns    800bb4 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c05:	eb 13                	jmp    800c1a <vprintfmt+0x24b>
				putch(' ', putdat);
  800c07:	83 ec 08             	sub    $0x8,%esp
  800c0a:	ff 75 0c             	pushl  0xc(%ebp)
  800c0d:	6a 20                	push   $0x20
  800c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c12:	ff d0                	call   *%eax
  800c14:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c17:	ff 4d e4             	decl   -0x1c(%ebp)
  800c1a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c1e:	7f e7                	jg     800c07 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800c20:	e9 78 01 00 00       	jmp    800d9d <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800c25:	83 ec 08             	sub    $0x8,%esp
  800c28:	ff 75 e8             	pushl  -0x18(%ebp)
  800c2b:	8d 45 14             	lea    0x14(%ebp),%eax
  800c2e:	50                   	push   %eax
  800c2f:	e8 3c fd ff ff       	call   800970 <getint>
  800c34:	83 c4 10             	add    $0x10,%esp
  800c37:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c3a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800c3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c40:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c43:	85 d2                	test   %edx,%edx
  800c45:	79 23                	jns    800c6a <vprintfmt+0x29b>
				putch('-', putdat);
  800c47:	83 ec 08             	sub    $0x8,%esp
  800c4a:	ff 75 0c             	pushl  0xc(%ebp)
  800c4d:	6a 2d                	push   $0x2d
  800c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c52:	ff d0                	call   *%eax
  800c54:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c5d:	f7 d8                	neg    %eax
  800c5f:	83 d2 00             	adc    $0x0,%edx
  800c62:	f7 da                	neg    %edx
  800c64:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c67:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c6a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c71:	e9 bc 00 00 00       	jmp    800d32 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c76:	83 ec 08             	sub    $0x8,%esp
  800c79:	ff 75 e8             	pushl  -0x18(%ebp)
  800c7c:	8d 45 14             	lea    0x14(%ebp),%eax
  800c7f:	50                   	push   %eax
  800c80:	e8 84 fc ff ff       	call   800909 <getuint>
  800c85:	83 c4 10             	add    $0x10,%esp
  800c88:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c8b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c8e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c95:	e9 98 00 00 00       	jmp    800d32 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c9a:	83 ec 08             	sub    $0x8,%esp
  800c9d:	ff 75 0c             	pushl  0xc(%ebp)
  800ca0:	6a 58                	push   $0x58
  800ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca5:	ff d0                	call   *%eax
  800ca7:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800caa:	83 ec 08             	sub    $0x8,%esp
  800cad:	ff 75 0c             	pushl  0xc(%ebp)
  800cb0:	6a 58                	push   $0x58
  800cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb5:	ff d0                	call   *%eax
  800cb7:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800cba:	83 ec 08             	sub    $0x8,%esp
  800cbd:	ff 75 0c             	pushl  0xc(%ebp)
  800cc0:	6a 58                	push   $0x58
  800cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc5:	ff d0                	call   *%eax
  800cc7:	83 c4 10             	add    $0x10,%esp
			break;
  800cca:	e9 ce 00 00 00       	jmp    800d9d <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800ccf:	83 ec 08             	sub    $0x8,%esp
  800cd2:	ff 75 0c             	pushl  0xc(%ebp)
  800cd5:	6a 30                	push   $0x30
  800cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cda:	ff d0                	call   *%eax
  800cdc:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800cdf:	83 ec 08             	sub    $0x8,%esp
  800ce2:	ff 75 0c             	pushl  0xc(%ebp)
  800ce5:	6a 78                	push   $0x78
  800ce7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cea:	ff d0                	call   *%eax
  800cec:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800cef:	8b 45 14             	mov    0x14(%ebp),%eax
  800cf2:	83 c0 04             	add    $0x4,%eax
  800cf5:	89 45 14             	mov    %eax,0x14(%ebp)
  800cf8:	8b 45 14             	mov    0x14(%ebp),%eax
  800cfb:	83 e8 04             	sub    $0x4,%eax
  800cfe:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d00:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d03:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800d0a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800d11:	eb 1f                	jmp    800d32 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800d13:	83 ec 08             	sub    $0x8,%esp
  800d16:	ff 75 e8             	pushl  -0x18(%ebp)
  800d19:	8d 45 14             	lea    0x14(%ebp),%eax
  800d1c:	50                   	push   %eax
  800d1d:	e8 e7 fb ff ff       	call   800909 <getuint>
  800d22:	83 c4 10             	add    $0x10,%esp
  800d25:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d28:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800d2b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d32:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800d36:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d39:	83 ec 04             	sub    $0x4,%esp
  800d3c:	52                   	push   %edx
  800d3d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800d40:	50                   	push   %eax
  800d41:	ff 75 f4             	pushl  -0xc(%ebp)
  800d44:	ff 75 f0             	pushl  -0x10(%ebp)
  800d47:	ff 75 0c             	pushl  0xc(%ebp)
  800d4a:	ff 75 08             	pushl  0x8(%ebp)
  800d4d:	e8 00 fb ff ff       	call   800852 <printnum>
  800d52:	83 c4 20             	add    $0x20,%esp
			break;
  800d55:	eb 46                	jmp    800d9d <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d57:	83 ec 08             	sub    $0x8,%esp
  800d5a:	ff 75 0c             	pushl  0xc(%ebp)
  800d5d:	53                   	push   %ebx
  800d5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d61:	ff d0                	call   *%eax
  800d63:	83 c4 10             	add    $0x10,%esp
			break;
  800d66:	eb 35                	jmp    800d9d <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800d68:	c6 05 60 f0 80 00 00 	movb   $0x0,0x80f060
			break;
  800d6f:	eb 2c                	jmp    800d9d <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800d71:	c6 05 60 f0 80 00 01 	movb   $0x1,0x80f060
			break;
  800d78:	eb 23                	jmp    800d9d <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d7a:	83 ec 08             	sub    $0x8,%esp
  800d7d:	ff 75 0c             	pushl  0xc(%ebp)
  800d80:	6a 25                	push   $0x25
  800d82:	8b 45 08             	mov    0x8(%ebp),%eax
  800d85:	ff d0                	call   *%eax
  800d87:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d8a:	ff 4d 10             	decl   0x10(%ebp)
  800d8d:	eb 03                	jmp    800d92 <vprintfmt+0x3c3>
  800d8f:	ff 4d 10             	decl   0x10(%ebp)
  800d92:	8b 45 10             	mov    0x10(%ebp),%eax
  800d95:	48                   	dec    %eax
  800d96:	8a 00                	mov    (%eax),%al
  800d98:	3c 25                	cmp    $0x25,%al
  800d9a:	75 f3                	jne    800d8f <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800d9c:	90                   	nop
		}
	}
  800d9d:	e9 35 fc ff ff       	jmp    8009d7 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800da2:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800da3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800da6:	5b                   	pop    %ebx
  800da7:	5e                   	pop    %esi
  800da8:	5d                   	pop    %ebp
  800da9:	c3                   	ret    

00800daa <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800daa:	55                   	push   %ebp
  800dab:	89 e5                	mov    %esp,%ebp
  800dad:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800db0:	8d 45 10             	lea    0x10(%ebp),%eax
  800db3:	83 c0 04             	add    $0x4,%eax
  800db6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800db9:	8b 45 10             	mov    0x10(%ebp),%eax
  800dbc:	ff 75 f4             	pushl  -0xc(%ebp)
  800dbf:	50                   	push   %eax
  800dc0:	ff 75 0c             	pushl  0xc(%ebp)
  800dc3:	ff 75 08             	pushl  0x8(%ebp)
  800dc6:	e8 04 fc ff ff       	call   8009cf <vprintfmt>
  800dcb:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800dce:	90                   	nop
  800dcf:	c9                   	leave  
  800dd0:	c3                   	ret    

00800dd1 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800dd1:	55                   	push   %ebp
  800dd2:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800dd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd7:	8b 40 08             	mov    0x8(%eax),%eax
  800dda:	8d 50 01             	lea    0x1(%eax),%edx
  800ddd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de0:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800de3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de6:	8b 10                	mov    (%eax),%edx
  800de8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800deb:	8b 40 04             	mov    0x4(%eax),%eax
  800dee:	39 c2                	cmp    %eax,%edx
  800df0:	73 12                	jae    800e04 <sprintputch+0x33>
		*b->buf++ = ch;
  800df2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df5:	8b 00                	mov    (%eax),%eax
  800df7:	8d 48 01             	lea    0x1(%eax),%ecx
  800dfa:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dfd:	89 0a                	mov    %ecx,(%edx)
  800dff:	8b 55 08             	mov    0x8(%ebp),%edx
  800e02:	88 10                	mov    %dl,(%eax)
}
  800e04:	90                   	nop
  800e05:	5d                   	pop    %ebp
  800e06:	c3                   	ret    

00800e07 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e07:	55                   	push   %ebp
  800e08:	89 e5                	mov    %esp,%ebp
  800e0a:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e10:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800e13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e16:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e19:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1c:	01 d0                	add    %edx,%eax
  800e1e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e21:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800e28:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e2c:	74 06                	je     800e34 <vsnprintf+0x2d>
  800e2e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e32:	7f 07                	jg     800e3b <vsnprintf+0x34>
		return -E_INVAL;
  800e34:	b8 03 00 00 00       	mov    $0x3,%eax
  800e39:	eb 20                	jmp    800e5b <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e3b:	ff 75 14             	pushl  0x14(%ebp)
  800e3e:	ff 75 10             	pushl  0x10(%ebp)
  800e41:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e44:	50                   	push   %eax
  800e45:	68 d1 0d 80 00       	push   $0x800dd1
  800e4a:	e8 80 fb ff ff       	call   8009cf <vprintfmt>
  800e4f:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800e52:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e55:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e58:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e5b:	c9                   	leave  
  800e5c:	c3                   	ret    

00800e5d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e5d:	55                   	push   %ebp
  800e5e:	89 e5                	mov    %esp,%ebp
  800e60:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e63:	8d 45 10             	lea    0x10(%ebp),%eax
  800e66:	83 c0 04             	add    $0x4,%eax
  800e69:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e6c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e6f:	ff 75 f4             	pushl  -0xc(%ebp)
  800e72:	50                   	push   %eax
  800e73:	ff 75 0c             	pushl  0xc(%ebp)
  800e76:	ff 75 08             	pushl  0x8(%ebp)
  800e79:	e8 89 ff ff ff       	call   800e07 <vsnprintf>
  800e7e:	83 c4 10             	add    $0x10,%esp
  800e81:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e84:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e87:	c9                   	leave  
  800e88:	c3                   	ret    

00800e89 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e89:	55                   	push   %ebp
  800e8a:	89 e5                	mov    %esp,%ebp
  800e8c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e8f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e96:	eb 06                	jmp    800e9e <strlen+0x15>
		n++;
  800e98:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e9b:	ff 45 08             	incl   0x8(%ebp)
  800e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea1:	8a 00                	mov    (%eax),%al
  800ea3:	84 c0                	test   %al,%al
  800ea5:	75 f1                	jne    800e98 <strlen+0xf>
		n++;
	return n;
  800ea7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800eaa:	c9                   	leave  
  800eab:	c3                   	ret    

00800eac <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800eac:	55                   	push   %ebp
  800ead:	89 e5                	mov    %esp,%ebp
  800eaf:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800eb2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800eb9:	eb 09                	jmp    800ec4 <strnlen+0x18>
		n++;
  800ebb:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ebe:	ff 45 08             	incl   0x8(%ebp)
  800ec1:	ff 4d 0c             	decl   0xc(%ebp)
  800ec4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ec8:	74 09                	je     800ed3 <strnlen+0x27>
  800eca:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecd:	8a 00                	mov    (%eax),%al
  800ecf:	84 c0                	test   %al,%al
  800ed1:	75 e8                	jne    800ebb <strnlen+0xf>
		n++;
	return n;
  800ed3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ed6:	c9                   	leave  
  800ed7:	c3                   	ret    

00800ed8 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ed8:	55                   	push   %ebp
  800ed9:	89 e5                	mov    %esp,%ebp
  800edb:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800ede:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800ee4:	90                   	nop
  800ee5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee8:	8d 50 01             	lea    0x1(%eax),%edx
  800eeb:	89 55 08             	mov    %edx,0x8(%ebp)
  800eee:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ef1:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ef4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ef7:	8a 12                	mov    (%edx),%dl
  800ef9:	88 10                	mov    %dl,(%eax)
  800efb:	8a 00                	mov    (%eax),%al
  800efd:	84 c0                	test   %al,%al
  800eff:	75 e4                	jne    800ee5 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800f01:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f04:	c9                   	leave  
  800f05:	c3                   	ret    

00800f06 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800f06:	55                   	push   %ebp
  800f07:	89 e5                	mov    %esp,%ebp
  800f09:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800f0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800f12:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f19:	eb 1f                	jmp    800f3a <strncpy+0x34>
		*dst++ = *src;
  800f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1e:	8d 50 01             	lea    0x1(%eax),%edx
  800f21:	89 55 08             	mov    %edx,0x8(%ebp)
  800f24:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f27:	8a 12                	mov    (%edx),%dl
  800f29:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2e:	8a 00                	mov    (%eax),%al
  800f30:	84 c0                	test   %al,%al
  800f32:	74 03                	je     800f37 <strncpy+0x31>
			src++;
  800f34:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f37:	ff 45 fc             	incl   -0x4(%ebp)
  800f3a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f3d:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f40:	72 d9                	jb     800f1b <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f42:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f45:	c9                   	leave  
  800f46:	c3                   	ret    

00800f47 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800f47:	55                   	push   %ebp
  800f48:	89 e5                	mov    %esp,%ebp
  800f4a:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800f4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f50:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800f53:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f57:	74 30                	je     800f89 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800f59:	eb 16                	jmp    800f71 <strlcpy+0x2a>
			*dst++ = *src++;
  800f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5e:	8d 50 01             	lea    0x1(%eax),%edx
  800f61:	89 55 08             	mov    %edx,0x8(%ebp)
  800f64:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f67:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f6a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f6d:	8a 12                	mov    (%edx),%dl
  800f6f:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f71:	ff 4d 10             	decl   0x10(%ebp)
  800f74:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f78:	74 09                	je     800f83 <strlcpy+0x3c>
  800f7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f7d:	8a 00                	mov    (%eax),%al
  800f7f:	84 c0                	test   %al,%al
  800f81:	75 d8                	jne    800f5b <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f83:	8b 45 08             	mov    0x8(%ebp),%eax
  800f86:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f89:	8b 55 08             	mov    0x8(%ebp),%edx
  800f8c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f8f:	29 c2                	sub    %eax,%edx
  800f91:	89 d0                	mov    %edx,%eax
}
  800f93:	c9                   	leave  
  800f94:	c3                   	ret    

00800f95 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f95:	55                   	push   %ebp
  800f96:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f98:	eb 06                	jmp    800fa0 <strcmp+0xb>
		p++, q++;
  800f9a:	ff 45 08             	incl   0x8(%ebp)
  800f9d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa3:	8a 00                	mov    (%eax),%al
  800fa5:	84 c0                	test   %al,%al
  800fa7:	74 0e                	je     800fb7 <strcmp+0x22>
  800fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fac:	8a 10                	mov    (%eax),%dl
  800fae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb1:	8a 00                	mov    (%eax),%al
  800fb3:	38 c2                	cmp    %al,%dl
  800fb5:	74 e3                	je     800f9a <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800fb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fba:	8a 00                	mov    (%eax),%al
  800fbc:	0f b6 d0             	movzbl %al,%edx
  800fbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc2:	8a 00                	mov    (%eax),%al
  800fc4:	0f b6 c0             	movzbl %al,%eax
  800fc7:	29 c2                	sub    %eax,%edx
  800fc9:	89 d0                	mov    %edx,%eax
}
  800fcb:	5d                   	pop    %ebp
  800fcc:	c3                   	ret    

00800fcd <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800fcd:	55                   	push   %ebp
  800fce:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800fd0:	eb 09                	jmp    800fdb <strncmp+0xe>
		n--, p++, q++;
  800fd2:	ff 4d 10             	decl   0x10(%ebp)
  800fd5:	ff 45 08             	incl   0x8(%ebp)
  800fd8:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800fdb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fdf:	74 17                	je     800ff8 <strncmp+0x2b>
  800fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe4:	8a 00                	mov    (%eax),%al
  800fe6:	84 c0                	test   %al,%al
  800fe8:	74 0e                	je     800ff8 <strncmp+0x2b>
  800fea:	8b 45 08             	mov    0x8(%ebp),%eax
  800fed:	8a 10                	mov    (%eax),%dl
  800fef:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff2:	8a 00                	mov    (%eax),%al
  800ff4:	38 c2                	cmp    %al,%dl
  800ff6:	74 da                	je     800fd2 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800ff8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ffc:	75 07                	jne    801005 <strncmp+0x38>
		return 0;
  800ffe:	b8 00 00 00 00       	mov    $0x0,%eax
  801003:	eb 14                	jmp    801019 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801005:	8b 45 08             	mov    0x8(%ebp),%eax
  801008:	8a 00                	mov    (%eax),%al
  80100a:	0f b6 d0             	movzbl %al,%edx
  80100d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801010:	8a 00                	mov    (%eax),%al
  801012:	0f b6 c0             	movzbl %al,%eax
  801015:	29 c2                	sub    %eax,%edx
  801017:	89 d0                	mov    %edx,%eax
}
  801019:	5d                   	pop    %ebp
  80101a:	c3                   	ret    

0080101b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80101b:	55                   	push   %ebp
  80101c:	89 e5                	mov    %esp,%ebp
  80101e:	83 ec 04             	sub    $0x4,%esp
  801021:	8b 45 0c             	mov    0xc(%ebp),%eax
  801024:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801027:	eb 12                	jmp    80103b <strchr+0x20>
		if (*s == c)
  801029:	8b 45 08             	mov    0x8(%ebp),%eax
  80102c:	8a 00                	mov    (%eax),%al
  80102e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801031:	75 05                	jne    801038 <strchr+0x1d>
			return (char *) s;
  801033:	8b 45 08             	mov    0x8(%ebp),%eax
  801036:	eb 11                	jmp    801049 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801038:	ff 45 08             	incl   0x8(%ebp)
  80103b:	8b 45 08             	mov    0x8(%ebp),%eax
  80103e:	8a 00                	mov    (%eax),%al
  801040:	84 c0                	test   %al,%al
  801042:	75 e5                	jne    801029 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801044:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801049:	c9                   	leave  
  80104a:	c3                   	ret    

0080104b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80104b:	55                   	push   %ebp
  80104c:	89 e5                	mov    %esp,%ebp
  80104e:	83 ec 04             	sub    $0x4,%esp
  801051:	8b 45 0c             	mov    0xc(%ebp),%eax
  801054:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801057:	eb 0d                	jmp    801066 <strfind+0x1b>
		if (*s == c)
  801059:	8b 45 08             	mov    0x8(%ebp),%eax
  80105c:	8a 00                	mov    (%eax),%al
  80105e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801061:	74 0e                	je     801071 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801063:	ff 45 08             	incl   0x8(%ebp)
  801066:	8b 45 08             	mov    0x8(%ebp),%eax
  801069:	8a 00                	mov    (%eax),%al
  80106b:	84 c0                	test   %al,%al
  80106d:	75 ea                	jne    801059 <strfind+0xe>
  80106f:	eb 01                	jmp    801072 <strfind+0x27>
		if (*s == c)
			break;
  801071:	90                   	nop
	return (char *) s;
  801072:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801075:	c9                   	leave  
  801076:	c3                   	ret    

00801077 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801077:	55                   	push   %ebp
  801078:	89 e5                	mov    %esp,%ebp
  80107a:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  80107d:	8b 45 08             	mov    0x8(%ebp),%eax
  801080:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801083:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801087:	76 63                	jbe    8010ec <memset+0x75>
		uint64 data_block = c;
  801089:	8b 45 0c             	mov    0xc(%ebp),%eax
  80108c:	99                   	cltd   
  80108d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801090:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801093:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801096:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801099:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  80109d:	c1 e0 08             	shl    $0x8,%eax
  8010a0:	09 45 f0             	or     %eax,-0x10(%ebp)
  8010a3:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  8010a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010ac:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  8010b0:	c1 e0 10             	shl    $0x10,%eax
  8010b3:	09 45 f0             	or     %eax,-0x10(%ebp)
  8010b6:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  8010b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010bf:	89 c2                	mov    %eax,%edx
  8010c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8010c6:	09 45 f0             	or     %eax,-0x10(%ebp)
  8010c9:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  8010cc:	eb 18                	jmp    8010e6 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  8010ce:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8010d1:	8d 41 08             	lea    0x8(%ecx),%eax
  8010d4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8010d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010dd:	89 01                	mov    %eax,(%ecx)
  8010df:	89 51 04             	mov    %edx,0x4(%ecx)
  8010e2:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  8010e6:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010ea:	77 e2                	ja     8010ce <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8010ec:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010f0:	74 23                	je     801115 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8010f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010f5:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8010f8:	eb 0e                	jmp    801108 <memset+0x91>
			*p8++ = (uint8)c;
  8010fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010fd:	8d 50 01             	lea    0x1(%eax),%edx
  801100:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801103:	8b 55 0c             	mov    0xc(%ebp),%edx
  801106:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801108:	8b 45 10             	mov    0x10(%ebp),%eax
  80110b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80110e:	89 55 10             	mov    %edx,0x10(%ebp)
  801111:	85 c0                	test   %eax,%eax
  801113:	75 e5                	jne    8010fa <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801115:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801118:	c9                   	leave  
  801119:	c3                   	ret    

0080111a <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80111a:	55                   	push   %ebp
  80111b:	89 e5                	mov    %esp,%ebp
  80111d:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801120:	8b 45 0c             	mov    0xc(%ebp),%eax
  801123:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801126:	8b 45 08             	mov    0x8(%ebp),%eax
  801129:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  80112c:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801130:	76 24                	jbe    801156 <memcpy+0x3c>
		while(n >= 8){
  801132:	eb 1c                	jmp    801150 <memcpy+0x36>
			*d64 = *s64;
  801134:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801137:	8b 50 04             	mov    0x4(%eax),%edx
  80113a:	8b 00                	mov    (%eax),%eax
  80113c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80113f:	89 01                	mov    %eax,(%ecx)
  801141:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801144:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801148:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  80114c:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801150:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801154:	77 de                	ja     801134 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801156:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80115a:	74 31                	je     80118d <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  80115c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80115f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801162:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801165:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801168:	eb 16                	jmp    801180 <memcpy+0x66>
			*d8++ = *s8++;
  80116a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80116d:	8d 50 01             	lea    0x1(%eax),%edx
  801170:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801173:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801176:	8d 4a 01             	lea    0x1(%edx),%ecx
  801179:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80117c:	8a 12                	mov    (%edx),%dl
  80117e:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801180:	8b 45 10             	mov    0x10(%ebp),%eax
  801183:	8d 50 ff             	lea    -0x1(%eax),%edx
  801186:	89 55 10             	mov    %edx,0x10(%ebp)
  801189:	85 c0                	test   %eax,%eax
  80118b:	75 dd                	jne    80116a <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  80118d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801190:	c9                   	leave  
  801191:	c3                   	ret    

00801192 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801192:	55                   	push   %ebp
  801193:	89 e5                	mov    %esp,%ebp
  801195:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801198:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80119e:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8011a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011a7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8011aa:	73 50                	jae    8011fc <memmove+0x6a>
  8011ac:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011af:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b2:	01 d0                	add    %edx,%eax
  8011b4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8011b7:	76 43                	jbe    8011fc <memmove+0x6a>
		s += n;
  8011b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8011bc:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8011bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c2:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8011c5:	eb 10                	jmp    8011d7 <memmove+0x45>
			*--d = *--s;
  8011c7:	ff 4d f8             	decl   -0x8(%ebp)
  8011ca:	ff 4d fc             	decl   -0x4(%ebp)
  8011cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011d0:	8a 10                	mov    (%eax),%dl
  8011d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011d5:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8011d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8011da:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011dd:	89 55 10             	mov    %edx,0x10(%ebp)
  8011e0:	85 c0                	test   %eax,%eax
  8011e2:	75 e3                	jne    8011c7 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8011e4:	eb 23                	jmp    801209 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8011e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011e9:	8d 50 01             	lea    0x1(%eax),%edx
  8011ec:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011ef:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011f2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011f5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8011f8:	8a 12                	mov    (%edx),%dl
  8011fa:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8011fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ff:	8d 50 ff             	lea    -0x1(%eax),%edx
  801202:	89 55 10             	mov    %edx,0x10(%ebp)
  801205:	85 c0                	test   %eax,%eax
  801207:	75 dd                	jne    8011e6 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801209:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80120c:	c9                   	leave  
  80120d:	c3                   	ret    

0080120e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80120e:	55                   	push   %ebp
  80120f:	89 e5                	mov    %esp,%ebp
  801211:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801214:	8b 45 08             	mov    0x8(%ebp),%eax
  801217:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80121a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121d:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801220:	eb 2a                	jmp    80124c <memcmp+0x3e>
		if (*s1 != *s2)
  801222:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801225:	8a 10                	mov    (%eax),%dl
  801227:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80122a:	8a 00                	mov    (%eax),%al
  80122c:	38 c2                	cmp    %al,%dl
  80122e:	74 16                	je     801246 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801230:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801233:	8a 00                	mov    (%eax),%al
  801235:	0f b6 d0             	movzbl %al,%edx
  801238:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80123b:	8a 00                	mov    (%eax),%al
  80123d:	0f b6 c0             	movzbl %al,%eax
  801240:	29 c2                	sub    %eax,%edx
  801242:	89 d0                	mov    %edx,%eax
  801244:	eb 18                	jmp    80125e <memcmp+0x50>
		s1++, s2++;
  801246:	ff 45 fc             	incl   -0x4(%ebp)
  801249:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80124c:	8b 45 10             	mov    0x10(%ebp),%eax
  80124f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801252:	89 55 10             	mov    %edx,0x10(%ebp)
  801255:	85 c0                	test   %eax,%eax
  801257:	75 c9                	jne    801222 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801259:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80125e:	c9                   	leave  
  80125f:	c3                   	ret    

00801260 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801260:	55                   	push   %ebp
  801261:	89 e5                	mov    %esp,%ebp
  801263:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801266:	8b 55 08             	mov    0x8(%ebp),%edx
  801269:	8b 45 10             	mov    0x10(%ebp),%eax
  80126c:	01 d0                	add    %edx,%eax
  80126e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801271:	eb 15                	jmp    801288 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801273:	8b 45 08             	mov    0x8(%ebp),%eax
  801276:	8a 00                	mov    (%eax),%al
  801278:	0f b6 d0             	movzbl %al,%edx
  80127b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80127e:	0f b6 c0             	movzbl %al,%eax
  801281:	39 c2                	cmp    %eax,%edx
  801283:	74 0d                	je     801292 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801285:	ff 45 08             	incl   0x8(%ebp)
  801288:	8b 45 08             	mov    0x8(%ebp),%eax
  80128b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80128e:	72 e3                	jb     801273 <memfind+0x13>
  801290:	eb 01                	jmp    801293 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801292:	90                   	nop
	return (void *) s;
  801293:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801296:	c9                   	leave  
  801297:	c3                   	ret    

00801298 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801298:	55                   	push   %ebp
  801299:	89 e5                	mov    %esp,%ebp
  80129b:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80129e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8012a5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8012ac:	eb 03                	jmp    8012b1 <strtol+0x19>
		s++;
  8012ae:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8012b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b4:	8a 00                	mov    (%eax),%al
  8012b6:	3c 20                	cmp    $0x20,%al
  8012b8:	74 f4                	je     8012ae <strtol+0x16>
  8012ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bd:	8a 00                	mov    (%eax),%al
  8012bf:	3c 09                	cmp    $0x9,%al
  8012c1:	74 eb                	je     8012ae <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8012c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c6:	8a 00                	mov    (%eax),%al
  8012c8:	3c 2b                	cmp    $0x2b,%al
  8012ca:	75 05                	jne    8012d1 <strtol+0x39>
		s++;
  8012cc:	ff 45 08             	incl   0x8(%ebp)
  8012cf:	eb 13                	jmp    8012e4 <strtol+0x4c>
	else if (*s == '-')
  8012d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d4:	8a 00                	mov    (%eax),%al
  8012d6:	3c 2d                	cmp    $0x2d,%al
  8012d8:	75 0a                	jne    8012e4 <strtol+0x4c>
		s++, neg = 1;
  8012da:	ff 45 08             	incl   0x8(%ebp)
  8012dd:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8012e4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012e8:	74 06                	je     8012f0 <strtol+0x58>
  8012ea:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8012ee:	75 20                	jne    801310 <strtol+0x78>
  8012f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f3:	8a 00                	mov    (%eax),%al
  8012f5:	3c 30                	cmp    $0x30,%al
  8012f7:	75 17                	jne    801310 <strtol+0x78>
  8012f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fc:	40                   	inc    %eax
  8012fd:	8a 00                	mov    (%eax),%al
  8012ff:	3c 78                	cmp    $0x78,%al
  801301:	75 0d                	jne    801310 <strtol+0x78>
		s += 2, base = 16;
  801303:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801307:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80130e:	eb 28                	jmp    801338 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801310:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801314:	75 15                	jne    80132b <strtol+0x93>
  801316:	8b 45 08             	mov    0x8(%ebp),%eax
  801319:	8a 00                	mov    (%eax),%al
  80131b:	3c 30                	cmp    $0x30,%al
  80131d:	75 0c                	jne    80132b <strtol+0x93>
		s++, base = 8;
  80131f:	ff 45 08             	incl   0x8(%ebp)
  801322:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801329:	eb 0d                	jmp    801338 <strtol+0xa0>
	else if (base == 0)
  80132b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80132f:	75 07                	jne    801338 <strtol+0xa0>
		base = 10;
  801331:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801338:	8b 45 08             	mov    0x8(%ebp),%eax
  80133b:	8a 00                	mov    (%eax),%al
  80133d:	3c 2f                	cmp    $0x2f,%al
  80133f:	7e 19                	jle    80135a <strtol+0xc2>
  801341:	8b 45 08             	mov    0x8(%ebp),%eax
  801344:	8a 00                	mov    (%eax),%al
  801346:	3c 39                	cmp    $0x39,%al
  801348:	7f 10                	jg     80135a <strtol+0xc2>
			dig = *s - '0';
  80134a:	8b 45 08             	mov    0x8(%ebp),%eax
  80134d:	8a 00                	mov    (%eax),%al
  80134f:	0f be c0             	movsbl %al,%eax
  801352:	83 e8 30             	sub    $0x30,%eax
  801355:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801358:	eb 42                	jmp    80139c <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80135a:	8b 45 08             	mov    0x8(%ebp),%eax
  80135d:	8a 00                	mov    (%eax),%al
  80135f:	3c 60                	cmp    $0x60,%al
  801361:	7e 19                	jle    80137c <strtol+0xe4>
  801363:	8b 45 08             	mov    0x8(%ebp),%eax
  801366:	8a 00                	mov    (%eax),%al
  801368:	3c 7a                	cmp    $0x7a,%al
  80136a:	7f 10                	jg     80137c <strtol+0xe4>
			dig = *s - 'a' + 10;
  80136c:	8b 45 08             	mov    0x8(%ebp),%eax
  80136f:	8a 00                	mov    (%eax),%al
  801371:	0f be c0             	movsbl %al,%eax
  801374:	83 e8 57             	sub    $0x57,%eax
  801377:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80137a:	eb 20                	jmp    80139c <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80137c:	8b 45 08             	mov    0x8(%ebp),%eax
  80137f:	8a 00                	mov    (%eax),%al
  801381:	3c 40                	cmp    $0x40,%al
  801383:	7e 39                	jle    8013be <strtol+0x126>
  801385:	8b 45 08             	mov    0x8(%ebp),%eax
  801388:	8a 00                	mov    (%eax),%al
  80138a:	3c 5a                	cmp    $0x5a,%al
  80138c:	7f 30                	jg     8013be <strtol+0x126>
			dig = *s - 'A' + 10;
  80138e:	8b 45 08             	mov    0x8(%ebp),%eax
  801391:	8a 00                	mov    (%eax),%al
  801393:	0f be c0             	movsbl %al,%eax
  801396:	83 e8 37             	sub    $0x37,%eax
  801399:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80139c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80139f:	3b 45 10             	cmp    0x10(%ebp),%eax
  8013a2:	7d 19                	jge    8013bd <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8013a4:	ff 45 08             	incl   0x8(%ebp)
  8013a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013aa:	0f af 45 10          	imul   0x10(%ebp),%eax
  8013ae:	89 c2                	mov    %eax,%edx
  8013b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013b3:	01 d0                	add    %edx,%eax
  8013b5:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8013b8:	e9 7b ff ff ff       	jmp    801338 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8013bd:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8013be:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8013c2:	74 08                	je     8013cc <strtol+0x134>
		*endptr = (char *) s;
  8013c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c7:	8b 55 08             	mov    0x8(%ebp),%edx
  8013ca:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8013cc:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8013d0:	74 07                	je     8013d9 <strtol+0x141>
  8013d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013d5:	f7 d8                	neg    %eax
  8013d7:	eb 03                	jmp    8013dc <strtol+0x144>
  8013d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8013dc:	c9                   	leave  
  8013dd:	c3                   	ret    

008013de <ltostr>:

void
ltostr(long value, char *str)
{
  8013de:	55                   	push   %ebp
  8013df:	89 e5                	mov    %esp,%ebp
  8013e1:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8013e4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8013eb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8013f2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013f6:	79 13                	jns    80140b <ltostr+0x2d>
	{
		neg = 1;
  8013f8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8013ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801402:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801405:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801408:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80140b:	8b 45 08             	mov    0x8(%ebp),%eax
  80140e:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801413:	99                   	cltd   
  801414:	f7 f9                	idiv   %ecx
  801416:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801419:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80141c:	8d 50 01             	lea    0x1(%eax),%edx
  80141f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801422:	89 c2                	mov    %eax,%edx
  801424:	8b 45 0c             	mov    0xc(%ebp),%eax
  801427:	01 d0                	add    %edx,%eax
  801429:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80142c:	83 c2 30             	add    $0x30,%edx
  80142f:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801431:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801434:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801439:	f7 e9                	imul   %ecx
  80143b:	c1 fa 02             	sar    $0x2,%edx
  80143e:	89 c8                	mov    %ecx,%eax
  801440:	c1 f8 1f             	sar    $0x1f,%eax
  801443:	29 c2                	sub    %eax,%edx
  801445:	89 d0                	mov    %edx,%eax
  801447:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80144a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80144e:	75 bb                	jne    80140b <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801450:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801457:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80145a:	48                   	dec    %eax
  80145b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80145e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801462:	74 3d                	je     8014a1 <ltostr+0xc3>
		start = 1 ;
  801464:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80146b:	eb 34                	jmp    8014a1 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80146d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801470:	8b 45 0c             	mov    0xc(%ebp),%eax
  801473:	01 d0                	add    %edx,%eax
  801475:	8a 00                	mov    (%eax),%al
  801477:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80147a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80147d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801480:	01 c2                	add    %eax,%edx
  801482:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801485:	8b 45 0c             	mov    0xc(%ebp),%eax
  801488:	01 c8                	add    %ecx,%eax
  80148a:	8a 00                	mov    (%eax),%al
  80148c:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80148e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801491:	8b 45 0c             	mov    0xc(%ebp),%eax
  801494:	01 c2                	add    %eax,%edx
  801496:	8a 45 eb             	mov    -0x15(%ebp),%al
  801499:	88 02                	mov    %al,(%edx)
		start++ ;
  80149b:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80149e:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8014a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014a4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8014a7:	7c c4                	jl     80146d <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8014a9:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8014ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014af:	01 d0                	add    %edx,%eax
  8014b1:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8014b4:	90                   	nop
  8014b5:	c9                   	leave  
  8014b6:	c3                   	ret    

008014b7 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8014b7:	55                   	push   %ebp
  8014b8:	89 e5                	mov    %esp,%ebp
  8014ba:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8014bd:	ff 75 08             	pushl  0x8(%ebp)
  8014c0:	e8 c4 f9 ff ff       	call   800e89 <strlen>
  8014c5:	83 c4 04             	add    $0x4,%esp
  8014c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8014cb:	ff 75 0c             	pushl  0xc(%ebp)
  8014ce:	e8 b6 f9 ff ff       	call   800e89 <strlen>
  8014d3:	83 c4 04             	add    $0x4,%esp
  8014d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8014d9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8014e0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014e7:	eb 17                	jmp    801500 <strcconcat+0x49>
		final[s] = str1[s] ;
  8014e9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ef:	01 c2                	add    %eax,%edx
  8014f1:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8014f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f7:	01 c8                	add    %ecx,%eax
  8014f9:	8a 00                	mov    (%eax),%al
  8014fb:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8014fd:	ff 45 fc             	incl   -0x4(%ebp)
  801500:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801503:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801506:	7c e1                	jl     8014e9 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801508:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80150f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801516:	eb 1f                	jmp    801537 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801518:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80151b:	8d 50 01             	lea    0x1(%eax),%edx
  80151e:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801521:	89 c2                	mov    %eax,%edx
  801523:	8b 45 10             	mov    0x10(%ebp),%eax
  801526:	01 c2                	add    %eax,%edx
  801528:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80152b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80152e:	01 c8                	add    %ecx,%eax
  801530:	8a 00                	mov    (%eax),%al
  801532:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801534:	ff 45 f8             	incl   -0x8(%ebp)
  801537:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80153a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80153d:	7c d9                	jl     801518 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80153f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801542:	8b 45 10             	mov    0x10(%ebp),%eax
  801545:	01 d0                	add    %edx,%eax
  801547:	c6 00 00             	movb   $0x0,(%eax)
}
  80154a:	90                   	nop
  80154b:	c9                   	leave  
  80154c:	c3                   	ret    

0080154d <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80154d:	55                   	push   %ebp
  80154e:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801550:	8b 45 14             	mov    0x14(%ebp),%eax
  801553:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801559:	8b 45 14             	mov    0x14(%ebp),%eax
  80155c:	8b 00                	mov    (%eax),%eax
  80155e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801565:	8b 45 10             	mov    0x10(%ebp),%eax
  801568:	01 d0                	add    %edx,%eax
  80156a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801570:	eb 0c                	jmp    80157e <strsplit+0x31>
			*string++ = 0;
  801572:	8b 45 08             	mov    0x8(%ebp),%eax
  801575:	8d 50 01             	lea    0x1(%eax),%edx
  801578:	89 55 08             	mov    %edx,0x8(%ebp)
  80157b:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80157e:	8b 45 08             	mov    0x8(%ebp),%eax
  801581:	8a 00                	mov    (%eax),%al
  801583:	84 c0                	test   %al,%al
  801585:	74 18                	je     80159f <strsplit+0x52>
  801587:	8b 45 08             	mov    0x8(%ebp),%eax
  80158a:	8a 00                	mov    (%eax),%al
  80158c:	0f be c0             	movsbl %al,%eax
  80158f:	50                   	push   %eax
  801590:	ff 75 0c             	pushl  0xc(%ebp)
  801593:	e8 83 fa ff ff       	call   80101b <strchr>
  801598:	83 c4 08             	add    $0x8,%esp
  80159b:	85 c0                	test   %eax,%eax
  80159d:	75 d3                	jne    801572 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80159f:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a2:	8a 00                	mov    (%eax),%al
  8015a4:	84 c0                	test   %al,%al
  8015a6:	74 5a                	je     801602 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8015a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8015ab:	8b 00                	mov    (%eax),%eax
  8015ad:	83 f8 0f             	cmp    $0xf,%eax
  8015b0:	75 07                	jne    8015b9 <strsplit+0x6c>
		{
			return 0;
  8015b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8015b7:	eb 66                	jmp    80161f <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8015b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8015bc:	8b 00                	mov    (%eax),%eax
  8015be:	8d 48 01             	lea    0x1(%eax),%ecx
  8015c1:	8b 55 14             	mov    0x14(%ebp),%edx
  8015c4:	89 0a                	mov    %ecx,(%edx)
  8015c6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8015d0:	01 c2                	add    %eax,%edx
  8015d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d5:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8015d7:	eb 03                	jmp    8015dc <strsplit+0x8f>
			string++;
  8015d9:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8015dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8015df:	8a 00                	mov    (%eax),%al
  8015e1:	84 c0                	test   %al,%al
  8015e3:	74 8b                	je     801570 <strsplit+0x23>
  8015e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e8:	8a 00                	mov    (%eax),%al
  8015ea:	0f be c0             	movsbl %al,%eax
  8015ed:	50                   	push   %eax
  8015ee:	ff 75 0c             	pushl  0xc(%ebp)
  8015f1:	e8 25 fa ff ff       	call   80101b <strchr>
  8015f6:	83 c4 08             	add    $0x8,%esp
  8015f9:	85 c0                	test   %eax,%eax
  8015fb:	74 dc                	je     8015d9 <strsplit+0x8c>
			string++;
	}
  8015fd:	e9 6e ff ff ff       	jmp    801570 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801602:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801603:	8b 45 14             	mov    0x14(%ebp),%eax
  801606:	8b 00                	mov    (%eax),%eax
  801608:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80160f:	8b 45 10             	mov    0x10(%ebp),%eax
  801612:	01 d0                	add    %edx,%eax
  801614:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80161a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80161f:	c9                   	leave  
  801620:	c3                   	ret    

00801621 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801621:	55                   	push   %ebp
  801622:	89 e5                	mov    %esp,%ebp
  801624:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801627:	8b 45 08             	mov    0x8(%ebp),%eax
  80162a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  80162d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801634:	eb 4a                	jmp    801680 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801636:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801639:	8b 45 08             	mov    0x8(%ebp),%eax
  80163c:	01 c2                	add    %eax,%edx
  80163e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801641:	8b 45 0c             	mov    0xc(%ebp),%eax
  801644:	01 c8                	add    %ecx,%eax
  801646:	8a 00                	mov    (%eax),%al
  801648:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  80164a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80164d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801650:	01 d0                	add    %edx,%eax
  801652:	8a 00                	mov    (%eax),%al
  801654:	3c 40                	cmp    $0x40,%al
  801656:	7e 25                	jle    80167d <str2lower+0x5c>
  801658:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80165b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80165e:	01 d0                	add    %edx,%eax
  801660:	8a 00                	mov    (%eax),%al
  801662:	3c 5a                	cmp    $0x5a,%al
  801664:	7f 17                	jg     80167d <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801666:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801669:	8b 45 08             	mov    0x8(%ebp),%eax
  80166c:	01 d0                	add    %edx,%eax
  80166e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801671:	8b 55 08             	mov    0x8(%ebp),%edx
  801674:	01 ca                	add    %ecx,%edx
  801676:	8a 12                	mov    (%edx),%dl
  801678:	83 c2 20             	add    $0x20,%edx
  80167b:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80167d:	ff 45 fc             	incl   -0x4(%ebp)
  801680:	ff 75 0c             	pushl  0xc(%ebp)
  801683:	e8 01 f8 ff ff       	call   800e89 <strlen>
  801688:	83 c4 04             	add    $0x4,%esp
  80168b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80168e:	7f a6                	jg     801636 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801690:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801693:	c9                   	leave  
  801694:	c3                   	ret    

00801695 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801695:	55                   	push   %ebp
  801696:	89 e5                	mov    %esp,%ebp
  801698:	57                   	push   %edi
  801699:	56                   	push   %esi
  80169a:	53                   	push   %ebx
  80169b:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80169e:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016a4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016a7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016aa:	8b 7d 18             	mov    0x18(%ebp),%edi
  8016ad:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8016b0:	cd 30                	int    $0x30
  8016b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8016b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8016b8:	83 c4 10             	add    $0x10,%esp
  8016bb:	5b                   	pop    %ebx
  8016bc:	5e                   	pop    %esi
  8016bd:	5f                   	pop    %edi
  8016be:	5d                   	pop    %ebp
  8016bf:	c3                   	ret    

008016c0 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8016c0:	55                   	push   %ebp
  8016c1:	89 e5                	mov    %esp,%ebp
  8016c3:	83 ec 04             	sub    $0x4,%esp
  8016c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8016c9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8016cc:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8016cf:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8016d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d6:	6a 00                	push   $0x0
  8016d8:	51                   	push   %ecx
  8016d9:	52                   	push   %edx
  8016da:	ff 75 0c             	pushl  0xc(%ebp)
  8016dd:	50                   	push   %eax
  8016de:	6a 00                	push   $0x0
  8016e0:	e8 b0 ff ff ff       	call   801695 <syscall>
  8016e5:	83 c4 18             	add    $0x18,%esp
}
  8016e8:	90                   	nop
  8016e9:	c9                   	leave  
  8016ea:	c3                   	ret    

008016eb <sys_cgetc>:

int
sys_cgetc(void)
{
  8016eb:	55                   	push   %ebp
  8016ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8016ee:	6a 00                	push   $0x0
  8016f0:	6a 00                	push   $0x0
  8016f2:	6a 00                	push   $0x0
  8016f4:	6a 00                	push   $0x0
  8016f6:	6a 00                	push   $0x0
  8016f8:	6a 02                	push   $0x2
  8016fa:	e8 96 ff ff ff       	call   801695 <syscall>
  8016ff:	83 c4 18             	add    $0x18,%esp
}
  801702:	c9                   	leave  
  801703:	c3                   	ret    

00801704 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801704:	55                   	push   %ebp
  801705:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801707:	6a 00                	push   $0x0
  801709:	6a 00                	push   $0x0
  80170b:	6a 00                	push   $0x0
  80170d:	6a 00                	push   $0x0
  80170f:	6a 00                	push   $0x0
  801711:	6a 03                	push   $0x3
  801713:	e8 7d ff ff ff       	call   801695 <syscall>
  801718:	83 c4 18             	add    $0x18,%esp
}
  80171b:	90                   	nop
  80171c:	c9                   	leave  
  80171d:	c3                   	ret    

0080171e <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80171e:	55                   	push   %ebp
  80171f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801721:	6a 00                	push   $0x0
  801723:	6a 00                	push   $0x0
  801725:	6a 00                	push   $0x0
  801727:	6a 00                	push   $0x0
  801729:	6a 00                	push   $0x0
  80172b:	6a 04                	push   $0x4
  80172d:	e8 63 ff ff ff       	call   801695 <syscall>
  801732:	83 c4 18             	add    $0x18,%esp
}
  801735:	90                   	nop
  801736:	c9                   	leave  
  801737:	c3                   	ret    

00801738 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801738:	55                   	push   %ebp
  801739:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80173b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80173e:	8b 45 08             	mov    0x8(%ebp),%eax
  801741:	6a 00                	push   $0x0
  801743:	6a 00                	push   $0x0
  801745:	6a 00                	push   $0x0
  801747:	52                   	push   %edx
  801748:	50                   	push   %eax
  801749:	6a 08                	push   $0x8
  80174b:	e8 45 ff ff ff       	call   801695 <syscall>
  801750:	83 c4 18             	add    $0x18,%esp
}
  801753:	c9                   	leave  
  801754:	c3                   	ret    

00801755 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801755:	55                   	push   %ebp
  801756:	89 e5                	mov    %esp,%ebp
  801758:	56                   	push   %esi
  801759:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80175a:	8b 75 18             	mov    0x18(%ebp),%esi
  80175d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801760:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801763:	8b 55 0c             	mov    0xc(%ebp),%edx
  801766:	8b 45 08             	mov    0x8(%ebp),%eax
  801769:	56                   	push   %esi
  80176a:	53                   	push   %ebx
  80176b:	51                   	push   %ecx
  80176c:	52                   	push   %edx
  80176d:	50                   	push   %eax
  80176e:	6a 09                	push   $0x9
  801770:	e8 20 ff ff ff       	call   801695 <syscall>
  801775:	83 c4 18             	add    $0x18,%esp
}
  801778:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80177b:	5b                   	pop    %ebx
  80177c:	5e                   	pop    %esi
  80177d:	5d                   	pop    %ebp
  80177e:	c3                   	ret    

0080177f <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  80177f:	55                   	push   %ebp
  801780:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801782:	6a 00                	push   $0x0
  801784:	6a 00                	push   $0x0
  801786:	6a 00                	push   $0x0
  801788:	6a 00                	push   $0x0
  80178a:	ff 75 08             	pushl  0x8(%ebp)
  80178d:	6a 0a                	push   $0xa
  80178f:	e8 01 ff ff ff       	call   801695 <syscall>
  801794:	83 c4 18             	add    $0x18,%esp
}
  801797:	c9                   	leave  
  801798:	c3                   	ret    

00801799 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801799:	55                   	push   %ebp
  80179a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80179c:	6a 00                	push   $0x0
  80179e:	6a 00                	push   $0x0
  8017a0:	6a 00                	push   $0x0
  8017a2:	ff 75 0c             	pushl  0xc(%ebp)
  8017a5:	ff 75 08             	pushl  0x8(%ebp)
  8017a8:	6a 0b                	push   $0xb
  8017aa:	e8 e6 fe ff ff       	call   801695 <syscall>
  8017af:	83 c4 18             	add    $0x18,%esp
}
  8017b2:	c9                   	leave  
  8017b3:	c3                   	ret    

008017b4 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8017b4:	55                   	push   %ebp
  8017b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8017b7:	6a 00                	push   $0x0
  8017b9:	6a 00                	push   $0x0
  8017bb:	6a 00                	push   $0x0
  8017bd:	6a 00                	push   $0x0
  8017bf:	6a 00                	push   $0x0
  8017c1:	6a 0c                	push   $0xc
  8017c3:	e8 cd fe ff ff       	call   801695 <syscall>
  8017c8:	83 c4 18             	add    $0x18,%esp
}
  8017cb:	c9                   	leave  
  8017cc:	c3                   	ret    

008017cd <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8017cd:	55                   	push   %ebp
  8017ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8017d0:	6a 00                	push   $0x0
  8017d2:	6a 00                	push   $0x0
  8017d4:	6a 00                	push   $0x0
  8017d6:	6a 00                	push   $0x0
  8017d8:	6a 00                	push   $0x0
  8017da:	6a 0d                	push   $0xd
  8017dc:	e8 b4 fe ff ff       	call   801695 <syscall>
  8017e1:	83 c4 18             	add    $0x18,%esp
}
  8017e4:	c9                   	leave  
  8017e5:	c3                   	ret    

008017e6 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8017e6:	55                   	push   %ebp
  8017e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8017e9:	6a 00                	push   $0x0
  8017eb:	6a 00                	push   $0x0
  8017ed:	6a 00                	push   $0x0
  8017ef:	6a 00                	push   $0x0
  8017f1:	6a 00                	push   $0x0
  8017f3:	6a 0e                	push   $0xe
  8017f5:	e8 9b fe ff ff       	call   801695 <syscall>
  8017fa:	83 c4 18             	add    $0x18,%esp
}
  8017fd:	c9                   	leave  
  8017fe:	c3                   	ret    

008017ff <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8017ff:	55                   	push   %ebp
  801800:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801802:	6a 00                	push   $0x0
  801804:	6a 00                	push   $0x0
  801806:	6a 00                	push   $0x0
  801808:	6a 00                	push   $0x0
  80180a:	6a 00                	push   $0x0
  80180c:	6a 0f                	push   $0xf
  80180e:	e8 82 fe ff ff       	call   801695 <syscall>
  801813:	83 c4 18             	add    $0x18,%esp
}
  801816:	c9                   	leave  
  801817:	c3                   	ret    

00801818 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801818:	55                   	push   %ebp
  801819:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80181b:	6a 00                	push   $0x0
  80181d:	6a 00                	push   $0x0
  80181f:	6a 00                	push   $0x0
  801821:	6a 00                	push   $0x0
  801823:	ff 75 08             	pushl  0x8(%ebp)
  801826:	6a 10                	push   $0x10
  801828:	e8 68 fe ff ff       	call   801695 <syscall>
  80182d:	83 c4 18             	add    $0x18,%esp
}
  801830:	c9                   	leave  
  801831:	c3                   	ret    

00801832 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801832:	55                   	push   %ebp
  801833:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801835:	6a 00                	push   $0x0
  801837:	6a 00                	push   $0x0
  801839:	6a 00                	push   $0x0
  80183b:	6a 00                	push   $0x0
  80183d:	6a 00                	push   $0x0
  80183f:	6a 11                	push   $0x11
  801841:	e8 4f fe ff ff       	call   801695 <syscall>
  801846:	83 c4 18             	add    $0x18,%esp
}
  801849:	90                   	nop
  80184a:	c9                   	leave  
  80184b:	c3                   	ret    

0080184c <sys_cputc>:

void
sys_cputc(const char c)
{
  80184c:	55                   	push   %ebp
  80184d:	89 e5                	mov    %esp,%ebp
  80184f:	83 ec 04             	sub    $0x4,%esp
  801852:	8b 45 08             	mov    0x8(%ebp),%eax
  801855:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801858:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80185c:	6a 00                	push   $0x0
  80185e:	6a 00                	push   $0x0
  801860:	6a 00                	push   $0x0
  801862:	6a 00                	push   $0x0
  801864:	50                   	push   %eax
  801865:	6a 01                	push   $0x1
  801867:	e8 29 fe ff ff       	call   801695 <syscall>
  80186c:	83 c4 18             	add    $0x18,%esp
}
  80186f:	90                   	nop
  801870:	c9                   	leave  
  801871:	c3                   	ret    

00801872 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801872:	55                   	push   %ebp
  801873:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	6a 00                	push   $0x0
  80187b:	6a 00                	push   $0x0
  80187d:	6a 00                	push   $0x0
  80187f:	6a 14                	push   $0x14
  801881:	e8 0f fe ff ff       	call   801695 <syscall>
  801886:	83 c4 18             	add    $0x18,%esp
}
  801889:	90                   	nop
  80188a:	c9                   	leave  
  80188b:	c3                   	ret    

0080188c <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80188c:	55                   	push   %ebp
  80188d:	89 e5                	mov    %esp,%ebp
  80188f:	83 ec 04             	sub    $0x4,%esp
  801892:	8b 45 10             	mov    0x10(%ebp),%eax
  801895:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801898:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80189b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80189f:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a2:	6a 00                	push   $0x0
  8018a4:	51                   	push   %ecx
  8018a5:	52                   	push   %edx
  8018a6:	ff 75 0c             	pushl  0xc(%ebp)
  8018a9:	50                   	push   %eax
  8018aa:	6a 15                	push   $0x15
  8018ac:	e8 e4 fd ff ff       	call   801695 <syscall>
  8018b1:	83 c4 18             	add    $0x18,%esp
}
  8018b4:	c9                   	leave  
  8018b5:	c3                   	ret    

008018b6 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8018b6:	55                   	push   %ebp
  8018b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8018b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bf:	6a 00                	push   $0x0
  8018c1:	6a 00                	push   $0x0
  8018c3:	6a 00                	push   $0x0
  8018c5:	52                   	push   %edx
  8018c6:	50                   	push   %eax
  8018c7:	6a 16                	push   $0x16
  8018c9:	e8 c7 fd ff ff       	call   801695 <syscall>
  8018ce:	83 c4 18             	add    $0x18,%esp
}
  8018d1:	c9                   	leave  
  8018d2:	c3                   	ret    

008018d3 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8018d3:	55                   	push   %ebp
  8018d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8018d6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018df:	6a 00                	push   $0x0
  8018e1:	6a 00                	push   $0x0
  8018e3:	51                   	push   %ecx
  8018e4:	52                   	push   %edx
  8018e5:	50                   	push   %eax
  8018e6:	6a 17                	push   $0x17
  8018e8:	e8 a8 fd ff ff       	call   801695 <syscall>
  8018ed:	83 c4 18             	add    $0x18,%esp
}
  8018f0:	c9                   	leave  
  8018f1:	c3                   	ret    

008018f2 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8018f2:	55                   	push   %ebp
  8018f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8018f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fb:	6a 00                	push   $0x0
  8018fd:	6a 00                	push   $0x0
  8018ff:	6a 00                	push   $0x0
  801901:	52                   	push   %edx
  801902:	50                   	push   %eax
  801903:	6a 18                	push   $0x18
  801905:	e8 8b fd ff ff       	call   801695 <syscall>
  80190a:	83 c4 18             	add    $0x18,%esp
}
  80190d:	c9                   	leave  
  80190e:	c3                   	ret    

0080190f <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80190f:	55                   	push   %ebp
  801910:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801912:	8b 45 08             	mov    0x8(%ebp),%eax
  801915:	6a 00                	push   $0x0
  801917:	ff 75 14             	pushl  0x14(%ebp)
  80191a:	ff 75 10             	pushl  0x10(%ebp)
  80191d:	ff 75 0c             	pushl  0xc(%ebp)
  801920:	50                   	push   %eax
  801921:	6a 19                	push   $0x19
  801923:	e8 6d fd ff ff       	call   801695 <syscall>
  801928:	83 c4 18             	add    $0x18,%esp
}
  80192b:	c9                   	leave  
  80192c:	c3                   	ret    

0080192d <sys_run_env>:

void sys_run_env(int32 envId)
{
  80192d:	55                   	push   %ebp
  80192e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801930:	8b 45 08             	mov    0x8(%ebp),%eax
  801933:	6a 00                	push   $0x0
  801935:	6a 00                	push   $0x0
  801937:	6a 00                	push   $0x0
  801939:	6a 00                	push   $0x0
  80193b:	50                   	push   %eax
  80193c:	6a 1a                	push   $0x1a
  80193e:	e8 52 fd ff ff       	call   801695 <syscall>
  801943:	83 c4 18             	add    $0x18,%esp
}
  801946:	90                   	nop
  801947:	c9                   	leave  
  801948:	c3                   	ret    

00801949 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801949:	55                   	push   %ebp
  80194a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80194c:	8b 45 08             	mov    0x8(%ebp),%eax
  80194f:	6a 00                	push   $0x0
  801951:	6a 00                	push   $0x0
  801953:	6a 00                	push   $0x0
  801955:	6a 00                	push   $0x0
  801957:	50                   	push   %eax
  801958:	6a 1b                	push   $0x1b
  80195a:	e8 36 fd ff ff       	call   801695 <syscall>
  80195f:	83 c4 18             	add    $0x18,%esp
}
  801962:	c9                   	leave  
  801963:	c3                   	ret    

00801964 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801964:	55                   	push   %ebp
  801965:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801967:	6a 00                	push   $0x0
  801969:	6a 00                	push   $0x0
  80196b:	6a 00                	push   $0x0
  80196d:	6a 00                	push   $0x0
  80196f:	6a 00                	push   $0x0
  801971:	6a 05                	push   $0x5
  801973:	e8 1d fd ff ff       	call   801695 <syscall>
  801978:	83 c4 18             	add    $0x18,%esp
}
  80197b:	c9                   	leave  
  80197c:	c3                   	ret    

0080197d <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80197d:	55                   	push   %ebp
  80197e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801980:	6a 00                	push   $0x0
  801982:	6a 00                	push   $0x0
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	6a 00                	push   $0x0
  80198a:	6a 06                	push   $0x6
  80198c:	e8 04 fd ff ff       	call   801695 <syscall>
  801991:	83 c4 18             	add    $0x18,%esp
}
  801994:	c9                   	leave  
  801995:	c3                   	ret    

00801996 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801996:	55                   	push   %ebp
  801997:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801999:	6a 00                	push   $0x0
  80199b:	6a 00                	push   $0x0
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 07                	push   $0x7
  8019a5:	e8 eb fc ff ff       	call   801695 <syscall>
  8019aa:	83 c4 18             	add    $0x18,%esp
}
  8019ad:	c9                   	leave  
  8019ae:	c3                   	ret    

008019af <sys_exit_env>:


void sys_exit_env(void)
{
  8019af:	55                   	push   %ebp
  8019b0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8019b2:	6a 00                	push   $0x0
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 1c                	push   $0x1c
  8019be:	e8 d2 fc ff ff       	call   801695 <syscall>
  8019c3:	83 c4 18             	add    $0x18,%esp
}
  8019c6:	90                   	nop
  8019c7:	c9                   	leave  
  8019c8:	c3                   	ret    

008019c9 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8019c9:	55                   	push   %ebp
  8019ca:	89 e5                	mov    %esp,%ebp
  8019cc:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8019cf:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8019d2:	8d 50 04             	lea    0x4(%eax),%edx
  8019d5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8019d8:	6a 00                	push   $0x0
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 00                	push   $0x0
  8019de:	52                   	push   %edx
  8019df:	50                   	push   %eax
  8019e0:	6a 1d                	push   $0x1d
  8019e2:	e8 ae fc ff ff       	call   801695 <syscall>
  8019e7:	83 c4 18             	add    $0x18,%esp
	return result;
  8019ea:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019f0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019f3:	89 01                	mov    %eax,(%ecx)
  8019f5:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8019f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fb:	c9                   	leave  
  8019fc:	c2 04 00             	ret    $0x4

008019ff <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8019ff:	55                   	push   %ebp
  801a00:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801a02:	6a 00                	push   $0x0
  801a04:	6a 00                	push   $0x0
  801a06:	ff 75 10             	pushl  0x10(%ebp)
  801a09:	ff 75 0c             	pushl  0xc(%ebp)
  801a0c:	ff 75 08             	pushl  0x8(%ebp)
  801a0f:	6a 13                	push   $0x13
  801a11:	e8 7f fc ff ff       	call   801695 <syscall>
  801a16:	83 c4 18             	add    $0x18,%esp
	return ;
  801a19:	90                   	nop
}
  801a1a:	c9                   	leave  
  801a1b:	c3                   	ret    

00801a1c <sys_rcr2>:
uint32 sys_rcr2()
{
  801a1c:	55                   	push   %ebp
  801a1d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 00                	push   $0x0
  801a23:	6a 00                	push   $0x0
  801a25:	6a 00                	push   $0x0
  801a27:	6a 00                	push   $0x0
  801a29:	6a 1e                	push   $0x1e
  801a2b:	e8 65 fc ff ff       	call   801695 <syscall>
  801a30:	83 c4 18             	add    $0x18,%esp
}
  801a33:	c9                   	leave  
  801a34:	c3                   	ret    

00801a35 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801a35:	55                   	push   %ebp
  801a36:	89 e5                	mov    %esp,%ebp
  801a38:	83 ec 04             	sub    $0x4,%esp
  801a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801a41:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801a45:	6a 00                	push   $0x0
  801a47:	6a 00                	push   $0x0
  801a49:	6a 00                	push   $0x0
  801a4b:	6a 00                	push   $0x0
  801a4d:	50                   	push   %eax
  801a4e:	6a 1f                	push   $0x1f
  801a50:	e8 40 fc ff ff       	call   801695 <syscall>
  801a55:	83 c4 18             	add    $0x18,%esp
	return ;
  801a58:	90                   	nop
}
  801a59:	c9                   	leave  
  801a5a:	c3                   	ret    

00801a5b <rsttst>:
void rsttst()
{
  801a5b:	55                   	push   %ebp
  801a5c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 00                	push   $0x0
  801a62:	6a 00                	push   $0x0
  801a64:	6a 00                	push   $0x0
  801a66:	6a 00                	push   $0x0
  801a68:	6a 21                	push   $0x21
  801a6a:	e8 26 fc ff ff       	call   801695 <syscall>
  801a6f:	83 c4 18             	add    $0x18,%esp
	return ;
  801a72:	90                   	nop
}
  801a73:	c9                   	leave  
  801a74:	c3                   	ret    

00801a75 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801a75:	55                   	push   %ebp
  801a76:	89 e5                	mov    %esp,%ebp
  801a78:	83 ec 04             	sub    $0x4,%esp
  801a7b:	8b 45 14             	mov    0x14(%ebp),%eax
  801a7e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801a81:	8b 55 18             	mov    0x18(%ebp),%edx
  801a84:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a88:	52                   	push   %edx
  801a89:	50                   	push   %eax
  801a8a:	ff 75 10             	pushl  0x10(%ebp)
  801a8d:	ff 75 0c             	pushl  0xc(%ebp)
  801a90:	ff 75 08             	pushl  0x8(%ebp)
  801a93:	6a 20                	push   $0x20
  801a95:	e8 fb fb ff ff       	call   801695 <syscall>
  801a9a:	83 c4 18             	add    $0x18,%esp
	return ;
  801a9d:	90                   	nop
}
  801a9e:	c9                   	leave  
  801a9f:	c3                   	ret    

00801aa0 <chktst>:
void chktst(uint32 n)
{
  801aa0:	55                   	push   %ebp
  801aa1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801aa3:	6a 00                	push   $0x0
  801aa5:	6a 00                	push   $0x0
  801aa7:	6a 00                	push   $0x0
  801aa9:	6a 00                	push   $0x0
  801aab:	ff 75 08             	pushl  0x8(%ebp)
  801aae:	6a 22                	push   $0x22
  801ab0:	e8 e0 fb ff ff       	call   801695 <syscall>
  801ab5:	83 c4 18             	add    $0x18,%esp
	return ;
  801ab8:	90                   	nop
}
  801ab9:	c9                   	leave  
  801aba:	c3                   	ret    

00801abb <inctst>:

void inctst()
{
  801abb:	55                   	push   %ebp
  801abc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801abe:	6a 00                	push   $0x0
  801ac0:	6a 00                	push   $0x0
  801ac2:	6a 00                	push   $0x0
  801ac4:	6a 00                	push   $0x0
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 23                	push   $0x23
  801aca:	e8 c6 fb ff ff       	call   801695 <syscall>
  801acf:	83 c4 18             	add    $0x18,%esp
	return ;
  801ad2:	90                   	nop
}
  801ad3:	c9                   	leave  
  801ad4:	c3                   	ret    

00801ad5 <gettst>:
uint32 gettst()
{
  801ad5:	55                   	push   %ebp
  801ad6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801ad8:	6a 00                	push   $0x0
  801ada:	6a 00                	push   $0x0
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 24                	push   $0x24
  801ae4:	e8 ac fb ff ff       	call   801695 <syscall>
  801ae9:	83 c4 18             	add    $0x18,%esp
}
  801aec:	c9                   	leave  
  801aed:	c3                   	ret    

00801aee <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801aee:	55                   	push   %ebp
  801aef:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801af1:	6a 00                	push   $0x0
  801af3:	6a 00                	push   $0x0
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	6a 25                	push   $0x25
  801afd:	e8 93 fb ff ff       	call   801695 <syscall>
  801b02:	83 c4 18             	add    $0x18,%esp
  801b05:	a3 80 70 82 00       	mov    %eax,0x827080
	return uheapPlaceStrategy ;
  801b0a:	a1 80 70 82 00       	mov    0x827080,%eax
}
  801b0f:	c9                   	leave  
  801b10:	c3                   	ret    

00801b11 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801b11:	55                   	push   %ebp
  801b12:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801b14:	8b 45 08             	mov    0x8(%ebp),%eax
  801b17:	a3 80 70 82 00       	mov    %eax,0x827080
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	ff 75 08             	pushl  0x8(%ebp)
  801b27:	6a 26                	push   $0x26
  801b29:	e8 67 fb ff ff       	call   801695 <syscall>
  801b2e:	83 c4 18             	add    $0x18,%esp
	return ;
  801b31:	90                   	nop
}
  801b32:	c9                   	leave  
  801b33:	c3                   	ret    

00801b34 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801b34:	55                   	push   %ebp
  801b35:	89 e5                	mov    %esp,%ebp
  801b37:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801b38:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b3b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b3e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b41:	8b 45 08             	mov    0x8(%ebp),%eax
  801b44:	6a 00                	push   $0x0
  801b46:	53                   	push   %ebx
  801b47:	51                   	push   %ecx
  801b48:	52                   	push   %edx
  801b49:	50                   	push   %eax
  801b4a:	6a 27                	push   $0x27
  801b4c:	e8 44 fb ff ff       	call   801695 <syscall>
  801b51:	83 c4 18             	add    $0x18,%esp
}
  801b54:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b57:	c9                   	leave  
  801b58:	c3                   	ret    

00801b59 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801b59:	55                   	push   %ebp
  801b5a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801b5c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b62:	6a 00                	push   $0x0
  801b64:	6a 00                	push   $0x0
  801b66:	6a 00                	push   $0x0
  801b68:	52                   	push   %edx
  801b69:	50                   	push   %eax
  801b6a:	6a 28                	push   $0x28
  801b6c:	e8 24 fb ff ff       	call   801695 <syscall>
  801b71:	83 c4 18             	add    $0x18,%esp
}
  801b74:	c9                   	leave  
  801b75:	c3                   	ret    

00801b76 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801b76:	55                   	push   %ebp
  801b77:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801b79:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b7c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b82:	6a 00                	push   $0x0
  801b84:	51                   	push   %ecx
  801b85:	ff 75 10             	pushl  0x10(%ebp)
  801b88:	52                   	push   %edx
  801b89:	50                   	push   %eax
  801b8a:	6a 29                	push   $0x29
  801b8c:	e8 04 fb ff ff       	call   801695 <syscall>
  801b91:	83 c4 18             	add    $0x18,%esp
}
  801b94:	c9                   	leave  
  801b95:	c3                   	ret    

00801b96 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b96:	55                   	push   %ebp
  801b97:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b99:	6a 00                	push   $0x0
  801b9b:	6a 00                	push   $0x0
  801b9d:	ff 75 10             	pushl  0x10(%ebp)
  801ba0:	ff 75 0c             	pushl  0xc(%ebp)
  801ba3:	ff 75 08             	pushl  0x8(%ebp)
  801ba6:	6a 12                	push   $0x12
  801ba8:	e8 e8 fa ff ff       	call   801695 <syscall>
  801bad:	83 c4 18             	add    $0x18,%esp
	return ;
  801bb0:	90                   	nop
}
  801bb1:	c9                   	leave  
  801bb2:	c3                   	ret    

00801bb3 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801bb3:	55                   	push   %ebp
  801bb4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801bb6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbc:	6a 00                	push   $0x0
  801bbe:	6a 00                	push   $0x0
  801bc0:	6a 00                	push   $0x0
  801bc2:	52                   	push   %edx
  801bc3:	50                   	push   %eax
  801bc4:	6a 2a                	push   $0x2a
  801bc6:	e8 ca fa ff ff       	call   801695 <syscall>
  801bcb:	83 c4 18             	add    $0x18,%esp
	return;
  801bce:	90                   	nop
}
  801bcf:	c9                   	leave  
  801bd0:	c3                   	ret    

00801bd1 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801bd1:	55                   	push   %ebp
  801bd2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 2b                	push   $0x2b
  801be0:	e8 b0 fa ff ff       	call   801695 <syscall>
  801be5:	83 c4 18             	add    $0x18,%esp
}
  801be8:	c9                   	leave  
  801be9:	c3                   	ret    

00801bea <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801bea:	55                   	push   %ebp
  801beb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801bed:	6a 00                	push   $0x0
  801bef:	6a 00                	push   $0x0
  801bf1:	6a 00                	push   $0x0
  801bf3:	ff 75 0c             	pushl  0xc(%ebp)
  801bf6:	ff 75 08             	pushl  0x8(%ebp)
  801bf9:	6a 2d                	push   $0x2d
  801bfb:	e8 95 fa ff ff       	call   801695 <syscall>
  801c00:	83 c4 18             	add    $0x18,%esp
	return;
  801c03:	90                   	nop
}
  801c04:	c9                   	leave  
  801c05:	c3                   	ret    

00801c06 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801c06:	55                   	push   %ebp
  801c07:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 00                	push   $0x0
  801c0f:	ff 75 0c             	pushl  0xc(%ebp)
  801c12:	ff 75 08             	pushl  0x8(%ebp)
  801c15:	6a 2c                	push   $0x2c
  801c17:	e8 79 fa ff ff       	call   801695 <syscall>
  801c1c:	83 c4 18             	add    $0x18,%esp
	return ;
  801c1f:	90                   	nop
}
  801c20:	c9                   	leave  
  801c21:	c3                   	ret    

00801c22 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801c22:	55                   	push   %ebp
  801c23:	89 e5                	mov    %esp,%ebp
  801c25:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801c28:	83 ec 04             	sub    $0x4,%esp
  801c2b:	68 e8 25 80 00       	push   $0x8025e8
  801c30:	68 25 01 00 00       	push   $0x125
  801c35:	68 1b 26 80 00       	push   $0x80261b
  801c3a:	e8 a3 e8 ff ff       	call   8004e2 <_panic>
  801c3f:	90                   	nop

00801c40 <__udivdi3>:
  801c40:	55                   	push   %ebp
  801c41:	57                   	push   %edi
  801c42:	56                   	push   %esi
  801c43:	53                   	push   %ebx
  801c44:	83 ec 1c             	sub    $0x1c,%esp
  801c47:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801c4b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801c4f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c53:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c57:	89 ca                	mov    %ecx,%edx
  801c59:	89 f8                	mov    %edi,%eax
  801c5b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801c5f:	85 f6                	test   %esi,%esi
  801c61:	75 2d                	jne    801c90 <__udivdi3+0x50>
  801c63:	39 cf                	cmp    %ecx,%edi
  801c65:	77 65                	ja     801ccc <__udivdi3+0x8c>
  801c67:	89 fd                	mov    %edi,%ebp
  801c69:	85 ff                	test   %edi,%edi
  801c6b:	75 0b                	jne    801c78 <__udivdi3+0x38>
  801c6d:	b8 01 00 00 00       	mov    $0x1,%eax
  801c72:	31 d2                	xor    %edx,%edx
  801c74:	f7 f7                	div    %edi
  801c76:	89 c5                	mov    %eax,%ebp
  801c78:	31 d2                	xor    %edx,%edx
  801c7a:	89 c8                	mov    %ecx,%eax
  801c7c:	f7 f5                	div    %ebp
  801c7e:	89 c1                	mov    %eax,%ecx
  801c80:	89 d8                	mov    %ebx,%eax
  801c82:	f7 f5                	div    %ebp
  801c84:	89 cf                	mov    %ecx,%edi
  801c86:	89 fa                	mov    %edi,%edx
  801c88:	83 c4 1c             	add    $0x1c,%esp
  801c8b:	5b                   	pop    %ebx
  801c8c:	5e                   	pop    %esi
  801c8d:	5f                   	pop    %edi
  801c8e:	5d                   	pop    %ebp
  801c8f:	c3                   	ret    
  801c90:	39 ce                	cmp    %ecx,%esi
  801c92:	77 28                	ja     801cbc <__udivdi3+0x7c>
  801c94:	0f bd fe             	bsr    %esi,%edi
  801c97:	83 f7 1f             	xor    $0x1f,%edi
  801c9a:	75 40                	jne    801cdc <__udivdi3+0x9c>
  801c9c:	39 ce                	cmp    %ecx,%esi
  801c9e:	72 0a                	jb     801caa <__udivdi3+0x6a>
  801ca0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801ca4:	0f 87 9e 00 00 00    	ja     801d48 <__udivdi3+0x108>
  801caa:	b8 01 00 00 00       	mov    $0x1,%eax
  801caf:	89 fa                	mov    %edi,%edx
  801cb1:	83 c4 1c             	add    $0x1c,%esp
  801cb4:	5b                   	pop    %ebx
  801cb5:	5e                   	pop    %esi
  801cb6:	5f                   	pop    %edi
  801cb7:	5d                   	pop    %ebp
  801cb8:	c3                   	ret    
  801cb9:	8d 76 00             	lea    0x0(%esi),%esi
  801cbc:	31 ff                	xor    %edi,%edi
  801cbe:	31 c0                	xor    %eax,%eax
  801cc0:	89 fa                	mov    %edi,%edx
  801cc2:	83 c4 1c             	add    $0x1c,%esp
  801cc5:	5b                   	pop    %ebx
  801cc6:	5e                   	pop    %esi
  801cc7:	5f                   	pop    %edi
  801cc8:	5d                   	pop    %ebp
  801cc9:	c3                   	ret    
  801cca:	66 90                	xchg   %ax,%ax
  801ccc:	89 d8                	mov    %ebx,%eax
  801cce:	f7 f7                	div    %edi
  801cd0:	31 ff                	xor    %edi,%edi
  801cd2:	89 fa                	mov    %edi,%edx
  801cd4:	83 c4 1c             	add    $0x1c,%esp
  801cd7:	5b                   	pop    %ebx
  801cd8:	5e                   	pop    %esi
  801cd9:	5f                   	pop    %edi
  801cda:	5d                   	pop    %ebp
  801cdb:	c3                   	ret    
  801cdc:	bd 20 00 00 00       	mov    $0x20,%ebp
  801ce1:	89 eb                	mov    %ebp,%ebx
  801ce3:	29 fb                	sub    %edi,%ebx
  801ce5:	89 f9                	mov    %edi,%ecx
  801ce7:	d3 e6                	shl    %cl,%esi
  801ce9:	89 c5                	mov    %eax,%ebp
  801ceb:	88 d9                	mov    %bl,%cl
  801ced:	d3 ed                	shr    %cl,%ebp
  801cef:	89 e9                	mov    %ebp,%ecx
  801cf1:	09 f1                	or     %esi,%ecx
  801cf3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801cf7:	89 f9                	mov    %edi,%ecx
  801cf9:	d3 e0                	shl    %cl,%eax
  801cfb:	89 c5                	mov    %eax,%ebp
  801cfd:	89 d6                	mov    %edx,%esi
  801cff:	88 d9                	mov    %bl,%cl
  801d01:	d3 ee                	shr    %cl,%esi
  801d03:	89 f9                	mov    %edi,%ecx
  801d05:	d3 e2                	shl    %cl,%edx
  801d07:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d0b:	88 d9                	mov    %bl,%cl
  801d0d:	d3 e8                	shr    %cl,%eax
  801d0f:	09 c2                	or     %eax,%edx
  801d11:	89 d0                	mov    %edx,%eax
  801d13:	89 f2                	mov    %esi,%edx
  801d15:	f7 74 24 0c          	divl   0xc(%esp)
  801d19:	89 d6                	mov    %edx,%esi
  801d1b:	89 c3                	mov    %eax,%ebx
  801d1d:	f7 e5                	mul    %ebp
  801d1f:	39 d6                	cmp    %edx,%esi
  801d21:	72 19                	jb     801d3c <__udivdi3+0xfc>
  801d23:	74 0b                	je     801d30 <__udivdi3+0xf0>
  801d25:	89 d8                	mov    %ebx,%eax
  801d27:	31 ff                	xor    %edi,%edi
  801d29:	e9 58 ff ff ff       	jmp    801c86 <__udivdi3+0x46>
  801d2e:	66 90                	xchg   %ax,%ax
  801d30:	8b 54 24 08          	mov    0x8(%esp),%edx
  801d34:	89 f9                	mov    %edi,%ecx
  801d36:	d3 e2                	shl    %cl,%edx
  801d38:	39 c2                	cmp    %eax,%edx
  801d3a:	73 e9                	jae    801d25 <__udivdi3+0xe5>
  801d3c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801d3f:	31 ff                	xor    %edi,%edi
  801d41:	e9 40 ff ff ff       	jmp    801c86 <__udivdi3+0x46>
  801d46:	66 90                	xchg   %ax,%ax
  801d48:	31 c0                	xor    %eax,%eax
  801d4a:	e9 37 ff ff ff       	jmp    801c86 <__udivdi3+0x46>
  801d4f:	90                   	nop

00801d50 <__umoddi3>:
  801d50:	55                   	push   %ebp
  801d51:	57                   	push   %edi
  801d52:	56                   	push   %esi
  801d53:	53                   	push   %ebx
  801d54:	83 ec 1c             	sub    $0x1c,%esp
  801d57:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801d5b:	8b 74 24 34          	mov    0x34(%esp),%esi
  801d5f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d63:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801d67:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d6b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d6f:	89 f3                	mov    %esi,%ebx
  801d71:	89 fa                	mov    %edi,%edx
  801d73:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d77:	89 34 24             	mov    %esi,(%esp)
  801d7a:	85 c0                	test   %eax,%eax
  801d7c:	75 1a                	jne    801d98 <__umoddi3+0x48>
  801d7e:	39 f7                	cmp    %esi,%edi
  801d80:	0f 86 a2 00 00 00    	jbe    801e28 <__umoddi3+0xd8>
  801d86:	89 c8                	mov    %ecx,%eax
  801d88:	89 f2                	mov    %esi,%edx
  801d8a:	f7 f7                	div    %edi
  801d8c:	89 d0                	mov    %edx,%eax
  801d8e:	31 d2                	xor    %edx,%edx
  801d90:	83 c4 1c             	add    $0x1c,%esp
  801d93:	5b                   	pop    %ebx
  801d94:	5e                   	pop    %esi
  801d95:	5f                   	pop    %edi
  801d96:	5d                   	pop    %ebp
  801d97:	c3                   	ret    
  801d98:	39 f0                	cmp    %esi,%eax
  801d9a:	0f 87 ac 00 00 00    	ja     801e4c <__umoddi3+0xfc>
  801da0:	0f bd e8             	bsr    %eax,%ebp
  801da3:	83 f5 1f             	xor    $0x1f,%ebp
  801da6:	0f 84 ac 00 00 00    	je     801e58 <__umoddi3+0x108>
  801dac:	bf 20 00 00 00       	mov    $0x20,%edi
  801db1:	29 ef                	sub    %ebp,%edi
  801db3:	89 fe                	mov    %edi,%esi
  801db5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801db9:	89 e9                	mov    %ebp,%ecx
  801dbb:	d3 e0                	shl    %cl,%eax
  801dbd:	89 d7                	mov    %edx,%edi
  801dbf:	89 f1                	mov    %esi,%ecx
  801dc1:	d3 ef                	shr    %cl,%edi
  801dc3:	09 c7                	or     %eax,%edi
  801dc5:	89 e9                	mov    %ebp,%ecx
  801dc7:	d3 e2                	shl    %cl,%edx
  801dc9:	89 14 24             	mov    %edx,(%esp)
  801dcc:	89 d8                	mov    %ebx,%eax
  801dce:	d3 e0                	shl    %cl,%eax
  801dd0:	89 c2                	mov    %eax,%edx
  801dd2:	8b 44 24 08          	mov    0x8(%esp),%eax
  801dd6:	d3 e0                	shl    %cl,%eax
  801dd8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ddc:	8b 44 24 08          	mov    0x8(%esp),%eax
  801de0:	89 f1                	mov    %esi,%ecx
  801de2:	d3 e8                	shr    %cl,%eax
  801de4:	09 d0                	or     %edx,%eax
  801de6:	d3 eb                	shr    %cl,%ebx
  801de8:	89 da                	mov    %ebx,%edx
  801dea:	f7 f7                	div    %edi
  801dec:	89 d3                	mov    %edx,%ebx
  801dee:	f7 24 24             	mull   (%esp)
  801df1:	89 c6                	mov    %eax,%esi
  801df3:	89 d1                	mov    %edx,%ecx
  801df5:	39 d3                	cmp    %edx,%ebx
  801df7:	0f 82 87 00 00 00    	jb     801e84 <__umoddi3+0x134>
  801dfd:	0f 84 91 00 00 00    	je     801e94 <__umoddi3+0x144>
  801e03:	8b 54 24 04          	mov    0x4(%esp),%edx
  801e07:	29 f2                	sub    %esi,%edx
  801e09:	19 cb                	sbb    %ecx,%ebx
  801e0b:	89 d8                	mov    %ebx,%eax
  801e0d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801e11:	d3 e0                	shl    %cl,%eax
  801e13:	89 e9                	mov    %ebp,%ecx
  801e15:	d3 ea                	shr    %cl,%edx
  801e17:	09 d0                	or     %edx,%eax
  801e19:	89 e9                	mov    %ebp,%ecx
  801e1b:	d3 eb                	shr    %cl,%ebx
  801e1d:	89 da                	mov    %ebx,%edx
  801e1f:	83 c4 1c             	add    $0x1c,%esp
  801e22:	5b                   	pop    %ebx
  801e23:	5e                   	pop    %esi
  801e24:	5f                   	pop    %edi
  801e25:	5d                   	pop    %ebp
  801e26:	c3                   	ret    
  801e27:	90                   	nop
  801e28:	89 fd                	mov    %edi,%ebp
  801e2a:	85 ff                	test   %edi,%edi
  801e2c:	75 0b                	jne    801e39 <__umoddi3+0xe9>
  801e2e:	b8 01 00 00 00       	mov    $0x1,%eax
  801e33:	31 d2                	xor    %edx,%edx
  801e35:	f7 f7                	div    %edi
  801e37:	89 c5                	mov    %eax,%ebp
  801e39:	89 f0                	mov    %esi,%eax
  801e3b:	31 d2                	xor    %edx,%edx
  801e3d:	f7 f5                	div    %ebp
  801e3f:	89 c8                	mov    %ecx,%eax
  801e41:	f7 f5                	div    %ebp
  801e43:	89 d0                	mov    %edx,%eax
  801e45:	e9 44 ff ff ff       	jmp    801d8e <__umoddi3+0x3e>
  801e4a:	66 90                	xchg   %ax,%ax
  801e4c:	89 c8                	mov    %ecx,%eax
  801e4e:	89 f2                	mov    %esi,%edx
  801e50:	83 c4 1c             	add    $0x1c,%esp
  801e53:	5b                   	pop    %ebx
  801e54:	5e                   	pop    %esi
  801e55:	5f                   	pop    %edi
  801e56:	5d                   	pop    %ebp
  801e57:	c3                   	ret    
  801e58:	3b 04 24             	cmp    (%esp),%eax
  801e5b:	72 06                	jb     801e63 <__umoddi3+0x113>
  801e5d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801e61:	77 0f                	ja     801e72 <__umoddi3+0x122>
  801e63:	89 f2                	mov    %esi,%edx
  801e65:	29 f9                	sub    %edi,%ecx
  801e67:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801e6b:	89 14 24             	mov    %edx,(%esp)
  801e6e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e72:	8b 44 24 04          	mov    0x4(%esp),%eax
  801e76:	8b 14 24             	mov    (%esp),%edx
  801e79:	83 c4 1c             	add    $0x1c,%esp
  801e7c:	5b                   	pop    %ebx
  801e7d:	5e                   	pop    %esi
  801e7e:	5f                   	pop    %edi
  801e7f:	5d                   	pop    %ebp
  801e80:	c3                   	ret    
  801e81:	8d 76 00             	lea    0x0(%esi),%esi
  801e84:	2b 04 24             	sub    (%esp),%eax
  801e87:	19 fa                	sbb    %edi,%edx
  801e89:	89 d1                	mov    %edx,%ecx
  801e8b:	89 c6                	mov    %eax,%esi
  801e8d:	e9 71 ff ff ff       	jmp    801e03 <__umoddi3+0xb3>
  801e92:	66 90                	xchg   %ax,%ax
  801e94:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801e98:	72 ea                	jb     801e84 <__umoddi3+0x134>
  801e9a:	89 d9                	mov    %ebx,%ecx
  801e9c:	e9 62 ff ff ff       	jmp    801e03 <__umoddi3+0xb3>

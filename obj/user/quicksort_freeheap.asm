
obj/user/quicksort_freeheap:     file format elf32-i386


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
  800031:	e8 5d 05 00 00       	call   800593 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
void QuickSort(int *Elements, int NumOfElements);
void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex);
uint32 CheckSorted(int *Elements, int NumOfElements);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	81 ec 24 01 00 00    	sub    $0x124,%esp
	char Chose ;
	char Line[255] ;
	int Iteration = 0 ;
  800042:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	do
	{
		int InitFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames();
  800049:	e8 86 1d 00 00       	call   801dd4 <sys_calculate_free_frames>
  80004e:	89 c3                	mov    %eax,%ebx
  800050:	e8 98 1d 00 00       	call   801ded <sys_calculate_modified_frames>
  800055:	01 d8                	add    %ebx,%eax
  800057:	89 45 f0             	mov    %eax,-0x10(%ebp)

		Iteration++ ;
  80005a:	ff 45 f4             	incl   -0xc(%ebp)
		//		cprintf("Free Frames Before Allocation = %d\n", sys_calculate_free_frames()) ;

		//	sys_lock_cons();

		readline("Enter the number of elements: ", Line);
  80005d:	83 ec 08             	sub    $0x8,%esp
  800060:	8d 85 e1 fe ff ff    	lea    -0x11f(%ebp),%eax
  800066:	50                   	push   %eax
  800067:	68 20 26 80 00       	push   $0x802620
  80006c:	e8 79 10 00 00       	call   8010ea <readline>
  800071:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = strtol(Line, NULL, 10) ;
  800074:	83 ec 04             	sub    $0x4,%esp
  800077:	6a 0a                	push   $0xa
  800079:	6a 00                	push   $0x0
  80007b:	8d 85 e1 fe ff ff    	lea    -0x11f(%ebp),%eax
  800081:	50                   	push   %eax
  800082:	e8 7a 16 00 00       	call   801701 <strtol>
  800087:	83 c4 10             	add    $0x10,%esp
  80008a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  80008d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800090:	c1 e0 02             	shl    $0x2,%eax
  800093:	83 ec 0c             	sub    $0xc,%esp
  800096:	50                   	push   %eax
  800097:	e8 3f 1b 00 00       	call   801bdb <malloc>
  80009c:	83 c4 10             	add    $0x10,%esp
  80009f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		cprintf("Choose the initialization method:\n") ;
  8000a2:	83 ec 0c             	sub    $0xc,%esp
  8000a5:	68 40 26 80 00       	push   $0x802640
  8000aa:	e8 62 09 00 00       	call   800a11 <cprintf>
  8000af:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000b2:	83 ec 0c             	sub    $0xc,%esp
  8000b5:	68 63 26 80 00       	push   $0x802663
  8000ba:	e8 52 09 00 00       	call   800a11 <cprintf>
  8000bf:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000c2:	83 ec 0c             	sub    $0xc,%esp
  8000c5:	68 71 26 80 00       	push   $0x802671
  8000ca:	e8 42 09 00 00       	call   800a11 <cprintf>
  8000cf:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  8000d2:	83 ec 0c             	sub    $0xc,%esp
  8000d5:	68 80 26 80 00       	push   $0x802680
  8000da:	e8 32 09 00 00       	call   800a11 <cprintf>
  8000df:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  8000e2:	83 ec 0c             	sub    $0xc,%esp
  8000e5:	68 90 26 80 00       	push   $0x802690
  8000ea:	e8 22 09 00 00       	call   800a11 <cprintf>
  8000ef:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  8000f2:	e8 7f 04 00 00       	call   800576 <getchar>
  8000f7:	88 45 e7             	mov    %al,-0x19(%ebp)
			cputchar(Chose);
  8000fa:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  8000fe:	83 ec 0c             	sub    $0xc,%esp
  800101:	50                   	push   %eax
  800102:	e8 50 04 00 00       	call   800557 <cputchar>
  800107:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  80010a:	83 ec 0c             	sub    $0xc,%esp
  80010d:	6a 0a                	push   $0xa
  80010f:	e8 43 04 00 00       	call   800557 <cputchar>
  800114:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800117:	80 7d e7 61          	cmpb   $0x61,-0x19(%ebp)
  80011b:	74 0c                	je     800129 <_main+0xf1>
  80011d:	80 7d e7 62          	cmpb   $0x62,-0x19(%ebp)
  800121:	74 06                	je     800129 <_main+0xf1>
  800123:	80 7d e7 63          	cmpb   $0x63,-0x19(%ebp)
  800127:	75 b9                	jne    8000e2 <_main+0xaa>
		//sys_unlock_cons();
		int  i ;
		switch (Chose)
  800129:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  80012d:	83 f8 62             	cmp    $0x62,%eax
  800130:	74 1d                	je     80014f <_main+0x117>
  800132:	83 f8 63             	cmp    $0x63,%eax
  800135:	74 2b                	je     800162 <_main+0x12a>
  800137:	83 f8 61             	cmp    $0x61,%eax
  80013a:	75 39                	jne    800175 <_main+0x13d>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  80013c:	83 ec 08             	sub    $0x8,%esp
  80013f:	ff 75 ec             	pushl  -0x14(%ebp)
  800142:	ff 75 e8             	pushl  -0x18(%ebp)
  800145:	e8 c8 02 00 00       	call   800412 <InitializeAscending>
  80014a:	83 c4 10             	add    $0x10,%esp
			break ;
  80014d:	eb 37                	jmp    800186 <_main+0x14e>
		case 'b':
			InitializeIdentical(Elements, NumOfElements);
  80014f:	83 ec 08             	sub    $0x8,%esp
  800152:	ff 75 ec             	pushl  -0x14(%ebp)
  800155:	ff 75 e8             	pushl  -0x18(%ebp)
  800158:	e8 e6 02 00 00       	call   800443 <InitializeIdentical>
  80015d:	83 c4 10             	add    $0x10,%esp
			break ;
  800160:	eb 24                	jmp    800186 <_main+0x14e>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  800162:	83 ec 08             	sub    $0x8,%esp
  800165:	ff 75 ec             	pushl  -0x14(%ebp)
  800168:	ff 75 e8             	pushl  -0x18(%ebp)
  80016b:	e8 08 03 00 00       	call   800478 <InitializeSemiRandom>
  800170:	83 c4 10             	add    $0x10,%esp
			break ;
  800173:	eb 11                	jmp    800186 <_main+0x14e>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  800175:	83 ec 08             	sub    $0x8,%esp
  800178:	ff 75 ec             	pushl  -0x14(%ebp)
  80017b:	ff 75 e8             	pushl  -0x18(%ebp)
  80017e:	e8 f5 02 00 00       	call   800478 <InitializeSemiRandom>
  800183:	83 c4 10             	add    $0x10,%esp
		}

		QuickSort(Elements, NumOfElements);
  800186:	83 ec 08             	sub    $0x8,%esp
  800189:	ff 75 ec             	pushl  -0x14(%ebp)
  80018c:	ff 75 e8             	pushl  -0x18(%ebp)
  80018f:	e8 c3 00 00 00       	call   800257 <QuickSort>
  800194:	83 c4 10             	add    $0x10,%esp

		//		PrintElements(Elements, NumOfElements);

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  800197:	83 ec 08             	sub    $0x8,%esp
  80019a:	ff 75 ec             	pushl  -0x14(%ebp)
  80019d:	ff 75 e8             	pushl  -0x18(%ebp)
  8001a0:	e8 c3 01 00 00       	call   800368 <CheckSorted>
  8001a5:	83 c4 10             	add    $0x10,%esp
  8001a8:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  8001ab:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8001af:	75 14                	jne    8001c5 <_main+0x18d>
  8001b1:	83 ec 04             	sub    $0x4,%esp
  8001b4:	68 9c 26 80 00       	push   $0x80269c
  8001b9:	6a 45                	push   $0x45
  8001bb:	68 be 26 80 00       	push   $0x8026be
  8001c0:	e8 7e 05 00 00       	call   800743 <_panic>
		else
		{
			cprintf("===============================================\n") ;
  8001c5:	83 ec 0c             	sub    $0xc,%esp
  8001c8:	68 d8 26 80 00       	push   $0x8026d8
  8001cd:	e8 3f 08 00 00       	call   800a11 <cprintf>
  8001d2:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  8001d5:	83 ec 0c             	sub    $0xc,%esp
  8001d8:	68 0c 27 80 00       	push   $0x80270c
  8001dd:	e8 2f 08 00 00       	call   800a11 <cprintf>
  8001e2:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  8001e5:	83 ec 0c             	sub    $0xc,%esp
  8001e8:	68 40 27 80 00       	push   $0x802740
  8001ed:	e8 1f 08 00 00       	call   800a11 <cprintf>
  8001f2:	83 c4 10             	add    $0x10,%esp
		}

		//		cprintf("Free Frames After Calculation = %d\n", sys_calculate_free_frames()) ;

		cprintf("Freeing the Heap...\n\n") ;
  8001f5:	83 ec 0c             	sub    $0xc,%esp
  8001f8:	68 72 27 80 00       	push   $0x802772
  8001fd:	e8 0f 08 00 00       	call   800a11 <cprintf>
  800202:	83 c4 10             	add    $0x10,%esp

		//freeHeap() ;

		///========================================================================
		//sys_lock_cons();
		cprintf("Do you want to repeat (y/n): ") ;
  800205:	83 ec 0c             	sub    $0xc,%esp
  800208:	68 88 27 80 00       	push   $0x802788
  80020d:	e8 ff 07 00 00       	call   800a11 <cprintf>
  800212:	83 c4 10             	add    $0x10,%esp
		Chose = getchar() ;
  800215:	e8 5c 03 00 00       	call   800576 <getchar>
  80021a:	88 45 e7             	mov    %al,-0x19(%ebp)
		cputchar(Chose);
  80021d:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  800221:	83 ec 0c             	sub    $0xc,%esp
  800224:	50                   	push   %eax
  800225:	e8 2d 03 00 00       	call   800557 <cputchar>
  80022a:	83 c4 10             	add    $0x10,%esp
		cputchar('\n');
  80022d:	83 ec 0c             	sub    $0xc,%esp
  800230:	6a 0a                	push   $0xa
  800232:	e8 20 03 00 00       	call   800557 <cputchar>
  800237:	83 c4 10             	add    $0x10,%esp
		cputchar('\n');
  80023a:	83 ec 0c             	sub    $0xc,%esp
  80023d:	6a 0a                	push   $0xa
  80023f:	e8 13 03 00 00       	call   800557 <cputchar>
  800244:	83 c4 10             	add    $0x10,%esp
		//sys_unlock_cons();

	} while (Chose == 'y');
  800247:	80 7d e7 79          	cmpb   $0x79,-0x19(%ebp)
  80024b:	0f 84 f8 fd ff ff    	je     800049 <_main+0x11>

}
  800251:	90                   	nop
  800252:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800255:	c9                   	leave  
  800256:	c3                   	ret    

00800257 <QuickSort>:

///Quick sort
void QuickSort(int *Elements, int NumOfElements)
{
  800257:	55                   	push   %ebp
  800258:	89 e5                	mov    %esp,%ebp
  80025a:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  80025d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800260:	48                   	dec    %eax
  800261:	50                   	push   %eax
  800262:	6a 00                	push   $0x0
  800264:	ff 75 0c             	pushl  0xc(%ebp)
  800267:	ff 75 08             	pushl  0x8(%ebp)
  80026a:	e8 06 00 00 00       	call   800275 <QSort>
  80026f:	83 c4 10             	add    $0x10,%esp
}
  800272:	90                   	nop
  800273:	c9                   	leave  
  800274:	c3                   	ret    

00800275 <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  800275:	55                   	push   %ebp
  800276:	89 e5                	mov    %esp,%ebp
  800278:	83 ec 18             	sub    $0x18,%esp
	if (startIndex >= finalIndex) return;
  80027b:	8b 45 10             	mov    0x10(%ebp),%eax
  80027e:	3b 45 14             	cmp    0x14(%ebp),%eax
  800281:	0f 8d de 00 00 00    	jge    800365 <QSort+0xf0>

	int i = startIndex+1, j = finalIndex;
  800287:	8b 45 10             	mov    0x10(%ebp),%eax
  80028a:	40                   	inc    %eax
  80028b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80028e:	8b 45 14             	mov    0x14(%ebp),%eax
  800291:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  800294:	e9 80 00 00 00       	jmp    800319 <QSort+0xa4>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  800299:	ff 45 f4             	incl   -0xc(%ebp)
  80029c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80029f:	3b 45 14             	cmp    0x14(%ebp),%eax
  8002a2:	7f 2b                	jg     8002cf <QSort+0x5a>
  8002a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8002a7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8002b1:	01 d0                	add    %edx,%eax
  8002b3:	8b 10                	mov    (%eax),%edx
  8002b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002b8:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c2:	01 c8                	add    %ecx,%eax
  8002c4:	8b 00                	mov    (%eax),%eax
  8002c6:	39 c2                	cmp    %eax,%edx
  8002c8:	7d cf                	jge    800299 <QSort+0x24>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  8002ca:	eb 03                	jmp    8002cf <QSort+0x5a>
  8002cc:	ff 4d f0             	decl   -0x10(%ebp)
  8002cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002d2:	3b 45 10             	cmp    0x10(%ebp),%eax
  8002d5:	7e 26                	jle    8002fd <QSort+0x88>
  8002d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8002da:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e4:	01 d0                	add    %edx,%eax
  8002e6:	8b 10                	mov    (%eax),%edx
  8002e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002eb:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f5:	01 c8                	add    %ecx,%eax
  8002f7:	8b 00                	mov    (%eax),%eax
  8002f9:	39 c2                	cmp    %eax,%edx
  8002fb:	7e cf                	jle    8002cc <QSort+0x57>

		if (i <= j)
  8002fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800300:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800303:	7f 14                	jg     800319 <QSort+0xa4>
		{
			Swap(Elements, i, j);
  800305:	83 ec 04             	sub    $0x4,%esp
  800308:	ff 75 f0             	pushl  -0x10(%ebp)
  80030b:	ff 75 f4             	pushl  -0xc(%ebp)
  80030e:	ff 75 08             	pushl  0x8(%ebp)
  800311:	e8 a9 00 00 00       	call   8003bf <Swap>
  800316:	83 c4 10             	add    $0x10,%esp
{
	if (startIndex >= finalIndex) return;

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  800319:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80031c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80031f:	0f 8e 77 ff ff ff    	jle    80029c <QSort+0x27>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  800325:	83 ec 04             	sub    $0x4,%esp
  800328:	ff 75 f0             	pushl  -0x10(%ebp)
  80032b:	ff 75 10             	pushl  0x10(%ebp)
  80032e:	ff 75 08             	pushl  0x8(%ebp)
  800331:	e8 89 00 00 00       	call   8003bf <Swap>
  800336:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  800339:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80033c:	48                   	dec    %eax
  80033d:	50                   	push   %eax
  80033e:	ff 75 10             	pushl  0x10(%ebp)
  800341:	ff 75 0c             	pushl  0xc(%ebp)
  800344:	ff 75 08             	pushl  0x8(%ebp)
  800347:	e8 29 ff ff ff       	call   800275 <QSort>
  80034c:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  80034f:	ff 75 14             	pushl  0x14(%ebp)
  800352:	ff 75 f4             	pushl  -0xc(%ebp)
  800355:	ff 75 0c             	pushl  0xc(%ebp)
  800358:	ff 75 08             	pushl  0x8(%ebp)
  80035b:	e8 15 ff ff ff       	call   800275 <QSort>
  800360:	83 c4 10             	add    $0x10,%esp
  800363:	eb 01                	jmp    800366 <QSort+0xf1>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  800365:	90                   	nop

	Swap( Elements, startIndex, j);

	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);
}
  800366:	c9                   	leave  
  800367:	c3                   	ret    

00800368 <CheckSorted>:

uint32 CheckSorted(int *Elements, int NumOfElements)
{
  800368:	55                   	push   %ebp
  800369:	89 e5                	mov    %esp,%ebp
  80036b:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  80036e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800375:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80037c:	eb 33                	jmp    8003b1 <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  80037e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800381:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800388:	8b 45 08             	mov    0x8(%ebp),%eax
  80038b:	01 d0                	add    %edx,%eax
  80038d:	8b 10                	mov    (%eax),%edx
  80038f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800392:	40                   	inc    %eax
  800393:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80039a:	8b 45 08             	mov    0x8(%ebp),%eax
  80039d:	01 c8                	add    %ecx,%eax
  80039f:	8b 00                	mov    (%eax),%eax
  8003a1:	39 c2                	cmp    %eax,%edx
  8003a3:	7e 09                	jle    8003ae <CheckSorted+0x46>
		{
			Sorted = 0 ;
  8003a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  8003ac:	eb 0c                	jmp    8003ba <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8003ae:	ff 45 f8             	incl   -0x8(%ebp)
  8003b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003b4:	48                   	dec    %eax
  8003b5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8003b8:	7f c4                	jg     80037e <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  8003ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8003bd:	c9                   	leave  
  8003be:	c3                   	ret    

008003bf <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  8003bf:	55                   	push   %ebp
  8003c0:	89 e5                	mov    %esp,%ebp
  8003c2:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  8003c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003c8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d2:	01 d0                	add    %edx,%eax
  8003d4:	8b 00                	mov    (%eax),%eax
  8003d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  8003d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003dc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e6:	01 c2                	add    %eax,%edx
  8003e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8003eb:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f5:	01 c8                	add    %ecx,%eax
  8003f7:	8b 00                	mov    (%eax),%eax
  8003f9:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  8003fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8003fe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800405:	8b 45 08             	mov    0x8(%ebp),%eax
  800408:	01 c2                	add    %eax,%edx
  80040a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80040d:	89 02                	mov    %eax,(%edx)
}
  80040f:	90                   	nop
  800410:	c9                   	leave  
  800411:	c3                   	ret    

00800412 <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  800412:	55                   	push   %ebp
  800413:	89 e5                	mov    %esp,%ebp
  800415:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800418:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80041f:	eb 17                	jmp    800438 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  800421:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800424:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80042b:	8b 45 08             	mov    0x8(%ebp),%eax
  80042e:	01 c2                	add    %eax,%edx
  800430:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800433:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800435:	ff 45 fc             	incl   -0x4(%ebp)
  800438:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80043b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80043e:	7c e1                	jl     800421 <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  800440:	90                   	nop
  800441:	c9                   	leave  
  800442:	c3                   	ret    

00800443 <InitializeIdentical>:

void InitializeIdentical(int *Elements, int NumOfElements)
{
  800443:	55                   	push   %ebp
  800444:	89 e5                	mov    %esp,%ebp
  800446:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800449:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800450:	eb 1b                	jmp    80046d <InitializeIdentical+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  800452:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800455:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80045c:	8b 45 08             	mov    0x8(%ebp),%eax
  80045f:	01 c2                	add    %eax,%edx
  800461:	8b 45 0c             	mov    0xc(%ebp),%eax
  800464:	2b 45 fc             	sub    -0x4(%ebp),%eax
  800467:	48                   	dec    %eax
  800468:	89 02                	mov    %eax,(%edx)
}

void InitializeIdentical(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80046a:	ff 45 fc             	incl   -0x4(%ebp)
  80046d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800470:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800473:	7c dd                	jl     800452 <InitializeIdentical+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  800475:	90                   	nop
  800476:	c9                   	leave  
  800477:	c3                   	ret    

00800478 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  800478:	55                   	push   %ebp
  800479:	89 e5                	mov    %esp,%ebp
  80047b:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  80047e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800481:	b8 56 55 55 55       	mov    $0x55555556,%eax
  800486:	f7 e9                	imul   %ecx
  800488:	c1 f9 1f             	sar    $0x1f,%ecx
  80048b:	89 d0                	mov    %edx,%eax
  80048d:	29 c8                	sub    %ecx,%eax
  80048f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (Repetition == 0)
  800492:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800496:	75 07                	jne    80049f <InitializeSemiRandom+0x27>
			Repetition = 3;
  800498:	c7 45 f8 03 00 00 00 	movl   $0x3,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  80049f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8004a6:	eb 1e                	jmp    8004c6 <InitializeSemiRandom+0x4e>
	{
		Elements[i] = i % Repetition ;
  8004a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004ab:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b5:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8004b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004bb:	99                   	cltd   
  8004bc:	f7 7d f8             	idivl  -0x8(%ebp)
  8004bf:	89 d0                	mov    %edx,%eax
  8004c1:	89 01                	mov    %eax,(%ecx)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	if (Repetition == 0)
			Repetition = 3;
	for (i = 0 ; i < NumOfElements ; i++)
  8004c3:	ff 45 fc             	incl   -0x4(%ebp)
  8004c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004c9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004cc:	7c da                	jl     8004a8 <InitializeSemiRandom+0x30>
	{
		Elements[i] = i % Repetition ;
	}

}
  8004ce:	90                   	nop
  8004cf:	c9                   	leave  
  8004d0:	c3                   	ret    

008004d1 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  8004d1:	55                   	push   %ebp
  8004d2:	89 e5                	mov    %esp,%ebp
  8004d4:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  8004d7:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  8004de:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8004e5:	eb 42                	jmp    800529 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  8004e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004ea:	99                   	cltd   
  8004eb:	f7 7d f0             	idivl  -0x10(%ebp)
  8004ee:	89 d0                	mov    %edx,%eax
  8004f0:	85 c0                	test   %eax,%eax
  8004f2:	75 10                	jne    800504 <PrintElements+0x33>
			cprintf("\n");
  8004f4:	83 ec 0c             	sub    $0xc,%esp
  8004f7:	68 a6 27 80 00       	push   $0x8027a6
  8004fc:	e8 10 05 00 00       	call   800a11 <cprintf>
  800501:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800504:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800507:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80050e:	8b 45 08             	mov    0x8(%ebp),%eax
  800511:	01 d0                	add    %edx,%eax
  800513:	8b 00                	mov    (%eax),%eax
  800515:	83 ec 08             	sub    $0x8,%esp
  800518:	50                   	push   %eax
  800519:	68 a8 27 80 00       	push   $0x8027a8
  80051e:	e8 ee 04 00 00       	call   800a11 <cprintf>
  800523:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800526:	ff 45 f4             	incl   -0xc(%ebp)
  800529:	8b 45 0c             	mov    0xc(%ebp),%eax
  80052c:	48                   	dec    %eax
  80052d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800530:	7f b5                	jg     8004e7 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  800532:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800535:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80053c:	8b 45 08             	mov    0x8(%ebp),%eax
  80053f:	01 d0                	add    %edx,%eax
  800541:	8b 00                	mov    (%eax),%eax
  800543:	83 ec 08             	sub    $0x8,%esp
  800546:	50                   	push   %eax
  800547:	68 ad 27 80 00       	push   $0x8027ad
  80054c:	e8 c0 04 00 00       	call   800a11 <cprintf>
  800551:	83 c4 10             	add    $0x10,%esp
}
  800554:	90                   	nop
  800555:	c9                   	leave  
  800556:	c3                   	ret    

00800557 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  800557:	55                   	push   %ebp
  800558:	89 e5                	mov    %esp,%ebp
  80055a:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  80055d:	8b 45 08             	mov    0x8(%ebp),%eax
  800560:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800563:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800567:	83 ec 0c             	sub    $0xc,%esp
  80056a:	50                   	push   %eax
  80056b:	e8 fc 18 00 00       	call   801e6c <sys_cputc>
  800570:	83 c4 10             	add    $0x10,%esp
}
  800573:	90                   	nop
  800574:	c9                   	leave  
  800575:	c3                   	ret    

00800576 <getchar>:


int
getchar(void)
{
  800576:	55                   	push   %ebp
  800577:	89 e5                	mov    %esp,%ebp
  800579:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  80057c:	e8 8a 17 00 00       	call   801d0b <sys_cgetc>
  800581:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  800584:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800587:	c9                   	leave  
  800588:	c3                   	ret    

00800589 <iscons>:

int iscons(int fdnum)
{
  800589:	55                   	push   %ebp
  80058a:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  80058c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800591:	5d                   	pop    %ebp
  800592:	c3                   	ret    

00800593 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800593:	55                   	push   %ebp
  800594:	89 e5                	mov    %esp,%ebp
  800596:	57                   	push   %edi
  800597:	56                   	push   %esi
  800598:	53                   	push   %ebx
  800599:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80059c:	e8 fc 19 00 00       	call   801f9d <sys_getenvindex>
  8005a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8005a4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8005a7:	89 d0                	mov    %edx,%eax
  8005a9:	c1 e0 02             	shl    $0x2,%eax
  8005ac:	01 d0                	add    %edx,%eax
  8005ae:	c1 e0 03             	shl    $0x3,%eax
  8005b1:	01 d0                	add    %edx,%eax
  8005b3:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8005ba:	01 d0                	add    %edx,%eax
  8005bc:	c1 e0 02             	shl    $0x2,%eax
  8005bf:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8005c4:	a3 24 40 80 00       	mov    %eax,0x804024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8005c9:	a1 24 40 80 00       	mov    0x804024,%eax
  8005ce:	8a 40 20             	mov    0x20(%eax),%al
  8005d1:	84 c0                	test   %al,%al
  8005d3:	74 0d                	je     8005e2 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8005d5:	a1 24 40 80 00       	mov    0x804024,%eax
  8005da:	83 c0 20             	add    $0x20,%eax
  8005dd:	a3 04 40 80 00       	mov    %eax,0x804004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8005e2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8005e6:	7e 0a                	jle    8005f2 <libmain+0x5f>
		binaryname = argv[0];
  8005e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005eb:	8b 00                	mov    (%eax),%eax
  8005ed:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	_main(argc, argv);
  8005f2:	83 ec 08             	sub    $0x8,%esp
  8005f5:	ff 75 0c             	pushl  0xc(%ebp)
  8005f8:	ff 75 08             	pushl  0x8(%ebp)
  8005fb:	e8 38 fa ff ff       	call   800038 <_main>
  800600:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800603:	a1 00 40 80 00       	mov    0x804000,%eax
  800608:	85 c0                	test   %eax,%eax
  80060a:	0f 84 01 01 00 00    	je     800711 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800610:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800616:	bb ac 28 80 00       	mov    $0x8028ac,%ebx
  80061b:	ba 0e 00 00 00       	mov    $0xe,%edx
  800620:	89 c7                	mov    %eax,%edi
  800622:	89 de                	mov    %ebx,%esi
  800624:	89 d1                	mov    %edx,%ecx
  800626:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800628:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80062b:	b9 56 00 00 00       	mov    $0x56,%ecx
  800630:	b0 00                	mov    $0x0,%al
  800632:	89 d7                	mov    %edx,%edi
  800634:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800636:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80063d:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800640:	83 ec 08             	sub    $0x8,%esp
  800643:	50                   	push   %eax
  800644:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80064a:	50                   	push   %eax
  80064b:	e8 83 1b 00 00       	call   8021d3 <sys_utilities>
  800650:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800653:	e8 cc 16 00 00       	call   801d24 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800658:	83 ec 0c             	sub    $0xc,%esp
  80065b:	68 cc 27 80 00       	push   $0x8027cc
  800660:	e8 ac 03 00 00       	call   800a11 <cprintf>
  800665:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800668:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80066b:	85 c0                	test   %eax,%eax
  80066d:	74 18                	je     800687 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80066f:	e8 7d 1b 00 00       	call   8021f1 <sys_get_optimal_num_faults>
  800674:	83 ec 08             	sub    $0x8,%esp
  800677:	50                   	push   %eax
  800678:	68 f4 27 80 00       	push   $0x8027f4
  80067d:	e8 8f 03 00 00       	call   800a11 <cprintf>
  800682:	83 c4 10             	add    $0x10,%esp
  800685:	eb 59                	jmp    8006e0 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800687:	a1 24 40 80 00       	mov    0x804024,%eax
  80068c:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  800692:	a1 24 40 80 00       	mov    0x804024,%eax
  800697:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  80069d:	83 ec 04             	sub    $0x4,%esp
  8006a0:	52                   	push   %edx
  8006a1:	50                   	push   %eax
  8006a2:	68 18 28 80 00       	push   $0x802818
  8006a7:	e8 65 03 00 00       	call   800a11 <cprintf>
  8006ac:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8006af:	a1 24 40 80 00       	mov    0x804024,%eax
  8006b4:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8006ba:	a1 24 40 80 00       	mov    0x804024,%eax
  8006bf:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  8006c5:	a1 24 40 80 00       	mov    0x804024,%eax
  8006ca:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  8006d0:	51                   	push   %ecx
  8006d1:	52                   	push   %edx
  8006d2:	50                   	push   %eax
  8006d3:	68 40 28 80 00       	push   $0x802840
  8006d8:	e8 34 03 00 00       	call   800a11 <cprintf>
  8006dd:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8006e0:	a1 24 40 80 00       	mov    0x804024,%eax
  8006e5:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  8006eb:	83 ec 08             	sub    $0x8,%esp
  8006ee:	50                   	push   %eax
  8006ef:	68 98 28 80 00       	push   $0x802898
  8006f4:	e8 18 03 00 00       	call   800a11 <cprintf>
  8006f9:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8006fc:	83 ec 0c             	sub    $0xc,%esp
  8006ff:	68 cc 27 80 00       	push   $0x8027cc
  800704:	e8 08 03 00 00       	call   800a11 <cprintf>
  800709:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80070c:	e8 2d 16 00 00       	call   801d3e <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800711:	e8 1f 00 00 00       	call   800735 <exit>
}
  800716:	90                   	nop
  800717:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80071a:	5b                   	pop    %ebx
  80071b:	5e                   	pop    %esi
  80071c:	5f                   	pop    %edi
  80071d:	5d                   	pop    %ebp
  80071e:	c3                   	ret    

0080071f <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80071f:	55                   	push   %ebp
  800720:	89 e5                	mov    %esp,%ebp
  800722:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800725:	83 ec 0c             	sub    $0xc,%esp
  800728:	6a 00                	push   $0x0
  80072a:	e8 3a 18 00 00       	call   801f69 <sys_destroy_env>
  80072f:	83 c4 10             	add    $0x10,%esp
}
  800732:	90                   	nop
  800733:	c9                   	leave  
  800734:	c3                   	ret    

00800735 <exit>:

void
exit(void)
{
  800735:	55                   	push   %ebp
  800736:	89 e5                	mov    %esp,%ebp
  800738:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80073b:	e8 8f 18 00 00       	call   801fcf <sys_exit_env>
}
  800740:	90                   	nop
  800741:	c9                   	leave  
  800742:	c3                   	ret    

00800743 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800743:	55                   	push   %ebp
  800744:	89 e5                	mov    %esp,%ebp
  800746:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800749:	8d 45 10             	lea    0x10(%ebp),%eax
  80074c:	83 c0 04             	add    $0x4,%eax
  80074f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800752:	a1 18 c1 81 00       	mov    0x81c118,%eax
  800757:	85 c0                	test   %eax,%eax
  800759:	74 16                	je     800771 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80075b:	a1 18 c1 81 00       	mov    0x81c118,%eax
  800760:	83 ec 08             	sub    $0x8,%esp
  800763:	50                   	push   %eax
  800764:	68 10 29 80 00       	push   $0x802910
  800769:	e8 a3 02 00 00       	call   800a11 <cprintf>
  80076e:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800771:	a1 04 40 80 00       	mov    0x804004,%eax
  800776:	83 ec 0c             	sub    $0xc,%esp
  800779:	ff 75 0c             	pushl  0xc(%ebp)
  80077c:	ff 75 08             	pushl  0x8(%ebp)
  80077f:	50                   	push   %eax
  800780:	68 18 29 80 00       	push   $0x802918
  800785:	6a 74                	push   $0x74
  800787:	e8 b2 02 00 00       	call   800a3e <cprintf_colored>
  80078c:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  80078f:	8b 45 10             	mov    0x10(%ebp),%eax
  800792:	83 ec 08             	sub    $0x8,%esp
  800795:	ff 75 f4             	pushl  -0xc(%ebp)
  800798:	50                   	push   %eax
  800799:	e8 04 02 00 00       	call   8009a2 <vcprintf>
  80079e:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8007a1:	83 ec 08             	sub    $0x8,%esp
  8007a4:	6a 00                	push   $0x0
  8007a6:	68 40 29 80 00       	push   $0x802940
  8007ab:	e8 f2 01 00 00       	call   8009a2 <vcprintf>
  8007b0:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8007b3:	e8 7d ff ff ff       	call   800735 <exit>

	// should not return here
	while (1) ;
  8007b8:	eb fe                	jmp    8007b8 <_panic+0x75>

008007ba <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8007ba:	55                   	push   %ebp
  8007bb:	89 e5                	mov    %esp,%ebp
  8007bd:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8007c0:	a1 24 40 80 00       	mov    0x804024,%eax
  8007c5:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8007cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007ce:	39 c2                	cmp    %eax,%edx
  8007d0:	74 14                	je     8007e6 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8007d2:	83 ec 04             	sub    $0x4,%esp
  8007d5:	68 44 29 80 00       	push   $0x802944
  8007da:	6a 26                	push   $0x26
  8007dc:	68 90 29 80 00       	push   $0x802990
  8007e1:	e8 5d ff ff ff       	call   800743 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8007e6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8007ed:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8007f4:	e9 c5 00 00 00       	jmp    8008be <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8007f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007fc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800803:	8b 45 08             	mov    0x8(%ebp),%eax
  800806:	01 d0                	add    %edx,%eax
  800808:	8b 00                	mov    (%eax),%eax
  80080a:	85 c0                	test   %eax,%eax
  80080c:	75 08                	jne    800816 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80080e:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800811:	e9 a5 00 00 00       	jmp    8008bb <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800816:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80081d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800824:	eb 69                	jmp    80088f <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800826:	a1 24 40 80 00       	mov    0x804024,%eax
  80082b:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800831:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800834:	89 d0                	mov    %edx,%eax
  800836:	01 c0                	add    %eax,%eax
  800838:	01 d0                	add    %edx,%eax
  80083a:	c1 e0 03             	shl    $0x3,%eax
  80083d:	01 c8                	add    %ecx,%eax
  80083f:	8a 40 04             	mov    0x4(%eax),%al
  800842:	84 c0                	test   %al,%al
  800844:	75 46                	jne    80088c <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800846:	a1 24 40 80 00       	mov    0x804024,%eax
  80084b:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800851:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800854:	89 d0                	mov    %edx,%eax
  800856:	01 c0                	add    %eax,%eax
  800858:	01 d0                	add    %edx,%eax
  80085a:	c1 e0 03             	shl    $0x3,%eax
  80085d:	01 c8                	add    %ecx,%eax
  80085f:	8b 00                	mov    (%eax),%eax
  800861:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800864:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800867:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80086c:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80086e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800871:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800878:	8b 45 08             	mov    0x8(%ebp),%eax
  80087b:	01 c8                	add    %ecx,%eax
  80087d:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80087f:	39 c2                	cmp    %eax,%edx
  800881:	75 09                	jne    80088c <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800883:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80088a:	eb 15                	jmp    8008a1 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80088c:	ff 45 e8             	incl   -0x18(%ebp)
  80088f:	a1 24 40 80 00       	mov    0x804024,%eax
  800894:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80089a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80089d:	39 c2                	cmp    %eax,%edx
  80089f:	77 85                	ja     800826 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8008a1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8008a5:	75 14                	jne    8008bb <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8008a7:	83 ec 04             	sub    $0x4,%esp
  8008aa:	68 9c 29 80 00       	push   $0x80299c
  8008af:	6a 3a                	push   $0x3a
  8008b1:	68 90 29 80 00       	push   $0x802990
  8008b6:	e8 88 fe ff ff       	call   800743 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8008bb:	ff 45 f0             	incl   -0x10(%ebp)
  8008be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008c1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8008c4:	0f 8c 2f ff ff ff    	jl     8007f9 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8008ca:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008d1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8008d8:	eb 26                	jmp    800900 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8008da:	a1 24 40 80 00       	mov    0x804024,%eax
  8008df:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8008e5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008e8:	89 d0                	mov    %edx,%eax
  8008ea:	01 c0                	add    %eax,%eax
  8008ec:	01 d0                	add    %edx,%eax
  8008ee:	c1 e0 03             	shl    $0x3,%eax
  8008f1:	01 c8                	add    %ecx,%eax
  8008f3:	8a 40 04             	mov    0x4(%eax),%al
  8008f6:	3c 01                	cmp    $0x1,%al
  8008f8:	75 03                	jne    8008fd <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8008fa:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008fd:	ff 45 e0             	incl   -0x20(%ebp)
  800900:	a1 24 40 80 00       	mov    0x804024,%eax
  800905:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80090b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80090e:	39 c2                	cmp    %eax,%edx
  800910:	77 c8                	ja     8008da <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800912:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800915:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800918:	74 14                	je     80092e <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80091a:	83 ec 04             	sub    $0x4,%esp
  80091d:	68 f0 29 80 00       	push   $0x8029f0
  800922:	6a 44                	push   $0x44
  800924:	68 90 29 80 00       	push   $0x802990
  800929:	e8 15 fe ff ff       	call   800743 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80092e:	90                   	nop
  80092f:	c9                   	leave  
  800930:	c3                   	ret    

00800931 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800931:	55                   	push   %ebp
  800932:	89 e5                	mov    %esp,%ebp
  800934:	53                   	push   %ebx
  800935:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800938:	8b 45 0c             	mov    0xc(%ebp),%eax
  80093b:	8b 00                	mov    (%eax),%eax
  80093d:	8d 48 01             	lea    0x1(%eax),%ecx
  800940:	8b 55 0c             	mov    0xc(%ebp),%edx
  800943:	89 0a                	mov    %ecx,(%edx)
  800945:	8b 55 08             	mov    0x8(%ebp),%edx
  800948:	88 d1                	mov    %dl,%cl
  80094a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80094d:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800951:	8b 45 0c             	mov    0xc(%ebp),%eax
  800954:	8b 00                	mov    (%eax),%eax
  800956:	3d ff 00 00 00       	cmp    $0xff,%eax
  80095b:	75 30                	jne    80098d <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  80095d:	8b 15 1c c1 81 00    	mov    0x81c11c,%edx
  800963:	a0 44 40 80 00       	mov    0x804044,%al
  800968:	0f b6 c0             	movzbl %al,%eax
  80096b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80096e:	8b 09                	mov    (%ecx),%ecx
  800970:	89 cb                	mov    %ecx,%ebx
  800972:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800975:	83 c1 08             	add    $0x8,%ecx
  800978:	52                   	push   %edx
  800979:	50                   	push   %eax
  80097a:	53                   	push   %ebx
  80097b:	51                   	push   %ecx
  80097c:	e8 5f 13 00 00       	call   801ce0 <sys_cputs>
  800981:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800984:	8b 45 0c             	mov    0xc(%ebp),%eax
  800987:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80098d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800990:	8b 40 04             	mov    0x4(%eax),%eax
  800993:	8d 50 01             	lea    0x1(%eax),%edx
  800996:	8b 45 0c             	mov    0xc(%ebp),%eax
  800999:	89 50 04             	mov    %edx,0x4(%eax)
}
  80099c:	90                   	nop
  80099d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009a0:	c9                   	leave  
  8009a1:	c3                   	ret    

008009a2 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8009a2:	55                   	push   %ebp
  8009a3:	89 e5                	mov    %esp,%ebp
  8009a5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8009ab:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8009b2:	00 00 00 
	b.cnt = 0;
  8009b5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8009bc:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8009bf:	ff 75 0c             	pushl  0xc(%ebp)
  8009c2:	ff 75 08             	pushl  0x8(%ebp)
  8009c5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009cb:	50                   	push   %eax
  8009cc:	68 31 09 80 00       	push   $0x800931
  8009d1:	e8 5a 02 00 00       	call   800c30 <vprintfmt>
  8009d6:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8009d9:	8b 15 1c c1 81 00    	mov    0x81c11c,%edx
  8009df:	a0 44 40 80 00       	mov    0x804044,%al
  8009e4:	0f b6 c0             	movzbl %al,%eax
  8009e7:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8009ed:	52                   	push   %edx
  8009ee:	50                   	push   %eax
  8009ef:	51                   	push   %ecx
  8009f0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009f6:	83 c0 08             	add    $0x8,%eax
  8009f9:	50                   	push   %eax
  8009fa:	e8 e1 12 00 00       	call   801ce0 <sys_cputs>
  8009ff:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800a02:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
	return b.cnt;
  800a09:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a0f:	c9                   	leave  
  800a10:	c3                   	ret    

00800a11 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800a11:	55                   	push   %ebp
  800a12:	89 e5                	mov    %esp,%ebp
  800a14:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a17:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	va_start(ap, fmt);
  800a1e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a21:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a24:	8b 45 08             	mov    0x8(%ebp),%eax
  800a27:	83 ec 08             	sub    $0x8,%esp
  800a2a:	ff 75 f4             	pushl  -0xc(%ebp)
  800a2d:	50                   	push   %eax
  800a2e:	e8 6f ff ff ff       	call   8009a2 <vcprintf>
  800a33:	83 c4 10             	add    $0x10,%esp
  800a36:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a39:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a3c:	c9                   	leave  
  800a3d:	c3                   	ret    

00800a3e <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800a3e:	55                   	push   %ebp
  800a3f:	89 e5                	mov    %esp,%ebp
  800a41:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a44:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4e:	c1 e0 08             	shl    $0x8,%eax
  800a51:	a3 1c c1 81 00       	mov    %eax,0x81c11c
	va_start(ap, fmt);
  800a56:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a59:	83 c0 04             	add    $0x4,%eax
  800a5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a62:	83 ec 08             	sub    $0x8,%esp
  800a65:	ff 75 f4             	pushl  -0xc(%ebp)
  800a68:	50                   	push   %eax
  800a69:	e8 34 ff ff ff       	call   8009a2 <vcprintf>
  800a6e:	83 c4 10             	add    $0x10,%esp
  800a71:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800a74:	c7 05 1c c1 81 00 00 	movl   $0x700,0x81c11c
  800a7b:	07 00 00 

	return cnt;
  800a7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a81:	c9                   	leave  
  800a82:	c3                   	ret    

00800a83 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800a83:	55                   	push   %ebp
  800a84:	89 e5                	mov    %esp,%ebp
  800a86:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800a89:	e8 96 12 00 00       	call   801d24 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800a8e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a91:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800a94:	8b 45 08             	mov    0x8(%ebp),%eax
  800a97:	83 ec 08             	sub    $0x8,%esp
  800a9a:	ff 75 f4             	pushl  -0xc(%ebp)
  800a9d:	50                   	push   %eax
  800a9e:	e8 ff fe ff ff       	call   8009a2 <vcprintf>
  800aa3:	83 c4 10             	add    $0x10,%esp
  800aa6:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800aa9:	e8 90 12 00 00       	call   801d3e <sys_unlock_cons>
	return cnt;
  800aae:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ab1:	c9                   	leave  
  800ab2:	c3                   	ret    

00800ab3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800ab3:	55                   	push   %ebp
  800ab4:	89 e5                	mov    %esp,%ebp
  800ab6:	53                   	push   %ebx
  800ab7:	83 ec 14             	sub    $0x14,%esp
  800aba:	8b 45 10             	mov    0x10(%ebp),%eax
  800abd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ac0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800ac6:	8b 45 18             	mov    0x18(%ebp),%eax
  800ac9:	ba 00 00 00 00       	mov    $0x0,%edx
  800ace:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800ad1:	77 55                	ja     800b28 <printnum+0x75>
  800ad3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800ad6:	72 05                	jb     800add <printnum+0x2a>
  800ad8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800adb:	77 4b                	ja     800b28 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800add:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800ae0:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800ae3:	8b 45 18             	mov    0x18(%ebp),%eax
  800ae6:	ba 00 00 00 00       	mov    $0x0,%edx
  800aeb:	52                   	push   %edx
  800aec:	50                   	push   %eax
  800aed:	ff 75 f4             	pushl  -0xc(%ebp)
  800af0:	ff 75 f0             	pushl  -0x10(%ebp)
  800af3:	e8 b0 18 00 00       	call   8023a8 <__udivdi3>
  800af8:	83 c4 10             	add    $0x10,%esp
  800afb:	83 ec 04             	sub    $0x4,%esp
  800afe:	ff 75 20             	pushl  0x20(%ebp)
  800b01:	53                   	push   %ebx
  800b02:	ff 75 18             	pushl  0x18(%ebp)
  800b05:	52                   	push   %edx
  800b06:	50                   	push   %eax
  800b07:	ff 75 0c             	pushl  0xc(%ebp)
  800b0a:	ff 75 08             	pushl  0x8(%ebp)
  800b0d:	e8 a1 ff ff ff       	call   800ab3 <printnum>
  800b12:	83 c4 20             	add    $0x20,%esp
  800b15:	eb 1a                	jmp    800b31 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800b17:	83 ec 08             	sub    $0x8,%esp
  800b1a:	ff 75 0c             	pushl  0xc(%ebp)
  800b1d:	ff 75 20             	pushl  0x20(%ebp)
  800b20:	8b 45 08             	mov    0x8(%ebp),%eax
  800b23:	ff d0                	call   *%eax
  800b25:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800b28:	ff 4d 1c             	decl   0x1c(%ebp)
  800b2b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800b2f:	7f e6                	jg     800b17 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800b31:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800b34:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b3c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b3f:	53                   	push   %ebx
  800b40:	51                   	push   %ecx
  800b41:	52                   	push   %edx
  800b42:	50                   	push   %eax
  800b43:	e8 70 19 00 00       	call   8024b8 <__umoddi3>
  800b48:	83 c4 10             	add    $0x10,%esp
  800b4b:	05 54 2c 80 00       	add    $0x802c54,%eax
  800b50:	8a 00                	mov    (%eax),%al
  800b52:	0f be c0             	movsbl %al,%eax
  800b55:	83 ec 08             	sub    $0x8,%esp
  800b58:	ff 75 0c             	pushl  0xc(%ebp)
  800b5b:	50                   	push   %eax
  800b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5f:	ff d0                	call   *%eax
  800b61:	83 c4 10             	add    $0x10,%esp
}
  800b64:	90                   	nop
  800b65:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b68:	c9                   	leave  
  800b69:	c3                   	ret    

00800b6a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b6a:	55                   	push   %ebp
  800b6b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b6d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b71:	7e 1c                	jle    800b8f <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800b73:	8b 45 08             	mov    0x8(%ebp),%eax
  800b76:	8b 00                	mov    (%eax),%eax
  800b78:	8d 50 08             	lea    0x8(%eax),%edx
  800b7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7e:	89 10                	mov    %edx,(%eax)
  800b80:	8b 45 08             	mov    0x8(%ebp),%eax
  800b83:	8b 00                	mov    (%eax),%eax
  800b85:	83 e8 08             	sub    $0x8,%eax
  800b88:	8b 50 04             	mov    0x4(%eax),%edx
  800b8b:	8b 00                	mov    (%eax),%eax
  800b8d:	eb 40                	jmp    800bcf <getuint+0x65>
	else if (lflag)
  800b8f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b93:	74 1e                	je     800bb3 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800b95:	8b 45 08             	mov    0x8(%ebp),%eax
  800b98:	8b 00                	mov    (%eax),%eax
  800b9a:	8d 50 04             	lea    0x4(%eax),%edx
  800b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba0:	89 10                	mov    %edx,(%eax)
  800ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba5:	8b 00                	mov    (%eax),%eax
  800ba7:	83 e8 04             	sub    $0x4,%eax
  800baa:	8b 00                	mov    (%eax),%eax
  800bac:	ba 00 00 00 00       	mov    $0x0,%edx
  800bb1:	eb 1c                	jmp    800bcf <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb6:	8b 00                	mov    (%eax),%eax
  800bb8:	8d 50 04             	lea    0x4(%eax),%edx
  800bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbe:	89 10                	mov    %edx,(%eax)
  800bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc3:	8b 00                	mov    (%eax),%eax
  800bc5:	83 e8 04             	sub    $0x4,%eax
  800bc8:	8b 00                	mov    (%eax),%eax
  800bca:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800bcf:	5d                   	pop    %ebp
  800bd0:	c3                   	ret    

00800bd1 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800bd1:	55                   	push   %ebp
  800bd2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800bd4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800bd8:	7e 1c                	jle    800bf6 <getint+0x25>
		return va_arg(*ap, long long);
  800bda:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdd:	8b 00                	mov    (%eax),%eax
  800bdf:	8d 50 08             	lea    0x8(%eax),%edx
  800be2:	8b 45 08             	mov    0x8(%ebp),%eax
  800be5:	89 10                	mov    %edx,(%eax)
  800be7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bea:	8b 00                	mov    (%eax),%eax
  800bec:	83 e8 08             	sub    $0x8,%eax
  800bef:	8b 50 04             	mov    0x4(%eax),%edx
  800bf2:	8b 00                	mov    (%eax),%eax
  800bf4:	eb 38                	jmp    800c2e <getint+0x5d>
	else if (lflag)
  800bf6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bfa:	74 1a                	je     800c16 <getint+0x45>
		return va_arg(*ap, long);
  800bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bff:	8b 00                	mov    (%eax),%eax
  800c01:	8d 50 04             	lea    0x4(%eax),%edx
  800c04:	8b 45 08             	mov    0x8(%ebp),%eax
  800c07:	89 10                	mov    %edx,(%eax)
  800c09:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0c:	8b 00                	mov    (%eax),%eax
  800c0e:	83 e8 04             	sub    $0x4,%eax
  800c11:	8b 00                	mov    (%eax),%eax
  800c13:	99                   	cltd   
  800c14:	eb 18                	jmp    800c2e <getint+0x5d>
	else
		return va_arg(*ap, int);
  800c16:	8b 45 08             	mov    0x8(%ebp),%eax
  800c19:	8b 00                	mov    (%eax),%eax
  800c1b:	8d 50 04             	lea    0x4(%eax),%edx
  800c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c21:	89 10                	mov    %edx,(%eax)
  800c23:	8b 45 08             	mov    0x8(%ebp),%eax
  800c26:	8b 00                	mov    (%eax),%eax
  800c28:	83 e8 04             	sub    $0x4,%eax
  800c2b:	8b 00                	mov    (%eax),%eax
  800c2d:	99                   	cltd   
}
  800c2e:	5d                   	pop    %ebp
  800c2f:	c3                   	ret    

00800c30 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800c30:	55                   	push   %ebp
  800c31:	89 e5                	mov    %esp,%ebp
  800c33:	56                   	push   %esi
  800c34:	53                   	push   %ebx
  800c35:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c38:	eb 17                	jmp    800c51 <vprintfmt+0x21>
			if (ch == '\0')
  800c3a:	85 db                	test   %ebx,%ebx
  800c3c:	0f 84 c1 03 00 00    	je     801003 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800c42:	83 ec 08             	sub    $0x8,%esp
  800c45:	ff 75 0c             	pushl  0xc(%ebp)
  800c48:	53                   	push   %ebx
  800c49:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4c:	ff d0                	call   *%eax
  800c4e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c51:	8b 45 10             	mov    0x10(%ebp),%eax
  800c54:	8d 50 01             	lea    0x1(%eax),%edx
  800c57:	89 55 10             	mov    %edx,0x10(%ebp)
  800c5a:	8a 00                	mov    (%eax),%al
  800c5c:	0f b6 d8             	movzbl %al,%ebx
  800c5f:	83 fb 25             	cmp    $0x25,%ebx
  800c62:	75 d6                	jne    800c3a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c64:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800c68:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800c6f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800c76:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800c7d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c84:	8b 45 10             	mov    0x10(%ebp),%eax
  800c87:	8d 50 01             	lea    0x1(%eax),%edx
  800c8a:	89 55 10             	mov    %edx,0x10(%ebp)
  800c8d:	8a 00                	mov    (%eax),%al
  800c8f:	0f b6 d8             	movzbl %al,%ebx
  800c92:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800c95:	83 f8 5b             	cmp    $0x5b,%eax
  800c98:	0f 87 3d 03 00 00    	ja     800fdb <vprintfmt+0x3ab>
  800c9e:	8b 04 85 78 2c 80 00 	mov    0x802c78(,%eax,4),%eax
  800ca5:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800ca7:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800cab:	eb d7                	jmp    800c84 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800cad:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800cb1:	eb d1                	jmp    800c84 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cb3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800cba:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800cbd:	89 d0                	mov    %edx,%eax
  800cbf:	c1 e0 02             	shl    $0x2,%eax
  800cc2:	01 d0                	add    %edx,%eax
  800cc4:	01 c0                	add    %eax,%eax
  800cc6:	01 d8                	add    %ebx,%eax
  800cc8:	83 e8 30             	sub    $0x30,%eax
  800ccb:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800cce:	8b 45 10             	mov    0x10(%ebp),%eax
  800cd1:	8a 00                	mov    (%eax),%al
  800cd3:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800cd6:	83 fb 2f             	cmp    $0x2f,%ebx
  800cd9:	7e 3e                	jle    800d19 <vprintfmt+0xe9>
  800cdb:	83 fb 39             	cmp    $0x39,%ebx
  800cde:	7f 39                	jg     800d19 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ce0:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ce3:	eb d5                	jmp    800cba <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800ce5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ce8:	83 c0 04             	add    $0x4,%eax
  800ceb:	89 45 14             	mov    %eax,0x14(%ebp)
  800cee:	8b 45 14             	mov    0x14(%ebp),%eax
  800cf1:	83 e8 04             	sub    $0x4,%eax
  800cf4:	8b 00                	mov    (%eax),%eax
  800cf6:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800cf9:	eb 1f                	jmp    800d1a <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800cfb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cff:	79 83                	jns    800c84 <vprintfmt+0x54>
				width = 0;
  800d01:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800d08:	e9 77 ff ff ff       	jmp    800c84 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800d0d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800d14:	e9 6b ff ff ff       	jmp    800c84 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800d19:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800d1a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d1e:	0f 89 60 ff ff ff    	jns    800c84 <vprintfmt+0x54>
				width = precision, precision = -1;
  800d24:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d27:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d2a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800d31:	e9 4e ff ff ff       	jmp    800c84 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d36:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800d39:	e9 46 ff ff ff       	jmp    800c84 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800d3e:	8b 45 14             	mov    0x14(%ebp),%eax
  800d41:	83 c0 04             	add    $0x4,%eax
  800d44:	89 45 14             	mov    %eax,0x14(%ebp)
  800d47:	8b 45 14             	mov    0x14(%ebp),%eax
  800d4a:	83 e8 04             	sub    $0x4,%eax
  800d4d:	8b 00                	mov    (%eax),%eax
  800d4f:	83 ec 08             	sub    $0x8,%esp
  800d52:	ff 75 0c             	pushl  0xc(%ebp)
  800d55:	50                   	push   %eax
  800d56:	8b 45 08             	mov    0x8(%ebp),%eax
  800d59:	ff d0                	call   *%eax
  800d5b:	83 c4 10             	add    $0x10,%esp
			break;
  800d5e:	e9 9b 02 00 00       	jmp    800ffe <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800d63:	8b 45 14             	mov    0x14(%ebp),%eax
  800d66:	83 c0 04             	add    $0x4,%eax
  800d69:	89 45 14             	mov    %eax,0x14(%ebp)
  800d6c:	8b 45 14             	mov    0x14(%ebp),%eax
  800d6f:	83 e8 04             	sub    $0x4,%eax
  800d72:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800d74:	85 db                	test   %ebx,%ebx
  800d76:	79 02                	jns    800d7a <vprintfmt+0x14a>
				err = -err;
  800d78:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800d7a:	83 fb 64             	cmp    $0x64,%ebx
  800d7d:	7f 0b                	jg     800d8a <vprintfmt+0x15a>
  800d7f:	8b 34 9d c0 2a 80 00 	mov    0x802ac0(,%ebx,4),%esi
  800d86:	85 f6                	test   %esi,%esi
  800d88:	75 19                	jne    800da3 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d8a:	53                   	push   %ebx
  800d8b:	68 65 2c 80 00       	push   $0x802c65
  800d90:	ff 75 0c             	pushl  0xc(%ebp)
  800d93:	ff 75 08             	pushl  0x8(%ebp)
  800d96:	e8 70 02 00 00       	call   80100b <printfmt>
  800d9b:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d9e:	e9 5b 02 00 00       	jmp    800ffe <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800da3:	56                   	push   %esi
  800da4:	68 6e 2c 80 00       	push   $0x802c6e
  800da9:	ff 75 0c             	pushl  0xc(%ebp)
  800dac:	ff 75 08             	pushl  0x8(%ebp)
  800daf:	e8 57 02 00 00       	call   80100b <printfmt>
  800db4:	83 c4 10             	add    $0x10,%esp
			break;
  800db7:	e9 42 02 00 00       	jmp    800ffe <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800dbc:	8b 45 14             	mov    0x14(%ebp),%eax
  800dbf:	83 c0 04             	add    $0x4,%eax
  800dc2:	89 45 14             	mov    %eax,0x14(%ebp)
  800dc5:	8b 45 14             	mov    0x14(%ebp),%eax
  800dc8:	83 e8 04             	sub    $0x4,%eax
  800dcb:	8b 30                	mov    (%eax),%esi
  800dcd:	85 f6                	test   %esi,%esi
  800dcf:	75 05                	jne    800dd6 <vprintfmt+0x1a6>
				p = "(null)";
  800dd1:	be 71 2c 80 00       	mov    $0x802c71,%esi
			if (width > 0 && padc != '-')
  800dd6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dda:	7e 6d                	jle    800e49 <vprintfmt+0x219>
  800ddc:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800de0:	74 67                	je     800e49 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800de2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800de5:	83 ec 08             	sub    $0x8,%esp
  800de8:	50                   	push   %eax
  800de9:	56                   	push   %esi
  800dea:	e8 26 05 00 00       	call   801315 <strnlen>
  800def:	83 c4 10             	add    $0x10,%esp
  800df2:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800df5:	eb 16                	jmp    800e0d <vprintfmt+0x1dd>
					putch(padc, putdat);
  800df7:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800dfb:	83 ec 08             	sub    $0x8,%esp
  800dfe:	ff 75 0c             	pushl  0xc(%ebp)
  800e01:	50                   	push   %eax
  800e02:	8b 45 08             	mov    0x8(%ebp),%eax
  800e05:	ff d0                	call   *%eax
  800e07:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e0a:	ff 4d e4             	decl   -0x1c(%ebp)
  800e0d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e11:	7f e4                	jg     800df7 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e13:	eb 34                	jmp    800e49 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800e15:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800e19:	74 1c                	je     800e37 <vprintfmt+0x207>
  800e1b:	83 fb 1f             	cmp    $0x1f,%ebx
  800e1e:	7e 05                	jle    800e25 <vprintfmt+0x1f5>
  800e20:	83 fb 7e             	cmp    $0x7e,%ebx
  800e23:	7e 12                	jle    800e37 <vprintfmt+0x207>
					putch('?', putdat);
  800e25:	83 ec 08             	sub    $0x8,%esp
  800e28:	ff 75 0c             	pushl  0xc(%ebp)
  800e2b:	6a 3f                	push   $0x3f
  800e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e30:	ff d0                	call   *%eax
  800e32:	83 c4 10             	add    $0x10,%esp
  800e35:	eb 0f                	jmp    800e46 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800e37:	83 ec 08             	sub    $0x8,%esp
  800e3a:	ff 75 0c             	pushl  0xc(%ebp)
  800e3d:	53                   	push   %ebx
  800e3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e41:	ff d0                	call   *%eax
  800e43:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e46:	ff 4d e4             	decl   -0x1c(%ebp)
  800e49:	89 f0                	mov    %esi,%eax
  800e4b:	8d 70 01             	lea    0x1(%eax),%esi
  800e4e:	8a 00                	mov    (%eax),%al
  800e50:	0f be d8             	movsbl %al,%ebx
  800e53:	85 db                	test   %ebx,%ebx
  800e55:	74 24                	je     800e7b <vprintfmt+0x24b>
  800e57:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e5b:	78 b8                	js     800e15 <vprintfmt+0x1e5>
  800e5d:	ff 4d e0             	decl   -0x20(%ebp)
  800e60:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e64:	79 af                	jns    800e15 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e66:	eb 13                	jmp    800e7b <vprintfmt+0x24b>
				putch(' ', putdat);
  800e68:	83 ec 08             	sub    $0x8,%esp
  800e6b:	ff 75 0c             	pushl  0xc(%ebp)
  800e6e:	6a 20                	push   $0x20
  800e70:	8b 45 08             	mov    0x8(%ebp),%eax
  800e73:	ff d0                	call   *%eax
  800e75:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e78:	ff 4d e4             	decl   -0x1c(%ebp)
  800e7b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e7f:	7f e7                	jg     800e68 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800e81:	e9 78 01 00 00       	jmp    800ffe <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e86:	83 ec 08             	sub    $0x8,%esp
  800e89:	ff 75 e8             	pushl  -0x18(%ebp)
  800e8c:	8d 45 14             	lea    0x14(%ebp),%eax
  800e8f:	50                   	push   %eax
  800e90:	e8 3c fd ff ff       	call   800bd1 <getint>
  800e95:	83 c4 10             	add    $0x10,%esp
  800e98:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e9b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800e9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ea1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ea4:	85 d2                	test   %edx,%edx
  800ea6:	79 23                	jns    800ecb <vprintfmt+0x29b>
				putch('-', putdat);
  800ea8:	83 ec 08             	sub    $0x8,%esp
  800eab:	ff 75 0c             	pushl  0xc(%ebp)
  800eae:	6a 2d                	push   $0x2d
  800eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb3:	ff d0                	call   *%eax
  800eb5:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800eb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ebb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ebe:	f7 d8                	neg    %eax
  800ec0:	83 d2 00             	adc    $0x0,%edx
  800ec3:	f7 da                	neg    %edx
  800ec5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ec8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800ecb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ed2:	e9 bc 00 00 00       	jmp    800f93 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ed7:	83 ec 08             	sub    $0x8,%esp
  800eda:	ff 75 e8             	pushl  -0x18(%ebp)
  800edd:	8d 45 14             	lea    0x14(%ebp),%eax
  800ee0:	50                   	push   %eax
  800ee1:	e8 84 fc ff ff       	call   800b6a <getuint>
  800ee6:	83 c4 10             	add    $0x10,%esp
  800ee9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800eec:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800eef:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ef6:	e9 98 00 00 00       	jmp    800f93 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800efb:	83 ec 08             	sub    $0x8,%esp
  800efe:	ff 75 0c             	pushl  0xc(%ebp)
  800f01:	6a 58                	push   $0x58
  800f03:	8b 45 08             	mov    0x8(%ebp),%eax
  800f06:	ff d0                	call   *%eax
  800f08:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f0b:	83 ec 08             	sub    $0x8,%esp
  800f0e:	ff 75 0c             	pushl  0xc(%ebp)
  800f11:	6a 58                	push   $0x58
  800f13:	8b 45 08             	mov    0x8(%ebp),%eax
  800f16:	ff d0                	call   *%eax
  800f18:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f1b:	83 ec 08             	sub    $0x8,%esp
  800f1e:	ff 75 0c             	pushl  0xc(%ebp)
  800f21:	6a 58                	push   $0x58
  800f23:	8b 45 08             	mov    0x8(%ebp),%eax
  800f26:	ff d0                	call   *%eax
  800f28:	83 c4 10             	add    $0x10,%esp
			break;
  800f2b:	e9 ce 00 00 00       	jmp    800ffe <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800f30:	83 ec 08             	sub    $0x8,%esp
  800f33:	ff 75 0c             	pushl  0xc(%ebp)
  800f36:	6a 30                	push   $0x30
  800f38:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3b:	ff d0                	call   *%eax
  800f3d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800f40:	83 ec 08             	sub    $0x8,%esp
  800f43:	ff 75 0c             	pushl  0xc(%ebp)
  800f46:	6a 78                	push   $0x78
  800f48:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4b:	ff d0                	call   *%eax
  800f4d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800f50:	8b 45 14             	mov    0x14(%ebp),%eax
  800f53:	83 c0 04             	add    $0x4,%eax
  800f56:	89 45 14             	mov    %eax,0x14(%ebp)
  800f59:	8b 45 14             	mov    0x14(%ebp),%eax
  800f5c:	83 e8 04             	sub    $0x4,%eax
  800f5f:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f61:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f64:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800f6b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800f72:	eb 1f                	jmp    800f93 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800f74:	83 ec 08             	sub    $0x8,%esp
  800f77:	ff 75 e8             	pushl  -0x18(%ebp)
  800f7a:	8d 45 14             	lea    0x14(%ebp),%eax
  800f7d:	50                   	push   %eax
  800f7e:	e8 e7 fb ff ff       	call   800b6a <getuint>
  800f83:	83 c4 10             	add    $0x10,%esp
  800f86:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f89:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800f8c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f93:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800f97:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f9a:	83 ec 04             	sub    $0x4,%esp
  800f9d:	52                   	push   %edx
  800f9e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800fa1:	50                   	push   %eax
  800fa2:	ff 75 f4             	pushl  -0xc(%ebp)
  800fa5:	ff 75 f0             	pushl  -0x10(%ebp)
  800fa8:	ff 75 0c             	pushl  0xc(%ebp)
  800fab:	ff 75 08             	pushl  0x8(%ebp)
  800fae:	e8 00 fb ff ff       	call   800ab3 <printnum>
  800fb3:	83 c4 20             	add    $0x20,%esp
			break;
  800fb6:	eb 46                	jmp    800ffe <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800fb8:	83 ec 08             	sub    $0x8,%esp
  800fbb:	ff 75 0c             	pushl  0xc(%ebp)
  800fbe:	53                   	push   %ebx
  800fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc2:	ff d0                	call   *%eax
  800fc4:	83 c4 10             	add    $0x10,%esp
			break;
  800fc7:	eb 35                	jmp    800ffe <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800fc9:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
			break;
  800fd0:	eb 2c                	jmp    800ffe <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800fd2:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
			break;
  800fd9:	eb 23                	jmp    800ffe <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800fdb:	83 ec 08             	sub    $0x8,%esp
  800fde:	ff 75 0c             	pushl  0xc(%ebp)
  800fe1:	6a 25                	push   $0x25
  800fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe6:	ff d0                	call   *%eax
  800fe8:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800feb:	ff 4d 10             	decl   0x10(%ebp)
  800fee:	eb 03                	jmp    800ff3 <vprintfmt+0x3c3>
  800ff0:	ff 4d 10             	decl   0x10(%ebp)
  800ff3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff6:	48                   	dec    %eax
  800ff7:	8a 00                	mov    (%eax),%al
  800ff9:	3c 25                	cmp    $0x25,%al
  800ffb:	75 f3                	jne    800ff0 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800ffd:	90                   	nop
		}
	}
  800ffe:	e9 35 fc ff ff       	jmp    800c38 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801003:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801004:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801007:	5b                   	pop    %ebx
  801008:	5e                   	pop    %esi
  801009:	5d                   	pop    %ebp
  80100a:	c3                   	ret    

0080100b <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80100b:	55                   	push   %ebp
  80100c:	89 e5                	mov    %esp,%ebp
  80100e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801011:	8d 45 10             	lea    0x10(%ebp),%eax
  801014:	83 c0 04             	add    $0x4,%eax
  801017:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80101a:	8b 45 10             	mov    0x10(%ebp),%eax
  80101d:	ff 75 f4             	pushl  -0xc(%ebp)
  801020:	50                   	push   %eax
  801021:	ff 75 0c             	pushl  0xc(%ebp)
  801024:	ff 75 08             	pushl  0x8(%ebp)
  801027:	e8 04 fc ff ff       	call   800c30 <vprintfmt>
  80102c:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80102f:	90                   	nop
  801030:	c9                   	leave  
  801031:	c3                   	ret    

00801032 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801032:	55                   	push   %ebp
  801033:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801035:	8b 45 0c             	mov    0xc(%ebp),%eax
  801038:	8b 40 08             	mov    0x8(%eax),%eax
  80103b:	8d 50 01             	lea    0x1(%eax),%edx
  80103e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801041:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801044:	8b 45 0c             	mov    0xc(%ebp),%eax
  801047:	8b 10                	mov    (%eax),%edx
  801049:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104c:	8b 40 04             	mov    0x4(%eax),%eax
  80104f:	39 c2                	cmp    %eax,%edx
  801051:	73 12                	jae    801065 <sprintputch+0x33>
		*b->buf++ = ch;
  801053:	8b 45 0c             	mov    0xc(%ebp),%eax
  801056:	8b 00                	mov    (%eax),%eax
  801058:	8d 48 01             	lea    0x1(%eax),%ecx
  80105b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80105e:	89 0a                	mov    %ecx,(%edx)
  801060:	8b 55 08             	mov    0x8(%ebp),%edx
  801063:	88 10                	mov    %dl,(%eax)
}
  801065:	90                   	nop
  801066:	5d                   	pop    %ebp
  801067:	c3                   	ret    

00801068 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801068:	55                   	push   %ebp
  801069:	89 e5                	mov    %esp,%ebp
  80106b:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80106e:	8b 45 08             	mov    0x8(%ebp),%eax
  801071:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801074:	8b 45 0c             	mov    0xc(%ebp),%eax
  801077:	8d 50 ff             	lea    -0x1(%eax),%edx
  80107a:	8b 45 08             	mov    0x8(%ebp),%eax
  80107d:	01 d0                	add    %edx,%eax
  80107f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801082:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801089:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80108d:	74 06                	je     801095 <vsnprintf+0x2d>
  80108f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801093:	7f 07                	jg     80109c <vsnprintf+0x34>
		return -E_INVAL;
  801095:	b8 03 00 00 00       	mov    $0x3,%eax
  80109a:	eb 20                	jmp    8010bc <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80109c:	ff 75 14             	pushl  0x14(%ebp)
  80109f:	ff 75 10             	pushl  0x10(%ebp)
  8010a2:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8010a5:	50                   	push   %eax
  8010a6:	68 32 10 80 00       	push   $0x801032
  8010ab:	e8 80 fb ff ff       	call   800c30 <vprintfmt>
  8010b0:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8010b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8010b6:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8010b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8010bc:	c9                   	leave  
  8010bd:	c3                   	ret    

008010be <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8010be:	55                   	push   %ebp
  8010bf:	89 e5                	mov    %esp,%ebp
  8010c1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8010c4:	8d 45 10             	lea    0x10(%ebp),%eax
  8010c7:	83 c0 04             	add    $0x4,%eax
  8010ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8010cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d0:	ff 75 f4             	pushl  -0xc(%ebp)
  8010d3:	50                   	push   %eax
  8010d4:	ff 75 0c             	pushl  0xc(%ebp)
  8010d7:	ff 75 08             	pushl  0x8(%ebp)
  8010da:	e8 89 ff ff ff       	call   801068 <vsnprintf>
  8010df:	83 c4 10             	add    $0x10,%esp
  8010e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8010e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8010e8:	c9                   	leave  
  8010e9:	c3                   	ret    

008010ea <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  8010ea:	55                   	push   %ebp
  8010eb:	89 e5                	mov    %esp,%ebp
  8010ed:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  8010f0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010f4:	74 13                	je     801109 <readline+0x1f>
		cprintf("%s", prompt);
  8010f6:	83 ec 08             	sub    $0x8,%esp
  8010f9:	ff 75 08             	pushl  0x8(%ebp)
  8010fc:	68 e8 2d 80 00       	push   $0x802de8
  801101:	e8 0b f9 ff ff       	call   800a11 <cprintf>
  801106:	83 c4 10             	add    $0x10,%esp

	i = 0;
  801109:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801110:	83 ec 0c             	sub    $0xc,%esp
  801113:	6a 00                	push   $0x0
  801115:	e8 6f f4 ff ff       	call   800589 <iscons>
  80111a:	83 c4 10             	add    $0x10,%esp
  80111d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801120:	e8 51 f4 ff ff       	call   800576 <getchar>
  801125:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801128:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80112c:	79 22                	jns    801150 <readline+0x66>
			if (c != -E_EOF)
  80112e:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801132:	0f 84 ad 00 00 00    	je     8011e5 <readline+0xfb>
				cprintf("read error: %e\n", c);
  801138:	83 ec 08             	sub    $0x8,%esp
  80113b:	ff 75 ec             	pushl  -0x14(%ebp)
  80113e:	68 eb 2d 80 00       	push   $0x802deb
  801143:	e8 c9 f8 ff ff       	call   800a11 <cprintf>
  801148:	83 c4 10             	add    $0x10,%esp
			break;
  80114b:	e9 95 00 00 00       	jmp    8011e5 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801150:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801154:	7e 34                	jle    80118a <readline+0xa0>
  801156:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80115d:	7f 2b                	jg     80118a <readline+0xa0>
			if (echoing)
  80115f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801163:	74 0e                	je     801173 <readline+0x89>
				cputchar(c);
  801165:	83 ec 0c             	sub    $0xc,%esp
  801168:	ff 75 ec             	pushl  -0x14(%ebp)
  80116b:	e8 e7 f3 ff ff       	call   800557 <cputchar>
  801170:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801173:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801176:	8d 50 01             	lea    0x1(%eax),%edx
  801179:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80117c:	89 c2                	mov    %eax,%edx
  80117e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801181:	01 d0                	add    %edx,%eax
  801183:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801186:	88 10                	mov    %dl,(%eax)
  801188:	eb 56                	jmp    8011e0 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  80118a:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80118e:	75 1f                	jne    8011af <readline+0xc5>
  801190:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801194:	7e 19                	jle    8011af <readline+0xc5>
			if (echoing)
  801196:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80119a:	74 0e                	je     8011aa <readline+0xc0>
				cputchar(c);
  80119c:	83 ec 0c             	sub    $0xc,%esp
  80119f:	ff 75 ec             	pushl  -0x14(%ebp)
  8011a2:	e8 b0 f3 ff ff       	call   800557 <cputchar>
  8011a7:	83 c4 10             	add    $0x10,%esp

			i--;
  8011aa:	ff 4d f4             	decl   -0xc(%ebp)
  8011ad:	eb 31                	jmp    8011e0 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  8011af:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8011b3:	74 0a                	je     8011bf <readline+0xd5>
  8011b5:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8011b9:	0f 85 61 ff ff ff    	jne    801120 <readline+0x36>
			if (echoing)
  8011bf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8011c3:	74 0e                	je     8011d3 <readline+0xe9>
				cputchar(c);
  8011c5:	83 ec 0c             	sub    $0xc,%esp
  8011c8:	ff 75 ec             	pushl  -0x14(%ebp)
  8011cb:	e8 87 f3 ff ff       	call   800557 <cputchar>
  8011d0:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  8011d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d9:	01 d0                	add    %edx,%eax
  8011db:	c6 00 00             	movb   $0x0,(%eax)
			break;
  8011de:	eb 06                	jmp    8011e6 <readline+0xfc>
		}
	}
  8011e0:	e9 3b ff ff ff       	jmp    801120 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  8011e5:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  8011e6:	90                   	nop
  8011e7:	c9                   	leave  
  8011e8:	c3                   	ret    

008011e9 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  8011e9:	55                   	push   %ebp
  8011ea:	89 e5                	mov    %esp,%ebp
  8011ec:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  8011ef:	e8 30 0b 00 00       	call   801d24 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  8011f4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011f8:	74 13                	je     80120d <atomic_readline+0x24>
			cprintf("%s", prompt);
  8011fa:	83 ec 08             	sub    $0x8,%esp
  8011fd:	ff 75 08             	pushl  0x8(%ebp)
  801200:	68 e8 2d 80 00       	push   $0x802de8
  801205:	e8 07 f8 ff ff       	call   800a11 <cprintf>
  80120a:	83 c4 10             	add    $0x10,%esp

		i = 0;
  80120d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  801214:	83 ec 0c             	sub    $0xc,%esp
  801217:	6a 00                	push   $0x0
  801219:	e8 6b f3 ff ff       	call   800589 <iscons>
  80121e:	83 c4 10             	add    $0x10,%esp
  801221:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  801224:	e8 4d f3 ff ff       	call   800576 <getchar>
  801229:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  80122c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801230:	79 22                	jns    801254 <atomic_readline+0x6b>
				if (c != -E_EOF)
  801232:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801236:	0f 84 ad 00 00 00    	je     8012e9 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  80123c:	83 ec 08             	sub    $0x8,%esp
  80123f:	ff 75 ec             	pushl  -0x14(%ebp)
  801242:	68 eb 2d 80 00       	push   $0x802deb
  801247:	e8 c5 f7 ff ff       	call   800a11 <cprintf>
  80124c:	83 c4 10             	add    $0x10,%esp
				break;
  80124f:	e9 95 00 00 00       	jmp    8012e9 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  801254:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801258:	7e 34                	jle    80128e <atomic_readline+0xa5>
  80125a:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801261:	7f 2b                	jg     80128e <atomic_readline+0xa5>
				if (echoing)
  801263:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801267:	74 0e                	je     801277 <atomic_readline+0x8e>
					cputchar(c);
  801269:	83 ec 0c             	sub    $0xc,%esp
  80126c:	ff 75 ec             	pushl  -0x14(%ebp)
  80126f:	e8 e3 f2 ff ff       	call   800557 <cputchar>
  801274:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  801277:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80127a:	8d 50 01             	lea    0x1(%eax),%edx
  80127d:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801280:	89 c2                	mov    %eax,%edx
  801282:	8b 45 0c             	mov    0xc(%ebp),%eax
  801285:	01 d0                	add    %edx,%eax
  801287:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80128a:	88 10                	mov    %dl,(%eax)
  80128c:	eb 56                	jmp    8012e4 <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  80128e:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801292:	75 1f                	jne    8012b3 <atomic_readline+0xca>
  801294:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801298:	7e 19                	jle    8012b3 <atomic_readline+0xca>
				if (echoing)
  80129a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80129e:	74 0e                	je     8012ae <atomic_readline+0xc5>
					cputchar(c);
  8012a0:	83 ec 0c             	sub    $0xc,%esp
  8012a3:	ff 75 ec             	pushl  -0x14(%ebp)
  8012a6:	e8 ac f2 ff ff       	call   800557 <cputchar>
  8012ab:	83 c4 10             	add    $0x10,%esp
				i--;
  8012ae:	ff 4d f4             	decl   -0xc(%ebp)
  8012b1:	eb 31                	jmp    8012e4 <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  8012b3:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8012b7:	74 0a                	je     8012c3 <atomic_readline+0xda>
  8012b9:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8012bd:	0f 85 61 ff ff ff    	jne    801224 <atomic_readline+0x3b>
				if (echoing)
  8012c3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012c7:	74 0e                	je     8012d7 <atomic_readline+0xee>
					cputchar(c);
  8012c9:	83 ec 0c             	sub    $0xc,%esp
  8012cc:	ff 75 ec             	pushl  -0x14(%ebp)
  8012cf:	e8 83 f2 ff ff       	call   800557 <cputchar>
  8012d4:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  8012d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012dd:	01 d0                	add    %edx,%eax
  8012df:	c6 00 00             	movb   $0x0,(%eax)
				break;
  8012e2:	eb 06                	jmp    8012ea <atomic_readline+0x101>
			}
		}
  8012e4:	e9 3b ff ff ff       	jmp    801224 <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  8012e9:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  8012ea:	e8 4f 0a 00 00       	call   801d3e <sys_unlock_cons>
}
  8012ef:	90                   	nop
  8012f0:	c9                   	leave  
  8012f1:	c3                   	ret    

008012f2 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8012f2:	55                   	push   %ebp
  8012f3:	89 e5                	mov    %esp,%ebp
  8012f5:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8012f8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012ff:	eb 06                	jmp    801307 <strlen+0x15>
		n++;
  801301:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801304:	ff 45 08             	incl   0x8(%ebp)
  801307:	8b 45 08             	mov    0x8(%ebp),%eax
  80130a:	8a 00                	mov    (%eax),%al
  80130c:	84 c0                	test   %al,%al
  80130e:	75 f1                	jne    801301 <strlen+0xf>
		n++;
	return n;
  801310:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801313:	c9                   	leave  
  801314:	c3                   	ret    

00801315 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801315:	55                   	push   %ebp
  801316:	89 e5                	mov    %esp,%ebp
  801318:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80131b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801322:	eb 09                	jmp    80132d <strnlen+0x18>
		n++;
  801324:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801327:	ff 45 08             	incl   0x8(%ebp)
  80132a:	ff 4d 0c             	decl   0xc(%ebp)
  80132d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801331:	74 09                	je     80133c <strnlen+0x27>
  801333:	8b 45 08             	mov    0x8(%ebp),%eax
  801336:	8a 00                	mov    (%eax),%al
  801338:	84 c0                	test   %al,%al
  80133a:	75 e8                	jne    801324 <strnlen+0xf>
		n++;
	return n;
  80133c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80133f:	c9                   	leave  
  801340:	c3                   	ret    

00801341 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801341:	55                   	push   %ebp
  801342:	89 e5                	mov    %esp,%ebp
  801344:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801347:	8b 45 08             	mov    0x8(%ebp),%eax
  80134a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80134d:	90                   	nop
  80134e:	8b 45 08             	mov    0x8(%ebp),%eax
  801351:	8d 50 01             	lea    0x1(%eax),%edx
  801354:	89 55 08             	mov    %edx,0x8(%ebp)
  801357:	8b 55 0c             	mov    0xc(%ebp),%edx
  80135a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80135d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801360:	8a 12                	mov    (%edx),%dl
  801362:	88 10                	mov    %dl,(%eax)
  801364:	8a 00                	mov    (%eax),%al
  801366:	84 c0                	test   %al,%al
  801368:	75 e4                	jne    80134e <strcpy+0xd>
		/* do nothing */;
	return ret;
  80136a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80136d:	c9                   	leave  
  80136e:	c3                   	ret    

0080136f <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80136f:	55                   	push   %ebp
  801370:	89 e5                	mov    %esp,%ebp
  801372:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801375:	8b 45 08             	mov    0x8(%ebp),%eax
  801378:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80137b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801382:	eb 1f                	jmp    8013a3 <strncpy+0x34>
		*dst++ = *src;
  801384:	8b 45 08             	mov    0x8(%ebp),%eax
  801387:	8d 50 01             	lea    0x1(%eax),%edx
  80138a:	89 55 08             	mov    %edx,0x8(%ebp)
  80138d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801390:	8a 12                	mov    (%edx),%dl
  801392:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801394:	8b 45 0c             	mov    0xc(%ebp),%eax
  801397:	8a 00                	mov    (%eax),%al
  801399:	84 c0                	test   %al,%al
  80139b:	74 03                	je     8013a0 <strncpy+0x31>
			src++;
  80139d:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8013a0:	ff 45 fc             	incl   -0x4(%ebp)
  8013a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013a6:	3b 45 10             	cmp    0x10(%ebp),%eax
  8013a9:	72 d9                	jb     801384 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8013ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8013ae:	c9                   	leave  
  8013af:	c3                   	ret    

008013b0 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8013b0:	55                   	push   %ebp
  8013b1:	89 e5                	mov    %esp,%ebp
  8013b3:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8013b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8013bc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013c0:	74 30                	je     8013f2 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8013c2:	eb 16                	jmp    8013da <strlcpy+0x2a>
			*dst++ = *src++;
  8013c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c7:	8d 50 01             	lea    0x1(%eax),%edx
  8013ca:	89 55 08             	mov    %edx,0x8(%ebp)
  8013cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013d0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013d3:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8013d6:	8a 12                	mov    (%edx),%dl
  8013d8:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8013da:	ff 4d 10             	decl   0x10(%ebp)
  8013dd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013e1:	74 09                	je     8013ec <strlcpy+0x3c>
  8013e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e6:	8a 00                	mov    (%eax),%al
  8013e8:	84 c0                	test   %al,%al
  8013ea:	75 d8                	jne    8013c4 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8013ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ef:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8013f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8013f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013f8:	29 c2                	sub    %eax,%edx
  8013fa:	89 d0                	mov    %edx,%eax
}
  8013fc:	c9                   	leave  
  8013fd:	c3                   	ret    

008013fe <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8013fe:	55                   	push   %ebp
  8013ff:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801401:	eb 06                	jmp    801409 <strcmp+0xb>
		p++, q++;
  801403:	ff 45 08             	incl   0x8(%ebp)
  801406:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801409:	8b 45 08             	mov    0x8(%ebp),%eax
  80140c:	8a 00                	mov    (%eax),%al
  80140e:	84 c0                	test   %al,%al
  801410:	74 0e                	je     801420 <strcmp+0x22>
  801412:	8b 45 08             	mov    0x8(%ebp),%eax
  801415:	8a 10                	mov    (%eax),%dl
  801417:	8b 45 0c             	mov    0xc(%ebp),%eax
  80141a:	8a 00                	mov    (%eax),%al
  80141c:	38 c2                	cmp    %al,%dl
  80141e:	74 e3                	je     801403 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801420:	8b 45 08             	mov    0x8(%ebp),%eax
  801423:	8a 00                	mov    (%eax),%al
  801425:	0f b6 d0             	movzbl %al,%edx
  801428:	8b 45 0c             	mov    0xc(%ebp),%eax
  80142b:	8a 00                	mov    (%eax),%al
  80142d:	0f b6 c0             	movzbl %al,%eax
  801430:	29 c2                	sub    %eax,%edx
  801432:	89 d0                	mov    %edx,%eax
}
  801434:	5d                   	pop    %ebp
  801435:	c3                   	ret    

00801436 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801436:	55                   	push   %ebp
  801437:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801439:	eb 09                	jmp    801444 <strncmp+0xe>
		n--, p++, q++;
  80143b:	ff 4d 10             	decl   0x10(%ebp)
  80143e:	ff 45 08             	incl   0x8(%ebp)
  801441:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801444:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801448:	74 17                	je     801461 <strncmp+0x2b>
  80144a:	8b 45 08             	mov    0x8(%ebp),%eax
  80144d:	8a 00                	mov    (%eax),%al
  80144f:	84 c0                	test   %al,%al
  801451:	74 0e                	je     801461 <strncmp+0x2b>
  801453:	8b 45 08             	mov    0x8(%ebp),%eax
  801456:	8a 10                	mov    (%eax),%dl
  801458:	8b 45 0c             	mov    0xc(%ebp),%eax
  80145b:	8a 00                	mov    (%eax),%al
  80145d:	38 c2                	cmp    %al,%dl
  80145f:	74 da                	je     80143b <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801461:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801465:	75 07                	jne    80146e <strncmp+0x38>
		return 0;
  801467:	b8 00 00 00 00       	mov    $0x0,%eax
  80146c:	eb 14                	jmp    801482 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80146e:	8b 45 08             	mov    0x8(%ebp),%eax
  801471:	8a 00                	mov    (%eax),%al
  801473:	0f b6 d0             	movzbl %al,%edx
  801476:	8b 45 0c             	mov    0xc(%ebp),%eax
  801479:	8a 00                	mov    (%eax),%al
  80147b:	0f b6 c0             	movzbl %al,%eax
  80147e:	29 c2                	sub    %eax,%edx
  801480:	89 d0                	mov    %edx,%eax
}
  801482:	5d                   	pop    %ebp
  801483:	c3                   	ret    

00801484 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801484:	55                   	push   %ebp
  801485:	89 e5                	mov    %esp,%ebp
  801487:	83 ec 04             	sub    $0x4,%esp
  80148a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80148d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801490:	eb 12                	jmp    8014a4 <strchr+0x20>
		if (*s == c)
  801492:	8b 45 08             	mov    0x8(%ebp),%eax
  801495:	8a 00                	mov    (%eax),%al
  801497:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80149a:	75 05                	jne    8014a1 <strchr+0x1d>
			return (char *) s;
  80149c:	8b 45 08             	mov    0x8(%ebp),%eax
  80149f:	eb 11                	jmp    8014b2 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8014a1:	ff 45 08             	incl   0x8(%ebp)
  8014a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a7:	8a 00                	mov    (%eax),%al
  8014a9:	84 c0                	test   %al,%al
  8014ab:	75 e5                	jne    801492 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8014ad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014b2:	c9                   	leave  
  8014b3:	c3                   	ret    

008014b4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8014b4:	55                   	push   %ebp
  8014b5:	89 e5                	mov    %esp,%ebp
  8014b7:	83 ec 04             	sub    $0x4,%esp
  8014ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014bd:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8014c0:	eb 0d                	jmp    8014cf <strfind+0x1b>
		if (*s == c)
  8014c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c5:	8a 00                	mov    (%eax),%al
  8014c7:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8014ca:	74 0e                	je     8014da <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8014cc:	ff 45 08             	incl   0x8(%ebp)
  8014cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d2:	8a 00                	mov    (%eax),%al
  8014d4:	84 c0                	test   %al,%al
  8014d6:	75 ea                	jne    8014c2 <strfind+0xe>
  8014d8:	eb 01                	jmp    8014db <strfind+0x27>
		if (*s == c)
			break;
  8014da:	90                   	nop
	return (char *) s;
  8014db:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014de:	c9                   	leave  
  8014df:	c3                   	ret    

008014e0 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  8014e0:	55                   	push   %ebp
  8014e1:	89 e5                	mov    %esp,%ebp
  8014e3:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  8014e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  8014ec:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8014f0:	76 63                	jbe    801555 <memset+0x75>
		uint64 data_block = c;
  8014f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f5:	99                   	cltd   
  8014f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014f9:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  8014fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801502:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801506:	c1 e0 08             	shl    $0x8,%eax
  801509:	09 45 f0             	or     %eax,-0x10(%ebp)
  80150c:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  80150f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801512:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801515:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801519:	c1 e0 10             	shl    $0x10,%eax
  80151c:	09 45 f0             	or     %eax,-0x10(%ebp)
  80151f:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801522:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801525:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801528:	89 c2                	mov    %eax,%edx
  80152a:	b8 00 00 00 00       	mov    $0x0,%eax
  80152f:	09 45 f0             	or     %eax,-0x10(%ebp)
  801532:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801535:	eb 18                	jmp    80154f <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801537:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80153a:	8d 41 08             	lea    0x8(%ecx),%eax
  80153d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801540:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801543:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801546:	89 01                	mov    %eax,(%ecx)
  801548:	89 51 04             	mov    %edx,0x4(%ecx)
  80154b:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  80154f:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801553:	77 e2                	ja     801537 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801555:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801559:	74 23                	je     80157e <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  80155b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80155e:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801561:	eb 0e                	jmp    801571 <memset+0x91>
			*p8++ = (uint8)c;
  801563:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801566:	8d 50 01             	lea    0x1(%eax),%edx
  801569:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80156c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80156f:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801571:	8b 45 10             	mov    0x10(%ebp),%eax
  801574:	8d 50 ff             	lea    -0x1(%eax),%edx
  801577:	89 55 10             	mov    %edx,0x10(%ebp)
  80157a:	85 c0                	test   %eax,%eax
  80157c:	75 e5                	jne    801563 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  80157e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801581:	c9                   	leave  
  801582:	c3                   	ret    

00801583 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801583:	55                   	push   %ebp
  801584:	89 e5                	mov    %esp,%ebp
  801586:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801589:	8b 45 0c             	mov    0xc(%ebp),%eax
  80158c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  80158f:	8b 45 08             	mov    0x8(%ebp),%eax
  801592:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801595:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801599:	76 24                	jbe    8015bf <memcpy+0x3c>
		while(n >= 8){
  80159b:	eb 1c                	jmp    8015b9 <memcpy+0x36>
			*d64 = *s64;
  80159d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015a0:	8b 50 04             	mov    0x4(%eax),%edx
  8015a3:	8b 00                	mov    (%eax),%eax
  8015a5:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8015a8:	89 01                	mov    %eax,(%ecx)
  8015aa:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8015ad:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8015b1:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8015b5:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8015b9:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8015bd:	77 de                	ja     80159d <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8015bf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015c3:	74 31                	je     8015f6 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8015c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8015cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8015d1:	eb 16                	jmp    8015e9 <memcpy+0x66>
			*d8++ = *s8++;
  8015d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015d6:	8d 50 01             	lea    0x1(%eax),%edx
  8015d9:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8015dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015df:	8d 4a 01             	lea    0x1(%edx),%ecx
  8015e2:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8015e5:	8a 12                	mov    (%edx),%dl
  8015e7:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  8015e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8015ec:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015ef:	89 55 10             	mov    %edx,0x10(%ebp)
  8015f2:	85 c0                	test   %eax,%eax
  8015f4:	75 dd                	jne    8015d3 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  8015f6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015f9:	c9                   	leave  
  8015fa:	c3                   	ret    

008015fb <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8015fb:	55                   	push   %ebp
  8015fc:	89 e5                	mov    %esp,%ebp
  8015fe:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801601:	8b 45 0c             	mov    0xc(%ebp),%eax
  801604:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801607:	8b 45 08             	mov    0x8(%ebp),%eax
  80160a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80160d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801610:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801613:	73 50                	jae    801665 <memmove+0x6a>
  801615:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801618:	8b 45 10             	mov    0x10(%ebp),%eax
  80161b:	01 d0                	add    %edx,%eax
  80161d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801620:	76 43                	jbe    801665 <memmove+0x6a>
		s += n;
  801622:	8b 45 10             	mov    0x10(%ebp),%eax
  801625:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801628:	8b 45 10             	mov    0x10(%ebp),%eax
  80162b:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80162e:	eb 10                	jmp    801640 <memmove+0x45>
			*--d = *--s;
  801630:	ff 4d f8             	decl   -0x8(%ebp)
  801633:	ff 4d fc             	decl   -0x4(%ebp)
  801636:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801639:	8a 10                	mov    (%eax),%dl
  80163b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80163e:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801640:	8b 45 10             	mov    0x10(%ebp),%eax
  801643:	8d 50 ff             	lea    -0x1(%eax),%edx
  801646:	89 55 10             	mov    %edx,0x10(%ebp)
  801649:	85 c0                	test   %eax,%eax
  80164b:	75 e3                	jne    801630 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80164d:	eb 23                	jmp    801672 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80164f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801652:	8d 50 01             	lea    0x1(%eax),%edx
  801655:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801658:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80165b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80165e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801661:	8a 12                	mov    (%edx),%dl
  801663:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801665:	8b 45 10             	mov    0x10(%ebp),%eax
  801668:	8d 50 ff             	lea    -0x1(%eax),%edx
  80166b:	89 55 10             	mov    %edx,0x10(%ebp)
  80166e:	85 c0                	test   %eax,%eax
  801670:	75 dd                	jne    80164f <memmove+0x54>
			*d++ = *s++;

	return dst;
  801672:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801675:	c9                   	leave  
  801676:	c3                   	ret    

00801677 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801677:	55                   	push   %ebp
  801678:	89 e5                	mov    %esp,%ebp
  80167a:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80167d:	8b 45 08             	mov    0x8(%ebp),%eax
  801680:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801683:	8b 45 0c             	mov    0xc(%ebp),%eax
  801686:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801689:	eb 2a                	jmp    8016b5 <memcmp+0x3e>
		if (*s1 != *s2)
  80168b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80168e:	8a 10                	mov    (%eax),%dl
  801690:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801693:	8a 00                	mov    (%eax),%al
  801695:	38 c2                	cmp    %al,%dl
  801697:	74 16                	je     8016af <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801699:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80169c:	8a 00                	mov    (%eax),%al
  80169e:	0f b6 d0             	movzbl %al,%edx
  8016a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016a4:	8a 00                	mov    (%eax),%al
  8016a6:	0f b6 c0             	movzbl %al,%eax
  8016a9:	29 c2                	sub    %eax,%edx
  8016ab:	89 d0                	mov    %edx,%eax
  8016ad:	eb 18                	jmp    8016c7 <memcmp+0x50>
		s1++, s2++;
  8016af:	ff 45 fc             	incl   -0x4(%ebp)
  8016b2:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8016b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016bb:	89 55 10             	mov    %edx,0x10(%ebp)
  8016be:	85 c0                	test   %eax,%eax
  8016c0:	75 c9                	jne    80168b <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8016c2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016c7:	c9                   	leave  
  8016c8:	c3                   	ret    

008016c9 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8016c9:	55                   	push   %ebp
  8016ca:	89 e5                	mov    %esp,%ebp
  8016cc:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8016cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8016d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8016d5:	01 d0                	add    %edx,%eax
  8016d7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8016da:	eb 15                	jmp    8016f1 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8016dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016df:	8a 00                	mov    (%eax),%al
  8016e1:	0f b6 d0             	movzbl %al,%edx
  8016e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016e7:	0f b6 c0             	movzbl %al,%eax
  8016ea:	39 c2                	cmp    %eax,%edx
  8016ec:	74 0d                	je     8016fb <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8016ee:	ff 45 08             	incl   0x8(%ebp)
  8016f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8016f7:	72 e3                	jb     8016dc <memfind+0x13>
  8016f9:	eb 01                	jmp    8016fc <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8016fb:	90                   	nop
	return (void *) s;
  8016fc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016ff:	c9                   	leave  
  801700:	c3                   	ret    

00801701 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801701:	55                   	push   %ebp
  801702:	89 e5                	mov    %esp,%ebp
  801704:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801707:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80170e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801715:	eb 03                	jmp    80171a <strtol+0x19>
		s++;
  801717:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80171a:	8b 45 08             	mov    0x8(%ebp),%eax
  80171d:	8a 00                	mov    (%eax),%al
  80171f:	3c 20                	cmp    $0x20,%al
  801721:	74 f4                	je     801717 <strtol+0x16>
  801723:	8b 45 08             	mov    0x8(%ebp),%eax
  801726:	8a 00                	mov    (%eax),%al
  801728:	3c 09                	cmp    $0x9,%al
  80172a:	74 eb                	je     801717 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80172c:	8b 45 08             	mov    0x8(%ebp),%eax
  80172f:	8a 00                	mov    (%eax),%al
  801731:	3c 2b                	cmp    $0x2b,%al
  801733:	75 05                	jne    80173a <strtol+0x39>
		s++;
  801735:	ff 45 08             	incl   0x8(%ebp)
  801738:	eb 13                	jmp    80174d <strtol+0x4c>
	else if (*s == '-')
  80173a:	8b 45 08             	mov    0x8(%ebp),%eax
  80173d:	8a 00                	mov    (%eax),%al
  80173f:	3c 2d                	cmp    $0x2d,%al
  801741:	75 0a                	jne    80174d <strtol+0x4c>
		s++, neg = 1;
  801743:	ff 45 08             	incl   0x8(%ebp)
  801746:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80174d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801751:	74 06                	je     801759 <strtol+0x58>
  801753:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801757:	75 20                	jne    801779 <strtol+0x78>
  801759:	8b 45 08             	mov    0x8(%ebp),%eax
  80175c:	8a 00                	mov    (%eax),%al
  80175e:	3c 30                	cmp    $0x30,%al
  801760:	75 17                	jne    801779 <strtol+0x78>
  801762:	8b 45 08             	mov    0x8(%ebp),%eax
  801765:	40                   	inc    %eax
  801766:	8a 00                	mov    (%eax),%al
  801768:	3c 78                	cmp    $0x78,%al
  80176a:	75 0d                	jne    801779 <strtol+0x78>
		s += 2, base = 16;
  80176c:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801770:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801777:	eb 28                	jmp    8017a1 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801779:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80177d:	75 15                	jne    801794 <strtol+0x93>
  80177f:	8b 45 08             	mov    0x8(%ebp),%eax
  801782:	8a 00                	mov    (%eax),%al
  801784:	3c 30                	cmp    $0x30,%al
  801786:	75 0c                	jne    801794 <strtol+0x93>
		s++, base = 8;
  801788:	ff 45 08             	incl   0x8(%ebp)
  80178b:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801792:	eb 0d                	jmp    8017a1 <strtol+0xa0>
	else if (base == 0)
  801794:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801798:	75 07                	jne    8017a1 <strtol+0xa0>
		base = 10;
  80179a:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8017a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a4:	8a 00                	mov    (%eax),%al
  8017a6:	3c 2f                	cmp    $0x2f,%al
  8017a8:	7e 19                	jle    8017c3 <strtol+0xc2>
  8017aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ad:	8a 00                	mov    (%eax),%al
  8017af:	3c 39                	cmp    $0x39,%al
  8017b1:	7f 10                	jg     8017c3 <strtol+0xc2>
			dig = *s - '0';
  8017b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b6:	8a 00                	mov    (%eax),%al
  8017b8:	0f be c0             	movsbl %al,%eax
  8017bb:	83 e8 30             	sub    $0x30,%eax
  8017be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017c1:	eb 42                	jmp    801805 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8017c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c6:	8a 00                	mov    (%eax),%al
  8017c8:	3c 60                	cmp    $0x60,%al
  8017ca:	7e 19                	jle    8017e5 <strtol+0xe4>
  8017cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cf:	8a 00                	mov    (%eax),%al
  8017d1:	3c 7a                	cmp    $0x7a,%al
  8017d3:	7f 10                	jg     8017e5 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8017d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d8:	8a 00                	mov    (%eax),%al
  8017da:	0f be c0             	movsbl %al,%eax
  8017dd:	83 e8 57             	sub    $0x57,%eax
  8017e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017e3:	eb 20                	jmp    801805 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8017e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e8:	8a 00                	mov    (%eax),%al
  8017ea:	3c 40                	cmp    $0x40,%al
  8017ec:	7e 39                	jle    801827 <strtol+0x126>
  8017ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f1:	8a 00                	mov    (%eax),%al
  8017f3:	3c 5a                	cmp    $0x5a,%al
  8017f5:	7f 30                	jg     801827 <strtol+0x126>
			dig = *s - 'A' + 10;
  8017f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fa:	8a 00                	mov    (%eax),%al
  8017fc:	0f be c0             	movsbl %al,%eax
  8017ff:	83 e8 37             	sub    $0x37,%eax
  801802:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801805:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801808:	3b 45 10             	cmp    0x10(%ebp),%eax
  80180b:	7d 19                	jge    801826 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80180d:	ff 45 08             	incl   0x8(%ebp)
  801810:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801813:	0f af 45 10          	imul   0x10(%ebp),%eax
  801817:	89 c2                	mov    %eax,%edx
  801819:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80181c:	01 d0                	add    %edx,%eax
  80181e:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801821:	e9 7b ff ff ff       	jmp    8017a1 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801826:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801827:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80182b:	74 08                	je     801835 <strtol+0x134>
		*endptr = (char *) s;
  80182d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801830:	8b 55 08             	mov    0x8(%ebp),%edx
  801833:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801835:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801839:	74 07                	je     801842 <strtol+0x141>
  80183b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80183e:	f7 d8                	neg    %eax
  801840:	eb 03                	jmp    801845 <strtol+0x144>
  801842:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801845:	c9                   	leave  
  801846:	c3                   	ret    

00801847 <ltostr>:

void
ltostr(long value, char *str)
{
  801847:	55                   	push   %ebp
  801848:	89 e5                	mov    %esp,%ebp
  80184a:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80184d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801854:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80185b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80185f:	79 13                	jns    801874 <ltostr+0x2d>
	{
		neg = 1;
  801861:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801868:	8b 45 0c             	mov    0xc(%ebp),%eax
  80186b:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80186e:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801871:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801874:	8b 45 08             	mov    0x8(%ebp),%eax
  801877:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80187c:	99                   	cltd   
  80187d:	f7 f9                	idiv   %ecx
  80187f:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801882:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801885:	8d 50 01             	lea    0x1(%eax),%edx
  801888:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80188b:	89 c2                	mov    %eax,%edx
  80188d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801890:	01 d0                	add    %edx,%eax
  801892:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801895:	83 c2 30             	add    $0x30,%edx
  801898:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80189a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80189d:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8018a2:	f7 e9                	imul   %ecx
  8018a4:	c1 fa 02             	sar    $0x2,%edx
  8018a7:	89 c8                	mov    %ecx,%eax
  8018a9:	c1 f8 1f             	sar    $0x1f,%eax
  8018ac:	29 c2                	sub    %eax,%edx
  8018ae:	89 d0                	mov    %edx,%eax
  8018b0:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8018b3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018b7:	75 bb                	jne    801874 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8018b9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8018c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018c3:	48                   	dec    %eax
  8018c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8018c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8018cb:	74 3d                	je     80190a <ltostr+0xc3>
		start = 1 ;
  8018cd:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8018d4:	eb 34                	jmp    80190a <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8018d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018dc:	01 d0                	add    %edx,%eax
  8018de:	8a 00                	mov    (%eax),%al
  8018e0:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8018e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018e9:	01 c2                	add    %eax,%edx
  8018eb:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8018ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018f1:	01 c8                	add    %ecx,%eax
  8018f3:	8a 00                	mov    (%eax),%al
  8018f5:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8018f7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018fd:	01 c2                	add    %eax,%edx
  8018ff:	8a 45 eb             	mov    -0x15(%ebp),%al
  801902:	88 02                	mov    %al,(%edx)
		start++ ;
  801904:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801907:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80190a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80190d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801910:	7c c4                	jl     8018d6 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801912:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801915:	8b 45 0c             	mov    0xc(%ebp),%eax
  801918:	01 d0                	add    %edx,%eax
  80191a:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80191d:	90                   	nop
  80191e:	c9                   	leave  
  80191f:	c3                   	ret    

00801920 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801920:	55                   	push   %ebp
  801921:	89 e5                	mov    %esp,%ebp
  801923:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801926:	ff 75 08             	pushl  0x8(%ebp)
  801929:	e8 c4 f9 ff ff       	call   8012f2 <strlen>
  80192e:	83 c4 04             	add    $0x4,%esp
  801931:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801934:	ff 75 0c             	pushl  0xc(%ebp)
  801937:	e8 b6 f9 ff ff       	call   8012f2 <strlen>
  80193c:	83 c4 04             	add    $0x4,%esp
  80193f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801942:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801949:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801950:	eb 17                	jmp    801969 <strcconcat+0x49>
		final[s] = str1[s] ;
  801952:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801955:	8b 45 10             	mov    0x10(%ebp),%eax
  801958:	01 c2                	add    %eax,%edx
  80195a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80195d:	8b 45 08             	mov    0x8(%ebp),%eax
  801960:	01 c8                	add    %ecx,%eax
  801962:	8a 00                	mov    (%eax),%al
  801964:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801966:	ff 45 fc             	incl   -0x4(%ebp)
  801969:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80196c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80196f:	7c e1                	jl     801952 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801971:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801978:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80197f:	eb 1f                	jmp    8019a0 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801981:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801984:	8d 50 01             	lea    0x1(%eax),%edx
  801987:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80198a:	89 c2                	mov    %eax,%edx
  80198c:	8b 45 10             	mov    0x10(%ebp),%eax
  80198f:	01 c2                	add    %eax,%edx
  801991:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801994:	8b 45 0c             	mov    0xc(%ebp),%eax
  801997:	01 c8                	add    %ecx,%eax
  801999:	8a 00                	mov    (%eax),%al
  80199b:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80199d:	ff 45 f8             	incl   -0x8(%ebp)
  8019a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019a3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8019a6:	7c d9                	jl     801981 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8019a8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8019ae:	01 d0                	add    %edx,%eax
  8019b0:	c6 00 00             	movb   $0x0,(%eax)
}
  8019b3:	90                   	nop
  8019b4:	c9                   	leave  
  8019b5:	c3                   	ret    

008019b6 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8019b6:	55                   	push   %ebp
  8019b7:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8019b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8019bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8019c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8019c5:	8b 00                	mov    (%eax),%eax
  8019c7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8019d1:	01 d0                	add    %edx,%eax
  8019d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8019d9:	eb 0c                	jmp    8019e7 <strsplit+0x31>
			*string++ = 0;
  8019db:	8b 45 08             	mov    0x8(%ebp),%eax
  8019de:	8d 50 01             	lea    0x1(%eax),%edx
  8019e1:	89 55 08             	mov    %edx,0x8(%ebp)
  8019e4:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8019e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ea:	8a 00                	mov    (%eax),%al
  8019ec:	84 c0                	test   %al,%al
  8019ee:	74 18                	je     801a08 <strsplit+0x52>
  8019f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f3:	8a 00                	mov    (%eax),%al
  8019f5:	0f be c0             	movsbl %al,%eax
  8019f8:	50                   	push   %eax
  8019f9:	ff 75 0c             	pushl  0xc(%ebp)
  8019fc:	e8 83 fa ff ff       	call   801484 <strchr>
  801a01:	83 c4 08             	add    $0x8,%esp
  801a04:	85 c0                	test   %eax,%eax
  801a06:	75 d3                	jne    8019db <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801a08:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0b:	8a 00                	mov    (%eax),%al
  801a0d:	84 c0                	test   %al,%al
  801a0f:	74 5a                	je     801a6b <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801a11:	8b 45 14             	mov    0x14(%ebp),%eax
  801a14:	8b 00                	mov    (%eax),%eax
  801a16:	83 f8 0f             	cmp    $0xf,%eax
  801a19:	75 07                	jne    801a22 <strsplit+0x6c>
		{
			return 0;
  801a1b:	b8 00 00 00 00       	mov    $0x0,%eax
  801a20:	eb 66                	jmp    801a88 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801a22:	8b 45 14             	mov    0x14(%ebp),%eax
  801a25:	8b 00                	mov    (%eax),%eax
  801a27:	8d 48 01             	lea    0x1(%eax),%ecx
  801a2a:	8b 55 14             	mov    0x14(%ebp),%edx
  801a2d:	89 0a                	mov    %ecx,(%edx)
  801a2f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a36:	8b 45 10             	mov    0x10(%ebp),%eax
  801a39:	01 c2                	add    %eax,%edx
  801a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3e:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a40:	eb 03                	jmp    801a45 <strsplit+0x8f>
			string++;
  801a42:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a45:	8b 45 08             	mov    0x8(%ebp),%eax
  801a48:	8a 00                	mov    (%eax),%al
  801a4a:	84 c0                	test   %al,%al
  801a4c:	74 8b                	je     8019d9 <strsplit+0x23>
  801a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a51:	8a 00                	mov    (%eax),%al
  801a53:	0f be c0             	movsbl %al,%eax
  801a56:	50                   	push   %eax
  801a57:	ff 75 0c             	pushl  0xc(%ebp)
  801a5a:	e8 25 fa ff ff       	call   801484 <strchr>
  801a5f:	83 c4 08             	add    $0x8,%esp
  801a62:	85 c0                	test   %eax,%eax
  801a64:	74 dc                	je     801a42 <strsplit+0x8c>
			string++;
	}
  801a66:	e9 6e ff ff ff       	jmp    8019d9 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801a6b:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801a6c:	8b 45 14             	mov    0x14(%ebp),%eax
  801a6f:	8b 00                	mov    (%eax),%eax
  801a71:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a78:	8b 45 10             	mov    0x10(%ebp),%eax
  801a7b:	01 d0                	add    %edx,%eax
  801a7d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801a83:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801a88:	c9                   	leave  
  801a89:	c3                   	ret    

00801a8a <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801a8a:	55                   	push   %ebp
  801a8b:	89 e5                	mov    %esp,%ebp
  801a8d:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801a90:	8b 45 08             	mov    0x8(%ebp),%eax
  801a93:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801a96:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801a9d:	eb 4a                	jmp    801ae9 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801a9f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa5:	01 c2                	add    %eax,%edx
  801aa7:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801aaa:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aad:	01 c8                	add    %ecx,%eax
  801aaf:	8a 00                	mov    (%eax),%al
  801ab1:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801ab3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ab6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ab9:	01 d0                	add    %edx,%eax
  801abb:	8a 00                	mov    (%eax),%al
  801abd:	3c 40                	cmp    $0x40,%al
  801abf:	7e 25                	jle    801ae6 <str2lower+0x5c>
  801ac1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ac4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ac7:	01 d0                	add    %edx,%eax
  801ac9:	8a 00                	mov    (%eax),%al
  801acb:	3c 5a                	cmp    $0x5a,%al
  801acd:	7f 17                	jg     801ae6 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801acf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad5:	01 d0                	add    %edx,%eax
  801ad7:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801ada:	8b 55 08             	mov    0x8(%ebp),%edx
  801add:	01 ca                	add    %ecx,%edx
  801adf:	8a 12                	mov    (%edx),%dl
  801ae1:	83 c2 20             	add    $0x20,%edx
  801ae4:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801ae6:	ff 45 fc             	incl   -0x4(%ebp)
  801ae9:	ff 75 0c             	pushl  0xc(%ebp)
  801aec:	e8 01 f8 ff ff       	call   8012f2 <strlen>
  801af1:	83 c4 04             	add    $0x4,%esp
  801af4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801af7:	7f a6                	jg     801a9f <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801af9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801afc:	c9                   	leave  
  801afd:	c3                   	ret    

00801afe <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801afe:	55                   	push   %ebp
  801aff:	89 e5                	mov    %esp,%ebp
  801b01:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801b04:	a1 08 40 80 00       	mov    0x804008,%eax
  801b09:	85 c0                	test   %eax,%eax
  801b0b:	74 42                	je     801b4f <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801b0d:	83 ec 08             	sub    $0x8,%esp
  801b10:	68 00 00 00 82       	push   $0x82000000
  801b15:	68 00 00 00 80       	push   $0x80000000
  801b1a:	e8 8c 07 00 00       	call   8022ab <initialize_dynamic_allocator>
  801b1f:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801b22:	e8 e7 05 00 00       	call   80210e <sys_get_uheap_strategy>
  801b27:	a3 60 c0 81 00       	mov    %eax,0x81c060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801b2c:	a1 40 40 80 00       	mov    0x804040,%eax
  801b31:	05 00 10 00 00       	add    $0x1000,%eax
  801b36:	a3 10 c1 81 00       	mov    %eax,0x81c110
		uheapPageAllocBreak = uheapPageAllocStart;
  801b3b:	a1 10 c1 81 00       	mov    0x81c110,%eax
  801b40:	a3 68 c0 81 00       	mov    %eax,0x81c068

		__firstTimeFlag = 0;
  801b45:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  801b4c:	00 00 00 
	}
}
  801b4f:	90                   	nop
  801b50:	c9                   	leave  
  801b51:	c3                   	ret    

00801b52 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801b52:	55                   	push   %ebp
  801b53:	89 e5                	mov    %esp,%ebp
  801b55:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801b58:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b61:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801b66:	83 ec 08             	sub    $0x8,%esp
  801b69:	68 06 04 00 00       	push   $0x406
  801b6e:	50                   	push   %eax
  801b6f:	e8 e4 01 00 00       	call   801d58 <__sys_allocate_page>
  801b74:	83 c4 10             	add    $0x10,%esp
  801b77:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801b7a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801b7e:	79 14                	jns    801b94 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801b80:	83 ec 04             	sub    $0x4,%esp
  801b83:	68 fc 2d 80 00       	push   $0x802dfc
  801b88:	6a 1f                	push   $0x1f
  801b8a:	68 38 2e 80 00       	push   $0x802e38
  801b8f:	e8 af eb ff ff       	call   800743 <_panic>
	return 0;
  801b94:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b99:	c9                   	leave  
  801b9a:	c3                   	ret    

00801b9b <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801b9b:	55                   	push   %ebp
  801b9c:	89 e5                	mov    %esp,%ebp
  801b9e:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ba7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801baa:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801baf:	83 ec 0c             	sub    $0xc,%esp
  801bb2:	50                   	push   %eax
  801bb3:	e8 e7 01 00 00       	call   801d9f <__sys_unmap_frame>
  801bb8:	83 c4 10             	add    $0x10,%esp
  801bbb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801bbe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801bc2:	79 14                	jns    801bd8 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801bc4:	83 ec 04             	sub    $0x4,%esp
  801bc7:	68 44 2e 80 00       	push   $0x802e44
  801bcc:	6a 2a                	push   $0x2a
  801bce:	68 38 2e 80 00       	push   $0x802e38
  801bd3:	e8 6b eb ff ff       	call   800743 <_panic>
}
  801bd8:	90                   	nop
  801bd9:	c9                   	leave  
  801bda:	c3                   	ret    

00801bdb <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801bdb:	55                   	push   %ebp
  801bdc:	89 e5                	mov    %esp,%ebp
  801bde:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801be1:	e8 18 ff ff ff       	call   801afe <uheap_init>
	if (size == 0) return NULL ;
  801be6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801bea:	75 07                	jne    801bf3 <malloc+0x18>
  801bec:	b8 00 00 00 00       	mov    $0x0,%eax
  801bf1:	eb 14                	jmp    801c07 <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  801bf3:	83 ec 04             	sub    $0x4,%esp
  801bf6:	68 84 2e 80 00       	push   $0x802e84
  801bfb:	6a 3e                	push   $0x3e
  801bfd:	68 38 2e 80 00       	push   $0x802e38
  801c02:	e8 3c eb ff ff       	call   800743 <_panic>
}
  801c07:	c9                   	leave  
  801c08:	c3                   	ret    

00801c09 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801c09:	55                   	push   %ebp
  801c0a:	89 e5                	mov    %esp,%ebp
  801c0c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  801c0f:	83 ec 04             	sub    $0x4,%esp
  801c12:	68 ac 2e 80 00       	push   $0x802eac
  801c17:	6a 49                	push   $0x49
  801c19:	68 38 2e 80 00       	push   $0x802e38
  801c1e:	e8 20 eb ff ff       	call   800743 <_panic>

00801c23 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801c23:	55                   	push   %ebp
  801c24:	89 e5                	mov    %esp,%ebp
  801c26:	83 ec 18             	sub    $0x18,%esp
  801c29:	8b 45 10             	mov    0x10(%ebp),%eax
  801c2c:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801c2f:	e8 ca fe ff ff       	call   801afe <uheap_init>
	if (size == 0) return NULL ;
  801c34:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801c38:	75 07                	jne    801c41 <smalloc+0x1e>
  801c3a:	b8 00 00 00 00       	mov    $0x0,%eax
  801c3f:	eb 14                	jmp    801c55 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  801c41:	83 ec 04             	sub    $0x4,%esp
  801c44:	68 d0 2e 80 00       	push   $0x802ed0
  801c49:	6a 5a                	push   $0x5a
  801c4b:	68 38 2e 80 00       	push   $0x802e38
  801c50:	e8 ee ea ff ff       	call   800743 <_panic>
}
  801c55:	c9                   	leave  
  801c56:	c3                   	ret    

00801c57 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801c57:	55                   	push   %ebp
  801c58:	89 e5                	mov    %esp,%ebp
  801c5a:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801c5d:	e8 9c fe ff ff       	call   801afe <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  801c62:	83 ec 04             	sub    $0x4,%esp
  801c65:	68 f8 2e 80 00       	push   $0x802ef8
  801c6a:	6a 6a                	push   $0x6a
  801c6c:	68 38 2e 80 00       	push   $0x802e38
  801c71:	e8 cd ea ff ff       	call   800743 <_panic>

00801c76 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801c76:	55                   	push   %ebp
  801c77:	89 e5                	mov    %esp,%ebp
  801c79:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801c7c:	e8 7d fe ff ff       	call   801afe <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  801c81:	83 ec 04             	sub    $0x4,%esp
  801c84:	68 1c 2f 80 00       	push   $0x802f1c
  801c89:	68 88 00 00 00       	push   $0x88
  801c8e:	68 38 2e 80 00       	push   $0x802e38
  801c93:	e8 ab ea ff ff       	call   800743 <_panic>

00801c98 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  801c98:	55                   	push   %ebp
  801c99:	89 e5                	mov    %esp,%ebp
  801c9b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  801c9e:	83 ec 04             	sub    $0x4,%esp
  801ca1:	68 44 2f 80 00       	push   $0x802f44
  801ca6:	68 9b 00 00 00       	push   $0x9b
  801cab:	68 38 2e 80 00       	push   $0x802e38
  801cb0:	e8 8e ea ff ff       	call   800743 <_panic>

00801cb5 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801cb5:	55                   	push   %ebp
  801cb6:	89 e5                	mov    %esp,%ebp
  801cb8:	57                   	push   %edi
  801cb9:	56                   	push   %esi
  801cba:	53                   	push   %ebx
  801cbb:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cc4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cc7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cca:	8b 7d 18             	mov    0x18(%ebp),%edi
  801ccd:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801cd0:	cd 30                	int    $0x30
  801cd2:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801cd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801cd8:	83 c4 10             	add    $0x10,%esp
  801cdb:	5b                   	pop    %ebx
  801cdc:	5e                   	pop    %esi
  801cdd:	5f                   	pop    %edi
  801cde:	5d                   	pop    %ebp
  801cdf:	c3                   	ret    

00801ce0 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801ce0:	55                   	push   %ebp
  801ce1:	89 e5                	mov    %esp,%ebp
  801ce3:	83 ec 04             	sub    $0x4,%esp
  801ce6:	8b 45 10             	mov    0x10(%ebp),%eax
  801ce9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801cec:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801cef:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf6:	6a 00                	push   $0x0
  801cf8:	51                   	push   %ecx
  801cf9:	52                   	push   %edx
  801cfa:	ff 75 0c             	pushl  0xc(%ebp)
  801cfd:	50                   	push   %eax
  801cfe:	6a 00                	push   $0x0
  801d00:	e8 b0 ff ff ff       	call   801cb5 <syscall>
  801d05:	83 c4 18             	add    $0x18,%esp
}
  801d08:	90                   	nop
  801d09:	c9                   	leave  
  801d0a:	c3                   	ret    

00801d0b <sys_cgetc>:

int
sys_cgetc(void)
{
  801d0b:	55                   	push   %ebp
  801d0c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801d0e:	6a 00                	push   $0x0
  801d10:	6a 00                	push   $0x0
  801d12:	6a 00                	push   $0x0
  801d14:	6a 00                	push   $0x0
  801d16:	6a 00                	push   $0x0
  801d18:	6a 02                	push   $0x2
  801d1a:	e8 96 ff ff ff       	call   801cb5 <syscall>
  801d1f:	83 c4 18             	add    $0x18,%esp
}
  801d22:	c9                   	leave  
  801d23:	c3                   	ret    

00801d24 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801d24:	55                   	push   %ebp
  801d25:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801d27:	6a 00                	push   $0x0
  801d29:	6a 00                	push   $0x0
  801d2b:	6a 00                	push   $0x0
  801d2d:	6a 00                	push   $0x0
  801d2f:	6a 00                	push   $0x0
  801d31:	6a 03                	push   $0x3
  801d33:	e8 7d ff ff ff       	call   801cb5 <syscall>
  801d38:	83 c4 18             	add    $0x18,%esp
}
  801d3b:	90                   	nop
  801d3c:	c9                   	leave  
  801d3d:	c3                   	ret    

00801d3e <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801d3e:	55                   	push   %ebp
  801d3f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801d41:	6a 00                	push   $0x0
  801d43:	6a 00                	push   $0x0
  801d45:	6a 00                	push   $0x0
  801d47:	6a 00                	push   $0x0
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 04                	push   $0x4
  801d4d:	e8 63 ff ff ff       	call   801cb5 <syscall>
  801d52:	83 c4 18             	add    $0x18,%esp
}
  801d55:	90                   	nop
  801d56:	c9                   	leave  
  801d57:	c3                   	ret    

00801d58 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801d58:	55                   	push   %ebp
  801d59:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801d5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d61:	6a 00                	push   $0x0
  801d63:	6a 00                	push   $0x0
  801d65:	6a 00                	push   $0x0
  801d67:	52                   	push   %edx
  801d68:	50                   	push   %eax
  801d69:	6a 08                	push   $0x8
  801d6b:	e8 45 ff ff ff       	call   801cb5 <syscall>
  801d70:	83 c4 18             	add    $0x18,%esp
}
  801d73:	c9                   	leave  
  801d74:	c3                   	ret    

00801d75 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801d75:	55                   	push   %ebp
  801d76:	89 e5                	mov    %esp,%ebp
  801d78:	56                   	push   %esi
  801d79:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801d7a:	8b 75 18             	mov    0x18(%ebp),%esi
  801d7d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d80:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d83:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d86:	8b 45 08             	mov    0x8(%ebp),%eax
  801d89:	56                   	push   %esi
  801d8a:	53                   	push   %ebx
  801d8b:	51                   	push   %ecx
  801d8c:	52                   	push   %edx
  801d8d:	50                   	push   %eax
  801d8e:	6a 09                	push   $0x9
  801d90:	e8 20 ff ff ff       	call   801cb5 <syscall>
  801d95:	83 c4 18             	add    $0x18,%esp
}
  801d98:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d9b:	5b                   	pop    %ebx
  801d9c:	5e                   	pop    %esi
  801d9d:	5d                   	pop    %ebp
  801d9e:	c3                   	ret    

00801d9f <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801d9f:	55                   	push   %ebp
  801da0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801da2:	6a 00                	push   $0x0
  801da4:	6a 00                	push   $0x0
  801da6:	6a 00                	push   $0x0
  801da8:	6a 00                	push   $0x0
  801daa:	ff 75 08             	pushl  0x8(%ebp)
  801dad:	6a 0a                	push   $0xa
  801daf:	e8 01 ff ff ff       	call   801cb5 <syscall>
  801db4:	83 c4 18             	add    $0x18,%esp
}
  801db7:	c9                   	leave  
  801db8:	c3                   	ret    

00801db9 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801db9:	55                   	push   %ebp
  801dba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801dbc:	6a 00                	push   $0x0
  801dbe:	6a 00                	push   $0x0
  801dc0:	6a 00                	push   $0x0
  801dc2:	ff 75 0c             	pushl  0xc(%ebp)
  801dc5:	ff 75 08             	pushl  0x8(%ebp)
  801dc8:	6a 0b                	push   $0xb
  801dca:	e8 e6 fe ff ff       	call   801cb5 <syscall>
  801dcf:	83 c4 18             	add    $0x18,%esp
}
  801dd2:	c9                   	leave  
  801dd3:	c3                   	ret    

00801dd4 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801dd4:	55                   	push   %ebp
  801dd5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801dd7:	6a 00                	push   $0x0
  801dd9:	6a 00                	push   $0x0
  801ddb:	6a 00                	push   $0x0
  801ddd:	6a 00                	push   $0x0
  801ddf:	6a 00                	push   $0x0
  801de1:	6a 0c                	push   $0xc
  801de3:	e8 cd fe ff ff       	call   801cb5 <syscall>
  801de8:	83 c4 18             	add    $0x18,%esp
}
  801deb:	c9                   	leave  
  801dec:	c3                   	ret    

00801ded <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801ded:	55                   	push   %ebp
  801dee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801df0:	6a 00                	push   $0x0
  801df2:	6a 00                	push   $0x0
  801df4:	6a 00                	push   $0x0
  801df6:	6a 00                	push   $0x0
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 0d                	push   $0xd
  801dfc:	e8 b4 fe ff ff       	call   801cb5 <syscall>
  801e01:	83 c4 18             	add    $0x18,%esp
}
  801e04:	c9                   	leave  
  801e05:	c3                   	ret    

00801e06 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801e06:	55                   	push   %ebp
  801e07:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801e09:	6a 00                	push   $0x0
  801e0b:	6a 00                	push   $0x0
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 00                	push   $0x0
  801e13:	6a 0e                	push   $0xe
  801e15:	e8 9b fe ff ff       	call   801cb5 <syscall>
  801e1a:	83 c4 18             	add    $0x18,%esp
}
  801e1d:	c9                   	leave  
  801e1e:	c3                   	ret    

00801e1f <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801e1f:	55                   	push   %ebp
  801e20:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801e22:	6a 00                	push   $0x0
  801e24:	6a 00                	push   $0x0
  801e26:	6a 00                	push   $0x0
  801e28:	6a 00                	push   $0x0
  801e2a:	6a 00                	push   $0x0
  801e2c:	6a 0f                	push   $0xf
  801e2e:	e8 82 fe ff ff       	call   801cb5 <syscall>
  801e33:	83 c4 18             	add    $0x18,%esp
}
  801e36:	c9                   	leave  
  801e37:	c3                   	ret    

00801e38 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801e38:	55                   	push   %ebp
  801e39:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801e3b:	6a 00                	push   $0x0
  801e3d:	6a 00                	push   $0x0
  801e3f:	6a 00                	push   $0x0
  801e41:	6a 00                	push   $0x0
  801e43:	ff 75 08             	pushl  0x8(%ebp)
  801e46:	6a 10                	push   $0x10
  801e48:	e8 68 fe ff ff       	call   801cb5 <syscall>
  801e4d:	83 c4 18             	add    $0x18,%esp
}
  801e50:	c9                   	leave  
  801e51:	c3                   	ret    

00801e52 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801e52:	55                   	push   %ebp
  801e53:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801e55:	6a 00                	push   $0x0
  801e57:	6a 00                	push   $0x0
  801e59:	6a 00                	push   $0x0
  801e5b:	6a 00                	push   $0x0
  801e5d:	6a 00                	push   $0x0
  801e5f:	6a 11                	push   $0x11
  801e61:	e8 4f fe ff ff       	call   801cb5 <syscall>
  801e66:	83 c4 18             	add    $0x18,%esp
}
  801e69:	90                   	nop
  801e6a:	c9                   	leave  
  801e6b:	c3                   	ret    

00801e6c <sys_cputc>:

void
sys_cputc(const char c)
{
  801e6c:	55                   	push   %ebp
  801e6d:	89 e5                	mov    %esp,%ebp
  801e6f:	83 ec 04             	sub    $0x4,%esp
  801e72:	8b 45 08             	mov    0x8(%ebp),%eax
  801e75:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801e78:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e7c:	6a 00                	push   $0x0
  801e7e:	6a 00                	push   $0x0
  801e80:	6a 00                	push   $0x0
  801e82:	6a 00                	push   $0x0
  801e84:	50                   	push   %eax
  801e85:	6a 01                	push   $0x1
  801e87:	e8 29 fe ff ff       	call   801cb5 <syscall>
  801e8c:	83 c4 18             	add    $0x18,%esp
}
  801e8f:	90                   	nop
  801e90:	c9                   	leave  
  801e91:	c3                   	ret    

00801e92 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801e92:	55                   	push   %ebp
  801e93:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801e95:	6a 00                	push   $0x0
  801e97:	6a 00                	push   $0x0
  801e99:	6a 00                	push   $0x0
  801e9b:	6a 00                	push   $0x0
  801e9d:	6a 00                	push   $0x0
  801e9f:	6a 14                	push   $0x14
  801ea1:	e8 0f fe ff ff       	call   801cb5 <syscall>
  801ea6:	83 c4 18             	add    $0x18,%esp
}
  801ea9:	90                   	nop
  801eaa:	c9                   	leave  
  801eab:	c3                   	ret    

00801eac <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801eac:	55                   	push   %ebp
  801ead:	89 e5                	mov    %esp,%ebp
  801eaf:	83 ec 04             	sub    $0x4,%esp
  801eb2:	8b 45 10             	mov    0x10(%ebp),%eax
  801eb5:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801eb8:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ebb:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ebf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec2:	6a 00                	push   $0x0
  801ec4:	51                   	push   %ecx
  801ec5:	52                   	push   %edx
  801ec6:	ff 75 0c             	pushl  0xc(%ebp)
  801ec9:	50                   	push   %eax
  801eca:	6a 15                	push   $0x15
  801ecc:	e8 e4 fd ff ff       	call   801cb5 <syscall>
  801ed1:	83 c4 18             	add    $0x18,%esp
}
  801ed4:	c9                   	leave  
  801ed5:	c3                   	ret    

00801ed6 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801ed6:	55                   	push   %ebp
  801ed7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801ed9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801edc:	8b 45 08             	mov    0x8(%ebp),%eax
  801edf:	6a 00                	push   $0x0
  801ee1:	6a 00                	push   $0x0
  801ee3:	6a 00                	push   $0x0
  801ee5:	52                   	push   %edx
  801ee6:	50                   	push   %eax
  801ee7:	6a 16                	push   $0x16
  801ee9:	e8 c7 fd ff ff       	call   801cb5 <syscall>
  801eee:	83 c4 18             	add    $0x18,%esp
}
  801ef1:	c9                   	leave  
  801ef2:	c3                   	ret    

00801ef3 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801ef3:	55                   	push   %ebp
  801ef4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801ef6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ef9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801efc:	8b 45 08             	mov    0x8(%ebp),%eax
  801eff:	6a 00                	push   $0x0
  801f01:	6a 00                	push   $0x0
  801f03:	51                   	push   %ecx
  801f04:	52                   	push   %edx
  801f05:	50                   	push   %eax
  801f06:	6a 17                	push   $0x17
  801f08:	e8 a8 fd ff ff       	call   801cb5 <syscall>
  801f0d:	83 c4 18             	add    $0x18,%esp
}
  801f10:	c9                   	leave  
  801f11:	c3                   	ret    

00801f12 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801f12:	55                   	push   %ebp
  801f13:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801f15:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f18:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1b:	6a 00                	push   $0x0
  801f1d:	6a 00                	push   $0x0
  801f1f:	6a 00                	push   $0x0
  801f21:	52                   	push   %edx
  801f22:	50                   	push   %eax
  801f23:	6a 18                	push   $0x18
  801f25:	e8 8b fd ff ff       	call   801cb5 <syscall>
  801f2a:	83 c4 18             	add    $0x18,%esp
}
  801f2d:	c9                   	leave  
  801f2e:	c3                   	ret    

00801f2f <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801f2f:	55                   	push   %ebp
  801f30:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801f32:	8b 45 08             	mov    0x8(%ebp),%eax
  801f35:	6a 00                	push   $0x0
  801f37:	ff 75 14             	pushl  0x14(%ebp)
  801f3a:	ff 75 10             	pushl  0x10(%ebp)
  801f3d:	ff 75 0c             	pushl  0xc(%ebp)
  801f40:	50                   	push   %eax
  801f41:	6a 19                	push   $0x19
  801f43:	e8 6d fd ff ff       	call   801cb5 <syscall>
  801f48:	83 c4 18             	add    $0x18,%esp
}
  801f4b:	c9                   	leave  
  801f4c:	c3                   	ret    

00801f4d <sys_run_env>:

void sys_run_env(int32 envId)
{
  801f4d:	55                   	push   %ebp
  801f4e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801f50:	8b 45 08             	mov    0x8(%ebp),%eax
  801f53:	6a 00                	push   $0x0
  801f55:	6a 00                	push   $0x0
  801f57:	6a 00                	push   $0x0
  801f59:	6a 00                	push   $0x0
  801f5b:	50                   	push   %eax
  801f5c:	6a 1a                	push   $0x1a
  801f5e:	e8 52 fd ff ff       	call   801cb5 <syscall>
  801f63:	83 c4 18             	add    $0x18,%esp
}
  801f66:	90                   	nop
  801f67:	c9                   	leave  
  801f68:	c3                   	ret    

00801f69 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801f69:	55                   	push   %ebp
  801f6a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6f:	6a 00                	push   $0x0
  801f71:	6a 00                	push   $0x0
  801f73:	6a 00                	push   $0x0
  801f75:	6a 00                	push   $0x0
  801f77:	50                   	push   %eax
  801f78:	6a 1b                	push   $0x1b
  801f7a:	e8 36 fd ff ff       	call   801cb5 <syscall>
  801f7f:	83 c4 18             	add    $0x18,%esp
}
  801f82:	c9                   	leave  
  801f83:	c3                   	ret    

00801f84 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801f84:	55                   	push   %ebp
  801f85:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801f87:	6a 00                	push   $0x0
  801f89:	6a 00                	push   $0x0
  801f8b:	6a 00                	push   $0x0
  801f8d:	6a 00                	push   $0x0
  801f8f:	6a 00                	push   $0x0
  801f91:	6a 05                	push   $0x5
  801f93:	e8 1d fd ff ff       	call   801cb5 <syscall>
  801f98:	83 c4 18             	add    $0x18,%esp
}
  801f9b:	c9                   	leave  
  801f9c:	c3                   	ret    

00801f9d <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801f9d:	55                   	push   %ebp
  801f9e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801fa0:	6a 00                	push   $0x0
  801fa2:	6a 00                	push   $0x0
  801fa4:	6a 00                	push   $0x0
  801fa6:	6a 00                	push   $0x0
  801fa8:	6a 00                	push   $0x0
  801faa:	6a 06                	push   $0x6
  801fac:	e8 04 fd ff ff       	call   801cb5 <syscall>
  801fb1:	83 c4 18             	add    $0x18,%esp
}
  801fb4:	c9                   	leave  
  801fb5:	c3                   	ret    

00801fb6 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801fb6:	55                   	push   %ebp
  801fb7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801fb9:	6a 00                	push   $0x0
  801fbb:	6a 00                	push   $0x0
  801fbd:	6a 00                	push   $0x0
  801fbf:	6a 00                	push   $0x0
  801fc1:	6a 00                	push   $0x0
  801fc3:	6a 07                	push   $0x7
  801fc5:	e8 eb fc ff ff       	call   801cb5 <syscall>
  801fca:	83 c4 18             	add    $0x18,%esp
}
  801fcd:	c9                   	leave  
  801fce:	c3                   	ret    

00801fcf <sys_exit_env>:


void sys_exit_env(void)
{
  801fcf:	55                   	push   %ebp
  801fd0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801fd2:	6a 00                	push   $0x0
  801fd4:	6a 00                	push   $0x0
  801fd6:	6a 00                	push   $0x0
  801fd8:	6a 00                	push   $0x0
  801fda:	6a 00                	push   $0x0
  801fdc:	6a 1c                	push   $0x1c
  801fde:	e8 d2 fc ff ff       	call   801cb5 <syscall>
  801fe3:	83 c4 18             	add    $0x18,%esp
}
  801fe6:	90                   	nop
  801fe7:	c9                   	leave  
  801fe8:	c3                   	ret    

00801fe9 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801fe9:	55                   	push   %ebp
  801fea:	89 e5                	mov    %esp,%ebp
  801fec:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801fef:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ff2:	8d 50 04             	lea    0x4(%eax),%edx
  801ff5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ff8:	6a 00                	push   $0x0
  801ffa:	6a 00                	push   $0x0
  801ffc:	6a 00                	push   $0x0
  801ffe:	52                   	push   %edx
  801fff:	50                   	push   %eax
  802000:	6a 1d                	push   $0x1d
  802002:	e8 ae fc ff ff       	call   801cb5 <syscall>
  802007:	83 c4 18             	add    $0x18,%esp
	return result;
  80200a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80200d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802010:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802013:	89 01                	mov    %eax,(%ecx)
  802015:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802018:	8b 45 08             	mov    0x8(%ebp),%eax
  80201b:	c9                   	leave  
  80201c:	c2 04 00             	ret    $0x4

0080201f <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80201f:	55                   	push   %ebp
  802020:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802022:	6a 00                	push   $0x0
  802024:	6a 00                	push   $0x0
  802026:	ff 75 10             	pushl  0x10(%ebp)
  802029:	ff 75 0c             	pushl  0xc(%ebp)
  80202c:	ff 75 08             	pushl  0x8(%ebp)
  80202f:	6a 13                	push   $0x13
  802031:	e8 7f fc ff ff       	call   801cb5 <syscall>
  802036:	83 c4 18             	add    $0x18,%esp
	return ;
  802039:	90                   	nop
}
  80203a:	c9                   	leave  
  80203b:	c3                   	ret    

0080203c <sys_rcr2>:
uint32 sys_rcr2()
{
  80203c:	55                   	push   %ebp
  80203d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80203f:	6a 00                	push   $0x0
  802041:	6a 00                	push   $0x0
  802043:	6a 00                	push   $0x0
  802045:	6a 00                	push   $0x0
  802047:	6a 00                	push   $0x0
  802049:	6a 1e                	push   $0x1e
  80204b:	e8 65 fc ff ff       	call   801cb5 <syscall>
  802050:	83 c4 18             	add    $0x18,%esp
}
  802053:	c9                   	leave  
  802054:	c3                   	ret    

00802055 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802055:	55                   	push   %ebp
  802056:	89 e5                	mov    %esp,%ebp
  802058:	83 ec 04             	sub    $0x4,%esp
  80205b:	8b 45 08             	mov    0x8(%ebp),%eax
  80205e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802061:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802065:	6a 00                	push   $0x0
  802067:	6a 00                	push   $0x0
  802069:	6a 00                	push   $0x0
  80206b:	6a 00                	push   $0x0
  80206d:	50                   	push   %eax
  80206e:	6a 1f                	push   $0x1f
  802070:	e8 40 fc ff ff       	call   801cb5 <syscall>
  802075:	83 c4 18             	add    $0x18,%esp
	return ;
  802078:	90                   	nop
}
  802079:	c9                   	leave  
  80207a:	c3                   	ret    

0080207b <rsttst>:
void rsttst()
{
  80207b:	55                   	push   %ebp
  80207c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80207e:	6a 00                	push   $0x0
  802080:	6a 00                	push   $0x0
  802082:	6a 00                	push   $0x0
  802084:	6a 00                	push   $0x0
  802086:	6a 00                	push   $0x0
  802088:	6a 21                	push   $0x21
  80208a:	e8 26 fc ff ff       	call   801cb5 <syscall>
  80208f:	83 c4 18             	add    $0x18,%esp
	return ;
  802092:	90                   	nop
}
  802093:	c9                   	leave  
  802094:	c3                   	ret    

00802095 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802095:	55                   	push   %ebp
  802096:	89 e5                	mov    %esp,%ebp
  802098:	83 ec 04             	sub    $0x4,%esp
  80209b:	8b 45 14             	mov    0x14(%ebp),%eax
  80209e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8020a1:	8b 55 18             	mov    0x18(%ebp),%edx
  8020a4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8020a8:	52                   	push   %edx
  8020a9:	50                   	push   %eax
  8020aa:	ff 75 10             	pushl  0x10(%ebp)
  8020ad:	ff 75 0c             	pushl  0xc(%ebp)
  8020b0:	ff 75 08             	pushl  0x8(%ebp)
  8020b3:	6a 20                	push   $0x20
  8020b5:	e8 fb fb ff ff       	call   801cb5 <syscall>
  8020ba:	83 c4 18             	add    $0x18,%esp
	return ;
  8020bd:	90                   	nop
}
  8020be:	c9                   	leave  
  8020bf:	c3                   	ret    

008020c0 <chktst>:
void chktst(uint32 n)
{
  8020c0:	55                   	push   %ebp
  8020c1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8020c3:	6a 00                	push   $0x0
  8020c5:	6a 00                	push   $0x0
  8020c7:	6a 00                	push   $0x0
  8020c9:	6a 00                	push   $0x0
  8020cb:	ff 75 08             	pushl  0x8(%ebp)
  8020ce:	6a 22                	push   $0x22
  8020d0:	e8 e0 fb ff ff       	call   801cb5 <syscall>
  8020d5:	83 c4 18             	add    $0x18,%esp
	return ;
  8020d8:	90                   	nop
}
  8020d9:	c9                   	leave  
  8020da:	c3                   	ret    

008020db <inctst>:

void inctst()
{
  8020db:	55                   	push   %ebp
  8020dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8020de:	6a 00                	push   $0x0
  8020e0:	6a 00                	push   $0x0
  8020e2:	6a 00                	push   $0x0
  8020e4:	6a 00                	push   $0x0
  8020e6:	6a 00                	push   $0x0
  8020e8:	6a 23                	push   $0x23
  8020ea:	e8 c6 fb ff ff       	call   801cb5 <syscall>
  8020ef:	83 c4 18             	add    $0x18,%esp
	return ;
  8020f2:	90                   	nop
}
  8020f3:	c9                   	leave  
  8020f4:	c3                   	ret    

008020f5 <gettst>:
uint32 gettst()
{
  8020f5:	55                   	push   %ebp
  8020f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8020f8:	6a 00                	push   $0x0
  8020fa:	6a 00                	push   $0x0
  8020fc:	6a 00                	push   $0x0
  8020fe:	6a 00                	push   $0x0
  802100:	6a 00                	push   $0x0
  802102:	6a 24                	push   $0x24
  802104:	e8 ac fb ff ff       	call   801cb5 <syscall>
  802109:	83 c4 18             	add    $0x18,%esp
}
  80210c:	c9                   	leave  
  80210d:	c3                   	ret    

0080210e <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  80210e:	55                   	push   %ebp
  80210f:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802111:	6a 00                	push   $0x0
  802113:	6a 00                	push   $0x0
  802115:	6a 00                	push   $0x0
  802117:	6a 00                	push   $0x0
  802119:	6a 00                	push   $0x0
  80211b:	6a 25                	push   $0x25
  80211d:	e8 93 fb ff ff       	call   801cb5 <syscall>
  802122:	83 c4 18             	add    $0x18,%esp
  802125:	a3 60 c0 81 00       	mov    %eax,0x81c060
	return uheapPlaceStrategy ;
  80212a:	a1 60 c0 81 00       	mov    0x81c060,%eax
}
  80212f:	c9                   	leave  
  802130:	c3                   	ret    

00802131 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802131:	55                   	push   %ebp
  802132:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  802134:	8b 45 08             	mov    0x8(%ebp),%eax
  802137:	a3 60 c0 81 00       	mov    %eax,0x81c060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80213c:	6a 00                	push   $0x0
  80213e:	6a 00                	push   $0x0
  802140:	6a 00                	push   $0x0
  802142:	6a 00                	push   $0x0
  802144:	ff 75 08             	pushl  0x8(%ebp)
  802147:	6a 26                	push   $0x26
  802149:	e8 67 fb ff ff       	call   801cb5 <syscall>
  80214e:	83 c4 18             	add    $0x18,%esp
	return ;
  802151:	90                   	nop
}
  802152:	c9                   	leave  
  802153:	c3                   	ret    

00802154 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802154:	55                   	push   %ebp
  802155:	89 e5                	mov    %esp,%ebp
  802157:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802158:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80215b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80215e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802161:	8b 45 08             	mov    0x8(%ebp),%eax
  802164:	6a 00                	push   $0x0
  802166:	53                   	push   %ebx
  802167:	51                   	push   %ecx
  802168:	52                   	push   %edx
  802169:	50                   	push   %eax
  80216a:	6a 27                	push   $0x27
  80216c:	e8 44 fb ff ff       	call   801cb5 <syscall>
  802171:	83 c4 18             	add    $0x18,%esp
}
  802174:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802177:	c9                   	leave  
  802178:	c3                   	ret    

00802179 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802179:	55                   	push   %ebp
  80217a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80217c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80217f:	8b 45 08             	mov    0x8(%ebp),%eax
  802182:	6a 00                	push   $0x0
  802184:	6a 00                	push   $0x0
  802186:	6a 00                	push   $0x0
  802188:	52                   	push   %edx
  802189:	50                   	push   %eax
  80218a:	6a 28                	push   $0x28
  80218c:	e8 24 fb ff ff       	call   801cb5 <syscall>
  802191:	83 c4 18             	add    $0x18,%esp
}
  802194:	c9                   	leave  
  802195:	c3                   	ret    

00802196 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802196:	55                   	push   %ebp
  802197:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802199:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80219c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80219f:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a2:	6a 00                	push   $0x0
  8021a4:	51                   	push   %ecx
  8021a5:	ff 75 10             	pushl  0x10(%ebp)
  8021a8:	52                   	push   %edx
  8021a9:	50                   	push   %eax
  8021aa:	6a 29                	push   $0x29
  8021ac:	e8 04 fb ff ff       	call   801cb5 <syscall>
  8021b1:	83 c4 18             	add    $0x18,%esp
}
  8021b4:	c9                   	leave  
  8021b5:	c3                   	ret    

008021b6 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8021b6:	55                   	push   %ebp
  8021b7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8021b9:	6a 00                	push   $0x0
  8021bb:	6a 00                	push   $0x0
  8021bd:	ff 75 10             	pushl  0x10(%ebp)
  8021c0:	ff 75 0c             	pushl  0xc(%ebp)
  8021c3:	ff 75 08             	pushl  0x8(%ebp)
  8021c6:	6a 12                	push   $0x12
  8021c8:	e8 e8 fa ff ff       	call   801cb5 <syscall>
  8021cd:	83 c4 18             	add    $0x18,%esp
	return ;
  8021d0:	90                   	nop
}
  8021d1:	c9                   	leave  
  8021d2:	c3                   	ret    

008021d3 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8021d3:	55                   	push   %ebp
  8021d4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8021d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021dc:	6a 00                	push   $0x0
  8021de:	6a 00                	push   $0x0
  8021e0:	6a 00                	push   $0x0
  8021e2:	52                   	push   %edx
  8021e3:	50                   	push   %eax
  8021e4:	6a 2a                	push   $0x2a
  8021e6:	e8 ca fa ff ff       	call   801cb5 <syscall>
  8021eb:	83 c4 18             	add    $0x18,%esp
	return;
  8021ee:	90                   	nop
}
  8021ef:	c9                   	leave  
  8021f0:	c3                   	ret    

008021f1 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8021f1:	55                   	push   %ebp
  8021f2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8021f4:	6a 00                	push   $0x0
  8021f6:	6a 00                	push   $0x0
  8021f8:	6a 00                	push   $0x0
  8021fa:	6a 00                	push   $0x0
  8021fc:	6a 00                	push   $0x0
  8021fe:	6a 2b                	push   $0x2b
  802200:	e8 b0 fa ff ff       	call   801cb5 <syscall>
  802205:	83 c4 18             	add    $0x18,%esp
}
  802208:	c9                   	leave  
  802209:	c3                   	ret    

0080220a <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80220a:	55                   	push   %ebp
  80220b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80220d:	6a 00                	push   $0x0
  80220f:	6a 00                	push   $0x0
  802211:	6a 00                	push   $0x0
  802213:	ff 75 0c             	pushl  0xc(%ebp)
  802216:	ff 75 08             	pushl  0x8(%ebp)
  802219:	6a 2d                	push   $0x2d
  80221b:	e8 95 fa ff ff       	call   801cb5 <syscall>
  802220:	83 c4 18             	add    $0x18,%esp
	return;
  802223:	90                   	nop
}
  802224:	c9                   	leave  
  802225:	c3                   	ret    

00802226 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802226:	55                   	push   %ebp
  802227:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802229:	6a 00                	push   $0x0
  80222b:	6a 00                	push   $0x0
  80222d:	6a 00                	push   $0x0
  80222f:	ff 75 0c             	pushl  0xc(%ebp)
  802232:	ff 75 08             	pushl  0x8(%ebp)
  802235:	6a 2c                	push   $0x2c
  802237:	e8 79 fa ff ff       	call   801cb5 <syscall>
  80223c:	83 c4 18             	add    $0x18,%esp
	return ;
  80223f:	90                   	nop
}
  802240:	c9                   	leave  
  802241:	c3                   	ret    

00802242 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  802242:	55                   	push   %ebp
  802243:	89 e5                	mov    %esp,%ebp
  802245:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  802248:	83 ec 04             	sub    $0x4,%esp
  80224b:	68 68 2f 80 00       	push   $0x802f68
  802250:	68 25 01 00 00       	push   $0x125
  802255:	68 9b 2f 80 00       	push   $0x802f9b
  80225a:	e8 e4 e4 ff ff       	call   800743 <_panic>

0080225f <to_page_va>:
//==================================================================================//
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  80225f:	55                   	push   %ebp
  802260:	89 e5                	mov    %esp,%ebp
  802262:	83 ec 10             	sub    $0x10,%esp
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  802265:	8b 45 08             	mov    0x8(%ebp),%eax
  802268:	ba 60 40 80 00       	mov    $0x804060,%edx
  80226d:	29 d0                	sub    %edx,%eax
  80226f:	c1 f8 02             	sar    $0x2,%eax
  802272:	89 c2                	mov    %eax,%edx
  802274:	89 d0                	mov    %edx,%eax
  802276:	c1 e0 02             	shl    $0x2,%eax
  802279:	01 d0                	add    %edx,%eax
  80227b:	c1 e0 02             	shl    $0x2,%eax
  80227e:	01 d0                	add    %edx,%eax
  802280:	c1 e0 02             	shl    $0x2,%eax
  802283:	01 d0                	add    %edx,%eax
  802285:	89 c1                	mov    %eax,%ecx
  802287:	c1 e1 08             	shl    $0x8,%ecx
  80228a:	01 c8                	add    %ecx,%eax
  80228c:	89 c1                	mov    %eax,%ecx
  80228e:	c1 e1 10             	shl    $0x10,%ecx
  802291:	01 c8                	add    %ecx,%eax
  802293:	01 c0                	add    %eax,%eax
  802295:	01 d0                	add    %edx,%eax
  802297:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  80229a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80229d:	c1 e0 0c             	shl    $0xc,%eax
  8022a0:	89 c2                	mov    %eax,%edx
  8022a2:	a1 64 c0 81 00       	mov    0x81c064,%eax
  8022a7:	01 d0                	add    %edx,%eax
}
  8022a9:	c9                   	leave  
  8022aa:	c3                   	ret    

008022ab <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  8022ab:	55                   	push   %ebp
  8022ac:	89 e5                	mov    %esp,%ebp
  8022ae:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  8022b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b4:	05 00 00 00 02       	add    $0x2000000,%eax
  8022b9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8022bc:	73 16                	jae    8022d4 <initialize_dynamic_allocator+0x29>
  8022be:	68 ac 2f 80 00       	push   $0x802fac
  8022c3:	68 d2 2f 80 00       	push   $0x802fd2
  8022c8:	6a 26                	push   $0x26
  8022ca:	68 e7 2f 80 00       	push   $0x802fe7
  8022cf:	e8 6f e4 ff ff       	call   800743 <_panic>
		is_initialized = 1;
  8022d4:	c7 05 28 40 80 00 01 	movl   $0x1,0x804028
  8022db:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	//Comment the following line
	panic("initialize_dynamic_allocator() Not implemented yet");
  8022de:	83 ec 04             	sub    $0x4,%esp
  8022e1:	68 00 30 80 00       	push   $0x803000
  8022e6:	6a 2e                	push   $0x2e
  8022e8:	68 e7 2f 80 00       	push   $0x802fe7
  8022ed:	e8 51 e4 ff ff       	call   800743 <_panic>

008022f2 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  8022f2:	55                   	push   %ebp
  8022f3:	89 e5                	mov    %esp,%ebp
  8022f5:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	//Comment the following line
	panic("get_block_size() Not implemented yet");
  8022f8:	83 ec 04             	sub    $0x4,%esp
  8022fb:	68 34 30 80 00       	push   $0x803034
  802300:	6a 3a                	push   $0x3a
  802302:	68 e7 2f 80 00       	push   $0x802fe7
  802307:	e8 37 e4 ff ff       	call   800743 <_panic>

0080230c <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  80230c:	55                   	push   %ebp
  80230d:	89 e5                	mov    %esp,%ebp
  80230f:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  802312:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802319:	76 16                	jbe    802331 <alloc_block+0x25>
  80231b:	68 5c 30 80 00       	push   $0x80305c
  802320:	68 d2 2f 80 00       	push   $0x802fd2
  802325:	6a 46                	push   $0x46
  802327:	68 e7 2f 80 00       	push   $0x802fe7
  80232c:	e8 12 e4 ff ff       	call   800743 <_panic>
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	panic("alloc_block() Not implemented yet");
  802331:	83 ec 04             	sub    $0x4,%esp
  802334:	68 80 30 80 00       	push   $0x803080
  802339:	6a 4d                	push   $0x4d
  80233b:	68 e7 2f 80 00       	push   $0x802fe7
  802340:	e8 fe e3 ff ff       	call   800743 <_panic>

00802345 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  802345:	55                   	push   %ebp
  802346:	89 e5                	mov    %esp,%ebp
  802348:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  80234b:	8b 55 08             	mov    0x8(%ebp),%edx
  80234e:	a1 64 c0 81 00       	mov    0x81c064,%eax
  802353:	39 c2                	cmp    %eax,%edx
  802355:	72 0c                	jb     802363 <free_block+0x1e>
  802357:	8b 55 08             	mov    0x8(%ebp),%edx
  80235a:	a1 40 40 80 00       	mov    0x804040,%eax
  80235f:	39 c2                	cmp    %eax,%edx
  802361:	72 16                	jb     802379 <free_block+0x34>
  802363:	68 a4 30 80 00       	push   $0x8030a4
  802368:	68 d2 2f 80 00       	push   $0x802fd2
  80236d:	6a 5b                	push   $0x5b
  80236f:	68 e7 2f 80 00       	push   $0x802fe7
  802374:	e8 ca e3 ff ff       	call   800743 <_panic>
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	panic("free_block() Not implemented yet");
  802379:	83 ec 04             	sub    $0x4,%esp
  80237c:	68 dc 30 80 00       	push   $0x8030dc
  802381:	6a 63                	push   $0x63
  802383:	68 e7 2f 80 00       	push   $0x802fe7
  802388:	e8 b6 e3 ff ff       	call   800743 <_panic>

0080238d <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  80238d:	55                   	push   %ebp
  80238e:	89 e5                	mov    %esp,%ebp
  802390:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  802393:	83 ec 04             	sub    $0x4,%esp
  802396:	68 00 31 80 00       	push   $0x803100
  80239b:	6a 72                	push   $0x72
  80239d:	68 e7 2f 80 00       	push   $0x802fe7
  8023a2:	e8 9c e3 ff ff       	call   800743 <_panic>
  8023a7:	90                   	nop

008023a8 <__udivdi3>:
  8023a8:	55                   	push   %ebp
  8023a9:	57                   	push   %edi
  8023aa:	56                   	push   %esi
  8023ab:	53                   	push   %ebx
  8023ac:	83 ec 1c             	sub    $0x1c,%esp
  8023af:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8023b3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8023b7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8023bb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8023bf:	89 ca                	mov    %ecx,%edx
  8023c1:	89 f8                	mov    %edi,%eax
  8023c3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8023c7:	85 f6                	test   %esi,%esi
  8023c9:	75 2d                	jne    8023f8 <__udivdi3+0x50>
  8023cb:	39 cf                	cmp    %ecx,%edi
  8023cd:	77 65                	ja     802434 <__udivdi3+0x8c>
  8023cf:	89 fd                	mov    %edi,%ebp
  8023d1:	85 ff                	test   %edi,%edi
  8023d3:	75 0b                	jne    8023e0 <__udivdi3+0x38>
  8023d5:	b8 01 00 00 00       	mov    $0x1,%eax
  8023da:	31 d2                	xor    %edx,%edx
  8023dc:	f7 f7                	div    %edi
  8023de:	89 c5                	mov    %eax,%ebp
  8023e0:	31 d2                	xor    %edx,%edx
  8023e2:	89 c8                	mov    %ecx,%eax
  8023e4:	f7 f5                	div    %ebp
  8023e6:	89 c1                	mov    %eax,%ecx
  8023e8:	89 d8                	mov    %ebx,%eax
  8023ea:	f7 f5                	div    %ebp
  8023ec:	89 cf                	mov    %ecx,%edi
  8023ee:	89 fa                	mov    %edi,%edx
  8023f0:	83 c4 1c             	add    $0x1c,%esp
  8023f3:	5b                   	pop    %ebx
  8023f4:	5e                   	pop    %esi
  8023f5:	5f                   	pop    %edi
  8023f6:	5d                   	pop    %ebp
  8023f7:	c3                   	ret    
  8023f8:	39 ce                	cmp    %ecx,%esi
  8023fa:	77 28                	ja     802424 <__udivdi3+0x7c>
  8023fc:	0f bd fe             	bsr    %esi,%edi
  8023ff:	83 f7 1f             	xor    $0x1f,%edi
  802402:	75 40                	jne    802444 <__udivdi3+0x9c>
  802404:	39 ce                	cmp    %ecx,%esi
  802406:	72 0a                	jb     802412 <__udivdi3+0x6a>
  802408:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80240c:	0f 87 9e 00 00 00    	ja     8024b0 <__udivdi3+0x108>
  802412:	b8 01 00 00 00       	mov    $0x1,%eax
  802417:	89 fa                	mov    %edi,%edx
  802419:	83 c4 1c             	add    $0x1c,%esp
  80241c:	5b                   	pop    %ebx
  80241d:	5e                   	pop    %esi
  80241e:	5f                   	pop    %edi
  80241f:	5d                   	pop    %ebp
  802420:	c3                   	ret    
  802421:	8d 76 00             	lea    0x0(%esi),%esi
  802424:	31 ff                	xor    %edi,%edi
  802426:	31 c0                	xor    %eax,%eax
  802428:	89 fa                	mov    %edi,%edx
  80242a:	83 c4 1c             	add    $0x1c,%esp
  80242d:	5b                   	pop    %ebx
  80242e:	5e                   	pop    %esi
  80242f:	5f                   	pop    %edi
  802430:	5d                   	pop    %ebp
  802431:	c3                   	ret    
  802432:	66 90                	xchg   %ax,%ax
  802434:	89 d8                	mov    %ebx,%eax
  802436:	f7 f7                	div    %edi
  802438:	31 ff                	xor    %edi,%edi
  80243a:	89 fa                	mov    %edi,%edx
  80243c:	83 c4 1c             	add    $0x1c,%esp
  80243f:	5b                   	pop    %ebx
  802440:	5e                   	pop    %esi
  802441:	5f                   	pop    %edi
  802442:	5d                   	pop    %ebp
  802443:	c3                   	ret    
  802444:	bd 20 00 00 00       	mov    $0x20,%ebp
  802449:	89 eb                	mov    %ebp,%ebx
  80244b:	29 fb                	sub    %edi,%ebx
  80244d:	89 f9                	mov    %edi,%ecx
  80244f:	d3 e6                	shl    %cl,%esi
  802451:	89 c5                	mov    %eax,%ebp
  802453:	88 d9                	mov    %bl,%cl
  802455:	d3 ed                	shr    %cl,%ebp
  802457:	89 e9                	mov    %ebp,%ecx
  802459:	09 f1                	or     %esi,%ecx
  80245b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80245f:	89 f9                	mov    %edi,%ecx
  802461:	d3 e0                	shl    %cl,%eax
  802463:	89 c5                	mov    %eax,%ebp
  802465:	89 d6                	mov    %edx,%esi
  802467:	88 d9                	mov    %bl,%cl
  802469:	d3 ee                	shr    %cl,%esi
  80246b:	89 f9                	mov    %edi,%ecx
  80246d:	d3 e2                	shl    %cl,%edx
  80246f:	8b 44 24 08          	mov    0x8(%esp),%eax
  802473:	88 d9                	mov    %bl,%cl
  802475:	d3 e8                	shr    %cl,%eax
  802477:	09 c2                	or     %eax,%edx
  802479:	89 d0                	mov    %edx,%eax
  80247b:	89 f2                	mov    %esi,%edx
  80247d:	f7 74 24 0c          	divl   0xc(%esp)
  802481:	89 d6                	mov    %edx,%esi
  802483:	89 c3                	mov    %eax,%ebx
  802485:	f7 e5                	mul    %ebp
  802487:	39 d6                	cmp    %edx,%esi
  802489:	72 19                	jb     8024a4 <__udivdi3+0xfc>
  80248b:	74 0b                	je     802498 <__udivdi3+0xf0>
  80248d:	89 d8                	mov    %ebx,%eax
  80248f:	31 ff                	xor    %edi,%edi
  802491:	e9 58 ff ff ff       	jmp    8023ee <__udivdi3+0x46>
  802496:	66 90                	xchg   %ax,%ax
  802498:	8b 54 24 08          	mov    0x8(%esp),%edx
  80249c:	89 f9                	mov    %edi,%ecx
  80249e:	d3 e2                	shl    %cl,%edx
  8024a0:	39 c2                	cmp    %eax,%edx
  8024a2:	73 e9                	jae    80248d <__udivdi3+0xe5>
  8024a4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8024a7:	31 ff                	xor    %edi,%edi
  8024a9:	e9 40 ff ff ff       	jmp    8023ee <__udivdi3+0x46>
  8024ae:	66 90                	xchg   %ax,%ax
  8024b0:	31 c0                	xor    %eax,%eax
  8024b2:	e9 37 ff ff ff       	jmp    8023ee <__udivdi3+0x46>
  8024b7:	90                   	nop

008024b8 <__umoddi3>:
  8024b8:	55                   	push   %ebp
  8024b9:	57                   	push   %edi
  8024ba:	56                   	push   %esi
  8024bb:	53                   	push   %ebx
  8024bc:	83 ec 1c             	sub    $0x1c,%esp
  8024bf:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8024c3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8024c7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8024cb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8024cf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8024d3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8024d7:	89 f3                	mov    %esi,%ebx
  8024d9:	89 fa                	mov    %edi,%edx
  8024db:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8024df:	89 34 24             	mov    %esi,(%esp)
  8024e2:	85 c0                	test   %eax,%eax
  8024e4:	75 1a                	jne    802500 <__umoddi3+0x48>
  8024e6:	39 f7                	cmp    %esi,%edi
  8024e8:	0f 86 a2 00 00 00    	jbe    802590 <__umoddi3+0xd8>
  8024ee:	89 c8                	mov    %ecx,%eax
  8024f0:	89 f2                	mov    %esi,%edx
  8024f2:	f7 f7                	div    %edi
  8024f4:	89 d0                	mov    %edx,%eax
  8024f6:	31 d2                	xor    %edx,%edx
  8024f8:	83 c4 1c             	add    $0x1c,%esp
  8024fb:	5b                   	pop    %ebx
  8024fc:	5e                   	pop    %esi
  8024fd:	5f                   	pop    %edi
  8024fe:	5d                   	pop    %ebp
  8024ff:	c3                   	ret    
  802500:	39 f0                	cmp    %esi,%eax
  802502:	0f 87 ac 00 00 00    	ja     8025b4 <__umoddi3+0xfc>
  802508:	0f bd e8             	bsr    %eax,%ebp
  80250b:	83 f5 1f             	xor    $0x1f,%ebp
  80250e:	0f 84 ac 00 00 00    	je     8025c0 <__umoddi3+0x108>
  802514:	bf 20 00 00 00       	mov    $0x20,%edi
  802519:	29 ef                	sub    %ebp,%edi
  80251b:	89 fe                	mov    %edi,%esi
  80251d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802521:	89 e9                	mov    %ebp,%ecx
  802523:	d3 e0                	shl    %cl,%eax
  802525:	89 d7                	mov    %edx,%edi
  802527:	89 f1                	mov    %esi,%ecx
  802529:	d3 ef                	shr    %cl,%edi
  80252b:	09 c7                	or     %eax,%edi
  80252d:	89 e9                	mov    %ebp,%ecx
  80252f:	d3 e2                	shl    %cl,%edx
  802531:	89 14 24             	mov    %edx,(%esp)
  802534:	89 d8                	mov    %ebx,%eax
  802536:	d3 e0                	shl    %cl,%eax
  802538:	89 c2                	mov    %eax,%edx
  80253a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80253e:	d3 e0                	shl    %cl,%eax
  802540:	89 44 24 04          	mov    %eax,0x4(%esp)
  802544:	8b 44 24 08          	mov    0x8(%esp),%eax
  802548:	89 f1                	mov    %esi,%ecx
  80254a:	d3 e8                	shr    %cl,%eax
  80254c:	09 d0                	or     %edx,%eax
  80254e:	d3 eb                	shr    %cl,%ebx
  802550:	89 da                	mov    %ebx,%edx
  802552:	f7 f7                	div    %edi
  802554:	89 d3                	mov    %edx,%ebx
  802556:	f7 24 24             	mull   (%esp)
  802559:	89 c6                	mov    %eax,%esi
  80255b:	89 d1                	mov    %edx,%ecx
  80255d:	39 d3                	cmp    %edx,%ebx
  80255f:	0f 82 87 00 00 00    	jb     8025ec <__umoddi3+0x134>
  802565:	0f 84 91 00 00 00    	je     8025fc <__umoddi3+0x144>
  80256b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80256f:	29 f2                	sub    %esi,%edx
  802571:	19 cb                	sbb    %ecx,%ebx
  802573:	89 d8                	mov    %ebx,%eax
  802575:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802579:	d3 e0                	shl    %cl,%eax
  80257b:	89 e9                	mov    %ebp,%ecx
  80257d:	d3 ea                	shr    %cl,%edx
  80257f:	09 d0                	or     %edx,%eax
  802581:	89 e9                	mov    %ebp,%ecx
  802583:	d3 eb                	shr    %cl,%ebx
  802585:	89 da                	mov    %ebx,%edx
  802587:	83 c4 1c             	add    $0x1c,%esp
  80258a:	5b                   	pop    %ebx
  80258b:	5e                   	pop    %esi
  80258c:	5f                   	pop    %edi
  80258d:	5d                   	pop    %ebp
  80258e:	c3                   	ret    
  80258f:	90                   	nop
  802590:	89 fd                	mov    %edi,%ebp
  802592:	85 ff                	test   %edi,%edi
  802594:	75 0b                	jne    8025a1 <__umoddi3+0xe9>
  802596:	b8 01 00 00 00       	mov    $0x1,%eax
  80259b:	31 d2                	xor    %edx,%edx
  80259d:	f7 f7                	div    %edi
  80259f:	89 c5                	mov    %eax,%ebp
  8025a1:	89 f0                	mov    %esi,%eax
  8025a3:	31 d2                	xor    %edx,%edx
  8025a5:	f7 f5                	div    %ebp
  8025a7:	89 c8                	mov    %ecx,%eax
  8025a9:	f7 f5                	div    %ebp
  8025ab:	89 d0                	mov    %edx,%eax
  8025ad:	e9 44 ff ff ff       	jmp    8024f6 <__umoddi3+0x3e>
  8025b2:	66 90                	xchg   %ax,%ax
  8025b4:	89 c8                	mov    %ecx,%eax
  8025b6:	89 f2                	mov    %esi,%edx
  8025b8:	83 c4 1c             	add    $0x1c,%esp
  8025bb:	5b                   	pop    %ebx
  8025bc:	5e                   	pop    %esi
  8025bd:	5f                   	pop    %edi
  8025be:	5d                   	pop    %ebp
  8025bf:	c3                   	ret    
  8025c0:	3b 04 24             	cmp    (%esp),%eax
  8025c3:	72 06                	jb     8025cb <__umoddi3+0x113>
  8025c5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8025c9:	77 0f                	ja     8025da <__umoddi3+0x122>
  8025cb:	89 f2                	mov    %esi,%edx
  8025cd:	29 f9                	sub    %edi,%ecx
  8025cf:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8025d3:	89 14 24             	mov    %edx,(%esp)
  8025d6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8025da:	8b 44 24 04          	mov    0x4(%esp),%eax
  8025de:	8b 14 24             	mov    (%esp),%edx
  8025e1:	83 c4 1c             	add    $0x1c,%esp
  8025e4:	5b                   	pop    %ebx
  8025e5:	5e                   	pop    %esi
  8025e6:	5f                   	pop    %edi
  8025e7:	5d                   	pop    %ebp
  8025e8:	c3                   	ret    
  8025e9:	8d 76 00             	lea    0x0(%esi),%esi
  8025ec:	2b 04 24             	sub    (%esp),%eax
  8025ef:	19 fa                	sbb    %edi,%edx
  8025f1:	89 d1                	mov    %edx,%ecx
  8025f3:	89 c6                	mov    %eax,%esi
  8025f5:	e9 71 ff ff ff       	jmp    80256b <__umoddi3+0xb3>
  8025fa:	66 90                	xchg   %ax,%ax
  8025fc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802600:	72 ea                	jb     8025ec <__umoddi3+0x134>
  802602:	89 d9                	mov    %ebx,%ecx
  802604:	e9 62 ff ff ff       	jmp    80256b <__umoddi3+0xb3>

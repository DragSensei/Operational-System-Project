
obj/user/quicksort_interrupt:     file format elf32-i386


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
  800031:	e8 8f 05 00 00       	call   8005c5 <libmain>
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
  800049:	e8 b8 1d 00 00       	call   801e06 <sys_calculate_free_frames>
  80004e:	89 c3                	mov    %eax,%ebx
  800050:	e8 ca 1d 00 00       	call   801e1f <sys_calculate_modified_frames>
  800055:	01 d8                	add    %ebx,%eax
  800057:	89 45 f0             	mov    %eax,-0x10(%ebp)

		Iteration++ ;
  80005a:	ff 45 f4             	incl   -0xc(%ebp)
		//		cprintf("Free Frames Before Allocation = %d\n", sys_calculate_free_frames()) ;

//	sys_lock_cons();

		sys_lock_cons();
  80005d:	e8 f4 1c 00 00       	call   801d56 <sys_lock_cons>
			readline("Enter the number of elements: ", Line);
  800062:	83 ec 08             	sub    $0x8,%esp
  800065:	8d 85 e1 fe ff ff    	lea    -0x11f(%ebp),%eax
  80006b:	50                   	push   %eax
  80006c:	68 40 26 80 00       	push   $0x802640
  800071:	e8 a6 10 00 00       	call   80111c <readline>
  800076:	83 c4 10             	add    $0x10,%esp
			int NumOfElements = strtol(Line, NULL, 10) ;
  800079:	83 ec 04             	sub    $0x4,%esp
  80007c:	6a 0a                	push   $0xa
  80007e:	6a 00                	push   $0x0
  800080:	8d 85 e1 fe ff ff    	lea    -0x11f(%ebp),%eax
  800086:	50                   	push   %eax
  800087:	e8 a7 16 00 00       	call   801733 <strtol>
  80008c:	83 c4 10             	add    $0x10,%esp
  80008f:	89 45 ec             	mov    %eax,-0x14(%ebp)
			int *Elements = malloc(sizeof(int) * NumOfElements) ;
  800092:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800095:	c1 e0 02             	shl    $0x2,%eax
  800098:	83 ec 0c             	sub    $0xc,%esp
  80009b:	50                   	push   %eax
  80009c:	e8 6c 1b 00 00       	call   801c0d <malloc>
  8000a1:	83 c4 10             	add    $0x10,%esp
  8000a4:	89 45 e8             	mov    %eax,-0x18(%ebp)
			cprintf("Choose the initialization method:\n") ;
  8000a7:	83 ec 0c             	sub    $0xc,%esp
  8000aa:	68 60 26 80 00       	push   $0x802660
  8000af:	e8 8f 09 00 00       	call   800a43 <cprintf>
  8000b4:	83 c4 10             	add    $0x10,%esp
			cprintf("a) Ascending\n") ;
  8000b7:	83 ec 0c             	sub    $0xc,%esp
  8000ba:	68 83 26 80 00       	push   $0x802683
  8000bf:	e8 7f 09 00 00       	call   800a43 <cprintf>
  8000c4:	83 c4 10             	add    $0x10,%esp
			cprintf("b) Descending\n") ;
  8000c7:	83 ec 0c             	sub    $0xc,%esp
  8000ca:	68 91 26 80 00       	push   $0x802691
  8000cf:	e8 6f 09 00 00       	call   800a43 <cprintf>
  8000d4:	83 c4 10             	add    $0x10,%esp
			cprintf("c) Semi random\n");
  8000d7:	83 ec 0c             	sub    $0xc,%esp
  8000da:	68 a0 26 80 00       	push   $0x8026a0
  8000df:	e8 5f 09 00 00       	call   800a43 <cprintf>
  8000e4:	83 c4 10             	add    $0x10,%esp
			do
			{
				cprintf("Select: ") ;
  8000e7:	83 ec 0c             	sub    $0xc,%esp
  8000ea:	68 b0 26 80 00       	push   $0x8026b0
  8000ef:	e8 4f 09 00 00       	call   800a43 <cprintf>
  8000f4:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  8000f7:	e8 ac 04 00 00       	call   8005a8 <getchar>
  8000fc:	88 45 e7             	mov    %al,-0x19(%ebp)
				cputchar(Chose);
  8000ff:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  800103:	83 ec 0c             	sub    $0xc,%esp
  800106:	50                   	push   %eax
  800107:	e8 7d 04 00 00       	call   800589 <cputchar>
  80010c:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  80010f:	83 ec 0c             	sub    $0xc,%esp
  800112:	6a 0a                	push   $0xa
  800114:	e8 70 04 00 00       	call   800589 <cputchar>
  800119:	83 c4 10             	add    $0x10,%esp
			} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  80011c:	80 7d e7 61          	cmpb   $0x61,-0x19(%ebp)
  800120:	74 0c                	je     80012e <_main+0xf6>
  800122:	80 7d e7 62          	cmpb   $0x62,-0x19(%ebp)
  800126:	74 06                	je     80012e <_main+0xf6>
  800128:	80 7d e7 63          	cmpb   $0x63,-0x19(%ebp)
  80012c:	75 b9                	jne    8000e7 <_main+0xaf>
		sys_unlock_cons();
  80012e:	e8 3d 1c 00 00       	call   801d70 <sys_unlock_cons>
			//sys_unlock_cons();
			int  i ;
		switch (Chose)
  800133:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  800137:	83 f8 62             	cmp    $0x62,%eax
  80013a:	74 1d                	je     800159 <_main+0x121>
  80013c:	83 f8 63             	cmp    $0x63,%eax
  80013f:	74 2b                	je     80016c <_main+0x134>
  800141:	83 f8 61             	cmp    $0x61,%eax
  800144:	75 39                	jne    80017f <_main+0x147>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  800146:	83 ec 08             	sub    $0x8,%esp
  800149:	ff 75 ec             	pushl  -0x14(%ebp)
  80014c:	ff 75 e8             	pushl  -0x18(%ebp)
  80014f:	e8 e6 02 00 00       	call   80043a <InitializeAscending>
  800154:	83 c4 10             	add    $0x10,%esp
			break ;
  800157:	eb 37                	jmp    800190 <_main+0x158>
		case 'b':
			InitializeIdentical(Elements, NumOfElements);
  800159:	83 ec 08             	sub    $0x8,%esp
  80015c:	ff 75 ec             	pushl  -0x14(%ebp)
  80015f:	ff 75 e8             	pushl  -0x18(%ebp)
  800162:	e8 04 03 00 00       	call   80046b <InitializeIdentical>
  800167:	83 c4 10             	add    $0x10,%esp
			break ;
  80016a:	eb 24                	jmp    800190 <_main+0x158>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  80016c:	83 ec 08             	sub    $0x8,%esp
  80016f:	ff 75 ec             	pushl  -0x14(%ebp)
  800172:	ff 75 e8             	pushl  -0x18(%ebp)
  800175:	e8 26 03 00 00       	call   8004a0 <InitializeSemiRandom>
  80017a:	83 c4 10             	add    $0x10,%esp
			break ;
  80017d:	eb 11                	jmp    800190 <_main+0x158>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  80017f:	83 ec 08             	sub    $0x8,%esp
  800182:	ff 75 ec             	pushl  -0x14(%ebp)
  800185:	ff 75 e8             	pushl  -0x18(%ebp)
  800188:	e8 13 03 00 00       	call   8004a0 <InitializeSemiRandom>
  80018d:	83 c4 10             	add    $0x10,%esp
		}

		QuickSort(Elements, NumOfElements);
  800190:	83 ec 08             	sub    $0x8,%esp
  800193:	ff 75 ec             	pushl  -0x14(%ebp)
  800196:	ff 75 e8             	pushl  -0x18(%ebp)
  800199:	e8 e1 00 00 00       	call   80027f <QuickSort>
  80019e:	83 c4 10             	add    $0x10,%esp

		//		PrintElements(Elements, NumOfElements);

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001a1:	83 ec 08             	sub    $0x8,%esp
  8001a4:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a7:	ff 75 e8             	pushl  -0x18(%ebp)
  8001aa:	e8 e1 01 00 00       	call   800390 <CheckSorted>
  8001af:	83 c4 10             	add    $0x10,%esp
  8001b2:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  8001b5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8001b9:	75 14                	jne    8001cf <_main+0x197>
  8001bb:	83 ec 04             	sub    $0x4,%esp
  8001be:	68 bc 26 80 00       	push   $0x8026bc
  8001c3:	6a 46                	push   $0x46
  8001c5:	68 de 26 80 00       	push   $0x8026de
  8001ca:	e8 a6 05 00 00       	call   800775 <_panic>
		else
		{
			sys_lock_cons();
  8001cf:	e8 82 1b 00 00       	call   801d56 <sys_lock_cons>
				cprintf("\n===============================================\n") ;
  8001d4:	83 ec 0c             	sub    $0xc,%esp
  8001d7:	68 fc 26 80 00       	push   $0x8026fc
  8001dc:	e8 62 08 00 00       	call   800a43 <cprintf>
  8001e1:	83 c4 10             	add    $0x10,%esp
				cprintf("Congratulations!! The array is sorted correctly\n") ;
  8001e4:	83 ec 0c             	sub    $0xc,%esp
  8001e7:	68 30 27 80 00       	push   $0x802730
  8001ec:	e8 52 08 00 00       	call   800a43 <cprintf>
  8001f1:	83 c4 10             	add    $0x10,%esp
				cprintf("===============================================\n\n") ;
  8001f4:	83 ec 0c             	sub    $0xc,%esp
  8001f7:	68 64 27 80 00       	push   $0x802764
  8001fc:	e8 42 08 00 00       	call   800a43 <cprintf>
  800201:	83 c4 10             	add    $0x10,%esp
			sys_unlock_cons();
  800204:	e8 67 1b 00 00       	call   801d70 <sys_unlock_cons>
		}

		//		cprintf("Free Frames After Calculation = %d\n", sys_calculate_free_frames()) ;

		sys_lock_cons();
  800209:	e8 48 1b 00 00       	call   801d56 <sys_lock_cons>
			cprintf("Freeing the Heap...\n\n") ;
  80020e:	83 ec 0c             	sub    $0xc,%esp
  800211:	68 96 27 80 00       	push   $0x802796
  800216:	e8 28 08 00 00       	call   800a43 <cprintf>
  80021b:	83 c4 10             	add    $0x10,%esp
		sys_unlock_cons();
  80021e:	e8 4d 1b 00 00       	call   801d70 <sys_unlock_cons>

		//freeHeap() ;

		///========================================================================
	//sys_lock_cons();
		sys_lock_cons();
  800223:	e8 2e 1b 00 00       	call   801d56 <sys_lock_cons>
			cprintf("Do you want to repeat (y/n): ") ;
  800228:	83 ec 0c             	sub    $0xc,%esp
  80022b:	68 ac 27 80 00       	push   $0x8027ac
  800230:	e8 0e 08 00 00       	call   800a43 <cprintf>
  800235:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  800238:	e8 6b 03 00 00       	call   8005a8 <getchar>
  80023d:	88 45 e7             	mov    %al,-0x19(%ebp)
			cputchar(Chose);
  800240:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  800244:	83 ec 0c             	sub    $0xc,%esp
  800247:	50                   	push   %eax
  800248:	e8 3c 03 00 00       	call   800589 <cputchar>
  80024d:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800250:	83 ec 0c             	sub    $0xc,%esp
  800253:	6a 0a                	push   $0xa
  800255:	e8 2f 03 00 00       	call   800589 <cputchar>
  80025a:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  80025d:	83 ec 0c             	sub    $0xc,%esp
  800260:	6a 0a                	push   $0xa
  800262:	e8 22 03 00 00       	call   800589 <cputchar>
  800267:	83 c4 10             	add    $0x10,%esp
	//sys_unlock_cons();
		sys_unlock_cons();
  80026a:	e8 01 1b 00 00       	call   801d70 <sys_unlock_cons>

	} while (Chose == 'y');
  80026f:	80 7d e7 79          	cmpb   $0x79,-0x19(%ebp)
  800273:	0f 84 d0 fd ff ff    	je     800049 <_main+0x11>

}
  800279:	90                   	nop
  80027a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80027d:	c9                   	leave  
  80027e:	c3                   	ret    

0080027f <QuickSort>:

///Quick sort
void QuickSort(int *Elements, int NumOfElements)
{
  80027f:	55                   	push   %ebp
  800280:	89 e5                	mov    %esp,%ebp
  800282:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  800285:	8b 45 0c             	mov    0xc(%ebp),%eax
  800288:	48                   	dec    %eax
  800289:	50                   	push   %eax
  80028a:	6a 00                	push   $0x0
  80028c:	ff 75 0c             	pushl  0xc(%ebp)
  80028f:	ff 75 08             	pushl  0x8(%ebp)
  800292:	e8 06 00 00 00       	call   80029d <QSort>
  800297:	83 c4 10             	add    $0x10,%esp
}
  80029a:	90                   	nop
  80029b:	c9                   	leave  
  80029c:	c3                   	ret    

0080029d <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  80029d:	55                   	push   %ebp
  80029e:	89 e5                	mov    %esp,%ebp
  8002a0:	83 ec 18             	sub    $0x18,%esp
	if (startIndex >= finalIndex) return;
  8002a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8002a6:	3b 45 14             	cmp    0x14(%ebp),%eax
  8002a9:	0f 8d de 00 00 00    	jge    80038d <QSort+0xf0>

	int i = startIndex+1, j = finalIndex;
  8002af:	8b 45 10             	mov    0x10(%ebp),%eax
  8002b2:	40                   	inc    %eax
  8002b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8002b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8002b9:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  8002bc:	e9 80 00 00 00       	jmp    800341 <QSort+0xa4>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  8002c1:	ff 45 f4             	incl   -0xc(%ebp)
  8002c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002c7:	3b 45 14             	cmp    0x14(%ebp),%eax
  8002ca:	7f 2b                	jg     8002f7 <QSort+0x5a>
  8002cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8002cf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d9:	01 d0                	add    %edx,%eax
  8002db:	8b 10                	mov    (%eax),%edx
  8002dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002e0:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ea:	01 c8                	add    %ecx,%eax
  8002ec:	8b 00                	mov    (%eax),%eax
  8002ee:	39 c2                	cmp    %eax,%edx
  8002f0:	7d cf                	jge    8002c1 <QSort+0x24>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  8002f2:	eb 03                	jmp    8002f7 <QSort+0x5a>
  8002f4:	ff 4d f0             	decl   -0x10(%ebp)
  8002f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002fa:	3b 45 10             	cmp    0x10(%ebp),%eax
  8002fd:	7e 26                	jle    800325 <QSort+0x88>
  8002ff:	8b 45 10             	mov    0x10(%ebp),%eax
  800302:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800309:	8b 45 08             	mov    0x8(%ebp),%eax
  80030c:	01 d0                	add    %edx,%eax
  80030e:	8b 10                	mov    (%eax),%edx
  800310:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800313:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80031a:	8b 45 08             	mov    0x8(%ebp),%eax
  80031d:	01 c8                	add    %ecx,%eax
  80031f:	8b 00                	mov    (%eax),%eax
  800321:	39 c2                	cmp    %eax,%edx
  800323:	7e cf                	jle    8002f4 <QSort+0x57>

		if (i <= j)
  800325:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800328:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80032b:	7f 14                	jg     800341 <QSort+0xa4>
		{
			Swap(Elements, i, j);
  80032d:	83 ec 04             	sub    $0x4,%esp
  800330:	ff 75 f0             	pushl  -0x10(%ebp)
  800333:	ff 75 f4             	pushl  -0xc(%ebp)
  800336:	ff 75 08             	pushl  0x8(%ebp)
  800339:	e8 a9 00 00 00       	call   8003e7 <Swap>
  80033e:	83 c4 10             	add    $0x10,%esp
{
	if (startIndex >= finalIndex) return;

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  800341:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800344:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800347:	0f 8e 77 ff ff ff    	jle    8002c4 <QSort+0x27>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  80034d:	83 ec 04             	sub    $0x4,%esp
  800350:	ff 75 f0             	pushl  -0x10(%ebp)
  800353:	ff 75 10             	pushl  0x10(%ebp)
  800356:	ff 75 08             	pushl  0x8(%ebp)
  800359:	e8 89 00 00 00       	call   8003e7 <Swap>
  80035e:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  800361:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800364:	48                   	dec    %eax
  800365:	50                   	push   %eax
  800366:	ff 75 10             	pushl  0x10(%ebp)
  800369:	ff 75 0c             	pushl  0xc(%ebp)
  80036c:	ff 75 08             	pushl  0x8(%ebp)
  80036f:	e8 29 ff ff ff       	call   80029d <QSort>
  800374:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  800377:	ff 75 14             	pushl  0x14(%ebp)
  80037a:	ff 75 f4             	pushl  -0xc(%ebp)
  80037d:	ff 75 0c             	pushl  0xc(%ebp)
  800380:	ff 75 08             	pushl  0x8(%ebp)
  800383:	e8 15 ff ff ff       	call   80029d <QSort>
  800388:	83 c4 10             	add    $0x10,%esp
  80038b:	eb 01                	jmp    80038e <QSort+0xf1>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  80038d:	90                   	nop

	Swap( Elements, startIndex, j);

	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);
}
  80038e:	c9                   	leave  
  80038f:	c3                   	ret    

00800390 <CheckSorted>:

uint32 CheckSorted(int *Elements, int NumOfElements)
{
  800390:	55                   	push   %ebp
  800391:	89 e5                	mov    %esp,%ebp
  800393:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  800396:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  80039d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8003a4:	eb 33                	jmp    8003d9 <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8003a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003a9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b3:	01 d0                	add    %edx,%eax
  8003b5:	8b 10                	mov    (%eax),%edx
  8003b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003ba:	40                   	inc    %eax
  8003bb:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c5:	01 c8                	add    %ecx,%eax
  8003c7:	8b 00                	mov    (%eax),%eax
  8003c9:	39 c2                	cmp    %eax,%edx
  8003cb:	7e 09                	jle    8003d6 <CheckSorted+0x46>
		{
			Sorted = 0 ;
  8003cd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  8003d4:	eb 0c                	jmp    8003e2 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8003d6:	ff 45 f8             	incl   -0x8(%ebp)
  8003d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003dc:	48                   	dec    %eax
  8003dd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8003e0:	7f c4                	jg     8003a6 <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  8003e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8003e5:	c9                   	leave  
  8003e6:	c3                   	ret    

008003e7 <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  8003e7:	55                   	push   %ebp
  8003e8:	89 e5                	mov    %esp,%ebp
  8003ea:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  8003ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003f0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fa:	01 d0                	add    %edx,%eax
  8003fc:	8b 00                	mov    (%eax),%eax
  8003fe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800401:	8b 45 0c             	mov    0xc(%ebp),%eax
  800404:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80040b:	8b 45 08             	mov    0x8(%ebp),%eax
  80040e:	01 c2                	add    %eax,%edx
  800410:	8b 45 10             	mov    0x10(%ebp),%eax
  800413:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80041a:	8b 45 08             	mov    0x8(%ebp),%eax
  80041d:	01 c8                	add    %ecx,%eax
  80041f:	8b 00                	mov    (%eax),%eax
  800421:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800423:	8b 45 10             	mov    0x10(%ebp),%eax
  800426:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80042d:	8b 45 08             	mov    0x8(%ebp),%eax
  800430:	01 c2                	add    %eax,%edx
  800432:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800435:	89 02                	mov    %eax,(%edx)
}
  800437:	90                   	nop
  800438:	c9                   	leave  
  800439:	c3                   	ret    

0080043a <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  80043a:	55                   	push   %ebp
  80043b:	89 e5                	mov    %esp,%ebp
  80043d:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800440:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800447:	eb 17                	jmp    800460 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  800449:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80044c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800453:	8b 45 08             	mov    0x8(%ebp),%eax
  800456:	01 c2                	add    %eax,%edx
  800458:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80045b:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80045d:	ff 45 fc             	incl   -0x4(%ebp)
  800460:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800463:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800466:	7c e1                	jl     800449 <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  800468:	90                   	nop
  800469:	c9                   	leave  
  80046a:	c3                   	ret    

0080046b <InitializeIdentical>:

void InitializeIdentical(int *Elements, int NumOfElements)
{
  80046b:	55                   	push   %ebp
  80046c:	89 e5                	mov    %esp,%ebp
  80046e:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800471:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800478:	eb 1b                	jmp    800495 <InitializeIdentical+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  80047a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80047d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800484:	8b 45 08             	mov    0x8(%ebp),%eax
  800487:	01 c2                	add    %eax,%edx
  800489:	8b 45 0c             	mov    0xc(%ebp),%eax
  80048c:	2b 45 fc             	sub    -0x4(%ebp),%eax
  80048f:	48                   	dec    %eax
  800490:	89 02                	mov    %eax,(%edx)
}

void InitializeIdentical(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800492:	ff 45 fc             	incl   -0x4(%ebp)
  800495:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800498:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80049b:	7c dd                	jl     80047a <InitializeIdentical+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  80049d:	90                   	nop
  80049e:	c9                   	leave  
  80049f:	c3                   	ret    

008004a0 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8004a0:	55                   	push   %ebp
  8004a1:	89 e5                	mov    %esp,%ebp
  8004a3:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8004a6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004a9:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8004ae:	f7 e9                	imul   %ecx
  8004b0:	c1 f9 1f             	sar    $0x1f,%ecx
  8004b3:	89 d0                	mov    %edx,%eax
  8004b5:	29 c8                	sub    %ecx,%eax
  8004b7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (Repetition == 0)
  8004ba:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8004be:	75 07                	jne    8004c7 <InitializeSemiRandom+0x27>
			Repetition = 3;
  8004c0:	c7 45 f8 03 00 00 00 	movl   $0x3,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8004c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8004ce:	eb 1e                	jmp    8004ee <InitializeSemiRandom+0x4e>
	{
		Elements[i] = i % Repetition ;
  8004d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004d3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004da:	8b 45 08             	mov    0x8(%ebp),%eax
  8004dd:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8004e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004e3:	99                   	cltd   
  8004e4:	f7 7d f8             	idivl  -0x8(%ebp)
  8004e7:	89 d0                	mov    %edx,%eax
  8004e9:	89 01                	mov    %eax,(%ecx)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	if (Repetition == 0)
			Repetition = 3;
	for (i = 0 ; i < NumOfElements ; i++)
  8004eb:	ff 45 fc             	incl   -0x4(%ebp)
  8004ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004f1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004f4:	7c da                	jl     8004d0 <InitializeSemiRandom+0x30>
	{
		Elements[i] = i % Repetition ;
	}

}
  8004f6:	90                   	nop
  8004f7:	c9                   	leave  
  8004f8:	c3                   	ret    

008004f9 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  8004f9:	55                   	push   %ebp
  8004fa:	89 e5                	mov    %esp,%ebp
  8004fc:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  8004ff:	e8 52 18 00 00       	call   801d56 <sys_lock_cons>
		int i ;
		int NumsPerLine = 20 ;
  800504:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
		for (i = 0 ; i < NumOfElements-1 ; i++)
  80050b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800512:	eb 42                	jmp    800556 <PrintElements+0x5d>
		{
			if (i%NumsPerLine == 0)
  800514:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800517:	99                   	cltd   
  800518:	f7 7d f0             	idivl  -0x10(%ebp)
  80051b:	89 d0                	mov    %edx,%eax
  80051d:	85 c0                	test   %eax,%eax
  80051f:	75 10                	jne    800531 <PrintElements+0x38>
				cprintf("\n");
  800521:	83 ec 0c             	sub    $0xc,%esp
  800524:	68 ca 27 80 00       	push   $0x8027ca
  800529:	e8 15 05 00 00       	call   800a43 <cprintf>
  80052e:	83 c4 10             	add    $0x10,%esp
			cprintf("%d, ",Elements[i]);
  800531:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800534:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80053b:	8b 45 08             	mov    0x8(%ebp),%eax
  80053e:	01 d0                	add    %edx,%eax
  800540:	8b 00                	mov    (%eax),%eax
  800542:	83 ec 08             	sub    $0x8,%esp
  800545:	50                   	push   %eax
  800546:	68 cc 27 80 00       	push   $0x8027cc
  80054b:	e8 f3 04 00 00       	call   800a43 <cprintf>
  800550:	83 c4 10             	add    $0x10,%esp
void PrintElements(int *Elements, int NumOfElements)
{
	sys_lock_cons();
		int i ;
		int NumsPerLine = 20 ;
		for (i = 0 ; i < NumOfElements-1 ; i++)
  800553:	ff 45 f4             	incl   -0xc(%ebp)
  800556:	8b 45 0c             	mov    0xc(%ebp),%eax
  800559:	48                   	dec    %eax
  80055a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80055d:	7f b5                	jg     800514 <PrintElements+0x1b>
		{
			if (i%NumsPerLine == 0)
				cprintf("\n");
			cprintf("%d, ",Elements[i]);
		}
		cprintf("%d\n",Elements[i]);
  80055f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800562:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800569:	8b 45 08             	mov    0x8(%ebp),%eax
  80056c:	01 d0                	add    %edx,%eax
  80056e:	8b 00                	mov    (%eax),%eax
  800570:	83 ec 08             	sub    $0x8,%esp
  800573:	50                   	push   %eax
  800574:	68 d1 27 80 00       	push   $0x8027d1
  800579:	e8 c5 04 00 00       	call   800a43 <cprintf>
  80057e:	83 c4 10             	add    $0x10,%esp
	sys_unlock_cons();
  800581:	e8 ea 17 00 00       	call   801d70 <sys_unlock_cons>
}
  800586:	90                   	nop
  800587:	c9                   	leave  
  800588:	c3                   	ret    

00800589 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  800589:	55                   	push   %ebp
  80058a:	89 e5                	mov    %esp,%ebp
  80058c:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  80058f:	8b 45 08             	mov    0x8(%ebp),%eax
  800592:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800595:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800599:	83 ec 0c             	sub    $0xc,%esp
  80059c:	50                   	push   %eax
  80059d:	e8 fc 18 00 00       	call   801e9e <sys_cputc>
  8005a2:	83 c4 10             	add    $0x10,%esp
}
  8005a5:	90                   	nop
  8005a6:	c9                   	leave  
  8005a7:	c3                   	ret    

008005a8 <getchar>:


int
getchar(void)
{
  8005a8:	55                   	push   %ebp
  8005a9:	89 e5                	mov    %esp,%ebp
  8005ab:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  8005ae:	e8 8a 17 00 00       	call   801d3d <sys_cgetc>
  8005b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  8005b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8005b9:	c9                   	leave  
  8005ba:	c3                   	ret    

008005bb <iscons>:

int iscons(int fdnum)
{
  8005bb:	55                   	push   %ebp
  8005bc:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  8005be:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8005c3:	5d                   	pop    %ebp
  8005c4:	c3                   	ret    

008005c5 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8005c5:	55                   	push   %ebp
  8005c6:	89 e5                	mov    %esp,%ebp
  8005c8:	57                   	push   %edi
  8005c9:	56                   	push   %esi
  8005ca:	53                   	push   %ebx
  8005cb:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8005ce:	e8 fc 19 00 00       	call   801fcf <sys_getenvindex>
  8005d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8005d6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8005d9:	89 d0                	mov    %edx,%eax
  8005db:	c1 e0 02             	shl    $0x2,%eax
  8005de:	01 d0                	add    %edx,%eax
  8005e0:	c1 e0 03             	shl    $0x3,%eax
  8005e3:	01 d0                	add    %edx,%eax
  8005e5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8005ec:	01 d0                	add    %edx,%eax
  8005ee:	c1 e0 02             	shl    $0x2,%eax
  8005f1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8005f6:	a3 24 40 80 00       	mov    %eax,0x804024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8005fb:	a1 24 40 80 00       	mov    0x804024,%eax
  800600:	8a 40 20             	mov    0x20(%eax),%al
  800603:	84 c0                	test   %al,%al
  800605:	74 0d                	je     800614 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800607:	a1 24 40 80 00       	mov    0x804024,%eax
  80060c:	83 c0 20             	add    $0x20,%eax
  80060f:	a3 04 40 80 00       	mov    %eax,0x804004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800614:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800618:	7e 0a                	jle    800624 <libmain+0x5f>
		binaryname = argv[0];
  80061a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80061d:	8b 00                	mov    (%eax),%eax
  80061f:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	_main(argc, argv);
  800624:	83 ec 08             	sub    $0x8,%esp
  800627:	ff 75 0c             	pushl  0xc(%ebp)
  80062a:	ff 75 08             	pushl  0x8(%ebp)
  80062d:	e8 06 fa ff ff       	call   800038 <_main>
  800632:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800635:	a1 00 40 80 00       	mov    0x804000,%eax
  80063a:	85 c0                	test   %eax,%eax
  80063c:	0f 84 01 01 00 00    	je     800743 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800642:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800648:	bb d0 28 80 00       	mov    $0x8028d0,%ebx
  80064d:	ba 0e 00 00 00       	mov    $0xe,%edx
  800652:	89 c7                	mov    %eax,%edi
  800654:	89 de                	mov    %ebx,%esi
  800656:	89 d1                	mov    %edx,%ecx
  800658:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80065a:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80065d:	b9 56 00 00 00       	mov    $0x56,%ecx
  800662:	b0 00                	mov    $0x0,%al
  800664:	89 d7                	mov    %edx,%edi
  800666:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800668:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80066f:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800672:	83 ec 08             	sub    $0x8,%esp
  800675:	50                   	push   %eax
  800676:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80067c:	50                   	push   %eax
  80067d:	e8 83 1b 00 00       	call   802205 <sys_utilities>
  800682:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800685:	e8 cc 16 00 00       	call   801d56 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80068a:	83 ec 0c             	sub    $0xc,%esp
  80068d:	68 f0 27 80 00       	push   $0x8027f0
  800692:	e8 ac 03 00 00       	call   800a43 <cprintf>
  800697:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80069a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80069d:	85 c0                	test   %eax,%eax
  80069f:	74 18                	je     8006b9 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8006a1:	e8 7d 1b 00 00       	call   802223 <sys_get_optimal_num_faults>
  8006a6:	83 ec 08             	sub    $0x8,%esp
  8006a9:	50                   	push   %eax
  8006aa:	68 18 28 80 00       	push   $0x802818
  8006af:	e8 8f 03 00 00       	call   800a43 <cprintf>
  8006b4:	83 c4 10             	add    $0x10,%esp
  8006b7:	eb 59                	jmp    800712 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8006b9:	a1 24 40 80 00       	mov    0x804024,%eax
  8006be:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8006c4:	a1 24 40 80 00       	mov    0x804024,%eax
  8006c9:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  8006cf:	83 ec 04             	sub    $0x4,%esp
  8006d2:	52                   	push   %edx
  8006d3:	50                   	push   %eax
  8006d4:	68 3c 28 80 00       	push   $0x80283c
  8006d9:	e8 65 03 00 00       	call   800a43 <cprintf>
  8006de:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8006e1:	a1 24 40 80 00       	mov    0x804024,%eax
  8006e6:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8006ec:	a1 24 40 80 00       	mov    0x804024,%eax
  8006f1:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  8006f7:	a1 24 40 80 00       	mov    0x804024,%eax
  8006fc:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  800702:	51                   	push   %ecx
  800703:	52                   	push   %edx
  800704:	50                   	push   %eax
  800705:	68 64 28 80 00       	push   $0x802864
  80070a:	e8 34 03 00 00       	call   800a43 <cprintf>
  80070f:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800712:	a1 24 40 80 00       	mov    0x804024,%eax
  800717:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  80071d:	83 ec 08             	sub    $0x8,%esp
  800720:	50                   	push   %eax
  800721:	68 bc 28 80 00       	push   $0x8028bc
  800726:	e8 18 03 00 00       	call   800a43 <cprintf>
  80072b:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80072e:	83 ec 0c             	sub    $0xc,%esp
  800731:	68 f0 27 80 00       	push   $0x8027f0
  800736:	e8 08 03 00 00       	call   800a43 <cprintf>
  80073b:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80073e:	e8 2d 16 00 00       	call   801d70 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800743:	e8 1f 00 00 00       	call   800767 <exit>
}
  800748:	90                   	nop
  800749:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80074c:	5b                   	pop    %ebx
  80074d:	5e                   	pop    %esi
  80074e:	5f                   	pop    %edi
  80074f:	5d                   	pop    %ebp
  800750:	c3                   	ret    

00800751 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800751:	55                   	push   %ebp
  800752:	89 e5                	mov    %esp,%ebp
  800754:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800757:	83 ec 0c             	sub    $0xc,%esp
  80075a:	6a 00                	push   $0x0
  80075c:	e8 3a 18 00 00       	call   801f9b <sys_destroy_env>
  800761:	83 c4 10             	add    $0x10,%esp
}
  800764:	90                   	nop
  800765:	c9                   	leave  
  800766:	c3                   	ret    

00800767 <exit>:

void
exit(void)
{
  800767:	55                   	push   %ebp
  800768:	89 e5                	mov    %esp,%ebp
  80076a:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80076d:	e8 8f 18 00 00       	call   802001 <sys_exit_env>
}
  800772:	90                   	nop
  800773:	c9                   	leave  
  800774:	c3                   	ret    

00800775 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800775:	55                   	push   %ebp
  800776:	89 e5                	mov    %esp,%ebp
  800778:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80077b:	8d 45 10             	lea    0x10(%ebp),%eax
  80077e:	83 c0 04             	add    $0x4,%eax
  800781:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800784:	a1 18 c1 81 00       	mov    0x81c118,%eax
  800789:	85 c0                	test   %eax,%eax
  80078b:	74 16                	je     8007a3 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80078d:	a1 18 c1 81 00       	mov    0x81c118,%eax
  800792:	83 ec 08             	sub    $0x8,%esp
  800795:	50                   	push   %eax
  800796:	68 34 29 80 00       	push   $0x802934
  80079b:	e8 a3 02 00 00       	call   800a43 <cprintf>
  8007a0:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8007a3:	a1 04 40 80 00       	mov    0x804004,%eax
  8007a8:	83 ec 0c             	sub    $0xc,%esp
  8007ab:	ff 75 0c             	pushl  0xc(%ebp)
  8007ae:	ff 75 08             	pushl  0x8(%ebp)
  8007b1:	50                   	push   %eax
  8007b2:	68 3c 29 80 00       	push   $0x80293c
  8007b7:	6a 74                	push   $0x74
  8007b9:	e8 b2 02 00 00       	call   800a70 <cprintf_colored>
  8007be:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8007c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8007c4:	83 ec 08             	sub    $0x8,%esp
  8007c7:	ff 75 f4             	pushl  -0xc(%ebp)
  8007ca:	50                   	push   %eax
  8007cb:	e8 04 02 00 00       	call   8009d4 <vcprintf>
  8007d0:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8007d3:	83 ec 08             	sub    $0x8,%esp
  8007d6:	6a 00                	push   $0x0
  8007d8:	68 64 29 80 00       	push   $0x802964
  8007dd:	e8 f2 01 00 00       	call   8009d4 <vcprintf>
  8007e2:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8007e5:	e8 7d ff ff ff       	call   800767 <exit>

	// should not return here
	while (1) ;
  8007ea:	eb fe                	jmp    8007ea <_panic+0x75>

008007ec <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8007ec:	55                   	push   %ebp
  8007ed:	89 e5                	mov    %esp,%ebp
  8007ef:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8007f2:	a1 24 40 80 00       	mov    0x804024,%eax
  8007f7:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8007fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800800:	39 c2                	cmp    %eax,%edx
  800802:	74 14                	je     800818 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800804:	83 ec 04             	sub    $0x4,%esp
  800807:	68 68 29 80 00       	push   $0x802968
  80080c:	6a 26                	push   $0x26
  80080e:	68 b4 29 80 00       	push   $0x8029b4
  800813:	e8 5d ff ff ff       	call   800775 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800818:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80081f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800826:	e9 c5 00 00 00       	jmp    8008f0 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80082b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80082e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800835:	8b 45 08             	mov    0x8(%ebp),%eax
  800838:	01 d0                	add    %edx,%eax
  80083a:	8b 00                	mov    (%eax),%eax
  80083c:	85 c0                	test   %eax,%eax
  80083e:	75 08                	jne    800848 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800840:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800843:	e9 a5 00 00 00       	jmp    8008ed <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800848:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80084f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800856:	eb 69                	jmp    8008c1 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800858:	a1 24 40 80 00       	mov    0x804024,%eax
  80085d:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800863:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800866:	89 d0                	mov    %edx,%eax
  800868:	01 c0                	add    %eax,%eax
  80086a:	01 d0                	add    %edx,%eax
  80086c:	c1 e0 03             	shl    $0x3,%eax
  80086f:	01 c8                	add    %ecx,%eax
  800871:	8a 40 04             	mov    0x4(%eax),%al
  800874:	84 c0                	test   %al,%al
  800876:	75 46                	jne    8008be <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800878:	a1 24 40 80 00       	mov    0x804024,%eax
  80087d:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800883:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800886:	89 d0                	mov    %edx,%eax
  800888:	01 c0                	add    %eax,%eax
  80088a:	01 d0                	add    %edx,%eax
  80088c:	c1 e0 03             	shl    $0x3,%eax
  80088f:	01 c8                	add    %ecx,%eax
  800891:	8b 00                	mov    (%eax),%eax
  800893:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800896:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800899:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80089e:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8008a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008a3:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8008aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ad:	01 c8                	add    %ecx,%eax
  8008af:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008b1:	39 c2                	cmp    %eax,%edx
  8008b3:	75 09                	jne    8008be <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8008b5:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8008bc:	eb 15                	jmp    8008d3 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008be:	ff 45 e8             	incl   -0x18(%ebp)
  8008c1:	a1 24 40 80 00       	mov    0x804024,%eax
  8008c6:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8008cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008cf:	39 c2                	cmp    %eax,%edx
  8008d1:	77 85                	ja     800858 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8008d3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8008d7:	75 14                	jne    8008ed <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8008d9:	83 ec 04             	sub    $0x4,%esp
  8008dc:	68 c0 29 80 00       	push   $0x8029c0
  8008e1:	6a 3a                	push   $0x3a
  8008e3:	68 b4 29 80 00       	push   $0x8029b4
  8008e8:	e8 88 fe ff ff       	call   800775 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8008ed:	ff 45 f0             	incl   -0x10(%ebp)
  8008f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008f3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8008f6:	0f 8c 2f ff ff ff    	jl     80082b <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8008fc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800903:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80090a:	eb 26                	jmp    800932 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80090c:	a1 24 40 80 00       	mov    0x804024,%eax
  800911:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800917:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80091a:	89 d0                	mov    %edx,%eax
  80091c:	01 c0                	add    %eax,%eax
  80091e:	01 d0                	add    %edx,%eax
  800920:	c1 e0 03             	shl    $0x3,%eax
  800923:	01 c8                	add    %ecx,%eax
  800925:	8a 40 04             	mov    0x4(%eax),%al
  800928:	3c 01                	cmp    $0x1,%al
  80092a:	75 03                	jne    80092f <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80092c:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80092f:	ff 45 e0             	incl   -0x20(%ebp)
  800932:	a1 24 40 80 00       	mov    0x804024,%eax
  800937:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80093d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800940:	39 c2                	cmp    %eax,%edx
  800942:	77 c8                	ja     80090c <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800944:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800947:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80094a:	74 14                	je     800960 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80094c:	83 ec 04             	sub    $0x4,%esp
  80094f:	68 14 2a 80 00       	push   $0x802a14
  800954:	6a 44                	push   $0x44
  800956:	68 b4 29 80 00       	push   $0x8029b4
  80095b:	e8 15 fe ff ff       	call   800775 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800960:	90                   	nop
  800961:	c9                   	leave  
  800962:	c3                   	ret    

00800963 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800963:	55                   	push   %ebp
  800964:	89 e5                	mov    %esp,%ebp
  800966:	53                   	push   %ebx
  800967:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  80096a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80096d:	8b 00                	mov    (%eax),%eax
  80096f:	8d 48 01             	lea    0x1(%eax),%ecx
  800972:	8b 55 0c             	mov    0xc(%ebp),%edx
  800975:	89 0a                	mov    %ecx,(%edx)
  800977:	8b 55 08             	mov    0x8(%ebp),%edx
  80097a:	88 d1                	mov    %dl,%cl
  80097c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80097f:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800983:	8b 45 0c             	mov    0xc(%ebp),%eax
  800986:	8b 00                	mov    (%eax),%eax
  800988:	3d ff 00 00 00       	cmp    $0xff,%eax
  80098d:	75 30                	jne    8009bf <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  80098f:	8b 15 1c c1 81 00    	mov    0x81c11c,%edx
  800995:	a0 44 40 80 00       	mov    0x804044,%al
  80099a:	0f b6 c0             	movzbl %al,%eax
  80099d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009a0:	8b 09                	mov    (%ecx),%ecx
  8009a2:	89 cb                	mov    %ecx,%ebx
  8009a4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009a7:	83 c1 08             	add    $0x8,%ecx
  8009aa:	52                   	push   %edx
  8009ab:	50                   	push   %eax
  8009ac:	53                   	push   %ebx
  8009ad:	51                   	push   %ecx
  8009ae:	e8 5f 13 00 00       	call   801d12 <sys_cputs>
  8009b3:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8009b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8009bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009c2:	8b 40 04             	mov    0x4(%eax),%eax
  8009c5:	8d 50 01             	lea    0x1(%eax),%edx
  8009c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009cb:	89 50 04             	mov    %edx,0x4(%eax)
}
  8009ce:	90                   	nop
  8009cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009d2:	c9                   	leave  
  8009d3:	c3                   	ret    

008009d4 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8009d4:	55                   	push   %ebp
  8009d5:	89 e5                	mov    %esp,%ebp
  8009d7:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8009dd:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8009e4:	00 00 00 
	b.cnt = 0;
  8009e7:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8009ee:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8009f1:	ff 75 0c             	pushl  0xc(%ebp)
  8009f4:	ff 75 08             	pushl  0x8(%ebp)
  8009f7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009fd:	50                   	push   %eax
  8009fe:	68 63 09 80 00       	push   $0x800963
  800a03:	e8 5a 02 00 00       	call   800c62 <vprintfmt>
  800a08:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800a0b:	8b 15 1c c1 81 00    	mov    0x81c11c,%edx
  800a11:	a0 44 40 80 00       	mov    0x804044,%al
  800a16:	0f b6 c0             	movzbl %al,%eax
  800a19:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800a1f:	52                   	push   %edx
  800a20:	50                   	push   %eax
  800a21:	51                   	push   %ecx
  800a22:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a28:	83 c0 08             	add    $0x8,%eax
  800a2b:	50                   	push   %eax
  800a2c:	e8 e1 12 00 00       	call   801d12 <sys_cputs>
  800a31:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800a34:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
	return b.cnt;
  800a3b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a41:	c9                   	leave  
  800a42:	c3                   	ret    

00800a43 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800a43:	55                   	push   %ebp
  800a44:	89 e5                	mov    %esp,%ebp
  800a46:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a49:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	va_start(ap, fmt);
  800a50:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a53:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a56:	8b 45 08             	mov    0x8(%ebp),%eax
  800a59:	83 ec 08             	sub    $0x8,%esp
  800a5c:	ff 75 f4             	pushl  -0xc(%ebp)
  800a5f:	50                   	push   %eax
  800a60:	e8 6f ff ff ff       	call   8009d4 <vcprintf>
  800a65:	83 c4 10             	add    $0x10,%esp
  800a68:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a6e:	c9                   	leave  
  800a6f:	c3                   	ret    

00800a70 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800a70:	55                   	push   %ebp
  800a71:	89 e5                	mov    %esp,%ebp
  800a73:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a76:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800a7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a80:	c1 e0 08             	shl    $0x8,%eax
  800a83:	a3 1c c1 81 00       	mov    %eax,0x81c11c
	va_start(ap, fmt);
  800a88:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a8b:	83 c0 04             	add    $0x4,%eax
  800a8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a94:	83 ec 08             	sub    $0x8,%esp
  800a97:	ff 75 f4             	pushl  -0xc(%ebp)
  800a9a:	50                   	push   %eax
  800a9b:	e8 34 ff ff ff       	call   8009d4 <vcprintf>
  800aa0:	83 c4 10             	add    $0x10,%esp
  800aa3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800aa6:	c7 05 1c c1 81 00 00 	movl   $0x700,0x81c11c
  800aad:	07 00 00 

	return cnt;
  800ab0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ab3:	c9                   	leave  
  800ab4:	c3                   	ret    

00800ab5 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800ab5:	55                   	push   %ebp
  800ab6:	89 e5                	mov    %esp,%ebp
  800ab8:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800abb:	e8 96 12 00 00       	call   801d56 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800ac0:	8d 45 0c             	lea    0xc(%ebp),%eax
  800ac3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac9:	83 ec 08             	sub    $0x8,%esp
  800acc:	ff 75 f4             	pushl  -0xc(%ebp)
  800acf:	50                   	push   %eax
  800ad0:	e8 ff fe ff ff       	call   8009d4 <vcprintf>
  800ad5:	83 c4 10             	add    $0x10,%esp
  800ad8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800adb:	e8 90 12 00 00       	call   801d70 <sys_unlock_cons>
	return cnt;
  800ae0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ae3:	c9                   	leave  
  800ae4:	c3                   	ret    

00800ae5 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800ae5:	55                   	push   %ebp
  800ae6:	89 e5                	mov    %esp,%ebp
  800ae8:	53                   	push   %ebx
  800ae9:	83 ec 14             	sub    $0x14,%esp
  800aec:	8b 45 10             	mov    0x10(%ebp),%eax
  800aef:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800af2:	8b 45 14             	mov    0x14(%ebp),%eax
  800af5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800af8:	8b 45 18             	mov    0x18(%ebp),%eax
  800afb:	ba 00 00 00 00       	mov    $0x0,%edx
  800b00:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b03:	77 55                	ja     800b5a <printnum+0x75>
  800b05:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b08:	72 05                	jb     800b0f <printnum+0x2a>
  800b0a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800b0d:	77 4b                	ja     800b5a <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800b0f:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800b12:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800b15:	8b 45 18             	mov    0x18(%ebp),%eax
  800b18:	ba 00 00 00 00       	mov    $0x0,%edx
  800b1d:	52                   	push   %edx
  800b1e:	50                   	push   %eax
  800b1f:	ff 75 f4             	pushl  -0xc(%ebp)
  800b22:	ff 75 f0             	pushl  -0x10(%ebp)
  800b25:	e8 b2 18 00 00       	call   8023dc <__udivdi3>
  800b2a:	83 c4 10             	add    $0x10,%esp
  800b2d:	83 ec 04             	sub    $0x4,%esp
  800b30:	ff 75 20             	pushl  0x20(%ebp)
  800b33:	53                   	push   %ebx
  800b34:	ff 75 18             	pushl  0x18(%ebp)
  800b37:	52                   	push   %edx
  800b38:	50                   	push   %eax
  800b39:	ff 75 0c             	pushl  0xc(%ebp)
  800b3c:	ff 75 08             	pushl  0x8(%ebp)
  800b3f:	e8 a1 ff ff ff       	call   800ae5 <printnum>
  800b44:	83 c4 20             	add    $0x20,%esp
  800b47:	eb 1a                	jmp    800b63 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800b49:	83 ec 08             	sub    $0x8,%esp
  800b4c:	ff 75 0c             	pushl  0xc(%ebp)
  800b4f:	ff 75 20             	pushl  0x20(%ebp)
  800b52:	8b 45 08             	mov    0x8(%ebp),%eax
  800b55:	ff d0                	call   *%eax
  800b57:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800b5a:	ff 4d 1c             	decl   0x1c(%ebp)
  800b5d:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800b61:	7f e6                	jg     800b49 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800b63:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800b66:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b6e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b71:	53                   	push   %ebx
  800b72:	51                   	push   %ecx
  800b73:	52                   	push   %edx
  800b74:	50                   	push   %eax
  800b75:	e8 72 19 00 00       	call   8024ec <__umoddi3>
  800b7a:	83 c4 10             	add    $0x10,%esp
  800b7d:	05 74 2c 80 00       	add    $0x802c74,%eax
  800b82:	8a 00                	mov    (%eax),%al
  800b84:	0f be c0             	movsbl %al,%eax
  800b87:	83 ec 08             	sub    $0x8,%esp
  800b8a:	ff 75 0c             	pushl  0xc(%ebp)
  800b8d:	50                   	push   %eax
  800b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b91:	ff d0                	call   *%eax
  800b93:	83 c4 10             	add    $0x10,%esp
}
  800b96:	90                   	nop
  800b97:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b9a:	c9                   	leave  
  800b9b:	c3                   	ret    

00800b9c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b9c:	55                   	push   %ebp
  800b9d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b9f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800ba3:	7e 1c                	jle    800bc1 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800ba5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba8:	8b 00                	mov    (%eax),%eax
  800baa:	8d 50 08             	lea    0x8(%eax),%edx
  800bad:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb0:	89 10                	mov    %edx,(%eax)
  800bb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb5:	8b 00                	mov    (%eax),%eax
  800bb7:	83 e8 08             	sub    $0x8,%eax
  800bba:	8b 50 04             	mov    0x4(%eax),%edx
  800bbd:	8b 00                	mov    (%eax),%eax
  800bbf:	eb 40                	jmp    800c01 <getuint+0x65>
	else if (lflag)
  800bc1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bc5:	74 1e                	je     800be5 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bca:	8b 00                	mov    (%eax),%eax
  800bcc:	8d 50 04             	lea    0x4(%eax),%edx
  800bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd2:	89 10                	mov    %edx,(%eax)
  800bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd7:	8b 00                	mov    (%eax),%eax
  800bd9:	83 e8 04             	sub    $0x4,%eax
  800bdc:	8b 00                	mov    (%eax),%eax
  800bde:	ba 00 00 00 00       	mov    $0x0,%edx
  800be3:	eb 1c                	jmp    800c01 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800be5:	8b 45 08             	mov    0x8(%ebp),%eax
  800be8:	8b 00                	mov    (%eax),%eax
  800bea:	8d 50 04             	lea    0x4(%eax),%edx
  800bed:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf0:	89 10                	mov    %edx,(%eax)
  800bf2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf5:	8b 00                	mov    (%eax),%eax
  800bf7:	83 e8 04             	sub    $0x4,%eax
  800bfa:	8b 00                	mov    (%eax),%eax
  800bfc:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800c01:	5d                   	pop    %ebp
  800c02:	c3                   	ret    

00800c03 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800c03:	55                   	push   %ebp
  800c04:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c06:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c0a:	7e 1c                	jle    800c28 <getint+0x25>
		return va_arg(*ap, long long);
  800c0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0f:	8b 00                	mov    (%eax),%eax
  800c11:	8d 50 08             	lea    0x8(%eax),%edx
  800c14:	8b 45 08             	mov    0x8(%ebp),%eax
  800c17:	89 10                	mov    %edx,(%eax)
  800c19:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1c:	8b 00                	mov    (%eax),%eax
  800c1e:	83 e8 08             	sub    $0x8,%eax
  800c21:	8b 50 04             	mov    0x4(%eax),%edx
  800c24:	8b 00                	mov    (%eax),%eax
  800c26:	eb 38                	jmp    800c60 <getint+0x5d>
	else if (lflag)
  800c28:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c2c:	74 1a                	je     800c48 <getint+0x45>
		return va_arg(*ap, long);
  800c2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c31:	8b 00                	mov    (%eax),%eax
  800c33:	8d 50 04             	lea    0x4(%eax),%edx
  800c36:	8b 45 08             	mov    0x8(%ebp),%eax
  800c39:	89 10                	mov    %edx,(%eax)
  800c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3e:	8b 00                	mov    (%eax),%eax
  800c40:	83 e8 04             	sub    $0x4,%eax
  800c43:	8b 00                	mov    (%eax),%eax
  800c45:	99                   	cltd   
  800c46:	eb 18                	jmp    800c60 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800c48:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4b:	8b 00                	mov    (%eax),%eax
  800c4d:	8d 50 04             	lea    0x4(%eax),%edx
  800c50:	8b 45 08             	mov    0x8(%ebp),%eax
  800c53:	89 10                	mov    %edx,(%eax)
  800c55:	8b 45 08             	mov    0x8(%ebp),%eax
  800c58:	8b 00                	mov    (%eax),%eax
  800c5a:	83 e8 04             	sub    $0x4,%eax
  800c5d:	8b 00                	mov    (%eax),%eax
  800c5f:	99                   	cltd   
}
  800c60:	5d                   	pop    %ebp
  800c61:	c3                   	ret    

00800c62 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800c62:	55                   	push   %ebp
  800c63:	89 e5                	mov    %esp,%ebp
  800c65:	56                   	push   %esi
  800c66:	53                   	push   %ebx
  800c67:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c6a:	eb 17                	jmp    800c83 <vprintfmt+0x21>
			if (ch == '\0')
  800c6c:	85 db                	test   %ebx,%ebx
  800c6e:	0f 84 c1 03 00 00    	je     801035 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800c74:	83 ec 08             	sub    $0x8,%esp
  800c77:	ff 75 0c             	pushl  0xc(%ebp)
  800c7a:	53                   	push   %ebx
  800c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7e:	ff d0                	call   *%eax
  800c80:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c83:	8b 45 10             	mov    0x10(%ebp),%eax
  800c86:	8d 50 01             	lea    0x1(%eax),%edx
  800c89:	89 55 10             	mov    %edx,0x10(%ebp)
  800c8c:	8a 00                	mov    (%eax),%al
  800c8e:	0f b6 d8             	movzbl %al,%ebx
  800c91:	83 fb 25             	cmp    $0x25,%ebx
  800c94:	75 d6                	jne    800c6c <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c96:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800c9a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800ca1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800ca8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800caf:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800cb6:	8b 45 10             	mov    0x10(%ebp),%eax
  800cb9:	8d 50 01             	lea    0x1(%eax),%edx
  800cbc:	89 55 10             	mov    %edx,0x10(%ebp)
  800cbf:	8a 00                	mov    (%eax),%al
  800cc1:	0f b6 d8             	movzbl %al,%ebx
  800cc4:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800cc7:	83 f8 5b             	cmp    $0x5b,%eax
  800cca:	0f 87 3d 03 00 00    	ja     80100d <vprintfmt+0x3ab>
  800cd0:	8b 04 85 98 2c 80 00 	mov    0x802c98(,%eax,4),%eax
  800cd7:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800cd9:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800cdd:	eb d7                	jmp    800cb6 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800cdf:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800ce3:	eb d1                	jmp    800cb6 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ce5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800cec:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800cef:	89 d0                	mov    %edx,%eax
  800cf1:	c1 e0 02             	shl    $0x2,%eax
  800cf4:	01 d0                	add    %edx,%eax
  800cf6:	01 c0                	add    %eax,%eax
  800cf8:	01 d8                	add    %ebx,%eax
  800cfa:	83 e8 30             	sub    $0x30,%eax
  800cfd:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800d00:	8b 45 10             	mov    0x10(%ebp),%eax
  800d03:	8a 00                	mov    (%eax),%al
  800d05:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800d08:	83 fb 2f             	cmp    $0x2f,%ebx
  800d0b:	7e 3e                	jle    800d4b <vprintfmt+0xe9>
  800d0d:	83 fb 39             	cmp    $0x39,%ebx
  800d10:	7f 39                	jg     800d4b <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d12:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800d15:	eb d5                	jmp    800cec <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800d17:	8b 45 14             	mov    0x14(%ebp),%eax
  800d1a:	83 c0 04             	add    $0x4,%eax
  800d1d:	89 45 14             	mov    %eax,0x14(%ebp)
  800d20:	8b 45 14             	mov    0x14(%ebp),%eax
  800d23:	83 e8 04             	sub    $0x4,%eax
  800d26:	8b 00                	mov    (%eax),%eax
  800d28:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800d2b:	eb 1f                	jmp    800d4c <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800d2d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d31:	79 83                	jns    800cb6 <vprintfmt+0x54>
				width = 0;
  800d33:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800d3a:	e9 77 ff ff ff       	jmp    800cb6 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800d3f:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800d46:	e9 6b ff ff ff       	jmp    800cb6 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800d4b:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800d4c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d50:	0f 89 60 ff ff ff    	jns    800cb6 <vprintfmt+0x54>
				width = precision, precision = -1;
  800d56:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d59:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d5c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800d63:	e9 4e ff ff ff       	jmp    800cb6 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d68:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800d6b:	e9 46 ff ff ff       	jmp    800cb6 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800d70:	8b 45 14             	mov    0x14(%ebp),%eax
  800d73:	83 c0 04             	add    $0x4,%eax
  800d76:	89 45 14             	mov    %eax,0x14(%ebp)
  800d79:	8b 45 14             	mov    0x14(%ebp),%eax
  800d7c:	83 e8 04             	sub    $0x4,%eax
  800d7f:	8b 00                	mov    (%eax),%eax
  800d81:	83 ec 08             	sub    $0x8,%esp
  800d84:	ff 75 0c             	pushl  0xc(%ebp)
  800d87:	50                   	push   %eax
  800d88:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8b:	ff d0                	call   *%eax
  800d8d:	83 c4 10             	add    $0x10,%esp
			break;
  800d90:	e9 9b 02 00 00       	jmp    801030 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800d95:	8b 45 14             	mov    0x14(%ebp),%eax
  800d98:	83 c0 04             	add    $0x4,%eax
  800d9b:	89 45 14             	mov    %eax,0x14(%ebp)
  800d9e:	8b 45 14             	mov    0x14(%ebp),%eax
  800da1:	83 e8 04             	sub    $0x4,%eax
  800da4:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800da6:	85 db                	test   %ebx,%ebx
  800da8:	79 02                	jns    800dac <vprintfmt+0x14a>
				err = -err;
  800daa:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800dac:	83 fb 64             	cmp    $0x64,%ebx
  800daf:	7f 0b                	jg     800dbc <vprintfmt+0x15a>
  800db1:	8b 34 9d e0 2a 80 00 	mov    0x802ae0(,%ebx,4),%esi
  800db8:	85 f6                	test   %esi,%esi
  800dba:	75 19                	jne    800dd5 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800dbc:	53                   	push   %ebx
  800dbd:	68 85 2c 80 00       	push   $0x802c85
  800dc2:	ff 75 0c             	pushl  0xc(%ebp)
  800dc5:	ff 75 08             	pushl  0x8(%ebp)
  800dc8:	e8 70 02 00 00       	call   80103d <printfmt>
  800dcd:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800dd0:	e9 5b 02 00 00       	jmp    801030 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800dd5:	56                   	push   %esi
  800dd6:	68 8e 2c 80 00       	push   $0x802c8e
  800ddb:	ff 75 0c             	pushl  0xc(%ebp)
  800dde:	ff 75 08             	pushl  0x8(%ebp)
  800de1:	e8 57 02 00 00       	call   80103d <printfmt>
  800de6:	83 c4 10             	add    $0x10,%esp
			break;
  800de9:	e9 42 02 00 00       	jmp    801030 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800dee:	8b 45 14             	mov    0x14(%ebp),%eax
  800df1:	83 c0 04             	add    $0x4,%eax
  800df4:	89 45 14             	mov    %eax,0x14(%ebp)
  800df7:	8b 45 14             	mov    0x14(%ebp),%eax
  800dfa:	83 e8 04             	sub    $0x4,%eax
  800dfd:	8b 30                	mov    (%eax),%esi
  800dff:	85 f6                	test   %esi,%esi
  800e01:	75 05                	jne    800e08 <vprintfmt+0x1a6>
				p = "(null)";
  800e03:	be 91 2c 80 00       	mov    $0x802c91,%esi
			if (width > 0 && padc != '-')
  800e08:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e0c:	7e 6d                	jle    800e7b <vprintfmt+0x219>
  800e0e:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800e12:	74 67                	je     800e7b <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e14:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e17:	83 ec 08             	sub    $0x8,%esp
  800e1a:	50                   	push   %eax
  800e1b:	56                   	push   %esi
  800e1c:	e8 26 05 00 00       	call   801347 <strnlen>
  800e21:	83 c4 10             	add    $0x10,%esp
  800e24:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800e27:	eb 16                	jmp    800e3f <vprintfmt+0x1dd>
					putch(padc, putdat);
  800e29:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800e2d:	83 ec 08             	sub    $0x8,%esp
  800e30:	ff 75 0c             	pushl  0xc(%ebp)
  800e33:	50                   	push   %eax
  800e34:	8b 45 08             	mov    0x8(%ebp),%eax
  800e37:	ff d0                	call   *%eax
  800e39:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e3c:	ff 4d e4             	decl   -0x1c(%ebp)
  800e3f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e43:	7f e4                	jg     800e29 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e45:	eb 34                	jmp    800e7b <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800e47:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800e4b:	74 1c                	je     800e69 <vprintfmt+0x207>
  800e4d:	83 fb 1f             	cmp    $0x1f,%ebx
  800e50:	7e 05                	jle    800e57 <vprintfmt+0x1f5>
  800e52:	83 fb 7e             	cmp    $0x7e,%ebx
  800e55:	7e 12                	jle    800e69 <vprintfmt+0x207>
					putch('?', putdat);
  800e57:	83 ec 08             	sub    $0x8,%esp
  800e5a:	ff 75 0c             	pushl  0xc(%ebp)
  800e5d:	6a 3f                	push   $0x3f
  800e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e62:	ff d0                	call   *%eax
  800e64:	83 c4 10             	add    $0x10,%esp
  800e67:	eb 0f                	jmp    800e78 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800e69:	83 ec 08             	sub    $0x8,%esp
  800e6c:	ff 75 0c             	pushl  0xc(%ebp)
  800e6f:	53                   	push   %ebx
  800e70:	8b 45 08             	mov    0x8(%ebp),%eax
  800e73:	ff d0                	call   *%eax
  800e75:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e78:	ff 4d e4             	decl   -0x1c(%ebp)
  800e7b:	89 f0                	mov    %esi,%eax
  800e7d:	8d 70 01             	lea    0x1(%eax),%esi
  800e80:	8a 00                	mov    (%eax),%al
  800e82:	0f be d8             	movsbl %al,%ebx
  800e85:	85 db                	test   %ebx,%ebx
  800e87:	74 24                	je     800ead <vprintfmt+0x24b>
  800e89:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e8d:	78 b8                	js     800e47 <vprintfmt+0x1e5>
  800e8f:	ff 4d e0             	decl   -0x20(%ebp)
  800e92:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e96:	79 af                	jns    800e47 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e98:	eb 13                	jmp    800ead <vprintfmt+0x24b>
				putch(' ', putdat);
  800e9a:	83 ec 08             	sub    $0x8,%esp
  800e9d:	ff 75 0c             	pushl  0xc(%ebp)
  800ea0:	6a 20                	push   $0x20
  800ea2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea5:	ff d0                	call   *%eax
  800ea7:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800eaa:	ff 4d e4             	decl   -0x1c(%ebp)
  800ead:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800eb1:	7f e7                	jg     800e9a <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800eb3:	e9 78 01 00 00       	jmp    801030 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800eb8:	83 ec 08             	sub    $0x8,%esp
  800ebb:	ff 75 e8             	pushl  -0x18(%ebp)
  800ebe:	8d 45 14             	lea    0x14(%ebp),%eax
  800ec1:	50                   	push   %eax
  800ec2:	e8 3c fd ff ff       	call   800c03 <getint>
  800ec7:	83 c4 10             	add    $0x10,%esp
  800eca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ecd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800ed0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ed3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ed6:	85 d2                	test   %edx,%edx
  800ed8:	79 23                	jns    800efd <vprintfmt+0x29b>
				putch('-', putdat);
  800eda:	83 ec 08             	sub    $0x8,%esp
  800edd:	ff 75 0c             	pushl  0xc(%ebp)
  800ee0:	6a 2d                	push   $0x2d
  800ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee5:	ff d0                	call   *%eax
  800ee7:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800eea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ef0:	f7 d8                	neg    %eax
  800ef2:	83 d2 00             	adc    $0x0,%edx
  800ef5:	f7 da                	neg    %edx
  800ef7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800efa:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800efd:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f04:	e9 bc 00 00 00       	jmp    800fc5 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800f09:	83 ec 08             	sub    $0x8,%esp
  800f0c:	ff 75 e8             	pushl  -0x18(%ebp)
  800f0f:	8d 45 14             	lea    0x14(%ebp),%eax
  800f12:	50                   	push   %eax
  800f13:	e8 84 fc ff ff       	call   800b9c <getuint>
  800f18:	83 c4 10             	add    $0x10,%esp
  800f1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f1e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800f21:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f28:	e9 98 00 00 00       	jmp    800fc5 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800f2d:	83 ec 08             	sub    $0x8,%esp
  800f30:	ff 75 0c             	pushl  0xc(%ebp)
  800f33:	6a 58                	push   $0x58
  800f35:	8b 45 08             	mov    0x8(%ebp),%eax
  800f38:	ff d0                	call   *%eax
  800f3a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f3d:	83 ec 08             	sub    $0x8,%esp
  800f40:	ff 75 0c             	pushl  0xc(%ebp)
  800f43:	6a 58                	push   $0x58
  800f45:	8b 45 08             	mov    0x8(%ebp),%eax
  800f48:	ff d0                	call   *%eax
  800f4a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f4d:	83 ec 08             	sub    $0x8,%esp
  800f50:	ff 75 0c             	pushl  0xc(%ebp)
  800f53:	6a 58                	push   $0x58
  800f55:	8b 45 08             	mov    0x8(%ebp),%eax
  800f58:	ff d0                	call   *%eax
  800f5a:	83 c4 10             	add    $0x10,%esp
			break;
  800f5d:	e9 ce 00 00 00       	jmp    801030 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800f62:	83 ec 08             	sub    $0x8,%esp
  800f65:	ff 75 0c             	pushl  0xc(%ebp)
  800f68:	6a 30                	push   $0x30
  800f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6d:	ff d0                	call   *%eax
  800f6f:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800f72:	83 ec 08             	sub    $0x8,%esp
  800f75:	ff 75 0c             	pushl  0xc(%ebp)
  800f78:	6a 78                	push   $0x78
  800f7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7d:	ff d0                	call   *%eax
  800f7f:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800f82:	8b 45 14             	mov    0x14(%ebp),%eax
  800f85:	83 c0 04             	add    $0x4,%eax
  800f88:	89 45 14             	mov    %eax,0x14(%ebp)
  800f8b:	8b 45 14             	mov    0x14(%ebp),%eax
  800f8e:	83 e8 04             	sub    $0x4,%eax
  800f91:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f93:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f96:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800f9d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800fa4:	eb 1f                	jmp    800fc5 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800fa6:	83 ec 08             	sub    $0x8,%esp
  800fa9:	ff 75 e8             	pushl  -0x18(%ebp)
  800fac:	8d 45 14             	lea    0x14(%ebp),%eax
  800faf:	50                   	push   %eax
  800fb0:	e8 e7 fb ff ff       	call   800b9c <getuint>
  800fb5:	83 c4 10             	add    $0x10,%esp
  800fb8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fbb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800fbe:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800fc5:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800fc9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800fcc:	83 ec 04             	sub    $0x4,%esp
  800fcf:	52                   	push   %edx
  800fd0:	ff 75 e4             	pushl  -0x1c(%ebp)
  800fd3:	50                   	push   %eax
  800fd4:	ff 75 f4             	pushl  -0xc(%ebp)
  800fd7:	ff 75 f0             	pushl  -0x10(%ebp)
  800fda:	ff 75 0c             	pushl  0xc(%ebp)
  800fdd:	ff 75 08             	pushl  0x8(%ebp)
  800fe0:	e8 00 fb ff ff       	call   800ae5 <printnum>
  800fe5:	83 c4 20             	add    $0x20,%esp
			break;
  800fe8:	eb 46                	jmp    801030 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800fea:	83 ec 08             	sub    $0x8,%esp
  800fed:	ff 75 0c             	pushl  0xc(%ebp)
  800ff0:	53                   	push   %ebx
  800ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff4:	ff d0                	call   *%eax
  800ff6:	83 c4 10             	add    $0x10,%esp
			break;
  800ff9:	eb 35                	jmp    801030 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800ffb:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
			break;
  801002:	eb 2c                	jmp    801030 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  801004:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
			break;
  80100b:	eb 23                	jmp    801030 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80100d:	83 ec 08             	sub    $0x8,%esp
  801010:	ff 75 0c             	pushl  0xc(%ebp)
  801013:	6a 25                	push   $0x25
  801015:	8b 45 08             	mov    0x8(%ebp),%eax
  801018:	ff d0                	call   *%eax
  80101a:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80101d:	ff 4d 10             	decl   0x10(%ebp)
  801020:	eb 03                	jmp    801025 <vprintfmt+0x3c3>
  801022:	ff 4d 10             	decl   0x10(%ebp)
  801025:	8b 45 10             	mov    0x10(%ebp),%eax
  801028:	48                   	dec    %eax
  801029:	8a 00                	mov    (%eax),%al
  80102b:	3c 25                	cmp    $0x25,%al
  80102d:	75 f3                	jne    801022 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  80102f:	90                   	nop
		}
	}
  801030:	e9 35 fc ff ff       	jmp    800c6a <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801035:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801036:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801039:	5b                   	pop    %ebx
  80103a:	5e                   	pop    %esi
  80103b:	5d                   	pop    %ebp
  80103c:	c3                   	ret    

0080103d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80103d:	55                   	push   %ebp
  80103e:	89 e5                	mov    %esp,%ebp
  801040:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801043:	8d 45 10             	lea    0x10(%ebp),%eax
  801046:	83 c0 04             	add    $0x4,%eax
  801049:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80104c:	8b 45 10             	mov    0x10(%ebp),%eax
  80104f:	ff 75 f4             	pushl  -0xc(%ebp)
  801052:	50                   	push   %eax
  801053:	ff 75 0c             	pushl  0xc(%ebp)
  801056:	ff 75 08             	pushl  0x8(%ebp)
  801059:	e8 04 fc ff ff       	call   800c62 <vprintfmt>
  80105e:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801061:	90                   	nop
  801062:	c9                   	leave  
  801063:	c3                   	ret    

00801064 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801064:	55                   	push   %ebp
  801065:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801067:	8b 45 0c             	mov    0xc(%ebp),%eax
  80106a:	8b 40 08             	mov    0x8(%eax),%eax
  80106d:	8d 50 01             	lea    0x1(%eax),%edx
  801070:	8b 45 0c             	mov    0xc(%ebp),%eax
  801073:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801076:	8b 45 0c             	mov    0xc(%ebp),%eax
  801079:	8b 10                	mov    (%eax),%edx
  80107b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107e:	8b 40 04             	mov    0x4(%eax),%eax
  801081:	39 c2                	cmp    %eax,%edx
  801083:	73 12                	jae    801097 <sprintputch+0x33>
		*b->buf++ = ch;
  801085:	8b 45 0c             	mov    0xc(%ebp),%eax
  801088:	8b 00                	mov    (%eax),%eax
  80108a:	8d 48 01             	lea    0x1(%eax),%ecx
  80108d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801090:	89 0a                	mov    %ecx,(%edx)
  801092:	8b 55 08             	mov    0x8(%ebp),%edx
  801095:	88 10                	mov    %dl,(%eax)
}
  801097:	90                   	nop
  801098:	5d                   	pop    %ebp
  801099:	c3                   	ret    

0080109a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80109a:	55                   	push   %ebp
  80109b:	89 e5                	mov    %esp,%ebp
  80109d:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8010a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8010a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8010af:	01 d0                	add    %edx,%eax
  8010b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010b4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8010bb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010bf:	74 06                	je     8010c7 <vsnprintf+0x2d>
  8010c1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010c5:	7f 07                	jg     8010ce <vsnprintf+0x34>
		return -E_INVAL;
  8010c7:	b8 03 00 00 00       	mov    $0x3,%eax
  8010cc:	eb 20                	jmp    8010ee <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8010ce:	ff 75 14             	pushl  0x14(%ebp)
  8010d1:	ff 75 10             	pushl  0x10(%ebp)
  8010d4:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8010d7:	50                   	push   %eax
  8010d8:	68 64 10 80 00       	push   $0x801064
  8010dd:	e8 80 fb ff ff       	call   800c62 <vprintfmt>
  8010e2:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8010e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8010e8:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8010eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8010ee:	c9                   	leave  
  8010ef:	c3                   	ret    

008010f0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8010f0:	55                   	push   %ebp
  8010f1:	89 e5                	mov    %esp,%ebp
  8010f3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8010f6:	8d 45 10             	lea    0x10(%ebp),%eax
  8010f9:	83 c0 04             	add    $0x4,%eax
  8010fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8010ff:	8b 45 10             	mov    0x10(%ebp),%eax
  801102:	ff 75 f4             	pushl  -0xc(%ebp)
  801105:	50                   	push   %eax
  801106:	ff 75 0c             	pushl  0xc(%ebp)
  801109:	ff 75 08             	pushl  0x8(%ebp)
  80110c:	e8 89 ff ff ff       	call   80109a <vsnprintf>
  801111:	83 c4 10             	add    $0x10,%esp
  801114:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801117:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80111a:	c9                   	leave  
  80111b:	c3                   	ret    

0080111c <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  80111c:	55                   	push   %ebp
  80111d:	89 e5                	mov    %esp,%ebp
  80111f:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  801122:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801126:	74 13                	je     80113b <readline+0x1f>
		cprintf("%s", prompt);
  801128:	83 ec 08             	sub    $0x8,%esp
  80112b:	ff 75 08             	pushl  0x8(%ebp)
  80112e:	68 08 2e 80 00       	push   $0x802e08
  801133:	e8 0b f9 ff ff       	call   800a43 <cprintf>
  801138:	83 c4 10             	add    $0x10,%esp

	i = 0;
  80113b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801142:	83 ec 0c             	sub    $0xc,%esp
  801145:	6a 00                	push   $0x0
  801147:	e8 6f f4 ff ff       	call   8005bb <iscons>
  80114c:	83 c4 10             	add    $0x10,%esp
  80114f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801152:	e8 51 f4 ff ff       	call   8005a8 <getchar>
  801157:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  80115a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80115e:	79 22                	jns    801182 <readline+0x66>
			if (c != -E_EOF)
  801160:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801164:	0f 84 ad 00 00 00    	je     801217 <readline+0xfb>
				cprintf("read error: %e\n", c);
  80116a:	83 ec 08             	sub    $0x8,%esp
  80116d:	ff 75 ec             	pushl  -0x14(%ebp)
  801170:	68 0b 2e 80 00       	push   $0x802e0b
  801175:	e8 c9 f8 ff ff       	call   800a43 <cprintf>
  80117a:	83 c4 10             	add    $0x10,%esp
			break;
  80117d:	e9 95 00 00 00       	jmp    801217 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801182:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801186:	7e 34                	jle    8011bc <readline+0xa0>
  801188:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80118f:	7f 2b                	jg     8011bc <readline+0xa0>
			if (echoing)
  801191:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801195:	74 0e                	je     8011a5 <readline+0x89>
				cputchar(c);
  801197:	83 ec 0c             	sub    $0xc,%esp
  80119a:	ff 75 ec             	pushl  -0x14(%ebp)
  80119d:	e8 e7 f3 ff ff       	call   800589 <cputchar>
  8011a2:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  8011a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011a8:	8d 50 01             	lea    0x1(%eax),%edx
  8011ab:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8011ae:	89 c2                	mov    %eax,%edx
  8011b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b3:	01 d0                	add    %edx,%eax
  8011b5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011b8:	88 10                	mov    %dl,(%eax)
  8011ba:	eb 56                	jmp    801212 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  8011bc:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8011c0:	75 1f                	jne    8011e1 <readline+0xc5>
  8011c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8011c6:	7e 19                	jle    8011e1 <readline+0xc5>
			if (echoing)
  8011c8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8011cc:	74 0e                	je     8011dc <readline+0xc0>
				cputchar(c);
  8011ce:	83 ec 0c             	sub    $0xc,%esp
  8011d1:	ff 75 ec             	pushl  -0x14(%ebp)
  8011d4:	e8 b0 f3 ff ff       	call   800589 <cputchar>
  8011d9:	83 c4 10             	add    $0x10,%esp

			i--;
  8011dc:	ff 4d f4             	decl   -0xc(%ebp)
  8011df:	eb 31                	jmp    801212 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  8011e1:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8011e5:	74 0a                	je     8011f1 <readline+0xd5>
  8011e7:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8011eb:	0f 85 61 ff ff ff    	jne    801152 <readline+0x36>
			if (echoing)
  8011f1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8011f5:	74 0e                	je     801205 <readline+0xe9>
				cputchar(c);
  8011f7:	83 ec 0c             	sub    $0xc,%esp
  8011fa:	ff 75 ec             	pushl  -0x14(%ebp)
  8011fd:	e8 87 f3 ff ff       	call   800589 <cputchar>
  801202:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  801205:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801208:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120b:	01 d0                	add    %edx,%eax
  80120d:	c6 00 00             	movb   $0x0,(%eax)
			break;
  801210:	eb 06                	jmp    801218 <readline+0xfc>
		}
	}
  801212:	e9 3b ff ff ff       	jmp    801152 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  801217:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  801218:	90                   	nop
  801219:	c9                   	leave  
  80121a:	c3                   	ret    

0080121b <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  80121b:	55                   	push   %ebp
  80121c:	89 e5                	mov    %esp,%ebp
  80121e:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  801221:	e8 30 0b 00 00       	call   801d56 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  801226:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80122a:	74 13                	je     80123f <atomic_readline+0x24>
			cprintf("%s", prompt);
  80122c:	83 ec 08             	sub    $0x8,%esp
  80122f:	ff 75 08             	pushl  0x8(%ebp)
  801232:	68 08 2e 80 00       	push   $0x802e08
  801237:	e8 07 f8 ff ff       	call   800a43 <cprintf>
  80123c:	83 c4 10             	add    $0x10,%esp

		i = 0;
  80123f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  801246:	83 ec 0c             	sub    $0xc,%esp
  801249:	6a 00                	push   $0x0
  80124b:	e8 6b f3 ff ff       	call   8005bb <iscons>
  801250:	83 c4 10             	add    $0x10,%esp
  801253:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  801256:	e8 4d f3 ff ff       	call   8005a8 <getchar>
  80125b:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  80125e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801262:	79 22                	jns    801286 <atomic_readline+0x6b>
				if (c != -E_EOF)
  801264:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801268:	0f 84 ad 00 00 00    	je     80131b <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  80126e:	83 ec 08             	sub    $0x8,%esp
  801271:	ff 75 ec             	pushl  -0x14(%ebp)
  801274:	68 0b 2e 80 00       	push   $0x802e0b
  801279:	e8 c5 f7 ff ff       	call   800a43 <cprintf>
  80127e:	83 c4 10             	add    $0x10,%esp
				break;
  801281:	e9 95 00 00 00       	jmp    80131b <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  801286:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  80128a:	7e 34                	jle    8012c0 <atomic_readline+0xa5>
  80128c:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801293:	7f 2b                	jg     8012c0 <atomic_readline+0xa5>
				if (echoing)
  801295:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801299:	74 0e                	je     8012a9 <atomic_readline+0x8e>
					cputchar(c);
  80129b:	83 ec 0c             	sub    $0xc,%esp
  80129e:	ff 75 ec             	pushl  -0x14(%ebp)
  8012a1:	e8 e3 f2 ff ff       	call   800589 <cputchar>
  8012a6:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  8012a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012ac:	8d 50 01             	lea    0x1(%eax),%edx
  8012af:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8012b2:	89 c2                	mov    %eax,%edx
  8012b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b7:	01 d0                	add    %edx,%eax
  8012b9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012bc:	88 10                	mov    %dl,(%eax)
  8012be:	eb 56                	jmp    801316 <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  8012c0:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8012c4:	75 1f                	jne    8012e5 <atomic_readline+0xca>
  8012c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8012ca:	7e 19                	jle    8012e5 <atomic_readline+0xca>
				if (echoing)
  8012cc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012d0:	74 0e                	je     8012e0 <atomic_readline+0xc5>
					cputchar(c);
  8012d2:	83 ec 0c             	sub    $0xc,%esp
  8012d5:	ff 75 ec             	pushl  -0x14(%ebp)
  8012d8:	e8 ac f2 ff ff       	call   800589 <cputchar>
  8012dd:	83 c4 10             	add    $0x10,%esp
				i--;
  8012e0:	ff 4d f4             	decl   -0xc(%ebp)
  8012e3:	eb 31                	jmp    801316 <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  8012e5:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8012e9:	74 0a                	je     8012f5 <atomic_readline+0xda>
  8012eb:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8012ef:	0f 85 61 ff ff ff    	jne    801256 <atomic_readline+0x3b>
				if (echoing)
  8012f5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012f9:	74 0e                	je     801309 <atomic_readline+0xee>
					cputchar(c);
  8012fb:	83 ec 0c             	sub    $0xc,%esp
  8012fe:	ff 75 ec             	pushl  -0x14(%ebp)
  801301:	e8 83 f2 ff ff       	call   800589 <cputchar>
  801306:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  801309:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80130c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80130f:	01 d0                	add    %edx,%eax
  801311:	c6 00 00             	movb   $0x0,(%eax)
				break;
  801314:	eb 06                	jmp    80131c <atomic_readline+0x101>
			}
		}
  801316:	e9 3b ff ff ff       	jmp    801256 <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  80131b:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  80131c:	e8 4f 0a 00 00       	call   801d70 <sys_unlock_cons>
}
  801321:	90                   	nop
  801322:	c9                   	leave  
  801323:	c3                   	ret    

00801324 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801324:	55                   	push   %ebp
  801325:	89 e5                	mov    %esp,%ebp
  801327:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80132a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801331:	eb 06                	jmp    801339 <strlen+0x15>
		n++;
  801333:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801336:	ff 45 08             	incl   0x8(%ebp)
  801339:	8b 45 08             	mov    0x8(%ebp),%eax
  80133c:	8a 00                	mov    (%eax),%al
  80133e:	84 c0                	test   %al,%al
  801340:	75 f1                	jne    801333 <strlen+0xf>
		n++;
	return n;
  801342:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801345:	c9                   	leave  
  801346:	c3                   	ret    

00801347 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801347:	55                   	push   %ebp
  801348:	89 e5                	mov    %esp,%ebp
  80134a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80134d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801354:	eb 09                	jmp    80135f <strnlen+0x18>
		n++;
  801356:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801359:	ff 45 08             	incl   0x8(%ebp)
  80135c:	ff 4d 0c             	decl   0xc(%ebp)
  80135f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801363:	74 09                	je     80136e <strnlen+0x27>
  801365:	8b 45 08             	mov    0x8(%ebp),%eax
  801368:	8a 00                	mov    (%eax),%al
  80136a:	84 c0                	test   %al,%al
  80136c:	75 e8                	jne    801356 <strnlen+0xf>
		n++;
	return n;
  80136e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801371:	c9                   	leave  
  801372:	c3                   	ret    

00801373 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801373:	55                   	push   %ebp
  801374:	89 e5                	mov    %esp,%ebp
  801376:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801379:	8b 45 08             	mov    0x8(%ebp),%eax
  80137c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80137f:	90                   	nop
  801380:	8b 45 08             	mov    0x8(%ebp),%eax
  801383:	8d 50 01             	lea    0x1(%eax),%edx
  801386:	89 55 08             	mov    %edx,0x8(%ebp)
  801389:	8b 55 0c             	mov    0xc(%ebp),%edx
  80138c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80138f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801392:	8a 12                	mov    (%edx),%dl
  801394:	88 10                	mov    %dl,(%eax)
  801396:	8a 00                	mov    (%eax),%al
  801398:	84 c0                	test   %al,%al
  80139a:	75 e4                	jne    801380 <strcpy+0xd>
		/* do nothing */;
	return ret;
  80139c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80139f:	c9                   	leave  
  8013a0:	c3                   	ret    

008013a1 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8013a1:	55                   	push   %ebp
  8013a2:	89 e5                	mov    %esp,%ebp
  8013a4:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8013a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013aa:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8013ad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013b4:	eb 1f                	jmp    8013d5 <strncpy+0x34>
		*dst++ = *src;
  8013b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b9:	8d 50 01             	lea    0x1(%eax),%edx
  8013bc:	89 55 08             	mov    %edx,0x8(%ebp)
  8013bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013c2:	8a 12                	mov    (%edx),%dl
  8013c4:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8013c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c9:	8a 00                	mov    (%eax),%al
  8013cb:	84 c0                	test   %al,%al
  8013cd:	74 03                	je     8013d2 <strncpy+0x31>
			src++;
  8013cf:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8013d2:	ff 45 fc             	incl   -0x4(%ebp)
  8013d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013d8:	3b 45 10             	cmp    0x10(%ebp),%eax
  8013db:	72 d9                	jb     8013b6 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8013dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8013e0:	c9                   	leave  
  8013e1:	c3                   	ret    

008013e2 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8013e2:	55                   	push   %ebp
  8013e3:	89 e5                	mov    %esp,%ebp
  8013e5:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8013e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013eb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8013ee:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013f2:	74 30                	je     801424 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8013f4:	eb 16                	jmp    80140c <strlcpy+0x2a>
			*dst++ = *src++;
  8013f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f9:	8d 50 01             	lea    0x1(%eax),%edx
  8013fc:	89 55 08             	mov    %edx,0x8(%ebp)
  8013ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801402:	8d 4a 01             	lea    0x1(%edx),%ecx
  801405:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801408:	8a 12                	mov    (%edx),%dl
  80140a:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80140c:	ff 4d 10             	decl   0x10(%ebp)
  80140f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801413:	74 09                	je     80141e <strlcpy+0x3c>
  801415:	8b 45 0c             	mov    0xc(%ebp),%eax
  801418:	8a 00                	mov    (%eax),%al
  80141a:	84 c0                	test   %al,%al
  80141c:	75 d8                	jne    8013f6 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80141e:	8b 45 08             	mov    0x8(%ebp),%eax
  801421:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801424:	8b 55 08             	mov    0x8(%ebp),%edx
  801427:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80142a:	29 c2                	sub    %eax,%edx
  80142c:	89 d0                	mov    %edx,%eax
}
  80142e:	c9                   	leave  
  80142f:	c3                   	ret    

00801430 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801430:	55                   	push   %ebp
  801431:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801433:	eb 06                	jmp    80143b <strcmp+0xb>
		p++, q++;
  801435:	ff 45 08             	incl   0x8(%ebp)
  801438:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80143b:	8b 45 08             	mov    0x8(%ebp),%eax
  80143e:	8a 00                	mov    (%eax),%al
  801440:	84 c0                	test   %al,%al
  801442:	74 0e                	je     801452 <strcmp+0x22>
  801444:	8b 45 08             	mov    0x8(%ebp),%eax
  801447:	8a 10                	mov    (%eax),%dl
  801449:	8b 45 0c             	mov    0xc(%ebp),%eax
  80144c:	8a 00                	mov    (%eax),%al
  80144e:	38 c2                	cmp    %al,%dl
  801450:	74 e3                	je     801435 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801452:	8b 45 08             	mov    0x8(%ebp),%eax
  801455:	8a 00                	mov    (%eax),%al
  801457:	0f b6 d0             	movzbl %al,%edx
  80145a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80145d:	8a 00                	mov    (%eax),%al
  80145f:	0f b6 c0             	movzbl %al,%eax
  801462:	29 c2                	sub    %eax,%edx
  801464:	89 d0                	mov    %edx,%eax
}
  801466:	5d                   	pop    %ebp
  801467:	c3                   	ret    

00801468 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801468:	55                   	push   %ebp
  801469:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80146b:	eb 09                	jmp    801476 <strncmp+0xe>
		n--, p++, q++;
  80146d:	ff 4d 10             	decl   0x10(%ebp)
  801470:	ff 45 08             	incl   0x8(%ebp)
  801473:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801476:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80147a:	74 17                	je     801493 <strncmp+0x2b>
  80147c:	8b 45 08             	mov    0x8(%ebp),%eax
  80147f:	8a 00                	mov    (%eax),%al
  801481:	84 c0                	test   %al,%al
  801483:	74 0e                	je     801493 <strncmp+0x2b>
  801485:	8b 45 08             	mov    0x8(%ebp),%eax
  801488:	8a 10                	mov    (%eax),%dl
  80148a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80148d:	8a 00                	mov    (%eax),%al
  80148f:	38 c2                	cmp    %al,%dl
  801491:	74 da                	je     80146d <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801493:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801497:	75 07                	jne    8014a0 <strncmp+0x38>
		return 0;
  801499:	b8 00 00 00 00       	mov    $0x0,%eax
  80149e:	eb 14                	jmp    8014b4 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8014a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a3:	8a 00                	mov    (%eax),%al
  8014a5:	0f b6 d0             	movzbl %al,%edx
  8014a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ab:	8a 00                	mov    (%eax),%al
  8014ad:	0f b6 c0             	movzbl %al,%eax
  8014b0:	29 c2                	sub    %eax,%edx
  8014b2:	89 d0                	mov    %edx,%eax
}
  8014b4:	5d                   	pop    %ebp
  8014b5:	c3                   	ret    

008014b6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8014b6:	55                   	push   %ebp
  8014b7:	89 e5                	mov    %esp,%ebp
  8014b9:	83 ec 04             	sub    $0x4,%esp
  8014bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014bf:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8014c2:	eb 12                	jmp    8014d6 <strchr+0x20>
		if (*s == c)
  8014c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c7:	8a 00                	mov    (%eax),%al
  8014c9:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8014cc:	75 05                	jne    8014d3 <strchr+0x1d>
			return (char *) s;
  8014ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d1:	eb 11                	jmp    8014e4 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8014d3:	ff 45 08             	incl   0x8(%ebp)
  8014d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d9:	8a 00                	mov    (%eax),%al
  8014db:	84 c0                	test   %al,%al
  8014dd:	75 e5                	jne    8014c4 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8014df:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014e4:	c9                   	leave  
  8014e5:	c3                   	ret    

008014e6 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8014e6:	55                   	push   %ebp
  8014e7:	89 e5                	mov    %esp,%ebp
  8014e9:	83 ec 04             	sub    $0x4,%esp
  8014ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ef:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8014f2:	eb 0d                	jmp    801501 <strfind+0x1b>
		if (*s == c)
  8014f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f7:	8a 00                	mov    (%eax),%al
  8014f9:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8014fc:	74 0e                	je     80150c <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8014fe:	ff 45 08             	incl   0x8(%ebp)
  801501:	8b 45 08             	mov    0x8(%ebp),%eax
  801504:	8a 00                	mov    (%eax),%al
  801506:	84 c0                	test   %al,%al
  801508:	75 ea                	jne    8014f4 <strfind+0xe>
  80150a:	eb 01                	jmp    80150d <strfind+0x27>
		if (*s == c)
			break;
  80150c:	90                   	nop
	return (char *) s;
  80150d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801510:	c9                   	leave  
  801511:	c3                   	ret    

00801512 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801512:	55                   	push   %ebp
  801513:	89 e5                	mov    %esp,%ebp
  801515:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801518:	8b 45 08             	mov    0x8(%ebp),%eax
  80151b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  80151e:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801522:	76 63                	jbe    801587 <memset+0x75>
		uint64 data_block = c;
  801524:	8b 45 0c             	mov    0xc(%ebp),%eax
  801527:	99                   	cltd   
  801528:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80152b:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  80152e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801531:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801534:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801538:	c1 e0 08             	shl    $0x8,%eax
  80153b:	09 45 f0             	or     %eax,-0x10(%ebp)
  80153e:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801541:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801544:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801547:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  80154b:	c1 e0 10             	shl    $0x10,%eax
  80154e:	09 45 f0             	or     %eax,-0x10(%ebp)
  801551:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801554:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801557:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80155a:	89 c2                	mov    %eax,%edx
  80155c:	b8 00 00 00 00       	mov    $0x0,%eax
  801561:	09 45 f0             	or     %eax,-0x10(%ebp)
  801564:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801567:	eb 18                	jmp    801581 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801569:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80156c:	8d 41 08             	lea    0x8(%ecx),%eax
  80156f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801572:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801575:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801578:	89 01                	mov    %eax,(%ecx)
  80157a:	89 51 04             	mov    %edx,0x4(%ecx)
  80157d:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801581:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801585:	77 e2                	ja     801569 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801587:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80158b:	74 23                	je     8015b0 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  80158d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801590:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801593:	eb 0e                	jmp    8015a3 <memset+0x91>
			*p8++ = (uint8)c;
  801595:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801598:	8d 50 01             	lea    0x1(%eax),%edx
  80159b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80159e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015a1:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8015a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8015a6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015a9:	89 55 10             	mov    %edx,0x10(%ebp)
  8015ac:	85 c0                	test   %eax,%eax
  8015ae:	75 e5                	jne    801595 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8015b0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015b3:	c9                   	leave  
  8015b4:	c3                   	ret    

008015b5 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8015b5:	55                   	push   %ebp
  8015b6:	89 e5                	mov    %esp,%ebp
  8015b8:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8015bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015be:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8015c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8015c7:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8015cb:	76 24                	jbe    8015f1 <memcpy+0x3c>
		while(n >= 8){
  8015cd:	eb 1c                	jmp    8015eb <memcpy+0x36>
			*d64 = *s64;
  8015cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015d2:	8b 50 04             	mov    0x4(%eax),%edx
  8015d5:	8b 00                	mov    (%eax),%eax
  8015d7:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8015da:	89 01                	mov    %eax,(%ecx)
  8015dc:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8015df:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8015e3:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8015e7:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8015eb:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8015ef:	77 de                	ja     8015cf <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8015f1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015f5:	74 31                	je     801628 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8015f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8015fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801600:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801603:	eb 16                	jmp    80161b <memcpy+0x66>
			*d8++ = *s8++;
  801605:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801608:	8d 50 01             	lea    0x1(%eax),%edx
  80160b:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80160e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801611:	8d 4a 01             	lea    0x1(%edx),%ecx
  801614:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801617:	8a 12                	mov    (%edx),%dl
  801619:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  80161b:	8b 45 10             	mov    0x10(%ebp),%eax
  80161e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801621:	89 55 10             	mov    %edx,0x10(%ebp)
  801624:	85 c0                	test   %eax,%eax
  801626:	75 dd                	jne    801605 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801628:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80162b:	c9                   	leave  
  80162c:	c3                   	ret    

0080162d <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80162d:	55                   	push   %ebp
  80162e:	89 e5                	mov    %esp,%ebp
  801630:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801633:	8b 45 0c             	mov    0xc(%ebp),%eax
  801636:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801639:	8b 45 08             	mov    0x8(%ebp),%eax
  80163c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80163f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801642:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801645:	73 50                	jae    801697 <memmove+0x6a>
  801647:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80164a:	8b 45 10             	mov    0x10(%ebp),%eax
  80164d:	01 d0                	add    %edx,%eax
  80164f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801652:	76 43                	jbe    801697 <memmove+0x6a>
		s += n;
  801654:	8b 45 10             	mov    0x10(%ebp),%eax
  801657:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80165a:	8b 45 10             	mov    0x10(%ebp),%eax
  80165d:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801660:	eb 10                	jmp    801672 <memmove+0x45>
			*--d = *--s;
  801662:	ff 4d f8             	decl   -0x8(%ebp)
  801665:	ff 4d fc             	decl   -0x4(%ebp)
  801668:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80166b:	8a 10                	mov    (%eax),%dl
  80166d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801670:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801672:	8b 45 10             	mov    0x10(%ebp),%eax
  801675:	8d 50 ff             	lea    -0x1(%eax),%edx
  801678:	89 55 10             	mov    %edx,0x10(%ebp)
  80167b:	85 c0                	test   %eax,%eax
  80167d:	75 e3                	jne    801662 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80167f:	eb 23                	jmp    8016a4 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801681:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801684:	8d 50 01             	lea    0x1(%eax),%edx
  801687:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80168a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80168d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801690:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801693:	8a 12                	mov    (%edx),%dl
  801695:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801697:	8b 45 10             	mov    0x10(%ebp),%eax
  80169a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80169d:	89 55 10             	mov    %edx,0x10(%ebp)
  8016a0:	85 c0                	test   %eax,%eax
  8016a2:	75 dd                	jne    801681 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8016a4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016a7:	c9                   	leave  
  8016a8:	c3                   	ret    

008016a9 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8016a9:	55                   	push   %ebp
  8016aa:	89 e5                	mov    %esp,%ebp
  8016ac:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8016af:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8016b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016b8:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8016bb:	eb 2a                	jmp    8016e7 <memcmp+0x3e>
		if (*s1 != *s2)
  8016bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016c0:	8a 10                	mov    (%eax),%dl
  8016c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016c5:	8a 00                	mov    (%eax),%al
  8016c7:	38 c2                	cmp    %al,%dl
  8016c9:	74 16                	je     8016e1 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8016cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016ce:	8a 00                	mov    (%eax),%al
  8016d0:	0f b6 d0             	movzbl %al,%edx
  8016d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016d6:	8a 00                	mov    (%eax),%al
  8016d8:	0f b6 c0             	movzbl %al,%eax
  8016db:	29 c2                	sub    %eax,%edx
  8016dd:	89 d0                	mov    %edx,%eax
  8016df:	eb 18                	jmp    8016f9 <memcmp+0x50>
		s1++, s2++;
  8016e1:	ff 45 fc             	incl   -0x4(%ebp)
  8016e4:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8016e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ea:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016ed:	89 55 10             	mov    %edx,0x10(%ebp)
  8016f0:	85 c0                	test   %eax,%eax
  8016f2:	75 c9                	jne    8016bd <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8016f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016f9:	c9                   	leave  
  8016fa:	c3                   	ret    

008016fb <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8016fb:	55                   	push   %ebp
  8016fc:	89 e5                	mov    %esp,%ebp
  8016fe:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801701:	8b 55 08             	mov    0x8(%ebp),%edx
  801704:	8b 45 10             	mov    0x10(%ebp),%eax
  801707:	01 d0                	add    %edx,%eax
  801709:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80170c:	eb 15                	jmp    801723 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80170e:	8b 45 08             	mov    0x8(%ebp),%eax
  801711:	8a 00                	mov    (%eax),%al
  801713:	0f b6 d0             	movzbl %al,%edx
  801716:	8b 45 0c             	mov    0xc(%ebp),%eax
  801719:	0f b6 c0             	movzbl %al,%eax
  80171c:	39 c2                	cmp    %eax,%edx
  80171e:	74 0d                	je     80172d <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801720:	ff 45 08             	incl   0x8(%ebp)
  801723:	8b 45 08             	mov    0x8(%ebp),%eax
  801726:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801729:	72 e3                	jb     80170e <memfind+0x13>
  80172b:	eb 01                	jmp    80172e <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80172d:	90                   	nop
	return (void *) s;
  80172e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801731:	c9                   	leave  
  801732:	c3                   	ret    

00801733 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801733:	55                   	push   %ebp
  801734:	89 e5                	mov    %esp,%ebp
  801736:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801739:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801740:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801747:	eb 03                	jmp    80174c <strtol+0x19>
		s++;
  801749:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80174c:	8b 45 08             	mov    0x8(%ebp),%eax
  80174f:	8a 00                	mov    (%eax),%al
  801751:	3c 20                	cmp    $0x20,%al
  801753:	74 f4                	je     801749 <strtol+0x16>
  801755:	8b 45 08             	mov    0x8(%ebp),%eax
  801758:	8a 00                	mov    (%eax),%al
  80175a:	3c 09                	cmp    $0x9,%al
  80175c:	74 eb                	je     801749 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80175e:	8b 45 08             	mov    0x8(%ebp),%eax
  801761:	8a 00                	mov    (%eax),%al
  801763:	3c 2b                	cmp    $0x2b,%al
  801765:	75 05                	jne    80176c <strtol+0x39>
		s++;
  801767:	ff 45 08             	incl   0x8(%ebp)
  80176a:	eb 13                	jmp    80177f <strtol+0x4c>
	else if (*s == '-')
  80176c:	8b 45 08             	mov    0x8(%ebp),%eax
  80176f:	8a 00                	mov    (%eax),%al
  801771:	3c 2d                	cmp    $0x2d,%al
  801773:	75 0a                	jne    80177f <strtol+0x4c>
		s++, neg = 1;
  801775:	ff 45 08             	incl   0x8(%ebp)
  801778:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80177f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801783:	74 06                	je     80178b <strtol+0x58>
  801785:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801789:	75 20                	jne    8017ab <strtol+0x78>
  80178b:	8b 45 08             	mov    0x8(%ebp),%eax
  80178e:	8a 00                	mov    (%eax),%al
  801790:	3c 30                	cmp    $0x30,%al
  801792:	75 17                	jne    8017ab <strtol+0x78>
  801794:	8b 45 08             	mov    0x8(%ebp),%eax
  801797:	40                   	inc    %eax
  801798:	8a 00                	mov    (%eax),%al
  80179a:	3c 78                	cmp    $0x78,%al
  80179c:	75 0d                	jne    8017ab <strtol+0x78>
		s += 2, base = 16;
  80179e:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8017a2:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8017a9:	eb 28                	jmp    8017d3 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8017ab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017af:	75 15                	jne    8017c6 <strtol+0x93>
  8017b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b4:	8a 00                	mov    (%eax),%al
  8017b6:	3c 30                	cmp    $0x30,%al
  8017b8:	75 0c                	jne    8017c6 <strtol+0x93>
		s++, base = 8;
  8017ba:	ff 45 08             	incl   0x8(%ebp)
  8017bd:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8017c4:	eb 0d                	jmp    8017d3 <strtol+0xa0>
	else if (base == 0)
  8017c6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017ca:	75 07                	jne    8017d3 <strtol+0xa0>
		base = 10;
  8017cc:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8017d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d6:	8a 00                	mov    (%eax),%al
  8017d8:	3c 2f                	cmp    $0x2f,%al
  8017da:	7e 19                	jle    8017f5 <strtol+0xc2>
  8017dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017df:	8a 00                	mov    (%eax),%al
  8017e1:	3c 39                	cmp    $0x39,%al
  8017e3:	7f 10                	jg     8017f5 <strtol+0xc2>
			dig = *s - '0';
  8017e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e8:	8a 00                	mov    (%eax),%al
  8017ea:	0f be c0             	movsbl %al,%eax
  8017ed:	83 e8 30             	sub    $0x30,%eax
  8017f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017f3:	eb 42                	jmp    801837 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8017f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f8:	8a 00                	mov    (%eax),%al
  8017fa:	3c 60                	cmp    $0x60,%al
  8017fc:	7e 19                	jle    801817 <strtol+0xe4>
  8017fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801801:	8a 00                	mov    (%eax),%al
  801803:	3c 7a                	cmp    $0x7a,%al
  801805:	7f 10                	jg     801817 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801807:	8b 45 08             	mov    0x8(%ebp),%eax
  80180a:	8a 00                	mov    (%eax),%al
  80180c:	0f be c0             	movsbl %al,%eax
  80180f:	83 e8 57             	sub    $0x57,%eax
  801812:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801815:	eb 20                	jmp    801837 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801817:	8b 45 08             	mov    0x8(%ebp),%eax
  80181a:	8a 00                	mov    (%eax),%al
  80181c:	3c 40                	cmp    $0x40,%al
  80181e:	7e 39                	jle    801859 <strtol+0x126>
  801820:	8b 45 08             	mov    0x8(%ebp),%eax
  801823:	8a 00                	mov    (%eax),%al
  801825:	3c 5a                	cmp    $0x5a,%al
  801827:	7f 30                	jg     801859 <strtol+0x126>
			dig = *s - 'A' + 10;
  801829:	8b 45 08             	mov    0x8(%ebp),%eax
  80182c:	8a 00                	mov    (%eax),%al
  80182e:	0f be c0             	movsbl %al,%eax
  801831:	83 e8 37             	sub    $0x37,%eax
  801834:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801837:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80183a:	3b 45 10             	cmp    0x10(%ebp),%eax
  80183d:	7d 19                	jge    801858 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80183f:	ff 45 08             	incl   0x8(%ebp)
  801842:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801845:	0f af 45 10          	imul   0x10(%ebp),%eax
  801849:	89 c2                	mov    %eax,%edx
  80184b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80184e:	01 d0                	add    %edx,%eax
  801850:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801853:	e9 7b ff ff ff       	jmp    8017d3 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801858:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801859:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80185d:	74 08                	je     801867 <strtol+0x134>
		*endptr = (char *) s;
  80185f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801862:	8b 55 08             	mov    0x8(%ebp),%edx
  801865:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801867:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80186b:	74 07                	je     801874 <strtol+0x141>
  80186d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801870:	f7 d8                	neg    %eax
  801872:	eb 03                	jmp    801877 <strtol+0x144>
  801874:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801877:	c9                   	leave  
  801878:	c3                   	ret    

00801879 <ltostr>:

void
ltostr(long value, char *str)
{
  801879:	55                   	push   %ebp
  80187a:	89 e5                	mov    %esp,%ebp
  80187c:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80187f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801886:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80188d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801891:	79 13                	jns    8018a6 <ltostr+0x2d>
	{
		neg = 1;
  801893:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80189a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80189d:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8018a0:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8018a3:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8018a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a9:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8018ae:	99                   	cltd   
  8018af:	f7 f9                	idiv   %ecx
  8018b1:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8018b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018b7:	8d 50 01             	lea    0x1(%eax),%edx
  8018ba:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8018bd:	89 c2                	mov    %eax,%edx
  8018bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c2:	01 d0                	add    %edx,%eax
  8018c4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8018c7:	83 c2 30             	add    $0x30,%edx
  8018ca:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8018cc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018cf:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8018d4:	f7 e9                	imul   %ecx
  8018d6:	c1 fa 02             	sar    $0x2,%edx
  8018d9:	89 c8                	mov    %ecx,%eax
  8018db:	c1 f8 1f             	sar    $0x1f,%eax
  8018de:	29 c2                	sub    %eax,%edx
  8018e0:	89 d0                	mov    %edx,%eax
  8018e2:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8018e5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018e9:	75 bb                	jne    8018a6 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8018eb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8018f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018f5:	48                   	dec    %eax
  8018f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8018f9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8018fd:	74 3d                	je     80193c <ltostr+0xc3>
		start = 1 ;
  8018ff:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801906:	eb 34                	jmp    80193c <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801908:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80190b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80190e:	01 d0                	add    %edx,%eax
  801910:	8a 00                	mov    (%eax),%al
  801912:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801915:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801918:	8b 45 0c             	mov    0xc(%ebp),%eax
  80191b:	01 c2                	add    %eax,%edx
  80191d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801920:	8b 45 0c             	mov    0xc(%ebp),%eax
  801923:	01 c8                	add    %ecx,%eax
  801925:	8a 00                	mov    (%eax),%al
  801927:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801929:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80192c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80192f:	01 c2                	add    %eax,%edx
  801931:	8a 45 eb             	mov    -0x15(%ebp),%al
  801934:	88 02                	mov    %al,(%edx)
		start++ ;
  801936:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801939:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80193c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80193f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801942:	7c c4                	jl     801908 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801944:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801947:	8b 45 0c             	mov    0xc(%ebp),%eax
  80194a:	01 d0                	add    %edx,%eax
  80194c:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80194f:	90                   	nop
  801950:	c9                   	leave  
  801951:	c3                   	ret    

00801952 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801952:	55                   	push   %ebp
  801953:	89 e5                	mov    %esp,%ebp
  801955:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801958:	ff 75 08             	pushl  0x8(%ebp)
  80195b:	e8 c4 f9 ff ff       	call   801324 <strlen>
  801960:	83 c4 04             	add    $0x4,%esp
  801963:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801966:	ff 75 0c             	pushl  0xc(%ebp)
  801969:	e8 b6 f9 ff ff       	call   801324 <strlen>
  80196e:	83 c4 04             	add    $0x4,%esp
  801971:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801974:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80197b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801982:	eb 17                	jmp    80199b <strcconcat+0x49>
		final[s] = str1[s] ;
  801984:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801987:	8b 45 10             	mov    0x10(%ebp),%eax
  80198a:	01 c2                	add    %eax,%edx
  80198c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80198f:	8b 45 08             	mov    0x8(%ebp),%eax
  801992:	01 c8                	add    %ecx,%eax
  801994:	8a 00                	mov    (%eax),%al
  801996:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801998:	ff 45 fc             	incl   -0x4(%ebp)
  80199b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80199e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8019a1:	7c e1                	jl     801984 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8019a3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8019aa:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8019b1:	eb 1f                	jmp    8019d2 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8019b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019b6:	8d 50 01             	lea    0x1(%eax),%edx
  8019b9:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8019bc:	89 c2                	mov    %eax,%edx
  8019be:	8b 45 10             	mov    0x10(%ebp),%eax
  8019c1:	01 c2                	add    %eax,%edx
  8019c3:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8019c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019c9:	01 c8                	add    %ecx,%eax
  8019cb:	8a 00                	mov    (%eax),%al
  8019cd:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8019cf:	ff 45 f8             	incl   -0x8(%ebp)
  8019d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019d5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8019d8:	7c d9                	jl     8019b3 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8019da:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8019e0:	01 d0                	add    %edx,%eax
  8019e2:	c6 00 00             	movb   $0x0,(%eax)
}
  8019e5:	90                   	nop
  8019e6:	c9                   	leave  
  8019e7:	c3                   	ret    

008019e8 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8019e8:	55                   	push   %ebp
  8019e9:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8019eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8019ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8019f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8019f7:	8b 00                	mov    (%eax),%eax
  8019f9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a00:	8b 45 10             	mov    0x10(%ebp),%eax
  801a03:	01 d0                	add    %edx,%eax
  801a05:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a0b:	eb 0c                	jmp    801a19 <strsplit+0x31>
			*string++ = 0;
  801a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a10:	8d 50 01             	lea    0x1(%eax),%edx
  801a13:	89 55 08             	mov    %edx,0x8(%ebp)
  801a16:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a19:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1c:	8a 00                	mov    (%eax),%al
  801a1e:	84 c0                	test   %al,%al
  801a20:	74 18                	je     801a3a <strsplit+0x52>
  801a22:	8b 45 08             	mov    0x8(%ebp),%eax
  801a25:	8a 00                	mov    (%eax),%al
  801a27:	0f be c0             	movsbl %al,%eax
  801a2a:	50                   	push   %eax
  801a2b:	ff 75 0c             	pushl  0xc(%ebp)
  801a2e:	e8 83 fa ff ff       	call   8014b6 <strchr>
  801a33:	83 c4 08             	add    $0x8,%esp
  801a36:	85 c0                	test   %eax,%eax
  801a38:	75 d3                	jne    801a0d <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3d:	8a 00                	mov    (%eax),%al
  801a3f:	84 c0                	test   %al,%al
  801a41:	74 5a                	je     801a9d <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801a43:	8b 45 14             	mov    0x14(%ebp),%eax
  801a46:	8b 00                	mov    (%eax),%eax
  801a48:	83 f8 0f             	cmp    $0xf,%eax
  801a4b:	75 07                	jne    801a54 <strsplit+0x6c>
		{
			return 0;
  801a4d:	b8 00 00 00 00       	mov    $0x0,%eax
  801a52:	eb 66                	jmp    801aba <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801a54:	8b 45 14             	mov    0x14(%ebp),%eax
  801a57:	8b 00                	mov    (%eax),%eax
  801a59:	8d 48 01             	lea    0x1(%eax),%ecx
  801a5c:	8b 55 14             	mov    0x14(%ebp),%edx
  801a5f:	89 0a                	mov    %ecx,(%edx)
  801a61:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a68:	8b 45 10             	mov    0x10(%ebp),%eax
  801a6b:	01 c2                	add    %eax,%edx
  801a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a70:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a72:	eb 03                	jmp    801a77 <strsplit+0x8f>
			string++;
  801a74:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a77:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7a:	8a 00                	mov    (%eax),%al
  801a7c:	84 c0                	test   %al,%al
  801a7e:	74 8b                	je     801a0b <strsplit+0x23>
  801a80:	8b 45 08             	mov    0x8(%ebp),%eax
  801a83:	8a 00                	mov    (%eax),%al
  801a85:	0f be c0             	movsbl %al,%eax
  801a88:	50                   	push   %eax
  801a89:	ff 75 0c             	pushl  0xc(%ebp)
  801a8c:	e8 25 fa ff ff       	call   8014b6 <strchr>
  801a91:	83 c4 08             	add    $0x8,%esp
  801a94:	85 c0                	test   %eax,%eax
  801a96:	74 dc                	je     801a74 <strsplit+0x8c>
			string++;
	}
  801a98:	e9 6e ff ff ff       	jmp    801a0b <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801a9d:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801a9e:	8b 45 14             	mov    0x14(%ebp),%eax
  801aa1:	8b 00                	mov    (%eax),%eax
  801aa3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801aaa:	8b 45 10             	mov    0x10(%ebp),%eax
  801aad:	01 d0                	add    %edx,%eax
  801aaf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801ab5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801aba:	c9                   	leave  
  801abb:	c3                   	ret    

00801abc <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801abc:	55                   	push   %ebp
  801abd:	89 e5                	mov    %esp,%ebp
  801abf:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801ac8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801acf:	eb 4a                	jmp    801b1b <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801ad1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad7:	01 c2                	add    %eax,%edx
  801ad9:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801adc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801adf:	01 c8                	add    %ecx,%eax
  801ae1:	8a 00                	mov    (%eax),%al
  801ae3:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801ae5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ae8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aeb:	01 d0                	add    %edx,%eax
  801aed:	8a 00                	mov    (%eax),%al
  801aef:	3c 40                	cmp    $0x40,%al
  801af1:	7e 25                	jle    801b18 <str2lower+0x5c>
  801af3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801af6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801af9:	01 d0                	add    %edx,%eax
  801afb:	8a 00                	mov    (%eax),%al
  801afd:	3c 5a                	cmp    $0x5a,%al
  801aff:	7f 17                	jg     801b18 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801b01:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b04:	8b 45 08             	mov    0x8(%ebp),%eax
  801b07:	01 d0                	add    %edx,%eax
  801b09:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801b0c:	8b 55 08             	mov    0x8(%ebp),%edx
  801b0f:	01 ca                	add    %ecx,%edx
  801b11:	8a 12                	mov    (%edx),%dl
  801b13:	83 c2 20             	add    $0x20,%edx
  801b16:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801b18:	ff 45 fc             	incl   -0x4(%ebp)
  801b1b:	ff 75 0c             	pushl  0xc(%ebp)
  801b1e:	e8 01 f8 ff ff       	call   801324 <strlen>
  801b23:	83 c4 04             	add    $0x4,%esp
  801b26:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801b29:	7f a6                	jg     801ad1 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801b2b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801b2e:	c9                   	leave  
  801b2f:	c3                   	ret    

00801b30 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801b30:	55                   	push   %ebp
  801b31:	89 e5                	mov    %esp,%ebp
  801b33:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801b36:	a1 08 40 80 00       	mov    0x804008,%eax
  801b3b:	85 c0                	test   %eax,%eax
  801b3d:	74 42                	je     801b81 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801b3f:	83 ec 08             	sub    $0x8,%esp
  801b42:	68 00 00 00 82       	push   $0x82000000
  801b47:	68 00 00 00 80       	push   $0x80000000
  801b4c:	e8 8c 07 00 00       	call   8022dd <initialize_dynamic_allocator>
  801b51:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801b54:	e8 e7 05 00 00       	call   802140 <sys_get_uheap_strategy>
  801b59:	a3 60 c0 81 00       	mov    %eax,0x81c060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801b5e:	a1 40 40 80 00       	mov    0x804040,%eax
  801b63:	05 00 10 00 00       	add    $0x1000,%eax
  801b68:	a3 10 c1 81 00       	mov    %eax,0x81c110
		uheapPageAllocBreak = uheapPageAllocStart;
  801b6d:	a1 10 c1 81 00       	mov    0x81c110,%eax
  801b72:	a3 68 c0 81 00       	mov    %eax,0x81c068

		__firstTimeFlag = 0;
  801b77:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  801b7e:	00 00 00 
	}
}
  801b81:	90                   	nop
  801b82:	c9                   	leave  
  801b83:	c3                   	ret    

00801b84 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801b84:	55                   	push   %ebp
  801b85:	89 e5                	mov    %esp,%ebp
  801b87:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b93:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801b98:	83 ec 08             	sub    $0x8,%esp
  801b9b:	68 06 04 00 00       	push   $0x406
  801ba0:	50                   	push   %eax
  801ba1:	e8 e4 01 00 00       	call   801d8a <__sys_allocate_page>
  801ba6:	83 c4 10             	add    $0x10,%esp
  801ba9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801bac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801bb0:	79 14                	jns    801bc6 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801bb2:	83 ec 04             	sub    $0x4,%esp
  801bb5:	68 1c 2e 80 00       	push   $0x802e1c
  801bba:	6a 1f                	push   $0x1f
  801bbc:	68 58 2e 80 00       	push   $0x802e58
  801bc1:	e8 af eb ff ff       	call   800775 <_panic>
	return 0;
  801bc6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bcb:	c9                   	leave  
  801bcc:	c3                   	ret    

00801bcd <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801bcd:	55                   	push   %ebp
  801bce:	89 e5                	mov    %esp,%ebp
  801bd0:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801bd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bdc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801be1:	83 ec 0c             	sub    $0xc,%esp
  801be4:	50                   	push   %eax
  801be5:	e8 e7 01 00 00       	call   801dd1 <__sys_unmap_frame>
  801bea:	83 c4 10             	add    $0x10,%esp
  801bed:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801bf0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801bf4:	79 14                	jns    801c0a <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801bf6:	83 ec 04             	sub    $0x4,%esp
  801bf9:	68 64 2e 80 00       	push   $0x802e64
  801bfe:	6a 2a                	push   $0x2a
  801c00:	68 58 2e 80 00       	push   $0x802e58
  801c05:	e8 6b eb ff ff       	call   800775 <_panic>
}
  801c0a:	90                   	nop
  801c0b:	c9                   	leave  
  801c0c:	c3                   	ret    

00801c0d <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801c0d:	55                   	push   %ebp
  801c0e:	89 e5                	mov    %esp,%ebp
  801c10:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801c13:	e8 18 ff ff ff       	call   801b30 <uheap_init>
	if (size == 0) return NULL ;
  801c18:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801c1c:	75 07                	jne    801c25 <malloc+0x18>
  801c1e:	b8 00 00 00 00       	mov    $0x0,%eax
  801c23:	eb 14                	jmp    801c39 <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  801c25:	83 ec 04             	sub    $0x4,%esp
  801c28:	68 a4 2e 80 00       	push   $0x802ea4
  801c2d:	6a 3e                	push   $0x3e
  801c2f:	68 58 2e 80 00       	push   $0x802e58
  801c34:	e8 3c eb ff ff       	call   800775 <_panic>
}
  801c39:	c9                   	leave  
  801c3a:	c3                   	ret    

00801c3b <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801c3b:	55                   	push   %ebp
  801c3c:	89 e5                	mov    %esp,%ebp
  801c3e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  801c41:	83 ec 04             	sub    $0x4,%esp
  801c44:	68 cc 2e 80 00       	push   $0x802ecc
  801c49:	6a 49                	push   $0x49
  801c4b:	68 58 2e 80 00       	push   $0x802e58
  801c50:	e8 20 eb ff ff       	call   800775 <_panic>

00801c55 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801c55:	55                   	push   %ebp
  801c56:	89 e5                	mov    %esp,%ebp
  801c58:	83 ec 18             	sub    $0x18,%esp
  801c5b:	8b 45 10             	mov    0x10(%ebp),%eax
  801c5e:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801c61:	e8 ca fe ff ff       	call   801b30 <uheap_init>
	if (size == 0) return NULL ;
  801c66:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801c6a:	75 07                	jne    801c73 <smalloc+0x1e>
  801c6c:	b8 00 00 00 00       	mov    $0x0,%eax
  801c71:	eb 14                	jmp    801c87 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  801c73:	83 ec 04             	sub    $0x4,%esp
  801c76:	68 f0 2e 80 00       	push   $0x802ef0
  801c7b:	6a 5a                	push   $0x5a
  801c7d:	68 58 2e 80 00       	push   $0x802e58
  801c82:	e8 ee ea ff ff       	call   800775 <_panic>
}
  801c87:	c9                   	leave  
  801c88:	c3                   	ret    

00801c89 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801c89:	55                   	push   %ebp
  801c8a:	89 e5                	mov    %esp,%ebp
  801c8c:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801c8f:	e8 9c fe ff ff       	call   801b30 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  801c94:	83 ec 04             	sub    $0x4,%esp
  801c97:	68 18 2f 80 00       	push   $0x802f18
  801c9c:	6a 6a                	push   $0x6a
  801c9e:	68 58 2e 80 00       	push   $0x802e58
  801ca3:	e8 cd ea ff ff       	call   800775 <_panic>

00801ca8 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801ca8:	55                   	push   %ebp
  801ca9:	89 e5                	mov    %esp,%ebp
  801cab:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801cae:	e8 7d fe ff ff       	call   801b30 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  801cb3:	83 ec 04             	sub    $0x4,%esp
  801cb6:	68 3c 2f 80 00       	push   $0x802f3c
  801cbb:	68 88 00 00 00       	push   $0x88
  801cc0:	68 58 2e 80 00       	push   $0x802e58
  801cc5:	e8 ab ea ff ff       	call   800775 <_panic>

00801cca <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  801cca:	55                   	push   %ebp
  801ccb:	89 e5                	mov    %esp,%ebp
  801ccd:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  801cd0:	83 ec 04             	sub    $0x4,%esp
  801cd3:	68 64 2f 80 00       	push   $0x802f64
  801cd8:	68 9b 00 00 00       	push   $0x9b
  801cdd:	68 58 2e 80 00       	push   $0x802e58
  801ce2:	e8 8e ea ff ff       	call   800775 <_panic>

00801ce7 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801ce7:	55                   	push   %ebp
  801ce8:	89 e5                	mov    %esp,%ebp
  801cea:	57                   	push   %edi
  801ceb:	56                   	push   %esi
  801cec:	53                   	push   %ebx
  801ced:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cf6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cf9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cfc:	8b 7d 18             	mov    0x18(%ebp),%edi
  801cff:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801d02:	cd 30                	int    $0x30
  801d04:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801d07:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801d0a:	83 c4 10             	add    $0x10,%esp
  801d0d:	5b                   	pop    %ebx
  801d0e:	5e                   	pop    %esi
  801d0f:	5f                   	pop    %edi
  801d10:	5d                   	pop    %ebp
  801d11:	c3                   	ret    

00801d12 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801d12:	55                   	push   %ebp
  801d13:	89 e5                	mov    %esp,%ebp
  801d15:	83 ec 04             	sub    $0x4,%esp
  801d18:	8b 45 10             	mov    0x10(%ebp),%eax
  801d1b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801d1e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d21:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d25:	8b 45 08             	mov    0x8(%ebp),%eax
  801d28:	6a 00                	push   $0x0
  801d2a:	51                   	push   %ecx
  801d2b:	52                   	push   %edx
  801d2c:	ff 75 0c             	pushl  0xc(%ebp)
  801d2f:	50                   	push   %eax
  801d30:	6a 00                	push   $0x0
  801d32:	e8 b0 ff ff ff       	call   801ce7 <syscall>
  801d37:	83 c4 18             	add    $0x18,%esp
}
  801d3a:	90                   	nop
  801d3b:	c9                   	leave  
  801d3c:	c3                   	ret    

00801d3d <sys_cgetc>:

int
sys_cgetc(void)
{
  801d3d:	55                   	push   %ebp
  801d3e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801d40:	6a 00                	push   $0x0
  801d42:	6a 00                	push   $0x0
  801d44:	6a 00                	push   $0x0
  801d46:	6a 00                	push   $0x0
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 02                	push   $0x2
  801d4c:	e8 96 ff ff ff       	call   801ce7 <syscall>
  801d51:	83 c4 18             	add    $0x18,%esp
}
  801d54:	c9                   	leave  
  801d55:	c3                   	ret    

00801d56 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801d56:	55                   	push   %ebp
  801d57:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801d59:	6a 00                	push   $0x0
  801d5b:	6a 00                	push   $0x0
  801d5d:	6a 00                	push   $0x0
  801d5f:	6a 00                	push   $0x0
  801d61:	6a 00                	push   $0x0
  801d63:	6a 03                	push   $0x3
  801d65:	e8 7d ff ff ff       	call   801ce7 <syscall>
  801d6a:	83 c4 18             	add    $0x18,%esp
}
  801d6d:	90                   	nop
  801d6e:	c9                   	leave  
  801d6f:	c3                   	ret    

00801d70 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801d70:	55                   	push   %ebp
  801d71:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801d73:	6a 00                	push   $0x0
  801d75:	6a 00                	push   $0x0
  801d77:	6a 00                	push   $0x0
  801d79:	6a 00                	push   $0x0
  801d7b:	6a 00                	push   $0x0
  801d7d:	6a 04                	push   $0x4
  801d7f:	e8 63 ff ff ff       	call   801ce7 <syscall>
  801d84:	83 c4 18             	add    $0x18,%esp
}
  801d87:	90                   	nop
  801d88:	c9                   	leave  
  801d89:	c3                   	ret    

00801d8a <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801d8a:	55                   	push   %ebp
  801d8b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801d8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d90:	8b 45 08             	mov    0x8(%ebp),%eax
  801d93:	6a 00                	push   $0x0
  801d95:	6a 00                	push   $0x0
  801d97:	6a 00                	push   $0x0
  801d99:	52                   	push   %edx
  801d9a:	50                   	push   %eax
  801d9b:	6a 08                	push   $0x8
  801d9d:	e8 45 ff ff ff       	call   801ce7 <syscall>
  801da2:	83 c4 18             	add    $0x18,%esp
}
  801da5:	c9                   	leave  
  801da6:	c3                   	ret    

00801da7 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801da7:	55                   	push   %ebp
  801da8:	89 e5                	mov    %esp,%ebp
  801daa:	56                   	push   %esi
  801dab:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801dac:	8b 75 18             	mov    0x18(%ebp),%esi
  801daf:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801db2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801db5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801db8:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbb:	56                   	push   %esi
  801dbc:	53                   	push   %ebx
  801dbd:	51                   	push   %ecx
  801dbe:	52                   	push   %edx
  801dbf:	50                   	push   %eax
  801dc0:	6a 09                	push   $0x9
  801dc2:	e8 20 ff ff ff       	call   801ce7 <syscall>
  801dc7:	83 c4 18             	add    $0x18,%esp
}
  801dca:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dcd:	5b                   	pop    %ebx
  801dce:	5e                   	pop    %esi
  801dcf:	5d                   	pop    %ebp
  801dd0:	c3                   	ret    

00801dd1 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801dd1:	55                   	push   %ebp
  801dd2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801dd4:	6a 00                	push   $0x0
  801dd6:	6a 00                	push   $0x0
  801dd8:	6a 00                	push   $0x0
  801dda:	6a 00                	push   $0x0
  801ddc:	ff 75 08             	pushl  0x8(%ebp)
  801ddf:	6a 0a                	push   $0xa
  801de1:	e8 01 ff ff ff       	call   801ce7 <syscall>
  801de6:	83 c4 18             	add    $0x18,%esp
}
  801de9:	c9                   	leave  
  801dea:	c3                   	ret    

00801deb <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801deb:	55                   	push   %ebp
  801dec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801dee:	6a 00                	push   $0x0
  801df0:	6a 00                	push   $0x0
  801df2:	6a 00                	push   $0x0
  801df4:	ff 75 0c             	pushl  0xc(%ebp)
  801df7:	ff 75 08             	pushl  0x8(%ebp)
  801dfa:	6a 0b                	push   $0xb
  801dfc:	e8 e6 fe ff ff       	call   801ce7 <syscall>
  801e01:	83 c4 18             	add    $0x18,%esp
}
  801e04:	c9                   	leave  
  801e05:	c3                   	ret    

00801e06 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801e06:	55                   	push   %ebp
  801e07:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801e09:	6a 00                	push   $0x0
  801e0b:	6a 00                	push   $0x0
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 00                	push   $0x0
  801e13:	6a 0c                	push   $0xc
  801e15:	e8 cd fe ff ff       	call   801ce7 <syscall>
  801e1a:	83 c4 18             	add    $0x18,%esp
}
  801e1d:	c9                   	leave  
  801e1e:	c3                   	ret    

00801e1f <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801e1f:	55                   	push   %ebp
  801e20:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801e22:	6a 00                	push   $0x0
  801e24:	6a 00                	push   $0x0
  801e26:	6a 00                	push   $0x0
  801e28:	6a 00                	push   $0x0
  801e2a:	6a 00                	push   $0x0
  801e2c:	6a 0d                	push   $0xd
  801e2e:	e8 b4 fe ff ff       	call   801ce7 <syscall>
  801e33:	83 c4 18             	add    $0x18,%esp
}
  801e36:	c9                   	leave  
  801e37:	c3                   	ret    

00801e38 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801e38:	55                   	push   %ebp
  801e39:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801e3b:	6a 00                	push   $0x0
  801e3d:	6a 00                	push   $0x0
  801e3f:	6a 00                	push   $0x0
  801e41:	6a 00                	push   $0x0
  801e43:	6a 00                	push   $0x0
  801e45:	6a 0e                	push   $0xe
  801e47:	e8 9b fe ff ff       	call   801ce7 <syscall>
  801e4c:	83 c4 18             	add    $0x18,%esp
}
  801e4f:	c9                   	leave  
  801e50:	c3                   	ret    

00801e51 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801e51:	55                   	push   %ebp
  801e52:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801e54:	6a 00                	push   $0x0
  801e56:	6a 00                	push   $0x0
  801e58:	6a 00                	push   $0x0
  801e5a:	6a 00                	push   $0x0
  801e5c:	6a 00                	push   $0x0
  801e5e:	6a 0f                	push   $0xf
  801e60:	e8 82 fe ff ff       	call   801ce7 <syscall>
  801e65:	83 c4 18             	add    $0x18,%esp
}
  801e68:	c9                   	leave  
  801e69:	c3                   	ret    

00801e6a <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801e6a:	55                   	push   %ebp
  801e6b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801e6d:	6a 00                	push   $0x0
  801e6f:	6a 00                	push   $0x0
  801e71:	6a 00                	push   $0x0
  801e73:	6a 00                	push   $0x0
  801e75:	ff 75 08             	pushl  0x8(%ebp)
  801e78:	6a 10                	push   $0x10
  801e7a:	e8 68 fe ff ff       	call   801ce7 <syscall>
  801e7f:	83 c4 18             	add    $0x18,%esp
}
  801e82:	c9                   	leave  
  801e83:	c3                   	ret    

00801e84 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801e84:	55                   	push   %ebp
  801e85:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801e87:	6a 00                	push   $0x0
  801e89:	6a 00                	push   $0x0
  801e8b:	6a 00                	push   $0x0
  801e8d:	6a 00                	push   $0x0
  801e8f:	6a 00                	push   $0x0
  801e91:	6a 11                	push   $0x11
  801e93:	e8 4f fe ff ff       	call   801ce7 <syscall>
  801e98:	83 c4 18             	add    $0x18,%esp
}
  801e9b:	90                   	nop
  801e9c:	c9                   	leave  
  801e9d:	c3                   	ret    

00801e9e <sys_cputc>:

void
sys_cputc(const char c)
{
  801e9e:	55                   	push   %ebp
  801e9f:	89 e5                	mov    %esp,%ebp
  801ea1:	83 ec 04             	sub    $0x4,%esp
  801ea4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801eaa:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801eae:	6a 00                	push   $0x0
  801eb0:	6a 00                	push   $0x0
  801eb2:	6a 00                	push   $0x0
  801eb4:	6a 00                	push   $0x0
  801eb6:	50                   	push   %eax
  801eb7:	6a 01                	push   $0x1
  801eb9:	e8 29 fe ff ff       	call   801ce7 <syscall>
  801ebe:	83 c4 18             	add    $0x18,%esp
}
  801ec1:	90                   	nop
  801ec2:	c9                   	leave  
  801ec3:	c3                   	ret    

00801ec4 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801ec4:	55                   	push   %ebp
  801ec5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801ec7:	6a 00                	push   $0x0
  801ec9:	6a 00                	push   $0x0
  801ecb:	6a 00                	push   $0x0
  801ecd:	6a 00                	push   $0x0
  801ecf:	6a 00                	push   $0x0
  801ed1:	6a 14                	push   $0x14
  801ed3:	e8 0f fe ff ff       	call   801ce7 <syscall>
  801ed8:	83 c4 18             	add    $0x18,%esp
}
  801edb:	90                   	nop
  801edc:	c9                   	leave  
  801edd:	c3                   	ret    

00801ede <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801ede:	55                   	push   %ebp
  801edf:	89 e5                	mov    %esp,%ebp
  801ee1:	83 ec 04             	sub    $0x4,%esp
  801ee4:	8b 45 10             	mov    0x10(%ebp),%eax
  801ee7:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801eea:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801eed:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef4:	6a 00                	push   $0x0
  801ef6:	51                   	push   %ecx
  801ef7:	52                   	push   %edx
  801ef8:	ff 75 0c             	pushl  0xc(%ebp)
  801efb:	50                   	push   %eax
  801efc:	6a 15                	push   $0x15
  801efe:	e8 e4 fd ff ff       	call   801ce7 <syscall>
  801f03:	83 c4 18             	add    $0x18,%esp
}
  801f06:	c9                   	leave  
  801f07:	c3                   	ret    

00801f08 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801f08:	55                   	push   %ebp
  801f09:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801f0b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f11:	6a 00                	push   $0x0
  801f13:	6a 00                	push   $0x0
  801f15:	6a 00                	push   $0x0
  801f17:	52                   	push   %edx
  801f18:	50                   	push   %eax
  801f19:	6a 16                	push   $0x16
  801f1b:	e8 c7 fd ff ff       	call   801ce7 <syscall>
  801f20:	83 c4 18             	add    $0x18,%esp
}
  801f23:	c9                   	leave  
  801f24:	c3                   	ret    

00801f25 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801f25:	55                   	push   %ebp
  801f26:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801f28:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f31:	6a 00                	push   $0x0
  801f33:	6a 00                	push   $0x0
  801f35:	51                   	push   %ecx
  801f36:	52                   	push   %edx
  801f37:	50                   	push   %eax
  801f38:	6a 17                	push   $0x17
  801f3a:	e8 a8 fd ff ff       	call   801ce7 <syscall>
  801f3f:	83 c4 18             	add    $0x18,%esp
}
  801f42:	c9                   	leave  
  801f43:	c3                   	ret    

00801f44 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801f44:	55                   	push   %ebp
  801f45:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801f47:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4d:	6a 00                	push   $0x0
  801f4f:	6a 00                	push   $0x0
  801f51:	6a 00                	push   $0x0
  801f53:	52                   	push   %edx
  801f54:	50                   	push   %eax
  801f55:	6a 18                	push   $0x18
  801f57:	e8 8b fd ff ff       	call   801ce7 <syscall>
  801f5c:	83 c4 18             	add    $0x18,%esp
}
  801f5f:	c9                   	leave  
  801f60:	c3                   	ret    

00801f61 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801f61:	55                   	push   %ebp
  801f62:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801f64:	8b 45 08             	mov    0x8(%ebp),%eax
  801f67:	6a 00                	push   $0x0
  801f69:	ff 75 14             	pushl  0x14(%ebp)
  801f6c:	ff 75 10             	pushl  0x10(%ebp)
  801f6f:	ff 75 0c             	pushl  0xc(%ebp)
  801f72:	50                   	push   %eax
  801f73:	6a 19                	push   $0x19
  801f75:	e8 6d fd ff ff       	call   801ce7 <syscall>
  801f7a:	83 c4 18             	add    $0x18,%esp
}
  801f7d:	c9                   	leave  
  801f7e:	c3                   	ret    

00801f7f <sys_run_env>:

void sys_run_env(int32 envId)
{
  801f7f:	55                   	push   %ebp
  801f80:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801f82:	8b 45 08             	mov    0x8(%ebp),%eax
  801f85:	6a 00                	push   $0x0
  801f87:	6a 00                	push   $0x0
  801f89:	6a 00                	push   $0x0
  801f8b:	6a 00                	push   $0x0
  801f8d:	50                   	push   %eax
  801f8e:	6a 1a                	push   $0x1a
  801f90:	e8 52 fd ff ff       	call   801ce7 <syscall>
  801f95:	83 c4 18             	add    $0x18,%esp
}
  801f98:	90                   	nop
  801f99:	c9                   	leave  
  801f9a:	c3                   	ret    

00801f9b <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801f9b:	55                   	push   %ebp
  801f9c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801f9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa1:	6a 00                	push   $0x0
  801fa3:	6a 00                	push   $0x0
  801fa5:	6a 00                	push   $0x0
  801fa7:	6a 00                	push   $0x0
  801fa9:	50                   	push   %eax
  801faa:	6a 1b                	push   $0x1b
  801fac:	e8 36 fd ff ff       	call   801ce7 <syscall>
  801fb1:	83 c4 18             	add    $0x18,%esp
}
  801fb4:	c9                   	leave  
  801fb5:	c3                   	ret    

00801fb6 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801fb6:	55                   	push   %ebp
  801fb7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801fb9:	6a 00                	push   $0x0
  801fbb:	6a 00                	push   $0x0
  801fbd:	6a 00                	push   $0x0
  801fbf:	6a 00                	push   $0x0
  801fc1:	6a 00                	push   $0x0
  801fc3:	6a 05                	push   $0x5
  801fc5:	e8 1d fd ff ff       	call   801ce7 <syscall>
  801fca:	83 c4 18             	add    $0x18,%esp
}
  801fcd:	c9                   	leave  
  801fce:	c3                   	ret    

00801fcf <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801fcf:	55                   	push   %ebp
  801fd0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801fd2:	6a 00                	push   $0x0
  801fd4:	6a 00                	push   $0x0
  801fd6:	6a 00                	push   $0x0
  801fd8:	6a 00                	push   $0x0
  801fda:	6a 00                	push   $0x0
  801fdc:	6a 06                	push   $0x6
  801fde:	e8 04 fd ff ff       	call   801ce7 <syscall>
  801fe3:	83 c4 18             	add    $0x18,%esp
}
  801fe6:	c9                   	leave  
  801fe7:	c3                   	ret    

00801fe8 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801fe8:	55                   	push   %ebp
  801fe9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801feb:	6a 00                	push   $0x0
  801fed:	6a 00                	push   $0x0
  801fef:	6a 00                	push   $0x0
  801ff1:	6a 00                	push   $0x0
  801ff3:	6a 00                	push   $0x0
  801ff5:	6a 07                	push   $0x7
  801ff7:	e8 eb fc ff ff       	call   801ce7 <syscall>
  801ffc:	83 c4 18             	add    $0x18,%esp
}
  801fff:	c9                   	leave  
  802000:	c3                   	ret    

00802001 <sys_exit_env>:


void sys_exit_env(void)
{
  802001:	55                   	push   %ebp
  802002:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802004:	6a 00                	push   $0x0
  802006:	6a 00                	push   $0x0
  802008:	6a 00                	push   $0x0
  80200a:	6a 00                	push   $0x0
  80200c:	6a 00                	push   $0x0
  80200e:	6a 1c                	push   $0x1c
  802010:	e8 d2 fc ff ff       	call   801ce7 <syscall>
  802015:	83 c4 18             	add    $0x18,%esp
}
  802018:	90                   	nop
  802019:	c9                   	leave  
  80201a:	c3                   	ret    

0080201b <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80201b:	55                   	push   %ebp
  80201c:	89 e5                	mov    %esp,%ebp
  80201e:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802021:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802024:	8d 50 04             	lea    0x4(%eax),%edx
  802027:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80202a:	6a 00                	push   $0x0
  80202c:	6a 00                	push   $0x0
  80202e:	6a 00                	push   $0x0
  802030:	52                   	push   %edx
  802031:	50                   	push   %eax
  802032:	6a 1d                	push   $0x1d
  802034:	e8 ae fc ff ff       	call   801ce7 <syscall>
  802039:	83 c4 18             	add    $0x18,%esp
	return result;
  80203c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80203f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802042:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802045:	89 01                	mov    %eax,(%ecx)
  802047:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80204a:	8b 45 08             	mov    0x8(%ebp),%eax
  80204d:	c9                   	leave  
  80204e:	c2 04 00             	ret    $0x4

00802051 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802051:	55                   	push   %ebp
  802052:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802054:	6a 00                	push   $0x0
  802056:	6a 00                	push   $0x0
  802058:	ff 75 10             	pushl  0x10(%ebp)
  80205b:	ff 75 0c             	pushl  0xc(%ebp)
  80205e:	ff 75 08             	pushl  0x8(%ebp)
  802061:	6a 13                	push   $0x13
  802063:	e8 7f fc ff ff       	call   801ce7 <syscall>
  802068:	83 c4 18             	add    $0x18,%esp
	return ;
  80206b:	90                   	nop
}
  80206c:	c9                   	leave  
  80206d:	c3                   	ret    

0080206e <sys_rcr2>:
uint32 sys_rcr2()
{
  80206e:	55                   	push   %ebp
  80206f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802071:	6a 00                	push   $0x0
  802073:	6a 00                	push   $0x0
  802075:	6a 00                	push   $0x0
  802077:	6a 00                	push   $0x0
  802079:	6a 00                	push   $0x0
  80207b:	6a 1e                	push   $0x1e
  80207d:	e8 65 fc ff ff       	call   801ce7 <syscall>
  802082:	83 c4 18             	add    $0x18,%esp
}
  802085:	c9                   	leave  
  802086:	c3                   	ret    

00802087 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802087:	55                   	push   %ebp
  802088:	89 e5                	mov    %esp,%ebp
  80208a:	83 ec 04             	sub    $0x4,%esp
  80208d:	8b 45 08             	mov    0x8(%ebp),%eax
  802090:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802093:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802097:	6a 00                	push   $0x0
  802099:	6a 00                	push   $0x0
  80209b:	6a 00                	push   $0x0
  80209d:	6a 00                	push   $0x0
  80209f:	50                   	push   %eax
  8020a0:	6a 1f                	push   $0x1f
  8020a2:	e8 40 fc ff ff       	call   801ce7 <syscall>
  8020a7:	83 c4 18             	add    $0x18,%esp
	return ;
  8020aa:	90                   	nop
}
  8020ab:	c9                   	leave  
  8020ac:	c3                   	ret    

008020ad <rsttst>:
void rsttst()
{
  8020ad:	55                   	push   %ebp
  8020ae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8020b0:	6a 00                	push   $0x0
  8020b2:	6a 00                	push   $0x0
  8020b4:	6a 00                	push   $0x0
  8020b6:	6a 00                	push   $0x0
  8020b8:	6a 00                	push   $0x0
  8020ba:	6a 21                	push   $0x21
  8020bc:	e8 26 fc ff ff       	call   801ce7 <syscall>
  8020c1:	83 c4 18             	add    $0x18,%esp
	return ;
  8020c4:	90                   	nop
}
  8020c5:	c9                   	leave  
  8020c6:	c3                   	ret    

008020c7 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8020c7:	55                   	push   %ebp
  8020c8:	89 e5                	mov    %esp,%ebp
  8020ca:	83 ec 04             	sub    $0x4,%esp
  8020cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8020d0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8020d3:	8b 55 18             	mov    0x18(%ebp),%edx
  8020d6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8020da:	52                   	push   %edx
  8020db:	50                   	push   %eax
  8020dc:	ff 75 10             	pushl  0x10(%ebp)
  8020df:	ff 75 0c             	pushl  0xc(%ebp)
  8020e2:	ff 75 08             	pushl  0x8(%ebp)
  8020e5:	6a 20                	push   $0x20
  8020e7:	e8 fb fb ff ff       	call   801ce7 <syscall>
  8020ec:	83 c4 18             	add    $0x18,%esp
	return ;
  8020ef:	90                   	nop
}
  8020f0:	c9                   	leave  
  8020f1:	c3                   	ret    

008020f2 <chktst>:
void chktst(uint32 n)
{
  8020f2:	55                   	push   %ebp
  8020f3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8020f5:	6a 00                	push   $0x0
  8020f7:	6a 00                	push   $0x0
  8020f9:	6a 00                	push   $0x0
  8020fb:	6a 00                	push   $0x0
  8020fd:	ff 75 08             	pushl  0x8(%ebp)
  802100:	6a 22                	push   $0x22
  802102:	e8 e0 fb ff ff       	call   801ce7 <syscall>
  802107:	83 c4 18             	add    $0x18,%esp
	return ;
  80210a:	90                   	nop
}
  80210b:	c9                   	leave  
  80210c:	c3                   	ret    

0080210d <inctst>:

void inctst()
{
  80210d:	55                   	push   %ebp
  80210e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802110:	6a 00                	push   $0x0
  802112:	6a 00                	push   $0x0
  802114:	6a 00                	push   $0x0
  802116:	6a 00                	push   $0x0
  802118:	6a 00                	push   $0x0
  80211a:	6a 23                	push   $0x23
  80211c:	e8 c6 fb ff ff       	call   801ce7 <syscall>
  802121:	83 c4 18             	add    $0x18,%esp
	return ;
  802124:	90                   	nop
}
  802125:	c9                   	leave  
  802126:	c3                   	ret    

00802127 <gettst>:
uint32 gettst()
{
  802127:	55                   	push   %ebp
  802128:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80212a:	6a 00                	push   $0x0
  80212c:	6a 00                	push   $0x0
  80212e:	6a 00                	push   $0x0
  802130:	6a 00                	push   $0x0
  802132:	6a 00                	push   $0x0
  802134:	6a 24                	push   $0x24
  802136:	e8 ac fb ff ff       	call   801ce7 <syscall>
  80213b:	83 c4 18             	add    $0x18,%esp
}
  80213e:	c9                   	leave  
  80213f:	c3                   	ret    

00802140 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  802140:	55                   	push   %ebp
  802141:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802143:	6a 00                	push   $0x0
  802145:	6a 00                	push   $0x0
  802147:	6a 00                	push   $0x0
  802149:	6a 00                	push   $0x0
  80214b:	6a 00                	push   $0x0
  80214d:	6a 25                	push   $0x25
  80214f:	e8 93 fb ff ff       	call   801ce7 <syscall>
  802154:	83 c4 18             	add    $0x18,%esp
  802157:	a3 60 c0 81 00       	mov    %eax,0x81c060
	return uheapPlaceStrategy ;
  80215c:	a1 60 c0 81 00       	mov    0x81c060,%eax
}
  802161:	c9                   	leave  
  802162:	c3                   	ret    

00802163 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802163:	55                   	push   %ebp
  802164:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  802166:	8b 45 08             	mov    0x8(%ebp),%eax
  802169:	a3 60 c0 81 00       	mov    %eax,0x81c060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80216e:	6a 00                	push   $0x0
  802170:	6a 00                	push   $0x0
  802172:	6a 00                	push   $0x0
  802174:	6a 00                	push   $0x0
  802176:	ff 75 08             	pushl  0x8(%ebp)
  802179:	6a 26                	push   $0x26
  80217b:	e8 67 fb ff ff       	call   801ce7 <syscall>
  802180:	83 c4 18             	add    $0x18,%esp
	return ;
  802183:	90                   	nop
}
  802184:	c9                   	leave  
  802185:	c3                   	ret    

00802186 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802186:	55                   	push   %ebp
  802187:	89 e5                	mov    %esp,%ebp
  802189:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80218a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80218d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802190:	8b 55 0c             	mov    0xc(%ebp),%edx
  802193:	8b 45 08             	mov    0x8(%ebp),%eax
  802196:	6a 00                	push   $0x0
  802198:	53                   	push   %ebx
  802199:	51                   	push   %ecx
  80219a:	52                   	push   %edx
  80219b:	50                   	push   %eax
  80219c:	6a 27                	push   $0x27
  80219e:	e8 44 fb ff ff       	call   801ce7 <syscall>
  8021a3:	83 c4 18             	add    $0x18,%esp
}
  8021a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021a9:	c9                   	leave  
  8021aa:	c3                   	ret    

008021ab <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8021ab:	55                   	push   %ebp
  8021ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8021ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b4:	6a 00                	push   $0x0
  8021b6:	6a 00                	push   $0x0
  8021b8:	6a 00                	push   $0x0
  8021ba:	52                   	push   %edx
  8021bb:	50                   	push   %eax
  8021bc:	6a 28                	push   $0x28
  8021be:	e8 24 fb ff ff       	call   801ce7 <syscall>
  8021c3:	83 c4 18             	add    $0x18,%esp
}
  8021c6:	c9                   	leave  
  8021c7:	c3                   	ret    

008021c8 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8021c8:	55                   	push   %ebp
  8021c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8021cb:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8021ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d4:	6a 00                	push   $0x0
  8021d6:	51                   	push   %ecx
  8021d7:	ff 75 10             	pushl  0x10(%ebp)
  8021da:	52                   	push   %edx
  8021db:	50                   	push   %eax
  8021dc:	6a 29                	push   $0x29
  8021de:	e8 04 fb ff ff       	call   801ce7 <syscall>
  8021e3:	83 c4 18             	add    $0x18,%esp
}
  8021e6:	c9                   	leave  
  8021e7:	c3                   	ret    

008021e8 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8021e8:	55                   	push   %ebp
  8021e9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8021eb:	6a 00                	push   $0x0
  8021ed:	6a 00                	push   $0x0
  8021ef:	ff 75 10             	pushl  0x10(%ebp)
  8021f2:	ff 75 0c             	pushl  0xc(%ebp)
  8021f5:	ff 75 08             	pushl  0x8(%ebp)
  8021f8:	6a 12                	push   $0x12
  8021fa:	e8 e8 fa ff ff       	call   801ce7 <syscall>
  8021ff:	83 c4 18             	add    $0x18,%esp
	return ;
  802202:	90                   	nop
}
  802203:	c9                   	leave  
  802204:	c3                   	ret    

00802205 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802205:	55                   	push   %ebp
  802206:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802208:	8b 55 0c             	mov    0xc(%ebp),%edx
  80220b:	8b 45 08             	mov    0x8(%ebp),%eax
  80220e:	6a 00                	push   $0x0
  802210:	6a 00                	push   $0x0
  802212:	6a 00                	push   $0x0
  802214:	52                   	push   %edx
  802215:	50                   	push   %eax
  802216:	6a 2a                	push   $0x2a
  802218:	e8 ca fa ff ff       	call   801ce7 <syscall>
  80221d:	83 c4 18             	add    $0x18,%esp
	return;
  802220:	90                   	nop
}
  802221:	c9                   	leave  
  802222:	c3                   	ret    

00802223 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  802223:	55                   	push   %ebp
  802224:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  802226:	6a 00                	push   $0x0
  802228:	6a 00                	push   $0x0
  80222a:	6a 00                	push   $0x0
  80222c:	6a 00                	push   $0x0
  80222e:	6a 00                	push   $0x0
  802230:	6a 2b                	push   $0x2b
  802232:	e8 b0 fa ff ff       	call   801ce7 <syscall>
  802237:	83 c4 18             	add    $0x18,%esp
}
  80223a:	c9                   	leave  
  80223b:	c3                   	ret    

0080223c <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80223c:	55                   	push   %ebp
  80223d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80223f:	6a 00                	push   $0x0
  802241:	6a 00                	push   $0x0
  802243:	6a 00                	push   $0x0
  802245:	ff 75 0c             	pushl  0xc(%ebp)
  802248:	ff 75 08             	pushl  0x8(%ebp)
  80224b:	6a 2d                	push   $0x2d
  80224d:	e8 95 fa ff ff       	call   801ce7 <syscall>
  802252:	83 c4 18             	add    $0x18,%esp
	return;
  802255:	90                   	nop
}
  802256:	c9                   	leave  
  802257:	c3                   	ret    

00802258 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802258:	55                   	push   %ebp
  802259:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80225b:	6a 00                	push   $0x0
  80225d:	6a 00                	push   $0x0
  80225f:	6a 00                	push   $0x0
  802261:	ff 75 0c             	pushl  0xc(%ebp)
  802264:	ff 75 08             	pushl  0x8(%ebp)
  802267:	6a 2c                	push   $0x2c
  802269:	e8 79 fa ff ff       	call   801ce7 <syscall>
  80226e:	83 c4 18             	add    $0x18,%esp
	return ;
  802271:	90                   	nop
}
  802272:	c9                   	leave  
  802273:	c3                   	ret    

00802274 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  802274:	55                   	push   %ebp
  802275:	89 e5                	mov    %esp,%ebp
  802277:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  80227a:	83 ec 04             	sub    $0x4,%esp
  80227d:	68 88 2f 80 00       	push   $0x802f88
  802282:	68 25 01 00 00       	push   $0x125
  802287:	68 bb 2f 80 00       	push   $0x802fbb
  80228c:	e8 e4 e4 ff ff       	call   800775 <_panic>

00802291 <to_page_va>:
//==================================================================================//
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  802291:	55                   	push   %ebp
  802292:	89 e5                	mov    %esp,%ebp
  802294:	83 ec 10             	sub    $0x10,%esp
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  802297:	8b 45 08             	mov    0x8(%ebp),%eax
  80229a:	ba 60 40 80 00       	mov    $0x804060,%edx
  80229f:	29 d0                	sub    %edx,%eax
  8022a1:	c1 f8 02             	sar    $0x2,%eax
  8022a4:	89 c2                	mov    %eax,%edx
  8022a6:	89 d0                	mov    %edx,%eax
  8022a8:	c1 e0 02             	shl    $0x2,%eax
  8022ab:	01 d0                	add    %edx,%eax
  8022ad:	c1 e0 02             	shl    $0x2,%eax
  8022b0:	01 d0                	add    %edx,%eax
  8022b2:	c1 e0 02             	shl    $0x2,%eax
  8022b5:	01 d0                	add    %edx,%eax
  8022b7:	89 c1                	mov    %eax,%ecx
  8022b9:	c1 e1 08             	shl    $0x8,%ecx
  8022bc:	01 c8                	add    %ecx,%eax
  8022be:	89 c1                	mov    %eax,%ecx
  8022c0:	c1 e1 10             	shl    $0x10,%ecx
  8022c3:	01 c8                	add    %ecx,%eax
  8022c5:	01 c0                	add    %eax,%eax
  8022c7:	01 d0                	add    %edx,%eax
  8022c9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  8022cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022cf:	c1 e0 0c             	shl    $0xc,%eax
  8022d2:	89 c2                	mov    %eax,%edx
  8022d4:	a1 64 c0 81 00       	mov    0x81c064,%eax
  8022d9:	01 d0                	add    %edx,%eax
}
  8022db:	c9                   	leave  
  8022dc:	c3                   	ret    

008022dd <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  8022dd:	55                   	push   %ebp
  8022de:	89 e5                	mov    %esp,%ebp
  8022e0:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  8022e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e6:	05 00 00 00 02       	add    $0x2000000,%eax
  8022eb:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8022ee:	73 16                	jae    802306 <initialize_dynamic_allocator+0x29>
  8022f0:	68 cc 2f 80 00       	push   $0x802fcc
  8022f5:	68 f2 2f 80 00       	push   $0x802ff2
  8022fa:	6a 26                	push   $0x26
  8022fc:	68 07 30 80 00       	push   $0x803007
  802301:	e8 6f e4 ff ff       	call   800775 <_panic>
		is_initialized = 1;
  802306:	c7 05 28 40 80 00 01 	movl   $0x1,0x804028
  80230d:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	//Comment the following line
	panic("initialize_dynamic_allocator() Not implemented yet");
  802310:	83 ec 04             	sub    $0x4,%esp
  802313:	68 20 30 80 00       	push   $0x803020
  802318:	6a 2e                	push   $0x2e
  80231a:	68 07 30 80 00       	push   $0x803007
  80231f:	e8 51 e4 ff ff       	call   800775 <_panic>

00802324 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  802324:	55                   	push   %ebp
  802325:	89 e5                	mov    %esp,%ebp
  802327:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	//Comment the following line
	panic("get_block_size() Not implemented yet");
  80232a:	83 ec 04             	sub    $0x4,%esp
  80232d:	68 54 30 80 00       	push   $0x803054
  802332:	6a 3a                	push   $0x3a
  802334:	68 07 30 80 00       	push   $0x803007
  802339:	e8 37 e4 ff ff       	call   800775 <_panic>

0080233e <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  80233e:	55                   	push   %ebp
  80233f:	89 e5                	mov    %esp,%ebp
  802341:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  802344:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  80234b:	76 16                	jbe    802363 <alloc_block+0x25>
  80234d:	68 7c 30 80 00       	push   $0x80307c
  802352:	68 f2 2f 80 00       	push   $0x802ff2
  802357:	6a 46                	push   $0x46
  802359:	68 07 30 80 00       	push   $0x803007
  80235e:	e8 12 e4 ff ff       	call   800775 <_panic>
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	panic("alloc_block() Not implemented yet");
  802363:	83 ec 04             	sub    $0x4,%esp
  802366:	68 a0 30 80 00       	push   $0x8030a0
  80236b:	6a 4d                	push   $0x4d
  80236d:	68 07 30 80 00       	push   $0x803007
  802372:	e8 fe e3 ff ff       	call   800775 <_panic>

00802377 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  802377:	55                   	push   %ebp
  802378:	89 e5                	mov    %esp,%ebp
  80237a:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  80237d:	8b 55 08             	mov    0x8(%ebp),%edx
  802380:	a1 64 c0 81 00       	mov    0x81c064,%eax
  802385:	39 c2                	cmp    %eax,%edx
  802387:	72 0c                	jb     802395 <free_block+0x1e>
  802389:	8b 55 08             	mov    0x8(%ebp),%edx
  80238c:	a1 40 40 80 00       	mov    0x804040,%eax
  802391:	39 c2                	cmp    %eax,%edx
  802393:	72 16                	jb     8023ab <free_block+0x34>
  802395:	68 c4 30 80 00       	push   $0x8030c4
  80239a:	68 f2 2f 80 00       	push   $0x802ff2
  80239f:	6a 5b                	push   $0x5b
  8023a1:	68 07 30 80 00       	push   $0x803007
  8023a6:	e8 ca e3 ff ff       	call   800775 <_panic>
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	panic("free_block() Not implemented yet");
  8023ab:	83 ec 04             	sub    $0x4,%esp
  8023ae:	68 fc 30 80 00       	push   $0x8030fc
  8023b3:	6a 63                	push   $0x63
  8023b5:	68 07 30 80 00       	push   $0x803007
  8023ba:	e8 b6 e3 ff ff       	call   800775 <_panic>

008023bf <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  8023bf:	55                   	push   %ebp
  8023c0:	89 e5                	mov    %esp,%ebp
  8023c2:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  8023c5:	83 ec 04             	sub    $0x4,%esp
  8023c8:	68 20 31 80 00       	push   $0x803120
  8023cd:	6a 72                	push   $0x72
  8023cf:	68 07 30 80 00       	push   $0x803007
  8023d4:	e8 9c e3 ff ff       	call   800775 <_panic>
  8023d9:	66 90                	xchg   %ax,%ax
  8023db:	90                   	nop

008023dc <__udivdi3>:
  8023dc:	55                   	push   %ebp
  8023dd:	57                   	push   %edi
  8023de:	56                   	push   %esi
  8023df:	53                   	push   %ebx
  8023e0:	83 ec 1c             	sub    $0x1c,%esp
  8023e3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8023e7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8023eb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8023ef:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8023f3:	89 ca                	mov    %ecx,%edx
  8023f5:	89 f8                	mov    %edi,%eax
  8023f7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8023fb:	85 f6                	test   %esi,%esi
  8023fd:	75 2d                	jne    80242c <__udivdi3+0x50>
  8023ff:	39 cf                	cmp    %ecx,%edi
  802401:	77 65                	ja     802468 <__udivdi3+0x8c>
  802403:	89 fd                	mov    %edi,%ebp
  802405:	85 ff                	test   %edi,%edi
  802407:	75 0b                	jne    802414 <__udivdi3+0x38>
  802409:	b8 01 00 00 00       	mov    $0x1,%eax
  80240e:	31 d2                	xor    %edx,%edx
  802410:	f7 f7                	div    %edi
  802412:	89 c5                	mov    %eax,%ebp
  802414:	31 d2                	xor    %edx,%edx
  802416:	89 c8                	mov    %ecx,%eax
  802418:	f7 f5                	div    %ebp
  80241a:	89 c1                	mov    %eax,%ecx
  80241c:	89 d8                	mov    %ebx,%eax
  80241e:	f7 f5                	div    %ebp
  802420:	89 cf                	mov    %ecx,%edi
  802422:	89 fa                	mov    %edi,%edx
  802424:	83 c4 1c             	add    $0x1c,%esp
  802427:	5b                   	pop    %ebx
  802428:	5e                   	pop    %esi
  802429:	5f                   	pop    %edi
  80242a:	5d                   	pop    %ebp
  80242b:	c3                   	ret    
  80242c:	39 ce                	cmp    %ecx,%esi
  80242e:	77 28                	ja     802458 <__udivdi3+0x7c>
  802430:	0f bd fe             	bsr    %esi,%edi
  802433:	83 f7 1f             	xor    $0x1f,%edi
  802436:	75 40                	jne    802478 <__udivdi3+0x9c>
  802438:	39 ce                	cmp    %ecx,%esi
  80243a:	72 0a                	jb     802446 <__udivdi3+0x6a>
  80243c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802440:	0f 87 9e 00 00 00    	ja     8024e4 <__udivdi3+0x108>
  802446:	b8 01 00 00 00       	mov    $0x1,%eax
  80244b:	89 fa                	mov    %edi,%edx
  80244d:	83 c4 1c             	add    $0x1c,%esp
  802450:	5b                   	pop    %ebx
  802451:	5e                   	pop    %esi
  802452:	5f                   	pop    %edi
  802453:	5d                   	pop    %ebp
  802454:	c3                   	ret    
  802455:	8d 76 00             	lea    0x0(%esi),%esi
  802458:	31 ff                	xor    %edi,%edi
  80245a:	31 c0                	xor    %eax,%eax
  80245c:	89 fa                	mov    %edi,%edx
  80245e:	83 c4 1c             	add    $0x1c,%esp
  802461:	5b                   	pop    %ebx
  802462:	5e                   	pop    %esi
  802463:	5f                   	pop    %edi
  802464:	5d                   	pop    %ebp
  802465:	c3                   	ret    
  802466:	66 90                	xchg   %ax,%ax
  802468:	89 d8                	mov    %ebx,%eax
  80246a:	f7 f7                	div    %edi
  80246c:	31 ff                	xor    %edi,%edi
  80246e:	89 fa                	mov    %edi,%edx
  802470:	83 c4 1c             	add    $0x1c,%esp
  802473:	5b                   	pop    %ebx
  802474:	5e                   	pop    %esi
  802475:	5f                   	pop    %edi
  802476:	5d                   	pop    %ebp
  802477:	c3                   	ret    
  802478:	bd 20 00 00 00       	mov    $0x20,%ebp
  80247d:	89 eb                	mov    %ebp,%ebx
  80247f:	29 fb                	sub    %edi,%ebx
  802481:	89 f9                	mov    %edi,%ecx
  802483:	d3 e6                	shl    %cl,%esi
  802485:	89 c5                	mov    %eax,%ebp
  802487:	88 d9                	mov    %bl,%cl
  802489:	d3 ed                	shr    %cl,%ebp
  80248b:	89 e9                	mov    %ebp,%ecx
  80248d:	09 f1                	or     %esi,%ecx
  80248f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802493:	89 f9                	mov    %edi,%ecx
  802495:	d3 e0                	shl    %cl,%eax
  802497:	89 c5                	mov    %eax,%ebp
  802499:	89 d6                	mov    %edx,%esi
  80249b:	88 d9                	mov    %bl,%cl
  80249d:	d3 ee                	shr    %cl,%esi
  80249f:	89 f9                	mov    %edi,%ecx
  8024a1:	d3 e2                	shl    %cl,%edx
  8024a3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8024a7:	88 d9                	mov    %bl,%cl
  8024a9:	d3 e8                	shr    %cl,%eax
  8024ab:	09 c2                	or     %eax,%edx
  8024ad:	89 d0                	mov    %edx,%eax
  8024af:	89 f2                	mov    %esi,%edx
  8024b1:	f7 74 24 0c          	divl   0xc(%esp)
  8024b5:	89 d6                	mov    %edx,%esi
  8024b7:	89 c3                	mov    %eax,%ebx
  8024b9:	f7 e5                	mul    %ebp
  8024bb:	39 d6                	cmp    %edx,%esi
  8024bd:	72 19                	jb     8024d8 <__udivdi3+0xfc>
  8024bf:	74 0b                	je     8024cc <__udivdi3+0xf0>
  8024c1:	89 d8                	mov    %ebx,%eax
  8024c3:	31 ff                	xor    %edi,%edi
  8024c5:	e9 58 ff ff ff       	jmp    802422 <__udivdi3+0x46>
  8024ca:	66 90                	xchg   %ax,%ax
  8024cc:	8b 54 24 08          	mov    0x8(%esp),%edx
  8024d0:	89 f9                	mov    %edi,%ecx
  8024d2:	d3 e2                	shl    %cl,%edx
  8024d4:	39 c2                	cmp    %eax,%edx
  8024d6:	73 e9                	jae    8024c1 <__udivdi3+0xe5>
  8024d8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8024db:	31 ff                	xor    %edi,%edi
  8024dd:	e9 40 ff ff ff       	jmp    802422 <__udivdi3+0x46>
  8024e2:	66 90                	xchg   %ax,%ax
  8024e4:	31 c0                	xor    %eax,%eax
  8024e6:	e9 37 ff ff ff       	jmp    802422 <__udivdi3+0x46>
  8024eb:	90                   	nop

008024ec <__umoddi3>:
  8024ec:	55                   	push   %ebp
  8024ed:	57                   	push   %edi
  8024ee:	56                   	push   %esi
  8024ef:	53                   	push   %ebx
  8024f0:	83 ec 1c             	sub    $0x1c,%esp
  8024f3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8024f7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8024fb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8024ff:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802503:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802507:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80250b:	89 f3                	mov    %esi,%ebx
  80250d:	89 fa                	mov    %edi,%edx
  80250f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802513:	89 34 24             	mov    %esi,(%esp)
  802516:	85 c0                	test   %eax,%eax
  802518:	75 1a                	jne    802534 <__umoddi3+0x48>
  80251a:	39 f7                	cmp    %esi,%edi
  80251c:	0f 86 a2 00 00 00    	jbe    8025c4 <__umoddi3+0xd8>
  802522:	89 c8                	mov    %ecx,%eax
  802524:	89 f2                	mov    %esi,%edx
  802526:	f7 f7                	div    %edi
  802528:	89 d0                	mov    %edx,%eax
  80252a:	31 d2                	xor    %edx,%edx
  80252c:	83 c4 1c             	add    $0x1c,%esp
  80252f:	5b                   	pop    %ebx
  802530:	5e                   	pop    %esi
  802531:	5f                   	pop    %edi
  802532:	5d                   	pop    %ebp
  802533:	c3                   	ret    
  802534:	39 f0                	cmp    %esi,%eax
  802536:	0f 87 ac 00 00 00    	ja     8025e8 <__umoddi3+0xfc>
  80253c:	0f bd e8             	bsr    %eax,%ebp
  80253f:	83 f5 1f             	xor    $0x1f,%ebp
  802542:	0f 84 ac 00 00 00    	je     8025f4 <__umoddi3+0x108>
  802548:	bf 20 00 00 00       	mov    $0x20,%edi
  80254d:	29 ef                	sub    %ebp,%edi
  80254f:	89 fe                	mov    %edi,%esi
  802551:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802555:	89 e9                	mov    %ebp,%ecx
  802557:	d3 e0                	shl    %cl,%eax
  802559:	89 d7                	mov    %edx,%edi
  80255b:	89 f1                	mov    %esi,%ecx
  80255d:	d3 ef                	shr    %cl,%edi
  80255f:	09 c7                	or     %eax,%edi
  802561:	89 e9                	mov    %ebp,%ecx
  802563:	d3 e2                	shl    %cl,%edx
  802565:	89 14 24             	mov    %edx,(%esp)
  802568:	89 d8                	mov    %ebx,%eax
  80256a:	d3 e0                	shl    %cl,%eax
  80256c:	89 c2                	mov    %eax,%edx
  80256e:	8b 44 24 08          	mov    0x8(%esp),%eax
  802572:	d3 e0                	shl    %cl,%eax
  802574:	89 44 24 04          	mov    %eax,0x4(%esp)
  802578:	8b 44 24 08          	mov    0x8(%esp),%eax
  80257c:	89 f1                	mov    %esi,%ecx
  80257e:	d3 e8                	shr    %cl,%eax
  802580:	09 d0                	or     %edx,%eax
  802582:	d3 eb                	shr    %cl,%ebx
  802584:	89 da                	mov    %ebx,%edx
  802586:	f7 f7                	div    %edi
  802588:	89 d3                	mov    %edx,%ebx
  80258a:	f7 24 24             	mull   (%esp)
  80258d:	89 c6                	mov    %eax,%esi
  80258f:	89 d1                	mov    %edx,%ecx
  802591:	39 d3                	cmp    %edx,%ebx
  802593:	0f 82 87 00 00 00    	jb     802620 <__umoddi3+0x134>
  802599:	0f 84 91 00 00 00    	je     802630 <__umoddi3+0x144>
  80259f:	8b 54 24 04          	mov    0x4(%esp),%edx
  8025a3:	29 f2                	sub    %esi,%edx
  8025a5:	19 cb                	sbb    %ecx,%ebx
  8025a7:	89 d8                	mov    %ebx,%eax
  8025a9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8025ad:	d3 e0                	shl    %cl,%eax
  8025af:	89 e9                	mov    %ebp,%ecx
  8025b1:	d3 ea                	shr    %cl,%edx
  8025b3:	09 d0                	or     %edx,%eax
  8025b5:	89 e9                	mov    %ebp,%ecx
  8025b7:	d3 eb                	shr    %cl,%ebx
  8025b9:	89 da                	mov    %ebx,%edx
  8025bb:	83 c4 1c             	add    $0x1c,%esp
  8025be:	5b                   	pop    %ebx
  8025bf:	5e                   	pop    %esi
  8025c0:	5f                   	pop    %edi
  8025c1:	5d                   	pop    %ebp
  8025c2:	c3                   	ret    
  8025c3:	90                   	nop
  8025c4:	89 fd                	mov    %edi,%ebp
  8025c6:	85 ff                	test   %edi,%edi
  8025c8:	75 0b                	jne    8025d5 <__umoddi3+0xe9>
  8025ca:	b8 01 00 00 00       	mov    $0x1,%eax
  8025cf:	31 d2                	xor    %edx,%edx
  8025d1:	f7 f7                	div    %edi
  8025d3:	89 c5                	mov    %eax,%ebp
  8025d5:	89 f0                	mov    %esi,%eax
  8025d7:	31 d2                	xor    %edx,%edx
  8025d9:	f7 f5                	div    %ebp
  8025db:	89 c8                	mov    %ecx,%eax
  8025dd:	f7 f5                	div    %ebp
  8025df:	89 d0                	mov    %edx,%eax
  8025e1:	e9 44 ff ff ff       	jmp    80252a <__umoddi3+0x3e>
  8025e6:	66 90                	xchg   %ax,%ax
  8025e8:	89 c8                	mov    %ecx,%eax
  8025ea:	89 f2                	mov    %esi,%edx
  8025ec:	83 c4 1c             	add    $0x1c,%esp
  8025ef:	5b                   	pop    %ebx
  8025f0:	5e                   	pop    %esi
  8025f1:	5f                   	pop    %edi
  8025f2:	5d                   	pop    %ebp
  8025f3:	c3                   	ret    
  8025f4:	3b 04 24             	cmp    (%esp),%eax
  8025f7:	72 06                	jb     8025ff <__umoddi3+0x113>
  8025f9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8025fd:	77 0f                	ja     80260e <__umoddi3+0x122>
  8025ff:	89 f2                	mov    %esi,%edx
  802601:	29 f9                	sub    %edi,%ecx
  802603:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802607:	89 14 24             	mov    %edx,(%esp)
  80260a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80260e:	8b 44 24 04          	mov    0x4(%esp),%eax
  802612:	8b 14 24             	mov    (%esp),%edx
  802615:	83 c4 1c             	add    $0x1c,%esp
  802618:	5b                   	pop    %ebx
  802619:	5e                   	pop    %esi
  80261a:	5f                   	pop    %edi
  80261b:	5d                   	pop    %ebp
  80261c:	c3                   	ret    
  80261d:	8d 76 00             	lea    0x0(%esi),%esi
  802620:	2b 04 24             	sub    (%esp),%eax
  802623:	19 fa                	sbb    %edi,%edx
  802625:	89 d1                	mov    %edx,%ecx
  802627:	89 c6                	mov    %eax,%esi
  802629:	e9 71 ff ff ff       	jmp    80259f <__umoddi3+0xb3>
  80262e:	66 90                	xchg   %ax,%ax
  802630:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802634:	72 ea                	jb     802620 <__umoddi3+0x134>
  802636:	89 d9                	mov    %ebx,%ecx
  802638:	e9 62 ff ff ff       	jmp    80259f <__umoddi3+0xb3>

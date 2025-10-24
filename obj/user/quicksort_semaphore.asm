
obj/user/quicksort_semaphore:     file format elf32-i386


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
  800031:	e8 3b 06 00 00       	call   800671 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
void QuickSort(int *Elements, int NumOfElements);
void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex);
uint32 CheckSorted(int *Elements, int NumOfElements);
struct semaphore IO_CS ;
void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	81 ec 34 01 00 00    	sub    $0x134,%esp
	int envID = sys_getenvid();
  800042:	e8 1b 20 00 00       	call   802062 <sys_getenvid>
  800047:	89 45 f0             	mov    %eax,-0x10(%ebp)
	char Chose ;
	char Line[255] ;
	int Iteration = 0 ;
  80004a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	IO_CS = create_semaphore("IO.CS", 1);
  800051:	8d 85 d4 fe ff ff    	lea    -0x12c(%ebp),%eax
  800057:	83 ec 04             	sub    $0x4,%esp
  80005a:	6a 01                	push   $0x1
  80005c:	68 60 27 80 00       	push   $0x802760
  800061:	50                   	push   %eax
  800062:	e8 1e 24 00 00       	call   802485 <create_semaphore>
  800067:	83 c4 0c             	add    $0xc,%esp
  80006a:	8b 85 d4 fe ff ff    	mov    -0x12c(%ebp),%eax
  800070:	a3 60 c0 81 00       	mov    %eax,0x81c060
	do
	{
		int InitFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames();
  800075:	e8 38 1e 00 00       	call   801eb2 <sys_calculate_free_frames>
  80007a:	89 c3                	mov    %eax,%ebx
  80007c:	e8 4a 1e 00 00       	call   801ecb <sys_calculate_modified_frames>
  800081:	01 d8                	add    %ebx,%eax
  800083:	89 45 ec             	mov    %eax,-0x14(%ebp)

		Iteration++ ;
  800086:	ff 45 f4             	incl   -0xc(%ebp)
		//		cprintf("Free Frames Before Allocation = %d\n", sys_calculate_free_frames()) ;

//	sys_lock_cons();
		int NumOfElements, *Elements;
		wait_semaphore(IO_CS);
  800089:	83 ec 0c             	sub    $0xc,%esp
  80008c:	ff 35 60 c0 81 00    	pushl  0x81c060
  800092:	e8 22 24 00 00       	call   8024b9 <wait_semaphore>
  800097:	83 c4 10             	add    $0x10,%esp
		{
			readline("Enter the number of elements: ", Line);
  80009a:	83 ec 08             	sub    $0x8,%esp
  80009d:	8d 85 dd fe ff ff    	lea    -0x123(%ebp),%eax
  8000a3:	50                   	push   %eax
  8000a4:	68 68 27 80 00       	push   $0x802768
  8000a9:	e8 1a 11 00 00       	call   8011c8 <readline>
  8000ae:	83 c4 10             	add    $0x10,%esp
			NumOfElements = strtol(Line, NULL, 10) ;
  8000b1:	83 ec 04             	sub    $0x4,%esp
  8000b4:	6a 0a                	push   $0xa
  8000b6:	6a 00                	push   $0x0
  8000b8:	8d 85 dd fe ff ff    	lea    -0x123(%ebp),%eax
  8000be:	50                   	push   %eax
  8000bf:	e8 1b 17 00 00       	call   8017df <strtol>
  8000c4:	83 c4 10             	add    $0x10,%esp
  8000c7:	89 45 e8             	mov    %eax,-0x18(%ebp)
			Elements = malloc(sizeof(int) * NumOfElements) ;
  8000ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000cd:	c1 e0 02             	shl    $0x2,%eax
  8000d0:	83 ec 0c             	sub    $0xc,%esp
  8000d3:	50                   	push   %eax
  8000d4:	e8 e0 1b 00 00       	call   801cb9 <malloc>
  8000d9:	83 c4 10             	add    $0x10,%esp
  8000dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			cprintf("Choose the initialization method:\n") ;
  8000df:	83 ec 0c             	sub    $0xc,%esp
  8000e2:	68 88 27 80 00       	push   $0x802788
  8000e7:	e8 03 0a 00 00       	call   800aef <cprintf>
  8000ec:	83 c4 10             	add    $0x10,%esp
			cprintf("a) Ascending\n") ;
  8000ef:	83 ec 0c             	sub    $0xc,%esp
  8000f2:	68 ab 27 80 00       	push   $0x8027ab
  8000f7:	e8 f3 09 00 00       	call   800aef <cprintf>
  8000fc:	83 c4 10             	add    $0x10,%esp
			cprintf("b) Descending\n") ;
  8000ff:	83 ec 0c             	sub    $0xc,%esp
  800102:	68 b9 27 80 00       	push   $0x8027b9
  800107:	e8 e3 09 00 00       	call   800aef <cprintf>
  80010c:	83 c4 10             	add    $0x10,%esp
			cprintf("c) Semi random\n");
  80010f:	83 ec 0c             	sub    $0xc,%esp
  800112:	68 c8 27 80 00       	push   $0x8027c8
  800117:	e8 d3 09 00 00       	call   800aef <cprintf>
  80011c:	83 c4 10             	add    $0x10,%esp
			do
			{
				cprintf("Select: ") ;
  80011f:	83 ec 0c             	sub    $0xc,%esp
  800122:	68 d8 27 80 00       	push   $0x8027d8
  800127:	e8 c3 09 00 00       	call   800aef <cprintf>
  80012c:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  80012f:	e8 20 05 00 00       	call   800654 <getchar>
  800134:	88 45 e3             	mov    %al,-0x1d(%ebp)
				cputchar(Chose);
  800137:	0f be 45 e3          	movsbl -0x1d(%ebp),%eax
  80013b:	83 ec 0c             	sub    $0xc,%esp
  80013e:	50                   	push   %eax
  80013f:	e8 f1 04 00 00       	call   800635 <cputchar>
  800144:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  800147:	83 ec 0c             	sub    $0xc,%esp
  80014a:	6a 0a                	push   $0xa
  80014c:	e8 e4 04 00 00       	call   800635 <cputchar>
  800151:	83 c4 10             	add    $0x10,%esp
			} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800154:	80 7d e3 61          	cmpb   $0x61,-0x1d(%ebp)
  800158:	74 0c                	je     800166 <_main+0x12e>
  80015a:	80 7d e3 62          	cmpb   $0x62,-0x1d(%ebp)
  80015e:	74 06                	je     800166 <_main+0x12e>
  800160:	80 7d e3 63          	cmpb   $0x63,-0x1d(%ebp)
  800164:	75 b9                	jne    80011f <_main+0xe7>

		}
		signal_semaphore(IO_CS);
  800166:	83 ec 0c             	sub    $0xc,%esp
  800169:	ff 35 60 c0 81 00    	pushl  0x81c060
  80016f:	e8 5f 23 00 00       	call   8024d3 <signal_semaphore>
  800174:	83 c4 10             	add    $0x10,%esp

		//sys_unlock_cons();
		int  i ;
		switch (Chose)
  800177:	0f be 45 e3          	movsbl -0x1d(%ebp),%eax
  80017b:	83 f8 62             	cmp    $0x62,%eax
  80017e:	74 1d                	je     80019d <_main+0x165>
  800180:	83 f8 63             	cmp    $0x63,%eax
  800183:	74 2b                	je     8001b0 <_main+0x178>
  800185:	83 f8 61             	cmp    $0x61,%eax
  800188:	75 39                	jne    8001c3 <_main+0x18b>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  80018a:	83 ec 08             	sub    $0x8,%esp
  80018d:	ff 75 e8             	pushl  -0x18(%ebp)
  800190:	ff 75 e4             	pushl  -0x1c(%ebp)
  800193:	e8 2e 03 00 00       	call   8004c6 <InitializeAscending>
  800198:	83 c4 10             	add    $0x10,%esp
			break ;
  80019b:	eb 37                	jmp    8001d4 <_main+0x19c>
		case 'b':
			InitializeIdentical(Elements, NumOfElements);
  80019d:	83 ec 08             	sub    $0x8,%esp
  8001a0:	ff 75 e8             	pushl  -0x18(%ebp)
  8001a3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001a6:	e8 4c 03 00 00       	call   8004f7 <InitializeIdentical>
  8001ab:	83 c4 10             	add    $0x10,%esp
			break ;
  8001ae:	eb 24                	jmp    8001d4 <_main+0x19c>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001b0:	83 ec 08             	sub    $0x8,%esp
  8001b3:	ff 75 e8             	pushl  -0x18(%ebp)
  8001b6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001b9:	e8 6e 03 00 00       	call   80052c <InitializeSemiRandom>
  8001be:	83 c4 10             	add    $0x10,%esp
			break ;
  8001c1:	eb 11                	jmp    8001d4 <_main+0x19c>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001c3:	83 ec 08             	sub    $0x8,%esp
  8001c6:	ff 75 e8             	pushl  -0x18(%ebp)
  8001c9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001cc:	e8 5b 03 00 00       	call   80052c <InitializeSemiRandom>
  8001d1:	83 c4 10             	add    $0x10,%esp
		}

		QuickSort(Elements, NumOfElements);
  8001d4:	83 ec 08             	sub    $0x8,%esp
  8001d7:	ff 75 e8             	pushl  -0x18(%ebp)
  8001da:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001dd:	e8 29 01 00 00       	call   80030b <QuickSort>
  8001e2:	83 c4 10             	add    $0x10,%esp

		//		PrintElements(Elements, NumOfElements);

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001e5:	83 ec 08             	sub    $0x8,%esp
  8001e8:	ff 75 e8             	pushl  -0x18(%ebp)
  8001eb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001ee:	e8 29 02 00 00       	call   80041c <CheckSorted>
  8001f3:	83 c4 10             	add    $0x10,%esp
  8001f6:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  8001f9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8001fd:	75 14                	jne    800213 <_main+0x1db>
  8001ff:	83 ec 04             	sub    $0x4,%esp
  800202:	68 e4 27 80 00       	push   $0x8027e4
  800207:	6a 4d                	push   $0x4d
  800209:	68 06 28 80 00       	push   $0x802806
  80020e:	e8 0e 06 00 00       	call   800821 <_panic>
		else
		{
			wait_semaphore(IO_CS);
  800213:	83 ec 0c             	sub    $0xc,%esp
  800216:	ff 35 60 c0 81 00    	pushl  0x81c060
  80021c:	e8 98 22 00 00       	call   8024b9 <wait_semaphore>
  800221:	83 c4 10             	add    $0x10,%esp
				cprintf("\n===============================================\n") ;
  800224:	83 ec 0c             	sub    $0xc,%esp
  800227:	68 24 28 80 00       	push   $0x802824
  80022c:	e8 be 08 00 00       	call   800aef <cprintf>
  800231:	83 c4 10             	add    $0x10,%esp
				cprintf("Congratulations!! The array is sorted correctly\n") ;
  800234:	83 ec 0c             	sub    $0xc,%esp
  800237:	68 58 28 80 00       	push   $0x802858
  80023c:	e8 ae 08 00 00       	call   800aef <cprintf>
  800241:	83 c4 10             	add    $0x10,%esp
				cprintf("===============================================\n\n") ;
  800244:	83 ec 0c             	sub    $0xc,%esp
  800247:	68 8c 28 80 00       	push   $0x80288c
  80024c:	e8 9e 08 00 00       	call   800aef <cprintf>
  800251:	83 c4 10             	add    $0x10,%esp
			signal_semaphore(IO_CS);
  800254:	83 ec 0c             	sub    $0xc,%esp
  800257:	ff 35 60 c0 81 00    	pushl  0x81c060
  80025d:	e8 71 22 00 00       	call   8024d3 <signal_semaphore>
  800262:	83 c4 10             	add    $0x10,%esp
		}

		//		cprintf("Free Frames After Calculation = %d\n", sys_calculate_free_frames()) ;

		wait_semaphore(IO_CS);
  800265:	83 ec 0c             	sub    $0xc,%esp
  800268:	ff 35 60 c0 81 00    	pushl  0x81c060
  80026e:	e8 46 22 00 00       	call   8024b9 <wait_semaphore>
  800273:	83 c4 10             	add    $0x10,%esp
			cprintf("Freeing the Heap...\n\n") ;
  800276:	83 ec 0c             	sub    $0xc,%esp
  800279:	68 be 28 80 00       	push   $0x8028be
  80027e:	e8 6c 08 00 00       	call   800aef <cprintf>
  800283:	83 c4 10             	add    $0x10,%esp
		signal_semaphore(IO_CS);
  800286:	83 ec 0c             	sub    $0xc,%esp
  800289:	ff 35 60 c0 81 00    	pushl  0x81c060
  80028f:	e8 3f 22 00 00       	call   8024d3 <signal_semaphore>
  800294:	83 c4 10             	add    $0x10,%esp

		//freeHeap() ;

		///========================================================================
	//sys_lock_cons();
		wait_semaphore(IO_CS);
  800297:	83 ec 0c             	sub    $0xc,%esp
  80029a:	ff 35 60 c0 81 00    	pushl  0x81c060
  8002a0:	e8 14 22 00 00       	call   8024b9 <wait_semaphore>
  8002a5:	83 c4 10             	add    $0x10,%esp
			cprintf("Do you want to repeat (y/n): ") ;
  8002a8:	83 ec 0c             	sub    $0xc,%esp
  8002ab:	68 d4 28 80 00       	push   $0x8028d4
  8002b0:	e8 3a 08 00 00       	call   800aef <cprintf>
  8002b5:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  8002b8:	e8 97 03 00 00       	call   800654 <getchar>
  8002bd:	88 45 e3             	mov    %al,-0x1d(%ebp)
			cputchar(Chose);
  8002c0:	0f be 45 e3          	movsbl -0x1d(%ebp),%eax
  8002c4:	83 ec 0c             	sub    $0xc,%esp
  8002c7:	50                   	push   %eax
  8002c8:	e8 68 03 00 00       	call   800635 <cputchar>
  8002cd:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  8002d0:	83 ec 0c             	sub    $0xc,%esp
  8002d3:	6a 0a                	push   $0xa
  8002d5:	e8 5b 03 00 00       	call   800635 <cputchar>
  8002da:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  8002dd:	83 ec 0c             	sub    $0xc,%esp
  8002e0:	6a 0a                	push   $0xa
  8002e2:	e8 4e 03 00 00       	call   800635 <cputchar>
  8002e7:	83 c4 10             	add    $0x10,%esp
	//sys_unlock_cons();
		signal_semaphore(IO_CS);
  8002ea:	83 ec 0c             	sub    $0xc,%esp
  8002ed:	ff 35 60 c0 81 00    	pushl  0x81c060
  8002f3:	e8 db 21 00 00       	call   8024d3 <signal_semaphore>
  8002f8:	83 c4 10             	add    $0x10,%esp

	} while (Chose == 'y');
  8002fb:	80 7d e3 79          	cmpb   $0x79,-0x1d(%ebp)
  8002ff:	0f 84 70 fd ff ff    	je     800075 <_main+0x3d>

}
  800305:	90                   	nop
  800306:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800309:	c9                   	leave  
  80030a:	c3                   	ret    

0080030b <QuickSort>:

///Quick sort
void QuickSort(int *Elements, int NumOfElements)
{
  80030b:	55                   	push   %ebp
  80030c:	89 e5                	mov    %esp,%ebp
  80030e:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  800311:	8b 45 0c             	mov    0xc(%ebp),%eax
  800314:	48                   	dec    %eax
  800315:	50                   	push   %eax
  800316:	6a 00                	push   $0x0
  800318:	ff 75 0c             	pushl  0xc(%ebp)
  80031b:	ff 75 08             	pushl  0x8(%ebp)
  80031e:	e8 06 00 00 00       	call   800329 <QSort>
  800323:	83 c4 10             	add    $0x10,%esp
}
  800326:	90                   	nop
  800327:	c9                   	leave  
  800328:	c3                   	ret    

00800329 <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  800329:	55                   	push   %ebp
  80032a:	89 e5                	mov    %esp,%ebp
  80032c:	83 ec 18             	sub    $0x18,%esp
	if (startIndex >= finalIndex) return;
  80032f:	8b 45 10             	mov    0x10(%ebp),%eax
  800332:	3b 45 14             	cmp    0x14(%ebp),%eax
  800335:	0f 8d de 00 00 00    	jge    800419 <QSort+0xf0>

	int i = startIndex+1, j = finalIndex;
  80033b:	8b 45 10             	mov    0x10(%ebp),%eax
  80033e:	40                   	inc    %eax
  80033f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800342:	8b 45 14             	mov    0x14(%ebp),%eax
  800345:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  800348:	e9 80 00 00 00       	jmp    8003cd <QSort+0xa4>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  80034d:	ff 45 f4             	incl   -0xc(%ebp)
  800350:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800353:	3b 45 14             	cmp    0x14(%ebp),%eax
  800356:	7f 2b                	jg     800383 <QSort+0x5a>
  800358:	8b 45 10             	mov    0x10(%ebp),%eax
  80035b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800362:	8b 45 08             	mov    0x8(%ebp),%eax
  800365:	01 d0                	add    %edx,%eax
  800367:	8b 10                	mov    (%eax),%edx
  800369:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80036c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800373:	8b 45 08             	mov    0x8(%ebp),%eax
  800376:	01 c8                	add    %ecx,%eax
  800378:	8b 00                	mov    (%eax),%eax
  80037a:	39 c2                	cmp    %eax,%edx
  80037c:	7d cf                	jge    80034d <QSort+0x24>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  80037e:	eb 03                	jmp    800383 <QSort+0x5a>
  800380:	ff 4d f0             	decl   -0x10(%ebp)
  800383:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800386:	3b 45 10             	cmp    0x10(%ebp),%eax
  800389:	7e 26                	jle    8003b1 <QSort+0x88>
  80038b:	8b 45 10             	mov    0x10(%ebp),%eax
  80038e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800395:	8b 45 08             	mov    0x8(%ebp),%eax
  800398:	01 d0                	add    %edx,%eax
  80039a:	8b 10                	mov    (%eax),%edx
  80039c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80039f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a9:	01 c8                	add    %ecx,%eax
  8003ab:	8b 00                	mov    (%eax),%eax
  8003ad:	39 c2                	cmp    %eax,%edx
  8003af:	7e cf                	jle    800380 <QSort+0x57>

		if (i <= j)
  8003b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003b4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8003b7:	7f 14                	jg     8003cd <QSort+0xa4>
		{
			Swap(Elements, i, j);
  8003b9:	83 ec 04             	sub    $0x4,%esp
  8003bc:	ff 75 f0             	pushl  -0x10(%ebp)
  8003bf:	ff 75 f4             	pushl  -0xc(%ebp)
  8003c2:	ff 75 08             	pushl  0x8(%ebp)
  8003c5:	e8 a9 00 00 00       	call   800473 <Swap>
  8003ca:	83 c4 10             	add    $0x10,%esp
{
	if (startIndex >= finalIndex) return;

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  8003cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003d0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8003d3:	0f 8e 77 ff ff ff    	jle    800350 <QSort+0x27>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  8003d9:	83 ec 04             	sub    $0x4,%esp
  8003dc:	ff 75 f0             	pushl  -0x10(%ebp)
  8003df:	ff 75 10             	pushl  0x10(%ebp)
  8003e2:	ff 75 08             	pushl  0x8(%ebp)
  8003e5:	e8 89 00 00 00       	call   800473 <Swap>
  8003ea:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  8003ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003f0:	48                   	dec    %eax
  8003f1:	50                   	push   %eax
  8003f2:	ff 75 10             	pushl  0x10(%ebp)
  8003f5:	ff 75 0c             	pushl  0xc(%ebp)
  8003f8:	ff 75 08             	pushl  0x8(%ebp)
  8003fb:	e8 29 ff ff ff       	call   800329 <QSort>
  800400:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  800403:	ff 75 14             	pushl  0x14(%ebp)
  800406:	ff 75 f4             	pushl  -0xc(%ebp)
  800409:	ff 75 0c             	pushl  0xc(%ebp)
  80040c:	ff 75 08             	pushl  0x8(%ebp)
  80040f:	e8 15 ff ff ff       	call   800329 <QSort>
  800414:	83 c4 10             	add    $0x10,%esp
  800417:	eb 01                	jmp    80041a <QSort+0xf1>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  800419:	90                   	nop

	Swap( Elements, startIndex, j);

	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);
}
  80041a:	c9                   	leave  
  80041b:	c3                   	ret    

0080041c <CheckSorted>:

uint32 CheckSorted(int *Elements, int NumOfElements)
{
  80041c:	55                   	push   %ebp
  80041d:	89 e5                	mov    %esp,%ebp
  80041f:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  800422:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800429:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800430:	eb 33                	jmp    800465 <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  800432:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800435:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80043c:	8b 45 08             	mov    0x8(%ebp),%eax
  80043f:	01 d0                	add    %edx,%eax
  800441:	8b 10                	mov    (%eax),%edx
  800443:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800446:	40                   	inc    %eax
  800447:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80044e:	8b 45 08             	mov    0x8(%ebp),%eax
  800451:	01 c8                	add    %ecx,%eax
  800453:	8b 00                	mov    (%eax),%eax
  800455:	39 c2                	cmp    %eax,%edx
  800457:	7e 09                	jle    800462 <CheckSorted+0x46>
		{
			Sorted = 0 ;
  800459:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800460:	eb 0c                	jmp    80046e <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800462:	ff 45 f8             	incl   -0x8(%ebp)
  800465:	8b 45 0c             	mov    0xc(%ebp),%eax
  800468:	48                   	dec    %eax
  800469:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80046c:	7f c4                	jg     800432 <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  80046e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800471:	c9                   	leave  
  800472:	c3                   	ret    

00800473 <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  800473:	55                   	push   %ebp
  800474:	89 e5                	mov    %esp,%ebp
  800476:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800479:	8b 45 0c             	mov    0xc(%ebp),%eax
  80047c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800483:	8b 45 08             	mov    0x8(%ebp),%eax
  800486:	01 d0                	add    %edx,%eax
  800488:	8b 00                	mov    (%eax),%eax
  80048a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  80048d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800490:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800497:	8b 45 08             	mov    0x8(%ebp),%eax
  80049a:	01 c2                	add    %eax,%edx
  80049c:	8b 45 10             	mov    0x10(%ebp),%eax
  80049f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8004a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a9:	01 c8                	add    %ecx,%eax
  8004ab:	8b 00                	mov    (%eax),%eax
  8004ad:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  8004af:	8b 45 10             	mov    0x10(%ebp),%eax
  8004b2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8004bc:	01 c2                	add    %eax,%edx
  8004be:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004c1:	89 02                	mov    %eax,(%edx)
}
  8004c3:	90                   	nop
  8004c4:	c9                   	leave  
  8004c5:	c3                   	ret    

008004c6 <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  8004c6:	55                   	push   %ebp
  8004c7:	89 e5                	mov    %esp,%ebp
  8004c9:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004cc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8004d3:	eb 17                	jmp    8004ec <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  8004d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004d8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004df:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e2:	01 c2                	add    %eax,%edx
  8004e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004e7:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004e9:	ff 45 fc             	incl   -0x4(%ebp)
  8004ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004ef:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004f2:	7c e1                	jl     8004d5 <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8004f4:	90                   	nop
  8004f5:	c9                   	leave  
  8004f6:	c3                   	ret    

008004f7 <InitializeIdentical>:

void InitializeIdentical(int *Elements, int NumOfElements)
{
  8004f7:	55                   	push   %ebp
  8004f8:	89 e5                	mov    %esp,%ebp
  8004fa:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004fd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800504:	eb 1b                	jmp    800521 <InitializeIdentical+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  800506:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800509:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800510:	8b 45 08             	mov    0x8(%ebp),%eax
  800513:	01 c2                	add    %eax,%edx
  800515:	8b 45 0c             	mov    0xc(%ebp),%eax
  800518:	2b 45 fc             	sub    -0x4(%ebp),%eax
  80051b:	48                   	dec    %eax
  80051c:	89 02                	mov    %eax,(%edx)
}

void InitializeIdentical(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80051e:	ff 45 fc             	incl   -0x4(%ebp)
  800521:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800524:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800527:	7c dd                	jl     800506 <InitializeIdentical+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  800529:	90                   	nop
  80052a:	c9                   	leave  
  80052b:	c3                   	ret    

0080052c <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  80052c:	55                   	push   %ebp
  80052d:	89 e5                	mov    %esp,%ebp
  80052f:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  800532:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800535:	b8 56 55 55 55       	mov    $0x55555556,%eax
  80053a:	f7 e9                	imul   %ecx
  80053c:	c1 f9 1f             	sar    $0x1f,%ecx
  80053f:	89 d0                	mov    %edx,%eax
  800541:	29 c8                	sub    %ecx,%eax
  800543:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (Repetition == 0)
  800546:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80054a:	75 07                	jne    800553 <InitializeSemiRandom+0x27>
			Repetition = 3;
  80054c:	c7 45 f8 03 00 00 00 	movl   $0x3,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  800553:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80055a:	eb 1e                	jmp    80057a <InitializeSemiRandom+0x4e>
	{
		Elements[i] = i % Repetition ;
  80055c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80055f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800566:	8b 45 08             	mov    0x8(%ebp),%eax
  800569:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80056c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80056f:	99                   	cltd   
  800570:	f7 7d f8             	idivl  -0x8(%ebp)
  800573:	89 d0                	mov    %edx,%eax
  800575:	89 01                	mov    %eax,(%ecx)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	if (Repetition == 0)
			Repetition = 3;
	for (i = 0 ; i < NumOfElements ; i++)
  800577:	ff 45 fc             	incl   -0x4(%ebp)
  80057a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80057d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800580:	7c da                	jl     80055c <InitializeSemiRandom+0x30>
	{
		Elements[i] = i % Repetition ;
	}

}
  800582:	90                   	nop
  800583:	c9                   	leave  
  800584:	c3                   	ret    

00800585 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  800585:	55                   	push   %ebp
  800586:	89 e5                	mov    %esp,%ebp
  800588:	83 ec 18             	sub    $0x18,%esp
	int envID = sys_getenvid();
  80058b:	e8 d2 1a 00 00       	call   802062 <sys_getenvid>
  800590:	89 45 f0             	mov    %eax,-0x10(%ebp)
	wait_semaphore(IO_CS);
  800593:	83 ec 0c             	sub    $0xc,%esp
  800596:	ff 35 60 c0 81 00    	pushl  0x81c060
  80059c:	e8 18 1f 00 00       	call   8024b9 <wait_semaphore>
  8005a1:	83 c4 10             	add    $0x10,%esp
		int i ;
		int NumsPerLine = 20 ;
  8005a4:	c7 45 ec 14 00 00 00 	movl   $0x14,-0x14(%ebp)
		for (i = 0 ; i < NumOfElements-1 ; i++)
  8005ab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8005b2:	eb 42                	jmp    8005f6 <PrintElements+0x71>
		{
			if (i%NumsPerLine == 0)
  8005b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005b7:	99                   	cltd   
  8005b8:	f7 7d ec             	idivl  -0x14(%ebp)
  8005bb:	89 d0                	mov    %edx,%eax
  8005bd:	85 c0                	test   %eax,%eax
  8005bf:	75 10                	jne    8005d1 <PrintElements+0x4c>
				cprintf("\n");
  8005c1:	83 ec 0c             	sub    $0xc,%esp
  8005c4:	68 f2 28 80 00       	push   $0x8028f2
  8005c9:	e8 21 05 00 00       	call   800aef <cprintf>
  8005ce:	83 c4 10             	add    $0x10,%esp
			cprintf("%d, ",Elements[i]);
  8005d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005d4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005db:	8b 45 08             	mov    0x8(%ebp),%eax
  8005de:	01 d0                	add    %edx,%eax
  8005e0:	8b 00                	mov    (%eax),%eax
  8005e2:	83 ec 08             	sub    $0x8,%esp
  8005e5:	50                   	push   %eax
  8005e6:	68 f4 28 80 00       	push   $0x8028f4
  8005eb:	e8 ff 04 00 00       	call   800aef <cprintf>
  8005f0:	83 c4 10             	add    $0x10,%esp
{
	int envID = sys_getenvid();
	wait_semaphore(IO_CS);
		int i ;
		int NumsPerLine = 20 ;
		for (i = 0 ; i < NumOfElements-1 ; i++)
  8005f3:	ff 45 f4             	incl   -0xc(%ebp)
  8005f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005f9:	48                   	dec    %eax
  8005fa:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8005fd:	7f b5                	jg     8005b4 <PrintElements+0x2f>
		{
			if (i%NumsPerLine == 0)
				cprintf("\n");
			cprintf("%d, ",Elements[i]);
		}
		cprintf("%d\n",Elements[i]);
  8005ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800602:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800609:	8b 45 08             	mov    0x8(%ebp),%eax
  80060c:	01 d0                	add    %edx,%eax
  80060e:	8b 00                	mov    (%eax),%eax
  800610:	83 ec 08             	sub    $0x8,%esp
  800613:	50                   	push   %eax
  800614:	68 f9 28 80 00       	push   $0x8028f9
  800619:	e8 d1 04 00 00       	call   800aef <cprintf>
  80061e:	83 c4 10             	add    $0x10,%esp
	signal_semaphore(IO_CS);
  800621:	83 ec 0c             	sub    $0xc,%esp
  800624:	ff 35 60 c0 81 00    	pushl  0x81c060
  80062a:	e8 a4 1e 00 00       	call   8024d3 <signal_semaphore>
  80062f:	83 c4 10             	add    $0x10,%esp
}
  800632:	90                   	nop
  800633:	c9                   	leave  
  800634:	c3                   	ret    

00800635 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  800635:	55                   	push   %ebp
  800636:	89 e5                	mov    %esp,%ebp
  800638:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  80063b:	8b 45 08             	mov    0x8(%ebp),%eax
  80063e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800641:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800645:	83 ec 0c             	sub    $0xc,%esp
  800648:	50                   	push   %eax
  800649:	e8 fc 18 00 00       	call   801f4a <sys_cputc>
  80064e:	83 c4 10             	add    $0x10,%esp
}
  800651:	90                   	nop
  800652:	c9                   	leave  
  800653:	c3                   	ret    

00800654 <getchar>:


int
getchar(void)
{
  800654:	55                   	push   %ebp
  800655:	89 e5                	mov    %esp,%ebp
  800657:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  80065a:	e8 8a 17 00 00       	call   801de9 <sys_cgetc>
  80065f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  800662:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800665:	c9                   	leave  
  800666:	c3                   	ret    

00800667 <iscons>:

int iscons(int fdnum)
{
  800667:	55                   	push   %ebp
  800668:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  80066a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80066f:	5d                   	pop    %ebp
  800670:	c3                   	ret    

00800671 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800671:	55                   	push   %ebp
  800672:	89 e5                	mov    %esp,%ebp
  800674:	57                   	push   %edi
  800675:	56                   	push   %esi
  800676:	53                   	push   %ebx
  800677:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80067a:	e8 fc 19 00 00       	call   80207b <sys_getenvindex>
  80067f:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800682:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800685:	89 d0                	mov    %edx,%eax
  800687:	c1 e0 02             	shl    $0x2,%eax
  80068a:	01 d0                	add    %edx,%eax
  80068c:	c1 e0 03             	shl    $0x3,%eax
  80068f:	01 d0                	add    %edx,%eax
  800691:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800698:	01 d0                	add    %edx,%eax
  80069a:	c1 e0 02             	shl    $0x2,%eax
  80069d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8006a2:	a3 24 40 80 00       	mov    %eax,0x804024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8006a7:	a1 24 40 80 00       	mov    0x804024,%eax
  8006ac:	8a 40 20             	mov    0x20(%eax),%al
  8006af:	84 c0                	test   %al,%al
  8006b1:	74 0d                	je     8006c0 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8006b3:	a1 24 40 80 00       	mov    0x804024,%eax
  8006b8:	83 c0 20             	add    $0x20,%eax
  8006bb:	a3 04 40 80 00       	mov    %eax,0x804004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8006c0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8006c4:	7e 0a                	jle    8006d0 <libmain+0x5f>
		binaryname = argv[0];
  8006c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006c9:	8b 00                	mov    (%eax),%eax
  8006cb:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	_main(argc, argv);
  8006d0:	83 ec 08             	sub    $0x8,%esp
  8006d3:	ff 75 0c             	pushl  0xc(%ebp)
  8006d6:	ff 75 08             	pushl  0x8(%ebp)
  8006d9:	e8 5a f9 ff ff       	call   800038 <_main>
  8006de:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8006e1:	a1 00 40 80 00       	mov    0x804000,%eax
  8006e6:	85 c0                	test   %eax,%eax
  8006e8:	0f 84 01 01 00 00    	je     8007ef <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8006ee:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8006f4:	bb f8 29 80 00       	mov    $0x8029f8,%ebx
  8006f9:	ba 0e 00 00 00       	mov    $0xe,%edx
  8006fe:	89 c7                	mov    %eax,%edi
  800700:	89 de                	mov    %ebx,%esi
  800702:	89 d1                	mov    %edx,%ecx
  800704:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800706:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800709:	b9 56 00 00 00       	mov    $0x56,%ecx
  80070e:	b0 00                	mov    $0x0,%al
  800710:	89 d7                	mov    %edx,%edi
  800712:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800714:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80071b:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80071e:	83 ec 08             	sub    $0x8,%esp
  800721:	50                   	push   %eax
  800722:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800728:	50                   	push   %eax
  800729:	e8 83 1b 00 00       	call   8022b1 <sys_utilities>
  80072e:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800731:	e8 cc 16 00 00       	call   801e02 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800736:	83 ec 0c             	sub    $0xc,%esp
  800739:	68 18 29 80 00       	push   $0x802918
  80073e:	e8 ac 03 00 00       	call   800aef <cprintf>
  800743:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800746:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800749:	85 c0                	test   %eax,%eax
  80074b:	74 18                	je     800765 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80074d:	e8 7d 1b 00 00       	call   8022cf <sys_get_optimal_num_faults>
  800752:	83 ec 08             	sub    $0x8,%esp
  800755:	50                   	push   %eax
  800756:	68 40 29 80 00       	push   $0x802940
  80075b:	e8 8f 03 00 00       	call   800aef <cprintf>
  800760:	83 c4 10             	add    $0x10,%esp
  800763:	eb 59                	jmp    8007be <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800765:	a1 24 40 80 00       	mov    0x804024,%eax
  80076a:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  800770:	a1 24 40 80 00       	mov    0x804024,%eax
  800775:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  80077b:	83 ec 04             	sub    $0x4,%esp
  80077e:	52                   	push   %edx
  80077f:	50                   	push   %eax
  800780:	68 64 29 80 00       	push   $0x802964
  800785:	e8 65 03 00 00       	call   800aef <cprintf>
  80078a:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80078d:	a1 24 40 80 00       	mov    0x804024,%eax
  800792:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800798:	a1 24 40 80 00       	mov    0x804024,%eax
  80079d:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  8007a3:	a1 24 40 80 00       	mov    0x804024,%eax
  8007a8:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  8007ae:	51                   	push   %ecx
  8007af:	52                   	push   %edx
  8007b0:	50                   	push   %eax
  8007b1:	68 8c 29 80 00       	push   $0x80298c
  8007b6:	e8 34 03 00 00       	call   800aef <cprintf>
  8007bb:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8007be:	a1 24 40 80 00       	mov    0x804024,%eax
  8007c3:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  8007c9:	83 ec 08             	sub    $0x8,%esp
  8007cc:	50                   	push   %eax
  8007cd:	68 e4 29 80 00       	push   $0x8029e4
  8007d2:	e8 18 03 00 00       	call   800aef <cprintf>
  8007d7:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8007da:	83 ec 0c             	sub    $0xc,%esp
  8007dd:	68 18 29 80 00       	push   $0x802918
  8007e2:	e8 08 03 00 00       	call   800aef <cprintf>
  8007e7:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8007ea:	e8 2d 16 00 00       	call   801e1c <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8007ef:	e8 1f 00 00 00       	call   800813 <exit>
}
  8007f4:	90                   	nop
  8007f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007f8:	5b                   	pop    %ebx
  8007f9:	5e                   	pop    %esi
  8007fa:	5f                   	pop    %edi
  8007fb:	5d                   	pop    %ebp
  8007fc:	c3                   	ret    

008007fd <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8007fd:	55                   	push   %ebp
  8007fe:	89 e5                	mov    %esp,%ebp
  800800:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800803:	83 ec 0c             	sub    $0xc,%esp
  800806:	6a 00                	push   $0x0
  800808:	e8 3a 18 00 00       	call   802047 <sys_destroy_env>
  80080d:	83 c4 10             	add    $0x10,%esp
}
  800810:	90                   	nop
  800811:	c9                   	leave  
  800812:	c3                   	ret    

00800813 <exit>:

void
exit(void)
{
  800813:	55                   	push   %ebp
  800814:	89 e5                	mov    %esp,%ebp
  800816:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800819:	e8 8f 18 00 00       	call   8020ad <sys_exit_env>
}
  80081e:	90                   	nop
  80081f:	c9                   	leave  
  800820:	c3                   	ret    

00800821 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800821:	55                   	push   %ebp
  800822:	89 e5                	mov    %esp,%ebp
  800824:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800827:	8d 45 10             	lea    0x10(%ebp),%eax
  80082a:	83 c0 04             	add    $0x4,%eax
  80082d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800830:	a1 18 c1 81 00       	mov    0x81c118,%eax
  800835:	85 c0                	test   %eax,%eax
  800837:	74 16                	je     80084f <_panic+0x2e>
		cprintf("%s: ", argv0);
  800839:	a1 18 c1 81 00       	mov    0x81c118,%eax
  80083e:	83 ec 08             	sub    $0x8,%esp
  800841:	50                   	push   %eax
  800842:	68 5c 2a 80 00       	push   $0x802a5c
  800847:	e8 a3 02 00 00       	call   800aef <cprintf>
  80084c:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  80084f:	a1 04 40 80 00       	mov    0x804004,%eax
  800854:	83 ec 0c             	sub    $0xc,%esp
  800857:	ff 75 0c             	pushl  0xc(%ebp)
  80085a:	ff 75 08             	pushl  0x8(%ebp)
  80085d:	50                   	push   %eax
  80085e:	68 64 2a 80 00       	push   $0x802a64
  800863:	6a 74                	push   $0x74
  800865:	e8 b2 02 00 00       	call   800b1c <cprintf_colored>
  80086a:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  80086d:	8b 45 10             	mov    0x10(%ebp),%eax
  800870:	83 ec 08             	sub    $0x8,%esp
  800873:	ff 75 f4             	pushl  -0xc(%ebp)
  800876:	50                   	push   %eax
  800877:	e8 04 02 00 00       	call   800a80 <vcprintf>
  80087c:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80087f:	83 ec 08             	sub    $0x8,%esp
  800882:	6a 00                	push   $0x0
  800884:	68 8c 2a 80 00       	push   $0x802a8c
  800889:	e8 f2 01 00 00       	call   800a80 <vcprintf>
  80088e:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800891:	e8 7d ff ff ff       	call   800813 <exit>

	// should not return here
	while (1) ;
  800896:	eb fe                	jmp    800896 <_panic+0x75>

00800898 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800898:	55                   	push   %ebp
  800899:	89 e5                	mov    %esp,%ebp
  80089b:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80089e:	a1 24 40 80 00       	mov    0x804024,%eax
  8008a3:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8008a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ac:	39 c2                	cmp    %eax,%edx
  8008ae:	74 14                	je     8008c4 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8008b0:	83 ec 04             	sub    $0x4,%esp
  8008b3:	68 90 2a 80 00       	push   $0x802a90
  8008b8:	6a 26                	push   $0x26
  8008ba:	68 dc 2a 80 00       	push   $0x802adc
  8008bf:	e8 5d ff ff ff       	call   800821 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8008c4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8008cb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8008d2:	e9 c5 00 00 00       	jmp    80099c <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8008d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008da:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8008e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e4:	01 d0                	add    %edx,%eax
  8008e6:	8b 00                	mov    (%eax),%eax
  8008e8:	85 c0                	test   %eax,%eax
  8008ea:	75 08                	jne    8008f4 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8008ec:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8008ef:	e9 a5 00 00 00       	jmp    800999 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8008f4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008fb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800902:	eb 69                	jmp    80096d <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800904:	a1 24 40 80 00       	mov    0x804024,%eax
  800909:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80090f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800912:	89 d0                	mov    %edx,%eax
  800914:	01 c0                	add    %eax,%eax
  800916:	01 d0                	add    %edx,%eax
  800918:	c1 e0 03             	shl    $0x3,%eax
  80091b:	01 c8                	add    %ecx,%eax
  80091d:	8a 40 04             	mov    0x4(%eax),%al
  800920:	84 c0                	test   %al,%al
  800922:	75 46                	jne    80096a <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800924:	a1 24 40 80 00       	mov    0x804024,%eax
  800929:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80092f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800932:	89 d0                	mov    %edx,%eax
  800934:	01 c0                	add    %eax,%eax
  800936:	01 d0                	add    %edx,%eax
  800938:	c1 e0 03             	shl    $0x3,%eax
  80093b:	01 c8                	add    %ecx,%eax
  80093d:	8b 00                	mov    (%eax),%eax
  80093f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800942:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800945:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80094a:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80094c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80094f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800956:	8b 45 08             	mov    0x8(%ebp),%eax
  800959:	01 c8                	add    %ecx,%eax
  80095b:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80095d:	39 c2                	cmp    %eax,%edx
  80095f:	75 09                	jne    80096a <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800961:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800968:	eb 15                	jmp    80097f <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80096a:	ff 45 e8             	incl   -0x18(%ebp)
  80096d:	a1 24 40 80 00       	mov    0x804024,%eax
  800972:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800978:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80097b:	39 c2                	cmp    %eax,%edx
  80097d:	77 85                	ja     800904 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80097f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800983:	75 14                	jne    800999 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800985:	83 ec 04             	sub    $0x4,%esp
  800988:	68 e8 2a 80 00       	push   $0x802ae8
  80098d:	6a 3a                	push   $0x3a
  80098f:	68 dc 2a 80 00       	push   $0x802adc
  800994:	e8 88 fe ff ff       	call   800821 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800999:	ff 45 f0             	incl   -0x10(%ebp)
  80099c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80099f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8009a2:	0f 8c 2f ff ff ff    	jl     8008d7 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8009a8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009af:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8009b6:	eb 26                	jmp    8009de <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8009b8:	a1 24 40 80 00       	mov    0x804024,%eax
  8009bd:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8009c3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009c6:	89 d0                	mov    %edx,%eax
  8009c8:	01 c0                	add    %eax,%eax
  8009ca:	01 d0                	add    %edx,%eax
  8009cc:	c1 e0 03             	shl    $0x3,%eax
  8009cf:	01 c8                	add    %ecx,%eax
  8009d1:	8a 40 04             	mov    0x4(%eax),%al
  8009d4:	3c 01                	cmp    $0x1,%al
  8009d6:	75 03                	jne    8009db <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8009d8:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009db:	ff 45 e0             	incl   -0x20(%ebp)
  8009de:	a1 24 40 80 00       	mov    0x804024,%eax
  8009e3:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8009e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009ec:	39 c2                	cmp    %eax,%edx
  8009ee:	77 c8                	ja     8009b8 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8009f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009f3:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8009f6:	74 14                	je     800a0c <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8009f8:	83 ec 04             	sub    $0x4,%esp
  8009fb:	68 3c 2b 80 00       	push   $0x802b3c
  800a00:	6a 44                	push   $0x44
  800a02:	68 dc 2a 80 00       	push   $0x802adc
  800a07:	e8 15 fe ff ff       	call   800821 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800a0c:	90                   	nop
  800a0d:	c9                   	leave  
  800a0e:	c3                   	ret    

00800a0f <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800a0f:	55                   	push   %ebp
  800a10:	89 e5                	mov    %esp,%ebp
  800a12:	53                   	push   %ebx
  800a13:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800a16:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a19:	8b 00                	mov    (%eax),%eax
  800a1b:	8d 48 01             	lea    0x1(%eax),%ecx
  800a1e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a21:	89 0a                	mov    %ecx,(%edx)
  800a23:	8b 55 08             	mov    0x8(%ebp),%edx
  800a26:	88 d1                	mov    %dl,%cl
  800a28:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a2b:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800a2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a32:	8b 00                	mov    (%eax),%eax
  800a34:	3d ff 00 00 00       	cmp    $0xff,%eax
  800a39:	75 30                	jne    800a6b <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800a3b:	8b 15 1c c1 81 00    	mov    0x81c11c,%edx
  800a41:	a0 44 40 80 00       	mov    0x804044,%al
  800a46:	0f b6 c0             	movzbl %al,%eax
  800a49:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a4c:	8b 09                	mov    (%ecx),%ecx
  800a4e:	89 cb                	mov    %ecx,%ebx
  800a50:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a53:	83 c1 08             	add    $0x8,%ecx
  800a56:	52                   	push   %edx
  800a57:	50                   	push   %eax
  800a58:	53                   	push   %ebx
  800a59:	51                   	push   %ecx
  800a5a:	e8 5f 13 00 00       	call   801dbe <sys_cputs>
  800a5f:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800a62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a65:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800a6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a6e:	8b 40 04             	mov    0x4(%eax),%eax
  800a71:	8d 50 01             	lea    0x1(%eax),%edx
  800a74:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a77:	89 50 04             	mov    %edx,0x4(%eax)
}
  800a7a:	90                   	nop
  800a7b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a7e:	c9                   	leave  
  800a7f:	c3                   	ret    

00800a80 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800a80:	55                   	push   %ebp
  800a81:	89 e5                	mov    %esp,%ebp
  800a83:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800a89:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800a90:	00 00 00 
	b.cnt = 0;
  800a93:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800a9a:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800a9d:	ff 75 0c             	pushl  0xc(%ebp)
  800aa0:	ff 75 08             	pushl  0x8(%ebp)
  800aa3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800aa9:	50                   	push   %eax
  800aaa:	68 0f 0a 80 00       	push   $0x800a0f
  800aaf:	e8 5a 02 00 00       	call   800d0e <vprintfmt>
  800ab4:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800ab7:	8b 15 1c c1 81 00    	mov    0x81c11c,%edx
  800abd:	a0 44 40 80 00       	mov    0x804044,%al
  800ac2:	0f b6 c0             	movzbl %al,%eax
  800ac5:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800acb:	52                   	push   %edx
  800acc:	50                   	push   %eax
  800acd:	51                   	push   %ecx
  800ace:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800ad4:	83 c0 08             	add    $0x8,%eax
  800ad7:	50                   	push   %eax
  800ad8:	e8 e1 12 00 00       	call   801dbe <sys_cputs>
  800add:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800ae0:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
	return b.cnt;
  800ae7:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800aed:	c9                   	leave  
  800aee:	c3                   	ret    

00800aef <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800aef:	55                   	push   %ebp
  800af0:	89 e5                	mov    %esp,%ebp
  800af2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800af5:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	va_start(ap, fmt);
  800afc:	8d 45 0c             	lea    0xc(%ebp),%eax
  800aff:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800b02:	8b 45 08             	mov    0x8(%ebp),%eax
  800b05:	83 ec 08             	sub    $0x8,%esp
  800b08:	ff 75 f4             	pushl  -0xc(%ebp)
  800b0b:	50                   	push   %eax
  800b0c:	e8 6f ff ff ff       	call   800a80 <vcprintf>
  800b11:	83 c4 10             	add    $0x10,%esp
  800b14:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800b17:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b1a:	c9                   	leave  
  800b1b:	c3                   	ret    

00800b1c <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800b1c:	55                   	push   %ebp
  800b1d:	89 e5                	mov    %esp,%ebp
  800b1f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800b22:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800b29:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2c:	c1 e0 08             	shl    $0x8,%eax
  800b2f:	a3 1c c1 81 00       	mov    %eax,0x81c11c
	va_start(ap, fmt);
  800b34:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b37:	83 c0 04             	add    $0x4,%eax
  800b3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800b3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b40:	83 ec 08             	sub    $0x8,%esp
  800b43:	ff 75 f4             	pushl  -0xc(%ebp)
  800b46:	50                   	push   %eax
  800b47:	e8 34 ff ff ff       	call   800a80 <vcprintf>
  800b4c:	83 c4 10             	add    $0x10,%esp
  800b4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800b52:	c7 05 1c c1 81 00 00 	movl   $0x700,0x81c11c
  800b59:	07 00 00 

	return cnt;
  800b5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b5f:	c9                   	leave  
  800b60:	c3                   	ret    

00800b61 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800b61:	55                   	push   %ebp
  800b62:	89 e5                	mov    %esp,%ebp
  800b64:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800b67:	e8 96 12 00 00       	call   801e02 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800b6c:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800b72:	8b 45 08             	mov    0x8(%ebp),%eax
  800b75:	83 ec 08             	sub    $0x8,%esp
  800b78:	ff 75 f4             	pushl  -0xc(%ebp)
  800b7b:	50                   	push   %eax
  800b7c:	e8 ff fe ff ff       	call   800a80 <vcprintf>
  800b81:	83 c4 10             	add    $0x10,%esp
  800b84:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800b87:	e8 90 12 00 00       	call   801e1c <sys_unlock_cons>
	return cnt;
  800b8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b8f:	c9                   	leave  
  800b90:	c3                   	ret    

00800b91 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800b91:	55                   	push   %ebp
  800b92:	89 e5                	mov    %esp,%ebp
  800b94:	53                   	push   %ebx
  800b95:	83 ec 14             	sub    $0x14,%esp
  800b98:	8b 45 10             	mov    0x10(%ebp),%eax
  800b9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b9e:	8b 45 14             	mov    0x14(%ebp),%eax
  800ba1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800ba4:	8b 45 18             	mov    0x18(%ebp),%eax
  800ba7:	ba 00 00 00 00       	mov    $0x0,%edx
  800bac:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800baf:	77 55                	ja     800c06 <printnum+0x75>
  800bb1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800bb4:	72 05                	jb     800bbb <printnum+0x2a>
  800bb6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800bb9:	77 4b                	ja     800c06 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800bbb:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800bbe:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800bc1:	8b 45 18             	mov    0x18(%ebp),%eax
  800bc4:	ba 00 00 00 00       	mov    $0x0,%edx
  800bc9:	52                   	push   %edx
  800bca:	50                   	push   %eax
  800bcb:	ff 75 f4             	pushl  -0xc(%ebp)
  800bce:	ff 75 f0             	pushl  -0x10(%ebp)
  800bd1:	e8 22 19 00 00       	call   8024f8 <__udivdi3>
  800bd6:	83 c4 10             	add    $0x10,%esp
  800bd9:	83 ec 04             	sub    $0x4,%esp
  800bdc:	ff 75 20             	pushl  0x20(%ebp)
  800bdf:	53                   	push   %ebx
  800be0:	ff 75 18             	pushl  0x18(%ebp)
  800be3:	52                   	push   %edx
  800be4:	50                   	push   %eax
  800be5:	ff 75 0c             	pushl  0xc(%ebp)
  800be8:	ff 75 08             	pushl  0x8(%ebp)
  800beb:	e8 a1 ff ff ff       	call   800b91 <printnum>
  800bf0:	83 c4 20             	add    $0x20,%esp
  800bf3:	eb 1a                	jmp    800c0f <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800bf5:	83 ec 08             	sub    $0x8,%esp
  800bf8:	ff 75 0c             	pushl  0xc(%ebp)
  800bfb:	ff 75 20             	pushl  0x20(%ebp)
  800bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800c01:	ff d0                	call   *%eax
  800c03:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c06:	ff 4d 1c             	decl   0x1c(%ebp)
  800c09:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800c0d:	7f e6                	jg     800bf5 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c0f:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800c12:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c1d:	53                   	push   %ebx
  800c1e:	51                   	push   %ecx
  800c1f:	52                   	push   %edx
  800c20:	50                   	push   %eax
  800c21:	e8 e2 19 00 00       	call   802608 <__umoddi3>
  800c26:	83 c4 10             	add    $0x10,%esp
  800c29:	05 b4 2d 80 00       	add    $0x802db4,%eax
  800c2e:	8a 00                	mov    (%eax),%al
  800c30:	0f be c0             	movsbl %al,%eax
  800c33:	83 ec 08             	sub    $0x8,%esp
  800c36:	ff 75 0c             	pushl  0xc(%ebp)
  800c39:	50                   	push   %eax
  800c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3d:	ff d0                	call   *%eax
  800c3f:	83 c4 10             	add    $0x10,%esp
}
  800c42:	90                   	nop
  800c43:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c46:	c9                   	leave  
  800c47:	c3                   	ret    

00800c48 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800c48:	55                   	push   %ebp
  800c49:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c4b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c4f:	7e 1c                	jle    800c6d <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800c51:	8b 45 08             	mov    0x8(%ebp),%eax
  800c54:	8b 00                	mov    (%eax),%eax
  800c56:	8d 50 08             	lea    0x8(%eax),%edx
  800c59:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5c:	89 10                	mov    %edx,(%eax)
  800c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c61:	8b 00                	mov    (%eax),%eax
  800c63:	83 e8 08             	sub    $0x8,%eax
  800c66:	8b 50 04             	mov    0x4(%eax),%edx
  800c69:	8b 00                	mov    (%eax),%eax
  800c6b:	eb 40                	jmp    800cad <getuint+0x65>
	else if (lflag)
  800c6d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c71:	74 1e                	je     800c91 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800c73:	8b 45 08             	mov    0x8(%ebp),%eax
  800c76:	8b 00                	mov    (%eax),%eax
  800c78:	8d 50 04             	lea    0x4(%eax),%edx
  800c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7e:	89 10                	mov    %edx,(%eax)
  800c80:	8b 45 08             	mov    0x8(%ebp),%eax
  800c83:	8b 00                	mov    (%eax),%eax
  800c85:	83 e8 04             	sub    $0x4,%eax
  800c88:	8b 00                	mov    (%eax),%eax
  800c8a:	ba 00 00 00 00       	mov    $0x0,%edx
  800c8f:	eb 1c                	jmp    800cad <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800c91:	8b 45 08             	mov    0x8(%ebp),%eax
  800c94:	8b 00                	mov    (%eax),%eax
  800c96:	8d 50 04             	lea    0x4(%eax),%edx
  800c99:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9c:	89 10                	mov    %edx,(%eax)
  800c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca1:	8b 00                	mov    (%eax),%eax
  800ca3:	83 e8 04             	sub    $0x4,%eax
  800ca6:	8b 00                	mov    (%eax),%eax
  800ca8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800cad:	5d                   	pop    %ebp
  800cae:	c3                   	ret    

00800caf <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800caf:	55                   	push   %ebp
  800cb0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800cb2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800cb6:	7e 1c                	jle    800cd4 <getint+0x25>
		return va_arg(*ap, long long);
  800cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbb:	8b 00                	mov    (%eax),%eax
  800cbd:	8d 50 08             	lea    0x8(%eax),%edx
  800cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc3:	89 10                	mov    %edx,(%eax)
  800cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc8:	8b 00                	mov    (%eax),%eax
  800cca:	83 e8 08             	sub    $0x8,%eax
  800ccd:	8b 50 04             	mov    0x4(%eax),%edx
  800cd0:	8b 00                	mov    (%eax),%eax
  800cd2:	eb 38                	jmp    800d0c <getint+0x5d>
	else if (lflag)
  800cd4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cd8:	74 1a                	je     800cf4 <getint+0x45>
		return va_arg(*ap, long);
  800cda:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdd:	8b 00                	mov    (%eax),%eax
  800cdf:	8d 50 04             	lea    0x4(%eax),%edx
  800ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce5:	89 10                	mov    %edx,(%eax)
  800ce7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cea:	8b 00                	mov    (%eax),%eax
  800cec:	83 e8 04             	sub    $0x4,%eax
  800cef:	8b 00                	mov    (%eax),%eax
  800cf1:	99                   	cltd   
  800cf2:	eb 18                	jmp    800d0c <getint+0x5d>
	else
		return va_arg(*ap, int);
  800cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf7:	8b 00                	mov    (%eax),%eax
  800cf9:	8d 50 04             	lea    0x4(%eax),%edx
  800cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cff:	89 10                	mov    %edx,(%eax)
  800d01:	8b 45 08             	mov    0x8(%ebp),%eax
  800d04:	8b 00                	mov    (%eax),%eax
  800d06:	83 e8 04             	sub    $0x4,%eax
  800d09:	8b 00                	mov    (%eax),%eax
  800d0b:	99                   	cltd   
}
  800d0c:	5d                   	pop    %ebp
  800d0d:	c3                   	ret    

00800d0e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800d0e:	55                   	push   %ebp
  800d0f:	89 e5                	mov    %esp,%ebp
  800d11:	56                   	push   %esi
  800d12:	53                   	push   %ebx
  800d13:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d16:	eb 17                	jmp    800d2f <vprintfmt+0x21>
			if (ch == '\0')
  800d18:	85 db                	test   %ebx,%ebx
  800d1a:	0f 84 c1 03 00 00    	je     8010e1 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800d20:	83 ec 08             	sub    $0x8,%esp
  800d23:	ff 75 0c             	pushl  0xc(%ebp)
  800d26:	53                   	push   %ebx
  800d27:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2a:	ff d0                	call   *%eax
  800d2c:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d2f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d32:	8d 50 01             	lea    0x1(%eax),%edx
  800d35:	89 55 10             	mov    %edx,0x10(%ebp)
  800d38:	8a 00                	mov    (%eax),%al
  800d3a:	0f b6 d8             	movzbl %al,%ebx
  800d3d:	83 fb 25             	cmp    $0x25,%ebx
  800d40:	75 d6                	jne    800d18 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800d42:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800d46:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800d4d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800d54:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800d5b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d62:	8b 45 10             	mov    0x10(%ebp),%eax
  800d65:	8d 50 01             	lea    0x1(%eax),%edx
  800d68:	89 55 10             	mov    %edx,0x10(%ebp)
  800d6b:	8a 00                	mov    (%eax),%al
  800d6d:	0f b6 d8             	movzbl %al,%ebx
  800d70:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800d73:	83 f8 5b             	cmp    $0x5b,%eax
  800d76:	0f 87 3d 03 00 00    	ja     8010b9 <vprintfmt+0x3ab>
  800d7c:	8b 04 85 d8 2d 80 00 	mov    0x802dd8(,%eax,4),%eax
  800d83:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800d85:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800d89:	eb d7                	jmp    800d62 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800d8b:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800d8f:	eb d1                	jmp    800d62 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d91:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800d98:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800d9b:	89 d0                	mov    %edx,%eax
  800d9d:	c1 e0 02             	shl    $0x2,%eax
  800da0:	01 d0                	add    %edx,%eax
  800da2:	01 c0                	add    %eax,%eax
  800da4:	01 d8                	add    %ebx,%eax
  800da6:	83 e8 30             	sub    $0x30,%eax
  800da9:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800dac:	8b 45 10             	mov    0x10(%ebp),%eax
  800daf:	8a 00                	mov    (%eax),%al
  800db1:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800db4:	83 fb 2f             	cmp    $0x2f,%ebx
  800db7:	7e 3e                	jle    800df7 <vprintfmt+0xe9>
  800db9:	83 fb 39             	cmp    $0x39,%ebx
  800dbc:	7f 39                	jg     800df7 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800dbe:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800dc1:	eb d5                	jmp    800d98 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800dc3:	8b 45 14             	mov    0x14(%ebp),%eax
  800dc6:	83 c0 04             	add    $0x4,%eax
  800dc9:	89 45 14             	mov    %eax,0x14(%ebp)
  800dcc:	8b 45 14             	mov    0x14(%ebp),%eax
  800dcf:	83 e8 04             	sub    $0x4,%eax
  800dd2:	8b 00                	mov    (%eax),%eax
  800dd4:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800dd7:	eb 1f                	jmp    800df8 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800dd9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ddd:	79 83                	jns    800d62 <vprintfmt+0x54>
				width = 0;
  800ddf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800de6:	e9 77 ff ff ff       	jmp    800d62 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800deb:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800df2:	e9 6b ff ff ff       	jmp    800d62 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800df7:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800df8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dfc:	0f 89 60 ff ff ff    	jns    800d62 <vprintfmt+0x54>
				width = precision, precision = -1;
  800e02:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e05:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e08:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800e0f:	e9 4e ff ff ff       	jmp    800d62 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800e14:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800e17:	e9 46 ff ff ff       	jmp    800d62 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800e1c:	8b 45 14             	mov    0x14(%ebp),%eax
  800e1f:	83 c0 04             	add    $0x4,%eax
  800e22:	89 45 14             	mov    %eax,0x14(%ebp)
  800e25:	8b 45 14             	mov    0x14(%ebp),%eax
  800e28:	83 e8 04             	sub    $0x4,%eax
  800e2b:	8b 00                	mov    (%eax),%eax
  800e2d:	83 ec 08             	sub    $0x8,%esp
  800e30:	ff 75 0c             	pushl  0xc(%ebp)
  800e33:	50                   	push   %eax
  800e34:	8b 45 08             	mov    0x8(%ebp),%eax
  800e37:	ff d0                	call   *%eax
  800e39:	83 c4 10             	add    $0x10,%esp
			break;
  800e3c:	e9 9b 02 00 00       	jmp    8010dc <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800e41:	8b 45 14             	mov    0x14(%ebp),%eax
  800e44:	83 c0 04             	add    $0x4,%eax
  800e47:	89 45 14             	mov    %eax,0x14(%ebp)
  800e4a:	8b 45 14             	mov    0x14(%ebp),%eax
  800e4d:	83 e8 04             	sub    $0x4,%eax
  800e50:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800e52:	85 db                	test   %ebx,%ebx
  800e54:	79 02                	jns    800e58 <vprintfmt+0x14a>
				err = -err;
  800e56:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800e58:	83 fb 64             	cmp    $0x64,%ebx
  800e5b:	7f 0b                	jg     800e68 <vprintfmt+0x15a>
  800e5d:	8b 34 9d 20 2c 80 00 	mov    0x802c20(,%ebx,4),%esi
  800e64:	85 f6                	test   %esi,%esi
  800e66:	75 19                	jne    800e81 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800e68:	53                   	push   %ebx
  800e69:	68 c5 2d 80 00       	push   $0x802dc5
  800e6e:	ff 75 0c             	pushl  0xc(%ebp)
  800e71:	ff 75 08             	pushl  0x8(%ebp)
  800e74:	e8 70 02 00 00       	call   8010e9 <printfmt>
  800e79:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800e7c:	e9 5b 02 00 00       	jmp    8010dc <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800e81:	56                   	push   %esi
  800e82:	68 ce 2d 80 00       	push   $0x802dce
  800e87:	ff 75 0c             	pushl  0xc(%ebp)
  800e8a:	ff 75 08             	pushl  0x8(%ebp)
  800e8d:	e8 57 02 00 00       	call   8010e9 <printfmt>
  800e92:	83 c4 10             	add    $0x10,%esp
			break;
  800e95:	e9 42 02 00 00       	jmp    8010dc <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800e9a:	8b 45 14             	mov    0x14(%ebp),%eax
  800e9d:	83 c0 04             	add    $0x4,%eax
  800ea0:	89 45 14             	mov    %eax,0x14(%ebp)
  800ea3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ea6:	83 e8 04             	sub    $0x4,%eax
  800ea9:	8b 30                	mov    (%eax),%esi
  800eab:	85 f6                	test   %esi,%esi
  800ead:	75 05                	jne    800eb4 <vprintfmt+0x1a6>
				p = "(null)";
  800eaf:	be d1 2d 80 00       	mov    $0x802dd1,%esi
			if (width > 0 && padc != '-')
  800eb4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800eb8:	7e 6d                	jle    800f27 <vprintfmt+0x219>
  800eba:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800ebe:	74 67                	je     800f27 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ec0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ec3:	83 ec 08             	sub    $0x8,%esp
  800ec6:	50                   	push   %eax
  800ec7:	56                   	push   %esi
  800ec8:	e8 26 05 00 00       	call   8013f3 <strnlen>
  800ecd:	83 c4 10             	add    $0x10,%esp
  800ed0:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800ed3:	eb 16                	jmp    800eeb <vprintfmt+0x1dd>
					putch(padc, putdat);
  800ed5:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800ed9:	83 ec 08             	sub    $0x8,%esp
  800edc:	ff 75 0c             	pushl  0xc(%ebp)
  800edf:	50                   	push   %eax
  800ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee3:	ff d0                	call   *%eax
  800ee5:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800ee8:	ff 4d e4             	decl   -0x1c(%ebp)
  800eeb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800eef:	7f e4                	jg     800ed5 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ef1:	eb 34                	jmp    800f27 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800ef3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800ef7:	74 1c                	je     800f15 <vprintfmt+0x207>
  800ef9:	83 fb 1f             	cmp    $0x1f,%ebx
  800efc:	7e 05                	jle    800f03 <vprintfmt+0x1f5>
  800efe:	83 fb 7e             	cmp    $0x7e,%ebx
  800f01:	7e 12                	jle    800f15 <vprintfmt+0x207>
					putch('?', putdat);
  800f03:	83 ec 08             	sub    $0x8,%esp
  800f06:	ff 75 0c             	pushl  0xc(%ebp)
  800f09:	6a 3f                	push   $0x3f
  800f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0e:	ff d0                	call   *%eax
  800f10:	83 c4 10             	add    $0x10,%esp
  800f13:	eb 0f                	jmp    800f24 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800f15:	83 ec 08             	sub    $0x8,%esp
  800f18:	ff 75 0c             	pushl  0xc(%ebp)
  800f1b:	53                   	push   %ebx
  800f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1f:	ff d0                	call   *%eax
  800f21:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f24:	ff 4d e4             	decl   -0x1c(%ebp)
  800f27:	89 f0                	mov    %esi,%eax
  800f29:	8d 70 01             	lea    0x1(%eax),%esi
  800f2c:	8a 00                	mov    (%eax),%al
  800f2e:	0f be d8             	movsbl %al,%ebx
  800f31:	85 db                	test   %ebx,%ebx
  800f33:	74 24                	je     800f59 <vprintfmt+0x24b>
  800f35:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f39:	78 b8                	js     800ef3 <vprintfmt+0x1e5>
  800f3b:	ff 4d e0             	decl   -0x20(%ebp)
  800f3e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f42:	79 af                	jns    800ef3 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f44:	eb 13                	jmp    800f59 <vprintfmt+0x24b>
				putch(' ', putdat);
  800f46:	83 ec 08             	sub    $0x8,%esp
  800f49:	ff 75 0c             	pushl  0xc(%ebp)
  800f4c:	6a 20                	push   $0x20
  800f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f51:	ff d0                	call   *%eax
  800f53:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f56:	ff 4d e4             	decl   -0x1c(%ebp)
  800f59:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f5d:	7f e7                	jg     800f46 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800f5f:	e9 78 01 00 00       	jmp    8010dc <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800f64:	83 ec 08             	sub    $0x8,%esp
  800f67:	ff 75 e8             	pushl  -0x18(%ebp)
  800f6a:	8d 45 14             	lea    0x14(%ebp),%eax
  800f6d:	50                   	push   %eax
  800f6e:	e8 3c fd ff ff       	call   800caf <getint>
  800f73:	83 c4 10             	add    $0x10,%esp
  800f76:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f79:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800f7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f7f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f82:	85 d2                	test   %edx,%edx
  800f84:	79 23                	jns    800fa9 <vprintfmt+0x29b>
				putch('-', putdat);
  800f86:	83 ec 08             	sub    $0x8,%esp
  800f89:	ff 75 0c             	pushl  0xc(%ebp)
  800f8c:	6a 2d                	push   $0x2d
  800f8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f91:	ff d0                	call   *%eax
  800f93:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800f96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f99:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f9c:	f7 d8                	neg    %eax
  800f9e:	83 d2 00             	adc    $0x0,%edx
  800fa1:	f7 da                	neg    %edx
  800fa3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fa6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800fa9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800fb0:	e9 bc 00 00 00       	jmp    801071 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800fb5:	83 ec 08             	sub    $0x8,%esp
  800fb8:	ff 75 e8             	pushl  -0x18(%ebp)
  800fbb:	8d 45 14             	lea    0x14(%ebp),%eax
  800fbe:	50                   	push   %eax
  800fbf:	e8 84 fc ff ff       	call   800c48 <getuint>
  800fc4:	83 c4 10             	add    $0x10,%esp
  800fc7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fca:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800fcd:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800fd4:	e9 98 00 00 00       	jmp    801071 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800fd9:	83 ec 08             	sub    $0x8,%esp
  800fdc:	ff 75 0c             	pushl  0xc(%ebp)
  800fdf:	6a 58                	push   $0x58
  800fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe4:	ff d0                	call   *%eax
  800fe6:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800fe9:	83 ec 08             	sub    $0x8,%esp
  800fec:	ff 75 0c             	pushl  0xc(%ebp)
  800fef:	6a 58                	push   $0x58
  800ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff4:	ff d0                	call   *%eax
  800ff6:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ff9:	83 ec 08             	sub    $0x8,%esp
  800ffc:	ff 75 0c             	pushl  0xc(%ebp)
  800fff:	6a 58                	push   $0x58
  801001:	8b 45 08             	mov    0x8(%ebp),%eax
  801004:	ff d0                	call   *%eax
  801006:	83 c4 10             	add    $0x10,%esp
			break;
  801009:	e9 ce 00 00 00       	jmp    8010dc <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  80100e:	83 ec 08             	sub    $0x8,%esp
  801011:	ff 75 0c             	pushl  0xc(%ebp)
  801014:	6a 30                	push   $0x30
  801016:	8b 45 08             	mov    0x8(%ebp),%eax
  801019:	ff d0                	call   *%eax
  80101b:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80101e:	83 ec 08             	sub    $0x8,%esp
  801021:	ff 75 0c             	pushl  0xc(%ebp)
  801024:	6a 78                	push   $0x78
  801026:	8b 45 08             	mov    0x8(%ebp),%eax
  801029:	ff d0                	call   *%eax
  80102b:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80102e:	8b 45 14             	mov    0x14(%ebp),%eax
  801031:	83 c0 04             	add    $0x4,%eax
  801034:	89 45 14             	mov    %eax,0x14(%ebp)
  801037:	8b 45 14             	mov    0x14(%ebp),%eax
  80103a:	83 e8 04             	sub    $0x4,%eax
  80103d:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80103f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801042:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801049:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801050:	eb 1f                	jmp    801071 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801052:	83 ec 08             	sub    $0x8,%esp
  801055:	ff 75 e8             	pushl  -0x18(%ebp)
  801058:	8d 45 14             	lea    0x14(%ebp),%eax
  80105b:	50                   	push   %eax
  80105c:	e8 e7 fb ff ff       	call   800c48 <getuint>
  801061:	83 c4 10             	add    $0x10,%esp
  801064:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801067:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80106a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801071:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801075:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801078:	83 ec 04             	sub    $0x4,%esp
  80107b:	52                   	push   %edx
  80107c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80107f:	50                   	push   %eax
  801080:	ff 75 f4             	pushl  -0xc(%ebp)
  801083:	ff 75 f0             	pushl  -0x10(%ebp)
  801086:	ff 75 0c             	pushl  0xc(%ebp)
  801089:	ff 75 08             	pushl  0x8(%ebp)
  80108c:	e8 00 fb ff ff       	call   800b91 <printnum>
  801091:	83 c4 20             	add    $0x20,%esp
			break;
  801094:	eb 46                	jmp    8010dc <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801096:	83 ec 08             	sub    $0x8,%esp
  801099:	ff 75 0c             	pushl  0xc(%ebp)
  80109c:	53                   	push   %ebx
  80109d:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a0:	ff d0                	call   *%eax
  8010a2:	83 c4 10             	add    $0x10,%esp
			break;
  8010a5:	eb 35                	jmp    8010dc <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8010a7:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
			break;
  8010ae:	eb 2c                	jmp    8010dc <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8010b0:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
			break;
  8010b7:	eb 23                	jmp    8010dc <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8010b9:	83 ec 08             	sub    $0x8,%esp
  8010bc:	ff 75 0c             	pushl  0xc(%ebp)
  8010bf:	6a 25                	push   $0x25
  8010c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c4:	ff d0                	call   *%eax
  8010c6:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8010c9:	ff 4d 10             	decl   0x10(%ebp)
  8010cc:	eb 03                	jmp    8010d1 <vprintfmt+0x3c3>
  8010ce:	ff 4d 10             	decl   0x10(%ebp)
  8010d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d4:	48                   	dec    %eax
  8010d5:	8a 00                	mov    (%eax),%al
  8010d7:	3c 25                	cmp    $0x25,%al
  8010d9:	75 f3                	jne    8010ce <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8010db:	90                   	nop
		}
	}
  8010dc:	e9 35 fc ff ff       	jmp    800d16 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8010e1:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8010e2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8010e5:	5b                   	pop    %ebx
  8010e6:	5e                   	pop    %esi
  8010e7:	5d                   	pop    %ebp
  8010e8:	c3                   	ret    

008010e9 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8010e9:	55                   	push   %ebp
  8010ea:	89 e5                	mov    %esp,%ebp
  8010ec:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8010ef:	8d 45 10             	lea    0x10(%ebp),%eax
  8010f2:	83 c0 04             	add    $0x4,%eax
  8010f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8010f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8010fb:	ff 75 f4             	pushl  -0xc(%ebp)
  8010fe:	50                   	push   %eax
  8010ff:	ff 75 0c             	pushl  0xc(%ebp)
  801102:	ff 75 08             	pushl  0x8(%ebp)
  801105:	e8 04 fc ff ff       	call   800d0e <vprintfmt>
  80110a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80110d:	90                   	nop
  80110e:	c9                   	leave  
  80110f:	c3                   	ret    

00801110 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801110:	55                   	push   %ebp
  801111:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801113:	8b 45 0c             	mov    0xc(%ebp),%eax
  801116:	8b 40 08             	mov    0x8(%eax),%eax
  801119:	8d 50 01             	lea    0x1(%eax),%edx
  80111c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801122:	8b 45 0c             	mov    0xc(%ebp),%eax
  801125:	8b 10                	mov    (%eax),%edx
  801127:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112a:	8b 40 04             	mov    0x4(%eax),%eax
  80112d:	39 c2                	cmp    %eax,%edx
  80112f:	73 12                	jae    801143 <sprintputch+0x33>
		*b->buf++ = ch;
  801131:	8b 45 0c             	mov    0xc(%ebp),%eax
  801134:	8b 00                	mov    (%eax),%eax
  801136:	8d 48 01             	lea    0x1(%eax),%ecx
  801139:	8b 55 0c             	mov    0xc(%ebp),%edx
  80113c:	89 0a                	mov    %ecx,(%edx)
  80113e:	8b 55 08             	mov    0x8(%ebp),%edx
  801141:	88 10                	mov    %dl,(%eax)
}
  801143:	90                   	nop
  801144:	5d                   	pop    %ebp
  801145:	c3                   	ret    

00801146 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801146:	55                   	push   %ebp
  801147:	89 e5                	mov    %esp,%ebp
  801149:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80114c:	8b 45 08             	mov    0x8(%ebp),%eax
  80114f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801152:	8b 45 0c             	mov    0xc(%ebp),%eax
  801155:	8d 50 ff             	lea    -0x1(%eax),%edx
  801158:	8b 45 08             	mov    0x8(%ebp),%eax
  80115b:	01 d0                	add    %edx,%eax
  80115d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801160:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801167:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80116b:	74 06                	je     801173 <vsnprintf+0x2d>
  80116d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801171:	7f 07                	jg     80117a <vsnprintf+0x34>
		return -E_INVAL;
  801173:	b8 03 00 00 00       	mov    $0x3,%eax
  801178:	eb 20                	jmp    80119a <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80117a:	ff 75 14             	pushl  0x14(%ebp)
  80117d:	ff 75 10             	pushl  0x10(%ebp)
  801180:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801183:	50                   	push   %eax
  801184:	68 10 11 80 00       	push   $0x801110
  801189:	e8 80 fb ff ff       	call   800d0e <vprintfmt>
  80118e:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801191:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801194:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801197:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80119a:	c9                   	leave  
  80119b:	c3                   	ret    

0080119c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80119c:	55                   	push   %ebp
  80119d:	89 e5                	mov    %esp,%ebp
  80119f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8011a2:	8d 45 10             	lea    0x10(%ebp),%eax
  8011a5:	83 c0 04             	add    $0x4,%eax
  8011a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8011ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ae:	ff 75 f4             	pushl  -0xc(%ebp)
  8011b1:	50                   	push   %eax
  8011b2:	ff 75 0c             	pushl  0xc(%ebp)
  8011b5:	ff 75 08             	pushl  0x8(%ebp)
  8011b8:	e8 89 ff ff ff       	call   801146 <vsnprintf>
  8011bd:	83 c4 10             	add    $0x10,%esp
  8011c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8011c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8011c6:	c9                   	leave  
  8011c7:	c3                   	ret    

008011c8 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  8011c8:	55                   	push   %ebp
  8011c9:	89 e5                	mov    %esp,%ebp
  8011cb:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  8011ce:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011d2:	74 13                	je     8011e7 <readline+0x1f>
		cprintf("%s", prompt);
  8011d4:	83 ec 08             	sub    $0x8,%esp
  8011d7:	ff 75 08             	pushl  0x8(%ebp)
  8011da:	68 48 2f 80 00       	push   $0x802f48
  8011df:	e8 0b f9 ff ff       	call   800aef <cprintf>
  8011e4:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8011e7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8011ee:	83 ec 0c             	sub    $0xc,%esp
  8011f1:	6a 00                	push   $0x0
  8011f3:	e8 6f f4 ff ff       	call   800667 <iscons>
  8011f8:	83 c4 10             	add    $0x10,%esp
  8011fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8011fe:	e8 51 f4 ff ff       	call   800654 <getchar>
  801203:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801206:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80120a:	79 22                	jns    80122e <readline+0x66>
			if (c != -E_EOF)
  80120c:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801210:	0f 84 ad 00 00 00    	je     8012c3 <readline+0xfb>
				cprintf("read error: %e\n", c);
  801216:	83 ec 08             	sub    $0x8,%esp
  801219:	ff 75 ec             	pushl  -0x14(%ebp)
  80121c:	68 4b 2f 80 00       	push   $0x802f4b
  801221:	e8 c9 f8 ff ff       	call   800aef <cprintf>
  801226:	83 c4 10             	add    $0x10,%esp
			break;
  801229:	e9 95 00 00 00       	jmp    8012c3 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  80122e:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801232:	7e 34                	jle    801268 <readline+0xa0>
  801234:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80123b:	7f 2b                	jg     801268 <readline+0xa0>
			if (echoing)
  80123d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801241:	74 0e                	je     801251 <readline+0x89>
				cputchar(c);
  801243:	83 ec 0c             	sub    $0xc,%esp
  801246:	ff 75 ec             	pushl  -0x14(%ebp)
  801249:	e8 e7 f3 ff ff       	call   800635 <cputchar>
  80124e:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801251:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801254:	8d 50 01             	lea    0x1(%eax),%edx
  801257:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80125a:	89 c2                	mov    %eax,%edx
  80125c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125f:	01 d0                	add    %edx,%eax
  801261:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801264:	88 10                	mov    %dl,(%eax)
  801266:	eb 56                	jmp    8012be <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  801268:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80126c:	75 1f                	jne    80128d <readline+0xc5>
  80126e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801272:	7e 19                	jle    80128d <readline+0xc5>
			if (echoing)
  801274:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801278:	74 0e                	je     801288 <readline+0xc0>
				cputchar(c);
  80127a:	83 ec 0c             	sub    $0xc,%esp
  80127d:	ff 75 ec             	pushl  -0x14(%ebp)
  801280:	e8 b0 f3 ff ff       	call   800635 <cputchar>
  801285:	83 c4 10             	add    $0x10,%esp

			i--;
  801288:	ff 4d f4             	decl   -0xc(%ebp)
  80128b:	eb 31                	jmp    8012be <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  80128d:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801291:	74 0a                	je     80129d <readline+0xd5>
  801293:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801297:	0f 85 61 ff ff ff    	jne    8011fe <readline+0x36>
			if (echoing)
  80129d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012a1:	74 0e                	je     8012b1 <readline+0xe9>
				cputchar(c);
  8012a3:	83 ec 0c             	sub    $0xc,%esp
  8012a6:	ff 75 ec             	pushl  -0x14(%ebp)
  8012a9:	e8 87 f3 ff ff       	call   800635 <cputchar>
  8012ae:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  8012b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b7:	01 d0                	add    %edx,%eax
  8012b9:	c6 00 00             	movb   $0x0,(%eax)
			break;
  8012bc:	eb 06                	jmp    8012c4 <readline+0xfc>
		}
	}
  8012be:	e9 3b ff ff ff       	jmp    8011fe <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  8012c3:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  8012c4:	90                   	nop
  8012c5:	c9                   	leave  
  8012c6:	c3                   	ret    

008012c7 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  8012c7:	55                   	push   %ebp
  8012c8:	89 e5                	mov    %esp,%ebp
  8012ca:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  8012cd:	e8 30 0b 00 00       	call   801e02 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  8012d2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012d6:	74 13                	je     8012eb <atomic_readline+0x24>
			cprintf("%s", prompt);
  8012d8:	83 ec 08             	sub    $0x8,%esp
  8012db:	ff 75 08             	pushl  0x8(%ebp)
  8012de:	68 48 2f 80 00       	push   $0x802f48
  8012e3:	e8 07 f8 ff ff       	call   800aef <cprintf>
  8012e8:	83 c4 10             	add    $0x10,%esp

		i = 0;
  8012eb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  8012f2:	83 ec 0c             	sub    $0xc,%esp
  8012f5:	6a 00                	push   $0x0
  8012f7:	e8 6b f3 ff ff       	call   800667 <iscons>
  8012fc:	83 c4 10             	add    $0x10,%esp
  8012ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  801302:	e8 4d f3 ff ff       	call   800654 <getchar>
  801307:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  80130a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80130e:	79 22                	jns    801332 <atomic_readline+0x6b>
				if (c != -E_EOF)
  801310:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801314:	0f 84 ad 00 00 00    	je     8013c7 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  80131a:	83 ec 08             	sub    $0x8,%esp
  80131d:	ff 75 ec             	pushl  -0x14(%ebp)
  801320:	68 4b 2f 80 00       	push   $0x802f4b
  801325:	e8 c5 f7 ff ff       	call   800aef <cprintf>
  80132a:	83 c4 10             	add    $0x10,%esp
				break;
  80132d:	e9 95 00 00 00       	jmp    8013c7 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  801332:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801336:	7e 34                	jle    80136c <atomic_readline+0xa5>
  801338:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80133f:	7f 2b                	jg     80136c <atomic_readline+0xa5>
				if (echoing)
  801341:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801345:	74 0e                	je     801355 <atomic_readline+0x8e>
					cputchar(c);
  801347:	83 ec 0c             	sub    $0xc,%esp
  80134a:	ff 75 ec             	pushl  -0x14(%ebp)
  80134d:	e8 e3 f2 ff ff       	call   800635 <cputchar>
  801352:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  801355:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801358:	8d 50 01             	lea    0x1(%eax),%edx
  80135b:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80135e:	89 c2                	mov    %eax,%edx
  801360:	8b 45 0c             	mov    0xc(%ebp),%eax
  801363:	01 d0                	add    %edx,%eax
  801365:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801368:	88 10                	mov    %dl,(%eax)
  80136a:	eb 56                	jmp    8013c2 <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  80136c:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801370:	75 1f                	jne    801391 <atomic_readline+0xca>
  801372:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801376:	7e 19                	jle    801391 <atomic_readline+0xca>
				if (echoing)
  801378:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80137c:	74 0e                	je     80138c <atomic_readline+0xc5>
					cputchar(c);
  80137e:	83 ec 0c             	sub    $0xc,%esp
  801381:	ff 75 ec             	pushl  -0x14(%ebp)
  801384:	e8 ac f2 ff ff       	call   800635 <cputchar>
  801389:	83 c4 10             	add    $0x10,%esp
				i--;
  80138c:	ff 4d f4             	decl   -0xc(%ebp)
  80138f:	eb 31                	jmp    8013c2 <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  801391:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801395:	74 0a                	je     8013a1 <atomic_readline+0xda>
  801397:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  80139b:	0f 85 61 ff ff ff    	jne    801302 <atomic_readline+0x3b>
				if (echoing)
  8013a1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013a5:	74 0e                	je     8013b5 <atomic_readline+0xee>
					cputchar(c);
  8013a7:	83 ec 0c             	sub    $0xc,%esp
  8013aa:	ff 75 ec             	pushl  -0x14(%ebp)
  8013ad:	e8 83 f2 ff ff       	call   800635 <cputchar>
  8013b2:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  8013b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013bb:	01 d0                	add    %edx,%eax
  8013bd:	c6 00 00             	movb   $0x0,(%eax)
				break;
  8013c0:	eb 06                	jmp    8013c8 <atomic_readline+0x101>
			}
		}
  8013c2:	e9 3b ff ff ff       	jmp    801302 <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  8013c7:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  8013c8:	e8 4f 0a 00 00       	call   801e1c <sys_unlock_cons>
}
  8013cd:	90                   	nop
  8013ce:	c9                   	leave  
  8013cf:	c3                   	ret    

008013d0 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8013d0:	55                   	push   %ebp
  8013d1:	89 e5                	mov    %esp,%ebp
  8013d3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8013d6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013dd:	eb 06                	jmp    8013e5 <strlen+0x15>
		n++;
  8013df:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8013e2:	ff 45 08             	incl   0x8(%ebp)
  8013e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e8:	8a 00                	mov    (%eax),%al
  8013ea:	84 c0                	test   %al,%al
  8013ec:	75 f1                	jne    8013df <strlen+0xf>
		n++;
	return n;
  8013ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8013f1:	c9                   	leave  
  8013f2:	c3                   	ret    

008013f3 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8013f3:	55                   	push   %ebp
  8013f4:	89 e5                	mov    %esp,%ebp
  8013f6:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8013f9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801400:	eb 09                	jmp    80140b <strnlen+0x18>
		n++;
  801402:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801405:	ff 45 08             	incl   0x8(%ebp)
  801408:	ff 4d 0c             	decl   0xc(%ebp)
  80140b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80140f:	74 09                	je     80141a <strnlen+0x27>
  801411:	8b 45 08             	mov    0x8(%ebp),%eax
  801414:	8a 00                	mov    (%eax),%al
  801416:	84 c0                	test   %al,%al
  801418:	75 e8                	jne    801402 <strnlen+0xf>
		n++;
	return n;
  80141a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80141d:	c9                   	leave  
  80141e:	c3                   	ret    

0080141f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80141f:	55                   	push   %ebp
  801420:	89 e5                	mov    %esp,%ebp
  801422:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801425:	8b 45 08             	mov    0x8(%ebp),%eax
  801428:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80142b:	90                   	nop
  80142c:	8b 45 08             	mov    0x8(%ebp),%eax
  80142f:	8d 50 01             	lea    0x1(%eax),%edx
  801432:	89 55 08             	mov    %edx,0x8(%ebp)
  801435:	8b 55 0c             	mov    0xc(%ebp),%edx
  801438:	8d 4a 01             	lea    0x1(%edx),%ecx
  80143b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80143e:	8a 12                	mov    (%edx),%dl
  801440:	88 10                	mov    %dl,(%eax)
  801442:	8a 00                	mov    (%eax),%al
  801444:	84 c0                	test   %al,%al
  801446:	75 e4                	jne    80142c <strcpy+0xd>
		/* do nothing */;
	return ret;
  801448:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80144b:	c9                   	leave  
  80144c:	c3                   	ret    

0080144d <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80144d:	55                   	push   %ebp
  80144e:	89 e5                	mov    %esp,%ebp
  801450:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801453:	8b 45 08             	mov    0x8(%ebp),%eax
  801456:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801459:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801460:	eb 1f                	jmp    801481 <strncpy+0x34>
		*dst++ = *src;
  801462:	8b 45 08             	mov    0x8(%ebp),%eax
  801465:	8d 50 01             	lea    0x1(%eax),%edx
  801468:	89 55 08             	mov    %edx,0x8(%ebp)
  80146b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80146e:	8a 12                	mov    (%edx),%dl
  801470:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801472:	8b 45 0c             	mov    0xc(%ebp),%eax
  801475:	8a 00                	mov    (%eax),%al
  801477:	84 c0                	test   %al,%al
  801479:	74 03                	je     80147e <strncpy+0x31>
			src++;
  80147b:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80147e:	ff 45 fc             	incl   -0x4(%ebp)
  801481:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801484:	3b 45 10             	cmp    0x10(%ebp),%eax
  801487:	72 d9                	jb     801462 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801489:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80148c:	c9                   	leave  
  80148d:	c3                   	ret    

0080148e <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80148e:	55                   	push   %ebp
  80148f:	89 e5                	mov    %esp,%ebp
  801491:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801494:	8b 45 08             	mov    0x8(%ebp),%eax
  801497:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80149a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80149e:	74 30                	je     8014d0 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8014a0:	eb 16                	jmp    8014b8 <strlcpy+0x2a>
			*dst++ = *src++;
  8014a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a5:	8d 50 01             	lea    0x1(%eax),%edx
  8014a8:	89 55 08             	mov    %edx,0x8(%ebp)
  8014ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ae:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014b1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8014b4:	8a 12                	mov    (%edx),%dl
  8014b6:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8014b8:	ff 4d 10             	decl   0x10(%ebp)
  8014bb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014bf:	74 09                	je     8014ca <strlcpy+0x3c>
  8014c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c4:	8a 00                	mov    (%eax),%al
  8014c6:	84 c0                	test   %al,%al
  8014c8:	75 d8                	jne    8014a2 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8014ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cd:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8014d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8014d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014d6:	29 c2                	sub    %eax,%edx
  8014d8:	89 d0                	mov    %edx,%eax
}
  8014da:	c9                   	leave  
  8014db:	c3                   	ret    

008014dc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8014dc:	55                   	push   %ebp
  8014dd:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8014df:	eb 06                	jmp    8014e7 <strcmp+0xb>
		p++, q++;
  8014e1:	ff 45 08             	incl   0x8(%ebp)
  8014e4:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8014e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ea:	8a 00                	mov    (%eax),%al
  8014ec:	84 c0                	test   %al,%al
  8014ee:	74 0e                	je     8014fe <strcmp+0x22>
  8014f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f3:	8a 10                	mov    (%eax),%dl
  8014f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f8:	8a 00                	mov    (%eax),%al
  8014fa:	38 c2                	cmp    %al,%dl
  8014fc:	74 e3                	je     8014e1 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8014fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801501:	8a 00                	mov    (%eax),%al
  801503:	0f b6 d0             	movzbl %al,%edx
  801506:	8b 45 0c             	mov    0xc(%ebp),%eax
  801509:	8a 00                	mov    (%eax),%al
  80150b:	0f b6 c0             	movzbl %al,%eax
  80150e:	29 c2                	sub    %eax,%edx
  801510:	89 d0                	mov    %edx,%eax
}
  801512:	5d                   	pop    %ebp
  801513:	c3                   	ret    

00801514 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801514:	55                   	push   %ebp
  801515:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801517:	eb 09                	jmp    801522 <strncmp+0xe>
		n--, p++, q++;
  801519:	ff 4d 10             	decl   0x10(%ebp)
  80151c:	ff 45 08             	incl   0x8(%ebp)
  80151f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801522:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801526:	74 17                	je     80153f <strncmp+0x2b>
  801528:	8b 45 08             	mov    0x8(%ebp),%eax
  80152b:	8a 00                	mov    (%eax),%al
  80152d:	84 c0                	test   %al,%al
  80152f:	74 0e                	je     80153f <strncmp+0x2b>
  801531:	8b 45 08             	mov    0x8(%ebp),%eax
  801534:	8a 10                	mov    (%eax),%dl
  801536:	8b 45 0c             	mov    0xc(%ebp),%eax
  801539:	8a 00                	mov    (%eax),%al
  80153b:	38 c2                	cmp    %al,%dl
  80153d:	74 da                	je     801519 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80153f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801543:	75 07                	jne    80154c <strncmp+0x38>
		return 0;
  801545:	b8 00 00 00 00       	mov    $0x0,%eax
  80154a:	eb 14                	jmp    801560 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80154c:	8b 45 08             	mov    0x8(%ebp),%eax
  80154f:	8a 00                	mov    (%eax),%al
  801551:	0f b6 d0             	movzbl %al,%edx
  801554:	8b 45 0c             	mov    0xc(%ebp),%eax
  801557:	8a 00                	mov    (%eax),%al
  801559:	0f b6 c0             	movzbl %al,%eax
  80155c:	29 c2                	sub    %eax,%edx
  80155e:	89 d0                	mov    %edx,%eax
}
  801560:	5d                   	pop    %ebp
  801561:	c3                   	ret    

00801562 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801562:	55                   	push   %ebp
  801563:	89 e5                	mov    %esp,%ebp
  801565:	83 ec 04             	sub    $0x4,%esp
  801568:	8b 45 0c             	mov    0xc(%ebp),%eax
  80156b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80156e:	eb 12                	jmp    801582 <strchr+0x20>
		if (*s == c)
  801570:	8b 45 08             	mov    0x8(%ebp),%eax
  801573:	8a 00                	mov    (%eax),%al
  801575:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801578:	75 05                	jne    80157f <strchr+0x1d>
			return (char *) s;
  80157a:	8b 45 08             	mov    0x8(%ebp),%eax
  80157d:	eb 11                	jmp    801590 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80157f:	ff 45 08             	incl   0x8(%ebp)
  801582:	8b 45 08             	mov    0x8(%ebp),%eax
  801585:	8a 00                	mov    (%eax),%al
  801587:	84 c0                	test   %al,%al
  801589:	75 e5                	jne    801570 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80158b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801590:	c9                   	leave  
  801591:	c3                   	ret    

00801592 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801592:	55                   	push   %ebp
  801593:	89 e5                	mov    %esp,%ebp
  801595:	83 ec 04             	sub    $0x4,%esp
  801598:	8b 45 0c             	mov    0xc(%ebp),%eax
  80159b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80159e:	eb 0d                	jmp    8015ad <strfind+0x1b>
		if (*s == c)
  8015a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a3:	8a 00                	mov    (%eax),%al
  8015a5:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8015a8:	74 0e                	je     8015b8 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8015aa:	ff 45 08             	incl   0x8(%ebp)
  8015ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b0:	8a 00                	mov    (%eax),%al
  8015b2:	84 c0                	test   %al,%al
  8015b4:	75 ea                	jne    8015a0 <strfind+0xe>
  8015b6:	eb 01                	jmp    8015b9 <strfind+0x27>
		if (*s == c)
			break;
  8015b8:	90                   	nop
	return (char *) s;
  8015b9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015bc:	c9                   	leave  
  8015bd:	c3                   	ret    

008015be <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  8015be:	55                   	push   %ebp
  8015bf:	89 e5                	mov    %esp,%ebp
  8015c1:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  8015c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  8015ca:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8015ce:	76 63                	jbe    801633 <memset+0x75>
		uint64 data_block = c;
  8015d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d3:	99                   	cltd   
  8015d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015d7:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  8015da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015e0:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  8015e4:	c1 e0 08             	shl    $0x8,%eax
  8015e7:	09 45 f0             	or     %eax,-0x10(%ebp)
  8015ea:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  8015ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015f3:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  8015f7:	c1 e0 10             	shl    $0x10,%eax
  8015fa:	09 45 f0             	or     %eax,-0x10(%ebp)
  8015fd:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801600:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801603:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801606:	89 c2                	mov    %eax,%edx
  801608:	b8 00 00 00 00       	mov    $0x0,%eax
  80160d:	09 45 f0             	or     %eax,-0x10(%ebp)
  801610:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801613:	eb 18                	jmp    80162d <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801615:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801618:	8d 41 08             	lea    0x8(%ecx),%eax
  80161b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80161e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801621:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801624:	89 01                	mov    %eax,(%ecx)
  801626:	89 51 04             	mov    %edx,0x4(%ecx)
  801629:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  80162d:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801631:	77 e2                	ja     801615 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801633:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801637:	74 23                	je     80165c <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801639:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80163c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  80163f:	eb 0e                	jmp    80164f <memset+0x91>
			*p8++ = (uint8)c;
  801641:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801644:	8d 50 01             	lea    0x1(%eax),%edx
  801647:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80164a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80164d:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  80164f:	8b 45 10             	mov    0x10(%ebp),%eax
  801652:	8d 50 ff             	lea    -0x1(%eax),%edx
  801655:	89 55 10             	mov    %edx,0x10(%ebp)
  801658:	85 c0                	test   %eax,%eax
  80165a:	75 e5                	jne    801641 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  80165c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80165f:	c9                   	leave  
  801660:	c3                   	ret    

00801661 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801661:	55                   	push   %ebp
  801662:	89 e5                	mov    %esp,%ebp
  801664:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801667:	8b 45 0c             	mov    0xc(%ebp),%eax
  80166a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  80166d:	8b 45 08             	mov    0x8(%ebp),%eax
  801670:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801673:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801677:	76 24                	jbe    80169d <memcpy+0x3c>
		while(n >= 8){
  801679:	eb 1c                	jmp    801697 <memcpy+0x36>
			*d64 = *s64;
  80167b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80167e:	8b 50 04             	mov    0x4(%eax),%edx
  801681:	8b 00                	mov    (%eax),%eax
  801683:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801686:	89 01                	mov    %eax,(%ecx)
  801688:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  80168b:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  80168f:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801693:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801697:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80169b:	77 de                	ja     80167b <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  80169d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016a1:	74 31                	je     8016d4 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8016a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8016a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8016af:	eb 16                	jmp    8016c7 <memcpy+0x66>
			*d8++ = *s8++;
  8016b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016b4:	8d 50 01             	lea    0x1(%eax),%edx
  8016b7:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8016ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016bd:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016c0:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8016c3:	8a 12                	mov    (%edx),%dl
  8016c5:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  8016c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ca:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016cd:	89 55 10             	mov    %edx,0x10(%ebp)
  8016d0:	85 c0                	test   %eax,%eax
  8016d2:	75 dd                	jne    8016b1 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  8016d4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016d7:	c9                   	leave  
  8016d8:	c3                   	ret    

008016d9 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8016d9:	55                   	push   %ebp
  8016da:	89 e5                	mov    %esp,%ebp
  8016dc:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8016df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016e2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8016e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8016eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016ee:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8016f1:	73 50                	jae    801743 <memmove+0x6a>
  8016f3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8016f9:	01 d0                	add    %edx,%eax
  8016fb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8016fe:	76 43                	jbe    801743 <memmove+0x6a>
		s += n;
  801700:	8b 45 10             	mov    0x10(%ebp),%eax
  801703:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801706:	8b 45 10             	mov    0x10(%ebp),%eax
  801709:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80170c:	eb 10                	jmp    80171e <memmove+0x45>
			*--d = *--s;
  80170e:	ff 4d f8             	decl   -0x8(%ebp)
  801711:	ff 4d fc             	decl   -0x4(%ebp)
  801714:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801717:	8a 10                	mov    (%eax),%dl
  801719:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80171c:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80171e:	8b 45 10             	mov    0x10(%ebp),%eax
  801721:	8d 50 ff             	lea    -0x1(%eax),%edx
  801724:	89 55 10             	mov    %edx,0x10(%ebp)
  801727:	85 c0                	test   %eax,%eax
  801729:	75 e3                	jne    80170e <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80172b:	eb 23                	jmp    801750 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80172d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801730:	8d 50 01             	lea    0x1(%eax),%edx
  801733:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801736:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801739:	8d 4a 01             	lea    0x1(%edx),%ecx
  80173c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80173f:	8a 12                	mov    (%edx),%dl
  801741:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801743:	8b 45 10             	mov    0x10(%ebp),%eax
  801746:	8d 50 ff             	lea    -0x1(%eax),%edx
  801749:	89 55 10             	mov    %edx,0x10(%ebp)
  80174c:	85 c0                	test   %eax,%eax
  80174e:	75 dd                	jne    80172d <memmove+0x54>
			*d++ = *s++;

	return dst;
  801750:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801753:	c9                   	leave  
  801754:	c3                   	ret    

00801755 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801755:	55                   	push   %ebp
  801756:	89 e5                	mov    %esp,%ebp
  801758:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80175b:	8b 45 08             	mov    0x8(%ebp),%eax
  80175e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801761:	8b 45 0c             	mov    0xc(%ebp),%eax
  801764:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801767:	eb 2a                	jmp    801793 <memcmp+0x3e>
		if (*s1 != *s2)
  801769:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80176c:	8a 10                	mov    (%eax),%dl
  80176e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801771:	8a 00                	mov    (%eax),%al
  801773:	38 c2                	cmp    %al,%dl
  801775:	74 16                	je     80178d <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801777:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80177a:	8a 00                	mov    (%eax),%al
  80177c:	0f b6 d0             	movzbl %al,%edx
  80177f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801782:	8a 00                	mov    (%eax),%al
  801784:	0f b6 c0             	movzbl %al,%eax
  801787:	29 c2                	sub    %eax,%edx
  801789:	89 d0                	mov    %edx,%eax
  80178b:	eb 18                	jmp    8017a5 <memcmp+0x50>
		s1++, s2++;
  80178d:	ff 45 fc             	incl   -0x4(%ebp)
  801790:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801793:	8b 45 10             	mov    0x10(%ebp),%eax
  801796:	8d 50 ff             	lea    -0x1(%eax),%edx
  801799:	89 55 10             	mov    %edx,0x10(%ebp)
  80179c:	85 c0                	test   %eax,%eax
  80179e:	75 c9                	jne    801769 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8017a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017a5:	c9                   	leave  
  8017a6:	c3                   	ret    

008017a7 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8017a7:	55                   	push   %ebp
  8017a8:	89 e5                	mov    %esp,%ebp
  8017aa:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8017ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8017b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8017b3:	01 d0                	add    %edx,%eax
  8017b5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8017b8:	eb 15                	jmp    8017cf <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8017ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bd:	8a 00                	mov    (%eax),%al
  8017bf:	0f b6 d0             	movzbl %al,%edx
  8017c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017c5:	0f b6 c0             	movzbl %al,%eax
  8017c8:	39 c2                	cmp    %eax,%edx
  8017ca:	74 0d                	je     8017d9 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8017cc:	ff 45 08             	incl   0x8(%ebp)
  8017cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8017d5:	72 e3                	jb     8017ba <memfind+0x13>
  8017d7:	eb 01                	jmp    8017da <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8017d9:	90                   	nop
	return (void *) s;
  8017da:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017dd:	c9                   	leave  
  8017de:	c3                   	ret    

008017df <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8017df:	55                   	push   %ebp
  8017e0:	89 e5                	mov    %esp,%ebp
  8017e2:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8017e5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8017ec:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8017f3:	eb 03                	jmp    8017f8 <strtol+0x19>
		s++;
  8017f5:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8017f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fb:	8a 00                	mov    (%eax),%al
  8017fd:	3c 20                	cmp    $0x20,%al
  8017ff:	74 f4                	je     8017f5 <strtol+0x16>
  801801:	8b 45 08             	mov    0x8(%ebp),%eax
  801804:	8a 00                	mov    (%eax),%al
  801806:	3c 09                	cmp    $0x9,%al
  801808:	74 eb                	je     8017f5 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80180a:	8b 45 08             	mov    0x8(%ebp),%eax
  80180d:	8a 00                	mov    (%eax),%al
  80180f:	3c 2b                	cmp    $0x2b,%al
  801811:	75 05                	jne    801818 <strtol+0x39>
		s++;
  801813:	ff 45 08             	incl   0x8(%ebp)
  801816:	eb 13                	jmp    80182b <strtol+0x4c>
	else if (*s == '-')
  801818:	8b 45 08             	mov    0x8(%ebp),%eax
  80181b:	8a 00                	mov    (%eax),%al
  80181d:	3c 2d                	cmp    $0x2d,%al
  80181f:	75 0a                	jne    80182b <strtol+0x4c>
		s++, neg = 1;
  801821:	ff 45 08             	incl   0x8(%ebp)
  801824:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80182b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80182f:	74 06                	je     801837 <strtol+0x58>
  801831:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801835:	75 20                	jne    801857 <strtol+0x78>
  801837:	8b 45 08             	mov    0x8(%ebp),%eax
  80183a:	8a 00                	mov    (%eax),%al
  80183c:	3c 30                	cmp    $0x30,%al
  80183e:	75 17                	jne    801857 <strtol+0x78>
  801840:	8b 45 08             	mov    0x8(%ebp),%eax
  801843:	40                   	inc    %eax
  801844:	8a 00                	mov    (%eax),%al
  801846:	3c 78                	cmp    $0x78,%al
  801848:	75 0d                	jne    801857 <strtol+0x78>
		s += 2, base = 16;
  80184a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80184e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801855:	eb 28                	jmp    80187f <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801857:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80185b:	75 15                	jne    801872 <strtol+0x93>
  80185d:	8b 45 08             	mov    0x8(%ebp),%eax
  801860:	8a 00                	mov    (%eax),%al
  801862:	3c 30                	cmp    $0x30,%al
  801864:	75 0c                	jne    801872 <strtol+0x93>
		s++, base = 8;
  801866:	ff 45 08             	incl   0x8(%ebp)
  801869:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801870:	eb 0d                	jmp    80187f <strtol+0xa0>
	else if (base == 0)
  801872:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801876:	75 07                	jne    80187f <strtol+0xa0>
		base = 10;
  801878:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80187f:	8b 45 08             	mov    0x8(%ebp),%eax
  801882:	8a 00                	mov    (%eax),%al
  801884:	3c 2f                	cmp    $0x2f,%al
  801886:	7e 19                	jle    8018a1 <strtol+0xc2>
  801888:	8b 45 08             	mov    0x8(%ebp),%eax
  80188b:	8a 00                	mov    (%eax),%al
  80188d:	3c 39                	cmp    $0x39,%al
  80188f:	7f 10                	jg     8018a1 <strtol+0xc2>
			dig = *s - '0';
  801891:	8b 45 08             	mov    0x8(%ebp),%eax
  801894:	8a 00                	mov    (%eax),%al
  801896:	0f be c0             	movsbl %al,%eax
  801899:	83 e8 30             	sub    $0x30,%eax
  80189c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80189f:	eb 42                	jmp    8018e3 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8018a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a4:	8a 00                	mov    (%eax),%al
  8018a6:	3c 60                	cmp    $0x60,%al
  8018a8:	7e 19                	jle    8018c3 <strtol+0xe4>
  8018aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ad:	8a 00                	mov    (%eax),%al
  8018af:	3c 7a                	cmp    $0x7a,%al
  8018b1:	7f 10                	jg     8018c3 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8018b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b6:	8a 00                	mov    (%eax),%al
  8018b8:	0f be c0             	movsbl %al,%eax
  8018bb:	83 e8 57             	sub    $0x57,%eax
  8018be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8018c1:	eb 20                	jmp    8018e3 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8018c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c6:	8a 00                	mov    (%eax),%al
  8018c8:	3c 40                	cmp    $0x40,%al
  8018ca:	7e 39                	jle    801905 <strtol+0x126>
  8018cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cf:	8a 00                	mov    (%eax),%al
  8018d1:	3c 5a                	cmp    $0x5a,%al
  8018d3:	7f 30                	jg     801905 <strtol+0x126>
			dig = *s - 'A' + 10;
  8018d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d8:	8a 00                	mov    (%eax),%al
  8018da:	0f be c0             	movsbl %al,%eax
  8018dd:	83 e8 37             	sub    $0x37,%eax
  8018e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8018e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018e6:	3b 45 10             	cmp    0x10(%ebp),%eax
  8018e9:	7d 19                	jge    801904 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8018eb:	ff 45 08             	incl   0x8(%ebp)
  8018ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018f1:	0f af 45 10          	imul   0x10(%ebp),%eax
  8018f5:	89 c2                	mov    %eax,%edx
  8018f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018fa:	01 d0                	add    %edx,%eax
  8018fc:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8018ff:	e9 7b ff ff ff       	jmp    80187f <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801904:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801905:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801909:	74 08                	je     801913 <strtol+0x134>
		*endptr = (char *) s;
  80190b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80190e:	8b 55 08             	mov    0x8(%ebp),%edx
  801911:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801913:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801917:	74 07                	je     801920 <strtol+0x141>
  801919:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80191c:	f7 d8                	neg    %eax
  80191e:	eb 03                	jmp    801923 <strtol+0x144>
  801920:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801923:	c9                   	leave  
  801924:	c3                   	ret    

00801925 <ltostr>:

void
ltostr(long value, char *str)
{
  801925:	55                   	push   %ebp
  801926:	89 e5                	mov    %esp,%ebp
  801928:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80192b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801932:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801939:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80193d:	79 13                	jns    801952 <ltostr+0x2d>
	{
		neg = 1;
  80193f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801946:	8b 45 0c             	mov    0xc(%ebp),%eax
  801949:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80194c:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80194f:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801952:	8b 45 08             	mov    0x8(%ebp),%eax
  801955:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80195a:	99                   	cltd   
  80195b:	f7 f9                	idiv   %ecx
  80195d:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801960:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801963:	8d 50 01             	lea    0x1(%eax),%edx
  801966:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801969:	89 c2                	mov    %eax,%edx
  80196b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80196e:	01 d0                	add    %edx,%eax
  801970:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801973:	83 c2 30             	add    $0x30,%edx
  801976:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801978:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80197b:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801980:	f7 e9                	imul   %ecx
  801982:	c1 fa 02             	sar    $0x2,%edx
  801985:	89 c8                	mov    %ecx,%eax
  801987:	c1 f8 1f             	sar    $0x1f,%eax
  80198a:	29 c2                	sub    %eax,%edx
  80198c:	89 d0                	mov    %edx,%eax
  80198e:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801991:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801995:	75 bb                	jne    801952 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801997:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80199e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019a1:	48                   	dec    %eax
  8019a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8019a5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8019a9:	74 3d                	je     8019e8 <ltostr+0xc3>
		start = 1 ;
  8019ab:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8019b2:	eb 34                	jmp    8019e8 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8019b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019ba:	01 d0                	add    %edx,%eax
  8019bc:	8a 00                	mov    (%eax),%al
  8019be:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8019c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019c7:	01 c2                	add    %eax,%edx
  8019c9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8019cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019cf:	01 c8                	add    %ecx,%eax
  8019d1:	8a 00                	mov    (%eax),%al
  8019d3:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8019d5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019db:	01 c2                	add    %eax,%edx
  8019dd:	8a 45 eb             	mov    -0x15(%ebp),%al
  8019e0:	88 02                	mov    %al,(%edx)
		start++ ;
  8019e2:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8019e5:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8019e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019eb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8019ee:	7c c4                	jl     8019b4 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8019f0:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8019f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019f6:	01 d0                	add    %edx,%eax
  8019f8:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8019fb:	90                   	nop
  8019fc:	c9                   	leave  
  8019fd:	c3                   	ret    

008019fe <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8019fe:	55                   	push   %ebp
  8019ff:	89 e5                	mov    %esp,%ebp
  801a01:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801a04:	ff 75 08             	pushl  0x8(%ebp)
  801a07:	e8 c4 f9 ff ff       	call   8013d0 <strlen>
  801a0c:	83 c4 04             	add    $0x4,%esp
  801a0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801a12:	ff 75 0c             	pushl  0xc(%ebp)
  801a15:	e8 b6 f9 ff ff       	call   8013d0 <strlen>
  801a1a:	83 c4 04             	add    $0x4,%esp
  801a1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801a20:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801a27:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801a2e:	eb 17                	jmp    801a47 <strcconcat+0x49>
		final[s] = str1[s] ;
  801a30:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a33:	8b 45 10             	mov    0x10(%ebp),%eax
  801a36:	01 c2                	add    %eax,%edx
  801a38:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3e:	01 c8                	add    %ecx,%eax
  801a40:	8a 00                	mov    (%eax),%al
  801a42:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801a44:	ff 45 fc             	incl   -0x4(%ebp)
  801a47:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a4a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801a4d:	7c e1                	jl     801a30 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801a4f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801a56:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801a5d:	eb 1f                	jmp    801a7e <strcconcat+0x80>
		final[s++] = str2[i] ;
  801a5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a62:	8d 50 01             	lea    0x1(%eax),%edx
  801a65:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801a68:	89 c2                	mov    %eax,%edx
  801a6a:	8b 45 10             	mov    0x10(%ebp),%eax
  801a6d:	01 c2                	add    %eax,%edx
  801a6f:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801a72:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a75:	01 c8                	add    %ecx,%eax
  801a77:	8a 00                	mov    (%eax),%al
  801a79:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801a7b:	ff 45 f8             	incl   -0x8(%ebp)
  801a7e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a81:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a84:	7c d9                	jl     801a5f <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801a86:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a89:	8b 45 10             	mov    0x10(%ebp),%eax
  801a8c:	01 d0                	add    %edx,%eax
  801a8e:	c6 00 00             	movb   $0x0,(%eax)
}
  801a91:	90                   	nop
  801a92:	c9                   	leave  
  801a93:	c3                   	ret    

00801a94 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801a94:	55                   	push   %ebp
  801a95:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801a97:	8b 45 14             	mov    0x14(%ebp),%eax
  801a9a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801aa0:	8b 45 14             	mov    0x14(%ebp),%eax
  801aa3:	8b 00                	mov    (%eax),%eax
  801aa5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801aac:	8b 45 10             	mov    0x10(%ebp),%eax
  801aaf:	01 d0                	add    %edx,%eax
  801ab1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801ab7:	eb 0c                	jmp    801ac5 <strsplit+0x31>
			*string++ = 0;
  801ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  801abc:	8d 50 01             	lea    0x1(%eax),%edx
  801abf:	89 55 08             	mov    %edx,0x8(%ebp)
  801ac2:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801ac5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac8:	8a 00                	mov    (%eax),%al
  801aca:	84 c0                	test   %al,%al
  801acc:	74 18                	je     801ae6 <strsplit+0x52>
  801ace:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad1:	8a 00                	mov    (%eax),%al
  801ad3:	0f be c0             	movsbl %al,%eax
  801ad6:	50                   	push   %eax
  801ad7:	ff 75 0c             	pushl  0xc(%ebp)
  801ada:	e8 83 fa ff ff       	call   801562 <strchr>
  801adf:	83 c4 08             	add    $0x8,%esp
  801ae2:	85 c0                	test   %eax,%eax
  801ae4:	75 d3                	jne    801ab9 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae9:	8a 00                	mov    (%eax),%al
  801aeb:	84 c0                	test   %al,%al
  801aed:	74 5a                	je     801b49 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801aef:	8b 45 14             	mov    0x14(%ebp),%eax
  801af2:	8b 00                	mov    (%eax),%eax
  801af4:	83 f8 0f             	cmp    $0xf,%eax
  801af7:	75 07                	jne    801b00 <strsplit+0x6c>
		{
			return 0;
  801af9:	b8 00 00 00 00       	mov    $0x0,%eax
  801afe:	eb 66                	jmp    801b66 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801b00:	8b 45 14             	mov    0x14(%ebp),%eax
  801b03:	8b 00                	mov    (%eax),%eax
  801b05:	8d 48 01             	lea    0x1(%eax),%ecx
  801b08:	8b 55 14             	mov    0x14(%ebp),%edx
  801b0b:	89 0a                	mov    %ecx,(%edx)
  801b0d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b14:	8b 45 10             	mov    0x10(%ebp),%eax
  801b17:	01 c2                	add    %eax,%edx
  801b19:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1c:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801b1e:	eb 03                	jmp    801b23 <strsplit+0x8f>
			string++;
  801b20:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801b23:	8b 45 08             	mov    0x8(%ebp),%eax
  801b26:	8a 00                	mov    (%eax),%al
  801b28:	84 c0                	test   %al,%al
  801b2a:	74 8b                	je     801ab7 <strsplit+0x23>
  801b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2f:	8a 00                	mov    (%eax),%al
  801b31:	0f be c0             	movsbl %al,%eax
  801b34:	50                   	push   %eax
  801b35:	ff 75 0c             	pushl  0xc(%ebp)
  801b38:	e8 25 fa ff ff       	call   801562 <strchr>
  801b3d:	83 c4 08             	add    $0x8,%esp
  801b40:	85 c0                	test   %eax,%eax
  801b42:	74 dc                	je     801b20 <strsplit+0x8c>
			string++;
	}
  801b44:	e9 6e ff ff ff       	jmp    801ab7 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801b49:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801b4a:	8b 45 14             	mov    0x14(%ebp),%eax
  801b4d:	8b 00                	mov    (%eax),%eax
  801b4f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b56:	8b 45 10             	mov    0x10(%ebp),%eax
  801b59:	01 d0                	add    %edx,%eax
  801b5b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801b61:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801b66:	c9                   	leave  
  801b67:	c3                   	ret    

00801b68 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801b68:	55                   	push   %ebp
  801b69:	89 e5                	mov    %esp,%ebp
  801b6b:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b71:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801b74:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801b7b:	eb 4a                	jmp    801bc7 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801b7d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b80:	8b 45 08             	mov    0x8(%ebp),%eax
  801b83:	01 c2                	add    %eax,%edx
  801b85:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801b88:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b8b:	01 c8                	add    %ecx,%eax
  801b8d:	8a 00                	mov    (%eax),%al
  801b8f:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801b91:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b94:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b97:	01 d0                	add    %edx,%eax
  801b99:	8a 00                	mov    (%eax),%al
  801b9b:	3c 40                	cmp    $0x40,%al
  801b9d:	7e 25                	jle    801bc4 <str2lower+0x5c>
  801b9f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ba2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ba5:	01 d0                	add    %edx,%eax
  801ba7:	8a 00                	mov    (%eax),%al
  801ba9:	3c 5a                	cmp    $0x5a,%al
  801bab:	7f 17                	jg     801bc4 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801bad:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb3:	01 d0                	add    %edx,%eax
  801bb5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801bb8:	8b 55 08             	mov    0x8(%ebp),%edx
  801bbb:	01 ca                	add    %ecx,%edx
  801bbd:	8a 12                	mov    (%edx),%dl
  801bbf:	83 c2 20             	add    $0x20,%edx
  801bc2:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801bc4:	ff 45 fc             	incl   -0x4(%ebp)
  801bc7:	ff 75 0c             	pushl  0xc(%ebp)
  801bca:	e8 01 f8 ff ff       	call   8013d0 <strlen>
  801bcf:	83 c4 04             	add    $0x4,%esp
  801bd2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801bd5:	7f a6                	jg     801b7d <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801bd7:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801bda:	c9                   	leave  
  801bdb:	c3                   	ret    

00801bdc <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801bdc:	55                   	push   %ebp
  801bdd:	89 e5                	mov    %esp,%ebp
  801bdf:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801be2:	a1 08 40 80 00       	mov    0x804008,%eax
  801be7:	85 c0                	test   %eax,%eax
  801be9:	74 42                	je     801c2d <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801beb:	83 ec 08             	sub    $0x8,%esp
  801bee:	68 00 00 00 82       	push   $0x82000000
  801bf3:	68 00 00 00 80       	push   $0x80000000
  801bf8:	e8 8c 07 00 00       	call   802389 <initialize_dynamic_allocator>
  801bfd:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801c00:	e8 e7 05 00 00       	call   8021ec <sys_get_uheap_strategy>
  801c05:	a3 64 c0 81 00       	mov    %eax,0x81c064
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801c0a:	a1 40 40 80 00       	mov    0x804040,%eax
  801c0f:	05 00 10 00 00       	add    $0x1000,%eax
  801c14:	a3 10 c1 81 00       	mov    %eax,0x81c110
		uheapPageAllocBreak = uheapPageAllocStart;
  801c19:	a1 10 c1 81 00       	mov    0x81c110,%eax
  801c1e:	a3 6c c0 81 00       	mov    %eax,0x81c06c

		__firstTimeFlag = 0;
  801c23:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  801c2a:	00 00 00 
	}
}
  801c2d:	90                   	nop
  801c2e:	c9                   	leave  
  801c2f:	c3                   	ret    

00801c30 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801c30:	55                   	push   %ebp
  801c31:	89 e5                	mov    %esp,%ebp
  801c33:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801c36:	8b 45 08             	mov    0x8(%ebp),%eax
  801c39:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c3f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801c44:	83 ec 08             	sub    $0x8,%esp
  801c47:	68 06 04 00 00       	push   $0x406
  801c4c:	50                   	push   %eax
  801c4d:	e8 e4 01 00 00       	call   801e36 <__sys_allocate_page>
  801c52:	83 c4 10             	add    $0x10,%esp
  801c55:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801c58:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801c5c:	79 14                	jns    801c72 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801c5e:	83 ec 04             	sub    $0x4,%esp
  801c61:	68 5c 2f 80 00       	push   $0x802f5c
  801c66:	6a 1f                	push   $0x1f
  801c68:	68 98 2f 80 00       	push   $0x802f98
  801c6d:	e8 af eb ff ff       	call   800821 <_panic>
	return 0;
  801c72:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c77:	c9                   	leave  
  801c78:	c3                   	ret    

00801c79 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801c79:	55                   	push   %ebp
  801c7a:	89 e5                	mov    %esp,%ebp
  801c7c:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c82:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c88:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801c8d:	83 ec 0c             	sub    $0xc,%esp
  801c90:	50                   	push   %eax
  801c91:	e8 e7 01 00 00       	call   801e7d <__sys_unmap_frame>
  801c96:	83 c4 10             	add    $0x10,%esp
  801c99:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801c9c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ca0:	79 14                	jns    801cb6 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801ca2:	83 ec 04             	sub    $0x4,%esp
  801ca5:	68 a4 2f 80 00       	push   $0x802fa4
  801caa:	6a 2a                	push   $0x2a
  801cac:	68 98 2f 80 00       	push   $0x802f98
  801cb1:	e8 6b eb ff ff       	call   800821 <_panic>
}
  801cb6:	90                   	nop
  801cb7:	c9                   	leave  
  801cb8:	c3                   	ret    

00801cb9 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801cb9:	55                   	push   %ebp
  801cba:	89 e5                	mov    %esp,%ebp
  801cbc:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801cbf:	e8 18 ff ff ff       	call   801bdc <uheap_init>
	if (size == 0) return NULL ;
  801cc4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801cc8:	75 07                	jne    801cd1 <malloc+0x18>
  801cca:	b8 00 00 00 00       	mov    $0x0,%eax
  801ccf:	eb 14                	jmp    801ce5 <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  801cd1:	83 ec 04             	sub    $0x4,%esp
  801cd4:	68 e4 2f 80 00       	push   $0x802fe4
  801cd9:	6a 3e                	push   $0x3e
  801cdb:	68 98 2f 80 00       	push   $0x802f98
  801ce0:	e8 3c eb ff ff       	call   800821 <_panic>
}
  801ce5:	c9                   	leave  
  801ce6:	c3                   	ret    

00801ce7 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801ce7:	55                   	push   %ebp
  801ce8:	89 e5                	mov    %esp,%ebp
  801cea:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  801ced:	83 ec 04             	sub    $0x4,%esp
  801cf0:	68 0c 30 80 00       	push   $0x80300c
  801cf5:	6a 49                	push   $0x49
  801cf7:	68 98 2f 80 00       	push   $0x802f98
  801cfc:	e8 20 eb ff ff       	call   800821 <_panic>

00801d01 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801d01:	55                   	push   %ebp
  801d02:	89 e5                	mov    %esp,%ebp
  801d04:	83 ec 18             	sub    $0x18,%esp
  801d07:	8b 45 10             	mov    0x10(%ebp),%eax
  801d0a:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801d0d:	e8 ca fe ff ff       	call   801bdc <uheap_init>
	if (size == 0) return NULL ;
  801d12:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d16:	75 07                	jne    801d1f <smalloc+0x1e>
  801d18:	b8 00 00 00 00       	mov    $0x0,%eax
  801d1d:	eb 14                	jmp    801d33 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  801d1f:	83 ec 04             	sub    $0x4,%esp
  801d22:	68 30 30 80 00       	push   $0x803030
  801d27:	6a 5a                	push   $0x5a
  801d29:	68 98 2f 80 00       	push   $0x802f98
  801d2e:	e8 ee ea ff ff       	call   800821 <_panic>
}
  801d33:	c9                   	leave  
  801d34:	c3                   	ret    

00801d35 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801d35:	55                   	push   %ebp
  801d36:	89 e5                	mov    %esp,%ebp
  801d38:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801d3b:	e8 9c fe ff ff       	call   801bdc <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  801d40:	83 ec 04             	sub    $0x4,%esp
  801d43:	68 58 30 80 00       	push   $0x803058
  801d48:	6a 6a                	push   $0x6a
  801d4a:	68 98 2f 80 00       	push   $0x802f98
  801d4f:	e8 cd ea ff ff       	call   800821 <_panic>

00801d54 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801d54:	55                   	push   %ebp
  801d55:	89 e5                	mov    %esp,%ebp
  801d57:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801d5a:	e8 7d fe ff ff       	call   801bdc <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  801d5f:	83 ec 04             	sub    $0x4,%esp
  801d62:	68 7c 30 80 00       	push   $0x80307c
  801d67:	68 88 00 00 00       	push   $0x88
  801d6c:	68 98 2f 80 00       	push   $0x802f98
  801d71:	e8 ab ea ff ff       	call   800821 <_panic>

00801d76 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  801d76:	55                   	push   %ebp
  801d77:	89 e5                	mov    %esp,%ebp
  801d79:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  801d7c:	83 ec 04             	sub    $0x4,%esp
  801d7f:	68 a4 30 80 00       	push   $0x8030a4
  801d84:	68 9b 00 00 00       	push   $0x9b
  801d89:	68 98 2f 80 00       	push   $0x802f98
  801d8e:	e8 8e ea ff ff       	call   800821 <_panic>

00801d93 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801d93:	55                   	push   %ebp
  801d94:	89 e5                	mov    %esp,%ebp
  801d96:	57                   	push   %edi
  801d97:	56                   	push   %esi
  801d98:	53                   	push   %ebx
  801d99:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801da2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801da5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801da8:	8b 7d 18             	mov    0x18(%ebp),%edi
  801dab:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801dae:	cd 30                	int    $0x30
  801db0:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801db3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801db6:	83 c4 10             	add    $0x10,%esp
  801db9:	5b                   	pop    %ebx
  801dba:	5e                   	pop    %esi
  801dbb:	5f                   	pop    %edi
  801dbc:	5d                   	pop    %ebp
  801dbd:	c3                   	ret    

00801dbe <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801dbe:	55                   	push   %ebp
  801dbf:	89 e5                	mov    %esp,%ebp
  801dc1:	83 ec 04             	sub    $0x4,%esp
  801dc4:	8b 45 10             	mov    0x10(%ebp),%eax
  801dc7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801dca:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801dcd:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd4:	6a 00                	push   $0x0
  801dd6:	51                   	push   %ecx
  801dd7:	52                   	push   %edx
  801dd8:	ff 75 0c             	pushl  0xc(%ebp)
  801ddb:	50                   	push   %eax
  801ddc:	6a 00                	push   $0x0
  801dde:	e8 b0 ff ff ff       	call   801d93 <syscall>
  801de3:	83 c4 18             	add    $0x18,%esp
}
  801de6:	90                   	nop
  801de7:	c9                   	leave  
  801de8:	c3                   	ret    

00801de9 <sys_cgetc>:

int
sys_cgetc(void)
{
  801de9:	55                   	push   %ebp
  801dea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801dec:	6a 00                	push   $0x0
  801dee:	6a 00                	push   $0x0
  801df0:	6a 00                	push   $0x0
  801df2:	6a 00                	push   $0x0
  801df4:	6a 00                	push   $0x0
  801df6:	6a 02                	push   $0x2
  801df8:	e8 96 ff ff ff       	call   801d93 <syscall>
  801dfd:	83 c4 18             	add    $0x18,%esp
}
  801e00:	c9                   	leave  
  801e01:	c3                   	ret    

00801e02 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801e02:	55                   	push   %ebp
  801e03:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801e05:	6a 00                	push   $0x0
  801e07:	6a 00                	push   $0x0
  801e09:	6a 00                	push   $0x0
  801e0b:	6a 00                	push   $0x0
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 03                	push   $0x3
  801e11:	e8 7d ff ff ff       	call   801d93 <syscall>
  801e16:	83 c4 18             	add    $0x18,%esp
}
  801e19:	90                   	nop
  801e1a:	c9                   	leave  
  801e1b:	c3                   	ret    

00801e1c <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801e1c:	55                   	push   %ebp
  801e1d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801e1f:	6a 00                	push   $0x0
  801e21:	6a 00                	push   $0x0
  801e23:	6a 00                	push   $0x0
  801e25:	6a 00                	push   $0x0
  801e27:	6a 00                	push   $0x0
  801e29:	6a 04                	push   $0x4
  801e2b:	e8 63 ff ff ff       	call   801d93 <syscall>
  801e30:	83 c4 18             	add    $0x18,%esp
}
  801e33:	90                   	nop
  801e34:	c9                   	leave  
  801e35:	c3                   	ret    

00801e36 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801e36:	55                   	push   %ebp
  801e37:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801e39:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3f:	6a 00                	push   $0x0
  801e41:	6a 00                	push   $0x0
  801e43:	6a 00                	push   $0x0
  801e45:	52                   	push   %edx
  801e46:	50                   	push   %eax
  801e47:	6a 08                	push   $0x8
  801e49:	e8 45 ff ff ff       	call   801d93 <syscall>
  801e4e:	83 c4 18             	add    $0x18,%esp
}
  801e51:	c9                   	leave  
  801e52:	c3                   	ret    

00801e53 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801e53:	55                   	push   %ebp
  801e54:	89 e5                	mov    %esp,%ebp
  801e56:	56                   	push   %esi
  801e57:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801e58:	8b 75 18             	mov    0x18(%ebp),%esi
  801e5b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e5e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e61:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e64:	8b 45 08             	mov    0x8(%ebp),%eax
  801e67:	56                   	push   %esi
  801e68:	53                   	push   %ebx
  801e69:	51                   	push   %ecx
  801e6a:	52                   	push   %edx
  801e6b:	50                   	push   %eax
  801e6c:	6a 09                	push   $0x9
  801e6e:	e8 20 ff ff ff       	call   801d93 <syscall>
  801e73:	83 c4 18             	add    $0x18,%esp
}
  801e76:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e79:	5b                   	pop    %ebx
  801e7a:	5e                   	pop    %esi
  801e7b:	5d                   	pop    %ebp
  801e7c:	c3                   	ret    

00801e7d <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801e7d:	55                   	push   %ebp
  801e7e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801e80:	6a 00                	push   $0x0
  801e82:	6a 00                	push   $0x0
  801e84:	6a 00                	push   $0x0
  801e86:	6a 00                	push   $0x0
  801e88:	ff 75 08             	pushl  0x8(%ebp)
  801e8b:	6a 0a                	push   $0xa
  801e8d:	e8 01 ff ff ff       	call   801d93 <syscall>
  801e92:	83 c4 18             	add    $0x18,%esp
}
  801e95:	c9                   	leave  
  801e96:	c3                   	ret    

00801e97 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801e97:	55                   	push   %ebp
  801e98:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801e9a:	6a 00                	push   $0x0
  801e9c:	6a 00                	push   $0x0
  801e9e:	6a 00                	push   $0x0
  801ea0:	ff 75 0c             	pushl  0xc(%ebp)
  801ea3:	ff 75 08             	pushl  0x8(%ebp)
  801ea6:	6a 0b                	push   $0xb
  801ea8:	e8 e6 fe ff ff       	call   801d93 <syscall>
  801ead:	83 c4 18             	add    $0x18,%esp
}
  801eb0:	c9                   	leave  
  801eb1:	c3                   	ret    

00801eb2 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801eb2:	55                   	push   %ebp
  801eb3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801eb5:	6a 00                	push   $0x0
  801eb7:	6a 00                	push   $0x0
  801eb9:	6a 00                	push   $0x0
  801ebb:	6a 00                	push   $0x0
  801ebd:	6a 00                	push   $0x0
  801ebf:	6a 0c                	push   $0xc
  801ec1:	e8 cd fe ff ff       	call   801d93 <syscall>
  801ec6:	83 c4 18             	add    $0x18,%esp
}
  801ec9:	c9                   	leave  
  801eca:	c3                   	ret    

00801ecb <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801ecb:	55                   	push   %ebp
  801ecc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801ece:	6a 00                	push   $0x0
  801ed0:	6a 00                	push   $0x0
  801ed2:	6a 00                	push   $0x0
  801ed4:	6a 00                	push   $0x0
  801ed6:	6a 00                	push   $0x0
  801ed8:	6a 0d                	push   $0xd
  801eda:	e8 b4 fe ff ff       	call   801d93 <syscall>
  801edf:	83 c4 18             	add    $0x18,%esp
}
  801ee2:	c9                   	leave  
  801ee3:	c3                   	ret    

00801ee4 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801ee4:	55                   	push   %ebp
  801ee5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801ee7:	6a 00                	push   $0x0
  801ee9:	6a 00                	push   $0x0
  801eeb:	6a 00                	push   $0x0
  801eed:	6a 00                	push   $0x0
  801eef:	6a 00                	push   $0x0
  801ef1:	6a 0e                	push   $0xe
  801ef3:	e8 9b fe ff ff       	call   801d93 <syscall>
  801ef8:	83 c4 18             	add    $0x18,%esp
}
  801efb:	c9                   	leave  
  801efc:	c3                   	ret    

00801efd <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801efd:	55                   	push   %ebp
  801efe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801f00:	6a 00                	push   $0x0
  801f02:	6a 00                	push   $0x0
  801f04:	6a 00                	push   $0x0
  801f06:	6a 00                	push   $0x0
  801f08:	6a 00                	push   $0x0
  801f0a:	6a 0f                	push   $0xf
  801f0c:	e8 82 fe ff ff       	call   801d93 <syscall>
  801f11:	83 c4 18             	add    $0x18,%esp
}
  801f14:	c9                   	leave  
  801f15:	c3                   	ret    

00801f16 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801f16:	55                   	push   %ebp
  801f17:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801f19:	6a 00                	push   $0x0
  801f1b:	6a 00                	push   $0x0
  801f1d:	6a 00                	push   $0x0
  801f1f:	6a 00                	push   $0x0
  801f21:	ff 75 08             	pushl  0x8(%ebp)
  801f24:	6a 10                	push   $0x10
  801f26:	e8 68 fe ff ff       	call   801d93 <syscall>
  801f2b:	83 c4 18             	add    $0x18,%esp
}
  801f2e:	c9                   	leave  
  801f2f:	c3                   	ret    

00801f30 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801f30:	55                   	push   %ebp
  801f31:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801f33:	6a 00                	push   $0x0
  801f35:	6a 00                	push   $0x0
  801f37:	6a 00                	push   $0x0
  801f39:	6a 00                	push   $0x0
  801f3b:	6a 00                	push   $0x0
  801f3d:	6a 11                	push   $0x11
  801f3f:	e8 4f fe ff ff       	call   801d93 <syscall>
  801f44:	83 c4 18             	add    $0x18,%esp
}
  801f47:	90                   	nop
  801f48:	c9                   	leave  
  801f49:	c3                   	ret    

00801f4a <sys_cputc>:

void
sys_cputc(const char c)
{
  801f4a:	55                   	push   %ebp
  801f4b:	89 e5                	mov    %esp,%ebp
  801f4d:	83 ec 04             	sub    $0x4,%esp
  801f50:	8b 45 08             	mov    0x8(%ebp),%eax
  801f53:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801f56:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f5a:	6a 00                	push   $0x0
  801f5c:	6a 00                	push   $0x0
  801f5e:	6a 00                	push   $0x0
  801f60:	6a 00                	push   $0x0
  801f62:	50                   	push   %eax
  801f63:	6a 01                	push   $0x1
  801f65:	e8 29 fe ff ff       	call   801d93 <syscall>
  801f6a:	83 c4 18             	add    $0x18,%esp
}
  801f6d:	90                   	nop
  801f6e:	c9                   	leave  
  801f6f:	c3                   	ret    

00801f70 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801f70:	55                   	push   %ebp
  801f71:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801f73:	6a 00                	push   $0x0
  801f75:	6a 00                	push   $0x0
  801f77:	6a 00                	push   $0x0
  801f79:	6a 00                	push   $0x0
  801f7b:	6a 00                	push   $0x0
  801f7d:	6a 14                	push   $0x14
  801f7f:	e8 0f fe ff ff       	call   801d93 <syscall>
  801f84:	83 c4 18             	add    $0x18,%esp
}
  801f87:	90                   	nop
  801f88:	c9                   	leave  
  801f89:	c3                   	ret    

00801f8a <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801f8a:	55                   	push   %ebp
  801f8b:	89 e5                	mov    %esp,%ebp
  801f8d:	83 ec 04             	sub    $0x4,%esp
  801f90:	8b 45 10             	mov    0x10(%ebp),%eax
  801f93:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801f96:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801f99:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa0:	6a 00                	push   $0x0
  801fa2:	51                   	push   %ecx
  801fa3:	52                   	push   %edx
  801fa4:	ff 75 0c             	pushl  0xc(%ebp)
  801fa7:	50                   	push   %eax
  801fa8:	6a 15                	push   $0x15
  801faa:	e8 e4 fd ff ff       	call   801d93 <syscall>
  801faf:	83 c4 18             	add    $0x18,%esp
}
  801fb2:	c9                   	leave  
  801fb3:	c3                   	ret    

00801fb4 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801fb4:	55                   	push   %ebp
  801fb5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801fb7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fba:	8b 45 08             	mov    0x8(%ebp),%eax
  801fbd:	6a 00                	push   $0x0
  801fbf:	6a 00                	push   $0x0
  801fc1:	6a 00                	push   $0x0
  801fc3:	52                   	push   %edx
  801fc4:	50                   	push   %eax
  801fc5:	6a 16                	push   $0x16
  801fc7:	e8 c7 fd ff ff       	call   801d93 <syscall>
  801fcc:	83 c4 18             	add    $0x18,%esp
}
  801fcf:	c9                   	leave  
  801fd0:	c3                   	ret    

00801fd1 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801fd1:	55                   	push   %ebp
  801fd2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801fd4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fd7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fda:	8b 45 08             	mov    0x8(%ebp),%eax
  801fdd:	6a 00                	push   $0x0
  801fdf:	6a 00                	push   $0x0
  801fe1:	51                   	push   %ecx
  801fe2:	52                   	push   %edx
  801fe3:	50                   	push   %eax
  801fe4:	6a 17                	push   $0x17
  801fe6:	e8 a8 fd ff ff       	call   801d93 <syscall>
  801feb:	83 c4 18             	add    $0x18,%esp
}
  801fee:	c9                   	leave  
  801fef:	c3                   	ret    

00801ff0 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801ff0:	55                   	push   %ebp
  801ff1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801ff3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ff6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff9:	6a 00                	push   $0x0
  801ffb:	6a 00                	push   $0x0
  801ffd:	6a 00                	push   $0x0
  801fff:	52                   	push   %edx
  802000:	50                   	push   %eax
  802001:	6a 18                	push   $0x18
  802003:	e8 8b fd ff ff       	call   801d93 <syscall>
  802008:	83 c4 18             	add    $0x18,%esp
}
  80200b:	c9                   	leave  
  80200c:	c3                   	ret    

0080200d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80200d:	55                   	push   %ebp
  80200e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802010:	8b 45 08             	mov    0x8(%ebp),%eax
  802013:	6a 00                	push   $0x0
  802015:	ff 75 14             	pushl  0x14(%ebp)
  802018:	ff 75 10             	pushl  0x10(%ebp)
  80201b:	ff 75 0c             	pushl  0xc(%ebp)
  80201e:	50                   	push   %eax
  80201f:	6a 19                	push   $0x19
  802021:	e8 6d fd ff ff       	call   801d93 <syscall>
  802026:	83 c4 18             	add    $0x18,%esp
}
  802029:	c9                   	leave  
  80202a:	c3                   	ret    

0080202b <sys_run_env>:

void sys_run_env(int32 envId)
{
  80202b:	55                   	push   %ebp
  80202c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80202e:	8b 45 08             	mov    0x8(%ebp),%eax
  802031:	6a 00                	push   $0x0
  802033:	6a 00                	push   $0x0
  802035:	6a 00                	push   $0x0
  802037:	6a 00                	push   $0x0
  802039:	50                   	push   %eax
  80203a:	6a 1a                	push   $0x1a
  80203c:	e8 52 fd ff ff       	call   801d93 <syscall>
  802041:	83 c4 18             	add    $0x18,%esp
}
  802044:	90                   	nop
  802045:	c9                   	leave  
  802046:	c3                   	ret    

00802047 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802047:	55                   	push   %ebp
  802048:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80204a:	8b 45 08             	mov    0x8(%ebp),%eax
  80204d:	6a 00                	push   $0x0
  80204f:	6a 00                	push   $0x0
  802051:	6a 00                	push   $0x0
  802053:	6a 00                	push   $0x0
  802055:	50                   	push   %eax
  802056:	6a 1b                	push   $0x1b
  802058:	e8 36 fd ff ff       	call   801d93 <syscall>
  80205d:	83 c4 18             	add    $0x18,%esp
}
  802060:	c9                   	leave  
  802061:	c3                   	ret    

00802062 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802062:	55                   	push   %ebp
  802063:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802065:	6a 00                	push   $0x0
  802067:	6a 00                	push   $0x0
  802069:	6a 00                	push   $0x0
  80206b:	6a 00                	push   $0x0
  80206d:	6a 00                	push   $0x0
  80206f:	6a 05                	push   $0x5
  802071:	e8 1d fd ff ff       	call   801d93 <syscall>
  802076:	83 c4 18             	add    $0x18,%esp
}
  802079:	c9                   	leave  
  80207a:	c3                   	ret    

0080207b <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80207b:	55                   	push   %ebp
  80207c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80207e:	6a 00                	push   $0x0
  802080:	6a 00                	push   $0x0
  802082:	6a 00                	push   $0x0
  802084:	6a 00                	push   $0x0
  802086:	6a 00                	push   $0x0
  802088:	6a 06                	push   $0x6
  80208a:	e8 04 fd ff ff       	call   801d93 <syscall>
  80208f:	83 c4 18             	add    $0x18,%esp
}
  802092:	c9                   	leave  
  802093:	c3                   	ret    

00802094 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802094:	55                   	push   %ebp
  802095:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802097:	6a 00                	push   $0x0
  802099:	6a 00                	push   $0x0
  80209b:	6a 00                	push   $0x0
  80209d:	6a 00                	push   $0x0
  80209f:	6a 00                	push   $0x0
  8020a1:	6a 07                	push   $0x7
  8020a3:	e8 eb fc ff ff       	call   801d93 <syscall>
  8020a8:	83 c4 18             	add    $0x18,%esp
}
  8020ab:	c9                   	leave  
  8020ac:	c3                   	ret    

008020ad <sys_exit_env>:


void sys_exit_env(void)
{
  8020ad:	55                   	push   %ebp
  8020ae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8020b0:	6a 00                	push   $0x0
  8020b2:	6a 00                	push   $0x0
  8020b4:	6a 00                	push   $0x0
  8020b6:	6a 00                	push   $0x0
  8020b8:	6a 00                	push   $0x0
  8020ba:	6a 1c                	push   $0x1c
  8020bc:	e8 d2 fc ff ff       	call   801d93 <syscall>
  8020c1:	83 c4 18             	add    $0x18,%esp
}
  8020c4:	90                   	nop
  8020c5:	c9                   	leave  
  8020c6:	c3                   	ret    

008020c7 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8020c7:	55                   	push   %ebp
  8020c8:	89 e5                	mov    %esp,%ebp
  8020ca:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8020cd:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8020d0:	8d 50 04             	lea    0x4(%eax),%edx
  8020d3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8020d6:	6a 00                	push   $0x0
  8020d8:	6a 00                	push   $0x0
  8020da:	6a 00                	push   $0x0
  8020dc:	52                   	push   %edx
  8020dd:	50                   	push   %eax
  8020de:	6a 1d                	push   $0x1d
  8020e0:	e8 ae fc ff ff       	call   801d93 <syscall>
  8020e5:	83 c4 18             	add    $0x18,%esp
	return result;
  8020e8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8020ee:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8020f1:	89 01                	mov    %eax,(%ecx)
  8020f3:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8020f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f9:	c9                   	leave  
  8020fa:	c2 04 00             	ret    $0x4

008020fd <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8020fd:	55                   	push   %ebp
  8020fe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802100:	6a 00                	push   $0x0
  802102:	6a 00                	push   $0x0
  802104:	ff 75 10             	pushl  0x10(%ebp)
  802107:	ff 75 0c             	pushl  0xc(%ebp)
  80210a:	ff 75 08             	pushl  0x8(%ebp)
  80210d:	6a 13                	push   $0x13
  80210f:	e8 7f fc ff ff       	call   801d93 <syscall>
  802114:	83 c4 18             	add    $0x18,%esp
	return ;
  802117:	90                   	nop
}
  802118:	c9                   	leave  
  802119:	c3                   	ret    

0080211a <sys_rcr2>:
uint32 sys_rcr2()
{
  80211a:	55                   	push   %ebp
  80211b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80211d:	6a 00                	push   $0x0
  80211f:	6a 00                	push   $0x0
  802121:	6a 00                	push   $0x0
  802123:	6a 00                	push   $0x0
  802125:	6a 00                	push   $0x0
  802127:	6a 1e                	push   $0x1e
  802129:	e8 65 fc ff ff       	call   801d93 <syscall>
  80212e:	83 c4 18             	add    $0x18,%esp
}
  802131:	c9                   	leave  
  802132:	c3                   	ret    

00802133 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802133:	55                   	push   %ebp
  802134:	89 e5                	mov    %esp,%ebp
  802136:	83 ec 04             	sub    $0x4,%esp
  802139:	8b 45 08             	mov    0x8(%ebp),%eax
  80213c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80213f:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802143:	6a 00                	push   $0x0
  802145:	6a 00                	push   $0x0
  802147:	6a 00                	push   $0x0
  802149:	6a 00                	push   $0x0
  80214b:	50                   	push   %eax
  80214c:	6a 1f                	push   $0x1f
  80214e:	e8 40 fc ff ff       	call   801d93 <syscall>
  802153:	83 c4 18             	add    $0x18,%esp
	return ;
  802156:	90                   	nop
}
  802157:	c9                   	leave  
  802158:	c3                   	ret    

00802159 <rsttst>:
void rsttst()
{
  802159:	55                   	push   %ebp
  80215a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80215c:	6a 00                	push   $0x0
  80215e:	6a 00                	push   $0x0
  802160:	6a 00                	push   $0x0
  802162:	6a 00                	push   $0x0
  802164:	6a 00                	push   $0x0
  802166:	6a 21                	push   $0x21
  802168:	e8 26 fc ff ff       	call   801d93 <syscall>
  80216d:	83 c4 18             	add    $0x18,%esp
	return ;
  802170:	90                   	nop
}
  802171:	c9                   	leave  
  802172:	c3                   	ret    

00802173 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802173:	55                   	push   %ebp
  802174:	89 e5                	mov    %esp,%ebp
  802176:	83 ec 04             	sub    $0x4,%esp
  802179:	8b 45 14             	mov    0x14(%ebp),%eax
  80217c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80217f:	8b 55 18             	mov    0x18(%ebp),%edx
  802182:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802186:	52                   	push   %edx
  802187:	50                   	push   %eax
  802188:	ff 75 10             	pushl  0x10(%ebp)
  80218b:	ff 75 0c             	pushl  0xc(%ebp)
  80218e:	ff 75 08             	pushl  0x8(%ebp)
  802191:	6a 20                	push   $0x20
  802193:	e8 fb fb ff ff       	call   801d93 <syscall>
  802198:	83 c4 18             	add    $0x18,%esp
	return ;
  80219b:	90                   	nop
}
  80219c:	c9                   	leave  
  80219d:	c3                   	ret    

0080219e <chktst>:
void chktst(uint32 n)
{
  80219e:	55                   	push   %ebp
  80219f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8021a1:	6a 00                	push   $0x0
  8021a3:	6a 00                	push   $0x0
  8021a5:	6a 00                	push   $0x0
  8021a7:	6a 00                	push   $0x0
  8021a9:	ff 75 08             	pushl  0x8(%ebp)
  8021ac:	6a 22                	push   $0x22
  8021ae:	e8 e0 fb ff ff       	call   801d93 <syscall>
  8021b3:	83 c4 18             	add    $0x18,%esp
	return ;
  8021b6:	90                   	nop
}
  8021b7:	c9                   	leave  
  8021b8:	c3                   	ret    

008021b9 <inctst>:

void inctst()
{
  8021b9:	55                   	push   %ebp
  8021ba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8021bc:	6a 00                	push   $0x0
  8021be:	6a 00                	push   $0x0
  8021c0:	6a 00                	push   $0x0
  8021c2:	6a 00                	push   $0x0
  8021c4:	6a 00                	push   $0x0
  8021c6:	6a 23                	push   $0x23
  8021c8:	e8 c6 fb ff ff       	call   801d93 <syscall>
  8021cd:	83 c4 18             	add    $0x18,%esp
	return ;
  8021d0:	90                   	nop
}
  8021d1:	c9                   	leave  
  8021d2:	c3                   	ret    

008021d3 <gettst>:
uint32 gettst()
{
  8021d3:	55                   	push   %ebp
  8021d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8021d6:	6a 00                	push   $0x0
  8021d8:	6a 00                	push   $0x0
  8021da:	6a 00                	push   $0x0
  8021dc:	6a 00                	push   $0x0
  8021de:	6a 00                	push   $0x0
  8021e0:	6a 24                	push   $0x24
  8021e2:	e8 ac fb ff ff       	call   801d93 <syscall>
  8021e7:	83 c4 18             	add    $0x18,%esp
}
  8021ea:	c9                   	leave  
  8021eb:	c3                   	ret    

008021ec <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8021ec:	55                   	push   %ebp
  8021ed:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021ef:	6a 00                	push   $0x0
  8021f1:	6a 00                	push   $0x0
  8021f3:	6a 00                	push   $0x0
  8021f5:	6a 00                	push   $0x0
  8021f7:	6a 00                	push   $0x0
  8021f9:	6a 25                	push   $0x25
  8021fb:	e8 93 fb ff ff       	call   801d93 <syscall>
  802200:	83 c4 18             	add    $0x18,%esp
  802203:	a3 64 c0 81 00       	mov    %eax,0x81c064
	return uheapPlaceStrategy ;
  802208:	a1 64 c0 81 00       	mov    0x81c064,%eax
}
  80220d:	c9                   	leave  
  80220e:	c3                   	ret    

0080220f <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80220f:	55                   	push   %ebp
  802210:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  802212:	8b 45 08             	mov    0x8(%ebp),%eax
  802215:	a3 64 c0 81 00       	mov    %eax,0x81c064
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80221a:	6a 00                	push   $0x0
  80221c:	6a 00                	push   $0x0
  80221e:	6a 00                	push   $0x0
  802220:	6a 00                	push   $0x0
  802222:	ff 75 08             	pushl  0x8(%ebp)
  802225:	6a 26                	push   $0x26
  802227:	e8 67 fb ff ff       	call   801d93 <syscall>
  80222c:	83 c4 18             	add    $0x18,%esp
	return ;
  80222f:	90                   	nop
}
  802230:	c9                   	leave  
  802231:	c3                   	ret    

00802232 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802232:	55                   	push   %ebp
  802233:	89 e5                	mov    %esp,%ebp
  802235:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802236:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802239:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80223c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80223f:	8b 45 08             	mov    0x8(%ebp),%eax
  802242:	6a 00                	push   $0x0
  802244:	53                   	push   %ebx
  802245:	51                   	push   %ecx
  802246:	52                   	push   %edx
  802247:	50                   	push   %eax
  802248:	6a 27                	push   $0x27
  80224a:	e8 44 fb ff ff       	call   801d93 <syscall>
  80224f:	83 c4 18             	add    $0x18,%esp
}
  802252:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802255:	c9                   	leave  
  802256:	c3                   	ret    

00802257 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802257:	55                   	push   %ebp
  802258:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80225a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80225d:	8b 45 08             	mov    0x8(%ebp),%eax
  802260:	6a 00                	push   $0x0
  802262:	6a 00                	push   $0x0
  802264:	6a 00                	push   $0x0
  802266:	52                   	push   %edx
  802267:	50                   	push   %eax
  802268:	6a 28                	push   $0x28
  80226a:	e8 24 fb ff ff       	call   801d93 <syscall>
  80226f:	83 c4 18             	add    $0x18,%esp
}
  802272:	c9                   	leave  
  802273:	c3                   	ret    

00802274 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802274:	55                   	push   %ebp
  802275:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802277:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80227a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80227d:	8b 45 08             	mov    0x8(%ebp),%eax
  802280:	6a 00                	push   $0x0
  802282:	51                   	push   %ecx
  802283:	ff 75 10             	pushl  0x10(%ebp)
  802286:	52                   	push   %edx
  802287:	50                   	push   %eax
  802288:	6a 29                	push   $0x29
  80228a:	e8 04 fb ff ff       	call   801d93 <syscall>
  80228f:	83 c4 18             	add    $0x18,%esp
}
  802292:	c9                   	leave  
  802293:	c3                   	ret    

00802294 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802294:	55                   	push   %ebp
  802295:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802297:	6a 00                	push   $0x0
  802299:	6a 00                	push   $0x0
  80229b:	ff 75 10             	pushl  0x10(%ebp)
  80229e:	ff 75 0c             	pushl  0xc(%ebp)
  8022a1:	ff 75 08             	pushl  0x8(%ebp)
  8022a4:	6a 12                	push   $0x12
  8022a6:	e8 e8 fa ff ff       	call   801d93 <syscall>
  8022ab:	83 c4 18             	add    $0x18,%esp
	return ;
  8022ae:	90                   	nop
}
  8022af:	c9                   	leave  
  8022b0:	c3                   	ret    

008022b1 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8022b1:	55                   	push   %ebp
  8022b2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8022b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ba:	6a 00                	push   $0x0
  8022bc:	6a 00                	push   $0x0
  8022be:	6a 00                	push   $0x0
  8022c0:	52                   	push   %edx
  8022c1:	50                   	push   %eax
  8022c2:	6a 2a                	push   $0x2a
  8022c4:	e8 ca fa ff ff       	call   801d93 <syscall>
  8022c9:	83 c4 18             	add    $0x18,%esp
	return;
  8022cc:	90                   	nop
}
  8022cd:	c9                   	leave  
  8022ce:	c3                   	ret    

008022cf <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8022cf:	55                   	push   %ebp
  8022d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8022d2:	6a 00                	push   $0x0
  8022d4:	6a 00                	push   $0x0
  8022d6:	6a 00                	push   $0x0
  8022d8:	6a 00                	push   $0x0
  8022da:	6a 00                	push   $0x0
  8022dc:	6a 2b                	push   $0x2b
  8022de:	e8 b0 fa ff ff       	call   801d93 <syscall>
  8022e3:	83 c4 18             	add    $0x18,%esp
}
  8022e6:	c9                   	leave  
  8022e7:	c3                   	ret    

008022e8 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8022e8:	55                   	push   %ebp
  8022e9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8022eb:	6a 00                	push   $0x0
  8022ed:	6a 00                	push   $0x0
  8022ef:	6a 00                	push   $0x0
  8022f1:	ff 75 0c             	pushl  0xc(%ebp)
  8022f4:	ff 75 08             	pushl  0x8(%ebp)
  8022f7:	6a 2d                	push   $0x2d
  8022f9:	e8 95 fa ff ff       	call   801d93 <syscall>
  8022fe:	83 c4 18             	add    $0x18,%esp
	return;
  802301:	90                   	nop
}
  802302:	c9                   	leave  
  802303:	c3                   	ret    

00802304 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802304:	55                   	push   %ebp
  802305:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802307:	6a 00                	push   $0x0
  802309:	6a 00                	push   $0x0
  80230b:	6a 00                	push   $0x0
  80230d:	ff 75 0c             	pushl  0xc(%ebp)
  802310:	ff 75 08             	pushl  0x8(%ebp)
  802313:	6a 2c                	push   $0x2c
  802315:	e8 79 fa ff ff       	call   801d93 <syscall>
  80231a:	83 c4 18             	add    $0x18,%esp
	return ;
  80231d:	90                   	nop
}
  80231e:	c9                   	leave  
  80231f:	c3                   	ret    

00802320 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  802320:	55                   	push   %ebp
  802321:	89 e5                	mov    %esp,%ebp
  802323:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  802326:	83 ec 04             	sub    $0x4,%esp
  802329:	68 c8 30 80 00       	push   $0x8030c8
  80232e:	68 25 01 00 00       	push   $0x125
  802333:	68 fb 30 80 00       	push   $0x8030fb
  802338:	e8 e4 e4 ff ff       	call   800821 <_panic>

0080233d <to_page_va>:
//==================================================================================//
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  80233d:	55                   	push   %ebp
  80233e:	89 e5                	mov    %esp,%ebp
  802340:	83 ec 10             	sub    $0x10,%esp
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  802343:	8b 45 08             	mov    0x8(%ebp),%eax
  802346:	ba 60 40 80 00       	mov    $0x804060,%edx
  80234b:	29 d0                	sub    %edx,%eax
  80234d:	c1 f8 02             	sar    $0x2,%eax
  802350:	89 c2                	mov    %eax,%edx
  802352:	89 d0                	mov    %edx,%eax
  802354:	c1 e0 02             	shl    $0x2,%eax
  802357:	01 d0                	add    %edx,%eax
  802359:	c1 e0 02             	shl    $0x2,%eax
  80235c:	01 d0                	add    %edx,%eax
  80235e:	c1 e0 02             	shl    $0x2,%eax
  802361:	01 d0                	add    %edx,%eax
  802363:	89 c1                	mov    %eax,%ecx
  802365:	c1 e1 08             	shl    $0x8,%ecx
  802368:	01 c8                	add    %ecx,%eax
  80236a:	89 c1                	mov    %eax,%ecx
  80236c:	c1 e1 10             	shl    $0x10,%ecx
  80236f:	01 c8                	add    %ecx,%eax
  802371:	01 c0                	add    %eax,%eax
  802373:	01 d0                	add    %edx,%eax
  802375:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  802378:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80237b:	c1 e0 0c             	shl    $0xc,%eax
  80237e:	89 c2                	mov    %eax,%edx
  802380:	a1 68 c0 81 00       	mov    0x81c068,%eax
  802385:	01 d0                	add    %edx,%eax
}
  802387:	c9                   	leave  
  802388:	c3                   	ret    

00802389 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  802389:	55                   	push   %ebp
  80238a:	89 e5                	mov    %esp,%ebp
  80238c:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  80238f:	8b 45 08             	mov    0x8(%ebp),%eax
  802392:	05 00 00 00 02       	add    $0x2000000,%eax
  802397:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80239a:	73 16                	jae    8023b2 <initialize_dynamic_allocator+0x29>
  80239c:	68 0c 31 80 00       	push   $0x80310c
  8023a1:	68 32 31 80 00       	push   $0x803132
  8023a6:	6a 26                	push   $0x26
  8023a8:	68 47 31 80 00       	push   $0x803147
  8023ad:	e8 6f e4 ff ff       	call   800821 <_panic>
		is_initialized = 1;
  8023b2:	c7 05 28 40 80 00 01 	movl   $0x1,0x804028
  8023b9:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	//Comment the following line
	panic("initialize_dynamic_allocator() Not implemented yet");
  8023bc:	83 ec 04             	sub    $0x4,%esp
  8023bf:	68 60 31 80 00       	push   $0x803160
  8023c4:	6a 2e                	push   $0x2e
  8023c6:	68 47 31 80 00       	push   $0x803147
  8023cb:	e8 51 e4 ff ff       	call   800821 <_panic>

008023d0 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  8023d0:	55                   	push   %ebp
  8023d1:	89 e5                	mov    %esp,%ebp
  8023d3:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	//Comment the following line
	panic("get_block_size() Not implemented yet");
  8023d6:	83 ec 04             	sub    $0x4,%esp
  8023d9:	68 94 31 80 00       	push   $0x803194
  8023de:	6a 3a                	push   $0x3a
  8023e0:	68 47 31 80 00       	push   $0x803147
  8023e5:	e8 37 e4 ff ff       	call   800821 <_panic>

008023ea <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  8023ea:	55                   	push   %ebp
  8023eb:	89 e5                	mov    %esp,%ebp
  8023ed:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  8023f0:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8023f7:	76 16                	jbe    80240f <alloc_block+0x25>
  8023f9:	68 bc 31 80 00       	push   $0x8031bc
  8023fe:	68 32 31 80 00       	push   $0x803132
  802403:	6a 46                	push   $0x46
  802405:	68 47 31 80 00       	push   $0x803147
  80240a:	e8 12 e4 ff ff       	call   800821 <_panic>
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	panic("alloc_block() Not implemented yet");
  80240f:	83 ec 04             	sub    $0x4,%esp
  802412:	68 e0 31 80 00       	push   $0x8031e0
  802417:	6a 4d                	push   $0x4d
  802419:	68 47 31 80 00       	push   $0x803147
  80241e:	e8 fe e3 ff ff       	call   800821 <_panic>

00802423 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  802423:	55                   	push   %ebp
  802424:	89 e5                	mov    %esp,%ebp
  802426:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  802429:	8b 55 08             	mov    0x8(%ebp),%edx
  80242c:	a1 68 c0 81 00       	mov    0x81c068,%eax
  802431:	39 c2                	cmp    %eax,%edx
  802433:	72 0c                	jb     802441 <free_block+0x1e>
  802435:	8b 55 08             	mov    0x8(%ebp),%edx
  802438:	a1 40 40 80 00       	mov    0x804040,%eax
  80243d:	39 c2                	cmp    %eax,%edx
  80243f:	72 16                	jb     802457 <free_block+0x34>
  802441:	68 04 32 80 00       	push   $0x803204
  802446:	68 32 31 80 00       	push   $0x803132
  80244b:	6a 5b                	push   $0x5b
  80244d:	68 47 31 80 00       	push   $0x803147
  802452:	e8 ca e3 ff ff       	call   800821 <_panic>
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	panic("free_block() Not implemented yet");
  802457:	83 ec 04             	sub    $0x4,%esp
  80245a:	68 3c 32 80 00       	push   $0x80323c
  80245f:	6a 63                	push   $0x63
  802461:	68 47 31 80 00       	push   $0x803147
  802466:	e8 b6 e3 ff ff       	call   800821 <_panic>

0080246b <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  80246b:	55                   	push   %ebp
  80246c:	89 e5                	mov    %esp,%ebp
  80246e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  802471:	83 ec 04             	sub    $0x4,%esp
  802474:	68 60 32 80 00       	push   $0x803260
  802479:	6a 72                	push   $0x72
  80247b:	68 47 31 80 00       	push   $0x803147
  802480:	e8 9c e3 ff ff       	call   800821 <_panic>

00802485 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  802485:	55                   	push   %ebp
  802486:	89 e5                	mov    %esp,%ebp
  802488:	83 ec 08             	sub    $0x8,%esp
	panic("create_semaphore() is not implemented yet...!!");
  80248b:	83 ec 04             	sub    $0x4,%esp
  80248e:	68 84 32 80 00       	push   $0x803284
  802493:	6a 07                	push   $0x7
  802495:	68 b3 32 80 00       	push   $0x8032b3
  80249a:	e8 82 e3 ff ff       	call   800821 <_panic>

0080249f <get_semaphore>:
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  80249f:	55                   	push   %ebp
  8024a0:	89 e5                	mov    %esp,%ebp
  8024a2:	83 ec 08             	sub    $0x8,%esp
	panic("get_semaphore() is not implemented yet...!!");
  8024a5:	83 ec 04             	sub    $0x4,%esp
  8024a8:	68 c4 32 80 00       	push   $0x8032c4
  8024ad:	6a 0b                	push   $0xb
  8024af:	68 b3 32 80 00       	push   $0x8032b3
  8024b4:	e8 68 e3 ff ff       	call   800821 <_panic>

008024b9 <wait_semaphore>:
}

void wait_semaphore(struct semaphore sem)
{
  8024b9:	55                   	push   %ebp
  8024ba:	89 e5                	mov    %esp,%ebp
  8024bc:	83 ec 08             	sub    $0x8,%esp
	panic("wait_semaphore() is not implemented yet...!!");
  8024bf:	83 ec 04             	sub    $0x4,%esp
  8024c2:	68 f0 32 80 00       	push   $0x8032f0
  8024c7:	6a 10                	push   $0x10
  8024c9:	68 b3 32 80 00       	push   $0x8032b3
  8024ce:	e8 4e e3 ff ff       	call   800821 <_panic>

008024d3 <signal_semaphore>:
}

void signal_semaphore(struct semaphore sem)
{
  8024d3:	55                   	push   %ebp
  8024d4:	89 e5                	mov    %esp,%ebp
  8024d6:	83 ec 08             	sub    $0x8,%esp
	panic("signal_semaphore() is not implemented yet...!!");
  8024d9:	83 ec 04             	sub    $0x4,%esp
  8024dc:	68 20 33 80 00       	push   $0x803320
  8024e1:	6a 15                	push   $0x15
  8024e3:	68 b3 32 80 00       	push   $0x8032b3
  8024e8:	e8 34 e3 ff ff       	call   800821 <_panic>

008024ed <semaphore_count>:
}

int semaphore_count(struct semaphore sem)
{
  8024ed:	55                   	push   %ebp
  8024ee:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  8024f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f3:	8b 40 10             	mov    0x10(%eax),%eax
}
  8024f6:	5d                   	pop    %ebp
  8024f7:	c3                   	ret    

008024f8 <__udivdi3>:
  8024f8:	55                   	push   %ebp
  8024f9:	57                   	push   %edi
  8024fa:	56                   	push   %esi
  8024fb:	53                   	push   %ebx
  8024fc:	83 ec 1c             	sub    $0x1c,%esp
  8024ff:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802503:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802507:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80250b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80250f:	89 ca                	mov    %ecx,%edx
  802511:	89 f8                	mov    %edi,%eax
  802513:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802517:	85 f6                	test   %esi,%esi
  802519:	75 2d                	jne    802548 <__udivdi3+0x50>
  80251b:	39 cf                	cmp    %ecx,%edi
  80251d:	77 65                	ja     802584 <__udivdi3+0x8c>
  80251f:	89 fd                	mov    %edi,%ebp
  802521:	85 ff                	test   %edi,%edi
  802523:	75 0b                	jne    802530 <__udivdi3+0x38>
  802525:	b8 01 00 00 00       	mov    $0x1,%eax
  80252a:	31 d2                	xor    %edx,%edx
  80252c:	f7 f7                	div    %edi
  80252e:	89 c5                	mov    %eax,%ebp
  802530:	31 d2                	xor    %edx,%edx
  802532:	89 c8                	mov    %ecx,%eax
  802534:	f7 f5                	div    %ebp
  802536:	89 c1                	mov    %eax,%ecx
  802538:	89 d8                	mov    %ebx,%eax
  80253a:	f7 f5                	div    %ebp
  80253c:	89 cf                	mov    %ecx,%edi
  80253e:	89 fa                	mov    %edi,%edx
  802540:	83 c4 1c             	add    $0x1c,%esp
  802543:	5b                   	pop    %ebx
  802544:	5e                   	pop    %esi
  802545:	5f                   	pop    %edi
  802546:	5d                   	pop    %ebp
  802547:	c3                   	ret    
  802548:	39 ce                	cmp    %ecx,%esi
  80254a:	77 28                	ja     802574 <__udivdi3+0x7c>
  80254c:	0f bd fe             	bsr    %esi,%edi
  80254f:	83 f7 1f             	xor    $0x1f,%edi
  802552:	75 40                	jne    802594 <__udivdi3+0x9c>
  802554:	39 ce                	cmp    %ecx,%esi
  802556:	72 0a                	jb     802562 <__udivdi3+0x6a>
  802558:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80255c:	0f 87 9e 00 00 00    	ja     802600 <__udivdi3+0x108>
  802562:	b8 01 00 00 00       	mov    $0x1,%eax
  802567:	89 fa                	mov    %edi,%edx
  802569:	83 c4 1c             	add    $0x1c,%esp
  80256c:	5b                   	pop    %ebx
  80256d:	5e                   	pop    %esi
  80256e:	5f                   	pop    %edi
  80256f:	5d                   	pop    %ebp
  802570:	c3                   	ret    
  802571:	8d 76 00             	lea    0x0(%esi),%esi
  802574:	31 ff                	xor    %edi,%edi
  802576:	31 c0                	xor    %eax,%eax
  802578:	89 fa                	mov    %edi,%edx
  80257a:	83 c4 1c             	add    $0x1c,%esp
  80257d:	5b                   	pop    %ebx
  80257e:	5e                   	pop    %esi
  80257f:	5f                   	pop    %edi
  802580:	5d                   	pop    %ebp
  802581:	c3                   	ret    
  802582:	66 90                	xchg   %ax,%ax
  802584:	89 d8                	mov    %ebx,%eax
  802586:	f7 f7                	div    %edi
  802588:	31 ff                	xor    %edi,%edi
  80258a:	89 fa                	mov    %edi,%edx
  80258c:	83 c4 1c             	add    $0x1c,%esp
  80258f:	5b                   	pop    %ebx
  802590:	5e                   	pop    %esi
  802591:	5f                   	pop    %edi
  802592:	5d                   	pop    %ebp
  802593:	c3                   	ret    
  802594:	bd 20 00 00 00       	mov    $0x20,%ebp
  802599:	89 eb                	mov    %ebp,%ebx
  80259b:	29 fb                	sub    %edi,%ebx
  80259d:	89 f9                	mov    %edi,%ecx
  80259f:	d3 e6                	shl    %cl,%esi
  8025a1:	89 c5                	mov    %eax,%ebp
  8025a3:	88 d9                	mov    %bl,%cl
  8025a5:	d3 ed                	shr    %cl,%ebp
  8025a7:	89 e9                	mov    %ebp,%ecx
  8025a9:	09 f1                	or     %esi,%ecx
  8025ab:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8025af:	89 f9                	mov    %edi,%ecx
  8025b1:	d3 e0                	shl    %cl,%eax
  8025b3:	89 c5                	mov    %eax,%ebp
  8025b5:	89 d6                	mov    %edx,%esi
  8025b7:	88 d9                	mov    %bl,%cl
  8025b9:	d3 ee                	shr    %cl,%esi
  8025bb:	89 f9                	mov    %edi,%ecx
  8025bd:	d3 e2                	shl    %cl,%edx
  8025bf:	8b 44 24 08          	mov    0x8(%esp),%eax
  8025c3:	88 d9                	mov    %bl,%cl
  8025c5:	d3 e8                	shr    %cl,%eax
  8025c7:	09 c2                	or     %eax,%edx
  8025c9:	89 d0                	mov    %edx,%eax
  8025cb:	89 f2                	mov    %esi,%edx
  8025cd:	f7 74 24 0c          	divl   0xc(%esp)
  8025d1:	89 d6                	mov    %edx,%esi
  8025d3:	89 c3                	mov    %eax,%ebx
  8025d5:	f7 e5                	mul    %ebp
  8025d7:	39 d6                	cmp    %edx,%esi
  8025d9:	72 19                	jb     8025f4 <__udivdi3+0xfc>
  8025db:	74 0b                	je     8025e8 <__udivdi3+0xf0>
  8025dd:	89 d8                	mov    %ebx,%eax
  8025df:	31 ff                	xor    %edi,%edi
  8025e1:	e9 58 ff ff ff       	jmp    80253e <__udivdi3+0x46>
  8025e6:	66 90                	xchg   %ax,%ax
  8025e8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8025ec:	89 f9                	mov    %edi,%ecx
  8025ee:	d3 e2                	shl    %cl,%edx
  8025f0:	39 c2                	cmp    %eax,%edx
  8025f2:	73 e9                	jae    8025dd <__udivdi3+0xe5>
  8025f4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8025f7:	31 ff                	xor    %edi,%edi
  8025f9:	e9 40 ff ff ff       	jmp    80253e <__udivdi3+0x46>
  8025fe:	66 90                	xchg   %ax,%ax
  802600:	31 c0                	xor    %eax,%eax
  802602:	e9 37 ff ff ff       	jmp    80253e <__udivdi3+0x46>
  802607:	90                   	nop

00802608 <__umoddi3>:
  802608:	55                   	push   %ebp
  802609:	57                   	push   %edi
  80260a:	56                   	push   %esi
  80260b:	53                   	push   %ebx
  80260c:	83 ec 1c             	sub    $0x1c,%esp
  80260f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802613:	8b 74 24 34          	mov    0x34(%esp),%esi
  802617:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80261b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80261f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802623:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802627:	89 f3                	mov    %esi,%ebx
  802629:	89 fa                	mov    %edi,%edx
  80262b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80262f:	89 34 24             	mov    %esi,(%esp)
  802632:	85 c0                	test   %eax,%eax
  802634:	75 1a                	jne    802650 <__umoddi3+0x48>
  802636:	39 f7                	cmp    %esi,%edi
  802638:	0f 86 a2 00 00 00    	jbe    8026e0 <__umoddi3+0xd8>
  80263e:	89 c8                	mov    %ecx,%eax
  802640:	89 f2                	mov    %esi,%edx
  802642:	f7 f7                	div    %edi
  802644:	89 d0                	mov    %edx,%eax
  802646:	31 d2                	xor    %edx,%edx
  802648:	83 c4 1c             	add    $0x1c,%esp
  80264b:	5b                   	pop    %ebx
  80264c:	5e                   	pop    %esi
  80264d:	5f                   	pop    %edi
  80264e:	5d                   	pop    %ebp
  80264f:	c3                   	ret    
  802650:	39 f0                	cmp    %esi,%eax
  802652:	0f 87 ac 00 00 00    	ja     802704 <__umoddi3+0xfc>
  802658:	0f bd e8             	bsr    %eax,%ebp
  80265b:	83 f5 1f             	xor    $0x1f,%ebp
  80265e:	0f 84 ac 00 00 00    	je     802710 <__umoddi3+0x108>
  802664:	bf 20 00 00 00       	mov    $0x20,%edi
  802669:	29 ef                	sub    %ebp,%edi
  80266b:	89 fe                	mov    %edi,%esi
  80266d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802671:	89 e9                	mov    %ebp,%ecx
  802673:	d3 e0                	shl    %cl,%eax
  802675:	89 d7                	mov    %edx,%edi
  802677:	89 f1                	mov    %esi,%ecx
  802679:	d3 ef                	shr    %cl,%edi
  80267b:	09 c7                	or     %eax,%edi
  80267d:	89 e9                	mov    %ebp,%ecx
  80267f:	d3 e2                	shl    %cl,%edx
  802681:	89 14 24             	mov    %edx,(%esp)
  802684:	89 d8                	mov    %ebx,%eax
  802686:	d3 e0                	shl    %cl,%eax
  802688:	89 c2                	mov    %eax,%edx
  80268a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80268e:	d3 e0                	shl    %cl,%eax
  802690:	89 44 24 04          	mov    %eax,0x4(%esp)
  802694:	8b 44 24 08          	mov    0x8(%esp),%eax
  802698:	89 f1                	mov    %esi,%ecx
  80269a:	d3 e8                	shr    %cl,%eax
  80269c:	09 d0                	or     %edx,%eax
  80269e:	d3 eb                	shr    %cl,%ebx
  8026a0:	89 da                	mov    %ebx,%edx
  8026a2:	f7 f7                	div    %edi
  8026a4:	89 d3                	mov    %edx,%ebx
  8026a6:	f7 24 24             	mull   (%esp)
  8026a9:	89 c6                	mov    %eax,%esi
  8026ab:	89 d1                	mov    %edx,%ecx
  8026ad:	39 d3                	cmp    %edx,%ebx
  8026af:	0f 82 87 00 00 00    	jb     80273c <__umoddi3+0x134>
  8026b5:	0f 84 91 00 00 00    	je     80274c <__umoddi3+0x144>
  8026bb:	8b 54 24 04          	mov    0x4(%esp),%edx
  8026bf:	29 f2                	sub    %esi,%edx
  8026c1:	19 cb                	sbb    %ecx,%ebx
  8026c3:	89 d8                	mov    %ebx,%eax
  8026c5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8026c9:	d3 e0                	shl    %cl,%eax
  8026cb:	89 e9                	mov    %ebp,%ecx
  8026cd:	d3 ea                	shr    %cl,%edx
  8026cf:	09 d0                	or     %edx,%eax
  8026d1:	89 e9                	mov    %ebp,%ecx
  8026d3:	d3 eb                	shr    %cl,%ebx
  8026d5:	89 da                	mov    %ebx,%edx
  8026d7:	83 c4 1c             	add    $0x1c,%esp
  8026da:	5b                   	pop    %ebx
  8026db:	5e                   	pop    %esi
  8026dc:	5f                   	pop    %edi
  8026dd:	5d                   	pop    %ebp
  8026de:	c3                   	ret    
  8026df:	90                   	nop
  8026e0:	89 fd                	mov    %edi,%ebp
  8026e2:	85 ff                	test   %edi,%edi
  8026e4:	75 0b                	jne    8026f1 <__umoddi3+0xe9>
  8026e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8026eb:	31 d2                	xor    %edx,%edx
  8026ed:	f7 f7                	div    %edi
  8026ef:	89 c5                	mov    %eax,%ebp
  8026f1:	89 f0                	mov    %esi,%eax
  8026f3:	31 d2                	xor    %edx,%edx
  8026f5:	f7 f5                	div    %ebp
  8026f7:	89 c8                	mov    %ecx,%eax
  8026f9:	f7 f5                	div    %ebp
  8026fb:	89 d0                	mov    %edx,%eax
  8026fd:	e9 44 ff ff ff       	jmp    802646 <__umoddi3+0x3e>
  802702:	66 90                	xchg   %ax,%ax
  802704:	89 c8                	mov    %ecx,%eax
  802706:	89 f2                	mov    %esi,%edx
  802708:	83 c4 1c             	add    $0x1c,%esp
  80270b:	5b                   	pop    %ebx
  80270c:	5e                   	pop    %esi
  80270d:	5f                   	pop    %edi
  80270e:	5d                   	pop    %ebp
  80270f:	c3                   	ret    
  802710:	3b 04 24             	cmp    (%esp),%eax
  802713:	72 06                	jb     80271b <__umoddi3+0x113>
  802715:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802719:	77 0f                	ja     80272a <__umoddi3+0x122>
  80271b:	89 f2                	mov    %esi,%edx
  80271d:	29 f9                	sub    %edi,%ecx
  80271f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802723:	89 14 24             	mov    %edx,(%esp)
  802726:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80272a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80272e:	8b 14 24             	mov    (%esp),%edx
  802731:	83 c4 1c             	add    $0x1c,%esp
  802734:	5b                   	pop    %ebx
  802735:	5e                   	pop    %esi
  802736:	5f                   	pop    %edi
  802737:	5d                   	pop    %ebp
  802738:	c3                   	ret    
  802739:	8d 76 00             	lea    0x0(%esi),%esi
  80273c:	2b 04 24             	sub    (%esp),%eax
  80273f:	19 fa                	sbb    %edi,%edx
  802741:	89 d1                	mov    %edx,%ecx
  802743:	89 c6                	mov    %eax,%esi
  802745:	e9 71 ff ff ff       	jmp    8026bb <__umoddi3+0xb3>
  80274a:	66 90                	xchg   %ax,%ax
  80274c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802750:	72 ea                	jb     80273c <__umoddi3+0x134>
  802752:	89 d9                	mov    %ebx,%ecx
  802754:	e9 62 ff ff ff       	jmp    8026bb <__umoddi3+0xb3>


obj/user/quicksort_noleakage:     file format elf32-i386


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
  800031:	e8 d6 05 00 00       	call   80060c <libmain>
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
  80003b:	81 ec 18 01 00 00    	sub    $0x118,%esp
		//2012: lock the interrupt
		//sys_lock_cons();
		//2024: lock the console only using a sleepLock
		int NumOfElements;
		int *Elements;
		sys_lock_cons();
  800041:	e8 57 1d 00 00       	call   801d9d <sys_lock_cons>
		{
			cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 a0 26 80 00       	push   $0x8026a0
  80004e:	e8 37 0a 00 00       	call   800a8a <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 a2 26 80 00       	push   $0x8026a2
  80005e:	e8 27 0a 00 00       	call   800a8a <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!   QUICK SORT    !!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 bb 26 80 00       	push   $0x8026bb
  80006e:	e8 17 0a 00 00       	call   800a8a <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 a2 26 80 00       	push   $0x8026a2
  80007e:	e8 07 0a 00 00       	call   800a8a <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
			cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 a0 26 80 00       	push   $0x8026a0
  80008e:	e8 f7 09 00 00       	call   800a8a <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp

			readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 d4 26 80 00       	push   $0x8026d4
  8000a5:	e8 b9 10 00 00       	call   801163 <readline>
  8000aa:	83 c4 10             	add    $0x10,%esp
			NumOfElements = strtol(Line, NULL, 10) ;
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 0a                	push   $0xa
  8000b2:	6a 00                	push   $0x0
  8000b4:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8000ba:	50                   	push   %eax
  8000bb:	e8 ba 16 00 00       	call   80177a <strtol>
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
			cprintf("Chose the initialization method:\n") ;
  8000c6:	83 ec 0c             	sub    $0xc,%esp
  8000c9:	68 f4 26 80 00       	push   $0x8026f4
  8000ce:	e8 b7 09 00 00       	call   800a8a <cprintf>
  8000d3:	83 c4 10             	add    $0x10,%esp
			cprintf("a) Ascending\n") ;
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	68 16 27 80 00       	push   $0x802716
  8000de:	e8 a7 09 00 00       	call   800a8a <cprintf>
  8000e3:	83 c4 10             	add    $0x10,%esp
			cprintf("b) Descending\n") ;
  8000e6:	83 ec 0c             	sub    $0xc,%esp
  8000e9:	68 24 27 80 00       	push   $0x802724
  8000ee:	e8 97 09 00 00       	call   800a8a <cprintf>
  8000f3:	83 c4 10             	add    $0x10,%esp
			cprintf("c) Semi random\n");
  8000f6:	83 ec 0c             	sub    $0xc,%esp
  8000f9:	68 33 27 80 00       	push   $0x802733
  8000fe:	e8 87 09 00 00       	call   800a8a <cprintf>
  800103:	83 c4 10             	add    $0x10,%esp
			do
			{
				cprintf("Select: ") ;
  800106:	83 ec 0c             	sub    $0xc,%esp
  800109:	68 43 27 80 00       	push   $0x802743
  80010e:	e8 77 09 00 00       	call   800a8a <cprintf>
  800113:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  800116:	e8 d4 04 00 00       	call   8005ef <getchar>
  80011b:	88 45 f7             	mov    %al,-0x9(%ebp)
				cputchar(Chose);
  80011e:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800122:	83 ec 0c             	sub    $0xc,%esp
  800125:	50                   	push   %eax
  800126:	e8 a5 04 00 00       	call   8005d0 <cputchar>
  80012b:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  80012e:	83 ec 0c             	sub    $0xc,%esp
  800131:	6a 0a                	push   $0xa
  800133:	e8 98 04 00 00       	call   8005d0 <cputchar>
  800138:	83 c4 10             	add    $0x10,%esp
			} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  80013b:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  80013f:	74 0c                	je     80014d <_main+0x115>
  800141:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  800145:	74 06                	je     80014d <_main+0x115>
  800147:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  80014b:	75 b9                	jne    800106 <_main+0xce>
		}
		//2012: unlock
		sys_unlock_cons();
  80014d:	e8 65 1c 00 00       	call   801db7 <sys_unlock_cons>
		//sys_unlock_cons();

		Elements = malloc(sizeof(int) * NumOfElements) ;
  800152:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800155:	c1 e0 02             	shl    $0x2,%eax
  800158:	83 ec 0c             	sub    $0xc,%esp
  80015b:	50                   	push   %eax
  80015c:	e8 f3 1a 00 00       	call   801c54 <malloc>
  800161:	83 c4 10             	add    $0x10,%esp
  800164:	89 45 ec             	mov    %eax,-0x14(%ebp)

		int  i ;
		switch (Chose)
  800167:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80016b:	83 f8 62             	cmp    $0x62,%eax
  80016e:	74 1d                	je     80018d <_main+0x155>
  800170:	83 f8 63             	cmp    $0x63,%eax
  800173:	74 2b                	je     8001a0 <_main+0x168>
  800175:	83 f8 61             	cmp    $0x61,%eax
  800178:	75 39                	jne    8001b3 <_main+0x17b>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  80017a:	83 ec 08             	sub    $0x8,%esp
  80017d:	ff 75 f0             	pushl  -0x10(%ebp)
  800180:	ff 75 ec             	pushl  -0x14(%ebp)
  800183:	e8 03 03 00 00       	call   80048b <InitializeAscending>
  800188:	83 c4 10             	add    $0x10,%esp
			break ;
  80018b:	eb 37                	jmp    8001c4 <_main+0x18c>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80018d:	83 ec 08             	sub    $0x8,%esp
  800190:	ff 75 f0             	pushl  -0x10(%ebp)
  800193:	ff 75 ec             	pushl  -0x14(%ebp)
  800196:	e8 21 03 00 00       	call   8004bc <InitializeDescending>
  80019b:	83 c4 10             	add    $0x10,%esp
			break ;
  80019e:	eb 24                	jmp    8001c4 <_main+0x18c>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001a0:	83 ec 08             	sub    $0x8,%esp
  8001a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a6:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a9:	e8 43 03 00 00       	call   8004f1 <InitializeSemiRandom>
  8001ae:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b1:	eb 11                	jmp    8001c4 <_main+0x18c>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001b9:	ff 75 ec             	pushl  -0x14(%ebp)
  8001bc:	e8 30 03 00 00       	call   8004f1 <InitializeSemiRandom>
  8001c1:	83 c4 10             	add    $0x10,%esp
		}

		QuickSort(Elements, NumOfElements);
  8001c4:	83 ec 08             	sub    $0x8,%esp
  8001c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ca:	ff 75 ec             	pushl  -0x14(%ebp)
  8001cd:	e8 fe 00 00 00       	call   8002d0 <QuickSort>
  8001d2:	83 c4 10             	add    $0x10,%esp

		//sys_lock_cons();
		sys_lock_cons();
  8001d5:	e8 c3 1b 00 00       	call   801d9d <sys_lock_cons>
		{
			cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001da:	83 ec 0c             	sub    $0xc,%esp
  8001dd:	68 4c 27 80 00       	push   $0x80274c
  8001e2:	e8 a3 08 00 00       	call   800a8a <cprintf>
  8001e7:	83 c4 10             	add    $0x10,%esp
			//		PrintElements(Elements, NumOfElements);
		}
		sys_unlock_cons();
  8001ea:	e8 c8 1b 00 00       	call   801db7 <sys_unlock_cons>
		//sys_unlock_cons();

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001ef:	83 ec 08             	sub    $0x8,%esp
  8001f2:	ff 75 f0             	pushl  -0x10(%ebp)
  8001f5:	ff 75 ec             	pushl  -0x14(%ebp)
  8001f8:	e8 e4 01 00 00       	call   8003e1 <CheckSorted>
  8001fd:	83 c4 10             	add    $0x10,%esp
  800200:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  800203:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800207:	75 14                	jne    80021d <_main+0x1e5>
  800209:	83 ec 04             	sub    $0x4,%esp
  80020c:	68 80 27 80 00       	push   $0x802780
  800211:	6a 54                	push   $0x54
  800213:	68 a2 27 80 00       	push   $0x8027a2
  800218:	e8 9f 05 00 00       	call   8007bc <_panic>
		else
		{
			//			sys_lock_cons();
			sys_lock_cons();
  80021d:	e8 7b 1b 00 00       	call   801d9d <sys_lock_cons>
			{
				cprintf("===============================================\n") ;
  800222:	83 ec 0c             	sub    $0xc,%esp
  800225:	68 c0 27 80 00       	push   $0x8027c0
  80022a:	e8 5b 08 00 00       	call   800a8a <cprintf>
  80022f:	83 c4 10             	add    $0x10,%esp
				cprintf("Congratulations!! The array is sorted correctly\n") ;
  800232:	83 ec 0c             	sub    $0xc,%esp
  800235:	68 f4 27 80 00       	push   $0x8027f4
  80023a:	e8 4b 08 00 00       	call   800a8a <cprintf>
  80023f:	83 c4 10             	add    $0x10,%esp
				cprintf("===============================================\n\n") ;
  800242:	83 ec 0c             	sub    $0xc,%esp
  800245:	68 28 28 80 00       	push   $0x802828
  80024a:	e8 3b 08 00 00       	call   800a8a <cprintf>
  80024f:	83 c4 10             	add    $0x10,%esp
			}
			sys_unlock_cons();
  800252:	e8 60 1b 00 00       	call   801db7 <sys_unlock_cons>
			//			sys_unlock_cons();


		}

		free(Elements) ;
  800257:	83 ec 0c             	sub    $0xc,%esp
  80025a:	ff 75 ec             	pushl  -0x14(%ebp)
  80025d:	e8 20 1a 00 00       	call   801c82 <free>
  800262:	83 c4 10             	add    $0x10,%esp

		//		sys_lock_cons();
		sys_lock_cons();
  800265:	e8 33 1b 00 00       	call   801d9d <sys_lock_cons>
		{
			Chose = 0 ;
  80026a:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  80026e:	eb 42                	jmp    8002b2 <_main+0x27a>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800270:	83 ec 0c             	sub    $0xc,%esp
  800273:	68 5a 28 80 00       	push   $0x80285a
  800278:	e8 0d 08 00 00       	call   800a8a <cprintf>
  80027d:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  800280:	e8 6a 03 00 00       	call   8005ef <getchar>
  800285:	88 45 f7             	mov    %al,-0x9(%ebp)
				cputchar(Chose);
  800288:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	50                   	push   %eax
  800290:	e8 3b 03 00 00       	call   8005d0 <cputchar>
  800295:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  800298:	83 ec 0c             	sub    $0xc,%esp
  80029b:	6a 0a                	push   $0xa
  80029d:	e8 2e 03 00 00       	call   8005d0 <cputchar>
  8002a2:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  8002a5:	83 ec 0c             	sub    $0xc,%esp
  8002a8:	6a 0a                	push   $0xa
  8002aa:	e8 21 03 00 00       	call   8005d0 <cputchar>
  8002af:	83 c4 10             	add    $0x10,%esp

		//		sys_lock_cons();
		sys_lock_cons();
		{
			Chose = 0 ;
			while (Chose != 'y' && Chose != 'n')
  8002b2:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002b6:	74 06                	je     8002be <_main+0x286>
  8002b8:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  8002bc:	75 b2                	jne    800270 <_main+0x238>
				cputchar(Chose);
				cputchar('\n');
				cputchar('\n');
			}
		}
		sys_unlock_cons();
  8002be:	e8 f4 1a 00 00       	call   801db7 <sys_unlock_cons>
		//		sys_unlock_cons();

	} while (Chose == 'y');
  8002c3:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002c7:	0f 84 74 fd ff ff    	je     800041 <_main+0x9>

}
  8002cd:	90                   	nop
  8002ce:	c9                   	leave  
  8002cf:	c3                   	ret    

008002d0 <QuickSort>:

///Quick sort
void QuickSort(int *Elements, int NumOfElements)
{
  8002d0:	55                   	push   %ebp
  8002d1:	89 e5                	mov    %esp,%ebp
  8002d3:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  8002d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002d9:	48                   	dec    %eax
  8002da:	50                   	push   %eax
  8002db:	6a 00                	push   $0x0
  8002dd:	ff 75 0c             	pushl  0xc(%ebp)
  8002e0:	ff 75 08             	pushl  0x8(%ebp)
  8002e3:	e8 06 00 00 00       	call   8002ee <QSort>
  8002e8:	83 c4 10             	add    $0x10,%esp
}
  8002eb:	90                   	nop
  8002ec:	c9                   	leave  
  8002ed:	c3                   	ret    

008002ee <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  8002ee:	55                   	push   %ebp
  8002ef:	89 e5                	mov    %esp,%ebp
  8002f1:	83 ec 18             	sub    $0x18,%esp
	if (startIndex >= finalIndex) return;
  8002f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8002f7:	3b 45 14             	cmp    0x14(%ebp),%eax
  8002fa:	0f 8d de 00 00 00    	jge    8003de <QSort+0xf0>

	int i = startIndex+1, j = finalIndex;
  800300:	8b 45 10             	mov    0x10(%ebp),%eax
  800303:	40                   	inc    %eax
  800304:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800307:	8b 45 14             	mov    0x14(%ebp),%eax
  80030a:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  80030d:	e9 80 00 00 00       	jmp    800392 <QSort+0xa4>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  800312:	ff 45 f4             	incl   -0xc(%ebp)
  800315:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800318:	3b 45 14             	cmp    0x14(%ebp),%eax
  80031b:	7f 2b                	jg     800348 <QSort+0x5a>
  80031d:	8b 45 10             	mov    0x10(%ebp),%eax
  800320:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800327:	8b 45 08             	mov    0x8(%ebp),%eax
  80032a:	01 d0                	add    %edx,%eax
  80032c:	8b 10                	mov    (%eax),%edx
  80032e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800331:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800338:	8b 45 08             	mov    0x8(%ebp),%eax
  80033b:	01 c8                	add    %ecx,%eax
  80033d:	8b 00                	mov    (%eax),%eax
  80033f:	39 c2                	cmp    %eax,%edx
  800341:	7d cf                	jge    800312 <QSort+0x24>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  800343:	eb 03                	jmp    800348 <QSort+0x5a>
  800345:	ff 4d f0             	decl   -0x10(%ebp)
  800348:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80034b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80034e:	7e 26                	jle    800376 <QSort+0x88>
  800350:	8b 45 10             	mov    0x10(%ebp),%eax
  800353:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80035a:	8b 45 08             	mov    0x8(%ebp),%eax
  80035d:	01 d0                	add    %edx,%eax
  80035f:	8b 10                	mov    (%eax),%edx
  800361:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800364:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80036b:	8b 45 08             	mov    0x8(%ebp),%eax
  80036e:	01 c8                	add    %ecx,%eax
  800370:	8b 00                	mov    (%eax),%eax
  800372:	39 c2                	cmp    %eax,%edx
  800374:	7e cf                	jle    800345 <QSort+0x57>

		if (i <= j)
  800376:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800379:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80037c:	7f 14                	jg     800392 <QSort+0xa4>
		{
			Swap(Elements, i, j);
  80037e:	83 ec 04             	sub    $0x4,%esp
  800381:	ff 75 f0             	pushl  -0x10(%ebp)
  800384:	ff 75 f4             	pushl  -0xc(%ebp)
  800387:	ff 75 08             	pushl  0x8(%ebp)
  80038a:	e8 a9 00 00 00       	call   800438 <Swap>
  80038f:	83 c4 10             	add    $0x10,%esp
{
	if (startIndex >= finalIndex) return;

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  800392:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800395:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800398:	0f 8e 77 ff ff ff    	jle    800315 <QSort+0x27>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  80039e:	83 ec 04             	sub    $0x4,%esp
  8003a1:	ff 75 f0             	pushl  -0x10(%ebp)
  8003a4:	ff 75 10             	pushl  0x10(%ebp)
  8003a7:	ff 75 08             	pushl  0x8(%ebp)
  8003aa:	e8 89 00 00 00       	call   800438 <Swap>
  8003af:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  8003b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003b5:	48                   	dec    %eax
  8003b6:	50                   	push   %eax
  8003b7:	ff 75 10             	pushl  0x10(%ebp)
  8003ba:	ff 75 0c             	pushl  0xc(%ebp)
  8003bd:	ff 75 08             	pushl  0x8(%ebp)
  8003c0:	e8 29 ff ff ff       	call   8002ee <QSort>
  8003c5:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  8003c8:	ff 75 14             	pushl  0x14(%ebp)
  8003cb:	ff 75 f4             	pushl  -0xc(%ebp)
  8003ce:	ff 75 0c             	pushl  0xc(%ebp)
  8003d1:	ff 75 08             	pushl  0x8(%ebp)
  8003d4:	e8 15 ff ff ff       	call   8002ee <QSort>
  8003d9:	83 c4 10             	add    $0x10,%esp
  8003dc:	eb 01                	jmp    8003df <QSort+0xf1>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  8003de:	90                   	nop
	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);

	//cprintf("qs,after sorting: start = %d, end = %d\n", startIndex, finalIndex);

}
  8003df:	c9                   	leave  
  8003e0:	c3                   	ret    

008003e1 <CheckSorted>:

uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8003e1:	55                   	push   %ebp
  8003e2:	89 e5                	mov    %esp,%ebp
  8003e4:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8003e7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8003ee:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8003f5:	eb 33                	jmp    80042a <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8003f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003fa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800401:	8b 45 08             	mov    0x8(%ebp),%eax
  800404:	01 d0                	add    %edx,%eax
  800406:	8b 10                	mov    (%eax),%edx
  800408:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80040b:	40                   	inc    %eax
  80040c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800413:	8b 45 08             	mov    0x8(%ebp),%eax
  800416:	01 c8                	add    %ecx,%eax
  800418:	8b 00                	mov    (%eax),%eax
  80041a:	39 c2                	cmp    %eax,%edx
  80041c:	7e 09                	jle    800427 <CheckSorted+0x46>
		{
			Sorted = 0 ;
  80041e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800425:	eb 0c                	jmp    800433 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800427:	ff 45 f8             	incl   -0x8(%ebp)
  80042a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80042d:	48                   	dec    %eax
  80042e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800431:	7f c4                	jg     8003f7 <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800433:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800436:	c9                   	leave  
  800437:	c3                   	ret    

00800438 <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  800438:	55                   	push   %ebp
  800439:	89 e5                	mov    %esp,%ebp
  80043b:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  80043e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800441:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800448:	8b 45 08             	mov    0x8(%ebp),%eax
  80044b:	01 d0                	add    %edx,%eax
  80044d:	8b 00                	mov    (%eax),%eax
  80044f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800452:	8b 45 0c             	mov    0xc(%ebp),%eax
  800455:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80045c:	8b 45 08             	mov    0x8(%ebp),%eax
  80045f:	01 c2                	add    %eax,%edx
  800461:	8b 45 10             	mov    0x10(%ebp),%eax
  800464:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80046b:	8b 45 08             	mov    0x8(%ebp),%eax
  80046e:	01 c8                	add    %ecx,%eax
  800470:	8b 00                	mov    (%eax),%eax
  800472:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800474:	8b 45 10             	mov    0x10(%ebp),%eax
  800477:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80047e:	8b 45 08             	mov    0x8(%ebp),%eax
  800481:	01 c2                	add    %eax,%edx
  800483:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800486:	89 02                	mov    %eax,(%edx)
}
  800488:	90                   	nop
  800489:	c9                   	leave  
  80048a:	c3                   	ret    

0080048b <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  80048b:	55                   	push   %ebp
  80048c:	89 e5                	mov    %esp,%ebp
  80048e:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800491:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800498:	eb 17                	jmp    8004b1 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  80049a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80049d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a7:	01 c2                	add    %eax,%edx
  8004a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004ac:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004ae:	ff 45 fc             	incl   -0x4(%ebp)
  8004b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004b4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004b7:	7c e1                	jl     80049a <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8004b9:	90                   	nop
  8004ba:	c9                   	leave  
  8004bb:	c3                   	ret    

008004bc <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  8004bc:	55                   	push   %ebp
  8004bd:	89 e5                	mov    %esp,%ebp
  8004bf:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8004c9:	eb 1b                	jmp    8004e6 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8004cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004ce:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d8:	01 c2                	add    %eax,%edx
  8004da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004dd:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8004e0:	48                   	dec    %eax
  8004e1:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004e3:	ff 45 fc             	incl   -0x4(%ebp)
  8004e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004e9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004ec:	7c dd                	jl     8004cb <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8004ee:	90                   	nop
  8004ef:	c9                   	leave  
  8004f0:	c3                   	ret    

008004f1 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8004f1:	55                   	push   %ebp
  8004f2:	89 e5                	mov    %esp,%ebp
  8004f4:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8004f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004fa:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8004ff:	f7 e9                	imul   %ecx
  800501:	c1 f9 1f             	sar    $0x1f,%ecx
  800504:	89 d0                	mov    %edx,%eax
  800506:	29 c8                	sub    %ecx,%eax
  800508:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (Repetition == 0)
  80050b:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80050f:	75 07                	jne    800518 <InitializeSemiRandom+0x27>
		Repetition = 3;
  800511:	c7 45 f8 03 00 00 00 	movl   $0x3,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  800518:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80051f:	eb 1e                	jmp    80053f <InitializeSemiRandom+0x4e>
	{
		Elements[i] = i % Repetition ;
  800521:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800524:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80052b:	8b 45 08             	mov    0x8(%ebp),%eax
  80052e:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800531:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800534:	99                   	cltd   
  800535:	f7 7d f8             	idivl  -0x8(%ebp)
  800538:	89 d0                	mov    %edx,%eax
  80053a:	89 01                	mov    %eax,(%ecx)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	if (Repetition == 0)
		Repetition = 3;
	for (i = 0 ; i < NumOfElements ; i++)
  80053c:	ff 45 fc             	incl   -0x4(%ebp)
  80053f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800542:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800545:	7c da                	jl     800521 <InitializeSemiRandom+0x30>
	{
		Elements[i] = i % Repetition ;
		//	cprintf("i=%d\n",i);
	}

}
  800547:	90                   	nop
  800548:	c9                   	leave  
  800549:	c3                   	ret    

0080054a <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  80054a:	55                   	push   %ebp
  80054b:	89 e5                	mov    %esp,%ebp
  80054d:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800550:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800557:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80055e:	eb 42                	jmp    8005a2 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800560:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800563:	99                   	cltd   
  800564:	f7 7d f0             	idivl  -0x10(%ebp)
  800567:	89 d0                	mov    %edx,%eax
  800569:	85 c0                	test   %eax,%eax
  80056b:	75 10                	jne    80057d <PrintElements+0x33>
			cprintf("\n");
  80056d:	83 ec 0c             	sub    $0xc,%esp
  800570:	68 a0 26 80 00       	push   $0x8026a0
  800575:	e8 10 05 00 00       	call   800a8a <cprintf>
  80057a:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  80057d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800580:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800587:	8b 45 08             	mov    0x8(%ebp),%eax
  80058a:	01 d0                	add    %edx,%eax
  80058c:	8b 00                	mov    (%eax),%eax
  80058e:	83 ec 08             	sub    $0x8,%esp
  800591:	50                   	push   %eax
  800592:	68 78 28 80 00       	push   $0x802878
  800597:	e8 ee 04 00 00       	call   800a8a <cprintf>
  80059c:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80059f:	ff 45 f4             	incl   -0xc(%ebp)
  8005a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005a5:	48                   	dec    %eax
  8005a6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8005a9:	7f b5                	jg     800560 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  8005ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005ae:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b8:	01 d0                	add    %edx,%eax
  8005ba:	8b 00                	mov    (%eax),%eax
  8005bc:	83 ec 08             	sub    $0x8,%esp
  8005bf:	50                   	push   %eax
  8005c0:	68 7d 28 80 00       	push   $0x80287d
  8005c5:	e8 c0 04 00 00       	call   800a8a <cprintf>
  8005ca:	83 c4 10             	add    $0x10,%esp

}
  8005cd:	90                   	nop
  8005ce:	c9                   	leave  
  8005cf:	c3                   	ret    

008005d0 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8005d0:	55                   	push   %ebp
  8005d1:	89 e5                	mov    %esp,%ebp
  8005d3:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8005d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d9:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8005dc:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8005e0:	83 ec 0c             	sub    $0xc,%esp
  8005e3:	50                   	push   %eax
  8005e4:	e8 fc 18 00 00       	call   801ee5 <sys_cputc>
  8005e9:	83 c4 10             	add    $0x10,%esp
}
  8005ec:	90                   	nop
  8005ed:	c9                   	leave  
  8005ee:	c3                   	ret    

008005ef <getchar>:


int
getchar(void)
{
  8005ef:	55                   	push   %ebp
  8005f0:	89 e5                	mov    %esp,%ebp
  8005f2:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  8005f5:	e8 8a 17 00 00       	call   801d84 <sys_cgetc>
  8005fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  8005fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800600:	c9                   	leave  
  800601:	c3                   	ret    

00800602 <iscons>:

int iscons(int fdnum)
{
  800602:	55                   	push   %ebp
  800603:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  800605:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80060a:	5d                   	pop    %ebp
  80060b:	c3                   	ret    

0080060c <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80060c:	55                   	push   %ebp
  80060d:	89 e5                	mov    %esp,%ebp
  80060f:	57                   	push   %edi
  800610:	56                   	push   %esi
  800611:	53                   	push   %ebx
  800612:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800615:	e8 fc 19 00 00       	call   802016 <sys_getenvindex>
  80061a:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  80061d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800620:	89 d0                	mov    %edx,%eax
  800622:	c1 e0 02             	shl    $0x2,%eax
  800625:	01 d0                	add    %edx,%eax
  800627:	c1 e0 03             	shl    $0x3,%eax
  80062a:	01 d0                	add    %edx,%eax
  80062c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800633:	01 d0                	add    %edx,%eax
  800635:	c1 e0 02             	shl    $0x2,%eax
  800638:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80063d:	a3 24 40 80 00       	mov    %eax,0x804024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800642:	a1 24 40 80 00       	mov    0x804024,%eax
  800647:	8a 40 20             	mov    0x20(%eax),%al
  80064a:	84 c0                	test   %al,%al
  80064c:	74 0d                	je     80065b <libmain+0x4f>
		binaryname = myEnv->prog_name;
  80064e:	a1 24 40 80 00       	mov    0x804024,%eax
  800653:	83 c0 20             	add    $0x20,%eax
  800656:	a3 04 40 80 00       	mov    %eax,0x804004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80065b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80065f:	7e 0a                	jle    80066b <libmain+0x5f>
		binaryname = argv[0];
  800661:	8b 45 0c             	mov    0xc(%ebp),%eax
  800664:	8b 00                	mov    (%eax),%eax
  800666:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	_main(argc, argv);
  80066b:	83 ec 08             	sub    $0x8,%esp
  80066e:	ff 75 0c             	pushl  0xc(%ebp)
  800671:	ff 75 08             	pushl  0x8(%ebp)
  800674:	e8 bf f9 ff ff       	call   800038 <_main>
  800679:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80067c:	a1 00 40 80 00       	mov    0x804000,%eax
  800681:	85 c0                	test   %eax,%eax
  800683:	0f 84 01 01 00 00    	je     80078a <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800689:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80068f:	bb 7c 29 80 00       	mov    $0x80297c,%ebx
  800694:	ba 0e 00 00 00       	mov    $0xe,%edx
  800699:	89 c7                	mov    %eax,%edi
  80069b:	89 de                	mov    %ebx,%esi
  80069d:	89 d1                	mov    %edx,%ecx
  80069f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8006a1:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8006a4:	b9 56 00 00 00       	mov    $0x56,%ecx
  8006a9:	b0 00                	mov    $0x0,%al
  8006ab:	89 d7                	mov    %edx,%edi
  8006ad:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8006af:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8006b6:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8006b9:	83 ec 08             	sub    $0x8,%esp
  8006bc:	50                   	push   %eax
  8006bd:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8006c3:	50                   	push   %eax
  8006c4:	e8 83 1b 00 00       	call   80224c <sys_utilities>
  8006c9:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8006cc:	e8 cc 16 00 00       	call   801d9d <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8006d1:	83 ec 0c             	sub    $0xc,%esp
  8006d4:	68 9c 28 80 00       	push   $0x80289c
  8006d9:	e8 ac 03 00 00       	call   800a8a <cprintf>
  8006de:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8006e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006e4:	85 c0                	test   %eax,%eax
  8006e6:	74 18                	je     800700 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8006e8:	e8 7d 1b 00 00       	call   80226a <sys_get_optimal_num_faults>
  8006ed:	83 ec 08             	sub    $0x8,%esp
  8006f0:	50                   	push   %eax
  8006f1:	68 c4 28 80 00       	push   $0x8028c4
  8006f6:	e8 8f 03 00 00       	call   800a8a <cprintf>
  8006fb:	83 c4 10             	add    $0x10,%esp
  8006fe:	eb 59                	jmp    800759 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800700:	a1 24 40 80 00       	mov    0x804024,%eax
  800705:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  80070b:	a1 24 40 80 00       	mov    0x804024,%eax
  800710:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  800716:	83 ec 04             	sub    $0x4,%esp
  800719:	52                   	push   %edx
  80071a:	50                   	push   %eax
  80071b:	68 e8 28 80 00       	push   $0x8028e8
  800720:	e8 65 03 00 00       	call   800a8a <cprintf>
  800725:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800728:	a1 24 40 80 00       	mov    0x804024,%eax
  80072d:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800733:	a1 24 40 80 00       	mov    0x804024,%eax
  800738:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  80073e:	a1 24 40 80 00       	mov    0x804024,%eax
  800743:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  800749:	51                   	push   %ecx
  80074a:	52                   	push   %edx
  80074b:	50                   	push   %eax
  80074c:	68 10 29 80 00       	push   $0x802910
  800751:	e8 34 03 00 00       	call   800a8a <cprintf>
  800756:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800759:	a1 24 40 80 00       	mov    0x804024,%eax
  80075e:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  800764:	83 ec 08             	sub    $0x8,%esp
  800767:	50                   	push   %eax
  800768:	68 68 29 80 00       	push   $0x802968
  80076d:	e8 18 03 00 00       	call   800a8a <cprintf>
  800772:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800775:	83 ec 0c             	sub    $0xc,%esp
  800778:	68 9c 28 80 00       	push   $0x80289c
  80077d:	e8 08 03 00 00       	call   800a8a <cprintf>
  800782:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800785:	e8 2d 16 00 00       	call   801db7 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80078a:	e8 1f 00 00 00       	call   8007ae <exit>
}
  80078f:	90                   	nop
  800790:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800793:	5b                   	pop    %ebx
  800794:	5e                   	pop    %esi
  800795:	5f                   	pop    %edi
  800796:	5d                   	pop    %ebp
  800797:	c3                   	ret    

00800798 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800798:	55                   	push   %ebp
  800799:	89 e5                	mov    %esp,%ebp
  80079b:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80079e:	83 ec 0c             	sub    $0xc,%esp
  8007a1:	6a 00                	push   $0x0
  8007a3:	e8 3a 18 00 00       	call   801fe2 <sys_destroy_env>
  8007a8:	83 c4 10             	add    $0x10,%esp
}
  8007ab:	90                   	nop
  8007ac:	c9                   	leave  
  8007ad:	c3                   	ret    

008007ae <exit>:

void
exit(void)
{
  8007ae:	55                   	push   %ebp
  8007af:	89 e5                	mov    %esp,%ebp
  8007b1:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8007b4:	e8 8f 18 00 00       	call   802048 <sys_exit_env>
}
  8007b9:	90                   	nop
  8007ba:	c9                   	leave  
  8007bb:	c3                   	ret    

008007bc <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8007bc:	55                   	push   %ebp
  8007bd:	89 e5                	mov    %esp,%ebp
  8007bf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8007c2:	8d 45 10             	lea    0x10(%ebp),%eax
  8007c5:	83 c0 04             	add    $0x4,%eax
  8007c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8007cb:	a1 18 c1 81 00       	mov    0x81c118,%eax
  8007d0:	85 c0                	test   %eax,%eax
  8007d2:	74 16                	je     8007ea <_panic+0x2e>
		cprintf("%s: ", argv0);
  8007d4:	a1 18 c1 81 00       	mov    0x81c118,%eax
  8007d9:	83 ec 08             	sub    $0x8,%esp
  8007dc:	50                   	push   %eax
  8007dd:	68 e0 29 80 00       	push   $0x8029e0
  8007e2:	e8 a3 02 00 00       	call   800a8a <cprintf>
  8007e7:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8007ea:	a1 04 40 80 00       	mov    0x804004,%eax
  8007ef:	83 ec 0c             	sub    $0xc,%esp
  8007f2:	ff 75 0c             	pushl  0xc(%ebp)
  8007f5:	ff 75 08             	pushl  0x8(%ebp)
  8007f8:	50                   	push   %eax
  8007f9:	68 e8 29 80 00       	push   $0x8029e8
  8007fe:	6a 74                	push   $0x74
  800800:	e8 b2 02 00 00       	call   800ab7 <cprintf_colored>
  800805:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800808:	8b 45 10             	mov    0x10(%ebp),%eax
  80080b:	83 ec 08             	sub    $0x8,%esp
  80080e:	ff 75 f4             	pushl  -0xc(%ebp)
  800811:	50                   	push   %eax
  800812:	e8 04 02 00 00       	call   800a1b <vcprintf>
  800817:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80081a:	83 ec 08             	sub    $0x8,%esp
  80081d:	6a 00                	push   $0x0
  80081f:	68 10 2a 80 00       	push   $0x802a10
  800824:	e8 f2 01 00 00       	call   800a1b <vcprintf>
  800829:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80082c:	e8 7d ff ff ff       	call   8007ae <exit>

	// should not return here
	while (1) ;
  800831:	eb fe                	jmp    800831 <_panic+0x75>

00800833 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800833:	55                   	push   %ebp
  800834:	89 e5                	mov    %esp,%ebp
  800836:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800839:	a1 24 40 80 00       	mov    0x804024,%eax
  80083e:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800844:	8b 45 0c             	mov    0xc(%ebp),%eax
  800847:	39 c2                	cmp    %eax,%edx
  800849:	74 14                	je     80085f <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80084b:	83 ec 04             	sub    $0x4,%esp
  80084e:	68 14 2a 80 00       	push   $0x802a14
  800853:	6a 26                	push   $0x26
  800855:	68 60 2a 80 00       	push   $0x802a60
  80085a:	e8 5d ff ff ff       	call   8007bc <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80085f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800866:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80086d:	e9 c5 00 00 00       	jmp    800937 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800872:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800875:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80087c:	8b 45 08             	mov    0x8(%ebp),%eax
  80087f:	01 d0                	add    %edx,%eax
  800881:	8b 00                	mov    (%eax),%eax
  800883:	85 c0                	test   %eax,%eax
  800885:	75 08                	jne    80088f <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800887:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80088a:	e9 a5 00 00 00       	jmp    800934 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80088f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800896:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80089d:	eb 69                	jmp    800908 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80089f:	a1 24 40 80 00       	mov    0x804024,%eax
  8008a4:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8008aa:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8008ad:	89 d0                	mov    %edx,%eax
  8008af:	01 c0                	add    %eax,%eax
  8008b1:	01 d0                	add    %edx,%eax
  8008b3:	c1 e0 03             	shl    $0x3,%eax
  8008b6:	01 c8                	add    %ecx,%eax
  8008b8:	8a 40 04             	mov    0x4(%eax),%al
  8008bb:	84 c0                	test   %al,%al
  8008bd:	75 46                	jne    800905 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008bf:	a1 24 40 80 00       	mov    0x804024,%eax
  8008c4:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8008ca:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8008cd:	89 d0                	mov    %edx,%eax
  8008cf:	01 c0                	add    %eax,%eax
  8008d1:	01 d0                	add    %edx,%eax
  8008d3:	c1 e0 03             	shl    $0x3,%eax
  8008d6:	01 c8                	add    %ecx,%eax
  8008d8:	8b 00                	mov    (%eax),%eax
  8008da:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8008dd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8008e0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008e5:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8008e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008ea:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8008f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f4:	01 c8                	add    %ecx,%eax
  8008f6:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008f8:	39 c2                	cmp    %eax,%edx
  8008fa:	75 09                	jne    800905 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8008fc:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800903:	eb 15                	jmp    80091a <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800905:	ff 45 e8             	incl   -0x18(%ebp)
  800908:	a1 24 40 80 00       	mov    0x804024,%eax
  80090d:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800913:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800916:	39 c2                	cmp    %eax,%edx
  800918:	77 85                	ja     80089f <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80091a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80091e:	75 14                	jne    800934 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800920:	83 ec 04             	sub    $0x4,%esp
  800923:	68 6c 2a 80 00       	push   $0x802a6c
  800928:	6a 3a                	push   $0x3a
  80092a:	68 60 2a 80 00       	push   $0x802a60
  80092f:	e8 88 fe ff ff       	call   8007bc <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800934:	ff 45 f0             	incl   -0x10(%ebp)
  800937:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80093a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80093d:	0f 8c 2f ff ff ff    	jl     800872 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800943:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80094a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800951:	eb 26                	jmp    800979 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800953:	a1 24 40 80 00       	mov    0x804024,%eax
  800958:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80095e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800961:	89 d0                	mov    %edx,%eax
  800963:	01 c0                	add    %eax,%eax
  800965:	01 d0                	add    %edx,%eax
  800967:	c1 e0 03             	shl    $0x3,%eax
  80096a:	01 c8                	add    %ecx,%eax
  80096c:	8a 40 04             	mov    0x4(%eax),%al
  80096f:	3c 01                	cmp    $0x1,%al
  800971:	75 03                	jne    800976 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800973:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800976:	ff 45 e0             	incl   -0x20(%ebp)
  800979:	a1 24 40 80 00       	mov    0x804024,%eax
  80097e:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800984:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800987:	39 c2                	cmp    %eax,%edx
  800989:	77 c8                	ja     800953 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80098b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80098e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800991:	74 14                	je     8009a7 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800993:	83 ec 04             	sub    $0x4,%esp
  800996:	68 c0 2a 80 00       	push   $0x802ac0
  80099b:	6a 44                	push   $0x44
  80099d:	68 60 2a 80 00       	push   $0x802a60
  8009a2:	e8 15 fe ff ff       	call   8007bc <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8009a7:	90                   	nop
  8009a8:	c9                   	leave  
  8009a9:	c3                   	ret    

008009aa <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8009aa:	55                   	push   %ebp
  8009ab:	89 e5                	mov    %esp,%ebp
  8009ad:	53                   	push   %ebx
  8009ae:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8009b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b4:	8b 00                	mov    (%eax),%eax
  8009b6:	8d 48 01             	lea    0x1(%eax),%ecx
  8009b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009bc:	89 0a                	mov    %ecx,(%edx)
  8009be:	8b 55 08             	mov    0x8(%ebp),%edx
  8009c1:	88 d1                	mov    %dl,%cl
  8009c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009c6:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8009ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009cd:	8b 00                	mov    (%eax),%eax
  8009cf:	3d ff 00 00 00       	cmp    $0xff,%eax
  8009d4:	75 30                	jne    800a06 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8009d6:	8b 15 1c c1 81 00    	mov    0x81c11c,%edx
  8009dc:	a0 44 40 80 00       	mov    0x804044,%al
  8009e1:	0f b6 c0             	movzbl %al,%eax
  8009e4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009e7:	8b 09                	mov    (%ecx),%ecx
  8009e9:	89 cb                	mov    %ecx,%ebx
  8009eb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009ee:	83 c1 08             	add    $0x8,%ecx
  8009f1:	52                   	push   %edx
  8009f2:	50                   	push   %eax
  8009f3:	53                   	push   %ebx
  8009f4:	51                   	push   %ecx
  8009f5:	e8 5f 13 00 00       	call   801d59 <sys_cputs>
  8009fa:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8009fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a00:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800a06:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a09:	8b 40 04             	mov    0x4(%eax),%eax
  800a0c:	8d 50 01             	lea    0x1(%eax),%edx
  800a0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a12:	89 50 04             	mov    %edx,0x4(%eax)
}
  800a15:	90                   	nop
  800a16:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a19:	c9                   	leave  
  800a1a:	c3                   	ret    

00800a1b <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800a1b:	55                   	push   %ebp
  800a1c:	89 e5                	mov    %esp,%ebp
  800a1e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800a24:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800a2b:	00 00 00 
	b.cnt = 0;
  800a2e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800a35:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800a38:	ff 75 0c             	pushl  0xc(%ebp)
  800a3b:	ff 75 08             	pushl  0x8(%ebp)
  800a3e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a44:	50                   	push   %eax
  800a45:	68 aa 09 80 00       	push   $0x8009aa
  800a4a:	e8 5a 02 00 00       	call   800ca9 <vprintfmt>
  800a4f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800a52:	8b 15 1c c1 81 00    	mov    0x81c11c,%edx
  800a58:	a0 44 40 80 00       	mov    0x804044,%al
  800a5d:	0f b6 c0             	movzbl %al,%eax
  800a60:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800a66:	52                   	push   %edx
  800a67:	50                   	push   %eax
  800a68:	51                   	push   %ecx
  800a69:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a6f:	83 c0 08             	add    $0x8,%eax
  800a72:	50                   	push   %eax
  800a73:	e8 e1 12 00 00       	call   801d59 <sys_cputs>
  800a78:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800a7b:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
	return b.cnt;
  800a82:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a88:	c9                   	leave  
  800a89:	c3                   	ret    

00800a8a <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800a8a:	55                   	push   %ebp
  800a8b:	89 e5                	mov    %esp,%ebp
  800a8d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a90:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	va_start(ap, fmt);
  800a97:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa0:	83 ec 08             	sub    $0x8,%esp
  800aa3:	ff 75 f4             	pushl  -0xc(%ebp)
  800aa6:	50                   	push   %eax
  800aa7:	e8 6f ff ff ff       	call   800a1b <vcprintf>
  800aac:	83 c4 10             	add    $0x10,%esp
  800aaf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800ab2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ab5:	c9                   	leave  
  800ab6:	c3                   	ret    

00800ab7 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800ab7:	55                   	push   %ebp
  800ab8:	89 e5                	mov    %esp,%ebp
  800aba:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800abd:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac7:	c1 e0 08             	shl    $0x8,%eax
  800aca:	a3 1c c1 81 00       	mov    %eax,0x81c11c
	va_start(ap, fmt);
  800acf:	8d 45 0c             	lea    0xc(%ebp),%eax
  800ad2:	83 c0 04             	add    $0x4,%eax
  800ad5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800ad8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800adb:	83 ec 08             	sub    $0x8,%esp
  800ade:	ff 75 f4             	pushl  -0xc(%ebp)
  800ae1:	50                   	push   %eax
  800ae2:	e8 34 ff ff ff       	call   800a1b <vcprintf>
  800ae7:	83 c4 10             	add    $0x10,%esp
  800aea:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800aed:	c7 05 1c c1 81 00 00 	movl   $0x700,0x81c11c
  800af4:	07 00 00 

	return cnt;
  800af7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800afa:	c9                   	leave  
  800afb:	c3                   	ret    

00800afc <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800afc:	55                   	push   %ebp
  800afd:	89 e5                	mov    %esp,%ebp
  800aff:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800b02:	e8 96 12 00 00       	call   801d9d <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800b07:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b10:	83 ec 08             	sub    $0x8,%esp
  800b13:	ff 75 f4             	pushl  -0xc(%ebp)
  800b16:	50                   	push   %eax
  800b17:	e8 ff fe ff ff       	call   800a1b <vcprintf>
  800b1c:	83 c4 10             	add    $0x10,%esp
  800b1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800b22:	e8 90 12 00 00       	call   801db7 <sys_unlock_cons>
	return cnt;
  800b27:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b2a:	c9                   	leave  
  800b2b:	c3                   	ret    

00800b2c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800b2c:	55                   	push   %ebp
  800b2d:	89 e5                	mov    %esp,%ebp
  800b2f:	53                   	push   %ebx
  800b30:	83 ec 14             	sub    $0x14,%esp
  800b33:	8b 45 10             	mov    0x10(%ebp),%eax
  800b36:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b39:	8b 45 14             	mov    0x14(%ebp),%eax
  800b3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800b3f:	8b 45 18             	mov    0x18(%ebp),%eax
  800b42:	ba 00 00 00 00       	mov    $0x0,%edx
  800b47:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b4a:	77 55                	ja     800ba1 <printnum+0x75>
  800b4c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b4f:	72 05                	jb     800b56 <printnum+0x2a>
  800b51:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800b54:	77 4b                	ja     800ba1 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800b56:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800b59:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800b5c:	8b 45 18             	mov    0x18(%ebp),%eax
  800b5f:	ba 00 00 00 00       	mov    $0x0,%edx
  800b64:	52                   	push   %edx
  800b65:	50                   	push   %eax
  800b66:	ff 75 f4             	pushl  -0xc(%ebp)
  800b69:	ff 75 f0             	pushl  -0x10(%ebp)
  800b6c:	e8 af 18 00 00       	call   802420 <__udivdi3>
  800b71:	83 c4 10             	add    $0x10,%esp
  800b74:	83 ec 04             	sub    $0x4,%esp
  800b77:	ff 75 20             	pushl  0x20(%ebp)
  800b7a:	53                   	push   %ebx
  800b7b:	ff 75 18             	pushl  0x18(%ebp)
  800b7e:	52                   	push   %edx
  800b7f:	50                   	push   %eax
  800b80:	ff 75 0c             	pushl  0xc(%ebp)
  800b83:	ff 75 08             	pushl  0x8(%ebp)
  800b86:	e8 a1 ff ff ff       	call   800b2c <printnum>
  800b8b:	83 c4 20             	add    $0x20,%esp
  800b8e:	eb 1a                	jmp    800baa <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800b90:	83 ec 08             	sub    $0x8,%esp
  800b93:	ff 75 0c             	pushl  0xc(%ebp)
  800b96:	ff 75 20             	pushl  0x20(%ebp)
  800b99:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9c:	ff d0                	call   *%eax
  800b9e:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800ba1:	ff 4d 1c             	decl   0x1c(%ebp)
  800ba4:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800ba8:	7f e6                	jg     800b90 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800baa:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800bad:	bb 00 00 00 00       	mov    $0x0,%ebx
  800bb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bb5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bb8:	53                   	push   %ebx
  800bb9:	51                   	push   %ecx
  800bba:	52                   	push   %edx
  800bbb:	50                   	push   %eax
  800bbc:	e8 6f 19 00 00       	call   802530 <__umoddi3>
  800bc1:	83 c4 10             	add    $0x10,%esp
  800bc4:	05 34 2d 80 00       	add    $0x802d34,%eax
  800bc9:	8a 00                	mov    (%eax),%al
  800bcb:	0f be c0             	movsbl %al,%eax
  800bce:	83 ec 08             	sub    $0x8,%esp
  800bd1:	ff 75 0c             	pushl  0xc(%ebp)
  800bd4:	50                   	push   %eax
  800bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd8:	ff d0                	call   *%eax
  800bda:	83 c4 10             	add    $0x10,%esp
}
  800bdd:	90                   	nop
  800bde:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800be1:	c9                   	leave  
  800be2:	c3                   	ret    

00800be3 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800be3:	55                   	push   %ebp
  800be4:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800be6:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800bea:	7e 1c                	jle    800c08 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800bec:	8b 45 08             	mov    0x8(%ebp),%eax
  800bef:	8b 00                	mov    (%eax),%eax
  800bf1:	8d 50 08             	lea    0x8(%eax),%edx
  800bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf7:	89 10                	mov    %edx,(%eax)
  800bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfc:	8b 00                	mov    (%eax),%eax
  800bfe:	83 e8 08             	sub    $0x8,%eax
  800c01:	8b 50 04             	mov    0x4(%eax),%edx
  800c04:	8b 00                	mov    (%eax),%eax
  800c06:	eb 40                	jmp    800c48 <getuint+0x65>
	else if (lflag)
  800c08:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c0c:	74 1e                	je     800c2c <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c11:	8b 00                	mov    (%eax),%eax
  800c13:	8d 50 04             	lea    0x4(%eax),%edx
  800c16:	8b 45 08             	mov    0x8(%ebp),%eax
  800c19:	89 10                	mov    %edx,(%eax)
  800c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1e:	8b 00                	mov    (%eax),%eax
  800c20:	83 e8 04             	sub    $0x4,%eax
  800c23:	8b 00                	mov    (%eax),%eax
  800c25:	ba 00 00 00 00       	mov    $0x0,%edx
  800c2a:	eb 1c                	jmp    800c48 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2f:	8b 00                	mov    (%eax),%eax
  800c31:	8d 50 04             	lea    0x4(%eax),%edx
  800c34:	8b 45 08             	mov    0x8(%ebp),%eax
  800c37:	89 10                	mov    %edx,(%eax)
  800c39:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3c:	8b 00                	mov    (%eax),%eax
  800c3e:	83 e8 04             	sub    $0x4,%eax
  800c41:	8b 00                	mov    (%eax),%eax
  800c43:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800c48:	5d                   	pop    %ebp
  800c49:	c3                   	ret    

00800c4a <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800c4a:	55                   	push   %ebp
  800c4b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c4d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c51:	7e 1c                	jle    800c6f <getint+0x25>
		return va_arg(*ap, long long);
  800c53:	8b 45 08             	mov    0x8(%ebp),%eax
  800c56:	8b 00                	mov    (%eax),%eax
  800c58:	8d 50 08             	lea    0x8(%eax),%edx
  800c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5e:	89 10                	mov    %edx,(%eax)
  800c60:	8b 45 08             	mov    0x8(%ebp),%eax
  800c63:	8b 00                	mov    (%eax),%eax
  800c65:	83 e8 08             	sub    $0x8,%eax
  800c68:	8b 50 04             	mov    0x4(%eax),%edx
  800c6b:	8b 00                	mov    (%eax),%eax
  800c6d:	eb 38                	jmp    800ca7 <getint+0x5d>
	else if (lflag)
  800c6f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c73:	74 1a                	je     800c8f <getint+0x45>
		return va_arg(*ap, long);
  800c75:	8b 45 08             	mov    0x8(%ebp),%eax
  800c78:	8b 00                	mov    (%eax),%eax
  800c7a:	8d 50 04             	lea    0x4(%eax),%edx
  800c7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c80:	89 10                	mov    %edx,(%eax)
  800c82:	8b 45 08             	mov    0x8(%ebp),%eax
  800c85:	8b 00                	mov    (%eax),%eax
  800c87:	83 e8 04             	sub    $0x4,%eax
  800c8a:	8b 00                	mov    (%eax),%eax
  800c8c:	99                   	cltd   
  800c8d:	eb 18                	jmp    800ca7 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c92:	8b 00                	mov    (%eax),%eax
  800c94:	8d 50 04             	lea    0x4(%eax),%edx
  800c97:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9a:	89 10                	mov    %edx,(%eax)
  800c9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9f:	8b 00                	mov    (%eax),%eax
  800ca1:	83 e8 04             	sub    $0x4,%eax
  800ca4:	8b 00                	mov    (%eax),%eax
  800ca6:	99                   	cltd   
}
  800ca7:	5d                   	pop    %ebp
  800ca8:	c3                   	ret    

00800ca9 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800ca9:	55                   	push   %ebp
  800caa:	89 e5                	mov    %esp,%ebp
  800cac:	56                   	push   %esi
  800cad:	53                   	push   %ebx
  800cae:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800cb1:	eb 17                	jmp    800cca <vprintfmt+0x21>
			if (ch == '\0')
  800cb3:	85 db                	test   %ebx,%ebx
  800cb5:	0f 84 c1 03 00 00    	je     80107c <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800cbb:	83 ec 08             	sub    $0x8,%esp
  800cbe:	ff 75 0c             	pushl  0xc(%ebp)
  800cc1:	53                   	push   %ebx
  800cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc5:	ff d0                	call   *%eax
  800cc7:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800cca:	8b 45 10             	mov    0x10(%ebp),%eax
  800ccd:	8d 50 01             	lea    0x1(%eax),%edx
  800cd0:	89 55 10             	mov    %edx,0x10(%ebp)
  800cd3:	8a 00                	mov    (%eax),%al
  800cd5:	0f b6 d8             	movzbl %al,%ebx
  800cd8:	83 fb 25             	cmp    $0x25,%ebx
  800cdb:	75 d6                	jne    800cb3 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800cdd:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800ce1:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800ce8:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800cef:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800cf6:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800cfd:	8b 45 10             	mov    0x10(%ebp),%eax
  800d00:	8d 50 01             	lea    0x1(%eax),%edx
  800d03:	89 55 10             	mov    %edx,0x10(%ebp)
  800d06:	8a 00                	mov    (%eax),%al
  800d08:	0f b6 d8             	movzbl %al,%ebx
  800d0b:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800d0e:	83 f8 5b             	cmp    $0x5b,%eax
  800d11:	0f 87 3d 03 00 00    	ja     801054 <vprintfmt+0x3ab>
  800d17:	8b 04 85 58 2d 80 00 	mov    0x802d58(,%eax,4),%eax
  800d1e:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800d20:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800d24:	eb d7                	jmp    800cfd <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800d26:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800d2a:	eb d1                	jmp    800cfd <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d2c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800d33:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800d36:	89 d0                	mov    %edx,%eax
  800d38:	c1 e0 02             	shl    $0x2,%eax
  800d3b:	01 d0                	add    %edx,%eax
  800d3d:	01 c0                	add    %eax,%eax
  800d3f:	01 d8                	add    %ebx,%eax
  800d41:	83 e8 30             	sub    $0x30,%eax
  800d44:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800d47:	8b 45 10             	mov    0x10(%ebp),%eax
  800d4a:	8a 00                	mov    (%eax),%al
  800d4c:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800d4f:	83 fb 2f             	cmp    $0x2f,%ebx
  800d52:	7e 3e                	jle    800d92 <vprintfmt+0xe9>
  800d54:	83 fb 39             	cmp    $0x39,%ebx
  800d57:	7f 39                	jg     800d92 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d59:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800d5c:	eb d5                	jmp    800d33 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800d5e:	8b 45 14             	mov    0x14(%ebp),%eax
  800d61:	83 c0 04             	add    $0x4,%eax
  800d64:	89 45 14             	mov    %eax,0x14(%ebp)
  800d67:	8b 45 14             	mov    0x14(%ebp),%eax
  800d6a:	83 e8 04             	sub    $0x4,%eax
  800d6d:	8b 00                	mov    (%eax),%eax
  800d6f:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800d72:	eb 1f                	jmp    800d93 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800d74:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d78:	79 83                	jns    800cfd <vprintfmt+0x54>
				width = 0;
  800d7a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800d81:	e9 77 ff ff ff       	jmp    800cfd <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800d86:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800d8d:	e9 6b ff ff ff       	jmp    800cfd <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800d92:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800d93:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d97:	0f 89 60 ff ff ff    	jns    800cfd <vprintfmt+0x54>
				width = precision, precision = -1;
  800d9d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800da0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800da3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800daa:	e9 4e ff ff ff       	jmp    800cfd <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800daf:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800db2:	e9 46 ff ff ff       	jmp    800cfd <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800db7:	8b 45 14             	mov    0x14(%ebp),%eax
  800dba:	83 c0 04             	add    $0x4,%eax
  800dbd:	89 45 14             	mov    %eax,0x14(%ebp)
  800dc0:	8b 45 14             	mov    0x14(%ebp),%eax
  800dc3:	83 e8 04             	sub    $0x4,%eax
  800dc6:	8b 00                	mov    (%eax),%eax
  800dc8:	83 ec 08             	sub    $0x8,%esp
  800dcb:	ff 75 0c             	pushl  0xc(%ebp)
  800dce:	50                   	push   %eax
  800dcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd2:	ff d0                	call   *%eax
  800dd4:	83 c4 10             	add    $0x10,%esp
			break;
  800dd7:	e9 9b 02 00 00       	jmp    801077 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ddc:	8b 45 14             	mov    0x14(%ebp),%eax
  800ddf:	83 c0 04             	add    $0x4,%eax
  800de2:	89 45 14             	mov    %eax,0x14(%ebp)
  800de5:	8b 45 14             	mov    0x14(%ebp),%eax
  800de8:	83 e8 04             	sub    $0x4,%eax
  800deb:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ded:	85 db                	test   %ebx,%ebx
  800def:	79 02                	jns    800df3 <vprintfmt+0x14a>
				err = -err;
  800df1:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800df3:	83 fb 64             	cmp    $0x64,%ebx
  800df6:	7f 0b                	jg     800e03 <vprintfmt+0x15a>
  800df8:	8b 34 9d a0 2b 80 00 	mov    0x802ba0(,%ebx,4),%esi
  800dff:	85 f6                	test   %esi,%esi
  800e01:	75 19                	jne    800e1c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800e03:	53                   	push   %ebx
  800e04:	68 45 2d 80 00       	push   $0x802d45
  800e09:	ff 75 0c             	pushl  0xc(%ebp)
  800e0c:	ff 75 08             	pushl  0x8(%ebp)
  800e0f:	e8 70 02 00 00       	call   801084 <printfmt>
  800e14:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800e17:	e9 5b 02 00 00       	jmp    801077 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800e1c:	56                   	push   %esi
  800e1d:	68 4e 2d 80 00       	push   $0x802d4e
  800e22:	ff 75 0c             	pushl  0xc(%ebp)
  800e25:	ff 75 08             	pushl  0x8(%ebp)
  800e28:	e8 57 02 00 00       	call   801084 <printfmt>
  800e2d:	83 c4 10             	add    $0x10,%esp
			break;
  800e30:	e9 42 02 00 00       	jmp    801077 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800e35:	8b 45 14             	mov    0x14(%ebp),%eax
  800e38:	83 c0 04             	add    $0x4,%eax
  800e3b:	89 45 14             	mov    %eax,0x14(%ebp)
  800e3e:	8b 45 14             	mov    0x14(%ebp),%eax
  800e41:	83 e8 04             	sub    $0x4,%eax
  800e44:	8b 30                	mov    (%eax),%esi
  800e46:	85 f6                	test   %esi,%esi
  800e48:	75 05                	jne    800e4f <vprintfmt+0x1a6>
				p = "(null)";
  800e4a:	be 51 2d 80 00       	mov    $0x802d51,%esi
			if (width > 0 && padc != '-')
  800e4f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e53:	7e 6d                	jle    800ec2 <vprintfmt+0x219>
  800e55:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800e59:	74 67                	je     800ec2 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e5b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e5e:	83 ec 08             	sub    $0x8,%esp
  800e61:	50                   	push   %eax
  800e62:	56                   	push   %esi
  800e63:	e8 26 05 00 00       	call   80138e <strnlen>
  800e68:	83 c4 10             	add    $0x10,%esp
  800e6b:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800e6e:	eb 16                	jmp    800e86 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800e70:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800e74:	83 ec 08             	sub    $0x8,%esp
  800e77:	ff 75 0c             	pushl  0xc(%ebp)
  800e7a:	50                   	push   %eax
  800e7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7e:	ff d0                	call   *%eax
  800e80:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e83:	ff 4d e4             	decl   -0x1c(%ebp)
  800e86:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e8a:	7f e4                	jg     800e70 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e8c:	eb 34                	jmp    800ec2 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800e8e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800e92:	74 1c                	je     800eb0 <vprintfmt+0x207>
  800e94:	83 fb 1f             	cmp    $0x1f,%ebx
  800e97:	7e 05                	jle    800e9e <vprintfmt+0x1f5>
  800e99:	83 fb 7e             	cmp    $0x7e,%ebx
  800e9c:	7e 12                	jle    800eb0 <vprintfmt+0x207>
					putch('?', putdat);
  800e9e:	83 ec 08             	sub    $0x8,%esp
  800ea1:	ff 75 0c             	pushl  0xc(%ebp)
  800ea4:	6a 3f                	push   $0x3f
  800ea6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea9:	ff d0                	call   *%eax
  800eab:	83 c4 10             	add    $0x10,%esp
  800eae:	eb 0f                	jmp    800ebf <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800eb0:	83 ec 08             	sub    $0x8,%esp
  800eb3:	ff 75 0c             	pushl  0xc(%ebp)
  800eb6:	53                   	push   %ebx
  800eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eba:	ff d0                	call   *%eax
  800ebc:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ebf:	ff 4d e4             	decl   -0x1c(%ebp)
  800ec2:	89 f0                	mov    %esi,%eax
  800ec4:	8d 70 01             	lea    0x1(%eax),%esi
  800ec7:	8a 00                	mov    (%eax),%al
  800ec9:	0f be d8             	movsbl %al,%ebx
  800ecc:	85 db                	test   %ebx,%ebx
  800ece:	74 24                	je     800ef4 <vprintfmt+0x24b>
  800ed0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ed4:	78 b8                	js     800e8e <vprintfmt+0x1e5>
  800ed6:	ff 4d e0             	decl   -0x20(%ebp)
  800ed9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800edd:	79 af                	jns    800e8e <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800edf:	eb 13                	jmp    800ef4 <vprintfmt+0x24b>
				putch(' ', putdat);
  800ee1:	83 ec 08             	sub    $0x8,%esp
  800ee4:	ff 75 0c             	pushl  0xc(%ebp)
  800ee7:	6a 20                	push   $0x20
  800ee9:	8b 45 08             	mov    0x8(%ebp),%eax
  800eec:	ff d0                	call   *%eax
  800eee:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ef1:	ff 4d e4             	decl   -0x1c(%ebp)
  800ef4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ef8:	7f e7                	jg     800ee1 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800efa:	e9 78 01 00 00       	jmp    801077 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800eff:	83 ec 08             	sub    $0x8,%esp
  800f02:	ff 75 e8             	pushl  -0x18(%ebp)
  800f05:	8d 45 14             	lea    0x14(%ebp),%eax
  800f08:	50                   	push   %eax
  800f09:	e8 3c fd ff ff       	call   800c4a <getint>
  800f0e:	83 c4 10             	add    $0x10,%esp
  800f11:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f14:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800f17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f1d:	85 d2                	test   %edx,%edx
  800f1f:	79 23                	jns    800f44 <vprintfmt+0x29b>
				putch('-', putdat);
  800f21:	83 ec 08             	sub    $0x8,%esp
  800f24:	ff 75 0c             	pushl  0xc(%ebp)
  800f27:	6a 2d                	push   $0x2d
  800f29:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2c:	ff d0                	call   *%eax
  800f2e:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800f31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f34:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f37:	f7 d8                	neg    %eax
  800f39:	83 d2 00             	adc    $0x0,%edx
  800f3c:	f7 da                	neg    %edx
  800f3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f41:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800f44:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f4b:	e9 bc 00 00 00       	jmp    80100c <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800f50:	83 ec 08             	sub    $0x8,%esp
  800f53:	ff 75 e8             	pushl  -0x18(%ebp)
  800f56:	8d 45 14             	lea    0x14(%ebp),%eax
  800f59:	50                   	push   %eax
  800f5a:	e8 84 fc ff ff       	call   800be3 <getuint>
  800f5f:	83 c4 10             	add    $0x10,%esp
  800f62:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f65:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800f68:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f6f:	e9 98 00 00 00       	jmp    80100c <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800f74:	83 ec 08             	sub    $0x8,%esp
  800f77:	ff 75 0c             	pushl  0xc(%ebp)
  800f7a:	6a 58                	push   $0x58
  800f7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7f:	ff d0                	call   *%eax
  800f81:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f84:	83 ec 08             	sub    $0x8,%esp
  800f87:	ff 75 0c             	pushl  0xc(%ebp)
  800f8a:	6a 58                	push   $0x58
  800f8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8f:	ff d0                	call   *%eax
  800f91:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f94:	83 ec 08             	sub    $0x8,%esp
  800f97:	ff 75 0c             	pushl  0xc(%ebp)
  800f9a:	6a 58                	push   $0x58
  800f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9f:	ff d0                	call   *%eax
  800fa1:	83 c4 10             	add    $0x10,%esp
			break;
  800fa4:	e9 ce 00 00 00       	jmp    801077 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800fa9:	83 ec 08             	sub    $0x8,%esp
  800fac:	ff 75 0c             	pushl  0xc(%ebp)
  800faf:	6a 30                	push   $0x30
  800fb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb4:	ff d0                	call   *%eax
  800fb6:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800fb9:	83 ec 08             	sub    $0x8,%esp
  800fbc:	ff 75 0c             	pushl  0xc(%ebp)
  800fbf:	6a 78                	push   $0x78
  800fc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc4:	ff d0                	call   *%eax
  800fc6:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800fc9:	8b 45 14             	mov    0x14(%ebp),%eax
  800fcc:	83 c0 04             	add    $0x4,%eax
  800fcf:	89 45 14             	mov    %eax,0x14(%ebp)
  800fd2:	8b 45 14             	mov    0x14(%ebp),%eax
  800fd5:	83 e8 04             	sub    $0x4,%eax
  800fd8:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800fda:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fdd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800fe4:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800feb:	eb 1f                	jmp    80100c <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800fed:	83 ec 08             	sub    $0x8,%esp
  800ff0:	ff 75 e8             	pushl  -0x18(%ebp)
  800ff3:	8d 45 14             	lea    0x14(%ebp),%eax
  800ff6:	50                   	push   %eax
  800ff7:	e8 e7 fb ff ff       	call   800be3 <getuint>
  800ffc:	83 c4 10             	add    $0x10,%esp
  800fff:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801002:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801005:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80100c:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801010:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801013:	83 ec 04             	sub    $0x4,%esp
  801016:	52                   	push   %edx
  801017:	ff 75 e4             	pushl  -0x1c(%ebp)
  80101a:	50                   	push   %eax
  80101b:	ff 75 f4             	pushl  -0xc(%ebp)
  80101e:	ff 75 f0             	pushl  -0x10(%ebp)
  801021:	ff 75 0c             	pushl  0xc(%ebp)
  801024:	ff 75 08             	pushl  0x8(%ebp)
  801027:	e8 00 fb ff ff       	call   800b2c <printnum>
  80102c:	83 c4 20             	add    $0x20,%esp
			break;
  80102f:	eb 46                	jmp    801077 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801031:	83 ec 08             	sub    $0x8,%esp
  801034:	ff 75 0c             	pushl  0xc(%ebp)
  801037:	53                   	push   %ebx
  801038:	8b 45 08             	mov    0x8(%ebp),%eax
  80103b:	ff d0                	call   *%eax
  80103d:	83 c4 10             	add    $0x10,%esp
			break;
  801040:	eb 35                	jmp    801077 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  801042:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
			break;
  801049:	eb 2c                	jmp    801077 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  80104b:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
			break;
  801052:	eb 23                	jmp    801077 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801054:	83 ec 08             	sub    $0x8,%esp
  801057:	ff 75 0c             	pushl  0xc(%ebp)
  80105a:	6a 25                	push   $0x25
  80105c:	8b 45 08             	mov    0x8(%ebp),%eax
  80105f:	ff d0                	call   *%eax
  801061:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801064:	ff 4d 10             	decl   0x10(%ebp)
  801067:	eb 03                	jmp    80106c <vprintfmt+0x3c3>
  801069:	ff 4d 10             	decl   0x10(%ebp)
  80106c:	8b 45 10             	mov    0x10(%ebp),%eax
  80106f:	48                   	dec    %eax
  801070:	8a 00                	mov    (%eax),%al
  801072:	3c 25                	cmp    $0x25,%al
  801074:	75 f3                	jne    801069 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  801076:	90                   	nop
		}
	}
  801077:	e9 35 fc ff ff       	jmp    800cb1 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80107c:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80107d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801080:	5b                   	pop    %ebx
  801081:	5e                   	pop    %esi
  801082:	5d                   	pop    %ebp
  801083:	c3                   	ret    

00801084 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801084:	55                   	push   %ebp
  801085:	89 e5                	mov    %esp,%ebp
  801087:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80108a:	8d 45 10             	lea    0x10(%ebp),%eax
  80108d:	83 c0 04             	add    $0x4,%eax
  801090:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801093:	8b 45 10             	mov    0x10(%ebp),%eax
  801096:	ff 75 f4             	pushl  -0xc(%ebp)
  801099:	50                   	push   %eax
  80109a:	ff 75 0c             	pushl  0xc(%ebp)
  80109d:	ff 75 08             	pushl  0x8(%ebp)
  8010a0:	e8 04 fc ff ff       	call   800ca9 <vprintfmt>
  8010a5:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8010a8:	90                   	nop
  8010a9:	c9                   	leave  
  8010aa:	c3                   	ret    

008010ab <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8010ab:	55                   	push   %ebp
  8010ac:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8010ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b1:	8b 40 08             	mov    0x8(%eax),%eax
  8010b4:	8d 50 01             	lea    0x1(%eax),%edx
  8010b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ba:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8010bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c0:	8b 10                	mov    (%eax),%edx
  8010c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c5:	8b 40 04             	mov    0x4(%eax),%eax
  8010c8:	39 c2                	cmp    %eax,%edx
  8010ca:	73 12                	jae    8010de <sprintputch+0x33>
		*b->buf++ = ch;
  8010cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010cf:	8b 00                	mov    (%eax),%eax
  8010d1:	8d 48 01             	lea    0x1(%eax),%ecx
  8010d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010d7:	89 0a                	mov    %ecx,(%edx)
  8010d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8010dc:	88 10                	mov    %dl,(%eax)
}
  8010de:	90                   	nop
  8010df:	5d                   	pop    %ebp
  8010e0:	c3                   	ret    

008010e1 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8010e1:	55                   	push   %ebp
  8010e2:	89 e5                	mov    %esp,%ebp
  8010e4:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8010e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ea:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8010ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f6:	01 d0                	add    %edx,%eax
  8010f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010fb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801102:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801106:	74 06                	je     80110e <vsnprintf+0x2d>
  801108:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80110c:	7f 07                	jg     801115 <vsnprintf+0x34>
		return -E_INVAL;
  80110e:	b8 03 00 00 00       	mov    $0x3,%eax
  801113:	eb 20                	jmp    801135 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801115:	ff 75 14             	pushl  0x14(%ebp)
  801118:	ff 75 10             	pushl  0x10(%ebp)
  80111b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80111e:	50                   	push   %eax
  80111f:	68 ab 10 80 00       	push   $0x8010ab
  801124:	e8 80 fb ff ff       	call   800ca9 <vprintfmt>
  801129:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80112c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80112f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801132:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801135:	c9                   	leave  
  801136:	c3                   	ret    

00801137 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801137:	55                   	push   %ebp
  801138:	89 e5                	mov    %esp,%ebp
  80113a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80113d:	8d 45 10             	lea    0x10(%ebp),%eax
  801140:	83 c0 04             	add    $0x4,%eax
  801143:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801146:	8b 45 10             	mov    0x10(%ebp),%eax
  801149:	ff 75 f4             	pushl  -0xc(%ebp)
  80114c:	50                   	push   %eax
  80114d:	ff 75 0c             	pushl  0xc(%ebp)
  801150:	ff 75 08             	pushl  0x8(%ebp)
  801153:	e8 89 ff ff ff       	call   8010e1 <vsnprintf>
  801158:	83 c4 10             	add    $0x10,%esp
  80115b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80115e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801161:	c9                   	leave  
  801162:	c3                   	ret    

00801163 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  801163:	55                   	push   %ebp
  801164:	89 e5                	mov    %esp,%ebp
  801166:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  801169:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80116d:	74 13                	je     801182 <readline+0x1f>
		cprintf("%s", prompt);
  80116f:	83 ec 08             	sub    $0x8,%esp
  801172:	ff 75 08             	pushl  0x8(%ebp)
  801175:	68 c8 2e 80 00       	push   $0x802ec8
  80117a:	e8 0b f9 ff ff       	call   800a8a <cprintf>
  80117f:	83 c4 10             	add    $0x10,%esp

	i = 0;
  801182:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801189:	83 ec 0c             	sub    $0xc,%esp
  80118c:	6a 00                	push   $0x0
  80118e:	e8 6f f4 ff ff       	call   800602 <iscons>
  801193:	83 c4 10             	add    $0x10,%esp
  801196:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801199:	e8 51 f4 ff ff       	call   8005ef <getchar>
  80119e:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8011a1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8011a5:	79 22                	jns    8011c9 <readline+0x66>
			if (c != -E_EOF)
  8011a7:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8011ab:	0f 84 ad 00 00 00    	je     80125e <readline+0xfb>
				cprintf("read error: %e\n", c);
  8011b1:	83 ec 08             	sub    $0x8,%esp
  8011b4:	ff 75 ec             	pushl  -0x14(%ebp)
  8011b7:	68 cb 2e 80 00       	push   $0x802ecb
  8011bc:	e8 c9 f8 ff ff       	call   800a8a <cprintf>
  8011c1:	83 c4 10             	add    $0x10,%esp
			break;
  8011c4:	e9 95 00 00 00       	jmp    80125e <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8011c9:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8011cd:	7e 34                	jle    801203 <readline+0xa0>
  8011cf:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8011d6:	7f 2b                	jg     801203 <readline+0xa0>
			if (echoing)
  8011d8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8011dc:	74 0e                	je     8011ec <readline+0x89>
				cputchar(c);
  8011de:	83 ec 0c             	sub    $0xc,%esp
  8011e1:	ff 75 ec             	pushl  -0x14(%ebp)
  8011e4:	e8 e7 f3 ff ff       	call   8005d0 <cputchar>
  8011e9:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  8011ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011ef:	8d 50 01             	lea    0x1(%eax),%edx
  8011f2:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8011f5:	89 c2                	mov    %eax,%edx
  8011f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fa:	01 d0                	add    %edx,%eax
  8011fc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011ff:	88 10                	mov    %dl,(%eax)
  801201:	eb 56                	jmp    801259 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  801203:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801207:	75 1f                	jne    801228 <readline+0xc5>
  801209:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80120d:	7e 19                	jle    801228 <readline+0xc5>
			if (echoing)
  80120f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801213:	74 0e                	je     801223 <readline+0xc0>
				cputchar(c);
  801215:	83 ec 0c             	sub    $0xc,%esp
  801218:	ff 75 ec             	pushl  -0x14(%ebp)
  80121b:	e8 b0 f3 ff ff       	call   8005d0 <cputchar>
  801220:	83 c4 10             	add    $0x10,%esp

			i--;
  801223:	ff 4d f4             	decl   -0xc(%ebp)
  801226:	eb 31                	jmp    801259 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  801228:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  80122c:	74 0a                	je     801238 <readline+0xd5>
  80122e:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801232:	0f 85 61 ff ff ff    	jne    801199 <readline+0x36>
			if (echoing)
  801238:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80123c:	74 0e                	je     80124c <readline+0xe9>
				cputchar(c);
  80123e:	83 ec 0c             	sub    $0xc,%esp
  801241:	ff 75 ec             	pushl  -0x14(%ebp)
  801244:	e8 87 f3 ff ff       	call   8005d0 <cputchar>
  801249:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  80124c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80124f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801252:	01 d0                	add    %edx,%eax
  801254:	c6 00 00             	movb   $0x0,(%eax)
			break;
  801257:	eb 06                	jmp    80125f <readline+0xfc>
		}
	}
  801259:	e9 3b ff ff ff       	jmp    801199 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  80125e:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  80125f:	90                   	nop
  801260:	c9                   	leave  
  801261:	c3                   	ret    

00801262 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  801262:	55                   	push   %ebp
  801263:	89 e5                	mov    %esp,%ebp
  801265:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  801268:	e8 30 0b 00 00       	call   801d9d <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  80126d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801271:	74 13                	je     801286 <atomic_readline+0x24>
			cprintf("%s", prompt);
  801273:	83 ec 08             	sub    $0x8,%esp
  801276:	ff 75 08             	pushl  0x8(%ebp)
  801279:	68 c8 2e 80 00       	push   $0x802ec8
  80127e:	e8 07 f8 ff ff       	call   800a8a <cprintf>
  801283:	83 c4 10             	add    $0x10,%esp

		i = 0;
  801286:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  80128d:	83 ec 0c             	sub    $0xc,%esp
  801290:	6a 00                	push   $0x0
  801292:	e8 6b f3 ff ff       	call   800602 <iscons>
  801297:	83 c4 10             	add    $0x10,%esp
  80129a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  80129d:	e8 4d f3 ff ff       	call   8005ef <getchar>
  8012a2:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  8012a5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8012a9:	79 22                	jns    8012cd <atomic_readline+0x6b>
				if (c != -E_EOF)
  8012ab:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8012af:	0f 84 ad 00 00 00    	je     801362 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  8012b5:	83 ec 08             	sub    $0x8,%esp
  8012b8:	ff 75 ec             	pushl  -0x14(%ebp)
  8012bb:	68 cb 2e 80 00       	push   $0x802ecb
  8012c0:	e8 c5 f7 ff ff       	call   800a8a <cprintf>
  8012c5:	83 c4 10             	add    $0x10,%esp
				break;
  8012c8:	e9 95 00 00 00       	jmp    801362 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  8012cd:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8012d1:	7e 34                	jle    801307 <atomic_readline+0xa5>
  8012d3:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8012da:	7f 2b                	jg     801307 <atomic_readline+0xa5>
				if (echoing)
  8012dc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012e0:	74 0e                	je     8012f0 <atomic_readline+0x8e>
					cputchar(c);
  8012e2:	83 ec 0c             	sub    $0xc,%esp
  8012e5:	ff 75 ec             	pushl  -0x14(%ebp)
  8012e8:	e8 e3 f2 ff ff       	call   8005d0 <cputchar>
  8012ed:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  8012f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012f3:	8d 50 01             	lea    0x1(%eax),%edx
  8012f6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8012f9:	89 c2                	mov    %eax,%edx
  8012fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012fe:	01 d0                	add    %edx,%eax
  801300:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801303:	88 10                	mov    %dl,(%eax)
  801305:	eb 56                	jmp    80135d <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  801307:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80130b:	75 1f                	jne    80132c <atomic_readline+0xca>
  80130d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801311:	7e 19                	jle    80132c <atomic_readline+0xca>
				if (echoing)
  801313:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801317:	74 0e                	je     801327 <atomic_readline+0xc5>
					cputchar(c);
  801319:	83 ec 0c             	sub    $0xc,%esp
  80131c:	ff 75 ec             	pushl  -0x14(%ebp)
  80131f:	e8 ac f2 ff ff       	call   8005d0 <cputchar>
  801324:	83 c4 10             	add    $0x10,%esp
				i--;
  801327:	ff 4d f4             	decl   -0xc(%ebp)
  80132a:	eb 31                	jmp    80135d <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  80132c:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801330:	74 0a                	je     80133c <atomic_readline+0xda>
  801332:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801336:	0f 85 61 ff ff ff    	jne    80129d <atomic_readline+0x3b>
				if (echoing)
  80133c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801340:	74 0e                	je     801350 <atomic_readline+0xee>
					cputchar(c);
  801342:	83 ec 0c             	sub    $0xc,%esp
  801345:	ff 75 ec             	pushl  -0x14(%ebp)
  801348:	e8 83 f2 ff ff       	call   8005d0 <cputchar>
  80134d:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  801350:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801353:	8b 45 0c             	mov    0xc(%ebp),%eax
  801356:	01 d0                	add    %edx,%eax
  801358:	c6 00 00             	movb   $0x0,(%eax)
				break;
  80135b:	eb 06                	jmp    801363 <atomic_readline+0x101>
			}
		}
  80135d:	e9 3b ff ff ff       	jmp    80129d <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  801362:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  801363:	e8 4f 0a 00 00       	call   801db7 <sys_unlock_cons>
}
  801368:	90                   	nop
  801369:	c9                   	leave  
  80136a:	c3                   	ret    

0080136b <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80136b:	55                   	push   %ebp
  80136c:	89 e5                	mov    %esp,%ebp
  80136e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801371:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801378:	eb 06                	jmp    801380 <strlen+0x15>
		n++;
  80137a:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80137d:	ff 45 08             	incl   0x8(%ebp)
  801380:	8b 45 08             	mov    0x8(%ebp),%eax
  801383:	8a 00                	mov    (%eax),%al
  801385:	84 c0                	test   %al,%al
  801387:	75 f1                	jne    80137a <strlen+0xf>
		n++;
	return n;
  801389:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80138c:	c9                   	leave  
  80138d:	c3                   	ret    

0080138e <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80138e:	55                   	push   %ebp
  80138f:	89 e5                	mov    %esp,%ebp
  801391:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801394:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80139b:	eb 09                	jmp    8013a6 <strnlen+0x18>
		n++;
  80139d:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8013a0:	ff 45 08             	incl   0x8(%ebp)
  8013a3:	ff 4d 0c             	decl   0xc(%ebp)
  8013a6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8013aa:	74 09                	je     8013b5 <strnlen+0x27>
  8013ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8013af:	8a 00                	mov    (%eax),%al
  8013b1:	84 c0                	test   %al,%al
  8013b3:	75 e8                	jne    80139d <strnlen+0xf>
		n++;
	return n;
  8013b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8013b8:	c9                   	leave  
  8013b9:	c3                   	ret    

008013ba <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8013ba:	55                   	push   %ebp
  8013bb:	89 e5                	mov    %esp,%ebp
  8013bd:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8013c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8013c6:	90                   	nop
  8013c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ca:	8d 50 01             	lea    0x1(%eax),%edx
  8013cd:	89 55 08             	mov    %edx,0x8(%ebp)
  8013d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013d3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013d6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8013d9:	8a 12                	mov    (%edx),%dl
  8013db:	88 10                	mov    %dl,(%eax)
  8013dd:	8a 00                	mov    (%eax),%al
  8013df:	84 c0                	test   %al,%al
  8013e1:	75 e4                	jne    8013c7 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8013e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8013e6:	c9                   	leave  
  8013e7:	c3                   	ret    

008013e8 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8013e8:	55                   	push   %ebp
  8013e9:	89 e5                	mov    %esp,%ebp
  8013eb:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8013ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8013f4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013fb:	eb 1f                	jmp    80141c <strncpy+0x34>
		*dst++ = *src;
  8013fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801400:	8d 50 01             	lea    0x1(%eax),%edx
  801403:	89 55 08             	mov    %edx,0x8(%ebp)
  801406:	8b 55 0c             	mov    0xc(%ebp),%edx
  801409:	8a 12                	mov    (%edx),%dl
  80140b:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80140d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801410:	8a 00                	mov    (%eax),%al
  801412:	84 c0                	test   %al,%al
  801414:	74 03                	je     801419 <strncpy+0x31>
			src++;
  801416:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801419:	ff 45 fc             	incl   -0x4(%ebp)
  80141c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80141f:	3b 45 10             	cmp    0x10(%ebp),%eax
  801422:	72 d9                	jb     8013fd <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801424:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801427:	c9                   	leave  
  801428:	c3                   	ret    

00801429 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801429:	55                   	push   %ebp
  80142a:	89 e5                	mov    %esp,%ebp
  80142c:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80142f:	8b 45 08             	mov    0x8(%ebp),%eax
  801432:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801435:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801439:	74 30                	je     80146b <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80143b:	eb 16                	jmp    801453 <strlcpy+0x2a>
			*dst++ = *src++;
  80143d:	8b 45 08             	mov    0x8(%ebp),%eax
  801440:	8d 50 01             	lea    0x1(%eax),%edx
  801443:	89 55 08             	mov    %edx,0x8(%ebp)
  801446:	8b 55 0c             	mov    0xc(%ebp),%edx
  801449:	8d 4a 01             	lea    0x1(%edx),%ecx
  80144c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80144f:	8a 12                	mov    (%edx),%dl
  801451:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801453:	ff 4d 10             	decl   0x10(%ebp)
  801456:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80145a:	74 09                	je     801465 <strlcpy+0x3c>
  80145c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80145f:	8a 00                	mov    (%eax),%al
  801461:	84 c0                	test   %al,%al
  801463:	75 d8                	jne    80143d <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801465:	8b 45 08             	mov    0x8(%ebp),%eax
  801468:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80146b:	8b 55 08             	mov    0x8(%ebp),%edx
  80146e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801471:	29 c2                	sub    %eax,%edx
  801473:	89 d0                	mov    %edx,%eax
}
  801475:	c9                   	leave  
  801476:	c3                   	ret    

00801477 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801477:	55                   	push   %ebp
  801478:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80147a:	eb 06                	jmp    801482 <strcmp+0xb>
		p++, q++;
  80147c:	ff 45 08             	incl   0x8(%ebp)
  80147f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801482:	8b 45 08             	mov    0x8(%ebp),%eax
  801485:	8a 00                	mov    (%eax),%al
  801487:	84 c0                	test   %al,%al
  801489:	74 0e                	je     801499 <strcmp+0x22>
  80148b:	8b 45 08             	mov    0x8(%ebp),%eax
  80148e:	8a 10                	mov    (%eax),%dl
  801490:	8b 45 0c             	mov    0xc(%ebp),%eax
  801493:	8a 00                	mov    (%eax),%al
  801495:	38 c2                	cmp    %al,%dl
  801497:	74 e3                	je     80147c <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801499:	8b 45 08             	mov    0x8(%ebp),%eax
  80149c:	8a 00                	mov    (%eax),%al
  80149e:	0f b6 d0             	movzbl %al,%edx
  8014a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a4:	8a 00                	mov    (%eax),%al
  8014a6:	0f b6 c0             	movzbl %al,%eax
  8014a9:	29 c2                	sub    %eax,%edx
  8014ab:	89 d0                	mov    %edx,%eax
}
  8014ad:	5d                   	pop    %ebp
  8014ae:	c3                   	ret    

008014af <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8014af:	55                   	push   %ebp
  8014b0:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8014b2:	eb 09                	jmp    8014bd <strncmp+0xe>
		n--, p++, q++;
  8014b4:	ff 4d 10             	decl   0x10(%ebp)
  8014b7:	ff 45 08             	incl   0x8(%ebp)
  8014ba:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8014bd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014c1:	74 17                	je     8014da <strncmp+0x2b>
  8014c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c6:	8a 00                	mov    (%eax),%al
  8014c8:	84 c0                	test   %al,%al
  8014ca:	74 0e                	je     8014da <strncmp+0x2b>
  8014cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cf:	8a 10                	mov    (%eax),%dl
  8014d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d4:	8a 00                	mov    (%eax),%al
  8014d6:	38 c2                	cmp    %al,%dl
  8014d8:	74 da                	je     8014b4 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8014da:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014de:	75 07                	jne    8014e7 <strncmp+0x38>
		return 0;
  8014e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8014e5:	eb 14                	jmp    8014fb <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8014e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ea:	8a 00                	mov    (%eax),%al
  8014ec:	0f b6 d0             	movzbl %al,%edx
  8014ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f2:	8a 00                	mov    (%eax),%al
  8014f4:	0f b6 c0             	movzbl %al,%eax
  8014f7:	29 c2                	sub    %eax,%edx
  8014f9:	89 d0                	mov    %edx,%eax
}
  8014fb:	5d                   	pop    %ebp
  8014fc:	c3                   	ret    

008014fd <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8014fd:	55                   	push   %ebp
  8014fe:	89 e5                	mov    %esp,%ebp
  801500:	83 ec 04             	sub    $0x4,%esp
  801503:	8b 45 0c             	mov    0xc(%ebp),%eax
  801506:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801509:	eb 12                	jmp    80151d <strchr+0x20>
		if (*s == c)
  80150b:	8b 45 08             	mov    0x8(%ebp),%eax
  80150e:	8a 00                	mov    (%eax),%al
  801510:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801513:	75 05                	jne    80151a <strchr+0x1d>
			return (char *) s;
  801515:	8b 45 08             	mov    0x8(%ebp),%eax
  801518:	eb 11                	jmp    80152b <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80151a:	ff 45 08             	incl   0x8(%ebp)
  80151d:	8b 45 08             	mov    0x8(%ebp),%eax
  801520:	8a 00                	mov    (%eax),%al
  801522:	84 c0                	test   %al,%al
  801524:	75 e5                	jne    80150b <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801526:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80152b:	c9                   	leave  
  80152c:	c3                   	ret    

0080152d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80152d:	55                   	push   %ebp
  80152e:	89 e5                	mov    %esp,%ebp
  801530:	83 ec 04             	sub    $0x4,%esp
  801533:	8b 45 0c             	mov    0xc(%ebp),%eax
  801536:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801539:	eb 0d                	jmp    801548 <strfind+0x1b>
		if (*s == c)
  80153b:	8b 45 08             	mov    0x8(%ebp),%eax
  80153e:	8a 00                	mov    (%eax),%al
  801540:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801543:	74 0e                	je     801553 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801545:	ff 45 08             	incl   0x8(%ebp)
  801548:	8b 45 08             	mov    0x8(%ebp),%eax
  80154b:	8a 00                	mov    (%eax),%al
  80154d:	84 c0                	test   %al,%al
  80154f:	75 ea                	jne    80153b <strfind+0xe>
  801551:	eb 01                	jmp    801554 <strfind+0x27>
		if (*s == c)
			break;
  801553:	90                   	nop
	return (char *) s;
  801554:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801557:	c9                   	leave  
  801558:	c3                   	ret    

00801559 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801559:	55                   	push   %ebp
  80155a:	89 e5                	mov    %esp,%ebp
  80155c:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  80155f:	8b 45 08             	mov    0x8(%ebp),%eax
  801562:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801565:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801569:	76 63                	jbe    8015ce <memset+0x75>
		uint64 data_block = c;
  80156b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80156e:	99                   	cltd   
  80156f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801572:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801575:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801578:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80157b:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  80157f:	c1 e0 08             	shl    $0x8,%eax
  801582:	09 45 f0             	or     %eax,-0x10(%ebp)
  801585:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801588:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80158b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80158e:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801592:	c1 e0 10             	shl    $0x10,%eax
  801595:	09 45 f0             	or     %eax,-0x10(%ebp)
  801598:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  80159b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80159e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015a1:	89 c2                	mov    %eax,%edx
  8015a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8015a8:	09 45 f0             	or     %eax,-0x10(%ebp)
  8015ab:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  8015ae:	eb 18                	jmp    8015c8 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  8015b0:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015b3:	8d 41 08             	lea    0x8(%ecx),%eax
  8015b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8015b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015bf:	89 01                	mov    %eax,(%ecx)
  8015c1:	89 51 04             	mov    %edx,0x4(%ecx)
  8015c4:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  8015c8:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8015cc:	77 e2                	ja     8015b0 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8015ce:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015d2:	74 23                	je     8015f7 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8015d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015d7:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8015da:	eb 0e                	jmp    8015ea <memset+0x91>
			*p8++ = (uint8)c;
  8015dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015df:	8d 50 01             	lea    0x1(%eax),%edx
  8015e2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8015e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015e8:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8015ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8015ed:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015f0:	89 55 10             	mov    %edx,0x10(%ebp)
  8015f3:	85 c0                	test   %eax,%eax
  8015f5:	75 e5                	jne    8015dc <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8015f7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015fa:	c9                   	leave  
  8015fb:	c3                   	ret    

008015fc <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8015fc:	55                   	push   %ebp
  8015fd:	89 e5                	mov    %esp,%ebp
  8015ff:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801602:	8b 45 0c             	mov    0xc(%ebp),%eax
  801605:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801608:	8b 45 08             	mov    0x8(%ebp),%eax
  80160b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  80160e:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801612:	76 24                	jbe    801638 <memcpy+0x3c>
		while(n >= 8){
  801614:	eb 1c                	jmp    801632 <memcpy+0x36>
			*d64 = *s64;
  801616:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801619:	8b 50 04             	mov    0x4(%eax),%edx
  80161c:	8b 00                	mov    (%eax),%eax
  80161e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801621:	89 01                	mov    %eax,(%ecx)
  801623:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801626:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  80162a:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  80162e:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801632:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801636:	77 de                	ja     801616 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801638:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80163c:	74 31                	je     80166f <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  80163e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801641:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801644:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801647:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  80164a:	eb 16                	jmp    801662 <memcpy+0x66>
			*d8++ = *s8++;
  80164c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80164f:	8d 50 01             	lea    0x1(%eax),%edx
  801652:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801655:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801658:	8d 4a 01             	lea    0x1(%edx),%ecx
  80165b:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80165e:	8a 12                	mov    (%edx),%dl
  801660:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801662:	8b 45 10             	mov    0x10(%ebp),%eax
  801665:	8d 50 ff             	lea    -0x1(%eax),%edx
  801668:	89 55 10             	mov    %edx,0x10(%ebp)
  80166b:	85 c0                	test   %eax,%eax
  80166d:	75 dd                	jne    80164c <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  80166f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801672:	c9                   	leave  
  801673:	c3                   	ret    

00801674 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801674:	55                   	push   %ebp
  801675:	89 e5                	mov    %esp,%ebp
  801677:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80167a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80167d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801680:	8b 45 08             	mov    0x8(%ebp),%eax
  801683:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801686:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801689:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80168c:	73 50                	jae    8016de <memmove+0x6a>
  80168e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801691:	8b 45 10             	mov    0x10(%ebp),%eax
  801694:	01 d0                	add    %edx,%eax
  801696:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801699:	76 43                	jbe    8016de <memmove+0x6a>
		s += n;
  80169b:	8b 45 10             	mov    0x10(%ebp),%eax
  80169e:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8016a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a4:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8016a7:	eb 10                	jmp    8016b9 <memmove+0x45>
			*--d = *--s;
  8016a9:	ff 4d f8             	decl   -0x8(%ebp)
  8016ac:	ff 4d fc             	decl   -0x4(%ebp)
  8016af:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016b2:	8a 10                	mov    (%eax),%dl
  8016b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016b7:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8016b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8016bc:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016bf:	89 55 10             	mov    %edx,0x10(%ebp)
  8016c2:	85 c0                	test   %eax,%eax
  8016c4:	75 e3                	jne    8016a9 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8016c6:	eb 23                	jmp    8016eb <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8016c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016cb:	8d 50 01             	lea    0x1(%eax),%edx
  8016ce:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8016d1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016d4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016d7:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8016da:	8a 12                	mov    (%edx),%dl
  8016dc:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8016de:	8b 45 10             	mov    0x10(%ebp),%eax
  8016e1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016e4:	89 55 10             	mov    %edx,0x10(%ebp)
  8016e7:	85 c0                	test   %eax,%eax
  8016e9:	75 dd                	jne    8016c8 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8016eb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016ee:	c9                   	leave  
  8016ef:	c3                   	ret    

008016f0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8016f0:	55                   	push   %ebp
  8016f1:	89 e5                	mov    %esp,%ebp
  8016f3:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8016f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8016fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016ff:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801702:	eb 2a                	jmp    80172e <memcmp+0x3e>
		if (*s1 != *s2)
  801704:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801707:	8a 10                	mov    (%eax),%dl
  801709:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80170c:	8a 00                	mov    (%eax),%al
  80170e:	38 c2                	cmp    %al,%dl
  801710:	74 16                	je     801728 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801712:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801715:	8a 00                	mov    (%eax),%al
  801717:	0f b6 d0             	movzbl %al,%edx
  80171a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80171d:	8a 00                	mov    (%eax),%al
  80171f:	0f b6 c0             	movzbl %al,%eax
  801722:	29 c2                	sub    %eax,%edx
  801724:	89 d0                	mov    %edx,%eax
  801726:	eb 18                	jmp    801740 <memcmp+0x50>
		s1++, s2++;
  801728:	ff 45 fc             	incl   -0x4(%ebp)
  80172b:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80172e:	8b 45 10             	mov    0x10(%ebp),%eax
  801731:	8d 50 ff             	lea    -0x1(%eax),%edx
  801734:	89 55 10             	mov    %edx,0x10(%ebp)
  801737:	85 c0                	test   %eax,%eax
  801739:	75 c9                	jne    801704 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80173b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801740:	c9                   	leave  
  801741:	c3                   	ret    

00801742 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801742:	55                   	push   %ebp
  801743:	89 e5                	mov    %esp,%ebp
  801745:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801748:	8b 55 08             	mov    0x8(%ebp),%edx
  80174b:	8b 45 10             	mov    0x10(%ebp),%eax
  80174e:	01 d0                	add    %edx,%eax
  801750:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801753:	eb 15                	jmp    80176a <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801755:	8b 45 08             	mov    0x8(%ebp),%eax
  801758:	8a 00                	mov    (%eax),%al
  80175a:	0f b6 d0             	movzbl %al,%edx
  80175d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801760:	0f b6 c0             	movzbl %al,%eax
  801763:	39 c2                	cmp    %eax,%edx
  801765:	74 0d                	je     801774 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801767:	ff 45 08             	incl   0x8(%ebp)
  80176a:	8b 45 08             	mov    0x8(%ebp),%eax
  80176d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801770:	72 e3                	jb     801755 <memfind+0x13>
  801772:	eb 01                	jmp    801775 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801774:	90                   	nop
	return (void *) s;
  801775:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801778:	c9                   	leave  
  801779:	c3                   	ret    

0080177a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80177a:	55                   	push   %ebp
  80177b:	89 e5                	mov    %esp,%ebp
  80177d:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801780:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801787:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80178e:	eb 03                	jmp    801793 <strtol+0x19>
		s++;
  801790:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801793:	8b 45 08             	mov    0x8(%ebp),%eax
  801796:	8a 00                	mov    (%eax),%al
  801798:	3c 20                	cmp    $0x20,%al
  80179a:	74 f4                	je     801790 <strtol+0x16>
  80179c:	8b 45 08             	mov    0x8(%ebp),%eax
  80179f:	8a 00                	mov    (%eax),%al
  8017a1:	3c 09                	cmp    $0x9,%al
  8017a3:	74 eb                	je     801790 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8017a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a8:	8a 00                	mov    (%eax),%al
  8017aa:	3c 2b                	cmp    $0x2b,%al
  8017ac:	75 05                	jne    8017b3 <strtol+0x39>
		s++;
  8017ae:	ff 45 08             	incl   0x8(%ebp)
  8017b1:	eb 13                	jmp    8017c6 <strtol+0x4c>
	else if (*s == '-')
  8017b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b6:	8a 00                	mov    (%eax),%al
  8017b8:	3c 2d                	cmp    $0x2d,%al
  8017ba:	75 0a                	jne    8017c6 <strtol+0x4c>
		s++, neg = 1;
  8017bc:	ff 45 08             	incl   0x8(%ebp)
  8017bf:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8017c6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017ca:	74 06                	je     8017d2 <strtol+0x58>
  8017cc:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8017d0:	75 20                	jne    8017f2 <strtol+0x78>
  8017d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d5:	8a 00                	mov    (%eax),%al
  8017d7:	3c 30                	cmp    $0x30,%al
  8017d9:	75 17                	jne    8017f2 <strtol+0x78>
  8017db:	8b 45 08             	mov    0x8(%ebp),%eax
  8017de:	40                   	inc    %eax
  8017df:	8a 00                	mov    (%eax),%al
  8017e1:	3c 78                	cmp    $0x78,%al
  8017e3:	75 0d                	jne    8017f2 <strtol+0x78>
		s += 2, base = 16;
  8017e5:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8017e9:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8017f0:	eb 28                	jmp    80181a <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8017f2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017f6:	75 15                	jne    80180d <strtol+0x93>
  8017f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fb:	8a 00                	mov    (%eax),%al
  8017fd:	3c 30                	cmp    $0x30,%al
  8017ff:	75 0c                	jne    80180d <strtol+0x93>
		s++, base = 8;
  801801:	ff 45 08             	incl   0x8(%ebp)
  801804:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80180b:	eb 0d                	jmp    80181a <strtol+0xa0>
	else if (base == 0)
  80180d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801811:	75 07                	jne    80181a <strtol+0xa0>
		base = 10;
  801813:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80181a:	8b 45 08             	mov    0x8(%ebp),%eax
  80181d:	8a 00                	mov    (%eax),%al
  80181f:	3c 2f                	cmp    $0x2f,%al
  801821:	7e 19                	jle    80183c <strtol+0xc2>
  801823:	8b 45 08             	mov    0x8(%ebp),%eax
  801826:	8a 00                	mov    (%eax),%al
  801828:	3c 39                	cmp    $0x39,%al
  80182a:	7f 10                	jg     80183c <strtol+0xc2>
			dig = *s - '0';
  80182c:	8b 45 08             	mov    0x8(%ebp),%eax
  80182f:	8a 00                	mov    (%eax),%al
  801831:	0f be c0             	movsbl %al,%eax
  801834:	83 e8 30             	sub    $0x30,%eax
  801837:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80183a:	eb 42                	jmp    80187e <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80183c:	8b 45 08             	mov    0x8(%ebp),%eax
  80183f:	8a 00                	mov    (%eax),%al
  801841:	3c 60                	cmp    $0x60,%al
  801843:	7e 19                	jle    80185e <strtol+0xe4>
  801845:	8b 45 08             	mov    0x8(%ebp),%eax
  801848:	8a 00                	mov    (%eax),%al
  80184a:	3c 7a                	cmp    $0x7a,%al
  80184c:	7f 10                	jg     80185e <strtol+0xe4>
			dig = *s - 'a' + 10;
  80184e:	8b 45 08             	mov    0x8(%ebp),%eax
  801851:	8a 00                	mov    (%eax),%al
  801853:	0f be c0             	movsbl %al,%eax
  801856:	83 e8 57             	sub    $0x57,%eax
  801859:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80185c:	eb 20                	jmp    80187e <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80185e:	8b 45 08             	mov    0x8(%ebp),%eax
  801861:	8a 00                	mov    (%eax),%al
  801863:	3c 40                	cmp    $0x40,%al
  801865:	7e 39                	jle    8018a0 <strtol+0x126>
  801867:	8b 45 08             	mov    0x8(%ebp),%eax
  80186a:	8a 00                	mov    (%eax),%al
  80186c:	3c 5a                	cmp    $0x5a,%al
  80186e:	7f 30                	jg     8018a0 <strtol+0x126>
			dig = *s - 'A' + 10;
  801870:	8b 45 08             	mov    0x8(%ebp),%eax
  801873:	8a 00                	mov    (%eax),%al
  801875:	0f be c0             	movsbl %al,%eax
  801878:	83 e8 37             	sub    $0x37,%eax
  80187b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80187e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801881:	3b 45 10             	cmp    0x10(%ebp),%eax
  801884:	7d 19                	jge    80189f <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801886:	ff 45 08             	incl   0x8(%ebp)
  801889:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80188c:	0f af 45 10          	imul   0x10(%ebp),%eax
  801890:	89 c2                	mov    %eax,%edx
  801892:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801895:	01 d0                	add    %edx,%eax
  801897:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80189a:	e9 7b ff ff ff       	jmp    80181a <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80189f:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8018a0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8018a4:	74 08                	je     8018ae <strtol+0x134>
		*endptr = (char *) s;
  8018a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8018ac:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8018ae:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8018b2:	74 07                	je     8018bb <strtol+0x141>
  8018b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018b7:	f7 d8                	neg    %eax
  8018b9:	eb 03                	jmp    8018be <strtol+0x144>
  8018bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8018be:	c9                   	leave  
  8018bf:	c3                   	ret    

008018c0 <ltostr>:

void
ltostr(long value, char *str)
{
  8018c0:	55                   	push   %ebp
  8018c1:	89 e5                	mov    %esp,%ebp
  8018c3:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8018c6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8018cd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8018d4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018d8:	79 13                	jns    8018ed <ltostr+0x2d>
	{
		neg = 1;
  8018da:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8018e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018e4:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8018e7:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8018ea:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8018ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f0:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8018f5:	99                   	cltd   
  8018f6:	f7 f9                	idiv   %ecx
  8018f8:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8018fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018fe:	8d 50 01             	lea    0x1(%eax),%edx
  801901:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801904:	89 c2                	mov    %eax,%edx
  801906:	8b 45 0c             	mov    0xc(%ebp),%eax
  801909:	01 d0                	add    %edx,%eax
  80190b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80190e:	83 c2 30             	add    $0x30,%edx
  801911:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801913:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801916:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80191b:	f7 e9                	imul   %ecx
  80191d:	c1 fa 02             	sar    $0x2,%edx
  801920:	89 c8                	mov    %ecx,%eax
  801922:	c1 f8 1f             	sar    $0x1f,%eax
  801925:	29 c2                	sub    %eax,%edx
  801927:	89 d0                	mov    %edx,%eax
  801929:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80192c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801930:	75 bb                	jne    8018ed <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801932:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801939:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80193c:	48                   	dec    %eax
  80193d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801940:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801944:	74 3d                	je     801983 <ltostr+0xc3>
		start = 1 ;
  801946:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80194d:	eb 34                	jmp    801983 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80194f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801952:	8b 45 0c             	mov    0xc(%ebp),%eax
  801955:	01 d0                	add    %edx,%eax
  801957:	8a 00                	mov    (%eax),%al
  801959:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80195c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80195f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801962:	01 c2                	add    %eax,%edx
  801964:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801967:	8b 45 0c             	mov    0xc(%ebp),%eax
  80196a:	01 c8                	add    %ecx,%eax
  80196c:	8a 00                	mov    (%eax),%al
  80196e:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801970:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801973:	8b 45 0c             	mov    0xc(%ebp),%eax
  801976:	01 c2                	add    %eax,%edx
  801978:	8a 45 eb             	mov    -0x15(%ebp),%al
  80197b:	88 02                	mov    %al,(%edx)
		start++ ;
  80197d:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801980:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801983:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801986:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801989:	7c c4                	jl     80194f <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80198b:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80198e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801991:	01 d0                	add    %edx,%eax
  801993:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801996:	90                   	nop
  801997:	c9                   	leave  
  801998:	c3                   	ret    

00801999 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801999:	55                   	push   %ebp
  80199a:	89 e5                	mov    %esp,%ebp
  80199c:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80199f:	ff 75 08             	pushl  0x8(%ebp)
  8019a2:	e8 c4 f9 ff ff       	call   80136b <strlen>
  8019a7:	83 c4 04             	add    $0x4,%esp
  8019aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8019ad:	ff 75 0c             	pushl  0xc(%ebp)
  8019b0:	e8 b6 f9 ff ff       	call   80136b <strlen>
  8019b5:	83 c4 04             	add    $0x4,%esp
  8019b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8019bb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8019c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8019c9:	eb 17                	jmp    8019e2 <strcconcat+0x49>
		final[s] = str1[s] ;
  8019cb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8019d1:	01 c2                	add    %eax,%edx
  8019d3:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8019d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d9:	01 c8                	add    %ecx,%eax
  8019db:	8a 00                	mov    (%eax),%al
  8019dd:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8019df:	ff 45 fc             	incl   -0x4(%ebp)
  8019e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019e5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8019e8:	7c e1                	jl     8019cb <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8019ea:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8019f1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8019f8:	eb 1f                	jmp    801a19 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8019fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019fd:	8d 50 01             	lea    0x1(%eax),%edx
  801a00:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801a03:	89 c2                	mov    %eax,%edx
  801a05:	8b 45 10             	mov    0x10(%ebp),%eax
  801a08:	01 c2                	add    %eax,%edx
  801a0a:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801a0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a10:	01 c8                	add    %ecx,%eax
  801a12:	8a 00                	mov    (%eax),%al
  801a14:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801a16:	ff 45 f8             	incl   -0x8(%ebp)
  801a19:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a1c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a1f:	7c d9                	jl     8019fa <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801a21:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a24:	8b 45 10             	mov    0x10(%ebp),%eax
  801a27:	01 d0                	add    %edx,%eax
  801a29:	c6 00 00             	movb   $0x0,(%eax)
}
  801a2c:	90                   	nop
  801a2d:	c9                   	leave  
  801a2e:	c3                   	ret    

00801a2f <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801a2f:	55                   	push   %ebp
  801a30:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801a32:	8b 45 14             	mov    0x14(%ebp),%eax
  801a35:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801a3b:	8b 45 14             	mov    0x14(%ebp),%eax
  801a3e:	8b 00                	mov    (%eax),%eax
  801a40:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a47:	8b 45 10             	mov    0x10(%ebp),%eax
  801a4a:	01 d0                	add    %edx,%eax
  801a4c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a52:	eb 0c                	jmp    801a60 <strsplit+0x31>
			*string++ = 0;
  801a54:	8b 45 08             	mov    0x8(%ebp),%eax
  801a57:	8d 50 01             	lea    0x1(%eax),%edx
  801a5a:	89 55 08             	mov    %edx,0x8(%ebp)
  801a5d:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a60:	8b 45 08             	mov    0x8(%ebp),%eax
  801a63:	8a 00                	mov    (%eax),%al
  801a65:	84 c0                	test   %al,%al
  801a67:	74 18                	je     801a81 <strsplit+0x52>
  801a69:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6c:	8a 00                	mov    (%eax),%al
  801a6e:	0f be c0             	movsbl %al,%eax
  801a71:	50                   	push   %eax
  801a72:	ff 75 0c             	pushl  0xc(%ebp)
  801a75:	e8 83 fa ff ff       	call   8014fd <strchr>
  801a7a:	83 c4 08             	add    $0x8,%esp
  801a7d:	85 c0                	test   %eax,%eax
  801a7f:	75 d3                	jne    801a54 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801a81:	8b 45 08             	mov    0x8(%ebp),%eax
  801a84:	8a 00                	mov    (%eax),%al
  801a86:	84 c0                	test   %al,%al
  801a88:	74 5a                	je     801ae4 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801a8a:	8b 45 14             	mov    0x14(%ebp),%eax
  801a8d:	8b 00                	mov    (%eax),%eax
  801a8f:	83 f8 0f             	cmp    $0xf,%eax
  801a92:	75 07                	jne    801a9b <strsplit+0x6c>
		{
			return 0;
  801a94:	b8 00 00 00 00       	mov    $0x0,%eax
  801a99:	eb 66                	jmp    801b01 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801a9b:	8b 45 14             	mov    0x14(%ebp),%eax
  801a9e:	8b 00                	mov    (%eax),%eax
  801aa0:	8d 48 01             	lea    0x1(%eax),%ecx
  801aa3:	8b 55 14             	mov    0x14(%ebp),%edx
  801aa6:	89 0a                	mov    %ecx,(%edx)
  801aa8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801aaf:	8b 45 10             	mov    0x10(%ebp),%eax
  801ab2:	01 c2                	add    %eax,%edx
  801ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab7:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801ab9:	eb 03                	jmp    801abe <strsplit+0x8f>
			string++;
  801abb:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801abe:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac1:	8a 00                	mov    (%eax),%al
  801ac3:	84 c0                	test   %al,%al
  801ac5:	74 8b                	je     801a52 <strsplit+0x23>
  801ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aca:	8a 00                	mov    (%eax),%al
  801acc:	0f be c0             	movsbl %al,%eax
  801acf:	50                   	push   %eax
  801ad0:	ff 75 0c             	pushl  0xc(%ebp)
  801ad3:	e8 25 fa ff ff       	call   8014fd <strchr>
  801ad8:	83 c4 08             	add    $0x8,%esp
  801adb:	85 c0                	test   %eax,%eax
  801add:	74 dc                	je     801abb <strsplit+0x8c>
			string++;
	}
  801adf:	e9 6e ff ff ff       	jmp    801a52 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801ae4:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801ae5:	8b 45 14             	mov    0x14(%ebp),%eax
  801ae8:	8b 00                	mov    (%eax),%eax
  801aea:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801af1:	8b 45 10             	mov    0x10(%ebp),%eax
  801af4:	01 d0                	add    %edx,%eax
  801af6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801afc:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801b01:	c9                   	leave  
  801b02:	c3                   	ret    

00801b03 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801b03:	55                   	push   %ebp
  801b04:	89 e5                	mov    %esp,%ebp
  801b06:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801b09:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801b0f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801b16:	eb 4a                	jmp    801b62 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801b18:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1e:	01 c2                	add    %eax,%edx
  801b20:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801b23:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b26:	01 c8                	add    %ecx,%eax
  801b28:	8a 00                	mov    (%eax),%al
  801b2a:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801b2c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b32:	01 d0                	add    %edx,%eax
  801b34:	8a 00                	mov    (%eax),%al
  801b36:	3c 40                	cmp    $0x40,%al
  801b38:	7e 25                	jle    801b5f <str2lower+0x5c>
  801b3a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b40:	01 d0                	add    %edx,%eax
  801b42:	8a 00                	mov    (%eax),%al
  801b44:	3c 5a                	cmp    $0x5a,%al
  801b46:	7f 17                	jg     801b5f <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801b48:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4e:	01 d0                	add    %edx,%eax
  801b50:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801b53:	8b 55 08             	mov    0x8(%ebp),%edx
  801b56:	01 ca                	add    %ecx,%edx
  801b58:	8a 12                	mov    (%edx),%dl
  801b5a:	83 c2 20             	add    $0x20,%edx
  801b5d:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801b5f:	ff 45 fc             	incl   -0x4(%ebp)
  801b62:	ff 75 0c             	pushl  0xc(%ebp)
  801b65:	e8 01 f8 ff ff       	call   80136b <strlen>
  801b6a:	83 c4 04             	add    $0x4,%esp
  801b6d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801b70:	7f a6                	jg     801b18 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801b72:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801b75:	c9                   	leave  
  801b76:	c3                   	ret    

00801b77 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801b77:	55                   	push   %ebp
  801b78:	89 e5                	mov    %esp,%ebp
  801b7a:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801b7d:	a1 08 40 80 00       	mov    0x804008,%eax
  801b82:	85 c0                	test   %eax,%eax
  801b84:	74 42                	je     801bc8 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801b86:	83 ec 08             	sub    $0x8,%esp
  801b89:	68 00 00 00 82       	push   $0x82000000
  801b8e:	68 00 00 00 80       	push   $0x80000000
  801b93:	e8 8c 07 00 00       	call   802324 <initialize_dynamic_allocator>
  801b98:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801b9b:	e8 e7 05 00 00       	call   802187 <sys_get_uheap_strategy>
  801ba0:	a3 60 c0 81 00       	mov    %eax,0x81c060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801ba5:	a1 40 40 80 00       	mov    0x804040,%eax
  801baa:	05 00 10 00 00       	add    $0x1000,%eax
  801baf:	a3 10 c1 81 00       	mov    %eax,0x81c110
		uheapPageAllocBreak = uheapPageAllocStart;
  801bb4:	a1 10 c1 81 00       	mov    0x81c110,%eax
  801bb9:	a3 68 c0 81 00       	mov    %eax,0x81c068

		__firstTimeFlag = 0;
  801bbe:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  801bc5:	00 00 00 
	}
}
  801bc8:	90                   	nop
  801bc9:	c9                   	leave  
  801bca:	c3                   	ret    

00801bcb <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801bcb:	55                   	push   %ebp
  801bcc:	89 e5                	mov    %esp,%ebp
  801bce:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801bd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bda:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801bdf:	83 ec 08             	sub    $0x8,%esp
  801be2:	68 06 04 00 00       	push   $0x406
  801be7:	50                   	push   %eax
  801be8:	e8 e4 01 00 00       	call   801dd1 <__sys_allocate_page>
  801bed:	83 c4 10             	add    $0x10,%esp
  801bf0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801bf3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801bf7:	79 14                	jns    801c0d <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801bf9:	83 ec 04             	sub    $0x4,%esp
  801bfc:	68 dc 2e 80 00       	push   $0x802edc
  801c01:	6a 1f                	push   $0x1f
  801c03:	68 18 2f 80 00       	push   $0x802f18
  801c08:	e8 af eb ff ff       	call   8007bc <_panic>
	return 0;
  801c0d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c12:	c9                   	leave  
  801c13:	c3                   	ret    

00801c14 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801c14:	55                   	push   %ebp
  801c15:	89 e5                	mov    %esp,%ebp
  801c17:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c23:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801c28:	83 ec 0c             	sub    $0xc,%esp
  801c2b:	50                   	push   %eax
  801c2c:	e8 e7 01 00 00       	call   801e18 <__sys_unmap_frame>
  801c31:	83 c4 10             	add    $0x10,%esp
  801c34:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801c37:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801c3b:	79 14                	jns    801c51 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801c3d:	83 ec 04             	sub    $0x4,%esp
  801c40:	68 24 2f 80 00       	push   $0x802f24
  801c45:	6a 2a                	push   $0x2a
  801c47:	68 18 2f 80 00       	push   $0x802f18
  801c4c:	e8 6b eb ff ff       	call   8007bc <_panic>
}
  801c51:	90                   	nop
  801c52:	c9                   	leave  
  801c53:	c3                   	ret    

00801c54 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801c54:	55                   	push   %ebp
  801c55:	89 e5                	mov    %esp,%ebp
  801c57:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801c5a:	e8 18 ff ff ff       	call   801b77 <uheap_init>
	if (size == 0) return NULL ;
  801c5f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801c63:	75 07                	jne    801c6c <malloc+0x18>
  801c65:	b8 00 00 00 00       	mov    $0x0,%eax
  801c6a:	eb 14                	jmp    801c80 <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  801c6c:	83 ec 04             	sub    $0x4,%esp
  801c6f:	68 64 2f 80 00       	push   $0x802f64
  801c74:	6a 3e                	push   $0x3e
  801c76:	68 18 2f 80 00       	push   $0x802f18
  801c7b:	e8 3c eb ff ff       	call   8007bc <_panic>
}
  801c80:	c9                   	leave  
  801c81:	c3                   	ret    

00801c82 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801c82:	55                   	push   %ebp
  801c83:	89 e5                	mov    %esp,%ebp
  801c85:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  801c88:	83 ec 04             	sub    $0x4,%esp
  801c8b:	68 8c 2f 80 00       	push   $0x802f8c
  801c90:	6a 49                	push   $0x49
  801c92:	68 18 2f 80 00       	push   $0x802f18
  801c97:	e8 20 eb ff ff       	call   8007bc <_panic>

00801c9c <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801c9c:	55                   	push   %ebp
  801c9d:	89 e5                	mov    %esp,%ebp
  801c9f:	83 ec 18             	sub    $0x18,%esp
  801ca2:	8b 45 10             	mov    0x10(%ebp),%eax
  801ca5:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801ca8:	e8 ca fe ff ff       	call   801b77 <uheap_init>
	if (size == 0) return NULL ;
  801cad:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801cb1:	75 07                	jne    801cba <smalloc+0x1e>
  801cb3:	b8 00 00 00 00       	mov    $0x0,%eax
  801cb8:	eb 14                	jmp    801cce <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  801cba:	83 ec 04             	sub    $0x4,%esp
  801cbd:	68 b0 2f 80 00       	push   $0x802fb0
  801cc2:	6a 5a                	push   $0x5a
  801cc4:	68 18 2f 80 00       	push   $0x802f18
  801cc9:	e8 ee ea ff ff       	call   8007bc <_panic>
}
  801cce:	c9                   	leave  
  801ccf:	c3                   	ret    

00801cd0 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801cd0:	55                   	push   %ebp
  801cd1:	89 e5                	mov    %esp,%ebp
  801cd3:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801cd6:	e8 9c fe ff ff       	call   801b77 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  801cdb:	83 ec 04             	sub    $0x4,%esp
  801cde:	68 d8 2f 80 00       	push   $0x802fd8
  801ce3:	6a 6a                	push   $0x6a
  801ce5:	68 18 2f 80 00       	push   $0x802f18
  801cea:	e8 cd ea ff ff       	call   8007bc <_panic>

00801cef <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801cef:	55                   	push   %ebp
  801cf0:	89 e5                	mov    %esp,%ebp
  801cf2:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801cf5:	e8 7d fe ff ff       	call   801b77 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  801cfa:	83 ec 04             	sub    $0x4,%esp
  801cfd:	68 fc 2f 80 00       	push   $0x802ffc
  801d02:	68 88 00 00 00       	push   $0x88
  801d07:	68 18 2f 80 00       	push   $0x802f18
  801d0c:	e8 ab ea ff ff       	call   8007bc <_panic>

00801d11 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  801d11:	55                   	push   %ebp
  801d12:	89 e5                	mov    %esp,%ebp
  801d14:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  801d17:	83 ec 04             	sub    $0x4,%esp
  801d1a:	68 24 30 80 00       	push   $0x803024
  801d1f:	68 9b 00 00 00       	push   $0x9b
  801d24:	68 18 2f 80 00       	push   $0x802f18
  801d29:	e8 8e ea ff ff       	call   8007bc <_panic>

00801d2e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801d2e:	55                   	push   %ebp
  801d2f:	89 e5                	mov    %esp,%ebp
  801d31:	57                   	push   %edi
  801d32:	56                   	push   %esi
  801d33:	53                   	push   %ebx
  801d34:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801d37:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d3d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d40:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d43:	8b 7d 18             	mov    0x18(%ebp),%edi
  801d46:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801d49:	cd 30                	int    $0x30
  801d4b:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801d4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801d51:	83 c4 10             	add    $0x10,%esp
  801d54:	5b                   	pop    %ebx
  801d55:	5e                   	pop    %esi
  801d56:	5f                   	pop    %edi
  801d57:	5d                   	pop    %ebp
  801d58:	c3                   	ret    

00801d59 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801d59:	55                   	push   %ebp
  801d5a:	89 e5                	mov    %esp,%ebp
  801d5c:	83 ec 04             	sub    $0x4,%esp
  801d5f:	8b 45 10             	mov    0x10(%ebp),%eax
  801d62:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801d65:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d68:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6f:	6a 00                	push   $0x0
  801d71:	51                   	push   %ecx
  801d72:	52                   	push   %edx
  801d73:	ff 75 0c             	pushl  0xc(%ebp)
  801d76:	50                   	push   %eax
  801d77:	6a 00                	push   $0x0
  801d79:	e8 b0 ff ff ff       	call   801d2e <syscall>
  801d7e:	83 c4 18             	add    $0x18,%esp
}
  801d81:	90                   	nop
  801d82:	c9                   	leave  
  801d83:	c3                   	ret    

00801d84 <sys_cgetc>:

int
sys_cgetc(void)
{
  801d84:	55                   	push   %ebp
  801d85:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801d87:	6a 00                	push   $0x0
  801d89:	6a 00                	push   $0x0
  801d8b:	6a 00                	push   $0x0
  801d8d:	6a 00                	push   $0x0
  801d8f:	6a 00                	push   $0x0
  801d91:	6a 02                	push   $0x2
  801d93:	e8 96 ff ff ff       	call   801d2e <syscall>
  801d98:	83 c4 18             	add    $0x18,%esp
}
  801d9b:	c9                   	leave  
  801d9c:	c3                   	ret    

00801d9d <sys_lock_cons>:

void sys_lock_cons(void)
{
  801d9d:	55                   	push   %ebp
  801d9e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801da0:	6a 00                	push   $0x0
  801da2:	6a 00                	push   $0x0
  801da4:	6a 00                	push   $0x0
  801da6:	6a 00                	push   $0x0
  801da8:	6a 00                	push   $0x0
  801daa:	6a 03                	push   $0x3
  801dac:	e8 7d ff ff ff       	call   801d2e <syscall>
  801db1:	83 c4 18             	add    $0x18,%esp
}
  801db4:	90                   	nop
  801db5:	c9                   	leave  
  801db6:	c3                   	ret    

00801db7 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801db7:	55                   	push   %ebp
  801db8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801dba:	6a 00                	push   $0x0
  801dbc:	6a 00                	push   $0x0
  801dbe:	6a 00                	push   $0x0
  801dc0:	6a 00                	push   $0x0
  801dc2:	6a 00                	push   $0x0
  801dc4:	6a 04                	push   $0x4
  801dc6:	e8 63 ff ff ff       	call   801d2e <syscall>
  801dcb:	83 c4 18             	add    $0x18,%esp
}
  801dce:	90                   	nop
  801dcf:	c9                   	leave  
  801dd0:	c3                   	ret    

00801dd1 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801dd1:	55                   	push   %ebp
  801dd2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801dd4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  801dda:	6a 00                	push   $0x0
  801ddc:	6a 00                	push   $0x0
  801dde:	6a 00                	push   $0x0
  801de0:	52                   	push   %edx
  801de1:	50                   	push   %eax
  801de2:	6a 08                	push   $0x8
  801de4:	e8 45 ff ff ff       	call   801d2e <syscall>
  801de9:	83 c4 18             	add    $0x18,%esp
}
  801dec:	c9                   	leave  
  801ded:	c3                   	ret    

00801dee <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801dee:	55                   	push   %ebp
  801def:	89 e5                	mov    %esp,%ebp
  801df1:	56                   	push   %esi
  801df2:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801df3:	8b 75 18             	mov    0x18(%ebp),%esi
  801df6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801df9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801dfc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dff:	8b 45 08             	mov    0x8(%ebp),%eax
  801e02:	56                   	push   %esi
  801e03:	53                   	push   %ebx
  801e04:	51                   	push   %ecx
  801e05:	52                   	push   %edx
  801e06:	50                   	push   %eax
  801e07:	6a 09                	push   $0x9
  801e09:	e8 20 ff ff ff       	call   801d2e <syscall>
  801e0e:	83 c4 18             	add    $0x18,%esp
}
  801e11:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e14:	5b                   	pop    %ebx
  801e15:	5e                   	pop    %esi
  801e16:	5d                   	pop    %ebp
  801e17:	c3                   	ret    

00801e18 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801e18:	55                   	push   %ebp
  801e19:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801e1b:	6a 00                	push   $0x0
  801e1d:	6a 00                	push   $0x0
  801e1f:	6a 00                	push   $0x0
  801e21:	6a 00                	push   $0x0
  801e23:	ff 75 08             	pushl  0x8(%ebp)
  801e26:	6a 0a                	push   $0xa
  801e28:	e8 01 ff ff ff       	call   801d2e <syscall>
  801e2d:	83 c4 18             	add    $0x18,%esp
}
  801e30:	c9                   	leave  
  801e31:	c3                   	ret    

00801e32 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801e32:	55                   	push   %ebp
  801e33:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801e35:	6a 00                	push   $0x0
  801e37:	6a 00                	push   $0x0
  801e39:	6a 00                	push   $0x0
  801e3b:	ff 75 0c             	pushl  0xc(%ebp)
  801e3e:	ff 75 08             	pushl  0x8(%ebp)
  801e41:	6a 0b                	push   $0xb
  801e43:	e8 e6 fe ff ff       	call   801d2e <syscall>
  801e48:	83 c4 18             	add    $0x18,%esp
}
  801e4b:	c9                   	leave  
  801e4c:	c3                   	ret    

00801e4d <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801e4d:	55                   	push   %ebp
  801e4e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801e50:	6a 00                	push   $0x0
  801e52:	6a 00                	push   $0x0
  801e54:	6a 00                	push   $0x0
  801e56:	6a 00                	push   $0x0
  801e58:	6a 00                	push   $0x0
  801e5a:	6a 0c                	push   $0xc
  801e5c:	e8 cd fe ff ff       	call   801d2e <syscall>
  801e61:	83 c4 18             	add    $0x18,%esp
}
  801e64:	c9                   	leave  
  801e65:	c3                   	ret    

00801e66 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801e66:	55                   	push   %ebp
  801e67:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801e69:	6a 00                	push   $0x0
  801e6b:	6a 00                	push   $0x0
  801e6d:	6a 00                	push   $0x0
  801e6f:	6a 00                	push   $0x0
  801e71:	6a 00                	push   $0x0
  801e73:	6a 0d                	push   $0xd
  801e75:	e8 b4 fe ff ff       	call   801d2e <syscall>
  801e7a:	83 c4 18             	add    $0x18,%esp
}
  801e7d:	c9                   	leave  
  801e7e:	c3                   	ret    

00801e7f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801e7f:	55                   	push   %ebp
  801e80:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801e82:	6a 00                	push   $0x0
  801e84:	6a 00                	push   $0x0
  801e86:	6a 00                	push   $0x0
  801e88:	6a 00                	push   $0x0
  801e8a:	6a 00                	push   $0x0
  801e8c:	6a 0e                	push   $0xe
  801e8e:	e8 9b fe ff ff       	call   801d2e <syscall>
  801e93:	83 c4 18             	add    $0x18,%esp
}
  801e96:	c9                   	leave  
  801e97:	c3                   	ret    

00801e98 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801e98:	55                   	push   %ebp
  801e99:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801e9b:	6a 00                	push   $0x0
  801e9d:	6a 00                	push   $0x0
  801e9f:	6a 00                	push   $0x0
  801ea1:	6a 00                	push   $0x0
  801ea3:	6a 00                	push   $0x0
  801ea5:	6a 0f                	push   $0xf
  801ea7:	e8 82 fe ff ff       	call   801d2e <syscall>
  801eac:	83 c4 18             	add    $0x18,%esp
}
  801eaf:	c9                   	leave  
  801eb0:	c3                   	ret    

00801eb1 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801eb1:	55                   	push   %ebp
  801eb2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801eb4:	6a 00                	push   $0x0
  801eb6:	6a 00                	push   $0x0
  801eb8:	6a 00                	push   $0x0
  801eba:	6a 00                	push   $0x0
  801ebc:	ff 75 08             	pushl  0x8(%ebp)
  801ebf:	6a 10                	push   $0x10
  801ec1:	e8 68 fe ff ff       	call   801d2e <syscall>
  801ec6:	83 c4 18             	add    $0x18,%esp
}
  801ec9:	c9                   	leave  
  801eca:	c3                   	ret    

00801ecb <sys_scarce_memory>:

void sys_scarce_memory()
{
  801ecb:	55                   	push   %ebp
  801ecc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801ece:	6a 00                	push   $0x0
  801ed0:	6a 00                	push   $0x0
  801ed2:	6a 00                	push   $0x0
  801ed4:	6a 00                	push   $0x0
  801ed6:	6a 00                	push   $0x0
  801ed8:	6a 11                	push   $0x11
  801eda:	e8 4f fe ff ff       	call   801d2e <syscall>
  801edf:	83 c4 18             	add    $0x18,%esp
}
  801ee2:	90                   	nop
  801ee3:	c9                   	leave  
  801ee4:	c3                   	ret    

00801ee5 <sys_cputc>:

void
sys_cputc(const char c)
{
  801ee5:	55                   	push   %ebp
  801ee6:	89 e5                	mov    %esp,%ebp
  801ee8:	83 ec 04             	sub    $0x4,%esp
  801eeb:	8b 45 08             	mov    0x8(%ebp),%eax
  801eee:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801ef1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ef5:	6a 00                	push   $0x0
  801ef7:	6a 00                	push   $0x0
  801ef9:	6a 00                	push   $0x0
  801efb:	6a 00                	push   $0x0
  801efd:	50                   	push   %eax
  801efe:	6a 01                	push   $0x1
  801f00:	e8 29 fe ff ff       	call   801d2e <syscall>
  801f05:	83 c4 18             	add    $0x18,%esp
}
  801f08:	90                   	nop
  801f09:	c9                   	leave  
  801f0a:	c3                   	ret    

00801f0b <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801f0b:	55                   	push   %ebp
  801f0c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801f0e:	6a 00                	push   $0x0
  801f10:	6a 00                	push   $0x0
  801f12:	6a 00                	push   $0x0
  801f14:	6a 00                	push   $0x0
  801f16:	6a 00                	push   $0x0
  801f18:	6a 14                	push   $0x14
  801f1a:	e8 0f fe ff ff       	call   801d2e <syscall>
  801f1f:	83 c4 18             	add    $0x18,%esp
}
  801f22:	90                   	nop
  801f23:	c9                   	leave  
  801f24:	c3                   	ret    

00801f25 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801f25:	55                   	push   %ebp
  801f26:	89 e5                	mov    %esp,%ebp
  801f28:	83 ec 04             	sub    $0x4,%esp
  801f2b:	8b 45 10             	mov    0x10(%ebp),%eax
  801f2e:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801f31:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801f34:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f38:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3b:	6a 00                	push   $0x0
  801f3d:	51                   	push   %ecx
  801f3e:	52                   	push   %edx
  801f3f:	ff 75 0c             	pushl  0xc(%ebp)
  801f42:	50                   	push   %eax
  801f43:	6a 15                	push   $0x15
  801f45:	e8 e4 fd ff ff       	call   801d2e <syscall>
  801f4a:	83 c4 18             	add    $0x18,%esp
}
  801f4d:	c9                   	leave  
  801f4e:	c3                   	ret    

00801f4f <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801f4f:	55                   	push   %ebp
  801f50:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801f52:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f55:	8b 45 08             	mov    0x8(%ebp),%eax
  801f58:	6a 00                	push   $0x0
  801f5a:	6a 00                	push   $0x0
  801f5c:	6a 00                	push   $0x0
  801f5e:	52                   	push   %edx
  801f5f:	50                   	push   %eax
  801f60:	6a 16                	push   $0x16
  801f62:	e8 c7 fd ff ff       	call   801d2e <syscall>
  801f67:	83 c4 18             	add    $0x18,%esp
}
  801f6a:	c9                   	leave  
  801f6b:	c3                   	ret    

00801f6c <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801f6c:	55                   	push   %ebp
  801f6d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801f6f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f72:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f75:	8b 45 08             	mov    0x8(%ebp),%eax
  801f78:	6a 00                	push   $0x0
  801f7a:	6a 00                	push   $0x0
  801f7c:	51                   	push   %ecx
  801f7d:	52                   	push   %edx
  801f7e:	50                   	push   %eax
  801f7f:	6a 17                	push   $0x17
  801f81:	e8 a8 fd ff ff       	call   801d2e <syscall>
  801f86:	83 c4 18             	add    $0x18,%esp
}
  801f89:	c9                   	leave  
  801f8a:	c3                   	ret    

00801f8b <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801f8b:	55                   	push   %ebp
  801f8c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801f8e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f91:	8b 45 08             	mov    0x8(%ebp),%eax
  801f94:	6a 00                	push   $0x0
  801f96:	6a 00                	push   $0x0
  801f98:	6a 00                	push   $0x0
  801f9a:	52                   	push   %edx
  801f9b:	50                   	push   %eax
  801f9c:	6a 18                	push   $0x18
  801f9e:	e8 8b fd ff ff       	call   801d2e <syscall>
  801fa3:	83 c4 18             	add    $0x18,%esp
}
  801fa6:	c9                   	leave  
  801fa7:	c3                   	ret    

00801fa8 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801fa8:	55                   	push   %ebp
  801fa9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801fab:	8b 45 08             	mov    0x8(%ebp),%eax
  801fae:	6a 00                	push   $0x0
  801fb0:	ff 75 14             	pushl  0x14(%ebp)
  801fb3:	ff 75 10             	pushl  0x10(%ebp)
  801fb6:	ff 75 0c             	pushl  0xc(%ebp)
  801fb9:	50                   	push   %eax
  801fba:	6a 19                	push   $0x19
  801fbc:	e8 6d fd ff ff       	call   801d2e <syscall>
  801fc1:	83 c4 18             	add    $0x18,%esp
}
  801fc4:	c9                   	leave  
  801fc5:	c3                   	ret    

00801fc6 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801fc6:	55                   	push   %ebp
  801fc7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801fc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fcc:	6a 00                	push   $0x0
  801fce:	6a 00                	push   $0x0
  801fd0:	6a 00                	push   $0x0
  801fd2:	6a 00                	push   $0x0
  801fd4:	50                   	push   %eax
  801fd5:	6a 1a                	push   $0x1a
  801fd7:	e8 52 fd ff ff       	call   801d2e <syscall>
  801fdc:	83 c4 18             	add    $0x18,%esp
}
  801fdf:	90                   	nop
  801fe0:	c9                   	leave  
  801fe1:	c3                   	ret    

00801fe2 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801fe2:	55                   	push   %ebp
  801fe3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe8:	6a 00                	push   $0x0
  801fea:	6a 00                	push   $0x0
  801fec:	6a 00                	push   $0x0
  801fee:	6a 00                	push   $0x0
  801ff0:	50                   	push   %eax
  801ff1:	6a 1b                	push   $0x1b
  801ff3:	e8 36 fd ff ff       	call   801d2e <syscall>
  801ff8:	83 c4 18             	add    $0x18,%esp
}
  801ffb:	c9                   	leave  
  801ffc:	c3                   	ret    

00801ffd <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ffd:	55                   	push   %ebp
  801ffe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802000:	6a 00                	push   $0x0
  802002:	6a 00                	push   $0x0
  802004:	6a 00                	push   $0x0
  802006:	6a 00                	push   $0x0
  802008:	6a 00                	push   $0x0
  80200a:	6a 05                	push   $0x5
  80200c:	e8 1d fd ff ff       	call   801d2e <syscall>
  802011:	83 c4 18             	add    $0x18,%esp
}
  802014:	c9                   	leave  
  802015:	c3                   	ret    

00802016 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802016:	55                   	push   %ebp
  802017:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802019:	6a 00                	push   $0x0
  80201b:	6a 00                	push   $0x0
  80201d:	6a 00                	push   $0x0
  80201f:	6a 00                	push   $0x0
  802021:	6a 00                	push   $0x0
  802023:	6a 06                	push   $0x6
  802025:	e8 04 fd ff ff       	call   801d2e <syscall>
  80202a:	83 c4 18             	add    $0x18,%esp
}
  80202d:	c9                   	leave  
  80202e:	c3                   	ret    

0080202f <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80202f:	55                   	push   %ebp
  802030:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802032:	6a 00                	push   $0x0
  802034:	6a 00                	push   $0x0
  802036:	6a 00                	push   $0x0
  802038:	6a 00                	push   $0x0
  80203a:	6a 00                	push   $0x0
  80203c:	6a 07                	push   $0x7
  80203e:	e8 eb fc ff ff       	call   801d2e <syscall>
  802043:	83 c4 18             	add    $0x18,%esp
}
  802046:	c9                   	leave  
  802047:	c3                   	ret    

00802048 <sys_exit_env>:


void sys_exit_env(void)
{
  802048:	55                   	push   %ebp
  802049:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80204b:	6a 00                	push   $0x0
  80204d:	6a 00                	push   $0x0
  80204f:	6a 00                	push   $0x0
  802051:	6a 00                	push   $0x0
  802053:	6a 00                	push   $0x0
  802055:	6a 1c                	push   $0x1c
  802057:	e8 d2 fc ff ff       	call   801d2e <syscall>
  80205c:	83 c4 18             	add    $0x18,%esp
}
  80205f:	90                   	nop
  802060:	c9                   	leave  
  802061:	c3                   	ret    

00802062 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802062:	55                   	push   %ebp
  802063:	89 e5                	mov    %esp,%ebp
  802065:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802068:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80206b:	8d 50 04             	lea    0x4(%eax),%edx
  80206e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802071:	6a 00                	push   $0x0
  802073:	6a 00                	push   $0x0
  802075:	6a 00                	push   $0x0
  802077:	52                   	push   %edx
  802078:	50                   	push   %eax
  802079:	6a 1d                	push   $0x1d
  80207b:	e8 ae fc ff ff       	call   801d2e <syscall>
  802080:	83 c4 18             	add    $0x18,%esp
	return result;
  802083:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802086:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802089:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80208c:	89 01                	mov    %eax,(%ecx)
  80208e:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802091:	8b 45 08             	mov    0x8(%ebp),%eax
  802094:	c9                   	leave  
  802095:	c2 04 00             	ret    $0x4

00802098 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802098:	55                   	push   %ebp
  802099:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80209b:	6a 00                	push   $0x0
  80209d:	6a 00                	push   $0x0
  80209f:	ff 75 10             	pushl  0x10(%ebp)
  8020a2:	ff 75 0c             	pushl  0xc(%ebp)
  8020a5:	ff 75 08             	pushl  0x8(%ebp)
  8020a8:	6a 13                	push   $0x13
  8020aa:	e8 7f fc ff ff       	call   801d2e <syscall>
  8020af:	83 c4 18             	add    $0x18,%esp
	return ;
  8020b2:	90                   	nop
}
  8020b3:	c9                   	leave  
  8020b4:	c3                   	ret    

008020b5 <sys_rcr2>:
uint32 sys_rcr2()
{
  8020b5:	55                   	push   %ebp
  8020b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8020b8:	6a 00                	push   $0x0
  8020ba:	6a 00                	push   $0x0
  8020bc:	6a 00                	push   $0x0
  8020be:	6a 00                	push   $0x0
  8020c0:	6a 00                	push   $0x0
  8020c2:	6a 1e                	push   $0x1e
  8020c4:	e8 65 fc ff ff       	call   801d2e <syscall>
  8020c9:	83 c4 18             	add    $0x18,%esp
}
  8020cc:	c9                   	leave  
  8020cd:	c3                   	ret    

008020ce <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8020ce:	55                   	push   %ebp
  8020cf:	89 e5                	mov    %esp,%ebp
  8020d1:	83 ec 04             	sub    $0x4,%esp
  8020d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8020da:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8020de:	6a 00                	push   $0x0
  8020e0:	6a 00                	push   $0x0
  8020e2:	6a 00                	push   $0x0
  8020e4:	6a 00                	push   $0x0
  8020e6:	50                   	push   %eax
  8020e7:	6a 1f                	push   $0x1f
  8020e9:	e8 40 fc ff ff       	call   801d2e <syscall>
  8020ee:	83 c4 18             	add    $0x18,%esp
	return ;
  8020f1:	90                   	nop
}
  8020f2:	c9                   	leave  
  8020f3:	c3                   	ret    

008020f4 <rsttst>:
void rsttst()
{
  8020f4:	55                   	push   %ebp
  8020f5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8020f7:	6a 00                	push   $0x0
  8020f9:	6a 00                	push   $0x0
  8020fb:	6a 00                	push   $0x0
  8020fd:	6a 00                	push   $0x0
  8020ff:	6a 00                	push   $0x0
  802101:	6a 21                	push   $0x21
  802103:	e8 26 fc ff ff       	call   801d2e <syscall>
  802108:	83 c4 18             	add    $0x18,%esp
	return ;
  80210b:	90                   	nop
}
  80210c:	c9                   	leave  
  80210d:	c3                   	ret    

0080210e <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80210e:	55                   	push   %ebp
  80210f:	89 e5                	mov    %esp,%ebp
  802111:	83 ec 04             	sub    $0x4,%esp
  802114:	8b 45 14             	mov    0x14(%ebp),%eax
  802117:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80211a:	8b 55 18             	mov    0x18(%ebp),%edx
  80211d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802121:	52                   	push   %edx
  802122:	50                   	push   %eax
  802123:	ff 75 10             	pushl  0x10(%ebp)
  802126:	ff 75 0c             	pushl  0xc(%ebp)
  802129:	ff 75 08             	pushl  0x8(%ebp)
  80212c:	6a 20                	push   $0x20
  80212e:	e8 fb fb ff ff       	call   801d2e <syscall>
  802133:	83 c4 18             	add    $0x18,%esp
	return ;
  802136:	90                   	nop
}
  802137:	c9                   	leave  
  802138:	c3                   	ret    

00802139 <chktst>:
void chktst(uint32 n)
{
  802139:	55                   	push   %ebp
  80213a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80213c:	6a 00                	push   $0x0
  80213e:	6a 00                	push   $0x0
  802140:	6a 00                	push   $0x0
  802142:	6a 00                	push   $0x0
  802144:	ff 75 08             	pushl  0x8(%ebp)
  802147:	6a 22                	push   $0x22
  802149:	e8 e0 fb ff ff       	call   801d2e <syscall>
  80214e:	83 c4 18             	add    $0x18,%esp
	return ;
  802151:	90                   	nop
}
  802152:	c9                   	leave  
  802153:	c3                   	ret    

00802154 <inctst>:

void inctst()
{
  802154:	55                   	push   %ebp
  802155:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802157:	6a 00                	push   $0x0
  802159:	6a 00                	push   $0x0
  80215b:	6a 00                	push   $0x0
  80215d:	6a 00                	push   $0x0
  80215f:	6a 00                	push   $0x0
  802161:	6a 23                	push   $0x23
  802163:	e8 c6 fb ff ff       	call   801d2e <syscall>
  802168:	83 c4 18             	add    $0x18,%esp
	return ;
  80216b:	90                   	nop
}
  80216c:	c9                   	leave  
  80216d:	c3                   	ret    

0080216e <gettst>:
uint32 gettst()
{
  80216e:	55                   	push   %ebp
  80216f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802171:	6a 00                	push   $0x0
  802173:	6a 00                	push   $0x0
  802175:	6a 00                	push   $0x0
  802177:	6a 00                	push   $0x0
  802179:	6a 00                	push   $0x0
  80217b:	6a 24                	push   $0x24
  80217d:	e8 ac fb ff ff       	call   801d2e <syscall>
  802182:	83 c4 18             	add    $0x18,%esp
}
  802185:	c9                   	leave  
  802186:	c3                   	ret    

00802187 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  802187:	55                   	push   %ebp
  802188:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80218a:	6a 00                	push   $0x0
  80218c:	6a 00                	push   $0x0
  80218e:	6a 00                	push   $0x0
  802190:	6a 00                	push   $0x0
  802192:	6a 00                	push   $0x0
  802194:	6a 25                	push   $0x25
  802196:	e8 93 fb ff ff       	call   801d2e <syscall>
  80219b:	83 c4 18             	add    $0x18,%esp
  80219e:	a3 60 c0 81 00       	mov    %eax,0x81c060
	return uheapPlaceStrategy ;
  8021a3:	a1 60 c0 81 00       	mov    0x81c060,%eax
}
  8021a8:	c9                   	leave  
  8021a9:	c3                   	ret    

008021aa <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8021aa:	55                   	push   %ebp
  8021ab:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8021ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b0:	a3 60 c0 81 00       	mov    %eax,0x81c060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8021b5:	6a 00                	push   $0x0
  8021b7:	6a 00                	push   $0x0
  8021b9:	6a 00                	push   $0x0
  8021bb:	6a 00                	push   $0x0
  8021bd:	ff 75 08             	pushl  0x8(%ebp)
  8021c0:	6a 26                	push   $0x26
  8021c2:	e8 67 fb ff ff       	call   801d2e <syscall>
  8021c7:	83 c4 18             	add    $0x18,%esp
	return ;
  8021ca:	90                   	nop
}
  8021cb:	c9                   	leave  
  8021cc:	c3                   	ret    

008021cd <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8021cd:	55                   	push   %ebp
  8021ce:	89 e5                	mov    %esp,%ebp
  8021d0:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8021d1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8021d4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021da:	8b 45 08             	mov    0x8(%ebp),%eax
  8021dd:	6a 00                	push   $0x0
  8021df:	53                   	push   %ebx
  8021e0:	51                   	push   %ecx
  8021e1:	52                   	push   %edx
  8021e2:	50                   	push   %eax
  8021e3:	6a 27                	push   $0x27
  8021e5:	e8 44 fb ff ff       	call   801d2e <syscall>
  8021ea:	83 c4 18             	add    $0x18,%esp
}
  8021ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021f0:	c9                   	leave  
  8021f1:	c3                   	ret    

008021f2 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8021f2:	55                   	push   %ebp
  8021f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8021f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fb:	6a 00                	push   $0x0
  8021fd:	6a 00                	push   $0x0
  8021ff:	6a 00                	push   $0x0
  802201:	52                   	push   %edx
  802202:	50                   	push   %eax
  802203:	6a 28                	push   $0x28
  802205:	e8 24 fb ff ff       	call   801d2e <syscall>
  80220a:	83 c4 18             	add    $0x18,%esp
}
  80220d:	c9                   	leave  
  80220e:	c3                   	ret    

0080220f <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80220f:	55                   	push   %ebp
  802210:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802212:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802215:	8b 55 0c             	mov    0xc(%ebp),%edx
  802218:	8b 45 08             	mov    0x8(%ebp),%eax
  80221b:	6a 00                	push   $0x0
  80221d:	51                   	push   %ecx
  80221e:	ff 75 10             	pushl  0x10(%ebp)
  802221:	52                   	push   %edx
  802222:	50                   	push   %eax
  802223:	6a 29                	push   $0x29
  802225:	e8 04 fb ff ff       	call   801d2e <syscall>
  80222a:	83 c4 18             	add    $0x18,%esp
}
  80222d:	c9                   	leave  
  80222e:	c3                   	ret    

0080222f <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80222f:	55                   	push   %ebp
  802230:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802232:	6a 00                	push   $0x0
  802234:	6a 00                	push   $0x0
  802236:	ff 75 10             	pushl  0x10(%ebp)
  802239:	ff 75 0c             	pushl  0xc(%ebp)
  80223c:	ff 75 08             	pushl  0x8(%ebp)
  80223f:	6a 12                	push   $0x12
  802241:	e8 e8 fa ff ff       	call   801d2e <syscall>
  802246:	83 c4 18             	add    $0x18,%esp
	return ;
  802249:	90                   	nop
}
  80224a:	c9                   	leave  
  80224b:	c3                   	ret    

0080224c <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80224c:	55                   	push   %ebp
  80224d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80224f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802252:	8b 45 08             	mov    0x8(%ebp),%eax
  802255:	6a 00                	push   $0x0
  802257:	6a 00                	push   $0x0
  802259:	6a 00                	push   $0x0
  80225b:	52                   	push   %edx
  80225c:	50                   	push   %eax
  80225d:	6a 2a                	push   $0x2a
  80225f:	e8 ca fa ff ff       	call   801d2e <syscall>
  802264:	83 c4 18             	add    $0x18,%esp
	return;
  802267:	90                   	nop
}
  802268:	c9                   	leave  
  802269:	c3                   	ret    

0080226a <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  80226a:	55                   	push   %ebp
  80226b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  80226d:	6a 00                	push   $0x0
  80226f:	6a 00                	push   $0x0
  802271:	6a 00                	push   $0x0
  802273:	6a 00                	push   $0x0
  802275:	6a 00                	push   $0x0
  802277:	6a 2b                	push   $0x2b
  802279:	e8 b0 fa ff ff       	call   801d2e <syscall>
  80227e:	83 c4 18             	add    $0x18,%esp
}
  802281:	c9                   	leave  
  802282:	c3                   	ret    

00802283 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802283:	55                   	push   %ebp
  802284:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802286:	6a 00                	push   $0x0
  802288:	6a 00                	push   $0x0
  80228a:	6a 00                	push   $0x0
  80228c:	ff 75 0c             	pushl  0xc(%ebp)
  80228f:	ff 75 08             	pushl  0x8(%ebp)
  802292:	6a 2d                	push   $0x2d
  802294:	e8 95 fa ff ff       	call   801d2e <syscall>
  802299:	83 c4 18             	add    $0x18,%esp
	return;
  80229c:	90                   	nop
}
  80229d:	c9                   	leave  
  80229e:	c3                   	ret    

0080229f <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80229f:	55                   	push   %ebp
  8022a0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8022a2:	6a 00                	push   $0x0
  8022a4:	6a 00                	push   $0x0
  8022a6:	6a 00                	push   $0x0
  8022a8:	ff 75 0c             	pushl  0xc(%ebp)
  8022ab:	ff 75 08             	pushl  0x8(%ebp)
  8022ae:	6a 2c                	push   $0x2c
  8022b0:	e8 79 fa ff ff       	call   801d2e <syscall>
  8022b5:	83 c4 18             	add    $0x18,%esp
	return ;
  8022b8:	90                   	nop
}
  8022b9:	c9                   	leave  
  8022ba:	c3                   	ret    

008022bb <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8022bb:	55                   	push   %ebp
  8022bc:	89 e5                	mov    %esp,%ebp
  8022be:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  8022c1:	83 ec 04             	sub    $0x4,%esp
  8022c4:	68 48 30 80 00       	push   $0x803048
  8022c9:	68 25 01 00 00       	push   $0x125
  8022ce:	68 7b 30 80 00       	push   $0x80307b
  8022d3:	e8 e4 e4 ff ff       	call   8007bc <_panic>

008022d8 <to_page_va>:
//==================================================================================//
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  8022d8:	55                   	push   %ebp
  8022d9:	89 e5                	mov    %esp,%ebp
  8022db:	83 ec 10             	sub    $0x10,%esp
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  8022de:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e1:	ba 60 40 80 00       	mov    $0x804060,%edx
  8022e6:	29 d0                	sub    %edx,%eax
  8022e8:	c1 f8 02             	sar    $0x2,%eax
  8022eb:	89 c2                	mov    %eax,%edx
  8022ed:	89 d0                	mov    %edx,%eax
  8022ef:	c1 e0 02             	shl    $0x2,%eax
  8022f2:	01 d0                	add    %edx,%eax
  8022f4:	c1 e0 02             	shl    $0x2,%eax
  8022f7:	01 d0                	add    %edx,%eax
  8022f9:	c1 e0 02             	shl    $0x2,%eax
  8022fc:	01 d0                	add    %edx,%eax
  8022fe:	89 c1                	mov    %eax,%ecx
  802300:	c1 e1 08             	shl    $0x8,%ecx
  802303:	01 c8                	add    %ecx,%eax
  802305:	89 c1                	mov    %eax,%ecx
  802307:	c1 e1 10             	shl    $0x10,%ecx
  80230a:	01 c8                	add    %ecx,%eax
  80230c:	01 c0                	add    %eax,%eax
  80230e:	01 d0                	add    %edx,%eax
  802310:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  802313:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802316:	c1 e0 0c             	shl    $0xc,%eax
  802319:	89 c2                	mov    %eax,%edx
  80231b:	a1 64 c0 81 00       	mov    0x81c064,%eax
  802320:	01 d0                	add    %edx,%eax
}
  802322:	c9                   	leave  
  802323:	c3                   	ret    

00802324 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  802324:	55                   	push   %ebp
  802325:	89 e5                	mov    %esp,%ebp
  802327:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  80232a:	8b 45 08             	mov    0x8(%ebp),%eax
  80232d:	05 00 00 00 02       	add    $0x2000000,%eax
  802332:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802335:	73 16                	jae    80234d <initialize_dynamic_allocator+0x29>
  802337:	68 8c 30 80 00       	push   $0x80308c
  80233c:	68 b2 30 80 00       	push   $0x8030b2
  802341:	6a 26                	push   $0x26
  802343:	68 c7 30 80 00       	push   $0x8030c7
  802348:	e8 6f e4 ff ff       	call   8007bc <_panic>
		is_initialized = 1;
  80234d:	c7 05 28 40 80 00 01 	movl   $0x1,0x804028
  802354:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	//Comment the following line
	panic("initialize_dynamic_allocator() Not implemented yet");
  802357:	83 ec 04             	sub    $0x4,%esp
  80235a:	68 e0 30 80 00       	push   $0x8030e0
  80235f:	6a 2e                	push   $0x2e
  802361:	68 c7 30 80 00       	push   $0x8030c7
  802366:	e8 51 e4 ff ff       	call   8007bc <_panic>

0080236b <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  80236b:	55                   	push   %ebp
  80236c:	89 e5                	mov    %esp,%ebp
  80236e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	//Comment the following line
	panic("get_block_size() Not implemented yet");
  802371:	83 ec 04             	sub    $0x4,%esp
  802374:	68 14 31 80 00       	push   $0x803114
  802379:	6a 3a                	push   $0x3a
  80237b:	68 c7 30 80 00       	push   $0x8030c7
  802380:	e8 37 e4 ff ff       	call   8007bc <_panic>

00802385 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  802385:	55                   	push   %ebp
  802386:	89 e5                	mov    %esp,%ebp
  802388:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  80238b:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802392:	76 16                	jbe    8023aa <alloc_block+0x25>
  802394:	68 3c 31 80 00       	push   $0x80313c
  802399:	68 b2 30 80 00       	push   $0x8030b2
  80239e:	6a 46                	push   $0x46
  8023a0:	68 c7 30 80 00       	push   $0x8030c7
  8023a5:	e8 12 e4 ff ff       	call   8007bc <_panic>
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	panic("alloc_block() Not implemented yet");
  8023aa:	83 ec 04             	sub    $0x4,%esp
  8023ad:	68 60 31 80 00       	push   $0x803160
  8023b2:	6a 4d                	push   $0x4d
  8023b4:	68 c7 30 80 00       	push   $0x8030c7
  8023b9:	e8 fe e3 ff ff       	call   8007bc <_panic>

008023be <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  8023be:	55                   	push   %ebp
  8023bf:	89 e5                	mov    %esp,%ebp
  8023c1:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  8023c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8023c7:	a1 64 c0 81 00       	mov    0x81c064,%eax
  8023cc:	39 c2                	cmp    %eax,%edx
  8023ce:	72 0c                	jb     8023dc <free_block+0x1e>
  8023d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8023d3:	a1 40 40 80 00       	mov    0x804040,%eax
  8023d8:	39 c2                	cmp    %eax,%edx
  8023da:	72 16                	jb     8023f2 <free_block+0x34>
  8023dc:	68 84 31 80 00       	push   $0x803184
  8023e1:	68 b2 30 80 00       	push   $0x8030b2
  8023e6:	6a 5b                	push   $0x5b
  8023e8:	68 c7 30 80 00       	push   $0x8030c7
  8023ed:	e8 ca e3 ff ff       	call   8007bc <_panic>
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	panic("free_block() Not implemented yet");
  8023f2:	83 ec 04             	sub    $0x4,%esp
  8023f5:	68 bc 31 80 00       	push   $0x8031bc
  8023fa:	6a 63                	push   $0x63
  8023fc:	68 c7 30 80 00       	push   $0x8030c7
  802401:	e8 b6 e3 ff ff       	call   8007bc <_panic>

00802406 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  802406:	55                   	push   %ebp
  802407:	89 e5                	mov    %esp,%ebp
  802409:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  80240c:	83 ec 04             	sub    $0x4,%esp
  80240f:	68 e0 31 80 00       	push   $0x8031e0
  802414:	6a 72                	push   $0x72
  802416:	68 c7 30 80 00       	push   $0x8030c7
  80241b:	e8 9c e3 ff ff       	call   8007bc <_panic>

00802420 <__udivdi3>:
  802420:	55                   	push   %ebp
  802421:	57                   	push   %edi
  802422:	56                   	push   %esi
  802423:	53                   	push   %ebx
  802424:	83 ec 1c             	sub    $0x1c,%esp
  802427:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80242b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80242f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802433:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802437:	89 ca                	mov    %ecx,%edx
  802439:	89 f8                	mov    %edi,%eax
  80243b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80243f:	85 f6                	test   %esi,%esi
  802441:	75 2d                	jne    802470 <__udivdi3+0x50>
  802443:	39 cf                	cmp    %ecx,%edi
  802445:	77 65                	ja     8024ac <__udivdi3+0x8c>
  802447:	89 fd                	mov    %edi,%ebp
  802449:	85 ff                	test   %edi,%edi
  80244b:	75 0b                	jne    802458 <__udivdi3+0x38>
  80244d:	b8 01 00 00 00       	mov    $0x1,%eax
  802452:	31 d2                	xor    %edx,%edx
  802454:	f7 f7                	div    %edi
  802456:	89 c5                	mov    %eax,%ebp
  802458:	31 d2                	xor    %edx,%edx
  80245a:	89 c8                	mov    %ecx,%eax
  80245c:	f7 f5                	div    %ebp
  80245e:	89 c1                	mov    %eax,%ecx
  802460:	89 d8                	mov    %ebx,%eax
  802462:	f7 f5                	div    %ebp
  802464:	89 cf                	mov    %ecx,%edi
  802466:	89 fa                	mov    %edi,%edx
  802468:	83 c4 1c             	add    $0x1c,%esp
  80246b:	5b                   	pop    %ebx
  80246c:	5e                   	pop    %esi
  80246d:	5f                   	pop    %edi
  80246e:	5d                   	pop    %ebp
  80246f:	c3                   	ret    
  802470:	39 ce                	cmp    %ecx,%esi
  802472:	77 28                	ja     80249c <__udivdi3+0x7c>
  802474:	0f bd fe             	bsr    %esi,%edi
  802477:	83 f7 1f             	xor    $0x1f,%edi
  80247a:	75 40                	jne    8024bc <__udivdi3+0x9c>
  80247c:	39 ce                	cmp    %ecx,%esi
  80247e:	72 0a                	jb     80248a <__udivdi3+0x6a>
  802480:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802484:	0f 87 9e 00 00 00    	ja     802528 <__udivdi3+0x108>
  80248a:	b8 01 00 00 00       	mov    $0x1,%eax
  80248f:	89 fa                	mov    %edi,%edx
  802491:	83 c4 1c             	add    $0x1c,%esp
  802494:	5b                   	pop    %ebx
  802495:	5e                   	pop    %esi
  802496:	5f                   	pop    %edi
  802497:	5d                   	pop    %ebp
  802498:	c3                   	ret    
  802499:	8d 76 00             	lea    0x0(%esi),%esi
  80249c:	31 ff                	xor    %edi,%edi
  80249e:	31 c0                	xor    %eax,%eax
  8024a0:	89 fa                	mov    %edi,%edx
  8024a2:	83 c4 1c             	add    $0x1c,%esp
  8024a5:	5b                   	pop    %ebx
  8024a6:	5e                   	pop    %esi
  8024a7:	5f                   	pop    %edi
  8024a8:	5d                   	pop    %ebp
  8024a9:	c3                   	ret    
  8024aa:	66 90                	xchg   %ax,%ax
  8024ac:	89 d8                	mov    %ebx,%eax
  8024ae:	f7 f7                	div    %edi
  8024b0:	31 ff                	xor    %edi,%edi
  8024b2:	89 fa                	mov    %edi,%edx
  8024b4:	83 c4 1c             	add    $0x1c,%esp
  8024b7:	5b                   	pop    %ebx
  8024b8:	5e                   	pop    %esi
  8024b9:	5f                   	pop    %edi
  8024ba:	5d                   	pop    %ebp
  8024bb:	c3                   	ret    
  8024bc:	bd 20 00 00 00       	mov    $0x20,%ebp
  8024c1:	89 eb                	mov    %ebp,%ebx
  8024c3:	29 fb                	sub    %edi,%ebx
  8024c5:	89 f9                	mov    %edi,%ecx
  8024c7:	d3 e6                	shl    %cl,%esi
  8024c9:	89 c5                	mov    %eax,%ebp
  8024cb:	88 d9                	mov    %bl,%cl
  8024cd:	d3 ed                	shr    %cl,%ebp
  8024cf:	89 e9                	mov    %ebp,%ecx
  8024d1:	09 f1                	or     %esi,%ecx
  8024d3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8024d7:	89 f9                	mov    %edi,%ecx
  8024d9:	d3 e0                	shl    %cl,%eax
  8024db:	89 c5                	mov    %eax,%ebp
  8024dd:	89 d6                	mov    %edx,%esi
  8024df:	88 d9                	mov    %bl,%cl
  8024e1:	d3 ee                	shr    %cl,%esi
  8024e3:	89 f9                	mov    %edi,%ecx
  8024e5:	d3 e2                	shl    %cl,%edx
  8024e7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8024eb:	88 d9                	mov    %bl,%cl
  8024ed:	d3 e8                	shr    %cl,%eax
  8024ef:	09 c2                	or     %eax,%edx
  8024f1:	89 d0                	mov    %edx,%eax
  8024f3:	89 f2                	mov    %esi,%edx
  8024f5:	f7 74 24 0c          	divl   0xc(%esp)
  8024f9:	89 d6                	mov    %edx,%esi
  8024fb:	89 c3                	mov    %eax,%ebx
  8024fd:	f7 e5                	mul    %ebp
  8024ff:	39 d6                	cmp    %edx,%esi
  802501:	72 19                	jb     80251c <__udivdi3+0xfc>
  802503:	74 0b                	je     802510 <__udivdi3+0xf0>
  802505:	89 d8                	mov    %ebx,%eax
  802507:	31 ff                	xor    %edi,%edi
  802509:	e9 58 ff ff ff       	jmp    802466 <__udivdi3+0x46>
  80250e:	66 90                	xchg   %ax,%ax
  802510:	8b 54 24 08          	mov    0x8(%esp),%edx
  802514:	89 f9                	mov    %edi,%ecx
  802516:	d3 e2                	shl    %cl,%edx
  802518:	39 c2                	cmp    %eax,%edx
  80251a:	73 e9                	jae    802505 <__udivdi3+0xe5>
  80251c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80251f:	31 ff                	xor    %edi,%edi
  802521:	e9 40 ff ff ff       	jmp    802466 <__udivdi3+0x46>
  802526:	66 90                	xchg   %ax,%ax
  802528:	31 c0                	xor    %eax,%eax
  80252a:	e9 37 ff ff ff       	jmp    802466 <__udivdi3+0x46>
  80252f:	90                   	nop

00802530 <__umoddi3>:
  802530:	55                   	push   %ebp
  802531:	57                   	push   %edi
  802532:	56                   	push   %esi
  802533:	53                   	push   %ebx
  802534:	83 ec 1c             	sub    $0x1c,%esp
  802537:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80253b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80253f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802543:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802547:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80254b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80254f:	89 f3                	mov    %esi,%ebx
  802551:	89 fa                	mov    %edi,%edx
  802553:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802557:	89 34 24             	mov    %esi,(%esp)
  80255a:	85 c0                	test   %eax,%eax
  80255c:	75 1a                	jne    802578 <__umoddi3+0x48>
  80255e:	39 f7                	cmp    %esi,%edi
  802560:	0f 86 a2 00 00 00    	jbe    802608 <__umoddi3+0xd8>
  802566:	89 c8                	mov    %ecx,%eax
  802568:	89 f2                	mov    %esi,%edx
  80256a:	f7 f7                	div    %edi
  80256c:	89 d0                	mov    %edx,%eax
  80256e:	31 d2                	xor    %edx,%edx
  802570:	83 c4 1c             	add    $0x1c,%esp
  802573:	5b                   	pop    %ebx
  802574:	5e                   	pop    %esi
  802575:	5f                   	pop    %edi
  802576:	5d                   	pop    %ebp
  802577:	c3                   	ret    
  802578:	39 f0                	cmp    %esi,%eax
  80257a:	0f 87 ac 00 00 00    	ja     80262c <__umoddi3+0xfc>
  802580:	0f bd e8             	bsr    %eax,%ebp
  802583:	83 f5 1f             	xor    $0x1f,%ebp
  802586:	0f 84 ac 00 00 00    	je     802638 <__umoddi3+0x108>
  80258c:	bf 20 00 00 00       	mov    $0x20,%edi
  802591:	29 ef                	sub    %ebp,%edi
  802593:	89 fe                	mov    %edi,%esi
  802595:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802599:	89 e9                	mov    %ebp,%ecx
  80259b:	d3 e0                	shl    %cl,%eax
  80259d:	89 d7                	mov    %edx,%edi
  80259f:	89 f1                	mov    %esi,%ecx
  8025a1:	d3 ef                	shr    %cl,%edi
  8025a3:	09 c7                	or     %eax,%edi
  8025a5:	89 e9                	mov    %ebp,%ecx
  8025a7:	d3 e2                	shl    %cl,%edx
  8025a9:	89 14 24             	mov    %edx,(%esp)
  8025ac:	89 d8                	mov    %ebx,%eax
  8025ae:	d3 e0                	shl    %cl,%eax
  8025b0:	89 c2                	mov    %eax,%edx
  8025b2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8025b6:	d3 e0                	shl    %cl,%eax
  8025b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025bc:	8b 44 24 08          	mov    0x8(%esp),%eax
  8025c0:	89 f1                	mov    %esi,%ecx
  8025c2:	d3 e8                	shr    %cl,%eax
  8025c4:	09 d0                	or     %edx,%eax
  8025c6:	d3 eb                	shr    %cl,%ebx
  8025c8:	89 da                	mov    %ebx,%edx
  8025ca:	f7 f7                	div    %edi
  8025cc:	89 d3                	mov    %edx,%ebx
  8025ce:	f7 24 24             	mull   (%esp)
  8025d1:	89 c6                	mov    %eax,%esi
  8025d3:	89 d1                	mov    %edx,%ecx
  8025d5:	39 d3                	cmp    %edx,%ebx
  8025d7:	0f 82 87 00 00 00    	jb     802664 <__umoddi3+0x134>
  8025dd:	0f 84 91 00 00 00    	je     802674 <__umoddi3+0x144>
  8025e3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8025e7:	29 f2                	sub    %esi,%edx
  8025e9:	19 cb                	sbb    %ecx,%ebx
  8025eb:	89 d8                	mov    %ebx,%eax
  8025ed:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8025f1:	d3 e0                	shl    %cl,%eax
  8025f3:	89 e9                	mov    %ebp,%ecx
  8025f5:	d3 ea                	shr    %cl,%edx
  8025f7:	09 d0                	or     %edx,%eax
  8025f9:	89 e9                	mov    %ebp,%ecx
  8025fb:	d3 eb                	shr    %cl,%ebx
  8025fd:	89 da                	mov    %ebx,%edx
  8025ff:	83 c4 1c             	add    $0x1c,%esp
  802602:	5b                   	pop    %ebx
  802603:	5e                   	pop    %esi
  802604:	5f                   	pop    %edi
  802605:	5d                   	pop    %ebp
  802606:	c3                   	ret    
  802607:	90                   	nop
  802608:	89 fd                	mov    %edi,%ebp
  80260a:	85 ff                	test   %edi,%edi
  80260c:	75 0b                	jne    802619 <__umoddi3+0xe9>
  80260e:	b8 01 00 00 00       	mov    $0x1,%eax
  802613:	31 d2                	xor    %edx,%edx
  802615:	f7 f7                	div    %edi
  802617:	89 c5                	mov    %eax,%ebp
  802619:	89 f0                	mov    %esi,%eax
  80261b:	31 d2                	xor    %edx,%edx
  80261d:	f7 f5                	div    %ebp
  80261f:	89 c8                	mov    %ecx,%eax
  802621:	f7 f5                	div    %ebp
  802623:	89 d0                	mov    %edx,%eax
  802625:	e9 44 ff ff ff       	jmp    80256e <__umoddi3+0x3e>
  80262a:	66 90                	xchg   %ax,%ax
  80262c:	89 c8                	mov    %ecx,%eax
  80262e:	89 f2                	mov    %esi,%edx
  802630:	83 c4 1c             	add    $0x1c,%esp
  802633:	5b                   	pop    %ebx
  802634:	5e                   	pop    %esi
  802635:	5f                   	pop    %edi
  802636:	5d                   	pop    %ebp
  802637:	c3                   	ret    
  802638:	3b 04 24             	cmp    (%esp),%eax
  80263b:	72 06                	jb     802643 <__umoddi3+0x113>
  80263d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802641:	77 0f                	ja     802652 <__umoddi3+0x122>
  802643:	89 f2                	mov    %esi,%edx
  802645:	29 f9                	sub    %edi,%ecx
  802647:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80264b:	89 14 24             	mov    %edx,(%esp)
  80264e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802652:	8b 44 24 04          	mov    0x4(%esp),%eax
  802656:	8b 14 24             	mov    (%esp),%edx
  802659:	83 c4 1c             	add    $0x1c,%esp
  80265c:	5b                   	pop    %ebx
  80265d:	5e                   	pop    %esi
  80265e:	5f                   	pop    %edi
  80265f:	5d                   	pop    %ebp
  802660:	c3                   	ret    
  802661:	8d 76 00             	lea    0x0(%esi),%esi
  802664:	2b 04 24             	sub    (%esp),%eax
  802667:	19 fa                	sbb    %edi,%edx
  802669:	89 d1                	mov    %edx,%ecx
  80266b:	89 c6                	mov    %eax,%esi
  80266d:	e9 71 ff ff ff       	jmp    8025e3 <__umoddi3+0xb3>
  802672:	66 90                	xchg   %ax,%ax
  802674:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802678:	72 ea                	jb     802664 <__umoddi3+0x134>
  80267a:	89 d9                	mov    %ebx,%ecx
  80267c:	e9 62 ff ff ff       	jmp    8025e3 <__umoddi3+0xb3>

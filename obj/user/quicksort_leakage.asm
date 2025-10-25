
obj/user/quicksort_leakage:     file format elf32-i386


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
  800031:	e8 c8 05 00 00       	call   8005fe <libmain>
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
  800041:	e8 49 1d 00 00       	call   801d8f <sys_lock_cons>
		{
			cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 80 26 80 00       	push   $0x802680
  80004e:	e8 29 0a 00 00       	call   800a7c <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 82 26 80 00       	push   $0x802682
  80005e:	e8 19 0a 00 00       	call   800a7c <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!   QUICK SORT    !!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 9b 26 80 00       	push   $0x80269b
  80006e:	e8 09 0a 00 00       	call   800a7c <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 82 26 80 00       	push   $0x802682
  80007e:	e8 f9 09 00 00       	call   800a7c <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
			cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 80 26 80 00       	push   $0x802680
  80008e:	e8 e9 09 00 00       	call   800a7c <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp

			readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 b4 26 80 00       	push   $0x8026b4
  8000a5:	e8 ab 10 00 00       	call   801155 <readline>
  8000aa:	83 c4 10             	add    $0x10,%esp
			NumOfElements = strtol(Line, NULL, 10) ;
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 0a                	push   $0xa
  8000b2:	6a 00                	push   $0x0
  8000b4:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8000ba:	50                   	push   %eax
  8000bb:	e8 ac 16 00 00       	call   80176c <strtol>
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
			cprintf("Chose the initialization method:\n") ;
  8000c6:	83 ec 0c             	sub    $0xc,%esp
  8000c9:	68 d4 26 80 00       	push   $0x8026d4
  8000ce:	e8 a9 09 00 00       	call   800a7c <cprintf>
  8000d3:	83 c4 10             	add    $0x10,%esp
			cprintf("a) Ascending\n") ;
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	68 f6 26 80 00       	push   $0x8026f6
  8000de:	e8 99 09 00 00       	call   800a7c <cprintf>
  8000e3:	83 c4 10             	add    $0x10,%esp
			cprintf("b) Descending\n") ;
  8000e6:	83 ec 0c             	sub    $0xc,%esp
  8000e9:	68 04 27 80 00       	push   $0x802704
  8000ee:	e8 89 09 00 00       	call   800a7c <cprintf>
  8000f3:	83 c4 10             	add    $0x10,%esp
			cprintf("c) Semi random\n");
  8000f6:	83 ec 0c             	sub    $0xc,%esp
  8000f9:	68 13 27 80 00       	push   $0x802713
  8000fe:	e8 79 09 00 00       	call   800a7c <cprintf>
  800103:	83 c4 10             	add    $0x10,%esp
			do
			{
				cprintf("Select: ") ;
  800106:	83 ec 0c             	sub    $0xc,%esp
  800109:	68 23 27 80 00       	push   $0x802723
  80010e:	e8 69 09 00 00       	call   800a7c <cprintf>
  800113:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  800116:	e8 c6 04 00 00       	call   8005e1 <getchar>
  80011b:	88 45 f7             	mov    %al,-0x9(%ebp)
				cputchar(Chose);
  80011e:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800122:	83 ec 0c             	sub    $0xc,%esp
  800125:	50                   	push   %eax
  800126:	e8 97 04 00 00       	call   8005c2 <cputchar>
  80012b:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  80012e:	83 ec 0c             	sub    $0xc,%esp
  800131:	6a 0a                	push   $0xa
  800133:	e8 8a 04 00 00       	call   8005c2 <cputchar>
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
  80014d:	e8 57 1c 00 00       	call   801da9 <sys_unlock_cons>

		Elements = malloc(sizeof(int) * NumOfElements) ;
  800152:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800155:	c1 e0 02             	shl    $0x2,%eax
  800158:	83 ec 0c             	sub    $0xc,%esp
  80015b:	50                   	push   %eax
  80015c:	e8 e5 1a 00 00       	call   801c46 <malloc>
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
  800183:	e8 f5 02 00 00       	call   80047d <InitializeAscending>
  800188:	83 c4 10             	add    $0x10,%esp
			break ;
  80018b:	eb 37                	jmp    8001c4 <_main+0x18c>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80018d:	83 ec 08             	sub    $0x8,%esp
  800190:	ff 75 f0             	pushl  -0x10(%ebp)
  800193:	ff 75 ec             	pushl  -0x14(%ebp)
  800196:	e8 13 03 00 00       	call   8004ae <InitializeDescending>
  80019b:	83 c4 10             	add    $0x10,%esp
			break ;
  80019e:	eb 24                	jmp    8001c4 <_main+0x18c>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001a0:	83 ec 08             	sub    $0x8,%esp
  8001a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a6:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a9:	e8 35 03 00 00       	call   8004e3 <InitializeSemiRandom>
  8001ae:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b1:	eb 11                	jmp    8001c4 <_main+0x18c>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001b9:	ff 75 ec             	pushl  -0x14(%ebp)
  8001bc:	e8 22 03 00 00       	call   8004e3 <InitializeSemiRandom>
  8001c1:	83 c4 10             	add    $0x10,%esp
		}

		QuickSort(Elements, NumOfElements);
  8001c4:	83 ec 08             	sub    $0x8,%esp
  8001c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ca:	ff 75 ec             	pushl  -0x14(%ebp)
  8001cd:	e8 f0 00 00 00       	call   8002c2 <QuickSort>
  8001d2:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8001d5:	e8 b5 1b 00 00       	call   801d8f <sys_lock_cons>
		{
			cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001da:	83 ec 0c             	sub    $0xc,%esp
  8001dd:	68 2c 27 80 00       	push   $0x80272c
  8001e2:	e8 95 08 00 00       	call   800a7c <cprintf>
  8001e7:	83 c4 10             	add    $0x10,%esp
			//		PrintElements(Elements, NumOfElements);
		}
		sys_unlock_cons();
  8001ea:	e8 ba 1b 00 00       	call   801da9 <sys_unlock_cons>

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001ef:	83 ec 08             	sub    $0x8,%esp
  8001f2:	ff 75 f0             	pushl  -0x10(%ebp)
  8001f5:	ff 75 ec             	pushl  -0x14(%ebp)
  8001f8:	e8 d6 01 00 00       	call   8003d3 <CheckSorted>
  8001fd:	83 c4 10             	add    $0x10,%esp
  800200:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  800203:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800207:	75 14                	jne    80021d <_main+0x1e5>
  800209:	83 ec 04             	sub    $0x4,%esp
  80020c:	68 60 27 80 00       	push   $0x802760
  800211:	6a 51                	push   $0x51
  800213:	68 82 27 80 00       	push   $0x802782
  800218:	e8 91 05 00 00       	call   8007ae <_panic>
		else
		{
			sys_lock_cons();
  80021d:	e8 6d 1b 00 00       	call   801d8f <sys_lock_cons>
			{
				cprintf("===============================================\n") ;
  800222:	83 ec 0c             	sub    $0xc,%esp
  800225:	68 9c 27 80 00       	push   $0x80279c
  80022a:	e8 4d 08 00 00       	call   800a7c <cprintf>
  80022f:	83 c4 10             	add    $0x10,%esp
				cprintf("Congratulations!! The array is sorted correctly\n") ;
  800232:	83 ec 0c             	sub    $0xc,%esp
  800235:	68 d0 27 80 00       	push   $0x8027d0
  80023a:	e8 3d 08 00 00       	call   800a7c <cprintf>
  80023f:	83 c4 10             	add    $0x10,%esp
				cprintf("===============================================\n\n") ;
  800242:	83 ec 0c             	sub    $0xc,%esp
  800245:	68 04 28 80 00       	push   $0x802804
  80024a:	e8 2d 08 00 00       	call   800a7c <cprintf>
  80024f:	83 c4 10             	add    $0x10,%esp
			}
			sys_unlock_cons();
  800252:	e8 52 1b 00 00       	call   801da9 <sys_unlock_cons>
		}

		sys_lock_cons();
  800257:	e8 33 1b 00 00       	call   801d8f <sys_lock_cons>
		{
			Chose = 0 ;
  80025c:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800260:	eb 42                	jmp    8002a4 <_main+0x26c>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800262:	83 ec 0c             	sub    $0xc,%esp
  800265:	68 36 28 80 00       	push   $0x802836
  80026a:	e8 0d 08 00 00       	call   800a7c <cprintf>
  80026f:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  800272:	e8 6a 03 00 00       	call   8005e1 <getchar>
  800277:	88 45 f7             	mov    %al,-0x9(%ebp)
				cputchar(Chose);
  80027a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80027e:	83 ec 0c             	sub    $0xc,%esp
  800281:	50                   	push   %eax
  800282:	e8 3b 03 00 00       	call   8005c2 <cputchar>
  800287:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  80028a:	83 ec 0c             	sub    $0xc,%esp
  80028d:	6a 0a                	push   $0xa
  80028f:	e8 2e 03 00 00       	call   8005c2 <cputchar>
  800294:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  800297:	83 ec 0c             	sub    $0xc,%esp
  80029a:	6a 0a                	push   $0xa
  80029c:	e8 21 03 00 00       	call   8005c2 <cputchar>
  8002a1:	83 c4 10             	add    $0x10,%esp
		}

		sys_lock_cons();
		{
			Chose = 0 ;
			while (Chose != 'y' && Chose != 'n')
  8002a4:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002a8:	74 06                	je     8002b0 <_main+0x278>
  8002aa:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  8002ae:	75 b2                	jne    800262 <_main+0x22a>
				cputchar(Chose);
				cputchar('\n');
				cputchar('\n');
			}
		}
		sys_unlock_cons();
  8002b0:	e8 f4 1a 00 00       	call   801da9 <sys_unlock_cons>

	} while (Chose == 'y');
  8002b5:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002b9:	0f 84 82 fd ff ff    	je     800041 <_main+0x9>

}
  8002bf:	90                   	nop
  8002c0:	c9                   	leave  
  8002c1:	c3                   	ret    

008002c2 <QuickSort>:

///Quick sort
void QuickSort(int *Elements, int NumOfElements)
{
  8002c2:	55                   	push   %ebp
  8002c3:	89 e5                	mov    %esp,%ebp
  8002c5:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  8002c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002cb:	48                   	dec    %eax
  8002cc:	50                   	push   %eax
  8002cd:	6a 00                	push   $0x0
  8002cf:	ff 75 0c             	pushl  0xc(%ebp)
  8002d2:	ff 75 08             	pushl  0x8(%ebp)
  8002d5:	e8 06 00 00 00       	call   8002e0 <QSort>
  8002da:	83 c4 10             	add    $0x10,%esp
}
  8002dd:	90                   	nop
  8002de:	c9                   	leave  
  8002df:	c3                   	ret    

008002e0 <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  8002e0:	55                   	push   %ebp
  8002e1:	89 e5                	mov    %esp,%ebp
  8002e3:	83 ec 18             	sub    $0x18,%esp
	if (startIndex >= finalIndex) return;
  8002e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8002e9:	3b 45 14             	cmp    0x14(%ebp),%eax
  8002ec:	0f 8d de 00 00 00    	jge    8003d0 <QSort+0xf0>

	int i = startIndex+1, j = finalIndex;
  8002f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8002f5:	40                   	inc    %eax
  8002f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8002f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8002fc:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  8002ff:	e9 80 00 00 00       	jmp    800384 <QSort+0xa4>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  800304:	ff 45 f4             	incl   -0xc(%ebp)
  800307:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80030a:	3b 45 14             	cmp    0x14(%ebp),%eax
  80030d:	7f 2b                	jg     80033a <QSort+0x5a>
  80030f:	8b 45 10             	mov    0x10(%ebp),%eax
  800312:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800319:	8b 45 08             	mov    0x8(%ebp),%eax
  80031c:	01 d0                	add    %edx,%eax
  80031e:	8b 10                	mov    (%eax),%edx
  800320:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800323:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80032a:	8b 45 08             	mov    0x8(%ebp),%eax
  80032d:	01 c8                	add    %ecx,%eax
  80032f:	8b 00                	mov    (%eax),%eax
  800331:	39 c2                	cmp    %eax,%edx
  800333:	7d cf                	jge    800304 <QSort+0x24>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  800335:	eb 03                	jmp    80033a <QSort+0x5a>
  800337:	ff 4d f0             	decl   -0x10(%ebp)
  80033a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80033d:	3b 45 10             	cmp    0x10(%ebp),%eax
  800340:	7e 26                	jle    800368 <QSort+0x88>
  800342:	8b 45 10             	mov    0x10(%ebp),%eax
  800345:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80034c:	8b 45 08             	mov    0x8(%ebp),%eax
  80034f:	01 d0                	add    %edx,%eax
  800351:	8b 10                	mov    (%eax),%edx
  800353:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800356:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80035d:	8b 45 08             	mov    0x8(%ebp),%eax
  800360:	01 c8                	add    %ecx,%eax
  800362:	8b 00                	mov    (%eax),%eax
  800364:	39 c2                	cmp    %eax,%edx
  800366:	7e cf                	jle    800337 <QSort+0x57>

		if (i <= j)
  800368:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80036b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80036e:	7f 14                	jg     800384 <QSort+0xa4>
		{
			Swap(Elements, i, j);
  800370:	83 ec 04             	sub    $0x4,%esp
  800373:	ff 75 f0             	pushl  -0x10(%ebp)
  800376:	ff 75 f4             	pushl  -0xc(%ebp)
  800379:	ff 75 08             	pushl  0x8(%ebp)
  80037c:	e8 a9 00 00 00       	call   80042a <Swap>
  800381:	83 c4 10             	add    $0x10,%esp
{
	if (startIndex >= finalIndex) return;

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  800384:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800387:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80038a:	0f 8e 77 ff ff ff    	jle    800307 <QSort+0x27>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  800390:	83 ec 04             	sub    $0x4,%esp
  800393:	ff 75 f0             	pushl  -0x10(%ebp)
  800396:	ff 75 10             	pushl  0x10(%ebp)
  800399:	ff 75 08             	pushl  0x8(%ebp)
  80039c:	e8 89 00 00 00       	call   80042a <Swap>
  8003a1:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  8003a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003a7:	48                   	dec    %eax
  8003a8:	50                   	push   %eax
  8003a9:	ff 75 10             	pushl  0x10(%ebp)
  8003ac:	ff 75 0c             	pushl  0xc(%ebp)
  8003af:	ff 75 08             	pushl  0x8(%ebp)
  8003b2:	e8 29 ff ff ff       	call   8002e0 <QSort>
  8003b7:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  8003ba:	ff 75 14             	pushl  0x14(%ebp)
  8003bd:	ff 75 f4             	pushl  -0xc(%ebp)
  8003c0:	ff 75 0c             	pushl  0xc(%ebp)
  8003c3:	ff 75 08             	pushl  0x8(%ebp)
  8003c6:	e8 15 ff ff ff       	call   8002e0 <QSort>
  8003cb:	83 c4 10             	add    $0x10,%esp
  8003ce:	eb 01                	jmp    8003d1 <QSort+0xf1>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  8003d0:	90                   	nop
	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);

	//cprintf("qs,after sorting: start = %d, end = %d\n", startIndex, finalIndex);

}
  8003d1:	c9                   	leave  
  8003d2:	c3                   	ret    

008003d3 <CheckSorted>:

uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8003d3:	55                   	push   %ebp
  8003d4:	89 e5                	mov    %esp,%ebp
  8003d6:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8003d9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8003e0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8003e7:	eb 33                	jmp    80041c <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8003e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003ec:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f6:	01 d0                	add    %edx,%eax
  8003f8:	8b 10                	mov    (%eax),%edx
  8003fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003fd:	40                   	inc    %eax
  8003fe:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800405:	8b 45 08             	mov    0x8(%ebp),%eax
  800408:	01 c8                	add    %ecx,%eax
  80040a:	8b 00                	mov    (%eax),%eax
  80040c:	39 c2                	cmp    %eax,%edx
  80040e:	7e 09                	jle    800419 <CheckSorted+0x46>
		{
			Sorted = 0 ;
  800410:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800417:	eb 0c                	jmp    800425 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800419:	ff 45 f8             	incl   -0x8(%ebp)
  80041c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80041f:	48                   	dec    %eax
  800420:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800423:	7f c4                	jg     8003e9 <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800425:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800428:	c9                   	leave  
  800429:	c3                   	ret    

0080042a <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  80042a:	55                   	push   %ebp
  80042b:	89 e5                	mov    %esp,%ebp
  80042d:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800430:	8b 45 0c             	mov    0xc(%ebp),%eax
  800433:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80043a:	8b 45 08             	mov    0x8(%ebp),%eax
  80043d:	01 d0                	add    %edx,%eax
  80043f:	8b 00                	mov    (%eax),%eax
  800441:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800444:	8b 45 0c             	mov    0xc(%ebp),%eax
  800447:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80044e:	8b 45 08             	mov    0x8(%ebp),%eax
  800451:	01 c2                	add    %eax,%edx
  800453:	8b 45 10             	mov    0x10(%ebp),%eax
  800456:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80045d:	8b 45 08             	mov    0x8(%ebp),%eax
  800460:	01 c8                	add    %ecx,%eax
  800462:	8b 00                	mov    (%eax),%eax
  800464:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800466:	8b 45 10             	mov    0x10(%ebp),%eax
  800469:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800470:	8b 45 08             	mov    0x8(%ebp),%eax
  800473:	01 c2                	add    %eax,%edx
  800475:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800478:	89 02                	mov    %eax,(%edx)
}
  80047a:	90                   	nop
  80047b:	c9                   	leave  
  80047c:	c3                   	ret    

0080047d <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  80047d:	55                   	push   %ebp
  80047e:	89 e5                	mov    %esp,%ebp
  800480:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800483:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80048a:	eb 17                	jmp    8004a3 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  80048c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80048f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800496:	8b 45 08             	mov    0x8(%ebp),%eax
  800499:	01 c2                	add    %eax,%edx
  80049b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80049e:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004a0:	ff 45 fc             	incl   -0x4(%ebp)
  8004a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004a6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004a9:	7c e1                	jl     80048c <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8004ab:	90                   	nop
  8004ac:	c9                   	leave  
  8004ad:	c3                   	ret    

008004ae <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  8004ae:	55                   	push   %ebp
  8004af:	89 e5                	mov    %esp,%ebp
  8004b1:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004b4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8004bb:	eb 1b                	jmp    8004d8 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8004bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004c0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ca:	01 c2                	add    %eax,%edx
  8004cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004cf:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8004d2:	48                   	dec    %eax
  8004d3:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004d5:	ff 45 fc             	incl   -0x4(%ebp)
  8004d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004db:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004de:	7c dd                	jl     8004bd <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8004e0:	90                   	nop
  8004e1:	c9                   	leave  
  8004e2:	c3                   	ret    

008004e3 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8004e3:	55                   	push   %ebp
  8004e4:	89 e5                	mov    %esp,%ebp
  8004e6:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8004e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004ec:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8004f1:	f7 e9                	imul   %ecx
  8004f3:	c1 f9 1f             	sar    $0x1f,%ecx
  8004f6:	89 d0                	mov    %edx,%eax
  8004f8:	29 c8                	sub    %ecx,%eax
  8004fa:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (Repetition == 0)
  8004fd:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800501:	75 07                	jne    80050a <InitializeSemiRandom+0x27>
			Repetition = 3;
  800503:	c7 45 f8 03 00 00 00 	movl   $0x3,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  80050a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800511:	eb 1e                	jmp    800531 <InitializeSemiRandom+0x4e>
	{
		Elements[i] = i % Repetition ;
  800513:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800516:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80051d:	8b 45 08             	mov    0x8(%ebp),%eax
  800520:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800523:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800526:	99                   	cltd   
  800527:	f7 7d f8             	idivl  -0x8(%ebp)
  80052a:	89 d0                	mov    %edx,%eax
  80052c:	89 01                	mov    %eax,(%ecx)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	if (Repetition == 0)
			Repetition = 3;
	for (i = 0 ; i < NumOfElements ; i++)
  80052e:	ff 45 fc             	incl   -0x4(%ebp)
  800531:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800534:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800537:	7c da                	jl     800513 <InitializeSemiRandom+0x30>
	{
		Elements[i] = i % Repetition ;
		//	cprintf("i=%d\n",i);
	}

}
  800539:	90                   	nop
  80053a:	c9                   	leave  
  80053b:	c3                   	ret    

0080053c <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  80053c:	55                   	push   %ebp
  80053d:	89 e5                	mov    %esp,%ebp
  80053f:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800542:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800549:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800550:	eb 42                	jmp    800594 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800552:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800555:	99                   	cltd   
  800556:	f7 7d f0             	idivl  -0x10(%ebp)
  800559:	89 d0                	mov    %edx,%eax
  80055b:	85 c0                	test   %eax,%eax
  80055d:	75 10                	jne    80056f <PrintElements+0x33>
			cprintf("\n");
  80055f:	83 ec 0c             	sub    $0xc,%esp
  800562:	68 80 26 80 00       	push   $0x802680
  800567:	e8 10 05 00 00       	call   800a7c <cprintf>
  80056c:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  80056f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800572:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800579:	8b 45 08             	mov    0x8(%ebp),%eax
  80057c:	01 d0                	add    %edx,%eax
  80057e:	8b 00                	mov    (%eax),%eax
  800580:	83 ec 08             	sub    $0x8,%esp
  800583:	50                   	push   %eax
  800584:	68 54 28 80 00       	push   $0x802854
  800589:	e8 ee 04 00 00       	call   800a7c <cprintf>
  80058e:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800591:	ff 45 f4             	incl   -0xc(%ebp)
  800594:	8b 45 0c             	mov    0xc(%ebp),%eax
  800597:	48                   	dec    %eax
  800598:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80059b:	7f b5                	jg     800552 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  80059d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005a0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005aa:	01 d0                	add    %edx,%eax
  8005ac:	8b 00                	mov    (%eax),%eax
  8005ae:	83 ec 08             	sub    $0x8,%esp
  8005b1:	50                   	push   %eax
  8005b2:	68 59 28 80 00       	push   $0x802859
  8005b7:	e8 c0 04 00 00       	call   800a7c <cprintf>
  8005bc:	83 c4 10             	add    $0x10,%esp

}
  8005bf:	90                   	nop
  8005c0:	c9                   	leave  
  8005c1:	c3                   	ret    

008005c2 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8005c2:	55                   	push   %ebp
  8005c3:	89 e5                	mov    %esp,%ebp
  8005c5:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8005c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005cb:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8005ce:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8005d2:	83 ec 0c             	sub    $0xc,%esp
  8005d5:	50                   	push   %eax
  8005d6:	e8 fc 18 00 00       	call   801ed7 <sys_cputc>
  8005db:	83 c4 10             	add    $0x10,%esp
}
  8005de:	90                   	nop
  8005df:	c9                   	leave  
  8005e0:	c3                   	ret    

008005e1 <getchar>:


int
getchar(void)
{
  8005e1:	55                   	push   %ebp
  8005e2:	89 e5                	mov    %esp,%ebp
  8005e4:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  8005e7:	e8 8a 17 00 00       	call   801d76 <sys_cgetc>
  8005ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  8005ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8005f2:	c9                   	leave  
  8005f3:	c3                   	ret    

008005f4 <iscons>:

int iscons(int fdnum)
{
  8005f4:	55                   	push   %ebp
  8005f5:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  8005f7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8005fc:	5d                   	pop    %ebp
  8005fd:	c3                   	ret    

008005fe <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8005fe:	55                   	push   %ebp
  8005ff:	89 e5                	mov    %esp,%ebp
  800601:	57                   	push   %edi
  800602:	56                   	push   %esi
  800603:	53                   	push   %ebx
  800604:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800607:	e8 fc 19 00 00       	call   802008 <sys_getenvindex>
  80060c:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  80060f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800612:	89 d0                	mov    %edx,%eax
  800614:	c1 e0 02             	shl    $0x2,%eax
  800617:	01 d0                	add    %edx,%eax
  800619:	c1 e0 03             	shl    $0x3,%eax
  80061c:	01 d0                	add    %edx,%eax
  80061e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800625:	01 d0                	add    %edx,%eax
  800627:	c1 e0 02             	shl    $0x2,%eax
  80062a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80062f:	a3 24 40 80 00       	mov    %eax,0x804024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800634:	a1 24 40 80 00       	mov    0x804024,%eax
  800639:	8a 40 20             	mov    0x20(%eax),%al
  80063c:	84 c0                	test   %al,%al
  80063e:	74 0d                	je     80064d <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800640:	a1 24 40 80 00       	mov    0x804024,%eax
  800645:	83 c0 20             	add    $0x20,%eax
  800648:	a3 04 40 80 00       	mov    %eax,0x804004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80064d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800651:	7e 0a                	jle    80065d <libmain+0x5f>
		binaryname = argv[0];
  800653:	8b 45 0c             	mov    0xc(%ebp),%eax
  800656:	8b 00                	mov    (%eax),%eax
  800658:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	_main(argc, argv);
  80065d:	83 ec 08             	sub    $0x8,%esp
  800660:	ff 75 0c             	pushl  0xc(%ebp)
  800663:	ff 75 08             	pushl  0x8(%ebp)
  800666:	e8 cd f9 ff ff       	call   800038 <_main>
  80066b:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80066e:	a1 00 40 80 00       	mov    0x804000,%eax
  800673:	85 c0                	test   %eax,%eax
  800675:	0f 84 01 01 00 00    	je     80077c <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80067b:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800681:	bb 58 29 80 00       	mov    $0x802958,%ebx
  800686:	ba 0e 00 00 00       	mov    $0xe,%edx
  80068b:	89 c7                	mov    %eax,%edi
  80068d:	89 de                	mov    %ebx,%esi
  80068f:	89 d1                	mov    %edx,%ecx
  800691:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800693:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800696:	b9 56 00 00 00       	mov    $0x56,%ecx
  80069b:	b0 00                	mov    $0x0,%al
  80069d:	89 d7                	mov    %edx,%edi
  80069f:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8006a1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8006a8:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8006ab:	83 ec 08             	sub    $0x8,%esp
  8006ae:	50                   	push   %eax
  8006af:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8006b5:	50                   	push   %eax
  8006b6:	e8 83 1b 00 00       	call   80223e <sys_utilities>
  8006bb:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8006be:	e8 cc 16 00 00       	call   801d8f <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8006c3:	83 ec 0c             	sub    $0xc,%esp
  8006c6:	68 78 28 80 00       	push   $0x802878
  8006cb:	e8 ac 03 00 00       	call   800a7c <cprintf>
  8006d0:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8006d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006d6:	85 c0                	test   %eax,%eax
  8006d8:	74 18                	je     8006f2 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8006da:	e8 7d 1b 00 00       	call   80225c <sys_get_optimal_num_faults>
  8006df:	83 ec 08             	sub    $0x8,%esp
  8006e2:	50                   	push   %eax
  8006e3:	68 a0 28 80 00       	push   $0x8028a0
  8006e8:	e8 8f 03 00 00       	call   800a7c <cprintf>
  8006ed:	83 c4 10             	add    $0x10,%esp
  8006f0:	eb 59                	jmp    80074b <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8006f2:	a1 24 40 80 00       	mov    0x804024,%eax
  8006f7:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8006fd:	a1 24 40 80 00       	mov    0x804024,%eax
  800702:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  800708:	83 ec 04             	sub    $0x4,%esp
  80070b:	52                   	push   %edx
  80070c:	50                   	push   %eax
  80070d:	68 c4 28 80 00       	push   $0x8028c4
  800712:	e8 65 03 00 00       	call   800a7c <cprintf>
  800717:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80071a:	a1 24 40 80 00       	mov    0x804024,%eax
  80071f:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800725:	a1 24 40 80 00       	mov    0x804024,%eax
  80072a:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  800730:	a1 24 40 80 00       	mov    0x804024,%eax
  800735:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  80073b:	51                   	push   %ecx
  80073c:	52                   	push   %edx
  80073d:	50                   	push   %eax
  80073e:	68 ec 28 80 00       	push   $0x8028ec
  800743:	e8 34 03 00 00       	call   800a7c <cprintf>
  800748:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80074b:	a1 24 40 80 00       	mov    0x804024,%eax
  800750:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  800756:	83 ec 08             	sub    $0x8,%esp
  800759:	50                   	push   %eax
  80075a:	68 44 29 80 00       	push   $0x802944
  80075f:	e8 18 03 00 00       	call   800a7c <cprintf>
  800764:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800767:	83 ec 0c             	sub    $0xc,%esp
  80076a:	68 78 28 80 00       	push   $0x802878
  80076f:	e8 08 03 00 00       	call   800a7c <cprintf>
  800774:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800777:	e8 2d 16 00 00       	call   801da9 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80077c:	e8 1f 00 00 00       	call   8007a0 <exit>
}
  800781:	90                   	nop
  800782:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800785:	5b                   	pop    %ebx
  800786:	5e                   	pop    %esi
  800787:	5f                   	pop    %edi
  800788:	5d                   	pop    %ebp
  800789:	c3                   	ret    

0080078a <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80078a:	55                   	push   %ebp
  80078b:	89 e5                	mov    %esp,%ebp
  80078d:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800790:	83 ec 0c             	sub    $0xc,%esp
  800793:	6a 00                	push   $0x0
  800795:	e8 3a 18 00 00       	call   801fd4 <sys_destroy_env>
  80079a:	83 c4 10             	add    $0x10,%esp
}
  80079d:	90                   	nop
  80079e:	c9                   	leave  
  80079f:	c3                   	ret    

008007a0 <exit>:

void
exit(void)
{
  8007a0:	55                   	push   %ebp
  8007a1:	89 e5                	mov    %esp,%ebp
  8007a3:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8007a6:	e8 8f 18 00 00       	call   80203a <sys_exit_env>
}
  8007ab:	90                   	nop
  8007ac:	c9                   	leave  
  8007ad:	c3                   	ret    

008007ae <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8007ae:	55                   	push   %ebp
  8007af:	89 e5                	mov    %esp,%ebp
  8007b1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8007b4:	8d 45 10             	lea    0x10(%ebp),%eax
  8007b7:	83 c0 04             	add    $0x4,%eax
  8007ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8007bd:	a1 18 c1 81 00       	mov    0x81c118,%eax
  8007c2:	85 c0                	test   %eax,%eax
  8007c4:	74 16                	je     8007dc <_panic+0x2e>
		cprintf("%s: ", argv0);
  8007c6:	a1 18 c1 81 00       	mov    0x81c118,%eax
  8007cb:	83 ec 08             	sub    $0x8,%esp
  8007ce:	50                   	push   %eax
  8007cf:	68 bc 29 80 00       	push   $0x8029bc
  8007d4:	e8 a3 02 00 00       	call   800a7c <cprintf>
  8007d9:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8007dc:	a1 04 40 80 00       	mov    0x804004,%eax
  8007e1:	83 ec 0c             	sub    $0xc,%esp
  8007e4:	ff 75 0c             	pushl  0xc(%ebp)
  8007e7:	ff 75 08             	pushl  0x8(%ebp)
  8007ea:	50                   	push   %eax
  8007eb:	68 c4 29 80 00       	push   $0x8029c4
  8007f0:	6a 74                	push   $0x74
  8007f2:	e8 b2 02 00 00       	call   800aa9 <cprintf_colored>
  8007f7:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8007fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8007fd:	83 ec 08             	sub    $0x8,%esp
  800800:	ff 75 f4             	pushl  -0xc(%ebp)
  800803:	50                   	push   %eax
  800804:	e8 04 02 00 00       	call   800a0d <vcprintf>
  800809:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80080c:	83 ec 08             	sub    $0x8,%esp
  80080f:	6a 00                	push   $0x0
  800811:	68 ec 29 80 00       	push   $0x8029ec
  800816:	e8 f2 01 00 00       	call   800a0d <vcprintf>
  80081b:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80081e:	e8 7d ff ff ff       	call   8007a0 <exit>

	// should not return here
	while (1) ;
  800823:	eb fe                	jmp    800823 <_panic+0x75>

00800825 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800825:	55                   	push   %ebp
  800826:	89 e5                	mov    %esp,%ebp
  800828:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80082b:	a1 24 40 80 00       	mov    0x804024,%eax
  800830:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800836:	8b 45 0c             	mov    0xc(%ebp),%eax
  800839:	39 c2                	cmp    %eax,%edx
  80083b:	74 14                	je     800851 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80083d:	83 ec 04             	sub    $0x4,%esp
  800840:	68 f0 29 80 00       	push   $0x8029f0
  800845:	6a 26                	push   $0x26
  800847:	68 3c 2a 80 00       	push   $0x802a3c
  80084c:	e8 5d ff ff ff       	call   8007ae <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800851:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800858:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80085f:	e9 c5 00 00 00       	jmp    800929 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800864:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800867:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80086e:	8b 45 08             	mov    0x8(%ebp),%eax
  800871:	01 d0                	add    %edx,%eax
  800873:	8b 00                	mov    (%eax),%eax
  800875:	85 c0                	test   %eax,%eax
  800877:	75 08                	jne    800881 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800879:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80087c:	e9 a5 00 00 00       	jmp    800926 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800881:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800888:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80088f:	eb 69                	jmp    8008fa <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800891:	a1 24 40 80 00       	mov    0x804024,%eax
  800896:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80089c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80089f:	89 d0                	mov    %edx,%eax
  8008a1:	01 c0                	add    %eax,%eax
  8008a3:	01 d0                	add    %edx,%eax
  8008a5:	c1 e0 03             	shl    $0x3,%eax
  8008a8:	01 c8                	add    %ecx,%eax
  8008aa:	8a 40 04             	mov    0x4(%eax),%al
  8008ad:	84 c0                	test   %al,%al
  8008af:	75 46                	jne    8008f7 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008b1:	a1 24 40 80 00       	mov    0x804024,%eax
  8008b6:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8008bc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8008bf:	89 d0                	mov    %edx,%eax
  8008c1:	01 c0                	add    %eax,%eax
  8008c3:	01 d0                	add    %edx,%eax
  8008c5:	c1 e0 03             	shl    $0x3,%eax
  8008c8:	01 c8                	add    %ecx,%eax
  8008ca:	8b 00                	mov    (%eax),%eax
  8008cc:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8008cf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8008d2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008d7:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8008d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008dc:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8008e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e6:	01 c8                	add    %ecx,%eax
  8008e8:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008ea:	39 c2                	cmp    %eax,%edx
  8008ec:	75 09                	jne    8008f7 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8008ee:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8008f5:	eb 15                	jmp    80090c <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008f7:	ff 45 e8             	incl   -0x18(%ebp)
  8008fa:	a1 24 40 80 00       	mov    0x804024,%eax
  8008ff:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800905:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800908:	39 c2                	cmp    %eax,%edx
  80090a:	77 85                	ja     800891 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80090c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800910:	75 14                	jne    800926 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800912:	83 ec 04             	sub    $0x4,%esp
  800915:	68 48 2a 80 00       	push   $0x802a48
  80091a:	6a 3a                	push   $0x3a
  80091c:	68 3c 2a 80 00       	push   $0x802a3c
  800921:	e8 88 fe ff ff       	call   8007ae <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800926:	ff 45 f0             	incl   -0x10(%ebp)
  800929:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80092c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80092f:	0f 8c 2f ff ff ff    	jl     800864 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800935:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80093c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800943:	eb 26                	jmp    80096b <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800945:	a1 24 40 80 00       	mov    0x804024,%eax
  80094a:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800950:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800953:	89 d0                	mov    %edx,%eax
  800955:	01 c0                	add    %eax,%eax
  800957:	01 d0                	add    %edx,%eax
  800959:	c1 e0 03             	shl    $0x3,%eax
  80095c:	01 c8                	add    %ecx,%eax
  80095e:	8a 40 04             	mov    0x4(%eax),%al
  800961:	3c 01                	cmp    $0x1,%al
  800963:	75 03                	jne    800968 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800965:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800968:	ff 45 e0             	incl   -0x20(%ebp)
  80096b:	a1 24 40 80 00       	mov    0x804024,%eax
  800970:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800976:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800979:	39 c2                	cmp    %eax,%edx
  80097b:	77 c8                	ja     800945 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80097d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800980:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800983:	74 14                	je     800999 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800985:	83 ec 04             	sub    $0x4,%esp
  800988:	68 9c 2a 80 00       	push   $0x802a9c
  80098d:	6a 44                	push   $0x44
  80098f:	68 3c 2a 80 00       	push   $0x802a3c
  800994:	e8 15 fe ff ff       	call   8007ae <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800999:	90                   	nop
  80099a:	c9                   	leave  
  80099b:	c3                   	ret    

0080099c <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80099c:	55                   	push   %ebp
  80099d:	89 e5                	mov    %esp,%ebp
  80099f:	53                   	push   %ebx
  8009a0:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8009a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009a6:	8b 00                	mov    (%eax),%eax
  8009a8:	8d 48 01             	lea    0x1(%eax),%ecx
  8009ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ae:	89 0a                	mov    %ecx,(%edx)
  8009b0:	8b 55 08             	mov    0x8(%ebp),%edx
  8009b3:	88 d1                	mov    %dl,%cl
  8009b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009b8:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8009bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009bf:	8b 00                	mov    (%eax),%eax
  8009c1:	3d ff 00 00 00       	cmp    $0xff,%eax
  8009c6:	75 30                	jne    8009f8 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8009c8:	8b 15 1c c1 81 00    	mov    0x81c11c,%edx
  8009ce:	a0 44 40 80 00       	mov    0x804044,%al
  8009d3:	0f b6 c0             	movzbl %al,%eax
  8009d6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009d9:	8b 09                	mov    (%ecx),%ecx
  8009db:	89 cb                	mov    %ecx,%ebx
  8009dd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009e0:	83 c1 08             	add    $0x8,%ecx
  8009e3:	52                   	push   %edx
  8009e4:	50                   	push   %eax
  8009e5:	53                   	push   %ebx
  8009e6:	51                   	push   %ecx
  8009e7:	e8 5f 13 00 00       	call   801d4b <sys_cputs>
  8009ec:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8009ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009f2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8009f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009fb:	8b 40 04             	mov    0x4(%eax),%eax
  8009fe:	8d 50 01             	lea    0x1(%eax),%edx
  800a01:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a04:	89 50 04             	mov    %edx,0x4(%eax)
}
  800a07:	90                   	nop
  800a08:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a0b:	c9                   	leave  
  800a0c:	c3                   	ret    

00800a0d <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800a0d:	55                   	push   %ebp
  800a0e:	89 e5                	mov    %esp,%ebp
  800a10:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800a16:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800a1d:	00 00 00 
	b.cnt = 0;
  800a20:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800a27:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800a2a:	ff 75 0c             	pushl  0xc(%ebp)
  800a2d:	ff 75 08             	pushl  0x8(%ebp)
  800a30:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a36:	50                   	push   %eax
  800a37:	68 9c 09 80 00       	push   $0x80099c
  800a3c:	e8 5a 02 00 00       	call   800c9b <vprintfmt>
  800a41:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800a44:	8b 15 1c c1 81 00    	mov    0x81c11c,%edx
  800a4a:	a0 44 40 80 00       	mov    0x804044,%al
  800a4f:	0f b6 c0             	movzbl %al,%eax
  800a52:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800a58:	52                   	push   %edx
  800a59:	50                   	push   %eax
  800a5a:	51                   	push   %ecx
  800a5b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a61:	83 c0 08             	add    $0x8,%eax
  800a64:	50                   	push   %eax
  800a65:	e8 e1 12 00 00       	call   801d4b <sys_cputs>
  800a6a:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800a6d:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
	return b.cnt;
  800a74:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a7a:	c9                   	leave  
  800a7b:	c3                   	ret    

00800a7c <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800a7c:	55                   	push   %ebp
  800a7d:	89 e5                	mov    %esp,%ebp
  800a7f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a82:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	va_start(ap, fmt);
  800a89:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a92:	83 ec 08             	sub    $0x8,%esp
  800a95:	ff 75 f4             	pushl  -0xc(%ebp)
  800a98:	50                   	push   %eax
  800a99:	e8 6f ff ff ff       	call   800a0d <vcprintf>
  800a9e:	83 c4 10             	add    $0x10,%esp
  800aa1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800aa4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800aa7:	c9                   	leave  
  800aa8:	c3                   	ret    

00800aa9 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800aa9:	55                   	push   %ebp
  800aaa:	89 e5                	mov    %esp,%ebp
  800aac:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800aaf:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab9:	c1 e0 08             	shl    $0x8,%eax
  800abc:	a3 1c c1 81 00       	mov    %eax,0x81c11c
	va_start(ap, fmt);
  800ac1:	8d 45 0c             	lea    0xc(%ebp),%eax
  800ac4:	83 c0 04             	add    $0x4,%eax
  800ac7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800aca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800acd:	83 ec 08             	sub    $0x8,%esp
  800ad0:	ff 75 f4             	pushl  -0xc(%ebp)
  800ad3:	50                   	push   %eax
  800ad4:	e8 34 ff ff ff       	call   800a0d <vcprintf>
  800ad9:	83 c4 10             	add    $0x10,%esp
  800adc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800adf:	c7 05 1c c1 81 00 00 	movl   $0x700,0x81c11c
  800ae6:	07 00 00 

	return cnt;
  800ae9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800aec:	c9                   	leave  
  800aed:	c3                   	ret    

00800aee <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800aee:	55                   	push   %ebp
  800aef:	89 e5                	mov    %esp,%ebp
  800af1:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800af4:	e8 96 12 00 00       	call   801d8f <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800af9:	8d 45 0c             	lea    0xc(%ebp),%eax
  800afc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800aff:	8b 45 08             	mov    0x8(%ebp),%eax
  800b02:	83 ec 08             	sub    $0x8,%esp
  800b05:	ff 75 f4             	pushl  -0xc(%ebp)
  800b08:	50                   	push   %eax
  800b09:	e8 ff fe ff ff       	call   800a0d <vcprintf>
  800b0e:	83 c4 10             	add    $0x10,%esp
  800b11:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800b14:	e8 90 12 00 00       	call   801da9 <sys_unlock_cons>
	return cnt;
  800b19:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b1c:	c9                   	leave  
  800b1d:	c3                   	ret    

00800b1e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800b1e:	55                   	push   %ebp
  800b1f:	89 e5                	mov    %esp,%ebp
  800b21:	53                   	push   %ebx
  800b22:	83 ec 14             	sub    $0x14,%esp
  800b25:	8b 45 10             	mov    0x10(%ebp),%eax
  800b28:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b2b:	8b 45 14             	mov    0x14(%ebp),%eax
  800b2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800b31:	8b 45 18             	mov    0x18(%ebp),%eax
  800b34:	ba 00 00 00 00       	mov    $0x0,%edx
  800b39:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b3c:	77 55                	ja     800b93 <printnum+0x75>
  800b3e:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b41:	72 05                	jb     800b48 <printnum+0x2a>
  800b43:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800b46:	77 4b                	ja     800b93 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800b48:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800b4b:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800b4e:	8b 45 18             	mov    0x18(%ebp),%eax
  800b51:	ba 00 00 00 00       	mov    $0x0,%edx
  800b56:	52                   	push   %edx
  800b57:	50                   	push   %eax
  800b58:	ff 75 f4             	pushl  -0xc(%ebp)
  800b5b:	ff 75 f0             	pushl  -0x10(%ebp)
  800b5e:	e8 b1 18 00 00       	call   802414 <__udivdi3>
  800b63:	83 c4 10             	add    $0x10,%esp
  800b66:	83 ec 04             	sub    $0x4,%esp
  800b69:	ff 75 20             	pushl  0x20(%ebp)
  800b6c:	53                   	push   %ebx
  800b6d:	ff 75 18             	pushl  0x18(%ebp)
  800b70:	52                   	push   %edx
  800b71:	50                   	push   %eax
  800b72:	ff 75 0c             	pushl  0xc(%ebp)
  800b75:	ff 75 08             	pushl  0x8(%ebp)
  800b78:	e8 a1 ff ff ff       	call   800b1e <printnum>
  800b7d:	83 c4 20             	add    $0x20,%esp
  800b80:	eb 1a                	jmp    800b9c <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800b82:	83 ec 08             	sub    $0x8,%esp
  800b85:	ff 75 0c             	pushl  0xc(%ebp)
  800b88:	ff 75 20             	pushl  0x20(%ebp)
  800b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8e:	ff d0                	call   *%eax
  800b90:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800b93:	ff 4d 1c             	decl   0x1c(%ebp)
  800b96:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800b9a:	7f e6                	jg     800b82 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800b9c:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800b9f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ba4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ba7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800baa:	53                   	push   %ebx
  800bab:	51                   	push   %ecx
  800bac:	52                   	push   %edx
  800bad:	50                   	push   %eax
  800bae:	e8 71 19 00 00       	call   802524 <__umoddi3>
  800bb3:	83 c4 10             	add    $0x10,%esp
  800bb6:	05 14 2d 80 00       	add    $0x802d14,%eax
  800bbb:	8a 00                	mov    (%eax),%al
  800bbd:	0f be c0             	movsbl %al,%eax
  800bc0:	83 ec 08             	sub    $0x8,%esp
  800bc3:	ff 75 0c             	pushl  0xc(%ebp)
  800bc6:	50                   	push   %eax
  800bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bca:	ff d0                	call   *%eax
  800bcc:	83 c4 10             	add    $0x10,%esp
}
  800bcf:	90                   	nop
  800bd0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800bd3:	c9                   	leave  
  800bd4:	c3                   	ret    

00800bd5 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800bd5:	55                   	push   %ebp
  800bd6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800bd8:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800bdc:	7e 1c                	jle    800bfa <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800bde:	8b 45 08             	mov    0x8(%ebp),%eax
  800be1:	8b 00                	mov    (%eax),%eax
  800be3:	8d 50 08             	lea    0x8(%eax),%edx
  800be6:	8b 45 08             	mov    0x8(%ebp),%eax
  800be9:	89 10                	mov    %edx,(%eax)
  800beb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bee:	8b 00                	mov    (%eax),%eax
  800bf0:	83 e8 08             	sub    $0x8,%eax
  800bf3:	8b 50 04             	mov    0x4(%eax),%edx
  800bf6:	8b 00                	mov    (%eax),%eax
  800bf8:	eb 40                	jmp    800c3a <getuint+0x65>
	else if (lflag)
  800bfa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bfe:	74 1e                	je     800c1e <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800c00:	8b 45 08             	mov    0x8(%ebp),%eax
  800c03:	8b 00                	mov    (%eax),%eax
  800c05:	8d 50 04             	lea    0x4(%eax),%edx
  800c08:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0b:	89 10                	mov    %edx,(%eax)
  800c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c10:	8b 00                	mov    (%eax),%eax
  800c12:	83 e8 04             	sub    $0x4,%eax
  800c15:	8b 00                	mov    (%eax),%eax
  800c17:	ba 00 00 00 00       	mov    $0x0,%edx
  800c1c:	eb 1c                	jmp    800c3a <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c21:	8b 00                	mov    (%eax),%eax
  800c23:	8d 50 04             	lea    0x4(%eax),%edx
  800c26:	8b 45 08             	mov    0x8(%ebp),%eax
  800c29:	89 10                	mov    %edx,(%eax)
  800c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2e:	8b 00                	mov    (%eax),%eax
  800c30:	83 e8 04             	sub    $0x4,%eax
  800c33:	8b 00                	mov    (%eax),%eax
  800c35:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800c3a:	5d                   	pop    %ebp
  800c3b:	c3                   	ret    

00800c3c <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800c3c:	55                   	push   %ebp
  800c3d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c3f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c43:	7e 1c                	jle    800c61 <getint+0x25>
		return va_arg(*ap, long long);
  800c45:	8b 45 08             	mov    0x8(%ebp),%eax
  800c48:	8b 00                	mov    (%eax),%eax
  800c4a:	8d 50 08             	lea    0x8(%eax),%edx
  800c4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c50:	89 10                	mov    %edx,(%eax)
  800c52:	8b 45 08             	mov    0x8(%ebp),%eax
  800c55:	8b 00                	mov    (%eax),%eax
  800c57:	83 e8 08             	sub    $0x8,%eax
  800c5a:	8b 50 04             	mov    0x4(%eax),%edx
  800c5d:	8b 00                	mov    (%eax),%eax
  800c5f:	eb 38                	jmp    800c99 <getint+0x5d>
	else if (lflag)
  800c61:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c65:	74 1a                	je     800c81 <getint+0x45>
		return va_arg(*ap, long);
  800c67:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6a:	8b 00                	mov    (%eax),%eax
  800c6c:	8d 50 04             	lea    0x4(%eax),%edx
  800c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c72:	89 10                	mov    %edx,(%eax)
  800c74:	8b 45 08             	mov    0x8(%ebp),%eax
  800c77:	8b 00                	mov    (%eax),%eax
  800c79:	83 e8 04             	sub    $0x4,%eax
  800c7c:	8b 00                	mov    (%eax),%eax
  800c7e:	99                   	cltd   
  800c7f:	eb 18                	jmp    800c99 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800c81:	8b 45 08             	mov    0x8(%ebp),%eax
  800c84:	8b 00                	mov    (%eax),%eax
  800c86:	8d 50 04             	lea    0x4(%eax),%edx
  800c89:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8c:	89 10                	mov    %edx,(%eax)
  800c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c91:	8b 00                	mov    (%eax),%eax
  800c93:	83 e8 04             	sub    $0x4,%eax
  800c96:	8b 00                	mov    (%eax),%eax
  800c98:	99                   	cltd   
}
  800c99:	5d                   	pop    %ebp
  800c9a:	c3                   	ret    

00800c9b <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800c9b:	55                   	push   %ebp
  800c9c:	89 e5                	mov    %esp,%ebp
  800c9e:	56                   	push   %esi
  800c9f:	53                   	push   %ebx
  800ca0:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ca3:	eb 17                	jmp    800cbc <vprintfmt+0x21>
			if (ch == '\0')
  800ca5:	85 db                	test   %ebx,%ebx
  800ca7:	0f 84 c1 03 00 00    	je     80106e <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800cad:	83 ec 08             	sub    $0x8,%esp
  800cb0:	ff 75 0c             	pushl  0xc(%ebp)
  800cb3:	53                   	push   %ebx
  800cb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb7:	ff d0                	call   *%eax
  800cb9:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800cbc:	8b 45 10             	mov    0x10(%ebp),%eax
  800cbf:	8d 50 01             	lea    0x1(%eax),%edx
  800cc2:	89 55 10             	mov    %edx,0x10(%ebp)
  800cc5:	8a 00                	mov    (%eax),%al
  800cc7:	0f b6 d8             	movzbl %al,%ebx
  800cca:	83 fb 25             	cmp    $0x25,%ebx
  800ccd:	75 d6                	jne    800ca5 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800ccf:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800cd3:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800cda:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800ce1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800ce8:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800cef:	8b 45 10             	mov    0x10(%ebp),%eax
  800cf2:	8d 50 01             	lea    0x1(%eax),%edx
  800cf5:	89 55 10             	mov    %edx,0x10(%ebp)
  800cf8:	8a 00                	mov    (%eax),%al
  800cfa:	0f b6 d8             	movzbl %al,%ebx
  800cfd:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800d00:	83 f8 5b             	cmp    $0x5b,%eax
  800d03:	0f 87 3d 03 00 00    	ja     801046 <vprintfmt+0x3ab>
  800d09:	8b 04 85 38 2d 80 00 	mov    0x802d38(,%eax,4),%eax
  800d10:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800d12:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800d16:	eb d7                	jmp    800cef <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800d18:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800d1c:	eb d1                	jmp    800cef <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d1e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800d25:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800d28:	89 d0                	mov    %edx,%eax
  800d2a:	c1 e0 02             	shl    $0x2,%eax
  800d2d:	01 d0                	add    %edx,%eax
  800d2f:	01 c0                	add    %eax,%eax
  800d31:	01 d8                	add    %ebx,%eax
  800d33:	83 e8 30             	sub    $0x30,%eax
  800d36:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800d39:	8b 45 10             	mov    0x10(%ebp),%eax
  800d3c:	8a 00                	mov    (%eax),%al
  800d3e:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800d41:	83 fb 2f             	cmp    $0x2f,%ebx
  800d44:	7e 3e                	jle    800d84 <vprintfmt+0xe9>
  800d46:	83 fb 39             	cmp    $0x39,%ebx
  800d49:	7f 39                	jg     800d84 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d4b:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800d4e:	eb d5                	jmp    800d25 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800d50:	8b 45 14             	mov    0x14(%ebp),%eax
  800d53:	83 c0 04             	add    $0x4,%eax
  800d56:	89 45 14             	mov    %eax,0x14(%ebp)
  800d59:	8b 45 14             	mov    0x14(%ebp),%eax
  800d5c:	83 e8 04             	sub    $0x4,%eax
  800d5f:	8b 00                	mov    (%eax),%eax
  800d61:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800d64:	eb 1f                	jmp    800d85 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800d66:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d6a:	79 83                	jns    800cef <vprintfmt+0x54>
				width = 0;
  800d6c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800d73:	e9 77 ff ff ff       	jmp    800cef <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800d78:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800d7f:	e9 6b ff ff ff       	jmp    800cef <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800d84:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800d85:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d89:	0f 89 60 ff ff ff    	jns    800cef <vprintfmt+0x54>
				width = precision, precision = -1;
  800d8f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d92:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d95:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800d9c:	e9 4e ff ff ff       	jmp    800cef <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800da1:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800da4:	e9 46 ff ff ff       	jmp    800cef <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800da9:	8b 45 14             	mov    0x14(%ebp),%eax
  800dac:	83 c0 04             	add    $0x4,%eax
  800daf:	89 45 14             	mov    %eax,0x14(%ebp)
  800db2:	8b 45 14             	mov    0x14(%ebp),%eax
  800db5:	83 e8 04             	sub    $0x4,%eax
  800db8:	8b 00                	mov    (%eax),%eax
  800dba:	83 ec 08             	sub    $0x8,%esp
  800dbd:	ff 75 0c             	pushl  0xc(%ebp)
  800dc0:	50                   	push   %eax
  800dc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc4:	ff d0                	call   *%eax
  800dc6:	83 c4 10             	add    $0x10,%esp
			break;
  800dc9:	e9 9b 02 00 00       	jmp    801069 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800dce:	8b 45 14             	mov    0x14(%ebp),%eax
  800dd1:	83 c0 04             	add    $0x4,%eax
  800dd4:	89 45 14             	mov    %eax,0x14(%ebp)
  800dd7:	8b 45 14             	mov    0x14(%ebp),%eax
  800dda:	83 e8 04             	sub    $0x4,%eax
  800ddd:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ddf:	85 db                	test   %ebx,%ebx
  800de1:	79 02                	jns    800de5 <vprintfmt+0x14a>
				err = -err;
  800de3:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800de5:	83 fb 64             	cmp    $0x64,%ebx
  800de8:	7f 0b                	jg     800df5 <vprintfmt+0x15a>
  800dea:	8b 34 9d 80 2b 80 00 	mov    0x802b80(,%ebx,4),%esi
  800df1:	85 f6                	test   %esi,%esi
  800df3:	75 19                	jne    800e0e <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800df5:	53                   	push   %ebx
  800df6:	68 25 2d 80 00       	push   $0x802d25
  800dfb:	ff 75 0c             	pushl  0xc(%ebp)
  800dfe:	ff 75 08             	pushl  0x8(%ebp)
  800e01:	e8 70 02 00 00       	call   801076 <printfmt>
  800e06:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800e09:	e9 5b 02 00 00       	jmp    801069 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800e0e:	56                   	push   %esi
  800e0f:	68 2e 2d 80 00       	push   $0x802d2e
  800e14:	ff 75 0c             	pushl  0xc(%ebp)
  800e17:	ff 75 08             	pushl  0x8(%ebp)
  800e1a:	e8 57 02 00 00       	call   801076 <printfmt>
  800e1f:	83 c4 10             	add    $0x10,%esp
			break;
  800e22:	e9 42 02 00 00       	jmp    801069 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800e27:	8b 45 14             	mov    0x14(%ebp),%eax
  800e2a:	83 c0 04             	add    $0x4,%eax
  800e2d:	89 45 14             	mov    %eax,0x14(%ebp)
  800e30:	8b 45 14             	mov    0x14(%ebp),%eax
  800e33:	83 e8 04             	sub    $0x4,%eax
  800e36:	8b 30                	mov    (%eax),%esi
  800e38:	85 f6                	test   %esi,%esi
  800e3a:	75 05                	jne    800e41 <vprintfmt+0x1a6>
				p = "(null)";
  800e3c:	be 31 2d 80 00       	mov    $0x802d31,%esi
			if (width > 0 && padc != '-')
  800e41:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e45:	7e 6d                	jle    800eb4 <vprintfmt+0x219>
  800e47:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800e4b:	74 67                	je     800eb4 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e4d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e50:	83 ec 08             	sub    $0x8,%esp
  800e53:	50                   	push   %eax
  800e54:	56                   	push   %esi
  800e55:	e8 26 05 00 00       	call   801380 <strnlen>
  800e5a:	83 c4 10             	add    $0x10,%esp
  800e5d:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800e60:	eb 16                	jmp    800e78 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800e62:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800e66:	83 ec 08             	sub    $0x8,%esp
  800e69:	ff 75 0c             	pushl  0xc(%ebp)
  800e6c:	50                   	push   %eax
  800e6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e70:	ff d0                	call   *%eax
  800e72:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e75:	ff 4d e4             	decl   -0x1c(%ebp)
  800e78:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e7c:	7f e4                	jg     800e62 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e7e:	eb 34                	jmp    800eb4 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800e80:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800e84:	74 1c                	je     800ea2 <vprintfmt+0x207>
  800e86:	83 fb 1f             	cmp    $0x1f,%ebx
  800e89:	7e 05                	jle    800e90 <vprintfmt+0x1f5>
  800e8b:	83 fb 7e             	cmp    $0x7e,%ebx
  800e8e:	7e 12                	jle    800ea2 <vprintfmt+0x207>
					putch('?', putdat);
  800e90:	83 ec 08             	sub    $0x8,%esp
  800e93:	ff 75 0c             	pushl  0xc(%ebp)
  800e96:	6a 3f                	push   $0x3f
  800e98:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9b:	ff d0                	call   *%eax
  800e9d:	83 c4 10             	add    $0x10,%esp
  800ea0:	eb 0f                	jmp    800eb1 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800ea2:	83 ec 08             	sub    $0x8,%esp
  800ea5:	ff 75 0c             	pushl  0xc(%ebp)
  800ea8:	53                   	push   %ebx
  800ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  800eac:	ff d0                	call   *%eax
  800eae:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800eb1:	ff 4d e4             	decl   -0x1c(%ebp)
  800eb4:	89 f0                	mov    %esi,%eax
  800eb6:	8d 70 01             	lea    0x1(%eax),%esi
  800eb9:	8a 00                	mov    (%eax),%al
  800ebb:	0f be d8             	movsbl %al,%ebx
  800ebe:	85 db                	test   %ebx,%ebx
  800ec0:	74 24                	je     800ee6 <vprintfmt+0x24b>
  800ec2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ec6:	78 b8                	js     800e80 <vprintfmt+0x1e5>
  800ec8:	ff 4d e0             	decl   -0x20(%ebp)
  800ecb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ecf:	79 af                	jns    800e80 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ed1:	eb 13                	jmp    800ee6 <vprintfmt+0x24b>
				putch(' ', putdat);
  800ed3:	83 ec 08             	sub    $0x8,%esp
  800ed6:	ff 75 0c             	pushl  0xc(%ebp)
  800ed9:	6a 20                	push   $0x20
  800edb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ede:	ff d0                	call   *%eax
  800ee0:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ee3:	ff 4d e4             	decl   -0x1c(%ebp)
  800ee6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800eea:	7f e7                	jg     800ed3 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800eec:	e9 78 01 00 00       	jmp    801069 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ef1:	83 ec 08             	sub    $0x8,%esp
  800ef4:	ff 75 e8             	pushl  -0x18(%ebp)
  800ef7:	8d 45 14             	lea    0x14(%ebp),%eax
  800efa:	50                   	push   %eax
  800efb:	e8 3c fd ff ff       	call   800c3c <getint>
  800f00:	83 c4 10             	add    $0x10,%esp
  800f03:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f06:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800f09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f0c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f0f:	85 d2                	test   %edx,%edx
  800f11:	79 23                	jns    800f36 <vprintfmt+0x29b>
				putch('-', putdat);
  800f13:	83 ec 08             	sub    $0x8,%esp
  800f16:	ff 75 0c             	pushl  0xc(%ebp)
  800f19:	6a 2d                	push   $0x2d
  800f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1e:	ff d0                	call   *%eax
  800f20:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800f23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f26:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f29:	f7 d8                	neg    %eax
  800f2b:	83 d2 00             	adc    $0x0,%edx
  800f2e:	f7 da                	neg    %edx
  800f30:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f33:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800f36:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f3d:	e9 bc 00 00 00       	jmp    800ffe <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800f42:	83 ec 08             	sub    $0x8,%esp
  800f45:	ff 75 e8             	pushl  -0x18(%ebp)
  800f48:	8d 45 14             	lea    0x14(%ebp),%eax
  800f4b:	50                   	push   %eax
  800f4c:	e8 84 fc ff ff       	call   800bd5 <getuint>
  800f51:	83 c4 10             	add    $0x10,%esp
  800f54:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f57:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800f5a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f61:	e9 98 00 00 00       	jmp    800ffe <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800f66:	83 ec 08             	sub    $0x8,%esp
  800f69:	ff 75 0c             	pushl  0xc(%ebp)
  800f6c:	6a 58                	push   $0x58
  800f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f71:	ff d0                	call   *%eax
  800f73:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f76:	83 ec 08             	sub    $0x8,%esp
  800f79:	ff 75 0c             	pushl  0xc(%ebp)
  800f7c:	6a 58                	push   $0x58
  800f7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f81:	ff d0                	call   *%eax
  800f83:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f86:	83 ec 08             	sub    $0x8,%esp
  800f89:	ff 75 0c             	pushl  0xc(%ebp)
  800f8c:	6a 58                	push   $0x58
  800f8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f91:	ff d0                	call   *%eax
  800f93:	83 c4 10             	add    $0x10,%esp
			break;
  800f96:	e9 ce 00 00 00       	jmp    801069 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800f9b:	83 ec 08             	sub    $0x8,%esp
  800f9e:	ff 75 0c             	pushl  0xc(%ebp)
  800fa1:	6a 30                	push   $0x30
  800fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa6:	ff d0                	call   *%eax
  800fa8:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800fab:	83 ec 08             	sub    $0x8,%esp
  800fae:	ff 75 0c             	pushl  0xc(%ebp)
  800fb1:	6a 78                	push   $0x78
  800fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb6:	ff d0                	call   *%eax
  800fb8:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800fbb:	8b 45 14             	mov    0x14(%ebp),%eax
  800fbe:	83 c0 04             	add    $0x4,%eax
  800fc1:	89 45 14             	mov    %eax,0x14(%ebp)
  800fc4:	8b 45 14             	mov    0x14(%ebp),%eax
  800fc7:	83 e8 04             	sub    $0x4,%eax
  800fca:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800fcc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fcf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800fd6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800fdd:	eb 1f                	jmp    800ffe <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800fdf:	83 ec 08             	sub    $0x8,%esp
  800fe2:	ff 75 e8             	pushl  -0x18(%ebp)
  800fe5:	8d 45 14             	lea    0x14(%ebp),%eax
  800fe8:	50                   	push   %eax
  800fe9:	e8 e7 fb ff ff       	call   800bd5 <getuint>
  800fee:	83 c4 10             	add    $0x10,%esp
  800ff1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ff4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ff7:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ffe:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801002:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801005:	83 ec 04             	sub    $0x4,%esp
  801008:	52                   	push   %edx
  801009:	ff 75 e4             	pushl  -0x1c(%ebp)
  80100c:	50                   	push   %eax
  80100d:	ff 75 f4             	pushl  -0xc(%ebp)
  801010:	ff 75 f0             	pushl  -0x10(%ebp)
  801013:	ff 75 0c             	pushl  0xc(%ebp)
  801016:	ff 75 08             	pushl  0x8(%ebp)
  801019:	e8 00 fb ff ff       	call   800b1e <printnum>
  80101e:	83 c4 20             	add    $0x20,%esp
			break;
  801021:	eb 46                	jmp    801069 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801023:	83 ec 08             	sub    $0x8,%esp
  801026:	ff 75 0c             	pushl  0xc(%ebp)
  801029:	53                   	push   %ebx
  80102a:	8b 45 08             	mov    0x8(%ebp),%eax
  80102d:	ff d0                	call   *%eax
  80102f:	83 c4 10             	add    $0x10,%esp
			break;
  801032:	eb 35                	jmp    801069 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  801034:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
			break;
  80103b:	eb 2c                	jmp    801069 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  80103d:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
			break;
  801044:	eb 23                	jmp    801069 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801046:	83 ec 08             	sub    $0x8,%esp
  801049:	ff 75 0c             	pushl  0xc(%ebp)
  80104c:	6a 25                	push   $0x25
  80104e:	8b 45 08             	mov    0x8(%ebp),%eax
  801051:	ff d0                	call   *%eax
  801053:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801056:	ff 4d 10             	decl   0x10(%ebp)
  801059:	eb 03                	jmp    80105e <vprintfmt+0x3c3>
  80105b:	ff 4d 10             	decl   0x10(%ebp)
  80105e:	8b 45 10             	mov    0x10(%ebp),%eax
  801061:	48                   	dec    %eax
  801062:	8a 00                	mov    (%eax),%al
  801064:	3c 25                	cmp    $0x25,%al
  801066:	75 f3                	jne    80105b <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  801068:	90                   	nop
		}
	}
  801069:	e9 35 fc ff ff       	jmp    800ca3 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80106e:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80106f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801072:	5b                   	pop    %ebx
  801073:	5e                   	pop    %esi
  801074:	5d                   	pop    %ebp
  801075:	c3                   	ret    

00801076 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801076:	55                   	push   %ebp
  801077:	89 e5                	mov    %esp,%ebp
  801079:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80107c:	8d 45 10             	lea    0x10(%ebp),%eax
  80107f:	83 c0 04             	add    $0x4,%eax
  801082:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801085:	8b 45 10             	mov    0x10(%ebp),%eax
  801088:	ff 75 f4             	pushl  -0xc(%ebp)
  80108b:	50                   	push   %eax
  80108c:	ff 75 0c             	pushl  0xc(%ebp)
  80108f:	ff 75 08             	pushl  0x8(%ebp)
  801092:	e8 04 fc ff ff       	call   800c9b <vprintfmt>
  801097:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80109a:	90                   	nop
  80109b:	c9                   	leave  
  80109c:	c3                   	ret    

0080109d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80109d:	55                   	push   %ebp
  80109e:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8010a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a3:	8b 40 08             	mov    0x8(%eax),%eax
  8010a6:	8d 50 01             	lea    0x1(%eax),%edx
  8010a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ac:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8010af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b2:	8b 10                	mov    (%eax),%edx
  8010b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b7:	8b 40 04             	mov    0x4(%eax),%eax
  8010ba:	39 c2                	cmp    %eax,%edx
  8010bc:	73 12                	jae    8010d0 <sprintputch+0x33>
		*b->buf++ = ch;
  8010be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c1:	8b 00                	mov    (%eax),%eax
  8010c3:	8d 48 01             	lea    0x1(%eax),%ecx
  8010c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010c9:	89 0a                	mov    %ecx,(%edx)
  8010cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ce:	88 10                	mov    %dl,(%eax)
}
  8010d0:	90                   	nop
  8010d1:	5d                   	pop    %ebp
  8010d2:	c3                   	ret    

008010d3 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8010d3:	55                   	push   %ebp
  8010d4:	89 e5                	mov    %esp,%ebp
  8010d6:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8010d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010dc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8010df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e8:	01 d0                	add    %edx,%eax
  8010ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010ed:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8010f4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010f8:	74 06                	je     801100 <vsnprintf+0x2d>
  8010fa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010fe:	7f 07                	jg     801107 <vsnprintf+0x34>
		return -E_INVAL;
  801100:	b8 03 00 00 00       	mov    $0x3,%eax
  801105:	eb 20                	jmp    801127 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801107:	ff 75 14             	pushl  0x14(%ebp)
  80110a:	ff 75 10             	pushl  0x10(%ebp)
  80110d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801110:	50                   	push   %eax
  801111:	68 9d 10 80 00       	push   $0x80109d
  801116:	e8 80 fb ff ff       	call   800c9b <vprintfmt>
  80111b:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80111e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801121:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801124:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801127:	c9                   	leave  
  801128:	c3                   	ret    

00801129 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801129:	55                   	push   %ebp
  80112a:	89 e5                	mov    %esp,%ebp
  80112c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80112f:	8d 45 10             	lea    0x10(%ebp),%eax
  801132:	83 c0 04             	add    $0x4,%eax
  801135:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801138:	8b 45 10             	mov    0x10(%ebp),%eax
  80113b:	ff 75 f4             	pushl  -0xc(%ebp)
  80113e:	50                   	push   %eax
  80113f:	ff 75 0c             	pushl  0xc(%ebp)
  801142:	ff 75 08             	pushl  0x8(%ebp)
  801145:	e8 89 ff ff ff       	call   8010d3 <vsnprintf>
  80114a:	83 c4 10             	add    $0x10,%esp
  80114d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801150:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801153:	c9                   	leave  
  801154:	c3                   	ret    

00801155 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  801155:	55                   	push   %ebp
  801156:	89 e5                	mov    %esp,%ebp
  801158:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  80115b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80115f:	74 13                	je     801174 <readline+0x1f>
		cprintf("%s", prompt);
  801161:	83 ec 08             	sub    $0x8,%esp
  801164:	ff 75 08             	pushl  0x8(%ebp)
  801167:	68 a8 2e 80 00       	push   $0x802ea8
  80116c:	e8 0b f9 ff ff       	call   800a7c <cprintf>
  801171:	83 c4 10             	add    $0x10,%esp

	i = 0;
  801174:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  80117b:	83 ec 0c             	sub    $0xc,%esp
  80117e:	6a 00                	push   $0x0
  801180:	e8 6f f4 ff ff       	call   8005f4 <iscons>
  801185:	83 c4 10             	add    $0x10,%esp
  801188:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  80118b:	e8 51 f4 ff ff       	call   8005e1 <getchar>
  801190:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801193:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801197:	79 22                	jns    8011bb <readline+0x66>
			if (c != -E_EOF)
  801199:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  80119d:	0f 84 ad 00 00 00    	je     801250 <readline+0xfb>
				cprintf("read error: %e\n", c);
  8011a3:	83 ec 08             	sub    $0x8,%esp
  8011a6:	ff 75 ec             	pushl  -0x14(%ebp)
  8011a9:	68 ab 2e 80 00       	push   $0x802eab
  8011ae:	e8 c9 f8 ff ff       	call   800a7c <cprintf>
  8011b3:	83 c4 10             	add    $0x10,%esp
			break;
  8011b6:	e9 95 00 00 00       	jmp    801250 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8011bb:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8011bf:	7e 34                	jle    8011f5 <readline+0xa0>
  8011c1:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8011c8:	7f 2b                	jg     8011f5 <readline+0xa0>
			if (echoing)
  8011ca:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8011ce:	74 0e                	je     8011de <readline+0x89>
				cputchar(c);
  8011d0:	83 ec 0c             	sub    $0xc,%esp
  8011d3:	ff 75 ec             	pushl  -0x14(%ebp)
  8011d6:	e8 e7 f3 ff ff       	call   8005c2 <cputchar>
  8011db:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  8011de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011e1:	8d 50 01             	lea    0x1(%eax),%edx
  8011e4:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8011e7:	89 c2                	mov    %eax,%edx
  8011e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ec:	01 d0                	add    %edx,%eax
  8011ee:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011f1:	88 10                	mov    %dl,(%eax)
  8011f3:	eb 56                	jmp    80124b <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  8011f5:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8011f9:	75 1f                	jne    80121a <readline+0xc5>
  8011fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8011ff:	7e 19                	jle    80121a <readline+0xc5>
			if (echoing)
  801201:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801205:	74 0e                	je     801215 <readline+0xc0>
				cputchar(c);
  801207:	83 ec 0c             	sub    $0xc,%esp
  80120a:	ff 75 ec             	pushl  -0x14(%ebp)
  80120d:	e8 b0 f3 ff ff       	call   8005c2 <cputchar>
  801212:	83 c4 10             	add    $0x10,%esp

			i--;
  801215:	ff 4d f4             	decl   -0xc(%ebp)
  801218:	eb 31                	jmp    80124b <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  80121a:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  80121e:	74 0a                	je     80122a <readline+0xd5>
  801220:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801224:	0f 85 61 ff ff ff    	jne    80118b <readline+0x36>
			if (echoing)
  80122a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80122e:	74 0e                	je     80123e <readline+0xe9>
				cputchar(c);
  801230:	83 ec 0c             	sub    $0xc,%esp
  801233:	ff 75 ec             	pushl  -0x14(%ebp)
  801236:	e8 87 f3 ff ff       	call   8005c2 <cputchar>
  80123b:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  80123e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801241:	8b 45 0c             	mov    0xc(%ebp),%eax
  801244:	01 d0                	add    %edx,%eax
  801246:	c6 00 00             	movb   $0x0,(%eax)
			break;
  801249:	eb 06                	jmp    801251 <readline+0xfc>
		}
	}
  80124b:	e9 3b ff ff ff       	jmp    80118b <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  801250:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  801251:	90                   	nop
  801252:	c9                   	leave  
  801253:	c3                   	ret    

00801254 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  801254:	55                   	push   %ebp
  801255:	89 e5                	mov    %esp,%ebp
  801257:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  80125a:	e8 30 0b 00 00       	call   801d8f <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  80125f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801263:	74 13                	je     801278 <atomic_readline+0x24>
			cprintf("%s", prompt);
  801265:	83 ec 08             	sub    $0x8,%esp
  801268:	ff 75 08             	pushl  0x8(%ebp)
  80126b:	68 a8 2e 80 00       	push   $0x802ea8
  801270:	e8 07 f8 ff ff       	call   800a7c <cprintf>
  801275:	83 c4 10             	add    $0x10,%esp

		i = 0;
  801278:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  80127f:	83 ec 0c             	sub    $0xc,%esp
  801282:	6a 00                	push   $0x0
  801284:	e8 6b f3 ff ff       	call   8005f4 <iscons>
  801289:	83 c4 10             	add    $0x10,%esp
  80128c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  80128f:	e8 4d f3 ff ff       	call   8005e1 <getchar>
  801294:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  801297:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80129b:	79 22                	jns    8012bf <atomic_readline+0x6b>
				if (c != -E_EOF)
  80129d:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8012a1:	0f 84 ad 00 00 00    	je     801354 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  8012a7:	83 ec 08             	sub    $0x8,%esp
  8012aa:	ff 75 ec             	pushl  -0x14(%ebp)
  8012ad:	68 ab 2e 80 00       	push   $0x802eab
  8012b2:	e8 c5 f7 ff ff       	call   800a7c <cprintf>
  8012b7:	83 c4 10             	add    $0x10,%esp
				break;
  8012ba:	e9 95 00 00 00       	jmp    801354 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  8012bf:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8012c3:	7e 34                	jle    8012f9 <atomic_readline+0xa5>
  8012c5:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8012cc:	7f 2b                	jg     8012f9 <atomic_readline+0xa5>
				if (echoing)
  8012ce:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012d2:	74 0e                	je     8012e2 <atomic_readline+0x8e>
					cputchar(c);
  8012d4:	83 ec 0c             	sub    $0xc,%esp
  8012d7:	ff 75 ec             	pushl  -0x14(%ebp)
  8012da:	e8 e3 f2 ff ff       	call   8005c2 <cputchar>
  8012df:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  8012e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012e5:	8d 50 01             	lea    0x1(%eax),%edx
  8012e8:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8012eb:	89 c2                	mov    %eax,%edx
  8012ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f0:	01 d0                	add    %edx,%eax
  8012f2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012f5:	88 10                	mov    %dl,(%eax)
  8012f7:	eb 56                	jmp    80134f <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  8012f9:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8012fd:	75 1f                	jne    80131e <atomic_readline+0xca>
  8012ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801303:	7e 19                	jle    80131e <atomic_readline+0xca>
				if (echoing)
  801305:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801309:	74 0e                	je     801319 <atomic_readline+0xc5>
					cputchar(c);
  80130b:	83 ec 0c             	sub    $0xc,%esp
  80130e:	ff 75 ec             	pushl  -0x14(%ebp)
  801311:	e8 ac f2 ff ff       	call   8005c2 <cputchar>
  801316:	83 c4 10             	add    $0x10,%esp
				i--;
  801319:	ff 4d f4             	decl   -0xc(%ebp)
  80131c:	eb 31                	jmp    80134f <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  80131e:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801322:	74 0a                	je     80132e <atomic_readline+0xda>
  801324:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801328:	0f 85 61 ff ff ff    	jne    80128f <atomic_readline+0x3b>
				if (echoing)
  80132e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801332:	74 0e                	je     801342 <atomic_readline+0xee>
					cputchar(c);
  801334:	83 ec 0c             	sub    $0xc,%esp
  801337:	ff 75 ec             	pushl  -0x14(%ebp)
  80133a:	e8 83 f2 ff ff       	call   8005c2 <cputchar>
  80133f:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  801342:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801345:	8b 45 0c             	mov    0xc(%ebp),%eax
  801348:	01 d0                	add    %edx,%eax
  80134a:	c6 00 00             	movb   $0x0,(%eax)
				break;
  80134d:	eb 06                	jmp    801355 <atomic_readline+0x101>
			}
		}
  80134f:	e9 3b ff ff ff       	jmp    80128f <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  801354:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  801355:	e8 4f 0a 00 00       	call   801da9 <sys_unlock_cons>
}
  80135a:	90                   	nop
  80135b:	c9                   	leave  
  80135c:	c3                   	ret    

0080135d <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80135d:	55                   	push   %ebp
  80135e:	89 e5                	mov    %esp,%ebp
  801360:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801363:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80136a:	eb 06                	jmp    801372 <strlen+0x15>
		n++;
  80136c:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80136f:	ff 45 08             	incl   0x8(%ebp)
  801372:	8b 45 08             	mov    0x8(%ebp),%eax
  801375:	8a 00                	mov    (%eax),%al
  801377:	84 c0                	test   %al,%al
  801379:	75 f1                	jne    80136c <strlen+0xf>
		n++;
	return n;
  80137b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80137e:	c9                   	leave  
  80137f:	c3                   	ret    

00801380 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801380:	55                   	push   %ebp
  801381:	89 e5                	mov    %esp,%ebp
  801383:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801386:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80138d:	eb 09                	jmp    801398 <strnlen+0x18>
		n++;
  80138f:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801392:	ff 45 08             	incl   0x8(%ebp)
  801395:	ff 4d 0c             	decl   0xc(%ebp)
  801398:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80139c:	74 09                	je     8013a7 <strnlen+0x27>
  80139e:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a1:	8a 00                	mov    (%eax),%al
  8013a3:	84 c0                	test   %al,%al
  8013a5:	75 e8                	jne    80138f <strnlen+0xf>
		n++;
	return n;
  8013a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8013aa:	c9                   	leave  
  8013ab:	c3                   	ret    

008013ac <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8013ac:	55                   	push   %ebp
  8013ad:	89 e5                	mov    %esp,%ebp
  8013af:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8013b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8013b8:	90                   	nop
  8013b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bc:	8d 50 01             	lea    0x1(%eax),%edx
  8013bf:	89 55 08             	mov    %edx,0x8(%ebp)
  8013c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013c5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013c8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8013cb:	8a 12                	mov    (%edx),%dl
  8013cd:	88 10                	mov    %dl,(%eax)
  8013cf:	8a 00                	mov    (%eax),%al
  8013d1:	84 c0                	test   %al,%al
  8013d3:	75 e4                	jne    8013b9 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8013d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8013d8:	c9                   	leave  
  8013d9:	c3                   	ret    

008013da <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8013da:	55                   	push   %ebp
  8013db:	89 e5                	mov    %esp,%ebp
  8013dd:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8013e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8013e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013ed:	eb 1f                	jmp    80140e <strncpy+0x34>
		*dst++ = *src;
  8013ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f2:	8d 50 01             	lea    0x1(%eax),%edx
  8013f5:	89 55 08             	mov    %edx,0x8(%ebp)
  8013f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013fb:	8a 12                	mov    (%edx),%dl
  8013fd:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8013ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801402:	8a 00                	mov    (%eax),%al
  801404:	84 c0                	test   %al,%al
  801406:	74 03                	je     80140b <strncpy+0x31>
			src++;
  801408:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80140b:	ff 45 fc             	incl   -0x4(%ebp)
  80140e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801411:	3b 45 10             	cmp    0x10(%ebp),%eax
  801414:	72 d9                	jb     8013ef <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801416:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801419:	c9                   	leave  
  80141a:	c3                   	ret    

0080141b <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80141b:	55                   	push   %ebp
  80141c:	89 e5                	mov    %esp,%ebp
  80141e:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801421:	8b 45 08             	mov    0x8(%ebp),%eax
  801424:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801427:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80142b:	74 30                	je     80145d <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80142d:	eb 16                	jmp    801445 <strlcpy+0x2a>
			*dst++ = *src++;
  80142f:	8b 45 08             	mov    0x8(%ebp),%eax
  801432:	8d 50 01             	lea    0x1(%eax),%edx
  801435:	89 55 08             	mov    %edx,0x8(%ebp)
  801438:	8b 55 0c             	mov    0xc(%ebp),%edx
  80143b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80143e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801441:	8a 12                	mov    (%edx),%dl
  801443:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801445:	ff 4d 10             	decl   0x10(%ebp)
  801448:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80144c:	74 09                	je     801457 <strlcpy+0x3c>
  80144e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801451:	8a 00                	mov    (%eax),%al
  801453:	84 c0                	test   %al,%al
  801455:	75 d8                	jne    80142f <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801457:	8b 45 08             	mov    0x8(%ebp),%eax
  80145a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80145d:	8b 55 08             	mov    0x8(%ebp),%edx
  801460:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801463:	29 c2                	sub    %eax,%edx
  801465:	89 d0                	mov    %edx,%eax
}
  801467:	c9                   	leave  
  801468:	c3                   	ret    

00801469 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801469:	55                   	push   %ebp
  80146a:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80146c:	eb 06                	jmp    801474 <strcmp+0xb>
		p++, q++;
  80146e:	ff 45 08             	incl   0x8(%ebp)
  801471:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801474:	8b 45 08             	mov    0x8(%ebp),%eax
  801477:	8a 00                	mov    (%eax),%al
  801479:	84 c0                	test   %al,%al
  80147b:	74 0e                	je     80148b <strcmp+0x22>
  80147d:	8b 45 08             	mov    0x8(%ebp),%eax
  801480:	8a 10                	mov    (%eax),%dl
  801482:	8b 45 0c             	mov    0xc(%ebp),%eax
  801485:	8a 00                	mov    (%eax),%al
  801487:	38 c2                	cmp    %al,%dl
  801489:	74 e3                	je     80146e <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80148b:	8b 45 08             	mov    0x8(%ebp),%eax
  80148e:	8a 00                	mov    (%eax),%al
  801490:	0f b6 d0             	movzbl %al,%edx
  801493:	8b 45 0c             	mov    0xc(%ebp),%eax
  801496:	8a 00                	mov    (%eax),%al
  801498:	0f b6 c0             	movzbl %al,%eax
  80149b:	29 c2                	sub    %eax,%edx
  80149d:	89 d0                	mov    %edx,%eax
}
  80149f:	5d                   	pop    %ebp
  8014a0:	c3                   	ret    

008014a1 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8014a1:	55                   	push   %ebp
  8014a2:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8014a4:	eb 09                	jmp    8014af <strncmp+0xe>
		n--, p++, q++;
  8014a6:	ff 4d 10             	decl   0x10(%ebp)
  8014a9:	ff 45 08             	incl   0x8(%ebp)
  8014ac:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8014af:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014b3:	74 17                	je     8014cc <strncmp+0x2b>
  8014b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b8:	8a 00                	mov    (%eax),%al
  8014ba:	84 c0                	test   %al,%al
  8014bc:	74 0e                	je     8014cc <strncmp+0x2b>
  8014be:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c1:	8a 10                	mov    (%eax),%dl
  8014c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c6:	8a 00                	mov    (%eax),%al
  8014c8:	38 c2                	cmp    %al,%dl
  8014ca:	74 da                	je     8014a6 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8014cc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014d0:	75 07                	jne    8014d9 <strncmp+0x38>
		return 0;
  8014d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8014d7:	eb 14                	jmp    8014ed <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8014d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014dc:	8a 00                	mov    (%eax),%al
  8014de:	0f b6 d0             	movzbl %al,%edx
  8014e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e4:	8a 00                	mov    (%eax),%al
  8014e6:	0f b6 c0             	movzbl %al,%eax
  8014e9:	29 c2                	sub    %eax,%edx
  8014eb:	89 d0                	mov    %edx,%eax
}
  8014ed:	5d                   	pop    %ebp
  8014ee:	c3                   	ret    

008014ef <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8014ef:	55                   	push   %ebp
  8014f0:	89 e5                	mov    %esp,%ebp
  8014f2:	83 ec 04             	sub    $0x4,%esp
  8014f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f8:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8014fb:	eb 12                	jmp    80150f <strchr+0x20>
		if (*s == c)
  8014fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801500:	8a 00                	mov    (%eax),%al
  801502:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801505:	75 05                	jne    80150c <strchr+0x1d>
			return (char *) s;
  801507:	8b 45 08             	mov    0x8(%ebp),%eax
  80150a:	eb 11                	jmp    80151d <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80150c:	ff 45 08             	incl   0x8(%ebp)
  80150f:	8b 45 08             	mov    0x8(%ebp),%eax
  801512:	8a 00                	mov    (%eax),%al
  801514:	84 c0                	test   %al,%al
  801516:	75 e5                	jne    8014fd <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801518:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80151d:	c9                   	leave  
  80151e:	c3                   	ret    

0080151f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80151f:	55                   	push   %ebp
  801520:	89 e5                	mov    %esp,%ebp
  801522:	83 ec 04             	sub    $0x4,%esp
  801525:	8b 45 0c             	mov    0xc(%ebp),%eax
  801528:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80152b:	eb 0d                	jmp    80153a <strfind+0x1b>
		if (*s == c)
  80152d:	8b 45 08             	mov    0x8(%ebp),%eax
  801530:	8a 00                	mov    (%eax),%al
  801532:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801535:	74 0e                	je     801545 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801537:	ff 45 08             	incl   0x8(%ebp)
  80153a:	8b 45 08             	mov    0x8(%ebp),%eax
  80153d:	8a 00                	mov    (%eax),%al
  80153f:	84 c0                	test   %al,%al
  801541:	75 ea                	jne    80152d <strfind+0xe>
  801543:	eb 01                	jmp    801546 <strfind+0x27>
		if (*s == c)
			break;
  801545:	90                   	nop
	return (char *) s;
  801546:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801549:	c9                   	leave  
  80154a:	c3                   	ret    

0080154b <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  80154b:	55                   	push   %ebp
  80154c:	89 e5                	mov    %esp,%ebp
  80154e:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801551:	8b 45 08             	mov    0x8(%ebp),%eax
  801554:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801557:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80155b:	76 63                	jbe    8015c0 <memset+0x75>
		uint64 data_block = c;
  80155d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801560:	99                   	cltd   
  801561:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801564:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801567:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80156a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80156d:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801571:	c1 e0 08             	shl    $0x8,%eax
  801574:	09 45 f0             	or     %eax,-0x10(%ebp)
  801577:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  80157a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80157d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801580:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801584:	c1 e0 10             	shl    $0x10,%eax
  801587:	09 45 f0             	or     %eax,-0x10(%ebp)
  80158a:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  80158d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801590:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801593:	89 c2                	mov    %eax,%edx
  801595:	b8 00 00 00 00       	mov    $0x0,%eax
  80159a:	09 45 f0             	or     %eax,-0x10(%ebp)
  80159d:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  8015a0:	eb 18                	jmp    8015ba <memset+0x6f>
			*p64++ = data_block, n -= 8;
  8015a2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015a5:	8d 41 08             	lea    0x8(%ecx),%eax
  8015a8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8015ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015b1:	89 01                	mov    %eax,(%ecx)
  8015b3:	89 51 04             	mov    %edx,0x4(%ecx)
  8015b6:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  8015ba:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8015be:	77 e2                	ja     8015a2 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8015c0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015c4:	74 23                	je     8015e9 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8015c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015c9:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8015cc:	eb 0e                	jmp    8015dc <memset+0x91>
			*p8++ = (uint8)c;
  8015ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015d1:	8d 50 01             	lea    0x1(%eax),%edx
  8015d4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8015d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015da:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8015dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8015df:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015e2:	89 55 10             	mov    %edx,0x10(%ebp)
  8015e5:	85 c0                	test   %eax,%eax
  8015e7:	75 e5                	jne    8015ce <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8015e9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015ec:	c9                   	leave  
  8015ed:	c3                   	ret    

008015ee <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8015ee:	55                   	push   %ebp
  8015ef:	89 e5                	mov    %esp,%ebp
  8015f1:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8015f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8015fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801600:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801604:	76 24                	jbe    80162a <memcpy+0x3c>
		while(n >= 8){
  801606:	eb 1c                	jmp    801624 <memcpy+0x36>
			*d64 = *s64;
  801608:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80160b:	8b 50 04             	mov    0x4(%eax),%edx
  80160e:	8b 00                	mov    (%eax),%eax
  801610:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801613:	89 01                	mov    %eax,(%ecx)
  801615:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801618:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  80161c:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801620:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801624:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801628:	77 de                	ja     801608 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  80162a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80162e:	74 31                	je     801661 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801630:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801633:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801636:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801639:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  80163c:	eb 16                	jmp    801654 <memcpy+0x66>
			*d8++ = *s8++;
  80163e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801641:	8d 50 01             	lea    0x1(%eax),%edx
  801644:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801647:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80164a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80164d:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801650:	8a 12                	mov    (%edx),%dl
  801652:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801654:	8b 45 10             	mov    0x10(%ebp),%eax
  801657:	8d 50 ff             	lea    -0x1(%eax),%edx
  80165a:	89 55 10             	mov    %edx,0x10(%ebp)
  80165d:	85 c0                	test   %eax,%eax
  80165f:	75 dd                	jne    80163e <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801661:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801664:	c9                   	leave  
  801665:	c3                   	ret    

00801666 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801666:	55                   	push   %ebp
  801667:	89 e5                	mov    %esp,%ebp
  801669:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80166c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80166f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801672:	8b 45 08             	mov    0x8(%ebp),%eax
  801675:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801678:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80167b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80167e:	73 50                	jae    8016d0 <memmove+0x6a>
  801680:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801683:	8b 45 10             	mov    0x10(%ebp),%eax
  801686:	01 d0                	add    %edx,%eax
  801688:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80168b:	76 43                	jbe    8016d0 <memmove+0x6a>
		s += n;
  80168d:	8b 45 10             	mov    0x10(%ebp),%eax
  801690:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801693:	8b 45 10             	mov    0x10(%ebp),%eax
  801696:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801699:	eb 10                	jmp    8016ab <memmove+0x45>
			*--d = *--s;
  80169b:	ff 4d f8             	decl   -0x8(%ebp)
  80169e:	ff 4d fc             	decl   -0x4(%ebp)
  8016a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016a4:	8a 10                	mov    (%eax),%dl
  8016a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016a9:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8016ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ae:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016b1:	89 55 10             	mov    %edx,0x10(%ebp)
  8016b4:	85 c0                	test   %eax,%eax
  8016b6:	75 e3                	jne    80169b <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8016b8:	eb 23                	jmp    8016dd <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8016ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016bd:	8d 50 01             	lea    0x1(%eax),%edx
  8016c0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8016c3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016c6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016c9:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8016cc:	8a 12                	mov    (%edx),%dl
  8016ce:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8016d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8016d3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016d6:	89 55 10             	mov    %edx,0x10(%ebp)
  8016d9:	85 c0                	test   %eax,%eax
  8016db:	75 dd                	jne    8016ba <memmove+0x54>
			*d++ = *s++;

	return dst;
  8016dd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016e0:	c9                   	leave  
  8016e1:	c3                   	ret    

008016e2 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8016e2:	55                   	push   %ebp
  8016e3:	89 e5                	mov    %esp,%ebp
  8016e5:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8016e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016eb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8016ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f1:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8016f4:	eb 2a                	jmp    801720 <memcmp+0x3e>
		if (*s1 != *s2)
  8016f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016f9:	8a 10                	mov    (%eax),%dl
  8016fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016fe:	8a 00                	mov    (%eax),%al
  801700:	38 c2                	cmp    %al,%dl
  801702:	74 16                	je     80171a <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801704:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801707:	8a 00                	mov    (%eax),%al
  801709:	0f b6 d0             	movzbl %al,%edx
  80170c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80170f:	8a 00                	mov    (%eax),%al
  801711:	0f b6 c0             	movzbl %al,%eax
  801714:	29 c2                	sub    %eax,%edx
  801716:	89 d0                	mov    %edx,%eax
  801718:	eb 18                	jmp    801732 <memcmp+0x50>
		s1++, s2++;
  80171a:	ff 45 fc             	incl   -0x4(%ebp)
  80171d:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801720:	8b 45 10             	mov    0x10(%ebp),%eax
  801723:	8d 50 ff             	lea    -0x1(%eax),%edx
  801726:	89 55 10             	mov    %edx,0x10(%ebp)
  801729:	85 c0                	test   %eax,%eax
  80172b:	75 c9                	jne    8016f6 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80172d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801732:	c9                   	leave  
  801733:	c3                   	ret    

00801734 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801734:	55                   	push   %ebp
  801735:	89 e5                	mov    %esp,%ebp
  801737:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80173a:	8b 55 08             	mov    0x8(%ebp),%edx
  80173d:	8b 45 10             	mov    0x10(%ebp),%eax
  801740:	01 d0                	add    %edx,%eax
  801742:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801745:	eb 15                	jmp    80175c <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801747:	8b 45 08             	mov    0x8(%ebp),%eax
  80174a:	8a 00                	mov    (%eax),%al
  80174c:	0f b6 d0             	movzbl %al,%edx
  80174f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801752:	0f b6 c0             	movzbl %al,%eax
  801755:	39 c2                	cmp    %eax,%edx
  801757:	74 0d                	je     801766 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801759:	ff 45 08             	incl   0x8(%ebp)
  80175c:	8b 45 08             	mov    0x8(%ebp),%eax
  80175f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801762:	72 e3                	jb     801747 <memfind+0x13>
  801764:	eb 01                	jmp    801767 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801766:	90                   	nop
	return (void *) s;
  801767:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80176a:	c9                   	leave  
  80176b:	c3                   	ret    

0080176c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80176c:	55                   	push   %ebp
  80176d:	89 e5                	mov    %esp,%ebp
  80176f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801772:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801779:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801780:	eb 03                	jmp    801785 <strtol+0x19>
		s++;
  801782:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801785:	8b 45 08             	mov    0x8(%ebp),%eax
  801788:	8a 00                	mov    (%eax),%al
  80178a:	3c 20                	cmp    $0x20,%al
  80178c:	74 f4                	je     801782 <strtol+0x16>
  80178e:	8b 45 08             	mov    0x8(%ebp),%eax
  801791:	8a 00                	mov    (%eax),%al
  801793:	3c 09                	cmp    $0x9,%al
  801795:	74 eb                	je     801782 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801797:	8b 45 08             	mov    0x8(%ebp),%eax
  80179a:	8a 00                	mov    (%eax),%al
  80179c:	3c 2b                	cmp    $0x2b,%al
  80179e:	75 05                	jne    8017a5 <strtol+0x39>
		s++;
  8017a0:	ff 45 08             	incl   0x8(%ebp)
  8017a3:	eb 13                	jmp    8017b8 <strtol+0x4c>
	else if (*s == '-')
  8017a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a8:	8a 00                	mov    (%eax),%al
  8017aa:	3c 2d                	cmp    $0x2d,%al
  8017ac:	75 0a                	jne    8017b8 <strtol+0x4c>
		s++, neg = 1;
  8017ae:	ff 45 08             	incl   0x8(%ebp)
  8017b1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8017b8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017bc:	74 06                	je     8017c4 <strtol+0x58>
  8017be:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8017c2:	75 20                	jne    8017e4 <strtol+0x78>
  8017c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c7:	8a 00                	mov    (%eax),%al
  8017c9:	3c 30                	cmp    $0x30,%al
  8017cb:	75 17                	jne    8017e4 <strtol+0x78>
  8017cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d0:	40                   	inc    %eax
  8017d1:	8a 00                	mov    (%eax),%al
  8017d3:	3c 78                	cmp    $0x78,%al
  8017d5:	75 0d                	jne    8017e4 <strtol+0x78>
		s += 2, base = 16;
  8017d7:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8017db:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8017e2:	eb 28                	jmp    80180c <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8017e4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017e8:	75 15                	jne    8017ff <strtol+0x93>
  8017ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ed:	8a 00                	mov    (%eax),%al
  8017ef:	3c 30                	cmp    $0x30,%al
  8017f1:	75 0c                	jne    8017ff <strtol+0x93>
		s++, base = 8;
  8017f3:	ff 45 08             	incl   0x8(%ebp)
  8017f6:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8017fd:	eb 0d                	jmp    80180c <strtol+0xa0>
	else if (base == 0)
  8017ff:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801803:	75 07                	jne    80180c <strtol+0xa0>
		base = 10;
  801805:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80180c:	8b 45 08             	mov    0x8(%ebp),%eax
  80180f:	8a 00                	mov    (%eax),%al
  801811:	3c 2f                	cmp    $0x2f,%al
  801813:	7e 19                	jle    80182e <strtol+0xc2>
  801815:	8b 45 08             	mov    0x8(%ebp),%eax
  801818:	8a 00                	mov    (%eax),%al
  80181a:	3c 39                	cmp    $0x39,%al
  80181c:	7f 10                	jg     80182e <strtol+0xc2>
			dig = *s - '0';
  80181e:	8b 45 08             	mov    0x8(%ebp),%eax
  801821:	8a 00                	mov    (%eax),%al
  801823:	0f be c0             	movsbl %al,%eax
  801826:	83 e8 30             	sub    $0x30,%eax
  801829:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80182c:	eb 42                	jmp    801870 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80182e:	8b 45 08             	mov    0x8(%ebp),%eax
  801831:	8a 00                	mov    (%eax),%al
  801833:	3c 60                	cmp    $0x60,%al
  801835:	7e 19                	jle    801850 <strtol+0xe4>
  801837:	8b 45 08             	mov    0x8(%ebp),%eax
  80183a:	8a 00                	mov    (%eax),%al
  80183c:	3c 7a                	cmp    $0x7a,%al
  80183e:	7f 10                	jg     801850 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801840:	8b 45 08             	mov    0x8(%ebp),%eax
  801843:	8a 00                	mov    (%eax),%al
  801845:	0f be c0             	movsbl %al,%eax
  801848:	83 e8 57             	sub    $0x57,%eax
  80184b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80184e:	eb 20                	jmp    801870 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801850:	8b 45 08             	mov    0x8(%ebp),%eax
  801853:	8a 00                	mov    (%eax),%al
  801855:	3c 40                	cmp    $0x40,%al
  801857:	7e 39                	jle    801892 <strtol+0x126>
  801859:	8b 45 08             	mov    0x8(%ebp),%eax
  80185c:	8a 00                	mov    (%eax),%al
  80185e:	3c 5a                	cmp    $0x5a,%al
  801860:	7f 30                	jg     801892 <strtol+0x126>
			dig = *s - 'A' + 10;
  801862:	8b 45 08             	mov    0x8(%ebp),%eax
  801865:	8a 00                	mov    (%eax),%al
  801867:	0f be c0             	movsbl %al,%eax
  80186a:	83 e8 37             	sub    $0x37,%eax
  80186d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801870:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801873:	3b 45 10             	cmp    0x10(%ebp),%eax
  801876:	7d 19                	jge    801891 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801878:	ff 45 08             	incl   0x8(%ebp)
  80187b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80187e:	0f af 45 10          	imul   0x10(%ebp),%eax
  801882:	89 c2                	mov    %eax,%edx
  801884:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801887:	01 d0                	add    %edx,%eax
  801889:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80188c:	e9 7b ff ff ff       	jmp    80180c <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801891:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801892:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801896:	74 08                	je     8018a0 <strtol+0x134>
		*endptr = (char *) s;
  801898:	8b 45 0c             	mov    0xc(%ebp),%eax
  80189b:	8b 55 08             	mov    0x8(%ebp),%edx
  80189e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8018a0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8018a4:	74 07                	je     8018ad <strtol+0x141>
  8018a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018a9:	f7 d8                	neg    %eax
  8018ab:	eb 03                	jmp    8018b0 <strtol+0x144>
  8018ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8018b0:	c9                   	leave  
  8018b1:	c3                   	ret    

008018b2 <ltostr>:

void
ltostr(long value, char *str)
{
  8018b2:	55                   	push   %ebp
  8018b3:	89 e5                	mov    %esp,%ebp
  8018b5:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8018b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8018bf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8018c6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018ca:	79 13                	jns    8018df <ltostr+0x2d>
	{
		neg = 1;
  8018cc:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8018d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018d6:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8018d9:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8018dc:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8018df:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e2:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8018e7:	99                   	cltd   
  8018e8:	f7 f9                	idiv   %ecx
  8018ea:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8018ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018f0:	8d 50 01             	lea    0x1(%eax),%edx
  8018f3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8018f6:	89 c2                	mov    %eax,%edx
  8018f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018fb:	01 d0                	add    %edx,%eax
  8018fd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801900:	83 c2 30             	add    $0x30,%edx
  801903:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801905:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801908:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80190d:	f7 e9                	imul   %ecx
  80190f:	c1 fa 02             	sar    $0x2,%edx
  801912:	89 c8                	mov    %ecx,%eax
  801914:	c1 f8 1f             	sar    $0x1f,%eax
  801917:	29 c2                	sub    %eax,%edx
  801919:	89 d0                	mov    %edx,%eax
  80191b:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80191e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801922:	75 bb                	jne    8018df <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801924:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80192b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80192e:	48                   	dec    %eax
  80192f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801932:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801936:	74 3d                	je     801975 <ltostr+0xc3>
		start = 1 ;
  801938:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80193f:	eb 34                	jmp    801975 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801941:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801944:	8b 45 0c             	mov    0xc(%ebp),%eax
  801947:	01 d0                	add    %edx,%eax
  801949:	8a 00                	mov    (%eax),%al
  80194b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80194e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801951:	8b 45 0c             	mov    0xc(%ebp),%eax
  801954:	01 c2                	add    %eax,%edx
  801956:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801959:	8b 45 0c             	mov    0xc(%ebp),%eax
  80195c:	01 c8                	add    %ecx,%eax
  80195e:	8a 00                	mov    (%eax),%al
  801960:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801962:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801965:	8b 45 0c             	mov    0xc(%ebp),%eax
  801968:	01 c2                	add    %eax,%edx
  80196a:	8a 45 eb             	mov    -0x15(%ebp),%al
  80196d:	88 02                	mov    %al,(%edx)
		start++ ;
  80196f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801972:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801975:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801978:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80197b:	7c c4                	jl     801941 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80197d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801980:	8b 45 0c             	mov    0xc(%ebp),%eax
  801983:	01 d0                	add    %edx,%eax
  801985:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801988:	90                   	nop
  801989:	c9                   	leave  
  80198a:	c3                   	ret    

0080198b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80198b:	55                   	push   %ebp
  80198c:	89 e5                	mov    %esp,%ebp
  80198e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801991:	ff 75 08             	pushl  0x8(%ebp)
  801994:	e8 c4 f9 ff ff       	call   80135d <strlen>
  801999:	83 c4 04             	add    $0x4,%esp
  80199c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80199f:	ff 75 0c             	pushl  0xc(%ebp)
  8019a2:	e8 b6 f9 ff ff       	call   80135d <strlen>
  8019a7:	83 c4 04             	add    $0x4,%esp
  8019aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8019ad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8019b4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8019bb:	eb 17                	jmp    8019d4 <strcconcat+0x49>
		final[s] = str1[s] ;
  8019bd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8019c3:	01 c2                	add    %eax,%edx
  8019c5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8019c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cb:	01 c8                	add    %ecx,%eax
  8019cd:	8a 00                	mov    (%eax),%al
  8019cf:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8019d1:	ff 45 fc             	incl   -0x4(%ebp)
  8019d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019d7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8019da:	7c e1                	jl     8019bd <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8019dc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8019e3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8019ea:	eb 1f                	jmp    801a0b <strcconcat+0x80>
		final[s++] = str2[i] ;
  8019ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019ef:	8d 50 01             	lea    0x1(%eax),%edx
  8019f2:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8019f5:	89 c2                	mov    %eax,%edx
  8019f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8019fa:	01 c2                	add    %eax,%edx
  8019fc:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8019ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a02:	01 c8                	add    %ecx,%eax
  801a04:	8a 00                	mov    (%eax),%al
  801a06:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801a08:	ff 45 f8             	incl   -0x8(%ebp)
  801a0b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a0e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a11:	7c d9                	jl     8019ec <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801a13:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a16:	8b 45 10             	mov    0x10(%ebp),%eax
  801a19:	01 d0                	add    %edx,%eax
  801a1b:	c6 00 00             	movb   $0x0,(%eax)
}
  801a1e:	90                   	nop
  801a1f:	c9                   	leave  
  801a20:	c3                   	ret    

00801a21 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801a21:	55                   	push   %ebp
  801a22:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801a24:	8b 45 14             	mov    0x14(%ebp),%eax
  801a27:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801a2d:	8b 45 14             	mov    0x14(%ebp),%eax
  801a30:	8b 00                	mov    (%eax),%eax
  801a32:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a39:	8b 45 10             	mov    0x10(%ebp),%eax
  801a3c:	01 d0                	add    %edx,%eax
  801a3e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a44:	eb 0c                	jmp    801a52 <strsplit+0x31>
			*string++ = 0;
  801a46:	8b 45 08             	mov    0x8(%ebp),%eax
  801a49:	8d 50 01             	lea    0x1(%eax),%edx
  801a4c:	89 55 08             	mov    %edx,0x8(%ebp)
  801a4f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a52:	8b 45 08             	mov    0x8(%ebp),%eax
  801a55:	8a 00                	mov    (%eax),%al
  801a57:	84 c0                	test   %al,%al
  801a59:	74 18                	je     801a73 <strsplit+0x52>
  801a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5e:	8a 00                	mov    (%eax),%al
  801a60:	0f be c0             	movsbl %al,%eax
  801a63:	50                   	push   %eax
  801a64:	ff 75 0c             	pushl  0xc(%ebp)
  801a67:	e8 83 fa ff ff       	call   8014ef <strchr>
  801a6c:	83 c4 08             	add    $0x8,%esp
  801a6f:	85 c0                	test   %eax,%eax
  801a71:	75 d3                	jne    801a46 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801a73:	8b 45 08             	mov    0x8(%ebp),%eax
  801a76:	8a 00                	mov    (%eax),%al
  801a78:	84 c0                	test   %al,%al
  801a7a:	74 5a                	je     801ad6 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801a7c:	8b 45 14             	mov    0x14(%ebp),%eax
  801a7f:	8b 00                	mov    (%eax),%eax
  801a81:	83 f8 0f             	cmp    $0xf,%eax
  801a84:	75 07                	jne    801a8d <strsplit+0x6c>
		{
			return 0;
  801a86:	b8 00 00 00 00       	mov    $0x0,%eax
  801a8b:	eb 66                	jmp    801af3 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801a8d:	8b 45 14             	mov    0x14(%ebp),%eax
  801a90:	8b 00                	mov    (%eax),%eax
  801a92:	8d 48 01             	lea    0x1(%eax),%ecx
  801a95:	8b 55 14             	mov    0x14(%ebp),%edx
  801a98:	89 0a                	mov    %ecx,(%edx)
  801a9a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801aa1:	8b 45 10             	mov    0x10(%ebp),%eax
  801aa4:	01 c2                	add    %eax,%edx
  801aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa9:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801aab:	eb 03                	jmp    801ab0 <strsplit+0x8f>
			string++;
  801aad:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab3:	8a 00                	mov    (%eax),%al
  801ab5:	84 c0                	test   %al,%al
  801ab7:	74 8b                	je     801a44 <strsplit+0x23>
  801ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  801abc:	8a 00                	mov    (%eax),%al
  801abe:	0f be c0             	movsbl %al,%eax
  801ac1:	50                   	push   %eax
  801ac2:	ff 75 0c             	pushl  0xc(%ebp)
  801ac5:	e8 25 fa ff ff       	call   8014ef <strchr>
  801aca:	83 c4 08             	add    $0x8,%esp
  801acd:	85 c0                	test   %eax,%eax
  801acf:	74 dc                	je     801aad <strsplit+0x8c>
			string++;
	}
  801ad1:	e9 6e ff ff ff       	jmp    801a44 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801ad6:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801ad7:	8b 45 14             	mov    0x14(%ebp),%eax
  801ada:	8b 00                	mov    (%eax),%eax
  801adc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ae3:	8b 45 10             	mov    0x10(%ebp),%eax
  801ae6:	01 d0                	add    %edx,%eax
  801ae8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801aee:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801af3:	c9                   	leave  
  801af4:	c3                   	ret    

00801af5 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801af5:	55                   	push   %ebp
  801af6:	89 e5                	mov    %esp,%ebp
  801af8:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801afb:	8b 45 08             	mov    0x8(%ebp),%eax
  801afe:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801b01:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801b08:	eb 4a                	jmp    801b54 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801b0a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b10:	01 c2                	add    %eax,%edx
  801b12:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801b15:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b18:	01 c8                	add    %ecx,%eax
  801b1a:	8a 00                	mov    (%eax),%al
  801b1c:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801b1e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b21:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b24:	01 d0                	add    %edx,%eax
  801b26:	8a 00                	mov    (%eax),%al
  801b28:	3c 40                	cmp    $0x40,%al
  801b2a:	7e 25                	jle    801b51 <str2lower+0x5c>
  801b2c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b32:	01 d0                	add    %edx,%eax
  801b34:	8a 00                	mov    (%eax),%al
  801b36:	3c 5a                	cmp    $0x5a,%al
  801b38:	7f 17                	jg     801b51 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801b3a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b40:	01 d0                	add    %edx,%eax
  801b42:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801b45:	8b 55 08             	mov    0x8(%ebp),%edx
  801b48:	01 ca                	add    %ecx,%edx
  801b4a:	8a 12                	mov    (%edx),%dl
  801b4c:	83 c2 20             	add    $0x20,%edx
  801b4f:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801b51:	ff 45 fc             	incl   -0x4(%ebp)
  801b54:	ff 75 0c             	pushl  0xc(%ebp)
  801b57:	e8 01 f8 ff ff       	call   80135d <strlen>
  801b5c:	83 c4 04             	add    $0x4,%esp
  801b5f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801b62:	7f a6                	jg     801b0a <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801b64:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801b67:	c9                   	leave  
  801b68:	c3                   	ret    

00801b69 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801b69:	55                   	push   %ebp
  801b6a:	89 e5                	mov    %esp,%ebp
  801b6c:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801b6f:	a1 08 40 80 00       	mov    0x804008,%eax
  801b74:	85 c0                	test   %eax,%eax
  801b76:	74 42                	je     801bba <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801b78:	83 ec 08             	sub    $0x8,%esp
  801b7b:	68 00 00 00 82       	push   $0x82000000
  801b80:	68 00 00 00 80       	push   $0x80000000
  801b85:	e8 8c 07 00 00       	call   802316 <initialize_dynamic_allocator>
  801b8a:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801b8d:	e8 e7 05 00 00       	call   802179 <sys_get_uheap_strategy>
  801b92:	a3 60 c0 81 00       	mov    %eax,0x81c060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801b97:	a1 40 40 80 00       	mov    0x804040,%eax
  801b9c:	05 00 10 00 00       	add    $0x1000,%eax
  801ba1:	a3 10 c1 81 00       	mov    %eax,0x81c110
		uheapPageAllocBreak = uheapPageAllocStart;
  801ba6:	a1 10 c1 81 00       	mov    0x81c110,%eax
  801bab:	a3 68 c0 81 00       	mov    %eax,0x81c068

		__firstTimeFlag = 0;
  801bb0:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  801bb7:	00 00 00 
	}
}
  801bba:	90                   	nop
  801bbb:	c9                   	leave  
  801bbc:	c3                   	ret    

00801bbd <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801bbd:	55                   	push   %ebp
  801bbe:	89 e5                	mov    %esp,%ebp
  801bc0:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801bc3:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801bc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bcc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801bd1:	83 ec 08             	sub    $0x8,%esp
  801bd4:	68 06 04 00 00       	push   $0x406
  801bd9:	50                   	push   %eax
  801bda:	e8 e4 01 00 00       	call   801dc3 <__sys_allocate_page>
  801bdf:	83 c4 10             	add    $0x10,%esp
  801be2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801be5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801be9:	79 14                	jns    801bff <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801beb:	83 ec 04             	sub    $0x4,%esp
  801bee:	68 bc 2e 80 00       	push   $0x802ebc
  801bf3:	6a 1f                	push   $0x1f
  801bf5:	68 f8 2e 80 00       	push   $0x802ef8
  801bfa:	e8 af eb ff ff       	call   8007ae <_panic>
	return 0;
  801bff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c04:	c9                   	leave  
  801c05:	c3                   	ret    

00801c06 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801c06:	55                   	push   %ebp
  801c07:	89 e5                	mov    %esp,%ebp
  801c09:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801c0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c15:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801c1a:	83 ec 0c             	sub    $0xc,%esp
  801c1d:	50                   	push   %eax
  801c1e:	e8 e7 01 00 00       	call   801e0a <__sys_unmap_frame>
  801c23:	83 c4 10             	add    $0x10,%esp
  801c26:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801c29:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801c2d:	79 14                	jns    801c43 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801c2f:	83 ec 04             	sub    $0x4,%esp
  801c32:	68 04 2f 80 00       	push   $0x802f04
  801c37:	6a 2a                	push   $0x2a
  801c39:	68 f8 2e 80 00       	push   $0x802ef8
  801c3e:	e8 6b eb ff ff       	call   8007ae <_panic>
}
  801c43:	90                   	nop
  801c44:	c9                   	leave  
  801c45:	c3                   	ret    

00801c46 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801c46:	55                   	push   %ebp
  801c47:	89 e5                	mov    %esp,%ebp
  801c49:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801c4c:	e8 18 ff ff ff       	call   801b69 <uheap_init>
	if (size == 0) return NULL ;
  801c51:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801c55:	75 07                	jne    801c5e <malloc+0x18>
  801c57:	b8 00 00 00 00       	mov    $0x0,%eax
  801c5c:	eb 14                	jmp    801c72 <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  801c5e:	83 ec 04             	sub    $0x4,%esp
  801c61:	68 44 2f 80 00       	push   $0x802f44
  801c66:	6a 3e                	push   $0x3e
  801c68:	68 f8 2e 80 00       	push   $0x802ef8
  801c6d:	e8 3c eb ff ff       	call   8007ae <_panic>
}
  801c72:	c9                   	leave  
  801c73:	c3                   	ret    

00801c74 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801c74:	55                   	push   %ebp
  801c75:	89 e5                	mov    %esp,%ebp
  801c77:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  801c7a:	83 ec 04             	sub    $0x4,%esp
  801c7d:	68 6c 2f 80 00       	push   $0x802f6c
  801c82:	6a 49                	push   $0x49
  801c84:	68 f8 2e 80 00       	push   $0x802ef8
  801c89:	e8 20 eb ff ff       	call   8007ae <_panic>

00801c8e <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801c8e:	55                   	push   %ebp
  801c8f:	89 e5                	mov    %esp,%ebp
  801c91:	83 ec 18             	sub    $0x18,%esp
  801c94:	8b 45 10             	mov    0x10(%ebp),%eax
  801c97:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801c9a:	e8 ca fe ff ff       	call   801b69 <uheap_init>
	if (size == 0) return NULL ;
  801c9f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ca3:	75 07                	jne    801cac <smalloc+0x1e>
  801ca5:	b8 00 00 00 00       	mov    $0x0,%eax
  801caa:	eb 14                	jmp    801cc0 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  801cac:	83 ec 04             	sub    $0x4,%esp
  801caf:	68 90 2f 80 00       	push   $0x802f90
  801cb4:	6a 5a                	push   $0x5a
  801cb6:	68 f8 2e 80 00       	push   $0x802ef8
  801cbb:	e8 ee ea ff ff       	call   8007ae <_panic>
}
  801cc0:	c9                   	leave  
  801cc1:	c3                   	ret    

00801cc2 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801cc2:	55                   	push   %ebp
  801cc3:	89 e5                	mov    %esp,%ebp
  801cc5:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801cc8:	e8 9c fe ff ff       	call   801b69 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  801ccd:	83 ec 04             	sub    $0x4,%esp
  801cd0:	68 b8 2f 80 00       	push   $0x802fb8
  801cd5:	6a 6a                	push   $0x6a
  801cd7:	68 f8 2e 80 00       	push   $0x802ef8
  801cdc:	e8 cd ea ff ff       	call   8007ae <_panic>

00801ce1 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801ce1:	55                   	push   %ebp
  801ce2:	89 e5                	mov    %esp,%ebp
  801ce4:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801ce7:	e8 7d fe ff ff       	call   801b69 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  801cec:	83 ec 04             	sub    $0x4,%esp
  801cef:	68 dc 2f 80 00       	push   $0x802fdc
  801cf4:	68 88 00 00 00       	push   $0x88
  801cf9:	68 f8 2e 80 00       	push   $0x802ef8
  801cfe:	e8 ab ea ff ff       	call   8007ae <_panic>

00801d03 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  801d03:	55                   	push   %ebp
  801d04:	89 e5                	mov    %esp,%ebp
  801d06:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  801d09:	83 ec 04             	sub    $0x4,%esp
  801d0c:	68 04 30 80 00       	push   $0x803004
  801d11:	68 9b 00 00 00       	push   $0x9b
  801d16:	68 f8 2e 80 00       	push   $0x802ef8
  801d1b:	e8 8e ea ff ff       	call   8007ae <_panic>

00801d20 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801d20:	55                   	push   %ebp
  801d21:	89 e5                	mov    %esp,%ebp
  801d23:	57                   	push   %edi
  801d24:	56                   	push   %esi
  801d25:	53                   	push   %ebx
  801d26:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801d29:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d2f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d32:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d35:	8b 7d 18             	mov    0x18(%ebp),%edi
  801d38:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801d3b:	cd 30                	int    $0x30
  801d3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801d40:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801d43:	83 c4 10             	add    $0x10,%esp
  801d46:	5b                   	pop    %ebx
  801d47:	5e                   	pop    %esi
  801d48:	5f                   	pop    %edi
  801d49:	5d                   	pop    %ebp
  801d4a:	c3                   	ret    

00801d4b <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801d4b:	55                   	push   %ebp
  801d4c:	89 e5                	mov    %esp,%ebp
  801d4e:	83 ec 04             	sub    $0x4,%esp
  801d51:	8b 45 10             	mov    0x10(%ebp),%eax
  801d54:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801d57:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d5a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d61:	6a 00                	push   $0x0
  801d63:	51                   	push   %ecx
  801d64:	52                   	push   %edx
  801d65:	ff 75 0c             	pushl  0xc(%ebp)
  801d68:	50                   	push   %eax
  801d69:	6a 00                	push   $0x0
  801d6b:	e8 b0 ff ff ff       	call   801d20 <syscall>
  801d70:	83 c4 18             	add    $0x18,%esp
}
  801d73:	90                   	nop
  801d74:	c9                   	leave  
  801d75:	c3                   	ret    

00801d76 <sys_cgetc>:

int
sys_cgetc(void)
{
  801d76:	55                   	push   %ebp
  801d77:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801d79:	6a 00                	push   $0x0
  801d7b:	6a 00                	push   $0x0
  801d7d:	6a 00                	push   $0x0
  801d7f:	6a 00                	push   $0x0
  801d81:	6a 00                	push   $0x0
  801d83:	6a 02                	push   $0x2
  801d85:	e8 96 ff ff ff       	call   801d20 <syscall>
  801d8a:	83 c4 18             	add    $0x18,%esp
}
  801d8d:	c9                   	leave  
  801d8e:	c3                   	ret    

00801d8f <sys_lock_cons>:

void sys_lock_cons(void)
{
  801d8f:	55                   	push   %ebp
  801d90:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801d92:	6a 00                	push   $0x0
  801d94:	6a 00                	push   $0x0
  801d96:	6a 00                	push   $0x0
  801d98:	6a 00                	push   $0x0
  801d9a:	6a 00                	push   $0x0
  801d9c:	6a 03                	push   $0x3
  801d9e:	e8 7d ff ff ff       	call   801d20 <syscall>
  801da3:	83 c4 18             	add    $0x18,%esp
}
  801da6:	90                   	nop
  801da7:	c9                   	leave  
  801da8:	c3                   	ret    

00801da9 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801da9:	55                   	push   %ebp
  801daa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801dac:	6a 00                	push   $0x0
  801dae:	6a 00                	push   $0x0
  801db0:	6a 00                	push   $0x0
  801db2:	6a 00                	push   $0x0
  801db4:	6a 00                	push   $0x0
  801db6:	6a 04                	push   $0x4
  801db8:	e8 63 ff ff ff       	call   801d20 <syscall>
  801dbd:	83 c4 18             	add    $0x18,%esp
}
  801dc0:	90                   	nop
  801dc1:	c9                   	leave  
  801dc2:	c3                   	ret    

00801dc3 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801dc3:	55                   	push   %ebp
  801dc4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801dc6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dcc:	6a 00                	push   $0x0
  801dce:	6a 00                	push   $0x0
  801dd0:	6a 00                	push   $0x0
  801dd2:	52                   	push   %edx
  801dd3:	50                   	push   %eax
  801dd4:	6a 08                	push   $0x8
  801dd6:	e8 45 ff ff ff       	call   801d20 <syscall>
  801ddb:	83 c4 18             	add    $0x18,%esp
}
  801dde:	c9                   	leave  
  801ddf:	c3                   	ret    

00801de0 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801de0:	55                   	push   %ebp
  801de1:	89 e5                	mov    %esp,%ebp
  801de3:	56                   	push   %esi
  801de4:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801de5:	8b 75 18             	mov    0x18(%ebp),%esi
  801de8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801deb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801dee:	8b 55 0c             	mov    0xc(%ebp),%edx
  801df1:	8b 45 08             	mov    0x8(%ebp),%eax
  801df4:	56                   	push   %esi
  801df5:	53                   	push   %ebx
  801df6:	51                   	push   %ecx
  801df7:	52                   	push   %edx
  801df8:	50                   	push   %eax
  801df9:	6a 09                	push   $0x9
  801dfb:	e8 20 ff ff ff       	call   801d20 <syscall>
  801e00:	83 c4 18             	add    $0x18,%esp
}
  801e03:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e06:	5b                   	pop    %ebx
  801e07:	5e                   	pop    %esi
  801e08:	5d                   	pop    %ebp
  801e09:	c3                   	ret    

00801e0a <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801e0a:	55                   	push   %ebp
  801e0b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 00                	push   $0x0
  801e13:	6a 00                	push   $0x0
  801e15:	ff 75 08             	pushl  0x8(%ebp)
  801e18:	6a 0a                	push   $0xa
  801e1a:	e8 01 ff ff ff       	call   801d20 <syscall>
  801e1f:	83 c4 18             	add    $0x18,%esp
}
  801e22:	c9                   	leave  
  801e23:	c3                   	ret    

00801e24 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801e24:	55                   	push   %ebp
  801e25:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801e27:	6a 00                	push   $0x0
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 00                	push   $0x0
  801e2d:	ff 75 0c             	pushl  0xc(%ebp)
  801e30:	ff 75 08             	pushl  0x8(%ebp)
  801e33:	6a 0b                	push   $0xb
  801e35:	e8 e6 fe ff ff       	call   801d20 <syscall>
  801e3a:	83 c4 18             	add    $0x18,%esp
}
  801e3d:	c9                   	leave  
  801e3e:	c3                   	ret    

00801e3f <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801e3f:	55                   	push   %ebp
  801e40:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801e42:	6a 00                	push   $0x0
  801e44:	6a 00                	push   $0x0
  801e46:	6a 00                	push   $0x0
  801e48:	6a 00                	push   $0x0
  801e4a:	6a 00                	push   $0x0
  801e4c:	6a 0c                	push   $0xc
  801e4e:	e8 cd fe ff ff       	call   801d20 <syscall>
  801e53:	83 c4 18             	add    $0x18,%esp
}
  801e56:	c9                   	leave  
  801e57:	c3                   	ret    

00801e58 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801e58:	55                   	push   %ebp
  801e59:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801e5b:	6a 00                	push   $0x0
  801e5d:	6a 00                	push   $0x0
  801e5f:	6a 00                	push   $0x0
  801e61:	6a 00                	push   $0x0
  801e63:	6a 00                	push   $0x0
  801e65:	6a 0d                	push   $0xd
  801e67:	e8 b4 fe ff ff       	call   801d20 <syscall>
  801e6c:	83 c4 18             	add    $0x18,%esp
}
  801e6f:	c9                   	leave  
  801e70:	c3                   	ret    

00801e71 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801e71:	55                   	push   %ebp
  801e72:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801e74:	6a 00                	push   $0x0
  801e76:	6a 00                	push   $0x0
  801e78:	6a 00                	push   $0x0
  801e7a:	6a 00                	push   $0x0
  801e7c:	6a 00                	push   $0x0
  801e7e:	6a 0e                	push   $0xe
  801e80:	e8 9b fe ff ff       	call   801d20 <syscall>
  801e85:	83 c4 18             	add    $0x18,%esp
}
  801e88:	c9                   	leave  
  801e89:	c3                   	ret    

00801e8a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801e8a:	55                   	push   %ebp
  801e8b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801e8d:	6a 00                	push   $0x0
  801e8f:	6a 00                	push   $0x0
  801e91:	6a 00                	push   $0x0
  801e93:	6a 00                	push   $0x0
  801e95:	6a 00                	push   $0x0
  801e97:	6a 0f                	push   $0xf
  801e99:	e8 82 fe ff ff       	call   801d20 <syscall>
  801e9e:	83 c4 18             	add    $0x18,%esp
}
  801ea1:	c9                   	leave  
  801ea2:	c3                   	ret    

00801ea3 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801ea3:	55                   	push   %ebp
  801ea4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801ea6:	6a 00                	push   $0x0
  801ea8:	6a 00                	push   $0x0
  801eaa:	6a 00                	push   $0x0
  801eac:	6a 00                	push   $0x0
  801eae:	ff 75 08             	pushl  0x8(%ebp)
  801eb1:	6a 10                	push   $0x10
  801eb3:	e8 68 fe ff ff       	call   801d20 <syscall>
  801eb8:	83 c4 18             	add    $0x18,%esp
}
  801ebb:	c9                   	leave  
  801ebc:	c3                   	ret    

00801ebd <sys_scarce_memory>:

void sys_scarce_memory()
{
  801ebd:	55                   	push   %ebp
  801ebe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801ec0:	6a 00                	push   $0x0
  801ec2:	6a 00                	push   $0x0
  801ec4:	6a 00                	push   $0x0
  801ec6:	6a 00                	push   $0x0
  801ec8:	6a 00                	push   $0x0
  801eca:	6a 11                	push   $0x11
  801ecc:	e8 4f fe ff ff       	call   801d20 <syscall>
  801ed1:	83 c4 18             	add    $0x18,%esp
}
  801ed4:	90                   	nop
  801ed5:	c9                   	leave  
  801ed6:	c3                   	ret    

00801ed7 <sys_cputc>:

void
sys_cputc(const char c)
{
  801ed7:	55                   	push   %ebp
  801ed8:	89 e5                	mov    %esp,%ebp
  801eda:	83 ec 04             	sub    $0x4,%esp
  801edd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801ee3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ee7:	6a 00                	push   $0x0
  801ee9:	6a 00                	push   $0x0
  801eeb:	6a 00                	push   $0x0
  801eed:	6a 00                	push   $0x0
  801eef:	50                   	push   %eax
  801ef0:	6a 01                	push   $0x1
  801ef2:	e8 29 fe ff ff       	call   801d20 <syscall>
  801ef7:	83 c4 18             	add    $0x18,%esp
}
  801efa:	90                   	nop
  801efb:	c9                   	leave  
  801efc:	c3                   	ret    

00801efd <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801efd:	55                   	push   %ebp
  801efe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801f00:	6a 00                	push   $0x0
  801f02:	6a 00                	push   $0x0
  801f04:	6a 00                	push   $0x0
  801f06:	6a 00                	push   $0x0
  801f08:	6a 00                	push   $0x0
  801f0a:	6a 14                	push   $0x14
  801f0c:	e8 0f fe ff ff       	call   801d20 <syscall>
  801f11:	83 c4 18             	add    $0x18,%esp
}
  801f14:	90                   	nop
  801f15:	c9                   	leave  
  801f16:	c3                   	ret    

00801f17 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801f17:	55                   	push   %ebp
  801f18:	89 e5                	mov    %esp,%ebp
  801f1a:	83 ec 04             	sub    $0x4,%esp
  801f1d:	8b 45 10             	mov    0x10(%ebp),%eax
  801f20:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801f23:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801f26:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2d:	6a 00                	push   $0x0
  801f2f:	51                   	push   %ecx
  801f30:	52                   	push   %edx
  801f31:	ff 75 0c             	pushl  0xc(%ebp)
  801f34:	50                   	push   %eax
  801f35:	6a 15                	push   $0x15
  801f37:	e8 e4 fd ff ff       	call   801d20 <syscall>
  801f3c:	83 c4 18             	add    $0x18,%esp
}
  801f3f:	c9                   	leave  
  801f40:	c3                   	ret    

00801f41 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801f41:	55                   	push   %ebp
  801f42:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801f44:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f47:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4a:	6a 00                	push   $0x0
  801f4c:	6a 00                	push   $0x0
  801f4e:	6a 00                	push   $0x0
  801f50:	52                   	push   %edx
  801f51:	50                   	push   %eax
  801f52:	6a 16                	push   $0x16
  801f54:	e8 c7 fd ff ff       	call   801d20 <syscall>
  801f59:	83 c4 18             	add    $0x18,%esp
}
  801f5c:	c9                   	leave  
  801f5d:	c3                   	ret    

00801f5e <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801f5e:	55                   	push   %ebp
  801f5f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801f61:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f64:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f67:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6a:	6a 00                	push   $0x0
  801f6c:	6a 00                	push   $0x0
  801f6e:	51                   	push   %ecx
  801f6f:	52                   	push   %edx
  801f70:	50                   	push   %eax
  801f71:	6a 17                	push   $0x17
  801f73:	e8 a8 fd ff ff       	call   801d20 <syscall>
  801f78:	83 c4 18             	add    $0x18,%esp
}
  801f7b:	c9                   	leave  
  801f7c:	c3                   	ret    

00801f7d <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801f7d:	55                   	push   %ebp
  801f7e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801f80:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f83:	8b 45 08             	mov    0x8(%ebp),%eax
  801f86:	6a 00                	push   $0x0
  801f88:	6a 00                	push   $0x0
  801f8a:	6a 00                	push   $0x0
  801f8c:	52                   	push   %edx
  801f8d:	50                   	push   %eax
  801f8e:	6a 18                	push   $0x18
  801f90:	e8 8b fd ff ff       	call   801d20 <syscall>
  801f95:	83 c4 18             	add    $0x18,%esp
}
  801f98:	c9                   	leave  
  801f99:	c3                   	ret    

00801f9a <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801f9a:	55                   	push   %ebp
  801f9b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa0:	6a 00                	push   $0x0
  801fa2:	ff 75 14             	pushl  0x14(%ebp)
  801fa5:	ff 75 10             	pushl  0x10(%ebp)
  801fa8:	ff 75 0c             	pushl  0xc(%ebp)
  801fab:	50                   	push   %eax
  801fac:	6a 19                	push   $0x19
  801fae:	e8 6d fd ff ff       	call   801d20 <syscall>
  801fb3:	83 c4 18             	add    $0x18,%esp
}
  801fb6:	c9                   	leave  
  801fb7:	c3                   	ret    

00801fb8 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801fb8:	55                   	push   %ebp
  801fb9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801fbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fbe:	6a 00                	push   $0x0
  801fc0:	6a 00                	push   $0x0
  801fc2:	6a 00                	push   $0x0
  801fc4:	6a 00                	push   $0x0
  801fc6:	50                   	push   %eax
  801fc7:	6a 1a                	push   $0x1a
  801fc9:	e8 52 fd ff ff       	call   801d20 <syscall>
  801fce:	83 c4 18             	add    $0x18,%esp
}
  801fd1:	90                   	nop
  801fd2:	c9                   	leave  
  801fd3:	c3                   	ret    

00801fd4 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801fd4:	55                   	push   %ebp
  801fd5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  801fda:	6a 00                	push   $0x0
  801fdc:	6a 00                	push   $0x0
  801fde:	6a 00                	push   $0x0
  801fe0:	6a 00                	push   $0x0
  801fe2:	50                   	push   %eax
  801fe3:	6a 1b                	push   $0x1b
  801fe5:	e8 36 fd ff ff       	call   801d20 <syscall>
  801fea:	83 c4 18             	add    $0x18,%esp
}
  801fed:	c9                   	leave  
  801fee:	c3                   	ret    

00801fef <sys_getenvid>:

int32 sys_getenvid(void)
{
  801fef:	55                   	push   %ebp
  801ff0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ff2:	6a 00                	push   $0x0
  801ff4:	6a 00                	push   $0x0
  801ff6:	6a 00                	push   $0x0
  801ff8:	6a 00                	push   $0x0
  801ffa:	6a 00                	push   $0x0
  801ffc:	6a 05                	push   $0x5
  801ffe:	e8 1d fd ff ff       	call   801d20 <syscall>
  802003:	83 c4 18             	add    $0x18,%esp
}
  802006:	c9                   	leave  
  802007:	c3                   	ret    

00802008 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802008:	55                   	push   %ebp
  802009:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80200b:	6a 00                	push   $0x0
  80200d:	6a 00                	push   $0x0
  80200f:	6a 00                	push   $0x0
  802011:	6a 00                	push   $0x0
  802013:	6a 00                	push   $0x0
  802015:	6a 06                	push   $0x6
  802017:	e8 04 fd ff ff       	call   801d20 <syscall>
  80201c:	83 c4 18             	add    $0x18,%esp
}
  80201f:	c9                   	leave  
  802020:	c3                   	ret    

00802021 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802021:	55                   	push   %ebp
  802022:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802024:	6a 00                	push   $0x0
  802026:	6a 00                	push   $0x0
  802028:	6a 00                	push   $0x0
  80202a:	6a 00                	push   $0x0
  80202c:	6a 00                	push   $0x0
  80202e:	6a 07                	push   $0x7
  802030:	e8 eb fc ff ff       	call   801d20 <syscall>
  802035:	83 c4 18             	add    $0x18,%esp
}
  802038:	c9                   	leave  
  802039:	c3                   	ret    

0080203a <sys_exit_env>:


void sys_exit_env(void)
{
  80203a:	55                   	push   %ebp
  80203b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80203d:	6a 00                	push   $0x0
  80203f:	6a 00                	push   $0x0
  802041:	6a 00                	push   $0x0
  802043:	6a 00                	push   $0x0
  802045:	6a 00                	push   $0x0
  802047:	6a 1c                	push   $0x1c
  802049:	e8 d2 fc ff ff       	call   801d20 <syscall>
  80204e:	83 c4 18             	add    $0x18,%esp
}
  802051:	90                   	nop
  802052:	c9                   	leave  
  802053:	c3                   	ret    

00802054 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802054:	55                   	push   %ebp
  802055:	89 e5                	mov    %esp,%ebp
  802057:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80205a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80205d:	8d 50 04             	lea    0x4(%eax),%edx
  802060:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802063:	6a 00                	push   $0x0
  802065:	6a 00                	push   $0x0
  802067:	6a 00                	push   $0x0
  802069:	52                   	push   %edx
  80206a:	50                   	push   %eax
  80206b:	6a 1d                	push   $0x1d
  80206d:	e8 ae fc ff ff       	call   801d20 <syscall>
  802072:	83 c4 18             	add    $0x18,%esp
	return result;
  802075:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802078:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80207b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80207e:	89 01                	mov    %eax,(%ecx)
  802080:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802083:	8b 45 08             	mov    0x8(%ebp),%eax
  802086:	c9                   	leave  
  802087:	c2 04 00             	ret    $0x4

0080208a <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80208a:	55                   	push   %ebp
  80208b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80208d:	6a 00                	push   $0x0
  80208f:	6a 00                	push   $0x0
  802091:	ff 75 10             	pushl  0x10(%ebp)
  802094:	ff 75 0c             	pushl  0xc(%ebp)
  802097:	ff 75 08             	pushl  0x8(%ebp)
  80209a:	6a 13                	push   $0x13
  80209c:	e8 7f fc ff ff       	call   801d20 <syscall>
  8020a1:	83 c4 18             	add    $0x18,%esp
	return ;
  8020a4:	90                   	nop
}
  8020a5:	c9                   	leave  
  8020a6:	c3                   	ret    

008020a7 <sys_rcr2>:
uint32 sys_rcr2()
{
  8020a7:	55                   	push   %ebp
  8020a8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8020aa:	6a 00                	push   $0x0
  8020ac:	6a 00                	push   $0x0
  8020ae:	6a 00                	push   $0x0
  8020b0:	6a 00                	push   $0x0
  8020b2:	6a 00                	push   $0x0
  8020b4:	6a 1e                	push   $0x1e
  8020b6:	e8 65 fc ff ff       	call   801d20 <syscall>
  8020bb:	83 c4 18             	add    $0x18,%esp
}
  8020be:	c9                   	leave  
  8020bf:	c3                   	ret    

008020c0 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8020c0:	55                   	push   %ebp
  8020c1:	89 e5                	mov    %esp,%ebp
  8020c3:	83 ec 04             	sub    $0x4,%esp
  8020c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8020cc:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8020d0:	6a 00                	push   $0x0
  8020d2:	6a 00                	push   $0x0
  8020d4:	6a 00                	push   $0x0
  8020d6:	6a 00                	push   $0x0
  8020d8:	50                   	push   %eax
  8020d9:	6a 1f                	push   $0x1f
  8020db:	e8 40 fc ff ff       	call   801d20 <syscall>
  8020e0:	83 c4 18             	add    $0x18,%esp
	return ;
  8020e3:	90                   	nop
}
  8020e4:	c9                   	leave  
  8020e5:	c3                   	ret    

008020e6 <rsttst>:
void rsttst()
{
  8020e6:	55                   	push   %ebp
  8020e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8020e9:	6a 00                	push   $0x0
  8020eb:	6a 00                	push   $0x0
  8020ed:	6a 00                	push   $0x0
  8020ef:	6a 00                	push   $0x0
  8020f1:	6a 00                	push   $0x0
  8020f3:	6a 21                	push   $0x21
  8020f5:	e8 26 fc ff ff       	call   801d20 <syscall>
  8020fa:	83 c4 18             	add    $0x18,%esp
	return ;
  8020fd:	90                   	nop
}
  8020fe:	c9                   	leave  
  8020ff:	c3                   	ret    

00802100 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802100:	55                   	push   %ebp
  802101:	89 e5                	mov    %esp,%ebp
  802103:	83 ec 04             	sub    $0x4,%esp
  802106:	8b 45 14             	mov    0x14(%ebp),%eax
  802109:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80210c:	8b 55 18             	mov    0x18(%ebp),%edx
  80210f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802113:	52                   	push   %edx
  802114:	50                   	push   %eax
  802115:	ff 75 10             	pushl  0x10(%ebp)
  802118:	ff 75 0c             	pushl  0xc(%ebp)
  80211b:	ff 75 08             	pushl  0x8(%ebp)
  80211e:	6a 20                	push   $0x20
  802120:	e8 fb fb ff ff       	call   801d20 <syscall>
  802125:	83 c4 18             	add    $0x18,%esp
	return ;
  802128:	90                   	nop
}
  802129:	c9                   	leave  
  80212a:	c3                   	ret    

0080212b <chktst>:
void chktst(uint32 n)
{
  80212b:	55                   	push   %ebp
  80212c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80212e:	6a 00                	push   $0x0
  802130:	6a 00                	push   $0x0
  802132:	6a 00                	push   $0x0
  802134:	6a 00                	push   $0x0
  802136:	ff 75 08             	pushl  0x8(%ebp)
  802139:	6a 22                	push   $0x22
  80213b:	e8 e0 fb ff ff       	call   801d20 <syscall>
  802140:	83 c4 18             	add    $0x18,%esp
	return ;
  802143:	90                   	nop
}
  802144:	c9                   	leave  
  802145:	c3                   	ret    

00802146 <inctst>:

void inctst()
{
  802146:	55                   	push   %ebp
  802147:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802149:	6a 00                	push   $0x0
  80214b:	6a 00                	push   $0x0
  80214d:	6a 00                	push   $0x0
  80214f:	6a 00                	push   $0x0
  802151:	6a 00                	push   $0x0
  802153:	6a 23                	push   $0x23
  802155:	e8 c6 fb ff ff       	call   801d20 <syscall>
  80215a:	83 c4 18             	add    $0x18,%esp
	return ;
  80215d:	90                   	nop
}
  80215e:	c9                   	leave  
  80215f:	c3                   	ret    

00802160 <gettst>:
uint32 gettst()
{
  802160:	55                   	push   %ebp
  802161:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802163:	6a 00                	push   $0x0
  802165:	6a 00                	push   $0x0
  802167:	6a 00                	push   $0x0
  802169:	6a 00                	push   $0x0
  80216b:	6a 00                	push   $0x0
  80216d:	6a 24                	push   $0x24
  80216f:	e8 ac fb ff ff       	call   801d20 <syscall>
  802174:	83 c4 18             	add    $0x18,%esp
}
  802177:	c9                   	leave  
  802178:	c3                   	ret    

00802179 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  802179:	55                   	push   %ebp
  80217a:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80217c:	6a 00                	push   $0x0
  80217e:	6a 00                	push   $0x0
  802180:	6a 00                	push   $0x0
  802182:	6a 00                	push   $0x0
  802184:	6a 00                	push   $0x0
  802186:	6a 25                	push   $0x25
  802188:	e8 93 fb ff ff       	call   801d20 <syscall>
  80218d:	83 c4 18             	add    $0x18,%esp
  802190:	a3 60 c0 81 00       	mov    %eax,0x81c060
	return uheapPlaceStrategy ;
  802195:	a1 60 c0 81 00       	mov    0x81c060,%eax
}
  80219a:	c9                   	leave  
  80219b:	c3                   	ret    

0080219c <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80219c:	55                   	push   %ebp
  80219d:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  80219f:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a2:	a3 60 c0 81 00       	mov    %eax,0x81c060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8021a7:	6a 00                	push   $0x0
  8021a9:	6a 00                	push   $0x0
  8021ab:	6a 00                	push   $0x0
  8021ad:	6a 00                	push   $0x0
  8021af:	ff 75 08             	pushl  0x8(%ebp)
  8021b2:	6a 26                	push   $0x26
  8021b4:	e8 67 fb ff ff       	call   801d20 <syscall>
  8021b9:	83 c4 18             	add    $0x18,%esp
	return ;
  8021bc:	90                   	nop
}
  8021bd:	c9                   	leave  
  8021be:	c3                   	ret    

008021bf <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8021bf:	55                   	push   %ebp
  8021c0:	89 e5                	mov    %esp,%ebp
  8021c2:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8021c3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8021c6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cf:	6a 00                	push   $0x0
  8021d1:	53                   	push   %ebx
  8021d2:	51                   	push   %ecx
  8021d3:	52                   	push   %edx
  8021d4:	50                   	push   %eax
  8021d5:	6a 27                	push   $0x27
  8021d7:	e8 44 fb ff ff       	call   801d20 <syscall>
  8021dc:	83 c4 18             	add    $0x18,%esp
}
  8021df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021e2:	c9                   	leave  
  8021e3:	c3                   	ret    

008021e4 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8021e4:	55                   	push   %ebp
  8021e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8021e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ed:	6a 00                	push   $0x0
  8021ef:	6a 00                	push   $0x0
  8021f1:	6a 00                	push   $0x0
  8021f3:	52                   	push   %edx
  8021f4:	50                   	push   %eax
  8021f5:	6a 28                	push   $0x28
  8021f7:	e8 24 fb ff ff       	call   801d20 <syscall>
  8021fc:	83 c4 18             	add    $0x18,%esp
}
  8021ff:	c9                   	leave  
  802200:	c3                   	ret    

00802201 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802201:	55                   	push   %ebp
  802202:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802204:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802207:	8b 55 0c             	mov    0xc(%ebp),%edx
  80220a:	8b 45 08             	mov    0x8(%ebp),%eax
  80220d:	6a 00                	push   $0x0
  80220f:	51                   	push   %ecx
  802210:	ff 75 10             	pushl  0x10(%ebp)
  802213:	52                   	push   %edx
  802214:	50                   	push   %eax
  802215:	6a 29                	push   $0x29
  802217:	e8 04 fb ff ff       	call   801d20 <syscall>
  80221c:	83 c4 18             	add    $0x18,%esp
}
  80221f:	c9                   	leave  
  802220:	c3                   	ret    

00802221 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802221:	55                   	push   %ebp
  802222:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802224:	6a 00                	push   $0x0
  802226:	6a 00                	push   $0x0
  802228:	ff 75 10             	pushl  0x10(%ebp)
  80222b:	ff 75 0c             	pushl  0xc(%ebp)
  80222e:	ff 75 08             	pushl  0x8(%ebp)
  802231:	6a 12                	push   $0x12
  802233:	e8 e8 fa ff ff       	call   801d20 <syscall>
  802238:	83 c4 18             	add    $0x18,%esp
	return ;
  80223b:	90                   	nop
}
  80223c:	c9                   	leave  
  80223d:	c3                   	ret    

0080223e <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80223e:	55                   	push   %ebp
  80223f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802241:	8b 55 0c             	mov    0xc(%ebp),%edx
  802244:	8b 45 08             	mov    0x8(%ebp),%eax
  802247:	6a 00                	push   $0x0
  802249:	6a 00                	push   $0x0
  80224b:	6a 00                	push   $0x0
  80224d:	52                   	push   %edx
  80224e:	50                   	push   %eax
  80224f:	6a 2a                	push   $0x2a
  802251:	e8 ca fa ff ff       	call   801d20 <syscall>
  802256:	83 c4 18             	add    $0x18,%esp
	return;
  802259:	90                   	nop
}
  80225a:	c9                   	leave  
  80225b:	c3                   	ret    

0080225c <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  80225c:	55                   	push   %ebp
  80225d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  80225f:	6a 00                	push   $0x0
  802261:	6a 00                	push   $0x0
  802263:	6a 00                	push   $0x0
  802265:	6a 00                	push   $0x0
  802267:	6a 00                	push   $0x0
  802269:	6a 2b                	push   $0x2b
  80226b:	e8 b0 fa ff ff       	call   801d20 <syscall>
  802270:	83 c4 18             	add    $0x18,%esp
}
  802273:	c9                   	leave  
  802274:	c3                   	ret    

00802275 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802275:	55                   	push   %ebp
  802276:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802278:	6a 00                	push   $0x0
  80227a:	6a 00                	push   $0x0
  80227c:	6a 00                	push   $0x0
  80227e:	ff 75 0c             	pushl  0xc(%ebp)
  802281:	ff 75 08             	pushl  0x8(%ebp)
  802284:	6a 2d                	push   $0x2d
  802286:	e8 95 fa ff ff       	call   801d20 <syscall>
  80228b:	83 c4 18             	add    $0x18,%esp
	return;
  80228e:	90                   	nop
}
  80228f:	c9                   	leave  
  802290:	c3                   	ret    

00802291 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802291:	55                   	push   %ebp
  802292:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802294:	6a 00                	push   $0x0
  802296:	6a 00                	push   $0x0
  802298:	6a 00                	push   $0x0
  80229a:	ff 75 0c             	pushl  0xc(%ebp)
  80229d:	ff 75 08             	pushl  0x8(%ebp)
  8022a0:	6a 2c                	push   $0x2c
  8022a2:	e8 79 fa ff ff       	call   801d20 <syscall>
  8022a7:	83 c4 18             	add    $0x18,%esp
	return ;
  8022aa:	90                   	nop
}
  8022ab:	c9                   	leave  
  8022ac:	c3                   	ret    

008022ad <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8022ad:	55                   	push   %ebp
  8022ae:	89 e5                	mov    %esp,%ebp
  8022b0:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  8022b3:	83 ec 04             	sub    $0x4,%esp
  8022b6:	68 28 30 80 00       	push   $0x803028
  8022bb:	68 25 01 00 00       	push   $0x125
  8022c0:	68 5b 30 80 00       	push   $0x80305b
  8022c5:	e8 e4 e4 ff ff       	call   8007ae <_panic>

008022ca <to_page_va>:
//==================================================================================//
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  8022ca:	55                   	push   %ebp
  8022cb:	89 e5                	mov    %esp,%ebp
  8022cd:	83 ec 10             	sub    $0x10,%esp
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  8022d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d3:	ba 60 40 80 00       	mov    $0x804060,%edx
  8022d8:	29 d0                	sub    %edx,%eax
  8022da:	c1 f8 02             	sar    $0x2,%eax
  8022dd:	89 c2                	mov    %eax,%edx
  8022df:	89 d0                	mov    %edx,%eax
  8022e1:	c1 e0 02             	shl    $0x2,%eax
  8022e4:	01 d0                	add    %edx,%eax
  8022e6:	c1 e0 02             	shl    $0x2,%eax
  8022e9:	01 d0                	add    %edx,%eax
  8022eb:	c1 e0 02             	shl    $0x2,%eax
  8022ee:	01 d0                	add    %edx,%eax
  8022f0:	89 c1                	mov    %eax,%ecx
  8022f2:	c1 e1 08             	shl    $0x8,%ecx
  8022f5:	01 c8                	add    %ecx,%eax
  8022f7:	89 c1                	mov    %eax,%ecx
  8022f9:	c1 e1 10             	shl    $0x10,%ecx
  8022fc:	01 c8                	add    %ecx,%eax
  8022fe:	01 c0                	add    %eax,%eax
  802300:	01 d0                	add    %edx,%eax
  802302:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  802305:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802308:	c1 e0 0c             	shl    $0xc,%eax
  80230b:	89 c2                	mov    %eax,%edx
  80230d:	a1 64 c0 81 00       	mov    0x81c064,%eax
  802312:	01 d0                	add    %edx,%eax
}
  802314:	c9                   	leave  
  802315:	c3                   	ret    

00802316 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  802316:	55                   	push   %ebp
  802317:	89 e5                	mov    %esp,%ebp
  802319:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  80231c:	8b 45 08             	mov    0x8(%ebp),%eax
  80231f:	05 00 00 00 02       	add    $0x2000000,%eax
  802324:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802327:	73 16                	jae    80233f <initialize_dynamic_allocator+0x29>
  802329:	68 6c 30 80 00       	push   $0x80306c
  80232e:	68 92 30 80 00       	push   $0x803092
  802333:	6a 26                	push   $0x26
  802335:	68 a7 30 80 00       	push   $0x8030a7
  80233a:	e8 6f e4 ff ff       	call   8007ae <_panic>
		is_initialized = 1;
  80233f:	c7 05 28 40 80 00 01 	movl   $0x1,0x804028
  802346:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	//Comment the following line
	panic("initialize_dynamic_allocator() Not implemented yet");
  802349:	83 ec 04             	sub    $0x4,%esp
  80234c:	68 c0 30 80 00       	push   $0x8030c0
  802351:	6a 2e                	push   $0x2e
  802353:	68 a7 30 80 00       	push   $0x8030a7
  802358:	e8 51 e4 ff ff       	call   8007ae <_panic>

0080235d <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  80235d:	55                   	push   %ebp
  80235e:	89 e5                	mov    %esp,%ebp
  802360:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	//Comment the following line
	panic("get_block_size() Not implemented yet");
  802363:	83 ec 04             	sub    $0x4,%esp
  802366:	68 f4 30 80 00       	push   $0x8030f4
  80236b:	6a 3a                	push   $0x3a
  80236d:	68 a7 30 80 00       	push   $0x8030a7
  802372:	e8 37 e4 ff ff       	call   8007ae <_panic>

00802377 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  802377:	55                   	push   %ebp
  802378:	89 e5                	mov    %esp,%ebp
  80237a:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  80237d:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802384:	76 16                	jbe    80239c <alloc_block+0x25>
  802386:	68 1c 31 80 00       	push   $0x80311c
  80238b:	68 92 30 80 00       	push   $0x803092
  802390:	6a 46                	push   $0x46
  802392:	68 a7 30 80 00       	push   $0x8030a7
  802397:	e8 12 e4 ff ff       	call   8007ae <_panic>
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	panic("alloc_block() Not implemented yet");
  80239c:	83 ec 04             	sub    $0x4,%esp
  80239f:	68 40 31 80 00       	push   $0x803140
  8023a4:	6a 4d                	push   $0x4d
  8023a6:	68 a7 30 80 00       	push   $0x8030a7
  8023ab:	e8 fe e3 ff ff       	call   8007ae <_panic>

008023b0 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  8023b0:	55                   	push   %ebp
  8023b1:	89 e5                	mov    %esp,%ebp
  8023b3:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  8023b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8023b9:	a1 64 c0 81 00       	mov    0x81c064,%eax
  8023be:	39 c2                	cmp    %eax,%edx
  8023c0:	72 0c                	jb     8023ce <free_block+0x1e>
  8023c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8023c5:	a1 40 40 80 00       	mov    0x804040,%eax
  8023ca:	39 c2                	cmp    %eax,%edx
  8023cc:	72 16                	jb     8023e4 <free_block+0x34>
  8023ce:	68 64 31 80 00       	push   $0x803164
  8023d3:	68 92 30 80 00       	push   $0x803092
  8023d8:	6a 5b                	push   $0x5b
  8023da:	68 a7 30 80 00       	push   $0x8030a7
  8023df:	e8 ca e3 ff ff       	call   8007ae <_panic>
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	panic("free_block() Not implemented yet");
  8023e4:	83 ec 04             	sub    $0x4,%esp
  8023e7:	68 9c 31 80 00       	push   $0x80319c
  8023ec:	6a 63                	push   $0x63
  8023ee:	68 a7 30 80 00       	push   $0x8030a7
  8023f3:	e8 b6 e3 ff ff       	call   8007ae <_panic>

008023f8 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  8023f8:	55                   	push   %ebp
  8023f9:	89 e5                	mov    %esp,%ebp
  8023fb:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  8023fe:	83 ec 04             	sub    $0x4,%esp
  802401:	68 c0 31 80 00       	push   $0x8031c0
  802406:	6a 72                	push   $0x72
  802408:	68 a7 30 80 00       	push   $0x8030a7
  80240d:	e8 9c e3 ff ff       	call   8007ae <_panic>
  802412:	66 90                	xchg   %ax,%ax

00802414 <__udivdi3>:
  802414:	55                   	push   %ebp
  802415:	57                   	push   %edi
  802416:	56                   	push   %esi
  802417:	53                   	push   %ebx
  802418:	83 ec 1c             	sub    $0x1c,%esp
  80241b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80241f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802423:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802427:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80242b:	89 ca                	mov    %ecx,%edx
  80242d:	89 f8                	mov    %edi,%eax
  80242f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802433:	85 f6                	test   %esi,%esi
  802435:	75 2d                	jne    802464 <__udivdi3+0x50>
  802437:	39 cf                	cmp    %ecx,%edi
  802439:	77 65                	ja     8024a0 <__udivdi3+0x8c>
  80243b:	89 fd                	mov    %edi,%ebp
  80243d:	85 ff                	test   %edi,%edi
  80243f:	75 0b                	jne    80244c <__udivdi3+0x38>
  802441:	b8 01 00 00 00       	mov    $0x1,%eax
  802446:	31 d2                	xor    %edx,%edx
  802448:	f7 f7                	div    %edi
  80244a:	89 c5                	mov    %eax,%ebp
  80244c:	31 d2                	xor    %edx,%edx
  80244e:	89 c8                	mov    %ecx,%eax
  802450:	f7 f5                	div    %ebp
  802452:	89 c1                	mov    %eax,%ecx
  802454:	89 d8                	mov    %ebx,%eax
  802456:	f7 f5                	div    %ebp
  802458:	89 cf                	mov    %ecx,%edi
  80245a:	89 fa                	mov    %edi,%edx
  80245c:	83 c4 1c             	add    $0x1c,%esp
  80245f:	5b                   	pop    %ebx
  802460:	5e                   	pop    %esi
  802461:	5f                   	pop    %edi
  802462:	5d                   	pop    %ebp
  802463:	c3                   	ret    
  802464:	39 ce                	cmp    %ecx,%esi
  802466:	77 28                	ja     802490 <__udivdi3+0x7c>
  802468:	0f bd fe             	bsr    %esi,%edi
  80246b:	83 f7 1f             	xor    $0x1f,%edi
  80246e:	75 40                	jne    8024b0 <__udivdi3+0x9c>
  802470:	39 ce                	cmp    %ecx,%esi
  802472:	72 0a                	jb     80247e <__udivdi3+0x6a>
  802474:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802478:	0f 87 9e 00 00 00    	ja     80251c <__udivdi3+0x108>
  80247e:	b8 01 00 00 00       	mov    $0x1,%eax
  802483:	89 fa                	mov    %edi,%edx
  802485:	83 c4 1c             	add    $0x1c,%esp
  802488:	5b                   	pop    %ebx
  802489:	5e                   	pop    %esi
  80248a:	5f                   	pop    %edi
  80248b:	5d                   	pop    %ebp
  80248c:	c3                   	ret    
  80248d:	8d 76 00             	lea    0x0(%esi),%esi
  802490:	31 ff                	xor    %edi,%edi
  802492:	31 c0                	xor    %eax,%eax
  802494:	89 fa                	mov    %edi,%edx
  802496:	83 c4 1c             	add    $0x1c,%esp
  802499:	5b                   	pop    %ebx
  80249a:	5e                   	pop    %esi
  80249b:	5f                   	pop    %edi
  80249c:	5d                   	pop    %ebp
  80249d:	c3                   	ret    
  80249e:	66 90                	xchg   %ax,%ax
  8024a0:	89 d8                	mov    %ebx,%eax
  8024a2:	f7 f7                	div    %edi
  8024a4:	31 ff                	xor    %edi,%edi
  8024a6:	89 fa                	mov    %edi,%edx
  8024a8:	83 c4 1c             	add    $0x1c,%esp
  8024ab:	5b                   	pop    %ebx
  8024ac:	5e                   	pop    %esi
  8024ad:	5f                   	pop    %edi
  8024ae:	5d                   	pop    %ebp
  8024af:	c3                   	ret    
  8024b0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8024b5:	89 eb                	mov    %ebp,%ebx
  8024b7:	29 fb                	sub    %edi,%ebx
  8024b9:	89 f9                	mov    %edi,%ecx
  8024bb:	d3 e6                	shl    %cl,%esi
  8024bd:	89 c5                	mov    %eax,%ebp
  8024bf:	88 d9                	mov    %bl,%cl
  8024c1:	d3 ed                	shr    %cl,%ebp
  8024c3:	89 e9                	mov    %ebp,%ecx
  8024c5:	09 f1                	or     %esi,%ecx
  8024c7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8024cb:	89 f9                	mov    %edi,%ecx
  8024cd:	d3 e0                	shl    %cl,%eax
  8024cf:	89 c5                	mov    %eax,%ebp
  8024d1:	89 d6                	mov    %edx,%esi
  8024d3:	88 d9                	mov    %bl,%cl
  8024d5:	d3 ee                	shr    %cl,%esi
  8024d7:	89 f9                	mov    %edi,%ecx
  8024d9:	d3 e2                	shl    %cl,%edx
  8024db:	8b 44 24 08          	mov    0x8(%esp),%eax
  8024df:	88 d9                	mov    %bl,%cl
  8024e1:	d3 e8                	shr    %cl,%eax
  8024e3:	09 c2                	or     %eax,%edx
  8024e5:	89 d0                	mov    %edx,%eax
  8024e7:	89 f2                	mov    %esi,%edx
  8024e9:	f7 74 24 0c          	divl   0xc(%esp)
  8024ed:	89 d6                	mov    %edx,%esi
  8024ef:	89 c3                	mov    %eax,%ebx
  8024f1:	f7 e5                	mul    %ebp
  8024f3:	39 d6                	cmp    %edx,%esi
  8024f5:	72 19                	jb     802510 <__udivdi3+0xfc>
  8024f7:	74 0b                	je     802504 <__udivdi3+0xf0>
  8024f9:	89 d8                	mov    %ebx,%eax
  8024fb:	31 ff                	xor    %edi,%edi
  8024fd:	e9 58 ff ff ff       	jmp    80245a <__udivdi3+0x46>
  802502:	66 90                	xchg   %ax,%ax
  802504:	8b 54 24 08          	mov    0x8(%esp),%edx
  802508:	89 f9                	mov    %edi,%ecx
  80250a:	d3 e2                	shl    %cl,%edx
  80250c:	39 c2                	cmp    %eax,%edx
  80250e:	73 e9                	jae    8024f9 <__udivdi3+0xe5>
  802510:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802513:	31 ff                	xor    %edi,%edi
  802515:	e9 40 ff ff ff       	jmp    80245a <__udivdi3+0x46>
  80251a:	66 90                	xchg   %ax,%ax
  80251c:	31 c0                	xor    %eax,%eax
  80251e:	e9 37 ff ff ff       	jmp    80245a <__udivdi3+0x46>
  802523:	90                   	nop

00802524 <__umoddi3>:
  802524:	55                   	push   %ebp
  802525:	57                   	push   %edi
  802526:	56                   	push   %esi
  802527:	53                   	push   %ebx
  802528:	83 ec 1c             	sub    $0x1c,%esp
  80252b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80252f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802533:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802537:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80253b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80253f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802543:	89 f3                	mov    %esi,%ebx
  802545:	89 fa                	mov    %edi,%edx
  802547:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80254b:	89 34 24             	mov    %esi,(%esp)
  80254e:	85 c0                	test   %eax,%eax
  802550:	75 1a                	jne    80256c <__umoddi3+0x48>
  802552:	39 f7                	cmp    %esi,%edi
  802554:	0f 86 a2 00 00 00    	jbe    8025fc <__umoddi3+0xd8>
  80255a:	89 c8                	mov    %ecx,%eax
  80255c:	89 f2                	mov    %esi,%edx
  80255e:	f7 f7                	div    %edi
  802560:	89 d0                	mov    %edx,%eax
  802562:	31 d2                	xor    %edx,%edx
  802564:	83 c4 1c             	add    $0x1c,%esp
  802567:	5b                   	pop    %ebx
  802568:	5e                   	pop    %esi
  802569:	5f                   	pop    %edi
  80256a:	5d                   	pop    %ebp
  80256b:	c3                   	ret    
  80256c:	39 f0                	cmp    %esi,%eax
  80256e:	0f 87 ac 00 00 00    	ja     802620 <__umoddi3+0xfc>
  802574:	0f bd e8             	bsr    %eax,%ebp
  802577:	83 f5 1f             	xor    $0x1f,%ebp
  80257a:	0f 84 ac 00 00 00    	je     80262c <__umoddi3+0x108>
  802580:	bf 20 00 00 00       	mov    $0x20,%edi
  802585:	29 ef                	sub    %ebp,%edi
  802587:	89 fe                	mov    %edi,%esi
  802589:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80258d:	89 e9                	mov    %ebp,%ecx
  80258f:	d3 e0                	shl    %cl,%eax
  802591:	89 d7                	mov    %edx,%edi
  802593:	89 f1                	mov    %esi,%ecx
  802595:	d3 ef                	shr    %cl,%edi
  802597:	09 c7                	or     %eax,%edi
  802599:	89 e9                	mov    %ebp,%ecx
  80259b:	d3 e2                	shl    %cl,%edx
  80259d:	89 14 24             	mov    %edx,(%esp)
  8025a0:	89 d8                	mov    %ebx,%eax
  8025a2:	d3 e0                	shl    %cl,%eax
  8025a4:	89 c2                	mov    %eax,%edx
  8025a6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8025aa:	d3 e0                	shl    %cl,%eax
  8025ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025b0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8025b4:	89 f1                	mov    %esi,%ecx
  8025b6:	d3 e8                	shr    %cl,%eax
  8025b8:	09 d0                	or     %edx,%eax
  8025ba:	d3 eb                	shr    %cl,%ebx
  8025bc:	89 da                	mov    %ebx,%edx
  8025be:	f7 f7                	div    %edi
  8025c0:	89 d3                	mov    %edx,%ebx
  8025c2:	f7 24 24             	mull   (%esp)
  8025c5:	89 c6                	mov    %eax,%esi
  8025c7:	89 d1                	mov    %edx,%ecx
  8025c9:	39 d3                	cmp    %edx,%ebx
  8025cb:	0f 82 87 00 00 00    	jb     802658 <__umoddi3+0x134>
  8025d1:	0f 84 91 00 00 00    	je     802668 <__umoddi3+0x144>
  8025d7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8025db:	29 f2                	sub    %esi,%edx
  8025dd:	19 cb                	sbb    %ecx,%ebx
  8025df:	89 d8                	mov    %ebx,%eax
  8025e1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8025e5:	d3 e0                	shl    %cl,%eax
  8025e7:	89 e9                	mov    %ebp,%ecx
  8025e9:	d3 ea                	shr    %cl,%edx
  8025eb:	09 d0                	or     %edx,%eax
  8025ed:	89 e9                	mov    %ebp,%ecx
  8025ef:	d3 eb                	shr    %cl,%ebx
  8025f1:	89 da                	mov    %ebx,%edx
  8025f3:	83 c4 1c             	add    $0x1c,%esp
  8025f6:	5b                   	pop    %ebx
  8025f7:	5e                   	pop    %esi
  8025f8:	5f                   	pop    %edi
  8025f9:	5d                   	pop    %ebp
  8025fa:	c3                   	ret    
  8025fb:	90                   	nop
  8025fc:	89 fd                	mov    %edi,%ebp
  8025fe:	85 ff                	test   %edi,%edi
  802600:	75 0b                	jne    80260d <__umoddi3+0xe9>
  802602:	b8 01 00 00 00       	mov    $0x1,%eax
  802607:	31 d2                	xor    %edx,%edx
  802609:	f7 f7                	div    %edi
  80260b:	89 c5                	mov    %eax,%ebp
  80260d:	89 f0                	mov    %esi,%eax
  80260f:	31 d2                	xor    %edx,%edx
  802611:	f7 f5                	div    %ebp
  802613:	89 c8                	mov    %ecx,%eax
  802615:	f7 f5                	div    %ebp
  802617:	89 d0                	mov    %edx,%eax
  802619:	e9 44 ff ff ff       	jmp    802562 <__umoddi3+0x3e>
  80261e:	66 90                	xchg   %ax,%ax
  802620:	89 c8                	mov    %ecx,%eax
  802622:	89 f2                	mov    %esi,%edx
  802624:	83 c4 1c             	add    $0x1c,%esp
  802627:	5b                   	pop    %ebx
  802628:	5e                   	pop    %esi
  802629:	5f                   	pop    %edi
  80262a:	5d                   	pop    %ebp
  80262b:	c3                   	ret    
  80262c:	3b 04 24             	cmp    (%esp),%eax
  80262f:	72 06                	jb     802637 <__umoddi3+0x113>
  802631:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802635:	77 0f                	ja     802646 <__umoddi3+0x122>
  802637:	89 f2                	mov    %esi,%edx
  802639:	29 f9                	sub    %edi,%ecx
  80263b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80263f:	89 14 24             	mov    %edx,(%esp)
  802642:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802646:	8b 44 24 04          	mov    0x4(%esp),%eax
  80264a:	8b 14 24             	mov    (%esp),%edx
  80264d:	83 c4 1c             	add    $0x1c,%esp
  802650:	5b                   	pop    %ebx
  802651:	5e                   	pop    %esi
  802652:	5f                   	pop    %edi
  802653:	5d                   	pop    %ebp
  802654:	c3                   	ret    
  802655:	8d 76 00             	lea    0x0(%esi),%esi
  802658:	2b 04 24             	sub    (%esp),%eax
  80265b:	19 fa                	sbb    %edi,%edx
  80265d:	89 d1                	mov    %edx,%ecx
  80265f:	89 c6                	mov    %eax,%esi
  802661:	e9 71 ff ff ff       	jmp    8025d7 <__umoddi3+0xb3>
  802666:	66 90                	xchg   %ax,%ax
  802668:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80266c:	72 ea                	jb     802658 <__umoddi3+0x134>
  80266e:	89 d9                	mov    %ebx,%ecx
  802670:	e9 62 ff ff ff       	jmp    8025d7 <__umoddi3+0xb3>

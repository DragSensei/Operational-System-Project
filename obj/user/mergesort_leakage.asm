
obj/user/mergesort_leakage:     file format elf32-i386


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
  800031:	e8 01 07 00 00       	call   800737 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
void Merge(int* A, int p, int q, int r);

uint32 CheckSorted(int *Elements, int NumOfElements);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	{
		//2012: lock the interrupt
//		sys_lock_cons();
		int NumOfElements;
		int *Elements;
		sys_lock_cons();
  800041:	e8 82 1e 00 00       	call   801ec8 <sys_lock_cons>
		{
			cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 c0 27 80 00       	push   $0x8027c0
  80004e:	e8 62 0b 00 00       	call   800bb5 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 c2 27 80 00       	push   $0x8027c2
  80005e:	e8 52 0b 00 00       	call   800bb5 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!! MERGE SORT !!!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 d8 27 80 00       	push   $0x8027d8
  80006e:	e8 42 0b 00 00       	call   800bb5 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 c2 27 80 00       	push   $0x8027c2
  80007e:	e8 32 0b 00 00       	call   800bb5 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
			cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 c0 27 80 00       	push   $0x8027c0
  80008e:	e8 22 0b 00 00       	call   800bb5 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp
			readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 f0 27 80 00       	push   $0x8027f0
  8000a5:	e8 e4 11 00 00       	call   80128e <readline>
  8000aa:	83 c4 10             	add    $0x10,%esp
			NumOfElements = strtol(Line, NULL, 10) ;
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 0a                	push   $0xa
  8000b2:	6a 00                	push   $0x0
  8000b4:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8000ba:	50                   	push   %eax
  8000bb:	e8 e5 17 00 00       	call   8018a5 <strtol>
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
			Elements = malloc(sizeof(int) * NumOfElements) ;
  8000c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c9:	c1 e0 02             	shl    $0x2,%eax
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	50                   	push   %eax
  8000d0:	e8 aa 1c 00 00       	call   801d7f <malloc>
  8000d5:	83 c4 10             	add    $0x10,%esp
  8000d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
			cprintf("Chose the initialization method:\n") ;
  8000db:	83 ec 0c             	sub    $0xc,%esp
  8000de:	68 10 28 80 00       	push   $0x802810
  8000e3:	e8 cd 0a 00 00       	call   800bb5 <cprintf>
  8000e8:	83 c4 10             	add    $0x10,%esp
			cprintf("a) Ascending\n") ;
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	68 32 28 80 00       	push   $0x802832
  8000f3:	e8 bd 0a 00 00       	call   800bb5 <cprintf>
  8000f8:	83 c4 10             	add    $0x10,%esp
			cprintf("b) Descending\n") ;
  8000fb:	83 ec 0c             	sub    $0xc,%esp
  8000fe:	68 40 28 80 00       	push   $0x802840
  800103:	e8 ad 0a 00 00       	call   800bb5 <cprintf>
  800108:	83 c4 10             	add    $0x10,%esp
			cprintf("c) Semi random\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 4f 28 80 00       	push   $0x80284f
  800113:	e8 9d 0a 00 00       	call   800bb5 <cprintf>
  800118:	83 c4 10             	add    $0x10,%esp
			do
			{
				cprintf("Select: ") ;
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	68 5f 28 80 00       	push   $0x80285f
  800123:	e8 8d 0a 00 00       	call   800bb5 <cprintf>
  800128:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  80012b:	e8 ea 05 00 00       	call   80071a <getchar>
  800130:	88 45 f7             	mov    %al,-0x9(%ebp)
				cputchar(Chose);
  800133:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800137:	83 ec 0c             	sub    $0xc,%esp
  80013a:	50                   	push   %eax
  80013b:	e8 bb 05 00 00       	call   8006fb <cputchar>
  800140:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  800143:	83 ec 0c             	sub    $0xc,%esp
  800146:	6a 0a                	push   $0xa
  800148:	e8 ae 05 00 00       	call   8006fb <cputchar>
  80014d:	83 c4 10             	add    $0x10,%esp
			} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800150:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  800154:	74 0c                	je     800162 <_main+0x12a>
  800156:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  80015a:	74 06                	je     800162 <_main+0x12a>
  80015c:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  800160:	75 b9                	jne    80011b <_main+0xe3>
		}
		sys_unlock_cons();
  800162:	e8 7b 1d 00 00       	call   801ee2 <sys_unlock_cons>
//		sys_unlock_cons();

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
  800183:	e8 e6 01 00 00       	call   80036e <InitializeAscending>
  800188:	83 c4 10             	add    $0x10,%esp
			break ;
  80018b:	eb 37                	jmp    8001c4 <_main+0x18c>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80018d:	83 ec 08             	sub    $0x8,%esp
  800190:	ff 75 f0             	pushl  -0x10(%ebp)
  800193:	ff 75 ec             	pushl  -0x14(%ebp)
  800196:	e8 04 02 00 00       	call   80039f <InitializeDescending>
  80019b:	83 c4 10             	add    $0x10,%esp
			break ;
  80019e:	eb 24                	jmp    8001c4 <_main+0x18c>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001a0:	83 ec 08             	sub    $0x8,%esp
  8001a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a6:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a9:	e8 26 02 00 00       	call   8003d4 <InitializeSemiRandom>
  8001ae:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b1:	eb 11                	jmp    8001c4 <_main+0x18c>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001b9:	ff 75 ec             	pushl  -0x14(%ebp)
  8001bc:	e8 13 02 00 00       	call   8003d4 <InitializeSemiRandom>
  8001c1:	83 c4 10             	add    $0x10,%esp
		}

		MSort(Elements, 1, NumOfElements);
  8001c4:	83 ec 04             	sub    $0x4,%esp
  8001c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ca:	6a 01                	push   $0x1
  8001cc:	ff 75 ec             	pushl  -0x14(%ebp)
  8001cf:	e8 d2 02 00 00       	call   8004a6 <MSort>
  8001d4:	83 c4 10             	add    $0x10,%esp

//		sys_lock_cons();
		sys_lock_cons();
  8001d7:	e8 ec 1c 00 00       	call   801ec8 <sys_lock_cons>
		{
			cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001dc:	83 ec 0c             	sub    $0xc,%esp
  8001df:	68 68 28 80 00       	push   $0x802868
  8001e4:	e8 cc 09 00 00       	call   800bb5 <cprintf>
  8001e9:	83 c4 10             	add    $0x10,%esp
			//PrintElements(Elements, NumOfElements);
		}
		sys_unlock_cons();
  8001ec:	e8 f1 1c 00 00       	call   801ee2 <sys_unlock_cons>
//		sys_unlock_cons();

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001f1:	83 ec 08             	sub    $0x8,%esp
  8001f4:	ff 75 f0             	pushl  -0x10(%ebp)
  8001f7:	ff 75 ec             	pushl  -0x14(%ebp)
  8001fa:	e8 c5 00 00 00       	call   8002c4 <CheckSorted>
  8001ff:	83 c4 10             	add    $0x10,%esp
  800202:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  800205:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800209:	75 14                	jne    80021f <_main+0x1e7>
  80020b:	83 ec 04             	sub    $0x4,%esp
  80020e:	68 9c 28 80 00       	push   $0x80289c
  800213:	6a 51                	push   $0x51
  800215:	68 be 28 80 00       	push   $0x8028be
  80021a:	e8 c8 06 00 00       	call   8008e7 <_panic>
		else
		{
//			sys_lock_cons();
			sys_lock_cons();
  80021f:	e8 a4 1c 00 00       	call   801ec8 <sys_lock_cons>
			{
				cprintf("===============================================\n") ;
  800224:	83 ec 0c             	sub    $0xc,%esp
  800227:	68 d8 28 80 00       	push   $0x8028d8
  80022c:	e8 84 09 00 00       	call   800bb5 <cprintf>
  800231:	83 c4 10             	add    $0x10,%esp
				cprintf("Congratulations!! The array is sorted correctly\n") ;
  800234:	83 ec 0c             	sub    $0xc,%esp
  800237:	68 0c 29 80 00       	push   $0x80290c
  80023c:	e8 74 09 00 00       	call   800bb5 <cprintf>
  800241:	83 c4 10             	add    $0x10,%esp
				cprintf("===============================================\n\n") ;
  800244:	83 ec 0c             	sub    $0xc,%esp
  800247:	68 40 29 80 00       	push   $0x802940
  80024c:	e8 64 09 00 00       	call   800bb5 <cprintf>
  800251:	83 c4 10             	add    $0x10,%esp
			}
			sys_unlock_cons();
  800254:	e8 89 1c 00 00       	call   801ee2 <sys_unlock_cons>
		}

		//free(Elements) ;

//		sys_lock_cons();
		sys_lock_cons();
  800259:	e8 6a 1c 00 00       	call   801ec8 <sys_lock_cons>
		{
			Chose = 0 ;
  80025e:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800262:	eb 42                	jmp    8002a6 <_main+0x26e>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800264:	83 ec 0c             	sub    $0xc,%esp
  800267:	68 72 29 80 00       	push   $0x802972
  80026c:	e8 44 09 00 00       	call   800bb5 <cprintf>
  800271:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  800274:	e8 a1 04 00 00       	call   80071a <getchar>
  800279:	88 45 f7             	mov    %al,-0x9(%ebp)
				cputchar(Chose);
  80027c:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800280:	83 ec 0c             	sub    $0xc,%esp
  800283:	50                   	push   %eax
  800284:	e8 72 04 00 00       	call   8006fb <cputchar>
  800289:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	6a 0a                	push   $0xa
  800291:	e8 65 04 00 00       	call   8006fb <cputchar>
  800296:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  800299:	83 ec 0c             	sub    $0xc,%esp
  80029c:	6a 0a                	push   $0xa
  80029e:	e8 58 04 00 00       	call   8006fb <cputchar>
  8002a3:	83 c4 10             	add    $0x10,%esp

//		sys_lock_cons();
		sys_lock_cons();
		{
			Chose = 0 ;
			while (Chose != 'y' && Chose != 'n')
  8002a6:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002aa:	74 06                	je     8002b2 <_main+0x27a>
  8002ac:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  8002b0:	75 b2                	jne    800264 <_main+0x22c>
				cputchar(Chose);
				cputchar('\n');
				cputchar('\n');
			}
		}
		sys_unlock_cons();
  8002b2:	e8 2b 1c 00 00       	call   801ee2 <sys_unlock_cons>
//		sys_unlock_cons();

	} while (Chose == 'y');
  8002b7:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002bb:	0f 84 80 fd ff ff    	je     800041 <_main+0x9>

}
  8002c1:	90                   	nop
  8002c2:	c9                   	leave  
  8002c3:	c3                   	ret    

008002c4 <CheckSorted>:


uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8002c4:	55                   	push   %ebp
  8002c5:	89 e5                	mov    %esp,%ebp
  8002c7:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8002ca:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8002d1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8002d8:	eb 33                	jmp    80030d <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8002da:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002dd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e7:	01 d0                	add    %edx,%eax
  8002e9:	8b 10                	mov    (%eax),%edx
  8002eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002ee:	40                   	inc    %eax
  8002ef:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f9:	01 c8                	add    %ecx,%eax
  8002fb:	8b 00                	mov    (%eax),%eax
  8002fd:	39 c2                	cmp    %eax,%edx
  8002ff:	7e 09                	jle    80030a <CheckSorted+0x46>
		{
			Sorted = 0 ;
  800301:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800308:	eb 0c                	jmp    800316 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  80030a:	ff 45 f8             	incl   -0x8(%ebp)
  80030d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800310:	48                   	dec    %eax
  800311:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800314:	7f c4                	jg     8002da <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800316:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800319:	c9                   	leave  
  80031a:	c3                   	ret    

0080031b <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  80031b:	55                   	push   %ebp
  80031c:	89 e5                	mov    %esp,%ebp
  80031e:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800321:	8b 45 0c             	mov    0xc(%ebp),%eax
  800324:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80032b:	8b 45 08             	mov    0x8(%ebp),%eax
  80032e:	01 d0                	add    %edx,%eax
  800330:	8b 00                	mov    (%eax),%eax
  800332:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800335:	8b 45 0c             	mov    0xc(%ebp),%eax
  800338:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80033f:	8b 45 08             	mov    0x8(%ebp),%eax
  800342:	01 c2                	add    %eax,%edx
  800344:	8b 45 10             	mov    0x10(%ebp),%eax
  800347:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80034e:	8b 45 08             	mov    0x8(%ebp),%eax
  800351:	01 c8                	add    %ecx,%eax
  800353:	8b 00                	mov    (%eax),%eax
  800355:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800357:	8b 45 10             	mov    0x10(%ebp),%eax
  80035a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800361:	8b 45 08             	mov    0x8(%ebp),%eax
  800364:	01 c2                	add    %eax,%edx
  800366:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800369:	89 02                	mov    %eax,(%edx)
}
  80036b:	90                   	nop
  80036c:	c9                   	leave  
  80036d:	c3                   	ret    

0080036e <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  80036e:	55                   	push   %ebp
  80036f:	89 e5                	mov    %esp,%ebp
  800371:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800374:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80037b:	eb 17                	jmp    800394 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  80037d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800380:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800387:	8b 45 08             	mov    0x8(%ebp),%eax
  80038a:	01 c2                	add    %eax,%edx
  80038c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80038f:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800391:	ff 45 fc             	incl   -0x4(%ebp)
  800394:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800397:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80039a:	7c e1                	jl     80037d <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  80039c:	90                   	nop
  80039d:	c9                   	leave  
  80039e:	c3                   	ret    

0080039f <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  80039f:	55                   	push   %ebp
  8003a0:	89 e5                	mov    %esp,%ebp
  8003a2:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003ac:	eb 1b                	jmp    8003c9 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8003ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003b1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bb:	01 c2                	add    %eax,%edx
  8003bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003c0:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8003c3:	48                   	dec    %eax
  8003c4:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003c6:	ff 45 fc             	incl   -0x4(%ebp)
  8003c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003cc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003cf:	7c dd                	jl     8003ae <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8003d1:	90                   	nop
  8003d2:	c9                   	leave  
  8003d3:	c3                   	ret    

008003d4 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8003d4:	55                   	push   %ebp
  8003d5:	89 e5                	mov    %esp,%ebp
  8003d7:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8003da:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003dd:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8003e2:	f7 e9                	imul   %ecx
  8003e4:	c1 f9 1f             	sar    $0x1f,%ecx
  8003e7:	89 d0                	mov    %edx,%eax
  8003e9:	29 c8                	sub    %ecx,%eax
  8003eb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8003ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003f5:	eb 1e                	jmp    800415 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  8003f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003fa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800401:	8b 45 08             	mov    0x8(%ebp),%eax
  800404:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800407:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80040a:	99                   	cltd   
  80040b:	f7 7d f8             	idivl  -0x8(%ebp)
  80040e:	89 d0                	mov    %edx,%eax
  800410:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800412:	ff 45 fc             	incl   -0x4(%ebp)
  800415:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800418:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80041b:	7c da                	jl     8003f7 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
		//	cprintf("i=%d\n",i);
	}

}
  80041d:	90                   	nop
  80041e:	c9                   	leave  
  80041f:	c3                   	ret    

00800420 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  800420:	55                   	push   %ebp
  800421:	89 e5                	mov    %esp,%ebp
  800423:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800426:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80042d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800434:	eb 42                	jmp    800478 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800436:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800439:	99                   	cltd   
  80043a:	f7 7d f0             	idivl  -0x10(%ebp)
  80043d:	89 d0                	mov    %edx,%eax
  80043f:	85 c0                	test   %eax,%eax
  800441:	75 10                	jne    800453 <PrintElements+0x33>
			cprintf("\n");
  800443:	83 ec 0c             	sub    $0xc,%esp
  800446:	68 c0 27 80 00       	push   $0x8027c0
  80044b:	e8 65 07 00 00       	call   800bb5 <cprintf>
  800450:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800453:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800456:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80045d:	8b 45 08             	mov    0x8(%ebp),%eax
  800460:	01 d0                	add    %edx,%eax
  800462:	8b 00                	mov    (%eax),%eax
  800464:	83 ec 08             	sub    $0x8,%esp
  800467:	50                   	push   %eax
  800468:	68 90 29 80 00       	push   $0x802990
  80046d:	e8 43 07 00 00       	call   800bb5 <cprintf>
  800472:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800475:	ff 45 f4             	incl   -0xc(%ebp)
  800478:	8b 45 0c             	mov    0xc(%ebp),%eax
  80047b:	48                   	dec    %eax
  80047c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80047f:	7f b5                	jg     800436 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  800481:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800484:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80048b:	8b 45 08             	mov    0x8(%ebp),%eax
  80048e:	01 d0                	add    %edx,%eax
  800490:	8b 00                	mov    (%eax),%eax
  800492:	83 ec 08             	sub    $0x8,%esp
  800495:	50                   	push   %eax
  800496:	68 95 29 80 00       	push   $0x802995
  80049b:	e8 15 07 00 00       	call   800bb5 <cprintf>
  8004a0:	83 c4 10             	add    $0x10,%esp

}
  8004a3:	90                   	nop
  8004a4:	c9                   	leave  
  8004a5:	c3                   	ret    

008004a6 <MSort>:


void MSort(int* A, int p, int r)
{
  8004a6:	55                   	push   %ebp
  8004a7:	89 e5                	mov    %esp,%ebp
  8004a9:	83 ec 18             	sub    $0x18,%esp
	if (p >= r)
  8004ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004af:	3b 45 10             	cmp    0x10(%ebp),%eax
  8004b2:	7d 54                	jge    800508 <MSort+0x62>
	{
		return;
	}

	int q = (p + r) / 2;
  8004b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8004ba:	01 d0                	add    %edx,%eax
  8004bc:	89 c2                	mov    %eax,%edx
  8004be:	c1 ea 1f             	shr    $0x1f,%edx
  8004c1:	01 d0                	add    %edx,%eax
  8004c3:	d1 f8                	sar    %eax
  8004c5:	89 45 f4             	mov    %eax,-0xc(%ebp)

	MSort(A, p, q);
  8004c8:	83 ec 04             	sub    $0x4,%esp
  8004cb:	ff 75 f4             	pushl  -0xc(%ebp)
  8004ce:	ff 75 0c             	pushl  0xc(%ebp)
  8004d1:	ff 75 08             	pushl  0x8(%ebp)
  8004d4:	e8 cd ff ff ff       	call   8004a6 <MSort>
  8004d9:	83 c4 10             	add    $0x10,%esp

	MSort(A, q + 1, r);
  8004dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004df:	40                   	inc    %eax
  8004e0:	83 ec 04             	sub    $0x4,%esp
  8004e3:	ff 75 10             	pushl  0x10(%ebp)
  8004e6:	50                   	push   %eax
  8004e7:	ff 75 08             	pushl  0x8(%ebp)
  8004ea:	e8 b7 ff ff ff       	call   8004a6 <MSort>
  8004ef:	83 c4 10             	add    $0x10,%esp

	Merge(A, p, q, r);
  8004f2:	ff 75 10             	pushl  0x10(%ebp)
  8004f5:	ff 75 f4             	pushl  -0xc(%ebp)
  8004f8:	ff 75 0c             	pushl  0xc(%ebp)
  8004fb:	ff 75 08             	pushl  0x8(%ebp)
  8004fe:	e8 08 00 00 00       	call   80050b <Merge>
  800503:	83 c4 10             	add    $0x10,%esp
  800506:	eb 01                	jmp    800509 <MSort+0x63>

void MSort(int* A, int p, int r)
{
	if (p >= r)
	{
		return;
  800508:	90                   	nop

	MSort(A, q + 1, r);

	Merge(A, p, q, r);

}
  800509:	c9                   	leave  
  80050a:	c3                   	ret    

0080050b <Merge>:

void Merge(int* A, int p, int q, int r)
{
  80050b:	55                   	push   %ebp
  80050c:	89 e5                	mov    %esp,%ebp
  80050e:	83 ec 38             	sub    $0x38,%esp
	int leftCapacity = q - p + 1;
  800511:	8b 45 10             	mov    0x10(%ebp),%eax
  800514:	2b 45 0c             	sub    0xc(%ebp),%eax
  800517:	40                   	inc    %eax
  800518:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int rightCapacity = r - q;
  80051b:	8b 45 14             	mov    0x14(%ebp),%eax
  80051e:	2b 45 10             	sub    0x10(%ebp),%eax
  800521:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int leftIndex = 0;
  800524:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int rightIndex = 0;
  80052b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int* Left = malloc(sizeof(int) * leftCapacity);
  800532:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800535:	c1 e0 02             	shl    $0x2,%eax
  800538:	83 ec 0c             	sub    $0xc,%esp
  80053b:	50                   	push   %eax
  80053c:	e8 3e 18 00 00       	call   801d7f <malloc>
  800541:	83 c4 10             	add    $0x10,%esp
  800544:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* Right = malloc(sizeof(int) * rightCapacity);
  800547:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80054a:	c1 e0 02             	shl    $0x2,%eax
  80054d:	83 ec 0c             	sub    $0xc,%esp
  800550:	50                   	push   %eax
  800551:	e8 29 18 00 00       	call   801d7f <malloc>
  800556:	83 c4 10             	add    $0x10,%esp
  800559:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	//	int Left[5000] ;
	//	int Right[5000] ;

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  80055c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800563:	eb 2f                	jmp    800594 <Merge+0x89>
	{
		Left[i] = A[p + i - 1];
  800565:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800568:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80056f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800572:	01 c2                	add    %eax,%edx
  800574:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800577:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80057a:	01 c8                	add    %ecx,%eax
  80057c:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800581:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800588:	8b 45 08             	mov    0x8(%ebp),%eax
  80058b:	01 c8                	add    %ecx,%eax
  80058d:	8b 00                	mov    (%eax),%eax
  80058f:	89 02                	mov    %eax,(%edx)

	//	int Left[5000] ;
	//	int Right[5000] ;

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  800591:	ff 45 ec             	incl   -0x14(%ebp)
  800594:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800597:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80059a:	7c c9                	jl     800565 <Merge+0x5a>
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  80059c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005a3:	eb 2a                	jmp    8005cf <Merge+0xc4>
	{
		Right[j] = A[q + j];
  8005a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005a8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005af:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005b2:	01 c2                	add    %eax,%edx
  8005b4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8005b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005ba:	01 c8                	add    %ecx,%eax
  8005bc:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c6:	01 c8                	add    %ecx,%eax
  8005c8:	8b 00                	mov    (%eax),%eax
  8005ca:	89 02                	mov    %eax,(%edx)
	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8005cc:	ff 45 e8             	incl   -0x18(%ebp)
  8005cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005d2:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8005d5:	7c ce                	jl     8005a5 <Merge+0x9a>
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8005d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005dd:	e9 0a 01 00 00       	jmp    8006ec <Merge+0x1e1>
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
  8005e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005e5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005e8:	0f 8d 95 00 00 00    	jge    800683 <Merge+0x178>
  8005ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005f1:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8005f4:	0f 8d 89 00 00 00    	jge    800683 <Merge+0x178>
		{
			if (Left[leftIndex] < Right[rightIndex] )
  8005fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005fd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800604:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800607:	01 d0                	add    %edx,%eax
  800609:	8b 10                	mov    (%eax),%edx
  80060b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80060e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800615:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800618:	01 c8                	add    %ecx,%eax
  80061a:	8b 00                	mov    (%eax),%eax
  80061c:	39 c2                	cmp    %eax,%edx
  80061e:	7d 33                	jge    800653 <Merge+0x148>
			{
				A[k - 1] = Left[leftIndex++];
  800620:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800623:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800628:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80062f:	8b 45 08             	mov    0x8(%ebp),%eax
  800632:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800635:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800638:	8d 50 01             	lea    0x1(%eax),%edx
  80063b:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80063e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800645:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800648:	01 d0                	add    %edx,%eax
  80064a:	8b 00                	mov    (%eax),%eax
  80064c:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  80064e:	e9 96 00 00 00       	jmp    8006e9 <Merge+0x1de>
			{
				A[k - 1] = Left[leftIndex++];
			}
			else
			{
				A[k - 1] = Right[rightIndex++];
  800653:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800656:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80065b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800662:	8b 45 08             	mov    0x8(%ebp),%eax
  800665:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800668:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80066b:	8d 50 01             	lea    0x1(%eax),%edx
  80066e:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800671:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800678:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80067b:	01 d0                	add    %edx,%eax
  80067d:	8b 00                	mov    (%eax),%eax
  80067f:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800681:	eb 66                	jmp    8006e9 <Merge+0x1de>
			else
			{
				A[k - 1] = Right[rightIndex++];
			}
		}
		else if (leftIndex < leftCapacity)
  800683:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800686:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800689:	7d 30                	jge    8006bb <Merge+0x1b0>
		{
			A[k - 1] = Left[leftIndex++];
  80068b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80068e:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800693:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80069a:	8b 45 08             	mov    0x8(%ebp),%eax
  80069d:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006a3:	8d 50 01             	lea    0x1(%eax),%edx
  8006a6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8006a9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006b0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006b3:	01 d0                	add    %edx,%eax
  8006b5:	8b 00                	mov    (%eax),%eax
  8006b7:	89 01                	mov    %eax,(%ecx)
  8006b9:	eb 2e                	jmp    8006e9 <Merge+0x1de>
		}
		else
		{
			A[k - 1] = Right[rightIndex++];
  8006bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006be:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8006c3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cd:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006d3:	8d 50 01             	lea    0x1(%eax),%edx
  8006d6:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8006d9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006e0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006e3:	01 d0                	add    %edx,%eax
  8006e5:	8b 00                	mov    (%eax),%eax
  8006e7:	89 01                	mov    %eax,(%ecx)
	for (j = 0; j < rightCapacity; j++)
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8006e9:	ff 45 e4             	incl   -0x1c(%ebp)
  8006ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006ef:	3b 45 14             	cmp    0x14(%ebp),%eax
  8006f2:	0f 8e ea fe ff ff    	jle    8005e2 <Merge+0xd7>
		{
			A[k - 1] = Right[rightIndex++];
		}
	}

}
  8006f8:	90                   	nop
  8006f9:	c9                   	leave  
  8006fa:	c3                   	ret    

008006fb <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8006fb:	55                   	push   %ebp
  8006fc:	89 e5                	mov    %esp,%ebp
  8006fe:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  800701:	8b 45 08             	mov    0x8(%ebp),%eax
  800704:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800707:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80070b:	83 ec 0c             	sub    $0xc,%esp
  80070e:	50                   	push   %eax
  80070f:	e8 fc 18 00 00       	call   802010 <sys_cputc>
  800714:	83 c4 10             	add    $0x10,%esp
}
  800717:	90                   	nop
  800718:	c9                   	leave  
  800719:	c3                   	ret    

0080071a <getchar>:


int
getchar(void)
{
  80071a:	55                   	push   %ebp
  80071b:	89 e5                	mov    %esp,%ebp
  80071d:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  800720:	e8 8a 17 00 00       	call   801eaf <sys_cgetc>
  800725:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  800728:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80072b:	c9                   	leave  
  80072c:	c3                   	ret    

0080072d <iscons>:

int iscons(int fdnum)
{
  80072d:	55                   	push   %ebp
  80072e:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  800730:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800735:	5d                   	pop    %ebp
  800736:	c3                   	ret    

00800737 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800737:	55                   	push   %ebp
  800738:	89 e5                	mov    %esp,%ebp
  80073a:	57                   	push   %edi
  80073b:	56                   	push   %esi
  80073c:	53                   	push   %ebx
  80073d:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800740:	e8 fc 19 00 00       	call   802141 <sys_getenvindex>
  800745:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800748:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80074b:	89 d0                	mov    %edx,%eax
  80074d:	c1 e0 02             	shl    $0x2,%eax
  800750:	01 d0                	add    %edx,%eax
  800752:	c1 e0 03             	shl    $0x3,%eax
  800755:	01 d0                	add    %edx,%eax
  800757:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80075e:	01 d0                	add    %edx,%eax
  800760:	c1 e0 02             	shl    $0x2,%eax
  800763:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800768:	a3 24 40 80 00       	mov    %eax,0x804024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80076d:	a1 24 40 80 00       	mov    0x804024,%eax
  800772:	8a 40 20             	mov    0x20(%eax),%al
  800775:	84 c0                	test   %al,%al
  800777:	74 0d                	je     800786 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800779:	a1 24 40 80 00       	mov    0x804024,%eax
  80077e:	83 c0 20             	add    $0x20,%eax
  800781:	a3 04 40 80 00       	mov    %eax,0x804004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800786:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80078a:	7e 0a                	jle    800796 <libmain+0x5f>
		binaryname = argv[0];
  80078c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80078f:	8b 00                	mov    (%eax),%eax
  800791:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	_main(argc, argv);
  800796:	83 ec 08             	sub    $0x8,%esp
  800799:	ff 75 0c             	pushl  0xc(%ebp)
  80079c:	ff 75 08             	pushl  0x8(%ebp)
  80079f:	e8 94 f8 ff ff       	call   800038 <_main>
  8007a4:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8007a7:	a1 00 40 80 00       	mov    0x804000,%eax
  8007ac:	85 c0                	test   %eax,%eax
  8007ae:	0f 84 01 01 00 00    	je     8008b5 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8007b4:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8007ba:	bb 94 2a 80 00       	mov    $0x802a94,%ebx
  8007bf:	ba 0e 00 00 00       	mov    $0xe,%edx
  8007c4:	89 c7                	mov    %eax,%edi
  8007c6:	89 de                	mov    %ebx,%esi
  8007c8:	89 d1                	mov    %edx,%ecx
  8007ca:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8007cc:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8007cf:	b9 56 00 00 00       	mov    $0x56,%ecx
  8007d4:	b0 00                	mov    $0x0,%al
  8007d6:	89 d7                	mov    %edx,%edi
  8007d8:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8007da:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8007e1:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8007e4:	83 ec 08             	sub    $0x8,%esp
  8007e7:	50                   	push   %eax
  8007e8:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8007ee:	50                   	push   %eax
  8007ef:	e8 83 1b 00 00       	call   802377 <sys_utilities>
  8007f4:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8007f7:	e8 cc 16 00 00       	call   801ec8 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8007fc:	83 ec 0c             	sub    $0xc,%esp
  8007ff:	68 b4 29 80 00       	push   $0x8029b4
  800804:	e8 ac 03 00 00       	call   800bb5 <cprintf>
  800809:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80080c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80080f:	85 c0                	test   %eax,%eax
  800811:	74 18                	je     80082b <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800813:	e8 7d 1b 00 00       	call   802395 <sys_get_optimal_num_faults>
  800818:	83 ec 08             	sub    $0x8,%esp
  80081b:	50                   	push   %eax
  80081c:	68 dc 29 80 00       	push   $0x8029dc
  800821:	e8 8f 03 00 00       	call   800bb5 <cprintf>
  800826:	83 c4 10             	add    $0x10,%esp
  800829:	eb 59                	jmp    800884 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80082b:	a1 24 40 80 00       	mov    0x804024,%eax
  800830:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  800836:	a1 24 40 80 00       	mov    0x804024,%eax
  80083b:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  800841:	83 ec 04             	sub    $0x4,%esp
  800844:	52                   	push   %edx
  800845:	50                   	push   %eax
  800846:	68 00 2a 80 00       	push   $0x802a00
  80084b:	e8 65 03 00 00       	call   800bb5 <cprintf>
  800850:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800853:	a1 24 40 80 00       	mov    0x804024,%eax
  800858:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  80085e:	a1 24 40 80 00       	mov    0x804024,%eax
  800863:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  800869:	a1 24 40 80 00       	mov    0x804024,%eax
  80086e:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  800874:	51                   	push   %ecx
  800875:	52                   	push   %edx
  800876:	50                   	push   %eax
  800877:	68 28 2a 80 00       	push   $0x802a28
  80087c:	e8 34 03 00 00       	call   800bb5 <cprintf>
  800881:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800884:	a1 24 40 80 00       	mov    0x804024,%eax
  800889:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  80088f:	83 ec 08             	sub    $0x8,%esp
  800892:	50                   	push   %eax
  800893:	68 80 2a 80 00       	push   $0x802a80
  800898:	e8 18 03 00 00       	call   800bb5 <cprintf>
  80089d:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8008a0:	83 ec 0c             	sub    $0xc,%esp
  8008a3:	68 b4 29 80 00       	push   $0x8029b4
  8008a8:	e8 08 03 00 00       	call   800bb5 <cprintf>
  8008ad:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8008b0:	e8 2d 16 00 00       	call   801ee2 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8008b5:	e8 1f 00 00 00       	call   8008d9 <exit>
}
  8008ba:	90                   	nop
  8008bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008be:	5b                   	pop    %ebx
  8008bf:	5e                   	pop    %esi
  8008c0:	5f                   	pop    %edi
  8008c1:	5d                   	pop    %ebp
  8008c2:	c3                   	ret    

008008c3 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8008c3:	55                   	push   %ebp
  8008c4:	89 e5                	mov    %esp,%ebp
  8008c6:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8008c9:	83 ec 0c             	sub    $0xc,%esp
  8008cc:	6a 00                	push   $0x0
  8008ce:	e8 3a 18 00 00       	call   80210d <sys_destroy_env>
  8008d3:	83 c4 10             	add    $0x10,%esp
}
  8008d6:	90                   	nop
  8008d7:	c9                   	leave  
  8008d8:	c3                   	ret    

008008d9 <exit>:

void
exit(void)
{
  8008d9:	55                   	push   %ebp
  8008da:	89 e5                	mov    %esp,%ebp
  8008dc:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8008df:	e8 8f 18 00 00       	call   802173 <sys_exit_env>
}
  8008e4:	90                   	nop
  8008e5:	c9                   	leave  
  8008e6:	c3                   	ret    

008008e7 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8008e7:	55                   	push   %ebp
  8008e8:	89 e5                	mov    %esp,%ebp
  8008ea:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8008ed:	8d 45 10             	lea    0x10(%ebp),%eax
  8008f0:	83 c0 04             	add    $0x4,%eax
  8008f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8008f6:	a1 18 c1 81 00       	mov    0x81c118,%eax
  8008fb:	85 c0                	test   %eax,%eax
  8008fd:	74 16                	je     800915 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8008ff:	a1 18 c1 81 00       	mov    0x81c118,%eax
  800904:	83 ec 08             	sub    $0x8,%esp
  800907:	50                   	push   %eax
  800908:	68 f8 2a 80 00       	push   $0x802af8
  80090d:	e8 a3 02 00 00       	call   800bb5 <cprintf>
  800912:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800915:	a1 04 40 80 00       	mov    0x804004,%eax
  80091a:	83 ec 0c             	sub    $0xc,%esp
  80091d:	ff 75 0c             	pushl  0xc(%ebp)
  800920:	ff 75 08             	pushl  0x8(%ebp)
  800923:	50                   	push   %eax
  800924:	68 00 2b 80 00       	push   $0x802b00
  800929:	6a 74                	push   $0x74
  80092b:	e8 b2 02 00 00       	call   800be2 <cprintf_colored>
  800930:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800933:	8b 45 10             	mov    0x10(%ebp),%eax
  800936:	83 ec 08             	sub    $0x8,%esp
  800939:	ff 75 f4             	pushl  -0xc(%ebp)
  80093c:	50                   	push   %eax
  80093d:	e8 04 02 00 00       	call   800b46 <vcprintf>
  800942:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800945:	83 ec 08             	sub    $0x8,%esp
  800948:	6a 00                	push   $0x0
  80094a:	68 28 2b 80 00       	push   $0x802b28
  80094f:	e8 f2 01 00 00       	call   800b46 <vcprintf>
  800954:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800957:	e8 7d ff ff ff       	call   8008d9 <exit>

	// should not return here
	while (1) ;
  80095c:	eb fe                	jmp    80095c <_panic+0x75>

0080095e <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80095e:	55                   	push   %ebp
  80095f:	89 e5                	mov    %esp,%ebp
  800961:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800964:	a1 24 40 80 00       	mov    0x804024,%eax
  800969:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80096f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800972:	39 c2                	cmp    %eax,%edx
  800974:	74 14                	je     80098a <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800976:	83 ec 04             	sub    $0x4,%esp
  800979:	68 2c 2b 80 00       	push   $0x802b2c
  80097e:	6a 26                	push   $0x26
  800980:	68 78 2b 80 00       	push   $0x802b78
  800985:	e8 5d ff ff ff       	call   8008e7 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80098a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800991:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800998:	e9 c5 00 00 00       	jmp    800a62 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80099d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009a0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8009a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009aa:	01 d0                	add    %edx,%eax
  8009ac:	8b 00                	mov    (%eax),%eax
  8009ae:	85 c0                	test   %eax,%eax
  8009b0:	75 08                	jne    8009ba <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8009b2:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8009b5:	e9 a5 00 00 00       	jmp    800a5f <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8009ba:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009c1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8009c8:	eb 69                	jmp    800a33 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8009ca:	a1 24 40 80 00       	mov    0x804024,%eax
  8009cf:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8009d5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009d8:	89 d0                	mov    %edx,%eax
  8009da:	01 c0                	add    %eax,%eax
  8009dc:	01 d0                	add    %edx,%eax
  8009de:	c1 e0 03             	shl    $0x3,%eax
  8009e1:	01 c8                	add    %ecx,%eax
  8009e3:	8a 40 04             	mov    0x4(%eax),%al
  8009e6:	84 c0                	test   %al,%al
  8009e8:	75 46                	jne    800a30 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8009ea:	a1 24 40 80 00       	mov    0x804024,%eax
  8009ef:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8009f5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009f8:	89 d0                	mov    %edx,%eax
  8009fa:	01 c0                	add    %eax,%eax
  8009fc:	01 d0                	add    %edx,%eax
  8009fe:	c1 e0 03             	shl    $0x3,%eax
  800a01:	01 c8                	add    %ecx,%eax
  800a03:	8b 00                	mov    (%eax),%eax
  800a05:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800a08:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800a0b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800a10:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800a12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a15:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1f:	01 c8                	add    %ecx,%eax
  800a21:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a23:	39 c2                	cmp    %eax,%edx
  800a25:	75 09                	jne    800a30 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800a27:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800a2e:	eb 15                	jmp    800a45 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a30:	ff 45 e8             	incl   -0x18(%ebp)
  800a33:	a1 24 40 80 00       	mov    0x804024,%eax
  800a38:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800a3e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a41:	39 c2                	cmp    %eax,%edx
  800a43:	77 85                	ja     8009ca <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800a45:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800a49:	75 14                	jne    800a5f <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800a4b:	83 ec 04             	sub    $0x4,%esp
  800a4e:	68 84 2b 80 00       	push   $0x802b84
  800a53:	6a 3a                	push   $0x3a
  800a55:	68 78 2b 80 00       	push   $0x802b78
  800a5a:	e8 88 fe ff ff       	call   8008e7 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800a5f:	ff 45 f0             	incl   -0x10(%ebp)
  800a62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a65:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800a68:	0f 8c 2f ff ff ff    	jl     80099d <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800a6e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a75:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800a7c:	eb 26                	jmp    800aa4 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800a7e:	a1 24 40 80 00       	mov    0x804024,%eax
  800a83:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800a89:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a8c:	89 d0                	mov    %edx,%eax
  800a8e:	01 c0                	add    %eax,%eax
  800a90:	01 d0                	add    %edx,%eax
  800a92:	c1 e0 03             	shl    $0x3,%eax
  800a95:	01 c8                	add    %ecx,%eax
  800a97:	8a 40 04             	mov    0x4(%eax),%al
  800a9a:	3c 01                	cmp    $0x1,%al
  800a9c:	75 03                	jne    800aa1 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800a9e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800aa1:	ff 45 e0             	incl   -0x20(%ebp)
  800aa4:	a1 24 40 80 00       	mov    0x804024,%eax
  800aa9:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800aaf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ab2:	39 c2                	cmp    %eax,%edx
  800ab4:	77 c8                	ja     800a7e <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800ab6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ab9:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800abc:	74 14                	je     800ad2 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800abe:	83 ec 04             	sub    $0x4,%esp
  800ac1:	68 d8 2b 80 00       	push   $0x802bd8
  800ac6:	6a 44                	push   $0x44
  800ac8:	68 78 2b 80 00       	push   $0x802b78
  800acd:	e8 15 fe ff ff       	call   8008e7 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800ad2:	90                   	nop
  800ad3:	c9                   	leave  
  800ad4:	c3                   	ret    

00800ad5 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800ad5:	55                   	push   %ebp
  800ad6:	89 e5                	mov    %esp,%ebp
  800ad8:	53                   	push   %ebx
  800ad9:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800adc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800adf:	8b 00                	mov    (%eax),%eax
  800ae1:	8d 48 01             	lea    0x1(%eax),%ecx
  800ae4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ae7:	89 0a                	mov    %ecx,(%edx)
  800ae9:	8b 55 08             	mov    0x8(%ebp),%edx
  800aec:	88 d1                	mov    %dl,%cl
  800aee:	8b 55 0c             	mov    0xc(%ebp),%edx
  800af1:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800af5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af8:	8b 00                	mov    (%eax),%eax
  800afa:	3d ff 00 00 00       	cmp    $0xff,%eax
  800aff:	75 30                	jne    800b31 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800b01:	8b 15 1c c1 81 00    	mov    0x81c11c,%edx
  800b07:	a0 44 40 80 00       	mov    0x804044,%al
  800b0c:	0f b6 c0             	movzbl %al,%eax
  800b0f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b12:	8b 09                	mov    (%ecx),%ecx
  800b14:	89 cb                	mov    %ecx,%ebx
  800b16:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b19:	83 c1 08             	add    $0x8,%ecx
  800b1c:	52                   	push   %edx
  800b1d:	50                   	push   %eax
  800b1e:	53                   	push   %ebx
  800b1f:	51                   	push   %ecx
  800b20:	e8 5f 13 00 00       	call   801e84 <sys_cputs>
  800b25:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800b28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b2b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800b31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b34:	8b 40 04             	mov    0x4(%eax),%eax
  800b37:	8d 50 01             	lea    0x1(%eax),%edx
  800b3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3d:	89 50 04             	mov    %edx,0x4(%eax)
}
  800b40:	90                   	nop
  800b41:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b44:	c9                   	leave  
  800b45:	c3                   	ret    

00800b46 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800b46:	55                   	push   %ebp
  800b47:	89 e5                	mov    %esp,%ebp
  800b49:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800b4f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800b56:	00 00 00 
	b.cnt = 0;
  800b59:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b60:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800b63:	ff 75 0c             	pushl  0xc(%ebp)
  800b66:	ff 75 08             	pushl  0x8(%ebp)
  800b69:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b6f:	50                   	push   %eax
  800b70:	68 d5 0a 80 00       	push   $0x800ad5
  800b75:	e8 5a 02 00 00       	call   800dd4 <vprintfmt>
  800b7a:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800b7d:	8b 15 1c c1 81 00    	mov    0x81c11c,%edx
  800b83:	a0 44 40 80 00       	mov    0x804044,%al
  800b88:	0f b6 c0             	movzbl %al,%eax
  800b8b:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800b91:	52                   	push   %edx
  800b92:	50                   	push   %eax
  800b93:	51                   	push   %ecx
  800b94:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b9a:	83 c0 08             	add    $0x8,%eax
  800b9d:	50                   	push   %eax
  800b9e:	e8 e1 12 00 00       	call   801e84 <sys_cputs>
  800ba3:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800ba6:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
	return b.cnt;
  800bad:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800bb3:	c9                   	leave  
  800bb4:	c3                   	ret    

00800bb5 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800bb5:	55                   	push   %ebp
  800bb6:	89 e5                	mov    %esp,%ebp
  800bb8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800bbb:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	va_start(ap, fmt);
  800bc2:	8d 45 0c             	lea    0xc(%ebp),%eax
  800bc5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcb:	83 ec 08             	sub    $0x8,%esp
  800bce:	ff 75 f4             	pushl  -0xc(%ebp)
  800bd1:	50                   	push   %eax
  800bd2:	e8 6f ff ff ff       	call   800b46 <vcprintf>
  800bd7:	83 c4 10             	add    $0x10,%esp
  800bda:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800bdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800be0:	c9                   	leave  
  800be1:	c3                   	ret    

00800be2 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800be2:	55                   	push   %ebp
  800be3:	89 e5                	mov    %esp,%ebp
  800be5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800be8:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800bef:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf2:	c1 e0 08             	shl    $0x8,%eax
  800bf5:	a3 1c c1 81 00       	mov    %eax,0x81c11c
	va_start(ap, fmt);
  800bfa:	8d 45 0c             	lea    0xc(%ebp),%eax
  800bfd:	83 c0 04             	add    $0x4,%eax
  800c00:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800c03:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c06:	83 ec 08             	sub    $0x8,%esp
  800c09:	ff 75 f4             	pushl  -0xc(%ebp)
  800c0c:	50                   	push   %eax
  800c0d:	e8 34 ff ff ff       	call   800b46 <vcprintf>
  800c12:	83 c4 10             	add    $0x10,%esp
  800c15:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800c18:	c7 05 1c c1 81 00 00 	movl   $0x700,0x81c11c
  800c1f:	07 00 00 

	return cnt;
  800c22:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c25:	c9                   	leave  
  800c26:	c3                   	ret    

00800c27 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800c27:	55                   	push   %ebp
  800c28:	89 e5                	mov    %esp,%ebp
  800c2a:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800c2d:	e8 96 12 00 00       	call   801ec8 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800c32:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c35:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800c38:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3b:	83 ec 08             	sub    $0x8,%esp
  800c3e:	ff 75 f4             	pushl  -0xc(%ebp)
  800c41:	50                   	push   %eax
  800c42:	e8 ff fe ff ff       	call   800b46 <vcprintf>
  800c47:	83 c4 10             	add    $0x10,%esp
  800c4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800c4d:	e8 90 12 00 00       	call   801ee2 <sys_unlock_cons>
	return cnt;
  800c52:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c55:	c9                   	leave  
  800c56:	c3                   	ret    

00800c57 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800c57:	55                   	push   %ebp
  800c58:	89 e5                	mov    %esp,%ebp
  800c5a:	53                   	push   %ebx
  800c5b:	83 ec 14             	sub    $0x14,%esp
  800c5e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c61:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c64:	8b 45 14             	mov    0x14(%ebp),%eax
  800c67:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800c6a:	8b 45 18             	mov    0x18(%ebp),%eax
  800c6d:	ba 00 00 00 00       	mov    $0x0,%edx
  800c72:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c75:	77 55                	ja     800ccc <printnum+0x75>
  800c77:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c7a:	72 05                	jb     800c81 <printnum+0x2a>
  800c7c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800c7f:	77 4b                	ja     800ccc <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800c81:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800c84:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800c87:	8b 45 18             	mov    0x18(%ebp),%eax
  800c8a:	ba 00 00 00 00       	mov    $0x0,%edx
  800c8f:	52                   	push   %edx
  800c90:	50                   	push   %eax
  800c91:	ff 75 f4             	pushl  -0xc(%ebp)
  800c94:	ff 75 f0             	pushl  -0x10(%ebp)
  800c97:	e8 b0 18 00 00       	call   80254c <__udivdi3>
  800c9c:	83 c4 10             	add    $0x10,%esp
  800c9f:	83 ec 04             	sub    $0x4,%esp
  800ca2:	ff 75 20             	pushl  0x20(%ebp)
  800ca5:	53                   	push   %ebx
  800ca6:	ff 75 18             	pushl  0x18(%ebp)
  800ca9:	52                   	push   %edx
  800caa:	50                   	push   %eax
  800cab:	ff 75 0c             	pushl  0xc(%ebp)
  800cae:	ff 75 08             	pushl  0x8(%ebp)
  800cb1:	e8 a1 ff ff ff       	call   800c57 <printnum>
  800cb6:	83 c4 20             	add    $0x20,%esp
  800cb9:	eb 1a                	jmp    800cd5 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800cbb:	83 ec 08             	sub    $0x8,%esp
  800cbe:	ff 75 0c             	pushl  0xc(%ebp)
  800cc1:	ff 75 20             	pushl  0x20(%ebp)
  800cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc7:	ff d0                	call   *%eax
  800cc9:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800ccc:	ff 4d 1c             	decl   0x1c(%ebp)
  800ccf:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800cd3:	7f e6                	jg     800cbb <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800cd5:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800cd8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ce0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ce3:	53                   	push   %ebx
  800ce4:	51                   	push   %ecx
  800ce5:	52                   	push   %edx
  800ce6:	50                   	push   %eax
  800ce7:	e8 70 19 00 00       	call   80265c <__umoddi3>
  800cec:	83 c4 10             	add    $0x10,%esp
  800cef:	05 54 2e 80 00       	add    $0x802e54,%eax
  800cf4:	8a 00                	mov    (%eax),%al
  800cf6:	0f be c0             	movsbl %al,%eax
  800cf9:	83 ec 08             	sub    $0x8,%esp
  800cfc:	ff 75 0c             	pushl  0xc(%ebp)
  800cff:	50                   	push   %eax
  800d00:	8b 45 08             	mov    0x8(%ebp),%eax
  800d03:	ff d0                	call   *%eax
  800d05:	83 c4 10             	add    $0x10,%esp
}
  800d08:	90                   	nop
  800d09:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800d0c:	c9                   	leave  
  800d0d:	c3                   	ret    

00800d0e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800d0e:	55                   	push   %ebp
  800d0f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d11:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d15:	7e 1c                	jle    800d33 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800d17:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1a:	8b 00                	mov    (%eax),%eax
  800d1c:	8d 50 08             	lea    0x8(%eax),%edx
  800d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d22:	89 10                	mov    %edx,(%eax)
  800d24:	8b 45 08             	mov    0x8(%ebp),%eax
  800d27:	8b 00                	mov    (%eax),%eax
  800d29:	83 e8 08             	sub    $0x8,%eax
  800d2c:	8b 50 04             	mov    0x4(%eax),%edx
  800d2f:	8b 00                	mov    (%eax),%eax
  800d31:	eb 40                	jmp    800d73 <getuint+0x65>
	else if (lflag)
  800d33:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d37:	74 1e                	je     800d57 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800d39:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3c:	8b 00                	mov    (%eax),%eax
  800d3e:	8d 50 04             	lea    0x4(%eax),%edx
  800d41:	8b 45 08             	mov    0x8(%ebp),%eax
  800d44:	89 10                	mov    %edx,(%eax)
  800d46:	8b 45 08             	mov    0x8(%ebp),%eax
  800d49:	8b 00                	mov    (%eax),%eax
  800d4b:	83 e8 04             	sub    $0x4,%eax
  800d4e:	8b 00                	mov    (%eax),%eax
  800d50:	ba 00 00 00 00       	mov    $0x0,%edx
  800d55:	eb 1c                	jmp    800d73 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800d57:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5a:	8b 00                	mov    (%eax),%eax
  800d5c:	8d 50 04             	lea    0x4(%eax),%edx
  800d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d62:	89 10                	mov    %edx,(%eax)
  800d64:	8b 45 08             	mov    0x8(%ebp),%eax
  800d67:	8b 00                	mov    (%eax),%eax
  800d69:	83 e8 04             	sub    $0x4,%eax
  800d6c:	8b 00                	mov    (%eax),%eax
  800d6e:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800d73:	5d                   	pop    %ebp
  800d74:	c3                   	ret    

00800d75 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800d75:	55                   	push   %ebp
  800d76:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d78:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d7c:	7e 1c                	jle    800d9a <getint+0x25>
		return va_arg(*ap, long long);
  800d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d81:	8b 00                	mov    (%eax),%eax
  800d83:	8d 50 08             	lea    0x8(%eax),%edx
  800d86:	8b 45 08             	mov    0x8(%ebp),%eax
  800d89:	89 10                	mov    %edx,(%eax)
  800d8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8e:	8b 00                	mov    (%eax),%eax
  800d90:	83 e8 08             	sub    $0x8,%eax
  800d93:	8b 50 04             	mov    0x4(%eax),%edx
  800d96:	8b 00                	mov    (%eax),%eax
  800d98:	eb 38                	jmp    800dd2 <getint+0x5d>
	else if (lflag)
  800d9a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d9e:	74 1a                	je     800dba <getint+0x45>
		return va_arg(*ap, long);
  800da0:	8b 45 08             	mov    0x8(%ebp),%eax
  800da3:	8b 00                	mov    (%eax),%eax
  800da5:	8d 50 04             	lea    0x4(%eax),%edx
  800da8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dab:	89 10                	mov    %edx,(%eax)
  800dad:	8b 45 08             	mov    0x8(%ebp),%eax
  800db0:	8b 00                	mov    (%eax),%eax
  800db2:	83 e8 04             	sub    $0x4,%eax
  800db5:	8b 00                	mov    (%eax),%eax
  800db7:	99                   	cltd   
  800db8:	eb 18                	jmp    800dd2 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800dba:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbd:	8b 00                	mov    (%eax),%eax
  800dbf:	8d 50 04             	lea    0x4(%eax),%edx
  800dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc5:	89 10                	mov    %edx,(%eax)
  800dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dca:	8b 00                	mov    (%eax),%eax
  800dcc:	83 e8 04             	sub    $0x4,%eax
  800dcf:	8b 00                	mov    (%eax),%eax
  800dd1:	99                   	cltd   
}
  800dd2:	5d                   	pop    %ebp
  800dd3:	c3                   	ret    

00800dd4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800dd4:	55                   	push   %ebp
  800dd5:	89 e5                	mov    %esp,%ebp
  800dd7:	56                   	push   %esi
  800dd8:	53                   	push   %ebx
  800dd9:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ddc:	eb 17                	jmp    800df5 <vprintfmt+0x21>
			if (ch == '\0')
  800dde:	85 db                	test   %ebx,%ebx
  800de0:	0f 84 c1 03 00 00    	je     8011a7 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800de6:	83 ec 08             	sub    $0x8,%esp
  800de9:	ff 75 0c             	pushl  0xc(%ebp)
  800dec:	53                   	push   %ebx
  800ded:	8b 45 08             	mov    0x8(%ebp),%eax
  800df0:	ff d0                	call   *%eax
  800df2:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800df5:	8b 45 10             	mov    0x10(%ebp),%eax
  800df8:	8d 50 01             	lea    0x1(%eax),%edx
  800dfb:	89 55 10             	mov    %edx,0x10(%ebp)
  800dfe:	8a 00                	mov    (%eax),%al
  800e00:	0f b6 d8             	movzbl %al,%ebx
  800e03:	83 fb 25             	cmp    $0x25,%ebx
  800e06:	75 d6                	jne    800dde <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800e08:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800e0c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800e13:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800e1a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800e21:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800e28:	8b 45 10             	mov    0x10(%ebp),%eax
  800e2b:	8d 50 01             	lea    0x1(%eax),%edx
  800e2e:	89 55 10             	mov    %edx,0x10(%ebp)
  800e31:	8a 00                	mov    (%eax),%al
  800e33:	0f b6 d8             	movzbl %al,%ebx
  800e36:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800e39:	83 f8 5b             	cmp    $0x5b,%eax
  800e3c:	0f 87 3d 03 00 00    	ja     80117f <vprintfmt+0x3ab>
  800e42:	8b 04 85 78 2e 80 00 	mov    0x802e78(,%eax,4),%eax
  800e49:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800e4b:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800e4f:	eb d7                	jmp    800e28 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800e51:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800e55:	eb d1                	jmp    800e28 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e57:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800e5e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800e61:	89 d0                	mov    %edx,%eax
  800e63:	c1 e0 02             	shl    $0x2,%eax
  800e66:	01 d0                	add    %edx,%eax
  800e68:	01 c0                	add    %eax,%eax
  800e6a:	01 d8                	add    %ebx,%eax
  800e6c:	83 e8 30             	sub    $0x30,%eax
  800e6f:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800e72:	8b 45 10             	mov    0x10(%ebp),%eax
  800e75:	8a 00                	mov    (%eax),%al
  800e77:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800e7a:	83 fb 2f             	cmp    $0x2f,%ebx
  800e7d:	7e 3e                	jle    800ebd <vprintfmt+0xe9>
  800e7f:	83 fb 39             	cmp    $0x39,%ebx
  800e82:	7f 39                	jg     800ebd <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e84:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800e87:	eb d5                	jmp    800e5e <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800e89:	8b 45 14             	mov    0x14(%ebp),%eax
  800e8c:	83 c0 04             	add    $0x4,%eax
  800e8f:	89 45 14             	mov    %eax,0x14(%ebp)
  800e92:	8b 45 14             	mov    0x14(%ebp),%eax
  800e95:	83 e8 04             	sub    $0x4,%eax
  800e98:	8b 00                	mov    (%eax),%eax
  800e9a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800e9d:	eb 1f                	jmp    800ebe <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800e9f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ea3:	79 83                	jns    800e28 <vprintfmt+0x54>
				width = 0;
  800ea5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800eac:	e9 77 ff ff ff       	jmp    800e28 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800eb1:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800eb8:	e9 6b ff ff ff       	jmp    800e28 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800ebd:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800ebe:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ec2:	0f 89 60 ff ff ff    	jns    800e28 <vprintfmt+0x54>
				width = precision, precision = -1;
  800ec8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ecb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800ece:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800ed5:	e9 4e ff ff ff       	jmp    800e28 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800eda:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800edd:	e9 46 ff ff ff       	jmp    800e28 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800ee2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ee5:	83 c0 04             	add    $0x4,%eax
  800ee8:	89 45 14             	mov    %eax,0x14(%ebp)
  800eeb:	8b 45 14             	mov    0x14(%ebp),%eax
  800eee:	83 e8 04             	sub    $0x4,%eax
  800ef1:	8b 00                	mov    (%eax),%eax
  800ef3:	83 ec 08             	sub    $0x8,%esp
  800ef6:	ff 75 0c             	pushl  0xc(%ebp)
  800ef9:	50                   	push   %eax
  800efa:	8b 45 08             	mov    0x8(%ebp),%eax
  800efd:	ff d0                	call   *%eax
  800eff:	83 c4 10             	add    $0x10,%esp
			break;
  800f02:	e9 9b 02 00 00       	jmp    8011a2 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800f07:	8b 45 14             	mov    0x14(%ebp),%eax
  800f0a:	83 c0 04             	add    $0x4,%eax
  800f0d:	89 45 14             	mov    %eax,0x14(%ebp)
  800f10:	8b 45 14             	mov    0x14(%ebp),%eax
  800f13:	83 e8 04             	sub    $0x4,%eax
  800f16:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800f18:	85 db                	test   %ebx,%ebx
  800f1a:	79 02                	jns    800f1e <vprintfmt+0x14a>
				err = -err;
  800f1c:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800f1e:	83 fb 64             	cmp    $0x64,%ebx
  800f21:	7f 0b                	jg     800f2e <vprintfmt+0x15a>
  800f23:	8b 34 9d c0 2c 80 00 	mov    0x802cc0(,%ebx,4),%esi
  800f2a:	85 f6                	test   %esi,%esi
  800f2c:	75 19                	jne    800f47 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800f2e:	53                   	push   %ebx
  800f2f:	68 65 2e 80 00       	push   $0x802e65
  800f34:	ff 75 0c             	pushl  0xc(%ebp)
  800f37:	ff 75 08             	pushl  0x8(%ebp)
  800f3a:	e8 70 02 00 00       	call   8011af <printfmt>
  800f3f:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800f42:	e9 5b 02 00 00       	jmp    8011a2 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800f47:	56                   	push   %esi
  800f48:	68 6e 2e 80 00       	push   $0x802e6e
  800f4d:	ff 75 0c             	pushl  0xc(%ebp)
  800f50:	ff 75 08             	pushl  0x8(%ebp)
  800f53:	e8 57 02 00 00       	call   8011af <printfmt>
  800f58:	83 c4 10             	add    $0x10,%esp
			break;
  800f5b:	e9 42 02 00 00       	jmp    8011a2 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800f60:	8b 45 14             	mov    0x14(%ebp),%eax
  800f63:	83 c0 04             	add    $0x4,%eax
  800f66:	89 45 14             	mov    %eax,0x14(%ebp)
  800f69:	8b 45 14             	mov    0x14(%ebp),%eax
  800f6c:	83 e8 04             	sub    $0x4,%eax
  800f6f:	8b 30                	mov    (%eax),%esi
  800f71:	85 f6                	test   %esi,%esi
  800f73:	75 05                	jne    800f7a <vprintfmt+0x1a6>
				p = "(null)";
  800f75:	be 71 2e 80 00       	mov    $0x802e71,%esi
			if (width > 0 && padc != '-')
  800f7a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f7e:	7e 6d                	jle    800fed <vprintfmt+0x219>
  800f80:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800f84:	74 67                	je     800fed <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800f86:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f89:	83 ec 08             	sub    $0x8,%esp
  800f8c:	50                   	push   %eax
  800f8d:	56                   	push   %esi
  800f8e:	e8 26 05 00 00       	call   8014b9 <strnlen>
  800f93:	83 c4 10             	add    $0x10,%esp
  800f96:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800f99:	eb 16                	jmp    800fb1 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800f9b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800f9f:	83 ec 08             	sub    $0x8,%esp
  800fa2:	ff 75 0c             	pushl  0xc(%ebp)
  800fa5:	50                   	push   %eax
  800fa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa9:	ff d0                	call   *%eax
  800fab:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800fae:	ff 4d e4             	decl   -0x1c(%ebp)
  800fb1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fb5:	7f e4                	jg     800f9b <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800fb7:	eb 34                	jmp    800fed <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800fb9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800fbd:	74 1c                	je     800fdb <vprintfmt+0x207>
  800fbf:	83 fb 1f             	cmp    $0x1f,%ebx
  800fc2:	7e 05                	jle    800fc9 <vprintfmt+0x1f5>
  800fc4:	83 fb 7e             	cmp    $0x7e,%ebx
  800fc7:	7e 12                	jle    800fdb <vprintfmt+0x207>
					putch('?', putdat);
  800fc9:	83 ec 08             	sub    $0x8,%esp
  800fcc:	ff 75 0c             	pushl  0xc(%ebp)
  800fcf:	6a 3f                	push   $0x3f
  800fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd4:	ff d0                	call   *%eax
  800fd6:	83 c4 10             	add    $0x10,%esp
  800fd9:	eb 0f                	jmp    800fea <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800fdb:	83 ec 08             	sub    $0x8,%esp
  800fde:	ff 75 0c             	pushl  0xc(%ebp)
  800fe1:	53                   	push   %ebx
  800fe2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe5:	ff d0                	call   *%eax
  800fe7:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800fea:	ff 4d e4             	decl   -0x1c(%ebp)
  800fed:	89 f0                	mov    %esi,%eax
  800fef:	8d 70 01             	lea    0x1(%eax),%esi
  800ff2:	8a 00                	mov    (%eax),%al
  800ff4:	0f be d8             	movsbl %al,%ebx
  800ff7:	85 db                	test   %ebx,%ebx
  800ff9:	74 24                	je     80101f <vprintfmt+0x24b>
  800ffb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800fff:	78 b8                	js     800fb9 <vprintfmt+0x1e5>
  801001:	ff 4d e0             	decl   -0x20(%ebp)
  801004:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801008:	79 af                	jns    800fb9 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80100a:	eb 13                	jmp    80101f <vprintfmt+0x24b>
				putch(' ', putdat);
  80100c:	83 ec 08             	sub    $0x8,%esp
  80100f:	ff 75 0c             	pushl  0xc(%ebp)
  801012:	6a 20                	push   $0x20
  801014:	8b 45 08             	mov    0x8(%ebp),%eax
  801017:	ff d0                	call   *%eax
  801019:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80101c:	ff 4d e4             	decl   -0x1c(%ebp)
  80101f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801023:	7f e7                	jg     80100c <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801025:	e9 78 01 00 00       	jmp    8011a2 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80102a:	83 ec 08             	sub    $0x8,%esp
  80102d:	ff 75 e8             	pushl  -0x18(%ebp)
  801030:	8d 45 14             	lea    0x14(%ebp),%eax
  801033:	50                   	push   %eax
  801034:	e8 3c fd ff ff       	call   800d75 <getint>
  801039:	83 c4 10             	add    $0x10,%esp
  80103c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80103f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801042:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801045:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801048:	85 d2                	test   %edx,%edx
  80104a:	79 23                	jns    80106f <vprintfmt+0x29b>
				putch('-', putdat);
  80104c:	83 ec 08             	sub    $0x8,%esp
  80104f:	ff 75 0c             	pushl  0xc(%ebp)
  801052:	6a 2d                	push   $0x2d
  801054:	8b 45 08             	mov    0x8(%ebp),%eax
  801057:	ff d0                	call   *%eax
  801059:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80105c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80105f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801062:	f7 d8                	neg    %eax
  801064:	83 d2 00             	adc    $0x0,%edx
  801067:	f7 da                	neg    %edx
  801069:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80106c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80106f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801076:	e9 bc 00 00 00       	jmp    801137 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80107b:	83 ec 08             	sub    $0x8,%esp
  80107e:	ff 75 e8             	pushl  -0x18(%ebp)
  801081:	8d 45 14             	lea    0x14(%ebp),%eax
  801084:	50                   	push   %eax
  801085:	e8 84 fc ff ff       	call   800d0e <getuint>
  80108a:	83 c4 10             	add    $0x10,%esp
  80108d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801090:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801093:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80109a:	e9 98 00 00 00       	jmp    801137 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80109f:	83 ec 08             	sub    $0x8,%esp
  8010a2:	ff 75 0c             	pushl  0xc(%ebp)
  8010a5:	6a 58                	push   $0x58
  8010a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010aa:	ff d0                	call   *%eax
  8010ac:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8010af:	83 ec 08             	sub    $0x8,%esp
  8010b2:	ff 75 0c             	pushl  0xc(%ebp)
  8010b5:	6a 58                	push   $0x58
  8010b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ba:	ff d0                	call   *%eax
  8010bc:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8010bf:	83 ec 08             	sub    $0x8,%esp
  8010c2:	ff 75 0c             	pushl  0xc(%ebp)
  8010c5:	6a 58                	push   $0x58
  8010c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ca:	ff d0                	call   *%eax
  8010cc:	83 c4 10             	add    $0x10,%esp
			break;
  8010cf:	e9 ce 00 00 00       	jmp    8011a2 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8010d4:	83 ec 08             	sub    $0x8,%esp
  8010d7:	ff 75 0c             	pushl  0xc(%ebp)
  8010da:	6a 30                	push   $0x30
  8010dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010df:	ff d0                	call   *%eax
  8010e1:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8010e4:	83 ec 08             	sub    $0x8,%esp
  8010e7:	ff 75 0c             	pushl  0xc(%ebp)
  8010ea:	6a 78                	push   $0x78
  8010ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ef:	ff d0                	call   *%eax
  8010f1:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8010f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8010f7:	83 c0 04             	add    $0x4,%eax
  8010fa:	89 45 14             	mov    %eax,0x14(%ebp)
  8010fd:	8b 45 14             	mov    0x14(%ebp),%eax
  801100:	83 e8 04             	sub    $0x4,%eax
  801103:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801105:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801108:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80110f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801116:	eb 1f                	jmp    801137 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801118:	83 ec 08             	sub    $0x8,%esp
  80111b:	ff 75 e8             	pushl  -0x18(%ebp)
  80111e:	8d 45 14             	lea    0x14(%ebp),%eax
  801121:	50                   	push   %eax
  801122:	e8 e7 fb ff ff       	call   800d0e <getuint>
  801127:	83 c4 10             	add    $0x10,%esp
  80112a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80112d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801130:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801137:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80113b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80113e:	83 ec 04             	sub    $0x4,%esp
  801141:	52                   	push   %edx
  801142:	ff 75 e4             	pushl  -0x1c(%ebp)
  801145:	50                   	push   %eax
  801146:	ff 75 f4             	pushl  -0xc(%ebp)
  801149:	ff 75 f0             	pushl  -0x10(%ebp)
  80114c:	ff 75 0c             	pushl  0xc(%ebp)
  80114f:	ff 75 08             	pushl  0x8(%ebp)
  801152:	e8 00 fb ff ff       	call   800c57 <printnum>
  801157:	83 c4 20             	add    $0x20,%esp
			break;
  80115a:	eb 46                	jmp    8011a2 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80115c:	83 ec 08             	sub    $0x8,%esp
  80115f:	ff 75 0c             	pushl  0xc(%ebp)
  801162:	53                   	push   %ebx
  801163:	8b 45 08             	mov    0x8(%ebp),%eax
  801166:	ff d0                	call   *%eax
  801168:	83 c4 10             	add    $0x10,%esp
			break;
  80116b:	eb 35                	jmp    8011a2 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  80116d:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
			break;
  801174:	eb 2c                	jmp    8011a2 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  801176:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
			break;
  80117d:	eb 23                	jmp    8011a2 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80117f:	83 ec 08             	sub    $0x8,%esp
  801182:	ff 75 0c             	pushl  0xc(%ebp)
  801185:	6a 25                	push   $0x25
  801187:	8b 45 08             	mov    0x8(%ebp),%eax
  80118a:	ff d0                	call   *%eax
  80118c:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80118f:	ff 4d 10             	decl   0x10(%ebp)
  801192:	eb 03                	jmp    801197 <vprintfmt+0x3c3>
  801194:	ff 4d 10             	decl   0x10(%ebp)
  801197:	8b 45 10             	mov    0x10(%ebp),%eax
  80119a:	48                   	dec    %eax
  80119b:	8a 00                	mov    (%eax),%al
  80119d:	3c 25                	cmp    $0x25,%al
  80119f:	75 f3                	jne    801194 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8011a1:	90                   	nop
		}
	}
  8011a2:	e9 35 fc ff ff       	jmp    800ddc <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8011a7:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8011a8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8011ab:	5b                   	pop    %ebx
  8011ac:	5e                   	pop    %esi
  8011ad:	5d                   	pop    %ebp
  8011ae:	c3                   	ret    

008011af <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8011af:	55                   	push   %ebp
  8011b0:	89 e5                	mov    %esp,%ebp
  8011b2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8011b5:	8d 45 10             	lea    0x10(%ebp),%eax
  8011b8:	83 c0 04             	add    $0x4,%eax
  8011bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8011be:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c1:	ff 75 f4             	pushl  -0xc(%ebp)
  8011c4:	50                   	push   %eax
  8011c5:	ff 75 0c             	pushl  0xc(%ebp)
  8011c8:	ff 75 08             	pushl  0x8(%ebp)
  8011cb:	e8 04 fc ff ff       	call   800dd4 <vprintfmt>
  8011d0:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8011d3:	90                   	nop
  8011d4:	c9                   	leave  
  8011d5:	c3                   	ret    

008011d6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8011d6:	55                   	push   %ebp
  8011d7:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8011d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011dc:	8b 40 08             	mov    0x8(%eax),%eax
  8011df:	8d 50 01             	lea    0x1(%eax),%edx
  8011e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e5:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8011e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011eb:	8b 10                	mov    (%eax),%edx
  8011ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f0:	8b 40 04             	mov    0x4(%eax),%eax
  8011f3:	39 c2                	cmp    %eax,%edx
  8011f5:	73 12                	jae    801209 <sprintputch+0x33>
		*b->buf++ = ch;
  8011f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fa:	8b 00                	mov    (%eax),%eax
  8011fc:	8d 48 01             	lea    0x1(%eax),%ecx
  8011ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801202:	89 0a                	mov    %ecx,(%edx)
  801204:	8b 55 08             	mov    0x8(%ebp),%edx
  801207:	88 10                	mov    %dl,(%eax)
}
  801209:	90                   	nop
  80120a:	5d                   	pop    %ebp
  80120b:	c3                   	ret    

0080120c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80120c:	55                   	push   %ebp
  80120d:	89 e5                	mov    %esp,%ebp
  80120f:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801212:	8b 45 08             	mov    0x8(%ebp),%eax
  801215:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801218:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80121e:	8b 45 08             	mov    0x8(%ebp),%eax
  801221:	01 d0                	add    %edx,%eax
  801223:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801226:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80122d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801231:	74 06                	je     801239 <vsnprintf+0x2d>
  801233:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801237:	7f 07                	jg     801240 <vsnprintf+0x34>
		return -E_INVAL;
  801239:	b8 03 00 00 00       	mov    $0x3,%eax
  80123e:	eb 20                	jmp    801260 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801240:	ff 75 14             	pushl  0x14(%ebp)
  801243:	ff 75 10             	pushl  0x10(%ebp)
  801246:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801249:	50                   	push   %eax
  80124a:	68 d6 11 80 00       	push   $0x8011d6
  80124f:	e8 80 fb ff ff       	call   800dd4 <vprintfmt>
  801254:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801257:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80125a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80125d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801260:	c9                   	leave  
  801261:	c3                   	ret    

00801262 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801262:	55                   	push   %ebp
  801263:	89 e5                	mov    %esp,%ebp
  801265:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801268:	8d 45 10             	lea    0x10(%ebp),%eax
  80126b:	83 c0 04             	add    $0x4,%eax
  80126e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801271:	8b 45 10             	mov    0x10(%ebp),%eax
  801274:	ff 75 f4             	pushl  -0xc(%ebp)
  801277:	50                   	push   %eax
  801278:	ff 75 0c             	pushl  0xc(%ebp)
  80127b:	ff 75 08             	pushl  0x8(%ebp)
  80127e:	e8 89 ff ff ff       	call   80120c <vsnprintf>
  801283:	83 c4 10             	add    $0x10,%esp
  801286:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801289:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80128c:	c9                   	leave  
  80128d:	c3                   	ret    

0080128e <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  80128e:	55                   	push   %ebp
  80128f:	89 e5                	mov    %esp,%ebp
  801291:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  801294:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801298:	74 13                	je     8012ad <readline+0x1f>
		cprintf("%s", prompt);
  80129a:	83 ec 08             	sub    $0x8,%esp
  80129d:	ff 75 08             	pushl  0x8(%ebp)
  8012a0:	68 e8 2f 80 00       	push   $0x802fe8
  8012a5:	e8 0b f9 ff ff       	call   800bb5 <cprintf>
  8012aa:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8012ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8012b4:	83 ec 0c             	sub    $0xc,%esp
  8012b7:	6a 00                	push   $0x0
  8012b9:	e8 6f f4 ff ff       	call   80072d <iscons>
  8012be:	83 c4 10             	add    $0x10,%esp
  8012c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8012c4:	e8 51 f4 ff ff       	call   80071a <getchar>
  8012c9:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8012cc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8012d0:	79 22                	jns    8012f4 <readline+0x66>
			if (c != -E_EOF)
  8012d2:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8012d6:	0f 84 ad 00 00 00    	je     801389 <readline+0xfb>
				cprintf("read error: %e\n", c);
  8012dc:	83 ec 08             	sub    $0x8,%esp
  8012df:	ff 75 ec             	pushl  -0x14(%ebp)
  8012e2:	68 eb 2f 80 00       	push   $0x802feb
  8012e7:	e8 c9 f8 ff ff       	call   800bb5 <cprintf>
  8012ec:	83 c4 10             	add    $0x10,%esp
			break;
  8012ef:	e9 95 00 00 00       	jmp    801389 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8012f4:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8012f8:	7e 34                	jle    80132e <readline+0xa0>
  8012fa:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801301:	7f 2b                	jg     80132e <readline+0xa0>
			if (echoing)
  801303:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801307:	74 0e                	je     801317 <readline+0x89>
				cputchar(c);
  801309:	83 ec 0c             	sub    $0xc,%esp
  80130c:	ff 75 ec             	pushl  -0x14(%ebp)
  80130f:	e8 e7 f3 ff ff       	call   8006fb <cputchar>
  801314:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801317:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80131a:	8d 50 01             	lea    0x1(%eax),%edx
  80131d:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801320:	89 c2                	mov    %eax,%edx
  801322:	8b 45 0c             	mov    0xc(%ebp),%eax
  801325:	01 d0                	add    %edx,%eax
  801327:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80132a:	88 10                	mov    %dl,(%eax)
  80132c:	eb 56                	jmp    801384 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  80132e:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801332:	75 1f                	jne    801353 <readline+0xc5>
  801334:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801338:	7e 19                	jle    801353 <readline+0xc5>
			if (echoing)
  80133a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80133e:	74 0e                	je     80134e <readline+0xc0>
				cputchar(c);
  801340:	83 ec 0c             	sub    $0xc,%esp
  801343:	ff 75 ec             	pushl  -0x14(%ebp)
  801346:	e8 b0 f3 ff ff       	call   8006fb <cputchar>
  80134b:	83 c4 10             	add    $0x10,%esp

			i--;
  80134e:	ff 4d f4             	decl   -0xc(%ebp)
  801351:	eb 31                	jmp    801384 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  801353:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801357:	74 0a                	je     801363 <readline+0xd5>
  801359:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  80135d:	0f 85 61 ff ff ff    	jne    8012c4 <readline+0x36>
			if (echoing)
  801363:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801367:	74 0e                	je     801377 <readline+0xe9>
				cputchar(c);
  801369:	83 ec 0c             	sub    $0xc,%esp
  80136c:	ff 75 ec             	pushl  -0x14(%ebp)
  80136f:	e8 87 f3 ff ff       	call   8006fb <cputchar>
  801374:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  801377:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80137a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80137d:	01 d0                	add    %edx,%eax
  80137f:	c6 00 00             	movb   $0x0,(%eax)
			break;
  801382:	eb 06                	jmp    80138a <readline+0xfc>
		}
	}
  801384:	e9 3b ff ff ff       	jmp    8012c4 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  801389:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  80138a:	90                   	nop
  80138b:	c9                   	leave  
  80138c:	c3                   	ret    

0080138d <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  80138d:	55                   	push   %ebp
  80138e:	89 e5                	mov    %esp,%ebp
  801390:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  801393:	e8 30 0b 00 00       	call   801ec8 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  801398:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80139c:	74 13                	je     8013b1 <atomic_readline+0x24>
			cprintf("%s", prompt);
  80139e:	83 ec 08             	sub    $0x8,%esp
  8013a1:	ff 75 08             	pushl  0x8(%ebp)
  8013a4:	68 e8 2f 80 00       	push   $0x802fe8
  8013a9:	e8 07 f8 ff ff       	call   800bb5 <cprintf>
  8013ae:	83 c4 10             	add    $0x10,%esp

		i = 0;
  8013b1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  8013b8:	83 ec 0c             	sub    $0xc,%esp
  8013bb:	6a 00                	push   $0x0
  8013bd:	e8 6b f3 ff ff       	call   80072d <iscons>
  8013c2:	83 c4 10             	add    $0x10,%esp
  8013c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  8013c8:	e8 4d f3 ff ff       	call   80071a <getchar>
  8013cd:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  8013d0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8013d4:	79 22                	jns    8013f8 <atomic_readline+0x6b>
				if (c != -E_EOF)
  8013d6:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8013da:	0f 84 ad 00 00 00    	je     80148d <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  8013e0:	83 ec 08             	sub    $0x8,%esp
  8013e3:	ff 75 ec             	pushl  -0x14(%ebp)
  8013e6:	68 eb 2f 80 00       	push   $0x802feb
  8013eb:	e8 c5 f7 ff ff       	call   800bb5 <cprintf>
  8013f0:	83 c4 10             	add    $0x10,%esp
				break;
  8013f3:	e9 95 00 00 00       	jmp    80148d <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  8013f8:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8013fc:	7e 34                	jle    801432 <atomic_readline+0xa5>
  8013fe:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801405:	7f 2b                	jg     801432 <atomic_readline+0xa5>
				if (echoing)
  801407:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80140b:	74 0e                	je     80141b <atomic_readline+0x8e>
					cputchar(c);
  80140d:	83 ec 0c             	sub    $0xc,%esp
  801410:	ff 75 ec             	pushl  -0x14(%ebp)
  801413:	e8 e3 f2 ff ff       	call   8006fb <cputchar>
  801418:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  80141b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80141e:	8d 50 01             	lea    0x1(%eax),%edx
  801421:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801424:	89 c2                	mov    %eax,%edx
  801426:	8b 45 0c             	mov    0xc(%ebp),%eax
  801429:	01 d0                	add    %edx,%eax
  80142b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80142e:	88 10                	mov    %dl,(%eax)
  801430:	eb 56                	jmp    801488 <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  801432:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801436:	75 1f                	jne    801457 <atomic_readline+0xca>
  801438:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80143c:	7e 19                	jle    801457 <atomic_readline+0xca>
				if (echoing)
  80143e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801442:	74 0e                	je     801452 <atomic_readline+0xc5>
					cputchar(c);
  801444:	83 ec 0c             	sub    $0xc,%esp
  801447:	ff 75 ec             	pushl  -0x14(%ebp)
  80144a:	e8 ac f2 ff ff       	call   8006fb <cputchar>
  80144f:	83 c4 10             	add    $0x10,%esp
				i--;
  801452:	ff 4d f4             	decl   -0xc(%ebp)
  801455:	eb 31                	jmp    801488 <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  801457:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  80145b:	74 0a                	je     801467 <atomic_readline+0xda>
  80145d:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801461:	0f 85 61 ff ff ff    	jne    8013c8 <atomic_readline+0x3b>
				if (echoing)
  801467:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80146b:	74 0e                	je     80147b <atomic_readline+0xee>
					cputchar(c);
  80146d:	83 ec 0c             	sub    $0xc,%esp
  801470:	ff 75 ec             	pushl  -0x14(%ebp)
  801473:	e8 83 f2 ff ff       	call   8006fb <cputchar>
  801478:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  80147b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80147e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801481:	01 d0                	add    %edx,%eax
  801483:	c6 00 00             	movb   $0x0,(%eax)
				break;
  801486:	eb 06                	jmp    80148e <atomic_readline+0x101>
			}
		}
  801488:	e9 3b ff ff ff       	jmp    8013c8 <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  80148d:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  80148e:	e8 4f 0a 00 00       	call   801ee2 <sys_unlock_cons>
}
  801493:	90                   	nop
  801494:	c9                   	leave  
  801495:	c3                   	ret    

00801496 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801496:	55                   	push   %ebp
  801497:	89 e5                	mov    %esp,%ebp
  801499:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80149c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014a3:	eb 06                	jmp    8014ab <strlen+0x15>
		n++;
  8014a5:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8014a8:	ff 45 08             	incl   0x8(%ebp)
  8014ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ae:	8a 00                	mov    (%eax),%al
  8014b0:	84 c0                	test   %al,%al
  8014b2:	75 f1                	jne    8014a5 <strlen+0xf>
		n++;
	return n;
  8014b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8014b7:	c9                   	leave  
  8014b8:	c3                   	ret    

008014b9 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8014b9:	55                   	push   %ebp
  8014ba:	89 e5                	mov    %esp,%ebp
  8014bc:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8014bf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014c6:	eb 09                	jmp    8014d1 <strnlen+0x18>
		n++;
  8014c8:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8014cb:	ff 45 08             	incl   0x8(%ebp)
  8014ce:	ff 4d 0c             	decl   0xc(%ebp)
  8014d1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8014d5:	74 09                	je     8014e0 <strnlen+0x27>
  8014d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014da:	8a 00                	mov    (%eax),%al
  8014dc:	84 c0                	test   %al,%al
  8014de:	75 e8                	jne    8014c8 <strnlen+0xf>
		n++;
	return n;
  8014e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8014e3:	c9                   	leave  
  8014e4:	c3                   	ret    

008014e5 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8014e5:	55                   	push   %ebp
  8014e6:	89 e5                	mov    %esp,%ebp
  8014e8:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8014eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ee:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8014f1:	90                   	nop
  8014f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f5:	8d 50 01             	lea    0x1(%eax),%edx
  8014f8:	89 55 08             	mov    %edx,0x8(%ebp)
  8014fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014fe:	8d 4a 01             	lea    0x1(%edx),%ecx
  801501:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801504:	8a 12                	mov    (%edx),%dl
  801506:	88 10                	mov    %dl,(%eax)
  801508:	8a 00                	mov    (%eax),%al
  80150a:	84 c0                	test   %al,%al
  80150c:	75 e4                	jne    8014f2 <strcpy+0xd>
		/* do nothing */;
	return ret;
  80150e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801511:	c9                   	leave  
  801512:	c3                   	ret    

00801513 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801513:	55                   	push   %ebp
  801514:	89 e5                	mov    %esp,%ebp
  801516:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801519:	8b 45 08             	mov    0x8(%ebp),%eax
  80151c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80151f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801526:	eb 1f                	jmp    801547 <strncpy+0x34>
		*dst++ = *src;
  801528:	8b 45 08             	mov    0x8(%ebp),%eax
  80152b:	8d 50 01             	lea    0x1(%eax),%edx
  80152e:	89 55 08             	mov    %edx,0x8(%ebp)
  801531:	8b 55 0c             	mov    0xc(%ebp),%edx
  801534:	8a 12                	mov    (%edx),%dl
  801536:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801538:	8b 45 0c             	mov    0xc(%ebp),%eax
  80153b:	8a 00                	mov    (%eax),%al
  80153d:	84 c0                	test   %al,%al
  80153f:	74 03                	je     801544 <strncpy+0x31>
			src++;
  801541:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801544:	ff 45 fc             	incl   -0x4(%ebp)
  801547:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80154a:	3b 45 10             	cmp    0x10(%ebp),%eax
  80154d:	72 d9                	jb     801528 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80154f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801552:	c9                   	leave  
  801553:	c3                   	ret    

00801554 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801554:	55                   	push   %ebp
  801555:	89 e5                	mov    %esp,%ebp
  801557:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80155a:	8b 45 08             	mov    0x8(%ebp),%eax
  80155d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801560:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801564:	74 30                	je     801596 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801566:	eb 16                	jmp    80157e <strlcpy+0x2a>
			*dst++ = *src++;
  801568:	8b 45 08             	mov    0x8(%ebp),%eax
  80156b:	8d 50 01             	lea    0x1(%eax),%edx
  80156e:	89 55 08             	mov    %edx,0x8(%ebp)
  801571:	8b 55 0c             	mov    0xc(%ebp),%edx
  801574:	8d 4a 01             	lea    0x1(%edx),%ecx
  801577:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80157a:	8a 12                	mov    (%edx),%dl
  80157c:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80157e:	ff 4d 10             	decl   0x10(%ebp)
  801581:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801585:	74 09                	je     801590 <strlcpy+0x3c>
  801587:	8b 45 0c             	mov    0xc(%ebp),%eax
  80158a:	8a 00                	mov    (%eax),%al
  80158c:	84 c0                	test   %al,%al
  80158e:	75 d8                	jne    801568 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801590:	8b 45 08             	mov    0x8(%ebp),%eax
  801593:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801596:	8b 55 08             	mov    0x8(%ebp),%edx
  801599:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80159c:	29 c2                	sub    %eax,%edx
  80159e:	89 d0                	mov    %edx,%eax
}
  8015a0:	c9                   	leave  
  8015a1:	c3                   	ret    

008015a2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8015a2:	55                   	push   %ebp
  8015a3:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8015a5:	eb 06                	jmp    8015ad <strcmp+0xb>
		p++, q++;
  8015a7:	ff 45 08             	incl   0x8(%ebp)
  8015aa:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8015ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b0:	8a 00                	mov    (%eax),%al
  8015b2:	84 c0                	test   %al,%al
  8015b4:	74 0e                	je     8015c4 <strcmp+0x22>
  8015b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b9:	8a 10                	mov    (%eax),%dl
  8015bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015be:	8a 00                	mov    (%eax),%al
  8015c0:	38 c2                	cmp    %al,%dl
  8015c2:	74 e3                	je     8015a7 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8015c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c7:	8a 00                	mov    (%eax),%al
  8015c9:	0f b6 d0             	movzbl %al,%edx
  8015cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015cf:	8a 00                	mov    (%eax),%al
  8015d1:	0f b6 c0             	movzbl %al,%eax
  8015d4:	29 c2                	sub    %eax,%edx
  8015d6:	89 d0                	mov    %edx,%eax
}
  8015d8:	5d                   	pop    %ebp
  8015d9:	c3                   	ret    

008015da <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8015da:	55                   	push   %ebp
  8015db:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8015dd:	eb 09                	jmp    8015e8 <strncmp+0xe>
		n--, p++, q++;
  8015df:	ff 4d 10             	decl   0x10(%ebp)
  8015e2:	ff 45 08             	incl   0x8(%ebp)
  8015e5:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8015e8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015ec:	74 17                	je     801605 <strncmp+0x2b>
  8015ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f1:	8a 00                	mov    (%eax),%al
  8015f3:	84 c0                	test   %al,%al
  8015f5:	74 0e                	je     801605 <strncmp+0x2b>
  8015f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fa:	8a 10                	mov    (%eax),%dl
  8015fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ff:	8a 00                	mov    (%eax),%al
  801601:	38 c2                	cmp    %al,%dl
  801603:	74 da                	je     8015df <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801605:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801609:	75 07                	jne    801612 <strncmp+0x38>
		return 0;
  80160b:	b8 00 00 00 00       	mov    $0x0,%eax
  801610:	eb 14                	jmp    801626 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801612:	8b 45 08             	mov    0x8(%ebp),%eax
  801615:	8a 00                	mov    (%eax),%al
  801617:	0f b6 d0             	movzbl %al,%edx
  80161a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80161d:	8a 00                	mov    (%eax),%al
  80161f:	0f b6 c0             	movzbl %al,%eax
  801622:	29 c2                	sub    %eax,%edx
  801624:	89 d0                	mov    %edx,%eax
}
  801626:	5d                   	pop    %ebp
  801627:	c3                   	ret    

00801628 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801628:	55                   	push   %ebp
  801629:	89 e5                	mov    %esp,%ebp
  80162b:	83 ec 04             	sub    $0x4,%esp
  80162e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801631:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801634:	eb 12                	jmp    801648 <strchr+0x20>
		if (*s == c)
  801636:	8b 45 08             	mov    0x8(%ebp),%eax
  801639:	8a 00                	mov    (%eax),%al
  80163b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80163e:	75 05                	jne    801645 <strchr+0x1d>
			return (char *) s;
  801640:	8b 45 08             	mov    0x8(%ebp),%eax
  801643:	eb 11                	jmp    801656 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801645:	ff 45 08             	incl   0x8(%ebp)
  801648:	8b 45 08             	mov    0x8(%ebp),%eax
  80164b:	8a 00                	mov    (%eax),%al
  80164d:	84 c0                	test   %al,%al
  80164f:	75 e5                	jne    801636 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801651:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801656:	c9                   	leave  
  801657:	c3                   	ret    

00801658 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801658:	55                   	push   %ebp
  801659:	89 e5                	mov    %esp,%ebp
  80165b:	83 ec 04             	sub    $0x4,%esp
  80165e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801661:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801664:	eb 0d                	jmp    801673 <strfind+0x1b>
		if (*s == c)
  801666:	8b 45 08             	mov    0x8(%ebp),%eax
  801669:	8a 00                	mov    (%eax),%al
  80166b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80166e:	74 0e                	je     80167e <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801670:	ff 45 08             	incl   0x8(%ebp)
  801673:	8b 45 08             	mov    0x8(%ebp),%eax
  801676:	8a 00                	mov    (%eax),%al
  801678:	84 c0                	test   %al,%al
  80167a:	75 ea                	jne    801666 <strfind+0xe>
  80167c:	eb 01                	jmp    80167f <strfind+0x27>
		if (*s == c)
			break;
  80167e:	90                   	nop
	return (char *) s;
  80167f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801682:	c9                   	leave  
  801683:	c3                   	ret    

00801684 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801684:	55                   	push   %ebp
  801685:	89 e5                	mov    %esp,%ebp
  801687:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  80168a:	8b 45 08             	mov    0x8(%ebp),%eax
  80168d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801690:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801694:	76 63                	jbe    8016f9 <memset+0x75>
		uint64 data_block = c;
  801696:	8b 45 0c             	mov    0xc(%ebp),%eax
  801699:	99                   	cltd   
  80169a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80169d:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  8016a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016a6:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  8016aa:	c1 e0 08             	shl    $0x8,%eax
  8016ad:	09 45 f0             	or     %eax,-0x10(%ebp)
  8016b0:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  8016b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016b9:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  8016bd:	c1 e0 10             	shl    $0x10,%eax
  8016c0:	09 45 f0             	or     %eax,-0x10(%ebp)
  8016c3:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  8016c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016cc:	89 c2                	mov    %eax,%edx
  8016ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8016d3:	09 45 f0             	or     %eax,-0x10(%ebp)
  8016d6:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  8016d9:	eb 18                	jmp    8016f3 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  8016db:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8016de:	8d 41 08             	lea    0x8(%ecx),%eax
  8016e1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8016e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016ea:	89 01                	mov    %eax,(%ecx)
  8016ec:	89 51 04             	mov    %edx,0x4(%ecx)
  8016ef:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  8016f3:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8016f7:	77 e2                	ja     8016db <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8016f9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016fd:	74 23                	je     801722 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8016ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801702:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801705:	eb 0e                	jmp    801715 <memset+0x91>
			*p8++ = (uint8)c;
  801707:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80170a:	8d 50 01             	lea    0x1(%eax),%edx
  80170d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801710:	8b 55 0c             	mov    0xc(%ebp),%edx
  801713:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801715:	8b 45 10             	mov    0x10(%ebp),%eax
  801718:	8d 50 ff             	lea    -0x1(%eax),%edx
  80171b:	89 55 10             	mov    %edx,0x10(%ebp)
  80171e:	85 c0                	test   %eax,%eax
  801720:	75 e5                	jne    801707 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801722:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801725:	c9                   	leave  
  801726:	c3                   	ret    

00801727 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801727:	55                   	push   %ebp
  801728:	89 e5                	mov    %esp,%ebp
  80172a:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  80172d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801730:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801733:	8b 45 08             	mov    0x8(%ebp),%eax
  801736:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801739:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80173d:	76 24                	jbe    801763 <memcpy+0x3c>
		while(n >= 8){
  80173f:	eb 1c                	jmp    80175d <memcpy+0x36>
			*d64 = *s64;
  801741:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801744:	8b 50 04             	mov    0x4(%eax),%edx
  801747:	8b 00                	mov    (%eax),%eax
  801749:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80174c:	89 01                	mov    %eax,(%ecx)
  80174e:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801751:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801755:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801759:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  80175d:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801761:	77 de                	ja     801741 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801763:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801767:	74 31                	je     80179a <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801769:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80176c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  80176f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801772:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801775:	eb 16                	jmp    80178d <memcpy+0x66>
			*d8++ = *s8++;
  801777:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80177a:	8d 50 01             	lea    0x1(%eax),%edx
  80177d:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801780:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801783:	8d 4a 01             	lea    0x1(%edx),%ecx
  801786:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801789:	8a 12                	mov    (%edx),%dl
  80178b:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  80178d:	8b 45 10             	mov    0x10(%ebp),%eax
  801790:	8d 50 ff             	lea    -0x1(%eax),%edx
  801793:	89 55 10             	mov    %edx,0x10(%ebp)
  801796:	85 c0                	test   %eax,%eax
  801798:	75 dd                	jne    801777 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  80179a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80179d:	c9                   	leave  
  80179e:	c3                   	ret    

0080179f <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80179f:	55                   	push   %ebp
  8017a0:	89 e5                	mov    %esp,%ebp
  8017a2:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8017a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017a8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8017ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ae:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8017b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017b4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8017b7:	73 50                	jae    801809 <memmove+0x6a>
  8017b9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8017bf:	01 d0                	add    %edx,%eax
  8017c1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8017c4:	76 43                	jbe    801809 <memmove+0x6a>
		s += n;
  8017c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8017c9:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8017cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8017cf:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8017d2:	eb 10                	jmp    8017e4 <memmove+0x45>
			*--d = *--s;
  8017d4:	ff 4d f8             	decl   -0x8(%ebp)
  8017d7:	ff 4d fc             	decl   -0x4(%ebp)
  8017da:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017dd:	8a 10                	mov    (%eax),%dl
  8017df:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017e2:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8017e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8017e7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8017ea:	89 55 10             	mov    %edx,0x10(%ebp)
  8017ed:	85 c0                	test   %eax,%eax
  8017ef:	75 e3                	jne    8017d4 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8017f1:	eb 23                	jmp    801816 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8017f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017f6:	8d 50 01             	lea    0x1(%eax),%edx
  8017f9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8017fc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017ff:	8d 4a 01             	lea    0x1(%edx),%ecx
  801802:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801805:	8a 12                	mov    (%edx),%dl
  801807:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801809:	8b 45 10             	mov    0x10(%ebp),%eax
  80180c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80180f:	89 55 10             	mov    %edx,0x10(%ebp)
  801812:	85 c0                	test   %eax,%eax
  801814:	75 dd                	jne    8017f3 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801816:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801819:	c9                   	leave  
  80181a:	c3                   	ret    

0080181b <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80181b:	55                   	push   %ebp
  80181c:	89 e5                	mov    %esp,%ebp
  80181e:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801821:	8b 45 08             	mov    0x8(%ebp),%eax
  801824:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801827:	8b 45 0c             	mov    0xc(%ebp),%eax
  80182a:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80182d:	eb 2a                	jmp    801859 <memcmp+0x3e>
		if (*s1 != *s2)
  80182f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801832:	8a 10                	mov    (%eax),%dl
  801834:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801837:	8a 00                	mov    (%eax),%al
  801839:	38 c2                	cmp    %al,%dl
  80183b:	74 16                	je     801853 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80183d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801840:	8a 00                	mov    (%eax),%al
  801842:	0f b6 d0             	movzbl %al,%edx
  801845:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801848:	8a 00                	mov    (%eax),%al
  80184a:	0f b6 c0             	movzbl %al,%eax
  80184d:	29 c2                	sub    %eax,%edx
  80184f:	89 d0                	mov    %edx,%eax
  801851:	eb 18                	jmp    80186b <memcmp+0x50>
		s1++, s2++;
  801853:	ff 45 fc             	incl   -0x4(%ebp)
  801856:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801859:	8b 45 10             	mov    0x10(%ebp),%eax
  80185c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80185f:	89 55 10             	mov    %edx,0x10(%ebp)
  801862:	85 c0                	test   %eax,%eax
  801864:	75 c9                	jne    80182f <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801866:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80186b:	c9                   	leave  
  80186c:	c3                   	ret    

0080186d <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80186d:	55                   	push   %ebp
  80186e:	89 e5                	mov    %esp,%ebp
  801870:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801873:	8b 55 08             	mov    0x8(%ebp),%edx
  801876:	8b 45 10             	mov    0x10(%ebp),%eax
  801879:	01 d0                	add    %edx,%eax
  80187b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80187e:	eb 15                	jmp    801895 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801880:	8b 45 08             	mov    0x8(%ebp),%eax
  801883:	8a 00                	mov    (%eax),%al
  801885:	0f b6 d0             	movzbl %al,%edx
  801888:	8b 45 0c             	mov    0xc(%ebp),%eax
  80188b:	0f b6 c0             	movzbl %al,%eax
  80188e:	39 c2                	cmp    %eax,%edx
  801890:	74 0d                	je     80189f <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801892:	ff 45 08             	incl   0x8(%ebp)
  801895:	8b 45 08             	mov    0x8(%ebp),%eax
  801898:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80189b:	72 e3                	jb     801880 <memfind+0x13>
  80189d:	eb 01                	jmp    8018a0 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80189f:	90                   	nop
	return (void *) s;
  8018a0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8018a3:	c9                   	leave  
  8018a4:	c3                   	ret    

008018a5 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8018a5:	55                   	push   %ebp
  8018a6:	89 e5                	mov    %esp,%ebp
  8018a8:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8018ab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8018b2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8018b9:	eb 03                	jmp    8018be <strtol+0x19>
		s++;
  8018bb:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8018be:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c1:	8a 00                	mov    (%eax),%al
  8018c3:	3c 20                	cmp    $0x20,%al
  8018c5:	74 f4                	je     8018bb <strtol+0x16>
  8018c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ca:	8a 00                	mov    (%eax),%al
  8018cc:	3c 09                	cmp    $0x9,%al
  8018ce:	74 eb                	je     8018bb <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8018d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d3:	8a 00                	mov    (%eax),%al
  8018d5:	3c 2b                	cmp    $0x2b,%al
  8018d7:	75 05                	jne    8018de <strtol+0x39>
		s++;
  8018d9:	ff 45 08             	incl   0x8(%ebp)
  8018dc:	eb 13                	jmp    8018f1 <strtol+0x4c>
	else if (*s == '-')
  8018de:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e1:	8a 00                	mov    (%eax),%al
  8018e3:	3c 2d                	cmp    $0x2d,%al
  8018e5:	75 0a                	jne    8018f1 <strtol+0x4c>
		s++, neg = 1;
  8018e7:	ff 45 08             	incl   0x8(%ebp)
  8018ea:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8018f1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8018f5:	74 06                	je     8018fd <strtol+0x58>
  8018f7:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8018fb:	75 20                	jne    80191d <strtol+0x78>
  8018fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801900:	8a 00                	mov    (%eax),%al
  801902:	3c 30                	cmp    $0x30,%al
  801904:	75 17                	jne    80191d <strtol+0x78>
  801906:	8b 45 08             	mov    0x8(%ebp),%eax
  801909:	40                   	inc    %eax
  80190a:	8a 00                	mov    (%eax),%al
  80190c:	3c 78                	cmp    $0x78,%al
  80190e:	75 0d                	jne    80191d <strtol+0x78>
		s += 2, base = 16;
  801910:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801914:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80191b:	eb 28                	jmp    801945 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80191d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801921:	75 15                	jne    801938 <strtol+0x93>
  801923:	8b 45 08             	mov    0x8(%ebp),%eax
  801926:	8a 00                	mov    (%eax),%al
  801928:	3c 30                	cmp    $0x30,%al
  80192a:	75 0c                	jne    801938 <strtol+0x93>
		s++, base = 8;
  80192c:	ff 45 08             	incl   0x8(%ebp)
  80192f:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801936:	eb 0d                	jmp    801945 <strtol+0xa0>
	else if (base == 0)
  801938:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80193c:	75 07                	jne    801945 <strtol+0xa0>
		base = 10;
  80193e:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801945:	8b 45 08             	mov    0x8(%ebp),%eax
  801948:	8a 00                	mov    (%eax),%al
  80194a:	3c 2f                	cmp    $0x2f,%al
  80194c:	7e 19                	jle    801967 <strtol+0xc2>
  80194e:	8b 45 08             	mov    0x8(%ebp),%eax
  801951:	8a 00                	mov    (%eax),%al
  801953:	3c 39                	cmp    $0x39,%al
  801955:	7f 10                	jg     801967 <strtol+0xc2>
			dig = *s - '0';
  801957:	8b 45 08             	mov    0x8(%ebp),%eax
  80195a:	8a 00                	mov    (%eax),%al
  80195c:	0f be c0             	movsbl %al,%eax
  80195f:	83 e8 30             	sub    $0x30,%eax
  801962:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801965:	eb 42                	jmp    8019a9 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801967:	8b 45 08             	mov    0x8(%ebp),%eax
  80196a:	8a 00                	mov    (%eax),%al
  80196c:	3c 60                	cmp    $0x60,%al
  80196e:	7e 19                	jle    801989 <strtol+0xe4>
  801970:	8b 45 08             	mov    0x8(%ebp),%eax
  801973:	8a 00                	mov    (%eax),%al
  801975:	3c 7a                	cmp    $0x7a,%al
  801977:	7f 10                	jg     801989 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801979:	8b 45 08             	mov    0x8(%ebp),%eax
  80197c:	8a 00                	mov    (%eax),%al
  80197e:	0f be c0             	movsbl %al,%eax
  801981:	83 e8 57             	sub    $0x57,%eax
  801984:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801987:	eb 20                	jmp    8019a9 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801989:	8b 45 08             	mov    0x8(%ebp),%eax
  80198c:	8a 00                	mov    (%eax),%al
  80198e:	3c 40                	cmp    $0x40,%al
  801990:	7e 39                	jle    8019cb <strtol+0x126>
  801992:	8b 45 08             	mov    0x8(%ebp),%eax
  801995:	8a 00                	mov    (%eax),%al
  801997:	3c 5a                	cmp    $0x5a,%al
  801999:	7f 30                	jg     8019cb <strtol+0x126>
			dig = *s - 'A' + 10;
  80199b:	8b 45 08             	mov    0x8(%ebp),%eax
  80199e:	8a 00                	mov    (%eax),%al
  8019a0:	0f be c0             	movsbl %al,%eax
  8019a3:	83 e8 37             	sub    $0x37,%eax
  8019a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8019a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019ac:	3b 45 10             	cmp    0x10(%ebp),%eax
  8019af:	7d 19                	jge    8019ca <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8019b1:	ff 45 08             	incl   0x8(%ebp)
  8019b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019b7:	0f af 45 10          	imul   0x10(%ebp),%eax
  8019bb:	89 c2                	mov    %eax,%edx
  8019bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019c0:	01 d0                	add    %edx,%eax
  8019c2:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8019c5:	e9 7b ff ff ff       	jmp    801945 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8019ca:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8019cb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8019cf:	74 08                	je     8019d9 <strtol+0x134>
		*endptr = (char *) s;
  8019d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019d4:	8b 55 08             	mov    0x8(%ebp),%edx
  8019d7:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8019d9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8019dd:	74 07                	je     8019e6 <strtol+0x141>
  8019df:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019e2:	f7 d8                	neg    %eax
  8019e4:	eb 03                	jmp    8019e9 <strtol+0x144>
  8019e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8019e9:	c9                   	leave  
  8019ea:	c3                   	ret    

008019eb <ltostr>:

void
ltostr(long value, char *str)
{
  8019eb:	55                   	push   %ebp
  8019ec:	89 e5                	mov    %esp,%ebp
  8019ee:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8019f1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8019f8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8019ff:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a03:	79 13                	jns    801a18 <ltostr+0x2d>
	{
		neg = 1;
  801a05:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801a0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a0f:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801a12:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801a15:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801a18:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801a20:	99                   	cltd   
  801a21:	f7 f9                	idiv   %ecx
  801a23:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801a26:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a29:	8d 50 01             	lea    0x1(%eax),%edx
  801a2c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801a2f:	89 c2                	mov    %eax,%edx
  801a31:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a34:	01 d0                	add    %edx,%eax
  801a36:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801a39:	83 c2 30             	add    $0x30,%edx
  801a3c:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801a3e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a41:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801a46:	f7 e9                	imul   %ecx
  801a48:	c1 fa 02             	sar    $0x2,%edx
  801a4b:	89 c8                	mov    %ecx,%eax
  801a4d:	c1 f8 1f             	sar    $0x1f,%eax
  801a50:	29 c2                	sub    %eax,%edx
  801a52:	89 d0                	mov    %edx,%eax
  801a54:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801a57:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a5b:	75 bb                	jne    801a18 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801a5d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801a64:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a67:	48                   	dec    %eax
  801a68:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801a6b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801a6f:	74 3d                	je     801aae <ltostr+0xc3>
		start = 1 ;
  801a71:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801a78:	eb 34                	jmp    801aae <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801a7a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a80:	01 d0                	add    %edx,%eax
  801a82:	8a 00                	mov    (%eax),%al
  801a84:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801a87:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a8d:	01 c2                	add    %eax,%edx
  801a8f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801a92:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a95:	01 c8                	add    %ecx,%eax
  801a97:	8a 00                	mov    (%eax),%al
  801a99:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801a9b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aa1:	01 c2                	add    %eax,%edx
  801aa3:	8a 45 eb             	mov    -0x15(%ebp),%al
  801aa6:	88 02                	mov    %al,(%edx)
		start++ ;
  801aa8:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801aab:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801aae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ab1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801ab4:	7c c4                	jl     801a7a <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801ab6:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801ab9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801abc:	01 d0                	add    %edx,%eax
  801abe:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801ac1:	90                   	nop
  801ac2:	c9                   	leave  
  801ac3:	c3                   	ret    

00801ac4 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801ac4:	55                   	push   %ebp
  801ac5:	89 e5                	mov    %esp,%ebp
  801ac7:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801aca:	ff 75 08             	pushl  0x8(%ebp)
  801acd:	e8 c4 f9 ff ff       	call   801496 <strlen>
  801ad2:	83 c4 04             	add    $0x4,%esp
  801ad5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801ad8:	ff 75 0c             	pushl  0xc(%ebp)
  801adb:	e8 b6 f9 ff ff       	call   801496 <strlen>
  801ae0:	83 c4 04             	add    $0x4,%esp
  801ae3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801ae6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801aed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801af4:	eb 17                	jmp    801b0d <strcconcat+0x49>
		final[s] = str1[s] ;
  801af6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801af9:	8b 45 10             	mov    0x10(%ebp),%eax
  801afc:	01 c2                	add    %eax,%edx
  801afe:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801b01:	8b 45 08             	mov    0x8(%ebp),%eax
  801b04:	01 c8                	add    %ecx,%eax
  801b06:	8a 00                	mov    (%eax),%al
  801b08:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801b0a:	ff 45 fc             	incl   -0x4(%ebp)
  801b0d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b10:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801b13:	7c e1                	jl     801af6 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801b15:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801b1c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801b23:	eb 1f                	jmp    801b44 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801b25:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b28:	8d 50 01             	lea    0x1(%eax),%edx
  801b2b:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801b2e:	89 c2                	mov    %eax,%edx
  801b30:	8b 45 10             	mov    0x10(%ebp),%eax
  801b33:	01 c2                	add    %eax,%edx
  801b35:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801b38:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b3b:	01 c8                	add    %ecx,%eax
  801b3d:	8a 00                	mov    (%eax),%al
  801b3f:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801b41:	ff 45 f8             	incl   -0x8(%ebp)
  801b44:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b47:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801b4a:	7c d9                	jl     801b25 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801b4c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b4f:	8b 45 10             	mov    0x10(%ebp),%eax
  801b52:	01 d0                	add    %edx,%eax
  801b54:	c6 00 00             	movb   $0x0,(%eax)
}
  801b57:	90                   	nop
  801b58:	c9                   	leave  
  801b59:	c3                   	ret    

00801b5a <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801b5a:	55                   	push   %ebp
  801b5b:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801b5d:	8b 45 14             	mov    0x14(%ebp),%eax
  801b60:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801b66:	8b 45 14             	mov    0x14(%ebp),%eax
  801b69:	8b 00                	mov    (%eax),%eax
  801b6b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b72:	8b 45 10             	mov    0x10(%ebp),%eax
  801b75:	01 d0                	add    %edx,%eax
  801b77:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801b7d:	eb 0c                	jmp    801b8b <strsplit+0x31>
			*string++ = 0;
  801b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b82:	8d 50 01             	lea    0x1(%eax),%edx
  801b85:	89 55 08             	mov    %edx,0x8(%ebp)
  801b88:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8e:	8a 00                	mov    (%eax),%al
  801b90:	84 c0                	test   %al,%al
  801b92:	74 18                	je     801bac <strsplit+0x52>
  801b94:	8b 45 08             	mov    0x8(%ebp),%eax
  801b97:	8a 00                	mov    (%eax),%al
  801b99:	0f be c0             	movsbl %al,%eax
  801b9c:	50                   	push   %eax
  801b9d:	ff 75 0c             	pushl  0xc(%ebp)
  801ba0:	e8 83 fa ff ff       	call   801628 <strchr>
  801ba5:	83 c4 08             	add    $0x8,%esp
  801ba8:	85 c0                	test   %eax,%eax
  801baa:	75 d3                	jne    801b7f <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801bac:	8b 45 08             	mov    0x8(%ebp),%eax
  801baf:	8a 00                	mov    (%eax),%al
  801bb1:	84 c0                	test   %al,%al
  801bb3:	74 5a                	je     801c0f <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801bb5:	8b 45 14             	mov    0x14(%ebp),%eax
  801bb8:	8b 00                	mov    (%eax),%eax
  801bba:	83 f8 0f             	cmp    $0xf,%eax
  801bbd:	75 07                	jne    801bc6 <strsplit+0x6c>
		{
			return 0;
  801bbf:	b8 00 00 00 00       	mov    $0x0,%eax
  801bc4:	eb 66                	jmp    801c2c <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801bc6:	8b 45 14             	mov    0x14(%ebp),%eax
  801bc9:	8b 00                	mov    (%eax),%eax
  801bcb:	8d 48 01             	lea    0x1(%eax),%ecx
  801bce:	8b 55 14             	mov    0x14(%ebp),%edx
  801bd1:	89 0a                	mov    %ecx,(%edx)
  801bd3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801bda:	8b 45 10             	mov    0x10(%ebp),%eax
  801bdd:	01 c2                	add    %eax,%edx
  801bdf:	8b 45 08             	mov    0x8(%ebp),%eax
  801be2:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801be4:	eb 03                	jmp    801be9 <strsplit+0x8f>
			string++;
  801be6:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801be9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bec:	8a 00                	mov    (%eax),%al
  801bee:	84 c0                	test   %al,%al
  801bf0:	74 8b                	je     801b7d <strsplit+0x23>
  801bf2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf5:	8a 00                	mov    (%eax),%al
  801bf7:	0f be c0             	movsbl %al,%eax
  801bfa:	50                   	push   %eax
  801bfb:	ff 75 0c             	pushl  0xc(%ebp)
  801bfe:	e8 25 fa ff ff       	call   801628 <strchr>
  801c03:	83 c4 08             	add    $0x8,%esp
  801c06:	85 c0                	test   %eax,%eax
  801c08:	74 dc                	je     801be6 <strsplit+0x8c>
			string++;
	}
  801c0a:	e9 6e ff ff ff       	jmp    801b7d <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801c0f:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801c10:	8b 45 14             	mov    0x14(%ebp),%eax
  801c13:	8b 00                	mov    (%eax),%eax
  801c15:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c1c:	8b 45 10             	mov    0x10(%ebp),%eax
  801c1f:	01 d0                	add    %edx,%eax
  801c21:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801c27:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801c2c:	c9                   	leave  
  801c2d:	c3                   	ret    

00801c2e <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801c2e:	55                   	push   %ebp
  801c2f:	89 e5                	mov    %esp,%ebp
  801c31:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801c34:	8b 45 08             	mov    0x8(%ebp),%eax
  801c37:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801c3a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801c41:	eb 4a                	jmp    801c8d <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801c43:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c46:	8b 45 08             	mov    0x8(%ebp),%eax
  801c49:	01 c2                	add    %eax,%edx
  801c4b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801c4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c51:	01 c8                	add    %ecx,%eax
  801c53:	8a 00                	mov    (%eax),%al
  801c55:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801c57:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c5d:	01 d0                	add    %edx,%eax
  801c5f:	8a 00                	mov    (%eax),%al
  801c61:	3c 40                	cmp    $0x40,%al
  801c63:	7e 25                	jle    801c8a <str2lower+0x5c>
  801c65:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c68:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c6b:	01 d0                	add    %edx,%eax
  801c6d:	8a 00                	mov    (%eax),%al
  801c6f:	3c 5a                	cmp    $0x5a,%al
  801c71:	7f 17                	jg     801c8a <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801c73:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c76:	8b 45 08             	mov    0x8(%ebp),%eax
  801c79:	01 d0                	add    %edx,%eax
  801c7b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801c7e:	8b 55 08             	mov    0x8(%ebp),%edx
  801c81:	01 ca                	add    %ecx,%edx
  801c83:	8a 12                	mov    (%edx),%dl
  801c85:	83 c2 20             	add    $0x20,%edx
  801c88:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801c8a:	ff 45 fc             	incl   -0x4(%ebp)
  801c8d:	ff 75 0c             	pushl  0xc(%ebp)
  801c90:	e8 01 f8 ff ff       	call   801496 <strlen>
  801c95:	83 c4 04             	add    $0x4,%esp
  801c98:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801c9b:	7f a6                	jg     801c43 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801c9d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801ca0:	c9                   	leave  
  801ca1:	c3                   	ret    

00801ca2 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801ca2:	55                   	push   %ebp
  801ca3:	89 e5                	mov    %esp,%ebp
  801ca5:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801ca8:	a1 08 40 80 00       	mov    0x804008,%eax
  801cad:	85 c0                	test   %eax,%eax
  801caf:	74 42                	je     801cf3 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801cb1:	83 ec 08             	sub    $0x8,%esp
  801cb4:	68 00 00 00 82       	push   $0x82000000
  801cb9:	68 00 00 00 80       	push   $0x80000000
  801cbe:	e8 8c 07 00 00       	call   80244f <initialize_dynamic_allocator>
  801cc3:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801cc6:	e8 e7 05 00 00       	call   8022b2 <sys_get_uheap_strategy>
  801ccb:	a3 60 c0 81 00       	mov    %eax,0x81c060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801cd0:	a1 40 40 80 00       	mov    0x804040,%eax
  801cd5:	05 00 10 00 00       	add    $0x1000,%eax
  801cda:	a3 10 c1 81 00       	mov    %eax,0x81c110
		uheapPageAllocBreak = uheapPageAllocStart;
  801cdf:	a1 10 c1 81 00       	mov    0x81c110,%eax
  801ce4:	a3 68 c0 81 00       	mov    %eax,0x81c068

		__firstTimeFlag = 0;
  801ce9:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  801cf0:	00 00 00 
	}
}
  801cf3:	90                   	nop
  801cf4:	c9                   	leave  
  801cf5:	c3                   	ret    

00801cf6 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801cf6:	55                   	push   %ebp
  801cf7:	89 e5                	mov    %esp,%ebp
  801cf9:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  801cff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d05:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d0a:	83 ec 08             	sub    $0x8,%esp
  801d0d:	68 06 04 00 00       	push   $0x406
  801d12:	50                   	push   %eax
  801d13:	e8 e4 01 00 00       	call   801efc <__sys_allocate_page>
  801d18:	83 c4 10             	add    $0x10,%esp
  801d1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801d1e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d22:	79 14                	jns    801d38 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801d24:	83 ec 04             	sub    $0x4,%esp
  801d27:	68 fc 2f 80 00       	push   $0x802ffc
  801d2c:	6a 1f                	push   $0x1f
  801d2e:	68 38 30 80 00       	push   $0x803038
  801d33:	e8 af eb ff ff       	call   8008e7 <_panic>
	return 0;
  801d38:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d3d:	c9                   	leave  
  801d3e:	c3                   	ret    

00801d3f <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801d3f:	55                   	push   %ebp
  801d40:	89 e5                	mov    %esp,%ebp
  801d42:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801d45:	8b 45 08             	mov    0x8(%ebp),%eax
  801d48:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d4e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d53:	83 ec 0c             	sub    $0xc,%esp
  801d56:	50                   	push   %eax
  801d57:	e8 e7 01 00 00       	call   801f43 <__sys_unmap_frame>
  801d5c:	83 c4 10             	add    $0x10,%esp
  801d5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801d62:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d66:	79 14                	jns    801d7c <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801d68:	83 ec 04             	sub    $0x4,%esp
  801d6b:	68 44 30 80 00       	push   $0x803044
  801d70:	6a 2a                	push   $0x2a
  801d72:	68 38 30 80 00       	push   $0x803038
  801d77:	e8 6b eb ff ff       	call   8008e7 <_panic>
}
  801d7c:	90                   	nop
  801d7d:	c9                   	leave  
  801d7e:	c3                   	ret    

00801d7f <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801d7f:	55                   	push   %ebp
  801d80:	89 e5                	mov    %esp,%ebp
  801d82:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801d85:	e8 18 ff ff ff       	call   801ca2 <uheap_init>
	if (size == 0) return NULL ;
  801d8a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d8e:	75 07                	jne    801d97 <malloc+0x18>
  801d90:	b8 00 00 00 00       	mov    $0x0,%eax
  801d95:	eb 14                	jmp    801dab <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  801d97:	83 ec 04             	sub    $0x4,%esp
  801d9a:	68 84 30 80 00       	push   $0x803084
  801d9f:	6a 3e                	push   $0x3e
  801da1:	68 38 30 80 00       	push   $0x803038
  801da6:	e8 3c eb ff ff       	call   8008e7 <_panic>
}
  801dab:	c9                   	leave  
  801dac:	c3                   	ret    

00801dad <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801dad:	55                   	push   %ebp
  801dae:	89 e5                	mov    %esp,%ebp
  801db0:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  801db3:	83 ec 04             	sub    $0x4,%esp
  801db6:	68 ac 30 80 00       	push   $0x8030ac
  801dbb:	6a 49                	push   $0x49
  801dbd:	68 38 30 80 00       	push   $0x803038
  801dc2:	e8 20 eb ff ff       	call   8008e7 <_panic>

00801dc7 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801dc7:	55                   	push   %ebp
  801dc8:	89 e5                	mov    %esp,%ebp
  801dca:	83 ec 18             	sub    $0x18,%esp
  801dcd:	8b 45 10             	mov    0x10(%ebp),%eax
  801dd0:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801dd3:	e8 ca fe ff ff       	call   801ca2 <uheap_init>
	if (size == 0) return NULL ;
  801dd8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ddc:	75 07                	jne    801de5 <smalloc+0x1e>
  801dde:	b8 00 00 00 00       	mov    $0x0,%eax
  801de3:	eb 14                	jmp    801df9 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  801de5:	83 ec 04             	sub    $0x4,%esp
  801de8:	68 d0 30 80 00       	push   $0x8030d0
  801ded:	6a 5a                	push   $0x5a
  801def:	68 38 30 80 00       	push   $0x803038
  801df4:	e8 ee ea ff ff       	call   8008e7 <_panic>
}
  801df9:	c9                   	leave  
  801dfa:	c3                   	ret    

00801dfb <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801dfb:	55                   	push   %ebp
  801dfc:	89 e5                	mov    %esp,%ebp
  801dfe:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801e01:	e8 9c fe ff ff       	call   801ca2 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  801e06:	83 ec 04             	sub    $0x4,%esp
  801e09:	68 f8 30 80 00       	push   $0x8030f8
  801e0e:	6a 6a                	push   $0x6a
  801e10:	68 38 30 80 00       	push   $0x803038
  801e15:	e8 cd ea ff ff       	call   8008e7 <_panic>

00801e1a <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801e1a:	55                   	push   %ebp
  801e1b:	89 e5                	mov    %esp,%ebp
  801e1d:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801e20:	e8 7d fe ff ff       	call   801ca2 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  801e25:	83 ec 04             	sub    $0x4,%esp
  801e28:	68 1c 31 80 00       	push   $0x80311c
  801e2d:	68 88 00 00 00       	push   $0x88
  801e32:	68 38 30 80 00       	push   $0x803038
  801e37:	e8 ab ea ff ff       	call   8008e7 <_panic>

00801e3c <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  801e3c:	55                   	push   %ebp
  801e3d:	89 e5                	mov    %esp,%ebp
  801e3f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  801e42:	83 ec 04             	sub    $0x4,%esp
  801e45:	68 44 31 80 00       	push   $0x803144
  801e4a:	68 9b 00 00 00       	push   $0x9b
  801e4f:	68 38 30 80 00       	push   $0x803038
  801e54:	e8 8e ea ff ff       	call   8008e7 <_panic>

00801e59 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801e59:	55                   	push   %ebp
  801e5a:	89 e5                	mov    %esp,%ebp
  801e5c:	57                   	push   %edi
  801e5d:	56                   	push   %esi
  801e5e:	53                   	push   %ebx
  801e5f:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801e62:	8b 45 08             	mov    0x8(%ebp),%eax
  801e65:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e68:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e6b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e6e:	8b 7d 18             	mov    0x18(%ebp),%edi
  801e71:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801e74:	cd 30                	int    $0x30
  801e76:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801e79:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801e7c:	83 c4 10             	add    $0x10,%esp
  801e7f:	5b                   	pop    %ebx
  801e80:	5e                   	pop    %esi
  801e81:	5f                   	pop    %edi
  801e82:	5d                   	pop    %ebp
  801e83:	c3                   	ret    

00801e84 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801e84:	55                   	push   %ebp
  801e85:	89 e5                	mov    %esp,%ebp
  801e87:	83 ec 04             	sub    $0x4,%esp
  801e8a:	8b 45 10             	mov    0x10(%ebp),%eax
  801e8d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801e90:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801e93:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801e97:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9a:	6a 00                	push   $0x0
  801e9c:	51                   	push   %ecx
  801e9d:	52                   	push   %edx
  801e9e:	ff 75 0c             	pushl  0xc(%ebp)
  801ea1:	50                   	push   %eax
  801ea2:	6a 00                	push   $0x0
  801ea4:	e8 b0 ff ff ff       	call   801e59 <syscall>
  801ea9:	83 c4 18             	add    $0x18,%esp
}
  801eac:	90                   	nop
  801ead:	c9                   	leave  
  801eae:	c3                   	ret    

00801eaf <sys_cgetc>:

int
sys_cgetc(void)
{
  801eaf:	55                   	push   %ebp
  801eb0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801eb2:	6a 00                	push   $0x0
  801eb4:	6a 00                	push   $0x0
  801eb6:	6a 00                	push   $0x0
  801eb8:	6a 00                	push   $0x0
  801eba:	6a 00                	push   $0x0
  801ebc:	6a 02                	push   $0x2
  801ebe:	e8 96 ff ff ff       	call   801e59 <syscall>
  801ec3:	83 c4 18             	add    $0x18,%esp
}
  801ec6:	c9                   	leave  
  801ec7:	c3                   	ret    

00801ec8 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801ec8:	55                   	push   %ebp
  801ec9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801ecb:	6a 00                	push   $0x0
  801ecd:	6a 00                	push   $0x0
  801ecf:	6a 00                	push   $0x0
  801ed1:	6a 00                	push   $0x0
  801ed3:	6a 00                	push   $0x0
  801ed5:	6a 03                	push   $0x3
  801ed7:	e8 7d ff ff ff       	call   801e59 <syscall>
  801edc:	83 c4 18             	add    $0x18,%esp
}
  801edf:	90                   	nop
  801ee0:	c9                   	leave  
  801ee1:	c3                   	ret    

00801ee2 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801ee2:	55                   	push   %ebp
  801ee3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801ee5:	6a 00                	push   $0x0
  801ee7:	6a 00                	push   $0x0
  801ee9:	6a 00                	push   $0x0
  801eeb:	6a 00                	push   $0x0
  801eed:	6a 00                	push   $0x0
  801eef:	6a 04                	push   $0x4
  801ef1:	e8 63 ff ff ff       	call   801e59 <syscall>
  801ef6:	83 c4 18             	add    $0x18,%esp
}
  801ef9:	90                   	nop
  801efa:	c9                   	leave  
  801efb:	c3                   	ret    

00801efc <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801efc:	55                   	push   %ebp
  801efd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801eff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f02:	8b 45 08             	mov    0x8(%ebp),%eax
  801f05:	6a 00                	push   $0x0
  801f07:	6a 00                	push   $0x0
  801f09:	6a 00                	push   $0x0
  801f0b:	52                   	push   %edx
  801f0c:	50                   	push   %eax
  801f0d:	6a 08                	push   $0x8
  801f0f:	e8 45 ff ff ff       	call   801e59 <syscall>
  801f14:	83 c4 18             	add    $0x18,%esp
}
  801f17:	c9                   	leave  
  801f18:	c3                   	ret    

00801f19 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801f19:	55                   	push   %ebp
  801f1a:	89 e5                	mov    %esp,%ebp
  801f1c:	56                   	push   %esi
  801f1d:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801f1e:	8b 75 18             	mov    0x18(%ebp),%esi
  801f21:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f24:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f27:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2d:	56                   	push   %esi
  801f2e:	53                   	push   %ebx
  801f2f:	51                   	push   %ecx
  801f30:	52                   	push   %edx
  801f31:	50                   	push   %eax
  801f32:	6a 09                	push   $0x9
  801f34:	e8 20 ff ff ff       	call   801e59 <syscall>
  801f39:	83 c4 18             	add    $0x18,%esp
}
  801f3c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f3f:	5b                   	pop    %ebx
  801f40:	5e                   	pop    %esi
  801f41:	5d                   	pop    %ebp
  801f42:	c3                   	ret    

00801f43 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801f43:	55                   	push   %ebp
  801f44:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801f46:	6a 00                	push   $0x0
  801f48:	6a 00                	push   $0x0
  801f4a:	6a 00                	push   $0x0
  801f4c:	6a 00                	push   $0x0
  801f4e:	ff 75 08             	pushl  0x8(%ebp)
  801f51:	6a 0a                	push   $0xa
  801f53:	e8 01 ff ff ff       	call   801e59 <syscall>
  801f58:	83 c4 18             	add    $0x18,%esp
}
  801f5b:	c9                   	leave  
  801f5c:	c3                   	ret    

00801f5d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801f5d:	55                   	push   %ebp
  801f5e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801f60:	6a 00                	push   $0x0
  801f62:	6a 00                	push   $0x0
  801f64:	6a 00                	push   $0x0
  801f66:	ff 75 0c             	pushl  0xc(%ebp)
  801f69:	ff 75 08             	pushl  0x8(%ebp)
  801f6c:	6a 0b                	push   $0xb
  801f6e:	e8 e6 fe ff ff       	call   801e59 <syscall>
  801f73:	83 c4 18             	add    $0x18,%esp
}
  801f76:	c9                   	leave  
  801f77:	c3                   	ret    

00801f78 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801f78:	55                   	push   %ebp
  801f79:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801f7b:	6a 00                	push   $0x0
  801f7d:	6a 00                	push   $0x0
  801f7f:	6a 00                	push   $0x0
  801f81:	6a 00                	push   $0x0
  801f83:	6a 00                	push   $0x0
  801f85:	6a 0c                	push   $0xc
  801f87:	e8 cd fe ff ff       	call   801e59 <syscall>
  801f8c:	83 c4 18             	add    $0x18,%esp
}
  801f8f:	c9                   	leave  
  801f90:	c3                   	ret    

00801f91 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801f91:	55                   	push   %ebp
  801f92:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801f94:	6a 00                	push   $0x0
  801f96:	6a 00                	push   $0x0
  801f98:	6a 00                	push   $0x0
  801f9a:	6a 00                	push   $0x0
  801f9c:	6a 00                	push   $0x0
  801f9e:	6a 0d                	push   $0xd
  801fa0:	e8 b4 fe ff ff       	call   801e59 <syscall>
  801fa5:	83 c4 18             	add    $0x18,%esp
}
  801fa8:	c9                   	leave  
  801fa9:	c3                   	ret    

00801faa <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801faa:	55                   	push   %ebp
  801fab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801fad:	6a 00                	push   $0x0
  801faf:	6a 00                	push   $0x0
  801fb1:	6a 00                	push   $0x0
  801fb3:	6a 00                	push   $0x0
  801fb5:	6a 00                	push   $0x0
  801fb7:	6a 0e                	push   $0xe
  801fb9:	e8 9b fe ff ff       	call   801e59 <syscall>
  801fbe:	83 c4 18             	add    $0x18,%esp
}
  801fc1:	c9                   	leave  
  801fc2:	c3                   	ret    

00801fc3 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801fc3:	55                   	push   %ebp
  801fc4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801fc6:	6a 00                	push   $0x0
  801fc8:	6a 00                	push   $0x0
  801fca:	6a 00                	push   $0x0
  801fcc:	6a 00                	push   $0x0
  801fce:	6a 00                	push   $0x0
  801fd0:	6a 0f                	push   $0xf
  801fd2:	e8 82 fe ff ff       	call   801e59 <syscall>
  801fd7:	83 c4 18             	add    $0x18,%esp
}
  801fda:	c9                   	leave  
  801fdb:	c3                   	ret    

00801fdc <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801fdc:	55                   	push   %ebp
  801fdd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801fdf:	6a 00                	push   $0x0
  801fe1:	6a 00                	push   $0x0
  801fe3:	6a 00                	push   $0x0
  801fe5:	6a 00                	push   $0x0
  801fe7:	ff 75 08             	pushl  0x8(%ebp)
  801fea:	6a 10                	push   $0x10
  801fec:	e8 68 fe ff ff       	call   801e59 <syscall>
  801ff1:	83 c4 18             	add    $0x18,%esp
}
  801ff4:	c9                   	leave  
  801ff5:	c3                   	ret    

00801ff6 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801ff6:	55                   	push   %ebp
  801ff7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801ff9:	6a 00                	push   $0x0
  801ffb:	6a 00                	push   $0x0
  801ffd:	6a 00                	push   $0x0
  801fff:	6a 00                	push   $0x0
  802001:	6a 00                	push   $0x0
  802003:	6a 11                	push   $0x11
  802005:	e8 4f fe ff ff       	call   801e59 <syscall>
  80200a:	83 c4 18             	add    $0x18,%esp
}
  80200d:	90                   	nop
  80200e:	c9                   	leave  
  80200f:	c3                   	ret    

00802010 <sys_cputc>:

void
sys_cputc(const char c)
{
  802010:	55                   	push   %ebp
  802011:	89 e5                	mov    %esp,%ebp
  802013:	83 ec 04             	sub    $0x4,%esp
  802016:	8b 45 08             	mov    0x8(%ebp),%eax
  802019:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80201c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802020:	6a 00                	push   $0x0
  802022:	6a 00                	push   $0x0
  802024:	6a 00                	push   $0x0
  802026:	6a 00                	push   $0x0
  802028:	50                   	push   %eax
  802029:	6a 01                	push   $0x1
  80202b:	e8 29 fe ff ff       	call   801e59 <syscall>
  802030:	83 c4 18             	add    $0x18,%esp
}
  802033:	90                   	nop
  802034:	c9                   	leave  
  802035:	c3                   	ret    

00802036 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802036:	55                   	push   %ebp
  802037:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802039:	6a 00                	push   $0x0
  80203b:	6a 00                	push   $0x0
  80203d:	6a 00                	push   $0x0
  80203f:	6a 00                	push   $0x0
  802041:	6a 00                	push   $0x0
  802043:	6a 14                	push   $0x14
  802045:	e8 0f fe ff ff       	call   801e59 <syscall>
  80204a:	83 c4 18             	add    $0x18,%esp
}
  80204d:	90                   	nop
  80204e:	c9                   	leave  
  80204f:	c3                   	ret    

00802050 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802050:	55                   	push   %ebp
  802051:	89 e5                	mov    %esp,%ebp
  802053:	83 ec 04             	sub    $0x4,%esp
  802056:	8b 45 10             	mov    0x10(%ebp),%eax
  802059:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80205c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80205f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802063:	8b 45 08             	mov    0x8(%ebp),%eax
  802066:	6a 00                	push   $0x0
  802068:	51                   	push   %ecx
  802069:	52                   	push   %edx
  80206a:	ff 75 0c             	pushl  0xc(%ebp)
  80206d:	50                   	push   %eax
  80206e:	6a 15                	push   $0x15
  802070:	e8 e4 fd ff ff       	call   801e59 <syscall>
  802075:	83 c4 18             	add    $0x18,%esp
}
  802078:	c9                   	leave  
  802079:	c3                   	ret    

0080207a <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  80207a:	55                   	push   %ebp
  80207b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80207d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802080:	8b 45 08             	mov    0x8(%ebp),%eax
  802083:	6a 00                	push   $0x0
  802085:	6a 00                	push   $0x0
  802087:	6a 00                	push   $0x0
  802089:	52                   	push   %edx
  80208a:	50                   	push   %eax
  80208b:	6a 16                	push   $0x16
  80208d:	e8 c7 fd ff ff       	call   801e59 <syscall>
  802092:	83 c4 18             	add    $0x18,%esp
}
  802095:	c9                   	leave  
  802096:	c3                   	ret    

00802097 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  802097:	55                   	push   %ebp
  802098:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80209a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80209d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a3:	6a 00                	push   $0x0
  8020a5:	6a 00                	push   $0x0
  8020a7:	51                   	push   %ecx
  8020a8:	52                   	push   %edx
  8020a9:	50                   	push   %eax
  8020aa:	6a 17                	push   $0x17
  8020ac:	e8 a8 fd ff ff       	call   801e59 <syscall>
  8020b1:	83 c4 18             	add    $0x18,%esp
}
  8020b4:	c9                   	leave  
  8020b5:	c3                   	ret    

008020b6 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8020b6:	55                   	push   %ebp
  8020b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8020b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bf:	6a 00                	push   $0x0
  8020c1:	6a 00                	push   $0x0
  8020c3:	6a 00                	push   $0x0
  8020c5:	52                   	push   %edx
  8020c6:	50                   	push   %eax
  8020c7:	6a 18                	push   $0x18
  8020c9:	e8 8b fd ff ff       	call   801e59 <syscall>
  8020ce:	83 c4 18             	add    $0x18,%esp
}
  8020d1:	c9                   	leave  
  8020d2:	c3                   	ret    

008020d3 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8020d3:	55                   	push   %ebp
  8020d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8020d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d9:	6a 00                	push   $0x0
  8020db:	ff 75 14             	pushl  0x14(%ebp)
  8020de:	ff 75 10             	pushl  0x10(%ebp)
  8020e1:	ff 75 0c             	pushl  0xc(%ebp)
  8020e4:	50                   	push   %eax
  8020e5:	6a 19                	push   $0x19
  8020e7:	e8 6d fd ff ff       	call   801e59 <syscall>
  8020ec:	83 c4 18             	add    $0x18,%esp
}
  8020ef:	c9                   	leave  
  8020f0:	c3                   	ret    

008020f1 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8020f1:	55                   	push   %ebp
  8020f2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8020f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f7:	6a 00                	push   $0x0
  8020f9:	6a 00                	push   $0x0
  8020fb:	6a 00                	push   $0x0
  8020fd:	6a 00                	push   $0x0
  8020ff:	50                   	push   %eax
  802100:	6a 1a                	push   $0x1a
  802102:	e8 52 fd ff ff       	call   801e59 <syscall>
  802107:	83 c4 18             	add    $0x18,%esp
}
  80210a:	90                   	nop
  80210b:	c9                   	leave  
  80210c:	c3                   	ret    

0080210d <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80210d:	55                   	push   %ebp
  80210e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802110:	8b 45 08             	mov    0x8(%ebp),%eax
  802113:	6a 00                	push   $0x0
  802115:	6a 00                	push   $0x0
  802117:	6a 00                	push   $0x0
  802119:	6a 00                	push   $0x0
  80211b:	50                   	push   %eax
  80211c:	6a 1b                	push   $0x1b
  80211e:	e8 36 fd ff ff       	call   801e59 <syscall>
  802123:	83 c4 18             	add    $0x18,%esp
}
  802126:	c9                   	leave  
  802127:	c3                   	ret    

00802128 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802128:	55                   	push   %ebp
  802129:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80212b:	6a 00                	push   $0x0
  80212d:	6a 00                	push   $0x0
  80212f:	6a 00                	push   $0x0
  802131:	6a 00                	push   $0x0
  802133:	6a 00                	push   $0x0
  802135:	6a 05                	push   $0x5
  802137:	e8 1d fd ff ff       	call   801e59 <syscall>
  80213c:	83 c4 18             	add    $0x18,%esp
}
  80213f:	c9                   	leave  
  802140:	c3                   	ret    

00802141 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802141:	55                   	push   %ebp
  802142:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802144:	6a 00                	push   $0x0
  802146:	6a 00                	push   $0x0
  802148:	6a 00                	push   $0x0
  80214a:	6a 00                	push   $0x0
  80214c:	6a 00                	push   $0x0
  80214e:	6a 06                	push   $0x6
  802150:	e8 04 fd ff ff       	call   801e59 <syscall>
  802155:	83 c4 18             	add    $0x18,%esp
}
  802158:	c9                   	leave  
  802159:	c3                   	ret    

0080215a <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80215a:	55                   	push   %ebp
  80215b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80215d:	6a 00                	push   $0x0
  80215f:	6a 00                	push   $0x0
  802161:	6a 00                	push   $0x0
  802163:	6a 00                	push   $0x0
  802165:	6a 00                	push   $0x0
  802167:	6a 07                	push   $0x7
  802169:	e8 eb fc ff ff       	call   801e59 <syscall>
  80216e:	83 c4 18             	add    $0x18,%esp
}
  802171:	c9                   	leave  
  802172:	c3                   	ret    

00802173 <sys_exit_env>:


void sys_exit_env(void)
{
  802173:	55                   	push   %ebp
  802174:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802176:	6a 00                	push   $0x0
  802178:	6a 00                	push   $0x0
  80217a:	6a 00                	push   $0x0
  80217c:	6a 00                	push   $0x0
  80217e:	6a 00                	push   $0x0
  802180:	6a 1c                	push   $0x1c
  802182:	e8 d2 fc ff ff       	call   801e59 <syscall>
  802187:	83 c4 18             	add    $0x18,%esp
}
  80218a:	90                   	nop
  80218b:	c9                   	leave  
  80218c:	c3                   	ret    

0080218d <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80218d:	55                   	push   %ebp
  80218e:	89 e5                	mov    %esp,%ebp
  802190:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802193:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802196:	8d 50 04             	lea    0x4(%eax),%edx
  802199:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80219c:	6a 00                	push   $0x0
  80219e:	6a 00                	push   $0x0
  8021a0:	6a 00                	push   $0x0
  8021a2:	52                   	push   %edx
  8021a3:	50                   	push   %eax
  8021a4:	6a 1d                	push   $0x1d
  8021a6:	e8 ae fc ff ff       	call   801e59 <syscall>
  8021ab:	83 c4 18             	add    $0x18,%esp
	return result;
  8021ae:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8021b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021b4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8021b7:	89 01                	mov    %eax,(%ecx)
  8021b9:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8021bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bf:	c9                   	leave  
  8021c0:	c2 04 00             	ret    $0x4

008021c3 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8021c3:	55                   	push   %ebp
  8021c4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8021c6:	6a 00                	push   $0x0
  8021c8:	6a 00                	push   $0x0
  8021ca:	ff 75 10             	pushl  0x10(%ebp)
  8021cd:	ff 75 0c             	pushl  0xc(%ebp)
  8021d0:	ff 75 08             	pushl  0x8(%ebp)
  8021d3:	6a 13                	push   $0x13
  8021d5:	e8 7f fc ff ff       	call   801e59 <syscall>
  8021da:	83 c4 18             	add    $0x18,%esp
	return ;
  8021dd:	90                   	nop
}
  8021de:	c9                   	leave  
  8021df:	c3                   	ret    

008021e0 <sys_rcr2>:
uint32 sys_rcr2()
{
  8021e0:	55                   	push   %ebp
  8021e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8021e3:	6a 00                	push   $0x0
  8021e5:	6a 00                	push   $0x0
  8021e7:	6a 00                	push   $0x0
  8021e9:	6a 00                	push   $0x0
  8021eb:	6a 00                	push   $0x0
  8021ed:	6a 1e                	push   $0x1e
  8021ef:	e8 65 fc ff ff       	call   801e59 <syscall>
  8021f4:	83 c4 18             	add    $0x18,%esp
}
  8021f7:	c9                   	leave  
  8021f8:	c3                   	ret    

008021f9 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8021f9:	55                   	push   %ebp
  8021fa:	89 e5                	mov    %esp,%ebp
  8021fc:	83 ec 04             	sub    $0x4,%esp
  8021ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802202:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802205:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802209:	6a 00                	push   $0x0
  80220b:	6a 00                	push   $0x0
  80220d:	6a 00                	push   $0x0
  80220f:	6a 00                	push   $0x0
  802211:	50                   	push   %eax
  802212:	6a 1f                	push   $0x1f
  802214:	e8 40 fc ff ff       	call   801e59 <syscall>
  802219:	83 c4 18             	add    $0x18,%esp
	return ;
  80221c:	90                   	nop
}
  80221d:	c9                   	leave  
  80221e:	c3                   	ret    

0080221f <rsttst>:
void rsttst()
{
  80221f:	55                   	push   %ebp
  802220:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802222:	6a 00                	push   $0x0
  802224:	6a 00                	push   $0x0
  802226:	6a 00                	push   $0x0
  802228:	6a 00                	push   $0x0
  80222a:	6a 00                	push   $0x0
  80222c:	6a 21                	push   $0x21
  80222e:	e8 26 fc ff ff       	call   801e59 <syscall>
  802233:	83 c4 18             	add    $0x18,%esp
	return ;
  802236:	90                   	nop
}
  802237:	c9                   	leave  
  802238:	c3                   	ret    

00802239 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802239:	55                   	push   %ebp
  80223a:	89 e5                	mov    %esp,%ebp
  80223c:	83 ec 04             	sub    $0x4,%esp
  80223f:	8b 45 14             	mov    0x14(%ebp),%eax
  802242:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802245:	8b 55 18             	mov    0x18(%ebp),%edx
  802248:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80224c:	52                   	push   %edx
  80224d:	50                   	push   %eax
  80224e:	ff 75 10             	pushl  0x10(%ebp)
  802251:	ff 75 0c             	pushl  0xc(%ebp)
  802254:	ff 75 08             	pushl  0x8(%ebp)
  802257:	6a 20                	push   $0x20
  802259:	e8 fb fb ff ff       	call   801e59 <syscall>
  80225e:	83 c4 18             	add    $0x18,%esp
	return ;
  802261:	90                   	nop
}
  802262:	c9                   	leave  
  802263:	c3                   	ret    

00802264 <chktst>:
void chktst(uint32 n)
{
  802264:	55                   	push   %ebp
  802265:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802267:	6a 00                	push   $0x0
  802269:	6a 00                	push   $0x0
  80226b:	6a 00                	push   $0x0
  80226d:	6a 00                	push   $0x0
  80226f:	ff 75 08             	pushl  0x8(%ebp)
  802272:	6a 22                	push   $0x22
  802274:	e8 e0 fb ff ff       	call   801e59 <syscall>
  802279:	83 c4 18             	add    $0x18,%esp
	return ;
  80227c:	90                   	nop
}
  80227d:	c9                   	leave  
  80227e:	c3                   	ret    

0080227f <inctst>:

void inctst()
{
  80227f:	55                   	push   %ebp
  802280:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802282:	6a 00                	push   $0x0
  802284:	6a 00                	push   $0x0
  802286:	6a 00                	push   $0x0
  802288:	6a 00                	push   $0x0
  80228a:	6a 00                	push   $0x0
  80228c:	6a 23                	push   $0x23
  80228e:	e8 c6 fb ff ff       	call   801e59 <syscall>
  802293:	83 c4 18             	add    $0x18,%esp
	return ;
  802296:	90                   	nop
}
  802297:	c9                   	leave  
  802298:	c3                   	ret    

00802299 <gettst>:
uint32 gettst()
{
  802299:	55                   	push   %ebp
  80229a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80229c:	6a 00                	push   $0x0
  80229e:	6a 00                	push   $0x0
  8022a0:	6a 00                	push   $0x0
  8022a2:	6a 00                	push   $0x0
  8022a4:	6a 00                	push   $0x0
  8022a6:	6a 24                	push   $0x24
  8022a8:	e8 ac fb ff ff       	call   801e59 <syscall>
  8022ad:	83 c4 18             	add    $0x18,%esp
}
  8022b0:	c9                   	leave  
  8022b1:	c3                   	ret    

008022b2 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8022b2:	55                   	push   %ebp
  8022b3:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022b5:	6a 00                	push   $0x0
  8022b7:	6a 00                	push   $0x0
  8022b9:	6a 00                	push   $0x0
  8022bb:	6a 00                	push   $0x0
  8022bd:	6a 00                	push   $0x0
  8022bf:	6a 25                	push   $0x25
  8022c1:	e8 93 fb ff ff       	call   801e59 <syscall>
  8022c6:	83 c4 18             	add    $0x18,%esp
  8022c9:	a3 60 c0 81 00       	mov    %eax,0x81c060
	return uheapPlaceStrategy ;
  8022ce:	a1 60 c0 81 00       	mov    0x81c060,%eax
}
  8022d3:	c9                   	leave  
  8022d4:	c3                   	ret    

008022d5 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8022d5:	55                   	push   %ebp
  8022d6:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8022d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022db:	a3 60 c0 81 00       	mov    %eax,0x81c060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8022e0:	6a 00                	push   $0x0
  8022e2:	6a 00                	push   $0x0
  8022e4:	6a 00                	push   $0x0
  8022e6:	6a 00                	push   $0x0
  8022e8:	ff 75 08             	pushl  0x8(%ebp)
  8022eb:	6a 26                	push   $0x26
  8022ed:	e8 67 fb ff ff       	call   801e59 <syscall>
  8022f2:	83 c4 18             	add    $0x18,%esp
	return ;
  8022f5:	90                   	nop
}
  8022f6:	c9                   	leave  
  8022f7:	c3                   	ret    

008022f8 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8022f8:	55                   	push   %ebp
  8022f9:	89 e5                	mov    %esp,%ebp
  8022fb:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8022fc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8022ff:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802302:	8b 55 0c             	mov    0xc(%ebp),%edx
  802305:	8b 45 08             	mov    0x8(%ebp),%eax
  802308:	6a 00                	push   $0x0
  80230a:	53                   	push   %ebx
  80230b:	51                   	push   %ecx
  80230c:	52                   	push   %edx
  80230d:	50                   	push   %eax
  80230e:	6a 27                	push   $0x27
  802310:	e8 44 fb ff ff       	call   801e59 <syscall>
  802315:	83 c4 18             	add    $0x18,%esp
}
  802318:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80231b:	c9                   	leave  
  80231c:	c3                   	ret    

0080231d <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80231d:	55                   	push   %ebp
  80231e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802320:	8b 55 0c             	mov    0xc(%ebp),%edx
  802323:	8b 45 08             	mov    0x8(%ebp),%eax
  802326:	6a 00                	push   $0x0
  802328:	6a 00                	push   $0x0
  80232a:	6a 00                	push   $0x0
  80232c:	52                   	push   %edx
  80232d:	50                   	push   %eax
  80232e:	6a 28                	push   $0x28
  802330:	e8 24 fb ff ff       	call   801e59 <syscall>
  802335:	83 c4 18             	add    $0x18,%esp
}
  802338:	c9                   	leave  
  802339:	c3                   	ret    

0080233a <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80233a:	55                   	push   %ebp
  80233b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80233d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802340:	8b 55 0c             	mov    0xc(%ebp),%edx
  802343:	8b 45 08             	mov    0x8(%ebp),%eax
  802346:	6a 00                	push   $0x0
  802348:	51                   	push   %ecx
  802349:	ff 75 10             	pushl  0x10(%ebp)
  80234c:	52                   	push   %edx
  80234d:	50                   	push   %eax
  80234e:	6a 29                	push   $0x29
  802350:	e8 04 fb ff ff       	call   801e59 <syscall>
  802355:	83 c4 18             	add    $0x18,%esp
}
  802358:	c9                   	leave  
  802359:	c3                   	ret    

0080235a <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80235a:	55                   	push   %ebp
  80235b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80235d:	6a 00                	push   $0x0
  80235f:	6a 00                	push   $0x0
  802361:	ff 75 10             	pushl  0x10(%ebp)
  802364:	ff 75 0c             	pushl  0xc(%ebp)
  802367:	ff 75 08             	pushl  0x8(%ebp)
  80236a:	6a 12                	push   $0x12
  80236c:	e8 e8 fa ff ff       	call   801e59 <syscall>
  802371:	83 c4 18             	add    $0x18,%esp
	return ;
  802374:	90                   	nop
}
  802375:	c9                   	leave  
  802376:	c3                   	ret    

00802377 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802377:	55                   	push   %ebp
  802378:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80237a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80237d:	8b 45 08             	mov    0x8(%ebp),%eax
  802380:	6a 00                	push   $0x0
  802382:	6a 00                	push   $0x0
  802384:	6a 00                	push   $0x0
  802386:	52                   	push   %edx
  802387:	50                   	push   %eax
  802388:	6a 2a                	push   $0x2a
  80238a:	e8 ca fa ff ff       	call   801e59 <syscall>
  80238f:	83 c4 18             	add    $0x18,%esp
	return;
  802392:	90                   	nop
}
  802393:	c9                   	leave  
  802394:	c3                   	ret    

00802395 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  802395:	55                   	push   %ebp
  802396:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  802398:	6a 00                	push   $0x0
  80239a:	6a 00                	push   $0x0
  80239c:	6a 00                	push   $0x0
  80239e:	6a 00                	push   $0x0
  8023a0:	6a 00                	push   $0x0
  8023a2:	6a 2b                	push   $0x2b
  8023a4:	e8 b0 fa ff ff       	call   801e59 <syscall>
  8023a9:	83 c4 18             	add    $0x18,%esp
}
  8023ac:	c9                   	leave  
  8023ad:	c3                   	ret    

008023ae <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8023ae:	55                   	push   %ebp
  8023af:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8023b1:	6a 00                	push   $0x0
  8023b3:	6a 00                	push   $0x0
  8023b5:	6a 00                	push   $0x0
  8023b7:	ff 75 0c             	pushl  0xc(%ebp)
  8023ba:	ff 75 08             	pushl  0x8(%ebp)
  8023bd:	6a 2d                	push   $0x2d
  8023bf:	e8 95 fa ff ff       	call   801e59 <syscall>
  8023c4:	83 c4 18             	add    $0x18,%esp
	return;
  8023c7:	90                   	nop
}
  8023c8:	c9                   	leave  
  8023c9:	c3                   	ret    

008023ca <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8023ca:	55                   	push   %ebp
  8023cb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8023cd:	6a 00                	push   $0x0
  8023cf:	6a 00                	push   $0x0
  8023d1:	6a 00                	push   $0x0
  8023d3:	ff 75 0c             	pushl  0xc(%ebp)
  8023d6:	ff 75 08             	pushl  0x8(%ebp)
  8023d9:	6a 2c                	push   $0x2c
  8023db:	e8 79 fa ff ff       	call   801e59 <syscall>
  8023e0:	83 c4 18             	add    $0x18,%esp
	return ;
  8023e3:	90                   	nop
}
  8023e4:	c9                   	leave  
  8023e5:	c3                   	ret    

008023e6 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8023e6:	55                   	push   %ebp
  8023e7:	89 e5                	mov    %esp,%ebp
  8023e9:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  8023ec:	83 ec 04             	sub    $0x4,%esp
  8023ef:	68 68 31 80 00       	push   $0x803168
  8023f4:	68 25 01 00 00       	push   $0x125
  8023f9:	68 9b 31 80 00       	push   $0x80319b
  8023fe:	e8 e4 e4 ff ff       	call   8008e7 <_panic>

00802403 <to_page_va>:
//==================================================================================//
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  802403:	55                   	push   %ebp
  802404:	89 e5                	mov    %esp,%ebp
  802406:	83 ec 10             	sub    $0x10,%esp
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  802409:	8b 45 08             	mov    0x8(%ebp),%eax
  80240c:	ba 60 40 80 00       	mov    $0x804060,%edx
  802411:	29 d0                	sub    %edx,%eax
  802413:	c1 f8 02             	sar    $0x2,%eax
  802416:	89 c2                	mov    %eax,%edx
  802418:	89 d0                	mov    %edx,%eax
  80241a:	c1 e0 02             	shl    $0x2,%eax
  80241d:	01 d0                	add    %edx,%eax
  80241f:	c1 e0 02             	shl    $0x2,%eax
  802422:	01 d0                	add    %edx,%eax
  802424:	c1 e0 02             	shl    $0x2,%eax
  802427:	01 d0                	add    %edx,%eax
  802429:	89 c1                	mov    %eax,%ecx
  80242b:	c1 e1 08             	shl    $0x8,%ecx
  80242e:	01 c8                	add    %ecx,%eax
  802430:	89 c1                	mov    %eax,%ecx
  802432:	c1 e1 10             	shl    $0x10,%ecx
  802435:	01 c8                	add    %ecx,%eax
  802437:	01 c0                	add    %eax,%eax
  802439:	01 d0                	add    %edx,%eax
  80243b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  80243e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802441:	c1 e0 0c             	shl    $0xc,%eax
  802444:	89 c2                	mov    %eax,%edx
  802446:	a1 64 c0 81 00       	mov    0x81c064,%eax
  80244b:	01 d0                	add    %edx,%eax
}
  80244d:	c9                   	leave  
  80244e:	c3                   	ret    

0080244f <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  80244f:	55                   	push   %ebp
  802450:	89 e5                	mov    %esp,%ebp
  802452:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  802455:	8b 45 08             	mov    0x8(%ebp),%eax
  802458:	05 00 00 00 02       	add    $0x2000000,%eax
  80245d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802460:	73 16                	jae    802478 <initialize_dynamic_allocator+0x29>
  802462:	68 ac 31 80 00       	push   $0x8031ac
  802467:	68 d2 31 80 00       	push   $0x8031d2
  80246c:	6a 26                	push   $0x26
  80246e:	68 e7 31 80 00       	push   $0x8031e7
  802473:	e8 6f e4 ff ff       	call   8008e7 <_panic>
		is_initialized = 1;
  802478:	c7 05 28 40 80 00 01 	movl   $0x1,0x804028
  80247f:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	//Comment the following line
	panic("initialize_dynamic_allocator() Not implemented yet");
  802482:	83 ec 04             	sub    $0x4,%esp
  802485:	68 00 32 80 00       	push   $0x803200
  80248a:	6a 2e                	push   $0x2e
  80248c:	68 e7 31 80 00       	push   $0x8031e7
  802491:	e8 51 e4 ff ff       	call   8008e7 <_panic>

00802496 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  802496:	55                   	push   %ebp
  802497:	89 e5                	mov    %esp,%ebp
  802499:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	//Comment the following line
	panic("get_block_size() Not implemented yet");
  80249c:	83 ec 04             	sub    $0x4,%esp
  80249f:	68 34 32 80 00       	push   $0x803234
  8024a4:	6a 3a                	push   $0x3a
  8024a6:	68 e7 31 80 00       	push   $0x8031e7
  8024ab:	e8 37 e4 ff ff       	call   8008e7 <_panic>

008024b0 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  8024b0:	55                   	push   %ebp
  8024b1:	89 e5                	mov    %esp,%ebp
  8024b3:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  8024b6:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8024bd:	76 16                	jbe    8024d5 <alloc_block+0x25>
  8024bf:	68 5c 32 80 00       	push   $0x80325c
  8024c4:	68 d2 31 80 00       	push   $0x8031d2
  8024c9:	6a 46                	push   $0x46
  8024cb:	68 e7 31 80 00       	push   $0x8031e7
  8024d0:	e8 12 e4 ff ff       	call   8008e7 <_panic>
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	panic("alloc_block() Not implemented yet");
  8024d5:	83 ec 04             	sub    $0x4,%esp
  8024d8:	68 80 32 80 00       	push   $0x803280
  8024dd:	6a 4d                	push   $0x4d
  8024df:	68 e7 31 80 00       	push   $0x8031e7
  8024e4:	e8 fe e3 ff ff       	call   8008e7 <_panic>

008024e9 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  8024e9:	55                   	push   %ebp
  8024ea:	89 e5                	mov    %esp,%ebp
  8024ec:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  8024ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8024f2:	a1 64 c0 81 00       	mov    0x81c064,%eax
  8024f7:	39 c2                	cmp    %eax,%edx
  8024f9:	72 0c                	jb     802507 <free_block+0x1e>
  8024fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8024fe:	a1 40 40 80 00       	mov    0x804040,%eax
  802503:	39 c2                	cmp    %eax,%edx
  802505:	72 16                	jb     80251d <free_block+0x34>
  802507:	68 a4 32 80 00       	push   $0x8032a4
  80250c:	68 d2 31 80 00       	push   $0x8031d2
  802511:	6a 5b                	push   $0x5b
  802513:	68 e7 31 80 00       	push   $0x8031e7
  802518:	e8 ca e3 ff ff       	call   8008e7 <_panic>
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	panic("free_block() Not implemented yet");
  80251d:	83 ec 04             	sub    $0x4,%esp
  802520:	68 dc 32 80 00       	push   $0x8032dc
  802525:	6a 63                	push   $0x63
  802527:	68 e7 31 80 00       	push   $0x8031e7
  80252c:	e8 b6 e3 ff ff       	call   8008e7 <_panic>

00802531 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  802531:	55                   	push   %ebp
  802532:	89 e5                	mov    %esp,%ebp
  802534:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  802537:	83 ec 04             	sub    $0x4,%esp
  80253a:	68 00 33 80 00       	push   $0x803300
  80253f:	6a 72                	push   $0x72
  802541:	68 e7 31 80 00       	push   $0x8031e7
  802546:	e8 9c e3 ff ff       	call   8008e7 <_panic>
  80254b:	90                   	nop

0080254c <__udivdi3>:
  80254c:	55                   	push   %ebp
  80254d:	57                   	push   %edi
  80254e:	56                   	push   %esi
  80254f:	53                   	push   %ebx
  802550:	83 ec 1c             	sub    $0x1c,%esp
  802553:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802557:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80255b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80255f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802563:	89 ca                	mov    %ecx,%edx
  802565:	89 f8                	mov    %edi,%eax
  802567:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80256b:	85 f6                	test   %esi,%esi
  80256d:	75 2d                	jne    80259c <__udivdi3+0x50>
  80256f:	39 cf                	cmp    %ecx,%edi
  802571:	77 65                	ja     8025d8 <__udivdi3+0x8c>
  802573:	89 fd                	mov    %edi,%ebp
  802575:	85 ff                	test   %edi,%edi
  802577:	75 0b                	jne    802584 <__udivdi3+0x38>
  802579:	b8 01 00 00 00       	mov    $0x1,%eax
  80257e:	31 d2                	xor    %edx,%edx
  802580:	f7 f7                	div    %edi
  802582:	89 c5                	mov    %eax,%ebp
  802584:	31 d2                	xor    %edx,%edx
  802586:	89 c8                	mov    %ecx,%eax
  802588:	f7 f5                	div    %ebp
  80258a:	89 c1                	mov    %eax,%ecx
  80258c:	89 d8                	mov    %ebx,%eax
  80258e:	f7 f5                	div    %ebp
  802590:	89 cf                	mov    %ecx,%edi
  802592:	89 fa                	mov    %edi,%edx
  802594:	83 c4 1c             	add    $0x1c,%esp
  802597:	5b                   	pop    %ebx
  802598:	5e                   	pop    %esi
  802599:	5f                   	pop    %edi
  80259a:	5d                   	pop    %ebp
  80259b:	c3                   	ret    
  80259c:	39 ce                	cmp    %ecx,%esi
  80259e:	77 28                	ja     8025c8 <__udivdi3+0x7c>
  8025a0:	0f bd fe             	bsr    %esi,%edi
  8025a3:	83 f7 1f             	xor    $0x1f,%edi
  8025a6:	75 40                	jne    8025e8 <__udivdi3+0x9c>
  8025a8:	39 ce                	cmp    %ecx,%esi
  8025aa:	72 0a                	jb     8025b6 <__udivdi3+0x6a>
  8025ac:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8025b0:	0f 87 9e 00 00 00    	ja     802654 <__udivdi3+0x108>
  8025b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8025bb:	89 fa                	mov    %edi,%edx
  8025bd:	83 c4 1c             	add    $0x1c,%esp
  8025c0:	5b                   	pop    %ebx
  8025c1:	5e                   	pop    %esi
  8025c2:	5f                   	pop    %edi
  8025c3:	5d                   	pop    %ebp
  8025c4:	c3                   	ret    
  8025c5:	8d 76 00             	lea    0x0(%esi),%esi
  8025c8:	31 ff                	xor    %edi,%edi
  8025ca:	31 c0                	xor    %eax,%eax
  8025cc:	89 fa                	mov    %edi,%edx
  8025ce:	83 c4 1c             	add    $0x1c,%esp
  8025d1:	5b                   	pop    %ebx
  8025d2:	5e                   	pop    %esi
  8025d3:	5f                   	pop    %edi
  8025d4:	5d                   	pop    %ebp
  8025d5:	c3                   	ret    
  8025d6:	66 90                	xchg   %ax,%ax
  8025d8:	89 d8                	mov    %ebx,%eax
  8025da:	f7 f7                	div    %edi
  8025dc:	31 ff                	xor    %edi,%edi
  8025de:	89 fa                	mov    %edi,%edx
  8025e0:	83 c4 1c             	add    $0x1c,%esp
  8025e3:	5b                   	pop    %ebx
  8025e4:	5e                   	pop    %esi
  8025e5:	5f                   	pop    %edi
  8025e6:	5d                   	pop    %ebp
  8025e7:	c3                   	ret    
  8025e8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8025ed:	89 eb                	mov    %ebp,%ebx
  8025ef:	29 fb                	sub    %edi,%ebx
  8025f1:	89 f9                	mov    %edi,%ecx
  8025f3:	d3 e6                	shl    %cl,%esi
  8025f5:	89 c5                	mov    %eax,%ebp
  8025f7:	88 d9                	mov    %bl,%cl
  8025f9:	d3 ed                	shr    %cl,%ebp
  8025fb:	89 e9                	mov    %ebp,%ecx
  8025fd:	09 f1                	or     %esi,%ecx
  8025ff:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802603:	89 f9                	mov    %edi,%ecx
  802605:	d3 e0                	shl    %cl,%eax
  802607:	89 c5                	mov    %eax,%ebp
  802609:	89 d6                	mov    %edx,%esi
  80260b:	88 d9                	mov    %bl,%cl
  80260d:	d3 ee                	shr    %cl,%esi
  80260f:	89 f9                	mov    %edi,%ecx
  802611:	d3 e2                	shl    %cl,%edx
  802613:	8b 44 24 08          	mov    0x8(%esp),%eax
  802617:	88 d9                	mov    %bl,%cl
  802619:	d3 e8                	shr    %cl,%eax
  80261b:	09 c2                	or     %eax,%edx
  80261d:	89 d0                	mov    %edx,%eax
  80261f:	89 f2                	mov    %esi,%edx
  802621:	f7 74 24 0c          	divl   0xc(%esp)
  802625:	89 d6                	mov    %edx,%esi
  802627:	89 c3                	mov    %eax,%ebx
  802629:	f7 e5                	mul    %ebp
  80262b:	39 d6                	cmp    %edx,%esi
  80262d:	72 19                	jb     802648 <__udivdi3+0xfc>
  80262f:	74 0b                	je     80263c <__udivdi3+0xf0>
  802631:	89 d8                	mov    %ebx,%eax
  802633:	31 ff                	xor    %edi,%edi
  802635:	e9 58 ff ff ff       	jmp    802592 <__udivdi3+0x46>
  80263a:	66 90                	xchg   %ax,%ax
  80263c:	8b 54 24 08          	mov    0x8(%esp),%edx
  802640:	89 f9                	mov    %edi,%ecx
  802642:	d3 e2                	shl    %cl,%edx
  802644:	39 c2                	cmp    %eax,%edx
  802646:	73 e9                	jae    802631 <__udivdi3+0xe5>
  802648:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80264b:	31 ff                	xor    %edi,%edi
  80264d:	e9 40 ff ff ff       	jmp    802592 <__udivdi3+0x46>
  802652:	66 90                	xchg   %ax,%ax
  802654:	31 c0                	xor    %eax,%eax
  802656:	e9 37 ff ff ff       	jmp    802592 <__udivdi3+0x46>
  80265b:	90                   	nop

0080265c <__umoddi3>:
  80265c:	55                   	push   %ebp
  80265d:	57                   	push   %edi
  80265e:	56                   	push   %esi
  80265f:	53                   	push   %ebx
  802660:	83 ec 1c             	sub    $0x1c,%esp
  802663:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802667:	8b 74 24 34          	mov    0x34(%esp),%esi
  80266b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80266f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802673:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802677:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80267b:	89 f3                	mov    %esi,%ebx
  80267d:	89 fa                	mov    %edi,%edx
  80267f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802683:	89 34 24             	mov    %esi,(%esp)
  802686:	85 c0                	test   %eax,%eax
  802688:	75 1a                	jne    8026a4 <__umoddi3+0x48>
  80268a:	39 f7                	cmp    %esi,%edi
  80268c:	0f 86 a2 00 00 00    	jbe    802734 <__umoddi3+0xd8>
  802692:	89 c8                	mov    %ecx,%eax
  802694:	89 f2                	mov    %esi,%edx
  802696:	f7 f7                	div    %edi
  802698:	89 d0                	mov    %edx,%eax
  80269a:	31 d2                	xor    %edx,%edx
  80269c:	83 c4 1c             	add    $0x1c,%esp
  80269f:	5b                   	pop    %ebx
  8026a0:	5e                   	pop    %esi
  8026a1:	5f                   	pop    %edi
  8026a2:	5d                   	pop    %ebp
  8026a3:	c3                   	ret    
  8026a4:	39 f0                	cmp    %esi,%eax
  8026a6:	0f 87 ac 00 00 00    	ja     802758 <__umoddi3+0xfc>
  8026ac:	0f bd e8             	bsr    %eax,%ebp
  8026af:	83 f5 1f             	xor    $0x1f,%ebp
  8026b2:	0f 84 ac 00 00 00    	je     802764 <__umoddi3+0x108>
  8026b8:	bf 20 00 00 00       	mov    $0x20,%edi
  8026bd:	29 ef                	sub    %ebp,%edi
  8026bf:	89 fe                	mov    %edi,%esi
  8026c1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8026c5:	89 e9                	mov    %ebp,%ecx
  8026c7:	d3 e0                	shl    %cl,%eax
  8026c9:	89 d7                	mov    %edx,%edi
  8026cb:	89 f1                	mov    %esi,%ecx
  8026cd:	d3 ef                	shr    %cl,%edi
  8026cf:	09 c7                	or     %eax,%edi
  8026d1:	89 e9                	mov    %ebp,%ecx
  8026d3:	d3 e2                	shl    %cl,%edx
  8026d5:	89 14 24             	mov    %edx,(%esp)
  8026d8:	89 d8                	mov    %ebx,%eax
  8026da:	d3 e0                	shl    %cl,%eax
  8026dc:	89 c2                	mov    %eax,%edx
  8026de:	8b 44 24 08          	mov    0x8(%esp),%eax
  8026e2:	d3 e0                	shl    %cl,%eax
  8026e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026e8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8026ec:	89 f1                	mov    %esi,%ecx
  8026ee:	d3 e8                	shr    %cl,%eax
  8026f0:	09 d0                	or     %edx,%eax
  8026f2:	d3 eb                	shr    %cl,%ebx
  8026f4:	89 da                	mov    %ebx,%edx
  8026f6:	f7 f7                	div    %edi
  8026f8:	89 d3                	mov    %edx,%ebx
  8026fa:	f7 24 24             	mull   (%esp)
  8026fd:	89 c6                	mov    %eax,%esi
  8026ff:	89 d1                	mov    %edx,%ecx
  802701:	39 d3                	cmp    %edx,%ebx
  802703:	0f 82 87 00 00 00    	jb     802790 <__umoddi3+0x134>
  802709:	0f 84 91 00 00 00    	je     8027a0 <__umoddi3+0x144>
  80270f:	8b 54 24 04          	mov    0x4(%esp),%edx
  802713:	29 f2                	sub    %esi,%edx
  802715:	19 cb                	sbb    %ecx,%ebx
  802717:	89 d8                	mov    %ebx,%eax
  802719:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80271d:	d3 e0                	shl    %cl,%eax
  80271f:	89 e9                	mov    %ebp,%ecx
  802721:	d3 ea                	shr    %cl,%edx
  802723:	09 d0                	or     %edx,%eax
  802725:	89 e9                	mov    %ebp,%ecx
  802727:	d3 eb                	shr    %cl,%ebx
  802729:	89 da                	mov    %ebx,%edx
  80272b:	83 c4 1c             	add    $0x1c,%esp
  80272e:	5b                   	pop    %ebx
  80272f:	5e                   	pop    %esi
  802730:	5f                   	pop    %edi
  802731:	5d                   	pop    %ebp
  802732:	c3                   	ret    
  802733:	90                   	nop
  802734:	89 fd                	mov    %edi,%ebp
  802736:	85 ff                	test   %edi,%edi
  802738:	75 0b                	jne    802745 <__umoddi3+0xe9>
  80273a:	b8 01 00 00 00       	mov    $0x1,%eax
  80273f:	31 d2                	xor    %edx,%edx
  802741:	f7 f7                	div    %edi
  802743:	89 c5                	mov    %eax,%ebp
  802745:	89 f0                	mov    %esi,%eax
  802747:	31 d2                	xor    %edx,%edx
  802749:	f7 f5                	div    %ebp
  80274b:	89 c8                	mov    %ecx,%eax
  80274d:	f7 f5                	div    %ebp
  80274f:	89 d0                	mov    %edx,%eax
  802751:	e9 44 ff ff ff       	jmp    80269a <__umoddi3+0x3e>
  802756:	66 90                	xchg   %ax,%ax
  802758:	89 c8                	mov    %ecx,%eax
  80275a:	89 f2                	mov    %esi,%edx
  80275c:	83 c4 1c             	add    $0x1c,%esp
  80275f:	5b                   	pop    %ebx
  802760:	5e                   	pop    %esi
  802761:	5f                   	pop    %edi
  802762:	5d                   	pop    %ebp
  802763:	c3                   	ret    
  802764:	3b 04 24             	cmp    (%esp),%eax
  802767:	72 06                	jb     80276f <__umoddi3+0x113>
  802769:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80276d:	77 0f                	ja     80277e <__umoddi3+0x122>
  80276f:	89 f2                	mov    %esi,%edx
  802771:	29 f9                	sub    %edi,%ecx
  802773:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802777:	89 14 24             	mov    %edx,(%esp)
  80277a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80277e:	8b 44 24 04          	mov    0x4(%esp),%eax
  802782:	8b 14 24             	mov    (%esp),%edx
  802785:	83 c4 1c             	add    $0x1c,%esp
  802788:	5b                   	pop    %ebx
  802789:	5e                   	pop    %esi
  80278a:	5f                   	pop    %edi
  80278b:	5d                   	pop    %ebp
  80278c:	c3                   	ret    
  80278d:	8d 76 00             	lea    0x0(%esi),%esi
  802790:	2b 04 24             	sub    (%esp),%eax
  802793:	19 fa                	sbb    %edi,%edx
  802795:	89 d1                	mov    %edx,%ecx
  802797:	89 c6                	mov    %eax,%esi
  802799:	e9 71 ff ff ff       	jmp    80270f <__umoddi3+0xb3>
  80279e:	66 90                	xchg   %ax,%ax
  8027a0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8027a4:	72 ea                	jb     802790 <__umoddi3+0x134>
  8027a6:	89 d9                	mov    %ebx,%ecx
  8027a8:	e9 62 ff ff ff       	jmp    80270f <__umoddi3+0xb3>

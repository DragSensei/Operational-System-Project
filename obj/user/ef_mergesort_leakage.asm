
obj/user/ef_mergesort_leakage:     file format elf32-i386


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
  800031:	e8 48 07 00 00       	call   80077e <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
void Merge(int* A, int p, int q, int r);

uint32 CheckSorted(int *Elements, int NumOfElements);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 28 01 00 00    	sub    $0x128,%esp
	char Line[255] ;
	char Chose ;
	int numOfRep = 0;
  800041:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	do
	{
		numOfRep++ ;
  800048:	ff 45 f0             	incl   -0x10(%ebp)
		//2012: lock the interrupt
		sys_lock_cons();
  80004b:	e8 b7 1c 00 00       	call   801d07 <sys_lock_cons>

		cprintf("\n");
  800050:	83 ec 0c             	sub    $0xc,%esp
  800053:	68 00 26 80 00       	push   $0x802600
  800058:	e8 9f 0b 00 00       	call   800bfc <cprintf>
  80005d:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800060:	83 ec 0c             	sub    $0xc,%esp
  800063:	68 02 26 80 00       	push   $0x802602
  800068:	e8 8f 0b 00 00       	call   800bfc <cprintf>
  80006d:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!! MERGE SORT !!!!\n");
  800070:	83 ec 0c             	sub    $0xc,%esp
  800073:	68 18 26 80 00       	push   $0x802618
  800078:	e8 7f 0b 00 00       	call   800bfc <cprintf>
  80007d:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800080:	83 ec 0c             	sub    $0xc,%esp
  800083:	68 02 26 80 00       	push   $0x802602
  800088:	e8 6f 0b 00 00       	call   800bfc <cprintf>
  80008d:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800090:	83 ec 0c             	sub    $0xc,%esp
  800093:	68 00 26 80 00       	push   $0x802600
  800098:	e8 5f 0b 00 00       	call   800bfc <cprintf>
  80009d:	83 c4 10             	add    $0x10,%esp
		cprintf("Enter the number of elements: ");
  8000a0:	83 ec 0c             	sub    $0xc,%esp
  8000a3:	68 30 26 80 00       	push   $0x802630
  8000a8:	e8 4f 0b 00 00       	call   800bfc <cprintf>
  8000ad:	83 c4 10             	add    $0x10,%esp

		int NumOfElements ;

		if (numOfRep == 1)
  8000b0:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  8000b4:	75 09                	jne    8000bf <_main+0x87>
			NumOfElements = 32;
  8000b6:	c7 45 ec 20 00 00 00 	movl   $0x20,-0x14(%ebp)
  8000bd:	eb 0d                	jmp    8000cc <_main+0x94>
		else if (numOfRep == 2)
  8000bf:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
  8000c3:	75 07                	jne    8000cc <_main+0x94>
			NumOfElements = 32;
  8000c5:	c7 45 ec 20 00 00 00 	movl   $0x20,-0x14(%ebp)

		cprintf("%d\n", NumOfElements) ;
  8000cc:	83 ec 08             	sub    $0x8,%esp
  8000cf:	ff 75 ec             	pushl  -0x14(%ebp)
  8000d2:	68 4f 26 80 00       	push   $0x80264f
  8000d7:	e8 20 0b 00 00       	call   800bfc <cprintf>
  8000dc:	83 c4 10             	add    $0x10,%esp

		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  8000df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000e2:	c1 e0 02             	shl    $0x2,%eax
  8000e5:	83 ec 0c             	sub    $0xc,%esp
  8000e8:	50                   	push   %eax
  8000e9:	e8 d0 1a 00 00       	call   801bbe <malloc>
  8000ee:	83 c4 10             	add    $0x10,%esp
  8000f1:	89 45 e8             	mov    %eax,-0x18(%ebp)
		cprintf("Chose the initialization method:\n") ;
  8000f4:	83 ec 0c             	sub    $0xc,%esp
  8000f7:	68 54 26 80 00       	push   $0x802654
  8000fc:	e8 fb 0a 00 00       	call   800bfc <cprintf>
  800101:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  800104:	83 ec 0c             	sub    $0xc,%esp
  800107:	68 76 26 80 00       	push   $0x802676
  80010c:	e8 eb 0a 00 00       	call   800bfc <cprintf>
  800111:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  800114:	83 ec 0c             	sub    $0xc,%esp
  800117:	68 84 26 80 00       	push   $0x802684
  80011c:	e8 db 0a 00 00       	call   800bfc <cprintf>
  800121:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  800124:	83 ec 0c             	sub    $0xc,%esp
  800127:	68 93 26 80 00       	push   $0x802693
  80012c:	e8 cb 0a 00 00       	call   800bfc <cprintf>
  800131:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  800134:	83 ec 0c             	sub    $0xc,%esp
  800137:	68 a3 26 80 00       	push   $0x8026a3
  80013c:	e8 bb 0a 00 00       	call   800bfc <cprintf>
  800141:	83 c4 10             	add    $0x10,%esp
			if (numOfRep == 1)
  800144:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  800148:	75 06                	jne    800150 <_main+0x118>
				Chose = 'a' ;
  80014a:	c6 45 f7 61          	movb   $0x61,-0x9(%ebp)
  80014e:	eb 0a                	jmp    80015a <_main+0x122>
			else if (numOfRep == 2)
  800150:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
  800154:	75 04                	jne    80015a <_main+0x122>
				Chose = 'c' ;
  800156:	c6 45 f7 63          	movb   $0x63,-0x9(%ebp)
			cputchar(Chose);
  80015a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80015e:	83 ec 0c             	sub    $0xc,%esp
  800161:	50                   	push   %eax
  800162:	e8 db 05 00 00       	call   800742 <cputchar>
  800167:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  80016a:	83 ec 0c             	sub    $0xc,%esp
  80016d:	6a 0a                	push   $0xa
  80016f:	e8 ce 05 00 00       	call   800742 <cputchar>
  800174:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800177:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  80017b:	74 0c                	je     800189 <_main+0x151>
  80017d:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  800181:	74 06                	je     800189 <_main+0x151>
  800183:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  800187:	75 ab                	jne    800134 <_main+0xfc>

		//2012: lock the interrupt
		sys_unlock_cons();
  800189:	e8 93 1b 00 00       	call   801d21 <sys_unlock_cons>

		int  i ;
		switch (Chose)
  80018e:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800192:	83 f8 62             	cmp    $0x62,%eax
  800195:	74 1d                	je     8001b4 <_main+0x17c>
  800197:	83 f8 63             	cmp    $0x63,%eax
  80019a:	74 2b                	je     8001c7 <_main+0x18f>
  80019c:	83 f8 61             	cmp    $0x61,%eax
  80019f:	75 39                	jne    8001da <_main+0x1a2>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  8001a1:	83 ec 08             	sub    $0x8,%esp
  8001a4:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a7:	ff 75 e8             	pushl  -0x18(%ebp)
  8001aa:	e8 f9 01 00 00       	call   8003a8 <InitializeAscending>
  8001af:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b2:	eb 37                	jmp    8001eb <_main+0x1b3>
		case 'b':
			InitializeIdentical(Elements, NumOfElements);
  8001b4:	83 ec 08             	sub    $0x8,%esp
  8001b7:	ff 75 ec             	pushl  -0x14(%ebp)
  8001ba:	ff 75 e8             	pushl  -0x18(%ebp)
  8001bd:	e8 17 02 00 00       	call   8003d9 <InitializeIdentical>
  8001c2:	83 c4 10             	add    $0x10,%esp
			break ;
  8001c5:	eb 24                	jmp    8001eb <_main+0x1b3>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001c7:	83 ec 08             	sub    $0x8,%esp
  8001ca:	ff 75 ec             	pushl  -0x14(%ebp)
  8001cd:	ff 75 e8             	pushl  -0x18(%ebp)
  8001d0:	e8 39 02 00 00       	call   80040e <InitializeSemiRandom>
  8001d5:	83 c4 10             	add    $0x10,%esp
			break ;
  8001d8:	eb 11                	jmp    8001eb <_main+0x1b3>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001da:	83 ec 08             	sub    $0x8,%esp
  8001dd:	ff 75 ec             	pushl  -0x14(%ebp)
  8001e0:	ff 75 e8             	pushl  -0x18(%ebp)
  8001e3:	e8 26 02 00 00       	call   80040e <InitializeSemiRandom>
  8001e8:	83 c4 10             	add    $0x10,%esp
		}

		MSort(Elements, 1, NumOfElements);
  8001eb:	83 ec 04             	sub    $0x4,%esp
  8001ee:	ff 75 ec             	pushl  -0x14(%ebp)
  8001f1:	6a 01                	push   $0x1
  8001f3:	ff 75 e8             	pushl  -0x18(%ebp)
  8001f6:	e8 f2 02 00 00       	call   8004ed <MSort>
  8001fb:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8001fe:	e8 04 1b 00 00       	call   801d07 <sys_lock_cons>
		cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  800203:	83 ec 0c             	sub    $0xc,%esp
  800206:	68 ac 26 80 00       	push   $0x8026ac
  80020b:	e8 ec 09 00 00       	call   800bfc <cprintf>
  800210:	83 c4 10             	add    $0x10,%esp
		//PrintElements(Elements, NumOfElements);
		sys_unlock_cons();
  800213:	e8 09 1b 00 00       	call   801d21 <sys_unlock_cons>

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  800218:	83 ec 08             	sub    $0x8,%esp
  80021b:	ff 75 ec             	pushl  -0x14(%ebp)
  80021e:	ff 75 e8             	pushl  -0x18(%ebp)
  800221:	e8 d8 00 00 00       	call   8002fe <CheckSorted>
  800226:	83 c4 10             	add    $0x10,%esp
  800229:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  80022c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800230:	75 14                	jne    800246 <_main+0x20e>
  800232:	83 ec 04             	sub    $0x4,%esp
  800235:	68 e0 26 80 00       	push   $0x8026e0
  80023a:	6a 58                	push   $0x58
  80023c:	68 02 27 80 00       	push   $0x802702
  800241:	e8 e8 06 00 00       	call   80092e <_panic>
		else
		{
			sys_lock_cons();
  800246:	e8 bc 1a 00 00       	call   801d07 <sys_lock_cons>
			cprintf("===============================================\n") ;
  80024b:	83 ec 0c             	sub    $0xc,%esp
  80024e:	68 20 27 80 00       	push   $0x802720
  800253:	e8 a4 09 00 00       	call   800bfc <cprintf>
  800258:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  80025b:	83 ec 0c             	sub    $0xc,%esp
  80025e:	68 54 27 80 00       	push   $0x802754
  800263:	e8 94 09 00 00       	call   800bfc <cprintf>
  800268:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  80026b:	83 ec 0c             	sub    $0xc,%esp
  80026e:	68 88 27 80 00       	push   $0x802788
  800273:	e8 84 09 00 00       	call   800bfc <cprintf>
  800278:	83 c4 10             	add    $0x10,%esp
			sys_unlock_cons();
  80027b:	e8 a1 1a 00 00       	call   801d21 <sys_unlock_cons>
		}

		//free(Elements) ;

		sys_lock_cons();
  800280:	e8 82 1a 00 00       	call   801d07 <sys_lock_cons>
		Chose = 0 ;
  800285:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
		while (Chose != 'y' && Chose != 'n')
  800289:	eb 50                	jmp    8002db <_main+0x2a3>
		{
			cprintf("Do you want to repeat (y/n): ") ;
  80028b:	83 ec 0c             	sub    $0xc,%esp
  80028e:	68 ba 27 80 00       	push   $0x8027ba
  800293:	e8 64 09 00 00       	call   800bfc <cprintf>
  800298:	83 c4 10             	add    $0x10,%esp
			if (numOfRep == 1)
  80029b:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  80029f:	75 06                	jne    8002a7 <_main+0x26f>
				Chose = 'y' ;
  8002a1:	c6 45 f7 79          	movb   $0x79,-0x9(%ebp)
  8002a5:	eb 0a                	jmp    8002b1 <_main+0x279>
			else if (numOfRep == 2)
  8002a7:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
  8002ab:	75 04                	jne    8002b1 <_main+0x279>
				Chose = 'n' ;
  8002ad:	c6 45 f7 6e          	movb   $0x6e,-0x9(%ebp)
			cputchar(Chose);
  8002b1:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8002b5:	83 ec 0c             	sub    $0xc,%esp
  8002b8:	50                   	push   %eax
  8002b9:	e8 84 04 00 00       	call   800742 <cputchar>
  8002be:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  8002c1:	83 ec 0c             	sub    $0xc,%esp
  8002c4:	6a 0a                	push   $0xa
  8002c6:	e8 77 04 00 00       	call   800742 <cputchar>
  8002cb:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  8002ce:	83 ec 0c             	sub    $0xc,%esp
  8002d1:	6a 0a                	push   $0xa
  8002d3:	e8 6a 04 00 00       	call   800742 <cputchar>
  8002d8:	83 c4 10             	add    $0x10,%esp

		//free(Elements) ;

		sys_lock_cons();
		Chose = 0 ;
		while (Chose != 'y' && Chose != 'n')
  8002db:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002df:	74 06                	je     8002e7 <_main+0x2af>
  8002e1:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  8002e5:	75 a4                	jne    80028b <_main+0x253>
				Chose = 'n' ;
			cputchar(Chose);
			cputchar('\n');
			cputchar('\n');
		}
		sys_unlock_cons();
  8002e7:	e8 35 1a 00 00       	call   801d21 <sys_unlock_cons>

	} while (Chose == 'y');
  8002ec:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002f0:	0f 84 52 fd ff ff    	je     800048 <_main+0x10>

	//To indicate that it's completed successfully
	inctst();
  8002f6:	e8 c3 1d 00 00       	call   8020be <inctst>

}
  8002fb:	90                   	nop
  8002fc:	c9                   	leave  
  8002fd:	c3                   	ret    

008002fe <CheckSorted>:


uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8002fe:	55                   	push   %ebp
  8002ff:	89 e5                	mov    %esp,%ebp
  800301:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  800304:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  80030b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800312:	eb 33                	jmp    800347 <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  800314:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800317:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80031e:	8b 45 08             	mov    0x8(%ebp),%eax
  800321:	01 d0                	add    %edx,%eax
  800323:	8b 10                	mov    (%eax),%edx
  800325:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800328:	40                   	inc    %eax
  800329:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800330:	8b 45 08             	mov    0x8(%ebp),%eax
  800333:	01 c8                	add    %ecx,%eax
  800335:	8b 00                	mov    (%eax),%eax
  800337:	39 c2                	cmp    %eax,%edx
  800339:	7e 09                	jle    800344 <CheckSorted+0x46>
		{
			Sorted = 0 ;
  80033b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800342:	eb 0c                	jmp    800350 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800344:	ff 45 f8             	incl   -0x8(%ebp)
  800347:	8b 45 0c             	mov    0xc(%ebp),%eax
  80034a:	48                   	dec    %eax
  80034b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80034e:	7f c4                	jg     800314 <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800350:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800353:	c9                   	leave  
  800354:	c3                   	ret    

00800355 <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  800355:	55                   	push   %ebp
  800356:	89 e5                	mov    %esp,%ebp
  800358:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  80035b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80035e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800365:	8b 45 08             	mov    0x8(%ebp),%eax
  800368:	01 d0                	add    %edx,%eax
  80036a:	8b 00                	mov    (%eax),%eax
  80036c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  80036f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800372:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800379:	8b 45 08             	mov    0x8(%ebp),%eax
  80037c:	01 c2                	add    %eax,%edx
  80037e:	8b 45 10             	mov    0x10(%ebp),%eax
  800381:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800388:	8b 45 08             	mov    0x8(%ebp),%eax
  80038b:	01 c8                	add    %ecx,%eax
  80038d:	8b 00                	mov    (%eax),%eax
  80038f:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800391:	8b 45 10             	mov    0x10(%ebp),%eax
  800394:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80039b:	8b 45 08             	mov    0x8(%ebp),%eax
  80039e:	01 c2                	add    %eax,%edx
  8003a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003a3:	89 02                	mov    %eax,(%edx)
}
  8003a5:	90                   	nop
  8003a6:	c9                   	leave  
  8003a7:	c3                   	ret    

008003a8 <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  8003a8:	55                   	push   %ebp
  8003a9:	89 e5                	mov    %esp,%ebp
  8003ab:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003ae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003b5:	eb 17                	jmp    8003ce <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  8003b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003ba:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c4:	01 c2                	add    %eax,%edx
  8003c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003c9:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003cb:	ff 45 fc             	incl   -0x4(%ebp)
  8003ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003d1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003d4:	7c e1                	jl     8003b7 <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8003d6:	90                   	nop
  8003d7:	c9                   	leave  
  8003d8:	c3                   	ret    

008003d9 <InitializeIdentical>:

void InitializeIdentical(int *Elements, int NumOfElements)
{
  8003d9:	55                   	push   %ebp
  8003da:	89 e5                	mov    %esp,%ebp
  8003dc:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003df:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003e6:	eb 1b                	jmp    800403 <InitializeIdentical+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8003e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003eb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f5:	01 c2                	add    %eax,%edx
  8003f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003fa:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8003fd:	48                   	dec    %eax
  8003fe:	89 02                	mov    %eax,(%edx)
}

void InitializeIdentical(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800400:	ff 45 fc             	incl   -0x4(%ebp)
  800403:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800406:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800409:	7c dd                	jl     8003e8 <InitializeIdentical+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  80040b:	90                   	nop
  80040c:	c9                   	leave  
  80040d:	c3                   	ret    

0080040e <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  80040e:	55                   	push   %ebp
  80040f:	89 e5                	mov    %esp,%ebp
  800411:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  800414:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800417:	b8 56 55 55 55       	mov    $0x55555556,%eax
  80041c:	f7 e9                	imul   %ecx
  80041e:	c1 f9 1f             	sar    $0x1f,%ecx
  800421:	89 d0                	mov    %edx,%eax
  800423:	29 c8                	sub    %ecx,%eax
  800425:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (Repetition == 0)
  800428:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80042c:	75 07                	jne    800435 <InitializeSemiRandom+0x27>
			Repetition = 3;
  80042e:	c7 45 f8 03 00 00 00 	movl   $0x3,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  800435:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80043c:	eb 1e                	jmp    80045c <InitializeSemiRandom+0x4e>
	{
		Elements[i] = i % Repetition ;
  80043e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800441:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800448:	8b 45 08             	mov    0x8(%ebp),%eax
  80044b:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80044e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800451:	99                   	cltd   
  800452:	f7 7d f8             	idivl  -0x8(%ebp)
  800455:	89 d0                	mov    %edx,%eax
  800457:	89 01                	mov    %eax,(%ecx)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	if (Repetition == 0)
			Repetition = 3;
	for (i = 0 ; i < NumOfElements ; i++)
  800459:	ff 45 fc             	incl   -0x4(%ebp)
  80045c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80045f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800462:	7c da                	jl     80043e <InitializeSemiRandom+0x30>
	{
		Elements[i] = i % Repetition ;
		//	cprintf("i=%d\n",i);
	}

}
  800464:	90                   	nop
  800465:	c9                   	leave  
  800466:	c3                   	ret    

00800467 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  800467:	55                   	push   %ebp
  800468:	89 e5                	mov    %esp,%ebp
  80046a:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  80046d:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800474:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80047b:	eb 42                	jmp    8004bf <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  80047d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800480:	99                   	cltd   
  800481:	f7 7d f0             	idivl  -0x10(%ebp)
  800484:	89 d0                	mov    %edx,%eax
  800486:	85 c0                	test   %eax,%eax
  800488:	75 10                	jne    80049a <PrintElements+0x33>
			cprintf("\n");
  80048a:	83 ec 0c             	sub    $0xc,%esp
  80048d:	68 00 26 80 00       	push   $0x802600
  800492:	e8 65 07 00 00       	call   800bfc <cprintf>
  800497:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  80049a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80049d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a7:	01 d0                	add    %edx,%eax
  8004a9:	8b 00                	mov    (%eax),%eax
  8004ab:	83 ec 08             	sub    $0x8,%esp
  8004ae:	50                   	push   %eax
  8004af:	68 d8 27 80 00       	push   $0x8027d8
  8004b4:	e8 43 07 00 00       	call   800bfc <cprintf>
  8004b9:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  8004bc:	ff 45 f4             	incl   -0xc(%ebp)
  8004bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c2:	48                   	dec    %eax
  8004c3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8004c6:	7f b5                	jg     80047d <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  8004c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004cb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d5:	01 d0                	add    %edx,%eax
  8004d7:	8b 00                	mov    (%eax),%eax
  8004d9:	83 ec 08             	sub    $0x8,%esp
  8004dc:	50                   	push   %eax
  8004dd:	68 4f 26 80 00       	push   $0x80264f
  8004e2:	e8 15 07 00 00       	call   800bfc <cprintf>
  8004e7:	83 c4 10             	add    $0x10,%esp

}
  8004ea:	90                   	nop
  8004eb:	c9                   	leave  
  8004ec:	c3                   	ret    

008004ed <MSort>:


void MSort(int* A, int p, int r)
{
  8004ed:	55                   	push   %ebp
  8004ee:	89 e5                	mov    %esp,%ebp
  8004f0:	83 ec 18             	sub    $0x18,%esp
	if (p >= r)
  8004f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f6:	3b 45 10             	cmp    0x10(%ebp),%eax
  8004f9:	7d 54                	jge    80054f <MSort+0x62>
	{
		return;
	}

	int q = (p + r) / 2;
  8004fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004fe:	8b 45 10             	mov    0x10(%ebp),%eax
  800501:	01 d0                	add    %edx,%eax
  800503:	89 c2                	mov    %eax,%edx
  800505:	c1 ea 1f             	shr    $0x1f,%edx
  800508:	01 d0                	add    %edx,%eax
  80050a:	d1 f8                	sar    %eax
  80050c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	MSort(A, p, q);
  80050f:	83 ec 04             	sub    $0x4,%esp
  800512:	ff 75 f4             	pushl  -0xc(%ebp)
  800515:	ff 75 0c             	pushl  0xc(%ebp)
  800518:	ff 75 08             	pushl  0x8(%ebp)
  80051b:	e8 cd ff ff ff       	call   8004ed <MSort>
  800520:	83 c4 10             	add    $0x10,%esp

	MSort(A, q + 1, r);
  800523:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800526:	40                   	inc    %eax
  800527:	83 ec 04             	sub    $0x4,%esp
  80052a:	ff 75 10             	pushl  0x10(%ebp)
  80052d:	50                   	push   %eax
  80052e:	ff 75 08             	pushl  0x8(%ebp)
  800531:	e8 b7 ff ff ff       	call   8004ed <MSort>
  800536:	83 c4 10             	add    $0x10,%esp

	Merge(A, p, q, r);
  800539:	ff 75 10             	pushl  0x10(%ebp)
  80053c:	ff 75 f4             	pushl  -0xc(%ebp)
  80053f:	ff 75 0c             	pushl  0xc(%ebp)
  800542:	ff 75 08             	pushl  0x8(%ebp)
  800545:	e8 08 00 00 00       	call   800552 <Merge>
  80054a:	83 c4 10             	add    $0x10,%esp
  80054d:	eb 01                	jmp    800550 <MSort+0x63>

void MSort(int* A, int p, int r)
{
	if (p >= r)
	{
		return;
  80054f:	90                   	nop

	MSort(A, q + 1, r);

	Merge(A, p, q, r);

}
  800550:	c9                   	leave  
  800551:	c3                   	ret    

00800552 <Merge>:

void Merge(int* A, int p, int q, int r)
{
  800552:	55                   	push   %ebp
  800553:	89 e5                	mov    %esp,%ebp
  800555:	83 ec 38             	sub    $0x38,%esp
	int leftCapacity = q - p + 1;
  800558:	8b 45 10             	mov    0x10(%ebp),%eax
  80055b:	2b 45 0c             	sub    0xc(%ebp),%eax
  80055e:	40                   	inc    %eax
  80055f:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int rightCapacity = r - q;
  800562:	8b 45 14             	mov    0x14(%ebp),%eax
  800565:	2b 45 10             	sub    0x10(%ebp),%eax
  800568:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int leftIndex = 0;
  80056b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int rightIndex = 0;
  800572:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int* Left = malloc(sizeof(int) * leftCapacity);
  800579:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80057c:	c1 e0 02             	shl    $0x2,%eax
  80057f:	83 ec 0c             	sub    $0xc,%esp
  800582:	50                   	push   %eax
  800583:	e8 36 16 00 00       	call   801bbe <malloc>
  800588:	83 c4 10             	add    $0x10,%esp
  80058b:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* Right = malloc(sizeof(int) * rightCapacity);
  80058e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800591:	c1 e0 02             	shl    $0x2,%eax
  800594:	83 ec 0c             	sub    $0xc,%esp
  800597:	50                   	push   %eax
  800598:	e8 21 16 00 00       	call   801bbe <malloc>
  80059d:	83 c4 10             	add    $0x10,%esp
  8005a0:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	//	int Left[5000] ;
	//	int Right[5000] ;

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  8005a3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8005aa:	eb 2f                	jmp    8005db <Merge+0x89>
	{
		Left[i] = A[p + i - 1];
  8005ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005af:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005b6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005b9:	01 c2                	add    %eax,%edx
  8005bb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005c1:	01 c8                	add    %ecx,%eax
  8005c3:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8005c8:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d2:	01 c8                	add    %ecx,%eax
  8005d4:	8b 00                	mov    (%eax),%eax
  8005d6:	89 02                	mov    %eax,(%edx)

	//	int Left[5000] ;
	//	int Right[5000] ;

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  8005d8:	ff 45 ec             	incl   -0x14(%ebp)
  8005db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005de:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005e1:	7c c9                	jl     8005ac <Merge+0x5a>
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8005e3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005ea:	eb 2a                	jmp    800616 <Merge+0xc4>
	{
		Right[j] = A[q + j];
  8005ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005ef:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005f6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005f9:	01 c2                	add    %eax,%edx
  8005fb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8005fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800601:	01 c8                	add    %ecx,%eax
  800603:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80060a:	8b 45 08             	mov    0x8(%ebp),%eax
  80060d:	01 c8                	add    %ecx,%eax
  80060f:	8b 00                	mov    (%eax),%eax
  800611:	89 02                	mov    %eax,(%edx)
	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  800613:	ff 45 e8             	incl   -0x18(%ebp)
  800616:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800619:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80061c:	7c ce                	jl     8005ec <Merge+0x9a>
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  80061e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800621:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800624:	e9 0a 01 00 00       	jmp    800733 <Merge+0x1e1>
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
  800629:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80062c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80062f:	0f 8d 95 00 00 00    	jge    8006ca <Merge+0x178>
  800635:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800638:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80063b:	0f 8d 89 00 00 00    	jge    8006ca <Merge+0x178>
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800641:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800644:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80064b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80064e:	01 d0                	add    %edx,%eax
  800650:	8b 10                	mov    (%eax),%edx
  800652:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800655:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80065c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80065f:	01 c8                	add    %ecx,%eax
  800661:	8b 00                	mov    (%eax),%eax
  800663:	39 c2                	cmp    %eax,%edx
  800665:	7d 33                	jge    80069a <Merge+0x148>
			{
				A[k - 1] = Left[leftIndex++];
  800667:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80066a:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80066f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800676:	8b 45 08             	mov    0x8(%ebp),%eax
  800679:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80067c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80067f:	8d 50 01             	lea    0x1(%eax),%edx
  800682:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800685:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80068c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80068f:	01 d0                	add    %edx,%eax
  800691:	8b 00                	mov    (%eax),%eax
  800693:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800695:	e9 96 00 00 00       	jmp    800730 <Merge+0x1de>
			{
				A[k - 1] = Left[leftIndex++];
			}
			else
			{
				A[k - 1] = Right[rightIndex++];
  80069a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80069d:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8006a2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ac:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006b2:	8d 50 01             	lea    0x1(%eax),%edx
  8006b5:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8006b8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006c2:	01 d0                	add    %edx,%eax
  8006c4:	8b 00                	mov    (%eax),%eax
  8006c6:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  8006c8:	eb 66                	jmp    800730 <Merge+0x1de>
			else
			{
				A[k - 1] = Right[rightIndex++];
			}
		}
		else if (leftIndex < leftCapacity)
  8006ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006cd:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8006d0:	7d 30                	jge    800702 <Merge+0x1b0>
		{
			A[k - 1] = Left[leftIndex++];
  8006d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006d5:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8006da:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e4:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006ea:	8d 50 01             	lea    0x1(%eax),%edx
  8006ed:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8006f0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006f7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006fa:	01 d0                	add    %edx,%eax
  8006fc:	8b 00                	mov    (%eax),%eax
  8006fe:	89 01                	mov    %eax,(%ecx)
  800700:	eb 2e                	jmp    800730 <Merge+0x1de>
		}
		else
		{
			A[k - 1] = Right[rightIndex++];
  800702:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800705:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80070a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800711:	8b 45 08             	mov    0x8(%ebp),%eax
  800714:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800717:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80071a:	8d 50 01             	lea    0x1(%eax),%edx
  80071d:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800720:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800727:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80072a:	01 d0                	add    %edx,%eax
  80072c:	8b 00                	mov    (%eax),%eax
  80072e:	89 01                	mov    %eax,(%ecx)
	for (j = 0; j < rightCapacity; j++)
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  800730:	ff 45 e4             	incl   -0x1c(%ebp)
  800733:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800736:	3b 45 14             	cmp    0x14(%ebp),%eax
  800739:	0f 8e ea fe ff ff    	jle    800629 <Merge+0xd7>
		{
			A[k - 1] = Right[rightIndex++];
		}
	}

}
  80073f:	90                   	nop
  800740:	c9                   	leave  
  800741:	c3                   	ret    

00800742 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  800742:	55                   	push   %ebp
  800743:	89 e5                	mov    %esp,%ebp
  800745:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  800748:	8b 45 08             	mov    0x8(%ebp),%eax
  80074b:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  80074e:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800752:	83 ec 0c             	sub    $0xc,%esp
  800755:	50                   	push   %eax
  800756:	e8 f4 16 00 00       	call   801e4f <sys_cputc>
  80075b:	83 c4 10             	add    $0x10,%esp
}
  80075e:	90                   	nop
  80075f:	c9                   	leave  
  800760:	c3                   	ret    

00800761 <getchar>:


int
getchar(void)
{
  800761:	55                   	push   %ebp
  800762:	89 e5                	mov    %esp,%ebp
  800764:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  800767:	e8 82 15 00 00       	call   801cee <sys_cgetc>
  80076c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  80076f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800772:	c9                   	leave  
  800773:	c3                   	ret    

00800774 <iscons>:

int iscons(int fdnum)
{
  800774:	55                   	push   %ebp
  800775:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  800777:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80077c:	5d                   	pop    %ebp
  80077d:	c3                   	ret    

0080077e <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80077e:	55                   	push   %ebp
  80077f:	89 e5                	mov    %esp,%ebp
  800781:	57                   	push   %edi
  800782:	56                   	push   %esi
  800783:	53                   	push   %ebx
  800784:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800787:	e8 f4 17 00 00       	call   801f80 <sys_getenvindex>
  80078c:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  80078f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800792:	89 d0                	mov    %edx,%eax
  800794:	c1 e0 02             	shl    $0x2,%eax
  800797:	01 d0                	add    %edx,%eax
  800799:	c1 e0 03             	shl    $0x3,%eax
  80079c:	01 d0                	add    %edx,%eax
  80079e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8007a5:	01 d0                	add    %edx,%eax
  8007a7:	c1 e0 02             	shl    $0x2,%eax
  8007aa:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8007af:	a3 24 40 80 00       	mov    %eax,0x804024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8007b4:	a1 24 40 80 00       	mov    0x804024,%eax
  8007b9:	8a 40 20             	mov    0x20(%eax),%al
  8007bc:	84 c0                	test   %al,%al
  8007be:	74 0d                	je     8007cd <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8007c0:	a1 24 40 80 00       	mov    0x804024,%eax
  8007c5:	83 c0 20             	add    $0x20,%eax
  8007c8:	a3 04 40 80 00       	mov    %eax,0x804004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8007cd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8007d1:	7e 0a                	jle    8007dd <libmain+0x5f>
		binaryname = argv[0];
  8007d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007d6:	8b 00                	mov    (%eax),%eax
  8007d8:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	_main(argc, argv);
  8007dd:	83 ec 08             	sub    $0x8,%esp
  8007e0:	ff 75 0c             	pushl  0xc(%ebp)
  8007e3:	ff 75 08             	pushl  0x8(%ebp)
  8007e6:	e8 4d f8 ff ff       	call   800038 <_main>
  8007eb:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8007ee:	a1 00 40 80 00       	mov    0x804000,%eax
  8007f3:	85 c0                	test   %eax,%eax
  8007f5:	0f 84 01 01 00 00    	je     8008fc <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8007fb:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800801:	bb d8 28 80 00       	mov    $0x8028d8,%ebx
  800806:	ba 0e 00 00 00       	mov    $0xe,%edx
  80080b:	89 c7                	mov    %eax,%edi
  80080d:	89 de                	mov    %ebx,%esi
  80080f:	89 d1                	mov    %edx,%ecx
  800811:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800813:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800816:	b9 56 00 00 00       	mov    $0x56,%ecx
  80081b:	b0 00                	mov    $0x0,%al
  80081d:	89 d7                	mov    %edx,%edi
  80081f:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800821:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800828:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80082b:	83 ec 08             	sub    $0x8,%esp
  80082e:	50                   	push   %eax
  80082f:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800835:	50                   	push   %eax
  800836:	e8 7b 19 00 00       	call   8021b6 <sys_utilities>
  80083b:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  80083e:	e8 c4 14 00 00       	call   801d07 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800843:	83 ec 0c             	sub    $0xc,%esp
  800846:	68 f8 27 80 00       	push   $0x8027f8
  80084b:	e8 ac 03 00 00       	call   800bfc <cprintf>
  800850:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800853:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800856:	85 c0                	test   %eax,%eax
  800858:	74 18                	je     800872 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80085a:	e8 75 19 00 00       	call   8021d4 <sys_get_optimal_num_faults>
  80085f:	83 ec 08             	sub    $0x8,%esp
  800862:	50                   	push   %eax
  800863:	68 20 28 80 00       	push   $0x802820
  800868:	e8 8f 03 00 00       	call   800bfc <cprintf>
  80086d:	83 c4 10             	add    $0x10,%esp
  800870:	eb 59                	jmp    8008cb <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800872:	a1 24 40 80 00       	mov    0x804024,%eax
  800877:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  80087d:	a1 24 40 80 00       	mov    0x804024,%eax
  800882:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  800888:	83 ec 04             	sub    $0x4,%esp
  80088b:	52                   	push   %edx
  80088c:	50                   	push   %eax
  80088d:	68 44 28 80 00       	push   $0x802844
  800892:	e8 65 03 00 00       	call   800bfc <cprintf>
  800897:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80089a:	a1 24 40 80 00       	mov    0x804024,%eax
  80089f:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8008a5:	a1 24 40 80 00       	mov    0x804024,%eax
  8008aa:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  8008b0:	a1 24 40 80 00       	mov    0x804024,%eax
  8008b5:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  8008bb:	51                   	push   %ecx
  8008bc:	52                   	push   %edx
  8008bd:	50                   	push   %eax
  8008be:	68 6c 28 80 00       	push   $0x80286c
  8008c3:	e8 34 03 00 00       	call   800bfc <cprintf>
  8008c8:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8008cb:	a1 24 40 80 00       	mov    0x804024,%eax
  8008d0:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  8008d6:	83 ec 08             	sub    $0x8,%esp
  8008d9:	50                   	push   %eax
  8008da:	68 c4 28 80 00       	push   $0x8028c4
  8008df:	e8 18 03 00 00       	call   800bfc <cprintf>
  8008e4:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8008e7:	83 ec 0c             	sub    $0xc,%esp
  8008ea:	68 f8 27 80 00       	push   $0x8027f8
  8008ef:	e8 08 03 00 00       	call   800bfc <cprintf>
  8008f4:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8008f7:	e8 25 14 00 00       	call   801d21 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8008fc:	e8 1f 00 00 00       	call   800920 <exit>
}
  800901:	90                   	nop
  800902:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800905:	5b                   	pop    %ebx
  800906:	5e                   	pop    %esi
  800907:	5f                   	pop    %edi
  800908:	5d                   	pop    %ebp
  800909:	c3                   	ret    

0080090a <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80090a:	55                   	push   %ebp
  80090b:	89 e5                	mov    %esp,%ebp
  80090d:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800910:	83 ec 0c             	sub    $0xc,%esp
  800913:	6a 00                	push   $0x0
  800915:	e8 32 16 00 00       	call   801f4c <sys_destroy_env>
  80091a:	83 c4 10             	add    $0x10,%esp
}
  80091d:	90                   	nop
  80091e:	c9                   	leave  
  80091f:	c3                   	ret    

00800920 <exit>:

void
exit(void)
{
  800920:	55                   	push   %ebp
  800921:	89 e5                	mov    %esp,%ebp
  800923:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800926:	e8 87 16 00 00       	call   801fb2 <sys_exit_env>
}
  80092b:	90                   	nop
  80092c:	c9                   	leave  
  80092d:	c3                   	ret    

0080092e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80092e:	55                   	push   %ebp
  80092f:	89 e5                	mov    %esp,%ebp
  800931:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800934:	8d 45 10             	lea    0x10(%ebp),%eax
  800937:	83 c0 04             	add    $0x4,%eax
  80093a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80093d:	a1 18 c1 81 00       	mov    0x81c118,%eax
  800942:	85 c0                	test   %eax,%eax
  800944:	74 16                	je     80095c <_panic+0x2e>
		cprintf("%s: ", argv0);
  800946:	a1 18 c1 81 00       	mov    0x81c118,%eax
  80094b:	83 ec 08             	sub    $0x8,%esp
  80094e:	50                   	push   %eax
  80094f:	68 3c 29 80 00       	push   $0x80293c
  800954:	e8 a3 02 00 00       	call   800bfc <cprintf>
  800959:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  80095c:	a1 04 40 80 00       	mov    0x804004,%eax
  800961:	83 ec 0c             	sub    $0xc,%esp
  800964:	ff 75 0c             	pushl  0xc(%ebp)
  800967:	ff 75 08             	pushl  0x8(%ebp)
  80096a:	50                   	push   %eax
  80096b:	68 44 29 80 00       	push   $0x802944
  800970:	6a 74                	push   $0x74
  800972:	e8 b2 02 00 00       	call   800c29 <cprintf_colored>
  800977:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  80097a:	8b 45 10             	mov    0x10(%ebp),%eax
  80097d:	83 ec 08             	sub    $0x8,%esp
  800980:	ff 75 f4             	pushl  -0xc(%ebp)
  800983:	50                   	push   %eax
  800984:	e8 04 02 00 00       	call   800b8d <vcprintf>
  800989:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80098c:	83 ec 08             	sub    $0x8,%esp
  80098f:	6a 00                	push   $0x0
  800991:	68 6c 29 80 00       	push   $0x80296c
  800996:	e8 f2 01 00 00       	call   800b8d <vcprintf>
  80099b:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80099e:	e8 7d ff ff ff       	call   800920 <exit>

	// should not return here
	while (1) ;
  8009a3:	eb fe                	jmp    8009a3 <_panic+0x75>

008009a5 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8009a5:	55                   	push   %ebp
  8009a6:	89 e5                	mov    %esp,%ebp
  8009a8:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8009ab:	a1 24 40 80 00       	mov    0x804024,%eax
  8009b0:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8009b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b9:	39 c2                	cmp    %eax,%edx
  8009bb:	74 14                	je     8009d1 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8009bd:	83 ec 04             	sub    $0x4,%esp
  8009c0:	68 70 29 80 00       	push   $0x802970
  8009c5:	6a 26                	push   $0x26
  8009c7:	68 bc 29 80 00       	push   $0x8029bc
  8009cc:	e8 5d ff ff ff       	call   80092e <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8009d1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8009d8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8009df:	e9 c5 00 00 00       	jmp    800aa9 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8009e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009e7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8009ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f1:	01 d0                	add    %edx,%eax
  8009f3:	8b 00                	mov    (%eax),%eax
  8009f5:	85 c0                	test   %eax,%eax
  8009f7:	75 08                	jne    800a01 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8009f9:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8009fc:	e9 a5 00 00 00       	jmp    800aa6 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800a01:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a08:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800a0f:	eb 69                	jmp    800a7a <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800a11:	a1 24 40 80 00       	mov    0x804024,%eax
  800a16:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800a1c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a1f:	89 d0                	mov    %edx,%eax
  800a21:	01 c0                	add    %eax,%eax
  800a23:	01 d0                	add    %edx,%eax
  800a25:	c1 e0 03             	shl    $0x3,%eax
  800a28:	01 c8                	add    %ecx,%eax
  800a2a:	8a 40 04             	mov    0x4(%eax),%al
  800a2d:	84 c0                	test   %al,%al
  800a2f:	75 46                	jne    800a77 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a31:	a1 24 40 80 00       	mov    0x804024,%eax
  800a36:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800a3c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a3f:	89 d0                	mov    %edx,%eax
  800a41:	01 c0                	add    %eax,%eax
  800a43:	01 d0                	add    %edx,%eax
  800a45:	c1 e0 03             	shl    $0x3,%eax
  800a48:	01 c8                	add    %ecx,%eax
  800a4a:	8b 00                	mov    (%eax),%eax
  800a4c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800a4f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800a52:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800a57:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800a59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a5c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800a63:	8b 45 08             	mov    0x8(%ebp),%eax
  800a66:	01 c8                	add    %ecx,%eax
  800a68:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a6a:	39 c2                	cmp    %eax,%edx
  800a6c:	75 09                	jne    800a77 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800a6e:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800a75:	eb 15                	jmp    800a8c <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a77:	ff 45 e8             	incl   -0x18(%ebp)
  800a7a:	a1 24 40 80 00       	mov    0x804024,%eax
  800a7f:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800a85:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a88:	39 c2                	cmp    %eax,%edx
  800a8a:	77 85                	ja     800a11 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800a8c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800a90:	75 14                	jne    800aa6 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800a92:	83 ec 04             	sub    $0x4,%esp
  800a95:	68 c8 29 80 00       	push   $0x8029c8
  800a9a:	6a 3a                	push   $0x3a
  800a9c:	68 bc 29 80 00       	push   $0x8029bc
  800aa1:	e8 88 fe ff ff       	call   80092e <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800aa6:	ff 45 f0             	incl   -0x10(%ebp)
  800aa9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800aac:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800aaf:	0f 8c 2f ff ff ff    	jl     8009e4 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800ab5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800abc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800ac3:	eb 26                	jmp    800aeb <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800ac5:	a1 24 40 80 00       	mov    0x804024,%eax
  800aca:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800ad0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800ad3:	89 d0                	mov    %edx,%eax
  800ad5:	01 c0                	add    %eax,%eax
  800ad7:	01 d0                	add    %edx,%eax
  800ad9:	c1 e0 03             	shl    $0x3,%eax
  800adc:	01 c8                	add    %ecx,%eax
  800ade:	8a 40 04             	mov    0x4(%eax),%al
  800ae1:	3c 01                	cmp    $0x1,%al
  800ae3:	75 03                	jne    800ae8 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800ae5:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800ae8:	ff 45 e0             	incl   -0x20(%ebp)
  800aeb:	a1 24 40 80 00       	mov    0x804024,%eax
  800af0:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800af6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800af9:	39 c2                	cmp    %eax,%edx
  800afb:	77 c8                	ja     800ac5 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800afd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b00:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800b03:	74 14                	je     800b19 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800b05:	83 ec 04             	sub    $0x4,%esp
  800b08:	68 1c 2a 80 00       	push   $0x802a1c
  800b0d:	6a 44                	push   $0x44
  800b0f:	68 bc 29 80 00       	push   $0x8029bc
  800b14:	e8 15 fe ff ff       	call   80092e <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800b19:	90                   	nop
  800b1a:	c9                   	leave  
  800b1b:	c3                   	ret    

00800b1c <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800b1c:	55                   	push   %ebp
  800b1d:	89 e5                	mov    %esp,%ebp
  800b1f:	53                   	push   %ebx
  800b20:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800b23:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b26:	8b 00                	mov    (%eax),%eax
  800b28:	8d 48 01             	lea    0x1(%eax),%ecx
  800b2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b2e:	89 0a                	mov    %ecx,(%edx)
  800b30:	8b 55 08             	mov    0x8(%ebp),%edx
  800b33:	88 d1                	mov    %dl,%cl
  800b35:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b38:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800b3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3f:	8b 00                	mov    (%eax),%eax
  800b41:	3d ff 00 00 00       	cmp    $0xff,%eax
  800b46:	75 30                	jne    800b78 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800b48:	8b 15 1c c1 81 00    	mov    0x81c11c,%edx
  800b4e:	a0 44 40 80 00       	mov    0x804044,%al
  800b53:	0f b6 c0             	movzbl %al,%eax
  800b56:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b59:	8b 09                	mov    (%ecx),%ecx
  800b5b:	89 cb                	mov    %ecx,%ebx
  800b5d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b60:	83 c1 08             	add    $0x8,%ecx
  800b63:	52                   	push   %edx
  800b64:	50                   	push   %eax
  800b65:	53                   	push   %ebx
  800b66:	51                   	push   %ecx
  800b67:	e8 57 11 00 00       	call   801cc3 <sys_cputs>
  800b6c:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800b6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b72:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800b78:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b7b:	8b 40 04             	mov    0x4(%eax),%eax
  800b7e:	8d 50 01             	lea    0x1(%eax),%edx
  800b81:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b84:	89 50 04             	mov    %edx,0x4(%eax)
}
  800b87:	90                   	nop
  800b88:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b8b:	c9                   	leave  
  800b8c:	c3                   	ret    

00800b8d <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800b8d:	55                   	push   %ebp
  800b8e:	89 e5                	mov    %esp,%ebp
  800b90:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800b96:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800b9d:	00 00 00 
	b.cnt = 0;
  800ba0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800ba7:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800baa:	ff 75 0c             	pushl  0xc(%ebp)
  800bad:	ff 75 08             	pushl  0x8(%ebp)
  800bb0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800bb6:	50                   	push   %eax
  800bb7:	68 1c 0b 80 00       	push   $0x800b1c
  800bbc:	e8 5a 02 00 00       	call   800e1b <vprintfmt>
  800bc1:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800bc4:	8b 15 1c c1 81 00    	mov    0x81c11c,%edx
  800bca:	a0 44 40 80 00       	mov    0x804044,%al
  800bcf:	0f b6 c0             	movzbl %al,%eax
  800bd2:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800bd8:	52                   	push   %edx
  800bd9:	50                   	push   %eax
  800bda:	51                   	push   %ecx
  800bdb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800be1:	83 c0 08             	add    $0x8,%eax
  800be4:	50                   	push   %eax
  800be5:	e8 d9 10 00 00       	call   801cc3 <sys_cputs>
  800bea:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800bed:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
	return b.cnt;
  800bf4:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800bfa:	c9                   	leave  
  800bfb:	c3                   	ret    

00800bfc <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800bfc:	55                   	push   %ebp
  800bfd:	89 e5                	mov    %esp,%ebp
  800bff:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800c02:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	va_start(ap, fmt);
  800c09:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c12:	83 ec 08             	sub    $0x8,%esp
  800c15:	ff 75 f4             	pushl  -0xc(%ebp)
  800c18:	50                   	push   %eax
  800c19:	e8 6f ff ff ff       	call   800b8d <vcprintf>
  800c1e:	83 c4 10             	add    $0x10,%esp
  800c21:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800c24:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c27:	c9                   	leave  
  800c28:	c3                   	ret    

00800c29 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800c29:	55                   	push   %ebp
  800c2a:	89 e5                	mov    %esp,%ebp
  800c2c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800c2f:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800c36:	8b 45 08             	mov    0x8(%ebp),%eax
  800c39:	c1 e0 08             	shl    $0x8,%eax
  800c3c:	a3 1c c1 81 00       	mov    %eax,0x81c11c
	va_start(ap, fmt);
  800c41:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c44:	83 c0 04             	add    $0x4,%eax
  800c47:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800c4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c4d:	83 ec 08             	sub    $0x8,%esp
  800c50:	ff 75 f4             	pushl  -0xc(%ebp)
  800c53:	50                   	push   %eax
  800c54:	e8 34 ff ff ff       	call   800b8d <vcprintf>
  800c59:	83 c4 10             	add    $0x10,%esp
  800c5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800c5f:	c7 05 1c c1 81 00 00 	movl   $0x700,0x81c11c
  800c66:	07 00 00 

	return cnt;
  800c69:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c6c:	c9                   	leave  
  800c6d:	c3                   	ret    

00800c6e <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800c6e:	55                   	push   %ebp
  800c6f:	89 e5                	mov    %esp,%ebp
  800c71:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800c74:	e8 8e 10 00 00       	call   801d07 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800c79:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c82:	83 ec 08             	sub    $0x8,%esp
  800c85:	ff 75 f4             	pushl  -0xc(%ebp)
  800c88:	50                   	push   %eax
  800c89:	e8 ff fe ff ff       	call   800b8d <vcprintf>
  800c8e:	83 c4 10             	add    $0x10,%esp
  800c91:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800c94:	e8 88 10 00 00       	call   801d21 <sys_unlock_cons>
	return cnt;
  800c99:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c9c:	c9                   	leave  
  800c9d:	c3                   	ret    

00800c9e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800c9e:	55                   	push   %ebp
  800c9f:	89 e5                	mov    %esp,%ebp
  800ca1:	53                   	push   %ebx
  800ca2:	83 ec 14             	sub    $0x14,%esp
  800ca5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ca8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cab:	8b 45 14             	mov    0x14(%ebp),%eax
  800cae:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800cb1:	8b 45 18             	mov    0x18(%ebp),%eax
  800cb4:	ba 00 00 00 00       	mov    $0x0,%edx
  800cb9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800cbc:	77 55                	ja     800d13 <printnum+0x75>
  800cbe:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800cc1:	72 05                	jb     800cc8 <printnum+0x2a>
  800cc3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800cc6:	77 4b                	ja     800d13 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800cc8:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800ccb:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800cce:	8b 45 18             	mov    0x18(%ebp),%eax
  800cd1:	ba 00 00 00 00       	mov    $0x0,%edx
  800cd6:	52                   	push   %edx
  800cd7:	50                   	push   %eax
  800cd8:	ff 75 f4             	pushl  -0xc(%ebp)
  800cdb:	ff 75 f0             	pushl  -0x10(%ebp)
  800cde:	e8 a9 16 00 00       	call   80238c <__udivdi3>
  800ce3:	83 c4 10             	add    $0x10,%esp
  800ce6:	83 ec 04             	sub    $0x4,%esp
  800ce9:	ff 75 20             	pushl  0x20(%ebp)
  800cec:	53                   	push   %ebx
  800ced:	ff 75 18             	pushl  0x18(%ebp)
  800cf0:	52                   	push   %edx
  800cf1:	50                   	push   %eax
  800cf2:	ff 75 0c             	pushl  0xc(%ebp)
  800cf5:	ff 75 08             	pushl  0x8(%ebp)
  800cf8:	e8 a1 ff ff ff       	call   800c9e <printnum>
  800cfd:	83 c4 20             	add    $0x20,%esp
  800d00:	eb 1a                	jmp    800d1c <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800d02:	83 ec 08             	sub    $0x8,%esp
  800d05:	ff 75 0c             	pushl  0xc(%ebp)
  800d08:	ff 75 20             	pushl  0x20(%ebp)
  800d0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0e:	ff d0                	call   *%eax
  800d10:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800d13:	ff 4d 1c             	decl   0x1c(%ebp)
  800d16:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800d1a:	7f e6                	jg     800d02 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800d1c:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800d1f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d27:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d2a:	53                   	push   %ebx
  800d2b:	51                   	push   %ecx
  800d2c:	52                   	push   %edx
  800d2d:	50                   	push   %eax
  800d2e:	e8 69 17 00 00       	call   80249c <__umoddi3>
  800d33:	83 c4 10             	add    $0x10,%esp
  800d36:	05 94 2c 80 00       	add    $0x802c94,%eax
  800d3b:	8a 00                	mov    (%eax),%al
  800d3d:	0f be c0             	movsbl %al,%eax
  800d40:	83 ec 08             	sub    $0x8,%esp
  800d43:	ff 75 0c             	pushl  0xc(%ebp)
  800d46:	50                   	push   %eax
  800d47:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4a:	ff d0                	call   *%eax
  800d4c:	83 c4 10             	add    $0x10,%esp
}
  800d4f:	90                   	nop
  800d50:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800d53:	c9                   	leave  
  800d54:	c3                   	ret    

00800d55 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800d55:	55                   	push   %ebp
  800d56:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d58:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d5c:	7e 1c                	jle    800d7a <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800d5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d61:	8b 00                	mov    (%eax),%eax
  800d63:	8d 50 08             	lea    0x8(%eax),%edx
  800d66:	8b 45 08             	mov    0x8(%ebp),%eax
  800d69:	89 10                	mov    %edx,(%eax)
  800d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6e:	8b 00                	mov    (%eax),%eax
  800d70:	83 e8 08             	sub    $0x8,%eax
  800d73:	8b 50 04             	mov    0x4(%eax),%edx
  800d76:	8b 00                	mov    (%eax),%eax
  800d78:	eb 40                	jmp    800dba <getuint+0x65>
	else if (lflag)
  800d7a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d7e:	74 1e                	je     800d9e <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800d80:	8b 45 08             	mov    0x8(%ebp),%eax
  800d83:	8b 00                	mov    (%eax),%eax
  800d85:	8d 50 04             	lea    0x4(%eax),%edx
  800d88:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8b:	89 10                	mov    %edx,(%eax)
  800d8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d90:	8b 00                	mov    (%eax),%eax
  800d92:	83 e8 04             	sub    $0x4,%eax
  800d95:	8b 00                	mov    (%eax),%eax
  800d97:	ba 00 00 00 00       	mov    $0x0,%edx
  800d9c:	eb 1c                	jmp    800dba <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800da1:	8b 00                	mov    (%eax),%eax
  800da3:	8d 50 04             	lea    0x4(%eax),%edx
  800da6:	8b 45 08             	mov    0x8(%ebp),%eax
  800da9:	89 10                	mov    %edx,(%eax)
  800dab:	8b 45 08             	mov    0x8(%ebp),%eax
  800dae:	8b 00                	mov    (%eax),%eax
  800db0:	83 e8 04             	sub    $0x4,%eax
  800db3:	8b 00                	mov    (%eax),%eax
  800db5:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800dba:	5d                   	pop    %ebp
  800dbb:	c3                   	ret    

00800dbc <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800dbc:	55                   	push   %ebp
  800dbd:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800dbf:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800dc3:	7e 1c                	jle    800de1 <getint+0x25>
		return va_arg(*ap, long long);
  800dc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc8:	8b 00                	mov    (%eax),%eax
  800dca:	8d 50 08             	lea    0x8(%eax),%edx
  800dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd0:	89 10                	mov    %edx,(%eax)
  800dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd5:	8b 00                	mov    (%eax),%eax
  800dd7:	83 e8 08             	sub    $0x8,%eax
  800dda:	8b 50 04             	mov    0x4(%eax),%edx
  800ddd:	8b 00                	mov    (%eax),%eax
  800ddf:	eb 38                	jmp    800e19 <getint+0x5d>
	else if (lflag)
  800de1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800de5:	74 1a                	je     800e01 <getint+0x45>
		return va_arg(*ap, long);
  800de7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dea:	8b 00                	mov    (%eax),%eax
  800dec:	8d 50 04             	lea    0x4(%eax),%edx
  800def:	8b 45 08             	mov    0x8(%ebp),%eax
  800df2:	89 10                	mov    %edx,(%eax)
  800df4:	8b 45 08             	mov    0x8(%ebp),%eax
  800df7:	8b 00                	mov    (%eax),%eax
  800df9:	83 e8 04             	sub    $0x4,%eax
  800dfc:	8b 00                	mov    (%eax),%eax
  800dfe:	99                   	cltd   
  800dff:	eb 18                	jmp    800e19 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800e01:	8b 45 08             	mov    0x8(%ebp),%eax
  800e04:	8b 00                	mov    (%eax),%eax
  800e06:	8d 50 04             	lea    0x4(%eax),%edx
  800e09:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0c:	89 10                	mov    %edx,(%eax)
  800e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e11:	8b 00                	mov    (%eax),%eax
  800e13:	83 e8 04             	sub    $0x4,%eax
  800e16:	8b 00                	mov    (%eax),%eax
  800e18:	99                   	cltd   
}
  800e19:	5d                   	pop    %ebp
  800e1a:	c3                   	ret    

00800e1b <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800e1b:	55                   	push   %ebp
  800e1c:	89 e5                	mov    %esp,%ebp
  800e1e:	56                   	push   %esi
  800e1f:	53                   	push   %ebx
  800e20:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e23:	eb 17                	jmp    800e3c <vprintfmt+0x21>
			if (ch == '\0')
  800e25:	85 db                	test   %ebx,%ebx
  800e27:	0f 84 c1 03 00 00    	je     8011ee <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800e2d:	83 ec 08             	sub    $0x8,%esp
  800e30:	ff 75 0c             	pushl  0xc(%ebp)
  800e33:	53                   	push   %ebx
  800e34:	8b 45 08             	mov    0x8(%ebp),%eax
  800e37:	ff d0                	call   *%eax
  800e39:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e3c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e3f:	8d 50 01             	lea    0x1(%eax),%edx
  800e42:	89 55 10             	mov    %edx,0x10(%ebp)
  800e45:	8a 00                	mov    (%eax),%al
  800e47:	0f b6 d8             	movzbl %al,%ebx
  800e4a:	83 fb 25             	cmp    $0x25,%ebx
  800e4d:	75 d6                	jne    800e25 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800e4f:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800e53:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800e5a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800e61:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800e68:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800e6f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e72:	8d 50 01             	lea    0x1(%eax),%edx
  800e75:	89 55 10             	mov    %edx,0x10(%ebp)
  800e78:	8a 00                	mov    (%eax),%al
  800e7a:	0f b6 d8             	movzbl %al,%ebx
  800e7d:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800e80:	83 f8 5b             	cmp    $0x5b,%eax
  800e83:	0f 87 3d 03 00 00    	ja     8011c6 <vprintfmt+0x3ab>
  800e89:	8b 04 85 b8 2c 80 00 	mov    0x802cb8(,%eax,4),%eax
  800e90:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800e92:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800e96:	eb d7                	jmp    800e6f <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800e98:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800e9c:	eb d1                	jmp    800e6f <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e9e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800ea5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800ea8:	89 d0                	mov    %edx,%eax
  800eaa:	c1 e0 02             	shl    $0x2,%eax
  800ead:	01 d0                	add    %edx,%eax
  800eaf:	01 c0                	add    %eax,%eax
  800eb1:	01 d8                	add    %ebx,%eax
  800eb3:	83 e8 30             	sub    $0x30,%eax
  800eb6:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800eb9:	8b 45 10             	mov    0x10(%ebp),%eax
  800ebc:	8a 00                	mov    (%eax),%al
  800ebe:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800ec1:	83 fb 2f             	cmp    $0x2f,%ebx
  800ec4:	7e 3e                	jle    800f04 <vprintfmt+0xe9>
  800ec6:	83 fb 39             	cmp    $0x39,%ebx
  800ec9:	7f 39                	jg     800f04 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ecb:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ece:	eb d5                	jmp    800ea5 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800ed0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ed3:	83 c0 04             	add    $0x4,%eax
  800ed6:	89 45 14             	mov    %eax,0x14(%ebp)
  800ed9:	8b 45 14             	mov    0x14(%ebp),%eax
  800edc:	83 e8 04             	sub    $0x4,%eax
  800edf:	8b 00                	mov    (%eax),%eax
  800ee1:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800ee4:	eb 1f                	jmp    800f05 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800ee6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800eea:	79 83                	jns    800e6f <vprintfmt+0x54>
				width = 0;
  800eec:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800ef3:	e9 77 ff ff ff       	jmp    800e6f <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800ef8:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800eff:	e9 6b ff ff ff       	jmp    800e6f <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800f04:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800f05:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f09:	0f 89 60 ff ff ff    	jns    800e6f <vprintfmt+0x54>
				width = precision, precision = -1;
  800f0f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f12:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800f15:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800f1c:	e9 4e ff ff ff       	jmp    800e6f <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800f21:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800f24:	e9 46 ff ff ff       	jmp    800e6f <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800f29:	8b 45 14             	mov    0x14(%ebp),%eax
  800f2c:	83 c0 04             	add    $0x4,%eax
  800f2f:	89 45 14             	mov    %eax,0x14(%ebp)
  800f32:	8b 45 14             	mov    0x14(%ebp),%eax
  800f35:	83 e8 04             	sub    $0x4,%eax
  800f38:	8b 00                	mov    (%eax),%eax
  800f3a:	83 ec 08             	sub    $0x8,%esp
  800f3d:	ff 75 0c             	pushl  0xc(%ebp)
  800f40:	50                   	push   %eax
  800f41:	8b 45 08             	mov    0x8(%ebp),%eax
  800f44:	ff d0                	call   *%eax
  800f46:	83 c4 10             	add    $0x10,%esp
			break;
  800f49:	e9 9b 02 00 00       	jmp    8011e9 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800f4e:	8b 45 14             	mov    0x14(%ebp),%eax
  800f51:	83 c0 04             	add    $0x4,%eax
  800f54:	89 45 14             	mov    %eax,0x14(%ebp)
  800f57:	8b 45 14             	mov    0x14(%ebp),%eax
  800f5a:	83 e8 04             	sub    $0x4,%eax
  800f5d:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800f5f:	85 db                	test   %ebx,%ebx
  800f61:	79 02                	jns    800f65 <vprintfmt+0x14a>
				err = -err;
  800f63:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800f65:	83 fb 64             	cmp    $0x64,%ebx
  800f68:	7f 0b                	jg     800f75 <vprintfmt+0x15a>
  800f6a:	8b 34 9d 00 2b 80 00 	mov    0x802b00(,%ebx,4),%esi
  800f71:	85 f6                	test   %esi,%esi
  800f73:	75 19                	jne    800f8e <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800f75:	53                   	push   %ebx
  800f76:	68 a5 2c 80 00       	push   $0x802ca5
  800f7b:	ff 75 0c             	pushl  0xc(%ebp)
  800f7e:	ff 75 08             	pushl  0x8(%ebp)
  800f81:	e8 70 02 00 00       	call   8011f6 <printfmt>
  800f86:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800f89:	e9 5b 02 00 00       	jmp    8011e9 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800f8e:	56                   	push   %esi
  800f8f:	68 ae 2c 80 00       	push   $0x802cae
  800f94:	ff 75 0c             	pushl  0xc(%ebp)
  800f97:	ff 75 08             	pushl  0x8(%ebp)
  800f9a:	e8 57 02 00 00       	call   8011f6 <printfmt>
  800f9f:	83 c4 10             	add    $0x10,%esp
			break;
  800fa2:	e9 42 02 00 00       	jmp    8011e9 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800fa7:	8b 45 14             	mov    0x14(%ebp),%eax
  800faa:	83 c0 04             	add    $0x4,%eax
  800fad:	89 45 14             	mov    %eax,0x14(%ebp)
  800fb0:	8b 45 14             	mov    0x14(%ebp),%eax
  800fb3:	83 e8 04             	sub    $0x4,%eax
  800fb6:	8b 30                	mov    (%eax),%esi
  800fb8:	85 f6                	test   %esi,%esi
  800fba:	75 05                	jne    800fc1 <vprintfmt+0x1a6>
				p = "(null)";
  800fbc:	be b1 2c 80 00       	mov    $0x802cb1,%esi
			if (width > 0 && padc != '-')
  800fc1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fc5:	7e 6d                	jle    801034 <vprintfmt+0x219>
  800fc7:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800fcb:	74 67                	je     801034 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800fcd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fd0:	83 ec 08             	sub    $0x8,%esp
  800fd3:	50                   	push   %eax
  800fd4:	56                   	push   %esi
  800fd5:	e8 1e 03 00 00       	call   8012f8 <strnlen>
  800fda:	83 c4 10             	add    $0x10,%esp
  800fdd:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800fe0:	eb 16                	jmp    800ff8 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800fe2:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800fe6:	83 ec 08             	sub    $0x8,%esp
  800fe9:	ff 75 0c             	pushl  0xc(%ebp)
  800fec:	50                   	push   %eax
  800fed:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff0:	ff d0                	call   *%eax
  800ff2:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800ff5:	ff 4d e4             	decl   -0x1c(%ebp)
  800ff8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ffc:	7f e4                	jg     800fe2 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ffe:	eb 34                	jmp    801034 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801000:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801004:	74 1c                	je     801022 <vprintfmt+0x207>
  801006:	83 fb 1f             	cmp    $0x1f,%ebx
  801009:	7e 05                	jle    801010 <vprintfmt+0x1f5>
  80100b:	83 fb 7e             	cmp    $0x7e,%ebx
  80100e:	7e 12                	jle    801022 <vprintfmt+0x207>
					putch('?', putdat);
  801010:	83 ec 08             	sub    $0x8,%esp
  801013:	ff 75 0c             	pushl  0xc(%ebp)
  801016:	6a 3f                	push   $0x3f
  801018:	8b 45 08             	mov    0x8(%ebp),%eax
  80101b:	ff d0                	call   *%eax
  80101d:	83 c4 10             	add    $0x10,%esp
  801020:	eb 0f                	jmp    801031 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801022:	83 ec 08             	sub    $0x8,%esp
  801025:	ff 75 0c             	pushl  0xc(%ebp)
  801028:	53                   	push   %ebx
  801029:	8b 45 08             	mov    0x8(%ebp),%eax
  80102c:	ff d0                	call   *%eax
  80102e:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801031:	ff 4d e4             	decl   -0x1c(%ebp)
  801034:	89 f0                	mov    %esi,%eax
  801036:	8d 70 01             	lea    0x1(%eax),%esi
  801039:	8a 00                	mov    (%eax),%al
  80103b:	0f be d8             	movsbl %al,%ebx
  80103e:	85 db                	test   %ebx,%ebx
  801040:	74 24                	je     801066 <vprintfmt+0x24b>
  801042:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801046:	78 b8                	js     801000 <vprintfmt+0x1e5>
  801048:	ff 4d e0             	decl   -0x20(%ebp)
  80104b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80104f:	79 af                	jns    801000 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801051:	eb 13                	jmp    801066 <vprintfmt+0x24b>
				putch(' ', putdat);
  801053:	83 ec 08             	sub    $0x8,%esp
  801056:	ff 75 0c             	pushl  0xc(%ebp)
  801059:	6a 20                	push   $0x20
  80105b:	8b 45 08             	mov    0x8(%ebp),%eax
  80105e:	ff d0                	call   *%eax
  801060:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801063:	ff 4d e4             	decl   -0x1c(%ebp)
  801066:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80106a:	7f e7                	jg     801053 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80106c:	e9 78 01 00 00       	jmp    8011e9 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801071:	83 ec 08             	sub    $0x8,%esp
  801074:	ff 75 e8             	pushl  -0x18(%ebp)
  801077:	8d 45 14             	lea    0x14(%ebp),%eax
  80107a:	50                   	push   %eax
  80107b:	e8 3c fd ff ff       	call   800dbc <getint>
  801080:	83 c4 10             	add    $0x10,%esp
  801083:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801086:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801089:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80108c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80108f:	85 d2                	test   %edx,%edx
  801091:	79 23                	jns    8010b6 <vprintfmt+0x29b>
				putch('-', putdat);
  801093:	83 ec 08             	sub    $0x8,%esp
  801096:	ff 75 0c             	pushl  0xc(%ebp)
  801099:	6a 2d                	push   $0x2d
  80109b:	8b 45 08             	mov    0x8(%ebp),%eax
  80109e:	ff d0                	call   *%eax
  8010a0:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8010a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010a9:	f7 d8                	neg    %eax
  8010ab:	83 d2 00             	adc    $0x0,%edx
  8010ae:	f7 da                	neg    %edx
  8010b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010b3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8010b6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8010bd:	e9 bc 00 00 00       	jmp    80117e <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8010c2:	83 ec 08             	sub    $0x8,%esp
  8010c5:	ff 75 e8             	pushl  -0x18(%ebp)
  8010c8:	8d 45 14             	lea    0x14(%ebp),%eax
  8010cb:	50                   	push   %eax
  8010cc:	e8 84 fc ff ff       	call   800d55 <getuint>
  8010d1:	83 c4 10             	add    $0x10,%esp
  8010d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010d7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8010da:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8010e1:	e9 98 00 00 00       	jmp    80117e <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8010e6:	83 ec 08             	sub    $0x8,%esp
  8010e9:	ff 75 0c             	pushl  0xc(%ebp)
  8010ec:	6a 58                	push   $0x58
  8010ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f1:	ff d0                	call   *%eax
  8010f3:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8010f6:	83 ec 08             	sub    $0x8,%esp
  8010f9:	ff 75 0c             	pushl  0xc(%ebp)
  8010fc:	6a 58                	push   $0x58
  8010fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801101:	ff d0                	call   *%eax
  801103:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801106:	83 ec 08             	sub    $0x8,%esp
  801109:	ff 75 0c             	pushl  0xc(%ebp)
  80110c:	6a 58                	push   $0x58
  80110e:	8b 45 08             	mov    0x8(%ebp),%eax
  801111:	ff d0                	call   *%eax
  801113:	83 c4 10             	add    $0x10,%esp
			break;
  801116:	e9 ce 00 00 00       	jmp    8011e9 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  80111b:	83 ec 08             	sub    $0x8,%esp
  80111e:	ff 75 0c             	pushl  0xc(%ebp)
  801121:	6a 30                	push   $0x30
  801123:	8b 45 08             	mov    0x8(%ebp),%eax
  801126:	ff d0                	call   *%eax
  801128:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80112b:	83 ec 08             	sub    $0x8,%esp
  80112e:	ff 75 0c             	pushl  0xc(%ebp)
  801131:	6a 78                	push   $0x78
  801133:	8b 45 08             	mov    0x8(%ebp),%eax
  801136:	ff d0                	call   *%eax
  801138:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80113b:	8b 45 14             	mov    0x14(%ebp),%eax
  80113e:	83 c0 04             	add    $0x4,%eax
  801141:	89 45 14             	mov    %eax,0x14(%ebp)
  801144:	8b 45 14             	mov    0x14(%ebp),%eax
  801147:	83 e8 04             	sub    $0x4,%eax
  80114a:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80114c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80114f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801156:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80115d:	eb 1f                	jmp    80117e <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80115f:	83 ec 08             	sub    $0x8,%esp
  801162:	ff 75 e8             	pushl  -0x18(%ebp)
  801165:	8d 45 14             	lea    0x14(%ebp),%eax
  801168:	50                   	push   %eax
  801169:	e8 e7 fb ff ff       	call   800d55 <getuint>
  80116e:	83 c4 10             	add    $0x10,%esp
  801171:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801174:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801177:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80117e:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801182:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801185:	83 ec 04             	sub    $0x4,%esp
  801188:	52                   	push   %edx
  801189:	ff 75 e4             	pushl  -0x1c(%ebp)
  80118c:	50                   	push   %eax
  80118d:	ff 75 f4             	pushl  -0xc(%ebp)
  801190:	ff 75 f0             	pushl  -0x10(%ebp)
  801193:	ff 75 0c             	pushl  0xc(%ebp)
  801196:	ff 75 08             	pushl  0x8(%ebp)
  801199:	e8 00 fb ff ff       	call   800c9e <printnum>
  80119e:	83 c4 20             	add    $0x20,%esp
			break;
  8011a1:	eb 46                	jmp    8011e9 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8011a3:	83 ec 08             	sub    $0x8,%esp
  8011a6:	ff 75 0c             	pushl  0xc(%ebp)
  8011a9:	53                   	push   %ebx
  8011aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ad:	ff d0                	call   *%eax
  8011af:	83 c4 10             	add    $0x10,%esp
			break;
  8011b2:	eb 35                	jmp    8011e9 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8011b4:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
			break;
  8011bb:	eb 2c                	jmp    8011e9 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8011bd:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
			break;
  8011c4:	eb 23                	jmp    8011e9 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8011c6:	83 ec 08             	sub    $0x8,%esp
  8011c9:	ff 75 0c             	pushl  0xc(%ebp)
  8011cc:	6a 25                	push   $0x25
  8011ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d1:	ff d0                	call   *%eax
  8011d3:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8011d6:	ff 4d 10             	decl   0x10(%ebp)
  8011d9:	eb 03                	jmp    8011de <vprintfmt+0x3c3>
  8011db:	ff 4d 10             	decl   0x10(%ebp)
  8011de:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e1:	48                   	dec    %eax
  8011e2:	8a 00                	mov    (%eax),%al
  8011e4:	3c 25                	cmp    $0x25,%al
  8011e6:	75 f3                	jne    8011db <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8011e8:	90                   	nop
		}
	}
  8011e9:	e9 35 fc ff ff       	jmp    800e23 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8011ee:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8011ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8011f2:	5b                   	pop    %ebx
  8011f3:	5e                   	pop    %esi
  8011f4:	5d                   	pop    %ebp
  8011f5:	c3                   	ret    

008011f6 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8011f6:	55                   	push   %ebp
  8011f7:	89 e5                	mov    %esp,%ebp
  8011f9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8011fc:	8d 45 10             	lea    0x10(%ebp),%eax
  8011ff:	83 c0 04             	add    $0x4,%eax
  801202:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801205:	8b 45 10             	mov    0x10(%ebp),%eax
  801208:	ff 75 f4             	pushl  -0xc(%ebp)
  80120b:	50                   	push   %eax
  80120c:	ff 75 0c             	pushl  0xc(%ebp)
  80120f:	ff 75 08             	pushl  0x8(%ebp)
  801212:	e8 04 fc ff ff       	call   800e1b <vprintfmt>
  801217:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80121a:	90                   	nop
  80121b:	c9                   	leave  
  80121c:	c3                   	ret    

0080121d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80121d:	55                   	push   %ebp
  80121e:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801220:	8b 45 0c             	mov    0xc(%ebp),%eax
  801223:	8b 40 08             	mov    0x8(%eax),%eax
  801226:	8d 50 01             	lea    0x1(%eax),%edx
  801229:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122c:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80122f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801232:	8b 10                	mov    (%eax),%edx
  801234:	8b 45 0c             	mov    0xc(%ebp),%eax
  801237:	8b 40 04             	mov    0x4(%eax),%eax
  80123a:	39 c2                	cmp    %eax,%edx
  80123c:	73 12                	jae    801250 <sprintputch+0x33>
		*b->buf++ = ch;
  80123e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801241:	8b 00                	mov    (%eax),%eax
  801243:	8d 48 01             	lea    0x1(%eax),%ecx
  801246:	8b 55 0c             	mov    0xc(%ebp),%edx
  801249:	89 0a                	mov    %ecx,(%edx)
  80124b:	8b 55 08             	mov    0x8(%ebp),%edx
  80124e:	88 10                	mov    %dl,(%eax)
}
  801250:	90                   	nop
  801251:	5d                   	pop    %ebp
  801252:	c3                   	ret    

00801253 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801253:	55                   	push   %ebp
  801254:	89 e5                	mov    %esp,%ebp
  801256:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801259:	8b 45 08             	mov    0x8(%ebp),%eax
  80125c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80125f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801262:	8d 50 ff             	lea    -0x1(%eax),%edx
  801265:	8b 45 08             	mov    0x8(%ebp),%eax
  801268:	01 d0                	add    %edx,%eax
  80126a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80126d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801274:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801278:	74 06                	je     801280 <vsnprintf+0x2d>
  80127a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80127e:	7f 07                	jg     801287 <vsnprintf+0x34>
		return -E_INVAL;
  801280:	b8 03 00 00 00       	mov    $0x3,%eax
  801285:	eb 20                	jmp    8012a7 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801287:	ff 75 14             	pushl  0x14(%ebp)
  80128a:	ff 75 10             	pushl  0x10(%ebp)
  80128d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801290:	50                   	push   %eax
  801291:	68 1d 12 80 00       	push   $0x80121d
  801296:	e8 80 fb ff ff       	call   800e1b <vprintfmt>
  80129b:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80129e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8012a1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8012a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8012a7:	c9                   	leave  
  8012a8:	c3                   	ret    

008012a9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8012a9:	55                   	push   %ebp
  8012aa:	89 e5                	mov    %esp,%ebp
  8012ac:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8012af:	8d 45 10             	lea    0x10(%ebp),%eax
  8012b2:	83 c0 04             	add    $0x4,%eax
  8012b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8012b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8012bb:	ff 75 f4             	pushl  -0xc(%ebp)
  8012be:	50                   	push   %eax
  8012bf:	ff 75 0c             	pushl  0xc(%ebp)
  8012c2:	ff 75 08             	pushl  0x8(%ebp)
  8012c5:	e8 89 ff ff ff       	call   801253 <vsnprintf>
  8012ca:	83 c4 10             	add    $0x10,%esp
  8012cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8012d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012d3:	c9                   	leave  
  8012d4:	c3                   	ret    

008012d5 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8012d5:	55                   	push   %ebp
  8012d6:	89 e5                	mov    %esp,%ebp
  8012d8:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8012db:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012e2:	eb 06                	jmp    8012ea <strlen+0x15>
		n++;
  8012e4:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8012e7:	ff 45 08             	incl   0x8(%ebp)
  8012ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ed:	8a 00                	mov    (%eax),%al
  8012ef:	84 c0                	test   %al,%al
  8012f1:	75 f1                	jne    8012e4 <strlen+0xf>
		n++;
	return n;
  8012f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012f6:	c9                   	leave  
  8012f7:	c3                   	ret    

008012f8 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8012f8:	55                   	push   %ebp
  8012f9:	89 e5                	mov    %esp,%ebp
  8012fb:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012fe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801305:	eb 09                	jmp    801310 <strnlen+0x18>
		n++;
  801307:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80130a:	ff 45 08             	incl   0x8(%ebp)
  80130d:	ff 4d 0c             	decl   0xc(%ebp)
  801310:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801314:	74 09                	je     80131f <strnlen+0x27>
  801316:	8b 45 08             	mov    0x8(%ebp),%eax
  801319:	8a 00                	mov    (%eax),%al
  80131b:	84 c0                	test   %al,%al
  80131d:	75 e8                	jne    801307 <strnlen+0xf>
		n++;
	return n;
  80131f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801322:	c9                   	leave  
  801323:	c3                   	ret    

00801324 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801324:	55                   	push   %ebp
  801325:	89 e5                	mov    %esp,%ebp
  801327:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80132a:	8b 45 08             	mov    0x8(%ebp),%eax
  80132d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801330:	90                   	nop
  801331:	8b 45 08             	mov    0x8(%ebp),%eax
  801334:	8d 50 01             	lea    0x1(%eax),%edx
  801337:	89 55 08             	mov    %edx,0x8(%ebp)
  80133a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80133d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801340:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801343:	8a 12                	mov    (%edx),%dl
  801345:	88 10                	mov    %dl,(%eax)
  801347:	8a 00                	mov    (%eax),%al
  801349:	84 c0                	test   %al,%al
  80134b:	75 e4                	jne    801331 <strcpy+0xd>
		/* do nothing */;
	return ret;
  80134d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801350:	c9                   	leave  
  801351:	c3                   	ret    

00801352 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801352:	55                   	push   %ebp
  801353:	89 e5                	mov    %esp,%ebp
  801355:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801358:	8b 45 08             	mov    0x8(%ebp),%eax
  80135b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80135e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801365:	eb 1f                	jmp    801386 <strncpy+0x34>
		*dst++ = *src;
  801367:	8b 45 08             	mov    0x8(%ebp),%eax
  80136a:	8d 50 01             	lea    0x1(%eax),%edx
  80136d:	89 55 08             	mov    %edx,0x8(%ebp)
  801370:	8b 55 0c             	mov    0xc(%ebp),%edx
  801373:	8a 12                	mov    (%edx),%dl
  801375:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801377:	8b 45 0c             	mov    0xc(%ebp),%eax
  80137a:	8a 00                	mov    (%eax),%al
  80137c:	84 c0                	test   %al,%al
  80137e:	74 03                	je     801383 <strncpy+0x31>
			src++;
  801380:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801383:	ff 45 fc             	incl   -0x4(%ebp)
  801386:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801389:	3b 45 10             	cmp    0x10(%ebp),%eax
  80138c:	72 d9                	jb     801367 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80138e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801391:	c9                   	leave  
  801392:	c3                   	ret    

00801393 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801393:	55                   	push   %ebp
  801394:	89 e5                	mov    %esp,%ebp
  801396:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801399:	8b 45 08             	mov    0x8(%ebp),%eax
  80139c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80139f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013a3:	74 30                	je     8013d5 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8013a5:	eb 16                	jmp    8013bd <strlcpy+0x2a>
			*dst++ = *src++;
  8013a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013aa:	8d 50 01             	lea    0x1(%eax),%edx
  8013ad:	89 55 08             	mov    %edx,0x8(%ebp)
  8013b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013b3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013b6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8013b9:	8a 12                	mov    (%edx),%dl
  8013bb:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8013bd:	ff 4d 10             	decl   0x10(%ebp)
  8013c0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013c4:	74 09                	je     8013cf <strlcpy+0x3c>
  8013c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c9:	8a 00                	mov    (%eax),%al
  8013cb:	84 c0                	test   %al,%al
  8013cd:	75 d8                	jne    8013a7 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8013cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d2:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8013d5:	8b 55 08             	mov    0x8(%ebp),%edx
  8013d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013db:	29 c2                	sub    %eax,%edx
  8013dd:	89 d0                	mov    %edx,%eax
}
  8013df:	c9                   	leave  
  8013e0:	c3                   	ret    

008013e1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8013e1:	55                   	push   %ebp
  8013e2:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8013e4:	eb 06                	jmp    8013ec <strcmp+0xb>
		p++, q++;
  8013e6:	ff 45 08             	incl   0x8(%ebp)
  8013e9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8013ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ef:	8a 00                	mov    (%eax),%al
  8013f1:	84 c0                	test   %al,%al
  8013f3:	74 0e                	je     801403 <strcmp+0x22>
  8013f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f8:	8a 10                	mov    (%eax),%dl
  8013fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013fd:	8a 00                	mov    (%eax),%al
  8013ff:	38 c2                	cmp    %al,%dl
  801401:	74 e3                	je     8013e6 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801403:	8b 45 08             	mov    0x8(%ebp),%eax
  801406:	8a 00                	mov    (%eax),%al
  801408:	0f b6 d0             	movzbl %al,%edx
  80140b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80140e:	8a 00                	mov    (%eax),%al
  801410:	0f b6 c0             	movzbl %al,%eax
  801413:	29 c2                	sub    %eax,%edx
  801415:	89 d0                	mov    %edx,%eax
}
  801417:	5d                   	pop    %ebp
  801418:	c3                   	ret    

00801419 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801419:	55                   	push   %ebp
  80141a:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80141c:	eb 09                	jmp    801427 <strncmp+0xe>
		n--, p++, q++;
  80141e:	ff 4d 10             	decl   0x10(%ebp)
  801421:	ff 45 08             	incl   0x8(%ebp)
  801424:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801427:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80142b:	74 17                	je     801444 <strncmp+0x2b>
  80142d:	8b 45 08             	mov    0x8(%ebp),%eax
  801430:	8a 00                	mov    (%eax),%al
  801432:	84 c0                	test   %al,%al
  801434:	74 0e                	je     801444 <strncmp+0x2b>
  801436:	8b 45 08             	mov    0x8(%ebp),%eax
  801439:	8a 10                	mov    (%eax),%dl
  80143b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80143e:	8a 00                	mov    (%eax),%al
  801440:	38 c2                	cmp    %al,%dl
  801442:	74 da                	je     80141e <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801444:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801448:	75 07                	jne    801451 <strncmp+0x38>
		return 0;
  80144a:	b8 00 00 00 00       	mov    $0x0,%eax
  80144f:	eb 14                	jmp    801465 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801451:	8b 45 08             	mov    0x8(%ebp),%eax
  801454:	8a 00                	mov    (%eax),%al
  801456:	0f b6 d0             	movzbl %al,%edx
  801459:	8b 45 0c             	mov    0xc(%ebp),%eax
  80145c:	8a 00                	mov    (%eax),%al
  80145e:	0f b6 c0             	movzbl %al,%eax
  801461:	29 c2                	sub    %eax,%edx
  801463:	89 d0                	mov    %edx,%eax
}
  801465:	5d                   	pop    %ebp
  801466:	c3                   	ret    

00801467 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801467:	55                   	push   %ebp
  801468:	89 e5                	mov    %esp,%ebp
  80146a:	83 ec 04             	sub    $0x4,%esp
  80146d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801470:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801473:	eb 12                	jmp    801487 <strchr+0x20>
		if (*s == c)
  801475:	8b 45 08             	mov    0x8(%ebp),%eax
  801478:	8a 00                	mov    (%eax),%al
  80147a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80147d:	75 05                	jne    801484 <strchr+0x1d>
			return (char *) s;
  80147f:	8b 45 08             	mov    0x8(%ebp),%eax
  801482:	eb 11                	jmp    801495 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801484:	ff 45 08             	incl   0x8(%ebp)
  801487:	8b 45 08             	mov    0x8(%ebp),%eax
  80148a:	8a 00                	mov    (%eax),%al
  80148c:	84 c0                	test   %al,%al
  80148e:	75 e5                	jne    801475 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801490:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801495:	c9                   	leave  
  801496:	c3                   	ret    

00801497 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801497:	55                   	push   %ebp
  801498:	89 e5                	mov    %esp,%ebp
  80149a:	83 ec 04             	sub    $0x4,%esp
  80149d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a0:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8014a3:	eb 0d                	jmp    8014b2 <strfind+0x1b>
		if (*s == c)
  8014a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a8:	8a 00                	mov    (%eax),%al
  8014aa:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8014ad:	74 0e                	je     8014bd <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8014af:	ff 45 08             	incl   0x8(%ebp)
  8014b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b5:	8a 00                	mov    (%eax),%al
  8014b7:	84 c0                	test   %al,%al
  8014b9:	75 ea                	jne    8014a5 <strfind+0xe>
  8014bb:	eb 01                	jmp    8014be <strfind+0x27>
		if (*s == c)
			break;
  8014bd:	90                   	nop
	return (char *) s;
  8014be:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014c1:	c9                   	leave  
  8014c2:	c3                   	ret    

008014c3 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  8014c3:	55                   	push   %ebp
  8014c4:	89 e5                	mov    %esp,%ebp
  8014c6:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  8014c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  8014cf:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8014d3:	76 63                	jbe    801538 <memset+0x75>
		uint64 data_block = c;
  8014d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d8:	99                   	cltd   
  8014d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014dc:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  8014df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014e5:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  8014e9:	c1 e0 08             	shl    $0x8,%eax
  8014ec:	09 45 f0             	or     %eax,-0x10(%ebp)
  8014ef:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  8014f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014f8:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  8014fc:	c1 e0 10             	shl    $0x10,%eax
  8014ff:	09 45 f0             	or     %eax,-0x10(%ebp)
  801502:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801505:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801508:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80150b:	89 c2                	mov    %eax,%edx
  80150d:	b8 00 00 00 00       	mov    $0x0,%eax
  801512:	09 45 f0             	or     %eax,-0x10(%ebp)
  801515:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801518:	eb 18                	jmp    801532 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  80151a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80151d:	8d 41 08             	lea    0x8(%ecx),%eax
  801520:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801523:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801526:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801529:	89 01                	mov    %eax,(%ecx)
  80152b:	89 51 04             	mov    %edx,0x4(%ecx)
  80152e:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801532:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801536:	77 e2                	ja     80151a <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801538:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80153c:	74 23                	je     801561 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  80153e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801541:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801544:	eb 0e                	jmp    801554 <memset+0x91>
			*p8++ = (uint8)c;
  801546:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801549:	8d 50 01             	lea    0x1(%eax),%edx
  80154c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80154f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801552:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801554:	8b 45 10             	mov    0x10(%ebp),%eax
  801557:	8d 50 ff             	lea    -0x1(%eax),%edx
  80155a:	89 55 10             	mov    %edx,0x10(%ebp)
  80155d:	85 c0                	test   %eax,%eax
  80155f:	75 e5                	jne    801546 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801561:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801564:	c9                   	leave  
  801565:	c3                   	ret    

00801566 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801566:	55                   	push   %ebp
  801567:	89 e5                	mov    %esp,%ebp
  801569:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  80156c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80156f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801572:	8b 45 08             	mov    0x8(%ebp),%eax
  801575:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801578:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80157c:	76 24                	jbe    8015a2 <memcpy+0x3c>
		while(n >= 8){
  80157e:	eb 1c                	jmp    80159c <memcpy+0x36>
			*d64 = *s64;
  801580:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801583:	8b 50 04             	mov    0x4(%eax),%edx
  801586:	8b 00                	mov    (%eax),%eax
  801588:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80158b:	89 01                	mov    %eax,(%ecx)
  80158d:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801590:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801594:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801598:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  80159c:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8015a0:	77 de                	ja     801580 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8015a2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015a6:	74 31                	je     8015d9 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8015a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8015ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8015b4:	eb 16                	jmp    8015cc <memcpy+0x66>
			*d8++ = *s8++;
  8015b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015b9:	8d 50 01             	lea    0x1(%eax),%edx
  8015bc:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8015bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015c2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8015c5:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8015c8:	8a 12                	mov    (%edx),%dl
  8015ca:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  8015cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8015cf:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015d2:	89 55 10             	mov    %edx,0x10(%ebp)
  8015d5:	85 c0                	test   %eax,%eax
  8015d7:	75 dd                	jne    8015b6 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  8015d9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015dc:	c9                   	leave  
  8015dd:	c3                   	ret    

008015de <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8015de:	55                   	push   %ebp
  8015df:	89 e5                	mov    %esp,%ebp
  8015e1:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8015e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8015ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ed:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8015f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015f3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8015f6:	73 50                	jae    801648 <memmove+0x6a>
  8015f8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8015fe:	01 d0                	add    %edx,%eax
  801600:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801603:	76 43                	jbe    801648 <memmove+0x6a>
		s += n;
  801605:	8b 45 10             	mov    0x10(%ebp),%eax
  801608:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80160b:	8b 45 10             	mov    0x10(%ebp),%eax
  80160e:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801611:	eb 10                	jmp    801623 <memmove+0x45>
			*--d = *--s;
  801613:	ff 4d f8             	decl   -0x8(%ebp)
  801616:	ff 4d fc             	decl   -0x4(%ebp)
  801619:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80161c:	8a 10                	mov    (%eax),%dl
  80161e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801621:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801623:	8b 45 10             	mov    0x10(%ebp),%eax
  801626:	8d 50 ff             	lea    -0x1(%eax),%edx
  801629:	89 55 10             	mov    %edx,0x10(%ebp)
  80162c:	85 c0                	test   %eax,%eax
  80162e:	75 e3                	jne    801613 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801630:	eb 23                	jmp    801655 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801632:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801635:	8d 50 01             	lea    0x1(%eax),%edx
  801638:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80163b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80163e:	8d 4a 01             	lea    0x1(%edx),%ecx
  801641:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801644:	8a 12                	mov    (%edx),%dl
  801646:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801648:	8b 45 10             	mov    0x10(%ebp),%eax
  80164b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80164e:	89 55 10             	mov    %edx,0x10(%ebp)
  801651:	85 c0                	test   %eax,%eax
  801653:	75 dd                	jne    801632 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801655:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801658:	c9                   	leave  
  801659:	c3                   	ret    

0080165a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80165a:	55                   	push   %ebp
  80165b:	89 e5                	mov    %esp,%ebp
  80165d:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801660:	8b 45 08             	mov    0x8(%ebp),%eax
  801663:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801666:	8b 45 0c             	mov    0xc(%ebp),%eax
  801669:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80166c:	eb 2a                	jmp    801698 <memcmp+0x3e>
		if (*s1 != *s2)
  80166e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801671:	8a 10                	mov    (%eax),%dl
  801673:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801676:	8a 00                	mov    (%eax),%al
  801678:	38 c2                	cmp    %al,%dl
  80167a:	74 16                	je     801692 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80167c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80167f:	8a 00                	mov    (%eax),%al
  801681:	0f b6 d0             	movzbl %al,%edx
  801684:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801687:	8a 00                	mov    (%eax),%al
  801689:	0f b6 c0             	movzbl %al,%eax
  80168c:	29 c2                	sub    %eax,%edx
  80168e:	89 d0                	mov    %edx,%eax
  801690:	eb 18                	jmp    8016aa <memcmp+0x50>
		s1++, s2++;
  801692:	ff 45 fc             	incl   -0x4(%ebp)
  801695:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801698:	8b 45 10             	mov    0x10(%ebp),%eax
  80169b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80169e:	89 55 10             	mov    %edx,0x10(%ebp)
  8016a1:	85 c0                	test   %eax,%eax
  8016a3:	75 c9                	jne    80166e <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8016a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016aa:	c9                   	leave  
  8016ab:	c3                   	ret    

008016ac <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8016ac:	55                   	push   %ebp
  8016ad:	89 e5                	mov    %esp,%ebp
  8016af:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8016b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8016b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b8:	01 d0                	add    %edx,%eax
  8016ba:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8016bd:	eb 15                	jmp    8016d4 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8016bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c2:	8a 00                	mov    (%eax),%al
  8016c4:	0f b6 d0             	movzbl %al,%edx
  8016c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016ca:	0f b6 c0             	movzbl %al,%eax
  8016cd:	39 c2                	cmp    %eax,%edx
  8016cf:	74 0d                	je     8016de <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8016d1:	ff 45 08             	incl   0x8(%ebp)
  8016d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8016da:	72 e3                	jb     8016bf <memfind+0x13>
  8016dc:	eb 01                	jmp    8016df <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8016de:	90                   	nop
	return (void *) s;
  8016df:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016e2:	c9                   	leave  
  8016e3:	c3                   	ret    

008016e4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8016e4:	55                   	push   %ebp
  8016e5:	89 e5                	mov    %esp,%ebp
  8016e7:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8016ea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8016f1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8016f8:	eb 03                	jmp    8016fd <strtol+0x19>
		s++;
  8016fa:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8016fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801700:	8a 00                	mov    (%eax),%al
  801702:	3c 20                	cmp    $0x20,%al
  801704:	74 f4                	je     8016fa <strtol+0x16>
  801706:	8b 45 08             	mov    0x8(%ebp),%eax
  801709:	8a 00                	mov    (%eax),%al
  80170b:	3c 09                	cmp    $0x9,%al
  80170d:	74 eb                	je     8016fa <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80170f:	8b 45 08             	mov    0x8(%ebp),%eax
  801712:	8a 00                	mov    (%eax),%al
  801714:	3c 2b                	cmp    $0x2b,%al
  801716:	75 05                	jne    80171d <strtol+0x39>
		s++;
  801718:	ff 45 08             	incl   0x8(%ebp)
  80171b:	eb 13                	jmp    801730 <strtol+0x4c>
	else if (*s == '-')
  80171d:	8b 45 08             	mov    0x8(%ebp),%eax
  801720:	8a 00                	mov    (%eax),%al
  801722:	3c 2d                	cmp    $0x2d,%al
  801724:	75 0a                	jne    801730 <strtol+0x4c>
		s++, neg = 1;
  801726:	ff 45 08             	incl   0x8(%ebp)
  801729:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801730:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801734:	74 06                	je     80173c <strtol+0x58>
  801736:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80173a:	75 20                	jne    80175c <strtol+0x78>
  80173c:	8b 45 08             	mov    0x8(%ebp),%eax
  80173f:	8a 00                	mov    (%eax),%al
  801741:	3c 30                	cmp    $0x30,%al
  801743:	75 17                	jne    80175c <strtol+0x78>
  801745:	8b 45 08             	mov    0x8(%ebp),%eax
  801748:	40                   	inc    %eax
  801749:	8a 00                	mov    (%eax),%al
  80174b:	3c 78                	cmp    $0x78,%al
  80174d:	75 0d                	jne    80175c <strtol+0x78>
		s += 2, base = 16;
  80174f:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801753:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80175a:	eb 28                	jmp    801784 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80175c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801760:	75 15                	jne    801777 <strtol+0x93>
  801762:	8b 45 08             	mov    0x8(%ebp),%eax
  801765:	8a 00                	mov    (%eax),%al
  801767:	3c 30                	cmp    $0x30,%al
  801769:	75 0c                	jne    801777 <strtol+0x93>
		s++, base = 8;
  80176b:	ff 45 08             	incl   0x8(%ebp)
  80176e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801775:	eb 0d                	jmp    801784 <strtol+0xa0>
	else if (base == 0)
  801777:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80177b:	75 07                	jne    801784 <strtol+0xa0>
		base = 10;
  80177d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801784:	8b 45 08             	mov    0x8(%ebp),%eax
  801787:	8a 00                	mov    (%eax),%al
  801789:	3c 2f                	cmp    $0x2f,%al
  80178b:	7e 19                	jle    8017a6 <strtol+0xc2>
  80178d:	8b 45 08             	mov    0x8(%ebp),%eax
  801790:	8a 00                	mov    (%eax),%al
  801792:	3c 39                	cmp    $0x39,%al
  801794:	7f 10                	jg     8017a6 <strtol+0xc2>
			dig = *s - '0';
  801796:	8b 45 08             	mov    0x8(%ebp),%eax
  801799:	8a 00                	mov    (%eax),%al
  80179b:	0f be c0             	movsbl %al,%eax
  80179e:	83 e8 30             	sub    $0x30,%eax
  8017a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017a4:	eb 42                	jmp    8017e8 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8017a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a9:	8a 00                	mov    (%eax),%al
  8017ab:	3c 60                	cmp    $0x60,%al
  8017ad:	7e 19                	jle    8017c8 <strtol+0xe4>
  8017af:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b2:	8a 00                	mov    (%eax),%al
  8017b4:	3c 7a                	cmp    $0x7a,%al
  8017b6:	7f 10                	jg     8017c8 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8017b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bb:	8a 00                	mov    (%eax),%al
  8017bd:	0f be c0             	movsbl %al,%eax
  8017c0:	83 e8 57             	sub    $0x57,%eax
  8017c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017c6:	eb 20                	jmp    8017e8 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8017c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cb:	8a 00                	mov    (%eax),%al
  8017cd:	3c 40                	cmp    $0x40,%al
  8017cf:	7e 39                	jle    80180a <strtol+0x126>
  8017d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d4:	8a 00                	mov    (%eax),%al
  8017d6:	3c 5a                	cmp    $0x5a,%al
  8017d8:	7f 30                	jg     80180a <strtol+0x126>
			dig = *s - 'A' + 10;
  8017da:	8b 45 08             	mov    0x8(%ebp),%eax
  8017dd:	8a 00                	mov    (%eax),%al
  8017df:	0f be c0             	movsbl %al,%eax
  8017e2:	83 e8 37             	sub    $0x37,%eax
  8017e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8017e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017eb:	3b 45 10             	cmp    0x10(%ebp),%eax
  8017ee:	7d 19                	jge    801809 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8017f0:	ff 45 08             	incl   0x8(%ebp)
  8017f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017f6:	0f af 45 10          	imul   0x10(%ebp),%eax
  8017fa:	89 c2                	mov    %eax,%edx
  8017fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017ff:	01 d0                	add    %edx,%eax
  801801:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801804:	e9 7b ff ff ff       	jmp    801784 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801809:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80180a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80180e:	74 08                	je     801818 <strtol+0x134>
		*endptr = (char *) s;
  801810:	8b 45 0c             	mov    0xc(%ebp),%eax
  801813:	8b 55 08             	mov    0x8(%ebp),%edx
  801816:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801818:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80181c:	74 07                	je     801825 <strtol+0x141>
  80181e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801821:	f7 d8                	neg    %eax
  801823:	eb 03                	jmp    801828 <strtol+0x144>
  801825:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801828:	c9                   	leave  
  801829:	c3                   	ret    

0080182a <ltostr>:

void
ltostr(long value, char *str)
{
  80182a:	55                   	push   %ebp
  80182b:	89 e5                	mov    %esp,%ebp
  80182d:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801830:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801837:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80183e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801842:	79 13                	jns    801857 <ltostr+0x2d>
	{
		neg = 1;
  801844:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80184b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80184e:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801851:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801854:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801857:	8b 45 08             	mov    0x8(%ebp),%eax
  80185a:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80185f:	99                   	cltd   
  801860:	f7 f9                	idiv   %ecx
  801862:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801865:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801868:	8d 50 01             	lea    0x1(%eax),%edx
  80186b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80186e:	89 c2                	mov    %eax,%edx
  801870:	8b 45 0c             	mov    0xc(%ebp),%eax
  801873:	01 d0                	add    %edx,%eax
  801875:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801878:	83 c2 30             	add    $0x30,%edx
  80187b:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80187d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801880:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801885:	f7 e9                	imul   %ecx
  801887:	c1 fa 02             	sar    $0x2,%edx
  80188a:	89 c8                	mov    %ecx,%eax
  80188c:	c1 f8 1f             	sar    $0x1f,%eax
  80188f:	29 c2                	sub    %eax,%edx
  801891:	89 d0                	mov    %edx,%eax
  801893:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801896:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80189a:	75 bb                	jne    801857 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80189c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8018a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018a6:	48                   	dec    %eax
  8018a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8018aa:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8018ae:	74 3d                	je     8018ed <ltostr+0xc3>
		start = 1 ;
  8018b0:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8018b7:	eb 34                	jmp    8018ed <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8018b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018bf:	01 d0                	add    %edx,%eax
  8018c1:	8a 00                	mov    (%eax),%al
  8018c3:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8018c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018cc:	01 c2                	add    %eax,%edx
  8018ce:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8018d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018d4:	01 c8                	add    %ecx,%eax
  8018d6:	8a 00                	mov    (%eax),%al
  8018d8:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8018da:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018e0:	01 c2                	add    %eax,%edx
  8018e2:	8a 45 eb             	mov    -0x15(%ebp),%al
  8018e5:	88 02                	mov    %al,(%edx)
		start++ ;
  8018e7:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8018ea:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8018ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018f0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8018f3:	7c c4                	jl     8018b9 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8018f5:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8018f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018fb:	01 d0                	add    %edx,%eax
  8018fd:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801900:	90                   	nop
  801901:	c9                   	leave  
  801902:	c3                   	ret    

00801903 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801903:	55                   	push   %ebp
  801904:	89 e5                	mov    %esp,%ebp
  801906:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801909:	ff 75 08             	pushl  0x8(%ebp)
  80190c:	e8 c4 f9 ff ff       	call   8012d5 <strlen>
  801911:	83 c4 04             	add    $0x4,%esp
  801914:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801917:	ff 75 0c             	pushl  0xc(%ebp)
  80191a:	e8 b6 f9 ff ff       	call   8012d5 <strlen>
  80191f:	83 c4 04             	add    $0x4,%esp
  801922:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801925:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80192c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801933:	eb 17                	jmp    80194c <strcconcat+0x49>
		final[s] = str1[s] ;
  801935:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801938:	8b 45 10             	mov    0x10(%ebp),%eax
  80193b:	01 c2                	add    %eax,%edx
  80193d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801940:	8b 45 08             	mov    0x8(%ebp),%eax
  801943:	01 c8                	add    %ecx,%eax
  801945:	8a 00                	mov    (%eax),%al
  801947:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801949:	ff 45 fc             	incl   -0x4(%ebp)
  80194c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80194f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801952:	7c e1                	jl     801935 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801954:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80195b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801962:	eb 1f                	jmp    801983 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801964:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801967:	8d 50 01             	lea    0x1(%eax),%edx
  80196a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80196d:	89 c2                	mov    %eax,%edx
  80196f:	8b 45 10             	mov    0x10(%ebp),%eax
  801972:	01 c2                	add    %eax,%edx
  801974:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801977:	8b 45 0c             	mov    0xc(%ebp),%eax
  80197a:	01 c8                	add    %ecx,%eax
  80197c:	8a 00                	mov    (%eax),%al
  80197e:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801980:	ff 45 f8             	incl   -0x8(%ebp)
  801983:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801986:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801989:	7c d9                	jl     801964 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80198b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80198e:	8b 45 10             	mov    0x10(%ebp),%eax
  801991:	01 d0                	add    %edx,%eax
  801993:	c6 00 00             	movb   $0x0,(%eax)
}
  801996:	90                   	nop
  801997:	c9                   	leave  
  801998:	c3                   	ret    

00801999 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801999:	55                   	push   %ebp
  80199a:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80199c:	8b 45 14             	mov    0x14(%ebp),%eax
  80199f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8019a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8019a8:	8b 00                	mov    (%eax),%eax
  8019aa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8019b4:	01 d0                	add    %edx,%eax
  8019b6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8019bc:	eb 0c                	jmp    8019ca <strsplit+0x31>
			*string++ = 0;
  8019be:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c1:	8d 50 01             	lea    0x1(%eax),%edx
  8019c4:	89 55 08             	mov    %edx,0x8(%ebp)
  8019c7:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8019ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cd:	8a 00                	mov    (%eax),%al
  8019cf:	84 c0                	test   %al,%al
  8019d1:	74 18                	je     8019eb <strsplit+0x52>
  8019d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d6:	8a 00                	mov    (%eax),%al
  8019d8:	0f be c0             	movsbl %al,%eax
  8019db:	50                   	push   %eax
  8019dc:	ff 75 0c             	pushl  0xc(%ebp)
  8019df:	e8 83 fa ff ff       	call   801467 <strchr>
  8019e4:	83 c4 08             	add    $0x8,%esp
  8019e7:	85 c0                	test   %eax,%eax
  8019e9:	75 d3                	jne    8019be <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8019eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ee:	8a 00                	mov    (%eax),%al
  8019f0:	84 c0                	test   %al,%al
  8019f2:	74 5a                	je     801a4e <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8019f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8019f7:	8b 00                	mov    (%eax),%eax
  8019f9:	83 f8 0f             	cmp    $0xf,%eax
  8019fc:	75 07                	jne    801a05 <strsplit+0x6c>
		{
			return 0;
  8019fe:	b8 00 00 00 00       	mov    $0x0,%eax
  801a03:	eb 66                	jmp    801a6b <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801a05:	8b 45 14             	mov    0x14(%ebp),%eax
  801a08:	8b 00                	mov    (%eax),%eax
  801a0a:	8d 48 01             	lea    0x1(%eax),%ecx
  801a0d:	8b 55 14             	mov    0x14(%ebp),%edx
  801a10:	89 0a                	mov    %ecx,(%edx)
  801a12:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a19:	8b 45 10             	mov    0x10(%ebp),%eax
  801a1c:	01 c2                	add    %eax,%edx
  801a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a21:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a23:	eb 03                	jmp    801a28 <strsplit+0x8f>
			string++;
  801a25:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a28:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2b:	8a 00                	mov    (%eax),%al
  801a2d:	84 c0                	test   %al,%al
  801a2f:	74 8b                	je     8019bc <strsplit+0x23>
  801a31:	8b 45 08             	mov    0x8(%ebp),%eax
  801a34:	8a 00                	mov    (%eax),%al
  801a36:	0f be c0             	movsbl %al,%eax
  801a39:	50                   	push   %eax
  801a3a:	ff 75 0c             	pushl  0xc(%ebp)
  801a3d:	e8 25 fa ff ff       	call   801467 <strchr>
  801a42:	83 c4 08             	add    $0x8,%esp
  801a45:	85 c0                	test   %eax,%eax
  801a47:	74 dc                	je     801a25 <strsplit+0x8c>
			string++;
	}
  801a49:	e9 6e ff ff ff       	jmp    8019bc <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801a4e:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801a4f:	8b 45 14             	mov    0x14(%ebp),%eax
  801a52:	8b 00                	mov    (%eax),%eax
  801a54:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a5b:	8b 45 10             	mov    0x10(%ebp),%eax
  801a5e:	01 d0                	add    %edx,%eax
  801a60:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801a66:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801a6b:	c9                   	leave  
  801a6c:	c3                   	ret    

00801a6d <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801a6d:	55                   	push   %ebp
  801a6e:	89 e5                	mov    %esp,%ebp
  801a70:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801a73:	8b 45 08             	mov    0x8(%ebp),%eax
  801a76:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801a79:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801a80:	eb 4a                	jmp    801acc <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801a82:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a85:	8b 45 08             	mov    0x8(%ebp),%eax
  801a88:	01 c2                	add    %eax,%edx
  801a8a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801a8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a90:	01 c8                	add    %ecx,%eax
  801a92:	8a 00                	mov    (%eax),%al
  801a94:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801a96:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a99:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a9c:	01 d0                	add    %edx,%eax
  801a9e:	8a 00                	mov    (%eax),%al
  801aa0:	3c 40                	cmp    $0x40,%al
  801aa2:	7e 25                	jle    801ac9 <str2lower+0x5c>
  801aa4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801aa7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aaa:	01 d0                	add    %edx,%eax
  801aac:	8a 00                	mov    (%eax),%al
  801aae:	3c 5a                	cmp    $0x5a,%al
  801ab0:	7f 17                	jg     801ac9 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801ab2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ab5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab8:	01 d0                	add    %edx,%eax
  801aba:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801abd:	8b 55 08             	mov    0x8(%ebp),%edx
  801ac0:	01 ca                	add    %ecx,%edx
  801ac2:	8a 12                	mov    (%edx),%dl
  801ac4:	83 c2 20             	add    $0x20,%edx
  801ac7:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801ac9:	ff 45 fc             	incl   -0x4(%ebp)
  801acc:	ff 75 0c             	pushl  0xc(%ebp)
  801acf:	e8 01 f8 ff ff       	call   8012d5 <strlen>
  801ad4:	83 c4 04             	add    $0x4,%esp
  801ad7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801ada:	7f a6                	jg     801a82 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801adc:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801adf:	c9                   	leave  
  801ae0:	c3                   	ret    

00801ae1 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801ae1:	55                   	push   %ebp
  801ae2:	89 e5                	mov    %esp,%ebp
  801ae4:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801ae7:	a1 08 40 80 00       	mov    0x804008,%eax
  801aec:	85 c0                	test   %eax,%eax
  801aee:	74 42                	je     801b32 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801af0:	83 ec 08             	sub    $0x8,%esp
  801af3:	68 00 00 00 82       	push   $0x82000000
  801af8:	68 00 00 00 80       	push   $0x80000000
  801afd:	e8 8c 07 00 00       	call   80228e <initialize_dynamic_allocator>
  801b02:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801b05:	e8 e7 05 00 00       	call   8020f1 <sys_get_uheap_strategy>
  801b0a:	a3 60 c0 81 00       	mov    %eax,0x81c060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801b0f:	a1 40 40 80 00       	mov    0x804040,%eax
  801b14:	05 00 10 00 00       	add    $0x1000,%eax
  801b19:	a3 10 c1 81 00       	mov    %eax,0x81c110
		uheapPageAllocBreak = uheapPageAllocStart;
  801b1e:	a1 10 c1 81 00       	mov    0x81c110,%eax
  801b23:	a3 68 c0 81 00       	mov    %eax,0x81c068

		__firstTimeFlag = 0;
  801b28:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  801b2f:	00 00 00 
	}
}
  801b32:	90                   	nop
  801b33:	c9                   	leave  
  801b34:	c3                   	ret    

00801b35 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801b35:	55                   	push   %ebp
  801b36:	89 e5                	mov    %esp,%ebp
  801b38:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b44:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801b49:	83 ec 08             	sub    $0x8,%esp
  801b4c:	68 06 04 00 00       	push   $0x406
  801b51:	50                   	push   %eax
  801b52:	e8 e4 01 00 00       	call   801d3b <__sys_allocate_page>
  801b57:	83 c4 10             	add    $0x10,%esp
  801b5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801b5d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801b61:	79 14                	jns    801b77 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801b63:	83 ec 04             	sub    $0x4,%esp
  801b66:	68 28 2e 80 00       	push   $0x802e28
  801b6b:	6a 1f                	push   $0x1f
  801b6d:	68 64 2e 80 00       	push   $0x802e64
  801b72:	e8 b7 ed ff ff       	call   80092e <_panic>
	return 0;
  801b77:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b7c:	c9                   	leave  
  801b7d:	c3                   	ret    

00801b7e <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801b7e:	55                   	push   %ebp
  801b7f:	89 e5                	mov    %esp,%ebp
  801b81:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801b84:	8b 45 08             	mov    0x8(%ebp),%eax
  801b87:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b8d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801b92:	83 ec 0c             	sub    $0xc,%esp
  801b95:	50                   	push   %eax
  801b96:	e8 e7 01 00 00       	call   801d82 <__sys_unmap_frame>
  801b9b:	83 c4 10             	add    $0x10,%esp
  801b9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801ba1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ba5:	79 14                	jns    801bbb <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801ba7:	83 ec 04             	sub    $0x4,%esp
  801baa:	68 70 2e 80 00       	push   $0x802e70
  801baf:	6a 2a                	push   $0x2a
  801bb1:	68 64 2e 80 00       	push   $0x802e64
  801bb6:	e8 73 ed ff ff       	call   80092e <_panic>
}
  801bbb:	90                   	nop
  801bbc:	c9                   	leave  
  801bbd:	c3                   	ret    

00801bbe <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801bbe:	55                   	push   %ebp
  801bbf:	89 e5                	mov    %esp,%ebp
  801bc1:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801bc4:	e8 18 ff ff ff       	call   801ae1 <uheap_init>
	if (size == 0) return NULL ;
  801bc9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801bcd:	75 07                	jne    801bd6 <malloc+0x18>
  801bcf:	b8 00 00 00 00       	mov    $0x0,%eax
  801bd4:	eb 14                	jmp    801bea <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  801bd6:	83 ec 04             	sub    $0x4,%esp
  801bd9:	68 b0 2e 80 00       	push   $0x802eb0
  801bde:	6a 3e                	push   $0x3e
  801be0:	68 64 2e 80 00       	push   $0x802e64
  801be5:	e8 44 ed ff ff       	call   80092e <_panic>
}
  801bea:	c9                   	leave  
  801beb:	c3                   	ret    

00801bec <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801bec:	55                   	push   %ebp
  801bed:	89 e5                	mov    %esp,%ebp
  801bef:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  801bf2:	83 ec 04             	sub    $0x4,%esp
  801bf5:	68 d8 2e 80 00       	push   $0x802ed8
  801bfa:	6a 49                	push   $0x49
  801bfc:	68 64 2e 80 00       	push   $0x802e64
  801c01:	e8 28 ed ff ff       	call   80092e <_panic>

00801c06 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801c06:	55                   	push   %ebp
  801c07:	89 e5                	mov    %esp,%ebp
  801c09:	83 ec 18             	sub    $0x18,%esp
  801c0c:	8b 45 10             	mov    0x10(%ebp),%eax
  801c0f:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801c12:	e8 ca fe ff ff       	call   801ae1 <uheap_init>
	if (size == 0) return NULL ;
  801c17:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801c1b:	75 07                	jne    801c24 <smalloc+0x1e>
  801c1d:	b8 00 00 00 00       	mov    $0x0,%eax
  801c22:	eb 14                	jmp    801c38 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  801c24:	83 ec 04             	sub    $0x4,%esp
  801c27:	68 fc 2e 80 00       	push   $0x802efc
  801c2c:	6a 5a                	push   $0x5a
  801c2e:	68 64 2e 80 00       	push   $0x802e64
  801c33:	e8 f6 ec ff ff       	call   80092e <_panic>
}
  801c38:	c9                   	leave  
  801c39:	c3                   	ret    

00801c3a <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801c3a:	55                   	push   %ebp
  801c3b:	89 e5                	mov    %esp,%ebp
  801c3d:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801c40:	e8 9c fe ff ff       	call   801ae1 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  801c45:	83 ec 04             	sub    $0x4,%esp
  801c48:	68 24 2f 80 00       	push   $0x802f24
  801c4d:	6a 6a                	push   $0x6a
  801c4f:	68 64 2e 80 00       	push   $0x802e64
  801c54:	e8 d5 ec ff ff       	call   80092e <_panic>

00801c59 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801c59:	55                   	push   %ebp
  801c5a:	89 e5                	mov    %esp,%ebp
  801c5c:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801c5f:	e8 7d fe ff ff       	call   801ae1 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  801c64:	83 ec 04             	sub    $0x4,%esp
  801c67:	68 48 2f 80 00       	push   $0x802f48
  801c6c:	68 88 00 00 00       	push   $0x88
  801c71:	68 64 2e 80 00       	push   $0x802e64
  801c76:	e8 b3 ec ff ff       	call   80092e <_panic>

00801c7b <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  801c7b:	55                   	push   %ebp
  801c7c:	89 e5                	mov    %esp,%ebp
  801c7e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  801c81:	83 ec 04             	sub    $0x4,%esp
  801c84:	68 70 2f 80 00       	push   $0x802f70
  801c89:	68 9b 00 00 00       	push   $0x9b
  801c8e:	68 64 2e 80 00       	push   $0x802e64
  801c93:	e8 96 ec ff ff       	call   80092e <_panic>

00801c98 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801c98:	55                   	push   %ebp
  801c99:	89 e5                	mov    %esp,%ebp
  801c9b:	57                   	push   %edi
  801c9c:	56                   	push   %esi
  801c9d:	53                   	push   %ebx
  801c9e:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801ca1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ca7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801caa:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cad:	8b 7d 18             	mov    0x18(%ebp),%edi
  801cb0:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801cb3:	cd 30                	int    $0x30
  801cb5:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801cb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801cbb:	83 c4 10             	add    $0x10,%esp
  801cbe:	5b                   	pop    %ebx
  801cbf:	5e                   	pop    %esi
  801cc0:	5f                   	pop    %edi
  801cc1:	5d                   	pop    %ebp
  801cc2:	c3                   	ret    

00801cc3 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801cc3:	55                   	push   %ebp
  801cc4:	89 e5                	mov    %esp,%ebp
  801cc6:	83 ec 04             	sub    $0x4,%esp
  801cc9:	8b 45 10             	mov    0x10(%ebp),%eax
  801ccc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801ccf:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801cd2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd9:	6a 00                	push   $0x0
  801cdb:	51                   	push   %ecx
  801cdc:	52                   	push   %edx
  801cdd:	ff 75 0c             	pushl  0xc(%ebp)
  801ce0:	50                   	push   %eax
  801ce1:	6a 00                	push   $0x0
  801ce3:	e8 b0 ff ff ff       	call   801c98 <syscall>
  801ce8:	83 c4 18             	add    $0x18,%esp
}
  801ceb:	90                   	nop
  801cec:	c9                   	leave  
  801ced:	c3                   	ret    

00801cee <sys_cgetc>:

int
sys_cgetc(void)
{
  801cee:	55                   	push   %ebp
  801cef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801cf1:	6a 00                	push   $0x0
  801cf3:	6a 00                	push   $0x0
  801cf5:	6a 00                	push   $0x0
  801cf7:	6a 00                	push   $0x0
  801cf9:	6a 00                	push   $0x0
  801cfb:	6a 02                	push   $0x2
  801cfd:	e8 96 ff ff ff       	call   801c98 <syscall>
  801d02:	83 c4 18             	add    $0x18,%esp
}
  801d05:	c9                   	leave  
  801d06:	c3                   	ret    

00801d07 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801d07:	55                   	push   %ebp
  801d08:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801d0a:	6a 00                	push   $0x0
  801d0c:	6a 00                	push   $0x0
  801d0e:	6a 00                	push   $0x0
  801d10:	6a 00                	push   $0x0
  801d12:	6a 00                	push   $0x0
  801d14:	6a 03                	push   $0x3
  801d16:	e8 7d ff ff ff       	call   801c98 <syscall>
  801d1b:	83 c4 18             	add    $0x18,%esp
}
  801d1e:	90                   	nop
  801d1f:	c9                   	leave  
  801d20:	c3                   	ret    

00801d21 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801d21:	55                   	push   %ebp
  801d22:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801d24:	6a 00                	push   $0x0
  801d26:	6a 00                	push   $0x0
  801d28:	6a 00                	push   $0x0
  801d2a:	6a 00                	push   $0x0
  801d2c:	6a 00                	push   $0x0
  801d2e:	6a 04                	push   $0x4
  801d30:	e8 63 ff ff ff       	call   801c98 <syscall>
  801d35:	83 c4 18             	add    $0x18,%esp
}
  801d38:	90                   	nop
  801d39:	c9                   	leave  
  801d3a:	c3                   	ret    

00801d3b <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801d3b:	55                   	push   %ebp
  801d3c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801d3e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d41:	8b 45 08             	mov    0x8(%ebp),%eax
  801d44:	6a 00                	push   $0x0
  801d46:	6a 00                	push   $0x0
  801d48:	6a 00                	push   $0x0
  801d4a:	52                   	push   %edx
  801d4b:	50                   	push   %eax
  801d4c:	6a 08                	push   $0x8
  801d4e:	e8 45 ff ff ff       	call   801c98 <syscall>
  801d53:	83 c4 18             	add    $0x18,%esp
}
  801d56:	c9                   	leave  
  801d57:	c3                   	ret    

00801d58 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801d58:	55                   	push   %ebp
  801d59:	89 e5                	mov    %esp,%ebp
  801d5b:	56                   	push   %esi
  801d5c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801d5d:	8b 75 18             	mov    0x18(%ebp),%esi
  801d60:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d63:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d66:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d69:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6c:	56                   	push   %esi
  801d6d:	53                   	push   %ebx
  801d6e:	51                   	push   %ecx
  801d6f:	52                   	push   %edx
  801d70:	50                   	push   %eax
  801d71:	6a 09                	push   $0x9
  801d73:	e8 20 ff ff ff       	call   801c98 <syscall>
  801d78:	83 c4 18             	add    $0x18,%esp
}
  801d7b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d7e:	5b                   	pop    %ebx
  801d7f:	5e                   	pop    %esi
  801d80:	5d                   	pop    %ebp
  801d81:	c3                   	ret    

00801d82 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801d82:	55                   	push   %ebp
  801d83:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801d85:	6a 00                	push   $0x0
  801d87:	6a 00                	push   $0x0
  801d89:	6a 00                	push   $0x0
  801d8b:	6a 00                	push   $0x0
  801d8d:	ff 75 08             	pushl  0x8(%ebp)
  801d90:	6a 0a                	push   $0xa
  801d92:	e8 01 ff ff ff       	call   801c98 <syscall>
  801d97:	83 c4 18             	add    $0x18,%esp
}
  801d9a:	c9                   	leave  
  801d9b:	c3                   	ret    

00801d9c <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801d9c:	55                   	push   %ebp
  801d9d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801d9f:	6a 00                	push   $0x0
  801da1:	6a 00                	push   $0x0
  801da3:	6a 00                	push   $0x0
  801da5:	ff 75 0c             	pushl  0xc(%ebp)
  801da8:	ff 75 08             	pushl  0x8(%ebp)
  801dab:	6a 0b                	push   $0xb
  801dad:	e8 e6 fe ff ff       	call   801c98 <syscall>
  801db2:	83 c4 18             	add    $0x18,%esp
}
  801db5:	c9                   	leave  
  801db6:	c3                   	ret    

00801db7 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801db7:	55                   	push   %ebp
  801db8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801dba:	6a 00                	push   $0x0
  801dbc:	6a 00                	push   $0x0
  801dbe:	6a 00                	push   $0x0
  801dc0:	6a 00                	push   $0x0
  801dc2:	6a 00                	push   $0x0
  801dc4:	6a 0c                	push   $0xc
  801dc6:	e8 cd fe ff ff       	call   801c98 <syscall>
  801dcb:	83 c4 18             	add    $0x18,%esp
}
  801dce:	c9                   	leave  
  801dcf:	c3                   	ret    

00801dd0 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801dd0:	55                   	push   %ebp
  801dd1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801dd3:	6a 00                	push   $0x0
  801dd5:	6a 00                	push   $0x0
  801dd7:	6a 00                	push   $0x0
  801dd9:	6a 00                	push   $0x0
  801ddb:	6a 00                	push   $0x0
  801ddd:	6a 0d                	push   $0xd
  801ddf:	e8 b4 fe ff ff       	call   801c98 <syscall>
  801de4:	83 c4 18             	add    $0x18,%esp
}
  801de7:	c9                   	leave  
  801de8:	c3                   	ret    

00801de9 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801de9:	55                   	push   %ebp
  801dea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801dec:	6a 00                	push   $0x0
  801dee:	6a 00                	push   $0x0
  801df0:	6a 00                	push   $0x0
  801df2:	6a 00                	push   $0x0
  801df4:	6a 00                	push   $0x0
  801df6:	6a 0e                	push   $0xe
  801df8:	e8 9b fe ff ff       	call   801c98 <syscall>
  801dfd:	83 c4 18             	add    $0x18,%esp
}
  801e00:	c9                   	leave  
  801e01:	c3                   	ret    

00801e02 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801e02:	55                   	push   %ebp
  801e03:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801e05:	6a 00                	push   $0x0
  801e07:	6a 00                	push   $0x0
  801e09:	6a 00                	push   $0x0
  801e0b:	6a 00                	push   $0x0
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 0f                	push   $0xf
  801e11:	e8 82 fe ff ff       	call   801c98 <syscall>
  801e16:	83 c4 18             	add    $0x18,%esp
}
  801e19:	c9                   	leave  
  801e1a:	c3                   	ret    

00801e1b <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801e1b:	55                   	push   %ebp
  801e1c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801e1e:	6a 00                	push   $0x0
  801e20:	6a 00                	push   $0x0
  801e22:	6a 00                	push   $0x0
  801e24:	6a 00                	push   $0x0
  801e26:	ff 75 08             	pushl  0x8(%ebp)
  801e29:	6a 10                	push   $0x10
  801e2b:	e8 68 fe ff ff       	call   801c98 <syscall>
  801e30:	83 c4 18             	add    $0x18,%esp
}
  801e33:	c9                   	leave  
  801e34:	c3                   	ret    

00801e35 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801e35:	55                   	push   %ebp
  801e36:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801e38:	6a 00                	push   $0x0
  801e3a:	6a 00                	push   $0x0
  801e3c:	6a 00                	push   $0x0
  801e3e:	6a 00                	push   $0x0
  801e40:	6a 00                	push   $0x0
  801e42:	6a 11                	push   $0x11
  801e44:	e8 4f fe ff ff       	call   801c98 <syscall>
  801e49:	83 c4 18             	add    $0x18,%esp
}
  801e4c:	90                   	nop
  801e4d:	c9                   	leave  
  801e4e:	c3                   	ret    

00801e4f <sys_cputc>:

void
sys_cputc(const char c)
{
  801e4f:	55                   	push   %ebp
  801e50:	89 e5                	mov    %esp,%ebp
  801e52:	83 ec 04             	sub    $0x4,%esp
  801e55:	8b 45 08             	mov    0x8(%ebp),%eax
  801e58:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801e5b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e5f:	6a 00                	push   $0x0
  801e61:	6a 00                	push   $0x0
  801e63:	6a 00                	push   $0x0
  801e65:	6a 00                	push   $0x0
  801e67:	50                   	push   %eax
  801e68:	6a 01                	push   $0x1
  801e6a:	e8 29 fe ff ff       	call   801c98 <syscall>
  801e6f:	83 c4 18             	add    $0x18,%esp
}
  801e72:	90                   	nop
  801e73:	c9                   	leave  
  801e74:	c3                   	ret    

00801e75 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801e75:	55                   	push   %ebp
  801e76:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801e78:	6a 00                	push   $0x0
  801e7a:	6a 00                	push   $0x0
  801e7c:	6a 00                	push   $0x0
  801e7e:	6a 00                	push   $0x0
  801e80:	6a 00                	push   $0x0
  801e82:	6a 14                	push   $0x14
  801e84:	e8 0f fe ff ff       	call   801c98 <syscall>
  801e89:	83 c4 18             	add    $0x18,%esp
}
  801e8c:	90                   	nop
  801e8d:	c9                   	leave  
  801e8e:	c3                   	ret    

00801e8f <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801e8f:	55                   	push   %ebp
  801e90:	89 e5                	mov    %esp,%ebp
  801e92:	83 ec 04             	sub    $0x4,%esp
  801e95:	8b 45 10             	mov    0x10(%ebp),%eax
  801e98:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801e9b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801e9e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ea2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea5:	6a 00                	push   $0x0
  801ea7:	51                   	push   %ecx
  801ea8:	52                   	push   %edx
  801ea9:	ff 75 0c             	pushl  0xc(%ebp)
  801eac:	50                   	push   %eax
  801ead:	6a 15                	push   $0x15
  801eaf:	e8 e4 fd ff ff       	call   801c98 <syscall>
  801eb4:	83 c4 18             	add    $0x18,%esp
}
  801eb7:	c9                   	leave  
  801eb8:	c3                   	ret    

00801eb9 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801eb9:	55                   	push   %ebp
  801eba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801ebc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ebf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec2:	6a 00                	push   $0x0
  801ec4:	6a 00                	push   $0x0
  801ec6:	6a 00                	push   $0x0
  801ec8:	52                   	push   %edx
  801ec9:	50                   	push   %eax
  801eca:	6a 16                	push   $0x16
  801ecc:	e8 c7 fd ff ff       	call   801c98 <syscall>
  801ed1:	83 c4 18             	add    $0x18,%esp
}
  801ed4:	c9                   	leave  
  801ed5:	c3                   	ret    

00801ed6 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801ed6:	55                   	push   %ebp
  801ed7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801ed9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801edc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801edf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee2:	6a 00                	push   $0x0
  801ee4:	6a 00                	push   $0x0
  801ee6:	51                   	push   %ecx
  801ee7:	52                   	push   %edx
  801ee8:	50                   	push   %eax
  801ee9:	6a 17                	push   $0x17
  801eeb:	e8 a8 fd ff ff       	call   801c98 <syscall>
  801ef0:	83 c4 18             	add    $0x18,%esp
}
  801ef3:	c9                   	leave  
  801ef4:	c3                   	ret    

00801ef5 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801ef5:	55                   	push   %ebp
  801ef6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801ef8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801efb:	8b 45 08             	mov    0x8(%ebp),%eax
  801efe:	6a 00                	push   $0x0
  801f00:	6a 00                	push   $0x0
  801f02:	6a 00                	push   $0x0
  801f04:	52                   	push   %edx
  801f05:	50                   	push   %eax
  801f06:	6a 18                	push   $0x18
  801f08:	e8 8b fd ff ff       	call   801c98 <syscall>
  801f0d:	83 c4 18             	add    $0x18,%esp
}
  801f10:	c9                   	leave  
  801f11:	c3                   	ret    

00801f12 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801f12:	55                   	push   %ebp
  801f13:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801f15:	8b 45 08             	mov    0x8(%ebp),%eax
  801f18:	6a 00                	push   $0x0
  801f1a:	ff 75 14             	pushl  0x14(%ebp)
  801f1d:	ff 75 10             	pushl  0x10(%ebp)
  801f20:	ff 75 0c             	pushl  0xc(%ebp)
  801f23:	50                   	push   %eax
  801f24:	6a 19                	push   $0x19
  801f26:	e8 6d fd ff ff       	call   801c98 <syscall>
  801f2b:	83 c4 18             	add    $0x18,%esp
}
  801f2e:	c9                   	leave  
  801f2f:	c3                   	ret    

00801f30 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801f30:	55                   	push   %ebp
  801f31:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801f33:	8b 45 08             	mov    0x8(%ebp),%eax
  801f36:	6a 00                	push   $0x0
  801f38:	6a 00                	push   $0x0
  801f3a:	6a 00                	push   $0x0
  801f3c:	6a 00                	push   $0x0
  801f3e:	50                   	push   %eax
  801f3f:	6a 1a                	push   $0x1a
  801f41:	e8 52 fd ff ff       	call   801c98 <syscall>
  801f46:	83 c4 18             	add    $0x18,%esp
}
  801f49:	90                   	nop
  801f4a:	c9                   	leave  
  801f4b:	c3                   	ret    

00801f4c <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801f4c:	55                   	push   %ebp
  801f4d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f52:	6a 00                	push   $0x0
  801f54:	6a 00                	push   $0x0
  801f56:	6a 00                	push   $0x0
  801f58:	6a 00                	push   $0x0
  801f5a:	50                   	push   %eax
  801f5b:	6a 1b                	push   $0x1b
  801f5d:	e8 36 fd ff ff       	call   801c98 <syscall>
  801f62:	83 c4 18             	add    $0x18,%esp
}
  801f65:	c9                   	leave  
  801f66:	c3                   	ret    

00801f67 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801f67:	55                   	push   %ebp
  801f68:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801f6a:	6a 00                	push   $0x0
  801f6c:	6a 00                	push   $0x0
  801f6e:	6a 00                	push   $0x0
  801f70:	6a 00                	push   $0x0
  801f72:	6a 00                	push   $0x0
  801f74:	6a 05                	push   $0x5
  801f76:	e8 1d fd ff ff       	call   801c98 <syscall>
  801f7b:	83 c4 18             	add    $0x18,%esp
}
  801f7e:	c9                   	leave  
  801f7f:	c3                   	ret    

00801f80 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801f80:	55                   	push   %ebp
  801f81:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801f83:	6a 00                	push   $0x0
  801f85:	6a 00                	push   $0x0
  801f87:	6a 00                	push   $0x0
  801f89:	6a 00                	push   $0x0
  801f8b:	6a 00                	push   $0x0
  801f8d:	6a 06                	push   $0x6
  801f8f:	e8 04 fd ff ff       	call   801c98 <syscall>
  801f94:	83 c4 18             	add    $0x18,%esp
}
  801f97:	c9                   	leave  
  801f98:	c3                   	ret    

00801f99 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801f99:	55                   	push   %ebp
  801f9a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801f9c:	6a 00                	push   $0x0
  801f9e:	6a 00                	push   $0x0
  801fa0:	6a 00                	push   $0x0
  801fa2:	6a 00                	push   $0x0
  801fa4:	6a 00                	push   $0x0
  801fa6:	6a 07                	push   $0x7
  801fa8:	e8 eb fc ff ff       	call   801c98 <syscall>
  801fad:	83 c4 18             	add    $0x18,%esp
}
  801fb0:	c9                   	leave  
  801fb1:	c3                   	ret    

00801fb2 <sys_exit_env>:


void sys_exit_env(void)
{
  801fb2:	55                   	push   %ebp
  801fb3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801fb5:	6a 00                	push   $0x0
  801fb7:	6a 00                	push   $0x0
  801fb9:	6a 00                	push   $0x0
  801fbb:	6a 00                	push   $0x0
  801fbd:	6a 00                	push   $0x0
  801fbf:	6a 1c                	push   $0x1c
  801fc1:	e8 d2 fc ff ff       	call   801c98 <syscall>
  801fc6:	83 c4 18             	add    $0x18,%esp
}
  801fc9:	90                   	nop
  801fca:	c9                   	leave  
  801fcb:	c3                   	ret    

00801fcc <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801fcc:	55                   	push   %ebp
  801fcd:	89 e5                	mov    %esp,%ebp
  801fcf:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801fd2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801fd5:	8d 50 04             	lea    0x4(%eax),%edx
  801fd8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801fdb:	6a 00                	push   $0x0
  801fdd:	6a 00                	push   $0x0
  801fdf:	6a 00                	push   $0x0
  801fe1:	52                   	push   %edx
  801fe2:	50                   	push   %eax
  801fe3:	6a 1d                	push   $0x1d
  801fe5:	e8 ae fc ff ff       	call   801c98 <syscall>
  801fea:	83 c4 18             	add    $0x18,%esp
	return result;
  801fed:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ff0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ff3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ff6:	89 01                	mov    %eax,(%ecx)
  801ff8:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801ffb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffe:	c9                   	leave  
  801fff:	c2 04 00             	ret    $0x4

00802002 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802002:	55                   	push   %ebp
  802003:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802005:	6a 00                	push   $0x0
  802007:	6a 00                	push   $0x0
  802009:	ff 75 10             	pushl  0x10(%ebp)
  80200c:	ff 75 0c             	pushl  0xc(%ebp)
  80200f:	ff 75 08             	pushl  0x8(%ebp)
  802012:	6a 13                	push   $0x13
  802014:	e8 7f fc ff ff       	call   801c98 <syscall>
  802019:	83 c4 18             	add    $0x18,%esp
	return ;
  80201c:	90                   	nop
}
  80201d:	c9                   	leave  
  80201e:	c3                   	ret    

0080201f <sys_rcr2>:
uint32 sys_rcr2()
{
  80201f:	55                   	push   %ebp
  802020:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802022:	6a 00                	push   $0x0
  802024:	6a 00                	push   $0x0
  802026:	6a 00                	push   $0x0
  802028:	6a 00                	push   $0x0
  80202a:	6a 00                	push   $0x0
  80202c:	6a 1e                	push   $0x1e
  80202e:	e8 65 fc ff ff       	call   801c98 <syscall>
  802033:	83 c4 18             	add    $0x18,%esp
}
  802036:	c9                   	leave  
  802037:	c3                   	ret    

00802038 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802038:	55                   	push   %ebp
  802039:	89 e5                	mov    %esp,%ebp
  80203b:	83 ec 04             	sub    $0x4,%esp
  80203e:	8b 45 08             	mov    0x8(%ebp),%eax
  802041:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802044:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802048:	6a 00                	push   $0x0
  80204a:	6a 00                	push   $0x0
  80204c:	6a 00                	push   $0x0
  80204e:	6a 00                	push   $0x0
  802050:	50                   	push   %eax
  802051:	6a 1f                	push   $0x1f
  802053:	e8 40 fc ff ff       	call   801c98 <syscall>
  802058:	83 c4 18             	add    $0x18,%esp
	return ;
  80205b:	90                   	nop
}
  80205c:	c9                   	leave  
  80205d:	c3                   	ret    

0080205e <rsttst>:
void rsttst()
{
  80205e:	55                   	push   %ebp
  80205f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802061:	6a 00                	push   $0x0
  802063:	6a 00                	push   $0x0
  802065:	6a 00                	push   $0x0
  802067:	6a 00                	push   $0x0
  802069:	6a 00                	push   $0x0
  80206b:	6a 21                	push   $0x21
  80206d:	e8 26 fc ff ff       	call   801c98 <syscall>
  802072:	83 c4 18             	add    $0x18,%esp
	return ;
  802075:	90                   	nop
}
  802076:	c9                   	leave  
  802077:	c3                   	ret    

00802078 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802078:	55                   	push   %ebp
  802079:	89 e5                	mov    %esp,%ebp
  80207b:	83 ec 04             	sub    $0x4,%esp
  80207e:	8b 45 14             	mov    0x14(%ebp),%eax
  802081:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802084:	8b 55 18             	mov    0x18(%ebp),%edx
  802087:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80208b:	52                   	push   %edx
  80208c:	50                   	push   %eax
  80208d:	ff 75 10             	pushl  0x10(%ebp)
  802090:	ff 75 0c             	pushl  0xc(%ebp)
  802093:	ff 75 08             	pushl  0x8(%ebp)
  802096:	6a 20                	push   $0x20
  802098:	e8 fb fb ff ff       	call   801c98 <syscall>
  80209d:	83 c4 18             	add    $0x18,%esp
	return ;
  8020a0:	90                   	nop
}
  8020a1:	c9                   	leave  
  8020a2:	c3                   	ret    

008020a3 <chktst>:
void chktst(uint32 n)
{
  8020a3:	55                   	push   %ebp
  8020a4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8020a6:	6a 00                	push   $0x0
  8020a8:	6a 00                	push   $0x0
  8020aa:	6a 00                	push   $0x0
  8020ac:	6a 00                	push   $0x0
  8020ae:	ff 75 08             	pushl  0x8(%ebp)
  8020b1:	6a 22                	push   $0x22
  8020b3:	e8 e0 fb ff ff       	call   801c98 <syscall>
  8020b8:	83 c4 18             	add    $0x18,%esp
	return ;
  8020bb:	90                   	nop
}
  8020bc:	c9                   	leave  
  8020bd:	c3                   	ret    

008020be <inctst>:

void inctst()
{
  8020be:	55                   	push   %ebp
  8020bf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8020c1:	6a 00                	push   $0x0
  8020c3:	6a 00                	push   $0x0
  8020c5:	6a 00                	push   $0x0
  8020c7:	6a 00                	push   $0x0
  8020c9:	6a 00                	push   $0x0
  8020cb:	6a 23                	push   $0x23
  8020cd:	e8 c6 fb ff ff       	call   801c98 <syscall>
  8020d2:	83 c4 18             	add    $0x18,%esp
	return ;
  8020d5:	90                   	nop
}
  8020d6:	c9                   	leave  
  8020d7:	c3                   	ret    

008020d8 <gettst>:
uint32 gettst()
{
  8020d8:	55                   	push   %ebp
  8020d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8020db:	6a 00                	push   $0x0
  8020dd:	6a 00                	push   $0x0
  8020df:	6a 00                	push   $0x0
  8020e1:	6a 00                	push   $0x0
  8020e3:	6a 00                	push   $0x0
  8020e5:	6a 24                	push   $0x24
  8020e7:	e8 ac fb ff ff       	call   801c98 <syscall>
  8020ec:	83 c4 18             	add    $0x18,%esp
}
  8020ef:	c9                   	leave  
  8020f0:	c3                   	ret    

008020f1 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8020f1:	55                   	push   %ebp
  8020f2:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020f4:	6a 00                	push   $0x0
  8020f6:	6a 00                	push   $0x0
  8020f8:	6a 00                	push   $0x0
  8020fa:	6a 00                	push   $0x0
  8020fc:	6a 00                	push   $0x0
  8020fe:	6a 25                	push   $0x25
  802100:	e8 93 fb ff ff       	call   801c98 <syscall>
  802105:	83 c4 18             	add    $0x18,%esp
  802108:	a3 60 c0 81 00       	mov    %eax,0x81c060
	return uheapPlaceStrategy ;
  80210d:	a1 60 c0 81 00       	mov    0x81c060,%eax
}
  802112:	c9                   	leave  
  802113:	c3                   	ret    

00802114 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802114:	55                   	push   %ebp
  802115:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  802117:	8b 45 08             	mov    0x8(%ebp),%eax
  80211a:	a3 60 c0 81 00       	mov    %eax,0x81c060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80211f:	6a 00                	push   $0x0
  802121:	6a 00                	push   $0x0
  802123:	6a 00                	push   $0x0
  802125:	6a 00                	push   $0x0
  802127:	ff 75 08             	pushl  0x8(%ebp)
  80212a:	6a 26                	push   $0x26
  80212c:	e8 67 fb ff ff       	call   801c98 <syscall>
  802131:	83 c4 18             	add    $0x18,%esp
	return ;
  802134:	90                   	nop
}
  802135:	c9                   	leave  
  802136:	c3                   	ret    

00802137 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802137:	55                   	push   %ebp
  802138:	89 e5                	mov    %esp,%ebp
  80213a:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80213b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80213e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802141:	8b 55 0c             	mov    0xc(%ebp),%edx
  802144:	8b 45 08             	mov    0x8(%ebp),%eax
  802147:	6a 00                	push   $0x0
  802149:	53                   	push   %ebx
  80214a:	51                   	push   %ecx
  80214b:	52                   	push   %edx
  80214c:	50                   	push   %eax
  80214d:	6a 27                	push   $0x27
  80214f:	e8 44 fb ff ff       	call   801c98 <syscall>
  802154:	83 c4 18             	add    $0x18,%esp
}
  802157:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80215a:	c9                   	leave  
  80215b:	c3                   	ret    

0080215c <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80215c:	55                   	push   %ebp
  80215d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80215f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802162:	8b 45 08             	mov    0x8(%ebp),%eax
  802165:	6a 00                	push   $0x0
  802167:	6a 00                	push   $0x0
  802169:	6a 00                	push   $0x0
  80216b:	52                   	push   %edx
  80216c:	50                   	push   %eax
  80216d:	6a 28                	push   $0x28
  80216f:	e8 24 fb ff ff       	call   801c98 <syscall>
  802174:	83 c4 18             	add    $0x18,%esp
}
  802177:	c9                   	leave  
  802178:	c3                   	ret    

00802179 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802179:	55                   	push   %ebp
  80217a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80217c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80217f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802182:	8b 45 08             	mov    0x8(%ebp),%eax
  802185:	6a 00                	push   $0x0
  802187:	51                   	push   %ecx
  802188:	ff 75 10             	pushl  0x10(%ebp)
  80218b:	52                   	push   %edx
  80218c:	50                   	push   %eax
  80218d:	6a 29                	push   $0x29
  80218f:	e8 04 fb ff ff       	call   801c98 <syscall>
  802194:	83 c4 18             	add    $0x18,%esp
}
  802197:	c9                   	leave  
  802198:	c3                   	ret    

00802199 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802199:	55                   	push   %ebp
  80219a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80219c:	6a 00                	push   $0x0
  80219e:	6a 00                	push   $0x0
  8021a0:	ff 75 10             	pushl  0x10(%ebp)
  8021a3:	ff 75 0c             	pushl  0xc(%ebp)
  8021a6:	ff 75 08             	pushl  0x8(%ebp)
  8021a9:	6a 12                	push   $0x12
  8021ab:	e8 e8 fa ff ff       	call   801c98 <syscall>
  8021b0:	83 c4 18             	add    $0x18,%esp
	return ;
  8021b3:	90                   	nop
}
  8021b4:	c9                   	leave  
  8021b5:	c3                   	ret    

008021b6 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8021b6:	55                   	push   %ebp
  8021b7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8021b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bf:	6a 00                	push   $0x0
  8021c1:	6a 00                	push   $0x0
  8021c3:	6a 00                	push   $0x0
  8021c5:	52                   	push   %edx
  8021c6:	50                   	push   %eax
  8021c7:	6a 2a                	push   $0x2a
  8021c9:	e8 ca fa ff ff       	call   801c98 <syscall>
  8021ce:	83 c4 18             	add    $0x18,%esp
	return;
  8021d1:	90                   	nop
}
  8021d2:	c9                   	leave  
  8021d3:	c3                   	ret    

008021d4 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8021d4:	55                   	push   %ebp
  8021d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8021d7:	6a 00                	push   $0x0
  8021d9:	6a 00                	push   $0x0
  8021db:	6a 00                	push   $0x0
  8021dd:	6a 00                	push   $0x0
  8021df:	6a 00                	push   $0x0
  8021e1:	6a 2b                	push   $0x2b
  8021e3:	e8 b0 fa ff ff       	call   801c98 <syscall>
  8021e8:	83 c4 18             	add    $0x18,%esp
}
  8021eb:	c9                   	leave  
  8021ec:	c3                   	ret    

008021ed <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8021ed:	55                   	push   %ebp
  8021ee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8021f0:	6a 00                	push   $0x0
  8021f2:	6a 00                	push   $0x0
  8021f4:	6a 00                	push   $0x0
  8021f6:	ff 75 0c             	pushl  0xc(%ebp)
  8021f9:	ff 75 08             	pushl  0x8(%ebp)
  8021fc:	6a 2d                	push   $0x2d
  8021fe:	e8 95 fa ff ff       	call   801c98 <syscall>
  802203:	83 c4 18             	add    $0x18,%esp
	return;
  802206:	90                   	nop
}
  802207:	c9                   	leave  
  802208:	c3                   	ret    

00802209 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802209:	55                   	push   %ebp
  80220a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80220c:	6a 00                	push   $0x0
  80220e:	6a 00                	push   $0x0
  802210:	6a 00                	push   $0x0
  802212:	ff 75 0c             	pushl  0xc(%ebp)
  802215:	ff 75 08             	pushl  0x8(%ebp)
  802218:	6a 2c                	push   $0x2c
  80221a:	e8 79 fa ff ff       	call   801c98 <syscall>
  80221f:	83 c4 18             	add    $0x18,%esp
	return ;
  802222:	90                   	nop
}
  802223:	c9                   	leave  
  802224:	c3                   	ret    

00802225 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  802225:	55                   	push   %ebp
  802226:	89 e5                	mov    %esp,%ebp
  802228:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  80222b:	83 ec 04             	sub    $0x4,%esp
  80222e:	68 94 2f 80 00       	push   $0x802f94
  802233:	68 25 01 00 00       	push   $0x125
  802238:	68 c7 2f 80 00       	push   $0x802fc7
  80223d:	e8 ec e6 ff ff       	call   80092e <_panic>

00802242 <to_page_va>:
//==================================================================================//
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  802242:	55                   	push   %ebp
  802243:	89 e5                	mov    %esp,%ebp
  802245:	83 ec 10             	sub    $0x10,%esp
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  802248:	8b 45 08             	mov    0x8(%ebp),%eax
  80224b:	ba 60 40 80 00       	mov    $0x804060,%edx
  802250:	29 d0                	sub    %edx,%eax
  802252:	c1 f8 02             	sar    $0x2,%eax
  802255:	89 c2                	mov    %eax,%edx
  802257:	89 d0                	mov    %edx,%eax
  802259:	c1 e0 02             	shl    $0x2,%eax
  80225c:	01 d0                	add    %edx,%eax
  80225e:	c1 e0 02             	shl    $0x2,%eax
  802261:	01 d0                	add    %edx,%eax
  802263:	c1 e0 02             	shl    $0x2,%eax
  802266:	01 d0                	add    %edx,%eax
  802268:	89 c1                	mov    %eax,%ecx
  80226a:	c1 e1 08             	shl    $0x8,%ecx
  80226d:	01 c8                	add    %ecx,%eax
  80226f:	89 c1                	mov    %eax,%ecx
  802271:	c1 e1 10             	shl    $0x10,%ecx
  802274:	01 c8                	add    %ecx,%eax
  802276:	01 c0                	add    %eax,%eax
  802278:	01 d0                	add    %edx,%eax
  80227a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  80227d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802280:	c1 e0 0c             	shl    $0xc,%eax
  802283:	89 c2                	mov    %eax,%edx
  802285:	a1 64 c0 81 00       	mov    0x81c064,%eax
  80228a:	01 d0                	add    %edx,%eax
}
  80228c:	c9                   	leave  
  80228d:	c3                   	ret    

0080228e <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  80228e:	55                   	push   %ebp
  80228f:	89 e5                	mov    %esp,%ebp
  802291:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  802294:	8b 45 08             	mov    0x8(%ebp),%eax
  802297:	05 00 00 00 02       	add    $0x2000000,%eax
  80229c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80229f:	73 16                	jae    8022b7 <initialize_dynamic_allocator+0x29>
  8022a1:	68 d8 2f 80 00       	push   $0x802fd8
  8022a6:	68 fe 2f 80 00       	push   $0x802ffe
  8022ab:	6a 26                	push   $0x26
  8022ad:	68 13 30 80 00       	push   $0x803013
  8022b2:	e8 77 e6 ff ff       	call   80092e <_panic>
		is_initialized = 1;
  8022b7:	c7 05 28 40 80 00 01 	movl   $0x1,0x804028
  8022be:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	//Comment the following line
	panic("initialize_dynamic_allocator() Not implemented yet");
  8022c1:	83 ec 04             	sub    $0x4,%esp
  8022c4:	68 2c 30 80 00       	push   $0x80302c
  8022c9:	6a 2e                	push   $0x2e
  8022cb:	68 13 30 80 00       	push   $0x803013
  8022d0:	e8 59 e6 ff ff       	call   80092e <_panic>

008022d5 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  8022d5:	55                   	push   %ebp
  8022d6:	89 e5                	mov    %esp,%ebp
  8022d8:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	//Comment the following line
	panic("get_block_size() Not implemented yet");
  8022db:	83 ec 04             	sub    $0x4,%esp
  8022de:	68 60 30 80 00       	push   $0x803060
  8022e3:	6a 3a                	push   $0x3a
  8022e5:	68 13 30 80 00       	push   $0x803013
  8022ea:	e8 3f e6 ff ff       	call   80092e <_panic>

008022ef <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  8022ef:	55                   	push   %ebp
  8022f0:	89 e5                	mov    %esp,%ebp
  8022f2:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  8022f5:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8022fc:	76 16                	jbe    802314 <alloc_block+0x25>
  8022fe:	68 88 30 80 00       	push   $0x803088
  802303:	68 fe 2f 80 00       	push   $0x802ffe
  802308:	6a 46                	push   $0x46
  80230a:	68 13 30 80 00       	push   $0x803013
  80230f:	e8 1a e6 ff ff       	call   80092e <_panic>
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	panic("alloc_block() Not implemented yet");
  802314:	83 ec 04             	sub    $0x4,%esp
  802317:	68 ac 30 80 00       	push   $0x8030ac
  80231c:	6a 4d                	push   $0x4d
  80231e:	68 13 30 80 00       	push   $0x803013
  802323:	e8 06 e6 ff ff       	call   80092e <_panic>

00802328 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  802328:	55                   	push   %ebp
  802329:	89 e5                	mov    %esp,%ebp
  80232b:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  80232e:	8b 55 08             	mov    0x8(%ebp),%edx
  802331:	a1 64 c0 81 00       	mov    0x81c064,%eax
  802336:	39 c2                	cmp    %eax,%edx
  802338:	72 0c                	jb     802346 <free_block+0x1e>
  80233a:	8b 55 08             	mov    0x8(%ebp),%edx
  80233d:	a1 40 40 80 00       	mov    0x804040,%eax
  802342:	39 c2                	cmp    %eax,%edx
  802344:	72 16                	jb     80235c <free_block+0x34>
  802346:	68 d0 30 80 00       	push   $0x8030d0
  80234b:	68 fe 2f 80 00       	push   $0x802ffe
  802350:	6a 5b                	push   $0x5b
  802352:	68 13 30 80 00       	push   $0x803013
  802357:	e8 d2 e5 ff ff       	call   80092e <_panic>
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	panic("free_block() Not implemented yet");
  80235c:	83 ec 04             	sub    $0x4,%esp
  80235f:	68 08 31 80 00       	push   $0x803108
  802364:	6a 63                	push   $0x63
  802366:	68 13 30 80 00       	push   $0x803013
  80236b:	e8 be e5 ff ff       	call   80092e <_panic>

00802370 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  802370:	55                   	push   %ebp
  802371:	89 e5                	mov    %esp,%ebp
  802373:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  802376:	83 ec 04             	sub    $0x4,%esp
  802379:	68 2c 31 80 00       	push   $0x80312c
  80237e:	6a 72                	push   $0x72
  802380:	68 13 30 80 00       	push   $0x803013
  802385:	e8 a4 e5 ff ff       	call   80092e <_panic>
  80238a:	66 90                	xchg   %ax,%ax

0080238c <__udivdi3>:
  80238c:	55                   	push   %ebp
  80238d:	57                   	push   %edi
  80238e:	56                   	push   %esi
  80238f:	53                   	push   %ebx
  802390:	83 ec 1c             	sub    $0x1c,%esp
  802393:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802397:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80239b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80239f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8023a3:	89 ca                	mov    %ecx,%edx
  8023a5:	89 f8                	mov    %edi,%eax
  8023a7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8023ab:	85 f6                	test   %esi,%esi
  8023ad:	75 2d                	jne    8023dc <__udivdi3+0x50>
  8023af:	39 cf                	cmp    %ecx,%edi
  8023b1:	77 65                	ja     802418 <__udivdi3+0x8c>
  8023b3:	89 fd                	mov    %edi,%ebp
  8023b5:	85 ff                	test   %edi,%edi
  8023b7:	75 0b                	jne    8023c4 <__udivdi3+0x38>
  8023b9:	b8 01 00 00 00       	mov    $0x1,%eax
  8023be:	31 d2                	xor    %edx,%edx
  8023c0:	f7 f7                	div    %edi
  8023c2:	89 c5                	mov    %eax,%ebp
  8023c4:	31 d2                	xor    %edx,%edx
  8023c6:	89 c8                	mov    %ecx,%eax
  8023c8:	f7 f5                	div    %ebp
  8023ca:	89 c1                	mov    %eax,%ecx
  8023cc:	89 d8                	mov    %ebx,%eax
  8023ce:	f7 f5                	div    %ebp
  8023d0:	89 cf                	mov    %ecx,%edi
  8023d2:	89 fa                	mov    %edi,%edx
  8023d4:	83 c4 1c             	add    $0x1c,%esp
  8023d7:	5b                   	pop    %ebx
  8023d8:	5e                   	pop    %esi
  8023d9:	5f                   	pop    %edi
  8023da:	5d                   	pop    %ebp
  8023db:	c3                   	ret    
  8023dc:	39 ce                	cmp    %ecx,%esi
  8023de:	77 28                	ja     802408 <__udivdi3+0x7c>
  8023e0:	0f bd fe             	bsr    %esi,%edi
  8023e3:	83 f7 1f             	xor    $0x1f,%edi
  8023e6:	75 40                	jne    802428 <__udivdi3+0x9c>
  8023e8:	39 ce                	cmp    %ecx,%esi
  8023ea:	72 0a                	jb     8023f6 <__udivdi3+0x6a>
  8023ec:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8023f0:	0f 87 9e 00 00 00    	ja     802494 <__udivdi3+0x108>
  8023f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8023fb:	89 fa                	mov    %edi,%edx
  8023fd:	83 c4 1c             	add    $0x1c,%esp
  802400:	5b                   	pop    %ebx
  802401:	5e                   	pop    %esi
  802402:	5f                   	pop    %edi
  802403:	5d                   	pop    %ebp
  802404:	c3                   	ret    
  802405:	8d 76 00             	lea    0x0(%esi),%esi
  802408:	31 ff                	xor    %edi,%edi
  80240a:	31 c0                	xor    %eax,%eax
  80240c:	89 fa                	mov    %edi,%edx
  80240e:	83 c4 1c             	add    $0x1c,%esp
  802411:	5b                   	pop    %ebx
  802412:	5e                   	pop    %esi
  802413:	5f                   	pop    %edi
  802414:	5d                   	pop    %ebp
  802415:	c3                   	ret    
  802416:	66 90                	xchg   %ax,%ax
  802418:	89 d8                	mov    %ebx,%eax
  80241a:	f7 f7                	div    %edi
  80241c:	31 ff                	xor    %edi,%edi
  80241e:	89 fa                	mov    %edi,%edx
  802420:	83 c4 1c             	add    $0x1c,%esp
  802423:	5b                   	pop    %ebx
  802424:	5e                   	pop    %esi
  802425:	5f                   	pop    %edi
  802426:	5d                   	pop    %ebp
  802427:	c3                   	ret    
  802428:	bd 20 00 00 00       	mov    $0x20,%ebp
  80242d:	89 eb                	mov    %ebp,%ebx
  80242f:	29 fb                	sub    %edi,%ebx
  802431:	89 f9                	mov    %edi,%ecx
  802433:	d3 e6                	shl    %cl,%esi
  802435:	89 c5                	mov    %eax,%ebp
  802437:	88 d9                	mov    %bl,%cl
  802439:	d3 ed                	shr    %cl,%ebp
  80243b:	89 e9                	mov    %ebp,%ecx
  80243d:	09 f1                	or     %esi,%ecx
  80243f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802443:	89 f9                	mov    %edi,%ecx
  802445:	d3 e0                	shl    %cl,%eax
  802447:	89 c5                	mov    %eax,%ebp
  802449:	89 d6                	mov    %edx,%esi
  80244b:	88 d9                	mov    %bl,%cl
  80244d:	d3 ee                	shr    %cl,%esi
  80244f:	89 f9                	mov    %edi,%ecx
  802451:	d3 e2                	shl    %cl,%edx
  802453:	8b 44 24 08          	mov    0x8(%esp),%eax
  802457:	88 d9                	mov    %bl,%cl
  802459:	d3 e8                	shr    %cl,%eax
  80245b:	09 c2                	or     %eax,%edx
  80245d:	89 d0                	mov    %edx,%eax
  80245f:	89 f2                	mov    %esi,%edx
  802461:	f7 74 24 0c          	divl   0xc(%esp)
  802465:	89 d6                	mov    %edx,%esi
  802467:	89 c3                	mov    %eax,%ebx
  802469:	f7 e5                	mul    %ebp
  80246b:	39 d6                	cmp    %edx,%esi
  80246d:	72 19                	jb     802488 <__udivdi3+0xfc>
  80246f:	74 0b                	je     80247c <__udivdi3+0xf0>
  802471:	89 d8                	mov    %ebx,%eax
  802473:	31 ff                	xor    %edi,%edi
  802475:	e9 58 ff ff ff       	jmp    8023d2 <__udivdi3+0x46>
  80247a:	66 90                	xchg   %ax,%ax
  80247c:	8b 54 24 08          	mov    0x8(%esp),%edx
  802480:	89 f9                	mov    %edi,%ecx
  802482:	d3 e2                	shl    %cl,%edx
  802484:	39 c2                	cmp    %eax,%edx
  802486:	73 e9                	jae    802471 <__udivdi3+0xe5>
  802488:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80248b:	31 ff                	xor    %edi,%edi
  80248d:	e9 40 ff ff ff       	jmp    8023d2 <__udivdi3+0x46>
  802492:	66 90                	xchg   %ax,%ax
  802494:	31 c0                	xor    %eax,%eax
  802496:	e9 37 ff ff ff       	jmp    8023d2 <__udivdi3+0x46>
  80249b:	90                   	nop

0080249c <__umoddi3>:
  80249c:	55                   	push   %ebp
  80249d:	57                   	push   %edi
  80249e:	56                   	push   %esi
  80249f:	53                   	push   %ebx
  8024a0:	83 ec 1c             	sub    $0x1c,%esp
  8024a3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8024a7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8024ab:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8024af:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8024b3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8024b7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8024bb:	89 f3                	mov    %esi,%ebx
  8024bd:	89 fa                	mov    %edi,%edx
  8024bf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8024c3:	89 34 24             	mov    %esi,(%esp)
  8024c6:	85 c0                	test   %eax,%eax
  8024c8:	75 1a                	jne    8024e4 <__umoddi3+0x48>
  8024ca:	39 f7                	cmp    %esi,%edi
  8024cc:	0f 86 a2 00 00 00    	jbe    802574 <__umoddi3+0xd8>
  8024d2:	89 c8                	mov    %ecx,%eax
  8024d4:	89 f2                	mov    %esi,%edx
  8024d6:	f7 f7                	div    %edi
  8024d8:	89 d0                	mov    %edx,%eax
  8024da:	31 d2                	xor    %edx,%edx
  8024dc:	83 c4 1c             	add    $0x1c,%esp
  8024df:	5b                   	pop    %ebx
  8024e0:	5e                   	pop    %esi
  8024e1:	5f                   	pop    %edi
  8024e2:	5d                   	pop    %ebp
  8024e3:	c3                   	ret    
  8024e4:	39 f0                	cmp    %esi,%eax
  8024e6:	0f 87 ac 00 00 00    	ja     802598 <__umoddi3+0xfc>
  8024ec:	0f bd e8             	bsr    %eax,%ebp
  8024ef:	83 f5 1f             	xor    $0x1f,%ebp
  8024f2:	0f 84 ac 00 00 00    	je     8025a4 <__umoddi3+0x108>
  8024f8:	bf 20 00 00 00       	mov    $0x20,%edi
  8024fd:	29 ef                	sub    %ebp,%edi
  8024ff:	89 fe                	mov    %edi,%esi
  802501:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802505:	89 e9                	mov    %ebp,%ecx
  802507:	d3 e0                	shl    %cl,%eax
  802509:	89 d7                	mov    %edx,%edi
  80250b:	89 f1                	mov    %esi,%ecx
  80250d:	d3 ef                	shr    %cl,%edi
  80250f:	09 c7                	or     %eax,%edi
  802511:	89 e9                	mov    %ebp,%ecx
  802513:	d3 e2                	shl    %cl,%edx
  802515:	89 14 24             	mov    %edx,(%esp)
  802518:	89 d8                	mov    %ebx,%eax
  80251a:	d3 e0                	shl    %cl,%eax
  80251c:	89 c2                	mov    %eax,%edx
  80251e:	8b 44 24 08          	mov    0x8(%esp),%eax
  802522:	d3 e0                	shl    %cl,%eax
  802524:	89 44 24 04          	mov    %eax,0x4(%esp)
  802528:	8b 44 24 08          	mov    0x8(%esp),%eax
  80252c:	89 f1                	mov    %esi,%ecx
  80252e:	d3 e8                	shr    %cl,%eax
  802530:	09 d0                	or     %edx,%eax
  802532:	d3 eb                	shr    %cl,%ebx
  802534:	89 da                	mov    %ebx,%edx
  802536:	f7 f7                	div    %edi
  802538:	89 d3                	mov    %edx,%ebx
  80253a:	f7 24 24             	mull   (%esp)
  80253d:	89 c6                	mov    %eax,%esi
  80253f:	89 d1                	mov    %edx,%ecx
  802541:	39 d3                	cmp    %edx,%ebx
  802543:	0f 82 87 00 00 00    	jb     8025d0 <__umoddi3+0x134>
  802549:	0f 84 91 00 00 00    	je     8025e0 <__umoddi3+0x144>
  80254f:	8b 54 24 04          	mov    0x4(%esp),%edx
  802553:	29 f2                	sub    %esi,%edx
  802555:	19 cb                	sbb    %ecx,%ebx
  802557:	89 d8                	mov    %ebx,%eax
  802559:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80255d:	d3 e0                	shl    %cl,%eax
  80255f:	89 e9                	mov    %ebp,%ecx
  802561:	d3 ea                	shr    %cl,%edx
  802563:	09 d0                	or     %edx,%eax
  802565:	89 e9                	mov    %ebp,%ecx
  802567:	d3 eb                	shr    %cl,%ebx
  802569:	89 da                	mov    %ebx,%edx
  80256b:	83 c4 1c             	add    $0x1c,%esp
  80256e:	5b                   	pop    %ebx
  80256f:	5e                   	pop    %esi
  802570:	5f                   	pop    %edi
  802571:	5d                   	pop    %ebp
  802572:	c3                   	ret    
  802573:	90                   	nop
  802574:	89 fd                	mov    %edi,%ebp
  802576:	85 ff                	test   %edi,%edi
  802578:	75 0b                	jne    802585 <__umoddi3+0xe9>
  80257a:	b8 01 00 00 00       	mov    $0x1,%eax
  80257f:	31 d2                	xor    %edx,%edx
  802581:	f7 f7                	div    %edi
  802583:	89 c5                	mov    %eax,%ebp
  802585:	89 f0                	mov    %esi,%eax
  802587:	31 d2                	xor    %edx,%edx
  802589:	f7 f5                	div    %ebp
  80258b:	89 c8                	mov    %ecx,%eax
  80258d:	f7 f5                	div    %ebp
  80258f:	89 d0                	mov    %edx,%eax
  802591:	e9 44 ff ff ff       	jmp    8024da <__umoddi3+0x3e>
  802596:	66 90                	xchg   %ax,%ax
  802598:	89 c8                	mov    %ecx,%eax
  80259a:	89 f2                	mov    %esi,%edx
  80259c:	83 c4 1c             	add    $0x1c,%esp
  80259f:	5b                   	pop    %ebx
  8025a0:	5e                   	pop    %esi
  8025a1:	5f                   	pop    %edi
  8025a2:	5d                   	pop    %ebp
  8025a3:	c3                   	ret    
  8025a4:	3b 04 24             	cmp    (%esp),%eax
  8025a7:	72 06                	jb     8025af <__umoddi3+0x113>
  8025a9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8025ad:	77 0f                	ja     8025be <__umoddi3+0x122>
  8025af:	89 f2                	mov    %esi,%edx
  8025b1:	29 f9                	sub    %edi,%ecx
  8025b3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8025b7:	89 14 24             	mov    %edx,(%esp)
  8025ba:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8025be:	8b 44 24 04          	mov    0x4(%esp),%eax
  8025c2:	8b 14 24             	mov    (%esp),%edx
  8025c5:	83 c4 1c             	add    $0x1c,%esp
  8025c8:	5b                   	pop    %ebx
  8025c9:	5e                   	pop    %esi
  8025ca:	5f                   	pop    %edi
  8025cb:	5d                   	pop    %ebp
  8025cc:	c3                   	ret    
  8025cd:	8d 76 00             	lea    0x0(%esi),%esi
  8025d0:	2b 04 24             	sub    (%esp),%eax
  8025d3:	19 fa                	sbb    %edi,%edx
  8025d5:	89 d1                	mov    %edx,%ecx
  8025d7:	89 c6                	mov    %eax,%esi
  8025d9:	e9 71 ff ff ff       	jmp    80254f <__umoddi3+0xb3>
  8025de:	66 90                	xchg   %ax,%ax
  8025e0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8025e4:	72 ea                	jb     8025d0 <__umoddi3+0x134>
  8025e6:	89 d9                	mov    %ebx,%ecx
  8025e8:	e9 62 ff ff ff       	jmp    80254f <__umoddi3+0xb3>

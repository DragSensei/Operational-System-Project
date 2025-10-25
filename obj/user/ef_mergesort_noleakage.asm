
obj/user/ef_mergesort_noleakage:     file format elf32-i386


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
  800031:	e8 2f 07 00 00       	call   800765 <libmain>
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
	char Line[255] ;
	char Chose ;
	do
	{
		//2012: lock the interrupt
		sys_lock_cons();
  800041:	e8 a8 1c 00 00       	call   801cee <sys_lock_cons>

		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 e0 25 80 00       	push   $0x8025e0
  80004e:	e8 90 0b 00 00       	call   800be3 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 e2 25 80 00       	push   $0x8025e2
  80005e:	e8 80 0b 00 00       	call   800be3 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!! MERGE SORT !!!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 f8 25 80 00       	push   $0x8025f8
  80006e:	e8 70 0b 00 00       	call   800be3 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 e2 25 80 00       	push   $0x8025e2
  80007e:	e8 60 0b 00 00       	call   800be3 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 e0 25 80 00       	push   $0x8025e0
  80008e:	e8 50 0b 00 00       	call   800be3 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp
		//readline("Enter the number of elements: ", Line);
		cprintf("Enter the number of elements: ");
  800096:	83 ec 0c             	sub    $0xc,%esp
  800099:	68 10 26 80 00       	push   $0x802610
  80009e:	e8 40 0b 00 00       	call   800be3 <cprintf>
  8000a3:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = 2000 ;
  8000a6:	c7 45 f0 d0 07 00 00 	movl   $0x7d0,-0x10(%ebp)
		cprintf("%d\n", NumOfElements) ;
  8000ad:	83 ec 08             	sub    $0x8,%esp
  8000b0:	ff 75 f0             	pushl  -0x10(%ebp)
  8000b3:	68 2f 26 80 00       	push   $0x80262f
  8000b8:	e8 26 0b 00 00       	call   800be3 <cprintf>
  8000bd:	83 c4 10             	add    $0x10,%esp

		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  8000c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c3:	c1 e0 02             	shl    $0x2,%eax
  8000c6:	83 ec 0c             	sub    $0xc,%esp
  8000c9:	50                   	push   %eax
  8000ca:	e8 d6 1a 00 00       	call   801ba5 <malloc>
  8000cf:	83 c4 10             	add    $0x10,%esp
  8000d2:	89 45 ec             	mov    %eax,-0x14(%ebp)
		cprintf("Chose the initialization method:\n") ;
  8000d5:	83 ec 0c             	sub    $0xc,%esp
  8000d8:	68 34 26 80 00       	push   $0x802634
  8000dd:	e8 01 0b 00 00       	call   800be3 <cprintf>
  8000e2:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000e5:	83 ec 0c             	sub    $0xc,%esp
  8000e8:	68 56 26 80 00       	push   $0x802656
  8000ed:	e8 f1 0a 00 00       	call   800be3 <cprintf>
  8000f2:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000f5:	83 ec 0c             	sub    $0xc,%esp
  8000f8:	68 64 26 80 00       	push   $0x802664
  8000fd:	e8 e1 0a 00 00       	call   800be3 <cprintf>
  800102:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  800105:	83 ec 0c             	sub    $0xc,%esp
  800108:	68 73 26 80 00       	push   $0x802673
  80010d:	e8 d1 0a 00 00       	call   800be3 <cprintf>
  800112:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  800115:	83 ec 0c             	sub    $0xc,%esp
  800118:	68 83 26 80 00       	push   $0x802683
  80011d:	e8 c1 0a 00 00       	call   800be3 <cprintf>
  800122:	83 c4 10             	add    $0x10,%esp
			//Chose = getchar() ;
			Chose = 'a';
  800125:	c6 45 f7 61          	movb   $0x61,-0x9(%ebp)
			cputchar(Chose);
  800129:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80012d:	83 ec 0c             	sub    $0xc,%esp
  800130:	50                   	push   %eax
  800131:	e8 f3 05 00 00       	call   800729 <cputchar>
  800136:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800139:	83 ec 0c             	sub    $0xc,%esp
  80013c:	6a 0a                	push   $0xa
  80013e:	e8 e6 05 00 00       	call   800729 <cputchar>
  800143:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800146:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  80014a:	74 0c                	je     800158 <_main+0x120>
  80014c:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  800150:	74 06                	je     800158 <_main+0x120>
  800152:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  800156:	75 bd                	jne    800115 <_main+0xdd>

		//2012: lock the interrupt
		sys_unlock_cons();
  800158:	e8 ab 1b 00 00       	call   801d08 <sys_unlock_cons>

		int  i ;
		switch (Chose)
  80015d:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800161:	83 f8 62             	cmp    $0x62,%eax
  800164:	74 1d                	je     800183 <_main+0x14b>
  800166:	83 f8 63             	cmp    $0x63,%eax
  800169:	74 2b                	je     800196 <_main+0x15e>
  80016b:	83 f8 61             	cmp    $0x61,%eax
  80016e:	75 39                	jne    8001a9 <_main+0x171>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  800170:	83 ec 08             	sub    $0x8,%esp
  800173:	ff 75 f0             	pushl  -0x10(%ebp)
  800176:	ff 75 ec             	pushl  -0x14(%ebp)
  800179:	e8 f5 01 00 00       	call   800373 <InitializeAscending>
  80017e:	83 c4 10             	add    $0x10,%esp
			break ;
  800181:	eb 37                	jmp    8001ba <_main+0x182>
		case 'b':
			InitializeIdentical(Elements, NumOfElements);
  800183:	83 ec 08             	sub    $0x8,%esp
  800186:	ff 75 f0             	pushl  -0x10(%ebp)
  800189:	ff 75 ec             	pushl  -0x14(%ebp)
  80018c:	e8 13 02 00 00       	call   8003a4 <InitializeIdentical>
  800191:	83 c4 10             	add    $0x10,%esp
			break ;
  800194:	eb 24                	jmp    8001ba <_main+0x182>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  800196:	83 ec 08             	sub    $0x8,%esp
  800199:	ff 75 f0             	pushl  -0x10(%ebp)
  80019c:	ff 75 ec             	pushl  -0x14(%ebp)
  80019f:	e8 35 02 00 00       	call   8003d9 <InitializeSemiRandom>
  8001a4:	83 c4 10             	add    $0x10,%esp
			break ;
  8001a7:	eb 11                	jmp    8001ba <_main+0x182>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001a9:	83 ec 08             	sub    $0x8,%esp
  8001ac:	ff 75 f0             	pushl  -0x10(%ebp)
  8001af:	ff 75 ec             	pushl  -0x14(%ebp)
  8001b2:	e8 22 02 00 00       	call   8003d9 <InitializeSemiRandom>
  8001b7:	83 c4 10             	add    $0x10,%esp
		}

		MSort(Elements, 1, NumOfElements);
  8001ba:	83 ec 04             	sub    $0x4,%esp
  8001bd:	ff 75 f0             	pushl  -0x10(%ebp)
  8001c0:	6a 01                	push   $0x1
  8001c2:	ff 75 ec             	pushl  -0x14(%ebp)
  8001c5:	e8 ee 02 00 00       	call   8004b8 <MSort>
  8001ca:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8001cd:	e8 1c 1b 00 00       	call   801cee <sys_lock_cons>
		cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001d2:	83 ec 0c             	sub    $0xc,%esp
  8001d5:	68 8c 26 80 00       	push   $0x80268c
  8001da:	e8 04 0a 00 00       	call   800be3 <cprintf>
  8001df:	83 c4 10             	add    $0x10,%esp
		//PrintElements(Elements, NumOfElements);
		sys_unlock_cons();
  8001e2:	e8 21 1b 00 00       	call   801d08 <sys_unlock_cons>

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001e7:	83 ec 08             	sub    $0x8,%esp
  8001ea:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ed:	ff 75 ec             	pushl  -0x14(%ebp)
  8001f0:	e8 d4 00 00 00       	call   8002c9 <CheckSorted>
  8001f5:	83 c4 10             	add    $0x10,%esp
  8001f8:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  8001fb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8001ff:	75 14                	jne    800215 <_main+0x1dd>
  800201:	83 ec 04             	sub    $0x4,%esp
  800204:	68 c0 26 80 00       	push   $0x8026c0
  800209:	6a 4e                	push   $0x4e
  80020b:	68 e2 26 80 00       	push   $0x8026e2
  800210:	e8 00 07 00 00       	call   800915 <_panic>
		else
		{
			sys_lock_cons();
  800215:	e8 d4 1a 00 00       	call   801cee <sys_lock_cons>
			cprintf("===============================================\n") ;
  80021a:	83 ec 0c             	sub    $0xc,%esp
  80021d:	68 00 27 80 00       	push   $0x802700
  800222:	e8 bc 09 00 00       	call   800be3 <cprintf>
  800227:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  80022a:	83 ec 0c             	sub    $0xc,%esp
  80022d:	68 34 27 80 00       	push   $0x802734
  800232:	e8 ac 09 00 00       	call   800be3 <cprintf>
  800237:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  80023a:	83 ec 0c             	sub    $0xc,%esp
  80023d:	68 68 27 80 00       	push   $0x802768
  800242:	e8 9c 09 00 00       	call   800be3 <cprintf>
  800247:	83 c4 10             	add    $0x10,%esp
			sys_unlock_cons();
  80024a:	e8 b9 1a 00 00       	call   801d08 <sys_unlock_cons>
		}

		free(Elements) ;
  80024f:	83 ec 0c             	sub    $0xc,%esp
  800252:	ff 75 ec             	pushl  -0x14(%ebp)
  800255:	e8 79 19 00 00       	call   801bd3 <free>
  80025a:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  80025d:	e8 8c 1a 00 00       	call   801cee <sys_lock_cons>
			Chose = 0 ;
  800262:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800266:	eb 3e                	jmp    8002a6 <_main+0x26e>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800268:	83 ec 0c             	sub    $0xc,%esp
  80026b:	68 9a 27 80 00       	push   $0x80279a
  800270:	e8 6e 09 00 00       	call   800be3 <cprintf>
  800275:	83 c4 10             	add    $0x10,%esp
				Chose = 'n' ;
  800278:	c6 45 f7 6e          	movb   $0x6e,-0x9(%ebp)
				cputchar(Chose);
  80027c:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800280:	83 ec 0c             	sub    $0xc,%esp
  800283:	50                   	push   %eax
  800284:	e8 a0 04 00 00       	call   800729 <cputchar>
  800289:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	6a 0a                	push   $0xa
  800291:	e8 93 04 00 00       	call   800729 <cputchar>
  800296:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  800299:	83 ec 0c             	sub    $0xc,%esp
  80029c:	6a 0a                	push   $0xa
  80029e:	e8 86 04 00 00       	call   800729 <cputchar>
  8002a3:	83 c4 10             	add    $0x10,%esp

		free(Elements) ;

		sys_lock_cons();
			Chose = 0 ;
			while (Chose != 'y' && Chose != 'n')
  8002a6:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002aa:	74 06                	je     8002b2 <_main+0x27a>
  8002ac:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  8002b0:	75 b6                	jne    800268 <_main+0x230>
				Chose = 'n' ;
				cputchar(Chose);
				cputchar('\n');
				cputchar('\n');
			}
		sys_unlock_cons();
  8002b2:	e8 51 1a 00 00       	call   801d08 <sys_unlock_cons>

	} while (Chose == 'y');
  8002b7:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002bb:	0f 84 80 fd ff ff    	je     800041 <_main+0x9>

	//To indicate that it's completed successfully
	inctst();
  8002c1:	e8 df 1d 00 00       	call   8020a5 <inctst>

}
  8002c6:	90                   	nop
  8002c7:	c9                   	leave  
  8002c8:	c3                   	ret    

008002c9 <CheckSorted>:


uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8002c9:	55                   	push   %ebp
  8002ca:	89 e5                	mov    %esp,%ebp
  8002cc:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8002cf:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8002d6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8002dd:	eb 33                	jmp    800312 <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8002df:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002e2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ec:	01 d0                	add    %edx,%eax
  8002ee:	8b 10                	mov    (%eax),%edx
  8002f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002f3:	40                   	inc    %eax
  8002f4:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8002fe:	01 c8                	add    %ecx,%eax
  800300:	8b 00                	mov    (%eax),%eax
  800302:	39 c2                	cmp    %eax,%edx
  800304:	7e 09                	jle    80030f <CheckSorted+0x46>
		{
			Sorted = 0 ;
  800306:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  80030d:	eb 0c                	jmp    80031b <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  80030f:	ff 45 f8             	incl   -0x8(%ebp)
  800312:	8b 45 0c             	mov    0xc(%ebp),%eax
  800315:	48                   	dec    %eax
  800316:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800319:	7f c4                	jg     8002df <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  80031b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80031e:	c9                   	leave  
  80031f:	c3                   	ret    

00800320 <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  800320:	55                   	push   %ebp
  800321:	89 e5                	mov    %esp,%ebp
  800323:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800326:	8b 45 0c             	mov    0xc(%ebp),%eax
  800329:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800330:	8b 45 08             	mov    0x8(%ebp),%eax
  800333:	01 d0                	add    %edx,%eax
  800335:	8b 00                	mov    (%eax),%eax
  800337:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  80033a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80033d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800344:	8b 45 08             	mov    0x8(%ebp),%eax
  800347:	01 c2                	add    %eax,%edx
  800349:	8b 45 10             	mov    0x10(%ebp),%eax
  80034c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800353:	8b 45 08             	mov    0x8(%ebp),%eax
  800356:	01 c8                	add    %ecx,%eax
  800358:	8b 00                	mov    (%eax),%eax
  80035a:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  80035c:	8b 45 10             	mov    0x10(%ebp),%eax
  80035f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800366:	8b 45 08             	mov    0x8(%ebp),%eax
  800369:	01 c2                	add    %eax,%edx
  80036b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80036e:	89 02                	mov    %eax,(%edx)
}
  800370:	90                   	nop
  800371:	c9                   	leave  
  800372:	c3                   	ret    

00800373 <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  800373:	55                   	push   %ebp
  800374:	89 e5                	mov    %esp,%ebp
  800376:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800379:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800380:	eb 17                	jmp    800399 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  800382:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800385:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80038c:	8b 45 08             	mov    0x8(%ebp),%eax
  80038f:	01 c2                	add    %eax,%edx
  800391:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800394:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800396:	ff 45 fc             	incl   -0x4(%ebp)
  800399:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80039c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80039f:	7c e1                	jl     800382 <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8003a1:	90                   	nop
  8003a2:	c9                   	leave  
  8003a3:	c3                   	ret    

008003a4 <InitializeIdentical>:

void InitializeIdentical(int *Elements, int NumOfElements)
{
  8003a4:	55                   	push   %ebp
  8003a5:	89 e5                	mov    %esp,%ebp
  8003a7:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003aa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003b1:	eb 1b                	jmp    8003ce <InitializeIdentical+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8003b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003b6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c0:	01 c2                	add    %eax,%edx
  8003c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003c5:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8003c8:	48                   	dec    %eax
  8003c9:	89 02                	mov    %eax,(%edx)
}

void InitializeIdentical(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003cb:	ff 45 fc             	incl   -0x4(%ebp)
  8003ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003d1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003d4:	7c dd                	jl     8003b3 <InitializeIdentical+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8003d6:	90                   	nop
  8003d7:	c9                   	leave  
  8003d8:	c3                   	ret    

008003d9 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8003d9:	55                   	push   %ebp
  8003da:	89 e5                	mov    %esp,%ebp
  8003dc:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8003df:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003e2:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8003e7:	f7 e9                	imul   %ecx
  8003e9:	c1 f9 1f             	sar    $0x1f,%ecx
  8003ec:	89 d0                	mov    %edx,%eax
  8003ee:	29 c8                	sub    %ecx,%eax
  8003f0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (Repetition == 0)
  8003f3:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8003f7:	75 07                	jne    800400 <InitializeSemiRandom+0x27>
			Repetition = 3;
  8003f9:	c7 45 f8 03 00 00 00 	movl   $0x3,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  800400:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800407:	eb 1e                	jmp    800427 <InitializeSemiRandom+0x4e>
	{
		Elements[i] = i % Repetition ;
  800409:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80040c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800413:	8b 45 08             	mov    0x8(%ebp),%eax
  800416:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800419:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80041c:	99                   	cltd   
  80041d:	f7 7d f8             	idivl  -0x8(%ebp)
  800420:	89 d0                	mov    %edx,%eax
  800422:	89 01                	mov    %eax,(%ecx)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	if (Repetition == 0)
			Repetition = 3;
	for (i = 0 ; i < NumOfElements ; i++)
  800424:	ff 45 fc             	incl   -0x4(%ebp)
  800427:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80042a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80042d:	7c da                	jl     800409 <InitializeSemiRandom+0x30>
	{
		Elements[i] = i % Repetition ;
		//	cprintf("i=%d\n",i);
	}

}
  80042f:	90                   	nop
  800430:	c9                   	leave  
  800431:	c3                   	ret    

00800432 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  800432:	55                   	push   %ebp
  800433:	89 e5                	mov    %esp,%ebp
  800435:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800438:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80043f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800446:	eb 42                	jmp    80048a <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800448:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80044b:	99                   	cltd   
  80044c:	f7 7d f0             	idivl  -0x10(%ebp)
  80044f:	89 d0                	mov    %edx,%eax
  800451:	85 c0                	test   %eax,%eax
  800453:	75 10                	jne    800465 <PrintElements+0x33>
			cprintf("\n");
  800455:	83 ec 0c             	sub    $0xc,%esp
  800458:	68 e0 25 80 00       	push   $0x8025e0
  80045d:	e8 81 07 00 00       	call   800be3 <cprintf>
  800462:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800465:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800468:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80046f:	8b 45 08             	mov    0x8(%ebp),%eax
  800472:	01 d0                	add    %edx,%eax
  800474:	8b 00                	mov    (%eax),%eax
  800476:	83 ec 08             	sub    $0x8,%esp
  800479:	50                   	push   %eax
  80047a:	68 b8 27 80 00       	push   $0x8027b8
  80047f:	e8 5f 07 00 00       	call   800be3 <cprintf>
  800484:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800487:	ff 45 f4             	incl   -0xc(%ebp)
  80048a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80048d:	48                   	dec    %eax
  80048e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800491:	7f b5                	jg     800448 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  800493:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800496:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80049d:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a0:	01 d0                	add    %edx,%eax
  8004a2:	8b 00                	mov    (%eax),%eax
  8004a4:	83 ec 08             	sub    $0x8,%esp
  8004a7:	50                   	push   %eax
  8004a8:	68 2f 26 80 00       	push   $0x80262f
  8004ad:	e8 31 07 00 00       	call   800be3 <cprintf>
  8004b2:	83 c4 10             	add    $0x10,%esp

}
  8004b5:	90                   	nop
  8004b6:	c9                   	leave  
  8004b7:	c3                   	ret    

008004b8 <MSort>:


void MSort(int* A, int p, int r)
{
  8004b8:	55                   	push   %ebp
  8004b9:	89 e5                	mov    %esp,%ebp
  8004bb:	83 ec 18             	sub    $0x18,%esp
	if (p >= r)
  8004be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c1:	3b 45 10             	cmp    0x10(%ebp),%eax
  8004c4:	7d 54                	jge    80051a <MSort+0x62>
	{
		return;
	}

	int q = (p + r) / 2;
  8004c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8004cc:	01 d0                	add    %edx,%eax
  8004ce:	89 c2                	mov    %eax,%edx
  8004d0:	c1 ea 1f             	shr    $0x1f,%edx
  8004d3:	01 d0                	add    %edx,%eax
  8004d5:	d1 f8                	sar    %eax
  8004d7:	89 45 f4             	mov    %eax,-0xc(%ebp)

	MSort(A, p, q);
  8004da:	83 ec 04             	sub    $0x4,%esp
  8004dd:	ff 75 f4             	pushl  -0xc(%ebp)
  8004e0:	ff 75 0c             	pushl  0xc(%ebp)
  8004e3:	ff 75 08             	pushl  0x8(%ebp)
  8004e6:	e8 cd ff ff ff       	call   8004b8 <MSort>
  8004eb:	83 c4 10             	add    $0x10,%esp

	MSort(A, q + 1, r);
  8004ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004f1:	40                   	inc    %eax
  8004f2:	83 ec 04             	sub    $0x4,%esp
  8004f5:	ff 75 10             	pushl  0x10(%ebp)
  8004f8:	50                   	push   %eax
  8004f9:	ff 75 08             	pushl  0x8(%ebp)
  8004fc:	e8 b7 ff ff ff       	call   8004b8 <MSort>
  800501:	83 c4 10             	add    $0x10,%esp

	Merge(A, p, q, r);
  800504:	ff 75 10             	pushl  0x10(%ebp)
  800507:	ff 75 f4             	pushl  -0xc(%ebp)
  80050a:	ff 75 0c             	pushl  0xc(%ebp)
  80050d:	ff 75 08             	pushl  0x8(%ebp)
  800510:	e8 08 00 00 00       	call   80051d <Merge>
  800515:	83 c4 10             	add    $0x10,%esp
  800518:	eb 01                	jmp    80051b <MSort+0x63>

void MSort(int* A, int p, int r)
{
	if (p >= r)
	{
		return;
  80051a:	90                   	nop

	MSort(A, q + 1, r);

	Merge(A, p, q, r);

}
  80051b:	c9                   	leave  
  80051c:	c3                   	ret    

0080051d <Merge>:

void Merge(int* A, int p, int q, int r)
{
  80051d:	55                   	push   %ebp
  80051e:	89 e5                	mov    %esp,%ebp
  800520:	83 ec 38             	sub    $0x38,%esp
	int leftCapacity = q - p + 1;
  800523:	8b 45 10             	mov    0x10(%ebp),%eax
  800526:	2b 45 0c             	sub    0xc(%ebp),%eax
  800529:	40                   	inc    %eax
  80052a:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int rightCapacity = r - q;
  80052d:	8b 45 14             	mov    0x14(%ebp),%eax
  800530:	2b 45 10             	sub    0x10(%ebp),%eax
  800533:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int leftIndex = 0;
  800536:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int rightIndex = 0;
  80053d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int* Left = malloc(sizeof(int) * leftCapacity);
  800544:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800547:	c1 e0 02             	shl    $0x2,%eax
  80054a:	83 ec 0c             	sub    $0xc,%esp
  80054d:	50                   	push   %eax
  80054e:	e8 52 16 00 00       	call   801ba5 <malloc>
  800553:	83 c4 10             	add    $0x10,%esp
  800556:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* Right = malloc(sizeof(int) * rightCapacity);
  800559:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80055c:	c1 e0 02             	shl    $0x2,%eax
  80055f:	83 ec 0c             	sub    $0xc,%esp
  800562:	50                   	push   %eax
  800563:	e8 3d 16 00 00       	call   801ba5 <malloc>
  800568:	83 c4 10             	add    $0x10,%esp
  80056b:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  80056e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800575:	eb 2f                	jmp    8005a6 <Merge+0x89>
	{
		Left[i] = A[p + i - 1];
  800577:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80057a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800581:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800584:	01 c2                	add    %eax,%edx
  800586:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800589:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80058c:	01 c8                	add    %ecx,%eax
  80058e:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800593:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80059a:	8b 45 08             	mov    0x8(%ebp),%eax
  80059d:	01 c8                	add    %ecx,%eax
  80059f:	8b 00                	mov    (%eax),%eax
  8005a1:	89 02                	mov    %eax,(%edx)
	int* Left = malloc(sizeof(int) * leftCapacity);

	int* Right = malloc(sizeof(int) * rightCapacity);

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  8005a3:	ff 45 ec             	incl   -0x14(%ebp)
  8005a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005a9:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005ac:	7c c9                	jl     800577 <Merge+0x5a>
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8005ae:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005b5:	eb 2a                	jmp    8005e1 <Merge+0xc4>
	{
		Right[j] = A[q + j];
  8005b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005ba:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005c1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005c4:	01 c2                	add    %eax,%edx
  8005c6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8005c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005cc:	01 c8                	add    %ecx,%eax
  8005ce:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d8:	01 c8                	add    %ecx,%eax
  8005da:	8b 00                	mov    (%eax),%eax
  8005dc:	89 02                	mov    %eax,(%edx)
	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8005de:	ff 45 e8             	incl   -0x18(%ebp)
  8005e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005e4:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8005e7:	7c ce                	jl     8005b7 <Merge+0x9a>
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8005e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005ef:	e9 0a 01 00 00       	jmp    8006fe <Merge+0x1e1>
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
  8005f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005f7:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005fa:	0f 8d 95 00 00 00    	jge    800695 <Merge+0x178>
  800600:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800603:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800606:	0f 8d 89 00 00 00    	jge    800695 <Merge+0x178>
		{
			if (Left[leftIndex] < Right[rightIndex] )
  80060c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80060f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800616:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800619:	01 d0                	add    %edx,%eax
  80061b:	8b 10                	mov    (%eax),%edx
  80061d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800620:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800627:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80062a:	01 c8                	add    %ecx,%eax
  80062c:	8b 00                	mov    (%eax),%eax
  80062e:	39 c2                	cmp    %eax,%edx
  800630:	7d 33                	jge    800665 <Merge+0x148>
			{
				A[k - 1] = Left[leftIndex++];
  800632:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800635:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80063a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800641:	8b 45 08             	mov    0x8(%ebp),%eax
  800644:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800647:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80064a:	8d 50 01             	lea    0x1(%eax),%edx
  80064d:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800650:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800657:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80065a:	01 d0                	add    %edx,%eax
  80065c:	8b 00                	mov    (%eax),%eax
  80065e:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800660:	e9 96 00 00 00       	jmp    8006fb <Merge+0x1de>
			{
				A[k - 1] = Left[leftIndex++];
			}
			else
			{
				A[k - 1] = Right[rightIndex++];
  800665:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800668:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80066d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800674:	8b 45 08             	mov    0x8(%ebp),%eax
  800677:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80067a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80067d:	8d 50 01             	lea    0x1(%eax),%edx
  800680:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800683:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80068a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80068d:	01 d0                	add    %edx,%eax
  80068f:	8b 00                	mov    (%eax),%eax
  800691:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800693:	eb 66                	jmp    8006fb <Merge+0x1de>
			else
			{
				A[k - 1] = Right[rightIndex++];
			}
		}
		else if (leftIndex < leftCapacity)
  800695:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800698:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80069b:	7d 30                	jge    8006cd <Merge+0x1b0>
		{
			A[k - 1] = Left[leftIndex++];
  80069d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006a0:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8006a5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8006af:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006b5:	8d 50 01             	lea    0x1(%eax),%edx
  8006b8:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8006bb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006c2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006c5:	01 d0                	add    %edx,%eax
  8006c7:	8b 00                	mov    (%eax),%eax
  8006c9:	89 01                	mov    %eax,(%ecx)
  8006cb:	eb 2e                	jmp    8006fb <Merge+0x1de>
		}
		else
		{
			A[k - 1] = Right[rightIndex++];
  8006cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006d0:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8006d5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006df:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006e5:	8d 50 01             	lea    0x1(%eax),%edx
  8006e8:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8006eb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006f2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006f5:	01 d0                	add    %edx,%eax
  8006f7:	8b 00                	mov    (%eax),%eax
  8006f9:	89 01                	mov    %eax,(%ecx)
	for (j = 0; j < rightCapacity; j++)
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8006fb:	ff 45 e4             	incl   -0x1c(%ebp)
  8006fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800701:	3b 45 14             	cmp    0x14(%ebp),%eax
  800704:	0f 8e ea fe ff ff    	jle    8005f4 <Merge+0xd7>
		{
			A[k - 1] = Right[rightIndex++];
		}
	}

	free(Left);
  80070a:	83 ec 0c             	sub    $0xc,%esp
  80070d:	ff 75 d8             	pushl  -0x28(%ebp)
  800710:	e8 be 14 00 00       	call   801bd3 <free>
  800715:	83 c4 10             	add    $0x10,%esp
	free(Right);
  800718:	83 ec 0c             	sub    $0xc,%esp
  80071b:	ff 75 d4             	pushl  -0x2c(%ebp)
  80071e:	e8 b0 14 00 00       	call   801bd3 <free>
  800723:	83 c4 10             	add    $0x10,%esp

}
  800726:	90                   	nop
  800727:	c9                   	leave  
  800728:	c3                   	ret    

00800729 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  800729:	55                   	push   %ebp
  80072a:	89 e5                	mov    %esp,%ebp
  80072c:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  80072f:	8b 45 08             	mov    0x8(%ebp),%eax
  800732:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800735:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800739:	83 ec 0c             	sub    $0xc,%esp
  80073c:	50                   	push   %eax
  80073d:	e8 f4 16 00 00       	call   801e36 <sys_cputc>
  800742:	83 c4 10             	add    $0x10,%esp
}
  800745:	90                   	nop
  800746:	c9                   	leave  
  800747:	c3                   	ret    

00800748 <getchar>:


int
getchar(void)
{
  800748:	55                   	push   %ebp
  800749:	89 e5                	mov    %esp,%ebp
  80074b:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  80074e:	e8 82 15 00 00       	call   801cd5 <sys_cgetc>
  800753:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  800756:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800759:	c9                   	leave  
  80075a:	c3                   	ret    

0080075b <iscons>:

int iscons(int fdnum)
{
  80075b:	55                   	push   %ebp
  80075c:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  80075e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800763:	5d                   	pop    %ebp
  800764:	c3                   	ret    

00800765 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800765:	55                   	push   %ebp
  800766:	89 e5                	mov    %esp,%ebp
  800768:	57                   	push   %edi
  800769:	56                   	push   %esi
  80076a:	53                   	push   %ebx
  80076b:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80076e:	e8 f4 17 00 00       	call   801f67 <sys_getenvindex>
  800773:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800776:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800779:	89 d0                	mov    %edx,%eax
  80077b:	c1 e0 02             	shl    $0x2,%eax
  80077e:	01 d0                	add    %edx,%eax
  800780:	c1 e0 03             	shl    $0x3,%eax
  800783:	01 d0                	add    %edx,%eax
  800785:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80078c:	01 d0                	add    %edx,%eax
  80078e:	c1 e0 02             	shl    $0x2,%eax
  800791:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800796:	a3 24 40 80 00       	mov    %eax,0x804024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80079b:	a1 24 40 80 00       	mov    0x804024,%eax
  8007a0:	8a 40 20             	mov    0x20(%eax),%al
  8007a3:	84 c0                	test   %al,%al
  8007a5:	74 0d                	je     8007b4 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8007a7:	a1 24 40 80 00       	mov    0x804024,%eax
  8007ac:	83 c0 20             	add    $0x20,%eax
  8007af:	a3 04 40 80 00       	mov    %eax,0x804004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8007b4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8007b8:	7e 0a                	jle    8007c4 <libmain+0x5f>
		binaryname = argv[0];
  8007ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007bd:	8b 00                	mov    (%eax),%eax
  8007bf:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	_main(argc, argv);
  8007c4:	83 ec 08             	sub    $0x8,%esp
  8007c7:	ff 75 0c             	pushl  0xc(%ebp)
  8007ca:	ff 75 08             	pushl  0x8(%ebp)
  8007cd:	e8 66 f8 ff ff       	call   800038 <_main>
  8007d2:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8007d5:	a1 00 40 80 00       	mov    0x804000,%eax
  8007da:	85 c0                	test   %eax,%eax
  8007dc:	0f 84 01 01 00 00    	je     8008e3 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8007e2:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8007e8:	bb b8 28 80 00       	mov    $0x8028b8,%ebx
  8007ed:	ba 0e 00 00 00       	mov    $0xe,%edx
  8007f2:	89 c7                	mov    %eax,%edi
  8007f4:	89 de                	mov    %ebx,%esi
  8007f6:	89 d1                	mov    %edx,%ecx
  8007f8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8007fa:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8007fd:	b9 56 00 00 00       	mov    $0x56,%ecx
  800802:	b0 00                	mov    $0x0,%al
  800804:	89 d7                	mov    %edx,%edi
  800806:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800808:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80080f:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800812:	83 ec 08             	sub    $0x8,%esp
  800815:	50                   	push   %eax
  800816:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80081c:	50                   	push   %eax
  80081d:	e8 7b 19 00 00       	call   80219d <sys_utilities>
  800822:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800825:	e8 c4 14 00 00       	call   801cee <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80082a:	83 ec 0c             	sub    $0xc,%esp
  80082d:	68 d8 27 80 00       	push   $0x8027d8
  800832:	e8 ac 03 00 00       	call   800be3 <cprintf>
  800837:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80083a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80083d:	85 c0                	test   %eax,%eax
  80083f:	74 18                	je     800859 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800841:	e8 75 19 00 00       	call   8021bb <sys_get_optimal_num_faults>
  800846:	83 ec 08             	sub    $0x8,%esp
  800849:	50                   	push   %eax
  80084a:	68 00 28 80 00       	push   $0x802800
  80084f:	e8 8f 03 00 00       	call   800be3 <cprintf>
  800854:	83 c4 10             	add    $0x10,%esp
  800857:	eb 59                	jmp    8008b2 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800859:	a1 24 40 80 00       	mov    0x804024,%eax
  80085e:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  800864:	a1 24 40 80 00       	mov    0x804024,%eax
  800869:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  80086f:	83 ec 04             	sub    $0x4,%esp
  800872:	52                   	push   %edx
  800873:	50                   	push   %eax
  800874:	68 24 28 80 00       	push   $0x802824
  800879:	e8 65 03 00 00       	call   800be3 <cprintf>
  80087e:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800881:	a1 24 40 80 00       	mov    0x804024,%eax
  800886:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  80088c:	a1 24 40 80 00       	mov    0x804024,%eax
  800891:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  800897:	a1 24 40 80 00       	mov    0x804024,%eax
  80089c:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  8008a2:	51                   	push   %ecx
  8008a3:	52                   	push   %edx
  8008a4:	50                   	push   %eax
  8008a5:	68 4c 28 80 00       	push   $0x80284c
  8008aa:	e8 34 03 00 00       	call   800be3 <cprintf>
  8008af:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8008b2:	a1 24 40 80 00       	mov    0x804024,%eax
  8008b7:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  8008bd:	83 ec 08             	sub    $0x8,%esp
  8008c0:	50                   	push   %eax
  8008c1:	68 a4 28 80 00       	push   $0x8028a4
  8008c6:	e8 18 03 00 00       	call   800be3 <cprintf>
  8008cb:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8008ce:	83 ec 0c             	sub    $0xc,%esp
  8008d1:	68 d8 27 80 00       	push   $0x8027d8
  8008d6:	e8 08 03 00 00       	call   800be3 <cprintf>
  8008db:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8008de:	e8 25 14 00 00       	call   801d08 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8008e3:	e8 1f 00 00 00       	call   800907 <exit>
}
  8008e8:	90                   	nop
  8008e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008ec:	5b                   	pop    %ebx
  8008ed:	5e                   	pop    %esi
  8008ee:	5f                   	pop    %edi
  8008ef:	5d                   	pop    %ebp
  8008f0:	c3                   	ret    

008008f1 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8008f1:	55                   	push   %ebp
  8008f2:	89 e5                	mov    %esp,%ebp
  8008f4:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8008f7:	83 ec 0c             	sub    $0xc,%esp
  8008fa:	6a 00                	push   $0x0
  8008fc:	e8 32 16 00 00       	call   801f33 <sys_destroy_env>
  800901:	83 c4 10             	add    $0x10,%esp
}
  800904:	90                   	nop
  800905:	c9                   	leave  
  800906:	c3                   	ret    

00800907 <exit>:

void
exit(void)
{
  800907:	55                   	push   %ebp
  800908:	89 e5                	mov    %esp,%ebp
  80090a:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80090d:	e8 87 16 00 00       	call   801f99 <sys_exit_env>
}
  800912:	90                   	nop
  800913:	c9                   	leave  
  800914:	c3                   	ret    

00800915 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800915:	55                   	push   %ebp
  800916:	89 e5                	mov    %esp,%ebp
  800918:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80091b:	8d 45 10             	lea    0x10(%ebp),%eax
  80091e:	83 c0 04             	add    $0x4,%eax
  800921:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800924:	a1 18 c1 81 00       	mov    0x81c118,%eax
  800929:	85 c0                	test   %eax,%eax
  80092b:	74 16                	je     800943 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80092d:	a1 18 c1 81 00       	mov    0x81c118,%eax
  800932:	83 ec 08             	sub    $0x8,%esp
  800935:	50                   	push   %eax
  800936:	68 1c 29 80 00       	push   $0x80291c
  80093b:	e8 a3 02 00 00       	call   800be3 <cprintf>
  800940:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800943:	a1 04 40 80 00       	mov    0x804004,%eax
  800948:	83 ec 0c             	sub    $0xc,%esp
  80094b:	ff 75 0c             	pushl  0xc(%ebp)
  80094e:	ff 75 08             	pushl  0x8(%ebp)
  800951:	50                   	push   %eax
  800952:	68 24 29 80 00       	push   $0x802924
  800957:	6a 74                	push   $0x74
  800959:	e8 b2 02 00 00       	call   800c10 <cprintf_colored>
  80095e:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800961:	8b 45 10             	mov    0x10(%ebp),%eax
  800964:	83 ec 08             	sub    $0x8,%esp
  800967:	ff 75 f4             	pushl  -0xc(%ebp)
  80096a:	50                   	push   %eax
  80096b:	e8 04 02 00 00       	call   800b74 <vcprintf>
  800970:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800973:	83 ec 08             	sub    $0x8,%esp
  800976:	6a 00                	push   $0x0
  800978:	68 4c 29 80 00       	push   $0x80294c
  80097d:	e8 f2 01 00 00       	call   800b74 <vcprintf>
  800982:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800985:	e8 7d ff ff ff       	call   800907 <exit>

	// should not return here
	while (1) ;
  80098a:	eb fe                	jmp    80098a <_panic+0x75>

0080098c <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80098c:	55                   	push   %ebp
  80098d:	89 e5                	mov    %esp,%ebp
  80098f:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800992:	a1 24 40 80 00       	mov    0x804024,%eax
  800997:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80099d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009a0:	39 c2                	cmp    %eax,%edx
  8009a2:	74 14                	je     8009b8 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8009a4:	83 ec 04             	sub    $0x4,%esp
  8009a7:	68 50 29 80 00       	push   $0x802950
  8009ac:	6a 26                	push   $0x26
  8009ae:	68 9c 29 80 00       	push   $0x80299c
  8009b3:	e8 5d ff ff ff       	call   800915 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8009b8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8009bf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8009c6:	e9 c5 00 00 00       	jmp    800a90 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8009cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009ce:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8009d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d8:	01 d0                	add    %edx,%eax
  8009da:	8b 00                	mov    (%eax),%eax
  8009dc:	85 c0                	test   %eax,%eax
  8009de:	75 08                	jne    8009e8 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8009e0:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8009e3:	e9 a5 00 00 00       	jmp    800a8d <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8009e8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009ef:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8009f6:	eb 69                	jmp    800a61 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8009f8:	a1 24 40 80 00       	mov    0x804024,%eax
  8009fd:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800a03:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a06:	89 d0                	mov    %edx,%eax
  800a08:	01 c0                	add    %eax,%eax
  800a0a:	01 d0                	add    %edx,%eax
  800a0c:	c1 e0 03             	shl    $0x3,%eax
  800a0f:	01 c8                	add    %ecx,%eax
  800a11:	8a 40 04             	mov    0x4(%eax),%al
  800a14:	84 c0                	test   %al,%al
  800a16:	75 46                	jne    800a5e <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a18:	a1 24 40 80 00       	mov    0x804024,%eax
  800a1d:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800a23:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a26:	89 d0                	mov    %edx,%eax
  800a28:	01 c0                	add    %eax,%eax
  800a2a:	01 d0                	add    %edx,%eax
  800a2c:	c1 e0 03             	shl    $0x3,%eax
  800a2f:	01 c8                	add    %ecx,%eax
  800a31:	8b 00                	mov    (%eax),%eax
  800a33:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800a36:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800a39:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800a3e:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800a40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a43:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4d:	01 c8                	add    %ecx,%eax
  800a4f:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a51:	39 c2                	cmp    %eax,%edx
  800a53:	75 09                	jne    800a5e <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800a55:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800a5c:	eb 15                	jmp    800a73 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a5e:	ff 45 e8             	incl   -0x18(%ebp)
  800a61:	a1 24 40 80 00       	mov    0x804024,%eax
  800a66:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800a6c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a6f:	39 c2                	cmp    %eax,%edx
  800a71:	77 85                	ja     8009f8 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800a73:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800a77:	75 14                	jne    800a8d <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800a79:	83 ec 04             	sub    $0x4,%esp
  800a7c:	68 a8 29 80 00       	push   $0x8029a8
  800a81:	6a 3a                	push   $0x3a
  800a83:	68 9c 29 80 00       	push   $0x80299c
  800a88:	e8 88 fe ff ff       	call   800915 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800a8d:	ff 45 f0             	incl   -0x10(%ebp)
  800a90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a93:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800a96:	0f 8c 2f ff ff ff    	jl     8009cb <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800a9c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800aa3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800aaa:	eb 26                	jmp    800ad2 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800aac:	a1 24 40 80 00       	mov    0x804024,%eax
  800ab1:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800ab7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800aba:	89 d0                	mov    %edx,%eax
  800abc:	01 c0                	add    %eax,%eax
  800abe:	01 d0                	add    %edx,%eax
  800ac0:	c1 e0 03             	shl    $0x3,%eax
  800ac3:	01 c8                	add    %ecx,%eax
  800ac5:	8a 40 04             	mov    0x4(%eax),%al
  800ac8:	3c 01                	cmp    $0x1,%al
  800aca:	75 03                	jne    800acf <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800acc:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800acf:	ff 45 e0             	incl   -0x20(%ebp)
  800ad2:	a1 24 40 80 00       	mov    0x804024,%eax
  800ad7:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800add:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ae0:	39 c2                	cmp    %eax,%edx
  800ae2:	77 c8                	ja     800aac <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800ae4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ae7:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800aea:	74 14                	je     800b00 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800aec:	83 ec 04             	sub    $0x4,%esp
  800aef:	68 fc 29 80 00       	push   $0x8029fc
  800af4:	6a 44                	push   $0x44
  800af6:	68 9c 29 80 00       	push   $0x80299c
  800afb:	e8 15 fe ff ff       	call   800915 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800b00:	90                   	nop
  800b01:	c9                   	leave  
  800b02:	c3                   	ret    

00800b03 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800b03:	55                   	push   %ebp
  800b04:	89 e5                	mov    %esp,%ebp
  800b06:	53                   	push   %ebx
  800b07:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800b0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0d:	8b 00                	mov    (%eax),%eax
  800b0f:	8d 48 01             	lea    0x1(%eax),%ecx
  800b12:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b15:	89 0a                	mov    %ecx,(%edx)
  800b17:	8b 55 08             	mov    0x8(%ebp),%edx
  800b1a:	88 d1                	mov    %dl,%cl
  800b1c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b1f:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800b23:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b26:	8b 00                	mov    (%eax),%eax
  800b28:	3d ff 00 00 00       	cmp    $0xff,%eax
  800b2d:	75 30                	jne    800b5f <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800b2f:	8b 15 1c c1 81 00    	mov    0x81c11c,%edx
  800b35:	a0 44 40 80 00       	mov    0x804044,%al
  800b3a:	0f b6 c0             	movzbl %al,%eax
  800b3d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b40:	8b 09                	mov    (%ecx),%ecx
  800b42:	89 cb                	mov    %ecx,%ebx
  800b44:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b47:	83 c1 08             	add    $0x8,%ecx
  800b4a:	52                   	push   %edx
  800b4b:	50                   	push   %eax
  800b4c:	53                   	push   %ebx
  800b4d:	51                   	push   %ecx
  800b4e:	e8 57 11 00 00       	call   801caa <sys_cputs>
  800b53:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800b56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b59:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800b5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b62:	8b 40 04             	mov    0x4(%eax),%eax
  800b65:	8d 50 01             	lea    0x1(%eax),%edx
  800b68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b6b:	89 50 04             	mov    %edx,0x4(%eax)
}
  800b6e:	90                   	nop
  800b6f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b72:	c9                   	leave  
  800b73:	c3                   	ret    

00800b74 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800b74:	55                   	push   %ebp
  800b75:	89 e5                	mov    %esp,%ebp
  800b77:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800b7d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800b84:	00 00 00 
	b.cnt = 0;
  800b87:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b8e:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800b91:	ff 75 0c             	pushl  0xc(%ebp)
  800b94:	ff 75 08             	pushl  0x8(%ebp)
  800b97:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b9d:	50                   	push   %eax
  800b9e:	68 03 0b 80 00       	push   $0x800b03
  800ba3:	e8 5a 02 00 00       	call   800e02 <vprintfmt>
  800ba8:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800bab:	8b 15 1c c1 81 00    	mov    0x81c11c,%edx
  800bb1:	a0 44 40 80 00       	mov    0x804044,%al
  800bb6:	0f b6 c0             	movzbl %al,%eax
  800bb9:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800bbf:	52                   	push   %edx
  800bc0:	50                   	push   %eax
  800bc1:	51                   	push   %ecx
  800bc2:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800bc8:	83 c0 08             	add    $0x8,%eax
  800bcb:	50                   	push   %eax
  800bcc:	e8 d9 10 00 00       	call   801caa <sys_cputs>
  800bd1:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800bd4:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
	return b.cnt;
  800bdb:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800be1:	c9                   	leave  
  800be2:	c3                   	ret    

00800be3 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800be3:	55                   	push   %ebp
  800be4:	89 e5                	mov    %esp,%ebp
  800be6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800be9:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	va_start(ap, fmt);
  800bf0:	8d 45 0c             	lea    0xc(%ebp),%eax
  800bf3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf9:	83 ec 08             	sub    $0x8,%esp
  800bfc:	ff 75 f4             	pushl  -0xc(%ebp)
  800bff:	50                   	push   %eax
  800c00:	e8 6f ff ff ff       	call   800b74 <vcprintf>
  800c05:	83 c4 10             	add    $0x10,%esp
  800c08:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800c0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c0e:	c9                   	leave  
  800c0f:	c3                   	ret    

00800c10 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800c10:	55                   	push   %ebp
  800c11:	89 e5                	mov    %esp,%ebp
  800c13:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800c16:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c20:	c1 e0 08             	shl    $0x8,%eax
  800c23:	a3 1c c1 81 00       	mov    %eax,0x81c11c
	va_start(ap, fmt);
  800c28:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c2b:	83 c0 04             	add    $0x4,%eax
  800c2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800c31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c34:	83 ec 08             	sub    $0x8,%esp
  800c37:	ff 75 f4             	pushl  -0xc(%ebp)
  800c3a:	50                   	push   %eax
  800c3b:	e8 34 ff ff ff       	call   800b74 <vcprintf>
  800c40:	83 c4 10             	add    $0x10,%esp
  800c43:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800c46:	c7 05 1c c1 81 00 00 	movl   $0x700,0x81c11c
  800c4d:	07 00 00 

	return cnt;
  800c50:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c53:	c9                   	leave  
  800c54:	c3                   	ret    

00800c55 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800c55:	55                   	push   %ebp
  800c56:	89 e5                	mov    %esp,%ebp
  800c58:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800c5b:	e8 8e 10 00 00       	call   801cee <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800c60:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c63:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800c66:	8b 45 08             	mov    0x8(%ebp),%eax
  800c69:	83 ec 08             	sub    $0x8,%esp
  800c6c:	ff 75 f4             	pushl  -0xc(%ebp)
  800c6f:	50                   	push   %eax
  800c70:	e8 ff fe ff ff       	call   800b74 <vcprintf>
  800c75:	83 c4 10             	add    $0x10,%esp
  800c78:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800c7b:	e8 88 10 00 00       	call   801d08 <sys_unlock_cons>
	return cnt;
  800c80:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c83:	c9                   	leave  
  800c84:	c3                   	ret    

00800c85 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800c85:	55                   	push   %ebp
  800c86:	89 e5                	mov    %esp,%ebp
  800c88:	53                   	push   %ebx
  800c89:	83 ec 14             	sub    $0x14,%esp
  800c8c:	8b 45 10             	mov    0x10(%ebp),%eax
  800c8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c92:	8b 45 14             	mov    0x14(%ebp),%eax
  800c95:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800c98:	8b 45 18             	mov    0x18(%ebp),%eax
  800c9b:	ba 00 00 00 00       	mov    $0x0,%edx
  800ca0:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800ca3:	77 55                	ja     800cfa <printnum+0x75>
  800ca5:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800ca8:	72 05                	jb     800caf <printnum+0x2a>
  800caa:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800cad:	77 4b                	ja     800cfa <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800caf:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800cb2:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800cb5:	8b 45 18             	mov    0x18(%ebp),%eax
  800cb8:	ba 00 00 00 00       	mov    $0x0,%edx
  800cbd:	52                   	push   %edx
  800cbe:	50                   	push   %eax
  800cbf:	ff 75 f4             	pushl  -0xc(%ebp)
  800cc2:	ff 75 f0             	pushl  -0x10(%ebp)
  800cc5:	e8 aa 16 00 00       	call   802374 <__udivdi3>
  800cca:	83 c4 10             	add    $0x10,%esp
  800ccd:	83 ec 04             	sub    $0x4,%esp
  800cd0:	ff 75 20             	pushl  0x20(%ebp)
  800cd3:	53                   	push   %ebx
  800cd4:	ff 75 18             	pushl  0x18(%ebp)
  800cd7:	52                   	push   %edx
  800cd8:	50                   	push   %eax
  800cd9:	ff 75 0c             	pushl  0xc(%ebp)
  800cdc:	ff 75 08             	pushl  0x8(%ebp)
  800cdf:	e8 a1 ff ff ff       	call   800c85 <printnum>
  800ce4:	83 c4 20             	add    $0x20,%esp
  800ce7:	eb 1a                	jmp    800d03 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800ce9:	83 ec 08             	sub    $0x8,%esp
  800cec:	ff 75 0c             	pushl  0xc(%ebp)
  800cef:	ff 75 20             	pushl  0x20(%ebp)
  800cf2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf5:	ff d0                	call   *%eax
  800cf7:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800cfa:	ff 4d 1c             	decl   0x1c(%ebp)
  800cfd:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800d01:	7f e6                	jg     800ce9 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800d03:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800d06:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d0e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d11:	53                   	push   %ebx
  800d12:	51                   	push   %ecx
  800d13:	52                   	push   %edx
  800d14:	50                   	push   %eax
  800d15:	e8 6a 17 00 00       	call   802484 <__umoddi3>
  800d1a:	83 c4 10             	add    $0x10,%esp
  800d1d:	05 74 2c 80 00       	add    $0x802c74,%eax
  800d22:	8a 00                	mov    (%eax),%al
  800d24:	0f be c0             	movsbl %al,%eax
  800d27:	83 ec 08             	sub    $0x8,%esp
  800d2a:	ff 75 0c             	pushl  0xc(%ebp)
  800d2d:	50                   	push   %eax
  800d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d31:	ff d0                	call   *%eax
  800d33:	83 c4 10             	add    $0x10,%esp
}
  800d36:	90                   	nop
  800d37:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800d3a:	c9                   	leave  
  800d3b:	c3                   	ret    

00800d3c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800d3c:	55                   	push   %ebp
  800d3d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d3f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d43:	7e 1c                	jle    800d61 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800d45:	8b 45 08             	mov    0x8(%ebp),%eax
  800d48:	8b 00                	mov    (%eax),%eax
  800d4a:	8d 50 08             	lea    0x8(%eax),%edx
  800d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d50:	89 10                	mov    %edx,(%eax)
  800d52:	8b 45 08             	mov    0x8(%ebp),%eax
  800d55:	8b 00                	mov    (%eax),%eax
  800d57:	83 e8 08             	sub    $0x8,%eax
  800d5a:	8b 50 04             	mov    0x4(%eax),%edx
  800d5d:	8b 00                	mov    (%eax),%eax
  800d5f:	eb 40                	jmp    800da1 <getuint+0x65>
	else if (lflag)
  800d61:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d65:	74 1e                	je     800d85 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800d67:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6a:	8b 00                	mov    (%eax),%eax
  800d6c:	8d 50 04             	lea    0x4(%eax),%edx
  800d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d72:	89 10                	mov    %edx,(%eax)
  800d74:	8b 45 08             	mov    0x8(%ebp),%eax
  800d77:	8b 00                	mov    (%eax),%eax
  800d79:	83 e8 04             	sub    $0x4,%eax
  800d7c:	8b 00                	mov    (%eax),%eax
  800d7e:	ba 00 00 00 00       	mov    $0x0,%edx
  800d83:	eb 1c                	jmp    800da1 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800d85:	8b 45 08             	mov    0x8(%ebp),%eax
  800d88:	8b 00                	mov    (%eax),%eax
  800d8a:	8d 50 04             	lea    0x4(%eax),%edx
  800d8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d90:	89 10                	mov    %edx,(%eax)
  800d92:	8b 45 08             	mov    0x8(%ebp),%eax
  800d95:	8b 00                	mov    (%eax),%eax
  800d97:	83 e8 04             	sub    $0x4,%eax
  800d9a:	8b 00                	mov    (%eax),%eax
  800d9c:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800da1:	5d                   	pop    %ebp
  800da2:	c3                   	ret    

00800da3 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800da3:	55                   	push   %ebp
  800da4:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800da6:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800daa:	7e 1c                	jle    800dc8 <getint+0x25>
		return va_arg(*ap, long long);
  800dac:	8b 45 08             	mov    0x8(%ebp),%eax
  800daf:	8b 00                	mov    (%eax),%eax
  800db1:	8d 50 08             	lea    0x8(%eax),%edx
  800db4:	8b 45 08             	mov    0x8(%ebp),%eax
  800db7:	89 10                	mov    %edx,(%eax)
  800db9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbc:	8b 00                	mov    (%eax),%eax
  800dbe:	83 e8 08             	sub    $0x8,%eax
  800dc1:	8b 50 04             	mov    0x4(%eax),%edx
  800dc4:	8b 00                	mov    (%eax),%eax
  800dc6:	eb 38                	jmp    800e00 <getint+0x5d>
	else if (lflag)
  800dc8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dcc:	74 1a                	je     800de8 <getint+0x45>
		return va_arg(*ap, long);
  800dce:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd1:	8b 00                	mov    (%eax),%eax
  800dd3:	8d 50 04             	lea    0x4(%eax),%edx
  800dd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd9:	89 10                	mov    %edx,(%eax)
  800ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dde:	8b 00                	mov    (%eax),%eax
  800de0:	83 e8 04             	sub    $0x4,%eax
  800de3:	8b 00                	mov    (%eax),%eax
  800de5:	99                   	cltd   
  800de6:	eb 18                	jmp    800e00 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800de8:	8b 45 08             	mov    0x8(%ebp),%eax
  800deb:	8b 00                	mov    (%eax),%eax
  800ded:	8d 50 04             	lea    0x4(%eax),%edx
  800df0:	8b 45 08             	mov    0x8(%ebp),%eax
  800df3:	89 10                	mov    %edx,(%eax)
  800df5:	8b 45 08             	mov    0x8(%ebp),%eax
  800df8:	8b 00                	mov    (%eax),%eax
  800dfa:	83 e8 04             	sub    $0x4,%eax
  800dfd:	8b 00                	mov    (%eax),%eax
  800dff:	99                   	cltd   
}
  800e00:	5d                   	pop    %ebp
  800e01:	c3                   	ret    

00800e02 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800e02:	55                   	push   %ebp
  800e03:	89 e5                	mov    %esp,%ebp
  800e05:	56                   	push   %esi
  800e06:	53                   	push   %ebx
  800e07:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e0a:	eb 17                	jmp    800e23 <vprintfmt+0x21>
			if (ch == '\0')
  800e0c:	85 db                	test   %ebx,%ebx
  800e0e:	0f 84 c1 03 00 00    	je     8011d5 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800e14:	83 ec 08             	sub    $0x8,%esp
  800e17:	ff 75 0c             	pushl  0xc(%ebp)
  800e1a:	53                   	push   %ebx
  800e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1e:	ff d0                	call   *%eax
  800e20:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e23:	8b 45 10             	mov    0x10(%ebp),%eax
  800e26:	8d 50 01             	lea    0x1(%eax),%edx
  800e29:	89 55 10             	mov    %edx,0x10(%ebp)
  800e2c:	8a 00                	mov    (%eax),%al
  800e2e:	0f b6 d8             	movzbl %al,%ebx
  800e31:	83 fb 25             	cmp    $0x25,%ebx
  800e34:	75 d6                	jne    800e0c <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800e36:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800e3a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800e41:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800e48:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800e4f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800e56:	8b 45 10             	mov    0x10(%ebp),%eax
  800e59:	8d 50 01             	lea    0x1(%eax),%edx
  800e5c:	89 55 10             	mov    %edx,0x10(%ebp)
  800e5f:	8a 00                	mov    (%eax),%al
  800e61:	0f b6 d8             	movzbl %al,%ebx
  800e64:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800e67:	83 f8 5b             	cmp    $0x5b,%eax
  800e6a:	0f 87 3d 03 00 00    	ja     8011ad <vprintfmt+0x3ab>
  800e70:	8b 04 85 98 2c 80 00 	mov    0x802c98(,%eax,4),%eax
  800e77:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800e79:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800e7d:	eb d7                	jmp    800e56 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800e7f:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800e83:	eb d1                	jmp    800e56 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e85:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800e8c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800e8f:	89 d0                	mov    %edx,%eax
  800e91:	c1 e0 02             	shl    $0x2,%eax
  800e94:	01 d0                	add    %edx,%eax
  800e96:	01 c0                	add    %eax,%eax
  800e98:	01 d8                	add    %ebx,%eax
  800e9a:	83 e8 30             	sub    $0x30,%eax
  800e9d:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800ea0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea3:	8a 00                	mov    (%eax),%al
  800ea5:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800ea8:	83 fb 2f             	cmp    $0x2f,%ebx
  800eab:	7e 3e                	jle    800eeb <vprintfmt+0xe9>
  800ead:	83 fb 39             	cmp    $0x39,%ebx
  800eb0:	7f 39                	jg     800eeb <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800eb2:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800eb5:	eb d5                	jmp    800e8c <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800eb7:	8b 45 14             	mov    0x14(%ebp),%eax
  800eba:	83 c0 04             	add    $0x4,%eax
  800ebd:	89 45 14             	mov    %eax,0x14(%ebp)
  800ec0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ec3:	83 e8 04             	sub    $0x4,%eax
  800ec6:	8b 00                	mov    (%eax),%eax
  800ec8:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800ecb:	eb 1f                	jmp    800eec <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800ecd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ed1:	79 83                	jns    800e56 <vprintfmt+0x54>
				width = 0;
  800ed3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800eda:	e9 77 ff ff ff       	jmp    800e56 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800edf:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800ee6:	e9 6b ff ff ff       	jmp    800e56 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800eeb:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800eec:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ef0:	0f 89 60 ff ff ff    	jns    800e56 <vprintfmt+0x54>
				width = precision, precision = -1;
  800ef6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ef9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800efc:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800f03:	e9 4e ff ff ff       	jmp    800e56 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800f08:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800f0b:	e9 46 ff ff ff       	jmp    800e56 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800f10:	8b 45 14             	mov    0x14(%ebp),%eax
  800f13:	83 c0 04             	add    $0x4,%eax
  800f16:	89 45 14             	mov    %eax,0x14(%ebp)
  800f19:	8b 45 14             	mov    0x14(%ebp),%eax
  800f1c:	83 e8 04             	sub    $0x4,%eax
  800f1f:	8b 00                	mov    (%eax),%eax
  800f21:	83 ec 08             	sub    $0x8,%esp
  800f24:	ff 75 0c             	pushl  0xc(%ebp)
  800f27:	50                   	push   %eax
  800f28:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2b:	ff d0                	call   *%eax
  800f2d:	83 c4 10             	add    $0x10,%esp
			break;
  800f30:	e9 9b 02 00 00       	jmp    8011d0 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800f35:	8b 45 14             	mov    0x14(%ebp),%eax
  800f38:	83 c0 04             	add    $0x4,%eax
  800f3b:	89 45 14             	mov    %eax,0x14(%ebp)
  800f3e:	8b 45 14             	mov    0x14(%ebp),%eax
  800f41:	83 e8 04             	sub    $0x4,%eax
  800f44:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800f46:	85 db                	test   %ebx,%ebx
  800f48:	79 02                	jns    800f4c <vprintfmt+0x14a>
				err = -err;
  800f4a:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800f4c:	83 fb 64             	cmp    $0x64,%ebx
  800f4f:	7f 0b                	jg     800f5c <vprintfmt+0x15a>
  800f51:	8b 34 9d e0 2a 80 00 	mov    0x802ae0(,%ebx,4),%esi
  800f58:	85 f6                	test   %esi,%esi
  800f5a:	75 19                	jne    800f75 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800f5c:	53                   	push   %ebx
  800f5d:	68 85 2c 80 00       	push   $0x802c85
  800f62:	ff 75 0c             	pushl  0xc(%ebp)
  800f65:	ff 75 08             	pushl  0x8(%ebp)
  800f68:	e8 70 02 00 00       	call   8011dd <printfmt>
  800f6d:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800f70:	e9 5b 02 00 00       	jmp    8011d0 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800f75:	56                   	push   %esi
  800f76:	68 8e 2c 80 00       	push   $0x802c8e
  800f7b:	ff 75 0c             	pushl  0xc(%ebp)
  800f7e:	ff 75 08             	pushl  0x8(%ebp)
  800f81:	e8 57 02 00 00       	call   8011dd <printfmt>
  800f86:	83 c4 10             	add    $0x10,%esp
			break;
  800f89:	e9 42 02 00 00       	jmp    8011d0 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800f8e:	8b 45 14             	mov    0x14(%ebp),%eax
  800f91:	83 c0 04             	add    $0x4,%eax
  800f94:	89 45 14             	mov    %eax,0x14(%ebp)
  800f97:	8b 45 14             	mov    0x14(%ebp),%eax
  800f9a:	83 e8 04             	sub    $0x4,%eax
  800f9d:	8b 30                	mov    (%eax),%esi
  800f9f:	85 f6                	test   %esi,%esi
  800fa1:	75 05                	jne    800fa8 <vprintfmt+0x1a6>
				p = "(null)";
  800fa3:	be 91 2c 80 00       	mov    $0x802c91,%esi
			if (width > 0 && padc != '-')
  800fa8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fac:	7e 6d                	jle    80101b <vprintfmt+0x219>
  800fae:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800fb2:	74 67                	je     80101b <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800fb4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fb7:	83 ec 08             	sub    $0x8,%esp
  800fba:	50                   	push   %eax
  800fbb:	56                   	push   %esi
  800fbc:	e8 1e 03 00 00       	call   8012df <strnlen>
  800fc1:	83 c4 10             	add    $0x10,%esp
  800fc4:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800fc7:	eb 16                	jmp    800fdf <vprintfmt+0x1dd>
					putch(padc, putdat);
  800fc9:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800fcd:	83 ec 08             	sub    $0x8,%esp
  800fd0:	ff 75 0c             	pushl  0xc(%ebp)
  800fd3:	50                   	push   %eax
  800fd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd7:	ff d0                	call   *%eax
  800fd9:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800fdc:	ff 4d e4             	decl   -0x1c(%ebp)
  800fdf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fe3:	7f e4                	jg     800fc9 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800fe5:	eb 34                	jmp    80101b <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800fe7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800feb:	74 1c                	je     801009 <vprintfmt+0x207>
  800fed:	83 fb 1f             	cmp    $0x1f,%ebx
  800ff0:	7e 05                	jle    800ff7 <vprintfmt+0x1f5>
  800ff2:	83 fb 7e             	cmp    $0x7e,%ebx
  800ff5:	7e 12                	jle    801009 <vprintfmt+0x207>
					putch('?', putdat);
  800ff7:	83 ec 08             	sub    $0x8,%esp
  800ffa:	ff 75 0c             	pushl  0xc(%ebp)
  800ffd:	6a 3f                	push   $0x3f
  800fff:	8b 45 08             	mov    0x8(%ebp),%eax
  801002:	ff d0                	call   *%eax
  801004:	83 c4 10             	add    $0x10,%esp
  801007:	eb 0f                	jmp    801018 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801009:	83 ec 08             	sub    $0x8,%esp
  80100c:	ff 75 0c             	pushl  0xc(%ebp)
  80100f:	53                   	push   %ebx
  801010:	8b 45 08             	mov    0x8(%ebp),%eax
  801013:	ff d0                	call   *%eax
  801015:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801018:	ff 4d e4             	decl   -0x1c(%ebp)
  80101b:	89 f0                	mov    %esi,%eax
  80101d:	8d 70 01             	lea    0x1(%eax),%esi
  801020:	8a 00                	mov    (%eax),%al
  801022:	0f be d8             	movsbl %al,%ebx
  801025:	85 db                	test   %ebx,%ebx
  801027:	74 24                	je     80104d <vprintfmt+0x24b>
  801029:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80102d:	78 b8                	js     800fe7 <vprintfmt+0x1e5>
  80102f:	ff 4d e0             	decl   -0x20(%ebp)
  801032:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801036:	79 af                	jns    800fe7 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801038:	eb 13                	jmp    80104d <vprintfmt+0x24b>
				putch(' ', putdat);
  80103a:	83 ec 08             	sub    $0x8,%esp
  80103d:	ff 75 0c             	pushl  0xc(%ebp)
  801040:	6a 20                	push   $0x20
  801042:	8b 45 08             	mov    0x8(%ebp),%eax
  801045:	ff d0                	call   *%eax
  801047:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80104a:	ff 4d e4             	decl   -0x1c(%ebp)
  80104d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801051:	7f e7                	jg     80103a <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801053:	e9 78 01 00 00       	jmp    8011d0 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801058:	83 ec 08             	sub    $0x8,%esp
  80105b:	ff 75 e8             	pushl  -0x18(%ebp)
  80105e:	8d 45 14             	lea    0x14(%ebp),%eax
  801061:	50                   	push   %eax
  801062:	e8 3c fd ff ff       	call   800da3 <getint>
  801067:	83 c4 10             	add    $0x10,%esp
  80106a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80106d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801070:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801073:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801076:	85 d2                	test   %edx,%edx
  801078:	79 23                	jns    80109d <vprintfmt+0x29b>
				putch('-', putdat);
  80107a:	83 ec 08             	sub    $0x8,%esp
  80107d:	ff 75 0c             	pushl  0xc(%ebp)
  801080:	6a 2d                	push   $0x2d
  801082:	8b 45 08             	mov    0x8(%ebp),%eax
  801085:	ff d0                	call   *%eax
  801087:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80108a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80108d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801090:	f7 d8                	neg    %eax
  801092:	83 d2 00             	adc    $0x0,%edx
  801095:	f7 da                	neg    %edx
  801097:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80109a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80109d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8010a4:	e9 bc 00 00 00       	jmp    801165 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8010a9:	83 ec 08             	sub    $0x8,%esp
  8010ac:	ff 75 e8             	pushl  -0x18(%ebp)
  8010af:	8d 45 14             	lea    0x14(%ebp),%eax
  8010b2:	50                   	push   %eax
  8010b3:	e8 84 fc ff ff       	call   800d3c <getuint>
  8010b8:	83 c4 10             	add    $0x10,%esp
  8010bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010be:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8010c1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8010c8:	e9 98 00 00 00       	jmp    801165 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8010cd:	83 ec 08             	sub    $0x8,%esp
  8010d0:	ff 75 0c             	pushl  0xc(%ebp)
  8010d3:	6a 58                	push   $0x58
  8010d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d8:	ff d0                	call   *%eax
  8010da:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8010dd:	83 ec 08             	sub    $0x8,%esp
  8010e0:	ff 75 0c             	pushl  0xc(%ebp)
  8010e3:	6a 58                	push   $0x58
  8010e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e8:	ff d0                	call   *%eax
  8010ea:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8010ed:	83 ec 08             	sub    $0x8,%esp
  8010f0:	ff 75 0c             	pushl  0xc(%ebp)
  8010f3:	6a 58                	push   $0x58
  8010f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f8:	ff d0                	call   *%eax
  8010fa:	83 c4 10             	add    $0x10,%esp
			break;
  8010fd:	e9 ce 00 00 00       	jmp    8011d0 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  801102:	83 ec 08             	sub    $0x8,%esp
  801105:	ff 75 0c             	pushl  0xc(%ebp)
  801108:	6a 30                	push   $0x30
  80110a:	8b 45 08             	mov    0x8(%ebp),%eax
  80110d:	ff d0                	call   *%eax
  80110f:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801112:	83 ec 08             	sub    $0x8,%esp
  801115:	ff 75 0c             	pushl  0xc(%ebp)
  801118:	6a 78                	push   $0x78
  80111a:	8b 45 08             	mov    0x8(%ebp),%eax
  80111d:	ff d0                	call   *%eax
  80111f:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801122:	8b 45 14             	mov    0x14(%ebp),%eax
  801125:	83 c0 04             	add    $0x4,%eax
  801128:	89 45 14             	mov    %eax,0x14(%ebp)
  80112b:	8b 45 14             	mov    0x14(%ebp),%eax
  80112e:	83 e8 04             	sub    $0x4,%eax
  801131:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801133:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801136:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80113d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801144:	eb 1f                	jmp    801165 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801146:	83 ec 08             	sub    $0x8,%esp
  801149:	ff 75 e8             	pushl  -0x18(%ebp)
  80114c:	8d 45 14             	lea    0x14(%ebp),%eax
  80114f:	50                   	push   %eax
  801150:	e8 e7 fb ff ff       	call   800d3c <getuint>
  801155:	83 c4 10             	add    $0x10,%esp
  801158:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80115b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80115e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801165:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801169:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80116c:	83 ec 04             	sub    $0x4,%esp
  80116f:	52                   	push   %edx
  801170:	ff 75 e4             	pushl  -0x1c(%ebp)
  801173:	50                   	push   %eax
  801174:	ff 75 f4             	pushl  -0xc(%ebp)
  801177:	ff 75 f0             	pushl  -0x10(%ebp)
  80117a:	ff 75 0c             	pushl  0xc(%ebp)
  80117d:	ff 75 08             	pushl  0x8(%ebp)
  801180:	e8 00 fb ff ff       	call   800c85 <printnum>
  801185:	83 c4 20             	add    $0x20,%esp
			break;
  801188:	eb 46                	jmp    8011d0 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80118a:	83 ec 08             	sub    $0x8,%esp
  80118d:	ff 75 0c             	pushl  0xc(%ebp)
  801190:	53                   	push   %ebx
  801191:	8b 45 08             	mov    0x8(%ebp),%eax
  801194:	ff d0                	call   *%eax
  801196:	83 c4 10             	add    $0x10,%esp
			break;
  801199:	eb 35                	jmp    8011d0 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  80119b:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
			break;
  8011a2:	eb 2c                	jmp    8011d0 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8011a4:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
			break;
  8011ab:	eb 23                	jmp    8011d0 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8011ad:	83 ec 08             	sub    $0x8,%esp
  8011b0:	ff 75 0c             	pushl  0xc(%ebp)
  8011b3:	6a 25                	push   $0x25
  8011b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b8:	ff d0                	call   *%eax
  8011ba:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8011bd:	ff 4d 10             	decl   0x10(%ebp)
  8011c0:	eb 03                	jmp    8011c5 <vprintfmt+0x3c3>
  8011c2:	ff 4d 10             	decl   0x10(%ebp)
  8011c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c8:	48                   	dec    %eax
  8011c9:	8a 00                	mov    (%eax),%al
  8011cb:	3c 25                	cmp    $0x25,%al
  8011cd:	75 f3                	jne    8011c2 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8011cf:	90                   	nop
		}
	}
  8011d0:	e9 35 fc ff ff       	jmp    800e0a <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8011d5:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8011d6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8011d9:	5b                   	pop    %ebx
  8011da:	5e                   	pop    %esi
  8011db:	5d                   	pop    %ebp
  8011dc:	c3                   	ret    

008011dd <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8011dd:	55                   	push   %ebp
  8011de:	89 e5                	mov    %esp,%ebp
  8011e0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8011e3:	8d 45 10             	lea    0x10(%ebp),%eax
  8011e6:	83 c0 04             	add    $0x4,%eax
  8011e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8011ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ef:	ff 75 f4             	pushl  -0xc(%ebp)
  8011f2:	50                   	push   %eax
  8011f3:	ff 75 0c             	pushl  0xc(%ebp)
  8011f6:	ff 75 08             	pushl  0x8(%ebp)
  8011f9:	e8 04 fc ff ff       	call   800e02 <vprintfmt>
  8011fe:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801201:	90                   	nop
  801202:	c9                   	leave  
  801203:	c3                   	ret    

00801204 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801204:	55                   	push   %ebp
  801205:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801207:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120a:	8b 40 08             	mov    0x8(%eax),%eax
  80120d:	8d 50 01             	lea    0x1(%eax),%edx
  801210:	8b 45 0c             	mov    0xc(%ebp),%eax
  801213:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801216:	8b 45 0c             	mov    0xc(%ebp),%eax
  801219:	8b 10                	mov    (%eax),%edx
  80121b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121e:	8b 40 04             	mov    0x4(%eax),%eax
  801221:	39 c2                	cmp    %eax,%edx
  801223:	73 12                	jae    801237 <sprintputch+0x33>
		*b->buf++ = ch;
  801225:	8b 45 0c             	mov    0xc(%ebp),%eax
  801228:	8b 00                	mov    (%eax),%eax
  80122a:	8d 48 01             	lea    0x1(%eax),%ecx
  80122d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801230:	89 0a                	mov    %ecx,(%edx)
  801232:	8b 55 08             	mov    0x8(%ebp),%edx
  801235:	88 10                	mov    %dl,(%eax)
}
  801237:	90                   	nop
  801238:	5d                   	pop    %ebp
  801239:	c3                   	ret    

0080123a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80123a:	55                   	push   %ebp
  80123b:	89 e5                	mov    %esp,%ebp
  80123d:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801240:	8b 45 08             	mov    0x8(%ebp),%eax
  801243:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801246:	8b 45 0c             	mov    0xc(%ebp),%eax
  801249:	8d 50 ff             	lea    -0x1(%eax),%edx
  80124c:	8b 45 08             	mov    0x8(%ebp),%eax
  80124f:	01 d0                	add    %edx,%eax
  801251:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801254:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80125b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80125f:	74 06                	je     801267 <vsnprintf+0x2d>
  801261:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801265:	7f 07                	jg     80126e <vsnprintf+0x34>
		return -E_INVAL;
  801267:	b8 03 00 00 00       	mov    $0x3,%eax
  80126c:	eb 20                	jmp    80128e <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80126e:	ff 75 14             	pushl  0x14(%ebp)
  801271:	ff 75 10             	pushl  0x10(%ebp)
  801274:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801277:	50                   	push   %eax
  801278:	68 04 12 80 00       	push   $0x801204
  80127d:	e8 80 fb ff ff       	call   800e02 <vprintfmt>
  801282:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801285:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801288:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80128b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80128e:	c9                   	leave  
  80128f:	c3                   	ret    

00801290 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801290:	55                   	push   %ebp
  801291:	89 e5                	mov    %esp,%ebp
  801293:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801296:	8d 45 10             	lea    0x10(%ebp),%eax
  801299:	83 c0 04             	add    $0x4,%eax
  80129c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80129f:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a2:	ff 75 f4             	pushl  -0xc(%ebp)
  8012a5:	50                   	push   %eax
  8012a6:	ff 75 0c             	pushl  0xc(%ebp)
  8012a9:	ff 75 08             	pushl  0x8(%ebp)
  8012ac:	e8 89 ff ff ff       	call   80123a <vsnprintf>
  8012b1:	83 c4 10             	add    $0x10,%esp
  8012b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8012b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012ba:	c9                   	leave  
  8012bb:	c3                   	ret    

008012bc <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8012bc:	55                   	push   %ebp
  8012bd:	89 e5                	mov    %esp,%ebp
  8012bf:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8012c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012c9:	eb 06                	jmp    8012d1 <strlen+0x15>
		n++;
  8012cb:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8012ce:	ff 45 08             	incl   0x8(%ebp)
  8012d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d4:	8a 00                	mov    (%eax),%al
  8012d6:	84 c0                	test   %al,%al
  8012d8:	75 f1                	jne    8012cb <strlen+0xf>
		n++;
	return n;
  8012da:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012dd:	c9                   	leave  
  8012de:	c3                   	ret    

008012df <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8012df:	55                   	push   %ebp
  8012e0:	89 e5                	mov    %esp,%ebp
  8012e2:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012e5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012ec:	eb 09                	jmp    8012f7 <strnlen+0x18>
		n++;
  8012ee:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012f1:	ff 45 08             	incl   0x8(%ebp)
  8012f4:	ff 4d 0c             	decl   0xc(%ebp)
  8012f7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012fb:	74 09                	je     801306 <strnlen+0x27>
  8012fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801300:	8a 00                	mov    (%eax),%al
  801302:	84 c0                	test   %al,%al
  801304:	75 e8                	jne    8012ee <strnlen+0xf>
		n++;
	return n;
  801306:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801309:	c9                   	leave  
  80130a:	c3                   	ret    

0080130b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80130b:	55                   	push   %ebp
  80130c:	89 e5                	mov    %esp,%ebp
  80130e:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801311:	8b 45 08             	mov    0x8(%ebp),%eax
  801314:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801317:	90                   	nop
  801318:	8b 45 08             	mov    0x8(%ebp),%eax
  80131b:	8d 50 01             	lea    0x1(%eax),%edx
  80131e:	89 55 08             	mov    %edx,0x8(%ebp)
  801321:	8b 55 0c             	mov    0xc(%ebp),%edx
  801324:	8d 4a 01             	lea    0x1(%edx),%ecx
  801327:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80132a:	8a 12                	mov    (%edx),%dl
  80132c:	88 10                	mov    %dl,(%eax)
  80132e:	8a 00                	mov    (%eax),%al
  801330:	84 c0                	test   %al,%al
  801332:	75 e4                	jne    801318 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801334:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801337:	c9                   	leave  
  801338:	c3                   	ret    

00801339 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801339:	55                   	push   %ebp
  80133a:	89 e5                	mov    %esp,%ebp
  80133c:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80133f:	8b 45 08             	mov    0x8(%ebp),%eax
  801342:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801345:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80134c:	eb 1f                	jmp    80136d <strncpy+0x34>
		*dst++ = *src;
  80134e:	8b 45 08             	mov    0x8(%ebp),%eax
  801351:	8d 50 01             	lea    0x1(%eax),%edx
  801354:	89 55 08             	mov    %edx,0x8(%ebp)
  801357:	8b 55 0c             	mov    0xc(%ebp),%edx
  80135a:	8a 12                	mov    (%edx),%dl
  80135c:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80135e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801361:	8a 00                	mov    (%eax),%al
  801363:	84 c0                	test   %al,%al
  801365:	74 03                	je     80136a <strncpy+0x31>
			src++;
  801367:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80136a:	ff 45 fc             	incl   -0x4(%ebp)
  80136d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801370:	3b 45 10             	cmp    0x10(%ebp),%eax
  801373:	72 d9                	jb     80134e <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801375:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801378:	c9                   	leave  
  801379:	c3                   	ret    

0080137a <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80137a:	55                   	push   %ebp
  80137b:	89 e5                	mov    %esp,%ebp
  80137d:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801380:	8b 45 08             	mov    0x8(%ebp),%eax
  801383:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801386:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80138a:	74 30                	je     8013bc <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80138c:	eb 16                	jmp    8013a4 <strlcpy+0x2a>
			*dst++ = *src++;
  80138e:	8b 45 08             	mov    0x8(%ebp),%eax
  801391:	8d 50 01             	lea    0x1(%eax),%edx
  801394:	89 55 08             	mov    %edx,0x8(%ebp)
  801397:	8b 55 0c             	mov    0xc(%ebp),%edx
  80139a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80139d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8013a0:	8a 12                	mov    (%edx),%dl
  8013a2:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8013a4:	ff 4d 10             	decl   0x10(%ebp)
  8013a7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013ab:	74 09                	je     8013b6 <strlcpy+0x3c>
  8013ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b0:	8a 00                	mov    (%eax),%al
  8013b2:	84 c0                	test   %al,%al
  8013b4:	75 d8                	jne    80138e <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8013b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b9:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8013bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8013bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013c2:	29 c2                	sub    %eax,%edx
  8013c4:	89 d0                	mov    %edx,%eax
}
  8013c6:	c9                   	leave  
  8013c7:	c3                   	ret    

008013c8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8013c8:	55                   	push   %ebp
  8013c9:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8013cb:	eb 06                	jmp    8013d3 <strcmp+0xb>
		p++, q++;
  8013cd:	ff 45 08             	incl   0x8(%ebp)
  8013d0:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8013d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d6:	8a 00                	mov    (%eax),%al
  8013d8:	84 c0                	test   %al,%al
  8013da:	74 0e                	je     8013ea <strcmp+0x22>
  8013dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013df:	8a 10                	mov    (%eax),%dl
  8013e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e4:	8a 00                	mov    (%eax),%al
  8013e6:	38 c2                	cmp    %al,%dl
  8013e8:	74 e3                	je     8013cd <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8013ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ed:	8a 00                	mov    (%eax),%al
  8013ef:	0f b6 d0             	movzbl %al,%edx
  8013f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f5:	8a 00                	mov    (%eax),%al
  8013f7:	0f b6 c0             	movzbl %al,%eax
  8013fa:	29 c2                	sub    %eax,%edx
  8013fc:	89 d0                	mov    %edx,%eax
}
  8013fe:	5d                   	pop    %ebp
  8013ff:	c3                   	ret    

00801400 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801400:	55                   	push   %ebp
  801401:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801403:	eb 09                	jmp    80140e <strncmp+0xe>
		n--, p++, q++;
  801405:	ff 4d 10             	decl   0x10(%ebp)
  801408:	ff 45 08             	incl   0x8(%ebp)
  80140b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80140e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801412:	74 17                	je     80142b <strncmp+0x2b>
  801414:	8b 45 08             	mov    0x8(%ebp),%eax
  801417:	8a 00                	mov    (%eax),%al
  801419:	84 c0                	test   %al,%al
  80141b:	74 0e                	je     80142b <strncmp+0x2b>
  80141d:	8b 45 08             	mov    0x8(%ebp),%eax
  801420:	8a 10                	mov    (%eax),%dl
  801422:	8b 45 0c             	mov    0xc(%ebp),%eax
  801425:	8a 00                	mov    (%eax),%al
  801427:	38 c2                	cmp    %al,%dl
  801429:	74 da                	je     801405 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80142b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80142f:	75 07                	jne    801438 <strncmp+0x38>
		return 0;
  801431:	b8 00 00 00 00       	mov    $0x0,%eax
  801436:	eb 14                	jmp    80144c <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801438:	8b 45 08             	mov    0x8(%ebp),%eax
  80143b:	8a 00                	mov    (%eax),%al
  80143d:	0f b6 d0             	movzbl %al,%edx
  801440:	8b 45 0c             	mov    0xc(%ebp),%eax
  801443:	8a 00                	mov    (%eax),%al
  801445:	0f b6 c0             	movzbl %al,%eax
  801448:	29 c2                	sub    %eax,%edx
  80144a:	89 d0                	mov    %edx,%eax
}
  80144c:	5d                   	pop    %ebp
  80144d:	c3                   	ret    

0080144e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80144e:	55                   	push   %ebp
  80144f:	89 e5                	mov    %esp,%ebp
  801451:	83 ec 04             	sub    $0x4,%esp
  801454:	8b 45 0c             	mov    0xc(%ebp),%eax
  801457:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80145a:	eb 12                	jmp    80146e <strchr+0x20>
		if (*s == c)
  80145c:	8b 45 08             	mov    0x8(%ebp),%eax
  80145f:	8a 00                	mov    (%eax),%al
  801461:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801464:	75 05                	jne    80146b <strchr+0x1d>
			return (char *) s;
  801466:	8b 45 08             	mov    0x8(%ebp),%eax
  801469:	eb 11                	jmp    80147c <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80146b:	ff 45 08             	incl   0x8(%ebp)
  80146e:	8b 45 08             	mov    0x8(%ebp),%eax
  801471:	8a 00                	mov    (%eax),%al
  801473:	84 c0                	test   %al,%al
  801475:	75 e5                	jne    80145c <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801477:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80147c:	c9                   	leave  
  80147d:	c3                   	ret    

0080147e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80147e:	55                   	push   %ebp
  80147f:	89 e5                	mov    %esp,%ebp
  801481:	83 ec 04             	sub    $0x4,%esp
  801484:	8b 45 0c             	mov    0xc(%ebp),%eax
  801487:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80148a:	eb 0d                	jmp    801499 <strfind+0x1b>
		if (*s == c)
  80148c:	8b 45 08             	mov    0x8(%ebp),%eax
  80148f:	8a 00                	mov    (%eax),%al
  801491:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801494:	74 0e                	je     8014a4 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801496:	ff 45 08             	incl   0x8(%ebp)
  801499:	8b 45 08             	mov    0x8(%ebp),%eax
  80149c:	8a 00                	mov    (%eax),%al
  80149e:	84 c0                	test   %al,%al
  8014a0:	75 ea                	jne    80148c <strfind+0xe>
  8014a2:	eb 01                	jmp    8014a5 <strfind+0x27>
		if (*s == c)
			break;
  8014a4:	90                   	nop
	return (char *) s;
  8014a5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014a8:	c9                   	leave  
  8014a9:	c3                   	ret    

008014aa <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  8014aa:	55                   	push   %ebp
  8014ab:	89 e5                	mov    %esp,%ebp
  8014ad:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  8014b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  8014b6:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8014ba:	76 63                	jbe    80151f <memset+0x75>
		uint64 data_block = c;
  8014bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014bf:	99                   	cltd   
  8014c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014c3:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  8014c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014cc:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  8014d0:	c1 e0 08             	shl    $0x8,%eax
  8014d3:	09 45 f0             	or     %eax,-0x10(%ebp)
  8014d6:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  8014d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014df:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  8014e3:	c1 e0 10             	shl    $0x10,%eax
  8014e6:	09 45 f0             	or     %eax,-0x10(%ebp)
  8014e9:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  8014ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014f2:	89 c2                	mov    %eax,%edx
  8014f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8014f9:	09 45 f0             	or     %eax,-0x10(%ebp)
  8014fc:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  8014ff:	eb 18                	jmp    801519 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801501:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801504:	8d 41 08             	lea    0x8(%ecx),%eax
  801507:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80150a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80150d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801510:	89 01                	mov    %eax,(%ecx)
  801512:	89 51 04             	mov    %edx,0x4(%ecx)
  801515:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801519:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80151d:	77 e2                	ja     801501 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  80151f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801523:	74 23                	je     801548 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801525:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801528:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  80152b:	eb 0e                	jmp    80153b <memset+0x91>
			*p8++ = (uint8)c;
  80152d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801530:	8d 50 01             	lea    0x1(%eax),%edx
  801533:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801536:	8b 55 0c             	mov    0xc(%ebp),%edx
  801539:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  80153b:	8b 45 10             	mov    0x10(%ebp),%eax
  80153e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801541:	89 55 10             	mov    %edx,0x10(%ebp)
  801544:	85 c0                	test   %eax,%eax
  801546:	75 e5                	jne    80152d <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801548:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80154b:	c9                   	leave  
  80154c:	c3                   	ret    

0080154d <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80154d:	55                   	push   %ebp
  80154e:	89 e5                	mov    %esp,%ebp
  801550:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801553:	8b 45 0c             	mov    0xc(%ebp),%eax
  801556:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801559:	8b 45 08             	mov    0x8(%ebp),%eax
  80155c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  80155f:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801563:	76 24                	jbe    801589 <memcpy+0x3c>
		while(n >= 8){
  801565:	eb 1c                	jmp    801583 <memcpy+0x36>
			*d64 = *s64;
  801567:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80156a:	8b 50 04             	mov    0x4(%eax),%edx
  80156d:	8b 00                	mov    (%eax),%eax
  80156f:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801572:	89 01                	mov    %eax,(%ecx)
  801574:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801577:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  80157b:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  80157f:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801583:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801587:	77 de                	ja     801567 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801589:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80158d:	74 31                	je     8015c0 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  80158f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801592:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801595:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801598:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  80159b:	eb 16                	jmp    8015b3 <memcpy+0x66>
			*d8++ = *s8++;
  80159d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015a0:	8d 50 01             	lea    0x1(%eax),%edx
  8015a3:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8015a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015a9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8015ac:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8015af:	8a 12                	mov    (%edx),%dl
  8015b1:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  8015b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8015b6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015b9:	89 55 10             	mov    %edx,0x10(%ebp)
  8015bc:	85 c0                	test   %eax,%eax
  8015be:	75 dd                	jne    80159d <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  8015c0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015c3:	c9                   	leave  
  8015c4:	c3                   	ret    

008015c5 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8015c5:	55                   	push   %ebp
  8015c6:	89 e5                	mov    %esp,%ebp
  8015c8:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8015cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ce:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8015d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8015d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015da:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8015dd:	73 50                	jae    80162f <memmove+0x6a>
  8015df:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8015e5:	01 d0                	add    %edx,%eax
  8015e7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8015ea:	76 43                	jbe    80162f <memmove+0x6a>
		s += n;
  8015ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8015ef:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8015f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8015f5:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8015f8:	eb 10                	jmp    80160a <memmove+0x45>
			*--d = *--s;
  8015fa:	ff 4d f8             	decl   -0x8(%ebp)
  8015fd:	ff 4d fc             	decl   -0x4(%ebp)
  801600:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801603:	8a 10                	mov    (%eax),%dl
  801605:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801608:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80160a:	8b 45 10             	mov    0x10(%ebp),%eax
  80160d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801610:	89 55 10             	mov    %edx,0x10(%ebp)
  801613:	85 c0                	test   %eax,%eax
  801615:	75 e3                	jne    8015fa <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801617:	eb 23                	jmp    80163c <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801619:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80161c:	8d 50 01             	lea    0x1(%eax),%edx
  80161f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801622:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801625:	8d 4a 01             	lea    0x1(%edx),%ecx
  801628:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80162b:	8a 12                	mov    (%edx),%dl
  80162d:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80162f:	8b 45 10             	mov    0x10(%ebp),%eax
  801632:	8d 50 ff             	lea    -0x1(%eax),%edx
  801635:	89 55 10             	mov    %edx,0x10(%ebp)
  801638:	85 c0                	test   %eax,%eax
  80163a:	75 dd                	jne    801619 <memmove+0x54>
			*d++ = *s++;

	return dst;
  80163c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80163f:	c9                   	leave  
  801640:	c3                   	ret    

00801641 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801641:	55                   	push   %ebp
  801642:	89 e5                	mov    %esp,%ebp
  801644:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801647:	8b 45 08             	mov    0x8(%ebp),%eax
  80164a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80164d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801650:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801653:	eb 2a                	jmp    80167f <memcmp+0x3e>
		if (*s1 != *s2)
  801655:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801658:	8a 10                	mov    (%eax),%dl
  80165a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80165d:	8a 00                	mov    (%eax),%al
  80165f:	38 c2                	cmp    %al,%dl
  801661:	74 16                	je     801679 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801663:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801666:	8a 00                	mov    (%eax),%al
  801668:	0f b6 d0             	movzbl %al,%edx
  80166b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80166e:	8a 00                	mov    (%eax),%al
  801670:	0f b6 c0             	movzbl %al,%eax
  801673:	29 c2                	sub    %eax,%edx
  801675:	89 d0                	mov    %edx,%eax
  801677:	eb 18                	jmp    801691 <memcmp+0x50>
		s1++, s2++;
  801679:	ff 45 fc             	incl   -0x4(%ebp)
  80167c:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80167f:	8b 45 10             	mov    0x10(%ebp),%eax
  801682:	8d 50 ff             	lea    -0x1(%eax),%edx
  801685:	89 55 10             	mov    %edx,0x10(%ebp)
  801688:	85 c0                	test   %eax,%eax
  80168a:	75 c9                	jne    801655 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80168c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801691:	c9                   	leave  
  801692:	c3                   	ret    

00801693 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801693:	55                   	push   %ebp
  801694:	89 e5                	mov    %esp,%ebp
  801696:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801699:	8b 55 08             	mov    0x8(%ebp),%edx
  80169c:	8b 45 10             	mov    0x10(%ebp),%eax
  80169f:	01 d0                	add    %edx,%eax
  8016a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8016a4:	eb 15                	jmp    8016bb <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8016a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a9:	8a 00                	mov    (%eax),%al
  8016ab:	0f b6 d0             	movzbl %al,%edx
  8016ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016b1:	0f b6 c0             	movzbl %al,%eax
  8016b4:	39 c2                	cmp    %eax,%edx
  8016b6:	74 0d                	je     8016c5 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8016b8:	ff 45 08             	incl   0x8(%ebp)
  8016bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016be:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8016c1:	72 e3                	jb     8016a6 <memfind+0x13>
  8016c3:	eb 01                	jmp    8016c6 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8016c5:	90                   	nop
	return (void *) s;
  8016c6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016c9:	c9                   	leave  
  8016ca:	c3                   	ret    

008016cb <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8016cb:	55                   	push   %ebp
  8016cc:	89 e5                	mov    %esp,%ebp
  8016ce:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8016d1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8016d8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8016df:	eb 03                	jmp    8016e4 <strtol+0x19>
		s++;
  8016e1:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8016e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e7:	8a 00                	mov    (%eax),%al
  8016e9:	3c 20                	cmp    $0x20,%al
  8016eb:	74 f4                	je     8016e1 <strtol+0x16>
  8016ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f0:	8a 00                	mov    (%eax),%al
  8016f2:	3c 09                	cmp    $0x9,%al
  8016f4:	74 eb                	je     8016e1 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8016f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f9:	8a 00                	mov    (%eax),%al
  8016fb:	3c 2b                	cmp    $0x2b,%al
  8016fd:	75 05                	jne    801704 <strtol+0x39>
		s++;
  8016ff:	ff 45 08             	incl   0x8(%ebp)
  801702:	eb 13                	jmp    801717 <strtol+0x4c>
	else if (*s == '-')
  801704:	8b 45 08             	mov    0x8(%ebp),%eax
  801707:	8a 00                	mov    (%eax),%al
  801709:	3c 2d                	cmp    $0x2d,%al
  80170b:	75 0a                	jne    801717 <strtol+0x4c>
		s++, neg = 1;
  80170d:	ff 45 08             	incl   0x8(%ebp)
  801710:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801717:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80171b:	74 06                	je     801723 <strtol+0x58>
  80171d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801721:	75 20                	jne    801743 <strtol+0x78>
  801723:	8b 45 08             	mov    0x8(%ebp),%eax
  801726:	8a 00                	mov    (%eax),%al
  801728:	3c 30                	cmp    $0x30,%al
  80172a:	75 17                	jne    801743 <strtol+0x78>
  80172c:	8b 45 08             	mov    0x8(%ebp),%eax
  80172f:	40                   	inc    %eax
  801730:	8a 00                	mov    (%eax),%al
  801732:	3c 78                	cmp    $0x78,%al
  801734:	75 0d                	jne    801743 <strtol+0x78>
		s += 2, base = 16;
  801736:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80173a:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801741:	eb 28                	jmp    80176b <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801743:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801747:	75 15                	jne    80175e <strtol+0x93>
  801749:	8b 45 08             	mov    0x8(%ebp),%eax
  80174c:	8a 00                	mov    (%eax),%al
  80174e:	3c 30                	cmp    $0x30,%al
  801750:	75 0c                	jne    80175e <strtol+0x93>
		s++, base = 8;
  801752:	ff 45 08             	incl   0x8(%ebp)
  801755:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80175c:	eb 0d                	jmp    80176b <strtol+0xa0>
	else if (base == 0)
  80175e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801762:	75 07                	jne    80176b <strtol+0xa0>
		base = 10;
  801764:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80176b:	8b 45 08             	mov    0x8(%ebp),%eax
  80176e:	8a 00                	mov    (%eax),%al
  801770:	3c 2f                	cmp    $0x2f,%al
  801772:	7e 19                	jle    80178d <strtol+0xc2>
  801774:	8b 45 08             	mov    0x8(%ebp),%eax
  801777:	8a 00                	mov    (%eax),%al
  801779:	3c 39                	cmp    $0x39,%al
  80177b:	7f 10                	jg     80178d <strtol+0xc2>
			dig = *s - '0';
  80177d:	8b 45 08             	mov    0x8(%ebp),%eax
  801780:	8a 00                	mov    (%eax),%al
  801782:	0f be c0             	movsbl %al,%eax
  801785:	83 e8 30             	sub    $0x30,%eax
  801788:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80178b:	eb 42                	jmp    8017cf <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80178d:	8b 45 08             	mov    0x8(%ebp),%eax
  801790:	8a 00                	mov    (%eax),%al
  801792:	3c 60                	cmp    $0x60,%al
  801794:	7e 19                	jle    8017af <strtol+0xe4>
  801796:	8b 45 08             	mov    0x8(%ebp),%eax
  801799:	8a 00                	mov    (%eax),%al
  80179b:	3c 7a                	cmp    $0x7a,%al
  80179d:	7f 10                	jg     8017af <strtol+0xe4>
			dig = *s - 'a' + 10;
  80179f:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a2:	8a 00                	mov    (%eax),%al
  8017a4:	0f be c0             	movsbl %al,%eax
  8017a7:	83 e8 57             	sub    $0x57,%eax
  8017aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017ad:	eb 20                	jmp    8017cf <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8017af:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b2:	8a 00                	mov    (%eax),%al
  8017b4:	3c 40                	cmp    $0x40,%al
  8017b6:	7e 39                	jle    8017f1 <strtol+0x126>
  8017b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bb:	8a 00                	mov    (%eax),%al
  8017bd:	3c 5a                	cmp    $0x5a,%al
  8017bf:	7f 30                	jg     8017f1 <strtol+0x126>
			dig = *s - 'A' + 10;
  8017c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c4:	8a 00                	mov    (%eax),%al
  8017c6:	0f be c0             	movsbl %al,%eax
  8017c9:	83 e8 37             	sub    $0x37,%eax
  8017cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8017cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017d2:	3b 45 10             	cmp    0x10(%ebp),%eax
  8017d5:	7d 19                	jge    8017f0 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8017d7:	ff 45 08             	incl   0x8(%ebp)
  8017da:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017dd:	0f af 45 10          	imul   0x10(%ebp),%eax
  8017e1:	89 c2                	mov    %eax,%edx
  8017e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017e6:	01 d0                	add    %edx,%eax
  8017e8:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8017eb:	e9 7b ff ff ff       	jmp    80176b <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8017f0:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8017f1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8017f5:	74 08                	je     8017ff <strtol+0x134>
		*endptr = (char *) s;
  8017f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017fa:	8b 55 08             	mov    0x8(%ebp),%edx
  8017fd:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8017ff:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801803:	74 07                	je     80180c <strtol+0x141>
  801805:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801808:	f7 d8                	neg    %eax
  80180a:	eb 03                	jmp    80180f <strtol+0x144>
  80180c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80180f:	c9                   	leave  
  801810:	c3                   	ret    

00801811 <ltostr>:

void
ltostr(long value, char *str)
{
  801811:	55                   	push   %ebp
  801812:	89 e5                	mov    %esp,%ebp
  801814:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801817:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80181e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801825:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801829:	79 13                	jns    80183e <ltostr+0x2d>
	{
		neg = 1;
  80182b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801832:	8b 45 0c             	mov    0xc(%ebp),%eax
  801835:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801838:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80183b:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80183e:	8b 45 08             	mov    0x8(%ebp),%eax
  801841:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801846:	99                   	cltd   
  801847:	f7 f9                	idiv   %ecx
  801849:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80184c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80184f:	8d 50 01             	lea    0x1(%eax),%edx
  801852:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801855:	89 c2                	mov    %eax,%edx
  801857:	8b 45 0c             	mov    0xc(%ebp),%eax
  80185a:	01 d0                	add    %edx,%eax
  80185c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80185f:	83 c2 30             	add    $0x30,%edx
  801862:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801864:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801867:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80186c:	f7 e9                	imul   %ecx
  80186e:	c1 fa 02             	sar    $0x2,%edx
  801871:	89 c8                	mov    %ecx,%eax
  801873:	c1 f8 1f             	sar    $0x1f,%eax
  801876:	29 c2                	sub    %eax,%edx
  801878:	89 d0                	mov    %edx,%eax
  80187a:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80187d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801881:	75 bb                	jne    80183e <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801883:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80188a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80188d:	48                   	dec    %eax
  80188e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801891:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801895:	74 3d                	je     8018d4 <ltostr+0xc3>
		start = 1 ;
  801897:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80189e:	eb 34                	jmp    8018d4 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8018a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018a6:	01 d0                	add    %edx,%eax
  8018a8:	8a 00                	mov    (%eax),%al
  8018aa:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8018ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018b3:	01 c2                	add    %eax,%edx
  8018b5:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8018b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018bb:	01 c8                	add    %ecx,%eax
  8018bd:	8a 00                	mov    (%eax),%al
  8018bf:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8018c1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c7:	01 c2                	add    %eax,%edx
  8018c9:	8a 45 eb             	mov    -0x15(%ebp),%al
  8018cc:	88 02                	mov    %al,(%edx)
		start++ ;
  8018ce:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8018d1:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8018d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018d7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8018da:	7c c4                	jl     8018a0 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8018dc:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8018df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018e2:	01 d0                	add    %edx,%eax
  8018e4:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8018e7:	90                   	nop
  8018e8:	c9                   	leave  
  8018e9:	c3                   	ret    

008018ea <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8018ea:	55                   	push   %ebp
  8018eb:	89 e5                	mov    %esp,%ebp
  8018ed:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8018f0:	ff 75 08             	pushl  0x8(%ebp)
  8018f3:	e8 c4 f9 ff ff       	call   8012bc <strlen>
  8018f8:	83 c4 04             	add    $0x4,%esp
  8018fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8018fe:	ff 75 0c             	pushl  0xc(%ebp)
  801901:	e8 b6 f9 ff ff       	call   8012bc <strlen>
  801906:	83 c4 04             	add    $0x4,%esp
  801909:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80190c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801913:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80191a:	eb 17                	jmp    801933 <strcconcat+0x49>
		final[s] = str1[s] ;
  80191c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80191f:	8b 45 10             	mov    0x10(%ebp),%eax
  801922:	01 c2                	add    %eax,%edx
  801924:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801927:	8b 45 08             	mov    0x8(%ebp),%eax
  80192a:	01 c8                	add    %ecx,%eax
  80192c:	8a 00                	mov    (%eax),%al
  80192e:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801930:	ff 45 fc             	incl   -0x4(%ebp)
  801933:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801936:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801939:	7c e1                	jl     80191c <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80193b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801942:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801949:	eb 1f                	jmp    80196a <strcconcat+0x80>
		final[s++] = str2[i] ;
  80194b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80194e:	8d 50 01             	lea    0x1(%eax),%edx
  801951:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801954:	89 c2                	mov    %eax,%edx
  801956:	8b 45 10             	mov    0x10(%ebp),%eax
  801959:	01 c2                	add    %eax,%edx
  80195b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80195e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801961:	01 c8                	add    %ecx,%eax
  801963:	8a 00                	mov    (%eax),%al
  801965:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801967:	ff 45 f8             	incl   -0x8(%ebp)
  80196a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80196d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801970:	7c d9                	jl     80194b <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801972:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801975:	8b 45 10             	mov    0x10(%ebp),%eax
  801978:	01 d0                	add    %edx,%eax
  80197a:	c6 00 00             	movb   $0x0,(%eax)
}
  80197d:	90                   	nop
  80197e:	c9                   	leave  
  80197f:	c3                   	ret    

00801980 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801980:	55                   	push   %ebp
  801981:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801983:	8b 45 14             	mov    0x14(%ebp),%eax
  801986:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80198c:	8b 45 14             	mov    0x14(%ebp),%eax
  80198f:	8b 00                	mov    (%eax),%eax
  801991:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801998:	8b 45 10             	mov    0x10(%ebp),%eax
  80199b:	01 d0                	add    %edx,%eax
  80199d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8019a3:	eb 0c                	jmp    8019b1 <strsplit+0x31>
			*string++ = 0;
  8019a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a8:	8d 50 01             	lea    0x1(%eax),%edx
  8019ab:	89 55 08             	mov    %edx,0x8(%ebp)
  8019ae:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8019b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b4:	8a 00                	mov    (%eax),%al
  8019b6:	84 c0                	test   %al,%al
  8019b8:	74 18                	je     8019d2 <strsplit+0x52>
  8019ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bd:	8a 00                	mov    (%eax),%al
  8019bf:	0f be c0             	movsbl %al,%eax
  8019c2:	50                   	push   %eax
  8019c3:	ff 75 0c             	pushl  0xc(%ebp)
  8019c6:	e8 83 fa ff ff       	call   80144e <strchr>
  8019cb:	83 c4 08             	add    $0x8,%esp
  8019ce:	85 c0                	test   %eax,%eax
  8019d0:	75 d3                	jne    8019a5 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8019d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d5:	8a 00                	mov    (%eax),%al
  8019d7:	84 c0                	test   %al,%al
  8019d9:	74 5a                	je     801a35 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8019db:	8b 45 14             	mov    0x14(%ebp),%eax
  8019de:	8b 00                	mov    (%eax),%eax
  8019e0:	83 f8 0f             	cmp    $0xf,%eax
  8019e3:	75 07                	jne    8019ec <strsplit+0x6c>
		{
			return 0;
  8019e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8019ea:	eb 66                	jmp    801a52 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8019ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8019ef:	8b 00                	mov    (%eax),%eax
  8019f1:	8d 48 01             	lea    0x1(%eax),%ecx
  8019f4:	8b 55 14             	mov    0x14(%ebp),%edx
  8019f7:	89 0a                	mov    %ecx,(%edx)
  8019f9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a00:	8b 45 10             	mov    0x10(%ebp),%eax
  801a03:	01 c2                	add    %eax,%edx
  801a05:	8b 45 08             	mov    0x8(%ebp),%eax
  801a08:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a0a:	eb 03                	jmp    801a0f <strsplit+0x8f>
			string++;
  801a0c:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a12:	8a 00                	mov    (%eax),%al
  801a14:	84 c0                	test   %al,%al
  801a16:	74 8b                	je     8019a3 <strsplit+0x23>
  801a18:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1b:	8a 00                	mov    (%eax),%al
  801a1d:	0f be c0             	movsbl %al,%eax
  801a20:	50                   	push   %eax
  801a21:	ff 75 0c             	pushl  0xc(%ebp)
  801a24:	e8 25 fa ff ff       	call   80144e <strchr>
  801a29:	83 c4 08             	add    $0x8,%esp
  801a2c:	85 c0                	test   %eax,%eax
  801a2e:	74 dc                	je     801a0c <strsplit+0x8c>
			string++;
	}
  801a30:	e9 6e ff ff ff       	jmp    8019a3 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801a35:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801a36:	8b 45 14             	mov    0x14(%ebp),%eax
  801a39:	8b 00                	mov    (%eax),%eax
  801a3b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a42:	8b 45 10             	mov    0x10(%ebp),%eax
  801a45:	01 d0                	add    %edx,%eax
  801a47:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801a4d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801a52:	c9                   	leave  
  801a53:	c3                   	ret    

00801a54 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801a54:	55                   	push   %ebp
  801a55:	89 e5                	mov    %esp,%ebp
  801a57:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801a60:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801a67:	eb 4a                	jmp    801ab3 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801a69:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6f:	01 c2                	add    %eax,%edx
  801a71:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801a74:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a77:	01 c8                	add    %ecx,%eax
  801a79:	8a 00                	mov    (%eax),%al
  801a7b:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801a7d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a80:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a83:	01 d0                	add    %edx,%eax
  801a85:	8a 00                	mov    (%eax),%al
  801a87:	3c 40                	cmp    $0x40,%al
  801a89:	7e 25                	jle    801ab0 <str2lower+0x5c>
  801a8b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a91:	01 d0                	add    %edx,%eax
  801a93:	8a 00                	mov    (%eax),%al
  801a95:	3c 5a                	cmp    $0x5a,%al
  801a97:	7f 17                	jg     801ab0 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801a99:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9f:	01 d0                	add    %edx,%eax
  801aa1:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801aa4:	8b 55 08             	mov    0x8(%ebp),%edx
  801aa7:	01 ca                	add    %ecx,%edx
  801aa9:	8a 12                	mov    (%edx),%dl
  801aab:	83 c2 20             	add    $0x20,%edx
  801aae:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801ab0:	ff 45 fc             	incl   -0x4(%ebp)
  801ab3:	ff 75 0c             	pushl  0xc(%ebp)
  801ab6:	e8 01 f8 ff ff       	call   8012bc <strlen>
  801abb:	83 c4 04             	add    $0x4,%esp
  801abe:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801ac1:	7f a6                	jg     801a69 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801ac3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801ac6:	c9                   	leave  
  801ac7:	c3                   	ret    

00801ac8 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801ac8:	55                   	push   %ebp
  801ac9:	89 e5                	mov    %esp,%ebp
  801acb:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801ace:	a1 08 40 80 00       	mov    0x804008,%eax
  801ad3:	85 c0                	test   %eax,%eax
  801ad5:	74 42                	je     801b19 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801ad7:	83 ec 08             	sub    $0x8,%esp
  801ada:	68 00 00 00 82       	push   $0x82000000
  801adf:	68 00 00 00 80       	push   $0x80000000
  801ae4:	e8 8c 07 00 00       	call   802275 <initialize_dynamic_allocator>
  801ae9:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801aec:	e8 e7 05 00 00       	call   8020d8 <sys_get_uheap_strategy>
  801af1:	a3 60 c0 81 00       	mov    %eax,0x81c060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801af6:	a1 40 40 80 00       	mov    0x804040,%eax
  801afb:	05 00 10 00 00       	add    $0x1000,%eax
  801b00:	a3 10 c1 81 00       	mov    %eax,0x81c110
		uheapPageAllocBreak = uheapPageAllocStart;
  801b05:	a1 10 c1 81 00       	mov    0x81c110,%eax
  801b0a:	a3 68 c0 81 00       	mov    %eax,0x81c068

		__firstTimeFlag = 0;
  801b0f:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  801b16:	00 00 00 
	}
}
  801b19:	90                   	nop
  801b1a:	c9                   	leave  
  801b1b:	c3                   	ret    

00801b1c <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801b1c:	55                   	push   %ebp
  801b1d:	89 e5                	mov    %esp,%ebp
  801b1f:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801b22:	8b 45 08             	mov    0x8(%ebp),%eax
  801b25:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b2b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801b30:	83 ec 08             	sub    $0x8,%esp
  801b33:	68 06 04 00 00       	push   $0x406
  801b38:	50                   	push   %eax
  801b39:	e8 e4 01 00 00       	call   801d22 <__sys_allocate_page>
  801b3e:	83 c4 10             	add    $0x10,%esp
  801b41:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801b44:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801b48:	79 14                	jns    801b5e <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801b4a:	83 ec 04             	sub    $0x4,%esp
  801b4d:	68 08 2e 80 00       	push   $0x802e08
  801b52:	6a 1f                	push   $0x1f
  801b54:	68 44 2e 80 00       	push   $0x802e44
  801b59:	e8 b7 ed ff ff       	call   800915 <_panic>
	return 0;
  801b5e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b63:	c9                   	leave  
  801b64:	c3                   	ret    

00801b65 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801b65:	55                   	push   %ebp
  801b66:	89 e5                	mov    %esp,%ebp
  801b68:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b74:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801b79:	83 ec 0c             	sub    $0xc,%esp
  801b7c:	50                   	push   %eax
  801b7d:	e8 e7 01 00 00       	call   801d69 <__sys_unmap_frame>
  801b82:	83 c4 10             	add    $0x10,%esp
  801b85:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801b88:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801b8c:	79 14                	jns    801ba2 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801b8e:	83 ec 04             	sub    $0x4,%esp
  801b91:	68 50 2e 80 00       	push   $0x802e50
  801b96:	6a 2a                	push   $0x2a
  801b98:	68 44 2e 80 00       	push   $0x802e44
  801b9d:	e8 73 ed ff ff       	call   800915 <_panic>
}
  801ba2:	90                   	nop
  801ba3:	c9                   	leave  
  801ba4:	c3                   	ret    

00801ba5 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801ba5:	55                   	push   %ebp
  801ba6:	89 e5                	mov    %esp,%ebp
  801ba8:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801bab:	e8 18 ff ff ff       	call   801ac8 <uheap_init>
	if (size == 0) return NULL ;
  801bb0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801bb4:	75 07                	jne    801bbd <malloc+0x18>
  801bb6:	b8 00 00 00 00       	mov    $0x0,%eax
  801bbb:	eb 14                	jmp    801bd1 <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  801bbd:	83 ec 04             	sub    $0x4,%esp
  801bc0:	68 90 2e 80 00       	push   $0x802e90
  801bc5:	6a 3e                	push   $0x3e
  801bc7:	68 44 2e 80 00       	push   $0x802e44
  801bcc:	e8 44 ed ff ff       	call   800915 <_panic>
}
  801bd1:	c9                   	leave  
  801bd2:	c3                   	ret    

00801bd3 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801bd3:	55                   	push   %ebp
  801bd4:	89 e5                	mov    %esp,%ebp
  801bd6:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  801bd9:	83 ec 04             	sub    $0x4,%esp
  801bdc:	68 b8 2e 80 00       	push   $0x802eb8
  801be1:	6a 49                	push   $0x49
  801be3:	68 44 2e 80 00       	push   $0x802e44
  801be8:	e8 28 ed ff ff       	call   800915 <_panic>

00801bed <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801bed:	55                   	push   %ebp
  801bee:	89 e5                	mov    %esp,%ebp
  801bf0:	83 ec 18             	sub    $0x18,%esp
  801bf3:	8b 45 10             	mov    0x10(%ebp),%eax
  801bf6:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801bf9:	e8 ca fe ff ff       	call   801ac8 <uheap_init>
	if (size == 0) return NULL ;
  801bfe:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801c02:	75 07                	jne    801c0b <smalloc+0x1e>
  801c04:	b8 00 00 00 00       	mov    $0x0,%eax
  801c09:	eb 14                	jmp    801c1f <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  801c0b:	83 ec 04             	sub    $0x4,%esp
  801c0e:	68 dc 2e 80 00       	push   $0x802edc
  801c13:	6a 5a                	push   $0x5a
  801c15:	68 44 2e 80 00       	push   $0x802e44
  801c1a:	e8 f6 ec ff ff       	call   800915 <_panic>
}
  801c1f:	c9                   	leave  
  801c20:	c3                   	ret    

00801c21 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801c21:	55                   	push   %ebp
  801c22:	89 e5                	mov    %esp,%ebp
  801c24:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801c27:	e8 9c fe ff ff       	call   801ac8 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  801c2c:	83 ec 04             	sub    $0x4,%esp
  801c2f:	68 04 2f 80 00       	push   $0x802f04
  801c34:	6a 6a                	push   $0x6a
  801c36:	68 44 2e 80 00       	push   $0x802e44
  801c3b:	e8 d5 ec ff ff       	call   800915 <_panic>

00801c40 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801c40:	55                   	push   %ebp
  801c41:	89 e5                	mov    %esp,%ebp
  801c43:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801c46:	e8 7d fe ff ff       	call   801ac8 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  801c4b:	83 ec 04             	sub    $0x4,%esp
  801c4e:	68 28 2f 80 00       	push   $0x802f28
  801c53:	68 88 00 00 00       	push   $0x88
  801c58:	68 44 2e 80 00       	push   $0x802e44
  801c5d:	e8 b3 ec ff ff       	call   800915 <_panic>

00801c62 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  801c62:	55                   	push   %ebp
  801c63:	89 e5                	mov    %esp,%ebp
  801c65:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  801c68:	83 ec 04             	sub    $0x4,%esp
  801c6b:	68 50 2f 80 00       	push   $0x802f50
  801c70:	68 9b 00 00 00       	push   $0x9b
  801c75:	68 44 2e 80 00       	push   $0x802e44
  801c7a:	e8 96 ec ff ff       	call   800915 <_panic>

00801c7f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801c7f:	55                   	push   %ebp
  801c80:	89 e5                	mov    %esp,%ebp
  801c82:	57                   	push   %edi
  801c83:	56                   	push   %esi
  801c84:	53                   	push   %ebx
  801c85:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801c88:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c8e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c91:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c94:	8b 7d 18             	mov    0x18(%ebp),%edi
  801c97:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801c9a:	cd 30                	int    $0x30
  801c9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801c9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801ca2:	83 c4 10             	add    $0x10,%esp
  801ca5:	5b                   	pop    %ebx
  801ca6:	5e                   	pop    %esi
  801ca7:	5f                   	pop    %edi
  801ca8:	5d                   	pop    %ebp
  801ca9:	c3                   	ret    

00801caa <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801caa:	55                   	push   %ebp
  801cab:	89 e5                	mov    %esp,%ebp
  801cad:	83 ec 04             	sub    $0x4,%esp
  801cb0:	8b 45 10             	mov    0x10(%ebp),%eax
  801cb3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801cb6:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801cb9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc0:	6a 00                	push   $0x0
  801cc2:	51                   	push   %ecx
  801cc3:	52                   	push   %edx
  801cc4:	ff 75 0c             	pushl  0xc(%ebp)
  801cc7:	50                   	push   %eax
  801cc8:	6a 00                	push   $0x0
  801cca:	e8 b0 ff ff ff       	call   801c7f <syscall>
  801ccf:	83 c4 18             	add    $0x18,%esp
}
  801cd2:	90                   	nop
  801cd3:	c9                   	leave  
  801cd4:	c3                   	ret    

00801cd5 <sys_cgetc>:

int
sys_cgetc(void)
{
  801cd5:	55                   	push   %ebp
  801cd6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801cd8:	6a 00                	push   $0x0
  801cda:	6a 00                	push   $0x0
  801cdc:	6a 00                	push   $0x0
  801cde:	6a 00                	push   $0x0
  801ce0:	6a 00                	push   $0x0
  801ce2:	6a 02                	push   $0x2
  801ce4:	e8 96 ff ff ff       	call   801c7f <syscall>
  801ce9:	83 c4 18             	add    $0x18,%esp
}
  801cec:	c9                   	leave  
  801ced:	c3                   	ret    

00801cee <sys_lock_cons>:

void sys_lock_cons(void)
{
  801cee:	55                   	push   %ebp
  801cef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801cf1:	6a 00                	push   $0x0
  801cf3:	6a 00                	push   $0x0
  801cf5:	6a 00                	push   $0x0
  801cf7:	6a 00                	push   $0x0
  801cf9:	6a 00                	push   $0x0
  801cfb:	6a 03                	push   $0x3
  801cfd:	e8 7d ff ff ff       	call   801c7f <syscall>
  801d02:	83 c4 18             	add    $0x18,%esp
}
  801d05:	90                   	nop
  801d06:	c9                   	leave  
  801d07:	c3                   	ret    

00801d08 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801d08:	55                   	push   %ebp
  801d09:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801d0b:	6a 00                	push   $0x0
  801d0d:	6a 00                	push   $0x0
  801d0f:	6a 00                	push   $0x0
  801d11:	6a 00                	push   $0x0
  801d13:	6a 00                	push   $0x0
  801d15:	6a 04                	push   $0x4
  801d17:	e8 63 ff ff ff       	call   801c7f <syscall>
  801d1c:	83 c4 18             	add    $0x18,%esp
}
  801d1f:	90                   	nop
  801d20:	c9                   	leave  
  801d21:	c3                   	ret    

00801d22 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801d22:	55                   	push   %ebp
  801d23:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801d25:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d28:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2b:	6a 00                	push   $0x0
  801d2d:	6a 00                	push   $0x0
  801d2f:	6a 00                	push   $0x0
  801d31:	52                   	push   %edx
  801d32:	50                   	push   %eax
  801d33:	6a 08                	push   $0x8
  801d35:	e8 45 ff ff ff       	call   801c7f <syscall>
  801d3a:	83 c4 18             	add    $0x18,%esp
}
  801d3d:	c9                   	leave  
  801d3e:	c3                   	ret    

00801d3f <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801d3f:	55                   	push   %ebp
  801d40:	89 e5                	mov    %esp,%ebp
  801d42:	56                   	push   %esi
  801d43:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801d44:	8b 75 18             	mov    0x18(%ebp),%esi
  801d47:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d4a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d50:	8b 45 08             	mov    0x8(%ebp),%eax
  801d53:	56                   	push   %esi
  801d54:	53                   	push   %ebx
  801d55:	51                   	push   %ecx
  801d56:	52                   	push   %edx
  801d57:	50                   	push   %eax
  801d58:	6a 09                	push   $0x9
  801d5a:	e8 20 ff ff ff       	call   801c7f <syscall>
  801d5f:	83 c4 18             	add    $0x18,%esp
}
  801d62:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d65:	5b                   	pop    %ebx
  801d66:	5e                   	pop    %esi
  801d67:	5d                   	pop    %ebp
  801d68:	c3                   	ret    

00801d69 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801d69:	55                   	push   %ebp
  801d6a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801d6c:	6a 00                	push   $0x0
  801d6e:	6a 00                	push   $0x0
  801d70:	6a 00                	push   $0x0
  801d72:	6a 00                	push   $0x0
  801d74:	ff 75 08             	pushl  0x8(%ebp)
  801d77:	6a 0a                	push   $0xa
  801d79:	e8 01 ff ff ff       	call   801c7f <syscall>
  801d7e:	83 c4 18             	add    $0x18,%esp
}
  801d81:	c9                   	leave  
  801d82:	c3                   	ret    

00801d83 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801d83:	55                   	push   %ebp
  801d84:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801d86:	6a 00                	push   $0x0
  801d88:	6a 00                	push   $0x0
  801d8a:	6a 00                	push   $0x0
  801d8c:	ff 75 0c             	pushl  0xc(%ebp)
  801d8f:	ff 75 08             	pushl  0x8(%ebp)
  801d92:	6a 0b                	push   $0xb
  801d94:	e8 e6 fe ff ff       	call   801c7f <syscall>
  801d99:	83 c4 18             	add    $0x18,%esp
}
  801d9c:	c9                   	leave  
  801d9d:	c3                   	ret    

00801d9e <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801d9e:	55                   	push   %ebp
  801d9f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801da1:	6a 00                	push   $0x0
  801da3:	6a 00                	push   $0x0
  801da5:	6a 00                	push   $0x0
  801da7:	6a 00                	push   $0x0
  801da9:	6a 00                	push   $0x0
  801dab:	6a 0c                	push   $0xc
  801dad:	e8 cd fe ff ff       	call   801c7f <syscall>
  801db2:	83 c4 18             	add    $0x18,%esp
}
  801db5:	c9                   	leave  
  801db6:	c3                   	ret    

00801db7 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801db7:	55                   	push   %ebp
  801db8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801dba:	6a 00                	push   $0x0
  801dbc:	6a 00                	push   $0x0
  801dbe:	6a 00                	push   $0x0
  801dc0:	6a 00                	push   $0x0
  801dc2:	6a 00                	push   $0x0
  801dc4:	6a 0d                	push   $0xd
  801dc6:	e8 b4 fe ff ff       	call   801c7f <syscall>
  801dcb:	83 c4 18             	add    $0x18,%esp
}
  801dce:	c9                   	leave  
  801dcf:	c3                   	ret    

00801dd0 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801dd0:	55                   	push   %ebp
  801dd1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801dd3:	6a 00                	push   $0x0
  801dd5:	6a 00                	push   $0x0
  801dd7:	6a 00                	push   $0x0
  801dd9:	6a 00                	push   $0x0
  801ddb:	6a 00                	push   $0x0
  801ddd:	6a 0e                	push   $0xe
  801ddf:	e8 9b fe ff ff       	call   801c7f <syscall>
  801de4:	83 c4 18             	add    $0x18,%esp
}
  801de7:	c9                   	leave  
  801de8:	c3                   	ret    

00801de9 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801de9:	55                   	push   %ebp
  801dea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801dec:	6a 00                	push   $0x0
  801dee:	6a 00                	push   $0x0
  801df0:	6a 00                	push   $0x0
  801df2:	6a 00                	push   $0x0
  801df4:	6a 00                	push   $0x0
  801df6:	6a 0f                	push   $0xf
  801df8:	e8 82 fe ff ff       	call   801c7f <syscall>
  801dfd:	83 c4 18             	add    $0x18,%esp
}
  801e00:	c9                   	leave  
  801e01:	c3                   	ret    

00801e02 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801e02:	55                   	push   %ebp
  801e03:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801e05:	6a 00                	push   $0x0
  801e07:	6a 00                	push   $0x0
  801e09:	6a 00                	push   $0x0
  801e0b:	6a 00                	push   $0x0
  801e0d:	ff 75 08             	pushl  0x8(%ebp)
  801e10:	6a 10                	push   $0x10
  801e12:	e8 68 fe ff ff       	call   801c7f <syscall>
  801e17:	83 c4 18             	add    $0x18,%esp
}
  801e1a:	c9                   	leave  
  801e1b:	c3                   	ret    

00801e1c <sys_scarce_memory>:

void sys_scarce_memory()
{
  801e1c:	55                   	push   %ebp
  801e1d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801e1f:	6a 00                	push   $0x0
  801e21:	6a 00                	push   $0x0
  801e23:	6a 00                	push   $0x0
  801e25:	6a 00                	push   $0x0
  801e27:	6a 00                	push   $0x0
  801e29:	6a 11                	push   $0x11
  801e2b:	e8 4f fe ff ff       	call   801c7f <syscall>
  801e30:	83 c4 18             	add    $0x18,%esp
}
  801e33:	90                   	nop
  801e34:	c9                   	leave  
  801e35:	c3                   	ret    

00801e36 <sys_cputc>:

void
sys_cputc(const char c)
{
  801e36:	55                   	push   %ebp
  801e37:	89 e5                	mov    %esp,%ebp
  801e39:	83 ec 04             	sub    $0x4,%esp
  801e3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801e42:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e46:	6a 00                	push   $0x0
  801e48:	6a 00                	push   $0x0
  801e4a:	6a 00                	push   $0x0
  801e4c:	6a 00                	push   $0x0
  801e4e:	50                   	push   %eax
  801e4f:	6a 01                	push   $0x1
  801e51:	e8 29 fe ff ff       	call   801c7f <syscall>
  801e56:	83 c4 18             	add    $0x18,%esp
}
  801e59:	90                   	nop
  801e5a:	c9                   	leave  
  801e5b:	c3                   	ret    

00801e5c <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801e5c:	55                   	push   %ebp
  801e5d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801e5f:	6a 00                	push   $0x0
  801e61:	6a 00                	push   $0x0
  801e63:	6a 00                	push   $0x0
  801e65:	6a 00                	push   $0x0
  801e67:	6a 00                	push   $0x0
  801e69:	6a 14                	push   $0x14
  801e6b:	e8 0f fe ff ff       	call   801c7f <syscall>
  801e70:	83 c4 18             	add    $0x18,%esp
}
  801e73:	90                   	nop
  801e74:	c9                   	leave  
  801e75:	c3                   	ret    

00801e76 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801e76:	55                   	push   %ebp
  801e77:	89 e5                	mov    %esp,%ebp
  801e79:	83 ec 04             	sub    $0x4,%esp
  801e7c:	8b 45 10             	mov    0x10(%ebp),%eax
  801e7f:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801e82:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801e85:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801e89:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8c:	6a 00                	push   $0x0
  801e8e:	51                   	push   %ecx
  801e8f:	52                   	push   %edx
  801e90:	ff 75 0c             	pushl  0xc(%ebp)
  801e93:	50                   	push   %eax
  801e94:	6a 15                	push   $0x15
  801e96:	e8 e4 fd ff ff       	call   801c7f <syscall>
  801e9b:	83 c4 18             	add    $0x18,%esp
}
  801e9e:	c9                   	leave  
  801e9f:	c3                   	ret    

00801ea0 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801ea0:	55                   	push   %ebp
  801ea1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801ea3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ea6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea9:	6a 00                	push   $0x0
  801eab:	6a 00                	push   $0x0
  801ead:	6a 00                	push   $0x0
  801eaf:	52                   	push   %edx
  801eb0:	50                   	push   %eax
  801eb1:	6a 16                	push   $0x16
  801eb3:	e8 c7 fd ff ff       	call   801c7f <syscall>
  801eb8:	83 c4 18             	add    $0x18,%esp
}
  801ebb:	c9                   	leave  
  801ebc:	c3                   	ret    

00801ebd <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801ebd:	55                   	push   %ebp
  801ebe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801ec0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ec3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ec6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec9:	6a 00                	push   $0x0
  801ecb:	6a 00                	push   $0x0
  801ecd:	51                   	push   %ecx
  801ece:	52                   	push   %edx
  801ecf:	50                   	push   %eax
  801ed0:	6a 17                	push   $0x17
  801ed2:	e8 a8 fd ff ff       	call   801c7f <syscall>
  801ed7:	83 c4 18             	add    $0x18,%esp
}
  801eda:	c9                   	leave  
  801edb:	c3                   	ret    

00801edc <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801edc:	55                   	push   %ebp
  801edd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801edf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee5:	6a 00                	push   $0x0
  801ee7:	6a 00                	push   $0x0
  801ee9:	6a 00                	push   $0x0
  801eeb:	52                   	push   %edx
  801eec:	50                   	push   %eax
  801eed:	6a 18                	push   $0x18
  801eef:	e8 8b fd ff ff       	call   801c7f <syscall>
  801ef4:	83 c4 18             	add    $0x18,%esp
}
  801ef7:	c9                   	leave  
  801ef8:	c3                   	ret    

00801ef9 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801ef9:	55                   	push   %ebp
  801efa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801efc:	8b 45 08             	mov    0x8(%ebp),%eax
  801eff:	6a 00                	push   $0x0
  801f01:	ff 75 14             	pushl  0x14(%ebp)
  801f04:	ff 75 10             	pushl  0x10(%ebp)
  801f07:	ff 75 0c             	pushl  0xc(%ebp)
  801f0a:	50                   	push   %eax
  801f0b:	6a 19                	push   $0x19
  801f0d:	e8 6d fd ff ff       	call   801c7f <syscall>
  801f12:	83 c4 18             	add    $0x18,%esp
}
  801f15:	c9                   	leave  
  801f16:	c3                   	ret    

00801f17 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801f17:	55                   	push   %ebp
  801f18:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1d:	6a 00                	push   $0x0
  801f1f:	6a 00                	push   $0x0
  801f21:	6a 00                	push   $0x0
  801f23:	6a 00                	push   $0x0
  801f25:	50                   	push   %eax
  801f26:	6a 1a                	push   $0x1a
  801f28:	e8 52 fd ff ff       	call   801c7f <syscall>
  801f2d:	83 c4 18             	add    $0x18,%esp
}
  801f30:	90                   	nop
  801f31:	c9                   	leave  
  801f32:	c3                   	ret    

00801f33 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801f33:	55                   	push   %ebp
  801f34:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801f36:	8b 45 08             	mov    0x8(%ebp),%eax
  801f39:	6a 00                	push   $0x0
  801f3b:	6a 00                	push   $0x0
  801f3d:	6a 00                	push   $0x0
  801f3f:	6a 00                	push   $0x0
  801f41:	50                   	push   %eax
  801f42:	6a 1b                	push   $0x1b
  801f44:	e8 36 fd ff ff       	call   801c7f <syscall>
  801f49:	83 c4 18             	add    $0x18,%esp
}
  801f4c:	c9                   	leave  
  801f4d:	c3                   	ret    

00801f4e <sys_getenvid>:

int32 sys_getenvid(void)
{
  801f4e:	55                   	push   %ebp
  801f4f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801f51:	6a 00                	push   $0x0
  801f53:	6a 00                	push   $0x0
  801f55:	6a 00                	push   $0x0
  801f57:	6a 00                	push   $0x0
  801f59:	6a 00                	push   $0x0
  801f5b:	6a 05                	push   $0x5
  801f5d:	e8 1d fd ff ff       	call   801c7f <syscall>
  801f62:	83 c4 18             	add    $0x18,%esp
}
  801f65:	c9                   	leave  
  801f66:	c3                   	ret    

00801f67 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801f67:	55                   	push   %ebp
  801f68:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801f6a:	6a 00                	push   $0x0
  801f6c:	6a 00                	push   $0x0
  801f6e:	6a 00                	push   $0x0
  801f70:	6a 00                	push   $0x0
  801f72:	6a 00                	push   $0x0
  801f74:	6a 06                	push   $0x6
  801f76:	e8 04 fd ff ff       	call   801c7f <syscall>
  801f7b:	83 c4 18             	add    $0x18,%esp
}
  801f7e:	c9                   	leave  
  801f7f:	c3                   	ret    

00801f80 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801f80:	55                   	push   %ebp
  801f81:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801f83:	6a 00                	push   $0x0
  801f85:	6a 00                	push   $0x0
  801f87:	6a 00                	push   $0x0
  801f89:	6a 00                	push   $0x0
  801f8b:	6a 00                	push   $0x0
  801f8d:	6a 07                	push   $0x7
  801f8f:	e8 eb fc ff ff       	call   801c7f <syscall>
  801f94:	83 c4 18             	add    $0x18,%esp
}
  801f97:	c9                   	leave  
  801f98:	c3                   	ret    

00801f99 <sys_exit_env>:


void sys_exit_env(void)
{
  801f99:	55                   	push   %ebp
  801f9a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801f9c:	6a 00                	push   $0x0
  801f9e:	6a 00                	push   $0x0
  801fa0:	6a 00                	push   $0x0
  801fa2:	6a 00                	push   $0x0
  801fa4:	6a 00                	push   $0x0
  801fa6:	6a 1c                	push   $0x1c
  801fa8:	e8 d2 fc ff ff       	call   801c7f <syscall>
  801fad:	83 c4 18             	add    $0x18,%esp
}
  801fb0:	90                   	nop
  801fb1:	c9                   	leave  
  801fb2:	c3                   	ret    

00801fb3 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801fb3:	55                   	push   %ebp
  801fb4:	89 e5                	mov    %esp,%ebp
  801fb6:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801fb9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801fbc:	8d 50 04             	lea    0x4(%eax),%edx
  801fbf:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801fc2:	6a 00                	push   $0x0
  801fc4:	6a 00                	push   $0x0
  801fc6:	6a 00                	push   $0x0
  801fc8:	52                   	push   %edx
  801fc9:	50                   	push   %eax
  801fca:	6a 1d                	push   $0x1d
  801fcc:	e8 ae fc ff ff       	call   801c7f <syscall>
  801fd1:	83 c4 18             	add    $0x18,%esp
	return result;
  801fd4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fd7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801fda:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801fdd:	89 01                	mov    %eax,(%ecx)
  801fdf:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801fe2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe5:	c9                   	leave  
  801fe6:	c2 04 00             	ret    $0x4

00801fe9 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801fe9:	55                   	push   %ebp
  801fea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801fec:	6a 00                	push   $0x0
  801fee:	6a 00                	push   $0x0
  801ff0:	ff 75 10             	pushl  0x10(%ebp)
  801ff3:	ff 75 0c             	pushl  0xc(%ebp)
  801ff6:	ff 75 08             	pushl  0x8(%ebp)
  801ff9:	6a 13                	push   $0x13
  801ffb:	e8 7f fc ff ff       	call   801c7f <syscall>
  802000:	83 c4 18             	add    $0x18,%esp
	return ;
  802003:	90                   	nop
}
  802004:	c9                   	leave  
  802005:	c3                   	ret    

00802006 <sys_rcr2>:
uint32 sys_rcr2()
{
  802006:	55                   	push   %ebp
  802007:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802009:	6a 00                	push   $0x0
  80200b:	6a 00                	push   $0x0
  80200d:	6a 00                	push   $0x0
  80200f:	6a 00                	push   $0x0
  802011:	6a 00                	push   $0x0
  802013:	6a 1e                	push   $0x1e
  802015:	e8 65 fc ff ff       	call   801c7f <syscall>
  80201a:	83 c4 18             	add    $0x18,%esp
}
  80201d:	c9                   	leave  
  80201e:	c3                   	ret    

0080201f <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80201f:	55                   	push   %ebp
  802020:	89 e5                	mov    %esp,%ebp
  802022:	83 ec 04             	sub    $0x4,%esp
  802025:	8b 45 08             	mov    0x8(%ebp),%eax
  802028:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80202b:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80202f:	6a 00                	push   $0x0
  802031:	6a 00                	push   $0x0
  802033:	6a 00                	push   $0x0
  802035:	6a 00                	push   $0x0
  802037:	50                   	push   %eax
  802038:	6a 1f                	push   $0x1f
  80203a:	e8 40 fc ff ff       	call   801c7f <syscall>
  80203f:	83 c4 18             	add    $0x18,%esp
	return ;
  802042:	90                   	nop
}
  802043:	c9                   	leave  
  802044:	c3                   	ret    

00802045 <rsttst>:
void rsttst()
{
  802045:	55                   	push   %ebp
  802046:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802048:	6a 00                	push   $0x0
  80204a:	6a 00                	push   $0x0
  80204c:	6a 00                	push   $0x0
  80204e:	6a 00                	push   $0x0
  802050:	6a 00                	push   $0x0
  802052:	6a 21                	push   $0x21
  802054:	e8 26 fc ff ff       	call   801c7f <syscall>
  802059:	83 c4 18             	add    $0x18,%esp
	return ;
  80205c:	90                   	nop
}
  80205d:	c9                   	leave  
  80205e:	c3                   	ret    

0080205f <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80205f:	55                   	push   %ebp
  802060:	89 e5                	mov    %esp,%ebp
  802062:	83 ec 04             	sub    $0x4,%esp
  802065:	8b 45 14             	mov    0x14(%ebp),%eax
  802068:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80206b:	8b 55 18             	mov    0x18(%ebp),%edx
  80206e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802072:	52                   	push   %edx
  802073:	50                   	push   %eax
  802074:	ff 75 10             	pushl  0x10(%ebp)
  802077:	ff 75 0c             	pushl  0xc(%ebp)
  80207a:	ff 75 08             	pushl  0x8(%ebp)
  80207d:	6a 20                	push   $0x20
  80207f:	e8 fb fb ff ff       	call   801c7f <syscall>
  802084:	83 c4 18             	add    $0x18,%esp
	return ;
  802087:	90                   	nop
}
  802088:	c9                   	leave  
  802089:	c3                   	ret    

0080208a <chktst>:
void chktst(uint32 n)
{
  80208a:	55                   	push   %ebp
  80208b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80208d:	6a 00                	push   $0x0
  80208f:	6a 00                	push   $0x0
  802091:	6a 00                	push   $0x0
  802093:	6a 00                	push   $0x0
  802095:	ff 75 08             	pushl  0x8(%ebp)
  802098:	6a 22                	push   $0x22
  80209a:	e8 e0 fb ff ff       	call   801c7f <syscall>
  80209f:	83 c4 18             	add    $0x18,%esp
	return ;
  8020a2:	90                   	nop
}
  8020a3:	c9                   	leave  
  8020a4:	c3                   	ret    

008020a5 <inctst>:

void inctst()
{
  8020a5:	55                   	push   %ebp
  8020a6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8020a8:	6a 00                	push   $0x0
  8020aa:	6a 00                	push   $0x0
  8020ac:	6a 00                	push   $0x0
  8020ae:	6a 00                	push   $0x0
  8020b0:	6a 00                	push   $0x0
  8020b2:	6a 23                	push   $0x23
  8020b4:	e8 c6 fb ff ff       	call   801c7f <syscall>
  8020b9:	83 c4 18             	add    $0x18,%esp
	return ;
  8020bc:	90                   	nop
}
  8020bd:	c9                   	leave  
  8020be:	c3                   	ret    

008020bf <gettst>:
uint32 gettst()
{
  8020bf:	55                   	push   %ebp
  8020c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8020c2:	6a 00                	push   $0x0
  8020c4:	6a 00                	push   $0x0
  8020c6:	6a 00                	push   $0x0
  8020c8:	6a 00                	push   $0x0
  8020ca:	6a 00                	push   $0x0
  8020cc:	6a 24                	push   $0x24
  8020ce:	e8 ac fb ff ff       	call   801c7f <syscall>
  8020d3:	83 c4 18             	add    $0x18,%esp
}
  8020d6:	c9                   	leave  
  8020d7:	c3                   	ret    

008020d8 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8020d8:	55                   	push   %ebp
  8020d9:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020db:	6a 00                	push   $0x0
  8020dd:	6a 00                	push   $0x0
  8020df:	6a 00                	push   $0x0
  8020e1:	6a 00                	push   $0x0
  8020e3:	6a 00                	push   $0x0
  8020e5:	6a 25                	push   $0x25
  8020e7:	e8 93 fb ff ff       	call   801c7f <syscall>
  8020ec:	83 c4 18             	add    $0x18,%esp
  8020ef:	a3 60 c0 81 00       	mov    %eax,0x81c060
	return uheapPlaceStrategy ;
  8020f4:	a1 60 c0 81 00       	mov    0x81c060,%eax
}
  8020f9:	c9                   	leave  
  8020fa:	c3                   	ret    

008020fb <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8020fb:	55                   	push   %ebp
  8020fc:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8020fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802101:	a3 60 c0 81 00       	mov    %eax,0x81c060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802106:	6a 00                	push   $0x0
  802108:	6a 00                	push   $0x0
  80210a:	6a 00                	push   $0x0
  80210c:	6a 00                	push   $0x0
  80210e:	ff 75 08             	pushl  0x8(%ebp)
  802111:	6a 26                	push   $0x26
  802113:	e8 67 fb ff ff       	call   801c7f <syscall>
  802118:	83 c4 18             	add    $0x18,%esp
	return ;
  80211b:	90                   	nop
}
  80211c:	c9                   	leave  
  80211d:	c3                   	ret    

0080211e <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80211e:	55                   	push   %ebp
  80211f:	89 e5                	mov    %esp,%ebp
  802121:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802122:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802125:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802128:	8b 55 0c             	mov    0xc(%ebp),%edx
  80212b:	8b 45 08             	mov    0x8(%ebp),%eax
  80212e:	6a 00                	push   $0x0
  802130:	53                   	push   %ebx
  802131:	51                   	push   %ecx
  802132:	52                   	push   %edx
  802133:	50                   	push   %eax
  802134:	6a 27                	push   $0x27
  802136:	e8 44 fb ff ff       	call   801c7f <syscall>
  80213b:	83 c4 18             	add    $0x18,%esp
}
  80213e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802141:	c9                   	leave  
  802142:	c3                   	ret    

00802143 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802143:	55                   	push   %ebp
  802144:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802146:	8b 55 0c             	mov    0xc(%ebp),%edx
  802149:	8b 45 08             	mov    0x8(%ebp),%eax
  80214c:	6a 00                	push   $0x0
  80214e:	6a 00                	push   $0x0
  802150:	6a 00                	push   $0x0
  802152:	52                   	push   %edx
  802153:	50                   	push   %eax
  802154:	6a 28                	push   $0x28
  802156:	e8 24 fb ff ff       	call   801c7f <syscall>
  80215b:	83 c4 18             	add    $0x18,%esp
}
  80215e:	c9                   	leave  
  80215f:	c3                   	ret    

00802160 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802160:	55                   	push   %ebp
  802161:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802163:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802166:	8b 55 0c             	mov    0xc(%ebp),%edx
  802169:	8b 45 08             	mov    0x8(%ebp),%eax
  80216c:	6a 00                	push   $0x0
  80216e:	51                   	push   %ecx
  80216f:	ff 75 10             	pushl  0x10(%ebp)
  802172:	52                   	push   %edx
  802173:	50                   	push   %eax
  802174:	6a 29                	push   $0x29
  802176:	e8 04 fb ff ff       	call   801c7f <syscall>
  80217b:	83 c4 18             	add    $0x18,%esp
}
  80217e:	c9                   	leave  
  80217f:	c3                   	ret    

00802180 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802180:	55                   	push   %ebp
  802181:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802183:	6a 00                	push   $0x0
  802185:	6a 00                	push   $0x0
  802187:	ff 75 10             	pushl  0x10(%ebp)
  80218a:	ff 75 0c             	pushl  0xc(%ebp)
  80218d:	ff 75 08             	pushl  0x8(%ebp)
  802190:	6a 12                	push   $0x12
  802192:	e8 e8 fa ff ff       	call   801c7f <syscall>
  802197:	83 c4 18             	add    $0x18,%esp
	return ;
  80219a:	90                   	nop
}
  80219b:	c9                   	leave  
  80219c:	c3                   	ret    

0080219d <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80219d:	55                   	push   %ebp
  80219e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8021a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a6:	6a 00                	push   $0x0
  8021a8:	6a 00                	push   $0x0
  8021aa:	6a 00                	push   $0x0
  8021ac:	52                   	push   %edx
  8021ad:	50                   	push   %eax
  8021ae:	6a 2a                	push   $0x2a
  8021b0:	e8 ca fa ff ff       	call   801c7f <syscall>
  8021b5:	83 c4 18             	add    $0x18,%esp
	return;
  8021b8:	90                   	nop
}
  8021b9:	c9                   	leave  
  8021ba:	c3                   	ret    

008021bb <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8021bb:	55                   	push   %ebp
  8021bc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8021be:	6a 00                	push   $0x0
  8021c0:	6a 00                	push   $0x0
  8021c2:	6a 00                	push   $0x0
  8021c4:	6a 00                	push   $0x0
  8021c6:	6a 00                	push   $0x0
  8021c8:	6a 2b                	push   $0x2b
  8021ca:	e8 b0 fa ff ff       	call   801c7f <syscall>
  8021cf:	83 c4 18             	add    $0x18,%esp
}
  8021d2:	c9                   	leave  
  8021d3:	c3                   	ret    

008021d4 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8021d4:	55                   	push   %ebp
  8021d5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8021d7:	6a 00                	push   $0x0
  8021d9:	6a 00                	push   $0x0
  8021db:	6a 00                	push   $0x0
  8021dd:	ff 75 0c             	pushl  0xc(%ebp)
  8021e0:	ff 75 08             	pushl  0x8(%ebp)
  8021e3:	6a 2d                	push   $0x2d
  8021e5:	e8 95 fa ff ff       	call   801c7f <syscall>
  8021ea:	83 c4 18             	add    $0x18,%esp
	return;
  8021ed:	90                   	nop
}
  8021ee:	c9                   	leave  
  8021ef:	c3                   	ret    

008021f0 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8021f0:	55                   	push   %ebp
  8021f1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8021f3:	6a 00                	push   $0x0
  8021f5:	6a 00                	push   $0x0
  8021f7:	6a 00                	push   $0x0
  8021f9:	ff 75 0c             	pushl  0xc(%ebp)
  8021fc:	ff 75 08             	pushl  0x8(%ebp)
  8021ff:	6a 2c                	push   $0x2c
  802201:	e8 79 fa ff ff       	call   801c7f <syscall>
  802206:	83 c4 18             	add    $0x18,%esp
	return ;
  802209:	90                   	nop
}
  80220a:	c9                   	leave  
  80220b:	c3                   	ret    

0080220c <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  80220c:	55                   	push   %ebp
  80220d:	89 e5                	mov    %esp,%ebp
  80220f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  802212:	83 ec 04             	sub    $0x4,%esp
  802215:	68 74 2f 80 00       	push   $0x802f74
  80221a:	68 25 01 00 00       	push   $0x125
  80221f:	68 a7 2f 80 00       	push   $0x802fa7
  802224:	e8 ec e6 ff ff       	call   800915 <_panic>

00802229 <to_page_va>:
//==================================================================================//
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  802229:	55                   	push   %ebp
  80222a:	89 e5                	mov    %esp,%ebp
  80222c:	83 ec 10             	sub    $0x10,%esp
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  80222f:	8b 45 08             	mov    0x8(%ebp),%eax
  802232:	ba 60 40 80 00       	mov    $0x804060,%edx
  802237:	29 d0                	sub    %edx,%eax
  802239:	c1 f8 02             	sar    $0x2,%eax
  80223c:	89 c2                	mov    %eax,%edx
  80223e:	89 d0                	mov    %edx,%eax
  802240:	c1 e0 02             	shl    $0x2,%eax
  802243:	01 d0                	add    %edx,%eax
  802245:	c1 e0 02             	shl    $0x2,%eax
  802248:	01 d0                	add    %edx,%eax
  80224a:	c1 e0 02             	shl    $0x2,%eax
  80224d:	01 d0                	add    %edx,%eax
  80224f:	89 c1                	mov    %eax,%ecx
  802251:	c1 e1 08             	shl    $0x8,%ecx
  802254:	01 c8                	add    %ecx,%eax
  802256:	89 c1                	mov    %eax,%ecx
  802258:	c1 e1 10             	shl    $0x10,%ecx
  80225b:	01 c8                	add    %ecx,%eax
  80225d:	01 c0                	add    %eax,%eax
  80225f:	01 d0                	add    %edx,%eax
  802261:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  802264:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802267:	c1 e0 0c             	shl    $0xc,%eax
  80226a:	89 c2                	mov    %eax,%edx
  80226c:	a1 64 c0 81 00       	mov    0x81c064,%eax
  802271:	01 d0                	add    %edx,%eax
}
  802273:	c9                   	leave  
  802274:	c3                   	ret    

00802275 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  802275:	55                   	push   %ebp
  802276:	89 e5                	mov    %esp,%ebp
  802278:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  80227b:	8b 45 08             	mov    0x8(%ebp),%eax
  80227e:	05 00 00 00 02       	add    $0x2000000,%eax
  802283:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802286:	73 16                	jae    80229e <initialize_dynamic_allocator+0x29>
  802288:	68 b8 2f 80 00       	push   $0x802fb8
  80228d:	68 de 2f 80 00       	push   $0x802fde
  802292:	6a 26                	push   $0x26
  802294:	68 f3 2f 80 00       	push   $0x802ff3
  802299:	e8 77 e6 ff ff       	call   800915 <_panic>
		is_initialized = 1;
  80229e:	c7 05 28 40 80 00 01 	movl   $0x1,0x804028
  8022a5:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	//Comment the following line
	panic("initialize_dynamic_allocator() Not implemented yet");
  8022a8:	83 ec 04             	sub    $0x4,%esp
  8022ab:	68 0c 30 80 00       	push   $0x80300c
  8022b0:	6a 2e                	push   $0x2e
  8022b2:	68 f3 2f 80 00       	push   $0x802ff3
  8022b7:	e8 59 e6 ff ff       	call   800915 <_panic>

008022bc <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  8022bc:	55                   	push   %ebp
  8022bd:	89 e5                	mov    %esp,%ebp
  8022bf:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	//Comment the following line
	panic("get_block_size() Not implemented yet");
  8022c2:	83 ec 04             	sub    $0x4,%esp
  8022c5:	68 40 30 80 00       	push   $0x803040
  8022ca:	6a 3a                	push   $0x3a
  8022cc:	68 f3 2f 80 00       	push   $0x802ff3
  8022d1:	e8 3f e6 ff ff       	call   800915 <_panic>

008022d6 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  8022d6:	55                   	push   %ebp
  8022d7:	89 e5                	mov    %esp,%ebp
  8022d9:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  8022dc:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8022e3:	76 16                	jbe    8022fb <alloc_block+0x25>
  8022e5:	68 68 30 80 00       	push   $0x803068
  8022ea:	68 de 2f 80 00       	push   $0x802fde
  8022ef:	6a 46                	push   $0x46
  8022f1:	68 f3 2f 80 00       	push   $0x802ff3
  8022f6:	e8 1a e6 ff ff       	call   800915 <_panic>
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	panic("alloc_block() Not implemented yet");
  8022fb:	83 ec 04             	sub    $0x4,%esp
  8022fe:	68 8c 30 80 00       	push   $0x80308c
  802303:	6a 4d                	push   $0x4d
  802305:	68 f3 2f 80 00       	push   $0x802ff3
  80230a:	e8 06 e6 ff ff       	call   800915 <_panic>

0080230f <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  80230f:	55                   	push   %ebp
  802310:	89 e5                	mov    %esp,%ebp
  802312:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  802315:	8b 55 08             	mov    0x8(%ebp),%edx
  802318:	a1 64 c0 81 00       	mov    0x81c064,%eax
  80231d:	39 c2                	cmp    %eax,%edx
  80231f:	72 0c                	jb     80232d <free_block+0x1e>
  802321:	8b 55 08             	mov    0x8(%ebp),%edx
  802324:	a1 40 40 80 00       	mov    0x804040,%eax
  802329:	39 c2                	cmp    %eax,%edx
  80232b:	72 16                	jb     802343 <free_block+0x34>
  80232d:	68 b0 30 80 00       	push   $0x8030b0
  802332:	68 de 2f 80 00       	push   $0x802fde
  802337:	6a 5b                	push   $0x5b
  802339:	68 f3 2f 80 00       	push   $0x802ff3
  80233e:	e8 d2 e5 ff ff       	call   800915 <_panic>
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	panic("free_block() Not implemented yet");
  802343:	83 ec 04             	sub    $0x4,%esp
  802346:	68 e8 30 80 00       	push   $0x8030e8
  80234b:	6a 63                	push   $0x63
  80234d:	68 f3 2f 80 00       	push   $0x802ff3
  802352:	e8 be e5 ff ff       	call   800915 <_panic>

00802357 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  802357:	55                   	push   %ebp
  802358:	89 e5                	mov    %esp,%ebp
  80235a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  80235d:	83 ec 04             	sub    $0x4,%esp
  802360:	68 0c 31 80 00       	push   $0x80310c
  802365:	6a 72                	push   $0x72
  802367:	68 f3 2f 80 00       	push   $0x802ff3
  80236c:	e8 a4 e5 ff ff       	call   800915 <_panic>
  802371:	66 90                	xchg   %ax,%ax
  802373:	90                   	nop

00802374 <__udivdi3>:
  802374:	55                   	push   %ebp
  802375:	57                   	push   %edi
  802376:	56                   	push   %esi
  802377:	53                   	push   %ebx
  802378:	83 ec 1c             	sub    $0x1c,%esp
  80237b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80237f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802383:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802387:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80238b:	89 ca                	mov    %ecx,%edx
  80238d:	89 f8                	mov    %edi,%eax
  80238f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802393:	85 f6                	test   %esi,%esi
  802395:	75 2d                	jne    8023c4 <__udivdi3+0x50>
  802397:	39 cf                	cmp    %ecx,%edi
  802399:	77 65                	ja     802400 <__udivdi3+0x8c>
  80239b:	89 fd                	mov    %edi,%ebp
  80239d:	85 ff                	test   %edi,%edi
  80239f:	75 0b                	jne    8023ac <__udivdi3+0x38>
  8023a1:	b8 01 00 00 00       	mov    $0x1,%eax
  8023a6:	31 d2                	xor    %edx,%edx
  8023a8:	f7 f7                	div    %edi
  8023aa:	89 c5                	mov    %eax,%ebp
  8023ac:	31 d2                	xor    %edx,%edx
  8023ae:	89 c8                	mov    %ecx,%eax
  8023b0:	f7 f5                	div    %ebp
  8023b2:	89 c1                	mov    %eax,%ecx
  8023b4:	89 d8                	mov    %ebx,%eax
  8023b6:	f7 f5                	div    %ebp
  8023b8:	89 cf                	mov    %ecx,%edi
  8023ba:	89 fa                	mov    %edi,%edx
  8023bc:	83 c4 1c             	add    $0x1c,%esp
  8023bf:	5b                   	pop    %ebx
  8023c0:	5e                   	pop    %esi
  8023c1:	5f                   	pop    %edi
  8023c2:	5d                   	pop    %ebp
  8023c3:	c3                   	ret    
  8023c4:	39 ce                	cmp    %ecx,%esi
  8023c6:	77 28                	ja     8023f0 <__udivdi3+0x7c>
  8023c8:	0f bd fe             	bsr    %esi,%edi
  8023cb:	83 f7 1f             	xor    $0x1f,%edi
  8023ce:	75 40                	jne    802410 <__udivdi3+0x9c>
  8023d0:	39 ce                	cmp    %ecx,%esi
  8023d2:	72 0a                	jb     8023de <__udivdi3+0x6a>
  8023d4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8023d8:	0f 87 9e 00 00 00    	ja     80247c <__udivdi3+0x108>
  8023de:	b8 01 00 00 00       	mov    $0x1,%eax
  8023e3:	89 fa                	mov    %edi,%edx
  8023e5:	83 c4 1c             	add    $0x1c,%esp
  8023e8:	5b                   	pop    %ebx
  8023e9:	5e                   	pop    %esi
  8023ea:	5f                   	pop    %edi
  8023eb:	5d                   	pop    %ebp
  8023ec:	c3                   	ret    
  8023ed:	8d 76 00             	lea    0x0(%esi),%esi
  8023f0:	31 ff                	xor    %edi,%edi
  8023f2:	31 c0                	xor    %eax,%eax
  8023f4:	89 fa                	mov    %edi,%edx
  8023f6:	83 c4 1c             	add    $0x1c,%esp
  8023f9:	5b                   	pop    %ebx
  8023fa:	5e                   	pop    %esi
  8023fb:	5f                   	pop    %edi
  8023fc:	5d                   	pop    %ebp
  8023fd:	c3                   	ret    
  8023fe:	66 90                	xchg   %ax,%ax
  802400:	89 d8                	mov    %ebx,%eax
  802402:	f7 f7                	div    %edi
  802404:	31 ff                	xor    %edi,%edi
  802406:	89 fa                	mov    %edi,%edx
  802408:	83 c4 1c             	add    $0x1c,%esp
  80240b:	5b                   	pop    %ebx
  80240c:	5e                   	pop    %esi
  80240d:	5f                   	pop    %edi
  80240e:	5d                   	pop    %ebp
  80240f:	c3                   	ret    
  802410:	bd 20 00 00 00       	mov    $0x20,%ebp
  802415:	89 eb                	mov    %ebp,%ebx
  802417:	29 fb                	sub    %edi,%ebx
  802419:	89 f9                	mov    %edi,%ecx
  80241b:	d3 e6                	shl    %cl,%esi
  80241d:	89 c5                	mov    %eax,%ebp
  80241f:	88 d9                	mov    %bl,%cl
  802421:	d3 ed                	shr    %cl,%ebp
  802423:	89 e9                	mov    %ebp,%ecx
  802425:	09 f1                	or     %esi,%ecx
  802427:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80242b:	89 f9                	mov    %edi,%ecx
  80242d:	d3 e0                	shl    %cl,%eax
  80242f:	89 c5                	mov    %eax,%ebp
  802431:	89 d6                	mov    %edx,%esi
  802433:	88 d9                	mov    %bl,%cl
  802435:	d3 ee                	shr    %cl,%esi
  802437:	89 f9                	mov    %edi,%ecx
  802439:	d3 e2                	shl    %cl,%edx
  80243b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80243f:	88 d9                	mov    %bl,%cl
  802441:	d3 e8                	shr    %cl,%eax
  802443:	09 c2                	or     %eax,%edx
  802445:	89 d0                	mov    %edx,%eax
  802447:	89 f2                	mov    %esi,%edx
  802449:	f7 74 24 0c          	divl   0xc(%esp)
  80244d:	89 d6                	mov    %edx,%esi
  80244f:	89 c3                	mov    %eax,%ebx
  802451:	f7 e5                	mul    %ebp
  802453:	39 d6                	cmp    %edx,%esi
  802455:	72 19                	jb     802470 <__udivdi3+0xfc>
  802457:	74 0b                	je     802464 <__udivdi3+0xf0>
  802459:	89 d8                	mov    %ebx,%eax
  80245b:	31 ff                	xor    %edi,%edi
  80245d:	e9 58 ff ff ff       	jmp    8023ba <__udivdi3+0x46>
  802462:	66 90                	xchg   %ax,%ax
  802464:	8b 54 24 08          	mov    0x8(%esp),%edx
  802468:	89 f9                	mov    %edi,%ecx
  80246a:	d3 e2                	shl    %cl,%edx
  80246c:	39 c2                	cmp    %eax,%edx
  80246e:	73 e9                	jae    802459 <__udivdi3+0xe5>
  802470:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802473:	31 ff                	xor    %edi,%edi
  802475:	e9 40 ff ff ff       	jmp    8023ba <__udivdi3+0x46>
  80247a:	66 90                	xchg   %ax,%ax
  80247c:	31 c0                	xor    %eax,%eax
  80247e:	e9 37 ff ff ff       	jmp    8023ba <__udivdi3+0x46>
  802483:	90                   	nop

00802484 <__umoddi3>:
  802484:	55                   	push   %ebp
  802485:	57                   	push   %edi
  802486:	56                   	push   %esi
  802487:	53                   	push   %ebx
  802488:	83 ec 1c             	sub    $0x1c,%esp
  80248b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80248f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802493:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802497:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80249b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80249f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8024a3:	89 f3                	mov    %esi,%ebx
  8024a5:	89 fa                	mov    %edi,%edx
  8024a7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8024ab:	89 34 24             	mov    %esi,(%esp)
  8024ae:	85 c0                	test   %eax,%eax
  8024b0:	75 1a                	jne    8024cc <__umoddi3+0x48>
  8024b2:	39 f7                	cmp    %esi,%edi
  8024b4:	0f 86 a2 00 00 00    	jbe    80255c <__umoddi3+0xd8>
  8024ba:	89 c8                	mov    %ecx,%eax
  8024bc:	89 f2                	mov    %esi,%edx
  8024be:	f7 f7                	div    %edi
  8024c0:	89 d0                	mov    %edx,%eax
  8024c2:	31 d2                	xor    %edx,%edx
  8024c4:	83 c4 1c             	add    $0x1c,%esp
  8024c7:	5b                   	pop    %ebx
  8024c8:	5e                   	pop    %esi
  8024c9:	5f                   	pop    %edi
  8024ca:	5d                   	pop    %ebp
  8024cb:	c3                   	ret    
  8024cc:	39 f0                	cmp    %esi,%eax
  8024ce:	0f 87 ac 00 00 00    	ja     802580 <__umoddi3+0xfc>
  8024d4:	0f bd e8             	bsr    %eax,%ebp
  8024d7:	83 f5 1f             	xor    $0x1f,%ebp
  8024da:	0f 84 ac 00 00 00    	je     80258c <__umoddi3+0x108>
  8024e0:	bf 20 00 00 00       	mov    $0x20,%edi
  8024e5:	29 ef                	sub    %ebp,%edi
  8024e7:	89 fe                	mov    %edi,%esi
  8024e9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8024ed:	89 e9                	mov    %ebp,%ecx
  8024ef:	d3 e0                	shl    %cl,%eax
  8024f1:	89 d7                	mov    %edx,%edi
  8024f3:	89 f1                	mov    %esi,%ecx
  8024f5:	d3 ef                	shr    %cl,%edi
  8024f7:	09 c7                	or     %eax,%edi
  8024f9:	89 e9                	mov    %ebp,%ecx
  8024fb:	d3 e2                	shl    %cl,%edx
  8024fd:	89 14 24             	mov    %edx,(%esp)
  802500:	89 d8                	mov    %ebx,%eax
  802502:	d3 e0                	shl    %cl,%eax
  802504:	89 c2                	mov    %eax,%edx
  802506:	8b 44 24 08          	mov    0x8(%esp),%eax
  80250a:	d3 e0                	shl    %cl,%eax
  80250c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802510:	8b 44 24 08          	mov    0x8(%esp),%eax
  802514:	89 f1                	mov    %esi,%ecx
  802516:	d3 e8                	shr    %cl,%eax
  802518:	09 d0                	or     %edx,%eax
  80251a:	d3 eb                	shr    %cl,%ebx
  80251c:	89 da                	mov    %ebx,%edx
  80251e:	f7 f7                	div    %edi
  802520:	89 d3                	mov    %edx,%ebx
  802522:	f7 24 24             	mull   (%esp)
  802525:	89 c6                	mov    %eax,%esi
  802527:	89 d1                	mov    %edx,%ecx
  802529:	39 d3                	cmp    %edx,%ebx
  80252b:	0f 82 87 00 00 00    	jb     8025b8 <__umoddi3+0x134>
  802531:	0f 84 91 00 00 00    	je     8025c8 <__umoddi3+0x144>
  802537:	8b 54 24 04          	mov    0x4(%esp),%edx
  80253b:	29 f2                	sub    %esi,%edx
  80253d:	19 cb                	sbb    %ecx,%ebx
  80253f:	89 d8                	mov    %ebx,%eax
  802541:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802545:	d3 e0                	shl    %cl,%eax
  802547:	89 e9                	mov    %ebp,%ecx
  802549:	d3 ea                	shr    %cl,%edx
  80254b:	09 d0                	or     %edx,%eax
  80254d:	89 e9                	mov    %ebp,%ecx
  80254f:	d3 eb                	shr    %cl,%ebx
  802551:	89 da                	mov    %ebx,%edx
  802553:	83 c4 1c             	add    $0x1c,%esp
  802556:	5b                   	pop    %ebx
  802557:	5e                   	pop    %esi
  802558:	5f                   	pop    %edi
  802559:	5d                   	pop    %ebp
  80255a:	c3                   	ret    
  80255b:	90                   	nop
  80255c:	89 fd                	mov    %edi,%ebp
  80255e:	85 ff                	test   %edi,%edi
  802560:	75 0b                	jne    80256d <__umoddi3+0xe9>
  802562:	b8 01 00 00 00       	mov    $0x1,%eax
  802567:	31 d2                	xor    %edx,%edx
  802569:	f7 f7                	div    %edi
  80256b:	89 c5                	mov    %eax,%ebp
  80256d:	89 f0                	mov    %esi,%eax
  80256f:	31 d2                	xor    %edx,%edx
  802571:	f7 f5                	div    %ebp
  802573:	89 c8                	mov    %ecx,%eax
  802575:	f7 f5                	div    %ebp
  802577:	89 d0                	mov    %edx,%eax
  802579:	e9 44 ff ff ff       	jmp    8024c2 <__umoddi3+0x3e>
  80257e:	66 90                	xchg   %ax,%ax
  802580:	89 c8                	mov    %ecx,%eax
  802582:	89 f2                	mov    %esi,%edx
  802584:	83 c4 1c             	add    $0x1c,%esp
  802587:	5b                   	pop    %ebx
  802588:	5e                   	pop    %esi
  802589:	5f                   	pop    %edi
  80258a:	5d                   	pop    %ebp
  80258b:	c3                   	ret    
  80258c:	3b 04 24             	cmp    (%esp),%eax
  80258f:	72 06                	jb     802597 <__umoddi3+0x113>
  802591:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802595:	77 0f                	ja     8025a6 <__umoddi3+0x122>
  802597:	89 f2                	mov    %esi,%edx
  802599:	29 f9                	sub    %edi,%ecx
  80259b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80259f:	89 14 24             	mov    %edx,(%esp)
  8025a2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8025a6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8025aa:	8b 14 24             	mov    (%esp),%edx
  8025ad:	83 c4 1c             	add    $0x1c,%esp
  8025b0:	5b                   	pop    %ebx
  8025b1:	5e                   	pop    %esi
  8025b2:	5f                   	pop    %edi
  8025b3:	5d                   	pop    %ebp
  8025b4:	c3                   	ret    
  8025b5:	8d 76 00             	lea    0x0(%esi),%esi
  8025b8:	2b 04 24             	sub    (%esp),%eax
  8025bb:	19 fa                	sbb    %edi,%edx
  8025bd:	89 d1                	mov    %edx,%ecx
  8025bf:	89 c6                	mov    %eax,%esi
  8025c1:	e9 71 ff ff ff       	jmp    802537 <__umoddi3+0xb3>
  8025c6:	66 90                	xchg   %ax,%ax
  8025c8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8025cc:	72 ea                	jb     8025b8 <__umoddi3+0x134>
  8025ce:	89 d9                	mov    %ebx,%ecx
  8025d0:	e9 62 ff ff ff       	jmp    802537 <__umoddi3+0xb3>

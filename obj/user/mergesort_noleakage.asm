
obj/user/mergesort_noleakage:     file format elf32-i386


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
  800031:	e8 21 07 00 00       	call   800757 <libmain>
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

	do
	{
		//2012: lock the interrupt
		//sys_lock_cons();
		sys_lock_cons();
  800041:	e8 a2 1e 00 00       	call   801ee8 <sys_lock_cons>
		{
			cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 e0 27 80 00       	push   $0x8027e0
  80004e:	e8 82 0b 00 00       	call   800bd5 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 e2 27 80 00       	push   $0x8027e2
  80005e:	e8 72 0b 00 00       	call   800bd5 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!! MERGE SORT !!!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 f8 27 80 00       	push   $0x8027f8
  80006e:	e8 62 0b 00 00       	call   800bd5 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 e2 27 80 00       	push   $0x8027e2
  80007e:	e8 52 0b 00 00       	call   800bd5 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
			cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 e0 27 80 00       	push   $0x8027e0
  80008e:	e8 42 0b 00 00       	call   800bd5 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp
			readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 10 28 80 00       	push   $0x802810
  8000a5:	e8 04 12 00 00       	call   8012ae <readline>
  8000aa:	83 c4 10             	add    $0x10,%esp
			cprintf("Chose the initialization method:\n") ;
  8000ad:	83 ec 0c             	sub    $0xc,%esp
  8000b0:	68 30 28 80 00       	push   $0x802830
  8000b5:	e8 1b 0b 00 00       	call   800bd5 <cprintf>
  8000ba:	83 c4 10             	add    $0x10,%esp
			cprintf("a) Ascending\n") ;
  8000bd:	83 ec 0c             	sub    $0xc,%esp
  8000c0:	68 52 28 80 00       	push   $0x802852
  8000c5:	e8 0b 0b 00 00       	call   800bd5 <cprintf>
  8000ca:	83 c4 10             	add    $0x10,%esp
			cprintf("b) Descending\n") ;
  8000cd:	83 ec 0c             	sub    $0xc,%esp
  8000d0:	68 60 28 80 00       	push   $0x802860
  8000d5:	e8 fb 0a 00 00       	call   800bd5 <cprintf>
  8000da:	83 c4 10             	add    $0x10,%esp
			cprintf("c) Semi random\n");
  8000dd:	83 ec 0c             	sub    $0xc,%esp
  8000e0:	68 6f 28 80 00       	push   $0x80286f
  8000e5:	e8 eb 0a 00 00       	call   800bd5 <cprintf>
  8000ea:	83 c4 10             	add    $0x10,%esp
			do
			{
				cprintf("Select: ") ;
  8000ed:	83 ec 0c             	sub    $0xc,%esp
  8000f0:	68 7f 28 80 00       	push   $0x80287f
  8000f5:	e8 db 0a 00 00       	call   800bd5 <cprintf>
  8000fa:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  8000fd:	e8 38 06 00 00       	call   80073a <getchar>
  800102:	88 45 f7             	mov    %al,-0x9(%ebp)
				cputchar(Chose);
  800105:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800109:	83 ec 0c             	sub    $0xc,%esp
  80010c:	50                   	push   %eax
  80010d:	e8 09 06 00 00       	call   80071b <cputchar>
  800112:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  800115:	83 ec 0c             	sub    $0xc,%esp
  800118:	6a 0a                	push   $0xa
  80011a:	e8 fc 05 00 00       	call   80071b <cputchar>
  80011f:	83 c4 10             	add    $0x10,%esp
			} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800122:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  800126:	74 0c                	je     800134 <_main+0xfc>
  800128:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  80012c:	74 06                	je     800134 <_main+0xfc>
  80012e:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  800132:	75 b9                	jne    8000ed <_main+0xb5>
		}
		sys_unlock_cons();
  800134:	e8 c9 1d 00 00       	call   801f02 <sys_unlock_cons>
		//sys_unlock_cons();

		NumOfElements = strtol(Line, NULL, 10) ;
  800139:	83 ec 04             	sub    $0x4,%esp
  80013c:	6a 0a                	push   $0xa
  80013e:	6a 00                	push   $0x0
  800140:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  800146:	50                   	push   %eax
  800147:	e8 79 17 00 00       	call   8018c5 <strtol>
  80014c:	83 c4 10             	add    $0x10,%esp
  80014f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		Elements = malloc(sizeof(int) * NumOfElements) ;
  800152:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800155:	c1 e0 02             	shl    $0x2,%eax
  800158:	83 ec 0c             	sub    $0xc,%esp
  80015b:	50                   	push   %eax
  80015c:	e8 3e 1c 00 00       	call   801d9f <malloc>
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
  800183:	e8 ea 01 00 00       	call   800372 <InitializeAscending>
  800188:	83 c4 10             	add    $0x10,%esp
			break ;
  80018b:	eb 37                	jmp    8001c4 <_main+0x18c>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80018d:	83 ec 08             	sub    $0x8,%esp
  800190:	ff 75 f0             	pushl  -0x10(%ebp)
  800193:	ff 75 ec             	pushl  -0x14(%ebp)
  800196:	e8 08 02 00 00       	call   8003a3 <InitializeDescending>
  80019b:	83 c4 10             	add    $0x10,%esp
			break ;
  80019e:	eb 24                	jmp    8001c4 <_main+0x18c>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001a0:	83 ec 08             	sub    $0x8,%esp
  8001a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a6:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a9:	e8 2a 02 00 00       	call   8003d8 <InitializeSemiRandom>
  8001ae:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b1:	eb 11                	jmp    8001c4 <_main+0x18c>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001b9:	ff 75 ec             	pushl  -0x14(%ebp)
  8001bc:	e8 17 02 00 00       	call   8003d8 <InitializeSemiRandom>
  8001c1:	83 c4 10             	add    $0x10,%esp
		}

		MSort(Elements, 1, NumOfElements);
  8001c4:	83 ec 04             	sub    $0x4,%esp
  8001c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ca:	6a 01                	push   $0x1
  8001cc:	ff 75 ec             	pushl  -0x14(%ebp)
  8001cf:	e8 d6 02 00 00       	call   8004aa <MSort>
  8001d4:	83 c4 10             	add    $0x10,%esp

		atomic_cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001d7:	83 ec 0c             	sub    $0xc,%esp
  8001da:	68 88 28 80 00       	push   $0x802888
  8001df:	e8 63 0a 00 00       	call   800c47 <atomic_cprintf>
  8001e4:	83 c4 10             	add    $0x10,%esp
		//PrintElements(Elements, NumOfElements);

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001e7:	83 ec 08             	sub    $0x8,%esp
  8001ea:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ed:	ff 75 ec             	pushl  -0x14(%ebp)
  8001f0:	e8 d3 00 00 00       	call   8002c8 <CheckSorted>
  8001f5:	83 c4 10             	add    $0x10,%esp
  8001f8:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  8001fb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8001ff:	75 14                	jne    800215 <_main+0x1dd>
  800201:	83 ec 04             	sub    $0x4,%esp
  800204:	68 bc 28 80 00       	push   $0x8028bc
  800209:	6a 4d                	push   $0x4d
  80020b:	68 de 28 80 00       	push   $0x8028de
  800210:	e8 f2 06 00 00       	call   800907 <_panic>
		else
		{
			//sys_lock_cons();
			sys_lock_cons();
  800215:	e8 ce 1c 00 00       	call   801ee8 <sys_lock_cons>
			{
				cprintf("===============================================\n") ;
  80021a:	83 ec 0c             	sub    $0xc,%esp
  80021d:	68 fc 28 80 00       	push   $0x8028fc
  800222:	e8 ae 09 00 00       	call   800bd5 <cprintf>
  800227:	83 c4 10             	add    $0x10,%esp
				cprintf("Congratulations!! The array is sorted correctly\n") ;
  80022a:	83 ec 0c             	sub    $0xc,%esp
  80022d:	68 30 29 80 00       	push   $0x802930
  800232:	e8 9e 09 00 00       	call   800bd5 <cprintf>
  800237:	83 c4 10             	add    $0x10,%esp
				cprintf("===============================================\n\n") ;
  80023a:	83 ec 0c             	sub    $0xc,%esp
  80023d:	68 64 29 80 00       	push   $0x802964
  800242:	e8 8e 09 00 00       	call   800bd5 <cprintf>
  800247:	83 c4 10             	add    $0x10,%esp
			}
			sys_unlock_cons();
  80024a:	e8 b3 1c 00 00       	call   801f02 <sys_unlock_cons>
			//sys_unlock_cons();
		}

		free(Elements) ;
  80024f:	83 ec 0c             	sub    $0xc,%esp
  800252:	ff 75 ec             	pushl  -0x14(%ebp)
  800255:	e8 73 1b 00 00       	call   801dcd <free>
  80025a:	83 c4 10             	add    $0x10,%esp

		//sys_lock_cons();
		sys_lock_cons();
  80025d:	e8 86 1c 00 00       	call   801ee8 <sys_lock_cons>
		{
			Chose = 0 ;
  800262:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800266:	eb 42                	jmp    8002aa <_main+0x272>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800268:	83 ec 0c             	sub    $0xc,%esp
  80026b:	68 96 29 80 00       	push   $0x802996
  800270:	e8 60 09 00 00       	call   800bd5 <cprintf>
  800275:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  800278:	e8 bd 04 00 00       	call   80073a <getchar>
  80027d:	88 45 f7             	mov    %al,-0x9(%ebp)
				cputchar(Chose);
  800280:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800284:	83 ec 0c             	sub    $0xc,%esp
  800287:	50                   	push   %eax
  800288:	e8 8e 04 00 00       	call   80071b <cputchar>
  80028d:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  800290:	83 ec 0c             	sub    $0xc,%esp
  800293:	6a 0a                	push   $0xa
  800295:	e8 81 04 00 00       	call   80071b <cputchar>
  80029a:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  80029d:	83 ec 0c             	sub    $0xc,%esp
  8002a0:	6a 0a                	push   $0xa
  8002a2:	e8 74 04 00 00       	call   80071b <cputchar>
  8002a7:	83 c4 10             	add    $0x10,%esp

		//sys_lock_cons();
		sys_lock_cons();
		{
			Chose = 0 ;
			while (Chose != 'y' && Chose != 'n')
  8002aa:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002ae:	74 06                	je     8002b6 <_main+0x27e>
  8002b0:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  8002b4:	75 b2                	jne    800268 <_main+0x230>
				cputchar(Chose);
				cputchar('\n');
				cputchar('\n');
			}
		}
		sys_unlock_cons();
  8002b6:	e8 47 1c 00 00       	call   801f02 <sys_unlock_cons>
		//sys_unlock_cons();

	} while (Chose == 'y');
  8002bb:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002bf:	0f 84 7c fd ff ff    	je     800041 <_main+0x9>

}
  8002c5:	90                   	nop
  8002c6:	c9                   	leave  
  8002c7:	c3                   	ret    

008002c8 <CheckSorted>:


uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8002c8:	55                   	push   %ebp
  8002c9:	89 e5                	mov    %esp,%ebp
  8002cb:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8002ce:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8002d5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8002dc:	eb 33                	jmp    800311 <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8002de:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002e1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8002eb:	01 d0                	add    %edx,%eax
  8002ed:	8b 10                	mov    (%eax),%edx
  8002ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002f2:	40                   	inc    %eax
  8002f3:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8002fd:	01 c8                	add    %ecx,%eax
  8002ff:	8b 00                	mov    (%eax),%eax
  800301:	39 c2                	cmp    %eax,%edx
  800303:	7e 09                	jle    80030e <CheckSorted+0x46>
		{
			Sorted = 0 ;
  800305:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  80030c:	eb 0c                	jmp    80031a <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  80030e:	ff 45 f8             	incl   -0x8(%ebp)
  800311:	8b 45 0c             	mov    0xc(%ebp),%eax
  800314:	48                   	dec    %eax
  800315:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800318:	7f c4                	jg     8002de <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  80031a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80031d:	c9                   	leave  
  80031e:	c3                   	ret    

0080031f <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  80031f:	55                   	push   %ebp
  800320:	89 e5                	mov    %esp,%ebp
  800322:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800325:	8b 45 0c             	mov    0xc(%ebp),%eax
  800328:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80032f:	8b 45 08             	mov    0x8(%ebp),%eax
  800332:	01 d0                	add    %edx,%eax
  800334:	8b 00                	mov    (%eax),%eax
  800336:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800339:	8b 45 0c             	mov    0xc(%ebp),%eax
  80033c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800343:	8b 45 08             	mov    0x8(%ebp),%eax
  800346:	01 c2                	add    %eax,%edx
  800348:	8b 45 10             	mov    0x10(%ebp),%eax
  80034b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800352:	8b 45 08             	mov    0x8(%ebp),%eax
  800355:	01 c8                	add    %ecx,%eax
  800357:	8b 00                	mov    (%eax),%eax
  800359:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  80035b:	8b 45 10             	mov    0x10(%ebp),%eax
  80035e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800365:	8b 45 08             	mov    0x8(%ebp),%eax
  800368:	01 c2                	add    %eax,%edx
  80036a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80036d:	89 02                	mov    %eax,(%edx)
}
  80036f:	90                   	nop
  800370:	c9                   	leave  
  800371:	c3                   	ret    

00800372 <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  800372:	55                   	push   %ebp
  800373:	89 e5                	mov    %esp,%ebp
  800375:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800378:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80037f:	eb 17                	jmp    800398 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  800381:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800384:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80038b:	8b 45 08             	mov    0x8(%ebp),%eax
  80038e:	01 c2                	add    %eax,%edx
  800390:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800393:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800395:	ff 45 fc             	incl   -0x4(%ebp)
  800398:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80039b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80039e:	7c e1                	jl     800381 <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8003a0:	90                   	nop
  8003a1:	c9                   	leave  
  8003a2:	c3                   	ret    

008003a3 <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  8003a3:	55                   	push   %ebp
  8003a4:	89 e5                	mov    %esp,%ebp
  8003a6:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003b0:	eb 1b                	jmp    8003cd <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8003b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003b5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bf:	01 c2                	add    %eax,%edx
  8003c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003c4:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8003c7:	48                   	dec    %eax
  8003c8:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003ca:	ff 45 fc             	incl   -0x4(%ebp)
  8003cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003d0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003d3:	7c dd                	jl     8003b2 <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8003d5:	90                   	nop
  8003d6:	c9                   	leave  
  8003d7:	c3                   	ret    

008003d8 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8003d8:	55                   	push   %ebp
  8003d9:	89 e5                	mov    %esp,%ebp
  8003db:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8003de:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003e1:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8003e6:	f7 e9                	imul   %ecx
  8003e8:	c1 f9 1f             	sar    $0x1f,%ecx
  8003eb:	89 d0                	mov    %edx,%eax
  8003ed:	29 c8                	sub    %ecx,%eax
  8003ef:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8003f2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003f9:	eb 1e                	jmp    800419 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  8003fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003fe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800405:	8b 45 08             	mov    0x8(%ebp),%eax
  800408:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80040b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80040e:	99                   	cltd   
  80040f:	f7 7d f8             	idivl  -0x8(%ebp)
  800412:	89 d0                	mov    %edx,%eax
  800414:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800416:	ff 45 fc             	incl   -0x4(%ebp)
  800419:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80041c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80041f:	7c da                	jl     8003fb <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
		//cprintf("i=%d\n",i);
	}

}
  800421:	90                   	nop
  800422:	c9                   	leave  
  800423:	c3                   	ret    

00800424 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  800424:	55                   	push   %ebp
  800425:	89 e5                	mov    %esp,%ebp
  800427:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  80042a:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800431:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800438:	eb 42                	jmp    80047c <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  80043a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80043d:	99                   	cltd   
  80043e:	f7 7d f0             	idivl  -0x10(%ebp)
  800441:	89 d0                	mov    %edx,%eax
  800443:	85 c0                	test   %eax,%eax
  800445:	75 10                	jne    800457 <PrintElements+0x33>
			cprintf("\n");
  800447:	83 ec 0c             	sub    $0xc,%esp
  80044a:	68 e0 27 80 00       	push   $0x8027e0
  80044f:	e8 81 07 00 00       	call   800bd5 <cprintf>
  800454:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800457:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80045a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800461:	8b 45 08             	mov    0x8(%ebp),%eax
  800464:	01 d0                	add    %edx,%eax
  800466:	8b 00                	mov    (%eax),%eax
  800468:	83 ec 08             	sub    $0x8,%esp
  80046b:	50                   	push   %eax
  80046c:	68 b4 29 80 00       	push   $0x8029b4
  800471:	e8 5f 07 00 00       	call   800bd5 <cprintf>
  800476:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800479:	ff 45 f4             	incl   -0xc(%ebp)
  80047c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80047f:	48                   	dec    %eax
  800480:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800483:	7f b5                	jg     80043a <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  800485:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800488:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80048f:	8b 45 08             	mov    0x8(%ebp),%eax
  800492:	01 d0                	add    %edx,%eax
  800494:	8b 00                	mov    (%eax),%eax
  800496:	83 ec 08             	sub    $0x8,%esp
  800499:	50                   	push   %eax
  80049a:	68 b9 29 80 00       	push   $0x8029b9
  80049f:	e8 31 07 00 00       	call   800bd5 <cprintf>
  8004a4:	83 c4 10             	add    $0x10,%esp

}
  8004a7:	90                   	nop
  8004a8:	c9                   	leave  
  8004a9:	c3                   	ret    

008004aa <MSort>:


void MSort(int* A, int p, int r)
{
  8004aa:	55                   	push   %ebp
  8004ab:	89 e5                	mov    %esp,%ebp
  8004ad:	83 ec 18             	sub    $0x18,%esp
	if (p >= r)
  8004b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b3:	3b 45 10             	cmp    0x10(%ebp),%eax
  8004b6:	7d 54                	jge    80050c <MSort+0x62>
	{
		return;
	}

	int q = (p + r) / 2;
  8004b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8004be:	01 d0                	add    %edx,%eax
  8004c0:	89 c2                	mov    %eax,%edx
  8004c2:	c1 ea 1f             	shr    $0x1f,%edx
  8004c5:	01 d0                	add    %edx,%eax
  8004c7:	d1 f8                	sar    %eax
  8004c9:	89 45 f4             	mov    %eax,-0xc(%ebp)

	MSort(A, p, q);
  8004cc:	83 ec 04             	sub    $0x4,%esp
  8004cf:	ff 75 f4             	pushl  -0xc(%ebp)
  8004d2:	ff 75 0c             	pushl  0xc(%ebp)
  8004d5:	ff 75 08             	pushl  0x8(%ebp)
  8004d8:	e8 cd ff ff ff       	call   8004aa <MSort>
  8004dd:	83 c4 10             	add    $0x10,%esp

	MSort(A, q + 1, r);
  8004e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004e3:	40                   	inc    %eax
  8004e4:	83 ec 04             	sub    $0x4,%esp
  8004e7:	ff 75 10             	pushl  0x10(%ebp)
  8004ea:	50                   	push   %eax
  8004eb:	ff 75 08             	pushl  0x8(%ebp)
  8004ee:	e8 b7 ff ff ff       	call   8004aa <MSort>
  8004f3:	83 c4 10             	add    $0x10,%esp

	Merge(A, p, q, r);
  8004f6:	ff 75 10             	pushl  0x10(%ebp)
  8004f9:	ff 75 f4             	pushl  -0xc(%ebp)
  8004fc:	ff 75 0c             	pushl  0xc(%ebp)
  8004ff:	ff 75 08             	pushl  0x8(%ebp)
  800502:	e8 08 00 00 00       	call   80050f <Merge>
  800507:	83 c4 10             	add    $0x10,%esp
  80050a:	eb 01                	jmp    80050d <MSort+0x63>

void MSort(int* A, int p, int r)
{
	if (p >= r)
	{
		return;
  80050c:	90                   	nop

	MSort(A, q + 1, r);

	Merge(A, p, q, r);

}
  80050d:	c9                   	leave  
  80050e:	c3                   	ret    

0080050f <Merge>:

void Merge(int* A, int p, int q, int r)
{
  80050f:	55                   	push   %ebp
  800510:	89 e5                	mov    %esp,%ebp
  800512:	83 ec 38             	sub    $0x38,%esp
	int leftCapacity = q - p + 1;
  800515:	8b 45 10             	mov    0x10(%ebp),%eax
  800518:	2b 45 0c             	sub    0xc(%ebp),%eax
  80051b:	40                   	inc    %eax
  80051c:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int rightCapacity = r - q;
  80051f:	8b 45 14             	mov    0x14(%ebp),%eax
  800522:	2b 45 10             	sub    0x10(%ebp),%eax
  800525:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int leftIndex = 0;
  800528:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int rightIndex = 0;
  80052f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	//cprintf("allocate LEFT\n");
	int* Left = malloc(sizeof(int) * leftCapacity);
  800536:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800539:	c1 e0 02             	shl    $0x2,%eax
  80053c:	83 ec 0c             	sub    $0xc,%esp
  80053f:	50                   	push   %eax
  800540:	e8 5a 18 00 00       	call   801d9f <malloc>
  800545:	83 c4 10             	add    $0x10,%esp
  800548:	89 45 d8             	mov    %eax,-0x28(%ebp)

	//cprintf("allocate RIGHT\n");
	int* Right = malloc(sizeof(int) * rightCapacity);
  80054b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80054e:	c1 e0 02             	shl    $0x2,%eax
  800551:	83 ec 0c             	sub    $0xc,%esp
  800554:	50                   	push   %eax
  800555:	e8 45 18 00 00       	call   801d9f <malloc>
  80055a:	83 c4 10             	add    $0x10,%esp
  80055d:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  800560:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800567:	eb 2f                	jmp    800598 <Merge+0x89>
	{
		Left[i] = A[p + i - 1];
  800569:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80056c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800573:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800576:	01 c2                	add    %eax,%edx
  800578:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80057b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80057e:	01 c8                	add    %ecx,%eax
  800580:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800585:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80058c:	8b 45 08             	mov    0x8(%ebp),%eax
  80058f:	01 c8                	add    %ecx,%eax
  800591:	8b 00                	mov    (%eax),%eax
  800593:	89 02                	mov    %eax,(%edx)

	//cprintf("allocate RIGHT\n");
	int* Right = malloc(sizeof(int) * rightCapacity);

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  800595:	ff 45 ec             	incl   -0x14(%ebp)
  800598:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80059b:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80059e:	7c c9                	jl     800569 <Merge+0x5a>
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8005a0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005a7:	eb 2a                	jmp    8005d3 <Merge+0xc4>
	{
		Right[j] = A[q + j];
  8005a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005ac:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005b3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005b6:	01 c2                	add    %eax,%edx
  8005b8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8005bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005be:	01 c8                	add    %ecx,%eax
  8005c0:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ca:	01 c8                	add    %ecx,%eax
  8005cc:	8b 00                	mov    (%eax),%eax
  8005ce:	89 02                	mov    %eax,(%edx)
	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8005d0:	ff 45 e8             	incl   -0x18(%ebp)
  8005d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005d6:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8005d9:	7c ce                	jl     8005a9 <Merge+0x9a>
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8005db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005e1:	e9 0a 01 00 00       	jmp    8006f0 <Merge+0x1e1>
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
  8005e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005e9:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005ec:	0f 8d 95 00 00 00    	jge    800687 <Merge+0x178>
  8005f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005f5:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8005f8:	0f 8d 89 00 00 00    	jge    800687 <Merge+0x178>
		{
			if (Left[leftIndex] < Right[rightIndex] )
  8005fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800601:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800608:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80060b:	01 d0                	add    %edx,%eax
  80060d:	8b 10                	mov    (%eax),%edx
  80060f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800612:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800619:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80061c:	01 c8                	add    %ecx,%eax
  80061e:	8b 00                	mov    (%eax),%eax
  800620:	39 c2                	cmp    %eax,%edx
  800622:	7d 33                	jge    800657 <Merge+0x148>
			{
				A[k - 1] = Left[leftIndex++];
  800624:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800627:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80062c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800633:	8b 45 08             	mov    0x8(%ebp),%eax
  800636:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800639:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80063c:	8d 50 01             	lea    0x1(%eax),%edx
  80063f:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800642:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800649:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80064c:	01 d0                	add    %edx,%eax
  80064e:	8b 00                	mov    (%eax),%eax
  800650:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800652:	e9 96 00 00 00       	jmp    8006ed <Merge+0x1de>
			{
				A[k - 1] = Left[leftIndex++];
			}
			else
			{
				A[k - 1] = Right[rightIndex++];
  800657:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80065a:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80065f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800666:	8b 45 08             	mov    0x8(%ebp),%eax
  800669:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80066c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80066f:	8d 50 01             	lea    0x1(%eax),%edx
  800672:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800675:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80067c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80067f:	01 d0                	add    %edx,%eax
  800681:	8b 00                	mov    (%eax),%eax
  800683:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800685:	eb 66                	jmp    8006ed <Merge+0x1de>
			else
			{
				A[k - 1] = Right[rightIndex++];
			}
		}
		else if (leftIndex < leftCapacity)
  800687:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80068a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80068d:	7d 30                	jge    8006bf <Merge+0x1b0>
		{
			A[k - 1] = Left[leftIndex++];
  80068f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800692:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800697:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80069e:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a1:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006a7:	8d 50 01             	lea    0x1(%eax),%edx
  8006aa:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8006ad:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006b4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006b7:	01 d0                	add    %edx,%eax
  8006b9:	8b 00                	mov    (%eax),%eax
  8006bb:	89 01                	mov    %eax,(%ecx)
  8006bd:	eb 2e                	jmp    8006ed <Merge+0x1de>
		}
		else
		{
			A[k - 1] = Right[rightIndex++];
  8006bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006c2:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8006c7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d1:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006d7:	8d 50 01             	lea    0x1(%eax),%edx
  8006da:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8006dd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006e4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006e7:	01 d0                	add    %edx,%eax
  8006e9:	8b 00                	mov    (%eax),%eax
  8006eb:	89 01                	mov    %eax,(%ecx)
	for (j = 0; j < rightCapacity; j++)
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8006ed:	ff 45 e4             	incl   -0x1c(%ebp)
  8006f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006f3:	3b 45 14             	cmp    0x14(%ebp),%eax
  8006f6:	0f 8e ea fe ff ff    	jle    8005e6 <Merge+0xd7>
			A[k - 1] = Right[rightIndex++];
		}
	}

	//cprintf("free LEFT\n");
	free(Left);
  8006fc:	83 ec 0c             	sub    $0xc,%esp
  8006ff:	ff 75 d8             	pushl  -0x28(%ebp)
  800702:	e8 c6 16 00 00       	call   801dcd <free>
  800707:	83 c4 10             	add    $0x10,%esp
	//cprintf("free RIGHT\n");
	free(Right);
  80070a:	83 ec 0c             	sub    $0xc,%esp
  80070d:	ff 75 d4             	pushl  -0x2c(%ebp)
  800710:	e8 b8 16 00 00       	call   801dcd <free>
  800715:	83 c4 10             	add    $0x10,%esp

}
  800718:	90                   	nop
  800719:	c9                   	leave  
  80071a:	c3                   	ret    

0080071b <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  80071b:	55                   	push   %ebp
  80071c:	89 e5                	mov    %esp,%ebp
  80071e:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  800721:	8b 45 08             	mov    0x8(%ebp),%eax
  800724:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800727:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80072b:	83 ec 0c             	sub    $0xc,%esp
  80072e:	50                   	push   %eax
  80072f:	e8 fc 18 00 00       	call   802030 <sys_cputc>
  800734:	83 c4 10             	add    $0x10,%esp
}
  800737:	90                   	nop
  800738:	c9                   	leave  
  800739:	c3                   	ret    

0080073a <getchar>:


int
getchar(void)
{
  80073a:	55                   	push   %ebp
  80073b:	89 e5                	mov    %esp,%ebp
  80073d:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  800740:	e8 8a 17 00 00       	call   801ecf <sys_cgetc>
  800745:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  800748:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80074b:	c9                   	leave  
  80074c:	c3                   	ret    

0080074d <iscons>:

int iscons(int fdnum)
{
  80074d:	55                   	push   %ebp
  80074e:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  800750:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800755:	5d                   	pop    %ebp
  800756:	c3                   	ret    

00800757 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800757:	55                   	push   %ebp
  800758:	89 e5                	mov    %esp,%ebp
  80075a:	57                   	push   %edi
  80075b:	56                   	push   %esi
  80075c:	53                   	push   %ebx
  80075d:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800760:	e8 fc 19 00 00       	call   802161 <sys_getenvindex>
  800765:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800768:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80076b:	89 d0                	mov    %edx,%eax
  80076d:	c1 e0 02             	shl    $0x2,%eax
  800770:	01 d0                	add    %edx,%eax
  800772:	c1 e0 03             	shl    $0x3,%eax
  800775:	01 d0                	add    %edx,%eax
  800777:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80077e:	01 d0                	add    %edx,%eax
  800780:	c1 e0 02             	shl    $0x2,%eax
  800783:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800788:	a3 24 40 80 00       	mov    %eax,0x804024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80078d:	a1 24 40 80 00       	mov    0x804024,%eax
  800792:	8a 40 20             	mov    0x20(%eax),%al
  800795:	84 c0                	test   %al,%al
  800797:	74 0d                	je     8007a6 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800799:	a1 24 40 80 00       	mov    0x804024,%eax
  80079e:	83 c0 20             	add    $0x20,%eax
  8007a1:	a3 04 40 80 00       	mov    %eax,0x804004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8007a6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8007aa:	7e 0a                	jle    8007b6 <libmain+0x5f>
		binaryname = argv[0];
  8007ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007af:	8b 00                	mov    (%eax),%eax
  8007b1:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	_main(argc, argv);
  8007b6:	83 ec 08             	sub    $0x8,%esp
  8007b9:	ff 75 0c             	pushl  0xc(%ebp)
  8007bc:	ff 75 08             	pushl  0x8(%ebp)
  8007bf:	e8 74 f8 ff ff       	call   800038 <_main>
  8007c4:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8007c7:	a1 00 40 80 00       	mov    0x804000,%eax
  8007cc:	85 c0                	test   %eax,%eax
  8007ce:	0f 84 01 01 00 00    	je     8008d5 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8007d4:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8007da:	bb b8 2a 80 00       	mov    $0x802ab8,%ebx
  8007df:	ba 0e 00 00 00       	mov    $0xe,%edx
  8007e4:	89 c7                	mov    %eax,%edi
  8007e6:	89 de                	mov    %ebx,%esi
  8007e8:	89 d1                	mov    %edx,%ecx
  8007ea:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8007ec:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8007ef:	b9 56 00 00 00       	mov    $0x56,%ecx
  8007f4:	b0 00                	mov    $0x0,%al
  8007f6:	89 d7                	mov    %edx,%edi
  8007f8:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8007fa:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800801:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800804:	83 ec 08             	sub    $0x8,%esp
  800807:	50                   	push   %eax
  800808:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80080e:	50                   	push   %eax
  80080f:	e8 83 1b 00 00       	call   802397 <sys_utilities>
  800814:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800817:	e8 cc 16 00 00       	call   801ee8 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80081c:	83 ec 0c             	sub    $0xc,%esp
  80081f:	68 d8 29 80 00       	push   $0x8029d8
  800824:	e8 ac 03 00 00       	call   800bd5 <cprintf>
  800829:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80082c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80082f:	85 c0                	test   %eax,%eax
  800831:	74 18                	je     80084b <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800833:	e8 7d 1b 00 00       	call   8023b5 <sys_get_optimal_num_faults>
  800838:	83 ec 08             	sub    $0x8,%esp
  80083b:	50                   	push   %eax
  80083c:	68 00 2a 80 00       	push   $0x802a00
  800841:	e8 8f 03 00 00       	call   800bd5 <cprintf>
  800846:	83 c4 10             	add    $0x10,%esp
  800849:	eb 59                	jmp    8008a4 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80084b:	a1 24 40 80 00       	mov    0x804024,%eax
  800850:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  800856:	a1 24 40 80 00       	mov    0x804024,%eax
  80085b:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  800861:	83 ec 04             	sub    $0x4,%esp
  800864:	52                   	push   %edx
  800865:	50                   	push   %eax
  800866:	68 24 2a 80 00       	push   $0x802a24
  80086b:	e8 65 03 00 00       	call   800bd5 <cprintf>
  800870:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800873:	a1 24 40 80 00       	mov    0x804024,%eax
  800878:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  80087e:	a1 24 40 80 00       	mov    0x804024,%eax
  800883:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  800889:	a1 24 40 80 00       	mov    0x804024,%eax
  80088e:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  800894:	51                   	push   %ecx
  800895:	52                   	push   %edx
  800896:	50                   	push   %eax
  800897:	68 4c 2a 80 00       	push   $0x802a4c
  80089c:	e8 34 03 00 00       	call   800bd5 <cprintf>
  8008a1:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8008a4:	a1 24 40 80 00       	mov    0x804024,%eax
  8008a9:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  8008af:	83 ec 08             	sub    $0x8,%esp
  8008b2:	50                   	push   %eax
  8008b3:	68 a4 2a 80 00       	push   $0x802aa4
  8008b8:	e8 18 03 00 00       	call   800bd5 <cprintf>
  8008bd:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8008c0:	83 ec 0c             	sub    $0xc,%esp
  8008c3:	68 d8 29 80 00       	push   $0x8029d8
  8008c8:	e8 08 03 00 00       	call   800bd5 <cprintf>
  8008cd:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8008d0:	e8 2d 16 00 00       	call   801f02 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8008d5:	e8 1f 00 00 00       	call   8008f9 <exit>
}
  8008da:	90                   	nop
  8008db:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008de:	5b                   	pop    %ebx
  8008df:	5e                   	pop    %esi
  8008e0:	5f                   	pop    %edi
  8008e1:	5d                   	pop    %ebp
  8008e2:	c3                   	ret    

008008e3 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8008e3:	55                   	push   %ebp
  8008e4:	89 e5                	mov    %esp,%ebp
  8008e6:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8008e9:	83 ec 0c             	sub    $0xc,%esp
  8008ec:	6a 00                	push   $0x0
  8008ee:	e8 3a 18 00 00       	call   80212d <sys_destroy_env>
  8008f3:	83 c4 10             	add    $0x10,%esp
}
  8008f6:	90                   	nop
  8008f7:	c9                   	leave  
  8008f8:	c3                   	ret    

008008f9 <exit>:

void
exit(void)
{
  8008f9:	55                   	push   %ebp
  8008fa:	89 e5                	mov    %esp,%ebp
  8008fc:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8008ff:	e8 8f 18 00 00       	call   802193 <sys_exit_env>
}
  800904:	90                   	nop
  800905:	c9                   	leave  
  800906:	c3                   	ret    

00800907 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800907:	55                   	push   %ebp
  800908:	89 e5                	mov    %esp,%ebp
  80090a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80090d:	8d 45 10             	lea    0x10(%ebp),%eax
  800910:	83 c0 04             	add    $0x4,%eax
  800913:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800916:	a1 18 c1 81 00       	mov    0x81c118,%eax
  80091b:	85 c0                	test   %eax,%eax
  80091d:	74 16                	je     800935 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80091f:	a1 18 c1 81 00       	mov    0x81c118,%eax
  800924:	83 ec 08             	sub    $0x8,%esp
  800927:	50                   	push   %eax
  800928:	68 1c 2b 80 00       	push   $0x802b1c
  80092d:	e8 a3 02 00 00       	call   800bd5 <cprintf>
  800932:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800935:	a1 04 40 80 00       	mov    0x804004,%eax
  80093a:	83 ec 0c             	sub    $0xc,%esp
  80093d:	ff 75 0c             	pushl  0xc(%ebp)
  800940:	ff 75 08             	pushl  0x8(%ebp)
  800943:	50                   	push   %eax
  800944:	68 24 2b 80 00       	push   $0x802b24
  800949:	6a 74                	push   $0x74
  80094b:	e8 b2 02 00 00       	call   800c02 <cprintf_colored>
  800950:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800953:	8b 45 10             	mov    0x10(%ebp),%eax
  800956:	83 ec 08             	sub    $0x8,%esp
  800959:	ff 75 f4             	pushl  -0xc(%ebp)
  80095c:	50                   	push   %eax
  80095d:	e8 04 02 00 00       	call   800b66 <vcprintf>
  800962:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800965:	83 ec 08             	sub    $0x8,%esp
  800968:	6a 00                	push   $0x0
  80096a:	68 4c 2b 80 00       	push   $0x802b4c
  80096f:	e8 f2 01 00 00       	call   800b66 <vcprintf>
  800974:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800977:	e8 7d ff ff ff       	call   8008f9 <exit>

	// should not return here
	while (1) ;
  80097c:	eb fe                	jmp    80097c <_panic+0x75>

0080097e <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80097e:	55                   	push   %ebp
  80097f:	89 e5                	mov    %esp,%ebp
  800981:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800984:	a1 24 40 80 00       	mov    0x804024,%eax
  800989:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80098f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800992:	39 c2                	cmp    %eax,%edx
  800994:	74 14                	je     8009aa <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800996:	83 ec 04             	sub    $0x4,%esp
  800999:	68 50 2b 80 00       	push   $0x802b50
  80099e:	6a 26                	push   $0x26
  8009a0:	68 9c 2b 80 00       	push   $0x802b9c
  8009a5:	e8 5d ff ff ff       	call   800907 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8009aa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8009b1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8009b8:	e9 c5 00 00 00       	jmp    800a82 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8009bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009c0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8009c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ca:	01 d0                	add    %edx,%eax
  8009cc:	8b 00                	mov    (%eax),%eax
  8009ce:	85 c0                	test   %eax,%eax
  8009d0:	75 08                	jne    8009da <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8009d2:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8009d5:	e9 a5 00 00 00       	jmp    800a7f <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8009da:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009e1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8009e8:	eb 69                	jmp    800a53 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8009ea:	a1 24 40 80 00       	mov    0x804024,%eax
  8009ef:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8009f5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009f8:	89 d0                	mov    %edx,%eax
  8009fa:	01 c0                	add    %eax,%eax
  8009fc:	01 d0                	add    %edx,%eax
  8009fe:	c1 e0 03             	shl    $0x3,%eax
  800a01:	01 c8                	add    %ecx,%eax
  800a03:	8a 40 04             	mov    0x4(%eax),%al
  800a06:	84 c0                	test   %al,%al
  800a08:	75 46                	jne    800a50 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a0a:	a1 24 40 80 00       	mov    0x804024,%eax
  800a0f:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800a15:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a18:	89 d0                	mov    %edx,%eax
  800a1a:	01 c0                	add    %eax,%eax
  800a1c:	01 d0                	add    %edx,%eax
  800a1e:	c1 e0 03             	shl    $0x3,%eax
  800a21:	01 c8                	add    %ecx,%eax
  800a23:	8b 00                	mov    (%eax),%eax
  800a25:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800a28:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800a2b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800a30:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800a32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a35:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3f:	01 c8                	add    %ecx,%eax
  800a41:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a43:	39 c2                	cmp    %eax,%edx
  800a45:	75 09                	jne    800a50 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800a47:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800a4e:	eb 15                	jmp    800a65 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a50:	ff 45 e8             	incl   -0x18(%ebp)
  800a53:	a1 24 40 80 00       	mov    0x804024,%eax
  800a58:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800a5e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a61:	39 c2                	cmp    %eax,%edx
  800a63:	77 85                	ja     8009ea <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800a65:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800a69:	75 14                	jne    800a7f <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800a6b:	83 ec 04             	sub    $0x4,%esp
  800a6e:	68 a8 2b 80 00       	push   $0x802ba8
  800a73:	6a 3a                	push   $0x3a
  800a75:	68 9c 2b 80 00       	push   $0x802b9c
  800a7a:	e8 88 fe ff ff       	call   800907 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800a7f:	ff 45 f0             	incl   -0x10(%ebp)
  800a82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a85:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800a88:	0f 8c 2f ff ff ff    	jl     8009bd <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800a8e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a95:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800a9c:	eb 26                	jmp    800ac4 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800a9e:	a1 24 40 80 00       	mov    0x804024,%eax
  800aa3:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800aa9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800aac:	89 d0                	mov    %edx,%eax
  800aae:	01 c0                	add    %eax,%eax
  800ab0:	01 d0                	add    %edx,%eax
  800ab2:	c1 e0 03             	shl    $0x3,%eax
  800ab5:	01 c8                	add    %ecx,%eax
  800ab7:	8a 40 04             	mov    0x4(%eax),%al
  800aba:	3c 01                	cmp    $0x1,%al
  800abc:	75 03                	jne    800ac1 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800abe:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800ac1:	ff 45 e0             	incl   -0x20(%ebp)
  800ac4:	a1 24 40 80 00       	mov    0x804024,%eax
  800ac9:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800acf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ad2:	39 c2                	cmp    %eax,%edx
  800ad4:	77 c8                	ja     800a9e <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800ad6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ad9:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800adc:	74 14                	je     800af2 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800ade:	83 ec 04             	sub    $0x4,%esp
  800ae1:	68 fc 2b 80 00       	push   $0x802bfc
  800ae6:	6a 44                	push   $0x44
  800ae8:	68 9c 2b 80 00       	push   $0x802b9c
  800aed:	e8 15 fe ff ff       	call   800907 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800af2:	90                   	nop
  800af3:	c9                   	leave  
  800af4:	c3                   	ret    

00800af5 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800af5:	55                   	push   %ebp
  800af6:	89 e5                	mov    %esp,%ebp
  800af8:	53                   	push   %ebx
  800af9:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800afc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aff:	8b 00                	mov    (%eax),%eax
  800b01:	8d 48 01             	lea    0x1(%eax),%ecx
  800b04:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b07:	89 0a                	mov    %ecx,(%edx)
  800b09:	8b 55 08             	mov    0x8(%ebp),%edx
  800b0c:	88 d1                	mov    %dl,%cl
  800b0e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b11:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800b15:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b18:	8b 00                	mov    (%eax),%eax
  800b1a:	3d ff 00 00 00       	cmp    $0xff,%eax
  800b1f:	75 30                	jne    800b51 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800b21:	8b 15 1c c1 81 00    	mov    0x81c11c,%edx
  800b27:	a0 44 40 80 00       	mov    0x804044,%al
  800b2c:	0f b6 c0             	movzbl %al,%eax
  800b2f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b32:	8b 09                	mov    (%ecx),%ecx
  800b34:	89 cb                	mov    %ecx,%ebx
  800b36:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b39:	83 c1 08             	add    $0x8,%ecx
  800b3c:	52                   	push   %edx
  800b3d:	50                   	push   %eax
  800b3e:	53                   	push   %ebx
  800b3f:	51                   	push   %ecx
  800b40:	e8 5f 13 00 00       	call   801ea4 <sys_cputs>
  800b45:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800b48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800b51:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b54:	8b 40 04             	mov    0x4(%eax),%eax
  800b57:	8d 50 01             	lea    0x1(%eax),%edx
  800b5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5d:	89 50 04             	mov    %edx,0x4(%eax)
}
  800b60:	90                   	nop
  800b61:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b64:	c9                   	leave  
  800b65:	c3                   	ret    

00800b66 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800b66:	55                   	push   %ebp
  800b67:	89 e5                	mov    %esp,%ebp
  800b69:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800b6f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800b76:	00 00 00 
	b.cnt = 0;
  800b79:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b80:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800b83:	ff 75 0c             	pushl  0xc(%ebp)
  800b86:	ff 75 08             	pushl  0x8(%ebp)
  800b89:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b8f:	50                   	push   %eax
  800b90:	68 f5 0a 80 00       	push   $0x800af5
  800b95:	e8 5a 02 00 00       	call   800df4 <vprintfmt>
  800b9a:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800b9d:	8b 15 1c c1 81 00    	mov    0x81c11c,%edx
  800ba3:	a0 44 40 80 00       	mov    0x804044,%al
  800ba8:	0f b6 c0             	movzbl %al,%eax
  800bab:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800bb1:	52                   	push   %edx
  800bb2:	50                   	push   %eax
  800bb3:	51                   	push   %ecx
  800bb4:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800bba:	83 c0 08             	add    $0x8,%eax
  800bbd:	50                   	push   %eax
  800bbe:	e8 e1 12 00 00       	call   801ea4 <sys_cputs>
  800bc3:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800bc6:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
	return b.cnt;
  800bcd:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800bd3:	c9                   	leave  
  800bd4:	c3                   	ret    

00800bd5 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800bd5:	55                   	push   %ebp
  800bd6:	89 e5                	mov    %esp,%ebp
  800bd8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800bdb:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	va_start(ap, fmt);
  800be2:	8d 45 0c             	lea    0xc(%ebp),%eax
  800be5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800be8:	8b 45 08             	mov    0x8(%ebp),%eax
  800beb:	83 ec 08             	sub    $0x8,%esp
  800bee:	ff 75 f4             	pushl  -0xc(%ebp)
  800bf1:	50                   	push   %eax
  800bf2:	e8 6f ff ff ff       	call   800b66 <vcprintf>
  800bf7:	83 c4 10             	add    $0x10,%esp
  800bfa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800bfd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c00:	c9                   	leave  
  800c01:	c3                   	ret    

00800c02 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800c02:	55                   	push   %ebp
  800c03:	89 e5                	mov    %esp,%ebp
  800c05:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800c08:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c12:	c1 e0 08             	shl    $0x8,%eax
  800c15:	a3 1c c1 81 00       	mov    %eax,0x81c11c
	va_start(ap, fmt);
  800c1a:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c1d:	83 c0 04             	add    $0x4,%eax
  800c20:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800c23:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c26:	83 ec 08             	sub    $0x8,%esp
  800c29:	ff 75 f4             	pushl  -0xc(%ebp)
  800c2c:	50                   	push   %eax
  800c2d:	e8 34 ff ff ff       	call   800b66 <vcprintf>
  800c32:	83 c4 10             	add    $0x10,%esp
  800c35:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800c38:	c7 05 1c c1 81 00 00 	movl   $0x700,0x81c11c
  800c3f:	07 00 00 

	return cnt;
  800c42:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c45:	c9                   	leave  
  800c46:	c3                   	ret    

00800c47 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800c47:	55                   	push   %ebp
  800c48:	89 e5                	mov    %esp,%ebp
  800c4a:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800c4d:	e8 96 12 00 00       	call   801ee8 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800c52:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c55:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800c58:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5b:	83 ec 08             	sub    $0x8,%esp
  800c5e:	ff 75 f4             	pushl  -0xc(%ebp)
  800c61:	50                   	push   %eax
  800c62:	e8 ff fe ff ff       	call   800b66 <vcprintf>
  800c67:	83 c4 10             	add    $0x10,%esp
  800c6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800c6d:	e8 90 12 00 00       	call   801f02 <sys_unlock_cons>
	return cnt;
  800c72:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c75:	c9                   	leave  
  800c76:	c3                   	ret    

00800c77 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800c77:	55                   	push   %ebp
  800c78:	89 e5                	mov    %esp,%ebp
  800c7a:	53                   	push   %ebx
  800c7b:	83 ec 14             	sub    $0x14,%esp
  800c7e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c81:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c84:	8b 45 14             	mov    0x14(%ebp),%eax
  800c87:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800c8a:	8b 45 18             	mov    0x18(%ebp),%eax
  800c8d:	ba 00 00 00 00       	mov    $0x0,%edx
  800c92:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c95:	77 55                	ja     800cec <printnum+0x75>
  800c97:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c9a:	72 05                	jb     800ca1 <printnum+0x2a>
  800c9c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800c9f:	77 4b                	ja     800cec <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800ca1:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800ca4:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800ca7:	8b 45 18             	mov    0x18(%ebp),%eax
  800caa:	ba 00 00 00 00       	mov    $0x0,%edx
  800caf:	52                   	push   %edx
  800cb0:	50                   	push   %eax
  800cb1:	ff 75 f4             	pushl  -0xc(%ebp)
  800cb4:	ff 75 f0             	pushl  -0x10(%ebp)
  800cb7:	e8 b0 18 00 00       	call   80256c <__udivdi3>
  800cbc:	83 c4 10             	add    $0x10,%esp
  800cbf:	83 ec 04             	sub    $0x4,%esp
  800cc2:	ff 75 20             	pushl  0x20(%ebp)
  800cc5:	53                   	push   %ebx
  800cc6:	ff 75 18             	pushl  0x18(%ebp)
  800cc9:	52                   	push   %edx
  800cca:	50                   	push   %eax
  800ccb:	ff 75 0c             	pushl  0xc(%ebp)
  800cce:	ff 75 08             	pushl  0x8(%ebp)
  800cd1:	e8 a1 ff ff ff       	call   800c77 <printnum>
  800cd6:	83 c4 20             	add    $0x20,%esp
  800cd9:	eb 1a                	jmp    800cf5 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800cdb:	83 ec 08             	sub    $0x8,%esp
  800cde:	ff 75 0c             	pushl  0xc(%ebp)
  800ce1:	ff 75 20             	pushl  0x20(%ebp)
  800ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce7:	ff d0                	call   *%eax
  800ce9:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800cec:	ff 4d 1c             	decl   0x1c(%ebp)
  800cef:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800cf3:	7f e6                	jg     800cdb <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800cf5:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800cf8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cfd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d00:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d03:	53                   	push   %ebx
  800d04:	51                   	push   %ecx
  800d05:	52                   	push   %edx
  800d06:	50                   	push   %eax
  800d07:	e8 70 19 00 00       	call   80267c <__umoddi3>
  800d0c:	83 c4 10             	add    $0x10,%esp
  800d0f:	05 74 2e 80 00       	add    $0x802e74,%eax
  800d14:	8a 00                	mov    (%eax),%al
  800d16:	0f be c0             	movsbl %al,%eax
  800d19:	83 ec 08             	sub    $0x8,%esp
  800d1c:	ff 75 0c             	pushl  0xc(%ebp)
  800d1f:	50                   	push   %eax
  800d20:	8b 45 08             	mov    0x8(%ebp),%eax
  800d23:	ff d0                	call   *%eax
  800d25:	83 c4 10             	add    $0x10,%esp
}
  800d28:	90                   	nop
  800d29:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800d2c:	c9                   	leave  
  800d2d:	c3                   	ret    

00800d2e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800d2e:	55                   	push   %ebp
  800d2f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d31:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d35:	7e 1c                	jle    800d53 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800d37:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3a:	8b 00                	mov    (%eax),%eax
  800d3c:	8d 50 08             	lea    0x8(%eax),%edx
  800d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d42:	89 10                	mov    %edx,(%eax)
  800d44:	8b 45 08             	mov    0x8(%ebp),%eax
  800d47:	8b 00                	mov    (%eax),%eax
  800d49:	83 e8 08             	sub    $0x8,%eax
  800d4c:	8b 50 04             	mov    0x4(%eax),%edx
  800d4f:	8b 00                	mov    (%eax),%eax
  800d51:	eb 40                	jmp    800d93 <getuint+0x65>
	else if (lflag)
  800d53:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d57:	74 1e                	je     800d77 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800d59:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5c:	8b 00                	mov    (%eax),%eax
  800d5e:	8d 50 04             	lea    0x4(%eax),%edx
  800d61:	8b 45 08             	mov    0x8(%ebp),%eax
  800d64:	89 10                	mov    %edx,(%eax)
  800d66:	8b 45 08             	mov    0x8(%ebp),%eax
  800d69:	8b 00                	mov    (%eax),%eax
  800d6b:	83 e8 04             	sub    $0x4,%eax
  800d6e:	8b 00                	mov    (%eax),%eax
  800d70:	ba 00 00 00 00       	mov    $0x0,%edx
  800d75:	eb 1c                	jmp    800d93 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800d77:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7a:	8b 00                	mov    (%eax),%eax
  800d7c:	8d 50 04             	lea    0x4(%eax),%edx
  800d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d82:	89 10                	mov    %edx,(%eax)
  800d84:	8b 45 08             	mov    0x8(%ebp),%eax
  800d87:	8b 00                	mov    (%eax),%eax
  800d89:	83 e8 04             	sub    $0x4,%eax
  800d8c:	8b 00                	mov    (%eax),%eax
  800d8e:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800d93:	5d                   	pop    %ebp
  800d94:	c3                   	ret    

00800d95 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800d95:	55                   	push   %ebp
  800d96:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d98:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d9c:	7e 1c                	jle    800dba <getint+0x25>
		return va_arg(*ap, long long);
  800d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800da1:	8b 00                	mov    (%eax),%eax
  800da3:	8d 50 08             	lea    0x8(%eax),%edx
  800da6:	8b 45 08             	mov    0x8(%ebp),%eax
  800da9:	89 10                	mov    %edx,(%eax)
  800dab:	8b 45 08             	mov    0x8(%ebp),%eax
  800dae:	8b 00                	mov    (%eax),%eax
  800db0:	83 e8 08             	sub    $0x8,%eax
  800db3:	8b 50 04             	mov    0x4(%eax),%edx
  800db6:	8b 00                	mov    (%eax),%eax
  800db8:	eb 38                	jmp    800df2 <getint+0x5d>
	else if (lflag)
  800dba:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dbe:	74 1a                	je     800dda <getint+0x45>
		return va_arg(*ap, long);
  800dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc3:	8b 00                	mov    (%eax),%eax
  800dc5:	8d 50 04             	lea    0x4(%eax),%edx
  800dc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcb:	89 10                	mov    %edx,(%eax)
  800dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd0:	8b 00                	mov    (%eax),%eax
  800dd2:	83 e8 04             	sub    $0x4,%eax
  800dd5:	8b 00                	mov    (%eax),%eax
  800dd7:	99                   	cltd   
  800dd8:	eb 18                	jmp    800df2 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800dda:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddd:	8b 00                	mov    (%eax),%eax
  800ddf:	8d 50 04             	lea    0x4(%eax),%edx
  800de2:	8b 45 08             	mov    0x8(%ebp),%eax
  800de5:	89 10                	mov    %edx,(%eax)
  800de7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dea:	8b 00                	mov    (%eax),%eax
  800dec:	83 e8 04             	sub    $0x4,%eax
  800def:	8b 00                	mov    (%eax),%eax
  800df1:	99                   	cltd   
}
  800df2:	5d                   	pop    %ebp
  800df3:	c3                   	ret    

00800df4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800df4:	55                   	push   %ebp
  800df5:	89 e5                	mov    %esp,%ebp
  800df7:	56                   	push   %esi
  800df8:	53                   	push   %ebx
  800df9:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800dfc:	eb 17                	jmp    800e15 <vprintfmt+0x21>
			if (ch == '\0')
  800dfe:	85 db                	test   %ebx,%ebx
  800e00:	0f 84 c1 03 00 00    	je     8011c7 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800e06:	83 ec 08             	sub    $0x8,%esp
  800e09:	ff 75 0c             	pushl  0xc(%ebp)
  800e0c:	53                   	push   %ebx
  800e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e10:	ff d0                	call   *%eax
  800e12:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e15:	8b 45 10             	mov    0x10(%ebp),%eax
  800e18:	8d 50 01             	lea    0x1(%eax),%edx
  800e1b:	89 55 10             	mov    %edx,0x10(%ebp)
  800e1e:	8a 00                	mov    (%eax),%al
  800e20:	0f b6 d8             	movzbl %al,%ebx
  800e23:	83 fb 25             	cmp    $0x25,%ebx
  800e26:	75 d6                	jne    800dfe <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800e28:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800e2c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800e33:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800e3a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800e41:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800e48:	8b 45 10             	mov    0x10(%ebp),%eax
  800e4b:	8d 50 01             	lea    0x1(%eax),%edx
  800e4e:	89 55 10             	mov    %edx,0x10(%ebp)
  800e51:	8a 00                	mov    (%eax),%al
  800e53:	0f b6 d8             	movzbl %al,%ebx
  800e56:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800e59:	83 f8 5b             	cmp    $0x5b,%eax
  800e5c:	0f 87 3d 03 00 00    	ja     80119f <vprintfmt+0x3ab>
  800e62:	8b 04 85 98 2e 80 00 	mov    0x802e98(,%eax,4),%eax
  800e69:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800e6b:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800e6f:	eb d7                	jmp    800e48 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800e71:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800e75:	eb d1                	jmp    800e48 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e77:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800e7e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800e81:	89 d0                	mov    %edx,%eax
  800e83:	c1 e0 02             	shl    $0x2,%eax
  800e86:	01 d0                	add    %edx,%eax
  800e88:	01 c0                	add    %eax,%eax
  800e8a:	01 d8                	add    %ebx,%eax
  800e8c:	83 e8 30             	sub    $0x30,%eax
  800e8f:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800e92:	8b 45 10             	mov    0x10(%ebp),%eax
  800e95:	8a 00                	mov    (%eax),%al
  800e97:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800e9a:	83 fb 2f             	cmp    $0x2f,%ebx
  800e9d:	7e 3e                	jle    800edd <vprintfmt+0xe9>
  800e9f:	83 fb 39             	cmp    $0x39,%ebx
  800ea2:	7f 39                	jg     800edd <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ea4:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ea7:	eb d5                	jmp    800e7e <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800ea9:	8b 45 14             	mov    0x14(%ebp),%eax
  800eac:	83 c0 04             	add    $0x4,%eax
  800eaf:	89 45 14             	mov    %eax,0x14(%ebp)
  800eb2:	8b 45 14             	mov    0x14(%ebp),%eax
  800eb5:	83 e8 04             	sub    $0x4,%eax
  800eb8:	8b 00                	mov    (%eax),%eax
  800eba:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800ebd:	eb 1f                	jmp    800ede <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800ebf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ec3:	79 83                	jns    800e48 <vprintfmt+0x54>
				width = 0;
  800ec5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800ecc:	e9 77 ff ff ff       	jmp    800e48 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800ed1:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800ed8:	e9 6b ff ff ff       	jmp    800e48 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800edd:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800ede:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ee2:	0f 89 60 ff ff ff    	jns    800e48 <vprintfmt+0x54>
				width = precision, precision = -1;
  800ee8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800eeb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800eee:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800ef5:	e9 4e ff ff ff       	jmp    800e48 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800efa:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800efd:	e9 46 ff ff ff       	jmp    800e48 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800f02:	8b 45 14             	mov    0x14(%ebp),%eax
  800f05:	83 c0 04             	add    $0x4,%eax
  800f08:	89 45 14             	mov    %eax,0x14(%ebp)
  800f0b:	8b 45 14             	mov    0x14(%ebp),%eax
  800f0e:	83 e8 04             	sub    $0x4,%eax
  800f11:	8b 00                	mov    (%eax),%eax
  800f13:	83 ec 08             	sub    $0x8,%esp
  800f16:	ff 75 0c             	pushl  0xc(%ebp)
  800f19:	50                   	push   %eax
  800f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1d:	ff d0                	call   *%eax
  800f1f:	83 c4 10             	add    $0x10,%esp
			break;
  800f22:	e9 9b 02 00 00       	jmp    8011c2 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800f27:	8b 45 14             	mov    0x14(%ebp),%eax
  800f2a:	83 c0 04             	add    $0x4,%eax
  800f2d:	89 45 14             	mov    %eax,0x14(%ebp)
  800f30:	8b 45 14             	mov    0x14(%ebp),%eax
  800f33:	83 e8 04             	sub    $0x4,%eax
  800f36:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800f38:	85 db                	test   %ebx,%ebx
  800f3a:	79 02                	jns    800f3e <vprintfmt+0x14a>
				err = -err;
  800f3c:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800f3e:	83 fb 64             	cmp    $0x64,%ebx
  800f41:	7f 0b                	jg     800f4e <vprintfmt+0x15a>
  800f43:	8b 34 9d e0 2c 80 00 	mov    0x802ce0(,%ebx,4),%esi
  800f4a:	85 f6                	test   %esi,%esi
  800f4c:	75 19                	jne    800f67 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800f4e:	53                   	push   %ebx
  800f4f:	68 85 2e 80 00       	push   $0x802e85
  800f54:	ff 75 0c             	pushl  0xc(%ebp)
  800f57:	ff 75 08             	pushl  0x8(%ebp)
  800f5a:	e8 70 02 00 00       	call   8011cf <printfmt>
  800f5f:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800f62:	e9 5b 02 00 00       	jmp    8011c2 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800f67:	56                   	push   %esi
  800f68:	68 8e 2e 80 00       	push   $0x802e8e
  800f6d:	ff 75 0c             	pushl  0xc(%ebp)
  800f70:	ff 75 08             	pushl  0x8(%ebp)
  800f73:	e8 57 02 00 00       	call   8011cf <printfmt>
  800f78:	83 c4 10             	add    $0x10,%esp
			break;
  800f7b:	e9 42 02 00 00       	jmp    8011c2 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800f80:	8b 45 14             	mov    0x14(%ebp),%eax
  800f83:	83 c0 04             	add    $0x4,%eax
  800f86:	89 45 14             	mov    %eax,0x14(%ebp)
  800f89:	8b 45 14             	mov    0x14(%ebp),%eax
  800f8c:	83 e8 04             	sub    $0x4,%eax
  800f8f:	8b 30                	mov    (%eax),%esi
  800f91:	85 f6                	test   %esi,%esi
  800f93:	75 05                	jne    800f9a <vprintfmt+0x1a6>
				p = "(null)";
  800f95:	be 91 2e 80 00       	mov    $0x802e91,%esi
			if (width > 0 && padc != '-')
  800f9a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f9e:	7e 6d                	jle    80100d <vprintfmt+0x219>
  800fa0:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800fa4:	74 67                	je     80100d <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800fa6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fa9:	83 ec 08             	sub    $0x8,%esp
  800fac:	50                   	push   %eax
  800fad:	56                   	push   %esi
  800fae:	e8 26 05 00 00       	call   8014d9 <strnlen>
  800fb3:	83 c4 10             	add    $0x10,%esp
  800fb6:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800fb9:	eb 16                	jmp    800fd1 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800fbb:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800fbf:	83 ec 08             	sub    $0x8,%esp
  800fc2:	ff 75 0c             	pushl  0xc(%ebp)
  800fc5:	50                   	push   %eax
  800fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc9:	ff d0                	call   *%eax
  800fcb:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800fce:	ff 4d e4             	decl   -0x1c(%ebp)
  800fd1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fd5:	7f e4                	jg     800fbb <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800fd7:	eb 34                	jmp    80100d <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800fd9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800fdd:	74 1c                	je     800ffb <vprintfmt+0x207>
  800fdf:	83 fb 1f             	cmp    $0x1f,%ebx
  800fe2:	7e 05                	jle    800fe9 <vprintfmt+0x1f5>
  800fe4:	83 fb 7e             	cmp    $0x7e,%ebx
  800fe7:	7e 12                	jle    800ffb <vprintfmt+0x207>
					putch('?', putdat);
  800fe9:	83 ec 08             	sub    $0x8,%esp
  800fec:	ff 75 0c             	pushl  0xc(%ebp)
  800fef:	6a 3f                	push   $0x3f
  800ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff4:	ff d0                	call   *%eax
  800ff6:	83 c4 10             	add    $0x10,%esp
  800ff9:	eb 0f                	jmp    80100a <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800ffb:	83 ec 08             	sub    $0x8,%esp
  800ffe:	ff 75 0c             	pushl  0xc(%ebp)
  801001:	53                   	push   %ebx
  801002:	8b 45 08             	mov    0x8(%ebp),%eax
  801005:	ff d0                	call   *%eax
  801007:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80100a:	ff 4d e4             	decl   -0x1c(%ebp)
  80100d:	89 f0                	mov    %esi,%eax
  80100f:	8d 70 01             	lea    0x1(%eax),%esi
  801012:	8a 00                	mov    (%eax),%al
  801014:	0f be d8             	movsbl %al,%ebx
  801017:	85 db                	test   %ebx,%ebx
  801019:	74 24                	je     80103f <vprintfmt+0x24b>
  80101b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80101f:	78 b8                	js     800fd9 <vprintfmt+0x1e5>
  801021:	ff 4d e0             	decl   -0x20(%ebp)
  801024:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801028:	79 af                	jns    800fd9 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80102a:	eb 13                	jmp    80103f <vprintfmt+0x24b>
				putch(' ', putdat);
  80102c:	83 ec 08             	sub    $0x8,%esp
  80102f:	ff 75 0c             	pushl  0xc(%ebp)
  801032:	6a 20                	push   $0x20
  801034:	8b 45 08             	mov    0x8(%ebp),%eax
  801037:	ff d0                	call   *%eax
  801039:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80103c:	ff 4d e4             	decl   -0x1c(%ebp)
  80103f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801043:	7f e7                	jg     80102c <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801045:	e9 78 01 00 00       	jmp    8011c2 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80104a:	83 ec 08             	sub    $0x8,%esp
  80104d:	ff 75 e8             	pushl  -0x18(%ebp)
  801050:	8d 45 14             	lea    0x14(%ebp),%eax
  801053:	50                   	push   %eax
  801054:	e8 3c fd ff ff       	call   800d95 <getint>
  801059:	83 c4 10             	add    $0x10,%esp
  80105c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80105f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801062:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801065:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801068:	85 d2                	test   %edx,%edx
  80106a:	79 23                	jns    80108f <vprintfmt+0x29b>
				putch('-', putdat);
  80106c:	83 ec 08             	sub    $0x8,%esp
  80106f:	ff 75 0c             	pushl  0xc(%ebp)
  801072:	6a 2d                	push   $0x2d
  801074:	8b 45 08             	mov    0x8(%ebp),%eax
  801077:	ff d0                	call   *%eax
  801079:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80107c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80107f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801082:	f7 d8                	neg    %eax
  801084:	83 d2 00             	adc    $0x0,%edx
  801087:	f7 da                	neg    %edx
  801089:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80108c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80108f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801096:	e9 bc 00 00 00       	jmp    801157 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80109b:	83 ec 08             	sub    $0x8,%esp
  80109e:	ff 75 e8             	pushl  -0x18(%ebp)
  8010a1:	8d 45 14             	lea    0x14(%ebp),%eax
  8010a4:	50                   	push   %eax
  8010a5:	e8 84 fc ff ff       	call   800d2e <getuint>
  8010aa:	83 c4 10             	add    $0x10,%esp
  8010ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010b0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8010b3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8010ba:	e9 98 00 00 00       	jmp    801157 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8010bf:	83 ec 08             	sub    $0x8,%esp
  8010c2:	ff 75 0c             	pushl  0xc(%ebp)
  8010c5:	6a 58                	push   $0x58
  8010c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ca:	ff d0                	call   *%eax
  8010cc:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8010cf:	83 ec 08             	sub    $0x8,%esp
  8010d2:	ff 75 0c             	pushl  0xc(%ebp)
  8010d5:	6a 58                	push   $0x58
  8010d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010da:	ff d0                	call   *%eax
  8010dc:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8010df:	83 ec 08             	sub    $0x8,%esp
  8010e2:	ff 75 0c             	pushl  0xc(%ebp)
  8010e5:	6a 58                	push   $0x58
  8010e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ea:	ff d0                	call   *%eax
  8010ec:	83 c4 10             	add    $0x10,%esp
			break;
  8010ef:	e9 ce 00 00 00       	jmp    8011c2 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8010f4:	83 ec 08             	sub    $0x8,%esp
  8010f7:	ff 75 0c             	pushl  0xc(%ebp)
  8010fa:	6a 30                	push   $0x30
  8010fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ff:	ff d0                	call   *%eax
  801101:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801104:	83 ec 08             	sub    $0x8,%esp
  801107:	ff 75 0c             	pushl  0xc(%ebp)
  80110a:	6a 78                	push   $0x78
  80110c:	8b 45 08             	mov    0x8(%ebp),%eax
  80110f:	ff d0                	call   *%eax
  801111:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801114:	8b 45 14             	mov    0x14(%ebp),%eax
  801117:	83 c0 04             	add    $0x4,%eax
  80111a:	89 45 14             	mov    %eax,0x14(%ebp)
  80111d:	8b 45 14             	mov    0x14(%ebp),%eax
  801120:	83 e8 04             	sub    $0x4,%eax
  801123:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801125:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801128:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80112f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801136:	eb 1f                	jmp    801157 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801138:	83 ec 08             	sub    $0x8,%esp
  80113b:	ff 75 e8             	pushl  -0x18(%ebp)
  80113e:	8d 45 14             	lea    0x14(%ebp),%eax
  801141:	50                   	push   %eax
  801142:	e8 e7 fb ff ff       	call   800d2e <getuint>
  801147:	83 c4 10             	add    $0x10,%esp
  80114a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80114d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801150:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801157:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80115b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80115e:	83 ec 04             	sub    $0x4,%esp
  801161:	52                   	push   %edx
  801162:	ff 75 e4             	pushl  -0x1c(%ebp)
  801165:	50                   	push   %eax
  801166:	ff 75 f4             	pushl  -0xc(%ebp)
  801169:	ff 75 f0             	pushl  -0x10(%ebp)
  80116c:	ff 75 0c             	pushl  0xc(%ebp)
  80116f:	ff 75 08             	pushl  0x8(%ebp)
  801172:	e8 00 fb ff ff       	call   800c77 <printnum>
  801177:	83 c4 20             	add    $0x20,%esp
			break;
  80117a:	eb 46                	jmp    8011c2 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80117c:	83 ec 08             	sub    $0x8,%esp
  80117f:	ff 75 0c             	pushl  0xc(%ebp)
  801182:	53                   	push   %ebx
  801183:	8b 45 08             	mov    0x8(%ebp),%eax
  801186:	ff d0                	call   *%eax
  801188:	83 c4 10             	add    $0x10,%esp
			break;
  80118b:	eb 35                	jmp    8011c2 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  80118d:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
			break;
  801194:	eb 2c                	jmp    8011c2 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  801196:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
			break;
  80119d:	eb 23                	jmp    8011c2 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80119f:	83 ec 08             	sub    $0x8,%esp
  8011a2:	ff 75 0c             	pushl  0xc(%ebp)
  8011a5:	6a 25                	push   $0x25
  8011a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011aa:	ff d0                	call   *%eax
  8011ac:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8011af:	ff 4d 10             	decl   0x10(%ebp)
  8011b2:	eb 03                	jmp    8011b7 <vprintfmt+0x3c3>
  8011b4:	ff 4d 10             	decl   0x10(%ebp)
  8011b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ba:	48                   	dec    %eax
  8011bb:	8a 00                	mov    (%eax),%al
  8011bd:	3c 25                	cmp    $0x25,%al
  8011bf:	75 f3                	jne    8011b4 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8011c1:	90                   	nop
		}
	}
  8011c2:	e9 35 fc ff ff       	jmp    800dfc <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8011c7:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8011c8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8011cb:	5b                   	pop    %ebx
  8011cc:	5e                   	pop    %esi
  8011cd:	5d                   	pop    %ebp
  8011ce:	c3                   	ret    

008011cf <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8011cf:	55                   	push   %ebp
  8011d0:	89 e5                	mov    %esp,%ebp
  8011d2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8011d5:	8d 45 10             	lea    0x10(%ebp),%eax
  8011d8:	83 c0 04             	add    $0x4,%eax
  8011db:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8011de:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e1:	ff 75 f4             	pushl  -0xc(%ebp)
  8011e4:	50                   	push   %eax
  8011e5:	ff 75 0c             	pushl  0xc(%ebp)
  8011e8:	ff 75 08             	pushl  0x8(%ebp)
  8011eb:	e8 04 fc ff ff       	call   800df4 <vprintfmt>
  8011f0:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8011f3:	90                   	nop
  8011f4:	c9                   	leave  
  8011f5:	c3                   	ret    

008011f6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8011f6:	55                   	push   %ebp
  8011f7:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8011f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fc:	8b 40 08             	mov    0x8(%eax),%eax
  8011ff:	8d 50 01             	lea    0x1(%eax),%edx
  801202:	8b 45 0c             	mov    0xc(%ebp),%eax
  801205:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801208:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120b:	8b 10                	mov    (%eax),%edx
  80120d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801210:	8b 40 04             	mov    0x4(%eax),%eax
  801213:	39 c2                	cmp    %eax,%edx
  801215:	73 12                	jae    801229 <sprintputch+0x33>
		*b->buf++ = ch;
  801217:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121a:	8b 00                	mov    (%eax),%eax
  80121c:	8d 48 01             	lea    0x1(%eax),%ecx
  80121f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801222:	89 0a                	mov    %ecx,(%edx)
  801224:	8b 55 08             	mov    0x8(%ebp),%edx
  801227:	88 10                	mov    %dl,(%eax)
}
  801229:	90                   	nop
  80122a:	5d                   	pop    %ebp
  80122b:	c3                   	ret    

0080122c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80122c:	55                   	push   %ebp
  80122d:	89 e5                	mov    %esp,%ebp
  80122f:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801232:	8b 45 08             	mov    0x8(%ebp),%eax
  801235:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801238:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80123e:	8b 45 08             	mov    0x8(%ebp),%eax
  801241:	01 d0                	add    %edx,%eax
  801243:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801246:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80124d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801251:	74 06                	je     801259 <vsnprintf+0x2d>
  801253:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801257:	7f 07                	jg     801260 <vsnprintf+0x34>
		return -E_INVAL;
  801259:	b8 03 00 00 00       	mov    $0x3,%eax
  80125e:	eb 20                	jmp    801280 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801260:	ff 75 14             	pushl  0x14(%ebp)
  801263:	ff 75 10             	pushl  0x10(%ebp)
  801266:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801269:	50                   	push   %eax
  80126a:	68 f6 11 80 00       	push   $0x8011f6
  80126f:	e8 80 fb ff ff       	call   800df4 <vprintfmt>
  801274:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801277:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80127a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80127d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801280:	c9                   	leave  
  801281:	c3                   	ret    

00801282 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801282:	55                   	push   %ebp
  801283:	89 e5                	mov    %esp,%ebp
  801285:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801288:	8d 45 10             	lea    0x10(%ebp),%eax
  80128b:	83 c0 04             	add    $0x4,%eax
  80128e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801291:	8b 45 10             	mov    0x10(%ebp),%eax
  801294:	ff 75 f4             	pushl  -0xc(%ebp)
  801297:	50                   	push   %eax
  801298:	ff 75 0c             	pushl  0xc(%ebp)
  80129b:	ff 75 08             	pushl  0x8(%ebp)
  80129e:	e8 89 ff ff ff       	call   80122c <vsnprintf>
  8012a3:	83 c4 10             	add    $0x10,%esp
  8012a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8012a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012ac:	c9                   	leave  
  8012ad:	c3                   	ret    

008012ae <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  8012ae:	55                   	push   %ebp
  8012af:	89 e5                	mov    %esp,%ebp
  8012b1:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  8012b4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012b8:	74 13                	je     8012cd <readline+0x1f>
		cprintf("%s", prompt);
  8012ba:	83 ec 08             	sub    $0x8,%esp
  8012bd:	ff 75 08             	pushl  0x8(%ebp)
  8012c0:	68 08 30 80 00       	push   $0x803008
  8012c5:	e8 0b f9 ff ff       	call   800bd5 <cprintf>
  8012ca:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8012cd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8012d4:	83 ec 0c             	sub    $0xc,%esp
  8012d7:	6a 00                	push   $0x0
  8012d9:	e8 6f f4 ff ff       	call   80074d <iscons>
  8012de:	83 c4 10             	add    $0x10,%esp
  8012e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8012e4:	e8 51 f4 ff ff       	call   80073a <getchar>
  8012e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8012ec:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8012f0:	79 22                	jns    801314 <readline+0x66>
			if (c != -E_EOF)
  8012f2:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8012f6:	0f 84 ad 00 00 00    	je     8013a9 <readline+0xfb>
				cprintf("read error: %e\n", c);
  8012fc:	83 ec 08             	sub    $0x8,%esp
  8012ff:	ff 75 ec             	pushl  -0x14(%ebp)
  801302:	68 0b 30 80 00       	push   $0x80300b
  801307:	e8 c9 f8 ff ff       	call   800bd5 <cprintf>
  80130c:	83 c4 10             	add    $0x10,%esp
			break;
  80130f:	e9 95 00 00 00       	jmp    8013a9 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801314:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801318:	7e 34                	jle    80134e <readline+0xa0>
  80131a:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801321:	7f 2b                	jg     80134e <readline+0xa0>
			if (echoing)
  801323:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801327:	74 0e                	je     801337 <readline+0x89>
				cputchar(c);
  801329:	83 ec 0c             	sub    $0xc,%esp
  80132c:	ff 75 ec             	pushl  -0x14(%ebp)
  80132f:	e8 e7 f3 ff ff       	call   80071b <cputchar>
  801334:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801337:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80133a:	8d 50 01             	lea    0x1(%eax),%edx
  80133d:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801340:	89 c2                	mov    %eax,%edx
  801342:	8b 45 0c             	mov    0xc(%ebp),%eax
  801345:	01 d0                	add    %edx,%eax
  801347:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80134a:	88 10                	mov    %dl,(%eax)
  80134c:	eb 56                	jmp    8013a4 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  80134e:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801352:	75 1f                	jne    801373 <readline+0xc5>
  801354:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801358:	7e 19                	jle    801373 <readline+0xc5>
			if (echoing)
  80135a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80135e:	74 0e                	je     80136e <readline+0xc0>
				cputchar(c);
  801360:	83 ec 0c             	sub    $0xc,%esp
  801363:	ff 75 ec             	pushl  -0x14(%ebp)
  801366:	e8 b0 f3 ff ff       	call   80071b <cputchar>
  80136b:	83 c4 10             	add    $0x10,%esp

			i--;
  80136e:	ff 4d f4             	decl   -0xc(%ebp)
  801371:	eb 31                	jmp    8013a4 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  801373:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801377:	74 0a                	je     801383 <readline+0xd5>
  801379:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  80137d:	0f 85 61 ff ff ff    	jne    8012e4 <readline+0x36>
			if (echoing)
  801383:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801387:	74 0e                	je     801397 <readline+0xe9>
				cputchar(c);
  801389:	83 ec 0c             	sub    $0xc,%esp
  80138c:	ff 75 ec             	pushl  -0x14(%ebp)
  80138f:	e8 87 f3 ff ff       	call   80071b <cputchar>
  801394:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  801397:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80139a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80139d:	01 d0                	add    %edx,%eax
  80139f:	c6 00 00             	movb   $0x0,(%eax)
			break;
  8013a2:	eb 06                	jmp    8013aa <readline+0xfc>
		}
	}
  8013a4:	e9 3b ff ff ff       	jmp    8012e4 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  8013a9:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  8013aa:	90                   	nop
  8013ab:	c9                   	leave  
  8013ac:	c3                   	ret    

008013ad <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  8013ad:	55                   	push   %ebp
  8013ae:	89 e5                	mov    %esp,%ebp
  8013b0:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  8013b3:	e8 30 0b 00 00       	call   801ee8 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  8013b8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013bc:	74 13                	je     8013d1 <atomic_readline+0x24>
			cprintf("%s", prompt);
  8013be:	83 ec 08             	sub    $0x8,%esp
  8013c1:	ff 75 08             	pushl  0x8(%ebp)
  8013c4:	68 08 30 80 00       	push   $0x803008
  8013c9:	e8 07 f8 ff ff       	call   800bd5 <cprintf>
  8013ce:	83 c4 10             	add    $0x10,%esp

		i = 0;
  8013d1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  8013d8:	83 ec 0c             	sub    $0xc,%esp
  8013db:	6a 00                	push   $0x0
  8013dd:	e8 6b f3 ff ff       	call   80074d <iscons>
  8013e2:	83 c4 10             	add    $0x10,%esp
  8013e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  8013e8:	e8 4d f3 ff ff       	call   80073a <getchar>
  8013ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  8013f0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8013f4:	79 22                	jns    801418 <atomic_readline+0x6b>
				if (c != -E_EOF)
  8013f6:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8013fa:	0f 84 ad 00 00 00    	je     8014ad <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  801400:	83 ec 08             	sub    $0x8,%esp
  801403:	ff 75 ec             	pushl  -0x14(%ebp)
  801406:	68 0b 30 80 00       	push   $0x80300b
  80140b:	e8 c5 f7 ff ff       	call   800bd5 <cprintf>
  801410:	83 c4 10             	add    $0x10,%esp
				break;
  801413:	e9 95 00 00 00       	jmp    8014ad <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  801418:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  80141c:	7e 34                	jle    801452 <atomic_readline+0xa5>
  80141e:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801425:	7f 2b                	jg     801452 <atomic_readline+0xa5>
				if (echoing)
  801427:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80142b:	74 0e                	je     80143b <atomic_readline+0x8e>
					cputchar(c);
  80142d:	83 ec 0c             	sub    $0xc,%esp
  801430:	ff 75 ec             	pushl  -0x14(%ebp)
  801433:	e8 e3 f2 ff ff       	call   80071b <cputchar>
  801438:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  80143b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80143e:	8d 50 01             	lea    0x1(%eax),%edx
  801441:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801444:	89 c2                	mov    %eax,%edx
  801446:	8b 45 0c             	mov    0xc(%ebp),%eax
  801449:	01 d0                	add    %edx,%eax
  80144b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80144e:	88 10                	mov    %dl,(%eax)
  801450:	eb 56                	jmp    8014a8 <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  801452:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801456:	75 1f                	jne    801477 <atomic_readline+0xca>
  801458:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80145c:	7e 19                	jle    801477 <atomic_readline+0xca>
				if (echoing)
  80145e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801462:	74 0e                	je     801472 <atomic_readline+0xc5>
					cputchar(c);
  801464:	83 ec 0c             	sub    $0xc,%esp
  801467:	ff 75 ec             	pushl  -0x14(%ebp)
  80146a:	e8 ac f2 ff ff       	call   80071b <cputchar>
  80146f:	83 c4 10             	add    $0x10,%esp
				i--;
  801472:	ff 4d f4             	decl   -0xc(%ebp)
  801475:	eb 31                	jmp    8014a8 <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  801477:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  80147b:	74 0a                	je     801487 <atomic_readline+0xda>
  80147d:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801481:	0f 85 61 ff ff ff    	jne    8013e8 <atomic_readline+0x3b>
				if (echoing)
  801487:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80148b:	74 0e                	je     80149b <atomic_readline+0xee>
					cputchar(c);
  80148d:	83 ec 0c             	sub    $0xc,%esp
  801490:	ff 75 ec             	pushl  -0x14(%ebp)
  801493:	e8 83 f2 ff ff       	call   80071b <cputchar>
  801498:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  80149b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80149e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a1:	01 d0                	add    %edx,%eax
  8014a3:	c6 00 00             	movb   $0x0,(%eax)
				break;
  8014a6:	eb 06                	jmp    8014ae <atomic_readline+0x101>
			}
		}
  8014a8:	e9 3b ff ff ff       	jmp    8013e8 <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  8014ad:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  8014ae:	e8 4f 0a 00 00       	call   801f02 <sys_unlock_cons>
}
  8014b3:	90                   	nop
  8014b4:	c9                   	leave  
  8014b5:	c3                   	ret    

008014b6 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8014b6:	55                   	push   %ebp
  8014b7:	89 e5                	mov    %esp,%ebp
  8014b9:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8014bc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014c3:	eb 06                	jmp    8014cb <strlen+0x15>
		n++;
  8014c5:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8014c8:	ff 45 08             	incl   0x8(%ebp)
  8014cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ce:	8a 00                	mov    (%eax),%al
  8014d0:	84 c0                	test   %al,%al
  8014d2:	75 f1                	jne    8014c5 <strlen+0xf>
		n++;
	return n;
  8014d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8014d7:	c9                   	leave  
  8014d8:	c3                   	ret    

008014d9 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8014d9:	55                   	push   %ebp
  8014da:	89 e5                	mov    %esp,%ebp
  8014dc:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8014df:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014e6:	eb 09                	jmp    8014f1 <strnlen+0x18>
		n++;
  8014e8:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8014eb:	ff 45 08             	incl   0x8(%ebp)
  8014ee:	ff 4d 0c             	decl   0xc(%ebp)
  8014f1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8014f5:	74 09                	je     801500 <strnlen+0x27>
  8014f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fa:	8a 00                	mov    (%eax),%al
  8014fc:	84 c0                	test   %al,%al
  8014fe:	75 e8                	jne    8014e8 <strnlen+0xf>
		n++;
	return n;
  801500:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801503:	c9                   	leave  
  801504:	c3                   	ret    

00801505 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801505:	55                   	push   %ebp
  801506:	89 e5                	mov    %esp,%ebp
  801508:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80150b:	8b 45 08             	mov    0x8(%ebp),%eax
  80150e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801511:	90                   	nop
  801512:	8b 45 08             	mov    0x8(%ebp),%eax
  801515:	8d 50 01             	lea    0x1(%eax),%edx
  801518:	89 55 08             	mov    %edx,0x8(%ebp)
  80151b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80151e:	8d 4a 01             	lea    0x1(%edx),%ecx
  801521:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801524:	8a 12                	mov    (%edx),%dl
  801526:	88 10                	mov    %dl,(%eax)
  801528:	8a 00                	mov    (%eax),%al
  80152a:	84 c0                	test   %al,%al
  80152c:	75 e4                	jne    801512 <strcpy+0xd>
		/* do nothing */;
	return ret;
  80152e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801531:	c9                   	leave  
  801532:	c3                   	ret    

00801533 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801533:	55                   	push   %ebp
  801534:	89 e5                	mov    %esp,%ebp
  801536:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801539:	8b 45 08             	mov    0x8(%ebp),%eax
  80153c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80153f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801546:	eb 1f                	jmp    801567 <strncpy+0x34>
		*dst++ = *src;
  801548:	8b 45 08             	mov    0x8(%ebp),%eax
  80154b:	8d 50 01             	lea    0x1(%eax),%edx
  80154e:	89 55 08             	mov    %edx,0x8(%ebp)
  801551:	8b 55 0c             	mov    0xc(%ebp),%edx
  801554:	8a 12                	mov    (%edx),%dl
  801556:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801558:	8b 45 0c             	mov    0xc(%ebp),%eax
  80155b:	8a 00                	mov    (%eax),%al
  80155d:	84 c0                	test   %al,%al
  80155f:	74 03                	je     801564 <strncpy+0x31>
			src++;
  801561:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801564:	ff 45 fc             	incl   -0x4(%ebp)
  801567:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80156a:	3b 45 10             	cmp    0x10(%ebp),%eax
  80156d:	72 d9                	jb     801548 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80156f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801572:	c9                   	leave  
  801573:	c3                   	ret    

00801574 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801574:	55                   	push   %ebp
  801575:	89 e5                	mov    %esp,%ebp
  801577:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80157a:	8b 45 08             	mov    0x8(%ebp),%eax
  80157d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801580:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801584:	74 30                	je     8015b6 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801586:	eb 16                	jmp    80159e <strlcpy+0x2a>
			*dst++ = *src++;
  801588:	8b 45 08             	mov    0x8(%ebp),%eax
  80158b:	8d 50 01             	lea    0x1(%eax),%edx
  80158e:	89 55 08             	mov    %edx,0x8(%ebp)
  801591:	8b 55 0c             	mov    0xc(%ebp),%edx
  801594:	8d 4a 01             	lea    0x1(%edx),%ecx
  801597:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80159a:	8a 12                	mov    (%edx),%dl
  80159c:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80159e:	ff 4d 10             	decl   0x10(%ebp)
  8015a1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015a5:	74 09                	je     8015b0 <strlcpy+0x3c>
  8015a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015aa:	8a 00                	mov    (%eax),%al
  8015ac:	84 c0                	test   %al,%al
  8015ae:	75 d8                	jne    801588 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8015b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b3:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8015b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8015b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015bc:	29 c2                	sub    %eax,%edx
  8015be:	89 d0                	mov    %edx,%eax
}
  8015c0:	c9                   	leave  
  8015c1:	c3                   	ret    

008015c2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8015c2:	55                   	push   %ebp
  8015c3:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8015c5:	eb 06                	jmp    8015cd <strcmp+0xb>
		p++, q++;
  8015c7:	ff 45 08             	incl   0x8(%ebp)
  8015ca:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8015cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d0:	8a 00                	mov    (%eax),%al
  8015d2:	84 c0                	test   %al,%al
  8015d4:	74 0e                	je     8015e4 <strcmp+0x22>
  8015d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d9:	8a 10                	mov    (%eax),%dl
  8015db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015de:	8a 00                	mov    (%eax),%al
  8015e0:	38 c2                	cmp    %al,%dl
  8015e2:	74 e3                	je     8015c7 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8015e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e7:	8a 00                	mov    (%eax),%al
  8015e9:	0f b6 d0             	movzbl %al,%edx
  8015ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ef:	8a 00                	mov    (%eax),%al
  8015f1:	0f b6 c0             	movzbl %al,%eax
  8015f4:	29 c2                	sub    %eax,%edx
  8015f6:	89 d0                	mov    %edx,%eax
}
  8015f8:	5d                   	pop    %ebp
  8015f9:	c3                   	ret    

008015fa <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8015fa:	55                   	push   %ebp
  8015fb:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8015fd:	eb 09                	jmp    801608 <strncmp+0xe>
		n--, p++, q++;
  8015ff:	ff 4d 10             	decl   0x10(%ebp)
  801602:	ff 45 08             	incl   0x8(%ebp)
  801605:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801608:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80160c:	74 17                	je     801625 <strncmp+0x2b>
  80160e:	8b 45 08             	mov    0x8(%ebp),%eax
  801611:	8a 00                	mov    (%eax),%al
  801613:	84 c0                	test   %al,%al
  801615:	74 0e                	je     801625 <strncmp+0x2b>
  801617:	8b 45 08             	mov    0x8(%ebp),%eax
  80161a:	8a 10                	mov    (%eax),%dl
  80161c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80161f:	8a 00                	mov    (%eax),%al
  801621:	38 c2                	cmp    %al,%dl
  801623:	74 da                	je     8015ff <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801625:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801629:	75 07                	jne    801632 <strncmp+0x38>
		return 0;
  80162b:	b8 00 00 00 00       	mov    $0x0,%eax
  801630:	eb 14                	jmp    801646 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801632:	8b 45 08             	mov    0x8(%ebp),%eax
  801635:	8a 00                	mov    (%eax),%al
  801637:	0f b6 d0             	movzbl %al,%edx
  80163a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80163d:	8a 00                	mov    (%eax),%al
  80163f:	0f b6 c0             	movzbl %al,%eax
  801642:	29 c2                	sub    %eax,%edx
  801644:	89 d0                	mov    %edx,%eax
}
  801646:	5d                   	pop    %ebp
  801647:	c3                   	ret    

00801648 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801648:	55                   	push   %ebp
  801649:	89 e5                	mov    %esp,%ebp
  80164b:	83 ec 04             	sub    $0x4,%esp
  80164e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801651:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801654:	eb 12                	jmp    801668 <strchr+0x20>
		if (*s == c)
  801656:	8b 45 08             	mov    0x8(%ebp),%eax
  801659:	8a 00                	mov    (%eax),%al
  80165b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80165e:	75 05                	jne    801665 <strchr+0x1d>
			return (char *) s;
  801660:	8b 45 08             	mov    0x8(%ebp),%eax
  801663:	eb 11                	jmp    801676 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801665:	ff 45 08             	incl   0x8(%ebp)
  801668:	8b 45 08             	mov    0x8(%ebp),%eax
  80166b:	8a 00                	mov    (%eax),%al
  80166d:	84 c0                	test   %al,%al
  80166f:	75 e5                	jne    801656 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801671:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801676:	c9                   	leave  
  801677:	c3                   	ret    

00801678 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801678:	55                   	push   %ebp
  801679:	89 e5                	mov    %esp,%ebp
  80167b:	83 ec 04             	sub    $0x4,%esp
  80167e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801681:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801684:	eb 0d                	jmp    801693 <strfind+0x1b>
		if (*s == c)
  801686:	8b 45 08             	mov    0x8(%ebp),%eax
  801689:	8a 00                	mov    (%eax),%al
  80168b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80168e:	74 0e                	je     80169e <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801690:	ff 45 08             	incl   0x8(%ebp)
  801693:	8b 45 08             	mov    0x8(%ebp),%eax
  801696:	8a 00                	mov    (%eax),%al
  801698:	84 c0                	test   %al,%al
  80169a:	75 ea                	jne    801686 <strfind+0xe>
  80169c:	eb 01                	jmp    80169f <strfind+0x27>
		if (*s == c)
			break;
  80169e:	90                   	nop
	return (char *) s;
  80169f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016a2:	c9                   	leave  
  8016a3:	c3                   	ret    

008016a4 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  8016a4:	55                   	push   %ebp
  8016a5:	89 e5                	mov    %esp,%ebp
  8016a7:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  8016aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ad:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  8016b0:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8016b4:	76 63                	jbe    801719 <memset+0x75>
		uint64 data_block = c;
  8016b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016b9:	99                   	cltd   
  8016ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016bd:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  8016c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016c6:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  8016ca:	c1 e0 08             	shl    $0x8,%eax
  8016cd:	09 45 f0             	or     %eax,-0x10(%ebp)
  8016d0:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  8016d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016d9:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  8016dd:	c1 e0 10             	shl    $0x10,%eax
  8016e0:	09 45 f0             	or     %eax,-0x10(%ebp)
  8016e3:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  8016e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016ec:	89 c2                	mov    %eax,%edx
  8016ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8016f3:	09 45 f0             	or     %eax,-0x10(%ebp)
  8016f6:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  8016f9:	eb 18                	jmp    801713 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  8016fb:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8016fe:	8d 41 08             	lea    0x8(%ecx),%eax
  801701:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801704:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801707:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80170a:	89 01                	mov    %eax,(%ecx)
  80170c:	89 51 04             	mov    %edx,0x4(%ecx)
  80170f:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801713:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801717:	77 e2                	ja     8016fb <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801719:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80171d:	74 23                	je     801742 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  80171f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801722:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801725:	eb 0e                	jmp    801735 <memset+0x91>
			*p8++ = (uint8)c;
  801727:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80172a:	8d 50 01             	lea    0x1(%eax),%edx
  80172d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801730:	8b 55 0c             	mov    0xc(%ebp),%edx
  801733:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801735:	8b 45 10             	mov    0x10(%ebp),%eax
  801738:	8d 50 ff             	lea    -0x1(%eax),%edx
  80173b:	89 55 10             	mov    %edx,0x10(%ebp)
  80173e:	85 c0                	test   %eax,%eax
  801740:	75 e5                	jne    801727 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801742:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801745:	c9                   	leave  
  801746:	c3                   	ret    

00801747 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801747:	55                   	push   %ebp
  801748:	89 e5                	mov    %esp,%ebp
  80174a:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  80174d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801750:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801753:	8b 45 08             	mov    0x8(%ebp),%eax
  801756:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801759:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80175d:	76 24                	jbe    801783 <memcpy+0x3c>
		while(n >= 8){
  80175f:	eb 1c                	jmp    80177d <memcpy+0x36>
			*d64 = *s64;
  801761:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801764:	8b 50 04             	mov    0x4(%eax),%edx
  801767:	8b 00                	mov    (%eax),%eax
  801769:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80176c:	89 01                	mov    %eax,(%ecx)
  80176e:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801771:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801775:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801779:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  80177d:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801781:	77 de                	ja     801761 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801783:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801787:	74 31                	je     8017ba <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801789:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80178c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  80178f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801792:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801795:	eb 16                	jmp    8017ad <memcpy+0x66>
			*d8++ = *s8++;
  801797:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80179a:	8d 50 01             	lea    0x1(%eax),%edx
  80179d:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8017a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017a3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8017a6:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8017a9:	8a 12                	mov    (%edx),%dl
  8017ab:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  8017ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8017b0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8017b3:	89 55 10             	mov    %edx,0x10(%ebp)
  8017b6:	85 c0                	test   %eax,%eax
  8017b8:	75 dd                	jne    801797 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  8017ba:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017bd:	c9                   	leave  
  8017be:	c3                   	ret    

008017bf <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8017bf:	55                   	push   %ebp
  8017c0:	89 e5                	mov    %esp,%ebp
  8017c2:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8017c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017c8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8017cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ce:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8017d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017d4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8017d7:	73 50                	jae    801829 <memmove+0x6a>
  8017d9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8017df:	01 d0                	add    %edx,%eax
  8017e1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8017e4:	76 43                	jbe    801829 <memmove+0x6a>
		s += n;
  8017e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8017e9:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8017ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8017ef:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8017f2:	eb 10                	jmp    801804 <memmove+0x45>
			*--d = *--s;
  8017f4:	ff 4d f8             	decl   -0x8(%ebp)
  8017f7:	ff 4d fc             	decl   -0x4(%ebp)
  8017fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017fd:	8a 10                	mov    (%eax),%dl
  8017ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801802:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801804:	8b 45 10             	mov    0x10(%ebp),%eax
  801807:	8d 50 ff             	lea    -0x1(%eax),%edx
  80180a:	89 55 10             	mov    %edx,0x10(%ebp)
  80180d:	85 c0                	test   %eax,%eax
  80180f:	75 e3                	jne    8017f4 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801811:	eb 23                	jmp    801836 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801813:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801816:	8d 50 01             	lea    0x1(%eax),%edx
  801819:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80181c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80181f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801822:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801825:	8a 12                	mov    (%edx),%dl
  801827:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801829:	8b 45 10             	mov    0x10(%ebp),%eax
  80182c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80182f:	89 55 10             	mov    %edx,0x10(%ebp)
  801832:	85 c0                	test   %eax,%eax
  801834:	75 dd                	jne    801813 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801836:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801839:	c9                   	leave  
  80183a:	c3                   	ret    

0080183b <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80183b:	55                   	push   %ebp
  80183c:	89 e5                	mov    %esp,%ebp
  80183e:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801841:	8b 45 08             	mov    0x8(%ebp),%eax
  801844:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801847:	8b 45 0c             	mov    0xc(%ebp),%eax
  80184a:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80184d:	eb 2a                	jmp    801879 <memcmp+0x3e>
		if (*s1 != *s2)
  80184f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801852:	8a 10                	mov    (%eax),%dl
  801854:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801857:	8a 00                	mov    (%eax),%al
  801859:	38 c2                	cmp    %al,%dl
  80185b:	74 16                	je     801873 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80185d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801860:	8a 00                	mov    (%eax),%al
  801862:	0f b6 d0             	movzbl %al,%edx
  801865:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801868:	8a 00                	mov    (%eax),%al
  80186a:	0f b6 c0             	movzbl %al,%eax
  80186d:	29 c2                	sub    %eax,%edx
  80186f:	89 d0                	mov    %edx,%eax
  801871:	eb 18                	jmp    80188b <memcmp+0x50>
		s1++, s2++;
  801873:	ff 45 fc             	incl   -0x4(%ebp)
  801876:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801879:	8b 45 10             	mov    0x10(%ebp),%eax
  80187c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80187f:	89 55 10             	mov    %edx,0x10(%ebp)
  801882:	85 c0                	test   %eax,%eax
  801884:	75 c9                	jne    80184f <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801886:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80188b:	c9                   	leave  
  80188c:	c3                   	ret    

0080188d <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80188d:	55                   	push   %ebp
  80188e:	89 e5                	mov    %esp,%ebp
  801890:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801893:	8b 55 08             	mov    0x8(%ebp),%edx
  801896:	8b 45 10             	mov    0x10(%ebp),%eax
  801899:	01 d0                	add    %edx,%eax
  80189b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80189e:	eb 15                	jmp    8018b5 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8018a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a3:	8a 00                	mov    (%eax),%al
  8018a5:	0f b6 d0             	movzbl %al,%edx
  8018a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018ab:	0f b6 c0             	movzbl %al,%eax
  8018ae:	39 c2                	cmp    %eax,%edx
  8018b0:	74 0d                	je     8018bf <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8018b2:	ff 45 08             	incl   0x8(%ebp)
  8018b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8018bb:	72 e3                	jb     8018a0 <memfind+0x13>
  8018bd:	eb 01                	jmp    8018c0 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8018bf:	90                   	nop
	return (void *) s;
  8018c0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8018c3:	c9                   	leave  
  8018c4:	c3                   	ret    

008018c5 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8018c5:	55                   	push   %ebp
  8018c6:	89 e5                	mov    %esp,%ebp
  8018c8:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8018cb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8018d2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8018d9:	eb 03                	jmp    8018de <strtol+0x19>
		s++;
  8018db:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8018de:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e1:	8a 00                	mov    (%eax),%al
  8018e3:	3c 20                	cmp    $0x20,%al
  8018e5:	74 f4                	je     8018db <strtol+0x16>
  8018e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ea:	8a 00                	mov    (%eax),%al
  8018ec:	3c 09                	cmp    $0x9,%al
  8018ee:	74 eb                	je     8018db <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8018f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f3:	8a 00                	mov    (%eax),%al
  8018f5:	3c 2b                	cmp    $0x2b,%al
  8018f7:	75 05                	jne    8018fe <strtol+0x39>
		s++;
  8018f9:	ff 45 08             	incl   0x8(%ebp)
  8018fc:	eb 13                	jmp    801911 <strtol+0x4c>
	else if (*s == '-')
  8018fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801901:	8a 00                	mov    (%eax),%al
  801903:	3c 2d                	cmp    $0x2d,%al
  801905:	75 0a                	jne    801911 <strtol+0x4c>
		s++, neg = 1;
  801907:	ff 45 08             	incl   0x8(%ebp)
  80190a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801911:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801915:	74 06                	je     80191d <strtol+0x58>
  801917:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80191b:	75 20                	jne    80193d <strtol+0x78>
  80191d:	8b 45 08             	mov    0x8(%ebp),%eax
  801920:	8a 00                	mov    (%eax),%al
  801922:	3c 30                	cmp    $0x30,%al
  801924:	75 17                	jne    80193d <strtol+0x78>
  801926:	8b 45 08             	mov    0x8(%ebp),%eax
  801929:	40                   	inc    %eax
  80192a:	8a 00                	mov    (%eax),%al
  80192c:	3c 78                	cmp    $0x78,%al
  80192e:	75 0d                	jne    80193d <strtol+0x78>
		s += 2, base = 16;
  801930:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801934:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80193b:	eb 28                	jmp    801965 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80193d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801941:	75 15                	jne    801958 <strtol+0x93>
  801943:	8b 45 08             	mov    0x8(%ebp),%eax
  801946:	8a 00                	mov    (%eax),%al
  801948:	3c 30                	cmp    $0x30,%al
  80194a:	75 0c                	jne    801958 <strtol+0x93>
		s++, base = 8;
  80194c:	ff 45 08             	incl   0x8(%ebp)
  80194f:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801956:	eb 0d                	jmp    801965 <strtol+0xa0>
	else if (base == 0)
  801958:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80195c:	75 07                	jne    801965 <strtol+0xa0>
		base = 10;
  80195e:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801965:	8b 45 08             	mov    0x8(%ebp),%eax
  801968:	8a 00                	mov    (%eax),%al
  80196a:	3c 2f                	cmp    $0x2f,%al
  80196c:	7e 19                	jle    801987 <strtol+0xc2>
  80196e:	8b 45 08             	mov    0x8(%ebp),%eax
  801971:	8a 00                	mov    (%eax),%al
  801973:	3c 39                	cmp    $0x39,%al
  801975:	7f 10                	jg     801987 <strtol+0xc2>
			dig = *s - '0';
  801977:	8b 45 08             	mov    0x8(%ebp),%eax
  80197a:	8a 00                	mov    (%eax),%al
  80197c:	0f be c0             	movsbl %al,%eax
  80197f:	83 e8 30             	sub    $0x30,%eax
  801982:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801985:	eb 42                	jmp    8019c9 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801987:	8b 45 08             	mov    0x8(%ebp),%eax
  80198a:	8a 00                	mov    (%eax),%al
  80198c:	3c 60                	cmp    $0x60,%al
  80198e:	7e 19                	jle    8019a9 <strtol+0xe4>
  801990:	8b 45 08             	mov    0x8(%ebp),%eax
  801993:	8a 00                	mov    (%eax),%al
  801995:	3c 7a                	cmp    $0x7a,%al
  801997:	7f 10                	jg     8019a9 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801999:	8b 45 08             	mov    0x8(%ebp),%eax
  80199c:	8a 00                	mov    (%eax),%al
  80199e:	0f be c0             	movsbl %al,%eax
  8019a1:	83 e8 57             	sub    $0x57,%eax
  8019a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8019a7:	eb 20                	jmp    8019c9 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8019a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ac:	8a 00                	mov    (%eax),%al
  8019ae:	3c 40                	cmp    $0x40,%al
  8019b0:	7e 39                	jle    8019eb <strtol+0x126>
  8019b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b5:	8a 00                	mov    (%eax),%al
  8019b7:	3c 5a                	cmp    $0x5a,%al
  8019b9:	7f 30                	jg     8019eb <strtol+0x126>
			dig = *s - 'A' + 10;
  8019bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019be:	8a 00                	mov    (%eax),%al
  8019c0:	0f be c0             	movsbl %al,%eax
  8019c3:	83 e8 37             	sub    $0x37,%eax
  8019c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8019c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019cc:	3b 45 10             	cmp    0x10(%ebp),%eax
  8019cf:	7d 19                	jge    8019ea <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8019d1:	ff 45 08             	incl   0x8(%ebp)
  8019d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019d7:	0f af 45 10          	imul   0x10(%ebp),%eax
  8019db:	89 c2                	mov    %eax,%edx
  8019dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019e0:	01 d0                	add    %edx,%eax
  8019e2:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8019e5:	e9 7b ff ff ff       	jmp    801965 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8019ea:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8019eb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8019ef:	74 08                	je     8019f9 <strtol+0x134>
		*endptr = (char *) s;
  8019f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8019f7:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8019f9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8019fd:	74 07                	je     801a06 <strtol+0x141>
  8019ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a02:	f7 d8                	neg    %eax
  801a04:	eb 03                	jmp    801a09 <strtol+0x144>
  801a06:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801a09:	c9                   	leave  
  801a0a:	c3                   	ret    

00801a0b <ltostr>:

void
ltostr(long value, char *str)
{
  801a0b:	55                   	push   %ebp
  801a0c:	89 e5                	mov    %esp,%ebp
  801a0e:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801a11:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801a18:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801a1f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a23:	79 13                	jns    801a38 <ltostr+0x2d>
	{
		neg = 1;
  801a25:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801a2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a2f:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801a32:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801a35:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801a38:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801a40:	99                   	cltd   
  801a41:	f7 f9                	idiv   %ecx
  801a43:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801a46:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a49:	8d 50 01             	lea    0x1(%eax),%edx
  801a4c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801a4f:	89 c2                	mov    %eax,%edx
  801a51:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a54:	01 d0                	add    %edx,%eax
  801a56:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801a59:	83 c2 30             	add    $0x30,%edx
  801a5c:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801a5e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a61:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801a66:	f7 e9                	imul   %ecx
  801a68:	c1 fa 02             	sar    $0x2,%edx
  801a6b:	89 c8                	mov    %ecx,%eax
  801a6d:	c1 f8 1f             	sar    $0x1f,%eax
  801a70:	29 c2                	sub    %eax,%edx
  801a72:	89 d0                	mov    %edx,%eax
  801a74:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801a77:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a7b:	75 bb                	jne    801a38 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801a7d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801a84:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a87:	48                   	dec    %eax
  801a88:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801a8b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801a8f:	74 3d                	je     801ace <ltostr+0xc3>
		start = 1 ;
  801a91:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801a98:	eb 34                	jmp    801ace <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801a9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aa0:	01 d0                	add    %edx,%eax
  801aa2:	8a 00                	mov    (%eax),%al
  801aa4:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801aa7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801aaa:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aad:	01 c2                	add    %eax,%edx
  801aaf:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801ab2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ab5:	01 c8                	add    %ecx,%eax
  801ab7:	8a 00                	mov    (%eax),%al
  801ab9:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801abb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801abe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ac1:	01 c2                	add    %eax,%edx
  801ac3:	8a 45 eb             	mov    -0x15(%ebp),%al
  801ac6:	88 02                	mov    %al,(%edx)
		start++ ;
  801ac8:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801acb:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801ace:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ad1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801ad4:	7c c4                	jl     801a9a <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801ad6:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801ad9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801adc:	01 d0                	add    %edx,%eax
  801ade:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801ae1:	90                   	nop
  801ae2:	c9                   	leave  
  801ae3:	c3                   	ret    

00801ae4 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801ae4:	55                   	push   %ebp
  801ae5:	89 e5                	mov    %esp,%ebp
  801ae7:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801aea:	ff 75 08             	pushl  0x8(%ebp)
  801aed:	e8 c4 f9 ff ff       	call   8014b6 <strlen>
  801af2:	83 c4 04             	add    $0x4,%esp
  801af5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801af8:	ff 75 0c             	pushl  0xc(%ebp)
  801afb:	e8 b6 f9 ff ff       	call   8014b6 <strlen>
  801b00:	83 c4 04             	add    $0x4,%esp
  801b03:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801b06:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801b0d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801b14:	eb 17                	jmp    801b2d <strcconcat+0x49>
		final[s] = str1[s] ;
  801b16:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b19:	8b 45 10             	mov    0x10(%ebp),%eax
  801b1c:	01 c2                	add    %eax,%edx
  801b1e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801b21:	8b 45 08             	mov    0x8(%ebp),%eax
  801b24:	01 c8                	add    %ecx,%eax
  801b26:	8a 00                	mov    (%eax),%al
  801b28:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801b2a:	ff 45 fc             	incl   -0x4(%ebp)
  801b2d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b30:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801b33:	7c e1                	jl     801b16 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801b35:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801b3c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801b43:	eb 1f                	jmp    801b64 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801b45:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b48:	8d 50 01             	lea    0x1(%eax),%edx
  801b4b:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801b4e:	89 c2                	mov    %eax,%edx
  801b50:	8b 45 10             	mov    0x10(%ebp),%eax
  801b53:	01 c2                	add    %eax,%edx
  801b55:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801b58:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b5b:	01 c8                	add    %ecx,%eax
  801b5d:	8a 00                	mov    (%eax),%al
  801b5f:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801b61:	ff 45 f8             	incl   -0x8(%ebp)
  801b64:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b67:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801b6a:	7c d9                	jl     801b45 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801b6c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b6f:	8b 45 10             	mov    0x10(%ebp),%eax
  801b72:	01 d0                	add    %edx,%eax
  801b74:	c6 00 00             	movb   $0x0,(%eax)
}
  801b77:	90                   	nop
  801b78:	c9                   	leave  
  801b79:	c3                   	ret    

00801b7a <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801b7a:	55                   	push   %ebp
  801b7b:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801b7d:	8b 45 14             	mov    0x14(%ebp),%eax
  801b80:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801b86:	8b 45 14             	mov    0x14(%ebp),%eax
  801b89:	8b 00                	mov    (%eax),%eax
  801b8b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b92:	8b 45 10             	mov    0x10(%ebp),%eax
  801b95:	01 d0                	add    %edx,%eax
  801b97:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801b9d:	eb 0c                	jmp    801bab <strsplit+0x31>
			*string++ = 0;
  801b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba2:	8d 50 01             	lea    0x1(%eax),%edx
  801ba5:	89 55 08             	mov    %edx,0x8(%ebp)
  801ba8:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801bab:	8b 45 08             	mov    0x8(%ebp),%eax
  801bae:	8a 00                	mov    (%eax),%al
  801bb0:	84 c0                	test   %al,%al
  801bb2:	74 18                	je     801bcc <strsplit+0x52>
  801bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb7:	8a 00                	mov    (%eax),%al
  801bb9:	0f be c0             	movsbl %al,%eax
  801bbc:	50                   	push   %eax
  801bbd:	ff 75 0c             	pushl  0xc(%ebp)
  801bc0:	e8 83 fa ff ff       	call   801648 <strchr>
  801bc5:	83 c4 08             	add    $0x8,%esp
  801bc8:	85 c0                	test   %eax,%eax
  801bca:	75 d3                	jne    801b9f <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801bcc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcf:	8a 00                	mov    (%eax),%al
  801bd1:	84 c0                	test   %al,%al
  801bd3:	74 5a                	je     801c2f <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801bd5:	8b 45 14             	mov    0x14(%ebp),%eax
  801bd8:	8b 00                	mov    (%eax),%eax
  801bda:	83 f8 0f             	cmp    $0xf,%eax
  801bdd:	75 07                	jne    801be6 <strsplit+0x6c>
		{
			return 0;
  801bdf:	b8 00 00 00 00       	mov    $0x0,%eax
  801be4:	eb 66                	jmp    801c4c <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801be6:	8b 45 14             	mov    0x14(%ebp),%eax
  801be9:	8b 00                	mov    (%eax),%eax
  801beb:	8d 48 01             	lea    0x1(%eax),%ecx
  801bee:	8b 55 14             	mov    0x14(%ebp),%edx
  801bf1:	89 0a                	mov    %ecx,(%edx)
  801bf3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801bfa:	8b 45 10             	mov    0x10(%ebp),%eax
  801bfd:	01 c2                	add    %eax,%edx
  801bff:	8b 45 08             	mov    0x8(%ebp),%eax
  801c02:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801c04:	eb 03                	jmp    801c09 <strsplit+0x8f>
			string++;
  801c06:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801c09:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0c:	8a 00                	mov    (%eax),%al
  801c0e:	84 c0                	test   %al,%al
  801c10:	74 8b                	je     801b9d <strsplit+0x23>
  801c12:	8b 45 08             	mov    0x8(%ebp),%eax
  801c15:	8a 00                	mov    (%eax),%al
  801c17:	0f be c0             	movsbl %al,%eax
  801c1a:	50                   	push   %eax
  801c1b:	ff 75 0c             	pushl  0xc(%ebp)
  801c1e:	e8 25 fa ff ff       	call   801648 <strchr>
  801c23:	83 c4 08             	add    $0x8,%esp
  801c26:	85 c0                	test   %eax,%eax
  801c28:	74 dc                	je     801c06 <strsplit+0x8c>
			string++;
	}
  801c2a:	e9 6e ff ff ff       	jmp    801b9d <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801c2f:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801c30:	8b 45 14             	mov    0x14(%ebp),%eax
  801c33:	8b 00                	mov    (%eax),%eax
  801c35:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c3c:	8b 45 10             	mov    0x10(%ebp),%eax
  801c3f:	01 d0                	add    %edx,%eax
  801c41:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801c47:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801c4c:	c9                   	leave  
  801c4d:	c3                   	ret    

00801c4e <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801c4e:	55                   	push   %ebp
  801c4f:	89 e5                	mov    %esp,%ebp
  801c51:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801c54:	8b 45 08             	mov    0x8(%ebp),%eax
  801c57:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801c5a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801c61:	eb 4a                	jmp    801cad <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801c63:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c66:	8b 45 08             	mov    0x8(%ebp),%eax
  801c69:	01 c2                	add    %eax,%edx
  801c6b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801c6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c71:	01 c8                	add    %ecx,%eax
  801c73:	8a 00                	mov    (%eax),%al
  801c75:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801c77:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c7d:	01 d0                	add    %edx,%eax
  801c7f:	8a 00                	mov    (%eax),%al
  801c81:	3c 40                	cmp    $0x40,%al
  801c83:	7e 25                	jle    801caa <str2lower+0x5c>
  801c85:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c88:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c8b:	01 d0                	add    %edx,%eax
  801c8d:	8a 00                	mov    (%eax),%al
  801c8f:	3c 5a                	cmp    $0x5a,%al
  801c91:	7f 17                	jg     801caa <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801c93:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c96:	8b 45 08             	mov    0x8(%ebp),%eax
  801c99:	01 d0                	add    %edx,%eax
  801c9b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801c9e:	8b 55 08             	mov    0x8(%ebp),%edx
  801ca1:	01 ca                	add    %ecx,%edx
  801ca3:	8a 12                	mov    (%edx),%dl
  801ca5:	83 c2 20             	add    $0x20,%edx
  801ca8:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801caa:	ff 45 fc             	incl   -0x4(%ebp)
  801cad:	ff 75 0c             	pushl  0xc(%ebp)
  801cb0:	e8 01 f8 ff ff       	call   8014b6 <strlen>
  801cb5:	83 c4 04             	add    $0x4,%esp
  801cb8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801cbb:	7f a6                	jg     801c63 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801cbd:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801cc0:	c9                   	leave  
  801cc1:	c3                   	ret    

00801cc2 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801cc2:	55                   	push   %ebp
  801cc3:	89 e5                	mov    %esp,%ebp
  801cc5:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801cc8:	a1 08 40 80 00       	mov    0x804008,%eax
  801ccd:	85 c0                	test   %eax,%eax
  801ccf:	74 42                	je     801d13 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801cd1:	83 ec 08             	sub    $0x8,%esp
  801cd4:	68 00 00 00 82       	push   $0x82000000
  801cd9:	68 00 00 00 80       	push   $0x80000000
  801cde:	e8 8c 07 00 00       	call   80246f <initialize_dynamic_allocator>
  801ce3:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801ce6:	e8 e7 05 00 00       	call   8022d2 <sys_get_uheap_strategy>
  801ceb:	a3 60 c0 81 00       	mov    %eax,0x81c060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801cf0:	a1 40 40 80 00       	mov    0x804040,%eax
  801cf5:	05 00 10 00 00       	add    $0x1000,%eax
  801cfa:	a3 10 c1 81 00       	mov    %eax,0x81c110
		uheapPageAllocBreak = uheapPageAllocStart;
  801cff:	a1 10 c1 81 00       	mov    0x81c110,%eax
  801d04:	a3 68 c0 81 00       	mov    %eax,0x81c068

		__firstTimeFlag = 0;
  801d09:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  801d10:	00 00 00 
	}
}
  801d13:	90                   	nop
  801d14:	c9                   	leave  
  801d15:	c3                   	ret    

00801d16 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801d16:	55                   	push   %ebp
  801d17:	89 e5                	mov    %esp,%ebp
  801d19:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801d1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d25:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d2a:	83 ec 08             	sub    $0x8,%esp
  801d2d:	68 06 04 00 00       	push   $0x406
  801d32:	50                   	push   %eax
  801d33:	e8 e4 01 00 00       	call   801f1c <__sys_allocate_page>
  801d38:	83 c4 10             	add    $0x10,%esp
  801d3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801d3e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d42:	79 14                	jns    801d58 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801d44:	83 ec 04             	sub    $0x4,%esp
  801d47:	68 1c 30 80 00       	push   $0x80301c
  801d4c:	6a 1f                	push   $0x1f
  801d4e:	68 58 30 80 00       	push   $0x803058
  801d53:	e8 af eb ff ff       	call   800907 <_panic>
	return 0;
  801d58:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d5d:	c9                   	leave  
  801d5e:	c3                   	ret    

00801d5f <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801d5f:	55                   	push   %ebp
  801d60:	89 e5                	mov    %esp,%ebp
  801d62:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801d65:	8b 45 08             	mov    0x8(%ebp),%eax
  801d68:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d6e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d73:	83 ec 0c             	sub    $0xc,%esp
  801d76:	50                   	push   %eax
  801d77:	e8 e7 01 00 00       	call   801f63 <__sys_unmap_frame>
  801d7c:	83 c4 10             	add    $0x10,%esp
  801d7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801d82:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d86:	79 14                	jns    801d9c <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801d88:	83 ec 04             	sub    $0x4,%esp
  801d8b:	68 64 30 80 00       	push   $0x803064
  801d90:	6a 2a                	push   $0x2a
  801d92:	68 58 30 80 00       	push   $0x803058
  801d97:	e8 6b eb ff ff       	call   800907 <_panic>
}
  801d9c:	90                   	nop
  801d9d:	c9                   	leave  
  801d9e:	c3                   	ret    

00801d9f <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801d9f:	55                   	push   %ebp
  801da0:	89 e5                	mov    %esp,%ebp
  801da2:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801da5:	e8 18 ff ff ff       	call   801cc2 <uheap_init>
	if (size == 0) return NULL ;
  801daa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801dae:	75 07                	jne    801db7 <malloc+0x18>
  801db0:	b8 00 00 00 00       	mov    $0x0,%eax
  801db5:	eb 14                	jmp    801dcb <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  801db7:	83 ec 04             	sub    $0x4,%esp
  801dba:	68 a4 30 80 00       	push   $0x8030a4
  801dbf:	6a 3e                	push   $0x3e
  801dc1:	68 58 30 80 00       	push   $0x803058
  801dc6:	e8 3c eb ff ff       	call   800907 <_panic>
}
  801dcb:	c9                   	leave  
  801dcc:	c3                   	ret    

00801dcd <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801dcd:	55                   	push   %ebp
  801dce:	89 e5                	mov    %esp,%ebp
  801dd0:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  801dd3:	83 ec 04             	sub    $0x4,%esp
  801dd6:	68 cc 30 80 00       	push   $0x8030cc
  801ddb:	6a 49                	push   $0x49
  801ddd:	68 58 30 80 00       	push   $0x803058
  801de2:	e8 20 eb ff ff       	call   800907 <_panic>

00801de7 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801de7:	55                   	push   %ebp
  801de8:	89 e5                	mov    %esp,%ebp
  801dea:	83 ec 18             	sub    $0x18,%esp
  801ded:	8b 45 10             	mov    0x10(%ebp),%eax
  801df0:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801df3:	e8 ca fe ff ff       	call   801cc2 <uheap_init>
	if (size == 0) return NULL ;
  801df8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801dfc:	75 07                	jne    801e05 <smalloc+0x1e>
  801dfe:	b8 00 00 00 00       	mov    $0x0,%eax
  801e03:	eb 14                	jmp    801e19 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  801e05:	83 ec 04             	sub    $0x4,%esp
  801e08:	68 f0 30 80 00       	push   $0x8030f0
  801e0d:	6a 5a                	push   $0x5a
  801e0f:	68 58 30 80 00       	push   $0x803058
  801e14:	e8 ee ea ff ff       	call   800907 <_panic>
}
  801e19:	c9                   	leave  
  801e1a:	c3                   	ret    

00801e1b <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801e1b:	55                   	push   %ebp
  801e1c:	89 e5                	mov    %esp,%ebp
  801e1e:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801e21:	e8 9c fe ff ff       	call   801cc2 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  801e26:	83 ec 04             	sub    $0x4,%esp
  801e29:	68 18 31 80 00       	push   $0x803118
  801e2e:	6a 6a                	push   $0x6a
  801e30:	68 58 30 80 00       	push   $0x803058
  801e35:	e8 cd ea ff ff       	call   800907 <_panic>

00801e3a <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801e3a:	55                   	push   %ebp
  801e3b:	89 e5                	mov    %esp,%ebp
  801e3d:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801e40:	e8 7d fe ff ff       	call   801cc2 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  801e45:	83 ec 04             	sub    $0x4,%esp
  801e48:	68 3c 31 80 00       	push   $0x80313c
  801e4d:	68 88 00 00 00       	push   $0x88
  801e52:	68 58 30 80 00       	push   $0x803058
  801e57:	e8 ab ea ff ff       	call   800907 <_panic>

00801e5c <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  801e5c:	55                   	push   %ebp
  801e5d:	89 e5                	mov    %esp,%ebp
  801e5f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  801e62:	83 ec 04             	sub    $0x4,%esp
  801e65:	68 64 31 80 00       	push   $0x803164
  801e6a:	68 9b 00 00 00       	push   $0x9b
  801e6f:	68 58 30 80 00       	push   $0x803058
  801e74:	e8 8e ea ff ff       	call   800907 <_panic>

00801e79 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801e79:	55                   	push   %ebp
  801e7a:	89 e5                	mov    %esp,%ebp
  801e7c:	57                   	push   %edi
  801e7d:	56                   	push   %esi
  801e7e:	53                   	push   %ebx
  801e7f:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801e82:	8b 45 08             	mov    0x8(%ebp),%eax
  801e85:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e88:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e8b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e8e:	8b 7d 18             	mov    0x18(%ebp),%edi
  801e91:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801e94:	cd 30                	int    $0x30
  801e96:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801e99:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801e9c:	83 c4 10             	add    $0x10,%esp
  801e9f:	5b                   	pop    %ebx
  801ea0:	5e                   	pop    %esi
  801ea1:	5f                   	pop    %edi
  801ea2:	5d                   	pop    %ebp
  801ea3:	c3                   	ret    

00801ea4 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801ea4:	55                   	push   %ebp
  801ea5:	89 e5                	mov    %esp,%ebp
  801ea7:	83 ec 04             	sub    $0x4,%esp
  801eaa:	8b 45 10             	mov    0x10(%ebp),%eax
  801ead:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801eb0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801eb3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eba:	6a 00                	push   $0x0
  801ebc:	51                   	push   %ecx
  801ebd:	52                   	push   %edx
  801ebe:	ff 75 0c             	pushl  0xc(%ebp)
  801ec1:	50                   	push   %eax
  801ec2:	6a 00                	push   $0x0
  801ec4:	e8 b0 ff ff ff       	call   801e79 <syscall>
  801ec9:	83 c4 18             	add    $0x18,%esp
}
  801ecc:	90                   	nop
  801ecd:	c9                   	leave  
  801ece:	c3                   	ret    

00801ecf <sys_cgetc>:

int
sys_cgetc(void)
{
  801ecf:	55                   	push   %ebp
  801ed0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801ed2:	6a 00                	push   $0x0
  801ed4:	6a 00                	push   $0x0
  801ed6:	6a 00                	push   $0x0
  801ed8:	6a 00                	push   $0x0
  801eda:	6a 00                	push   $0x0
  801edc:	6a 02                	push   $0x2
  801ede:	e8 96 ff ff ff       	call   801e79 <syscall>
  801ee3:	83 c4 18             	add    $0x18,%esp
}
  801ee6:	c9                   	leave  
  801ee7:	c3                   	ret    

00801ee8 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801ee8:	55                   	push   %ebp
  801ee9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801eeb:	6a 00                	push   $0x0
  801eed:	6a 00                	push   $0x0
  801eef:	6a 00                	push   $0x0
  801ef1:	6a 00                	push   $0x0
  801ef3:	6a 00                	push   $0x0
  801ef5:	6a 03                	push   $0x3
  801ef7:	e8 7d ff ff ff       	call   801e79 <syscall>
  801efc:	83 c4 18             	add    $0x18,%esp
}
  801eff:	90                   	nop
  801f00:	c9                   	leave  
  801f01:	c3                   	ret    

00801f02 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801f02:	55                   	push   %ebp
  801f03:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801f05:	6a 00                	push   $0x0
  801f07:	6a 00                	push   $0x0
  801f09:	6a 00                	push   $0x0
  801f0b:	6a 00                	push   $0x0
  801f0d:	6a 00                	push   $0x0
  801f0f:	6a 04                	push   $0x4
  801f11:	e8 63 ff ff ff       	call   801e79 <syscall>
  801f16:	83 c4 18             	add    $0x18,%esp
}
  801f19:	90                   	nop
  801f1a:	c9                   	leave  
  801f1b:	c3                   	ret    

00801f1c <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801f1c:	55                   	push   %ebp
  801f1d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801f1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f22:	8b 45 08             	mov    0x8(%ebp),%eax
  801f25:	6a 00                	push   $0x0
  801f27:	6a 00                	push   $0x0
  801f29:	6a 00                	push   $0x0
  801f2b:	52                   	push   %edx
  801f2c:	50                   	push   %eax
  801f2d:	6a 08                	push   $0x8
  801f2f:	e8 45 ff ff ff       	call   801e79 <syscall>
  801f34:	83 c4 18             	add    $0x18,%esp
}
  801f37:	c9                   	leave  
  801f38:	c3                   	ret    

00801f39 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801f39:	55                   	push   %ebp
  801f3a:	89 e5                	mov    %esp,%ebp
  801f3c:	56                   	push   %esi
  801f3d:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801f3e:	8b 75 18             	mov    0x18(%ebp),%esi
  801f41:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f44:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f47:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4d:	56                   	push   %esi
  801f4e:	53                   	push   %ebx
  801f4f:	51                   	push   %ecx
  801f50:	52                   	push   %edx
  801f51:	50                   	push   %eax
  801f52:	6a 09                	push   $0x9
  801f54:	e8 20 ff ff ff       	call   801e79 <syscall>
  801f59:	83 c4 18             	add    $0x18,%esp
}
  801f5c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f5f:	5b                   	pop    %ebx
  801f60:	5e                   	pop    %esi
  801f61:	5d                   	pop    %ebp
  801f62:	c3                   	ret    

00801f63 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801f63:	55                   	push   %ebp
  801f64:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801f66:	6a 00                	push   $0x0
  801f68:	6a 00                	push   $0x0
  801f6a:	6a 00                	push   $0x0
  801f6c:	6a 00                	push   $0x0
  801f6e:	ff 75 08             	pushl  0x8(%ebp)
  801f71:	6a 0a                	push   $0xa
  801f73:	e8 01 ff ff ff       	call   801e79 <syscall>
  801f78:	83 c4 18             	add    $0x18,%esp
}
  801f7b:	c9                   	leave  
  801f7c:	c3                   	ret    

00801f7d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801f7d:	55                   	push   %ebp
  801f7e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801f80:	6a 00                	push   $0x0
  801f82:	6a 00                	push   $0x0
  801f84:	6a 00                	push   $0x0
  801f86:	ff 75 0c             	pushl  0xc(%ebp)
  801f89:	ff 75 08             	pushl  0x8(%ebp)
  801f8c:	6a 0b                	push   $0xb
  801f8e:	e8 e6 fe ff ff       	call   801e79 <syscall>
  801f93:	83 c4 18             	add    $0x18,%esp
}
  801f96:	c9                   	leave  
  801f97:	c3                   	ret    

00801f98 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801f98:	55                   	push   %ebp
  801f99:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801f9b:	6a 00                	push   $0x0
  801f9d:	6a 00                	push   $0x0
  801f9f:	6a 00                	push   $0x0
  801fa1:	6a 00                	push   $0x0
  801fa3:	6a 00                	push   $0x0
  801fa5:	6a 0c                	push   $0xc
  801fa7:	e8 cd fe ff ff       	call   801e79 <syscall>
  801fac:	83 c4 18             	add    $0x18,%esp
}
  801faf:	c9                   	leave  
  801fb0:	c3                   	ret    

00801fb1 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801fb1:	55                   	push   %ebp
  801fb2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801fb4:	6a 00                	push   $0x0
  801fb6:	6a 00                	push   $0x0
  801fb8:	6a 00                	push   $0x0
  801fba:	6a 00                	push   $0x0
  801fbc:	6a 00                	push   $0x0
  801fbe:	6a 0d                	push   $0xd
  801fc0:	e8 b4 fe ff ff       	call   801e79 <syscall>
  801fc5:	83 c4 18             	add    $0x18,%esp
}
  801fc8:	c9                   	leave  
  801fc9:	c3                   	ret    

00801fca <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801fca:	55                   	push   %ebp
  801fcb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801fcd:	6a 00                	push   $0x0
  801fcf:	6a 00                	push   $0x0
  801fd1:	6a 00                	push   $0x0
  801fd3:	6a 00                	push   $0x0
  801fd5:	6a 00                	push   $0x0
  801fd7:	6a 0e                	push   $0xe
  801fd9:	e8 9b fe ff ff       	call   801e79 <syscall>
  801fde:	83 c4 18             	add    $0x18,%esp
}
  801fe1:	c9                   	leave  
  801fe2:	c3                   	ret    

00801fe3 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801fe3:	55                   	push   %ebp
  801fe4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801fe6:	6a 00                	push   $0x0
  801fe8:	6a 00                	push   $0x0
  801fea:	6a 00                	push   $0x0
  801fec:	6a 00                	push   $0x0
  801fee:	6a 00                	push   $0x0
  801ff0:	6a 0f                	push   $0xf
  801ff2:	e8 82 fe ff ff       	call   801e79 <syscall>
  801ff7:	83 c4 18             	add    $0x18,%esp
}
  801ffa:	c9                   	leave  
  801ffb:	c3                   	ret    

00801ffc <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801ffc:	55                   	push   %ebp
  801ffd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801fff:	6a 00                	push   $0x0
  802001:	6a 00                	push   $0x0
  802003:	6a 00                	push   $0x0
  802005:	6a 00                	push   $0x0
  802007:	ff 75 08             	pushl  0x8(%ebp)
  80200a:	6a 10                	push   $0x10
  80200c:	e8 68 fe ff ff       	call   801e79 <syscall>
  802011:	83 c4 18             	add    $0x18,%esp
}
  802014:	c9                   	leave  
  802015:	c3                   	ret    

00802016 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802016:	55                   	push   %ebp
  802017:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802019:	6a 00                	push   $0x0
  80201b:	6a 00                	push   $0x0
  80201d:	6a 00                	push   $0x0
  80201f:	6a 00                	push   $0x0
  802021:	6a 00                	push   $0x0
  802023:	6a 11                	push   $0x11
  802025:	e8 4f fe ff ff       	call   801e79 <syscall>
  80202a:	83 c4 18             	add    $0x18,%esp
}
  80202d:	90                   	nop
  80202e:	c9                   	leave  
  80202f:	c3                   	ret    

00802030 <sys_cputc>:

void
sys_cputc(const char c)
{
  802030:	55                   	push   %ebp
  802031:	89 e5                	mov    %esp,%ebp
  802033:	83 ec 04             	sub    $0x4,%esp
  802036:	8b 45 08             	mov    0x8(%ebp),%eax
  802039:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80203c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802040:	6a 00                	push   $0x0
  802042:	6a 00                	push   $0x0
  802044:	6a 00                	push   $0x0
  802046:	6a 00                	push   $0x0
  802048:	50                   	push   %eax
  802049:	6a 01                	push   $0x1
  80204b:	e8 29 fe ff ff       	call   801e79 <syscall>
  802050:	83 c4 18             	add    $0x18,%esp
}
  802053:	90                   	nop
  802054:	c9                   	leave  
  802055:	c3                   	ret    

00802056 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802056:	55                   	push   %ebp
  802057:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802059:	6a 00                	push   $0x0
  80205b:	6a 00                	push   $0x0
  80205d:	6a 00                	push   $0x0
  80205f:	6a 00                	push   $0x0
  802061:	6a 00                	push   $0x0
  802063:	6a 14                	push   $0x14
  802065:	e8 0f fe ff ff       	call   801e79 <syscall>
  80206a:	83 c4 18             	add    $0x18,%esp
}
  80206d:	90                   	nop
  80206e:	c9                   	leave  
  80206f:	c3                   	ret    

00802070 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802070:	55                   	push   %ebp
  802071:	89 e5                	mov    %esp,%ebp
  802073:	83 ec 04             	sub    $0x4,%esp
  802076:	8b 45 10             	mov    0x10(%ebp),%eax
  802079:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80207c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80207f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802083:	8b 45 08             	mov    0x8(%ebp),%eax
  802086:	6a 00                	push   $0x0
  802088:	51                   	push   %ecx
  802089:	52                   	push   %edx
  80208a:	ff 75 0c             	pushl  0xc(%ebp)
  80208d:	50                   	push   %eax
  80208e:	6a 15                	push   $0x15
  802090:	e8 e4 fd ff ff       	call   801e79 <syscall>
  802095:	83 c4 18             	add    $0x18,%esp
}
  802098:	c9                   	leave  
  802099:	c3                   	ret    

0080209a <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  80209a:	55                   	push   %ebp
  80209b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80209d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a3:	6a 00                	push   $0x0
  8020a5:	6a 00                	push   $0x0
  8020a7:	6a 00                	push   $0x0
  8020a9:	52                   	push   %edx
  8020aa:	50                   	push   %eax
  8020ab:	6a 16                	push   $0x16
  8020ad:	e8 c7 fd ff ff       	call   801e79 <syscall>
  8020b2:	83 c4 18             	add    $0x18,%esp
}
  8020b5:	c9                   	leave  
  8020b6:	c3                   	ret    

008020b7 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8020b7:	55                   	push   %ebp
  8020b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8020ba:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c3:	6a 00                	push   $0x0
  8020c5:	6a 00                	push   $0x0
  8020c7:	51                   	push   %ecx
  8020c8:	52                   	push   %edx
  8020c9:	50                   	push   %eax
  8020ca:	6a 17                	push   $0x17
  8020cc:	e8 a8 fd ff ff       	call   801e79 <syscall>
  8020d1:	83 c4 18             	add    $0x18,%esp
}
  8020d4:	c9                   	leave  
  8020d5:	c3                   	ret    

008020d6 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8020d6:	55                   	push   %ebp
  8020d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8020d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020df:	6a 00                	push   $0x0
  8020e1:	6a 00                	push   $0x0
  8020e3:	6a 00                	push   $0x0
  8020e5:	52                   	push   %edx
  8020e6:	50                   	push   %eax
  8020e7:	6a 18                	push   $0x18
  8020e9:	e8 8b fd ff ff       	call   801e79 <syscall>
  8020ee:	83 c4 18             	add    $0x18,%esp
}
  8020f1:	c9                   	leave  
  8020f2:	c3                   	ret    

008020f3 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8020f3:	55                   	push   %ebp
  8020f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8020f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f9:	6a 00                	push   $0x0
  8020fb:	ff 75 14             	pushl  0x14(%ebp)
  8020fe:	ff 75 10             	pushl  0x10(%ebp)
  802101:	ff 75 0c             	pushl  0xc(%ebp)
  802104:	50                   	push   %eax
  802105:	6a 19                	push   $0x19
  802107:	e8 6d fd ff ff       	call   801e79 <syscall>
  80210c:	83 c4 18             	add    $0x18,%esp
}
  80210f:	c9                   	leave  
  802110:	c3                   	ret    

00802111 <sys_run_env>:

void sys_run_env(int32 envId)
{
  802111:	55                   	push   %ebp
  802112:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802114:	8b 45 08             	mov    0x8(%ebp),%eax
  802117:	6a 00                	push   $0x0
  802119:	6a 00                	push   $0x0
  80211b:	6a 00                	push   $0x0
  80211d:	6a 00                	push   $0x0
  80211f:	50                   	push   %eax
  802120:	6a 1a                	push   $0x1a
  802122:	e8 52 fd ff ff       	call   801e79 <syscall>
  802127:	83 c4 18             	add    $0x18,%esp
}
  80212a:	90                   	nop
  80212b:	c9                   	leave  
  80212c:	c3                   	ret    

0080212d <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80212d:	55                   	push   %ebp
  80212e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802130:	8b 45 08             	mov    0x8(%ebp),%eax
  802133:	6a 00                	push   $0x0
  802135:	6a 00                	push   $0x0
  802137:	6a 00                	push   $0x0
  802139:	6a 00                	push   $0x0
  80213b:	50                   	push   %eax
  80213c:	6a 1b                	push   $0x1b
  80213e:	e8 36 fd ff ff       	call   801e79 <syscall>
  802143:	83 c4 18             	add    $0x18,%esp
}
  802146:	c9                   	leave  
  802147:	c3                   	ret    

00802148 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802148:	55                   	push   %ebp
  802149:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80214b:	6a 00                	push   $0x0
  80214d:	6a 00                	push   $0x0
  80214f:	6a 00                	push   $0x0
  802151:	6a 00                	push   $0x0
  802153:	6a 00                	push   $0x0
  802155:	6a 05                	push   $0x5
  802157:	e8 1d fd ff ff       	call   801e79 <syscall>
  80215c:	83 c4 18             	add    $0x18,%esp
}
  80215f:	c9                   	leave  
  802160:	c3                   	ret    

00802161 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802161:	55                   	push   %ebp
  802162:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802164:	6a 00                	push   $0x0
  802166:	6a 00                	push   $0x0
  802168:	6a 00                	push   $0x0
  80216a:	6a 00                	push   $0x0
  80216c:	6a 00                	push   $0x0
  80216e:	6a 06                	push   $0x6
  802170:	e8 04 fd ff ff       	call   801e79 <syscall>
  802175:	83 c4 18             	add    $0x18,%esp
}
  802178:	c9                   	leave  
  802179:	c3                   	ret    

0080217a <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80217a:	55                   	push   %ebp
  80217b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80217d:	6a 00                	push   $0x0
  80217f:	6a 00                	push   $0x0
  802181:	6a 00                	push   $0x0
  802183:	6a 00                	push   $0x0
  802185:	6a 00                	push   $0x0
  802187:	6a 07                	push   $0x7
  802189:	e8 eb fc ff ff       	call   801e79 <syscall>
  80218e:	83 c4 18             	add    $0x18,%esp
}
  802191:	c9                   	leave  
  802192:	c3                   	ret    

00802193 <sys_exit_env>:


void sys_exit_env(void)
{
  802193:	55                   	push   %ebp
  802194:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802196:	6a 00                	push   $0x0
  802198:	6a 00                	push   $0x0
  80219a:	6a 00                	push   $0x0
  80219c:	6a 00                	push   $0x0
  80219e:	6a 00                	push   $0x0
  8021a0:	6a 1c                	push   $0x1c
  8021a2:	e8 d2 fc ff ff       	call   801e79 <syscall>
  8021a7:	83 c4 18             	add    $0x18,%esp
}
  8021aa:	90                   	nop
  8021ab:	c9                   	leave  
  8021ac:	c3                   	ret    

008021ad <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8021ad:	55                   	push   %ebp
  8021ae:	89 e5                	mov    %esp,%ebp
  8021b0:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8021b3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8021b6:	8d 50 04             	lea    0x4(%eax),%edx
  8021b9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8021bc:	6a 00                	push   $0x0
  8021be:	6a 00                	push   $0x0
  8021c0:	6a 00                	push   $0x0
  8021c2:	52                   	push   %edx
  8021c3:	50                   	push   %eax
  8021c4:	6a 1d                	push   $0x1d
  8021c6:	e8 ae fc ff ff       	call   801e79 <syscall>
  8021cb:	83 c4 18             	add    $0x18,%esp
	return result;
  8021ce:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8021d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021d4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8021d7:	89 01                	mov    %eax,(%ecx)
  8021d9:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8021dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021df:	c9                   	leave  
  8021e0:	c2 04 00             	ret    $0x4

008021e3 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8021e3:	55                   	push   %ebp
  8021e4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8021e6:	6a 00                	push   $0x0
  8021e8:	6a 00                	push   $0x0
  8021ea:	ff 75 10             	pushl  0x10(%ebp)
  8021ed:	ff 75 0c             	pushl  0xc(%ebp)
  8021f0:	ff 75 08             	pushl  0x8(%ebp)
  8021f3:	6a 13                	push   $0x13
  8021f5:	e8 7f fc ff ff       	call   801e79 <syscall>
  8021fa:	83 c4 18             	add    $0x18,%esp
	return ;
  8021fd:	90                   	nop
}
  8021fe:	c9                   	leave  
  8021ff:	c3                   	ret    

00802200 <sys_rcr2>:
uint32 sys_rcr2()
{
  802200:	55                   	push   %ebp
  802201:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802203:	6a 00                	push   $0x0
  802205:	6a 00                	push   $0x0
  802207:	6a 00                	push   $0x0
  802209:	6a 00                	push   $0x0
  80220b:	6a 00                	push   $0x0
  80220d:	6a 1e                	push   $0x1e
  80220f:	e8 65 fc ff ff       	call   801e79 <syscall>
  802214:	83 c4 18             	add    $0x18,%esp
}
  802217:	c9                   	leave  
  802218:	c3                   	ret    

00802219 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802219:	55                   	push   %ebp
  80221a:	89 e5                	mov    %esp,%ebp
  80221c:	83 ec 04             	sub    $0x4,%esp
  80221f:	8b 45 08             	mov    0x8(%ebp),%eax
  802222:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802225:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802229:	6a 00                	push   $0x0
  80222b:	6a 00                	push   $0x0
  80222d:	6a 00                	push   $0x0
  80222f:	6a 00                	push   $0x0
  802231:	50                   	push   %eax
  802232:	6a 1f                	push   $0x1f
  802234:	e8 40 fc ff ff       	call   801e79 <syscall>
  802239:	83 c4 18             	add    $0x18,%esp
	return ;
  80223c:	90                   	nop
}
  80223d:	c9                   	leave  
  80223e:	c3                   	ret    

0080223f <rsttst>:
void rsttst()
{
  80223f:	55                   	push   %ebp
  802240:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802242:	6a 00                	push   $0x0
  802244:	6a 00                	push   $0x0
  802246:	6a 00                	push   $0x0
  802248:	6a 00                	push   $0x0
  80224a:	6a 00                	push   $0x0
  80224c:	6a 21                	push   $0x21
  80224e:	e8 26 fc ff ff       	call   801e79 <syscall>
  802253:	83 c4 18             	add    $0x18,%esp
	return ;
  802256:	90                   	nop
}
  802257:	c9                   	leave  
  802258:	c3                   	ret    

00802259 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802259:	55                   	push   %ebp
  80225a:	89 e5                	mov    %esp,%ebp
  80225c:	83 ec 04             	sub    $0x4,%esp
  80225f:	8b 45 14             	mov    0x14(%ebp),%eax
  802262:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802265:	8b 55 18             	mov    0x18(%ebp),%edx
  802268:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80226c:	52                   	push   %edx
  80226d:	50                   	push   %eax
  80226e:	ff 75 10             	pushl  0x10(%ebp)
  802271:	ff 75 0c             	pushl  0xc(%ebp)
  802274:	ff 75 08             	pushl  0x8(%ebp)
  802277:	6a 20                	push   $0x20
  802279:	e8 fb fb ff ff       	call   801e79 <syscall>
  80227e:	83 c4 18             	add    $0x18,%esp
	return ;
  802281:	90                   	nop
}
  802282:	c9                   	leave  
  802283:	c3                   	ret    

00802284 <chktst>:
void chktst(uint32 n)
{
  802284:	55                   	push   %ebp
  802285:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802287:	6a 00                	push   $0x0
  802289:	6a 00                	push   $0x0
  80228b:	6a 00                	push   $0x0
  80228d:	6a 00                	push   $0x0
  80228f:	ff 75 08             	pushl  0x8(%ebp)
  802292:	6a 22                	push   $0x22
  802294:	e8 e0 fb ff ff       	call   801e79 <syscall>
  802299:	83 c4 18             	add    $0x18,%esp
	return ;
  80229c:	90                   	nop
}
  80229d:	c9                   	leave  
  80229e:	c3                   	ret    

0080229f <inctst>:

void inctst()
{
  80229f:	55                   	push   %ebp
  8022a0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8022a2:	6a 00                	push   $0x0
  8022a4:	6a 00                	push   $0x0
  8022a6:	6a 00                	push   $0x0
  8022a8:	6a 00                	push   $0x0
  8022aa:	6a 00                	push   $0x0
  8022ac:	6a 23                	push   $0x23
  8022ae:	e8 c6 fb ff ff       	call   801e79 <syscall>
  8022b3:	83 c4 18             	add    $0x18,%esp
	return ;
  8022b6:	90                   	nop
}
  8022b7:	c9                   	leave  
  8022b8:	c3                   	ret    

008022b9 <gettst>:
uint32 gettst()
{
  8022b9:	55                   	push   %ebp
  8022ba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8022bc:	6a 00                	push   $0x0
  8022be:	6a 00                	push   $0x0
  8022c0:	6a 00                	push   $0x0
  8022c2:	6a 00                	push   $0x0
  8022c4:	6a 00                	push   $0x0
  8022c6:	6a 24                	push   $0x24
  8022c8:	e8 ac fb ff ff       	call   801e79 <syscall>
  8022cd:	83 c4 18             	add    $0x18,%esp
}
  8022d0:	c9                   	leave  
  8022d1:	c3                   	ret    

008022d2 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8022d2:	55                   	push   %ebp
  8022d3:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022d5:	6a 00                	push   $0x0
  8022d7:	6a 00                	push   $0x0
  8022d9:	6a 00                	push   $0x0
  8022db:	6a 00                	push   $0x0
  8022dd:	6a 00                	push   $0x0
  8022df:	6a 25                	push   $0x25
  8022e1:	e8 93 fb ff ff       	call   801e79 <syscall>
  8022e6:	83 c4 18             	add    $0x18,%esp
  8022e9:	a3 60 c0 81 00       	mov    %eax,0x81c060
	return uheapPlaceStrategy ;
  8022ee:	a1 60 c0 81 00       	mov    0x81c060,%eax
}
  8022f3:	c9                   	leave  
  8022f4:	c3                   	ret    

008022f5 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8022f5:	55                   	push   %ebp
  8022f6:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8022f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fb:	a3 60 c0 81 00       	mov    %eax,0x81c060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802300:	6a 00                	push   $0x0
  802302:	6a 00                	push   $0x0
  802304:	6a 00                	push   $0x0
  802306:	6a 00                	push   $0x0
  802308:	ff 75 08             	pushl  0x8(%ebp)
  80230b:	6a 26                	push   $0x26
  80230d:	e8 67 fb ff ff       	call   801e79 <syscall>
  802312:	83 c4 18             	add    $0x18,%esp
	return ;
  802315:	90                   	nop
}
  802316:	c9                   	leave  
  802317:	c3                   	ret    

00802318 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802318:	55                   	push   %ebp
  802319:	89 e5                	mov    %esp,%ebp
  80231b:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80231c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80231f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802322:	8b 55 0c             	mov    0xc(%ebp),%edx
  802325:	8b 45 08             	mov    0x8(%ebp),%eax
  802328:	6a 00                	push   $0x0
  80232a:	53                   	push   %ebx
  80232b:	51                   	push   %ecx
  80232c:	52                   	push   %edx
  80232d:	50                   	push   %eax
  80232e:	6a 27                	push   $0x27
  802330:	e8 44 fb ff ff       	call   801e79 <syscall>
  802335:	83 c4 18             	add    $0x18,%esp
}
  802338:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80233b:	c9                   	leave  
  80233c:	c3                   	ret    

0080233d <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80233d:	55                   	push   %ebp
  80233e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802340:	8b 55 0c             	mov    0xc(%ebp),%edx
  802343:	8b 45 08             	mov    0x8(%ebp),%eax
  802346:	6a 00                	push   $0x0
  802348:	6a 00                	push   $0x0
  80234a:	6a 00                	push   $0x0
  80234c:	52                   	push   %edx
  80234d:	50                   	push   %eax
  80234e:	6a 28                	push   $0x28
  802350:	e8 24 fb ff ff       	call   801e79 <syscall>
  802355:	83 c4 18             	add    $0x18,%esp
}
  802358:	c9                   	leave  
  802359:	c3                   	ret    

0080235a <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80235a:	55                   	push   %ebp
  80235b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80235d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802360:	8b 55 0c             	mov    0xc(%ebp),%edx
  802363:	8b 45 08             	mov    0x8(%ebp),%eax
  802366:	6a 00                	push   $0x0
  802368:	51                   	push   %ecx
  802369:	ff 75 10             	pushl  0x10(%ebp)
  80236c:	52                   	push   %edx
  80236d:	50                   	push   %eax
  80236e:	6a 29                	push   $0x29
  802370:	e8 04 fb ff ff       	call   801e79 <syscall>
  802375:	83 c4 18             	add    $0x18,%esp
}
  802378:	c9                   	leave  
  802379:	c3                   	ret    

0080237a <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80237a:	55                   	push   %ebp
  80237b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80237d:	6a 00                	push   $0x0
  80237f:	6a 00                	push   $0x0
  802381:	ff 75 10             	pushl  0x10(%ebp)
  802384:	ff 75 0c             	pushl  0xc(%ebp)
  802387:	ff 75 08             	pushl  0x8(%ebp)
  80238a:	6a 12                	push   $0x12
  80238c:	e8 e8 fa ff ff       	call   801e79 <syscall>
  802391:	83 c4 18             	add    $0x18,%esp
	return ;
  802394:	90                   	nop
}
  802395:	c9                   	leave  
  802396:	c3                   	ret    

00802397 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802397:	55                   	push   %ebp
  802398:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80239a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80239d:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a0:	6a 00                	push   $0x0
  8023a2:	6a 00                	push   $0x0
  8023a4:	6a 00                	push   $0x0
  8023a6:	52                   	push   %edx
  8023a7:	50                   	push   %eax
  8023a8:	6a 2a                	push   $0x2a
  8023aa:	e8 ca fa ff ff       	call   801e79 <syscall>
  8023af:	83 c4 18             	add    $0x18,%esp
	return;
  8023b2:	90                   	nop
}
  8023b3:	c9                   	leave  
  8023b4:	c3                   	ret    

008023b5 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8023b5:	55                   	push   %ebp
  8023b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8023b8:	6a 00                	push   $0x0
  8023ba:	6a 00                	push   $0x0
  8023bc:	6a 00                	push   $0x0
  8023be:	6a 00                	push   $0x0
  8023c0:	6a 00                	push   $0x0
  8023c2:	6a 2b                	push   $0x2b
  8023c4:	e8 b0 fa ff ff       	call   801e79 <syscall>
  8023c9:	83 c4 18             	add    $0x18,%esp
}
  8023cc:	c9                   	leave  
  8023cd:	c3                   	ret    

008023ce <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8023ce:	55                   	push   %ebp
  8023cf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8023d1:	6a 00                	push   $0x0
  8023d3:	6a 00                	push   $0x0
  8023d5:	6a 00                	push   $0x0
  8023d7:	ff 75 0c             	pushl  0xc(%ebp)
  8023da:	ff 75 08             	pushl  0x8(%ebp)
  8023dd:	6a 2d                	push   $0x2d
  8023df:	e8 95 fa ff ff       	call   801e79 <syscall>
  8023e4:	83 c4 18             	add    $0x18,%esp
	return;
  8023e7:	90                   	nop
}
  8023e8:	c9                   	leave  
  8023e9:	c3                   	ret    

008023ea <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8023ea:	55                   	push   %ebp
  8023eb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8023ed:	6a 00                	push   $0x0
  8023ef:	6a 00                	push   $0x0
  8023f1:	6a 00                	push   $0x0
  8023f3:	ff 75 0c             	pushl  0xc(%ebp)
  8023f6:	ff 75 08             	pushl  0x8(%ebp)
  8023f9:	6a 2c                	push   $0x2c
  8023fb:	e8 79 fa ff ff       	call   801e79 <syscall>
  802400:	83 c4 18             	add    $0x18,%esp
	return ;
  802403:	90                   	nop
}
  802404:	c9                   	leave  
  802405:	c3                   	ret    

00802406 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  802406:	55                   	push   %ebp
  802407:	89 e5                	mov    %esp,%ebp
  802409:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  80240c:	83 ec 04             	sub    $0x4,%esp
  80240f:	68 88 31 80 00       	push   $0x803188
  802414:	68 25 01 00 00       	push   $0x125
  802419:	68 bb 31 80 00       	push   $0x8031bb
  80241e:	e8 e4 e4 ff ff       	call   800907 <_panic>

00802423 <to_page_va>:
//==================================================================================//
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  802423:	55                   	push   %ebp
  802424:	89 e5                	mov    %esp,%ebp
  802426:	83 ec 10             	sub    $0x10,%esp
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  802429:	8b 45 08             	mov    0x8(%ebp),%eax
  80242c:	ba 60 40 80 00       	mov    $0x804060,%edx
  802431:	29 d0                	sub    %edx,%eax
  802433:	c1 f8 02             	sar    $0x2,%eax
  802436:	89 c2                	mov    %eax,%edx
  802438:	89 d0                	mov    %edx,%eax
  80243a:	c1 e0 02             	shl    $0x2,%eax
  80243d:	01 d0                	add    %edx,%eax
  80243f:	c1 e0 02             	shl    $0x2,%eax
  802442:	01 d0                	add    %edx,%eax
  802444:	c1 e0 02             	shl    $0x2,%eax
  802447:	01 d0                	add    %edx,%eax
  802449:	89 c1                	mov    %eax,%ecx
  80244b:	c1 e1 08             	shl    $0x8,%ecx
  80244e:	01 c8                	add    %ecx,%eax
  802450:	89 c1                	mov    %eax,%ecx
  802452:	c1 e1 10             	shl    $0x10,%ecx
  802455:	01 c8                	add    %ecx,%eax
  802457:	01 c0                	add    %eax,%eax
  802459:	01 d0                	add    %edx,%eax
  80245b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  80245e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802461:	c1 e0 0c             	shl    $0xc,%eax
  802464:	89 c2                	mov    %eax,%edx
  802466:	a1 64 c0 81 00       	mov    0x81c064,%eax
  80246b:	01 d0                	add    %edx,%eax
}
  80246d:	c9                   	leave  
  80246e:	c3                   	ret    

0080246f <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  80246f:	55                   	push   %ebp
  802470:	89 e5                	mov    %esp,%ebp
  802472:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  802475:	8b 45 08             	mov    0x8(%ebp),%eax
  802478:	05 00 00 00 02       	add    $0x2000000,%eax
  80247d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802480:	73 16                	jae    802498 <initialize_dynamic_allocator+0x29>
  802482:	68 cc 31 80 00       	push   $0x8031cc
  802487:	68 f2 31 80 00       	push   $0x8031f2
  80248c:	6a 26                	push   $0x26
  80248e:	68 07 32 80 00       	push   $0x803207
  802493:	e8 6f e4 ff ff       	call   800907 <_panic>
		is_initialized = 1;
  802498:	c7 05 28 40 80 00 01 	movl   $0x1,0x804028
  80249f:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	//Comment the following line
	panic("initialize_dynamic_allocator() Not implemented yet");
  8024a2:	83 ec 04             	sub    $0x4,%esp
  8024a5:	68 20 32 80 00       	push   $0x803220
  8024aa:	6a 2e                	push   $0x2e
  8024ac:	68 07 32 80 00       	push   $0x803207
  8024b1:	e8 51 e4 ff ff       	call   800907 <_panic>

008024b6 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  8024b6:	55                   	push   %ebp
  8024b7:	89 e5                	mov    %esp,%ebp
  8024b9:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	//Comment the following line
	panic("get_block_size() Not implemented yet");
  8024bc:	83 ec 04             	sub    $0x4,%esp
  8024bf:	68 54 32 80 00       	push   $0x803254
  8024c4:	6a 3a                	push   $0x3a
  8024c6:	68 07 32 80 00       	push   $0x803207
  8024cb:	e8 37 e4 ff ff       	call   800907 <_panic>

008024d0 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  8024d0:	55                   	push   %ebp
  8024d1:	89 e5                	mov    %esp,%ebp
  8024d3:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  8024d6:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8024dd:	76 16                	jbe    8024f5 <alloc_block+0x25>
  8024df:	68 7c 32 80 00       	push   $0x80327c
  8024e4:	68 f2 31 80 00       	push   $0x8031f2
  8024e9:	6a 46                	push   $0x46
  8024eb:	68 07 32 80 00       	push   $0x803207
  8024f0:	e8 12 e4 ff ff       	call   800907 <_panic>
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	panic("alloc_block() Not implemented yet");
  8024f5:	83 ec 04             	sub    $0x4,%esp
  8024f8:	68 a0 32 80 00       	push   $0x8032a0
  8024fd:	6a 4d                	push   $0x4d
  8024ff:	68 07 32 80 00       	push   $0x803207
  802504:	e8 fe e3 ff ff       	call   800907 <_panic>

00802509 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  802509:	55                   	push   %ebp
  80250a:	89 e5                	mov    %esp,%ebp
  80250c:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  80250f:	8b 55 08             	mov    0x8(%ebp),%edx
  802512:	a1 64 c0 81 00       	mov    0x81c064,%eax
  802517:	39 c2                	cmp    %eax,%edx
  802519:	72 0c                	jb     802527 <free_block+0x1e>
  80251b:	8b 55 08             	mov    0x8(%ebp),%edx
  80251e:	a1 40 40 80 00       	mov    0x804040,%eax
  802523:	39 c2                	cmp    %eax,%edx
  802525:	72 16                	jb     80253d <free_block+0x34>
  802527:	68 c4 32 80 00       	push   $0x8032c4
  80252c:	68 f2 31 80 00       	push   $0x8031f2
  802531:	6a 5b                	push   $0x5b
  802533:	68 07 32 80 00       	push   $0x803207
  802538:	e8 ca e3 ff ff       	call   800907 <_panic>
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	panic("free_block() Not implemented yet");
  80253d:	83 ec 04             	sub    $0x4,%esp
  802540:	68 fc 32 80 00       	push   $0x8032fc
  802545:	6a 63                	push   $0x63
  802547:	68 07 32 80 00       	push   $0x803207
  80254c:	e8 b6 e3 ff ff       	call   800907 <_panic>

00802551 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  802551:	55                   	push   %ebp
  802552:	89 e5                	mov    %esp,%ebp
  802554:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  802557:	83 ec 04             	sub    $0x4,%esp
  80255a:	68 20 33 80 00       	push   $0x803320
  80255f:	6a 72                	push   $0x72
  802561:	68 07 32 80 00       	push   $0x803207
  802566:	e8 9c e3 ff ff       	call   800907 <_panic>
  80256b:	90                   	nop

0080256c <__udivdi3>:
  80256c:	55                   	push   %ebp
  80256d:	57                   	push   %edi
  80256e:	56                   	push   %esi
  80256f:	53                   	push   %ebx
  802570:	83 ec 1c             	sub    $0x1c,%esp
  802573:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802577:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80257b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80257f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802583:	89 ca                	mov    %ecx,%edx
  802585:	89 f8                	mov    %edi,%eax
  802587:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80258b:	85 f6                	test   %esi,%esi
  80258d:	75 2d                	jne    8025bc <__udivdi3+0x50>
  80258f:	39 cf                	cmp    %ecx,%edi
  802591:	77 65                	ja     8025f8 <__udivdi3+0x8c>
  802593:	89 fd                	mov    %edi,%ebp
  802595:	85 ff                	test   %edi,%edi
  802597:	75 0b                	jne    8025a4 <__udivdi3+0x38>
  802599:	b8 01 00 00 00       	mov    $0x1,%eax
  80259e:	31 d2                	xor    %edx,%edx
  8025a0:	f7 f7                	div    %edi
  8025a2:	89 c5                	mov    %eax,%ebp
  8025a4:	31 d2                	xor    %edx,%edx
  8025a6:	89 c8                	mov    %ecx,%eax
  8025a8:	f7 f5                	div    %ebp
  8025aa:	89 c1                	mov    %eax,%ecx
  8025ac:	89 d8                	mov    %ebx,%eax
  8025ae:	f7 f5                	div    %ebp
  8025b0:	89 cf                	mov    %ecx,%edi
  8025b2:	89 fa                	mov    %edi,%edx
  8025b4:	83 c4 1c             	add    $0x1c,%esp
  8025b7:	5b                   	pop    %ebx
  8025b8:	5e                   	pop    %esi
  8025b9:	5f                   	pop    %edi
  8025ba:	5d                   	pop    %ebp
  8025bb:	c3                   	ret    
  8025bc:	39 ce                	cmp    %ecx,%esi
  8025be:	77 28                	ja     8025e8 <__udivdi3+0x7c>
  8025c0:	0f bd fe             	bsr    %esi,%edi
  8025c3:	83 f7 1f             	xor    $0x1f,%edi
  8025c6:	75 40                	jne    802608 <__udivdi3+0x9c>
  8025c8:	39 ce                	cmp    %ecx,%esi
  8025ca:	72 0a                	jb     8025d6 <__udivdi3+0x6a>
  8025cc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8025d0:	0f 87 9e 00 00 00    	ja     802674 <__udivdi3+0x108>
  8025d6:	b8 01 00 00 00       	mov    $0x1,%eax
  8025db:	89 fa                	mov    %edi,%edx
  8025dd:	83 c4 1c             	add    $0x1c,%esp
  8025e0:	5b                   	pop    %ebx
  8025e1:	5e                   	pop    %esi
  8025e2:	5f                   	pop    %edi
  8025e3:	5d                   	pop    %ebp
  8025e4:	c3                   	ret    
  8025e5:	8d 76 00             	lea    0x0(%esi),%esi
  8025e8:	31 ff                	xor    %edi,%edi
  8025ea:	31 c0                	xor    %eax,%eax
  8025ec:	89 fa                	mov    %edi,%edx
  8025ee:	83 c4 1c             	add    $0x1c,%esp
  8025f1:	5b                   	pop    %ebx
  8025f2:	5e                   	pop    %esi
  8025f3:	5f                   	pop    %edi
  8025f4:	5d                   	pop    %ebp
  8025f5:	c3                   	ret    
  8025f6:	66 90                	xchg   %ax,%ax
  8025f8:	89 d8                	mov    %ebx,%eax
  8025fa:	f7 f7                	div    %edi
  8025fc:	31 ff                	xor    %edi,%edi
  8025fe:	89 fa                	mov    %edi,%edx
  802600:	83 c4 1c             	add    $0x1c,%esp
  802603:	5b                   	pop    %ebx
  802604:	5e                   	pop    %esi
  802605:	5f                   	pop    %edi
  802606:	5d                   	pop    %ebp
  802607:	c3                   	ret    
  802608:	bd 20 00 00 00       	mov    $0x20,%ebp
  80260d:	89 eb                	mov    %ebp,%ebx
  80260f:	29 fb                	sub    %edi,%ebx
  802611:	89 f9                	mov    %edi,%ecx
  802613:	d3 e6                	shl    %cl,%esi
  802615:	89 c5                	mov    %eax,%ebp
  802617:	88 d9                	mov    %bl,%cl
  802619:	d3 ed                	shr    %cl,%ebp
  80261b:	89 e9                	mov    %ebp,%ecx
  80261d:	09 f1                	or     %esi,%ecx
  80261f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802623:	89 f9                	mov    %edi,%ecx
  802625:	d3 e0                	shl    %cl,%eax
  802627:	89 c5                	mov    %eax,%ebp
  802629:	89 d6                	mov    %edx,%esi
  80262b:	88 d9                	mov    %bl,%cl
  80262d:	d3 ee                	shr    %cl,%esi
  80262f:	89 f9                	mov    %edi,%ecx
  802631:	d3 e2                	shl    %cl,%edx
  802633:	8b 44 24 08          	mov    0x8(%esp),%eax
  802637:	88 d9                	mov    %bl,%cl
  802639:	d3 e8                	shr    %cl,%eax
  80263b:	09 c2                	or     %eax,%edx
  80263d:	89 d0                	mov    %edx,%eax
  80263f:	89 f2                	mov    %esi,%edx
  802641:	f7 74 24 0c          	divl   0xc(%esp)
  802645:	89 d6                	mov    %edx,%esi
  802647:	89 c3                	mov    %eax,%ebx
  802649:	f7 e5                	mul    %ebp
  80264b:	39 d6                	cmp    %edx,%esi
  80264d:	72 19                	jb     802668 <__udivdi3+0xfc>
  80264f:	74 0b                	je     80265c <__udivdi3+0xf0>
  802651:	89 d8                	mov    %ebx,%eax
  802653:	31 ff                	xor    %edi,%edi
  802655:	e9 58 ff ff ff       	jmp    8025b2 <__udivdi3+0x46>
  80265a:	66 90                	xchg   %ax,%ax
  80265c:	8b 54 24 08          	mov    0x8(%esp),%edx
  802660:	89 f9                	mov    %edi,%ecx
  802662:	d3 e2                	shl    %cl,%edx
  802664:	39 c2                	cmp    %eax,%edx
  802666:	73 e9                	jae    802651 <__udivdi3+0xe5>
  802668:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80266b:	31 ff                	xor    %edi,%edi
  80266d:	e9 40 ff ff ff       	jmp    8025b2 <__udivdi3+0x46>
  802672:	66 90                	xchg   %ax,%ax
  802674:	31 c0                	xor    %eax,%eax
  802676:	e9 37 ff ff ff       	jmp    8025b2 <__udivdi3+0x46>
  80267b:	90                   	nop

0080267c <__umoddi3>:
  80267c:	55                   	push   %ebp
  80267d:	57                   	push   %edi
  80267e:	56                   	push   %esi
  80267f:	53                   	push   %ebx
  802680:	83 ec 1c             	sub    $0x1c,%esp
  802683:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802687:	8b 74 24 34          	mov    0x34(%esp),%esi
  80268b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80268f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802693:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802697:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80269b:	89 f3                	mov    %esi,%ebx
  80269d:	89 fa                	mov    %edi,%edx
  80269f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8026a3:	89 34 24             	mov    %esi,(%esp)
  8026a6:	85 c0                	test   %eax,%eax
  8026a8:	75 1a                	jne    8026c4 <__umoddi3+0x48>
  8026aa:	39 f7                	cmp    %esi,%edi
  8026ac:	0f 86 a2 00 00 00    	jbe    802754 <__umoddi3+0xd8>
  8026b2:	89 c8                	mov    %ecx,%eax
  8026b4:	89 f2                	mov    %esi,%edx
  8026b6:	f7 f7                	div    %edi
  8026b8:	89 d0                	mov    %edx,%eax
  8026ba:	31 d2                	xor    %edx,%edx
  8026bc:	83 c4 1c             	add    $0x1c,%esp
  8026bf:	5b                   	pop    %ebx
  8026c0:	5e                   	pop    %esi
  8026c1:	5f                   	pop    %edi
  8026c2:	5d                   	pop    %ebp
  8026c3:	c3                   	ret    
  8026c4:	39 f0                	cmp    %esi,%eax
  8026c6:	0f 87 ac 00 00 00    	ja     802778 <__umoddi3+0xfc>
  8026cc:	0f bd e8             	bsr    %eax,%ebp
  8026cf:	83 f5 1f             	xor    $0x1f,%ebp
  8026d2:	0f 84 ac 00 00 00    	je     802784 <__umoddi3+0x108>
  8026d8:	bf 20 00 00 00       	mov    $0x20,%edi
  8026dd:	29 ef                	sub    %ebp,%edi
  8026df:	89 fe                	mov    %edi,%esi
  8026e1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8026e5:	89 e9                	mov    %ebp,%ecx
  8026e7:	d3 e0                	shl    %cl,%eax
  8026e9:	89 d7                	mov    %edx,%edi
  8026eb:	89 f1                	mov    %esi,%ecx
  8026ed:	d3 ef                	shr    %cl,%edi
  8026ef:	09 c7                	or     %eax,%edi
  8026f1:	89 e9                	mov    %ebp,%ecx
  8026f3:	d3 e2                	shl    %cl,%edx
  8026f5:	89 14 24             	mov    %edx,(%esp)
  8026f8:	89 d8                	mov    %ebx,%eax
  8026fa:	d3 e0                	shl    %cl,%eax
  8026fc:	89 c2                	mov    %eax,%edx
  8026fe:	8b 44 24 08          	mov    0x8(%esp),%eax
  802702:	d3 e0                	shl    %cl,%eax
  802704:	89 44 24 04          	mov    %eax,0x4(%esp)
  802708:	8b 44 24 08          	mov    0x8(%esp),%eax
  80270c:	89 f1                	mov    %esi,%ecx
  80270e:	d3 e8                	shr    %cl,%eax
  802710:	09 d0                	or     %edx,%eax
  802712:	d3 eb                	shr    %cl,%ebx
  802714:	89 da                	mov    %ebx,%edx
  802716:	f7 f7                	div    %edi
  802718:	89 d3                	mov    %edx,%ebx
  80271a:	f7 24 24             	mull   (%esp)
  80271d:	89 c6                	mov    %eax,%esi
  80271f:	89 d1                	mov    %edx,%ecx
  802721:	39 d3                	cmp    %edx,%ebx
  802723:	0f 82 87 00 00 00    	jb     8027b0 <__umoddi3+0x134>
  802729:	0f 84 91 00 00 00    	je     8027c0 <__umoddi3+0x144>
  80272f:	8b 54 24 04          	mov    0x4(%esp),%edx
  802733:	29 f2                	sub    %esi,%edx
  802735:	19 cb                	sbb    %ecx,%ebx
  802737:	89 d8                	mov    %ebx,%eax
  802739:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80273d:	d3 e0                	shl    %cl,%eax
  80273f:	89 e9                	mov    %ebp,%ecx
  802741:	d3 ea                	shr    %cl,%edx
  802743:	09 d0                	or     %edx,%eax
  802745:	89 e9                	mov    %ebp,%ecx
  802747:	d3 eb                	shr    %cl,%ebx
  802749:	89 da                	mov    %ebx,%edx
  80274b:	83 c4 1c             	add    $0x1c,%esp
  80274e:	5b                   	pop    %ebx
  80274f:	5e                   	pop    %esi
  802750:	5f                   	pop    %edi
  802751:	5d                   	pop    %ebp
  802752:	c3                   	ret    
  802753:	90                   	nop
  802754:	89 fd                	mov    %edi,%ebp
  802756:	85 ff                	test   %edi,%edi
  802758:	75 0b                	jne    802765 <__umoddi3+0xe9>
  80275a:	b8 01 00 00 00       	mov    $0x1,%eax
  80275f:	31 d2                	xor    %edx,%edx
  802761:	f7 f7                	div    %edi
  802763:	89 c5                	mov    %eax,%ebp
  802765:	89 f0                	mov    %esi,%eax
  802767:	31 d2                	xor    %edx,%edx
  802769:	f7 f5                	div    %ebp
  80276b:	89 c8                	mov    %ecx,%eax
  80276d:	f7 f5                	div    %ebp
  80276f:	89 d0                	mov    %edx,%eax
  802771:	e9 44 ff ff ff       	jmp    8026ba <__umoddi3+0x3e>
  802776:	66 90                	xchg   %ax,%ax
  802778:	89 c8                	mov    %ecx,%eax
  80277a:	89 f2                	mov    %esi,%edx
  80277c:	83 c4 1c             	add    $0x1c,%esp
  80277f:	5b                   	pop    %ebx
  802780:	5e                   	pop    %esi
  802781:	5f                   	pop    %edi
  802782:	5d                   	pop    %ebp
  802783:	c3                   	ret    
  802784:	3b 04 24             	cmp    (%esp),%eax
  802787:	72 06                	jb     80278f <__umoddi3+0x113>
  802789:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80278d:	77 0f                	ja     80279e <__umoddi3+0x122>
  80278f:	89 f2                	mov    %esi,%edx
  802791:	29 f9                	sub    %edi,%ecx
  802793:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802797:	89 14 24             	mov    %edx,(%esp)
  80279a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80279e:	8b 44 24 04          	mov    0x4(%esp),%eax
  8027a2:	8b 14 24             	mov    (%esp),%edx
  8027a5:	83 c4 1c             	add    $0x1c,%esp
  8027a8:	5b                   	pop    %ebx
  8027a9:	5e                   	pop    %esi
  8027aa:	5f                   	pop    %edi
  8027ab:	5d                   	pop    %ebp
  8027ac:	c3                   	ret    
  8027ad:	8d 76 00             	lea    0x0(%esi),%esi
  8027b0:	2b 04 24             	sub    (%esp),%eax
  8027b3:	19 fa                	sbb    %edi,%edx
  8027b5:	89 d1                	mov    %edx,%ecx
  8027b7:	89 c6                	mov    %eax,%esi
  8027b9:	e9 71 ff ff ff       	jmp    80272f <__umoddi3+0xb3>
  8027be:	66 90                	xchg   %ax,%ax
  8027c0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8027c4:	72 ea                	jb     8027b0 <__umoddi3+0x134>
  8027c6:	89 d9                	mov    %ebx,%ecx
  8027c8:	e9 62 ff ff ff       	jmp    80272f <__umoddi3+0xb3>

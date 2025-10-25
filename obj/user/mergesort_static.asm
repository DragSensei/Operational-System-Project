
obj/user/mergesort_static:     file format elf32-i386


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
  800031:	e8 d5 06 00 00       	call   80070b <libmain>
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
  80004b:	e8 8d 1a 00 00       	call   801add <sys_lock_cons>

		cprintf("\n");
  800050:	83 ec 0c             	sub    $0xc,%esp
  800053:	68 80 22 80 00       	push   $0x802280
  800058:	e8 2c 0b 00 00       	call   800b89 <cprintf>
  80005d:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800060:	83 ec 0c             	sub    $0xc,%esp
  800063:	68 82 22 80 00       	push   $0x802282
  800068:	e8 1c 0b 00 00       	call   800b89 <cprintf>
  80006d:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!! MERGE SORT !!!!\n");
  800070:	83 ec 0c             	sub    $0xc,%esp
  800073:	68 98 22 80 00       	push   $0x802298
  800078:	e8 0c 0b 00 00       	call   800b89 <cprintf>
  80007d:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800080:	83 ec 0c             	sub    $0xc,%esp
  800083:	68 82 22 80 00       	push   $0x802282
  800088:	e8 fc 0a 00 00       	call   800b89 <cprintf>
  80008d:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800090:	83 ec 0c             	sub    $0xc,%esp
  800093:	68 80 22 80 00       	push   $0x802280
  800098:	e8 ec 0a 00 00       	call   800b89 <cprintf>
  80009d:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = 800000;
  8000a0:	c7 45 ec 00 35 0c 00 	movl   $0xc3500,-0x14(%ebp)
		cprintf("Enter the number of elements: %d\n", NumOfElements) ;
  8000a7:	83 ec 08             	sub    $0x8,%esp
  8000aa:	ff 75 ec             	pushl  -0x14(%ebp)
  8000ad:	68 b0 22 80 00       	push   $0x8022b0
  8000b2:	e8 d2 0a 00 00       	call   800b89 <cprintf>
  8000b7:	83 c4 10             	add    $0x10,%esp

		cprintf("Chose the initialization method:\n") ;
  8000ba:	83 ec 0c             	sub    $0xc,%esp
  8000bd:	68 d4 22 80 00       	push   $0x8022d4
  8000c2:	e8 c2 0a 00 00       	call   800b89 <cprintf>
  8000c7:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000ca:	83 ec 0c             	sub    $0xc,%esp
  8000cd:	68 f6 22 80 00       	push   $0x8022f6
  8000d2:	e8 b2 0a 00 00       	call   800b89 <cprintf>
  8000d7:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000da:	83 ec 0c             	sub    $0xc,%esp
  8000dd:	68 04 23 80 00       	push   $0x802304
  8000e2:	e8 a2 0a 00 00       	call   800b89 <cprintf>
  8000e7:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  8000ea:	83 ec 0c             	sub    $0xc,%esp
  8000ed:	68 13 23 80 00       	push   $0x802313
  8000f2:	e8 92 0a 00 00       	call   800b89 <cprintf>
  8000f7:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  8000fa:	83 ec 0c             	sub    $0xc,%esp
  8000fd:	68 23 23 80 00       	push   $0x802323
  800102:	e8 82 0a 00 00       	call   800b89 <cprintf>
  800107:	83 c4 10             	add    $0x10,%esp
			Chose = 'c' ;
  80010a:	c6 45 f7 63          	movb   $0x63,-0x9(%ebp)
			cputchar(Chose);
  80010e:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800112:	83 ec 0c             	sub    $0xc,%esp
  800115:	50                   	push   %eax
  800116:	e8 b4 05 00 00       	call   8006cf <cputchar>
  80011b:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  80011e:	83 ec 0c             	sub    $0xc,%esp
  800121:	6a 0a                	push   $0xa
  800123:	e8 a7 05 00 00       	call   8006cf <cputchar>
  800128:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  80012b:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  80012f:	74 0c                	je     80013d <_main+0x105>
  800131:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  800135:	74 06                	je     80013d <_main+0x105>
  800137:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  80013b:	75 bd                	jne    8000fa <_main+0xc2>

		//2012: lock the interrupt
		sys_unlock_cons();
  80013d:	e8 b5 19 00 00       	call   801af7 <sys_unlock_cons>

		//int *Elements = malloc(sizeof(int) * NumOfElements) ;
		int *Elements = __Elements;
  800142:	c7 45 e8 40 85 b2 00 	movl   $0xb28540,-0x18(%ebp)
		int  i ;
		switch (Chose)
  800149:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80014d:	83 f8 62             	cmp    $0x62,%eax
  800150:	74 1d                	je     80016f <_main+0x137>
  800152:	83 f8 63             	cmp    $0x63,%eax
  800155:	74 2b                	je     800182 <_main+0x14a>
  800157:	83 f8 61             	cmp    $0x61,%eax
  80015a:	75 39                	jne    800195 <_main+0x15d>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  80015c:	83 ec 08             	sub    $0x8,%esp
  80015f:	ff 75 ec             	pushl  -0x14(%ebp)
  800162:	ff 75 e8             	pushl  -0x18(%ebp)
  800165:	e8 e7 01 00 00       	call   800351 <InitializeAscending>
  80016a:	83 c4 10             	add    $0x10,%esp
			break ;
  80016d:	eb 37                	jmp    8001a6 <_main+0x16e>
		case 'b':
			InitializeIdentical(Elements, NumOfElements);
  80016f:	83 ec 08             	sub    $0x8,%esp
  800172:	ff 75 ec             	pushl  -0x14(%ebp)
  800175:	ff 75 e8             	pushl  -0x18(%ebp)
  800178:	e8 05 02 00 00       	call   800382 <InitializeIdentical>
  80017d:	83 c4 10             	add    $0x10,%esp
			break ;
  800180:	eb 24                	jmp    8001a6 <_main+0x16e>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  800182:	83 ec 08             	sub    $0x8,%esp
  800185:	ff 75 ec             	pushl  -0x14(%ebp)
  800188:	ff 75 e8             	pushl  -0x18(%ebp)
  80018b:	e8 27 02 00 00       	call   8003b7 <InitializeSemiRandom>
  800190:	83 c4 10             	add    $0x10,%esp
			break ;
  800193:	eb 11                	jmp    8001a6 <_main+0x16e>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  800195:	83 ec 08             	sub    $0x8,%esp
  800198:	ff 75 ec             	pushl  -0x14(%ebp)
  80019b:	ff 75 e8             	pushl  -0x18(%ebp)
  80019e:	e8 14 02 00 00       	call   8003b7 <InitializeSemiRandom>
  8001a3:	83 c4 10             	add    $0x10,%esp
		}

		MSort(Elements, 1, NumOfElements);
  8001a6:	83 ec 04             	sub    $0x4,%esp
  8001a9:	ff 75 ec             	pushl  -0x14(%ebp)
  8001ac:	6a 01                	push   $0x1
  8001ae:	ff 75 e8             	pushl  -0x18(%ebp)
  8001b1:	e8 e0 02 00 00       	call   800496 <MSort>
  8001b6:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8001b9:	e8 1f 19 00 00       	call   801add <sys_lock_cons>
		cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001be:	83 ec 0c             	sub    $0xc,%esp
  8001c1:	68 2c 23 80 00       	push   $0x80232c
  8001c6:	e8 be 09 00 00       	call   800b89 <cprintf>
  8001cb:	83 c4 10             	add    $0x10,%esp
		//PrintElements(Elements, NumOfElements);
		sys_unlock_cons();
  8001ce:	e8 24 19 00 00       	call   801af7 <sys_unlock_cons>

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001d3:	83 ec 08             	sub    $0x8,%esp
  8001d6:	ff 75 ec             	pushl  -0x14(%ebp)
  8001d9:	ff 75 e8             	pushl  -0x18(%ebp)
  8001dc:	e8 c6 00 00 00       	call   8002a7 <CheckSorted>
  8001e1:	83 c4 10             	add    $0x10,%esp
  8001e4:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  8001e7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8001eb:	75 14                	jne    800201 <_main+0x1c9>
  8001ed:	83 ec 04             	sub    $0x4,%esp
  8001f0:	68 60 23 80 00       	push   $0x802360
  8001f5:	6a 51                	push   $0x51
  8001f7:	68 82 23 80 00       	push   $0x802382
  8001fc:	e8 ba 06 00 00       	call   8008bb <_panic>
		else
		{
			sys_lock_cons();
  800201:	e8 d7 18 00 00       	call   801add <sys_lock_cons>
			cprintf("===============================================\n") ;
  800206:	83 ec 0c             	sub    $0xc,%esp
  800209:	68 9c 23 80 00       	push   $0x80239c
  80020e:	e8 76 09 00 00       	call   800b89 <cprintf>
  800213:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800216:	83 ec 0c             	sub    $0xc,%esp
  800219:	68 d0 23 80 00       	push   $0x8023d0
  80021e:	e8 66 09 00 00       	call   800b89 <cprintf>
  800223:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800226:	83 ec 0c             	sub    $0xc,%esp
  800229:	68 04 24 80 00       	push   $0x802404
  80022e:	e8 56 09 00 00       	call   800b89 <cprintf>
  800233:	83 c4 10             	add    $0x10,%esp
			sys_unlock_cons();
  800236:	e8 bc 18 00 00       	call   801af7 <sys_unlock_cons>
		}

		//free(Elements) ;

		sys_lock_cons();
  80023b:	e8 9d 18 00 00       	call   801add <sys_lock_cons>
		Chose = 0 ;
  800240:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
		while (Chose != 'y' && Chose != 'n')
  800244:	eb 3e                	jmp    800284 <_main+0x24c>
		{
			cprintf("Do you want to repeat (y/n): ") ;
  800246:	83 ec 0c             	sub    $0xc,%esp
  800249:	68 36 24 80 00       	push   $0x802436
  80024e:	e8 36 09 00 00       	call   800b89 <cprintf>
  800253:	83 c4 10             	add    $0x10,%esp
			Chose = 'n' ;
  800256:	c6 45 f7 6e          	movb   $0x6e,-0x9(%ebp)
			cputchar(Chose);
  80025a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80025e:	83 ec 0c             	sub    $0xc,%esp
  800261:	50                   	push   %eax
  800262:	e8 68 04 00 00       	call   8006cf <cputchar>
  800267:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  80026a:	83 ec 0c             	sub    $0xc,%esp
  80026d:	6a 0a                	push   $0xa
  80026f:	e8 5b 04 00 00       	call   8006cf <cputchar>
  800274:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800277:	83 ec 0c             	sub    $0xc,%esp
  80027a:	6a 0a                	push   $0xa
  80027c:	e8 4e 04 00 00       	call   8006cf <cputchar>
  800281:	83 c4 10             	add    $0x10,%esp

		//free(Elements) ;

		sys_lock_cons();
		Chose = 0 ;
		while (Chose != 'y' && Chose != 'n')
  800284:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  800288:	74 06                	je     800290 <_main+0x258>
  80028a:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  80028e:	75 b6                	jne    800246 <_main+0x20e>
			Chose = 'n' ;
			cputchar(Chose);
			cputchar('\n');
			cputchar('\n');
		}
		sys_unlock_cons();
  800290:	e8 62 18 00 00       	call   801af7 <sys_unlock_cons>

	} while (Chose == 'y');
  800295:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  800299:	0f 84 a9 fd ff ff    	je     800048 <_main+0x10>

	//To indicate that it's completed successfully
	inctst();
  80029f:	e8 f0 1b 00 00       	call   801e94 <inctst>

}
  8002a4:	90                   	nop
  8002a5:	c9                   	leave  
  8002a6:	c3                   	ret    

008002a7 <CheckSorted>:


uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8002a7:	55                   	push   %ebp
  8002a8:	89 e5                	mov    %esp,%ebp
  8002aa:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8002ad:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8002b4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8002bb:	eb 33                	jmp    8002f0 <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8002bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002c0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ca:	01 d0                	add    %edx,%eax
  8002cc:	8b 10                	mov    (%eax),%edx
  8002ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002d1:	40                   	inc    %eax
  8002d2:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8002dc:	01 c8                	add    %ecx,%eax
  8002de:	8b 00                	mov    (%eax),%eax
  8002e0:	39 c2                	cmp    %eax,%edx
  8002e2:	7e 09                	jle    8002ed <CheckSorted+0x46>
		{
			Sorted = 0 ;
  8002e4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  8002eb:	eb 0c                	jmp    8002f9 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8002ed:	ff 45 f8             	incl   -0x8(%ebp)
  8002f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002f3:	48                   	dec    %eax
  8002f4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8002f7:	7f c4                	jg     8002bd <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  8002f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8002fc:	c9                   	leave  
  8002fd:	c3                   	ret    

008002fe <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  8002fe:	55                   	push   %ebp
  8002ff:	89 e5                	mov    %esp,%ebp
  800301:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800304:	8b 45 0c             	mov    0xc(%ebp),%eax
  800307:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80030e:	8b 45 08             	mov    0x8(%ebp),%eax
  800311:	01 d0                	add    %edx,%eax
  800313:	8b 00                	mov    (%eax),%eax
  800315:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800318:	8b 45 0c             	mov    0xc(%ebp),%eax
  80031b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800322:	8b 45 08             	mov    0x8(%ebp),%eax
  800325:	01 c2                	add    %eax,%edx
  800327:	8b 45 10             	mov    0x10(%ebp),%eax
  80032a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800331:	8b 45 08             	mov    0x8(%ebp),%eax
  800334:	01 c8                	add    %ecx,%eax
  800336:	8b 00                	mov    (%eax),%eax
  800338:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  80033a:	8b 45 10             	mov    0x10(%ebp),%eax
  80033d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800344:	8b 45 08             	mov    0x8(%ebp),%eax
  800347:	01 c2                	add    %eax,%edx
  800349:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80034c:	89 02                	mov    %eax,(%edx)
}
  80034e:	90                   	nop
  80034f:	c9                   	leave  
  800350:	c3                   	ret    

00800351 <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  800351:	55                   	push   %ebp
  800352:	89 e5                	mov    %esp,%ebp
  800354:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800357:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80035e:	eb 17                	jmp    800377 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  800360:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800363:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80036a:	8b 45 08             	mov    0x8(%ebp),%eax
  80036d:	01 c2                	add    %eax,%edx
  80036f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800372:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800374:	ff 45 fc             	incl   -0x4(%ebp)
  800377:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80037a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80037d:	7c e1                	jl     800360 <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  80037f:	90                   	nop
  800380:	c9                   	leave  
  800381:	c3                   	ret    

00800382 <InitializeIdentical>:

void InitializeIdentical(int *Elements, int NumOfElements)
{
  800382:	55                   	push   %ebp
  800383:	89 e5                	mov    %esp,%ebp
  800385:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800388:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80038f:	eb 1b                	jmp    8003ac <InitializeIdentical+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  800391:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800394:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80039b:	8b 45 08             	mov    0x8(%ebp),%eax
  80039e:	01 c2                	add    %eax,%edx
  8003a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003a3:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8003a6:	48                   	dec    %eax
  8003a7:	89 02                	mov    %eax,(%edx)
}

void InitializeIdentical(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003a9:	ff 45 fc             	incl   -0x4(%ebp)
  8003ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003af:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003b2:	7c dd                	jl     800391 <InitializeIdentical+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8003b4:	90                   	nop
  8003b5:	c9                   	leave  
  8003b6:	c3                   	ret    

008003b7 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8003b7:	55                   	push   %ebp
  8003b8:	89 e5                	mov    %esp,%ebp
  8003ba:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8003bd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003c0:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8003c5:	f7 e9                	imul   %ecx
  8003c7:	c1 f9 1f             	sar    $0x1f,%ecx
  8003ca:	89 d0                	mov    %edx,%eax
  8003cc:	29 c8                	sub    %ecx,%eax
  8003ce:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (Repetition == 0)
  8003d1:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8003d5:	75 07                	jne    8003de <InitializeSemiRandom+0x27>
			Repetition = 3;
  8003d7:	c7 45 f8 03 00 00 00 	movl   $0x3,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8003de:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003e5:	eb 1e                	jmp    800405 <InitializeSemiRandom+0x4e>
	{
		Elements[i] = i % Repetition ;
  8003e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003ea:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f4:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8003f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003fa:	99                   	cltd   
  8003fb:	f7 7d f8             	idivl  -0x8(%ebp)
  8003fe:	89 d0                	mov    %edx,%eax
  800400:	89 01                	mov    %eax,(%ecx)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	if (Repetition == 0)
			Repetition = 3;
	for (i = 0 ; i < NumOfElements ; i++)
  800402:	ff 45 fc             	incl   -0x4(%ebp)
  800405:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800408:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80040b:	7c da                	jl     8003e7 <InitializeSemiRandom+0x30>
	{
		Elements[i] = i % Repetition ;
		//	cprintf("i=%d\n",i);
	}

}
  80040d:	90                   	nop
  80040e:	c9                   	leave  
  80040f:	c3                   	ret    

00800410 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  800410:	55                   	push   %ebp
  800411:	89 e5                	mov    %esp,%ebp
  800413:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800416:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80041d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800424:	eb 42                	jmp    800468 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800426:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800429:	99                   	cltd   
  80042a:	f7 7d f0             	idivl  -0x10(%ebp)
  80042d:	89 d0                	mov    %edx,%eax
  80042f:	85 c0                	test   %eax,%eax
  800431:	75 10                	jne    800443 <PrintElements+0x33>
			cprintf("\n");
  800433:	83 ec 0c             	sub    $0xc,%esp
  800436:	68 80 22 80 00       	push   $0x802280
  80043b:	e8 49 07 00 00       	call   800b89 <cprintf>
  800440:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800443:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800446:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80044d:	8b 45 08             	mov    0x8(%ebp),%eax
  800450:	01 d0                	add    %edx,%eax
  800452:	8b 00                	mov    (%eax),%eax
  800454:	83 ec 08             	sub    $0x8,%esp
  800457:	50                   	push   %eax
  800458:	68 54 24 80 00       	push   $0x802454
  80045d:	e8 27 07 00 00       	call   800b89 <cprintf>
  800462:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800465:	ff 45 f4             	incl   -0xc(%ebp)
  800468:	8b 45 0c             	mov    0xc(%ebp),%eax
  80046b:	48                   	dec    %eax
  80046c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80046f:	7f b5                	jg     800426 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  800471:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800474:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80047b:	8b 45 08             	mov    0x8(%ebp),%eax
  80047e:	01 d0                	add    %edx,%eax
  800480:	8b 00                	mov    (%eax),%eax
  800482:	83 ec 08             	sub    $0x8,%esp
  800485:	50                   	push   %eax
  800486:	68 59 24 80 00       	push   $0x802459
  80048b:	e8 f9 06 00 00       	call   800b89 <cprintf>
  800490:	83 c4 10             	add    $0x10,%esp

}
  800493:	90                   	nop
  800494:	c9                   	leave  
  800495:	c3                   	ret    

00800496 <MSort>:


void MSort(int* A, int p, int r)
{
  800496:	55                   	push   %ebp
  800497:	89 e5                	mov    %esp,%ebp
  800499:	83 ec 18             	sub    $0x18,%esp
	if (p >= r)
  80049c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80049f:	3b 45 10             	cmp    0x10(%ebp),%eax
  8004a2:	7d 54                	jge    8004f8 <MSort+0x62>
	{
		return;
	}

	int q = (p + r) / 2;
  8004a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8004aa:	01 d0                	add    %edx,%eax
  8004ac:	89 c2                	mov    %eax,%edx
  8004ae:	c1 ea 1f             	shr    $0x1f,%edx
  8004b1:	01 d0                	add    %edx,%eax
  8004b3:	d1 f8                	sar    %eax
  8004b5:	89 45 f4             	mov    %eax,-0xc(%ebp)

	MSort(A, p, q);
  8004b8:	83 ec 04             	sub    $0x4,%esp
  8004bb:	ff 75 f4             	pushl  -0xc(%ebp)
  8004be:	ff 75 0c             	pushl  0xc(%ebp)
  8004c1:	ff 75 08             	pushl  0x8(%ebp)
  8004c4:	e8 cd ff ff ff       	call   800496 <MSort>
  8004c9:	83 c4 10             	add    $0x10,%esp

	MSort(A, q + 1, r);
  8004cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004cf:	40                   	inc    %eax
  8004d0:	83 ec 04             	sub    $0x4,%esp
  8004d3:	ff 75 10             	pushl  0x10(%ebp)
  8004d6:	50                   	push   %eax
  8004d7:	ff 75 08             	pushl  0x8(%ebp)
  8004da:	e8 b7 ff ff ff       	call   800496 <MSort>
  8004df:	83 c4 10             	add    $0x10,%esp

	Merge(A, p, q, r);
  8004e2:	ff 75 10             	pushl  0x10(%ebp)
  8004e5:	ff 75 f4             	pushl  -0xc(%ebp)
  8004e8:	ff 75 0c             	pushl  0xc(%ebp)
  8004eb:	ff 75 08             	pushl  0x8(%ebp)
  8004ee:	e8 08 00 00 00       	call   8004fb <Merge>
  8004f3:	83 c4 10             	add    $0x10,%esp
  8004f6:	eb 01                	jmp    8004f9 <MSort+0x63>

void MSort(int* A, int p, int r)
{
	if (p >= r)
	{
		return;
  8004f8:	90                   	nop

	MSort(A, q + 1, r);

	Merge(A, p, q, r);

}
  8004f9:	c9                   	leave  
  8004fa:	c3                   	ret    

008004fb <Merge>:

void Merge(int* A, int p, int q, int r)
{
  8004fb:	55                   	push   %ebp
  8004fc:	89 e5                	mov    %esp,%ebp
  8004fe:	83 ec 30             	sub    $0x30,%esp
	int leftCapacity = q - p + 1;
  800501:	8b 45 10             	mov    0x10(%ebp),%eax
  800504:	2b 45 0c             	sub    0xc(%ebp),%eax
  800507:	40                   	inc    %eax
  800508:	89 45 e8             	mov    %eax,-0x18(%ebp)

	int rightCapacity = r - q;
  80050b:	8b 45 14             	mov    0x14(%ebp),%eax
  80050e:	2b 45 10             	sub    0x10(%ebp),%eax
  800511:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	int leftIndex = 0;
  800514:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

	int rightIndex = 0;
  80051b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	//int* Left = malloc(sizeof(int) * leftCapacity);
	int* Left = __Left ;
  800522:	c7 45 e0 60 30 80 00 	movl   $0x803060,-0x20(%ebp)
	int* Right = __Right;
  800529:	c7 45 dc 40 59 e3 00 	movl   $0xe35940,-0x24(%ebp)

	//	int Left[5000] ;
	//	int Right[5000] ;

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  800530:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800537:	eb 2f                	jmp    800568 <Merge+0x6d>
	{
		Left[i] = A[p + i - 1];
  800539:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80053c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800543:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800546:	01 c2                	add    %eax,%edx
  800548:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80054b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80054e:	01 c8                	add    %ecx,%eax
  800550:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800555:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80055c:	8b 45 08             	mov    0x8(%ebp),%eax
  80055f:	01 c8                	add    %ecx,%eax
  800561:	8b 00                	mov    (%eax),%eax
  800563:	89 02                	mov    %eax,(%edx)

	//	int Left[5000] ;
	//	int Right[5000] ;

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  800565:	ff 45 f4             	incl   -0xc(%ebp)
  800568:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80056b:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80056e:	7c c9                	jl     800539 <Merge+0x3e>
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  800570:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800577:	eb 2a                	jmp    8005a3 <Merge+0xa8>
	{
		Right[j] = A[q + j];
  800579:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80057c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800583:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800586:	01 c2                	add    %eax,%edx
  800588:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80058b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80058e:	01 c8                	add    %ecx,%eax
  800590:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800597:	8b 45 08             	mov    0x8(%ebp),%eax
  80059a:	01 c8                	add    %ecx,%eax
  80059c:	8b 00                	mov    (%eax),%eax
  80059e:	89 02                	mov    %eax,(%edx)
	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8005a0:	ff 45 f0             	incl   -0x10(%ebp)
  8005a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005a6:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8005a9:	7c ce                	jl     800579 <Merge+0x7e>
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8005ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005ae:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8005b1:	e9 0a 01 00 00       	jmp    8006c0 <Merge+0x1c5>
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
  8005b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8005b9:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8005bc:	0f 8d 95 00 00 00    	jge    800657 <Merge+0x15c>
  8005c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8005c5:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8005c8:	0f 8d 89 00 00 00    	jge    800657 <Merge+0x15c>
		{
			if (Left[leftIndex] < Right[rightIndex] )
  8005ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8005d1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005db:	01 d0                	add    %edx,%eax
  8005dd:	8b 10                	mov    (%eax),%edx
  8005df:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8005e2:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005e9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005ec:	01 c8                	add    %ecx,%eax
  8005ee:	8b 00                	mov    (%eax),%eax
  8005f0:	39 c2                	cmp    %eax,%edx
  8005f2:	7d 33                	jge    800627 <Merge+0x12c>
			{
				A[k - 1] = Left[leftIndex++];
  8005f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005f7:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8005fc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800603:	8b 45 08             	mov    0x8(%ebp),%eax
  800606:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800609:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80060c:	8d 50 01             	lea    0x1(%eax),%edx
  80060f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800612:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800619:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80061c:	01 d0                	add    %edx,%eax
  80061e:	8b 00                	mov    (%eax),%eax
  800620:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800622:	e9 96 00 00 00       	jmp    8006bd <Merge+0x1c2>
			{
				A[k - 1] = Left[leftIndex++];
			}
			else
			{
				A[k - 1] = Right[rightIndex++];
  800627:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80062a:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80062f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800636:	8b 45 08             	mov    0x8(%ebp),%eax
  800639:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80063c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80063f:	8d 50 01             	lea    0x1(%eax),%edx
  800642:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800645:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80064c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80064f:	01 d0                	add    %edx,%eax
  800651:	8b 00                	mov    (%eax),%eax
  800653:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800655:	eb 66                	jmp    8006bd <Merge+0x1c2>
			else
			{
				A[k - 1] = Right[rightIndex++];
			}
		}
		else if (leftIndex < leftCapacity)
  800657:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80065a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80065d:	7d 30                	jge    80068f <Merge+0x194>
		{
			A[k - 1] = Left[leftIndex++];
  80065f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800662:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800667:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80066e:	8b 45 08             	mov    0x8(%ebp),%eax
  800671:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800674:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800677:	8d 50 01             	lea    0x1(%eax),%edx
  80067a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80067d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800684:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800687:	01 d0                	add    %edx,%eax
  800689:	8b 00                	mov    (%eax),%eax
  80068b:	89 01                	mov    %eax,(%ecx)
  80068d:	eb 2e                	jmp    8006bd <Merge+0x1c2>
		}
		else
		{
			A[k - 1] = Right[rightIndex++];
  80068f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800692:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800697:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80069e:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a1:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8006a7:	8d 50 01             	lea    0x1(%eax),%edx
  8006aa:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8006ad:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006b4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8006b7:	01 d0                	add    %edx,%eax
  8006b9:	8b 00                	mov    (%eax),%eax
  8006bb:	89 01                	mov    %eax,(%ecx)
	for (j = 0; j < rightCapacity; j++)
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8006bd:	ff 45 ec             	incl   -0x14(%ebp)
  8006c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8006c3:	3b 45 14             	cmp    0x14(%ebp),%eax
  8006c6:	0f 8e ea fe ff ff    	jle    8005b6 <Merge+0xbb>
		{
			A[k - 1] = Right[rightIndex++];
		}
	}

}
  8006cc:	90                   	nop
  8006cd:	c9                   	leave  
  8006ce:	c3                   	ret    

008006cf <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8006cf:	55                   	push   %ebp
  8006d0:	89 e5                	mov    %esp,%ebp
  8006d2:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8006d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d8:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8006db:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8006df:	83 ec 0c             	sub    $0xc,%esp
  8006e2:	50                   	push   %eax
  8006e3:	e8 3d 15 00 00       	call   801c25 <sys_cputc>
  8006e8:	83 c4 10             	add    $0x10,%esp
}
  8006eb:	90                   	nop
  8006ec:	c9                   	leave  
  8006ed:	c3                   	ret    

008006ee <getchar>:


int
getchar(void)
{
  8006ee:	55                   	push   %ebp
  8006ef:	89 e5                	mov    %esp,%ebp
  8006f1:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  8006f4:	e8 cb 13 00 00       	call   801ac4 <sys_cgetc>
  8006f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  8006fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8006ff:	c9                   	leave  
  800700:	c3                   	ret    

00800701 <iscons>:

int iscons(int fdnum)
{
  800701:	55                   	push   %ebp
  800702:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  800704:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800709:	5d                   	pop    %ebp
  80070a:	c3                   	ret    

0080070b <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80070b:	55                   	push   %ebp
  80070c:	89 e5                	mov    %esp,%ebp
  80070e:	57                   	push   %edi
  80070f:	56                   	push   %esi
  800710:	53                   	push   %ebx
  800711:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800714:	e8 3d 16 00 00       	call   801d56 <sys_getenvindex>
  800719:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  80071c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80071f:	89 d0                	mov    %edx,%eax
  800721:	c1 e0 02             	shl    $0x2,%eax
  800724:	01 d0                	add    %edx,%eax
  800726:	c1 e0 03             	shl    $0x3,%eax
  800729:	01 d0                	add    %edx,%eax
  80072b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800732:	01 d0                	add    %edx,%eax
  800734:	c1 e0 02             	shl    $0x2,%eax
  800737:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80073c:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800741:	a1 20 30 80 00       	mov    0x803020,%eax
  800746:	8a 40 20             	mov    0x20(%eax),%al
  800749:	84 c0                	test   %al,%al
  80074b:	74 0d                	je     80075a <libmain+0x4f>
		binaryname = myEnv->prog_name;
  80074d:	a1 20 30 80 00       	mov    0x803020,%eax
  800752:	83 c0 20             	add    $0x20,%eax
  800755:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80075a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80075e:	7e 0a                	jle    80076a <libmain+0x5f>
		binaryname = argv[0];
  800760:	8b 45 0c             	mov    0xc(%ebp),%eax
  800763:	8b 00                	mov    (%eax),%eax
  800765:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  80076a:	83 ec 08             	sub    $0x8,%esp
  80076d:	ff 75 0c             	pushl  0xc(%ebp)
  800770:	ff 75 08             	pushl  0x8(%ebp)
  800773:	e8 c0 f8 ff ff       	call   800038 <_main>
  800778:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80077b:	a1 00 30 80 00       	mov    0x803000,%eax
  800780:	85 c0                	test   %eax,%eax
  800782:	0f 84 01 01 00 00    	je     800889 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800788:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80078e:	bb 58 25 80 00       	mov    $0x802558,%ebx
  800793:	ba 0e 00 00 00       	mov    $0xe,%edx
  800798:	89 c7                	mov    %eax,%edi
  80079a:	89 de                	mov    %ebx,%esi
  80079c:	89 d1                	mov    %edx,%ecx
  80079e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8007a0:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8007a3:	b9 56 00 00 00       	mov    $0x56,%ecx
  8007a8:	b0 00                	mov    $0x0,%al
  8007aa:	89 d7                	mov    %edx,%edi
  8007ac:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8007ae:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8007b5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8007b8:	83 ec 08             	sub    $0x8,%esp
  8007bb:	50                   	push   %eax
  8007bc:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8007c2:	50                   	push   %eax
  8007c3:	e8 c4 17 00 00       	call   801f8c <sys_utilities>
  8007c8:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8007cb:	e8 0d 13 00 00       	call   801add <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8007d0:	83 ec 0c             	sub    $0xc,%esp
  8007d3:	68 78 24 80 00       	push   $0x802478
  8007d8:	e8 ac 03 00 00       	call   800b89 <cprintf>
  8007dd:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8007e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007e3:	85 c0                	test   %eax,%eax
  8007e5:	74 18                	je     8007ff <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8007e7:	e8 be 17 00 00       	call   801faa <sys_get_optimal_num_faults>
  8007ec:	83 ec 08             	sub    $0x8,%esp
  8007ef:	50                   	push   %eax
  8007f0:	68 a0 24 80 00       	push   $0x8024a0
  8007f5:	e8 8f 03 00 00       	call   800b89 <cprintf>
  8007fa:	83 c4 10             	add    $0x10,%esp
  8007fd:	eb 59                	jmp    800858 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8007ff:	a1 20 30 80 00       	mov    0x803020,%eax
  800804:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  80080a:	a1 20 30 80 00       	mov    0x803020,%eax
  80080f:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  800815:	83 ec 04             	sub    $0x4,%esp
  800818:	52                   	push   %edx
  800819:	50                   	push   %eax
  80081a:	68 c4 24 80 00       	push   $0x8024c4
  80081f:	e8 65 03 00 00       	call   800b89 <cprintf>
  800824:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800827:	a1 20 30 80 00       	mov    0x803020,%eax
  80082c:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800832:	a1 20 30 80 00       	mov    0x803020,%eax
  800837:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  80083d:	a1 20 30 80 00       	mov    0x803020,%eax
  800842:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  800848:	51                   	push   %ecx
  800849:	52                   	push   %edx
  80084a:	50                   	push   %eax
  80084b:	68 ec 24 80 00       	push   $0x8024ec
  800850:	e8 34 03 00 00       	call   800b89 <cprintf>
  800855:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800858:	a1 20 30 80 00       	mov    0x803020,%eax
  80085d:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  800863:	83 ec 08             	sub    $0x8,%esp
  800866:	50                   	push   %eax
  800867:	68 44 25 80 00       	push   $0x802544
  80086c:	e8 18 03 00 00       	call   800b89 <cprintf>
  800871:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800874:	83 ec 0c             	sub    $0xc,%esp
  800877:	68 78 24 80 00       	push   $0x802478
  80087c:	e8 08 03 00 00       	call   800b89 <cprintf>
  800881:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800884:	e8 6e 12 00 00       	call   801af7 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800889:	e8 1f 00 00 00       	call   8008ad <exit>
}
  80088e:	90                   	nop
  80088f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800892:	5b                   	pop    %ebx
  800893:	5e                   	pop    %esi
  800894:	5f                   	pop    %edi
  800895:	5d                   	pop    %ebp
  800896:	c3                   	ret    

00800897 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800897:	55                   	push   %ebp
  800898:	89 e5                	mov    %esp,%ebp
  80089a:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80089d:	83 ec 0c             	sub    $0xc,%esp
  8008a0:	6a 00                	push   $0x0
  8008a2:	e8 7b 14 00 00       	call   801d22 <sys_destroy_env>
  8008a7:	83 c4 10             	add    $0x10,%esp
}
  8008aa:	90                   	nop
  8008ab:	c9                   	leave  
  8008ac:	c3                   	ret    

008008ad <exit>:

void
exit(void)
{
  8008ad:	55                   	push   %ebp
  8008ae:	89 e5                	mov    %esp,%ebp
  8008b0:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8008b3:	e8 d0 14 00 00       	call   801d88 <sys_exit_env>
}
  8008b8:	90                   	nop
  8008b9:	c9                   	leave  
  8008ba:	c3                   	ret    

008008bb <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8008bb:	55                   	push   %ebp
  8008bc:	89 e5                	mov    %esp,%ebp
  8008be:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8008c1:	8d 45 10             	lea    0x10(%ebp),%eax
  8008c4:	83 c0 04             	add    $0x4,%eax
  8008c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8008ca:	a1 44 2d 14 01       	mov    0x1142d44,%eax
  8008cf:	85 c0                	test   %eax,%eax
  8008d1:	74 16                	je     8008e9 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8008d3:	a1 44 2d 14 01       	mov    0x1142d44,%eax
  8008d8:	83 ec 08             	sub    $0x8,%esp
  8008db:	50                   	push   %eax
  8008dc:	68 bc 25 80 00       	push   $0x8025bc
  8008e1:	e8 a3 02 00 00       	call   800b89 <cprintf>
  8008e6:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8008e9:	a1 04 30 80 00       	mov    0x803004,%eax
  8008ee:	83 ec 0c             	sub    $0xc,%esp
  8008f1:	ff 75 0c             	pushl  0xc(%ebp)
  8008f4:	ff 75 08             	pushl  0x8(%ebp)
  8008f7:	50                   	push   %eax
  8008f8:	68 c4 25 80 00       	push   $0x8025c4
  8008fd:	6a 74                	push   $0x74
  8008ff:	e8 b2 02 00 00       	call   800bb6 <cprintf_colored>
  800904:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800907:	8b 45 10             	mov    0x10(%ebp),%eax
  80090a:	83 ec 08             	sub    $0x8,%esp
  80090d:	ff 75 f4             	pushl  -0xc(%ebp)
  800910:	50                   	push   %eax
  800911:	e8 04 02 00 00       	call   800b1a <vcprintf>
  800916:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800919:	83 ec 08             	sub    $0x8,%esp
  80091c:	6a 00                	push   $0x0
  80091e:	68 ec 25 80 00       	push   $0x8025ec
  800923:	e8 f2 01 00 00       	call   800b1a <vcprintf>
  800928:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80092b:	e8 7d ff ff ff       	call   8008ad <exit>

	// should not return here
	while (1) ;
  800930:	eb fe                	jmp    800930 <_panic+0x75>

00800932 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800932:	55                   	push   %ebp
  800933:	89 e5                	mov    %esp,%ebp
  800935:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800938:	a1 20 30 80 00       	mov    0x803020,%eax
  80093d:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800943:	8b 45 0c             	mov    0xc(%ebp),%eax
  800946:	39 c2                	cmp    %eax,%edx
  800948:	74 14                	je     80095e <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80094a:	83 ec 04             	sub    $0x4,%esp
  80094d:	68 f0 25 80 00       	push   $0x8025f0
  800952:	6a 26                	push   $0x26
  800954:	68 3c 26 80 00       	push   $0x80263c
  800959:	e8 5d ff ff ff       	call   8008bb <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80095e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800965:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80096c:	e9 c5 00 00 00       	jmp    800a36 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800971:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800974:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80097b:	8b 45 08             	mov    0x8(%ebp),%eax
  80097e:	01 d0                	add    %edx,%eax
  800980:	8b 00                	mov    (%eax),%eax
  800982:	85 c0                	test   %eax,%eax
  800984:	75 08                	jne    80098e <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800986:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800989:	e9 a5 00 00 00       	jmp    800a33 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80098e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800995:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80099c:	eb 69                	jmp    800a07 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80099e:	a1 20 30 80 00       	mov    0x803020,%eax
  8009a3:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8009a9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009ac:	89 d0                	mov    %edx,%eax
  8009ae:	01 c0                	add    %eax,%eax
  8009b0:	01 d0                	add    %edx,%eax
  8009b2:	c1 e0 03             	shl    $0x3,%eax
  8009b5:	01 c8                	add    %ecx,%eax
  8009b7:	8a 40 04             	mov    0x4(%eax),%al
  8009ba:	84 c0                	test   %al,%al
  8009bc:	75 46                	jne    800a04 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8009be:	a1 20 30 80 00       	mov    0x803020,%eax
  8009c3:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8009c9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009cc:	89 d0                	mov    %edx,%eax
  8009ce:	01 c0                	add    %eax,%eax
  8009d0:	01 d0                	add    %edx,%eax
  8009d2:	c1 e0 03             	shl    $0x3,%eax
  8009d5:	01 c8                	add    %ecx,%eax
  8009d7:	8b 00                	mov    (%eax),%eax
  8009d9:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8009dc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8009df:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8009e4:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8009e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009e9:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8009f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f3:	01 c8                	add    %ecx,%eax
  8009f5:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8009f7:	39 c2                	cmp    %eax,%edx
  8009f9:	75 09                	jne    800a04 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8009fb:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800a02:	eb 15                	jmp    800a19 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a04:	ff 45 e8             	incl   -0x18(%ebp)
  800a07:	a1 20 30 80 00       	mov    0x803020,%eax
  800a0c:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800a12:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a15:	39 c2                	cmp    %eax,%edx
  800a17:	77 85                	ja     80099e <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800a19:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800a1d:	75 14                	jne    800a33 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800a1f:	83 ec 04             	sub    $0x4,%esp
  800a22:	68 48 26 80 00       	push   $0x802648
  800a27:	6a 3a                	push   $0x3a
  800a29:	68 3c 26 80 00       	push   $0x80263c
  800a2e:	e8 88 fe ff ff       	call   8008bb <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800a33:	ff 45 f0             	incl   -0x10(%ebp)
  800a36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a39:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800a3c:	0f 8c 2f ff ff ff    	jl     800971 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800a42:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a49:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800a50:	eb 26                	jmp    800a78 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800a52:	a1 20 30 80 00       	mov    0x803020,%eax
  800a57:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800a5d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a60:	89 d0                	mov    %edx,%eax
  800a62:	01 c0                	add    %eax,%eax
  800a64:	01 d0                	add    %edx,%eax
  800a66:	c1 e0 03             	shl    $0x3,%eax
  800a69:	01 c8                	add    %ecx,%eax
  800a6b:	8a 40 04             	mov    0x4(%eax),%al
  800a6e:	3c 01                	cmp    $0x1,%al
  800a70:	75 03                	jne    800a75 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800a72:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a75:	ff 45 e0             	incl   -0x20(%ebp)
  800a78:	a1 20 30 80 00       	mov    0x803020,%eax
  800a7d:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800a83:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a86:	39 c2                	cmp    %eax,%edx
  800a88:	77 c8                	ja     800a52 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800a8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a8d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800a90:	74 14                	je     800aa6 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800a92:	83 ec 04             	sub    $0x4,%esp
  800a95:	68 9c 26 80 00       	push   $0x80269c
  800a9a:	6a 44                	push   $0x44
  800a9c:	68 3c 26 80 00       	push   $0x80263c
  800aa1:	e8 15 fe ff ff       	call   8008bb <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800aa6:	90                   	nop
  800aa7:	c9                   	leave  
  800aa8:	c3                   	ret    

00800aa9 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800aa9:	55                   	push   %ebp
  800aaa:	89 e5                	mov    %esp,%ebp
  800aac:	53                   	push   %ebx
  800aad:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800ab0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ab3:	8b 00                	mov    (%eax),%eax
  800ab5:	8d 48 01             	lea    0x1(%eax),%ecx
  800ab8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800abb:	89 0a                	mov    %ecx,(%edx)
  800abd:	8b 55 08             	mov    0x8(%ebp),%edx
  800ac0:	88 d1                	mov    %dl,%cl
  800ac2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ac5:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800ac9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800acc:	8b 00                	mov    (%eax),%eax
  800ace:	3d ff 00 00 00       	cmp    $0xff,%eax
  800ad3:	75 30                	jne    800b05 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800ad5:	8b 15 48 2d 14 01    	mov    0x1142d48,%edx
  800adb:	a0 60 04 b1 00       	mov    0xb10460,%al
  800ae0:	0f b6 c0             	movzbl %al,%eax
  800ae3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ae6:	8b 09                	mov    (%ecx),%ecx
  800ae8:	89 cb                	mov    %ecx,%ebx
  800aea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800aed:	83 c1 08             	add    $0x8,%ecx
  800af0:	52                   	push   %edx
  800af1:	50                   	push   %eax
  800af2:	53                   	push   %ebx
  800af3:	51                   	push   %ecx
  800af4:	e8 a0 0f 00 00       	call   801a99 <sys_cputs>
  800af9:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800afc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800b05:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b08:	8b 40 04             	mov    0x4(%eax),%eax
  800b0b:	8d 50 01             	lea    0x1(%eax),%edx
  800b0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b11:	89 50 04             	mov    %edx,0x4(%eax)
}
  800b14:	90                   	nop
  800b15:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b18:	c9                   	leave  
  800b19:	c3                   	ret    

00800b1a <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800b1a:	55                   	push   %ebp
  800b1b:	89 e5                	mov    %esp,%ebp
  800b1d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800b23:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800b2a:	00 00 00 
	b.cnt = 0;
  800b2d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b34:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800b37:	ff 75 0c             	pushl  0xc(%ebp)
  800b3a:	ff 75 08             	pushl  0x8(%ebp)
  800b3d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b43:	50                   	push   %eax
  800b44:	68 a9 0a 80 00       	push   $0x800aa9
  800b49:	e8 5a 02 00 00       	call   800da8 <vprintfmt>
  800b4e:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800b51:	8b 15 48 2d 14 01    	mov    0x1142d48,%edx
  800b57:	a0 60 04 b1 00       	mov    0xb10460,%al
  800b5c:	0f b6 c0             	movzbl %al,%eax
  800b5f:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800b65:	52                   	push   %edx
  800b66:	50                   	push   %eax
  800b67:	51                   	push   %ecx
  800b68:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b6e:	83 c0 08             	add    $0x8,%eax
  800b71:	50                   	push   %eax
  800b72:	e8 22 0f 00 00       	call   801a99 <sys_cputs>
  800b77:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800b7a:	c6 05 60 04 b1 00 00 	movb   $0x0,0xb10460
	return b.cnt;
  800b81:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800b87:	c9                   	leave  
  800b88:	c3                   	ret    

00800b89 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800b89:	55                   	push   %ebp
  800b8a:	89 e5                	mov    %esp,%ebp
  800b8c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800b8f:	c6 05 60 04 b1 00 01 	movb   $0x1,0xb10460
	va_start(ap, fmt);
  800b96:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b99:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800b9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9f:	83 ec 08             	sub    $0x8,%esp
  800ba2:	ff 75 f4             	pushl  -0xc(%ebp)
  800ba5:	50                   	push   %eax
  800ba6:	e8 6f ff ff ff       	call   800b1a <vcprintf>
  800bab:	83 c4 10             	add    $0x10,%esp
  800bae:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800bb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bb4:	c9                   	leave  
  800bb5:	c3                   	ret    

00800bb6 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800bb6:	55                   	push   %ebp
  800bb7:	89 e5                	mov    %esp,%ebp
  800bb9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800bbc:	c6 05 60 04 b1 00 01 	movb   $0x1,0xb10460
	curTextClr = (textClr << 8) ; //set text color by the given value
  800bc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc6:	c1 e0 08             	shl    $0x8,%eax
  800bc9:	a3 48 2d 14 01       	mov    %eax,0x1142d48
	va_start(ap, fmt);
  800bce:	8d 45 0c             	lea    0xc(%ebp),%eax
  800bd1:	83 c0 04             	add    $0x4,%eax
  800bd4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800bd7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bda:	83 ec 08             	sub    $0x8,%esp
  800bdd:	ff 75 f4             	pushl  -0xc(%ebp)
  800be0:	50                   	push   %eax
  800be1:	e8 34 ff ff ff       	call   800b1a <vcprintf>
  800be6:	83 c4 10             	add    $0x10,%esp
  800be9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800bec:	c7 05 48 2d 14 01 00 	movl   $0x700,0x1142d48
  800bf3:	07 00 00 

	return cnt;
  800bf6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bf9:	c9                   	leave  
  800bfa:	c3                   	ret    

00800bfb <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800bfb:	55                   	push   %ebp
  800bfc:	89 e5                	mov    %esp,%ebp
  800bfe:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800c01:	e8 d7 0e 00 00       	call   801add <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800c06:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c09:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800c0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0f:	83 ec 08             	sub    $0x8,%esp
  800c12:	ff 75 f4             	pushl  -0xc(%ebp)
  800c15:	50                   	push   %eax
  800c16:	e8 ff fe ff ff       	call   800b1a <vcprintf>
  800c1b:	83 c4 10             	add    $0x10,%esp
  800c1e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800c21:	e8 d1 0e 00 00       	call   801af7 <sys_unlock_cons>
	return cnt;
  800c26:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c29:	c9                   	leave  
  800c2a:	c3                   	ret    

00800c2b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800c2b:	55                   	push   %ebp
  800c2c:	89 e5                	mov    %esp,%ebp
  800c2e:	53                   	push   %ebx
  800c2f:	83 ec 14             	sub    $0x14,%esp
  800c32:	8b 45 10             	mov    0x10(%ebp),%eax
  800c35:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c38:	8b 45 14             	mov    0x14(%ebp),%eax
  800c3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800c3e:	8b 45 18             	mov    0x18(%ebp),%eax
  800c41:	ba 00 00 00 00       	mov    $0x0,%edx
  800c46:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c49:	77 55                	ja     800ca0 <printnum+0x75>
  800c4b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c4e:	72 05                	jb     800c55 <printnum+0x2a>
  800c50:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800c53:	77 4b                	ja     800ca0 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800c55:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800c58:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800c5b:	8b 45 18             	mov    0x18(%ebp),%eax
  800c5e:	ba 00 00 00 00       	mov    $0x0,%edx
  800c63:	52                   	push   %edx
  800c64:	50                   	push   %eax
  800c65:	ff 75 f4             	pushl  -0xc(%ebp)
  800c68:	ff 75 f0             	pushl  -0x10(%ebp)
  800c6b:	e8 a8 13 00 00       	call   802018 <__udivdi3>
  800c70:	83 c4 10             	add    $0x10,%esp
  800c73:	83 ec 04             	sub    $0x4,%esp
  800c76:	ff 75 20             	pushl  0x20(%ebp)
  800c79:	53                   	push   %ebx
  800c7a:	ff 75 18             	pushl  0x18(%ebp)
  800c7d:	52                   	push   %edx
  800c7e:	50                   	push   %eax
  800c7f:	ff 75 0c             	pushl  0xc(%ebp)
  800c82:	ff 75 08             	pushl  0x8(%ebp)
  800c85:	e8 a1 ff ff ff       	call   800c2b <printnum>
  800c8a:	83 c4 20             	add    $0x20,%esp
  800c8d:	eb 1a                	jmp    800ca9 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800c8f:	83 ec 08             	sub    $0x8,%esp
  800c92:	ff 75 0c             	pushl  0xc(%ebp)
  800c95:	ff 75 20             	pushl  0x20(%ebp)
  800c98:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9b:	ff d0                	call   *%eax
  800c9d:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800ca0:	ff 4d 1c             	decl   0x1c(%ebp)
  800ca3:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800ca7:	7f e6                	jg     800c8f <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800ca9:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800cac:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cb4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cb7:	53                   	push   %ebx
  800cb8:	51                   	push   %ecx
  800cb9:	52                   	push   %edx
  800cba:	50                   	push   %eax
  800cbb:	e8 68 14 00 00       	call   802128 <__umoddi3>
  800cc0:	83 c4 10             	add    $0x10,%esp
  800cc3:	05 14 29 80 00       	add    $0x802914,%eax
  800cc8:	8a 00                	mov    (%eax),%al
  800cca:	0f be c0             	movsbl %al,%eax
  800ccd:	83 ec 08             	sub    $0x8,%esp
  800cd0:	ff 75 0c             	pushl  0xc(%ebp)
  800cd3:	50                   	push   %eax
  800cd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd7:	ff d0                	call   *%eax
  800cd9:	83 c4 10             	add    $0x10,%esp
}
  800cdc:	90                   	nop
  800cdd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ce0:	c9                   	leave  
  800ce1:	c3                   	ret    

00800ce2 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800ce2:	55                   	push   %ebp
  800ce3:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800ce5:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800ce9:	7e 1c                	jle    800d07 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cee:	8b 00                	mov    (%eax),%eax
  800cf0:	8d 50 08             	lea    0x8(%eax),%edx
  800cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf6:	89 10                	mov    %edx,(%eax)
  800cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfb:	8b 00                	mov    (%eax),%eax
  800cfd:	83 e8 08             	sub    $0x8,%eax
  800d00:	8b 50 04             	mov    0x4(%eax),%edx
  800d03:	8b 00                	mov    (%eax),%eax
  800d05:	eb 40                	jmp    800d47 <getuint+0x65>
	else if (lflag)
  800d07:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d0b:	74 1e                	je     800d2b <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d10:	8b 00                	mov    (%eax),%eax
  800d12:	8d 50 04             	lea    0x4(%eax),%edx
  800d15:	8b 45 08             	mov    0x8(%ebp),%eax
  800d18:	89 10                	mov    %edx,(%eax)
  800d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1d:	8b 00                	mov    (%eax),%eax
  800d1f:	83 e8 04             	sub    $0x4,%eax
  800d22:	8b 00                	mov    (%eax),%eax
  800d24:	ba 00 00 00 00       	mov    $0x0,%edx
  800d29:	eb 1c                	jmp    800d47 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2e:	8b 00                	mov    (%eax),%eax
  800d30:	8d 50 04             	lea    0x4(%eax),%edx
  800d33:	8b 45 08             	mov    0x8(%ebp),%eax
  800d36:	89 10                	mov    %edx,(%eax)
  800d38:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3b:	8b 00                	mov    (%eax),%eax
  800d3d:	83 e8 04             	sub    $0x4,%eax
  800d40:	8b 00                	mov    (%eax),%eax
  800d42:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800d47:	5d                   	pop    %ebp
  800d48:	c3                   	ret    

00800d49 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800d49:	55                   	push   %ebp
  800d4a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d4c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d50:	7e 1c                	jle    800d6e <getint+0x25>
		return va_arg(*ap, long long);
  800d52:	8b 45 08             	mov    0x8(%ebp),%eax
  800d55:	8b 00                	mov    (%eax),%eax
  800d57:	8d 50 08             	lea    0x8(%eax),%edx
  800d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5d:	89 10                	mov    %edx,(%eax)
  800d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d62:	8b 00                	mov    (%eax),%eax
  800d64:	83 e8 08             	sub    $0x8,%eax
  800d67:	8b 50 04             	mov    0x4(%eax),%edx
  800d6a:	8b 00                	mov    (%eax),%eax
  800d6c:	eb 38                	jmp    800da6 <getint+0x5d>
	else if (lflag)
  800d6e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d72:	74 1a                	je     800d8e <getint+0x45>
		return va_arg(*ap, long);
  800d74:	8b 45 08             	mov    0x8(%ebp),%eax
  800d77:	8b 00                	mov    (%eax),%eax
  800d79:	8d 50 04             	lea    0x4(%eax),%edx
  800d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7f:	89 10                	mov    %edx,(%eax)
  800d81:	8b 45 08             	mov    0x8(%ebp),%eax
  800d84:	8b 00                	mov    (%eax),%eax
  800d86:	83 e8 04             	sub    $0x4,%eax
  800d89:	8b 00                	mov    (%eax),%eax
  800d8b:	99                   	cltd   
  800d8c:	eb 18                	jmp    800da6 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d91:	8b 00                	mov    (%eax),%eax
  800d93:	8d 50 04             	lea    0x4(%eax),%edx
  800d96:	8b 45 08             	mov    0x8(%ebp),%eax
  800d99:	89 10                	mov    %edx,(%eax)
  800d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9e:	8b 00                	mov    (%eax),%eax
  800da0:	83 e8 04             	sub    $0x4,%eax
  800da3:	8b 00                	mov    (%eax),%eax
  800da5:	99                   	cltd   
}
  800da6:	5d                   	pop    %ebp
  800da7:	c3                   	ret    

00800da8 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800da8:	55                   	push   %ebp
  800da9:	89 e5                	mov    %esp,%ebp
  800dab:	56                   	push   %esi
  800dac:	53                   	push   %ebx
  800dad:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800db0:	eb 17                	jmp    800dc9 <vprintfmt+0x21>
			if (ch == '\0')
  800db2:	85 db                	test   %ebx,%ebx
  800db4:	0f 84 c1 03 00 00    	je     80117b <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800dba:	83 ec 08             	sub    $0x8,%esp
  800dbd:	ff 75 0c             	pushl  0xc(%ebp)
  800dc0:	53                   	push   %ebx
  800dc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc4:	ff d0                	call   *%eax
  800dc6:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800dc9:	8b 45 10             	mov    0x10(%ebp),%eax
  800dcc:	8d 50 01             	lea    0x1(%eax),%edx
  800dcf:	89 55 10             	mov    %edx,0x10(%ebp)
  800dd2:	8a 00                	mov    (%eax),%al
  800dd4:	0f b6 d8             	movzbl %al,%ebx
  800dd7:	83 fb 25             	cmp    $0x25,%ebx
  800dda:	75 d6                	jne    800db2 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800ddc:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800de0:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800de7:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800dee:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800df5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800dfc:	8b 45 10             	mov    0x10(%ebp),%eax
  800dff:	8d 50 01             	lea    0x1(%eax),%edx
  800e02:	89 55 10             	mov    %edx,0x10(%ebp)
  800e05:	8a 00                	mov    (%eax),%al
  800e07:	0f b6 d8             	movzbl %al,%ebx
  800e0a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800e0d:	83 f8 5b             	cmp    $0x5b,%eax
  800e10:	0f 87 3d 03 00 00    	ja     801153 <vprintfmt+0x3ab>
  800e16:	8b 04 85 38 29 80 00 	mov    0x802938(,%eax,4),%eax
  800e1d:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800e1f:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800e23:	eb d7                	jmp    800dfc <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800e25:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800e29:	eb d1                	jmp    800dfc <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e2b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800e32:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800e35:	89 d0                	mov    %edx,%eax
  800e37:	c1 e0 02             	shl    $0x2,%eax
  800e3a:	01 d0                	add    %edx,%eax
  800e3c:	01 c0                	add    %eax,%eax
  800e3e:	01 d8                	add    %ebx,%eax
  800e40:	83 e8 30             	sub    $0x30,%eax
  800e43:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800e46:	8b 45 10             	mov    0x10(%ebp),%eax
  800e49:	8a 00                	mov    (%eax),%al
  800e4b:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800e4e:	83 fb 2f             	cmp    $0x2f,%ebx
  800e51:	7e 3e                	jle    800e91 <vprintfmt+0xe9>
  800e53:	83 fb 39             	cmp    $0x39,%ebx
  800e56:	7f 39                	jg     800e91 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e58:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800e5b:	eb d5                	jmp    800e32 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800e5d:	8b 45 14             	mov    0x14(%ebp),%eax
  800e60:	83 c0 04             	add    $0x4,%eax
  800e63:	89 45 14             	mov    %eax,0x14(%ebp)
  800e66:	8b 45 14             	mov    0x14(%ebp),%eax
  800e69:	83 e8 04             	sub    $0x4,%eax
  800e6c:	8b 00                	mov    (%eax),%eax
  800e6e:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800e71:	eb 1f                	jmp    800e92 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800e73:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e77:	79 83                	jns    800dfc <vprintfmt+0x54>
				width = 0;
  800e79:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800e80:	e9 77 ff ff ff       	jmp    800dfc <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800e85:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800e8c:	e9 6b ff ff ff       	jmp    800dfc <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800e91:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800e92:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e96:	0f 89 60 ff ff ff    	jns    800dfc <vprintfmt+0x54>
				width = precision, precision = -1;
  800e9c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e9f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800ea2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800ea9:	e9 4e ff ff ff       	jmp    800dfc <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800eae:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800eb1:	e9 46 ff ff ff       	jmp    800dfc <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800eb6:	8b 45 14             	mov    0x14(%ebp),%eax
  800eb9:	83 c0 04             	add    $0x4,%eax
  800ebc:	89 45 14             	mov    %eax,0x14(%ebp)
  800ebf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ec2:	83 e8 04             	sub    $0x4,%eax
  800ec5:	8b 00                	mov    (%eax),%eax
  800ec7:	83 ec 08             	sub    $0x8,%esp
  800eca:	ff 75 0c             	pushl  0xc(%ebp)
  800ecd:	50                   	push   %eax
  800ece:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed1:	ff d0                	call   *%eax
  800ed3:	83 c4 10             	add    $0x10,%esp
			break;
  800ed6:	e9 9b 02 00 00       	jmp    801176 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800edb:	8b 45 14             	mov    0x14(%ebp),%eax
  800ede:	83 c0 04             	add    $0x4,%eax
  800ee1:	89 45 14             	mov    %eax,0x14(%ebp)
  800ee4:	8b 45 14             	mov    0x14(%ebp),%eax
  800ee7:	83 e8 04             	sub    $0x4,%eax
  800eea:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800eec:	85 db                	test   %ebx,%ebx
  800eee:	79 02                	jns    800ef2 <vprintfmt+0x14a>
				err = -err;
  800ef0:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ef2:	83 fb 64             	cmp    $0x64,%ebx
  800ef5:	7f 0b                	jg     800f02 <vprintfmt+0x15a>
  800ef7:	8b 34 9d 80 27 80 00 	mov    0x802780(,%ebx,4),%esi
  800efe:	85 f6                	test   %esi,%esi
  800f00:	75 19                	jne    800f1b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800f02:	53                   	push   %ebx
  800f03:	68 25 29 80 00       	push   $0x802925
  800f08:	ff 75 0c             	pushl  0xc(%ebp)
  800f0b:	ff 75 08             	pushl  0x8(%ebp)
  800f0e:	e8 70 02 00 00       	call   801183 <printfmt>
  800f13:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800f16:	e9 5b 02 00 00       	jmp    801176 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800f1b:	56                   	push   %esi
  800f1c:	68 2e 29 80 00       	push   $0x80292e
  800f21:	ff 75 0c             	pushl  0xc(%ebp)
  800f24:	ff 75 08             	pushl  0x8(%ebp)
  800f27:	e8 57 02 00 00       	call   801183 <printfmt>
  800f2c:	83 c4 10             	add    $0x10,%esp
			break;
  800f2f:	e9 42 02 00 00       	jmp    801176 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800f34:	8b 45 14             	mov    0x14(%ebp),%eax
  800f37:	83 c0 04             	add    $0x4,%eax
  800f3a:	89 45 14             	mov    %eax,0x14(%ebp)
  800f3d:	8b 45 14             	mov    0x14(%ebp),%eax
  800f40:	83 e8 04             	sub    $0x4,%eax
  800f43:	8b 30                	mov    (%eax),%esi
  800f45:	85 f6                	test   %esi,%esi
  800f47:	75 05                	jne    800f4e <vprintfmt+0x1a6>
				p = "(null)";
  800f49:	be 31 29 80 00       	mov    $0x802931,%esi
			if (width > 0 && padc != '-')
  800f4e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f52:	7e 6d                	jle    800fc1 <vprintfmt+0x219>
  800f54:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800f58:	74 67                	je     800fc1 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800f5a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f5d:	83 ec 08             	sub    $0x8,%esp
  800f60:	50                   	push   %eax
  800f61:	56                   	push   %esi
  800f62:	e8 1e 03 00 00       	call   801285 <strnlen>
  800f67:	83 c4 10             	add    $0x10,%esp
  800f6a:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800f6d:	eb 16                	jmp    800f85 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800f6f:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800f73:	83 ec 08             	sub    $0x8,%esp
  800f76:	ff 75 0c             	pushl  0xc(%ebp)
  800f79:	50                   	push   %eax
  800f7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7d:	ff d0                	call   *%eax
  800f7f:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800f82:	ff 4d e4             	decl   -0x1c(%ebp)
  800f85:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f89:	7f e4                	jg     800f6f <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f8b:	eb 34                	jmp    800fc1 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800f8d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800f91:	74 1c                	je     800faf <vprintfmt+0x207>
  800f93:	83 fb 1f             	cmp    $0x1f,%ebx
  800f96:	7e 05                	jle    800f9d <vprintfmt+0x1f5>
  800f98:	83 fb 7e             	cmp    $0x7e,%ebx
  800f9b:	7e 12                	jle    800faf <vprintfmt+0x207>
					putch('?', putdat);
  800f9d:	83 ec 08             	sub    $0x8,%esp
  800fa0:	ff 75 0c             	pushl  0xc(%ebp)
  800fa3:	6a 3f                	push   $0x3f
  800fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa8:	ff d0                	call   *%eax
  800faa:	83 c4 10             	add    $0x10,%esp
  800fad:	eb 0f                	jmp    800fbe <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800faf:	83 ec 08             	sub    $0x8,%esp
  800fb2:	ff 75 0c             	pushl  0xc(%ebp)
  800fb5:	53                   	push   %ebx
  800fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb9:	ff d0                	call   *%eax
  800fbb:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800fbe:	ff 4d e4             	decl   -0x1c(%ebp)
  800fc1:	89 f0                	mov    %esi,%eax
  800fc3:	8d 70 01             	lea    0x1(%eax),%esi
  800fc6:	8a 00                	mov    (%eax),%al
  800fc8:	0f be d8             	movsbl %al,%ebx
  800fcb:	85 db                	test   %ebx,%ebx
  800fcd:	74 24                	je     800ff3 <vprintfmt+0x24b>
  800fcf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800fd3:	78 b8                	js     800f8d <vprintfmt+0x1e5>
  800fd5:	ff 4d e0             	decl   -0x20(%ebp)
  800fd8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800fdc:	79 af                	jns    800f8d <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800fde:	eb 13                	jmp    800ff3 <vprintfmt+0x24b>
				putch(' ', putdat);
  800fe0:	83 ec 08             	sub    $0x8,%esp
  800fe3:	ff 75 0c             	pushl  0xc(%ebp)
  800fe6:	6a 20                	push   $0x20
  800fe8:	8b 45 08             	mov    0x8(%ebp),%eax
  800feb:	ff d0                	call   *%eax
  800fed:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ff0:	ff 4d e4             	decl   -0x1c(%ebp)
  800ff3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ff7:	7f e7                	jg     800fe0 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800ff9:	e9 78 01 00 00       	jmp    801176 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ffe:	83 ec 08             	sub    $0x8,%esp
  801001:	ff 75 e8             	pushl  -0x18(%ebp)
  801004:	8d 45 14             	lea    0x14(%ebp),%eax
  801007:	50                   	push   %eax
  801008:	e8 3c fd ff ff       	call   800d49 <getint>
  80100d:	83 c4 10             	add    $0x10,%esp
  801010:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801013:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801016:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801019:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80101c:	85 d2                	test   %edx,%edx
  80101e:	79 23                	jns    801043 <vprintfmt+0x29b>
				putch('-', putdat);
  801020:	83 ec 08             	sub    $0x8,%esp
  801023:	ff 75 0c             	pushl  0xc(%ebp)
  801026:	6a 2d                	push   $0x2d
  801028:	8b 45 08             	mov    0x8(%ebp),%eax
  80102b:	ff d0                	call   *%eax
  80102d:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801030:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801033:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801036:	f7 d8                	neg    %eax
  801038:	83 d2 00             	adc    $0x0,%edx
  80103b:	f7 da                	neg    %edx
  80103d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801040:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801043:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80104a:	e9 bc 00 00 00       	jmp    80110b <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80104f:	83 ec 08             	sub    $0x8,%esp
  801052:	ff 75 e8             	pushl  -0x18(%ebp)
  801055:	8d 45 14             	lea    0x14(%ebp),%eax
  801058:	50                   	push   %eax
  801059:	e8 84 fc ff ff       	call   800ce2 <getuint>
  80105e:	83 c4 10             	add    $0x10,%esp
  801061:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801064:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801067:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80106e:	e9 98 00 00 00       	jmp    80110b <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801073:	83 ec 08             	sub    $0x8,%esp
  801076:	ff 75 0c             	pushl  0xc(%ebp)
  801079:	6a 58                	push   $0x58
  80107b:	8b 45 08             	mov    0x8(%ebp),%eax
  80107e:	ff d0                	call   *%eax
  801080:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801083:	83 ec 08             	sub    $0x8,%esp
  801086:	ff 75 0c             	pushl  0xc(%ebp)
  801089:	6a 58                	push   $0x58
  80108b:	8b 45 08             	mov    0x8(%ebp),%eax
  80108e:	ff d0                	call   *%eax
  801090:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801093:	83 ec 08             	sub    $0x8,%esp
  801096:	ff 75 0c             	pushl  0xc(%ebp)
  801099:	6a 58                	push   $0x58
  80109b:	8b 45 08             	mov    0x8(%ebp),%eax
  80109e:	ff d0                	call   *%eax
  8010a0:	83 c4 10             	add    $0x10,%esp
			break;
  8010a3:	e9 ce 00 00 00       	jmp    801176 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8010a8:	83 ec 08             	sub    $0x8,%esp
  8010ab:	ff 75 0c             	pushl  0xc(%ebp)
  8010ae:	6a 30                	push   $0x30
  8010b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b3:	ff d0                	call   *%eax
  8010b5:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8010b8:	83 ec 08             	sub    $0x8,%esp
  8010bb:	ff 75 0c             	pushl  0xc(%ebp)
  8010be:	6a 78                	push   $0x78
  8010c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c3:	ff d0                	call   *%eax
  8010c5:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8010c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8010cb:	83 c0 04             	add    $0x4,%eax
  8010ce:	89 45 14             	mov    %eax,0x14(%ebp)
  8010d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8010d4:	83 e8 04             	sub    $0x4,%eax
  8010d7:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8010d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010dc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8010e3:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8010ea:	eb 1f                	jmp    80110b <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8010ec:	83 ec 08             	sub    $0x8,%esp
  8010ef:	ff 75 e8             	pushl  -0x18(%ebp)
  8010f2:	8d 45 14             	lea    0x14(%ebp),%eax
  8010f5:	50                   	push   %eax
  8010f6:	e8 e7 fb ff ff       	call   800ce2 <getuint>
  8010fb:	83 c4 10             	add    $0x10,%esp
  8010fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801101:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801104:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80110b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80110f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801112:	83 ec 04             	sub    $0x4,%esp
  801115:	52                   	push   %edx
  801116:	ff 75 e4             	pushl  -0x1c(%ebp)
  801119:	50                   	push   %eax
  80111a:	ff 75 f4             	pushl  -0xc(%ebp)
  80111d:	ff 75 f0             	pushl  -0x10(%ebp)
  801120:	ff 75 0c             	pushl  0xc(%ebp)
  801123:	ff 75 08             	pushl  0x8(%ebp)
  801126:	e8 00 fb ff ff       	call   800c2b <printnum>
  80112b:	83 c4 20             	add    $0x20,%esp
			break;
  80112e:	eb 46                	jmp    801176 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801130:	83 ec 08             	sub    $0x8,%esp
  801133:	ff 75 0c             	pushl  0xc(%ebp)
  801136:	53                   	push   %ebx
  801137:	8b 45 08             	mov    0x8(%ebp),%eax
  80113a:	ff d0                	call   *%eax
  80113c:	83 c4 10             	add    $0x10,%esp
			break;
  80113f:	eb 35                	jmp    801176 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  801141:	c6 05 60 04 b1 00 00 	movb   $0x0,0xb10460
			break;
  801148:	eb 2c                	jmp    801176 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  80114a:	c6 05 60 04 b1 00 01 	movb   $0x1,0xb10460
			break;
  801151:	eb 23                	jmp    801176 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801153:	83 ec 08             	sub    $0x8,%esp
  801156:	ff 75 0c             	pushl  0xc(%ebp)
  801159:	6a 25                	push   $0x25
  80115b:	8b 45 08             	mov    0x8(%ebp),%eax
  80115e:	ff d0                	call   *%eax
  801160:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801163:	ff 4d 10             	decl   0x10(%ebp)
  801166:	eb 03                	jmp    80116b <vprintfmt+0x3c3>
  801168:	ff 4d 10             	decl   0x10(%ebp)
  80116b:	8b 45 10             	mov    0x10(%ebp),%eax
  80116e:	48                   	dec    %eax
  80116f:	8a 00                	mov    (%eax),%al
  801171:	3c 25                	cmp    $0x25,%al
  801173:	75 f3                	jne    801168 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  801175:	90                   	nop
		}
	}
  801176:	e9 35 fc ff ff       	jmp    800db0 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80117b:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80117c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80117f:	5b                   	pop    %ebx
  801180:	5e                   	pop    %esi
  801181:	5d                   	pop    %ebp
  801182:	c3                   	ret    

00801183 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801183:	55                   	push   %ebp
  801184:	89 e5                	mov    %esp,%ebp
  801186:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801189:	8d 45 10             	lea    0x10(%ebp),%eax
  80118c:	83 c0 04             	add    $0x4,%eax
  80118f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801192:	8b 45 10             	mov    0x10(%ebp),%eax
  801195:	ff 75 f4             	pushl  -0xc(%ebp)
  801198:	50                   	push   %eax
  801199:	ff 75 0c             	pushl  0xc(%ebp)
  80119c:	ff 75 08             	pushl  0x8(%ebp)
  80119f:	e8 04 fc ff ff       	call   800da8 <vprintfmt>
  8011a4:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8011a7:	90                   	nop
  8011a8:	c9                   	leave  
  8011a9:	c3                   	ret    

008011aa <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8011aa:	55                   	push   %ebp
  8011ab:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8011ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b0:	8b 40 08             	mov    0x8(%eax),%eax
  8011b3:	8d 50 01             	lea    0x1(%eax),%edx
  8011b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b9:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8011bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011bf:	8b 10                	mov    (%eax),%edx
  8011c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c4:	8b 40 04             	mov    0x4(%eax),%eax
  8011c7:	39 c2                	cmp    %eax,%edx
  8011c9:	73 12                	jae    8011dd <sprintputch+0x33>
		*b->buf++ = ch;
  8011cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ce:	8b 00                	mov    (%eax),%eax
  8011d0:	8d 48 01             	lea    0x1(%eax),%ecx
  8011d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011d6:	89 0a                	mov    %ecx,(%edx)
  8011d8:	8b 55 08             	mov    0x8(%ebp),%edx
  8011db:	88 10                	mov    %dl,(%eax)
}
  8011dd:	90                   	nop
  8011de:	5d                   	pop    %ebp
  8011df:	c3                   	ret    

008011e0 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8011e0:	55                   	push   %ebp
  8011e1:	89 e5                	mov    %esp,%ebp
  8011e3:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8011e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8011ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ef:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f5:	01 d0                	add    %edx,%eax
  8011f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011fa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801201:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801205:	74 06                	je     80120d <vsnprintf+0x2d>
  801207:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80120b:	7f 07                	jg     801214 <vsnprintf+0x34>
		return -E_INVAL;
  80120d:	b8 03 00 00 00       	mov    $0x3,%eax
  801212:	eb 20                	jmp    801234 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801214:	ff 75 14             	pushl  0x14(%ebp)
  801217:	ff 75 10             	pushl  0x10(%ebp)
  80121a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80121d:	50                   	push   %eax
  80121e:	68 aa 11 80 00       	push   $0x8011aa
  801223:	e8 80 fb ff ff       	call   800da8 <vprintfmt>
  801228:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80122b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80122e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801231:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801234:	c9                   	leave  
  801235:	c3                   	ret    

00801236 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801236:	55                   	push   %ebp
  801237:	89 e5                	mov    %esp,%ebp
  801239:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80123c:	8d 45 10             	lea    0x10(%ebp),%eax
  80123f:	83 c0 04             	add    $0x4,%eax
  801242:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801245:	8b 45 10             	mov    0x10(%ebp),%eax
  801248:	ff 75 f4             	pushl  -0xc(%ebp)
  80124b:	50                   	push   %eax
  80124c:	ff 75 0c             	pushl  0xc(%ebp)
  80124f:	ff 75 08             	pushl  0x8(%ebp)
  801252:	e8 89 ff ff ff       	call   8011e0 <vsnprintf>
  801257:	83 c4 10             	add    $0x10,%esp
  80125a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80125d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801260:	c9                   	leave  
  801261:	c3                   	ret    

00801262 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801262:	55                   	push   %ebp
  801263:	89 e5                	mov    %esp,%ebp
  801265:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801268:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80126f:	eb 06                	jmp    801277 <strlen+0x15>
		n++;
  801271:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801274:	ff 45 08             	incl   0x8(%ebp)
  801277:	8b 45 08             	mov    0x8(%ebp),%eax
  80127a:	8a 00                	mov    (%eax),%al
  80127c:	84 c0                	test   %al,%al
  80127e:	75 f1                	jne    801271 <strlen+0xf>
		n++;
	return n;
  801280:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801283:	c9                   	leave  
  801284:	c3                   	ret    

00801285 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801285:	55                   	push   %ebp
  801286:	89 e5                	mov    %esp,%ebp
  801288:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80128b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801292:	eb 09                	jmp    80129d <strnlen+0x18>
		n++;
  801294:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801297:	ff 45 08             	incl   0x8(%ebp)
  80129a:	ff 4d 0c             	decl   0xc(%ebp)
  80129d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012a1:	74 09                	je     8012ac <strnlen+0x27>
  8012a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a6:	8a 00                	mov    (%eax),%al
  8012a8:	84 c0                	test   %al,%al
  8012aa:	75 e8                	jne    801294 <strnlen+0xf>
		n++;
	return n;
  8012ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012af:	c9                   	leave  
  8012b0:	c3                   	ret    

008012b1 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8012b1:	55                   	push   %ebp
  8012b2:	89 e5                	mov    %esp,%ebp
  8012b4:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8012b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ba:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8012bd:	90                   	nop
  8012be:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c1:	8d 50 01             	lea    0x1(%eax),%edx
  8012c4:	89 55 08             	mov    %edx,0x8(%ebp)
  8012c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012ca:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012cd:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8012d0:	8a 12                	mov    (%edx),%dl
  8012d2:	88 10                	mov    %dl,(%eax)
  8012d4:	8a 00                	mov    (%eax),%al
  8012d6:	84 c0                	test   %al,%al
  8012d8:	75 e4                	jne    8012be <strcpy+0xd>
		/* do nothing */;
	return ret;
  8012da:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012dd:	c9                   	leave  
  8012de:	c3                   	ret    

008012df <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8012df:	55                   	push   %ebp
  8012e0:	89 e5                	mov    %esp,%ebp
  8012e2:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8012e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8012eb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012f2:	eb 1f                	jmp    801313 <strncpy+0x34>
		*dst++ = *src;
  8012f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f7:	8d 50 01             	lea    0x1(%eax),%edx
  8012fa:	89 55 08             	mov    %edx,0x8(%ebp)
  8012fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801300:	8a 12                	mov    (%edx),%dl
  801302:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801304:	8b 45 0c             	mov    0xc(%ebp),%eax
  801307:	8a 00                	mov    (%eax),%al
  801309:	84 c0                	test   %al,%al
  80130b:	74 03                	je     801310 <strncpy+0x31>
			src++;
  80130d:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801310:	ff 45 fc             	incl   -0x4(%ebp)
  801313:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801316:	3b 45 10             	cmp    0x10(%ebp),%eax
  801319:	72 d9                	jb     8012f4 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80131b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80131e:	c9                   	leave  
  80131f:	c3                   	ret    

00801320 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801320:	55                   	push   %ebp
  801321:	89 e5                	mov    %esp,%ebp
  801323:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801326:	8b 45 08             	mov    0x8(%ebp),%eax
  801329:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80132c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801330:	74 30                	je     801362 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801332:	eb 16                	jmp    80134a <strlcpy+0x2a>
			*dst++ = *src++;
  801334:	8b 45 08             	mov    0x8(%ebp),%eax
  801337:	8d 50 01             	lea    0x1(%eax),%edx
  80133a:	89 55 08             	mov    %edx,0x8(%ebp)
  80133d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801340:	8d 4a 01             	lea    0x1(%edx),%ecx
  801343:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801346:	8a 12                	mov    (%edx),%dl
  801348:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80134a:	ff 4d 10             	decl   0x10(%ebp)
  80134d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801351:	74 09                	je     80135c <strlcpy+0x3c>
  801353:	8b 45 0c             	mov    0xc(%ebp),%eax
  801356:	8a 00                	mov    (%eax),%al
  801358:	84 c0                	test   %al,%al
  80135a:	75 d8                	jne    801334 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80135c:	8b 45 08             	mov    0x8(%ebp),%eax
  80135f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801362:	8b 55 08             	mov    0x8(%ebp),%edx
  801365:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801368:	29 c2                	sub    %eax,%edx
  80136a:	89 d0                	mov    %edx,%eax
}
  80136c:	c9                   	leave  
  80136d:	c3                   	ret    

0080136e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80136e:	55                   	push   %ebp
  80136f:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801371:	eb 06                	jmp    801379 <strcmp+0xb>
		p++, q++;
  801373:	ff 45 08             	incl   0x8(%ebp)
  801376:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801379:	8b 45 08             	mov    0x8(%ebp),%eax
  80137c:	8a 00                	mov    (%eax),%al
  80137e:	84 c0                	test   %al,%al
  801380:	74 0e                	je     801390 <strcmp+0x22>
  801382:	8b 45 08             	mov    0x8(%ebp),%eax
  801385:	8a 10                	mov    (%eax),%dl
  801387:	8b 45 0c             	mov    0xc(%ebp),%eax
  80138a:	8a 00                	mov    (%eax),%al
  80138c:	38 c2                	cmp    %al,%dl
  80138e:	74 e3                	je     801373 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801390:	8b 45 08             	mov    0x8(%ebp),%eax
  801393:	8a 00                	mov    (%eax),%al
  801395:	0f b6 d0             	movzbl %al,%edx
  801398:	8b 45 0c             	mov    0xc(%ebp),%eax
  80139b:	8a 00                	mov    (%eax),%al
  80139d:	0f b6 c0             	movzbl %al,%eax
  8013a0:	29 c2                	sub    %eax,%edx
  8013a2:	89 d0                	mov    %edx,%eax
}
  8013a4:	5d                   	pop    %ebp
  8013a5:	c3                   	ret    

008013a6 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8013a6:	55                   	push   %ebp
  8013a7:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8013a9:	eb 09                	jmp    8013b4 <strncmp+0xe>
		n--, p++, q++;
  8013ab:	ff 4d 10             	decl   0x10(%ebp)
  8013ae:	ff 45 08             	incl   0x8(%ebp)
  8013b1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8013b4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013b8:	74 17                	je     8013d1 <strncmp+0x2b>
  8013ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bd:	8a 00                	mov    (%eax),%al
  8013bf:	84 c0                	test   %al,%al
  8013c1:	74 0e                	je     8013d1 <strncmp+0x2b>
  8013c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c6:	8a 10                	mov    (%eax),%dl
  8013c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013cb:	8a 00                	mov    (%eax),%al
  8013cd:	38 c2                	cmp    %al,%dl
  8013cf:	74 da                	je     8013ab <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8013d1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013d5:	75 07                	jne    8013de <strncmp+0x38>
		return 0;
  8013d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8013dc:	eb 14                	jmp    8013f2 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8013de:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e1:	8a 00                	mov    (%eax),%al
  8013e3:	0f b6 d0             	movzbl %al,%edx
  8013e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e9:	8a 00                	mov    (%eax),%al
  8013eb:	0f b6 c0             	movzbl %al,%eax
  8013ee:	29 c2                	sub    %eax,%edx
  8013f0:	89 d0                	mov    %edx,%eax
}
  8013f2:	5d                   	pop    %ebp
  8013f3:	c3                   	ret    

008013f4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8013f4:	55                   	push   %ebp
  8013f5:	89 e5                	mov    %esp,%ebp
  8013f7:	83 ec 04             	sub    $0x4,%esp
  8013fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013fd:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801400:	eb 12                	jmp    801414 <strchr+0x20>
		if (*s == c)
  801402:	8b 45 08             	mov    0x8(%ebp),%eax
  801405:	8a 00                	mov    (%eax),%al
  801407:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80140a:	75 05                	jne    801411 <strchr+0x1d>
			return (char *) s;
  80140c:	8b 45 08             	mov    0x8(%ebp),%eax
  80140f:	eb 11                	jmp    801422 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801411:	ff 45 08             	incl   0x8(%ebp)
  801414:	8b 45 08             	mov    0x8(%ebp),%eax
  801417:	8a 00                	mov    (%eax),%al
  801419:	84 c0                	test   %al,%al
  80141b:	75 e5                	jne    801402 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80141d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801422:	c9                   	leave  
  801423:	c3                   	ret    

00801424 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801424:	55                   	push   %ebp
  801425:	89 e5                	mov    %esp,%ebp
  801427:	83 ec 04             	sub    $0x4,%esp
  80142a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80142d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801430:	eb 0d                	jmp    80143f <strfind+0x1b>
		if (*s == c)
  801432:	8b 45 08             	mov    0x8(%ebp),%eax
  801435:	8a 00                	mov    (%eax),%al
  801437:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80143a:	74 0e                	je     80144a <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80143c:	ff 45 08             	incl   0x8(%ebp)
  80143f:	8b 45 08             	mov    0x8(%ebp),%eax
  801442:	8a 00                	mov    (%eax),%al
  801444:	84 c0                	test   %al,%al
  801446:	75 ea                	jne    801432 <strfind+0xe>
  801448:	eb 01                	jmp    80144b <strfind+0x27>
		if (*s == c)
			break;
  80144a:	90                   	nop
	return (char *) s;
  80144b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80144e:	c9                   	leave  
  80144f:	c3                   	ret    

00801450 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801450:	55                   	push   %ebp
  801451:	89 e5                	mov    %esp,%ebp
  801453:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801456:	8b 45 08             	mov    0x8(%ebp),%eax
  801459:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  80145c:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801460:	76 63                	jbe    8014c5 <memset+0x75>
		uint64 data_block = c;
  801462:	8b 45 0c             	mov    0xc(%ebp),%eax
  801465:	99                   	cltd   
  801466:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801469:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  80146c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80146f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801472:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801476:	c1 e0 08             	shl    $0x8,%eax
  801479:	09 45 f0             	or     %eax,-0x10(%ebp)
  80147c:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  80147f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801482:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801485:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801489:	c1 e0 10             	shl    $0x10,%eax
  80148c:	09 45 f0             	or     %eax,-0x10(%ebp)
  80148f:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801492:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801495:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801498:	89 c2                	mov    %eax,%edx
  80149a:	b8 00 00 00 00       	mov    $0x0,%eax
  80149f:	09 45 f0             	or     %eax,-0x10(%ebp)
  8014a2:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  8014a5:	eb 18                	jmp    8014bf <memset+0x6f>
			*p64++ = data_block, n -= 8;
  8014a7:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8014aa:	8d 41 08             	lea    0x8(%ecx),%eax
  8014ad:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8014b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014b6:	89 01                	mov    %eax,(%ecx)
  8014b8:	89 51 04             	mov    %edx,0x4(%ecx)
  8014bb:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  8014bf:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8014c3:	77 e2                	ja     8014a7 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8014c5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014c9:	74 23                	je     8014ee <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8014cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014ce:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8014d1:	eb 0e                	jmp    8014e1 <memset+0x91>
			*p8++ = (uint8)c;
  8014d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014d6:	8d 50 01             	lea    0x1(%eax),%edx
  8014d9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014df:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8014e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8014e4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8014e7:	89 55 10             	mov    %edx,0x10(%ebp)
  8014ea:	85 c0                	test   %eax,%eax
  8014ec:	75 e5                	jne    8014d3 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8014ee:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014f1:	c9                   	leave  
  8014f2:	c3                   	ret    

008014f3 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8014f3:	55                   	push   %ebp
  8014f4:	89 e5                	mov    %esp,%ebp
  8014f6:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8014f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014fc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8014ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801502:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801505:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801509:	76 24                	jbe    80152f <memcpy+0x3c>
		while(n >= 8){
  80150b:	eb 1c                	jmp    801529 <memcpy+0x36>
			*d64 = *s64;
  80150d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801510:	8b 50 04             	mov    0x4(%eax),%edx
  801513:	8b 00                	mov    (%eax),%eax
  801515:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801518:	89 01                	mov    %eax,(%ecx)
  80151a:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  80151d:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801521:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801525:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801529:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80152d:	77 de                	ja     80150d <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  80152f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801533:	74 31                	je     801566 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801535:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801538:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  80153b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80153e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801541:	eb 16                	jmp    801559 <memcpy+0x66>
			*d8++ = *s8++;
  801543:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801546:	8d 50 01             	lea    0x1(%eax),%edx
  801549:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80154c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80154f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801552:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801555:	8a 12                	mov    (%edx),%dl
  801557:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801559:	8b 45 10             	mov    0x10(%ebp),%eax
  80155c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80155f:	89 55 10             	mov    %edx,0x10(%ebp)
  801562:	85 c0                	test   %eax,%eax
  801564:	75 dd                	jne    801543 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801566:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801569:	c9                   	leave  
  80156a:	c3                   	ret    

0080156b <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80156b:	55                   	push   %ebp
  80156c:	89 e5                	mov    %esp,%ebp
  80156e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801571:	8b 45 0c             	mov    0xc(%ebp),%eax
  801574:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801577:	8b 45 08             	mov    0x8(%ebp),%eax
  80157a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80157d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801580:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801583:	73 50                	jae    8015d5 <memmove+0x6a>
  801585:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801588:	8b 45 10             	mov    0x10(%ebp),%eax
  80158b:	01 d0                	add    %edx,%eax
  80158d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801590:	76 43                	jbe    8015d5 <memmove+0x6a>
		s += n;
  801592:	8b 45 10             	mov    0x10(%ebp),%eax
  801595:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801598:	8b 45 10             	mov    0x10(%ebp),%eax
  80159b:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80159e:	eb 10                	jmp    8015b0 <memmove+0x45>
			*--d = *--s;
  8015a0:	ff 4d f8             	decl   -0x8(%ebp)
  8015a3:	ff 4d fc             	decl   -0x4(%ebp)
  8015a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015a9:	8a 10                	mov    (%eax),%dl
  8015ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015ae:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8015b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8015b3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015b6:	89 55 10             	mov    %edx,0x10(%ebp)
  8015b9:	85 c0                	test   %eax,%eax
  8015bb:	75 e3                	jne    8015a0 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8015bd:	eb 23                	jmp    8015e2 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8015bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015c2:	8d 50 01             	lea    0x1(%eax),%edx
  8015c5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8015c8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015cb:	8d 4a 01             	lea    0x1(%edx),%ecx
  8015ce:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8015d1:	8a 12                	mov    (%edx),%dl
  8015d3:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8015d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8015d8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015db:	89 55 10             	mov    %edx,0x10(%ebp)
  8015de:	85 c0                	test   %eax,%eax
  8015e0:	75 dd                	jne    8015bf <memmove+0x54>
			*d++ = *s++;

	return dst;
  8015e2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015e5:	c9                   	leave  
  8015e6:	c3                   	ret    

008015e7 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8015e7:	55                   	push   %ebp
  8015e8:	89 e5                	mov    %esp,%ebp
  8015ea:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8015ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8015f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f6:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8015f9:	eb 2a                	jmp    801625 <memcmp+0x3e>
		if (*s1 != *s2)
  8015fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015fe:	8a 10                	mov    (%eax),%dl
  801600:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801603:	8a 00                	mov    (%eax),%al
  801605:	38 c2                	cmp    %al,%dl
  801607:	74 16                	je     80161f <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801609:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80160c:	8a 00                	mov    (%eax),%al
  80160e:	0f b6 d0             	movzbl %al,%edx
  801611:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801614:	8a 00                	mov    (%eax),%al
  801616:	0f b6 c0             	movzbl %al,%eax
  801619:	29 c2                	sub    %eax,%edx
  80161b:	89 d0                	mov    %edx,%eax
  80161d:	eb 18                	jmp    801637 <memcmp+0x50>
		s1++, s2++;
  80161f:	ff 45 fc             	incl   -0x4(%ebp)
  801622:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801625:	8b 45 10             	mov    0x10(%ebp),%eax
  801628:	8d 50 ff             	lea    -0x1(%eax),%edx
  80162b:	89 55 10             	mov    %edx,0x10(%ebp)
  80162e:	85 c0                	test   %eax,%eax
  801630:	75 c9                	jne    8015fb <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801632:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801637:	c9                   	leave  
  801638:	c3                   	ret    

00801639 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801639:	55                   	push   %ebp
  80163a:	89 e5                	mov    %esp,%ebp
  80163c:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80163f:	8b 55 08             	mov    0x8(%ebp),%edx
  801642:	8b 45 10             	mov    0x10(%ebp),%eax
  801645:	01 d0                	add    %edx,%eax
  801647:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80164a:	eb 15                	jmp    801661 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80164c:	8b 45 08             	mov    0x8(%ebp),%eax
  80164f:	8a 00                	mov    (%eax),%al
  801651:	0f b6 d0             	movzbl %al,%edx
  801654:	8b 45 0c             	mov    0xc(%ebp),%eax
  801657:	0f b6 c0             	movzbl %al,%eax
  80165a:	39 c2                	cmp    %eax,%edx
  80165c:	74 0d                	je     80166b <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80165e:	ff 45 08             	incl   0x8(%ebp)
  801661:	8b 45 08             	mov    0x8(%ebp),%eax
  801664:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801667:	72 e3                	jb     80164c <memfind+0x13>
  801669:	eb 01                	jmp    80166c <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80166b:	90                   	nop
	return (void *) s;
  80166c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80166f:	c9                   	leave  
  801670:	c3                   	ret    

00801671 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801671:	55                   	push   %ebp
  801672:	89 e5                	mov    %esp,%ebp
  801674:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801677:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80167e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801685:	eb 03                	jmp    80168a <strtol+0x19>
		s++;
  801687:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80168a:	8b 45 08             	mov    0x8(%ebp),%eax
  80168d:	8a 00                	mov    (%eax),%al
  80168f:	3c 20                	cmp    $0x20,%al
  801691:	74 f4                	je     801687 <strtol+0x16>
  801693:	8b 45 08             	mov    0x8(%ebp),%eax
  801696:	8a 00                	mov    (%eax),%al
  801698:	3c 09                	cmp    $0x9,%al
  80169a:	74 eb                	je     801687 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80169c:	8b 45 08             	mov    0x8(%ebp),%eax
  80169f:	8a 00                	mov    (%eax),%al
  8016a1:	3c 2b                	cmp    $0x2b,%al
  8016a3:	75 05                	jne    8016aa <strtol+0x39>
		s++;
  8016a5:	ff 45 08             	incl   0x8(%ebp)
  8016a8:	eb 13                	jmp    8016bd <strtol+0x4c>
	else if (*s == '-')
  8016aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ad:	8a 00                	mov    (%eax),%al
  8016af:	3c 2d                	cmp    $0x2d,%al
  8016b1:	75 0a                	jne    8016bd <strtol+0x4c>
		s++, neg = 1;
  8016b3:	ff 45 08             	incl   0x8(%ebp)
  8016b6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8016bd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016c1:	74 06                	je     8016c9 <strtol+0x58>
  8016c3:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8016c7:	75 20                	jne    8016e9 <strtol+0x78>
  8016c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cc:	8a 00                	mov    (%eax),%al
  8016ce:	3c 30                	cmp    $0x30,%al
  8016d0:	75 17                	jne    8016e9 <strtol+0x78>
  8016d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d5:	40                   	inc    %eax
  8016d6:	8a 00                	mov    (%eax),%al
  8016d8:	3c 78                	cmp    $0x78,%al
  8016da:	75 0d                	jne    8016e9 <strtol+0x78>
		s += 2, base = 16;
  8016dc:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8016e0:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8016e7:	eb 28                	jmp    801711 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8016e9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016ed:	75 15                	jne    801704 <strtol+0x93>
  8016ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f2:	8a 00                	mov    (%eax),%al
  8016f4:	3c 30                	cmp    $0x30,%al
  8016f6:	75 0c                	jne    801704 <strtol+0x93>
		s++, base = 8;
  8016f8:	ff 45 08             	incl   0x8(%ebp)
  8016fb:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801702:	eb 0d                	jmp    801711 <strtol+0xa0>
	else if (base == 0)
  801704:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801708:	75 07                	jne    801711 <strtol+0xa0>
		base = 10;
  80170a:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801711:	8b 45 08             	mov    0x8(%ebp),%eax
  801714:	8a 00                	mov    (%eax),%al
  801716:	3c 2f                	cmp    $0x2f,%al
  801718:	7e 19                	jle    801733 <strtol+0xc2>
  80171a:	8b 45 08             	mov    0x8(%ebp),%eax
  80171d:	8a 00                	mov    (%eax),%al
  80171f:	3c 39                	cmp    $0x39,%al
  801721:	7f 10                	jg     801733 <strtol+0xc2>
			dig = *s - '0';
  801723:	8b 45 08             	mov    0x8(%ebp),%eax
  801726:	8a 00                	mov    (%eax),%al
  801728:	0f be c0             	movsbl %al,%eax
  80172b:	83 e8 30             	sub    $0x30,%eax
  80172e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801731:	eb 42                	jmp    801775 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801733:	8b 45 08             	mov    0x8(%ebp),%eax
  801736:	8a 00                	mov    (%eax),%al
  801738:	3c 60                	cmp    $0x60,%al
  80173a:	7e 19                	jle    801755 <strtol+0xe4>
  80173c:	8b 45 08             	mov    0x8(%ebp),%eax
  80173f:	8a 00                	mov    (%eax),%al
  801741:	3c 7a                	cmp    $0x7a,%al
  801743:	7f 10                	jg     801755 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801745:	8b 45 08             	mov    0x8(%ebp),%eax
  801748:	8a 00                	mov    (%eax),%al
  80174a:	0f be c0             	movsbl %al,%eax
  80174d:	83 e8 57             	sub    $0x57,%eax
  801750:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801753:	eb 20                	jmp    801775 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801755:	8b 45 08             	mov    0x8(%ebp),%eax
  801758:	8a 00                	mov    (%eax),%al
  80175a:	3c 40                	cmp    $0x40,%al
  80175c:	7e 39                	jle    801797 <strtol+0x126>
  80175e:	8b 45 08             	mov    0x8(%ebp),%eax
  801761:	8a 00                	mov    (%eax),%al
  801763:	3c 5a                	cmp    $0x5a,%al
  801765:	7f 30                	jg     801797 <strtol+0x126>
			dig = *s - 'A' + 10;
  801767:	8b 45 08             	mov    0x8(%ebp),%eax
  80176a:	8a 00                	mov    (%eax),%al
  80176c:	0f be c0             	movsbl %al,%eax
  80176f:	83 e8 37             	sub    $0x37,%eax
  801772:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801775:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801778:	3b 45 10             	cmp    0x10(%ebp),%eax
  80177b:	7d 19                	jge    801796 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80177d:	ff 45 08             	incl   0x8(%ebp)
  801780:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801783:	0f af 45 10          	imul   0x10(%ebp),%eax
  801787:	89 c2                	mov    %eax,%edx
  801789:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80178c:	01 d0                	add    %edx,%eax
  80178e:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801791:	e9 7b ff ff ff       	jmp    801711 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801796:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801797:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80179b:	74 08                	je     8017a5 <strtol+0x134>
		*endptr = (char *) s;
  80179d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8017a3:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8017a5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8017a9:	74 07                	je     8017b2 <strtol+0x141>
  8017ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017ae:	f7 d8                	neg    %eax
  8017b0:	eb 03                	jmp    8017b5 <strtol+0x144>
  8017b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8017b5:	c9                   	leave  
  8017b6:	c3                   	ret    

008017b7 <ltostr>:

void
ltostr(long value, char *str)
{
  8017b7:	55                   	push   %ebp
  8017b8:	89 e5                	mov    %esp,%ebp
  8017ba:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8017bd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8017c4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8017cb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8017cf:	79 13                	jns    8017e4 <ltostr+0x2d>
	{
		neg = 1;
  8017d1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8017d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017db:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8017de:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8017e1:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8017e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e7:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8017ec:	99                   	cltd   
  8017ed:	f7 f9                	idiv   %ecx
  8017ef:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8017f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017f5:	8d 50 01             	lea    0x1(%eax),%edx
  8017f8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8017fb:	89 c2                	mov    %eax,%edx
  8017fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801800:	01 d0                	add    %edx,%eax
  801802:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801805:	83 c2 30             	add    $0x30,%edx
  801808:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80180a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80180d:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801812:	f7 e9                	imul   %ecx
  801814:	c1 fa 02             	sar    $0x2,%edx
  801817:	89 c8                	mov    %ecx,%eax
  801819:	c1 f8 1f             	sar    $0x1f,%eax
  80181c:	29 c2                	sub    %eax,%edx
  80181e:	89 d0                	mov    %edx,%eax
  801820:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801823:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801827:	75 bb                	jne    8017e4 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801829:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801830:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801833:	48                   	dec    %eax
  801834:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801837:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80183b:	74 3d                	je     80187a <ltostr+0xc3>
		start = 1 ;
  80183d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801844:	eb 34                	jmp    80187a <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801846:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801849:	8b 45 0c             	mov    0xc(%ebp),%eax
  80184c:	01 d0                	add    %edx,%eax
  80184e:	8a 00                	mov    (%eax),%al
  801850:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801853:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801856:	8b 45 0c             	mov    0xc(%ebp),%eax
  801859:	01 c2                	add    %eax,%edx
  80185b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80185e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801861:	01 c8                	add    %ecx,%eax
  801863:	8a 00                	mov    (%eax),%al
  801865:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801867:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80186a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80186d:	01 c2                	add    %eax,%edx
  80186f:	8a 45 eb             	mov    -0x15(%ebp),%al
  801872:	88 02                	mov    %al,(%edx)
		start++ ;
  801874:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801877:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80187a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80187d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801880:	7c c4                	jl     801846 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801882:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801885:	8b 45 0c             	mov    0xc(%ebp),%eax
  801888:	01 d0                	add    %edx,%eax
  80188a:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80188d:	90                   	nop
  80188e:	c9                   	leave  
  80188f:	c3                   	ret    

00801890 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801890:	55                   	push   %ebp
  801891:	89 e5                	mov    %esp,%ebp
  801893:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801896:	ff 75 08             	pushl  0x8(%ebp)
  801899:	e8 c4 f9 ff ff       	call   801262 <strlen>
  80189e:	83 c4 04             	add    $0x4,%esp
  8018a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8018a4:	ff 75 0c             	pushl  0xc(%ebp)
  8018a7:	e8 b6 f9 ff ff       	call   801262 <strlen>
  8018ac:	83 c4 04             	add    $0x4,%esp
  8018af:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8018b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8018b9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8018c0:	eb 17                	jmp    8018d9 <strcconcat+0x49>
		final[s] = str1[s] ;
  8018c2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8018c8:	01 c2                	add    %eax,%edx
  8018ca:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8018cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d0:	01 c8                	add    %ecx,%eax
  8018d2:	8a 00                	mov    (%eax),%al
  8018d4:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8018d6:	ff 45 fc             	incl   -0x4(%ebp)
  8018d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018dc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8018df:	7c e1                	jl     8018c2 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8018e1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8018e8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8018ef:	eb 1f                	jmp    801910 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8018f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018f4:	8d 50 01             	lea    0x1(%eax),%edx
  8018f7:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8018fa:	89 c2                	mov    %eax,%edx
  8018fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8018ff:	01 c2                	add    %eax,%edx
  801901:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801904:	8b 45 0c             	mov    0xc(%ebp),%eax
  801907:	01 c8                	add    %ecx,%eax
  801909:	8a 00                	mov    (%eax),%al
  80190b:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80190d:	ff 45 f8             	incl   -0x8(%ebp)
  801910:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801913:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801916:	7c d9                	jl     8018f1 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801918:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80191b:	8b 45 10             	mov    0x10(%ebp),%eax
  80191e:	01 d0                	add    %edx,%eax
  801920:	c6 00 00             	movb   $0x0,(%eax)
}
  801923:	90                   	nop
  801924:	c9                   	leave  
  801925:	c3                   	ret    

00801926 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801926:	55                   	push   %ebp
  801927:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801929:	8b 45 14             	mov    0x14(%ebp),%eax
  80192c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801932:	8b 45 14             	mov    0x14(%ebp),%eax
  801935:	8b 00                	mov    (%eax),%eax
  801937:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80193e:	8b 45 10             	mov    0x10(%ebp),%eax
  801941:	01 d0                	add    %edx,%eax
  801943:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801949:	eb 0c                	jmp    801957 <strsplit+0x31>
			*string++ = 0;
  80194b:	8b 45 08             	mov    0x8(%ebp),%eax
  80194e:	8d 50 01             	lea    0x1(%eax),%edx
  801951:	89 55 08             	mov    %edx,0x8(%ebp)
  801954:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801957:	8b 45 08             	mov    0x8(%ebp),%eax
  80195a:	8a 00                	mov    (%eax),%al
  80195c:	84 c0                	test   %al,%al
  80195e:	74 18                	je     801978 <strsplit+0x52>
  801960:	8b 45 08             	mov    0x8(%ebp),%eax
  801963:	8a 00                	mov    (%eax),%al
  801965:	0f be c0             	movsbl %al,%eax
  801968:	50                   	push   %eax
  801969:	ff 75 0c             	pushl  0xc(%ebp)
  80196c:	e8 83 fa ff ff       	call   8013f4 <strchr>
  801971:	83 c4 08             	add    $0x8,%esp
  801974:	85 c0                	test   %eax,%eax
  801976:	75 d3                	jne    80194b <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801978:	8b 45 08             	mov    0x8(%ebp),%eax
  80197b:	8a 00                	mov    (%eax),%al
  80197d:	84 c0                	test   %al,%al
  80197f:	74 5a                	je     8019db <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801981:	8b 45 14             	mov    0x14(%ebp),%eax
  801984:	8b 00                	mov    (%eax),%eax
  801986:	83 f8 0f             	cmp    $0xf,%eax
  801989:	75 07                	jne    801992 <strsplit+0x6c>
		{
			return 0;
  80198b:	b8 00 00 00 00       	mov    $0x0,%eax
  801990:	eb 66                	jmp    8019f8 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801992:	8b 45 14             	mov    0x14(%ebp),%eax
  801995:	8b 00                	mov    (%eax),%eax
  801997:	8d 48 01             	lea    0x1(%eax),%ecx
  80199a:	8b 55 14             	mov    0x14(%ebp),%edx
  80199d:	89 0a                	mov    %ecx,(%edx)
  80199f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8019a9:	01 c2                	add    %eax,%edx
  8019ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ae:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8019b0:	eb 03                	jmp    8019b5 <strsplit+0x8f>
			string++;
  8019b2:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8019b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b8:	8a 00                	mov    (%eax),%al
  8019ba:	84 c0                	test   %al,%al
  8019bc:	74 8b                	je     801949 <strsplit+0x23>
  8019be:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c1:	8a 00                	mov    (%eax),%al
  8019c3:	0f be c0             	movsbl %al,%eax
  8019c6:	50                   	push   %eax
  8019c7:	ff 75 0c             	pushl  0xc(%ebp)
  8019ca:	e8 25 fa ff ff       	call   8013f4 <strchr>
  8019cf:	83 c4 08             	add    $0x8,%esp
  8019d2:	85 c0                	test   %eax,%eax
  8019d4:	74 dc                	je     8019b2 <strsplit+0x8c>
			string++;
	}
  8019d6:	e9 6e ff ff ff       	jmp    801949 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8019db:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8019dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8019df:	8b 00                	mov    (%eax),%eax
  8019e1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8019eb:	01 d0                	add    %edx,%eax
  8019ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8019f3:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8019f8:	c9                   	leave  
  8019f9:	c3                   	ret    

008019fa <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8019fa:	55                   	push   %ebp
  8019fb:	89 e5                	mov    %esp,%ebp
  8019fd:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801a00:	8b 45 08             	mov    0x8(%ebp),%eax
  801a03:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801a06:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801a0d:	eb 4a                	jmp    801a59 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801a0f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a12:	8b 45 08             	mov    0x8(%ebp),%eax
  801a15:	01 c2                	add    %eax,%edx
  801a17:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801a1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a1d:	01 c8                	add    %ecx,%eax
  801a1f:	8a 00                	mov    (%eax),%al
  801a21:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801a23:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a26:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a29:	01 d0                	add    %edx,%eax
  801a2b:	8a 00                	mov    (%eax),%al
  801a2d:	3c 40                	cmp    $0x40,%al
  801a2f:	7e 25                	jle    801a56 <str2lower+0x5c>
  801a31:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a34:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a37:	01 d0                	add    %edx,%eax
  801a39:	8a 00                	mov    (%eax),%al
  801a3b:	3c 5a                	cmp    $0x5a,%al
  801a3d:	7f 17                	jg     801a56 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801a3f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a42:	8b 45 08             	mov    0x8(%ebp),%eax
  801a45:	01 d0                	add    %edx,%eax
  801a47:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801a4a:	8b 55 08             	mov    0x8(%ebp),%edx
  801a4d:	01 ca                	add    %ecx,%edx
  801a4f:	8a 12                	mov    (%edx),%dl
  801a51:	83 c2 20             	add    $0x20,%edx
  801a54:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801a56:	ff 45 fc             	incl   -0x4(%ebp)
  801a59:	ff 75 0c             	pushl  0xc(%ebp)
  801a5c:	e8 01 f8 ff ff       	call   801262 <strlen>
  801a61:	83 c4 04             	add    $0x4,%esp
  801a64:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801a67:	7f a6                	jg     801a0f <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801a69:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801a6c:	c9                   	leave  
  801a6d:	c3                   	ret    

00801a6e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801a6e:	55                   	push   %ebp
  801a6f:	89 e5                	mov    %esp,%ebp
  801a71:	57                   	push   %edi
  801a72:	56                   	push   %esi
  801a73:	53                   	push   %ebx
  801a74:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a77:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a7d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a80:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a83:	8b 7d 18             	mov    0x18(%ebp),%edi
  801a86:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801a89:	cd 30                	int    $0x30
  801a8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801a8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801a91:	83 c4 10             	add    $0x10,%esp
  801a94:	5b                   	pop    %ebx
  801a95:	5e                   	pop    %esi
  801a96:	5f                   	pop    %edi
  801a97:	5d                   	pop    %ebp
  801a98:	c3                   	ret    

00801a99 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801a99:	55                   	push   %ebp
  801a9a:	89 e5                	mov    %esp,%ebp
  801a9c:	83 ec 04             	sub    $0x4,%esp
  801a9f:	8b 45 10             	mov    0x10(%ebp),%eax
  801aa2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801aa5:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801aa8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801aac:	8b 45 08             	mov    0x8(%ebp),%eax
  801aaf:	6a 00                	push   $0x0
  801ab1:	51                   	push   %ecx
  801ab2:	52                   	push   %edx
  801ab3:	ff 75 0c             	pushl  0xc(%ebp)
  801ab6:	50                   	push   %eax
  801ab7:	6a 00                	push   $0x0
  801ab9:	e8 b0 ff ff ff       	call   801a6e <syscall>
  801abe:	83 c4 18             	add    $0x18,%esp
}
  801ac1:	90                   	nop
  801ac2:	c9                   	leave  
  801ac3:	c3                   	ret    

00801ac4 <sys_cgetc>:

int
sys_cgetc(void)
{
  801ac4:	55                   	push   %ebp
  801ac5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 00                	push   $0x0
  801acd:	6a 00                	push   $0x0
  801acf:	6a 00                	push   $0x0
  801ad1:	6a 02                	push   $0x2
  801ad3:	e8 96 ff ff ff       	call   801a6e <syscall>
  801ad8:	83 c4 18             	add    $0x18,%esp
}
  801adb:	c9                   	leave  
  801adc:	c3                   	ret    

00801add <sys_lock_cons>:

void sys_lock_cons(void)
{
  801add:	55                   	push   %ebp
  801ade:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 00                	push   $0x0
  801ae4:	6a 00                	push   $0x0
  801ae6:	6a 00                	push   $0x0
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 03                	push   $0x3
  801aec:	e8 7d ff ff ff       	call   801a6e <syscall>
  801af1:	83 c4 18             	add    $0x18,%esp
}
  801af4:	90                   	nop
  801af5:	c9                   	leave  
  801af6:	c3                   	ret    

00801af7 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801af7:	55                   	push   %ebp
  801af8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801afa:	6a 00                	push   $0x0
  801afc:	6a 00                	push   $0x0
  801afe:	6a 00                	push   $0x0
  801b00:	6a 00                	push   $0x0
  801b02:	6a 00                	push   $0x0
  801b04:	6a 04                	push   $0x4
  801b06:	e8 63 ff ff ff       	call   801a6e <syscall>
  801b0b:	83 c4 18             	add    $0x18,%esp
}
  801b0e:	90                   	nop
  801b0f:	c9                   	leave  
  801b10:	c3                   	ret    

00801b11 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801b11:	55                   	push   %ebp
  801b12:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801b14:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b17:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1a:	6a 00                	push   $0x0
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 00                	push   $0x0
  801b20:	52                   	push   %edx
  801b21:	50                   	push   %eax
  801b22:	6a 08                	push   $0x8
  801b24:	e8 45 ff ff ff       	call   801a6e <syscall>
  801b29:	83 c4 18             	add    $0x18,%esp
}
  801b2c:	c9                   	leave  
  801b2d:	c3                   	ret    

00801b2e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801b2e:	55                   	push   %ebp
  801b2f:	89 e5                	mov    %esp,%ebp
  801b31:	56                   	push   %esi
  801b32:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801b33:	8b 75 18             	mov    0x18(%ebp),%esi
  801b36:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b39:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b42:	56                   	push   %esi
  801b43:	53                   	push   %ebx
  801b44:	51                   	push   %ecx
  801b45:	52                   	push   %edx
  801b46:	50                   	push   %eax
  801b47:	6a 09                	push   $0x9
  801b49:	e8 20 ff ff ff       	call   801a6e <syscall>
  801b4e:	83 c4 18             	add    $0x18,%esp
}
  801b51:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b54:	5b                   	pop    %ebx
  801b55:	5e                   	pop    %esi
  801b56:	5d                   	pop    %ebp
  801b57:	c3                   	ret    

00801b58 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801b58:	55                   	push   %ebp
  801b59:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801b5b:	6a 00                	push   $0x0
  801b5d:	6a 00                	push   $0x0
  801b5f:	6a 00                	push   $0x0
  801b61:	6a 00                	push   $0x0
  801b63:	ff 75 08             	pushl  0x8(%ebp)
  801b66:	6a 0a                	push   $0xa
  801b68:	e8 01 ff ff ff       	call   801a6e <syscall>
  801b6d:	83 c4 18             	add    $0x18,%esp
}
  801b70:	c9                   	leave  
  801b71:	c3                   	ret    

00801b72 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801b72:	55                   	push   %ebp
  801b73:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801b75:	6a 00                	push   $0x0
  801b77:	6a 00                	push   $0x0
  801b79:	6a 00                	push   $0x0
  801b7b:	ff 75 0c             	pushl  0xc(%ebp)
  801b7e:	ff 75 08             	pushl  0x8(%ebp)
  801b81:	6a 0b                	push   $0xb
  801b83:	e8 e6 fe ff ff       	call   801a6e <syscall>
  801b88:	83 c4 18             	add    $0x18,%esp
}
  801b8b:	c9                   	leave  
  801b8c:	c3                   	ret    

00801b8d <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801b8d:	55                   	push   %ebp
  801b8e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801b90:	6a 00                	push   $0x0
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	6a 00                	push   $0x0
  801b98:	6a 00                	push   $0x0
  801b9a:	6a 0c                	push   $0xc
  801b9c:	e8 cd fe ff ff       	call   801a6e <syscall>
  801ba1:	83 c4 18             	add    $0x18,%esp
}
  801ba4:	c9                   	leave  
  801ba5:	c3                   	ret    

00801ba6 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801ba6:	55                   	push   %ebp
  801ba7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 00                	push   $0x0
  801bad:	6a 00                	push   $0x0
  801baf:	6a 00                	push   $0x0
  801bb1:	6a 00                	push   $0x0
  801bb3:	6a 0d                	push   $0xd
  801bb5:	e8 b4 fe ff ff       	call   801a6e <syscall>
  801bba:	83 c4 18             	add    $0x18,%esp
}
  801bbd:	c9                   	leave  
  801bbe:	c3                   	ret    

00801bbf <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801bbf:	55                   	push   %ebp
  801bc0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801bc2:	6a 00                	push   $0x0
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 00                	push   $0x0
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 0e                	push   $0xe
  801bce:	e8 9b fe ff ff       	call   801a6e <syscall>
  801bd3:	83 c4 18             	add    $0x18,%esp
}
  801bd6:	c9                   	leave  
  801bd7:	c3                   	ret    

00801bd8 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801bd8:	55                   	push   %ebp
  801bd9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 00                	push   $0x0
  801be3:	6a 00                	push   $0x0
  801be5:	6a 0f                	push   $0xf
  801be7:	e8 82 fe ff ff       	call   801a6e <syscall>
  801bec:	83 c4 18             	add    $0x18,%esp
}
  801bef:	c9                   	leave  
  801bf0:	c3                   	ret    

00801bf1 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801bf1:	55                   	push   %ebp
  801bf2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801bf4:	6a 00                	push   $0x0
  801bf6:	6a 00                	push   $0x0
  801bf8:	6a 00                	push   $0x0
  801bfa:	6a 00                	push   $0x0
  801bfc:	ff 75 08             	pushl  0x8(%ebp)
  801bff:	6a 10                	push   $0x10
  801c01:	e8 68 fe ff ff       	call   801a6e <syscall>
  801c06:	83 c4 18             	add    $0x18,%esp
}
  801c09:	c9                   	leave  
  801c0a:	c3                   	ret    

00801c0b <sys_scarce_memory>:

void sys_scarce_memory()
{
  801c0b:	55                   	push   %ebp
  801c0c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801c0e:	6a 00                	push   $0x0
  801c10:	6a 00                	push   $0x0
  801c12:	6a 00                	push   $0x0
  801c14:	6a 00                	push   $0x0
  801c16:	6a 00                	push   $0x0
  801c18:	6a 11                	push   $0x11
  801c1a:	e8 4f fe ff ff       	call   801a6e <syscall>
  801c1f:	83 c4 18             	add    $0x18,%esp
}
  801c22:	90                   	nop
  801c23:	c9                   	leave  
  801c24:	c3                   	ret    

00801c25 <sys_cputc>:

void
sys_cputc(const char c)
{
  801c25:	55                   	push   %ebp
  801c26:	89 e5                	mov    %esp,%ebp
  801c28:	83 ec 04             	sub    $0x4,%esp
  801c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801c31:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 00                	push   $0x0
  801c3d:	50                   	push   %eax
  801c3e:	6a 01                	push   $0x1
  801c40:	e8 29 fe ff ff       	call   801a6e <syscall>
  801c45:	83 c4 18             	add    $0x18,%esp
}
  801c48:	90                   	nop
  801c49:	c9                   	leave  
  801c4a:	c3                   	ret    

00801c4b <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801c4b:	55                   	push   %ebp
  801c4c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 00                	push   $0x0
  801c52:	6a 00                	push   $0x0
  801c54:	6a 00                	push   $0x0
  801c56:	6a 00                	push   $0x0
  801c58:	6a 14                	push   $0x14
  801c5a:	e8 0f fe ff ff       	call   801a6e <syscall>
  801c5f:	83 c4 18             	add    $0x18,%esp
}
  801c62:	90                   	nop
  801c63:	c9                   	leave  
  801c64:	c3                   	ret    

00801c65 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801c65:	55                   	push   %ebp
  801c66:	89 e5                	mov    %esp,%ebp
  801c68:	83 ec 04             	sub    $0x4,%esp
  801c6b:	8b 45 10             	mov    0x10(%ebp),%eax
  801c6e:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801c71:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c74:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c78:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7b:	6a 00                	push   $0x0
  801c7d:	51                   	push   %ecx
  801c7e:	52                   	push   %edx
  801c7f:	ff 75 0c             	pushl  0xc(%ebp)
  801c82:	50                   	push   %eax
  801c83:	6a 15                	push   $0x15
  801c85:	e8 e4 fd ff ff       	call   801a6e <syscall>
  801c8a:	83 c4 18             	add    $0x18,%esp
}
  801c8d:	c9                   	leave  
  801c8e:	c3                   	ret    

00801c8f <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801c8f:	55                   	push   %ebp
  801c90:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801c92:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c95:	8b 45 08             	mov    0x8(%ebp),%eax
  801c98:	6a 00                	push   $0x0
  801c9a:	6a 00                	push   $0x0
  801c9c:	6a 00                	push   $0x0
  801c9e:	52                   	push   %edx
  801c9f:	50                   	push   %eax
  801ca0:	6a 16                	push   $0x16
  801ca2:	e8 c7 fd ff ff       	call   801a6e <syscall>
  801ca7:	83 c4 18             	add    $0x18,%esp
}
  801caa:	c9                   	leave  
  801cab:	c3                   	ret    

00801cac <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801cac:	55                   	push   %ebp
  801cad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801caf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cb2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb8:	6a 00                	push   $0x0
  801cba:	6a 00                	push   $0x0
  801cbc:	51                   	push   %ecx
  801cbd:	52                   	push   %edx
  801cbe:	50                   	push   %eax
  801cbf:	6a 17                	push   $0x17
  801cc1:	e8 a8 fd ff ff       	call   801a6e <syscall>
  801cc6:	83 c4 18             	add    $0x18,%esp
}
  801cc9:	c9                   	leave  
  801cca:	c3                   	ret    

00801ccb <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801ccb:	55                   	push   %ebp
  801ccc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801cce:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 00                	push   $0x0
  801cda:	52                   	push   %edx
  801cdb:	50                   	push   %eax
  801cdc:	6a 18                	push   $0x18
  801cde:	e8 8b fd ff ff       	call   801a6e <syscall>
  801ce3:	83 c4 18             	add    $0x18,%esp
}
  801ce6:	c9                   	leave  
  801ce7:	c3                   	ret    

00801ce8 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801ce8:	55                   	push   %ebp
  801ce9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cee:	6a 00                	push   $0x0
  801cf0:	ff 75 14             	pushl  0x14(%ebp)
  801cf3:	ff 75 10             	pushl  0x10(%ebp)
  801cf6:	ff 75 0c             	pushl  0xc(%ebp)
  801cf9:	50                   	push   %eax
  801cfa:	6a 19                	push   $0x19
  801cfc:	e8 6d fd ff ff       	call   801a6e <syscall>
  801d01:	83 c4 18             	add    $0x18,%esp
}
  801d04:	c9                   	leave  
  801d05:	c3                   	ret    

00801d06 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801d06:	55                   	push   %ebp
  801d07:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801d09:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0c:	6a 00                	push   $0x0
  801d0e:	6a 00                	push   $0x0
  801d10:	6a 00                	push   $0x0
  801d12:	6a 00                	push   $0x0
  801d14:	50                   	push   %eax
  801d15:	6a 1a                	push   $0x1a
  801d17:	e8 52 fd ff ff       	call   801a6e <syscall>
  801d1c:	83 c4 18             	add    $0x18,%esp
}
  801d1f:	90                   	nop
  801d20:	c9                   	leave  
  801d21:	c3                   	ret    

00801d22 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801d22:	55                   	push   %ebp
  801d23:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801d25:	8b 45 08             	mov    0x8(%ebp),%eax
  801d28:	6a 00                	push   $0x0
  801d2a:	6a 00                	push   $0x0
  801d2c:	6a 00                	push   $0x0
  801d2e:	6a 00                	push   $0x0
  801d30:	50                   	push   %eax
  801d31:	6a 1b                	push   $0x1b
  801d33:	e8 36 fd ff ff       	call   801a6e <syscall>
  801d38:	83 c4 18             	add    $0x18,%esp
}
  801d3b:	c9                   	leave  
  801d3c:	c3                   	ret    

00801d3d <sys_getenvid>:

int32 sys_getenvid(void)
{
  801d3d:	55                   	push   %ebp
  801d3e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801d40:	6a 00                	push   $0x0
  801d42:	6a 00                	push   $0x0
  801d44:	6a 00                	push   $0x0
  801d46:	6a 00                	push   $0x0
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 05                	push   $0x5
  801d4c:	e8 1d fd ff ff       	call   801a6e <syscall>
  801d51:	83 c4 18             	add    $0x18,%esp
}
  801d54:	c9                   	leave  
  801d55:	c3                   	ret    

00801d56 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801d56:	55                   	push   %ebp
  801d57:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801d59:	6a 00                	push   $0x0
  801d5b:	6a 00                	push   $0x0
  801d5d:	6a 00                	push   $0x0
  801d5f:	6a 00                	push   $0x0
  801d61:	6a 00                	push   $0x0
  801d63:	6a 06                	push   $0x6
  801d65:	e8 04 fd ff ff       	call   801a6e <syscall>
  801d6a:	83 c4 18             	add    $0x18,%esp
}
  801d6d:	c9                   	leave  
  801d6e:	c3                   	ret    

00801d6f <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801d6f:	55                   	push   %ebp
  801d70:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801d72:	6a 00                	push   $0x0
  801d74:	6a 00                	push   $0x0
  801d76:	6a 00                	push   $0x0
  801d78:	6a 00                	push   $0x0
  801d7a:	6a 00                	push   $0x0
  801d7c:	6a 07                	push   $0x7
  801d7e:	e8 eb fc ff ff       	call   801a6e <syscall>
  801d83:	83 c4 18             	add    $0x18,%esp
}
  801d86:	c9                   	leave  
  801d87:	c3                   	ret    

00801d88 <sys_exit_env>:


void sys_exit_env(void)
{
  801d88:	55                   	push   %ebp
  801d89:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801d8b:	6a 00                	push   $0x0
  801d8d:	6a 00                	push   $0x0
  801d8f:	6a 00                	push   $0x0
  801d91:	6a 00                	push   $0x0
  801d93:	6a 00                	push   $0x0
  801d95:	6a 1c                	push   $0x1c
  801d97:	e8 d2 fc ff ff       	call   801a6e <syscall>
  801d9c:	83 c4 18             	add    $0x18,%esp
}
  801d9f:	90                   	nop
  801da0:	c9                   	leave  
  801da1:	c3                   	ret    

00801da2 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801da2:	55                   	push   %ebp
  801da3:	89 e5                	mov    %esp,%ebp
  801da5:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801da8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801dab:	8d 50 04             	lea    0x4(%eax),%edx
  801dae:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801db1:	6a 00                	push   $0x0
  801db3:	6a 00                	push   $0x0
  801db5:	6a 00                	push   $0x0
  801db7:	52                   	push   %edx
  801db8:	50                   	push   %eax
  801db9:	6a 1d                	push   $0x1d
  801dbb:	e8 ae fc ff ff       	call   801a6e <syscall>
  801dc0:	83 c4 18             	add    $0x18,%esp
	return result;
  801dc3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801dc6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801dc9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801dcc:	89 01                	mov    %eax,(%ecx)
  801dce:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd4:	c9                   	leave  
  801dd5:	c2 04 00             	ret    $0x4

00801dd8 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801dd8:	55                   	push   %ebp
  801dd9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801ddb:	6a 00                	push   $0x0
  801ddd:	6a 00                	push   $0x0
  801ddf:	ff 75 10             	pushl  0x10(%ebp)
  801de2:	ff 75 0c             	pushl  0xc(%ebp)
  801de5:	ff 75 08             	pushl  0x8(%ebp)
  801de8:	6a 13                	push   $0x13
  801dea:	e8 7f fc ff ff       	call   801a6e <syscall>
  801def:	83 c4 18             	add    $0x18,%esp
	return ;
  801df2:	90                   	nop
}
  801df3:	c9                   	leave  
  801df4:	c3                   	ret    

00801df5 <sys_rcr2>:
uint32 sys_rcr2()
{
  801df5:	55                   	push   %ebp
  801df6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 00                	push   $0x0
  801dfc:	6a 00                	push   $0x0
  801dfe:	6a 00                	push   $0x0
  801e00:	6a 00                	push   $0x0
  801e02:	6a 1e                	push   $0x1e
  801e04:	e8 65 fc ff ff       	call   801a6e <syscall>
  801e09:	83 c4 18             	add    $0x18,%esp
}
  801e0c:	c9                   	leave  
  801e0d:	c3                   	ret    

00801e0e <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801e0e:	55                   	push   %ebp
  801e0f:	89 e5                	mov    %esp,%ebp
  801e11:	83 ec 04             	sub    $0x4,%esp
  801e14:	8b 45 08             	mov    0x8(%ebp),%eax
  801e17:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801e1a:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801e1e:	6a 00                	push   $0x0
  801e20:	6a 00                	push   $0x0
  801e22:	6a 00                	push   $0x0
  801e24:	6a 00                	push   $0x0
  801e26:	50                   	push   %eax
  801e27:	6a 1f                	push   $0x1f
  801e29:	e8 40 fc ff ff       	call   801a6e <syscall>
  801e2e:	83 c4 18             	add    $0x18,%esp
	return ;
  801e31:	90                   	nop
}
  801e32:	c9                   	leave  
  801e33:	c3                   	ret    

00801e34 <rsttst>:
void rsttst()
{
  801e34:	55                   	push   %ebp
  801e35:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801e37:	6a 00                	push   $0x0
  801e39:	6a 00                	push   $0x0
  801e3b:	6a 00                	push   $0x0
  801e3d:	6a 00                	push   $0x0
  801e3f:	6a 00                	push   $0x0
  801e41:	6a 21                	push   $0x21
  801e43:	e8 26 fc ff ff       	call   801a6e <syscall>
  801e48:	83 c4 18             	add    $0x18,%esp
	return ;
  801e4b:	90                   	nop
}
  801e4c:	c9                   	leave  
  801e4d:	c3                   	ret    

00801e4e <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801e4e:	55                   	push   %ebp
  801e4f:	89 e5                	mov    %esp,%ebp
  801e51:	83 ec 04             	sub    $0x4,%esp
  801e54:	8b 45 14             	mov    0x14(%ebp),%eax
  801e57:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801e5a:	8b 55 18             	mov    0x18(%ebp),%edx
  801e5d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e61:	52                   	push   %edx
  801e62:	50                   	push   %eax
  801e63:	ff 75 10             	pushl  0x10(%ebp)
  801e66:	ff 75 0c             	pushl  0xc(%ebp)
  801e69:	ff 75 08             	pushl  0x8(%ebp)
  801e6c:	6a 20                	push   $0x20
  801e6e:	e8 fb fb ff ff       	call   801a6e <syscall>
  801e73:	83 c4 18             	add    $0x18,%esp
	return ;
  801e76:	90                   	nop
}
  801e77:	c9                   	leave  
  801e78:	c3                   	ret    

00801e79 <chktst>:
void chktst(uint32 n)
{
  801e79:	55                   	push   %ebp
  801e7a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801e7c:	6a 00                	push   $0x0
  801e7e:	6a 00                	push   $0x0
  801e80:	6a 00                	push   $0x0
  801e82:	6a 00                	push   $0x0
  801e84:	ff 75 08             	pushl  0x8(%ebp)
  801e87:	6a 22                	push   $0x22
  801e89:	e8 e0 fb ff ff       	call   801a6e <syscall>
  801e8e:	83 c4 18             	add    $0x18,%esp
	return ;
  801e91:	90                   	nop
}
  801e92:	c9                   	leave  
  801e93:	c3                   	ret    

00801e94 <inctst>:

void inctst()
{
  801e94:	55                   	push   %ebp
  801e95:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801e97:	6a 00                	push   $0x0
  801e99:	6a 00                	push   $0x0
  801e9b:	6a 00                	push   $0x0
  801e9d:	6a 00                	push   $0x0
  801e9f:	6a 00                	push   $0x0
  801ea1:	6a 23                	push   $0x23
  801ea3:	e8 c6 fb ff ff       	call   801a6e <syscall>
  801ea8:	83 c4 18             	add    $0x18,%esp
	return ;
  801eab:	90                   	nop
}
  801eac:	c9                   	leave  
  801ead:	c3                   	ret    

00801eae <gettst>:
uint32 gettst()
{
  801eae:	55                   	push   %ebp
  801eaf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801eb1:	6a 00                	push   $0x0
  801eb3:	6a 00                	push   $0x0
  801eb5:	6a 00                	push   $0x0
  801eb7:	6a 00                	push   $0x0
  801eb9:	6a 00                	push   $0x0
  801ebb:	6a 24                	push   $0x24
  801ebd:	e8 ac fb ff ff       	call   801a6e <syscall>
  801ec2:	83 c4 18             	add    $0x18,%esp
}
  801ec5:	c9                   	leave  
  801ec6:	c3                   	ret    

00801ec7 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801ec7:	55                   	push   %ebp
  801ec8:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801eca:	6a 00                	push   $0x0
  801ecc:	6a 00                	push   $0x0
  801ece:	6a 00                	push   $0x0
  801ed0:	6a 00                	push   $0x0
  801ed2:	6a 00                	push   $0x0
  801ed4:	6a 25                	push   $0x25
  801ed6:	e8 93 fb ff ff       	call   801a6e <syscall>
  801edb:	83 c4 18             	add    $0x18,%esp
  801ede:	a3 80 84 b2 00       	mov    %eax,0xb28480
	return uheapPlaceStrategy ;
  801ee3:	a1 80 84 b2 00       	mov    0xb28480,%eax
}
  801ee8:	c9                   	leave  
  801ee9:	c3                   	ret    

00801eea <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801eea:	55                   	push   %ebp
  801eeb:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801eed:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef0:	a3 80 84 b2 00       	mov    %eax,0xb28480
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ef5:	6a 00                	push   $0x0
  801ef7:	6a 00                	push   $0x0
  801ef9:	6a 00                	push   $0x0
  801efb:	6a 00                	push   $0x0
  801efd:	ff 75 08             	pushl  0x8(%ebp)
  801f00:	6a 26                	push   $0x26
  801f02:	e8 67 fb ff ff       	call   801a6e <syscall>
  801f07:	83 c4 18             	add    $0x18,%esp
	return ;
  801f0a:	90                   	nop
}
  801f0b:	c9                   	leave  
  801f0c:	c3                   	ret    

00801f0d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801f0d:	55                   	push   %ebp
  801f0e:	89 e5                	mov    %esp,%ebp
  801f10:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801f11:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f14:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f17:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1d:	6a 00                	push   $0x0
  801f1f:	53                   	push   %ebx
  801f20:	51                   	push   %ecx
  801f21:	52                   	push   %edx
  801f22:	50                   	push   %eax
  801f23:	6a 27                	push   $0x27
  801f25:	e8 44 fb ff ff       	call   801a6e <syscall>
  801f2a:	83 c4 18             	add    $0x18,%esp
}
  801f2d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f30:	c9                   	leave  
  801f31:	c3                   	ret    

00801f32 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f32:	55                   	push   %ebp
  801f33:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f35:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f38:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3b:	6a 00                	push   $0x0
  801f3d:	6a 00                	push   $0x0
  801f3f:	6a 00                	push   $0x0
  801f41:	52                   	push   %edx
  801f42:	50                   	push   %eax
  801f43:	6a 28                	push   $0x28
  801f45:	e8 24 fb ff ff       	call   801a6e <syscall>
  801f4a:	83 c4 18             	add    $0x18,%esp
}
  801f4d:	c9                   	leave  
  801f4e:	c3                   	ret    

00801f4f <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801f4f:	55                   	push   %ebp
  801f50:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801f52:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801f55:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f58:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5b:	6a 00                	push   $0x0
  801f5d:	51                   	push   %ecx
  801f5e:	ff 75 10             	pushl  0x10(%ebp)
  801f61:	52                   	push   %edx
  801f62:	50                   	push   %eax
  801f63:	6a 29                	push   $0x29
  801f65:	e8 04 fb ff ff       	call   801a6e <syscall>
  801f6a:	83 c4 18             	add    $0x18,%esp
}
  801f6d:	c9                   	leave  
  801f6e:	c3                   	ret    

00801f6f <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801f6f:	55                   	push   %ebp
  801f70:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801f72:	6a 00                	push   $0x0
  801f74:	6a 00                	push   $0x0
  801f76:	ff 75 10             	pushl  0x10(%ebp)
  801f79:	ff 75 0c             	pushl  0xc(%ebp)
  801f7c:	ff 75 08             	pushl  0x8(%ebp)
  801f7f:	6a 12                	push   $0x12
  801f81:	e8 e8 fa ff ff       	call   801a6e <syscall>
  801f86:	83 c4 18             	add    $0x18,%esp
	return ;
  801f89:	90                   	nop
}
  801f8a:	c9                   	leave  
  801f8b:	c3                   	ret    

00801f8c <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801f8c:	55                   	push   %ebp
  801f8d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801f8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f92:	8b 45 08             	mov    0x8(%ebp),%eax
  801f95:	6a 00                	push   $0x0
  801f97:	6a 00                	push   $0x0
  801f99:	6a 00                	push   $0x0
  801f9b:	52                   	push   %edx
  801f9c:	50                   	push   %eax
  801f9d:	6a 2a                	push   $0x2a
  801f9f:	e8 ca fa ff ff       	call   801a6e <syscall>
  801fa4:	83 c4 18             	add    $0x18,%esp
	return;
  801fa7:	90                   	nop
}
  801fa8:	c9                   	leave  
  801fa9:	c3                   	ret    

00801faa <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801faa:	55                   	push   %ebp
  801fab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801fad:	6a 00                	push   $0x0
  801faf:	6a 00                	push   $0x0
  801fb1:	6a 00                	push   $0x0
  801fb3:	6a 00                	push   $0x0
  801fb5:	6a 00                	push   $0x0
  801fb7:	6a 2b                	push   $0x2b
  801fb9:	e8 b0 fa ff ff       	call   801a6e <syscall>
  801fbe:	83 c4 18             	add    $0x18,%esp
}
  801fc1:	c9                   	leave  
  801fc2:	c3                   	ret    

00801fc3 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801fc3:	55                   	push   %ebp
  801fc4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801fc6:	6a 00                	push   $0x0
  801fc8:	6a 00                	push   $0x0
  801fca:	6a 00                	push   $0x0
  801fcc:	ff 75 0c             	pushl  0xc(%ebp)
  801fcf:	ff 75 08             	pushl  0x8(%ebp)
  801fd2:	6a 2d                	push   $0x2d
  801fd4:	e8 95 fa ff ff       	call   801a6e <syscall>
  801fd9:	83 c4 18             	add    $0x18,%esp
	return;
  801fdc:	90                   	nop
}
  801fdd:	c9                   	leave  
  801fde:	c3                   	ret    

00801fdf <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801fdf:	55                   	push   %ebp
  801fe0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801fe2:	6a 00                	push   $0x0
  801fe4:	6a 00                	push   $0x0
  801fe6:	6a 00                	push   $0x0
  801fe8:	ff 75 0c             	pushl  0xc(%ebp)
  801feb:	ff 75 08             	pushl  0x8(%ebp)
  801fee:	6a 2c                	push   $0x2c
  801ff0:	e8 79 fa ff ff       	call   801a6e <syscall>
  801ff5:	83 c4 18             	add    $0x18,%esp
	return ;
  801ff8:	90                   	nop
}
  801ff9:	c9                   	leave  
  801ffa:	c3                   	ret    

00801ffb <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801ffb:	55                   	push   %ebp
  801ffc:	89 e5                	mov    %esp,%ebp
  801ffe:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  802001:	83 ec 04             	sub    $0x4,%esp
  802004:	68 a8 2a 80 00       	push   $0x802aa8
  802009:	68 25 01 00 00       	push   $0x125
  80200e:	68 db 2a 80 00       	push   $0x802adb
  802013:	e8 a3 e8 ff ff       	call   8008bb <_panic>

00802018 <__udivdi3>:
  802018:	55                   	push   %ebp
  802019:	57                   	push   %edi
  80201a:	56                   	push   %esi
  80201b:	53                   	push   %ebx
  80201c:	83 ec 1c             	sub    $0x1c,%esp
  80201f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802023:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802027:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80202b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80202f:	89 ca                	mov    %ecx,%edx
  802031:	89 f8                	mov    %edi,%eax
  802033:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802037:	85 f6                	test   %esi,%esi
  802039:	75 2d                	jne    802068 <__udivdi3+0x50>
  80203b:	39 cf                	cmp    %ecx,%edi
  80203d:	77 65                	ja     8020a4 <__udivdi3+0x8c>
  80203f:	89 fd                	mov    %edi,%ebp
  802041:	85 ff                	test   %edi,%edi
  802043:	75 0b                	jne    802050 <__udivdi3+0x38>
  802045:	b8 01 00 00 00       	mov    $0x1,%eax
  80204a:	31 d2                	xor    %edx,%edx
  80204c:	f7 f7                	div    %edi
  80204e:	89 c5                	mov    %eax,%ebp
  802050:	31 d2                	xor    %edx,%edx
  802052:	89 c8                	mov    %ecx,%eax
  802054:	f7 f5                	div    %ebp
  802056:	89 c1                	mov    %eax,%ecx
  802058:	89 d8                	mov    %ebx,%eax
  80205a:	f7 f5                	div    %ebp
  80205c:	89 cf                	mov    %ecx,%edi
  80205e:	89 fa                	mov    %edi,%edx
  802060:	83 c4 1c             	add    $0x1c,%esp
  802063:	5b                   	pop    %ebx
  802064:	5e                   	pop    %esi
  802065:	5f                   	pop    %edi
  802066:	5d                   	pop    %ebp
  802067:	c3                   	ret    
  802068:	39 ce                	cmp    %ecx,%esi
  80206a:	77 28                	ja     802094 <__udivdi3+0x7c>
  80206c:	0f bd fe             	bsr    %esi,%edi
  80206f:	83 f7 1f             	xor    $0x1f,%edi
  802072:	75 40                	jne    8020b4 <__udivdi3+0x9c>
  802074:	39 ce                	cmp    %ecx,%esi
  802076:	72 0a                	jb     802082 <__udivdi3+0x6a>
  802078:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80207c:	0f 87 9e 00 00 00    	ja     802120 <__udivdi3+0x108>
  802082:	b8 01 00 00 00       	mov    $0x1,%eax
  802087:	89 fa                	mov    %edi,%edx
  802089:	83 c4 1c             	add    $0x1c,%esp
  80208c:	5b                   	pop    %ebx
  80208d:	5e                   	pop    %esi
  80208e:	5f                   	pop    %edi
  80208f:	5d                   	pop    %ebp
  802090:	c3                   	ret    
  802091:	8d 76 00             	lea    0x0(%esi),%esi
  802094:	31 ff                	xor    %edi,%edi
  802096:	31 c0                	xor    %eax,%eax
  802098:	89 fa                	mov    %edi,%edx
  80209a:	83 c4 1c             	add    $0x1c,%esp
  80209d:	5b                   	pop    %ebx
  80209e:	5e                   	pop    %esi
  80209f:	5f                   	pop    %edi
  8020a0:	5d                   	pop    %ebp
  8020a1:	c3                   	ret    
  8020a2:	66 90                	xchg   %ax,%ax
  8020a4:	89 d8                	mov    %ebx,%eax
  8020a6:	f7 f7                	div    %edi
  8020a8:	31 ff                	xor    %edi,%edi
  8020aa:	89 fa                	mov    %edi,%edx
  8020ac:	83 c4 1c             	add    $0x1c,%esp
  8020af:	5b                   	pop    %ebx
  8020b0:	5e                   	pop    %esi
  8020b1:	5f                   	pop    %edi
  8020b2:	5d                   	pop    %ebp
  8020b3:	c3                   	ret    
  8020b4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8020b9:	89 eb                	mov    %ebp,%ebx
  8020bb:	29 fb                	sub    %edi,%ebx
  8020bd:	89 f9                	mov    %edi,%ecx
  8020bf:	d3 e6                	shl    %cl,%esi
  8020c1:	89 c5                	mov    %eax,%ebp
  8020c3:	88 d9                	mov    %bl,%cl
  8020c5:	d3 ed                	shr    %cl,%ebp
  8020c7:	89 e9                	mov    %ebp,%ecx
  8020c9:	09 f1                	or     %esi,%ecx
  8020cb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8020cf:	89 f9                	mov    %edi,%ecx
  8020d1:	d3 e0                	shl    %cl,%eax
  8020d3:	89 c5                	mov    %eax,%ebp
  8020d5:	89 d6                	mov    %edx,%esi
  8020d7:	88 d9                	mov    %bl,%cl
  8020d9:	d3 ee                	shr    %cl,%esi
  8020db:	89 f9                	mov    %edi,%ecx
  8020dd:	d3 e2                	shl    %cl,%edx
  8020df:	8b 44 24 08          	mov    0x8(%esp),%eax
  8020e3:	88 d9                	mov    %bl,%cl
  8020e5:	d3 e8                	shr    %cl,%eax
  8020e7:	09 c2                	or     %eax,%edx
  8020e9:	89 d0                	mov    %edx,%eax
  8020eb:	89 f2                	mov    %esi,%edx
  8020ed:	f7 74 24 0c          	divl   0xc(%esp)
  8020f1:	89 d6                	mov    %edx,%esi
  8020f3:	89 c3                	mov    %eax,%ebx
  8020f5:	f7 e5                	mul    %ebp
  8020f7:	39 d6                	cmp    %edx,%esi
  8020f9:	72 19                	jb     802114 <__udivdi3+0xfc>
  8020fb:	74 0b                	je     802108 <__udivdi3+0xf0>
  8020fd:	89 d8                	mov    %ebx,%eax
  8020ff:	31 ff                	xor    %edi,%edi
  802101:	e9 58 ff ff ff       	jmp    80205e <__udivdi3+0x46>
  802106:	66 90                	xchg   %ax,%ax
  802108:	8b 54 24 08          	mov    0x8(%esp),%edx
  80210c:	89 f9                	mov    %edi,%ecx
  80210e:	d3 e2                	shl    %cl,%edx
  802110:	39 c2                	cmp    %eax,%edx
  802112:	73 e9                	jae    8020fd <__udivdi3+0xe5>
  802114:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802117:	31 ff                	xor    %edi,%edi
  802119:	e9 40 ff ff ff       	jmp    80205e <__udivdi3+0x46>
  80211e:	66 90                	xchg   %ax,%ax
  802120:	31 c0                	xor    %eax,%eax
  802122:	e9 37 ff ff ff       	jmp    80205e <__udivdi3+0x46>
  802127:	90                   	nop

00802128 <__umoddi3>:
  802128:	55                   	push   %ebp
  802129:	57                   	push   %edi
  80212a:	56                   	push   %esi
  80212b:	53                   	push   %ebx
  80212c:	83 ec 1c             	sub    $0x1c,%esp
  80212f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802133:	8b 74 24 34          	mov    0x34(%esp),%esi
  802137:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80213b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80213f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802143:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802147:	89 f3                	mov    %esi,%ebx
  802149:	89 fa                	mov    %edi,%edx
  80214b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80214f:	89 34 24             	mov    %esi,(%esp)
  802152:	85 c0                	test   %eax,%eax
  802154:	75 1a                	jne    802170 <__umoddi3+0x48>
  802156:	39 f7                	cmp    %esi,%edi
  802158:	0f 86 a2 00 00 00    	jbe    802200 <__umoddi3+0xd8>
  80215e:	89 c8                	mov    %ecx,%eax
  802160:	89 f2                	mov    %esi,%edx
  802162:	f7 f7                	div    %edi
  802164:	89 d0                	mov    %edx,%eax
  802166:	31 d2                	xor    %edx,%edx
  802168:	83 c4 1c             	add    $0x1c,%esp
  80216b:	5b                   	pop    %ebx
  80216c:	5e                   	pop    %esi
  80216d:	5f                   	pop    %edi
  80216e:	5d                   	pop    %ebp
  80216f:	c3                   	ret    
  802170:	39 f0                	cmp    %esi,%eax
  802172:	0f 87 ac 00 00 00    	ja     802224 <__umoddi3+0xfc>
  802178:	0f bd e8             	bsr    %eax,%ebp
  80217b:	83 f5 1f             	xor    $0x1f,%ebp
  80217e:	0f 84 ac 00 00 00    	je     802230 <__umoddi3+0x108>
  802184:	bf 20 00 00 00       	mov    $0x20,%edi
  802189:	29 ef                	sub    %ebp,%edi
  80218b:	89 fe                	mov    %edi,%esi
  80218d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802191:	89 e9                	mov    %ebp,%ecx
  802193:	d3 e0                	shl    %cl,%eax
  802195:	89 d7                	mov    %edx,%edi
  802197:	89 f1                	mov    %esi,%ecx
  802199:	d3 ef                	shr    %cl,%edi
  80219b:	09 c7                	or     %eax,%edi
  80219d:	89 e9                	mov    %ebp,%ecx
  80219f:	d3 e2                	shl    %cl,%edx
  8021a1:	89 14 24             	mov    %edx,(%esp)
  8021a4:	89 d8                	mov    %ebx,%eax
  8021a6:	d3 e0                	shl    %cl,%eax
  8021a8:	89 c2                	mov    %eax,%edx
  8021aa:	8b 44 24 08          	mov    0x8(%esp),%eax
  8021ae:	d3 e0                	shl    %cl,%eax
  8021b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021b4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8021b8:	89 f1                	mov    %esi,%ecx
  8021ba:	d3 e8                	shr    %cl,%eax
  8021bc:	09 d0                	or     %edx,%eax
  8021be:	d3 eb                	shr    %cl,%ebx
  8021c0:	89 da                	mov    %ebx,%edx
  8021c2:	f7 f7                	div    %edi
  8021c4:	89 d3                	mov    %edx,%ebx
  8021c6:	f7 24 24             	mull   (%esp)
  8021c9:	89 c6                	mov    %eax,%esi
  8021cb:	89 d1                	mov    %edx,%ecx
  8021cd:	39 d3                	cmp    %edx,%ebx
  8021cf:	0f 82 87 00 00 00    	jb     80225c <__umoddi3+0x134>
  8021d5:	0f 84 91 00 00 00    	je     80226c <__umoddi3+0x144>
  8021db:	8b 54 24 04          	mov    0x4(%esp),%edx
  8021df:	29 f2                	sub    %esi,%edx
  8021e1:	19 cb                	sbb    %ecx,%ebx
  8021e3:	89 d8                	mov    %ebx,%eax
  8021e5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8021e9:	d3 e0                	shl    %cl,%eax
  8021eb:	89 e9                	mov    %ebp,%ecx
  8021ed:	d3 ea                	shr    %cl,%edx
  8021ef:	09 d0                	or     %edx,%eax
  8021f1:	89 e9                	mov    %ebp,%ecx
  8021f3:	d3 eb                	shr    %cl,%ebx
  8021f5:	89 da                	mov    %ebx,%edx
  8021f7:	83 c4 1c             	add    $0x1c,%esp
  8021fa:	5b                   	pop    %ebx
  8021fb:	5e                   	pop    %esi
  8021fc:	5f                   	pop    %edi
  8021fd:	5d                   	pop    %ebp
  8021fe:	c3                   	ret    
  8021ff:	90                   	nop
  802200:	89 fd                	mov    %edi,%ebp
  802202:	85 ff                	test   %edi,%edi
  802204:	75 0b                	jne    802211 <__umoddi3+0xe9>
  802206:	b8 01 00 00 00       	mov    $0x1,%eax
  80220b:	31 d2                	xor    %edx,%edx
  80220d:	f7 f7                	div    %edi
  80220f:	89 c5                	mov    %eax,%ebp
  802211:	89 f0                	mov    %esi,%eax
  802213:	31 d2                	xor    %edx,%edx
  802215:	f7 f5                	div    %ebp
  802217:	89 c8                	mov    %ecx,%eax
  802219:	f7 f5                	div    %ebp
  80221b:	89 d0                	mov    %edx,%eax
  80221d:	e9 44 ff ff ff       	jmp    802166 <__umoddi3+0x3e>
  802222:	66 90                	xchg   %ax,%ax
  802224:	89 c8                	mov    %ecx,%eax
  802226:	89 f2                	mov    %esi,%edx
  802228:	83 c4 1c             	add    $0x1c,%esp
  80222b:	5b                   	pop    %ebx
  80222c:	5e                   	pop    %esi
  80222d:	5f                   	pop    %edi
  80222e:	5d                   	pop    %ebp
  80222f:	c3                   	ret    
  802230:	3b 04 24             	cmp    (%esp),%eax
  802233:	72 06                	jb     80223b <__umoddi3+0x113>
  802235:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802239:	77 0f                	ja     80224a <__umoddi3+0x122>
  80223b:	89 f2                	mov    %esi,%edx
  80223d:	29 f9                	sub    %edi,%ecx
  80223f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802243:	89 14 24             	mov    %edx,(%esp)
  802246:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80224a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80224e:	8b 14 24             	mov    (%esp),%edx
  802251:	83 c4 1c             	add    $0x1c,%esp
  802254:	5b                   	pop    %ebx
  802255:	5e                   	pop    %esi
  802256:	5f                   	pop    %edi
  802257:	5d                   	pop    %ebp
  802258:	c3                   	ret    
  802259:	8d 76 00             	lea    0x0(%esi),%esi
  80225c:	2b 04 24             	sub    (%esp),%eax
  80225f:	19 fa                	sbb    %edi,%edx
  802261:	89 d1                	mov    %edx,%ecx
  802263:	89 c6                	mov    %eax,%esi
  802265:	e9 71 ff ff ff       	jmp    8021db <__umoddi3+0xb3>
  80226a:	66 90                	xchg   %ax,%ax
  80226c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802270:	72 ea                	jb     80225c <__umoddi3+0x134>
  802272:	89 d9                	mov    %ebx,%ecx
  802274:	e9 62 ff ff ff       	jmp    8021db <__umoddi3+0xb3>

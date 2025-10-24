
obj/user/arrayOperations_mergesort_static:     file format elf32-i386


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
  800031:	e8 91 04 00 00       	call   8004c7 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

//int *Left;
//int *Right;

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 38             	sub    $0x38,%esp
	int32 parentenvID = sys_getparentenvid();
  80003e:	e8 b1 1a 00 00       	call   801af4 <sys_getparentenvid>
  800043:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int ret;

	/*[1] GET SEMAPHORES*/
	struct semaphore ready = get_semaphore(parentenvID, "Ready");
  800046:	8d 45 dc             	lea    -0x24(%ebp),%eax
  800049:	83 ec 04             	sub    $0x4,%esp
  80004c:	68 c0 23 80 00       	push   $0x8023c0
  800051:	ff 75 f0             	pushl  -0x10(%ebp)
  800054:	50                   	push   %eax
  800055:	e8 a5 1e 00 00       	call   801eff <get_semaphore>
  80005a:	83 c4 0c             	add    $0xc,%esp
	struct semaphore finished = get_semaphore(parentenvID, "Finished");
  80005d:	8d 45 d8             	lea    -0x28(%ebp),%eax
  800060:	83 ec 04             	sub    $0x4,%esp
  800063:	68 c6 23 80 00       	push   $0x8023c6
  800068:	ff 75 f0             	pushl  -0x10(%ebp)
  80006b:	50                   	push   %eax
  80006c:	e8 8e 1e 00 00       	call   801eff <get_semaphore>
  800071:	83 c4 0c             	add    $0xc,%esp

	/*[2] WAIT A READY SIGNAL FROM THE MASTER*/
	wait_semaphore(ready);
  800074:	83 ec 0c             	sub    $0xc,%esp
  800077:	ff 75 dc             	pushl  -0x24(%ebp)
  80007a:	e8 9a 1e 00 00       	call   801f19 <wait_semaphore>
  80007f:	83 c4 10             	add    $0x10,%esp

	/*[3] GET SHARED VARs*/
	//Get the cons_mutex ownerID
	int* consMutexOwnerID = sget(parentenvID, "cons_mutex ownerID") ;
  800082:	83 ec 08             	sub    $0x8,%esp
  800085:	68 cf 23 80 00       	push   $0x8023cf
  80008a:	ff 75 f0             	pushl  -0x10(%ebp)
  80008d:	e8 03 17 00 00       	call   801795 <sget>
  800092:	83 c4 10             	add    $0x10,%esp
  800095:	89 45 ec             	mov    %eax,-0x14(%ebp)
	struct semaphore cons_mutex = get_semaphore(*consMutexOwnerID, "Console Mutex");
  800098:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80009b:	8b 10                	mov    (%eax),%edx
  80009d:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  8000a0:	83 ec 04             	sub    $0x4,%esp
  8000a3:	68 e2 23 80 00       	push   $0x8023e2
  8000a8:	52                   	push   %edx
  8000a9:	50                   	push   %eax
  8000aa:	e8 50 1e 00 00       	call   801eff <get_semaphore>
  8000af:	83 c4 0c             	add    $0xc,%esp

	//Get the shared array & its size
	int *numOfElements = NULL;
  8000b2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	int *sharedArray = NULL;
  8000b9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	sharedArray = sget(parentenvID, "arr") ;
  8000c0:	83 ec 08             	sub    $0x8,%esp
  8000c3:	68 f0 23 80 00       	push   $0x8023f0
  8000c8:	ff 75 f0             	pushl  -0x10(%ebp)
  8000cb:	e8 c5 16 00 00       	call   801795 <sget>
  8000d0:	83 c4 10             	add    $0x10,%esp
  8000d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	numOfElements = sget(parentenvID, "arrSize") ;
  8000d6:	83 ec 08             	sub    $0x8,%esp
  8000d9:	68 f4 23 80 00       	push   $0x8023f4
  8000de:	ff 75 f0             	pushl  -0x10(%ebp)
  8000e1:	e8 af 16 00 00       	call   801795 <sget>
  8000e6:	83 c4 10             	add    $0x10,%esp
  8000e9:	89 45 e8             	mov    %eax,-0x18(%ebp)

	/*[4] DO THE JOB*/
	//take a copy from the original array
	int *sortedArray;

	sortedArray = smalloc("mergesortedArr", sizeof(int) * *numOfElements, 0) ;
  8000ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000ef:	8b 00                	mov    (%eax),%eax
  8000f1:	c1 e0 02             	shl    $0x2,%eax
  8000f4:	83 ec 04             	sub    $0x4,%esp
  8000f7:	6a 00                	push   $0x0
  8000f9:	50                   	push   %eax
  8000fa:	68 fc 23 80 00       	push   $0x8023fc
  8000ff:	e8 5d 16 00 00       	call   801761 <smalloc>
  800104:	83 c4 10             	add    $0x10,%esp
  800107:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  80010a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800111:	eb 25                	jmp    800138 <_main+0x100>
	{
		sortedArray[i] = sharedArray[i];
  800113:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800116:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80011d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800120:	01 c2                	add    %eax,%edx
  800122:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800125:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80012c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80012f:	01 c8                	add    %ecx,%eax
  800131:	8b 00                	mov    (%eax),%eax
  800133:	89 02                	mov    %eax,(%edx)
	//take a copy from the original array
	int *sortedArray;

	sortedArray = smalloc("mergesortedArr", sizeof(int) * *numOfElements, 0) ;
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  800135:	ff 45 f4             	incl   -0xc(%ebp)
  800138:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80013b:	8b 00                	mov    (%eax),%eax
  80013d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800140:	7f d1                	jg     800113 <_main+0xdb>
	}
//	//Create two temps array for "left" & "right"
//	Left = smalloc("mergesortLeftArr", sizeof(int) * (*numOfElements), 1) ;
//	Right = smalloc("mergesortRightArr", sizeof(int) * (*numOfElements), 1) ;

	MSort(sortedArray, 1, *numOfElements);
  800142:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800145:	8b 00                	mov    (%eax),%eax
  800147:	83 ec 04             	sub    $0x4,%esp
  80014a:	50                   	push   %eax
  80014b:	6a 01                	push   $0x1
  80014d:	ff 75 e0             	pushl  -0x20(%ebp)
  800150:	e8 39 01 00 00       	call   80028e <MSort>
  800155:	83 c4 10             	add    $0x10,%esp

	wait_semaphore(cons_mutex);
  800158:	83 ec 0c             	sub    $0xc,%esp
  80015b:	ff 75 d4             	pushl  -0x2c(%ebp)
  80015e:	e8 b6 1d 00 00       	call   801f19 <wait_semaphore>
  800163:	83 c4 10             	add    $0x10,%esp
	{
		cprintf("Merge sort is Finished!!!!\n") ;
  800166:	83 ec 0c             	sub    $0xc,%esp
  800169:	68 0b 24 80 00       	push   $0x80240b
  80016e:	e8 e4 05 00 00       	call   800757 <cprintf>
  800173:	83 c4 10             	add    $0x10,%esp
		cprintf("will notify the master now...\n");
  800176:	83 ec 0c             	sub    $0xc,%esp
  800179:	68 28 24 80 00       	push   $0x802428
  80017e:	e8 d4 05 00 00       	call   800757 <cprintf>
  800183:	83 c4 10             	add    $0x10,%esp
		cprintf("Merge sort says GOOD BYE :)\n") ;
  800186:	83 ec 0c             	sub    $0xc,%esp
  800189:	68 47 24 80 00       	push   $0x802447
  80018e:	e8 c4 05 00 00       	call   800757 <cprintf>
  800193:	83 c4 10             	add    $0x10,%esp
	}
	signal_semaphore(cons_mutex);
  800196:	83 ec 0c             	sub    $0xc,%esp
  800199:	ff 75 d4             	pushl  -0x2c(%ebp)
  80019c:	e8 92 1d 00 00       	call   801f33 <signal_semaphore>
  8001a1:	83 c4 10             	add    $0x10,%esp

	/*[5] DECLARE FINISHING*/
	signal_semaphore(finished);
  8001a4:	83 ec 0c             	sub    $0xc,%esp
  8001a7:	ff 75 d8             	pushl  -0x28(%ebp)
  8001aa:	e8 84 1d 00 00       	call   801f33 <signal_semaphore>
  8001af:	83 c4 10             	add    $0x10,%esp
}
  8001b2:	90                   	nop
  8001b3:	c9                   	leave  
  8001b4:	c3                   	ret    

008001b5 <Swap>:

void Swap(int *Elements, int First, int Second)
{
  8001b5:	55                   	push   %ebp
  8001b6:	89 e5                	mov    %esp,%ebp
  8001b8:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  8001bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001be:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8001c8:	01 d0                	add    %edx,%eax
  8001ca:	8b 00                	mov    (%eax),%eax
  8001cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  8001cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001d2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8001dc:	01 c2                	add    %eax,%edx
  8001de:	8b 45 10             	mov    0x10(%ebp),%eax
  8001e1:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8001e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8001eb:	01 c8                	add    %ecx,%eax
  8001ed:	8b 00                	mov    (%eax),%eax
  8001ef:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  8001f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8001f4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8001fe:	01 c2                	add    %eax,%edx
  800200:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800203:	89 02                	mov    %eax,(%edx)
}
  800205:	90                   	nop
  800206:	c9                   	leave  
  800207:	c3                   	ret    

00800208 <PrintElements>:


void PrintElements(int *Elements, int NumOfElements)
{
  800208:	55                   	push   %ebp
  800209:	89 e5                	mov    %esp,%ebp
  80020b:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  80020e:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800215:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80021c:	eb 42                	jmp    800260 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  80021e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800221:	99                   	cltd   
  800222:	f7 7d f0             	idivl  -0x10(%ebp)
  800225:	89 d0                	mov    %edx,%eax
  800227:	85 c0                	test   %eax,%eax
  800229:	75 10                	jne    80023b <PrintElements+0x33>
			cprintf("\n");
  80022b:	83 ec 0c             	sub    $0xc,%esp
  80022e:	68 64 24 80 00       	push   $0x802464
  800233:	e8 1f 05 00 00       	call   800757 <cprintf>
  800238:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  80023b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80023e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800245:	8b 45 08             	mov    0x8(%ebp),%eax
  800248:	01 d0                	add    %edx,%eax
  80024a:	8b 00                	mov    (%eax),%eax
  80024c:	83 ec 08             	sub    $0x8,%esp
  80024f:	50                   	push   %eax
  800250:	68 66 24 80 00       	push   $0x802466
  800255:	e8 fd 04 00 00       	call   800757 <cprintf>
  80025a:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80025d:	ff 45 f4             	incl   -0xc(%ebp)
  800260:	8b 45 0c             	mov    0xc(%ebp),%eax
  800263:	48                   	dec    %eax
  800264:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800267:	7f b5                	jg     80021e <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  800269:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80026c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800273:	8b 45 08             	mov    0x8(%ebp),%eax
  800276:	01 d0                	add    %edx,%eax
  800278:	8b 00                	mov    (%eax),%eax
  80027a:	83 ec 08             	sub    $0x8,%esp
  80027d:	50                   	push   %eax
  80027e:	68 6b 24 80 00       	push   $0x80246b
  800283:	e8 cf 04 00 00       	call   800757 <cprintf>
  800288:	83 c4 10             	add    $0x10,%esp

}
  80028b:	90                   	nop
  80028c:	c9                   	leave  
  80028d:	c3                   	ret    

0080028e <MSort>:


void MSort(int* A, int p, int r)
{
  80028e:	55                   	push   %ebp
  80028f:	89 e5                	mov    %esp,%ebp
  800291:	83 ec 18             	sub    $0x18,%esp
	if (p >= r)
  800294:	8b 45 0c             	mov    0xc(%ebp),%eax
  800297:	3b 45 10             	cmp    0x10(%ebp),%eax
  80029a:	7d 54                	jge    8002f0 <MSort+0x62>
	{
		return;
	}

	int q = (p + r) / 2;
  80029c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80029f:	8b 45 10             	mov    0x10(%ebp),%eax
  8002a2:	01 d0                	add    %edx,%eax
  8002a4:	89 c2                	mov    %eax,%edx
  8002a6:	c1 ea 1f             	shr    $0x1f,%edx
  8002a9:	01 d0                	add    %edx,%eax
  8002ab:	d1 f8                	sar    %eax
  8002ad:	89 45 f4             	mov    %eax,-0xc(%ebp)

	MSort(A, p, q);
  8002b0:	83 ec 04             	sub    $0x4,%esp
  8002b3:	ff 75 f4             	pushl  -0xc(%ebp)
  8002b6:	ff 75 0c             	pushl  0xc(%ebp)
  8002b9:	ff 75 08             	pushl  0x8(%ebp)
  8002bc:	e8 cd ff ff ff       	call   80028e <MSort>
  8002c1:	83 c4 10             	add    $0x10,%esp
//	cprintf("LEFT is sorted: from %d to %d\n", p, q);

	MSort(A, q + 1, r);
  8002c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002c7:	40                   	inc    %eax
  8002c8:	83 ec 04             	sub    $0x4,%esp
  8002cb:	ff 75 10             	pushl  0x10(%ebp)
  8002ce:	50                   	push   %eax
  8002cf:	ff 75 08             	pushl  0x8(%ebp)
  8002d2:	e8 b7 ff ff ff       	call   80028e <MSort>
  8002d7:	83 c4 10             	add    $0x10,%esp
//	cprintf("RIGHT is sorted: from %d to %d\n", q+1, r);

	Merge(A, p, q, r);
  8002da:	ff 75 10             	pushl  0x10(%ebp)
  8002dd:	ff 75 f4             	pushl  -0xc(%ebp)
  8002e0:	ff 75 0c             	pushl  0xc(%ebp)
  8002e3:	ff 75 08             	pushl  0x8(%ebp)
  8002e6:	e8 08 00 00 00       	call   8002f3 <Merge>
  8002eb:	83 c4 10             	add    $0x10,%esp
  8002ee:	eb 01                	jmp    8002f1 <MSort+0x63>

void MSort(int* A, int p, int r)
{
	if (p >= r)
	{
		return;
  8002f0:	90                   	nop
//	cprintf("RIGHT is sorted: from %d to %d\n", q+1, r);

	Merge(A, p, q, r);
	//cprintf("[%d %d] + [%d %d] = [%d %d]\n", p, q, q+1, r, p, r);

}
  8002f1:	c9                   	leave  
  8002f2:	c3                   	ret    

008002f3 <Merge>:

void Merge(int* A, int p, int q, int r)
{
  8002f3:	55                   	push   %ebp
  8002f4:	89 e5                	mov    %esp,%ebp
  8002f6:	83 ec 30             	sub    $0x30,%esp
	int leftCapacity = q - p + 1;
  8002f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8002fc:	2b 45 0c             	sub    0xc(%ebp),%eax
  8002ff:	40                   	inc    %eax
  800300:	89 45 e8             	mov    %eax,-0x18(%ebp)

	int rightCapacity = r - q;
  800303:	8b 45 14             	mov    0x14(%ebp),%eax
  800306:	2b 45 10             	sub    0x10(%ebp),%eax
  800309:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	int leftIndex = 0;
  80030c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

	int rightIndex = 0;
  800313:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	//int* Left = malloc(sizeof(int) * leftCapacity);
	int* Left = __Left ;
  80031a:	c7 45 e0 60 30 80 00 	movl   $0x803060,-0x20(%ebp)
	int* Right = __Right;
  800321:	c7 45 dc c0 cb 87 00 	movl   $0x87cbc0,-0x24(%ebp)
	//int* Right = malloc(sizeof(int) * rightCapacity);

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  800328:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80032f:	eb 2f                	jmp    800360 <Merge+0x6d>
	{
		Left[i] = A[p + i - 1];
  800331:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800334:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80033b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80033e:	01 c2                	add    %eax,%edx
  800340:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800343:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800346:	01 c8                	add    %ecx,%eax
  800348:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80034d:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800354:	8b 45 08             	mov    0x8(%ebp),%eax
  800357:	01 c8                	add    %ecx,%eax
  800359:	8b 00                	mov    (%eax),%eax
  80035b:	89 02                	mov    %eax,(%edx)
	int* Left = __Left ;
	int* Right = __Right;
	//int* Right = malloc(sizeof(int) * rightCapacity);

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  80035d:	ff 45 f4             	incl   -0xc(%ebp)
  800360:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800363:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  800366:	7c c9                	jl     800331 <Merge+0x3e>
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  800368:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80036f:	eb 2a                	jmp    80039b <Merge+0xa8>
	{
		Right[j] = A[q + j];
  800371:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800374:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80037b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80037e:	01 c2                	add    %eax,%edx
  800380:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800383:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800386:	01 c8                	add    %ecx,%eax
  800388:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80038f:	8b 45 08             	mov    0x8(%ebp),%eax
  800392:	01 c8                	add    %ecx,%eax
  800394:	8b 00                	mov    (%eax),%eax
  800396:	89 02                	mov    %eax,(%edx)
	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  800398:	ff 45 f0             	incl   -0x10(%ebp)
  80039b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80039e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8003a1:	7c ce                	jl     800371 <Merge+0x7e>
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8003a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003a6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8003a9:	e9 0a 01 00 00       	jmp    8004b8 <Merge+0x1c5>
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
  8003ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003b1:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8003b4:	0f 8d 95 00 00 00    	jge    80044f <Merge+0x15c>
  8003ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003bd:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8003c0:	0f 8d 89 00 00 00    	jge    80044f <Merge+0x15c>
		{
			if (Left[leftIndex] < Right[rightIndex] )
  8003c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003c9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003d3:	01 d0                	add    %edx,%eax
  8003d5:	8b 10                	mov    (%eax),%edx
  8003d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003da:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003e1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003e4:	01 c8                	add    %ecx,%eax
  8003e6:	8b 00                	mov    (%eax),%eax
  8003e8:	39 c2                	cmp    %eax,%edx
  8003ea:	7d 33                	jge    80041f <Merge+0x12c>
			{
				A[k - 1] = Left[leftIndex++];
  8003ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003ef:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8003f4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fe:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800401:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800404:	8d 50 01             	lea    0x1(%eax),%edx
  800407:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80040a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800411:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800414:	01 d0                	add    %edx,%eax
  800416:	8b 00                	mov    (%eax),%eax
  800418:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  80041a:	e9 96 00 00 00       	jmp    8004b5 <Merge+0x1c2>
			{
				A[k - 1] = Left[leftIndex++];
			}
			else
			{
				A[k - 1] = Right[rightIndex++];
  80041f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800422:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800427:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80042e:	8b 45 08             	mov    0x8(%ebp),%eax
  800431:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800434:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800437:	8d 50 01             	lea    0x1(%eax),%edx
  80043a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80043d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800444:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800447:	01 d0                	add    %edx,%eax
  800449:	8b 00                	mov    (%eax),%eax
  80044b:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  80044d:	eb 66                	jmp    8004b5 <Merge+0x1c2>
			else
			{
				A[k - 1] = Right[rightIndex++];
			}
		}
		else if (leftIndex < leftCapacity)
  80044f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800452:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  800455:	7d 30                	jge    800487 <Merge+0x194>
		{
			A[k - 1] = Left[leftIndex++];
  800457:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80045a:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80045f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800466:	8b 45 08             	mov    0x8(%ebp),%eax
  800469:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80046c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80046f:	8d 50 01             	lea    0x1(%eax),%edx
  800472:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800475:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80047c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80047f:	01 d0                	add    %edx,%eax
  800481:	8b 00                	mov    (%eax),%eax
  800483:	89 01                	mov    %eax,(%ecx)
  800485:	eb 2e                	jmp    8004b5 <Merge+0x1c2>
		}
		else
		{
			A[k - 1] = Right[rightIndex++];
  800487:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80048a:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80048f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800496:	8b 45 08             	mov    0x8(%ebp),%eax
  800499:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80049c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80049f:	8d 50 01             	lea    0x1(%eax),%edx
  8004a2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8004a5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004ac:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004af:	01 d0                	add    %edx,%eax
  8004b1:	8b 00                	mov    (%eax),%eax
  8004b3:	89 01                	mov    %eax,(%ecx)
	for (j = 0; j < rightCapacity; j++)
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8004b5:	ff 45 ec             	incl   -0x14(%ebp)
  8004b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8004bb:	3b 45 14             	cmp    0x14(%ebp),%eax
  8004be:	0f 8e ea fe ff ff    	jle    8003ae <Merge+0xbb>
		{
			A[k - 1] = Right[rightIndex++];
		}
	}

}
  8004c4:	90                   	nop
  8004c5:	c9                   	leave  
  8004c6:	c3                   	ret    

008004c7 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8004c7:	55                   	push   %ebp
  8004c8:	89 e5                	mov    %esp,%ebp
  8004ca:	57                   	push   %edi
  8004cb:	56                   	push   %esi
  8004cc:	53                   	push   %ebx
  8004cd:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8004d0:	e8 06 16 00 00       	call   801adb <sys_getenvindex>
  8004d5:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8004d8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8004db:	89 d0                	mov    %edx,%eax
  8004dd:	c1 e0 02             	shl    $0x2,%eax
  8004e0:	01 d0                	add    %edx,%eax
  8004e2:	c1 e0 03             	shl    $0x3,%eax
  8004e5:	01 d0                	add    %edx,%eax
  8004e7:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8004ee:	01 d0                	add    %edx,%eax
  8004f0:	c1 e0 02             	shl    $0x2,%eax
  8004f3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8004f8:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8004fd:	a1 20 30 80 00       	mov    0x803020,%eax
  800502:	8a 40 20             	mov    0x20(%eax),%al
  800505:	84 c0                	test   %al,%al
  800507:	74 0d                	je     800516 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800509:	a1 20 30 80 00       	mov    0x803020,%eax
  80050e:	83 c0 20             	add    $0x20,%eax
  800511:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800516:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80051a:	7e 0a                	jle    800526 <libmain+0x5f>
		binaryname = argv[0];
  80051c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80051f:	8b 00                	mov    (%eax),%eax
  800521:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  800526:	83 ec 08             	sub    $0x8,%esp
  800529:	ff 75 0c             	pushl  0xc(%ebp)
  80052c:	ff 75 08             	pushl  0x8(%ebp)
  80052f:	e8 04 fb ff ff       	call   800038 <_main>
  800534:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800537:	a1 00 30 80 00       	mov    0x803000,%eax
  80053c:	85 c0                	test   %eax,%eax
  80053e:	0f 84 01 01 00 00    	je     800645 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800544:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80054a:	bb 68 25 80 00       	mov    $0x802568,%ebx
  80054f:	ba 0e 00 00 00       	mov    $0xe,%edx
  800554:	89 c7                	mov    %eax,%edi
  800556:	89 de                	mov    %ebx,%esi
  800558:	89 d1                	mov    %edx,%ecx
  80055a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80055c:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80055f:	b9 56 00 00 00       	mov    $0x56,%ecx
  800564:	b0 00                	mov    $0x0,%al
  800566:	89 d7                	mov    %edx,%edi
  800568:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80056a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800571:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800574:	83 ec 08             	sub    $0x8,%esp
  800577:	50                   	push   %eax
  800578:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80057e:	50                   	push   %eax
  80057f:	e8 8d 17 00 00       	call   801d11 <sys_utilities>
  800584:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800587:	e8 d6 12 00 00       	call   801862 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80058c:	83 ec 0c             	sub    $0xc,%esp
  80058f:	68 88 24 80 00       	push   $0x802488
  800594:	e8 be 01 00 00       	call   800757 <cprintf>
  800599:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80059c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80059f:	85 c0                	test   %eax,%eax
  8005a1:	74 18                	je     8005bb <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8005a3:	e8 87 17 00 00       	call   801d2f <sys_get_optimal_num_faults>
  8005a8:	83 ec 08             	sub    $0x8,%esp
  8005ab:	50                   	push   %eax
  8005ac:	68 b0 24 80 00       	push   $0x8024b0
  8005b1:	e8 a1 01 00 00       	call   800757 <cprintf>
  8005b6:	83 c4 10             	add    $0x10,%esp
  8005b9:	eb 59                	jmp    800614 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8005bb:	a1 20 30 80 00       	mov    0x803020,%eax
  8005c0:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8005c6:	a1 20 30 80 00       	mov    0x803020,%eax
  8005cb:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  8005d1:	83 ec 04             	sub    $0x4,%esp
  8005d4:	52                   	push   %edx
  8005d5:	50                   	push   %eax
  8005d6:	68 d4 24 80 00       	push   $0x8024d4
  8005db:	e8 77 01 00 00       	call   800757 <cprintf>
  8005e0:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8005e3:	a1 20 30 80 00       	mov    0x803020,%eax
  8005e8:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8005ee:	a1 20 30 80 00       	mov    0x803020,%eax
  8005f3:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  8005f9:	a1 20 30 80 00       	mov    0x803020,%eax
  8005fe:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  800604:	51                   	push   %ecx
  800605:	52                   	push   %edx
  800606:	50                   	push   %eax
  800607:	68 fc 24 80 00       	push   $0x8024fc
  80060c:	e8 46 01 00 00       	call   800757 <cprintf>
  800611:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800614:	a1 20 30 80 00       	mov    0x803020,%eax
  800619:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  80061f:	83 ec 08             	sub    $0x8,%esp
  800622:	50                   	push   %eax
  800623:	68 54 25 80 00       	push   $0x802554
  800628:	e8 2a 01 00 00       	call   800757 <cprintf>
  80062d:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800630:	83 ec 0c             	sub    $0xc,%esp
  800633:	68 88 24 80 00       	push   $0x802488
  800638:	e8 1a 01 00 00       	call   800757 <cprintf>
  80063d:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800640:	e8 37 12 00 00       	call   80187c <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800645:	e8 1f 00 00 00       	call   800669 <exit>
}
  80064a:	90                   	nop
  80064b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80064e:	5b                   	pop    %ebx
  80064f:	5e                   	pop    %esi
  800650:	5f                   	pop    %edi
  800651:	5d                   	pop    %ebp
  800652:	c3                   	ret    

00800653 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800653:	55                   	push   %ebp
  800654:	89 e5                	mov    %esp,%ebp
  800656:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800659:	83 ec 0c             	sub    $0xc,%esp
  80065c:	6a 00                	push   $0x0
  80065e:	e8 44 14 00 00       	call   801aa7 <sys_destroy_env>
  800663:	83 c4 10             	add    $0x10,%esp
}
  800666:	90                   	nop
  800667:	c9                   	leave  
  800668:	c3                   	ret    

00800669 <exit>:

void
exit(void)
{
  800669:	55                   	push   %ebp
  80066a:	89 e5                	mov    %esp,%ebp
  80066c:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80066f:	e8 99 14 00 00       	call   801b0d <sys_exit_env>
}
  800674:	90                   	nop
  800675:	c9                   	leave  
  800676:	c3                   	ret    

00800677 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800677:	55                   	push   %ebp
  800678:	89 e5                	mov    %esp,%ebp
  80067a:	53                   	push   %ebx
  80067b:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  80067e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800681:	8b 00                	mov    (%eax),%eax
  800683:	8d 48 01             	lea    0x1(%eax),%ecx
  800686:	8b 55 0c             	mov    0xc(%ebp),%edx
  800689:	89 0a                	mov    %ecx,(%edx)
  80068b:	8b 55 08             	mov    0x8(%ebp),%edx
  80068e:	88 d1                	mov    %dl,%cl
  800690:	8b 55 0c             	mov    0xc(%ebp),%edx
  800693:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800697:	8b 45 0c             	mov    0xc(%ebp),%eax
  80069a:	8b 00                	mov    (%eax),%eax
  80069c:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006a1:	75 30                	jne    8006d3 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8006a3:	8b 15 44 e6 8d 00    	mov    0x8de644,%edx
  8006a9:	a0 e0 4a 86 00       	mov    0x864ae0,%al
  8006ae:	0f b6 c0             	movzbl %al,%eax
  8006b1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006b4:	8b 09                	mov    (%ecx),%ecx
  8006b6:	89 cb                	mov    %ecx,%ebx
  8006b8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006bb:	83 c1 08             	add    $0x8,%ecx
  8006be:	52                   	push   %edx
  8006bf:	50                   	push   %eax
  8006c0:	53                   	push   %ebx
  8006c1:	51                   	push   %ecx
  8006c2:	e8 57 11 00 00       	call   80181e <sys_cputs>
  8006c7:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d6:	8b 40 04             	mov    0x4(%eax),%eax
  8006d9:	8d 50 01             	lea    0x1(%eax),%edx
  8006dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006df:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006e2:	90                   	nop
  8006e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006e6:	c9                   	leave  
  8006e7:	c3                   	ret    

008006e8 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006e8:	55                   	push   %ebp
  8006e9:	89 e5                	mov    %esp,%ebp
  8006eb:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006f1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006f8:	00 00 00 
	b.cnt = 0;
  8006fb:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800702:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800705:	ff 75 0c             	pushl  0xc(%ebp)
  800708:	ff 75 08             	pushl  0x8(%ebp)
  80070b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800711:	50                   	push   %eax
  800712:	68 77 06 80 00       	push   $0x800677
  800717:	e8 5a 02 00 00       	call   800976 <vprintfmt>
  80071c:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  80071f:	8b 15 44 e6 8d 00    	mov    0x8de644,%edx
  800725:	a0 e0 4a 86 00       	mov    0x864ae0,%al
  80072a:	0f b6 c0             	movzbl %al,%eax
  80072d:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800733:	52                   	push   %edx
  800734:	50                   	push   %eax
  800735:	51                   	push   %ecx
  800736:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80073c:	83 c0 08             	add    $0x8,%eax
  80073f:	50                   	push   %eax
  800740:	e8 d9 10 00 00       	call   80181e <sys_cputs>
  800745:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800748:	c6 05 e0 4a 86 00 00 	movb   $0x0,0x864ae0
	return b.cnt;
  80074f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800755:	c9                   	leave  
  800756:	c3                   	ret    

00800757 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800757:	55                   	push   %ebp
  800758:	89 e5                	mov    %esp,%ebp
  80075a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80075d:	c6 05 e0 4a 86 00 01 	movb   $0x1,0x864ae0
	va_start(ap, fmt);
  800764:	8d 45 0c             	lea    0xc(%ebp),%eax
  800767:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80076a:	8b 45 08             	mov    0x8(%ebp),%eax
  80076d:	83 ec 08             	sub    $0x8,%esp
  800770:	ff 75 f4             	pushl  -0xc(%ebp)
  800773:	50                   	push   %eax
  800774:	e8 6f ff ff ff       	call   8006e8 <vcprintf>
  800779:	83 c4 10             	add    $0x10,%esp
  80077c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80077f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800782:	c9                   	leave  
  800783:	c3                   	ret    

00800784 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800784:	55                   	push   %ebp
  800785:	89 e5                	mov    %esp,%ebp
  800787:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80078a:	c6 05 e0 4a 86 00 01 	movb   $0x1,0x864ae0
	curTextClr = (textClr << 8) ; //set text color by the given value
  800791:	8b 45 08             	mov    0x8(%ebp),%eax
  800794:	c1 e0 08             	shl    $0x8,%eax
  800797:	a3 44 e6 8d 00       	mov    %eax,0x8de644
	va_start(ap, fmt);
  80079c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80079f:	83 c0 04             	add    $0x4,%eax
  8007a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007a8:	83 ec 08             	sub    $0x8,%esp
  8007ab:	ff 75 f4             	pushl  -0xc(%ebp)
  8007ae:	50                   	push   %eax
  8007af:	e8 34 ff ff ff       	call   8006e8 <vcprintf>
  8007b4:	83 c4 10             	add    $0x10,%esp
  8007b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8007ba:	c7 05 44 e6 8d 00 00 	movl   $0x700,0x8de644
  8007c1:	07 00 00 

	return cnt;
  8007c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007c7:	c9                   	leave  
  8007c8:	c3                   	ret    

008007c9 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8007c9:	55                   	push   %ebp
  8007ca:	89 e5                	mov    %esp,%ebp
  8007cc:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8007cf:	e8 8e 10 00 00       	call   801862 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8007d4:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8007da:	8b 45 08             	mov    0x8(%ebp),%eax
  8007dd:	83 ec 08             	sub    $0x8,%esp
  8007e0:	ff 75 f4             	pushl  -0xc(%ebp)
  8007e3:	50                   	push   %eax
  8007e4:	e8 ff fe ff ff       	call   8006e8 <vcprintf>
  8007e9:	83 c4 10             	add    $0x10,%esp
  8007ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8007ef:	e8 88 10 00 00       	call   80187c <sys_unlock_cons>
	return cnt;
  8007f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007f7:	c9                   	leave  
  8007f8:	c3                   	ret    

008007f9 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007f9:	55                   	push   %ebp
  8007fa:	89 e5                	mov    %esp,%ebp
  8007fc:	53                   	push   %ebx
  8007fd:	83 ec 14             	sub    $0x14,%esp
  800800:	8b 45 10             	mov    0x10(%ebp),%eax
  800803:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800806:	8b 45 14             	mov    0x14(%ebp),%eax
  800809:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80080c:	8b 45 18             	mov    0x18(%ebp),%eax
  80080f:	ba 00 00 00 00       	mov    $0x0,%edx
  800814:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800817:	77 55                	ja     80086e <printnum+0x75>
  800819:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80081c:	72 05                	jb     800823 <printnum+0x2a>
  80081e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800821:	77 4b                	ja     80086e <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800823:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800826:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800829:	8b 45 18             	mov    0x18(%ebp),%eax
  80082c:	ba 00 00 00 00       	mov    $0x0,%edx
  800831:	52                   	push   %edx
  800832:	50                   	push   %eax
  800833:	ff 75 f4             	pushl  -0xc(%ebp)
  800836:	ff 75 f0             	pushl  -0x10(%ebp)
  800839:	e8 0a 19 00 00       	call   802148 <__udivdi3>
  80083e:	83 c4 10             	add    $0x10,%esp
  800841:	83 ec 04             	sub    $0x4,%esp
  800844:	ff 75 20             	pushl  0x20(%ebp)
  800847:	53                   	push   %ebx
  800848:	ff 75 18             	pushl  0x18(%ebp)
  80084b:	52                   	push   %edx
  80084c:	50                   	push   %eax
  80084d:	ff 75 0c             	pushl  0xc(%ebp)
  800850:	ff 75 08             	pushl  0x8(%ebp)
  800853:	e8 a1 ff ff ff       	call   8007f9 <printnum>
  800858:	83 c4 20             	add    $0x20,%esp
  80085b:	eb 1a                	jmp    800877 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80085d:	83 ec 08             	sub    $0x8,%esp
  800860:	ff 75 0c             	pushl  0xc(%ebp)
  800863:	ff 75 20             	pushl  0x20(%ebp)
  800866:	8b 45 08             	mov    0x8(%ebp),%eax
  800869:	ff d0                	call   *%eax
  80086b:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80086e:	ff 4d 1c             	decl   0x1c(%ebp)
  800871:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800875:	7f e6                	jg     80085d <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800877:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80087a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80087f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800882:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800885:	53                   	push   %ebx
  800886:	51                   	push   %ecx
  800887:	52                   	push   %edx
  800888:	50                   	push   %eax
  800889:	e8 ca 19 00 00       	call   802258 <__umoddi3>
  80088e:	83 c4 10             	add    $0x10,%esp
  800891:	05 f4 27 80 00       	add    $0x8027f4,%eax
  800896:	8a 00                	mov    (%eax),%al
  800898:	0f be c0             	movsbl %al,%eax
  80089b:	83 ec 08             	sub    $0x8,%esp
  80089e:	ff 75 0c             	pushl  0xc(%ebp)
  8008a1:	50                   	push   %eax
  8008a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a5:	ff d0                	call   *%eax
  8008a7:	83 c4 10             	add    $0x10,%esp
}
  8008aa:	90                   	nop
  8008ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008ae:	c9                   	leave  
  8008af:	c3                   	ret    

008008b0 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008b0:	55                   	push   %ebp
  8008b1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008b3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008b7:	7e 1c                	jle    8008d5 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bc:	8b 00                	mov    (%eax),%eax
  8008be:	8d 50 08             	lea    0x8(%eax),%edx
  8008c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c4:	89 10                	mov    %edx,(%eax)
  8008c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c9:	8b 00                	mov    (%eax),%eax
  8008cb:	83 e8 08             	sub    $0x8,%eax
  8008ce:	8b 50 04             	mov    0x4(%eax),%edx
  8008d1:	8b 00                	mov    (%eax),%eax
  8008d3:	eb 40                	jmp    800915 <getuint+0x65>
	else if (lflag)
  8008d5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008d9:	74 1e                	je     8008f9 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008db:	8b 45 08             	mov    0x8(%ebp),%eax
  8008de:	8b 00                	mov    (%eax),%eax
  8008e0:	8d 50 04             	lea    0x4(%eax),%edx
  8008e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e6:	89 10                	mov    %edx,(%eax)
  8008e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008eb:	8b 00                	mov    (%eax),%eax
  8008ed:	83 e8 04             	sub    $0x4,%eax
  8008f0:	8b 00                	mov    (%eax),%eax
  8008f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8008f7:	eb 1c                	jmp    800915 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fc:	8b 00                	mov    (%eax),%eax
  8008fe:	8d 50 04             	lea    0x4(%eax),%edx
  800901:	8b 45 08             	mov    0x8(%ebp),%eax
  800904:	89 10                	mov    %edx,(%eax)
  800906:	8b 45 08             	mov    0x8(%ebp),%eax
  800909:	8b 00                	mov    (%eax),%eax
  80090b:	83 e8 04             	sub    $0x4,%eax
  80090e:	8b 00                	mov    (%eax),%eax
  800910:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800915:	5d                   	pop    %ebp
  800916:	c3                   	ret    

00800917 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800917:	55                   	push   %ebp
  800918:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80091a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80091e:	7e 1c                	jle    80093c <getint+0x25>
		return va_arg(*ap, long long);
  800920:	8b 45 08             	mov    0x8(%ebp),%eax
  800923:	8b 00                	mov    (%eax),%eax
  800925:	8d 50 08             	lea    0x8(%eax),%edx
  800928:	8b 45 08             	mov    0x8(%ebp),%eax
  80092b:	89 10                	mov    %edx,(%eax)
  80092d:	8b 45 08             	mov    0x8(%ebp),%eax
  800930:	8b 00                	mov    (%eax),%eax
  800932:	83 e8 08             	sub    $0x8,%eax
  800935:	8b 50 04             	mov    0x4(%eax),%edx
  800938:	8b 00                	mov    (%eax),%eax
  80093a:	eb 38                	jmp    800974 <getint+0x5d>
	else if (lflag)
  80093c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800940:	74 1a                	je     80095c <getint+0x45>
		return va_arg(*ap, long);
  800942:	8b 45 08             	mov    0x8(%ebp),%eax
  800945:	8b 00                	mov    (%eax),%eax
  800947:	8d 50 04             	lea    0x4(%eax),%edx
  80094a:	8b 45 08             	mov    0x8(%ebp),%eax
  80094d:	89 10                	mov    %edx,(%eax)
  80094f:	8b 45 08             	mov    0x8(%ebp),%eax
  800952:	8b 00                	mov    (%eax),%eax
  800954:	83 e8 04             	sub    $0x4,%eax
  800957:	8b 00                	mov    (%eax),%eax
  800959:	99                   	cltd   
  80095a:	eb 18                	jmp    800974 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80095c:	8b 45 08             	mov    0x8(%ebp),%eax
  80095f:	8b 00                	mov    (%eax),%eax
  800961:	8d 50 04             	lea    0x4(%eax),%edx
  800964:	8b 45 08             	mov    0x8(%ebp),%eax
  800967:	89 10                	mov    %edx,(%eax)
  800969:	8b 45 08             	mov    0x8(%ebp),%eax
  80096c:	8b 00                	mov    (%eax),%eax
  80096e:	83 e8 04             	sub    $0x4,%eax
  800971:	8b 00                	mov    (%eax),%eax
  800973:	99                   	cltd   
}
  800974:	5d                   	pop    %ebp
  800975:	c3                   	ret    

00800976 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800976:	55                   	push   %ebp
  800977:	89 e5                	mov    %esp,%ebp
  800979:	56                   	push   %esi
  80097a:	53                   	push   %ebx
  80097b:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80097e:	eb 17                	jmp    800997 <vprintfmt+0x21>
			if (ch == '\0')
  800980:	85 db                	test   %ebx,%ebx
  800982:	0f 84 c1 03 00 00    	je     800d49 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800988:	83 ec 08             	sub    $0x8,%esp
  80098b:	ff 75 0c             	pushl  0xc(%ebp)
  80098e:	53                   	push   %ebx
  80098f:	8b 45 08             	mov    0x8(%ebp),%eax
  800992:	ff d0                	call   *%eax
  800994:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800997:	8b 45 10             	mov    0x10(%ebp),%eax
  80099a:	8d 50 01             	lea    0x1(%eax),%edx
  80099d:	89 55 10             	mov    %edx,0x10(%ebp)
  8009a0:	8a 00                	mov    (%eax),%al
  8009a2:	0f b6 d8             	movzbl %al,%ebx
  8009a5:	83 fb 25             	cmp    $0x25,%ebx
  8009a8:	75 d6                	jne    800980 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009aa:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8009ae:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009b5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009bc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009c3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8009cd:	8d 50 01             	lea    0x1(%eax),%edx
  8009d0:	89 55 10             	mov    %edx,0x10(%ebp)
  8009d3:	8a 00                	mov    (%eax),%al
  8009d5:	0f b6 d8             	movzbl %al,%ebx
  8009d8:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009db:	83 f8 5b             	cmp    $0x5b,%eax
  8009de:	0f 87 3d 03 00 00    	ja     800d21 <vprintfmt+0x3ab>
  8009e4:	8b 04 85 18 28 80 00 	mov    0x802818(,%eax,4),%eax
  8009eb:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009ed:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009f1:	eb d7                	jmp    8009ca <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009f3:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009f7:	eb d1                	jmp    8009ca <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009f9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a00:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a03:	89 d0                	mov    %edx,%eax
  800a05:	c1 e0 02             	shl    $0x2,%eax
  800a08:	01 d0                	add    %edx,%eax
  800a0a:	01 c0                	add    %eax,%eax
  800a0c:	01 d8                	add    %ebx,%eax
  800a0e:	83 e8 30             	sub    $0x30,%eax
  800a11:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a14:	8b 45 10             	mov    0x10(%ebp),%eax
  800a17:	8a 00                	mov    (%eax),%al
  800a19:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a1c:	83 fb 2f             	cmp    $0x2f,%ebx
  800a1f:	7e 3e                	jle    800a5f <vprintfmt+0xe9>
  800a21:	83 fb 39             	cmp    $0x39,%ebx
  800a24:	7f 39                	jg     800a5f <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a26:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a29:	eb d5                	jmp    800a00 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a2b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a2e:	83 c0 04             	add    $0x4,%eax
  800a31:	89 45 14             	mov    %eax,0x14(%ebp)
  800a34:	8b 45 14             	mov    0x14(%ebp),%eax
  800a37:	83 e8 04             	sub    $0x4,%eax
  800a3a:	8b 00                	mov    (%eax),%eax
  800a3c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a3f:	eb 1f                	jmp    800a60 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a41:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a45:	79 83                	jns    8009ca <vprintfmt+0x54>
				width = 0;
  800a47:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a4e:	e9 77 ff ff ff       	jmp    8009ca <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a53:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a5a:	e9 6b ff ff ff       	jmp    8009ca <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a5f:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a60:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a64:	0f 89 60 ff ff ff    	jns    8009ca <vprintfmt+0x54>
				width = precision, precision = -1;
  800a6a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a6d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a70:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a77:	e9 4e ff ff ff       	jmp    8009ca <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a7c:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a7f:	e9 46 ff ff ff       	jmp    8009ca <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a84:	8b 45 14             	mov    0x14(%ebp),%eax
  800a87:	83 c0 04             	add    $0x4,%eax
  800a8a:	89 45 14             	mov    %eax,0x14(%ebp)
  800a8d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a90:	83 e8 04             	sub    $0x4,%eax
  800a93:	8b 00                	mov    (%eax),%eax
  800a95:	83 ec 08             	sub    $0x8,%esp
  800a98:	ff 75 0c             	pushl  0xc(%ebp)
  800a9b:	50                   	push   %eax
  800a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9f:	ff d0                	call   *%eax
  800aa1:	83 c4 10             	add    $0x10,%esp
			break;
  800aa4:	e9 9b 02 00 00       	jmp    800d44 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800aa9:	8b 45 14             	mov    0x14(%ebp),%eax
  800aac:	83 c0 04             	add    $0x4,%eax
  800aaf:	89 45 14             	mov    %eax,0x14(%ebp)
  800ab2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab5:	83 e8 04             	sub    $0x4,%eax
  800ab8:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800aba:	85 db                	test   %ebx,%ebx
  800abc:	79 02                	jns    800ac0 <vprintfmt+0x14a>
				err = -err;
  800abe:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ac0:	83 fb 64             	cmp    $0x64,%ebx
  800ac3:	7f 0b                	jg     800ad0 <vprintfmt+0x15a>
  800ac5:	8b 34 9d 60 26 80 00 	mov    0x802660(,%ebx,4),%esi
  800acc:	85 f6                	test   %esi,%esi
  800ace:	75 19                	jne    800ae9 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ad0:	53                   	push   %ebx
  800ad1:	68 05 28 80 00       	push   $0x802805
  800ad6:	ff 75 0c             	pushl  0xc(%ebp)
  800ad9:	ff 75 08             	pushl  0x8(%ebp)
  800adc:	e8 70 02 00 00       	call   800d51 <printfmt>
  800ae1:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ae4:	e9 5b 02 00 00       	jmp    800d44 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ae9:	56                   	push   %esi
  800aea:	68 0e 28 80 00       	push   $0x80280e
  800aef:	ff 75 0c             	pushl  0xc(%ebp)
  800af2:	ff 75 08             	pushl  0x8(%ebp)
  800af5:	e8 57 02 00 00       	call   800d51 <printfmt>
  800afa:	83 c4 10             	add    $0x10,%esp
			break;
  800afd:	e9 42 02 00 00       	jmp    800d44 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b02:	8b 45 14             	mov    0x14(%ebp),%eax
  800b05:	83 c0 04             	add    $0x4,%eax
  800b08:	89 45 14             	mov    %eax,0x14(%ebp)
  800b0b:	8b 45 14             	mov    0x14(%ebp),%eax
  800b0e:	83 e8 04             	sub    $0x4,%eax
  800b11:	8b 30                	mov    (%eax),%esi
  800b13:	85 f6                	test   %esi,%esi
  800b15:	75 05                	jne    800b1c <vprintfmt+0x1a6>
				p = "(null)";
  800b17:	be 11 28 80 00       	mov    $0x802811,%esi
			if (width > 0 && padc != '-')
  800b1c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b20:	7e 6d                	jle    800b8f <vprintfmt+0x219>
  800b22:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b26:	74 67                	je     800b8f <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b28:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b2b:	83 ec 08             	sub    $0x8,%esp
  800b2e:	50                   	push   %eax
  800b2f:	56                   	push   %esi
  800b30:	e8 1e 03 00 00       	call   800e53 <strnlen>
  800b35:	83 c4 10             	add    $0x10,%esp
  800b38:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b3b:	eb 16                	jmp    800b53 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b3d:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b41:	83 ec 08             	sub    $0x8,%esp
  800b44:	ff 75 0c             	pushl  0xc(%ebp)
  800b47:	50                   	push   %eax
  800b48:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4b:	ff d0                	call   *%eax
  800b4d:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b50:	ff 4d e4             	decl   -0x1c(%ebp)
  800b53:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b57:	7f e4                	jg     800b3d <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b59:	eb 34                	jmp    800b8f <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b5b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b5f:	74 1c                	je     800b7d <vprintfmt+0x207>
  800b61:	83 fb 1f             	cmp    $0x1f,%ebx
  800b64:	7e 05                	jle    800b6b <vprintfmt+0x1f5>
  800b66:	83 fb 7e             	cmp    $0x7e,%ebx
  800b69:	7e 12                	jle    800b7d <vprintfmt+0x207>
					putch('?', putdat);
  800b6b:	83 ec 08             	sub    $0x8,%esp
  800b6e:	ff 75 0c             	pushl  0xc(%ebp)
  800b71:	6a 3f                	push   $0x3f
  800b73:	8b 45 08             	mov    0x8(%ebp),%eax
  800b76:	ff d0                	call   *%eax
  800b78:	83 c4 10             	add    $0x10,%esp
  800b7b:	eb 0f                	jmp    800b8c <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b7d:	83 ec 08             	sub    $0x8,%esp
  800b80:	ff 75 0c             	pushl  0xc(%ebp)
  800b83:	53                   	push   %ebx
  800b84:	8b 45 08             	mov    0x8(%ebp),%eax
  800b87:	ff d0                	call   *%eax
  800b89:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b8c:	ff 4d e4             	decl   -0x1c(%ebp)
  800b8f:	89 f0                	mov    %esi,%eax
  800b91:	8d 70 01             	lea    0x1(%eax),%esi
  800b94:	8a 00                	mov    (%eax),%al
  800b96:	0f be d8             	movsbl %al,%ebx
  800b99:	85 db                	test   %ebx,%ebx
  800b9b:	74 24                	je     800bc1 <vprintfmt+0x24b>
  800b9d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ba1:	78 b8                	js     800b5b <vprintfmt+0x1e5>
  800ba3:	ff 4d e0             	decl   -0x20(%ebp)
  800ba6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800baa:	79 af                	jns    800b5b <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bac:	eb 13                	jmp    800bc1 <vprintfmt+0x24b>
				putch(' ', putdat);
  800bae:	83 ec 08             	sub    $0x8,%esp
  800bb1:	ff 75 0c             	pushl  0xc(%ebp)
  800bb4:	6a 20                	push   $0x20
  800bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb9:	ff d0                	call   *%eax
  800bbb:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bbe:	ff 4d e4             	decl   -0x1c(%ebp)
  800bc1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bc5:	7f e7                	jg     800bae <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800bc7:	e9 78 01 00 00       	jmp    800d44 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800bcc:	83 ec 08             	sub    $0x8,%esp
  800bcf:	ff 75 e8             	pushl  -0x18(%ebp)
  800bd2:	8d 45 14             	lea    0x14(%ebp),%eax
  800bd5:	50                   	push   %eax
  800bd6:	e8 3c fd ff ff       	call   800917 <getint>
  800bdb:	83 c4 10             	add    $0x10,%esp
  800bde:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800be1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800be4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800be7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bea:	85 d2                	test   %edx,%edx
  800bec:	79 23                	jns    800c11 <vprintfmt+0x29b>
				putch('-', putdat);
  800bee:	83 ec 08             	sub    $0x8,%esp
  800bf1:	ff 75 0c             	pushl  0xc(%ebp)
  800bf4:	6a 2d                	push   $0x2d
  800bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf9:	ff d0                	call   *%eax
  800bfb:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800bfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c01:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c04:	f7 d8                	neg    %eax
  800c06:	83 d2 00             	adc    $0x0,%edx
  800c09:	f7 da                	neg    %edx
  800c0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c0e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c11:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c18:	e9 bc 00 00 00       	jmp    800cd9 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c1d:	83 ec 08             	sub    $0x8,%esp
  800c20:	ff 75 e8             	pushl  -0x18(%ebp)
  800c23:	8d 45 14             	lea    0x14(%ebp),%eax
  800c26:	50                   	push   %eax
  800c27:	e8 84 fc ff ff       	call   8008b0 <getuint>
  800c2c:	83 c4 10             	add    $0x10,%esp
  800c2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c32:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c35:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c3c:	e9 98 00 00 00       	jmp    800cd9 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c41:	83 ec 08             	sub    $0x8,%esp
  800c44:	ff 75 0c             	pushl  0xc(%ebp)
  800c47:	6a 58                	push   $0x58
  800c49:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4c:	ff d0                	call   *%eax
  800c4e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c51:	83 ec 08             	sub    $0x8,%esp
  800c54:	ff 75 0c             	pushl  0xc(%ebp)
  800c57:	6a 58                	push   $0x58
  800c59:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5c:	ff d0                	call   *%eax
  800c5e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c61:	83 ec 08             	sub    $0x8,%esp
  800c64:	ff 75 0c             	pushl  0xc(%ebp)
  800c67:	6a 58                	push   $0x58
  800c69:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6c:	ff d0                	call   *%eax
  800c6e:	83 c4 10             	add    $0x10,%esp
			break;
  800c71:	e9 ce 00 00 00       	jmp    800d44 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800c76:	83 ec 08             	sub    $0x8,%esp
  800c79:	ff 75 0c             	pushl  0xc(%ebp)
  800c7c:	6a 30                	push   $0x30
  800c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c81:	ff d0                	call   *%eax
  800c83:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c86:	83 ec 08             	sub    $0x8,%esp
  800c89:	ff 75 0c             	pushl  0xc(%ebp)
  800c8c:	6a 78                	push   $0x78
  800c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c91:	ff d0                	call   *%eax
  800c93:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c96:	8b 45 14             	mov    0x14(%ebp),%eax
  800c99:	83 c0 04             	add    $0x4,%eax
  800c9c:	89 45 14             	mov    %eax,0x14(%ebp)
  800c9f:	8b 45 14             	mov    0x14(%ebp),%eax
  800ca2:	83 e8 04             	sub    $0x4,%eax
  800ca5:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ca7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800caa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800cb1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800cb8:	eb 1f                	jmp    800cd9 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800cba:	83 ec 08             	sub    $0x8,%esp
  800cbd:	ff 75 e8             	pushl  -0x18(%ebp)
  800cc0:	8d 45 14             	lea    0x14(%ebp),%eax
  800cc3:	50                   	push   %eax
  800cc4:	e8 e7 fb ff ff       	call   8008b0 <getuint>
  800cc9:	83 c4 10             	add    $0x10,%esp
  800ccc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ccf:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800cd2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cd9:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800cdd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ce0:	83 ec 04             	sub    $0x4,%esp
  800ce3:	52                   	push   %edx
  800ce4:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ce7:	50                   	push   %eax
  800ce8:	ff 75 f4             	pushl  -0xc(%ebp)
  800ceb:	ff 75 f0             	pushl  -0x10(%ebp)
  800cee:	ff 75 0c             	pushl  0xc(%ebp)
  800cf1:	ff 75 08             	pushl  0x8(%ebp)
  800cf4:	e8 00 fb ff ff       	call   8007f9 <printnum>
  800cf9:	83 c4 20             	add    $0x20,%esp
			break;
  800cfc:	eb 46                	jmp    800d44 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cfe:	83 ec 08             	sub    $0x8,%esp
  800d01:	ff 75 0c             	pushl  0xc(%ebp)
  800d04:	53                   	push   %ebx
  800d05:	8b 45 08             	mov    0x8(%ebp),%eax
  800d08:	ff d0                	call   *%eax
  800d0a:	83 c4 10             	add    $0x10,%esp
			break;
  800d0d:	eb 35                	jmp    800d44 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800d0f:	c6 05 e0 4a 86 00 00 	movb   $0x0,0x864ae0
			break;
  800d16:	eb 2c                	jmp    800d44 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800d18:	c6 05 e0 4a 86 00 01 	movb   $0x1,0x864ae0
			break;
  800d1f:	eb 23                	jmp    800d44 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d21:	83 ec 08             	sub    $0x8,%esp
  800d24:	ff 75 0c             	pushl  0xc(%ebp)
  800d27:	6a 25                	push   $0x25
  800d29:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2c:	ff d0                	call   *%eax
  800d2e:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d31:	ff 4d 10             	decl   0x10(%ebp)
  800d34:	eb 03                	jmp    800d39 <vprintfmt+0x3c3>
  800d36:	ff 4d 10             	decl   0x10(%ebp)
  800d39:	8b 45 10             	mov    0x10(%ebp),%eax
  800d3c:	48                   	dec    %eax
  800d3d:	8a 00                	mov    (%eax),%al
  800d3f:	3c 25                	cmp    $0x25,%al
  800d41:	75 f3                	jne    800d36 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800d43:	90                   	nop
		}
	}
  800d44:	e9 35 fc ff ff       	jmp    80097e <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d49:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d4a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d4d:	5b                   	pop    %ebx
  800d4e:	5e                   	pop    %esi
  800d4f:	5d                   	pop    %ebp
  800d50:	c3                   	ret    

00800d51 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d51:	55                   	push   %ebp
  800d52:	89 e5                	mov    %esp,%ebp
  800d54:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d57:	8d 45 10             	lea    0x10(%ebp),%eax
  800d5a:	83 c0 04             	add    $0x4,%eax
  800d5d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d60:	8b 45 10             	mov    0x10(%ebp),%eax
  800d63:	ff 75 f4             	pushl  -0xc(%ebp)
  800d66:	50                   	push   %eax
  800d67:	ff 75 0c             	pushl  0xc(%ebp)
  800d6a:	ff 75 08             	pushl  0x8(%ebp)
  800d6d:	e8 04 fc ff ff       	call   800976 <vprintfmt>
  800d72:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d75:	90                   	nop
  800d76:	c9                   	leave  
  800d77:	c3                   	ret    

00800d78 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d78:	55                   	push   %ebp
  800d79:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7e:	8b 40 08             	mov    0x8(%eax),%eax
  800d81:	8d 50 01             	lea    0x1(%eax),%edx
  800d84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d87:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8d:	8b 10                	mov    (%eax),%edx
  800d8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d92:	8b 40 04             	mov    0x4(%eax),%eax
  800d95:	39 c2                	cmp    %eax,%edx
  800d97:	73 12                	jae    800dab <sprintputch+0x33>
		*b->buf++ = ch;
  800d99:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9c:	8b 00                	mov    (%eax),%eax
  800d9e:	8d 48 01             	lea    0x1(%eax),%ecx
  800da1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800da4:	89 0a                	mov    %ecx,(%edx)
  800da6:	8b 55 08             	mov    0x8(%ebp),%edx
  800da9:	88 10                	mov    %dl,(%eax)
}
  800dab:	90                   	nop
  800dac:	5d                   	pop    %ebp
  800dad:	c3                   	ret    

00800dae <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800dae:	55                   	push   %ebp
  800daf:	89 e5                	mov    %esp,%ebp
  800db1:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800db4:	8b 45 08             	mov    0x8(%ebp),%eax
  800db7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800dba:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dbd:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc3:	01 d0                	add    %edx,%eax
  800dc5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dc8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800dcf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800dd3:	74 06                	je     800ddb <vsnprintf+0x2d>
  800dd5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dd9:	7f 07                	jg     800de2 <vsnprintf+0x34>
		return -E_INVAL;
  800ddb:	b8 03 00 00 00       	mov    $0x3,%eax
  800de0:	eb 20                	jmp    800e02 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800de2:	ff 75 14             	pushl  0x14(%ebp)
  800de5:	ff 75 10             	pushl  0x10(%ebp)
  800de8:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800deb:	50                   	push   %eax
  800dec:	68 78 0d 80 00       	push   $0x800d78
  800df1:	e8 80 fb ff ff       	call   800976 <vprintfmt>
  800df6:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800df9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800dfc:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800dff:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e02:	c9                   	leave  
  800e03:	c3                   	ret    

00800e04 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e04:	55                   	push   %ebp
  800e05:	89 e5                	mov    %esp,%ebp
  800e07:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e0a:	8d 45 10             	lea    0x10(%ebp),%eax
  800e0d:	83 c0 04             	add    $0x4,%eax
  800e10:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e13:	8b 45 10             	mov    0x10(%ebp),%eax
  800e16:	ff 75 f4             	pushl  -0xc(%ebp)
  800e19:	50                   	push   %eax
  800e1a:	ff 75 0c             	pushl  0xc(%ebp)
  800e1d:	ff 75 08             	pushl  0x8(%ebp)
  800e20:	e8 89 ff ff ff       	call   800dae <vsnprintf>
  800e25:	83 c4 10             	add    $0x10,%esp
  800e28:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e2e:	c9                   	leave  
  800e2f:	c3                   	ret    

00800e30 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e30:	55                   	push   %ebp
  800e31:	89 e5                	mov    %esp,%ebp
  800e33:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e36:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e3d:	eb 06                	jmp    800e45 <strlen+0x15>
		n++;
  800e3f:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e42:	ff 45 08             	incl   0x8(%ebp)
  800e45:	8b 45 08             	mov    0x8(%ebp),%eax
  800e48:	8a 00                	mov    (%eax),%al
  800e4a:	84 c0                	test   %al,%al
  800e4c:	75 f1                	jne    800e3f <strlen+0xf>
		n++;
	return n;
  800e4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e51:	c9                   	leave  
  800e52:	c3                   	ret    

00800e53 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e53:	55                   	push   %ebp
  800e54:	89 e5                	mov    %esp,%ebp
  800e56:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e59:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e60:	eb 09                	jmp    800e6b <strnlen+0x18>
		n++;
  800e62:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e65:	ff 45 08             	incl   0x8(%ebp)
  800e68:	ff 4d 0c             	decl   0xc(%ebp)
  800e6b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e6f:	74 09                	je     800e7a <strnlen+0x27>
  800e71:	8b 45 08             	mov    0x8(%ebp),%eax
  800e74:	8a 00                	mov    (%eax),%al
  800e76:	84 c0                	test   %al,%al
  800e78:	75 e8                	jne    800e62 <strnlen+0xf>
		n++;
	return n;
  800e7a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e7d:	c9                   	leave  
  800e7e:	c3                   	ret    

00800e7f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e7f:	55                   	push   %ebp
  800e80:	89 e5                	mov    %esp,%ebp
  800e82:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e85:	8b 45 08             	mov    0x8(%ebp),%eax
  800e88:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e8b:	90                   	nop
  800e8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8f:	8d 50 01             	lea    0x1(%eax),%edx
  800e92:	89 55 08             	mov    %edx,0x8(%ebp)
  800e95:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e98:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e9b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e9e:	8a 12                	mov    (%edx),%dl
  800ea0:	88 10                	mov    %dl,(%eax)
  800ea2:	8a 00                	mov    (%eax),%al
  800ea4:	84 c0                	test   %al,%al
  800ea6:	75 e4                	jne    800e8c <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ea8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800eab:	c9                   	leave  
  800eac:	c3                   	ret    

00800ead <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800ead:	55                   	push   %ebp
  800eae:	89 e5                	mov    %esp,%ebp
  800eb0:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800eb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800eb9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ec0:	eb 1f                	jmp    800ee1 <strncpy+0x34>
		*dst++ = *src;
  800ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec5:	8d 50 01             	lea    0x1(%eax),%edx
  800ec8:	89 55 08             	mov    %edx,0x8(%ebp)
  800ecb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ece:	8a 12                	mov    (%edx),%dl
  800ed0:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ed2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed5:	8a 00                	mov    (%eax),%al
  800ed7:	84 c0                	test   %al,%al
  800ed9:	74 03                	je     800ede <strncpy+0x31>
			src++;
  800edb:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ede:	ff 45 fc             	incl   -0x4(%ebp)
  800ee1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee4:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ee7:	72 d9                	jb     800ec2 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ee9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800eec:	c9                   	leave  
  800eed:	c3                   	ret    

00800eee <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800eee:	55                   	push   %ebp
  800eef:	89 e5                	mov    %esp,%ebp
  800ef1:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ef4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800efa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800efe:	74 30                	je     800f30 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800f00:	eb 16                	jmp    800f18 <strlcpy+0x2a>
			*dst++ = *src++;
  800f02:	8b 45 08             	mov    0x8(%ebp),%eax
  800f05:	8d 50 01             	lea    0x1(%eax),%edx
  800f08:	89 55 08             	mov    %edx,0x8(%ebp)
  800f0b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f0e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f11:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f14:	8a 12                	mov    (%edx),%dl
  800f16:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f18:	ff 4d 10             	decl   0x10(%ebp)
  800f1b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f1f:	74 09                	je     800f2a <strlcpy+0x3c>
  800f21:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f24:	8a 00                	mov    (%eax),%al
  800f26:	84 c0                	test   %al,%al
  800f28:	75 d8                	jne    800f02 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f30:	8b 55 08             	mov    0x8(%ebp),%edx
  800f33:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f36:	29 c2                	sub    %eax,%edx
  800f38:	89 d0                	mov    %edx,%eax
}
  800f3a:	c9                   	leave  
  800f3b:	c3                   	ret    

00800f3c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f3c:	55                   	push   %ebp
  800f3d:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f3f:	eb 06                	jmp    800f47 <strcmp+0xb>
		p++, q++;
  800f41:	ff 45 08             	incl   0x8(%ebp)
  800f44:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f47:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4a:	8a 00                	mov    (%eax),%al
  800f4c:	84 c0                	test   %al,%al
  800f4e:	74 0e                	je     800f5e <strcmp+0x22>
  800f50:	8b 45 08             	mov    0x8(%ebp),%eax
  800f53:	8a 10                	mov    (%eax),%dl
  800f55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f58:	8a 00                	mov    (%eax),%al
  800f5a:	38 c2                	cmp    %al,%dl
  800f5c:	74 e3                	je     800f41 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f61:	8a 00                	mov    (%eax),%al
  800f63:	0f b6 d0             	movzbl %al,%edx
  800f66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f69:	8a 00                	mov    (%eax),%al
  800f6b:	0f b6 c0             	movzbl %al,%eax
  800f6e:	29 c2                	sub    %eax,%edx
  800f70:	89 d0                	mov    %edx,%eax
}
  800f72:	5d                   	pop    %ebp
  800f73:	c3                   	ret    

00800f74 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f74:	55                   	push   %ebp
  800f75:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f77:	eb 09                	jmp    800f82 <strncmp+0xe>
		n--, p++, q++;
  800f79:	ff 4d 10             	decl   0x10(%ebp)
  800f7c:	ff 45 08             	incl   0x8(%ebp)
  800f7f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f82:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f86:	74 17                	je     800f9f <strncmp+0x2b>
  800f88:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8b:	8a 00                	mov    (%eax),%al
  800f8d:	84 c0                	test   %al,%al
  800f8f:	74 0e                	je     800f9f <strncmp+0x2b>
  800f91:	8b 45 08             	mov    0x8(%ebp),%eax
  800f94:	8a 10                	mov    (%eax),%dl
  800f96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f99:	8a 00                	mov    (%eax),%al
  800f9b:	38 c2                	cmp    %al,%dl
  800f9d:	74 da                	je     800f79 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f9f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fa3:	75 07                	jne    800fac <strncmp+0x38>
		return 0;
  800fa5:	b8 00 00 00 00       	mov    $0x0,%eax
  800faa:	eb 14                	jmp    800fc0 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800fac:	8b 45 08             	mov    0x8(%ebp),%eax
  800faf:	8a 00                	mov    (%eax),%al
  800fb1:	0f b6 d0             	movzbl %al,%edx
  800fb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb7:	8a 00                	mov    (%eax),%al
  800fb9:	0f b6 c0             	movzbl %al,%eax
  800fbc:	29 c2                	sub    %eax,%edx
  800fbe:	89 d0                	mov    %edx,%eax
}
  800fc0:	5d                   	pop    %ebp
  800fc1:	c3                   	ret    

00800fc2 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800fc2:	55                   	push   %ebp
  800fc3:	89 e5                	mov    %esp,%ebp
  800fc5:	83 ec 04             	sub    $0x4,%esp
  800fc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fcb:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fce:	eb 12                	jmp    800fe2 <strchr+0x20>
		if (*s == c)
  800fd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd3:	8a 00                	mov    (%eax),%al
  800fd5:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fd8:	75 05                	jne    800fdf <strchr+0x1d>
			return (char *) s;
  800fda:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdd:	eb 11                	jmp    800ff0 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800fdf:	ff 45 08             	incl   0x8(%ebp)
  800fe2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe5:	8a 00                	mov    (%eax),%al
  800fe7:	84 c0                	test   %al,%al
  800fe9:	75 e5                	jne    800fd0 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800feb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ff0:	c9                   	leave  
  800ff1:	c3                   	ret    

00800ff2 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ff2:	55                   	push   %ebp
  800ff3:	89 e5                	mov    %esp,%ebp
  800ff5:	83 ec 04             	sub    $0x4,%esp
  800ff8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ffb:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ffe:	eb 0d                	jmp    80100d <strfind+0x1b>
		if (*s == c)
  801000:	8b 45 08             	mov    0x8(%ebp),%eax
  801003:	8a 00                	mov    (%eax),%al
  801005:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801008:	74 0e                	je     801018 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80100a:	ff 45 08             	incl   0x8(%ebp)
  80100d:	8b 45 08             	mov    0x8(%ebp),%eax
  801010:	8a 00                	mov    (%eax),%al
  801012:	84 c0                	test   %al,%al
  801014:	75 ea                	jne    801000 <strfind+0xe>
  801016:	eb 01                	jmp    801019 <strfind+0x27>
		if (*s == c)
			break;
  801018:	90                   	nop
	return (char *) s;
  801019:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80101c:	c9                   	leave  
  80101d:	c3                   	ret    

0080101e <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  80101e:	55                   	push   %ebp
  80101f:	89 e5                	mov    %esp,%ebp
  801021:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801024:	8b 45 08             	mov    0x8(%ebp),%eax
  801027:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  80102a:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80102e:	76 63                	jbe    801093 <memset+0x75>
		uint64 data_block = c;
  801030:	8b 45 0c             	mov    0xc(%ebp),%eax
  801033:	99                   	cltd   
  801034:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801037:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  80103a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80103d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801040:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801044:	c1 e0 08             	shl    $0x8,%eax
  801047:	09 45 f0             	or     %eax,-0x10(%ebp)
  80104a:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  80104d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801050:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801053:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801057:	c1 e0 10             	shl    $0x10,%eax
  80105a:	09 45 f0             	or     %eax,-0x10(%ebp)
  80105d:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801060:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801063:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801066:	89 c2                	mov    %eax,%edx
  801068:	b8 00 00 00 00       	mov    $0x0,%eax
  80106d:	09 45 f0             	or     %eax,-0x10(%ebp)
  801070:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801073:	eb 18                	jmp    80108d <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801075:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801078:	8d 41 08             	lea    0x8(%ecx),%eax
  80107b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80107e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801081:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801084:	89 01                	mov    %eax,(%ecx)
  801086:	89 51 04             	mov    %edx,0x4(%ecx)
  801089:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  80108d:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801091:	77 e2                	ja     801075 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801093:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801097:	74 23                	je     8010bc <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801099:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80109c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  80109f:	eb 0e                	jmp    8010af <memset+0x91>
			*p8++ = (uint8)c;
  8010a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010a4:	8d 50 01             	lea    0x1(%eax),%edx
  8010a7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010ad:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8010af:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010b5:	89 55 10             	mov    %edx,0x10(%ebp)
  8010b8:	85 c0                	test   %eax,%eax
  8010ba:	75 e5                	jne    8010a1 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8010bc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010bf:	c9                   	leave  
  8010c0:	c3                   	ret    

008010c1 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8010c1:	55                   	push   %ebp
  8010c2:	89 e5                	mov    %esp,%ebp
  8010c4:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8010c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8010cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8010d3:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010d7:	76 24                	jbe    8010fd <memcpy+0x3c>
		while(n >= 8){
  8010d9:	eb 1c                	jmp    8010f7 <memcpy+0x36>
			*d64 = *s64;
  8010db:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010de:	8b 50 04             	mov    0x4(%eax),%edx
  8010e1:	8b 00                	mov    (%eax),%eax
  8010e3:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010e6:	89 01                	mov    %eax,(%ecx)
  8010e8:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8010eb:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8010ef:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8010f3:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8010f7:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010fb:	77 de                	ja     8010db <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8010fd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801101:	74 31                	je     801134 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801103:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801106:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801109:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80110c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  80110f:	eb 16                	jmp    801127 <memcpy+0x66>
			*d8++ = *s8++;
  801111:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801114:	8d 50 01             	lea    0x1(%eax),%edx
  801117:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80111a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80111d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801120:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801123:	8a 12                	mov    (%edx),%dl
  801125:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801127:	8b 45 10             	mov    0x10(%ebp),%eax
  80112a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80112d:	89 55 10             	mov    %edx,0x10(%ebp)
  801130:	85 c0                	test   %eax,%eax
  801132:	75 dd                	jne    801111 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801134:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801137:	c9                   	leave  
  801138:	c3                   	ret    

00801139 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801139:	55                   	push   %ebp
  80113a:	89 e5                	mov    %esp,%ebp
  80113c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80113f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801142:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801145:	8b 45 08             	mov    0x8(%ebp),%eax
  801148:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80114b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80114e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801151:	73 50                	jae    8011a3 <memmove+0x6a>
  801153:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801156:	8b 45 10             	mov    0x10(%ebp),%eax
  801159:	01 d0                	add    %edx,%eax
  80115b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80115e:	76 43                	jbe    8011a3 <memmove+0x6a>
		s += n;
  801160:	8b 45 10             	mov    0x10(%ebp),%eax
  801163:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801166:	8b 45 10             	mov    0x10(%ebp),%eax
  801169:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80116c:	eb 10                	jmp    80117e <memmove+0x45>
			*--d = *--s;
  80116e:	ff 4d f8             	decl   -0x8(%ebp)
  801171:	ff 4d fc             	decl   -0x4(%ebp)
  801174:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801177:	8a 10                	mov    (%eax),%dl
  801179:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80117c:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80117e:	8b 45 10             	mov    0x10(%ebp),%eax
  801181:	8d 50 ff             	lea    -0x1(%eax),%edx
  801184:	89 55 10             	mov    %edx,0x10(%ebp)
  801187:	85 c0                	test   %eax,%eax
  801189:	75 e3                	jne    80116e <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80118b:	eb 23                	jmp    8011b0 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80118d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801190:	8d 50 01             	lea    0x1(%eax),%edx
  801193:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801196:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801199:	8d 4a 01             	lea    0x1(%edx),%ecx
  80119c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80119f:	8a 12                	mov    (%edx),%dl
  8011a1:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8011a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8011a6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011a9:	89 55 10             	mov    %edx,0x10(%ebp)
  8011ac:	85 c0                	test   %eax,%eax
  8011ae:	75 dd                	jne    80118d <memmove+0x54>
			*d++ = *s++;

	return dst;
  8011b0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011b3:	c9                   	leave  
  8011b4:	c3                   	ret    

008011b5 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8011b5:	55                   	push   %ebp
  8011b6:	89 e5                	mov    %esp,%ebp
  8011b8:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8011bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011be:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8011c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c4:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8011c7:	eb 2a                	jmp    8011f3 <memcmp+0x3e>
		if (*s1 != *s2)
  8011c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011cc:	8a 10                	mov    (%eax),%dl
  8011ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011d1:	8a 00                	mov    (%eax),%al
  8011d3:	38 c2                	cmp    %al,%dl
  8011d5:	74 16                	je     8011ed <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8011d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011da:	8a 00                	mov    (%eax),%al
  8011dc:	0f b6 d0             	movzbl %al,%edx
  8011df:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011e2:	8a 00                	mov    (%eax),%al
  8011e4:	0f b6 c0             	movzbl %al,%eax
  8011e7:	29 c2                	sub    %eax,%edx
  8011e9:	89 d0                	mov    %edx,%eax
  8011eb:	eb 18                	jmp    801205 <memcmp+0x50>
		s1++, s2++;
  8011ed:	ff 45 fc             	incl   -0x4(%ebp)
  8011f0:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8011f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011f9:	89 55 10             	mov    %edx,0x10(%ebp)
  8011fc:	85 c0                	test   %eax,%eax
  8011fe:	75 c9                	jne    8011c9 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801200:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801205:	c9                   	leave  
  801206:	c3                   	ret    

00801207 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801207:	55                   	push   %ebp
  801208:	89 e5                	mov    %esp,%ebp
  80120a:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80120d:	8b 55 08             	mov    0x8(%ebp),%edx
  801210:	8b 45 10             	mov    0x10(%ebp),%eax
  801213:	01 d0                	add    %edx,%eax
  801215:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801218:	eb 15                	jmp    80122f <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80121a:	8b 45 08             	mov    0x8(%ebp),%eax
  80121d:	8a 00                	mov    (%eax),%al
  80121f:	0f b6 d0             	movzbl %al,%edx
  801222:	8b 45 0c             	mov    0xc(%ebp),%eax
  801225:	0f b6 c0             	movzbl %al,%eax
  801228:	39 c2                	cmp    %eax,%edx
  80122a:	74 0d                	je     801239 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80122c:	ff 45 08             	incl   0x8(%ebp)
  80122f:	8b 45 08             	mov    0x8(%ebp),%eax
  801232:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801235:	72 e3                	jb     80121a <memfind+0x13>
  801237:	eb 01                	jmp    80123a <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801239:	90                   	nop
	return (void *) s;
  80123a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80123d:	c9                   	leave  
  80123e:	c3                   	ret    

0080123f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80123f:	55                   	push   %ebp
  801240:	89 e5                	mov    %esp,%ebp
  801242:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801245:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80124c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801253:	eb 03                	jmp    801258 <strtol+0x19>
		s++;
  801255:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801258:	8b 45 08             	mov    0x8(%ebp),%eax
  80125b:	8a 00                	mov    (%eax),%al
  80125d:	3c 20                	cmp    $0x20,%al
  80125f:	74 f4                	je     801255 <strtol+0x16>
  801261:	8b 45 08             	mov    0x8(%ebp),%eax
  801264:	8a 00                	mov    (%eax),%al
  801266:	3c 09                	cmp    $0x9,%al
  801268:	74 eb                	je     801255 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80126a:	8b 45 08             	mov    0x8(%ebp),%eax
  80126d:	8a 00                	mov    (%eax),%al
  80126f:	3c 2b                	cmp    $0x2b,%al
  801271:	75 05                	jne    801278 <strtol+0x39>
		s++;
  801273:	ff 45 08             	incl   0x8(%ebp)
  801276:	eb 13                	jmp    80128b <strtol+0x4c>
	else if (*s == '-')
  801278:	8b 45 08             	mov    0x8(%ebp),%eax
  80127b:	8a 00                	mov    (%eax),%al
  80127d:	3c 2d                	cmp    $0x2d,%al
  80127f:	75 0a                	jne    80128b <strtol+0x4c>
		s++, neg = 1;
  801281:	ff 45 08             	incl   0x8(%ebp)
  801284:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80128b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80128f:	74 06                	je     801297 <strtol+0x58>
  801291:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801295:	75 20                	jne    8012b7 <strtol+0x78>
  801297:	8b 45 08             	mov    0x8(%ebp),%eax
  80129a:	8a 00                	mov    (%eax),%al
  80129c:	3c 30                	cmp    $0x30,%al
  80129e:	75 17                	jne    8012b7 <strtol+0x78>
  8012a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a3:	40                   	inc    %eax
  8012a4:	8a 00                	mov    (%eax),%al
  8012a6:	3c 78                	cmp    $0x78,%al
  8012a8:	75 0d                	jne    8012b7 <strtol+0x78>
		s += 2, base = 16;
  8012aa:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8012ae:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8012b5:	eb 28                	jmp    8012df <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8012b7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012bb:	75 15                	jne    8012d2 <strtol+0x93>
  8012bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c0:	8a 00                	mov    (%eax),%al
  8012c2:	3c 30                	cmp    $0x30,%al
  8012c4:	75 0c                	jne    8012d2 <strtol+0x93>
		s++, base = 8;
  8012c6:	ff 45 08             	incl   0x8(%ebp)
  8012c9:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8012d0:	eb 0d                	jmp    8012df <strtol+0xa0>
	else if (base == 0)
  8012d2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012d6:	75 07                	jne    8012df <strtol+0xa0>
		base = 10;
  8012d8:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8012df:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e2:	8a 00                	mov    (%eax),%al
  8012e4:	3c 2f                	cmp    $0x2f,%al
  8012e6:	7e 19                	jle    801301 <strtol+0xc2>
  8012e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012eb:	8a 00                	mov    (%eax),%al
  8012ed:	3c 39                	cmp    $0x39,%al
  8012ef:	7f 10                	jg     801301 <strtol+0xc2>
			dig = *s - '0';
  8012f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f4:	8a 00                	mov    (%eax),%al
  8012f6:	0f be c0             	movsbl %al,%eax
  8012f9:	83 e8 30             	sub    $0x30,%eax
  8012fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012ff:	eb 42                	jmp    801343 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801301:	8b 45 08             	mov    0x8(%ebp),%eax
  801304:	8a 00                	mov    (%eax),%al
  801306:	3c 60                	cmp    $0x60,%al
  801308:	7e 19                	jle    801323 <strtol+0xe4>
  80130a:	8b 45 08             	mov    0x8(%ebp),%eax
  80130d:	8a 00                	mov    (%eax),%al
  80130f:	3c 7a                	cmp    $0x7a,%al
  801311:	7f 10                	jg     801323 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801313:	8b 45 08             	mov    0x8(%ebp),%eax
  801316:	8a 00                	mov    (%eax),%al
  801318:	0f be c0             	movsbl %al,%eax
  80131b:	83 e8 57             	sub    $0x57,%eax
  80131e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801321:	eb 20                	jmp    801343 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801323:	8b 45 08             	mov    0x8(%ebp),%eax
  801326:	8a 00                	mov    (%eax),%al
  801328:	3c 40                	cmp    $0x40,%al
  80132a:	7e 39                	jle    801365 <strtol+0x126>
  80132c:	8b 45 08             	mov    0x8(%ebp),%eax
  80132f:	8a 00                	mov    (%eax),%al
  801331:	3c 5a                	cmp    $0x5a,%al
  801333:	7f 30                	jg     801365 <strtol+0x126>
			dig = *s - 'A' + 10;
  801335:	8b 45 08             	mov    0x8(%ebp),%eax
  801338:	8a 00                	mov    (%eax),%al
  80133a:	0f be c0             	movsbl %al,%eax
  80133d:	83 e8 37             	sub    $0x37,%eax
  801340:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801343:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801346:	3b 45 10             	cmp    0x10(%ebp),%eax
  801349:	7d 19                	jge    801364 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80134b:	ff 45 08             	incl   0x8(%ebp)
  80134e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801351:	0f af 45 10          	imul   0x10(%ebp),%eax
  801355:	89 c2                	mov    %eax,%edx
  801357:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80135a:	01 d0                	add    %edx,%eax
  80135c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80135f:	e9 7b ff ff ff       	jmp    8012df <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801364:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801365:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801369:	74 08                	je     801373 <strtol+0x134>
		*endptr = (char *) s;
  80136b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136e:	8b 55 08             	mov    0x8(%ebp),%edx
  801371:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801373:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801377:	74 07                	je     801380 <strtol+0x141>
  801379:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80137c:	f7 d8                	neg    %eax
  80137e:	eb 03                	jmp    801383 <strtol+0x144>
  801380:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801383:	c9                   	leave  
  801384:	c3                   	ret    

00801385 <ltostr>:

void
ltostr(long value, char *str)
{
  801385:	55                   	push   %ebp
  801386:	89 e5                	mov    %esp,%ebp
  801388:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80138b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801392:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801399:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80139d:	79 13                	jns    8013b2 <ltostr+0x2d>
	{
		neg = 1;
  80139f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8013a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a9:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8013ac:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8013af:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8013b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b5:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8013ba:	99                   	cltd   
  8013bb:	f7 f9                	idiv   %ecx
  8013bd:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8013c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013c3:	8d 50 01             	lea    0x1(%eax),%edx
  8013c6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013c9:	89 c2                	mov    %eax,%edx
  8013cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ce:	01 d0                	add    %edx,%eax
  8013d0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013d3:	83 c2 30             	add    $0x30,%edx
  8013d6:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8013d8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013db:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8013e0:	f7 e9                	imul   %ecx
  8013e2:	c1 fa 02             	sar    $0x2,%edx
  8013e5:	89 c8                	mov    %ecx,%eax
  8013e7:	c1 f8 1f             	sar    $0x1f,%eax
  8013ea:	29 c2                	sub    %eax,%edx
  8013ec:	89 d0                	mov    %edx,%eax
  8013ee:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8013f1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013f5:	75 bb                	jne    8013b2 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8013f7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8013fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801401:	48                   	dec    %eax
  801402:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801405:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801409:	74 3d                	je     801448 <ltostr+0xc3>
		start = 1 ;
  80140b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801412:	eb 34                	jmp    801448 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801414:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801417:	8b 45 0c             	mov    0xc(%ebp),%eax
  80141a:	01 d0                	add    %edx,%eax
  80141c:	8a 00                	mov    (%eax),%al
  80141e:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801421:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801424:	8b 45 0c             	mov    0xc(%ebp),%eax
  801427:	01 c2                	add    %eax,%edx
  801429:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80142c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80142f:	01 c8                	add    %ecx,%eax
  801431:	8a 00                	mov    (%eax),%al
  801433:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801435:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801438:	8b 45 0c             	mov    0xc(%ebp),%eax
  80143b:	01 c2                	add    %eax,%edx
  80143d:	8a 45 eb             	mov    -0x15(%ebp),%al
  801440:	88 02                	mov    %al,(%edx)
		start++ ;
  801442:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801445:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801448:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80144b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80144e:	7c c4                	jl     801414 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801450:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801453:	8b 45 0c             	mov    0xc(%ebp),%eax
  801456:	01 d0                	add    %edx,%eax
  801458:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80145b:	90                   	nop
  80145c:	c9                   	leave  
  80145d:	c3                   	ret    

0080145e <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80145e:	55                   	push   %ebp
  80145f:	89 e5                	mov    %esp,%ebp
  801461:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801464:	ff 75 08             	pushl  0x8(%ebp)
  801467:	e8 c4 f9 ff ff       	call   800e30 <strlen>
  80146c:	83 c4 04             	add    $0x4,%esp
  80146f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801472:	ff 75 0c             	pushl  0xc(%ebp)
  801475:	e8 b6 f9 ff ff       	call   800e30 <strlen>
  80147a:	83 c4 04             	add    $0x4,%esp
  80147d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801480:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801487:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80148e:	eb 17                	jmp    8014a7 <strcconcat+0x49>
		final[s] = str1[s] ;
  801490:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801493:	8b 45 10             	mov    0x10(%ebp),%eax
  801496:	01 c2                	add    %eax,%edx
  801498:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80149b:	8b 45 08             	mov    0x8(%ebp),%eax
  80149e:	01 c8                	add    %ecx,%eax
  8014a0:	8a 00                	mov    (%eax),%al
  8014a2:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8014a4:	ff 45 fc             	incl   -0x4(%ebp)
  8014a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014aa:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8014ad:	7c e1                	jl     801490 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8014af:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8014b6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8014bd:	eb 1f                	jmp    8014de <strcconcat+0x80>
		final[s++] = str2[i] ;
  8014bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014c2:	8d 50 01             	lea    0x1(%eax),%edx
  8014c5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014c8:	89 c2                	mov    %eax,%edx
  8014ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8014cd:	01 c2                	add    %eax,%edx
  8014cf:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8014d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d5:	01 c8                	add    %ecx,%eax
  8014d7:	8a 00                	mov    (%eax),%al
  8014d9:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8014db:	ff 45 f8             	incl   -0x8(%ebp)
  8014de:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014e1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8014e4:	7c d9                	jl     8014bf <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8014e6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ec:	01 d0                	add    %edx,%eax
  8014ee:	c6 00 00             	movb   $0x0,(%eax)
}
  8014f1:	90                   	nop
  8014f2:	c9                   	leave  
  8014f3:	c3                   	ret    

008014f4 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8014f4:	55                   	push   %ebp
  8014f5:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8014f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8014fa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801500:	8b 45 14             	mov    0x14(%ebp),%eax
  801503:	8b 00                	mov    (%eax),%eax
  801505:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80150c:	8b 45 10             	mov    0x10(%ebp),%eax
  80150f:	01 d0                	add    %edx,%eax
  801511:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801517:	eb 0c                	jmp    801525 <strsplit+0x31>
			*string++ = 0;
  801519:	8b 45 08             	mov    0x8(%ebp),%eax
  80151c:	8d 50 01             	lea    0x1(%eax),%edx
  80151f:	89 55 08             	mov    %edx,0x8(%ebp)
  801522:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801525:	8b 45 08             	mov    0x8(%ebp),%eax
  801528:	8a 00                	mov    (%eax),%al
  80152a:	84 c0                	test   %al,%al
  80152c:	74 18                	je     801546 <strsplit+0x52>
  80152e:	8b 45 08             	mov    0x8(%ebp),%eax
  801531:	8a 00                	mov    (%eax),%al
  801533:	0f be c0             	movsbl %al,%eax
  801536:	50                   	push   %eax
  801537:	ff 75 0c             	pushl  0xc(%ebp)
  80153a:	e8 83 fa ff ff       	call   800fc2 <strchr>
  80153f:	83 c4 08             	add    $0x8,%esp
  801542:	85 c0                	test   %eax,%eax
  801544:	75 d3                	jne    801519 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801546:	8b 45 08             	mov    0x8(%ebp),%eax
  801549:	8a 00                	mov    (%eax),%al
  80154b:	84 c0                	test   %al,%al
  80154d:	74 5a                	je     8015a9 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80154f:	8b 45 14             	mov    0x14(%ebp),%eax
  801552:	8b 00                	mov    (%eax),%eax
  801554:	83 f8 0f             	cmp    $0xf,%eax
  801557:	75 07                	jne    801560 <strsplit+0x6c>
		{
			return 0;
  801559:	b8 00 00 00 00       	mov    $0x0,%eax
  80155e:	eb 66                	jmp    8015c6 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801560:	8b 45 14             	mov    0x14(%ebp),%eax
  801563:	8b 00                	mov    (%eax),%eax
  801565:	8d 48 01             	lea    0x1(%eax),%ecx
  801568:	8b 55 14             	mov    0x14(%ebp),%edx
  80156b:	89 0a                	mov    %ecx,(%edx)
  80156d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801574:	8b 45 10             	mov    0x10(%ebp),%eax
  801577:	01 c2                	add    %eax,%edx
  801579:	8b 45 08             	mov    0x8(%ebp),%eax
  80157c:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80157e:	eb 03                	jmp    801583 <strsplit+0x8f>
			string++;
  801580:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801583:	8b 45 08             	mov    0x8(%ebp),%eax
  801586:	8a 00                	mov    (%eax),%al
  801588:	84 c0                	test   %al,%al
  80158a:	74 8b                	je     801517 <strsplit+0x23>
  80158c:	8b 45 08             	mov    0x8(%ebp),%eax
  80158f:	8a 00                	mov    (%eax),%al
  801591:	0f be c0             	movsbl %al,%eax
  801594:	50                   	push   %eax
  801595:	ff 75 0c             	pushl  0xc(%ebp)
  801598:	e8 25 fa ff ff       	call   800fc2 <strchr>
  80159d:	83 c4 08             	add    $0x8,%esp
  8015a0:	85 c0                	test   %eax,%eax
  8015a2:	74 dc                	je     801580 <strsplit+0x8c>
			string++;
	}
  8015a4:	e9 6e ff ff ff       	jmp    801517 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8015a9:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8015aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8015ad:	8b 00                	mov    (%eax),%eax
  8015af:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8015b9:	01 d0                	add    %edx,%eax
  8015bb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8015c1:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8015c6:	c9                   	leave  
  8015c7:	c3                   	ret    

008015c8 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8015c8:	55                   	push   %ebp
  8015c9:	89 e5                	mov    %esp,%ebp
  8015cb:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8015ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8015d4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015db:	eb 4a                	jmp    801627 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8015dd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e3:	01 c2                	add    %eax,%edx
  8015e5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015eb:	01 c8                	add    %ecx,%eax
  8015ed:	8a 00                	mov    (%eax),%al
  8015ef:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8015f1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f7:	01 d0                	add    %edx,%eax
  8015f9:	8a 00                	mov    (%eax),%al
  8015fb:	3c 40                	cmp    $0x40,%al
  8015fd:	7e 25                	jle    801624 <str2lower+0x5c>
  8015ff:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801602:	8b 45 0c             	mov    0xc(%ebp),%eax
  801605:	01 d0                	add    %edx,%eax
  801607:	8a 00                	mov    (%eax),%al
  801609:	3c 5a                	cmp    $0x5a,%al
  80160b:	7f 17                	jg     801624 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  80160d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801610:	8b 45 08             	mov    0x8(%ebp),%eax
  801613:	01 d0                	add    %edx,%eax
  801615:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801618:	8b 55 08             	mov    0x8(%ebp),%edx
  80161b:	01 ca                	add    %ecx,%edx
  80161d:	8a 12                	mov    (%edx),%dl
  80161f:	83 c2 20             	add    $0x20,%edx
  801622:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801624:	ff 45 fc             	incl   -0x4(%ebp)
  801627:	ff 75 0c             	pushl  0xc(%ebp)
  80162a:	e8 01 f8 ff ff       	call   800e30 <strlen>
  80162f:	83 c4 04             	add    $0x4,%esp
  801632:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801635:	7f a6                	jg     8015dd <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801637:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80163a:	c9                   	leave  
  80163b:	c3                   	ret    

0080163c <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  80163c:	55                   	push   %ebp
  80163d:	89 e5                	mov    %esp,%ebp
  80163f:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801642:	a1 08 30 80 00       	mov    0x803008,%eax
  801647:	85 c0                	test   %eax,%eax
  801649:	74 42                	je     80168d <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  80164b:	83 ec 08             	sub    $0x8,%esp
  80164e:	68 00 00 00 82       	push   $0x82000000
  801653:	68 00 00 00 80       	push   $0x80000000
  801658:	e8 8c 07 00 00       	call   801de9 <initialize_dynamic_allocator>
  80165d:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801660:	e8 e7 05 00 00       	call   801c4c <sys_get_uheap_strategy>
  801665:	a3 00 cb 87 00       	mov    %eax,0x87cb00
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  80166a:	a1 40 30 80 00       	mov    0x803040,%eax
  80166f:	05 00 10 00 00       	add    $0x1000,%eax
  801674:	a3 b0 cb 87 00       	mov    %eax,0x87cbb0
		uheapPageAllocBreak = uheapPageAllocStart;
  801679:	a1 b0 cb 87 00       	mov    0x87cbb0,%eax
  80167e:	a3 08 cb 87 00       	mov    %eax,0x87cb08

		__firstTimeFlag = 0;
  801683:	c7 05 08 30 80 00 00 	movl   $0x0,0x803008
  80168a:	00 00 00 
	}
}
  80168d:	90                   	nop
  80168e:	c9                   	leave  
  80168f:	c3                   	ret    

00801690 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801690:	55                   	push   %ebp
  801691:	89 e5                	mov    %esp,%ebp
  801693:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801696:	8b 45 08             	mov    0x8(%ebp),%eax
  801699:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80169c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80169f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016a4:	83 ec 08             	sub    $0x8,%esp
  8016a7:	68 06 04 00 00       	push   $0x406
  8016ac:	50                   	push   %eax
  8016ad:	e8 e4 01 00 00       	call   801896 <__sys_allocate_page>
  8016b2:	83 c4 10             	add    $0x10,%esp
  8016b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8016b8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8016bc:	79 14                	jns    8016d2 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  8016be:	83 ec 04             	sub    $0x4,%esp
  8016c1:	68 88 29 80 00       	push   $0x802988
  8016c6:	6a 1f                	push   $0x1f
  8016c8:	68 c4 29 80 00       	push   $0x8029c4
  8016cd:	e8 86 08 00 00       	call   801f58 <_panic>
	return 0;
  8016d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016d7:	c9                   	leave  
  8016d8:	c3                   	ret    

008016d9 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  8016d9:	55                   	push   %ebp
  8016da:	89 e5                	mov    %esp,%ebp
  8016dc:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  8016df:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016e8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016ed:	83 ec 0c             	sub    $0xc,%esp
  8016f0:	50                   	push   %eax
  8016f1:	e8 e7 01 00 00       	call   8018dd <__sys_unmap_frame>
  8016f6:	83 c4 10             	add    $0x10,%esp
  8016f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8016fc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801700:	79 14                	jns    801716 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801702:	83 ec 04             	sub    $0x4,%esp
  801705:	68 d0 29 80 00       	push   $0x8029d0
  80170a:	6a 2a                	push   $0x2a
  80170c:	68 c4 29 80 00       	push   $0x8029c4
  801711:	e8 42 08 00 00       	call   801f58 <_panic>
}
  801716:	90                   	nop
  801717:	c9                   	leave  
  801718:	c3                   	ret    

00801719 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801719:	55                   	push   %ebp
  80171a:	89 e5                	mov    %esp,%ebp
  80171c:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80171f:	e8 18 ff ff ff       	call   80163c <uheap_init>
	if (size == 0) return NULL ;
  801724:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801728:	75 07                	jne    801731 <malloc+0x18>
  80172a:	b8 00 00 00 00       	mov    $0x0,%eax
  80172f:	eb 14                	jmp    801745 <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  801731:	83 ec 04             	sub    $0x4,%esp
  801734:	68 10 2a 80 00       	push   $0x802a10
  801739:	6a 3e                	push   $0x3e
  80173b:	68 c4 29 80 00       	push   $0x8029c4
  801740:	e8 13 08 00 00       	call   801f58 <_panic>
}
  801745:	c9                   	leave  
  801746:	c3                   	ret    

00801747 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801747:	55                   	push   %ebp
  801748:	89 e5                	mov    %esp,%ebp
  80174a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  80174d:	83 ec 04             	sub    $0x4,%esp
  801750:	68 38 2a 80 00       	push   $0x802a38
  801755:	6a 49                	push   $0x49
  801757:	68 c4 29 80 00       	push   $0x8029c4
  80175c:	e8 f7 07 00 00       	call   801f58 <_panic>

00801761 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801761:	55                   	push   %ebp
  801762:	89 e5                	mov    %esp,%ebp
  801764:	83 ec 18             	sub    $0x18,%esp
  801767:	8b 45 10             	mov    0x10(%ebp),%eax
  80176a:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80176d:	e8 ca fe ff ff       	call   80163c <uheap_init>
	if (size == 0) return NULL ;
  801772:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801776:	75 07                	jne    80177f <smalloc+0x1e>
  801778:	b8 00 00 00 00       	mov    $0x0,%eax
  80177d:	eb 14                	jmp    801793 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  80177f:	83 ec 04             	sub    $0x4,%esp
  801782:	68 5c 2a 80 00       	push   $0x802a5c
  801787:	6a 5a                	push   $0x5a
  801789:	68 c4 29 80 00       	push   $0x8029c4
  80178e:	e8 c5 07 00 00       	call   801f58 <_panic>
}
  801793:	c9                   	leave  
  801794:	c3                   	ret    

00801795 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801795:	55                   	push   %ebp
  801796:	89 e5                	mov    %esp,%ebp
  801798:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80179b:	e8 9c fe ff ff       	call   80163c <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  8017a0:	83 ec 04             	sub    $0x4,%esp
  8017a3:	68 84 2a 80 00       	push   $0x802a84
  8017a8:	6a 6a                	push   $0x6a
  8017aa:	68 c4 29 80 00       	push   $0x8029c4
  8017af:	e8 a4 07 00 00       	call   801f58 <_panic>

008017b4 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8017b4:	55                   	push   %ebp
  8017b5:	89 e5                	mov    %esp,%ebp
  8017b7:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8017ba:	e8 7d fe ff ff       	call   80163c <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  8017bf:	83 ec 04             	sub    $0x4,%esp
  8017c2:	68 a8 2a 80 00       	push   $0x802aa8
  8017c7:	68 88 00 00 00       	push   $0x88
  8017cc:	68 c4 29 80 00       	push   $0x8029c4
  8017d1:	e8 82 07 00 00       	call   801f58 <_panic>

008017d6 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  8017d6:	55                   	push   %ebp
  8017d7:	89 e5                	mov    %esp,%ebp
  8017d9:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  8017dc:	83 ec 04             	sub    $0x4,%esp
  8017df:	68 d0 2a 80 00       	push   $0x802ad0
  8017e4:	68 9b 00 00 00       	push   $0x9b
  8017e9:	68 c4 29 80 00       	push   $0x8029c4
  8017ee:	e8 65 07 00 00       	call   801f58 <_panic>

008017f3 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8017f3:	55                   	push   %ebp
  8017f4:	89 e5                	mov    %esp,%ebp
  8017f6:	57                   	push   %edi
  8017f7:	56                   	push   %esi
  8017f8:	53                   	push   %ebx
  8017f9:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801802:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801805:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801808:	8b 7d 18             	mov    0x18(%ebp),%edi
  80180b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80180e:	cd 30                	int    $0x30
  801810:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801813:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801816:	83 c4 10             	add    $0x10,%esp
  801819:	5b                   	pop    %ebx
  80181a:	5e                   	pop    %esi
  80181b:	5f                   	pop    %edi
  80181c:	5d                   	pop    %ebp
  80181d:	c3                   	ret    

0080181e <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  80181e:	55                   	push   %ebp
  80181f:	89 e5                	mov    %esp,%ebp
  801821:	83 ec 04             	sub    $0x4,%esp
  801824:	8b 45 10             	mov    0x10(%ebp),%eax
  801827:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  80182a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80182d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801831:	8b 45 08             	mov    0x8(%ebp),%eax
  801834:	6a 00                	push   $0x0
  801836:	51                   	push   %ecx
  801837:	52                   	push   %edx
  801838:	ff 75 0c             	pushl  0xc(%ebp)
  80183b:	50                   	push   %eax
  80183c:	6a 00                	push   $0x0
  80183e:	e8 b0 ff ff ff       	call   8017f3 <syscall>
  801843:	83 c4 18             	add    $0x18,%esp
}
  801846:	90                   	nop
  801847:	c9                   	leave  
  801848:	c3                   	ret    

00801849 <sys_cgetc>:

int
sys_cgetc(void)
{
  801849:	55                   	push   %ebp
  80184a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80184c:	6a 00                	push   $0x0
  80184e:	6a 00                	push   $0x0
  801850:	6a 00                	push   $0x0
  801852:	6a 00                	push   $0x0
  801854:	6a 00                	push   $0x0
  801856:	6a 02                	push   $0x2
  801858:	e8 96 ff ff ff       	call   8017f3 <syscall>
  80185d:	83 c4 18             	add    $0x18,%esp
}
  801860:	c9                   	leave  
  801861:	c3                   	ret    

00801862 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801862:	55                   	push   %ebp
  801863:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801865:	6a 00                	push   $0x0
  801867:	6a 00                	push   $0x0
  801869:	6a 00                	push   $0x0
  80186b:	6a 00                	push   $0x0
  80186d:	6a 00                	push   $0x0
  80186f:	6a 03                	push   $0x3
  801871:	e8 7d ff ff ff       	call   8017f3 <syscall>
  801876:	83 c4 18             	add    $0x18,%esp
}
  801879:	90                   	nop
  80187a:	c9                   	leave  
  80187b:	c3                   	ret    

0080187c <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80187c:	55                   	push   %ebp
  80187d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80187f:	6a 00                	push   $0x0
  801881:	6a 00                	push   $0x0
  801883:	6a 00                	push   $0x0
  801885:	6a 00                	push   $0x0
  801887:	6a 00                	push   $0x0
  801889:	6a 04                	push   $0x4
  80188b:	e8 63 ff ff ff       	call   8017f3 <syscall>
  801890:	83 c4 18             	add    $0x18,%esp
}
  801893:	90                   	nop
  801894:	c9                   	leave  
  801895:	c3                   	ret    

00801896 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801896:	55                   	push   %ebp
  801897:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801899:	8b 55 0c             	mov    0xc(%ebp),%edx
  80189c:	8b 45 08             	mov    0x8(%ebp),%eax
  80189f:	6a 00                	push   $0x0
  8018a1:	6a 00                	push   $0x0
  8018a3:	6a 00                	push   $0x0
  8018a5:	52                   	push   %edx
  8018a6:	50                   	push   %eax
  8018a7:	6a 08                	push   $0x8
  8018a9:	e8 45 ff ff ff       	call   8017f3 <syscall>
  8018ae:	83 c4 18             	add    $0x18,%esp
}
  8018b1:	c9                   	leave  
  8018b2:	c3                   	ret    

008018b3 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018b3:	55                   	push   %ebp
  8018b4:	89 e5                	mov    %esp,%ebp
  8018b6:	56                   	push   %esi
  8018b7:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018b8:	8b 75 18             	mov    0x18(%ebp),%esi
  8018bb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018be:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c7:	56                   	push   %esi
  8018c8:	53                   	push   %ebx
  8018c9:	51                   	push   %ecx
  8018ca:	52                   	push   %edx
  8018cb:	50                   	push   %eax
  8018cc:	6a 09                	push   $0x9
  8018ce:	e8 20 ff ff ff       	call   8017f3 <syscall>
  8018d3:	83 c4 18             	add    $0x18,%esp
}
  8018d6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018d9:	5b                   	pop    %ebx
  8018da:	5e                   	pop    %esi
  8018db:	5d                   	pop    %ebp
  8018dc:	c3                   	ret    

008018dd <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8018dd:	55                   	push   %ebp
  8018de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 00                	push   $0x0
  8018e6:	6a 00                	push   $0x0
  8018e8:	ff 75 08             	pushl  0x8(%ebp)
  8018eb:	6a 0a                	push   $0xa
  8018ed:	e8 01 ff ff ff       	call   8017f3 <syscall>
  8018f2:	83 c4 18             	add    $0x18,%esp
}
  8018f5:	c9                   	leave  
  8018f6:	c3                   	ret    

008018f7 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018f7:	55                   	push   %ebp
  8018f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018fa:	6a 00                	push   $0x0
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 00                	push   $0x0
  801900:	ff 75 0c             	pushl  0xc(%ebp)
  801903:	ff 75 08             	pushl  0x8(%ebp)
  801906:	6a 0b                	push   $0xb
  801908:	e8 e6 fe ff ff       	call   8017f3 <syscall>
  80190d:	83 c4 18             	add    $0x18,%esp
}
  801910:	c9                   	leave  
  801911:	c3                   	ret    

00801912 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801912:	55                   	push   %ebp
  801913:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801915:	6a 00                	push   $0x0
  801917:	6a 00                	push   $0x0
  801919:	6a 00                	push   $0x0
  80191b:	6a 00                	push   $0x0
  80191d:	6a 00                	push   $0x0
  80191f:	6a 0c                	push   $0xc
  801921:	e8 cd fe ff ff       	call   8017f3 <syscall>
  801926:	83 c4 18             	add    $0x18,%esp
}
  801929:	c9                   	leave  
  80192a:	c3                   	ret    

0080192b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80192b:	55                   	push   %ebp
  80192c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80192e:	6a 00                	push   $0x0
  801930:	6a 00                	push   $0x0
  801932:	6a 00                	push   $0x0
  801934:	6a 00                	push   $0x0
  801936:	6a 00                	push   $0x0
  801938:	6a 0d                	push   $0xd
  80193a:	e8 b4 fe ff ff       	call   8017f3 <syscall>
  80193f:	83 c4 18             	add    $0x18,%esp
}
  801942:	c9                   	leave  
  801943:	c3                   	ret    

00801944 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801944:	55                   	push   %ebp
  801945:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801947:	6a 00                	push   $0x0
  801949:	6a 00                	push   $0x0
  80194b:	6a 00                	push   $0x0
  80194d:	6a 00                	push   $0x0
  80194f:	6a 00                	push   $0x0
  801951:	6a 0e                	push   $0xe
  801953:	e8 9b fe ff ff       	call   8017f3 <syscall>
  801958:	83 c4 18             	add    $0x18,%esp
}
  80195b:	c9                   	leave  
  80195c:	c3                   	ret    

0080195d <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80195d:	55                   	push   %ebp
  80195e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801960:	6a 00                	push   $0x0
  801962:	6a 00                	push   $0x0
  801964:	6a 00                	push   $0x0
  801966:	6a 00                	push   $0x0
  801968:	6a 00                	push   $0x0
  80196a:	6a 0f                	push   $0xf
  80196c:	e8 82 fe ff ff       	call   8017f3 <syscall>
  801971:	83 c4 18             	add    $0x18,%esp
}
  801974:	c9                   	leave  
  801975:	c3                   	ret    

00801976 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801976:	55                   	push   %ebp
  801977:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801979:	6a 00                	push   $0x0
  80197b:	6a 00                	push   $0x0
  80197d:	6a 00                	push   $0x0
  80197f:	6a 00                	push   $0x0
  801981:	ff 75 08             	pushl  0x8(%ebp)
  801984:	6a 10                	push   $0x10
  801986:	e8 68 fe ff ff       	call   8017f3 <syscall>
  80198b:	83 c4 18             	add    $0x18,%esp
}
  80198e:	c9                   	leave  
  80198f:	c3                   	ret    

00801990 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801990:	55                   	push   %ebp
  801991:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801993:	6a 00                	push   $0x0
  801995:	6a 00                	push   $0x0
  801997:	6a 00                	push   $0x0
  801999:	6a 00                	push   $0x0
  80199b:	6a 00                	push   $0x0
  80199d:	6a 11                	push   $0x11
  80199f:	e8 4f fe ff ff       	call   8017f3 <syscall>
  8019a4:	83 c4 18             	add    $0x18,%esp
}
  8019a7:	90                   	nop
  8019a8:	c9                   	leave  
  8019a9:	c3                   	ret    

008019aa <sys_cputc>:

void
sys_cputc(const char c)
{
  8019aa:	55                   	push   %ebp
  8019ab:	89 e5                	mov    %esp,%ebp
  8019ad:	83 ec 04             	sub    $0x4,%esp
  8019b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8019b6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 00                	push   $0x0
  8019c2:	50                   	push   %eax
  8019c3:	6a 01                	push   $0x1
  8019c5:	e8 29 fe ff ff       	call   8017f3 <syscall>
  8019ca:	83 c4 18             	add    $0x18,%esp
}
  8019cd:	90                   	nop
  8019ce:	c9                   	leave  
  8019cf:	c3                   	ret    

008019d0 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8019d0:	55                   	push   %ebp
  8019d1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 00                	push   $0x0
  8019d9:	6a 00                	push   $0x0
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 14                	push   $0x14
  8019df:	e8 0f fe ff ff       	call   8017f3 <syscall>
  8019e4:	83 c4 18             	add    $0x18,%esp
}
  8019e7:	90                   	nop
  8019e8:	c9                   	leave  
  8019e9:	c3                   	ret    

008019ea <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8019ea:	55                   	push   %ebp
  8019eb:	89 e5                	mov    %esp,%ebp
  8019ed:	83 ec 04             	sub    $0x4,%esp
  8019f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8019f3:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8019f6:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8019f9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801a00:	6a 00                	push   $0x0
  801a02:	51                   	push   %ecx
  801a03:	52                   	push   %edx
  801a04:	ff 75 0c             	pushl  0xc(%ebp)
  801a07:	50                   	push   %eax
  801a08:	6a 15                	push   $0x15
  801a0a:	e8 e4 fd ff ff       	call   8017f3 <syscall>
  801a0f:	83 c4 18             	add    $0x18,%esp
}
  801a12:	c9                   	leave  
  801a13:	c3                   	ret    

00801a14 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801a14:	55                   	push   %ebp
  801a15:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a17:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 00                	push   $0x0
  801a23:	52                   	push   %edx
  801a24:	50                   	push   %eax
  801a25:	6a 16                	push   $0x16
  801a27:	e8 c7 fd ff ff       	call   8017f3 <syscall>
  801a2c:	83 c4 18             	add    $0x18,%esp
}
  801a2f:	c9                   	leave  
  801a30:	c3                   	ret    

00801a31 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801a31:	55                   	push   %ebp
  801a32:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a34:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a37:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3d:	6a 00                	push   $0x0
  801a3f:	6a 00                	push   $0x0
  801a41:	51                   	push   %ecx
  801a42:	52                   	push   %edx
  801a43:	50                   	push   %eax
  801a44:	6a 17                	push   $0x17
  801a46:	e8 a8 fd ff ff       	call   8017f3 <syscall>
  801a4b:	83 c4 18             	add    $0x18,%esp
}
  801a4e:	c9                   	leave  
  801a4f:	c3                   	ret    

00801a50 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801a50:	55                   	push   %ebp
  801a51:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a53:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a56:	8b 45 08             	mov    0x8(%ebp),%eax
  801a59:	6a 00                	push   $0x0
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 00                	push   $0x0
  801a5f:	52                   	push   %edx
  801a60:	50                   	push   %eax
  801a61:	6a 18                	push   $0x18
  801a63:	e8 8b fd ff ff       	call   8017f3 <syscall>
  801a68:	83 c4 18             	add    $0x18,%esp
}
  801a6b:	c9                   	leave  
  801a6c:	c3                   	ret    

00801a6d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a6d:	55                   	push   %ebp
  801a6e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a70:	8b 45 08             	mov    0x8(%ebp),%eax
  801a73:	6a 00                	push   $0x0
  801a75:	ff 75 14             	pushl  0x14(%ebp)
  801a78:	ff 75 10             	pushl  0x10(%ebp)
  801a7b:	ff 75 0c             	pushl  0xc(%ebp)
  801a7e:	50                   	push   %eax
  801a7f:	6a 19                	push   $0x19
  801a81:	e8 6d fd ff ff       	call   8017f3 <syscall>
  801a86:	83 c4 18             	add    $0x18,%esp
}
  801a89:	c9                   	leave  
  801a8a:	c3                   	ret    

00801a8b <sys_run_env>:

void sys_run_env(int32 envId)
{
  801a8b:	55                   	push   %ebp
  801a8c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a91:	6a 00                	push   $0x0
  801a93:	6a 00                	push   $0x0
  801a95:	6a 00                	push   $0x0
  801a97:	6a 00                	push   $0x0
  801a99:	50                   	push   %eax
  801a9a:	6a 1a                	push   $0x1a
  801a9c:	e8 52 fd ff ff       	call   8017f3 <syscall>
  801aa1:	83 c4 18             	add    $0x18,%esp
}
  801aa4:	90                   	nop
  801aa5:	c9                   	leave  
  801aa6:	c3                   	ret    

00801aa7 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801aa7:	55                   	push   %ebp
  801aa8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801aaa:	8b 45 08             	mov    0x8(%ebp),%eax
  801aad:	6a 00                	push   $0x0
  801aaf:	6a 00                	push   $0x0
  801ab1:	6a 00                	push   $0x0
  801ab3:	6a 00                	push   $0x0
  801ab5:	50                   	push   %eax
  801ab6:	6a 1b                	push   $0x1b
  801ab8:	e8 36 fd ff ff       	call   8017f3 <syscall>
  801abd:	83 c4 18             	add    $0x18,%esp
}
  801ac0:	c9                   	leave  
  801ac1:	c3                   	ret    

00801ac2 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ac2:	55                   	push   %ebp
  801ac3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 00                	push   $0x0
  801acd:	6a 00                	push   $0x0
  801acf:	6a 05                	push   $0x5
  801ad1:	e8 1d fd ff ff       	call   8017f3 <syscall>
  801ad6:	83 c4 18             	add    $0x18,%esp
}
  801ad9:	c9                   	leave  
  801ada:	c3                   	ret    

00801adb <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801adb:	55                   	push   %ebp
  801adc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 00                	push   $0x0
  801ae4:	6a 00                	push   $0x0
  801ae6:	6a 00                	push   $0x0
  801ae8:	6a 06                	push   $0x6
  801aea:	e8 04 fd ff ff       	call   8017f3 <syscall>
  801aef:	83 c4 18             	add    $0x18,%esp
}
  801af2:	c9                   	leave  
  801af3:	c3                   	ret    

00801af4 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801af4:	55                   	push   %ebp
  801af5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	6a 00                	push   $0x0
  801afd:	6a 00                	push   $0x0
  801aff:	6a 00                	push   $0x0
  801b01:	6a 07                	push   $0x7
  801b03:	e8 eb fc ff ff       	call   8017f3 <syscall>
  801b08:	83 c4 18             	add    $0x18,%esp
}
  801b0b:	c9                   	leave  
  801b0c:	c3                   	ret    

00801b0d <sys_exit_env>:


void sys_exit_env(void)
{
  801b0d:	55                   	push   %ebp
  801b0e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b10:	6a 00                	push   $0x0
  801b12:	6a 00                	push   $0x0
  801b14:	6a 00                	push   $0x0
  801b16:	6a 00                	push   $0x0
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 1c                	push   $0x1c
  801b1c:	e8 d2 fc ff ff       	call   8017f3 <syscall>
  801b21:	83 c4 18             	add    $0x18,%esp
}
  801b24:	90                   	nop
  801b25:	c9                   	leave  
  801b26:	c3                   	ret    

00801b27 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801b27:	55                   	push   %ebp
  801b28:	89 e5                	mov    %esp,%ebp
  801b2a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b2d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b30:	8d 50 04             	lea    0x4(%eax),%edx
  801b33:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b36:	6a 00                	push   $0x0
  801b38:	6a 00                	push   $0x0
  801b3a:	6a 00                	push   $0x0
  801b3c:	52                   	push   %edx
  801b3d:	50                   	push   %eax
  801b3e:	6a 1d                	push   $0x1d
  801b40:	e8 ae fc ff ff       	call   8017f3 <syscall>
  801b45:	83 c4 18             	add    $0x18,%esp
	return result;
  801b48:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b4b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b4e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b51:	89 01                	mov    %eax,(%ecx)
  801b53:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b56:	8b 45 08             	mov    0x8(%ebp),%eax
  801b59:	c9                   	leave  
  801b5a:	c2 04 00             	ret    $0x4

00801b5d <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b5d:	55                   	push   %ebp
  801b5e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b60:	6a 00                	push   $0x0
  801b62:	6a 00                	push   $0x0
  801b64:	ff 75 10             	pushl  0x10(%ebp)
  801b67:	ff 75 0c             	pushl  0xc(%ebp)
  801b6a:	ff 75 08             	pushl  0x8(%ebp)
  801b6d:	6a 13                	push   $0x13
  801b6f:	e8 7f fc ff ff       	call   8017f3 <syscall>
  801b74:	83 c4 18             	add    $0x18,%esp
	return ;
  801b77:	90                   	nop
}
  801b78:	c9                   	leave  
  801b79:	c3                   	ret    

00801b7a <sys_rcr2>:
uint32 sys_rcr2()
{
  801b7a:	55                   	push   %ebp
  801b7b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 00                	push   $0x0
  801b83:	6a 00                	push   $0x0
  801b85:	6a 00                	push   $0x0
  801b87:	6a 1e                	push   $0x1e
  801b89:	e8 65 fc ff ff       	call   8017f3 <syscall>
  801b8e:	83 c4 18             	add    $0x18,%esp
}
  801b91:	c9                   	leave  
  801b92:	c3                   	ret    

00801b93 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801b93:	55                   	push   %ebp
  801b94:	89 e5                	mov    %esp,%ebp
  801b96:	83 ec 04             	sub    $0x4,%esp
  801b99:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801b9f:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	50                   	push   %eax
  801bac:	6a 1f                	push   $0x1f
  801bae:	e8 40 fc ff ff       	call   8017f3 <syscall>
  801bb3:	83 c4 18             	add    $0x18,%esp
	return ;
  801bb6:	90                   	nop
}
  801bb7:	c9                   	leave  
  801bb8:	c3                   	ret    

00801bb9 <rsttst>:
void rsttst()
{
  801bb9:	55                   	push   %ebp
  801bba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801bbc:	6a 00                	push   $0x0
  801bbe:	6a 00                	push   $0x0
  801bc0:	6a 00                	push   $0x0
  801bc2:	6a 00                	push   $0x0
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 21                	push   $0x21
  801bc8:	e8 26 fc ff ff       	call   8017f3 <syscall>
  801bcd:	83 c4 18             	add    $0x18,%esp
	return ;
  801bd0:	90                   	nop
}
  801bd1:	c9                   	leave  
  801bd2:	c3                   	ret    

00801bd3 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801bd3:	55                   	push   %ebp
  801bd4:	89 e5                	mov    %esp,%ebp
  801bd6:	83 ec 04             	sub    $0x4,%esp
  801bd9:	8b 45 14             	mov    0x14(%ebp),%eax
  801bdc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801bdf:	8b 55 18             	mov    0x18(%ebp),%edx
  801be2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801be6:	52                   	push   %edx
  801be7:	50                   	push   %eax
  801be8:	ff 75 10             	pushl  0x10(%ebp)
  801beb:	ff 75 0c             	pushl  0xc(%ebp)
  801bee:	ff 75 08             	pushl  0x8(%ebp)
  801bf1:	6a 20                	push   $0x20
  801bf3:	e8 fb fb ff ff       	call   8017f3 <syscall>
  801bf8:	83 c4 18             	add    $0x18,%esp
	return ;
  801bfb:	90                   	nop
}
  801bfc:	c9                   	leave  
  801bfd:	c3                   	ret    

00801bfe <chktst>:
void chktst(uint32 n)
{
  801bfe:	55                   	push   %ebp
  801bff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	ff 75 08             	pushl  0x8(%ebp)
  801c0c:	6a 22                	push   $0x22
  801c0e:	e8 e0 fb ff ff       	call   8017f3 <syscall>
  801c13:	83 c4 18             	add    $0x18,%esp
	return ;
  801c16:	90                   	nop
}
  801c17:	c9                   	leave  
  801c18:	c3                   	ret    

00801c19 <inctst>:

void inctst()
{
  801c19:	55                   	push   %ebp
  801c1a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	6a 00                	push   $0x0
  801c24:	6a 00                	push   $0x0
  801c26:	6a 23                	push   $0x23
  801c28:	e8 c6 fb ff ff       	call   8017f3 <syscall>
  801c2d:	83 c4 18             	add    $0x18,%esp
	return ;
  801c30:	90                   	nop
}
  801c31:	c9                   	leave  
  801c32:	c3                   	ret    

00801c33 <gettst>:
uint32 gettst()
{
  801c33:	55                   	push   %ebp
  801c34:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c36:	6a 00                	push   $0x0
  801c38:	6a 00                	push   $0x0
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 24                	push   $0x24
  801c42:	e8 ac fb ff ff       	call   8017f3 <syscall>
  801c47:	83 c4 18             	add    $0x18,%esp
}
  801c4a:	c9                   	leave  
  801c4b:	c3                   	ret    

00801c4c <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801c4c:	55                   	push   %ebp
  801c4d:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	6a 00                	push   $0x0
  801c57:	6a 00                	push   $0x0
  801c59:	6a 25                	push   $0x25
  801c5b:	e8 93 fb ff ff       	call   8017f3 <syscall>
  801c60:	83 c4 18             	add    $0x18,%esp
  801c63:	a3 00 cb 87 00       	mov    %eax,0x87cb00
	return uheapPlaceStrategy ;
  801c68:	a1 00 cb 87 00       	mov    0x87cb00,%eax
}
  801c6d:	c9                   	leave  
  801c6e:	c3                   	ret    

00801c6f <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c6f:	55                   	push   %ebp
  801c70:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801c72:	8b 45 08             	mov    0x8(%ebp),%eax
  801c75:	a3 00 cb 87 00       	mov    %eax,0x87cb00
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c7a:	6a 00                	push   $0x0
  801c7c:	6a 00                	push   $0x0
  801c7e:	6a 00                	push   $0x0
  801c80:	6a 00                	push   $0x0
  801c82:	ff 75 08             	pushl  0x8(%ebp)
  801c85:	6a 26                	push   $0x26
  801c87:	e8 67 fb ff ff       	call   8017f3 <syscall>
  801c8c:	83 c4 18             	add    $0x18,%esp
	return ;
  801c8f:	90                   	nop
}
  801c90:	c9                   	leave  
  801c91:	c3                   	ret    

00801c92 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801c92:	55                   	push   %ebp
  801c93:	89 e5                	mov    %esp,%ebp
  801c95:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801c96:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c99:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca2:	6a 00                	push   $0x0
  801ca4:	53                   	push   %ebx
  801ca5:	51                   	push   %ecx
  801ca6:	52                   	push   %edx
  801ca7:	50                   	push   %eax
  801ca8:	6a 27                	push   $0x27
  801caa:	e8 44 fb ff ff       	call   8017f3 <syscall>
  801caf:	83 c4 18             	add    $0x18,%esp
}
  801cb2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cb5:	c9                   	leave  
  801cb6:	c3                   	ret    

00801cb7 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801cb7:	55                   	push   %ebp
  801cb8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801cba:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc0:	6a 00                	push   $0x0
  801cc2:	6a 00                	push   $0x0
  801cc4:	6a 00                	push   $0x0
  801cc6:	52                   	push   %edx
  801cc7:	50                   	push   %eax
  801cc8:	6a 28                	push   $0x28
  801cca:	e8 24 fb ff ff       	call   8017f3 <syscall>
  801ccf:	83 c4 18             	add    $0x18,%esp
}
  801cd2:	c9                   	leave  
  801cd3:	c3                   	ret    

00801cd4 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801cd4:	55                   	push   %ebp
  801cd5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801cd7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801cda:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce0:	6a 00                	push   $0x0
  801ce2:	51                   	push   %ecx
  801ce3:	ff 75 10             	pushl  0x10(%ebp)
  801ce6:	52                   	push   %edx
  801ce7:	50                   	push   %eax
  801ce8:	6a 29                	push   $0x29
  801cea:	e8 04 fb ff ff       	call   8017f3 <syscall>
  801cef:	83 c4 18             	add    $0x18,%esp
}
  801cf2:	c9                   	leave  
  801cf3:	c3                   	ret    

00801cf4 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801cf4:	55                   	push   %ebp
  801cf5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801cf7:	6a 00                	push   $0x0
  801cf9:	6a 00                	push   $0x0
  801cfb:	ff 75 10             	pushl  0x10(%ebp)
  801cfe:	ff 75 0c             	pushl  0xc(%ebp)
  801d01:	ff 75 08             	pushl  0x8(%ebp)
  801d04:	6a 12                	push   $0x12
  801d06:	e8 e8 fa ff ff       	call   8017f3 <syscall>
  801d0b:	83 c4 18             	add    $0x18,%esp
	return ;
  801d0e:	90                   	nop
}
  801d0f:	c9                   	leave  
  801d10:	c3                   	ret    

00801d11 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801d11:	55                   	push   %ebp
  801d12:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801d14:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d17:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 00                	push   $0x0
  801d1e:	6a 00                	push   $0x0
  801d20:	52                   	push   %edx
  801d21:	50                   	push   %eax
  801d22:	6a 2a                	push   $0x2a
  801d24:	e8 ca fa ff ff       	call   8017f3 <syscall>
  801d29:	83 c4 18             	add    $0x18,%esp
	return;
  801d2c:	90                   	nop
}
  801d2d:	c9                   	leave  
  801d2e:	c3                   	ret    

00801d2f <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801d2f:	55                   	push   %ebp
  801d30:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801d32:	6a 00                	push   $0x0
  801d34:	6a 00                	push   $0x0
  801d36:	6a 00                	push   $0x0
  801d38:	6a 00                	push   $0x0
  801d3a:	6a 00                	push   $0x0
  801d3c:	6a 2b                	push   $0x2b
  801d3e:	e8 b0 fa ff ff       	call   8017f3 <syscall>
  801d43:	83 c4 18             	add    $0x18,%esp
}
  801d46:	c9                   	leave  
  801d47:	c3                   	ret    

00801d48 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801d48:	55                   	push   %ebp
  801d49:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801d4b:	6a 00                	push   $0x0
  801d4d:	6a 00                	push   $0x0
  801d4f:	6a 00                	push   $0x0
  801d51:	ff 75 0c             	pushl  0xc(%ebp)
  801d54:	ff 75 08             	pushl  0x8(%ebp)
  801d57:	6a 2d                	push   $0x2d
  801d59:	e8 95 fa ff ff       	call   8017f3 <syscall>
  801d5e:	83 c4 18             	add    $0x18,%esp
	return;
  801d61:	90                   	nop
}
  801d62:	c9                   	leave  
  801d63:	c3                   	ret    

00801d64 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801d64:	55                   	push   %ebp
  801d65:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801d67:	6a 00                	push   $0x0
  801d69:	6a 00                	push   $0x0
  801d6b:	6a 00                	push   $0x0
  801d6d:	ff 75 0c             	pushl  0xc(%ebp)
  801d70:	ff 75 08             	pushl  0x8(%ebp)
  801d73:	6a 2c                	push   $0x2c
  801d75:	e8 79 fa ff ff       	call   8017f3 <syscall>
  801d7a:	83 c4 18             	add    $0x18,%esp
	return ;
  801d7d:	90                   	nop
}
  801d7e:	c9                   	leave  
  801d7f:	c3                   	ret    

00801d80 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801d80:	55                   	push   %ebp
  801d81:	89 e5                	mov    %esp,%ebp
  801d83:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801d86:	83 ec 04             	sub    $0x4,%esp
  801d89:	68 f4 2a 80 00       	push   $0x802af4
  801d8e:	68 25 01 00 00       	push   $0x125
  801d93:	68 27 2b 80 00       	push   $0x802b27
  801d98:	e8 bb 01 00 00       	call   801f58 <_panic>

00801d9d <to_page_va>:
//==================================================================================//
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  801d9d:	55                   	push   %ebp
  801d9e:	89 e5                	mov    %esp,%ebp
  801da0:	83 ec 10             	sub    $0x10,%esp
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  801da3:	8b 45 08             	mov    0x8(%ebp),%eax
  801da6:	ba 00 4b 86 00       	mov    $0x864b00,%edx
  801dab:	29 d0                	sub    %edx,%eax
  801dad:	c1 f8 02             	sar    $0x2,%eax
  801db0:	89 c2                	mov    %eax,%edx
  801db2:	89 d0                	mov    %edx,%eax
  801db4:	c1 e0 02             	shl    $0x2,%eax
  801db7:	01 d0                	add    %edx,%eax
  801db9:	c1 e0 02             	shl    $0x2,%eax
  801dbc:	01 d0                	add    %edx,%eax
  801dbe:	c1 e0 02             	shl    $0x2,%eax
  801dc1:	01 d0                	add    %edx,%eax
  801dc3:	89 c1                	mov    %eax,%ecx
  801dc5:	c1 e1 08             	shl    $0x8,%ecx
  801dc8:	01 c8                	add    %ecx,%eax
  801dca:	89 c1                	mov    %eax,%ecx
  801dcc:	c1 e1 10             	shl    $0x10,%ecx
  801dcf:	01 c8                	add    %ecx,%eax
  801dd1:	01 c0                	add    %eax,%eax
  801dd3:	01 d0                	add    %edx,%eax
  801dd5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  801dd8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ddb:	c1 e0 0c             	shl    $0xc,%eax
  801dde:	89 c2                	mov    %eax,%edx
  801de0:	a1 04 cb 87 00       	mov    0x87cb04,%eax
  801de5:	01 d0                	add    %edx,%eax
}
  801de7:	c9                   	leave  
  801de8:	c3                   	ret    

00801de9 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  801de9:	55                   	push   %ebp
  801dea:	89 e5                	mov    %esp,%ebp
  801dec:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  801def:	8b 45 08             	mov    0x8(%ebp),%eax
  801df2:	05 00 00 00 02       	add    $0x2000000,%eax
  801df7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801dfa:	73 16                	jae    801e12 <initialize_dynamic_allocator+0x29>
  801dfc:	68 38 2b 80 00       	push   $0x802b38
  801e01:	68 5e 2b 80 00       	push   $0x802b5e
  801e06:	6a 26                	push   $0x26
  801e08:	68 73 2b 80 00       	push   $0x802b73
  801e0d:	e8 46 01 00 00       	call   801f58 <_panic>
		is_initialized = 1;
  801e12:	c7 05 24 30 80 00 01 	movl   $0x1,0x803024
  801e19:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	//Comment the following line
	panic("initialize_dynamic_allocator() Not implemented yet");
  801e1c:	83 ec 04             	sub    $0x4,%esp
  801e1f:	68 8c 2b 80 00       	push   $0x802b8c
  801e24:	6a 2e                	push   $0x2e
  801e26:	68 73 2b 80 00       	push   $0x802b73
  801e2b:	e8 28 01 00 00       	call   801f58 <_panic>

00801e30 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  801e30:	55                   	push   %ebp
  801e31:	89 e5                	mov    %esp,%ebp
  801e33:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	//Comment the following line
	panic("get_block_size() Not implemented yet");
  801e36:	83 ec 04             	sub    $0x4,%esp
  801e39:	68 c0 2b 80 00       	push   $0x802bc0
  801e3e:	6a 3a                	push   $0x3a
  801e40:	68 73 2b 80 00       	push   $0x802b73
  801e45:	e8 0e 01 00 00       	call   801f58 <_panic>

00801e4a <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  801e4a:	55                   	push   %ebp
  801e4b:	89 e5                	mov    %esp,%ebp
  801e4d:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  801e50:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801e57:	76 16                	jbe    801e6f <alloc_block+0x25>
  801e59:	68 e8 2b 80 00       	push   $0x802be8
  801e5e:	68 5e 2b 80 00       	push   $0x802b5e
  801e63:	6a 46                	push   $0x46
  801e65:	68 73 2b 80 00       	push   $0x802b73
  801e6a:	e8 e9 00 00 00       	call   801f58 <_panic>
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	panic("alloc_block() Not implemented yet");
  801e6f:	83 ec 04             	sub    $0x4,%esp
  801e72:	68 0c 2c 80 00       	push   $0x802c0c
  801e77:	6a 4d                	push   $0x4d
  801e79:	68 73 2b 80 00       	push   $0x802b73
  801e7e:	e8 d5 00 00 00       	call   801f58 <_panic>

00801e83 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  801e83:	55                   	push   %ebp
  801e84:	89 e5                	mov    %esp,%ebp
  801e86:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  801e89:	8b 55 08             	mov    0x8(%ebp),%edx
  801e8c:	a1 04 cb 87 00       	mov    0x87cb04,%eax
  801e91:	39 c2                	cmp    %eax,%edx
  801e93:	72 0c                	jb     801ea1 <free_block+0x1e>
  801e95:	8b 55 08             	mov    0x8(%ebp),%edx
  801e98:	a1 40 30 80 00       	mov    0x803040,%eax
  801e9d:	39 c2                	cmp    %eax,%edx
  801e9f:	72 16                	jb     801eb7 <free_block+0x34>
  801ea1:	68 30 2c 80 00       	push   $0x802c30
  801ea6:	68 5e 2b 80 00       	push   $0x802b5e
  801eab:	6a 5b                	push   $0x5b
  801ead:	68 73 2b 80 00       	push   $0x802b73
  801eb2:	e8 a1 00 00 00       	call   801f58 <_panic>
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	panic("free_block() Not implemented yet");
  801eb7:	83 ec 04             	sub    $0x4,%esp
  801eba:	68 68 2c 80 00       	push   $0x802c68
  801ebf:	6a 63                	push   $0x63
  801ec1:	68 73 2b 80 00       	push   $0x802b73
  801ec6:	e8 8d 00 00 00       	call   801f58 <_panic>

00801ecb <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  801ecb:	55                   	push   %ebp
  801ecc:	89 e5                	mov    %esp,%ebp
  801ece:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  801ed1:	83 ec 04             	sub    $0x4,%esp
  801ed4:	68 8c 2c 80 00       	push   $0x802c8c
  801ed9:	6a 72                	push   $0x72
  801edb:	68 73 2b 80 00       	push   $0x802b73
  801ee0:	e8 73 00 00 00       	call   801f58 <_panic>

00801ee5 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  801ee5:	55                   	push   %ebp
  801ee6:	89 e5                	mov    %esp,%ebp
  801ee8:	83 ec 08             	sub    $0x8,%esp
	panic("create_semaphore() is not implemented yet...!!");
  801eeb:	83 ec 04             	sub    $0x4,%esp
  801eee:	68 b0 2c 80 00       	push   $0x802cb0
  801ef3:	6a 07                	push   $0x7
  801ef5:	68 df 2c 80 00       	push   $0x802cdf
  801efa:	e8 59 00 00 00       	call   801f58 <_panic>

00801eff <get_semaphore>:
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  801eff:	55                   	push   %ebp
  801f00:	89 e5                	mov    %esp,%ebp
  801f02:	83 ec 08             	sub    $0x8,%esp
	panic("get_semaphore() is not implemented yet...!!");
  801f05:	83 ec 04             	sub    $0x4,%esp
  801f08:	68 f0 2c 80 00       	push   $0x802cf0
  801f0d:	6a 0b                	push   $0xb
  801f0f:	68 df 2c 80 00       	push   $0x802cdf
  801f14:	e8 3f 00 00 00       	call   801f58 <_panic>

00801f19 <wait_semaphore>:
}

void wait_semaphore(struct semaphore sem)
{
  801f19:	55                   	push   %ebp
  801f1a:	89 e5                	mov    %esp,%ebp
  801f1c:	83 ec 08             	sub    $0x8,%esp
	panic("wait_semaphore() is not implemented yet...!!");
  801f1f:	83 ec 04             	sub    $0x4,%esp
  801f22:	68 1c 2d 80 00       	push   $0x802d1c
  801f27:	6a 10                	push   $0x10
  801f29:	68 df 2c 80 00       	push   $0x802cdf
  801f2e:	e8 25 00 00 00       	call   801f58 <_panic>

00801f33 <signal_semaphore>:
}

void signal_semaphore(struct semaphore sem)
{
  801f33:	55                   	push   %ebp
  801f34:	89 e5                	mov    %esp,%ebp
  801f36:	83 ec 08             	sub    $0x8,%esp
	panic("signal_semaphore() is not implemented yet...!!");
  801f39:	83 ec 04             	sub    $0x4,%esp
  801f3c:	68 4c 2d 80 00       	push   $0x802d4c
  801f41:	6a 15                	push   $0x15
  801f43:	68 df 2c 80 00       	push   $0x802cdf
  801f48:	e8 0b 00 00 00       	call   801f58 <_panic>

00801f4d <semaphore_count>:
}

int semaphore_count(struct semaphore sem)
{
  801f4d:	55                   	push   %ebp
  801f4e:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  801f50:	8b 45 08             	mov    0x8(%ebp),%eax
  801f53:	8b 40 10             	mov    0x10(%eax),%eax
}
  801f56:	5d                   	pop    %ebp
  801f57:	c3                   	ret    

00801f58 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801f58:	55                   	push   %ebp
  801f59:	89 e5                	mov    %esp,%ebp
  801f5b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801f5e:	8d 45 10             	lea    0x10(%ebp),%eax
  801f61:	83 c0 04             	add    $0x4,%eax
  801f64:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801f67:	a1 48 e6 8d 00       	mov    0x8de648,%eax
  801f6c:	85 c0                	test   %eax,%eax
  801f6e:	74 16                	je     801f86 <_panic+0x2e>
		cprintf("%s: ", argv0);
  801f70:	a1 48 e6 8d 00       	mov    0x8de648,%eax
  801f75:	83 ec 08             	sub    $0x8,%esp
  801f78:	50                   	push   %eax
  801f79:	68 7c 2d 80 00       	push   $0x802d7c
  801f7e:	e8 d4 e7 ff ff       	call   800757 <cprintf>
  801f83:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  801f86:	a1 04 30 80 00       	mov    0x803004,%eax
  801f8b:	83 ec 0c             	sub    $0xc,%esp
  801f8e:	ff 75 0c             	pushl  0xc(%ebp)
  801f91:	ff 75 08             	pushl  0x8(%ebp)
  801f94:	50                   	push   %eax
  801f95:	68 84 2d 80 00       	push   $0x802d84
  801f9a:	6a 74                	push   $0x74
  801f9c:	e8 e3 e7 ff ff       	call   800784 <cprintf_colored>
  801fa1:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  801fa4:	8b 45 10             	mov    0x10(%ebp),%eax
  801fa7:	83 ec 08             	sub    $0x8,%esp
  801faa:	ff 75 f4             	pushl  -0xc(%ebp)
  801fad:	50                   	push   %eax
  801fae:	e8 35 e7 ff ff       	call   8006e8 <vcprintf>
  801fb3:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801fb6:	83 ec 08             	sub    $0x8,%esp
  801fb9:	6a 00                	push   $0x0
  801fbb:	68 ac 2d 80 00       	push   $0x802dac
  801fc0:	e8 23 e7 ff ff       	call   8006e8 <vcprintf>
  801fc5:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801fc8:	e8 9c e6 ff ff       	call   800669 <exit>

	// should not return here
	while (1) ;
  801fcd:	eb fe                	jmp    801fcd <_panic+0x75>

00801fcf <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801fcf:	55                   	push   %ebp
  801fd0:	89 e5                	mov    %esp,%ebp
  801fd2:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801fd5:	a1 20 30 80 00       	mov    0x803020,%eax
  801fda:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801fe0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fe3:	39 c2                	cmp    %eax,%edx
  801fe5:	74 14                	je     801ffb <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801fe7:	83 ec 04             	sub    $0x4,%esp
  801fea:	68 b0 2d 80 00       	push   $0x802db0
  801fef:	6a 26                	push   $0x26
  801ff1:	68 fc 2d 80 00       	push   $0x802dfc
  801ff6:	e8 5d ff ff ff       	call   801f58 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801ffb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  802002:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802009:	e9 c5 00 00 00       	jmp    8020d3 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80200e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802011:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802018:	8b 45 08             	mov    0x8(%ebp),%eax
  80201b:	01 d0                	add    %edx,%eax
  80201d:	8b 00                	mov    (%eax),%eax
  80201f:	85 c0                	test   %eax,%eax
  802021:	75 08                	jne    80202b <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  802023:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  802026:	e9 a5 00 00 00       	jmp    8020d0 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80202b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802032:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802039:	eb 69                	jmp    8020a4 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80203b:	a1 20 30 80 00       	mov    0x803020,%eax
  802040:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  802046:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802049:	89 d0                	mov    %edx,%eax
  80204b:	01 c0                	add    %eax,%eax
  80204d:	01 d0                	add    %edx,%eax
  80204f:	c1 e0 03             	shl    $0x3,%eax
  802052:	01 c8                	add    %ecx,%eax
  802054:	8a 40 04             	mov    0x4(%eax),%al
  802057:	84 c0                	test   %al,%al
  802059:	75 46                	jne    8020a1 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80205b:	a1 20 30 80 00       	mov    0x803020,%eax
  802060:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  802066:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802069:	89 d0                	mov    %edx,%eax
  80206b:	01 c0                	add    %eax,%eax
  80206d:	01 d0                	add    %edx,%eax
  80206f:	c1 e0 03             	shl    $0x3,%eax
  802072:	01 c8                	add    %ecx,%eax
  802074:	8b 00                	mov    (%eax),%eax
  802076:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802079:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80207c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802081:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  802083:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802086:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80208d:	8b 45 08             	mov    0x8(%ebp),%eax
  802090:	01 c8                	add    %ecx,%eax
  802092:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  802094:	39 c2                	cmp    %eax,%edx
  802096:	75 09                	jne    8020a1 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  802098:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80209f:	eb 15                	jmp    8020b6 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8020a1:	ff 45 e8             	incl   -0x18(%ebp)
  8020a4:	a1 20 30 80 00       	mov    0x803020,%eax
  8020a9:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8020af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8020b2:	39 c2                	cmp    %eax,%edx
  8020b4:	77 85                	ja     80203b <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8020b6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8020ba:	75 14                	jne    8020d0 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8020bc:	83 ec 04             	sub    $0x4,%esp
  8020bf:	68 08 2e 80 00       	push   $0x802e08
  8020c4:	6a 3a                	push   $0x3a
  8020c6:	68 fc 2d 80 00       	push   $0x802dfc
  8020cb:	e8 88 fe ff ff       	call   801f58 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8020d0:	ff 45 f0             	incl   -0x10(%ebp)
  8020d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020d6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8020d9:	0f 8c 2f ff ff ff    	jl     80200e <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8020df:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8020e6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8020ed:	eb 26                	jmp    802115 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8020ef:	a1 20 30 80 00       	mov    0x803020,%eax
  8020f4:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8020fa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8020fd:	89 d0                	mov    %edx,%eax
  8020ff:	01 c0                	add    %eax,%eax
  802101:	01 d0                	add    %edx,%eax
  802103:	c1 e0 03             	shl    $0x3,%eax
  802106:	01 c8                	add    %ecx,%eax
  802108:	8a 40 04             	mov    0x4(%eax),%al
  80210b:	3c 01                	cmp    $0x1,%al
  80210d:	75 03                	jne    802112 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80210f:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802112:	ff 45 e0             	incl   -0x20(%ebp)
  802115:	a1 20 30 80 00       	mov    0x803020,%eax
  80211a:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  802120:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802123:	39 c2                	cmp    %eax,%edx
  802125:	77 c8                	ja     8020ef <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  802127:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80212a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80212d:	74 14                	je     802143 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80212f:	83 ec 04             	sub    $0x4,%esp
  802132:	68 5c 2e 80 00       	push   $0x802e5c
  802137:	6a 44                	push   $0x44
  802139:	68 fc 2d 80 00       	push   $0x802dfc
  80213e:	e8 15 fe ff ff       	call   801f58 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  802143:	90                   	nop
  802144:	c9                   	leave  
  802145:	c3                   	ret    
  802146:	66 90                	xchg   %ax,%ax

00802148 <__udivdi3>:
  802148:	55                   	push   %ebp
  802149:	57                   	push   %edi
  80214a:	56                   	push   %esi
  80214b:	53                   	push   %ebx
  80214c:	83 ec 1c             	sub    $0x1c,%esp
  80214f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802153:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802157:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80215b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80215f:	89 ca                	mov    %ecx,%edx
  802161:	89 f8                	mov    %edi,%eax
  802163:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802167:	85 f6                	test   %esi,%esi
  802169:	75 2d                	jne    802198 <__udivdi3+0x50>
  80216b:	39 cf                	cmp    %ecx,%edi
  80216d:	77 65                	ja     8021d4 <__udivdi3+0x8c>
  80216f:	89 fd                	mov    %edi,%ebp
  802171:	85 ff                	test   %edi,%edi
  802173:	75 0b                	jne    802180 <__udivdi3+0x38>
  802175:	b8 01 00 00 00       	mov    $0x1,%eax
  80217a:	31 d2                	xor    %edx,%edx
  80217c:	f7 f7                	div    %edi
  80217e:	89 c5                	mov    %eax,%ebp
  802180:	31 d2                	xor    %edx,%edx
  802182:	89 c8                	mov    %ecx,%eax
  802184:	f7 f5                	div    %ebp
  802186:	89 c1                	mov    %eax,%ecx
  802188:	89 d8                	mov    %ebx,%eax
  80218a:	f7 f5                	div    %ebp
  80218c:	89 cf                	mov    %ecx,%edi
  80218e:	89 fa                	mov    %edi,%edx
  802190:	83 c4 1c             	add    $0x1c,%esp
  802193:	5b                   	pop    %ebx
  802194:	5e                   	pop    %esi
  802195:	5f                   	pop    %edi
  802196:	5d                   	pop    %ebp
  802197:	c3                   	ret    
  802198:	39 ce                	cmp    %ecx,%esi
  80219a:	77 28                	ja     8021c4 <__udivdi3+0x7c>
  80219c:	0f bd fe             	bsr    %esi,%edi
  80219f:	83 f7 1f             	xor    $0x1f,%edi
  8021a2:	75 40                	jne    8021e4 <__udivdi3+0x9c>
  8021a4:	39 ce                	cmp    %ecx,%esi
  8021a6:	72 0a                	jb     8021b2 <__udivdi3+0x6a>
  8021a8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8021ac:	0f 87 9e 00 00 00    	ja     802250 <__udivdi3+0x108>
  8021b2:	b8 01 00 00 00       	mov    $0x1,%eax
  8021b7:	89 fa                	mov    %edi,%edx
  8021b9:	83 c4 1c             	add    $0x1c,%esp
  8021bc:	5b                   	pop    %ebx
  8021bd:	5e                   	pop    %esi
  8021be:	5f                   	pop    %edi
  8021bf:	5d                   	pop    %ebp
  8021c0:	c3                   	ret    
  8021c1:	8d 76 00             	lea    0x0(%esi),%esi
  8021c4:	31 ff                	xor    %edi,%edi
  8021c6:	31 c0                	xor    %eax,%eax
  8021c8:	89 fa                	mov    %edi,%edx
  8021ca:	83 c4 1c             	add    $0x1c,%esp
  8021cd:	5b                   	pop    %ebx
  8021ce:	5e                   	pop    %esi
  8021cf:	5f                   	pop    %edi
  8021d0:	5d                   	pop    %ebp
  8021d1:	c3                   	ret    
  8021d2:	66 90                	xchg   %ax,%ax
  8021d4:	89 d8                	mov    %ebx,%eax
  8021d6:	f7 f7                	div    %edi
  8021d8:	31 ff                	xor    %edi,%edi
  8021da:	89 fa                	mov    %edi,%edx
  8021dc:	83 c4 1c             	add    $0x1c,%esp
  8021df:	5b                   	pop    %ebx
  8021e0:	5e                   	pop    %esi
  8021e1:	5f                   	pop    %edi
  8021e2:	5d                   	pop    %ebp
  8021e3:	c3                   	ret    
  8021e4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8021e9:	89 eb                	mov    %ebp,%ebx
  8021eb:	29 fb                	sub    %edi,%ebx
  8021ed:	89 f9                	mov    %edi,%ecx
  8021ef:	d3 e6                	shl    %cl,%esi
  8021f1:	89 c5                	mov    %eax,%ebp
  8021f3:	88 d9                	mov    %bl,%cl
  8021f5:	d3 ed                	shr    %cl,%ebp
  8021f7:	89 e9                	mov    %ebp,%ecx
  8021f9:	09 f1                	or     %esi,%ecx
  8021fb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8021ff:	89 f9                	mov    %edi,%ecx
  802201:	d3 e0                	shl    %cl,%eax
  802203:	89 c5                	mov    %eax,%ebp
  802205:	89 d6                	mov    %edx,%esi
  802207:	88 d9                	mov    %bl,%cl
  802209:	d3 ee                	shr    %cl,%esi
  80220b:	89 f9                	mov    %edi,%ecx
  80220d:	d3 e2                	shl    %cl,%edx
  80220f:	8b 44 24 08          	mov    0x8(%esp),%eax
  802213:	88 d9                	mov    %bl,%cl
  802215:	d3 e8                	shr    %cl,%eax
  802217:	09 c2                	or     %eax,%edx
  802219:	89 d0                	mov    %edx,%eax
  80221b:	89 f2                	mov    %esi,%edx
  80221d:	f7 74 24 0c          	divl   0xc(%esp)
  802221:	89 d6                	mov    %edx,%esi
  802223:	89 c3                	mov    %eax,%ebx
  802225:	f7 e5                	mul    %ebp
  802227:	39 d6                	cmp    %edx,%esi
  802229:	72 19                	jb     802244 <__udivdi3+0xfc>
  80222b:	74 0b                	je     802238 <__udivdi3+0xf0>
  80222d:	89 d8                	mov    %ebx,%eax
  80222f:	31 ff                	xor    %edi,%edi
  802231:	e9 58 ff ff ff       	jmp    80218e <__udivdi3+0x46>
  802236:	66 90                	xchg   %ax,%ax
  802238:	8b 54 24 08          	mov    0x8(%esp),%edx
  80223c:	89 f9                	mov    %edi,%ecx
  80223e:	d3 e2                	shl    %cl,%edx
  802240:	39 c2                	cmp    %eax,%edx
  802242:	73 e9                	jae    80222d <__udivdi3+0xe5>
  802244:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802247:	31 ff                	xor    %edi,%edi
  802249:	e9 40 ff ff ff       	jmp    80218e <__udivdi3+0x46>
  80224e:	66 90                	xchg   %ax,%ax
  802250:	31 c0                	xor    %eax,%eax
  802252:	e9 37 ff ff ff       	jmp    80218e <__udivdi3+0x46>
  802257:	90                   	nop

00802258 <__umoddi3>:
  802258:	55                   	push   %ebp
  802259:	57                   	push   %edi
  80225a:	56                   	push   %esi
  80225b:	53                   	push   %ebx
  80225c:	83 ec 1c             	sub    $0x1c,%esp
  80225f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802263:	8b 74 24 34          	mov    0x34(%esp),%esi
  802267:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80226b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80226f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802273:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802277:	89 f3                	mov    %esi,%ebx
  802279:	89 fa                	mov    %edi,%edx
  80227b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80227f:	89 34 24             	mov    %esi,(%esp)
  802282:	85 c0                	test   %eax,%eax
  802284:	75 1a                	jne    8022a0 <__umoddi3+0x48>
  802286:	39 f7                	cmp    %esi,%edi
  802288:	0f 86 a2 00 00 00    	jbe    802330 <__umoddi3+0xd8>
  80228e:	89 c8                	mov    %ecx,%eax
  802290:	89 f2                	mov    %esi,%edx
  802292:	f7 f7                	div    %edi
  802294:	89 d0                	mov    %edx,%eax
  802296:	31 d2                	xor    %edx,%edx
  802298:	83 c4 1c             	add    $0x1c,%esp
  80229b:	5b                   	pop    %ebx
  80229c:	5e                   	pop    %esi
  80229d:	5f                   	pop    %edi
  80229e:	5d                   	pop    %ebp
  80229f:	c3                   	ret    
  8022a0:	39 f0                	cmp    %esi,%eax
  8022a2:	0f 87 ac 00 00 00    	ja     802354 <__umoddi3+0xfc>
  8022a8:	0f bd e8             	bsr    %eax,%ebp
  8022ab:	83 f5 1f             	xor    $0x1f,%ebp
  8022ae:	0f 84 ac 00 00 00    	je     802360 <__umoddi3+0x108>
  8022b4:	bf 20 00 00 00       	mov    $0x20,%edi
  8022b9:	29 ef                	sub    %ebp,%edi
  8022bb:	89 fe                	mov    %edi,%esi
  8022bd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8022c1:	89 e9                	mov    %ebp,%ecx
  8022c3:	d3 e0                	shl    %cl,%eax
  8022c5:	89 d7                	mov    %edx,%edi
  8022c7:	89 f1                	mov    %esi,%ecx
  8022c9:	d3 ef                	shr    %cl,%edi
  8022cb:	09 c7                	or     %eax,%edi
  8022cd:	89 e9                	mov    %ebp,%ecx
  8022cf:	d3 e2                	shl    %cl,%edx
  8022d1:	89 14 24             	mov    %edx,(%esp)
  8022d4:	89 d8                	mov    %ebx,%eax
  8022d6:	d3 e0                	shl    %cl,%eax
  8022d8:	89 c2                	mov    %eax,%edx
  8022da:	8b 44 24 08          	mov    0x8(%esp),%eax
  8022de:	d3 e0                	shl    %cl,%eax
  8022e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022e4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8022e8:	89 f1                	mov    %esi,%ecx
  8022ea:	d3 e8                	shr    %cl,%eax
  8022ec:	09 d0                	or     %edx,%eax
  8022ee:	d3 eb                	shr    %cl,%ebx
  8022f0:	89 da                	mov    %ebx,%edx
  8022f2:	f7 f7                	div    %edi
  8022f4:	89 d3                	mov    %edx,%ebx
  8022f6:	f7 24 24             	mull   (%esp)
  8022f9:	89 c6                	mov    %eax,%esi
  8022fb:	89 d1                	mov    %edx,%ecx
  8022fd:	39 d3                	cmp    %edx,%ebx
  8022ff:	0f 82 87 00 00 00    	jb     80238c <__umoddi3+0x134>
  802305:	0f 84 91 00 00 00    	je     80239c <__umoddi3+0x144>
  80230b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80230f:	29 f2                	sub    %esi,%edx
  802311:	19 cb                	sbb    %ecx,%ebx
  802313:	89 d8                	mov    %ebx,%eax
  802315:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802319:	d3 e0                	shl    %cl,%eax
  80231b:	89 e9                	mov    %ebp,%ecx
  80231d:	d3 ea                	shr    %cl,%edx
  80231f:	09 d0                	or     %edx,%eax
  802321:	89 e9                	mov    %ebp,%ecx
  802323:	d3 eb                	shr    %cl,%ebx
  802325:	89 da                	mov    %ebx,%edx
  802327:	83 c4 1c             	add    $0x1c,%esp
  80232a:	5b                   	pop    %ebx
  80232b:	5e                   	pop    %esi
  80232c:	5f                   	pop    %edi
  80232d:	5d                   	pop    %ebp
  80232e:	c3                   	ret    
  80232f:	90                   	nop
  802330:	89 fd                	mov    %edi,%ebp
  802332:	85 ff                	test   %edi,%edi
  802334:	75 0b                	jne    802341 <__umoddi3+0xe9>
  802336:	b8 01 00 00 00       	mov    $0x1,%eax
  80233b:	31 d2                	xor    %edx,%edx
  80233d:	f7 f7                	div    %edi
  80233f:	89 c5                	mov    %eax,%ebp
  802341:	89 f0                	mov    %esi,%eax
  802343:	31 d2                	xor    %edx,%edx
  802345:	f7 f5                	div    %ebp
  802347:	89 c8                	mov    %ecx,%eax
  802349:	f7 f5                	div    %ebp
  80234b:	89 d0                	mov    %edx,%eax
  80234d:	e9 44 ff ff ff       	jmp    802296 <__umoddi3+0x3e>
  802352:	66 90                	xchg   %ax,%ax
  802354:	89 c8                	mov    %ecx,%eax
  802356:	89 f2                	mov    %esi,%edx
  802358:	83 c4 1c             	add    $0x1c,%esp
  80235b:	5b                   	pop    %ebx
  80235c:	5e                   	pop    %esi
  80235d:	5f                   	pop    %edi
  80235e:	5d                   	pop    %ebp
  80235f:	c3                   	ret    
  802360:	3b 04 24             	cmp    (%esp),%eax
  802363:	72 06                	jb     80236b <__umoddi3+0x113>
  802365:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802369:	77 0f                	ja     80237a <__umoddi3+0x122>
  80236b:	89 f2                	mov    %esi,%edx
  80236d:	29 f9                	sub    %edi,%ecx
  80236f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802373:	89 14 24             	mov    %edx,(%esp)
  802376:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80237a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80237e:	8b 14 24             	mov    (%esp),%edx
  802381:	83 c4 1c             	add    $0x1c,%esp
  802384:	5b                   	pop    %ebx
  802385:	5e                   	pop    %esi
  802386:	5f                   	pop    %edi
  802387:	5d                   	pop    %ebp
  802388:	c3                   	ret    
  802389:	8d 76 00             	lea    0x0(%esi),%esi
  80238c:	2b 04 24             	sub    (%esp),%eax
  80238f:	19 fa                	sbb    %edi,%edx
  802391:	89 d1                	mov    %edx,%ecx
  802393:	89 c6                	mov    %eax,%esi
  802395:	e9 71 ff ff ff       	jmp    80230b <__umoddi3+0xb3>
  80239a:	66 90                	xchg   %ax,%ax
  80239c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8023a0:	72 ea                	jb     80238c <__umoddi3+0x134>
  8023a2:	89 d9                	mov    %ebx,%ecx
  8023a4:	e9 62 ff ff ff       	jmp    80230b <__umoddi3+0xb3>

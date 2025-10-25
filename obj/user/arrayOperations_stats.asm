
obj/user/arrayOperations_stats:     file format elf32-i386


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
  800031:	e8 31 06 00 00       	call   800667 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
void ArrayStats(int *Elements, int NumOfElements, int64 *mean, int64 *var, int *min, int *max, int *med);
int KthElement(int *Elements, int NumOfElements, int k);
int QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex, int kIndex);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 68             	sub    $0x68,%esp
	int32 envID = sys_getenvid();
  80003e:	e8 1f 1c 00 00       	call   801c62 <sys_getenvid>
  800043:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int32 parentenvID = sys_getparentenvid();
  800046:	e8 49 1c 00 00       	call   801c94 <sys_getparentenvid>
  80004b:	89 45 ec             	mov    %eax,-0x14(%ebp)

	int ret;
	/*[1] GET SEMAPHORES*/
	struct semaphore ready = get_semaphore(parentenvID, "Ready");
  80004e:	8d 45 c4             	lea    -0x3c(%ebp),%eax
  800051:	83 ec 04             	sub    $0x4,%esp
  800054:	68 c0 26 80 00       	push   $0x8026c0
  800059:	ff 75 ec             	pushl  -0x14(%ebp)
  80005c:	50                   	push   %eax
  80005d:	e8 3d 20 00 00       	call   80209f <get_semaphore>
  800062:	83 c4 0c             	add    $0xc,%esp
	struct semaphore finished = get_semaphore(parentenvID, "Finished");
  800065:	8d 45 c0             	lea    -0x40(%ebp),%eax
  800068:	83 ec 04             	sub    $0x4,%esp
  80006b:	68 c6 26 80 00       	push   $0x8026c6
  800070:	ff 75 ec             	pushl  -0x14(%ebp)
  800073:	50                   	push   %eax
  800074:	e8 26 20 00 00       	call   80209f <get_semaphore>
  800079:	83 c4 0c             	add    $0xc,%esp

	/*[2] WAIT A READY SIGNAL FROM THE MASTER*/
	wait_semaphore(ready);
  80007c:	83 ec 0c             	sub    $0xc,%esp
  80007f:	ff 75 c4             	pushl  -0x3c(%ebp)
  800082:	e8 32 20 00 00       	call   8020b9 <wait_semaphore>
  800087:	83 c4 10             	add    $0x10,%esp

	/*[3] GET SHARED VARs*/
	//Get the cons_mutex ownerID
	int* consMutexOwnerID = sget(parentenvID, "cons_mutex ownerID") ;
  80008a:	83 ec 08             	sub    $0x8,%esp
  80008d:	68 cf 26 80 00       	push   $0x8026cf
  800092:	ff 75 ec             	pushl  -0x14(%ebp)
  800095:	e8 9b 18 00 00       	call   801935 <sget>
  80009a:	83 c4 10             	add    $0x10,%esp
  80009d:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct semaphore cons_mutex = get_semaphore(*consMutexOwnerID, "Console Mutex");
  8000a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000a3:	8b 10                	mov    (%eax),%edx
  8000a5:	8d 45 bc             	lea    -0x44(%ebp),%eax
  8000a8:	83 ec 04             	sub    $0x4,%esp
  8000ab:	68 e2 26 80 00       	push   $0x8026e2
  8000b0:	52                   	push   %edx
  8000b1:	50                   	push   %eax
  8000b2:	e8 e8 1f 00 00       	call   80209f <get_semaphore>
  8000b7:	83 c4 0c             	add    $0xc,%esp

	//Get the shared array & its size
	int *numOfElements = NULL;
  8000ba:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	int *sharedArray = NULL;
  8000c1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	sharedArray = sget(parentenvID,"arr") ;
  8000c8:	83 ec 08             	sub    $0x8,%esp
  8000cb:	68 f0 26 80 00       	push   $0x8026f0
  8000d0:	ff 75 ec             	pushl  -0x14(%ebp)
  8000d3:	e8 5d 18 00 00       	call   801935 <sget>
  8000d8:	83 c4 10             	add    $0x10,%esp
  8000db:	89 45 e0             	mov    %eax,-0x20(%ebp)
	numOfElements = sget(parentenvID,"arrSize") ;
  8000de:	83 ec 08             	sub    $0x8,%esp
  8000e1:	68 f4 26 80 00       	push   $0x8026f4
  8000e6:	ff 75 ec             	pushl  -0x14(%ebp)
  8000e9:	e8 47 18 00 00       	call   801935 <sget>
  8000ee:	83 c4 10             	add    $0x10,%esp
  8000f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int max ;
	int med ;

	//take a copy from the original array
	int *tmpArray;
	tmpArray = smalloc("tmpArr", sizeof(int) * *numOfElements, 0) ;
  8000f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000f7:	8b 00                	mov    (%eax),%eax
  8000f9:	c1 e0 02             	shl    $0x2,%eax
  8000fc:	83 ec 04             	sub    $0x4,%esp
  8000ff:	6a 00                	push   $0x0
  800101:	50                   	push   %eax
  800102:	68 fc 26 80 00       	push   $0x8026fc
  800107:	e8 f5 17 00 00       	call   801901 <smalloc>
  80010c:	83 c4 10             	add    $0x10,%esp
  80010f:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  800112:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800119:	eb 25                	jmp    800140 <_main+0x108>
	{
		tmpArray[i] = sharedArray[i];
  80011b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80011e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800125:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800128:	01 c2                	add    %eax,%edx
  80012a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80012d:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800134:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800137:	01 c8                	add    %ecx,%eax
  800139:	8b 00                	mov    (%eax),%eax
  80013b:	89 02                	mov    %eax,(%edx)

	//take a copy from the original array
	int *tmpArray;
	tmpArray = smalloc("tmpArr", sizeof(int) * *numOfElements, 0) ;
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  80013d:	ff 45 f4             	incl   -0xc(%ebp)
  800140:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800143:	8b 00                	mov    (%eax),%eax
  800145:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800148:	7f d1                	jg     80011b <_main+0xe3>
	{
		tmpArray[i] = sharedArray[i];
	}

	ArrayStats(tmpArray ,*numOfElements, &mean, &var, &min, &max, &med);
  80014a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80014d:	8b 00                	mov    (%eax),%eax
  80014f:	83 ec 04             	sub    $0x4,%esp
  800152:	8d 55 9c             	lea    -0x64(%ebp),%edx
  800155:	52                   	push   %edx
  800156:	8d 55 a0             	lea    -0x60(%ebp),%edx
  800159:	52                   	push   %edx
  80015a:	8d 55 a4             	lea    -0x5c(%ebp),%edx
  80015d:	52                   	push   %edx
  80015e:	8d 55 a8             	lea    -0x58(%ebp),%edx
  800161:	52                   	push   %edx
  800162:	8d 55 b0             	lea    -0x50(%ebp),%edx
  800165:	52                   	push   %edx
  800166:	50                   	push   %eax
  800167:	ff 75 dc             	pushl  -0x24(%ebp)
  80016a:	e8 bf 02 00 00       	call   80042e <ArrayStats>
  80016f:	83 c4 20             	add    $0x20,%esp

	wait_semaphore(cons_mutex);
  800172:	83 ec 0c             	sub    $0xc,%esp
  800175:	ff 75 bc             	pushl  -0x44(%ebp)
  800178:	e8 3c 1f 00 00       	call   8020b9 <wait_semaphore>
  80017d:	83 c4 10             	add    $0x10,%esp
	{
		cprintf("Stats Calculations are Finished!!!!\n") ;
  800180:	83 ec 0c             	sub    $0xc,%esp
  800183:	68 04 27 80 00       	push   $0x802704
  800188:	e8 6a 07 00 00       	call   8008f7 <cprintf>
  80018d:	83 c4 10             	add    $0x10,%esp
		cprintf("will share the rsults & notify the master now...\n");
  800190:	83 ec 0c             	sub    $0xc,%esp
  800193:	68 2c 27 80 00       	push   $0x80272c
  800198:	e8 5a 07 00 00       	call   8008f7 <cprintf>
  80019d:	83 c4 10             	add    $0x10,%esp
	}
	signal_semaphore(cons_mutex);
  8001a0:	83 ec 0c             	sub    $0xc,%esp
  8001a3:	ff 75 bc             	pushl  -0x44(%ebp)
  8001a6:	e8 28 1f 00 00       	call   8020d3 <signal_semaphore>
  8001ab:	83 c4 10             	add    $0x10,%esp

	/*[3] SHARE THE RESULTS & DECLARE FINISHING*/
	int64 *shMean, *shVar;
	int *shMin, *shMax, *shMed;
	shMean = smalloc("mean", sizeof(int64), 0) ; *shMean = mean;
  8001ae:	83 ec 04             	sub    $0x4,%esp
  8001b1:	6a 00                	push   $0x0
  8001b3:	6a 08                	push   $0x8
  8001b5:	68 5e 27 80 00       	push   $0x80275e
  8001ba:	e8 42 17 00 00       	call   801901 <smalloc>
  8001bf:	83 c4 10             	add    $0x10,%esp
  8001c2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001c5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8001c8:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  8001cb:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  8001ce:	89 01                	mov    %eax,(%ecx)
  8001d0:	89 51 04             	mov    %edx,0x4(%ecx)
	shVar = smalloc("var", sizeof(int64), 0) ; *shVar = var;
  8001d3:	83 ec 04             	sub    $0x4,%esp
  8001d6:	6a 00                	push   $0x0
  8001d8:	6a 08                	push   $0x8
  8001da:	68 63 27 80 00       	push   $0x802763
  8001df:	e8 1d 17 00 00       	call   801901 <smalloc>
  8001e4:	83 c4 10             	add    $0x10,%esp
  8001e7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8001ea:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8001ed:	8b 55 ac             	mov    -0x54(%ebp),%edx
  8001f0:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8001f3:	89 01                	mov    %eax,(%ecx)
  8001f5:	89 51 04             	mov    %edx,0x4(%ecx)
	shMin = smalloc("min", sizeof(int), 0) ; *shMin = min;
  8001f8:	83 ec 04             	sub    $0x4,%esp
  8001fb:	6a 00                	push   $0x0
  8001fd:	6a 04                	push   $0x4
  8001ff:	68 67 27 80 00       	push   $0x802767
  800204:	e8 f8 16 00 00       	call   801901 <smalloc>
  800209:	83 c4 10             	add    $0x10,%esp
  80020c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80020f:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  800212:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800215:	89 10                	mov    %edx,(%eax)
	shMax = smalloc("max", sizeof(int), 0) ; *shMax = max;
  800217:	83 ec 04             	sub    $0x4,%esp
  80021a:	6a 00                	push   $0x0
  80021c:	6a 04                	push   $0x4
  80021e:	68 6b 27 80 00       	push   $0x80276b
  800223:	e8 d9 16 00 00       	call   801901 <smalloc>
  800228:	83 c4 10             	add    $0x10,%esp
  80022b:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80022e:	8b 55 a0             	mov    -0x60(%ebp),%edx
  800231:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800234:	89 10                	mov    %edx,(%eax)
	shMed = smalloc("med", sizeof(int), 0) ; *shMed = med;
  800236:	83 ec 04             	sub    $0x4,%esp
  800239:	6a 00                	push   $0x0
  80023b:	6a 04                	push   $0x4
  80023d:	68 6f 27 80 00       	push   $0x80276f
  800242:	e8 ba 16 00 00       	call   801901 <smalloc>
  800247:	83 c4 10             	add    $0x10,%esp
  80024a:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80024d:	8b 55 9c             	mov    -0x64(%ebp),%edx
  800250:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800253:	89 10                	mov    %edx,(%eax)

	wait_semaphore(cons_mutex);
  800255:	83 ec 0c             	sub    $0xc,%esp
  800258:	ff 75 bc             	pushl  -0x44(%ebp)
  80025b:	e8 59 1e 00 00       	call   8020b9 <wait_semaphore>
  800260:	83 c4 10             	add    $0x10,%esp
	{
		cprintf("Stats app says GOOD BYE :)\n") ;
  800263:	83 ec 0c             	sub    $0xc,%esp
  800266:	68 73 27 80 00       	push   $0x802773
  80026b:	e8 87 06 00 00       	call   8008f7 <cprintf>
  800270:	83 c4 10             	add    $0x10,%esp
	}
	signal_semaphore(cons_mutex);
  800273:	83 ec 0c             	sub    $0xc,%esp
  800276:	ff 75 bc             	pushl  -0x44(%ebp)
  800279:	e8 55 1e 00 00       	call   8020d3 <signal_semaphore>
  80027e:	83 c4 10             	add    $0x10,%esp

	signal_semaphore(finished);
  800281:	83 ec 0c             	sub    $0xc,%esp
  800284:	ff 75 c0             	pushl  -0x40(%ebp)
  800287:	e8 47 1e 00 00       	call   8020d3 <signal_semaphore>
  80028c:	83 c4 10             	add    $0x10,%esp

}
  80028f:	90                   	nop
  800290:	c9                   	leave  
  800291:	c3                   	ret    

00800292 <KthElement>:



///Kth Element
int KthElement(int *Elements, int NumOfElements, int k)
{
  800292:	55                   	push   %ebp
  800293:	89 e5                	mov    %esp,%ebp
  800295:	83 ec 08             	sub    $0x8,%esp
	return QSort(Elements, NumOfElements, 0, NumOfElements-1, k-1) ;
  800298:	8b 45 10             	mov    0x10(%ebp),%eax
  80029b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80029e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002a1:	48                   	dec    %eax
  8002a2:	83 ec 0c             	sub    $0xc,%esp
  8002a5:	52                   	push   %edx
  8002a6:	50                   	push   %eax
  8002a7:	6a 00                	push   $0x0
  8002a9:	ff 75 0c             	pushl  0xc(%ebp)
  8002ac:	ff 75 08             	pushl  0x8(%ebp)
  8002af:	e8 05 00 00 00       	call   8002b9 <QSort>
  8002b4:	83 c4 20             	add    $0x20,%esp
}
  8002b7:	c9                   	leave  
  8002b8:	c3                   	ret    

008002b9 <QSort>:


int QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex, int kIndex)
{
  8002b9:	55                   	push   %ebp
  8002ba:	89 e5                	mov    %esp,%ebp
  8002bc:	83 ec 28             	sub    $0x28,%esp
	if (startIndex >= finalIndex) return Elements[finalIndex];
  8002bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8002c2:	3b 45 14             	cmp    0x14(%ebp),%eax
  8002c5:	7c 16                	jl     8002dd <QSort+0x24>
  8002c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8002ca:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d4:	01 d0                	add    %edx,%eax
  8002d6:	8b 00                	mov    (%eax),%eax
  8002d8:	e9 4f 01 00 00       	jmp    80042c <QSort+0x173>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  8002dd:	0f 31                	rdtsc  
  8002df:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8002e2:	89 55 e0             	mov    %edx,-0x20(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  8002e5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002e8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8002eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002ee:	89 55 e8             	mov    %edx,-0x18(%ebp)

	int pvtIndex = RANDU(startIndex, finalIndex) ;
  8002f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002f4:	8b 55 14             	mov    0x14(%ebp),%edx
  8002f7:	2b 55 10             	sub    0x10(%ebp),%edx
  8002fa:	89 d1                	mov    %edx,%ecx
  8002fc:	ba 00 00 00 00       	mov    $0x0,%edx
  800301:	f7 f1                	div    %ecx
  800303:	8b 45 10             	mov    0x10(%ebp),%eax
  800306:	01 d0                	add    %edx,%eax
  800308:	89 45 ec             	mov    %eax,-0x14(%ebp)
	Swap(Elements, startIndex, pvtIndex);
  80030b:	83 ec 04             	sub    $0x4,%esp
  80030e:	ff 75 ec             	pushl  -0x14(%ebp)
  800311:	ff 75 10             	pushl  0x10(%ebp)
  800314:	ff 75 08             	pushl  0x8(%ebp)
  800317:	e8 f8 02 00 00       	call   800614 <Swap>
  80031c:	83 c4 10             	add    $0x10,%esp

	int i = startIndex+1, j = finalIndex;
  80031f:	8b 45 10             	mov    0x10(%ebp),%eax
  800322:	40                   	inc    %eax
  800323:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800326:	8b 45 14             	mov    0x14(%ebp),%eax
  800329:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  80032c:	e9 80 00 00 00       	jmp    8003b1 <QSort+0xf8>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  800331:	ff 45 f4             	incl   -0xc(%ebp)
  800334:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800337:	3b 45 14             	cmp    0x14(%ebp),%eax
  80033a:	7f 2b                	jg     800367 <QSort+0xae>
  80033c:	8b 45 10             	mov    0x10(%ebp),%eax
  80033f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800346:	8b 45 08             	mov    0x8(%ebp),%eax
  800349:	01 d0                	add    %edx,%eax
  80034b:	8b 10                	mov    (%eax),%edx
  80034d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800350:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800357:	8b 45 08             	mov    0x8(%ebp),%eax
  80035a:	01 c8                	add    %ecx,%eax
  80035c:	8b 00                	mov    (%eax),%eax
  80035e:	39 c2                	cmp    %eax,%edx
  800360:	7d cf                	jge    800331 <QSort+0x78>
		while (j > startIndex && Elements[startIndex] < Elements[j]) j--;
  800362:	eb 03                	jmp    800367 <QSort+0xae>
  800364:	ff 4d f0             	decl   -0x10(%ebp)
  800367:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80036a:	3b 45 10             	cmp    0x10(%ebp),%eax
  80036d:	7e 26                	jle    800395 <QSort+0xdc>
  80036f:	8b 45 10             	mov    0x10(%ebp),%eax
  800372:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800379:	8b 45 08             	mov    0x8(%ebp),%eax
  80037c:	01 d0                	add    %edx,%eax
  80037e:	8b 10                	mov    (%eax),%edx
  800380:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800383:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80038a:	8b 45 08             	mov    0x8(%ebp),%eax
  80038d:	01 c8                	add    %ecx,%eax
  80038f:	8b 00                	mov    (%eax),%eax
  800391:	39 c2                	cmp    %eax,%edx
  800393:	7c cf                	jl     800364 <QSort+0xab>

		if (i <= j)
  800395:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800398:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80039b:	7f 14                	jg     8003b1 <QSort+0xf8>
		{
			Swap(Elements, i, j);
  80039d:	83 ec 04             	sub    $0x4,%esp
  8003a0:	ff 75 f0             	pushl  -0x10(%ebp)
  8003a3:	ff 75 f4             	pushl  -0xc(%ebp)
  8003a6:	ff 75 08             	pushl  0x8(%ebp)
  8003a9:	e8 66 02 00 00       	call   800614 <Swap>
  8003ae:	83 c4 10             	add    $0x10,%esp
	int pvtIndex = RANDU(startIndex, finalIndex) ;
	Swap(Elements, startIndex, pvtIndex);

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  8003b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003b4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8003b7:	0f 8e 77 ff ff ff    	jle    800334 <QSort+0x7b>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  8003bd:	83 ec 04             	sub    $0x4,%esp
  8003c0:	ff 75 f0             	pushl  -0x10(%ebp)
  8003c3:	ff 75 10             	pushl  0x10(%ebp)
  8003c6:	ff 75 08             	pushl  0x8(%ebp)
  8003c9:	e8 46 02 00 00       	call   800614 <Swap>
  8003ce:	83 c4 10             	add    $0x10,%esp

	if (kIndex == j)
  8003d1:	8b 45 18             	mov    0x18(%ebp),%eax
  8003d4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8003d7:	75 13                	jne    8003ec <QSort+0x133>
		return Elements[kIndex] ;
  8003d9:	8b 45 18             	mov    0x18(%ebp),%eax
  8003dc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e6:	01 d0                	add    %edx,%eax
  8003e8:	8b 00                	mov    (%eax),%eax
  8003ea:	eb 40                	jmp    80042c <QSort+0x173>
	else if (kIndex < j)
  8003ec:	8b 45 18             	mov    0x18(%ebp),%eax
  8003ef:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8003f2:	7d 1e                	jge    800412 <QSort+0x159>
		return QSort(Elements, NumOfElements, startIndex, j - 1, kIndex);
  8003f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003f7:	48                   	dec    %eax
  8003f8:	83 ec 0c             	sub    $0xc,%esp
  8003fb:	ff 75 18             	pushl  0x18(%ebp)
  8003fe:	50                   	push   %eax
  8003ff:	ff 75 10             	pushl  0x10(%ebp)
  800402:	ff 75 0c             	pushl  0xc(%ebp)
  800405:	ff 75 08             	pushl  0x8(%ebp)
  800408:	e8 ac fe ff ff       	call   8002b9 <QSort>
  80040d:	83 c4 20             	add    $0x20,%esp
  800410:	eb 1a                	jmp    80042c <QSort+0x173>
	else
		return QSort(Elements, NumOfElements, i, finalIndex, kIndex);
  800412:	83 ec 0c             	sub    $0xc,%esp
  800415:	ff 75 18             	pushl  0x18(%ebp)
  800418:	ff 75 14             	pushl  0x14(%ebp)
  80041b:	ff 75 f4             	pushl  -0xc(%ebp)
  80041e:	ff 75 0c             	pushl  0xc(%ebp)
  800421:	ff 75 08             	pushl  0x8(%ebp)
  800424:	e8 90 fe ff ff       	call   8002b9 <QSort>
  800429:	83 c4 20             	add    $0x20,%esp
}
  80042c:	c9                   	leave  
  80042d:	c3                   	ret    

0080042e <ArrayStats>:

void ArrayStats(int *Elements, int NumOfElements, int64 *mean, int64 *var, int *min, int *max, int *med)
{
  80042e:	55                   	push   %ebp
  80042f:	89 e5                	mov    %esp,%ebp
  800431:	57                   	push   %edi
  800432:	56                   	push   %esi
  800433:	53                   	push   %ebx
  800434:	83 ec 2c             	sub    $0x2c,%esp
	int i ;
	*mean =0 ;
  800437:	8b 45 10             	mov    0x10(%ebp),%eax
  80043a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  800440:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	*min = 0x7FFFFFFF ;
  800447:	8b 45 18             	mov    0x18(%ebp),%eax
  80044a:	c7 00 ff ff ff 7f    	movl   $0x7fffffff,(%eax)
	*max = 0x80000000 ;
  800450:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800453:	c7 00 00 00 00 80    	movl   $0x80000000,(%eax)
	for (i = 0 ; i < NumOfElements ; i++)
  800459:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800460:	e9 89 00 00 00       	jmp    8004ee <ArrayStats+0xc0>
	{
		(*mean) += Elements[i];
  800465:	8b 45 10             	mov    0x10(%ebp),%eax
  800468:	8b 08                	mov    (%eax),%ecx
  80046a:	8b 58 04             	mov    0x4(%eax),%ebx
  80046d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800470:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800477:	8b 45 08             	mov    0x8(%ebp),%eax
  80047a:	01 d0                	add    %edx,%eax
  80047c:	8b 00                	mov    (%eax),%eax
  80047e:	99                   	cltd   
  80047f:	01 c8                	add    %ecx,%eax
  800481:	11 da                	adc    %ebx,%edx
  800483:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800486:	89 01                	mov    %eax,(%ecx)
  800488:	89 51 04             	mov    %edx,0x4(%ecx)
		if (Elements[i] < (*min))
  80048b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80048e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800495:	8b 45 08             	mov    0x8(%ebp),%eax
  800498:	01 d0                	add    %edx,%eax
  80049a:	8b 10                	mov    (%eax),%edx
  80049c:	8b 45 18             	mov    0x18(%ebp),%eax
  80049f:	8b 00                	mov    (%eax),%eax
  8004a1:	39 c2                	cmp    %eax,%edx
  8004a3:	7d 16                	jge    8004bb <ArrayStats+0x8d>
		{
			(*min) = Elements[i];
  8004a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004a8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004af:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b2:	01 d0                	add    %edx,%eax
  8004b4:	8b 10                	mov    (%eax),%edx
  8004b6:	8b 45 18             	mov    0x18(%ebp),%eax
  8004b9:	89 10                	mov    %edx,(%eax)
		}
		if (Elements[i] > (*max))
  8004bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004be:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c8:	01 d0                	add    %edx,%eax
  8004ca:	8b 10                	mov    (%eax),%edx
  8004cc:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8004cf:	8b 00                	mov    (%eax),%eax
  8004d1:	39 c2                	cmp    %eax,%edx
  8004d3:	7e 16                	jle    8004eb <ArrayStats+0xbd>
		{
			(*max) = Elements[i];
  8004d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004d8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004df:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e2:	01 d0                	add    %edx,%eax
  8004e4:	8b 10                	mov    (%eax),%edx
  8004e6:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8004e9:	89 10                	mov    %edx,(%eax)
{
	int i ;
	*mean =0 ;
	*min = 0x7FFFFFFF ;
	*max = 0x80000000 ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004eb:	ff 45 e4             	incl   -0x1c(%ebp)
  8004ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004f1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004f4:	0f 8c 6b ff ff ff    	jl     800465 <ArrayStats+0x37>
		{
			(*max) = Elements[i];
		}
	}

	(*med) = KthElement(Elements, NumOfElements, (NumOfElements+1)/2);
  8004fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004fd:	40                   	inc    %eax
  8004fe:	89 c2                	mov    %eax,%edx
  800500:	c1 ea 1f             	shr    $0x1f,%edx
  800503:	01 d0                	add    %edx,%eax
  800505:	d1 f8                	sar    %eax
  800507:	83 ec 04             	sub    $0x4,%esp
  80050a:	50                   	push   %eax
  80050b:	ff 75 0c             	pushl  0xc(%ebp)
  80050e:	ff 75 08             	pushl  0x8(%ebp)
  800511:	e8 7c fd ff ff       	call   800292 <KthElement>
  800516:	83 c4 10             	add    $0x10,%esp
  800519:	89 c2                	mov    %eax,%edx
  80051b:	8b 45 20             	mov    0x20(%ebp),%eax
  80051e:	89 10                	mov    %edx,(%eax)

	(*mean) /= NumOfElements;
  800520:	8b 45 10             	mov    0x10(%ebp),%eax
  800523:	8b 50 04             	mov    0x4(%eax),%edx
  800526:	8b 00                	mov    (%eax),%eax
  800528:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80052b:	89 cb                	mov    %ecx,%ebx
  80052d:	c1 fb 1f             	sar    $0x1f,%ebx
  800530:	53                   	push   %ebx
  800531:	51                   	push   %ecx
  800532:	52                   	push   %edx
  800533:	50                   	push   %eax
  800534:	e8 af 1d 00 00       	call   8022e8 <__divdi3>
  800539:	83 c4 10             	add    $0x10,%esp
  80053c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80053f:	89 01                	mov    %eax,(%ecx)
  800541:	89 51 04             	mov    %edx,0x4(%ecx)
	(*var) = 0;
  800544:	8b 45 14             	mov    0x14(%ebp),%eax
  800547:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80054d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	for (i = 0 ; i < NumOfElements ; i++)
  800554:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80055b:	eb 7e                	jmp    8005db <ArrayStats+0x1ad>
	{
		(*var) += (int64)((Elements[i] - (*mean))*(Elements[i] - (*mean)));
  80055d:	8b 45 14             	mov    0x14(%ebp),%eax
  800560:	8b 50 04             	mov    0x4(%eax),%edx
  800563:	8b 00                	mov    (%eax),%eax
  800565:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800568:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  80056b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80056e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800575:	8b 45 08             	mov    0x8(%ebp),%eax
  800578:	01 d0                	add    %edx,%eax
  80057a:	8b 00                	mov    (%eax),%eax
  80057c:	89 c1                	mov    %eax,%ecx
  80057e:	89 c3                	mov    %eax,%ebx
  800580:	c1 fb 1f             	sar    $0x1f,%ebx
  800583:	8b 45 10             	mov    0x10(%ebp),%eax
  800586:	8b 50 04             	mov    0x4(%eax),%edx
  800589:	8b 00                	mov    (%eax),%eax
  80058b:	29 c1                	sub    %eax,%ecx
  80058d:	19 d3                	sbb    %edx,%ebx
  80058f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800592:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800599:	8b 45 08             	mov    0x8(%ebp),%eax
  80059c:	01 d0                	add    %edx,%eax
  80059e:	8b 00                	mov    (%eax),%eax
  8005a0:	89 c6                	mov    %eax,%esi
  8005a2:	89 c7                	mov    %eax,%edi
  8005a4:	c1 ff 1f             	sar    $0x1f,%edi
  8005a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8005aa:	8b 50 04             	mov    0x4(%eax),%edx
  8005ad:	8b 00                	mov    (%eax),%eax
  8005af:	29 c6                	sub    %eax,%esi
  8005b1:	19 d7                	sbb    %edx,%edi
  8005b3:	89 f0                	mov    %esi,%eax
  8005b5:	89 fa                	mov    %edi,%edx
  8005b7:	89 df                	mov    %ebx,%edi
  8005b9:	0f af f8             	imul   %eax,%edi
  8005bc:	89 d6                	mov    %edx,%esi
  8005be:	0f af f1             	imul   %ecx,%esi
  8005c1:	01 fe                	add    %edi,%esi
  8005c3:	f7 e1                	mul    %ecx
  8005c5:	8d 0c 16             	lea    (%esi,%edx,1),%ecx
  8005c8:	89 ca                	mov    %ecx,%edx
  8005ca:	03 45 d0             	add    -0x30(%ebp),%eax
  8005cd:	13 55 d4             	adc    -0x2c(%ebp),%edx
  8005d0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8005d3:	89 01                	mov    %eax,(%ecx)
  8005d5:	89 51 04             	mov    %edx,0x4(%ecx)

	(*med) = KthElement(Elements, NumOfElements, (NumOfElements+1)/2);

	(*mean) /= NumOfElements;
	(*var) = 0;
	for (i = 0 ; i < NumOfElements ; i++)
  8005d8:	ff 45 e4             	incl   -0x1c(%ebp)
  8005db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005de:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8005e1:	0f 8c 76 ff ff ff    	jl     80055d <ArrayStats+0x12f>
	{
		(*var) += (int64)((Elements[i] - (*mean))*(Elements[i] - (*mean)));
	}
	(*var) /= NumOfElements;
  8005e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ea:	8b 50 04             	mov    0x4(%eax),%edx
  8005ed:	8b 00                	mov    (%eax),%eax
  8005ef:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005f2:	89 cb                	mov    %ecx,%ebx
  8005f4:	c1 fb 1f             	sar    $0x1f,%ebx
  8005f7:	53                   	push   %ebx
  8005f8:	51                   	push   %ecx
  8005f9:	52                   	push   %edx
  8005fa:	50                   	push   %eax
  8005fb:	e8 e8 1c 00 00       	call   8022e8 <__divdi3>
  800600:	83 c4 10             	add    $0x10,%esp
  800603:	8b 4d 14             	mov    0x14(%ebp),%ecx
  800606:	89 01                	mov    %eax,(%ecx)
  800608:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80060b:	90                   	nop
  80060c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80060f:	5b                   	pop    %ebx
  800610:	5e                   	pop    %esi
  800611:	5f                   	pop    %edi
  800612:	5d                   	pop    %ebp
  800613:	c3                   	ret    

00800614 <Swap>:

///Private Functions
void Swap(int *Elements, int First, int Second)
{
  800614:	55                   	push   %ebp
  800615:	89 e5                	mov    %esp,%ebp
  800617:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  80061a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80061d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800624:	8b 45 08             	mov    0x8(%ebp),%eax
  800627:	01 d0                	add    %edx,%eax
  800629:	8b 00                	mov    (%eax),%eax
  80062b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  80062e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800631:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800638:	8b 45 08             	mov    0x8(%ebp),%eax
  80063b:	01 c2                	add    %eax,%edx
  80063d:	8b 45 10             	mov    0x10(%ebp),%eax
  800640:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800647:	8b 45 08             	mov    0x8(%ebp),%eax
  80064a:	01 c8                	add    %ecx,%eax
  80064c:	8b 00                	mov    (%eax),%eax
  80064e:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800650:	8b 45 10             	mov    0x10(%ebp),%eax
  800653:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80065a:	8b 45 08             	mov    0x8(%ebp),%eax
  80065d:	01 c2                	add    %eax,%edx
  80065f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800662:	89 02                	mov    %eax,(%edx)
}
  800664:	90                   	nop
  800665:	c9                   	leave  
  800666:	c3                   	ret    

00800667 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800667:	55                   	push   %ebp
  800668:	89 e5                	mov    %esp,%ebp
  80066a:	57                   	push   %edi
  80066b:	56                   	push   %esi
  80066c:	53                   	push   %ebx
  80066d:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800670:	e8 06 16 00 00       	call   801c7b <sys_getenvindex>
  800675:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800678:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80067b:	89 d0                	mov    %edx,%eax
  80067d:	c1 e0 02             	shl    $0x2,%eax
  800680:	01 d0                	add    %edx,%eax
  800682:	c1 e0 03             	shl    $0x3,%eax
  800685:	01 d0                	add    %edx,%eax
  800687:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80068e:	01 d0                	add    %edx,%eax
  800690:	c1 e0 02             	shl    $0x2,%eax
  800693:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800698:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80069d:	a1 20 40 80 00       	mov    0x804020,%eax
  8006a2:	8a 40 20             	mov    0x20(%eax),%al
  8006a5:	84 c0                	test   %al,%al
  8006a7:	74 0d                	je     8006b6 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8006a9:	a1 20 40 80 00       	mov    0x804020,%eax
  8006ae:	83 c0 20             	add    $0x20,%eax
  8006b1:	a3 04 40 80 00       	mov    %eax,0x804004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8006b6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8006ba:	7e 0a                	jle    8006c6 <libmain+0x5f>
		binaryname = argv[0];
  8006bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006bf:	8b 00                	mov    (%eax),%eax
  8006c1:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	_main(argc, argv);
  8006c6:	83 ec 08             	sub    $0x8,%esp
  8006c9:	ff 75 0c             	pushl  0xc(%ebp)
  8006cc:	ff 75 08             	pushl  0x8(%ebp)
  8006cf:	e8 64 f9 ff ff       	call   800038 <_main>
  8006d4:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8006d7:	a1 00 40 80 00       	mov    0x804000,%eax
  8006dc:	85 c0                	test   %eax,%eax
  8006de:	0f 84 01 01 00 00    	je     8007e5 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8006e4:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8006ea:	bb 88 28 80 00       	mov    $0x802888,%ebx
  8006ef:	ba 0e 00 00 00       	mov    $0xe,%edx
  8006f4:	89 c7                	mov    %eax,%edi
  8006f6:	89 de                	mov    %ebx,%esi
  8006f8:	89 d1                	mov    %edx,%ecx
  8006fa:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8006fc:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8006ff:	b9 56 00 00 00       	mov    $0x56,%ecx
  800704:	b0 00                	mov    $0x0,%al
  800706:	89 d7                	mov    %edx,%edi
  800708:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80070a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800711:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800714:	83 ec 08             	sub    $0x8,%esp
  800717:	50                   	push   %eax
  800718:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80071e:	50                   	push   %eax
  80071f:	e8 8d 17 00 00       	call   801eb1 <sys_utilities>
  800724:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800727:	e8 d6 12 00 00       	call   801a02 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80072c:	83 ec 0c             	sub    $0xc,%esp
  80072f:	68 a8 27 80 00       	push   $0x8027a8
  800734:	e8 be 01 00 00       	call   8008f7 <cprintf>
  800739:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80073c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80073f:	85 c0                	test   %eax,%eax
  800741:	74 18                	je     80075b <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800743:	e8 87 17 00 00       	call   801ecf <sys_get_optimal_num_faults>
  800748:	83 ec 08             	sub    $0x8,%esp
  80074b:	50                   	push   %eax
  80074c:	68 d0 27 80 00       	push   $0x8027d0
  800751:	e8 a1 01 00 00       	call   8008f7 <cprintf>
  800756:	83 c4 10             	add    $0x10,%esp
  800759:	eb 59                	jmp    8007b4 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80075b:	a1 20 40 80 00       	mov    0x804020,%eax
  800760:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  800766:	a1 20 40 80 00       	mov    0x804020,%eax
  80076b:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  800771:	83 ec 04             	sub    $0x4,%esp
  800774:	52                   	push   %edx
  800775:	50                   	push   %eax
  800776:	68 f4 27 80 00       	push   $0x8027f4
  80077b:	e8 77 01 00 00       	call   8008f7 <cprintf>
  800780:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800783:	a1 20 40 80 00       	mov    0x804020,%eax
  800788:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  80078e:	a1 20 40 80 00       	mov    0x804020,%eax
  800793:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  800799:	a1 20 40 80 00       	mov    0x804020,%eax
  80079e:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  8007a4:	51                   	push   %ecx
  8007a5:	52                   	push   %edx
  8007a6:	50                   	push   %eax
  8007a7:	68 1c 28 80 00       	push   $0x80281c
  8007ac:	e8 46 01 00 00       	call   8008f7 <cprintf>
  8007b1:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8007b4:	a1 20 40 80 00       	mov    0x804020,%eax
  8007b9:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  8007bf:	83 ec 08             	sub    $0x8,%esp
  8007c2:	50                   	push   %eax
  8007c3:	68 74 28 80 00       	push   $0x802874
  8007c8:	e8 2a 01 00 00       	call   8008f7 <cprintf>
  8007cd:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8007d0:	83 ec 0c             	sub    $0xc,%esp
  8007d3:	68 a8 27 80 00       	push   $0x8027a8
  8007d8:	e8 1a 01 00 00       	call   8008f7 <cprintf>
  8007dd:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8007e0:	e8 37 12 00 00       	call   801a1c <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8007e5:	e8 1f 00 00 00       	call   800809 <exit>
}
  8007ea:	90                   	nop
  8007eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007ee:	5b                   	pop    %ebx
  8007ef:	5e                   	pop    %esi
  8007f0:	5f                   	pop    %edi
  8007f1:	5d                   	pop    %ebp
  8007f2:	c3                   	ret    

008007f3 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8007f3:	55                   	push   %ebp
  8007f4:	89 e5                	mov    %esp,%ebp
  8007f6:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8007f9:	83 ec 0c             	sub    $0xc,%esp
  8007fc:	6a 00                	push   $0x0
  8007fe:	e8 44 14 00 00       	call   801c47 <sys_destroy_env>
  800803:	83 c4 10             	add    $0x10,%esp
}
  800806:	90                   	nop
  800807:	c9                   	leave  
  800808:	c3                   	ret    

00800809 <exit>:

void
exit(void)
{
  800809:	55                   	push   %ebp
  80080a:	89 e5                	mov    %esp,%ebp
  80080c:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80080f:	e8 99 14 00 00       	call   801cad <sys_exit_env>
}
  800814:	90                   	nop
  800815:	c9                   	leave  
  800816:	c3                   	ret    

00800817 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800817:	55                   	push   %ebp
  800818:	89 e5                	mov    %esp,%ebp
  80081a:	53                   	push   %ebx
  80081b:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  80081e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800821:	8b 00                	mov    (%eax),%eax
  800823:	8d 48 01             	lea    0x1(%eax),%ecx
  800826:	8b 55 0c             	mov    0xc(%ebp),%edx
  800829:	89 0a                	mov    %ecx,(%edx)
  80082b:	8b 55 08             	mov    0x8(%ebp),%edx
  80082e:	88 d1                	mov    %dl,%cl
  800830:	8b 55 0c             	mov    0xc(%ebp),%edx
  800833:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800837:	8b 45 0c             	mov    0xc(%ebp),%eax
  80083a:	8b 00                	mov    (%eax),%eax
  80083c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800841:	75 30                	jne    800873 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800843:	8b 15 18 c1 81 00    	mov    0x81c118,%edx
  800849:	a0 44 40 80 00       	mov    0x804044,%al
  80084e:	0f b6 c0             	movzbl %al,%eax
  800851:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800854:	8b 09                	mov    (%ecx),%ecx
  800856:	89 cb                	mov    %ecx,%ebx
  800858:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80085b:	83 c1 08             	add    $0x8,%ecx
  80085e:	52                   	push   %edx
  80085f:	50                   	push   %eax
  800860:	53                   	push   %ebx
  800861:	51                   	push   %ecx
  800862:	e8 57 11 00 00       	call   8019be <sys_cputs>
  800867:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80086a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80086d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800873:	8b 45 0c             	mov    0xc(%ebp),%eax
  800876:	8b 40 04             	mov    0x4(%eax),%eax
  800879:	8d 50 01             	lea    0x1(%eax),%edx
  80087c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80087f:	89 50 04             	mov    %edx,0x4(%eax)
}
  800882:	90                   	nop
  800883:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800886:	c9                   	leave  
  800887:	c3                   	ret    

00800888 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800888:	55                   	push   %ebp
  800889:	89 e5                	mov    %esp,%ebp
  80088b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800891:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800898:	00 00 00 
	b.cnt = 0;
  80089b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8008a2:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8008a5:	ff 75 0c             	pushl  0xc(%ebp)
  8008a8:	ff 75 08             	pushl  0x8(%ebp)
  8008ab:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8008b1:	50                   	push   %eax
  8008b2:	68 17 08 80 00       	push   $0x800817
  8008b7:	e8 5a 02 00 00       	call   800b16 <vprintfmt>
  8008bc:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8008bf:	8b 15 18 c1 81 00    	mov    0x81c118,%edx
  8008c5:	a0 44 40 80 00       	mov    0x804044,%al
  8008ca:	0f b6 c0             	movzbl %al,%eax
  8008cd:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8008d3:	52                   	push   %edx
  8008d4:	50                   	push   %eax
  8008d5:	51                   	push   %ecx
  8008d6:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8008dc:	83 c0 08             	add    $0x8,%eax
  8008df:	50                   	push   %eax
  8008e0:	e8 d9 10 00 00       	call   8019be <sys_cputs>
  8008e5:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8008e8:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
	return b.cnt;
  8008ef:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8008f5:	c9                   	leave  
  8008f6:	c3                   	ret    

008008f7 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8008f7:	55                   	push   %ebp
  8008f8:	89 e5                	mov    %esp,%ebp
  8008fa:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8008fd:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	va_start(ap, fmt);
  800904:	8d 45 0c             	lea    0xc(%ebp),%eax
  800907:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80090a:	8b 45 08             	mov    0x8(%ebp),%eax
  80090d:	83 ec 08             	sub    $0x8,%esp
  800910:	ff 75 f4             	pushl  -0xc(%ebp)
  800913:	50                   	push   %eax
  800914:	e8 6f ff ff ff       	call   800888 <vcprintf>
  800919:	83 c4 10             	add    $0x10,%esp
  80091c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80091f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800922:	c9                   	leave  
  800923:	c3                   	ret    

00800924 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800924:	55                   	push   %ebp
  800925:	89 e5                	mov    %esp,%ebp
  800927:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80092a:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800931:	8b 45 08             	mov    0x8(%ebp),%eax
  800934:	c1 e0 08             	shl    $0x8,%eax
  800937:	a3 18 c1 81 00       	mov    %eax,0x81c118
	va_start(ap, fmt);
  80093c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80093f:	83 c0 04             	add    $0x4,%eax
  800942:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800945:	8b 45 0c             	mov    0xc(%ebp),%eax
  800948:	83 ec 08             	sub    $0x8,%esp
  80094b:	ff 75 f4             	pushl  -0xc(%ebp)
  80094e:	50                   	push   %eax
  80094f:	e8 34 ff ff ff       	call   800888 <vcprintf>
  800954:	83 c4 10             	add    $0x10,%esp
  800957:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  80095a:	c7 05 18 c1 81 00 00 	movl   $0x700,0x81c118
  800961:	07 00 00 

	return cnt;
  800964:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800967:	c9                   	leave  
  800968:	c3                   	ret    

00800969 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800969:	55                   	push   %ebp
  80096a:	89 e5                	mov    %esp,%ebp
  80096c:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80096f:	e8 8e 10 00 00       	call   801a02 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800974:	8d 45 0c             	lea    0xc(%ebp),%eax
  800977:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80097a:	8b 45 08             	mov    0x8(%ebp),%eax
  80097d:	83 ec 08             	sub    $0x8,%esp
  800980:	ff 75 f4             	pushl  -0xc(%ebp)
  800983:	50                   	push   %eax
  800984:	e8 ff fe ff ff       	call   800888 <vcprintf>
  800989:	83 c4 10             	add    $0x10,%esp
  80098c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80098f:	e8 88 10 00 00       	call   801a1c <sys_unlock_cons>
	return cnt;
  800994:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800997:	c9                   	leave  
  800998:	c3                   	ret    

00800999 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800999:	55                   	push   %ebp
  80099a:	89 e5                	mov    %esp,%ebp
  80099c:	53                   	push   %ebx
  80099d:	83 ec 14             	sub    $0x14,%esp
  8009a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8009a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8009ac:	8b 45 18             	mov    0x18(%ebp),%eax
  8009af:	ba 00 00 00 00       	mov    $0x0,%edx
  8009b4:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8009b7:	77 55                	ja     800a0e <printnum+0x75>
  8009b9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8009bc:	72 05                	jb     8009c3 <printnum+0x2a>
  8009be:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8009c1:	77 4b                	ja     800a0e <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8009c3:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8009c6:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8009c9:	8b 45 18             	mov    0x18(%ebp),%eax
  8009cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8009d1:	52                   	push   %edx
  8009d2:	50                   	push   %eax
  8009d3:	ff 75 f4             	pushl  -0xc(%ebp)
  8009d6:	ff 75 f0             	pushl  -0x10(%ebp)
  8009d9:	e8 72 1a 00 00       	call   802450 <__udivdi3>
  8009de:	83 c4 10             	add    $0x10,%esp
  8009e1:	83 ec 04             	sub    $0x4,%esp
  8009e4:	ff 75 20             	pushl  0x20(%ebp)
  8009e7:	53                   	push   %ebx
  8009e8:	ff 75 18             	pushl  0x18(%ebp)
  8009eb:	52                   	push   %edx
  8009ec:	50                   	push   %eax
  8009ed:	ff 75 0c             	pushl  0xc(%ebp)
  8009f0:	ff 75 08             	pushl  0x8(%ebp)
  8009f3:	e8 a1 ff ff ff       	call   800999 <printnum>
  8009f8:	83 c4 20             	add    $0x20,%esp
  8009fb:	eb 1a                	jmp    800a17 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8009fd:	83 ec 08             	sub    $0x8,%esp
  800a00:	ff 75 0c             	pushl  0xc(%ebp)
  800a03:	ff 75 20             	pushl  0x20(%ebp)
  800a06:	8b 45 08             	mov    0x8(%ebp),%eax
  800a09:	ff d0                	call   *%eax
  800a0b:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800a0e:	ff 4d 1c             	decl   0x1c(%ebp)
  800a11:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800a15:	7f e6                	jg     8009fd <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800a17:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800a1a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a22:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a25:	53                   	push   %ebx
  800a26:	51                   	push   %ecx
  800a27:	52                   	push   %edx
  800a28:	50                   	push   %eax
  800a29:	e8 32 1b 00 00       	call   802560 <__umoddi3>
  800a2e:	83 c4 10             	add    $0x10,%esp
  800a31:	05 14 2b 80 00       	add    $0x802b14,%eax
  800a36:	8a 00                	mov    (%eax),%al
  800a38:	0f be c0             	movsbl %al,%eax
  800a3b:	83 ec 08             	sub    $0x8,%esp
  800a3e:	ff 75 0c             	pushl  0xc(%ebp)
  800a41:	50                   	push   %eax
  800a42:	8b 45 08             	mov    0x8(%ebp),%eax
  800a45:	ff d0                	call   *%eax
  800a47:	83 c4 10             	add    $0x10,%esp
}
  800a4a:	90                   	nop
  800a4b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a4e:	c9                   	leave  
  800a4f:	c3                   	ret    

00800a50 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800a50:	55                   	push   %ebp
  800a51:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800a53:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800a57:	7e 1c                	jle    800a75 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800a59:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5c:	8b 00                	mov    (%eax),%eax
  800a5e:	8d 50 08             	lea    0x8(%eax),%edx
  800a61:	8b 45 08             	mov    0x8(%ebp),%eax
  800a64:	89 10                	mov    %edx,(%eax)
  800a66:	8b 45 08             	mov    0x8(%ebp),%eax
  800a69:	8b 00                	mov    (%eax),%eax
  800a6b:	83 e8 08             	sub    $0x8,%eax
  800a6e:	8b 50 04             	mov    0x4(%eax),%edx
  800a71:	8b 00                	mov    (%eax),%eax
  800a73:	eb 40                	jmp    800ab5 <getuint+0x65>
	else if (lflag)
  800a75:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a79:	74 1e                	je     800a99 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7e:	8b 00                	mov    (%eax),%eax
  800a80:	8d 50 04             	lea    0x4(%eax),%edx
  800a83:	8b 45 08             	mov    0x8(%ebp),%eax
  800a86:	89 10                	mov    %edx,(%eax)
  800a88:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8b:	8b 00                	mov    (%eax),%eax
  800a8d:	83 e8 04             	sub    $0x4,%eax
  800a90:	8b 00                	mov    (%eax),%eax
  800a92:	ba 00 00 00 00       	mov    $0x0,%edx
  800a97:	eb 1c                	jmp    800ab5 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800a99:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9c:	8b 00                	mov    (%eax),%eax
  800a9e:	8d 50 04             	lea    0x4(%eax),%edx
  800aa1:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa4:	89 10                	mov    %edx,(%eax)
  800aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa9:	8b 00                	mov    (%eax),%eax
  800aab:	83 e8 04             	sub    $0x4,%eax
  800aae:	8b 00                	mov    (%eax),%eax
  800ab0:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800ab5:	5d                   	pop    %ebp
  800ab6:	c3                   	ret    

00800ab7 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800ab7:	55                   	push   %ebp
  800ab8:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800aba:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800abe:	7e 1c                	jle    800adc <getint+0x25>
		return va_arg(*ap, long long);
  800ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac3:	8b 00                	mov    (%eax),%eax
  800ac5:	8d 50 08             	lea    0x8(%eax),%edx
  800ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  800acb:	89 10                	mov    %edx,(%eax)
  800acd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad0:	8b 00                	mov    (%eax),%eax
  800ad2:	83 e8 08             	sub    $0x8,%eax
  800ad5:	8b 50 04             	mov    0x4(%eax),%edx
  800ad8:	8b 00                	mov    (%eax),%eax
  800ada:	eb 38                	jmp    800b14 <getint+0x5d>
	else if (lflag)
  800adc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ae0:	74 1a                	je     800afc <getint+0x45>
		return va_arg(*ap, long);
  800ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae5:	8b 00                	mov    (%eax),%eax
  800ae7:	8d 50 04             	lea    0x4(%eax),%edx
  800aea:	8b 45 08             	mov    0x8(%ebp),%eax
  800aed:	89 10                	mov    %edx,(%eax)
  800aef:	8b 45 08             	mov    0x8(%ebp),%eax
  800af2:	8b 00                	mov    (%eax),%eax
  800af4:	83 e8 04             	sub    $0x4,%eax
  800af7:	8b 00                	mov    (%eax),%eax
  800af9:	99                   	cltd   
  800afa:	eb 18                	jmp    800b14 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800afc:	8b 45 08             	mov    0x8(%ebp),%eax
  800aff:	8b 00                	mov    (%eax),%eax
  800b01:	8d 50 04             	lea    0x4(%eax),%edx
  800b04:	8b 45 08             	mov    0x8(%ebp),%eax
  800b07:	89 10                	mov    %edx,(%eax)
  800b09:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0c:	8b 00                	mov    (%eax),%eax
  800b0e:	83 e8 04             	sub    $0x4,%eax
  800b11:	8b 00                	mov    (%eax),%eax
  800b13:	99                   	cltd   
}
  800b14:	5d                   	pop    %ebp
  800b15:	c3                   	ret    

00800b16 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800b16:	55                   	push   %ebp
  800b17:	89 e5                	mov    %esp,%ebp
  800b19:	56                   	push   %esi
  800b1a:	53                   	push   %ebx
  800b1b:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b1e:	eb 17                	jmp    800b37 <vprintfmt+0x21>
			if (ch == '\0')
  800b20:	85 db                	test   %ebx,%ebx
  800b22:	0f 84 c1 03 00 00    	je     800ee9 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800b28:	83 ec 08             	sub    $0x8,%esp
  800b2b:	ff 75 0c             	pushl  0xc(%ebp)
  800b2e:	53                   	push   %ebx
  800b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b32:	ff d0                	call   *%eax
  800b34:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b37:	8b 45 10             	mov    0x10(%ebp),%eax
  800b3a:	8d 50 01             	lea    0x1(%eax),%edx
  800b3d:	89 55 10             	mov    %edx,0x10(%ebp)
  800b40:	8a 00                	mov    (%eax),%al
  800b42:	0f b6 d8             	movzbl %al,%ebx
  800b45:	83 fb 25             	cmp    $0x25,%ebx
  800b48:	75 d6                	jne    800b20 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800b4a:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800b4e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800b55:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800b5c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800b63:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b6a:	8b 45 10             	mov    0x10(%ebp),%eax
  800b6d:	8d 50 01             	lea    0x1(%eax),%edx
  800b70:	89 55 10             	mov    %edx,0x10(%ebp)
  800b73:	8a 00                	mov    (%eax),%al
  800b75:	0f b6 d8             	movzbl %al,%ebx
  800b78:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800b7b:	83 f8 5b             	cmp    $0x5b,%eax
  800b7e:	0f 87 3d 03 00 00    	ja     800ec1 <vprintfmt+0x3ab>
  800b84:	8b 04 85 38 2b 80 00 	mov    0x802b38(,%eax,4),%eax
  800b8b:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800b8d:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800b91:	eb d7                	jmp    800b6a <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800b93:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800b97:	eb d1                	jmp    800b6a <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800b99:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800ba0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800ba3:	89 d0                	mov    %edx,%eax
  800ba5:	c1 e0 02             	shl    $0x2,%eax
  800ba8:	01 d0                	add    %edx,%eax
  800baa:	01 c0                	add    %eax,%eax
  800bac:	01 d8                	add    %ebx,%eax
  800bae:	83 e8 30             	sub    $0x30,%eax
  800bb1:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800bb4:	8b 45 10             	mov    0x10(%ebp),%eax
  800bb7:	8a 00                	mov    (%eax),%al
  800bb9:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800bbc:	83 fb 2f             	cmp    $0x2f,%ebx
  800bbf:	7e 3e                	jle    800bff <vprintfmt+0xe9>
  800bc1:	83 fb 39             	cmp    $0x39,%ebx
  800bc4:	7f 39                	jg     800bff <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bc6:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800bc9:	eb d5                	jmp    800ba0 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800bcb:	8b 45 14             	mov    0x14(%ebp),%eax
  800bce:	83 c0 04             	add    $0x4,%eax
  800bd1:	89 45 14             	mov    %eax,0x14(%ebp)
  800bd4:	8b 45 14             	mov    0x14(%ebp),%eax
  800bd7:	83 e8 04             	sub    $0x4,%eax
  800bda:	8b 00                	mov    (%eax),%eax
  800bdc:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800bdf:	eb 1f                	jmp    800c00 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800be1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800be5:	79 83                	jns    800b6a <vprintfmt+0x54>
				width = 0;
  800be7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800bee:	e9 77 ff ff ff       	jmp    800b6a <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800bf3:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800bfa:	e9 6b ff ff ff       	jmp    800b6a <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800bff:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c00:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c04:	0f 89 60 ff ff ff    	jns    800b6a <vprintfmt+0x54>
				width = precision, precision = -1;
  800c0a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c0d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c10:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800c17:	e9 4e ff ff ff       	jmp    800b6a <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c1c:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800c1f:	e9 46 ff ff ff       	jmp    800b6a <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800c24:	8b 45 14             	mov    0x14(%ebp),%eax
  800c27:	83 c0 04             	add    $0x4,%eax
  800c2a:	89 45 14             	mov    %eax,0x14(%ebp)
  800c2d:	8b 45 14             	mov    0x14(%ebp),%eax
  800c30:	83 e8 04             	sub    $0x4,%eax
  800c33:	8b 00                	mov    (%eax),%eax
  800c35:	83 ec 08             	sub    $0x8,%esp
  800c38:	ff 75 0c             	pushl  0xc(%ebp)
  800c3b:	50                   	push   %eax
  800c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3f:	ff d0                	call   *%eax
  800c41:	83 c4 10             	add    $0x10,%esp
			break;
  800c44:	e9 9b 02 00 00       	jmp    800ee4 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800c49:	8b 45 14             	mov    0x14(%ebp),%eax
  800c4c:	83 c0 04             	add    $0x4,%eax
  800c4f:	89 45 14             	mov    %eax,0x14(%ebp)
  800c52:	8b 45 14             	mov    0x14(%ebp),%eax
  800c55:	83 e8 04             	sub    $0x4,%eax
  800c58:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800c5a:	85 db                	test   %ebx,%ebx
  800c5c:	79 02                	jns    800c60 <vprintfmt+0x14a>
				err = -err;
  800c5e:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800c60:	83 fb 64             	cmp    $0x64,%ebx
  800c63:	7f 0b                	jg     800c70 <vprintfmt+0x15a>
  800c65:	8b 34 9d 80 29 80 00 	mov    0x802980(,%ebx,4),%esi
  800c6c:	85 f6                	test   %esi,%esi
  800c6e:	75 19                	jne    800c89 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800c70:	53                   	push   %ebx
  800c71:	68 25 2b 80 00       	push   $0x802b25
  800c76:	ff 75 0c             	pushl  0xc(%ebp)
  800c79:	ff 75 08             	pushl  0x8(%ebp)
  800c7c:	e8 70 02 00 00       	call   800ef1 <printfmt>
  800c81:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800c84:	e9 5b 02 00 00       	jmp    800ee4 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800c89:	56                   	push   %esi
  800c8a:	68 2e 2b 80 00       	push   $0x802b2e
  800c8f:	ff 75 0c             	pushl  0xc(%ebp)
  800c92:	ff 75 08             	pushl  0x8(%ebp)
  800c95:	e8 57 02 00 00       	call   800ef1 <printfmt>
  800c9a:	83 c4 10             	add    $0x10,%esp
			break;
  800c9d:	e9 42 02 00 00       	jmp    800ee4 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ca2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ca5:	83 c0 04             	add    $0x4,%eax
  800ca8:	89 45 14             	mov    %eax,0x14(%ebp)
  800cab:	8b 45 14             	mov    0x14(%ebp),%eax
  800cae:	83 e8 04             	sub    $0x4,%eax
  800cb1:	8b 30                	mov    (%eax),%esi
  800cb3:	85 f6                	test   %esi,%esi
  800cb5:	75 05                	jne    800cbc <vprintfmt+0x1a6>
				p = "(null)";
  800cb7:	be 31 2b 80 00       	mov    $0x802b31,%esi
			if (width > 0 && padc != '-')
  800cbc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cc0:	7e 6d                	jle    800d2f <vprintfmt+0x219>
  800cc2:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800cc6:	74 67                	je     800d2f <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800cc8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ccb:	83 ec 08             	sub    $0x8,%esp
  800cce:	50                   	push   %eax
  800ccf:	56                   	push   %esi
  800cd0:	e8 1e 03 00 00       	call   800ff3 <strnlen>
  800cd5:	83 c4 10             	add    $0x10,%esp
  800cd8:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800cdb:	eb 16                	jmp    800cf3 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800cdd:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800ce1:	83 ec 08             	sub    $0x8,%esp
  800ce4:	ff 75 0c             	pushl  0xc(%ebp)
  800ce7:	50                   	push   %eax
  800ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ceb:	ff d0                	call   *%eax
  800ced:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800cf0:	ff 4d e4             	decl   -0x1c(%ebp)
  800cf3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cf7:	7f e4                	jg     800cdd <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800cf9:	eb 34                	jmp    800d2f <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800cfb:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800cff:	74 1c                	je     800d1d <vprintfmt+0x207>
  800d01:	83 fb 1f             	cmp    $0x1f,%ebx
  800d04:	7e 05                	jle    800d0b <vprintfmt+0x1f5>
  800d06:	83 fb 7e             	cmp    $0x7e,%ebx
  800d09:	7e 12                	jle    800d1d <vprintfmt+0x207>
					putch('?', putdat);
  800d0b:	83 ec 08             	sub    $0x8,%esp
  800d0e:	ff 75 0c             	pushl  0xc(%ebp)
  800d11:	6a 3f                	push   $0x3f
  800d13:	8b 45 08             	mov    0x8(%ebp),%eax
  800d16:	ff d0                	call   *%eax
  800d18:	83 c4 10             	add    $0x10,%esp
  800d1b:	eb 0f                	jmp    800d2c <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800d1d:	83 ec 08             	sub    $0x8,%esp
  800d20:	ff 75 0c             	pushl  0xc(%ebp)
  800d23:	53                   	push   %ebx
  800d24:	8b 45 08             	mov    0x8(%ebp),%eax
  800d27:	ff d0                	call   *%eax
  800d29:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d2c:	ff 4d e4             	decl   -0x1c(%ebp)
  800d2f:	89 f0                	mov    %esi,%eax
  800d31:	8d 70 01             	lea    0x1(%eax),%esi
  800d34:	8a 00                	mov    (%eax),%al
  800d36:	0f be d8             	movsbl %al,%ebx
  800d39:	85 db                	test   %ebx,%ebx
  800d3b:	74 24                	je     800d61 <vprintfmt+0x24b>
  800d3d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d41:	78 b8                	js     800cfb <vprintfmt+0x1e5>
  800d43:	ff 4d e0             	decl   -0x20(%ebp)
  800d46:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d4a:	79 af                	jns    800cfb <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d4c:	eb 13                	jmp    800d61 <vprintfmt+0x24b>
				putch(' ', putdat);
  800d4e:	83 ec 08             	sub    $0x8,%esp
  800d51:	ff 75 0c             	pushl  0xc(%ebp)
  800d54:	6a 20                	push   $0x20
  800d56:	8b 45 08             	mov    0x8(%ebp),%eax
  800d59:	ff d0                	call   *%eax
  800d5b:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d5e:	ff 4d e4             	decl   -0x1c(%ebp)
  800d61:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d65:	7f e7                	jg     800d4e <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800d67:	e9 78 01 00 00       	jmp    800ee4 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800d6c:	83 ec 08             	sub    $0x8,%esp
  800d6f:	ff 75 e8             	pushl  -0x18(%ebp)
  800d72:	8d 45 14             	lea    0x14(%ebp),%eax
  800d75:	50                   	push   %eax
  800d76:	e8 3c fd ff ff       	call   800ab7 <getint>
  800d7b:	83 c4 10             	add    $0x10,%esp
  800d7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d81:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800d84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d87:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d8a:	85 d2                	test   %edx,%edx
  800d8c:	79 23                	jns    800db1 <vprintfmt+0x29b>
				putch('-', putdat);
  800d8e:	83 ec 08             	sub    $0x8,%esp
  800d91:	ff 75 0c             	pushl  0xc(%ebp)
  800d94:	6a 2d                	push   $0x2d
  800d96:	8b 45 08             	mov    0x8(%ebp),%eax
  800d99:	ff d0                	call   *%eax
  800d9b:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800d9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800da1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800da4:	f7 d8                	neg    %eax
  800da6:	83 d2 00             	adc    $0x0,%edx
  800da9:	f7 da                	neg    %edx
  800dab:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dae:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800db1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800db8:	e9 bc 00 00 00       	jmp    800e79 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800dbd:	83 ec 08             	sub    $0x8,%esp
  800dc0:	ff 75 e8             	pushl  -0x18(%ebp)
  800dc3:	8d 45 14             	lea    0x14(%ebp),%eax
  800dc6:	50                   	push   %eax
  800dc7:	e8 84 fc ff ff       	call   800a50 <getuint>
  800dcc:	83 c4 10             	add    $0x10,%esp
  800dcf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dd2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800dd5:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ddc:	e9 98 00 00 00       	jmp    800e79 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800de1:	83 ec 08             	sub    $0x8,%esp
  800de4:	ff 75 0c             	pushl  0xc(%ebp)
  800de7:	6a 58                	push   $0x58
  800de9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dec:	ff d0                	call   *%eax
  800dee:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800df1:	83 ec 08             	sub    $0x8,%esp
  800df4:	ff 75 0c             	pushl  0xc(%ebp)
  800df7:	6a 58                	push   $0x58
  800df9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfc:	ff d0                	call   *%eax
  800dfe:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e01:	83 ec 08             	sub    $0x8,%esp
  800e04:	ff 75 0c             	pushl  0xc(%ebp)
  800e07:	6a 58                	push   $0x58
  800e09:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0c:	ff d0                	call   *%eax
  800e0e:	83 c4 10             	add    $0x10,%esp
			break;
  800e11:	e9 ce 00 00 00       	jmp    800ee4 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800e16:	83 ec 08             	sub    $0x8,%esp
  800e19:	ff 75 0c             	pushl  0xc(%ebp)
  800e1c:	6a 30                	push   $0x30
  800e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e21:	ff d0                	call   *%eax
  800e23:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800e26:	83 ec 08             	sub    $0x8,%esp
  800e29:	ff 75 0c             	pushl  0xc(%ebp)
  800e2c:	6a 78                	push   $0x78
  800e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e31:	ff d0                	call   *%eax
  800e33:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800e36:	8b 45 14             	mov    0x14(%ebp),%eax
  800e39:	83 c0 04             	add    $0x4,%eax
  800e3c:	89 45 14             	mov    %eax,0x14(%ebp)
  800e3f:	8b 45 14             	mov    0x14(%ebp),%eax
  800e42:	83 e8 04             	sub    $0x4,%eax
  800e45:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e47:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e4a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800e51:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800e58:	eb 1f                	jmp    800e79 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800e5a:	83 ec 08             	sub    $0x8,%esp
  800e5d:	ff 75 e8             	pushl  -0x18(%ebp)
  800e60:	8d 45 14             	lea    0x14(%ebp),%eax
  800e63:	50                   	push   %eax
  800e64:	e8 e7 fb ff ff       	call   800a50 <getuint>
  800e69:	83 c4 10             	add    $0x10,%esp
  800e6c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e6f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800e72:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800e79:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800e7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e80:	83 ec 04             	sub    $0x4,%esp
  800e83:	52                   	push   %edx
  800e84:	ff 75 e4             	pushl  -0x1c(%ebp)
  800e87:	50                   	push   %eax
  800e88:	ff 75 f4             	pushl  -0xc(%ebp)
  800e8b:	ff 75 f0             	pushl  -0x10(%ebp)
  800e8e:	ff 75 0c             	pushl  0xc(%ebp)
  800e91:	ff 75 08             	pushl  0x8(%ebp)
  800e94:	e8 00 fb ff ff       	call   800999 <printnum>
  800e99:	83 c4 20             	add    $0x20,%esp
			break;
  800e9c:	eb 46                	jmp    800ee4 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800e9e:	83 ec 08             	sub    $0x8,%esp
  800ea1:	ff 75 0c             	pushl  0xc(%ebp)
  800ea4:	53                   	push   %ebx
  800ea5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea8:	ff d0                	call   *%eax
  800eaa:	83 c4 10             	add    $0x10,%esp
			break;
  800ead:	eb 35                	jmp    800ee4 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800eaf:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
			break;
  800eb6:	eb 2c                	jmp    800ee4 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800eb8:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
			break;
  800ebf:	eb 23                	jmp    800ee4 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ec1:	83 ec 08             	sub    $0x8,%esp
  800ec4:	ff 75 0c             	pushl  0xc(%ebp)
  800ec7:	6a 25                	push   $0x25
  800ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecc:	ff d0                	call   *%eax
  800ece:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ed1:	ff 4d 10             	decl   0x10(%ebp)
  800ed4:	eb 03                	jmp    800ed9 <vprintfmt+0x3c3>
  800ed6:	ff 4d 10             	decl   0x10(%ebp)
  800ed9:	8b 45 10             	mov    0x10(%ebp),%eax
  800edc:	48                   	dec    %eax
  800edd:	8a 00                	mov    (%eax),%al
  800edf:	3c 25                	cmp    $0x25,%al
  800ee1:	75 f3                	jne    800ed6 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800ee3:	90                   	nop
		}
	}
  800ee4:	e9 35 fc ff ff       	jmp    800b1e <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ee9:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800eea:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800eed:	5b                   	pop    %ebx
  800eee:	5e                   	pop    %esi
  800eef:	5d                   	pop    %ebp
  800ef0:	c3                   	ret    

00800ef1 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ef1:	55                   	push   %ebp
  800ef2:	89 e5                	mov    %esp,%ebp
  800ef4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ef7:	8d 45 10             	lea    0x10(%ebp),%eax
  800efa:	83 c0 04             	add    $0x4,%eax
  800efd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800f00:	8b 45 10             	mov    0x10(%ebp),%eax
  800f03:	ff 75 f4             	pushl  -0xc(%ebp)
  800f06:	50                   	push   %eax
  800f07:	ff 75 0c             	pushl  0xc(%ebp)
  800f0a:	ff 75 08             	pushl  0x8(%ebp)
  800f0d:	e8 04 fc ff ff       	call   800b16 <vprintfmt>
  800f12:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800f15:	90                   	nop
  800f16:	c9                   	leave  
  800f17:	c3                   	ret    

00800f18 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f18:	55                   	push   %ebp
  800f19:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800f1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f1e:	8b 40 08             	mov    0x8(%eax),%eax
  800f21:	8d 50 01             	lea    0x1(%eax),%edx
  800f24:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f27:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800f2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2d:	8b 10                	mov    (%eax),%edx
  800f2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f32:	8b 40 04             	mov    0x4(%eax),%eax
  800f35:	39 c2                	cmp    %eax,%edx
  800f37:	73 12                	jae    800f4b <sprintputch+0x33>
		*b->buf++ = ch;
  800f39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f3c:	8b 00                	mov    (%eax),%eax
  800f3e:	8d 48 01             	lea    0x1(%eax),%ecx
  800f41:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f44:	89 0a                	mov    %ecx,(%edx)
  800f46:	8b 55 08             	mov    0x8(%ebp),%edx
  800f49:	88 10                	mov    %dl,(%eax)
}
  800f4b:	90                   	nop
  800f4c:	5d                   	pop    %ebp
  800f4d:	c3                   	ret    

00800f4e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f4e:	55                   	push   %ebp
  800f4f:	89 e5                	mov    %esp,%ebp
  800f51:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f54:	8b 45 08             	mov    0x8(%ebp),%eax
  800f57:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800f5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f5d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f60:	8b 45 08             	mov    0x8(%ebp),%eax
  800f63:	01 d0                	add    %edx,%eax
  800f65:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f68:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800f6f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f73:	74 06                	je     800f7b <vsnprintf+0x2d>
  800f75:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f79:	7f 07                	jg     800f82 <vsnprintf+0x34>
		return -E_INVAL;
  800f7b:	b8 03 00 00 00       	mov    $0x3,%eax
  800f80:	eb 20                	jmp    800fa2 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800f82:	ff 75 14             	pushl  0x14(%ebp)
  800f85:	ff 75 10             	pushl  0x10(%ebp)
  800f88:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800f8b:	50                   	push   %eax
  800f8c:	68 18 0f 80 00       	push   $0x800f18
  800f91:	e8 80 fb ff ff       	call   800b16 <vprintfmt>
  800f96:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800f99:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f9c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800f9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800fa2:	c9                   	leave  
  800fa3:	c3                   	ret    

00800fa4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800fa4:	55                   	push   %ebp
  800fa5:	89 e5                	mov    %esp,%ebp
  800fa7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800faa:	8d 45 10             	lea    0x10(%ebp),%eax
  800fad:	83 c0 04             	add    $0x4,%eax
  800fb0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800fb3:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb6:	ff 75 f4             	pushl  -0xc(%ebp)
  800fb9:	50                   	push   %eax
  800fba:	ff 75 0c             	pushl  0xc(%ebp)
  800fbd:	ff 75 08             	pushl  0x8(%ebp)
  800fc0:	e8 89 ff ff ff       	call   800f4e <vsnprintf>
  800fc5:	83 c4 10             	add    $0x10,%esp
  800fc8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800fcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800fce:	c9                   	leave  
  800fcf:	c3                   	ret    

00800fd0 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800fd0:	55                   	push   %ebp
  800fd1:	89 e5                	mov    %esp,%ebp
  800fd3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800fd6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800fdd:	eb 06                	jmp    800fe5 <strlen+0x15>
		n++;
  800fdf:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800fe2:	ff 45 08             	incl   0x8(%ebp)
  800fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe8:	8a 00                	mov    (%eax),%al
  800fea:	84 c0                	test   %al,%al
  800fec:	75 f1                	jne    800fdf <strlen+0xf>
		n++;
	return n;
  800fee:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ff1:	c9                   	leave  
  800ff2:	c3                   	ret    

00800ff3 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800ff3:	55                   	push   %ebp
  800ff4:	89 e5                	mov    %esp,%ebp
  800ff6:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ff9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801000:	eb 09                	jmp    80100b <strnlen+0x18>
		n++;
  801002:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801005:	ff 45 08             	incl   0x8(%ebp)
  801008:	ff 4d 0c             	decl   0xc(%ebp)
  80100b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80100f:	74 09                	je     80101a <strnlen+0x27>
  801011:	8b 45 08             	mov    0x8(%ebp),%eax
  801014:	8a 00                	mov    (%eax),%al
  801016:	84 c0                	test   %al,%al
  801018:	75 e8                	jne    801002 <strnlen+0xf>
		n++;
	return n;
  80101a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80101d:	c9                   	leave  
  80101e:	c3                   	ret    

0080101f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80101f:	55                   	push   %ebp
  801020:	89 e5                	mov    %esp,%ebp
  801022:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801025:	8b 45 08             	mov    0x8(%ebp),%eax
  801028:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80102b:	90                   	nop
  80102c:	8b 45 08             	mov    0x8(%ebp),%eax
  80102f:	8d 50 01             	lea    0x1(%eax),%edx
  801032:	89 55 08             	mov    %edx,0x8(%ebp)
  801035:	8b 55 0c             	mov    0xc(%ebp),%edx
  801038:	8d 4a 01             	lea    0x1(%edx),%ecx
  80103b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80103e:	8a 12                	mov    (%edx),%dl
  801040:	88 10                	mov    %dl,(%eax)
  801042:	8a 00                	mov    (%eax),%al
  801044:	84 c0                	test   %al,%al
  801046:	75 e4                	jne    80102c <strcpy+0xd>
		/* do nothing */;
	return ret;
  801048:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80104b:	c9                   	leave  
  80104c:	c3                   	ret    

0080104d <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80104d:	55                   	push   %ebp
  80104e:	89 e5                	mov    %esp,%ebp
  801050:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801053:	8b 45 08             	mov    0x8(%ebp),%eax
  801056:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801059:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801060:	eb 1f                	jmp    801081 <strncpy+0x34>
		*dst++ = *src;
  801062:	8b 45 08             	mov    0x8(%ebp),%eax
  801065:	8d 50 01             	lea    0x1(%eax),%edx
  801068:	89 55 08             	mov    %edx,0x8(%ebp)
  80106b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80106e:	8a 12                	mov    (%edx),%dl
  801070:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801072:	8b 45 0c             	mov    0xc(%ebp),%eax
  801075:	8a 00                	mov    (%eax),%al
  801077:	84 c0                	test   %al,%al
  801079:	74 03                	je     80107e <strncpy+0x31>
			src++;
  80107b:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80107e:	ff 45 fc             	incl   -0x4(%ebp)
  801081:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801084:	3b 45 10             	cmp    0x10(%ebp),%eax
  801087:	72 d9                	jb     801062 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801089:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80108c:	c9                   	leave  
  80108d:	c3                   	ret    

0080108e <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80108e:	55                   	push   %ebp
  80108f:	89 e5                	mov    %esp,%ebp
  801091:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801094:	8b 45 08             	mov    0x8(%ebp),%eax
  801097:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80109a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80109e:	74 30                	je     8010d0 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8010a0:	eb 16                	jmp    8010b8 <strlcpy+0x2a>
			*dst++ = *src++;
  8010a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a5:	8d 50 01             	lea    0x1(%eax),%edx
  8010a8:	89 55 08             	mov    %edx,0x8(%ebp)
  8010ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010ae:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010b1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010b4:	8a 12                	mov    (%edx),%dl
  8010b6:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8010b8:	ff 4d 10             	decl   0x10(%ebp)
  8010bb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010bf:	74 09                	je     8010ca <strlcpy+0x3c>
  8010c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c4:	8a 00                	mov    (%eax),%al
  8010c6:	84 c0                	test   %al,%al
  8010c8:	75 d8                	jne    8010a2 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8010ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cd:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8010d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8010d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010d6:	29 c2                	sub    %eax,%edx
  8010d8:	89 d0                	mov    %edx,%eax
}
  8010da:	c9                   	leave  
  8010db:	c3                   	ret    

008010dc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8010dc:	55                   	push   %ebp
  8010dd:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8010df:	eb 06                	jmp    8010e7 <strcmp+0xb>
		p++, q++;
  8010e1:	ff 45 08             	incl   0x8(%ebp)
  8010e4:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8010e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ea:	8a 00                	mov    (%eax),%al
  8010ec:	84 c0                	test   %al,%al
  8010ee:	74 0e                	je     8010fe <strcmp+0x22>
  8010f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f3:	8a 10                	mov    (%eax),%dl
  8010f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f8:	8a 00                	mov    (%eax),%al
  8010fa:	38 c2                	cmp    %al,%dl
  8010fc:	74 e3                	je     8010e1 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8010fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801101:	8a 00                	mov    (%eax),%al
  801103:	0f b6 d0             	movzbl %al,%edx
  801106:	8b 45 0c             	mov    0xc(%ebp),%eax
  801109:	8a 00                	mov    (%eax),%al
  80110b:	0f b6 c0             	movzbl %al,%eax
  80110e:	29 c2                	sub    %eax,%edx
  801110:	89 d0                	mov    %edx,%eax
}
  801112:	5d                   	pop    %ebp
  801113:	c3                   	ret    

00801114 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801114:	55                   	push   %ebp
  801115:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801117:	eb 09                	jmp    801122 <strncmp+0xe>
		n--, p++, q++;
  801119:	ff 4d 10             	decl   0x10(%ebp)
  80111c:	ff 45 08             	incl   0x8(%ebp)
  80111f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801122:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801126:	74 17                	je     80113f <strncmp+0x2b>
  801128:	8b 45 08             	mov    0x8(%ebp),%eax
  80112b:	8a 00                	mov    (%eax),%al
  80112d:	84 c0                	test   %al,%al
  80112f:	74 0e                	je     80113f <strncmp+0x2b>
  801131:	8b 45 08             	mov    0x8(%ebp),%eax
  801134:	8a 10                	mov    (%eax),%dl
  801136:	8b 45 0c             	mov    0xc(%ebp),%eax
  801139:	8a 00                	mov    (%eax),%al
  80113b:	38 c2                	cmp    %al,%dl
  80113d:	74 da                	je     801119 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80113f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801143:	75 07                	jne    80114c <strncmp+0x38>
		return 0;
  801145:	b8 00 00 00 00       	mov    $0x0,%eax
  80114a:	eb 14                	jmp    801160 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80114c:	8b 45 08             	mov    0x8(%ebp),%eax
  80114f:	8a 00                	mov    (%eax),%al
  801151:	0f b6 d0             	movzbl %al,%edx
  801154:	8b 45 0c             	mov    0xc(%ebp),%eax
  801157:	8a 00                	mov    (%eax),%al
  801159:	0f b6 c0             	movzbl %al,%eax
  80115c:	29 c2                	sub    %eax,%edx
  80115e:	89 d0                	mov    %edx,%eax
}
  801160:	5d                   	pop    %ebp
  801161:	c3                   	ret    

00801162 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801162:	55                   	push   %ebp
  801163:	89 e5                	mov    %esp,%ebp
  801165:	83 ec 04             	sub    $0x4,%esp
  801168:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80116e:	eb 12                	jmp    801182 <strchr+0x20>
		if (*s == c)
  801170:	8b 45 08             	mov    0x8(%ebp),%eax
  801173:	8a 00                	mov    (%eax),%al
  801175:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801178:	75 05                	jne    80117f <strchr+0x1d>
			return (char *) s;
  80117a:	8b 45 08             	mov    0x8(%ebp),%eax
  80117d:	eb 11                	jmp    801190 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80117f:	ff 45 08             	incl   0x8(%ebp)
  801182:	8b 45 08             	mov    0x8(%ebp),%eax
  801185:	8a 00                	mov    (%eax),%al
  801187:	84 c0                	test   %al,%al
  801189:	75 e5                	jne    801170 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80118b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801190:	c9                   	leave  
  801191:	c3                   	ret    

00801192 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801192:	55                   	push   %ebp
  801193:	89 e5                	mov    %esp,%ebp
  801195:	83 ec 04             	sub    $0x4,%esp
  801198:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80119e:	eb 0d                	jmp    8011ad <strfind+0x1b>
		if (*s == c)
  8011a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a3:	8a 00                	mov    (%eax),%al
  8011a5:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011a8:	74 0e                	je     8011b8 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8011aa:	ff 45 08             	incl   0x8(%ebp)
  8011ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b0:	8a 00                	mov    (%eax),%al
  8011b2:	84 c0                	test   %al,%al
  8011b4:	75 ea                	jne    8011a0 <strfind+0xe>
  8011b6:	eb 01                	jmp    8011b9 <strfind+0x27>
		if (*s == c)
			break;
  8011b8:	90                   	nop
	return (char *) s;
  8011b9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011bc:	c9                   	leave  
  8011bd:	c3                   	ret    

008011be <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  8011be:	55                   	push   %ebp
  8011bf:	89 e5                	mov    %esp,%ebp
  8011c1:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  8011c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  8011ca:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8011ce:	76 63                	jbe    801233 <memset+0x75>
		uint64 data_block = c;
  8011d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d3:	99                   	cltd   
  8011d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011d7:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  8011da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011e0:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  8011e4:	c1 e0 08             	shl    $0x8,%eax
  8011e7:	09 45 f0             	or     %eax,-0x10(%ebp)
  8011ea:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  8011ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011f3:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  8011f7:	c1 e0 10             	shl    $0x10,%eax
  8011fa:	09 45 f0             	or     %eax,-0x10(%ebp)
  8011fd:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801200:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801203:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801206:	89 c2                	mov    %eax,%edx
  801208:	b8 00 00 00 00       	mov    $0x0,%eax
  80120d:	09 45 f0             	or     %eax,-0x10(%ebp)
  801210:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801213:	eb 18                	jmp    80122d <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801215:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801218:	8d 41 08             	lea    0x8(%ecx),%eax
  80121b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80121e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801221:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801224:	89 01                	mov    %eax,(%ecx)
  801226:	89 51 04             	mov    %edx,0x4(%ecx)
  801229:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  80122d:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801231:	77 e2                	ja     801215 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801233:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801237:	74 23                	je     80125c <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801239:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80123c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  80123f:	eb 0e                	jmp    80124f <memset+0x91>
			*p8++ = (uint8)c;
  801241:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801244:	8d 50 01             	lea    0x1(%eax),%edx
  801247:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80124a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80124d:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  80124f:	8b 45 10             	mov    0x10(%ebp),%eax
  801252:	8d 50 ff             	lea    -0x1(%eax),%edx
  801255:	89 55 10             	mov    %edx,0x10(%ebp)
  801258:	85 c0                	test   %eax,%eax
  80125a:	75 e5                	jne    801241 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  80125c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80125f:	c9                   	leave  
  801260:	c3                   	ret    

00801261 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801261:	55                   	push   %ebp
  801262:	89 e5                	mov    %esp,%ebp
  801264:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801267:	8b 45 0c             	mov    0xc(%ebp),%eax
  80126a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  80126d:	8b 45 08             	mov    0x8(%ebp),%eax
  801270:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801273:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801277:	76 24                	jbe    80129d <memcpy+0x3c>
		while(n >= 8){
  801279:	eb 1c                	jmp    801297 <memcpy+0x36>
			*d64 = *s64;
  80127b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80127e:	8b 50 04             	mov    0x4(%eax),%edx
  801281:	8b 00                	mov    (%eax),%eax
  801283:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801286:	89 01                	mov    %eax,(%ecx)
  801288:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  80128b:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  80128f:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801293:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801297:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80129b:	77 de                	ja     80127b <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  80129d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012a1:	74 31                	je     8012d4 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8012a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8012a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8012af:	eb 16                	jmp    8012c7 <memcpy+0x66>
			*d8++ = *s8++;
  8012b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012b4:	8d 50 01             	lea    0x1(%eax),%edx
  8012b7:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8012ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012bd:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012c0:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8012c3:	8a 12                	mov    (%edx),%dl
  8012c5:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  8012c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ca:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012cd:	89 55 10             	mov    %edx,0x10(%ebp)
  8012d0:	85 c0                	test   %eax,%eax
  8012d2:	75 dd                	jne    8012b1 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  8012d4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012d7:	c9                   	leave  
  8012d8:	c3                   	ret    

008012d9 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8012d9:	55                   	push   %ebp
  8012da:	89 e5                	mov    %esp,%ebp
  8012dc:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8012df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8012e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8012eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012ee:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8012f1:	73 50                	jae    801343 <memmove+0x6a>
  8012f3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f9:	01 d0                	add    %edx,%eax
  8012fb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8012fe:	76 43                	jbe    801343 <memmove+0x6a>
		s += n;
  801300:	8b 45 10             	mov    0x10(%ebp),%eax
  801303:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801306:	8b 45 10             	mov    0x10(%ebp),%eax
  801309:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80130c:	eb 10                	jmp    80131e <memmove+0x45>
			*--d = *--s;
  80130e:	ff 4d f8             	decl   -0x8(%ebp)
  801311:	ff 4d fc             	decl   -0x4(%ebp)
  801314:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801317:	8a 10                	mov    (%eax),%dl
  801319:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80131c:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80131e:	8b 45 10             	mov    0x10(%ebp),%eax
  801321:	8d 50 ff             	lea    -0x1(%eax),%edx
  801324:	89 55 10             	mov    %edx,0x10(%ebp)
  801327:	85 c0                	test   %eax,%eax
  801329:	75 e3                	jne    80130e <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80132b:	eb 23                	jmp    801350 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80132d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801330:	8d 50 01             	lea    0x1(%eax),%edx
  801333:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801336:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801339:	8d 4a 01             	lea    0x1(%edx),%ecx
  80133c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80133f:	8a 12                	mov    (%edx),%dl
  801341:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801343:	8b 45 10             	mov    0x10(%ebp),%eax
  801346:	8d 50 ff             	lea    -0x1(%eax),%edx
  801349:	89 55 10             	mov    %edx,0x10(%ebp)
  80134c:	85 c0                	test   %eax,%eax
  80134e:	75 dd                	jne    80132d <memmove+0x54>
			*d++ = *s++;

	return dst;
  801350:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801353:	c9                   	leave  
  801354:	c3                   	ret    

00801355 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801355:	55                   	push   %ebp
  801356:	89 e5                	mov    %esp,%ebp
  801358:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80135b:	8b 45 08             	mov    0x8(%ebp),%eax
  80135e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801361:	8b 45 0c             	mov    0xc(%ebp),%eax
  801364:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801367:	eb 2a                	jmp    801393 <memcmp+0x3e>
		if (*s1 != *s2)
  801369:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80136c:	8a 10                	mov    (%eax),%dl
  80136e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801371:	8a 00                	mov    (%eax),%al
  801373:	38 c2                	cmp    %al,%dl
  801375:	74 16                	je     80138d <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801377:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80137a:	8a 00                	mov    (%eax),%al
  80137c:	0f b6 d0             	movzbl %al,%edx
  80137f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801382:	8a 00                	mov    (%eax),%al
  801384:	0f b6 c0             	movzbl %al,%eax
  801387:	29 c2                	sub    %eax,%edx
  801389:	89 d0                	mov    %edx,%eax
  80138b:	eb 18                	jmp    8013a5 <memcmp+0x50>
		s1++, s2++;
  80138d:	ff 45 fc             	incl   -0x4(%ebp)
  801390:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801393:	8b 45 10             	mov    0x10(%ebp),%eax
  801396:	8d 50 ff             	lea    -0x1(%eax),%edx
  801399:	89 55 10             	mov    %edx,0x10(%ebp)
  80139c:	85 c0                	test   %eax,%eax
  80139e:	75 c9                	jne    801369 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8013a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013a5:	c9                   	leave  
  8013a6:	c3                   	ret    

008013a7 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8013a7:	55                   	push   %ebp
  8013a8:	89 e5                	mov    %esp,%ebp
  8013aa:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8013ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8013b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8013b3:	01 d0                	add    %edx,%eax
  8013b5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8013b8:	eb 15                	jmp    8013cf <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8013ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bd:	8a 00                	mov    (%eax),%al
  8013bf:	0f b6 d0             	movzbl %al,%edx
  8013c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c5:	0f b6 c0             	movzbl %al,%eax
  8013c8:	39 c2                	cmp    %eax,%edx
  8013ca:	74 0d                	je     8013d9 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8013cc:	ff 45 08             	incl   0x8(%ebp)
  8013cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8013d5:	72 e3                	jb     8013ba <memfind+0x13>
  8013d7:	eb 01                	jmp    8013da <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8013d9:	90                   	nop
	return (void *) s;
  8013da:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013dd:	c9                   	leave  
  8013de:	c3                   	ret    

008013df <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8013df:	55                   	push   %ebp
  8013e0:	89 e5                	mov    %esp,%ebp
  8013e2:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8013e5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8013ec:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013f3:	eb 03                	jmp    8013f8 <strtol+0x19>
		s++;
  8013f5:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fb:	8a 00                	mov    (%eax),%al
  8013fd:	3c 20                	cmp    $0x20,%al
  8013ff:	74 f4                	je     8013f5 <strtol+0x16>
  801401:	8b 45 08             	mov    0x8(%ebp),%eax
  801404:	8a 00                	mov    (%eax),%al
  801406:	3c 09                	cmp    $0x9,%al
  801408:	74 eb                	je     8013f5 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80140a:	8b 45 08             	mov    0x8(%ebp),%eax
  80140d:	8a 00                	mov    (%eax),%al
  80140f:	3c 2b                	cmp    $0x2b,%al
  801411:	75 05                	jne    801418 <strtol+0x39>
		s++;
  801413:	ff 45 08             	incl   0x8(%ebp)
  801416:	eb 13                	jmp    80142b <strtol+0x4c>
	else if (*s == '-')
  801418:	8b 45 08             	mov    0x8(%ebp),%eax
  80141b:	8a 00                	mov    (%eax),%al
  80141d:	3c 2d                	cmp    $0x2d,%al
  80141f:	75 0a                	jne    80142b <strtol+0x4c>
		s++, neg = 1;
  801421:	ff 45 08             	incl   0x8(%ebp)
  801424:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80142b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80142f:	74 06                	je     801437 <strtol+0x58>
  801431:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801435:	75 20                	jne    801457 <strtol+0x78>
  801437:	8b 45 08             	mov    0x8(%ebp),%eax
  80143a:	8a 00                	mov    (%eax),%al
  80143c:	3c 30                	cmp    $0x30,%al
  80143e:	75 17                	jne    801457 <strtol+0x78>
  801440:	8b 45 08             	mov    0x8(%ebp),%eax
  801443:	40                   	inc    %eax
  801444:	8a 00                	mov    (%eax),%al
  801446:	3c 78                	cmp    $0x78,%al
  801448:	75 0d                	jne    801457 <strtol+0x78>
		s += 2, base = 16;
  80144a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80144e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801455:	eb 28                	jmp    80147f <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801457:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80145b:	75 15                	jne    801472 <strtol+0x93>
  80145d:	8b 45 08             	mov    0x8(%ebp),%eax
  801460:	8a 00                	mov    (%eax),%al
  801462:	3c 30                	cmp    $0x30,%al
  801464:	75 0c                	jne    801472 <strtol+0x93>
		s++, base = 8;
  801466:	ff 45 08             	incl   0x8(%ebp)
  801469:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801470:	eb 0d                	jmp    80147f <strtol+0xa0>
	else if (base == 0)
  801472:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801476:	75 07                	jne    80147f <strtol+0xa0>
		base = 10;
  801478:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80147f:	8b 45 08             	mov    0x8(%ebp),%eax
  801482:	8a 00                	mov    (%eax),%al
  801484:	3c 2f                	cmp    $0x2f,%al
  801486:	7e 19                	jle    8014a1 <strtol+0xc2>
  801488:	8b 45 08             	mov    0x8(%ebp),%eax
  80148b:	8a 00                	mov    (%eax),%al
  80148d:	3c 39                	cmp    $0x39,%al
  80148f:	7f 10                	jg     8014a1 <strtol+0xc2>
			dig = *s - '0';
  801491:	8b 45 08             	mov    0x8(%ebp),%eax
  801494:	8a 00                	mov    (%eax),%al
  801496:	0f be c0             	movsbl %al,%eax
  801499:	83 e8 30             	sub    $0x30,%eax
  80149c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80149f:	eb 42                	jmp    8014e3 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8014a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a4:	8a 00                	mov    (%eax),%al
  8014a6:	3c 60                	cmp    $0x60,%al
  8014a8:	7e 19                	jle    8014c3 <strtol+0xe4>
  8014aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ad:	8a 00                	mov    (%eax),%al
  8014af:	3c 7a                	cmp    $0x7a,%al
  8014b1:	7f 10                	jg     8014c3 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8014b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b6:	8a 00                	mov    (%eax),%al
  8014b8:	0f be c0             	movsbl %al,%eax
  8014bb:	83 e8 57             	sub    $0x57,%eax
  8014be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014c1:	eb 20                	jmp    8014e3 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8014c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c6:	8a 00                	mov    (%eax),%al
  8014c8:	3c 40                	cmp    $0x40,%al
  8014ca:	7e 39                	jle    801505 <strtol+0x126>
  8014cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cf:	8a 00                	mov    (%eax),%al
  8014d1:	3c 5a                	cmp    $0x5a,%al
  8014d3:	7f 30                	jg     801505 <strtol+0x126>
			dig = *s - 'A' + 10;
  8014d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d8:	8a 00                	mov    (%eax),%al
  8014da:	0f be c0             	movsbl %al,%eax
  8014dd:	83 e8 37             	sub    $0x37,%eax
  8014e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8014e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014e6:	3b 45 10             	cmp    0x10(%ebp),%eax
  8014e9:	7d 19                	jge    801504 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8014eb:	ff 45 08             	incl   0x8(%ebp)
  8014ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014f1:	0f af 45 10          	imul   0x10(%ebp),%eax
  8014f5:	89 c2                	mov    %eax,%edx
  8014f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014fa:	01 d0                	add    %edx,%eax
  8014fc:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8014ff:	e9 7b ff ff ff       	jmp    80147f <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801504:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801505:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801509:	74 08                	je     801513 <strtol+0x134>
		*endptr = (char *) s;
  80150b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80150e:	8b 55 08             	mov    0x8(%ebp),%edx
  801511:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801513:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801517:	74 07                	je     801520 <strtol+0x141>
  801519:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80151c:	f7 d8                	neg    %eax
  80151e:	eb 03                	jmp    801523 <strtol+0x144>
  801520:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801523:	c9                   	leave  
  801524:	c3                   	ret    

00801525 <ltostr>:

void
ltostr(long value, char *str)
{
  801525:	55                   	push   %ebp
  801526:	89 e5                	mov    %esp,%ebp
  801528:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80152b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801532:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801539:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80153d:	79 13                	jns    801552 <ltostr+0x2d>
	{
		neg = 1;
  80153f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801546:	8b 45 0c             	mov    0xc(%ebp),%eax
  801549:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80154c:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80154f:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801552:	8b 45 08             	mov    0x8(%ebp),%eax
  801555:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80155a:	99                   	cltd   
  80155b:	f7 f9                	idiv   %ecx
  80155d:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801560:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801563:	8d 50 01             	lea    0x1(%eax),%edx
  801566:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801569:	89 c2                	mov    %eax,%edx
  80156b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80156e:	01 d0                	add    %edx,%eax
  801570:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801573:	83 c2 30             	add    $0x30,%edx
  801576:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801578:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80157b:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801580:	f7 e9                	imul   %ecx
  801582:	c1 fa 02             	sar    $0x2,%edx
  801585:	89 c8                	mov    %ecx,%eax
  801587:	c1 f8 1f             	sar    $0x1f,%eax
  80158a:	29 c2                	sub    %eax,%edx
  80158c:	89 d0                	mov    %edx,%eax
  80158e:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801591:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801595:	75 bb                	jne    801552 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801597:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80159e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015a1:	48                   	dec    %eax
  8015a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8015a5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8015a9:	74 3d                	je     8015e8 <ltostr+0xc3>
		start = 1 ;
  8015ab:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8015b2:	eb 34                	jmp    8015e8 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8015b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ba:	01 d0                	add    %edx,%eax
  8015bc:	8a 00                	mov    (%eax),%al
  8015be:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8015c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c7:	01 c2                	add    %eax,%edx
  8015c9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8015cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015cf:	01 c8                	add    %ecx,%eax
  8015d1:	8a 00                	mov    (%eax),%al
  8015d3:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8015d5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015db:	01 c2                	add    %eax,%edx
  8015dd:	8a 45 eb             	mov    -0x15(%ebp),%al
  8015e0:	88 02                	mov    %al,(%edx)
		start++ ;
  8015e2:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8015e5:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8015e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015eb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8015ee:	7c c4                	jl     8015b4 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8015f0:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8015f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f6:	01 d0                	add    %edx,%eax
  8015f8:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8015fb:	90                   	nop
  8015fc:	c9                   	leave  
  8015fd:	c3                   	ret    

008015fe <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8015fe:	55                   	push   %ebp
  8015ff:	89 e5                	mov    %esp,%ebp
  801601:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801604:	ff 75 08             	pushl  0x8(%ebp)
  801607:	e8 c4 f9 ff ff       	call   800fd0 <strlen>
  80160c:	83 c4 04             	add    $0x4,%esp
  80160f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801612:	ff 75 0c             	pushl  0xc(%ebp)
  801615:	e8 b6 f9 ff ff       	call   800fd0 <strlen>
  80161a:	83 c4 04             	add    $0x4,%esp
  80161d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801620:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801627:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80162e:	eb 17                	jmp    801647 <strcconcat+0x49>
		final[s] = str1[s] ;
  801630:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801633:	8b 45 10             	mov    0x10(%ebp),%eax
  801636:	01 c2                	add    %eax,%edx
  801638:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80163b:	8b 45 08             	mov    0x8(%ebp),%eax
  80163e:	01 c8                	add    %ecx,%eax
  801640:	8a 00                	mov    (%eax),%al
  801642:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801644:	ff 45 fc             	incl   -0x4(%ebp)
  801647:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80164a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80164d:	7c e1                	jl     801630 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80164f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801656:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80165d:	eb 1f                	jmp    80167e <strcconcat+0x80>
		final[s++] = str2[i] ;
  80165f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801662:	8d 50 01             	lea    0x1(%eax),%edx
  801665:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801668:	89 c2                	mov    %eax,%edx
  80166a:	8b 45 10             	mov    0x10(%ebp),%eax
  80166d:	01 c2                	add    %eax,%edx
  80166f:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801672:	8b 45 0c             	mov    0xc(%ebp),%eax
  801675:	01 c8                	add    %ecx,%eax
  801677:	8a 00                	mov    (%eax),%al
  801679:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80167b:	ff 45 f8             	incl   -0x8(%ebp)
  80167e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801681:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801684:	7c d9                	jl     80165f <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801686:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801689:	8b 45 10             	mov    0x10(%ebp),%eax
  80168c:	01 d0                	add    %edx,%eax
  80168e:	c6 00 00             	movb   $0x0,(%eax)
}
  801691:	90                   	nop
  801692:	c9                   	leave  
  801693:	c3                   	ret    

00801694 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801694:	55                   	push   %ebp
  801695:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801697:	8b 45 14             	mov    0x14(%ebp),%eax
  80169a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8016a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8016a3:	8b 00                	mov    (%eax),%eax
  8016a5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8016af:	01 d0                	add    %edx,%eax
  8016b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8016b7:	eb 0c                	jmp    8016c5 <strsplit+0x31>
			*string++ = 0;
  8016b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bc:	8d 50 01             	lea    0x1(%eax),%edx
  8016bf:	89 55 08             	mov    %edx,0x8(%ebp)
  8016c2:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8016c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c8:	8a 00                	mov    (%eax),%al
  8016ca:	84 c0                	test   %al,%al
  8016cc:	74 18                	je     8016e6 <strsplit+0x52>
  8016ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d1:	8a 00                	mov    (%eax),%al
  8016d3:	0f be c0             	movsbl %al,%eax
  8016d6:	50                   	push   %eax
  8016d7:	ff 75 0c             	pushl  0xc(%ebp)
  8016da:	e8 83 fa ff ff       	call   801162 <strchr>
  8016df:	83 c4 08             	add    $0x8,%esp
  8016e2:	85 c0                	test   %eax,%eax
  8016e4:	75 d3                	jne    8016b9 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8016e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e9:	8a 00                	mov    (%eax),%al
  8016eb:	84 c0                	test   %al,%al
  8016ed:	74 5a                	je     801749 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8016ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8016f2:	8b 00                	mov    (%eax),%eax
  8016f4:	83 f8 0f             	cmp    $0xf,%eax
  8016f7:	75 07                	jne    801700 <strsplit+0x6c>
		{
			return 0;
  8016f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8016fe:	eb 66                	jmp    801766 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801700:	8b 45 14             	mov    0x14(%ebp),%eax
  801703:	8b 00                	mov    (%eax),%eax
  801705:	8d 48 01             	lea    0x1(%eax),%ecx
  801708:	8b 55 14             	mov    0x14(%ebp),%edx
  80170b:	89 0a                	mov    %ecx,(%edx)
  80170d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801714:	8b 45 10             	mov    0x10(%ebp),%eax
  801717:	01 c2                	add    %eax,%edx
  801719:	8b 45 08             	mov    0x8(%ebp),%eax
  80171c:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80171e:	eb 03                	jmp    801723 <strsplit+0x8f>
			string++;
  801720:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801723:	8b 45 08             	mov    0x8(%ebp),%eax
  801726:	8a 00                	mov    (%eax),%al
  801728:	84 c0                	test   %al,%al
  80172a:	74 8b                	je     8016b7 <strsplit+0x23>
  80172c:	8b 45 08             	mov    0x8(%ebp),%eax
  80172f:	8a 00                	mov    (%eax),%al
  801731:	0f be c0             	movsbl %al,%eax
  801734:	50                   	push   %eax
  801735:	ff 75 0c             	pushl  0xc(%ebp)
  801738:	e8 25 fa ff ff       	call   801162 <strchr>
  80173d:	83 c4 08             	add    $0x8,%esp
  801740:	85 c0                	test   %eax,%eax
  801742:	74 dc                	je     801720 <strsplit+0x8c>
			string++;
	}
  801744:	e9 6e ff ff ff       	jmp    8016b7 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801749:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80174a:	8b 45 14             	mov    0x14(%ebp),%eax
  80174d:	8b 00                	mov    (%eax),%eax
  80174f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801756:	8b 45 10             	mov    0x10(%ebp),%eax
  801759:	01 d0                	add    %edx,%eax
  80175b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801761:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801766:	c9                   	leave  
  801767:	c3                   	ret    

00801768 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801768:	55                   	push   %ebp
  801769:	89 e5                	mov    %esp,%ebp
  80176b:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  80176e:	8b 45 08             	mov    0x8(%ebp),%eax
  801771:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801774:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80177b:	eb 4a                	jmp    8017c7 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  80177d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801780:	8b 45 08             	mov    0x8(%ebp),%eax
  801783:	01 c2                	add    %eax,%edx
  801785:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801788:	8b 45 0c             	mov    0xc(%ebp),%eax
  80178b:	01 c8                	add    %ecx,%eax
  80178d:	8a 00                	mov    (%eax),%al
  80178f:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801791:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801794:	8b 45 0c             	mov    0xc(%ebp),%eax
  801797:	01 d0                	add    %edx,%eax
  801799:	8a 00                	mov    (%eax),%al
  80179b:	3c 40                	cmp    $0x40,%al
  80179d:	7e 25                	jle    8017c4 <str2lower+0x5c>
  80179f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017a5:	01 d0                	add    %edx,%eax
  8017a7:	8a 00                	mov    (%eax),%al
  8017a9:	3c 5a                	cmp    $0x5a,%al
  8017ab:	7f 17                	jg     8017c4 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8017ad:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b3:	01 d0                	add    %edx,%eax
  8017b5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8017b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8017bb:	01 ca                	add    %ecx,%edx
  8017bd:	8a 12                	mov    (%edx),%dl
  8017bf:	83 c2 20             	add    $0x20,%edx
  8017c2:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8017c4:	ff 45 fc             	incl   -0x4(%ebp)
  8017c7:	ff 75 0c             	pushl  0xc(%ebp)
  8017ca:	e8 01 f8 ff ff       	call   800fd0 <strlen>
  8017cf:	83 c4 04             	add    $0x4,%esp
  8017d2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8017d5:	7f a6                	jg     80177d <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8017d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8017da:	c9                   	leave  
  8017db:	c3                   	ret    

008017dc <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  8017dc:	55                   	push   %ebp
  8017dd:	89 e5                	mov    %esp,%ebp
  8017df:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  8017e2:	a1 08 40 80 00       	mov    0x804008,%eax
  8017e7:	85 c0                	test   %eax,%eax
  8017e9:	74 42                	je     80182d <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  8017eb:	83 ec 08             	sub    $0x8,%esp
  8017ee:	68 00 00 00 82       	push   $0x82000000
  8017f3:	68 00 00 00 80       	push   $0x80000000
  8017f8:	e8 8c 07 00 00       	call   801f89 <initialize_dynamic_allocator>
  8017fd:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801800:	e8 e7 05 00 00       	call   801dec <sys_get_uheap_strategy>
  801805:	a3 60 c0 81 00       	mov    %eax,0x81c060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  80180a:	a1 40 40 80 00       	mov    0x804040,%eax
  80180f:	05 00 10 00 00       	add    $0x1000,%eax
  801814:	a3 10 c1 81 00       	mov    %eax,0x81c110
		uheapPageAllocBreak = uheapPageAllocStart;
  801819:	a1 10 c1 81 00       	mov    0x81c110,%eax
  80181e:	a3 68 c0 81 00       	mov    %eax,0x81c068

		__firstTimeFlag = 0;
  801823:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  80182a:	00 00 00 
	}
}
  80182d:	90                   	nop
  80182e:	c9                   	leave  
  80182f:	c3                   	ret    

00801830 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801830:	55                   	push   %ebp
  801831:	89 e5                	mov    %esp,%ebp
  801833:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801836:	8b 45 08             	mov    0x8(%ebp),%eax
  801839:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80183c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80183f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801844:	83 ec 08             	sub    $0x8,%esp
  801847:	68 06 04 00 00       	push   $0x406
  80184c:	50                   	push   %eax
  80184d:	e8 e4 01 00 00       	call   801a36 <__sys_allocate_page>
  801852:	83 c4 10             	add    $0x10,%esp
  801855:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801858:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80185c:	79 14                	jns    801872 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  80185e:	83 ec 04             	sub    $0x4,%esp
  801861:	68 a8 2c 80 00       	push   $0x802ca8
  801866:	6a 1f                	push   $0x1f
  801868:	68 e4 2c 80 00       	push   $0x802ce4
  80186d:	e8 86 08 00 00       	call   8020f8 <_panic>
	return 0;
  801872:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801877:	c9                   	leave  
  801878:	c3                   	ret    

00801879 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801879:	55                   	push   %ebp
  80187a:	89 e5                	mov    %esp,%ebp
  80187c:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  80187f:	8b 45 08             	mov    0x8(%ebp),%eax
  801882:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801885:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801888:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80188d:	83 ec 0c             	sub    $0xc,%esp
  801890:	50                   	push   %eax
  801891:	e8 e7 01 00 00       	call   801a7d <__sys_unmap_frame>
  801896:	83 c4 10             	add    $0x10,%esp
  801899:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  80189c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8018a0:	79 14                	jns    8018b6 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  8018a2:	83 ec 04             	sub    $0x4,%esp
  8018a5:	68 f0 2c 80 00       	push   $0x802cf0
  8018aa:	6a 2a                	push   $0x2a
  8018ac:	68 e4 2c 80 00       	push   $0x802ce4
  8018b1:	e8 42 08 00 00       	call   8020f8 <_panic>
}
  8018b6:	90                   	nop
  8018b7:	c9                   	leave  
  8018b8:	c3                   	ret    

008018b9 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  8018b9:	55                   	push   %ebp
  8018ba:	89 e5                	mov    %esp,%ebp
  8018bc:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8018bf:	e8 18 ff ff ff       	call   8017dc <uheap_init>
	if (size == 0) return NULL ;
  8018c4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018c8:	75 07                	jne    8018d1 <malloc+0x18>
  8018ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8018cf:	eb 14                	jmp    8018e5 <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  8018d1:	83 ec 04             	sub    $0x4,%esp
  8018d4:	68 30 2d 80 00       	push   $0x802d30
  8018d9:	6a 3e                	push   $0x3e
  8018db:	68 e4 2c 80 00       	push   $0x802ce4
  8018e0:	e8 13 08 00 00       	call   8020f8 <_panic>
}
  8018e5:	c9                   	leave  
  8018e6:	c3                   	ret    

008018e7 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  8018e7:	55                   	push   %ebp
  8018e8:	89 e5                	mov    %esp,%ebp
  8018ea:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  8018ed:	83 ec 04             	sub    $0x4,%esp
  8018f0:	68 58 2d 80 00       	push   $0x802d58
  8018f5:	6a 49                	push   $0x49
  8018f7:	68 e4 2c 80 00       	push   $0x802ce4
  8018fc:	e8 f7 07 00 00       	call   8020f8 <_panic>

00801901 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801901:	55                   	push   %ebp
  801902:	89 e5                	mov    %esp,%ebp
  801904:	83 ec 18             	sub    $0x18,%esp
  801907:	8b 45 10             	mov    0x10(%ebp),%eax
  80190a:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80190d:	e8 ca fe ff ff       	call   8017dc <uheap_init>
	if (size == 0) return NULL ;
  801912:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801916:	75 07                	jne    80191f <smalloc+0x1e>
  801918:	b8 00 00 00 00       	mov    $0x0,%eax
  80191d:	eb 14                	jmp    801933 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  80191f:	83 ec 04             	sub    $0x4,%esp
  801922:	68 7c 2d 80 00       	push   $0x802d7c
  801927:	6a 5a                	push   $0x5a
  801929:	68 e4 2c 80 00       	push   $0x802ce4
  80192e:	e8 c5 07 00 00       	call   8020f8 <_panic>
}
  801933:	c9                   	leave  
  801934:	c3                   	ret    

00801935 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801935:	55                   	push   %ebp
  801936:	89 e5                	mov    %esp,%ebp
  801938:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80193b:	e8 9c fe ff ff       	call   8017dc <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  801940:	83 ec 04             	sub    $0x4,%esp
  801943:	68 a4 2d 80 00       	push   $0x802da4
  801948:	6a 6a                	push   $0x6a
  80194a:	68 e4 2c 80 00       	push   $0x802ce4
  80194f:	e8 a4 07 00 00       	call   8020f8 <_panic>

00801954 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801954:	55                   	push   %ebp
  801955:	89 e5                	mov    %esp,%ebp
  801957:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80195a:	e8 7d fe ff ff       	call   8017dc <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  80195f:	83 ec 04             	sub    $0x4,%esp
  801962:	68 c8 2d 80 00       	push   $0x802dc8
  801967:	68 88 00 00 00       	push   $0x88
  80196c:	68 e4 2c 80 00       	push   $0x802ce4
  801971:	e8 82 07 00 00       	call   8020f8 <_panic>

00801976 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  801976:	55                   	push   %ebp
  801977:	89 e5                	mov    %esp,%ebp
  801979:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  80197c:	83 ec 04             	sub    $0x4,%esp
  80197f:	68 f0 2d 80 00       	push   $0x802df0
  801984:	68 9b 00 00 00       	push   $0x9b
  801989:	68 e4 2c 80 00       	push   $0x802ce4
  80198e:	e8 65 07 00 00       	call   8020f8 <_panic>

00801993 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801993:	55                   	push   %ebp
  801994:	89 e5                	mov    %esp,%ebp
  801996:	57                   	push   %edi
  801997:	56                   	push   %esi
  801998:	53                   	push   %ebx
  801999:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80199c:	8b 45 08             	mov    0x8(%ebp),%eax
  80199f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019a2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019a5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019a8:	8b 7d 18             	mov    0x18(%ebp),%edi
  8019ab:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8019ae:	cd 30                	int    $0x30
  8019b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8019b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8019b6:	83 c4 10             	add    $0x10,%esp
  8019b9:	5b                   	pop    %ebx
  8019ba:	5e                   	pop    %esi
  8019bb:	5f                   	pop    %edi
  8019bc:	5d                   	pop    %ebp
  8019bd:	c3                   	ret    

008019be <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8019be:	55                   	push   %ebp
  8019bf:	89 e5                	mov    %esp,%ebp
  8019c1:	83 ec 04             	sub    $0x4,%esp
  8019c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8019c7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8019ca:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8019cd:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d4:	6a 00                	push   $0x0
  8019d6:	51                   	push   %ecx
  8019d7:	52                   	push   %edx
  8019d8:	ff 75 0c             	pushl  0xc(%ebp)
  8019db:	50                   	push   %eax
  8019dc:	6a 00                	push   $0x0
  8019de:	e8 b0 ff ff ff       	call   801993 <syscall>
  8019e3:	83 c4 18             	add    $0x18,%esp
}
  8019e6:	90                   	nop
  8019e7:	c9                   	leave  
  8019e8:	c3                   	ret    

008019e9 <sys_cgetc>:

int
sys_cgetc(void)
{
  8019e9:	55                   	push   %ebp
  8019ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8019ec:	6a 00                	push   $0x0
  8019ee:	6a 00                	push   $0x0
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 00                	push   $0x0
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 02                	push   $0x2
  8019f8:	e8 96 ff ff ff       	call   801993 <syscall>
  8019fd:	83 c4 18             	add    $0x18,%esp
}
  801a00:	c9                   	leave  
  801a01:	c3                   	ret    

00801a02 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801a02:	55                   	push   %ebp
  801a03:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801a05:	6a 00                	push   $0x0
  801a07:	6a 00                	push   $0x0
  801a09:	6a 00                	push   $0x0
  801a0b:	6a 00                	push   $0x0
  801a0d:	6a 00                	push   $0x0
  801a0f:	6a 03                	push   $0x3
  801a11:	e8 7d ff ff ff       	call   801993 <syscall>
  801a16:	83 c4 18             	add    $0x18,%esp
}
  801a19:	90                   	nop
  801a1a:	c9                   	leave  
  801a1b:	c3                   	ret    

00801a1c <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801a1c:	55                   	push   %ebp
  801a1d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 00                	push   $0x0
  801a23:	6a 00                	push   $0x0
  801a25:	6a 00                	push   $0x0
  801a27:	6a 00                	push   $0x0
  801a29:	6a 04                	push   $0x4
  801a2b:	e8 63 ff ff ff       	call   801993 <syscall>
  801a30:	83 c4 18             	add    $0x18,%esp
}
  801a33:	90                   	nop
  801a34:	c9                   	leave  
  801a35:	c3                   	ret    

00801a36 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801a36:	55                   	push   %ebp
  801a37:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801a39:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3f:	6a 00                	push   $0x0
  801a41:	6a 00                	push   $0x0
  801a43:	6a 00                	push   $0x0
  801a45:	52                   	push   %edx
  801a46:	50                   	push   %eax
  801a47:	6a 08                	push   $0x8
  801a49:	e8 45 ff ff ff       	call   801993 <syscall>
  801a4e:	83 c4 18             	add    $0x18,%esp
}
  801a51:	c9                   	leave  
  801a52:	c3                   	ret    

00801a53 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801a53:	55                   	push   %ebp
  801a54:	89 e5                	mov    %esp,%ebp
  801a56:	56                   	push   %esi
  801a57:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801a58:	8b 75 18             	mov    0x18(%ebp),%esi
  801a5b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a5e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a61:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a64:	8b 45 08             	mov    0x8(%ebp),%eax
  801a67:	56                   	push   %esi
  801a68:	53                   	push   %ebx
  801a69:	51                   	push   %ecx
  801a6a:	52                   	push   %edx
  801a6b:	50                   	push   %eax
  801a6c:	6a 09                	push   $0x9
  801a6e:	e8 20 ff ff ff       	call   801993 <syscall>
  801a73:	83 c4 18             	add    $0x18,%esp
}
  801a76:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a79:	5b                   	pop    %ebx
  801a7a:	5e                   	pop    %esi
  801a7b:	5d                   	pop    %ebp
  801a7c:	c3                   	ret    

00801a7d <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801a7d:	55                   	push   %ebp
  801a7e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801a80:	6a 00                	push   $0x0
  801a82:	6a 00                	push   $0x0
  801a84:	6a 00                	push   $0x0
  801a86:	6a 00                	push   $0x0
  801a88:	ff 75 08             	pushl  0x8(%ebp)
  801a8b:	6a 0a                	push   $0xa
  801a8d:	e8 01 ff ff ff       	call   801993 <syscall>
  801a92:	83 c4 18             	add    $0x18,%esp
}
  801a95:	c9                   	leave  
  801a96:	c3                   	ret    

00801a97 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a97:	55                   	push   %ebp
  801a98:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 00                	push   $0x0
  801aa0:	ff 75 0c             	pushl  0xc(%ebp)
  801aa3:	ff 75 08             	pushl  0x8(%ebp)
  801aa6:	6a 0b                	push   $0xb
  801aa8:	e8 e6 fe ff ff       	call   801993 <syscall>
  801aad:	83 c4 18             	add    $0x18,%esp
}
  801ab0:	c9                   	leave  
  801ab1:	c3                   	ret    

00801ab2 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801ab2:	55                   	push   %ebp
  801ab3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801ab5:	6a 00                	push   $0x0
  801ab7:	6a 00                	push   $0x0
  801ab9:	6a 00                	push   $0x0
  801abb:	6a 00                	push   $0x0
  801abd:	6a 00                	push   $0x0
  801abf:	6a 0c                	push   $0xc
  801ac1:	e8 cd fe ff ff       	call   801993 <syscall>
  801ac6:	83 c4 18             	add    $0x18,%esp
}
  801ac9:	c9                   	leave  
  801aca:	c3                   	ret    

00801acb <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801acb:	55                   	push   %ebp
  801acc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801ace:	6a 00                	push   $0x0
  801ad0:	6a 00                	push   $0x0
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 00                	push   $0x0
  801ad6:	6a 00                	push   $0x0
  801ad8:	6a 0d                	push   $0xd
  801ada:	e8 b4 fe ff ff       	call   801993 <syscall>
  801adf:	83 c4 18             	add    $0x18,%esp
}
  801ae2:	c9                   	leave  
  801ae3:	c3                   	ret    

00801ae4 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801ae4:	55                   	push   %ebp
  801ae5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801ae7:	6a 00                	push   $0x0
  801ae9:	6a 00                	push   $0x0
  801aeb:	6a 00                	push   $0x0
  801aed:	6a 00                	push   $0x0
  801aef:	6a 00                	push   $0x0
  801af1:	6a 0e                	push   $0xe
  801af3:	e8 9b fe ff ff       	call   801993 <syscall>
  801af8:	83 c4 18             	add    $0x18,%esp
}
  801afb:	c9                   	leave  
  801afc:	c3                   	ret    

00801afd <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801afd:	55                   	push   %ebp
  801afe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801b00:	6a 00                	push   $0x0
  801b02:	6a 00                	push   $0x0
  801b04:	6a 00                	push   $0x0
  801b06:	6a 00                	push   $0x0
  801b08:	6a 00                	push   $0x0
  801b0a:	6a 0f                	push   $0xf
  801b0c:	e8 82 fe ff ff       	call   801993 <syscall>
  801b11:	83 c4 18             	add    $0x18,%esp
}
  801b14:	c9                   	leave  
  801b15:	c3                   	ret    

00801b16 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801b16:	55                   	push   %ebp
  801b17:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801b19:	6a 00                	push   $0x0
  801b1b:	6a 00                	push   $0x0
  801b1d:	6a 00                	push   $0x0
  801b1f:	6a 00                	push   $0x0
  801b21:	ff 75 08             	pushl  0x8(%ebp)
  801b24:	6a 10                	push   $0x10
  801b26:	e8 68 fe ff ff       	call   801993 <syscall>
  801b2b:	83 c4 18             	add    $0x18,%esp
}
  801b2e:	c9                   	leave  
  801b2f:	c3                   	ret    

00801b30 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801b30:	55                   	push   %ebp
  801b31:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801b33:	6a 00                	push   $0x0
  801b35:	6a 00                	push   $0x0
  801b37:	6a 00                	push   $0x0
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 11                	push   $0x11
  801b3f:	e8 4f fe ff ff       	call   801993 <syscall>
  801b44:	83 c4 18             	add    $0x18,%esp
}
  801b47:	90                   	nop
  801b48:	c9                   	leave  
  801b49:	c3                   	ret    

00801b4a <sys_cputc>:

void
sys_cputc(const char c)
{
  801b4a:	55                   	push   %ebp
  801b4b:	89 e5                	mov    %esp,%ebp
  801b4d:	83 ec 04             	sub    $0x4,%esp
  801b50:	8b 45 08             	mov    0x8(%ebp),%eax
  801b53:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b56:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b5a:	6a 00                	push   $0x0
  801b5c:	6a 00                	push   $0x0
  801b5e:	6a 00                	push   $0x0
  801b60:	6a 00                	push   $0x0
  801b62:	50                   	push   %eax
  801b63:	6a 01                	push   $0x1
  801b65:	e8 29 fe ff ff       	call   801993 <syscall>
  801b6a:	83 c4 18             	add    $0x18,%esp
}
  801b6d:	90                   	nop
  801b6e:	c9                   	leave  
  801b6f:	c3                   	ret    

00801b70 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b70:	55                   	push   %ebp
  801b71:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b73:	6a 00                	push   $0x0
  801b75:	6a 00                	push   $0x0
  801b77:	6a 00                	push   $0x0
  801b79:	6a 00                	push   $0x0
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 14                	push   $0x14
  801b7f:	e8 0f fe ff ff       	call   801993 <syscall>
  801b84:	83 c4 18             	add    $0x18,%esp
}
  801b87:	90                   	nop
  801b88:	c9                   	leave  
  801b89:	c3                   	ret    

00801b8a <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b8a:	55                   	push   %ebp
  801b8b:	89 e5                	mov    %esp,%ebp
  801b8d:	83 ec 04             	sub    $0x4,%esp
  801b90:	8b 45 10             	mov    0x10(%ebp),%eax
  801b93:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b96:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b99:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba0:	6a 00                	push   $0x0
  801ba2:	51                   	push   %ecx
  801ba3:	52                   	push   %edx
  801ba4:	ff 75 0c             	pushl  0xc(%ebp)
  801ba7:	50                   	push   %eax
  801ba8:	6a 15                	push   $0x15
  801baa:	e8 e4 fd ff ff       	call   801993 <syscall>
  801baf:	83 c4 18             	add    $0x18,%esp
}
  801bb2:	c9                   	leave  
  801bb3:	c3                   	ret    

00801bb4 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801bb4:	55                   	push   %ebp
  801bb5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801bb7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bba:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbd:	6a 00                	push   $0x0
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 00                	push   $0x0
  801bc3:	52                   	push   %edx
  801bc4:	50                   	push   %eax
  801bc5:	6a 16                	push   $0x16
  801bc7:	e8 c7 fd ff ff       	call   801993 <syscall>
  801bcc:	83 c4 18             	add    $0x18,%esp
}
  801bcf:	c9                   	leave  
  801bd0:	c3                   	ret    

00801bd1 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801bd1:	55                   	push   %ebp
  801bd2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801bd4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bd7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bda:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 00                	push   $0x0
  801be1:	51                   	push   %ecx
  801be2:	52                   	push   %edx
  801be3:	50                   	push   %eax
  801be4:	6a 17                	push   $0x17
  801be6:	e8 a8 fd ff ff       	call   801993 <syscall>
  801beb:	83 c4 18             	add    $0x18,%esp
}
  801bee:	c9                   	leave  
  801bef:	c3                   	ret    

00801bf0 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801bf0:	55                   	push   %ebp
  801bf1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801bf3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf9:	6a 00                	push   $0x0
  801bfb:	6a 00                	push   $0x0
  801bfd:	6a 00                	push   $0x0
  801bff:	52                   	push   %edx
  801c00:	50                   	push   %eax
  801c01:	6a 18                	push   $0x18
  801c03:	e8 8b fd ff ff       	call   801993 <syscall>
  801c08:	83 c4 18             	add    $0x18,%esp
}
  801c0b:	c9                   	leave  
  801c0c:	c3                   	ret    

00801c0d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c0d:	55                   	push   %ebp
  801c0e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c10:	8b 45 08             	mov    0x8(%ebp),%eax
  801c13:	6a 00                	push   $0x0
  801c15:	ff 75 14             	pushl  0x14(%ebp)
  801c18:	ff 75 10             	pushl  0x10(%ebp)
  801c1b:	ff 75 0c             	pushl  0xc(%ebp)
  801c1e:	50                   	push   %eax
  801c1f:	6a 19                	push   $0x19
  801c21:	e8 6d fd ff ff       	call   801993 <syscall>
  801c26:	83 c4 18             	add    $0x18,%esp
}
  801c29:	c9                   	leave  
  801c2a:	c3                   	ret    

00801c2b <sys_run_env>:

void sys_run_env(int32 envId)
{
  801c2b:	55                   	push   %ebp
  801c2c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c31:	6a 00                	push   $0x0
  801c33:	6a 00                	push   $0x0
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	50                   	push   %eax
  801c3a:	6a 1a                	push   $0x1a
  801c3c:	e8 52 fd ff ff       	call   801993 <syscall>
  801c41:	83 c4 18             	add    $0x18,%esp
}
  801c44:	90                   	nop
  801c45:	c9                   	leave  
  801c46:	c3                   	ret    

00801c47 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c47:	55                   	push   %ebp
  801c48:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4d:	6a 00                	push   $0x0
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	50                   	push   %eax
  801c56:	6a 1b                	push   $0x1b
  801c58:	e8 36 fd ff ff       	call   801993 <syscall>
  801c5d:	83 c4 18             	add    $0x18,%esp
}
  801c60:	c9                   	leave  
  801c61:	c3                   	ret    

00801c62 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c62:	55                   	push   %ebp
  801c63:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c65:	6a 00                	push   $0x0
  801c67:	6a 00                	push   $0x0
  801c69:	6a 00                	push   $0x0
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 05                	push   $0x5
  801c71:	e8 1d fd ff ff       	call   801993 <syscall>
  801c76:	83 c4 18             	add    $0x18,%esp
}
  801c79:	c9                   	leave  
  801c7a:	c3                   	ret    

00801c7b <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c7b:	55                   	push   %ebp
  801c7c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c7e:	6a 00                	push   $0x0
  801c80:	6a 00                	push   $0x0
  801c82:	6a 00                	push   $0x0
  801c84:	6a 00                	push   $0x0
  801c86:	6a 00                	push   $0x0
  801c88:	6a 06                	push   $0x6
  801c8a:	e8 04 fd ff ff       	call   801993 <syscall>
  801c8f:	83 c4 18             	add    $0x18,%esp
}
  801c92:	c9                   	leave  
  801c93:	c3                   	ret    

00801c94 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c94:	55                   	push   %ebp
  801c95:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c97:	6a 00                	push   $0x0
  801c99:	6a 00                	push   $0x0
  801c9b:	6a 00                	push   $0x0
  801c9d:	6a 00                	push   $0x0
  801c9f:	6a 00                	push   $0x0
  801ca1:	6a 07                	push   $0x7
  801ca3:	e8 eb fc ff ff       	call   801993 <syscall>
  801ca8:	83 c4 18             	add    $0x18,%esp
}
  801cab:	c9                   	leave  
  801cac:	c3                   	ret    

00801cad <sys_exit_env>:


void sys_exit_env(void)
{
  801cad:	55                   	push   %ebp
  801cae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801cb0:	6a 00                	push   $0x0
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 00                	push   $0x0
  801cb6:	6a 00                	push   $0x0
  801cb8:	6a 00                	push   $0x0
  801cba:	6a 1c                	push   $0x1c
  801cbc:	e8 d2 fc ff ff       	call   801993 <syscall>
  801cc1:	83 c4 18             	add    $0x18,%esp
}
  801cc4:	90                   	nop
  801cc5:	c9                   	leave  
  801cc6:	c3                   	ret    

00801cc7 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801cc7:	55                   	push   %ebp
  801cc8:	89 e5                	mov    %esp,%ebp
  801cca:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801ccd:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cd0:	8d 50 04             	lea    0x4(%eax),%edx
  801cd3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 00                	push   $0x0
  801cda:	6a 00                	push   $0x0
  801cdc:	52                   	push   %edx
  801cdd:	50                   	push   %eax
  801cde:	6a 1d                	push   $0x1d
  801ce0:	e8 ae fc ff ff       	call   801993 <syscall>
  801ce5:	83 c4 18             	add    $0x18,%esp
	return result;
  801ce8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ceb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801cee:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801cf1:	89 01                	mov    %eax,(%ecx)
  801cf3:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801cf6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf9:	c9                   	leave  
  801cfa:	c2 04 00             	ret    $0x4

00801cfd <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801cfd:	55                   	push   %ebp
  801cfe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d00:	6a 00                	push   $0x0
  801d02:	6a 00                	push   $0x0
  801d04:	ff 75 10             	pushl  0x10(%ebp)
  801d07:	ff 75 0c             	pushl  0xc(%ebp)
  801d0a:	ff 75 08             	pushl  0x8(%ebp)
  801d0d:	6a 13                	push   $0x13
  801d0f:	e8 7f fc ff ff       	call   801993 <syscall>
  801d14:	83 c4 18             	add    $0x18,%esp
	return ;
  801d17:	90                   	nop
}
  801d18:	c9                   	leave  
  801d19:	c3                   	ret    

00801d1a <sys_rcr2>:
uint32 sys_rcr2()
{
  801d1a:	55                   	push   %ebp
  801d1b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d1d:	6a 00                	push   $0x0
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 00                	push   $0x0
  801d23:	6a 00                	push   $0x0
  801d25:	6a 00                	push   $0x0
  801d27:	6a 1e                	push   $0x1e
  801d29:	e8 65 fc ff ff       	call   801993 <syscall>
  801d2e:	83 c4 18             	add    $0x18,%esp
}
  801d31:	c9                   	leave  
  801d32:	c3                   	ret    

00801d33 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801d33:	55                   	push   %ebp
  801d34:	89 e5                	mov    %esp,%ebp
  801d36:	83 ec 04             	sub    $0x4,%esp
  801d39:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d3f:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d43:	6a 00                	push   $0x0
  801d45:	6a 00                	push   $0x0
  801d47:	6a 00                	push   $0x0
  801d49:	6a 00                	push   $0x0
  801d4b:	50                   	push   %eax
  801d4c:	6a 1f                	push   $0x1f
  801d4e:	e8 40 fc ff ff       	call   801993 <syscall>
  801d53:	83 c4 18             	add    $0x18,%esp
	return ;
  801d56:	90                   	nop
}
  801d57:	c9                   	leave  
  801d58:	c3                   	ret    

00801d59 <rsttst>:
void rsttst()
{
  801d59:	55                   	push   %ebp
  801d5a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d5c:	6a 00                	push   $0x0
  801d5e:	6a 00                	push   $0x0
  801d60:	6a 00                	push   $0x0
  801d62:	6a 00                	push   $0x0
  801d64:	6a 00                	push   $0x0
  801d66:	6a 21                	push   $0x21
  801d68:	e8 26 fc ff ff       	call   801993 <syscall>
  801d6d:	83 c4 18             	add    $0x18,%esp
	return ;
  801d70:	90                   	nop
}
  801d71:	c9                   	leave  
  801d72:	c3                   	ret    

00801d73 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d73:	55                   	push   %ebp
  801d74:	89 e5                	mov    %esp,%ebp
  801d76:	83 ec 04             	sub    $0x4,%esp
  801d79:	8b 45 14             	mov    0x14(%ebp),%eax
  801d7c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d7f:	8b 55 18             	mov    0x18(%ebp),%edx
  801d82:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d86:	52                   	push   %edx
  801d87:	50                   	push   %eax
  801d88:	ff 75 10             	pushl  0x10(%ebp)
  801d8b:	ff 75 0c             	pushl  0xc(%ebp)
  801d8e:	ff 75 08             	pushl  0x8(%ebp)
  801d91:	6a 20                	push   $0x20
  801d93:	e8 fb fb ff ff       	call   801993 <syscall>
  801d98:	83 c4 18             	add    $0x18,%esp
	return ;
  801d9b:	90                   	nop
}
  801d9c:	c9                   	leave  
  801d9d:	c3                   	ret    

00801d9e <chktst>:
void chktst(uint32 n)
{
  801d9e:	55                   	push   %ebp
  801d9f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801da1:	6a 00                	push   $0x0
  801da3:	6a 00                	push   $0x0
  801da5:	6a 00                	push   $0x0
  801da7:	6a 00                	push   $0x0
  801da9:	ff 75 08             	pushl  0x8(%ebp)
  801dac:	6a 22                	push   $0x22
  801dae:	e8 e0 fb ff ff       	call   801993 <syscall>
  801db3:	83 c4 18             	add    $0x18,%esp
	return ;
  801db6:	90                   	nop
}
  801db7:	c9                   	leave  
  801db8:	c3                   	ret    

00801db9 <inctst>:

void inctst()
{
  801db9:	55                   	push   %ebp
  801dba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801dbc:	6a 00                	push   $0x0
  801dbe:	6a 00                	push   $0x0
  801dc0:	6a 00                	push   $0x0
  801dc2:	6a 00                	push   $0x0
  801dc4:	6a 00                	push   $0x0
  801dc6:	6a 23                	push   $0x23
  801dc8:	e8 c6 fb ff ff       	call   801993 <syscall>
  801dcd:	83 c4 18             	add    $0x18,%esp
	return ;
  801dd0:	90                   	nop
}
  801dd1:	c9                   	leave  
  801dd2:	c3                   	ret    

00801dd3 <gettst>:
uint32 gettst()
{
  801dd3:	55                   	push   %ebp
  801dd4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801dd6:	6a 00                	push   $0x0
  801dd8:	6a 00                	push   $0x0
  801dda:	6a 00                	push   $0x0
  801ddc:	6a 00                	push   $0x0
  801dde:	6a 00                	push   $0x0
  801de0:	6a 24                	push   $0x24
  801de2:	e8 ac fb ff ff       	call   801993 <syscall>
  801de7:	83 c4 18             	add    $0x18,%esp
}
  801dea:	c9                   	leave  
  801deb:	c3                   	ret    

00801dec <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801dec:	55                   	push   %ebp
  801ded:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801def:	6a 00                	push   $0x0
  801df1:	6a 00                	push   $0x0
  801df3:	6a 00                	push   $0x0
  801df5:	6a 00                	push   $0x0
  801df7:	6a 00                	push   $0x0
  801df9:	6a 25                	push   $0x25
  801dfb:	e8 93 fb ff ff       	call   801993 <syscall>
  801e00:	83 c4 18             	add    $0x18,%esp
  801e03:	a3 60 c0 81 00       	mov    %eax,0x81c060
	return uheapPlaceStrategy ;
  801e08:	a1 60 c0 81 00       	mov    0x81c060,%eax
}
  801e0d:	c9                   	leave  
  801e0e:	c3                   	ret    

00801e0f <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e0f:	55                   	push   %ebp
  801e10:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801e12:	8b 45 08             	mov    0x8(%ebp),%eax
  801e15:	a3 60 c0 81 00       	mov    %eax,0x81c060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e1a:	6a 00                	push   $0x0
  801e1c:	6a 00                	push   $0x0
  801e1e:	6a 00                	push   $0x0
  801e20:	6a 00                	push   $0x0
  801e22:	ff 75 08             	pushl  0x8(%ebp)
  801e25:	6a 26                	push   $0x26
  801e27:	e8 67 fb ff ff       	call   801993 <syscall>
  801e2c:	83 c4 18             	add    $0x18,%esp
	return ;
  801e2f:	90                   	nop
}
  801e30:	c9                   	leave  
  801e31:	c3                   	ret    

00801e32 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e32:	55                   	push   %ebp
  801e33:	89 e5                	mov    %esp,%ebp
  801e35:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e36:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e39:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e42:	6a 00                	push   $0x0
  801e44:	53                   	push   %ebx
  801e45:	51                   	push   %ecx
  801e46:	52                   	push   %edx
  801e47:	50                   	push   %eax
  801e48:	6a 27                	push   $0x27
  801e4a:	e8 44 fb ff ff       	call   801993 <syscall>
  801e4f:	83 c4 18             	add    $0x18,%esp
}
  801e52:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e55:	c9                   	leave  
  801e56:	c3                   	ret    

00801e57 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e57:	55                   	push   %ebp
  801e58:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e60:	6a 00                	push   $0x0
  801e62:	6a 00                	push   $0x0
  801e64:	6a 00                	push   $0x0
  801e66:	52                   	push   %edx
  801e67:	50                   	push   %eax
  801e68:	6a 28                	push   $0x28
  801e6a:	e8 24 fb ff ff       	call   801993 <syscall>
  801e6f:	83 c4 18             	add    $0x18,%esp
}
  801e72:	c9                   	leave  
  801e73:	c3                   	ret    

00801e74 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801e74:	55                   	push   %ebp
  801e75:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801e77:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801e7a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e80:	6a 00                	push   $0x0
  801e82:	51                   	push   %ecx
  801e83:	ff 75 10             	pushl  0x10(%ebp)
  801e86:	52                   	push   %edx
  801e87:	50                   	push   %eax
  801e88:	6a 29                	push   $0x29
  801e8a:	e8 04 fb ff ff       	call   801993 <syscall>
  801e8f:	83 c4 18             	add    $0x18,%esp
}
  801e92:	c9                   	leave  
  801e93:	c3                   	ret    

00801e94 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801e94:	55                   	push   %ebp
  801e95:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801e97:	6a 00                	push   $0x0
  801e99:	6a 00                	push   $0x0
  801e9b:	ff 75 10             	pushl  0x10(%ebp)
  801e9e:	ff 75 0c             	pushl  0xc(%ebp)
  801ea1:	ff 75 08             	pushl  0x8(%ebp)
  801ea4:	6a 12                	push   $0x12
  801ea6:	e8 e8 fa ff ff       	call   801993 <syscall>
  801eab:	83 c4 18             	add    $0x18,%esp
	return ;
  801eae:	90                   	nop
}
  801eaf:	c9                   	leave  
  801eb0:	c3                   	ret    

00801eb1 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801eb1:	55                   	push   %ebp
  801eb2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801eb4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eba:	6a 00                	push   $0x0
  801ebc:	6a 00                	push   $0x0
  801ebe:	6a 00                	push   $0x0
  801ec0:	52                   	push   %edx
  801ec1:	50                   	push   %eax
  801ec2:	6a 2a                	push   $0x2a
  801ec4:	e8 ca fa ff ff       	call   801993 <syscall>
  801ec9:	83 c4 18             	add    $0x18,%esp
	return;
  801ecc:	90                   	nop
}
  801ecd:	c9                   	leave  
  801ece:	c3                   	ret    

00801ecf <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801ecf:	55                   	push   %ebp
  801ed0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801ed2:	6a 00                	push   $0x0
  801ed4:	6a 00                	push   $0x0
  801ed6:	6a 00                	push   $0x0
  801ed8:	6a 00                	push   $0x0
  801eda:	6a 00                	push   $0x0
  801edc:	6a 2b                	push   $0x2b
  801ede:	e8 b0 fa ff ff       	call   801993 <syscall>
  801ee3:	83 c4 18             	add    $0x18,%esp
}
  801ee6:	c9                   	leave  
  801ee7:	c3                   	ret    

00801ee8 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801ee8:	55                   	push   %ebp
  801ee9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801eeb:	6a 00                	push   $0x0
  801eed:	6a 00                	push   $0x0
  801eef:	6a 00                	push   $0x0
  801ef1:	ff 75 0c             	pushl  0xc(%ebp)
  801ef4:	ff 75 08             	pushl  0x8(%ebp)
  801ef7:	6a 2d                	push   $0x2d
  801ef9:	e8 95 fa ff ff       	call   801993 <syscall>
  801efe:	83 c4 18             	add    $0x18,%esp
	return;
  801f01:	90                   	nop
}
  801f02:	c9                   	leave  
  801f03:	c3                   	ret    

00801f04 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801f04:	55                   	push   %ebp
  801f05:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801f07:	6a 00                	push   $0x0
  801f09:	6a 00                	push   $0x0
  801f0b:	6a 00                	push   $0x0
  801f0d:	ff 75 0c             	pushl  0xc(%ebp)
  801f10:	ff 75 08             	pushl  0x8(%ebp)
  801f13:	6a 2c                	push   $0x2c
  801f15:	e8 79 fa ff ff       	call   801993 <syscall>
  801f1a:	83 c4 18             	add    $0x18,%esp
	return ;
  801f1d:	90                   	nop
}
  801f1e:	c9                   	leave  
  801f1f:	c3                   	ret    

00801f20 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801f20:	55                   	push   %ebp
  801f21:	89 e5                	mov    %esp,%ebp
  801f23:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801f26:	83 ec 04             	sub    $0x4,%esp
  801f29:	68 14 2e 80 00       	push   $0x802e14
  801f2e:	68 25 01 00 00       	push   $0x125
  801f33:	68 47 2e 80 00       	push   $0x802e47
  801f38:	e8 bb 01 00 00       	call   8020f8 <_panic>

00801f3d <to_page_va>:
//==================================================================================//
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  801f3d:	55                   	push   %ebp
  801f3e:	89 e5                	mov    %esp,%ebp
  801f40:	83 ec 10             	sub    $0x10,%esp
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  801f43:	8b 45 08             	mov    0x8(%ebp),%eax
  801f46:	ba 60 40 80 00       	mov    $0x804060,%edx
  801f4b:	29 d0                	sub    %edx,%eax
  801f4d:	c1 f8 02             	sar    $0x2,%eax
  801f50:	89 c2                	mov    %eax,%edx
  801f52:	89 d0                	mov    %edx,%eax
  801f54:	c1 e0 02             	shl    $0x2,%eax
  801f57:	01 d0                	add    %edx,%eax
  801f59:	c1 e0 02             	shl    $0x2,%eax
  801f5c:	01 d0                	add    %edx,%eax
  801f5e:	c1 e0 02             	shl    $0x2,%eax
  801f61:	01 d0                	add    %edx,%eax
  801f63:	89 c1                	mov    %eax,%ecx
  801f65:	c1 e1 08             	shl    $0x8,%ecx
  801f68:	01 c8                	add    %ecx,%eax
  801f6a:	89 c1                	mov    %eax,%ecx
  801f6c:	c1 e1 10             	shl    $0x10,%ecx
  801f6f:	01 c8                	add    %ecx,%eax
  801f71:	01 c0                	add    %eax,%eax
  801f73:	01 d0                	add    %edx,%eax
  801f75:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  801f78:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f7b:	c1 e0 0c             	shl    $0xc,%eax
  801f7e:	89 c2                	mov    %eax,%edx
  801f80:	a1 64 c0 81 00       	mov    0x81c064,%eax
  801f85:	01 d0                	add    %edx,%eax
}
  801f87:	c9                   	leave  
  801f88:	c3                   	ret    

00801f89 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  801f89:	55                   	push   %ebp
  801f8a:	89 e5                	mov    %esp,%ebp
  801f8c:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  801f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f92:	05 00 00 00 02       	add    $0x2000000,%eax
  801f97:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801f9a:	73 16                	jae    801fb2 <initialize_dynamic_allocator+0x29>
  801f9c:	68 58 2e 80 00       	push   $0x802e58
  801fa1:	68 7e 2e 80 00       	push   $0x802e7e
  801fa6:	6a 26                	push   $0x26
  801fa8:	68 93 2e 80 00       	push   $0x802e93
  801fad:	e8 46 01 00 00       	call   8020f8 <_panic>
		is_initialized = 1;
  801fb2:	c7 05 24 40 80 00 01 	movl   $0x1,0x804024
  801fb9:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	//Comment the following line
	panic("initialize_dynamic_allocator() Not implemented yet");
  801fbc:	83 ec 04             	sub    $0x4,%esp
  801fbf:	68 ac 2e 80 00       	push   $0x802eac
  801fc4:	6a 2e                	push   $0x2e
  801fc6:	68 93 2e 80 00       	push   $0x802e93
  801fcb:	e8 28 01 00 00       	call   8020f8 <_panic>

00801fd0 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  801fd0:	55                   	push   %ebp
  801fd1:	89 e5                	mov    %esp,%ebp
  801fd3:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	//Comment the following line
	panic("get_block_size() Not implemented yet");
  801fd6:	83 ec 04             	sub    $0x4,%esp
  801fd9:	68 e0 2e 80 00       	push   $0x802ee0
  801fde:	6a 3a                	push   $0x3a
  801fe0:	68 93 2e 80 00       	push   $0x802e93
  801fe5:	e8 0e 01 00 00       	call   8020f8 <_panic>

00801fea <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  801fea:	55                   	push   %ebp
  801feb:	89 e5                	mov    %esp,%ebp
  801fed:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  801ff0:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801ff7:	76 16                	jbe    80200f <alloc_block+0x25>
  801ff9:	68 08 2f 80 00       	push   $0x802f08
  801ffe:	68 7e 2e 80 00       	push   $0x802e7e
  802003:	6a 46                	push   $0x46
  802005:	68 93 2e 80 00       	push   $0x802e93
  80200a:	e8 e9 00 00 00       	call   8020f8 <_panic>
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	panic("alloc_block() Not implemented yet");
  80200f:	83 ec 04             	sub    $0x4,%esp
  802012:	68 2c 2f 80 00       	push   $0x802f2c
  802017:	6a 4d                	push   $0x4d
  802019:	68 93 2e 80 00       	push   $0x802e93
  80201e:	e8 d5 00 00 00       	call   8020f8 <_panic>

00802023 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  802023:	55                   	push   %ebp
  802024:	89 e5                	mov    %esp,%ebp
  802026:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  802029:	8b 55 08             	mov    0x8(%ebp),%edx
  80202c:	a1 64 c0 81 00       	mov    0x81c064,%eax
  802031:	39 c2                	cmp    %eax,%edx
  802033:	72 0c                	jb     802041 <free_block+0x1e>
  802035:	8b 55 08             	mov    0x8(%ebp),%edx
  802038:	a1 40 40 80 00       	mov    0x804040,%eax
  80203d:	39 c2                	cmp    %eax,%edx
  80203f:	72 16                	jb     802057 <free_block+0x34>
  802041:	68 50 2f 80 00       	push   $0x802f50
  802046:	68 7e 2e 80 00       	push   $0x802e7e
  80204b:	6a 5b                	push   $0x5b
  80204d:	68 93 2e 80 00       	push   $0x802e93
  802052:	e8 a1 00 00 00       	call   8020f8 <_panic>
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	panic("free_block() Not implemented yet");
  802057:	83 ec 04             	sub    $0x4,%esp
  80205a:	68 88 2f 80 00       	push   $0x802f88
  80205f:	6a 63                	push   $0x63
  802061:	68 93 2e 80 00       	push   $0x802e93
  802066:	e8 8d 00 00 00       	call   8020f8 <_panic>

0080206b <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  80206b:	55                   	push   %ebp
  80206c:	89 e5                	mov    %esp,%ebp
  80206e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  802071:	83 ec 04             	sub    $0x4,%esp
  802074:	68 ac 2f 80 00       	push   $0x802fac
  802079:	6a 72                	push   $0x72
  80207b:	68 93 2e 80 00       	push   $0x802e93
  802080:	e8 73 00 00 00       	call   8020f8 <_panic>

00802085 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  802085:	55                   	push   %ebp
  802086:	89 e5                	mov    %esp,%ebp
  802088:	83 ec 08             	sub    $0x8,%esp
	panic("create_semaphore() is not implemented yet...!!");
  80208b:	83 ec 04             	sub    $0x4,%esp
  80208e:	68 d0 2f 80 00       	push   $0x802fd0
  802093:	6a 07                	push   $0x7
  802095:	68 ff 2f 80 00       	push   $0x802fff
  80209a:	e8 59 00 00 00       	call   8020f8 <_panic>

0080209f <get_semaphore>:
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  80209f:	55                   	push   %ebp
  8020a0:	89 e5                	mov    %esp,%ebp
  8020a2:	83 ec 08             	sub    $0x8,%esp
	panic("get_semaphore() is not implemented yet...!!");
  8020a5:	83 ec 04             	sub    $0x4,%esp
  8020a8:	68 10 30 80 00       	push   $0x803010
  8020ad:	6a 0b                	push   $0xb
  8020af:	68 ff 2f 80 00       	push   $0x802fff
  8020b4:	e8 3f 00 00 00       	call   8020f8 <_panic>

008020b9 <wait_semaphore>:
}

void wait_semaphore(struct semaphore sem)
{
  8020b9:	55                   	push   %ebp
  8020ba:	89 e5                	mov    %esp,%ebp
  8020bc:	83 ec 08             	sub    $0x8,%esp
	panic("wait_semaphore() is not implemented yet...!!");
  8020bf:	83 ec 04             	sub    $0x4,%esp
  8020c2:	68 3c 30 80 00       	push   $0x80303c
  8020c7:	6a 10                	push   $0x10
  8020c9:	68 ff 2f 80 00       	push   $0x802fff
  8020ce:	e8 25 00 00 00       	call   8020f8 <_panic>

008020d3 <signal_semaphore>:
}

void signal_semaphore(struct semaphore sem)
{
  8020d3:	55                   	push   %ebp
  8020d4:	89 e5                	mov    %esp,%ebp
  8020d6:	83 ec 08             	sub    $0x8,%esp
	panic("signal_semaphore() is not implemented yet...!!");
  8020d9:	83 ec 04             	sub    $0x4,%esp
  8020dc:	68 6c 30 80 00       	push   $0x80306c
  8020e1:	6a 15                	push   $0x15
  8020e3:	68 ff 2f 80 00       	push   $0x802fff
  8020e8:	e8 0b 00 00 00       	call   8020f8 <_panic>

008020ed <semaphore_count>:
}

int semaphore_count(struct semaphore sem)
{
  8020ed:	55                   	push   %ebp
  8020ee:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  8020f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f3:	8b 40 10             	mov    0x10(%eax),%eax
}
  8020f6:	5d                   	pop    %ebp
  8020f7:	c3                   	ret    

008020f8 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8020f8:	55                   	push   %ebp
  8020f9:	89 e5                	mov    %esp,%ebp
  8020fb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8020fe:	8d 45 10             	lea    0x10(%ebp),%eax
  802101:	83 c0 04             	add    $0x4,%eax
  802104:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  802107:	a1 1c c1 81 00       	mov    0x81c11c,%eax
  80210c:	85 c0                	test   %eax,%eax
  80210e:	74 16                	je     802126 <_panic+0x2e>
		cprintf("%s: ", argv0);
  802110:	a1 1c c1 81 00       	mov    0x81c11c,%eax
  802115:	83 ec 08             	sub    $0x8,%esp
  802118:	50                   	push   %eax
  802119:	68 9c 30 80 00       	push   $0x80309c
  80211e:	e8 d4 e7 ff ff       	call   8008f7 <cprintf>
  802123:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  802126:	a1 04 40 80 00       	mov    0x804004,%eax
  80212b:	83 ec 0c             	sub    $0xc,%esp
  80212e:	ff 75 0c             	pushl  0xc(%ebp)
  802131:	ff 75 08             	pushl  0x8(%ebp)
  802134:	50                   	push   %eax
  802135:	68 a4 30 80 00       	push   $0x8030a4
  80213a:	6a 74                	push   $0x74
  80213c:	e8 e3 e7 ff ff       	call   800924 <cprintf_colored>
  802141:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  802144:	8b 45 10             	mov    0x10(%ebp),%eax
  802147:	83 ec 08             	sub    $0x8,%esp
  80214a:	ff 75 f4             	pushl  -0xc(%ebp)
  80214d:	50                   	push   %eax
  80214e:	e8 35 e7 ff ff       	call   800888 <vcprintf>
  802153:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  802156:	83 ec 08             	sub    $0x8,%esp
  802159:	6a 00                	push   $0x0
  80215b:	68 cc 30 80 00       	push   $0x8030cc
  802160:	e8 23 e7 ff ff       	call   800888 <vcprintf>
  802165:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  802168:	e8 9c e6 ff ff       	call   800809 <exit>

	// should not return here
	while (1) ;
  80216d:	eb fe                	jmp    80216d <_panic+0x75>

0080216f <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80216f:	55                   	push   %ebp
  802170:	89 e5                	mov    %esp,%ebp
  802172:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  802175:	a1 20 40 80 00       	mov    0x804020,%eax
  80217a:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  802180:	8b 45 0c             	mov    0xc(%ebp),%eax
  802183:	39 c2                	cmp    %eax,%edx
  802185:	74 14                	je     80219b <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  802187:	83 ec 04             	sub    $0x4,%esp
  80218a:	68 d0 30 80 00       	push   $0x8030d0
  80218f:	6a 26                	push   $0x26
  802191:	68 1c 31 80 00       	push   $0x80311c
  802196:	e8 5d ff ff ff       	call   8020f8 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80219b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8021a2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8021a9:	e9 c5 00 00 00       	jmp    802273 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8021ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021b1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8021b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bb:	01 d0                	add    %edx,%eax
  8021bd:	8b 00                	mov    (%eax),%eax
  8021bf:	85 c0                	test   %eax,%eax
  8021c1:	75 08                	jne    8021cb <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8021c3:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8021c6:	e9 a5 00 00 00       	jmp    802270 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8021cb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8021d2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8021d9:	eb 69                	jmp    802244 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8021db:	a1 20 40 80 00       	mov    0x804020,%eax
  8021e0:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8021e6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8021e9:	89 d0                	mov    %edx,%eax
  8021eb:	01 c0                	add    %eax,%eax
  8021ed:	01 d0                	add    %edx,%eax
  8021ef:	c1 e0 03             	shl    $0x3,%eax
  8021f2:	01 c8                	add    %ecx,%eax
  8021f4:	8a 40 04             	mov    0x4(%eax),%al
  8021f7:	84 c0                	test   %al,%al
  8021f9:	75 46                	jne    802241 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8021fb:	a1 20 40 80 00       	mov    0x804020,%eax
  802200:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  802206:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802209:	89 d0                	mov    %edx,%eax
  80220b:	01 c0                	add    %eax,%eax
  80220d:	01 d0                	add    %edx,%eax
  80220f:	c1 e0 03             	shl    $0x3,%eax
  802212:	01 c8                	add    %ecx,%eax
  802214:	8b 00                	mov    (%eax),%eax
  802216:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802219:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80221c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802221:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  802223:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802226:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80222d:	8b 45 08             	mov    0x8(%ebp),%eax
  802230:	01 c8                	add    %ecx,%eax
  802232:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  802234:	39 c2                	cmp    %eax,%edx
  802236:	75 09                	jne    802241 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  802238:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80223f:	eb 15                	jmp    802256 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802241:	ff 45 e8             	incl   -0x18(%ebp)
  802244:	a1 20 40 80 00       	mov    0x804020,%eax
  802249:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80224f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802252:	39 c2                	cmp    %eax,%edx
  802254:	77 85                	ja     8021db <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  802256:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80225a:	75 14                	jne    802270 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80225c:	83 ec 04             	sub    $0x4,%esp
  80225f:	68 28 31 80 00       	push   $0x803128
  802264:	6a 3a                	push   $0x3a
  802266:	68 1c 31 80 00       	push   $0x80311c
  80226b:	e8 88 fe ff ff       	call   8020f8 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  802270:	ff 45 f0             	incl   -0x10(%ebp)
  802273:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802276:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802279:	0f 8c 2f ff ff ff    	jl     8021ae <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80227f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802286:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80228d:	eb 26                	jmp    8022b5 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80228f:	a1 20 40 80 00       	mov    0x804020,%eax
  802294:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80229a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80229d:	89 d0                	mov    %edx,%eax
  80229f:	01 c0                	add    %eax,%eax
  8022a1:	01 d0                	add    %edx,%eax
  8022a3:	c1 e0 03             	shl    $0x3,%eax
  8022a6:	01 c8                	add    %ecx,%eax
  8022a8:	8a 40 04             	mov    0x4(%eax),%al
  8022ab:	3c 01                	cmp    $0x1,%al
  8022ad:	75 03                	jne    8022b2 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8022af:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8022b2:	ff 45 e0             	incl   -0x20(%ebp)
  8022b5:	a1 20 40 80 00       	mov    0x804020,%eax
  8022ba:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8022c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022c3:	39 c2                	cmp    %eax,%edx
  8022c5:	77 c8                	ja     80228f <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8022c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ca:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8022cd:	74 14                	je     8022e3 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8022cf:	83 ec 04             	sub    $0x4,%esp
  8022d2:	68 7c 31 80 00       	push   $0x80317c
  8022d7:	6a 44                	push   $0x44
  8022d9:	68 1c 31 80 00       	push   $0x80311c
  8022de:	e8 15 fe ff ff       	call   8020f8 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8022e3:	90                   	nop
  8022e4:	c9                   	leave  
  8022e5:	c3                   	ret    
  8022e6:	66 90                	xchg   %ax,%ax

008022e8 <__divdi3>:
  8022e8:	55                   	push   %ebp
  8022e9:	57                   	push   %edi
  8022ea:	56                   	push   %esi
  8022eb:	53                   	push   %ebx
  8022ec:	83 ec 1c             	sub    $0x1c,%esp
  8022ef:	8b 44 24 30          	mov    0x30(%esp),%eax
  8022f3:	8b 54 24 34          	mov    0x34(%esp),%edx
  8022f7:	8b 74 24 38          	mov    0x38(%esp),%esi
  8022fb:	8b 7c 24 3c          	mov    0x3c(%esp),%edi
  8022ff:	89 f9                	mov    %edi,%ecx
  802301:	85 d2                	test   %edx,%edx
  802303:	0f 88 bb 00 00 00    	js     8023c4 <__divdi3+0xdc>
  802309:	31 ed                	xor    %ebp,%ebp
  80230b:	85 c9                	test   %ecx,%ecx
  80230d:	0f 88 99 00 00 00    	js     8023ac <__divdi3+0xc4>
  802313:	89 34 24             	mov    %esi,(%esp)
  802316:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80231a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80231e:	89 d3                	mov    %edx,%ebx
  802320:	8b 34 24             	mov    (%esp),%esi
  802323:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802327:	89 74 24 08          	mov    %esi,0x8(%esp)
  80232b:	8b 34 24             	mov    (%esp),%esi
  80232e:	89 c1                	mov    %eax,%ecx
  802330:	85 ff                	test   %edi,%edi
  802332:	75 10                	jne    802344 <__divdi3+0x5c>
  802334:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802338:	39 d7                	cmp    %edx,%edi
  80233a:	76 4c                	jbe    802388 <__divdi3+0xa0>
  80233c:	f7 f7                	div    %edi
  80233e:	89 c1                	mov    %eax,%ecx
  802340:	31 f6                	xor    %esi,%esi
  802342:	eb 08                	jmp    80234c <__divdi3+0x64>
  802344:	39 d7                	cmp    %edx,%edi
  802346:	76 1c                	jbe    802364 <__divdi3+0x7c>
  802348:	31 f6                	xor    %esi,%esi
  80234a:	31 c9                	xor    %ecx,%ecx
  80234c:	89 c8                	mov    %ecx,%eax
  80234e:	89 f2                	mov    %esi,%edx
  802350:	85 ed                	test   %ebp,%ebp
  802352:	74 07                	je     80235b <__divdi3+0x73>
  802354:	f7 d8                	neg    %eax
  802356:	83 d2 00             	adc    $0x0,%edx
  802359:	f7 da                	neg    %edx
  80235b:	83 c4 1c             	add    $0x1c,%esp
  80235e:	5b                   	pop    %ebx
  80235f:	5e                   	pop    %esi
  802360:	5f                   	pop    %edi
  802361:	5d                   	pop    %ebp
  802362:	c3                   	ret    
  802363:	90                   	nop
  802364:	0f bd f7             	bsr    %edi,%esi
  802367:	83 f6 1f             	xor    $0x1f,%esi
  80236a:	75 6c                	jne    8023d8 <__divdi3+0xf0>
  80236c:	39 d7                	cmp    %edx,%edi
  80236e:	72 0e                	jb     80237e <__divdi3+0x96>
  802370:	8b 7c 24 0c          	mov    0xc(%esp),%edi
  802374:	39 7c 24 08          	cmp    %edi,0x8(%esp)
  802378:	0f 87 ca 00 00 00    	ja     802448 <__divdi3+0x160>
  80237e:	b9 01 00 00 00       	mov    $0x1,%ecx
  802383:	eb c7                	jmp    80234c <__divdi3+0x64>
  802385:	8d 76 00             	lea    0x0(%esi),%esi
  802388:	85 f6                	test   %esi,%esi
  80238a:	75 0b                	jne    802397 <__divdi3+0xaf>
  80238c:	b8 01 00 00 00       	mov    $0x1,%eax
  802391:	31 d2                	xor    %edx,%edx
  802393:	f7 f6                	div    %esi
  802395:	89 c6                	mov    %eax,%esi
  802397:	31 d2                	xor    %edx,%edx
  802399:	89 d8                	mov    %ebx,%eax
  80239b:	f7 f6                	div    %esi
  80239d:	89 c7                	mov    %eax,%edi
  80239f:	89 c8                	mov    %ecx,%eax
  8023a1:	f7 f6                	div    %esi
  8023a3:	89 c1                	mov    %eax,%ecx
  8023a5:	89 fe                	mov    %edi,%esi
  8023a7:	eb a3                	jmp    80234c <__divdi3+0x64>
  8023a9:	8d 76 00             	lea    0x0(%esi),%esi
  8023ac:	f7 d5                	not    %ebp
  8023ae:	f7 de                	neg    %esi
  8023b0:	83 d7 00             	adc    $0x0,%edi
  8023b3:	f7 df                	neg    %edi
  8023b5:	89 34 24             	mov    %esi,(%esp)
  8023b8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8023bc:	e9 59 ff ff ff       	jmp    80231a <__divdi3+0x32>
  8023c1:	8d 76 00             	lea    0x0(%esi),%esi
  8023c4:	f7 d8                	neg    %eax
  8023c6:	83 d2 00             	adc    $0x0,%edx
  8023c9:	f7 da                	neg    %edx
  8023cb:	bd ff ff ff ff       	mov    $0xffffffff,%ebp
  8023d0:	e9 36 ff ff ff       	jmp    80230b <__divdi3+0x23>
  8023d5:	8d 76 00             	lea    0x0(%esi),%esi
  8023d8:	b8 20 00 00 00       	mov    $0x20,%eax
  8023dd:	29 f0                	sub    %esi,%eax
  8023df:	89 f1                	mov    %esi,%ecx
  8023e1:	d3 e7                	shl    %cl,%edi
  8023e3:	8b 54 24 08          	mov    0x8(%esp),%edx
  8023e7:	88 c1                	mov    %al,%cl
  8023e9:	d3 ea                	shr    %cl,%edx
  8023eb:	89 d1                	mov    %edx,%ecx
  8023ed:	09 f9                	or     %edi,%ecx
  8023ef:	89 0c 24             	mov    %ecx,(%esp)
  8023f2:	8b 54 24 08          	mov    0x8(%esp),%edx
  8023f6:	89 f1                	mov    %esi,%ecx
  8023f8:	d3 e2                	shl    %cl,%edx
  8023fa:	89 54 24 08          	mov    %edx,0x8(%esp)
  8023fe:	89 df                	mov    %ebx,%edi
  802400:	88 c1                	mov    %al,%cl
  802402:	d3 ef                	shr    %cl,%edi
  802404:	89 f1                	mov    %esi,%ecx
  802406:	d3 e3                	shl    %cl,%ebx
  802408:	8b 54 24 0c          	mov    0xc(%esp),%edx
  80240c:	88 c1                	mov    %al,%cl
  80240e:	d3 ea                	shr    %cl,%edx
  802410:	09 d3                	or     %edx,%ebx
  802412:	89 d8                	mov    %ebx,%eax
  802414:	89 fa                	mov    %edi,%edx
  802416:	f7 34 24             	divl   (%esp)
  802419:	89 d1                	mov    %edx,%ecx
  80241b:	89 c3                	mov    %eax,%ebx
  80241d:	f7 64 24 08          	mull   0x8(%esp)
  802421:	39 d1                	cmp    %edx,%ecx
  802423:	72 17                	jb     80243c <__divdi3+0x154>
  802425:	74 09                	je     802430 <__divdi3+0x148>
  802427:	89 d9                	mov    %ebx,%ecx
  802429:	31 f6                	xor    %esi,%esi
  80242b:	e9 1c ff ff ff       	jmp    80234c <__divdi3+0x64>
  802430:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802434:	89 f1                	mov    %esi,%ecx
  802436:	d3 e2                	shl    %cl,%edx
  802438:	39 c2                	cmp    %eax,%edx
  80243a:	73 eb                	jae    802427 <__divdi3+0x13f>
  80243c:	8d 4b ff             	lea    -0x1(%ebx),%ecx
  80243f:	31 f6                	xor    %esi,%esi
  802441:	e9 06 ff ff ff       	jmp    80234c <__divdi3+0x64>
  802446:	66 90                	xchg   %ax,%ax
  802448:	31 c9                	xor    %ecx,%ecx
  80244a:	e9 fd fe ff ff       	jmp    80234c <__divdi3+0x64>
  80244f:	90                   	nop

00802450 <__udivdi3>:
  802450:	55                   	push   %ebp
  802451:	57                   	push   %edi
  802452:	56                   	push   %esi
  802453:	53                   	push   %ebx
  802454:	83 ec 1c             	sub    $0x1c,%esp
  802457:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80245b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80245f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802463:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802467:	89 ca                	mov    %ecx,%edx
  802469:	89 f8                	mov    %edi,%eax
  80246b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80246f:	85 f6                	test   %esi,%esi
  802471:	75 2d                	jne    8024a0 <__udivdi3+0x50>
  802473:	39 cf                	cmp    %ecx,%edi
  802475:	77 65                	ja     8024dc <__udivdi3+0x8c>
  802477:	89 fd                	mov    %edi,%ebp
  802479:	85 ff                	test   %edi,%edi
  80247b:	75 0b                	jne    802488 <__udivdi3+0x38>
  80247d:	b8 01 00 00 00       	mov    $0x1,%eax
  802482:	31 d2                	xor    %edx,%edx
  802484:	f7 f7                	div    %edi
  802486:	89 c5                	mov    %eax,%ebp
  802488:	31 d2                	xor    %edx,%edx
  80248a:	89 c8                	mov    %ecx,%eax
  80248c:	f7 f5                	div    %ebp
  80248e:	89 c1                	mov    %eax,%ecx
  802490:	89 d8                	mov    %ebx,%eax
  802492:	f7 f5                	div    %ebp
  802494:	89 cf                	mov    %ecx,%edi
  802496:	89 fa                	mov    %edi,%edx
  802498:	83 c4 1c             	add    $0x1c,%esp
  80249b:	5b                   	pop    %ebx
  80249c:	5e                   	pop    %esi
  80249d:	5f                   	pop    %edi
  80249e:	5d                   	pop    %ebp
  80249f:	c3                   	ret    
  8024a0:	39 ce                	cmp    %ecx,%esi
  8024a2:	77 28                	ja     8024cc <__udivdi3+0x7c>
  8024a4:	0f bd fe             	bsr    %esi,%edi
  8024a7:	83 f7 1f             	xor    $0x1f,%edi
  8024aa:	75 40                	jne    8024ec <__udivdi3+0x9c>
  8024ac:	39 ce                	cmp    %ecx,%esi
  8024ae:	72 0a                	jb     8024ba <__udivdi3+0x6a>
  8024b0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8024b4:	0f 87 9e 00 00 00    	ja     802558 <__udivdi3+0x108>
  8024ba:	b8 01 00 00 00       	mov    $0x1,%eax
  8024bf:	89 fa                	mov    %edi,%edx
  8024c1:	83 c4 1c             	add    $0x1c,%esp
  8024c4:	5b                   	pop    %ebx
  8024c5:	5e                   	pop    %esi
  8024c6:	5f                   	pop    %edi
  8024c7:	5d                   	pop    %ebp
  8024c8:	c3                   	ret    
  8024c9:	8d 76 00             	lea    0x0(%esi),%esi
  8024cc:	31 ff                	xor    %edi,%edi
  8024ce:	31 c0                	xor    %eax,%eax
  8024d0:	89 fa                	mov    %edi,%edx
  8024d2:	83 c4 1c             	add    $0x1c,%esp
  8024d5:	5b                   	pop    %ebx
  8024d6:	5e                   	pop    %esi
  8024d7:	5f                   	pop    %edi
  8024d8:	5d                   	pop    %ebp
  8024d9:	c3                   	ret    
  8024da:	66 90                	xchg   %ax,%ax
  8024dc:	89 d8                	mov    %ebx,%eax
  8024de:	f7 f7                	div    %edi
  8024e0:	31 ff                	xor    %edi,%edi
  8024e2:	89 fa                	mov    %edi,%edx
  8024e4:	83 c4 1c             	add    $0x1c,%esp
  8024e7:	5b                   	pop    %ebx
  8024e8:	5e                   	pop    %esi
  8024e9:	5f                   	pop    %edi
  8024ea:	5d                   	pop    %ebp
  8024eb:	c3                   	ret    
  8024ec:	bd 20 00 00 00       	mov    $0x20,%ebp
  8024f1:	89 eb                	mov    %ebp,%ebx
  8024f3:	29 fb                	sub    %edi,%ebx
  8024f5:	89 f9                	mov    %edi,%ecx
  8024f7:	d3 e6                	shl    %cl,%esi
  8024f9:	89 c5                	mov    %eax,%ebp
  8024fb:	88 d9                	mov    %bl,%cl
  8024fd:	d3 ed                	shr    %cl,%ebp
  8024ff:	89 e9                	mov    %ebp,%ecx
  802501:	09 f1                	or     %esi,%ecx
  802503:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802507:	89 f9                	mov    %edi,%ecx
  802509:	d3 e0                	shl    %cl,%eax
  80250b:	89 c5                	mov    %eax,%ebp
  80250d:	89 d6                	mov    %edx,%esi
  80250f:	88 d9                	mov    %bl,%cl
  802511:	d3 ee                	shr    %cl,%esi
  802513:	89 f9                	mov    %edi,%ecx
  802515:	d3 e2                	shl    %cl,%edx
  802517:	8b 44 24 08          	mov    0x8(%esp),%eax
  80251b:	88 d9                	mov    %bl,%cl
  80251d:	d3 e8                	shr    %cl,%eax
  80251f:	09 c2                	or     %eax,%edx
  802521:	89 d0                	mov    %edx,%eax
  802523:	89 f2                	mov    %esi,%edx
  802525:	f7 74 24 0c          	divl   0xc(%esp)
  802529:	89 d6                	mov    %edx,%esi
  80252b:	89 c3                	mov    %eax,%ebx
  80252d:	f7 e5                	mul    %ebp
  80252f:	39 d6                	cmp    %edx,%esi
  802531:	72 19                	jb     80254c <__udivdi3+0xfc>
  802533:	74 0b                	je     802540 <__udivdi3+0xf0>
  802535:	89 d8                	mov    %ebx,%eax
  802537:	31 ff                	xor    %edi,%edi
  802539:	e9 58 ff ff ff       	jmp    802496 <__udivdi3+0x46>
  80253e:	66 90                	xchg   %ax,%ax
  802540:	8b 54 24 08          	mov    0x8(%esp),%edx
  802544:	89 f9                	mov    %edi,%ecx
  802546:	d3 e2                	shl    %cl,%edx
  802548:	39 c2                	cmp    %eax,%edx
  80254a:	73 e9                	jae    802535 <__udivdi3+0xe5>
  80254c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80254f:	31 ff                	xor    %edi,%edi
  802551:	e9 40 ff ff ff       	jmp    802496 <__udivdi3+0x46>
  802556:	66 90                	xchg   %ax,%ax
  802558:	31 c0                	xor    %eax,%eax
  80255a:	e9 37 ff ff ff       	jmp    802496 <__udivdi3+0x46>
  80255f:	90                   	nop

00802560 <__umoddi3>:
  802560:	55                   	push   %ebp
  802561:	57                   	push   %edi
  802562:	56                   	push   %esi
  802563:	53                   	push   %ebx
  802564:	83 ec 1c             	sub    $0x1c,%esp
  802567:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80256b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80256f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802573:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802577:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80257b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80257f:	89 f3                	mov    %esi,%ebx
  802581:	89 fa                	mov    %edi,%edx
  802583:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802587:	89 34 24             	mov    %esi,(%esp)
  80258a:	85 c0                	test   %eax,%eax
  80258c:	75 1a                	jne    8025a8 <__umoddi3+0x48>
  80258e:	39 f7                	cmp    %esi,%edi
  802590:	0f 86 a2 00 00 00    	jbe    802638 <__umoddi3+0xd8>
  802596:	89 c8                	mov    %ecx,%eax
  802598:	89 f2                	mov    %esi,%edx
  80259a:	f7 f7                	div    %edi
  80259c:	89 d0                	mov    %edx,%eax
  80259e:	31 d2                	xor    %edx,%edx
  8025a0:	83 c4 1c             	add    $0x1c,%esp
  8025a3:	5b                   	pop    %ebx
  8025a4:	5e                   	pop    %esi
  8025a5:	5f                   	pop    %edi
  8025a6:	5d                   	pop    %ebp
  8025a7:	c3                   	ret    
  8025a8:	39 f0                	cmp    %esi,%eax
  8025aa:	0f 87 ac 00 00 00    	ja     80265c <__umoddi3+0xfc>
  8025b0:	0f bd e8             	bsr    %eax,%ebp
  8025b3:	83 f5 1f             	xor    $0x1f,%ebp
  8025b6:	0f 84 ac 00 00 00    	je     802668 <__umoddi3+0x108>
  8025bc:	bf 20 00 00 00       	mov    $0x20,%edi
  8025c1:	29 ef                	sub    %ebp,%edi
  8025c3:	89 fe                	mov    %edi,%esi
  8025c5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8025c9:	89 e9                	mov    %ebp,%ecx
  8025cb:	d3 e0                	shl    %cl,%eax
  8025cd:	89 d7                	mov    %edx,%edi
  8025cf:	89 f1                	mov    %esi,%ecx
  8025d1:	d3 ef                	shr    %cl,%edi
  8025d3:	09 c7                	or     %eax,%edi
  8025d5:	89 e9                	mov    %ebp,%ecx
  8025d7:	d3 e2                	shl    %cl,%edx
  8025d9:	89 14 24             	mov    %edx,(%esp)
  8025dc:	89 d8                	mov    %ebx,%eax
  8025de:	d3 e0                	shl    %cl,%eax
  8025e0:	89 c2                	mov    %eax,%edx
  8025e2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8025e6:	d3 e0                	shl    %cl,%eax
  8025e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025ec:	8b 44 24 08          	mov    0x8(%esp),%eax
  8025f0:	89 f1                	mov    %esi,%ecx
  8025f2:	d3 e8                	shr    %cl,%eax
  8025f4:	09 d0                	or     %edx,%eax
  8025f6:	d3 eb                	shr    %cl,%ebx
  8025f8:	89 da                	mov    %ebx,%edx
  8025fa:	f7 f7                	div    %edi
  8025fc:	89 d3                	mov    %edx,%ebx
  8025fe:	f7 24 24             	mull   (%esp)
  802601:	89 c6                	mov    %eax,%esi
  802603:	89 d1                	mov    %edx,%ecx
  802605:	39 d3                	cmp    %edx,%ebx
  802607:	0f 82 87 00 00 00    	jb     802694 <__umoddi3+0x134>
  80260d:	0f 84 91 00 00 00    	je     8026a4 <__umoddi3+0x144>
  802613:	8b 54 24 04          	mov    0x4(%esp),%edx
  802617:	29 f2                	sub    %esi,%edx
  802619:	19 cb                	sbb    %ecx,%ebx
  80261b:	89 d8                	mov    %ebx,%eax
  80261d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802621:	d3 e0                	shl    %cl,%eax
  802623:	89 e9                	mov    %ebp,%ecx
  802625:	d3 ea                	shr    %cl,%edx
  802627:	09 d0                	or     %edx,%eax
  802629:	89 e9                	mov    %ebp,%ecx
  80262b:	d3 eb                	shr    %cl,%ebx
  80262d:	89 da                	mov    %ebx,%edx
  80262f:	83 c4 1c             	add    $0x1c,%esp
  802632:	5b                   	pop    %ebx
  802633:	5e                   	pop    %esi
  802634:	5f                   	pop    %edi
  802635:	5d                   	pop    %ebp
  802636:	c3                   	ret    
  802637:	90                   	nop
  802638:	89 fd                	mov    %edi,%ebp
  80263a:	85 ff                	test   %edi,%edi
  80263c:	75 0b                	jne    802649 <__umoddi3+0xe9>
  80263e:	b8 01 00 00 00       	mov    $0x1,%eax
  802643:	31 d2                	xor    %edx,%edx
  802645:	f7 f7                	div    %edi
  802647:	89 c5                	mov    %eax,%ebp
  802649:	89 f0                	mov    %esi,%eax
  80264b:	31 d2                	xor    %edx,%edx
  80264d:	f7 f5                	div    %ebp
  80264f:	89 c8                	mov    %ecx,%eax
  802651:	f7 f5                	div    %ebp
  802653:	89 d0                	mov    %edx,%eax
  802655:	e9 44 ff ff ff       	jmp    80259e <__umoddi3+0x3e>
  80265a:	66 90                	xchg   %ax,%ax
  80265c:	89 c8                	mov    %ecx,%eax
  80265e:	89 f2                	mov    %esi,%edx
  802660:	83 c4 1c             	add    $0x1c,%esp
  802663:	5b                   	pop    %ebx
  802664:	5e                   	pop    %esi
  802665:	5f                   	pop    %edi
  802666:	5d                   	pop    %ebp
  802667:	c3                   	ret    
  802668:	3b 04 24             	cmp    (%esp),%eax
  80266b:	72 06                	jb     802673 <__umoddi3+0x113>
  80266d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802671:	77 0f                	ja     802682 <__umoddi3+0x122>
  802673:	89 f2                	mov    %esi,%edx
  802675:	29 f9                	sub    %edi,%ecx
  802677:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80267b:	89 14 24             	mov    %edx,(%esp)
  80267e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802682:	8b 44 24 04          	mov    0x4(%esp),%eax
  802686:	8b 14 24             	mov    (%esp),%edx
  802689:	83 c4 1c             	add    $0x1c,%esp
  80268c:	5b                   	pop    %ebx
  80268d:	5e                   	pop    %esi
  80268e:	5f                   	pop    %edi
  80268f:	5d                   	pop    %ebp
  802690:	c3                   	ret    
  802691:	8d 76 00             	lea    0x0(%esi),%esi
  802694:	2b 04 24             	sub    (%esp),%eax
  802697:	19 fa                	sbb    %edi,%edx
  802699:	89 d1                	mov    %edx,%ecx
  80269b:	89 c6                	mov    %eax,%esi
  80269d:	e9 71 ff ff ff       	jmp    802613 <__umoddi3+0xb3>
  8026a2:	66 90                	xchg   %ax,%ax
  8026a4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8026a8:	72 ea                	jb     802694 <__umoddi3+0x134>
  8026aa:	89 d9                	mov    %ebx,%ecx
  8026ac:	e9 62 ff ff ff       	jmp    802613 <__umoddi3+0xb3>

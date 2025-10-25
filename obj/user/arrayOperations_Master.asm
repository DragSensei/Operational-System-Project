
obj/user/arrayOperations_Master:     file format elf32-i386


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
  800031:	e8 b7 08 00 00       	call   8008ed <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
uint32 CheckSorted(int *Elements, int NumOfElements);
void ArrayStats(int *Elements, int NumOfElements, int64 *mean, int64 *var);

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec bc 00 00 00    	sub    $0xbc,%esp
	/*[1] CREATE SEMAPHORES*/
	struct semaphore ready = create_semaphore("Ready", 0);
  800044:	8d 45 84             	lea    -0x7c(%ebp),%eax
  800047:	83 ec 04             	sub    $0x4,%esp
  80004a:	6a 00                	push   $0x0
  80004c:	68 40 2b 80 00       	push   $0x802b40
  800051:	50                   	push   %eax
  800052:	e8 aa 26 00 00       	call   802701 <create_semaphore>
  800057:	83 c4 0c             	add    $0xc,%esp
	struct semaphore finished = create_semaphore("Finished", 0);
  80005a:	8d 45 80             	lea    -0x80(%ebp),%eax
  80005d:	83 ec 04             	sub    $0x4,%esp
  800060:	6a 00                	push   $0x0
  800062:	68 46 2b 80 00       	push   $0x802b46
  800067:	50                   	push   %eax
  800068:	e8 94 26 00 00       	call   802701 <create_semaphore>
  80006d:	83 c4 0c             	add    $0xc,%esp
	struct semaphore cons_mutex = create_semaphore("Console Mutex", 1);
  800070:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800076:	83 ec 04             	sub    $0x4,%esp
  800079:	6a 01                	push   $0x1
  80007b:	68 4f 2b 80 00       	push   $0x802b4f
  800080:	50                   	push   %eax
  800081:	e8 7b 26 00 00       	call   802701 <create_semaphore>
  800086:	83 c4 0c             	add    $0xc,%esp

	/*[2] RUN THE SLAVES PROGRAMS*/
	int numOfSlaveProgs = 3 ;
  800089:	c7 45 dc 03 00 00 00 	movl   $0x3,-0x24(%ebp)

	int32 envIdQuickSort = sys_create_env("slave_qs", (myEnv->page_WS_max_size),(myEnv->SecondListSize) ,(myEnv->percentage_of_WS_pages_to_be_removed));
  800090:	a1 20 40 80 00       	mov    0x804020,%eax
  800095:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  80009b:	a1 20 40 80 00       	mov    0x804020,%eax
  8000a0:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  8000a6:	89 c1                	mov    %eax,%ecx
  8000a8:	a1 20 40 80 00       	mov    0x804020,%eax
  8000ad:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000b3:	52                   	push   %edx
  8000b4:	51                   	push   %ecx
  8000b5:	50                   	push   %eax
  8000b6:	68 5d 2b 80 00       	push   $0x802b5d
  8000bb:	e8 c9 21 00 00       	call   802289 <sys_create_env>
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int32 envIdMergeSort = sys_create_env("slave_ms", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8000c6:	a1 20 40 80 00       	mov    0x804020,%eax
  8000cb:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  8000d1:	a1 20 40 80 00       	mov    0x804020,%eax
  8000d6:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  8000dc:	89 c1                	mov    %eax,%ecx
  8000de:	a1 20 40 80 00       	mov    0x804020,%eax
  8000e3:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000e9:	52                   	push   %edx
  8000ea:	51                   	push   %ecx
  8000eb:	50                   	push   %eax
  8000ec:	68 66 2b 80 00       	push   $0x802b66
  8000f1:	e8 93 21 00 00       	call   802289 <sys_create_env>
  8000f6:	83 c4 10             	add    $0x10,%esp
  8000f9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	int32 envIdStats = sys_create_env("slave_stats", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  8000fc:	a1 20 40 80 00       	mov    0x804020,%eax
  800101:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  800107:	a1 20 40 80 00       	mov    0x804020,%eax
  80010c:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  800112:	89 c1                	mov    %eax,%ecx
  800114:	a1 20 40 80 00       	mov    0x804020,%eax
  800119:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80011f:	52                   	push   %edx
  800120:	51                   	push   %ecx
  800121:	50                   	push   %eax
  800122:	68 6f 2b 80 00       	push   $0x802b6f
  800127:	e8 5d 21 00 00       	call   802289 <sys_create_env>
  80012c:	83 c4 10             	add    $0x10,%esp
  80012f:	89 45 d0             	mov    %eax,-0x30(%ebp)

	if (envIdQuickSort == E_ENV_CREATION_ERROR || envIdMergeSort == E_ENV_CREATION_ERROR || envIdStats == E_ENV_CREATION_ERROR)
  800132:	83 7d d8 ef          	cmpl   $0xffffffef,-0x28(%ebp)
  800136:	74 0c                	je     800144 <_main+0x10c>
  800138:	83 7d d4 ef          	cmpl   $0xffffffef,-0x2c(%ebp)
  80013c:	74 06                	je     800144 <_main+0x10c>
  80013e:	83 7d d0 ef          	cmpl   $0xffffffef,-0x30(%ebp)
  800142:	75 14                	jne    800158 <_main+0x120>
		panic("NO AVAILABLE ENVs...");
  800144:	83 ec 04             	sub    $0x4,%esp
  800147:	68 7b 2b 80 00       	push   $0x802b7b
  80014c:	6a 1a                	push   $0x1a
  80014e:	68 90 2b 80 00       	push   $0x802b90
  800153:	e8 45 09 00 00       	call   800a9d <_panic>

	sys_run_env(envIdQuickSort);
  800158:	83 ec 0c             	sub    $0xc,%esp
  80015b:	ff 75 d8             	pushl  -0x28(%ebp)
  80015e:	e8 44 21 00 00       	call   8022a7 <sys_run_env>
  800163:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdMergeSort);
  800166:	83 ec 0c             	sub    $0xc,%esp
  800169:	ff 75 d4             	pushl  -0x2c(%ebp)
  80016c:	e8 36 21 00 00       	call   8022a7 <sys_run_env>
  800171:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdStats);
  800174:	83 ec 0c             	sub    $0xc,%esp
  800177:	ff 75 d0             	pushl  -0x30(%ebp)
  80017a:	e8 28 21 00 00       	call   8022a7 <sys_run_env>
  80017f:	83 c4 10             	add    $0x10,%esp

	/*[3] CREATE SHARED VARIABLES*/
	//Share the cons_mutex owner ID
	int *mutexOwnerID = smalloc("cons_mutex ownerID", sizeof(int) , 0) ;
  800182:	83 ec 04             	sub    $0x4,%esp
  800185:	6a 00                	push   $0x0
  800187:	6a 04                	push   $0x4
  800189:	68 ae 2b 80 00       	push   $0x802bae
  80018e:	e8 ea 1d 00 00       	call   801f7d <smalloc>
  800193:	83 c4 10             	add    $0x10,%esp
  800196:	89 45 cc             	mov    %eax,-0x34(%ebp)
	*mutexOwnerID = myEnv->env_id ;
  800199:	a1 20 40 80 00       	mov    0x804020,%eax
  80019e:	8b 50 10             	mov    0x10(%eax),%edx
  8001a1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001a4:	89 10                	mov    %edx,(%eax)

	int ret;
	char Chose;
	char Line[30];
	int NumOfElements;
	int *Elements = NULL;
  8001a6:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
	//lock the console
	wait_semaphore(cons_mutex);
  8001ad:	83 ec 0c             	sub    $0xc,%esp
  8001b0:	ff b5 7c ff ff ff    	pushl  -0x84(%ebp)
  8001b6:	e8 7a 25 00 00       	call   802735 <wait_semaphore>
  8001bb:	83 c4 10             	add    $0x10,%esp
	{
		cprintf("\n");
  8001be:	83 ec 0c             	sub    $0xc,%esp
  8001c1:	68 c1 2b 80 00       	push   $0x802bc1
  8001c6:	e8 a0 0b 00 00       	call   800d6b <cprintf>
  8001cb:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  8001ce:	83 ec 0c             	sub    $0xc,%esp
  8001d1:	68 c3 2b 80 00       	push   $0x802bc3
  8001d6:	e8 90 0b 00 00       	call   800d6b <cprintf>
  8001db:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!   ARRAY OOERATIONS   !!!\n");
  8001de:	83 ec 0c             	sub    $0xc,%esp
  8001e1:	68 e1 2b 80 00       	push   $0x802be1
  8001e6:	e8 80 0b 00 00       	call   800d6b <cprintf>
  8001eb:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  8001ee:	83 ec 0c             	sub    $0xc,%esp
  8001f1:	68 c3 2b 80 00       	push   $0x802bc3
  8001f6:	e8 70 0b 00 00       	call   800d6b <cprintf>
  8001fb:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  8001fe:	83 ec 0c             	sub    $0xc,%esp
  800201:	68 c1 2b 80 00       	push   $0x802bc1
  800206:	e8 60 0b 00 00       	call   800d6b <cprintf>
  80020b:	83 c4 10             	add    $0x10,%esp

		readline("Enter the number of elements: ", Line);
  80020e:	83 ec 08             	sub    $0x8,%esp
  800211:	8d 85 5e ff ff ff    	lea    -0xa2(%ebp),%eax
  800217:	50                   	push   %eax
  800218:	68 00 2c 80 00       	push   $0x802c00
  80021d:	e8 22 12 00 00       	call   801444 <readline>
  800222:	83 c4 10             	add    $0x10,%esp

		//Create the shared array & its size
		int *arrSize = smalloc("arrSize", sizeof(int) , 0) ;
  800225:	83 ec 04             	sub    $0x4,%esp
  800228:	6a 00                	push   $0x0
  80022a:	6a 04                	push   $0x4
  80022c:	68 1f 2c 80 00       	push   $0x802c1f
  800231:	e8 47 1d 00 00       	call   801f7d <smalloc>
  800236:	83 c4 10             	add    $0x10,%esp
  800239:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		*arrSize = strtol(Line, NULL, 10) ;
  80023c:	83 ec 04             	sub    $0x4,%esp
  80023f:	6a 0a                	push   $0xa
  800241:	6a 00                	push   $0x0
  800243:	8d 85 5e ff ff ff    	lea    -0xa2(%ebp),%eax
  800249:	50                   	push   %eax
  80024a:	e8 0c 18 00 00       	call   801a5b <strtol>
  80024f:	83 c4 10             	add    $0x10,%esp
  800252:	89 c2                	mov    %eax,%edx
  800254:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800257:	89 10                	mov    %edx,(%eax)
		NumOfElements = *arrSize;
  800259:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80025c:	8b 00                	mov    (%eax),%eax
  80025e:	89 45 c0             	mov    %eax,-0x40(%ebp)
		Elements = smalloc("arr", sizeof(int) * NumOfElements , 0) ;
  800261:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800264:	c1 e0 02             	shl    $0x2,%eax
  800267:	83 ec 04             	sub    $0x4,%esp
  80026a:	6a 00                	push   $0x0
  80026c:	50                   	push   %eax
  80026d:	68 27 2c 80 00       	push   $0x802c27
  800272:	e8 06 1d 00 00       	call   801f7d <smalloc>
  800277:	83 c4 10             	add    $0x10,%esp
  80027a:	89 45 c8             	mov    %eax,-0x38(%ebp)

		cprintf("Chose the initialization method:\n") ;
  80027d:	83 ec 0c             	sub    $0xc,%esp
  800280:	68 2c 2c 80 00       	push   $0x802c2c
  800285:	e8 e1 0a 00 00       	call   800d6b <cprintf>
  80028a:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  80028d:	83 ec 0c             	sub    $0xc,%esp
  800290:	68 4e 2c 80 00       	push   $0x802c4e
  800295:	e8 d1 0a 00 00       	call   800d6b <cprintf>
  80029a:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  80029d:	83 ec 0c             	sub    $0xc,%esp
  8002a0:	68 5c 2c 80 00       	push   $0x802c5c
  8002a5:	e8 c1 0a 00 00       	call   800d6b <cprintf>
  8002aa:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  8002ad:	83 ec 0c             	sub    $0xc,%esp
  8002b0:	68 6b 2c 80 00       	push   $0x802c6b
  8002b5:	e8 b1 0a 00 00       	call   800d6b <cprintf>
  8002ba:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  8002bd:	83 ec 0c             	sub    $0xc,%esp
  8002c0:	68 7b 2c 80 00       	push   $0x802c7b
  8002c5:	e8 a1 0a 00 00       	call   800d6b <cprintf>
  8002ca:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  8002cd:	e8 fe 05 00 00       	call   8008d0 <getchar>
  8002d2:	88 45 bf             	mov    %al,-0x41(%ebp)
			cputchar(Chose);
  8002d5:	0f be 45 bf          	movsbl -0x41(%ebp),%eax
  8002d9:	83 ec 0c             	sub    $0xc,%esp
  8002dc:	50                   	push   %eax
  8002dd:	e8 cf 05 00 00       	call   8008b1 <cputchar>
  8002e2:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  8002e5:	83 ec 0c             	sub    $0xc,%esp
  8002e8:	6a 0a                	push   $0xa
  8002ea:	e8 c2 05 00 00       	call   8008b1 <cputchar>
  8002ef:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  8002f2:	80 7d bf 61          	cmpb   $0x61,-0x41(%ebp)
  8002f6:	74 0c                	je     800304 <_main+0x2cc>
  8002f8:	80 7d bf 62          	cmpb   $0x62,-0x41(%ebp)
  8002fc:	74 06                	je     800304 <_main+0x2cc>
  8002fe:	80 7d bf 63          	cmpb   $0x63,-0x41(%ebp)
  800302:	75 b9                	jne    8002bd <_main+0x285>

	}
	signal_semaphore(cons_mutex);
  800304:	83 ec 0c             	sub    $0xc,%esp
  800307:	ff b5 7c ff ff ff    	pushl  -0x84(%ebp)
  80030d:	e8 3d 24 00 00       	call   80274f <signal_semaphore>
  800312:	83 c4 10             	add    $0x10,%esp
	//unlock the console

	int  i ;
	switch (Chose)
  800315:	0f be 45 bf          	movsbl -0x41(%ebp),%eax
  800319:	83 f8 62             	cmp    $0x62,%eax
  80031c:	74 1d                	je     80033b <_main+0x303>
  80031e:	83 f8 63             	cmp    $0x63,%eax
  800321:	74 2b                	je     80034e <_main+0x316>
  800323:	83 f8 61             	cmp    $0x61,%eax
  800326:	75 39                	jne    800361 <_main+0x329>
	{
	case 'a':
		InitializeAscending(Elements, NumOfElements);
  800328:	83 ec 08             	sub    $0x8,%esp
  80032b:	ff 75 c0             	pushl  -0x40(%ebp)
  80032e:	ff 75 c8             	pushl  -0x38(%ebp)
  800331:	e8 82 03 00 00       	call   8006b8 <InitializeAscending>
  800336:	83 c4 10             	add    $0x10,%esp
		break ;
  800339:	eb 37                	jmp    800372 <_main+0x33a>
	case 'b':
		InitializeDescending(Elements, NumOfElements);
  80033b:	83 ec 08             	sub    $0x8,%esp
  80033e:	ff 75 c0             	pushl  -0x40(%ebp)
  800341:	ff 75 c8             	pushl  -0x38(%ebp)
  800344:	e8 a0 03 00 00       	call   8006e9 <InitializeDescending>
  800349:	83 c4 10             	add    $0x10,%esp
		break ;
  80034c:	eb 24                	jmp    800372 <_main+0x33a>
	case 'c':
		InitializeSemiRandom(Elements, NumOfElements);
  80034e:	83 ec 08             	sub    $0x8,%esp
  800351:	ff 75 c0             	pushl  -0x40(%ebp)
  800354:	ff 75 c8             	pushl  -0x38(%ebp)
  800357:	e8 c2 03 00 00       	call   80071e <InitializeSemiRandom>
  80035c:	83 c4 10             	add    $0x10,%esp
		break ;
  80035f:	eb 11                	jmp    800372 <_main+0x33a>
	default:
		InitializeSemiRandom(Elements, NumOfElements);
  800361:	83 ec 08             	sub    $0x8,%esp
  800364:	ff 75 c0             	pushl  -0x40(%ebp)
  800367:	ff 75 c8             	pushl  -0x38(%ebp)
  80036a:	e8 af 03 00 00       	call   80071e <InitializeSemiRandom>
  80036f:	83 c4 10             	add    $0x10,%esp
	}

	/*[4] SIGNAL READY TO THE SLAVES*/
	for (int i = 0; i < numOfSlaveProgs; ++i) {
  800372:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800379:	eb 11                	jmp    80038c <_main+0x354>
		signal_semaphore(ready);
  80037b:	83 ec 0c             	sub    $0xc,%esp
  80037e:	ff 75 84             	pushl  -0x7c(%ebp)
  800381:	e8 c9 23 00 00       	call   80274f <signal_semaphore>
  800386:	83 c4 10             	add    $0x10,%esp
	default:
		InitializeSemiRandom(Elements, NumOfElements);
	}

	/*[4] SIGNAL READY TO THE SLAVES*/
	for (int i = 0; i < numOfSlaveProgs; ++i) {
  800389:	ff 45 e4             	incl   -0x1c(%ebp)
  80038c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80038f:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800392:	7c e7                	jl     80037b <_main+0x343>
		signal_semaphore(ready);
	}

	/*[5] WAIT TILL ALL SLAVES FINISHED*/
	for (int i = 0; i < numOfSlaveProgs; ++i) {
  800394:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80039b:	eb 11                	jmp    8003ae <_main+0x376>
		wait_semaphore(finished);
  80039d:	83 ec 0c             	sub    $0xc,%esp
  8003a0:	ff 75 80             	pushl  -0x80(%ebp)
  8003a3:	e8 8d 23 00 00       	call   802735 <wait_semaphore>
  8003a8:	83 c4 10             	add    $0x10,%esp
	for (int i = 0; i < numOfSlaveProgs; ++i) {
		signal_semaphore(ready);
	}

	/*[5] WAIT TILL ALL SLAVES FINISHED*/
	for (int i = 0; i < numOfSlaveProgs; ++i) {
  8003ab:	ff 45 e0             	incl   -0x20(%ebp)
  8003ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003b1:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8003b4:	7c e7                	jl     80039d <_main+0x365>
		wait_semaphore(finished);
	}

	/*[6] GET THEIR RESULTS*/
	int *quicksortedArr = NULL;
  8003b6:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
	int *mergesortedArr = NULL;
  8003bd:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%ebp)
	int64 *mean = NULL;
  8003c4:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
	int64 *var = NULL;
  8003cb:	c7 45 ac 00 00 00 00 	movl   $0x0,-0x54(%ebp)
	int *min = NULL;
  8003d2:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
	int *max = NULL;
  8003d9:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
	int *med = NULL;
  8003e0:	c7 45 a0 00 00 00 00 	movl   $0x0,-0x60(%ebp)
	quicksortedArr = sget(envIdQuickSort, "quicksortedArr") ;
  8003e7:	83 ec 08             	sub    $0x8,%esp
  8003ea:	68 84 2c 80 00       	push   $0x802c84
  8003ef:	ff 75 d8             	pushl  -0x28(%ebp)
  8003f2:	e8 ba 1b 00 00       	call   801fb1 <sget>
  8003f7:	83 c4 10             	add    $0x10,%esp
  8003fa:	89 45 b8             	mov    %eax,-0x48(%ebp)
	mergesortedArr = sget(envIdMergeSort, "mergesortedArr") ;
  8003fd:	83 ec 08             	sub    $0x8,%esp
  800400:	68 93 2c 80 00       	push   $0x802c93
  800405:	ff 75 d4             	pushl  -0x2c(%ebp)
  800408:	e8 a4 1b 00 00       	call   801fb1 <sget>
  80040d:	83 c4 10             	add    $0x10,%esp
  800410:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	mean = sget(envIdStats, "mean") ;
  800413:	83 ec 08             	sub    $0x8,%esp
  800416:	68 a2 2c 80 00       	push   $0x802ca2
  80041b:	ff 75 d0             	pushl  -0x30(%ebp)
  80041e:	e8 8e 1b 00 00       	call   801fb1 <sget>
  800423:	83 c4 10             	add    $0x10,%esp
  800426:	89 45 b0             	mov    %eax,-0x50(%ebp)
	var = sget(envIdStats,"var") ;
  800429:	83 ec 08             	sub    $0x8,%esp
  80042c:	68 a7 2c 80 00       	push   $0x802ca7
  800431:	ff 75 d0             	pushl  -0x30(%ebp)
  800434:	e8 78 1b 00 00       	call   801fb1 <sget>
  800439:	83 c4 10             	add    $0x10,%esp
  80043c:	89 45 ac             	mov    %eax,-0x54(%ebp)
	min = sget(envIdStats,"min") ;
  80043f:	83 ec 08             	sub    $0x8,%esp
  800442:	68 ab 2c 80 00       	push   $0x802cab
  800447:	ff 75 d0             	pushl  -0x30(%ebp)
  80044a:	e8 62 1b 00 00       	call   801fb1 <sget>
  80044f:	83 c4 10             	add    $0x10,%esp
  800452:	89 45 a8             	mov    %eax,-0x58(%ebp)
	max = sget(envIdStats,"max") ;
  800455:	83 ec 08             	sub    $0x8,%esp
  800458:	68 af 2c 80 00       	push   $0x802caf
  80045d:	ff 75 d0             	pushl  -0x30(%ebp)
  800460:	e8 4c 1b 00 00       	call   801fb1 <sget>
  800465:	83 c4 10             	add    $0x10,%esp
  800468:	89 45 a4             	mov    %eax,-0x5c(%ebp)
	med = sget(envIdStats,"med") ;
  80046b:	83 ec 08             	sub    $0x8,%esp
  80046e:	68 b3 2c 80 00       	push   $0x802cb3
  800473:	ff 75 d0             	pushl  -0x30(%ebp)
  800476:	e8 36 1b 00 00       	call   801fb1 <sget>
  80047b:	83 c4 10             	add    $0x10,%esp
  80047e:	89 45 a0             	mov    %eax,-0x60(%ebp)

	/*[7] VALIDATE THE RESULTS*/
	uint32 sorted = CheckSorted(quicksortedArr, NumOfElements);
  800481:	83 ec 08             	sub    $0x8,%esp
  800484:	ff 75 c0             	pushl  -0x40(%ebp)
  800487:	ff 75 b8             	pushl  -0x48(%ebp)
  80048a:	e8 d2 01 00 00       	call   800661 <CheckSorted>
  80048f:	83 c4 10             	add    $0x10,%esp
  800492:	89 45 9c             	mov    %eax,-0x64(%ebp)
	if(sorted == 0) panic("The array is NOT quick-sorted correctly") ;
  800495:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  800499:	75 14                	jne    8004af <_main+0x477>
  80049b:	83 ec 04             	sub    $0x4,%esp
  80049e:	68 b8 2c 80 00       	push   $0x802cb8
  8004a3:	6a 77                	push   $0x77
  8004a5:	68 90 2b 80 00       	push   $0x802b90
  8004aa:	e8 ee 05 00 00       	call   800a9d <_panic>
	sorted = CheckSorted(mergesortedArr, NumOfElements);
  8004af:	83 ec 08             	sub    $0x8,%esp
  8004b2:	ff 75 c0             	pushl  -0x40(%ebp)
  8004b5:	ff 75 b4             	pushl  -0x4c(%ebp)
  8004b8:	e8 a4 01 00 00       	call   800661 <CheckSorted>
  8004bd:	83 c4 10             	add    $0x10,%esp
  8004c0:	89 45 9c             	mov    %eax,-0x64(%ebp)
	if(sorted == 0) panic("The array is NOT merge-sorted correctly") ;
  8004c3:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  8004c7:	75 14                	jne    8004dd <_main+0x4a5>
  8004c9:	83 ec 04             	sub    $0x4,%esp
  8004cc:	68 e0 2c 80 00       	push   $0x802ce0
  8004d1:	6a 79                	push   $0x79
  8004d3:	68 90 2b 80 00       	push   $0x802b90
  8004d8:	e8 c0 05 00 00       	call   800a9d <_panic>
	int64 correctMean, correctVar ;
	ArrayStats(Elements, NumOfElements, &correctMean , &correctVar);
  8004dd:	8d 85 48 ff ff ff    	lea    -0xb8(%ebp),%eax
  8004e3:	50                   	push   %eax
  8004e4:	8d 85 50 ff ff ff    	lea    -0xb0(%ebp),%eax
  8004ea:	50                   	push   %eax
  8004eb:	ff 75 c0             	pushl  -0x40(%ebp)
  8004ee:	ff 75 c8             	pushl  -0x38(%ebp)
  8004f1:	e8 74 02 00 00       	call   80076a <ArrayStats>
  8004f6:	83 c4 10             	add    $0x10,%esp
	int correctMin = quicksortedArr[0];
  8004f9:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8004fc:	8b 00                	mov    (%eax),%eax
  8004fe:	89 45 98             	mov    %eax,-0x68(%ebp)
	int last = NumOfElements-1;
  800501:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800504:	48                   	dec    %eax
  800505:	89 45 94             	mov    %eax,-0x6c(%ebp)
//	int middle = (NumOfElements-1)/2;
//	if (NumOfElements % 2 != 0)
//		middle--;
	int middle = (NumOfElements+1)/2 - 1; /*-1 to make it ZERO-Based*/
  800508:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80050b:	40                   	inc    %eax
  80050c:	89 c2                	mov    %eax,%edx
  80050e:	c1 ea 1f             	shr    $0x1f,%edx
  800511:	01 d0                	add    %edx,%eax
  800513:	d1 f8                	sar    %eax
  800515:	48                   	dec    %eax
  800516:	89 45 90             	mov    %eax,-0x70(%ebp)

	int correctMax = quicksortedArr[last];
  800519:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80051c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800523:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800526:	01 d0                	add    %edx,%eax
  800528:	8b 00                	mov    (%eax),%eax
  80052a:	89 45 8c             	mov    %eax,-0x74(%ebp)
	int correctMed = quicksortedArr[middle];
  80052d:	8b 45 90             	mov    -0x70(%ebp),%eax
  800530:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800537:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80053a:	01 d0                	add    %edx,%eax
  80053c:	8b 00                	mov    (%eax),%eax
  80053e:	89 45 88             	mov    %eax,-0x78(%ebp)
	wait_semaphore(cons_mutex);
  800541:	83 ec 0c             	sub    $0xc,%esp
  800544:	ff b5 7c ff ff ff    	pushl  -0x84(%ebp)
  80054a:	e8 e6 21 00 00       	call   802735 <wait_semaphore>
  80054f:	83 c4 10             	add    $0x10,%esp
	{
		//cprintf("Array is correctly sorted\n");
		cprintf("mean = %lld, var = %lld, min = %d, max = %d, med = %d\n", *mean, *var, *min, *max, *med);
  800552:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800555:	8b 00                	mov    (%eax),%eax
  800557:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  80055d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800560:	8b 38                	mov    (%eax),%edi
  800562:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800565:	8b 30                	mov    (%eax),%esi
  800567:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80056a:	8b 08                	mov    (%eax),%ecx
  80056c:	8b 58 04             	mov    0x4(%eax),%ebx
  80056f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800572:	8b 50 04             	mov    0x4(%eax),%edx
  800575:	8b 00                	mov    (%eax),%eax
  800577:	ff b5 44 ff ff ff    	pushl  -0xbc(%ebp)
  80057d:	57                   	push   %edi
  80057e:	56                   	push   %esi
  80057f:	53                   	push   %ebx
  800580:	51                   	push   %ecx
  800581:	52                   	push   %edx
  800582:	50                   	push   %eax
  800583:	68 08 2d 80 00       	push   $0x802d08
  800588:	e8 de 07 00 00       	call   800d6b <cprintf>
  80058d:	83 c4 20             	add    $0x20,%esp
		cprintf("mean = %lld, var = %lld, min = %d, max = %d, med = %d\n", correctMean, correctVar, correctMin, correctMax, correctMed);
  800590:	8b 8d 48 ff ff ff    	mov    -0xb8(%ebp),%ecx
  800596:	8b 9d 4c ff ff ff    	mov    -0xb4(%ebp),%ebx
  80059c:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  8005a2:	8b 95 54 ff ff ff    	mov    -0xac(%ebp),%edx
  8005a8:	ff 75 88             	pushl  -0x78(%ebp)
  8005ab:	ff 75 8c             	pushl  -0x74(%ebp)
  8005ae:	ff 75 98             	pushl  -0x68(%ebp)
  8005b1:	53                   	push   %ebx
  8005b2:	51                   	push   %ecx
  8005b3:	52                   	push   %edx
  8005b4:	50                   	push   %eax
  8005b5:	68 08 2d 80 00       	push   $0x802d08
  8005ba:	e8 ac 07 00 00       	call   800d6b <cprintf>
  8005bf:	83 c4 20             	add    $0x20,%esp
	}
	signal_semaphore(cons_mutex);
  8005c2:	83 ec 0c             	sub    $0xc,%esp
  8005c5:	ff b5 7c ff ff ff    	pushl  -0x84(%ebp)
  8005cb:	e8 7f 21 00 00       	call   80274f <signal_semaphore>
  8005d0:	83 c4 10             	add    $0x10,%esp
	if(*mean != correctMean || *var != correctVar|| *min != correctMin || *max != correctMax || *med != correctMed)
  8005d3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8005d6:	8b 08                	mov    (%eax),%ecx
  8005d8:	8b 58 04             	mov    0x4(%eax),%ebx
  8005db:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  8005e1:	8b 95 54 ff ff ff    	mov    -0xac(%ebp),%edx
  8005e7:	89 de                	mov    %ebx,%esi
  8005e9:	31 d6                	xor    %edx,%esi
  8005eb:	31 c8                	xor    %ecx,%eax
  8005ed:	09 f0                	or     %esi,%eax
  8005ef:	85 c0                	test   %eax,%eax
  8005f1:	75 3e                	jne    800631 <_main+0x5f9>
  8005f3:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8005f6:	8b 08                	mov    (%eax),%ecx
  8005f8:	8b 58 04             	mov    0x4(%eax),%ebx
  8005fb:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  800601:	8b 95 4c ff ff ff    	mov    -0xb4(%ebp),%edx
  800607:	89 de                	mov    %ebx,%esi
  800609:	31 d6                	xor    %edx,%esi
  80060b:	31 c8                	xor    %ecx,%eax
  80060d:	09 f0                	or     %esi,%eax
  80060f:	85 c0                	test   %eax,%eax
  800611:	75 1e                	jne    800631 <_main+0x5f9>
  800613:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800616:	8b 00                	mov    (%eax),%eax
  800618:	3b 45 98             	cmp    -0x68(%ebp),%eax
  80061b:	75 14                	jne    800631 <_main+0x5f9>
  80061d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800620:	8b 00                	mov    (%eax),%eax
  800622:	3b 45 8c             	cmp    -0x74(%ebp),%eax
  800625:	75 0a                	jne    800631 <_main+0x5f9>
  800627:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80062a:	8b 00                	mov    (%eax),%eax
  80062c:	3b 45 88             	cmp    -0x78(%ebp),%eax
  80062f:	74 17                	je     800648 <_main+0x610>
		panic("The array STATS are NOT calculated correctly") ;
  800631:	83 ec 04             	sub    $0x4,%esp
  800634:	68 40 2d 80 00       	push   $0x802d40
  800639:	68 8d 00 00 00       	push   $0x8d
  80063e:	68 90 2b 80 00       	push   $0x802b90
  800643:	e8 55 04 00 00       	call   800a9d <_panic>

	cprintf("Congratulations!! Scenario of Using the Semaphores & Shared Variables completed successfully!!\n\n\n");
  800648:	83 ec 0c             	sub    $0xc,%esp
  80064b:	68 70 2d 80 00       	push   $0x802d70
  800650:	e8 16 07 00 00       	call   800d6b <cprintf>
  800655:	83 c4 10             	add    $0x10,%esp

	return;
  800658:	90                   	nop
}
  800659:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80065c:	5b                   	pop    %ebx
  80065d:	5e                   	pop    %esi
  80065e:	5f                   	pop    %edi
  80065f:	5d                   	pop    %ebp
  800660:	c3                   	ret    

00800661 <CheckSorted>:


uint32 CheckSorted(int *Elements, int NumOfElements)
{
  800661:	55                   	push   %ebp
  800662:	89 e5                	mov    %esp,%ebp
  800664:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  800667:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  80066e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800675:	eb 33                	jmp    8006aa <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  800677:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80067a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800681:	8b 45 08             	mov    0x8(%ebp),%eax
  800684:	01 d0                	add    %edx,%eax
  800686:	8b 10                	mov    (%eax),%edx
  800688:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80068b:	40                   	inc    %eax
  80068c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800693:	8b 45 08             	mov    0x8(%ebp),%eax
  800696:	01 c8                	add    %ecx,%eax
  800698:	8b 00                	mov    (%eax),%eax
  80069a:	39 c2                	cmp    %eax,%edx
  80069c:	7e 09                	jle    8006a7 <CheckSorted+0x46>
		{
			Sorted = 0 ;
  80069e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  8006a5:	eb 0c                	jmp    8006b3 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8006a7:	ff 45 f8             	incl   -0x8(%ebp)
  8006aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ad:	48                   	dec    %eax
  8006ae:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8006b1:	7f c4                	jg     800677 <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  8006b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8006b6:	c9                   	leave  
  8006b7:	c3                   	ret    

008006b8 <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  8006b8:	55                   	push   %ebp
  8006b9:	89 e5                	mov    %esp,%ebp
  8006bb:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8006be:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8006c5:	eb 17                	jmp    8006de <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  8006c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006ca:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d4:	01 c2                	add    %eax,%edx
  8006d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006d9:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8006db:	ff 45 fc             	incl   -0x4(%ebp)
  8006de:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006e1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8006e4:	7c e1                	jl     8006c7 <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8006e6:	90                   	nop
  8006e7:	c9                   	leave  
  8006e8:	c3                   	ret    

008006e9 <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  8006e9:	55                   	push   %ebp
  8006ea:	89 e5                	mov    %esp,%ebp
  8006ec:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8006ef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8006f6:	eb 1b                	jmp    800713 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8006f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006fb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800702:	8b 45 08             	mov    0x8(%ebp),%eax
  800705:	01 c2                	add    %eax,%edx
  800707:	8b 45 0c             	mov    0xc(%ebp),%eax
  80070a:	2b 45 fc             	sub    -0x4(%ebp),%eax
  80070d:	48                   	dec    %eax
  80070e:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800710:	ff 45 fc             	incl   -0x4(%ebp)
  800713:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800716:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800719:	7c dd                	jl     8006f8 <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  80071b:	90                   	nop
  80071c:	c9                   	leave  
  80071d:	c3                   	ret    

0080071e <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  80071e:	55                   	push   %ebp
  80071f:	89 e5                	mov    %esp,%ebp
  800721:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  800724:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800727:	b8 56 55 55 55       	mov    $0x55555556,%eax
  80072c:	f7 e9                	imul   %ecx
  80072e:	c1 f9 1f             	sar    $0x1f,%ecx
  800731:	89 d0                	mov    %edx,%eax
  800733:	29 c8                	sub    %ecx,%eax
  800735:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  800738:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80073f:	eb 1e                	jmp    80075f <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  800741:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800744:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80074b:	8b 45 08             	mov    0x8(%ebp),%eax
  80074e:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800751:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800754:	99                   	cltd   
  800755:	f7 7d f8             	idivl  -0x8(%ebp)
  800758:	89 d0                	mov    %edx,%eax
  80075a:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  80075c:	ff 45 fc             	incl   -0x4(%ebp)
  80075f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800762:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800765:	7c da                	jl     800741 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
		//cprintf("Elements[%d] = %d\n",i, Elements[i]);
	}

}
  800767:	90                   	nop
  800768:	c9                   	leave  
  800769:	c3                   	ret    

0080076a <ArrayStats>:

void ArrayStats(int *Elements, int NumOfElements, int64 *mean, int64 *var)
{
  80076a:	55                   	push   %ebp
  80076b:	89 e5                	mov    %esp,%ebp
  80076d:	57                   	push   %edi
  80076e:	56                   	push   %esi
  80076f:	53                   	push   %ebx
  800770:	83 ec 2c             	sub    $0x2c,%esp
	int i ;
	*mean =0 ;
  800773:	8b 45 10             	mov    0x10(%ebp),%eax
  800776:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80077c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	for (i = 0 ; i < NumOfElements ; i++)
  800783:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80078a:	eb 29                	jmp    8007b5 <ArrayStats+0x4b>
	{
		*mean += Elements[i];
  80078c:	8b 45 10             	mov    0x10(%ebp),%eax
  80078f:	8b 08                	mov    (%eax),%ecx
  800791:	8b 58 04             	mov    0x4(%eax),%ebx
  800794:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800797:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80079e:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a1:	01 d0                	add    %edx,%eax
  8007a3:	8b 00                	mov    (%eax),%eax
  8007a5:	99                   	cltd   
  8007a6:	01 c8                	add    %ecx,%eax
  8007a8:	11 da                	adc    %ebx,%edx
  8007aa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8007ad:	89 01                	mov    %eax,(%ecx)
  8007af:	89 51 04             	mov    %edx,0x4(%ecx)

void ArrayStats(int *Elements, int NumOfElements, int64 *mean, int64 *var)
{
	int i ;
	*mean =0 ;
	for (i = 0 ; i < NumOfElements ; i++)
  8007b2:	ff 45 e4             	incl   -0x1c(%ebp)
  8007b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8007b8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8007bb:	7c cf                	jl     80078c <ArrayStats+0x22>
	{
		*mean += Elements[i];
	}
	*mean /= NumOfElements;
  8007bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8007c0:	8b 50 04             	mov    0x4(%eax),%edx
  8007c3:	8b 00                	mov    (%eax),%eax
  8007c5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007c8:	89 cb                	mov    %ecx,%ebx
  8007ca:	c1 fb 1f             	sar    $0x1f,%ebx
  8007cd:	53                   	push   %ebx
  8007ce:	51                   	push   %ecx
  8007cf:	52                   	push   %edx
  8007d0:	50                   	push   %eax
  8007d1:	e8 9e 1f 00 00       	call   802774 <__divdi3>
  8007d6:	83 c4 10             	add    $0x10,%esp
  8007d9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8007dc:	89 01                	mov    %eax,(%ecx)
  8007de:	89 51 04             	mov    %edx,0x4(%ecx)
	*var = 0;
  8007e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8007ea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	for (i = 0 ; i < NumOfElements ; i++)
  8007f1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8007f8:	eb 7e                	jmp    800878 <ArrayStats+0x10e>
	{
		*var += (int64) ((Elements[i] - *mean)*(Elements[i] - *mean));
  8007fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fd:	8b 50 04             	mov    0x4(%eax),%edx
  800800:	8b 00                	mov    (%eax),%eax
  800802:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800805:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800808:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80080b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800812:	8b 45 08             	mov    0x8(%ebp),%eax
  800815:	01 d0                	add    %edx,%eax
  800817:	8b 00                	mov    (%eax),%eax
  800819:	89 c1                	mov    %eax,%ecx
  80081b:	89 c3                	mov    %eax,%ebx
  80081d:	c1 fb 1f             	sar    $0x1f,%ebx
  800820:	8b 45 10             	mov    0x10(%ebp),%eax
  800823:	8b 50 04             	mov    0x4(%eax),%edx
  800826:	8b 00                	mov    (%eax),%eax
  800828:	29 c1                	sub    %eax,%ecx
  80082a:	19 d3                	sbb    %edx,%ebx
  80082c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80082f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800836:	8b 45 08             	mov    0x8(%ebp),%eax
  800839:	01 d0                	add    %edx,%eax
  80083b:	8b 00                	mov    (%eax),%eax
  80083d:	89 c6                	mov    %eax,%esi
  80083f:	89 c7                	mov    %eax,%edi
  800841:	c1 ff 1f             	sar    $0x1f,%edi
  800844:	8b 45 10             	mov    0x10(%ebp),%eax
  800847:	8b 50 04             	mov    0x4(%eax),%edx
  80084a:	8b 00                	mov    (%eax),%eax
  80084c:	29 c6                	sub    %eax,%esi
  80084e:	19 d7                	sbb    %edx,%edi
  800850:	89 f0                	mov    %esi,%eax
  800852:	89 fa                	mov    %edi,%edx
  800854:	89 df                	mov    %ebx,%edi
  800856:	0f af f8             	imul   %eax,%edi
  800859:	89 d6                	mov    %edx,%esi
  80085b:	0f af f1             	imul   %ecx,%esi
  80085e:	01 fe                	add    %edi,%esi
  800860:	f7 e1                	mul    %ecx
  800862:	8d 0c 16             	lea    (%esi,%edx,1),%ecx
  800865:	89 ca                	mov    %ecx,%edx
  800867:	03 45 d0             	add    -0x30(%ebp),%eax
  80086a:	13 55 d4             	adc    -0x2c(%ebp),%edx
  80086d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  800870:	89 01                	mov    %eax,(%ecx)
  800872:	89 51 04             	mov    %edx,0x4(%ecx)
	{
		*mean += Elements[i];
	}
	*mean /= NumOfElements;
	*var = 0;
	for (i = 0 ; i < NumOfElements ; i++)
  800875:	ff 45 e4             	incl   -0x1c(%ebp)
  800878:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80087b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80087e:	0f 8c 76 ff ff ff    	jl     8007fa <ArrayStats+0x90>
	{
		*var += (int64) ((Elements[i] - *mean)*(Elements[i] - *mean));
//		if (i%1000 == 0)
//			cprintf("current #elements = %d, current var = %lld\n", i , *var);
	}
	*var /= NumOfElements;
  800884:	8b 45 14             	mov    0x14(%ebp),%eax
  800887:	8b 50 04             	mov    0x4(%eax),%edx
  80088a:	8b 00                	mov    (%eax),%eax
  80088c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80088f:	89 cb                	mov    %ecx,%ebx
  800891:	c1 fb 1f             	sar    $0x1f,%ebx
  800894:	53                   	push   %ebx
  800895:	51                   	push   %ecx
  800896:	52                   	push   %edx
  800897:	50                   	push   %eax
  800898:	e8 d7 1e 00 00       	call   802774 <__divdi3>
  80089d:	83 c4 10             	add    $0x10,%esp
  8008a0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8008a3:	89 01                	mov    %eax,(%ecx)
  8008a5:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8008a8:	90                   	nop
  8008a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008ac:	5b                   	pop    %ebx
  8008ad:	5e                   	pop    %esi
  8008ae:	5f                   	pop    %edi
  8008af:	5d                   	pop    %ebp
  8008b0:	c3                   	ret    

008008b1 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8008b1:	55                   	push   %ebp
  8008b2:	89 e5                	mov    %esp,%ebp
  8008b4:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8008b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ba:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8008bd:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8008c1:	83 ec 0c             	sub    $0xc,%esp
  8008c4:	50                   	push   %eax
  8008c5:	e8 fc 18 00 00       	call   8021c6 <sys_cputc>
  8008ca:	83 c4 10             	add    $0x10,%esp
}
  8008cd:	90                   	nop
  8008ce:	c9                   	leave  
  8008cf:	c3                   	ret    

008008d0 <getchar>:


int
getchar(void)
{
  8008d0:	55                   	push   %ebp
  8008d1:	89 e5                	mov    %esp,%ebp
  8008d3:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  8008d6:	e8 8a 17 00 00       	call   802065 <sys_cgetc>
  8008db:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  8008de:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8008e1:	c9                   	leave  
  8008e2:	c3                   	ret    

008008e3 <iscons>:

int iscons(int fdnum)
{
  8008e3:	55                   	push   %ebp
  8008e4:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  8008e6:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8008eb:	5d                   	pop    %ebp
  8008ec:	c3                   	ret    

008008ed <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8008ed:	55                   	push   %ebp
  8008ee:	89 e5                	mov    %esp,%ebp
  8008f0:	57                   	push   %edi
  8008f1:	56                   	push   %esi
  8008f2:	53                   	push   %ebx
  8008f3:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8008f6:	e8 fc 19 00 00       	call   8022f7 <sys_getenvindex>
  8008fb:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8008fe:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800901:	89 d0                	mov    %edx,%eax
  800903:	c1 e0 02             	shl    $0x2,%eax
  800906:	01 d0                	add    %edx,%eax
  800908:	c1 e0 03             	shl    $0x3,%eax
  80090b:	01 d0                	add    %edx,%eax
  80090d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800914:	01 d0                	add    %edx,%eax
  800916:	c1 e0 02             	shl    $0x2,%eax
  800919:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80091e:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800923:	a1 20 40 80 00       	mov    0x804020,%eax
  800928:	8a 40 20             	mov    0x20(%eax),%al
  80092b:	84 c0                	test   %al,%al
  80092d:	74 0d                	je     80093c <libmain+0x4f>
		binaryname = myEnv->prog_name;
  80092f:	a1 20 40 80 00       	mov    0x804020,%eax
  800934:	83 c0 20             	add    $0x20,%eax
  800937:	a3 04 40 80 00       	mov    %eax,0x804004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80093c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800940:	7e 0a                	jle    80094c <libmain+0x5f>
		binaryname = argv[0];
  800942:	8b 45 0c             	mov    0xc(%ebp),%eax
  800945:	8b 00                	mov    (%eax),%eax
  800947:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	_main(argc, argv);
  80094c:	83 ec 08             	sub    $0x8,%esp
  80094f:	ff 75 0c             	pushl  0xc(%ebp)
  800952:	ff 75 08             	pushl  0x8(%ebp)
  800955:	e8 de f6 ff ff       	call   800038 <_main>
  80095a:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80095d:	a1 00 40 80 00       	mov    0x804000,%eax
  800962:	85 c0                	test   %eax,%eax
  800964:	0f 84 01 01 00 00    	je     800a6b <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80096a:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800970:	bb cc 2e 80 00       	mov    $0x802ecc,%ebx
  800975:	ba 0e 00 00 00       	mov    $0xe,%edx
  80097a:	89 c7                	mov    %eax,%edi
  80097c:	89 de                	mov    %ebx,%esi
  80097e:	89 d1                	mov    %edx,%ecx
  800980:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800982:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800985:	b9 56 00 00 00       	mov    $0x56,%ecx
  80098a:	b0 00                	mov    $0x0,%al
  80098c:	89 d7                	mov    %edx,%edi
  80098e:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800990:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800997:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80099a:	83 ec 08             	sub    $0x8,%esp
  80099d:	50                   	push   %eax
  80099e:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8009a4:	50                   	push   %eax
  8009a5:	e8 83 1b 00 00       	call   80252d <sys_utilities>
  8009aa:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8009ad:	e8 cc 16 00 00       	call   80207e <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8009b2:	83 ec 0c             	sub    $0xc,%esp
  8009b5:	68 ec 2d 80 00       	push   $0x802dec
  8009ba:	e8 ac 03 00 00       	call   800d6b <cprintf>
  8009bf:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8009c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009c5:	85 c0                	test   %eax,%eax
  8009c7:	74 18                	je     8009e1 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8009c9:	e8 7d 1b 00 00       	call   80254b <sys_get_optimal_num_faults>
  8009ce:	83 ec 08             	sub    $0x8,%esp
  8009d1:	50                   	push   %eax
  8009d2:	68 14 2e 80 00       	push   $0x802e14
  8009d7:	e8 8f 03 00 00       	call   800d6b <cprintf>
  8009dc:	83 c4 10             	add    $0x10,%esp
  8009df:	eb 59                	jmp    800a3a <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8009e1:	a1 20 40 80 00       	mov    0x804020,%eax
  8009e6:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8009ec:	a1 20 40 80 00       	mov    0x804020,%eax
  8009f1:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  8009f7:	83 ec 04             	sub    $0x4,%esp
  8009fa:	52                   	push   %edx
  8009fb:	50                   	push   %eax
  8009fc:	68 38 2e 80 00       	push   $0x802e38
  800a01:	e8 65 03 00 00       	call   800d6b <cprintf>
  800a06:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800a09:	a1 20 40 80 00       	mov    0x804020,%eax
  800a0e:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800a14:	a1 20 40 80 00       	mov    0x804020,%eax
  800a19:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  800a1f:	a1 20 40 80 00       	mov    0x804020,%eax
  800a24:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  800a2a:	51                   	push   %ecx
  800a2b:	52                   	push   %edx
  800a2c:	50                   	push   %eax
  800a2d:	68 60 2e 80 00       	push   $0x802e60
  800a32:	e8 34 03 00 00       	call   800d6b <cprintf>
  800a37:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800a3a:	a1 20 40 80 00       	mov    0x804020,%eax
  800a3f:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  800a45:	83 ec 08             	sub    $0x8,%esp
  800a48:	50                   	push   %eax
  800a49:	68 b8 2e 80 00       	push   $0x802eb8
  800a4e:	e8 18 03 00 00       	call   800d6b <cprintf>
  800a53:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800a56:	83 ec 0c             	sub    $0xc,%esp
  800a59:	68 ec 2d 80 00       	push   $0x802dec
  800a5e:	e8 08 03 00 00       	call   800d6b <cprintf>
  800a63:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800a66:	e8 2d 16 00 00       	call   802098 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800a6b:	e8 1f 00 00 00       	call   800a8f <exit>
}
  800a70:	90                   	nop
  800a71:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800a74:	5b                   	pop    %ebx
  800a75:	5e                   	pop    %esi
  800a76:	5f                   	pop    %edi
  800a77:	5d                   	pop    %ebp
  800a78:	c3                   	ret    

00800a79 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800a79:	55                   	push   %ebp
  800a7a:	89 e5                	mov    %esp,%ebp
  800a7c:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800a7f:	83 ec 0c             	sub    $0xc,%esp
  800a82:	6a 00                	push   $0x0
  800a84:	e8 3a 18 00 00       	call   8022c3 <sys_destroy_env>
  800a89:	83 c4 10             	add    $0x10,%esp
}
  800a8c:	90                   	nop
  800a8d:	c9                   	leave  
  800a8e:	c3                   	ret    

00800a8f <exit>:

void
exit(void)
{
  800a8f:	55                   	push   %ebp
  800a90:	89 e5                	mov    %esp,%ebp
  800a92:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800a95:	e8 8f 18 00 00       	call   802329 <sys_exit_env>
}
  800a9a:	90                   	nop
  800a9b:	c9                   	leave  
  800a9c:	c3                   	ret    

00800a9d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800a9d:	55                   	push   %ebp
  800a9e:	89 e5                	mov    %esp,%ebp
  800aa0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800aa3:	8d 45 10             	lea    0x10(%ebp),%eax
  800aa6:	83 c0 04             	add    $0x4,%eax
  800aa9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800aac:	a1 18 c1 81 00       	mov    0x81c118,%eax
  800ab1:	85 c0                	test   %eax,%eax
  800ab3:	74 16                	je     800acb <_panic+0x2e>
		cprintf("%s: ", argv0);
  800ab5:	a1 18 c1 81 00       	mov    0x81c118,%eax
  800aba:	83 ec 08             	sub    $0x8,%esp
  800abd:	50                   	push   %eax
  800abe:	68 30 2f 80 00       	push   $0x802f30
  800ac3:	e8 a3 02 00 00       	call   800d6b <cprintf>
  800ac8:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800acb:	a1 04 40 80 00       	mov    0x804004,%eax
  800ad0:	83 ec 0c             	sub    $0xc,%esp
  800ad3:	ff 75 0c             	pushl  0xc(%ebp)
  800ad6:	ff 75 08             	pushl  0x8(%ebp)
  800ad9:	50                   	push   %eax
  800ada:	68 38 2f 80 00       	push   $0x802f38
  800adf:	6a 74                	push   $0x74
  800ae1:	e8 b2 02 00 00       	call   800d98 <cprintf_colored>
  800ae6:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800ae9:	8b 45 10             	mov    0x10(%ebp),%eax
  800aec:	83 ec 08             	sub    $0x8,%esp
  800aef:	ff 75 f4             	pushl  -0xc(%ebp)
  800af2:	50                   	push   %eax
  800af3:	e8 04 02 00 00       	call   800cfc <vcprintf>
  800af8:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800afb:	83 ec 08             	sub    $0x8,%esp
  800afe:	6a 00                	push   $0x0
  800b00:	68 60 2f 80 00       	push   $0x802f60
  800b05:	e8 f2 01 00 00       	call   800cfc <vcprintf>
  800b0a:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800b0d:	e8 7d ff ff ff       	call   800a8f <exit>

	// should not return here
	while (1) ;
  800b12:	eb fe                	jmp    800b12 <_panic+0x75>

00800b14 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800b14:	55                   	push   %ebp
  800b15:	89 e5                	mov    %esp,%ebp
  800b17:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800b1a:	a1 20 40 80 00       	mov    0x804020,%eax
  800b1f:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800b25:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b28:	39 c2                	cmp    %eax,%edx
  800b2a:	74 14                	je     800b40 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800b2c:	83 ec 04             	sub    $0x4,%esp
  800b2f:	68 64 2f 80 00       	push   $0x802f64
  800b34:	6a 26                	push   $0x26
  800b36:	68 b0 2f 80 00       	push   $0x802fb0
  800b3b:	e8 5d ff ff ff       	call   800a9d <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800b40:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800b47:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800b4e:	e9 c5 00 00 00       	jmp    800c18 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800b53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b56:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b60:	01 d0                	add    %edx,%eax
  800b62:	8b 00                	mov    (%eax),%eax
  800b64:	85 c0                	test   %eax,%eax
  800b66:	75 08                	jne    800b70 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800b68:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800b6b:	e9 a5 00 00 00       	jmp    800c15 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800b70:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800b77:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800b7e:	eb 69                	jmp    800be9 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800b80:	a1 20 40 80 00       	mov    0x804020,%eax
  800b85:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800b8b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800b8e:	89 d0                	mov    %edx,%eax
  800b90:	01 c0                	add    %eax,%eax
  800b92:	01 d0                	add    %edx,%eax
  800b94:	c1 e0 03             	shl    $0x3,%eax
  800b97:	01 c8                	add    %ecx,%eax
  800b99:	8a 40 04             	mov    0x4(%eax),%al
  800b9c:	84 c0                	test   %al,%al
  800b9e:	75 46                	jne    800be6 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800ba0:	a1 20 40 80 00       	mov    0x804020,%eax
  800ba5:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800bab:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800bae:	89 d0                	mov    %edx,%eax
  800bb0:	01 c0                	add    %eax,%eax
  800bb2:	01 d0                	add    %edx,%eax
  800bb4:	c1 e0 03             	shl    $0x3,%eax
  800bb7:	01 c8                	add    %ecx,%eax
  800bb9:	8b 00                	mov    (%eax),%eax
  800bbb:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800bbe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800bc1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800bc6:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800bc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bcb:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd5:	01 c8                	add    %ecx,%eax
  800bd7:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800bd9:	39 c2                	cmp    %eax,%edx
  800bdb:	75 09                	jne    800be6 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800bdd:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800be4:	eb 15                	jmp    800bfb <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800be6:	ff 45 e8             	incl   -0x18(%ebp)
  800be9:	a1 20 40 80 00       	mov    0x804020,%eax
  800bee:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800bf4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800bf7:	39 c2                	cmp    %eax,%edx
  800bf9:	77 85                	ja     800b80 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800bfb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800bff:	75 14                	jne    800c15 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800c01:	83 ec 04             	sub    $0x4,%esp
  800c04:	68 bc 2f 80 00       	push   $0x802fbc
  800c09:	6a 3a                	push   $0x3a
  800c0b:	68 b0 2f 80 00       	push   $0x802fb0
  800c10:	e8 88 fe ff ff       	call   800a9d <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800c15:	ff 45 f0             	incl   -0x10(%ebp)
  800c18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c1b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800c1e:	0f 8c 2f ff ff ff    	jl     800b53 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800c24:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800c2b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800c32:	eb 26                	jmp    800c5a <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800c34:	a1 20 40 80 00       	mov    0x804020,%eax
  800c39:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800c3f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c42:	89 d0                	mov    %edx,%eax
  800c44:	01 c0                	add    %eax,%eax
  800c46:	01 d0                	add    %edx,%eax
  800c48:	c1 e0 03             	shl    $0x3,%eax
  800c4b:	01 c8                	add    %ecx,%eax
  800c4d:	8a 40 04             	mov    0x4(%eax),%al
  800c50:	3c 01                	cmp    $0x1,%al
  800c52:	75 03                	jne    800c57 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800c54:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800c57:	ff 45 e0             	incl   -0x20(%ebp)
  800c5a:	a1 20 40 80 00       	mov    0x804020,%eax
  800c5f:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800c65:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c68:	39 c2                	cmp    %eax,%edx
  800c6a:	77 c8                	ja     800c34 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800c6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c6f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800c72:	74 14                	je     800c88 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800c74:	83 ec 04             	sub    $0x4,%esp
  800c77:	68 10 30 80 00       	push   $0x803010
  800c7c:	6a 44                	push   $0x44
  800c7e:	68 b0 2f 80 00       	push   $0x802fb0
  800c83:	e8 15 fe ff ff       	call   800a9d <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800c88:	90                   	nop
  800c89:	c9                   	leave  
  800c8a:	c3                   	ret    

00800c8b <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800c8b:	55                   	push   %ebp
  800c8c:	89 e5                	mov    %esp,%ebp
  800c8e:	53                   	push   %ebx
  800c8f:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800c92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c95:	8b 00                	mov    (%eax),%eax
  800c97:	8d 48 01             	lea    0x1(%eax),%ecx
  800c9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c9d:	89 0a                	mov    %ecx,(%edx)
  800c9f:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca2:	88 d1                	mov    %dl,%cl
  800ca4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ca7:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800cab:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cae:	8b 00                	mov    (%eax),%eax
  800cb0:	3d ff 00 00 00       	cmp    $0xff,%eax
  800cb5:	75 30                	jne    800ce7 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800cb7:	8b 15 1c c1 81 00    	mov    0x81c11c,%edx
  800cbd:	a0 44 40 80 00       	mov    0x804044,%al
  800cc2:	0f b6 c0             	movzbl %al,%eax
  800cc5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cc8:	8b 09                	mov    (%ecx),%ecx
  800cca:	89 cb                	mov    %ecx,%ebx
  800ccc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ccf:	83 c1 08             	add    $0x8,%ecx
  800cd2:	52                   	push   %edx
  800cd3:	50                   	push   %eax
  800cd4:	53                   	push   %ebx
  800cd5:	51                   	push   %ecx
  800cd6:	e8 5f 13 00 00       	call   80203a <sys_cputs>
  800cdb:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800cde:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800ce7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cea:	8b 40 04             	mov    0x4(%eax),%eax
  800ced:	8d 50 01             	lea    0x1(%eax),%edx
  800cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf3:	89 50 04             	mov    %edx,0x4(%eax)
}
  800cf6:	90                   	nop
  800cf7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800cfa:	c9                   	leave  
  800cfb:	c3                   	ret    

00800cfc <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800cfc:	55                   	push   %ebp
  800cfd:	89 e5                	mov    %esp,%ebp
  800cff:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800d05:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800d0c:	00 00 00 
	b.cnt = 0;
  800d0f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800d16:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800d19:	ff 75 0c             	pushl  0xc(%ebp)
  800d1c:	ff 75 08             	pushl  0x8(%ebp)
  800d1f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800d25:	50                   	push   %eax
  800d26:	68 8b 0c 80 00       	push   $0x800c8b
  800d2b:	e8 5a 02 00 00       	call   800f8a <vprintfmt>
  800d30:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800d33:	8b 15 1c c1 81 00    	mov    0x81c11c,%edx
  800d39:	a0 44 40 80 00       	mov    0x804044,%al
  800d3e:	0f b6 c0             	movzbl %al,%eax
  800d41:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800d47:	52                   	push   %edx
  800d48:	50                   	push   %eax
  800d49:	51                   	push   %ecx
  800d4a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800d50:	83 c0 08             	add    $0x8,%eax
  800d53:	50                   	push   %eax
  800d54:	e8 e1 12 00 00       	call   80203a <sys_cputs>
  800d59:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800d5c:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
	return b.cnt;
  800d63:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800d69:	c9                   	leave  
  800d6a:	c3                   	ret    

00800d6b <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800d6b:	55                   	push   %ebp
  800d6c:	89 e5                	mov    %esp,%ebp
  800d6e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800d71:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	va_start(ap, fmt);
  800d78:	8d 45 0c             	lea    0xc(%ebp),%eax
  800d7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d81:	83 ec 08             	sub    $0x8,%esp
  800d84:	ff 75 f4             	pushl  -0xc(%ebp)
  800d87:	50                   	push   %eax
  800d88:	e8 6f ff ff ff       	call   800cfc <vcprintf>
  800d8d:	83 c4 10             	add    $0x10,%esp
  800d90:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800d93:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d96:	c9                   	leave  
  800d97:	c3                   	ret    

00800d98 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800d98:	55                   	push   %ebp
  800d99:	89 e5                	mov    %esp,%ebp
  800d9b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800d9e:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800da5:	8b 45 08             	mov    0x8(%ebp),%eax
  800da8:	c1 e0 08             	shl    $0x8,%eax
  800dab:	a3 1c c1 81 00       	mov    %eax,0x81c11c
	va_start(ap, fmt);
  800db0:	8d 45 0c             	lea    0xc(%ebp),%eax
  800db3:	83 c0 04             	add    $0x4,%eax
  800db6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800db9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dbc:	83 ec 08             	sub    $0x8,%esp
  800dbf:	ff 75 f4             	pushl  -0xc(%ebp)
  800dc2:	50                   	push   %eax
  800dc3:	e8 34 ff ff ff       	call   800cfc <vcprintf>
  800dc8:	83 c4 10             	add    $0x10,%esp
  800dcb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800dce:	c7 05 1c c1 81 00 00 	movl   $0x700,0x81c11c
  800dd5:	07 00 00 

	return cnt;
  800dd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ddb:	c9                   	leave  
  800ddc:	c3                   	ret    

00800ddd <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800ddd:	55                   	push   %ebp
  800dde:	89 e5                	mov    %esp,%ebp
  800de0:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800de3:	e8 96 12 00 00       	call   80207e <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800de8:	8d 45 0c             	lea    0xc(%ebp),%eax
  800deb:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800dee:	8b 45 08             	mov    0x8(%ebp),%eax
  800df1:	83 ec 08             	sub    $0x8,%esp
  800df4:	ff 75 f4             	pushl  -0xc(%ebp)
  800df7:	50                   	push   %eax
  800df8:	e8 ff fe ff ff       	call   800cfc <vcprintf>
  800dfd:	83 c4 10             	add    $0x10,%esp
  800e00:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800e03:	e8 90 12 00 00       	call   802098 <sys_unlock_cons>
	return cnt;
  800e08:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e0b:	c9                   	leave  
  800e0c:	c3                   	ret    

00800e0d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800e0d:	55                   	push   %ebp
  800e0e:	89 e5                	mov    %esp,%ebp
  800e10:	53                   	push   %ebx
  800e11:	83 ec 14             	sub    $0x14,%esp
  800e14:	8b 45 10             	mov    0x10(%ebp),%eax
  800e17:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e1a:	8b 45 14             	mov    0x14(%ebp),%eax
  800e1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800e20:	8b 45 18             	mov    0x18(%ebp),%eax
  800e23:	ba 00 00 00 00       	mov    $0x0,%edx
  800e28:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800e2b:	77 55                	ja     800e82 <printnum+0x75>
  800e2d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800e30:	72 05                	jb     800e37 <printnum+0x2a>
  800e32:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800e35:	77 4b                	ja     800e82 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800e37:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800e3a:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800e3d:	8b 45 18             	mov    0x18(%ebp),%eax
  800e40:	ba 00 00 00 00       	mov    $0x0,%edx
  800e45:	52                   	push   %edx
  800e46:	50                   	push   %eax
  800e47:	ff 75 f4             	pushl  -0xc(%ebp)
  800e4a:	ff 75 f0             	pushl  -0x10(%ebp)
  800e4d:	e8 8a 1a 00 00       	call   8028dc <__udivdi3>
  800e52:	83 c4 10             	add    $0x10,%esp
  800e55:	83 ec 04             	sub    $0x4,%esp
  800e58:	ff 75 20             	pushl  0x20(%ebp)
  800e5b:	53                   	push   %ebx
  800e5c:	ff 75 18             	pushl  0x18(%ebp)
  800e5f:	52                   	push   %edx
  800e60:	50                   	push   %eax
  800e61:	ff 75 0c             	pushl  0xc(%ebp)
  800e64:	ff 75 08             	pushl  0x8(%ebp)
  800e67:	e8 a1 ff ff ff       	call   800e0d <printnum>
  800e6c:	83 c4 20             	add    $0x20,%esp
  800e6f:	eb 1a                	jmp    800e8b <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800e71:	83 ec 08             	sub    $0x8,%esp
  800e74:	ff 75 0c             	pushl  0xc(%ebp)
  800e77:	ff 75 20             	pushl  0x20(%ebp)
  800e7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7d:	ff d0                	call   *%eax
  800e7f:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800e82:	ff 4d 1c             	decl   0x1c(%ebp)
  800e85:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800e89:	7f e6                	jg     800e71 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800e8b:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800e8e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e96:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e99:	53                   	push   %ebx
  800e9a:	51                   	push   %ecx
  800e9b:	52                   	push   %edx
  800e9c:	50                   	push   %eax
  800e9d:	e8 4a 1b 00 00       	call   8029ec <__umoddi3>
  800ea2:	83 c4 10             	add    $0x10,%esp
  800ea5:	05 74 32 80 00       	add    $0x803274,%eax
  800eaa:	8a 00                	mov    (%eax),%al
  800eac:	0f be c0             	movsbl %al,%eax
  800eaf:	83 ec 08             	sub    $0x8,%esp
  800eb2:	ff 75 0c             	pushl  0xc(%ebp)
  800eb5:	50                   	push   %eax
  800eb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb9:	ff d0                	call   *%eax
  800ebb:	83 c4 10             	add    $0x10,%esp
}
  800ebe:	90                   	nop
  800ebf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ec2:	c9                   	leave  
  800ec3:	c3                   	ret    

00800ec4 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800ec4:	55                   	push   %ebp
  800ec5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800ec7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800ecb:	7e 1c                	jle    800ee9 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800ecd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed0:	8b 00                	mov    (%eax),%eax
  800ed2:	8d 50 08             	lea    0x8(%eax),%edx
  800ed5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed8:	89 10                	mov    %edx,(%eax)
  800eda:	8b 45 08             	mov    0x8(%ebp),%eax
  800edd:	8b 00                	mov    (%eax),%eax
  800edf:	83 e8 08             	sub    $0x8,%eax
  800ee2:	8b 50 04             	mov    0x4(%eax),%edx
  800ee5:	8b 00                	mov    (%eax),%eax
  800ee7:	eb 40                	jmp    800f29 <getuint+0x65>
	else if (lflag)
  800ee9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800eed:	74 1e                	je     800f0d <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800eef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef2:	8b 00                	mov    (%eax),%eax
  800ef4:	8d 50 04             	lea    0x4(%eax),%edx
  800ef7:	8b 45 08             	mov    0x8(%ebp),%eax
  800efa:	89 10                	mov    %edx,(%eax)
  800efc:	8b 45 08             	mov    0x8(%ebp),%eax
  800eff:	8b 00                	mov    (%eax),%eax
  800f01:	83 e8 04             	sub    $0x4,%eax
  800f04:	8b 00                	mov    (%eax),%eax
  800f06:	ba 00 00 00 00       	mov    $0x0,%edx
  800f0b:	eb 1c                	jmp    800f29 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800f0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f10:	8b 00                	mov    (%eax),%eax
  800f12:	8d 50 04             	lea    0x4(%eax),%edx
  800f15:	8b 45 08             	mov    0x8(%ebp),%eax
  800f18:	89 10                	mov    %edx,(%eax)
  800f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1d:	8b 00                	mov    (%eax),%eax
  800f1f:	83 e8 04             	sub    $0x4,%eax
  800f22:	8b 00                	mov    (%eax),%eax
  800f24:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800f29:	5d                   	pop    %ebp
  800f2a:	c3                   	ret    

00800f2b <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800f2b:	55                   	push   %ebp
  800f2c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800f2e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800f32:	7e 1c                	jle    800f50 <getint+0x25>
		return va_arg(*ap, long long);
  800f34:	8b 45 08             	mov    0x8(%ebp),%eax
  800f37:	8b 00                	mov    (%eax),%eax
  800f39:	8d 50 08             	lea    0x8(%eax),%edx
  800f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3f:	89 10                	mov    %edx,(%eax)
  800f41:	8b 45 08             	mov    0x8(%ebp),%eax
  800f44:	8b 00                	mov    (%eax),%eax
  800f46:	83 e8 08             	sub    $0x8,%eax
  800f49:	8b 50 04             	mov    0x4(%eax),%edx
  800f4c:	8b 00                	mov    (%eax),%eax
  800f4e:	eb 38                	jmp    800f88 <getint+0x5d>
	else if (lflag)
  800f50:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f54:	74 1a                	je     800f70 <getint+0x45>
		return va_arg(*ap, long);
  800f56:	8b 45 08             	mov    0x8(%ebp),%eax
  800f59:	8b 00                	mov    (%eax),%eax
  800f5b:	8d 50 04             	lea    0x4(%eax),%edx
  800f5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f61:	89 10                	mov    %edx,(%eax)
  800f63:	8b 45 08             	mov    0x8(%ebp),%eax
  800f66:	8b 00                	mov    (%eax),%eax
  800f68:	83 e8 04             	sub    $0x4,%eax
  800f6b:	8b 00                	mov    (%eax),%eax
  800f6d:	99                   	cltd   
  800f6e:	eb 18                	jmp    800f88 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800f70:	8b 45 08             	mov    0x8(%ebp),%eax
  800f73:	8b 00                	mov    (%eax),%eax
  800f75:	8d 50 04             	lea    0x4(%eax),%edx
  800f78:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7b:	89 10                	mov    %edx,(%eax)
  800f7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f80:	8b 00                	mov    (%eax),%eax
  800f82:	83 e8 04             	sub    $0x4,%eax
  800f85:	8b 00                	mov    (%eax),%eax
  800f87:	99                   	cltd   
}
  800f88:	5d                   	pop    %ebp
  800f89:	c3                   	ret    

00800f8a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800f8a:	55                   	push   %ebp
  800f8b:	89 e5                	mov    %esp,%ebp
  800f8d:	56                   	push   %esi
  800f8e:	53                   	push   %ebx
  800f8f:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f92:	eb 17                	jmp    800fab <vprintfmt+0x21>
			if (ch == '\0')
  800f94:	85 db                	test   %ebx,%ebx
  800f96:	0f 84 c1 03 00 00    	je     80135d <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800f9c:	83 ec 08             	sub    $0x8,%esp
  800f9f:	ff 75 0c             	pushl  0xc(%ebp)
  800fa2:	53                   	push   %ebx
  800fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa6:	ff d0                	call   *%eax
  800fa8:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800fab:	8b 45 10             	mov    0x10(%ebp),%eax
  800fae:	8d 50 01             	lea    0x1(%eax),%edx
  800fb1:	89 55 10             	mov    %edx,0x10(%ebp)
  800fb4:	8a 00                	mov    (%eax),%al
  800fb6:	0f b6 d8             	movzbl %al,%ebx
  800fb9:	83 fb 25             	cmp    $0x25,%ebx
  800fbc:	75 d6                	jne    800f94 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800fbe:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800fc2:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800fc9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800fd0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800fd7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800fde:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe1:	8d 50 01             	lea    0x1(%eax),%edx
  800fe4:	89 55 10             	mov    %edx,0x10(%ebp)
  800fe7:	8a 00                	mov    (%eax),%al
  800fe9:	0f b6 d8             	movzbl %al,%ebx
  800fec:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800fef:	83 f8 5b             	cmp    $0x5b,%eax
  800ff2:	0f 87 3d 03 00 00    	ja     801335 <vprintfmt+0x3ab>
  800ff8:	8b 04 85 98 32 80 00 	mov    0x803298(,%eax,4),%eax
  800fff:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801001:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801005:	eb d7                	jmp    800fde <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801007:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80100b:	eb d1                	jmp    800fde <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80100d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801014:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801017:	89 d0                	mov    %edx,%eax
  801019:	c1 e0 02             	shl    $0x2,%eax
  80101c:	01 d0                	add    %edx,%eax
  80101e:	01 c0                	add    %eax,%eax
  801020:	01 d8                	add    %ebx,%eax
  801022:	83 e8 30             	sub    $0x30,%eax
  801025:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801028:	8b 45 10             	mov    0x10(%ebp),%eax
  80102b:	8a 00                	mov    (%eax),%al
  80102d:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801030:	83 fb 2f             	cmp    $0x2f,%ebx
  801033:	7e 3e                	jle    801073 <vprintfmt+0xe9>
  801035:	83 fb 39             	cmp    $0x39,%ebx
  801038:	7f 39                	jg     801073 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80103a:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80103d:	eb d5                	jmp    801014 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80103f:	8b 45 14             	mov    0x14(%ebp),%eax
  801042:	83 c0 04             	add    $0x4,%eax
  801045:	89 45 14             	mov    %eax,0x14(%ebp)
  801048:	8b 45 14             	mov    0x14(%ebp),%eax
  80104b:	83 e8 04             	sub    $0x4,%eax
  80104e:	8b 00                	mov    (%eax),%eax
  801050:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801053:	eb 1f                	jmp    801074 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801055:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801059:	79 83                	jns    800fde <vprintfmt+0x54>
				width = 0;
  80105b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801062:	e9 77 ff ff ff       	jmp    800fde <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801067:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80106e:	e9 6b ff ff ff       	jmp    800fde <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801073:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801074:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801078:	0f 89 60 ff ff ff    	jns    800fde <vprintfmt+0x54>
				width = precision, precision = -1;
  80107e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801081:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801084:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80108b:	e9 4e ff ff ff       	jmp    800fde <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801090:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801093:	e9 46 ff ff ff       	jmp    800fde <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801098:	8b 45 14             	mov    0x14(%ebp),%eax
  80109b:	83 c0 04             	add    $0x4,%eax
  80109e:	89 45 14             	mov    %eax,0x14(%ebp)
  8010a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8010a4:	83 e8 04             	sub    $0x4,%eax
  8010a7:	8b 00                	mov    (%eax),%eax
  8010a9:	83 ec 08             	sub    $0x8,%esp
  8010ac:	ff 75 0c             	pushl  0xc(%ebp)
  8010af:	50                   	push   %eax
  8010b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b3:	ff d0                	call   *%eax
  8010b5:	83 c4 10             	add    $0x10,%esp
			break;
  8010b8:	e9 9b 02 00 00       	jmp    801358 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8010bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8010c0:	83 c0 04             	add    $0x4,%eax
  8010c3:	89 45 14             	mov    %eax,0x14(%ebp)
  8010c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8010c9:	83 e8 04             	sub    $0x4,%eax
  8010cc:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8010ce:	85 db                	test   %ebx,%ebx
  8010d0:	79 02                	jns    8010d4 <vprintfmt+0x14a>
				err = -err;
  8010d2:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8010d4:	83 fb 64             	cmp    $0x64,%ebx
  8010d7:	7f 0b                	jg     8010e4 <vprintfmt+0x15a>
  8010d9:	8b 34 9d e0 30 80 00 	mov    0x8030e0(,%ebx,4),%esi
  8010e0:	85 f6                	test   %esi,%esi
  8010e2:	75 19                	jne    8010fd <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8010e4:	53                   	push   %ebx
  8010e5:	68 85 32 80 00       	push   $0x803285
  8010ea:	ff 75 0c             	pushl  0xc(%ebp)
  8010ed:	ff 75 08             	pushl  0x8(%ebp)
  8010f0:	e8 70 02 00 00       	call   801365 <printfmt>
  8010f5:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8010f8:	e9 5b 02 00 00       	jmp    801358 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8010fd:	56                   	push   %esi
  8010fe:	68 8e 32 80 00       	push   $0x80328e
  801103:	ff 75 0c             	pushl  0xc(%ebp)
  801106:	ff 75 08             	pushl  0x8(%ebp)
  801109:	e8 57 02 00 00       	call   801365 <printfmt>
  80110e:	83 c4 10             	add    $0x10,%esp
			break;
  801111:	e9 42 02 00 00       	jmp    801358 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801116:	8b 45 14             	mov    0x14(%ebp),%eax
  801119:	83 c0 04             	add    $0x4,%eax
  80111c:	89 45 14             	mov    %eax,0x14(%ebp)
  80111f:	8b 45 14             	mov    0x14(%ebp),%eax
  801122:	83 e8 04             	sub    $0x4,%eax
  801125:	8b 30                	mov    (%eax),%esi
  801127:	85 f6                	test   %esi,%esi
  801129:	75 05                	jne    801130 <vprintfmt+0x1a6>
				p = "(null)";
  80112b:	be 91 32 80 00       	mov    $0x803291,%esi
			if (width > 0 && padc != '-')
  801130:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801134:	7e 6d                	jle    8011a3 <vprintfmt+0x219>
  801136:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80113a:	74 67                	je     8011a3 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80113c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80113f:	83 ec 08             	sub    $0x8,%esp
  801142:	50                   	push   %eax
  801143:	56                   	push   %esi
  801144:	e8 26 05 00 00       	call   80166f <strnlen>
  801149:	83 c4 10             	add    $0x10,%esp
  80114c:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80114f:	eb 16                	jmp    801167 <vprintfmt+0x1dd>
					putch(padc, putdat);
  801151:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801155:	83 ec 08             	sub    $0x8,%esp
  801158:	ff 75 0c             	pushl  0xc(%ebp)
  80115b:	50                   	push   %eax
  80115c:	8b 45 08             	mov    0x8(%ebp),%eax
  80115f:	ff d0                	call   *%eax
  801161:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801164:	ff 4d e4             	decl   -0x1c(%ebp)
  801167:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80116b:	7f e4                	jg     801151 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80116d:	eb 34                	jmp    8011a3 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80116f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801173:	74 1c                	je     801191 <vprintfmt+0x207>
  801175:	83 fb 1f             	cmp    $0x1f,%ebx
  801178:	7e 05                	jle    80117f <vprintfmt+0x1f5>
  80117a:	83 fb 7e             	cmp    $0x7e,%ebx
  80117d:	7e 12                	jle    801191 <vprintfmt+0x207>
					putch('?', putdat);
  80117f:	83 ec 08             	sub    $0x8,%esp
  801182:	ff 75 0c             	pushl  0xc(%ebp)
  801185:	6a 3f                	push   $0x3f
  801187:	8b 45 08             	mov    0x8(%ebp),%eax
  80118a:	ff d0                	call   *%eax
  80118c:	83 c4 10             	add    $0x10,%esp
  80118f:	eb 0f                	jmp    8011a0 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801191:	83 ec 08             	sub    $0x8,%esp
  801194:	ff 75 0c             	pushl  0xc(%ebp)
  801197:	53                   	push   %ebx
  801198:	8b 45 08             	mov    0x8(%ebp),%eax
  80119b:	ff d0                	call   *%eax
  80119d:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8011a0:	ff 4d e4             	decl   -0x1c(%ebp)
  8011a3:	89 f0                	mov    %esi,%eax
  8011a5:	8d 70 01             	lea    0x1(%eax),%esi
  8011a8:	8a 00                	mov    (%eax),%al
  8011aa:	0f be d8             	movsbl %al,%ebx
  8011ad:	85 db                	test   %ebx,%ebx
  8011af:	74 24                	je     8011d5 <vprintfmt+0x24b>
  8011b1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8011b5:	78 b8                	js     80116f <vprintfmt+0x1e5>
  8011b7:	ff 4d e0             	decl   -0x20(%ebp)
  8011ba:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8011be:	79 af                	jns    80116f <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8011c0:	eb 13                	jmp    8011d5 <vprintfmt+0x24b>
				putch(' ', putdat);
  8011c2:	83 ec 08             	sub    $0x8,%esp
  8011c5:	ff 75 0c             	pushl  0xc(%ebp)
  8011c8:	6a 20                	push   $0x20
  8011ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cd:	ff d0                	call   *%eax
  8011cf:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8011d2:	ff 4d e4             	decl   -0x1c(%ebp)
  8011d5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8011d9:	7f e7                	jg     8011c2 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8011db:	e9 78 01 00 00       	jmp    801358 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8011e0:	83 ec 08             	sub    $0x8,%esp
  8011e3:	ff 75 e8             	pushl  -0x18(%ebp)
  8011e6:	8d 45 14             	lea    0x14(%ebp),%eax
  8011e9:	50                   	push   %eax
  8011ea:	e8 3c fd ff ff       	call   800f2b <getint>
  8011ef:	83 c4 10             	add    $0x10,%esp
  8011f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011f5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8011f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011fe:	85 d2                	test   %edx,%edx
  801200:	79 23                	jns    801225 <vprintfmt+0x29b>
				putch('-', putdat);
  801202:	83 ec 08             	sub    $0x8,%esp
  801205:	ff 75 0c             	pushl  0xc(%ebp)
  801208:	6a 2d                	push   $0x2d
  80120a:	8b 45 08             	mov    0x8(%ebp),%eax
  80120d:	ff d0                	call   *%eax
  80120f:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801212:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801215:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801218:	f7 d8                	neg    %eax
  80121a:	83 d2 00             	adc    $0x0,%edx
  80121d:	f7 da                	neg    %edx
  80121f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801222:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801225:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80122c:	e9 bc 00 00 00       	jmp    8012ed <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801231:	83 ec 08             	sub    $0x8,%esp
  801234:	ff 75 e8             	pushl  -0x18(%ebp)
  801237:	8d 45 14             	lea    0x14(%ebp),%eax
  80123a:	50                   	push   %eax
  80123b:	e8 84 fc ff ff       	call   800ec4 <getuint>
  801240:	83 c4 10             	add    $0x10,%esp
  801243:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801246:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801249:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801250:	e9 98 00 00 00       	jmp    8012ed <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801255:	83 ec 08             	sub    $0x8,%esp
  801258:	ff 75 0c             	pushl  0xc(%ebp)
  80125b:	6a 58                	push   $0x58
  80125d:	8b 45 08             	mov    0x8(%ebp),%eax
  801260:	ff d0                	call   *%eax
  801262:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801265:	83 ec 08             	sub    $0x8,%esp
  801268:	ff 75 0c             	pushl  0xc(%ebp)
  80126b:	6a 58                	push   $0x58
  80126d:	8b 45 08             	mov    0x8(%ebp),%eax
  801270:	ff d0                	call   *%eax
  801272:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801275:	83 ec 08             	sub    $0x8,%esp
  801278:	ff 75 0c             	pushl  0xc(%ebp)
  80127b:	6a 58                	push   $0x58
  80127d:	8b 45 08             	mov    0x8(%ebp),%eax
  801280:	ff d0                	call   *%eax
  801282:	83 c4 10             	add    $0x10,%esp
			break;
  801285:	e9 ce 00 00 00       	jmp    801358 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  80128a:	83 ec 08             	sub    $0x8,%esp
  80128d:	ff 75 0c             	pushl  0xc(%ebp)
  801290:	6a 30                	push   $0x30
  801292:	8b 45 08             	mov    0x8(%ebp),%eax
  801295:	ff d0                	call   *%eax
  801297:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80129a:	83 ec 08             	sub    $0x8,%esp
  80129d:	ff 75 0c             	pushl  0xc(%ebp)
  8012a0:	6a 78                	push   $0x78
  8012a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a5:	ff d0                	call   *%eax
  8012a7:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8012aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8012ad:	83 c0 04             	add    $0x4,%eax
  8012b0:	89 45 14             	mov    %eax,0x14(%ebp)
  8012b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8012b6:	83 e8 04             	sub    $0x4,%eax
  8012b9:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8012bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8012be:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8012c5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8012cc:	eb 1f                	jmp    8012ed <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8012ce:	83 ec 08             	sub    $0x8,%esp
  8012d1:	ff 75 e8             	pushl  -0x18(%ebp)
  8012d4:	8d 45 14             	lea    0x14(%ebp),%eax
  8012d7:	50                   	push   %eax
  8012d8:	e8 e7 fb ff ff       	call   800ec4 <getuint>
  8012dd:	83 c4 10             	add    $0x10,%esp
  8012e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8012e3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8012e6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8012ed:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8012f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8012f4:	83 ec 04             	sub    $0x4,%esp
  8012f7:	52                   	push   %edx
  8012f8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8012fb:	50                   	push   %eax
  8012fc:	ff 75 f4             	pushl  -0xc(%ebp)
  8012ff:	ff 75 f0             	pushl  -0x10(%ebp)
  801302:	ff 75 0c             	pushl  0xc(%ebp)
  801305:	ff 75 08             	pushl  0x8(%ebp)
  801308:	e8 00 fb ff ff       	call   800e0d <printnum>
  80130d:	83 c4 20             	add    $0x20,%esp
			break;
  801310:	eb 46                	jmp    801358 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801312:	83 ec 08             	sub    $0x8,%esp
  801315:	ff 75 0c             	pushl  0xc(%ebp)
  801318:	53                   	push   %ebx
  801319:	8b 45 08             	mov    0x8(%ebp),%eax
  80131c:	ff d0                	call   *%eax
  80131e:	83 c4 10             	add    $0x10,%esp
			break;
  801321:	eb 35                	jmp    801358 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  801323:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
			break;
  80132a:	eb 2c                	jmp    801358 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  80132c:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
			break;
  801333:	eb 23                	jmp    801358 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801335:	83 ec 08             	sub    $0x8,%esp
  801338:	ff 75 0c             	pushl  0xc(%ebp)
  80133b:	6a 25                	push   $0x25
  80133d:	8b 45 08             	mov    0x8(%ebp),%eax
  801340:	ff d0                	call   *%eax
  801342:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801345:	ff 4d 10             	decl   0x10(%ebp)
  801348:	eb 03                	jmp    80134d <vprintfmt+0x3c3>
  80134a:	ff 4d 10             	decl   0x10(%ebp)
  80134d:	8b 45 10             	mov    0x10(%ebp),%eax
  801350:	48                   	dec    %eax
  801351:	8a 00                	mov    (%eax),%al
  801353:	3c 25                	cmp    $0x25,%al
  801355:	75 f3                	jne    80134a <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  801357:	90                   	nop
		}
	}
  801358:	e9 35 fc ff ff       	jmp    800f92 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80135d:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80135e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801361:	5b                   	pop    %ebx
  801362:	5e                   	pop    %esi
  801363:	5d                   	pop    %ebp
  801364:	c3                   	ret    

00801365 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801365:	55                   	push   %ebp
  801366:	89 e5                	mov    %esp,%ebp
  801368:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80136b:	8d 45 10             	lea    0x10(%ebp),%eax
  80136e:	83 c0 04             	add    $0x4,%eax
  801371:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801374:	8b 45 10             	mov    0x10(%ebp),%eax
  801377:	ff 75 f4             	pushl  -0xc(%ebp)
  80137a:	50                   	push   %eax
  80137b:	ff 75 0c             	pushl  0xc(%ebp)
  80137e:	ff 75 08             	pushl  0x8(%ebp)
  801381:	e8 04 fc ff ff       	call   800f8a <vprintfmt>
  801386:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801389:	90                   	nop
  80138a:	c9                   	leave  
  80138b:	c3                   	ret    

0080138c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80138c:	55                   	push   %ebp
  80138d:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80138f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801392:	8b 40 08             	mov    0x8(%eax),%eax
  801395:	8d 50 01             	lea    0x1(%eax),%edx
  801398:	8b 45 0c             	mov    0xc(%ebp),%eax
  80139b:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80139e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a1:	8b 10                	mov    (%eax),%edx
  8013a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a6:	8b 40 04             	mov    0x4(%eax),%eax
  8013a9:	39 c2                	cmp    %eax,%edx
  8013ab:	73 12                	jae    8013bf <sprintputch+0x33>
		*b->buf++ = ch;
  8013ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b0:	8b 00                	mov    (%eax),%eax
  8013b2:	8d 48 01             	lea    0x1(%eax),%ecx
  8013b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013b8:	89 0a                	mov    %ecx,(%edx)
  8013ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8013bd:	88 10                	mov    %dl,(%eax)
}
  8013bf:	90                   	nop
  8013c0:	5d                   	pop    %ebp
  8013c1:	c3                   	ret    

008013c2 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8013c2:	55                   	push   %ebp
  8013c3:	89 e5                	mov    %esp,%ebp
  8013c5:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8013c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8013ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d7:	01 d0                	add    %edx,%eax
  8013d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8013dc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8013e3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013e7:	74 06                	je     8013ef <vsnprintf+0x2d>
  8013e9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8013ed:	7f 07                	jg     8013f6 <vsnprintf+0x34>
		return -E_INVAL;
  8013ef:	b8 03 00 00 00       	mov    $0x3,%eax
  8013f4:	eb 20                	jmp    801416 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8013f6:	ff 75 14             	pushl  0x14(%ebp)
  8013f9:	ff 75 10             	pushl  0x10(%ebp)
  8013fc:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8013ff:	50                   	push   %eax
  801400:	68 8c 13 80 00       	push   $0x80138c
  801405:	e8 80 fb ff ff       	call   800f8a <vprintfmt>
  80140a:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80140d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801410:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801413:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801416:	c9                   	leave  
  801417:	c3                   	ret    

00801418 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801418:	55                   	push   %ebp
  801419:	89 e5                	mov    %esp,%ebp
  80141b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80141e:	8d 45 10             	lea    0x10(%ebp),%eax
  801421:	83 c0 04             	add    $0x4,%eax
  801424:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801427:	8b 45 10             	mov    0x10(%ebp),%eax
  80142a:	ff 75 f4             	pushl  -0xc(%ebp)
  80142d:	50                   	push   %eax
  80142e:	ff 75 0c             	pushl  0xc(%ebp)
  801431:	ff 75 08             	pushl  0x8(%ebp)
  801434:	e8 89 ff ff ff       	call   8013c2 <vsnprintf>
  801439:	83 c4 10             	add    $0x10,%esp
  80143c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80143f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801442:	c9                   	leave  
  801443:	c3                   	ret    

00801444 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  801444:	55                   	push   %ebp
  801445:	89 e5                	mov    %esp,%ebp
  801447:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  80144a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80144e:	74 13                	je     801463 <readline+0x1f>
		cprintf("%s", prompt);
  801450:	83 ec 08             	sub    $0x8,%esp
  801453:	ff 75 08             	pushl  0x8(%ebp)
  801456:	68 08 34 80 00       	push   $0x803408
  80145b:	e8 0b f9 ff ff       	call   800d6b <cprintf>
  801460:	83 c4 10             	add    $0x10,%esp

	i = 0;
  801463:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  80146a:	83 ec 0c             	sub    $0xc,%esp
  80146d:	6a 00                	push   $0x0
  80146f:	e8 6f f4 ff ff       	call   8008e3 <iscons>
  801474:	83 c4 10             	add    $0x10,%esp
  801477:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  80147a:	e8 51 f4 ff ff       	call   8008d0 <getchar>
  80147f:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801482:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801486:	79 22                	jns    8014aa <readline+0x66>
			if (c != -E_EOF)
  801488:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  80148c:	0f 84 ad 00 00 00    	je     80153f <readline+0xfb>
				cprintf("read error: %e\n", c);
  801492:	83 ec 08             	sub    $0x8,%esp
  801495:	ff 75 ec             	pushl  -0x14(%ebp)
  801498:	68 0b 34 80 00       	push   $0x80340b
  80149d:	e8 c9 f8 ff ff       	call   800d6b <cprintf>
  8014a2:	83 c4 10             	add    $0x10,%esp
			break;
  8014a5:	e9 95 00 00 00       	jmp    80153f <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8014aa:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8014ae:	7e 34                	jle    8014e4 <readline+0xa0>
  8014b0:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8014b7:	7f 2b                	jg     8014e4 <readline+0xa0>
			if (echoing)
  8014b9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8014bd:	74 0e                	je     8014cd <readline+0x89>
				cputchar(c);
  8014bf:	83 ec 0c             	sub    $0xc,%esp
  8014c2:	ff 75 ec             	pushl  -0x14(%ebp)
  8014c5:	e8 e7 f3 ff ff       	call   8008b1 <cputchar>
  8014ca:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  8014cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014d0:	8d 50 01             	lea    0x1(%eax),%edx
  8014d3:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8014d6:	89 c2                	mov    %eax,%edx
  8014d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014db:	01 d0                	add    %edx,%eax
  8014dd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8014e0:	88 10                	mov    %dl,(%eax)
  8014e2:	eb 56                	jmp    80153a <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  8014e4:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8014e8:	75 1f                	jne    801509 <readline+0xc5>
  8014ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8014ee:	7e 19                	jle    801509 <readline+0xc5>
			if (echoing)
  8014f0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8014f4:	74 0e                	je     801504 <readline+0xc0>
				cputchar(c);
  8014f6:	83 ec 0c             	sub    $0xc,%esp
  8014f9:	ff 75 ec             	pushl  -0x14(%ebp)
  8014fc:	e8 b0 f3 ff ff       	call   8008b1 <cputchar>
  801501:	83 c4 10             	add    $0x10,%esp

			i--;
  801504:	ff 4d f4             	decl   -0xc(%ebp)
  801507:	eb 31                	jmp    80153a <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  801509:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  80150d:	74 0a                	je     801519 <readline+0xd5>
  80150f:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801513:	0f 85 61 ff ff ff    	jne    80147a <readline+0x36>
			if (echoing)
  801519:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80151d:	74 0e                	je     80152d <readline+0xe9>
				cputchar(c);
  80151f:	83 ec 0c             	sub    $0xc,%esp
  801522:	ff 75 ec             	pushl  -0x14(%ebp)
  801525:	e8 87 f3 ff ff       	call   8008b1 <cputchar>
  80152a:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  80152d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801530:	8b 45 0c             	mov    0xc(%ebp),%eax
  801533:	01 d0                	add    %edx,%eax
  801535:	c6 00 00             	movb   $0x0,(%eax)
			break;
  801538:	eb 06                	jmp    801540 <readline+0xfc>
		}
	}
  80153a:	e9 3b ff ff ff       	jmp    80147a <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  80153f:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  801540:	90                   	nop
  801541:	c9                   	leave  
  801542:	c3                   	ret    

00801543 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  801543:	55                   	push   %ebp
  801544:	89 e5                	mov    %esp,%ebp
  801546:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  801549:	e8 30 0b 00 00       	call   80207e <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  80154e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801552:	74 13                	je     801567 <atomic_readline+0x24>
			cprintf("%s", prompt);
  801554:	83 ec 08             	sub    $0x8,%esp
  801557:	ff 75 08             	pushl  0x8(%ebp)
  80155a:	68 08 34 80 00       	push   $0x803408
  80155f:	e8 07 f8 ff ff       	call   800d6b <cprintf>
  801564:	83 c4 10             	add    $0x10,%esp

		i = 0;
  801567:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  80156e:	83 ec 0c             	sub    $0xc,%esp
  801571:	6a 00                	push   $0x0
  801573:	e8 6b f3 ff ff       	call   8008e3 <iscons>
  801578:	83 c4 10             	add    $0x10,%esp
  80157b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  80157e:	e8 4d f3 ff ff       	call   8008d0 <getchar>
  801583:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  801586:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80158a:	79 22                	jns    8015ae <atomic_readline+0x6b>
				if (c != -E_EOF)
  80158c:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801590:	0f 84 ad 00 00 00    	je     801643 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  801596:	83 ec 08             	sub    $0x8,%esp
  801599:	ff 75 ec             	pushl  -0x14(%ebp)
  80159c:	68 0b 34 80 00       	push   $0x80340b
  8015a1:	e8 c5 f7 ff ff       	call   800d6b <cprintf>
  8015a6:	83 c4 10             	add    $0x10,%esp
				break;
  8015a9:	e9 95 00 00 00       	jmp    801643 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  8015ae:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8015b2:	7e 34                	jle    8015e8 <atomic_readline+0xa5>
  8015b4:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8015bb:	7f 2b                	jg     8015e8 <atomic_readline+0xa5>
				if (echoing)
  8015bd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8015c1:	74 0e                	je     8015d1 <atomic_readline+0x8e>
					cputchar(c);
  8015c3:	83 ec 0c             	sub    $0xc,%esp
  8015c6:	ff 75 ec             	pushl  -0x14(%ebp)
  8015c9:	e8 e3 f2 ff ff       	call   8008b1 <cputchar>
  8015ce:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  8015d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015d4:	8d 50 01             	lea    0x1(%eax),%edx
  8015d7:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8015da:	89 c2                	mov    %eax,%edx
  8015dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015df:	01 d0                	add    %edx,%eax
  8015e1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8015e4:	88 10                	mov    %dl,(%eax)
  8015e6:	eb 56                	jmp    80163e <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  8015e8:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8015ec:	75 1f                	jne    80160d <atomic_readline+0xca>
  8015ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8015f2:	7e 19                	jle    80160d <atomic_readline+0xca>
				if (echoing)
  8015f4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8015f8:	74 0e                	je     801608 <atomic_readline+0xc5>
					cputchar(c);
  8015fa:	83 ec 0c             	sub    $0xc,%esp
  8015fd:	ff 75 ec             	pushl  -0x14(%ebp)
  801600:	e8 ac f2 ff ff       	call   8008b1 <cputchar>
  801605:	83 c4 10             	add    $0x10,%esp
				i--;
  801608:	ff 4d f4             	decl   -0xc(%ebp)
  80160b:	eb 31                	jmp    80163e <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  80160d:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801611:	74 0a                	je     80161d <atomic_readline+0xda>
  801613:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801617:	0f 85 61 ff ff ff    	jne    80157e <atomic_readline+0x3b>
				if (echoing)
  80161d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801621:	74 0e                	je     801631 <atomic_readline+0xee>
					cputchar(c);
  801623:	83 ec 0c             	sub    $0xc,%esp
  801626:	ff 75 ec             	pushl  -0x14(%ebp)
  801629:	e8 83 f2 ff ff       	call   8008b1 <cputchar>
  80162e:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  801631:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801634:	8b 45 0c             	mov    0xc(%ebp),%eax
  801637:	01 d0                	add    %edx,%eax
  801639:	c6 00 00             	movb   $0x0,(%eax)
				break;
  80163c:	eb 06                	jmp    801644 <atomic_readline+0x101>
			}
		}
  80163e:	e9 3b ff ff ff       	jmp    80157e <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  801643:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  801644:	e8 4f 0a 00 00       	call   802098 <sys_unlock_cons>
}
  801649:	90                   	nop
  80164a:	c9                   	leave  
  80164b:	c3                   	ret    

0080164c <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80164c:	55                   	push   %ebp
  80164d:	89 e5                	mov    %esp,%ebp
  80164f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801652:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801659:	eb 06                	jmp    801661 <strlen+0x15>
		n++;
  80165b:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80165e:	ff 45 08             	incl   0x8(%ebp)
  801661:	8b 45 08             	mov    0x8(%ebp),%eax
  801664:	8a 00                	mov    (%eax),%al
  801666:	84 c0                	test   %al,%al
  801668:	75 f1                	jne    80165b <strlen+0xf>
		n++;
	return n;
  80166a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80166d:	c9                   	leave  
  80166e:	c3                   	ret    

0080166f <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80166f:	55                   	push   %ebp
  801670:	89 e5                	mov    %esp,%ebp
  801672:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801675:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80167c:	eb 09                	jmp    801687 <strnlen+0x18>
		n++;
  80167e:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801681:	ff 45 08             	incl   0x8(%ebp)
  801684:	ff 4d 0c             	decl   0xc(%ebp)
  801687:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80168b:	74 09                	je     801696 <strnlen+0x27>
  80168d:	8b 45 08             	mov    0x8(%ebp),%eax
  801690:	8a 00                	mov    (%eax),%al
  801692:	84 c0                	test   %al,%al
  801694:	75 e8                	jne    80167e <strnlen+0xf>
		n++;
	return n;
  801696:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801699:	c9                   	leave  
  80169a:	c3                   	ret    

0080169b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80169b:	55                   	push   %ebp
  80169c:	89 e5                	mov    %esp,%ebp
  80169e:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8016a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8016a7:	90                   	nop
  8016a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ab:	8d 50 01             	lea    0x1(%eax),%edx
  8016ae:	89 55 08             	mov    %edx,0x8(%ebp)
  8016b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016b4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016b7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8016ba:	8a 12                	mov    (%edx),%dl
  8016bc:	88 10                	mov    %dl,(%eax)
  8016be:	8a 00                	mov    (%eax),%al
  8016c0:	84 c0                	test   %al,%al
  8016c2:	75 e4                	jne    8016a8 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8016c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8016c7:	c9                   	leave  
  8016c8:	c3                   	ret    

008016c9 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8016c9:	55                   	push   %ebp
  8016ca:	89 e5                	mov    %esp,%ebp
  8016cc:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8016cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8016d5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8016dc:	eb 1f                	jmp    8016fd <strncpy+0x34>
		*dst++ = *src;
  8016de:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e1:	8d 50 01             	lea    0x1(%eax),%edx
  8016e4:	89 55 08             	mov    %edx,0x8(%ebp)
  8016e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ea:	8a 12                	mov    (%edx),%dl
  8016ec:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8016ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f1:	8a 00                	mov    (%eax),%al
  8016f3:	84 c0                	test   %al,%al
  8016f5:	74 03                	je     8016fa <strncpy+0x31>
			src++;
  8016f7:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8016fa:	ff 45 fc             	incl   -0x4(%ebp)
  8016fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801700:	3b 45 10             	cmp    0x10(%ebp),%eax
  801703:	72 d9                	jb     8016de <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801705:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801708:	c9                   	leave  
  801709:	c3                   	ret    

0080170a <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80170a:	55                   	push   %ebp
  80170b:	89 e5                	mov    %esp,%ebp
  80170d:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801710:	8b 45 08             	mov    0x8(%ebp),%eax
  801713:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801716:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80171a:	74 30                	je     80174c <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80171c:	eb 16                	jmp    801734 <strlcpy+0x2a>
			*dst++ = *src++;
  80171e:	8b 45 08             	mov    0x8(%ebp),%eax
  801721:	8d 50 01             	lea    0x1(%eax),%edx
  801724:	89 55 08             	mov    %edx,0x8(%ebp)
  801727:	8b 55 0c             	mov    0xc(%ebp),%edx
  80172a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80172d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801730:	8a 12                	mov    (%edx),%dl
  801732:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801734:	ff 4d 10             	decl   0x10(%ebp)
  801737:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80173b:	74 09                	je     801746 <strlcpy+0x3c>
  80173d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801740:	8a 00                	mov    (%eax),%al
  801742:	84 c0                	test   %al,%al
  801744:	75 d8                	jne    80171e <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801746:	8b 45 08             	mov    0x8(%ebp),%eax
  801749:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80174c:	8b 55 08             	mov    0x8(%ebp),%edx
  80174f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801752:	29 c2                	sub    %eax,%edx
  801754:	89 d0                	mov    %edx,%eax
}
  801756:	c9                   	leave  
  801757:	c3                   	ret    

00801758 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801758:	55                   	push   %ebp
  801759:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80175b:	eb 06                	jmp    801763 <strcmp+0xb>
		p++, q++;
  80175d:	ff 45 08             	incl   0x8(%ebp)
  801760:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801763:	8b 45 08             	mov    0x8(%ebp),%eax
  801766:	8a 00                	mov    (%eax),%al
  801768:	84 c0                	test   %al,%al
  80176a:	74 0e                	je     80177a <strcmp+0x22>
  80176c:	8b 45 08             	mov    0x8(%ebp),%eax
  80176f:	8a 10                	mov    (%eax),%dl
  801771:	8b 45 0c             	mov    0xc(%ebp),%eax
  801774:	8a 00                	mov    (%eax),%al
  801776:	38 c2                	cmp    %al,%dl
  801778:	74 e3                	je     80175d <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80177a:	8b 45 08             	mov    0x8(%ebp),%eax
  80177d:	8a 00                	mov    (%eax),%al
  80177f:	0f b6 d0             	movzbl %al,%edx
  801782:	8b 45 0c             	mov    0xc(%ebp),%eax
  801785:	8a 00                	mov    (%eax),%al
  801787:	0f b6 c0             	movzbl %al,%eax
  80178a:	29 c2                	sub    %eax,%edx
  80178c:	89 d0                	mov    %edx,%eax
}
  80178e:	5d                   	pop    %ebp
  80178f:	c3                   	ret    

00801790 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801790:	55                   	push   %ebp
  801791:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801793:	eb 09                	jmp    80179e <strncmp+0xe>
		n--, p++, q++;
  801795:	ff 4d 10             	decl   0x10(%ebp)
  801798:	ff 45 08             	incl   0x8(%ebp)
  80179b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80179e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017a2:	74 17                	je     8017bb <strncmp+0x2b>
  8017a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a7:	8a 00                	mov    (%eax),%al
  8017a9:	84 c0                	test   %al,%al
  8017ab:	74 0e                	je     8017bb <strncmp+0x2b>
  8017ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b0:	8a 10                	mov    (%eax),%dl
  8017b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017b5:	8a 00                	mov    (%eax),%al
  8017b7:	38 c2                	cmp    %al,%dl
  8017b9:	74 da                	je     801795 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8017bb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017bf:	75 07                	jne    8017c8 <strncmp+0x38>
		return 0;
  8017c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8017c6:	eb 14                	jmp    8017dc <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8017c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cb:	8a 00                	mov    (%eax),%al
  8017cd:	0f b6 d0             	movzbl %al,%edx
  8017d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017d3:	8a 00                	mov    (%eax),%al
  8017d5:	0f b6 c0             	movzbl %al,%eax
  8017d8:	29 c2                	sub    %eax,%edx
  8017da:	89 d0                	mov    %edx,%eax
}
  8017dc:	5d                   	pop    %ebp
  8017dd:	c3                   	ret    

008017de <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8017de:	55                   	push   %ebp
  8017df:	89 e5                	mov    %esp,%ebp
  8017e1:	83 ec 04             	sub    $0x4,%esp
  8017e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017e7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8017ea:	eb 12                	jmp    8017fe <strchr+0x20>
		if (*s == c)
  8017ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ef:	8a 00                	mov    (%eax),%al
  8017f1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8017f4:	75 05                	jne    8017fb <strchr+0x1d>
			return (char *) s;
  8017f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f9:	eb 11                	jmp    80180c <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8017fb:	ff 45 08             	incl   0x8(%ebp)
  8017fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801801:	8a 00                	mov    (%eax),%al
  801803:	84 c0                	test   %al,%al
  801805:	75 e5                	jne    8017ec <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801807:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80180c:	c9                   	leave  
  80180d:	c3                   	ret    

0080180e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80180e:	55                   	push   %ebp
  80180f:	89 e5                	mov    %esp,%ebp
  801811:	83 ec 04             	sub    $0x4,%esp
  801814:	8b 45 0c             	mov    0xc(%ebp),%eax
  801817:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80181a:	eb 0d                	jmp    801829 <strfind+0x1b>
		if (*s == c)
  80181c:	8b 45 08             	mov    0x8(%ebp),%eax
  80181f:	8a 00                	mov    (%eax),%al
  801821:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801824:	74 0e                	je     801834 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801826:	ff 45 08             	incl   0x8(%ebp)
  801829:	8b 45 08             	mov    0x8(%ebp),%eax
  80182c:	8a 00                	mov    (%eax),%al
  80182e:	84 c0                	test   %al,%al
  801830:	75 ea                	jne    80181c <strfind+0xe>
  801832:	eb 01                	jmp    801835 <strfind+0x27>
		if (*s == c)
			break;
  801834:	90                   	nop
	return (char *) s;
  801835:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801838:	c9                   	leave  
  801839:	c3                   	ret    

0080183a <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  80183a:	55                   	push   %ebp
  80183b:	89 e5                	mov    %esp,%ebp
  80183d:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801840:	8b 45 08             	mov    0x8(%ebp),%eax
  801843:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801846:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80184a:	76 63                	jbe    8018af <memset+0x75>
		uint64 data_block = c;
  80184c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80184f:	99                   	cltd   
  801850:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801853:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801856:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801859:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80185c:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801860:	c1 e0 08             	shl    $0x8,%eax
  801863:	09 45 f0             	or     %eax,-0x10(%ebp)
  801866:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801869:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80186c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80186f:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801873:	c1 e0 10             	shl    $0x10,%eax
  801876:	09 45 f0             	or     %eax,-0x10(%ebp)
  801879:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  80187c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80187f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801882:	89 c2                	mov    %eax,%edx
  801884:	b8 00 00 00 00       	mov    $0x0,%eax
  801889:	09 45 f0             	or     %eax,-0x10(%ebp)
  80188c:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  80188f:	eb 18                	jmp    8018a9 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801891:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801894:	8d 41 08             	lea    0x8(%ecx),%eax
  801897:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80189a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80189d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018a0:	89 01                	mov    %eax,(%ecx)
  8018a2:	89 51 04             	mov    %edx,0x4(%ecx)
  8018a5:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  8018a9:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8018ad:	77 e2                	ja     801891 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8018af:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8018b3:	74 23                	je     8018d8 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8018b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018b8:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8018bb:	eb 0e                	jmp    8018cb <memset+0x91>
			*p8++ = (uint8)c;
  8018bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018c0:	8d 50 01             	lea    0x1(%eax),%edx
  8018c3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8018c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018c9:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8018cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8018ce:	8d 50 ff             	lea    -0x1(%eax),%edx
  8018d1:	89 55 10             	mov    %edx,0x10(%ebp)
  8018d4:	85 c0                	test   %eax,%eax
  8018d6:	75 e5                	jne    8018bd <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8018d8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8018db:	c9                   	leave  
  8018dc:	c3                   	ret    

008018dd <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8018dd:	55                   	push   %ebp
  8018de:	89 e5                	mov    %esp,%ebp
  8018e0:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8018e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018e6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8018e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ec:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8018ef:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8018f3:	76 24                	jbe    801919 <memcpy+0x3c>
		while(n >= 8){
  8018f5:	eb 1c                	jmp    801913 <memcpy+0x36>
			*d64 = *s64;
  8018f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018fa:	8b 50 04             	mov    0x4(%eax),%edx
  8018fd:	8b 00                	mov    (%eax),%eax
  8018ff:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801902:	89 01                	mov    %eax,(%ecx)
  801904:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801907:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  80190b:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  80190f:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801913:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801917:	77 de                	ja     8018f7 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801919:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80191d:	74 31                	je     801950 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  80191f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801922:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801925:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801928:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  80192b:	eb 16                	jmp    801943 <memcpy+0x66>
			*d8++ = *s8++;
  80192d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801930:	8d 50 01             	lea    0x1(%eax),%edx
  801933:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801936:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801939:	8d 4a 01             	lea    0x1(%edx),%ecx
  80193c:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80193f:	8a 12                	mov    (%edx),%dl
  801941:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801943:	8b 45 10             	mov    0x10(%ebp),%eax
  801946:	8d 50 ff             	lea    -0x1(%eax),%edx
  801949:	89 55 10             	mov    %edx,0x10(%ebp)
  80194c:	85 c0                	test   %eax,%eax
  80194e:	75 dd                	jne    80192d <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801950:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801953:	c9                   	leave  
  801954:	c3                   	ret    

00801955 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801955:	55                   	push   %ebp
  801956:	89 e5                	mov    %esp,%ebp
  801958:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80195b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80195e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801961:	8b 45 08             	mov    0x8(%ebp),%eax
  801964:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801967:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80196a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80196d:	73 50                	jae    8019bf <memmove+0x6a>
  80196f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801972:	8b 45 10             	mov    0x10(%ebp),%eax
  801975:	01 d0                	add    %edx,%eax
  801977:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80197a:	76 43                	jbe    8019bf <memmove+0x6a>
		s += n;
  80197c:	8b 45 10             	mov    0x10(%ebp),%eax
  80197f:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801982:	8b 45 10             	mov    0x10(%ebp),%eax
  801985:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801988:	eb 10                	jmp    80199a <memmove+0x45>
			*--d = *--s;
  80198a:	ff 4d f8             	decl   -0x8(%ebp)
  80198d:	ff 4d fc             	decl   -0x4(%ebp)
  801990:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801993:	8a 10                	mov    (%eax),%dl
  801995:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801998:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80199a:	8b 45 10             	mov    0x10(%ebp),%eax
  80199d:	8d 50 ff             	lea    -0x1(%eax),%edx
  8019a0:	89 55 10             	mov    %edx,0x10(%ebp)
  8019a3:	85 c0                	test   %eax,%eax
  8019a5:	75 e3                	jne    80198a <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8019a7:	eb 23                	jmp    8019cc <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8019a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019ac:	8d 50 01             	lea    0x1(%eax),%edx
  8019af:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8019b2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019b5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8019b8:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8019bb:	8a 12                	mov    (%edx),%dl
  8019bd:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8019bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8019c2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8019c5:	89 55 10             	mov    %edx,0x10(%ebp)
  8019c8:	85 c0                	test   %eax,%eax
  8019ca:	75 dd                	jne    8019a9 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8019cc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8019cf:	c9                   	leave  
  8019d0:	c3                   	ret    

008019d1 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8019d1:	55                   	push   %ebp
  8019d2:	89 e5                	mov    %esp,%ebp
  8019d4:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8019d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019da:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8019dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019e0:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8019e3:	eb 2a                	jmp    801a0f <memcmp+0x3e>
		if (*s1 != *s2)
  8019e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019e8:	8a 10                	mov    (%eax),%dl
  8019ea:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019ed:	8a 00                	mov    (%eax),%al
  8019ef:	38 c2                	cmp    %al,%dl
  8019f1:	74 16                	je     801a09 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8019f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019f6:	8a 00                	mov    (%eax),%al
  8019f8:	0f b6 d0             	movzbl %al,%edx
  8019fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019fe:	8a 00                	mov    (%eax),%al
  801a00:	0f b6 c0             	movzbl %al,%eax
  801a03:	29 c2                	sub    %eax,%edx
  801a05:	89 d0                	mov    %edx,%eax
  801a07:	eb 18                	jmp    801a21 <memcmp+0x50>
		s1++, s2++;
  801a09:	ff 45 fc             	incl   -0x4(%ebp)
  801a0c:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801a0f:	8b 45 10             	mov    0x10(%ebp),%eax
  801a12:	8d 50 ff             	lea    -0x1(%eax),%edx
  801a15:	89 55 10             	mov    %edx,0x10(%ebp)
  801a18:	85 c0                	test   %eax,%eax
  801a1a:	75 c9                	jne    8019e5 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801a1c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a21:	c9                   	leave  
  801a22:	c3                   	ret    

00801a23 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801a23:	55                   	push   %ebp
  801a24:	89 e5                	mov    %esp,%ebp
  801a26:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801a29:	8b 55 08             	mov    0x8(%ebp),%edx
  801a2c:	8b 45 10             	mov    0x10(%ebp),%eax
  801a2f:	01 d0                	add    %edx,%eax
  801a31:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801a34:	eb 15                	jmp    801a4b <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801a36:	8b 45 08             	mov    0x8(%ebp),%eax
  801a39:	8a 00                	mov    (%eax),%al
  801a3b:	0f b6 d0             	movzbl %al,%edx
  801a3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a41:	0f b6 c0             	movzbl %al,%eax
  801a44:	39 c2                	cmp    %eax,%edx
  801a46:	74 0d                	je     801a55 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801a48:	ff 45 08             	incl   0x8(%ebp)
  801a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801a51:	72 e3                	jb     801a36 <memfind+0x13>
  801a53:	eb 01                	jmp    801a56 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801a55:	90                   	nop
	return (void *) s;
  801a56:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801a59:	c9                   	leave  
  801a5a:	c3                   	ret    

00801a5b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801a5b:	55                   	push   %ebp
  801a5c:	89 e5                	mov    %esp,%ebp
  801a5e:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801a61:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801a68:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801a6f:	eb 03                	jmp    801a74 <strtol+0x19>
		s++;
  801a71:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801a74:	8b 45 08             	mov    0x8(%ebp),%eax
  801a77:	8a 00                	mov    (%eax),%al
  801a79:	3c 20                	cmp    $0x20,%al
  801a7b:	74 f4                	je     801a71 <strtol+0x16>
  801a7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a80:	8a 00                	mov    (%eax),%al
  801a82:	3c 09                	cmp    $0x9,%al
  801a84:	74 eb                	je     801a71 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801a86:	8b 45 08             	mov    0x8(%ebp),%eax
  801a89:	8a 00                	mov    (%eax),%al
  801a8b:	3c 2b                	cmp    $0x2b,%al
  801a8d:	75 05                	jne    801a94 <strtol+0x39>
		s++;
  801a8f:	ff 45 08             	incl   0x8(%ebp)
  801a92:	eb 13                	jmp    801aa7 <strtol+0x4c>
	else if (*s == '-')
  801a94:	8b 45 08             	mov    0x8(%ebp),%eax
  801a97:	8a 00                	mov    (%eax),%al
  801a99:	3c 2d                	cmp    $0x2d,%al
  801a9b:	75 0a                	jne    801aa7 <strtol+0x4c>
		s++, neg = 1;
  801a9d:	ff 45 08             	incl   0x8(%ebp)
  801aa0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801aa7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801aab:	74 06                	je     801ab3 <strtol+0x58>
  801aad:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801ab1:	75 20                	jne    801ad3 <strtol+0x78>
  801ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab6:	8a 00                	mov    (%eax),%al
  801ab8:	3c 30                	cmp    $0x30,%al
  801aba:	75 17                	jne    801ad3 <strtol+0x78>
  801abc:	8b 45 08             	mov    0x8(%ebp),%eax
  801abf:	40                   	inc    %eax
  801ac0:	8a 00                	mov    (%eax),%al
  801ac2:	3c 78                	cmp    $0x78,%al
  801ac4:	75 0d                	jne    801ad3 <strtol+0x78>
		s += 2, base = 16;
  801ac6:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801aca:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801ad1:	eb 28                	jmp    801afb <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801ad3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ad7:	75 15                	jne    801aee <strtol+0x93>
  801ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  801adc:	8a 00                	mov    (%eax),%al
  801ade:	3c 30                	cmp    $0x30,%al
  801ae0:	75 0c                	jne    801aee <strtol+0x93>
		s++, base = 8;
  801ae2:	ff 45 08             	incl   0x8(%ebp)
  801ae5:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801aec:	eb 0d                	jmp    801afb <strtol+0xa0>
	else if (base == 0)
  801aee:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801af2:	75 07                	jne    801afb <strtol+0xa0>
		base = 10;
  801af4:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801afb:	8b 45 08             	mov    0x8(%ebp),%eax
  801afe:	8a 00                	mov    (%eax),%al
  801b00:	3c 2f                	cmp    $0x2f,%al
  801b02:	7e 19                	jle    801b1d <strtol+0xc2>
  801b04:	8b 45 08             	mov    0x8(%ebp),%eax
  801b07:	8a 00                	mov    (%eax),%al
  801b09:	3c 39                	cmp    $0x39,%al
  801b0b:	7f 10                	jg     801b1d <strtol+0xc2>
			dig = *s - '0';
  801b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b10:	8a 00                	mov    (%eax),%al
  801b12:	0f be c0             	movsbl %al,%eax
  801b15:	83 e8 30             	sub    $0x30,%eax
  801b18:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b1b:	eb 42                	jmp    801b5f <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b20:	8a 00                	mov    (%eax),%al
  801b22:	3c 60                	cmp    $0x60,%al
  801b24:	7e 19                	jle    801b3f <strtol+0xe4>
  801b26:	8b 45 08             	mov    0x8(%ebp),%eax
  801b29:	8a 00                	mov    (%eax),%al
  801b2b:	3c 7a                	cmp    $0x7a,%al
  801b2d:	7f 10                	jg     801b3f <strtol+0xe4>
			dig = *s - 'a' + 10;
  801b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b32:	8a 00                	mov    (%eax),%al
  801b34:	0f be c0             	movsbl %al,%eax
  801b37:	83 e8 57             	sub    $0x57,%eax
  801b3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b3d:	eb 20                	jmp    801b5f <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b42:	8a 00                	mov    (%eax),%al
  801b44:	3c 40                	cmp    $0x40,%al
  801b46:	7e 39                	jle    801b81 <strtol+0x126>
  801b48:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4b:	8a 00                	mov    (%eax),%al
  801b4d:	3c 5a                	cmp    $0x5a,%al
  801b4f:	7f 30                	jg     801b81 <strtol+0x126>
			dig = *s - 'A' + 10;
  801b51:	8b 45 08             	mov    0x8(%ebp),%eax
  801b54:	8a 00                	mov    (%eax),%al
  801b56:	0f be c0             	movsbl %al,%eax
  801b59:	83 e8 37             	sub    $0x37,%eax
  801b5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801b5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b62:	3b 45 10             	cmp    0x10(%ebp),%eax
  801b65:	7d 19                	jge    801b80 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801b67:	ff 45 08             	incl   0x8(%ebp)
  801b6a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b6d:	0f af 45 10          	imul   0x10(%ebp),%eax
  801b71:	89 c2                	mov    %eax,%edx
  801b73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b76:	01 d0                	add    %edx,%eax
  801b78:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801b7b:	e9 7b ff ff ff       	jmp    801afb <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801b80:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801b81:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801b85:	74 08                	je     801b8f <strtol+0x134>
		*endptr = (char *) s;
  801b87:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b8a:	8b 55 08             	mov    0x8(%ebp),%edx
  801b8d:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801b8f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801b93:	74 07                	je     801b9c <strtol+0x141>
  801b95:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b98:	f7 d8                	neg    %eax
  801b9a:	eb 03                	jmp    801b9f <strtol+0x144>
  801b9c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801b9f:	c9                   	leave  
  801ba0:	c3                   	ret    

00801ba1 <ltostr>:

void
ltostr(long value, char *str)
{
  801ba1:	55                   	push   %ebp
  801ba2:	89 e5                	mov    %esp,%ebp
  801ba4:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801ba7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801bae:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801bb5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801bb9:	79 13                	jns    801bce <ltostr+0x2d>
	{
		neg = 1;
  801bbb:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801bc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bc5:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801bc8:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801bcb:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801bce:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd1:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801bd6:	99                   	cltd   
  801bd7:	f7 f9                	idiv   %ecx
  801bd9:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801bdc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bdf:	8d 50 01             	lea    0x1(%eax),%edx
  801be2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801be5:	89 c2                	mov    %eax,%edx
  801be7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bea:	01 d0                	add    %edx,%eax
  801bec:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801bef:	83 c2 30             	add    $0x30,%edx
  801bf2:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801bf4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801bf7:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801bfc:	f7 e9                	imul   %ecx
  801bfe:	c1 fa 02             	sar    $0x2,%edx
  801c01:	89 c8                	mov    %ecx,%eax
  801c03:	c1 f8 1f             	sar    $0x1f,%eax
  801c06:	29 c2                	sub    %eax,%edx
  801c08:	89 d0                	mov    %edx,%eax
  801c0a:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801c0d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801c11:	75 bb                	jne    801bce <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801c13:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801c1a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c1d:	48                   	dec    %eax
  801c1e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801c21:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801c25:	74 3d                	je     801c64 <ltostr+0xc3>
		start = 1 ;
  801c27:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801c2e:	eb 34                	jmp    801c64 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801c30:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c33:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c36:	01 d0                	add    %edx,%eax
  801c38:	8a 00                	mov    (%eax),%al
  801c3a:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801c3d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c40:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c43:	01 c2                	add    %eax,%edx
  801c45:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801c48:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c4b:	01 c8                	add    %ecx,%eax
  801c4d:	8a 00                	mov    (%eax),%al
  801c4f:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801c51:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801c54:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c57:	01 c2                	add    %eax,%edx
  801c59:	8a 45 eb             	mov    -0x15(%ebp),%al
  801c5c:	88 02                	mov    %al,(%edx)
		start++ ;
  801c5e:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801c61:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801c64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c67:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801c6a:	7c c4                	jl     801c30 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801c6c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801c6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c72:	01 d0                	add    %edx,%eax
  801c74:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801c77:	90                   	nop
  801c78:	c9                   	leave  
  801c79:	c3                   	ret    

00801c7a <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801c7a:	55                   	push   %ebp
  801c7b:	89 e5                	mov    %esp,%ebp
  801c7d:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801c80:	ff 75 08             	pushl  0x8(%ebp)
  801c83:	e8 c4 f9 ff ff       	call   80164c <strlen>
  801c88:	83 c4 04             	add    $0x4,%esp
  801c8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801c8e:	ff 75 0c             	pushl  0xc(%ebp)
  801c91:	e8 b6 f9 ff ff       	call   80164c <strlen>
  801c96:	83 c4 04             	add    $0x4,%esp
  801c99:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801c9c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801ca3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801caa:	eb 17                	jmp    801cc3 <strcconcat+0x49>
		final[s] = str1[s] ;
  801cac:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801caf:	8b 45 10             	mov    0x10(%ebp),%eax
  801cb2:	01 c2                	add    %eax,%edx
  801cb4:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cba:	01 c8                	add    %ecx,%eax
  801cbc:	8a 00                	mov    (%eax),%al
  801cbe:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801cc0:	ff 45 fc             	incl   -0x4(%ebp)
  801cc3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801cc6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801cc9:	7c e1                	jl     801cac <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801ccb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801cd2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801cd9:	eb 1f                	jmp    801cfa <strcconcat+0x80>
		final[s++] = str2[i] ;
  801cdb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801cde:	8d 50 01             	lea    0x1(%eax),%edx
  801ce1:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801ce4:	89 c2                	mov    %eax,%edx
  801ce6:	8b 45 10             	mov    0x10(%ebp),%eax
  801ce9:	01 c2                	add    %eax,%edx
  801ceb:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801cee:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cf1:	01 c8                	add    %ecx,%eax
  801cf3:	8a 00                	mov    (%eax),%al
  801cf5:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801cf7:	ff 45 f8             	incl   -0x8(%ebp)
  801cfa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801cfd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801d00:	7c d9                	jl     801cdb <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801d02:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d05:	8b 45 10             	mov    0x10(%ebp),%eax
  801d08:	01 d0                	add    %edx,%eax
  801d0a:	c6 00 00             	movb   $0x0,(%eax)
}
  801d0d:	90                   	nop
  801d0e:	c9                   	leave  
  801d0f:	c3                   	ret    

00801d10 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801d10:	55                   	push   %ebp
  801d11:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801d13:	8b 45 14             	mov    0x14(%ebp),%eax
  801d16:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801d1c:	8b 45 14             	mov    0x14(%ebp),%eax
  801d1f:	8b 00                	mov    (%eax),%eax
  801d21:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801d28:	8b 45 10             	mov    0x10(%ebp),%eax
  801d2b:	01 d0                	add    %edx,%eax
  801d2d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801d33:	eb 0c                	jmp    801d41 <strsplit+0x31>
			*string++ = 0;
  801d35:	8b 45 08             	mov    0x8(%ebp),%eax
  801d38:	8d 50 01             	lea    0x1(%eax),%edx
  801d3b:	89 55 08             	mov    %edx,0x8(%ebp)
  801d3e:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801d41:	8b 45 08             	mov    0x8(%ebp),%eax
  801d44:	8a 00                	mov    (%eax),%al
  801d46:	84 c0                	test   %al,%al
  801d48:	74 18                	je     801d62 <strsplit+0x52>
  801d4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4d:	8a 00                	mov    (%eax),%al
  801d4f:	0f be c0             	movsbl %al,%eax
  801d52:	50                   	push   %eax
  801d53:	ff 75 0c             	pushl  0xc(%ebp)
  801d56:	e8 83 fa ff ff       	call   8017de <strchr>
  801d5b:	83 c4 08             	add    $0x8,%esp
  801d5e:	85 c0                	test   %eax,%eax
  801d60:	75 d3                	jne    801d35 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801d62:	8b 45 08             	mov    0x8(%ebp),%eax
  801d65:	8a 00                	mov    (%eax),%al
  801d67:	84 c0                	test   %al,%al
  801d69:	74 5a                	je     801dc5 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801d6b:	8b 45 14             	mov    0x14(%ebp),%eax
  801d6e:	8b 00                	mov    (%eax),%eax
  801d70:	83 f8 0f             	cmp    $0xf,%eax
  801d73:	75 07                	jne    801d7c <strsplit+0x6c>
		{
			return 0;
  801d75:	b8 00 00 00 00       	mov    $0x0,%eax
  801d7a:	eb 66                	jmp    801de2 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801d7c:	8b 45 14             	mov    0x14(%ebp),%eax
  801d7f:	8b 00                	mov    (%eax),%eax
  801d81:	8d 48 01             	lea    0x1(%eax),%ecx
  801d84:	8b 55 14             	mov    0x14(%ebp),%edx
  801d87:	89 0a                	mov    %ecx,(%edx)
  801d89:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801d90:	8b 45 10             	mov    0x10(%ebp),%eax
  801d93:	01 c2                	add    %eax,%edx
  801d95:	8b 45 08             	mov    0x8(%ebp),%eax
  801d98:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801d9a:	eb 03                	jmp    801d9f <strsplit+0x8f>
			string++;
  801d9c:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801d9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801da2:	8a 00                	mov    (%eax),%al
  801da4:	84 c0                	test   %al,%al
  801da6:	74 8b                	je     801d33 <strsplit+0x23>
  801da8:	8b 45 08             	mov    0x8(%ebp),%eax
  801dab:	8a 00                	mov    (%eax),%al
  801dad:	0f be c0             	movsbl %al,%eax
  801db0:	50                   	push   %eax
  801db1:	ff 75 0c             	pushl  0xc(%ebp)
  801db4:	e8 25 fa ff ff       	call   8017de <strchr>
  801db9:	83 c4 08             	add    $0x8,%esp
  801dbc:	85 c0                	test   %eax,%eax
  801dbe:	74 dc                	je     801d9c <strsplit+0x8c>
			string++;
	}
  801dc0:	e9 6e ff ff ff       	jmp    801d33 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801dc5:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801dc6:	8b 45 14             	mov    0x14(%ebp),%eax
  801dc9:	8b 00                	mov    (%eax),%eax
  801dcb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801dd2:	8b 45 10             	mov    0x10(%ebp),%eax
  801dd5:	01 d0                	add    %edx,%eax
  801dd7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801ddd:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801de2:	c9                   	leave  
  801de3:	c3                   	ret    

00801de4 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801de4:	55                   	push   %ebp
  801de5:	89 e5                	mov    %esp,%ebp
  801de7:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801dea:	8b 45 08             	mov    0x8(%ebp),%eax
  801ded:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801df0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801df7:	eb 4a                	jmp    801e43 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801df9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  801dff:	01 c2                	add    %eax,%edx
  801e01:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801e04:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e07:	01 c8                	add    %ecx,%eax
  801e09:	8a 00                	mov    (%eax),%al
  801e0b:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801e0d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e10:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e13:	01 d0                	add    %edx,%eax
  801e15:	8a 00                	mov    (%eax),%al
  801e17:	3c 40                	cmp    $0x40,%al
  801e19:	7e 25                	jle    801e40 <str2lower+0x5c>
  801e1b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e21:	01 d0                	add    %edx,%eax
  801e23:	8a 00                	mov    (%eax),%al
  801e25:	3c 5a                	cmp    $0x5a,%al
  801e27:	7f 17                	jg     801e40 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801e29:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2f:	01 d0                	add    %edx,%eax
  801e31:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801e34:	8b 55 08             	mov    0x8(%ebp),%edx
  801e37:	01 ca                	add    %ecx,%edx
  801e39:	8a 12                	mov    (%edx),%dl
  801e3b:	83 c2 20             	add    $0x20,%edx
  801e3e:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801e40:	ff 45 fc             	incl   -0x4(%ebp)
  801e43:	ff 75 0c             	pushl  0xc(%ebp)
  801e46:	e8 01 f8 ff ff       	call   80164c <strlen>
  801e4b:	83 c4 04             	add    $0x4,%esp
  801e4e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801e51:	7f a6                	jg     801df9 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801e53:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801e56:	c9                   	leave  
  801e57:	c3                   	ret    

00801e58 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801e58:	55                   	push   %ebp
  801e59:	89 e5                	mov    %esp,%ebp
  801e5b:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801e5e:	a1 08 40 80 00       	mov    0x804008,%eax
  801e63:	85 c0                	test   %eax,%eax
  801e65:	74 42                	je     801ea9 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801e67:	83 ec 08             	sub    $0x8,%esp
  801e6a:	68 00 00 00 82       	push   $0x82000000
  801e6f:	68 00 00 00 80       	push   $0x80000000
  801e74:	e8 8c 07 00 00       	call   802605 <initialize_dynamic_allocator>
  801e79:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801e7c:	e8 e7 05 00 00       	call   802468 <sys_get_uheap_strategy>
  801e81:	a3 60 c0 81 00       	mov    %eax,0x81c060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801e86:	a1 40 40 80 00       	mov    0x804040,%eax
  801e8b:	05 00 10 00 00       	add    $0x1000,%eax
  801e90:	a3 10 c1 81 00       	mov    %eax,0x81c110
		uheapPageAllocBreak = uheapPageAllocStart;
  801e95:	a1 10 c1 81 00       	mov    0x81c110,%eax
  801e9a:	a3 68 c0 81 00       	mov    %eax,0x81c068

		__firstTimeFlag = 0;
  801e9f:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  801ea6:	00 00 00 
	}
}
  801ea9:	90                   	nop
  801eaa:	c9                   	leave  
  801eab:	c3                   	ret    

00801eac <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801eac:	55                   	push   %ebp
  801ead:	89 e5                	mov    %esp,%ebp
  801eaf:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801eb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801eb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ebb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801ec0:	83 ec 08             	sub    $0x8,%esp
  801ec3:	68 06 04 00 00       	push   $0x406
  801ec8:	50                   	push   %eax
  801ec9:	e8 e4 01 00 00       	call   8020b2 <__sys_allocate_page>
  801ece:	83 c4 10             	add    $0x10,%esp
  801ed1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801ed4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ed8:	79 14                	jns    801eee <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801eda:	83 ec 04             	sub    $0x4,%esp
  801edd:	68 1c 34 80 00       	push   $0x80341c
  801ee2:	6a 1f                	push   $0x1f
  801ee4:	68 58 34 80 00       	push   $0x803458
  801ee9:	e8 af eb ff ff       	call   800a9d <_panic>
	return 0;
  801eee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ef3:	c9                   	leave  
  801ef4:	c3                   	ret    

00801ef5 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801ef5:	55                   	push   %ebp
  801ef6:	89 e5                	mov    %esp,%ebp
  801ef8:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801efb:	8b 45 08             	mov    0x8(%ebp),%eax
  801efe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f04:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801f09:	83 ec 0c             	sub    $0xc,%esp
  801f0c:	50                   	push   %eax
  801f0d:	e8 e7 01 00 00       	call   8020f9 <__sys_unmap_frame>
  801f12:	83 c4 10             	add    $0x10,%esp
  801f15:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801f18:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f1c:	79 14                	jns    801f32 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801f1e:	83 ec 04             	sub    $0x4,%esp
  801f21:	68 64 34 80 00       	push   $0x803464
  801f26:	6a 2a                	push   $0x2a
  801f28:	68 58 34 80 00       	push   $0x803458
  801f2d:	e8 6b eb ff ff       	call   800a9d <_panic>
}
  801f32:	90                   	nop
  801f33:	c9                   	leave  
  801f34:	c3                   	ret    

00801f35 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801f35:	55                   	push   %ebp
  801f36:	89 e5                	mov    %esp,%ebp
  801f38:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801f3b:	e8 18 ff ff ff       	call   801e58 <uheap_init>
	if (size == 0) return NULL ;
  801f40:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f44:	75 07                	jne    801f4d <malloc+0x18>
  801f46:	b8 00 00 00 00       	mov    $0x0,%eax
  801f4b:	eb 14                	jmp    801f61 <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  801f4d:	83 ec 04             	sub    $0x4,%esp
  801f50:	68 a4 34 80 00       	push   $0x8034a4
  801f55:	6a 3e                	push   $0x3e
  801f57:	68 58 34 80 00       	push   $0x803458
  801f5c:	e8 3c eb ff ff       	call   800a9d <_panic>
}
  801f61:	c9                   	leave  
  801f62:	c3                   	ret    

00801f63 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801f63:	55                   	push   %ebp
  801f64:	89 e5                	mov    %esp,%ebp
  801f66:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  801f69:	83 ec 04             	sub    $0x4,%esp
  801f6c:	68 cc 34 80 00       	push   $0x8034cc
  801f71:	6a 49                	push   $0x49
  801f73:	68 58 34 80 00       	push   $0x803458
  801f78:	e8 20 eb ff ff       	call   800a9d <_panic>

00801f7d <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801f7d:	55                   	push   %ebp
  801f7e:	89 e5                	mov    %esp,%ebp
  801f80:	83 ec 18             	sub    $0x18,%esp
  801f83:	8b 45 10             	mov    0x10(%ebp),%eax
  801f86:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801f89:	e8 ca fe ff ff       	call   801e58 <uheap_init>
	if (size == 0) return NULL ;
  801f8e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f92:	75 07                	jne    801f9b <smalloc+0x1e>
  801f94:	b8 00 00 00 00       	mov    $0x0,%eax
  801f99:	eb 14                	jmp    801faf <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  801f9b:	83 ec 04             	sub    $0x4,%esp
  801f9e:	68 f0 34 80 00       	push   $0x8034f0
  801fa3:	6a 5a                	push   $0x5a
  801fa5:	68 58 34 80 00       	push   $0x803458
  801faa:	e8 ee ea ff ff       	call   800a9d <_panic>
}
  801faf:	c9                   	leave  
  801fb0:	c3                   	ret    

00801fb1 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801fb1:	55                   	push   %ebp
  801fb2:	89 e5                	mov    %esp,%ebp
  801fb4:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801fb7:	e8 9c fe ff ff       	call   801e58 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  801fbc:	83 ec 04             	sub    $0x4,%esp
  801fbf:	68 18 35 80 00       	push   $0x803518
  801fc4:	6a 6a                	push   $0x6a
  801fc6:	68 58 34 80 00       	push   $0x803458
  801fcb:	e8 cd ea ff ff       	call   800a9d <_panic>

00801fd0 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801fd0:	55                   	push   %ebp
  801fd1:	89 e5                	mov    %esp,%ebp
  801fd3:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801fd6:	e8 7d fe ff ff       	call   801e58 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  801fdb:	83 ec 04             	sub    $0x4,%esp
  801fde:	68 3c 35 80 00       	push   $0x80353c
  801fe3:	68 88 00 00 00       	push   $0x88
  801fe8:	68 58 34 80 00       	push   $0x803458
  801fed:	e8 ab ea ff ff       	call   800a9d <_panic>

00801ff2 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  801ff2:	55                   	push   %ebp
  801ff3:	89 e5                	mov    %esp,%ebp
  801ff5:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  801ff8:	83 ec 04             	sub    $0x4,%esp
  801ffb:	68 64 35 80 00       	push   $0x803564
  802000:	68 9b 00 00 00       	push   $0x9b
  802005:	68 58 34 80 00       	push   $0x803458
  80200a:	e8 8e ea ff ff       	call   800a9d <_panic>

0080200f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80200f:	55                   	push   %ebp
  802010:	89 e5                	mov    %esp,%ebp
  802012:	57                   	push   %edi
  802013:	56                   	push   %esi
  802014:	53                   	push   %ebx
  802015:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802018:	8b 45 08             	mov    0x8(%ebp),%eax
  80201b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80201e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802021:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802024:	8b 7d 18             	mov    0x18(%ebp),%edi
  802027:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80202a:	cd 30                	int    $0x30
  80202c:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  80202f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802032:	83 c4 10             	add    $0x10,%esp
  802035:	5b                   	pop    %ebx
  802036:	5e                   	pop    %esi
  802037:	5f                   	pop    %edi
  802038:	5d                   	pop    %ebp
  802039:	c3                   	ret    

0080203a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  80203a:	55                   	push   %ebp
  80203b:	89 e5                	mov    %esp,%ebp
  80203d:	83 ec 04             	sub    $0x4,%esp
  802040:	8b 45 10             	mov    0x10(%ebp),%eax
  802043:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  802046:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802049:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80204d:	8b 45 08             	mov    0x8(%ebp),%eax
  802050:	6a 00                	push   $0x0
  802052:	51                   	push   %ecx
  802053:	52                   	push   %edx
  802054:	ff 75 0c             	pushl  0xc(%ebp)
  802057:	50                   	push   %eax
  802058:	6a 00                	push   $0x0
  80205a:	e8 b0 ff ff ff       	call   80200f <syscall>
  80205f:	83 c4 18             	add    $0x18,%esp
}
  802062:	90                   	nop
  802063:	c9                   	leave  
  802064:	c3                   	ret    

00802065 <sys_cgetc>:

int
sys_cgetc(void)
{
  802065:	55                   	push   %ebp
  802066:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802068:	6a 00                	push   $0x0
  80206a:	6a 00                	push   $0x0
  80206c:	6a 00                	push   $0x0
  80206e:	6a 00                	push   $0x0
  802070:	6a 00                	push   $0x0
  802072:	6a 02                	push   $0x2
  802074:	e8 96 ff ff ff       	call   80200f <syscall>
  802079:	83 c4 18             	add    $0x18,%esp
}
  80207c:	c9                   	leave  
  80207d:	c3                   	ret    

0080207e <sys_lock_cons>:

void sys_lock_cons(void)
{
  80207e:	55                   	push   %ebp
  80207f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802081:	6a 00                	push   $0x0
  802083:	6a 00                	push   $0x0
  802085:	6a 00                	push   $0x0
  802087:	6a 00                	push   $0x0
  802089:	6a 00                	push   $0x0
  80208b:	6a 03                	push   $0x3
  80208d:	e8 7d ff ff ff       	call   80200f <syscall>
  802092:	83 c4 18             	add    $0x18,%esp
}
  802095:	90                   	nop
  802096:	c9                   	leave  
  802097:	c3                   	ret    

00802098 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802098:	55                   	push   %ebp
  802099:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80209b:	6a 00                	push   $0x0
  80209d:	6a 00                	push   $0x0
  80209f:	6a 00                	push   $0x0
  8020a1:	6a 00                	push   $0x0
  8020a3:	6a 00                	push   $0x0
  8020a5:	6a 04                	push   $0x4
  8020a7:	e8 63 ff ff ff       	call   80200f <syscall>
  8020ac:	83 c4 18             	add    $0x18,%esp
}
  8020af:	90                   	nop
  8020b0:	c9                   	leave  
  8020b1:	c3                   	ret    

008020b2 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8020b2:	55                   	push   %ebp
  8020b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8020b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bb:	6a 00                	push   $0x0
  8020bd:	6a 00                	push   $0x0
  8020bf:	6a 00                	push   $0x0
  8020c1:	52                   	push   %edx
  8020c2:	50                   	push   %eax
  8020c3:	6a 08                	push   $0x8
  8020c5:	e8 45 ff ff ff       	call   80200f <syscall>
  8020ca:	83 c4 18             	add    $0x18,%esp
}
  8020cd:	c9                   	leave  
  8020ce:	c3                   	ret    

008020cf <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8020cf:	55                   	push   %ebp
  8020d0:	89 e5                	mov    %esp,%ebp
  8020d2:	56                   	push   %esi
  8020d3:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8020d4:	8b 75 18             	mov    0x18(%ebp),%esi
  8020d7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8020da:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e3:	56                   	push   %esi
  8020e4:	53                   	push   %ebx
  8020e5:	51                   	push   %ecx
  8020e6:	52                   	push   %edx
  8020e7:	50                   	push   %eax
  8020e8:	6a 09                	push   $0x9
  8020ea:	e8 20 ff ff ff       	call   80200f <syscall>
  8020ef:	83 c4 18             	add    $0x18,%esp
}
  8020f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020f5:	5b                   	pop    %ebx
  8020f6:	5e                   	pop    %esi
  8020f7:	5d                   	pop    %ebp
  8020f8:	c3                   	ret    

008020f9 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8020f9:	55                   	push   %ebp
  8020fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8020fc:	6a 00                	push   $0x0
  8020fe:	6a 00                	push   $0x0
  802100:	6a 00                	push   $0x0
  802102:	6a 00                	push   $0x0
  802104:	ff 75 08             	pushl  0x8(%ebp)
  802107:	6a 0a                	push   $0xa
  802109:	e8 01 ff ff ff       	call   80200f <syscall>
  80210e:	83 c4 18             	add    $0x18,%esp
}
  802111:	c9                   	leave  
  802112:	c3                   	ret    

00802113 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802113:	55                   	push   %ebp
  802114:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802116:	6a 00                	push   $0x0
  802118:	6a 00                	push   $0x0
  80211a:	6a 00                	push   $0x0
  80211c:	ff 75 0c             	pushl  0xc(%ebp)
  80211f:	ff 75 08             	pushl  0x8(%ebp)
  802122:	6a 0b                	push   $0xb
  802124:	e8 e6 fe ff ff       	call   80200f <syscall>
  802129:	83 c4 18             	add    $0x18,%esp
}
  80212c:	c9                   	leave  
  80212d:	c3                   	ret    

0080212e <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80212e:	55                   	push   %ebp
  80212f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802131:	6a 00                	push   $0x0
  802133:	6a 00                	push   $0x0
  802135:	6a 00                	push   $0x0
  802137:	6a 00                	push   $0x0
  802139:	6a 00                	push   $0x0
  80213b:	6a 0c                	push   $0xc
  80213d:	e8 cd fe ff ff       	call   80200f <syscall>
  802142:	83 c4 18             	add    $0x18,%esp
}
  802145:	c9                   	leave  
  802146:	c3                   	ret    

00802147 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802147:	55                   	push   %ebp
  802148:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80214a:	6a 00                	push   $0x0
  80214c:	6a 00                	push   $0x0
  80214e:	6a 00                	push   $0x0
  802150:	6a 00                	push   $0x0
  802152:	6a 00                	push   $0x0
  802154:	6a 0d                	push   $0xd
  802156:	e8 b4 fe ff ff       	call   80200f <syscall>
  80215b:	83 c4 18             	add    $0x18,%esp
}
  80215e:	c9                   	leave  
  80215f:	c3                   	ret    

00802160 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802160:	55                   	push   %ebp
  802161:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802163:	6a 00                	push   $0x0
  802165:	6a 00                	push   $0x0
  802167:	6a 00                	push   $0x0
  802169:	6a 00                	push   $0x0
  80216b:	6a 00                	push   $0x0
  80216d:	6a 0e                	push   $0xe
  80216f:	e8 9b fe ff ff       	call   80200f <syscall>
  802174:	83 c4 18             	add    $0x18,%esp
}
  802177:	c9                   	leave  
  802178:	c3                   	ret    

00802179 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802179:	55                   	push   %ebp
  80217a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80217c:	6a 00                	push   $0x0
  80217e:	6a 00                	push   $0x0
  802180:	6a 00                	push   $0x0
  802182:	6a 00                	push   $0x0
  802184:	6a 00                	push   $0x0
  802186:	6a 0f                	push   $0xf
  802188:	e8 82 fe ff ff       	call   80200f <syscall>
  80218d:	83 c4 18             	add    $0x18,%esp
}
  802190:	c9                   	leave  
  802191:	c3                   	ret    

00802192 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802192:	55                   	push   %ebp
  802193:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802195:	6a 00                	push   $0x0
  802197:	6a 00                	push   $0x0
  802199:	6a 00                	push   $0x0
  80219b:	6a 00                	push   $0x0
  80219d:	ff 75 08             	pushl  0x8(%ebp)
  8021a0:	6a 10                	push   $0x10
  8021a2:	e8 68 fe ff ff       	call   80200f <syscall>
  8021a7:	83 c4 18             	add    $0x18,%esp
}
  8021aa:	c9                   	leave  
  8021ab:	c3                   	ret    

008021ac <sys_scarce_memory>:

void sys_scarce_memory()
{
  8021ac:	55                   	push   %ebp
  8021ad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8021af:	6a 00                	push   $0x0
  8021b1:	6a 00                	push   $0x0
  8021b3:	6a 00                	push   $0x0
  8021b5:	6a 00                	push   $0x0
  8021b7:	6a 00                	push   $0x0
  8021b9:	6a 11                	push   $0x11
  8021bb:	e8 4f fe ff ff       	call   80200f <syscall>
  8021c0:	83 c4 18             	add    $0x18,%esp
}
  8021c3:	90                   	nop
  8021c4:	c9                   	leave  
  8021c5:	c3                   	ret    

008021c6 <sys_cputc>:

void
sys_cputc(const char c)
{
  8021c6:	55                   	push   %ebp
  8021c7:	89 e5                	mov    %esp,%ebp
  8021c9:	83 ec 04             	sub    $0x4,%esp
  8021cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8021d2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8021d6:	6a 00                	push   $0x0
  8021d8:	6a 00                	push   $0x0
  8021da:	6a 00                	push   $0x0
  8021dc:	6a 00                	push   $0x0
  8021de:	50                   	push   %eax
  8021df:	6a 01                	push   $0x1
  8021e1:	e8 29 fe ff ff       	call   80200f <syscall>
  8021e6:	83 c4 18             	add    $0x18,%esp
}
  8021e9:	90                   	nop
  8021ea:	c9                   	leave  
  8021eb:	c3                   	ret    

008021ec <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8021ec:	55                   	push   %ebp
  8021ed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8021ef:	6a 00                	push   $0x0
  8021f1:	6a 00                	push   $0x0
  8021f3:	6a 00                	push   $0x0
  8021f5:	6a 00                	push   $0x0
  8021f7:	6a 00                	push   $0x0
  8021f9:	6a 14                	push   $0x14
  8021fb:	e8 0f fe ff ff       	call   80200f <syscall>
  802200:	83 c4 18             	add    $0x18,%esp
}
  802203:	90                   	nop
  802204:	c9                   	leave  
  802205:	c3                   	ret    

00802206 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802206:	55                   	push   %ebp
  802207:	89 e5                	mov    %esp,%ebp
  802209:	83 ec 04             	sub    $0x4,%esp
  80220c:	8b 45 10             	mov    0x10(%ebp),%eax
  80220f:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802212:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802215:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802219:	8b 45 08             	mov    0x8(%ebp),%eax
  80221c:	6a 00                	push   $0x0
  80221e:	51                   	push   %ecx
  80221f:	52                   	push   %edx
  802220:	ff 75 0c             	pushl  0xc(%ebp)
  802223:	50                   	push   %eax
  802224:	6a 15                	push   $0x15
  802226:	e8 e4 fd ff ff       	call   80200f <syscall>
  80222b:	83 c4 18             	add    $0x18,%esp
}
  80222e:	c9                   	leave  
  80222f:	c3                   	ret    

00802230 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  802230:	55                   	push   %ebp
  802231:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802233:	8b 55 0c             	mov    0xc(%ebp),%edx
  802236:	8b 45 08             	mov    0x8(%ebp),%eax
  802239:	6a 00                	push   $0x0
  80223b:	6a 00                	push   $0x0
  80223d:	6a 00                	push   $0x0
  80223f:	52                   	push   %edx
  802240:	50                   	push   %eax
  802241:	6a 16                	push   $0x16
  802243:	e8 c7 fd ff ff       	call   80200f <syscall>
  802248:	83 c4 18             	add    $0x18,%esp
}
  80224b:	c9                   	leave  
  80224c:	c3                   	ret    

0080224d <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  80224d:	55                   	push   %ebp
  80224e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802250:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802253:	8b 55 0c             	mov    0xc(%ebp),%edx
  802256:	8b 45 08             	mov    0x8(%ebp),%eax
  802259:	6a 00                	push   $0x0
  80225b:	6a 00                	push   $0x0
  80225d:	51                   	push   %ecx
  80225e:	52                   	push   %edx
  80225f:	50                   	push   %eax
  802260:	6a 17                	push   $0x17
  802262:	e8 a8 fd ff ff       	call   80200f <syscall>
  802267:	83 c4 18             	add    $0x18,%esp
}
  80226a:	c9                   	leave  
  80226b:	c3                   	ret    

0080226c <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  80226c:	55                   	push   %ebp
  80226d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80226f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802272:	8b 45 08             	mov    0x8(%ebp),%eax
  802275:	6a 00                	push   $0x0
  802277:	6a 00                	push   $0x0
  802279:	6a 00                	push   $0x0
  80227b:	52                   	push   %edx
  80227c:	50                   	push   %eax
  80227d:	6a 18                	push   $0x18
  80227f:	e8 8b fd ff ff       	call   80200f <syscall>
  802284:	83 c4 18             	add    $0x18,%esp
}
  802287:	c9                   	leave  
  802288:	c3                   	ret    

00802289 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802289:	55                   	push   %ebp
  80228a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80228c:	8b 45 08             	mov    0x8(%ebp),%eax
  80228f:	6a 00                	push   $0x0
  802291:	ff 75 14             	pushl  0x14(%ebp)
  802294:	ff 75 10             	pushl  0x10(%ebp)
  802297:	ff 75 0c             	pushl  0xc(%ebp)
  80229a:	50                   	push   %eax
  80229b:	6a 19                	push   $0x19
  80229d:	e8 6d fd ff ff       	call   80200f <syscall>
  8022a2:	83 c4 18             	add    $0x18,%esp
}
  8022a5:	c9                   	leave  
  8022a6:	c3                   	ret    

008022a7 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8022a7:	55                   	push   %ebp
  8022a8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8022aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ad:	6a 00                	push   $0x0
  8022af:	6a 00                	push   $0x0
  8022b1:	6a 00                	push   $0x0
  8022b3:	6a 00                	push   $0x0
  8022b5:	50                   	push   %eax
  8022b6:	6a 1a                	push   $0x1a
  8022b8:	e8 52 fd ff ff       	call   80200f <syscall>
  8022bd:	83 c4 18             	add    $0x18,%esp
}
  8022c0:	90                   	nop
  8022c1:	c9                   	leave  
  8022c2:	c3                   	ret    

008022c3 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8022c3:	55                   	push   %ebp
  8022c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8022c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c9:	6a 00                	push   $0x0
  8022cb:	6a 00                	push   $0x0
  8022cd:	6a 00                	push   $0x0
  8022cf:	6a 00                	push   $0x0
  8022d1:	50                   	push   %eax
  8022d2:	6a 1b                	push   $0x1b
  8022d4:	e8 36 fd ff ff       	call   80200f <syscall>
  8022d9:	83 c4 18             	add    $0x18,%esp
}
  8022dc:	c9                   	leave  
  8022dd:	c3                   	ret    

008022de <sys_getenvid>:

int32 sys_getenvid(void)
{
  8022de:	55                   	push   %ebp
  8022df:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8022e1:	6a 00                	push   $0x0
  8022e3:	6a 00                	push   $0x0
  8022e5:	6a 00                	push   $0x0
  8022e7:	6a 00                	push   $0x0
  8022e9:	6a 00                	push   $0x0
  8022eb:	6a 05                	push   $0x5
  8022ed:	e8 1d fd ff ff       	call   80200f <syscall>
  8022f2:	83 c4 18             	add    $0x18,%esp
}
  8022f5:	c9                   	leave  
  8022f6:	c3                   	ret    

008022f7 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8022f7:	55                   	push   %ebp
  8022f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8022fa:	6a 00                	push   $0x0
  8022fc:	6a 00                	push   $0x0
  8022fe:	6a 00                	push   $0x0
  802300:	6a 00                	push   $0x0
  802302:	6a 00                	push   $0x0
  802304:	6a 06                	push   $0x6
  802306:	e8 04 fd ff ff       	call   80200f <syscall>
  80230b:	83 c4 18             	add    $0x18,%esp
}
  80230e:	c9                   	leave  
  80230f:	c3                   	ret    

00802310 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802310:	55                   	push   %ebp
  802311:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802313:	6a 00                	push   $0x0
  802315:	6a 00                	push   $0x0
  802317:	6a 00                	push   $0x0
  802319:	6a 00                	push   $0x0
  80231b:	6a 00                	push   $0x0
  80231d:	6a 07                	push   $0x7
  80231f:	e8 eb fc ff ff       	call   80200f <syscall>
  802324:	83 c4 18             	add    $0x18,%esp
}
  802327:	c9                   	leave  
  802328:	c3                   	ret    

00802329 <sys_exit_env>:


void sys_exit_env(void)
{
  802329:	55                   	push   %ebp
  80232a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80232c:	6a 00                	push   $0x0
  80232e:	6a 00                	push   $0x0
  802330:	6a 00                	push   $0x0
  802332:	6a 00                	push   $0x0
  802334:	6a 00                	push   $0x0
  802336:	6a 1c                	push   $0x1c
  802338:	e8 d2 fc ff ff       	call   80200f <syscall>
  80233d:	83 c4 18             	add    $0x18,%esp
}
  802340:	90                   	nop
  802341:	c9                   	leave  
  802342:	c3                   	ret    

00802343 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802343:	55                   	push   %ebp
  802344:	89 e5                	mov    %esp,%ebp
  802346:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802349:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80234c:	8d 50 04             	lea    0x4(%eax),%edx
  80234f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802352:	6a 00                	push   $0x0
  802354:	6a 00                	push   $0x0
  802356:	6a 00                	push   $0x0
  802358:	52                   	push   %edx
  802359:	50                   	push   %eax
  80235a:	6a 1d                	push   $0x1d
  80235c:	e8 ae fc ff ff       	call   80200f <syscall>
  802361:	83 c4 18             	add    $0x18,%esp
	return result;
  802364:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802367:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80236a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80236d:	89 01                	mov    %eax,(%ecx)
  80236f:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802372:	8b 45 08             	mov    0x8(%ebp),%eax
  802375:	c9                   	leave  
  802376:	c2 04 00             	ret    $0x4

00802379 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802379:	55                   	push   %ebp
  80237a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80237c:	6a 00                	push   $0x0
  80237e:	6a 00                	push   $0x0
  802380:	ff 75 10             	pushl  0x10(%ebp)
  802383:	ff 75 0c             	pushl  0xc(%ebp)
  802386:	ff 75 08             	pushl  0x8(%ebp)
  802389:	6a 13                	push   $0x13
  80238b:	e8 7f fc ff ff       	call   80200f <syscall>
  802390:	83 c4 18             	add    $0x18,%esp
	return ;
  802393:	90                   	nop
}
  802394:	c9                   	leave  
  802395:	c3                   	ret    

00802396 <sys_rcr2>:
uint32 sys_rcr2()
{
  802396:	55                   	push   %ebp
  802397:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802399:	6a 00                	push   $0x0
  80239b:	6a 00                	push   $0x0
  80239d:	6a 00                	push   $0x0
  80239f:	6a 00                	push   $0x0
  8023a1:	6a 00                	push   $0x0
  8023a3:	6a 1e                	push   $0x1e
  8023a5:	e8 65 fc ff ff       	call   80200f <syscall>
  8023aa:	83 c4 18             	add    $0x18,%esp
}
  8023ad:	c9                   	leave  
  8023ae:	c3                   	ret    

008023af <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8023af:	55                   	push   %ebp
  8023b0:	89 e5                	mov    %esp,%ebp
  8023b2:	83 ec 04             	sub    $0x4,%esp
  8023b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8023bb:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8023bf:	6a 00                	push   $0x0
  8023c1:	6a 00                	push   $0x0
  8023c3:	6a 00                	push   $0x0
  8023c5:	6a 00                	push   $0x0
  8023c7:	50                   	push   %eax
  8023c8:	6a 1f                	push   $0x1f
  8023ca:	e8 40 fc ff ff       	call   80200f <syscall>
  8023cf:	83 c4 18             	add    $0x18,%esp
	return ;
  8023d2:	90                   	nop
}
  8023d3:	c9                   	leave  
  8023d4:	c3                   	ret    

008023d5 <rsttst>:
void rsttst()
{
  8023d5:	55                   	push   %ebp
  8023d6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8023d8:	6a 00                	push   $0x0
  8023da:	6a 00                	push   $0x0
  8023dc:	6a 00                	push   $0x0
  8023de:	6a 00                	push   $0x0
  8023e0:	6a 00                	push   $0x0
  8023e2:	6a 21                	push   $0x21
  8023e4:	e8 26 fc ff ff       	call   80200f <syscall>
  8023e9:	83 c4 18             	add    $0x18,%esp
	return ;
  8023ec:	90                   	nop
}
  8023ed:	c9                   	leave  
  8023ee:	c3                   	ret    

008023ef <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8023ef:	55                   	push   %ebp
  8023f0:	89 e5                	mov    %esp,%ebp
  8023f2:	83 ec 04             	sub    $0x4,%esp
  8023f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8023f8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8023fb:	8b 55 18             	mov    0x18(%ebp),%edx
  8023fe:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802402:	52                   	push   %edx
  802403:	50                   	push   %eax
  802404:	ff 75 10             	pushl  0x10(%ebp)
  802407:	ff 75 0c             	pushl  0xc(%ebp)
  80240a:	ff 75 08             	pushl  0x8(%ebp)
  80240d:	6a 20                	push   $0x20
  80240f:	e8 fb fb ff ff       	call   80200f <syscall>
  802414:	83 c4 18             	add    $0x18,%esp
	return ;
  802417:	90                   	nop
}
  802418:	c9                   	leave  
  802419:	c3                   	ret    

0080241a <chktst>:
void chktst(uint32 n)
{
  80241a:	55                   	push   %ebp
  80241b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80241d:	6a 00                	push   $0x0
  80241f:	6a 00                	push   $0x0
  802421:	6a 00                	push   $0x0
  802423:	6a 00                	push   $0x0
  802425:	ff 75 08             	pushl  0x8(%ebp)
  802428:	6a 22                	push   $0x22
  80242a:	e8 e0 fb ff ff       	call   80200f <syscall>
  80242f:	83 c4 18             	add    $0x18,%esp
	return ;
  802432:	90                   	nop
}
  802433:	c9                   	leave  
  802434:	c3                   	ret    

00802435 <inctst>:

void inctst()
{
  802435:	55                   	push   %ebp
  802436:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802438:	6a 00                	push   $0x0
  80243a:	6a 00                	push   $0x0
  80243c:	6a 00                	push   $0x0
  80243e:	6a 00                	push   $0x0
  802440:	6a 00                	push   $0x0
  802442:	6a 23                	push   $0x23
  802444:	e8 c6 fb ff ff       	call   80200f <syscall>
  802449:	83 c4 18             	add    $0x18,%esp
	return ;
  80244c:	90                   	nop
}
  80244d:	c9                   	leave  
  80244e:	c3                   	ret    

0080244f <gettst>:
uint32 gettst()
{
  80244f:	55                   	push   %ebp
  802450:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802452:	6a 00                	push   $0x0
  802454:	6a 00                	push   $0x0
  802456:	6a 00                	push   $0x0
  802458:	6a 00                	push   $0x0
  80245a:	6a 00                	push   $0x0
  80245c:	6a 24                	push   $0x24
  80245e:	e8 ac fb ff ff       	call   80200f <syscall>
  802463:	83 c4 18             	add    $0x18,%esp
}
  802466:	c9                   	leave  
  802467:	c3                   	ret    

00802468 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  802468:	55                   	push   %ebp
  802469:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80246b:	6a 00                	push   $0x0
  80246d:	6a 00                	push   $0x0
  80246f:	6a 00                	push   $0x0
  802471:	6a 00                	push   $0x0
  802473:	6a 00                	push   $0x0
  802475:	6a 25                	push   $0x25
  802477:	e8 93 fb ff ff       	call   80200f <syscall>
  80247c:	83 c4 18             	add    $0x18,%esp
  80247f:	a3 60 c0 81 00       	mov    %eax,0x81c060
	return uheapPlaceStrategy ;
  802484:	a1 60 c0 81 00       	mov    0x81c060,%eax
}
  802489:	c9                   	leave  
  80248a:	c3                   	ret    

0080248b <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80248b:	55                   	push   %ebp
  80248c:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  80248e:	8b 45 08             	mov    0x8(%ebp),%eax
  802491:	a3 60 c0 81 00       	mov    %eax,0x81c060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802496:	6a 00                	push   $0x0
  802498:	6a 00                	push   $0x0
  80249a:	6a 00                	push   $0x0
  80249c:	6a 00                	push   $0x0
  80249e:	ff 75 08             	pushl  0x8(%ebp)
  8024a1:	6a 26                	push   $0x26
  8024a3:	e8 67 fb ff ff       	call   80200f <syscall>
  8024a8:	83 c4 18             	add    $0x18,%esp
	return ;
  8024ab:	90                   	nop
}
  8024ac:	c9                   	leave  
  8024ad:	c3                   	ret    

008024ae <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8024ae:	55                   	push   %ebp
  8024af:	89 e5                	mov    %esp,%ebp
  8024b1:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8024b2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8024b5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8024b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8024be:	6a 00                	push   $0x0
  8024c0:	53                   	push   %ebx
  8024c1:	51                   	push   %ecx
  8024c2:	52                   	push   %edx
  8024c3:	50                   	push   %eax
  8024c4:	6a 27                	push   $0x27
  8024c6:	e8 44 fb ff ff       	call   80200f <syscall>
  8024cb:	83 c4 18             	add    $0x18,%esp
}
  8024ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024d1:	c9                   	leave  
  8024d2:	c3                   	ret    

008024d3 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8024d3:	55                   	push   %ebp
  8024d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8024d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024dc:	6a 00                	push   $0x0
  8024de:	6a 00                	push   $0x0
  8024e0:	6a 00                	push   $0x0
  8024e2:	52                   	push   %edx
  8024e3:	50                   	push   %eax
  8024e4:	6a 28                	push   $0x28
  8024e6:	e8 24 fb ff ff       	call   80200f <syscall>
  8024eb:	83 c4 18             	add    $0x18,%esp
}
  8024ee:	c9                   	leave  
  8024ef:	c3                   	ret    

008024f0 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8024f0:	55                   	push   %ebp
  8024f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8024f3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8024f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024fc:	6a 00                	push   $0x0
  8024fe:	51                   	push   %ecx
  8024ff:	ff 75 10             	pushl  0x10(%ebp)
  802502:	52                   	push   %edx
  802503:	50                   	push   %eax
  802504:	6a 29                	push   $0x29
  802506:	e8 04 fb ff ff       	call   80200f <syscall>
  80250b:	83 c4 18             	add    $0x18,%esp
}
  80250e:	c9                   	leave  
  80250f:	c3                   	ret    

00802510 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802510:	55                   	push   %ebp
  802511:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802513:	6a 00                	push   $0x0
  802515:	6a 00                	push   $0x0
  802517:	ff 75 10             	pushl  0x10(%ebp)
  80251a:	ff 75 0c             	pushl  0xc(%ebp)
  80251d:	ff 75 08             	pushl  0x8(%ebp)
  802520:	6a 12                	push   $0x12
  802522:	e8 e8 fa ff ff       	call   80200f <syscall>
  802527:	83 c4 18             	add    $0x18,%esp
	return ;
  80252a:	90                   	nop
}
  80252b:	c9                   	leave  
  80252c:	c3                   	ret    

0080252d <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80252d:	55                   	push   %ebp
  80252e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802530:	8b 55 0c             	mov    0xc(%ebp),%edx
  802533:	8b 45 08             	mov    0x8(%ebp),%eax
  802536:	6a 00                	push   $0x0
  802538:	6a 00                	push   $0x0
  80253a:	6a 00                	push   $0x0
  80253c:	52                   	push   %edx
  80253d:	50                   	push   %eax
  80253e:	6a 2a                	push   $0x2a
  802540:	e8 ca fa ff ff       	call   80200f <syscall>
  802545:	83 c4 18             	add    $0x18,%esp
	return;
  802548:	90                   	nop
}
  802549:	c9                   	leave  
  80254a:	c3                   	ret    

0080254b <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  80254b:	55                   	push   %ebp
  80254c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  80254e:	6a 00                	push   $0x0
  802550:	6a 00                	push   $0x0
  802552:	6a 00                	push   $0x0
  802554:	6a 00                	push   $0x0
  802556:	6a 00                	push   $0x0
  802558:	6a 2b                	push   $0x2b
  80255a:	e8 b0 fa ff ff       	call   80200f <syscall>
  80255f:	83 c4 18             	add    $0x18,%esp
}
  802562:	c9                   	leave  
  802563:	c3                   	ret    

00802564 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802564:	55                   	push   %ebp
  802565:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802567:	6a 00                	push   $0x0
  802569:	6a 00                	push   $0x0
  80256b:	6a 00                	push   $0x0
  80256d:	ff 75 0c             	pushl  0xc(%ebp)
  802570:	ff 75 08             	pushl  0x8(%ebp)
  802573:	6a 2d                	push   $0x2d
  802575:	e8 95 fa ff ff       	call   80200f <syscall>
  80257a:	83 c4 18             	add    $0x18,%esp
	return;
  80257d:	90                   	nop
}
  80257e:	c9                   	leave  
  80257f:	c3                   	ret    

00802580 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802580:	55                   	push   %ebp
  802581:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802583:	6a 00                	push   $0x0
  802585:	6a 00                	push   $0x0
  802587:	6a 00                	push   $0x0
  802589:	ff 75 0c             	pushl  0xc(%ebp)
  80258c:	ff 75 08             	pushl  0x8(%ebp)
  80258f:	6a 2c                	push   $0x2c
  802591:	e8 79 fa ff ff       	call   80200f <syscall>
  802596:	83 c4 18             	add    $0x18,%esp
	return ;
  802599:	90                   	nop
}
  80259a:	c9                   	leave  
  80259b:	c3                   	ret    

0080259c <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  80259c:	55                   	push   %ebp
  80259d:	89 e5                	mov    %esp,%ebp
  80259f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  8025a2:	83 ec 04             	sub    $0x4,%esp
  8025a5:	68 88 35 80 00       	push   $0x803588
  8025aa:	68 25 01 00 00       	push   $0x125
  8025af:	68 bb 35 80 00       	push   $0x8035bb
  8025b4:	e8 e4 e4 ff ff       	call   800a9d <_panic>

008025b9 <to_page_va>:
//==================================================================================//
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  8025b9:	55                   	push   %ebp
  8025ba:	89 e5                	mov    %esp,%ebp
  8025bc:	83 ec 10             	sub    $0x10,%esp
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  8025bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c2:	ba 60 40 80 00       	mov    $0x804060,%edx
  8025c7:	29 d0                	sub    %edx,%eax
  8025c9:	c1 f8 02             	sar    $0x2,%eax
  8025cc:	89 c2                	mov    %eax,%edx
  8025ce:	89 d0                	mov    %edx,%eax
  8025d0:	c1 e0 02             	shl    $0x2,%eax
  8025d3:	01 d0                	add    %edx,%eax
  8025d5:	c1 e0 02             	shl    $0x2,%eax
  8025d8:	01 d0                	add    %edx,%eax
  8025da:	c1 e0 02             	shl    $0x2,%eax
  8025dd:	01 d0                	add    %edx,%eax
  8025df:	89 c1                	mov    %eax,%ecx
  8025e1:	c1 e1 08             	shl    $0x8,%ecx
  8025e4:	01 c8                	add    %ecx,%eax
  8025e6:	89 c1                	mov    %eax,%ecx
  8025e8:	c1 e1 10             	shl    $0x10,%ecx
  8025eb:	01 c8                	add    %ecx,%eax
  8025ed:	01 c0                	add    %eax,%eax
  8025ef:	01 d0                	add    %edx,%eax
  8025f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  8025f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025f7:	c1 e0 0c             	shl    $0xc,%eax
  8025fa:	89 c2                	mov    %eax,%edx
  8025fc:	a1 64 c0 81 00       	mov    0x81c064,%eax
  802601:	01 d0                	add    %edx,%eax
}
  802603:	c9                   	leave  
  802604:	c3                   	ret    

00802605 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  802605:	55                   	push   %ebp
  802606:	89 e5                	mov    %esp,%ebp
  802608:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  80260b:	8b 45 08             	mov    0x8(%ebp),%eax
  80260e:	05 00 00 00 02       	add    $0x2000000,%eax
  802613:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802616:	73 16                	jae    80262e <initialize_dynamic_allocator+0x29>
  802618:	68 cc 35 80 00       	push   $0x8035cc
  80261d:	68 f2 35 80 00       	push   $0x8035f2
  802622:	6a 26                	push   $0x26
  802624:	68 07 36 80 00       	push   $0x803607
  802629:	e8 6f e4 ff ff       	call   800a9d <_panic>
		is_initialized = 1;
  80262e:	c7 05 24 40 80 00 01 	movl   $0x1,0x804024
  802635:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	//Comment the following line
	panic("initialize_dynamic_allocator() Not implemented yet");
  802638:	83 ec 04             	sub    $0x4,%esp
  80263b:	68 20 36 80 00       	push   $0x803620
  802640:	6a 2e                	push   $0x2e
  802642:	68 07 36 80 00       	push   $0x803607
  802647:	e8 51 e4 ff ff       	call   800a9d <_panic>

0080264c <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  80264c:	55                   	push   %ebp
  80264d:	89 e5                	mov    %esp,%ebp
  80264f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	//Comment the following line
	panic("get_block_size() Not implemented yet");
  802652:	83 ec 04             	sub    $0x4,%esp
  802655:	68 54 36 80 00       	push   $0x803654
  80265a:	6a 3a                	push   $0x3a
  80265c:	68 07 36 80 00       	push   $0x803607
  802661:	e8 37 e4 ff ff       	call   800a9d <_panic>

00802666 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  802666:	55                   	push   %ebp
  802667:	89 e5                	mov    %esp,%ebp
  802669:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  80266c:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802673:	76 16                	jbe    80268b <alloc_block+0x25>
  802675:	68 7c 36 80 00       	push   $0x80367c
  80267a:	68 f2 35 80 00       	push   $0x8035f2
  80267f:	6a 46                	push   $0x46
  802681:	68 07 36 80 00       	push   $0x803607
  802686:	e8 12 e4 ff ff       	call   800a9d <_panic>
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	panic("alloc_block() Not implemented yet");
  80268b:	83 ec 04             	sub    $0x4,%esp
  80268e:	68 a0 36 80 00       	push   $0x8036a0
  802693:	6a 4d                	push   $0x4d
  802695:	68 07 36 80 00       	push   $0x803607
  80269a:	e8 fe e3 ff ff       	call   800a9d <_panic>

0080269f <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  80269f:	55                   	push   %ebp
  8026a0:	89 e5                	mov    %esp,%ebp
  8026a2:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  8026a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8026a8:	a1 64 c0 81 00       	mov    0x81c064,%eax
  8026ad:	39 c2                	cmp    %eax,%edx
  8026af:	72 0c                	jb     8026bd <free_block+0x1e>
  8026b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8026b4:	a1 40 40 80 00       	mov    0x804040,%eax
  8026b9:	39 c2                	cmp    %eax,%edx
  8026bb:	72 16                	jb     8026d3 <free_block+0x34>
  8026bd:	68 c4 36 80 00       	push   $0x8036c4
  8026c2:	68 f2 35 80 00       	push   $0x8035f2
  8026c7:	6a 5b                	push   $0x5b
  8026c9:	68 07 36 80 00       	push   $0x803607
  8026ce:	e8 ca e3 ff ff       	call   800a9d <_panic>
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	panic("free_block() Not implemented yet");
  8026d3:	83 ec 04             	sub    $0x4,%esp
  8026d6:	68 fc 36 80 00       	push   $0x8036fc
  8026db:	6a 63                	push   $0x63
  8026dd:	68 07 36 80 00       	push   $0x803607
  8026e2:	e8 b6 e3 ff ff       	call   800a9d <_panic>

008026e7 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  8026e7:	55                   	push   %ebp
  8026e8:	89 e5                	mov    %esp,%ebp
  8026ea:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  8026ed:	83 ec 04             	sub    $0x4,%esp
  8026f0:	68 20 37 80 00       	push   $0x803720
  8026f5:	6a 72                	push   $0x72
  8026f7:	68 07 36 80 00       	push   $0x803607
  8026fc:	e8 9c e3 ff ff       	call   800a9d <_panic>

00802701 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  802701:	55                   	push   %ebp
  802702:	89 e5                	mov    %esp,%ebp
  802704:	83 ec 08             	sub    $0x8,%esp
	panic("create_semaphore() is not implemented yet...!!");
  802707:	83 ec 04             	sub    $0x4,%esp
  80270a:	68 44 37 80 00       	push   $0x803744
  80270f:	6a 07                	push   $0x7
  802711:	68 73 37 80 00       	push   $0x803773
  802716:	e8 82 e3 ff ff       	call   800a9d <_panic>

0080271b <get_semaphore>:
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  80271b:	55                   	push   %ebp
  80271c:	89 e5                	mov    %esp,%ebp
  80271e:	83 ec 08             	sub    $0x8,%esp
	panic("get_semaphore() is not implemented yet...!!");
  802721:	83 ec 04             	sub    $0x4,%esp
  802724:	68 84 37 80 00       	push   $0x803784
  802729:	6a 0b                	push   $0xb
  80272b:	68 73 37 80 00       	push   $0x803773
  802730:	e8 68 e3 ff ff       	call   800a9d <_panic>

00802735 <wait_semaphore>:
}

void wait_semaphore(struct semaphore sem)
{
  802735:	55                   	push   %ebp
  802736:	89 e5                	mov    %esp,%ebp
  802738:	83 ec 08             	sub    $0x8,%esp
	panic("wait_semaphore() is not implemented yet...!!");
  80273b:	83 ec 04             	sub    $0x4,%esp
  80273e:	68 b0 37 80 00       	push   $0x8037b0
  802743:	6a 10                	push   $0x10
  802745:	68 73 37 80 00       	push   $0x803773
  80274a:	e8 4e e3 ff ff       	call   800a9d <_panic>

0080274f <signal_semaphore>:
}

void signal_semaphore(struct semaphore sem)
{
  80274f:	55                   	push   %ebp
  802750:	89 e5                	mov    %esp,%ebp
  802752:	83 ec 08             	sub    $0x8,%esp
	panic("signal_semaphore() is not implemented yet...!!");
  802755:	83 ec 04             	sub    $0x4,%esp
  802758:	68 e0 37 80 00       	push   $0x8037e0
  80275d:	6a 15                	push   $0x15
  80275f:	68 73 37 80 00       	push   $0x803773
  802764:	e8 34 e3 ff ff       	call   800a9d <_panic>

00802769 <semaphore_count>:
}

int semaphore_count(struct semaphore sem)
{
  802769:	55                   	push   %ebp
  80276a:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  80276c:	8b 45 08             	mov    0x8(%ebp),%eax
  80276f:	8b 40 10             	mov    0x10(%eax),%eax
}
  802772:	5d                   	pop    %ebp
  802773:	c3                   	ret    

00802774 <__divdi3>:
  802774:	55                   	push   %ebp
  802775:	57                   	push   %edi
  802776:	56                   	push   %esi
  802777:	53                   	push   %ebx
  802778:	83 ec 1c             	sub    $0x1c,%esp
  80277b:	8b 44 24 30          	mov    0x30(%esp),%eax
  80277f:	8b 54 24 34          	mov    0x34(%esp),%edx
  802783:	8b 74 24 38          	mov    0x38(%esp),%esi
  802787:	8b 7c 24 3c          	mov    0x3c(%esp),%edi
  80278b:	89 f9                	mov    %edi,%ecx
  80278d:	85 d2                	test   %edx,%edx
  80278f:	0f 88 bb 00 00 00    	js     802850 <__divdi3+0xdc>
  802795:	31 ed                	xor    %ebp,%ebp
  802797:	85 c9                	test   %ecx,%ecx
  802799:	0f 88 99 00 00 00    	js     802838 <__divdi3+0xc4>
  80279f:	89 34 24             	mov    %esi,(%esp)
  8027a2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8027a6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8027aa:	89 d3                	mov    %edx,%ebx
  8027ac:	8b 34 24             	mov    (%esp),%esi
  8027af:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8027b3:	89 74 24 08          	mov    %esi,0x8(%esp)
  8027b7:	8b 34 24             	mov    (%esp),%esi
  8027ba:	89 c1                	mov    %eax,%ecx
  8027bc:	85 ff                	test   %edi,%edi
  8027be:	75 10                	jne    8027d0 <__divdi3+0x5c>
  8027c0:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8027c4:	39 d7                	cmp    %edx,%edi
  8027c6:	76 4c                	jbe    802814 <__divdi3+0xa0>
  8027c8:	f7 f7                	div    %edi
  8027ca:	89 c1                	mov    %eax,%ecx
  8027cc:	31 f6                	xor    %esi,%esi
  8027ce:	eb 08                	jmp    8027d8 <__divdi3+0x64>
  8027d0:	39 d7                	cmp    %edx,%edi
  8027d2:	76 1c                	jbe    8027f0 <__divdi3+0x7c>
  8027d4:	31 f6                	xor    %esi,%esi
  8027d6:	31 c9                	xor    %ecx,%ecx
  8027d8:	89 c8                	mov    %ecx,%eax
  8027da:	89 f2                	mov    %esi,%edx
  8027dc:	85 ed                	test   %ebp,%ebp
  8027de:	74 07                	je     8027e7 <__divdi3+0x73>
  8027e0:	f7 d8                	neg    %eax
  8027e2:	83 d2 00             	adc    $0x0,%edx
  8027e5:	f7 da                	neg    %edx
  8027e7:	83 c4 1c             	add    $0x1c,%esp
  8027ea:	5b                   	pop    %ebx
  8027eb:	5e                   	pop    %esi
  8027ec:	5f                   	pop    %edi
  8027ed:	5d                   	pop    %ebp
  8027ee:	c3                   	ret    
  8027ef:	90                   	nop
  8027f0:	0f bd f7             	bsr    %edi,%esi
  8027f3:	83 f6 1f             	xor    $0x1f,%esi
  8027f6:	75 6c                	jne    802864 <__divdi3+0xf0>
  8027f8:	39 d7                	cmp    %edx,%edi
  8027fa:	72 0e                	jb     80280a <__divdi3+0x96>
  8027fc:	8b 7c 24 0c          	mov    0xc(%esp),%edi
  802800:	39 7c 24 08          	cmp    %edi,0x8(%esp)
  802804:	0f 87 ca 00 00 00    	ja     8028d4 <__divdi3+0x160>
  80280a:	b9 01 00 00 00       	mov    $0x1,%ecx
  80280f:	eb c7                	jmp    8027d8 <__divdi3+0x64>
  802811:	8d 76 00             	lea    0x0(%esi),%esi
  802814:	85 f6                	test   %esi,%esi
  802816:	75 0b                	jne    802823 <__divdi3+0xaf>
  802818:	b8 01 00 00 00       	mov    $0x1,%eax
  80281d:	31 d2                	xor    %edx,%edx
  80281f:	f7 f6                	div    %esi
  802821:	89 c6                	mov    %eax,%esi
  802823:	31 d2                	xor    %edx,%edx
  802825:	89 d8                	mov    %ebx,%eax
  802827:	f7 f6                	div    %esi
  802829:	89 c7                	mov    %eax,%edi
  80282b:	89 c8                	mov    %ecx,%eax
  80282d:	f7 f6                	div    %esi
  80282f:	89 c1                	mov    %eax,%ecx
  802831:	89 fe                	mov    %edi,%esi
  802833:	eb a3                	jmp    8027d8 <__divdi3+0x64>
  802835:	8d 76 00             	lea    0x0(%esi),%esi
  802838:	f7 d5                	not    %ebp
  80283a:	f7 de                	neg    %esi
  80283c:	83 d7 00             	adc    $0x0,%edi
  80283f:	f7 df                	neg    %edi
  802841:	89 34 24             	mov    %esi,(%esp)
  802844:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802848:	e9 59 ff ff ff       	jmp    8027a6 <__divdi3+0x32>
  80284d:	8d 76 00             	lea    0x0(%esi),%esi
  802850:	f7 d8                	neg    %eax
  802852:	83 d2 00             	adc    $0x0,%edx
  802855:	f7 da                	neg    %edx
  802857:	bd ff ff ff ff       	mov    $0xffffffff,%ebp
  80285c:	e9 36 ff ff ff       	jmp    802797 <__divdi3+0x23>
  802861:	8d 76 00             	lea    0x0(%esi),%esi
  802864:	b8 20 00 00 00       	mov    $0x20,%eax
  802869:	29 f0                	sub    %esi,%eax
  80286b:	89 f1                	mov    %esi,%ecx
  80286d:	d3 e7                	shl    %cl,%edi
  80286f:	8b 54 24 08          	mov    0x8(%esp),%edx
  802873:	88 c1                	mov    %al,%cl
  802875:	d3 ea                	shr    %cl,%edx
  802877:	89 d1                	mov    %edx,%ecx
  802879:	09 f9                	or     %edi,%ecx
  80287b:	89 0c 24             	mov    %ecx,(%esp)
  80287e:	8b 54 24 08          	mov    0x8(%esp),%edx
  802882:	89 f1                	mov    %esi,%ecx
  802884:	d3 e2                	shl    %cl,%edx
  802886:	89 54 24 08          	mov    %edx,0x8(%esp)
  80288a:	89 df                	mov    %ebx,%edi
  80288c:	88 c1                	mov    %al,%cl
  80288e:	d3 ef                	shr    %cl,%edi
  802890:	89 f1                	mov    %esi,%ecx
  802892:	d3 e3                	shl    %cl,%ebx
  802894:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802898:	88 c1                	mov    %al,%cl
  80289a:	d3 ea                	shr    %cl,%edx
  80289c:	09 d3                	or     %edx,%ebx
  80289e:	89 d8                	mov    %ebx,%eax
  8028a0:	89 fa                	mov    %edi,%edx
  8028a2:	f7 34 24             	divl   (%esp)
  8028a5:	89 d1                	mov    %edx,%ecx
  8028a7:	89 c3                	mov    %eax,%ebx
  8028a9:	f7 64 24 08          	mull   0x8(%esp)
  8028ad:	39 d1                	cmp    %edx,%ecx
  8028af:	72 17                	jb     8028c8 <__divdi3+0x154>
  8028b1:	74 09                	je     8028bc <__divdi3+0x148>
  8028b3:	89 d9                	mov    %ebx,%ecx
  8028b5:	31 f6                	xor    %esi,%esi
  8028b7:	e9 1c ff ff ff       	jmp    8027d8 <__divdi3+0x64>
  8028bc:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8028c0:	89 f1                	mov    %esi,%ecx
  8028c2:	d3 e2                	shl    %cl,%edx
  8028c4:	39 c2                	cmp    %eax,%edx
  8028c6:	73 eb                	jae    8028b3 <__divdi3+0x13f>
  8028c8:	8d 4b ff             	lea    -0x1(%ebx),%ecx
  8028cb:	31 f6                	xor    %esi,%esi
  8028cd:	e9 06 ff ff ff       	jmp    8027d8 <__divdi3+0x64>
  8028d2:	66 90                	xchg   %ax,%ax
  8028d4:	31 c9                	xor    %ecx,%ecx
  8028d6:	e9 fd fe ff ff       	jmp    8027d8 <__divdi3+0x64>
  8028db:	90                   	nop

008028dc <__udivdi3>:
  8028dc:	55                   	push   %ebp
  8028dd:	57                   	push   %edi
  8028de:	56                   	push   %esi
  8028df:	53                   	push   %ebx
  8028e0:	83 ec 1c             	sub    $0x1c,%esp
  8028e3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8028e7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8028eb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8028ef:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8028f3:	89 ca                	mov    %ecx,%edx
  8028f5:	89 f8                	mov    %edi,%eax
  8028f7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8028fb:	85 f6                	test   %esi,%esi
  8028fd:	75 2d                	jne    80292c <__udivdi3+0x50>
  8028ff:	39 cf                	cmp    %ecx,%edi
  802901:	77 65                	ja     802968 <__udivdi3+0x8c>
  802903:	89 fd                	mov    %edi,%ebp
  802905:	85 ff                	test   %edi,%edi
  802907:	75 0b                	jne    802914 <__udivdi3+0x38>
  802909:	b8 01 00 00 00       	mov    $0x1,%eax
  80290e:	31 d2                	xor    %edx,%edx
  802910:	f7 f7                	div    %edi
  802912:	89 c5                	mov    %eax,%ebp
  802914:	31 d2                	xor    %edx,%edx
  802916:	89 c8                	mov    %ecx,%eax
  802918:	f7 f5                	div    %ebp
  80291a:	89 c1                	mov    %eax,%ecx
  80291c:	89 d8                	mov    %ebx,%eax
  80291e:	f7 f5                	div    %ebp
  802920:	89 cf                	mov    %ecx,%edi
  802922:	89 fa                	mov    %edi,%edx
  802924:	83 c4 1c             	add    $0x1c,%esp
  802927:	5b                   	pop    %ebx
  802928:	5e                   	pop    %esi
  802929:	5f                   	pop    %edi
  80292a:	5d                   	pop    %ebp
  80292b:	c3                   	ret    
  80292c:	39 ce                	cmp    %ecx,%esi
  80292e:	77 28                	ja     802958 <__udivdi3+0x7c>
  802930:	0f bd fe             	bsr    %esi,%edi
  802933:	83 f7 1f             	xor    $0x1f,%edi
  802936:	75 40                	jne    802978 <__udivdi3+0x9c>
  802938:	39 ce                	cmp    %ecx,%esi
  80293a:	72 0a                	jb     802946 <__udivdi3+0x6a>
  80293c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802940:	0f 87 9e 00 00 00    	ja     8029e4 <__udivdi3+0x108>
  802946:	b8 01 00 00 00       	mov    $0x1,%eax
  80294b:	89 fa                	mov    %edi,%edx
  80294d:	83 c4 1c             	add    $0x1c,%esp
  802950:	5b                   	pop    %ebx
  802951:	5e                   	pop    %esi
  802952:	5f                   	pop    %edi
  802953:	5d                   	pop    %ebp
  802954:	c3                   	ret    
  802955:	8d 76 00             	lea    0x0(%esi),%esi
  802958:	31 ff                	xor    %edi,%edi
  80295a:	31 c0                	xor    %eax,%eax
  80295c:	89 fa                	mov    %edi,%edx
  80295e:	83 c4 1c             	add    $0x1c,%esp
  802961:	5b                   	pop    %ebx
  802962:	5e                   	pop    %esi
  802963:	5f                   	pop    %edi
  802964:	5d                   	pop    %ebp
  802965:	c3                   	ret    
  802966:	66 90                	xchg   %ax,%ax
  802968:	89 d8                	mov    %ebx,%eax
  80296a:	f7 f7                	div    %edi
  80296c:	31 ff                	xor    %edi,%edi
  80296e:	89 fa                	mov    %edi,%edx
  802970:	83 c4 1c             	add    $0x1c,%esp
  802973:	5b                   	pop    %ebx
  802974:	5e                   	pop    %esi
  802975:	5f                   	pop    %edi
  802976:	5d                   	pop    %ebp
  802977:	c3                   	ret    
  802978:	bd 20 00 00 00       	mov    $0x20,%ebp
  80297d:	89 eb                	mov    %ebp,%ebx
  80297f:	29 fb                	sub    %edi,%ebx
  802981:	89 f9                	mov    %edi,%ecx
  802983:	d3 e6                	shl    %cl,%esi
  802985:	89 c5                	mov    %eax,%ebp
  802987:	88 d9                	mov    %bl,%cl
  802989:	d3 ed                	shr    %cl,%ebp
  80298b:	89 e9                	mov    %ebp,%ecx
  80298d:	09 f1                	or     %esi,%ecx
  80298f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802993:	89 f9                	mov    %edi,%ecx
  802995:	d3 e0                	shl    %cl,%eax
  802997:	89 c5                	mov    %eax,%ebp
  802999:	89 d6                	mov    %edx,%esi
  80299b:	88 d9                	mov    %bl,%cl
  80299d:	d3 ee                	shr    %cl,%esi
  80299f:	89 f9                	mov    %edi,%ecx
  8029a1:	d3 e2                	shl    %cl,%edx
  8029a3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8029a7:	88 d9                	mov    %bl,%cl
  8029a9:	d3 e8                	shr    %cl,%eax
  8029ab:	09 c2                	or     %eax,%edx
  8029ad:	89 d0                	mov    %edx,%eax
  8029af:	89 f2                	mov    %esi,%edx
  8029b1:	f7 74 24 0c          	divl   0xc(%esp)
  8029b5:	89 d6                	mov    %edx,%esi
  8029b7:	89 c3                	mov    %eax,%ebx
  8029b9:	f7 e5                	mul    %ebp
  8029bb:	39 d6                	cmp    %edx,%esi
  8029bd:	72 19                	jb     8029d8 <__udivdi3+0xfc>
  8029bf:	74 0b                	je     8029cc <__udivdi3+0xf0>
  8029c1:	89 d8                	mov    %ebx,%eax
  8029c3:	31 ff                	xor    %edi,%edi
  8029c5:	e9 58 ff ff ff       	jmp    802922 <__udivdi3+0x46>
  8029ca:	66 90                	xchg   %ax,%ax
  8029cc:	8b 54 24 08          	mov    0x8(%esp),%edx
  8029d0:	89 f9                	mov    %edi,%ecx
  8029d2:	d3 e2                	shl    %cl,%edx
  8029d4:	39 c2                	cmp    %eax,%edx
  8029d6:	73 e9                	jae    8029c1 <__udivdi3+0xe5>
  8029d8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8029db:	31 ff                	xor    %edi,%edi
  8029dd:	e9 40 ff ff ff       	jmp    802922 <__udivdi3+0x46>
  8029e2:	66 90                	xchg   %ax,%ax
  8029e4:	31 c0                	xor    %eax,%eax
  8029e6:	e9 37 ff ff ff       	jmp    802922 <__udivdi3+0x46>
  8029eb:	90                   	nop

008029ec <__umoddi3>:
  8029ec:	55                   	push   %ebp
  8029ed:	57                   	push   %edi
  8029ee:	56                   	push   %esi
  8029ef:	53                   	push   %ebx
  8029f0:	83 ec 1c             	sub    $0x1c,%esp
  8029f3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8029f7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8029fb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8029ff:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802a03:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802a07:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a0b:	89 f3                	mov    %esi,%ebx
  802a0d:	89 fa                	mov    %edi,%edx
  802a0f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802a13:	89 34 24             	mov    %esi,(%esp)
  802a16:	85 c0                	test   %eax,%eax
  802a18:	75 1a                	jne    802a34 <__umoddi3+0x48>
  802a1a:	39 f7                	cmp    %esi,%edi
  802a1c:	0f 86 a2 00 00 00    	jbe    802ac4 <__umoddi3+0xd8>
  802a22:	89 c8                	mov    %ecx,%eax
  802a24:	89 f2                	mov    %esi,%edx
  802a26:	f7 f7                	div    %edi
  802a28:	89 d0                	mov    %edx,%eax
  802a2a:	31 d2                	xor    %edx,%edx
  802a2c:	83 c4 1c             	add    $0x1c,%esp
  802a2f:	5b                   	pop    %ebx
  802a30:	5e                   	pop    %esi
  802a31:	5f                   	pop    %edi
  802a32:	5d                   	pop    %ebp
  802a33:	c3                   	ret    
  802a34:	39 f0                	cmp    %esi,%eax
  802a36:	0f 87 ac 00 00 00    	ja     802ae8 <__umoddi3+0xfc>
  802a3c:	0f bd e8             	bsr    %eax,%ebp
  802a3f:	83 f5 1f             	xor    $0x1f,%ebp
  802a42:	0f 84 ac 00 00 00    	je     802af4 <__umoddi3+0x108>
  802a48:	bf 20 00 00 00       	mov    $0x20,%edi
  802a4d:	29 ef                	sub    %ebp,%edi
  802a4f:	89 fe                	mov    %edi,%esi
  802a51:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802a55:	89 e9                	mov    %ebp,%ecx
  802a57:	d3 e0                	shl    %cl,%eax
  802a59:	89 d7                	mov    %edx,%edi
  802a5b:	89 f1                	mov    %esi,%ecx
  802a5d:	d3 ef                	shr    %cl,%edi
  802a5f:	09 c7                	or     %eax,%edi
  802a61:	89 e9                	mov    %ebp,%ecx
  802a63:	d3 e2                	shl    %cl,%edx
  802a65:	89 14 24             	mov    %edx,(%esp)
  802a68:	89 d8                	mov    %ebx,%eax
  802a6a:	d3 e0                	shl    %cl,%eax
  802a6c:	89 c2                	mov    %eax,%edx
  802a6e:	8b 44 24 08          	mov    0x8(%esp),%eax
  802a72:	d3 e0                	shl    %cl,%eax
  802a74:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a78:	8b 44 24 08          	mov    0x8(%esp),%eax
  802a7c:	89 f1                	mov    %esi,%ecx
  802a7e:	d3 e8                	shr    %cl,%eax
  802a80:	09 d0                	or     %edx,%eax
  802a82:	d3 eb                	shr    %cl,%ebx
  802a84:	89 da                	mov    %ebx,%edx
  802a86:	f7 f7                	div    %edi
  802a88:	89 d3                	mov    %edx,%ebx
  802a8a:	f7 24 24             	mull   (%esp)
  802a8d:	89 c6                	mov    %eax,%esi
  802a8f:	89 d1                	mov    %edx,%ecx
  802a91:	39 d3                	cmp    %edx,%ebx
  802a93:	0f 82 87 00 00 00    	jb     802b20 <__umoddi3+0x134>
  802a99:	0f 84 91 00 00 00    	je     802b30 <__umoddi3+0x144>
  802a9f:	8b 54 24 04          	mov    0x4(%esp),%edx
  802aa3:	29 f2                	sub    %esi,%edx
  802aa5:	19 cb                	sbb    %ecx,%ebx
  802aa7:	89 d8                	mov    %ebx,%eax
  802aa9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802aad:	d3 e0                	shl    %cl,%eax
  802aaf:	89 e9                	mov    %ebp,%ecx
  802ab1:	d3 ea                	shr    %cl,%edx
  802ab3:	09 d0                	or     %edx,%eax
  802ab5:	89 e9                	mov    %ebp,%ecx
  802ab7:	d3 eb                	shr    %cl,%ebx
  802ab9:	89 da                	mov    %ebx,%edx
  802abb:	83 c4 1c             	add    $0x1c,%esp
  802abe:	5b                   	pop    %ebx
  802abf:	5e                   	pop    %esi
  802ac0:	5f                   	pop    %edi
  802ac1:	5d                   	pop    %ebp
  802ac2:	c3                   	ret    
  802ac3:	90                   	nop
  802ac4:	89 fd                	mov    %edi,%ebp
  802ac6:	85 ff                	test   %edi,%edi
  802ac8:	75 0b                	jne    802ad5 <__umoddi3+0xe9>
  802aca:	b8 01 00 00 00       	mov    $0x1,%eax
  802acf:	31 d2                	xor    %edx,%edx
  802ad1:	f7 f7                	div    %edi
  802ad3:	89 c5                	mov    %eax,%ebp
  802ad5:	89 f0                	mov    %esi,%eax
  802ad7:	31 d2                	xor    %edx,%edx
  802ad9:	f7 f5                	div    %ebp
  802adb:	89 c8                	mov    %ecx,%eax
  802add:	f7 f5                	div    %ebp
  802adf:	89 d0                	mov    %edx,%eax
  802ae1:	e9 44 ff ff ff       	jmp    802a2a <__umoddi3+0x3e>
  802ae6:	66 90                	xchg   %ax,%ax
  802ae8:	89 c8                	mov    %ecx,%eax
  802aea:	89 f2                	mov    %esi,%edx
  802aec:	83 c4 1c             	add    $0x1c,%esp
  802aef:	5b                   	pop    %ebx
  802af0:	5e                   	pop    %esi
  802af1:	5f                   	pop    %edi
  802af2:	5d                   	pop    %ebp
  802af3:	c3                   	ret    
  802af4:	3b 04 24             	cmp    (%esp),%eax
  802af7:	72 06                	jb     802aff <__umoddi3+0x113>
  802af9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802afd:	77 0f                	ja     802b0e <__umoddi3+0x122>
  802aff:	89 f2                	mov    %esi,%edx
  802b01:	29 f9                	sub    %edi,%ecx
  802b03:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802b07:	89 14 24             	mov    %edx,(%esp)
  802b0a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802b0e:	8b 44 24 04          	mov    0x4(%esp),%eax
  802b12:	8b 14 24             	mov    (%esp),%edx
  802b15:	83 c4 1c             	add    $0x1c,%esp
  802b18:	5b                   	pop    %ebx
  802b19:	5e                   	pop    %esi
  802b1a:	5f                   	pop    %edi
  802b1b:	5d                   	pop    %ebp
  802b1c:	c3                   	ret    
  802b1d:	8d 76 00             	lea    0x0(%esi),%esi
  802b20:	2b 04 24             	sub    (%esp),%eax
  802b23:	19 fa                	sbb    %edi,%edx
  802b25:	89 d1                	mov    %edx,%ecx
  802b27:	89 c6                	mov    %eax,%esi
  802b29:	e9 71 ff ff ff       	jmp    802a9f <__umoddi3+0xb3>
  802b2e:	66 90                	xchg   %ax,%ax
  802b30:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802b34:	72 ea                	jb     802b20 <__umoddi3+0x134>
  802b36:	89 d9                	mov    %ebx,%ecx
  802b38:	e9 62 ff ff ff       	jmp    802a9f <__umoddi3+0xb3>
